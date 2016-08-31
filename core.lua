do
	local modules = {}
	CDFrames = function(name)
		if not modules[name] then
			module()
			modules[name] = M
			import (green_t)
			private.CDFrames = setmetatable({}, {__metatable=false, __index=function(_, key) return modules[key].I end, __newindex=error})
		end
		modules[name].import (modules.core.I)
		setfenv(2, modules[name])
	end
end

CDFrames 'core'

_G.CDFrames_Settings = {}

private.events = CreateFrame('Frame')
events:SetScript('OnEvent', function() this[event]() end)
events:RegisterEvent('ADDON_LOADED')

function public.Log(msg)
	DEFAULT_CHAT_FRAME:AddMessage(LIGHTYELLOW_FONT_COLOR_CODE..'[CDFrames] '..msg)
end

function public.List(first, ...)
	for i=1,arg.n do
		first = first..','..arg[i]
	end
	return first or ''
end

function public.Elems(list)
	local elems = {}
	for elem in string.gfind(list, '[^,]+') do
		tinsert(elems, elem)
	end
	return elems
end

function public.In(list, str)
	for element in string.gfind(list, '[^,]+') do
		if element == str then
			return true
		end
	end
end

function M.events.ADDON_LOADED()
	if arg1 ~= 'CDFrames' then return end

	_G.SLASH_CDFrames1 = '/cdframes'
	_G.SlashCmdList.CDFrames = M.SlashHandler

	CDFrames.player.Setup()
	CDFrames.enemy.Setup()
end

function private.ParseNumber(params)
	local number = tonumber(params.input) or params.default
	if params.min then
		number = max(params.min, number)
	end
	if params.max then
		number = min(params.max, number)
	end
	return params.integer and floor(number + .5) or number
end

function private.SlashHandler(str)
	str = strupper(str)
	local parameters = M.Tokenize(str)

	local frames = {}
	if M.In(parameters[1], 'PLAYER') then
		tinsert(frames, CDFrames.player.frame)
	end
	if M.In(parameters[1], 'TARGET') then
		tinsert(frames, CDFrames.enemy.targetFrame)
	end
	if M.In(parameters[1], 'TARGETTARGET') then
		tinsert(frames, CDFrames.enemy.targetTargetFrame)
	end
	if getn(frames) == 0 then
		frames = {CDFrames.player.frame, CDFrames.enemy.targetFrame, CDFrames.enemy.targetTargetFrame}
	else
		tremove(parameters, 1)
	end

	for _, frame in frames do
		if parameters[1] == 'ON' then
			frame.settings.active = true
		elseif parameters[1] == 'OFF' then
			frame.settings.active = false
		elseif parameters[1] == 'LOCK' then
			frame.settings.locked = true
		elseif parameters[1] == 'UNLOCK' then
			frame.settings.locked = false
		elseif parameters[1] == 'SIZE' then
			frame.settings.size = M.ParseNumber{input=parameters[2], min=1, max=100, default=16, integer=true}
		elseif parameters[1] == 'LINE' then
			frame.settings.line = M.ParseNumber{input=parameters[2], min=1, max=100, default=8, integer=true}
		elseif parameters[1] == 'SPACING' then
			frame.settings.spacing = M.ParseNumber{input=parameters[2], min=0, max=1, default=0}
		elseif parameters[1] == 'SCALE' then
			frame.settings.scale = M.ParseNumber{input=parameters[2], min=21/37/CDFrames.frame.BASE_SCALE, max=2, default=1}
		elseif parameters[1] == 'TEXT' then
			frame.settings.text = M.ParseNumber{input=parameters[2], min=0, max=2, default=1, integer=true}
		elseif parameters[1] == 'BLINK' then
			frame.settings.blink = M.ParseNumber{input=parameters[2], min=0, default=7}
		elseif parameters[1] == 'ANIMATION' then
			frame.settings.animation = not frame.settings.animation
		elseif parameters[1] == 'CLICKTHROUGH' then
			frame.settings.clickThrough = not frame.settings.clickThrough
		elseif parameters[1] == 'IGNORE' and parameters[2] == 'ADD' then
			local _, _, list = strfind(str, '[^,]*ADD%s+(.-)%s*$')
			local names = {}
			for _, name in M.Elems(list) do
				if not M.In(frame.settings.ignoreList, name) then
					tinsert(names, name)
				end
			end
			frame.settings.ignoreList = frame.settings.ignoreList == '' and M.List(unpack(names)) or frame.settings.ignoreList..','..M.List(unpack(names))
		elseif parameters[1] == 'IGNORE' and parameters[2] == 'REMOVE' then
			local _, _, list = strfind(str, '[^,]*REMOVE%s+(.-)%s*$')
			local names = {}
			for _, name in M.Elems(frame.settings.ignoreList) do
				if not M.In(list, name) then
					tinsert(names, name)
				end
			end
			frame.settings.ignoreList = M.List(unpack(names))
		elseif parameters[1] == 'IGNORE' then
			M.Log(frame.key..':')
			for _, name in M.Elems(frame.settings.ignoreList) do
				M.Log(name)
			end
		elseif parameters[1] == 'RESET' then
			frame:Reset()
		else
			return
		end

		frame:Configure()
	end
end

function private.Tokenize(str)
	local tokens = {}
	for token in string.gfind(str, '%S+') do
		tinsert(tokens, token)
	end
	return tokens
end
