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
		"cool meeting you. party at my iggy!",
		"so anyways, we need more penguins to tip the iceberg",
		"ok well... you've been banned from club penguin"
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
		dialogue_state = {
			stage = "greeting",
			curr = rnd(npc_dialogues.greetings),
			selected_idx = nil,
			next = nil
		},
		quest_state = nil,
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