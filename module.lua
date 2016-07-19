local function CDFrames_module()
    local data, is_public, interface, public_declarator = {}, {}, {}, {}
    setmetatable(data, {
        __index = function(_, key)
            local new_module = { CDFrames_module() }
            public_declarator[key] = new_module[1]
            return new_module[2], new_module[3]
        end,
    })
    setmetatable(interface, {
        __newindex = function() error() end,
        __index = function(_, key)
            local value = data[key]
            if is_public[key] then
                return value
            end
        end,
    })
    setmetatable(public_declarator, {
        __newindex = function(_, key, value)
            if is_public[key] then
                error()
            end
            data[key] = value
            is_public[key] = true
        end,
        __index = function() error() end,
    })
    return interface, data, public_declarator
end

