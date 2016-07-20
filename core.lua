local interface, m, public, private = unpack(CDFrames_Module())
CDFrames = interface

function public.module(name)
	local module = CDFrames_Module()
	public[name] = tremove(module, 1)
	return unpack(module)
end

public.events = CreateFrame('Frame')
m.events:SetScript('OnEvent', function() this[event]() end)
m.events:RegisterEvent('ADDON_LOADED')

do
	local x = 0

	function public.ID()
		x = x + 1
		return 'CDFrames_Frame'..x
	end
end

function public.Contains(list, str)
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

function private.SlashHandler(str)
	str = strupper(str)
	local parameters = m.Tokenize(str)

	local key = parameters[1]
	local frame
	if key == 'PLAYER' then
		frame = m.player.frame
	elseif key == 'ENEMY' then
		frame = m.enemy.frame
	else
		return
	end

	if parameters[2] == 'ON' then
		frame.settings.active = true
	elseif parameters[2] == 'OFF' then
		frame.settings.active = false
	elseif parameters[2] == 'LOCK' then
		frame.settings.locked = true
	elseif parameters[2] == 'UNLOCK' then
		frame.settings.locked = false
	elseif parameters[2] == 'SIZE' then
		frame.settings.size = min(20, max(1, tonumber(parameters[3]) or 10))
	elseif parameters[2] == 'SCALE' then
		frame.settings.scale = min(2, max(0.8, tonumber(parameters[3]) or 1))
	elseif parameters[2] == 'CLICK' then
		frame.settings.clickThrough = not frame.settings.clickThrough
	elseif parameters[2] == 'IGNORE' then
		local _, _, ignoreList = strfind(str, '^%s*'..key..'%s+IGNORE%s+(.-)%s*$')
		frame.settings.ignoreList = ignoreList or ''
	elseif parameters[2] == 'RESET' then
		frame:Reset()
		frame:PlaceFrames()
	else
		return
	end

	frame:Initialize()
end

function private.Tokenize(str)
	local tokens = {}
	for token in string.gfind(str, '%S+') do
		tinsert(tokens, token)
	end
	return tokens
end
