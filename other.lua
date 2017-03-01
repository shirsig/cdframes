module 'cdframes.other'

include 'T'
include 'cdframes'

local DATA = {
	-- Trinkets & Racials
	["Will of the Forsaken"] = {duration = 2*60, icon = "Spell_Shadow_RaiseDead"},
	["Perception"] = {duration = 3*60, icon = "Spell_Nature_Sleep"},
	["War Stomp"] = {duration = 2*60, icon = "Ability_WarStomp"},
	["Escape Artist"] = {duration = 60, icon = "Ability_Rogue_Trip"},
	["Stoneform"] = {duration = 3*60, icon = "Spell_Shadow_UnholyStrength"},

	["Brittle Armor"] = {duration = 2*60, icon = "Spell_Shadow_GrimWard"},
	["Unstable Power"] = {duration = 2*60, icon = "Spell_Lightning_LightningBolt01"},
	["Restless Strength"] = {duration = 2*60, icon = "Spell_Shadow_GrimWard"},
	["Ephemeral Power"] = {duration = 90, icon = "Spell_Holy_MindVision"},
	["Massive Destruction"] = {duration = 3*60, icon = "Spell_Fire_WindsofWoe"},
	["Arcane Potency"] = {duration = 3*60, icon = "Spell_Arcane_StarFire"},
	["Energized Shield"] = {duration = 3*60, icon = "Spell_Nature_CallStorm"},
	["Brilliant Light"] = {duration = 3*60, icon = "Spell_Holy_MindVision"},
	["Mar'li's Brain Boost"] = {duration = 3*60, icon = "INV_ZulGurubTrinket"},
	["Gift of Life"] = {duration = 5*60, icon = "INV_Misc_Gem_Pearl_05"},
	["Nature Aligned"] = {duration = 5*60, icon = "Spell_Nature_SpiritArmor"},
	["Earthstrike"] = {duration = 2*60, icon = "Spell_Nature_AbolishMagic"},
	["Tidal Charm"] = {duration = 15*60, icon = "INV_Misc_Rune_01"},
	["Aura of Protection"] = {duration = 30*60, icon = "INV_Misc_ArmorKit_04"},

	["Frost Reflector"] = {duration = 5*60, icon = "Spell_Frost_FrostWard"},
	["Shadow Reflector"] = {duration = 5*60, icon = "Spell_Shadow_AntiShadow"},
	["Fire Reflector"] = {duration = 5*60, icon = "Spell_Fire_SealOfFire"},

	["First Aid"] = {duration = 60, icon = "Spell_Holy_Heal"},

	-- Warrior
	["Charge"] = {duration = 15, icon = "Ability_Warrior_Charge", classes = 'Warrior'},
	["Mocking Blow"] = {duration = 2*60, icon = "Ability_Warrior_PunishingBlow", classes = 'Warrior'},
	["Mortal Strike"] = {duration = 6, icon = "Ability_Warrior_SavageBlow", classes = 'Warrior'},
	["Overpower"] = {duration = 5, icon = "Ability_MeleeDamage", classes = 'Warrior'},
	["Retaliation"] = {duration = 30*60, icon = "Ability_Warrior_Challange", classes = 'Warrior'},
	["Thunder Clap"] = {duration = 4, icon = "Spell_Nature_ThunderClap", classes = 'Warrior'},
	["Berserker Rage"] = {duration = 30, icon = "Spell_Nature_AncestralGuardian", classes = 'Warrior'},
	["Bloodthirst"] = {duration = 6, icon = "Spell_Nature_BloodLust", classes = 'Warrior'},
	["Challenging Shout"] = {duration = 10*60, icon = "Ability_BullRush", classes = 'Warrior'},
	["Intercept Stun"] = {duration = 30, icon = "Ability_Rogue_Sprint", classes = 'Warrior'},
	["Intimidating Shout"] = {duration = 3*60, icon = "Ability_GolemThunderClap", classes = 'Warrior'},
	["Pummel"] = {duration = 10, icon = "INV_Gauntlets_04", classes = 'Warrior'},
	["Recklessness"] = {duration = 30*60, icon = "Ability_CriticalStrike", classes = 'Warrior'},
	["Whirlwind"] = {duration = 10, icon = "Ability_Whirlwind", classes = 'Warrior'},
	["Bloodrage"] = {duration = 60, icon = "Ability_Racial_BloodRage", classes = 'Warrior'},
	["Disarm"] = {duration = 60, icon = "Ability_Warrior_Disarm", classes = 'Warrior'},
	["Revenge"] = {duration = 5, icon = "Ability_Warrior_Revenge", classes = 'Warrior'},
	["Shield Bash"] = {duration = 12, icon = "Ability_Warrior_ShieldBash", classes = 'Warrior'},
	["Shield Block"] = {duration = 5, icon = "Ability_Defend", classes = 'Warrior'},
	["Shield Slam"] = {duration = 6, icon = "INV_Shield_05", classes = 'Warrior'},
	["Shield Wall"] = {duration = 30*60, icon = "Ability_Warrior_ShieldWall", classes = 'Warrior'},
	["Sweeping Strikes"] = {duration = 30, icon = "Ability_Rogue_SliceDice", classes = 'Warrior'},
	["Last Stand"] = {duration = 10*60, icon = "Spell_Holy_AshesToAshes", classes = 'Warrior'},
	["Death Wish"] = {duration = 3*60, icon = "Spell_Shadow_DeathPact", classes = 'Warrior'},

	-- Paladin
	["Consecration"] = {duration = 8, icon = "Spell_Holy_InnerFire", classes = 'Paladin'},
	["Exorcism"] = {duration = 15, icon = "Spell_Holy_Excorcism_02", classes = 'Paladin'},
	["Hammer of Wrath"] = {duration = 6, icon = "Ability_ThunderClap", classes = 'Paladin'},
	["Holy Wrath"] = {duration = 60, icon = "Spell_Holy_Excorcism", classes = 'Paladin'},
	["Lay on Hands"] = {duration = 60*60, icon = "Spell_Holy_LayOnHands", classes = 'Paladin'},
	["Turn Undead"] = {duration = 30, icon = "Spell_Holy_TurnUndead", classes = 'Paladin'},
	["Blessing of Freedom"] = {duration = 20, icon = "Spell_Holy_SealOfValor", classes = 'Paladin'},
	["Blessing of Protection"] = {duration = 5*60, icon = "Spell_Holy_SealOfProtection", classes = 'Paladin'},
	["Divine Intervention"] = {duration = 60*60, icon = "Spell_Nature_TimeStop", classes = 'Paladin'},
	["Divine Protection"] = {duration = 5*60, icon = "Spell_Holy_Restoration", classes = 'Paladin'},
	["Divine Shield"] = {duration = 5*60, icon = "Spell_Holy_DivineIntervention", classes = 'Paladin'},
	["Hammer of Justice"] = {duration = 60, icon = "Spell_Holy_SealOfMight", classes = 'Paladin'},
	["Judgement"] = {duration = 10, icon = "Spell_Holy_RighteousFury", classes = 'Paladin'},
	["Divine Favor"] = {duration = 2*60, icon = "Spell_Holy_Heal", classes = 'Paladin'},
	["Holy Shock"] = {duration = 30, icon = "Spell_Holy_SearingLight", classes = 'Paladin'},
	["Holy Shield"] = {duration = 10, icon = "Spell_Holy_BlessingOfProtection", classes = 'Paladin'},
	["Repentance"] = {duration = 60, icon = "Spell_Holy_PrayerOfHealing", classes = 'Paladin'},

	-- Mage
	["Blink"] = {duration = 15, icon = "Spell_Arcane_Blink", classes = 'Mage'},
	["Portal: Darnassus"] = {duration = 60, icon = "Spell_Arcane_PortalDarnassus", classes = 'Mage'},
	["Portal: Ironforge"] = {duration = 60, icon = "Spell_Arcane_PortalIronForge", classes = 'Mage'},
	["Portal: Orgrimmar"] = {duration = 60, icon = "Spell_Arcane_PortalOrgrimmar", classes = 'Mage'},
	["Portal: Stormwind"] = {duration = 60, icon = "Spell_Arcane_PortalStormWind", classes = 'Mage'},
	["Portal: Thunder Bluff"] = {duration = 60, icon = "Spell_Arcane_PortalThunderBluff", classes = 'Mage'},
	["Portal: Undercity"] = {duration = 60, icon = "Spell_Arcane_PortalUnderCity", classes = 'Mage'},
	["Blast Wave"] = {duration = 45, icon = "Spell_Holy_Excorcism_02", classes = 'Mage'},
	["Fire Blast"] = {duration = 8, icon = "Spell_Fire_Fireball", classes = 'Mage'},
	["Fire Ward"] = {duration = 30, icon = "Spell_Fire_FireArmor", classes = 'Mage'},
	["Cone of Cold"] = {duration = 10, icon = "Spell_Frost_Glacier", classes = 'Mage'},
	["Frost Nova"] = {duration = 25, icon = "Spell_Frost_FrostNova", classes = 'Mage'},
	["Frost Ward"] = {duration = 30, icon = "Spell_Frost_FrostWard", classes = 'Mage'},
	["Ice Barrier"] = {duration = 30, icon = "Spell_Ice_Lament", classes = 'Mage'},
	["Counterspell - Silenced"] = {duration = 30, icon = "Spell_Frost_IceShock", classes = 'Mage'},
	["Presence of Mind"] = {duration = 3*60, icon = "Spell_Nature_EnchantArmor", classes = 'Mage'},
	["Arcane Power"] = {duration = 3*60, icon = "Spell_Nature_Lightning", classes = 'Mage'},
	["Combustion"] = {duration = 3*60, icon = "Spell_Fire_SealOfFire", classes = 'Mage'},
	["Cold Snap"] = {duration = 10*60, icon = "Spell_Frost_WizardMark", classes = 'Mage'},
	["Ice Block"] = {duration = 5*60, icon = "Spell_Frost_Frost", classes = 'Mage'},

	-- Rogue
	["Kidney Shot"] = {duration = 20, icon = "Ability_Rogue_KidneyShot", classes = 'Rogue'},
	["Evasion"] = {duration = 5*60, icon = "Spell_Shadow_ShadowWard", classes = 'Rogue'},
	["Feint"] = {duration = 10, icon = "Ability_Rogue_Feint", classes = 'Rogue'},
	["Gouge"] = {duration = 10, icon = "Ability_Gouge", classes = 'Rogue'},
	["Kick"] = {duration = 10, icon = "Ability_Kick", classes = 'Rogue'},
	["Sprint"] = {duration = 5*60, icon = "Ability_Rogue_Sprint", classes = 'Rogue'},
	["Blind"] = {duration = 5*60, icon = "Spell_Shadow_MindSteal", classes = 'Rogue'},
	["Distract"] = {duration = 30, icon = "Ability_Rogue_Distract", classes = 'Rogue'},
	["Stealth"] = {duration = 10, icon = "Ability_Stealth", classes = 'Rogue'},
	["Vanish"] = {duration = 5*60, icon = "Ability_Vanish", classes = 'Rogue'},
	["Blade Flurry"] = {duration = 2*60, icon = "Ability_Warrior_PunishingBlow", classes = 'Rogue'},
	["Adrenaline Rush"] = {duration = 6*60, icon = "Spell_Shadow_ShadowWordDominate", classes = 'Rogue'},
	["Preparation"] = {duration = 10*60, icon = "Spell_Shadow_AntiShadow", classes = 'Rogue'},
	["Ghostly Strike"] = {duration = 20, icon = "Spell_Shadow_Curse", classes = 'Rogue'},
	["Premeditation"] = {duration = 60, icon = "Spell_Shadow_Possession", classes = 'Rogue'},
	["Cold Blood"] = {duration = 3*60, icon = "Spell_Ice_Lament", classes = 'Rogue'},

	-- Shaman
	["Chain Lightning"] = {duration = 6, icon = "Spell_Nature_ChainLightning", classes = 'Shaman'},
	["Earth Shock"] = {duration = 6, icon = "Spell_Nature_EarthShock", classes = 'Shaman'},
	["Earthbind Totem"] = {duration = 15, icon = "Spell_Nature_StrengthOfEarthTotem02", classes = 'Shaman'},
	["Fire Nova Totem"] = {duration = 15, icon = "Spell_Fire_SealOfFire", classes = 'Shaman'},
	["Flame Shock"] = {duration = 6, icon = "Spell_Fire_FlameShock", classes = 'Shaman'},
	["Frost Shock"] = {duration = 6, icon = "Spell_Frost_FrostShock", classes = 'Shaman'},
	["Stoneclaw Totem"] = {duration = 30, icon = "Spell_Nature_StoneClawTotem", classes = 'Shaman'},
	["Astral Recall"] = {duration = 15*60, icon = "Spell_Nature_AstralRecal", classes = 'Shaman'},
	["Grounding Totem"] = {duration = 15, icon = "Spell_Nature_GroundingTotem", classes = 'Shaman'},
	["Mana Tide Totem"] = {duration = 5*60, icon = "Spell_Frost_SummonWaterElemental", classes = 'Shaman'},
	["Elemental Mastery"] = {duration = 3*60, icon = "Spell_Nature_WispHeal", classes = 'Shaman'},
	["Stormstrike"] = {duration = 20, icon = "Spell_Holy_SealOfMight", classes = 'Shaman'},
	["Nature's Swiftness"] = {duration = 3*60, icon = "Spell_Nature_RavenForm", classes = 'Shaman,Druid'},

	-- Hunter
	["Scare Beast"] = {duration = 30, icon = "Ability_Druid_Cower", classes = 'Hunter'},
	["Tranquilizing Shot"] = {duration = 20, icon = "Spell_Nature_Drowsy", classes = 'Hunter'},
	["Arcane Shot"] = {duration = 6, icon = "Ability_ImpalingBolt", classes = 'Hunter'},
	["Concussive Shot"] = {duration = 12, icon = "Spell_Frost_Stun", classes = 'Hunter'},
	["Distracting Shot"] = {duration = 8, icon = "Spell_Arcane_Blink", classes = 'Hunter'},
	["Flare"] = {duration = 15, icon = "Spell_Fire_Flare", classes = 'Hunter'},
	["Multi-Shot"] = {duration = 10, icon = "Ability_UpgradeMoonGlaive", classes = 'Hunter'},
	["Rapid Fire"] = {duration = 5*60, icon = "Ability_Hunter_RunningShot", classes = 'Hunter'},
	["Volley"] = {duration = 60, icon = "Ability_Marksmanship", classes = 'Hunter'},
	["Counterattack"] = {duration = 5, icon = "Ability_Warrior_Challange", classes = 'Hunter'},
	["Disengage"] = {duration = 5, icon = "Ability_Rogue_Feint", classes = 'Hunter'},
	["Explosive Trap"] = {duration = 15, icon = "Spell_Fire_SelfDestruct", classes = 'Hunter'},
	["Feign Death"] = {duration = 30, icon = "Ability_Rogue_FeignDeath", classes = 'Hunter'},
	["Freezing Trap"] = {duration = 15, icon = "Spell_Frost_ChainsOfIce", classes = 'Hunter'},
	["Frost Trap"] = {duration = 15, icon = "Spell_Frost_FreezingBreath", classes = 'Hunter'},
	["Immolation Trap"] = {duration = 15, icon = "Spell_Fire_FlameShock", classes = 'Hunter'},
	["Mongoose Bite"] = {duration = 5, icon = "Ability_Hunter_SwiftStrike", classes = 'Hunter'},
	["Raptor Strike"] = {duration = 6, icon = "Ability_MeleeDamage", classes = 'Hunter'},
	["Wyvern Sting"] = {duration = 2*60, icon = "INV_Spear_02", classes = 'Hunter'},
	["Bestial Wrath"] = {duration = 2*60, icon = "Ability_Druid_FerociousBite", classes = 'Hunter'},
	["Intimidation"] = {duration = 60, icon = "Ability_Devour", classes = 'Hunter'},
	["Deterrence"] = {duration = 5*60, icon = "Ability_Whirlwind", classes = 'Hunter'},
	["Scatter Shot"] = {duration = 30, icon = "Ability_GolemStormBolt", classes = 'Hunter'},

	-- Warlock
	["Curse of Doom"] = {duration = 60, icon = "Spell_Shadow_AuraOfDarkness", classes = 'Warlock'},
	["Death Coil"] = {duration = 2*60, icon = "Spell_Shadow_DeathCoil", classes = 'Warlock'},
	["Howl of Terror"] = {duration = 40, icon = "Spell_Shadow_DeathScream", classes = 'Warlock'},
	["Inferno"] = {duration = 60*60, icon = "Spell_Shadow_SummonInfernal", classes = 'Warlock'},
	["Ritual of Doom"] = {duration = 60*60, icon = "Spell_Shadow_AntiMagicShell", classes = 'Warlock'},
	["Shadow Ward"] = {duration = 30, icon = "Spell_Shadow_AntiShadow", classes = 'Warlock'},
	["Conflagrate"] = {duration = 10, icon = "Spell_Fire_Fireball", classes = 'Warlock'},
	["Shadowburn"] = {duration = 15, icon = "Spell_Shadow_ScourgeBuild", classes = 'Warlock'},
	["Soul Fire"] = {duration = 60, icon = "Spell_Fire_Fireball02", classes = 'Warlock'},
	["Devour Magic"] = {duration = 8, icon = "Spell_Nature_Purge", classes = 'Warlock'},
	["Spell Loc"] = {duration = 30, icon = "Spell_Shadow_MindRot", classes = 'Warlock'},
	["Lash of Pain"] = {duration = 12, icon = "Spell_Shadow_Curse", classes = 'Warlock'},
	["Soothing Kiss"] = {duration = 4, icon = "Spell_Shadow_SoothingKiss", classes = 'Warlock'},
	["Fel Domination"] = {duration = 15*60, icon = "Spell_Nature_RemoveCurse", classes = 'Warlock'},
	["Spell Lock"] = {duration = 30, icon = "Spell_Nature_RemoveCurse", classes = 'Warlock'},

	-- Priest
	["Elune's Grace"] = {duration = 5*60, icon = "Spell_Holy_ElunesGrace", classes = 'Priest'},
	["Feedback"] = {duration = 3*60, icon = "Spell_Shadow_RitualOfSacrifice", classes = 'Priest'},
	["Power Word: Shield"] = {duration = 4, icon = "Spell_Holy_PowerWordShield", classes = 'Priest'},
	["Desperate Prayer"] = {duration = 10*60, icon = "Spell_Holy_Restoration", classes = 'Priest'},
	["Fear Ward"] = {duration = 30, icon = "Spell_Holy_Excorcism", classes = 'Priest'},
	["Devouring Plague"] = {duration = 3*60, icon = "Spell_Shadow_BlackPlague", classes = 'Priest'},
	["Fade"] = {duration = 30, icon = "Spell_Magic_LesserInvisibilty", classes = 'Priest'},
	["Mind Blast"] = {duration = 8, icon = "Spell_Shadow_UnholyFrenzy", classes = 'Priest'},
	["Psychic Scream"] = {duration = 30, icon = "Spell_Shadow_PsychicScream", classes = 'Priest'},
	["Inner Focus"] = {duration = 3*60, icon = "Spell_Frost_WindWalkOn", classes = 'Priest'},
	["Power Infusion"] = {duration = 3*60, icon = "Spell_Holy_PowerInfusion", classes = 'Priest'},
	["Silence"] = {duration = 45, icon = "Spell_Shadow_ImpPhaseShift", classes = 'Priest'},

	-- Druid
	["Barkskin"] = {duration = 60, icon = "Spell_Nature_StoneClawTotem", classes = 'Druid'},
	["Faerie Fire"] = {duration = 6, icon = "Spell_Nature_FaerieFire", classes = 'Druid'},
	["Hurricane"] = {duration = 60, icon = "Spell_Nature_Cyclone", classes = 'Druid'},
	["Nature's Grasp"] = {duration = 60, icon = "Spell_Nature_NaturesWrath", classes = 'Druid'},
	["Bash"] = {duration = 60, icon = "Ability_Druid_Bash", classes = 'Druid'},
	["Challenging Roar"] = {duration = 10*60, icon = "Ability_Druid_ChallangingRoar", classes = 'Druid'},
	["Cower"] = {duration = 10, icon = "Ability_Druid_Cower", classes = 'Druid'},
	["Dash"] = {duration = 5*60, icon = "Ability_Druid_Dash", classes = 'Druid'},
	["Enrage"] = {duration = 60, icon = "Ability_Druid_Enrage", classes = 'Druid'},
	["Frenzied Regeneration"] = {duration = 3*60, icon = "Ability_BullRush", classes = 'Druid'},
	["Prowl"] = {duration = 10, icon = "Ability_Ambush", classes = 'Druid'},
	["Tiger's Fury"] = {duration = 1, icon = "Ability_Mount_JungleTiger", classes = 'Druid'},
	["Rebirth"] = {duration = 30*60, icon = "Spell_Nature_Reincarnation", classes = 'Druid'},
	["Tranquility"] = {duration = 5*60, icon = "Spell_Nature_Tranquility", classes = 'Druid'},
	["Innervate"] = {duration = 6*60, icon = "Spell_Nature_Lightning", classes = 'Druid'},
	["Faerie Fire (Feral)"] = {duration = 6, icon = "Spell_Nature_FaerieFire", classes = 'Druid'},
	["Feral Charge"] = {duration = 15, icon = "Ability_Hunter_Pet_Bear", classes = 'Druid'},
	-- ["Nature's Swiftness"] = {duration = 3*60, icon = "Spell_Nature_RavenForm"},
	["Swiftmend"] = {duration = 15, icon = "Inv_Relics_IdolOfRejuvenation", classes = 'Druid'},
}

local PATTERNS = {
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

local PARTIAL_PATTERN = "You are afflicted by (.+)%."

local recent, class = {}, {}

do
	local t = {}
	function M.cooldowns(unit)
		local time = GetTime()
		if t[unit] then
			for k, v in t[unit] do
				if v.started + v.duration <= time or class[unit] and DATA[k].classes and not contains(DATA[k].classes, class[unit]) then
					release(t[unit][k])
					t[unit][k] = nil
				end
			end
			if not next(t[unit]) then
				release(t[unit])
				t[unit] = nil
			end
		end
		return t[unit] or empty
	end
	function start_cooldown(unit, action)
		triggers(unit, action)
		t[unit] = t[unit] or T
		t[unit][action] = O(
			'name', action,
			'icon', [[Interface\Icons\]] .. DATA[action].icon,
			'started', GetTime(),
			'duration', DATA[action].duration
		)
	end
	function stop_cooldowns(unit, ...)
		if t[unit] then
			for i = 1, arg.n do
				if t[unit][arg[i]] then
					release(t[unit][arg[i]])
					t[unit][arg[i]] = nil
				end
			end
		end
	end
end

function triggers(unit, action)
	if action == 'Preparation' then
		stop_cooldowns(unit, 'Kidney Shot', 'Evasion', 'Feint', 'Gouge', 'Kick', 'Sprint', 'Blind', 'Distract', 'Stealth', 'Blade Flurry', 'Adrenaline Rush', 'Ghostly Strike', 'Premeditation', 'Cold Blood')
	elseif action == 'Cold Snap' then
		stop_cooldowns(unit, 'Ice Block', 'Cone of Cold', 'Frost Ward', 'Ice Barrier', 'Frost Nova')
	end
end

do
	local f = CreateFrame'Frame'
	for _, event in {
		'CHAT_MSG_SPELL_PARTY_DAMAGE',
		'CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE',
		'CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE',
		'CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE',
		'CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE',
		'CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE',
		'CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE',
		'CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS',
		'CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS',
		'CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS',
		'CHAT_MSG_SPELL_PARTY_BUFF',
		'CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF',
		'CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF',
	} do f:RegisterEvent(event) end
	f:SetScript('OnEvent', function()
		for action in string.gfind(arg1, PARTIAL_PATTERN) do
			if DATA[action] then
				for _, enemy in recent do
					local cooldowns = cooldowns(enemy.name)
					if not (cooldowns and cooldowns[action]) and (not DATA[action].classes or contains(DATA[action].classes, enemy.class)) then
						start_cooldown(enemy.name, action)
						break
					end
				end
			end
		end
		for _, pattern in PATTERNS do
			for unit, action in string.gfind(arg1, pattern) do
				if DATA[action] then
					start_cooldown(unit, action)
					return
				end
			end
		end
	end)
end

do
	local f = CreateFrame'Frame'
	f:RegisterEvent'PLAYER_TARGET_CHANGED'
	f:SetScript('OnEvent', function()
		if UnitIsEnemy('player', 'target') and UnitIsPlayer'target' then
			for i, unit in recent do
				if i == 100 or unit.name == UnitName'target' then
					release(tremove(recent, i))
					break
				end
			end
			tinsert(recent, 1, O('name', UnitName'target', 'class', UnitClass'target'))
		end
	end)
end

do
	local f = CreateFrame'Frame'
	f:RegisterEvent'PLAYER_TARGET_CHANGED'
	f:RegisterEvent'UPDATE_MOUSEOVER_UNIT'
	f:SetScript('OnEvent', function()
		local unit = event == 'PLAYER_TARGET_CHANGED' and 'target' or 'mouseover'
		if UnitIsPlayer(unit) then
			class[UnitName(unit)] = UnitClass(unit)
		end
	end)
end