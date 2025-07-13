-->8
-- drawing --

function d_walking_around()
	cls()
	map()
	draw_penguins()
    draw_sharks()

	if statex == "talking" then
		draw_textbox(closest)
		draw_big_penguin(closest)
	end
end


function d_end_game()
	cls()
	print("you tipped the iceberg!", 30,30, 7)
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


function draw_textbox(peng)
	-- generate rectangle (0 == index of black color)
	rectfill(60, 20, 120, 90, 0)
	rectfill(62, 22, 118, 88, 7)
	rectfill(66, 26, 114, 84, 6)

	print(peng.name, 75, 35, 1)
	print("")
	print("says") 
	print("hello!")
	print(":D")
end	


function draw_big_penguin(peng)
	-- identify sprite location in grid, then scale size
	local sx = (peng.spr_frames[1] % 16) * 8
	local sy = (peng.spr_frames[1] \ 16) * 8	
	sspr(sx, sy, 8, 8, -10, 60, 96, 96, true, false)
end


