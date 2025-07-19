pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-->8
-- >>> drawing.lua <<<
-- drawing functions --
function d_walking_around()
	-- ui animation timer
	ui_anim_timer += 1
	if ui_anim_timer >= ui_anim_speed then
		ui_anim_timer = 0
		ui_offset = (ui_offset + 1) % 2
	end
	
	cls()
	map()
	draw_penguins()
 	draw_sharks()

	if closest != "none" then
		draw_talk_hint()
	end
end


function d_dialogue()
	-- ui animation timer
	ui_anim_timer += 1
	if ui_anim_timer >= ui_anim_speed then
		ui_anim_timer = 0
		ui_offset = (ui_offset + 1) % 2
	end
	
	cls()
	map()
	draw_penguins()
 	draw_sharks()
 
 	draw_textbox(closest)
	draw_big_penguin(closest)
	
	print("🅾️ to exit", 85, 2 + ui_offset, 7)
end


function d_end_game()
	cls()
	print("you tipped the iceberg!", 30, 30, 7)
end


function draw_penguins()
	-- layers sprite drawing based on y position
	p_drawn = false

	for i = 1, npc_count do
		if npcs[i].y > p.y and not p_drawn then
			//spr(p.sprite, p.x, p.y)
			anim_peng(p)
			p_drawn = true
		end
		//spr(npcs[i].sprite, npcs[i].x, npcs[i].y)
		anim_peng(npcs[i])
	end

	if not p_drawn then
		//spr(p.sprite, p.x, p.y)
		anim_peng(p)
	end
end


function draw_talk_hint()
	local x = closest.x
	local y = closest.y - 10 + ui_offset
	
	spr(36, x, y)
end


function draw_sharks()
    for shark in all(sharks) do
        spr(shark.sprite, shark.x, shark.y, 1, 1, shark.flip, false)
    end
end


function anim_peng(peng)
	if peng.state == "still" then
			spr(peng.spr_frames[1], peng.x, peng.y, 1,1,peng.face_right)
	else
		peng.anim_timer += 1
		if peng.anim_timer >= peng.anim_speed then
			peng.anim_index = (peng.anim_index + 1) % 2
			peng.anim_timer = 0
		end
		
		spr(peng.spr_frames[peng.anim_index+1], peng.x, peng.y, 1,1,peng.face_right)
	end
end


function screen_shake()
	local grow = 1.05
	local offset_x = 4 - rnd(8)
	local offset_y = 4 - rnd(8)
	
	offset_x *= offset
	offset_y *= offset
	
	camera(offset_x,offset_y)
	
	offset *= grow
	
	if offset >= 20 then
		_upd = u_end_game
		_drw = d_end_game
	end
end


-- params: text, rect box coords (x0, y0, x1, y1), color
function draw_center_txt_rect(t, x0, y0, x1, y1, c)
    local w = x1 - x0 + 2
    local h = y1 - y0 + 2
    local pad = 4  -- pixel padding inside box

    local lines = wrap_txt(t, w - pad*2, h - pad*2)
    local sy = y0 + pad + (h - pad*2 - #lines * 8) \ 2

    for i, line in ipairs(lines) do
        local px = x0 + pad + (w - pad*2 - #line * 4) \ 2
        print(line, px, sy + (i - 1) * 8, c)
    end
end


function draw_textbox(peng)
	-- dithering background
	fillp(▒)
	rectfill(0, 128, 128, 108, 6)
	
	fillp(░)
	rectfill(0,108, 128, 88,6)
	
	fillp(☉)
	rectfill(0,88, 128, 68,6)
	
	fillp(…)
	rectfill(0,68, 128, 48,6)

	fillp(⬅️)
	-- generate rectangle (0 == index of black color)
	rectfill(60, 20, 120, 90, 0)
	rectfill(62, 22, 118, 88, 7)
	rectfill(66, 26, 114, 84, 6)

	-- local hello_name = peng.name .. " says hello! :D"
	-- draw_center_txt_rect(hello_name, 66, 26, 114, 84, 1)

	draw_center_txt_rect(peng.message, 66, 26, 114, 84, 1)
end	


function draw_big_penguin(peng)
	-- identify sprite location in grid, then scale size
	local sx = (peng.spr_frames[1] % 16) * 8
	local sy = (peng.spr_frames[1] \ 16) * 8	
	sspr(sx, sy, 8, 8, -10, 60, 96, 96, true, false)
end


-->8
-- >>> init.lua <<<
-- init / setup --
function _init()
	-- setting map transparency
	palt(0, false)
	palt(15, true)

	-- set flags on sprites 
	fset(62, 1, true) -- 62 (light blue water)

	p = {
		x = 50,
		y = 50, 
		sprite = 1,
		spr_frames = {1, 2},
		anim_index = 0,
		anim_timer = 0,
		anim_speed = 8,
		state = "still",
		face_right = false,
		speed = 2
	}

	npcs = {}
	npc_index = 1
	npc_count = 10

	npc_names = {"joe", "bob", "mary", "jane"}
	npc_colors = {3, 4, 5, 6, 7, 8, 9, 10}
	npc_messages = {
		"party at my iggy!",
		"we just need one more penguin to tip the iceberg!",
		"you have been banned from club penguin"
	}

	for i = 1, npc_count do
		create_npc(i, rnd(npc_colors), rnd(npc_names), 16 + rnd(80), 35 + 4 * i)
	end

	-- give sharks starting target to swim to
	sharks = {
		{
			x = 7, y = 100, 
			target_x = 7, target_y = 100, 
			speed = 0.4, 
			sprite = 17, flip = false
		},
		{
			x = 118, y = 45, 
			target_x = 118, target_y = 45, 
			speed = 0.2, 
			sprite = 17, flip = false
		}
	}

	statex = "walking"
	closest = npcs[0]
	talk_range = 6

	_upd = u_walking_around
	_drw = d_walking_around
	offset = 0
	
	-- universal animation timers for ui
	ui_anim_timer = 0
	ui_anim_speed = 12
	ui_offset = 0
end


function create_npc(id,sprite,name,x,y)
	local npc = {
		id = id,
		sprite = sprite,
		spr_frames = {sprite, sprite + 16},
		anim_timer = 0,
		anim_speed = 8,
		anim_index = 0,
		face_right = false,
		state = "still",
		name = name,
		x = x,
		y = y,
		dx = 1,
		dy = 1,
		target_x = 25, 
		target_y = 50,
		message = rnd(npc_messages),
		is_unlocked = false
	}

	add(npcs, npc)
end


function _update()
	_upd()
end


function _draw()
	_drw()
end


-->8
-- >>> movement.lua <<<
-- movement functions --
function on_sprite_zone(new_x, new_y, flag)
	-- reusable helper to check if coords on iceberg, on water, etc
	local tile_x = new_x / 8
	local tile_y = new_y / 8
	
	return fget(mget(tile_x,tile_y), flag)
end

function shark_fully_in_water(x, y)
	-- can adjust padding, but for now 0 seems best?
	local padding = 0 

    return on_sprite_zone(x + padding, y + padding, 1) and
           on_sprite_zone(x + 7 - padding, y + padding, 1) and
           on_sprite_zone(x + padding, y + 7 - padding, 1) and
           on_sprite_zone(x + 7 - padding, y + 7 - padding, 1)
end


function random_water_position()
	-- get new target for sharks 
    local new_x, new_y
    repeat
        new_x = flr(rnd(128))
        new_y = flr(rnd(128))
    until on_sprite_zone(new_x, new_y, 1)
    return new_x, new_y
end


function get_nearest_npc()
	local min_dist = 32000

	for i = 1, npc_count do 
		curr_dist = dst(p, npcs[i])
		min_dist = min(min_dist, curr_dist)

		if min_dist == curr_dist do 
			closest = npcs[i]
		end
	end

	if min_dist > talk_range then
		closest = "none"
	end

	return closest
end


function p_move()
	if btn() != 0 then
		p.state = "move"
		new_x = p.x
		new_y = p.y
		if btn(⬅️) then
			new_x = p.x - 1
			p.face_right = false
		end
		if btn(➡️) then
			new_x = p.x + 1
			p.face_right = true
		end
		if btn(⬆️) then
			new_y = p.y -1
		end
		if btn(⬇️) then
			new_y = p.y + 1
		end
		if on_sprite_zone(new_x + 4, new_y + 4, 0) then
			-- only update p position if on iceberg
			p.x = new_x
			p.y = new_y
		else 
			print("not on iceberg")
		end
	else
		p.state = "still"
		print("no input")
	end
end


function npcs_move()
	for i = 1, npc_count do
		if npcs[i].is_unlocked then 
			if npcs[i].x < npcs[i].target_x then 
				npcs[i].x += npcs[i].dx
			end	
			if npcs[i].x > npcs[i].target_x then 
				npcs[i].x -= npcs[i].dx
			end	
			if npcs[i].y < npcs[i].target_y then 
				npcs[i].y += npcs[i].dy
			end	
			if npcs[i].y > npcs[i].target_y then 
				npcs[i].y -= npcs[i].dy
			end	
		end
	end
end


function sharks_move()
    for shark in all(sharks) do
		-- get distance to target, swim there, then pick new one
        local dx = shark.target_x - shark.x
        local dy = shark.target_y - shark.y
        local dist = sqrt(dx * dx + dy * dy)

        if dist < 1 then
            shark.target_x, shark.target_y = random_water_position()
        else
            local vx = (dx / dist) * shark.speed
            local vy = (dy / dist) * shark.speed

            local new_x = shark.x + vx
            local new_y = shark.y + vy

            -- check full shark sprite inside water
            if shark_fully_in_water(new_x, new_y) then
                shark.x = new_x
                shark.y = new_y

                -- flip sprite if changing direction
                shark.flip = vx > 0
            else
                shark.target_x, shark.target_y = random_water_position()
            end
        end
    end
end


-->8
-- >>> update.lua <<<
-- update / states --
function u_walking_around()
	p_move()
	npcs_move()
	sharks_move()

	closest = get_nearest_npc()
	if closest != "none" then
		if btnp(🅾️) then
			state = "talking"
			_upd = u_dialogue
			_drw = d_dialogue
		end
	end

	if btnp(❎) then
		npcs[npc_index].is_unlocked = true
		npcs[npc_index].state = "move"
		npc_index += 1
		trigger_shake()
	end
end


function u_dialogue()
	if btnp(🅾️) then
		_upd = u_walking_around
		_drw = d_walking_around
	end
end


function ready_to_shake()
	for i = 1, npc_count do 
		if not npcs[i].is_unlocked then 
			return false 
		end
	end 
	return true 
end


function trigger_shake()
	if ready_to_shake() then 
		offset = 1
		_upd = u_tip_iceberg
	end
end


function u_tip_iceberg()
	screen_shake()
end


function u_end_game()
	cls()
end


-->8
-- >>> utils.lua <<<
-- helper / reusable functions --
function dst(o1, o2)
 	return sqrt(sqr(o1.x - o2.x) + sqr(o1.y - o2.y))
end


function sqr(x) 
	return x * x 
end


function wrap_txt(t, w, h)
    local lines = {}
    local line = ""
    local lw = 0
    local max = flr(h / 8)

    for word in all(split(t, " ")) do
        local ww = #word * 4
        if lw + ww <= w then
            if line != "" then
				-- str concat (..=)
                line ..= " "
                lw += 4
            end
            line ..= word
            lw += ww
        else
            add(lines, line)
            if #lines == max then return lines end
            line, lw = word, ww
        end
    end

    if line != "" and #lines < max then
        add(lines, line)
    end

    return lines
end


__gfx__
00000000ffddddfffffddddfffeeeeffff3333ffffbbbbffff1111ffffccccffffaaaaffff5555ffff4444ff6611111111116666111111117777777667777777
00000000fd777dffffd777dffe777efff37773fffb777bfff17771fffc777cfffa777afff57775fff47774ff6661111111666666111111117777767666777777
00700700fd070ddfffd070dffe070eeff307033ffb070bbff107011ffc070ccffa070aaff507055ff407044f6666666166666666166666117777777667777777
00077000f999dddfff999ddff999eeeff999333ff999bbbff999111ff999cccff999aaaff999555ff999444f6666666666666666566666617677777666777777
00077000dd777dddffd777ddee777eee33777333bb777bbb11777111cc777cccaa777aaa55777555447774446666666666666666155555117777776667777767
00700700d77777ddfd77777de77777ee37777733b77777bb17777711c77777cca77777aa57777755477777446666666656666666111166616777677667676777
00000000fd7777dffd7777ddfe7777eff377773ffb7777bff177771ffc7777cffa7777aff577775ff477774f6666665515566666111566667676767666767677
00000000f99f99ffff99f99ff99f99fff99f99fff99f99fff99f99fff99f99fff99f99fff99f99fff99f99ff5555555115555555111155516666666666666666
00000000ffffffff00000000fffeeeeffff3333ffffbbbbffff1111ffffccccffffaaaaffff5555ffff4444f000000000000000017777777cccccccc77767767
00000000ffff11ff00000000ffe777efff37773fffb777bfff17771fffc777cfffa777afff57775fff47774f000000000000000077777777cc7776cc67777677
00000000fff161ff00000000ffe070efff30703fffb070bfff10701fffc070cfffa070afff50705fff40704f000000000000000077777777c6666ccc77777776
00000000fff661ff00000000ff999eefff99933fff999bbfff99911fff999ccfff999aafff99955fff99944f000000000000000077777777cccccccc77677777
00000000ff16d11f00000000ffe777eeff377733ffb777bbf1177711fcc777ccfaa777aaf5577755f4477744000000000000000077777776ccccc77c77777777
00000000ff6d111f00000000fe77777ef3777773fb77777b11777771cc77777caa77777a5577777544777774000000000000000077777766cc77766c77777777
00000000f1d1111100000000fe7777eef3777733fb7777bbf177771ffc7777cffa7777aff577775ff477774f000000000000000066666666c66666cc77777677
00000000cc1111cc00000000ff99f99fff99f99fff99f99fff99f99fff99f99fff99f99fff99f99fff99f99f000000000000000066666666cccccccc77777777
00000000ccccccccfccccccfffffffffffffffff000000000000000000000000000000000000000000000000666666661c11111111111111cccccccc77777777
0000000000000000c777776cfcccccfff66666ff00000000000000000000000000000000000000000000000066677676111111c111111177c677cccc77777777
0000000000000000c77cc66ccc777ccf6611166f000000000000000000000000000000000000000000000000767767771111111111117777c6666ccc77777777
0000000000000000c7c77c6ccc7c7ccf6616166f000000000000000000000000000000000000000000000000776767671111c11111777777cccccccc76777777
0000000000000000c7c76c6ccc777ccf6611166f00000000000000000000000000000000000000000000000067777766c111111117777777cc777ccc77777767
0000000000000000c76cc66c1ccccc1f5666665f000000000000000000000000000000000000000000000000666665661111111117777777c666677c67776777
0000000000000000c666666cf11111fff55555ff000000000000000000000000000000000000000000000000565666661c1c111c77777666cccc666c76767676
0000000000000000fccccccfffffffffffffffff00000000000000000000000000000000000000000000000055555555c111c1c166666666cccccccc66666666
0000000000000000000000000000000000000000000000000000000000000000000000000000000077777777777777777777777711111111cccccccc77777777
0000000000000000000000000000000000000000000000000000000000000000000000000000000077766767777667677776676711111111cccccccc77777777
0000000000000000000000000000000000000000000000000000000000000000000000000000000067667665676676666766766611111111cccccccc77777777
0000000000000000000000000000000000000000000000000000000000000000000000000000000066767665567676666676766611111111cccccccc77777777
0000000000000000000000000000000000000000000000000000000000000000000000000000000066666675566666766666667611111111cccccccc77777777
0000000000000000000000000000000000000000000000000000000000000000000000000000000066666565556665666666656611111111cccccccc77777777
0000000000000000000000000000000000000000000000000000000000000000000000000000000056565655565666665656666611111111cccccccc77777777
0000000000000000000000000000000000000000000000000000000000000000000000000000000055555555555555555555555511111111cccccccc77777777
__gff__
0000000000000000000000000000010100000000000000000000000000000001000000000000000000000000000000010000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
3d3d3d3d3d0d3d3d3d3d3d3d3d3d3d3d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3d0c0b3d3d3d3d3d3d0d3d3d3d3d3d3d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3d3d3d3d3d3d3d3d3d3d3d0c0b3d3d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3d3d3d1f3f1f3d3d3d3d3d3d3d3d3d3d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2c2c1f3f3f3f3f3f1f2c2c2c2c2c2d1d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3e3e1f3f3f3f3f3f3f3f3f3f1f3e3e3e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3e1f3f3f3f3f3f3f3f3f3f3f3f1f3e3e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3e0f3f3f3f1f3f3f3f3f3f3f3f3f1f3e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3e3b3f3f3f3f3f3f3f1f3f3f3f3f3f3e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3e2e0f3f3f3f3f3f3f3f3f3f3f3f0e1e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3e3e3b0f2f3f3f1f3f3f3f2f2f0e3a3e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3e3e3e3b3c0f2f2f2f2f0e3c3c3a1e3e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3e3e2e3e2e3b3c3c3c3c3a3e1e3e3e3e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000