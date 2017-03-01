module 'cdframes'

include 'T'

local cdframes_frame = require 'cdframes.frame'

CreateFrame('GameTooltip', 'cdframes_tooltip', nil, 'GameTooltipTemplate')

_G.cdframes = {
	used = true,
	frames = {
		PLAYER = {code=[[UnitName'player']]},
		TARGET = {code=[[UnitName'target']]},
	},
}

function update_frames()
	for k, v in cdframes.frames do
		cdframes_frame.load(k, v)
	end
end

CreateFrame'Frame':SetScript('OnUpdate', function()
	update_frames()
	this:SetScript('OnUpdate', nil)
end)

function M.print(msg)
	DEFAULT_CHAT_FRAME:AddMessage('<cdframes> ' .. msg)
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

function tokenize(str)
	local tokens = T
	for token in string.gfind(str, '%S+') do tinsert(tokens, token) end
	return tokens
end

function parse_number(input, lower_bound, upper_bound, integer)
	local number = tonumber(input)
	if number then
		if lower_bound then number = max(lower_bound, number) end
		if upper_bound then number = min(upper_bound, number) end
		return integer and floor(number + .5) or number
	end
end

_G.SLASH_CDFRAMES1 = '/cdframes'
function SlashCmdList.CDFRAMES(str)
	local parameters = tokenize(strupper(str))
	if parameters[1] == 'USED' then
		cdframes.used = not cdframes.used
	elseif parameters[1] == 'FRAME' then
		if parameters[2] then
			local _, _, code = strfind(str, '%s*%S+%s+%S+%s+(.*)')
			if code then
				cdframes.frames[parameters[2]] = {code=code}
			elseif cdframes.frames[parameters[2]] then
				cdframes_frame.load(parameters[2], {code=[[nil]], locked=true})
				cdframes.frames[parameters[2]] = nil
			end
			update_frames()
		else
			for k, v in cdframes.frames do
				print(k .. ': ' .. v.code)
			end
		end
	elseif parameters[1] then
		local selected_frames = {}
		while cdframes.frames[parameters[1]] do
			selected_frames[tremove(parameters, 1)] = true
		end
		for k in next(selected_frames) and selected_frames or cdframes.frames do
			local settings = cdframes.frames[k]
			if parameters[1] == 'LOCK' then
				settings.locked = true
			elseif parameters[1] == 'UNLOCK' then
				settings.locked = false
			elseif parameters[1] == 'SIZE' then
				settings.size = parse_number(parameters[2], 1, 100, true)
			elseif parameters[1] == 'LINE' then
				settings.line = parse_number(parameters[2], 1, 100, true)
			elseif parameters[1] == 'SPACING' then
				settings.spacing = parse_number(parameters[2], 0, 1)
			elseif parameters[1] == 'SCALE' then
				local scale = parse_number(parameters[2], .5, 2)
				settings.x = settings.x * settings.scale / scale
				settings.y = settings.y * settings.scale / scale
				settings.scale = scale
			elseif parameters[1] == 'SKIN' then
				settings.skin = (temp-S('darion', 'blizzard', 'zoomed', 'elvui', 'modui'))[strlower(parameters[2] or '')] and strlower(parameters[2])
			elseif parameters[1] == 'COUNT' then
				settings.count = not settings.count
			elseif parameters[1] == 'BLINK' then
				settings.blink = parse_number(parameters[2], 0)
			elseif parameters[1] == 'SHADOW' then
				settings.shadow = not settings.shadow
			elseif parameters[1] == 'IGNORE' and parameters[2] == 'ADD' then
				local _, _, match = strfind(strupper(str), 'IGNORE%s+ADD%s+(.-)%s*$')
				local names = temp-T
				for _, name in temp-elems(match) do
					if not contains(settings.ignore_list, name) then tinsert(names, name) end
				end
				settings.ignore_list = settings.ignore_list == '' and list(unpack(names)) or settings.ignore_list .. ',' .. list(unpack(names))
			elseif parameters[1] == 'IGNORE' and parameters[2] == 'REMOVE' then
				local _, _, match = strfind(strupper(str), 'IGNORE%s+REMOVE%s+(.-)%s*$')
				local names = temp-T
				for _, name in temp-elems(settings.ignore_list) do
					if not contains(match, name) then tinsert(names, name) end
				end
				settings.ignore_list = list(unpack(names))
			elseif parameters[1] == 'IGNORE' then
				print(k .. ':')
				for _, name in temp-elems(settings.ignore_list) do
					print(name)
				end
			else
				return
			end
			cdframes_frame.load(k, settings)
		end
	end
end
