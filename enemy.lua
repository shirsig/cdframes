module 'cooldowns.enemy'

include 'T'
include 'cooldowns'

local cooldowns_frame = require 'cooldowns.frame'

local COOLDOWNS = {
	-- Trinkets & Racials
	["Will of the Forsaken"] = {duration = 2*60, desc = "Provides immunity to Charm, Fear and Sleep while active. May also be used while already afflicted by Charm, Fear or Sleep. Lasts 5 sec.", icon = "Spell_Shadow_RaiseDead"},
	["Perception"] = {duration = 3*60, desc = "Dramatically increases stealth detection for 20 sec.", icon = "Spell_Nature_Sleep"},
	["War Stomp"] = {duration = 2*60, desc = "Stuns up to 5 enemies within 8 yds for 2 sec.", icon = "Ability_WarStomp"},
	["Escape Artist"] = {duration = 60, desc = "Escape the effects of any immobilization or movement speed reduction effect.", icon = "Ability_Rogue_Trip"},
	["Stoneform"] = {duration = 3*60, desc = "While active, grants immunity to Bleed, Poison, and Disease effects. In addition, Armor increased by 10%. Lasts 8 sec.", icon = "Spell_Shadow_UnholyStrength"},

	["Brittle Armor"] = {duration = 2*60, desc = "Increases your armor by 2000 and defense skill by 30 for 20 sec. Every time you take melee or ranged damage, this bonus is reduced by 200 armor and 3 defense.", icon = "Spell_Shadow_GrimWard"},
	["Unstable Power"] = {duration = 2*60, desc = "Increases your spell damage by up to 204 and your healing by up to 408 for 20 sec. Every time you cast a spell, the bonus is reduced by 17 spell damage and 34 healing.", icon = "Spell_Lightning_LightningBolt01"},
	["Restless Strength"] = {duration = 2*60, desc = "Increases your melee and ranged damage by 40 for 20 sec. Every time you hit a target, this bonus is reduced by 2.", icon = "Spell_Shadow_GrimWard"},
	["Ephemeral Power"] = {duration = 90, desc = "Increases damage and healing done by magical spells and effects by up to 175 for 15 sec.", icon = "Spell_Holy_MindVision"},
	["Massive Destruction"] = {duration = 3*60, desc = "Increases the critical hit chance of your Destruction spells by 10% for 20 sec.", icon = "Spell_Fire_WindsofWoe"},
	["Arcane Potency"] = {duration = 3*60, desc = "Increases the critical hit chance of your Arcane spells by 5%, and increases the critical hit damage of your Arcane spells by 50% for 20 sec.", icon = "Spell_Arcane_StarFire"},
	["Energized Shield"] = {duration = 3*60, desc = "Increases the damage dealt by your Lightning Shield spell by 100% for 20 sec.", icon = "Spell_Nature_CallStorm"},
	["Brilliant Light"] = {duration = 3*60, desc = "Increases the critical hit chance of Holy spells by 10% for 15 sec.", icon = "Spell_Holy_MindVision"},
	["Mar'li's Brain Boost"] = {duration = 3*60, desc = "Restores 60 mana every 5 sec for 30 sec.", icon = "INV_ZulGurubTrinket"},
	["Gift of Life"] = {duration = 5*60, desc = "Heals yourself for 15% of your maximum health, and increases your maximum health by 15% for 20 sec.", icon = "INV_Misc_Gem_Pearl_05"},
	["Nature Aligned"] = {duration = 5*60, desc = "Aligns the Shaman with nature, increasing spell damage by 20%, improving heal effects by 20%, and increasing mana cost of spells by 20% for 20 sec.", icon = "Spell_Nature_SpiritArmor"},
	["Earthstrike"] = {duration = 2*60, desc = "Increases your melee and ranged attack power by 280. Effect lasts for 20 sec.", icon = "Spell_Nature_AbolishMagic"},
	["Tidal Charm"] = {duration = 15*60, desc = "Stuns target for 3 sec.", icon = "INV_Misc_Rune_01"},
	["Aura of Protection"] = {duration = 30*60, desc = "Absorbs 750 to 1251 damage. Lasts 20 sec.", icon = "INV_Misc_ArmorKit_04"},

	["Frost Reflector"] = {duration = 5*60, desc = "Reflects Frost spells back at their caster for 5 sec.", icon = "Spell_Frost_FrostWard"},
	["Shadow Reflector"] = {duration = 5*60, desc = "Reflects Shadow spells back at their caster for 5 sec.", icon = "Spell_Shadow_AntiShadow"},
	["Fire Reflector"] = {duration = 5*60, desc = "Reflects Fire spells back at their caster for 5 sec.", icon = "Spell_Fire_SealOfFire"},

	["First Aid"] = {duration = 60, desc = "Heals 2000 damage over 8 sec.", icon = "Spell_Holy_Heal"},

	-- Warrior
	["Charge"] = {duration = 15, desc = "Charge an enemy, generate 15 rage, and stun it for 1 sec. Cannot be used in combat.", icon = "Ability_Warrior_Charge", classes = 'Warrior'},
	["Mocking Blow"] = {duration = 2*60, desc = "A mocking attack that causes 93 damage, a moderate amount of threat and forces the target to focus attacks on you for 6 sec.", icon = "Ability_Warrior_PunishingBlow", classes = 'Warrior'},
	["Mortal Strike"] = {duration = 6, desc = "A vicious strike that deals weapon damage plus 160 and wounds the target, reducing the effectiveness of any healing by 50% for 10 sec.", icon = "Ability_Warrior_SavageBlow", classes = 'Warrior'},
	["Overpower"] = {duration = 5, desc = "Instantly overpower the enemy, causing weapon damage plus 35. Only useable after the target dodges. The Overpower cannot be blocked, dodged or parried.", icon = "Ability_MeleeDamage", classes = 'Warrior'},
	["Retaliation"] = {duration = 30*60, desc = "Instantly counterattack any enemy that strikes you in melee for 15 sec. Melee attacks made from behind cannot be counterattacked. A maximum of 30 attacks will cause retaliation.", icon = "Ability_Warrior_Challange", classes = 'Warrior'},
	["Thunder Clap"] = {duration = 4, desc = "Blasts nearby enemies with thunder slowing their attack speed by 10% for 30 sec and doing 103 damage to them. Will affect up to 4 targets.", icon = "Spell_Nature_ThunderClap", classes = 'Warrior'},
	["Berserker Rage"] = {duration = 30, desc = "The warrior enters a berserker rage, becoming immune to Fear and Incapacitate effects and generating extra rage when taking damage. Lasts 10 sec.", icon = "Spell_Nature_AncestralGuardian", classes = 'Warrior'},
	["Bloodthirst"] = {duration = 6, desc = "Instantly attack the target causing damage equal to 45% of your attack power. In addition, the next 5 successful melee attacks will restore 20 health. This effect lasts 8 sec.", icon = "Spell_Nature_BloodLust", classes = 'Warrior'},
	["Challenging Shout"] = {duration = 10*60, desc = "Forces all nearby enemies to focus attacks on you for 6 sec.", icon = "Ability_BullRush", classes = 'Warrior'},
	["Intercept Stun"] = {duration = 30, desc = "Charge an enemy, causing 65 damage and stunning it for 3 sec.", icon = "Ability_Rogue_Sprint", classes = 'Warrior'},
	["Intimidating Shout"] = {duration = 3*60, desc = "The warrior shouts, causing the targeted enemy to cower in fear. Up to 5 total nearby enemies will flee in fear. Lasts 8 sec.", icon = "Ability_GolemThunderClap", classes = 'Warrior'},
	["Pummel"] = {duration = 10, desc = "Pummel the target for 50 damage. It also interrupts spellcasting and prevents any spell in that school from being cast for 4 sec.", icon = "INV_Gauntlets_04", classes = 'Warrior'},
	["Recklessness"] = {duration = 30*60, desc = "The warrior will cause critical hits with most attacks and will be immune to Fear effects for the next 15 sec, but all damage taken is increased by 20%.", icon = "Ability_CriticalStrike", classes = 'Warrior'},
	["Whirlwind"] = {duration = 10, desc = "In a whirlwind of steel you attack up to 4 enemies within 8 yards, causing weapon damage to each enemy.", icon = "Ability_Whirlwind", classes = 'Warrior'},
	["Bloodrage"] = {duration = 60, desc = "Generates 10 rage at the cost of health, and then generates an additional 10 rage over 10 sec. The warrior is considered in combat for the duration.", icon = "Ability_Racial_BloodRage", classes = 'Warrior'},
	["Disarm"] = {duration = 60, desc = "Disarm the enemy's weapon for 10 sec.", icon = "Ability_Warrior_Disarm", classes = 'Warrior'},
	["Revenge"] = {duration = 5, desc = "Instantly counterattack an enemy for 81 to 99 damage and a high amount of threat. Revenge must follow a block, dodge or parry.", icon = "Ability_Warrior_Revenge", classes = 'Warrior'},
	["Shield Bash"] = {duration = 12, desc = "Bashes the target with your shield for 45 damage. It also interrupts spellcasting and prevents any spell in that school from being cast for 6 sec.", icon = "Ability_Warrior_ShieldBash", classes = 'Warrior'},
	["Shield Block"] = {duration = 5, desc = "Increases chance to block by 75% for 5 sec, but will only block 1 attack.", icon = "Ability_Defend", classes = 'Warrior'},
	["Shield Slam"] = {duration = 6, desc = "Slam the target with your shield, causing 342 to 358 damage, modified by your shield block value, and has a 50% chance of dispelling 1 magic effect on the target. Also causes a high amount of threat.", icon = "INV_Shield_05", classes = 'Warrior'},
	["Shield Wall"] = {duration = 30*60, desc = "Reduces the damage taken from melee attacks, ranged attacks and spells by 75% for 10 sec.", icon = "Ability_Warrior_ShieldWall", classes = 'Warrior'},

	["Sweeping Strikes"] = {duration = 30, desc = "Your next 5 melee attacks strike an additional nearby opponent.", icon = "Ability_Rogue_SliceDice", classes = 'Warrior'},
	["Last Stand"] = {duration = 10*60, desc = "When activated, this ability temporarily grants you 30% of your maximum hit points for 20 seconds. After the effect expires, the hit points are lost.", icon = "Spell_Holy_AshesToAshes", classes = 'Warrior'},
	["Death Wish"] = {duration = 3*60, desc = "When activated, increases your physical damage by 20% and makes you immune to Fear effects, but lowers your armor and all resistances by -20%. Lasts 30 sec.", icon = "Spell_Shadow_DeathPact", classes = 'Warrior'},

	-- Paladin
	["Consecration"] = {duration = 8, desc = "Consecrates the land beneath Paladin, doing 384 Holy damage over 8 sec to enemies who enter the area.", icon = "Spell_Holy_InnerFire", classes = 'Paladin'},
	["Exorcism"] = {duration = 15, desc = "Causes 505 to 563 Holy damage to an Undead or Demon target.", icon = "Spell_Holy_Excorcism_02", classes = 'Paladin'},
	["Hammer of Wrath"] = {duration = 6, desc = "Hurls a hammer that strikes an enemy for 304 to 336 Holy damage. Only usable on enemies that have 20% or less health.", icon = "Ability_ThunderClap", classes = 'Paladin'},
	["Holy Wrath"] = {duration = 60, desc = "Sends bolts of holy power in all directions, causing 490 to 576 Holy damage to all Undead and Demon targets within 20 yds.", icon = "Spell_Holy_Excorcism", classes = 'Paladin'},
	["Lay on Hands"] = {duration = 60*60, desc = "Heals a friendly target for an amount equal to the Paladin's maximum health and restores 550 of their mana. Drains all of the Paladin's remaining mana when used.", icon = "Spell_Holy_LayOnHands", classes = 'Paladin'},
	["Turn Undead"] = {duration = 30, desc = "The targeted undead enemy will be compelled to flee for up to 20 sec. Damage caused may interrupt the effect. Only one target can be turned at a time.", icon = "Spell_Holy_TurnUndead", classes = 'Paladin'},
	["Blessing of Freedom"] = {duration = 20, desc = "Places a Blessing on the friendly target, granting immunity to movement impairing effects for 10 sec. Players may only have one Blessing on them per Paladin at any one time.", icon = "Spell_Holy_SealOfValor", classes = 'Paladin'},
	["Blessing of Protection"] = {duration = 5*60, desc = "A targeted party member is protected from all physical attacks for 10 sec, but during that time they cannot attack or use physical abilities. Players may only have one Blessing on them per Paladin at any one time. Once protected, the target cannot be made invulnerable by Divine Shield, Divine Protection or Blessing of Protection again for 1 min.", icon = "Spell_Holy_SealOfProtection", classes = 'Paladin'},
	["Divine Intervention"] = {duration = 60*60, desc = "The paladin sacrifices himself to remove the targeted party member from harms way. Enemies will stop attacking the protected party member, who will be immune to all harmful attacks but cannot take any action for 3 min.", icon = "Spell_Nature_TimeStop", classes = 'Paladin'},
	["Divine Protection"] = {duration = 5*60, desc = "You are protected from all physical attacks and spells for 8 sec, but during that time you cannot attack or use physical abilities yourself. Once protected, the target cannot be made invulnerable by Divine Shield, Divine Protection or Blessing of Protection again for 1 min.", icon = "Spell_Holy_Restoration", classes = 'Paladin'},
	["Divine Shield"] = {duration = 5*60, desc = "Protects the paladin from all damage and spells for 12 sec, but reduces attack speed by 50%. Once protected, the target cannot be made invulnerable by Divine Shield, Divine Protection or Blessing of Protection again for 1 min.", icon = "Spell_Holy_DivineIntervention", classes = 'Paladin'},
	["Hammer of Justice"] = {duration = 60, desc = "Stuns the target for 6 sec.", icon = "Spell_Holy_SealOfMight", classes = 'Paladin'},
	["Judgement"] = {duration = 10, desc = "Unleashes the energy of a Seal spell upon an enemy. Refer to individual Seals for Judgement effect.", icon = "Spell_Holy_RighteousFury", classes = 'Paladin'},

	["Divine Favor"] = {duration = 2*60, desc = "When activated, gives your next Flash of Light, Holy Light, or Holy Shock spell a 100% critical effect chance.", icon = "Spell_Holy_Heal", classes = 'Paladin'},
	["Holy Shock"] = {duration = 30, desc = "Blasts the target with Holy energy, causing 365 to 396 Holy damage to an enemy, or 365 to 396 healing to an ally.", icon = "Spell_Holy_SearingLight", classes = 'Paladin'},
	["Holy Shield"] = {duration = 10, desc = "Increases chance to block by 30% for 10 sec, and deals 130 Holy damage for each attack blocked while active. Damage caused by Holy Shield causes 20% additional threat. Each block expends a charge. 4 charges.", icon = "Spell_Holy_BlessingOfProtection", classes = 'Paladin'},
	["Repentance"] = {duration = 60, desc = "Puts the enemy target in a state of meditation, incapacitating them for up to 6 sec. Any damage caused will awaken the target. Only works against Humanoids.", icon = "Spell_Holy_PrayerOfHealing", classes = 'Paladin'},

	-- Mage
	["Blink"] = {duration = 15, desc = "Teleports the caster 20 yards forward, unless something is in the way. Also frees the caster from stuns and bonds.", icon = "Spell_Arcane_Blink", classes = 'Mage'},
	["Portal: Darnassus"] = {duration = 60, desc = "Creates a portal, teleporting group members that use it to Darnassus.", icon = "Spell_Arcane_PortalDarnassus", classes = 'Mage'},
	["Portal: Ironforge"] = {duration = 60, desc = "Creates a portal, teleporting group members that use it to Ironforge.", icon = "Spell_Arcane_PortalIronForge", classes = 'Mage'},
	["Portal: Orgrimmar"] = {duration = 60, desc = "Creates a portal, teleporting group members that use it to Orgrimmar.", icon = "Spell_Arcane_PortalOrgrimmar", classes = 'Mage'},
	["Portal: Stormwind"] = {duration = 60, desc = "Creates a portal, teleporting group members that use it to Stormwind.", icon = "Spell_Arcane_PortalStormWind", classes = 'Mage'},
	["Portal: Thunder Bluff"] = {duration = 60, desc = "Creates a portal, teleporting group members that use it to Thunder Bluff.", icon = "Spell_Arcane_PortalThunderBluff", classes = 'Mage'},
	["Portal: Undercity"] = {duration = 60, desc = "Creates a portal, teleporting group members that use it to Undercity.", icon = "Spell_Arcane_PortalUnderCity", classes = 'Mage'},
	["Blast Wave"] = {duration = 45, desc = "A wave of flame radiates outward from the caster, damaging all enemies caught within the blast for 462 to 544 Fire damage, and dazing them for 6 sec.", icon = "Spell_Holy_Excorcism_02", classes = 'Mage'},
	["Fire Blast"] = {duration = 8, desc = "Blasts the enemy for 431 to 509 Fire damage.", icon = "Spell_Fire_Fireball", classes = 'Mage'},
	["Fire Ward"] = {duration = 30, desc = "Absorbs 920 Fire damage. Lasts 30 sec.", icon = "Spell_Fire_FireArmor", classes = 'Mage'},
	["Cone of Cold"] = {duration = 10, desc = "Targets in a cone in front of the caster take 335 to 365 Frost damage and are slowed by 50% for 8 sec.", icon = "Spell_Frost_Glacier", classes = 'Mage'},
	["Frost Nova"] = {duration = 25, desc = "Blasts enemies near the caster for 71 to 79 Frost damage and freezes them in place for up to 8 sec. Damage caused may interrupt the effect.", icon = "Spell_Frost_FrostNova", classes = 'Mage'},
	["Frost Ward"] = {duration = 30, desc = "Absorbs 920 Frost damage. Lasts 30 sec.", icon = "Spell_Frost_FrostWard", classes = 'Mage'},
	["Ice Barrier"] = {duration = 30, desc = "Instantly shields you, absorbing 818 damage. Lasts 1 min. While the shield holds, spells will not be interrupted.", icon = "Spell_Ice_Lament", classes = 'Mage'},
	["Counterspell"] = {duration = 30, desc = "Counters the enemy's spellcast, preventing any spell from that school of magic from being cast for 10 sec. Generates a high amount of threat.", icon = "Spell_Frost_IceShock", classes = 'Mage'},

	["Presence of Mind"] = {duration = 3*60, desc = "When activated, your next Mage spell with a casting time less than 10 sec becomes an instant cast spell.", icon = "Spell_Nature_EnchantArmor", classes = 'Mage'},
	["Arcane Power"] = {duration = 3*60, desc = "When activated, your spells deal 30% more damage while costing 30% more mana to cast. This effect lasts 15 sec.", icon = "Spell_Nature_Lightning", classes = 'Mage'},
	["Combustion"] = {duration = 3*60, desc = "When activated, this spell causes each of your Fire damage spell hits to increase your critical strike chance with Fire damage spells by 10%. This effect lasts until you have caused 3 critical strikes with Fire spells.", icon = "Spell_Fire_SealOfFire", classes = 'Mage'},
	["Cold Snap"] = {duration = 10*60, desc = "When activated, this spell finishes the cooldown on all of your Frost spells.", icon = "Spell_Frost_WizardMark", classes = 'Mage'},
	["Ice Block"] = {duration = 5*60, desc = "You become encased in a block of ice, protecting you from all physical attacks and spells for 10 sec, but during that time you cannot attack, move or cast spells.", icon = "Spell_Frost_Frost", classes = 'Mage'},

	-- Rogue
	["Kidney Shot"] = {duration = 20, desc = "Finishing move that stuns the target. Lasts longer per combo point.", icon = "Ability_Rogue_KidneyShot", classes = 'Rogue'},
	["Evasion"] = {duration = 5*60, desc = "The rogue's dodge chance will increase by 50% for 15 sec.", icon = "Spell_Shadow_ShadowWard", classes = 'Rogue'},
	["Feint"] = {duration = 10, desc = "Performs a feint, causing no damage but lowering your threat by a large amount, making the enemy less likely to attack you.", icon = "Ability_Rogue_Feint", classes = 'Rogue'},
	["Gouge"] = {duration = 10, desc = "Causes 75 damage, incapacitating the opponent for 4 sec, and turns off your attack. Target must be facing you. Any damage caused will revive the target. Awards 1 combo point.", icon = "Ability_Gouge", classes = 'Rogue'},
	["Kick"] = {duration = 10, desc = "A quick kick that injures a single foe for 80 damage. It also interrupts spellcasting and prevents any spell in that school from being cast for 5 sec.", icon = "Ability_Kick", classes = 'Rogue'},
	["Sprint"] = {duration = 5*60, desc = "Increases the rogue's movement speed by 70% for 15 sec. Does not break stealth.", icon = "Ability_Rogue_Sprint", classes = 'Rogue'},
	["Blind"] = {duration = 5*60, desc = "Blinds the target, causing it to wander disoriented for up to 10 sec. Any damage caused will remove the effect.", icon = "Spell_Shadow_MindSteal", classes = 'Rogue'},
	["Distract"] = {duration = 30, desc = "Throws a distraction, attracting the attention of all nearby monsters for 10 seconds. Does not break stealth.", icon = "Ability_Rogue_Distract", classes = 'Rogue'},
	["Stealth"] = {duration = 10, desc = "Allows the rogue to sneak around, but reduces your speed by 30%. Lasts until cancelled.", icon = "Ability_Stealth", classes = 'Rogue'},
	["Vanish"] = {duration = 5*60, desc = "Allows the rogue to vanish from sight, entering an improved stealth mode for 10 sec. Also breaks movement impairing effects. More effective than Vanish (Rank 1).", icon = "Ability_Vanish", classes = 'Rogue'},

	["Blade Flurry"] = {duration = 2*60, desc = "Increases your attack speed by 20%. In addition, attacks strike an additional nearby opponent. Lasts 15 sec.", icon = "Ability_Warrior_PunishingBlow", classes = 'Rogue'},
	["Adrenaline Rush"] = {duration = 6*60, desc = "Increases your Energy regeneration rate by 100% for 15 sec.", icon = "Spell_Shadow_ShadowWordDominate", classes = 'Rogue'},
	["Preparation"] = {duration = 10*60, desc = "When activated, this ability immediately finishes the cooldown of your other Rogue abilities.", icon = "Spell_Shadow_AntiShadow", classes = 'Rogue'},
	["Ghostly Strike"] = {duration = 20, desc = "A strike that deals 125% of weapon damage and increases your chance to dodge by 15% for 7 sec. Awards 1 combo points.", icon = "Spell_Shadow_Curse", classes = 'Rogue'},
	["Premeditation"] = {duration = 60, desc = "When used, adds two combo points to your target. You must add to or use those combo points within 10 sec or the combo points are lost.", icon = "Spell_Shadow_Possession", classes = 'Rogue'},
	["Cold Blood"] = {duration = 3*60, desc = "When activated, increases the critical strike chance of your next Sinister Strike, Backstab, Ambush, or Eviscerate by 100%.", icon = "Spell_Ice_Lament", classes = 'Rogue'},

	-- Shaman
	["Chain Lightning"] = {duration = 6, desc = "Hurls a lightning bolt at the enemy, dealing 493 to 551 Nature damage and then jumping to additional nearby enemies. Each jump reduces the damage by 30%. Affects 3 total targets.", icon = "Spell_Nature_ChainLightning", classes = 'Shaman'},
	["Earth Shock"] = {duration = 6, desc = "Instantly shocks the target with concussive force, causing 517 to 545 Nature damage. It also interrupts spellcasting and prevents any spell in that school from being cast for 2 sec. Causes a high amount of threat.", icon = "Spell_Nature_EarthShock", classes = 'Shaman'},
	["Earthbind Totem"] = {duration = 15, desc = "Summons an Earthbind Totem with 5 health at the feet of the caster for 45 sec that slows the movement speed of enemies within 10 yards.", icon = "Spell_Nature_StrengthOfEarthTotem02", classes = 'Shaman'},
	["Fire Nova Totem"] = {duration = 15, desc = "Summons a Fire Nova Totem that has 5 health and lasts 5 sec. Unless it is destroyed within 4 sec., the totem inflicts 396 to 442 fire damage to enemies within 10 yd.", icon = "Spell_Fire_SealOfFire", classes = 'Shaman'},
	["Flame Shock"] = {duration = 6, desc = "Instantly sears the target with fire, causing 292 Fire damage immediately and 320 Fire damage over 12 sec.", icon = "Spell_Fire_FlameShock", classes = 'Shaman'},
	["Frost Shock"] = {duration = 6, desc = "Instantly shocks the target with frost, causing 486 to 514 Frost damage and slowing movement speed by 50%. Lasts 8 sec.", icon = "Spell_Frost_FrostShock", classes = 'Shaman'},
	["Stoneclaw Totem"] = {duration = 30, desc = "Summons a Stoneclaw Totem with 480 health at the feet of the caster for 15 sec that taunts creatures within 8 yards to attack it.", icon = "Spell_Nature_StoneClawTotem", classes = 'Shaman'},
	["Astral Recall"] = {duration = 15*60, desc = "Yanks the caster through the twisting nether back to [home]. Speak to an Innkeeper in a different place to change your home location.", icon = "Spell_Nature_AstralRecal", classes = 'Shaman'},
	["Grounding Totem"] = {duration = 15, desc = "Summons a Grounding Totem with 5 health at the feet of the caster that will redirect one harmful spell cast on a nearby party member to itself every 10 seconds. Will not redirect area of effect spells. Lasts 45 sec.", icon = "Spell_Nature_GroundingTotem", classes = 'Shaman'},
	["Mana Tide Totem"] = {duration = 5*60, desc = "Summons a Mana Tide Totem with 5 health at the feet of the caster for 12 sec that restores 290 mana every 3 seconds to group members within 20 yards.", icon = "Spell_Frost_SummonWaterElemental", classes = 'Shaman'},

	["Elemental Mastery"] = {duration = 3*60, desc = "When activated, this spell gives your next Fire, Frost, or Nature damage spell a 100% critical strike chance and reduces the mana cost by 100%.", icon = "Spell_Nature_WispHeal", classes = 'Shaman'},
	["Stormstrike"] = {duration = 20, desc = "Gives you an extra attack. In addition, the next 2 sources of Nature damage dealt to the target are increased by 20%. Lasts 12 sec.", icon = "Spell_Holy_SealOfMight", classes = 'Shaman'},
	["Nature's Swiftness"] = {duration = 3*60, desc = "When activated, your next Nature spell with a casting time less than 10 sec. becomes an instant cast spell.", icon = "Spell_Nature_RavenForm", classes = 'Shaman,Druid'},

	-- Hunter
	["Scare Beast"] = {duration = 30, desc = "Scares a beast, causing it to run in fear for up to 20 sec. Damage caused may interrupt the effect. Only one beast can be feared at a time.", icon = "Ability_Druid_Cower", classes = 'Hunter'},
	["Tranquilizing Shot"] = {duration = 20, desc = "Attempts to remove 1 Frenzy effect from an enemy creature.", icon = "Spell_Nature_Drowsy", classes = 'Hunter'},
	["Arcane Shot"] = {duration = 6, desc = "An instant shot that causes 183 Arcane damage.", icon = "Ability_ImpalingBolt", classes = 'Hunter'},
	["Concussive Shot"] = {duration = 12, desc = "Dazes the target, slowing movement speed by 50% for 4 sec.", icon = "Spell_Frost_Stun", classes = 'Hunter'},
	["Distracting Shot"] = {duration = 8, desc = "Distract the target, causing threat.", icon = "Spell_Arcane_Blink", classes = 'Hunter'},
	["Flare"] = {duration = 15, desc = "Exposes all hidden and invisible enemies within 10 yards of the targeted area for 30 sec.", icon = "Spell_Fire_Flare", classes = 'Hunter'},
	["Multi-Shot"] = {duration = 10, desc = "Fires several missiles, hitting 3 targets for an additional 150 damage.", icon = "Ability_UpgradeMoonGlaive", classes = 'Hunter'},
	["Rapid Fire"] = {duration = 5*60, desc = "Increases ranged attack speed by 40% for 15 sec.", icon = "Ability_Hunter_RunningShot", classes = 'Hunter'},
	["Volley"] = {duration = 60, desc = "Continuously fires a volley of ammo at the target area, causing 80 Arcane damage to enemy targets within 8 yards every second for 6 sec.", icon = "Ability_Marksmanship", classes = 'Hunter'},
	["Counterattack"] = {duration = 5, desc = "A strike that becomes active after parrying an opponent's attack. This attack deals 110 damage and immobilizes the target for 5 sec. Counterattack cannot be blocked, dodged, or parried.", icon = "Ability_Warrior_Challange", classes = 'Hunter'},
	["Disengage"] = {duration = 5, desc = "Attempts to disengage from the target, reducing threat. More effective than Disengage (Rank 2). Character exits combat mode.", icon = "Ability_Rogue_Feint", classes = 'Hunter'},
	["Explosive Trap"] = {duration = 15, desc = "Place a fire trap that explodes when an enemy approaches, causing 201 to 257 Fire damage and 330 additional Fire damage over 20 sec to all within 10 yards. Trap will exist for 1 min. Traps can only be placed when out of combat. Only one trap can be active at a time.", icon = "Spell_Fire_SelfDestruct", classes = 'Hunter'},
	["Feign Death"] = {duration = 30, desc = "Feign death which may trick enemies into ignoring you. Lasts up to 6 min.", icon = "Ability_Rogue_FeignDeath", classes = 'Hunter'},
	["Freezing Trap"] = {duration = 15, desc = "Place a frost trap that freezes the first enemy that approaches, preventing all action for up to 20 sec. Any damage caused will break the ice. Trap will exist for 1 min. Traps can only be placed when out of combat. Only one trap can be active at a time.", icon = "Spell_Frost_ChainsOfIce", classes = 'Hunter'},
	["Frost Trap"] = {duration = 15, desc = "Place a frost trap that creates an ice slick around itself for 30 sec when the first enemy approaches it. All enemies within 10 yards will be slowed by 60% while in the area of effect. Trap will exist for 1 min. Traps can only be placed when out of combat. Only one trap can be active at a time.", icon = "Spell_Frost_FreezingBreath", classes = 'Hunter'},
	["Immolation Trap"] = {duration = 15, desc = "Place a fire trap that will burn the first enemy to approach for 690 Fire damage over 15 sec. Trap will exist for 1 min. Traps can only be placed when out of combat. Only one trap can be active at a time.", icon = "Spell_Fire_FlameShock", classes = 'Hunter'},
	["Mongoose Bite"] = {duration = 5, desc = "Counterattack the enemy for 115 damage. Can only be performed after you dodge.", icon = "Ability_Hunter_SwiftStrike", classes = 'Hunter'},
	["Raptor Strike"] = {duration = 6, desc = "A strong attack that increases melee damage by 140.", icon = "Ability_MeleeDamage", classes = 'Hunter'},
	["Wyvern Sting"] = {duration = 2*60, desc = "A stinging shot that puts the target to sleep for 12 sec. Any damage will cancel the effect. When the target wakes up, the Sting causes 600 Nature damage over 12 sec. Only usable out of combat. Only one Sting per Hunter can be active on the target at a time.", icon = "INV_Spear_02", classes = 'Hunter'},

	["Bestial Wrath"] = {duration = 2*60, desc = "Send your pet into a rage causing 50% additional damage for 18 sec. While enraged, the beast does not feel pity or remorse or fear and it cannot be stopped unless killed.", icon = "Ability_Druid_FerociousBite", classes = 'Hunter'},
	["Intimidation"] = {duration = 60, desc = "Command your pet to intimidate the target on the next successful melee attack, causing a high amount of threat and stunning the target for 3 sec.", icon = "Ability_Devour", classes = 'Hunter'},
	["Deterrence"] = {duration = 5*60, desc = "When activated, increases your Dodge and Parry chance by 25% for 10 sec.", icon = "Ability_Whirlwind", classes = 'Hunter'},
	["Scatter Shot"] = {duration = 30, desc = "A short-range shot that deals 50% weapon damage and disorients the target for 4 sec. Any damage caused will remove the effect. Turns off your attack when used.", icon = "Ability_GolemStormBolt", classes = 'Hunter'},

	-- Warlock
	["Curse of Doom"] = {duration = 60, desc = "Curses the target with impending doom, causing 3200 Shadow damage after 1 min. If the target dies from this damage, there is a chance that a Doomguard will be summoned. Cannot be cast on players.", icon = "Spell_Shadow_AuraOfDarkness", classes = 'Warlock'},
	["Death Coil"] = {duration = 2*60, desc = "Causes the enemy target to run in horror for 3 sec and causes 470 Shadow damage. The caster gains 100% of the damage caused in health.", icon = "Spell_Shadow_DeathCoil", classes = 'Warlock'},
	["Howl of Terror"] = {duration = 40, desc = "Howl, causing 5 enemies within 10 yds to flee in terror for 15 sec. Damage caused may interrupt the effect.", icon = "Spell_Shadow_DeathScream", classes = 'Warlock'},
	["Inferno"] = {duration = 60*60, desc = "Summons a meteor from the Twisting Nether, causing 200 Fire damage and stunning all enemy targets in the area for 2 sec. An Infernal rises from the crater, under the command of the caster for 5 min. Once control is lost, the Infernal must be Enslaved to maintain control. Can only be used outdoors.", icon = "Spell_Shadow_SummonInfernal", classes = 'Warlock'},
	["Ritual of Doom"] = {duration = 60*60, desc = "Begins a ritual that sacrifices a random participant to summon a doomguard. The doomguard must be immediately enslaved or it will attack the ritual participants. Requires the caster and 4 additional party members to complete the ritual. In order to participate, all players must right-click the portal and not move until the ritual is complete.", icon = "Spell_Shadow_AntiMagicShell", classes = 'Warlock'},
	["Shadow Ward"] = {duration = 30, desc = "Absorbs 920 shadow damage. Lasts 30 sec.", icon = "Spell_Shadow_AntiShadow", classes = 'Warlock'},
	["Conflagrate"] = {duration = 10, desc = "Ignites a target that is already afflicted by Immolate, dealing 447 to 557 Fire damage and consuming the Immolate spell.", icon = "Spell_Fire_Fireball", classes = 'Warlock'},
	["Shadowburn"] = {duration = 15, desc = "Instantly blasts the target for 450 to 502 Shadow damage. If the target dies within 5 sec of Shadowburn, and yields experience or honor, the caster gains a Soul Shard.", icon = "Spell_Shadow_ScourgeBuild", classes = 'Warlock'},
	["Soul Fire"] = {duration = 60, desc = "Burn the enemy's soul, causing 703 to 881 Fire damage.", icon = "Spell_Fire_Fireball02", classes = 'Warlock'},
	["Devour Magic"] = {duration = 8, desc = "Purges 1 harmful magic effect from a friend or 1 beneficial magic effect from an enemy. If an effect is devoured, the Felhunter will be healed for 579.", icon = "Spell_Nature_Purge", classes = 'Warlock'},
	["Spell Loc"] = {duration = 30, desc = "Silences the enemy for 3 sec. If used on a casting target, it will counter the enemy's spellcast, preventing any spell from that school of magic from being cast for 8 sec.", icon = "Spell_Shadow_MindRot", classes = 'Warlock'},
	["Lash of Pain"] = {duration = 12, desc = "An instant attack that lashes the target, causing 99 Shadow damage.", icon = "Spell_Shadow_Curse", classes = 'Warlock'},
	["Soothing Kiss"] = {duration = 4, desc = "Soothes the target, increasing the chance that it will attack something else. More effective than Soothing Kiss (Rank 3).", icon = "Spell_Shadow_SoothingKiss", classes = 'Warlock'},

	["Fel Domination"] = {duration = 15*60, desc = "Your next Imp, Voidwalker, Succubus, or Felhunter Summon spell has its casting time reduced by 5.5 sec and its Mana cost reduced by 50%.", icon = "Spell_Nature_RemoveCurse"},

	-- Priest
	["Elune's Grace"] = {duration = 5*60, desc = "Reduces ranged damage taken by 95 and increases chance to dodge by 10% for 15 sec.", icon = "Spell_Holy_ElunesGrace", classes = 'Priest'},
	["Feedback"] = {duration = 3*60, desc = "The priest becomes surrounded with anti-magic energy. Any successful spell cast against the priest will burn 105 of the attacker's Mana, causing 1 Shadow damage for each point of Mana burned. Lasts 15 sec.", icon = "Spell_Shadow_RitualOfSacrifice", classes = 'Priest'},
	["Power Word: Shield"] = {duration = 4, desc = "Draws on the soul of the party member to shield them, absorbing 942 damage. Lasts 30 sec. While the shield holds, spellcasting will not be interrupted by damage. Once shielded, the target cannot be shielded again for 15 sec.", icon = "Spell_Holy_PowerWordShield", classes = 'Priest'},
	["Desperate Prayer"] = {duration = 10*60, desc = "Instantly heals the caster for 1324 to 1562.", icon = "Spell_Holy_Restoration", classes = 'Priest'},
	["Fear Ward"] = {duration = 30, desc = "Wards the friendly target against Fear. The next Fear effect used against the target will fail, using up the ward. Lasts 10 min.", icon = "Spell_Holy_Excorcism", classes = 'Priest'},
	["Devouring Plague"] = {duration = 3*60, desc = "Afflicts the target with a disease that causes 904 Shadow damage over 24 sec. Damage caused by the Devouring Plague heals the caster.", icon = "Spell_Shadow_BlackPlague", classes = 'Priest'},
	["Fade"] = {duration = 30, desc = "Fade out, discouraging enemies from attacking you for 10 sec. More effective than Fade (rank 5).", icon = "Spell_Magic_LesserInvisibilty", classes = 'Priest'},
	["Mind Blast"] = {duration = 8, desc = "Blasts the target for 503 to 531 Shadow damage, but causes a high amount of threat.", icon = "Spell_Shadow_UnholyFrenzy", classes = 'Priest'},
	["Psychic Scream"] = {duration = 30, desc = "The caster lets out a psychic scream, causing 5 enemies within 8 yards to flee for 8 sec. Damage caused may interrupt the effect.", icon = "Spell_Shadow_PsychicScream", classes = 'Priest'},

	["Inner Focus"] = {duration = 3*60, desc = "When activated, reduces the Mana cost of your next spell by 100% and increases its critical effect chance by 25% if it is capable of a critical effect.", icon = "Spell_Frost_WindWalkOn", classes = 'Priest'},
	["Power Infusion"] = {duration = 3*60, desc = "Infuses the target with power, increasing their spell damage and healing by 20%. Lasts 15 sec.", icon = "Spell_Holy_PowerInfusion", classes = 'Priest'},
	["Silence"] = {duration = 45, desc = "Silences the target, preventing them from casting spells for 5 sec.", icon = "Spell_Shadow_ImpPhaseShift", classes = 'Priest'},

	-- Druid
	["Barkskin"] = {duration = 60, desc = "The druid's skin becomes as tough as bark. Physical damage taken is reduced by 20%. While protected, damaging attacks will not cause spellcasting delays but non-instant spells take 1 sec longer to cast and melee combat is slowed by 20%. Lasts 15 sec.", icon = "Spell_Nature_StoneClawTotem", classes = 'Druid'},
	["Faerie Fire"] = {duration = 6, desc = "Decrease the armor of the target by 505 for 40 sec. While affected, the target cannot stealth or turn invisible.", icon = "Spell_Nature_FaerieFire", classes = 'Druid'},
	["Hurricane"] = {duration = 60, desc = "Creates a violent storm in the target area causing 134 Nature damage to enemies every 1 sec, and reducing the attack speed of enemies by 20%. Lasts 10 sec. Druid must channel to maintain the spell.", icon = "Spell_Nature_Cyclone", classes = 'Druid'},
	["Nature's Grasp"] = {duration = 60, desc = "While active, any time an enemy strikes the caster they have a 35% chance to become afflicted by Entangling Roots (Rank 6). Only useable outdoors. 1 charge. Lasts 45 sec.", icon = "Spell_Nature_NaturesWrath", classes = 'Druid'},
	["Bash"] = {duration = 60, desc = "Stuns the target for 4 sec.", icon = "Ability_Druid_Bash", classes = 'Druid'},
	["Challenging Roar"] = {duration = 10*60, desc = "Forces all nearby enemies to focus attacks on you for 6 sec.", icon = "Ability_Druid_ChallangingRoar", classes = 'Druid'},
	["Cower"] = {duration = 10, desc = "Cower, causing no damage but lowering your threat a large amount, making the enemy less likely to attack you.", icon = "Ability_Druid_Cower", classes = 'Druid'},
	["Dash"] = {duration = 5*60, desc = "Increases movement speed by 60% for 15 sec. Does not break prowling.", icon = "Ability_Druid_Dash", classes = 'Druid'},
	["Enrage"] = {duration = 60, desc = "Generates 20 rage over 10 sec, but reduces base armor by 27% in Bear Form and 16% in Dire Bear Form. The druid is considered in combat for the duration.", icon = "Ability_Druid_Enrage", classes = 'Druid'},
	["Frenzied Regeneration"] = {duration = 3*60, desc = "Converts up to 10 rage per second into health for 10 sec. Each point of rage is converted into 20 health.", icon = "Ability_BullRush", classes = 'Druid'},
	["Prowl"] = {duration = 10, desc = "Allows the Druid to prowl around, but reduces your movement speed by 30%. Lasts until cancelled.", icon = "Ability_Ambush", classes = 'Druid'},
	["Tiger's Fury"] = {duration = 1, desc = "Increases damage done by 40 for 6 sec.", icon = "Ability_Mount_JungleTiger", classes = 'Druid'},
	["Rebirth"] = {duration = 30*60, desc = "Returns the spirit to the body, restoring a dead target to life with 2200 health and 2800 mana.", icon = "Spell_Nature_Reincarnation", classes = 'Druid'},
	["Tranquility"] = {duration = 5*60, desc = "Regenerates all nearby group members for 294 every 2 seconds for 10 sec. Druid must channel to maintain the spell.", icon = "Spell_Nature_Tranquility", classes = 'Druid'},
	["Innervate"] = {duration = 6*60, desc = "Increases the target's Mana regeneration by 400% and allows 100% of the target's Mana regeneration to continue while casting. Lasts 20 sec.", icon = "Spell_Nature_Lightning", classes = 'Druid'},

	["Faerie Fire (Feral)"] = {duration = 6, desc = "Decrease the armor of the target by 505 for 40 sec. While affected, the target cannot stealth or turn invisible.", icon = "Spell_Nature_FaerieFire", classes = 'Druid'},
	["Feral Charge"] = {duration = 15, desc = "Causes you to charge an enemy, immobilizing and interrupting any spell being cast for 4 sec.", icon = "Ability_Hunter_Pet_Bear", classes = 'Druid'},
	-- ["Nature's Swiftness"] = {duration = 3*60, desc = "When activated, your next Nature spell becomes an instant cast spell.", icon = "Spell_Nature_RavenForm"},
	["Swiftmend"] = {duration = 15, desc = "Consumes a Rejuvenation or Regrowth effect on a friendly target to instantly heal them an amount equal to 12 sec. of Rejuvenation or 18 sec. of Regrowth.", icon = "Inv_Relics_IdolOfRejuvenation", classes = 'Druid'},
}

local COMBAT_LOG_EVENTS = {
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
}

local COMBAT_LOG_PATTERNS = {
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

local COMBAT_LOG_PATTERNS_PARTIAL = {
	"You are afflicted by (.+)%.",
	"You are afflicted by (.+) %-",
}

function M.setup()
	cooldowns_settings.TARGET = cooldowns_settings.TARGET or T
	cooldowns_settings.TARGETTARGET = cooldowns_settings.TARGETTARGET or {active=false}
	M.targetFrame = cooldowns_frame.new('Target Cooldowns', A(.8, .2, .2), cooldowns_settings.TARGET)
	M.targetTargetFrame = cooldowns_frame.new('Target Target Cooldowns', A(.2, .2, .8), cooldowns_settings.TARGETTARGET)

	events = CreateFrame('Frame')
	events:SetScript('OnUpdate', UPDATE)
	events:SetScript('OnEvent', function() _M[event]() end)
	for _, event in COMBAT_LOG_EVENTS do
		_M[event] = combat_log_event_handler
		events:RegisterEvent(event)
	end
	events:RegisterEvent('PLAYER_TARGET_CHANGED')

	targeted_enemies = T
end

function combat_log_event_handler()
	for _, pattern in COMBAT_LOG_PATTERNS_PARTIAL do
		for cooldown_name in string.gfind(arg1, pattern) do
			for _, enemy in targeted_enemies do
				if COOLDOWNS[cooldown_name] and not active_cooldowns[enemy.name .. '|' .. cooldown_name] and (not COOLDOWNS[cooldown_name].classes or contains(COOLDOWNS[cooldown_name].classes, enemy.class)) then
					start_cooldown(enemy.name, cooldown_name)
					break
				end
			end
		end
	end

	for _, pattern in COMBAT_LOG_PATTERNS do
		for player, cooldown_name in string.gfind(arg1, pattern) do
			if COOLDOWNS[cooldown_name] then
				start_cooldown(player, cooldown_name)
			end
		end
	end
end

function expired(cooldown)
	return cooldown.started + COOLDOWNS[cooldown.name].duration <= GetTime()
end

do
	local active_cooldowns = T
	function get_active_cooldowns()
		for k, v in active_cooldowns do
			if expired(v) then
				active_cooldowns[k] = nil
			end
		end
		return active_cooldowns
	end
end

function show_cooldown(frame, key)
	local cooldown = active_cooldowns[key]
	if not cooldown[frame] then
		cooldown[frame] = frame:StartCD(cooldown.name, COOLDOWNS[cooldown.name].desc, [[Interface\Icons\]] .. COOLDOWNS[cooldown.name].icon, cooldown.started, COOLDOWNS[cooldown.name].duration)
	end
end

function hide_cooldown(frame, key)
	local cooldown = active_cooldowns[key]
	if cooldown[frame] then
		frame:CancelCD(cooldown[frame])
		cooldown[frame] = nil
	end
end

function triggers(player, cooldown_name)
	if cooldown_name == 'Preparation' then
		stop_cooldowns(player, 'Kidney Shot', 'Evasion', 'Feint', 'Gouge', 'Kick', 'Sprint', 'Blind', 'Distract', 'Stealth', 'Blade Flurry', 'Adrenaline Rush', 'Ghostly Strike', 'Premeditation', 'Cold Blood')
	elseif cooldown_name == 'Cold Snap' then
		stop_cooldowns(player, 'Ice Block', 'Cone of Cold', 'Frost Ward', 'Ice Barrier', 'Frost Nova')
	end
end

function start_cooldown(player, cooldown_name)
	triggers(player, cooldown_name)
	local key = player .. '|' .. cooldown_name
	if active_cooldowns[key] then
		hide_cooldown(targetFrame, key)
		hide_cooldown(targetTargetFrame, key)
	end
	active_cooldowns[key] = O(
		'name', cooldown_name,
		'player', player,
		'started', GetTime()
	)
	if player == UnitName('target') then
		show_cooldown(targetFrame, key)
	end
	if player == UnitName('targettarget') then
		show_cooldown(targetTargetFrame, key)
	end
end

function stop_cooldowns(player, ...)
	for i = 1, arg.n do
		local key = player .. '|' .. arg[i]
		if active_cooldowns[key] then
			hide_cooldown(targetFrame, key)
			hide_cooldown(targetTargetFrame, key)
			active_cooldowns[key] = nil
		end
	end
end

function update_frame(frame, player_name, player_class)
	for key, cooldown in active_cooldowns do
		if player_name == cooldown.player then
			if COOLDOWNS[cooldown.name].classes and not contains(COOLDOWNS[cooldown.name].classes, player_class) then
				stop_cooldowns(cooldown.player, cooldown.name)
			else
				show_cooldown(frame, key)
			end
		else
			hide_cooldown(frame, key)
		end
	end
end

function PLAYER_TARGET_CHANGED()
	if UnitIsEnemy('target', 'player') then
		tinsert(targeted_enemies, 1, O('name', UnitName('target'), 'class', UnitClass('target')))
		if getn(targeted_enemies) > 100 then release(tremove(targeted_enemies)) end
	end
	update_frame(targetFrame, UnitName('target'), UnitClass('target'))
end

do
	local skip = 0
	function UPDATE()
		if skip ~= 0 then return end
		skip = mod(skip - 1, 6)
		if cooldowns_settings.TARGETTARGET.active then
			update_frame(targetTargetFrame, UnitName('targettarget'), UnitClass('targettarget'))
		end
	end
end