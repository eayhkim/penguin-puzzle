-->8
-- >>> dialogue.lua <<<
-- npc dialogue --
npc_dialogues = {
    greetings = {
        {
            text = "hey there, cool flippers!",
            responses = {
                { text = "thanks! so what's up?", next = "get_quest" },
                { text = "not interested", next = "end" }
            }
        },
        {
            text = "move it, i'm waddling here!",
            responses = {
                { text = "uhh where are you going?", next = "get_quest" },
                { text = "so am i! outta the way!", next = "end" }
            }
        },
        {
            text = "hey you're new! wanna talk?",
            responses = {
                { text = "sure", next = "get_quest" },
                { text = "nope, i'm good", next = "end" }
            }
        },
    },
    quests = {
        {
            text = "have you seen my fish?",
            responses = {
                { text = "what fish?", next = "find_fish" },
                { text = "sorry buddy, good luck", next = "end" }
            }
        },
        {
            text = "iceberg's gonna tip lol.",
            responses = {
                { text = "lol i'll get my hard hat", next = "tip_iceberg" },
                { text = "you're delusional", next = "end" }
            }
        },
        {
            text = "you see those sharks too right...",
            responses = {
                { text = "yeah, but i'm not worried", next = "defeat_sharks" },
                { text = "yep, and i'm staying far away", next = "end" }
            }
        },
        {
            text = "wanna cause some chaos?",
            responses = {
                { text = "i live for this", next = "throw_snowballs" },
                { text = "no way. my ban just lifted!", next = "end" }
            }
        },
        {
            text = "i could really use a wing here...",
            responses = {
                { text = "sure thing", next = "find_penguin" },
                { text = "sorry, i'm busy", next = "end" }
            }
        },
    }
}


function start_convo(peng)
    local d = peng.dialogue_state

    if not d.next then
        get_response(peng)
        return
    end

    if d.stage == "greeting" and d.next == "get_quest" then 
        d.stage = "quest"
        d.curr = rnd(npc_dialogues.quests)

    elseif d.next == "end" then
        peng.dialogue_state = nil

    else -- on quest stage
        d.stage = "end"
        -- trigger_quest(n, peng) 
    end

    -- reset to avoid repeating on next advance
    d.selected_idx = nil
    d.next = nil
end


function get_response(peng)
    local d = peng.dialogue_state
    local responses = d.curr.responses

    -- initialize d.selected if not set yet
    if not d.selected_idx then
        d.selected_idx = 1
    end

    -- navigate choices
    if btnp(⬆️) then 
        d.selected_idx = max(1, d.selected_idx - 1)
    elseif btnp(⬇️) then 
        d.selected_idx = min(#responses, d.selected_idx + 1)
    end

    -- confirm selection
    if btnp(❎) then 
        local choice = responses[d.selected_idx]
        d.next = choice.next
    end
end