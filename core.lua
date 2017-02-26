module 'cdframes'

include 'T'

local cdframes_frame = require 'cdframes.frame'
local cdframes_player = require 'cdframes.player'
local cdframes_other = require 'cdframes.other'

CreateFrame('GameTooltip', 'cooldowns_Tooltip', nil, 'GameTooltipTemplate')

do
	local frame = CreateFrame'Frame'
	frame:SetScript('OnEvent', function() _M[event]() end)
	frame:RegisterEvent('ADDON_LOADED')
end

_G.cdframes = {
	used = true,
	frames = {
		PLAYER = {code=[[UnitName'player']], settings={}},
		TARGET = {code=[[UnitName'target']], settings={}},
	},
}

local chunks, frames = {}, {}

function update_chunks()
	for k, v in cdframes.frames do
		chunks[k] = loadstring('return ' .. v.code)
		frames[k] = frames[k] or cdframes_frame.new(k)
		frames[k]:LoadSettings(v.settings)
	end
end

CreateFrame'Frame':SetScript('OnUpdate', function()
	update_chunks()

	this:SetScript('OnUpdate', function()
		for k in cdframes.frames do
			local unit = chunks[k]()
			if unit == UnitName'player' then
				frames[k]:Update(cdframes_player.cooldowns)
			else
				frames[k]:Update(cdframes_other.cooldowns(unit))
			end
		end
	end)
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

function tokenize(str)
	local tokens = T
	for token in string.gfind(str, '%S+') do tinsert(tokens, token) end
	return tokens
end

function parse_number(params)
	local number = tonumber(params.input) or params.default
	if params.min then number = max(params.min, number) end
	if params.max then number = min(params.max, number) end
	return params.integer and floor(number + .5) or number
end

_G.SLASH_COOLDOWNS1 = '/cdframes'
function SlashCmdList.COOLDOWNS(str)
	str = strupper(str)
	local parameters = tokenize(str)
	if parameters[1] == 'USED' then
		cdframes.used = not cdframes.used
	elseif parameters[1] == 'FRAME' then
		if parameters[2] then
			if parameters[3] then
				cdframes.frames[parameters[2]] = {code=parameters[3], settings={}}
			elseif cdframes.frames[parameters[2]] then
				frames[parameters[2]]:Hide()
				cdframes.frames[parameters[2]] = nil
			end
			update_chunks()
		else
			for k, v in strings do
				print(k .. ': ' .. v)
			end
		end
	elseif parameters[1] then
		local selected_frames
		if parameters[1] == '*' then
			selected_frames = {}
			for k in cdframes.frames do
				tinsert(selected_frames, k)
			end
		else
			selected_frames = elems(parameters[1])
		end
		for _, k in selected_frames do
			local settings = cdframes.frames[k].settings
			if parameters[2] == 'LOCK' then
				settings.locked = true
			elseif parameters[2] == 'UNLOCK' then
				settings.locked = false
			elseif parameters[2] == 'SIZE' then
				settings.size = parse_number{input=parameters[3], min=1, max=100, default=16, integer=true}
			elseif parameters[2] == 'LINE' then
				settings.line = parse_number{input=parameters[3], min=1, max=100, default=8, integer=true}
			elseif parameters[2] == 'SPACING' then
				settings.spacing = parse_number{input=parameters[3], min=0, max=1, default=0}
			elseif parameters[2] == 'SCALE' then
				local scale = parse_number{input=parameters[3], min=.5, max=2, default=1}
				settings.x = settings.x * settings.scale / scale
				settings.y = settings.y * settings.scale / scale
				settings.scale = scale
			elseif parameters[2] == 'SKIN' then
				settings.skin = (temp-S('darion', 'blizzard', 'modui', 'zoomed', 'elvui'))[strlower(parameters[3] or '')] and strlower(parameters[3]) or 'darion'
			elseif parameters[2] == 'COUNT' then
				settings.count = not settings.count
			elseif parameters[2] == 'BLINK' then
				settings.blink = parse_number{input=parameters[3], min=0, default=7}
			elseif parameters[2] == 'ANIMATION' then
				settings.animation = not settings.animation
			elseif parameters[2] == 'CLICKTHROUGH' then
				settings.clickthrough = not settings.clickthrough
			elseif parameters[2] == 'IGNORE' and parameters[3] == 'ADD' then
				local _, _, match = strfind(str, '[^,]*ADD%s+(.-)%s*$')
				local names = temp-T
				for _, name in temp-elems(match) do
					if not contains(settings.ignore_list, name) then tinsert(names, name) end
				end
				settings.ignore_list = settings.ignore_list == '' and list(unpack(names)) or settings.ignore_list .. ',' .. list(unpack(names))
			elseif parameters[2] == 'IGNORE' and parameters[3] == 'REMOVE' then
				local _, _, match = strfind(str, '[^,]*REMOVE%s+(.-)%s*$')
				local names = temp-T
				for _, name in temp-elems(settings.ignore_list) do
					if not contains(match, name) then tinsert(names, name) end
				end
				settings.ignore_list = list(unpack(names))
			elseif parameters[2] == 'IGNORE' then
				print(k .. ':')
				for _, name in temp-elems(settings.ignore_list) do print(name) end
			elseif parameters[2] == 'RESET' then
				wipe(settings)
			else
				return
			end
			frames[k]:LoadSettings(settings)
		end
	end
end
