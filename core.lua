module 'cooldowns'

include 'T'

local cooldowns_frame = require 'cooldowns.frame'
local cooldowns_player = require 'cooldowns.player'
local cooldowns_other = require 'cooldowns.other'

CreateFrame('GameTooltip', 'cooldowns_Tooltip', nil, 'GameTooltipTemplate')

do
	local frame = CreateFrame'Frame'
	frame:SetScript('OnEvent', function() _M[event]() end)
	frame:RegisterEvent('ADDON_LOADED')
end

local strings = {
	PLAYER = [[UnitName'player']],
	TARGET = [[UnitName'target']],
}
local chunks, frames = {}, {}

function update_chunks()
	chunks = {}
	for k, v in strings do
		chunks[k] = loadstring('return ' .. v)
		cooldowns_settings.frames[k] = cooldowns_settings.frames[k] or {}
		frames[k] = frames[k] or cooldowns_frame.new(k, cooldowns_settings.frames[k])
	end
end

CreateFrame'Frame':SetScript('OnUpdate', function()
	for k, chunk in chunks do
		local unit = chunk()
		if unit == UnitName'player' then
			frames[k]:Update(cooldowns_player.cooldowns)
		else
			frames[k]:Update(cooldowns_other.cooldowns(unit))
		end
	end
end)

function M.print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(LIGHTYELLOW_FONT_COLOR_CODE .. '[cooldowns] ' .. msg)
end

function M.list(first, ...)
	for i = 1, arg.n do first = first .. ',' .. arg[i] end
	return first or ''
end

function M.elems(list)
	local elems = T
	for elem in string.gfind(list, '[^,]+') do tinsert(elems, elem) end
	return elems
end

function M.contains(list, str)
	for element in string.gfind(list, '[^,]+') do
		if element == str then return true end
	end
end

do
	local setup = {}

	function M.set_SETUP(f)
		tinsert(setup, f)
	end

	function ADDON_LOADED()
		if arg1 ~= 'cooldowns' then return end

		_G.cooldowns_settings = cooldowns_settings or {}
		if cooldowns_settings.used == nil then
			cooldowns_settings.used = true
		end
		cooldowns_settings.frames = cooldowns_settings.frames or {}

		_G.SLASH_COOLDOWNS1 = '/cooldowns'
		_G.SLASH_COOLDOWNS2 = '/cds'
		SlashCmdList.COOLDOWNS = SLASH

		for _, f in setup do
			f()
		end

		update_chunks()
	end
end

function parse_number(params)
	local number = tonumber(params.input) or params.default
	if params.min then number = max(params.min, number) end
	if params.max then number = min(params.max, number) end
	return params.integer and floor(number + .5) or number
end

function SLASH(str)
	str = strupper(str)
	local parameters = tokenize(str)
	if parameters[1] == 'USED' then
		cooldowns_settings.used = not cooldowns_settings.used
		return
	elseif parameters[1] == 'FRAME' then
		if parameters[2] then
			strings[parameters[2]] = parameters[3] or [['']]
		else
			for k, v in strings do
				print(k .. ': ' .. v)
			end
		end
	end
--
--	for _, key in elems(parameters[1]) do
--		if strings[key]
--	end
--
--		tremove(parameters, 1)
--	end
	for key in strings do
		local settings = cooldowns_settings.frames[key]
		if parameters[1] == 'ON' then
			settings.active = true
		elseif parameters[1] == 'OFF' then
			settings.active = false
		elseif parameters[1] == 'LOCK' then
			settings.locked = true
		elseif parameters[1] == 'UNLOCK' then
			settings.locked = false
		elseif parameters[1] == 'SIZE' then
			settings.size = parse_number{input=parameters[2], min=1, max=100, default=16, integer=true}
		elseif parameters[1] == 'LINE' then
			settings.line = parse_number{input=parameters[2], min=1, max=100, default=8, integer=true}
		elseif parameters[1] == 'SPACING' then
			settings.spacing = parse_number{input=parameters[2], min=0, max=1, default=0}
		elseif parameters[1] == 'SCALE' then
			local scale = parse_number{input=parameters[2], min=.5, max=2, default=1}
			settings.x = settings.x * settings.scale / scale
			settings.y = settings.y * settings.scale / scale
			settings.scale = scale
		elseif parameters[1] == 'SKIN' then
			settings.skin = (temp-S('darion', 'blizzard', 'modui', 'zoomed', 'elvui'))[strlower(parameters[2] or '')] and strlower(parameters[2]) or 'darion'
		elseif parameters[1] == 'COUNT' then
			settings.count = not settings.count
		elseif parameters[1] == 'BLINK' then
			settings.blink = parse_number{input=parameters[2], min=0, default=7}
		elseif parameters[1] == 'ANIMATION' then
			settings.animation = not settings.animation
		elseif parameters[1] == 'CLICKTHROUGH' then
			settings.clickthrough = not settings.clickthrough
		elseif parameters[1] == 'IGNORE' and parameters[2] == 'ADD' then
			local _, _, match = strfind(str, '[^,]*ADD%s+(.-)%s*$')
			local names = temp-T
			for _, name in temp-elems(match) do
				if not contains(settings.ignore_list, name) then tinsert(names, name) end
			end
			settings.ignore_list = settings.ignore_list == '' and list(unpack(names)) or settings.ignore_list .. ',' .. list(unpack(names))
		elseif parameters[1] == 'IGNORE' and parameters[2] == 'REMOVE' then
			local _, _, match = strfind(str, '[^,]*REMOVE%s+(.-)%s*$')
			local names = temp-T
			for _, name in temp-elems(settings.ignore_list) do
				if not contains(match, name) then tinsert(names, name) end
			end
			settings.ignore_list = list(unpack(names))
		elseif parameters[1] == 'IGNORE' then
			print(key .. ':')
			for _, name in temp-elems(settings.ignore_list) do print(name) end
		elseif parameters[1] == 'RESET' then
			wipe(settings)
		else
			return
		end
		frames[key]:LoadSettings(settings)
	end
end

function tokenize(str)
	local tokens = T
	for token in string.gfind(str, '%S+') do tinsert(tokens, token) end
	return tokens
end
