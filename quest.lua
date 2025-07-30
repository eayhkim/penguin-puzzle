-->8
-- >>> quest.lua <<<
-- quests --
function trigger_quest(peng) 
    local quest = peng.dialogue_state.curr

    if quest == "find_fish" then
        draw_big_penguin(peng)
    elseif quest == "tip_iceberg" then
        draw_big_penguin(peng)
    elseif quest == "defeat_sharks" then
        draw_big_penguin(peng)
    elseif quest == "throw_snowballs" then
        draw_big_penguin(peng)
    elseif quest == "find_penguin" then
        draw_big_penguin(peng)
    end
end


