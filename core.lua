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

function public.Iter(list)
	return string.gfind(list, '[^,]+')
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

function private.parseNumber(arg)
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

	local frames
	if parameters[1] == m.player.frame.key then
		frames = {m.player.frame}
		tremove(parameters, 1)
	elseif parameters[1] == m.enemy.targetFrame.key then
		frames = {m.enemy.targetFrame}
		tremove(parameters, 1)
	elseif parameters[1] == m.enemy.targetTargetFrame.key then
		frames = {m.enemy.targetTargetFrame}
		tremove(parameters, 1)
	else
		frames = {m.player.frame, m.enemy.targetFrame, m.enemy.targetTargetFrame}
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
			frame.settings.size = {m.parseNumber{input=parameters[2], min=1, max=20, default=10, integer=true}, m.parseNumber{input=parameters[3], min=1, max=20, default=1, integer=true}}
		elseif parameters[1] == 'SCALE' then
			frame.settings.scale = m.parseNumber{input=parameters[2], min=0.5, max=2, default=1}
		elseif parameters[1] == 'CLICK' then
			frame.settings.clickThrough = not frame.settings.clickThrough
		elseif parameters[1] == 'BLINK' then
			frame.settings.blink = m.parseNumber{input=parameters[2], min=0, default=10, integer=true}
		elseif parameters[1] == 'IGNORE' and parameters[2] == 'ADD' then
			local _, _, list = strfind(str, '[^,]*ADD%s+(.-)%s*$')
			local names = {}
			for name in m.Iter(list) do
				if not m.In(frame.settings.ignoreList, name) then
					tinsert(names, name)
				end
			end
			frame.settings.ignoreList = frame.settings.ignoreList == '' and m.List(unpack(names)) or frame.settings.ignoreList..','..m.List(unpack(names))
		elseif parameters[1] == 'IGNORE' and parameters[2] == 'REMOVE' then
			local _, _, list = strfind(str, '[^,]*REMOVE%s+(.-)%s*$')
			local names = {}
			for name in m.Iter(frame.settings.ignoreList) do
				if not m.In(list, name) then
					tinsert(names, name)
				end
			end
			frame.settings.ignoreList = m.List(unpack(names))
		elseif parameters[1] == 'IGNORE' then
			DEFAULT_CHAT_FRAME:AddMessage(frame.key..':', 1, 1, 0)
			for name in m.Iter(frame.settings.ignoreList) do
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
