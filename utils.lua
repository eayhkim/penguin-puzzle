-->8
-- >>> utils.lua <<<
-- helper / reusable functions --
function dst(o1, o2)
 	return sqrt(sqr(o1.x - o2.x) + sqr(o1.y - o2.y))
end


function sqr(x) 
	return x * x 
end


function wrap_txt(t, w, h)
    local lines = {}
    local line = ""
    local lw = 0
    local max = flr(h / 8)

    for word in all(split(t, " ")) do
        local ww = #word * 4
        if lw + ww <= w then
            if line != "" then
				-- str concat (..=)
                line ..= " "
                lw += 4
            end
            line ..= word
            lw += ww
        else
            add(lines, line)
            if #lines == max then return lines end
            line, lw = word, ww
        end
    end

    if line != "" and #lines < max then
        add(lines, line)
    end

    return lines
end