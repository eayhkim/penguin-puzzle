-->8
-- update / states --

function u_walking_around()
	p_move()
	npcs_move()
	sharks_move()

	closest = get_nearest_npc()

	if btnp(🅾️) then
		statex = "talking"
	else

	end

	if btnp(❎) then
		npcs[npc_index].is_unlocked = true
		npcs[npc_index].state = "move"
		npc_index += 1
		trigger_shake()
	end
end


function u_dialogue()
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


