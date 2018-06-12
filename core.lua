module 'cdframes'

local T = require 'T'
local util = require 'cdframes.util'
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

function tokenize(str)
	local tokens = T.acquire()
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
				util.print(k .. ': ' .. v.code)
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
				settings.skin = (T.temp-T.set('darion', 'blizzard', 'zoomed', 'elvui', 'modui'))[strlower(parameters[2] or '')] and strlower(parameters[2]) or 'darion'
			elseif parameters[1] == 'COUNT' then
				settings.count = not settings.count
			elseif parameters[1] == 'BLINK' then
				settings.blink = parse_number(parameters[2], 0)
			elseif parameters[1] == 'SHADOW' then
				settings.shadow = not settings.shadow
			elseif parameters[1] == 'ORDER' then
				settings.order = (T.temp-T.set('remaining', 'start'))[strlower(parameters[2] or '')] and strlower(parameters[2])  or 'remaining'
			elseif parameters[1] == 'IGNORE' and parameters[2] == 'ADD' then
				local _, _, match = strfind(strupper(str), 'IGNORE%s+ADD%s+(.-)%s*$')
				local names = T.temp-T.acquire()
				for _, name in T.temp-util.elems(match) do
					if not util.contains(settings.ignore_list, name) then tinsert(names, name) end
				end
				settings.ignore_list = settings.ignore_list == '' and util.list(unpack(names)) or settings.ignore_list .. ',' .. util.list(unpack(names))
			elseif parameters[1] == 'IGNORE' and parameters[2] == 'REMOVE' then
				local _, _, match = strfind(strupper(str), 'IGNORE%s+REMOVE%s+(.-)%s*$')
				local names = T.temp-T.acquire()
				for _, name in T.temp-util.elems(settings.ignore_list) do
					if not util.contains(match, name) then tinsert(names, name) end
				end
				settings.ignore_list = util.list(unpack(names))
			elseif parameters[1] == 'IGNORE' then
				util.print(k .. ':')
				for _, name in T.temp-util.elems(settings.ignore_list) do
					util.print(name)
				end
			else
				return
			end
			cdframes_frame.load(k, settings)
		end
	end
end
