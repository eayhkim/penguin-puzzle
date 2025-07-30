-->8
-- >>> quest.lua <<<
-- quests --
quest_templates = {
    find_fish = {
        id = "find_fish",
        base_text = "I lost my fish somehow... if you find it, I'll give you a snack",
        condition = function(q) return is_fish_found() end,
        on_complete = function(q) reward_fish_quest(q) end,
    },
    tip_iceberg = {
        id = "tip_iceberg",
        base_text = "we need more penguins to tip the iceberg! convince some friends to join",
        condition = function(q) return is_enough_penguins() end,
        on_complete = function(q) tip_iceberg(q) end,
    },
    defeat_sharks = {
        id = "defeat_sharks",
        base_text = "there are sharks in the water!! chase them off or distract them!",
        condition = function(q) return is_shark_defeated() end,
        on_complete = function(q) reward_shark_defense(q) end,
    },
    throw_snowballs = {
        id = "throw_snowballs",
        base_text = "go cause a little chaos! throw 10 snowballs",
        condition = function(q) return is_snowball_quota() end,
        on_complete = function(q) reward_snowball_chaos(q) end,
    },
    find_penguin = {
        id = "find_penguin",
        base_text = "my friend is missing.. last seen near the sharks. can you check?",
        condition = function(q) return is_penguin_found() end,
        on_complete = function(q) reunite_penguins(q) end,
    }
}

-- populate from quest templates for NPC
function create_quest(npc_ref)
    local quest_id = npc_ref.dialogue_state.curr
	local template = quest_templates[quest_id]

	local quest = {
		id = template.id,
		npc_ref = npc_ref,
		is_complete = false,
		progress = {},
		text = template.base_text .. " (" .. npc_ref.name .. ")",
		condition = function() return template.condition(quest) end,
		on_complete = function() template.on_complete(quest) end
	}

    npc_ref.quest = quest

    add(active_quests, quest)
	return quest
end


