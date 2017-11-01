module 'cdframes.util'

local T = require 'T'

function M.print(msg)
    DEFAULT_CHAT_FRAME:AddMessage('<cdframes> ' .. msg)
end

function M.list(first, ...)
    for i = 1, arg.n do first = first .. ',' .. arg[i] end
    return first or ''
end

function M.elems(list)
    local elems = T.acquire()
    for elem in string.gfind(list, '[^,]+') do tinsert(elems, elem) end
    return elems
end

function M.contains(list, str)
    for element in string.gfind(list, '[^,]+') do
        if element == str then return true end
    end
end
