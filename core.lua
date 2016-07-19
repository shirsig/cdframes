local interface, m, pub = CDFrames_Module()
CDFrames = interface

pub.events = CreateFrame('Frame')
m.events:SetScript('OnEvent', function() this[event]() end)
m.events:RegisterEvent('ADDON_LOADED')

function m.events.ADDON_LOADED()
	if arg1 ~= 'CDFrames' then
		return
	end

	SLASH_CDFrames1 = '/cdframes'
	SlashCmdList.CDFrames = m.SlashHandler

	m.player.frame = m.Frame('PLAYER', 'Player Cooldowns')
	m.enemy.frame = m.Frame('ENEMY', 'Enemy Cooldowns')

	m.player.Setup()
	m.enemy.Setup()
end

function m.SlashHandler(str)
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

	frame:ApplySettings()
end

function m.Contains(list, str)
	for element in string.gfind(list, '[^,]+') do
		if element == str then
			return true
		end
	end
end

function m.Tokenize(str)
	local tokens = {}
	for token in string.gfind(str, '%S+') do
		tinsert(tokens, token)
	end
	return tokens
end