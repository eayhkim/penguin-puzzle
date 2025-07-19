-->8
-- >>> dialogues.lua <<<
-- npc dialogues --
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
    get_response(peng)

    local d = peng.dialogue_state

    if d.selected then
        -- reset to avoid repeating on next advance
        d.selected = nil

        if d.stage == "greeting" and d.selected == "get_quest" then 
            d.stage = "quest"
            d.curr = rnd(npc_dialogues.quests)

        elseif d.selected == "end" then
            end_convo()

        else -- on quest stage
            -- trigger_quest(n, peng) 
            end_convo()
        end
    end
end


function end_convo(peng)
    if peng then
        peng.dialogue_state = nil
    end
end


function get_response(peng)
    local d = peng.dialogue_state
    local responses = d.curr.responses

    -- navigate choices
    if btnp(⬆️) then 
        d.selected_index = max(1, d.selected_index - 1)
    elseif btnp(⬇️) then 
        d.selected_index = min(#responses, d.selected_index + 1)
    end

    -- confirm selection
    if btnp(❎) then 
        local choice = responses[d.selected_index]
        d.selected = choice.next
    end
end
