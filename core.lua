local CDC = CreateFrame('Frame')
CDC:SetScript('OnEvent', function()
	this[event](this)
end)
CDC:RegisterEvent('ADDON_LOADED')

function CDC:ADDON_LOADED()
	if arg1 ~= 'CDC' then
		return
	end

	SLASH_CDC1 = '/cdc'
	SlashCmdList.CDC = function(str) self:SlashHandler(str) end

	self.playerFrame = CDC_Frame('PLAYER', 'Player Cooldowns')
	self.enemyFrame = CDC_Frame('ENEMY', 'Enemy Cooldowns')

	self:PlayerSetup()
	self:EnemySetup()
end

function CDC:SlashHandler(str)
	str = strupper(str)
	local parameters = self:Tokenize(str)

	local key = parameters[1]
	local frame
	if key == 'PLAYER' then
		frame = self.playerFrame
	elseif key == 'ENEMY' then
		frame = self.enemyFrame
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

function CDC:Tokenize(str)
	local tokens = {}
	for token in string.gfind(str, '%S+') do
		tinsert(tokens, token)
	end
	return tokens
end

-- PLAYER

function CDC:BAG_UPDATE_COOLDOWN()
	self:DetectItemCooldowns()
end

function CDC:SPELL_UPDATE_COOLDOWN()
	self:DetectSpellCooldowns()
end

function CDC:PlayerSetup()
	self:RegisterEvent('BAG_UPDATE_COOLDOWN')
	self:RegisterEvent('SPELL_UPDATE_COOLDOWN')

	self:DetectItemCooldowns()
	self:DetectSpellCooldowns()
end

do
	active = {}

	function CDC:StartPlayerCD(name, texture, started, duration)
		if active[name] then
			self.playerFrame:CancelCD(active[name])
		end
		active[name] = self.playerFrame:StartCD(name, '', strsub(texture, 17), started + duration)
	end
end

function CDC:LinkName(link)
	for name in string.gfind(link, '|Hitem:%d+:%d+:%d+:%d+|h[[]([^]]+)[]]|h') do
		return name
	end
end

function CDC:DetectItemCooldowns()	
    for bag=0,4 do
        if GetBagName(bag) then
            for slot = 1, GetContainerNumSlots(bag) do
				local started, duration, enabled = GetContainerItemCooldown(bag, slot)
				if enabled == 1 then
					local name = self:LinkName(GetContainerItemLink(bag, slot))
					if duration == 0 or duration > 3 and duration <= 1800 and GetItemInfo(6948) ~= name then
						self:StartPlayerCD(
							name,
							GetContainerItemInfo(bag, slot),
							started,
							duration
						)
					end
				end
            end
        end
    end
	for slot=0,19 do
		local started, duration, enabled = GetInventoryItemCooldown('player', slot)
		if enabled == 1 then
			local name = self:LinkName(GetInventoryItemLink('player', slot))
			if duration == 0 or duration > 3 and duration <= 1800 then
				self:StartPlayerCD(
					name,
					GetInventoryItemTexture('player', slot),
					started,
					duration
				)
			end
		end
	end
end

function CDC:DetectSpellCooldowns()	
	local _, _, offset, spellCount = GetSpellTabInfo(GetNumSpellTabs())
	local totalSpells = offset + spellCount
	for id=1,totalSpells do
		local started, duration, enabled = GetSpellCooldown(id, BOOKTYPE_SPELL)
		local name = GetSpellName(id, BOOKTYPE_SPELL)
		if duration == 0 or enabled == 1 and duration > 2.5 then
			self:StartPlayerCD(
				name,
				GetSpellTexture(id, BOOKTYPE_SPELL),
				started,
				duration
			)
		end
	end
end

-- ENEMY

local ENEMY_SKILLS = {

	-- Trinkets & Racials
	["Will of the Forsaken"] = {cooldown = 2*60, desc = "Unknown!", icon = "Spell_Shadow_RaiseDead"},
	["Perception"] = {cooldown = 3*60, desc = "Unknown!", icon = "Spell_Nature_Sleep"},
	["War Stomp"] = {cooldown = 2*60, desc = "Unknown!", icon = "Ability_WarStomp"},
	["Stoneform"] = {cooldown = 3*60, desc = "Unknown!", icon = "Spell_Shadow_UnholyStrength"},

	["Brittle Armor"] = {cooldown = 2*60, desc = "Unknown!", icon = "Spell_Shadow_GrimWard"},
	["Unstable Power"] = {cooldown = 2*60, desc = "Unknown!", icon = "Spell_Lightning_LightningBolt01"},
	["Restless Strength"] = {cooldown = 2*60, desc = "Unknown!", icon = "Spell_Shadow_GrimWard"},
	["Ephemeral Power"] = {cooldown = 90, desc = "Unknown!", icon = "Spell_Holy_MindVision"},
	["Massive Destruction"] = {cooldown = 3*60, desc = "Unknown!", icon = "Spell_Fire_WindsofWoe"},
	["Arcane Potency"] = {cooldown = 3*60, desc = "Unknown!", icon = "Spell_Arcane_StarFire"},
	["Energized Shield"] = {cooldown = 3*60, desc = "Unknown!", icon = "Spell_Nature_CallStorm"},
	["Brilliant Light"] = {cooldown = 3*60, desc = "Unknown!", icon = "Spell_Holy_MindVision"},
	["Mar'li's Brain Boost"] = {cooldown = 3*60, desc = "Unknown!", icon = "INV_ZulGurubTrinket"},
	["Gift of Life"] = {cooldown = 5*60, desc = "Unknown!", icon = "INV_Misc_Gem_Pearl_05"},
	["Nature Aligned"] = {cooldown = 5*60, desc = "Unknown!", icon = "Spell_Nature_SpiritArmor"},
	["Earthstrike"] = {cooldown = 2*60, desc = "Unknown!", icon = "Spell_Nature_AbolishMagic"},

	["Frost Recleftor"] = {cooldown = 5*60, desc = "Unknown!", icon = "Spell_Frost_FrostWard"},
	["Shadow Reflector"] = {cooldown = 5*60, desc = "Unknown!", icon = "Spell_Shadow_AntiShadow"},
	["Fire Reflector"] = {cooldown = 5*60, desc = "Unknown!", icon = "Spell_Fire_SealOfFire"},

	["First Aid"] = {cooldown = 60, desc = "Unknown!", icon = "Spell_Holy_Heal"},

	-- Warriors
	["Charge"] = {cooldown = 15, desc = "Charge an enemy, generate 15 rage, and stun it for 1 sec. Cannot be used in combat.", icon = "Ability_Warrior_Charge"},
	["Mocking Blow"] = {cooldown = 2*60, desc = "A mocking attack that causes 93 damage, a moderate amount of threat and forces the target to focus attacks on you for 6 sec.", icon = "Ability_Warrior_PunishingBlow"},
	["Mortal Strike"] = {cooldown = 6, desc = "A vicious strike that deals weapon damage plus 160 and wounds the target, reducing the effectiveness of any healing by 50% for 10 sec.", icon = "Ability_Warrior_SavageBlow"},
	["Overpower"] = {cooldown = 5, desc = "Instantly overpower the enemy, causing weapon damage plus 35. Only useable after the target dodges. The Overpower cannot be blocked, dodged or parried.", icon = "Ability_MeleeDamage"},
	["Retaliation"] = {cooldown = 30*60, desc = "Instantly counterattack any enemy that strikes you in melee for 15 sec. Melee attacks made from behind cannot be counterattacked. A maximum of 30 attacks will cause retaliation.", icon = "Ability_Warrior_Challange"},
	["Thunder Clap"] = {cooldown = 4, desc = "Blasts nearby enemies with thunder slowing their attack speed by 10% for 30 sec and doing 103 damage to them. Will affect up to 4 targets.", icon = "Spell_Nature_ThunderClap"},
	["Berserker Rage"] = {cooldown = 30, desc = "The warrior enters a berserker rage, becoming immune to Fear and Incapacitate effects and generating extra rage when taking damage. Lasts 10 sec.", icon = "Spell_Nature_AncestralGuardian"},
	["Bloodthirst"] = {cooldown = 6, desc = "Instantly attack the target causing damage equal to 45% of your attack power. In addition, the next 5 successful melee attacks will restore 20 health. This effect lasts 8 sec.", icon = "Spell_Nature_BloodLust"},
	["Challenging Shout"] = {cooldown = 10*60, desc = "Forces all nearby enemies to focus attacks on you for 6 sec.", icon = "Ability_BullRush"},
	["Intercept Stun"] = {cooldown = 30, desc = "Charge an enemy, causing 65 damage and stunning it for 3 sec.", icon = "Ability_Rogue_Sprint"},
	["Intimidating Shout"] = {cooldown = 3*60, desc = "The warrior shouts, causing the targeted enemy to cower in fear. Up to 5 total nearby enemies will flee in fear. Lasts 8 sec.", icon = "Ability_GolemThunderClap"},
	["Pummel"] = {cooldown = 10, desc = "Pummel the target for 50 damage. It also interrupts spellcasting and prevents any spell in that school from being cast for 4 sec.", icon = "INV_Gauntlets_04"},
	["Recklessness"] = {cooldown = 30*60, desc = "The warrior will cause critical hits with most attacks and will be immune to Fear effects for the next 15 sec, but all damage taken is increased by 20%.", icon = "Ability_CriticalStrike"},
	["Whirlwind"] = {cooldown = 10, desc = "In a whirlwind of steel you attack up to 4 enemies within 8 yards, causing weapon damage to each enemy.", icon = "Ability_Whirlwind"},
	["Bloodrage"] = {cooldown = 60, desc = "Generates 10 rage at the cost of health, and then generates an additional 10 rage over 10 sec. The warrior is considered in combat for the duration.", icon = "Ability_Racial_BloodRage"},
	["Disarm"] = {cooldown = 60, desc = "Disarm the enemy's weapon for 10 sec.", icon = "Ability_Warrior_Disarm"},
	["Revenge"] = {cooldown = 5, desc = "Instantly counterattack an enemy for 81 to 99 damage and a high amount of threat. Revenge must follow a block, dodge or parry.", icon = "Ability_Warrior_Revenge"},
	["Shield Bash"] = {cooldown = 12, desc = "Bashes the target with your shield for 45 damage. It also interrupts spellcasting and prevents any spell in that school from being cast for 6 sec.", icon = "Ability_Warrior_ShieldBash"},
	["Shield Block"] = {cooldown = 5, desc = "Increases chance to block by 75% for 5 sec, but will only block 1 attack.", icon = "Ability_Defend"},
	["Shield Slam"] = {cooldown = 6, desc = "Slam the target with your shield, causing 342 to 358 damage, modified by your shield block value, and has a 50% chance of dispelling 1 magic effect on the target. Also causes a high amount of threat.", icon = "INV_Shield_05"},
	["Shield Wall"] = {cooldown = 30*60, desc = "Reduces the damage taken from melee attacks, ranged attacks and spells by 75% for 10 sec.", icon = "Ability_Warrior_ShieldWall"},

	["Last Stand"] = {cooldown = 10*60, desc = "When activated, this ability temporarily grants you 30% of your maximum hit points for 20 seconds. After the effect expires, the hit points are lost.", icon = "Spell_Holy_AshesToAshes"},
	["Death Wish"] = {cooldown = 3*60, desc = "When activated, increases your physical damage by 20% and makes you immune to Fear effects, but lowers your armor and all resistances by -20%. Lasts 30 sec.", icon = "Spell_Shadow_DeathPact"},

	-- Paladin
	["Consecration"] = {cooldown = 8, desc = "Consecrates the land beneath Paladin, doing 384 Holy damage over 8 sec to enemies who enter the area.", icon = "Spell_Holy_InnerFire"},
	["Exorcism"] = {cooldown = 15, desc = "Causes 505 to 563 Holy damage to an Undead or Demon target.", icon = "Spell_Holy_Excorcism_02"},
	["Hammer of Wrath"] = {cooldown = 6, desc = "Hurls a hammer that strikes an enemy for 304 to 336 Holy damage. Only usable on enemies that have 20% or less health.", icon = "Ability_ThunderClap"},
	["Holy Wrath"] = {cooldown = 60, desc = "Sends bolts of holy power in all directions, causing 490 to 576 Holy damage to all Undead and Demon targets within 20 yds.", icon = "Spell_Holy_Excorcism"},
	["Lay on Hands"] = {cooldown = 60*60, desc = "Heals a friendly target for an amount equal to the Paladin's maximum health and restores 550 of their mana. Drains all of the Paladin's remaining mana when used.", icon = "Spell_Holy_LayOnHands"},
	["Turn Undead"] = {cooldown = 30, desc = "The targeted undead enemy will be compelled to flee for up to 20 sec. Damage caused may interrupt the effect. Only one target can be turned at a time.", icon = "Spell_Holy_TurnUndead"},
	["Blessing of Freedom"] = {cooldown = 20, desc = "Places a Blessing on the friendly target, granting immunity to movement impairing effects for 10 sec. Players may only have one Blessing on them per Paladin at any one time.", icon = "Spell_Holy_SealOfValor"},
	["Blessing of Protection"] = {cooldown = 5*60, desc = "A targeted party member is protected from all physical attacks for 10 sec, but during that time they cannot attack or use physical abilities. Players may only have one Blessing on them per Paladin at any one time. Once protected, the target cannot be made invulnerable by Divine Shield, Divine Protection or Blessing of Protection again for 1 min.", icon = "Spell_Holy_SealOfProtection"},
	["Divine Intervention"] = {cooldown = 60*60, desc = "The paladin sacrifices himself to remove the targeted party member from harms way. Enemies will stop attacking the protected party member, who will be immune to all harmful attacks but cannot take any action for 3 min.", icon = "Spell_Nature_TimeStop"},
	["Divine Protection"] = {cooldown = 5*60, desc = "You are protected from all physical attacks and spells for 8 sec, but during that time you cannot attack or use physical abilities yourself. Once protected, the target cannot be made invulnerable by Divine Shield, Divine Protection or Blessing of Protection again for 1 min.", icon = "Spell_Holy_Restoration"},
	["Divine Shield"] = {cooldown = 5*60, desc = "Protects the paladin from all damage and spells for 12 sec, but reduces attack speed by 50%. Once protected, the target cannot be made invulnerable by Divine Shield, Divine Protection or Blessing of Protection again for 1 min.", icon = "Spell_Holy_DivineIntervention"},
	["Hammer of Justice"] = {cooldown = 60, desc = "Stuns the target for 6 sec.", icon = "Spell_Holy_SealOfMight"},
	["Judgement"] = {cooldown = 10, desc = "Unleashes the energy of a Seal spell upon an enemy. Refer to individual Seals for Judgement effect.", icon = "Spell_Holy_RighteousFury"},

	["Divine Favor"] = {cooldown = 2*60, desc = "Unknown!", icon = "Spell_Holy_Heal"},
	["Holy Shock"] = {cooldown = 30, desc = "Unknown!", icon = "Spell_Holy_SearingLight"},
	["Holy Shield"] = {cooldown = 10, desc = "Unknown!", icon = "Spell_Holy_BlessingOfProtection"},
	["Repentance"] = {cooldown = 60, desc = "Unknown!", icon = "Spell_Holy_PrayerOfHealing"},

	-- Mage
	["Blink"] = {cooldown = 15, desc = "Teleports the caster 20 yards forward, unless something is in the way. Also frees the caster from stuns and bonds.", icon = "Spell_Arcane_Blink"},
	["Portal: Darnassus"] = {cooldown = 60, desc = "Creates a portal, teleporting group members that use it to Darnassus.", icon = "Spell_Arcane_PortalDarnassus"},
	["Portal: Ironforge"] = {cooldown = 60, desc = "Creates a portal, teleporting group members that use it to Ironforge.", icon = "Spell_Arcane_PortalIronForge"},
	["Portal: Orgrimmar"] = {cooldown = 60, desc = "Creates a portal, teleporting group members that use it to Orgrimmar.", icon = "Spell_Arcane_PortalOrgrimmar"},
	["Portal: Stormwind"] = {cooldown = 60, desc = "Creates a portal, teleporting group members that use it to Stormwind.", icon = "Spell_Arcane_PortalStormWind"},
	["Portal: Thunder Bluff"] = {cooldown = 60, desc = "Creates a portal, teleporting group members that use it to Thunder Bluff.", icon = "Spell_Arcane_PortalThunderBluff"},
	["Portal: Undercity"] = {cooldown = 60, desc = "Creates a portal, teleporting group members that use it to Undercity.", icon = "Spell_Arcane_PortalUnderCity"},
	["Blast Wave"] = {cooldown = 45, desc = "A wave of flame radiates outward from the caster, damaging all enemies caught within the blast for 462 to 544 Fire damage, and dazing them for 6 sec.", icon = "Spell_Holy_Excorcism_02"},
	["Fire Blast"] = {cooldown = 8, desc = "Blasts the enemy for 431 to 509 Fire damage.", icon = "Spell_Fire_Fireball"},
	["Fire Ward"] = {cooldown = 30, desc = "Absorbs 920 Fire damage. Lasts 30 sec.", icon = "Spell_Fire_FireArmor"},
	["Cone of Cold"] = {cooldown = 10, desc = "Targets in a cone in front of the caster take 335 to 365 Frost damage and are slowed by 50% for 8 sec.", icon = "Spell_Frost_Glacier"},
	["Frost Nova"] = {cooldown = 25, desc = "Blasts enemies near the caster for 71 to 79 Frost damage and freezes them in place for up to 8 sec. Damage caused may interrupt the effect.", icon = "Spell_Frost_FrostNova"},
	["Frost Ward"] = {cooldown = 30, desc = "Absorbs 920 Frost damage. Lasts 30 sec.", icon = "Spell_Frost_FrostWard"},
	["Ice Barrier"] = {cooldown = 30, desc = "Instantly shields you, absorbing 818 damage. Lasts 1 min. While the shield holds, spells will not be interrupted.", icon = "Spell_Ice_Lament"},

	["Presence of Mind"] = {cooldown = 3*60, desc = "Unknown!", icon = "Spell_Nature_EnchantArmor"},
	["Arcane Power"] = {cooldown = 3*60, desc = "Unknown!", icon = "Spell_Nature_Lightning"},
	["Combustion"] = {cooldown = 3*60, desc = "Unknown!", icon = "Spell_Fire_SealOfFire"},
	["Cold Snap"] = {cooldown = 10*60, desc = "Unknown!", icon = "Spell_Frost_WizardMark", trigger = function(player) CDC:StopEnemyCDs(player, 'Ice Block', 'Cone of Cold', 'Frost Ward', 'Ice Barrier', 'Frost Nova') end},
	["Ice Block"] = {cooldown = 5*60, desc = "Unknown!", icon = "Spell_Frost_Frost"},

	-- Rogues
	["Kidney Shot"] = {cooldown = 20, desc = "Finishing move that stuns the target. Lasts longer per combo point.", icon = "Ability_Rogue_KidneyShot"},
	["Evasion"] = {cooldown = 5*60, desc = "The rogue's dodge chance will increase by 50% for 15 sec.", icon = "Spell_Shadow_ShadowWard"},
	["Feint"] = {cooldown = 10, desc = "Performs a feint, causing no damage but lowering your threat by a large amount, making the enemy less likely to attack you.", icon = "Ability_Rogue_Feint"},
	["Gouge"] = {cooldown = 6, desc = "Causes 75 damage, incapacitating the opponent for 4 sec, and turns off your attack. Target must be facing you. Any damage caused will revive the target. Awards 1 combo point.", icon = "Ability_Gouge"},
	["Kick"] = {cooldown = 10, desc = "A quick kick that injures a single foe for 80 damage. It also interrupts spellcasting and prevents any spell in that school from being cast for 5 sec.", icon = "Ability_Kick"},
	["Sprint"] = {cooldown = 5*60, desc = "Increases the rogue's movement speed by 70% for 15 sec. Does not break stealth.", icon = "Ability_Rogue_Sprint"},
	["Blind"] = {cooldown = 5*60, desc = "Blinds the target, causing it to wander disoriented for up to 10 sec. Any damage caused will remove the effect.", icon = "Spell_Shadow_MindSteal"},
	["Distract"] = {cooldown = 30, desc = "Throws a distraction, attracting the attention of all nearby monsters for 10 seconds. Does not break stealth.", icon = "Ability_Rogue_Distract"},
	["Stealth"] = {cooldown = 10, desc = "Allows the rogue to sneak around, but reduces your speed by 30%. Lasts until cancelled.", icon = "Ability_Stealth"},
	["Vanish"] = {cooldown = 5*60, desc = "Allows the rogue to vanish from sight, entering an improved stealth mode for 10 sec. Also breaks movement impairing effects. More effective than Vanish (Rank 1).", icon = "Ability_Vanish"},

	["Blade Flurry"] = {cooldown = 2*60, desc = "Increases your attack speed by 20%. In addition, attacks strike an additional nearby opponent. Lasts 15 sec.", icon = "Ability_Warrior_PunishingBlow"},
	["Adrenaline Rush"] = {cooldown = 6*60, desc = "Increases your Energy regeneration rate by 100% for 15 sec.", icon = "Spell_Shadow_ShadowWordDominate"},
	["Preparation"] = {cooldown = 10*60, desc = "When activated, this ability immediately finishes the cooldown of your other Rogue abilities.", icon = "Spell_Shadow_AntiShadow", trigger = function(player) CDC:StopEnemyCDs(player, 'Kidney Shot', 'Evasion', 'Feint', 'Gouge', 'Kick', 'Sprint', 'Blind', 'Distract', 'Stealth', 'Blade Flurry', 'Adrenaline Rush', 'Ghostly Strike', 'Premeditation', 'Cold Blood') end},
	["Ghostly Strike"] = {cooldown = 20, desc = "A strike that deals 125% of weapon damage and increases your chance to dodge by 15% for 7 sec. Awards 1 combo points.", icon = "Spell_Shadow_Curse"},
	["Premeditation"] = {cooldown = 60, desc = "When used, adds two combo points to your target. You must add to or use those combo points within 10 sec or the combo points are lost.", icon = "Spell_Shadow_Possession"},
	["Cold Blood"] = {cooldown = 3*60, desc = "When activated, increases the critical strike chance of your next Sinister Strike, Backstab, Ambush, or Eviscerate by 100%.", icon = "Spell_Ice_Lament"},

	-- Shaman
	["Chain Lightning"] = {cooldown = 6, desc = "Hurls a lightning bolt at the enemy, dealing 493 to 551 Nature damage and then jumping to additional nearby enemies. Each jump reduces the damage by 30%. Affects 3 total targets.", icon = "Spell_Nature_ChainLightning"},
	["Earth Shock"] = {cooldown = 6, desc = "Instantly shocks the target with concussive force, causing 517 to 545 Nature damage. It also interrupts spellcasting and prevents any spell in that school from being cast for 2 sec. Causes a high amount of threat.", icon = "Spell_Nature_EarthShock"},
	["Earthbind Totem"] = {cooldown = 15, desc = "Summons an Earthbind Totem with 5 health at the feet of the caster for 45 sec that slows the movement speed of enemies within 10 yards.", icon = "Spell_Nature_StrengthOfEarthTotem02"},
	["Fire Nova Totem"] = {cooldown = 15, desc = "Summons a Fire Nova Totem that has 5 health and lasts 5 sec. Unless it is destroyed within 4 sec., the totem inflicts 396 to 442 fire damage to enemies within 10 yd.", icon = "Spell_Fire_SealOfFire"},
	["Flame Shock"] = {cooldown = 6, desc = "Instantly sears the target with fire, causing 292 Fire damage immediately and 320 Fire damage over 12 sec.", icon = "Spell_Fire_FlameShock"},
	["Frost Shock"] = {cooldown = 6, desc = "Instantly shocks the target with frost, causing 486 to 514 Frost damage and slowing movement speed by 50%. Lasts 8 sec.", icon = "Spell_Frost_FrostShock"},
	["Stoneclaw Totem"] = {cooldown = 30, desc = "Summons a Stoneclaw Totem with 480 health at the feet of the caster for 15 sec that taunts creatures within 8 yards to attack it.", icon = "Spell_Nature_StoneClawTotem"},
	["Astral Recall"] = {cooldown = 15*60, desc = "Yanks the caster through the twisting nether back to [home]. Speak to an Innkeeper in a different place to change your home location.", icon = "Spell_Nature_AstralRecal"},
	["Grounding Totem"] = {cooldown = 15, desc = "Summons a Grounding Totem with 5 health at the feet of the caster that will redirect one harmful spell cast on a nearby party member to itself every 10 seconds. Will not redirect area of effect spells. Lasts 45 sec.", icon = "Spell_Nature_GroundingTotem"},
	["Mana Tide Totem"] = {cooldown = 5*60, desc = "Summons a Mana Tide Totem with 5 health at the feet of the caster for 12 sec that restores 290 mana every 3 seconds to group members within 20 yards.", icon = "Spell_Frost_SummonWaterElemental"},

	["Elemental Mastery"] = {cooldown = 3*60, desc = "Unknown!", icon = "Spell_Nature_WispHeal"},
	["Stormstrike"] = {cooldown = 20, desc = "Unknown!", icon = "Spell_Holy_SealOfMight"},
	["Nature's Swiftness"] = {cooldown = 3*60, desc = "Unknown!", icon = "Spell_Nature_RavenForm"},

	-- Hunters
	["Scare Beast"] = {cooldown = 30, desc = "Scares a beast, causing it to run in fear for up to 20 sec. Damage caused may interrupt the effect. Only one beast can be feared at a time.", icon = "Ability_Druid_Cower"},
	["Tranquilizing Shot"] = {cooldown = 20, desc = "Attempts to remove 1 Frenzy effect from an enemy creature.", icon = "Spell_Nature_Drowsy"},
	["Arcane Shot"] = {cooldown = 6, desc = "An instant shot that causes 183 Arcane damage.", icon = "Ability_ImpalingBolt"},
	["Concussive Shot"] = {cooldown = 12, desc = "Dazes the target, slowing movement speed by 50% for 4 sec.", icon = "Spell_Frost_Stun"},
	["Distracting Shot"] = {cooldown = 8, desc = "Distract the target, causing threat.", icon = "Spell_Arcane_Blink"},
	["Flare"] = {cooldown = 15, desc = "Exposes all hidden and invisible enemies within 10 yards of the targeted area for 30 sec.", icon = "Spell_Fire_Flare"},
	["Multi-Shot"] = {cooldown = 10, desc = "Fires several missiles, hitting 3 targets for an additional 150 damage.", icon = "Ability_UpgradeMoonGlaive"},
	["Rapid Fire"] = {cooldown = 5*60, desc = "Increases ranged attack speed by 40% for 15 sec.", icon = "Ability_Hunter_RunningShot"},
	["Volley"] = {cooldown = 60, desc = "Continuously fires a volley of ammo at the target area, causing 80 Arcane damage to enemy targets within 8 yards every second for 6 sec.", icon = "Ability_Marksmanship"},
	["Counterattack"] = {cooldown = 5, desc = "A strike that becomes active after parrying an opponent's attack. This attack deals 110 damage and immobilizes the target for 5 sec. Counterattack cannot be blocked, dodged, or parried.", icon = "Ability_Warrior_Challange"},
	["Disengage"] = {cooldown = 5, desc = "Attempts to disengage from the target, reducing threat. More effective than Disengage (Rank 2). Character exits combat mode.", icon = "Ability_Rogue_Feint"},
	["Explosive Trap"] = {cooldown = 15, desc = "Place a fire trap that explodes when an enemy approaches, causing 201 to 257 Fire damage and 330 additional Fire damage over 20 sec to all within 10 yards. Trap will exist for 1 min. Traps can only be placed when out of combat. Only one trap can be active at a time.", icon = "Spell_Fire_SelfDestruct"},
	["Feign Death"] = {cooldown = 30, desc = "Feign death which may trick enemies into ignoring you. Lasts up to 6 min.", icon = "Ability_Rogue_FeignDeath"},
	["Freezing Trap"] = {cooldown = 15, desc = "Place a frost trap that freezes the first enemy that approaches, preventing all action for up to 20 sec. Any damage caused will break the ice. Trap will exist for 1 min. Traps can only be placed when out of combat. Only one trap can be active at a time.", icon = "Spell_Frost_ChainsOfIce"},
	["Frost Trap"] = {cooldown = 15, desc = "Place a frost trap that creates an ice slick around itself for 30 sec when the first enemy approaches it. All enemies within 10 yards will be slowed by 60% while in the area of effect. Trap will exist for 1 min. Traps can only be placed when out of combat. Only one trap can be active at a time.", icon = "Spell_Frost_FreezingBreath"},
	["Immolation Trap"] = {cooldown = 15, desc = "Place a fire trap that will burn the first enemy to approach for 690 Fire damage over 15 sec. Trap will exist for 1 min. Traps can only be placed when out of combat. Only one trap can be active at a time.", icon = "Spell_Fire_FlameShock"},
	["Mongoose Bite"] = {cooldown = 5, desc = "Counterattack the enemy for 115 damage. Can only be performed after you dodge.", icon = "Ability_Hunter_SwiftStrike"},
	["Raptor Strike"] = {cooldown = 6, desc = "A strong attack that increases melee damage by 140.", icon = "Ability_MeleeDamage"},
	["Wyvern Sting"] = {cooldown = 2*60, desc = "A stinging shot that puts the target to sleep for 12 sec. Any damage will cancel the effect. When the target wakes up, the Sting causes 600 Nature damage over 12 sec. Only usable out of combat. Only one Sting per Hunter can be active on the target at a time.", icon = "INV_Spear_02"},

	["Bestial Wrath"] = {cooldown = 2*60, desc = "Unknown!", icon = "Ability_Druid_FerociousBite"},
	["Intimidation"] = {cooldown = 60, desc = "Unknown!", icon = "Ability_Devour"},
	["Detterance"] = {cooldown = 5*60, desc = "Unknown!", icon = "Ability_Whirlwind"},
	["Scattershot"] = {cooldown = 30, desc = "Unknown!", icon = "Ability_GolemStormBolt"},

	-- Warlocks
	["Curse of Doom"] = {cooldown = 60, desc = "Curses the target with impending doom, causing 3200 Shadow damage after 1 min. If the target dies from this damage, there is a chance that a Doomguard will be summoned. Cannot be cast on players.", icon = "Spell_Shadow_AuraOfDarkness"},
	["Death Coil"] = {cooldown = 2*60, desc = "Causes the enemy target to run in horror for 3 sec and causes 470 Shadow damage. The caster gains 100% of the damage caused in health.", icon = "Spell_Shadow_DeathCoil"},
	["Howl of Terror"] = {cooldown = 40, desc = "Howl, causing 5 enemies within 10 yds to flee in terror for 15 sec. Damage caused may interrupt the effect.", icon = "Spell_Shadow_DeathScream"},
	["Inferno"] = {cooldown = 60*60, desc = "Summons a meteor from the Twisting Nether, causing 200 Fire damage and stunning all enemy targets in the area for 2 sec. An Infernal rises from the crater, under the command of the caster for 5 min. Once control is lost, the Infernal must be Enslaved to maintain control. Can only be used outdoors.", icon = "Spell_Shadow_SummonInfernal"},
	["Ritual of Doom"] = {cooldown = 60*60, desc = "Begins a ritual that sacrifices a random participant to summon a doomguard. The doomguard must be immediately enslaved or it will attack the ritual participants. Requires the caster and 4 additional party members to complete the ritual. In order to participate, all players must right-click the portal and not move until the ritual is complete.", icon = "Spell_Shadow_AntiMagicShell"},
	["Shadow Ward"] = {cooldown = 30, desc = "Absorbs 920 shadow damage. Lasts 30 sec.", icon = "Spell_Shadow_AntiShadow"},
	["Conflagrate"] = {cooldown = 10, desc = "Ignites a target that is already afflicted by Immolate, dealing 447 to 557 Fire damage and consuming the Immolate spell.", icon = "Spell_Fire_Fireball"},
	["Shadowburn"] = {cooldown = 15, desc = "Instantly blasts the target for 450 to 502 Shadow damage. If the target dies within 5 sec of Shadowburn, and yields experience or honor, the caster gains a Soul Shard.", icon = "Spell_Shadow_ScourgeBuild"},
	["Soul Fire"] = {cooldown = 60, desc = "Burn the enemy's soul, causing 703 to 881 Fire damage.", icon = "Spell_Fire_Fireball02"},
	["Devour Magic"] = {cooldown = 8, desc = "Purges 1 harmful magic effect from a friend or 1 beneficial magic effect from an enemy. If an effect is devoured, the Felhunter will be healed for 579.", icon = "Spell_Nature_Purge"},
	["Spell Loc"] = {cooldown = 30, desc = "Silences the enemy for 3 sec. If used on a casting target, it will counter the enemy's spellcast, preventing any spell from that school of magic from being cast for 8 sec.", icon = "Spell_Shadow_MindRot"},
	["Lash of Pain"] = {cooldown = 12, desc = "An instant attack that lashes the target, causing 99 Shadow damage.", icon = "Spell_Shadow_Curse"},
	["Soothing Kiss"] = {cooldown = 4, desc = "Soothes the target, increasing the chance that it will attack something else. More effective than Soothing Kiss (Rank 3).", icon = "Spell_Shadow_SoothingKiss"},

	["Fel Domination"] = {cooldown = 15*60, desc = "Unknown!", icon = "Spell_Nature_RemoveCurse"},

	-- Priest
	["Elune's Grace"] = {cooldown = 5*60, desc = "Reduces ranged damage taken by 95 and increases chance to dodge by 10% for 15 sec.", icon = "Spell_Holy_ElunesGrace"},
	["Feedback"] = {cooldown = 3*60, desc = "The priest becomes surrounded with anti-magic energy. Any successful spell cast against the priest will burn 105 of the attacker's Mana, causing 1 Shadow damage for each point of Mana burned. Lasts 15 sec.", icon = "Spell_Shadow_RitualOfSacrifice"},
	["Power Word: Shield"] = {cooldown = 4, desc = "Draws on the soul of the party member to shield them, absorbing 942 damage. Lasts 30 sec. While the shield holds, spellcasting will not be interrupted by damage. Once shielded, the target cannot be shielded again for 15 sec.", icon = "Spell_Holy_PowerWordShield"},
	["Desperate Prayer"] = {cooldown = 10*60, desc = "Instantly heals the caster for 1324 to 1562.", icon = "Spell_Holy_Restoration"},
	["Fear Ward"] = {cooldown = 30, desc = "Wards the friendly target against Fear. The next Fear effect used against the target will fail, using up the ward. Lasts 10 min.", icon = "Spell_Holy_Excorcism"},
	["Devouring Plague"] = {cooldown = 3*60, desc = "Afflicts the target with a disease that causes 904 Shadow damage over 24 sec. Damage caused by the Devouring Plague heals the caster.", icon = "Spell_Shadow_BlackPlague"},
	["Fade"] = {cooldown = 30, desc = "Fade out, discouraging enemies from attacking you for 10 sec. More effective than Fade (rank 5).", icon = "Spell_Magic_LesserInvisibilty"},
	["Mind Blast"] = {cooldown = 8, desc = "Blasts the target for 503 to 531 Shadow damage, but causes a high amount of threat.", icon = "Spell_Shadow_UnholyFrenzy"},
	["Psychic Scream"] = {cooldown = 30, desc = "The caster lets out a psychic scream, causing 5 enemies within 8 yards to flee for 8 sec. Damage caused may interrupt the effect.", icon = "Spell_Shadow_PsychicScream"},

	["Inner Focus"] = {cooldown = 3*60, desc = "Unknown!", icon = "Spell_Frost_WindWalkOn"},
	["Power Infusion"] = {cooldown = 3*60, desc = "Unknown!", icon = "Spell_Holy_PowerInfusion"},
	["Silence"] = {cooldown = 45, desc = "Unknown!", icon = "Spell_Shadow_ImpPhaseShift"},

	-- Druid
	["Barkskin"] = {cooldown = 60, desc = "The druid's skin becomes as tough as bark. Physical damage taken is reduced by 20%. While protected, damaging attacks will not cause spellcasting delays but non-instant spells take 1 sec longer to cast and melee combat is slowed by 20%. Lasts 15 sec.", icon = "Spell_Nature_StoneClawTotem"},
	["Faerie Fire"] = {cooldown = 6, desc = "Decrease the armor of the target by 505 for 40 sec. While affected, the target cannot stealth or turn invisible.", icon = "Spell_Nature_FaerieFire"},
	["Hurricane"] = {cooldown = 60, desc = "Creates a violent storm in the target area causing 134 Nature damage to enemies every 1 sec, and reducing the attack speed of enemies by 20%. Lasts 10 sec. Druid must channel to maintain the spell.", icon = "Spell_Nature_Cyclone"},
	["Nature's Grasp"] = {cooldown = 60, desc = "While active, any time an enemy strikes the caster they have a 35% chance to become afflicted by Entangling Roots (Rank 6). Only useable outdoors. 1 charge. Lasts 45 sec.", icon = "Spell_Nature_NaturesWrath"},
	["Bash"] = {cooldown = 60, desc = "Stuns the target for 4 sec.", icon = "Ability_Druid_Bash"},
	["Challenging Roar"] = {cooldown = 10*60, desc = "Forces all nearby enemies to focus attacks on you for 6 sec.", icon = "Ability_Druid_ChallangingRoar"},
	["Cower"] = {cooldown = 10, desc = "Cower, causing no damage but lowering your threat a large amount, making the enemy less likely to attack you.", icon = "Ability_Druid_Cower"},
	["Dash"] = {cooldown = 5*60, desc = "Increases movement speed by 60% for 15 sec. Does not break prowling.", icon = "Ability_Druid_Dash"},
	["Enrage"] = {cooldown = 60, desc = "Generates 20 rage over 10 sec, but reduces base armor by 27% in Bear Form and 16% in Dire Bear Form. The druid is considered in combat for the duration.", icon = "Ability_Druid_Enrage"},
	["Frenzied Regeneration"] = {cooldown = 3*60, desc = "Converts up to 10 rage per second into health for 10 sec. Each point of rage is converted into 20 health.", icon = "Ability_BullRush"},
	["Prowl"] = {cooldown = 10, desc = "Allows the Druid to prowl around, but reduces your movement speed by 30%. Lasts until cancelled.", icon = "Ability_Ambush"},
	["Tiger's Fury"] = {cooldown = 1, desc = "Increases damage done by 40 for 6 sec.", icon = "Ability_Mount_JungleTiger"},
	["Rebirth"] = {cooldown = 30*60, desc = "Returns the spirit to the body, restoring a dead target to life with 2200 health and 2800 mana.", icon = "Spell_Nature_Reincarnation"},
	["Tranquility"] = {cooldown = 5*60, desc = "Regenerates all nearby group members for 294 every 2 seconds for 10 sec. Druid must channel to maintain the spell.", icon = "Spell_Nature_Tranquility"},
	["Innervate"] = {cooldown = 6*60, desc = "Increases the target's Mana regeneration by 400% and allows 100% of the target's Mana regeneration to continue while casting. Lasts 20 sec.", icon = "Spell_Nature_Lightning"},

	["Faerie Fire (Feral)"] = {cooldown = 6, desc = "Unknown!", icon = "Spell_Nature_FaerieFire"},
	["Feral Charge"] = {cooldown = 15, desc = "Unknown!", icon = "Ability_Hunter_Pet_Bear"},
	-- {cooldown = 3*60, desc = "Unknown!", icon = "Spell_Nature_RavenForm"},
	["Swiftmend"] = {cooldown = 15, desc = "Unknown!", icon = "Inv_Relics_IdolOfRejuvenation"},
}

local ENEMY_COMBAT_LOG_EVENTS = {
	'CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE',
	'CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE',
	'CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE',
	'CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE',
	'CHAT_MSG_SPELL_PARTY_DAMAGE',
	'CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE',
	'CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE',
	'CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS',
	'CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS',
	'CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS',
	'CHAT_MSG_SPELL_PARTY_BUFF',
	'CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF',
	'CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF',
}

local ENEMY_COMBAT_LOG_PATTERNS = {
	"(.+) performs (.+)%.",
	"(.+) performs (.+) on ",
	"(.+) casts (.+)%.",
	"(.+) casts (.+) on ",
	"(.+) gains (.+)%.",
	"(.+) gains .+ Rage from .+'s (Charge)%.",
	"(.+)'s (.+) hits ",
	"(.+)'s (.+) crits ",
	"(.+)'s (.+) heals ",
	"(.+)'s (.+) critically ",
	"(.+)'s (.+) was ",
	"(.+)'s (.+) misses ",
	"(.+)'s (.+) missed ",
	"(.+)'s (.+) is absorbed ",
	" absorb (.+)'s (.+)%.",
	" resists (.+)'s (.+)%.",
	" resist (.+)'s (.+)%.",
	" immune to (.+)'s (.+)%.",
}

function CDC:EnemySetup()
	for _, event in ENEMY_COMBAT_LOG_EVENTS do
		self[event] = self.OnCombatLogEvent
		self:RegisterEvent(event)
	end
	self:RegisterEvent('PLAYER_TARGET_CHANGED')
end

function CDC:OnCombatLogEvent()
	for _, pattern in ENEMY_COMBAT_LOG_PATTERNS do
		for player, spell in string.gfind(arg1, pattern) do
			CDC:StartEnemyCD(player, spell, GetTime())
		end
	end
end

function CDC:ShowEnemyCD(CD)
	if not CD.ID then
		CD.ID = self.enemyFrame:StartCD(CD.skill, ENEMY_SKILLS[CD.skill].desc, ENEMY_SKILLS[CD.skill].icon, CD.started + ENEMY_SKILLS[CD.skill].cooldown)
	end
end

function CDC:HideEnemyCD(CD)
	if CD.ID then
		self.enemyFrame:CancelCD(CD.ID)
		CD.ID = nil
	end
end

do
	local active = {}

	function CDC:StartEnemyCD(player, skill, started)
		if ENEMY_SKILLS[skill] then
			local trigger = ENEMY_SKILLS[skill].trigger
			if trigger then
				trigger(player)
			end

			local key = player..'|'..skill
			if active[key] then
				self:HideEnemyCD(active[key])
			end
			active[key] = {
				skill = skill,
				player = player,
				started = started,
			}
			if player == UnitName('target') then
				self:ShowEnemyCD(active[key])
			end
		end
	end

	function CDC:StopEnemyCDs(player, ...)
		for i=1,arg.n do
			local key = player..'|'..arg[i]
			if active[key] and active[key].ID then
				self.enemyFrame:CancelCD(active[key].ID)
			end
			active[key] = nil
		end
	end

	function CDC:PLAYER_TARGET_CHANGED()
		local CDs = {}
		for _, CD in active do
			tinsert(CDs, CD)
		end

		for _, CD in CDs do
			if CD.started + ENEMY_SKILLS[CD.skill].cooldown <= GetTime() then
				active[CD.player..'|'..CD.skill] = nil
			elseif UnitName('target') == CD.player then
				if UnitClass('target') == 'Warrior' and CD.skill == 'Enrage' then
					self:StopEnemyCDs(CD.player, CD.skill)
				elseif not CD.ID then
					self:ShowEnemyCD(CD)
				end
			elseif CD.ID then
				self:HideEnemyCD(CD)
			end
		end
	end
end