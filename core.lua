local interface, m, public, private = unpack(CDFrames_Module())
CDFrames = interface

CDFrames_Settings = {}

function public.module(name)
	local module = CDFrames_Module()
	public[name] = tremove(module, 1)
	return unpack(module)
end

private.events = CreateFrame('Frame')
m.events:SetScript('OnEvent', function() this[event]() end)
m.events:RegisterEvent('ADDON_LOADED')

function public.Log(msg)
	DEFAULT_CHAT_FRAME:AddMessage(LIGHTYELLOW_FONT_COLOR_CODE..'[CDFrames] '..msg)
end

function public.Present(value)
	return value ~= nil and {[value]=true} or {}
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

function m.events.ADDON_LOADED()
	if arg1 ~= 'CDFrames' then
		return
	end

	SLASH_CDFrames1 = '/cdframes'
	SlashCmdList.CDFrames = m.SlashHandler

	m.player.Setup()
	m.enemy.Setup()
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
	local parameters = m.Tokenize(str)

	local frames = {}
	if m.In(parameters[1], 'PLAYER') then
		tinsert(frames, m.player.frame)
	end
	if m.In(parameters[1], 'TARGET') then
		tinsert(frames, m.enemy.targetFrame)
	end
	if m.In(parameters[1], 'TARGETTARGET') then
		tinsert(frames, m.enemy.targetTargetFrame)
	end
	if getn(frames) == 0 then
		frames = {m.player.frame, m.enemy.targetFrame, m.enemy.targetTargetFrame}
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
			frame.settings.size = m.ParseNumber{input=parameters[2], min=1, max=100, default=16, integer=true}
		elseif parameters[1] == 'LINE' then
			frame.settings.line = m.ParseNumber{input=parameters[2], min=1, max=100, default=8, integer=true}
		elseif parameters[1] == 'SPACING' then
			frame.settings.spacing = m.ParseNumber{input=parameters[2], min=0, max=1, default=0}
		elseif parameters[1] == 'SCALE' then
			frame.settings.scale = m.ParseNumber{input=parameters[2], min=21/36/m.frame.BASE_SCALE, max=2, default=1}
		elseif parameters[1] == 'TEXT' then
			frame.settings.count = m.ParseNumber{input=parameters[2], min=0, max=2, default=1, integer=true}
		elseif parameters[1] == 'BLINK' then
			frame.settings.blink = m.ParseNumber{input=parameters[2], min=0, default=7}
		elseif parameters[1] == 'ANIMATION' then
			frame.settings.animation = not frame.settings.animation
		elseif parameters[1] == 'CLICKTHROUGH' then
			frame.settings.clickThrough = not frame.settings.clickThrough
		elseif parameters[1] == 'IGNORE' and parameters[2] == 'ADD' then
			local _, _, list = strfind(str, '[^,]*ADD%s+(.-)%s*$')
			local names = {}
			for _, name in m.Elems(list) do
				if not m.In(frame.settings.ignoreList, name) then
					tinsert(names, name)
				end
			end
			frame.settings.ignoreList = frame.settings.ignoreList == '' and m.List(unpack(names)) or frame.settings.ignoreList..','..m.List(unpack(names))
		elseif parameters[1] == 'IGNORE' and parameters[2] == 'REMOVE' then
			local _, _, list = strfind(str, '[^,]*REMOVE%s+(.-)%s*$')
			local names = {}
			for _, name in m.Elems(frame.settings.ignoreList) do
				if not m.In(list, name) then
					tinsert(names, name)
				end
			end
			frame.settings.ignoreList = m.List(unpack(names))
		elseif parameters[1] == 'IGNORE' then
			m.Log(frame.key..':')
			for _, name in m.Elems(frame.settings.ignoreList) do
				m.Log(name)
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
