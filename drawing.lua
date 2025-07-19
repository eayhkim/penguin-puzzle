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
	-- generate rectangle
	rectfill(60, 20, 120, 90, 0)
	rectfill(62, 22, 118, 88, 7)
	rectfill(66, 26, 114, 84, 6)

	-- local hello_name = peng.name .. " says hello! :D"
	-- draw_center_txt_rect(hello_name, 66, 26, 114, 84, 1)

	-- draw_center_txt_rect(peng.message, 66, 26, 114, 84, 1)

	draw_center_txt_rect(peng.dialogue_state.curr.text, 66, 26, 114, 84, 1)
end	


function draw_big_penguin(peng)
	-- identify sprite location in grid, then scale size
	local sx = (peng.spr_frames[1] % 16) * 8
	local sy = (peng.spr_frames[1] \ 16) * 8	
	sspr(sx, sy, 8, 8, -10, 60, 96, 96, true, false)
end