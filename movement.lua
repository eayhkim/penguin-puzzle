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


function get_nearest_interactable()
	local min_dist = 32000
	local closest_type = ""

	for i = 1, npc_count do 
		curr_dist = dst(p, npcs[i])
		min_dist = min(min_dist, curr_dist)

		if min_dist == curr_dist do 
			closest = npcs[i]
			closest_type = "npc"
		end
	end
	for snowball in all(snowballs) do
		curr_dist = dst(p, snowball)
		min_dist = min(min_dist, curr_dist)

		if min_dist == curr_dist do 
			closest = snowball
			closest_type = "snowball"
		end
	end
	if min_dist > talk_range then
		closest = "none"
		closest_type = ""
	end

	return {closest, closest_type}
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

function snowball_move()
	for snowball in all(snowballs) do
		if snowball.state == "held" then
			snowball.x = p.x + 4
			snowball.y = p.y + 2
		else 
			snowball.x += snowball.dx
			snowball.y += snowball.dy

			snowball.dx *= 0.95
			-- friction/gravity applies over time
			if abs(snowball.dx) < 0.2 then
				snowball.dx = 0
				snowball.dy = 0
			else
				snowball.dy += 0.2
				if snowball.dy >=  0.5 then
					snowball.dy = 0
				end
			end
		end
	end
end