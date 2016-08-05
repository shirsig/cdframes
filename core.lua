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

function private.ParseNumber(arg)
	local number = tonumber(arg.input) or arg.default
	if arg.min then
		number = max(arg.min, number)
	end
	if arg.max then
		number = min(arg.max, number)
	end
	return arg.integer and floor(number+0.5) or number
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
			local primary, secondary = unpack(m.Elems(parameters[2] or ''))
			frame.settings.size = {m.ParseNumber{input=primary, min=1, max=20, default=10, integer=true}, m.ParseNumber{input=secondary, min=1, max=20, default=1, integer=true}}
		elseif parameters[1] == 'SCALE' then
			frame.settings.scale = m.ParseNumber{input=parameters[2], min=0.5, max=2, default=1}
		elseif parameters[1] == 'CLICK' then
			frame.settings.clickThrough = not frame.settings.clickThrough
		elseif parameters[1] == 'BLINK' then
			frame.settings.blink = m.ParseNumber{input=parameters[2], min=0, default=10, integer=true}
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
			DEFAULT_CHAT_FRAME:AddMessage(frame.key..':', 1, 1, 0)
			for _, name in m.Elems(frame.settings.ignoreList) do
				DEFAULT_CHAT_FRAME:AddMessage(name, 1, 1, 0)
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
