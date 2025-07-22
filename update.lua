-->8
-- >>> update.lua <<<
-- update / states --
function u_walking_around()
	p_move()
	npcs_move()
	sharks_move()
	snowball_move()

	nearest_search = get_nearest_interactable()
	closest = nearest_search[1]
	closest_type = nearest_search[2]
	if closest != "none" then
		if btnp(🅾️) then
			if closest_type == "npc" then
				state = "talking"
				_upd = u_dialogue
				_drw = d_dialogue
			elseif closest_type == "snowball" then
				closest.state = "held"
				_upd = u_snowball_throw
				p.held_item = closest
			end
		end
	end

	if btnp(❎) then
		npcs[npc_index].is_unlocked = true
		npcs[npc_index].state = "move"
		npc_index += 1
		trigger_shake()
	end
end

function u_snowball_throw()
	p_move()
	npcs_move()
	sharks_move()
	snowball_move()

	if btnp(🅾️) then
		if p.face_right then
			p.held_item.dx = 2
		else
			p.held_item.dx = - 2
		end
		p.held_item.dy = -1
		p.held_item.state = "floor"
		_upd = u_walking_around
	end
end

function u_dialogue()
	if closest.dialogue_state then 
		start_convo(closest)
	end

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