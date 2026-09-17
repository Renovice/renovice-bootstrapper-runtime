  local vT = {}
  vT[0] = module
  vT[1] = ...
  vT[2] = package.seeall
  vT[0](vT[1], vT[2])
  vT[1] = "RK_NONE"
  vT[2] = "RK_FLESH"
  vT[3] = "RK_CLONED_FLESH"
  vT[4] = "RK_INFESTED_FLESH"
  vT[5] = "RK_TENNO_FLESH"
  vT[6] = "RK_ROBOTIC"
  vT[7] = "RK_MACHINERY"
  vT[8] = "RK_INFESTED"
  vT[9] = "RK_FOSSILIZED"
  vT[10] = "RK_FRACTURE"
  vT[11] = "RK_ARMOR"
  vT[12] = "RK_HULKING_ARMOR"
  vT[13] = "RK_INFESTED_ARMOUR"
  vT[14] = "RK_TENNO_ARMOR"
  vT[15] = "RK_SHIELD"
  vT[16] = "RK_HEAVY_SHIELD"
  vT[0] = {vT[1], vT[2], vT[3], vT[4], vT[5], vT[6], vT[7], vT[8], vT[9], vT[10], vT[11], vT[12], vT[13], vT[14], vT[15], vT[16]}
  vT[1] = "RK_TENNO_SHIELD"
  vT[2] = "RK_OVERGUARD"
  vT[3] = "RK_DISABLE_FACTION"
  vT[4] = "RK_NEUTRAL"
  vT[5] = "RK_GRINEER_FACTION"
  vT[6] = "RK_INFESTED_FACTION"
  vT[7] = "RK_CORPUS_FACTION"
  vT[8] = "RK_MITW_FACTION"
  vT[9] = "RK_SENTIENT_FACTION"
  vT[10] = "RK_OROKIN_FACTION"
  vT[11] = "RK_NARMER_FACTION"
  vT[12] = "RK_ZARIMAN_FACTION"
  vT[13] = "RK_LASRIA_FACTION"
  vT[14] = "RK_GRINEER_KUVA_FACTION"
  vT[15] = "RK_INFESTED_DEIMOS_FACTION"
  vT[16] = "RK_CORPUS_AMALGAM_FACTION"
  vT[0][17] = vT[1]
  vT[0][18] = vT[2]
  vT[0][19] = vT[3]
  vT[0][20] = vT[4]
  vT[0][21] = vT[5]
  vT[0][22] = vT[6]
  vT[0][23] = vT[7]
  vT[0][24] = vT[8]
  vT[0][25] = vT[9]
  vT[0][26] = vT[10]
  vT[0][27] = vT[11]
  vT[0][28] = vT[12]
  vT[0][29] = vT[13]
  vT[0][30] = vT[14]
  vT[0][31] = vT[15]
  vT[0][32] = vT[16]
  vT[1] = "RK_PROTOINFESTED_FACTION"
  vT[2] = "RK_OROKIN_EMPIRE_FACTION"
  vT[0][33] = vT[1]
  vT[0][34] = vT[2]
  vT[2] = "DT_IMPACT"
  vT[3] = "DT_PUNCTURE"
  vT[4] = "DT_SLASH"
  vT[5] = "DT_FIRE"
  vT[6] = "DT_FREEZE"
  vT[7] = "DT_ELECTRICITY"
  vT[8] = "DT_POISON"
  vT[9] = "DT_EXPLOSION"
  vT[10] = "DT_RADIATION"
  vT[11] = "DT_GAS"
  vT[12] = "DT_MAGNETIC"
  vT[13] = "DT_VIRAL"
  vT[14] = "DT_CORROSIVE"
  vT[15] = "DT_RADIANT"
  vT[16] = "DT_SENTIENT"
  vT[17] = "DT_CINEMATIC"
  vT[1] = {vT[2], vT[3], vT[4], vT[5], vT[6], vT[7], vT[8], vT[9], vT[10], vT[11], vT[12], vT[13], vT[14], vT[15], vT[16], vT[17]}
  vT[2] = "DT_SHIELD_DRAIN"
  vT[3] = "DT_HEALTH_DRAIN"
  vT[4] = "DT_ENERGY_DRAIN"
  vT[5] = "DT_FINISHER"
  vT[6] = "DT_SUICIDE"
  vT[7] = "DT_PHYSICAL"
  vT[8] = "DT_INVALID"
  vT[9] = "DT_BASE_ELEMENTAL"
  vT[10] = "DT_COMPOUND_ELEMENTAL"
  vT[11] = "DT_ANY"
  vT[1][17] = vT[2]
  vT[1][18] = vT[3]
  vT[1][19] = vT[4]
  vT[1][20] = vT[5]
  vT[1][21] = vT[6]
  vT[1][22] = vT[7]
  vT[1][23] = vT[8]
  vT[1][24] = vT[9]
  vT[1][25] = vT[10]
  vT[1][26] = vT[11]
  DAMAGE_TYPE_TAGS = vT[1]
  vT[2] = "PT_KNOCKBACK"
  vT[3] = "PT_FRAILTY"
  vT[4] = "PT_BLEEDING"
  vT[5] = "PT_IMMOLATION"
  vT[6] = "PT_CHILLED"
  vT[7] = "PT_ELECTROCUTION"
  vT[8] = "PT_POISONED"
  vT[9] = "PT_FLASHBANG"
  vT[10] = "PT_RAD_TOX"
  vT[11] = "PT_ASPHYXIATION"
  vT[12] = "PT_MAGNETIZED"
  vT[13] = "PT_INFECTED"
  vT[14] = "PT_CAUSTIC_BURN"
  vT[15] = "PT_RADIANT"
  vT[16] = "PT_SENTIENT"
  vT[17] = "PT_MICROWAVE_BURN"
  vT[1] = {vT[2], vT[3], vT[4], vT[5], vT[6], vT[7], vT[8], vT[9], vT[10], vT[11], vT[12], vT[13], vT[14], vT[15], vT[16], vT[17]}
  vT[2] = "PT_STAGGERED"
  vT[3] = "PT_BIG_STAGGER"
  vT[4] = "PT_STUNNED"
  vT[5] = "PT_KNOCKED_DOWN"
  vT[6] = "PT_RAGDOLL"
  vT[7] = "PT_PARRIED"
  vT[8] = "PT_DISARMED"
  vT[9] = "PT_SILENCED"
  vT[10] = "PT_ROOTS"
  vT[11] = "PT_VOID"
  vT[12] = "PT_GLUE"
  vT[13] = "PT_SLEEP"
  vT[14] = "PT_LIFT_HIT"
  vT[15] = "PT_COUNTERED"
  vT[16] = "MAX_ProcType"
  vT[1][17] = vT[2]
  vT[1][18] = vT[3]
  vT[1][19] = vT[4]
  vT[1][20] = vT[5]
  vT[1][21] = vT[6]
  vT[1][22] = vT[7]
  vT[1][23] = vT[8]
  vT[1][24] = vT[9]
  vT[1][25] = vT[10]
  vT[1][26] = vT[11]
  vT[1][27] = vT[12]
  vT[1][28] = vT[13]
  vT[1][29] = vT[14]
  vT[1][30] = vT[15]
  vT[1][31] = vT[16]
  vT[3] = { Type = nil, Affix = "" }
  vT[4] = WeakResource
  vT[5] = "/Lotus/Types/Items/MiscItems/FocusLens"
  vT[4] = vT[4](vT[5])
  vT[3].Type = vT[4]
  vT[4] = { Type = nil, Affix = "_GREATER" }
  vT[5] = WeakResource
  vT[6] = "/Lotus/Types/Items/MiscItems/FocusLensGreater"
  vT[5] = vT[5](vT[6])
  vT[4].Type = vT[5]
  vT[5] = { Type = nil, Affix = "_EIDOLON" }
  vT[6] = WeakResource
  vT[7] = "/Lotus/Types/Items/MiscItems/FocusLensOstron"
  vT[6] = vT[6](vT[7])
  vT[5].Type = vT[6]
  vT[6] = { Type = nil, Affix = "_LUA" }
  vT[7] = WeakResource
  vT[8] = "/Lotus/Types/Items/MiscItems/FocusLensLua"
  vT[7] = vT[7](vT[8])
  vT[6].Type = vT[7]
  vT[2] = {vT[3], vT[4], vT[5], vT[6]}
  vT[5] = #vT[0]
  vT[7] = 33
  vT[6] = vT[7] + 1
  if vT[5] ~= vT[6] then
    vT[4] = false
  else
    vT[4] = true
  end
  vT[3] = assert
  vT[3](vT[4])
  vT[6] = DAMAGE_TYPE_TAGS
  vT[5] = #vT[6]
  vT[7] = 25
  vT[6] = vT[7] + 1
  if vT[5] ~= vT[6] then
    vT[4] = false
  else
    vT[4] = true
  end
  vT[3] = assert
  vT[3](vT[4])
  vT[5] = #vT[1]
  vT[7] = 30
  vT[6] = vT[7] + 1
  if vT[5] ~= vT[6] then
    vT[4] = false
  else
    vT[4] = true
  end
  vT[3] = assert
  vT[3](vT[4])
  vT[3] = WeakResource
  vT[4] = "/Lotus/Types/StoreItems/SuitCustomizations/ColourPickerDefaultsItemA"
  vT[3] = vT[3](vT[4])
  vT[4] = WeakResource
  vT[5] = "/Lotus/Upgrades/Mods/Fusers/UncommonModFuser"
  vT[4] = vT[4](vT[5])
  vT[5] = WeakResource
  vT[6] = "/Lotus/Upgrades/Mods/Fusers/RareModFuser"
  vT[5] = vT[5](vT[6])
  vT[6] = WeakResource
  vT[7] = "/Lotus/Types/Items/MiscItems/Elitium"
  vT[6] = vT[6](vT[7])
  vT[7] = WeakResource
  vT[8] = "/Lotus/Types/Game/OrokinGoldenMawAvatar"
  vT[7] = vT[7](vT[8])
  vT[8] = WeakResource
  vT[9] = "/Lotus/Types/Items/ShipFeatureItems/ShipFeatureItem"
  vT[8] = vT[8](vT[9])
  vT[9] = WeakResource
  vT[10] = "/Lotus/Types/Restoratives/LisetBaseAirSupportPower"
  vT[9] = vT[9](vT[10])
  vT[10] = WeakResource
  vT[11] = "/Lotus/Weapons/Tenno/HackingDevices/TnHackingDevice/TnHackingDeviceWeapon"
  vT[10] = vT[10](vT[11])
  vT[11] = WeakResource
  vT[12] = "/Lotus/Powersuits/Wraith/ReaperAvatar"
  vT[11] = vT[11](vT[12])
  vT[12] = WeakResource
  vT[13] = "/Lotus/Powersuits/Sandman/SandCloneAvatar"
  vT[12] = vT[12](vT[13])
  vT[13] = WeakResource
  vT[14] = "/Lotus/Weapons/Tenno/Bayonet/TnBayonetMeleeWeapon"
  vT[13] = vT[13](vT[14])
  vT[14] = WeakResource
  vT[15] = "/Lotus/Weapons/Tenno/Bayonet/TnBayonetRifleWeapon"
  vT[14] = vT[14](vT[15])
  vT[15] = WeakResource
  vT[16] = "/Lotus/Weapons/Tenno/Rifle/LotusAssaultRifle"
  vT[15] = vT[15](vT[16])
  vT[16] = Symbol
  vT[17] = "TENNO"
  vT[16] = vT[16](vT[17])
  TENNO_FACTION_TAG = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Friendly/Agents/TempleDefenseAgent"
  vT[16] = vT[16](vT[17])
  stageDefenseAgent = vT[16]
  vT[16] = 1
  UI_MODE_IN_SPACE_SHIP = vT[16]
  vT[16] = 2
  UI_MODE_IN_SPACE_HUB = vT[16]
  vT[16] = 3
  UI_MODE_IN_DOJO = vT[16]
  vT[16] = 4
  UI_MODE_IN_GAME = vT[16]
  vT[16] = 7
  REGION_ID_URANUS = vT[16]
  vT[16] = 14
  REGION_ID_DOJO = vT[16]
  vT[16] = 15
  REGION_ID_VOID = vT[16]
  vT[16] = 17
  REGION_ID_DERELICT = vT[16]
  vT[16] = 18
  REGION_ID_MOON = vT[16]
  vT[16] = 19
  REGION_ID_FORTRESS = vT[16]
  vT[16] = 20
  REGION_ID_DARK_SECTOR = vT[16]
  vT[16] = 21
  REGION_ID_DEEP_SPACE = vT[16]
  vT[16] = 22
  REGION_ID_ZARIMAN = vT[16]
  vT[16] = 23
  REGION_ID_DUVIRI = vT[16]
  vT[16] = 24
  REGION_ID_VANIA = vT[16]
  vT[16] = 25
  REGION_ID_TAU = vT[16]
  vT[16] = 97
  REGION_ID_DOJO_DUEL = vT[16]
  vT[16] = 98
  REGION_ID_CLAN_DOJO = vT[16]
  vT[16] = 99
  REGION_ID_PVP = vT[16]
  vT[16] = 100
  REGION_ID_PHOTOBOOTH = vT[16]
  vT[16] = 101
  REGION_ID_SIMULACRUM = vT[16]
  vT[16] = 1
  SLIDER = vT[16]
  vT[16] = 2
  CHECKBOX = vT[16]
  vT[16] = 3
  TOGGLE = vT[16]
  vT[16] = 4
  BUTTON = vT[16]
  vT[16] = 5
  TITLE = vT[16]
  vT[16] = 6
  INPUTBOX = vT[16]
  vT[16] = 7
  SPACER = vT[16]
  vT[16] = 8
  INPUTCOUNT = vT[16]
  vT[16] = 9
  ICONBUTTON = vT[16]
  vT[16] = 10
  CHOICE = vT[16]
  vT[16] = 11
  COLOR = vT[16]
  vT[16] = 12
  IMAGE = vT[16]
  vT[16] = 13
  CHECKMARK = vT[16]
  vT[16] = 1
  REPORT_PLAYER = vT[16]
  vT[16] = 2
  REPORT_CLAN_AD = vT[16]
  vT[16] = {}
  vT[17] = 0
  vT[18] = "WARFRAME_SLOT"
  vT[16][vT[17]] = vT[18]
  vT[17] = 1
  vT[18] = "WEAPON_SLOT"
  vT[16][vT[17]] = vT[18]
  vT[17] = 2
  vT[18] = "SENTINEL_SLOT"
  vT[16][vT[17]] = vT[18]
  vT[17] = 3
  vT[18] = "SPACE_SUIT_SLOT"
  vT[16][vT[17]] = vT[18]
  vT[17] = 4
  vT[18] = "SPACE_WEAPON_SLOT"
  vT[16][vT[17]] = vT[18]
  vT[17] = 8
  vT[18] = "OPERATOR_AMP_SLOT"
  vT[16][vT[17]] = vT[18]
  vT[17] = 10
  vT[18] = "MECH_SLOT"
  vT[16][vT[17]] = vT[18]
  vT[17] = 11
  vT[18] = "CREW_MEMBER_SLOT"
  vT[16][vT[17]] = vT[18]
  SLOT_TYPES = vT[16]
  vT[16] = 1
  SOUND_SET_EIDOLON = vT[16]
  vT[16] = 2
  SOUND_SET_FORTUNA = vT[16]
  vT[16] = 3
  SOUND_SET_ORB_VALLIS = vT[16]
  vT[16] = 4
  SOUND_SET_RAILJACK = vT[16]
  vT[16] = 5
  SOUND_SET_OROKIN_TOWER = vT[16]
  vT[16] = 6
  SOUND_SET_ZARIMAN = vT[16]
  vT[16] = 7
  SOUND_SET_DUVIRI = vT[16]
  vT[16] = 8
  SOUND_SET_ENTRATILAB = vT[16]
  vT[16] = 9
  SOUND_SET_1999 = vT[16]
  vT[16] = 10
  SOUND_SET_NOKKO = vT[16]
  vT[16] = 11
  SOUND_SET_HELL_TOWER = vT[16]
  vT[16] = 12
  SOUND_SET_12MIN_WAR = vT[16]
  vT[16] = "_"
  TAG_SEPERATOR = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "Alert"
  vT[16] = vT[17] .. vT[18]
  ALERT_TAG = vT[16]
  vT[16] = 100000
  ALERT_FLAG = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "Nightmare"
  vT[16] = vT[17] .. vT[18]
  NIGHTMARE_TAG = vT[16]
  vT[16] = 200000
  NIGHTMARE_FLAG = vT[16]
  vT[16] = 28800
  NIGHTMARE_MISSION_INTERVAL = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "Event"
  vT[16] = vT[17] .. vT[18]
  EVENT_TAG = vT[16]
  vT[16] = 300000
  EVENT_FLAG = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "PVP"
  vT[16] = vT[17] .. vT[18]
  PVP_TAG = vT[16]
  vT[16] = 400000
  PVP_FLAG = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "InvasionAttacker"
  vT[16] = vT[17] .. vT[18]
  INVASION_ATTACKER_TAG = vT[16]
  vT[16] = 500000
  INVASION_ATTACKER_FLAG = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "InvasionDefender"
  vT[16] = vT[17] .. vT[18]
  INVASION_DEFENDER_TAG = vT[16]
  vT[16] = 600000
  INVASION_DEFENDER_FLAG = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "HUB"
  vT[16] = vT[17] .. vT[18]
  HUB_TAG = vT[16]
  vT[16] = 700000
  HUB_FLAG = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "Syndicate"
  vT[16] = vT[17] .. vT[18]
  SYNDICATE_MISSION_TAG = vT[16]
  vT[16] = 1100000
  SYNDICATE_MISSION_FLAG = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "Key"
  vT[16] = vT[17] .. vT[18]
  KEY_TAG = vT[16]
  vT[16] = 1200000
  KEY_FLAG = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "Sortie"
  vT[16] = vT[17] .. vT[18]
  SORTIE_MISSION_TAG = vT[16]
  vT[16] = 1300000
  SORTIE_MISSION_FLAG = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "ActiveMission"
  vT[16] = vT[17] .. vT[18]
  ACTIVE_MISSION_TAG = vT[16]
  vT[16] = 1400000
  ACTIVE_MISSION_FLAG = vT[16]
  vT[16] = Symbol
  vT[17] = "GhostTower"
  vT[16] = vT[16](vT[17])
  KUVA_TOWER_GOAL_TAG = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "GhostTower"
  vT[16] = vT[17] .. vT[18]
  KUVA_TOWER_MISSION_TAG = vT[16]
  vT[16] = 1500000
  KUVA_TOWER_MISSION_FLAG = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "JUNCTION"
  vT[16] = vT[17] .. vT[18]
  JUNCTION_TAG = vT[16]
  vT[16] = 1600000
  JUNCTION_FLAG = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "Nemesis"
  vT[16] = vT[17] .. vT[18]
  NEMESIS_MISSION_TAG = vT[16]
  vT[16] = 1700000
  NEMESIS_MISSION_FLAG = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "EliteAlert"
  vT[16] = vT[17] .. vT[18]
  ELITE_ALERT_TAG = vT[16]
  vT[16] = 1800000
  ELITE_ALERT_FLAG = vT[16]
  vT[16] = Symbol
  vT[17] = "EliteAlert"
  vT[16] = vT[16](vT[17])
  ELITE_ALERT_PERIODIC_MISSION_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "EliteAlertB"
  vT[16] = vT[16](vT[17])
  ELITE_ALERT_PERIODIC_MISSION_TAG_ALT = vT[16]
  vT[16] = 3600
  ELITE_ALERT_MISSION_INTERVAL = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "Scenario"
  vT[16] = vT[17] .. vT[18]
  SCENARIO_BEACON_TAG = vT[16]
  vT[16] = 1900000
  SCENARIO_BEACON_FLAG = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "Hard"
  vT[16] = vT[17] .. vT[18]
  HARD_MODE_TAG = vT[16]
  vT[16] = 2000000
  HARD_MODE_FLAG = vT[16]
  vT[16] = 100
  HARD_MODE_LEVEL_MODIFIER = vT[16]
  vT[16] = 50
  HARD_MODE_ARCHWING_LEVEL_MODIFIER = vT[16]
  vT[16] = 20
  HARD_MODE_DUVIRI_LEVEL_MODIFIER = vT[16]
  vT[16] = 100
  HARD_MODE_JADE_SHADOWS_EVENT_LEVEL_MODIFIER = vT[16]
  vT[16] = 100
  HARD_MODE_MURMUR_INVASION_EVENT_LEVEL_MODIFIER = vT[16]
  vT[16] = 100
  HARD_MODE_SHADOWGRAPHER_EVENT_LEVEL_MODIFIER = vT[16]
  vT[16] = 1.5
  HARD_MODE_EVENT_ALERT_REWARD_MULTIPLIER = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "HardDaily"
  vT[16] = vT[17] .. vT[18]
  HARD_DAILY_TAG = vT[16]
  vT[16] = 2100000
  HARD_DAILY_FLAG = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "VoidStorm"
  vT[16] = vT[17] .. vT[18]
  VOID_STORM_TAG = vT[16]
  vT[16] = 2200000
  VOID_STORM_FLAG = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "LiteSortie"
  vT[16] = vT[17] .. vT[18]
  LITE_SORTIE_MISSION_TAG = vT[16]
  vT[16] = 2300000
  LITE_SORTIE_MISSION_FLAG = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "LabConquest"
  vT[16] = vT[17] .. vT[18]
  LAB_CONQUEST_MISSION_TAG = vT[16]
  vT[16] = 2400000
  LAB_CONQUEST_MISSION_FLAG = vT[16]
  vT[16] = "LabConquest"
  LAB_CONQUEST_MISSION_NAME_TAG = vT[16]
  vT[16] = "PvPvE"
  PVPVE_NODE_NAME_TAG = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = PVPVE_NODE_NAME_TAG
  vT[16] = vT[17] .. vT[18]
  PVPVE_VS_TENNO_NAME_TAG = vT[16]
  vT[16] = "SolNode855"
  PVPVE_VS_TENNO_NODE_TAG = vT[16]
  vT[17] = PVPVE_VS_TENNO_NODE_TAG
  vT[18] = HARD_MODE_TAG
  vT[16] = vT[17] .. vT[18]
  PVPVE_VS_TENNO_HARD_NODE_TAG = vT[16]
  vT[16] = 2500000
  PVPVE_VS_TENNO_MISSION_FLAG = vT[16]
  vT[17] = PVPVE_VS_TENNO_MISSION_FLAG
  vT[18] = HARD_MODE_FLAG
  vT[16] = vT[17] + vT[18]
  PVPVE_VS_TENNO_MISSION_HARD_FLAG = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = PVPVE_NODE_NAME_TAG
  vT[19] = TAG_SEPERATOR
  vT[20] = "VsAI"
  vT[16] = vT[17] .. vT[18] .. vT[19] .. vT[20]
  PVPVE_VS_AI_NAME_TAG = vT[16]
  vT[16] = "SolNode857"
  PVPVE_VS_AI_NODE_TAG = vT[16]
  vT[16] = 2600000
  PVPVE_VS_AI_MISSION_FLAG = vT[16]
  vT[17] = PVPVE_VS_AI_MISSION_FLAG
  vT[18] = HARD_MODE_FLAG
  vT[16] = vT[17] + vT[18]
  PVPVE_VS_AI_MISSION_HARD_FLAG = vT[16]
  vT[16] = "HexConquest"
  HEX_CONQUEST_MISSION_NAME_TAG = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = HEX_CONQUEST_MISSION_NAME_TAG
  vT[16] = vT[17] .. vT[18]
  HEX_CONQUEST_MISSION_TAG = vT[16]
  vT[16] = 2700000
  HEX_CONQUEST_MISSION_FLAG = vT[16]
  vT[16] = "SolNode860"
  HEX_CONQUEST_MISSION_NODE_NAME = vT[16]
  vT[17] = TAG_SEPERATOR
  vT[18] = "HardEvent"
  vT[16] = vT[17] .. vT[18]
  HARD_EVENT_TAG = vT[16]
  vT[16] = 2800000
  HARD_EVENT_FLAG = vT[16]
  vT[16] = 5
  MAX_PULSES = vT[16]
  vT[16] = 3600
  KUVA_TOWER_MISSION_INTERVAL = vT[16]
  vT[16] = "OptionalGoal"
  OPTIONAL_GOAL_PREFIX = vT[16]
  vT[16] = "AnyNode"
  ANY_NODE_PREFIX = vT[16]
  vT[16] = Symbol
  vT[17] = "ZarimanHub"
  vT[16] = vT[16](vT[17])
  ZARIMAN_NODE_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "CetusHub4"
  vT[16] = vT[16](vT[17])
  CETUS_NODE_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "SolNode228"
  vT[16] = vT[16](vT[17])
  PLAINS_NODE_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "IronwakeHUB3"
  vT[16] = vT[16](vT[17])
  IRON_WAKE_NODE_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "SolarisUnitedHub1"
  vT[16] = vT[16](vT[17])
  FORTUNA_NODE_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "SolNode129"
  vT[16] = vT[16](vT[17])
  ORB_VALLIS_NODE_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "SolNode450"
  vT[16] = vT[16](vT[17])
  MARS_DUAL_DEFENSE_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "SolNode719"
  vT[16] = vT[16](vT[17])
  DEIMOS_DUAL_DEFENSE_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "DeimosHub"
  vT[16] = vT[16](vT[17])
  OROKIN_TOWER_NODE_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "EntratiLabHub"
  vT[16] = vT[16](vT[17])
  ENTRATI_LAB_NODE_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "SolNode229"
  vT[16] = vT[16](vT[17])
  ENTRATI_LANDSCAPE_NODE_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "ScenarioEventHub5"
  vT[16] = vT[16](vT[17])
  SCENARIO_EVENT_HUB_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "MercuryHUB"
  vT[16] = vT[16](vT[17])
  MERCURY_HUB_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "SolNode234"
  vT[16] = vT[16](vT[17])
  APARTMENT_NODE_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "SolNode230"
  vT[16] = vT[16](vT[17])
  ZARIMAN_MISSION_A_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "SolNode231"
  vT[16] = vT[16](vT[17])
  ZARIMAN_MISSION_B_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "SolNode232"
  vT[16] = vT[16](vT[17])
  ZARIMAN_MISSION_C_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "SolNode233"
  vT[16] = vT[16](vT[17])
  ZARIMAN_MISSION_D_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "SolNode235"
  vT[16] = vT[16](vT[17])
  ZARIMAN_MISSION_E_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "/Lotus/Types/Keys/TestKeyForestOpLinkFragment"
  vT[16] = vT[16](vT[17])
  SCENARIO_EVENT_GROUND_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "/Lotus/Types/Keys/TestKeyCrewBattleSentientSquadLink"
  vT[16] = vT[16](vT[17])
  SCENARIO_EVENT_SPACE_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "SolNode451"
  vT[16] = vT[16](vT[17])
  CETUS_INVASION_NODE_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "LasriaHubTag"
  vT[16] = vT[16](vT[17])
  LASRIA_HUB_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "1999Hub"
  vT[16] = vT[16](vT[17])
  WF1999_MISSION_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "1999HubSpring"
  vT[16] = vT[16](vT[17])
  WF1999_MISSION_SPRING_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "1999HubSummer"
  vT[16] = vT[16](vT[17])
  WF1999_MISSION_SUMMER_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "1999HubFall"
  vT[16] = vT[16](vT[17])
  WF1999_MISSION_FALL_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "1999HubWinter"
  vT[16] = vT[16](vT[17])
  WF1999_MISSION_WINTER_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "EntratiLabHubZone"
  vT[16] = vT[16](vT[17])
  ENTRATI_LAB_ZONE_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "DeimosHubZone"
  vT[16] = vT[16](vT[17])
  DEIMOS_NECRALISK_ZONE_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "SolNode451"
  vT[16] = vT[16](vT[17])
  SAYAS_VISION_NODE_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "NokkoColony"
  vT[16] = vT[16](vT[17])
  NOKKO_COLONY_NODE_TAG = vT[16]
  vT[16] = Symbol
  vT[17] = "ReplayQuest"
  vT[16] = vT[16](vT[17])
  RAILJACK_QUEST_REPLAY_TAG = vT[16]
  vT[16] = 0
  PLAINS_ELO_IN_LISET = vT[16]
  vT[16] = 1
  PLAINS_ELO_INSIDE_SAFE_ZONE = vT[16]
  vT[16] = 2
  PLAINS_ELO_OUTSIDE_SAFE_ZONE = vT[16]
  vT[16] = 3
  PLAINS_ELO_BOUNTY_ACTIVE = vT[16]
  vT[16] = 10
  PLAINS_ELO_POST_NEW_WAR_OFFSET = vT[16]
  vT[16] = Symbol
  vT[17] = "Darvo"
  vT[16] = vT[16](vT[17])
  DARVO_TAG = vT[16]
  vT[16] = {}
  vT[28] = -1
  vT[29] = "/Lotus/Language/Game/Faction_WildUC"
  vT[16][vT[28]] = vT[29]
  vT[28] = 0
  vT[29] = "/Lotus/Language/Game/Faction_GrineerUC"
  vT[16][vT[28]] = vT[29]
  vT[17] = "/Lotus/Language/Game/Faction_CorpusUC"
  vT[18] = "/Lotus/Language/Game/Faction_InfestationUC"
  vT[19] = "/Lotus/Language/Game/Faction_OrokinUC"
  vT[20] = "/Lotus/Language/Game/Faction_RedVeilUC"
  vT[21] = "/Lotus/Language/Game/Faction_SentientUC"
  vT[22] = "/Lotus/Language/Game/Faction_NarmerUC"
  vT[23] = "/Lotus/Language/Game/Faction_MITW"
  vT[24] = "/Lotus/Language/1999/Faction_Scaldra"
  vT[25] = "/Lotus/Language/1999/Faction_Techrot"
  vT[26] = "/Lotus/Language/Duviri/Duviri"
  vT[27] = "/Lotus/Language/Menu/Codex_Tenno"
  vT[16] = {vT[17], vT[18], vT[19], vT[20], vT[21], vT[22], vT[23], vT[24], vT[25], vT[26], vT[27]}
  FactionNames = vT[16]
  vT[16] = {}
  vT[17] = -1
  vT[16].WILD = vT[17]
  vT[17] = 0
  vT[16].GRINEER = vT[17]
  vT[17] = 1
  vT[16].CORPUS = vT[17]
  vT[17] = 2
  vT[16].INFESTATION = vT[17]
  vT[17] = 3
  vT[16].OROKIN = vT[17]
  vT[17] = 4
  vT[16].REDVEIL = vT[17]
  vT[17] = 5
  vT[16].SENTIENT = vT[17]
  vT[17] = 6
  vT[16].NARMER = vT[17]
  vT[17] = 7
  vT[16].MITW = vT[17]
  vT[17] = 11
  vT[16].TENNO = vT[17]
  vT[17] = 9
  vT[16].TECHROT = vT[17]
  vT[17] = 8
  vT[16].SCALDRA = vT[17]
  FactionMap = vT[16]
  vT[16] = "???"
  HIDDEN_PLAYER_NAME = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/AlertsFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_ALERTS = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/ArsenalFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_ARSENAL = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/ArsenalMeleeFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_ARSENAL_MELEE = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/SocialMenuFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_CLAN = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/FoundryFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_FOUNDRY = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/FoundryVesselUpgradeFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_FOUNDRY_VESSEL_UPGRADE = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/GeneticFoundryFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_GENETIC_FOUNDRY = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/GeneticFoundryUpgradeFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_GENETIC_FOUNDRY_UPGRADE = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/InfestedFoundryItem"
  vT[16] = vT[16](vT[17])
  SF_INFESTED_FOUNDRY = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/InfestedFoundryUpgradeFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_INFESTED_FOUNDRY_UPGRADE = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/InfestedFoundryArchonShardFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_INFESTED_FOUNDRY_SHARD_UPGRADE = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/InfestedFoundryArchonShardUpgradeFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_INFESTED_FOUNDRY_FUSION_UPGRADE = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/SocialMenuFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_MARKET_TIER_ONE = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/SocialMenuFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_MARKET_TIER_TWO = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/ModsFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_MODS = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/ModsFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_MODS_FUSION = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/ModsFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_MODS_TRANSMUTE = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/SocialMenuFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_CONCLAVE = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/SocialMenuFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_SOCIAL_MENU = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/MercuryNavigationFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_SOLAR_CHART = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/VoidProjectionFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_VOID_PROJECTION = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/PersonalQuartersFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_PERSONAL_QUARTERS = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/RailjackCephalonShipFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_RAILJACK_CEPHALON = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/RailjackKeyShipFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_RAILJACK_KEY = vT[16]
  vT[16] = WeakResource
  vT[17] = "/Lotus/Types/Items/ShipFeatureItems/AdvancedOrdisFeatureItem"
  vT[16] = vT[16](vT[17])
  SF_ADVANCED_ORDIS = vT[16]
  vT[16] = 20
  MAX_PVP_LOADOUTS = vT[16]
  vT[16] = { VoidT1 = nil, VoidT2 = nil, VoidT3 = nil, VoidT4 = nil, VoidT5 = nil, VoidT6 = nil }
  vT[17] = WeakResource
  vT[18] = "/Lotus/Types/Game/Projections/T1VoidProjection"
  vT[17] = vT[17](vT[18])
  vT[16].VoidT1 = vT[17]
  vT[17] = WeakResource
  vT[18] = "/Lotus/Types/Game/Projections/T2VoidProjection"
  vT[17] = vT[17](vT[18])
  vT[16].VoidT2 = vT[17]
  vT[17] = WeakResource
  vT[18] = "/Lotus/Types/Game/Projections/T3VoidProjection"
  vT[17] = vT[17](vT[18])
  vT[16].VoidT3 = vT[17]
  vT[17] = WeakResource
  vT[18] = "/Lotus/Types/Game/Projections/T4VoidProjection"
  vT[17] = vT[17](vT[18])
  vT[16].VoidT4 = vT[17]
  vT[17] = WeakResource
  vT[18] = "/Lotus/Types/Game/Projections/T5VoidProjectionImmortal"
  vT[17] = vT[17](vT[18])
  vT[16].VoidT5 = vT[17]
  vT[17] = WeakResource
  vT[18] = "/Lotus/Types/Game/Projections/T0VoidProjection"
  vT[17] = vT[17](vT[18])
  vT[16].VoidT6 = vT[17]
  VOID_PROJECTION_ITEMS = vT[16]
  vT[16] = {}
  vT[17] = { levelOverride = nil, goalTag = nil }
  vT[18] = WeakResource
  vT[19] = "/Lotus/Levels/Proc/TheNewWar/PartOne/PostWarOstronTown"
  vT[18] = vT[18](vT[19])
  vT[17].levelOverride = vT[18]
  vT[18] = Symbol
  vT[19] = "PostWar"
  vT[18] = vT[18](vT[19])
  vT[17].goalTag = vT[18]
  vT[16].CetusHub4 = vT[17]
  vT[17] = { levelOverride = nil, goalTag = nil, eloMin = nil, eloMax = nil, extraEnemySpec = "/Lotus/Types/Game/EnemySpecs/Narmer/GrineerNarmer", streamingOffset = nil }
  vT[18] = WeakResource
  vT[19] = "/Lotus/Levels/Proc/TheNewWar/PartOne/PostWarEidolonLandscape"
  vT[18] = vT[18](vT[19])
  vT[17].levelOverride = vT[18]
  vT[18] = Symbol
  vT[19] = "PostWar"
  vT[18] = vT[18](vT[19])
  vT[17].goalTag = vT[18]
  vT[19] = PLAINS_ELO_IN_LISET
  vT[20] = PLAINS_ELO_POST_NEW_WAR_OFFSET
  vT[18] = vT[19] + vT[20]
  vT[17].eloMin = vT[18]
  vT[19] = PLAINS_ELO_BOUNTY_ACTIVE
  vT[20] = PLAINS_ELO_POST_NEW_WAR_OFFSET
  vT[18] = vT[19] + vT[20]
  vT[17].eloMax = vT[18]
  vT[18] = Vector
  vT[18] = vT[18]()
  vT[17].streamingOffset = vT[18]
  vT[16].SolNode228 = vT[17]
  vT[17] = { levelOverride = nil, goalTag = nil }
  vT[18] = WeakResource
  vT[19] = "/Lotus/Levels/Proc/TheNewWar/PartTwo/PostWarFortuna"
  vT[18] = vT[18](vT[19])
  vT[17].levelOverride = vT[18]
  vT[18] = Symbol
  vT[19] = "PostWar"
  vT[18] = vT[18](vT[19])
  vT[17].goalTag = vT[18]
  vT[16].SolarisUnitedHub1 = vT[17]
  vT[17] = { levelOverride = nil, goalTag = nil, eloMin = nil, eloMax = nil, extraEnemySpec = "/Lotus/Types/Game/EnemySpecs/Narmer/CorpusNarmer" }
  vT[18] = WeakResource
  vT[19] = "/Lotus/Levels/Proc/TheNewWar/PartTwo/PostWarVenusLandscape"
  vT[18] = vT[18](vT[19])
  vT[17].levelOverride = vT[18]
  vT[18] = Symbol
  vT[19] = "PostWar"
  vT[18] = vT[18](vT[19])
  vT[17].goalTag = vT[18]
  vT[19] = PLAINS_ELO_IN_LISET
  vT[20] = PLAINS_ELO_POST_NEW_WAR_OFFSET
  vT[18] = vT[19] + vT[20]
  vT[17].eloMin = vT[18]
  vT[19] = PLAINS_ELO_BOUNTY_ACTIVE
  vT[20] = PLAINS_ELO_POST_NEW_WAR_OFFSET
  vT[18] = vT[19] + vT[20]
  vT[17].eloMax = vT[18]
  vT[16].SolNode129 = vT[17]
  vT[17] = { levelOverride = nil, goalTag = nil }
  vT[18] = WeakResource
  vT[19] = "/Lotus/Levels/Proc/TauPrequel/EntratiLabHubTauPrequel"
  vT[18] = vT[18](vT[19])
  vT[17].levelOverride = vT[18]
  vT[18] = Symbol
  vT[19] = "PostOldPeace"
  vT[18] = vT[18](vT[19])
  vT[17].goalTag = vT[18]
  vT[16].EntratiLabHub = vT[17]
  vT[17] = { levelOverride = nil, goalTag = nil }
  vT[18] = WeakResource
  vT[19] = "/Lotus/Levels/Proc/TauPrequel/EntratiLabHubTauPrequel"
  vT[18] = vT[18](vT[19])
  vT[17].levelOverride = vT[18]
  vT[18] = Symbol
  vT[19] = "PostOldPeace"
  vT[18] = vT[18](vT[19])
  vT[17].goalTag = vT[18]
  vT[16].DeimosHub = vT[17]
  POST_NEW_WAR_MISSIONS = vT[16]
  vT[17] = "SolNode236"
  vT[18] = "SolNode237"
  vT[19] = "SolNode238"
  vT[20] = "/Lotus/Types/Keys/DuviriQuest/DuviriKullervoEventKey"
  vT[16] = {vT[17], vT[18], vT[19], vT[20]}
  DUVIRI_MISSION_NODES = vT[16]
  vT[16] = "SolNode238"
  DUVIRI_ENDLESS_NODE = vT[16]
  vT[17] = "SolNode715"
  vT[18] = "SolNode716"
  vT[19] = "SolNode717"
  vT[20] = "SolNode718"
  vT[21] = "SolNode719"
  vT[22] = "SolNode720"
  vT[23] = "SolNode721"
  vT[24] = "SolNode722"
  vT[16] = {vT[17], vT[18], vT[19], vT[20], vT[21], vT[22], vT[23], vT[24]}
  ENTRATI_LAB_MISSION_NODES = vT[16]
  vT[17] = "1999PlayerHome"
  vT[18] = "1999Hub"
  vT[19] = "SolNode850"
  vT[20] = "SolNode851"
  vT[21] = "SolNode852"
  vT[22] = "SolNode853"
  vT[23] = "SolNode854"
  vT[24] = "SolNode855"
  vT[25] = "SolNode856"
  vT[26] = "SolNode857"
  vT[27] = "SolNode858"
  vT[28] = "SolNode859"
  vT[29] = "SolNode860"
  vT[16] = {vT[17], vT[18], vT[19], vT[20], vT[21], vT[22], vT[23], vT[24], vT[25], vT[26], vT[27], vT[28], vT[29]}
  VANIA_MISSION_NODES = vT[16]
  vT[17] = "SolNode230"
  vT[18] = "SolNode231"
  vT[19] = "SolNode232"
  vT[20] = "SolNode233"
  vT[21] = "SolNode235"
  vT[16] = {vT[17], vT[18], vT[19], vT[20], vT[21]}
  ZARIMAN_MISSION_NODES = vT[16]
  vT[17] = "SolNode253"
  vT[18] = "SolNode254"
  vT[19] = "SolNode255"
  vT[20] = "SolNode256"
  vT[16] = {vT[17], vT[18], vT[19], vT[20]}
  DESCENT_MISSION_NODES = vT[16]
  vT[17] = "SolNode250"
  vT[18] = "SolNode251"
  vT[19] = "SolNode252"
  vT[20] = "SolNode257"
  vT[16] = {vT[17], vT[18], vT[19], vT[20]}
  TAU_BATTLE_MISSION_NODES = vT[16]
  vT[16] = Symbol
  vT[17] = "JadeShadowsEvent"
  vT[16] = vT[16](vT[17])
  JADE_SHADOWS_GOAL_TAG = vT[16]
  vT[17] = { progressReq = 0.3, reward = nil, progressText = "/Lotus/Language/JadeShadows/JadeShadowsEventProgress0" }
  vT[18] = WeakResource
  vT[19] = "/Lotus/StoreItems/Upgrades/Skins/Effects/JadeLightEphemeraA"
  vT[18] = vT[18](vT[19])
  vT[17].reward = vT[18]
  vT[18] = { progressReq = 0.6, reward = nil, progressText = "/Lotus/Language/JadeShadows/JadeShadowsEventProgress1" }
  vT[19] = WeakResource
  vT[20] = "/Lotus/StoreItems/Upgrades/Skins/Effects/JadeLightEphemeraB"
  vT[19] = vT[19](vT[20])
  vT[18].reward = vT[19]
  vT[19] = { progressReq = 0.9, reward = nil, progressText = "/Lotus/Language/JadeShadows/JadeShadowsEventProgress2" }
  vT[20] = WeakResource
  vT[21] = "/Lotus/StoreItems/Upgrades/Skins/Effects/JadeLightEphemeraC"
  vT[20] = vT[20](vT[21])
  vT[19].reward = vT[20]
  vT[16] = {vT[17], vT[18], vT[19]}
  JADE_SHADOWS_EVENT_REWARDS = vT[16]
  vT[18] = 15
  vT[19] = 30
  vT[20] = 45
  vT[21] = 60
  vT[17] = {vT[18], vT[19], vT[20], vT[21]}
  vT[19] = 45
  vT[20] = 90
  vT[21] = 135
  vT[22] = 180
  vT[18] = {vT[19], vT[20], vT[21], vT[22]}
  vT[20] = 150
  vT[21] = 300
  vT[22] = 450
  vT[23] = 600
  vT[19] = {vT[20], vT[21], vT[22], vT[23]}
  vT[21] = 450
  vT[22] = 900
  vT[23] = 1350
  vT[24] = 1800
  vT[20] = {vT[21], vT[22], vT[23], vT[24]}
  vT[22] = 1500
  vT[23] = 3000
  vT[24] = 4500
  vT[25] = 6000
  vT[21] = {vT[22], vT[23], vT[24], vT[25]}
  vT[16] = {vT[17], vT[18], vT[19], vT[20], vT[21]}
  JADE_SHADOWS_EVENT_TROPHY_REWARD_THRESHOLDS = vT[16]
  vT[16] = Symbol
  vT[17] = "DuviriMurmurEvent"
  vT[16] = vT[16](vT[17])
  DUVIRI_MURMUR_EVENT_GOAL_TAG = vT[16]
  vT[17] = { progressReq = 0.3, reward = nil, progressText = "/Lotus/Language/Isleweaver/IsleweaverEventProgress0" }
  vT[18] = WeakResource
  vT[19] = "/Lotus/StoreItems/Upgrades/Skins/Crowns/Events/IsleweaverEventCrownA"
  vT[18] = vT[18](vT[19])
  vT[17].reward = vT[18]
  vT[18] = { progressReq = 0.6, reward = nil, progressText = "/Lotus/Language/Isleweaver/IsleweaverEventProgress1" }
  vT[19] = WeakResource
  vT[20] = "/Lotus/StoreItems/Upgrades/Skins/Crowns/Events/IsleweaverEventCrownB"
  vT[19] = vT[19](vT[20])
  vT[18].reward = vT[19]
  vT[19] = { progressReq = 0.9, reward = nil, progressText = "/Lotus/Language/Isleweaver/IsleweaverEventProgress2" }
  vT[20] = WeakResource
  vT[21] = "/Lotus/StoreItems/Upgrades/Skins/Crowns/Events/IsleweaverEventCrownC"
  vT[20] = vT[20](vT[21])
  vT[19].reward = vT[20]
  vT[16] = {vT[17], vT[18], vT[19]}
  DUVIRI_MURMUR_EVENT_REWARDS = vT[16]
  vT[18] = 260
  vT[19] = 519
  vT[20] = 779
  vT[21] = 1038
  vT[17] = {vT[18], vT[19], vT[20], vT[21]}
  vT[19] = 779
  vT[20] = 1557
  vT[21] = 2336
  vT[22] = 3114
  vT[18] = {vT[19], vT[20], vT[21], vT[22]}
  vT[20] = 2595
  vT[21] = 5190
  vT[22] = 7785
  vT[23] = 10380
  vT[19] = {vT[20], vT[21], vT[22], vT[23]}
  vT[21] = 7785
  vT[22] = 15570
  vT[23] = 23355
  vT[24] = 31140
  vT[20] = {vT[21], vT[22], vT[23], vT[24]}
  vT[22] = 25950
  vT[23] = 51900
  vT[24] = 77850
  vT[25] = 103800
  vT[21] = {vT[22], vT[23], vT[24], vT[25]}
  vT[16] = {vT[17], vT[18], vT[19], vT[20], vT[21]}
  DUVIRI_MURMUR_EVENT_TROPHY_REWARD_THRESHOLDS = vT[16]
  vT[16] = Symbol
  vT[17] = "ShadowgrapherEvent"
  vT[16] = vT[16](vT[17])
  SHADOWGRAPHER_EVENT_GOAL_TAG = vT[16]
  vT[17] = { progressReq = 0.3, reward = nil, progressText = "/Lotus/Language/Shadowgrapher/ShadowgrapherEventProgress0" }
  vT[18] = WeakResource
  vT[19] = "/Lotus/StoreItems/Upgrades/Skins/Effects/InkEphemeraA"
  vT[18] = vT[18](vT[19])
  vT[17].reward = vT[18]
  vT[18] = { progressReq = 0.6, reward = nil, progressText = "/Lotus/Language/Shadowgrapher/ShadowgrapherEventProgress1" }
  vT[19] = WeakResource
  vT[20] = "/Lotus/StoreItems/Upgrades/Skins/Effects/InkEphemeraB"
  vT[19] = vT[19](vT[20])
  vT[18].reward = vT[19]
  vT[19] = { progressReq = 0.9, reward = nil, progressText = "/Lotus/Language/Shadowgrapher/ShadowgrapherEventProgress2" }
  vT[20] = WeakResource
  vT[21] = "/Lotus/StoreItems/Upgrades/Skins/Effects/InkEphemeraC"
  vT[20] = vT[20](vT[21])
  vT[19].reward = vT[20]
  vT[16] = {vT[17], vT[18], vT[19]}
  SHADOWGRAPHER_EVENT_REWARDS = vT[16]
  vT[18] = 84
  vT[19] = 168
  vT[20] = 252
  vT[21] = 336
  vT[17] = {vT[18], vT[19], vT[20], vT[21]}
  vT[19] = 252
  vT[20] = 504
  vT[21] = 756
  vT[22] = 1008
  vT[18] = {vT[19], vT[20], vT[21], vT[22]}
  vT[20] = 840
  vT[21] = 1680
  vT[22] = 2520
  vT[23] = 3360
  vT[19] = {vT[20], vT[21], vT[22], vT[23]}
  vT[21] = 2520
  vT[22] = 5040
  vT[23] = 7560
  vT[24] = 10080
  vT[20] = {vT[21], vT[22], vT[23], vT[24]}
  vT[22] = 8400
  vT[23] = 16800
  vT[24] = 25200
  vT[25] = 33600
  vT[21] = {vT[22], vT[23], vT[24], vT[25]}
  vT[16] = {vT[17], vT[18], vT[19], vT[20], vT[21]}
  SHADOWGRAPHER_EVENT_TROPHY_REWARD_THRESHOLDS = vT[16]
  vT[16] = 1
  HT_PROGRESS_BAR = vT[16]
  vT[16] = 2
  HT_TIMER = vT[16]
  vT[16] = 3
  HT_HEALTH_TRACKER = vT[16]
  vT[16] = 4
  HT_ICON_BAR = vT[16]
  vT[16] = 5
  HT_OPPONENT_BAR = vT[16]
  vT[16] = 6
  HT_LABEL = vT[16]
  vT[16] = 7
  HT_TEMPERATURE_BAR = vT[16]
  vT[16] = 8
  HT_CORRUPTION_BAR = vT[16]
  vT[16] = 9
  HT_NODE_CONFLICT_BAR = vT[16]
  vT[16] = 10
  HT_DRAGON_TRACKER = vT[16]
  vT[16] = 11
  HT_ALCHEMY_BAR = vT[16]
  vT[16] = 12
  HT_ELEVATOR = vT[16]
  vT[16] = 13
  HT_PVPVE_OBJS = vT[16]
  vT[16] = 14
  HT_BOOSTS_HINDERS = vT[16]
  vT[16] = 15
  HT_SHADOWGRAPHER_METER = vT[16]
  vT[16] = 16
  HT_PAINT_METER = vT[16]
  vT[17] = gDecorationType
  vT[18] = gDynamicCoverType
  vT[19] = gEmplacementType
  vT[20] = gDevourerType
  vT[22] = gBaseAvatarType
  vT[23] = gHitProxyType
  vT[24] = gPickUpType
  vT[16] = {vT[17], vT[18], vT[19], vT[20], vT[7], vT[22], vT[23], vT[24]}
  SCAN_ENTITY_TYPES = vT[16]
  vT[16] = { HOURS_PER_SECOND_EIDOLON = 0.0026670001, HOURS_PER_SECOND_VENUS = 0.015, HOURS_PER_SECOND_ENTRATI = 0.0026670001, HOURS_PER_SECOND_ZARIMAN = 0.0016666667, TIME_OF_DAY_LABEL_NIGHT = "/Lotus/Language/Game/TimeOfDay_Night", TIME_OF_DAY_LABEL_DAY = "/Lotus/Language/Game/TimeOfDay_Day", TIME_OF_DAY_LABEL_WARM = "/Lotus/Language/Game/TimeOfDay_Warm", TIME_OF_DAY_LABEL_COLD = "/Lotus/Language/Game/TimeOfDay_Cold", TIME_OF_DAY_LABEL_FASS = "/Lotus/Language/Mods/ImmortalSixModName", TIME_OF_DAY_LABEL_VOME = "/Lotus/Language/Mods/ImmortalFourModName", TIME_OF_DAY_LABEL_CONFLICT = "/Lotus/Language/Game/Territory_Conflict", TIME_OF_DAY_LABEL_CORPUS = "/Lotus/Language/Zariman/ZarimanInfluenceCorpus", TIME_OF_DAY_LABEL_GRINEER = "/Lotus/Language/Zariman/ZarimanInfluenceGrineer" }
  TimeOfDayConstants = vT[16]
  vT[16] = { DENY = nil, ALLOW = 1, ALLOW_WHILE_SPEEDABLE_TRANSMISSIONS = 2 }
  SpeedUpRule = vT[16]
  vT[17] = Symbol
  vT[18] = "GAME_L1_ARM2"
  vT[17] = vT[17](vT[18])
  vT[18] = Symbol
  vT[19] = "GAME_C1_HEAD1"
  vT[18] = vT[18](vT[19])
  vT[19] = Symbol
  vT[20] = "GAME_R1_LEG1"
  vT[19] = vT[19](vT[20])
  vT[20] = Symbol
  vT[21] = "GAME_L1_LEG2"
  vT[16] = {vT[17], vT[18], vT[19], vT[20](vT[21])}
  vT[17] = require
  vT[18] = "EE.Interface.Utilities"
  vT[17] = vT[17](vT[18])
  vT[18] = require
  vT[19] = "Lotus.Interface.UIStyleUtilities"
  vT[18] = vT[18](vT[19])
  vT[20] = "#FFFFFF"
  vT[21] = "#24D628"
  vT[22] = "#238DFF"
  vT[23] = "#C724D6"
  vT[19] = {vT[20], vT[21], vT[22], vT[23]}
  vT[21] = 16777215
  vT[22] = 2414120
  vT[23] = 2330111
  vT[24] = 13051094
  vT[20] = {vT[21], vT[22], vT[23], vT[24]}
  vT[21] = 0
  vT[22] = { mScanPoint = nil, mKuvaSurvivalTag = nil, mVoidEclipseSurvivalTag = nil }
  vT[23] = Symbol
  vT[24] = "ScanPoint"
  vT[23] = vT[23](vT[24])
  vT[22].mScanPoint = vT[23]
  vT[23] = Symbol
  vT[24] = "KuvaSurvival"
  vT[23] = vT[23](vT[24])
  vT[22].mKuvaSurvivalTag = vT[23]
  vT[23] = Symbol
  vT[24] = "VoidEclipse"
  vT[23] = vT[23](vT[24])
  vT[22].mVoidEclipseSurvivalTag = vT[23]
  vT[23] = {}
  vT[24] = { Scale = 1500, X = 0, Y = 0, Alpha = 5 }
  vT[23].Default = vT[24]
  vT[24] = { Scale = 2000, X = 40, Y = -40 }
  vT[23]["/Lotus/Interface/Icons/Syndicates/FactionSigilRebels.png"] = vT[24]
  vT[24] = { Scale = 1000, X = 0, Y = 0, Alpha = 8 }
  vT[23]["/Lotus/Interface/Icons/Syndicates/FactionSigilOracle.png"] = vT[24]
  vT[24] = { Scale = 2400, X = 0, Y = 20 }
  vT[23]["/Lotus/Interface/Icons/Syndicates/FactionSigilBusiness.png"] = vT[24]
  vT[24] = { Scale = 1300, X = -50, Y = 0 }
  vT[23]["/Lotus/Interface/Icons/Syndicates/FactionSigilAssassins.png"] = vT[24]
  vT[24] = { Scale = 1500, X = 0, Y = 60 }
  vT[23]["/Lotus/Interface/Icons/Syndicates/FactionSigilChurch.png"] = vT[24]
  vT[24] = { Scale = 1500, X = 0, Y = 40, Alpha = 15 }
  vT[23]["/Lotus/Interface/Icons/Syndicates/FactionSigilEidolonHunter.png"] = vT[24]
  vT[24] = { Scale = 1000, X = 0, Y = 0, Alpha = 8 }
  vT[23]["/Lotus/Interface/Graphics/Fortuna/FortunaTitleIcon.png"] = vT[24]
  vT[24] = { Scale = 1500, X = 0, Y = 40, Alpha = 8 }
  vT[23]["/Lotus/Interface/Icons/Syndicates/FactionVentKidz.png"] = vT[24]
  vT[24] = { Scale = 1500, X = 0, Y = 0, Alpha = 15 }
  vT[23]["/Lotus/Interface/Icons/Syndicates/FactionSigilSolarisUnited.png"] = vT[24]
  vT[24] = { Scale = 1300, X = 0, Y = 0, Alpha = 7 }
  vT[23]["/Lotus/Interface/Icons/Syndicates/FactionSigilConclave.png"] = vT[24]
  vT[24] = nil
  vT[25] = nil
  vT[26] = nil
  vT[27] = nil
  vT[28] = nil
  vT[29] = nil
  vT[30] = nil
  vT[31] = nil
  vT[32] = {}
  vT[33] = {}
  vT[34] = 0
  vT[35] = true
  vT[33][vT[34]] = vT[35]
  vT[34] = true
  vT[33][1] = vT[34]
  vT[32][2] = vT[33]
  vT[33] = {}
  vT[34] = true
  vT[33][2] = vT[34]
  vT[34] = true
  vT[33][3] = vT[34]
  vT[32][3] = vT[33]
  vT[33] = {}
  vT[34] = true
  vT[33][8] = vT[34]
  vT[34] = true
  vT[33][9] = vT[34]
  vT[32][4] = vT[33]
  vT[33] = {}
  vT[34] = true
  vT[33][4] = vT[34]
  vT[34] = true
  vT[33][5] = vT[34]
  vT[32][5] = vT[33]
  vT[33] = {}
  vT[34] = true
  vT[33][12] = vT[34]
  vT[34] = true
  vT[33][13] = vT[34]
  vT[32][6] = vT[33]
  vT[33] = {}
  vT[34] = true
  vT[33][16] = vT[34]
  vT[34] = true
  vT[33][17] = vT[34]
  vT[32][7] = vT[33]
  vT[33] = {}
  vT[34] = true
  vT[33][20] = vT[34]
  vT[34] = true
  vT[33][21] = vT[34]
  vT[32][8] = vT[33]
  vT[33] = {}
  vT[34] = true
  vT[33][24] = vT[34]
  vT[34] = true
  vT[33][25] = vT[34]
  vT[32][9] = vT[33]
  vT[33] = {}
  vT[34] = true
  vT[33][22] = vT[34]
  vT[34] = true
  vT[33][23] = vT[34]
  vT[32][10] = vT[33]
  vT[33] = {}
  vT[34] = true
  vT[33][18] = vT[34]
  vT[34] = true
  vT[33][19] = vT[34]
  vT[32][11] = vT[33]
  vT[33] = {}
  vT[34] = true
  vT[33][13] = vT[34]
  vT[34] = true
  vT[33][14] = vT[34]
  vT[32][12] = vT[33]
  vT[33] = {}
  vT[34] = true
  vT[33][6] = vT[34]
  vT[34] = true
  vT[33][7] = vT[34]
  vT[32][13] = vT[33]
  vT[33] = {}
  vT[34] = true
  vT[33][10] = vT[34]
  vT[34] = true
  vT[33][11] = vT[34]
  vT[32][16] = vT[33]
  vT[33] = WeakResource
  vT[34] = "/Lotus/Types/Keys/InfestedMicroplanetQuest/InfestedMicroplanetQuestKeyChain"
  vT[33] = vT[33](vT[34])
  vT[34] = WeakResource
  vT[35] = "/Lotus/Types/Keys/1999Quest/1999QuestKeyChain"
  vT[34] = vT[34](vT[35])
  vT[35] = WeakResource
  vT[36] = "/Lotus/Types/Keys/SolarisQuest/SolarisQuestKeyChain"
  vT[35] = vT[35](vT[36])
  vT[36] = WeakResource
  vT[37] = "/Lotus/Types/Keys/EntratiLab/EntratiQuestKeyChain"
  vT[36] = vT[36](vT[37])
  vT[38] = WeakResource
  vT[39] = "/Lotus/Types/Keys/NewWarQuest/NewWarQuestKeyChain"
  vT[38] = vT[38](vT[39])
  vT[39] = WeakResource
  vT[40] = "/Lotus/Types/Keys/NewWarIntroQuest/NewWarIntroKeyChain"
  vT[39] = vT[39](vT[40])
  vT[40] = WeakResource
  vT[41] = "/Lotus/Types/Keys/SacrificeQuest/SacrificeQuestKeyChain"
  vT[40] = vT[40](vT[41])
  vT[41] = WeakResource
  vT[42] = "/Lotus/Types/Keys/ChimeraQuest/ChimeraKeyChain"
  vT[37] = {vT[38], vT[39], vT[40], vT[41](vT[42])}
  vT[38] = WeakResource
  vT[39] = "/Lotus/Types/Keys/TauPrequel/TauPrequelQuestKeyChain"
  vT[38] = vT[38](vT[39])
  vT[39] = {}
  vT[40] = 1
  vT[39].Basic = vT[40]
  vT[40] = 2
  vT[39].Glossy = vT[40]
  vT[40] = 3
  vT[39].Chromatic = vT[40]
  vT[40] = {}
  vT[42] = Symbol
  vT[43] = "/Lotus/Language/Loadout/LoadoutCat_Rifle"
  vT[42] = vT[42](vT[43])
  vT[43] = Symbol
  vT[44] = "/Lotus/Language/Loadout/LoadoutCat_MG"
  vT[41] = {vT[42], vT[43](vT[44])}
  vT[40].LotusAssaultRifle = vT[41]
  vT[42] = Symbol
  vT[43] = "/Lotus/Language/Loadout/LoadoutCat_Shotgun"
  vT[41] = {vT[42](vT[43])}
  vT[40].LotusShotgun = vT[41]
  vT[42] = Symbol
  vT[43] = "/Lotus/Language/Loadout/LoadoutCat_Precision"
  vT[41] = {vT[42](vT[43])}
  vT[40].LotusSniperRifle = vT[41]
  vT[42] = Symbol
  vT[43] = "/Lotus/Language/Loadout/LoadoutCat_Bow"
  vT[41] = {vT[42](vT[43])}
  vT[40].LotusBow = vT[41]
  vT[41] = function(c1v0)
    local c1v1, c1v2
    c1v1 = c1v0:Name__2d897740()
    c1v2 = IsNull
    c1v2 = c1v2(c1v1)
    if not c1v2 then
      do return c1v1:GetOwnedPowerSuitAvatar() end
    end
    c1v2 = nil
    do return c1v2 end
  end
  GetWarframeFromOperator = vT[41]
  vT[41] = function(c2v0)
    local c2v1, c2v2, c2v3, c2v5, c2v6
    c2v3 = gLotusVehicleAvatarType
    c2v1 = c2v0:IsA(c2v3)
    if c2v1 then
      c2v1 = c2v0:GetRider()
      c2v2 = IsNull
      c2v2 = c2v2(c2v1)
      if not c2v2 then
        c2v5 = Vector
        c2v5 = c2v5()
        c2v6 = true
        c2v0:GetOffVehicle(c2v1, c2v5, c2v6)
        c2v0 = c2v1
      end
    end
    do return c2v0 end
  end
  UnmountVehicleAndGetRider = vT[41]
  vT[41] = function(c3v0, c3v1)
    local c3v2, c3v3, c3v4, c3v5
    c3v2 = vT[17]
    c3v2 = c3v2.Ternary
    if c3v1 == nil then
      c3v3 = false
    else
      c3v3 = true
    end
    c3v5 = 2
    c3v2 = c3v2(c3v3, c3v1, c3v5)
    c3v3 = getfenv
    c3v3 = c3v3(c3v2)
    while true do
      c3v4 = c3v3.mMovie
      c3v4 = IsNull
      c3v4 = c3v4(c3v0)
      if c3v4 then break end
      c3v4 = c3v3.mMovie
      if c3v4 == c3v0 then break end
      c3v2 = c3v2 + 1
      c3v4 = getfenv
      c3v3 = c3v4(c3v2)
    end
    do return c3v3 end
  end
  vT[42] = function(c4v0, c4v1)
    local c4v2
    c4v2 = vT[41]
    do return c4v2(c4v0, c4v1) end
  end
  GetEnv = vT[42]
  vT[42] = function()
    local c5v0, c5v1
    c5v0 = _T.hasCheckedTutorial
    if c5v0 ~= nil then
      c5v0 = _T.hasCheckedTutorial
      if c5v0 then
        c5v0 = false
        c5v1 = _T.tutorialActive
        if c5v1 ~= nil then
          c5v0 = _T.tutorialActive
        end
        do return c5v0 end
      end
    end
    c5v0 = true
    do return c5v0 end
  end
  ShouldBlockForTutorial = vT[42]
  vT[42] = function()
    local c6v0, c6v1, c6v2, c6v3, c6v4, c6v5, c6v6, c6v7, c6v8, c6v9, c6v10, c6v11, c6v12, c6v13, c6v14, c6v15, c6v16
    c6v1 = 4591633
    c6v2 = 6756120
    c6v3 = 9773092
    c6v4 = 12265515
    c6v5 = 13708851
    c6v6 = 4003870
    c6v7 = 5775914
    c6v8 = 8663871
    c6v9 = 11421784
    c6v10 = 13260653
    c6v11 = 2100501
    c6v12 = 3873573
    c6v13 = 7419972
    c6v14 = 11428207
    c6v15 = 13928599
    c6v16 = 2492950
    c6v0 = {c6v1, c6v2, c6v3, c6v4, c6v5, c6v6, c6v7, c6v8, c6v9, c6v10, c6v11, c6v12, c6v13, c6v14, c6v15, c6v16}
    c6v1 = 4067364
    c6v2 = 7216189
    c6v3 = 10299227
    c6v4 = 12464506
    c6v5 = 987681
    c6v6 = 1448500
    c6v7 = 2502747
    c6v8 = 3950990
    c6v9 = 5334711
    c6v10 = 530470
    c6v11 = 797252
    c6v12 = 1460087
    c6v13 = 1994408
    c6v14 = 2396358
    c6v15 = 930629
    c6v16 = 1526113
    c6v0[17] = c6v1
    c6v0[18] = c6v2
    c6v0[19] = c6v3
    c6v0[20] = c6v4
    c6v0[21] = c6v5
    c6v0[22] = c6v6
    c6v0[23] = c6v7
    c6v0[24] = c6v8
    c6v0[25] = c6v9
    c6v0[26] = c6v10
    c6v0[27] = c6v11
    c6v0[28] = c6v12
    c6v0[29] = c6v13
    c6v0[30] = c6v14
    c6v0[31] = c6v15
    c6v0[32] = c6v16
    c6v1 = 2716301
    c6v2 = 4169655
    c6v3 = 5619666
    c6v4 = 1650218
    c6v5 = 2442557
    c6v6 = 3828063
    c6v7 = 5543563
    c6v8 = 7388337
    c6v9 = 1125400
    c6v10 = 1721894
    c6v11 = 2914624
    c6v12 = 4303198
    c6v13 = 5491068
    c6v14 = 3816203
    c6v15 = 6317074
    c6v16 = 9409055
    c6v0[33] = c6v1
    c6v0[34] = c6v2
    c6v0[35] = c6v3
    c6v0[36] = c6v4
    c6v0[37] = c6v5
    c6v0[38] = c6v6
    c6v0[39] = c6v7
    c6v0[40] = c6v8
    c6v0[41] = c6v9
    c6v0[42] = c6v10
    c6v0[43] = c6v11
    c6v0[44] = c6v12
    c6v0[45] = c6v13
    c6v0[46] = c6v14
    c6v0[47] = c6v15
    c6v0[48] = c6v16
    c6v1 = 12106284
    c6v2 = 13750327
    c6v3 = 5916201
    c6v4 = 8347962
    c6v5 = 11111504
    c6v6 = 13546858
    c6v7 = 15126918
    c6v8 = 8143131
    c6v9 = 9589797
    c6v10 = 11366711
    c6v11 = 13014608
    c6v12 = 14530158
    c6v13 = 10107422
    c6v14 = 11751209
    c6v15 = 13529661
    c6v16 = 14786650
    c6v0[49] = c6v1
    c6v0[50] = c6v2
    c6v0[51] = c6v3
    c6v0[52] = c6v4
    c6v0[53] = c6v5
    c6v0[54] = c6v6
    c6v0[55] = c6v7
    c6v0[56] = c6v8
    c6v0[57] = c6v9
    c6v0[58] = c6v10
    c6v0[59] = c6v11
    c6v0[60] = c6v12
    c6v0[61] = c6v13
    c6v0[62] = c6v14
    c6v0[63] = c6v15
    c6v0[64] = c6v16
    c6v1 = 15254401
    c6v2 = 3282697
    c6v3 = 6301969
    c6v4 = 10767646
    c6v5 = 13726758
    c6v6 = 14127655
    c6v7 = 2694428
    c6v8 = 4994866
    c6v9 = 9398364
    c6v10 = 13213582
    c6v11 = 14991277
    c6v12 = 2631460
    c6v13 = 6117971
    c6v14 = 12499631
    c6v15 = 16118763
    c6v16 = 16777215
    c6v0[65] = c6v1
    c6v0[66] = c6v2
    c6v0[67] = c6v3
    c6v0[68] = c6v4
    c6v0[69] = c6v5
    c6v0[70] = c6v6
    c6v0[71] = c6v7
    c6v0[72] = c6v8
    c6v0[73] = c6v9
    c6v0[74] = c6v10
    c6v0[75] = c6v11
    c6v0[76] = c6v12
    c6v0[77] = c6v13
    c6v0[78] = c6v14
    c6v0[79] = c6v15
    c6v0[80] = c6v16
    c6v1 = 2106148
    c6v2 = 4673359
    c6v3 = 9872548
    c6v4 = 14082529
    c6v5 = 15989754
    c6v6 = 1908258
    c6v7 = 4145995
    c6v8 = 9080479
    c6v9 = 13225437
    c6v10 = 15199223
    c6v0[81] = c6v1
    c6v0[82] = c6v2
    c6v0[83] = c6v3
    c6v0[84] = c6v4
    c6v0[85] = c6v5
    c6v0[86] = c6v6
    c6v0[87] = c6v7
    c6v0[88] = c6v8
    c6v0[89] = c6v9
    c6v0[90] = c6v10
    do return c6v0 end
  end
  GetPhotoshopDefaultSwatches = vT[42]
  vT[42] = function()
    local c7v0, c7v1, c7v2, c7v3, c7v4, c7v5, c7v6, c7v7, c7v8, c7v9, c7v10, c7v11, c7v12, c7v13, c7v14, c7v15, c7v16, c7v17
    c7v1 = { Type = nil, Name = "/Lotus/Language/Items/AdventurerKubrowName" }
    c7v2 = WeakResource
    c7v3 = "/Lotus/Types/Game/KubrowPet/AdventurerKubrowPetPowerSuit"
    c7v2 = c7v2(c7v3)
    c7v1.Type = c7v2
    c7v2 = { Type = nil, Name = "/Lotus/Language/Items/FurtiveKubrowName" }
    c7v3 = WeakResource
    c7v4 = "/Lotus/Types/Game/KubrowPet/FurtiveKubrowPetPowerSuit"
    c7v3 = c7v3(c7v4)
    c7v2.Type = c7v3
    c7v3 = { Type = nil, Name = "/Lotus/Language/Items/GuardKubrowName" }
    c7v4 = WeakResource
    c7v5 = "/Lotus/Types/Game/KubrowPet/GuardKubrowPetPowerSuit"
    c7v4 = c7v4(c7v5)
    c7v3.Type = c7v4
    c7v4 = { Type = nil, Name = "/Lotus/Language/Items/HunterKubrowName" }
    c7v5 = WeakResource
    c7v6 = "/Lotus/Types/Game/KubrowPet/HunterKubrowPetPowerSuit"
    c7v5 = c7v5(c7v6)
    c7v4.Type = c7v5
    c7v5 = { Type = nil, Name = "/Lotus/Language/Items/RetrieverKubrowName" }
    c7v6 = WeakResource
    c7v7 = "/Lotus/Types/Game/KubrowPet/RetrieverKubrowPetPowerSuit"
    c7v6 = c7v6(c7v7)
    c7v5.Type = c7v6
    c7v6 = { Type = nil, Name = "/Lotus/Language/Items/InfestedKubrowName" }
    c7v7 = WeakResource
    c7v8 = "/Lotus/Types/Game/KubrowPet/ChargerKubrowPetPowerSuit"
    c7v7 = c7v7(c7v8)
    c7v6.Type = c7v7
    c7v7 = { Type = nil, Name = "/Lotus/Language/Items/MirrorCatbrowName" }
    c7v8 = WeakResource
    c7v9 = "/Lotus/Types/Game/CatbrowPet/MirrorCatbrowPetPowerSuit"
    c7v8 = c7v8(c7v9)
    c7v7.Type = c7v8
    c7v8 = { Type = nil, Name = "/Lotus/Language/Items/CheshireCatbrowName" }
    c7v9 = WeakResource
    c7v10 = "/Lotus/Types/Game/CatbrowPet/CheshireCatbrowPetPowerSuit"
    c7v9 = c7v9(c7v10)
    c7v8.Type = c7v9
    c7v9 = { Type = nil, Name = "/Lotus/Language/Pets/VampireKavatName" }
    c7v10 = WeakResource
    c7v11 = "/Lotus/Types/Game/CatbrowPet/VampireCatbrowPetPowerSuit"
    c7v10 = c7v10(c7v11)
    c7v9.Type = c7v10
    c7v10 = { Type = nil, Name = "/Lotus/Language/InfestedMicroplanet/InfestedPredatorCommonName" }
    c7v11 = WeakResource
    c7v12 = "/Lotus/Types/Friendly/Pets/CreaturePets/VizierPredatorKubrowPetPowerSuit"
    c7v11 = c7v11(c7v12)
    c7v10.Type = c7v11
    c7v11 = { Type = nil, Name = "/Lotus/Language/InfestedMicroplanet/InfestedPredatorRareName" }
    c7v12 = WeakResource
    c7v13 = "/Lotus/Types/Friendly/Pets/CreaturePets/MedjayPredatorKubrowPetPowerSuit"
    c7v12 = c7v12(c7v13)
    c7v11.Type = c7v12
    c7v12 = { Type = nil, Name = "/Lotus/Language/InfestedMicroplanet/InfestedPredatorUncommonName" }
    c7v13 = WeakResource
    c7v14 = "/Lotus/Types/Friendly/Pets/CreaturePets/PharaohPredatorKubrowPetPowerSuit"
    c7v13 = c7v13(c7v14)
    c7v12.Type = c7v13
    c7v13 = { Type = nil, Name = "/Lotus/Language/InfestedMicroplanet/InfestedCritterRareName" }
    c7v14 = WeakResource
    c7v15 = "/Lotus/Types/Friendly/Pets/CreaturePets/ArmoredInfestedCatbrowPetPowerSuit"
    c7v14 = c7v14(c7v15)
    c7v13.Type = c7v14
    c7v14 = { Type = nil, Name = "/Lotus/Language/InfestedMicroplanet/InfestedCritterUncommonName" }
    c7v15 = WeakResource
    c7v16 = "/Lotus/Types/Friendly/Pets/CreaturePets/HornedInfestedCatbrowPetPowerSuit"
    c7v15 = c7v15(c7v16)
    c7v14.Type = c7v15
    c7v15 = { Type = nil, Name = "/Lotus/Language/InfestedMicroplanet/InfestedCritterCommonName" }
    c7v16 = WeakResource
    c7v17 = "/Lotus/Types/Friendly/Pets/CreaturePets/VulpineInfestedCatbrowPetPowerSuit"
    c7v16 = c7v16(c7v17)
    c7v15.Type = c7v16
    c7v0 = {c7v1, c7v2, c7v3, c7v4, c7v5, c7v6, c7v7, c7v8, c7v9, c7v10, c7v11, c7v12, c7v13, c7v14, c7v15}
    c7v3 = 1
    c7v1 = #c7v0
    c7v2 = 1
    for c7v3 = c7v3, c7v1, c7v2 do
      c7v4 = c7v0[c7v3]
      c7v6 = _G
      c7v6 = c7v6.UITexture_CompanionIcons
      c7v5 = c7v6[c7v3]
      c7v4.Icon = c7v5
    end
    do return c7v0 end
  end
  GetKubrowTypesTable = vT[42]
  vT[42] = function(c8v0, c8v1, c8v2, c8v3, c8v4, c8v5)
    local c8v6, c8v7, c8v8, c8v9, c8v10, c8v11, c8v12, c8v13, c8v14, c8v15, c8v16, c8v17, c8v18, c8v19, c8v20
    c8v6 = Localize
    c8v7 = "/Lotus/Language/Menu/TimeFormat_DaysShort"
    c8v8 = false
    c8v6 = c8v6(c8v7, c8v8)
    c8v7 = Localize
    c8v8 = "/Lotus/Language/Menu/TimeFormat_HoursShort"
    c8v9 = false
    c8v7 = c8v7(c8v8, c8v9)
    c8v8 = Localize
    c8v9 = "/Lotus/Language/Menu/TimeFormat_MinutesShort"
    c8v10 = false
    c8v8 = c8v8(c8v9, c8v10)
    c8v9 = Localize
    c8v10 = "/Lotus/Language/Menu/TimeFormat_SecondsShort"
    c8v11 = false
    c8v9 = c8v9(c8v10, c8v11)
    if not c8v4 then
      c8v10 = 0
      if c8v10 < c8v0 then
        c8v12 = string.format
        c8v14 = "%d"
        c8v16 = " %d"
        c8v18 = " %d"
        c8v20 = " %d"
        c8v13 = c8v14 .. c8v6 .. c8v16 .. c8v7 .. c8v18 .. c8v8 .. c8v20 .. c8v9
        c8v12 = c8v12(c8v13, c8v0, c8v1, c8v2, c8v3)
        c8v10 = c8v5 .. c8v12
        do return c8v10 end
      end
      c8v12 = string.format
      c8v14 = "%d"
      c8v16 = " %d"
      c8v18 = " %d"
      c8v13 = c8v14 .. c8v7 .. c8v16 .. c8v8 .. c8v18 .. c8v9
      c8v12 = c8v12(c8v13, c8v1, c8v2, c8v3)
      c8v10 = c8v5 .. c8v12
      do return c8v10 end
    end
    if not c8v4 then
      if not ((c8v4 ~= "HoursOrMinutesOrSeconds" or c8v0 ~= 0)) then
        if not ((c8v1 ~= 0 or c8v2 ~= 0)) then
          c8v10 = vT[17]
          c8v10 = c8v10.Ternary
          if c8v3 ~= 1 then
            c8v11 = false
          else
            c8v11 = true
          end
          c8v12 = "/Lotus/Language/Menu/TimeFormat_Second"
          c8v13 = "/Lotus/Language/Menu/TimeFormat_Seconds"
          c8v10 = c8v10(c8v11, c8v12, c8v13)
          c8v13 = Localize
          c8v15 = { TIME = nil }
          c8v16 = string.format
          c8v17 = "%d"
          c8v16 = c8v16(c8v17, c8v3)
          c8v15.TIME = c8v16
          c8v13 = c8v13(c8v10, c8v15)
          c8v11 = c8v5 .. c8v13
          do return c8v11 end
        end
      end
      if not ((not (c8v4 == "HoursOrMinutes") and c8v4 ~= "HoursOrMinutesOrSeconds")) then
        if not ((c8v0 ~= 0 or c8v1 ~= 0)) then
          c8v10 = vT[17]
          c8v10 = c8v10.Ternary
          if c8v2 ~= 1 then
            c8v11 = false
          else
            c8v11 = true
          end
          c8v12 = "/Lotus/Language/Menu/TimeFormat_Minute"
          c8v13 = "/Lotus/Language/Menu/TimeFormat_Minutes"
          c8v10 = c8v10(c8v11, c8v12, c8v13)
          c8v13 = Localize
          c8v15 = { TIME = nil }
          c8v16 = string.format
          c8v17 = "%d"
          c8v16 = c8v16(c8v17, c8v2)
          c8v15.TIME = c8v16
          c8v13 = c8v13(c8v10, c8v15)
          c8v11 = c8v5 .. c8v13
          do return c8v11 end
        end
      end
      if c8v4 ~= "CompactHours" then
        c8v10 = vT[17]
        c8v10 = c8v10.Ternary
        c8v11 = true
        c8v12 = 1
        if c8v1 <= c8v12 then
          c8v12 = 0
          if c8v0 <= c8v12 then
            c8v11 = false
          else
            c8v11 = true
          end
        end
        c8v12 = "/Lotus/Language/Menu/TimeFormat_Hours"
        c8v13 = "/Lotus/Language/Menu/TimeFormat_Hour"
        c8v10 = c8v10(c8v11, c8v12, c8v13)
        c8v13 = Localize
        c8v15 = { TIME = nil }
        c8v16 = string.format
        c8v17 = "%d"
        c8v19 = c8v0 * 24
        c8v18 = c8v19 + c8v1
        c8v16 = c8v16(c8v17, c8v18)
        c8v15.TIME = c8v16
        c8v13 = c8v13(c8v10, c8v15)
        c8v11 = c8v5 .. c8v13
        do return c8v11 end
      end
      c8v10 = c8v0 * 24
      c8v1 = c8v10 + c8v1
      c8v10 = 0
      if c8v10 < c8v1 then
        c8v12 = string.format
        c8v14 = "%d "
        c8v13 = c8v14 .. c8v7
        c8v12 = c8v12(c8v13, c8v1)
        c8v10 = c8v5 .. c8v12
        do return c8v10 end
      end
      c8v10 = 0
      if c8v10 < c8v2 then
        c8v12 = string.format
        c8v14 = "%d "
        c8v13 = c8v14 .. c8v8
        c8v12 = c8v12(c8v13, c8v2)
        c8v10 = c8v5 .. c8v12
        do return c8v10 end
      end
      c8v12 = string.format
      c8v14 = "%d "
      c8v13 = c8v14 .. c8v9
      c8v12 = c8v12(c8v13, c8v3)
      c8v10 = c8v5 .. c8v12
      do return c8v10 end
    end
    c8v10 = 0
    if c8v10 < c8v0 then
      if c8v4 == "CompactTwoMax" then
        c8v12 = string.format
        c8v14 = "%d"
        c8v16 = " %d"
        c8v13 = c8v14 .. c8v6 .. c8v16 .. c8v7
        c8v12 = c8v12(c8v13, c8v0, c8v1)
        c8v10 = c8v5 .. c8v12
        do return c8v10 end
      end
      if c8v4 == "CompactOne" then
        c8v12 = string.format
        c8v14 = "%d"
        c8v13 = c8v14 .. c8v6
        c8v12 = c8v12(c8v13, c8v0)
        c8v10 = c8v5 .. c8v12
        do return c8v10 end
      end
      c8v12 = string.format
      c8v14 = "%d"
      c8v16 = " %d"
      c8v18 = " %d"
      c8v20 = " %d"
      c8v13 = c8v14 .. c8v6 .. c8v16 .. c8v7 .. c8v18 .. c8v8 .. c8v20 .. c8v9
      c8v12 = c8v12(c8v13, c8v0, c8v1, c8v2, c8v3)
      c8v10 = c8v5 .. c8v12
      do return c8v10 end
    end
    c8v10 = 0
    if c8v10 < c8v1 then
      if c8v4 == "CompactTwoMax" then
        c8v12 = string.format
        c8v14 = "%d"
        c8v16 = " %d"
        c8v13 = c8v14 .. c8v7 .. c8v16 .. c8v8
        c8v12 = c8v12(c8v13, c8v1, c8v2)
        c8v10 = c8v5 .. c8v12
        do return c8v10 end
      end
      if c8v4 == "CompactOne" then
        c8v12 = string.format
        c8v14 = "%d"
        c8v13 = c8v14 .. c8v7
        c8v12 = c8v12(c8v13, c8v1)
        c8v10 = c8v5 .. c8v12
        do return c8v10 end
      end
      c8v12 = string.format
      c8v14 = "%d"
      c8v16 = " %d"
      c8v18 = " %d"
      c8v13 = c8v14 .. c8v7 .. c8v16 .. c8v8 .. c8v18 .. c8v9
      c8v12 = c8v12(c8v13, c8v1, c8v2, c8v3)
      c8v10 = c8v5 .. c8v12
      do return c8v10 end
    end
    c8v10 = 0
    if c8v2 <= c8v10 then
      c8v12 = string.format
      c8v14 = "%d"
      c8v13 = c8v14 .. c8v9
      c8v12 = c8v12(c8v13, c8v3)
      c8v10 = c8v5 .. c8v12
      do return c8v10 end
    end
    if c8v4 == "CompactOne" then
      c8v12 = string.format
      c8v14 = "%d"
      c8v13 = c8v14 .. c8v8
      c8v12 = c8v12(c8v13, c8v2)
      c8v10 = c8v5 .. c8v12
      do return c8v10 end
    end
    c8v12 = string.format
    c8v14 = "%d"
    c8v16 = " %d"
    c8v13 = c8v14 .. c8v8 .. c8v16 .. c8v9
    c8v12 = c8v12(c8v13, c8v2, c8v3)
    c8v10 = c8v5 .. c8v12
    do return c8v10 end
  end
  vT[43] = function(c9v0)
    local c9v1, c9v2, c9v3, c9v4, c9v5
    c9v2 = c9v0 / 86400
    c9v1 = math.floor
    c9v1 = c9v1(c9v2)
    c9v2 = c9v1 * 86400
    c9v0 = c9v0 - c9v2
    c9v3 = c9v0 / 3600
    c9v2 = math.floor
    c9v2 = c9v2(c9v3)
    c9v3 = c9v2 * 3600
    c9v0 = c9v0 - c9v3
    c9v4 = c9v0 / 60
    c9v3 = math.floor
    c9v3 = c9v3(c9v4)
    c9v5 = c9v3 * 60
    c9v4 = c9v0 - c9v5
    do return c9v1, c9v2, c9v3, c9v4 end
  end
  vT[44] = function(c10v0)
    local c10v1
    c10v1 = vT[43]
    do return c10v1(c10v0) end
  end
  GetSecondElements = vT[44]
  vT[44] = function(c11v0, c11v1)
    local c11v2, c11v3, c11v4, c11v5, c11v6, c11v7
    c11v2 = ""
    c11v3 = 0
    if c11v0 < c11v3 then
      c11v0 = -c11v0
      c11v2 = "-"
    end
    c11v3 = vT[43]
    c11v3, c11v4, c11v5, c11v6 = c11v3(c11v0)
    c11v7 = vT[42]
    do return c11v7(c11v3, c11v4, c11v5, c11v6, c11v1, c11v2) end
  end
  vT[45] = function(c12v0, c12v1, c12v2)
    local c12v3
    c12v3 = vT[44]
    c12v3 = c12v3(c12v1, c12v2)
    do return c12v3 end
  end
  SecondsToFormattedTime = vT[45]
  vT[45] = function(c13v0, c13v1, c13v2)
    local c13v3, c13v4, c13v5, c13v6, c13v7, c13v8, c13v9, c13v10, c13v11, c13v12, c13v13, c13v14, c13v15, c13v16, c13v17, c13v18, c13v19, c13v20
    c13v3 = Localize
    c13v4 = "/Lotus/Language/Menu/TimeFormat_DaysShort"
    c13v5 = false
    c13v3 = c13v3(c13v4, c13v5)
    c13v4 = Localize
    c13v5 = "/Lotus/Language/Menu/TimeFormat_HoursShort"
    c13v6 = false
    c13v4 = c13v4(c13v5, c13v6)
    c13v5 = Localize
    c13v6 = "/Lotus/Language/Menu/TimeFormat_MinutesShort"
    c13v7 = false
    c13v5 = c13v5(c13v6, c13v7)
    c13v6 = Localize
    c13v7 = "/Lotus/Language/Menu/TimeFormat_SecondsShort"
    c13v8 = false
    c13v6 = c13v6(c13v7, c13v8)
    c13v7 = ""
    c13v8 = 0
    if c13v0 < c13v8 then
      c13v0 = -c13v0
      c13v7 = "-"
    end
    c13v8 = vT[43]
    c13v8, c13v9, c13v10, c13v11 = c13v8(c13v0)
    c13v12 = ""
    c13v13 = math.abs
    c13v13 = c13v13(c13v8)
    c13v14 = 0
    if c13v8 <= c13v0 then
      c13v12 = c13v8 .. c13v3
      if c13v1 ~= false then
        c13v14 = " "
        c13v12 = c13v12 .. c13v14 .. c13v9 .. c13v4
      end
    else
      c13v13 = math.abs
      c13v13 = c13v13(c13v9)
      c13v14 = 0
      if c13v14 < c13v13 then
        c13v12 = c13v9 .. c13v4
        if c13v2 then
          c13v13 = math.abs
          c13v13 = c13v13(c13v10)
          c13v14 = 0
          if c13v14 < c13v13 then
            c13v14 = " "
            c13v18 = c13v10 + 1
            c13v19 = 59
            c13v17 = math.min
            c13v15 = c13v17(c13v18, c13v19)
            c13v12 = c13v12 .. c13v14 .. c13v15 .. c13v5
          end
        end
      else
        c13v13 = math.abs
        c13v13 = c13v13(c13v10)
        c13v14 = 0
        if c13v14 < c13v13 then
          c13v17 = vT[17]
          c13v17 = c13v17.Ternary
          c13v19 = 0.99
          if c13v19 < c13v11 then
            c13v18 = false
          else
            c13v18 = true
          end
          c13v19 = 0
          c13v20 = 1
          c13v17 = c13v17(c13v18, c13v19, c13v20)
          c13v16 = c13v10 + c13v17
          c13v17 = 59
          c13v15 = math.min
          c13v13 = c13v15(c13v16, c13v17)
          c13v12 = c13v13 .. c13v5
        else
          c13v15 = math.ceil
          c13v13 = c13v15(c13v0)
          c13v12 = c13v13 .. c13v6
        end
      end
    end
    c13v13 = c13v7 .. c13v12
    do return c13v13 end
  end
  GetTwitterStyleTime = vT[45]
  vT[45] = function(c14v0)
    local c14v1, c14v2, c14v3, c14v4, c14v5, c14v6, c14v7, c14v8, c14v9, c14v10, c14v11, c14v12, c14v13, c14v14, c14v16, c14v17, c14v19, c14v20
    c14v1 = Localize
    c14v2 = "/Lotus/Language/Menu/TimeFormat_DaysShort"
    c14v3 = false
    c14v1 = c14v1(c14v2, c14v3)
    c14v2 = Localize
    c14v3 = "/Lotus/Language/Menu/TimeFormat_HoursShort"
    c14v4 = false
    c14v2 = c14v2(c14v3, c14v4)
    c14v3 = Localize
    c14v4 = "/Lotus/Language/Menu/TimeFormat_MinutesShort"
    c14v5 = false
    c14v3 = c14v3(c14v4, c14v5)
    c14v4 = Localize
    c14v5 = "/Lotus/Language/Menu/TimeFormat_SecondsShort"
    c14v6 = false
    c14v4 = c14v4(c14v5, c14v6)
    c14v5 = ""
    c14v6 = 0
    if c14v0 < c14v6 then
      c14v0 = -c14v0
      c14v5 = "-"
    end
    c14v6 = vT[43]
    c14v6, c14v7, c14v8, c14v9 = c14v6(c14v0)
    c14v10 = ""
    c14v11 = math.abs
    c14v11 = c14v11(c14v6)
    c14v12 = 0
    if c14v12 < c14v11 then
      c14v10 = c14v6 .. c14v1
    else
      c14v11 = math.abs
      c14v11 = c14v11(c14v7)
      c14v12 = 0
      if c14v12 < c14v11 then
        c14v13 = " "
        c14v16 = " "
        c14v20 = c14v9 + 0.5
        c14v19 = math.floor
        c14v17 = c14v19(c14v20)
        c14v10 = c14v7 .. c14v2 .. c14v13 .. c14v8 .. c14v3 .. c14v16 .. c14v17 .. c14v4
      else
        c14v11 = math.abs
        c14v11 = c14v11(c14v8)
        c14v12 = 0
        if c14v12 <= c14v11 then
          c14v13 = " "
          c14v17 = c14v9 + 0.5
          c14v16 = math.floor
          c14v14 = c14v16(c14v17)
          c14v10 = c14v8 .. c14v3 .. c14v13 .. c14v14 .. c14v4
        end
      end
    end
    c14v11 = c14v5 .. c14v10
    do return c14v11 end
  end
  vT[46] = function(c15v0)
    local c15v1
    c15v1 = vT[45]
    do return c15v1(c15v0) end
  end
  GetStoreTime = vT[46]
  vT[46] = function(c16v0, c16v1)
    local c16v2, c16v3, c16v4, c16v5, c16v6, c16v7, c16v8, c16v9, c16v10, c16v11, c16v12, c16v13, c16v14, c16v15, c16v16
    c16v2 = Localize
    c16v3 = "/Lotus/Language/Menu/TimeFormat_DaysShort"
    c16v4 = false
    c16v2 = c16v2(c16v3, c16v4)
    c16v3 = Localize
    c16v4 = "/Lotus/Language/Menu/TimeFormat_HoursShort"
    c16v5 = false
    c16v3 = c16v3(c16v4, c16v5)
    c16v4 = Localize
    c16v5 = "/Lotus/Language/Menu/TimeFormat_MinutesShort"
    c16v6 = false
    c16v4 = c16v4(c16v5, c16v6)
    c16v5 = Localize
    c16v6 = "/Lotus/Language/Menu/TimeFormat_SecondsShort"
    c16v7 = false
    c16v5 = c16v5(c16v6, c16v7)
    c16v6 = ""
    c16v7 = 0
    if c16v0 < c16v7 then
      c16v0 = -c16v0
      c16v6 = "-"
    end
    c16v7 = vT[43]
    c16v7, c16v8, c16v9, c16v10 = c16v7(c16v0)
    c16v11 = ""
    c16v12 = math.abs
    c16v12 = c16v12(c16v7)
    c16v13 = 0
    if c16v13 < c16v12 then
      c16v14 = " "
      c16v11 = c16v7 .. c16v2 .. c16v14
    end
    c16v12 = math.abs
    c16v12 = c16v12(c16v8)
    c16v13 = 0
    if c16v13 < c16v12 then
      c16v15 = " "
      c16v11 = c16v11 .. c16v8 .. c16v3 .. c16v15
    end
    c16v12 = math.abs
    c16v12 = c16v12(c16v9)
    c16v13 = 0
    if c16v13 <= c16v12 then
      c16v15 = " "
      c16v11 = c16v11 .. c16v9 .. c16v4 .. c16v15
    end
    c16v16 = c16v10 + 0.5
    c16v15 = math.floor
    c16v13 = c16v15(c16v16)
    c16v11 = c16v11 .. c16v13 .. c16v5
    c16v12 = 0
    if c16v7 < c16v12 then
      c16v11 = "-1"
    end
    c16v12 = c16v6 .. c16v11
    do return c16v12 end
  end
  vT[47] = function(c17v0)
    local c17v1
    c17v1 = vT[46]
    do return c17v1(c17v0) end
  end
  GetFullTime = vT[47]
  vT[47] = function(c18v0, c18v1, c18v2)
    local c18v3, c18v4, c18v5, c18v6
    c18v3 = c18v1
    c18v4 = c18v0:IsPlayerAvatar(c18v1)
    if not c18v4 then
      c18v3 = c18v0:GetAvatar()
    end
    if c18v4 then
      local p14 = 3
      if p14 == 3 then
        c18v4 = IsNull
        c18v4 = c18v4(c18v3)
        if c18v4 then
        else
          p14 = 4
        end
      end
      if p14 == 4 then
        c18v6 = vT[11]
        c18v4 = c18v3:IsA(c18v6)
        if c18v4 then
          p14 = 6
        else
          p14 = 5
        end
      end
      if p14 == 5 then
        c18v6 = vT[12]
        c18v4 = c18v3:IsA(c18v6)
        if not c18v4 then
        else
          p14 = 6
        end
      end
      if p14 == 6 then
        c18v4 = c18v0:GetOwnedPowerSuitAvatar()
        c18v5 = IsNull
        c18v5 = c18v5(c18v4)
        if c18v5 then
        else
          p14 = 7
        end
      end
      if p14 == 7 then
        c18v5 = c18v4:IsPreDeath()
        if not c18v5 then
        else
          p14 = 8
        end
      end
      if p14 == 8 then
        do return c18v4 end
      end
    end
    do return c18v3 end
  end
  GetPlayerAvatar = vT[47]
  vT[47] = function()
    local c19v0, c19v1, c19v2
    c19v1 = gRegion
    c19v0 = IsNull
    c19v0 = c19v0(c19v1)
    if not c19v0 then
      c19v1 = gClient
      c19v0 = IsNull
      c19v0 = c19v0(c19v1)
      if not c19v0 then
        c19v0 = gRegion
        c19v0 = c19v0:GetLocalPlayer()
        c19v1 = IsNull
        c19v1 = c19v1(c19v0)
        if c19v1 then
          c19v1 = nil
          do return c19v1 end
        end
        c19v1 = c19v0:GetOwnedPowerSuitAvatar()
        c19v2 = IsNull
        c19v2 = c19v2(c19v1)
        if c19v2 then
          c19v1 = c19v0:GetAvatar()
        end
        do return c19v1 end
      end
    end
    c19v0 = nil
    do return c19v0 end
  end
  vT[48] = function()
    local c20v0
    c20v0 = vT[47]
    do return c20v0() end
  end
  GetMainMenuSuitAvatar = vT[48]
  vT[48] = function()
    local c21v0, c21v1
    c21v0 = vT[47]
    c21v0 = c21v0()
    c21v1 = IsNull
    c21v1 = c21v1(c21v0)
    if not c21v1 then
      c21v1 = c21v0:InventoryControl()
      c21v1 = c21v1:GetSentinel()
      do return c21v1 end
    end
    c21v1 = nil
    do return c21v1 end
  end
  vT[49] = function()
    local c22v0
    c22v0 = vT[48]
    do return c22v0() end
  end
  GetMainMenuSentinelAvatar = vT[49]
  vT[49] = function(c23v0, c23v1, c23v2, c23v3, c23v4, c23v5, c23v6)
    local c23v7, c23v8, c23v9, c23v10, c23v11, c23v12, c23v13, c23v14, c23v15
    c23v7 = ""
    c23v8 = true
    c23v9 = IsNull
    c23v9 = c23v9(c23v4)
    if c23v9 then
      c23v4 = {}
    end
    c23v10 = c23v4.endLineTag
    c23v9 = IsNull
    c23v9 = c23v9(c23v10)
    if not c23v9 then
      c23v7 = c23v4.endLineTag
    end
    c23v10 = c23v4.includeParagraphTag
    c23v9 = IsNull
    c23v9 = c23v9(c23v10)
    if not c23v9 then
      c23v8 = c23v4.includeParagraphTag
    end
    if c23v5 == nil then
      c23v5 = "#FloatingContentHighlight"
    end
    if c23v6 == nil then
      c23v6 = "#FloatingContent"
    end
    if c23v2 ~= nil then
      c23v9 = vT[19]
      c23v11 = c23v2.rarity
      c23v10 = c23v11 + 1
      c23v5 = c23v9[c23v10]
    end
    c23v9 = ""
    if c23v8 then
      c23v11 = "<p>"
      c23v9 = c23v9 .. c23v11
    end
    c23v11 = "<font color=\""
    c23v13 = "\">"
    c23v9 = c23v9 .. c23v11 .. c23v5 .. c23v13
    if not c23v9 then
      c23v11 = c23v2.localizedTitle
      c23v9 = c23v9 .. c23v11
    else
      c23v10 = IsNull
      c23v10 = c23v10(c23v1)
      if not c23v10 then
        c23v10 = Localize
        c23v11 = tostring
        c23v11 = c23v11(c23v1:GetLocalizeTag())
        c23v12 = false
        c23v10 = c23v10(c23v11, c23v12)
        c23v11 = c23v4.Upper
        if c23v11 then
          c23v11 = string.upper
          c23v10 = c23v11(c23v10)
        end
        c23v9 = c23v9 .. c23v10
      end
    end
    c23v11 = "<br>"
    c23v12 = "</font>"
    c23v9 = c23v9 .. c23v11 .. c23v12
    c23v11 = "<font color=\""
    c23v13 = "\">"
    c23v9 = c23v9 .. c23v11 .. c23v6 .. c23v13
    if c23v2 ~= nil then
      c23v11 = c23v2.localizedDescription
      c23v9 = c23v9 .. c23v11
      c23v10 = c23v2.affixes
      if c23v10 ~= nil then
        c23v12 = 1
        c23v13 = c23v2.affixes
        c23v10 = #c23v13
        c23v11 = 1
        for c23v12 = c23v12, c23v10, c23v11 do
          c23v14 = "<br>"
          c23v9 = c23v9 .. c23v14
          c23v14 = "<font color=\"#FFFFFF\">"
          c23v9 = c23v9 .. c23v14
          c23v15 = c23v2.affixes
          c23v14 = c23v15[c23v12]
          c23v9 = c23v9 .. c23v14
          c23v14 = "</font>"
          c23v9 = c23v9 .. c23v14
          c23v9 = c23v9 .. c23v7
        end
      end
    else
      c23v10 = IsNull
      c23v10 = c23v10(c23v1)
      if not c23v10 then
        c23v11 = Localize
        c23v12 = tostring
        c23v12 = c23v12(c23v1:GetLocalizeDescTag())
        c23v13 = false
        c23v11 = c23v11(c23v12, c23v13)
        c23v9 = c23v9 .. c23v11
      end
    end
    c23v11 = "</font>"
    c23v9 = c23v9 .. c23v11
    if c23v8 then
      c23v11 = "</p>"
      c23v9 = c23v9 .. c23v11
    end
    do return c23v9 end
  end
  vT[50] = function(c24v0, c24v1, c24v2, c24v3, c24v4, c24v5, c24v6)
    local c24v7
    c24v7 = vT[49]
    do return c24v7(c24v0, c24v1, c24v2, c24v3, c24v4, c24v5, c24v6) end
  end
  GetItemToolTipText = vT[50]
  vT[50] = function(c25v0)
    local c25v1, c25v2, c25v3, c25v4
    c25v1 = 16777215
    if c25v0 ~= nil then
      c25v2 = vT[20]
      c25v4 = c25v0.rarity
      c25v3 = c25v4 + 1
      c25v1 = c25v2[c25v3]
    end
    do return c25v1 end
  end
  GetItemRarityColor = vT[50]
  vT[50] = function(c26v0, c26v1, c26v2, c26v3, c26v4, c26v5, c26v6)
    local c26v7, c26v8, c26v9
    local p8 = 0
    if p8 == 0 then
      c26v7 = _T
      if not c26v1 then
        p8 = 2
      else
        p8 = 1
      end
    end
    if p8 == 1 then
      c26v8 = string.format
      c26v9 = "0x%08X"
      c26v8 = c26v8(c26v9, c26v1)
      if c26v8 then
        p8 = 3
      else
        p8 = 2
      end
    end
    if p8 == 2 then
      c26v8 = nil
      p8 = 3
    end
    if p8 == 3 then
      c26v7.ColorPickerCurrentColor = c26v8
      c26v7 = _T
      c26v7.ColorPickerCallback = c26v2
      c26v7 = _T
      c26v7.ColorPickerOnCloseCallback = c26v3
      c26v7 = _T
      c26v7.ColorPickerSpecificColorsInfo = c26v4
      c26v7 = _T
      c26v7.ColorPickerType = c26v5
      c26v7 = _T
      c26v7.ExtraColorFilter = c26v6
      c26v7 = _T.InSimulacrum
      if not c26v7 then
        p8 = 5
      else
        p8 = 4
      end
    end
    if p8 == 4 then
      c26v7 = _T
      c26v8 = true
      c26v7.ColorPickerUseCustomBg = c26v8
      p8 = 5
    end
    if p8 == 5 then
      c26v9 = _G
      c26v9 = c26v9.UIMovie_ColorPicker
      c26v7 = c26v0:PushChildMovie(c26v9)
      do return c26v7 end
    end
  end
  OpenColorPicker = vT[50]
  vT[50] = function(c27v0, c27v1, c27v2, c27v3)
    local c27v4, c27v5, c27v6, c27v7, c27v8, c27v9, c27v10, c27v11, c27v12, c27v13, c27v14, c27v15, c27v16, c27v17, c27v18, c27v19, c27v20, c27v21, c27v22, c27v23, c27v24, c27v25, c27v26
    c27v5 = IsNull
    c27v5 = c27v5(c27v1)
    if c27v5 then
      c27v5 = vT[47]
      c27v1 = c27v5()
    end
    c27v5 = _T.mSpecialSuitMode
    if c27v5 then
      c27v4 = _T.SpecialSuitAvatar
    else
      c27v5 = _T.mSentinelMode
      if c27v5 then
        c27v5 = IsNull
        c27v5 = c27v5(c27v1)
        if not c27v5 then
          c27v7 = gLotusSentinelAvatarType
          c27v5 = c27v1:IsA(c27v7)
          if c27v5 then
            c27v4 = c27v1
          else
            c27v5 = c27v1:InventoryControl()
            c27v4 = c27v5:GetSentinel()
            c27v5 = IsNull
            c27v5 = c27v5(c27v4)
            if c27v5 then
              c27v5 = gGameRules
              c27v7 = gLotusAttractModeGameRulesType
              c27v5 = c27v5:IsA(c27v7)
              if c27v5 then
                c27v5 = gGameRules
                c27v7 = 3
                c27v4 = c27v5:GetPet(c27v7)
              end
            end
          end
        end
      else
        c27v4 = c27v1
      end
    end
    c27v5 = IsNull
    c27v5 = c27v5(c27v4)
    if c27v5 then
      do return end
    end
    c27v5 = _T.suitTable
    if c27v5 == nil then
      c27v5 = _T
      c27v6 = {}
      c27v5.suitTable = c27v6
      c27v5 = _T.suitTable
      c27v6 = -90
      c27v5.desiredRot = c27v6
      c27v5 = _T.suitTable
      c27v6 = _T.suitTable.desiredRot
      c27v5.lerpRot = c27v6
      c27v5 = _T.suitTable
      c27v6 = Rotation
      c27v6 = c27v6()
      c27v5.lerpHead = c27v6
    end
    c27v6 = _T.suitTable.lerpRot
    c27v5 = IsNull
    c27v5 = c27v5(c27v6)
    if c27v5 then
      c27v5 = _T.suitTable
      c27v6 = 0
      c27v5.lerpRot = c27v6
    end
    c27v6 = _T.suitTable.desiredRot
    c27v5 = IsNull
    c27v5 = c27v5(c27v6)
    if c27v5 then
      c27v5 = _T.suitTable
      c27v6 = -90
      c27v5.desiredRot = c27v6
    end
    c27v6 = _T.suitTable.lerpHead
    c27v5 = IsNull
    c27v5 = c27v5(c27v6)
    if c27v5 then
      c27v5 = _T.suitTable
      c27v6 = Rotation
      c27v6 = c27v6()
      c27v5.lerpHead = c27v6
    end
    c27v5 = IsNull
    c27v5 = c27v5(c27v0)
    if not c27v5 then
      local p178 = 23
      if p178 == 23 then
        c27v5 = IsNull
        c27v5 = c27v5(c27v4)
        if not c27v5 then
          p178 = 25
        else
        end
      end
      if p178 == 25 then
        c27v5 = c27v0:IsVisible()
        if c27v5 then
          p178 = 27
        else
          p178 = 26
        end
      end
      if p178 == 26 then
        do return end
      end
      if p178 == 27 then
        c27v7 = "_root"
        c27v8 = 30
        c27v5 = c27v0:GetNumberVariable(c27v7, c27v8)
        c27v8 = "_root"
        c27v9 = 31
        c27v6 = c27v0:GetNumberVariable(c27v8, c27v9)
        c27v7 = Engine.IsPlayingWithController
        c27v7 = c27v7()
        c27v8 = Engine.IsSwitch2
        c27v8 = c27v8()
        if not c27v8 then
          p178 = 30
        else
          p178 = 28
        end
      end
      if p178 == 28 then
        c27v8 = Engine.KBMControlsDisabled
        c27v8 = c27v8()
        if c27v8 then
          p178 = 30
        else
          p178 = 29
        end
      end
      if p178 == 29 then
        c27v7 = false
        c27v3 = false
        p178 = 30
      end
      if p178 == 30 then
        if (c27v5 ~= -1000 or c27v6 ~= -1000) then
          p178 = 36
        else
          p178 = 32
        end
      end
      if p178 == 32 then
        c27v5 = _T.suitTable.lastMX
        c27v6 = _T.suitTable.lastMY
        if (not (c27v5 == nil) and c27v6 ~= nil) then
          p178 = 35
        else
          p178 = 34
        end
      end
      if p178 == 34 then
        c27v5 = 0
        c27v6 = 0
        p178 = 35
      end
      if p178 == 35 then
        c27v8 = _T.suitTable
        c27v9 = true
        c27v8.mouseOffScreen = c27v9
        p178 = 40
      end
      if p178 == 36 then
        c27v8 = _T.suitTable.mouseOffScreen
        if not c27v8 then
          p178 = 40
        else
          p178 = 37
        end
      end
      if p178 == 37 then
        if c27v7 then
          p178 = 39
        else
          p178 = 38
        end
      end
      if p178 == 38 then
        c27v8 = _T.suitTable
        c27v8.lastMX = c27v5
        c27v8 = _T.suitTable
        c27v8.lastMY = c27v6
        p178 = 39
      end
      if p178 == 39 then
        c27v8 = _T.suitTable
        c27v9 = false
        c27v8.mouseOffScreen = c27v9
        p178 = 40
      end
      if p178 == 40 then
        c27v10 = "_root"
        c27v11 = "suitRotationX"
        c27v8 = c27v0:GetVariable(c27v10, c27v11)
        if ((not (c27v7) and not c27v3) or not c27v2) then
          p178 = 46
        else
          p178 = 43
        end
      end
      if p178 == 43 then
        c27v9 = IsNull
        c27v9 = c27v9(c27v8)
        if c27v9 then
          p178 = 46
        else
          p178 = 44
        end
      end
      if p178 == 44 then
        c27v9 = tonumber
        c27v9 = c27v9(c27v8)
        if c27v9 == nil then
          p178 = 46
        else
          p178 = 45
        end
      end
      if p178 == 45 then
        c27v10 = vT[21]
        c27v13 = tonumber
        c27v13 = c27v13(c27v8)
        c27v12 = c27v13 * 1000
        c27v13 = DeltaTime
        c27v13 = c27v13()
        c27v11 = c27v12 * c27v13
        c27v9 = c27v10 + c27v11
        vT[21] = c27v9
        c27v5 = vT[21]
        p178 = 46
      end
      if p178 == 46 then
        c27v9 = _T.suitTable.wasUsingController
        if c27v9 == c27v7 then
          p178 = 48
        else
          p178 = 47
        end
      end
      if p178 == 47 then
        c27v9 = _T.suitTable
        c27v9.wasUsingController = c27v7
        c27v9 = _T.suitTable
        c27v9.lastMX = c27v5
        c27v9 = _T.suitTable
        c27v9.lastMY = c27v6
        p178 = 48
      end
      if p178 == 48 then
        c27v9 = vT[17]
        c27v9 = c27v9.Ternary
        c27v11 = ""
        c27v9 = c27v9(c27v3, c27v11, c27v0:GetFocus())
        if (c27v9 ~= "" or not c27v2) then
          p178 = 54
        else
          p178 = 50
        end
      end
      if p178 == 50 then
        c27v10 = _T.suitTable.lastMX
        if c27v10 == nil then
          p178 = 52
        else
          p178 = 51
        end
      end
      if p178 == 51 then
        c27v10 = _T.suitTable
        c27v12 = _T.suitTable.desiredRot
        c27v15 = _T.suitTable.lastMX
        c27v14 = c27v15 - c27v5
        c27v13 = c27v14 * 0.5
        c27v11 = c27v12 + c27v13
        c27v10.desiredRot = c27v11
        p178 = 52
      end
      if p178 == 52 then
        c27v10 = _T.suitTable.lastMY
        if c27v10 == nil then
          p178 = 54
        else
          p178 = 53
        end
      end
      if p178 == 53 then
        c27v10 = _T.suitTable
        c27v12 = _T.suitTable.lastMY
        c27v11 = c27v12 - c27v6
        c27v10.myDiff = c27v11
        p178 = 54
      end
      if p178 == 54 then
        c27v10 = _T.suitTable
        c27v11 = Lerp
        c27v12 = _T.suitTable.lerpRot
        c27v13 = _T.suitTable.desiredRot
        c27v15 = DeltaTime
        c27v15 = c27v15()
        c27v14 = c27v15 * 4
        c27v11 = c27v11(c27v12, c27v13, c27v14)
        c27v10.lerpRot = c27v11
        c27v10 = 0
        c27v11 = _T.suitTable.lerpRot
        c27v12 = _T.suitTable.desiredRot
        if c27v12 < c27v11 then
          p178 = 56
        else
          p178 = 55
        end
      end
      if p178 == 55 then
        c27v13 = _T.suitTable.lerpRot
        c27v12 = c27v13 % 360
        c27v11 = math.abs
        c27v11 = c27v11(c27v12)
        c27v10 = 360 - c27v11
        p178 = 57
      end
      if p178 == 56 then
        c27v13 = _T.suitTable.lerpRot
        c27v12 = c27v13 % 360
        c27v11 = math.abs
        c27v10 = c27v11(c27v12)
        p178 = 57
      end
      if p178 == 57 then
        c27v13 = _T.suitTable.desiredRot
        c27v14 = _T.suitTable.lerpRot
        c27v12 = c27v13 - c27v14
        c27v11 = math.abs
        c27v11 = c27v11(c27v12)
        if c27v10 <= c27v11 then
          p178 = 59
        else
          p178 = 58
        end
      end
      if p178 == 58 then
        c27v12 = _T.suitTable
        c27v14 = _T.suitTable.lerpRot
        c27v13 = c27v14 % 360
        c27v12.lerpRot = c27v13
        c27v12 = _T.suitTable
        c27v14 = _T.suitTable.desiredRot
        c27v13 = c27v14 % 360
        c27v12.desiredRot = c27v13
        p178 = 59
      end
      if p178 == 59 then
        c27v12 = _T.suitTable.lerpRot
        c27v13 = _T.mSentinelMode
        if not c27v13 then
          p178 = 62
        else
          p178 = 60
        end
      end
      if p178 == 60 then
        c27v13 = _T.SENTINEL_DEFAULT_ROTATION
        if c27v13 == nil then
          p178 = 62
        else
          p178 = 61
        end
      end
      if p178 == 61 then
        c27v14 = _T.SENTINEL_DEFAULT_ROTATION
        c27v13 = c27v12 + c27v14
        c27v12 = c27v13 % 360
        p178 = 62
      end
      if p178 == 62 then
        c27v12 = c27v12 % 360
        c27v13 = -180
        if c27v13 < c27v12 then
          p178 = 64
        else
          p178 = 63
        end
      end
      if p178 == 63 then
        c27v12 = c27v12 + 360
        p178 = 66
      end
      if p178 == 64 then
        c27v13 = 180
        if c27v12 < c27v13 then
          p178 = 66
        else
          p178 = 65
        end
      end
      if p178 == 65 then
        c27v12 = c27v12 - 360
        p178 = 66
      end
      if p178 == 66 then
        c27v15 = Rotation
        c27v17 = 0
        c27v18 = 0
        c27v4:SetView(c27v15(c27v12, c27v17, c27v18))
        c27v13 = c27v4:GetPosition()
        c27v14 = c27v4:GetInstance()
        c27v15 = _T.suitTable.positions
        if not c27v15 then
          p178 = 68
        else
          p178 = 67
        end
      end
      if p178 == 67 then
        c27v16 = _T.suitTable.positions
        c27v15 = c27v16[c27v14]
        p178 = 68
      end
      if p178 == 68 then
        c27v16 = IsNull
        c27v16 = c27v16(c27v15)
        if c27v16 then
          p178 = 70
        else
          p178 = 69
        end
      end
      if p178 == 69 then
        c27v13 = c27v15
        p178 = 73
      end
      if p178 == 70 then
        c27v16 = _T.suitTable.desiredPos
        if c27v16 == nil then
          p178 = 73
        else
          p178 = 71
        end
      end
      if p178 == 71 then
        c27v18 = gPetAvatarType
        c27v16 = c27v4:IsA(c27v18)
        if c27v16 then
          p178 = 73
        else
          p178 = 72
        end
      end
      if p178 == 72 then
        c27v16 = LerpVector
        c27v18 = _T.suitTable.desiredPos
        c27v20 = DeltaTime
        c27v20 = c27v20()
        c27v19 = c27v20 * 4
        c27v13 = c27v16(c27v13, c27v18, c27v19)
        p178 = 73
      end
      if p178 == 73 then
        c27v16 = _T.suitTable.queuedTeleport
        if c27v16 ~= nil then
          p178 = 88
        else
          p178 = 74
        end
      end
      if p178 == 74 then
        c27v16 = 0
        c27v17 = 0
        c27v19 = _T.suitTable.lerpRotZ
        c27v18 = IsNull
        c27v18 = c27v18(c27v19)
        if c27v18 then
          p178 = 76
        else
          p178 = 75
        end
      end
      if p178 == 75 then
        c27v17 = _T.suitTable.lerpRotZ
        p178 = 76
      end
      if p178 == 76 then
        c27v19 = _T.suitTable.lerpRotY
        c27v18 = IsNull
        c27v18 = c27v18(c27v19)
        if c27v18 then
          p178 = 78
        else
          p178 = 77
        end
      end
      if p178 == 77 then
        c27v16 = _T.suitTable.lerpRotY
        p178 = 78
      end
      if p178 == 78 then
        c27v21 = Rotation
        c27v4:Teleport(c27v13, c27v21(c27v12, c27v16, c27v17))
        c27v18 = nil
        c27v20 = gRegion
        c27v19 = IsNull
        c27v19 = c27v19(c27v20)
        if c27v19 then
          p178 = 80
        else
          p178 = 79
        end
      end
      if p178 == 79 then
        c27v19 = gRegion
        c27v18 = c27v19:GetLocalPlayerAvatar()
        p178 = 80
      end
      if p178 == 80 then
        c27v19 = IsNull
        c27v19 = c27v19(c27v18)
        if c27v19 then
          p178 = 90
        else
          p178 = 81
        end
      end
      if p178 == 81 then
        c27v21 = gLotusOperatorAvatarType
        c27v19 = c27v18:IsA(c27v21)
        if c27v19 then
          p178 = 90
        else
          p178 = 82
        end
      end
      if p178 == 82 then
        c27v19 = _T.MenuSuitAvatar
        if c27v4 == c27v19 then
          p178 = 84
        else
          p178 = 83
        end
      end
      if p178 == 83 then
        c27v19 = _T.KDriveAvatar
        if c27v4 ~= c27v19 then
          p178 = 90
        else
          p178 = 84
        end
      end
      if p178 == 84 then
        if c27v18 == c27v4 then
          p178 = 90
        else
          p178 = 85
        end
      end
      if p178 == 85 then
        c27v22 = Rotation
        c27v24 = 0
        c27v25 = 0
        c27v18:Teleport(c27v13, c27v22(c27v12, c27v24, c27v25))
        c27v20 = _T.MenuSuitAvatar
        c27v19 = IsNull
        c27v19 = c27v19(c27v20)
        if c27v19 then
          p178 = 90
        else
          p178 = 86
        end
      end
      if p178 == 86 then
        c27v19 = _T.KDriveAvatar
        if c27v4 ~= c27v19 then
          p178 = 90
        else
          p178 = 87
        end
      end
      if p178 == 87 then
        c27v19 = _T.MenuSuitAvatar
        c27v22 = Rotation
        c27v24 = 0
        c27v25 = 0
        c27v19:Teleport(c27v13, c27v22(c27v12, c27v24, c27v25))
        p178 = 90
      end
      if p178 == 88 then
        c27v16 = _T.suitTable
        c27v18 = _T.suitTable.queuedTeleport
        c27v19 = RealDeltaTime
        c27v19 = c27v19()
        c27v17 = c27v18 - c27v19
        c27v16.queuedTeleport = c27v17
        c27v16 = _T.suitTable.queuedTeleport
        c27v17 = 0
        if c27v17 < c27v16 then
          p178 = 90
        else
          p178 = 89
        end
      end
      if p178 == 89 then
        c27v16 = _T.suitTable
        c27v17 = nil
        c27v16.queuedTeleport = c27v17
        p178 = 90
      end
      if p178 == 90 then
        c27v16 = Vector
        c27v19 = -200
        c27v16 = c27v16(c27v5, c27v6, c27v19)
        c27v20 = c27v4:EyePosition()
        c27v18 = c27v0:ProjectPosition(c27v20)
        c27v19 = 0
        c27v18.z = c27v19
        c27v19 = LookTo
        c27v19 = c27v19(c27v18, c27v16)
        c27v20 = AngleToDirection
        c27v20 = c27v20(c27v19)
        c27v21 = c27v20.z
        c27v22 = 0
        if c27v21 <= c27v22 then
          p178 = 92
        else
          p178 = 91
        end
      end
      if p178 == 91 then
        c27v22 = c27v20.z
        c27v21 = -c27v22
        c27v20.z = c27v21
        p178 = 92
      end
      if p178 == 92 then
        c27v21 = RotateVector
        c27v23 = Rotation
        c27v24 = 90 - c27v12
        c27v25 = 0
        c27v26 = 0
        c27v20 = c27v21(c27v20, c27v23(c27v24, c27v25, c27v26))
        c27v21 = LookTo
        c27v22 = ZERO_VECTOR
        c27v19 = c27v21(c27v22, c27v20)
        c27v21 = 0
        c27v19.bank = c27v21
        c27v22 = c27v19.pitch
        c27v21 = -c27v22
        c27v19.pitch = c27v21
        c27v21 = Clamp
        c27v22 = c27v19.heading
        c27v23 = -70
        c27v24 = 70
        c27v21 = c27v21(c27v22, c27v23, c27v24)
        c27v19.heading = c27v21
        c27v21 = Clamp
        c27v22 = c27v19.pitch
        c27v23 = -30
        c27v24 = 20
        c27v21 = c27v21(c27v22, c27v23, c27v24)
        c27v19.pitch = c27v21
        c27v21 = _T.suitTable.lerpHead
        c27v22 = Lerp
        c27v23 = _T.suitTable.lerpHead
        c27v23 = c27v23.heading
        c27v24 = c27v19.heading
        c27v26 = DeltaTime
        c27v26 = c27v26()
        c27v25 = c27v26 * 8
        c27v22 = c27v22(c27v23, c27v24, c27v25)
        c27v21.heading = c27v22
        c27v21 = _T.suitTable.lerpHead
        c27v22 = Lerp
        c27v23 = _T.suitTable.lerpHead
        c27v23 = c27v23.pitch
        c27v24 = c27v19.pitch
        c27v26 = DeltaTime
        c27v26 = c27v26()
        c27v25 = c27v26 * 8
        c27v22 = c27v22(c27v23, c27v24, c27v25)
        c27v21.pitch = c27v22
        c27v21 = Engine.IsMobile
        c27v21 = c27v21()
        if (not (c27v7) and c27v21) then
          p178 = 95
        else
          p178 = 94
        end
      end
      if p178 == 94 then
        c27v22 = _T.suitTable
        c27v22.lastMX = c27v5
        c27v22 = _T.suitTable
        c27v22.lastMY = c27v6
        p178 = 99
      end
      if p178 == 95 then
        if not c27v21 then
          p178 = 99
        else
          p178 = 96
        end
      end
      if p178 == 96 then
        if not c27v2 then
          p178 = 98
        else
          p178 = 97
        end
      end
      if p178 == 97 then
        c27v22 = _T.suitTable
        c27v22.lastMX = c27v5
        c27v22 = _T.suitTable
        c27v22.lastMY = c27v6
        p178 = 99
      end
      if p178 == 98 then
        c27v22 = _T.suitTable
        c27v23 = nil
        c27v22.lastMX = c27v23
        c27v22 = _T.suitTable
        c27v23 = nil
        c27v22.lastMY = c27v23
        p178 = 99
      end
      if p178 == 99 then
        if not c27v7 then
          p178 = 101
        else
          p178 = 100
        end
      end
      if p178 == 100 then
        c27v22 = _T.suitTable
        c27v23 = vT[21]
        c27v22.lastMX = c27v23
        p178 = 101
      end
      if p178 == 101 then
        do return end
      end
    end
    do return end
  end
  UpdateSuit = vT[50]
  vT[50] = function(c28v0, c28v1)
    local c28v2, c28v3, c28v4, c28v5, c28v6, c28v7
    c28v2 = gRegion
    c28v2 = c28v2:GetLocalPlayerAvatar()
    c28v3 = Lerp
    c28v4 = c28v1.heading
    c28v5 = c28v0.heading
    c28v7 = DeltaTime
    c28v7 = c28v7()
    c28v6 = c28v7 * 8
    c28v3 = c28v3(c28v4, c28v5, c28v6)
    c28v1.heading = c28v3
    c28v3 = Lerp
    c28v4 = c28v1.pitch
    c28v5 = c28v0.pitch
    c28v7 = DeltaTime
    c28v7 = c28v7()
    c28v6 = c28v7 * 8
    c28v3 = c28v3(c28v4, c28v5, c28v6)
    c28v1.pitch = c28v3
    c28v5 = Symbol
    c28v6 = "GAME_C1_HEAD1"
    c28v5 = c28v5(c28v6)
    c28v2:SetBoneDirector(c28v5, c28v1)
    do return c28v1 end
  end
  UpdateMiniGameHeadTracking = vT[50]
  vT[50] = function()
    do return end
  end
  OnAvatarImageSet = vT[50]
  vT[50] = function()
    local c34v0, c34v1
    c34v1 = _T.profileIconList
    c34v0 = IsNull
    c34v0 = c34v0(c34v1)
    if c34v0 then
      c34v0 = _T
      c34v1 = {}
      c34v0.profileIconList = c34v1
      c34v0 = _T
      c34v1 = function()
        local c30v0, c30v1
        c30v0 = gGameData
        c30v1 = IsNull
        c30v1 = c30v1(c30v0)
        if c30v1 then
          c30v1 = nil
          do return c30v1 end
        end
        c30v1 = c30v0:GetLoadOut()
        do return c30v1 end
      end
      c34v0.GetLocalLoadout = c34v1
      c34v0 = _T
      c34v1 = function(c31v0, c31v1)
        local c31v2, c31v3, c31v4, c31v5, c31v6, c31v7
        c31v2 = _T
        c31v2 = c31v2:GetLocalLoadout()
        c31v3 = IsNull
        c31v3 = c31v3(c31v2)
        if c31v3 then
          do return end
        end
        c31v3 = gGameData
        c31v4 = IsNull
        c31v4 = c31v4(c31v3)
        if not c31v4 then
          c31v7 = "OnAvatarImageSet"
          c31v3:SetActiveAvatarImage(c31v1, c31v7)
        end
        c31v2:SetActiveAvatarImage(c31v1)
        c31v4 = gMatchingService
        c31v4 = c31v4:GetSession()
        c31v5 = IsNull
        c31v5 = c31v5(c31v4)
        if not c31v5 then
          c31v5 = c31v4:IsLobbyReady()
          if c31v5 then
            c31v5 = print
            c31v6 = "SetProfileIcon - SendLobbyLoadout"
            c31v5(c31v6)
            c31v5 = gGameRules
            c31v5:SendLobbyLoadout()
          end
        end
        c31v5 = _T
        c31v5:UpdateProfileIconList()
        do return end
      end
      c34v0.SetProfileIcon = c34v1
      c34v0 = _T
      c34v1 = function(c32v0, c32v1)
        local c32v2, c32v3, c32v4, c32v5, c32v6, c32v7
        c32v2 = _T
        c32v2 = c32v2:GetLocalLoadout()
        c32v3 = IsNull
        c32v3 = c32v3(c32v2)
        if c32v3 then
          do return end
        end
        c32v3 = gGameData
        c32v4 = IsNull
        c32v4 = c32v4(c32v3)
        if not c32v4 then
          c32v7 = "OnAvatarImageSet"
          c32v3:SetTitle(c32v1, c32v7)
        end
        c32v2:SetTitle(c32v1)
        c32v4 = gMatchingService
        c32v4 = c32v4:GetSession()
        c32v5 = IsNull
        c32v5 = c32v5(c32v4)
        if not c32v5 then
          c32v5 = c32v4:IsLobbyReady()
          if c32v5 then
            c32v5 = print
            c32v6 = "SetProfileTitle - SendLobbyLoadout"
            c32v5(c32v6)
            c32v5 = gGameRules
            c32v5:SendLobbyLoadout()
          end
        end
        c32v5 = _T
        c32v5:UpdateProfileIconList()
        do return end
      end
      c34v0.SetProfileTitle = c34v1
      c34v0 = _T
      c34v1 = function()
        local c33v0, c33v1, c33v2, c33v3, c33v4, c33v5, c33v6, c33v7, c33v8, c33v9, c33v10, c33v11
        c33v1 = _T.profileIconList
        c33v0 = IsNull
        c33v0 = c33v0(c33v1)
        if c33v0 then
          do return end
        end
        c33v0 = _T.GetLocalLoadout
        c33v0 = c33v0()
        c33v1 = {}
        c33v3 = _T.profileIconList
        c33v2 = #c33v3
        c33v5 = 1
        c33v3 = c33v2
        c33v4 = 1
        for c33v5 = c33v5, c33v3, c33v4 do
          c33v7 = _T.profileIconList
          c33v6 = c33v7[c33v5]
          c33v8 = c33v6.Movie
          c33v7 = IsNull
          c33v7 = c33v7(c33v8)
          c33v7 = c33v6.Icon
          c33v8 = c33v7:GetActiveAvatarImage()
          c33v9 = IsNull
          c33v9 = c33v9(c33v8)
          c33v10 = c33v8.mItemType
          c33v9 = IsNull
          c33v9 = c33v9(c33v10)
          c33v9 = _G
          c33v8 = c33v9.UITexture_ProfilePlaceHolder
          c33v9 = Resource
          c33v10 = c33v8.mItemType
          c33v9 = c33v9(c33v10)
          c33v10 = IsNull
          c33v10 = c33v10(c33v9)
          if not c33v10 then
            c33v8 = c33v9:GetIconTexture()
          end
          c33v8 = c33v6.Icon
          c33v7 = IsNull
          c33v7 = c33v7(c33v8)
          if not c33v7 then
            c33v8 = c33v6.Movie
            c33v7 = IsNull
            c33v7 = c33v7(c33v8)
            if not c33v7 then
              c33v7 = c33v6.Movie
              c33v9 = c33v6.Clip
              c33v10 = c33v6.Icon
              c33v7:OverrideTexture(c33v9, c33v10)
            end
          end
          c33v8 = #c33v1
          c33v7 = c33v8 + 1
          c33v1[c33v7] = c33v6
          c33v7 = c33v0
          c33v9 = c33v6.HumanPlayer
          c33v8 = IsNull
          c33v8 = c33v8(c33v9)
          if not c33v8 then
            c33v8 = c33v6.HumanPlayer
            c33v8 = c33v8:IsLocal()
            if not c33v8 then
              c33v8 = c33v6.HumanPlayer
              c33v7 = c33v8:GetLoadOut()
            end
          end
          c33v8 = IsNull
          c33v8 = c33v8(c33v7)
          c33v9 = IsNull
          c33v9 = c33v9(c33v8)
          if not c33v9 then
            c33v10 = c33v6.Movie
            c33v9 = IsNull
            c33v9 = c33v9(c33v10)
            if not c33v9 then
              c33v9 = c33v6.Movie
              c33v11 = c33v6.Clip
              c33v9:OverrideTexture(c33v11, c33v8)
            end
          end
          c33v10 = #c33v1
          c33v9 = c33v10 + 1
          c33v1[c33v9] = c33v6
        end
        c33v3 = _T
        c33v3.profileIconList = c33v1
        do return end
      end
      c34v0.UpdateProfileIconList = c34v1
    end
    do return end
  end
  InitializeProfileIconList = vT[50]
  vT[50] = function(c35v0, c35v1)
    local c35v2, c35v3, c35v4, c35v5, c35v6, c35v7
    c35v3 = _T.profileIconList
    c35v2 = IsNull
    c35v2 = c35v2(c35v3)
    if c35v2 then
      do return end
    end
    c35v3 = _T.profileIconList
    c35v2 = #c35v3
    c35v5 = 1
    c35v3 = c35v2
    c35v4 = 1
    for c35v5 = c35v5, c35v3, c35v4 do
      c35v7 = _T.profileIconList
      c35v6 = c35v7[c35v5]
      c35v6 = c35v6.Movie
      if c35v6 == c35v0 then
        c35v7 = _T.profileIconList
        c35v6 = c35v7[c35v5]
        c35v6 = c35v6.Clip
        if c35v6 == c35v1 then break end
        if c35v6 == c35v1 then
          c35v6 = table.remove
          c35v7 = _T.profileIconList
          c35v6(c35v7, c35v5)
          do return end
        end
      end
    end
    do return end
  end
  UnregisterProfileIcon = vT[50]
  vT[50] = function(c36v0, c36v1, c36v2, c36v3)
    local c36v4, c36v5, c36v6, c36v7, c36v8, c36v9, c36v10, c36v11
    c36v5 = _T.profileIconList
    c36v4 = IsNull
    c36v4 = c36v4(c36v5)
    if c36v4 then
      do return end
    end
    c36v4 = { Movie = nil, Clip = nil, HumanPlayer = nil, Icon = nil }
    c36v4.Movie = c36v0
    c36v4.Clip = c36v1
    c36v4.HumanPlayer = c36v2
    c36v4.Icon = c36v3
    c36v5 = false
    c36v7 = _T.profileIconList
    c36v6 = #c36v7
    c36v9 = 1
    c36v7 = c36v6
    c36v8 = 1
    for c36v9 = c36v9, c36v7, c36v8 do
      c36v11 = _T.profileIconList
      c36v10 = c36v11[c36v9]
      c36v10 = c36v10.Clip
      c36v11 = c36v4.Clip
      if c36v10 == c36v11 then break end
      if c36v10 == c36v11 then
        c36v5 = true
        c36v10 = _T.profileIconList
        c36v10[c36v9] = c36v4
      end
    end
    if not c36v5 then
      c36v7 = _T.profileIconList
      c36v8 = c36v6 + 1
      c36v7[c36v8] = c36v4
    end
    c36v7 = _T
    c36v7:UpdateProfileIconList()
    do return end
  end
  RegisterProfileIcon = vT[50]
  vT[50] = function(c37v0, c37v1, c37v2, c37v3, c37v4, c37v5)
    local c37v6, c37v7
    c37v7 = gGameData
    c37v6 = IsNull
    c37v6 = c37v6(c37v7)
    if c37v6 then
      do return end
    end
    c37v6 = REPORT_PLAYER
    if c37v3 == c37v6 then
      c37v6 = gMatchingService
      c37v6 = c37v6:GetIrcMgr()
      if c37v6 ~= nil then
        c37v6:ReportPlayer(c37v0, c37v1, c37v2, c37v4)
        do return end
      end
    else
      c37v6 = REPORT_CLAN_AD
      if c37v3 == c37v6 then
        c37v6 = gGameData
        c37v6:Name__5ec03a61(c37v5, c37v1, c37v2, c37v4)
      end
    end
    do return end
  end
  vT[51] = function(c40v0, c40v1)
    local c40v2, c40v3, c40v4, c40v5, c40v6
    c40v2 = IsNull
    c40v2 = c40v2(c40v0)
    if not c40v2 then
      c40v3 = _G
      c40v3 = c40v3.UIMovie_GenericSettings
      c40v2 = IsNull
      c40v2 = c40v2(c40v3)
      if not c40v2 then
        c40v4 = _G
        c40v4 = c40v4.UIMovie_GenericSettings
        c40v2 = c40v0:PushChildMovie(c40v4)
        c40v3 = IsNull
        c40v3 = c40v3(c40v2)
        if c40v3 then
          do return end
        end
        c40v5 = "SetTitle"
        c40v6 = "/Lotus/Language/Menu/ReportPlayer_DetailsTitle"
        c40v2:Execute(c40v5, c40v6)
        c40v5 = "SetConfirmButtonActive"
        c40v6 = "true"
        c40v2:Execute(c40v5, c40v6)
        c40v3 = _T
        c40v4 = function(c38v0, c38v1)
          local c38v2, c38v3, c38v5, c38v6
          c38v2 = _T
          c38v3 = nil
          c38v2.ReportReason_Done = c38v3
          c38v2 = _T
          c38v3 = nil
          c38v2.ReportReason_GetSettings = c38v3
          c38v2 = IsNull
          c38v2 = c38v2(c38v1)
          if c38v2 then
            c38v2 = c38v0[1]
            c38v2 = c38v2.mContent
            c38v3 = string.gsub
            c38v5 = "\r\n"
            c38v6 = " "
            c38v2 = c38v3(c38v2, c38v5, c38v6)
            c38v3 = string.gsub
            c38v5 = "\n"
            c38v6 = " "
            c38v2 = c38v3(c38v2, c38v5, c38v6)
            c38v3 = string.gsub
            c38v5 = "\r"
            c38v6 = " "
            c38v2 = c38v3(c38v2, c38v5, c38v6)
            c38v3 = c40v0
            c38v5 = "ConfirmReport"
            c38v3:Execute(c38v5, c38v2)
            do return end
          end
          c38v3 = c40v1
          c38v2 = IsNull
          c38v2 = c38v2(c38v3)
          if not c38v2 then
            c38v2 = c40v1
            c38v3 = false
            c38v2(c38v3)
          end
          do return end
        end
        c40v3.ReportReason_Done = c40v4
        c40v5 = "SetCallBack"
        c40v6 = "ReportReason_Done"
        c40v2:Execute(c40v5, c40v6)
        c40v3 = _T
        c40v4 = function()
          local c39v0, c39v1, c39v3, c39v4
          c39v0 = {}
          c39v3 = { mLabel = "/Lotus/Language/CrashHandler/STRING_DETAILS", mType = nil, mMaxChars = 140, mWidth = 500, mHeight = 210, mMultiLine = true }
          c39v4 = INPUTBOX
          c39v3.mType = c39v4
          c39v1 = table.insert
          c39v1(c39v0, c39v3)
          do return c39v0 end
        end
        c40v3.ReportReason_GetSettings = c40v4
        c40v5 = "SetElementsFunction"
        c40v6 = "ReportReason_GetSettings"
        c40v2:Execute(c40v5, c40v6)
        do return end
      end
    end
    do return end
  end
  vT[52] = function(c46v0, c46v1, c46v2, c46v3, c46v4, c46v5)
    local c46v6, c46v7, c46v8, c46v9, c46v10, c46v11, c46v12, c46v13, c46v14, c46v15, c46v19, c46v20
    c46v6 = IsNull
    c46v6 = c46v6(c46v0)
    if not c46v6 then
      c46v7 = _G
      c46v7 = c46v7.UIMovie_GenericMenu
      c46v6 = IsNull
      c46v6 = c46v6(c46v7)
      if not c46v6 then
        if c46v4 == nil then
          c46v4 = REPORT_PLAYER
        end
        c46v6 = ""
        c46v7 = ""
        c46v8 = vT[41]
        c46v10 = 1
        c46v8 = c46v8(c46v0, c46v10)
        c46v9 = function(c41v0)
          local c41v1, c41v2, c41v3, c41v4, c41v5
          c41v1 = vT[17]
          c41v1 = c41v1.Ternary
          if c41v0 ~= nil then
            c41v2 = false
          else
            c41v2 = true
          end
          c41v3 = ""
          c41v1 = c41v1(c41v2, c41v3, c41v0)
          c46v7 = c41v1
          c41v1 = vT[17]
          c41v1 = c41v1.ShowYesOrNoMessage
          c41v2 = "/Lotus/Language/Menu/ReportPlayer_ConfirmText"
          c41v3 = "OnConfirmReport"
          c41v1 = c41v1(c41v2, c41v3)
          c41v2 = IsNull
          c41v2 = c41v2(c41v1)
          if not c41v2 then
            c41v4 = "SetSendCallbackOnShutdown"
            c41v5 = "true"
            c41v1:Execute(c41v4, c41v5)
          end
          do return end
        end
        c46v8.ConfirmReport = c46v9
        c46v9 = function(c42v0)
          local c42v1, c42v2, c42v3, c42v4, c42v5, c42v6, c42v7
          c42v1 = tonumber
          c42v1 = c42v1(c42v0)
          c42v2 = 4
          if c42v1 == c42v2 then
            c42v1 = c46v6
            c42v2 = c46v1
            c42v3 = c46v6
            c42v4 = c46v7
            c42v5 = c46v4
            c42v6 = "OnReported"
            c42v7 = c46v5
            c42v1(c42v2, c42v3, c42v4, c42v5, c42v6, c42v7)
            do return end
          end
          c42v2 = c46v2
          c42v1 = IsNull
          c42v1 = c42v1(c42v2)
          if not c42v1 then
            c42v1 = c46v2
            c42v2 = nil
            c42v1(c42v2)
          end
          do return end
        end
        c46v8.OnConfirmReport = c46v9
        c46v9 = function(c43v0, c43v1)
          local c43v2, c43v3, c43v4
          if c43v0 then
            c43v3 = c46v6
            c43v3 = c43v3.ShowMessage
            c43v4 = "/Lotus/Language/Menu/ReportPlayerSuccess"
            c43v3(c43v4)
            c43v2 = c46v6
          else
            c43v3 = c46v6
            c43v3 = c43v3.ShowErrorMessage
            c43v4 = "/Lotus/Language/Menu/ReportPlayerFailed"
            c43v3(c43v4)
          end
          c43v4 = c46v2
          c43v3 = IsNull
          c43v3 = c43v3(c43v4)
          if not c43v3 then
            c43v3 = c46v2
            c43v3(c43v2)
          end
          c43v3 = c46v8
          c43v4 = nil
          c43v3.ConfirmReport = c43v4
          c43v3 = c46v8
          c43v4 = nil
          c43v3.OnConfirmReport = c43v4
          c43v3 = c46v8
          c43v4 = nil
          c43v3.OnReported = c43v4
          do return end
        end
        c46v8.OnReported = c46v9
        c46v11 = _G
        c46v11 = c46v11.UIMovie_GenericMenu
        c46v9 = c46v0:PushChildMovie(c46v11)
        c46v12 = "SetTitle"
        c46v19 = "/Lotus/Language/Menu/SocialOverlay_ReportPlayer"
        c46v20 = false
        c46v14 = c46v0:GetLocalized(c46v19, c46v20)
        c46v15 = " "
        c46v13 = c46v14 .. c46v15 .. c46v1
        c46v9:Execute(c46v12, c46v13)
        c46v10 = _T
        c46v11 = function(c44v0)
          local c44v1, c44v2, c44v3
          c44v1 = _T
          c44v2 = nil
          c44v1.ReportSelectionDone = c44v2
          c44v1 = _T
          c44v2 = nil
          c44v1.GetReportOptions = c44v2
          c44v1 = c44v0[1]
          if c44v1 ~= nil then
            c44v1 = c44v0[1]
            c44v1 = c44v1.mReason
            c46v6 = c44v1
            c44v1 = c46v2
            c44v2 = c46v0
            c44v3 = c46v2
            c44v1(c44v2, c44v3)
            do return end
          end
          c44v2 = c46v2
          c44v1 = IsNull
          c44v1 = c44v1(c44v2)
          if not c44v1 then
            c44v1 = c46v2
            c44v2 = false
            c44v1(c44v2)
          end
          do return end
        end
        c46v10.ReportSelectionDone = c46v11
        c46v12 = "SetCallBack"
        c46v13 = "ReportSelectionDone"
        c46v9:Execute(c46v12, c46v13)
        c46v10 = _T
        c46v11 = function()
          local c45v0, c45v1, c45v3
          c45v0 = {}
          c45v3 = { mName = "/Lotus/Language/Menu/ReportPlayer_Spam", mReason = "Spam" }
          c45v1 = table.insert
          c45v1(c45v0, c45v3)
          c45v3 = { mName = "/Lotus/Language/Menu/ReportPlayer_OffensiveLanguage", mReason = "OffensiveLangauge" }
          c45v1 = table.insert
          c45v1(c45v0, c45v3)
          c45v3 = { mName = "/Lotus/Language/Menu/ReportPlayer_OffensiveName", mReason = "OffensiveName" }
          c45v1 = table.insert
          c45v1(c45v0, c45v3)
          c45v3 = { mName = "/Lotus/Language/CustomerSupport/ReportPlayer_OffensiveImage", mReason = "OffensiveImage" }
          c45v1 = table.insert
          c45v1(c45v0, c45v3)
          c45v3 = { mName = "/Lotus/Language/Menu/ReportPlayer_Harassment", mReason = "Harassment" }
          c45v1 = table.insert
          c45v1(c45v0, c45v3)
          c45v3 = { mName = "/Lotus/Language/Menu/ReportPlayer_RealLifeThreat", mReason = "RealLifeThreat" }
          c45v1 = table.insert
          c45v1(c45v0, c45v3)
          c45v3 = { mName = "/Lotus/Language/CustomerSupport/ReportPlayer_Cheating", mReason = "Cheating" }
          c45v1 = table.insert
          c45v1(c45v0, c45v3)
          c45v3 = { mName = "/Lotus/Language/CustomerSupport/ReportPlayer_RealMoneyTrade", mReason = "RealMoneyTrade" }
          c45v1 = table.insert
          c45v1(c45v0, c45v3)
          c45v3 = { mName = "/Lotus/Language/CustomerSupport/ReportPlayer_Griefing", mReason = "Griefing" }
          c45v1 = table.insert
          c45v1(c45v0, c45v3)
          c45v3 = { mName = "/Lotus/Language/CustomerSupport/ReportPlayer_HateSpeech", mReason = "HateSpeech" }
          c45v1 = table.insert
          c45v1(c45v0, c45v3)
          do return c45v0 end
        end
        c46v10.GetReportOptions = c46v11
        c46v12 = "SetElementsFunction"
        c46v13 = "GetReportOptions"
        c46v9:Execute(c46v12, c46v13)
        do return c46v9 end
      end
    end
    c46v6 = nil
    do return c46v6 end
  end
  ShowReportMenu = vT[52]
  vT[52] = function(c47v0)
    local c47v1
    c47v1 = vT[17]
    c47v1 = c47v1.ToRad
    c47v1 = c47v1(c47v0)
    do return c47v1 end
  end
  ToRad = vT[52]
  vT[52] = function(c48v0, c48v1, c48v2)
    local c48v3
    c48v3 = vT[17]
    c48v3 = c48v3.TransformPixelToViewportCoordinates
    c48v3 = c48v3(c48v0, c48v1, c48v2)
    do return c48v3 end
  end
  TransformPixelToViewportCoordinates = vT[52]
  vT[52] = function(c49v0, c49v1, c49v2)
    local c49v3
    c49v3 = vT[17]
    c49v3 = c49v3.GetRootBasedPosition
    do return c49v3(c49v0, c49v1, c49v2) end
  end
  GetRootBasedPosition = vT[52]
  vT[52] = function(c50v0, c50v1, c50v2, c50v3, c50v4, c50v5, c50v6)
    local c50v7
    c50v7 = vT[17]
    c50v7 = c50v7.CreateScreenParticles
    do return c50v7(c50v0, c50v1, c50v2, c50v3, c50v4, c50v5, c50v6) end
  end
  CreateScreenParticles = vT[52]
  vT[52] = function(c51v0, c51v1, c51v2, c51v3)
    local c51v4, c51v5, c51v6, c51v7, c51v8, c51v9, c51v10, c51v11, c51v12, c51v13, c51v14, c51v15, c51v16, c51v17, c51v18
    c51v4 = {}
    c51v7 = 1
    c51v5 = 4
    c51v6 = 1
    for c51v7 = c51v7, c51v5, c51v6 do
      c51v8 = nil
      c51v9 = IsNull
      c51v9 = c51v9(c51v2)
      if not c51v9 then
        c51v11 = c51v7 - 1
        c51v8 = c51v2:Name__262de5ca(c51v11)
      end
      c51v9 = IsNull
      c51v9 = c51v9(c51v8)
      if c51v9 then
        c51v9 = Resource
        c51v9 = c51v9(c51v8)
        c51v4[c51v7] = c51v9
        c51v10 = c51v9:GetLocalizeTag()
        c51v15 = ".Ability"
        c51v17 = ".Name.text"
        c51v13 = c51v1 .. c51v15 .. c51v7 .. c51v17
        c51v0:SetLocalized(c51v13, c51v10:c_str())
        c51v11 = c51v9:GetIconTexture()
        c51v12 = IsNull
        c51v12 = c51v12(c51v11)
        if not c51v12 then
          c51v16 = ".Ability"
          c51v18 = ".Icon"
          c51v14 = c51v1 .. c51v16 .. c51v7 .. c51v18
          c51v0:OverrideTexture(c51v14, c51v11)
        end
        c51v16 = ".Ability"
        c51v18 = ".Icon"
        c51v14 = c51v1 .. c51v16 .. c51v7 .. c51v18
        c51v15 = 13
        c51v17 = IsNull
        c51v17 = c51v17(c51v11)
        c51v16 = not c51v17
        c51v0:Name__d9713943(c51v14, c51v15, c51v16)
      else
        c51v13 = ".Ability"
        c51v15 = ".Name.text"
        c51v11 = c51v1 .. c51v13 .. c51v7 .. c51v15
        c51v12 = ""
        c51v0:SetLocalized(c51v11, c51v12)
        c51v13 = ".Ability"
        c51v15 = ".Icon"
        c51v11 = c51v1 .. c51v13 .. c51v7 .. c51v15
        c51v12 = nil
        c51v0:OverrideTexture(c51v11, c51v12)
        c51v13 = ".Ability"
        c51v15 = ".Icon"
        c51v11 = c51v1 .. c51v13 .. c51v7 .. c51v15
        c51v12 = 13
        c51v13 = false
        c51v0:Name__d9713943(c51v11, c51v12, c51v13)
      end
    end
    do return c51v4 end
  end
  SetupAbilityUIBySuitType = vT[52]
  vT[52] = function(c52v0, c52v1, c52v2, c52v3)
    local c52v4, c52v5, c52v6, c52v7, c52v8, c52v9, c52v10, c52v11, c52v12, c52v13, c52v14, c52v15, c52v16, c52v17
    c52v4 = {}
    c52v7 = 1
    c52v5 = 4
    c52v6 = 1
    for c52v7 = c52v7, c52v5, c52v6 do
      c52v8 = nil
      c52v9 = IsNull
      c52v9 = c52v9(c52v2)
      if not c52v9 then
        c52v11 = c52v7 - 1
        c52v8 = c52v2:GetAbilityByIndex(c52v11)
      end
      c52v9 = IsNull
      c52v9 = c52v9(c52v8)
      if c52v9 then
        c52v4[c52v7] = c52v8
        c52v9 = c52v8:GetLocalizeTag()
        c52v14 = ".Ability"
        c52v16 = ".Name.text"
        c52v12 = c52v1 .. c52v14 .. c52v7 .. c52v16
        c52v0:SetLocalized(c52v12, c52v9:c_str())
        c52v10 = c52v8:GetIconTexture()
        c52v11 = IsNull
        c52v11 = c52v11(c52v10)
        if not c52v11 then
          c52v15 = ".Ability"
          c52v17 = ".Icon"
          c52v13 = c52v1 .. c52v15 .. c52v7 .. c52v17
          c52v0:OverrideTexture(c52v13, c52v10)
        end
        c52v15 = ".Ability"
        c52v17 = ".Icon"
        c52v13 = c52v1 .. c52v15 .. c52v7 .. c52v17
        c52v14 = 13
        c52v16 = IsNull
        c52v16 = c52v16(c52v10)
        c52v15 = not c52v16
        c52v0:Name__d9713943(c52v13, c52v14, c52v15)
      else
        c52v13 = ".Ability"
        c52v15 = ".Name.text"
        c52v11 = c52v1 .. c52v13 .. c52v7 .. c52v15
        c52v12 = "/Lotus/Language/Menu/Empty_Precept"
        c52v0:SetLocalized(c52v11, c52v12)
        c52v13 = ".Ability"
        c52v15 = ".Icon"
        c52v11 = c52v1 .. c52v13 .. c52v7 .. c52v15
        c52v12 = nil
        c52v0:OverrideTexture(c52v11, c52v12)
        c52v13 = ".Ability"
        c52v15 = ".Icon"
        c52v11 = c52v1 .. c52v13 .. c52v7 .. c52v15
        c52v12 = 13
        c52v13 = false
        c52v0:Name__d9713943(c52v11, c52v12, c52v13)
      end
    end
    do return c52v4 end
  end
  SetupAbilityUIBySuitInstance = vT[52]
  vT[52] = function(c58v0)
    local c58v1, c58v2
    c58v1 = { mIndex = 0, mMovie = nil, mIsShowing = false, mListItems = nil, Add = nil, Clear = nil, IsShowing = nil, Hide = nil, Show = nil }
    c58v2 = {}
    c58v1.mListItems = c58v2
    c58v2 = function(c53v0, c53v1, c53v2)
      local c53v3, c53v4, c53v5, c53v6, c53v7, c53v8
      c53v4 = c53v0.mIndex
      c53v3 = c53v4 + 1
      c53v0.mIndex = c53v3
      c53v3 = c53v0.mMovie
      c53v6 = "ContextMenu.Btn"
      c53v7 = c53v0.mIndex
      c53v5 = c53v6 .. c53v7
      c53v6 = 67
      c53v7 = true
      c53v3:Name__d9713943(c53v5, c53v6, c53v7)
      c53v3 = c53v0.mMovie
      c53v6 = "ContextMenu.Btn"
      c53v7 = c53v0.mIndex
      c53v5 = c53v6 .. c53v7
      c53v6 = 13
      c53v7 = true
      c53v3:Name__d9713943(c53v5, c53v6, c53v7)
      c53v3 = c53v0.mMovie
      c53v6 = "ContextMenu.Btn"
      c53v7 = c53v0.mIndex
      c53v5 = c53v6 .. c53v7
      c53v6 = "Id"
      c53v7 = c53v0.mIndex
      c53v3:SetVariable(c53v5, c53v6, c53v7)
      c53v3 = c53v0.mMovie
      c53v6 = "ContextMenu.Btn"
      c53v7 = c53v0.mIndex
      c53v8 = ".Label.text"
      c53v5 = c53v6 .. c53v7 .. c53v8
      c53v3:SetLocalized(c53v5, c53v1)
      c53v3 = c53v0.mListItems
      c53v4 = c53v0.mIndex
      c53v5 = { Label = nil, PressedCallback = nil }
      c53v5.Label = c53v1
      c53v5.PressedCallback = c53v2
      c53v3[c53v4] = c53v5
      do return end
    end
    c58v1.Add = c58v2
    c58v2 = function(c54v0)
      local c54v1
      c54v1 = 0
      c54v0.mIndex = c54v1
      c54v0:Show()
      do return end
    end
    c58v1.Clear = c58v2
    c58v2 = function(c55v0)
      local c55v1
      c55v1 = c55v0.mIsShowing
      do return c55v1 end
    end
    c58v1.IsShowing = c58v2
    c58v2 = function(c56v0)
      local c56v1, c56v3, c56v4, c56v5
      c56v1 = c56v0:IsShowing()
      if not c56v1 then
        do return end
      end
      c56v1 = false
      c56v0.mIsShowing = c56v1
      c56v1 = c56v0.mMovie
      c56v3 = "ContextMenu"
      c56v4 = 67
      c56v5 = false
      c56v1:Name__d9713943(c56v3, c56v4, c56v5)
      c56v1 = c56v0.mMovie
      c56v3 = "ContextMenu"
      c56v4 = 13
      c56v5 = false
      c56v1:Name__d9713943(c56v3, c56v4, c56v5)
      do return end
    end
    c58v1.Hide = c58v2
    c58v2 = function(c57v0)
      local c57v1, c57v2, c57v3, c57v4, c57v5, c57v6, c57v7, c57v8
      c57v1 = true
      c57v0.mIsShowing = c57v1
      c57v1 = c57v0.mIndex
      c57v2 = 0
      if c57v2 < c57v1 then
        c57v1 = c57v0.mMovie
        c57v3 = "ContextMenu"
        c57v4 = 67
        c57v5 = true
        c57v1:Name__d9713943(c57v3, c57v4, c57v5)
        c57v1 = c57v0.mMovie
        c57v3 = "ContextMenu"
        c57v4 = 13
        c57v5 = true
        c57v1:Name__d9713943(c57v3, c57v4, c57v5)
        c57v2 = c57v0.mMovie
        c57v4 = "_root"
        c57v5 = 30
        c57v2 = c57v2:GetNumberVariable(c57v4, c57v5)
        c57v1 = c57v2 + 60
        c57v2 = c57v0.mMovie
        c57v4 = "_root"
        c57v5 = 31
        c57v2 = c57v2:GetNumberVariable(c57v4, c57v5)
        c57v3 = c57v0.mMovie
        c57v5 = "ContextMenu"
        c57v6 = 0
        c57v3:SetNumberVariable(c57v5, c57v6, c57v1)
        c57v3 = c57v0.mMovie
        c57v5 = "ContextMenu"
        c57v6 = 1
        c57v3:SetNumberVariable(c57v5, c57v6, c57v2)
      else
        c57v0:Hide()
      end
      c57v3 = 1
      c57v1 = 8
      c57v2 = 1
      for c57v3 = c57v3, c57v1, c57v2 do
        c57v6 = true
        c57v7 = false
        c57v4 = c57v4(c57v5, c57v6, c57v7)
        c57v5 = c57v0.mMovie
        c57v8 = "ContextMenu.Btn"
        c57v7 = c57v8 .. c57v3
        c57v8 = 67
        c57v5:Name__d9713943(c57v7, c57v8, c57v4)
        c57v5 = c57v0.mMovie
        c57v8 = "ContextMenu.Btn"
        c57v7 = c57v8 .. c57v3
        c57v8 = 13
        c57v5:Name__d9713943(c57v7, c57v8, c57v4)
        c57v4 = vT[17]
        c57v4 = c57v4.Ternary
        c57v6 = c57v0.mIndex
        if c57v6 < c57v3 then
          c57v5 = false
        else
          c57v5 = true
        end
      end
      do return end
    end
    c58v1.Show = c58v2
    c58v2 = _T
    c58v2.ContextMenu = c58v1
    c58v2 = _T.ContextMenu
    c58v2.mMovie = c58v0
    do return end
  end
  InitializeContextMenu = vT[52]
  vT[52] = function(c59v0)
    local c59v1, c59v2, c59v3, c59v4, c59v5
    c59v1 = IsNull
    c59v1 = c59v1(c59v0)
    if c59v1 then
      c59v1 = 0
      do return c59v1 end
    end
    c59v1 = c59v0.mItemType
    c59v2 = IsNull
    c59v2 = c59v2(c59v1)
    if c59v2 then
      c59v2 = 0
      do return c59v2 end
    end
    c59v2 = c59v0.mUpgradeVer
    c59v3 = Lotus_Game.Name__c188272e
    c59v3 = c59v3()
    if c59v2 == c59v3 then
      c59v2 = 0
      do return c59v2 end
    end
    c59v2 = gGameConfig
    c59v4 = c59v0.mXP
    c59v5 = c59v0.mItemType
    c59v2 = c59v2:GetItemLevel(c59v4, c59v5)
    do return c59v2 end
  end
  GetPointsRemainingForItem = vT[52]
  vT[52] = function(c60v0)
    local c60v1, c60v2, c60v3, c60v4, c60v5, c60v6, c60v7, c60v8, c60v9, c60v10
    c60v1 = gGameConfig
    c60v1 = c60v1:CanPurchaseIfAlreadyOwned(c60v0)
    c60v2 = false
    c60v3 = false
    c60v4 = nil
    c60v6 = gGameRules
    c60v5 = IsNull
    c60v5 = c60v5(c60v6)
    if not c60v5 then
      c60v5 = gGameRules
      c60v4 = c60v5:GetStoreManifest()
      c60v5 = IsNull
      c60v5 = c60v5(c60v4)
      if not c60v5 then
        c60v5 = c60v4:Name__6b727a06(c60v0)
        c60v6 = false
        if c60v5 ~= nil then
          c60v6 = false
          c60v7 = c60v5.mSlot
          c60v8 = 14
          if c60v8 <= c60v7 then
            c60v7 = c60v5.mSlot
            c60v8 = 16
            if c60v8 < c60v7 then
              c60v6 = false
            else
              c60v6 = true
            end
          end
        end
        c60v2 = c60v6
        c60v6 = false
        if c60v5 ~= nil then
          c60v7 = c60v5.mSlot
          c60v8 = 17
          if c60v7 ~= c60v8 then
            c60v6 = false
          else
            c60v6 = true
          end
        end
        c60v3 = c60v6
      end
    end
    c60v5 = IsNull
    c60v5 = c60v5(c60v0)
    if c60v5 then
      c60v5 = c60v0:OneTimePurchasable()
      if c60v5 then
        c60v6 = gGameData
        c60v5 = IsNull
        c60v5 = c60v5(c60v6)
        if not c60v5 then
          c60v5 = gGameData
          c60v5 = c60v5:GetInventory()
          c60v5 = c60v5:Name__6d6f5521()
          c60v6 = c60v0:GetFullName()
          c60v7 = IsNull
          c60v7 = c60v7(c60v0:GetItem())
          if not c60v7 then
            c60v7 = c60v0:GetItem()
            c60v6 = c60v7:GetFullName()
          end
          c60v9 = 1
          c60v7 = #c60v5
          c60v8 = 1
          for c60v9 = c60v9, c60v7, c60v8 do
            c60v10 = c60v5[c60v9]
            if c60v10 == c60v6 then break end
            if c60v10 == c60v6 then
              c60v1 = false
            end
          end
        end
      end
    end
    c60v5 = c60v1
    if not c60v5 then
      c60v5 = c60v2
      if not c60v5 then
        c60v5 = c60v3
      end
    end
    do return c60v5 end
  end
  vT[53] = function(c61v0)
    local c61v1
    c61v1 = vT[52]
    do return c61v1(c61v0) end
  end
  CanPurchaseIfAlreadyOwned = vT[53]
  vT[53] = function(c62v0)
    local c62v1, c62v2
    c62v1 = gGameConfig
    c62v1 = c62v1:Name__9f88c518(c62v0)
    c62v2 = 12
    if c62v1 < c62v2 then
      c62v2 = gGameData
      c62v2 = c62v2:GetInventory()
      c62v2 = c62v2:GetBinSlots(c62v1)
      do return c62v2 end
    end
    do return end
  end
  GetSlotsForCategory = vT[53]
  vT[53] = function(c63v0, c63v1)
    local c63v2, c63v3, c63v4, c63v5
    c63v2 = gGameData
    if c63v1 == nil then
      c63v1 = 1
    end
    c63v3 = gGameConfig
    c63v3 = c63v3:Name__9f88c518(c63v0)
    c63v4 = 12
    if c63v4 <= c63v3 then
      c63v4 = true
      do return c63v4 end
    end
    c63v5 = c63v2:GetInventory()
    c63v5 = c63v5:GetBinSlots(c63v3)
    if c63v5 < c63v1 then
      c63v4 = false
    else
      c63v4 = true
    end
    do return c63v4 end
  end
  HaveEnoughSlots = vT[53]
  vT[53] = function(c64v0)
    local c64v1, c64v2, c64v3
    c64v1 = IsNull
    c64v1 = c64v1(c64v0)
    if c64v1 then
      c64v1 = false
      do return c64v1 end
    end
    c64v1 = c64v0:GetRequiredLevel()
    c64v3 = gGameData
    c64v2 = IsNull
    c64v2 = c64v2(c64v3)
    if c64v2 then
      c64v2 = print
      c64v3 = "IsXPLocked: gGameData was nil"
      c64v2(c64v3)
      c64v2 = false
      do return c64v2 end
    end
    c64v2 = gGameData
    c64v2 = c64v2:Name__1d1bb34a()
    if c64v1 <= c64v2 then
      c64v3 = false
    else
      c64v3 = true
    end
    do return c64v3, c64v1 end
  end
  IsXPLocked = vT[53]
  vT[53] = function(c65v0, c65v1, c65v2, c65v3, c65v4)
    local c65v5
    c65v5 = vT[17]
    c65v5 = c65v5.CreateParticles
    do return c65v5(c65v0, c65v1, c65v2, c65v3, c65v4) end
  end
  CreateParticles = vT[53]
  vT[53] = function()
    local c66v0, c66v1, c66v2, c66v4
    c66v0 = string.lower
    c66v1 = gGameConfig
    c66v0 = c66v0(c66v1:Name__965f5a8b())
    c66v2 = string.find
    c66v4 = "api%-dev"
    c66v2 = c66v2(c66v0, c66v4)
    if c66v2 == nil then
      c66v1 = false
    else
      c66v1 = true
    end
    do return c66v1 end
  end
  vT[54] = function()
    local c67v0
    c67v0 = vT[53]
    do return c67v0() end
  end
  IsDevServer = vT[54]
  vT[54] = function()
    local c68v0, c68v1, c68v2, c68v4
    c68v0 = string.lower
    c68v1 = gGameConfig
    c68v0 = c68v0(c68v1:Name__965f5a8b())
    c68v2 = string.find
    c68v4 = "api%-test"
    c68v2 = c68v2(c68v0, c68v4)
    if c68v2 == nil then
      c68v1 = false
    else
      c68v1 = true
    end
    do return c68v1 end
  end
  vT[55] = function()
    local c69v0
    c69v0 = vT[54]
    do return c69v0() end
  end
  IsTestServer = vT[55]
  vT[55] = function()
    local c70v0, c70v1, c70v2, c70v4
    c70v0 = string.lower
    c70v1 = gGameConfig
    c70v0 = c70v0(c70v1:Name__965f5a8b())
    c70v2 = string.find
    c70v4 = "/localhost/"
    c70v2 = c70v2(c70v0, c70v4)
    if c70v2 == nil then
      c70v1 = false
    else
      c70v1 = true
    end
    do return c70v1 end
  end
  vT[56] = function()
    local c71v0
    c71v0 = vT[55]
    do return c71v0() end
  end
  IsLocalServer = vT[56]
  vT[56] = function()
    local c72v0
    c72v0 = vT[53]
    c72v0 = c72v0()
    if not c72v0 then
      c72v0 = vT[54]
      c72v0 = c72v0()
      if not c72v0 then
        c72v0 = vT[55]
        c72v0 = c72v0()
        if not c72v0 then
          c72v0 = true
          do return c72v0 end
        end
      end
    end
    c72v0 = false
    do return c72v0 end
  end
  IsRetailServer = vT[56]
  vT[56] = function()
    local c73v0, c73v1, c73v2
    local p8 = 0
    if p8 == 0 then
      c73v1 = gGameRules
      c73v0 = IsNull
      c73v0 = c73v0(c73v1)
      if c73v0 then
        p8 = 7
      else
        p8 = 1
      end
    end
    if p8 == 1 then
      c73v0 = gGameRules
      c73v2 = gLotusGameRulesType
      c73v0 = c73v0:IsA(c73v2)
      if c73v0 then
        p8 = 6
      else
        p8 = 2
      end
    end
    if p8 == 2 then
      c73v0 = gGameRules
      c73v2 = gLotusDojoGameRulesType
      c73v0 = c73v0:IsA(c73v2)
      if c73v0 then
        p8 = 6
      else
        p8 = 3
      end
    end
    if p8 == 3 then
      c73v0 = gGameRules
      c73v2 = gLotusBasePvpGameRulesType
      c73v0 = c73v0:IsA(c73v2)
      if c73v0 then
        p8 = 6
      else
        p8 = 4
      end
    end
    if p8 == 4 then
      c73v0 = gGameRules
      c73v2 = gLotusHubGameRulesType
      c73v0 = c73v0:IsA(c73v2)
      if c73v0 then
        p8 = 6
      else
        p8 = 5
      end
    end
    if p8 == 5 then
      c73v0 = gGameRules
      c73v2 = gLotusDuelGameRulesType
      c73v0 = c73v0:IsA(c73v2)
      if not c73v0 then
        p8 = 7
      else
        p8 = 6
      end
    end
    if p8 == 6 then
      c73v0 = true
      do return c73v0 end
    end
    if p8 == 7 then
      c73v0 = false
      do return c73v0 end
    end
  end
  vT[57] = function()
    local c74v0, c74v1, c74v2
    c74v1 = gGameRules
    c74v0 = IsNull
    c74v0 = c74v0(c74v1)
    if c74v0 then
      c74v0 = gStarChart
      do return c74v0 end
    end
    c74v0 = gGameRules
    c74v2 = gLotusHubGameRulesType
    c74v0 = c74v0:IsA(c74v2)
    if not c74v0 then
      c74v0 = vT[56]
      c74v0 = c74v0()
      if not c74v0 then
        c74v0 = gGameRules
        do return c74v0:GetStarChart() end
      end
    end
    c74v0 = gGameRules
    do return c74v0:GetCurrentStarChart() end
  end
  vT[58] = function(c75v0)
    local c75v1, c75v2, c75v3, c75v4, c75v5, c75v6, c75v7, c75v8, c75v9, c75v10, c75v11, c75v12, c75v13, c75v14, c75v15, c75v16, c75v17, c75v18, c75v19, c75v20, c75v21
    c75v1 = {}
    c75v2 = vT[57]
    c75v2 = c75v2()
    c75v3 = c75v2:GetRegions()
    c75v6 = 1
    c75v4 = #c75v3
    c75v5 = 1
    for c75v6 = c75v6, c75v4, c75v5 do
      c75v7 = c75v3[c75v6]
      c75v8 = c75v7.name
      c75v11 = 1
      c75v12 = c75v7.sectors
      c75v9 = #c75v12
      c75v10 = 1
      for c75v11 = c75v11, c75v9, c75v10 do
        c75v12 = ResetLineCount
        c75v13 = 0
        c75v12(c75v13)
        c75v13 = c75v7.sectors
        c75v12 = c75v13[c75v11]
        c75v13 = c75v12.nodeType
        c75v14 = 0
        c75v13 = c75v12.nodeType
        c75v14 = 4
        c75v13 = c75v12.nodeType
        c75v14 = 8
        c75v13 = c75v12.nodeType
        c75v14 = 2
        c75v13 = c75v12.mission
        c75v14 = c75v13.missionReward
        c75v15 = c75v14.randomizedItems
        c75v16 = c75v13.enemyCacheOverride
        c75v17 = { name = nil, locTag = nil, regionLocTag = nil, randomizedItems = nil, enemyCacheOverride = nil }
        c75v18 = c75v12.name
        c75v18 = c75v18:c_str()
        c75v17.name = c75v18
        c75v18 = c75v12.locTag
        c75v18 = c75v18:c_str()
        c75v17.locTag = c75v18
        c75v18 = vT[17]
        c75v18 = c75v18.Ternary
        c75v20 = c75v12.nodeType
        c75v21 = 2
        if c75v20 ~= c75v21 then
          c75v19 = false
        else
          c75v19 = true
        end
        c75v20 = "/Lotus/Language/GameModes/Conclave"
        c75v18 = c75v18(c75v19, c75v20, c75v8)
        c75v17.regionLocTag = c75v18
        c75v17.randomizedItems = c75v15
        c75v17.enemyCacheOverride = c75v16
        c75v18 = table.insert
        c75v18(c75v1, c75v17)
      end
    end
    do return c75v1 end
  end
  vT[59] = function()
    local c76v0
    c76v0 = vT[56]
    do return c76v0() end
  end
  IsInGamePlay = vT[59]
  vT[59] = function()
    local c77v0, c77v1, c77v2
    local p6 = 0
    if p6 == 0 then
      c77v1 = gGameRules
      c77v0 = IsNull
      c77v0 = c77v0(c77v1)
      if c77v0 then
        p6 = 5
      else
        p6 = 1
      end
    end
    if p6 == 1 then
      c77v0 = gGameRules
      c77v2 = gLotusGameRulesType
      c77v0 = c77v0:IsA(c77v2)
      if c77v0 then
        p6 = 4
      else
        p6 = 2
      end
    end
    if p6 == 2 then
      c77v0 = gGameRules
      c77v2 = gLotusDojoGameRulesType
      c77v0 = c77v0:IsA(c77v2)
      if c77v0 then
        p6 = 4
      else
        p6 = 3
      end
    end
    if p6 == 3 then
      c77v0 = gGameRules
      c77v2 = gLotusBasePvpGameRulesType
      c77v0 = c77v0:IsA(c77v2)
      if not c77v0 then
        p6 = 5
      else
        p6 = 4
      end
    end
    if p6 == 4 then
      c77v0 = true
      do return c77v0 end
    end
    if p6 == 5 then
      c77v0 = false
      do return c77v0 end
    end
  end
  vT[60] = function()
    local c78v0
    c78v0 = vT[59]
    do return c78v0() end
  end
  IsInMissionOrDojo = vT[60]
  vT[60] = function()
    local c79v0, c79v1, c79v2
    local p9 = 0
    if p9 == 0 then
      c79v1 = gGameRules
      c79v0 = IsNull
      c79v0 = c79v0(c79v1)
      if c79v0 then
        p9 = 6
      else
        p9 = 1
      end
    end
    if p9 == 1 then
      c79v0 = gGameRules
      c79v2 = gLotusPhotoBoothGameRulesType
      c79v0 = c79v0:IsA(c79v2)
      if not c79v0 then
        p9 = 3
      else
        p9 = 2
      end
    end
    if p9 == 2 then
      c79v0 = false
      do return c79v0 end
    end
    if p9 == 3 then
      c79v0 = gGameRules
      c79v2 = gLotusGameRulesType
      c79v0 = c79v0:IsA(c79v2)
      if c79v0 then
        p9 = 5
      else
        p9 = 4
      end
    end
    if p9 == 4 then
      c79v0 = gGameRules
      c79v2 = gLotusBasePvpGameRulesType
      c79v0 = c79v0:IsA(c79v2)
      if not c79v0 then
        p9 = 6
      else
        p9 = 5
      end
    end
    if p9 == 5 then
      c79v0 = true
      do return c79v0 end
    end
    if p9 == 6 then
      c79v0 = false
      do return c79v0 end
    end
  end
  vT[61] = function()
    local c80v0
    c80v0 = vT[60]
    do return c80v0() end
  end
  IsInMission = vT[61]
  vT[61] = function()
    local c81v0, c81v1, c81v2, c81v3, c81v4, c81v5, c81v6
    c81v0 = WeakResource
    c81v1 = "/Lotus/Types/Keys/NewWarQuest/NewWarQuestKeyChain"
    c81v0 = c81v0(c81v1)
    c81v1 = vT[27]
    c81v2 = gGameData
    c81v1, c81v2 = c81v1(c81v2)
    c81v3 = nil
    c81v5 = gGameRules
    c81v4 = IsNull
    c81v4 = c81v4(c81v5)
    if not c81v4 then
      c81v4 = vT[60]
      c81v4 = c81v4()
      if c81v4 then
        c81v4 = gGameRules
        c81v4 = c81v4:GetMission()
        c81v3 = c81v4.keyChainName
      end
    end
    c81v4 = false
    if c81v4 then
      c81v4 = false
      c81v5 = 13
      if c81v2 <= c81v5 then
        c81v5 = false
        c81v6 = 5
        if c81v2 < c81v6 then
          c81v5 = IsNull
          c81v5 = c81v5(c81v3)
        end
        c81v4 = not c81v5
      end
    end
    do return c81v4 end
  end
  IsInNewWarAltCharacterMission = vT[61]
  vT[61] = function()
    local c82v0
    c82v0 = vT[57]
    do return c82v0() end
  end
  GetStarChart = vT[61]
  vT[61] = function(c83v0)
    local c83v1
    c83v1 = vT[58]
    do return c83v1(c83v0) end
  end
  GetStarChartNodes = vT[61]
  vT[61] = function()
    local c84v0, c84v1, c84v2
    c84v2 = gGameRules
    c84v1 = IsNull
    c84v1 = c84v1(c84v2)
    c84v0 = not c84v1
    if c84v0 then
      c84v0 = gGameRules
      c84v2 = gLotusHubGameRulesType
      c84v0 = c84v0:IsA(c84v2)
    end
    do return c84v0 end
  end
  vT[62] = function()
    local c85v0
    c85v0 = vT[61]
    do return c85v0() end
  end
  IsInHub = vT[62]
  vT[62] = function(c86v0)
    local c86v1, c86v2
    c86v2 = REGION_ID_DOJO
    if c86v0 ~= c86v2 then
      c86v1 = false
    else
      c86v1 = true
    end
    do return c86v1 end
  end
  vT[63] = function(c87v0)
    local c87v1
    c87v1 = vT[62]
    do return c87v1(c87v0) end
  end
  RegionIsAKey = vT[63]
  vT[63] = function(c88v0)
    local c88v1, c88v2
    c88v1 = false
    c88v2 = REGION_ID_VOID
    if c88v0 ~= c88v2 then
      c88v1 = false
      c88v2 = REGION_ID_DOJO
      if c88v0 ~= c88v2 then
        c88v1 = false
        c88v2 = REGION_ID_DARK_SECTOR
        if c88v0 ~= c88v2 then
          c88v1 = false
          c88v2 = REGION_ID_DEEP_SPACE
          if c88v0 ~= c88v2 then
            c88v1 = false
            c88v2 = REGION_ID_VANIA
            if c88v0 ~= c88v2 then
              c88v2 = REGION_ID_TAU
              if c88v0 == c88v2 then
                c88v1 = false
              else
                c88v1 = true
              end
            end
          end
        end
      end
    end
    do return c88v1 end
  end
  ResourceDronesEnabledForRegion = vT[63]
  vT[63] = function(c89v0, c89v1, c89v2)
    local c89v3, c89v4, c89v5, c89v6, c89v7, c89v8, c89v9, c89v10, c89v11, c89v12, c89v13, c89v14, c89v15, c89v16, c89v17, c89v18, c89v19, c89v20, c89v21, c89v22, c89v23, c89v24, c89v25, c89v26, c89v27, c89v28, c89v29
    if not c89v1 then
      c89v3 = vT[57]
      c89v1 = c89v3()
    end
    c89v3 = IsNull
    c89v3 = c89v3(c89v1)
    if ((c89v3 or c89v0 == nil) or c89v0 == "") then
      c89v3 = nil
      c89v4 = 0
      c89v5 = 0
      do return c89v3, c89v4, c89v5 end
    end
    c89v3 = 0
    c89v4 = 0
    c89v5 = string.find
    c89v7 = KEY_TAG
    c89v5 = c89v5(c89v0, c89v7)
    if c89v5 ~= nil then
      c89v3 = KEY_FLAG
      c89v6 = _T.gSelectedRegionId
      if c89v6 ~= nil then
        c89v6 = _T.gSelectedRegionId
        c89v7 = 0
        if c89v7 < c89v6 then
          c89v4 = _T.gSelectedRegionId
        end
      end
      c89v6 = vT[62]
      c89v6 = c89v6(c89v4)
      if not c89v6 then
        c89v6 = Resource
        c89v9 = 1
        c89v10 = c89v5 - 1
        c89v7 = string.sub
        c89v7 = c89v7(c89v0, c89v9, c89v10)
        c89v6 = c89v6(c89v7)
        c89v7 = IsNull
        c89v7 = c89v7(c89v6)
        if not c89v7 then
          c89v7 = tostring
          c89v7 = c89v7(c89v6:GetNode())
          if c89v7 ~= "" then
            c89v0 = c89v7
          end
        end
      end
    end
    c89v6 = string.find
    c89v8 = ALERT_TAG
    c89v6 = c89v6(c89v0, c89v8)
    if c89v6 ~= nil then
      c89v9 = 1
      c89v10 = c89v6 - 1
      c89v7 = string.sub
      c89v0 = c89v7(c89v0, c89v9, c89v10)
      c89v3 = ALERT_FLAG
    end
    c89v7 = string.find
    c89v9 = NIGHTMARE_TAG
    c89v7 = c89v7(c89v0, c89v9)
    if c89v7 ~= nil then
      c89v10 = 1
      c89v11 = c89v7 - 1
      c89v8 = string.sub
      c89v0 = c89v8(c89v0, c89v10, c89v11)
      c89v3 = NIGHTMARE_FLAG
    end
    c89v8 = string.find
    c89v10 = EVENT_TAG
    c89v8 = c89v8(c89v0, c89v10)
    if c89v8 ~= nil then
      c89v11 = 1
      c89v12 = c89v8 - 1
      c89v9 = string.sub
      c89v0 = c89v9(c89v0, c89v11, c89v12)
      c89v3 = EVENT_FLAG
    end
    c89v9 = string.find
    c89v11 = PVP_TAG
    c89v9 = c89v9(c89v0, c89v11)
    if c89v9 ~= nil then
      c89v12 = 1
      c89v13 = c89v9 - 1
      c89v10 = string.sub
      c89v0 = c89v10(c89v0, c89v12, c89v13)
      c89v3 = PVP_FLAG
    end
    c89v10 = string.find
    c89v12 = INVASION_ATTACKER_TAG
    c89v10 = c89v10(c89v0, c89v12)
    if c89v10 ~= nil then
      c89v13 = 1
      c89v14 = c89v10 - 1
      c89v11 = string.sub
      c89v0 = c89v11(c89v0, c89v13, c89v14)
      c89v3 = INVASION_ATTACKER_FLAG
    end
    c89v11 = string.find
    c89v13 = INVASION_DEFENDER_TAG
    c89v11 = c89v11(c89v0, c89v13)
    if c89v11 ~= nil then
      c89v14 = 1
      c89v15 = c89v11 - 1
      c89v12 = string.sub
      c89v0 = c89v12(c89v0, c89v14, c89v15)
      c89v3 = INVASION_DEFENDER_FLAG
    end
    c89v12 = string.find
    c89v14 = SYNDICATE_MISSION_TAG
    c89v12 = c89v12(c89v0, c89v14)
    if c89v12 ~= nil then
      c89v15 = 1
      c89v16 = c89v12 - 1
      c89v13 = string.sub
      c89v0 = c89v13(c89v0, c89v15, c89v16)
      c89v3 = SYNDICATE_MISSION_FLAG
    end
    c89v13 = string.find
    c89v15 = SORTIE_MISSION_TAG
    c89v13 = c89v13(c89v0, c89v15)
    if c89v13 ~= nil then
      c89v16 = 1
      c89v17 = c89v13 - 1
      c89v14 = string.sub
      c89v0 = c89v14(c89v0, c89v16, c89v17)
      c89v3 = SORTIE_MISSION_FLAG
    end
    c89v14 = string.find
    c89v16 = LITE_SORTIE_MISSION_TAG
    c89v14 = c89v14(c89v0, c89v16)
    if c89v14 ~= nil then
      c89v17 = 1
      c89v18 = c89v14 - 1
      c89v15 = string.sub
      c89v0 = c89v15(c89v0, c89v17, c89v18)
      c89v3 = LITE_SORTIE_MISSION_FLAG
    end
    c89v15 = string.find
    c89v17 = HUB_TAG
    c89v15 = c89v15(c89v0, c89v17)
    if c89v15 ~= nil then
      c89v18 = 1
      c89v19 = c89v15 - 1
      c89v16 = string.sub
      c89v0 = c89v16(c89v0, c89v18, c89v19)
      c89v3 = HUB_FLAG
    end
    c89v16 = string.find
    c89v18 = ACTIVE_MISSION_TAG
    c89v16 = c89v16(c89v0, c89v18)
    if c89v16 ~= nil then
      c89v19 = 1
      c89v20 = c89v16 - 1
      c89v17 = string.sub
      c89v0 = c89v17(c89v0, c89v19, c89v20)
      c89v3 = ACTIVE_MISSION_FLAG
    end
    c89v17 = string.find
    c89v19 = KUVA_TOWER_MISSION_TAG
    c89v17 = c89v17(c89v0, c89v19)
    if c89v17 ~= nil then
      c89v20 = 1
      c89v21 = c89v17 - 1
      c89v18 = string.sub
      c89v0 = c89v18(c89v0, c89v20, c89v21)
      c89v3 = KUVA_TOWER_MISSION_FLAG
    end
    c89v18 = string.find
    c89v20 = NEMESIS_MISSION_TAG
    c89v18 = c89v18(c89v0, c89v20)
    if c89v18 ~= nil then
      c89v21 = 1
      c89v22 = c89v18 - 1
      c89v19 = string.sub
      c89v0 = c89v19(c89v0, c89v21, c89v22)
      c89v3 = NEMESIS_MISSION_FLAG
    end
    c89v19 = string.find
    c89v21 = ELITE_ALERT_TAG
    c89v19 = c89v19(c89v0, c89v21)
    if c89v19 ~= nil then
      c89v22 = 1
      c89v23 = c89v19 - 1
      c89v20 = string.sub
      c89v0 = c89v20(c89v0, c89v22, c89v23)
      c89v3 = ELITE_ALERT_FLAG
    end
    c89v20 = string.find
    c89v21 = string.lower
    c89v21 = c89v21(c89v0)
    c89v22 = "junction"
    c89v20 = c89v20(c89v21, c89v22)
    if c89v20 ~= nil then
      c89v23 = 1
      c89v24 = c89v20 - 1
      c89v21 = string.sub
      c89v0 = c89v21(c89v0, c89v23, c89v24)
      c89v3 = JUNCTION_FLAG
    end
    c89v21 = string.find
    c89v23 = HARD_DAILY_TAG
    c89v21 = c89v21(c89v0, c89v23)
    if c89v21 ~= nil then
      c89v24 = 1
      c89v25 = c89v21 - 1
      c89v22 = string.sub
      c89v0 = c89v22(c89v0, c89v24, c89v25)
      c89v3 = HARD_DAILY_FLAG
    else
      c89v22 = string.find
      c89v24 = HARD_EVENT_TAG
      c89v22 = c89v22(c89v0, c89v24)
      if c89v22 ~= nil then
        c89v25 = 1
        c89v26 = c89v22 - 1
        c89v23 = string.sub
        c89v0 = c89v23(c89v0, c89v25, c89v26)
        c89v3 = HARD_EVENT_FLAG
      end
    end
    c89v22 = string.find
    c89v24 = VOID_STORM_TAG
    c89v22 = c89v22(c89v0, c89v24)
    if c89v22 ~= nil then
      c89v3 = VOID_STORM_FLAG
      c89v23 = string.find
      c89v25 = HARD_MODE_TAG
      c89v23 = c89v23(c89v0, c89v25)
      if c89v23 ~= nil then
        c89v3 = c89v3 + 5000000
      end
      c89v25 = 1
      c89v26 = c89v22 - 1
      c89v23 = string.sub
      c89v0 = c89v23(c89v0, c89v25, c89v26)
    end
    c89v23 = string.find
    c89v25 = LAB_CONQUEST_MISSION_TAG
    c89v23 = c89v23(c89v0, c89v25)
    if c89v23 ~= nil then
      c89v26 = 1
      c89v27 = c89v23 - 1
      c89v24 = string.sub
      c89v0 = c89v24(c89v0, c89v26, c89v27)
      c89v3 = LAB_CONQUEST_MISSION_FLAG
    end
    c89v24 = string.find
    c89v26 = HEX_CONQUEST_MISSION_TAG
    c89v24 = c89v24(c89v0, c89v26)
    if c89v24 ~= nil then
      c89v27 = 1
      c89v28 = c89v24 - 1
      c89v25 = string.sub
      c89v0 = c89v25(c89v0, c89v27, c89v28)
      c89v3 = HEX_CONQUEST_MISSION_FLAG
    end
    if c89v3 == 0 then
      c89v25 = string.find
      c89v27 = HARD_MODE_TAG
      c89v25 = c89v25(c89v0, c89v27)
      if c89v25 ~= nil then
        c89v28 = 1
        c89v29 = c89v25 - 1
        c89v26 = string.sub
        c89v0 = c89v26(c89v0, c89v28, c89v29)
        c89v3 = HARD_MODE_FLAG
      end
    end
    c89v25 = PVPVE_VS_AI_NODE_TAG
    if c89v0 == c89v25 then
      c89v25 = PVPVE_VS_AI_MISSION_FLAG
      c89v3 = c89v3 + c89v25
    else
      c89v25 = PVPVE_VS_TENNO_NODE_TAG
      if c89v0 == c89v25 then
        c89v25 = PVPVE_VS_TENNO_MISSION_FLAG
        c89v3 = c89v3 + c89v25
      end
    end
    c89v25 = IsNull
    c89v25 = c89v25(c89v2)
    if c89v25 then
      c89v27 = Symbol
      c89v2 = c89v1:Name__19dfa8ea(c89v27(c89v0))
    end
    do return c89v2, c89v3, c89v4 end
  end
  vT[64] = function(c90v0, c90v1, c90v2)
    local c90v3
    c90v3 = vT[63]
    c90v3 = c90v3(c90v0, c90v1, c90v2)
    do return c90v3 end
  end
  GetNodeInfo = vT[64]
  vT[64] = function(c91v0, c91v1, c91v2)
    local c91v3, c91v4, c91v5, c91v6, c91v7, c91v8, c91v9, c91v10, c91v11, c91v12, c91v13, c91v14, c91v15, c91v16
    if not c91v1 then
      c91v3 = vT[57]
      c91v1 = c91v3()
    end
    if c91v0 == "Simulacrum" then
      c91v3 = REGION_ID_SIMULACRUM
      do return c91v3 end
    end
    c91v3 = vT[63]
    c91v3, c91v4, c91v5 = c91v3(c91v0, c91v1, c91v2)
    c91v6 = string.find
    c91v8 = TAG_SEPERATOR
    c91v6 = c91v6(c91v0, c91v8)
    c91v7 = nil
    if c91v6 ~= nil then
      c91v10 = 1
      c91v11 = c91v6 - 1
      c91v8 = string.sub
      c91v7 = c91v8(c91v0, c91v10, c91v11)
    else
      c91v7 = c91v0
    end
    c91v8 = IsNull
    c91v8 = c91v8(c91v3)
    if c91v1 then
      c91v9 = c91v3.region
      c91v8 = c91v9 + 1
      c91v10 = vT[17]
      c91v10 = c91v10.Ternary
      c91v12 = 0
      if c91v5 <= c91v12 then
        c91v11 = false
      else
        c91v11 = true
      end
      c91v10 = c91v10(c91v11, c91v5, c91v8)
      c91v9 = c91v10 * 1000
      if c91v12 < c91v5 then
        c91v10 = 0
        c91v11 = 1
        c91v14 = string.len
        c91v14 = c91v14(c91v7)
        c91v12 = 1
        c91v13 = -1
        for c91v14 = c91v14, c91v12, c91v13 do
          c91v16 = string.sub
          c91v16 = c91v16(c91v7, c91v14, c91v14)
          c91v15 = tonumber
          c91v15 = c91v15(c91v16)
          if c91v15 == nil then break end
          c91v16 = c91v15 * c91v11
          c91v10 = c91v10 + c91v16
          c91v11 = c91v11 * 10
        end
        local p49 = 17
        if p49 == 17 then
          if c91v10 ~= 0 then
            p49 = 20
          else
            p49 = 18
          end
        end
        if p49 == 18 then
          c91v12 = KEY_FLAG
          if c91v4 ~= c91v12 then
            p49 = 20
          else
            p49 = 19
          end
        end
        if p49 == 19 then
          c91v10 = c91v1:Name__14344212(c91v7)
          p49 = 20
        end
        if p49 == 20 then
          if c91v8 ~= 16 then
            p49 = 25
          else
            p49 = 21
          end
        end
        if p49 == 21 then
          if (not (c91v10 == 10) and c91v10 ~= 11) then
            p49 = 25
          else
            p49 = 23
          end
        end
        if p49 == 23 then
          c91v12 = string.find
          c91v14 = "ClanNode"
          c91v12 = c91v12(c91v7, c91v14)
          if not c91v12 then
            p49 = 25
          else
            p49 = 24
          end
        end
        if p49 == 24 then
          c91v10 = c91v10 + 80
          p49 = 29
        end
        if p49 == 25 then
          if (c91v8 ~= 2 or c91v10 ~= 0) then
            p49 = 29
          else
            p49 = 27
          end
        end
        if p49 == 27 then
          c91v12 = string.find
          c91v14 = "NokkoColony"
          c91v12 = c91v12(c91v7, c91v14)
          if not c91v12 then
            p49 = 29
          else
            p49 = 28
          end
        end
        if p49 == 28 then
          c91v10 = c91v10 + 80
          p49 = 29
        end
        if p49 == 29 then
          c91v13 = c91v9 + c91v10
          c91v12 = c91v13 + c91v4
          do return c91v12 end
        end
      end
    end
    local p48 = 30
    if p48 == 30 then
      c91v8 = _T.gSelectedRegionId
      if c91v8 == nil then
        p48 = 32
      else
        p48 = 31
      end
    end
    if p48 == 31 then
      c91v9 = 0
      if c91v9 < c91v8 then
        p48 = 33
      else
        p48 = 32
      end
    end
    if p48 == 32 then
      c91v8 = 1
      p48 = 33
    end
    if p48 == 33 then
      c91v9 = c91v8 * 1000
      do return c91v9 end
    end
  end
  vT[65] = function(c92v0, c92v1, c92v2)
    local c92v3
    c92v3 = vT[64]
    do return c92v3(c92v0, c92v1, c92v2) end
  end
  BuildGameModeIdForNode = vT[65]
  vT[65] = function()
    local c93v0
    c93v0 = REGION_ID_SIMULACRUM
    do return c93v0 end
  end
  BuildGameModeIdForSimulacrum = vT[65]
  vT[65] = function(c94v0)
    local c94v1, c94v2
    c94v2 = REGION_ID_SIMULACRUM
    if c94v0 ~= c94v2 then
      c94v1 = false
    else
      c94v1 = true
    end
    do return c94v1 end
  end
  IsSimulacrumGameModeId = vT[65]
  vT[65] = function()
    local c95v0
    c95v0 = REGION_ID_PHOTOBOOTH
    do return c95v0 end
  end
  BuildGameModeIdForPhotobooth = vT[65]
  vT[65] = function(c96v0)
    local c96v1, c96v2
    c96v2 = REGION_ID_PHOTOBOOTH
    if c96v0 ~= c96v2 then
      c96v1 = false
    else
      c96v1 = true
    end
    do return c96v1 end
  end
  IsPhotoboothGameModeId = vT[65]
  vT[65] = function(c97v0)
    local c97v1, c97v2, c97v3
    c97v1 = tonumber
    c97v0 = c97v1(c97v0)
    c97v3 = REGION_ID_PVP
    c97v2 = c97v3 * 1000
    c97v1 = c97v2 + c97v0
    do return c97v1 end
  end
  BuildGameModeIdForPVP = vT[65]
  vT[65] = function()
    local c98v0, c98v1
    c98v1 = REGION_ID_CLAN_DOJO
    c98v0 = c98v1 * 1000
    do return c98v0 end
  end
  BuildGameModeIdForClanDojo = vT[65]
  vT[65] = function(c99v0)
    local c99v1, c99v2, c99v3
    c99v3 = c99v0 / 1000
    c99v2 = math.floor
    c99v2 = c99v2(c99v3)
    c99v3 = REGION_ID_CLAN_DOJO
    if c99v2 ~= c99v3 then
      c99v1 = false
    else
      c99v1 = true
    end
    do return c99v1 end
  end
  IsClanDojoGameModeId = vT[65]
  vT[65] = function()
    local c100v0, c100v1
    c100v1 = REGION_ID_DOJO_DUEL
    c100v0 = c100v1 * 1000
    do return c100v0 end
  end
  BuildGameModeIdForDojoDuel = vT[65]
  vT[65] = function(c101v0)
    local c101v1, c101v2, c101v3
    c101v3 = c101v0 / 1000
    c101v2 = math.floor
    c101v2 = c101v2(c101v3)
    c101v3 = REGION_ID_DOJO_DUEL
    if c101v2 ~= c101v3 then
      c101v1 = false
    else
      c101v1 = true
    end
    do return c101v1 end
  end
  IsDojoDuelGameModeId = vT[65]
  vT[65] = function(c102v0)
    local c102v1, c102v2, c102v3, c102v4, c102v5
    c102v3 = c102v0 / 100000
    c102v2 = math.floor
    c102v2 = c102v2(c102v3)
    c102v5 = ALERT_FLAG
    c102v4 = c102v5 / 100000
    c102v3 = math.floor
    c102v3 = c102v3(c102v4)
    if c102v2 ~= c102v3 then
      c102v1 = false
    else
      c102v1 = true
    end
    do return c102v1 end
  end
  vT[66] = function(c103v0)
    local c103v1
    c103v1 = vT[65]
    c103v1 = c103v1(c103v0)
    do return c103v1 end
  end
  IsAlertGameModeId = vT[66]
  vT[66] = function(c104v0)
    local c104v1, c104v2, c104v3, c104v4, c104v5
    c104v3 = c104v0 / 100000
    c104v2 = math.floor
    c104v2 = c104v2(c104v3)
    c104v5 = NIGHTMARE_FLAG
    c104v4 = c104v5 / 100000
    c104v3 = math.floor
    c104v3 = c104v3(c104v4)
    if c104v2 ~= c104v3 then
      c104v1 = false
    else
      c104v1 = true
    end
    do return c104v1 end
  end
  vT[67] = function(c105v0)
    local c105v1
    c105v1 = vT[66]
    c105v1 = c105v1(c105v0)
    do return c105v1 end
  end
  IsNightmareGameModeId = vT[67]
  vT[67] = function(c106v0)
    local c106v1, c106v2, c106v3, c106v4, c106v5
    c106v3 = c106v0 / 100000
    c106v2 = math.floor
    c106v2 = c106v2(c106v3)
    c106v5 = EVENT_FLAG
    c106v4 = c106v5 / 100000
    c106v3 = math.floor
    c106v3 = c106v3(c106v4)
    if c106v2 ~= c106v3 then
      c106v1 = false
    else
      c106v1 = true
    end
    do return c106v1 end
  end
  vT[68] = function(c107v0)
    local c107v1
    c107v1 = vT[67]
    c107v1 = c107v1(c107v0)
    do return c107v1 end
  end
  IsEventGameModeId = vT[68]
  vT[68] = function(c108v0)
    local c108v1, c108v2, c108v3, c108v4, c108v5
    c108v3 = c108v0 / 100000
    c108v2 = math.floor
    c108v2 = c108v2(c108v3)
    c108v5 = HARD_EVENT_FLAG
    c108v4 = c108v5 / 100000
    c108v3 = math.floor
    c108v3 = c108v3(c108v4)
    if c108v2 ~= c108v3 then
      c108v1 = false
    else
      c108v1 = true
    end
    do return c108v1 end
  end
  vT[69] = function(c109v0)
    local c109v1
    c109v1 = vT[68]
    c109v1 = c109v1(c109v0)
    do return c109v1 end
  end
  IsHardEventGameModeId = vT[69]
  vT[69] = function(c110v0)
    local c110v1, c110v2, c110v3, c110v4, c110v5
    c110v3 = c110v0 / 100000
    c110v2 = math.floor
    c110v2 = c110v2(c110v3)
    c110v5 = INVASION_ATTACKER_FLAG
    c110v4 = c110v5 / 100000
    c110v3 = math.floor
    c110v3 = c110v3(c110v4)
    if c110v2 ~= c110v3 then
      c110v1 = false
    else
      c110v1 = true
    end
    do return c110v1 end
  end
  vT[70] = function(c111v0)
    local c111v1, c111v2, c111v3, c111v4, c111v5
    c111v3 = c111v0 / 100000
    c111v2 = math.floor
    c111v2 = c111v2(c111v3)
    c111v5 = INVASION_DEFENDER_FLAG
    c111v4 = c111v5 / 100000
    c111v3 = math.floor
    c111v3 = c111v3(c111v4)
    if c111v2 ~= c111v3 then
      c111v1 = false
    else
      c111v1 = true
    end
    do return c111v1 end
  end
  vT[71] = function(c112v0)
    local c112v1, c112v2, c112v3, c112v4, c112v5
    c112v3 = c112v0 / 100000
    c112v2 = math.floor
    c112v2 = c112v2(c112v3)
    c112v5 = PVP_FLAG
    c112v4 = c112v5 / 100000
    c112v3 = math.floor
    c112v3 = c112v3(c112v4)
    if c112v2 ~= c112v3 then
      c112v1 = false
    else
      c112v1 = true
    end
    do return c112v1 end
  end
  vT[72] = function(c113v0)
    local c113v1
    c113v1 = vT[71]
    c113v1 = c113v1(c113v0)
    do return c113v1 end
  end
  IsPvpGameModeId = vT[72]
  vT[72] = function(c114v0)
    local c114v1, c114v2, c114v3, c114v4, c114v5
    c114v2 = c114v0 / 100000
    c114v1 = math.floor
    c114v1 = c114v1(c114v2)
    c114v5 = SYNDICATE_MISSION_FLAG
    c114v4 = c114v5 / 100000
    c114v3 = math.floor
    c114v3 = c114v3(c114v4)
    if c114v1 ~= c114v3 then
      c114v2 = false
    else
      c114v2 = true
    end
    do return c114v2 end
  end
  vT[73] = function(c115v0)
    local c115v1
    c115v1 = vT[72]
    c115v1 = c115v1(c115v0)
    do return c115v1 end
  end
  IsSyndicateGameModeId = vT[73]
  vT[73] = function(c116v0)
    local c116v1, c116v2, c116v3, c116v4, c116v5
    c116v2 = c116v0 / 100000
    c116v1 = math.floor
    c116v1 = c116v1(c116v2)
    c116v5 = SORTIE_MISSION_FLAG
    c116v4 = c116v5 / 100000
    c116v3 = math.floor
    c116v3 = c116v3(c116v4)
    if c116v1 ~= c116v3 then
      c116v2 = false
    else
      c116v2 = true
    end
    do return c116v2 end
  end
  vT[74] = function(c117v0)
    local c117v1
    c117v1 = vT[73]
    do return c117v1(c117v0) end
  end
  IsSortieGameModeId = vT[74]
  vT[74] = function(c118v0)
    local c118v1, c118v2, c118v3, c118v4, c118v5
    c118v2 = c118v0 / 100000
    c118v1 = math.floor
    c118v1 = c118v1(c118v2)
    c118v5 = NEMESIS_MISSION_FLAG
    c118v4 = c118v5 / 100000
    c118v3 = math.floor
    c118v3 = c118v3(c118v4)
    if c118v1 ~= c118v3 then
      c118v2 = false
    else
      c118v2 = true
    end
    do return c118v2 end
  end
  vT[75] = function(c119v0)
    local c119v1
    c119v1 = vT[73]
    do return c119v1(c119v0) end
  end
  IsNemesisGameModeId = vT[75]
  vT[75] = function(c120v0)
    local c120v1, c120v2, c120v3, c120v4, c120v5
    c120v2 = c120v0 / 100000
    c120v1 = math.floor
    c120v1 = c120v1(c120v2)
    c120v5 = LITE_SORTIE_MISSION_FLAG
    c120v4 = c120v5 / 100000
    c120v3 = math.floor
    c120v3 = c120v3(c120v4)
    if c120v1 ~= c120v3 then
      c120v2 = false
    else
      c120v2 = true
    end
    do return c120v2 end
  end
  vT[76] = function(c121v0)
    local c121v1, c121v2, c121v3, c121v4, c121v5
    c121v2 = c121v0 / 100000
    c121v1 = math.floor
    c121v1 = c121v1(c121v2)
    c121v5 = HUB_FLAG
    c121v4 = c121v5 / 100000
    c121v3 = math.floor
    c121v3 = c121v3(c121v4)
    if c121v1 ~= c121v3 then
      c121v2 = false
    else
      c121v2 = true
    end
    do return c121v2 end
  end
  IsHubGameModeId = vT[76]
  vT[76] = function(c122v0)
    local c122v1, c122v2, c122v3, c122v4, c122v5
    c122v2 = c122v0 / 100000
    c122v1 = math.floor
    c122v1 = c122v1(c122v2)
    c122v5 = ACTIVE_MISSION_FLAG
    c122v4 = c122v5 / 100000
    c122v3 = math.floor
    c122v3 = c122v3(c122v4)
    if c122v1 ~= c122v3 then
      c122v2 = false
    else
      c122v2 = true
    end
    do return c122v2 end
  end
  vT[77] = function(c123v0)
    local c123v1, c123v2, c123v3, c123v4, c123v5
    c123v2 = c123v0 / 100000
    c123v1 = math.floor
    c123v1 = c123v1(c123v2)
    c123v5 = KUVA_TOWER_MISSION_FLAG
    c123v4 = c123v5 / 100000
    c123v3 = math.floor
    c123v3 = c123v3(c123v4)
    if c123v1 ~= c123v3 then
      c123v2 = false
    else
      c123v2 = true
    end
    do return c123v2 end
  end
  vT[78] = function(c124v0)
    local c124v1, c124v2, c124v3, c124v4, c124v5
    c124v2 = c124v0 / 100000
    c124v1 = math.floor
    c124v1 = c124v1(c124v2)
    c124v5 = JUNCTION_FLAG
    c124v4 = c124v5 / 100000
    c124v3 = math.floor
    c124v3 = c124v3(c124v4)
    if c124v1 ~= c124v3 then
      c124v2 = false
    else
      c124v2 = true
    end
    do return c124v2 end
  end
  IsJunctionGameModeId = vT[78]
  vT[78] = function(c125v0)
    local c125v1, c125v2, c125v3, c125v4
    c125v4 = c125v0 / 100
    c125v3 = math.floor
    c125v3 = c125v3(c125v4)
    c125v2 = c125v3 % 10
    if c125v2 ~= 5 then
      c125v1 = false
    else
      c125v1 = true
    end
    do return c125v1 end
  end
  vT[79] = function(c126v0)
    local c126v1, c126v2, c126v3, c126v4, c126v5
    c126v2 = c126v0 / 100000
    c126v1 = math.floor
    c126v1 = c126v1(c126v2)
    c126v5 = KEY_FLAG
    c126v4 = c126v5 / 100000
    c126v3 = math.floor
    c126v3 = c126v3(c126v4)
    if c126v1 ~= c126v3 then
      c126v2 = false
    else
      c126v2 = true
    end
    do return c126v2 end
  end
  IsKeyGameModeId = vT[79]
  vT[79] = function(c127v0)
    local c127v1, c127v2, c127v3, c127v4, c127v5
    c127v2 = c127v0 / 100000
    c127v1 = math.floor
    c127v1 = c127v1(c127v2)
    c127v5 = HARD_MODE_FLAG
    c127v4 = c127v5 / 100000
    c127v3 = math.floor
    c127v3 = c127v3(c127v4)
    if c127v1 ~= c127v3 then
      c127v2 = false
    else
      c127v2 = true
    end
    do return c127v2 end
  end
  IsHardGameModeId = vT[79]
  vT[79] = function()
    local c128v0, c128v1, c128v2
    c128v1 = gGameRules
    c128v0 = IsNull
    c128v0 = c128v0(c128v1)
    if not c128v0 then
      c128v0 = gGameRules
      c128v2 = gLotusGameRulesType
      c128v0 = c128v0:IsA(c128v2)
      if c128v0 then
        c128v0 = gGameRules
        c128v0 = c128v0:IsPlayingHardGameModeMission()
        do return c128v0 end
      end
    end
    c128v0 = false
    do return c128v0 end
  end
  IsPlayingHardGameModeMission = vT[79]
  vT[79] = function(c129v0)
    local c129v1, c129v2, c129v3, c129v4, c129v5
    c129v2 = c129v0 / 100000
    c129v1 = math.floor
    c129v1 = c129v1(c129v2)
    c129v5 = HARD_DAILY_FLAG
    c129v4 = c129v5 / 100000
    c129v3 = math.floor
    c129v3 = c129v3(c129v4)
    if c129v1 ~= c129v3 then
      c129v2 = false
    else
      c129v2 = true
    end
    do return c129v2 end
  end
  IsHardDailyGameModeId = vT[79]
  vT[79] = function(c130v0)
    local c130v1, c130v2, c130v3, c130v4, c130v5, c130v6, c130v7, c130v8, c130v9, c130v10, c130v11
    c130v1 = _T.CachedScenarioGameModeIds
    if not c130v1 then
      c130v1 = vT[57]
      c130v1 = c130v1()
      c130v2 = _T
      c130v4 = vT[64]
      c130v9 = SCENARIO_EVENT_HUB_TAG
      c130v8 = tostring
      c130v6 = c130v8(c130v9)
      c130v7 = HUB_TAG
      c130v5 = c130v6 .. c130v7
      c130v4 = c130v4(c130v5, c130v1)
      c130v5 = vT[64]
      c130v10 = SCENARIO_EVENT_GROUND_TAG
      c130v9 = tostring
      c130v7 = c130v9(c130v10)
      c130v8 = KEY_TAG
      c130v6 = c130v7 .. c130v8
      c130v5 = c130v5(c130v6, c130v1)
      c130v6 = vT[64]
      c130v11 = SCENARIO_EVENT_SPACE_TAG
      c130v10 = tostring
      c130v8 = c130v10(c130v11)
      c130v9 = KEY_TAG
      c130v7 = c130v8 .. c130v9
      c130v3 = {c130v4, c130v5, c130v6(c130v7, c130v1)}
      c130v2.CachedScenarioGameModeIds = c130v3
    end
    c130v1 = pairs
    c130v2 = _T.CachedScenarioGameModeIds
    c130v1, c130v2, c130v3 = c130v1(c130v2)
    for c130v4, c130v5 in c130v1, c130v2, c130v3 do
      if c130v0 == c130v5 then
        c130v6 = true
        do return c130v6 end
      end
    end
    c130v1 = false
    do return c130v1 end
  end
  IsScenarioGameModeId = vT[79]
  vT[79] = function(c131v0)
    local c131v1, c131v2, c131v3, c131v4, c131v5, c131v6
    c131v2 = c131v0 / 100000
    c131v1 = math.floor
    c131v1 = c131v1(c131v2)
    c131v2 = true
    c131v5 = VOID_STORM_FLAG
    c131v4 = c131v5 / 100000
    c131v3 = math.floor
    c131v3 = c131v3(c131v4)
    if c131v1 ~= c131v3 then
      c131v6 = VOID_STORM_FLAG
      c131v5 = c131v6 + 5000000
      c131v4 = c131v5 / 100000
      c131v3 = math.floor
      c131v3 = c131v3(c131v4)
      if c131v1 ~= c131v3 then
        c131v2 = false
      else
        c131v2 = true
      end
    end
    do return c131v2 end
  end
  vT[80] = function(c132v0)
    local c132v1, c132v2, c132v3, c132v4, c132v5
    c132v2 = c132v0 / 100000
    c132v1 = math.floor
    c132v1 = c132v1(c132v2)
    c132v5 = LAB_CONQUEST_MISSION_FLAG
    c132v4 = c132v5 / 100000
    c132v3 = math.floor
    c132v3 = c132v3(c132v4)
    if c132v1 ~= c132v3 then
      c132v2 = false
    else
      c132v2 = true
    end
    do return c132v2 end
  end
  vT[81] = function(c133v0)
    local c133v1, c133v2, c133v3, c133v4, c133v5
    c133v2 = c133v0 / 100000
    c133v1 = math.floor
    c133v1 = c133v1(c133v2)
    c133v5 = HEX_CONQUEST_MISSION_FLAG
    c133v4 = c133v5 / 100000
    c133v3 = math.floor
    c133v3 = c133v3(c133v4)
    if c133v1 ~= c133v3 then
      c133v2 = false
    else
      c133v2 = true
    end
    do return c133v2 end
  end
  vT[82] = function(c134v0)
    local c134v1, c134v2, c134v3, c134v4, c134v5
    c134v2 = c134v0 / 100000
    c134v1 = math.floor
    c134v1 = c134v1(c134v2)
    c134v5 = PVPVE_VS_TENNO_MISSION_HARD_FLAG
    c134v4 = c134v5 / 100000
    c134v3 = math.floor
    c134v3 = c134v3(c134v4)
    if c134v1 ~= c134v3 then
      c134v2 = false
    else
      c134v2 = true
    end
    do return c134v2 end
  end
  vT[83] = function(c135v0)
    local c135v1, c135v2, c135v3, c135v4, c135v5
    c135v2 = c135v0 / 100000
    c135v1 = math.floor
    c135v1 = c135v1(c135v2)
    c135v5 = PVPVE_VS_AI_MISSION_HARD_FLAG
    c135v4 = c135v5 / 100000
    c135v3 = math.floor
    c135v3 = c135v3(c135v4)
    if c135v1 ~= c135v3 then
      c135v2 = false
    else
      c135v2 = true
    end
    do return c135v2 end
  end
  vT[84] = function(c136v0)
    local c136v1, c136v2, c136v3, c136v4, c136v5
    c136v2 = c136v0 / 100000
    c136v1 = math.floor
    c136v1 = c136v1(c136v2)
    c136v2 = true
    c136v5 = PVPVE_VS_TENNO_MISSION_FLAG
    c136v4 = c136v5 / 100000
    c136v3 = math.floor
    c136v3 = c136v3(c136v4)
    if c136v1 ~= c136v3 then
      c136v2 = vT[82]
      c136v2 = c136v2(c136v0)
    end
    do return c136v2 end
  end
  IsPvPvEVsTennoGameModeId = vT[84]
  vT[84] = function(c137v0)
    local c137v1, c137v2, c137v3, c137v4, c137v5
    c137v2 = c137v0 / 100000
    c137v1 = math.floor
    c137v1 = c137v1(c137v2)
    c137v2 = true
    c137v5 = PVPVE_VS_AI_MISSION_FLAG
    c137v4 = c137v5 / 100000
    c137v3 = math.floor
    c137v3 = c137v3(c137v4)
    if c137v1 ~= c137v3 then
      c137v2 = vT[83]
      c137v2 = c137v2(c137v0)
    end
    do return c137v2 end
  end
  IsPvPvEVsAiGameModeId = vT[84]
  vT[84] = function(c138v0)
    local c138v1
    c138v1 = IsPvPvEVsAiGameModeId
    c138v1 = c138v1(c138v0)
    if not c138v1 then
      c138v1 = IsPvPvEVsTennoGameModeId
      c138v1 = c138v1(c138v0)
    end
    do return c138v1 end
  end
  IsPvPvEGameModeId = vT[84]
  vT[84] = function(c139v0)
    local c139v1
    c139v1 = vT[83]
    c139v1 = c139v1(c139v0)
    if not c139v1 then
      c139v1 = vT[82]
      c139v1 = c139v1(c139v0)
    end
    do return c139v1 end
  end
  IsPvPvEHardGameModeId = vT[84]
  vT[84] = function(c140v0)
    local c140v1, c140v2, c140v3, c140v4, c140v5
    c140v2 = c140v0 / 100000
    c140v1 = math.floor
    c140v1 = c140v1(c140v2)
    c140v5 = ELITE_ALERT_FLAG
    c140v4 = c140v5 / 100000
    c140v3 = math.floor
    c140v3 = c140v3(c140v4)
    if c140v1 ~= c140v3 then
      c140v2 = false
    else
      c140v2 = true
    end
    do return c140v2 end
  end
  IsEliteAlertGameModeId = vT[84]
  vT[84] = function(c141v0)
    local c141v1, c141v2, c141v3
    c141v3 = c141v0 / 1000
    c141v2 = math.floor
    c141v2 = c141v2(c141v3)
    c141v1 = c141v2 % 100
    do return c141v1 end
  end
  GetRegionFromGameModeId = vT[84]
  vT[84] = function(c142v0)
    local c142v1, c142v2, c142v3, c142v4
    c142v3 = tostring
    c142v3 = c142v3(c142v0)
    c142v4 = -3
    c142v2 = string.sub
    c142v2 = c142v2(c142v3, c142v4)
    c142v1 = tonumber
    c142v1 = c142v1(c142v2)
    do return c142v1 end
  end
  GetNodeFromGameModeId = vT[84]
  vT[84] = function(c143v0)
    local c143v1, c143v2, c143v3, c143v4, c143v5, c143v6, c143v8
    local p110 = 0
    if p110 == 0 then
      c143v3 = c143v0 / 1000
      c143v2 = math.floor
      c143v2 = c143v2(c143v3)
      c143v1 = c143v2 % 100
      c143v4 = tostring
      c143v4 = c143v4(c143v0)
      c143v5 = -3
      c143v3 = string.sub
      c143v3 = c143v3(c143v4, c143v5)
      c143v2 = tonumber
      c143v2 = c143v2(c143v3)
      c143v3 = vT[71]
      c143v3 = c143v3(c143v0)
      if not c143v3 then
        p110 = 2
      else
        p110 = 1
      end
    end
    if p110 == 1 then
      c143v4 = "PvpNode"
      c143v3 = c143v4 .. c143v2
      do return c143v3 end
    end
    if p110 == 2 then
      c143v3 = vT[67]
      c143v3 = c143v3(c143v0)
      if c143v3 then
        p110 = 4
      else
        p110 = 3
      end
    end
    if p110 == 3 then
      c143v3 = vT[68]
      c143v3 = c143v3(c143v0)
      if not c143v3 then
        p110 = 11
      else
        p110 = 4
      end
    end
    if p110 == 4 then
      c143v3 = _G
      c143v3 = c143v3.CachedGoalInfo
      if not c143v3 then
        p110 = 6
      else
        p110 = 5
      end
    end
    if p110 == 5 then
      c143v4 = _G
      c143v4 = c143v4.CachedGoalInfo
      c143v6 = "EventNode"
      c143v5 = c143v6 .. c143v2
      c143v3 = c143v4[c143v5]
      if c143v3 then
        p110 = 10
      else
        p110 = 6
      end
    end
    if p110 == 6 then
      c143v3 = _G
      c143v3 = c143v3.MergedGoalNodes
      if not c143v3 then
        p110 = 8
      else
        p110 = 7
      end
    end
    if p110 == 7 then
      c143v4 = _G
      c143v4 = c143v4.MergedGoalNodes
      c143v6 = "EventNode"
      c143v5 = c143v6 .. c143v2
      c143v3 = c143v4[c143v5]
      if c143v3 then
        p110 = 10
      else
        p110 = 8
      end
    end
    if p110 == 8 then
      c143v3 = _T.LockedGoalList
      if not c143v3 then
        p110 = 11
      else
        p110 = 9
      end
    end
    if p110 == 9 then
      c143v4 = _T.LockedGoalList
      c143v6 = "EventNode"
      c143v5 = c143v6 .. c143v2
      c143v3 = c143v4[c143v5]
      if not c143v3 then
        p110 = 11
      else
        p110 = 10
      end
    end
    if p110 == 10 then
      c143v4 = "EventNode"
      c143v3 = c143v4 .. c143v2
      do return c143v3 end
    end
    if p110 == 11 then
      c143v3 = vT[72]
      c143v3 = c143v3(c143v0)
      if not c143v3 then
        p110 = 13
      else
        p110 = 12
      end
    end
    if p110 == 12 then
      c143v4 = "SyndicateNode"
      c143v3 = c143v4 .. c143v2
      do return c143v3 end
    end
    if p110 == 13 then
      c143v3 = vT[73]
      c143v3 = c143v3(c143v0)
      if not c143v3 then
        p110 = 15
      else
        p110 = 14
      end
    end
    if p110 == 14 then
      c143v4 = "SortieNode"
      c143v3 = c143v4 .. c143v2
      do return c143v3 end
    end
    if p110 == 15 then
      c143v3 = IsHubGameModeId
      c143v3 = c143v3(c143v0)
      if not c143v3 then
        p110 = 43
      else
        p110 = 16
      end
    end
    if p110 == 16 then
      c143v5 = 1
      c143v3 = math.max
      c143v1 = c143v3(c143v1, c143v5)
      if c143v1 ~= 3 then
        p110 = 19
      else
        p110 = 17
      end
    end
    if p110 == 17 then
      c143v3 = c143v0 % 10
      if c143v3 ~= 2 then
        p110 = 19
      else
        p110 = 18
      end
    end
    if p110 == 18 then
      c143v3 = "TennoConHUB2"
      do return c143v3 end
    end
    if p110 == 19 then
      if c143v1 ~= 3 then
        p110 = 22
      else
        p110 = 20
      end
    end
    if p110 == 20 then
      c143v3 = c143v0 % 10
      if c143v3 ~= 3 then
        p110 = 22
      else
        p110 = 21
      end
    end
    if p110 == 21 then
      c143v3 = "IronwakeHUB3"
      do return c143v3 end
    end
    if p110 == 22 then
      if c143v1 ~= 3 then
        p110 = 25
      else
        p110 = 23
      end
    end
    if p110 == 23 then
      c143v3 = c143v0 % 10
      if c143v3 ~= 4 then
        p110 = 25
      else
        p110 = 24
      end
    end
    if p110 == 24 then
      c143v4 = CETUS_NODE_TAG
      c143v3 = tostring
      c143v3 = c143v3(c143v4)
      do return c143v3 end
    end
    if p110 == 25 then
      if c143v1 ~= 3 then
        p110 = 28
      else
        p110 = 26
      end
    end
    if p110 == 26 then
      c143v3 = c143v0 % 10
      if c143v3 ~= 5 then
        p110 = 28
      else
        p110 = 27
      end
    end
    if p110 == 27 then
      c143v4 = SCENARIO_EVENT_HUB_TAG
      c143v3 = tostring
      c143v3 = c143v3(c143v4)
      do return c143v3 end
    end
    if p110 == 28 then
      if c143v1 ~= 3 then
        p110 = 31
      else
        p110 = 29
      end
    end
    if p110 == 29 then
      c143v3 = c143v0 % 10
      if c143v3 ~= 6 then
        p110 = 31
      else
        p110 = 30
      end
    end
    if p110 == 30 then
      c143v3 = "TennoConBHUB6"
      do return c143v3 end
    end
    if p110 == 31 then
      if c143v1 ~= 3 then
        p110 = 34
      else
        p110 = 32
      end
    end
    if p110 == 32 then
      c143v3 = c143v0 % 10
      if c143v3 ~= 7 then
        p110 = 34
      else
        p110 = 33
      end
    end
    if p110 == 33 then
      c143v3 = "DevStreamHUB7"
      do return c143v3 end
    end
    if p110 == 34 then
      if c143v1 ~= 2 then
        p110 = 37
      else
        p110 = 35
      end
    end
    if p110 == 35 then
      c143v3 = c143v0 % 10
      if c143v3 ~= 1 then
        p110 = 37
      else
        p110 = 36
      end
    end
    if p110 == 36 then
      c143v4 = FORTUNA_NODE_TAG
      c143v3 = tostring
      c143v3 = c143v3(c143v4)
      do return c143v3 end
    end
    if p110 == 37 then
      if c143v1 ~= 2 then
        p110 = 40
      else
        p110 = 38
      end
    end
    if p110 == 38 then
      c143v3 = c143v0 % 100
      if c143v3 ~= 80 then
        p110 = 40
      else
        p110 = 39
      end
    end
    if p110 == 39 then
      c143v4 = NOKKO_COLONY_NODE_TAG
      c143v3 = tostring
      c143v3 = c143v3(c143v4)
      do return c143v3 end
    end
    if p110 == 40 then
      c143v3 = {}
      c143v4 = "MercuryHUB"
      c143v3[1] = c143v4
      c143v4 = "VenusHUB"
      c143v3[2] = c143v4
      c143v4 = "EarthHUB"
      c143v3[3] = c143v4
      c143v4 = "TradeHUB1"
      c143v3[4] = c143v4
      c143v4 = "JupiterHUB"
      c143v3[5] = c143v4
      c143v4 = "SaturnHUB"
      c143v3[6] = c143v4
      c143v4 = "JadeShadows2HUB"
      c143v3[7] = c143v4
      c143v4 = "NeptuneHUB"
      c143v3[8] = c143v4
      c143v4 = "PlutoHUB"
      c143v3[9] = c143v4
      c143v4 = "CeresHUB"
      c143v3[10] = c143v4
      c143v4 = "ErisHUB"
      c143v3[11] = c143v4
      c143v4 = "SednaHUB"
      c143v3[12] = c143v4
      c143v4 = "EuropaHUB"
      c143v3[13] = c143v4
      c143v4 = "DeimosHub"
      c143v3[17] = c143v4
      c143v4 = "ZarimanHub"
      c143v3[22] = c143v4
      c143v4 = "1999Hub"
      c143v3[24] = c143v4
      c143v4 = c143v3[c143v1]
      if not c143v4 then
        p110 = 42
      else
        p110 = 41
      end
    end
    if p110 == 41 then
      c143v4 = c143v3[c143v1]
      do return c143v4 end
    end
    if p110 == 42 then
      c143v4 = print
      c143v6 = "Invalid hub gameModeId "
      c143v8 = "! Defaulting to MercuryHUB"
      c143v5 = c143v6 .. c143v0 .. c143v8
      c143v4(c143v5)
      c143v4 = c143v3[1]
      do return c143v4 end
    end
    if p110 == 43 then
      c143v3 = vT[78]
      c143v3 = c143v3(c143v0)
      if not c143v3 then
        p110 = 45
      else
        p110 = 44
      end
    end
    if p110 == 44 then
      c143v4 = "CrewBattleNode"
      c143v3 = c143v4 .. c143v2
      do return c143v3 end
    end
    if p110 == 45 then
      c143v3 = IsKeyGameModeId
      c143v3 = c143v3(c143v0)
      if not c143v3 then
        p110 = 47
      else
        p110 = 46
      end
    end
    if p110 == 46 then
      c143v3 = c143v0 % 1000
      c143v4 = vT[57]
      c143v4 = c143v4()
      c143v4 = c143v4:Name__dc4c6f1c(c143v3)
      do return c143v4 end
    end
    if p110 == 47 then
      if c143v1 ~= 16 then
        p110 = 51
      else
        p110 = 48
      end
    end
    if p110 == 48 then
      c143v3 = 80
      if c143v2 < c143v3 then
        p110 = 50
      else
        p110 = 49
      end
    end
    if p110 == 49 then
      c143v2 = c143v2 - 80
      c143v4 = "ClanNode"
      c143v3 = c143v4 .. c143v2
      do return c143v3 end
    end
    if p110 == 50 then
      c143v4 = "SettlementNode"
      c143v3 = c143v4 .. c143v2
      do return c143v3 end
    end
    if p110 == 51 then
      if (c143v1 ~= 2 or c143v2 ~= 80) then
        p110 = 54
      else
        p110 = 53
      end
    end
    if p110 == 53 then
      c143v3 = "NokkoColony"
      do return c143v3 end
    end
    if p110 == 54 then
      c143v3 = 0
      if c143v2 <= c143v3 then
        p110 = 59
      else
        p110 = 55
      end
    end
    if p110 == 55 then
      c143v4 = vT[32]
      c143v3 = c143v4[c143v1]
      if not c143v3 then
        p110 = 58
      else
        p110 = 56
      end
    end
    if p110 == 56 then
      c143v5 = vT[32]
      c143v4 = c143v5[c143v1]
      c143v3 = c143v4[c143v2]
      if c143v3 ~= true then
        p110 = 58
      else
        p110 = 57
      end
    end
    if p110 == 57 then
      c143v4 = "ClanNode"
      c143v3 = c143v4 .. c143v2
      do return c143v3 end
    end
    if p110 == 58 then
      c143v4 = "SolNode"
      c143v3 = c143v4 .. c143v2
      do return c143v3 end
    end
    if p110 == 59 then
      c143v3 = nil
      do return c143v3 end
    end
  end
  GetNodeNameFromGameModeId = vT[84]
  vT[84] = function(c144v0)
    local c144v1
    c144v1 = vT[65]
    c144v1 = c144v1(c144v0)
    if c144v1 then
      c144v1 = ALERT_TAG
      do return c144v1 end
    end
    c144v1 = vT[68]
    c144v1 = c144v1(c144v0)
    if c144v1 then
      c144v1 = HARD_EVENT_TAG
      do return c144v1 end
    end
    c144v1 = vT[67]
    c144v1 = c144v1(c144v0)
    if c144v1 then
      c144v1 = EVENT_TAG
      do return c144v1 end
    end
    c144v1 = vT[69]
    c144v1 = c144v1(c144v0)
    if c144v1 then
      c144v1 = INVASION_ATTACKER_TAG
      do return c144v1 end
    end
    c144v1 = vT[70]
    c144v1 = c144v1(c144v0)
    if c144v1 then
      c144v1 = INVASION_DEFENDER_TAG
      do return c144v1 end
    end
    c144v1 = vT[72]
    c144v1 = c144v1(c144v0)
    if c144v1 then
      c144v1 = SYNDICATE_MISSION_TAG
      do return c144v1 end
    end
    c144v1 = vT[73]
    c144v1 = c144v1(c144v0)
    if c144v1 then
      c144v1 = SORTIE_MISSION_TAG
      do return c144v1 end
    end
    c144v1 = vT[75]
    c144v1 = c144v1(c144v0)
    if c144v1 then
      c144v1 = LITE_SORTIE_MISSION_TAG
      do return c144v1 end
    end
    c144v1 = IsHubGameModeId
    c144v1 = c144v1(c144v0)
    if c144v1 then
      c144v1 = HUB_TAG
      do return c144v1 end
    end
    c144v1 = vT[76]
    c144v1 = c144v1(c144v0)
    if c144v1 then
      c144v1 = ACTIVE_MISSION_TAG
      do return c144v1 end
    end
    c144v1 = vT[77]
    c144v1 = c144v1(c144v0)
    if c144v1 then
      c144v1 = KUVA_TOWER_MISSION_TAG
      do return c144v1 end
    end
    c144v1 = IsKeyGameModeId
    c144v1 = c144v1(c144v0)
    if c144v1 then
      c144v1 = KEY_TAG
      do return c144v1 end
    end
    c144v1 = vT[66]
    c144v1 = c144v1(c144v0)
    if c144v1 then
      c144v1 = NIGHTMARE_TAG
      do return c144v1 end
    end
    c144v1 = IsHardDailyGameModeId
    c144v1 = c144v1(c144v0)
    if c144v1 then
      c144v1 = HARD_DAILY_TAG
      do return c144v1 end
    end
    c144v1 = vT[79]
    c144v1 = c144v1(c144v0)
    if c144v1 then
      c144v1 = VOID_STORM_TAG
      do return c144v1 end
    end
    c144v1 = IsHardGameModeId
    c144v1 = c144v1(c144v0)
    if c144v1 then
      c144v1 = HARD_MODE_TAG
      do return c144v1 end
    end
    c144v1 = vT[80]
    c144v1 = c144v1(c144v0)
    if c144v1 then
      c144v1 = LAB_CONQUEST_MISSION_TAG
      do return c144v1 end
    end
    c144v1 = IsPvPvEVsAiGameModeId
    c144v1 = c144v1(c144v0)
    if c144v1 then
      c144v1 = PVPVE_VS_AI_NAME_TAG
      do return c144v1 end
    end
    c144v1 = IsPvPvEVsTennoGameModeId
    c144v1 = c144v1(c144v0)
    if c144v1 then
      c144v1 = PVPVE_VS_TENNO_NAME_TAG
      do return c144v1 end
    end
    c144v1 = vT[81]
    c144v1 = c144v1(c144v0)
    if c144v1 then
      c144v1 = HEX_CONQUEST_MISSION_TAG
      do return c144v1 end
    end
    c144v1 = IsEliteAlertGameModeId
    c144v1 = c144v1(c144v0)
    if c144v1 then
      c144v1 = ELITE_ALERT_TAG
      do return c144v1 end
    end
    c144v1 = ""
    do return c144v1 end
  end
  GetNodeModifierTagFromGameModeId = vT[84]
  vT[84] = function(c145v0)
    local c145v1, c145v2, c145v3, c145v4, c145v5, c145v6, c145v7
    c145v1 = vT[57]
    c145v1 = c145v1()
    c145v2 = GetNodeNameFromGameModeId
    c145v2 = c145v2(c145v0)
    c145v3 = nil
    if c145v2 then
      c145v6 = Symbol
      c145v3 = c145v1:BuildMissionForLocation(c145v6(c145v2))
    end
    c145v4 = WeakResource
    c145v5 = "/Lotus/Types/Game/LotusPvpGameRules"
    c145v4 = c145v4(c145v5)
    c145v6 = IsNull
    c145v6 = c145v6(c145v3)
    c145v5 = not c145v6
    if c145v5 then
      c145v7 = c145v3.gameRules
      c145v6 = IsNull
      c145v6 = c145v6(c145v7)
      c145v5 = not c145v6
      if c145v5 then
        c145v5 = c145v3.gameRules
        c145v5 = c145v5:IsA(c145v4)
      end
    end
    c145v6 = _T.CachedPvpNodes
    c145v6[c145v0] = c145v5
    do return end
  end
  vT[85] = function(c146v0)
    local c146v1, c146v2
    c146v1 = _T.CachedPvpNodes
    if not c146v1 then
      c146v1 = _T
      c146v2 = {}
      c146v1.CachedPvpNodes = c146v2
    end
    c146v2 = _T.CachedPvpNodes
    c146v1 = c146v2[c146v0]
    if not c146v1 then
      c146v1 = vT[84]
      c146v1(c146v0)
    end
    c146v2 = _T.CachedPvpNodes
    c146v1 = c146v2[c146v0]
    do return c146v1 end
  end
  vT[86] = function(c147v0)
    local c147v1
    c147v1 = vT[85]
    c147v1 = c147v1(c147v0)
    do return c147v1 end
  end
  CanMergeSquad = vT[86]
  vT[86] = function(c148v0)
    local c148v1, c148v2, c148v3, c148v4, c148v5, c148v6, c148v7, c148v8, c148v9
    c148v1 = vT[72]
    c148v1 = c148v1(c148v0)
    if not c148v1 then
      c148v1 = vT[73]
      c148v1 = c148v1(c148v0)
      if not c148v1 then
        c148v1 = GetNodeNameFromGameModeId
        c148v1 = c148v1(c148v0)
        do return c148v1 end
      end
    end
    c148v3 = c148v0 / 1000
    c148v2 = math.floor
    c148v2 = c148v2(c148v3)
    c148v1 = c148v2 % 100
    c148v4 = tostring
    c148v4 = c148v4(c148v0)
    c148v5 = -3
    c148v3 = string.sub
    c148v3 = c148v3(c148v4, c148v5)
    c148v2 = tonumber
    c148v2 = c148v2(c148v3)
    c148v6 = vT[17]
    c148v6 = c148v6.Ternary
    if c148v1 ~= 16 then
      c148v7 = false
    else
      c148v7 = true
    end
    c148v8 = "SettlementNode"
    c148v9 = "SolNode"
    c148v4 = c148v6(c148v7, c148v8, c148v9)
    c148v3 = c148v4 .. c148v2
    do return c148v3 end
  end
  GetDisplayedNodeNameFromGameModeId = vT[86]
  vT[86] = function(c149v0)
    local c149v1, c149v2, c149v3, c149v4, c149v5, c149v6, c149v7, c149v8
    c149v1 = gGameData
    c149v2 = c149v1:GetWorldState()
    c149v3 = string.find
    c149v5 = ALERT_TAG
    c149v3 = c149v3(c149v0, c149v5)
    if c149v3 ~= nil then
      c149v6 = 1
      c149v7 = c149v3 - 1
      c149v4 = string.sub
      c149v0 = c149v4(c149v0, c149v6, c149v7)
    end
    c149v4 = c149v2.mAlerts
    c149v7 = 1
    c149v5 = #c149v4
    c149v6 = 1
    for c149v7 = c149v7, c149v5, c149v6 do
      c149v8 = c149v4[c149v7]
      c149v8 = c149v8.mMissionInfo
      c149v8 = c149v8.location
      c149v8 = c149v8:c_str()
      if c149v8 == c149v0 then break end
      if c149v8 == c149v0 then
        c149v8 = c149v4[c149v7]
        c149v8 = c149v8.mExpiry
        do return c149v8 end
      end
    end
    c149v5 = nil
    do return c149v5 end
  end
  GetAlertExpiryforNode = vT[86]
  vT[86] = function(c150v0, c150v1, c150v2)
    local c150v3, c150v4, c150v5, c150v6
    c150v3 = _T.CachedRegionStatus
    if c150v3 then
      c150v4 = _T.CachedRegionStatus
      c150v3 = c150v4[c150v2]
      if c150v3 then
        c150v4 = _T.CachedRegionStatus
        c150v3 = c150v4[c150v2]
        c150v3 = c150v3.goal
        if c150v3 == true then
          c150v3 = true
          do return c150v3 end
        end
      end
    end
    c150v3 = IsNull
    c150v3 = c150v3(c150v0)
    if c150v3 then
      c150v3 = vT[57]
      c150v0 = c150v3()
    end
    c150v3 = IsNull
    c150v3 = c150v3(c150v1)
    if c150v3 then
      c150v3 = false
      do return c150v3 end
    end
    c150v4 = c150v0:GetRegions()
    c150v3 = c150v4[c150v2]
    c150v5 = IsNull
    c150v5 = c150v5(c150v3)
    c150v4 = not c150v5
    if c150v4 then
      c150v4 = true
      c150v5 = c150v3:GetCompletionStatus()
      c150v6 = 0
      if c150v5 == c150v6 then
        c150v4 = c150v1:Name__23ae9ab1(c150v2)
      end
    end
    do return c150v4 end
  end
  IsRegionUnlocked = vT[86]
  vT[86] = function()
    local c151v0, c151v1, c151v2, c151v3, c151v4
    c151v0 = gFlashMgr
    c151v2 = vT[17]
    c151v2 = c151v2.GetChatMovie
    c151v0 = c151v0:FindMovie(c151v2())
    c151v1 = IsNull
    c151v1 = c151v1(c151v0)
    if not c151v1 then
      c151v3 = "IsMaximized"
      c151v4 = ""
      do return c151v0:Execute(c151v3, c151v4) end
    end
    c151v1 = false
    do return c151v1 end
  end
  IsChatTextActive = vT[86]
  vT[86] = function(c152v0)
    local c152v1, c152v2, c152v3, c152v4, c152v5, c152v6, c152v7
    c152v1 = IsNull
    c152v1 = c152v1(c152v0)
    if c152v1 then
      c152v1 = true
      do return c152v1 end
    end
    c152v1 = c152v0:GetSettings()
    c152v2 = vT[65]
    c152v3 = c152v1.gameModeId
    c152v2 = c152v2(c152v3)
    if not c152v1 then
      local p17 = 3
      if p17 == 3 then
        c152v2 = ""
        c152v3 = c152v1:GetMaps()
        c152v4 = IsNull
        c152v4 = c152v4(c152v3)
        if c152v4 then
          p17 = 5
        else
          p17 = 4
        end
      end
      if p17 == 4 then
        c152v4 = #c152v3
        c152v5 = 0
        if c152v5 < c152v4 then
          p17 = 6
        else
          p17 = 5
        end
      end
      if p17 == 5 then
        c152v4 = true
        do return c152v4 end
      end
      if p17 == 6 then
        c152v2 = c152v3[1]
        c152v4 = string.len
        c152v4 = c152v4(c152v2)
        c152v5 = 0
        if c152v4 <= c152v5 then
        else
          p17 = 7
        end
      end
      if p17 == 7 then
        c152v4 = MongoDateTime
        c152v4 = c152v4()
        c152v4.sec = c152v2
        c152v5 = Engine.Name__b38e1642
        c152v5 = c152v5(c152v4)
        c152v7 = 0
        if c152v5 <= c152v7 then
          p17 = 9
        else
          p17 = 8
        end
      end
      if p17 == 8 then
        c152v6 = false
        p17 = 10
      end
      if p17 == 9 then
        c152v6 = true
        p17 = 10
      end
      if p17 == 10 then
        do return c152v6 end
      end
    end
    c152v2 = false
    do return c152v2 end
  end
  IsSessionExpired = vT[86]
  vT[86] = function(c153v0)
    local c153v1, c153v2, c153v3, c153v4, c153v5, c153v6, c153v7
    c153v1 = gGameData
    c153v2 = IsNull
    c153v2 = c153v2(c153v1)
    if c153v2 then
      c153v2 = false
      do return c153v2 end
    end
    c153v2 = c153v1:GetTauntHistory()
    c153v3 = Symbol
    c153v3 = c153v3(c153v0)
    c153v6 = 1
    c153v4 = #c153v2
    c153v5 = 1
    for c153v6 = c153v6, c153v4, c153v5 do
      c153v7 = c153v2[c153v6]
      c153v7 = c153v7.node
      if c153v7 == c153v3 then break end
      if c153v7 == c153v3 then
        c153v7 = false
        do return c153v7 end
      end
    end
    c153v1:AdvanceTauntHistory(c153v3)
    c153v4 = gPlayerProfileMgr
    c153v6 = 0
    c153v4:Name__4be6b7ba(c153v6)
    c153v4 = true
    do return c153v4 end
  end
  CheckShowTutorial = vT[86]
  vT[86] = function(c154v0, c154v1)
    local c154v2, c154v3, c154v4, c154v5, c154v6
    c154v2 = gFlashMgr
    c154v4 = _G
    c154v4 = c154v4.UIMovie_TransmissionMovie
    c154v2 = c154v2:FindMovie(c154v4)
    if c154v0 == nil then
      c154v0 = _T.curTransmission
    end
    c154v3 = IsNull
    c154v3 = c154v3(c154v0)
    if c154v0 ~= nil then
      local p23 = 3
      if p23 == 3 then
        c154v3 = IsNull
        c154v3 = c154v3(c154v2)
        if c154v3 then
        else
          p23 = 4
        end
      end
      if p23 == 4 then
        c154v3 = _T.curTransmission
        if c154v3 == c154v0 then
          p23 = 7
        else
          p23 = 5
        end
      end
      if p23 == 5 then
        if not c154v1 then
          p23 = 8
        else
          p23 = 6
        end
      end
      if p23 == 6 then
        c154v3 = _T.curTransmission
        c154v3 = c154v3:IsA(c154v0)
        if not c154v3 then
          p23 = 8
        else
          p23 = 7
        end
      end
      if p23 == 7 then
        c154v5 = "QueueClose"
        c154v6 = ""
        c154v2:Execute(c154v5, c154v6)
        do return end
      end
      if p23 == 8 then
        c154v4 = _T.QueuedTransmissions
        c154v3 = IsNull
        c154v3 = c154v3(c154v4)
        if c154v3 then
        else
          p23 = 9
        end
      end
      if p23 == 9 then
        c154v3 = 1
        p23 = 10
      end
      while p23 == 10 or p23 == 11 or p23 == 12 or p23 == 13 or p23 == 15 do
        if p23 == 10 then
          c154v5 = _T.QueuedTransmissions
          c154v4 = #c154v5
          if c154v4 < c154v3 then
          else
            p23 = 11
          end
        end
        if p23 == 11 then
          c154v5 = _T.QueuedTransmissions
          c154v4 = c154v5[c154v3]
          c154v4 = c154v4.Transmission
          if c154v4 == c154v0 then
            p23 = 14
          else
            p23 = 12
          end
        end
        if p23 == 12 then
          if not c154v1 then
            p23 = 15
          else
            p23 = 13
          end
        end
        if p23 == 13 then
          c154v5 = _T.QueuedTransmissions
          c154v4 = c154v5[c154v3]
          c154v4 = c154v4.Transmission
          c154v4 = c154v4:IsA(c154v0)
          if not c154v4 then
            p23 = 15
          else
            p23 = 14
          end
        end
        if p23 == 15 then
          c154v3 = c154v3 + 1
          p23 = 10
        end
      end
      if p23 == 14 then
        c154v4 = table.remove
        c154v5 = _T.QueuedTransmissions
        c154v4(c154v5, c154v3)
        do return end
      end
    end
    do return end
  end
  InterruptTransmission = vT[86]
  vT[86] = function(c155v0, c155v1, c155v2)
    local c155v3, c155v4, c155v5, c155v6, c155v7, c155v8
    c155v3 = _T.QueuedTransmissions
    if c155v3 == nil then
      c155v3 = _T
      c155v4 = {}
      c155v3.QueuedTransmissions = c155v4
    end
    c155v3 = print
    c155v5 = "Queuing new transmission: "
    c155v6 = c155v0:GetName()
    c155v4 = c155v5 .. c155v6
    c155v3(c155v4)
    c155v3 = Lotus_Game.Name__fee7bd22
    c155v3 = c155v3(c155v0)
    c155v4 = c155v3.mQueueDump
    if c155v4 then
      c155v4 = print
      c155v5 = "Dumping queued transmissions and interrupting current one"
      c155v4(c155v5)
      c155v4 = InterruptTransmission
      c155v4()
      c155v4 = _T
      c155v5 = {}
      c155v4.QueuedTransmissions = c155v5
    end
    if c155v2 then
      c155v5 = _T.QueuedTransmissions
      c155v6 = 1
      c155v7 = { Transmission = nil, SpeakerData = nil }
      c155v7.Transmission = c155v0
      c155v7.SpeakerData = c155v1
      c155v4 = table.insert
      c155v4(c155v5, c155v6, c155v7)
    else
      c155v5 = _T.QueuedTransmissions
      c155v6 = { Transmission = nil, SpeakerData = nil }
      c155v6.Transmission = c155v0
      c155v6.SpeakerData = c155v1
      c155v4 = table.insert
      c155v4(c155v5, c155v6)
    end
    c155v4 = WeakResource
    c155v5 = "/Lotus/Sounds/Dialog/PlayerShip/Ordis/DOrdis010OrdisTransmission"
    c155v4 = c155v4(c155v5)
    if c155v0 == c155v4 then
      c155v5 = gGameStatsMgr
      c155v4 = IsNull
      c155v4 = c155v4(c155v5)
      if not c155v4 then
        c155v4 = gGameStatsMgr
        c155v6 = Symbol
        c155v7 = "VORS_PRIZE"
        c155v6 = c155v6(c155v7)
        c155v7 = "LOADED_ORBITER"
        c155v8 = "STAGE_0"
        c155v4:LogEvent(c155v6, c155v7, c155v8)
      end
    end
    c155v4 = Engine.IsMobile
    c155v4 = c155v4()
    if c155v4 then
      c155v4 = _T.TransmissionSpeedUpRule
      c155v5 = SpeedUpRule
      c155v5 = c155v5.ALLOW
      if c155v4 == c155v5 then
        c155v4 = _T.SpeedableTransmissionTypes
        if c155v4 == nil then
          c155v4 = _T
          c155v5 = {}
          c155v4.SpeedableTransmissionTypes = c155v5
        end
        c155v5 = _T.SpeedableTransmissionTypes
        c155v4 = table.insert
        c155v4(c155v5, c155v0)
      end
    end
    do return end
  end
  QueueTransmission = vT[86]
  vT[86] = function(c156v0, c156v1)
    local c156v2, c156v3, c156v4, c156v5
    c156v2 = IsNull
    c156v2 = c156v2(c156v0)
    if c156v2 then
      do return end
    end
    c156v2 = QueueTransmission
    c156v2(c156v0, c156v1)
    c156v2 = gFlashMgr
    c156v4 = _G
    c156v4 = c156v4.UIMovie_TransmissionMovie
    c156v2 = c156v2:FindMovie(c156v4)
    c156v3 = IsNull
    c156v3 = c156v3(c156v2)
    if c156v3 then
      c156v3 = gFlashMgr
      c156v5 = _G
      c156v5 = c156v5.UIMovie_TransmissionMovie
      c156v2 = c156v3:PushMovie(c156v5)
    end
    do return end
  end
  CreateHudlessTransmission = vT[86]
  vT[86] = function()
    local c157v0, c157v2
    c157v0 = gFlashMgr
    c157v2 = _G
    c157v2 = c157v2.UIMovie_TransmissionMovie
    c157v0 = c157v0:HasMovie(c157v2)
    if c157v0 then
      c157v0 = true
      do return c157v0 end
    end
    c157v0 = false
    do return c157v0 end
  end
  IsTransmissionPlaying = vT[86]
  vT[86] = function()
    local c158v0, c158v1, c158v2
    c158v0 = Engine.IsMobile
    c158v0 = c158v0()
    if c158v0 then
      c158v0 = false
      c158v1 = _T.TransmissionSpeedUpRule
      c158v2 = SpeedUpRule
      c158v2 = c158v2.DENY
      if c158v1 ~= c158v2 then
        c158v1 = _T.TransmissionSpeedUpPressed
        if c158v1 ~= true then
          c158v0 = false
        else
          c158v0 = true
        end
      end
    end
    do return c158v0 end
  end
  IsTransmissionSpeedUpActive = vT[86]
  vT[86] = function()
    local c159v0, c159v1, c159v2, c159v3, c159v4
    c159v0 = IsTransmissionSpeedUpActive
    c159v0 = c159v0()
    c159v1 = SetConfigBool
    c159v2 = "TransmissionSpeedUp.Active"
    c159v1(c159v2, c159v0)
    c159v1 = Resource
    c159v2 = "/Lotus/Interface/TransmissionSpeedUpIndicator.swf"
    c159v1 = c159v1(c159v2)
    c159v2 = gFlashMgr
    c159v2 = c159v2:FindMovie(c159v1)
    c159v4 = IsNull
    c159v4 = c159v4(c159v2)
    c159v3 = not c159v4
    if c159v3 ~= c159v0 then
      if c159v3 then
        c159v2:Close()
        do return end
      end
      c159v4 = gFlashMgr
      c159v4:PushMovie(c159v1)
    end
    do return end
  end
  vT[87] = function(c160v0)
    local c160v2
    local c160v1 = _T.TransmissionSpeedUpRule
    if c160v0 == c160v1 then
      do return end
    end
    c160v1 = SpeedUpRule
    c160v1 = c160v1.ALLOW_WHILE_SPEEDABLE_TRANSMISSIONS
    if c160v0 == c160v1 then
      c160v1 = _T.SpeedableTransmissionTypes
      if c160v1 == nil then
        c160v1 = SpeedUpRule
        c160v0 = c160v1.DENY
      end
    end
    c160v1 = _T
    c160v1.TransmissionSpeedUpRule = c160v0
    c160v1 = _T.TransmissionSpeedUpRule
    c160v2 = SpeedUpRule
    c160v2 = c160v2.DENY
    if c160v1 == c160v2 then
      c160v1 = _T
      c160v2 = nil
      c160v1.SpeedableTransmissionTypes = c160v2
      c160v1 = vT[86]
      c160v1()
    end
    c160v2 = _T.TransmissionSpeedUpButton
    c160v1 = IsNull
    c160v1 = c160v1(c160v2)
    if not c160v1 then
      c160v1 = _T.TransmissionSpeedUpButton
      c160v1:OnSpeedUpRuleChanged()
    end
    do return end
  end
  SetTransmissionSpeedUpRule = vT[87]
  vT[87] = function(c161v0)
    local c161v1, c161v2
    c161v1 = _T.TransmissionSpeedUpPressed
    if c161v0 == c161v1 then
      do return end
    end
    c161v1 = _T
    c161v1.TransmissionSpeedUpPressed = c161v0
    c161v1 = _T.TransmissionSpeedUpRule
    c161v2 = SpeedUpRule
    c161v2 = c161v2.DENY
    if c161v1 == c161v2 then
      do return end
    end
    c161v1 = vT[86]
    c161v1()
    do return end
  end
  SetTransmissionSpeedUpPressed = vT[87]
  vT[87] = function()
    local c162v0, c162v1, c162v2, c162v3
    c162v0 = 0
    c162v1 = gGameData
    c162v2 = IsNull
    c162v2 = c162v2(c162v1)
    if not c162v2 then
      c162v2 = c162v1:GetPlayerXP()
      c162v3 = gGameConfig
      c162v0 = c162v3:GetPlayerLevel(c162v2)
    end
    do return c162v0 end
  end
  GetActualPlayerRank = vT[87]
  vT[87] = function()
    local c163v0, c163v1, c163v2, c163v3, c163v4, c163v5, c163v7, c163v8, c163v9
    c163v0 = _T.HasCompletedVorsPrize
    if c163v0 then
      c163v0 = true
      do return c163v0 end
    end
    c163v1 = gClient
    c163v0 = IsNull
    c163v0 = c163v0(c163v1)
    if c163v0 then
      c163v0 = _T
      c163v1 = true
      c163v0.HasCompletedVorsPrize = c163v1
      c163v0 = true
      do return c163v0 end
    end
    c163v0 = WeakResource
    c163v1 = "/Lotus/Types/Keys/VorsPrize/VorsPrizeQuestKeyChain"
    c163v0 = c163v0(c163v1)
    c163v1 = WeakResource
    c163v2 = "/Lotus/Types/Keys/InfestedIntroQuest/InfestedIntroQuestKeyChain"
    c163v1 = c163v1(c163v2)
    c163v2 = gGameData
    c163v3 = IsNull
    c163v3 = c163v3(c163v2)
    if c163v3 then
      c163v3 = gPlayerProfileMgr
      c163v5 = 0
      c163v3 = c163v3:GetPlayerProfile(c163v5)
      c163v4 = IsNull
      c163v4 = c163v4(c163v3)
      if not c163v4 then
        c163v2 = c163v3:GetGameSpecificData()
      end
    end
    c163v3 = IsNull
    c163v3 = c163v3(c163v2)
    if not c163v0 then
      c163v3 = IsNull
      c163v3 = c163v3(c163v2:GetInventory())
      if not c163v3 then
        c163v3 = pairs
        c163v4 = c163v2:GetInventory()
        c163v3, c163v4, c163v5 = c163v3(c163v4:GetQuestKeys())
        c163v8 = IsNull
        c163v8 = c163v8(c163v7)
        c163v8 = c163v7.mItemType
        c163v8 = c163v7.mItemType
        c163v8 = c163v7.mCompleted
        for c163v6, c163v7 in c163v3, c163v4, c163v5 do
          c163v8 = _T
          c163v9 = true
          c163v8.HasCompletedVorsPrize = c163v9
          c163v8 = true
          do return c163v8 end
        end
      end
    end
    c163v3 = false
    do return c163v3 end
  end
  HasCompletedVorsPrize = vT[87]
  vT[87] = function(c164v0, c164v1)
    local c164v2, c164v3, c164v4, c164v5, c164v6, c164v7, c164v8, c164v9, c164v10
    c164v4 = c164v3:GetInventory()
    c164v5 = IsNull
    c164v5 = c164v5(c164v4)
    c164v5 = c164v4:GetQuestKeys()
    c164v8 = 1
    c164v6 = #c164v5
    c164v7 = 1
    for c164v8 = c164v8, c164v6, c164v7 do
      c164v10 = c164v5[c164v8]
      c164v9 = IsNull
      c164v9 = c164v9(c164v10)
      if not c164v9 then
        c164v9 = c164v5[c164v8]
        c164v9 = c164v9.mItemType
        if c164v0 == c164v9 then break end
        if c164v0 == c164v9 then
          c164v9 = c164v5[c164v8]
          c164v9 = c164v9.mCompleted
          do return c164v9 end
        end
      end
    end
    c164v3 = gClient
    c164v2 = IsNull
    c164v2 = c164v2(c164v3)
    if c164v2 then
      c164v2 = true
      do return c164v2 end
    end
    c164v2 = WeakResource
    c164v3 = "/Lotus/Types/Keys/VorsPrize/VorsPrizeQuestKeyChain"
    c164v2 = c164v2(c164v3)
    if c164v0 == c164v2 then
      c164v3 = HasCompletedVorsPrize
      c164v3 = c164v3()
      do return c164v3 end
    end
    c164v4 = gGameData
    c164v3 = IsNull
    c164v3 = c164v3(c164v4)
    if not c164v3 then
      c164v3 = WeakResource
      c164v4 = "/Lotus/Types/Keys/ModQuest/ModQuestKeyChain"
      c164v3 = c164v3(c164v4)
      if not ((not c164v1 or c164v0 ~= c164v3)) then
        c164v4 = gGameData
        c164v6 = Symbol
        c164v7 = "ModQuestTeshinAccess"
        c164v4 = c164v4:HasCompletedNodeIntro(c164v6(c164v7))
        if c164v4 then
          c164v4 = true
          do return c164v4 end
        end
      end
      if c164v1 then
        c164v4 = vT[38]
        if c164v0 == c164v4 then
          c164v4 = gGameData
          c164v6 = Symbol
          c164v7 = "TauNavOverride"
          c164v4 = c164v4:HasCompletedNodeIntro(c164v6(c164v7))
          if c164v4 then
            c164v4 = true
            do return c164v4 end
          end
        end
      end
    end
    c164v3 = gGameData
    c164v4 = IsNull
    c164v4 = c164v4(c164v3)
    if c164v4 then
      c164v4 = gPlayerProfileMgr
      c164v6 = 0
      c164v4 = c164v4:GetPlayerProfile(c164v6)
      c164v5 = IsNull
      c164v5 = c164v5(c164v4)
      if not c164v5 then
        c164v3 = c164v4:GetGameSpecificData()
      end
    end
    c164v4 = IsNull
    c164v4 = c164v4(c164v0)
    if c164v4 then
      c164v4 = false
      do return c164v4 end
    end
    c164v4 = IsNull
    c164v4 = c164v4(c164v3)
    c164v4 = false
    do return c164v4 end
  end
  vT[88] = function()
    local c165v0, c165v1, c165v2
    c165v0 = vT[87]
    c165v1 = WeakResource
    c165v2 = "/Lotus/Types/Keys/ModQuest/ModQuestKeyChain"
    c165v1 = c165v1(c165v2)
    c165v2 = true
    do return c165v0(c165v1, c165v2) end
  end
  HasCompletedTheTeacher = vT[88]
  vT[88] = function(c166v0, c166v1)
    local c166v2
    c166v2 = vT[87]
    do return c166v2(c166v0, c166v1) end
  end
  HasCompletedQuest = vT[88]
  vT[88] = function(c167v0)
    local c167v1, c167v2, c167v3, c167v4, c167v5
    c167v1 = string.gsub
    c167v2 = tostring
    c167v2 = c167v2(c167v0:GetFullName())
    c167v3 = "/Lotus/Types/"
    c167v4 = "/Lotus/StoreItems/Types/"
    c167v1 = c167v1(c167v2, c167v3, c167v4)
    c167v2 = Resource
    c167v2 = c167v2(c167v1)
    c167v3 = IsNull
    c167v3 = c167v3(c167v2)
    if not c167v3 then
      c167v3 = Localize
      c167v4 = tostring
      c167v4 = c167v4(c167v2:GetLocalizeTag())
      c167v5 = nil
      do return c167v3(c167v4, c167v5) end
    end
    c167v3 = ""
    do return c167v3 end
  end
  GetLocalizedQuestName = vT[88]
  vT[88] = function(c168v0)
    local c168v1, c168v2, c168v3, c168v4, c168v5, c168v6, c168v7
    c168v4 = string.gsub
    c168v5 = tostring
    c168v5 = c168v5(c168v0:GetFullName())
    c168v6 = "/Lotus/Types/Restoratives/Upgraded/"
    c168v7 = "/Lotus/Language/Items/"
    c168v2 = c168v4(c168v5, c168v6, c168v7)
    c168v3 = "Name"
    c168v1 = c168v2 .. c168v3
    c168v2 = Localize
    c168v4 = nil
    do return c168v2(c168v1, c168v4) end
  end
  GetLocalizedDragonKeyName = vT[88]
  vT[88] = function()
    local c169v0, c169v1, c169v2
    c169v2 = vT[36]
    c169v1 = IsNull
    c169v1 = c169v1(c169v2)
    c169v0 = not c169v1
    if c169v0 then
      c169v0 = vT[87]
      c169v1 = vT[36]
      c169v0 = c169v0(c169v1)
    end
    do return c169v0 end
  end
  HasCompletedWITW = vT[88]
  vT[88] = function()
    local c170v0, c170v1, c170v2
    c170v0 = WeakResource
    c170v1 = "/Lotus/Types/Keys/ZarimanQuest/ZarimanQuestKeyChain"
    c170v0 = c170v0(c170v1)
    c170v2 = IsNull
    c170v2 = c170v2(c170v0)
    c170v1 = not c170v2
    if c170v1 then
      c170v1 = vT[87]
      c170v1 = c170v1(c170v0)
    end
    do return c170v1 end
  end
  HasCompletedZariman = vT[88]
  vT[88] = function()
    local c171v0, c171v1, c171v2
    c171v0 = WeakResource
    c171v1 = "/Lotus/Types/Keys/NewWarQuest/NewWarQuestKeyChain"
    c171v0 = c171v0(c171v1)
    c171v2 = IsNull
    c171v2 = c171v2(c171v0)
    c171v1 = not c171v2
    if c171v1 then
      c171v1 = vT[87]
      c171v1 = c171v1(c171v0)
    end
    do return c171v1 end
  end
  HasCompletedNewWar = vT[88]
  vT[88] = function()
    local c172v0, c172v1, c172v2, c172v3, c172v4, c172v5, c172v6
    local p18 = 0
    if p18 == 0 then
      c172v0 = false
      c172v2 = gMatchingService
      c172v1 = IsNull
      c172v1 = c172v1(c172v2:GetSession())
      if c172v1 then
        p18 = 2
      else
        p18 = 1
      end
    end
    if p18 == 1 then
      c172v1 = gMatchingService
      c172v1 = c172v1:IsSquadHost()
      if not c172v1 then
        p18 = 3
      else
        p18 = 2
      end
    end
    if p18 == 2 then
      c172v1 = HasCompletedNewWar
      c172v0 = c172v1()
      p18 = 7
    end
    if p18 == 3 then
      c172v1 = gMatchingService
      c172v1 = c172v1:GetSquadMembers()
      c172v4 = 1
      c172v2 = #c172v1
      c172v3 = 1
      for c172v4 = c172v4, c172v2, c172v3 do
        c172v5 = c172v1[c172v4]
        c172v5 = c172v5.isHost
        if c172v5 then break end
        if c172v5 then
          c172v5 = cjson.decode
          c172v6 = c172v1[c172v4]
          c172v6 = c172v6.loadout
          c172v5 = c172v5(c172v6)
          c172v0 = c172v5.PostNewWar
        end
      end
      p18 = 7
    end
    if p18 == 7 then
      c172v1 = false
      if c172v0 == nil then
        p18 = 11
      else
        p18 = 8
      end
    end
    if p18 == 8 then
      if c172v0 ~= false then
        p18 = 10
      else
        p18 = 9
      end
    end
    if p18 == 9 then
      c172v1 = false
      p18 = 11
    end
    if p18 == 10 then
      c172v1 = true
      p18 = 11
    end
    if p18 == 11 then
      do return c172v1 end
    end
  end
  HasSquadHostCompletedNewWar = vT[88]
  vT[88] = function()
    local c173v0, c173v1, c173v2
    c173v2 = vT[38]
    c173v1 = IsNull
    c173v1 = c173v1(c173v2)
    c173v0 = not c173v1
    if c173v0 then
      c173v0 = vT[87]
      c173v1 = vT[38]
      c173v0 = c173v0(c173v1)
    end
    do return c173v0 end
  end
  HasCompletedOldPeace = vT[88]
  vT[88] = function()
    local c174v0, c174v1, c174v2, c174v3, c174v4, c174v5, c174v6
    local p18 = 0
    if p18 == 0 then
      c174v0 = false
      c174v2 = gMatchingService
      c174v1 = IsNull
      c174v1 = c174v1(c174v2:GetSession())
      if c174v1 then
        p18 = 2
      else
        p18 = 1
      end
    end
    if p18 == 1 then
      c174v1 = gMatchingService
      c174v1 = c174v1:IsSquadHost()
      if not c174v1 then
        p18 = 3
      else
        p18 = 2
      end
    end
    if p18 == 2 then
      c174v1 = HasCompletedOldPeace
      c174v0 = c174v1()
      p18 = 7
    end
    if p18 == 3 then
      c174v1 = gMatchingService
      c174v1 = c174v1:GetSquadMembers()
      c174v4 = 1
      c174v2 = #c174v1
      c174v3 = 1
      for c174v4 = c174v4, c174v2, c174v3 do
        c174v5 = c174v1[c174v4]
        c174v5 = c174v5.isHost
        if c174v5 then break end
        if c174v5 then
          c174v5 = cjson.decode
          c174v6 = c174v1[c174v4]
          c174v6 = c174v6.loadout
          c174v5 = c174v5(c174v6)
          c174v0 = c174v5.PostOldPeace
        end
      end
      p18 = 7
    end
    if p18 == 7 then
      c174v1 = false
      if c174v0 == nil then
        p18 = 11
      else
        p18 = 8
      end
    end
    if p18 == 8 then
      if c174v0 ~= false then
        p18 = 10
      else
        p18 = 9
      end
    end
    if p18 == 9 then
      c174v1 = false
      p18 = 11
    end
    if p18 == 10 then
      c174v1 = true
      p18 = 11
    end
    if p18 == 11 then
      do return c174v1 end
    end
  end
  vT[89] = function(c175v0)
    local c175v1, c175v3, c175v4
    local c175v2 = gGameData
    c175v1 = IsNull
    c175v1 = c175v1(c175v2)
    if not ((not (c175v1) and c175v0)) then
      c175v1 = true
      do return c175v1 end
    end
    c175v1 = string.find
    c175v3 = "SolarisUnitedHub1"
    c175v1 = c175v1(c175v0, c175v3)
    if (not (c175v1) and c175v0) then
      c175v1 = gGameData
      c175v1 = c175v1:GetInventory()
      c175v2 = c175v1:GetActiveQuest()
      c175v3 = IsNull
      c175v3 = c175v3(c175v2)
      if not c175v3 then
        c175v4 = vT[35]
        if c175v2 == c175v4 then
          c175v3 = false
        else
          c175v3 = true
        end
      end
      do return c175v3 end
    end
    c175v1 = string.find
    c175v3 = "EntratiLabHub"
    c175v1 = c175v1(c175v0, c175v3)
    if not c175v1 then
      c175v1 = string.find
      c175v3 = "DeimosHub"
      c175v1 = c175v1(c175v0, c175v3)
      if not c175v1 then
        c175v1 = true
        do return c175v1 end
      end
    end
    c175v1 = gGameData
    c175v1 = c175v1:GetInventory()
    c175v2 = c175v1:GetActiveQuest()
    c175v3 = IsNull
    c175v3 = c175v3(c175v2)
    if not c175v3 then
      c175v3 = false
      c175v4 = vT[36]
      if c175v2 ~= c175v4 then
        c175v4 = vT[38]
        if c175v2 == c175v4 then
          c175v3 = false
        else
          c175v3 = true
        end
      end
    end
    do return c175v3 end
  end
  vT[90] = function(c176v0)
    local c176v1
    c176v1 = vT[89]
    do return c176v1(c176v0) end
  end
  CanOverridePostNewWar = vT[90]
  vT[90] = function(c177v0)
    local c177v1, c177v2, c177v3, c177v4, c177v5, c177v6
    if not c177v0 then
      do return end
    end
    c177v2 = c177v0.location
    c177v1 = tostring
    c177v1 = c177v1(c177v2)
    c177v3 = POST_NEW_WAR_MISSIONS
    c177v2 = c177v3[c177v1]
    if not c177v2 then
      do return end
    end
    c177v3 = vT[89]
    c177v3 = c177v3(c177v1)
    if c177v0 then
      local p27 = 5
      if p27 == 5 then
        c177v3 = nil
        c177v4 = c177v2.goalTag
        if not c177v4 then
          p27 = 8
        else
          p27 = 6
        end
      end
      if p27 == 6 then
        c177v4 = c177v2.goalTag
        c177v5 = Symbol
        c177v6 = "PostOldPeace"
        c177v5 = c177v5(c177v6)
        if c177v4 ~= c177v5 then
          p27 = 8
        else
          p27 = 7
        end
      end
      if p27 == 7 then
        c177v4 = vT[88]
        c177v3 = c177v4()
        p27 = 9
      end
      if p27 == 8 then
        c177v4 = HasSquadHostCompletedNewWar
        c177v3 = c177v4()
        p27 = 9
      end
      if p27 == 9 then
        if not c177v3 then
        else
          p27 = 10
        end
      end
      if p27 == 10 then
        c177v5 = c177v2.levelOverride
        c177v4 = IsNull
        c177v4 = c177v4(c177v5)
        if c177v4 then
          p27 = 12
        else
          p27 = 11
        end
      end
      if p27 == 11 then
        c177v4 = c177v2.levelOverride
        c177v0.levelOverride = c177v4
        p27 = 12
      end
      if p27 == 12 then
        c177v4 = c177v2.goalTag
        if not c177v4 then
          p27 = 14
        else
          p27 = 13
        end
      end
      if p27 == 13 then
        c177v4 = c177v2.goalTag
        c177v0.goalTag = c177v4
        p27 = 14
      end
      if p27 == 14 then
        c177v4 = c177v2.extraEnemySpec
        if not c177v4 then
        else
          p27 = 15
        end
      end
      if p27 == 15 then
        c177v4 = Resource
        c177v5 = c177v2.extraEnemySpec
        c177v4 = c177v4(c177v5)
        c177v0.extraEnemySpec = c177v4
      end
    end
    do return end
  end
  vT[91] = function(c178v0)
    local c178v1
    c178v1 = vT[90]
    c178v1(c178v0)
    do return end
  end
  ApplyPostNewWarMissionOverrides = vT[91]
  vT[91] = function(c179v0, c179v1)
    local c179v2, c179v3, c179v4, c179v5, c179v6, c179v9
    c179v2 = _T.QuestAdditionalContextObjects
    c179v2 = pairs
    c179v3 = _T.QuestAdditionalContextObjects
    c179v2, c179v3, c179v4 = c179v2(c179v3)
    for c179v5, c179v6 in c179v2, c179v3, c179v4 do
      c179v9 = WeakResource
      c179v1:AddContextObject(c179v9(c179v6))
    end
    for c179v5, c179v6 in c179v2, c179v3, c179v4 do
    end
    c179v2 = vT[57]
    c179v2 = c179v2()
    c179v2:SetLevelStreamingArgs(c179v0, c179v1)
    if not c179v0 then
      do return end
    end
    c179v3 = POST_NEW_WAR_MISSIONS
    c179v4 = tostring
    c179v4 = c179v4(c179v0)
    c179v2 = c179v3[c179v4]
    if c179v2 then
      c179v3 = HasSquadHostCompletedNewWar
      c179v3 = c179v3()
      if c179v3 then
        c179v3 = c179v2.streamingOffset
        if c179v3 then
          c179v5 = c179v2.streamingOffset
          c179v6 = Rotation
          c179v1:SetStreamingOffset(c179v5, c179v6())
        end
        do return end
      end
    end
    do return end
  end
  SetLevelStreamingArgs = vT[91]
  vT[91] = function(c180v0, c180v1)
    local c180v2, c180v3, c180v4
    if c180v1 then
      c180v3 = POST_NEW_WAR_MISSIONS
      c180v2 = c180v3[c180v1]
      if c180v2 then
        c180v2 = HasSquadHostCompletedNewWar
        c180v2 = c180v2()
        if c180v2 then
          c180v4 = "Alt"
          c180v0:AddContextTag(c180v4)
        end
        do return end
      end
    end
    do return end
  end
  ApplyPostNewWarHubLevelArgs = vT[91]
  vT[91] = function(c181v0)
    local c181v1, c181v2, c181v4
    c181v2 = string.find
    c181v4 = NEMESIS_MISSION_TAG
    c181v2 = c181v2(c181v0, c181v4)
    if c181v2 == nil then
      c181v1 = false
    else
      c181v1 = true
    end
    do return c181v1 end
  end
  IsNemesisNode = vT[91]
  vT[91] = function(c182v0, c182v1)
    local c182v2, c182v3, c182v4, c182v5, c182v6, c182v7
    if not c182v0 then
      c182v2 = false
      do return c182v2 end
    end
    c182v2 = c182v0
    c182v3 = string.find
    c182v5 = TAG_SEPERATOR
    c182v3 = c182v3(c182v2, c182v5)
    if c182v3 then
      c182v6 = 1
      c182v7 = c182v3 - 1
      c182v4 = string.sub
      c182v2 = c182v4(c182v2, c182v6, c182v7)
    end
    c182v6 = 1
    c182v4 = #c182v1
    c182v5 = 1
    for c182v6 = c182v6, c182v4, c182v5 do
      c182v7 = c182v1[c182v6]
      if c182v7 == c182v2 then break end
      if c182v7 == c182v2 then
        c182v7 = true
        do return c182v7 end
      end
    end
    c182v4 = false
    do return c182v4 end
  end
  IsNodeInList = vT[91]
  vT[91] = function(c183v0)
    local c183v1, c183v2, c183v3, c183v4
    c183v1 = IsNodeInList
    c183v3 = DUVIRI_MISSION_NODES
    c183v1 = c183v1(c183v0, c183v3)
    if c183v1 then
      c183v1 = true
      do return c183v1 end
    end
    c183v1 = false
    if c183v0 ~= nil then
      c183v2 = string.find
      c183v4 = "Duviri"
      c183v2 = c183v2(c183v0, c183v4)
      if c183v2 == nil then
        c183v1 = false
      else
        c183v1 = true
      end
    end
    do return c183v1 end
  end
  IsDuviriNode = vT[91]
  vT[91] = function(c184v0)
    local c184v1
    if c184v0 ~= nil then
      c184v1 = DUVIRI_ENDLESS_NODE
      if c184v0 == c184v1 then
        c184v1 = false
        do return c184v1 end
      end
    end
    c184v1 = IsDuviriNode
    do return c184v1(c184v0) end
  end
  IsNonEndlessDuviriNode = vT[91]
  vT[91] = function(c185v0)
    local c185v1, c185v3
    c185v1 = IsNodeInList
    c185v3 = ENTRATI_LAB_MISSION_NODES
    do return c185v1(c185v0, c185v3) end
  end
  IsEntratiLabNode = vT[91]
  vT[91] = function(c186v0)
    local c186v1, c186v3
    c186v1 = IsNodeInList
    c186v3 = VANIA_MISSION_NODES
    do return c186v1(c186v0, c186v3) end
  end
  IsVaniaNode = vT[91]
  vT[91] = function(c187v0)
    local c187v1, c187v3
    c187v1 = IsNodeInList
    c187v3 = ZARIMAN_MISSION_NODES
    do return c187v1(c187v0, c187v3) end
  end
  IsZarimanNode = vT[91]
  vT[91] = function(c188v0)
    local c188v1, c188v2
    c188v2 = NOKKO_COLONY_NODE_TAG
    if c188v0 ~= c188v2 then
      c188v1 = false
    else
      c188v1 = true
    end
    if c188v1 then
      c188v2 = true
      do return c188v2 end
    end
    c188v2 = false
    do return c188v2 end
  end
  IsNokkoColonyNode = vT[91]
  vT[91] = function(c189v0, c189v1)
    local c189v2, c189v3, c189v4, c189v5, c189v6, c189v7
    c189v3 = POST_NEW_WAR_MISSIONS
    c189v4 = tostring
    c189v4 = c189v4(c189v0)
    c189v2 = c189v3[c189v4]
    if not c189v2 then
      do return c189v1 end
    end
    c189v4 = vT[17]
    c189v4 = c189v4.Ternary
    c189v5 = HasCompletedNewWar
    c189v5 = c189v5()
    c189v6 = PLAINS_ELO_POST_NEW_WAR_OFFSET
    c189v7 = 0
    c189v4 = c189v4(c189v5, c189v6, c189v7)
    c189v3 = c189v1 + c189v4
    do return c189v3 end
  end
  GetModifiedPlainsElo = vT[91]
  vT[91] = function(c190v0)
    local c190v1, c190v2
    c190v2 = IsDuviriNode
    c190v2 = c190v2(c190v0)
    c190v1 = not c190v2
    do return c190v1 end
  end
  ShouldUsePlainsElo = vT[91]
  vT[91] = function(c191v0, c191v1)
    local c191v2, c191v3, c191v4
    c191v2 = true
    if c191v0 ~= c191v1 then
      c191v4 = PLAINS_ELO_POST_NEW_WAR_OFFSET
      c191v3 = c191v1 + c191v4
      if c191v0 ~= c191v3 then
        c191v2 = false
      else
        c191v2 = true
      end
    end
    do return c191v2 end
  end
  IsPlainsElo = vT[91]
  vT[91] = function()
    local c192v0, c192v1, c192v2, c192v3, c192v4, c192v5, c192v6, c192v7, c192v8, c192v9, c192v10
    c192v1 = gGameData
    c192v0 = IsNull
    c192v0 = c192v0(c192v1)
    c192v0 = gGameData
    c192v0 = c192v0:GetInventory()
    c192v1 = c192v0:GetQuestKeys()
    c192v2 = c192v0:GetActiveQuest()
    c192v3 = pairs
    c192v3, c192v4, c192v5 = c192v3(c192v1)
    for c192v6, c192v7 in c192v3, c192v4, c192v5 do
      c192v8 = c192v7.mItemType
      c192v9 = vT[33]
      if c192v8 == c192v9 then
        c192v8 = c192v7.mCompleted
        if not c192v8 then
          c192v8 = false
          c192v9 = vT[33]
          if c192v2 == c192v9 then
            c192v10 = c192v7.mProgress
            c192v9 = #c192v10
            c192v10 = 0
            if c192v9 <= c192v10 then
              c192v8 = false
            else
              c192v8 = true
            end
          end
        end
        do return c192v8 end
      end
    end
    for c192v6, c192v7 in c192v3, c192v4, c192v5 do
    end
    c192v0 = false
    do return c192v0 end
  end
  CanAccessDeimosHub = vT[91]
  vT[91] = function()
    local c193v0, c193v1
    c193v0 = vT[87]
    c193v1 = vT[33]
    do return c193v0(c193v1) end
  end
  vT[92] = function()
    local c194v0
    c194v0 = vT[91]
    do return c194v0() end
  end
  HasCompletedDeimosIntroQuest = vT[92]
  vT[92] = function()
    local c195v0, c195v1
    c195v0 = vT[87]
    c195v1 = vT[34]
    do return c195v0(c195v1) end
  end
  vT[93] = function()
    local c196v0
    c196v0 = vT[92]
    do return c196v0() end
  end
  HasCompleted1999Quest = vT[93]
  vT[93] = function(c197v0, c197v1)
    local c197v2, c197v3
    c197v2 = false
    c197v3 = APARTMENT_NODE_TAG
    if c197v0 ~= c197v3 then
      c197v3 = IsDuviriNode
      c197v3 = c197v3(c197v1)
      c197v2 = not c197v3
      if c197v2 then
        c197v3 = IsVaniaNode
        c197v3 = c197v3(c197v1)
        c197v2 = not c197v3
        if c197v2 then
          c197v3 = IsEntratiLabNode
          c197v3 = c197v3(c197v1)
          c197v2 = not c197v3
          if c197v2 then
            c197v3 = IsZarimanNode
            c197v3 = c197v3(c197v1)
            c197v2 = not c197v3
            if c197v2 then
              c197v3 = IsNokkoColonyNode
              c197v3 = c197v3(c197v0)
              c197v2 = not c197v3
              if c197v2 then
                c197v3 = IsTauBattleMission
                c197v3 = c197v3(c197v1)
                c197v2 = not c197v3
                if c197v2 then
                  c197v3 = IsDescentMission
                  c197v3 = c197v3(c197v1)
                  c197v2 = not c197v3
                end
              end
            end
          end
        end
      end
    end
    do return c197v2 end
  end
  vT[94] = function()
    local c198v0, c198v1, c198v2, c198v3, c198v4, c198v5, c198v6, c198v7, c198v8, c198v9, c198v10, c198v11, c198v12, c198v13, c198v14, c198v15, c198v16, c198v17, c198v18, c198v19, c198v20, c198v21, c198v22, c198v23
    c198v0 = _T.CachedStarChartProgress
    if c198v0 then
      c198v0 = _T.CachedStarChartProgress.numCompleted
      c198v1 = _T.CachedStarChartProgress.totalMissions
      c198v2 = _T.CachedStarChartProgress.missingNodes
      c198v3 = _T.CachedStarChartProgress.numHardCompleted
      c198v4 = _T.CachedStarChartProgress.missionXp
      c198v5 = _T.CachedStarChartProgress.hardMissionXp
      do return c198v0, c198v1, c198v2, c198v3, c198v4, c198v5 end
    end
    c198v0 = nil
    c198v2 = gGameData
    c198v1 = IsNull
    c198v1 = c198v1(c198v2)
    if not c198v1 then
      c198v1 = gGameData
      c198v0 = c198v1:GetMissions()
    else
      c198v0 = {}
      c198v2 = gPlayerProfileMgr
      c198v1 = IsNull
      c198v1 = c198v1(c198v2)
      if not c198v1 then
        c198v1 = gPlayerProfileMgr
        c198v3 = 0
        c198v1 = c198v1:GetPlayerProfile(c198v3)
        c198v2 = IsNull
        c198v2 = c198v2(c198v1)
        if not c198v2 then
          c198v2 = c198v1:GetGameSpecificData()
          c198v3 = IsNull
          c198v3 = c198v3(c198v2)
          if not c198v3 then
            c198v0 = c198v2:GetMissions()
          end
        end
      end
    end
    c198v1 = {}
    c198v2 = 0
    c198v3 = pairs
    c198v3, c198v4, c198v5 = c198v3(c198v0)
    for c198v6, c198v7 in c198v3, c198v4, c198v5 do
      c198v8 = c198v7.mTag
      c198v8 = c198v8:IsValid()
      if c198v8 then
        c198v9 = c198v7.mTag
        c198v8 = tostring
        c198v8 = c198v8(c198v9)
        c198v9 = c198v7.mTier
        c198v1[c198v8] = c198v9
      end
    end
    c198v3 = vT[57]
    c198v3 = c198v3()
    c198v4 = c198v3:GetAllNodes()
    c198v5 = 0
    c198v6 = 0
    c198v7 = {}
    c198v8 = pairs
    c198v8, c198v9, c198v10 = c198v8(c198v4)
    for c198v11, c198v12 in c198v8, c198v9, c198v10 do
      c198v13 = ResetLineCount
      c198v14 = 0
      c198v13(c198v14)
      c198v13 = c198v12.name
      c198v14 = tostring
      c198v14 = c198v14(c198v13)
      c198v17 = false
      c198v15 = c198v12:Name__caf3571d(c198v17)
      if c198v15 then
        c198v15 = vT[93]
        c198v15 = c198v15(c198v13, c198v14)
        if c198v15 then
          c198v5 = c198v5 + 1
          c198v15 = c198v1[c198v14]
          if c198v15 ~= nil then
            c198v6 = c198v6 + 1
            c198v15 = c198v1[c198v14]
            c198v16 = 0
            if c198v16 < c198v15 then
              c198v2 = c198v2 + 1
            end
          else
            c198v17 = { name = nil, locTag = nil, node = nil }
            c198v18 = Symbol
            c198v19 = c198v12.name
            c198v18 = c198v18(c198v19)
            c198v17.name = c198v18
            c198v18 = Symbol
            c198v19 = c198v12.locTag
            c198v18 = c198v18(c198v19)
            c198v17.locTag = c198v18
            c198v17.node = c198v12
            c198v15 = table.insert
            c198v15(c198v7, c198v17)
          end
        end
      end
    end
    c198v11 = 0
    c198v8 = c198v3:Name__4d399061(c198v0, c198v11)
    c198v12 = 1
    c198v9 = c198v3:Name__4d399061(c198v0, c198v12)
    c198v10 = _T
    c198v11 = { numCompleted = nil, totalMissions = nil, missingNodes = nil, numHardCompleted = nil, missionXp = nil, hardMissionXp = nil }
    c198v11.numCompleted = c198v6
    c198v11.totalMissions = c198v5
    c198v12 = vT[17]
    c198v12 = c198v12.CopyTable
    c198v12 = c198v12(c198v7)
    c198v11.missingNodes = c198v12
    c198v11.numHardCompleted = c198v2
    c198v11.missionXp = c198v8
    c198v11.hardMissionXp = c198v9
    c198v10.CachedStarChartProgress = c198v11
    c198v10 = #c198v7
    c198v11 = 10
    c198v10 = ResetLineCount
    c198v10()
    c198v10 = ""
    c198v11 = pairs
    c198v11, c198v12, c198v13 = c198v11(c198v7)
    for c198v14, c198v15 in c198v11, c198v12, c198v13 do
      c198v20 = c198v15.name
      c198v19 = tostring
      c198v17 = c198v19(c198v20)
      c198v18 = ", "
      c198v10 = c198v10 .. c198v17 .. c198v18
    end
    c198v11 = print
    c198v13 = "StarChartProgress: "
    c198v15 = " / "
    c198v17 = " missions completed, "
    c198v19 = " / "
    c198v21 = " steel path completed, "
    c198v22 = #c198v7
    c198v23 = " missing node(s)"
    c198v12 = c198v13 .. c198v6 .. c198v15 .. c198v5 .. c198v17 .. c198v2 .. c198v19 .. c198v5 .. c198v21 .. c198v22 .. c198v23
    c198v11(c198v12)
    c198v11 = #c198v7
    c198v12 = 0
    if c198v12 < c198v11 then
      c198v11 = print
      c198v11(c198v10)
    end
    for c198v14, c198v15 in c198v11, c198v12, c198v13 do
    end
    do return c198v6, c198v5, c198v7, c198v2, c198v8, c198v9 end
  end
  vT[95] = function()
    local c199v0
    c199v0 = vT[94]
    do return c199v0() end
  end
  GetStarChartProgress = vT[95]
  vT[95] = function()
    local c200v0, c200v1, c200v2, c200v3, c200v4, c200v5
    c200v0 = vT[94]
    c200v0, c200v1, c200v2, c200v3, c200v4 = c200v0()
    c200v5 = true
    if c200v0 ~= c200v1 then
      c200v5 = false
    end
    do return c200v5, c200v2 end
  end
  vT[96] = function()
    local c201v0
    c201v0 = vT[95]
    do return c201v0() end
  end
  HasCompletedStarChart = vT[96]
  vT[96] = function(c202v0)
    local c202v1, c202v2, c202v3, c202v4, c202v5, c202v6, c202v7, c202v8, c202v10, c202v11, c202v12
    local c43 = -1
    repeat
      local c42 = -1
      repeat
        c202v5 = c202v2.mFlashSales
        c202v6 = ipairs
        c202v6, c202v7, c202v8 = c202v6(c202v5)
        for c202v9, c202v10 in c202v6, c202v7, c202v8 do
          c202v12 = c202v10.mTypeName
          c202v11 = IsNull
          c202v11 = c202v11(c202v12)
          c202v11 = c202v10.mTypeName
          c202v11 = c202v11:GetFullName()
          c202v12 = c202v3:GetFullName()
          c202v11 = Engine.Name__b38e1642
          c202v12 = c202v10.mStartDate
          c202v11 = c202v11(c202v12)
          c202v12 = 0
          c202v11 = Engine.Name__b38e1642
          c202v12 = c202v10.mEndDate
          c202v11 = c202v11(c202v12)
          c202v12 = 0
          if c202v12 < c202v11 then
            c42 = 19
            break
          end
          c202v1 = gGameData
          c202v2 = IsNull
          c202v2 = c202v2(c202v1)
          if c202v2 then
            c202v2 = nil
            do return c202v2 end
          end
          c202v2 = c202v1:GetWorldState()
          c202v3 = _T.CachedFlashSales
          c202v3 = c202v2.mFlashSales
          c202v4 = _T
          c202v5 = {}
          c202v4.CachedFlashSales = c202v5
          c202v4 = ipairs
          c202v4, c202v5, c202v6 = c202v4(c202v3)
          for c202v7, c202v8 in c202v4, c202v5, c202v6 do
            c202v10 = c202v8.mTypeName
            c202v9 = IsNull
            c202v9 = c202v9(c202v10)
            if not c202v9 then
              c202v9 = _T.CachedFlashSales
              c202v10 = c202v8.mTypeName
              c202v10 = c202v10:GetFullName()
              c202v9[c202v10] = c202v8
            end
          end
          if c42 ~= -1 then break end
          for c202v7, c202v8 in c202v4, c202v5, c202v6 do
          end
          if c42 ~= -1 then break end
          c202v3 = _T.CachedFlashSales
          if c202v3 == nil then
            c202v3 = nil
            do return c202v3 end
          end
          c202v3 = nil
          c202v4 = c202v0:IsPackage()
          if c202v4 then
            c202v3 = c202v0
          else
            c202v3 = c202v0:GetItem()
            c202v4 = IsNull
            c202v4 = c202v4(c202v3)
            if c202v4 then
              c202v4 = nil
              do return c202v4 end
            end
          end
          c202v5 = _T.CachedFlashSales
          c202v6 = c202v3:GetFullName()
          c202v4 = c202v5[c202v6]
          c202v5 = IsNull
          c202v5 = c202v5(c202v4)
          if c202v5 then
            c42 = 25
            break
          end
        end
        if c42 ~= -1 then break end
        break
      until true
      if c42 == 19 then
        c202v4 = c202v10
        c202v11 = _T.CachedFlashSales
        c202v12 = c202v10.mTypeName
        c202v12 = c202v12:GetFullName()
        c202v11[c202v12] = c202v4
        c43 = 21
        do break end
      end
      break
    until true
    if c43 == 21 then
      c202v6 = Engine.Name__b38e1642
      c202v7 = c202v4.mStartDate
      c202v6 = c202v6(c202v7)
      c202v7 = 0
      if c202v6 < c202v7 then
        c202v6 = Engine.Name__b38e1642
        c202v7 = c202v4.mEndDate
        c202v6 = c202v6(c202v7)
        c202v7 = 0
        if c202v7 < c202v6 then
          c202v6 = c202v4.mShowInMarket
          if c202v6 then
            do return c202v4 end
          end
        end
      end
    end
    c202v5 = nil
    do return c202v5 end
  end
  vT[97] = function(c203v0)
    local c203v1
    c203v1 = vT[96]
    c203v1 = c203v1(c203v0)
    do return c203v1 end
  end
  GetSaleInfo = vT[97]
  vT[97] = {}
  vT[98] = 3
  vT[99] = true
  vT[97][vT[98]] = vT[99]
  vT[98] = 1
  vT[99] = true
  vT[97][vT[98]] = vT[99]
  vT[98] = 0
  vT[99] = true
  vT[97][vT[98]] = vT[99]
  vT[98] = 5
  vT[99] = true
  vT[97][vT[98]] = vT[99]
  vT[98] = 15
  vT[99] = true
  vT[97][vT[98]] = vT[99]
  vT[98] = 16
  vT[99] = true
  vT[97][vT[98]] = vT[99]
  vT[98] = 6
  vT[99] = true
  vT[97][vT[98]] = vT[99]
  vT[98] = 10
  vT[99] = true
  vT[97][vT[98]] = vT[99]
  vT[98] = 27
  vT[99] = true
  vT[97][vT[98]] = vT[99]
  vT[98] = 28
  vT[99] = true
  vT[97][vT[98]] = vT[99]
  vT[98] = 29
  vT[99] = true
  vT[97][vT[98]] = vT[99]
  vT[98] = 13
  vT[99] = true
  vT[97][vT[98]] = vT[99]
  vT[98] = 42
  vT[99] = true
  vT[97][vT[98]] = vT[99]
  vT[98] = 21
  vT[99] = true
  vT[97][vT[98]] = vT[99]
  vT[98] = 48
  vT[99] = true
  vT[97][vT[98]] = vT[99]
  vT[98] = 30
  vT[99] = true
  vT[97][vT[98]] = vT[99]
  vT[98] = 52
  vT[99] = true
  vT[97][vT[98]] = vT[99]
  vT[98] = 51
  vT[99] = true
  vT[97][vT[98]] = vT[99]
  vT[98] = 32
  vT[99] = true
  vT[97][vT[98]] = vT[99]
  vT[98] = 9
  vT[99] = nil
  vT[97][vT[98]] = vT[99]
  vT[98] = 11
  vT[99] = nil
  vT[97][vT[98]] = vT[99]
  vT[98] = 25
  vT[99] = nil
  vT[97][vT[98]] = vT[99]
  vT[98] = 26
  vT[99] = nil
  vT[97][vT[98]] = vT[99]
  vT[98] = 14
  vT[99] = nil
  vT[97][vT[98]] = vT[99]
  vT[98] = 2
  vT[99] = nil
  vT[97][vT[98]] = vT[99]
  vT[98] = 4
  vT[99] = nil
  vT[97][vT[98]] = vT[99]
  vT[98] = 8
  vT[99] = nil
  vT[97][vT[98]] = vT[99]
  vT[98] = 35
  vT[99] = nil
  vT[97][vT[98]] = vT[99]
  vT[98] = 19
  vT[99] = nil
  vT[97][vT[98]] = vT[99]
  vT[98] = 2
  vT[99] = nil
  vT[97][vT[98]] = vT[99]
  vT[98] = function(c204v0)
    local c204v1, c204v3, c204v4
    local c204v2 = IsNull
    c204v2 = c204v2(c204v0)
    c204v1 = not c204v2
    if c204v1 then
      c204v1 = false
      c204v2 = c204v0:GetProductCategory()
      c204v3 = 11
      if c204v2 == c204v3 then
        c204v2 = string.find
        c204v3 = c204v0:GetFullName()
        c204v4 = "OperatorAmplifiers"
        c204v2 = c204v2(c204v3, c204v4)
        if c204v2 == nil then
          c204v1 = false
        else
          c204v1 = true
        end
      end
    end
    do return c204v1 end
  end
  vT[99] = function(c205v0)
    local c205v1, c205v2, c205v3, c205v4
    c205v2 = IsNull
    c205v2 = c205v2(c205v0)
    c205v1 = not c205v2
    if c205v1 then
      c205v1 = true
      c205v3 = vT[97]
      c205v4 = c205v0:GetProductCategory()
      c205v2 = c205v3[c205v4]
      if c205v2 == nil then
        c205v1 = vT[98]
        c205v1 = c205v1(c205v0)
      end
    end
    do return c205v1 end
  end
  vT[100] = function(c206v0)
    local c206v1
    c206v1 = vT[99]
    c206v1 = c206v1(c206v0)
    do return c206v1 end
  end
  IsProratedPackageCategory = vT[100]
  vT[100] = function(c207v0)
    do return c207v0 end
  end
  vT[101] = function(c208v0, c208v1)
    local c208v2
    if c208v1 <= c208v0 then
      c208v2 = false
    else
      c208v2 = true
    end
    do return c208v2 end
  end
  vT[102] = function(c209v0, c209v1)
    local c209v2
    if c209v0 <= c209v1 then
      c209v2 = false
    else
      c209v2 = true
    end
    do return c209v2 end
  end
  vT[103] = function(c210v0, c210v1, c210v2, c210v3)
    local c210v4, c210v5, c210v6, c210v7, c210v8, c210v9, c210v10, c210v11, c210v12
    local p35 = 0
    if p35 == 0 then
      c210v4 = c210v2
      if c210v4 then
        p35 = 2
      else
        p35 = 1
      end
    end
    if p35 == 1 then
      c210v4 = vT[100]
      p35 = 2
    end
    if p35 == 2 then
      c210v2 = c210v4
      if not c210v3 then
        p35 = 4
      else
        p35 = 3
      end
    end
    if p35 == 3 then
      c210v4 = vT[102]
      if c210v4 then
        p35 = 5
      else
        p35 = 4
      end
    end
    if p35 == 4 then
      c210v4 = vT[101]
      p35 = 5
    end
    if p35 == 5 then
      c210v5 = 1
      c210v6 = #c210v0
      c210v7 = 0
      p35 = 6
    end
    while p35 == 6 or p35 == 7 or p35 == 15 or p35 == 16 or p35 == 17 or p35 == 18 do
      if p35 == 6 then
        if c210v6 < c210v5 then
          p35 = 19
        else
          p35 = 7
        end
      end
      if p35 == 7 then
        c210v10 = c210v5 + c210v6
        c210v9 = c210v10 / 2
        c210v8 = math.floor
        c210v7 = c210v8(c210v9)
        c210v9 = c210v0[c210v7]
        c210v8 = c210v2(c210v9)
        if c210v1 ~= c210v8 then
          p35 = 15
        else
          p35 = 8
        end
      end
      if p35 == 15 then
        c210v9 = c210v4(c210v1, c210v8)
        if not c210v9 then
          p35 = 17
        else
          p35 = 16
        end
      end
      if p35 == 16 then
        c210v6 = c210v7 - 1
        p35 = 18
      end
      if p35 == 17 then
        c210v5 = c210v7 + 1
        p35 = 18
      end
      if p35 == 18 then
        p35 = 6
      end
    end
    if p35 == 8 then
      c210v9 = {c210v7, c210v7}
      c210v10 = c210v7 - 1
      p35 = 9
    end
    while p35 == 9 or p35 == 10 do
      if p35 == 9 then
        c210v12 = c210v0[c210v10]
        c210v11 = c210v2(c210v12)
        if c210v1 ~= c210v11 then
          p35 = 11
        else
          p35 = 10
        end
      end
      if p35 == 10 then
        c210v11 = c210v10 - 1
        c210v9[1] = c210v10
        c210v10 = c210v11
        p35 = 9
      end
    end
    if p35 == 11 then
      c210v10 = c210v7 + 1
      p35 = 12
    end
    while p35 == 12 or p35 == 13 do
      if p35 == 12 then
        c210v12 = c210v0[c210v10]
        c210v11 = c210v2(c210v12)
        if c210v1 ~= c210v11 then
          p35 = 14
        else
          p35 = 13
        end
      end
      if p35 == 13 then
        c210v11 = c210v10 + 1
        c210v9[2] = c210v10
        c210v10 = c210v11
        p35 = 12
      end
    end
    if p35 == 14 then
      do return c210v9 end
    end
    if p35 == 19 then
      do return end
    end
  end
  vT[104] = function(c211v0, c211v1, c211v2, c211v3)
    local c211v4
    c211v4 = vT[103]
    do return c211v4(c211v0, c211v1, c211v2, c211v3) end
  end
  BinarySearch = vT[104]
  vT[104] = function(c212v0)
    local c212v1
    if c212v0 then
      c212v1 = c212v0.type
      do return c212v1 end
    end
    c212v1 = nil
    do return c212v1 end
  end
  vT[105] = function(c213v0, c213v1, c213v2, c213v3)
    local c213v4, c213v5, c213v6, c213v7, c213v8, c213v9, c213v10, c213v11, c213v12, c213v14, c213v15, c213v16, c213v17
    c213v8 = 1
    c213v6 = #c213v4
    c213v7 = 1
    for c213v8 = c213v8, c213v6, c213v7 do
      c213v9 = c213v4[c213v8]
      c213v9 = c213v9:Name__b7ad1ab2()
      if c213v9 then
        c213v10 = c213v4[c213v8]
        if c213v10 ~= c213v2 then
          c213v10 = GetStoreItemPriceObject
          c213v11 = c213v4[c213v8]
          c213v12 = nil
          c213v14 = false
          c213v15 = nil
          c213v16 = nil
          c213v17 = false
          c213v10 = c213v10(c213v11, c213v12, c213v3, c213v14, c213v15, c213v16, c213v17, c213v0)
          c213v11 = c213v10.UsePrice
          c213v12 = 0
          if c213v12 < c213v11 then break end
          if c213v12 < c213v11 then
            c213v11 = true
            do return c213v11 end
          end
        end
      end
    end
    c213v4 = IsNull
    c213v4 = c213v4(c213v0)
    if c213v4 then
      c213v4 = nil
      do return c213v4 end
    end
    c213v4 = c213v0:Name__a741415e(c213v1)
    c213v5 = false
    if c213v4 ~= nil then
      c213v6 = #c213v4
      c213v7 = 0
      if c213v6 <= c213v7 then
        c213v5 = false
      else
        c213v5 = true
      end
    end
    c213v6 = nil
    do return c213v6 end
  end
  vT[106] = function(c214v0)
    local c214v1, c214v2, c214v3, c214v4, c214v5, c214v6, c214v7, c214v8, c214v9, c214v10, c214v11, c214v12, c214v13, c214v14
    c214v1 = IsNull
    c214v1 = c214v1(c214v0)
    if c214v1 then
      c214v1 = false
      do return c214v1 end
    end
    c214v1 = _T.CachedGiftRewardMap
    if not c214v1 then
      c214v1 = gGameRules
      c214v1 = c214v1:GetStoreManifest()
      c214v2 = IsNull
      c214v2 = c214v2(c214v1)
      if c214v2 then
        c214v2 = false
        do return c214v2 end
      end
      c214v2 = c214v1:GetGiftBonusItems()
      c214v3 = _T
      c214v4 = {}
      c214v3.CachedGiftRewardMap = c214v4
      c214v5 = 1
      c214v3 = #c214v2
      c214v4 = 1
      for c214v5 = c214v5, c214v3, c214v4 do
        c214v6 = c214v2[c214v5]
        c214v6 = c214v6.reward
        c214v7 = IsNull
        c214v7 = c214v7(c214v6)
        c214v7 = _T.CachedGiftRewardMap
        c214v8 = c214v6:GetFullName()
        c214v9 = true
        c214v7[c214v8] = c214v9
        c214v7 = c214v6:IsPackage()
        c214v7 = c214v6:GetPackageComponents()
        c214v10 = 1
        c214v8 = #c214v7
        c214v9 = 1
        for c214v10 = c214v10, c214v8, c214v9 do
          c214v11 = c214v7[c214v10]
          c214v11 = c214v11.mTypeName
          c214v12 = IsNull
          c214v12 = c214v12(c214v11)
          if not c214v12 then
            c214v12 = _T.CachedGiftRewardMap
            c214v13 = c214v11:GetFullName()
            c214v14 = true
            c214v12[c214v13] = c214v14
          end
        end
      end
    end
    c214v1 = _T.CachedGiftRewardMap
    if c214v1 ~= nil then
      c214v2 = _T.CachedGiftRewardMap
      c214v3 = c214v0:GetFullName()
      c214v1 = c214v2[c214v3]
      if c214v1 ~= nil then
        c214v1 = true
        do return c214v1 end
      end
    end
    c214v1 = false
    do return c214v1 end
  end
  vT[107] = function(c215v0, c215v1)
    local c215v2, c215v3, c215v4, c215v5, c215v6, c215v7, c215v8, c215v9, c215v10, c215v11
    c215v2 = c215v0:GetItemName()
    c215v3 = false
    c215v6 = gVoidProjectionItemType
    c215v4 = c215v0:IsA(c215v6)
    if c215v4 then
      c215v4 = c215v2
      c215v5 = string.gsub
      c215v7 = "Bronze"
      c215v8 = ""
      c215v4 = c215v5(c215v4, c215v7, c215v8)
      c215v5 = string.gsub
      c215v7 = "Silver"
      c215v8 = ""
      c215v4 = c215v5(c215v4, c215v7, c215v8)
      c215v5 = string.gsub
      c215v7 = "Gold"
      c215v8 = ""
      c215v4 = c215v5(c215v4, c215v7, c215v8)
      c215v5 = string.gsub
      c215v7 = "Platinum"
      c215v8 = ""
      c215v4 = c215v5(c215v4, c215v7, c215v8)
      c215v8 = "Bronze"
      c215v6 = c215v4 .. c215v8
      c215v9 = "Silver"
      c215v7 = c215v4 .. c215v9
      c215v10 = "Gold"
      c215v8 = c215v4 .. c215v10
      c215v11 = "Platinum"
      c215v9 = c215v4 .. c215v11
      c215v2 = {c215v6, c215v7, c215v8, c215v9}
    else
      c215v2 = {c215v2}
    end
    c215v6 = 1
    c215v4 = #c215v2
    c215v5 = 1
    for c215v6 = c215v6, c215v4, c215v5 do
      c215v3 = c215v7
      c215v7 = c215v3
      if not c215v7 then
        c215v7 = vT[103]
        c215v9 = c215v2[c215v6]
        c215v10 = vT[104]
        c215v7 = c215v7(c215v1, c215v9, c215v10)
      end
    end
    do return c215v3 end
  end
  vT[109] = { Part = nil, XPCheck = nil }
  vT[110] = WeakResource
  vT[111] = "/Lotus/Weapons/Sentients/OperatorAmplifiers/Set1/Chassis/SentAmpSet1ChassisPartC"
  vT[110] = vT[110](vT[111])
  vT[109].Part = vT[110]
  vT[110] = WeakResource
  vT[111] = "/Lotus/Weapons/Sentients/OperatorAmplifiers/Set1/Barrel/SentAmpSet1BarrelPartC"
  vT[110] = vT[110](vT[111])
  vT[109].XPCheck = vT[110]
  vT[110] = { Part = nil, XPCheck = nil }
  vT[111] = WeakResource
  vT[112] = "/Lotus/Weapons/Sentients/OperatorAmplifiers/Set1/Barrel/SentAmpSet1BarrelPartC"
  vT[111] = vT[111](vT[112])
  vT[110].Part = vT[111]
  vT[111] = WeakResource
  vT[112] = "/Lotus/Weapons/Sentients/OperatorAmplifiers/Set1/Barrel/SentAmpSet1BarrelPartC"
  vT[111] = vT[111](vT[112])
  vT[110].XPCheck = vT[111]
  vT[111] = { Part = nil, XPCheck = nil }
  vT[112] = WeakResource
  vT[113] = "/Lotus/Weapons/Sentients/OperatorAmplifiers/Set1/Grip/SentAmpSet1GripPartC"
  vT[112] = vT[112](vT[113])
  vT[111].Part = vT[112]
  vT[112] = WeakResource
  vT[113] = "/Lotus/Weapons/Sentients/OperatorAmplifiers/Set1/Barrel/SentAmpSet1BarrelPartC"
  vT[112] = vT[112](vT[113])
  vT[111].XPCheck = vT[112]
  vT[108] = {vT[109], vT[110], vT[111]}
  vT[109] = function(c216v0, c216v1)
    local c216v2, c216v3, c216v4, c216v5, c216v7, c216v8, c216v9, c216v10, c216v11, c216v12
    c216v8 = 1
    c216v9 = vT[108]
    local c216v6 = #c216v9
    c216v7 = 1
    for c216v8 = c216v8, c216v6, c216v7 do
      c216v10 = vT[108]
      c216v9 = c216v10[c216v8]
      c216v9 = c216v9.XPCheck
      if c216v9 == c216v2 then
        c216v12 = vT[108]
        c216v11 = c216v12[c216v8]
        c216v11 = c216v11.Part
        c216v9 = c216v5:Name__1dc35bd2(c216v11)
        c216v10 = vT[107]
        c216v10 = c216v10(c216v9, c216v1)
        if c216v10 then break end
        if c216v10 then
          c216v10 = true
          do return c216v10 end
        end
      end
    end
    c216v2 = IsNull
    c216v2 = c216v2(c216v0)
    c216v2 = IsNull
    c216v2 = c216v2(c216v0:GetItem())
    c216v8 = c216v4[c216v7]
    c216v8 = c216v8.mItemType
    c216v9 = IsNull
    c216v9 = c216v9(c216v8)
    if not ((c216v9 or c216v8 ~= c216v2)) then
      c216v10 = c216v4[c216v7]
      c216v10 = c216v10.mXP
      c216v11 = 0
      if c216v10 <= c216v11 then
        c216v9 = false
      else
        c216v9 = true
      end
      do return c216v9 end
    end
    c216v2 = vT[98]
    c216v2 = c216v2(c216v0)
    if not c216v2 then
      c216v2 = false
      do return c216v2 end
    end
    c216v2 = nil
    c216v5 = 1
    c216v6 = vT[108]
    c216v3 = #c216v6
    c216v4 = 1
    for c216v5 = c216v5, c216v3, c216v4 do
      c216v7 = vT[108]
      c216v6 = c216v7[c216v5]
      c216v6 = c216v6.Part
      c216v7 = c216v0:GetItem()
      if c216v6 == c216v7 then break end
      if c216v6 == c216v7 then
        c216v7 = vT[108]
        c216v6 = c216v7[c216v5]
        c216v2 = c216v6.XPCheck
      end
    end
    c216v3 = IsNull
    c216v3 = c216v3(c216v2)
    if c216v3 then
      c216v3 = false
      do return c216v3 end
    end
    c216v3 = gGameData
    c216v3 = c216v3:GetInventory()
    c216v4 = c216v3.mXPInfo
    c216v7 = 1
    c216v5 = #c216v4
    c216v6 = 1
    if c216v2 then
      c216v2 = false
      do return c216v2 end
    end
    c216v5 = gGameRules
    c216v5 = c216v5:GetStoreManifest()
    c216v6 = IsNull
    c216v6 = c216v6(c216v5)
    c216v6 = false
    do return c216v6 end
  end
  vT[110] = function(c217v0, c217v1, c217v2)
    local c217v3, c217v4, c217v5
    if not c217v2 then
      c217v3 = vT[99]
      c217v3 = c217v3(c217v0)
      if not c217v3 then
        c217v3 = true
        do return c217v3 end
      end
    end
    c217v3 = vT[107]
    c217v5 = c217v3(c217v0, c217v1)
    if not c217v5 then
      c217v5 = vT[109]
      c217v5 = c217v5(c217v0, c217v1)
    end
    c217v4 = not c217v5
    do return c217v4 end
  end
  vT[111] = function(c218v0, c218v1, c218v2)
    local c218v3
    c218v3 = vT[110]
    do return c218v3(c218v0, c218v1, c218v2) end
  end
  ShouldGiveFromPackage = vT[111]
  vT[111] = function()
    local c219v0
    c219v0 = true
    do return c219v0 end
  end
  ProratedBundlesEnabled = vT[111]
  vT[111] = function(c220v0)
    local c220v1, c220v2, c220v3, c220v4, c220v6
    local p23 = 0
    if p23 == 0 then
      c220v2 = gPlayerProfileMgr
      c220v1 = IsNull
      c220v1 = c220v1(c220v2)
      if c220v1 then
        p23 = 17
      else
        p23 = 1
      end
    end
    if p23 == 1 then
      c220v1 = IsNull
      c220v1 = c220v1(c220v0)
      if c220v1 then
        p23 = 17
      else
        p23 = 2
      end
    end
    if p23 == 2 then
      c220v1 = c220v0:Name__aee7462d()
      c220v1 = c220v1:IsValid()
      if not c220v1 then
        p23 = 17
      else
        p23 = 3
      end
    end
    if p23 == 3 then
      c220v1 = c220v0:Name__aee7462d()
      c220v1 = c220v1:c_str()
      c220v2 = string.find
      c220v4 = "twitch.amazon.com"
      c220v2 = c220v2(c220v1, c220v4)
      if c220v2 ~= nil then
        p23 = 5
      else
        p23 = 4
      end
    end
    if p23 == 4 then
      c220v2 = string.find
      c220v4 = "gaming.amazon.com"
      c220v2 = c220v2(c220v1, c220v4)
      if c220v2 == nil then
        p23 = 14
      else
        p23 = 5
      end
    end
    if p23 == 5 then
      c220v2 = c220v0:GetFullName()
      c220v3 = gPlayerProfileMgr
      c220v3 = c220v3:JesterInstead()
      if (not ((c220v3 == "RU" or c220v3 == "CN")) and c220v3 ~= "KR") then
        p23 = 11
      else
        p23 = 8
      end
    end
    if p23 == 8 then
      c220v4 = string.find
      c220v6 = "NoLogo"
      c220v4 = c220v4(c220v2, c220v6)
      if c220v4 then
        p23 = 17
      else
        p23 = 9
      end
    end
    if p23 == 9 then
      c220v4 = false
      do return c220v4 end
    end
    if p23 == 11 then
      c220v4 = string.find
      c220v6 = "NoLogo"
      c220v4 = c220v4(c220v2, c220v6)
      if not c220v4 then
        p23 = 17
      else
        p23 = 12
      end
    end
    if p23 == 12 then
      c220v4 = false
      do return c220v4 end
    end
    if p23 == 14 then
      c220v2 = Engine.STACKSFollies
      c220v2 = c220v2()
      if not c220v2 then
        p23 = 17
      else
        p23 = 15
      end
    end
    if p23 == 15 then
      c220v2 = string.find
      c220v4 = "store.wf.qq.com"
      c220v2 = c220v2(c220v1, c220v4)
      if c220v2 == nil then
        p23 = 17
      else
        p23 = 16
      end
    end
    if p23 == 16 then
      c220v2 = true
      do return c220v2 end
    end
    if p23 == 17 then
      c220v1 = nil
      do return c220v1 end
    end
  end
  IsTwitchOrWegameValid = vT[111]
  vT[111] = function(c221v0, c221v1, c221v2, c221v3, c221v4, c221v5, c221v6, c221v7)
    local c221v8, c221v9, c221v10, c221v11, c221v12, c221v13, c221v14, c221v15, c221v16, c221v17, c221v18, c221v19, c221v20, c221v21, c221v22, c221v23, c221v24, c221v25, c221v26, c221v27, c221v28, c221v29, c221v30, c221v31, c221v32
    local p394 = 176
    if p394 == 176 then
      local e394_393 = -1
      repeat
        c221v20 = 0
        if c221v20 < c221v19 then
          c221v14 = c221v19
        end
        c221v20 = 0
        c221v23 = 1
        c221v24 = c221v10.mTieredPremiumOverrides
        c221v21 = #c221v24
        c221v22 = 1
        if (c221v22 > 0 and c221v23 > c221v21) or (c221v22 < 0 and c221v23 < c221v21) then
          e394_393 = 177
          break
        end
        for c221v23 = c221v23, c221v21, c221v22 do
          c221v25 = c221v10.mTieredPremiumOverrides
          c221v24 = c221v25[c221v23]
          if c221v20 < c221v24 then
            c221v24 = c221v10.mTieredPremiumOverrides
            c221v20 = c221v24[c221v23]
          end
        end
        if e394_393 ~= -1 then break end
        c221v11 = c221v4.mForcePlatSale
        c221v11 = Engine.Name__b38e1642
        c221v12 = c221v4.mEndDate
        c221v11 = c221v11(c221v12)
        c221v12 = 0
        if c221v12 < c221v11 then
          e394_393 = 132
          break
        end
        c221v19 = c221v10.mDiscount
        c221v20 = 0
        c221v19 = c221v0:IsTiered()
        if not c221v19 then
          e394_393 = 183
          break
        end
        c221v20 = c221v10.mTieredPremiumOverrides
        c221v19 = #c221v20
        c221v20 = 0
        c221v20 = c221v10.mTieredRegularOverrides
        c221v19 = #c221v20
        c221v20 = 0
        if c221v19 <= c221v20 then
          e394_393 = 183
          break
        end
        if c221v1 ~= nil then
          e394_393 = 179
          break
        end
        c221v19 = 0
        c221v22 = 1
        c221v23 = c221v10.mTieredRegularOverrides
        c221v20 = #c221v23
        c221v21 = 1
        for c221v22 = c221v22, c221v20, c221v21 do
          c221v24 = c221v10.mTieredRegularOverrides
          c221v23 = c221v24[c221v22]
          if c221v19 < c221v23 then
            c221v23 = c221v10.mTieredRegularOverrides
            c221v19 = c221v23[c221v22]
          end
        end
        if e394_393 ~= -1 then break end
        c221v11 = c221v8.FinalPrice
        c221v11 = c221v11.Credits
        c221v12 = c221v8.FinalPrice
        c221v12 = c221v12.Premium
        c221v13 = { StoreItem = nil }
        c221v13.StoreItem = c221v0
        c221v14 = c221v8.ShowInMarket
        if c221v14 then
          if not ((not (c221v6 == nil) and not c221v6)) then
            c221v14 = vT[28]
            c221v14(c221v13)
            c221v14 = c221v13.Coupon
            if c221v14 ~= nil then
              c221v14 = c221v13.Coupon
              c221v14 = c221v14.mAmount
              if c221v14 ~= nil then
                c221v14 = c221v13.Coupon
                c221v14 = c221v14.mAmount
                if c221v14 ~= 0 then
                  c221v15 = c221v13.Coupon
                  c221v15 = c221v15.mExpiry
                  c221v14 = IsNull
                  c221v14 = c221v14(c221v15)
                  if not c221v14 then
                    c221v14 = Engine.Name__b38e1642
                    c221v15 = c221v13.Coupon
                    c221v15 = c221v15.mExpiry
                    c221v14 = c221v14(c221v15)
                    c221v15 = 0
                    if c221v15 < c221v14 then
                      c221v14 = c221v13.Coupon
                      c221v8.Coupon = c221v14
                      if c221v11 ~= nil then
                        c221v14 = vT[29]
                        c221v16 = c221v13.Coupon
                        c221v16 = c221v16.mAmount
                        c221v11 = c221v14(c221v11, c221v16)
                      end
                      if c221v12 ~= nil then
                        c221v14 = vT[29]
                        c221v16 = c221v13.Coupon
                        c221v16 = c221v16.mAmount
                        c221v12 = c221v14(c221v12, c221v16)
                      end
                      c221v14 = c221v8.DiscountTags
                      c221v15 = true
                      c221v14.Coupon = c221v15
                    end
                  end
                end
              end
            end
          end
        end
        c221v14 = c221v8.FinalPrice
        c221v14 = c221v14.Credits
        c221v15 = c221v8.FinalPrice
        c221v15 = c221v15.Premium
        c221v17 = IsNull
        c221v17 = c221v17(c221v10)
        c221v16 = not c221v17
        if c221v16 then
          c221v18 = c221v10.mDiscount
          c221v17 = IsNull
          c221v17 = c221v17(c221v18)
          c221v16 = not c221v17
          if c221v16 then
            c221v16 = true
            c221v17 = c221v10.mRegularOverride
            c221v18 = c221v8.OriginalPrice
            c221v18 = c221v18.Credits
            if c221v17 == c221v18 then
              c221v17 = c221v10.mPremiumOverride
              c221v18 = c221v8.OriginalPrice
              c221v18 = c221v18.Premium
              if c221v17 == c221v18 then
                c221v16 = false
              else
                c221v16 = true
              end
            end
          end
        end
        c221v17 = c221v16
        if c221v17 then
          c221v18 = c221v8.DiscountTags
          c221v18 = c221v18.Coupon
          c221v17 = not c221v18
          if not c221v17 then
            c221v18 = c221v13.Coupon
            c221v18 = c221v18.mAmount
            c221v20 = c221v10.mDiscount
            c221v19 = c221v20 / 100
            if c221v19 <= c221v18 then
              c221v17 = false
            else
              c221v17 = true
            end
          end
        end
        c221v18 = false
        if not c221v16 then
          e394_393 = 190
          break
        end
        c221v8 = { ShowInMarket = false, Rarity = nil, Sale = nil, Coupon = nil, ExternalProduct = nil, UsePremium = false, UsePrice = 0, UseOriginalPrice = 0, OriginalPrice = nil, ProratedPrice = nil, FinalPrice = nil, ProratedPercent = 0, FinalDiscountPercent = 0, DiscountPercent = 0, DiscountTags = nil, ProratedItems = nil }
        c221v8.Rarity = c221v1
        c221v9 = { Premium = 0, Credits = 0 }
        c221v8.OriginalPrice = c221v9
        c221v9 = { Premium = 0, Credits = 0 }
        c221v8.ProratedPrice = c221v9
        c221v9 = { Premium = 0, Credits = 0 }
        c221v8.FinalPrice = c221v9
        c221v9 = { Coupon = nil, Sale = nil, PriceOverride = nil, Darvo = nil, Prorated = nil }
        c221v8.DiscountTags = c221v9
        c221v9 = {}
        c221v8.ProratedItems = c221v9
        c221v9 = IsNull
        c221v9 = c221v9(c221v0)
        c221v9 = c221v0:Name__b7ad1ab2()
        c221v11 = c221v8.OriginalPrice
        c221v11 = c221v11.Premium
        c221v12 = 0
        c221v11 = c221v8.OriginalPrice
        c221v11 = c221v11.Credits
        c221v12 = 0
        c221v11 = c221v0:GetRegularValue()
        c221v12 = c221v0:Name__efb43695()
        c221v13 = 0
        c221v14 = 0
        c221v15 = c221v0:GetPackageComponents()
        c221v16 = true
        c221v19 = 1
        c221v17 = #c221v15
        c221v18 = 1
        for c221v19 = c221v19, c221v17, c221v18 do
          c221v22 = IsNull
          c221v22 = c221v22(c221v2)
          c221v22 = vT[110]
          c221v22 = c221v22(c221v20, c221v2, c221v21)
          c221v22 = GetStoreItemPriceObject
          c221v24 = c221v15[c221v19]
          c221v24 = c221v24.mDurability
          c221v26 = false
          c221v27 = nil
          c221v28 = nil
          c221v29 = false
          c221v22 = c221v22(c221v20, c221v24, c221v2, c221v26, c221v27, c221v28, c221v29, c221v7)
          c221v23 = vT[105]
          c221v23 = c221v23(c221v7, c221v20, c221v0, c221v2)
          c221v24 = vT[106]
          c221v24 = c221v24(c221v20)
          c221v26 = IsNull
          c221v26 = c221v26(c221v20:GetDisplayRecipe())
          c221v25 = not c221v26
          c221v26 = vT[109]
          c221v26 = c221v26(c221v20, c221v2)
          c221v27 = 0
          c221v28 = 0
          c221v29 = c221v22.ShowInMarket
          c221v29 = c221v22.OriginalPrice
          c221v27 = c221v29.Credits
          c221v29 = c221v22.OriginalPrice
          c221v28 = c221v29.Premium
          c221v29 = true
          c221v30 = 0
          if c221v27 <= c221v30 then
            c221v30 = 0
            if c221v28 <= c221v30 then
              c221v29 = false
            else
              c221v29 = true
            end
          end
          c221v30 = false
          c221v31 = 0
          if c221v31 < c221v28 then
            c221v31 = 0
            if c221v31 < c221v12 then
              c221v30 = true
              c221v14 = c221v14 + c221v28
            end
          end
          if c221v30 then
            c221v32 = c221v8.ProratedItems
            c221v31 = table.insert
            c221v31(c221v32, c221v20)
          end
          c221v20 = ResetLineCount
          c221v20()
          c221v20 = c221v15[c221v19]
          c221v20 = c221v20.mTypeName
          c221v21 = IsNull
          c221v21 = c221v21(c221v20)
          if c221v21 then break end
          if c221v21 then
            c221v21 = print
            c221v23 = "Could not find subitem "
            c221v27 = tostring
            c221v24 = c221v27(c221v19)
            c221v25 = " for "
            c221v26 = c221v0:GetFullName()
            c221v22 = c221v23 .. c221v24 .. c221v25 .. c221v26
            c221v21(c221v22)
            do return c221v8 end
          end
          c221v21 = c221v20:Name__b7ad1ab2()
          if not c221v21 then break end
          if not c221v21 then
            do return c221v8 end
          end
          c221v21 = IsNull
          c221v21 = c221v21(c221v7)
          if c221v21 then
            c221v21 = gGameData
            c221v21 = c221v21:GetInventory()
            c221v22 = gGameRules
            c221v22 = c221v22:GetStoreManifest()
            c221v23 = IsNull
            c221v23 = c221v23(c221v22)
            if not c221v23 then
              c221v23 = Lotus_Game.ProductUpsellHelper
              c221v7 = c221v23(c221v22, c221v21)
            end
          end
          c221v21 = c221v16
          if c221v21 then
            c221v22 = c221v20:GetProductCategory()
            c221v23 = 30
            if c221v22 ~= c221v23 then
              c221v21 = false
            else
              c221v21 = true
            end
          end
          c221v16 = c221v21
          c221v21 = c221v3
          if c221v21 then
            c221v21 = vT[99]
            c221v21 = c221v21(c221v20)
            if c221v21 then
              c221v22 = c221v15[c221v19]
              c221v22 = c221v22.mPurchaseQuantity
              if c221v22 ~= 1 then
                c221v21 = false
              else
                c221v21 = true
              end
            end
          end
        end
        if e394_393 ~= -1 then break end
        c221v9 = IsNull
        c221v9 = c221v9(c221v3)
        if c221v9 then
          c221v3 = true
        end
        c221v3 = c221v3 and true
        c221v9 = IsExternalProduct
        c221v9 = c221v9(c221v0)
        if not c221v9 then
          c221v9 = true
          c221v8.ShowInMarket = c221v9
          c221v9 = true
          c221v8.ExternalProduct = c221v9
          c221v9 = vT[96]
          c221v9 = c221v9(c221v0)
          if c221v9 ~= nil then
            c221v8.Sale = c221v9
          end
          c221v10 = c221v8.Sale
          if c221v10 ~= nil then
            c221v10 = c221v8.Sale
            c221v10 = c221v10.mHideFromMarket
            if c221v10 then
              c221v10 = false
              c221v8.ShowInMarket = c221v10
              do return c221v8 end
            end
          end
          c221v10 = GetProductId
          c221v10 = c221v10(c221v0)
          c221v11 = gGameData
          c221v11 = c221v11:Name__f2020ddd(c221v10)
          c221v8.CatalogProductData = c221v11
          c221v11 = c221v0:Name__aee7462d()
          c221v11 = c221v11:IsValid()
          if not c221v11 then
            c221v13 = c221v8.Sale
            c221v12 = IsNull
            c221v12 = c221v12(c221v13)
            c221v11 = not c221v12
            if c221v11 then
              c221v13 = c221v8.Sale
              c221v13 = c221v13.mUrlOverride
              c221v12 = IsNull
              c221v12 = c221v12(c221v13)
              c221v11 = not c221v12
              if c221v11 then
                c221v12 = c221v8.Sale
                c221v12 = c221v12.mUrlOverride
                if c221v12 == "" then
                  c221v11 = false
                else
                  c221v11 = true
                end
              end
            end
          end
          c221v12 = IsTwitchOrWegameValid
          c221v12 = c221v12(c221v0)
          if c221v9 == nil then
            c221v13 = Engine.STACKSFollies
            c221v13 = c221v13()
            if (not c221v13 or not c221v11) then
              if c221v10 ~= "" then
                c221v13 = c221v8.CatalogProductData
                c221v13 = c221v13.productId
                if c221v13 == c221v10 then
                  c221v13 = c221v8.CatalogProductData
                  c221v13 = c221v13.listPrice
                  c221v13 = c221v13.formatted
                  if c221v13 ~= "" then
                    c221v13 = true
                    c221v14 = c221v8.CatalogProductData
                    c221v14 = c221v14.listPrice
                    c221v14 = c221v14.value
                    c221v15 = 0
                    if c221v14 <= c221v15 then
                      c221v13 = c221v8.CatalogProductData
                      c221v13 = c221v13.owned
                      if not c221v13 then
                        c221v13 = Engine.Name__3d4ef9f7
                        c221v13 = c221v13()
                      end
                    end
                    c221v8.ShowInMarket = c221v13
                    c221v13 = c221v8.CatalogProductData
                    c221v13 = c221v13:Name__e2a615b0()
                    if c221v13 then
                      c221v15 = 100
                      c221v17 = c221v8.CatalogProductData
                      c221v17 = c221v17.listPrice
                      c221v17 = c221v17.value
                      c221v18 = c221v8.CatalogProductData
                      c221v18 = c221v18.basePrice
                      c221v18 = c221v18.value
                      c221v16 = c221v17 / c221v18
                      c221v14 = c221v15 * c221v16
                      c221v13 = 100 - c221v14
                      c221v14 = c221v8.DiscountTags
                      c221v15 = true
                      c221v14.Sale = c221v15
                      c221v14 = { mDiscount = nil, mEndDate = nil, mStartDate = nil }
                      c221v14.mDiscount = c221v13
                      c221v15 = c221v8.CatalogProductData
                      c221v15 = c221v15.listPrice
                      c221v15 = c221v15.endDate
                      c221v15 = c221v15:Copy()
                      c221v14.mEndDate = c221v15
                      c221v15 = c221v8.CatalogProductData
                      c221v15 = c221v15.listPrice
                      c221v15 = c221v15.startDate
                      c221v15 = c221v15:Copy()
                      c221v14.mStartDate = c221v15
                      c221v8.Sale = c221v14
                      c221v8.DiscountPercent = c221v13
                      c221v8.FinalDiscountPercent = c221v13
                      do return c221v8 end
                    end
                    c221v13 = { StoreItem = nil }
                    c221v13.StoreItem = c221v0
                    c221v14 = vT[28]
                    c221v14(c221v13)
                    c221v14 = c221v13.Coupon
                    if c221v14 ~= nil then
                      c221v14 = c221v13.Coupon
                      c221v14 = c221v14.mAmount
                      if c221v14 ~= nil then
                        c221v14 = c221v13.Coupon
                        c221v14 = c221v14.mAmount
                        if c221v14 ~= 0 then
                          c221v15 = c221v13.Coupon
                          c221v15 = c221v15.mExpiry
                          c221v14 = IsNull
                          c221v14 = c221v14(c221v15)
                          if not c221v14 then
                            c221v14 = Engine.Name__b38e1642
                            c221v15 = c221v13.Coupon
                            c221v15 = c221v15.mExpiry
                            c221v14 = c221v14(c221v15)
                            c221v15 = 0
                            if c221v15 < c221v14 then
                              c221v14 = c221v13.Coupon
                              c221v8.Coupon = c221v14
                              c221v14 = c221v8.DiscountTags
                              c221v15 = true
                              c221v14.Coupon = c221v15
                              c221v15 = c221v8.Coupon
                              c221v15 = c221v15.mAmount
                              c221v14 = c221v15 * 100
                              c221v8.DiscountPercent = c221v14
                              c221v14 = c221v8.DiscountPercent
                              c221v8.FinalDiscountPercent = c221v14
                            end
                          end
                        end
                      end
                    end
                    do return c221v8 end
                  end
                end
              end
              c221v13 = false
              c221v8.ShowInMarket = c221v13
              do return c221v8 end
            end
          end
          c221v13 = c221v12
          if c221v13 then
            c221v13 = Engine.STACKSFollies
            c221v13 = c221v13()
          end
          c221v8.ValidWeGame = c221v13
          c221v13 = c221v0:ShowInMarket()
          if c221v13 then
            c221v13 = c221v12 or c221v11
          end
          c221v8.ShowInMarket = c221v13
          do return c221v8 end
        end
        c221v9 = false
        if c221v5 ~= nil then
          c221v9 = true
          c221v10 = c221v5.RegularPrice
          if c221v10 == nil then
            c221v9 = true
            c221v10 = c221v5.RegularPriceOverride
            if c221v10 == nil then
              c221v9 = true
              c221v10 = c221v5.PremiumPrice
              if c221v10 == nil then
                c221v10 = c221v5.PremiumPriceOverride
                if c221v10 == nil then
                  c221v9 = false
                else
                  c221v9 = true
                end
              end
            end
          end
        end
        c221v10 = vT[96]
        c221v10 = c221v10(c221v0)
        c221v11 = c221v0:ShowInMarket()
        c221v8.ShowInMarket = c221v11
        c221v11 = IsNull
        c221v11 = c221v11(c221v10)
        if not c221v11 then
          c221v12 = c221v10.mHideFromMarket
          c221v11 = not c221v12
          c221v8.ShowInMarket = c221v11
        end
        if not c221v9 then
          c221v11 = c221v5.RegularPrice
          if c221v11 ~= nil then
            c221v11 = c221v8.OriginalPrice
            c221v12 = c221v5.RegularPrice
            c221v11.Credits = c221v12
          end
          c221v11 = c221v5.RegularPriceOverride
          if c221v11 ~= nil then
            c221v11 = c221v8.OriginalPrice
            c221v12 = c221v5.RegularPriceOverride
            c221v11.Credits = c221v12
          end
          c221v11 = c221v5.PremiumPrice
          if c221v11 ~= nil then
            c221v11 = c221v8.OriginalPrice
            c221v12 = c221v5.PremiumPrice
            c221v11.Premium = c221v12
          end
          c221v11 = c221v5.PremiumPriceOverride
          if c221v11 ~= nil then
            c221v11 = c221v8.OriginalPrice
            c221v12 = c221v5.PremiumPriceOverride
            c221v11.Premium = c221v12
          end
        else
          if c221v1 == nil then
            c221v13 = 0
            c221v11 = 3
            c221v12 = 1
            for c221v13 = c221v13, c221v11, c221v12 do
              c221v14 = c221v0:GetRegularPrice(c221v13)
              c221v15 = c221v0:GetPremiumPrice(c221v13)
              c221v16 = 0
              c221v16 = 0
              c221v16 = c221v8.OriginalPrice
              c221v16 = c221v16.Credits
              c221v8.Rarity = c221v13
              c221v16 = c221v8.OriginalPrice
              c221v16.Credits = c221v14
              c221v16 = c221v8.OriginalPrice
              c221v16.Premium = c221v15
              if e394_393 ~= -1 then break end
            end
            if e394_393 ~= -1 then break end
          else
            c221v11 = c221v8.OriginalPrice
            c221v12 = c221v0:GetRegularPrice(c221v1)
            c221v11.Credits = c221v12
            c221v11 = c221v8.OriginalPrice
            c221v12 = c221v0:GetPremiumPrice(c221v1)
            c221v11.Premium = c221v12
          end
        end
        c221v11 = c221v8.ShowInMarket
        if not ((c221v11 or c221v9)) then
          do return c221v8 end
        end
        c221v11 = c221v0:IsPackage()
        if c221v9 then
          do return c221v8 end
        end
        if c221v9 then
          local p380 = 111
          if p380 == 111 then
            if not c221v16 then
              p380 = 113
            else
              p380 = 112
            end
          end
          if p380 == 112 then
            c221v17 = {}
            c221v8.ProratedItems = c221v17
            c221v14 = 0
            c221v13 = 0
            p380 = 113
          end
          if p380 == 113 then
            c221v17 = 0
            if c221v13 <= c221v17 then
              p380 = 116
            else
              p380 = 114
            end
          end
          if p380 == 114 then
            c221v17 = 0
            if c221v11 <= c221v17 then
              p380 = 116
            else
              p380 = 115
            end
          end
          if p380 == 115 then
            c221v17 = c221v8.FinalPrice
            c221v19 = c221v8.OriginalPrice
            c221v19 = c221v19.Credits
            c221v23 = c221v8.OriginalPrice
            c221v23 = c221v23.Credits
            c221v22 = c221v13 * c221v23
            c221v21 = c221v22 / c221v11
            c221v20 = math.ceil
            c221v20 = c221v20(c221v21)
            c221v18 = c221v19 - c221v20
            c221v17.Credits = c221v18
            c221v17 = c221v8.DiscountTags
            c221v18 = true
            c221v17.Prorated = c221v18
            c221v20 = c221v8.FinalPrice
            c221v20 = c221v20.Credits
            c221v21 = c221v8.OriginalPrice
            c221v21 = c221v21.Credits
            c221v19 = c221v20 / c221v21
            c221v18 = 1 - c221v19
            c221v17 = c221v18 * 100
            c221v8.ProratedPercent = c221v17
            p380 = 117
          end
          if p380 == 116 then
            c221v17 = c221v8.FinalPrice
            c221v18 = c221v8.OriginalPrice
            c221v18 = c221v18.Credits
            c221v17.Credits = c221v18
            p380 = 117
          end
          if p380 == 117 then
            c221v17 = 0
            if c221v14 <= c221v17 then
              p380 = 120
            else
              p380 = 118
            end
          end
          if p380 == 118 then
            c221v17 = 0
            if c221v12 <= c221v17 then
              p380 = 120
            else
              p380 = 119
            end
          end
          if p380 == 119 then
            c221v17 = c221v8.FinalPrice
            c221v19 = c221v8.OriginalPrice
            c221v19 = c221v19.Premium
            c221v23 = c221v8.OriginalPrice
            c221v23 = c221v23.Premium
            c221v22 = c221v14 * c221v23
            c221v21 = c221v22 / c221v12
            c221v20 = math.ceil
            c221v20 = c221v20(c221v21)
            c221v18 = c221v19 - c221v20
            c221v17.Premium = c221v18
            c221v17 = c221v8.DiscountTags
            c221v18 = true
            c221v17.Prorated = c221v18
            c221v20 = c221v8.FinalPrice
            c221v20 = c221v20.Premium
            c221v21 = c221v8.OriginalPrice
            c221v21 = c221v21.Premium
            c221v19 = c221v20 / c221v21
            c221v18 = 1 - c221v19
            c221v17 = c221v18 * 100
            c221v8.ProratedPercent = c221v17
            p380 = 121
          end
          if p380 == 120 then
            c221v17 = c221v8.FinalPrice
            c221v18 = c221v8.OriginalPrice
            c221v18 = c221v18.Premium
            c221v17.Premium = c221v18
            p380 = 121
          end
          if p380 == 121 then
            c221v17 = c221v8.FinalPrice
            c221v17 = c221v17.Credits
            c221v18 = 0
            if c221v18 <= c221v17 then
              p380 = 123
            else
              p380 = 122
            end
          end
          if p380 == 122 then
            c221v17 = c221v8.FinalPrice
            c221v18 = 0
            c221v17.Credits = c221v18
            p380 = 123
          end
          if p380 == 123 then
            c221v17 = c221v8.FinalPrice
            c221v17 = c221v17.Premium
            c221v18 = 0
            if c221v18 <= c221v17 then
              p380 = 125
            else
              p380 = 124
            end
          end
          if p380 == 124 then
            c221v17 = c221v8.FinalPrice
            c221v18 = 0
            c221v17.Premium = c221v18
            p380 = 125
          end
          if p380 == 125 then
            c221v17 = c221v8.ProratedPrice
            c221v18 = c221v8.FinalPrice
            c221v18 = c221v18.Credits
            c221v17.Credits = c221v18
            c221v17 = c221v8.ProratedPrice
            c221v18 = c221v8.FinalPrice
            c221v18 = c221v18.Premium
            c221v17.Premium = c221v18
          end
        else
          c221v11 = c221v8.FinalPrice
          c221v12 = c221v8.OriginalPrice
          c221v12 = c221v12.Credits
          c221v11.Credits = c221v12
          c221v11 = c221v8.FinalPrice
          c221v12 = c221v8.OriginalPrice
          c221v12 = c221v12.Premium
          c221v11.Premium = c221v12
          if c221v5 ~= nil then
            c221v11 = c221v5.RegularPriceBeforeDiscount
            if c221v11 ~= nil then
              c221v11 = c221v8.OriginalPrice
              c221v12 = c221v5.RegularPriceBeforeDiscount
              c221v11.Credits = c221v12
            end
          end
        end
        if not c221v11 then
          if c221v14 ~= nil then
            c221v23 = c221v10.mDiscount
            c221v22 = math.round
            c221v22 = c221v22(c221v23)
            c221v21 = c221v14 * c221v22
            c221v20 = c221v21 / 100
            c221v19 = math.ceil
            c221v19 = c221v19(c221v20)
            c221v14 = c221v14 - c221v19
          end
          if c221v15 == nil then
            e394_393 = 190
            break
          end
          if c221v15 ~= nil then
            c221v23 = c221v10.mDiscount
            c221v22 = math.round
            c221v22 = c221v22(c221v23)
            c221v21 = c221v15 * c221v22
            c221v20 = c221v21 / 100
            c221v19 = math.ceil
            c221v19 = c221v19(c221v20)
            c221v15 = c221v15 - c221v19
            e394_393 = 190
            do break end
          end
        end
        break
      until true
      if e394_393 == 132 then
        p394 = 132
      elseif e394_393 == 177 then
        p394 = 177
      elseif e394_393 == 179 then
        p394 = 179
      elseif e394_393 == 183 then
        p394 = 183
      elseif e394_393 == 190 then
        p394 = 190
      end
    end
    if p394 == 132 then
      c221v8.Sale = c221v4
      c221v11 = c221v8.FinalPrice
      c221v12 = c221v4.mForcePlatSale
      c221v11.Premium = c221v12
      c221v11 = c221v8.DiscountTags
      c221v12 = true
      c221v11.Sale = c221v12
      c221v11 = c221v8.DiscountTags
      c221v12 = true
      c221v11.Darvo = c221v12
      c221v11 = c221v4.mDiscount
      c221v8.DiscountPercent = c221v11
      p394 = 206
    end
    if p394 == 177 then
      c221v21 = 0
      if c221v20 <= c221v21 then
        p394 = 184
      else
        p394 = 178
      end
    end
    if p394 == 178 then
      c221v15 = c221v20
      p394 = 184
    end
    if p394 == 179 then
      c221v20 = c221v10.mTieredRegularOverrides
      c221v19 = #c221v20
      c221v20 = 0
      if c221v19 <= c221v20 then
        p394 = 181
      else
        p394 = 180
      end
    end
    if p394 == 180 then
      c221v19 = c221v10.mTieredRegularOverrides
      c221v20 = c221v1 + 1
      c221v14 = c221v19[c221v20]
      p394 = 181
    end
    if p394 == 181 then
      c221v20 = c221v10.mTieredPremiumOverrides
      c221v19 = #c221v20
      c221v20 = 0
      if c221v19 <= c221v20 then
        p394 = 184
      else
        p394 = 182
      end
    end
    if p394 == 182 then
      c221v19 = c221v10.mTieredPremiumOverrides
      c221v20 = c221v1 + 1
      c221v15 = c221v19[c221v20]
      p394 = 184
    end
    if p394 == 183 then
      c221v14 = c221v10.mRegularOverride
      c221v15 = c221v10.mPremiumOverride
      p394 = 184
    end
    if p394 == 184 then
      c221v19 = true
      c221v20 = c221v8.OriginalPrice
      c221v20 = c221v20.Credits
      if c221v14 ~= c221v20 then
        p394 = 188
      else
        p394 = 185
      end
    end
    if p394 == 185 then
      c221v20 = c221v8.OriginalPrice
      c221v20 = c221v20.Premium
      if c221v15 ~= c221v20 then
        p394 = 187
      else
        p394 = 186
      end
    end
    if p394 == 186 then
      c221v19 = false
      p394 = 188
    end
    if p394 == 187 then
      c221v19 = true
      p394 = 188
    end
    if p394 == 188 then
      c221v18 = c221v19
      if not c221v18 then
        p394 = 190
      else
        p394 = 189
      end
    end
    if p394 == 189 then
      c221v19 = c221v8.OriginalPrice
      c221v19.Credits = c221v14
      c221v19 = c221v8.OriginalPrice
      c221v19.Premium = c221v15
      c221v19 = c221v8.FinalPrice
      c221v19.Credits = c221v14
      c221v19 = c221v8.FinalPrice
      c221v19.Premium = c221v15
      p394 = 190
    end
    if p394 == 190 then
      c221v8.Sale = c221v10
      if not c221v16 then
        p394 = 200
      else
        p394 = 191
      end
    end
    if p394 == 191 then
      if (not (c221v17) and not c221v18) then
        p394 = 200
      else
        p394 = 193
      end
    end
    if p394 == 193 then
      c221v19 = c221v8.DiscountTags
      c221v20 = false
      c221v19.Coupon = c221v20
      c221v19 = c221v8.DiscountTags
      c221v20 = not c221v18
      c221v19.Sale = c221v20
      c221v19 = c221v8.DiscountTags
      c221v19.PriceOverride = c221v18
      c221v19 = c221v8.DiscountTags
      c221v20 = c221v8.DiscountTags
      c221v20 = c221v20.Prorated
      if not c221v20 then
        p394 = 195
      else
        p394 = 194
      end
    end
    if p394 == 194 then
      c221v20 = not c221v18
      p394 = 195
    end
    if p394 == 195 then
      c221v19.Prorated = c221v20
      c221v19 = 0
      if c221v14 <= c221v19 then
        p394 = 197
      else
        p394 = 196
      end
    end
    if p394 == 196 then
      c221v22 = c221v14 * 100
      c221v23 = c221v8.FinalPrice
      c221v23 = c221v23.Credits
      c221v21 = c221v22 / c221v23
      c221v20 = 100 - c221v21
      c221v19 = math.floor
      c221v19 = c221v19(c221v20)
      c221v8.DiscountPercent = c221v19
      p394 = 197
    end
    if p394 == 197 then
      c221v19 = 0
      if c221v15 <= c221v19 then
        p394 = 199
      else
        p394 = 198
      end
    end
    if p394 == 198 then
      c221v22 = c221v15 * 100
      c221v23 = c221v8.FinalPrice
      c221v23 = c221v23.Premium
      c221v21 = c221v22 / c221v23
      c221v20 = 100 - c221v21
      c221v19 = math.floor
      c221v19 = c221v19(c221v20)
      c221v8.DiscountPercent = c221v19
      p394 = 199
    end
    if p394 == 199 then
      c221v19 = c221v8.FinalPrice
      c221v19.Credits = c221v14
      c221v19 = c221v8.FinalPrice
      c221v19.Premium = c221v15
      p394 = 206
    end
    if p394 == 200 then
      c221v19 = c221v8.DiscountTags
      c221v19 = c221v19.Coupon
      if not c221v19 then
        p394 = 206
      else
        p394 = 201
      end
    end
    if p394 == 201 then
      c221v19 = 0
      if c221v11 <= c221v19 then
        p394 = 203
      else
        p394 = 202
      end
    end
    if p394 == 202 then
      c221v22 = c221v11 * 100
      c221v23 = c221v8.FinalPrice
      c221v23 = c221v23.Credits
      c221v21 = c221v22 / c221v23
      c221v20 = 100 - c221v21
      c221v19 = math.floor
      c221v19 = c221v19(c221v20)
      c221v8.DiscountPercent = c221v19
      p394 = 203
    end
    if p394 == 203 then
      c221v19 = 0
      if c221v12 <= c221v19 then
        p394 = 205
      else
        p394 = 204
      end
    end
    if p394 == 204 then
      c221v22 = c221v12 * 100
      c221v23 = c221v8.FinalPrice
      c221v23 = c221v23.Premium
      c221v21 = c221v22 / c221v23
      c221v20 = 100 - c221v21
      c221v19 = math.floor
      c221v19 = c221v19(c221v20)
      c221v8.DiscountPercent = c221v19
      p394 = 205
    end
    if p394 == 205 then
      c221v19 = c221v8.FinalPrice
      c221v19.Credits = c221v11
      c221v19 = c221v8.FinalPrice
      c221v19.Premium = c221v12
      p394 = 206
    end
    if p394 == 206 then
      if not c221v9 then
        p394 = 208
      else
        p394 = 207
      end
    end
    if p394 == 207 then
      c221v11 = true
      c221v8.ShowInMarket = c221v11
      p394 = 220
    end
    if p394 == 208 then
      c221v11 = c221v0:ShowInMarket()
      c221v8.ShowInMarket = c221v11
      c221v12 = c221v8.Sale
      c221v11 = IsNull
      c221v11 = c221v11(c221v12)
      if c221v11 then
        p394 = 210
      else
        p394 = 209
      end
    end
    if p394 == 209 then
      c221v12 = c221v8.Sale
      c221v12 = c221v12.mHideFromMarket
      c221v11 = not c221v12
      c221v8.ShowInMarket = c221v11
      p394 = 210
    end
    if p394 == 210 then
      c221v11 = IsTwitchOrWegameValid
      c221v11 = c221v11(c221v0)
      if c221v11 == nil then
        p394 = 212
      else
        p394 = 211
      end
    end
    if p394 == 211 then
      c221v13 = c221v8.ShowInMarket
      c221v12 = c221v13 and c221v11
      c221v8.ShowInMarket = c221v12
      p394 = 212
    end
    if p394 == 212 then
      c221v12 = c221v8.ShowInMarket
      if c221v12 then
        p394 = 214
      else
        p394 = 213
      end
    end
    if p394 == 213 then
      c221v12 = c221v8.FinalPrice
      c221v13 = 0
      c221v12.Credits = c221v13
      c221v12 = c221v8.FinalPrice
      c221v13 = 0
      c221v12.Premium = c221v13
      p394 = 214
    end
    if p394 == 214 then
      c221v12 = c221v8.DiscountTags
      c221v12 = c221v12.PriceOverride
      if not c221v12 then
        p394 = 216
      else
        p394 = 215
      end
    end
    if p394 == 215 then
      c221v12 = 0
      c221v8.DiscountPercent = c221v12
      c221v12 = 0
      c221v8.FinalDiscountPercent = c221v12
      p394 = 220
    end
    if p394 == 216 then
      c221v12 = c221v8.FinalPrice
      c221v12 = c221v12.Credits
      c221v13 = 0
      if c221v12 <= c221v13 then
        p394 = 218
      else
        p394 = 217
      end
    end
    if p394 == 217 then
      c221v16 = c221v8.FinalPrice
      c221v16 = c221v16.Credits
      c221v15 = c221v16 * 100
      c221v16 = c221v8.OriginalPrice
      c221v16 = c221v16.Credits
      c221v14 = c221v15 / c221v16
      c221v13 = 100 - c221v14
      c221v12 = math.floor
      c221v12 = c221v12(c221v13)
      c221v8.FinalDiscountPercent = c221v12
      p394 = 218
    end
    if p394 == 218 then
      c221v12 = c221v8.FinalPrice
      c221v12 = c221v12.Premium
      c221v13 = 0
      if c221v12 <= c221v13 then
        p394 = 220
      else
        p394 = 219
      end
    end
    if p394 == 219 then
      c221v16 = c221v8.FinalPrice
      c221v16 = c221v16.Premium
      c221v15 = c221v16 * 100
      c221v16 = c221v8.OriginalPrice
      c221v16 = c221v16.Premium
      c221v14 = c221v15 / c221v16
      c221v13 = 100 - c221v14
      c221v12 = math.floor
      c221v12 = c221v12(c221v13)
      c221v8.FinalDiscountPercent = c221v12
      p394 = 220
    end
    if p394 == 220 then
      c221v12 = c221v8.FinalPrice
      c221v12 = c221v12.Premium
      c221v13 = 0
      if c221v13 < c221v12 then
        p394 = 222
      else
        p394 = 221
      end
    end
    if p394 == 221 then
      c221v11 = false
      p394 = 223
    end
    if p394 == 222 then
      c221v11 = true
      p394 = 223
    end
    if p394 == 223 then
      c221v8.UsePremium = c221v11
      c221v11 = c221v8.UsePremium
      if not c221v11 then
        p394 = 225
      else
        p394 = 224
      end
    end
    if p394 == 224 then
      c221v11 = c221v8.FinalPrice
      c221v11 = c221v11.Premium
      c221v8.UsePrice = c221v11
      c221v11 = c221v8.OriginalPrice
      c221v11 = c221v11.Premium
      c221v8.UseOriginalPrice = c221v11
      p394 = 226
    end
    if p394 == 225 then
      c221v11 = c221v8.FinalPrice
      c221v11 = c221v11.Credits
      c221v8.UsePrice = c221v11
      c221v11 = c221v8.OriginalPrice
      c221v11 = c221v11.Credits
      c221v8.UseOriginalPrice = c221v11
      p394 = 226
    end
    if p394 == 226 then
      c221v11 = c221v8.UsePrice
      c221v12 = 0
      if c221v12 < c221v11 then
        p394 = 229
      else
        p394 = 227
      end
    end
    if p394 == 227 then
      c221v11 = c221v8.DiscountTags
      c221v11 = c221v11.Prorated
      if c221v11 then
        p394 = 229
      else
        p394 = 228
      end
    end
    if p394 == 228 then
      c221v11 = false
      c221v8.ShowInMarket = c221v11
      p394 = 229
    end
    if p394 == 229 then
      do return c221v8 end
    end
  end
  GetStoreItemPriceObject = vT[111]
  vT[112] = "/Lotus/Language/Menu/AP_UNIVERSAL"
  vT[113] = "/Lotus/Language/Menu/AP_ATTACK"
  vT[114] = "/Lotus/Language/Menu/AP_DEFENSE"
  vT[115] = "/Lotus/Language/Menu/AP_TACTIC"
  vT[116] = "/Lotus/Language/Menu/AP_POWER"
  vT[117] = "/Lotus/Language/Menu/AP_PRECEPT"
  vT[118] = "/Lotus/Language/Menu/AP_FUSION"
  vT[119] = "/Lotus/Language/Menu/AP_WARD"
  vT[111] = {vT[112], vT[113], vT[114], vT[115], vT[116], vT[117], vT[118], vT[119]}
  vT[112] = function(c222v0)
    local c222v1, c222v2, c222v3
    c222v2 = vT[111]
    c222v3 = c222v0 + 1
    c222v1 = c222v2[c222v3]
    do return c222v1 end
  end
  GetPolarityName = vT[112]
  vT[112] = function(c223v0)
    local c223v1
    c223v1 = 3
    if c223v0 < c223v1 then
      c223v1 = 0
      do return c223v1 end
    end
    c223v1 = 2
    do return c223v1 end
  end
  GetPVPEloRatingForRank = vT[112]
  vT[112] = function(c224v0)
    local c224v1, c224v2, c224v3
    c224v1 = true
    c224v3 = PLAINS_NODE_TAG
    c224v2 = tostring
    c224v2 = c224v2(c224v3)
    if c224v0 ~= c224v2 then
      c224v1 = true
      c224v3 = ORB_VALLIS_NODE_TAG
      c224v2 = tostring
      c224v2 = c224v2(c224v3)
      if c224v0 ~= c224v2 then
        c224v3 = ENTRATI_LANDSCAPE_NODE_TAG
        c224v2 = tostring
        c224v2 = c224v2(c224v3)
        if c224v0 ~= c224v2 then
          c224v1 = false
        else
          c224v1 = true
        end
      end
    end
    do return c224v1 end
  end
  vT[113] = function(c225v0)
    local c225v1, c225v2, c225v3, c225v4, c225v5, c225v6, c225v8
    c225v2 = ZARIMAN_MISSION_A_TAG
    c225v3 = ZARIMAN_MISSION_B_TAG
    c225v4 = ZARIMAN_MISSION_C_TAG
    c225v5 = ZARIMAN_MISSION_D_TAG
    c225v6 = ZARIMAN_MISSION_E_TAG
    c225v1 = {c225v2, c225v3, c225v4, c225v5, c225v6}
    c225v2 = Symbol
    c225v2 = c225v2(c225v0)
    c225v3 = pairs
    c225v3, c225v4, c225v5 = c225v3(c225v1)
    for c225v6, c225v7 in c225v3, c225v4, c225v5 do
      if c225v2 == c225v7 then
        c225v8 = true
        do return c225v8 end
      end
    end
    c225v3 = false
    do return c225v3 end
  end
  vT[114] = function(c226v0)
    local c226v1, c226v2, c226v3, c226v4, c226v5, c226v6
    c226v1 = vT[57]
    c226v1 = c226v1()
    c226v2 = IsNull
    c226v2 = c226v2(c226v1)
    if c226v2 then
      c226v2 = false
      do return c226v2 end
    end
    c226v2 = vT[57]
    c226v2 = c226v2()
    c226v4 = Symbol
    c226v3 = c226v2:Name__19dfa8ea(c226v4(c226v0))
    if c226v3 then
      c226v4 = c226v2.region
      c226v6 = REGION_ID_VANIA
      c226v5 = c226v6 - 1
      if c226v4 ~= c226v5 then
        c226v3 = false
      else
        c226v3 = true
      end
    end
    do return c226v3 end
  end
  vT[115] = function(c227v0)
    local c227v1, c227v2, c227v3, c227v4, c227v5, c227v6, c227v7, c227v8, c227v9, c227v10, c227v11
    c227v5 = c227v4:InventoryControl()
    c227v6 = IsNull
    c227v6 = c227v6(c227v5)
    c227v8 = 1
    c227v6 = #c227v1
    c227v7 = 1
    for c227v8 = c227v8, c227v6, c227v7 do
      c227v11 = c227v1[c227v8]
      c227v9 = c227v5:GetWeaponInSlot(c227v11)
      c227v10 = IsNull
      c227v10 = c227v10(c227v9)
      if not c227v10 then
        c227v2 = c227v2 + 1
        c227v10 = c227v9:GetLevel()
        c227v3 = c227v3 + c227v10
      end
    end
    if c227v0 then
      c227v1 = nil
      c227v2 = Lotus_Game.Name__0fd07f26
      c227v3 = gPlayerProfileMgr
      c227v5 = 0
      c227v2 = c227v2(c227v3:GetPlayerProfile(c227v5))
      if c227v2 then
        c227v1 = 0
        do return c227v1 end
      end
      c227v1 = 2
      do return c227v1 end
    end
    c227v1 = _T.gPendingMission
    if not c227v0 then
      local p33 = 5
      if p33 == 5 then
        c227v1 = gMatchingService
        c227v1 = c227v1:IsHost()
        if not c227v1 then
        else
          p33 = 6
        end
      end
      if p33 == 6 then
        c227v2 = _T.gPendingMission.name
        c227v1 = tostring
        c227v1 = c227v1(c227v2)
        c227v2 = string.find
        c227v4 = TAG_SEPERATOR
        c227v2 = c227v2(c227v1, c227v4)
        if not c227v2 then
          p33 = 8
        else
          p33 = 7
        end
      end
      if p33 == 7 then
        c227v5 = 1
        c227v6 = c227v2 - 1
        c227v3 = string.sub
        c227v1 = c227v3(c227v1, c227v5, c227v6)
        p33 = 8
      end
      if p33 == 8 then
        c227v3 = vT[112]
        c227v3 = c227v3(c227v1)
        if not c227v3 then
          p33 = 10
        else
          p33 = 9
        end
      end
      if p33 == 9 then
        c227v3 = GetModifiedPlainsElo
        c227v5 = PLAINS_ELO_IN_LISET
        do return c227v3(c227v1, c227v5) end
      end
      if p33 == 10 then
        c227v3 = vT[113]
        c227v3 = c227v3(c227v1)
        if c227v3 then
          p33 = 12
        else
          p33 = 11
        end
      end
      if p33 == 11 then
        c227v3 = vT[114]
        c227v3 = c227v3(c227v1)
        if not c227v3 then
        else
          p33 = 12
        end
      end
      if p33 == 12 then
        c227v3 = PLAINS_ELO_IN_LISET
        do return c227v3 end
      end
    end
    c227v2 = 0
    c227v3 = 1
    c227v4 = 3
    c227v5 = 5
    c227v1 = {c227v2, c227v3, c227v4, c227v5}
    c227v2 = 0
    c227v3 = 0
    c227v4 = vT[47]
    c227v4 = c227v4()
    c227v5 = IsNull
    c227v5 = c227v5(c227v4)
    c227v5 = 1
    if c227v2 < c227v5 then
      c227v2 = 1
    end
    c227v5 = c227v3 / c227v2
    do return c227v5 end
  end
  vT[116] = function(c228v0)
    local c228v1
    c228v1 = vT[115]
    c228v1 = c228v1(c228v0)
    do return c228v1 end
  end
  GetPlayerEloRating = vT[116]
  vT[116] = function(c229v0)
    local c229v1, c229v2, c229v3, c229v4, c229v5, c229v6, c229v7, c229v8, c229v9, c229v10
    local p51 = 0
    if p51 == 0 then
      c229v4 = true
      c229v5 = IsNull
      c229v5 = c229v5(c229v0)
      if c229v5 then
        p51 = 35
      else
        p51 = 1
      end
    end
    if p51 == 1 then
      c229v7 = gDecorationType
      c229v5 = c229v0:IsA(c229v7)
      if not c229v5 then
        p51 = 6
      else
        p51 = 2
      end
    end
    if p51 == 2 then
      c229v5 = c229v0:GetLocTag()
      c229v5 = c229v5:IsValid()
      if not c229v5 then
        p51 = 4
      else
        p51 = 3
      end
    end
    if p51 == 3 then
      c229v5 = c229v0:Outroinstigator()
      if c229v5 then
        p51 = 5
      else
        p51 = 4
      end
    end
    if p51 == 4 then
      c229v5 = c229v0:GetTag()
      c229v6 = vT[22]
      c229v6 = c229v6.mScanPoint
      if c229v5 ~= c229v6 then
        p51 = 6
      else
        p51 = 5
      end
    end
    if p51 == 5 then
      c229v4 = false
      do return c229v0, c229v2, c229v3, c229v4 end
    end
    if p51 == 6 then
      c229v7 = gDynamicCoverType
      c229v5 = c229v0:IsA(c229v7)
      if c229v5 then
        p51 = 9
      else
        p51 = 7
      end
    end
    if p51 == 7 then
      c229v7 = gEmplacementType
      c229v5 = c229v0:IsA(c229v7)
      if c229v5 then
        p51 = 9
      else
        p51 = 8
      end
    end
    if p51 == 8 then
      c229v7 = gDevourerType
      c229v5 = c229v0:IsA(c229v7)
      if not c229v5 then
        p51 = 10
      else
        p51 = 9
      end
    end
    if p51 == 9 then
      do return c229v0, c229v2, c229v3, c229v4 end
    end
    if p51 == 10 then
      c229v7 = vT[7]
      c229v5 = c229v0:IsA(c229v7)
      if not c229v5 then
        p51 = 12
      else
        p51 = 11
      end
    end
    if p51 == 11 then
      c229v5 = nil
      do return c229v5 end
    end
    if p51 == 12 then
      c229v7 = gBaseAvatarType
      c229v5 = c229v0:IsA(c229v7)
      if not c229v5 then
        p51 = 14
      else
        p51 = 13
      end
    end
    if p51 == 13 then
      do return c229v1, c229v0, c229v3, c229v4 end
    end
    if p51 == 14 then
      c229v7 = gHitProxyType
      c229v5 = c229v0:IsA(c229v7)
      if not c229v5 then
        p51 = 16
      else
        p51 = 15
      end
    end
    if p51 == 15 then
      c229v5 = c229v0:IsEnabled()
      p51 = 16
    end
    if p51 == 16 then
      c229v6 = c229v0:GetRootOwner()
      if not c229v5 then
        p51 = 19
      else
        p51 = 17
      end
    end
    if p51 == 17 then
      c229v9 = gBaseAvatarType
      c229v7 = c229v6:IsA(c229v9)
      if not c229v7 then
        p51 = 19
      else
        p51 = 18
      end
    end
    if p51 == 18 then
      do return c229v1, c229v6, c229v3, c229v4 end
    end
    if p51 == 19 then
      if not c229v5 then
        p51 = 25
      else
        p51 = 20
      end
    end
    if p51 == 20 then
      c229v9 = gDecorationType
      c229v7 = c229v6:IsA(c229v9)
      if not c229v7 then
        p51 = 22
      else
        p51 = 21
      end
    end
    if p51 == 21 then
      c229v7 = c229v6:GetLocTag()
      c229v7 = c229v7:IsValid()
      if c229v7 then
        p51 = 24
      else
        p51 = 22
      end
    end
    if p51 == 22 then
      c229v9 = gDynamicCoverType
      c229v7 = c229v6:IsA(c229v9)
      if c229v7 then
        p51 = 24
      else
        p51 = 23
      end
    end
    if p51 == 23 then
      c229v9 = gEmplacementType
      c229v7 = c229v6:IsA(c229v9)
      if not c229v7 then
        p51 = 25
      else
        p51 = 24
      end
    end
    if p51 == 24 then
      c229v4 = false
      do return c229v6, c229v2, c229v0, c229v4 end
    end
    if p51 == 25 then
      if not c229v5 then
        p51 = 28
      else
        p51 = 26
      end
    end
    if p51 == 26 then
      c229v9 = gDevourerType
      c229v7 = c229v6:IsA(c229v9)
      if not c229v7 then
        p51 = 28
      else
        p51 = 27
      end
    end
    if p51 == 27 then
      do return c229v6, c229v2, c229v0, c229v4 end
    end
    if p51 == 28 then
      c229v9 = gPickUpType
      c229v7 = c229v0:IsA(c229v9)
      if not c229v7 then
        p51 = 33
      else
        p51 = 29
      end
    end
    if p51 == 29 then
      c229v7 = c229v0:Name__9e567fe5()
      if not c229v7 then
        p51 = 33
      else
        p51 = 30
      end
    end
    if p51 == 30 then
      c229v7 = c229v0:GetPickUpItem()
      c229v8 = IsNull
      c229v8 = c229v8(c229v7)
      if c229v8 then
        p51 = 35
      else
        p51 = 31
      end
    end
    if p51 == 31 then
      c229v10 = gFusionTreasureType
      c229v8 = c229v7:IsA(c229v10)
      if not c229v8 then
        p51 = 35
      else
        p51 = 32
      end
    end
    if p51 == 32 then
      do return c229v0, c229v2, c229v3, c229v4 end
    end
    if p51 == 33 then
      c229v7 = c229v0:GetAttachParent()
      c229v8 = IsNull
      c229v8 = c229v8(c229v7)
      if c229v8 then
        p51 = 35
      else
        p51 = 34
      end
    end
    if p51 == 34 then
      c229v8 = vT[116]
      do return c229v8(c229v7) end
    end
    if p51 == 35 then
      do return c229v1, c229v2, c229v3, c229v4 end
    end
  end
  vT[117] = function(c230v0)
    local c230v1
    c230v1 = vT[116]
    do return c230v1(c230v0) end
  end
  FilterStatusEntity = vT[117]
  vT[117] = function(c231v0, c231v1, c231v2)
    local c231v3, c231v4, c231v5, c231v6, c231v7, c231v8, c231v9, c231v10, c231v11, c231v12, c231v13, c231v14
    if c231v1 ~= nil then
      c231v5 = 1
      c231v3 = #c231v1
      c231v4 = 1
      for c231v5 = c231v5, c231v3, c231v4 do
        c231v6 = ResetLineCount
        c231v7 = 0
        c231v6(c231v7)
        c231v6 = c231v1[c231v5]
        c231v7 = c231v6.mItemType
        c231v7 = c231v7:GetFullName()
        c231v8 = IsNull
        c231v8 = c231v8(c231v2)
        c231v8 = c231v2(c231v6)
        c231v8 = c231v0[c231v7]
        c231v9 = c231v8.Count
        c231v9 = c231v8.Count
        c231v9 = vT[17]
        c231v9 = c231v9.Ternary
        c231v11 = c231v6.mItemCount
        if c231v11 ~= nil then
          c231v10 = false
        else
          c231v10 = true
        end
        c231v11 = 1
        c231v12 = c231v6.mItemCount
        c231v9 = c231v9(c231v10, c231v11, c231v12)
        c231v8.Count = c231v9
        c231v10 = c231v8.Count
        c231v11 = vT[17]
        c231v11 = c231v11.Ternary
        c231v13 = c231v6.mItemCount
        if c231v13 ~= nil then
          c231v12 = false
        else
          c231v12 = true
        end
        c231v13 = 1
        c231v14 = c231v6.mItemCount
        c231v11 = c231v11(c231v12, c231v13, c231v14)
        c231v9 = c231v10 + c231v11
        c231v8.Count = c231v9
        c231v9 = { Type = nil, Count = nil, Item = nil }
        c231v10 = c231v6.mItemType
        c231v9.Type = c231v10
        c231v10 = c231v6.mItemCount
        c231v9.Count = c231v10
        c231v9.Item = c231v6
        c231v10 = c231v9.Count
        if c231v10 == nil then
          c231v10 = 1
          c231v9.Count = c231v10
        end
        c231v0[c231v7] = c231v9
      end
    end
    do return end
  end
  vT[118] = function(c232v0, c232v1, c232v2)
    local c232v3
    c232v3 = vT[117]
    c232v3(c232v0, c232v1, c232v2)
    do return end
  end
  AddTableToPurchasedItems = vT[118]
  vT[118] = function()
    local c234v0, c234v1, c234v2, c234v3, c234v4, c234v6, c234v7
    c234v0 = {}
    c234v1 = gGameData
    c234v2 = IsNull
    c234v2 = c234v2(c234v1)
    if not c234v2 then
      c234v2 = c234v1:GetInventory()
      c234v3 = IsNull
      c234v3 = c234v3(c234v2)
      if not c234v3 then
        c234v3 = vT[117]
        c234v3(c234v0, c234v2:GetLongGuns())
        c234v3 = vT[117]
        c234v3(c234v0, c234v2:GetPistols())
        c234v3 = vT[117]
        c234v3(c234v0, c234v2:GetSuits())
        c234v3 = vT[117]
        c234v3(c234v0, c234v2:GetMelee())
        c234v3 = vT[117]
        c234v3(c234v0, c234v2:GetSpaceSuits())
        c234v3 = vT[117]
        c234v3(c234v0, c234v2:GetSpaceGuns())
        c234v3 = vT[117]
        c234v3(c234v0, c234v2:GetSpaceMelee())
        c234v3 = vT[117]
        c234v3(c234v0, c234v2:GetSentinels())
        c234v3 = vT[117]
        c234v3(c234v0, c234v2:GetSentinelWeapons())
        c234v3 = vT[117]
        c234v3(c234v0, c234v2:GetWeaponSkins())
        c234v3 = WeakResource
        c234v4 = "/Lotus/Upgrades/Mods/Immortal/ImmortalBaseMod"
        c234v3 = c234v3(c234v4)
        c234v4 = vT[117]
        c234v6 = c234v2:GetUpgrades()
        c234v7 = function(c233v0)
          local c233v1, c233v2, c233v3
          c233v1 = c233v0.mItemType
          c233v3 = c234v3
          c233v1 = c233v1:IsA(c233v3)
          if c233v1 then
            c233v1 = cjson.decode
            c233v2 = c233v0.mUpgradeFingerprint
            c233v1 = c233v1(c233v2)
            c233v2 = IsNull
            c233v2 = c233v2(c233v1)
            if not c233v2 then
              c233v2 = c233v1.lvl
              if c233v2 == 3 then
                c233v2 = false
                do return c233v2 end
              end
            end
          end
          c233v1 = true
          do return c233v1 end
        end
        c234v4(c234v0, c234v6, c234v7)
        c234v4 = vT[117]
        c234v4(c234v0, c234v2:GetRawUpgrades())
        c234v4 = vT[117]
        c234v4(c234v0, c234v2:GetConsumables())
        c234v4 = vT[117]
        c234v4(c234v0, c234v2:GetRecipes())
        c234v4 = vT[117]
        c234v4(c234v0, c234v2:GetMiscItems())
        c234v4 = vT[117]
        c234v4(c234v0, c234v2:GetFlavourItems())
        c234v4 = vT[117]
        c234v4(c234v0, c234v2:GetLevelKeys())
        c234v4 = vT[117]
        c234v4(c234v0, c234v2:GetQuestKeys())
        c234v4 = vT[117]
        c234v4(c234v0, c234v2:GetDrones())
        c234v4 = vT[117]
        c234v4(c234v0, c234v2:GetShipDecos())
        c234v4 = vT[117]
        c234v4(c234v0, c234v2:GetShips())
        c234v4 = vT[117]
        c234v4(c234v0, c234v2:GetCrewShipWeapons())
        c234v4 = vT[117]
        c234v4(c234v0, c234v2:GetCrewShipWeaponSkins())
        c234v4 = vT[117]
        c234v4(c234v0, c234v2:GetCrewShips())
        c234v4 = vT[117]
        c234v4(c234v0, c234v2:GetHoverboards())
        c234v4 = vT[117]
        c234v4(c234v0, c234v2:GetMechSuits())
        c234v4 = vT[117]
        c234v4(c234v0, c234v2:GetMoaPets())
        c234v4 = vT[117]
        c234v4(c234v0, c234v2:GetOperatorAmps())
        c234v4 = vT[117]
        c234v4(c234v0, c234v2:GetMotorcycles())
        c234v4 = vT[117]
        c234v4(c234v0, c234v2:GetDataKnives())
      end
    end
    do return c234v0 end
  end
  GetAllPurchasedItems = vT[118]
  vT[118] = function(c237v0, c237v1, c237v2, c237v3, c237v4)
    local c237v5, c237v6, c237v7, c237v8, c237v9, c237v10, c237v11, c237v12, c237v13, c237v14, c237v15, c237v16, c237v17, c237v18, c237v19
    c237v6 = {}
    c237v7 = function(c235v0)
      local c235v1, c235v2, c235v3
      c235v1 = c237v2
      if c235v1 then
        c235v2 = c237v6
        c235v1 = table.insert
        c235v1(c235v2, c235v0)
        do return end
      end
      c235v1 = c237v5
      if c235v1 == nil then
        c237v5 = c235v0
        do return end
      end
      c235v2 = c237v5
      c235v3 = " + "
      c235v1 = c235v2 .. c235v3 .. c235v0
      c237v5 = c235v1
      do return end
    end
    c237v8 = function(c236v0, c236v1, c236v2)
      local c236v3, c236v4, c236v5, c236v6, c236v7, c236v8, c236v9, c236v10, c236v11
      local p58 = 0
      if p58 == 0 then
        c236v3 = ""
        c236v4 = nil
        c236v5 = IsNull
        c236v5 = c236v5(c236v1)
        if c236v5 then
          p58 = 5
        else
          p58 = 1
        end
      end
      if p58 == 1 then
        c236v4 = c236v1.mItemType
        c236v5 = c236v1.mItemType
        c236v7 = gRecipeItemType
        c236v5 = c236v5:IsA(c236v7)
        if not c236v5 then
          p58 = 4
        else
          p58 = 2
        end
      end
      if p58 == 2 then
        c236v5 = Resource
        c236v6 = c236v1.mItemType
        c236v5 = c236v5(c236v6)
        c236v6 = IsNull
        c236v6 = c236v6(c236v5)
        if c236v6 then
          p58 = 6
        else
          p58 = 3
        end
      end
      if p58 == 3 then
        c236v6 = tostring
        c236v3 = c236v6(c236v5:GetLocalizeTag())
        p58 = 6
      end
      if p58 == 4 then
        c236v5 = tostring
        c236v3 = c236v5(c236v1:Name__67ecf03e())
        p58 = 6
      end
      if p58 == 5 then
        c236v4 = c236v0:GetItem()
        c236v5 = tostring
        c236v3 = c236v5(c236v0:GetLocalizeTag())
        p58 = 6
      end
      if p58 == 6 then
        c236v5 = c237v0
        c236v8 = false
        c236v3 = c236v5:GetLocalized(c236v3, c236v8)
        c236v5 = IsNull
        c236v5 = c236v5(c236v0)
        if c236v5 then
          p58 = 10
        else
          p58 = 7
        end
      end
      if p58 == 7 then
        c236v5 = IsNull
        c236v5 = c236v5(c236v4)
        if c236v5 then
          p58 = 10
        else
          p58 = 8
        end
      end
      if p58 == 8 then
        c236v7 = gRecipeItemType
        c236v5 = c236v4:IsA(c236v7)
        if not c236v5 then
          p58 = 10
        else
          p58 = 9
        end
      end
      if p58 == 9 then
        c236v5 = c237v0
        c236v7 = "/Lotus/Language/Items/BlueprintAndItem"
        c236v8 = false
        c236v9 = { ITEM = nil }
        c236v9.ITEM = c236v3
        c236v3 = c236v5:GetLocalized(c236v7, c236v8, c236v9)
        p58 = 10
      end
      if p58 == 10 then
        c236v5 = IsNull
        c236v5 = c236v5(c236v0)
        if c236v5 then
          p58 = 12
        else
          p58 = 11
        end
      end
      if p58 == 11 then
        c236v5 = c236v0:GetProductCategory()
        c236v6 = 35
        if c236v5 == c236v6 then
          p58 = 14
        else
          p58 = 12
        end
      end
      if p58 == 12 then
        c236v5 = IsNull
        c236v5 = c236v5(c236v4)
        if c236v5 then
          p58 = 20
        else
          p58 = 13
        end
      end
      if p58 == 13 then
        c236v7 = gFusionBundleType
        c236v5 = c236v4:IsA(c236v7)
        if not c236v5 then
          p58 = 20
        else
          p58 = 14
        end
      end
      if p58 == 14 then
        c236v5 = 0
        c236v6 = 0
        c236v7 = IsNull
        c236v7 = c236v7(c236v1)
        if c236v7 then
          p58 = 16
        else
          p58 = 15
        end
      end
      if p58 == 15 then
        c236v7 = c236v1:Name__aeb85b56()
        c236v5 = -c236v7
        c236v6 = c236v2
        p58 = 17
      end
      if p58 == 16 then
        c236v7 = c236v0:GetRegularPrice()
        c236v5 = -c236v7
        c236v6 = c236v0:GetPurchaseQuantity()
        p58 = 17
      end
      if p58 == 17 then
        c236v7 = "<FUSION_POINTS>"
        c236v8 = c237v3
        if c236v8 then
          p58 = 19
        else
          p58 = 18
        end
      end
      if p58 == 18 then
        c236v8 = c237v0
        c236v10 = "<FUSION_POINTS>"
        c236v11 = true
        c236v7 = c236v8:GetLocalized(c236v10, c236v11)
        p58 = 19
      end
      if p58 == 19 then
        c236v9 = vT[17]
        c236v9 = c236v9.FormatNumber
        c236v10 = c236v5 * c236v6
        c236v9 = c236v9(c236v10)
        c236v3 = c236v7 .. c236v9
        p58 = 24
      end
      if p58 == 20 then
        c236v5 = 1
        if c236v2 <= c236v5 then
          p58 = 24
        else
          p58 = 21
        end
      end
      if p58 == 21 then
        c236v5 = c237v4
        if not c236v5 then
          p58 = 23
        else
          p58 = 22
        end
      end
      if p58 == 22 then
        c236v7 = c237v4
        c236v6 = c236v2 * c236v7
        c236v5 = math.floor
        c236v2 = c236v5(c236v6)
        p58 = 23
      end
      if p58 == 23 then
        c236v6 = " ("
        c236v8 = ")"
        c236v3 = c236v3 .. c236v6 .. c236v2 .. c236v8
        p58 = 24
      end
      if p58 == 24 then
        c236v5 = IsNull
        c236v5 = c236v5(c236v4)
        if c236v5 then
          p58 = 33
        else
          p58 = 25
        end
      end
      if p58 == 25 then
        c236v7 = vT[4]
        c236v5 = c236v4:IsA(c236v7)
        if not c236v5 then
          p58 = 27
        else
          p58 = 26
        end
      end
      if p58 == 26 then
        c236v5 = "U"
        c236v9 = Resource
        c236v9 = c236v9(c236v4)
        c236v11 = ""
        c236v6 = c236v9:GetFusionLevel(c236v11)
        c236v7 = " "
        c236v3 = c236v5 .. c236v6 .. c236v7 .. c236v3
        do return c236v3 end
      end
      if p58 == 27 then
        c236v7 = vT[5]
        c236v5 = c236v4:IsA(c236v7)
        if not c236v5 then
          p58 = 29
        else
          p58 = 28
        end
      end
      if p58 == 28 then
        c236v5 = "R"
        c236v9 = Resource
        c236v9 = c236v9(c236v4)
        c236v11 = ""
        c236v6 = c236v9:GetFusionLevel(c236v11)
        c236v7 = " "
        c236v3 = c236v5 .. c236v6 .. c236v7 .. c236v3
        do return c236v3 end
      end
      if p58 == 29 then
        c236v7 = gKeyChainItemType
        c236v5 = c236v4:IsA(c236v7)
        if not c236v5 then
          p58 = 31
        else
          p58 = 30
        end
      end
      if p58 == 30 then
        c236v5 = c237v0
        c236v7 = "/Lotus/Language/Menu/MissionReward_Quest"
        c236v8 = false
        c236v9 = { QUEST = nil }
        c236v9.QUEST = c236v3
        c236v3 = c236v5:GetLocalized(c236v7, c236v8, c236v9)
        do return c236v3 end
      end
      if p58 == 31 then
        c236v7 = vT[6]
        c236v5 = c236v4:IsA(c236v7)
        if not c236v5 then
          p58 = 33
        else
          p58 = 32
        end
      end
      if p58 == 32 then
        c236v7 = c237v0
        c236v9 = "<ELITIUM>"
        c236v10 = true
        c236v5 = c236v7:GetLocalized(c236v9, c236v10)
        c236v3 = c236v5 .. c236v3
        p58 = 33
      end
      if p58 == 33 then
        do return c236v3 end
      end
    end
    c237v9 = c237v1.credits
    c237v10 = 0
    if c237v10 < c237v9 then
      c237v9 = "<CREDITS>"
      if not c237v3 then
        c237v12 = "<CREDITS>"
        c237v13 = true
        c237v9 = c237v0:GetLocalized(c237v12, c237v13)
      end
      c237v13 = vT[17]
      c237v13 = c237v13.FormatNumber
      c237v14 = c237v1.credits
      c237v13 = c237v13(c237v14)
      c237v11 = c237v9 .. c237v13
      c237v7(c237v11)
    end
    c237v9 = c237v1.items
    c237v12 = 1
    c237v10 = #c237v9
    c237v11 = 1
    for c237v12 = c237v12, c237v10, c237v11 do
      c237v13 = c237v9[c237v12]
      c237v14 = IsNull
      c237v14 = c237v14(c237v13)
      if not c237v14 then
        c237v16 = nil
        c237v17 = 1
        c237v14 = c237v8(c237v13, c237v16, c237v17)
        c237v7(c237v14)
      end
    end
    c237v10 = c237v1.countedStoreItems
    c237v13 = 1
    c237v11 = #c237v10
    c237v12 = 1
    for c237v13 = c237v13, c237v11, c237v12 do
      c237v14 = c237v10[c237v13]
      c237v15 = c237v14.mStoreItem
      c237v16 = IsNull
      c237v16 = c237v16(c237v15)
      if not c237v16 then
        c237v18 = nil
        c237v19 = c237v14.mItemCount
        c237v16 = c237v8(c237v15, c237v18, c237v19)
        c237v7(c237v16)
      end
    end
    c237v11 = c237v1.countedItems
    c237v14 = 1
    c237v12 = #c237v11
    c237v13 = 1
    for c237v14 = c237v14, c237v12, c237v13 do
      c237v16 = c237v1.countedItems
      c237v15 = c237v16[c237v14]
      c237v17 = c237v15.mItemType
      c237v16 = IsNull
      c237v16 = c237v16(c237v17)
      if not c237v16 then
        c237v17 = nil
        c237v19 = c237v15.mItemCount
        c237v16 = c237v8(c237v17, c237v15, c237v19)
        c237v7(c237v16)
      end
    end
    if c237v5 == nil then
      c237v5 = ""
    end
    c237v12 = vT[17]
    c237v12 = c237v12.Ternary
    do return c237v12(c237v2, c237v6, c237v5) end
  end
  GetRewardDesc = vT[118]
  vT[118] = function(c238v0)
    local c238v1, c238v2, c238v3, c238v4
    c238v3 = gStoreItemType
    c238v1 = c238v0:IsA(c238v3)
    if c238v1 then
      c238v1 = c238v0:GetIconTexture()
      c238v3 = c238v0:Name__a6ca7840()
      c238v2 = not c238v3
      do return c238v1, c238v2 end
    end
    c238v1 = IsWeak
    c238v1 = c238v1(c238v0)
    if c238v1 then
      c238v2 = false
      c238v1 = assert
      c238v1(c238v2)
    end
    c238v1 = c238v0:Name__b75d81dd()
    c238v2 = 1
    if c238v2 < c238v1 then
      c238v1 = c238v0:GetIconTexture()
      if c238v1 then
        c238v1 = c238v0:GetIconTexture()
        c238v3 = c238v0:Name__a6ca7840()
        c238v2 = not c238v3
        do return c238v1, c238v2 end
      end
    end
    c238v1 = c238v0:GetResultStoreItem()
    c238v2 = IsNull
    c238v2 = c238v2(c238v1)
    if not c238v2 then
      c238v2 = IsNull
      c238v2 = c238v2(c238v1:GetIconTexture())
      if not c238v2 then
        c238v2 = c238v1:GetIconTexture()
        c238v4 = c238v1:Name__a6ca7840()
        c238v3 = not c238v4
        do return c238v2, c238v3 end
      end
    end
    c238v2 = c238v0:GetIconTexture()
    c238v4 = c238v0:Name__a6ca7840()
    c238v3 = not c238v4
    do return c238v2, c238v3 end
  end
  vT[119] = function(c239v0)
    local c239v1
    c239v1 = vT[118]
    do return c239v1(c239v0) end
  end
  GetRecipeIconTexture = vT[119]
  vT[119] = function(c240v0, c240v1)
    local c240v2, c240v3, c240v4, c240v5, c240v6, c240v7, c240v8, c240v9, c240v10, c240v11
    c240v6 = false
    c240v7 = false
    c240v8 = false
    c240v10 = c240v0.items
    c240v9 = #c240v10
    c240v10 = 0
    if c240v10 < c240v9 then
      c240v9 = c240v0.items
      c240v3 = c240v9[1]
    else
      c240v10 = c240v0.countedItems
      c240v9 = #c240v10
      c240v10 = 0
      if c240v10 < c240v9 then
        c240v10 = c240v0.countedItems
        c240v9 = c240v10[1]
        c240v4 = c240v9.mItemType
      else
        c240v10 = c240v0.countedStoreItems
        c240v9 = #c240v10
        c240v10 = 0
        if c240v10 < c240v9 then
          c240v10 = c240v0.countedStoreItems
          c240v9 = c240v10[1]
          c240v4 = c240v9.mStoreItem
        end
      end
    end
    if c240v9 <= c240v10 then
      c240v5 = c240v3:GetItem()
      c240v2 = c240v3:GetIconTexture()
      c240v9 = c240v3:Name__a6ca7840()
      c240v7 = not c240v9
      c240v10 = IsNull
      c240v10 = c240v10(c240v5)
      c240v9 = not c240v10
      if c240v9 then
        c240v9 = c240v3:GetItem()
        c240v11 = gRecipeItemType
        c240v9 = c240v9:IsA(c240v11)
      end
      c240v6 = c240v9
      c240v8 = c240v3:TintIconToTheme()
    else
      if c240v4 ~= nil then
        c240v5 = c240v4
        c240v9 = Resource
        c240v4 = c240v9(c240v4)
        c240v11 = gRecipeItemType
        c240v6 = c240v4:IsA(c240v11)
        if c240v6 then
          c240v9 = vT[118]
          c240v2, c240v7 = c240v9(c240v4)
        else
          c240v2 = c240v4:GetIconTexture()
          c240v9 = c240v4:Name__a6ca7840()
          c240v7 = not c240v9
        end
      else
        c240v9 = c240v0.credits
        c240v10 = 0
        if c240v10 < c240v9 then
          c240v9 = _G
          c240v2 = c240v9.UITexture_CreditsIcon
        end
      end
    end
    do return c240v2, c240v6, c240v5, c240v7, c240v8 end
  end
  GetRewardIcon = vT[119]
  vT[119] = function(c241v0)
    local c241v1, c241v2, c241v3, c241v4, c241v5, c241v6, c241v7, c241v8, c241v9, c241v10, c241v11, c241v12, c241v13, c241v14
    c241v1 = {}
    c241v2 = c241v0.credits
    c241v3 = 0
    if c241v3 < c241v2 then
      c241v4 = { Icon = nil, Themed = true, NameOverride = nil }
      c241v5 = _G
      c241v5 = c241v5.UITexture_CreditsIcon
      c241v4.Icon = c241v5
      c241v9 = vT[17]
      c241v9 = c241v9.FormatNumber
      c241v10 = c241v0.credits
      c241v6 = c241v9(c241v10)
      c241v7 = " "
      c241v8 = Localize
      c241v9 = "/Lotus/Language/Menu/Store_BuyWithCredits"
      c241v10 = {}
      c241v8 = c241v8(c241v9, c241v10)
      c241v5 = c241v6 .. c241v7 .. c241v8
      c241v4.NameOverride = c241v5
      c241v2 = table.insert
      c241v2(c241v1, c241v4)
    end
    c241v4 = 1
    c241v5 = c241v0.items
    c241v2 = #c241v5
    c241v3 = 1
    for c241v4 = c241v4, c241v2, c241v3 do
      c241v7 = table.insert
      c241v7(c241v1, c241v5)
      c241v5 = { StoreItem = nil }
      c241v7 = c241v0.items
      c241v6 = c241v7[c241v4]
      c241v5.StoreItem = c241v6
      c241v6 = c241v5.StoreItem
      c241v6 = c241v6:GetItem()
      c241v7 = IsNull
      c241v7 = c241v7(c241v6)
      if not c241v7 then
        c241v9 = gKeyChainItemType
        c241v7 = c241v6:IsA(c241v9)
        if c241v7 then
          c241v7 = Localize
          c241v9 = c241v5.StoreItem
          c241v8 = tostring
          c241v8 = c241v8(c241v9:GetLocalizeTag())
          c241v9 = {}
          c241v7 = c241v7(c241v8, c241v9)
          c241v8 = Localize
          c241v9 = "/Lotus/Language/Menu/MissionReward_Quest"
          c241v10 = { QUEST = nil }
          c241v10.QUEST = c241v7
          c241v8 = c241v8(c241v9, c241v10)
          c241v5.NameOverride = c241v8
        end
      end
    end
    c241v4 = 1
    c241v5 = c241v0.countedStoreItems
    c241v2 = #c241v5
    c241v3 = 1
    for c241v4 = c241v4, c241v2, c241v3 do
      c241v6 = c241v0.countedStoreItems
      c241v5 = c241v6[c241v4]
      c241v6 = c241v5.mStoreItem
      c241v7 = IsNull
      c241v7 = c241v7(c241v6)
      if not c241v7 then
        c241v7 = { StoreItem = nil, SkipTitleCase = true }
        c241v7.StoreItem = c241v6
        c241v8 = Localize
        c241v9 = "/Lotus/Language/Items/LargeBatchItem"
        c241v10 = { ITEM = nil, NUM = nil }
        c241v11 = TitleCase
        c241v12 = Localize
        c241v13 = tostring
        c241v13 = c241v13(c241v6:GetLocalizeTag())
        c241v14 = {}
        c241v11 = c241v11(c241v12(c241v13, c241v14))
        c241v10.ITEM = c241v11
        c241v11 = vT[17]
        c241v11 = c241v11.FormatNumber
        c241v12 = c241v5.mItemCount
        c241v11 = c241v11(c241v12)
        c241v10.NUM = c241v11
        c241v8 = c241v8(c241v9, c241v10)
        c241v7.NameOverride = c241v8
        c241v8 = table.insert
        c241v8(c241v1, c241v7)
      end
    end
    c241v4 = 1
    c241v5 = c241v0.countedItems
    c241v2 = #c241v5
    c241v3 = 1
    for c241v4 = c241v4, c241v2, c241v3 do
      c241v5 = Resource
      c241v7 = c241v0.countedItems
      c241v6 = c241v7[c241v4]
      c241v6 = c241v6.mItemType
      c241v5 = c241v5(c241v6)
      c241v6 = { ItemType = nil, Count = nil }
      c241v6.ItemType = c241v5
      c241v8 = c241v0.countedItems
      c241v7 = c241v8[c241v4]
      c241v7 = c241v7.mItemCount
      c241v6.Count = c241v7
      c241v11 = vT[17]
      c241v11 = c241v11.FormatNumber
      c241v13 = c241v0.countedItems
      c241v12 = c241v13[c241v4]
      c241v12 = c241v12.mItemCount
      c241v8 = c241v11(c241v12)
      c241v9 = " "
      c241v10 = Localize
      c241v11 = tostring
      c241v11 = c241v11(c241v5:GetLocalizeTag())
      c241v12 = {}
      c241v10 = c241v10(c241v11, c241v12)
      c241v7 = c241v8 .. c241v9 .. c241v10
      c241v6.NameOverride = c241v7
      c241v7 = table.insert
      c241v7(c241v1, c241v6)
    end
    do return c241v1 end
  end
  GetRewardInfo = vT[119]
  vT[119] = function(c242v0)
    local c242v1, c242v2, c242v3
    c242v2 = DAMAGE_TYPE_TAGS
    c242v3 = c242v0 + 1
    c242v1 = c242v2[c242v3]
    do return c242v1 end
  end
  GetDamageTypeTag = vT[119]
  vT[119] = function(c243v0)
    local c243v1, c243v2, c243v3, c243v6
    c243v1 = DAMAGE_TYPE_TAGS
    c243v2 = nil
    c243v3 = nil
    for c243v4, c243v5 in c243v1, c243v2, c243v3 do
      if c243v5 == c243v0 then
        c243v6 = c243v4 - 1
        do return c243v6 end
      end
    end
    c243v1 = nil
    do return c243v1 end
  end
  GetDamageTypeIndex = vT[119]
  vT[119] = function(c244v0)
    local c244v1, c244v2, c244v3
    c244v2 = vT[0]
    c244v3 = c244v0 + 1
    c244v1 = c244v2[c244v3]
    do return c244v1 end
  end
  GetResistTag = vT[119]
  vT[119] = function(c245v0)
    local c245v1, c245v2, c245v3
    c245v2 = vT[1]
    c245v3 = c245v0 + 1
    c245v1 = c245v2[c245v3]
    do return c245v1 end
  end
  GetProcTypeTag = vT[119]
  vT[119] = function()
    local c246v0, c246v1, c246v2
    c246v0 = Lotus_Game.LotusMissionInfo
    c246v0 = c246v0()
    c246v1 = 12
    c246v0.missionType = c246v1
    c246v1 = 1
    c246v0.faction = c246v1
    c246v1 = WeakResource
    c246v2 = "/Lotus/Levels/Proc/Corpus/CorpusGasCityHarvester"
    c246v1 = c246v1(c246v2)
    c246v0.levelOverride = c246v1
    c246v1 = Resource
    c246v2 = "/Lotus/Types/Game/EnemySpecs/CorpusSquadA"
    c246v1 = c246v1(c246v2)
    c246v0.enemySpec = c246v1
    c246v1 = true
    c246v0.soloMode = c246v1
    c246v1 = Symbol
    c246v2 = "/Lotus/Language/Locations/Jupiter"
    c246v1 = c246v1(c246v2)
    c246v0.location = c246v1
    do return c246v0 end
  end
  GetRecoveryMissionInfo = vT[119]
  vT[119] = function(c247v0)
    local c247v1, c247v2, c247v3, c247v4, c247v5, c247v6
    c247v1 = Clamp
    c247v3 = 0
    c247v4 = 100
    c247v1 = c247v1(c247v0, c247v3, c247v4)
    c247v2 = math.floor
    c247v2 = c247v2(c247v1)
    c247v6 = c247v1 * 10
    c247v5 = math.floor
    c247v5 = c247v5(c247v6)
    c247v4 = math.abs
    c247v4 = c247v4(c247v5)
    c247v3 = c247v4 % 10
    if not (((c247v2 ~= 0 or c247v3 ~= 0) or c247v1 == 0)) then
      c247v3 = 1
    end
    c247v4 = tostring
    c247v4 = c247v4(c247v2)
    if c247v3 ~= 0 then
      c247v6 = "."
      c247v4 = c247v4 .. c247v6 .. c247v3
    end
    c247v6 = "%"
    c247v4 = c247v4 .. c247v6
    do return c247v4 end
  end
  FormatGoalPercentage = vT[119]
  vT[119] = function(c248v0)
    local c248v1, c248v2, c248v3, c248v4, c248v5, c248v6
    c248v1 = vT[17]
    c248v1 = c248v1.GetEntityFromTag
    c248v2 = "AvatarLight"
    c248v3 = vT[17]
    c248v3 = c248v3.Ternary
    c248v4 = vT[61]
    c248v4 = c248v4()
    c248v5 = gBackgroundRegion
    c248v6 = nil
    c248v1 = c248v1(c248v2, c248v3(c248v4, c248v5, c248v6))
    c248v2 = IsNull
    c248v2 = c248v2(c248v1)
    if not c248v2 then
      if c248v0 then
        c248v1:TurnOn()
        c248v2 = GetConfigBool
        c248v3 = "Graphics.DynamicLighting"
        c248v2 = c248v2(c248v3)
        c248v5 = not c248v2
        c248v1:Name__bb7f3496(c248v5)
        do return end
      end
      c248v1:TurnOff()
    end
    do return end
  end
  vT[120] = function(c249v0)
    local c249v1
    c249v1 = vT[119]
    c249v1(c249v0)
    do return end
  end
  AvatarLight = vT[120]
  vT[120] = function()
    local c250v0, c250v1, c250v2, c250v3, c250v4
    c250v1 = _T.BackgroundMovie
    c250v0 = IsNull
    c250v0 = c250v0(c250v1)
    if not c250v0 then
      c250v0 = vT[47]
      c250v0 = c250v0()
      c250v3 = Symbol
      c250v4 = "Kneel"
      c250v0:SetAnimAction(c250v3(c250v4))
      c250v1 = vT[119]
      c250v2 = false
      c250v1(c250v2)
      c250v1 = gRegion
      c250v1 = c250v1:GetLevelInfo()
      c250v2 = c250v1.postProcess
      c250v3 = 0
      c250v2.horizonDOF = c250v3
      c250v2 = _T
      c250v3 = nil
      c250v2.SelectedLoadOutPart = c250v3
    end
    do return end
  end
  MakeMainMenuAvatarKneel = vT[120]
  vT[120] = function(c251v0)
    local c251v1, c251v2, c251v3
    c251v1 = print
    c251v2 = "OnSaveLoadOutCompleteCommon"
    c251v1(c251v2)
    c251v2 = gGameRules
    c251v1 = IsNull
    c251v1 = c251v1(c251v2)
    if not c251v1 then
      c251v1 = gGameRules
      c251v1:SendLobbyLoadout()
    end
    c251v1 = gMatchingService
    c251v1 = c251v1:GetSession()
    c251v2 = IsNull
    c251v2 = c251v2(c251v1)
    if not c251v2 then
      c251v2 = gMatchingService
      c251v2 = c251v2:IsHost()
      if c251v2 then
        c251v2 = c251v1:GetSettings()
        c251v3 = vT[115]
        c251v3 = c251v3()
        c251v2.eloRating = c251v3
        c251v3 = gMatchingService
        c251v3:UpdateSessionSettings(c251v2, c251v0)
      end
    end
    c251v2 = gMatchingService
    c251v2:UpdateLocalLoadout()
    do return end
  end
  OnSaveLoadOutCompleteCommon = vT[120]
  vT[120] = function(c252v0, c252v1)
    local c252v2, c252v3, c252v4, c252v5, c252v6, c252v7, c252v8, c252v9, c252v12, c252v13, c252v14, c252v15
    if c252v1 == nil then
      c252v1 = ""
    else
      c252v2 = " "
      c252v1 = c252v2 .. c252v1
    end
    c252v2 = c252v0:GetLevel()
    c252v3 = Localize
    c252v4 = c252v0:GetLocalizeTag()
    c252v4 = c252v4:c_str()
    c252v5 = nil
    c252v3 = c252v3(c252v4, c252v5)
    c252v5 = "<p><font face=\"Noto Sans\"><b>"
    c252v13 = Localize
    c252v14 = "/Lotus/Language/Menu/LevelAbbreviation"
    c252v15 = nil
    c252v6 = c252v13(c252v14, c252v15)
    c252v7 = " "
    c252v13 = tostring
    c252v8 = c252v13(c252v2)
    c252v9 = " </b>"
    c252v12 = "</font></p>"
    c252v4 = c252v5 .. c252v6 .. c252v7 .. c252v8 .. c252v9 .. c252v3 .. c252v1 .. c252v12
    do return c252v4 end
  end
  MakeLevelItemString = vT[120]
  vT[120] = function(c253v0)
    local c253v1, c253v2, c253v3, c253v4, c253v5, c253v6
    c253v2 = gGameRules
    c253v1 = IsNull
    c253v1 = c253v1(c253v2)
    c253v1 = gGameRules
    c253v1 = c253v1:Name__c79ce1a0()
    c253v2 = IsNull
    c253v2 = c253v2(c253v1)
    c253v4 = 1
    c253v2 = #c253v1
    c253v3 = 1
    for c253v4 = c253v4, c253v2, c253v3 do
      c253v5 = c253v1[c253v4]
      c253v5 = c253v5.playerName
      c253v6 = c253v0:GetPlayer()
      c253v6 = c253v6:GetPlayerName()
      if c253v5 == c253v6 then break end
      if c253v5 == c253v6 then
        c253v5 = true
        do return c253v5 end
      end
    end
    c253v1 = _T.gCorpusHarvesterFinisherVictim
    if c253v1 == c253v0 then
      c253v1 = true
      do return c253v1 end
    end
    c253v1 = IsNull
    c253v1 = c253v1(c253v0)
    c253v1 = false
    do return c253v1 end
  end
  IsHarvestedOrBranded = vT[120]
  vT[120] = function()
    local c254v0, c254v1, c254v3
    local p13 = 0
    if p13 == 0 then
      c254v1 = gClient
      c254v0 = IsNull
      c254v0 = c254v0(c254v1)
      if c254v0 then
        p13 = 9
      else
        p13 = 1
      end
    end
    if p13 == 1 then
      c254v0 = gGameRules
      c254v1 = IsNull
      c254v1 = c254v1(c254v0)
      if c254v1 then
        p13 = 9
      else
        p13 = 2
      end
    end
    if p13 == 2 then
      c254v3 = gLotusAttractModeGameRulesType
      c254v1 = c254v0:IsA(c254v3)
      if not c254v1 then
        p13 = 4
      else
        p13 = 3
      end
    end
    if p13 == 3 then
      c254v1 = UI_MODE_IN_SPACE_SHIP
      do return c254v1 end
    end
    if p13 == 4 then
      c254v3 = gLotusDojoGameRulesType
      c254v1 = c254v0:IsA(c254v3)
      if c254v1 then
        p13 = 6
      else
        p13 = 5
      end
    end
    if p13 == 5 then
      c254v3 = gLotusDuelGameRulesType
      c254v1 = c254v0:IsA(c254v3)
      if not c254v1 then
        p13 = 7
      else
        p13 = 6
      end
    end
    if p13 == 6 then
      c254v1 = UI_MODE_IN_DOJO
      do return c254v1 end
    end
    if p13 == 7 then
      c254v3 = gLotusHubGameRulesType
      c254v1 = c254v0:IsA(c254v3)
      if not c254v1 then
        p13 = 9
      else
        p13 = 8
      end
    end
    if p13 == 8 then
      c254v1 = UI_MODE_IN_SPACE_HUB
      do return c254v1 end
    end
    if p13 == 9 then
      c254v0 = UI_MODE_IN_GAME
      do return c254v0 end
    end
  end
  vT[121] = function()
    local c255v0
    c255v0 = vT[120]
    do return c255v0() end
  end
  GetUIMode = vT[121]
  vT[121] = function(c256v0)
    local c256v1, c256v2
    local p7 = 0
    if p7 == 0 then
      c256v1 = Engine.IsOSKAvailable
      c256v1 = c256v1()
      if not c256v1 then
        p7 = 6
      else
        p7 = 1
      end
    end
    if p7 == 1 then
      c256v1 = Engine.IsPlayingWithController
      c256v1 = c256v1()
      if c256v1 then
        p7 = 6
      else
        p7 = 2
      end
    end
    if p7 == 2 then
      c256v1 = Engine.Name__9472b1e7
      c256v1 = c256v1()
      if c256v1 then
        p7 = 6
      else
        p7 = 3
      end
    end
    if p7 == 3 then
      c256v2 = Engine.IsMobile
      c256v2 = c256v2()
      if not c256v2 then
        p7 = 5
      else
        p7 = 4
      end
    end
    if p7 == 4 then
      c256v2 = Engine.IsAndroid
      c256v2 = c256v2()
      c256v1 = not c256v2
      if c256v1 then
        p7 = 6
      else
        p7 = 5
      end
    end
    if p7 == 5 then
      c256v2 = Engine.IsConsole
      c256v2 = c256v2()
      c256v1 = c256v2 and c256v0
      p7 = 6
    end
    if p7 == 6 then
      do return c256v1 end
    end
  end
  IsOSKAvailable = vT[121]
  vT[121] = function(c257v0, c257v1, c257v2, c257v3, c257v4, c257v5, c257v6, c257v7)
    local c257v8, c257v9, c257v10, c257v11, c257v12, c257v13, c257v14, c257v15, c257v16, c257v17, c257v19
    c257v9 = gRegion
    c257v8 = IsNull
    c257v8 = c257v8(c257v9)
    if c257v8 then
      c257v8 = false
      do return c257v8 end
    end
    c257v8 = { isMultiline = false, cancelDisabled = false, forChat = false, desc = nil, isEmail = false, doFilter = true }
    c257v9 = pairs
    c257v9, c257v10, c257v11 = c257v9(c257v6)
    for c257v12, c257v13 in c257v9, c257v10, c257v11 do
      c257v8[c257v12] = c257v13
    end
    for c257v12, c257v13 in c257v9, c257v10, c257v11 do
    end
    c257v9 = true
    c257v10 = IsNull
    c257v10 = c257v10(c257v0)
    if not c257v10 then
      c257v10 = vT[41]
      c257v12 = 1
      c257v10 = c257v10(c257v0, c257v12)
      c257v11 = false
      c257v12 = #c257v5
      c257v13 = 0
      if c257v13 < c257v12 then
        c257v13 = c257v10[c257v5]
        c257v12 = type
        c257v12 = c257v12(c257v13)
        if c257v12 ~= "function" then
          c257v11 = false
        else
          c257v11 = true
        end
      end
      c257v9 = c257v11
    end
    c257v10 = IsOSKAvailable
    c257v10 = c257v10(c257v7)
    if not ((not c257v10 or not c257v9)) then
      c257v10 = Localize
      c257v12 = {}
      c257v1 = c257v10(c257v1, c257v12)
      if c257v3 ~= 0 then
        c257v10 = gRegion
        c257v15 = false
        c257v16 = c257v8.isEmail
        c257v17 = c257v8.forChat
        do return c257v10:Name__32c39a60(c257v2, c257v1, c257v1, c257v15, c257v16, c257v17, c257v5, c257v3) end
      end
      c257v10 = gRegion
      c257v15 = false
      c257v16 = c257v8.isEmail
      c257v17 = c257v8.forChat
      c257v19 = c257v8.doFilter
      do return c257v10:Name__5a873eef(c257v2, c257v1, c257v1, c257v15, c257v16, c257v17, c257v5, c257v19) end
    end
    c257v11 = _G
    c257v11 = c257v11.UIMovie_InputDialogMovie
    c257v10 = IsNull
    c257v10 = c257v10(c257v11)
    if c257v10 then
      do return end
    end
    c257v10 = nil
    c257v11 = IsNull
    c257v11 = c257v11(c257v0)
    if not c257v11 then
      c257v13 = _G
      c257v13 = c257v13.UIMovie_InputDialogMovie
      c257v10 = c257v0:PushChildMovie(c257v13)
    else
      c257v11 = gFlashMgr
      c257v13 = _G
      c257v13 = c257v13.UIMovie_InputDialogMovie
      c257v10 = c257v11:GotoMovie(c257v13)
    end
    c257v13 = "SetYesTag"
    c257v14 = "/Menu/Confirm_Item_Ok"
    c257v10:Execute(c257v13, c257v14)
    c257v11 = "/Menu/Confirm_Item_Cancel"
    c257v12 = c257v8.noTag
    if c257v12 ~= nil then
      c257v11 = c257v8.noTag
    end
    c257v14 = "SetNoTag"
    c257v10:Execute(c257v14, c257v11)
    c257v12 = c257v8.cancelDisabled
    if c257v12 then
      c257v14 = "SetCancelEnable"
      c257v15 = "false"
      c257v10:Execute(c257v14, c257v15)
    end
    c257v14 = "SetCaption"
    c257v15 = {c257v1}
    c257v10:Name__8b1f0505(c257v14, c257v15)
    c257v12 = c257v8.desc
    if c257v12 ~= nil then
      c257v14 = "SetText"
      c257v16 = c257v8.desc
      c257v15 = {c257v16}
      c257v10:Name__8b1f0505(c257v14, c257v15)
    end
    c257v12 = c257v8.isMultiline
    if c257v12 then
      c257v14 = "SetMultiline"
      c257v15 = ""
      c257v10:Execute(c257v14, c257v15)
    end
    c257v14 = "SetContent"
    c257v15 = {c257v2}
    c257v10:Name__8b1f0505(c257v14, c257v15)
    if c257v3 ~= 0 then
      c257v14 = "SetMaxChars"
      c257v10:Execute(c257v14, c257v3)
    end
    c257v14 = "SetCallback"
    c257v10:Execute(c257v14, c257v4)
    c257v12 = true
    do return c257v12, c257v10 end
  end
  vT[122] = function(c258v0, c258v1, c258v2, c258v3, c258v4, c258v5, c258v6)
    local c258v7
    c258v7 = vT[121]
    do return c258v7(c258v0, c258v1, c258v2, c258v3, c258v4, c258v5, c258v6) end
  end
  ShowInputDialog = vT[122]
  vT[122] = function()
    local c259v0, c259v1, c259v2, c259v3, c259v4, c259v5, c259v6, c259v8
    c259v0 = 0
    c259v1 = gGameData
    c259v2 = IsNull
    c259v2 = c259v2(c259v1)
    if not c259v2 then
      c259v4 = true
      c259v2 = c259v1:Name__6c55853f(c259v4)
      c259v5 = 1
      c259v3 = #c259v2
      c259v4 = 1
      for c259v5 = c259v5, c259v3, c259v4 do
        c259v6 = gGameConfig
        c259v8 = c259v2[c259v5]
        c259v8 = c259v8.mTier
        c259v6 = c259v6:Name__55bcce29(c259v8)
        c259v0 = c259v0 + c259v6
      end
    end
    do return c259v0 end
  end
  GetMaxAllianceMemberCount = vT[122]
  vT[122] = function(c260v0)
    local c260v1, c260v2
    c260v1 = tostring
    c260v0 = c260v1(c260v0)
    c260v1 = _T.CachedAlerts
    if c260v1 then
      c260v2 = _T.CachedAlerts
      c260v1 = c260v2[c260v0]
      if c260v1 ~= nil then
        c260v2 = _T.CachedAlerts
        c260v1 = c260v2[c260v0]
        c260v1 = c260v1.mVisible
        if c260v1 then
          c260v2 = _T.CachedAlerts
          c260v1 = c260v2[c260v0]
          c260v1 = c260v1.mAlertInfo
          c260v1 = c260v1.mMissionInfo
          do return c260v1 end
        end
      end
    end
    c260v1 = nil
    do return c260v1 end
  end
  vT[123] = function(c261v0)
    local c261v1
    c261v1 = vT[122]
    do return c261v1(c261v0) end
  end
  GetNodeAlertMissionInfo = vT[123]
  vT[123] = function(c262v0)
    local c262v1, c262v2, c262v3
    c262v1 = _T.CachedInvasionInfo
    if not ((not (c262v1 == nil) and c262v0 ~= nil)) then
      c262v1 = nil
      do return c262v1 end
    end
    c262v2 = _T.CachedInvasionInfo
    c262v3 = tostring
    c262v3 = c262v3(c262v0)
    c262v1 = c262v2[c262v3]
    do return c262v1 end
  end
  vT[124] = function(c263v0)
    local c263v1
    c263v1 = vT[123]
    do return c263v1(c263v0) end
  end
  GetInvasionInfo = vT[124]
  vT[124] = function(c264v0)
    local c264v1, c264v2, c264v3
    c264v2 = _G
    c264v2 = c264v2.CachedGoalInfo
    c264v3 = tostring
    c264v3 = c264v3(c264v0)
    c264v1 = c264v2[c264v3]
    do return c264v1 end
  end
  vT[125] = function(c265v0)
    local c265v1
    c265v1 = vT[124]
    do return c265v1(c265v0) end
  end
  GetGoalInfo = vT[125]
  vT[125] = function(c266v0)
    local c266v1, c266v2, c266v3, c266v4
    c266v1 = tostring
    c266v1 = c266v1(c266v0)
    c266v3 = _G
    c266v3 = c266v3.CachedGoalInfo
    c266v2 = c266v3[c266v1]
    if c266v2 then
      c266v4 = _G
      c266v4 = c266v4.CachedGoalInfo
      c266v3 = c266v4[c266v1]
      c266v3 = c266v3.mIcon
      c266v2 = IsNull
      c266v2 = c266v2(c266v3)
      if not c266v2 then
        c266v3 = _G
        c266v3 = c266v3.CachedGoalInfo
        c266v2 = c266v3[c266v1]
        c266v2 = c266v2.mIcon
        do return c266v2 end
      end
    end
    c266v2 = _G
    c266v2 = c266v2.UITexture_Event
    do return c266v2 end
  end
  vT[126] = function(c267v0)
    local c267v1
    c267v1 = vT[125]
    c267v1 = c267v1(c267v0)
    do return c267v1 end
  end
  GetEventTexture = vT[126]
  vT[126] = function(c268v0)
    local c268v1, c268v2, c268v3, c268v5, c268v6
    if not c268v0 then
      c268v1 = ""
      do return c268v1 end
    end
    c268v1 = Lotus_Game.Name__abcf5101
    c268v2 = c268v0.missionType
    c268v1 = c268v1(c268v2)
    c268v2 = nil
    if c268v1 == nil then
      c268v1 = ""
      do return c268v1, c268v2 end
    end
    c268v3 = c268v0.location
    local c268v4 = MARS_DUAL_DEFENSE_TAG
    if c268v0 then
      local p39 = 5
      if p39 == 5 then
        c268v3 = c268v0.location
        c268v4 = DEIMOS_DUAL_DEFENSE_TAG
        if c268v3 ~= c268v4 then
          p39 = 7
        else
        end
      end
      if p39 == 7 then
        c268v3 = c268v0.forceAllyFaction
        if not c268v3 then
          p39 = 9
        else
          p39 = 8
        end
      end
      if p39 == 8 then
        c268v1 = "Crossfire"
        do return c268v1, c268v1 end
      end
      if p39 == 9 then
        c268v3 = c268v0.goalTag
        c268v4 = vT[22]
        c268v4 = c268v4.mKuvaSurvivalTag
        if c268v3 ~= c268v4 then
          p39 = 11
        else
          p39 = 10
        end
      end
      if p39 == 10 then
        c268v1 = "KuvaSurvival"
        do return c268v1, c268v2 end
      end
      if p39 == 11 then
        c268v3 = c268v0.goalTag
        c268v4 = vT[22]
        c268v4 = c268v4.mVoidEclipseSurvivalTag
        if c268v3 ~= c268v4 then
          p39 = 13
        else
          p39 = 12
        end
      end
      if p39 == 12 then
        c268v1 = "VoidEclipse"
        do return c268v1, c268v2 end
      end
      if p39 == 13 then
        c268v4 = c268v0.vipAgent
        c268v3 = IsNull
        c268v3 = c268v3(c268v4)
        if c268v3 then
          p39 = 16
        else
          p39 = 14
        end
      end
      if p39 == 14 then
        c268v3 = c268v0.vipAgent
        c268v5 = stageDefenseAgent
        c268v3 = c268v3:IsA(c268v5)
        if not c268v3 then
          p39 = 16
        else
          p39 = 15
        end
      end
      if p39 == 15 then
        c268v1 = "StageDefense"
        do return c268v1, c268v2 end
      end
      if p39 == 16 then
        c268v3 = c268v0.missionType
        c268v4 = 32
        if c268v3 ~= c268v4 then
          p39 = 24
        else
          p39 = 17
        end
      end
      if p39 == 17 then
        c268v3 = c268v0.faction
        c268v4 = 1
        if c268v3 ~= c268v4 then
          p39 = 24
        else
          p39 = 18
        end
      end
      if p39 == 18 then
        c268v4 = c268v0.levelOverride
        c268v3 = IsNull
        c268v3 = c268v3(c268v4)
        if c268v3 then
          p39 = 24
        else
          p39 = 19
        end
      end
      if p39 == 19 then
        c268v4 = c268v0.levelOverride
        c268v3 = tostring
        c268v3 = c268v3(c268v4:GetFullName())
        c268v5 = c268v0.keyChainName
        c268v4 = IsNull
        c268v4 = c268v4(c268v5)
        if not c268v4 then
          p39 = 21
        else
          p39 = 20
        end
      end
      if p39 == 20 then
        c268v4 = string.find
        c268v6 = "Quest"
        c268v4 = c268v4(c268v3, c268v6)
        if c268v4 == nil then
          p39 = 22
        else
          p39 = 21
        end
      end
      if p39 == 21 then
        c268v1 = "Generic"
        do return c268v1, c268v2 end
      end
      if p39 == 22 then
        c268v4 = string.find
        c268v5 = string.reverse
        c268v5 = c268v5(c268v3)
        c268v6 = "%u"
        c268v4 = c268v4(c268v5, c268v6)
        if c268v4 == nil then
          p39 = 24
        else
          p39 = 23
        end
      end
      if p39 == 23 then
        c268v6 = string.len
        c268v6 = c268v6(c268v3)
        c268v5 = c268v6 - c268v4
        c268v4 = c268v5 + 1
        c268v5 = string.sub
        c268v5 = c268v5(c268v3, c268v4)
        c268v1 = c268v1 .. c268v5
        p39 = 24
      end
      if p39 == 24 then
        do return c268v1, c268v2 end
      end
    end
    c268v1 = "DualDefense"
    do return c268v1, c268v2 end
  end
  vT[127] = function(c269v0)
    local c269v1
    c269v1 = vT[126]
    do return c269v1(c269v0) end
  end
  GetMissionTypeName = vT[127]
  vT[127] = function(c270v0)
    local c270v1, c270v2
    c270v2 = 35
    if c270v0 ~= c270v2 then
      c270v1 = false
    else
      c270v1 = true
    end
    do return c270v1 end
  end
  HasTutorialForMissionType = vT[127]
  vT[127] = function(c271v0)
    local c271v1, c271v2, c271v3
    c271v1 = Localize
    c271v3 = FactionNames
    c271v2 = c271v3[c271v0]
    c271v3 = nil
    do return c271v1(c271v2, c271v3) end
  end
  vT[128] = function(c272v0)
    local c272v1
    c272v1 = vT[127]
    do return c272v1(c272v0) end
  end
  GetLocalizedFactionName = vT[128]
  vT[128] = function(c273v0, c273v1, c273v2, c273v3, c273v4)
    local c273v5, c273v6, c273v7, c273v8, c273v10, c273v11, c273v12
    c273v5 = ""
    c273v7 = c273v0.levelOverride
    c273v6 = IsNull
    c273v6 = c273v6(c273v7)
    if not c273v6 then
      c273v6 = c273v0.levelOverride
      c273v5 = c273v6:GetFullName()
    end
    c273v6 = nil
    c273v8 = gClient
    c273v7 = IsNull
    c273v7 = c273v7(c273v8)
    if c273v7 then
      do return c273v6 end
    end
    c273v7 = nil
    local c273v9 = string.find
    c273v10 = c273v0.sortieId
    c273v11 = "_Lite_"
    c273v9 = c273v9(c273v10, c273v11)
    if c273v9 == nil then
      c273v8 = false
    else
      c273v8 = true
    end
    c273v10 = c273v0.icon
    c273v9 = IsNull
    c273v9 = c273v9(c273v10)
    if c273v6 then
      c273v9 = IsNull
      c273v9 = c273v9(c273v2)
      if not c273v9 then
        c273v6 = c273v2.icon
      else
        c273v6 = c273v0.icon
      end
    else
      local p71 = 11
      if p71 == 11 then
        c273v9 = c273v0.missionType
        c273v10 = 22
        if c273v9 ~= c273v10 then
          p71 = 13
        else
          p71 = 12
        end
      end
      if p71 == 12 then
        c273v9 = _G
        c273v6 = c273v9.UITextures_ArenaLocation
      end
      if p71 == 13 then
        c273v9 = c273v0.missionType
        c273v10 = 23
        if c273v9 ~= c273v10 then
          p71 = 15
        else
          p71 = 14
        end
      end
      if p71 == 14 then
        c273v9 = _G
        c273v6 = c273v9.UITextures_JunctionLocation
      end
      if p71 == 15 then
        c273v9 = c273v0.missionType
        c273v10 = 28
        if c273v9 ~= c273v10 then
          p71 = 17
        else
          p71 = 16
        end
      end
      if p71 == 16 then
        c273v9 = _G
        c273v7 = c273v9.UITextures_EidolonPlains
      end
      if p71 == 17 then
        c273v9 = string.find
        c273v11 = "Asteroid"
        c273v9 = c273v9(c273v5, c273v11)
        if not c273v9 then
          p71 = 19
        else
          p71 = 18
        end
      end
      if p71 == 18 then
        c273v9 = _G
        c273v7 = c273v9.UITextures_GrineerAsteroid
      end
      if p71 == 19 then
        c273v9 = string.find
        c273v11 = "GasCity"
        c273v9 = c273v9(c273v5, c273v11)
        if not c273v9 then
          p71 = 21
        else
          p71 = 20
        end
      end
      if p71 == 20 then
        c273v9 = vT[17]
        c273v9 = c273v9.Ternary
        c273v11 = _G
        c273v11 = c273v11.UITextures_NarmerGasCity
        c273v12 = _G
        c273v12 = c273v12.UITextures_GasCity
        c273v7 = c273v9(c273v8, c273v11, c273v12)
      end
      if p71 == 21 then
        c273v9 = string.find
        c273v11 = "Galleon"
        c273v9 = c273v9(c273v5, c273v11)
        if not c273v9 then
          p71 = 23
        else
          p71 = 22
        end
      end
      if p71 == 22 then
        c273v9 = _G
        c273v7 = c273v9.UITextures_GrineerShip
      end
      if p71 == 23 then
        c273v9 = string.find
        c273v11 = "Outpost"
        c273v9 = c273v9(c273v5, c273v11)
        if not c273v9 then
          p71 = 25
        else
          p71 = 24
        end
      end
      if p71 == 24 then
        c273v9 = _G
        c273v7 = c273v9.UITextures_Outpost
      end
      if p71 == 25 then
        c273v9 = string.find
        c273v11 = "InfestedCorpus"
        c273v9 = c273v9(c273v5, c273v11)
        if c273v9 then
          p71 = 27
        else
          p71 = 26
        end
      end
      if p71 == 26 then
        c273v9 = string.find
        c273v11 = "InfestedHive"
        c273v9 = c273v9(c273v5, c273v11)
        if not c273v9 then
          p71 = 28
        else
          p71 = 27
        end
      end
      if p71 == 27 then
        c273v9 = _G
        c273v7 = c273v9.UITextures_InfestedCorpusShip
      end
      if p71 == 28 then
        c273v9 = string.find
        c273v11 = "IcePlanet"
        c273v9 = c273v9(c273v5, c273v11)
        if not c273v9 then
          p71 = 30
        else
          p71 = 29
        end
      end
      if p71 == 29 then
        c273v9 = _G
        c273v7 = c273v9.UITextures_IcePlanet
      end
      if p71 == 30 then
        c273v9 = string.find
        c273v11 = "Corpus"
        c273v9 = c273v9(c273v5, c273v11)
        if not c273v9 then
          p71 = 32
        else
          p71 = 31
        end
      end
      if p71 == 31 then
        c273v9 = _G
        c273v7 = c273v9.UITextures_CorpusShip
      end
      if p71 == 32 then
        c273v9 = string.find
        c273v11 = "Settlement"
        c273v9 = c273v9(c273v5, c273v11)
        if not c273v9 then
          p71 = 34
        else
          p71 = 33
        end
      end
      if p71 == 33 then
        c273v9 = vT[17]
        c273v9 = c273v9.Ternary
        c273v11 = _G
        c273v11 = c273v11.UITextures_NarmerSettlement
        c273v12 = _G
        c273v12 = c273v12.UITextures_Settlement
        c273v7 = c273v9(c273v8, c273v11, c273v12)
      end
      if p71 == 34 then
        c273v9 = string.find
        c273v11 = "Forest"
        c273v9 = c273v9(c273v5, c273v11)
        if not c273v9 then
          p71 = 36
        else
          p71 = 35
        end
      end
      if p71 == 35 then
        c273v9 = vT[17]
        c273v9 = c273v9.Ternary
        c273v11 = _G
        c273v11 = c273v11.UITextures_NarmerGrineerForest
        c273v12 = _G
        c273v12 = c273v12.UITextures_GrineerForest
        c273v7 = c273v9(c273v8, c273v11, c273v12)
      end
      if p71 == 36 then
        c273v9 = string.find
        c273v11 = "Shipyard"
        c273v9 = c273v9(c273v5, c273v11)
        if not c273v9 then
          p71 = 38
        else
          p71 = 37
        end
      end
      if p71 == 37 then
        c273v9 = _G
        c273v7 = c273v9.UITextures_GrineerShipyard
      end
      if p71 == 38 then
        c273v9 = string.find
        c273v11 = "SpaceBattles/"
        c273v9 = c273v9(c273v5, c273v11)
        if not c273v9 then
          p71 = 40
        else
          p71 = 39
        end
      end
      if p71 == 39 then
        c273v9 = _G
        c273v6 = c273v9.UITextures_ArchwingTrench
      end
      if p71 == 40 then
        c273v9 = string.find
        c273v11 = "GrineerOcean"
        c273v9 = c273v9(c273v5, c273v11)
        if not c273v9 then
          p71 = 42
        else
          p71 = 41
        end
      end
      if p71 == 41 then
        c273v9 = _G
        c273v7 = c273v9.UITextures_GrineerOcean
      end
      if p71 == 42 then
        c273v9 = string.find
        c273v11 = "OrokinMoon"
        c273v9 = c273v9(c273v5, c273v11)
        if not c273v9 then
          p71 = 44
        else
          p71 = 43
        end
      end
      if p71 == 43 then
        c273v9 = _G
        c273v7 = c273v9.UITextures_OrokinMoon
      end
      if p71 == 44 then
        c273v9 = string.find
        c273v11 = "OrokinTower"
        c273v9 = c273v9(c273v5, c273v11)
        if not c273v9 then
          p71 = 46
        else
          p71 = 45
        end
      end
      if p71 == 45 then
        c273v9 = _G
        c273v7 = c273v9.UITextures_OrokinTower
      end
      if p71 == 46 then
        c273v9 = string.find
        c273v11 = "Space/"
        c273v9 = c273v9(c273v5, c273v11)
        if not c273v9 then
          p71 = 48
        else
          p71 = 47
        end
      end
      if p71 == 47 then
        c273v9 = _G
        c273v6 = c273v9.UITextures_ArchwingFreeFlight
      end
      if p71 == 48 then
        c273v9 = string.find
        c273v11 = "Fortress"
        c273v9 = c273v9(c273v5, c273v11)
        if not c273v9 then
          p71 = 50
        else
          p71 = 49
        end
      end
      if p71 == 49 then
        c273v9 = _G
        c273v7 = c273v9.UITextures_GrineerFortress
      end
      if p71 == 50 then
        c273v9 = IsNull
        c273v9 = c273v9(c273v1)
        if c273v9 then
          p71 = 52
        else
          p71 = 51
        end
      end
      if p71 == 51 then
        c273v9 = c273v1.nodeType
        c273v10 = 1
        if c273v9 == c273v10 then
          p71 = 53
        else
          p71 = 52
        end
      end
      if p71 == 52 then
        if c273v3 == nil then
        else
          p71 = 53
        end
      end
      if p71 == 53 then
        c273v9 = vT[125]
        c273v10 = c273v1.name
        c273v6 = c273v9(c273v10)
      end
    end
    if not ((c273v6 ~= nil or c273v7 == nil)) then
      c273v9 = c273v4
      if not c273v9 then
        c273v9 = SRandomInt
        c273v10 = 1
        c273v11 = #c273v7
        c273v9 = c273v9(c273v10, c273v11)
      end
      c273v6 = c273v7[c273v9]
    end
    do return c273v6 end
  end
  vT[129] = function(c274v0, c274v1, c274v2, c274v3, c274v4)
    local c274v5
    c274v5 = vT[128]
    do return c274v5(c274v0, c274v1, c274v2, c274v3, c274v4) end
  end
  GetLocationTexture = vT[129]
  vT[129] = function(c275v0)
    local c275v1, c275v2, c275v3, c275v5, c275v6, c275v7, c275v8, c275v9, c275v10, c275v11, c275v13, c275v14, c275v15
    c275v3 = c275v0.levelOverride
    c275v2 = IsNull
    c275v2 = c275v2(c275v3)
    c275v1 = not c275v2
    if c275v1 then
      c275v3 = c275v0.levelOverride
      c275v2 = tostring
      c275v2 = c275v2(c275v3:GetFullName())
      if c275v2 ~= "/Lotus/Levels/Proc/Orokin/OrokinMoonSpy" then
        c275v1 = false
      else
        c275v1 = true
      end
    end
    c275v3 = c275v0.location
    local c275v4 = MARS_DUAL_DEFENSE_TAG
    if c275v3 ~= c275v4 then
      c275v2 = false
    else
      c275v2 = true
    end
    c275v3 = c275v0.forceAllyFaction
    if (not ((c275v3 or c275v1)) and not c275v2) then
      do return end
    end
    c275v3 = c275v0.invasionAllyFaction
    c275v4 = 3
    if not c275v1 then
      c275v4 = c275v0.faction
      c275v5 = 0
      if c275v4 == c275v5 then
        c275v3 = 1
      else
        c275v4 = c275v0.faction
        c275v5 = 2
        if c275v4 == c275v5 then
          c275v4 = ""
          c275v6 = c275v0.enemySpec
          c275v5 = IsNull
          c275v5 = c275v5(c275v6)
          if not c275v5 then
            c275v6 = string.lower
            c275v7 = c275v0.enemySpec
            c275v6 = c275v6(c275v7:GetFullName())
            c275v4 = c275v4 .. c275v6
          end
          c275v6 = c275v0.extraEnemySpec
          c275v5 = IsNull
          c275v5 = c275v5(c275v6)
          if not c275v5 then
            c275v6 = string.lower
            c275v7 = c275v0.extraEnemySpec
            c275v6 = c275v6(c275v7:GetFullName())
            c275v4 = c275v4 .. c275v6
          end
          c275v5 = string.find
          c275v7 = "corpus"
          c275v5 = c275v5(c275v4, c275v7)
          if c275v5 then
            c275v3 = 1
          else
            c275v3 = 0
          end
        else
          c275v3 = 0
        end
      end
    end
    c275v4 = vT[127]
    c275v4 = c275v4(c275v3)
    c275v5 = vT[127]
    c275v6 = c275v0.faction
    c275v5 = c275v5(c275v6)
    if c275v2 then
      c275v6 = string.upper
      c275v7 = Localize
      c275v8 = "/Lotus/Language/Missions/DualDefenseCompare"
      c275v9 = { FACTION1 = nil, FACTION2 = nil }
      c275v9.FACTION1 = c275v4
      c275v9.FACTION2 = c275v5
      do return c275v6(c275v7(c275v8, c275v9)) end
    end
    c275v6 = string.upper
    c275v9 = " "
    c275v13 = Localize
    c275v14 = "/Lotus/Language/Menu/MissionBoard_InvasionRewardCompare"
    c275v15 = nil
    c275v10 = c275v13(c275v14, c275v15)
    c275v11 = " "
    c275v7 = c275v4 .. c275v9 .. c275v10 .. c275v11 .. c275v5
    do return c275v6(c275v7) end
  end
  vT[130] = function(c276v0)
    local c276v1
    c276v1 = vT[129]
    do return c276v1(c276v0) end
  end
  TryGetCrossfireDesc = vT[130]
  vT[130] = function(c277v0, c277v1)
    local c277v2
    c277v2 = c277v0
    if c277v2 then
      c277v2 = c277v0[c277v1]
    end
    do return c277v2 end
  end
  vT[131] = function(c278v0, c278v1, c278v2, c278v3, c278v4)
    local c278v5, c278v6, c278v7, c278v8, c278v9, c278v10, c278v11, c278v12, c278v13, c278v14, c278v15, c278v16, c278v17, c278v18, c278v19, c278v20, c278v21, c278v22, c278v23, c278v24, c278v25, c278v26, c278v27, c278v28, c278v29, c278v30, c278v31, c278v32, c278v33, c278v34, c278v35, c278v36, c278v37, c278v38, c278v39, c278v40, c278v42, c278v43, c278v44, c278v47, c278v48
    c278v5 = c278v3
    c278v6 = IsNull
    c278v6 = c278v6(c278v5)
    if c278v6 then
      c278v6 = vT[41]
      c278v6 = c278v6()
      c278v5 = c278v6.mMovie
    end
    c278v6 = c278v1
    c278v7 = vT[122]
    c278v8 = c278v0.name
    c278v7 = c278v7(c278v8)
    c278v8 = vT[124]
    c278v9 = c278v0.name
    c278v8 = c278v8(c278v9)
    c278v9 = nil
    c278v10 = nil
    c278v11 = nil
    c278v12 = nil
    c278v13 = nil
    c278v15 = c278v0.name
    c278v14 = tostring
    c278v14 = c278v14(c278v15)
    c278v15 = false
    c278v16 = c278v0.radialSector
    c278v17 = IsNull
    c278v17 = c278v17(c278v16)
    if not c278v17 then
      c278v18 = c278v16.keyChain
      c278v17 = IsNull
      c278v17 = c278v17(c278v18)
      if not c278v17 then
        c278v15 = true
      else
        c278v18 = c278v1.levelKeyName
        c278v17 = IsNull
        c278v17 = c278v17(c278v18)
        if not c278v17 then
          c278v18 = c278v1.keyChainName
          c278v17 = IsNull
          c278v17 = c278v17(c278v18)
          if not c278v17 then
            c278v15 = true
          end
        end
      end
    end
    c278v18 = c278v0.nodeType
    c278v19 = 7
    if c278v18 ~= c278v19 then
      c278v17 = false
    else
      c278v17 = true
    end
    c278v18 = c278v0.reconstructionProgress
    if not c278v6 then
      c278v18 = nil
      c278v19 = _T.CachedConstructionProjects
      c278v22 = 1
      c278v20 = #c278v19
      c278v21 = 1
      for c278v22 = c278v22, c278v20, c278v21 do
        c278v23 = c278v19[c278v22]
        c278v24 = c278v23.info
        c278v24 = c278v24.mNode
        c278v25 = c278v0.name
        if c278v24 == c278v25 then break end
        if c278v24 == c278v25 then
          c278v18 = c278v23
        end
      end
      local p239 = 16
      if p239 == 16 then
        if not c278v18 then
          p239 = 18
        else
          p239 = 17
        end
      end
      if p239 == 17 then
        c278v20 = c278v0.reconstructionProgress
        if c278v20 == 1 then
        else
          p239 = 18
        end
      end
      if p239 == 18 then
        c278v8 = nil
      end
    end
    local p240 = 19
    if p240 == 19 then
      c278v19 = c278v0.locked
      c278v18 = not c278v19
      if not c278v8 then
        p240 = 21
      else
        p240 = 20
      end
    end
    if p240 == 20 then
      c278v6 = c278v8.mMissionInfo
      p240 = 52
    end
    if p240 == 21 then
      if (not c278v18 or c278v15) then
        p240 = 52
      else
        p240 = 23
      end
    end
    if p240 == 23 then
      c278v19 = IsNull
      c278v19 = c278v19(c278v7)
      if c278v19 then
        p240 = 28
      else
        p240 = 24
      end
    end
    if p240 == 24 then
      c278v6 = c278v7
      c278v20 = _T.CachedAlerts
      c278v19 = c278v20[c278v14]
      if not c278v19 then
        p240 = 52
      else
        p240 = 25
      end
    end
    if p240 == 25 then
      c278v20 = _T.CachedAlerts
      c278v19 = c278v20[c278v14]
      c278v19 = c278v19.mVisible
      if not c278v19 then
        p240 = 52
      else
        p240 = 26
      end
    end
    if p240 == 26 then
      c278v20 = _T.CachedAlerts
      c278v19 = c278v20[c278v14]
      c278v19 = c278v19.mAlertInfo
      c278v19 = c278v19.mTag
      c278v20 = DARVO_TAG
      if c278v19 ~= c278v20 then
        p240 = 52
      else
        p240 = 27
      end
    end
    if p240 == 27 then
      c278v19 = _G
      c278v19 = c278v19.UITexture_Darvo
      c278v6.icon = c278v19
      p240 = 52
    end
    if p240 == 28 then
      c278v19 = vT[130]
      c278v20 = _T.CachedGhostTowerMissions
      c278v19 = c278v19(c278v20, c278v14)
      if not c278v19 then
        p240 = 32
      else
        p240 = 29
      end
    end
    if p240 == 29 then
      c278v20 = _T.CachedGhostTowerMissions
      c278v19 = c278v20[c278v14]
      c278v19 = c278v19.mUnlocked
      if not c278v19 then
        p240 = 32
      else
        p240 = 30
      end
    end
    if p240 == 30 then
      c278v20 = _T.CachedGhostTowerMissions
      c278v19 = c278v20[c278v14]
      c278v19 = c278v19.mShowInStarChart
      if not c278v19 then
        p240 = 32
      else
        p240 = 31
      end
    end
    if p240 == 31 then
      c278v19 = _T.CachedGhostTowerMissions
      c278v12 = c278v19[c278v14]
      c278v6 = c278v12.mMissionInfo
      p240 = 52
    end
    if p240 == 32 then
      c278v19 = vT[130]
      c278v20 = _T.CachedSyndicateMissions
      c278v19 = c278v19(c278v20, c278v14)
      if not c278v19 then
        p240 = 35
      else
        p240 = 33
      end
    end
    if p240 == 33 then
      c278v20 = _T.CachedSyndicateMissions
      c278v19 = c278v20[c278v14]
      c278v19 = c278v19.mVisible
      if not c278v19 then
        p240 = 35
      else
        p240 = 34
      end
    end
    if p240 == 34 then
      c278v19 = _T.CachedSyndicateMissions
      c278v9 = c278v19[c278v14]
      c278v6 = c278v9.mMissionInfo
      p240 = 52
    end
    if p240 == 35 then
      c278v19 = vT[130]
      c278v20 = _T.CachedSortieMissions
      c278v19 = c278v19(c278v20, c278v14)
      if not c278v19 then
        p240 = 38
      else
        p240 = 36
      end
    end
    if p240 == 36 then
      c278v20 = _T.CachedSortieMissions
      c278v19 = c278v20[c278v14]
      c278v19 = c278v19.mShowInStarChart
      if not c278v19 then
        p240 = 38
      else
        p240 = 37
      end
    end
    if p240 == 37 then
      c278v19 = _T.CachedSortieMissions
      c278v10 = c278v19[c278v14]
      c278v6 = c278v10.mMissionInfo
      p240 = 52
    end
    if p240 == 38 then
      c278v19 = vT[130]
      c278v20 = _T.CachedLiteSortieMissions
      c278v19 = c278v19(c278v20, c278v14)
      if not c278v19 then
        p240 = 41
      else
        p240 = 39
      end
    end
    if p240 == 39 then
      c278v20 = _T.CachedLiteSortieMissions
      c278v19 = c278v20[c278v14]
      c278v19 = c278v19.mShowInStarChart
      if not c278v19 then
        p240 = 41
      else
        p240 = 40
      end
    end
    if p240 == 40 then
      c278v19 = _T.CachedLiteSortieMissions
      c278v10 = c278v19[c278v14]
      c278v6 = c278v10.mMissionInfo
      p240 = 52
    end
    if p240 == 41 then
      c278v19 = vT[130]
      c278v20 = _T.CachedInvasionInfo
      c278v19 = c278v19(c278v20, c278v14)
      if not c278v19 then
        p240 = 44
      else
        p240 = 42
      end
    end
    if p240 == 42 then
      c278v20 = _T.CachedInvasionInfo
      c278v19 = c278v20[c278v14]
      c278v19 = c278v19.mEventTag
      c278v20 = EMPTY_SYMBOL
      if c278v19 == c278v20 then
        p240 = 44
      else
        p240 = 43
      end
    end
    if p240 == 43 then
      c278v20 = _T.CachedInvasionInfo
      c278v19 = c278v20[c278v14]
      c278v6 = c278v19.mAttackerMissionInfo
      p240 = 52
    end
    if p240 == 44 then
      c278v19 = vT[130]
      c278v20 = _T.CachedActiveMissions
      c278v19 = c278v19(c278v20, c278v14)
      if not c278v19 then
        p240 = 48
      else
        p240 = 45
      end
    end
    if p240 == 45 then
      if c278v4 == nil then
        p240 = 47
      else
        p240 = 46
      end
    end
    if p240 == 46 then
      c278v20 = _T.CachedActiveMissions
      c278v19 = c278v20[c278v14]
      c278v19 = c278v19.mHard
      if c278v19 ~= c278v4 then
        p240 = 48
      else
        p240 = 47
      end
    end
    if p240 == 47 then
      c278v19 = _T.CachedActiveMissions
      c278v11 = c278v19[c278v14]
      c278v6 = c278v11.mMissionInfo
      p240 = 52
    end
    if p240 == 48 then
      c278v19 = vT[130]
      c278v20 = _T.CachedEliteAlertMissions
      c278v19 = c278v19(c278v20, c278v14)
      if not c278v19 then
        p240 = 52
      else
        p240 = 49
      end
    end
    if p240 == 49 then
      c278v20 = _T.CachedEliteAlertMissions
      c278v19 = c278v20[c278v14]
      c278v19 = c278v19.mUnlocked
      if not c278v19 then
        p240 = 52
      else
        p240 = 50
      end
    end
    if p240 == 50 then
      c278v20 = _T.CachedEliteAlertMissions
      c278v19 = c278v20[c278v14]
      c278v19 = c278v19.mShowInStarChart
      if not c278v19 then
        p240 = 52
      else
        p240 = 51
      end
    end
    if p240 == 51 then
      c278v19 = _T.CachedEliteAlertMissions
      c278v13 = c278v19[c278v14]
      c278v6 = c278v13.mMissionInfo
      p240 = 52
    end
    if p240 == 52 then
      c278v19 = vT[126]
      c278v19, c278v20 = c278v19(c278v6)
      c278v24 = "/Lotus/Language/Missions/MissionName_"
      c278v23 = c278v24 .. c278v19
      c278v24 = false
      c278v21 = c278v5:GetLocalized(c278v23, c278v24)
      if not c278v20 then
        p240 = 54
      else
        p240 = 53
      end
    end
    if p240 == 53 then
      c278v23 = " "
      c278v27 = "/Lotus/Language/Missions/MissionName_"
      c278v26 = c278v27 .. c278v20
      c278v27 = false
      c278v24 = c278v5:GetLocalized(c278v26, c278v27)
      c278v21 = c278v21 .. c278v23 .. c278v24
      p240 = 54
    end
    if p240 == 54 then
      c278v22 = nil
      if c278v15 then
        p240 = 57
      else
        p240 = 55
      end
    end
    if p240 == 55 then
      c278v23 = IsNull
      c278v23 = c278v23(c278v7)
      if not c278v23 then
        p240 = 57
      else
        p240 = 56
      end
    end
    if p240 == 56 then
      c278v23 = vT[123]
      c278v24 = c278v0.name
      c278v22 = c278v23(c278v24)
      p240 = 57
    end
    if p240 == 57 then
      c278v23 = c278v6.icon
      c278v24 = ""
      c278v25 = c278v6.descText
      c278v25 = c278v25:c_str()
      c278v26 = c278v6.difficulty
      c278v27 = c278v6.minEnemyLevel
      c278v28 = c278v6.maxEnemyLevel
      c278v29 = c278v6.uniqueName
      c278v30 = c278v6.rarity
      c278v31 = c278v6.tag
      c278v32 = nil
      c278v34 = c278v0.nodeType
      c278v35 = 3
      if c278v34 == c278v35 then
        p240 = 59
      else
        p240 = 58
      end
    end
    if p240 == 58 then
      c278v33 = false
      p240 = 60
    end
    if p240 == 59 then
      c278v33 = true
      p240 = 60
    end
    if p240 == 60 then
      c278v35 = string.find
      c278v37 = c278v0.name
      c278v36 = tostring
      c278v36 = c278v36(c278v37)
      c278v37 = "Dojo"
      c278v35 = c278v35(c278v36, c278v37)
      if c278v35 ~= nil then
        p240 = 62
      else
        p240 = 61
      end
    end
    if p240 == 61 then
      c278v34 = false
      p240 = 63
    end
    if p240 == 62 then
      c278v34 = true
      p240 = 63
    end
    if p240 == 63 then
      if not c278v15 then
        p240 = 65
      else
        p240 = 64
      end
    end
    if p240 == 64 then
      c278v35 = string.upper
      c278v36 = c278v6:GetFactionTag()
      c278v24 = c278v35(c278v36:c_str())
      p240 = 126
    end
    if p240 == 65 then
      if not c278v33 then
        p240 = 67
      else
        p240 = 66
      end
    end
    if p240 == 66 then
      c278v37 = "/Lotus/Language/Menu/Chat_HubTitle"
      c278v38 = false
      c278v21 = c278v5:GetLocalized(c278v37, c278v38)
      c278v37 = "/Lotus/Language/Bosses/Tenno"
      c278v38 = false
      c278v24 = c278v5:GetLocalized(c278v37, c278v38)
      c278v35 = _G
      c278v23 = c278v35.UITexture_Hub
      c278v35 = string.upper
      c278v21 = c278v35(c278v21)
      c278v35 = string.upper
      c278v24 = c278v35(c278v24)
      p240 = 126
    end
    if p240 == 67 then
      if not c278v34 then
        p240 = 69
      else
        p240 = 68
      end
    end
    if p240 == 68 then
      c278v35 = gGameData
      c278v38 = "/Lotus/Language/Clan/Clan_DOJO"
      c278v39 = false
      c278v21 = c278v5:GetLocalized(c278v38, c278v39)
      c278v24 = c278v35:GetGuildName()
      c278v36 = _G
      c278v23 = c278v36.UITexture_DefaultClan
      c278v36 = string.upper
      c278v21 = c278v36(c278v21)
      c278v36 = string.upper
      c278v24 = c278v36(c278v24)
      p240 = 126
    end
    if p240 == 69 then
      c278v35 = c278v0.nodeType
      c278v36 = 2
      if c278v35 ~= c278v36 then
        p240 = 71
      else
        p240 = 70
      end
    end
    if p240 == 70 then
      c278v37 = "/Lotus/Language/Menu/MissionIntro_PVP"
      c278v38 = false
      c278v21 = c278v5:GetLocalized(c278v37, c278v38)
      c278v37 = "/Lotus/Language/Menu/Codex_Tenno"
      c278v38 = false
      c278v24 = c278v5:GetLocalized(c278v37, c278v38)
      c278v35 = _G
      c278v23 = c278v35.UITexture_Pvp
      c278v35 = string.upper
      c278v24 = c278v35(c278v24)
      p240 = 126
    end
    if p240 == 71 then
      if c278v22 == nil then
        p240 = 81
      else
        p240 = 72
      end
    end
    if p240 == 72 then
      c278v35 = c278v22.mFaction
      c278v36 = 2
      if c278v35 ~= c278v36 then
        p240 = 74
      else
        p240 = 73
      end
    end
    if p240 == 73 then
      c278v35 = vT[126]
      c278v36 = c278v22.mDefenderMissionInfo
      c278v19 = c278v35(c278v36)
      c278v38 = "/Lotus/Language/Missions/MissionName_"
      c278v37 = c278v38 .. c278v19
      c278v38 = false
      c278v21 = c278v5:GetLocalized(c278v37, c278v38)
      p240 = 76
    end
    if p240 == 74 then
      c278v35 = c278v22.mEventTag
      c278v36 = EMPTY_SYMBOL
      if c278v35 ~= c278v36 then
        p240 = 76
      else
        p240 = 75
      end
    end
    if p240 == 75 then
      c278v37 = "/Lotus/Language/Menu/MissionIntro_Invasion"
      c278v38 = false
      c278v21 = c278v5:GetLocalized(c278v37, c278v38)
      p240 = 76
    end
    if p240 == 76 then
      c278v35 = c278v22.mDefenderMissionInfo
      c278v35 = c278v35:GetFactionTag()
      c278v24 = c278v35:c_str()
      c278v35 = _G
      c278v23 = c278v35.UITexture_Invasion
      c278v35 = string.upper
      c278v24 = c278v35(c278v24)
      c278v29 = ""
      c278v35 = c278v22.mAttackerMissionInfo
      c278v27 = c278v35.minEnemyLevel
      c278v35 = c278v22.mAttackerMissionInfo
      c278v28 = c278v35.maxEnemyLevel
      c278v35 = IsNull
      c278v35 = c278v35(c278v2)
      if c278v35 then
        p240 = 126
      else
        p240 = 77
      end
    end
    if p240 == 77 then
      c278v36 = c278v22.mDefenderMissionInfo
      c278v36 = c278v36.vipAgent
      c278v35 = IsNull
      c278v35 = c278v35(c278v36)
      if c278v35 then
        p240 = 126
      else
        p240 = 78
      end
    end
    if p240 == 78 then
      c278v35 = c278v22.mEventTag
      c278v36 = EMPTY_SYMBOL
      if c278v35 ~= c278v36 then
        p240 = 126
      else
        p240 = 79
      end
    end
    if p240 == 79 then
      c278v37 = c278v22.mDefenderMissionInfo
      c278v37 = c278v37.vipAgent
      c278v32 = c278v2:Name__a3e5c04f(c278v37)
      c278v35 = c278v32.locName
      c278v36 = EMPTY_SYMBOL
      if c278v35 == c278v36 then
        p240 = 126
      else
        p240 = 80
      end
    end
    if p240 == 80 then
      c278v37 = c278v32.locName
      c278v37 = c278v37:c_str()
      c278v38 = false
      c278v24 = c278v5:GetLocalized(c278v37, c278v38)
      c278v23 = c278v32.icon
      c278v29 = ""
      p240 = 126
    end
    if p240 == 81 then
      if c278v8 == nil then
        p240 = 103
      else
        p240 = 82
      end
    end
    if p240 == 82 then
      c278v36 = c278v8.mMissionKeyName
      c278v35 = IsNull
      c278v35 = c278v35(c278v36)
      if c278v35 then
        p240 = 97
      else
        p240 = 83
      end
    end
    if p240 == 83 then
      c278v35 = Resource
      c278v36 = c278v8.mMissionKeyName
      c278v35 = c278v35(c278v36)
      c278v36 = IsNull
      c278v36 = c278v36(c278v35)
      if c278v36 then
        p240 = 98
      else
        p240 = 84
      end
    end
    if p240 == 84 then
      c278v6 = c278v35:GetMission()
      c278v36 = c278v8.mMissionInfo
      c278v36 = c278v36.minEnemyLevel
      c278v37 = 1
      if c278v36 <= c278v37 then
        p240 = 86
      else
        p240 = 85
      end
    end
    if p240 == 85 then
      c278v36 = c278v8.mMissionInfo
      c278v36 = c278v36.minEnemyLevel
      c278v6.minEnemyLevel = c278v36
      p240 = 86
    end
    if p240 == 86 then
      c278v36 = c278v8.mMissionInfo
      c278v36 = c278v36.maxEnemyLevel
      c278v37 = 1
      if c278v36 <= c278v37 then
        p240 = 88
      else
        p240 = 87
      end
    end
    if p240 == 87 then
      c278v36 = c278v8.mMissionInfo
      c278v36 = c278v36.maxEnemyLevel
      c278v6.maxEnemyLevel = c278v36
      p240 = 88
    end
    if p240 == 88 then
      c278v37 = c278v8.mMissionInfo
      c278v37 = c278v37.enemySpec
      c278v36 = IsNull
      c278v36 = c278v36(c278v37)
      if c278v36 then
        p240 = 90
      else
        p240 = 89
      end
    end
    if p240 == 89 then
      c278v36 = c278v8.mMissionInfo
      c278v36 = c278v36.enemySpec
      c278v6.enemySpec = c278v36
      p240 = 90
    end
    if p240 == 90 then
      c278v36 = 0
      c278v37 = c278v8.mTag
      c278v38 = JADE_SHADOWS_GOAL_TAG
      if c278v37 ~= c278v38 then
        p240 = 92
      else
        p240 = 91
      end
    end
    if p240 == 91 then
      c278v37 = vT[17]
      c278v37 = c278v37.Ternary
      c278v39 = HARD_MODE_JADE_SHADOWS_EVENT_LEVEL_MODIFIER
      c278v40 = 0
      c278v36 = c278v37(c278v4, c278v39, c278v40)
      p240 = 96
    end
    if p240 == 92 then
      c278v37 = c278v8.mTag
      c278v38 = DUVIRI_MURMUR_EVENT_GOAL_TAG
      if c278v37 ~= c278v38 then
        p240 = 94
      else
        p240 = 93
      end
    end
    if p240 == 93 then
      c278v37 = vT[17]
      c278v37 = c278v37.Ternary
      c278v39 = HARD_MODE_MURMUR_INVASION_EVENT_LEVEL_MODIFIER
      c278v40 = 0
      c278v36 = c278v37(c278v4, c278v39, c278v40)
      p240 = 96
    end
    if p240 == 94 then
      c278v37 = c278v8.mTag
      c278v38 = SHADOWGRAPHER_EVENT_GOAL_TAG
      if c278v37 ~= c278v38 then
        p240 = 96
      else
        p240 = 95
      end
    end
    if p240 == 95 then
      c278v37 = vT[17]
      c278v37 = c278v37.Ternary
      c278v39 = HARD_MODE_SHADOWGRAPHER_EVENT_LEVEL_MODIFIER
      c278v40 = 0
      c278v36 = c278v37(c278v4, c278v39, c278v40)
      p240 = 96
    end
    if p240 == 96 then
      c278v37 = c278v6.minEnemyLevel
      c278v27 = c278v37 + c278v36
      c278v37 = c278v6.maxEnemyLevel
      c278v28 = c278v37 + c278v36
      c278v37 = c278v6:GetFactionTag()
      c278v24 = c278v37:c_str()
      c278v37 = vT[126]
      c278v19 = c278v37(c278v6)
      c278v40 = "/Lotus/Language/Missions/MissionName_"
      c278v39 = c278v40 .. c278v19
      c278v40 = false
      c278v21 = c278v5:GetLocalized(c278v39, c278v40)
      c278v29 = ""
      p240 = 98
    end
    if p240 == 97 then
      c278v37 = c278v8.mDesc
      c278v38 = false
      c278v21 = c278v5:GetLocalized(c278v37, c278v38)
      p240 = 98
    end
    if p240 == 98 then
      c278v36 = c278v6.enemySpec
      c278v35 = IsNull
      c278v35 = c278v35(c278v36)
      if c278v35 then
        p240 = 101
      else
        p240 = 99
      end
    end
    if p240 == 99 then
      c278v36 = c278v6.enemySpec
      c278v35 = tostring
      c278v35 = c278v35(c278v36:GetFullName())
      if c278v35 ~= "/Lotus/Types/Game/EnemySpecs/GrineerEventSquadM" then
        p240 = 101
      else
        p240 = 100
      end
    end
    if p240 == 100 then
      c278v24 = ""
      p240 = 102
    end
    if p240 == 101 then
      c278v35 = c278v6:GetFactionTag()
      c278v24 = c278v35:c_str()
      p240 = 102
    end
    if p240 == 102 then
      c278v35 = string.upper
      c278v24 = c278v35(c278v24)
      p240 = 126
    end
    if p240 == 103 then
      c278v35 = c278v6.missionType
      c278v36 = 0
      if c278v35 ~= c278v36 then
        p240 = 114
      else
        p240 = 104
      end
    end
    if p240 == 104 then
      c278v35 = false
      c278v36 = IsNull
      c278v36 = c278v36(c278v2)
      if c278v36 then
        p240 = 108
      else
        p240 = 105
      end
    end
    if p240 == 105 then
      c278v37 = c278v6.vipAgent
      c278v36 = IsNull
      c278v36 = c278v36(c278v37)
      if c278v36 then
        p240 = 108
      else
        p240 = 106
      end
    end
    if p240 == 106 then
      c278v38 = c278v6.vipAgent
      c278v32 = c278v2:Name__a3e5c04f(c278v38)
      c278v36 = c278v32.locName
      c278v37 = EMPTY_SYMBOL
      if c278v36 == c278v37 then
        p240 = 108
      else
        p240 = 107
      end
    end
    if p240 == 107 then
      c278v35 = true
      c278v38 = c278v32.locName
      c278v38 = c278v38:c_str()
      c278v39 = false
      c278v24 = c278v5:GetLocalized(c278v38, c278v39)
      c278v23 = c278v32.icon
      c278v29 = ""
      p240 = 108
    end
    if p240 == 108 then
      if c278v35 then
        p240 = 112
      else
        p240 = 109
      end
    end
    if p240 == 109 then
      c278v36 = c278v6.uniqueName
      if c278v36 == "" then
        p240 = 111
      else
        p240 = 110
      end
    end
    if p240 == 110 then
      c278v38 = c278v6.uniqueName
      c278v39 = false
      c278v24 = c278v5:GetLocalized(c278v38, c278v39)
      c278v35 = true
      p240 = 111
    end
    if p240 == 111 then
      c278v23 = c278v6.icon
      p240 = 112
    end
    if p240 == 112 then
      if c278v35 then
        p240 = 126
      else
        p240 = 113
      end
    end
    if p240 == 113 then
      c278v36 = c278v6:GetFactionTag()
      c278v24 = c278v36:c_str()
      p240 = 126
    end
    if p240 == 114 then
      c278v35 = c278v0.name
      c278v36 = APARTMENT_NODE_TAG
      if c278v35 ~= c278v36 then
        p240 = 116
      else
        p240 = 115
      end
    end
    if p240 == 115 then
      c278v21 = ""
      c278v24 = ""
      p240 = 126
    end
    if p240 == 116 then
      c278v36 = c278v0.name
      c278v35 = tostring
      c278v35 = c278v35(c278v36)
      c278v37 = _T.CachedAlerts
      c278v36 = IsNull
      c278v36 = c278v36(c278v37)
      if c278v36 then
        p240 = 121
      else
        p240 = 117
      end
    end
    if p240 == 117 then
      c278v37 = _T.CachedAlerts
      c278v36 = c278v37[c278v35]
      if not c278v36 then
        p240 = 121
      else
        p240 = 118
      end
    end
    if p240 == 118 then
      c278v37 = _T.CachedAlerts
      c278v36 = c278v37[c278v35]
      c278v36 = c278v36.mAlertInfo
      c278v36 = c278v36.mTag
      c278v37 = EMPTY_SYMBOL
      if c278v36 == c278v37 then
        p240 = 121
      else
        p240 = 119
      end
    end
    if p240 == 119 then
      c278v37 = _T.CachedAlerts
      c278v36 = c278v37[c278v35]
      c278v36 = c278v36.mAlertInfo
      c278v36 = c278v36.mMissionInfo
      c278v36 = c278v36.descText
      c278v37 = EMPTY_SYMBOL
      if c278v36 == c278v37 then
        p240 = 121
      else
        p240 = 120
      end
    end
    if p240 == 120 then
      c278v36 = Localize
      c278v39 = _T.CachedAlerts
      c278v38 = c278v39[c278v35]
      c278v38 = c278v38.mAlertInfo
      c278v38 = c278v38.mMissionInfo
      c278v38 = c278v38.descText
      c278v37 = tostring
      c278v37 = c278v37(c278v38)
      c278v38 = false
      c278v29 = c278v36(c278v37, c278v38)
      p240 = 121
    end
    if p240 == 121 then
      c278v36 = c278v6:GetFactionTag()
      c278v24 = c278v36:c_str()
      if not c278v17 then
        p240 = 123
      else
        p240 = 122
      end
    end
    if p240 == 122 then
      c278v24 = "TENNO"
      p240 = 123
    end
    if p240 == 123 then
      c278v36 = IsNull
      c278v36 = c278v36(c278v23)
      if not c278v36 then
        p240 = 125
      else
        p240 = 124
      end
    end
    if p240 == 124 then
      c278v23 = nil
      p240 = 125
    end
    if p240 == 125 then
      c278v36 = string.upper
      c278v24 = c278v36(c278v24)
      p240 = 126
    end
    if p240 == 126 then
      c278v35 = string.len
      c278v35 = c278v35(c278v29)
      c278v36 = 0
      if c278v35 <= c278v36 then
        p240 = 127
      else
        p240 = 127
      end
    end
    if p240 == 127 then
      c278v35 = vT[17]
      c278v35 = c278v35.Ternary
      c278v36 = Engine.STACKSFollies
      c278v36 = c278v36()
      c278v37 = ""
      c278v38 = c278v0.founders
      c278v35 = c278v35(c278v36, c278v37, c278v38)
      c278v36 = nil
      c278v38 = c278v6.levelOverride
      c278v37 = IsNull
      c278v37 = c278v37(c278v38)
      if c278v37 then
        p240 = 129
      else
        p240 = 128
      end
    end
    if p240 == 128 then
      c278v37 = GetSeed
      c278v37 = c278v37()
      c278v38 = SetSeed
      c278v39 = c278v6.seed
      c278v38(c278v39)
      c278v38 = vT[128]
      c278v36 = c278v38(c278v6, c278v0, c278v32, c278v8)
      c278v38 = SetSeed
      c278v38(c278v37)
      p240 = 129
    end
    if p240 == 129 then
      c278v37 = string.upper
      c278v37 = c278v37(c278v24)
      c278v38 = FactionMap
      c278v24 = c278v38[c278v37]
      if c278v24 == nil then
        p240 = 131
      else
        p240 = 130
      end
    end
    if p240 == 130 then
      c278v38 = FactionNames
      c278v24 = c278v38[c278v24]
      p240 = 131
    end
    if p240 == 131 then
      if c278v24 == nil then
        p240 = 133
      else
        p240 = 132
      end
    end
    if p240 == 132 then
      c278v38 = Localize
      c278v40 = nil
      c278v24 = c278v38(c278v24, c278v40)
      p240 = 134
    end
    if p240 == 133 then
      c278v24 = c278v37
      c278v37 = nil
      p240 = 134
    end
    if p240 == 134 then
      if c278v16 == nil then
        p240 = 142
      else
        p240 = 135
      end
    end
    if p240 == 135 then
      c278v38 = c278v16.name
      c278v39 = CETUS_NODE_TAG
      if c278v38 ~= c278v39 then
        p240 = 137
      else
        p240 = 136
      end
    end
    if p240 == 136 then
      c278v37 = "ostron"
      p240 = 142
    end
    if p240 == 137 then
      c278v38 = c278v16.name
      c278v39 = FORTUNA_NODE_TAG
      if c278v38 ~= c278v39 then
        p240 = 139
      else
        p240 = 138
      end
    end
    if p240 == 138 then
      c278v37 = "solaris"
      p240 = 142
    end
    if p240 == 139 then
      c278v38 = c278v16.name
      c278v39 = IRON_WAKE_NODE_TAG
      if c278v38 == c278v39 then
        p240 = 141
      else
        p240 = 140
      end
    end
    if p240 == 140 then
      c278v38 = c278v16.name
      c278v39 = APARTMENT_NODE_TAG
      if c278v38 ~= c278v39 then
        p240 = 142
      else
        p240 = 141
      end
    end
    if p240 == 141 then
      c278v37 = "tenno"
      p240 = 142
    end
    if p240 == 142 then
      if (not (c278v33) and not c278v34) then
        p240 = 145
      else
        p240 = 144
      end
    end
    if p240 == 144 then
      c278v37 = "tenno"
      p240 = 145
    end
    if p240 == 145 then
      c278v38 = IsNull
      c278v38 = c278v38(c278v37)
      if not c278v38 then
        p240 = 148
      else
        p240 = 146
      end
    end
    if p240 == 146 then
      c278v38 = c278v6.missionType
      c278v39 = 45
      if c278v38 ~= c278v39 then
        p240 = 148
      else
        p240 = 147
      end
    end
    if p240 == 147 then
      c278v37 = "shadowgrapher"
      p240 = 148
    end
    if p240 == 148 then
      c278v38 = vT[129]
      c278v38 = c278v38(c278v6)
      if not c278v38 then
        p240 = 150
      else
        p240 = 149
      end
    end
    if p240 == 149 then
      c278v24 = c278v38
      p240 = 150
    end
    if p240 == 150 then
      c278v39 = c278v6.missionType
      c278v40 = 32
      if c278v39 ~= c278v40 then
        p240 = 152
      else
        p240 = 151
      end
    end
    if p240 == 151 then
      c278v47 = "<RAILJACK>"
      c278v48 = true
      c278v39 = c278v5:GetLocalized(c278v47, c278v48)
      c278v40 = " "
      c278v42 = " ("
      c278v47 = "/Lotus/Language/Menu/RailjackTitle"
      c278v48 = false
      c278v43 = c278v5:GetLocalized(c278v47, c278v48)
      c278v44 = ")"
      c278v21 = c278v39 .. c278v40 .. c278v21 .. c278v42 .. c278v43 .. c278v44
      p240 = 156
    end
    if p240 == 152 then
      c278v39 = c278v6.isSharkwingMission
      if c278v39 then
        p240 = 155
      else
        p240 = 153
      end
    end
    if p240 == 153 then
      c278v39 = c278v6.archwingRequired
      if not c278v39 then
        p240 = 156
      else
        p240 = 154
      end
    end
    if p240 == 154 then
      c278v47 = "<ARCHWING>"
      c278v48 = true
      c278v39 = c278v5:GetLocalized(c278v47, c278v48)
      c278v40 = " "
      c278v42 = " ("
      c278v47 = "/Lotus/Language/Menu/Loadout_Archwing"
      c278v48 = false
      c278v43 = c278v5:GetLocalized(c278v47, c278v48)
      c278v44 = ")"
      c278v21 = c278v39 .. c278v40 .. c278v21 .. c278v42 .. c278v43 .. c278v44
      p240 = 156
    end
    if p240 == 155 then
      c278v47 = "<ARCHWING>"
      c278v48 = true
      c278v39 = c278v5:GetLocalized(c278v47, c278v48)
      c278v40 = " "
      c278v42 = " ("
      c278v47 = "/Lotus/Language/Menu/Sharkwing"
      c278v48 = false
      c278v43 = c278v5:GetLocalized(c278v47, c278v48)
      c278v44 = ")"
      c278v21 = c278v39 .. c278v40 .. c278v21 .. c278v42 .. c278v43 .. c278v44
      p240 = 156
    end
    if p240 == 156 then
      c278v39 = { mMission = nil, mFounders = nil, mTexture = nil, mLocationTexture = nil, mAlertInfo = nil, mSyndicateInfo = nil, mInvasionInfo = nil, mGoalInfo = nil, mSortieInfo = nil, mActiveMissionInfo = nil, mGhostTowerMissionInfo = nil, mEliteAlertMissionInfo = nil, mCardTag = nil, mName = nil, mRarity = nil, mDesc = nil, mDescText = nil, mNameText = nil, mNumMissions = 1, mDifficulty = nil, mLevelMin = nil, mLevelMax = nil, mFactionTag = nil }
      c278v39.mMission = c278v6
      c278v39.mFounders = c278v35
      c278v39.mTexture = c278v23
      c278v39.mLocationTexture = c278v36
      c278v39.mAlertInfo = c278v7
      c278v39.mSyndicateInfo = c278v9
      c278v39.mInvasionInfo = c278v22
      c278v39.mGoalInfo = c278v8
      c278v39.mSortieInfo = c278v10
      c278v39.mActiveMissionInfo = c278v11
      c278v39.mGhostTowerMissionInfo = c278v12
      c278v39.mEliteAlertMissionInfo = c278v13
      c278v39.mCardTag = c278v31
      c278v39.mName = c278v21
      c278v39.mRarity = c278v30
      c278v39.mDesc = c278v24
      c278v39.mDescText = c278v25
      c278v39.mNameText = c278v29
      c278v39.mDifficulty = c278v26
      c278v39.mLevelMin = c278v27
      c278v39.mLevelMax = c278v28
      c278v39.mFactionTag = c278v37
      do return c278v39 end
    end
  end
  GetMissionInfo = vT[131]
  vT[131] = function(c279v0, c279v1)
    local c279v2, c279v3, c279v4, c279v5, c279v6
    c279v4 = _G
    c279v4 = c279v4.UIMovie_MeleeCombosMovie
    c279v2 = c279v0:PushChildMovie(c279v4)
    c279v3 = IsNull
    c279v3 = c279v3(c279v2)
    if not c279v3 then
      c279v3 = _T
      c279v3.StanceUpgradeInfo = c279v1
      c279v5 = "SetStanceUpgradeInfo"
      c279v6 = "StanceUpgradeInfo"
      c279v2:Execute(c279v5, c279v6)
      c279v3 = _T
      c279v4 = nil
      c279v3.StanceUpgradeInfo = c279v4
    end
    do return c279v2 end
  end
  ShowCombos = vT[131]
  vT[131] = function()
    local c280v0, c280v1, c280v2, c280v3, c280v4, c280v5, c280v6, c280v7, c280v8, c280v9, c280v10
    c280v1 = gRegion
    c280v0 = IsNull
    c280v0 = c280v0(c280v1)
    c280v0 = gRegion
    c280v0 = c280v0:GetLocalPlayerAvatar()
    c280v1 = IsNull
    c280v1 = c280v1(c280v0)
    c280v1 = c280v0:InventoryControl()
    c280v1 = c280v1:GetMeleeWeapon()
    c280v2 = IsNull
    c280v2 = c280v2(c280v1)
    c280v2 = c280v1:GetNumUpgrades()
    c280v5 = 1
    c280v3 = c280v2
    c280v4 = 1
    for c280v5 = c280v5, c280v3, c280v4 do
      c280v8 = c280v5 - 1
      c280v6 = c280v1:GetUpgrade(c280v8)
      c280v7 = IsNull
      c280v7 = c280v7(c280v6)
      if not c280v7 then
        c280v9 = gMeleeTreeType
        c280v7 = c280v6:IsA(c280v9)
        if c280v7 then break end
        if c280v7 then
          c280v7 = Lotus_Game.UpgradeInfo
          c280v7 = c280v7()
          c280v8 = c280v6:GetType()
          c280v7.mItemType = c280v8
          c280v8 = c280v6:GetFingerPrint()
          c280v7.mUpgradeFingerprint = c280v8
          do return c280v7 end
        end
      end
    end
    c280v1 = gGameRules
    c280v0 = IsNull
    c280v0 = c280v0(c280v1)
    c280v0 = gGameRules
    c280v2 = gLotusAttractModeGameRulesType
    c280v0 = c280v0:IsA(c280v2)
    c280v1 = gGameData
    c280v0 = IsNull
    c280v0 = c280v0(c280v1)
    c280v0 = gGameData
    c280v0 = c280v0:GetInventory()
    c280v1 = IsNull
    c280v1 = c280v1(c280v0)
    c280v3 = 0
    c280v6 = 0
    c280v1 = c280v0:GetPreset(c280v3, c280v0:Name__9adc88cf(c280v6))
    c280v2 = IsNull
    c280v2 = c280v2(c280v1)
    c280v4 = 3
    c280v2 = c280v1:GetEntry(c280v4)
    c280v2 = c280v2.mItemId
    c280v5 = 3
    c280v3 = c280v1:GetEntry(c280v5)
    c280v3 = c280v3.mModSlot
    c280v6 = c280v2.mId
    c280v4 = c280v0:GetAttachedUpgrades(c280v6, c280v3)
    c280v7 = 1
    c280v5 = #c280v4
    c280v6 = 1
    for c280v7 = c280v7, c280v5, c280v6 do
      c280v9 = c280v4[c280v7]
      c280v9 = c280v9.mItemType
      c280v8 = IsNull
      c280v8 = c280v8(c280v9)
      if not c280v8 then
        c280v8 = c280v4[c280v7]
        c280v8 = c280v8.mItemType
        c280v10 = gMeleeTreeType
        c280v8 = c280v8:IsA(c280v10)
        if c280v8 then break end
        if c280v8 then
          c280v8 = c280v4[c280v7]
          do return c280v8 end
        end
      end
    end
    if c280v0 then
    end
    if c280v0 then
      local p29 = 19
      if p29 == 19 then
        c280v4 = gGameRules
        c280v3 = IsNull
        c280v3 = c280v3(c280v4)
        if c280v3 then
        else
          p29 = 20
        end
      end
      if p29 == 20 then
        c280v3 = gGameRules
        c280v5 = gLotusPvpGameRulesType
        c280v3 = c280v3:IsA(c280v5)
        if not c280v3 then
          p29 = 22
        else
          p29 = 21
        end
      end
      if p29 == 21 then
        c280v3 = gGameRules
        c280v3 = c280v3:Name__31882b50()
        if c280v3 then
          p29 = 23
        else
          p29 = 22
        end
      end
      if p29 == 22 then
        c280v3 = gGameRules
        c280v5 = gLotusFightingGameRulesType
        c280v3 = c280v3:IsA(c280v5)
        if not c280v3 then
        else
          p29 = 23
        end
      end
      if p29 == 23 then
        c280v3 = Lotus_Game.UpgradeInfo
        c280v3 = c280v3()
        c280v4 = c280v1:GetMeleeTree()
        c280v4 = c280v4:GetType()
        c280v3.mItemType = c280v4
        do return c280v3 end
      end
    end
    c280v0 = nil
    do return c280v0 end
  end
  GetMeleeStanceUpgradeInfo = vT[131]
  vT[131] = function(c281v0, c281v1, c281v2)
    local c281v3, c281v4, c281v5, c281v6, c281v7, c281v8, c281v9, c281v10, c281v12
    c281v3 = IsNull
    c281v3 = c281v3(c281v0)
    if not c281v3 then
      c281v3 = 0
      c281v4 = {}
      if c281v1 then
        c281v7 = WeakResource
        c281v8 = "/Lotus/Types/LotusMeleeTree/LotusMeleeTree"
        c281v5 = table.insert
        c281v5(c281v4, c281v7(c281v8))
      end
      if c281v2 ~= nil then
        c281v7 = 1
        c281v5 = #c281v2
        c281v6 = 1
        for c281v7 = c281v7, c281v5, c281v6 do
          c281v10 = c281v2[c281v7]
          c281v8 = table.insert
          c281v8(c281v4, c281v10)
        end
      end
      c281v5 = IsNull
      c281v5 = c281v5(c281v0:GetUpgrade(c281v3))
      c281v5 = c281v0:GetUpgrade(c281v3)
      c281v8 = gLotusArtifactUpgradeType
      c281v6 = c281v5:IsA(c281v8)
      c281v9 = 1
      c281v7 = #c281v4
      c281v8 = 1
      for c281v9 = c281v9, c281v7, c281v8 do
        c281v12 = c281v4[c281v9]
        c281v10 = c281v5:IsA(c281v12)
        if c281v10 then break end
      end
      c281v6 = false
      if c281v6 then
        c281v10 = true
        c281v0:RemoveUpgrade(c281v5, c281v10)
      else
        c281v3 = c281v3 + 1
      end
    end
    do return end
  end
  RemoveModsFromWeapon = vT[131]
  vT[131] = function(c282v0, c282v1)
    local c282v2, c282v3, c282v4, c282v5
    if c282v0 == "Assassination" then
      c282v3 = _G
      c282v3 = c282v3.UITextures_GameModeTextures
      c282v2 = c282v3[1]
      do return c282v2 end
    end
    if c282v0 == "Capture" then
      c282v3 = _G
      c282v3 = c282v3.UITextures_GameModeTextures
      c282v2 = c282v3[2]
      do return c282v2 end
    end
    if c282v0 == "PVP" then
      c282v3 = _G
      c282v3 = c282v3.UITextures_GameModeTextures
      c282v2 = c282v3[3]
      do return c282v2 end
    end
    if c282v0 == "Deception" then
      c282v3 = _G
      c282v3 = c282v3.UITextures_GameModeTextures
      c282v2 = c282v3[4]
      do return c282v2 end
    end
    if c282v0 == "Defense" then
      c282v3 = _G
      c282v3 = c282v3.UITextures_GameModeTextures
      c282v2 = c282v3[6]
      do return c282v2 end
    end
    if not ((c282v0 ~= "Exterminate" or c282v1 == nil)) then
      c282v3 = _G
      c282v3 = c282v3.UITextures_GameModeTextures
      c282v5 = 7
      c282v4 = c282v5 + c282v1
      c282v2 = c282v3[c282v4]
      do return c282v2 end
    end
    if c282v0 == "Hijack" then
      c282v3 = _G
      c282v3 = c282v3.UITextures_GameModeTextures
      c282v2 = c282v3[10]
      do return c282v2 end
    end
    if c282v0 == "Territory" then
      c282v3 = _G
      c282v3 = c282v3.UITextures_GameModeTextures
      c282v2 = c282v3[11]
      do return c282v2 end
    end
    if c282v0 == "MobileDefense" then
      c282v3 = _G
      c282v3 = c282v3.UITextures_GameModeTextures
      c282v2 = c282v3[12]
      do return c282v2 end
    end
    if c282v0 == "Rescue" then
      c282v3 = _G
      c282v3 = c282v3.UITextures_GameModeTextures
      c282v2 = c282v3[13]
      do return c282v2 end
    end
    if c282v0 == "Sabotage" then
      c282v3 = _G
      c282v3 = c282v3.UITextures_GameModeTextures
      c282v2 = c282v3[14]
      do return c282v2 end
    end
    if c282v0 == "Spy" then
      c282v3 = _G
      c282v3 = c282v3.UITextures_GameModeTextures
      c282v2 = c282v3[15]
      do return c282v2 end
    end
    if c282v0 == "Survival" then
      c282v3 = _G
      c282v3 = c282v3.UITextures_GameModeTextures
      c282v2 = c282v3[16]
      do return c282v2 end
    end
    if c282v0 == "Void" then
      c282v3 = _G
      c282v3 = c282v3.UITextures_GameModeTextures
      c282v2 = c282v3[17]
      do return c282v2 end
    end
    c282v3 = _G
    c282v3 = c282v3.UITextures_GameModeTextures
    c282v2 = c282v3[5]
    do return c282v2 end
  end
  GetGameModeTexture = vT[131]
  vT[131] = function(c283v0, c283v1, c283v2)
    local c283v3, c283v4, c283v5, c283v6, c283v7, c283v9, c283v10, c283v11, c283v12, c283v13, c283v14, c283v15
    local p28 = 0
    if p28 == 0 then
      c283v3 = IsNull
      c283v3 = c283v3(c283v0)
      if c283v3 then
        p28 = 3
      else
        p28 = 1
      end
    end
    if p28 == 1 then
      c283v3 = IsNull
      c283v3 = c283v3(c283v1)
      if c283v3 then
        p28 = 3
      else
        p28 = 2
      end
    end
    if p28 == 2 then
      c283v3 = IsNull
      c283v3 = c283v3(c283v2)
      if not c283v3 then
        p28 = 4
      else
        p28 = 3
      end
    end
    if p28 == 3 then
      c283v3 = false
      do return c283v3 end
    end
    if p28 == 4 then
      c283v3 = c283v0:GetInventory()
      c283v4 = c283v3:GetQuestKeys()
      c283v5 = IsNull
      c283v5 = c283v5(c283v4)
      if not c283v5 then
        p28 = 6
      else
        p28 = 5
      end
    end
    if p28 == 5 then
      c283v5 = false
      do return c283v5 end
    end
    if p28 == 6 then
      c283v5 = ipairs
      c283v5, c283v6, c283v7 = c283v5(c283v4)
    end
    for c283v8, c283v9 in c283v5, c283v6, c283v7 do
      c283v5 = false
      do return c283v5 end
    end
    c283v10 = c283v9.mItemType
    if c283v10 == c283v1 then
      c283v10 = c283v9.mProgress
      c283v11 = #c283v10
      if c283v11 <= c283v2 then
        c283v11 = false
        do return c283v11 end
      end
      c283v11 = c283v2 + 1
      c283v12 = c283v10[c283v11]
      c283v14 = IsNull
      c283v14 = c283v14(c283v12)
      c283v13 = not c283v14
      if c283v13 then
        c283v15 = c283v12.mCompletion
        c283v14 = IsNull
        c283v14 = c283v14(c283v15)
        c283v13 = not c283v14
        if c283v13 then
          c283v14 = c283v12.mCompletion
          c283v15 = -1
          if c283v14 <= c283v15 then
            c283v13 = false
          else
            c283v13 = true
          end
        end
      end
      do return c283v13 end
    end
  end
  HasCompletedQuestStage = vT[131]
  vT[131] = function(c284v0, c284v1, c284v2, c284v3, c284v4)
    local c284v5, c284v6, c284v7, c284v8, c284v9, c284v10, c284v11, c284v12, c284v13, c284v14, c284v15, c284v16, c284v17, c284v18, c284v19, c284v20, c284v21, c284v22
    c284v16 = #c284v14
    c284v16 = ipairs
    c284v16, c284v17, c284v18 = c284v16(c284v14)
    for c284v19, c284v20 in c284v16, c284v17, c284v18 do
      c284v21 = c284v20.mCompletion
      c284v22 = -1
      c284v15 = c284v19
      c284v13 = c284v12.mItemType
      for c284v11, c284v12 in c284v8, c284v9, c284v10 do
        c284v8 = nil
        c284v9 = nil
        c284v10 = nil
        c284v11 = nil
        do return c284v8, c284v9, c284v10, c284v11 end
      end
      local p62 = 0
      if p62 == 0 then
        c284v5 = IsNull
        c284v5 = c284v5(c284v0)
        if c284v5 then
          p62 = 2
        else
          p62 = 1
        end
      end
      if p62 == 1 then
        c284v5 = IsNull
        c284v5 = c284v5(c284v1)
        if not c284v5 then
          p62 = 3
        else
          p62 = 2
        end
      end
      if p62 == 2 then
        c284v5 = nil
        c284v6 = nil
        c284v7 = nil
        c284v8 = nil
        do return c284v5, c284v6, c284v7, c284v8 end
      end
      if p62 == 3 then
        c284v5 = IsNull
        c284v5 = c284v5(c284v4)
        if not c284v5 then
          p62 = 5
        else
          p62 = 4
        end
      end
      if p62 == 4 then
        c284v4 = 0
        p62 = 5
      end
      if p62 == 5 then
        c284v5 = c284v0:GetInventory()
        c284v6 = c284v5:GetQuestKeys()
        c284v7 = IsNull
        c284v7 = c284v7(c284v6)
        if not c284v7 then
          p62 = 7
        else
          p62 = 6
        end
      end
      if p62 == 6 then
        c284v7 = nil
        c284v8 = nil
        c284v9 = nil
        c284v10 = nil
        do return c284v7, c284v8, c284v9, c284v10 end
      end
      if p62 == 7 then
        c284v7 = c284v1:Name__d935b028()
        c284v8 = ipairs
        c284v8, c284v9, c284v10 = c284v8(c284v6)
      end
      for c284v11, c284v12 in c284v8, c284v9, c284v10 do
      end
      c284v13 = -1
      c284v14 = c284v12.mProgress
      if c284v3 then
        c284v15 = print
        c284v17 = "_GetQuestInfo: progress - "
        c284v19 = #c284v14
        c284v18 = tostring
        c284v18 = c284v18(c284v19)
        c284v16 = c284v17 .. c284v18
        c284v15(c284v16)
      end
      c284v15 = #c284v14
      c284v16 = 0
      if c284v16 < c284v15 then
        c284v15 = c284v14[1]
        c284v13 = c284v15.mCompletion
        if c284v3 then
          c284v15 = print
          c284v17 = "_GetQuestInfo: stage 1 completion - "
          c284v18 = tostring
          c284v18 = c284v18(c284v13)
          c284v16 = c284v17 .. c284v18
          c284v15(c284v16)
        end
      end
      c284v15 = 0
      c284v16 = 0
    end
    if c284v7 <= c284v16 then
      c284v15 = c284v15 + 1
    end
    if c284v7 <= c284v16 then
      c284v18 = 1
      c284v20 = #c284v14
      c284v19 = math.min
      c284v16 = c284v19(c284v20, c284v7)
      c284v17 = 1
      for c284v18 = c284v18, c284v16, c284v17 do
        c284v19 = c284v14[c284v18]
        c284v19 = c284v19.mCompletion
        if c284v19 < c284v13 then break end
        if c284v19 < c284v13 then
          c284v15 = c284v18
        end
      end
    end
    if c284v3 then
      c284v16 = print
      c284v18 = "_GetQuestInfo: difficulty (A) - "
      c284v19 = tostring
      c284v19 = c284v19(c284v13)
      c284v17 = c284v18 .. c284v19
      c284v16(c284v17)
    end
    c284v16 = 0
    if c284v13 < c284v16 then
      c284v15 = 1
      c284v13 = 0
    else
      if c284v15 == 0 then
        c284v13 = c284v13 + 1
        c284v15 = 1
      end
    end
    if c284v3 then
      c284v16 = print
      c284v18 = "_GetQuestInfo: difficulty (B) - "
      c284v22 = tostring
      c284v19 = c284v22(c284v13)
      c284v20 = ", mission index="
      c284v21 = tostring
      c284v21 = c284v21(c284v15)
      c284v17 = c284v18 .. c284v19 .. c284v20 .. c284v21
      c284v16(c284v17)
    end
    c284v16 = nil
    if c284v2 then
      c284v17 = c284v15 + c284v4
      c284v20 = c284v17 - 1
      c284v18 = c284v1:Name__6e760ebb(c284v20)
      if c284v18 then
        c284v20 = c284v1:Name__f1b1e156()
        c284v19 = c284v20[c284v17]
        c284v18 = IsNull
        c284v18 = c284v18(c284v19)
        if not c284v18 then
          c284v19 = c284v1:Name__f1b1e156()
          c284v18 = c284v19[c284v17]
          c284v18 = c284v18.mMainMission
          c284v16 = c284v18.mKey
        end
      end
    end
    c284v19 = c284v12.mCanProgressQuest
    do return c284v15, c284v13, c284v19, c284v16 end
  end
  vT[132] = function(c285v0, c285v1, c285v2, c285v3, c285v4)
    local c285v5
    c285v5 = vT[131]
    do return c285v5(c285v0, c285v1, c285v2, c285v3, c285v4) end
  end
  GetQuestInfo = vT[132]
  vT[27] = function(c286v0)
    local c286v1, c286v2, c286v3, c286v4, c286v5, c286v6
    c286v1 = IsNull
    c286v1 = c286v1(c286v0)
    if c286v1 then
      c286v1 = nil
      c286v2 = nil
      c286v3 = nil
      c286v4 = nil
      do return c286v1, c286v2, c286v3, c286v4 end
    end
    c286v1 = c286v0:GetInventory()
    c286v2 = _T.ActiveQuestLoaded
    if not c286v2 then
      c286v2 = nil
      c286v3 = nil
      c286v4 = nil
      c286v5 = nil
      do return c286v2, c286v3, c286v4, c286v5 end
    end
    c286v2 = Resource
    c286v2 = c286v2(c286v1:GetActiveQuest())
    c286v3 = IsNull
    c286v3 = c286v3(c286v2)
    if c286v3 then
      c286v3 = nil
      c286v4 = nil
      c286v5 = nil
      c286v6 = nil
      do return c286v3, c286v4, c286v5, c286v6 end
    end
    c286v4 = vT[131]
    do return c286v2, c286v4(c286v0, c286v2) end
  end
  vT[132] = function(c287v0)
    local c287v1
    c287v1 = vT[27]
    do return c287v1(c287v0) end
  end
  GetActiveQuest = vT[132]
  vT[132] = function(c288v0)
    local c288v1, c288v2
    c288v1 = c288v0
    if not c288v1 then
      c288v1 = gGameData
    end
    c288v0 = c288v1
    c288v2 = IsNull
    c288v2 = c288v2(c288v0)
    c288v1 = not c288v2
    if c288v1 then
      c288v1 = c288v0:InQuestCommitment()
    end
    do return c288v1 end
  end
  InQuestCommitment = vT[132]
  vT[132] = function(c291v0, c291v1, c291v2)
    local c291v3, c291v4, c291v5, c291v6, c291v7, c291v8, c291v9, c291v10, c291v11, c291v12, c291v13, c291v14, c291v15, c291v16, c291v17, c291v18
    c291v5 = c291v3:GetWorldState()
    c291v6 = c291v5.mGoals
    c291v7 = function(c289v0)
      local c289v1, c289v2, c289v3, c289v4, c289v5, c289v6, c289v7, c289v8, c289v9
      c289v4 = gKeyItemType
      c289v2 = c289v1:IsA(c289v4)
      c289v2 = vT[17]
      c289v2 = c289v2.IsUGCRestricted
      c289v2 = c289v2()
      c289v3 = _G
      c289v3 = c289v3.UITypes_UGCKeys
      c289v2 = IsNull
      c289v2 = c289v2(c289v3)
      c289v4 = 1
      c289v5 = _G
      c289v5 = c289v5.UITypes_UGCKeys
      c289v2 = #c289v5
      c289v3 = 1
      for c289v4 = c289v4, c289v2, c289v3 do
        c289v7 = _G
        c289v7 = c289v7.UITypes_UGCKeys
        c289v6 = c289v7[c289v4]
        c289v5 = IsNull
        c289v5 = c289v5(c289v6)
        if not c289v5 then
          c289v5 = c289v0.mItemType
          c289v8 = _G
          c289v8 = c289v8.UITypes_UGCKeys
          c289v7 = c289v8[c289v4]
          c289v5 = c289v5:IsA(c289v7)
          if c289v5 then break end
          if c289v5 then
            c289v5 = nil
            do return c289v5 end
          end
        end
      end
      c289v1 = c289v0.mItemCount
      c289v2 = 0
      if c289v1 <= c289v2 then
        c289v1 = nil
        do return c289v1 end
      end
      c289v1 = c289v0.mItemType
      c289v2 = IsNull
      c289v2 = c289v2(c289v1)
      if not c289v2 then
        c289v2 = nil
        do return c289v2 end
      end
      c289v2 = Resource
      c289v2 = c289v2(c289v1)
      c289v3 = IsNull
      c289v3 = c289v3(c289v2)
      if c289v3 then
        c289v3 = nil
        do return c289v3 end
      end
      c289v3 = c289v2:IsGoalKey()
      if c289v2 then
        c289v3 = true
        c289v6 = 1
        c289v7 = c291v6
        c289v4 = #c289v7
        c289v5 = 1
        for c289v6 = c289v6, c289v4, c289v5 do
          c289v7 = c291v3
          c289v9 = c289v6 - 1
          c289v7 = c289v7:IsGoalVisible(c289v9)
          c289v8 = c291v6
          c289v7 = c289v8[c289v6]
          c289v8 = c289v7.mKeyRequired
          c289v8 = c289v7.mSuccess
          if c289v8 == 0 then break end
          if not c289v7 then
            c289v3 = false
          end
        end
        if c289v3 then
          c289v4 = nil
          do return c289v4 end
        end
      end
      c289v3 = c291v1
      if c289v3 ~= nil then
        c289v3 = c289v2:GetRegionIdx()
        c289v4 = c291v1
        if c289v3 ~= c289v4 then
          c289v3 = nil
          do return c289v3 end
        end
      end
      do return c289v2 end
    end
    c291v10 = 1
    c291v8 = #c291v4
    c291v9 = 1
    for c291v10 = c291v10, c291v8, c291v9 do
      c291v11 = c291v4[c291v10]
      c291v12 = c291v7(c291v11)
      c291v13 = IsNull
      c291v13 = c291v13(c291v12)
      if not c291v13 then
        c291v13 = { Key = nil, Type = nil, Name = nil, Description = nil, ToolTip = nil }
        c291v13.Key = c291v11
        c291v13.Type = c291v12
        c291v14 = Localize
        c291v15 = tostring
        c291v15 = c291v15(c291v12:GetLocalizeTag())
        c291v16 = false
        c291v14 = c291v14(c291v15, c291v16)
        c291v13.Name = c291v14
        c291v14 = Localize
        c291v15 = tostring
        c291v15 = c291v15(c291v12:GetLocalizeDescTag())
        c291v16 = false
        c291v14 = c291v14(c291v15, c291v16)
        c291v13.Description = c291v14
        c291v14 = vT[49]
        c291v15 = nil
        c291v17 = nil
        c291v18 = nil
        c291v14 = c291v14(c291v15, c291v12, c291v17, c291v18)
        c291v13.ToolTip = c291v14
        c291v14 = IsNull
        c291v14 = c291v14(c291v2)
        if not c291v14 then
          c291v16 = c291v11.mItemType
          c291v14 = c291v2:Name__1dc35bd2(c291v16)
          c291v15 = IsNull
          c291v15 = c291v15(c291v14)
          if not c291v15 then
            c291v13.StoreItem = c291v14
            c291v15 = c291v14:GetIconTexture()
            c291v13.Icon = c291v15
          end
        end
        c291v14 = c291v12:ConsumeOnUse()
        if c291v14 then
          c291v14 = c291v11.mItemCount
          c291v13.Count = c291v14
        end
        c291v14 = table.insert
        c291v14(c291v0, c291v13)
      end
    end
    c291v3 = gGameData
    c291v4 = IsNull
    c291v4 = c291v4(c291v3)
    if c291v4 then
      do return c291v0 end
    end
    c291v4 = c291v3:GetInventory()
    c291v4 = c291v4:GetLevelKeys()
    c291v5 = IsNull
    c291v5 = c291v5(c291v4)
    c291v8 = table.sort
    c291v10 = function(c290v0, c290v1)
      local c290v2, c290v3, c290v4
      c290v3 = c290v1.Name
      c290v4 = c290v0.Name
      if c290v3 <= c290v4 then
        c290v2 = false
      else
        c290v2 = true
      end
      do return c290v2 end
    end
    c291v8(c291v0, c291v10)
    do return end
  end
  GetAllKeys = vT[132]
  vT[132] = function(c292v0)
    local c292v1, c292v2, c292v3, c292v4, c292v5, c292v6, c292v7, c292v8, c292v9, c292v10, c292v11, c292v12
    c292v1 = string.upper
    c292v2 = Localize
    c292v3 = c292v0:GetLocalizeTag()
    c292v3 = c292v3:c_str()
    c292v4 = {}
    c292v1 = c292v1(c292v2(c292v3, c292v4))
    c292v2 = Localize
    c292v3 = "/Lotus/Language/ShipFeatureItems/ShipFeatureUpgraded"
    c292v4 = { SEGMENT = nil }
    c292v4.SEGMENT = c292v1
    c292v2 = c292v2(c292v3, c292v4)
    c292v3 = "<font color=\"#FloatingContent\"><br><b>"
    c292v2 = c292v3 .. c292v2
    c292v4 = "</b><br><br></font>"
    c292v2 = c292v2 .. c292v4
    c292v3 = Localize
    c292v4 = c292v0:GetLocalizeDescTag()
    c292v4 = c292v4:c_str()
    c292v5 = {}
    c292v3 = c292v3(c292v4, c292v5)
    c292v4 = 0
    c292v5 = ""
    while true do
      c292v6 = string.find
      c292v8 = "\r\n%-[^%-^\r^\n]+"
      c292v6, c292v7 = c292v6(c292v3, c292v8, c292v4)
      if (c292v6 == nil or c292v7 == nil) then break end
      c292v8 = c292v3:sub(c292v6, c292v7)
      if c292v8 == nil then break end
      c292v11 = "\r\n"
      c292v12 = ""
      c292v8 = c292v8:gsub(c292v11, c292v12)
      c292v10 = "    "
      c292v12 = "<br>"
      c292v5 = c292v5 .. c292v10 .. c292v8 .. c292v12
      c292v4 = c292v7
    end
    c292v6 = "<font color=\"#Content\">"
    c292v8 = "</font>"
    c292v5 = c292v6 .. c292v5 .. c292v8
    c292v6 = vT[17]
    c292v6 = c292v6.ShowMessage
    c292v7 = c292v2 .. c292v5
    c292v8 = nil
    c292v9 = nil
    c292v10 = true
    c292v6(c292v7, c292v8, c292v9, c292v10)
    do return end
  end
  ShowDialogForFeatureUpgrade = vT[132]
  vT[132] = function(c293v0)
    local c293v1, c293v2, c293v3, c293v4, c293v5, c293v6, c293v7, c293v8, c293v9, c293v10, c293v11, c293v12, c293v13, c293v14, c293v15, c293v16, c293v17, c293v18, c293v19, c293v20, c293v21, c293v22, c293v23, c293v24, c293v25, c293v26
    c293v1 = gPlayerProfileMgr
    c293v1 = c293v1:IsLoggedIn()
    if c293v1 then
      c293v2 = gRegion
      c293v1 = IsNull
      c293v1 = c293v1(c293v2)
      if not c293v1 then
        c293v1 = gRegion
        c293v3 = gUIConsoleTriggerType
        c293v1 = c293v1:FindAll(c293v3)
        c293v2 = gGameData
        c293v3 = false
        c293v4 = Symbol
        c293v5 = "News"
        c293v4 = c293v4(c293v5)
        c293v5 = Symbol
        c293v6 = "Conclave"
        c293v5 = c293v5(c293v6)
        c293v6 = Symbol
        c293v7 = "1999"
        c293v6 = c293v6(c293v7)
        c293v7 = Symbol
        c293v8 = "Tau"
        c293v7 = c293v7(c293v8)
        c293v10 = 1
        c293v8 = 2
        c293v9 = 1
        for c293v10 = c293v10, c293v8, c293v9 do
          c293v11 = {}
          c293v14 = 1
          c293v12 = #c293v1
          c293v13 = 1
          for c293v14 = c293v14, c293v12, c293v13 do
            c293v17 = c293v1[c293v14]
            c293v17 = c293v17:Name__5bd1bfe4()
            c293v17 = IsNull
            c293v17 = c293v17(c293v2)
            c293v23 = c293v17[c293v22]
            c293v23 = c293v23.mFeatureItem
            c293v24 = tostring
            c293v24 = c293v24(c293v23:GetFullName())
            c293v25 = c293v2:HasShipFeature(c293v23)
            c293v25 = c293v1[c293v14]
            c293v25:Name__79f08a99(c293v23)
            c293v18 = true
            c293v25 = c293v11[c293v24]
            c293v25 = c293v2:CanUnlockShipFeature(c293v23)
            c293v25 = c293v17[c293v22]
            c293v25 = c293v25.mRequiresMainUpgrade
            c293v25 = c293v1[c293v14]
            c293v25 = c293v25:Scarabcommon()
            c293v25 = SF_INFESTED_FOUNDRY
            c293v25 = SF_INFESTED_FOUNDRY_UPGRADE
            c293v25 = SF_INFESTED_FOUNDRY_SHARD_UPGRADE
            c293v25 = SF_INFESTED_FOUNDRY_FUSION_UPGRADE
            c293v25 = c293v1[c293v14]
            c293v25:Enable()
            c293v17 = WeakResource
            c293v18 = "/Lotus/Types/Keys/NewWarQuest/NewWarQuestKeyChain"
            c293v17 = c293v17(c293v18)
            c293v18 = vT[27]
            c293v19 = gGameData
            c293v18, c293v19 = c293v18(c293v19)
            c293v20 = IsNull
            c293v20 = c293v20(c293v18)
            c293v20 = c293v18:IsA(c293v17)
            c293v20 = vT[87]
            c293v21 = vT[38]
            c293v22 = true
            c293v20 = c293v20(c293v21, c293v22)
            c293v20 = c293v1[c293v14]
            c293v20:Enable()
            c293v20 = c293v1[c293v14]
            c293v20:Disable()
            c293v25 = c293v1[c293v14]
            c293v25:Name__0590e549(c293v23)
            c293v25 = true
            c293v11[c293v24] = c293v25
            c293v18 = true
            if not c293v3 then
              c293v26 = c293v17[c293v22]
              c293v26 = c293v26.mInstallNowTransmission
              c293v25 = IsNull
              c293v25 = c293v25(c293v26)
              if not c293v25 then
                c293v25 = CreateHudlessTransmission
                c293v26 = c293v17[c293v22]
                c293v26 = c293v26.mInstallNowTransmission
                c293v25(c293v26)
                c293v3 = true
              end
            end
            c293v20 = c293v1[c293v14]
            c293v22 = c293v18 and c293v16
            c293v20:Name__d9c6b8a5(c293v22)
            if not (((not (c293v0) and c293v15 ~= c293v5) or not c293v16)) then
              c293v20 = c293v1[c293v14]
              c293v20:Start()
            end
            c293v15 = c293v1[c293v14]
            c293v15 = c293v15:GetTag()
            c293v16 = true
            c293v17 = Name__8fb019b4
            c293v17 = c293v17()
            if c293v17 then
              c293v17 = Engine.IsConsole
              c293v17 = c293v17()
              if not ((c293v17 or c293v15 ~= c293v4)) then
                c293v16 = false
              end
            end
            if not ((not (c293v15 == c293v5) and c293v15 ~= c293v4)) then
              c293v17 = HasCompletedVorsPrize
              c293v17 = c293v17()
              if not c293v17 then
                c293v16 = false
              end
            end
            c293v17 = c293v1[c293v14]
            c293v17 = c293v17:HoveringQP()
            c293v19 = #c293v17
            if c293v19 ~= 0 then
              c293v18 = false
            else
              c293v18 = true
            end
            c293v19 = vT[17]
            c293v19 = c293v19.Ternary
            if c293v10 ~= 1 then
              c293v20 = false
            else
              c293v20 = true
            end
            c293v22 = 1
            c293v23 = #c293v17
            c293v21 = math.min
            c293v21 = c293v21(c293v22, c293v23)
            c293v22 = #c293v17
            c293v19 = c293v19(c293v20, c293v21, c293v22)
            c293v22 = 1
            c293v20 = c293v19
            c293v21 = 1
          end
        end
        c293v8 = _T
        c293v9 = true
        c293v8.uiConsoleTriggersInitialized = c293v9
        do return end
      end
    end
    c293v1 = print
    c293v2 = "Warning: called UpdateUIConsoleTriggers but the player isn't logged in yet!"
    c293v1(c293v2)
    do return end
  end
  UpdateUIConsoleTriggers = vT[132]
  vT[132] = function(c294v0)
    local c294v1, c294v2, c294v3, c294v4, c294v5, c294v6, c294v7, c294v8, c294v10, c294v11
    c294v1 = c294v0
    c294v2 = string.len
    c294v2 = c294v2(c294v0)
    if c294v2 == 0 then
      c294v3 = false
      do return c294v3 end
    end
    c294v5 = 1
    c294v6 = 1
    c294v3 = string.sub
    c294v3 = c294v3(c294v0, c294v5, c294v6)
    c294v4 = string.sub
    c294v4 = c294v4(c294v0, c294v2, c294v2)
    c294v7 = 0
    c294v5 = 9
    c294v6 = 1
    for c294v7 = c294v7, c294v5, c294v6 do
      c294v8 = string.gsub
      c294v10 = tostring
      c294v10 = c294v10(c294v7)
      c294v11 = ""
      c294v1 = c294v8(c294v1, c294v10, c294v11)
    end
    if c294v2 ~= 0 then
      local p19 = 6
      if p19 == 6 then
        if c294v1 ~= " " then
          p19 = 9
        else
          p19 = 7
        end
      end
      if p19 == 7 then
        if (c294v3 == " " or c294v4 == " ") then
        else
          p19 = 9
        end
      end
      if p19 == 9 then
        if (not (c294v1 == ". ") and c294v1 ~= " .") then
          p19 = 12
        else
        end
      end
      if p19 == 12 then
        c294v5 = false
        do return c294v5 end
      end
    end
    c294v5 = true
    do return c294v5 end
  end
  DoesStringContainAllDigits = vT[132]
  vT[132] = function(c295v0, c295v1)
    local c295v2, c295v3, c295v4, c295v5, c295v6, c295v7, c295v8, c295v9
    c295v2 = _T.CustomHeadTracking
    if c295v2 then
      c295v2 = false
      do return c295v2 end
    end
    c295v2 = _T.GetTopScreen
    if not c295v2 then
      local p30 = 3
      if p30 == 3 then
        c295v3 = gRegion
        c295v2 = IsNull
        c295v2 = c295v2(c295v3)
        if c295v2 then
        else
          p30 = 4
        end
      end
      if p30 == 4 then
        c295v2 = IsNull
        c295v2 = c295v2(c295v0)
        if not c295v2 then
          p30 = 6
        else
        end
      end
      if p30 == 6 then
        c295v2 = _T.GetTopScreen
        c295v2, c295v3 = c295v2()
        c295v4 = gRegion
        c295v4 = c295v4:GetPlayingCinematic()
        c295v5 = c295v0:InventoryControl()
        c295v8 = 0
        c295v6 = c295v5:GetWeaponInHand(c295v8)
        c295v7 = _T.DisableHeadTracking
        if (c295v7 or c295v3 == "LoadOut") then
          p30 = 19
        else
          p30 = 8
        end
      end
      if p30 == 8 then
        c295v7 = IsNull
        c295v7 = c295v7(c295v4)
        if c295v7 then
          p30 = 10
        else
          p30 = 9
        end
      end
      if p30 == 9 then
        c295v7 = c295v4:DisableLookIK()
        if c295v7 then
          p30 = 19
        else
          p30 = 10
        end
      end
      if p30 == 10 then
        c295v9 = gLotusVehicleAvatarType
        c295v7 = c295v0:IsA(c295v9)
        if c295v7 then
          p30 = 19
        else
          p30 = 11
        end
      end
      if p30 == 11 then
        c295v7 = c295v0:IsDoingFinisher()
        if c295v7 then
          p30 = 19
        else
          p30 = 12
        end
      end
      if p30 == 12 then
        c295v7 = c295v0:holderRoar()
        if c295v7 then
          p30 = 19
        else
          p30 = 13
        end
      end
      if p30 == 13 then
        c295v9 = 0
        c295v7 = c295v0:HasPostureModifier(c295v9)
        if c295v7 then
          p30 = 19
        else
          p30 = 14
        end
      end
      if p30 == 14 then
        c295v9 = 3
        c295v7 = c295v0:HasPostureModifier(c295v9)
        if c295v7 then
          p30 = 19
        else
          p30 = 15
        end
      end
      if p30 == 15 then
        c295v7 = IsNull
        c295v7 = c295v7(c295v6)
        if c295v7 then
          p30 = 18
        else
          p30 = 16
        end
      end
      if p30 == 16 then
        c295v7 = c295v6:IsCharging()
        if c295v7 then
          p30 = 19
        else
          p30 = 17
        end
      end
      if p30 == 17 then
        c295v7 = vT[10]
        if c295v6 == c295v7 then
          p30 = 19
        else
          p30 = 18
        end
      end
      if p30 == 18 then
        c295v7 = c295v0:PeerRig()
        if not c295v7 then
          p30 = 20
        else
          p30 = 19
        end
      end
      if p30 == 19 then
        c295v0:ClearLookTarget()
        p30 = 25
      end
      if p30 == 20 then
        c295v7 = nil
        c295v8 = _T.DiegeticPosition
        if (not c295v8 or c295v1 == true) then
          p30 = 23
        else
          p30 = 22
        end
      end
      if p30 == 22 then
        c295v7 = _T.DiegeticPosition
        p30 = 24
      end
      if p30 == 23 then
        c295v7 = c295v5:GetAimEndPoint()
        p30 = 24
      end
      if p30 == 24 then
        c295v0:SetLookTarget(c295v7)
        p30 = 25
      end
      if p30 == 25 then
        c295v7 = true
        do return c295v7 end
      end
    end
    c295v2 = false
    do return c295v2 end
  end
  UpdateHeadTracking = vT[132]
  vT[132] = function(c296v0, c296v1)
    local c296v2, c296v3, c296v4, c296v5, c296v6, c296v7, c296v8, c296v9, c296v10, c296v11, c296v12, c296v13, c296v14, c296v15, c296v16, c296v17, c296v18
    c296v2 = {}
    c296v3 = IsNull
    c296v3 = c296v3(c296v1)
    if c296v3 then
      do return c296v2 end
    end
    c296v3 = vT[57]
    c296v3 = c296v3()
    c296v4 = {}
    c296v5 = c296v0:GetMissions()
    c296v8 = 1
    c296v6 = #c296v5
    c296v7 = 1
    for c296v8 = c296v8, c296v6, c296v7 do
      c296v11 = c296v5[c296v8]
      c296v11 = c296v11.mTag
      c296v9 = c296v3:DisableCheckZone(c296v11)
      c296v10 = c296v9.name
      c296v11 = true
      c296v4[c296v10] = c296v11
    end
    c296v8 = gNavigationFeatureItemType
    c296v6 = c296v1:GetStoreItemsOfType(c296v8)
    c296v9 = 1
    c296v7 = #c296v6
    c296v8 = 1
    if not c296v3 then
      c296v10 = c296v6[c296v9]
      c296v10 = c296v10:GetItem()
      c296v11 = Resource
      c296v11 = c296v11(c296v10)
      c296v12 = c296v11:GetNodesUnlocked()
      c296v15 = 1
      c296v13 = #c296v12
      c296v14 = 1
      for c296v15 = c296v15, c296v13, c296v14 do
        c296v18 = c296v12[c296v15]
        c296v16 = c296v3:DisableCheckZone(c296v18)
        c296v18 = c296v16.name
        c296v17 = c296v4[c296v18]
        if c296v17 then
          c296v17 = c296v16.name
          c296v18 = false
          c296v4[c296v17] = c296v18
          c296v17 = table.insert
          c296v17(c296v2, c296v10)
        end
      end
    end
    do return c296v2 end
  end
  GetUnlockedNavFeatures = vT[132]
  vT[132] = function(c297v0, c297v1, c297v2)
    local c297v3, c297v4, c297v5, c297v6, c297v7, c297v8, c297v9, c297v10, c297v11, c297v12, c297v13, c297v14, c297v15, c297v16, c297v17
    c297v3 = vT[17]
    c297v3 = c297v3.ConvertColorNumberToProceduralRGB
    c297v4 = _G
    c297v4 = c297v4.UIColor_DarkGrey
    c297v3 = c297v3(c297v4)
    c297v4 = vT[17]
    c297v4 = c297v4.Ternary
    if c297v2 ~= nil then
      c297v5 = false
    else
      c297v5 = true
    end
    c297v6 = _G
    c297v6 = c297v6.UIMaterial_Rectangle
    c297v4 = c297v4(c297v5, c297v6, c297v2)
    c297v5 = ipairs
    c297v10 = ".Foreground"
    c297v8 = c297v1 .. c297v10
    c297v11 = ".Shadow"
    c297v9 = c297v1 .. c297v11
    c297v12 = ".BackShadow"
    c297v10 = c297v1 .. c297v12
    c297v6 = {c297v8, c297v9, c297v10}
    c297v5, c297v6, c297v7 = c297v5(c297v6)
    for c297v8, c297v9 in c297v5, c297v6, c297v7 do
      c297v0:OverrideMaterial(c297v9, c297v4)
      c297v13 = "RectInnerColor"
      c297v14 = c297v3.r
      c297v15 = c297v3.g
      c297v16 = c297v3.b
      c297v17 = 0.35
      c297v0:Name__e243d995(c297v9, c297v13, c297v14, c297v15, c297v16, c297v17)
      c297v13 = "RectEdgeColor"
      c297v14 = _G
      c297v14 = c297v14.UIColorObject_White
      c297v14 = c297v14.r
      c297v15 = _G
      c297v15 = c297v15.UIColorObject_White
      c297v15 = c297v15.g
      c297v16 = _G
      c297v16 = c297v16.UIColorObject_White
      c297v16 = c297v16.b
      c297v17 = 1
      c297v0:Name__e243d995(c297v9, c297v13, c297v14, c297v15, c297v16, c297v17)
    end
    c297v8 = "Foreground"
    c297v9 = 4
    c297v10 = 0
    c297v0:Name__52c1b74e(c297v1, c297v8, c297v9, c297v10)
    c297v8 = "Shadow"
    c297v9 = 4
    c297v10 = 200
    c297v0:Name__52c1b74e(c297v1, c297v8, c297v9, c297v10)
    c297v8 = "BackShadow"
    c297v9 = 4
    c297v10 = 400
    c297v0:Name__52c1b74e(c297v1, c297v8, c297v9, c297v10)
    c297v8 = "Foreground"
    c297v9 = 12
    c297v10 = 75
    c297v0:Name__52c1b74e(c297v1, c297v8, c297v9, c297v10)
    c297v8 = "Shadow"
    c297v9 = 12
    c297v10 = 45
    c297v0:Name__52c1b74e(c297v1, c297v8, c297v9, c297v10)
    c297v8 = "BackShadow"
    c297v9 = 12
    c297v10 = 25
    c297v0:Name__52c1b74e(c297v1, c297v8, c297v9, c297v10)
    c297v6 = IsNull
    c297v6 = c297v6(c297v4)
    c297v5 = not c297v6
    do return c297v5 end
  end
  SetUpInWorldPanel = vT[132]
  vT[132] = function(c298v0)
    local c298v1, c298v2, c298v3, c298v5
    c298v1 = 0.0031308
    if c298v0 <= c298v1 then
      c298v1 = c298v0 * 12.92
      do return c298v1 end
    end
    c298v5 = 0.4166666666666667
    c298v3 = math.pow
    c298v3 = c298v3(c298v0, c298v5)
    c298v2 = c298v3 * 1.055
    c298v1 = c298v2 - 0.055
    do return c298v1 end
  end
  LinearToSRGB = vT[132]
  vT[132] = function(c299v0)
    local c299v1, c299v2, c299v3
    c299v1 = 0.03928
    if c299v0 <= c299v1 then
      c299v1 = c299v0 / 12.92
      do return c299v1 end
    end
    c299v3 = c299v0 + 0.055
    c299v2 = c299v3 / 1.055
    c299v3 = 2.4
    c299v1 = math.pow
    c299v1 = c299v1(c299v2, c299v3)
    do return c299v1 end
  end
  SRGBToLinear = vT[132]
  vT[132] = nil
  vT[133] = function()
    local c300v0, c300v1, c300v2, c300v3, c300v4, c300v5, c300v7, c300v8
    c300v0 = vT[41]
    c300v0 = c300v0()
    c300v1 = {}
    vT[132] = c300v1
    c300v1 = vT[132]
    c300v2 = 1
    c300v3 = "<POLARITY_ATTACK>"
    c300v1[c300v2] = c300v3
    c300v1 = vT[132]
    c300v2 = 2
    c300v3 = "<POLARITY_DEFENSE>"
    c300v1[c300v2] = c300v3
    c300v1 = vT[132]
    c300v2 = 3
    c300v3 = "<POLARITY_TACTIC>"
    c300v1[c300v2] = c300v3
    c300v1 = vT[132]
    c300v2 = 4
    c300v3 = "<POLARITY_POWER>"
    c300v1[c300v2] = c300v3
    c300v1 = vT[132]
    c300v2 = 5
    c300v3 = "<POLARITY_PRECEPT>"
    c300v1[c300v2] = c300v3
    c300v1 = vT[132]
    c300v2 = 6
    c300v3 = "<POLARITY_FUSION>"
    c300v1[c300v2] = c300v3
    c300v1 = vT[132]
    c300v2 = 7
    c300v3 = "<POLARITY_WARD>"
    c300v1[c300v2] = c300v3
    c300v1 = vT[132]
    c300v2 = 8
    c300v3 = "<POLARITY_UMBRA>"
    c300v1[c300v2] = c300v3
    c300v1 = vT[132]
    c300v2 = 9
    c300v3 = "<POLARITY_ANY>"
    c300v1[c300v2] = c300v3
    c300v3 = 1
    c300v4 = vT[132]
    c300v1 = #c300v4
    c300v2 = 1
    for c300v3 = c300v3, c300v1, c300v2 do
      c300v4 = vT[132]
      c300v5 = c300v0.mMovie
      c300v8 = vT[132]
      c300v7 = c300v8[c300v3]
      c300v8 = true
      c300v5 = c300v5:GetLocalized(c300v7, c300v8)
      c300v4[c300v3] = c300v5
    end
    do return end
  end
  vT[134] = function()
    local c301v0
    c301v0 = vT[133]
    c301v0()
    do return end
  end
  LocalizePolarities = vT[134]
  vT[134] = function(c302v0)
    local c302v1, c302v2
    c302v1 = vT[132]
    if c302v1 == nil then
      c302v1 = vT[133]
      c302v1()
    end
    c302v2 = vT[132]
    c302v1 = c302v2[c302v0]
    if c302v1 then
      c302v2 = vT[132]
      c302v1 = c302v2[c302v0]
      do return c302v1 end
    end
    c302v1 = ""
    do return c302v1 end
  end
  GetTagForPolarity = vT[134]
  vT[134] = function(c303v0)
    local c303v1, c303v2, c303v3, c303v4
    c303v1 = type
    c303v1 = c303v1(c303v0)
    if c303v1 ~= "string" then
      c303v0 = c303v0:GetFullName()
    end
    c303v2 = _G
    c303v2 = c303v2.UIMovie_EndOfQuestMovie
    c303v1 = IsNull
    c303v1 = c303v1(c303v2)
    if not c303v1 then
      c303v1 = gFlashMgr
      c303v3 = _G
      c303v3 = c303v3.UIMovie_EndOfQuestMovie
      c303v1 = c303v1:GotoMovie(c303v3)
      c303v2 = IsNull
      c303v2 = c303v2(c303v1)
      if not c303v2 then
        c303v4 = "SetQuestType"
        c303v1:Execute(c303v4, c303v0)
      end
    end
    do return end
  end
  ShowQuestCompleted = vT[134]
  vT[134] = function(c304v0, c304v1, c304v2)
    local c304v6, c304v7, c304v8, c304v9, c304v10
    if c304v2 == nil then
      c304v2 = true
    end
    c304v6 = vT[17]
    c304v6 = c304v6.Ternary
    c304v8 = _G
    c304v8 = c304v8.UIMaterial_RectangleNoDepth
    c304v9 = _G
    c304v9 = c304v9.UIMaterial_Rectangle
    c304v0:OverrideMaterial(c304v1, c304v6(c304v2, c304v8, c304v9))
    c304v6 = "RectInnerColor"
    c304v7 = _G
    c304v7 = c304v7.UIColorObject_DarkBlue
    c304v7 = c304v7.r
    c304v8 = _G
    c304v8 = c304v8.UIColorObject_DarkBlue
    c304v8 = c304v8.g
    c304v9 = _G
    c304v9 = c304v9.UIColorObject_DarkBlue
    c304v9 = c304v9.b
    c304v10 = 0.2
    c304v0:Name__e243d995(c304v1, c304v6, c304v7, c304v8, c304v9, c304v10)
    c304v6 = "RectEdgeColor"
    c304v7 = _G
    c304v7 = c304v7.UIColorObject_White
    c304v7 = c304v7.r
    c304v8 = _G
    c304v8 = c304v8.UIColorObject_White
    c304v8 = c304v8.g
    c304v9 = _G
    c304v9 = c304v9.UIColorObject_White
    c304v9 = c304v9.b
    c304v10 = 0
    c304v0:Name__e243d995(c304v1, c304v6, c304v7, c304v8, c304v9, c304v10)
    do return end
  end
  ApplyGenericBackerMaterial = vT[134]
  vT[134] = function(c305v0, c305v1, c305v2, c305v3, c305v4)
    local c305v5, c305v6, c305v7, c305v8, c305v9, c305v10, c305v11, c305v12, c305v13, c305v14, c305v15, c305v16, c305v17
    c305v5 = gGameData
    c305v6 = IsNull
    c305v6 = c305v6(c305v5)
    c305v6 = IsNull
    c305v6 = c305v6(c305v0)
    c305v9 = c305v7.mStanding
    c305v10 = gGameData
    c305v10 = c305v10:Name__648bc369()
    c305v13 = 1
    c305v11 = #c305v10
    c305v12 = 1
    for c305v13 = c305v13, c305v11, c305v12 do
      c305v14 = c305v10[c305v13]
      c305v14 = c305v14.mTag
      if c305v14 == c305v6 then
        c305v14 = c305v10[c305v13]
        c305v14 = c305v14.mStanding
        c305v9 = c305v9 - c305v14
      end
    end
    c305v9 = c305v0:GetAffiliationTag()
    c305v7 = c305v5:GetAffiliation(c305v9)
    c305v8 = vT[17]
    c305v8 = c305v8.Ternary
    if c305v3 == nil then
      c305v9 = false
    else
      c305v9 = true
    end
    c305v11 = c305v7.mTitle
    c305v8 = c305v8(c305v9, c305v3, c305v11)
    c305v9 = tonumber
    c305v9 = c305v9(c305v2)
    if c305v6 then
      c305v6 = 0
      c305v7 = 0
      c305v8 = 1
      c305v9 = false
      c305v10 = 0
      do return c305v6, c305v7, c305v8, c305v9, c305v10 end
    end
    c305v10 = vT[17]
    c305v10 = c305v10.Ternary
    c305v11 = c305v0:UsesTitles()
    c305v12 = gGameConfig
    c305v12 = c305v12:Name__2e73d72c(c305v6, c305v8)
    c305v13 = 0
    c305v10 = c305v10(c305v11, c305v12, c305v13)
    c305v11 = vT[17]
    c305v11 = c305v11.Ternary
    c305v12 = c305v0:UsesTitles()
    c305v13 = gGameConfig
    c305v13 = c305v13:Name__8c66febb(c305v6, c305v8)
    c305v11 = c305v11(c305v12, c305v13, c305v0:GetMaxStanding())
    c305v12 = c305v11 - c305v9
    c305v13 = c305v0:GetDailyStandingLimitBin()
    c305v14 = 0
    if c305v14 < c305v13 then
      c305v14 = 15
      if c305v13 < c305v14 then
        c305v14 = c305v0:StandingBonusesCappedByDailyLimit()
        if c305v14 then
          c305v14 = c305v5:GetDailyStandingLimit(c305v13)
          c305v15 = math.min
          c305v12 = c305v15(c305v12, c305v14)
        end
      end
    end
    if c305v1 ~= nil then
      c305v14 = tonumber
      c305v14 = c305v14(c305v1)
      c305v9 = c305v9 + c305v14
    end
    c305v14 = c305v9 - c305v10
    c305v15 = c305v11 - c305v10
    if c305v14 < c305v15 then
      c305v16 = false
    else
      c305v16 = true
    end
    c305v17 = c305v0:UsesTitles()
    if c305v17 then
      if c305v8 == 0 then
        c305v15 = c305v15 / 2
        c305v14 = c305v14 - c305v15
        c305v17 = 0
        if c305v14 < c305v17 then
          c305v15 = -c305v15
        end
      else
        c305v17 = 0
        if c305v8 < c305v17 then
          c305v14 = c305v14 - c305v15
          c305v15 = -c305v15
        end
      end
    end
    do return c305v8, c305v14, c305v15, c305v16, c305v12 end
  end
  vT[135] = function(c306v0, c306v1, c306v2, c306v3, c306v4)
    local c306v5
    c306v5 = vT[134]
    do return c306v5(c306v0, c306v1, c306v2, c306v3, c306v4) end
  end
  GetReputationInfoForSyndicate = vT[135]
  vT[135] = function(c307v0, c307v1)
    local c307v2, c307v3, c307v4, c307v5, c307v6, c307v7, c307v8
    c307v6 = 1
    c307v7 = c307v0.mAdditionalLovedSyndicateRequirements
    c307v4 = #c307v7
    c307v5 = 1
    for c307v6 = c307v6, c307v4, c307v5 do
      c307v7 = c307v0.mAdditionalLovedSyndicateRequirements
      c307v2 = c307v7[c307v6]
      c307v7 = IsNull
      c307v7 = c307v7(c307v2)
      if not c307v7 then
        c307v7 = vT[134]
        c307v7 = c307v7(c307v2)
        c307v3 = c307v2:GetLovedTitle()
        if c307v7 < c307v3 then
          c307v8 = false
          c307v1.Loved = c307v8
        end
      end
    end
    c307v4 = c307v0.mSpeakerSyndicate
    c307v3 = IsNull
    c307v3 = c307v3(c307v4)
    if not c307v3 then
      c307v2 = c307v0.mSpeakerSyndicate
    end
    c307v3 = vT[134]
    c307v3, c307v4, c307v5, c307v6 = c307v3(c307v2)
    c307v1.Level = c307v3
    c307v1.Reputation = c307v4
    c307v1.ReputationRequired = c307v5
    c307v1.HasEnoughReputationForSacrifice = c307v6
    c307v3 = 3
    c307v4 = IsNull
    c307v4 = c307v4(c307v2)
    if not c307v4 then
      c307v3 = c307v2:GetLovedTitle()
    end
    c307v5 = c307v1.Level
    if c307v5 < c307v3 then
      c307v4 = false
    else
      c307v4 = true
    end
    c307v1.Loved = c307v4
    c307v4 = c307v1.Loved
    c307v4 = c307v0.mHubNpc
    if c307v4 then
      c307v4 = c307v0.mHubNpc
      c307v4 = c307v4:GetTag()
      c307v5 = Symbol
      c307v6 = "NightcapNpc"
      c307v5 = c307v5(c307v6)
      if c307v4 == c307v5 then
        c307v4 = gGameData
        c307v6 = Symbol
        c307v7 = "CompletedVision3"
        c307v4 = c307v4:HasCompletedNodeIntro(c307v6(c307v7))
        if not c307v4 then
          c307v4 = false
          c307v1.Loved = c307v4
        end
      end
    end
    c307v4 = gPlayerProfileMgr
    c307v6 = 0
    c307v4 = c307v4:GetPlayerProfile(c307v6)
    c307v5 = IsNull
    c307v5 = c307v5(c307v4)
    if not c307v5 then
      c307v5 = c307v4:Settings()
      c307v6 = c307v1.Loved
      if c307v6 then
        c307v7 = c307v5:GetStreamerMode()
        c307v6 = not c307v7
      end
      c307v1.Loved = c307v6
    end
    do return end
  end
  vT[136] = function(c308v0, c308v1)
    local c308v2
    c308v2 = vT[135]
    c308v2(c308v0, c308v1)
    do return end
  end
  GetLovedReputationInfoForSyndicate = vT[136]
  vT[136] = function(c309v0, c309v1)
    local c309v2, c309v3, c309v4, c309v5, c309v6, c309v7, c309v8, c309v9, c309v10
    c309v4 = c309v1.mClipName
    c309v5 = "Image"
    c309v6 = 12
    c309v7 = vT[17]
    c309v7 = c309v7.Ternary
    c309v9 = c309v1.Icon
    c309v8 = IsNull
    c309v8 = c309v8(c309v9)
    c309v9 = 0
    c309v10 = 100
    c309v0:Name__52c1b74e(c309v4, c309v5, c309v6, c309v7(c309v8, c309v9, c309v10))
    c309v3 = c309v1.Icon
    c309v2 = IsNull
    c309v2 = c309v2(c309v3)
    if c309v2 then
      do return end
    end
    c309v2 = WeakResource
    c309v3 = "/Lotus/Types/Game/LotusSigil"
    c309v2 = c309v2(c309v3)
    c309v6 = c309v1.mClipName
    c309v7 = ".Image"
    c309v5 = c309v6 .. c309v7
    c309v6 = 15
    c309v3 = c309v0:GetNumberVariable(c309v5, c309v6)
    c309v4 = vT[17]
    c309v4 = c309v4.Ternary
    c309v5 = c309v1.Type
    c309v5 = c309v5:IsA(c309v2)
    c309v7 = c309v3 * 1.444
    c309v4 = c309v4(c309v5, c309v3, c309v7)
    c309v8 = c309v1.mClipName
    c309v9 = ".Image"
    c309v7 = c309v8 .. c309v9
    c309v8 = c309v1.Icon
    c309v0:OverrideTexture(c309v7, c309v8)
    c309v7 = c309v1.mClipName
    c309v8 = "Image"
    c309v9 = 14
    c309v0:Name__52c1b74e(c309v7, c309v8, c309v9, c309v4)
    do return end
  end
  DrawItem = vT[136]
  vT[136] = function()
    local c310v0, c310v1, c310v2, c310v3, c310v4, c310v7, c310v8
    c310v0 = gGameData
    c310v1 = IsNull
    c310v1 = c310v1(c310v0)
    if c310v1 then
      c310v1 = nil
      do return c310v1 end
    end
    c310v1 = c310v0:GetWorldState()
    c310v2 = IsNull
    c310v2 = c310v2(c310v1)
    if c310v2 then
      c310v2 = nil
      do return c310v2 end
    end
    c310v2 = ipairs
    c310v3 = c310v1.mDailyDeals
    c310v2, c310v3, c310v4 = c310v2(c310v3)
    for c310v5, c310v6 in c310v2, c310v3, c310v4 do
      c310v7 = Engine.Name__b38e1642
      c310v8 = c310v6.mActivation
      c310v7 = c310v7(c310v8)
      c310v8 = 0
      if c310v7 <= c310v8 then
        c310v7 = Engine.Name__b38e1642
        c310v8 = c310v6.mExpiry
        c310v7 = c310v7(c310v8)
        c310v8 = 0
        if c310v8 < c310v7 then
          c310v7 = Lotus_Game.DailyDealInfo
          do return c310v7(c310v6) end
        end
      end
    end
    c310v2 = nil
    do return c310v2 end
  end
  GetDailyDeal = vT[136]
  vT[136] = function(c311v0, c311v1)
    local c311v2, c311v3, c311v4, c311v5, c311v6, c311v7, c311v8, c311v9, c311v12
    c311v2 = _G
    c311v2.TrainingMissionRank = c311v0
    c311v2 = gGameConfig
    c311v2 = c311v2:Name__074ed0b4()
    c311v5 = c311v2 - 1
    c311v3 = math.min
    c311v0 = c311v3(c311v0, c311v5)
    c311v3 = _G
    c311v3.IsTrainingMissionReplay = c311v1
    c311v3 = gGameConfig
    c311v3 = c311v3:GetTrainingMission(c311v0)
    if c311v1 then
      c311v4 = c311v3.missionReward
      c311v5 = 0
      c311v4.credits = c311v5
    end
    c311v4 = Engine.OpenLevelArgs
    c311v4 = c311v4()
    c311v5 = c311v3:EncodeAsString()
    c311v6 = c311v3:GetEnemies()
    c311v9 = 1
    c311v7 = #c311v6
    c311v8 = 1
    for c311v9 = c311v9, c311v7, c311v8 do
      c311v12 = c311v6[c311v9]
      c311v12 = c311v12.agent
      c311v4:AddContextObject(c311v12)
    end
    c311v4:AddContextTag(c311v5)
    c311v9 = c311v3.levelOverride
    c311v4:SetLevel(c311v9:GetFullName())
    c311v7 = c311v3.gameRules
    c311v4.gameRules = c311v7
    c311v7 = false
    c311v4.migrateServer = c311v7
    c311v7 = Engine.OpenLevel
    c311v7(c311v4)
    do return end
  end
  OpenTrainingMission = vT[136]
  vT[136] = function()
    local c312v0
    c312v0 = 10
    do return c312v0 end
  end
  vT[137] = function()
    local c313v0
    c313v0 = vT[136]
    c313v0 = c313v0()
    do return c313v0 end
  end
  GetTrainingRetryPlatinumCost = vT[137]
  vT[137] = function(c314v0, c314v1, c314v2)
    local c314v3, c314v4, c314v5, c314v6, c314v7, c314v8, c314v9, c314v10, c314v11, c314v12, c314v13, c314v14, c314v15, c314v16, c314v17, c314v18, c314v19, c314v20, c314v21
    local p46 = 0
    if p46 == 0 then
      c314v3 = true
      c314v4 = ""
      c314v5 = IsNull
      c314v5 = c314v5(c314v0)
      if not c314v5 then
        p46 = 2
      else
        p46 = 1
      end
    end
    if p46 == 1 then
      c314v5 = false
      do return c314v5, c314v4 end
    end
    if p46 == 2 then
      c314v5 = c314v0:GetLoadOut()
      c314v8 = 0
      c314v9 = 1
      c314v6 = c314v5:GetWeaponInfo(c314v8, c314v9)
      c314v9 = 0
      c314v10 = 2
      c314v7 = c314v5:GetWeaponInfo(c314v9, c314v10)
      c314v10 = 0
      c314v11 = 3
      c314v8 = c314v5:GetWeaponInfo(c314v10, c314v11)
      c314v9 = c314v6.mItemId
      c314v9 = c314v9:IsValid()
      if not c314v9 then
        p46 = 5
      else
        p46 = 3
      end
    end
    if p46 == 3 then
      c314v9 = c314v7.mItemId
      c314v9 = c314v9:IsValid()
      if not c314v9 then
        p46 = 5
      else
        p46 = 4
      end
    end
    if p46 == 4 then
      c314v9 = c314v8.mItemId
      c314v9 = c314v9:IsValid()
      if c314v9 then
        p46 = 6
      else
        p46 = 5
      end
    end
    if p46 == 5 then
      c314v3 = false
      c314v4 = "/Lotus/Language/MasteryTest/IncompleteLoadout"
      p46 = 6
    end
    if p46 == 6 then
      c314v9 = gGameData
      c314v10 = c314v9:Name__1d1bb34a()
      c314v11 = gGameConfig
      c314v11 = c314v11:Name__074ed0b4()
      if c314v2 == nil then
        p46 = 8
      else
        p46 = 7
      end
    end
    if p46 == 7 then
      c314v12 = c314v2
      p46 = 9
    end
    if p46 == 8 then
      c314v12 = c314v10 + 1
      p46 = 9
    end
    if p46 == 9 then
      c314v15 = c314v11 - 1
      c314v13 = math.min
      c314v12 = c314v13(c314v12, c314v15)
      c314v13 = gGameConfig
      c314v13 = c314v13:GetTrainingMission(c314v12)
      c314v14 = c314v13.archwingRequired
      if not c314v14 then
        p46 = 16
      else
        p46 = 10
      end
    end
    if p46 == 10 then
      c314v14 = c314v9:GetInventory()
      c314v17 = 2
      c314v20 = 2
      c314v15 = c314v14:GetPreset(c314v17, c314v14:Name__9adc88cf(c314v20))
      c314v18 = 0
      c314v16 = c314v15:GetEntry(c314v18)
      c314v19 = 2
      c314v17 = c314v15:GetEntry(c314v19)
      c314v20 = 3
      c314v18 = c314v15:GetEntry(c314v20)
      c314v19 = c314v16.mItemId
      c314v19 = c314v19:IsValid()
      if not c314v19 then
        p46 = 13
      else
        p46 = 11
      end
    end
    if p46 == 11 then
      c314v19 = c314v17.mItemId
      c314v19 = c314v19:IsValid()
      if not c314v19 then
        p46 = 13
      else
        p46 = 12
      end
    end
    if p46 == 12 then
      c314v19 = c314v18.mItemId
      c314v19 = c314v19:IsValid()
      p46 = 13
    end
    if p46 == 13 then
      c314v21 = c314v9:ArchwingEnabled()
      c314v20 = c314v21 or false
      if (not (not c314v19) and c314v20) then
        p46 = 16
      else
        p46 = 15
      end
    end
    if p46 == 15 then
      c314v3 = false
      c314v4 = "/Lotus/Language/Menu/ArchwingFailureSolo"
      p46 = 16
    end
    if p46 == 16 then
      c314v14 = HasCompletedVorsPrize
      c314v14 = c314v14()
      if c314v14 then
        p46 = 18
      else
        p46 = 17
      end
    end
    if p46 == 17 then
      c314v3 = false
      c314v4 = "/Lotus/Language/MasteryTest/CompleteVorsPrize"
      p46 = 18
    end
    if p46 == 18 then
      if not c314v3 then
        p46 = 22
      else
        p46 = 19
      end
    end
    if p46 == 19 then
      c314v14 = c314v0:Name__927457bb()
      c314v15 = 0
      if (c314v14 <= c314v15 or c314v1) then
        p46 = 22
      else
        p46 = 21
      end
    end
    if p46 == 21 then
      c314v15 = vT[44]
      c314v15 = c314v15(c314v14)
      c314v16 = Localize
      c314v17 = "/Lotus/Language/Menu/Foreground_LevelUpSuspended"
      c314v18 = false
      c314v16 = c314v16(c314v17, c314v18)
      c314v17 = string.format
      c314v4 = c314v17(c314v16, c314v15)
      c314v3 = false
      p46 = 22
    end
    if p46 == 22 then
      if not c314v3 then
        p46 = 26
      else
        p46 = 23
      end
    end
    if p46 == 23 then
      c314v15 = gMatchingService
      c314v14 = IsNull
      c314v14 = c314v14(c314v15:GetSession())
      if c314v14 then
        p46 = 26
      else
        p46 = 24
      end
    end
    if p46 == 24 then
      c314v14 = gMatchingService
      c314v14 = c314v14:GetSession()
      c314v14 = c314v14:GetFilledSlots()
      c314v15 = 1
      if c314v14 <= c314v15 then
        p46 = 26
      else
        p46 = 25
      end
    end
    if p46 == 25 then
      c314v3 = false
      c314v4 = "/Lotus/Language/Menu/Foreground_LevelUpSessionActive"
      p46 = 26
    end
    if p46 == 26 then
      do return c314v3, c314v4 end
    end
  end
  CanRankUp = vT[137]
  vT[137] = function(c317v0, c317v1, c317v2, c317v3, c317v4)
    local c317v5, c317v6, c317v7, c317v8, c317v9, c317v10, c317v11, c317v12, c317v13, c317v14, c317v15, c317v16
    c317v5 = vT[17]
    c317v5 = c317v5.Ternary
    c317v7 = _G
    c317v7 = c317v7.IsTrainingMissionReplay
    c317v6 = IsNull
    c317v6 = c317v6(c317v7)
    c317v7 = true
    c317v8 = _G
    c317v8 = c317v8.IsTrainingMissionReplay
    c317v5 = c317v5(c317v6, c317v7, c317v8)
    c317v6 = require
    c317v7 = "Lotus.Scripts.ChallengeRooms.BaseChallengeRoom"
    c317v6 = c317v6(c317v7)
    c317v7 = WeakResource
    c317v8 = "/Lotus/Interface/SaveSpinner.swf"
    c317v7 = c317v7(c317v8)
    c317v8 = nil
    c317v9 = function(c315v0, c315v1)
      local c315v2, c315v3, c315v4, c315v5, c315v6, c315v7, c315v8
      c315v2 = print
      c315v4 = "OnChallengePassed: OnTrainingResultUploaded result="
      c315v8 = tostring
      c315v5 = c315v8(c315v0)
      c315v6 = ", body="
      c315v7 = tostring
      c315v7 = c315v7(c315v1)
      c315v3 = c315v4 .. c315v5 .. c315v6 .. c315v7
      c315v2(c315v3)
      c317v8 = c315v0
      do return end
    end
    if not c317v5 then
      c317v10 = gFlashMgr
      c317v13 = function()
        do return end
      end
      c317v10:Name__3e528491(c317v7, c317v13)
      c317v10 = gGameData
      c317v12 = 1
      c317v10:SubmitTrainingResult(c317v12, c317v9)
    end
    c317v10 = IsNull
    c317v10 = c317v10(c317v0)
    if c317v10 then
      c317v10 = gRegion
      c317v12 = 0
      c317v0 = c317v10:GetPlayerAvatar(c317v12)
    end
    c317v12 = gLotusVehicleAvatarType
    c317v10 = c317v0:IsA(c317v12)
    if c317v10 then
      c317v0 = c317v0:GetRider()
    end
    c317v10 = IsNull
    c317v10 = c317v10(c317v0)
    if not c317v10 then
      c317v13 = true
      c317v14 = 2
      c317v15 = 3
      c317v16 = true
      c317v0:PlayNonReplicatedAnimation(c317v1, c317v13, c317v14, c317v15, c317v16)
      c317v13 = true
      c317v0:GiveItem(c317v2, c317v13)
      c317v12 = true
      c317v0:Name__c4774f0a(c317v12)
    end
    c317v10 = false
    c317v11 = 2
    while true do
      if (c317v5 or c317v8) then break end
      while c317v8 == nil do
        c317v12 = Sleep
        c317v13 = 0
        c317v12(c317v13)
      end
      if c317v8 then break end
      if not c317v10 then
        c317v10 = true
        c317v12 = _T.BackgroundMovie
        c317v14 = "ShowBlockingMessage"
        c317v15 = "2"
        c317v12:Execute(c317v14, c317v15)
      end
      c317v12 = Sleep
      c317v12(c317v11)
      c317v13 = c317v11 * 2
      c317v14 = 15
      c317v12 = math.min
      c317v11 = c317v12(c317v13, c317v14)
      c317v8 = nil
      c317v12 = print
      c317v13 = "SubmitTrainingResult retrying..."
      c317v12(c317v13)
      c317v12 = gGameData
      c317v14 = 1
      c317v12:SubmitTrainingResult(c317v14, c317v9)
    end
    if c317v5 then
      if c317v10 then
        c317v12 = _T.BackgroundMovie
        c317v14 = "ShowBlockingMessage"
        c317v15 = "0"
        c317v12:Execute(c317v14, c317v15)
      end
    end
    c317v12 = Sleep
    c317v13 = 3
    c317v12(c317v13)
    c317v12 = gFlashMgr
    c317v12 = c317v12:FindMovie(c317v7)
    c317v13 = IsNull
    c317v13 = c317v13(c317v12)
    if not c317v13 then
      c317v15 = "Finished"
      c317v16 = ""
      c317v12:Execute(c317v15, c317v16)
    end
    c317v13 = c317v6.ChallengePassed
    c317v13(c317v3, c317v4, c317v5)
    do return end
  end
  OnChallengePassed = vT[137]
  vT[137] = function(c318v0)
    local c318v1, c318v2, c318v3, c318v4, c318v5, c318v6, c318v9, c318v10
    c318v1 = gGameRules
    c318v3 = gLotusBasePvpGameRulesType
    c318v1 = c318v1:IsA(c318v3)
    c318v2 = {}
    c318v3 = gRegion
    c318v3 = c318v3:GetHumanPlayers()
    c318v4 = ipairs
    c318v4, c318v5, c318v6 = c318v4(c318v3)
    for c318v7, c318v8 in c318v4, c318v5, c318v6 do
      c318v9 = c318v0:GetTeam()
      c318v10 = c318v8:GetTeam()
      c318v9 = _T.PvpMode
      c318v9 = _T.PvpMode
      c318v9 = _T.PvpMode
      c318v10 = 3
      c318v9 = c318v8:GetPlayerName()
      c318v10 = HIDDEN_PLAYER_NAME
      if c318v9 ~= c318v10 then
        c318v9 = table.insert
        c318v9(c318v2, c318v8)
      end
      for c318v7, c318v8 in c318v4, c318v5, c318v6 do
        do return c318v2 end
      end
    end
  end
  GetFriendlyPlayers = vT[137]
  vT[137] = function(c319v0, c319v1)
    local c319v2, c319v3, c319v4, c319v5
    while true do
      c319v2 = gRegion
      c319v2 = c319v2:FindNearestTagged(c319v0, c319v1)
      c319v3 = IsNull
      c319v3 = c319v3(c319v2)
      if not c319v3 then break end
      c319v5 = gRegion
      c319v5 = c319v5:IsMaster()
      c319v4 = not c319v5
      c319v3 = assert
      c319v3(c319v4)
      c319v3 = Sleep
      c319v4 = 0
      c319v3(c319v4)
    end
    do return c319v2 end
  end
  FindNearestTagged = vT[137]
  vT[137] = function(c320v0)
    local c320v1, c320v2, c320v3, c320v4
    c320v1 = c320v0
    if c320v1 == "" then
      c320v2 = Localize
      c320v3 = "/Lotus/Language/Menu/Loadout_Default"
      c320v4 = false
      c320v1 = c320v2(c320v3, c320v4)
    end
    c320v2 = string.find
    c320v4 = "/Lotus/Language/Bundles"
    c320v2 = c320v2(c320v1, c320v4)
    if c320v2 ~= nil then
      c320v2 = Localize
      c320v4 = {}
      c320v1 = c320v2(c320v1, c320v4)
    end
    c320v2 = IsChinaBuild
    c320v2 = c320v2()
    if c320v2 then
      c320v2 = SanitizeText
      c320v4 = 1
      c320v1 = c320v2(c320v1, c320v4)
    end
    do return c320v1 end
  end
  vT[138] = function(c321v0)
    local c321v1
    c321v1 = vT[137]
    do return c321v1(c321v0) end
  end
  GetLoadoutPresetName = vT[138]
  vT[138] = function(c322v0)
    local c322v1, c322v3, c322v4, c322v5, c322v6, c322v7, c322v9, c322v10, c322v11, c322v12, c322v13, c322v14, c322v15, c322v16
    c322v1 = gGameData
    local c322v2 = IsNull
    c322v2 = c322v2(c322v1)
    if c322v2 then
      c322v2 = ""
      c322v3 = false
      do return c322v2, c322v3 end
    end
    c322v2 = _T.ActiveQuestLoaded
    if not c322v2 then
      c322v2 = print
      c322v3 = "Update quests: no active quest loaded"
      c322v2(c322v3)
      c322v2 = ""
      c322v3 = false
      do return c322v2, c322v3 end
    end
    c322v2 = vT[27]
    c322v2, c322v3, c322v4, c322v5 = c322v2(c322v1)
    c322v6 = ""
    c322v7 = true
    local c322v8 = _T.questInfo
    if c322v8 ~= nil then
      c322v7 = true
      c322v8 = _T.questInfo.activeQuest
      if c322v8 ~= nil then
        c322v7 = true
        c322v8 = _T.questInfo.activeQuest
        if c322v8 == c322v2 then
          c322v7 = true
          c322v8 = _T.questInfo.stage
          if c322v8 == c322v3 then
            c322v8 = _T.questInfo.gameRules
            c322v9 = gGameRules
            if c322v8 == c322v9 then
              c322v7 = false
            else
              c322v7 = true
            end
          end
        end
      end
    end
    c322v8 = _T
    c322v9 = { activeQuest = nil, stage = nil, difficulty = nil, canProgress = nil, gameRules = nil }
    c322v9.activeQuest = c322v2
    c322v9.stage = c322v3
    c322v9.difficulty = c322v4
    c322v9.canProgress = c322v5
    c322v10 = gGameRules
    c322v9.gameRules = c322v10
    c322v8.questInfo = c322v9
    c322v8 = _G
    c322v9 = _T.questInfo
    c322v8.questInfo = c322v9
    c322v8 = IsNull
    c322v8 = c322v8(c322v2)
    if not c322v2 then
      c322v8 = c322v1:GetInventory()
      c322v9 = c322v8:GetQuestKeys()
      c322v10 = ipairs
      c322v10, c322v11, c322v12 = c322v10(c322v9)
      for c322v13, c322v14 in c322v10, c322v11, c322v12 do
        c322v15 = c322v14.mCompleted
        if not c322v15 then
          c322v15 = "New quests are available!"
          c322v16 = true
          do return c322v15, c322v16 end
        end
      end
      c322v10 = ""
      c322v11 = true
      do return c322v10, c322v11 end
    end
    if not c322v2 then
      local p81 = 14
      if p81 == 14 then
        c322v8 = IsNull
        c322v8 = c322v8(c322v2)
        if c322v8 then
        else
          p81 = 15
        end
      end
      if p81 == 15 then
        c322v8 = Localize
        c322v9 = tostring
        c322v9 = c322v9(c322v2:GetLocalizeTag())
        c322v10 = false
        c322v6 = c322v8(c322v9, c322v10)
        c322v10 = c322v3 - 1
        c322v8 = c322v2:Name__ce939156(c322v10)
        c322v9 = EMPTY_SYMBOL
        if c322v8 == c322v9 then
          p81 = 17
        else
          p81 = 16
        end
      end
      if p81 == 16 then
        c322v10 = "\r\n"
        c322v11 = Localize
        c322v12 = tostring
        c322v12 = c322v12(c322v8)
        c322v13 = false
        c322v11 = c322v11(c322v12, c322v13)
        c322v6 = c322v6 .. c322v10 .. c322v11
        p81 = 17
      end
      if p81 == 17 then
        if not c322v7 then
        else
          p81 = 18
        end
      end
      if p81 == 18 then
        c322v10 = gRegion
        c322v9 = IsNull
        c322v9 = c322v9(c322v10)
        if c322v9 then
        else
          p81 = 19
        end
      end
      if p81 == 19 then
        local e81_73 = -1
        repeat
          c322v11 = 1
          c322v12 = _T.QuestResetVars
          c322v9 = #c322v12
          c322v10 = 1
          for c322v11 = c322v11, c322v9, c322v10 do
            c322v12 = _T
            c322v14 = _T.QuestResetVars
            c322v13 = c322v14[c322v11]
            c322v14 = nil
            c322v12[c322v13] = c322v14
          end
          if e81_73 ~= -1 then break end
          c322v9 = _T
          c322v10 = {}
          c322v9.QuestResetVars = c322v10
          c322v9 = gRegion
          c322v9 = c322v9:GetLocalPlayer()
          c322v10 = IsNull
          c322v10 = c322v10(c322v9)
          if c322v10 then
            c322v10 = print
            c322v11 = "No local player yet, and this is kinda important"
            c322v10(c322v11)
            c322v10 = _T
            c322v11 = nil
            c322v10.questInfo = c322v11
            c322v10 = _G
            c322v11 = nil
            c322v10.questInfo = c322v11
            c322v10 = ""
            c322v11 = false
            do return c322v10, c322v11 end
          end
          c322v10 = vT[61]
          c322v10 = c322v10()
          if c322v10 then
            e81_73 = 25
          else
            e81_73 = 24
          end
          do break end
          break
        until true
        if e81_73 == 24 then
          p81 = 24
        elseif e81_73 == 25 then
          p81 = 25
        end
      end
      if p81 == 24 then
        c322v11 = gGameRules
        c322v11 = c322v11:InDojo()
        if c322v11 then
        else
          p81 = 25
        end
      end
      if p81 == 25 then
        if not c322v10 then
          p81 = 27
        else
          p81 = 26
        end
      end
      if p81 == 26 then
        c322v11 = print
        c322v12 = "Running RunOnPlayerSpawnedScriptsAfterIntro"
        c322v11(c322v12)
        c322v11 = gGameRules
        c322v11:RunOnPlayerSpawnedScriptsAfterIntro(c322v9)
        p81 = 38
      end
      if p81 == 27 then
        c322v11 = vT[56]
        c322v11 = c322v11()
        if c322v11 then
          p81 = 38
        else
          p81 = 28
        end
      end
      if p81 == 28 then
        c322v11 = gGameRules
        c322v13 = gLotusAttractModeGameRulesType
        c322v11 = c322v11:IsA(c322v13)
        if not c322v11 then
          p81 = 38
        else
          p81 = 29
        end
      end
      if p81 == 29 then
        c322v11 = true
        c322v12 = gGameRules
        c322v12 = c322v12:Name__736fe82d()
        c322v13 = 3
        if c322v12 ~= c322v13 then
          p81 = 36
        else
          p81 = 30
        end
      end
      if p81 == 30 then
        c322v12 = gGameData
        c322v14 = true
        c322v12 = c322v12:GetPlayerShip(c322v14)
        c322v12 = c322v12.mBootLocation
        c322v13 = 3
        if c322v12 == c322v13 then
          p81 = 36
        else
          p81 = 31
        end
      end
      if p81 == 31 then
        c322v12 = WeakResource
        c322v13 = "/Lotus/Types/Keys/1999Quest/1999QuestGoodEndKeyChain"
        c322v12 = c322v12(c322v13)
        c322v13 = true
        c322v14 = vT[34]
        if c322v2 == c322v14 then
          p81 = 35
        else
          p81 = 32
        end
      end
      if p81 == 32 then
        if c322v2 == c322v12 then
          p81 = 34
        else
          p81 = 33
        end
      end
      if p81 == 33 then
        c322v13 = false
        p81 = 35
      end
      if p81 == 34 then
        c322v13 = true
        p81 = 35
      end
      if p81 == 35 then
        c322v11 = c322v13
        p81 = 36
      end
      if p81 == 36 then
        if not c322v11 then
          p81 = 38
        else
          p81 = 37
        end
      end
      if p81 == 37 then
        c322v12 = gGameRules
        c322v12:Name__e36831ce(c322v9)
        p81 = 38
      end
      if p81 == 38 then
        c322v11 = vT[57]
        c322v11 = c322v11()
        c322v12 = IsNull
        c322v12 = c322v12(c322v11)
        if c322v12 then
        else
          p81 = 39
        end
      end
      if p81 == 39 then
        c322v11:Build()
      end
    end
    c322v8 = gFlashMgr
    c322v10 = "OnQuestsChanged"
    c322v11 = ""
    c322v8:Name__788d33f3(c322v10, c322v11)
    c322v9 = true
    do return c322v6, c322v9 end
  end
  UpdateQuests = vT[138]
  vT[138] = function()
    local c323v0, c323v1, c323v2, c323v3, c323v4, c323v5, c323v6, c323v7, c323v9, c323v10
    c323v0 = gPlayerProfileMgr
    c323v2 = 0
    c323v0 = c323v0:GetPlayerProfile(c323v2)
    c323v0 = c323v0:GetGameSpecificData()
    c323v1 = IsNull
    c323v1 = c323v1(c323v0)
    if c323v1 then
      c323v1 = false
      do return c323v1 end
    end
    c323v1 = vT[27]
    c323v2 = gGameData
    c323v1, c323v2, c323v3, c323v4 = c323v1(c323v2)
    c323v5 = IsNull
    c323v5 = c323v5(c323v1)
    if not ((c323v5 or not c323v4)) then
      c323v5 = WeakResource
      c323v6 = "/Lotus/Types/Keys/VorsPrize/VorsPrizeQuestKeyChain"
      c323v5 = c323v5(c323v6)
      if c323v1 == c323v5 then
        c323v5 = vT[131]
        c323v6 = gGameData
        c323v5 = c323v5(c323v6, c323v1)
        if c323v5 == 5 then
          c323v7 = c323v0:GetInventory()
          c323v9 = WeakResource
          c323v10 = "/Lotus/Types/Recipes/Components/VorBoltRemoverFakeItem"
          c323v7 = c323v7:Name__b6fefb70(c323v9(c323v10))
          c323v6 = not c323v7
          do return c323v6 end
        end
      end
    end
    c323v5 = false
    do return c323v5 end
  end
  vT[139] = function()
    local c324v0
    c324v0 = vT[138]
    do return c324v0() end
  end
  IsItemRequiredForActiveQuest = vT[139]
  vT[139] = function()
    local c325v0
    c325v0 = vT[16]
    do return c325v0 end
  end
  GetScanPointBones = vT[139]
  vT[139] = function()
    local c326v0, c326v1
    c326v1 = vT[16]
    c326v0 = #c326v1
    do return c326v0 end
  end
  MaxScanPointBones = vT[139]
  vT[139] = function(c327v0)
    local c327v1, c327v2, c327v3, c327v4, c327v5, c327v6, c327v11
    c327v2 = WeakResource
    c327v3 = "/EE/Types/Physics/FullBody"
    c327v2 = c327v2(c327v3)
    c327v3 = gBaseAvatarType
    c327v1 = {c327v2, c327v3}
    c327v2 = Vector
    c327v2 = c327v2()
    c327v3 = AngleToDirection
    c327v3 = c327v3(c327v0:GetCameraView())
    c327v4 = c327v0:InventoryControl()
    c327v4 = c327v4:GetAimEndPoint()
    c327v6 = c327v3 * 3
    c327v5 = c327v4 + c327v6
    c327v6 = gRegion
    c327v11 = nil
    do return c327v6:Name__35cdc568(c327v4, c327v5, c327v1, c327v11, c327v2) end
  end
  RayCastForScanPoints = vT[139]
  vT[139] = function(c328v0, c328v1, c328v2)
    local c328v3, c328v4, c328v5, c328v6, c328v7, c328v8, c328v9, c328v10
    c328v5 = #c328v3
    c328v6 = 0
    c328v7 = 1
    c328v5 = #c328v3
    c328v6 = 1
    for c328v7 = c328v7, c328v5, c328v6 do
      c328v9 = c328v3[c328v7]
      c328v9 = c328v9.mItemType
      c328v8 = IsNull
      c328v8 = c328v8(c328v9)
      if not c328v8 then
        c328v10 = c328v3[c328v7]
        c328v10 = c328v10.mItemType
        c328v8 = c328v2:Name__1dc35bd2(c328v10)
        c328v9 = IsNull
        c328v9 = c328v9(c328v8)
        if not c328v9 then
          c328v9 = table.insert
          c328v9(c328v4, c328v8)
        end
      end
    end
    c328v3 = {}
    c328v4 = {}
    c328v5 = 0
    if c328v0 == c328v5 then
      c328v3 = c328v1:GetSuits()
    else
      c328v5 = 3
      if c328v0 == c328v5 then
        c328v3 = c328v1:GetMelee()
      else
        c328v5 = 2
        if c328v0 == c328v5 then
          c328v3 = c328v1:GetLongGuns()
        else
          c328v5 = 1
          if c328v0 == c328v5 then
            c328v3 = c328v1:GetPistols()
          end
        end
      end
    end
    c328v5 = IsNull
    c328v5 = c328v5(c328v3)
    do return c328v4 end
  end
  vT[140] = function(c329v0, c329v1)
    local c329v2, c329v3, c329v4, c329v5, c329v6, c329v7, c329v8, c329v9, c329v10, c329v11, c329v12, c329v13, c329v14, c329v15, c329v18, c329v19
    c329v12 = c329v11.isSuit
    c329v12 = c329v11.isSuit
    c329v12 = vT[139]
    c329v13 = c329v11.Cat
    c329v12 = c329v12(c329v13, c329v0, c329v1)
    c329v13 = ipairs
    c329v13, c329v14, c329v15 = c329v13(c329v12)
    for c329v16, c329v17 in c329v13, c329v14, c329v15 do
      c329v18 = IsNull
      c329v18 = c329v18(c329v17)
      c329v18 = c329v17:Name__684d638f()
      c329v4 = c329v2 and c329v3
      c329v18 = c329v11.Cat
      c329v19 = 0
      if c329v18 == c329v19 then
        c329v2 = true
      else
        c329v3 = true
      end
      local p33 = 0
      if p33 == 0 then
        c329v2 = IsNull
        c329v2 = c329v2(c329v0)
        if c329v2 then
          p33 = 2
        else
          p33 = 1
        end
      end
      if p33 == 1 then
        c329v2 = IsNull
        c329v2 = c329v2(c329v1)
        if not c329v2 then
          p33 = 3
        else
          p33 = 2
        end
      end
      if p33 == 2 then
        c329v2 = false
        c329v3 = ""
        do return c329v2, c329v3 end
      end
      if p33 == 3 then
        c329v2 = false
        c329v3 = false
        c329v4 = false
        c329v5 = ""
        c329v7 = { Cat = nil, isSuit = true }
        c329v8 = 0
        c329v7.Cat = c329v8
        c329v8 = { Cat = nil, isSuit = false }
        c329v9 = 2
        c329v8.Cat = c329v9
        c329v9 = { Cat = nil, isSuit = false }
        c329v10 = 1
        c329v9.Cat = c329v10
        c329v10 = { Cat = nil, isSuit = false }
        c329v11 = 3
        c329v10.Cat = c329v11
        c329v6 = {c329v7, c329v8, c329v9, c329v10}
        c329v7 = ipairs
        c329v7, c329v8, c329v9 = c329v7(c329v6)
      end
    end
    if not c329v4 then
      c329v7 = ""
      if not c329v2 then
        c329v9 = "1x "
        c329v10 = Localize
        c329v11 = "/Lotus/Language/Menu/Global_ProductCategory_Suit"
        c329v12 = false
        c329v10 = c329v10(c329v11, c329v12)
        c329v7 = c329v7 .. c329v9 .. c329v10
        if not c329v3 then
          c329v9 = " + "
          c329v7 = c329v7 .. c329v9
        end
      end
      if not c329v3 then
        c329v9 = "1x "
        c329v10 = Localize
        c329v11 = "/Lotus/Language/Menu/Loadout_PVPCompatibleWeapon"
        c329v12 = false
        c329v10 = c329v10(c329v11, c329v12)
        c329v7 = c329v7 .. c329v9 .. c329v10
      end
      c329v8 = Localize
      c329v9 = "/Lotus/Language/Menu/Loadout_PVPNeedCompatibleGear"
      c329v10 = { REQ_GEAR = nil }
      c329v10.REQ_GEAR = c329v7
      c329v5 = c329v8(c329v9, c329v10)
    end
    do return c329v4, c329v5 end
  end
  HasPvpCompatibleGear = vT[140]
  vT[140] = function(c330v0, c330v1)
    local c330v2, c330v3, c330v7
    c330v2 = vT[17]
    c330v2 = c330v2.GetScreenDimensions
    c330v2, c330v3 = c330v2(c330v0)
    c330v7 = 14
    c330v0:SetNumberVariable(c330v1, c330v7, c330v2)
    c330v7 = 15
    c330v0:SetNumberVariable(c330v1, c330v7, c330v3)
    c330v7 = _G
    c330v7 = c330v7.UIMaterial_Bluer
    c330v0:OverrideMaterial(c330v1, c330v7)
    do return end
  end
  AdjustBluerSize = vT[140]
  vT[140] = function(c331v0, c331v1)
    local c331v2, c331v3, c331v4, c331v5, c331v6, c331v7
    c331v2 = gPlayerProfileMgr
    c331v4 = 0
    c331v2 = c331v2:GetPlayerProfile(c331v4)
    c331v3 = IsNull
    c331v3 = c331v3(c331v2)
    if c331v3 then
      c331v3 = 0
      c331v4 = 0
      c331v5 = 0
      do return c331v3, c331v4, c331v5 end
    end
    c331v3 = 0.3
    c331v4 = Engine.IsPlayingWithController
    c331v4 = c331v4()
    if c331v4 then
      c331v4 = 13
      c331v5 = c331v2:Settings()
      c331v7 = 3
      c331v5 = c331v5:Name__03431d9a(c331v7)
      c331v3 = c331v4 * c331v5
    end
    c331v4 = c331v2:Settings()
    c331v4 = c331v4:CameraInverted()
    if c331v4 then
      c331v1 = -c331v1
    end
    c331v4 = c331v0 * c331v3
    c331v5 = c331v1 * c331v3
    c331v6 = 0
    do return c331v4, c331v5, c331v6 end
  end
  GetInputCameraRotation = vT[140]
  vT[140] = function(c333v0)
    local c333v1, c333v2, c333v6
    c333v1 = IsNull
    c333v1 = c333v1(c333v0)
    if c333v1 then
      do return end
    end
    c333v1 = vT[41]
    c333v1 = c333v1()
    c333v2 = function(c332v0, c332v1)
      local c332v2
      if not c332v0 then
        do return end
      end
      c332v2 = gMatchingService
      c332v2:Name__a7450f20(c332v1)
      do return end
    end
    c333v1.ViewConsoleCallback = c333v2
    c333v2 = Engine.Name__3d4ef9f7
    c333v2 = c333v2()
    if c333v2 then
      c333v2 = gGameData
      c333v6 = "ViewConsoleCallback"
      c333v2:Name__819d11ac(c333v0, c333v6)
      do return end
    end
    c333v2 = gMatchingService
    c333v2:Name__a7450f20(c333v0)
    do return end
  end
  ViewConsoleProfile = vT[140]
  vT[140] = function()
    local c334v0, c334v1
    c334v0 = _T.ArsenalOpen
    if not c334v0 then
      c334v0 = _T.ArsenalUpgradeOpen
      if not c334v0 then
        c334v0 = _T.ModScreenOpen
      end
    end
    c334v1 = _T.AppearancePreviewOpen
    if c334v1 then
      c334v1 = 8
      do return c334v1 end
    end
    if c334v0 then
      c334v1 = 4
      do return c334v1 end
    end
    c334v1 = _T.PPSScreenOpen
    if c334v0 then
      c334v1 = _T.ProfileMenuOpen
      if not c334v1 then
        c334v1 = _T.OperatorScreenOpen
        if c334v1 then
          c334v1 = 10
          do return c334v1 end
        end
        c334v1 = _T.DecoratingPlayerShip
        if not c334v1 then
          c334v1 = _T.CustomizingPlayerShip
          if not c334v1 then
            c334v1 = _T.CustomizingCrewship
            if c334v1 then
              c334v1 = 12
              do return c334v1 end
            end
            c334v1 = _T.UIStyleScreenOpen
            if c334v1 then
              c334v1 = 13
              do return c334v1 end
            end
            c334v1 = _T.HUDColorScreenOpen
            if c334v1 then
              c334v1 = 14
              do return c334v1 end
            end
            c334v1 = _T.ChatLinkOpen
            if c334v1 then
              c334v1 = 15
              do return c334v1 end
            end
            c334v1 = _T.InventoryScreenOpen
            if c334v1 then
              c334v1 = 16
              do return c334v1 end
            end
            c334v1 = _T.InStarChart
            if c334v1 then
              c334v1 = 17
              do return c334v1 end
            end
            c334v1 = _T.IncubatorOpen
            if c334v1 then
              c334v1 = 19
              do return c334v1 end
            end
            c334v1 = _T.ShowingOmegaDiscardScreen
            if c334v1 then
              c334v1 = 20
              do return c334v1 end
            end
            c334v1 = _T.KaitheCustomizationOpen
            if c334v1 then
              c334v1 = 21
              do return c334v1 end
            end
            c334v1 = _T.IsDuviriWeaponPurchase
            if c334v1 then
              c334v1 = 22
              do return c334v1 end
            end
            c334v1 = _T.IsUpdateScreenOpen
            if c334v1 then
              c334v1 = 23
              do return c334v1 end
            end
            c334v1 = _T.MotorcycleCustomizationOpen
            if c334v1 then
              c334v1 = 24
              do return c334v1 end
            end
            c334v1 = 0
            do return c334v1 end
          end
        end
        c334v1 = 11
        do return c334v1 end
      end
    end
    c334v1 = 5
    do return c334v1 end
  end
  GetCurrentPurchaseSource = vT[140]
  vT[140] = function(c335v0, c335v1)
    local c335v2, c335v3, c335v4, c335v5, c335v6
    local p14 = 0
    if p14 == 0 then
      c335v2 = Engine.FindBuffsLoid
      c335v2 = c335v2()
      c335v3 = 0
      if c335v2 ~= c335v3 then
        p14 = 2
      else
        p14 = 1
      end
    end
    if p14 == 1 then
      do return end
    end
    if p14 == 2 then
      c335v3 = gPlayerProfileMgr
      c335v5 = 0
      c335v3 = c335v3:GetPlayerProfile(c335v5)
      c335v4 = c335v3:IsCrossSave()
      if c335v4 then
        p14 = 6
      else
        p14 = 3
      end
    end
    if p14 == 3 then
      if (c335v1 == nil or c335v2 == c335v1) then
        p14 = 9
      else
        p14 = 5
      end
    end
    if p14 == 5 then
      c335v4 = c335v3:Name__6c411c1f()
      if not c335v4 then
        p14 = 9
      else
        p14 = 6
      end
    end
    if p14 == 6 then
      c335v4 = {}
      c335v5 = c335v0.mExtraPurchaseInfoJson
      if c335v5 == "" then
        p14 = 8
      else
        p14 = 7
      end
    end
    if p14 == 7 then
      c335v5 = cjson.decode
      c335v6 = c335v0.mExtraPurchaseInfoJson
      c335v4 = c335v5(c335v6)
      p14 = 8
    end
    if p14 == 8 then
      c335v5 = c335v3:Name__f0880743()
      c335v4.MatchmakingBuildId = c335v5
      c335v5 = cjson.encode
      c335v5 = c335v5(c335v4)
      c335v0.mExtraPurchaseInfoJson = c335v5
      p14 = 9
    end
    if p14 == 9 then
      do return end
    end
  end
  AddMatchmakingLabelToPurchaseParams = vT[140]
  vT[140] = function(c336v0)
    local c336v1, c336v2, c336v3, c336v4, c336v5, c336v6
    c336v1 = gPlayerProfileMgr
    c336v3 = 0
    c336v1 = c336v1:GetPlayerProfile(c336v3)
    c336v2 = c336v1:IsCrossSave()
    if c336v2 then
      c336v4 = 40
      c336v5 = c336v1:Name__f0880743()
      c336v6 = 1
      c336v0:SellItem(c336v4, c336v5, c336v6)
    end
    do return end
  end
  AddMatchmakingLabelToSellOperation = vT[140]
  vT[29] = function(c337v0, c337v1)
    local c337v2, c337v3
    c337v3 = c337v0 * c337v1
    c337v2 = math.ceil
    c337v2 = c337v2(c337v3)
    c337v3 = c337v0 - c337v2
    do return c337v3 end
  end
  vT[140] = function(c338v0, c338v1)
    local c338v2
    c338v2 = vT[29]
    do return c338v2(c338v0, c338v1) end
  end
  GetPriceWithCoupon = vT[140]
  vT[28] = function(c339v0)
    local c339v1, c339v2, c339v3, c339v4, c339v5, c339v6, c339v7, c339v8, c339v9
    c339v2 = gGameData
    c339v1 = IsNull
    c339v1 = c339v1(c339v2)
    if not c339v1 then
      c339v1 = IsNull
      c339v1 = c339v1(c339v0)
      if not c339v1 then
        c339v2 = c339v0.StoreItem
        c339v1 = IsNull
        c339v1 = c339v1(c339v2)
        if not c339v1 then
          c339v1 = { mAmount = 0 }
          c339v0.Coupon = c339v1
          c339v1 = gGameData
          c339v1 = c339v1:Disableshowmove()
          c339v4 = 1
          c339v2 = #c339v1
          c339v3 = 1
          for c339v4 = c339v4, c339v2, c339v3 do
            c339v5 = c339v1[c339v4]
            c339v6 = Engine.Name__b38e1642
            c339v7 = c339v5.mExpiryDate
            c339v6 = c339v6(c339v7)
            c339v7 = 0
            c339v9 = c339v0.StoreItem
            c339v7 = c339v5:Name__68b7e3c7(c339v9)
            c339v7 = c339v0.StoreItem
            c339v7 = c339v7:IsSteamPurchase()
            if not c339v7 then break end
            if c339v6 <= c339v7 then
              c339v7 = c339v0.Coupon
              c339v9 = c339v5.mId
              c339v8 = tostring
              c339v8 = c339v8(c339v9)
              c339v7.mId = c339v8
              c339v7 = c339v0.Coupon
              c339v9 = c339v5.mAmount
              c339v8 = c339v9 / 100
              c339v7.mAmount = c339v8
              c339v7 = c339v0.Coupon
              c339v8 = c339v5.mExpiryDate
              c339v8 = c339v8.sec
              c339v7.mExpiry = c339v8
            end
          end
          c339v3 = gGameRules
          c339v2 = IsNull
          c339v2 = c339v2(c339v3)
          if not c339v2 then
            c339v2 = gGameRules
            c339v2 = c339v2:GetStoreManifest()
            c339v3 = IsNull
            c339v3 = c339v3(c339v2)
            if not c339v3 then
              c339v5 = c339v0.StoreItem
              c339v3 = c339v2:Name__6b727a06(c339v5)
              c339v4 = false
              if c339v3 ~= nil then
                c339v5 = c339v3.mSlot
                c339v6 = 17
                if c339v5 ~= c339v6 then
                  c339v4 = false
                else
                  c339v4 = true
                end
              end
              if c339v3 == nil then
                c339v5 = true
                c339v0.IsExternalPlat = c339v5
                c339v5 = gGameData
                c339v5 = c339v5:GetPendingCoupon()
                if c339v5 then
                  c339v6 = Engine.Name__b38e1642
                  c339v7 = c339v5.mExpiry
                  c339v6 = c339v6(c339v7)
                  c339v7 = 0
                  if c339v7 < c339v6 then
                    c339v7 = c339v0.Coupon
                    c339v8 = nil
                    c339v7.mId = c339v8
                    c339v7 = c339v0.Coupon
                    c339v8 = c339v5.mExpiry
                    c339v8 = c339v8.sec
                    c339v7.mExpiry = c339v8
                    c339v7 = c339v0.Coupon
                    c339v8 = c339v5.mCouponType
                    c339v7.mCouponType = c339v8
                    c339v7 = c339v5.mCouponType
                    c339v8 = 2
                    if c339v7 == c339v8 then
                      c339v7 = c339v0.Coupon
                      c339v8 = c339v5.mDiscount
                      c339v7.mDiscount = c339v8
                      c339v7 = c339v0.Coupon
                      c339v8 = c339v0.Coupon
                      c339v8 = c339v8.mDiscount
                      c339v7.mAmount = c339v8
                      do return end
                    end
                    c339v7 = c339v0.Coupon
                    c339v9 = c339v5.mDiscount
                    c339v8 = c339v9 / 100
                    c339v7.mDiscount = c339v8
                    c339v7 = c339v0.Coupon
                    c339v8 = c339v0.Coupon
                    c339v8 = c339v8.mDiscount
                    c339v7.mAmount = c339v8
                  end
                end
              end
            end
          end
          do return end
        end
      end
    end
    do return end
  end
  vT[140] = function(c340v0)
    local c340v1
    c340v1 = vT[28]
    do return c340v1(c340v0) end
  end
  PopulateCouponInfo = vT[140]
  vT[140] = function(c341v0, c341v1, c341v2, c341v3)
    local c341v4, c341v5, c341v6, c341v7, c341v8, c341v9, c341v10, c341v11, c341v12, c341v15, c341v16, c341v17, c341v18, c341v19, c341v20, c341v21, c341v23
    c341v9 = c341v0:GetStoreItemsOfType(c341v3)
    c341v10 = ipairs
    c341v10, c341v11, c341v12 = c341v10(c341v9)
    for c341v13, c341v14 in c341v10, c341v11, c341v12 do
      c341v15 = ResetLineCount
      c341v16 = 0
      c341v15(c341v16)
      c341v15 = IsNull
      c341v15 = c341v15(c341v14)
      c341v15 = c341v14:GetItem()
      c341v16 = IsNull
      c341v16 = c341v16(c341v15)
      c341v16 = c341v14:GetProductCategory()
      c341v17 = 10
      c341v16 = c341v14:AlwaysAvailable()
      c341v17 = IsNull
      c341v17 = c341v17(c341v6)
      c341v19 = 1
      c341v17 = #c341v6
      c341v18 = 1
      c341v20 = c341v6[c341v19]
      c341v20 = c341v20.mItemType
      c341v16 = true
      c341v17 = c341v14:ShowInMarket()
      c341v17 = false
      c341v20 = 1
      c341v18 = #c341v8
      c341v19 = 1
      c341v18 = _T.AccessibilityColorsAvailable
      c341v18 = _T.ExtraColorFilter
      c341v18 = _T.ExtraColorFilter
      c341v18 = c341v18(c341v14)
      c341v20 = { mStoreItem = nil, mOwned = nil, mIsAccessibility = nil }
      c341v20.mStoreItem = c341v14
      c341v20.mOwned = c341v16
      c341v20.mIsAccessibility = c341v17
      c341v18 = table.insert
      c341v18(c341v4, c341v20)
      c341v23 = c341v8[c341v20]
      c341v21 = c341v14:IsA(c341v23)
      if c341v21 then
        c341v17 = true
      end
      c341v8 = c341v7:GetInventory()
      c341v6 = c341v8:GetFlavourItems()
      c341v10 = 1
      c341v8 = #c341v6
      c341v9 = 1
      for c341v10 = c341v10, c341v8, c341v9 do
        c341v11 = c341v6[c341v10]
        c341v11 = c341v11.mItemType
        c341v13 = vT[3]
        c341v11 = c341v11:IsA(c341v13)
        if c341v11 then
          c341v5 = true
        end
      end
      c341v4 = {}
      c341v5 = false
      c341v6 = IsNull
      c341v6 = c341v6(c341v3)
      if c341v6 then
        c341v6 = WeakResource
        c341v7 = "/Lotus/Types/StoreItems/SuitCustomizations/GenericColorPicker"
        c341v3 = c341v6(c341v7)
      end
      c341v6 = nil
      c341v7 = gGameData
      c341v8 = IsNull
      c341v8 = c341v8(c341v7)
      c341v9 = WeakResource
      c341v10 = "/Lotus/StoreItems/Types/StoreItems/SuitCustomizations/ColourPickerAccessibilityItemA"
      c341v8 = {c341v9(c341v10)}
      c341v9 = IsNull
      c341v9 = c341v9(c341v0)
    end
    do return c341v4, c341v5 end
  end
  vT[141] = function(c342v0, c342v1, c342v2, c342v3)
    local c342v4
    c342v4 = vT[140]
    do return c342v4(c342v0, c342v1, c342v2, c342v3) end
  end
  GetAvailableColourPickers = vT[141]
  vT[141] = function(c343v0, c343v1, c343v2)
    local c343v3, c343v4, c343v5, c343v6, c343v7, c343v8, c343v9, c343v10, c343v11, c343v12, c343v13, c343v15
    c343v3 = IsNull
    c343v3 = c343v3(c343v1)
    if c343v3 then
      do return end
    end
    c343v3 = {}
    c343v4 = vT[140]
    c343v6 = true
    c343v7 = nil
    c343v4, c343v5 = c343v4(c343v0, c343v6, c343v7, c343v2)
    c343v6 = #c343v4
    if not c343v5 then
      c343v7 = IsNull
      c343v7 = c343v7(c343v2)
      if c343v7 then
        c343v6 = c343v6 + 1
      end
    end
    c343v7 = RandomInt
    c343v8 = 1
    c343v7 = c343v7(c343v8, c343v6)
    c343v8 = nil
    c343v9 = #c343v4
    if c343v7 <= c343v9 then
      c343v9 = Resource
      c343v10 = c343v4[c343v7]
      c343v10 = c343v10.mStoreItem
      c343v9 = c343v9(c343v10:GetItem())
      c343v3 = c343v9:Name__65bc6659()
      c343v10 = c343v4[c343v7]
      c343v8 = c343v10.mStoreItem
    end
    if c343v3 == nil then
      c343v3 = {}
    end
    c343v9 = #c343v3
    if c343v9 == 0 then
      c343v9 = c343v1:Name__65bc6659()
      c343v12 = 3
      c343v10 = #c343v9
      c343v11 = 5
      for c343v12 = c343v12, c343v10, c343v11 do
        c343v15 = c343v9[c343v12]
        c343v13 = table.insert
        c343v13(c343v3, c343v15)
      end
      c343v8 = nil
    end
    do return c343v3, c343v8 end
  end
  GetRandomColorPalette = vT[141]
  vT[141] = function(c344v0)
    local c344v1, c344v2, c344v3, c344v4, c344v5
    c344v1 = vT[134]
    c344v1 = c344v1(c344v0)
    c344v2 = 0
    c344v4 = gGameData
    c344v3 = IsNull
    c344v3 = c344v3(c344v4)
    if not c344v3 then
      c344v3 = gGameData
      c344v3 = c344v3:GetInventory()
      c344v5 = 5
      c344v2 = c344v3:GetBinMax(c344v5)
    end
    c344v5 = c344v1 + 1
    c344v4 = c344v5 + c344v2
    c344v5 = MAX_PVP_LOADOUTS
    c344v3 = math.min
    c344v3 = c344v3(c344v4, c344v5)
    do return c344v3 end
  end
  vT[142] = function(c345v0)
    local c345v1
    c345v1 = vT[141]
    do return c345v1(c345v0) end
  end
  GetPvPLoadoutCapacity = vT[142]
  vT[142] = function(c346v0, c346v1)
    local c346v2, c346v3, c346v4, c346v5, c346v6, c346v7, c346v8, c346v9
    c346v2 = c346v0:GetFullName()
    c346v3 = 0
    c346v4 = vT[103]
    c346v7 = vT[104]
    c346v4 = c346v4(c346v1, c346v2, c346v7)
    c346v7 = c346v4[1]
    c346v5 = c346v4[2]
    c346v6 = 1
    for c346v7 = c346v7, c346v5, c346v6 do
      c346v8 = c346v1[c346v7]
      c346v8 = c346v8.count
      if c346v8 then
        c346v8 = c346v1[c346v7]
        c346v8 = c346v8.count
        c346v3 = c346v3 + c346v8
      else
        c346v3 = c346v3 + 1
      end
      c346v8 = c346v4[1]
      c346v9 = c346v4[2]
    end
    do return c346v3 end
  end
  GetRecipesOwned = vT[142]
  vT[142] = function(c347v0, c347v1, c347v2, c347v3, c347v4)
    local c347v5, c347v6, c347v7, c347v8, c347v9, c347v10, c347v11, c347v12, c347v13, c347v14, c347v15, c347v16, c347v18, c347v19, c347v20, c347v21, c347v22, c347v23, c347v24, c347v26
    c347v5 = 0
    c347v6 = {}
    c347v7 = c347v2:IsPackage()
    c347v10 = gRecipeStoreItemType
    c347v8 = c347v2:IsA(c347v10)
    c347v9 = c347v2:GetItem()
    c347v10 = false
    c347v11 = false
    c347v12 = c347v2:GetPackageComponents()
    c347v13 = 0
    c347v14 = 0
    c347v15 = vT[52]
    c347v15 = c347v15(c347v2)
    c347v16 = true
    c347v19 = 1
    local c347v17 = #c347v12
    c347v18 = 1
    for c347v19 = c347v19, c347v17, c347v18 do
      c347v20 = c347v12[c347v19]
      c347v20 = c347v20.mTypeName
      c347v21 = IsNull
      c347v21 = c347v21(c347v20)
      if not c347v21 then
        c347v21 = c347v16
        if c347v21 then
          c347v22 = c347v20:GetProductCategory()
          c347v23 = 30
          if c347v22 ~= c347v23 then
            c347v21 = false
          else
            c347v21 = true
          end
        end
        c347v16 = c347v21
        c347v21 = vT[142]
        c347v21 = c347v21(c347v0, c347v1, c347v20, c347v3)
        c347v22 = vT[52]
        c347v22 = c347v22(c347v20)
        c347v23 = vT[99]
        c347v23 = c347v23(c347v20)
        if c347v23 then
          c347v23 = c347v20:IsPackage()
          if not c347v23 then
            c347v10 = true
            c347v23 = vT[110]
            c347v26 = true
            c347v23 = c347v23(c347v20, c347v3, c347v26)
            if c347v23 then
              c347v11 = true
            end
          end
        end
        if not c347v22 then
          c347v13 = c347v13 + 1
          c347v23 = 0
          if c347v23 < c347v21 then
            c347v14 = c347v14 + 1
          end
        end
      end
    end
    if not c347v7 then
      if c347v16 then
        c347v11 = true
      end
      c347v17 = c347v2:OneTimePurchasable()
      if not c347v16 then
        c347v17 = c347v1:Name__6d6f5521()
        c347v20 = 1
        c347v18 = #c347v17
        c347v19 = 1
        for c347v20 = c347v20, c347v18, c347v19 do
          c347v21 = c347v17[c347v20]
          c347v22 = c347v2:GetFullName()
          if c347v21 == c347v22 then break end
          if c347v21 == c347v22 then
            c347v21 = print
            c347v23 = c347v2:GetFullName()
            c347v24 = " OneTimePurchasable owned"
            c347v22 = c347v23 .. c347v24
            c347v21(c347v22)
            c347v5 = 1
          else
          end
        end
      else
        local p106 = 23
        if p106 == 23 then
          c347v17 = c347v2:GetProdId()
          if c347v17 == "" then
            p106 = 28
          else
            p106 = 24
          end
        end
        if p106 == 24 then
          c347v17 = c347v2:GetProdId()
          if c347v17 == "9999" then
            p106 = 28
          else
            p106 = 25
          end
        end
        if p106 == 25 then
          c347v17 = gGameData
          c347v17 = c347v17:IsExternalProductPurchased(c347v2:GetProdId())
          if (not c347v17 or c347v15) then
            p106 = 28
          else
            p106 = 27
          end
        end
        if p106 == 27 then
          c347v17 = print
          c347v19 = c347v2:GetFullName()
          c347v20 = " external product owned"
          c347v18 = c347v19 .. c347v20
          c347v17(c347v18)
          c347v5 = 1
        end
        if p106 == 28 then
          if (not c347v10 or c347v11) then
            p106 = 31
          else
            p106 = 30
          end
        end
        if p106 == 30 then
          c347v5 = 1
        end
        if p106 == 31 then
          if c347v11 then
            p106 = 35
          else
            p106 = 32
          end
        end
        if p106 == 32 then
          c347v17 = 0
          if (c347v13 <= c347v17 or c347v14 ~= c347v13) then
            p106 = 35
          else
            p106 = 34
          end
        end
        if p106 == 34 then
          c347v17 = print
          c347v19 = c347v2:GetFullName()
          c347v20 = " not proratable and own all single components owned"
          c347v18 = c347v19 .. c347v20
          c347v17(c347v18)
          c347v5 = 1
        end
        if p106 == 35 then
          c347v17 = GetStoreItemPriceObject
          c347v19 = nil
          c347v17 = c347v17(c347v2, c347v19, c347v3)
          c347v18 = c347v17.UsePrice
          if c347v18 ~= 0 then
          else
            p106 = 36
          end
        end
        if p106 == 36 then
          c347v18 = c347v17.UseOriginalPrice
          c347v19 = 0
          if c347v18 <= c347v19 then
          else
            p106 = 37
          end
        end
        if p106 == 37 then
          c347v18 = print
          c347v20 = c347v2:GetFullName()
          c347v21 = " prorated cost zero owned"
          c347v19 = c347v20 .. c347v21
          c347v18(c347v19)
          c347v5 = 1
        end
      end
    else
      local p114 = 38
      if p114 == 38 then
        c347v10 = ResetLineCount
        c347v10()
        c347v10 = c347v2:GetItemName()
        c347v11 = IsNull
        c347v11 = c347v11(c347v9)
        if c347v11 then
          p114 = 41
        else
          p114 = 39
        end
      end
      if p114 == 39 then
        c347v13 = gVoidProjectionItemType
        c347v11 = c347v9:IsA(c347v13)
        if not c347v11 then
          p114 = 41
        else
          p114 = 40
        end
      end
      if p114 == 40 then
        c347v11 = c347v10
        c347v12 = string.gsub
        c347v14 = "Bronze"
        c347v15 = ""
        c347v11 = c347v12(c347v11, c347v14, c347v15)
        c347v12 = string.gsub
        c347v14 = "Silver"
        c347v15 = ""
        c347v11 = c347v12(c347v11, c347v14, c347v15)
        c347v12 = string.gsub
        c347v14 = "Gold"
        c347v15 = ""
        c347v11 = c347v12(c347v11, c347v14, c347v15)
        c347v12 = string.gsub
        c347v14 = "Platinum"
        c347v15 = ""
        c347v11 = c347v12(c347v11, c347v14, c347v15)
        c347v15 = "Bronze"
        c347v13 = c347v11 .. c347v15
        c347v16 = "Silver"
        c347v14 = c347v11 .. c347v16
        c347v17 = "Gold"
        c347v15 = c347v11 .. c347v17
        c347v18 = "Platinum"
        c347v16 = c347v11 .. c347v18
        c347v10 = {c347v13, c347v14, c347v15, c347v16}
        p114 = 42
      end
      if p114 == 41 then
        c347v10 = {c347v10}
        p114 = 42
      end
      if p114 == 42 then
        c347v13 = 1
        c347v11 = #c347v10
        c347v12 = 1
        for c347v13 = c347v13, c347v11, c347v12 do
          c347v14 = vT[103]
          c347v16 = c347v10[c347v13]
          c347v17 = vT[104]
          c347v14 = c347v14(c347v3, c347v16, c347v17)
          c347v17 = c347v14[1]
          c347v15 = c347v14[2]
          c347v16 = 1
          for c347v17 = c347v17, c347v15, c347v16 do
            c347v19 = c347v14[1]
            c347v20 = c347v14[2]
            c347v18 = vT[17]
            c347v18 = c347v18.Ternary
            c347v20 = c347v3[c347v17]
            c347v20 = c347v20.count
            if c347v20 == nil then
              c347v19 = false
            else
              c347v19 = true
            end
            c347v20 = c347v3[c347v17]
            c347v20 = c347v20.count
            c347v21 = 1
            c347v18 = c347v18(c347v19, c347v20, c347v21)
            c347v5 = c347v5 + c347v18
            c347v19 = 0
            if c347v19 < c347v18 then
              c347v21 = { Count = nil, fp = nil }
              c347v21.Count = c347v18
              c347v22 = c347v3[c347v17]
              c347v22 = c347v22.fp
              c347v21.fp = c347v22
              c347v19 = table.insert
              c347v19(c347v6, c347v21)
            end
          end
        end
      end
    end
    if not c347v7 then
      c347v10 = c347v2:GetResultType()
      c347v11 = IsNull
      c347v11 = c347v11(c347v10)
      if not c347v11 then
        c347v13 = gKeyChainItemType
        c347v11 = c347v10:IsA(c347v13)
        if c347v11 then
          c347v11 = c347v1:GetQuestKeys()
          c347v14 = 1
          c347v12 = #c347v11
          c347v13 = 1
          for c347v14 = c347v14, c347v12, c347v13 do
            c347v16 = c347v11[c347v14]
            c347v15 = IsNull
            c347v15 = c347v15(c347v16)
            c347v15 = c347v11[c347v14]
            c347v15 = c347v15.mItemType
            if c347v15 == c347v10 then break end
            if c347v15 then
              c347v5 = 1
            end
          end
        end
      end
    end
    if c347v5 == 0 then
      c347v11 = gGameData
      c347v10 = IsNull
      c347v10 = c347v10(c347v11)
      if not c347v10 then
        c347v10 = c347v9
        if c347v8 then
          c347v10 = c347v2:GetResultType()
        end
        c347v11 = IsNull
        c347v11 = c347v11(c347v10)
        if not c347v11 then
          c347v13 = vT[8]
          c347v11 = c347v10:IsA(c347v13)
          if c347v11 then
            c347v11 = gGameData
            c347v11 = c347v11:HasShipFeature(c347v10)
            if c347v11 then
              c347v5 = 1
            end
          end
        end
      end
    end
    c347v10 = IsNull
    c347v10 = c347v10(c347v9)
    if not c347v10 then
      c347v12 = WeakResource
      c347v13 = "/Lotus/Types/StoreItems/SlotItems/PvPLoadoutSlotItem"
      c347v10 = c347v9:IsA(c347v12(c347v13))
      if c347v10 then
        c347v10 = vT[141]
        c347v11 = _T.ShowSyndicate
        c347v5 = c347v10(c347v11)
      end
    end
    if c347v4 then
      do return c347v6 end
    end
    do return c347v5 end
  end
  vT[143] = function(c348v0, c348v1, c348v2, c348v3, c348v4)
    local c348v5
    c348v5 = vT[142]
    c348v5 = c348v5(c348v0, c348v1, c348v2, c348v3, c348v4)
    do return c348v5 end
  end
  GetNumOwned = vT[143]
  vT[143] = function(c349v0)
    local c349v1, c349v2, c349v3, c349v4, c349v5, c349v6, c349v7, c349v9, c349v10
    c349v1 = c349v0:GetFullName()
    c349v2 = string.find
    c349v4 = "_"
    c349v2 = c349v2(c349v1, c349v4)
    c349v3 = string.find
    c349v5 = "x"
    c349v3 = c349v3(c349v1, c349v5, c349v2)
    c349v4 = string.find
    c349v6 = "%."
    c349v4 = c349v4(c349v1, c349v6, c349v3)
    c349v5 = 1
    c349v6 = 1
    if not ((not c349v2 or not c349v3)) then
      if not (((not c349v4 or c349v4 <= c349v3) or c349v3 <= c349v2)) then
        c349v9 = c349v2 + 1
        c349v10 = c349v3 - 1
        c349v7 = string.sub
        c349v5 = c349v7(c349v1, c349v9, c349v10)
        c349v9 = c349v3 + 1
        c349v10 = c349v4 - 1
        c349v7 = string.sub
        c349v6 = c349v7(c349v1, c349v9, c349v10)
      end
    end
    do return c349v5, c349v6 end
  end
  GetImageDimansionsFromName = vT[143]
  vT[143] = function(c350v0, c350v1)
    local c350v2, c350v3, c350v4, c350v5, c350v6, c350v7, c350v8, c350v9
    c350v2 = IsNull
    c350v2 = c350v2(c350v0)
    if c350v2 then
      c350v2 = false
      do return c350v2 end
    end
    c350v2 = true
    c350v3 = c350v0:GetBinMax(c350v1)
    c350v4 = 0
    c350v5 = 0
    if not c350v2 then
      c350v5 = c350v0:GetSuits()
      c350v4 = #c350v5
    else
      c350v5 = 1
      if c350v1 == c350v5 then
        c350v4 = c350v0:GetWeaponCount()
      else
        c350v5 = 2
        if c350v1 == c350v5 then
          c350v8 = c350v0:GetSentinels()
          c350v7 = #c350v8
          c350v9 = c350v0:GetSentinelWeapons()
          c350v8 = #c350v9
          c350v6 = c350v7 + c350v8
          c350v8 = c350v0:GetMoaPets()
          c350v7 = #c350v8
          c350v5 = c350v6 + c350v7
          c350v7 = c350v0:GetKubrowPets()
          c350v6 = #c350v7
          c350v4 = c350v5 + c350v6
        else
          c350v5 = 3
          if c350v1 == c350v5 then
            c350v5 = c350v0:GetSpaceSuits()
            c350v4 = #c350v5
          else
            c350v5 = 4
            if c350v1 == c350v5 then
              c350v6 = c350v0:GetSpaceGuns()
              c350v5 = #c350v6
              c350v7 = c350v0:GetSpaceMelee()
              c350v6 = #c350v7
              c350v4 = c350v5 + c350v6
            else
              c350v5 = 8
              if c350v1 == c350v5 then
                c350v5 = c350v0:GetOperatorAmps()
                c350v4 = #c350v5
              else
                c350v5 = 9
                if c350v1 == c350v5 then
                  c350v6 = c350v0:GetCrewShipWeapons()
                  c350v5 = #c350v6
                  c350v7 = c350v0:GetCrewShipWeaponSkins()
                  c350v6 = #c350v7
                  c350v4 = c350v5 + c350v6
                else
                  c350v5 = 10
                  if c350v1 == c350v5 then
                    c350v5 = c350v0:GetMechSuits()
                    c350v4 = #c350v5
                  else
                    c350v5 = 11
                    if c350v1 ~= c350v5 then
                      c350v5 = print
                      c350v7 = "Unsupported bin type!"
                      c350v8 = tostring
                      c350v8 = c350v8(c350v1)
                      c350v6 = c350v7 .. c350v8
                      c350v5(c350v6)
                      c350v5 = false
                      do return c350v5 end
                    end
                    c350v5 = c350v0:GetCrewMembers()
                    c350v4 = #c350v5
                  end
                end
              end
            end
          end
        end
      end
    end
    c350v5 = c350v3 - c350v4
    c350v6 = 0
    if c350v5 < c350v6 then
      c350v2 = false
    end
    do return c350v2 end
  end
  VerifyInventorySlots = vT[143]
  vT[143] = function(c351v0)
    local c351v1, c351v2, c351v3, c351v4, c351v5
    c351v1 = Engine.DialogSettings
    c351v1 = c351v1()
    c351v2 = vT[17]
    c351v2 = c351v2.Ternary
    c351v3 = Engine.IsConsole
    c351v3 = c351v3()
    c351v4 = 0
    c351v5 = 1
    c351v2 = c351v2(c351v3, c351v4, c351v5)
    c351v1.dialogType = c351v2
    c351v2 = "/Lotus/Language/Menu/Slot_InvalidBinError"
    c351v1.locString = c351v2
    c351v2 = "/Lotus/Language/Menu/ContactSupport"
    c351v1.secondString = c351v2
    if c351v0 ~= nil then
      c351v1:SetCallback(c351v0)
    end
    c351v2 = gClient
    c351v2 = c351v2:GetOverlayMgr()
    c351v2:ShowDialog(c351v1)
    do return end
  end
  ShowInvalidBinError = vT[143]
  vT[143] = function(c352v0)
    local c352v1, c352v2
    c352v1 = tonumber
    c352v1 = c352v1(c352v0)
    if c352v1 == 25 then
      c352v1 = vT[17]
      c352v1 = c352v1.ShowMessage
      c352v2 = "/Lotus/Language/Store/PurchaseFailSlotLimit"
      c352v1(c352v2)
      do return end
    end
    c352v1 = vT[17]
    c352v1 = c352v1.ShowMessage
    c352v2 = "/Lotus/Language/Menu/PurchaseFailure"
    c352v1(c352v2)
    do return end
  end
  HandleBinExpansionPurchaseFailure = vT[143]
  vT[143] = function(c353v0)
    local c353v1, c353v2
    c353v1 = tonumber
    c353v1 = c353v1(c353v0)
    c353v2 = 4
    if c353v1 ~= c353v2 then
      c353v1 = Engine.IsConsole
      c353v1 = c353v1()
      if not c353v1 then
        c353v1 = Engine.STACKSFollies
        c353v1 = c353v1()
        if c353v1 then
          c353v1 = vT[17]
          c353v1 = c353v1.DoOpenWebBrowser
          c353v2 = "https://kf.qq.com/bills/200901selfsam4979ae6.html"
          c353v1(c353v2)
          do return end
        end
        c353v1 = vT[17]
        c353v1 = c353v1.DoOpenWebBrowser
        c353v2 = "https://digitalextremes.zendesk.com"
        c353v1(c353v2)
      end
    end
    do return end
  end
  HandleInvalidBinErrorResponse = vT[143]
  vT[143] = function(c354v0)
    local c354v1, c354v2
    c354v1 = c354v0.Sale
    if c354v1 ~= nil then
      c354v1 = c354v0.Sale
      c354v1 = c354v1.mProductExpiryOverride
      if c354v1 ~= nil then
        c354v1 = c354v0.Sale
        c354v1 = c354v1.mProductExpiryOverride
        c354v1 = c354v1.sec
        if c354v1 ~= "" then
          c354v1 = Engine.Name__b38e1642
          c354v2 = c354v0.Sale
          c354v2 = c354v2.mProductExpiryOverride
          do return c354v1(c354v2) end
        end
      end
    end
    c354v1 = Engine.Name__b38e1642
    c354v2 = c354v0.StoreItem
    do return c354v1(c354v2:GetExpiryDate()) end
  end
  GetProductTimeLeft = vT[143]
  vT[143] = function(c355v0)
    local c355v1, c355v2, c355v3
    c355v1 = c355v0.Sale
    if c355v1 ~= nil then
      c355v1 = c355v0.Sale
      c355v1 = c355v1.mProductExpiryOverride
      if c355v1 ~= nil then
        c355v1 = c355v0.Sale
        c355v1 = c355v1.mProductExpiryOverride
        c355v1 = c355v1.sec
        if c355v1 ~= "" then
          c355v2 = Engine.Name__b38e1642
          c355v3 = c355v0.Sale
          c355v3 = c355v3.mProductExpiryOverride
          c355v2 = c355v2(c355v3)
          c355v3 = 0
          if c355v3 <= c355v2 then
            c355v1 = false
          else
            c355v1 = true
          end
          do return c355v1 end
        end
      end
    end
    c355v1 = c355v0.StoreItem
    c355v1 = c355v1:GetExpiryDate()
    if c355v1 ~= 0 then
      c355v1 = Engine.Name__b38e1642
      c355v2 = c355v0.StoreItem
      c355v1 = c355v1(c355v2:GetExpiryDate())
      c355v2 = 0
      if c355v1 <= c355v2 then
        c355v1 = true
        do return c355v1 end
      end
    end
    c355v1 = false
    do return c355v1 end
  end
  IsProductExpired = vT[143]
  vT[143] = {}
  vT[144] = 0
  vT[145] = { Icon = "", Ability = "", Lens = "", Polarity = "" }
  vT[143][vT[144]] = vT[145]
  vT[144] = 1
  vT[145] = { Icon = "FocusLensMadurai.png", Ability = "/Lotus/Upgrades/Focus/Attack/AttackFocusAbility", Ultimate = "/Lotus/Powersuits/PowersuitAbilities/OperatorAttackUltimateAbility", UltimateDiorama = nil, Lens = "MADURAI", Polarity = "/Lotus/Language/TennoWay/Madurai" }
  vT[146] = WeakResource
  vT[147] = "/Lotus/Levels/Lore/AttackAntiquePreview.level"
  vT[146] = vT[146](vT[147])
  vT[145].UltimateDiorama = vT[146]
  vT[143][vT[144]] = vT[145]
  vT[144] = 2
  vT[145] = { Icon = "FocusLensVazarin.png", Ability = "/Lotus/Upgrades/Focus/Defense/DefenseFocusAbility", Ultimate = "/Lotus/Powersuits/PowersuitAbilities/OperatorDefenseUltimateAbility", UltimateDiorama = nil, Lens = "VAZARIN", Polarity = "/Lotus/Language/TennoWay/Vazarin" }
  vT[146] = WeakResource
  vT[147] = "/Lotus/Levels/Lore/DefenseAntiquePreview.level"
  vT[146] = vT[146](vT[147])
  vT[145].UltimateDiorama = vT[146]
  vT[143][vT[144]] = vT[145]
  vT[144] = 3
  vT[145] = { Icon = "FocusLensNaramon.png", Ability = "/Lotus/Upgrades/Focus/Tactic/TacticFocusAbility", Ultimate = "/Lotus/Powersuits/PowersuitAbilities/OperatorTacticUltimateAbility", UltimateDiorama = nil, Lens = "NARAMON", Polarity = "/Lotus/Language/TennoWay/Naramon" }
  vT[146] = WeakResource
  vT[147] = "/Lotus/Levels/Lore/TacticAntiquePreview.level"
  vT[146] = vT[146](vT[147])
  vT[145].UltimateDiorama = vT[146]
  vT[143][vT[144]] = vT[145]
  vT[144] = 4
  vT[145] = { Icon = "FocusLensZenurik.png", Ability = "/Lotus/Upgrades/Focus/Power/PowerFocusAbility", Ultimate = "/Lotus/Powersuits/PowersuitAbilities/OperatorPowerUltimateAbility", UltimateDiorama = nil, Lens = "ZENURIK", Polarity = "/Lotus/Language/TennoWay/Zenurik" }
  vT[146] = WeakResource
  vT[147] = "/Lotus/Levels/Lore/PowerAntiquePreview.level"
  vT[146] = vT[146](vT[147])
  vT[145].UltimateDiorama = vT[146]
  vT[143][vT[144]] = vT[145]
  vT[144] = 5
  vT[145] = { Icon = "", Ability = "", Lens = "", Polarity = "" }
  vT[143][vT[144]] = vT[145]
  vT[144] = 6
  vT[145] = { Icon = "", Ability = "", Lens = "", Polarity = "" }
  vT[143][vT[144]] = vT[145]
  vT[144] = 7
  vT[145] = { Icon = "FocusLensUnairu.png", Ability = "/Lotus/Upgrades/Focus/Ward/WardFocusAbility", Ultimate = "/Lotus/Powersuits/PowersuitAbilities/OperatorWardUltimateAbility", UltimateDiorama = nil, Lens = "UNAIRU", Polarity = "/Lotus/Language/TennoWay/Unairu" }
  vT[146] = WeakResource
  vT[147] = "/Lotus/Levels/Lore/WardAntiquePreview.level"
  vT[146] = vT[146](vT[147])
  vT[145].UltimateDiorama = vT[146]
  vT[143][vT[144]] = vT[145]
  vT[144] = 8
  vT[145] = { Icon = "", Ability = "", Lens = "", Polarity = "" }
  vT[143][vT[144]] = vT[145]
  vT[144] = 9
  vT[145] = { Icon = "", Ability = "", Lens = "", Polarity = "" }
  vT[143][vT[144]] = vT[145]
  vT[144] = function(c356v0, c356v1, c356v2)
    local c356v3, c356v4, c356v5, c356v6, c356v7, c356v8, c356v9, c356v10, c356v11, c356v12, c356v13, c356v14, c356v15
    c356v3 = 0
    c356v4 = IsNull
    c356v4 = c356v4(c356v1)
    if c356v4 then
      c356v1 = false
    end
    c356v4 = IsNull
    c356v4 = c356v4(c356v2)
    if c356v4 then
      c356v2 = false
    end
    c356v4 = _G
    c356v4 = c356v4.UIMaterial_FocusLens
    if c356v1 then
      c356v5 = vT[17]
      c356v5 = c356v5.Ternary
      c356v7 = _G
      c356v7 = c356v7.UIMaterial_FocusLensStoreDepth
      c356v8 = _G
      c356v8 = c356v8.UIMaterial_FocusLensStore
      c356v4 = c356v5(c356v2, c356v7, c356v8)
    end
    c356v5 = c356v0
    c356v6 = IsWeak
    c356v6 = c356v6(c356v5)
    if c356v6 then
      c356v6 = Resource
      c356v5 = c356v6(c356v5)
    end
    c356v6 = ""
    c356v7 = 1
    c356v8 = IsNull
    c356v8 = c356v8(c356v5)
    if not c356v4 then
      c356v8 = c356v5:GetFocusXpDistributions()
      c356v11 = 1
      c356v14 = vT[143]
      c356v13 = #c356v14
      c356v14 = #c356v8
      c356v12 = math.min
      c356v9 = c356v12(c356v13, c356v14)
      c356v10 = 1
      for c356v11 = c356v11, c356v9, c356v10 do
        c356v12 = c356v8[c356v11]
        c356v13 = 0
        if c356v13 < c356v12 then break end
        if c356v13 < c356v12 then
          c356v3 = c356v11 - 1
        end
      end
      c356v12 = vT[2]
      c356v11 = #c356v12
      c356v9 = 1
      c356v10 = -1
      c356v15 = vT[2]
      c356v14 = c356v15[c356v11]
      c356v14 = c356v14.Type
      c356v12 = c356v5:IsA(c356v14)
      if c356v12 then
        c356v7 = c356v11
        c356v13 = vT[2]
        c356v12 = c356v13[c356v11]
        c356v6 = c356v12.Affix
      end
    end
    c356v9 = vT[143]
    c356v8 = c356v9[c356v3]
    c356v9 = { PolarityTag = nil, LensTag = nil, LensQuality = nil, LensTier = nil, Material = nil, PolarityType = nil }
    c356v10 = c356v8.Polarity
    c356v9.PolarityTag = c356v10
    c356v11 = "<"
    c356v12 = c356v8.Lens
    c356v14 = ">"
    c356v10 = c356v11 .. c356v12 .. c356v6 .. c356v14
    c356v9.LensTag = c356v10
    c356v9.LensQuality = c356v6
    c356v9.LensTier = c356v7
    c356v10 = c356v4[c356v3]
    c356v9.Material = c356v10
    c356v9.PolarityType = c356v3
    do return c356v9 end
  end
  GetPolarityInfoForLens = vT[144]
  vT[144] = function(c357v0)
    local c357v1, c357v2
    c357v2 = vT[143]
    c357v1 = c357v2[c357v0]
    do return c357v1 end
  end
  GetWayInfo = vT[144]
  vT[144] = function(c358v0, c358v1)
    local c358v2, c358v3, c358v4, c358v5, c358v6, c358v7, c358v8, c358v9, c358v10, c358v11, c358v12, c358v13
    c358v3 = gRegion
    c358v2 = IsNull
    c358v2 = c358v2(c358v3)
    if c358v2 then
      do return end
    end
    c358v2 = gRegion
    c358v2 = c358v2:GetLocalPlayer()
    c358v3 = IsNull
    c358v3 = c358v3(c358v2)
    if c358v3 then
      do return end
    end
    c358v3 = vT[17]
    c358v3 = c358v3.Ternary
    c358v4 = IsNull
    c358v4 = c358v4(c358v1)
    c358v5 = c358v2:GetOperatorAvatar()
    c358v3 = c358v3(c358v4, c358v5, c358v1)
    c358v4 = IsNull
    c358v4 = c358v4(c358v3)
    if c358v4 then
      do return end
    end
    c358v4 = Symbol
    c358v5 = "GAME_R1_EYE1"
    c358v4 = c358v4(c358v5)
    c358v5 = Symbol
    c358v6 = "GAME_L1_EYE1"
    c358v5 = c358v5(c358v6)
    c358v6 = Symbol
    c358v7 = "GAME_C1_HEAD1"
    c358v6 = c358v6(c358v7)
    c358v10 = false
    c358v3:Name__c92bf129(c358v4, c358v10)
    c358v10 = false
    c358v3:Name__c92bf129(c358v5, c358v10)
    c358v7 = _T.OperatorEyeTrack
    if not c358v2 then
      c358v9 = 0
      c358v11 = c358v7.LerpAmount
      c358v13 = DeltaTime
      c358v13 = c358v13()
      c358v12 = c358v13 * 3
      c358v10 = c358v11 - c358v12
      c358v8 = math.max
      c358v8 = c358v8(c358v9, c358v10)
      c358v7.LerpAmount = c358v8
      if c358v0 then
        c358v8 = 0
        c358v7.LerpAmount = c358v8
      end
      c358v8 = LerpRotation
      c358v9 = c358v7.InitialRot
      c358v10 = c358v7.FinalRot
      c358v11 = c358v7.LerpAmount
      c358v8 = c358v8(c358v9, c358v10, c358v11)
      c358v3:SetBoneDirector(c358v6, c358v8)
      c358v9 = c358v7.LerpAmount
      if c358v9 == 0 then
        c358v12 = false
        c358v3:Name__c92bf129(c358v6, c358v12)
        do return end
      end
    else
      c358v11 = false
      c358v3:Name__c92bf129(c358v6, c358v11)
    end
    do return end
  end
  ClearOperatorLookAt = vT[144]
  vT[144] = function(c359v0, c359v1, c359v2, c359v3)
    local c359v4, c359v5, c359v6, c359v7, c359v8, c359v9, c359v10, c359v11, c359v12, c359v13, c359v14, c359v15, c359v16, c359v17, c359v18, c359v19, c359v20, c359v21, c359v22, c359v23, c359v24, c359v25, c359v26
    c359v5 = gRegion
    c359v4 = IsNull
    c359v4 = c359v4(c359v5)
    if c359v4 then
      do return end
    end
    c359v4 = gRegion
    c359v4 = c359v4:GetLocalPlayer()
    c359v5 = IsNull
    c359v5 = c359v5(c359v4)
    if c359v5 then
      do return end
    end
    c359v5 = vT[17]
    c359v5 = c359v5.Ternary
    c359v6 = IsNull
    c359v6 = c359v6(c359v2)
    c359v7 = c359v4:GetOperatorAvatar()
    c359v5 = c359v5(c359v6, c359v7, c359v2)
    c359v6 = IsNull
    c359v6 = c359v6(c359v5)
    if c359v6 then
      do return end
    end
    c359v6 = _T.defaultOperatorRot
    if c359v3 then
      c359v7 = Rotation
      c359v8 = 45
      c359v9 = 0
      c359v10 = 0
      c359v6 = c359v7(c359v8, c359v9, c359v10)
    end
    c359v7 = Symbol
    c359v8 = "GAME_R1_EYE1"
    c359v7 = c359v7(c359v8)
    c359v8 = Symbol
    c359v9 = "GAME_R1_EYE1"
    c359v8 = c359v8(c359v9)
    c359v9 = Symbol
    c359v10 = "GAME_L1_EYE1"
    c359v9 = c359v9(c359v10)
    c359v10 = Symbol
    c359v11 = "GAME_C1_HEAD1"
    c359v10 = c359v10(c359v11)
    c359v11 = _T.OperatorEyeTrack
    if c359v11 == nil then
      c359v11 = _T
      c359v12 = { X = nil, Y = nil, InitialRot = nil, FinalRot = nil, LerpAmount = 0 }
      c359v13 = SmoothFloat
      c359v14 = 0
      c359v15 = 0.15
      c359v13 = c359v13(c359v14, c359v15)
      c359v12.X = c359v13
      c359v13 = SmoothFloat
      c359v14 = 0
      c359v15 = 0.15
      c359v13 = c359v13(c359v14, c359v15)
      c359v12.Y = c359v13
      c359v13 = c359v5:GetBoneRotation(c359v7)
      c359v12.InitialRot = c359v13
      c359v13 = Rotation
      c359v13 = c359v13()
      c359v12.FinalRot = c359v13
      c359v11.OperatorEyeTrack = c359v12
      c359v11 = _T.OperatorEyeTrack.InitialRot
      c359v13 = _T.OperatorEyeTrack.InitialRot
      c359v13 = c359v13.pitch
      c359v12 = c359v13 - 12
      c359v11.pitch = c359v12
      c359v11 = IsNull
      c359v11 = c359v11(c359v6)
      if not c359v11 then
        c359v11 = _T.OperatorEyeTrack.InitialRot
        c359v13 = _T.OperatorEyeTrack.InitialRot
        c359v13 = c359v13.heading
        c359v14 = c359v6.heading
        c359v12 = c359v13 - c359v14
        c359v11.heading = c359v12
      end
    end
    c359v11 = gRegion
    c359v11 = c359v11:GetGameCamera()
    c359v12 = c359v0:GetCursorX()
    if c359v1 ~= nil then
      c359v12 = c359v1.x
    end
    c359v13 = c359v0:GetCursorY()
    if c359v1 ~= nil then
      c359v13 = c359v1.y
    end
    c359v17 = c359v0:GetViewportWidth()
    c359v16 = c359v12 / c359v17
    c359v15 = c359v16 * 2
    c359v14 = c359v15 - 1
    c359v18 = c359v0:GetViewportHeight()
    c359v17 = c359v13 / c359v18
    c359v16 = c359v17 * 2
    c359v15 = c359v16 - 1
    c359v17 = Noise
    c359v19 = Time
    c359v19 = c359v19()
    c359v18 = c359v19 * 0.1
    c359v17 = c359v17(c359v18)
    c359v16 = c359v17 * 0.1
    c359v14 = c359v14 + c359v16
    c359v17 = Noise
    c359v19 = 7
    c359v21 = Time
    c359v21 = c359v21()
    c359v20 = c359v21 * 0.1
    c359v18 = c359v19 + c359v20
    c359v17 = c359v17(c359v18)
    c359v16 = c359v17 * 0.1
    c359v15 = c359v15 + c359v16
    c359v16 = _T.OperatorEyeTrack.X
    c359v16:SetTargetVal(c359v14)
    c359v16 = _T.OperatorEyeTrack.Y
    c359v16:SetTargetVal(c359v15)
    c359v16 = _T.OperatorEyeTrack.X
    c359v18 = DeltaTime
    c359v16:Update(c359v18())
    c359v16 = _T.OperatorEyeTrack.Y
    c359v18 = DeltaTime
    c359v16:Update(c359v18())
    c359v16 = Vector
    c359v18 = _T.OperatorEyeTrack.X
    c359v18 = c359v18:GetVal()
    c359v17 = c359v18 * 0.3
    c359v19 = 0.025
    c359v21 = _T.OperatorEyeTrack.Y
    c359v21 = c359v21:GetVal()
    c359v20 = c359v21 * 0.1
    c359v18 = c359v19 + c359v20
    c359v19 = 0
    c359v16 = c359v16(c359v17, c359v18, c359v19)
    c359v17 = IsNull
    c359v17 = c359v17(c359v6)
    if not c359v17 then
      c359v17 = RotateVector
      c359v16 = c359v17(c359v16, c359v6)
    end
    c359v18 = c359v11:GetPosition()
    c359v17 = c359v18 - c359v16
    c359v18 = c359v5:GetBonePosition(c359v7)
    c359v19 = LookTo
    c359v19 = c359v19(c359v18, c359v17)
    c359v20 = IsNull
    c359v20 = c359v20(c359v6)
    if not c359v20 then
      c359v21 = c359v19.heading
      c359v22 = c359v6.heading
      c359v20 = c359v21 - c359v22
      c359v19.heading = c359v20
    end
    c359v20 = LookTo
    c359v20 = c359v20(c359v18, c359v17)
    c359v21 = IsNull
    c359v21 = c359v21(c359v6)
    if not c359v21 then
      c359v22 = c359v20.heading
      c359v23 = c359v6.heading
      c359v21 = c359v22 - c359v23
      c359v20.heading = c359v21
    end
    c359v21 = Clamp
    c359v22 = c359v20.heading
    c359v23 = -10
    c359v24 = 10
    c359v21 = c359v21(c359v22, c359v23, c359v24)
    c359v20.heading = c359v21
    c359v5:Name__ede6df8b(c359v8, c359v20)
    c359v5:Name__ede6df8b(c359v9, c359v20)
    c359v24 = true
    c359v5:Name__c92bf129(c359v8, c359v24)
    c359v24 = true
    c359v5:Name__c92bf129(c359v9, c359v24)
    c359v24 = true
    c359v5:Name__c92bf129(c359v10, c359v24)
    c359v22 = c359v19.pitch
    c359v21 = c359v22 - 15
    c359v19.pitch = c359v21
    c359v21 = _T.OperatorEyeTrack
    c359v23 = 1
    c359v25 = _T.OperatorEyeTrack.LerpAmount
    c359v26 = DeltaTime
    c359v26 = c359v26()
    c359v24 = c359v25 + c359v26
    c359v22 = math.min
    c359v22 = c359v22(c359v23, c359v24)
    c359v21.LerpAmount = c359v22
    c359v21 = LerpRotation
    c359v22 = _T.OperatorEyeTrack.InitialRot
    c359v24 = _T.OperatorEyeTrack.LerpAmount
    c359v21 = c359v21(c359v22, c359v19, c359v24)
    c359v22 = _T.OperatorEyeTrack
    c359v22.FinalRot = c359v21
    c359v5:SetBoneDirector(c359v10, c359v21)
    c359v23 = _T.TennoSpeaking
    c359v22 = IsNull
    c359v22 = c359v22(c359v23)
    if not c359v22 then
      c359v24 = _T.TennoSpeaking
      c359v5:Name__eb295caa(c359v24)
    end
    do return end
  end
  UpdateOperatorLookAt = vT[144]
  vT[144] = function(c360v0)
    local c360v1, c360v2, c360v3, c360v5
    local p22 = 0
    if p22 == 0 then
      c360v3 = gStoreItemType
      c360v1 = c360v0:IsA(c360v3)
      if not c360v1 then
        p22 = 3
      else
        p22 = 1
      end
    end
    if p22 == 1 then
      c360v3 = 7
      c360v1 = c360v0:Name__3ec9e37b(c360v3)
      if c360v1 then
        p22 = 3
      else
        p22 = 2
      end
    end
    if p22 == 2 then
      c360v1 = false
      do return c360v1 end
    end
    if p22 == 3 then
      c360v1 = c360v0:GetFullName()
      c360v3 = string.find
      c360v5 = "Deluxe"
      c360v3 = c360v3(c360v1, c360v5)
      if c360v3 ~= nil then
        p22 = 6
      else
        p22 = 4
      end
    end
    if p22 == 4 then
      c360v3 = string.find
      c360v5 = "ExcaliburProtoSuit"
      c360v3 = c360v3(c360v1, c360v5)
      if c360v3 ~= nil then
        p22 = 6
      else
        p22 = 5
      end
    end
    if p22 == 5 then
      c360v2 = false
      c360v3 = string.find
      c360v5 = "NyxNemesisSuit"
      c360v3 = c360v3(c360v1, c360v5)
      if c360v3 == nil then
        p22 = 13
      else
        p22 = 6
      end
    end
    if p22 == 6 then
      c360v2 = false
      c360v3 = string.find
      c360v5 = "Operator"
      c360v3 = c360v3(c360v1, c360v5)
      if c360v3 ~= nil then
        p22 = 13
      else
        p22 = 7
      end
    end
    if p22 == 7 then
      c360v2 = false
      c360v3 = string.find
      c360v5 = "Ephemera"
      c360v3 = c360v3(c360v1, c360v5)
      if c360v3 ~= nil then
        p22 = 13
      else
        p22 = 8
      end
    end
    if p22 == 8 then
      c360v2 = false
      c360v3 = string.find
      c360v5 = "Crown"
      c360v3 = c360v3(c360v1, c360v5)
      if c360v3 ~= nil then
        p22 = 13
      else
        p22 = 9
      end
    end
    if p22 == 9 then
      c360v2 = false
      c360v3 = string.find
      c360v5 = "Scarves"
      c360v3 = c360v3(c360v1, c360v5)
      if c360v3 ~= nil then
        p22 = 13
      else
        p22 = 10
      end
    end
    if p22 == 10 then
      c360v3 = string.find
      c360v5 = "Sigil"
      c360v3 = c360v3(c360v1, c360v5)
      if c360v3 == nil then
        p22 = 12
      else
        p22 = 11
      end
    end
    if p22 == 11 then
      c360v2 = false
      p22 = 13
    end
    if p22 == 12 then
      c360v2 = true
      p22 = 13
    end
    if p22 == 13 then
      do return c360v2 end
    end
  end
  IsDeluxeSkin = vT[144]
  vT[144] = function(c361v0, c361v1, c361v2, c361v3, c361v4, c361v5, c361v6, c361v7, c361v8, c361v9)
    local c361v10, c361v11, c361v12, c361v13, c361v14, c361v15, c361v16, c361v17, c361v18, c361v20, c361v21, c361v22
    local p6 = 0
    if p6 == 0 then
      c361v13 = 36
      c361v0:SetStringVariable(c361v2, c361v13, c361v1)
      c361v13 = 36
      c361v0:SetStringVariable(c361v3, c361v13, c361v1)
      c361v10 = FlashMethod
      c361v14 = ".setVertexColors"
      c361v12 = c361v2 .. c361v14
      c361v10(c361v0, c361v12, c361v4, c361v4, c361v6, c361v6)
      c361v10 = vT[17]
      c361v10 = c361v10.GetRootBasedPosition
      c361v10, c361v11 = c361v10(c361v0, c361v3)
      c361v17 = 15
      c361v14 = c361v0:GetNumberVariable(c361v3, c361v17)
      c361v13 = c361v14 / 2
      c361v12 = c361v11 + c361v13
      c361v13 = vT[17]
      c361v13 = c361v13.TransformPixelToViewportCoordinates
      c361v15 = { x = 0, y = nil }
      c361v16 = c361v12 + c361v7
      c361v15.y = c361v16
      c361v13 = c361v13(c361v0, c361v15)
      c361v12 = c361v13.y
      c361v13 = c361v0:GetViewportWidth()
      c361v14 = c361v0:GetViewportHeight()
      c361v15 = c361v0:GetMovieWidth()
      if c361v13 < c361v15 then
        p6 = 2
      else
        p6 = 1
      end
    end
    if p6 == 1 then
      c361v15 = c361v0:GetMovieHeight()
      if c361v15 <= c361v14 then
        p6 = 4
      else
        p6 = 2
      end
    end
    if p6 == 2 then
      c361v15 = Engine.IsConsole
      c361v15 = c361v15()
      if c361v15 then
        p6 = 4
      else
        p6 = 3
      end
    end
    if p6 == 3 then
      c361v13 = c361v0:GetMovieWidth()
      c361v14 = c361v0:GetMovieHeight()
      p6 = 4
    end
    if p6 == 4 then
      c361v8 = c361v8 / c361v14
      c361v9 = c361v9 / c361v14
      c361v18 = _G
      c361v18 = c361v18.UIMaterial_VerticalVisibilityRangeText
      c361v0:OverrideMaterial(c361v3, c361v18)
      c361v18 = "VisibilityCenter"
      c361v20 = 0
      c361v21 = 0
      c361v22 = 0
      c361v0:Name__e243d995(c361v3, c361v18, c361v12, c361v20, c361v21, c361v22)
      c361v18 = "VisibilitySize"
      c361v20 = 0
      c361v21 = 0
      c361v22 = 0
      c361v0:Name__e243d995(c361v3, c361v18, c361v8, c361v20, c361v21, c361v22)
      c361v18 = "VisibilityFadeSize"
      c361v20 = 0
      c361v21 = 0
      c361v22 = 0
      c361v0:Name__e243d995(c361v3, c361v18, c361v9, c361v20, c361v21, c361v22)
      do return end
    end
  end
  SetupThreeColorText = vT[144]
  vT[144] = function(c362v0, c362v1)
    local c362v2, c362v3, c362v4, c362v5, c362v6, c362v7, c362v9, c362v10, c362v11, c362v12, c362v13, c362v14, c362v15, c362v16
    c362v2 = Color
    c362v3 = 232
    c362v4 = 145
    c362v5 = 58
    c362v6 = 255
    c362v2 = c362v2(c362v3, c362v4, c362v5, c362v6)
    if c362v1 == 2 then
      c362v3 = Color
      c362v4 = 62
      c362v5 = 196
      c362v6 = 221
      c362v7 = 255
      c362v2 = c362v3(c362v4, c362v5, c362v6, c362v7)
    end
    c362v3 = c362v0:InventoryControl()
    c362v6 = {}
    c362v9 = 1
    c362v5 = table.insert
    c362v5(c362v6, c362v3:GetWeaponInSlot(c362v9))
    c362v9 = 0
    c362v5 = table.insert
    c362v5(c362v4, c362v3:GetWeaponInSlot(c362v9))
    c362v9 = 5
    c362v5 = table.insert
    c362v5(c362v4, c362v3:GetWeaponInSlot(c362v9))
    c362v5 = table.insert
    c362v5(c362v4, c362v3:GetActivePowerSuit())
    c362v5 = ipairs
    c362v5, c362v6, c362v7 = c362v5(c362v4)
    for c362v8, c362v9 in c362v5, c362v6, c362v7 do
      do return end
    end
    c362v10 = IsNull
    c362v10 = c362v10(c362v9)
    if not c362v10 then
      c362v10 = c362v9:GetCustomization()
      c362v13 = 0
      c362v11 = c362v10:GetColors(c362v13)
      c362v14 = 6
      c362v11:SetColor(c362v14, c362v2)
      c362v14 = 6
      c362v15 = true
      c362v11:SetInitialized(c362v14, c362v15)
      c362v14 = 0
      c362v10:SetColors(c362v14, c362v11)
      c362v14 = gPowerSuitType
      c362v12 = c362v9:IsA(c362v14)
      if c362v12 then
        c362v14 = 1
        c362v12 = c362v10:GetColors(c362v14)
        c362v15 = 6
        c362v12:SetColor(c362v15, c362v2)
        c362v15 = 6
        c362v16 = true
        c362v12:SetInitialized(c362v15, c362v16)
        c362v15 = 1
        c362v10:SetColors(c362v15, c362v12)
      end
      c362v9:SetCustomization(c362v10)
    end
  end
  SetEnergyToTeamColor = vT[144]
  vT[144] = function()
    local c363v0, c363v1
    c363v0 = _T
    c363v1 = {}
    c363v0.QueuedTransmissions = c363v1
    do return end
  end
  ClearTransmissionQueue = vT[144]
  vT[144] = function(c364v0)
    local c364v1, c364v3
    c364v1 = IsNull
    c364v1 = c364v1(c364v0)
    if c364v1 then
      c364v1 = nil
      do return c364v1 end
    end
    c364v3 = gStoreItemType
    c364v1 = c364v0:IsA(c364v3)
    if not c364v1 then
      c364v1 = nil
      do return c364v1 end
    end
    c364v1 = Engine.Name__1330f85d
    c364v1 = c364v1()
    if c364v1 then
      c364v1 = c364v0:IsSteamPurchase()
      if c364v1 then
        c364v1 = c364v0:GetSteamProdId()
        if c364v1 ~= "" then
          do return c364v0:GetSteamProdId() end
        end
      end
    end
    c364v1 = Engine.DooperatorRank
    c364v1 = c364v1()
    if c364v1 then
      c364v1 = c364v0:GetEpicProdId()
      if c364v1 ~= "" then
        do return c364v0:GetEpicProdId() end
      end
    end
    do return c364v0:GetProdId() end
  end
  vT[145] = function(c365v0)
    local c365v1
    c365v1 = vT[144]
    c365v1 = c365v1(c365v0)
    do return c365v1 end
  end
  GetProductId = vT[145]
  vT[145] = function(c366v0)
    local c366v2
    local c366v1 = IsNull
    c366v1 = c366v1(c366v0)
    if c366v1 then
      c366v1 = nil
      do return c366v1 end
    end
    c366v1 = c366v0:IsSteamPurchase()
    if not c366v1 then
      local p34 = 3
      if p34 == 3 then
        c366v1 = Engine.Name__1330f85d
        c366v1 = c366v1()
        if not c366v1 then
          p34 = 5
        else
          p34 = 4
        end
      end
      if p34 == 4 then
        c366v1 = c366v0:GetSteamProdId()
        if c366v1 ~= "" then
        else
          p34 = 5
        end
      end
      if p34 == 5 then
        c366v1 = Engine.Name__1330f85d
        c366v1 = c366v1()
        if c366v1 then
          p34 = 8
        else
          p34 = 6
        end
      end
      if p34 == 6 then
        c366v1 = c366v0:GetSteamProdId()
        if c366v1 == "" then
          p34 = 8
        else
        end
      end
      if p34 == 8 then
        c366v1 = c366v0:IsPackage()
        if not c366v1 then
          p34 = 15
        else
          p34 = 9
        end
      end
      if p34 == 9 then
        c366v1 = Engine.IsConsole
        c366v1 = c366v1()
        if not c366v1 then
          p34 = 12
        else
          p34 = 10
        end
      end
      if p34 == 10 then
        c366v1 = c366v0:GetSteamProdId()
        if c366v1 ~= "" then
          p34 = 12
        else
          p34 = 11
        end
      end
      if p34 == 11 then
        c366v1 = "MARKET"
        do return c366v1 end
      end
      if p34 == 12 then
        c366v1 = Engine.IsConsole
        c366v1 = c366v1()
        if not c366v1 then
          p34 = 15
        else
          p34 = 13
        end
      end
      if p34 == 13 then
        c366v1 = c366v0:GetSteamProdId()
        if c366v1 == "" then
          p34 = 15
        else
          p34 = 14
        end
      end
      if p34 == 14 then
        c366v1 = "UNAVAILABLE"
        do return c366v1 end
      end
      if p34 == 15 then
        c366v1 = Engine.Name__1330f85d
        c366v1 = c366v1()
        if not c366v1 then
          p34 = 17
        else
          p34 = 16
        end
      end
      if p34 == 16 then
        c366v1 = "EXTERNAL"
        do return c366v1 end
      end
      if p34 == 17 then
        c366v1 = c366v0:GetPremiumPrice()
        c366v2 = 0
        if c366v1 <= c366v2 then
          p34 = 22
        else
          p34 = 18
        end
      end
      if p34 == 18 then
        c366v1 = Engine.IsConsole
        c366v1 = c366v1()
        if c366v1 then
          p34 = 21
        else
          p34 = 19
        end
      end
      if p34 == 19 then
        c366v1 = Engine.STACKSFollies
        c366v1 = c366v1()
        if c366v1 then
          p34 = 21
        else
          p34 = 20
        end
      end
      if p34 == 20 then
        c366v1 = Engine.IsMobile
        c366v1 = c366v1()
        if not c366v1 then
          p34 = 22
        else
          p34 = 21
        end
      end
      if p34 == 21 then
        c366v1 = "MARKET"
        do return c366v1 end
      end
      if p34 == 22 then
        c366v1 = "UNAVAILABLE"
        do return c366v1 end
      end
    end
    c366v1 = nil
    do return c366v1 end
  end
  vT[146] = function(c367v0)
    local c367v1
    c367v1 = vT[145]
    c367v1 = c367v1(c367v0)
    do return c367v1 end
  end
  CheckSteamPurchaseAvailability = vT[146]
  vT[146] = function(c368v0)
    local c368v1, c368v2, c368v3, c368v4, c368v5
    c368v1 = IsNull
    c368v1 = c368v1(c368v0)
    if not c368v1 then
      c368v2 = gGameData
      c368v1 = IsNull
      c368v1 = c368v1(c368v2)
      if not c368v1 then
        c368v1 = IsTwitchOrWegameValid
        c368v1 = c368v1(c368v0)
        if c368v1 ~= nil then
          c368v2 = true
          do return c368v2 end
        end
        c368v2 = vT[144]
        c368v2 = c368v2(c368v0)
        if not ((not (c368v2 == "") and c368v2 ~= "9999")) then
          c368v3 = false
          do return c368v3 end
        end
        c368v3 = gGameData
        c368v3 = c368v3:Name__f2020ddd(c368v2)
        c368v4 = false
        c368v5 = c368v3.productId
        if c368v5 == c368v2 then
          c368v5 = c368v3.listPrice
          c368v5 = c368v5.formatted
          if c368v5 == "" then
            c368v4 = false
          else
            c368v4 = true
          end
        end
        do return c368v4 end
      end
    end
    c368v1 = false
    do return c368v1 end
  end
  vT[147] = function(c369v0)
    local c369v1
    c369v1 = vT[146]
    c369v1 = c369v1(c369v0)
    do return c369v1 end
  end
  IsExternalProduct = vT[147]
  vT[147] = function(c370v0, c370v1, c370v2, c370v3)
    local c370v4, c370v5, c370v6, c370v7, c370v8, c370v9, c370v10, c370v11, c370v12, c370v13, c370v14, c370v15, c370v17, c370v18
    c370v4 = IsNull
    c370v4 = c370v4(c370v2)
    c370v4 = IsNull
    c370v4 = c370v4(c370v1)
    c370v4 = c370v3
    c370v5 = c370v1:GetSockets()
    c370v6 = #c370v5
    c370v7 = 0
    c370v6 = ""
    c370v7 = false
    c370v8 = c370v2.mSockets
    c370v10 = 1
    c370v8 = #c370v5
    c370v9 = 1
    for c370v10 = c370v10, c370v8, c370v9 do
      c370v14 = c370v10 - 1
      c370v12 = c370v2:GetSocket(c370v14)
      c370v11 = not c370v12
      c370v12 = c370v7
      if not c370v12 then
        c370v12 = not c370v11
      end
      c370v7 = c370v12
      c370v15 = vT[17]
      c370v15 = c370v15.Ternary
      c370v17 = "<TREASURE_GEM_OUTLINE>"
      c370v18 = "<TREASURE_GEM>"
      c370v13 = c370v15(c370v11, c370v17, c370v18)
      c370v14 = ""
      c370v6 = c370v6 .. c370v13 .. c370v14
    end
    if c370v4 then
      do return c370v3 end
    end
    if c370v4 then
      if c370v7 then
        c370v8 = ""
        c370v9 = IsNull
        c370v9 = c370v9(c370v0)
        if not c370v9 then
          c370v12 = true
          c370v8 = c370v0:GetLocalized(c370v6, c370v12)
        else
          c370v9 = Localize
          c370v11 = true
          c370v8 = c370v9(c370v6, c370v11)
        end
        c370v10 = "   "
        c370v4 = c370v4 .. c370v10 .. c370v8
      end
    end
    do return c370v4 end
  end
  GetTreasureName = vT[147]
  vT[147] = function()
    local c371v0, c371v1, c371v2
    c371v1 = gGameRules
    c371v0 = IsNull
    c371v0 = c371v0(c371v1)
    if c371v0 then
      c371v0 = 0
      do return c371v0 end
    end
    c371v0 = gGameRules
    c371v2 = 3600
    c371v0 = c371v0:GetCycleIdx(c371v2)
    do return c371v0 end
  end
  vT[148] = function()
    local c372v0
    c372v0 = vT[147]
    c372v0 = c372v0()
    do return c372v0 end
  end
  GetHourCount = vT[148]
  vT[148] = function()
    local c373v0, c373v1, c373v2
    c373v1 = gGameRules
    c373v0 = IsNull
    c373v0 = c373v0(c373v1)
    if c373v0 then
      c373v0 = 0
      do return c373v0 end
    end
    c373v0 = gGameRules
    c373v2 = 86400
    c373v0 = c373v0:GetCycleIdx(c373v2)
    do return c373v0 end
  end
  vT[149] = function()
    local c374v0
    c374v0 = vT[148]
    c374v0 = c374v0()
    do return c374v0 end
  end
  GetDayCount = vT[149]
  vT[149] = function()
    local c375v0, c375v1, c375v2
    c375v1 = gGameRules
    c375v0 = IsNull
    c375v0 = c375v0(c375v1)
    if c375v0 then
      c375v0 = 0
      do return c375v0 end
    end
    c375v0 = gGameRules
    c375v2 = 604800
    c375v0 = c375v0:GetCycleIdx(c375v2)
    do return c375v0 end
  end
  GetWeekCount = vT[149]
  vT[149] = function()
    local c376v0, c376v1, c376v2
    c376v1 = gGameRules
    c376v0 = IsNull
    c376v0 = c376v0(c376v1)
    if c376v0 then
      c376v0 = 0
      do return c376v0 end
    end
    c376v0 = gGameRules
    c376v2 = 604800
    c376v0 = c376v0:Name__d5a8b093(c376v2)
    do return c376v0 end
  end
  GetWeekTimeLeft = vT[149]
  vT[149] = function(c377v0)
    local c377v1, c377v3, c377v4, c377v5, c377v6, c377v8, c377v9, c377v10, c377v11
    c377v1 = {}
    local c377v2 = c377v0.missionType
    c377v3 = 18
    if c377v2 == c377v3 then
      c377v4 = 9
      c377v5 = "/Lotus/Language/Menu/NightmareModeName"
      c377v3 = {c377v4, c377v5}
      do return c377v3 end
    end
    c377v3 = {}
    local c377v7 = 1
    c377v8 = "/Lotus/Language/Game/NightmareModeVampire"
    c377v6 = {c377v7, c377v8}
    c377v4 = table.insert
    c377v4(c377v3, c377v6)
    c377v7 = 3
    c377v8 = "/Lotus/Language/Game/NightmareModeEnergyDrain"
    c377v6 = {c377v7, c377v8}
    c377v4 = table.insert
    c377v4(c377v3, c377v6)
    c377v7 = 6
    c377v8 = "/Lotus/Language/Game/NightmareModeExplodingCorpses"
    c377v6 = {c377v7, c377v8}
    c377v4 = table.insert
    c377v4(c377v3, c377v6)
    c377v4 = 8
    if c377v2 ~= c377v4 then
      c377v4 = 9
      if c377v2 ~= c377v4 then
        c377v4 = 2
        if c377v2 ~= c377v4 then
          c377v4 = 33
          if c377v2 ~= c377v4 then
            c377v4 = 4
            if c377v2 ~= c377v4 then
              c377v4 = 3
              if c377v2 ~= c377v4 then
                c377v4 = 0
                if c377v2 ~= c377v4 then
                  c377v4 = 34
                  if c377v2 ~= c377v4 then
                    c377v4 = 35
                    if c377v2 ~= c377v4 then
                      c377v4 = 36
                      if c377v2 ~= c377v4 then
                        c377v4 = 44
                        if c377v2 ~= c377v4 then
                          c377v7 = 0
                          c377v8 = "/Lotus/Language/Game/NightmareModeTimer"
                          c377v6 = {c377v7, c377v8}
                          c377v4 = table.insert
                          c377v4(c377v3, c377v6)
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    c377v4 = 0
    c377v4 = 14
    if c377v2 == c377v4 then
      c377v7 = 4
      c377v8 = "/Lotus/Language/Game/NightmareModeNoShield"
      c377v6 = {c377v7, c377v8}
      c377v4 = table.insert
      c377v4(c377v3, c377v6)
    end
    c377v4 = GetSeed
    c377v4 = c377v4()
    c377v5 = Name__6dd598b2
    c377v6 = Name__001701c4
    c377v8 = c377v0.location
    c377v7 = tostring
    c377v7 = c377v7(c377v8)
    c377v5 = c377v5(c377v6(c377v7))
    c377v6 = Name__dadf7b26
    c377v9 = vT[148]
    c377v9 = c377v9()
    c377v8 = c377v9 % 365
    c377v6(c377v5, c377v8)
    c377v6 = SRandomInt
    c377v7 = 1
    c377v8 = #c377v3
    c377v6 = c377v6(c377v7, c377v8)
    c377v9 = c377v3[c377v6]
    c377v7 = table.insert
    c377v7(c377v1, c377v9)
    c377v7 = SRandomInt
    c377v8 = 0
    c377v9 = 2
    c377v7 = c377v7(c377v8, c377v9)
    if c377v7 == -1 then
      c377v10 = 2
      c377v11 = "/Lotus/Language/Game/NightmareModeNoHud"
      c377v9 = {c377v10, c377v11}
      c377v7 = table.insert
      c377v7(c377v1, c377v9)
    end
    c377v7 = SRandomInt
    c377v8 = 0
    c377v9 = 3
    c377v7 = c377v7(c377v8, c377v9)
    if c377v7 == 1 then
      c377v10 = 8
      c377v11 = "/Lotus/Language/Game/NightmareModeLowGrav"
      c377v9 = {c377v10, c377v11}
      c377v7 = table.insert
      c377v7(c377v1, c377v9)
    end
    c377v7 = SetSeed
    c377v7(c377v4)
    do return c377v1 end
  end
  RollForNightmareMutators = vT[149]
  vT[24] = function()
    local c378v0, c378v1, c378v2, c378v3, c378v4, c378v5, c378v6, c378v7, c378v8, c378v9, c378v11
    c378v0 = {}
    c378v1 = gGameData
    c378v2 = IsNull
    c378v2 = c378v2(c378v1)
    if c378v2 then
      do return c378v0 end
    end
    c378v2 = c378v1:GetInventory()
    c378v3 = IsNull
    c378v3 = c378v3(c378v2)
    if c378v3 then
      do return c378v0 end
    end
    c378v3 = c378v2:GetUpgrades()
    c378v4 = gRandomizedArtifactUpgradeType
    c378v7 = 1
    c378v5 = #c378v3
    c378v6 = 1
    for c378v7 = c378v7, c378v5, c378v6 do
      c378v8 = c378v3[c378v7]
      c378v8 = c378v8.mItemType
      c378v9 = IsNull
      c378v9 = c378v9(c378v8)
      if not c378v9 then
        c378v9 = c378v8:IsA(c378v4)
        if c378v9 then
          c378v11 = c378v3[c378v7]
          c378v9 = table.insert
          c378v9(c378v0, c378v11)
        end
      end
    end
    do return c378v0 end
  end
  vT[149] = function()
    local c379v0
    c379v0 = vT[24]
    do return c379v0() end
  end
  GetOmegaCards = vT[149]
  vT[25] = function()
    local c380v0, c380v1, c380v2, c380v3, c380v4
    c380v0 = gGameData
    c380v1 = IsNull
    c380v1 = c380v1(c380v0)
    if c380v1 then
      c380v1 = false
      do return c380v1 end
    end
    c380v1 = c380v0:GetInventory()
    c380v2 = IsNull
    c380v2 = c380v2(c380v1)
    if c380v2 then
      c380v2 = false
      do return c380v2 end
    end
    c380v4 = vT[24]
    c380v4 = c380v4()
    c380v3 = #c380v4
    c380v4 = vT[26]
    c380v4 = c380v4()
    if c380v3 <= c380v4 then
      c380v2 = false
    else
      c380v2 = true
    end
    do return c380v2 end
  end
  vT[149] = function()
    local c381v0
    c381v0 = vT[25]
    do return c381v0() end
  end
  IsOverOmegaLimit = vT[149]
  vT[26] = function()
    local c382v0, c382v1, c382v2, c382v3, c382v5
    c382v0 = 0
    c382v2 = gGameData
    c382v1 = IsNull
    c382v1 = c382v1(c382v2)
    if not c382v1 then
      c382v1 = gGameData
      c382v1 = c382v1:GetInventory()
      c382v2 = gGameData
      c382v2 = c382v2:Name__1d1bb34a()
      c382v5 = 7
      c382v0 = c382v1:GetBinMax(c382v5)
      c382v3 = 30
      if c382v3 <= c382v2 then
        c382v0 = c382v0 + 30
      end
    end
    do return c382v0 end
  end
  vT[149] = function()
    local c383v0
    c383v0 = vT[26]
    do return c383v0() end
  end
  GetMaxOmegaCapacity = vT[149]
  vT[149] = function(c384v0, c384v1)
    local c384v2, c384v3, c384v4, c384v5, c384v6
    c384v4 = 0
    c384v5 = 0
    c384v2 = c384v0:GetWeaponInfo(c384v4, c384v5)
    c384v2 = c384v2.mInfestationDate
    c384v3 = c384v2:IsValid()
    if not c384v3 then
      c384v3 = false
      do return c384v3 end
    end
    c384v3 = Engine.Name__b38e1642
    c384v3 = c384v3(c384v2)
    c384v6 = -86400
    c384v5 = c384v6 * c384v1
    if c384v5 < c384v3 then
      c384v4 = false
    else
      c384v4 = true
    end
    do return c384v4 end
  end
  vT[150] = function(c385v0)
    local c385v1, c385v3
    c385v1 = vT[149]
    c385v3 = 1
    do return c385v1(c385v0, c385v3) end
  end
  IsCurrentSuitInfestedEnoughToHeal = vT[150]
  vT[150] = function(c386v0)
    local c386v1, c386v3
    c386v1 = vT[149]
    c386v3 = 7
    do return c386v1(c386v0, c386v3) end
  end
  IsCurrentSuitFullyInfested = vT[150]
  vT[150] = function(c387v0)
    local c387v1, c387v2, c387v3
    c387v1 = Engine.STACKSFollies
    c387v1 = c387v1()
    if c387v1 then
      c387v1 = false
      do return c387v1 end
    end
    c387v1 = IsNull
    c387v1 = c387v1(c387v0)
    if c387v1 then
      c387v0 = gGameData
      c387v1 = IsNull
      c387v1 = c387v1(c387v0)
      if c387v1 then
        c387v1 = false
        do return c387v1 end
      end
    end
    c387v1 = c387v0:Name__5d9bc002()
    if c387v1 then
      c387v1 = false
      do return c387v1 end
    end
    c387v1 = gRegion
    c387v1 = c387v1:GetLocalPlayerAvatar()
    c387v2 = IsNull
    c387v2 = c387v2(c387v1)
    if c387v2 then
      c387v2 = false
      do return c387v2 end
    end
    c387v2 = c387v1:InventoryControl()
    c387v2 = c387v2:GetActivePowerSuit()
    c387v3 = IsNull
    c387v3 = c387v3(c387v2)
    if not c387v3 then
      c387v3 = c387v2:IsOperatorSuit()
      if not c387v3 then
        c387v3 = true
        do return c387v3 end
      end
    end
    c387v3 = false
    do return c387v3 end
  end
  ShowTradeUI = vT[150]
  vT[150] = function(c388v0, c388v1)
    local c388v2, c388v3, c388v4, c388v5, c388v6, c388v7, c388v8, c388v9, c388v10, c388v11, c388v12, c388v13, c388v14
    local p12 = 0
    if p12 == 0 then
      c388v2 = IsNull
      c388v2 = c388v2(c388v0)
      if c388v2 then
        p12 = 8
      else
        p12 = 1
      end
    end
    if p12 == 1 then
      c388v2 = IsNull
      c388v2 = c388v2(c388v1)
      if c388v2 then
        p12 = 8
      else
        p12 = 2
      end
    end
    if p12 == 2 then
      c388v4 = DeltaTime
      c388v4 = c388v4()
      c388v6 = false
      c388v1:UpdateWeaponStatus(c388v4, c388v0, c388v6, c388v0:HasReviveTarget())
      c388v2 = c388v1:GetReticleMovie()
      c388v5 = true
      c388v3 = c388v1:GetReticleMovie(c388v5)
      c388v4 = IsNull
      c388v4 = c388v4(c388v2)
      if not c388v4 then
        p12 = 4
      else
        p12 = 3
      end
    end
    if p12 == 3 then
      c388v4 = IsNull
      c388v4 = c388v4(c388v3)
      if c388v4 then
        p12 = 8
      else
        p12 = 4
      end
    end
    if p12 == 4 then
      c388v4 = Distance
      c388v5 = c388v0:InventoryControl()
      c388v5 = c388v5:GetAimEndPoint()
      c388v4 = c388v4(c388v5, c388v0:EyePosition())
      c388v5 = math.floor
      c388v5 = c388v5(c388v4)
      c388v8 = c388v4 * 10
      c388v9 = c388v5 * 10
      c388v7 = c388v8 - c388v9
      c388v6 = math.floor
      c388v6 = c388v6(c388v7)
      c388v7 = IsNull
      c388v7 = c388v7(c388v2)
      if c388v7 then
        p12 = 6
      else
        p12 = 5
      end
    end
    if p12 == 5 then
      c388v9 = "UpdateRangeFinder"
      c388v14 = tostring
      c388v11 = c388v14(c388v5)
      c388v12 = ","
      c388v13 = tostring
      c388v13 = c388v13(c388v6)
      c388v10 = c388v11 .. c388v12 .. c388v13
      c388v2:Execute(c388v9, c388v10)
      p12 = 6
    end
    if p12 == 6 then
      c388v7 = IsNull
      c388v7 = c388v7(c388v3)
      if c388v7 then
        p12 = 8
      else
        p12 = 7
      end
    end
    if p12 == 7 then
      c388v9 = "UpdateRangeFinder"
      c388v14 = tostring
      c388v11 = c388v14(c388v5)
      c388v12 = ","
      c388v13 = tostring
      c388v13 = c388v13(c388v6)
      c388v10 = c388v11 .. c388v12 .. c388v13
      c388v3:Execute(c388v9, c388v10)
      p12 = 8
    end
    if p12 == 8 then
      do return end
    end
  end
  UpdateScannerInfo = vT[150]
  vT[150] = function(c389v0, c389v1)
    local c389v2, c389v3, c389v4, c389v5
    c389v2 = IsNull
    c389v2 = c389v2(c389v0)
    if not c389v2 then
      c389v4 = WeakResource
      c389v5 = "/Lotus/Types/Player/PlayerFlashLight"
      c389v2 = c389v0:GetAttachment(c389v4(c389v5))
      c389v3 = IsNull
      c389v3 = c389v3(c389v2)
      if not c389v3 then
        c389v2:SetDimness(c389v1)
      end
    end
    do return end
  end
  SetFlashlightDimness = vT[150]
  vT[150] = function(c390v0, c390v1, c390v2, c390v3)
    local c390v4, c390v5, c390v6, c390v7, c390v8, c390v9, c390v10, c390v11, c390v12, c390v13, c390v14, c390v15, c390v16, c390v17, c390v18, c390v19, c390v20
    local p43 = 0
    if p43 == 0 then
      c390v4 = IsNull
      c390v4 = c390v4(c390v0)
      if not c390v4 then
        p43 = 2
      else
        p43 = 1
      end
    end
    if p43 == 1 then
      c390v4 = ""
      do return c390v4 end
    end
    if p43 == 2 then
      c390v4 = vT[17]
      c390v4 = c390v4.Ternary
      if c390v2 ~= nil then
        p43 = 4
      else
        p43 = 3
      end
    end
    if p43 == 3 then
      c390v5 = false
      p43 = 5
    end
    if p43 == 4 then
      c390v5 = true
      p43 = 5
    end
    if p43 == 5 then
      c390v7 = "#FFFFFF"
      c390v4 = c390v4(c390v5, c390v2, c390v7)
      c390v5 = vT[17]
      c390v5 = c390v5.Ternary
      if c390v3 ~= nil then
        p43 = 7
      else
        p43 = 6
      end
    end
    if p43 == 6 then
      c390v6 = false
      p43 = 8
    end
    if p43 == 7 then
      c390v6 = true
      p43 = 8
    end
    if p43 == 8 then
      c390v8 = "#FFFFFF"
      c390v5 = c390v5(c390v6, c390v3, c390v8)
      c390v7 = "<p><font color=\""
      c390v9 = "\">"
      c390v6 = c390v7 .. c390v5 .. c390v9
      if c390v1 ~= 2 then
        p43 = 10
      else
        p43 = 9
      end
    end
    if p43 == 9 then
      c390v9 = "/Lotus/Language/MasteryTest/EndOfMatch_MasteryRankUpTrading"
      c390v10 = false
      c390v7 = c390v0:GetLocalized(c390v9, c390v10)
      c390v10 = "<br>"
      c390v6 = c390v6 .. c390v7 .. c390v10
      p43 = 15
    end
    if p43 == 10 then
      if c390v1 ~= 3 then
        p43 = 12
      else
        p43 = 11
      end
    end
    if p43 == 11 then
      c390v9 = "/Lotus/Language/MasteryTest/EndOfMatch_MasteryRankUpSyndicates"
      c390v10 = false
      c390v7 = c390v0:GetLocalized(c390v9, c390v10)
      c390v10 = "<br>"
      c390v6 = c390v6 .. c390v7 .. c390v10
      p43 = 15
    end
    if p43 == 12 then
      if (not (c390v1 == 5) and c390v1 ~= 10) then
        p43 = 15
      else
        p43 = 14
      end
    end
    if p43 == 14 then
      c390v9 = "/Lotus/Language/MasteryTest/EndOfMatch_MasteryRankUpExtraDroneSlot"
      c390v10 = false
      c390v11 = { OPEN_COLOR = nil, CLOSE_COLOR = nil }
      c390v13 = "</font><font color=\""
      c390v15 = "\">"
      c390v12 = c390v13 .. c390v4 .. c390v15
      c390v11.OPEN_COLOR = c390v12
      c390v13 = "</font><font color=\""
      c390v15 = "\">"
      c390v12 = c390v13 .. c390v5 .. c390v15
      c390v11.CLOSE_COLOR = c390v12
      c390v7 = c390v0:GetLocalized(c390v9, c390v10, c390v11)
      c390v10 = "<br>"
      c390v6 = c390v6 .. c390v7 .. c390v10
      p43 = 15
    end
    if p43 == 15 then
      if c390v1 ~= 30 then
        p43 = 17
      else
        p43 = 16
      end
    end
    if p43 == 16 then
      c390v9 = "/Lotus/Language/Blessings/MasteryRankUpBlessingDesc"
      c390v10 = false
      c390v7 = c390v0:GetLocalized(c390v9, c390v10)
      c390v10 = "<br>"
      c390v6 = c390v6 .. c390v7 .. c390v10
      c390v11 = TitleCase
      c390v19 = "/Lotus/Language/Emotes/Rank30EmoteName"
      c390v20 = false
      c390v13 = c390v0:GetLocalized(c390v19, c390v20)
      c390v14 = " ("
      c390v19 = "/Lotus/Language/Emotes/Emote"
      c390v20 = false
      c390v15 = c390v0:GetLocalized(c390v19, c390v20)
      c390v16 = ")"
      c390v12 = c390v13 .. c390v14 .. c390v15 .. c390v16
      c390v9 = c390v11(c390v12)
      c390v10 = "<br>"
      c390v6 = c390v6 .. c390v9 .. c390v10
      c390v11 = TitleCase
      c390v14 = "/Lotus/Language/ShipDecorations/HoodOrnament_MR30Name"
      c390v15 = false
      c390v9 = c390v11(c390v0:GetLocalized(c390v14, c390v15))
      c390v10 = "<br>"
      c390v6 = c390v6 .. c390v9 .. c390v10
      c390v11 = TitleCase
      c390v14 = "/Lotus/Language/Cosmetics/TrueMasterEmoji"
      c390v15 = false
      c390v9 = c390v11(c390v0:GetLocalized(c390v14, c390v15))
      c390v10 = "<br>"
      c390v6 = c390v6 .. c390v9 .. c390v10
      c390v9 = "<font color=\""
      c390v11 = "\">+3</font> "
      c390v16 = "/Lotus/Language/Consumables/FormaUmbra"
      c390v17 = false
      c390v12 = c390v0:GetLocalized(c390v16, c390v17)
      c390v13 = "<br>"
      c390v6 = c390v6 .. c390v9 .. c390v4 .. c390v11 .. c390v12 .. c390v13
      c390v9 = "<font color=\""
      c390v11 = "\">+15</font> "
      c390v14 = TitleCase
      c390v17 = "/Lotus/Language/Menu/Loadout_Slot"
      c390v18 = false
      c390v12 = c390v14(c390v0:GetLocalized(c390v17, c390v18))
      c390v13 = "<br>"
      c390v6 = c390v6 .. c390v9 .. c390v4 .. c390v11 .. c390v12 .. c390v13
      c390v9 = "<font color=\""
      c390v11 = "\">+30</font> "
      c390v14 = TitleCase
      c390v17 = "/Lotus/Language/Menu/ItemInventory_SlotsRandomMod"
      c390v18 = false
      c390v12 = c390v14(c390v0:GetLocalized(c390v17, c390v18))
      c390v13 = "<br>"
      c390v6 = c390v6 .. c390v9 .. c390v4 .. c390v11 .. c390v12 .. c390v13
      p43 = 19
    end
    if p43 == 17 then
      c390v7 = c390v1 % 2
      if c390v7 ~= 0 then
        p43 = 19
      else
        p43 = 18
      end
    end
    if p43 == 18 then
      c390v9 = "/Lotus/Language/MasteryTest/EndOfMatch_LoadOutSlot"
      c390v10 = false
      c390v11 = { OPEN_COLOR = nil, CLOSE_COLOR = nil }
      c390v13 = "</font><font color=\""
      c390v15 = "\">"
      c390v12 = c390v13 .. c390v4 .. c390v15
      c390v11.OPEN_COLOR = c390v12
      c390v13 = "</font><font color=\""
      c390v15 = "\">"
      c390v12 = c390v13 .. c390v5 .. c390v15
      c390v11.CLOSE_COLOR = c390v12
      c390v7 = c390v0:GetLocalized(c390v9, c390v10, c390v11)
      c390v10 = "<br>"
      c390v6 = c390v6 .. c390v7 .. c390v10
      p43 = 19
    end
    if p43 == 19 then
      c390v12 = "/Lotus/Language/MasteryTest/EndOfMatch_MasteryRankUpStanding"
      c390v13 = true
      c390v14 = { NUM = 500, OPEN_COLOR = nil, CLOSE_COLOR = nil }
      c390v16 = "</font><font color=\""
      c390v18 = "\">"
      c390v15 = c390v16 .. c390v4 .. c390v18
      c390v14.OPEN_COLOR = c390v15
      c390v16 = "</font><font color=\""
      c390v18 = "\">"
      c390v15 = c390v16 .. c390v5 .. c390v18
      c390v14.CLOSE_COLOR = c390v15
      c390v8 = c390v0:GetLocalized(c390v12, c390v13, c390v14)
      c390v9 = "<br>"
      c390v6 = c390v6 .. c390v8 .. c390v9
      c390v8 = gGameData
      c390v7 = IsNull
      c390v7 = c390v7(c390v8)
      if c390v7 then
        p43 = 21
      else
        p43 = 20
      end
    end
    if p43 == 20 then
      c390v7 = gGameData
      c390v7 = c390v7:Name__8f0bd229()
      c390v8 = 2
      if c390v7 < c390v8 then
        p43 = 22
      else
        p43 = 21
      end
    end
    if p43 == 21 then
      c390v12 = "/Lotus/Language/MasteryTest/EndOfMatch_MasteryRankUpFocusCapacity"
      c390v13 = true
      c390v14 = { NUM = 1000, OPEN_COLOR = nil, CLOSE_COLOR = nil }
      c390v16 = "</font><font color=\""
      c390v18 = "\">"
      c390v15 = c390v16 .. c390v4 .. c390v18
      c390v14.OPEN_COLOR = c390v15
      c390v16 = "</font><font color=\""
      c390v18 = "\">"
      c390v15 = c390v16 .. c390v5 .. c390v18
      c390v14.CLOSE_COLOR = c390v15
      c390v8 = c390v0:GetLocalized(c390v12, c390v13, c390v14)
      c390v9 = "<br>"
      c390v6 = c390v6 .. c390v8 .. c390v9
      p43 = 22
    end
    if p43 == 22 then
      c390v7 = 30
      if c390v7 < c390v1 then
        p43 = 25
      else
        p43 = 23
      end
    end
    if p43 == 23 then
      c390v7 = c390v1 % 2
      if c390v7 ~= 0 then
        p43 = 25
      else
        p43 = 24
      end
    end
    if p43 == 24 then
      c390v12 = "/Lotus/Language/MasteryTest/EndOfMatch_MasteryRankUpCapacity"
      c390v13 = false
      c390v14 = { OPEN_COLOR = nil, CLOSE_COLOR = nil }
      c390v16 = "</font><font color=\""
      c390v18 = "\">"
      c390v15 = c390v16 .. c390v4 .. c390v18
      c390v14.OPEN_COLOR = c390v15
      c390v16 = "</font><font color=\""
      c390v18 = "\">"
      c390v15 = c390v16 .. c390v5 .. c390v18
      c390v14.CLOSE_COLOR = c390v15
      c390v8 = c390v0:GetLocalized(c390v12, c390v13, c390v14)
      c390v9 = "<br>"
      c390v6 = c390v6 .. c390v8 .. c390v9
      p43 = 27
    end
    if p43 == 25 then
      c390v7 = 30
      if c390v1 <= c390v7 then
        p43 = 27
      else
        p43 = 26
      end
    end
    if p43 == 26 then
      c390v12 = "/Lotus/Language/MasteryTest/MasteryRankUp_LegendaryCore"
      c390v13 = true
      c390v14 = { NUM = 1, OPEN_COLOR = nil, CLOSE_COLOR = nil }
      c390v16 = "</font><font color=\""
      c390v18 = "\">"
      c390v15 = c390v16 .. c390v4 .. c390v18
      c390v14.OPEN_COLOR = c390v15
      c390v16 = "</font><font color=\""
      c390v18 = "\">"
      c390v15 = c390v16 .. c390v5 .. c390v18
      c390v14.CLOSE_COLOR = c390v15
      c390v8 = c390v0:GetLocalized(c390v12, c390v13, c390v14)
      c390v9 = "<br>"
      c390v6 = c390v6 .. c390v8 .. c390v9
      p43 = 27
    end
    if p43 == 27 then
      c390v10 = "/Lotus/Language/MasteryTest/EndOfMatch_MasteryRankUpReactant"
      c390v11 = true
      c390v12 = { NUM = 50, OPEN_COLOR = nil, CLOSE_COLOR = nil }
      c390v14 = "</font><font color=\""
      c390v16 = "\">"
      c390v13 = c390v14 .. c390v4 .. c390v16
      c390v12.OPEN_COLOR = c390v13
      c390v14 = "</font><font color=\""
      c390v16 = "\">"
      c390v13 = c390v14 .. c390v5 .. c390v16
      c390v12.CLOSE_COLOR = c390v13
      c390v8 = c390v0:GetLocalized(c390v10, c390v11, c390v12)
      c390v6 = c390v6 .. c390v8
      c390v8 = "</font></p>"
      c390v6 = c390v6 .. c390v8
      do return c390v6 end
    end
  end
  GetRewardTextForMastery = vT[150]
  vT[150] = function(c391v0, c391v1, c391v2)
    local c391v3, c391v4, c391v5, c391v6, c391v7, c391v8, c391v9, c391v10, c391v11
    local p71 = 0
    if p71 == 0 then
      c391v3 = {}
      c391v4 = 0
      if c391v0 == c391v4 then
        p71 = 2
      else
        p71 = 1
      end
    end
    if p71 == 1 then
      c391v4 = 3
      if c391v0 ~= c391v4 then
        p71 = 10
      else
        p71 = 2
      end
    end
    if p71 == 2 then
      c391v4 = 0
      if c391v1 ~= c391v4 then
        p71 = 4
      else
        p71 = 3
      end
    end
    if p71 == 3 then
      c391v3 = c391v2:GetSuits()
      do return c391v3 end
    end
    if p71 == 4 then
      c391v4 = 3
      if c391v1 ~= c391v4 then
        p71 = 6
      else
        p71 = 5
      end
    end
    if p71 == 5 then
      c391v3 = c391v2:GetMelee()
      do return c391v3 end
    end
    if p71 == 6 then
      c391v4 = 2
      if c391v1 ~= c391v4 then
        p71 = 8
      else
        p71 = 7
      end
    end
    if p71 == 7 then
      c391v3 = c391v2:GetLongGuns()
      do return c391v3 end
    end
    if p71 == 8 then
      c391v4 = 1
      if c391v1 ~= c391v4 then
        p71 = 38
      else
        p71 = 9
      end
    end
    if p71 == 9 then
      c391v3 = c391v2:GetPistols()
      do return c391v3 end
    end
    if p71 == 10 then
      c391v4 = 2
      if c391v0 ~= c391v4 then
        p71 = 17
      else
        p71 = 11
      end
    end
    if p71 == 11 then
      c391v4 = 0
      if c391v1 ~= c391v4 then
        p71 = 13
      else
        p71 = 12
      end
    end
    if p71 == 12 then
      c391v3 = c391v2:GetSpaceSuits()
      do return c391v3 end
    end
    if p71 == 13 then
      c391v4 = 3
      if c391v1 ~= c391v4 then
        p71 = 15
      else
        p71 = 14
      end
    end
    if p71 == 14 then
      c391v3 = c391v2:GetSpaceMelee()
      do return c391v3 end
    end
    if p71 == 15 then
      c391v4 = 2
      if c391v1 ~= c391v4 then
        p71 = 38
      else
        p71 = 16
      end
    end
    if p71 == 16 then
      c391v3 = c391v2:GetSpaceGuns()
      do return c391v3 end
    end
    if p71 == 17 then
      c391v4 = 6
      if c391v0 ~= c391v4 then
        p71 = 20
      else
        p71 = 18
      end
    end
    if p71 == 18 then
      c391v4 = 0
      if c391v1 ~= c391v4 then
        p71 = 38
      else
        p71 = 19
      end
    end
    if p71 == 19 then
      c391v3 = c391v2:GetHoverboards()
      do return c391v3 end
    end
    if p71 == 20 then
      c391v4 = 1
      if c391v0 ~= c391v4 then
        p71 = 35
      else
        p71 = 21
      end
    end
    if p71 == 21 then
      c391v4 = 0
      if c391v1 ~= c391v4 then
        p71 = 34
      else
        p71 = 22
      end
    end
    if p71 == 22 then
      c391v3 = c391v2:GetSentinels()
      if c391v3 then
        p71 = 24
      else
        p71 = 23
      end
    end
    if p71 == 23 then
      c391v3 = {}
      p71 = 24
    end
    if p71 == 24 then
      c391v4 = c391v2:GetMoaPets()
      c391v7 = 1
      c391v5 = #c391v4
      c391v6 = 1
      if (c391v6 > 0 and c391v7 > c391v5) or (c391v6 < 0 and c391v7 < c391v5) then
        p71 = 26
      else
        p71 = 25
      end
    end
    if p71 == 25 then
      c391v10 = c391v4[c391v7]
      c391v8 = table.insert
      c391v8(c391v3, c391v10)
      p71 = 26
    end
    if p71 == 26 then
      c391v5 = c391v2:GetKubrowPets()
      c391v6 = nil
      c391v9 = 1
      c391v7 = #c391v5
      c391v8 = 1
      if (c391v8 > 0 and c391v9 > c391v7) or (c391v8 < 0 and c391v9 < c391v7) then
        p71 = 32
      else
        p71 = 27
      end
    end
    if p71 == 27 then
      c391v10 = c391v5[c391v9]
      c391v10 = c391v10.mDetails
      c391v10 = c391v10.mStatus
      c391v11 = 2
      if c391v10 ~= c391v11 then
        p71 = 29
      else
        p71 = 28
      end
    end
    if p71 == 28 then
      c391v6 = c391v5[c391v9]
      p71 = 32
    end
    if p71 == 29 then
      c391v10 = c391v5[c391v9]
      c391v10 = c391v10.mDetails
      c391v10 = c391v10.mStatus
      c391v11 = 4
      if c391v10 ~= c391v11 then
        p71 = 31
      else
        p71 = 30
      end
    end
    if p71 == 30 then
      c391v6 = c391v5[c391v9]
      p71 = 31
    end
    if p71 == 31 then
      p71 = 32
    end
    if p71 == 32 then
      if c391v6 == nil then
        p71 = 38
      else
        p71 = 33
      end
    end
    if p71 == 33 then
      c391v7 = table.insert
      c391v7(c391v3, c391v6)
      do return c391v3 end
    end
    if p71 == 34 then
      c391v3 = c391v2:GetSentinelWeapons()
      do return c391v3 end
    end
    if p71 == 35 then
      c391v4 = 7
      if c391v0 ~= c391v4 then
        p71 = 38
      else
        p71 = 36
      end
    end
    if p71 == 36 then
      c391v4 = 0
      if c391v1 ~= c391v4 then
        p71 = 38
      else
        p71 = 37
      end
    end
    if p71 == 37 then
      c391v3 = c391v2:GetDataKnives()
      p71 = 38
    end
    if p71 == 38 then
      do return c391v3 end
    end
  end
  vT[151] = function(c392v0, c392v1, c392v2, c392v3, c392v4)
    local c392v5, c392v6, c392v7, c392v8, c392v9, c392v10, c392v11, c392v12, c392v13, c392v14, c392v15, c392v16, c392v17, c392v18, c392v19, c392v20, c392v21, c392v22, c392v23, c392v24, c392v25, c392v26, c392v28, c392v29, c392v30, c392v31
    c392v5 = 3
    c392v7 = { IsSentinel = false, Id = nil }
    c392v8 = 0
    c392v7.Id = c392v8
    c392v8 = { IsSentinel = false, Id = nil }
    c392v9 = 2
    c392v8.Id = c392v9
    c392v9 = { IsSentinel = false, Id = nil }
    c392v10 = 3
    c392v9.Id = c392v10
    c392v6 = {c392v7, c392v8, c392v9}
    c392v7 = 0
    c392v7 = 3
    c392v9 = 3
    c392v10 = { IsSentinel = false, Id = nil }
    c392v11 = 1
    c392v10.Id = c392v11
    c392v7 = table.insert
    c392v7(c392v6, c392v9, c392v10)
    c392v5 = 4
    c392v16 = c392v6[c392v11]
    c392v16 = c392v16.Id
    c392v14 = c392v13:GetEntry(c392v16)
    c392v15 = c392v14.mItemId
    c392v15 = c392v15:IsValid()
    c392v15 = vT[150]
    c392v16 = vT[17]
    c392v16 = c392v16.Ternary
    c392v17 = c392v6[c392v11]
    c392v17 = c392v17.IsSentinel
    c392v18 = 1
    c392v16 = c392v16(c392v17, c392v18, c392v2)
    c392v17 = c392v6[c392v11]
    c392v17 = c392v17.Id
    c392v15 = c392v15(c392v16, c392v17, c392v3)
    c392v18 = 1
    c392v16 = #c392v15
    c392v17 = 1
    for c392v18 = c392v18, c392v16, c392v17 do
      c392v19 = c392v15[c392v18]
      c392v19 = c392v19.mItemId
      c392v20 = c392v14.mItemId
      if c392v19 == c392v20 then break end
    end
    if c392v8 ~= nil then
      c392v15 = c392v6[c392v11]
      c392v15 = c392v15.IsSentinel
      if not c392v15 then
        c392v16 = "<font color=\"#FloatingContentHighlight\">"
        c392v20 = Localize
        c392v21 = "/Lotus/Language/Menu/Cosmetics_None"
        c392v22 = {}
        c392v17 = c392v20(c392v21, c392v22)
        c392v19 = "</font>"
        c392v8 = c392v8 .. c392v16 .. c392v17 .. c392v12 .. c392v19
      end
    end
    c392v12 = vT[17]
    c392v12 = c392v12.Ternary
    if c392v11 ~= c392v5 then
      c392v13 = false
    else
      c392v13 = true
    end
    c392v14 = ""
    c392v15 = "<br>"
    c392v12 = c392v12(c392v13, c392v14, c392v15)
    c392v13 = vT[17]
    c392v13 = c392v13.Ternary
    c392v14 = c392v6[c392v11]
    c392v14 = c392v14.IsSentinel
    c392v13 = c392v13(c392v14, c392v1, c392v0)
    c392v14 = IsNull
    c392v14 = c392v14(c392v13)
    c392v21 = c392v15[c392v18]
    c392v21 = c392v21.mItemType
    c392v19 = table.insert
    c392v19(c392v7, c392v21)
    c392v19 = IsNull
    c392v19 = c392v19(c392v4)
    if not c392v19 then
      c392v19 = c392v6[c392v11]
      c392v19 = c392v19.IsSentinel
      if not c392v19 then
        c392v21 = c392v15[c392v18]
        c392v21 = c392v21.mItemType
        c392v19 = c392v4:Name__1dc35bd2(c392v21)
        c392v20 = IsNull
        c392v20 = c392v20(c392v19)
        if not c392v20 then
          c392v20 = 0
          c392v21 = c392v15[c392v18]
          c392v21 = c392v21.mXP
          if c392v21 ~= nil then
            c392v21 = gGameConfig
            c392v23 = c392v15[c392v18]
            c392v23 = c392v23.mXP
            c392v24 = c392v15[c392v18]
            c392v24 = c392v24.mItemType
            c392v20 = c392v21:GetItemLevel(c392v23, c392v24)
          end
          c392v22 = "<font color=\"#FloatingContent\">"
          c392v29 = Localize
          c392v30 = c392v19:GetLocalizeTag()
          c392v30 = c392v30:c_str()
          c392v31 = {}
          c392v23 = c392v29(c392v30, c392v31)
          c392v24 = " ["
          c392v29 = tostring
          c392v25 = c392v29(c392v20)
          c392v26 = "]"
          c392v28 = "</font>"
          c392v8 = c392v8 .. c392v22 .. c392v23 .. c392v24 .. c392v25 .. c392v26 .. c392v12 .. c392v28
        else
          c392v21 = "<font color=\"#FloatingContent\">---"
          c392v23 = "</font>"
          c392v8 = c392v8 .. c392v21 .. c392v12 .. c392v23
        end
      end
    end
    if c392v1 ~= nil then
      c392v9 = { IsSentinel = true, Id = nil }
      c392v10 = 0
      c392v9.Id = c392v10
      c392v7 = table.insert
      c392v7(c392v6, c392v9)
      c392v9 = { IsSentinel = true, Id = nil }
      c392v10 = 2
      c392v9.Id = c392v10
      c392v7 = table.insert
      c392v7(c392v6, c392v9)
    end
    c392v7 = {}
    c392v8 = nil
    c392v9 = IsNull
    c392v9 = c392v9(c392v4)
    if not c392v9 then
      c392v8 = "<p>"
    end
    c392v11 = 1
    c392v9 = #c392v6
    c392v10 = 1
    if c392v8 ~= nil then
      c392v10 = "</p>"
      c392v8 = c392v8 .. c392v10
    end
    do return c392v7, c392v8 end
  end
  vT[152] = function(c393v0, c393v1, c393v2, c393v3, c393v4)
    local c393v5
    c393v5 = vT[151]
    do return c393v5(c393v0, c393v1, c393v2, c393v3, c393v4) end
  end
  GetPresetInfo = vT[152]
  vT[152] = function(c394v0)
    local c394v1, c394v2, c394v3, c394v4, c394v5, c394v6, c394v7, c394v8, c394v9, c394v10, c394v11, c394v12
    local p38 = 0
    if p38 == 0 then
      c394v1 = c394v0.mCount
      c394v2 = 0
      c394v3 = c394v0.mGoal
      c394v4 = c394v0.mPersonal
      if c394v4 then
        p38 = 2
      else
        p38 = 1
      end
    end
    if p38 == 1 then
      c394v4 = c394v0.mInvasion
      if not c394v4 then
        p38 = 24
      else
        p38 = 2
      end
    end
    if p38 == 2 then
      c394v4 = c394v0.mTag
      c394v5 = Symbol
      c394v6 = "HeatFissure"
      c394v5 = c394v5(c394v6)
      if c394v4 ~= c394v5 then
        p38 = 4
      else
        p38 = 3
      end
    end
    if p38 == 3 then
      c394v1 = 0
      p38 = 4
    end
    if p38 == 4 then
      c394v4 = gGameData
      c394v5 = IsNull
      c394v5 = c394v5(c394v4)
      if c394v5 then
        p38 = 23
      else
        p38 = 5
      end
    end
    if p38 == 5 then
      c394v5 = nil
      c394v8 = c394v0.mClanGoal
      c394v7 = #c394v8
      c394v8 = 0
      if c394v8 < c394v7 then
        p38 = 7
      else
        p38 = 6
      end
    end
    if p38 == 6 then
      c394v6 = false
      p38 = 8
    end
    if p38 == 7 then
      c394v6 = true
      p38 = 8
    end
    if p38 == 8 then
      if not c394v6 then
        p38 = 11
      else
        p38 = 9
      end
    end
    if p38 == 9 then
      c394v7 = c394v4:GetGuildId()
      if c394v7 == "" then
        p38 = 11
      else
        p38 = 10
      end
    end
    if p38 == 10 then
      c394v5 = c394v4:Name__1cbba7bf()
      p38 = 12
    end
    if p38 == 11 then
      c394v5 = c394v4:GetPersonalGoalProgress()
      p38 = 12
    end
    if p38 == 12 then
      c394v9 = 1
      c394v7 = #c394v5
      c394v8 = 1
      if (c394v8 > 0 and c394v9 > c394v7) or (c394v8 < 0 and c394v9 < c394v7) then
        p38 = 24
      else
        p38 = 13
      end
    end
    if p38 == 13 then
      c394v11 = c394v5[c394v9]
      c394v11 = c394v11.mId
      c394v10 = tostring
      c394v10 = c394v10(c394v11)
      c394v12 = c394v0.mId
      c394v11 = tostring
      c394v11 = c394v11(c394v12)
      if c394v10 ~= c394v11 then
        p38 = 21
      else
        p38 = 14
      end
    end
    if p38 == 14 then
      c394v10 = c394v0.mBest
      if not c394v10 then
        p38 = 16
      else
        p38 = 15
      end
    end
    if p38 == 15 then
      c394v10 = c394v5[c394v9]
      c394v1 = c394v10.mBest
      p38 = 20
    end
    if p38 == 16 then
      c394v10 = c394v5[c394v9]
      c394v10 = c394v10.mCount
      c394v11 = c394v0.mGoal
      if c394v10 <= c394v11 then
        p38 = 19
      else
        p38 = 17
      end
    end
    if p38 == 17 then
      c394v10 = c394v0.mBonusGoal
      c394v11 = 0
      if c394v10 <= c394v11 then
        p38 = 19
      else
        p38 = 18
      end
    end
    if p38 == 18 then
      c394v3 = c394v0.mBonusGoal
      p38 = 19
    end
    if p38 == 19 then
      c394v10 = c394v5[c394v9]
      c394v1 = c394v10.mCount
      p38 = 20
    end
    if p38 == 20 then
      c394v10 = c394v5[c394v9]
      c394v2 = c394v10.mBest
      do return c394v1, c394v2, c394v3 end
    end
    if p38 == 21 then
      p38 = 22
    end
    if p38 == 22 then
      do return c394v1, c394v2, c394v3 end
    end
    if p38 == 23 then
      c394v5 = print
      c394v6 = "GetPersonalGoalProgress: profile or gamedata is nil"
      c394v5(c394v6)
      p38 = 24
    end
    if p38 == 24 then
      do return c394v1, c394v2, c394v3 end
    end
  end
  GetPersonalGoalProgress = vT[152]
  vT[152] = function(c395v0)
    local c395v1, c395v2, c395v3, c395v4, c395v5, c395v6, c395v7, c395v8, c395v9, c395v10, c395v11, c395v12, c395v13, c395v14, c395v15, c395v16, c395v17, c395v18, c395v19, c395v20
    local c56 = -1
    repeat
      local c55 = -1
      repeat
        c395v6 = 0
        c395v7 = ipairs
        c395v7, c395v8, c395v9 = c395v7(c395v1)
        for c395v10, c395v11 in c395v7, c395v8, c395v9 do
          c395v13 = c395v11.mId
          c395v12 = tostring
          c395v12 = c395v12(c395v13)
          c395v14 = c395v0.mId
          c395v13 = tostring
          c395v13 = c395v13(c395v14)
          if c395v12 == c395v13 then
            c55 = 29
            break
          end
          c395v1 = gGameData
          c395v1 = c395v1:GetGuildId()
          if c395v1 == "" then
            c395v1 = nil
            do return c395v1 end
          end
          c395v1 = gGameData
          c395v1 = c395v1:Name__1cbba7bf()
          c395v2 = nil
          c395v3 = nil
          c395v4 = 0
          c395v5 = nil
          c395v6 = c395v0.mTag
          c395v7 = JADE_SHADOWS_GOAL_TAG
          if c395v6 == c395v7 then
            c395v2 = JADE_SHADOWS_EVENT_TROPHY_REWARD_THRESHOLDS
            c395v7 = "/Lotus/Language/EntratiLab/EntratiGeneral/EntratiEventTrophyTierNone"
            c395v8 = "/Lotus/Language/EntratiLab/EntratiGeneral/EntratiEventTrophyTierOne"
            c395v9 = "/Lotus/Language/EntratiLab/EntratiGeneral/EntratiEventTrophyTierTwo"
            c395v10 = "/Lotus/Language/EntratiLab/EntratiGeneral/EntratiEventTrophyTierThree"
            c395v11 = "/Lotus/Language/EntratiLab/EntratiGeneral/EntratiEventTrophyTierFour"
            c395v3 = {c395v7, c395v8, c395v9, c395v10, c395v11}
          else
            c395v6 = c395v0.mTag
            c395v7 = DUVIRI_MURMUR_EVENT_GOAL_TAG
            if c395v6 == c395v7 then
              c395v2 = DUVIRI_MURMUR_EVENT_TROPHY_REWARD_THRESHOLDS
              c395v7 = "/Lotus/Language/EntratiLab/EntratiGeneral/EntratiEventTrophyTierNone"
              c395v8 = "/Lotus/Language/DojoDecosDuviri/DuviriMurmurEventTrophyClay"
              c395v9 = "/Lotus/Language/DojoDecosDuviri/DuviriMurmurEventTrophyBronze"
              c395v10 = "/Lotus/Language/DojoDecosDuviri/DuviriMurmurEventTrophySilver"
              c395v11 = "/Lotus/Language/DojoDecosDuviri/DuviriMurmurEventTrophyGold"
              c395v3 = {c395v7, c395v8, c395v9, c395v10, c395v11}
            else
              c395v6 = c395v0.mTag
              c395v7 = SHADOWGRAPHER_EVENT_GOAL_TAG
              if c395v6 == c395v7 then
                c395v2 = SHADOWGRAPHER_EVENT_TROPHY_REWARD_THRESHOLDS
                c395v7 = "/Lotus/Language/EntratiLab/EntratiGeneral/EntratiEventTrophyTierNone"
                c395v8 = "/Lotus/Language/DojoDecosEvents/ShadowgrapherEventPewterTrophy"
                c395v9 = "/Lotus/Language/DojoDecosEvents/ShadowgrapherEventBronzeTrophy"
                c395v10 = "/Lotus/Language/DojoDecosEvents/ShadowgrapherEventSilverTrophy"
                c395v11 = "/Lotus/Language/DojoDecosEvents/ShadowgrapherEventGoldTrophy"
                c395v3 = {c395v7, c395v8, c395v9, c395v10, c395v11}
              else
                c395v7 = "/Lotus/Language/EntratiLab/EntratiGeneral/EntratiEventTrophyTierNone"
                c395v8 = "/Lotus/Language/EntratiLab/EntratiGeneral/EntratiEventTrophyTierOne"
                c395v9 = "/Lotus/Language/EntratiLab/EntratiGeneral/EntratiEventTrophyTierTwo"
                c395v10 = "/Lotus/Language/EntratiLab/EntratiGeneral/EntratiEventTrophyTierThree"
                c395v11 = "/Lotus/Language/EntratiLab/EntratiGeneral/EntratiEventTrophyTierFour"
                c395v3 = {c395v7, c395v8, c395v9, c395v10, c395v11}
              end
            end
          end
          c395v6 = IsNull
          c395v6 = c395v6(c395v2)
          if not c395v6 then
            c55 = 10
            break
          end
        end
        if c55 ~= -1 then break end
        break
      until true
      if c55 == 29 then
        c395v13 = c395v11.mCount
        c395v15 = #c395v3
        c395v14 = c395v15 - 1
        c395v12 = math.min
        c395v6 = c395v12(c395v13, c395v14)
        c56 = 31
        do break end
      end
      break
    until true
    if c56 == 31 then
      c395v10 = Localize
      c395v11 = "/Lotus/Language/EntratiLab/EntratiGeneral/EntratiEventClanScore"
      c395v12 = false
      c395v7 = c395v10(c395v11, c395v12)
      c395v8 = ": "
      c395v9 = Localize
      c395v11 = c395v6 + 1
      c395v10 = c395v3[c395v11]
      c395v11 = false
      c395v9 = c395v9(c395v10, c395v11)
      c395v5 = c395v7 .. c395v8 .. c395v9
    elseif c56 == 10 then
      c395v6 = gGameData
      c395v6 = c395v6:Name__1cbba7bf()
      c395v7 = gGameData
      c395v7 = c395v7:GetGuildTier()
      c395v8 = c395v2[c395v7]
      c395v9 = 0
      c395v10 = 1
      c395v11 = c395v8[1]
      c395v12 = IsNull
      c395v12 = c395v12(c395v6)
      if not c395v12 then
        c395v14 = 1
        c395v12 = #c395v6
        c395v13 = 1
        for c395v14 = c395v14, c395v12, c395v13 do
          c395v16 = c395v6[c395v14]
          c395v16 = c395v16.mId
          c395v15 = tostring
          c395v15 = c395v15(c395v16)
          c395v17 = c395v0.mId
          c395v16 = tostring
          c395v16 = c395v16(c395v17)
          if c395v15 == c395v16 then break end
          if c395v15 == c395v16 then
            c395v17 = 1
            c395v15 = #c395v8
            c395v16 = 1
            for c395v17 = c395v17, c395v15, c395v16 do
              c395v20 = #c395v3
              c395v18 = math.min
              c395v10 = c395v18(c395v17, c395v20)
              c395v18 = c395v8[c395v17]
              c395v19 = c395v6[c395v14]
              c395v19 = c395v19.mCount
              if c395v19 < c395v18 then break end
              c395v9 = c395v18
              c395v10 = c395v10 + 1
              if c395v19 < c395v18 then
                c395v19 = c395v6[c395v14]
                c395v19 = c395v19.mCount
                c395v4 = c395v19 - c395v9
                c395v11 = c395v18 - c395v9
              else
              end
            end
          end
        end
      end
      c395v12 = c395v3[c395v10]
      c395v13 = #c395v3
      if c395v13 <= c395v10 then
        c395v16 = Localize
        c395v17 = "/Lotus/Language/EntratiLab/EntratiGeneral/EntratiEventClanScore"
        c395v18 = false
        c395v13 = c395v16(c395v17, c395v18)
        c395v14 = ": "
        c395v15 = Localize
        c395v17 = false
        c395v15 = c395v15(c395v12, c395v17)
        c395v5 = c395v13 .. c395v14 .. c395v15
        do return c395v5 end
      end
      c395v13 = c395v0.mTag
      c395v14 = JADE_SHADOWS_GOAL_TAG
      if c395v13 == c395v14 then
        c395v17 = Localize
        c395v19 = false
        c395v13 = c395v17(c395v12, c395v19)
        c395v14 = " "
        c395v17 = Localize
        c395v18 = "/Lotus/Language/EntratiLab/EntratiGeneral/EntratiEventClanScore"
        c395v19 = false
        c395v15 = c395v17(c395v18, c395v19)
        c395v16 = ": "
        c395v5 = c395v13 .. c395v14 .. c395v15 .. c395v16
        c395v19 = tostring
        c395v14 = c395v19(c395v4)
        c395v15 = "/"
        c395v19 = tostring
        c395v16 = c395v19(c395v11)
        c395v17 = " "
        c395v18 = Localize
        c395v19 = "/Lotus/Language/JadeShadows/AscensionEventResourceItemName"
        c395v20 = false
        c395v18 = c395v18(c395v19, c395v20)
        c395v5 = c395v5 .. c395v14 .. c395v15 .. c395v16 .. c395v17 .. c395v18
        do return c395v5 end
      end
      c395v13 = c395v0.mTag
      c395v14 = DUVIRI_MURMUR_EVENT_GOAL_TAG
      if c395v13 == c395v14 then
        c395v17 = Localize
        c395v18 = "/Lotus/Language/EntratiLab/EntratiGeneral/EntratiEventClanScore"
        c395v19 = false
        c395v13 = c395v17(c395v18, c395v19)
        c395v14 = ": "
        c395v17 = Localize
        c395v19 = false
        c395v15 = c395v17(c395v12, c395v19)
        c395v16 = "\r\n"
        c395v5 = c395v13 .. c395v14 .. c395v15 .. c395v16
        c395v19 = tostring
        c395v14 = c395v19(c395v4)
        c395v15 = "/"
        c395v19 = tostring
        c395v16 = c395v19(c395v11)
        c395v17 = " "
        c395v18 = Localize
        c395v19 = "/Lotus/Language/Isleweaver/DuviriMurmurItemEvent"
        c395v20 = false
        c395v18 = c395v18(c395v19, c395v20)
        c395v5 = c395v5 .. c395v14 .. c395v15 .. c395v16 .. c395v17 .. c395v18
        do return c395v5 end
      end
      c395v13 = c395v0.mTag
      c395v14 = SHADOWGRAPHER_EVENT_GOAL_TAG
      if c395v13 == c395v14 then
        c395v17 = Localize
        c395v18 = "/Lotus/Language/EntratiLab/EntratiGeneral/EntratiEventClanScore"
        c395v19 = false
        c395v13 = c395v17(c395v18, c395v19)
        c395v14 = ": "
        c395v17 = Localize
        c395v19 = false
        c395v15 = c395v17(c395v12, c395v19)
        c395v16 = "\r\n"
        c395v5 = c395v13 .. c395v14 .. c395v15 .. c395v16
        c395v19 = tostring
        c395v14 = c395v19(c395v4)
        c395v15 = "/"
        c395v19 = tostring
        c395v16 = c395v19(c395v11)
        c395v17 = " "
        c395v18 = Localize
        c395v19 = "/Lotus/Language/Shadowgrapher/ShadowgrapherEventResourceName"
        c395v20 = false
        c395v18 = c395v18(c395v19, c395v20)
        c395v5 = c395v5 .. c395v14 .. c395v15 .. c395v16 .. c395v17 .. c395v18
        do return c395v5 end
      end
    end
    do return c395v5 end
  end
  GetEventTrophyProgressLabel = vT[152]
  vT[152] = function(c396v0)
    local c396v1, c396v2, c396v3, c396v4, c396v5, c396v7, c396v8, c396v9, c396v10, c396v11, c396v12, c396v13, c396v14, c396v16, c396v17, c396v18
    c396v2 = c396v0.keyChainName
    c396v1 = IsNull
    c396v1 = c396v1(c396v2)
    c396v1 = c396v0.missionType
    c396v2 = 18
    c396v1 = gGameConfig
    c396v1 = c396v1:Name__0a7f07e3()
    c396v2 = gGameData
    c396v3 = IsNull
    c396v3 = c396v3(c396v2)
    c396v3 = ipairs
    c396v4 = c396v2:GetWorldState()
    c396v4 = c396v4.mGoals
    c396v3, c396v4, c396v5 = c396v3(c396v4)
    for c396v6, c396v7 in c396v3, c396v4, c396v5 do
      c396v8 = c396v7.mTag
      c396v8 = Engine.Name__b38e1642
      c396v9 = c396v7.mActivation
      c396v8 = c396v8(c396v9)
      c396v9 = 0
      c396v8 = Engine.Name__b38e1642
      c396v9 = c396v7.mExpiry
      c396v8 = c396v8(c396v9)
      c396v9 = 0
      c396v8 = c396v0.location
      c396v9 = EMPTY_SYMBOL
      c396v1 = _T
      c396v2 = string.lower
      c396v3 = GetConfigString
      c396v4 = "LotusGameRules.ForceElementalCarrier"
      c396v2 = c396v2(c396v3(c396v4))
      c396v1.DebugElementalCarrier = c396v2
      c396v1 = _T.DebugElementalCarrier
      if c396v1 ~= "" then
        c396v1 = true
        c396v2 = 0
        do return c396v1, c396v2 end
      end
    end
    if not c396v1 then
      local p27 = 11
      if p27 == 11 then
        c396v9 = vT[57]
        c396v9 = c396v9()
        c396v11 = c396v0.location
        c396v9 = c396v9:Name__19dfa8ea(c396v11)
        c396v10 = c396v9.nodeType
        c396v11 = 7
        if c396v10 == c396v11 then
          p27 = 13
        else
          p27 = 12
        end
      end
      if p27 == 12 then
        c396v10 = c396v0.location
        c396v11 = Symbol
        c396v12 = c396v7.mNode
        c396v11 = c396v11(c396v12)
        if c396v10 ~= c396v11 then
          p27 = 14
        else
          p27 = 13
        end
      end
      if p27 == 13 then
        c396v10 = false
        do return c396v10 end
      end
      if p27 == 14 then
        c396v10 = c396v9.region
        c396v11 = c396v7.mRegions
        c396v12 = ipairs
        c396v12, c396v13, c396v14 = c396v12(c396v11)
        p27 = 17
      end
      if p27 == 15 then
        if c396v10 ~= c396v16 then
          p27 = 17
        else
          p27 = 16
        end
      end
      if p27 == 16 then
        c396v17 = true
        c396v18 = 1
        do return c396v17, c396v18 end
      end
      if p27 == 17 then
        p27 = 18
      end
      if p27 == 18 then
      end
    end
    c396v1 = false
    do return c396v1 end
  end
  HasRelayReconstructionEnemy = vT[152]
  vT[152] = function(c397v0, c397v1)
    local c397v2, c397v3, c397v4, c397v5, c397v6, c397v7, c397v8, c397v9, c397v10, c397v11, c397v12, c397v14, c397v15
    local p41 = 0
    if p41 == 0 then
      c397v2 = tostring
      c397v2 = c397v2(c397v1:GetName())
      c397v4 = vT[40]
      c397v3 = c397v4[c397v2]
      c397v6 = vT[14]
      c397v4 = c397v0:IsA(c397v6)
      if not c397v4 then
        p41 = 2
      else
        p41 = 1
      end
    end
    if p41 == 1 then
      c397v6 = vT[15]
      c397v4 = c397v1:IsA(c397v6)
      if c397v4 then
        p41 = 4
      else
        p41 = 2
      end
    end
    if p41 == 2 then
      c397v6 = vT[13]
      c397v4 = c397v0:IsA(c397v6)
      if not c397v4 then
        p41 = 5
      else
        p41 = 3
      end
    end
    if p41 == 3 then
      c397v6 = gLotusMeleeWeaponType
      c397v4 = c397v1:IsA(c397v6)
      if not c397v4 then
        p41 = 5
      else
        p41 = 4
      end
    end
    if p41 == 4 then
      c397v4 = false
      do return c397v4 end
    end
    if p41 == 5 then
      if c397v3 ~= nil then
        p41 = 10
      else
        p41 = 6
      end
    end
    if p41 == 6 then
      c397v6 = gLotusMeleeWeaponType
      c397v4 = c397v1:IsA(c397v6)
      if not c397v4 then
        p41 = 9
      else
        p41 = 7
      end
    end
    if p41 == 7 then
      c397v6 = gLotusHybridWeaponType
      c397v4 = c397v0:IsA(c397v6)
      if not c397v4 then
        p41 = 9
      else
        p41 = 8
      end
    end
    if p41 == 8 then
      c397v4 = true
      do return c397v4 end
    end
    if p41 == 9 then
      do return c397v0:IsA(c397v1) end
    end
    if p41 == 10 then
      c397v4 = nil
      c397v5 = IsWeak
      c397v5 = c397v5(c397v0)
      if not c397v5 then
        p41 = 13
      else
        p41 = 11
      end
    end
    if p41 == 11 then
      c397v5 = string.gsub
      c397v6 = tostring
      c397v6 = c397v6(c397v0:GetFullName())
      c397v7 = "/Lotus/Weapons/"
      c397v8 = "/Lotus/StoreItems/Weapons/"
      c397v5 = c397v5(c397v6, c397v7, c397v8)
      c397v6 = Resource
      c397v6 = c397v6(c397v5)
      c397v7 = IsNull
      c397v7 = c397v7(c397v6)
      if c397v7 then
        p41 = 14
      else
        p41 = 12
      end
    end
    if p41 == 12 then
      c397v4 = c397v6:GetSearchTags()
      p41 = 14
    end
    if p41 == 13 then
      c397v4 = c397v0:GetSearchTags()
      p41 = 14
    end
    if p41 == 14 then
      if c397v4 == nil then
        p41 = 16
      else
        p41 = 15
      end
    end
    if p41 == 15 then
      c397v5 = #c397v4
      if c397v5 ~= 0 then
        p41 = 17
      else
        p41 = 16
      end
    end
    if p41 == 16 then
      do return c397v0:IsA(c397v1) end
    end
    if p41 == 17 then
      c397v5 = c397v4
      c397v6 = nil
      c397v7 = nil
      p41 = 22
    end
    if p41 == 18 then
      c397v10 = c397v3
      c397v11 = nil
      c397v12 = nil
      p41 = 21
    end
    if p41 == 19 then
      if c397v9 ~= c397v14 then
        p41 = 21
      else
        p41 = 20
      end
    end
    if p41 == 20 then
      c397v15 = true
      do return c397v15 end
    end
    if p41 == 21 then
      p41 = 22
    end
    if p41 == 22 then
      p41 = 23
    end
    if p41 == 23 then
      c397v5 = false
      do return c397v5 end
    end
  end
  CheckWeaponMatchesExclusiveWeapon = vT[152]
  vT[152] = function(c398v0, c398v1)
    local c398v2, c398v3, c398v4, c398v5, c398v6, c398v7, c398v8, c398v9, c398v10, c398v11, c398v13
    c398v11 = CheckWeaponMatchesExclusiveWeapon
    c398v11 = c398v11(c398v10, c398v1)
    c398v3 = c398v9
    c398v2:SetWeaponDisabled(c398v9)
    c398v11 = gRegion
    c398v11:DestroyObject(c398v10)
    c398v11 = 5
    if c398v9 == c398v11 then
      c398v13 = 7
      c398v2:SetWeaponEnabled(c398v13)
    end
    for c398v8, c398v9 in c398v5, c398v6, c398v7 do
      c398v8 = 0
      c398v9 = 2
      c398v2:Equip(c398v3, c398v8, c398v9)
      c398v5 = _T
      c398v5.ExclusiveWeaponSlot = c398v3
      do return end
    end
    c398v10 = c398v2:GetWeaponInSlot(c398v9)
    c398v11 = IsNull
    c398v11 = c398v11(c398v10)
    local p24 = 0
    if p24 == 0 then
      c398v2 = gRegion
      c398v2 = c398v2:IsMaster()
      if c398v2 then
        p24 = 2
      else
        p24 = 1
      end
    end
    if p24 == 1 then
      do return end
    end
    if p24 == 2 then
      c398v2 = IsNull
      c398v2 = c398v2(c398v0)
      if c398v2 then
        p24 = 4
      else
        p24 = 3
      end
    end
    if p24 == 3 then
      c398v2 = IsNull
      c398v2 = c398v2(c398v1)
      if not c398v2 then
        p24 = 5
      else
        p24 = 4
      end
    end
    if p24 == 4 then
      do return end
    end
    if p24 == 5 then
      c398v2 = c398v0:InventoryControl()
      c398v3 = 0
      while true do
        c398v7 = 0
        c398v4 = IsNull
        c398v4 = c398v4(c398v2:GetWeaponInHand(c398v7))
        if not c398v4 then break end
        c398v4 = Sleep
        c398v5 = 0
        c398v4(c398v5)
      end
      c398v5 = 0
      c398v6 = 1
      c398v7 = 5
      c398v4 = {c398v5, c398v6, c398v7}
      c398v5 = pairs
      c398v5, c398v6, c398v7 = c398v5(c398v4)
    end
    for c398v8, c398v9 in c398v5, c398v6, c398v7 do
    end
  end
  ApplyWeaponRestriction = vT[152]
  vT[152] = function(c400v0, c400v1)
    local c400v2, c400v3, c400v4, c400v5, c400v6, c400v7, c400v8, c400v9, c400v10, c400v11, c400v13, c400v14, c400v15, c400v16
    c400v2 = IsNull
    c400v2 = c400v2(c400v0)
    if c400v2 then
      do return end
    end
    c400v2 = c400v0:InventoryControl()
    c400v3 = IsNull
    c400v3 = c400v3(c400v2)
    if c400v3 then
      do return end
    end
    c400v3 = gGameRules
    c400v5 = true
    c400v3:SetConsumablesDisabled(c400v5)
    c400v3 = function(c399v0)
      local c399v1, c399v2, c399v3, c399v4, c399v5, c399v6, c399v7, c399v8, c399v9, c399v10, c399v11, c399v12, c399v14
      c399v1 = WeakResource
      c399v2 = "/Lotus/Types/Game/SentinelPrecept"
      c399v1 = c399v1(c399v2)
      c399v4 = 0
      c399v2 = 11
      c399v3 = 1
      for c399v4 = c399v4, c399v2, c399v3 do
        c399v5 = c399v0:GetWeaponInSlot(c399v4)
        c399v6 = IsNull
        c399v6 = c399v6(c399v5)
        if not c399v6 then
          c399v6 = 0
          while true do
            c399v7 = IsNull
            c399v7 = c399v7(c399v5:GetUpgrade(c399v6))
            if c399v7 then break end
            c399v7 = c399v5:GetUpgrade(c399v6)
            c399v10 = gLotusArtifactUpgradeType
            c399v8 = c399v7:IsA(c399v10)
            c399v9 = c399v7:IsA(c399v1)
            c399v12 = gLotusSuitCustomizationType
            c399v10 = c399v7:IsA(c399v12)
            if c399v10 then
              c399v11 = c399v7:GetNumUpgrades()
              c399v12 = 0
              if c399v11 <= c399v12 then
                c399v10 = false
              else
                c399v10 = true
              end
            end
            if not c399v10 then
              if c399v9 then
                c399v11 = c399v7:GetAbility()
                if c399v11 then
                  c399v14 = true
                  c399v11:SetAbilityActivationBlocked(c399v14)
                  c399v11:DeactivateAbility()
                end
              end
              c399v14 = true
              c399v5:RemoveUpgrade(c399v7, c399v14)
            else
              if c399v10 then
                c399v5:UnapplyUpgrade(c399v7)
              end
              c399v6 = c399v6 + 1
            end
          end
        end
      end
      do return end
    end
    c400v3(c400v2)
    c400v4 = gGameRules
    c400v6 = gLotusAuraUpgradeType
    c400v4 = c400v4:Name__2cd0b208(c400v6, c400v0)
    c400v5 = pairs
    c400v5, c400v6, c400v7 = c400v5(c400v4)
    for c400v8, c400v9 in c400v5, c400v6, c400v7 do
      c400v10 = gRegion
      c400v10:DestroyObject(c400v9)
    end
    c400v5 = c400v0:DamageControl()
    c400v5:SetShield(c400v5:GetMaxShield())
    c400v6 = nil
    c400v7 = c400v0:Name__2d897740()
    c400v8 = IsNull
    c400v8 = c400v8(c400v7)
    for c400v8, c400v9 in c400v5, c400v6, c400v7 do
      c400v8 = c400v7:GetLoadOut()
      c400v8 = c400v8.mPetType
      c400v9 = 5
      if c400v8 ~= c400v9 then
        c400v9 = gGameRules
        c400v9 = c400v9:Name__41aa2454()
        if c400v9 then
          c400v9 = false
          while true do
            c400v10 = IsNull
            c400v10 = c400v10(c400v6)
            if (not c400v10 or c400v9) then break end
            c400v10 = Sleep
            c400v11 = 0
            c400v10(c400v11)
            c400v10 = c400v7:GetLoadOut()
            c400v10 = c400v10:Name__8650b3c3()
            if c400v10 then
              c400v11 = gGameRules
              c400v13 = c400v0:GetUIName()
              c400v14 = true
              c400v15 = c400v7:GetLoadOut()
              c400v15 = c400v15:Name__8650b3c3()
              c400v16 = true
              c400v11 = c400v11:Name__1c2b7340(c400v13, c400v14, c400v15, c400v16)
              c400v10 = not c400v11
            end
            c400v9 = c400v10
            c400v6 = c400v2:GetSentinel()
            if (not (c400v1 == true) and c400v1 ~= nil) then break end
          end
          c400v10 = IsNull
          c400v10 = c400v10(c400v6)
          if not c400v10 then
            c400v3(c400v6:InventoryControl())
          end
        end
      end
    end
    c400v8 = IsNull
    c400v8 = c400v8(c400v6)
    if not c400v8 then
      c400v8 = c400v6:DamageControl()
      c400v8:SetShield(c400v8:GetMaxShield())
    end
    do return end
  end
  ApplyModlessLoadout = vT[152]
  vT[152] = function()
    local c401v0, c401v1, c401v2, c401v3
    local p7 = 0
    if p7 == 0 then
      c401v1 = gGameRules
      c401v0 = IsNull
      c401v0 = c401v0(c401v1)
      if c401v0 then
        p7 = 6
      else
        p7 = 1
      end
    end
    if p7 == 1 then
      c401v0 = gGameRules
      c401v2 = gLotusGameRulesType
      c401v0 = c401v0:IsA(c401v2)
      if not c401v0 then
        p7 = 6
      else
        p7 = 2
      end
    end
    if p7 == 2 then
      c401v0 = gGameRules
      c401v0 = c401v0:GetMission()
      c401v1 = IsNull
      c401v1 = c401v1(c401v0)
      if c401v1 then
        p7 = 6
      else
        p7 = 3
      end
    end
    if p7 == 3 then
      c401v1 = c401v0.goalTag
      c401v2 = Symbol
      c401v3 = "NoMods"
      c401v2 = c401v2(c401v3)
      if c401v1 == c401v2 then
        p7 = 5
      else
        p7 = 4
      end
    end
    if p7 == 4 then
      c401v1 = c401v0.goalTag
      c401v2 = Symbol
      c401v3 = "WaterFight"
      c401v2 = c401v2(c401v3)
      if c401v1 ~= c401v2 then
        p7 = 6
      else
        p7 = 5
      end
    end
    if p7 == 5 then
      c401v1 = true
      do return c401v1 end
    end
    if p7 == 6 then
      c401v0 = false
      do return c401v0 end
    end
  end
  IsNoModsMode = vT[152]
  vT[152] = function(c402v0, c402v1)
    local c402v2, c402v3, c402v4, c402v5
    c402v2 = IsNull
    c402v2 = c402v2(c402v0)
    if c402v2 then
      do return end
    end
    c402v2 = gGameRules
    c402v4 = gLotusAuraUpgradeType
    c402v2 = c402v2:Name__2cd0b208(c402v4, c402v0)
    c402v3 = pairs
    c402v3, c402v4, c402v5 = c402v3(c402v2)
    for c402v6, c402v7 in c402v3, c402v4, c402v5 do
      if c402v1 then
        c402v7:EnableAura()
      else
        c402v7:DisableAura()
      end
    end
    do return end
  end
  ToggleAvatarAuras = vT[152]
  vT[152] = function(c403v0)
    local c403v1
    c403v1 = IsNull
    c403v1 = c403v1(c403v0)
    if not c403v1 then
      c403v1 = c403v0:GetLoadOut()
      c403v1 = c403v1.mIsFirstTimeInNode
      do return c403v1 end
    end
    c403v1 = false
    do return c403v1 end
  end
  IsFirstTimeInNode = vT[152]
  vT[152] = function(c404v0, c404v1)
    local c404v2, c404v3
    c404v3 = _T.PendingEquippingGearItem
    c404v2 = IsNull
    c404v2 = c404v2(c404v3)
    if c404v2 then
      c404v2 = _T
      c404v3 = {}
      c404v2.PendingEquippingGearItem = c404v3
    end
    c404v2 = _T.PendingEquippingGearItem
    c404v3 = c404v0:GetInstance()
    c404v2[c404v3] = c404v1
    do return end
  end
  SetEquippingGearItem = vT[152]
  vT[152] = function(c405v0)
    local c405v1, c405v2, c405v3
    c405v2 = _T.PendingEquippingGearItem
    c405v1 = IsNull
    c405v1 = c405v1(c405v2)
    if c405v1 then
      c405v1 = false
      do return c405v1 end
    end
    c405v2 = _T.PendingEquippingGearItem
    c405v3 = c405v0:GetInstance()
    c405v1 = c405v2[c405v3]
    do return c405v1 end
  end
  IsEquippingGearItem = vT[152]
  vT[152] = function(c407v0, c407v1, c407v2, c407v3, c407v4, c407v5, c407v6)
    local c407v7, c407v8, c407v9, c407v10, c407v11
    c407v8 = _G
    c407v8 = c407v8.UIMovie_LoadoutSelectMovie
    c407v7 = IsNull
    c407v7 = c407v7(c407v8)
    if not c407v7 then
      c407v7 = IsNull
      c407v7 = c407v7(c407v2)
      if not c407v7 then
        c407v7 = nil
        c407v8 = _T
        c407v8.SelectLoadOutType = c407v3
        c407v8 = _T
        c407v8.CurrentLoadoutId = c407v6
        c407v8 = IsNull
        c407v8 = c407v8(c407v0)
        if not c407v8 then
          c407v10 = _G
          c407v10 = c407v10.UIMovie_LoadoutSelectMovie
          c407v7 = c407v0:PushChildMovie(c407v10)
        else
          c407v8 = gFlashMgr
          c407v10 = _G
          c407v10 = c407v10.UIMovie_LoadoutSelectMovie
          c407v7 = c407v8:GotoMovie(c407v10)
        end
        c407v8 = _T
        c407v9 = function(c406v0)
          local c406v1, c406v2
          c406v1 = _T
          c406v2 = nil
          c406v1.LoadoutSelectionDone = c406v2
          c406v2 = c407v4
          c406v1 = IsNull
          c406v1 = c406v1(c406v2)
          if not c406v1 then
            c406v1 = c407v4
            c406v1(c406v0)
          end
          do return end
        end
        c407v8.LoadoutSelectionDone = c407v9
        c407v10 = "SetCallBack"
        c407v11 = "LoadoutSelectionDone"
        c407v7:Execute(c407v10, c407v11)
        do return c407v7 end
      end
    end
    c407v7 = nil
    do return c407v7 end
  end
  ShowLoadoutSelectionMenu = vT[152]
  vT[152] = function(c408v0, c408v1)
    local c408v2, c408v3, c408v4, c408v5, c408v6
    c408v2 = ""
    c408v3 = ""
    c408v4 = 0
    c408v5 = FORTUNA_NODE_TAG
    if c408v1 ~= c408v5 then
      c408v5 = ORB_VALLIS_NODE_TAG
      if c408v1 ~= c408v5 then
        c408v5 = NOKKO_COLONY_NODE_TAG
        if c408v1 ~= c408v5 then
          c408v5 = OROKIN_TOWER_NODE_TAG
          if c408v1 ~= c408v5 then
            c408v5 = ENTRATI_LANDSCAPE_NODE_TAG
            if c408v1 ~= c408v5 then
              c408v5 = ENTRATI_LAB_NODE_TAG
              if c408v1 ~= c408v5 then
                c408v5 = ZARIMAN_NODE_TAG
                if c408v1 == c408v5 then
                  c408v5 = TimeOfDayConstants
                  c408v5 = c408v5.HOURS_PER_SECOND_ZARIMAN
                  c408v6 = 12
                  if c408v0 < c408v6 then
                    c408v6 = 6
                    if c408v6 <= c408v0 then
                      c408v6 = TimeOfDayConstants
                      c408v2 = c408v6.TIME_OF_DAY_LABEL_GRINEER
                      c408v6 = TimeOfDayConstants
                      c408v3 = c408v6.TIME_OF_DAY_LABEL_CORPUS
                      c408v6 = 12 - c408v0
                      c408v4 = c408v6 / c408v5
                      do return c408v2, c408v3, c408v4 end
                    end
                  end
                  c408v6 = TimeOfDayConstants
                  c408v2 = c408v6.TIME_OF_DAY_LABEL_CORPUS
                  c408v6 = TimeOfDayConstants
                  c408v3 = c408v6.TIME_OF_DAY_LABEL_GRINEER
                  c408v6 = 12
                  if c408v6 <= c408v0 then
                    c408v6 = 36 - c408v0
                    c408v4 = c408v6 / c408v5
                    do return c408v2, c408v3, c408v4 end
                  end
                  c408v6 = 12 - c408v0
                  c408v4 = c408v6 / c408v5
                  do return c408v2, c408v3, c408v4 end
                end
                c408v5 = TimeOfDayConstants
                c408v5 = c408v5.HOURS_PER_SECOND_EIDOLON
                c408v6 = 22
                if c408v0 < c408v6 then
                  c408v6 = 6
                  if c408v6 <= c408v0 then
                    c408v6 = TimeOfDayConstants
                    c408v2 = c408v6.TIME_OF_DAY_LABEL_DAY
                    c408v6 = TimeOfDayConstants
                    c408v3 = c408v6.TIME_OF_DAY_LABEL_NIGHT
                    c408v6 = 22 - c408v0
                    c408v4 = c408v6 / c408v5
                    do return c408v2, c408v3, c408v4 end
                  end
                end
                c408v6 = TimeOfDayConstants
                c408v2 = c408v6.TIME_OF_DAY_LABEL_NIGHT
                c408v6 = TimeOfDayConstants
                c408v3 = c408v6.TIME_OF_DAY_LABEL_DAY
                c408v6 = 22
                if c408v6 <= c408v0 then
                  c408v6 = 30 - c408v0
                  c408v4 = c408v6 / c408v5
                  do return c408v2, c408v3, c408v4 end
                end
                c408v6 = 6 - c408v0
                c408v4 = c408v6 / c408v5
                do return c408v2, c408v3, c408v4 end
              end
            end
          end
          c408v5 = TimeOfDayConstants
          c408v5 = c408v5.HOURS_PER_SECOND_ENTRATI
          c408v6 = 22
          if c408v0 < c408v6 then
            c408v6 = 6
            if c408v6 <= c408v0 then
              c408v6 = TimeOfDayConstants
              c408v2 = c408v6.TIME_OF_DAY_LABEL_FASS
              c408v6 = TimeOfDayConstants
              c408v3 = c408v6.TIME_OF_DAY_LABEL_VOME
              c408v6 = 22 - c408v0
              c408v4 = c408v6 / c408v5
              do return c408v2, c408v3, c408v4 end
            end
          end
          c408v6 = TimeOfDayConstants
          c408v2 = c408v6.TIME_OF_DAY_LABEL_VOME
          c408v6 = TimeOfDayConstants
          c408v3 = c408v6.TIME_OF_DAY_LABEL_FASS
          c408v6 = 22
          if c408v6 <= c408v0 then
            c408v6 = 30 - c408v0
            c408v4 = c408v6 / c408v5
            do return c408v2, c408v3, c408v4 end
          end
          c408v6 = 6 - c408v0
          c408v4 = c408v6 / c408v5
          do return c408v2, c408v3, c408v4 end
        end
      end
    end
    c408v5 = TimeOfDayConstants
    c408v5 = c408v5.HOURS_PER_SECOND_VENUS
    c408v6 = 12
    if c408v0 < c408v6 then
      c408v6 = TimeOfDayConstants
      c408v2 = c408v6.TIME_OF_DAY_LABEL_COLD
      c408v6 = TimeOfDayConstants
      c408v3 = c408v6.TIME_OF_DAY_LABEL_WARM
      c408v6 = 12 - c408v0
      c408v4 = c408v6 / c408v5
      do return c408v2, c408v3, c408v4 end
    end
    c408v6 = 18
    if c408v0 < c408v6 then
      c408v6 = TimeOfDayConstants
      c408v2 = c408v6.TIME_OF_DAY_LABEL_WARM
      c408v6 = TimeOfDayConstants
      c408v3 = c408v6.TIME_OF_DAY_LABEL_COLD
      c408v6 = 18 - c408v0
      c408v4 = c408v6 / c408v5
      do return c408v2, c408v3, c408v4 end
    end
    c408v6 = TimeOfDayConstants
    c408v2 = c408v6.TIME_OF_DAY_LABEL_COLD
    c408v6 = TimeOfDayConstants
    c408v3 = c408v6.TIME_OF_DAY_LABEL_WARM
    c408v6 = 36 - c408v0
    c408v4 = c408v6 / c408v5
    do return c408v2, c408v3, c408v4 end
  end
  GetTimeOfDayLabel = vT[152]
  vT[152] = function(c409v0)
    local c409v1, c409v2, c409v3, c409v4
    local p19 = 0
    if p19 == 0 then
      c409v1 = 0
      c409v3 = gGameData
      c409v2 = IsNull
      c409v2 = c409v2(c409v3)
      if c409v2 then
        p19 = 2
      else
        p19 = 1
      end
    end
    if p19 == 1 then
      c409v3 = gGameRules
      c409v2 = IsNull
      c409v2 = c409v2(c409v3)
      if not c409v2 then
        p19 = 3
      else
        p19 = 2
      end
    end
    if p19 == 2 then
      do return c409v1 end
    end
    if p19 == 3 then
      c409v2 = gGameData
      c409v2 = c409v2:GetWorldState()
      c409v3 = IsNull
      c409v3 = c409v3(c409v2)
      if not c409v3 then
        p19 = 5
      else
        p19 = 4
      end
    end
    if p19 == 4 then
      do return c409v1 end
    end
    if p19 == 5 then
      c409v3 = TimeOfDayConstants
      c409v3 = c409v3.HOURS_PER_SECOND_EIDOLON
      c409v4 = FORTUNA_NODE_TAG
      if c409v0 == c409v4 then
        p19 = 8
      else
        p19 = 6
      end
    end
    if p19 == 6 then
      c409v4 = ORB_VALLIS_NODE_TAG
      if c409v0 == c409v4 then
        p19 = 8
      else
        p19 = 7
      end
    end
    if p19 == 7 then
      c409v4 = NOKKO_COLONY_NODE_TAG
      if c409v0 ~= c409v4 then
        p19 = 9
      else
        p19 = 8
      end
    end
    if p19 == 8 then
      c409v4 = TimeOfDayConstants
      c409v3 = c409v4.HOURS_PER_SECOND_VENUS
      p19 = 15
    end
    if p19 == 9 then
      c409v4 = OROKIN_TOWER_NODE_TAG
      if c409v0 == c409v4 then
        p19 = 12
      else
        p19 = 10
      end
    end
    if p19 == 10 then
      c409v4 = ENTRATI_LANDSCAPE_NODE_TAG
      if c409v0 == c409v4 then
        p19 = 12
      else
        p19 = 11
      end
    end
    if p19 == 11 then
      c409v4 = ENTRATI_LAB_NODE_TAG
      if c409v0 ~= c409v4 then
        p19 = 13
      else
        p19 = 12
      end
    end
    if p19 == 12 then
      c409v4 = TimeOfDayConstants
      c409v3 = c409v4.HOURS_PER_SECOND_ENTRATI
      p19 = 15
    end
    if p19 == 13 then
      c409v4 = ZARIMAN_NODE_TAG
      if c409v0 ~= c409v4 then
        p19 = 15
      else
        p19 = 14
      end
    end
    if p19 == 14 then
      c409v4 = TimeOfDayConstants
      c409v3 = c409v4.HOURS_PER_SECOND_ZARIMAN
      p19 = 15
    end
    if p19 == 15 then
      c409v4 = gGameRules
      c409v1 = c409v4:CalculateTimeOfDay(c409v3)
      do return c409v1 end
    end
  end
  CalculateTimeOfDay = vT[152]
  vT[152] = function(c410v0)
    local c410v1, c410v2, c410v3, c410v4, c410v5, c410v6, c410v7
    c410v1 = 30
    if c410v0 <= c410v1 then
      c410v1 = tostring
      c410v1 = c410v1(c410v0)
      do return c410v1 end
    end
    c410v1 = c410v0 - 30
    c410v2 = gFlashMgr
    c410v2 = c410v2:GetTopMovie()
    c410v3 = "+"
    c410v4 = IsNull
    c410v4 = c410v4(c410v2)
    if not c410v4 then
      c410v6 = "<LEGENDARY_RANK>"
      c410v7 = true
      c410v3 = c410v2:GetLocalized(c410v6, c410v7)
    end
    c410v7 = tostring
    c410v5 = c410v7(c410v1)
    c410v4 = c410v5 .. c410v3
    do return c410v4 end
  end
  vT[153] = function(c411v0)
    local c411v1
    c411v1 = vT[152]
    c411v1 = c411v1(c411v0)
    do return c411v1 end
  end
  ProcessPlayerLevel = vT[153]
  vT[153] = function(c414v0, c414v1, c414v2)
    local c414v3, c414v4, c414v5, c414v6, c414v7, c414v8, c414v9, c414v10, c414v11, c414v12, c414v13, c414v14, c414v15, c414v16, c414v17, c414v18, c414v19, c414v20, c414v21, c414v22, c414v23, c414v25, c414v26, c414v30
    c414v3 = { Name = nil, NameWithRank = nil, WeaponInfo = nil, CompanionInfo = nil, AuraInfo = nil }
    c414v4 = IsNull
    c414v4 = c414v4(c414v1)
    c414v4 = c414v1.name
    c414v5 = cjson.decode
    c414v6 = c414v1.loadout
    c414v5 = c414v5(c414v6)
    c414v6 = IsNull
    c414v6 = c414v6(c414v4)
    c414v6 = IsNull
    c414v6 = c414v6(c414v5)
    c414v13 = c414v11(c414v2)
    c414v13 = IsNull
    c414v13 = c414v13(c414v9)
    c414v13 = IsNull
    c414v13 = c414v13(c414v10)
    c414v13 = ""
    c414v16 = 1
    c414v14 = #c414v10
    c414v15 = 1
    for c414v16 = c414v16, c414v14, c414v15 do
      c414v17 = c414v10[c414v16]
      c414v18 = IsNull
      c414v18 = c414v18(c414v17)
      if not c414v18 then
        c414v18 = c414v17.Type
        if c414v18 then
          c414v18 = c414v17.Type
          c414v18 = c414v18.LocTag
          if c414v18 then
            c414v18 = c414v17.isWeapon
            if c414v18 then
              c414v19 = c414v17.Type
              c414v19 = c414v19.LocTag
              c414v18 = tostring
              c414v18 = c414v18(c414v19)
              c414v19 = Lotus_Game.Name__f1505a54
              c414v19 = c414v19(c414v18)
              if c414v19 ~= "" then
                c414v18 = c414v19
              end
              if c414v19 == "" then
                c414v20 = 1
                if c414v20 < c414v16 then
                  c414v21 = "\n\r"
                  c414v13 = c414v13 .. c414v21
                end
                c414v20 = c414v17.Type
                c414v20 = c414v20.Level
                c414v26 = string.upper
                c414v30 = true
                c414v22 = c414v26(c414v0:GetLocalized(c414v18, c414v30))
                c414v23 = " ["
                c414v25 = "]"
                c414v13 = c414v13 .. c414v22 .. c414v23 .. c414v20 .. c414v25
              end
            else
              c414v18 = WeakResource
              c414v19 = c414v17.Type
              c414v18 = c414v18(c414v19)
              c414v19 = IsNull
              c414v19 = c414v19(c414v18)
              if not c414v19 then
                c414v21 = WeakResource
                c414v22 = "/Lotus/Types/Restoratives/Upgraded/CorruptedKey"
                c414v19 = c414v18:IsA(c414v21(c414v22))
                if c414v19 then
                  c414v19 = 1
                  if c414v19 < c414v16 then
                    c414v20 = "\n\r"
                    c414v13 = c414v13 .. c414v20
                  end
                  c414v19 = GetLocalizedDragonKeyName
                  c414v19 = c414v19(c414v18)
                  c414v13 = c414v13 .. c414v19
                end
              end
            end
          end
        end
      end
    end
    c414v13 = c414v5.ARCHWING
    if c414v13 then
      c414v13 = c414v5.HasArchwing
      if c414v13 then
        c414v15 = 1
        c414v16 = c414v5.ARCHWING
        c414v13 = #c414v16
        c414v14 = 1
        for c414v15 = c414v15, c414v13, c414v14 do
          c414v18 = { Type = nil, isWeapon = true }
          c414v20 = c414v5.ARCHWING
          c414v22 = 0
          c414v21 = c414v22 + c414v15
          c414v19 = c414v20[c414v21]
          c414v18.Type = c414v19
          c414v16 = table.insert
          c414v16(c414v10, c414v18)
        end
      end
    end
    c414v6 = 0
    c414v8 = c414v5.PlayerLevel
    c414v7 = IsNull
    c414v7 = c414v7(c414v8)
    if not c414v7 then
      c414v7 = c414v5.PlayerLevel
      if c414v7 ~= "" then
        c414v6 = c414v5.PlayerLevel
      end
    end
    c414v7 = c414v4
    c414v14 = "<RANK_"
    c414v16 = ">"
    c414v13 = c414v14 .. c414v6 .. c414v16
    c414v14 = true
    c414v9 = c414v0:GetLocalized(c414v13, c414v14)
    c414v10 = vT[152]
    c414v10 = c414v10(c414v6)
    c414v8 = c414v9 .. c414v10
    c414v10 = " "
    c414v7 = c414v7 .. c414v10 .. c414v8
    c414v3.Name = c414v4
    c414v3.NameWithRank = c414v7
    c414v9 = nil
    c414v10 = vT[17]
    c414v10 = c414v10.Ternary
    c414v12 = c414v5.NORMAL_PVP
    if c414v12 == nil then
      c414v11 = false
    else
      c414v11 = true
    end
    c414v12 = c414v5.NORMAL_PVP
    c414v13 = c414v5.NORMAL
    c414v9 = c414v10(c414v11, c414v12, c414v13)
    c414v11 = { Type = nil, isWeapon = true }
    c414v12 = c414v9[1]
    c414v11.Type = c414v12
    c414v12 = { Type = nil }
    c414v13 = c414v5.DragonKey
    c414v12.Type = c414v13
    c414v13 = { Type = nil, isWeapon = true }
    c414v14 = c414v9[3]
    c414v13.Type = c414v14
    c414v14 = { Type = nil, isWeapon = true }
    c414v15 = c414v9[2]
    c414v14.Type = c414v15
    c414v15 = { Type = nil, isWeapon = true }
    c414v16 = c414v9[4]
    c414v15.Type = c414v16
    c414v10 = {c414v11, c414v12, c414v13, c414v14, c414v15}
    c414v11 = function(c412v0)
      local c412v1, c412v3
      c412v1 = IsNull
      c412v1 = c412v1(c412v0)
      if c412v1 then
        c412v1 = false
        do return c412v1 end
      end
      c412v1 = false
      local c412v2 = c412v0.missionType
      c412v3 = 28
      if c412v2 == c412v3 then
        c412v1 = false
        c412v2 = c412v0.sortieId
        if c412v2 == "" then
          c412v2 = c412v0.goalTag
          c412v3 = EMPTY_SYMBOL
          if c412v2 ~= c412v3 then
            c412v1 = false
          else
            c412v1 = true
          end
        end
      end
      do return c412v1 end
    end
    c414v12 = function(c413v0)
      local c413v1
      c413v1 = IsNull
      c413v1 = c413v1(c413v0)
      if c413v1 then
        c413v1 = false
        do return c413v1 end
      end
      c413v1 = c413v0.archwingRequired
      do return c413v1 end
    end
    c414v13 = c414v12(c414v2)
    if c414v4 then
      c414v3.WeaponInfo = c414v13
    end
    if c414v4 then
      c414v13 = ""
      c414v14 = c414v5.KubrowName
      if c414v14 ~= "" then
        c414v14 = vT[17]
        c414v14 = c414v14.IsUGCRestricted
        c414v14 = c414v14()
        if c414v14 then
          c414v16 = "/Lotus/Language/Menu/CategoryKubrow"
          c414v17 = false
          c414v13 = c414v0:GetLocalized(c414v16, c414v17)
        else
          c414v13 = c414v5.KubrowName
        end
      else
        c414v15 = c414v5.SENTINEL
        c414v14 = IsNull
        c414v14 = c414v14(c414v15)
        if not c414v14 then
          c414v16 = c414v5.SENTINEL
          c414v15 = c414v16[1]
          c414v15 = c414v15.LocTag
          c414v14 = tostring
          c414v14 = c414v14(c414v15)
          c414v15 = IsNull
          c414v15 = c414v15(c414v14)
          if not c414v15 then
            c414v15 = Lotus_Game.Name__f1505a54
            c414v15 = c414v15(c414v14)
            if c414v15 ~= "" then
              c414v13 = c414v15
            else
              c414v18 = tostring
              c414v18 = c414v18(c414v14)
              c414v19 = false
              c414v13 = c414v0:GetLocalized(c414v18, c414v19)
            end
          end
        end
      end
      if c414v13 ~= "" then
        c414v15 = c414v5.SENTINEL
        c414v14 = IsNull
        c414v14 = c414v14(c414v15)
        if not c414v14 then
          c414v15 = c414v5.SENTINEL
          c414v14 = c414v15[1]
          c414v14 = c414v14.Level
          c414v15 = "\n\r"
          c414v17 = " ["
          c414v19 = "]"
          c414v13 = c414v15 .. c414v13 .. c414v17 .. c414v14 .. c414v19
        end
      end
      c414v3.CompanionInfo = c414v13
      c414v17 = c414v5.AuraName
      c414v16 = tostring
      c414v16 = c414v16(c414v17)
      c414v17 = false
      c414v14 = c414v0:GetLocalized(c414v16, c414v17)
      if c414v14 ~= "" then
        c414v15 = "\n\r"
        c414v16 = string.upper
        c414v16 = c414v16(c414v14)
        c414v14 = c414v15 .. c414v16
      end
      c414v18 = c414v5.ExtraAuraName
      c414v17 = tostring
      c414v17 = c414v17(c414v18)
      c414v18 = false
      c414v15 = c414v0:GetLocalized(c414v17, c414v18)
      if c414v15 ~= "" then
        c414v16 = "\n\r"
        c414v17 = string.upper
        c414v17 = c414v17(c414v15)
        c414v15 = c414v16 .. c414v17
      end
      c414v3.AuraInfo = c414v14
      c414v3.ExtraAuraInfo = c414v15
    end
    do return c414v3 end
  end
  GetSquadMemberLoadoutInfo = vT[153]
  vT[153] = function(c415v0)
    local c415v1, c415v2, c415v3
    c415v1 = Engine.IsMobile
    c415v1 = c415v1()
    if not c415v1 then
      c415v1 = Engine.IsLowMemoryDevice
      c415v1 = c415v1()
      if not c415v1 then
        c415v1 = false
        do return c415v1 end
      end
    end
    c415v1 = IsNull
    c415v1 = c415v1(c415v0)
    if c415v1 then
      local p13 = 4
      if p13 == 4 then
        c415v2 = c415v0.name
        c415v1 = IsNull
        c415v1 = c415v1(c415v2)
        if c415v1 then
        else
          p13 = 5
        end
      end
      if p13 == 5 then
        c415v2 = c415v0.missionType
        c415v1 = IsNull
        c415v1 = c415v1(c415v2)
        if c415v1 then
        else
          p13 = 6
        end
      end
      if p13 == 6 then
        c415v1 = c415v0.missionType
        c415v2 = 28
        if c415v1 == c415v2 then
          p13 = 8
        else
          p13 = 7
        end
      end
      if p13 == 7 then
        c415v1 = IsDuviriNode
        c415v3 = c415v0.name
        c415v2 = tostring
        c415v2 = c415v2(c415v3)
        c415v1 = c415v1(c415v2)
        if not c415v1 then
        else
          p13 = 8
        end
      end
      if p13 == 8 then
        c415v1 = true
        do return c415v1 end
      end
    end
    c415v1 = false
    do return c415v1 end
  end
  IsHighMemoryMission = vT[153]
  vT[153] = function()
    local c416v0, c416v1, c416v2, c416v3, c416v4, c416v5
    c416v0 = Engine.IsMobile
    c416v0 = c416v0()
    if not c416v0 then
      c416v0 = false
      do return c416v0 end
    end
    c416v0 = Engine.Name__90e031b2
    c416v0 = c416v0()
    c416v1 = 7776000
    if c416v0 < c416v1 then
      c416v0 = print
      c416v1 = "No Review: time"
      c416v0(c416v1)
      c416v0 = false
      do return c416v0 end
    end
    c416v0 = Engine.Name__d5ecd948
    c416v0 = c416v0()
    c416v1 = print
    c416v3 = "Review progress: "
    c416v4 = tostring
    c416v4 = c416v4(c416v0)
    c416v2 = c416v3 .. c416v4
    c416v1(c416v2)
    c416v1 = 5
    if c416v1 < c416v0 then
      c416v1 = print
      c416v2 = "No Review: done"
      c416v1(c416v2)
      c416v1 = false
      do return c416v1 end
    end
    if c416v0 == 5 then
      c416v1 = Engine.MoveWarRecon
      c416v2 = c416v0 + 1
      c416v1(c416v2)
      c416v1 = Engine.Name__3398c9a2
      c416v1()
      c416v1 = true
      do return c416v1 end
    end
    c416v1 = Engine.MoveWarRecon
    c416v2 = c416v0 + 1
    c416v1(c416v2)
    c416v1 = print
    c416v3 = "Review progress: "
    c416v5 = c416v0 + 1
    c416v4 = tostring
    c416v4 = c416v4(c416v5)
    c416v2 = c416v3 .. c416v4
    c416v1(c416v2)
    c416v1 = false
    do return c416v1 end
  end
  ShouldShowAppReviewRequest = vT[153]
  vT[153] = function()
    local c419v0, c419v1
    c419v0 = _T
    c419v1 = function(c417v0)
      local c417v1, c417v2, c417v3, c417v4, c417v5, c417v6, c417v7, c417v8, c417v9, c417v10, c417v11, c417v12, c417v13, c417v14, c417v15, c417v16, c417v17
      c417v8 = c417v0.mEventTransmissionTag
      c417v9 = EMPTY_SYMBOL
      c417v8 = gGameData
      c417v8 = c417v8:GetWorldState()
      c417v9 = c417v8.mGoals
      c417v12 = 1
      c417v10 = #c417v9
      c417v11 = 1
      for c417v12 = c417v12, c417v10, c417v11 do
        c417v13 = c417v9[c417v12]
        c417v14 = Engine.Name__b38e1642
        c417v15 = c417v13.mActivation
        c417v14 = c417v14(c417v15)
        c417v15 = 0
        if c417v14 <= c417v15 then
          c417v14 = Engine.Name__b38e1642
          c417v15 = c417v13.mExpiry
          c417v14 = c417v14(c417v15)
          c417v15 = 0
          if c417v15 < c417v14 then
            c417v14 = c417v13.mTag
            c417v15 = c417v0.mEventStageTag
            if c417v14 == c417v15 then
              c417v14 = c417v0.mTransmissionSet
              c417v16 = c417v0.mEventTransmissionTag
              c417v3 = c417v14:GetTransmission(c417v16)
              c417v6 = false
            end
          end
        end
      end
      c417v1 = _T.SkipVendorDialog
      if c417v1 then
        c417v2 = _T.SkipVendorDialog
        c417v3 = c417v0.mSpeakerName
        c417v1 = c417v2[c417v3]
      end
      c417v2 = type
      c417v2 = c417v2(c417v1)
      if c417v2 == "function" then
        c417v1 = c417v1(c417v0)
      end
      c417v3 = c417v0.mTransmissionSet
      c417v2 = IsNull
      c417v2 = c417v2(c417v3)
      if not ((not (c417v2) and not c417v1)) then
        do return end
      end
      c417v2 = _T
      c417v3 = true
      c417v2.BlockAmbientTransmissions = c417v3
      c417v2 = {}
      c417v3 = vT[135]
      c417v3(c417v0, c417v2)
      c417v3 = c417v0.mTransmissionSet
      c417v5 = Symbol
      c417v6 = "FirstVisit"
      c417v3 = c417v3:GetTransmission(c417v5(c417v6))
      c417v4 = Symbol
      c417v5 = "FirstVisitIntro"
      c417v4 = c417v4(c417v5)
      c417v5 = c417v0.mSpeakerName
      c417v7 = IsNull
      c417v7 = c417v7(c417v3)
      c417v6 = not c417v7
      if c417v6 then
        c417v7 = gGameData
        c417v9 = Symbol
        c417v7 = c417v7:HasCompletedNodeIntro(c417v9(c417v5))
        c417v6 = not c417v7
      end
      if not c417v6 then
        c417v7 = HasCompletedNewWar
        c417v7 = c417v7()
        if c417v7 then
          c417v7 = c417v0.mTransmissionSet
          c417v9 = Symbol
          c417v10 = "PostNewWar"
          c417v3 = c417v7:GetTransmission(c417v9(c417v10))
          c417v7 = IsNull
          c417v7 = c417v7(c417v3)
          if not c417v7 then
            c417v9 = "PostNewWar"
            c417v7 = c417v5 .. c417v9
            c417v8 = gGameData
            c417v10 = Symbol
            c417v8 = c417v8:HasCompletedNodeIntro(c417v10(c417v7))
            if not c417v8 then
              c417v6 = true
              c417v5 = c417v7
            end
          end
        end
      end
      c417v7 = false
      if not c417v6 then
        c417v8 = gGameData
        c417v10 = Symbol
        c417v11 = "CoHFinaleCinematic"
        c417v8 = c417v8:HasCompletedNodeIntro(c417v10(c417v11))
        if c417v8 then
          c417v8 = c417v0.mTransmissionSet
          c417v10 = Symbol
          c417v11 = "PostCoHFinaleCin"
          c417v3 = c417v8:GetTransmission(c417v10(c417v11))
          c417v8 = IsNull
          c417v8 = c417v8(c417v3)
          if not c417v8 then
            c417v10 = "PostCoHFinaleCin"
            c417v8 = c417v5 .. c417v10
            c417v9 = gGameData
            c417v11 = Symbol
            c417v9 = c417v9:HasCompletedNodeIntro(c417v11(c417v8))
            if not c417v9 then
              c417v6 = true
              c417v5 = c417v8
            else
              c417v7 = true
            end
          end
        end
      end
      c417v8 = c417v2.Loved
      if not c417v1 then
        if not c417v6 then
          c417v8 = c417v0.mTransmissionSet
          c417v10 = Symbol
          c417v11 = "FirstLoved"
          c417v3 = c417v8:GetTransmission(c417v10(c417v11))
          c417v4 = nil
          c417v9 = "Loved"
          c417v5 = c417v5 .. c417v9
          c417v9 = IsNull
          c417v9 = c417v9(c417v3)
          c417v8 = not c417v9
          if c417v8 then
            c417v9 = gGameData
            c417v11 = Symbol
            c417v9 = c417v9:HasCompletedNodeIntro(c417v11(c417v5))
            c417v8 = not c417v9
          end
          c417v6 = c417v8
        end
        c417v9 = c417v0.mHubNpc
        c417v8 = IsNull
        c417v8 = c417v8(c417v9)
        if not c417v8 then
          c417v8 = c417v0.mHubNpc
          c417v10 = false
          c417v8:SetMaterialsDisabled(c417v10)
          c417v8 = c417v0.mHubNpc
          c417v10 = Symbol
          c417v11 = "LovedIntro"
          c417v8:Name__9fea1a0d(c417v10(c417v11))
          c417v8 = true
          c417v0.IsUnmasked = c417v8
        end
      end
      c417v10 = c417v2.Level
      c417v8 = 0
      c417v9 = -1
      for c417v10 = c417v10, c417v8, c417v9 do
        c417v12 = "FirstRank"
        c417v13 = tostring
        c417v13 = c417v13(c417v10)
        c417v11 = c417v12 .. c417v13
        c417v12 = c417v0.mTransmissionSet
        c417v14 = Symbol
        c417v12 = c417v12:GetTransmission(c417v14(c417v11))
        if c417v12 then break end
        if c417v12 then
          c417v13 = c417v5 .. c417v11
          c417v15 = IsNull
          c417v15 = c417v15(c417v12)
          c417v14 = not c417v15
          if c417v14 then
            c417v15 = gGameData
            c417v17 = Symbol
            c417v15 = c417v15:HasCompletedNodeIntro(c417v17(c417v13))
            c417v14 = not c417v15
          end
          c417v6 = c417v14
          if c417v6 then
            c417v3 = c417v12
            c417v5 = c417v13
          end
        end
      end
      if not c417v6 then
        c417v10 = c417v2.Level
        c417v8 = 0
        c417v9 = -1
        for c417v10 = c417v10, c417v8, c417v9 do
          c417v11 = Symbol
          c417v13 = "IntroRank"
          c417v14 = tostring
          c417v14 = c417v14(c417v10)
          c417v12 = c417v13 .. c417v14
          c417v11 = c417v11(c417v12)
          c417v12 = c417v0.mTransmissionSet
          c417v3 = c417v12:GetTransmission(c417v11)
          c417v12 = IsNull
          c417v12 = c417v12(c417v3)
        end
        c417v8 = IsNull
        c417v8 = c417v8(c417v3)
        local p114 = 39
        if p114 == 39 then
          c417v8 = c417v2.Level
          if c417v8 ~= 0 then
            p114 = 42
          else
            p114 = 40
          end
        end
        if p114 == 40 then
          c417v8 = c417v2.Reputation
          if c417v8 ~= 0 then
            p114 = 42
          else
            p114 = 41
          end
        end
        if p114 == 41 then
          c417v8 = c417v0.mTransmissionSet
          c417v10 = Symbol
          c417v11 = "Intro"
          c417v3 = c417v8:GetTransmission(c417v10(c417v11))
        end
        if p114 == 42 then
          c417v8 = c417v2.Loved
          if c417v8 then
            p114 = 44
          else
            p114 = 43
          end
        end
        if p114 == 43 then
          c417v8 = c417v0.mTransmissionSet
          c417v10 = Symbol
          c417v11 = "Welcome"
          c417v3 = c417v8:GetTransmission(c417v10(c417v11))
        end
        if p114 == 44 then
          c417v9 = c417v0.mTransmissionSet
          c417v11 = Symbol
          c417v12 = "Loved"
          c417v8 = {c417v9:GetTransmission(c417v11(c417v12))}
          if not c417v7 then
            p114 = 47
          else
            p114 = 45
          end
        end
        if p114 == 45 then
          c417v9 = c417v0.mTransmissionSet
          c417v11 = Symbol
          c417v12 = "LovedCoH"
          c417v9 = c417v9:GetTransmission(c417v11(c417v12))
          c417v10 = IsNull
          c417v10 = c417v10(c417v9)
          if c417v10 then
            p114 = 47
          else
            p114 = 46
          end
        end
        if p114 == 46 then
          c417v10 = table.insert
          c417v10(c417v8, c417v9)
          p114 = 47
        end
        if p114 == 47 then
          c417v9 = #c417v8
          if c417v9 == 0 then
          else
            p114 = 48
          end
        end
        if p114 == 48 then
          c417v9 = math.random
          c417v10 = #c417v8
          c417v9 = c417v9(c417v10)
          c417v3 = c417v8[c417v9]
        end
        c417v4 = nil
      end
      c417v8 = c417v0.mEventStageTag
      c417v9 = EMPTY_SYMBOL
      c417v8 = c417v0.IntroTransFunction
      if c417v8 ~= "" then
        c417v9 = _T
        c417v10 = c417v0.IntroTransFunction
        c417v8 = c417v9[c417v10]
        if c417v8 ~= nil then
          c417v9 = _T
          c417v10 = c417v0.IntroTransFunction
          c417v8 = c417v9[c417v10]
          c417v8 = c417v8(c417v0, c417v6)
          if c417v8 ~= nil then
            c417v9 = c417v0.mTransmissionSet
            c417v3 = c417v9:GetTransmission(c417v8)
          end
        end
      end
      c417v8 = IsNull
      c417v8 = c417v8(c417v3)
      if not c417v8 then
        c417v11 = nil
        c417v13 = true
        c417v0:PlayDialog(c417v3, c417v11, c417v6, c417v13, c417v4)
        if c417v6 then
          c417v9 = gGameData
          c417v8 = IsNull
          c417v8 = c417v8(c417v9)
          if not c417v8 then
            c417v8 = gGameData
            c417v10 = Symbol
            c417v8:SetNodeIntroCompleted(c417v10(c417v5))
          end
        end
      end
      do return end
    end
    c419v0.OnVendorConversationStarted = c419v1
    c419v0 = _T
    c419v1 = function(c418v0)
      local c418v1, c418v2, c418v3, c418v4, c418v5, c418v6, c418v7, c418v8, c418v9
      c418v1 = {}
      c418v2 = vT[135]
      c418v2(c418v0, c418v1)
      c418v2 = c418v1.Loved
      if c418v2 then
        c418v3 = c418v0.mHubNpc
        c418v2 = IsNull
        c418v2 = c418v2(c418v3)
        if not c418v2 then
          c418v2 = c418v0.IsUnmasked
          if c418v2 then
            c418v2 = c418v0.mHubNpc
            c418v4 = Symbol
            c418v5 = "LovedOutro"
            c418v2:Name__9fea1a0d(c418v4(c418v5))
            c418v2 = Sleep
            c418v3 = 0.5
            c418v2(c418v3)
            c418v2 = c418v0.mHubNpc
            c418v4 = true
            c418v2:SetMaterialsDisabled(c418v4)
          end
        end
      end
      c418v2 = _T
      c418v3 = nil
      c418v2.BlockAmbientTransmissions = c418v3
      c418v3 = c418v0.mTransmissionSet
      c418v2 = IsNull
      c418v2 = c418v2(c418v3)
      local p38 = 5
      if p38 == 5 then
        c418v2 = c418v0.mSkipEndTrans
        if c418v2 then
        else
          p38 = 6
        end
      end
      if p38 == 6 then
        c418v2 = _T.SkipVendorDialog
        if not c418v2 then
          p38 = 9
        else
          p38 = 7
        end
      end
      if p38 == 7 then
        c418v3 = _T.SkipVendorDialog
        c418v4 = c418v0.mSpeakerName
        c418v2 = c418v3[c418v4]
        if not c418v2 then
          p38 = 9
        else
        end
      end
      if p38 == 9 then
        c418v2 = _T.SkipConversationByeTransmission
        if c418v2 then
          p38 = 21
        else
          p38 = 10
        end
      end
      if p38 == 10 then
        c418v2 = nil
        c418v5 = c418v1.Level
        c418v3 = 0
        c418v4 = -1
        if (c418v4 > 0 and c418v5 > c418v3) or (c418v4 < 0 and c418v5 < c418v3) then
          p38 = 13
        else
          p38 = 11
        end
      end
      if p38 == 11 then
        c418v6 = Symbol
        c418v8 = "Bye"
        c418v9 = tostring
        c418v9 = c418v9(c418v5)
        c418v7 = c418v8 .. c418v9
        c418v6 = c418v6(c418v7)
        c418v7 = c418v0.mTransmissionSet
        c418v2 = c418v7:GetTransmission(c418v6)
        c418v7 = IsNull
        c418v7 = c418v7(c418v2)
        p38 = 13
      end
      if p38 == 13 then
        c418v3 = c418v0.ExitTransFunction
        if c418v3 == "" then
          p38 = 17
        else
          p38 = 14
        end
      end
      if p38 == 14 then
        c418v4 = _T
        c418v5 = c418v0.ExitTransFunction
        c418v3 = c418v4[c418v5]
        if c418v3 == nil then
          p38 = 17
        else
          p38 = 15
        end
      end
      if p38 == 15 then
        c418v4 = _T
        c418v5 = c418v0.ExitTransFunction
        c418v3 = c418v4[c418v5]
        c418v3 = c418v3(c418v0)
        if c418v3 == nil then
          p38 = 17
        else
          p38 = 16
        end
      end
      if p38 == 16 then
        c418v4 = c418v0.mTransmissionSet
        c418v2 = c418v4:GetTransmission(c418v3)
        p38 = 17
      end
      if p38 == 17 then
        c418v3 = IsNull
        c418v3 = c418v3(c418v2)
        if not c418v3 then
          p38 = 19
        else
          p38 = 18
        end
      end
      if p38 == 18 then
        c418v3 = c418v0.mTransmissionSet
        c418v5 = Symbol
        c418v6 = "Bye"
        c418v2 = c418v3:GetTransmission(c418v5(c418v6))
        p38 = 19
      end
      if p38 == 19 then
        c418v3 = IsNull
        c418v3 = c418v3(c418v2)
        if c418v3 then
          p38 = 21
        else
          p38 = 20
        end
      end
      if p38 == 20 then
        c418v6 = nil
        c418v7 = false
        c418v8 = true
        c418v0:PlayDialog(c418v2, c418v6, c418v7, c418v8)
        p38 = 21
      end
      if p38 == 21 then
        c418v2 = _T
        c418v3 = nil
        c418v2.SkipConversationByeTransmission = c418v3
        do return end
      end
      for c418v5 = c418v5, c418v3, c418v4 do
      end
      c418v2 = false
      c418v0.mSkipEndTrans = c418v2
      do return end
    end
    c419v0.OnVendorConversationEnded = c419v1
    do return end
  end
  CreateVendorConversationFunctions = vT[153]
  vT[153] = function(c420v0)
    local c420v1, c420v2, c420v3, c420v4, c420v5, c420v6, c420v8, c420v9
    c420v2 = _T.HideHud
    c420v1 = IsNull
    c420v1 = c420v1(c420v2)
    if c420v1 then
      c420v1 = _T
      c420v2 = 0
      c420v1.HideHud = c420v2
    end
    c420v1 = _T
    c420v3 = 0
    c420v5 = _T.HideHud
    c420v6 = vT[17]
    c420v6 = c420v6.Ternary
    c420v8 = 1
    c420v9 = -1
    c420v6 = c420v6(c420v0, c420v8, c420v9)
    c420v4 = c420v5 + c420v6
    c420v2 = math.max
    c420v2 = c420v2(c420v3, c420v4)
    c420v1.HideHud = c420v2
    c420v1 = print
    c420v3 = "DBG: HudVis "
    c420v4 = _T.HideHud
    c420v2 = c420v3 .. c420v4
    c420v1(c420v2)
    do return end
  end
  RegisterHideHud = vT[153]
  vT[153] = function(c421v0)
    local c421v1, c421v2, c421v3, c421v4, c421v5, c421v6, c421v8, c421v9
    c421v2 = _T.HideHudMinimap
    c421v1 = IsNull
    c421v1 = c421v1(c421v2)
    if c421v1 then
      c421v1 = _T
      c421v2 = 0
      c421v1.HideHudMinimap = c421v2
    end
    c421v1 = _T
    c421v3 = 0
    c421v5 = _T.HideHudMinimap
    c421v6 = vT[17]
    c421v6 = c421v6.Ternary
    c421v8 = 1
    c421v9 = -1
    c421v6 = c421v6(c421v0, c421v8, c421v9)
    c421v4 = c421v5 + c421v6
    c421v2 = math.max
    c421v2 = c421v2(c421v3, c421v4)
    c421v1.HideHudMinimap = c421v2
    do return end
  end
  RegisterHideHudMinimap = vT[153]
  vT[153] = function(c422v0)
    local c422v1, c422v2, c422v3, c422v4, c422v5, c422v6, c422v8, c422v9
    c422v2 = _T.HideNotifications
    c422v1 = IsNull
    c422v1 = c422v1(c422v2)
    if c422v1 then
      c422v1 = _T
      c422v2 = 0
      c422v1.HideNotifications = c422v2
    end
    c422v1 = _T
    c422v3 = 0
    c422v5 = _T.HideNotifications
    c422v6 = vT[17]
    c422v6 = c422v6.Ternary
    c422v8 = 1
    c422v9 = -1
    c422v6 = c422v6(c422v0, c422v8, c422v9)
    c422v4 = c422v5 + c422v6
    c422v2 = math.max
    c422v2 = c422v2(c422v3, c422v4)
    c422v1.HideNotifications = c422v2
    do return end
  end
  RegisterHideNotifications = vT[153]
  vT[153] = function(c423v0)
    local c423v1, c423v2, c423v3, c423v4, c423v5, c423v6, c423v8, c423v9
    c423v2 = _T.HideMapRedux
    c423v1 = IsNull
    c423v1 = c423v1(c423v2)
    if c423v1 then
      c423v1 = _T
      c423v2 = 0
      c423v1.HideMapRedux = c423v2
    end
    c423v1 = _T
    c423v3 = 0
    c423v5 = _T.HideMapRedux
    c423v6 = vT[17]
    c423v6 = c423v6.Ternary
    c423v8 = 1
    c423v9 = -1
    c423v6 = c423v6(c423v0, c423v8, c423v9)
    c423v4 = c423v5 + c423v6
    c423v2 = math.max
    c423v2 = c423v2(c423v3, c423v4)
    c423v1.HideMapRedux = c423v2
    do return end
  end
  RegisterHideStarChart = vT[153]
  vT[153] = function(c424v0)
    local c424v1, c424v2, c424v3, c424v4, c424v5, c424v6, c424v8, c424v9
    c424v2 = _T.HideSquadOverlay
    c424v1 = IsNull
    c424v1 = c424v1(c424v2)
    if c424v1 then
      c424v1 = _T
      c424v2 = 0
      c424v1.HideSquadOverlay = c424v2
    end
    c424v1 = _T
    c424v3 = 0
    c424v5 = _T.HideSquadOverlay
    c424v6 = vT[17]
    c424v6 = c424v6.Ternary
    c424v8 = 1
    c424v9 = -1
    c424v6 = c424v6(c424v0, c424v8, c424v9)
    c424v4 = c424v5 + c424v6
    c424v2 = math.max
    c424v2 = c424v2(c424v3, c424v4)
    c424v1.HideSquadOverlay = c424v2
    do return end
  end
  RegisterHideSquadOverlay = vT[153]
  vT[153] = function(c425v0)
    local c425v1, c425v2, c425v3, c425v4, c425v5, c425v6, c425v8, c425v9
    c425v2 = _T.HideEOM
    c425v1 = IsNull
    c425v1 = c425v1(c425v2)
    if c425v1 then
      c425v1 = _T
      c425v2 = 0
      c425v1.HideEOM = c425v2
    end
    c425v1 = _T
    c425v3 = 0
    c425v5 = _T.HideEOM
    c425v6 = vT[17]
    c425v6 = c425v6.Ternary
    c425v8 = 1
    c425v9 = -1
    c425v6 = c425v6(c425v0, c425v8, c425v9)
    c425v4 = c425v5 + c425v6
    c425v2 = math.max
    c425v2 = c425v2(c425v3, c425v4)
    c425v1.HideEOM = c425v2
    do return end
  end
  RegisterHideEOM = vT[153]
  vT[153] = function(c426v0, c426v1, c426v2)
    local c426v3, c426v4, c426v5, c426v6, c426v7, c426v8, c426v9, c426v10
    c426v3 = IsNull
    c426v3 = c426v3(c426v1:GetLocalPlayerAvatar())
    if not c426v3 then
      c426v3 = c426v1:GetLocalPlayerAvatar()
      c426v3 = c426v3:CameraControl()
      c426v3 = c426v3:GetCameraSpot()
      c426v4 = IsNull
      c426v4 = c426v4(c426v3)
      if not c426v4 then
        c426v6 = c426v3:GetPosition()
        c426v8 = c426v3:GetPosition()
        c426v10 = c426v0:Name__12d56d21()
        c426v9 = c426v10 * 200
        c426v7 = c426v8 + c426v9
        c426v8 = nil
        c426v4 = c426v1:RaycastEntity(c426v6, c426v7, c426v8)
        c426v5 = IsNull
        c426v5 = c426v5(c426v4)
        if not c426v5 then
          c426v5 = c426v4:IsA(c426v2)
          if c426v5 then
            do return c426v4 end
          end
        end
      end
    end
    c426v3 = nil
    do return c426v3 end
  end
  GetEntityUnderCursor = vT[153]
  vT[153] = function(c427v0, c427v1, c427v2)
    local c427v3, c427v4, c427v5, c427v6, c427v7, c427v8, c427v9, c427v10
    c427v3 = {}
    c427v6 = 16
    c427v4 = table.insert
    c427v4(c427v3, c427v6)
    c427v4 = _T.DojoMgr
    c427v10 = c427v6[c427v9]
    if c427v10 == c427v4 then
      c427v10 = true
      do return c427v10 end
    end
    c427v4 = type
    c427v4 = c427v4(c427v1)
    if c427v4 == "string" then
      c427v4 = MongoId
      c427v1 = c427v4(c427v1)
    end
    c427v4 = gPlayerProfileMgr
    c427v6 = 0
    c427v4 = c427v4:GetPlayerProfile(c427v6)
    c427v4 = c427v4:GetAccountIDString()
    c427v5 = _T.DojoMgr.mDojo
    c427v5 = c427v5:GetComponent(c427v1)
    c427v6 = _T.DojoMgr
    c427v9 = "decorators"
    c427v6 = c427v6:GetComponentSetting(c427v5, c427v9)
    c427v9 = 1
    c427v7 = #c427v6
    c427v8 = 1
    for c427v9 = c427v9, c427v7, c427v8 do
    end
    if not c427v0 then
      c427v4 = LogBug
      c427v5 = "Missing componentId for HasDojoArchitectPermission"
      c427v4(c427v5)
    end
    if not c427v0 then
      c427v6 = 1024
      c427v4 = table.insert
      c427v4(c427v3, c427v6)
    end
    c427v6 = 1
    c427v4 = #c427v3
    c427v5 = 1
    for c427v6 = c427v6, c427v4, c427v5 do
      c427v7 = gGameData
      c427v9 = c427v3[c427v6]
      c427v7 = c427v7:HavePermission(c427v9)
      if c427v7 then break end
      if c427v7 then
        c427v7 = true
        do return c427v7 end
      end
    end
    c427v4 = false
    do return c427v4 end
  end
  HasDojoArchitectPermission = vT[153]
  vT[153] = function(c428v0, c428v1, c428v2)
    local c428v3, c428v4, c428v5, c428v6, c428v7, c428v8, c428v9, c428v10, c428v11, c428v12, c428v13
    c428v13 = c428v12:IsValid()
    if not c428v2 then
      c428v13 = c428v10:DistanceToPoint(c428v1)
      if c428v13 < c428v5 then
        c428v4 = c428v10
        c428v5 = c428v13
      end
    end
    c428v13 = c428v12:IsCompleted()
    if c428v13 then
      c428v13 = c428v10:DistanceToPoint(c428v1)
      if c428v13 < c428v5 then
        c428v4 = c428v10
        c428v5 = c428v13
      end
    end
    c428v3 = _T.DojoMgr
    c428v4 = IsNull
    c428v4 = c428v4(c428v3)
    if c428v4 then
      do return end
    end
    c428v4 = nil
    c428v5 = 1000000
    c428v6 = gRegion
    c428v8 = Symbol
    c428v6 = c428v6:FindTagged(c428v8(c428v0))
    c428v9 = 1
    c428v7 = #c428v6
    c428v8 = 1
    for c428v9 = c428v9, c428v7, c428v8 do
      c428v10 = c428v6[c428v9]
      c428v11 = c428v3:BuildComponentParams(c428v10)
      c428v12 = nil
      c428v13 = c428v11.id
      if c428v13 ~= "" then
        c428v13 = c428v3.mDojo
        c428v12 = c428v13:GetJsonComponent(c428v11)
      end
    end
    do return c428v4 end
  end
  GetDojoConsole = vT[153]
  vT[153] = function(c429v0)
    local c429v1
    if c429v0 ~= 0 then
      c429v1 = false
    else
      c429v1 = true
    end
    do return c429v1 end
  end
  IsCreatorRank = vT[153]
  vT[153] = function(c430v0)
    local c430v1
    c430v1 = true
    if c430v0 ~= 0 then
      if c430v0 ~= 1 then
        c430v1 = false
      else
        c430v1 = true
      end
    end
    do return c430v1 end
  end
  IsWarlordRank = vT[153]
  vT[153] = function(c435v0, c435v1, c435v2, c435v3, c435v4, c435v5, c435v6, c435v7, c435v8)
    local c435v9, c435v10, c435v11, c435v13, c435v14
    local p7 = 0
    if p7 == 0 then
      c435v9 = string.lower
      c435v1 = c435v9(c435v1)
      c435v9 = function(c431v0, c431v1)
        local c431v2, c431v3, c431v4, c431v5, c431v6, c431v7, c431v8, c431v9
        c431v2 = vT[121]
        c431v3 = c435v0
        c431v5 = ""
        c431v6 = 40
        c431v7 = "ConfirmConditionalWord"
        c431v8 = "OSKConfirmConditionalWord"
        c431v9 = { isMultiline = nil, cancelDisabled = nil, forChat = nil, desc = nil }
        c431v9.desc = c431v1
        c431v2, c431v5 = c431v2(c431v3, c431v0, c431v5, c431v6, c431v7, c431v8, c431v9)
        c431v4 = IsNull
        c431v4 = c431v4(c431v5)
        if not c431v4 then
          c431v6 = "SetConditionalWord"
          c431v7 = c435v1
          c431v3:Execute(c431v6, c431v7)
          c431v6 = "SetDialogWidth"
          c431v7 = c435v8
          c431v3:Execute(c431v6, c431v7)
        end
        do return end
      end
      c435v10 = vT[41]
      c435v10 = c435v10()
      c435v11 = function(c432v0, c432v1, c432v2)
        local c432v3, c432v4, c432v5, c432v6, c432v7, c432v9
        local p9 = 0
        if p9 == 0 then
          c432v4 = tonumber
          c432v4 = c432v4(c432v2)
          c432v5 = 4
          if c432v4 == c432v5 then
            p9 = 2
          else
            p9 = 1
          end
        end
        if p9 == 1 then
          c432v3 = false
          p9 = 3
        end
        if p9 == 2 then
          c432v3 = true
          p9 = 3
        end
        if p9 == 3 then
          if c432v3 then
            p9 = 5
          else
            p9 = 4
          end
        end
        if p9 == 4 then
          c432v4 = c435v7
          if not c432v4 then
            p9 = 6
          else
            p9 = 5
          end
        end
        if p9 == 5 then
          c432v4 = c435v0
          c432v6 = c435v5
          c432v9 = tostring
          c432v9 = c432v9(c432v3)
          c432v7 = {c432v0, c432v9}
          c432v4:Name__8b1f0505(c432v6, c432v7)
          p9 = 6
        end
        if p9 == 6 then
          do return end
        end
      end
      c435v10.ConfirmConditionalWord = c435v11
      c435v11 = function(c433v0, c433v1)
        local c433v2, c433v4, c433v5, c433v7, c433v8
        local p4 = 0
        if p4 == 0 then
          if not c433v0 then
            p4 = 2
          else
            p4 = 1
          end
        end
        if p4 == 1 then
          c433v2 = c435v7
          if not c433v2 then
            p4 = 3
          else
            p4 = 2
          end
        end
        if p4 == 2 then
          c433v2 = c435v0
          c433v4 = c435v5
          c433v8 = not c433v0
          c433v7 = tostring
          c433v7 = c433v7(c433v8)
          c433v5 = {c433v1, c433v7}
          c433v2:Name__8b1f0505(c433v4, c433v5)
          p4 = 3
        end
        if p4 == 3 then
          do return end
        end
      end
      c435v10.OSKConfirmConditionalWord = c435v11
      c435v11 = function(c434v0)
        local c434v1, c434v2, c434v3, c434v4, c434v5, c434v6
        c434v1 = tonumber
        c434v1 = c434v1(c434v0)
        c434v2 = 4
        if c434v1 == c434v2 then
          c434v1 = setfenv
          c434v2 = 1
          c434v3 = c435v10
          c434v1(c434v2, c434v3)
          c434v1 = c435v9
          c434v2 = c435v4
          c434v1(c434v2)
          do return end
        end
        c434v1 = c435v7
        if c434v1 then
          c434v1 = c435v0
          c434v3 = c435v5
          c434v5 = ""
          c434v6 = "false"
          c434v4 = {c434v5, c434v6}
          c434v1:Name__8b1f0505(c434v3, c434v4)
        end
        do return end
      end
      c435v10.ConditionalFirstConfirm = c435v11
      c435v11 = Engine.IsConsole
      c435v11 = c435v11()
      if c435v11 then
        p7 = 4
      else
        p7 = 1
      end
    end
    if p7 == 1 then
      c435v11 = Engine.IsMobile
      c435v11 = c435v11()
      if c435v11 then
        p7 = 4
      else
        p7 = 2
      end
    end
    if p7 == 2 then
      c435v11 = Engine.IsSteamDeck
      c435v11 = c435v11()
      if c435v11 then
        p7 = 4
      else
        p7 = 3
      end
    end
    if p7 == 3 then
      c435v11 = Engine.IsBigPic
      c435v11 = c435v11()
      if not c435v11 then
        p7 = 5
      else
        p7 = 4
      end
    end
    if p7 == 4 then
      c435v11 = vT[17]
      c435v11 = c435v11.ShowConfirmMessage
      c435v13 = "ConditionalFirstConfirm"
      c435v14 = 3
      c435v11(c435v3, c435v13, c435v14)
      p7 = 6
    end
    if p7 == 5 then
      c435v9(c435v2, c435v6)
      p7 = 6
    end
    if p7 == 6 then
      do return end
    end
  end
  vT[154] = function(c436v0, c436v1, c436v2, c436v3, c436v4, c436v5, c436v6, c436v7, c436v8)
    local c436v9
    c436v9 = vT[153]
    c436v9(c436v0, c436v1, c436v2, c436v3, c436v4, c436v5, c436v6, c436v7, c436v8)
    do return end
  end
  ShowConditionalWordConfirm = vT[154]
  vT[154] = function(c437v0, c437v1)
    local c437v2, c437v4
    c437v2 = IsNull
    c437v2 = c437v2(c437v0)
    if not c437v2 then
      c437v2 = IsNull
      c437v2 = c437v2(c437v1)
      if not c437v2 then
        c437v4 = "<SECONDARY_FIRE>"
        c437v2 = c437v0:MakeINBomb(c437v4, c437v1)
        if c437v2 ~= "<SECONDARY_FIRE>" then
          c437v2 = "<SECONDARY_FIRE>"
          do return c437v2 end
        end
        c437v4 = "<MELEE_CHANNEL>"
        c437v2 = c437v0:MakeINBomb(c437v4, c437v1)
        if c437v2 ~= "<MELEE_CHANNEL>" then
          c437v2 = "<MELEE_CHANNEL>"
          do return c437v2 end
        end
      end
    end
    c437v2 = "<SECONDARY_FIRE>"
    do return c437v2 end
  end
  GetAltFireKey = vT[154]
  vT[154] = function()
    local c438v0, c438v1, c438v2, c438v3, c438v4, c438v5, c438v6, c438v7, c438v8, c438v9
    c438v2 = gRegion
    c438v1 = IsNull
    c438v1 = c438v1(c438v2)
    if not c438v1 then
      c438v1 = gRegion
      c438v1 = c438v1:GetLocalPlayerAvatar()
      c438v2 = IsNull
      c438v2 = c438v2(c438v1)
      if not c438v2 then
        c438v2 = nil
        c438v3 = IsNull
        c438v3 = c438v3(c438v1:GetZone())
        if not c438v3 then
          c438v4 = c438v1:GetZone()
          c438v3 = IsNull
          c438v3 = c438v3(c438v4:GetZoneAttribs())
          if not c438v3 then
            c438v3 = c438v1:GetZone()
            c438v3 = c438v3:GetZoneAttribs()
            c438v2 = c438v3:GetZoneId()
          end
        end
        c438v3 = IsNull
        c438v3 = c438v3(c438v2)
        if not c438v3 then
          c438v3 = EMPTY_SYMBOL
          if c438v2 ~= c438v3 then
            c438v3 = {}
            c438v5 = ENTRATI_LAB_ZONE_TAG
            c438v4 = tostring
            c438v4 = c438v4(c438v5)
            c438v5 = SOUND_SET_ENTRATILAB
            c438v3[c438v4] = c438v5
            c438v5 = DEIMOS_NECRALISK_ZONE_TAG
            c438v4 = tostring
            c438v4 = c438v4(c438v5)
            c438v5 = SOUND_SET_OROKIN_TOWER
            c438v3[c438v4] = c438v5
            c438v4 = tostring
            c438v4 = c438v4(c438v2)
            c438v0 = c438v3[c438v4]
          end
        end
      end
    end
    if c438v1 then
      local p70 = 9
      if p70 == 9 then
        c438v2 = gGameRules
        c438v1 = IsNull
        c438v1 = c438v1(c438v2)
        if c438v1 then
        else
          p70 = 10
        end
      end
      if p70 == 10 then
        c438v1 = gGameRules
        c438v3 = gLotusBaseGameRulesType
        c438v1 = c438v1:IsA(c438v3)
        if not c438v1 then
        else
          p70 = 11
        end
      end
      if p70 == 11 then
        c438v1 = gGameRules
        c438v1 = c438v1:GetCurrentMissionType()
        c438v2 = 32
        if c438v1 ~= c438v2 then
          p70 = 13
        else
          p70 = 12
        end
      end
      if p70 == 12 then
        c438v0 = SOUND_SET_RAILJACK
      end
      if p70 == 13 then
        c438v1 = gGameRules
        c438v1 = c438v1:GetMission()
        c438v2 = c438v1.faction
        c438v3 = 8
        if c438v2 == c438v3 then
          p70 = 15
        else
          p70 = 14
        end
      end
      if p70 == 14 then
        c438v3 = 9
        if c438v2 ~= c438v3 then
          p70 = 16
        else
          p70 = 15
        end
      end
      if p70 == 15 then
        c438v0 = SOUND_SET_1999
      end
      if p70 == 16 then
        c438v3 = c438v1.missionType
        c438v4 = 43
        if c438v3 == c438v4 then
          c438v0 = SOUND_SET_HELL_TOWER
        else
          c438v3 = c438v1.missionType
          c438v4 = 44
          c438v0 = SOUND_SET_12MIN_WAR
          c438v3 = {}
          c438v5 = CETUS_NODE_TAG
          c438v4 = tostring
          c438v4 = c438v4(c438v5)
          c438v5 = SOUND_SET_EIDOLON
          c438v3[c438v4] = c438v5
          c438v5 = PLAINS_NODE_TAG
          c438v4 = tostring
          c438v4 = c438v4(c438v5)
          c438v5 = SOUND_SET_EIDOLON
          c438v3[c438v4] = c438v5
          c438v5 = ORB_VALLIS_NODE_TAG
          c438v4 = tostring
          c438v4 = c438v4(c438v5)
          c438v5 = SOUND_SET_ORB_VALLIS
          c438v3[c438v4] = c438v5
          c438v5 = NOKKO_COLONY_NODE_TAG
          c438v4 = tostring
          c438v4 = c438v4(c438v5)
          c438v5 = SOUND_SET_NOKKO
          c438v3[c438v4] = c438v5
          c438v5 = FORTUNA_NODE_TAG
          c438v4 = tostring
          c438v4 = c438v4(c438v5)
          c438v5 = SOUND_SET_FORTUNA
          c438v3[c438v4] = c438v5
          c438v5 = OROKIN_TOWER_NODE_TAG
          c438v4 = tostring
          c438v4 = c438v4(c438v5)
          c438v5 = SOUND_SET_OROKIN_TOWER
          c438v3[c438v4] = c438v5
          c438v5 = ENTRATI_LANDSCAPE_NODE_TAG
          c438v4 = tostring
          c438v4 = c438v4(c438v5)
          c438v5 = SOUND_SET_OROKIN_TOWER
          c438v3[c438v4] = c438v5
          c438v5 = ENTRATI_LAB_NODE_TAG
          c438v4 = tostring
          c438v4 = c438v4(c438v5)
          c438v5 = SOUND_SET_ENTRATILAB
          c438v3[c438v4] = c438v5
          c438v5 = ZARIMAN_NODE_TAG
          c438v4 = tostring
          c438v4 = c438v4(c438v5)
          c438v5 = SOUND_SET_ZARIMAN
          c438v3[c438v4] = c438v5
          c438v5 = ZARIMAN_MISSION_A_TAG
          c438v4 = tostring
          c438v4 = c438v4(c438v5)
          c438v5 = SOUND_SET_ZARIMAN
          c438v3[c438v4] = c438v5
          c438v5 = ZARIMAN_MISSION_B_TAG
          c438v4 = tostring
          c438v4 = c438v4(c438v5)
          c438v5 = SOUND_SET_ZARIMAN
          c438v3[c438v4] = c438v5
          c438v5 = ZARIMAN_MISSION_C_TAG
          c438v4 = tostring
          c438v4 = c438v4(c438v5)
          c438v5 = SOUND_SET_ZARIMAN
          c438v3[c438v4] = c438v5
          c438v5 = ZARIMAN_MISSION_D_TAG
          c438v4 = tostring
          c438v4 = c438v4(c438v5)
          c438v5 = SOUND_SET_ZARIMAN
          c438v3[c438v4] = c438v5
          c438v5 = ZARIMAN_MISSION_E_TAG
          c438v4 = tostring
          c438v4 = c438v4(c438v5)
          c438v5 = SOUND_SET_ZARIMAN
          c438v3[c438v4] = c438v5
          c438v5 = APARTMENT_NODE_TAG
          c438v4 = tostring
          c438v4 = c438v4(c438v5)
          c438v5 = SOUND_SET_ZARIMAN
          c438v3[c438v4] = c438v5
          c438v5 = WF1999_MISSION_TAG
          c438v4 = tostring
          c438v4 = c438v4(c438v5)
          c438v5 = SOUND_SET_1999
          c438v3[c438v4] = c438v5
          c438v5 = WF1999_MISSION_SPRING_TAG
          c438v4 = tostring
          c438v4 = c438v4(c438v5)
          c438v5 = SOUND_SET_1999
          c438v3[c438v4] = c438v5
          c438v5 = WF1999_MISSION_SUMMER_TAG
          c438v4 = tostring
          c438v4 = c438v4(c438v5)
          c438v5 = SOUND_SET_1999
          c438v3[c438v4] = c438v5
          c438v5 = WF1999_MISSION_FALL_TAG
          c438v4 = tostring
          c438v4 = c438v4(c438v5)
          c438v5 = SOUND_SET_1999
          c438v3[c438v4] = c438v5
          c438v5 = WF1999_MISSION_WINTER_TAG
          c438v4 = tostring
          c438v4 = c438v4(c438v5)
          c438v5 = SOUND_SET_1999
          c438v3[c438v4] = c438v5
          c438v4 = ipairs
          c438v5 = DUVIRI_MISSION_NODES
          c438v4, c438v5, c438v6 = c438v4(c438v5)
          for c438v7, c438v8 in c438v4, c438v5, c438v6 do
            c438v9 = SOUND_SET_DUVIRI
            c438v3[c438v8] = c438v9
          end
          c438v4 = ipairs
          c438v5 = ENTRATI_LAB_MISSION_NODES
          c438v4, c438v5, c438v6 = c438v4(c438v5)
          for c438v7, c438v8 in c438v4, c438v5, c438v6 do
            c438v9 = SOUND_SET_ENTRATILAB
            c438v3[c438v8] = c438v9
          end
          c438v4 = c438v1.location
          c438v5 = EMPTY_SYMBOL
          if c438v4 == c438v5 then
            c438v5 = c438v1.hubLevelTag
            c438v6 = EMPTY_SYMBOL
            if c438v5 ~= c438v6 then
              c438v4 = c438v1.hubLevelTag
            end
          end
          c438v5 = tostring
          c438v5 = c438v5(c438v4)
          c438v0 = c438v3[c438v5]
          for c438v7, c438v8 in c438v4, c438v5, c438v6 do
          end
        end
      end
    end
    if c438v0 == nil then
      c438v1 = IsTailorShopLevel
      c438v1 = c438v1()
      if c438v1 then
        c438v0 = SOUND_SET_1999
      end
    end
    if c438v0 == nil then
      c438v1 = _G
      c438v1 = c438v1.CachedConquestMissionLastRewards
      if c438v1 ~= nil then
        c438v2 = gGameRules
        c438v1 = IsNull
        c438v1 = c438v1(c438v2)
        if not c438v1 then
          c438v1 = gGameRules
          c438v3 = gLotusAttractModeGameRulesType
          c438v1 = c438v1:IsA(c438v3)
          if c438v1 then
            c438v0 = SOUND_SET_ENTRATILAB
          end
        end
      end
    end
    if c438v0 == nil then
      c438v0 = SOUND_SET_EIDOLON
    end
    do return c438v0 end
  end
  GetActiveSoundSet = vT[154]
  vT[154] = function(c439v0, c439v1, c439v2)
    local c439v3, c439v4, c439v5, c439v6, c439v7, c439v8, c439v9, c439v10
    c439v2 = c439v2 or 0
    c439v3 = c439v1:GetDimensions()
    c439v5 = c439v3.x
    c439v7 = c439v3.y
    c439v6 = c439v7 / 64
    c439v4 = c439v5 / c439v6
    c439v7 = "Title.BookendLeft"
    c439v0:OverrideTexture(c439v7, c439v1)
    c439v7 = "Title.BookendRight"
    c439v0:OverrideTexture(c439v7, c439v1)
    c439v7 = "Title.BookendLeft"
    c439v8 = 14
    c439v0:SetNumberVariable(c439v7, c439v8, c439v4)
    c439v7 = "Title.BookendLeft"
    c439v8 = 15
    c439v9 = 64
    c439v0:SetNumberVariable(c439v7, c439v8, c439v9)
    c439v7 = "Title.BookendLeft"
    c439v8 = 1
    c439v10 = 22
    c439v9 = c439v10 + c439v2
    c439v0:SetNumberVariable(c439v7, c439v8, c439v9)
    c439v7 = "Title.BookendRight"
    c439v8 = 14
    c439v0:SetNumberVariable(c439v7, c439v8, c439v4)
    c439v7 = "Title.BookendRight"
    c439v8 = 15
    c439v9 = 64
    c439v0:SetNumberVariable(c439v7, c439v8, c439v9)
    c439v7 = "Title.BookendRight"
    c439v8 = 1
    c439v10 = 22
    c439v9 = c439v10 + c439v2
    c439v0:SetNumberVariable(c439v7, c439v8, c439v9)
    do return end
  end
  InitializeTitleBookends = vT[154]
  vT[154] = function(c440v0, c440v1)
    local c440v2, c440v3, c440v4, c440v5, c440v6
    c440v2 = c440v1
    if c440v2 == nil then
      c440v3 = gGameRules
      c440v5 = ELITE_ALERT_MISSION_INTERVAL
      c440v2 = c440v3:GetCycleIdx(c440v5)
    end
    c440v3 = GetSeed
    c440v3 = c440v3()
    c440v4 = SetSeed
    c440v5 = Name__6dd598b2
    c440v4(c440v5(c440v2))
    c440v4 = SRandomInt
    c440v5 = 1
    c440v6 = 1000000
    c440v4 = c440v4(c440v5, c440v6)
    c440v5 = SetSeed
    c440v5(c440v3)
    c440v5 = Name__001701c4
    c440v6 = Engine.Name__2333a0b7
    c440v5 = c440v5(c440v6(c440v0))
    c440v6 = c440v5 + c440v4
    do return c440v6, c440v2 end
  end
  GetEliteAlertUpgradeSeed = vT[154]
  vT[154] = function(c441v0, c441v1)
    local c441v2, c441v3, c441v4, c441v5, c441v6, c441v7, c441v8, c441v9
    c441v2 = c441v1
    if c441v2 == nil then
      c441v3 = gGameData
      c441v3 = c441v3:GetWorldState()
      c441v4 = c441v3.mLiteSorties
      if c441v4 ~= nil then
        c441v5 = c441v4[1]
        c441v5 = c441v5.mSeed
        c441v6 = GetSeed
        c441v6 = c441v6()
        c441v7 = SetSeed
        c441v7(c441v5)
        c441v7 = SRandomInt
        c441v8 = 1
        c441v9 = 2
        c441v7(c441v8, c441v9)
        c441v7 = SRandomInt
        c441v8 = 1
        c441v9 = 1000000
        c441v2 = c441v7(c441v8, c441v9)
        c441v7 = SetSeed
        c441v7(c441v6)
      end
    end
    if c441v2 ~= nil then
      c441v3 = Name__001701c4
      c441v4 = Engine.Name__2333a0b7
      c441v3 = c441v3(c441v4(c441v0))
      c441v4 = c441v3 + c441v2
      do return c441v4, c441v2 end
    end
    do return end
  end
  GetLiteSortieUpgradeSeed = vT[154]
  vT[154] = function(c442v0)
    local c442v1, c442v3
    c442v1 = string.find
    c442v3 = "MK1"
    c442v1 = c442v1(c442v0, c442v3)
    if not c442v1 then
      c442v1 = string.find
      c442v3 = "StartingRifle"
      c442v1 = c442v1(c442v0, c442v3)
      if not c442v1 then
        c442v1 = string.find
        c442v3 = "Prime"
        c442v1 = c442v1(c442v0, c442v3)
        if not c442v1 then
          c442v1 = string.find
          c442v3 = "Wraith"
          c442v1 = c442v1(c442v0, c442v3)
          if not c442v1 then
            c442v1 = string.find
            c442v3 = "Vandal"
            c442v1 = c442v1(c442v0, c442v3)
            if not c442v1 then
              c442v1 = string.find
              c442v3 = "Prisma"
              c442v1 = c442v1(c442v0, c442v3)
              if not c442v1 then
                c442v1 = string.find
                c442v3 = "Syndicate"
                c442v1 = c442v1(c442v0, c442v3)
                if not c442v1 then
                  c442v1 = string.find
                  c442v3 = "Bayonet/TnBayonet"
                  c442v1 = c442v1(c442v0, c442v3)
                  if not c442v1 then
                    c442v1 = string.find
                    c442v3 = "Modular"
                    c442v1 = c442v1(c442v0, c442v3)
                    if not c442v1 then
                      c442v1 = string.find
                      c442v3 = "Gear"
                      c442v1 = c442v1(c442v0, c442v3)
                      if not c442v1 then
                        c442v1 = true
                        do return c442v1 end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    c442v1 = false
    do return c442v1 end
  end
  vT[155] = function(c443v0)
    local c443v1
    c443v1 = vT[154]
    do return c443v1(c443v0) end
  end
  IsBaseWeapon = vT[155]
  vT[155] = function(c444v0, c444v1)
    local c444v2, c444v3, c444v4, c444v5, c444v6, c444v7, c444v8, c444v9, c444v10, c444v11, c444v12, c444v13, c444v14, c444v15, c444v16, c444v17, c444v18, c444v19, c444v20, c444v21, c444v22, c444v23, c444v24, c444v25, c444v26, c444v27, c444v28, c444v29
    c444v2 = _G
    c444v2 = c444v2.RollableItemsTypeNameCache
    c444v10 = c444v9:GetProductCategory()
    c444v11 = 0
    c444v11 = 1
    c444v11 = 5
    c444v11 = c444v9:GetLocalizeDescTag()
    c444v11 = c444v11:IsValid()
    if c444v11 then
      c444v11 = c444v9:Name__2c7b3d8f()
      if c444v11 then
        c444v11 = c444v9:ExcludeFromCodex()
        if not c444v11 then
          c444v11 = vT[154]
          c444v11 = c444v11(c444v9:GetFullName())
          if c444v11 then
            c444v12 = _G
            c444v12 = c444v12.RollableItemsTypeNameCache
            c444v12 = c444v12.weapons
            c444v13 = { itemName = nil, category = nil }
            c444v14 = c444v9:GetFullName()
            c444v13.itemName = c444v14
            c444v13.category = c444v10
            c444v11 = table.insert
            c444v11(c444v12, c444v13)
          end
        end
      end
    end
    c444v2 = _G
    c444v3 = {}
    c444v2.RollableItemsTypeNameCache = c444v3
    c444v2 = _G
    c444v2 = c444v2.RollableItemsTypeNameCache
    c444v3 = {}
    c444v2.suits = c444v3
    c444v2 = _G
    c444v2 = c444v2.RollableItemsTypeNameCache
    c444v3 = {}
    c444v2.weapons = c444v3
    c444v2 = gGameRules
    c444v2 = c444v2:GetStoreManifest()
    c444v3 = IsNull
    c444v3 = c444v3(c444v2)
    if c444v3 then
      c444v3 = ""
      c444v4 = WeakResource
      c444v4 = c444v4()
      c444v5 = WeakResource
      c444v5 = c444v5()
      c444v6 = {}
      c444v7 = ""
      c444v8 = {}
      c444v9 = {}
      c444v10 = {}
      c444v11 = 0
      do return c444v3, c444v4, c444v5, c444v6, c444v7, c444v8, c444v9, c444v10, c444v11 end
    end
    c444v5 = WeakResource
    c444v6 = "/Lotus/Types/Game/PowerSuits/PlayerPowerSuit"
    c444v5 = c444v5(c444v6)
    c444v6 = true
    c444v3 = c444v2:GetStoreItemsOfType(c444v5, c444v6)
    c444v4 = pairs
    c444v4, c444v5, c444v6 = c444v4(c444v3)
    for c444v7, c444v8 in c444v4, c444v5, c444v6 do
      c444v9 = c444v8:GetProductCategory()
      c444v10 = 3
      if c444v9 == c444v10 then
        c444v9 = c444v8:ExcludeFromCodex()
        if not c444v9 then
          c444v9 = c444v8:GetFullName()
          c444v10 = string.find
          c444v12 = "Prime"
          c444v10 = c444v10(c444v9, c444v12)
          if not c444v10 then
            c444v10 = string.find
            c444v12 = "Operator"
            c444v10 = c444v10(c444v9, c444v12)
            if not c444v10 then
              c444v10 = string.find
              c444v12 = "Umbra"
              c444v10 = c444v10(c444v9, c444v12)
              if not c444v10 then
                c444v10 = string.find
                c444v12 = "PlayerPowerSuit"
                c444v10 = c444v10(c444v9, c444v12)
                if not c444v10 then
                  c444v11 = _G
                  c444v11 = c444v11.RollableItemsTypeNameCache
                  c444v11 = c444v11.suits
                  c444v10 = table.insert
                  c444v10(c444v11, c444v9)
                end
              end
            end
          end
        end
      end
    end
    c444v6 = gLotusWeaponType
    c444v7 = true
    c444v4 = c444v2:GetStoreItemsOfType(c444v6, c444v7)
    c444v5 = pairs
    c444v5, c444v6, c444v7 = c444v5(c444v4)
    for c444v7, c444v8 in c444v4, c444v5, c444v6 do
    end
    c444v3 = _G
    c444v3 = c444v3.RollableItemsTypeNameCache
    c444v3 = c444v3.suits
    c444v2 = #c444v3
    if c444v2 == 0 then
      c444v2 = ""
      c444v3 = WeakResource
      c444v3 = c444v3()
      c444v4 = WeakResource
      c444v4 = c444v4()
      c444v5 = {}
      c444v6 = ""
      c444v7 = WeakResource
      c444v7 = c444v7()
      c444v8 = WeakResource
      c444v8 = c444v8()
      c444v9 = {}
      c444v10 = 0
      do return c444v2, c444v3, c444v4, c444v5, c444v6, c444v7, c444v8, c444v9, c444v10 end
    end
    c444v2 = GetSeed
    c444v2 = c444v2()
    c444v3 = SetSeed
    c444v4 = Name__6dd598b2
    c444v3(c444v4(c444v1))
    c444v4 = _G
    c444v4 = c444v4.RollableItemsTypeNameCache
    c444v4 = c444v4.suits
    c444v5 = SRandomInt
    c444v6 = 1
    c444v8 = _G
    c444v8 = c444v8.RollableItemsTypeNameCache
    c444v8 = c444v8.suits
    c444v7 = #c444v8
    c444v5 = c444v5(c444v6, c444v7)
    c444v3 = c444v4[c444v5]
    c444v4 = string.gsub
    c444v6 = "/StoreItems"
    c444v7 = ""
    c444v4 = c444v4(c444v3, c444v6, c444v7)
    c444v5 = WeakResource
    c444v5 = c444v5(c444v4)
    c444v6 = string.find
    c444v8 = "/Anti"
    c444v6 = c444v6(c444v4, c444v8)
    if c444v6 then
      c444v10 = 1
      c444v12 = string.len
      c444v12 = c444v12(c444v4)
      c444v11 = c444v12 - 4
      c444v8 = string.sub
      c444v6 = c444v8(c444v4, c444v10, c444v11)
      c444v7 = "Nova"
      c444v4 = c444v6 .. c444v7
    end
    c444v6 = WeakResource
    c444v9 = "BaseSuit"
    c444v7 = c444v4 .. c444v9
    c444v6 = c444v6(c444v7)
    c444v8 = { upgType = nil, upgOp = nil, value = 3, label = "/Lotus/Language/Labels/AVATAR_ABILITY_STRENGTH", itemType = nil }
    c444v9 = 10
    c444v8.upgType = c444v9
    c444v9 = 3
    c444v8.upgOp = c444v9
    c444v8.itemType = c444v6
    c444v9 = { upgType = nil, upgOp = nil, value = 500, label = "/Lotus/Language/Labels/AVATAR_HEALTH_MAX", checkSuitType = nil }
    c444v10 = 79
    c444v9.upgType = c444v10
    c444v10 = 0
    c444v9.upgOp = c444v10
    c444v9.checkSuitType = c444v6
    c444v7 = {c444v8, c444v9}
    c444v8 = {}
    c444v9 = {}
    c444v10 = {}
    c444v11 = {}
    c444v12 = ""
    c444v13 = {}
    c444v14 = _G
    c444v14 = c444v14.RollableItemsTypeNameCache
    c444v14 = c444v14.weapons
    c444v15 = #c444v14
    c444v18 = 1
    c444v16 = 3
    c444v17 = 1
    if c444v2 then
      c444v19 = nil
      while true do
        c444v20 = SRandomInt
        c444v21 = 1
        c444v19 = c444v20(c444v21, c444v15)
        c444v20 = c444v13[c444v19]
        if c444v20 == nil then break end
      end
      c444v20 = true
      c444v13[c444v19] = c444v20
      c444v20 = c444v14[c444v19]
      c444v21 = c444v20.itemName
      c444v22 = string.gsub
      c444v24 = "/StoreItems"
      c444v25 = ""
      c444v22 = c444v22(c444v21, c444v24, c444v25)
      c444v23 = WeakResource
      c444v23 = c444v23(c444v22)
      c444v24 = WeakResource
      c444v27 = "Prime"
      c444v25 = c444v22 .. c444v27
      c444v24 = c444v24(c444v25)
      c444v25 = { upgType = nil, label = "/Lotus/Language/Labels/WEAPON_DAMAGE_AMOUNT" }
      c444v26 = vT[17]
      c444v26 = c444v26.Ternary
      c444v28 = c444v20.category
      c444v29 = 5
      if c444v28 ~= c444v29 then
        c444v27 = false
      else
        c444v27 = true
      end
      c444v28 = 325
      c444v29 = 253
      c444v26 = c444v26(c444v27, c444v28, c444v29)
      c444v25.upgType = c444v26
      c444v8[c444v18] = c444v21
      c444v11[c444v18] = c444v25
      c444v9[c444v18] = c444v23
      c444v10[c444v18] = c444v24
      c444v28 = ", "
      c444v12 = c444v12 .. c444v22 .. c444v28
    end
    c444v16 = SetSeed
    c444v16(c444v2)
    c444v16 = print
    c444v18 = "EliteAlert: generated boosts for "
    c444v20 = ": suitType="
    c444v22 = " wepTypes="
    c444v17 = c444v18 .. c444v0 .. c444v20 .. c444v4 .. c444v22 .. c444v12
    c444v16(c444v17)
    do return c444v3, c444v5, c444v6, c444v7, c444v8, c444v9, c444v10, c444v11 end
  end
  GetEliteUpgrades = vT[155]
  vT[155] = function(c445v0)
    local c445v1, c445v2, c445v3, c445v4, c445v5, c445v6, c445v7, c445v8, c445v10
    c445v2 = c445v0.Rank
    c445v1 = IsNull
    c445v1 = c445v1(c445v2)
    c445v4 = gWeaponBaseType
    c445v2 = c445v1:IsA(c445v4)
    c445v4 = gGameData
    c445v3 = IsNull
    c445v3 = c445v3(c445v4)
    c445v2 = gGameData
    c445v2 = c445v2:GetInventory()
    c445v2 = nil
    c445v3 = IsNull
    c445v3 = c445v3(c445v2)
    c445v3 = c445v2.mXPInfo
    c445v6 = 1
    c445v4 = #c445v3
    c445v5 = 1
    for c445v6 = c445v6, c445v4, c445v5 do
      c445v7 = c445v3[c445v6]
      c445v7 = c445v7.mItemType
      c445v8 = IsNull
      c445v8 = c445v8(c445v7)
      if not ((c445v8 or c445v7 ~= c445v1)) then
        c445v8 = gGameConfig
        c445v10 = c445v3[c445v6]
        c445v10 = c445v10.mXP
        c445v8 = c445v8:GetItemLevel(c445v10, c445v7)
        c445v0.Rank = c445v8
      end
    end
    c445v1 = c445v0.ResultItemType
    if not c445v1 then
      c445v1 = c445v0.Type
    end
    c445v2 = IsNull
    c445v2 = c445v2(c445v1)
    do return end
  end
  AppendItemRank = vT[155]
  vT[155] = function(c446v0, c446v1, c446v2)
    local c446v3, c446v4, c446v5, c446v6, c446v7
    c446v3 = IsNull
    c446v3 = c446v3(c446v0)
    if not c446v3 then
      if c446v1 == nil then
        c446v1 = 10
      end
      if c446v2 == nil then
        c446v2 = 2
      end
      c446v3 = vT[17]
      c446v3 = c446v3.ConvertHEX2RGB255
      c446v4 = vT[18]
      c446v4 = c446v4.GetColor
      c446v6 = true
      c446v3 = c446v3(c446v4(c446v1, c446v6))
      c446v4 = vT[17]
      c446v4 = c446v4.ConvertHEX2RGB255
      c446v5 = vT[18]
      c446v5 = c446v5.GetColor
      c446v7 = true
      c446v4 = c446v4(c446v5(c446v2, c446v7))
      c446v7 = gParticleSysType
      c446v5 = c446v0:IsA(c446v7)
      if c446v5 then
        c446v0:Name__4fa62f0d(c446v3, c446v4)
        do return end
      end
      c446v7 = gLensFlareType
      c446v5 = c446v0:IsA(c446v7)
      if c446v5 then
        c446v0:SetTint(c446v3)
      end
    end
    do return end
  end
  ApplyParticleThemeColors = vT[155]
  vT[155] = function(c449v0, c449v1, c449v2)
    local c449v3, c449v5, c449v6
    c449v3 = string.gsub
    c449v5 = "\"#.-\""
    c449v6 = function(c448v0)
      local c448v1, c448v3, c448v4
      c448v1 = string.gsub
      c448v3 = "%w+"
      c448v4 = function(c447v0)
        local c447v1, c447v3, c447v4, c447v5, c447v7, c447v8
        local c447v2 = Lotus_Game
        c447v4 = "UIStyle_"
        c447v3 = c447v4 .. c447v0
        c447v1 = c447v2[c447v3]
        if c447v1 ~= nil then
          c447v3 = c449v1
          c447v2 = c447v3[c447v1]
          if c447v2 == nil then
            c447v2 = c449v1
            c447v3 = string.format
            c447v4 = "%X"
            c447v5 = vT[18]
            c447v5 = c447v5.GetColor
            c447v7 = true
            c447v8 = c449v2
            c447v3 = c447v3(c447v4, c447v5(c447v1, c447v7, c447v8))
            c447v2[c447v1] = c447v3
          end
          c447v3 = c449v1
          c447v2 = c447v3[c447v1]
          do return c447v2 end
        end
        c447v2 = #c447v0
        if c447v2 == 6 then
          do return c447v0 end
        end
        if c447v0 ~= nil then
          c447v4 = c449v1
          c447v3 = c447v4[c447v0]
          c447v2 = tonumber
          c447v2 = c447v2(c447v3)
          if c447v2 ~= nil then
            c447v2 = string.format
            c447v3 = "%X"
            c447v5 = c449v1
            c447v4 = c447v5[c447v0]
            do return c447v2(c447v3, c447v4) end
          end
        end
        c447v2 = print
        c447v4 = "Attempted to use broken color: "
        c447v3 = c447v4 .. c447v0
        c447v2(c447v3)
        c447v3 = c449v1
        c447v4 = 9
        c447v2 = c447v3[c447v4]
        do return c447v2 end
      end
      do return c448v1(c448v0, c448v3, c448v4) end
    end
    do return c449v3(c449v0, c449v5, c449v6) end
  end
  ReplaceTextColors = vT[155]
  vT[155] = function(c450v0)
    local c450v1, c450v2, c450v3, c450v4
    c450v1 = IsNull
    c450v1 = c450v1(c450v0)
    if c450v1 then
      c450v0 = gGameData
    end
    c450v2 = IsNull
    c450v2 = c450v2(c450v0)
    c450v1 = not c450v2
    if c450v1 then
      c450v4 = true
      c450v2 = c450v0:GetPlayerShip(c450v4)
      c450v2 = c450v2.mBootLocation
      c450v3 = 2
      if c450v2 ~= c450v3 then
        c450v1 = false
      else
        c450v1 = true
      end
    end
    do return c450v1 end
  end
  IsParadoxPath = vT[155]
  vT[155] = function(c451v0)
    local c451v1, c451v2, c451v3, c451v4, c451v5, c451v6, c451v7, c451v8, c451v9, c451v10, c451v11, c451v12, c451v13, c451v14, c451v15, c451v16, c451v17
    c451v1 = IsNull
    c451v1 = c451v1(c451v0)
    if c451v1 then
      c451v0 = gGameData
    end
    c451v1 = IsNull
    c451v1 = c451v1(c451v0)
    if c451v1 then
      c451v1 = false
      do return c451v1 end
    end
    c451v1 = c451v0:GetWeeklyVaultBonusInfo()
    c451v4 = 1
    c451v2 = #c451v1
    c451v3 = 1
    for c451v4 = c451v4, c451v2, c451v3 do
      c451v5 = c451v1[c451v4]
      c451v9 = c451v5.mRewards
      c451v8 = #c451v9
      c451v6 = 1
      c451v7 = -1
      for c451v8 = c451v8, c451v6, c451v7 do
        c451v10 = c451v5.mRewards
        c451v9 = c451v10[c451v8]
        c451v10 = c451v9.mRewardClaimed
        if not c451v10 then
          c451v10 = c451v5.mProgress
          c451v11 = c451v9.mPointThreshold
          if c451v11 <= c451v10 then break end
          if c451v11 <= c451v10 then
            c451v10 = true
            do return c451v10 end
          end
        end
      end
    end
    c451v2 = gGameData
    c451v2 = c451v2:GetWorldState()
    c451v5 = 1
    c451v6 = c451v2.mWeeklyVaultBonusRewards
    c451v3 = #c451v6
    c451v4 = 1
    if not c451v1 then
      c451v7 = c451v2.mWeeklyVaultBonusRewards
      c451v6 = c451v7[c451v5]
      c451v7 = gGameData
      c451v7 = c451v7:Name__ee0e44df()
      c451v10 = 1
      c451v8 = #c451v7
      c451v9 = 1
      for c451v10 = c451v10, c451v8, c451v9 do
        c451v11 = c451v7[c451v10]
        c451v12 = c451v11.mWeekCount
        c451v13 = c451v6.mWeekCount
        if c451v12 == c451v13 then break end
      end
      c451v14 = 1
      c451v15 = c451v6.mRewards
      c451v12 = #c451v15
      c451v13 = 1
      c451v15 = c451v11.mProgress
      c451v17 = c451v6.mRewards
      c451v16 = c451v17[c451v14]
      c451v16 = c451v16.mPointThreshold
      if c451v16 <= c451v15 then
        c451v16 = c451v11.mMaxRewardClaimed
        c451v15 = c451v16 + 1
        if c451v15 < c451v14 then
          c451v15 = true
          do return c451v15 end
        end
      end
    end
    c451v3 = false
    do return c451v3 end
  end
  GetUnclaimedClanReward = vT[155]
  vT[155] = function(c452v0)
    local c452v1, c452v2, c452v3, c452v4, c452v6, c452v7, c452v8, c452v9
    c452v1 = IsNull
    c452v1 = c452v1(c452v0)
    if c452v1 then
      c452v0 = gGameData
    end
    c452v1 = IsNull
    c452v1 = c452v1(c452v0)
    if c452v1 then
      c452v1 = 0
      do return c452v1 end
    end
    c452v1 = gGameData
    c452v1 = c452v1:GetUnreadMessageCount()
    c452v2 = 0
    local p20 = 5
    if p20 == 5 then
      c452v2 = IsParadoxPath
      c452v2 = c452v2()
      if c452v2 then
        p20 = 7
      else
        p20 = 6
      end
    end
    if p20 == 6 then
      c452v2 = HasCompletedVorsPrize
      c452v2 = c452v2()
      if c452v2 then
      else
        p20 = 7
      end
    end
    if p20 == 7 then
      c452v2 = ipairs
      c452v3 = gGameData
      c452v2, c452v3, c452v4 = c452v2(c452v3:GetMessageInbox())
      c452v7 = c452v6.mIsRead
      c452v7 = c452v6.mSubject
      c452v7 = string.find
      c452v8 = c452v6.mSubject
      c452v9 = "AnnounceTitle$"
      c452v7 = c452v7(c452v8, c452v9)
      c452v1 = c452v1 - 1
    end
    for c452v5, c452v6 in c452v2, c452v3, c452v4 do
    end
    do return c452v1 end
  end
  vT[156] = function()
    local c453v0
    c453v0 = vT[155]
    do return c453v0() end
  end
  GetUnreadMessageCount = vT[156]
  vT[156] = function(c456v0)
    local c456v1, c456v2, c456v3, c456v4, c456v5, c456v6, c456v7, c456v8
    c456v1 = function()
      local c454v0, c454v1
      local p15 = 0
      if p15 == 0 then
        c454v0 = _T.gQueueMailbox
        if c454v0 ~= true then
          p15 = 3
        else
          p15 = 1
        end
      end
      if p15 == 1 then
        c454v0 = Name__f2b0c533
        c454v0 = c454v0()
        if c454v0 ~= "" then
          p15 = 3
        else
          p15 = 2
        end
      end
      if p15 == 2 then
        c454v1 = gGameData
        c454v0 = IsNull
        c454v0 = c454v0(c454v1)
        if not c454v0 then
          p15 = 4
        else
          p15 = 3
        end
      end
      if p15 == 3 then
        c454v0 = false
        do return c454v0 end
      end
      if p15 == 4 then
        c454v1 = gGameData
        c454v1 = c454v1:GetLoginRewards()
        c454v0 = #c454v1
        c454v1 = 0
        if c454v1 < c454v0 then
          p15 = 12
        else
          p15 = 5
        end
      end
      if p15 == 5 then
        c454v1 = gGameData
        c454v1 = c454v1:GetEndOfMatchStats()
        c454v0 = #c454v1
        c454v1 = 0
        if c454v1 < c454v0 then
          p15 = 12
        else
          p15 = 6
        end
      end
      if p15 == 6 then
        c454v0 = _T.ForceCompletedQuestUpdate
        if c454v0 then
          p15 = 12
        else
          p15 = 7
        end
      end
      if p15 == 7 then
        c454v0 = InQuestCommitment
        c454v1 = gGameData
        c454v0 = c454v0(c454v1)
        if not c454v0 then
          p15 = 11
        else
          p15 = 8
        end
      end
      if p15 == 8 then
        c454v0 = _T.QuestHighPriorityMessagePending
        if not c454v0 then
          p15 = 12
        else
          p15 = 9
        end
      end
      if p15 == 9 then
        c454v0 = _T.ShowNotification
        if not c454v0 then
          p15 = 12
        else
          p15 = 10
        end
      end
      if p15 == 10 then
        c454v0 = _T.GetScreenRes
        if not c454v0 then
          p15 = 12
        else
          p15 = 11
        end
      end
      if p15 == 11 then
        c454v0 = _T.HubShowRoomActive
        if not c454v0 then
          p15 = 13
        else
          p15 = 12
        end
      end
      if p15 == 12 then
        c454v0 = false
        do return c454v0 end
      end
      if p15 == 13 then
        c454v0 = true
        do return c454v0 end
      end
    end
    c456v2 = c456v1()
    if not c456v2 then
      do return end
    end
    c456v2 = _T.ShowNotification
    if c456v2 then
      c456v2 = vT[155]
      c456v2 = c456v2()
      c456v3 = 0
      if c456v3 < c456v2 then
        c456v3 = _T.SkipMailNotification
        if not c456v3 then
          c456v3 = Localize
          if c456v2 == 1 then
            c456v4 = "/Lotus/Language/Menu/Message"
          else
            c456v4 = "/Lotus/Language/Menu/Messages"
          end
          c456v5 = {}
          c456v3 = c456v3(c456v4, c456v5)
          c456v4 = Name__2f367bb5
          c456v4 = c456v4()
          c456v4 = c456v4:c_str()
          if c456v4 ~= "_de" then
            c456v4 = string.lower
            c456v3 = c456v4(c456v3)
          end
          c456v4 = _T.ShowNotification
          c456v5 = Localize
          c456v6 = "/Lotus/Language/Menu/Mailbox_NewMessagesNotification"
          c456v7 = { COUNT = nil, MESSAGES = nil }
          c456v7.COUNT = c456v2
          c456v7.MESSAGES = c456v3
          c456v5 = c456v5(c456v6, c456v7)
          c456v6 = "Mail"
          c456v4(c456v5, c456v6)
        end
      end
      c456v3 = gGameData
      c456v3 = c456v3:Name__28aac72d()
      c456v4 = 0
      if c456v4 < c456v3 then
        c456v3 = _T.GetScreenRes
        if c456v3 ~= nil then
          c456v3 = _T.GetScreenRes
          c456v4 = "Inbox"
          c456v3 = c456v3(c456v4)
          c456v4 = gFlashMgr
          c456v4 = c456v4:FindMovie(c456v3)
          c456v5 = IsNull
          c456v5 = c456v5(c456v4)
          if c456v5 then
            c456v5 = IsNull
            c456v5 = c456v5(c456v0)
            if not c456v5 then
              c456v5 = _T
              c456v6 = true
              c456v5.OpeningMailbox = c456v6
              c456v7 = 1
              c456v8 = function()
                local c455v0, c455v1, c455v2
                c455v0 = _T.UIInputEnabled
                if not c455v0 then
                  c455v0 = _T.RadialSolarMapOpen
                  if not c455v0 then
                    c455v0 = _T.TeleportingToConsole
                    if not c455v0 then
                      c455v0 = _T.QuestPickerOpen
                      if not c455v0 then
                        c455v0 = _T.PreventForcedInbox
                        if not c455v0 then
                          c455v0 = _T.PlatBrowsingOpen
                          if not c455v0 then
                            c455v0 = _T.DojoMenuOpen
                            if not c455v0 then
                              c455v0 = _T
                              c455v1 = "Inbox"
                              c455v0.ForceOpenScreen = c455v1
                              c455v1 = gGameRules
                              c455v0 = IsNull
                              c455v0 = c455v0(c455v1)
                              if not c455v0 then
                                c455v1 = gRegion
                                c455v0 = IsNull
                                c455v0 = c455v0(c455v1)
                                if not c455v0 then
                                  c455v0 = gGameRules
                                  c455v2 = gRegion
                                  c455v0 = c455v0:CanShowPauseMenu(c455v2:GetLocalPlayerAvatar())
                                  if c455v0 then
                                    c455v0 = gGameRules
                                    c455v0:ShowPauseMenu()
                                    do return end
                                  end
                                end
                              end
                              c455v0 = _T
                              c455v1 = nil
                              c455v0.OpeningMailbox = c455v1
                              do return end
                            end
                          end
                        end
                      end
                    end
                  end
                end
                c455v0 = _T
                c455v1 = true
                c455v0.SkipMailNotification = c455v1
                c455v0 = _T
                c455v1 = true
                c455v0.gQueueMailbox = c455v1
                c455v0 = _T
                c455v1 = nil
                c455v0.OpeningMailbox = c455v1
                do return end
              end
              c456v0:AddTimer(c456v7, c456v8)
            end
          end
        end
      end
    end
    c456v2 = _T
    c456v3 = false
    c456v2.SkipMailNotification = c456v3
    c456v2 = _T
    c456v3 = false
    c456v2.gQueueMailbox = c456v3
    do return end
  end
  UpdateMailbox = vT[156]
  vT[156] = function()
    local c457v0, c457v1, c457v2
    c457v2 = gGameData
    c457v1 = IsNull
    c457v1 = c457v1(c457v2)
    c457v0 = not c457v1
    if c457v0 then
      c457v0 = gGameData
      c457v0 = c457v0:GetWorldState()
      c457v0 = c457v0:IsSeasonActive()
      if c457v0 then
        c457v0 = HasCompletedVorsPrize
        c457v0 = c457v0()
        if c457v0 then
          c457v0 = HasCompletedTheTeacher
          c457v0 = c457v0()
        end
      end
    end
    do return c457v0 end
  end
  IsSeasonActive = vT[156]
  vT[156] = function(c458v0, c458v1, c458v2, c458v3)
    local c458v5, c458v6, c458v7, c458v8, c458v9, c458v10, c458v11, c458v13
    local c458v4 = c458v2
    if not c458v4 then
      c458v4 = 0
    end
    c458v5 = vT[57]
    c458v5 = c458v5()
    c458v5 = c458v5:Name__fb10ad85(c458v0, c458v4)
    if c458v3 == nil then
      c458v6 = Localize
      c458v7 = "/Lotus/Language/Kingpins/NemesisViewer_Title"
      c458v8 = nil
      c458v3 = c458v6(c458v7, c458v8)
    end
    c458v6 = Localize
    c458v7 = "/Lotus/Language/Kingpins/NemesisControlledTerritory"
    c458v8 = { LICH_NAME = nil }
    c458v8.LICH_NAME = c458v3
    c458v6 = c458v6(c458v7, c458v8)
    c458v5.uniqueName = c458v6
    c458v6 = c458v1 or 1
    c458v7 = 55
    c458v8 = 75
    if c458v6 == 1 then
      c458v7 = 50
      c458v8 = 60
    else
      if c458v6 == 2 then
        c458v7 = 55
        c458v8 = 70
      else
        if c458v6 == 3 then
          c458v7 = 75
          c458v8 = 90
        else
          c458v9 = 4
          if c458v9 <= c458v6 then
            c458v7 = 90
            c458v8 = 110
          end
        end
      end
    end
    c458v9 = 2
    if c458v4 == c458v9 then
      c458v7 = 100
      c458v8 = 100
    end
    c458v10 = c458v5.minEnemyLevel
    c458v9 = math.max
    c458v9 = c458v9(c458v10, c458v7)
    c458v5.minEnemyLevel = c458v9
    c458v10 = c458v5.maxEnemyLevel
    c458v9 = math.max
    c458v9 = c458v9(c458v10, c458v8)
    c458v5.maxEnemyLevel = c458v9
    c458v9 = 1
    c458v5.difficulty = c458v9
    c458v9 = c458v5.missionType
    c458v10 = 8
    if c458v9 == c458v10 then
      c458v10 = 3
      c458v5.maxWaveNum = c458v10
    else
      c458v10 = 13
      if c458v9 == c458v10 then
        c458v10 = 1
        c458v5.maxWaveNum = c458v10
      else
        c458v10 = 2
        if c458v9 == c458v10 then
          c458v10 = 5
          c458v5.maxWaveNum = c458v10
        else
          c458v10 = 17
          if c458v9 == c458v10 then
            c458v10 = 5
            c458v5.maxWaveNum = c458v10
          else
            c458v10 = 7
            if c458v9 == c458v10 then
              c458v10 = 2
              c458v5.maxWaveNum = c458v10
            else
              c458v10 = 4
              if c458v9 == c458v10 then
                c458v10 = 2
                c458v5.maxWaveNum = c458v10
              else
                c458v10 = 33
                if c458v9 == c458v10 then
                  c458v10 = 4
                  c458v5.maxWaveNum = c458v10
                end
              end
            end
          end
        end
      end
    end
    c458v10 = 1
    if c458v4 == c458v10 then
      c458v10 = WeakResource
      c458v11 = "/Lotus/Types/Enemies/AdvancedSpawners/LawyerPetSpawner"
      c458v13 = c458v10(c458v11)
      c458v5:Name__36e599df(c458v13)
    end
    do return c458v5 end
  end
  vT[157] = function(c459v0, c459v1, c459v2, c459v3)
    local c459v4
    c459v4 = vT[156]
    do return c459v4(c459v0, c459v1, c459v2, c459v3) end
  end
  BuildNemesisMission = vT[157]
  vT[157] = function(c460v0)
    local c460v1, c460v2, c460v3, c460v4
    c460v1 = c460v0:GetRecipeVisibility()
    c460v2 = 1
    if c460v1 ~= c460v2 then
      c460v2 = 0
      if c460v1 ~= c460v2 then
        c460v2 = 3
        if c460v1 == c460v2 then
          c460v4 = gGameData
          c460v4 = c460v4:GetInventory()
          c460v4 = c460v4:GetCrewShips()
          c460v3 = #c460v4
          c460v4 = 0
          if c460v3 <= c460v4 then
            c460v2 = false
          else
            c460v2 = true
          end
          do return c460v2 end
        end
        c460v2 = 4
        if c460v1 ~= c460v2 then
          c460v2 = false
          do return c460v2 end
        end
        c460v4 = gGameData
        c460v4 = c460v4:GetInventory()
        c460v4 = c460v4:GetCrewShips()
        c460v3 = #c460v4
        if c460v3 ~= 0 then
          c460v2 = false
        else
          c460v2 = true
        end
        do return c460v2 end
      end
    end
    c460v2 = true
    do return c460v2 end
  end
  ShouldHideRecipe = vT[157]
  vT[157] = function(c461v0, c461v1)
    local c461v2, c461v3, c461v4, c461v7, c461v8
    c461v2 = { _uk = true, _ru = true, _ja = true, _zh = true, _tc = true, _ko = true }
    c461v3 = Name__2f367bb5
    c461v3 = c461v3()
    c461v3 = c461v3:c_str()
    c461v4 = c461v2[c461v3]
    if not c461v4 then
      c461v4 = true
      do return c461v4 end
    end
    c461v4 = IsNull
    c461v4 = c461v4(c461v0)
    if not ((c461v4 or c461v1 == nil)) then
      c461v7 = 77
      c461v8 = 0
      c461v0:SetNumberVariable(c461v1, c461v7, c461v8)
    end
    c461v4 = false
    do return c461v4 end
  end
  CheckLetterSpacing = vT[157]
  vT[157] = function()
    local c462v0, c462v1, c462v2
    c462v0 = Lotus_Game.ServerSideSettings
    c462v0 = c462v0()
    c462v2 = gGameData
    c462v1 = IsNull
    c462v1 = c462v1(c462v2)
    if not c462v1 then
      c462v1 = gGameData
      c462v1 = c462v1:GetGiftMode()
      c462v0.mGiftMode = c462v1
      c462v1 = gGameData
      c462v1 = c462v1:GetFriendInvRestriction()
      c462v0.mFriendInvRestriction = c462v1
      c462v1 = gGameData
      c462v1 = c462v1:GetGuildInvRestriction()
      c462v0.mGuildInvRestriction = c462v1
      c462v1 = gGameData
      c462v1 = c462v1:GetShowFriendInvNotifications()
      c462v0.mShowFriendInvNotifications = c462v1
      c462v1 = gGameData
      c462v1 = c462v1:GetTradingRulesConfirmed()
      c462v0.mTradingRulesConfirmed = c462v1
      c462v1 = gGameData
      c462v1 = c462v1:GetSubscribedToSurveys()
      c462v0.mSubscribedToSurveys = c462v1
    end
    do return c462v0 end
  end
  ServerSideSettings = vT[157]
  vT[157] = function(c463v0, c463v1)
    local c463v2, c463v3, c463v4, c463v5, c463v7, c463v8
    local p9 = 0
    if p9 == 0 then
      c463v3 = gGameData
      c463v3 = c463v3:Name__2e54c833()
      c463v2 = #c463v3
      c463v3 = 1000
      if c463v2 < c463v3 then
        p9 = 6
      else
        p9 = 1
      end
    end
    if p9 == 1 then
      c463v3 = Localize
      c463v4 = "/Lotus/Language/Menu/SocialOverlay_FriendLimitError"
      c463v5 = { NUM_FRIENDS = nil, MAX_FRIENDS = 1000 }
      c463v5.NUM_FRIENDS = c463v2
      c463v3 = c463v3(c463v4, c463v5)
      c463v4 = IsNull
      c463v4 = c463v4(c463v0)
      if c463v4 then
        p9 = 4
      else
        p9 = 2
      end
    end
    if p9 == 2 then
      c463v4 = #c463v1
      if c463v4 == 0 then
        p9 = 4
      else
        p9 = 3
      end
    end
    if p9 == 3 then
      c463v8 = "false"
      c463v7 = {c463v8, c463v3}
      c463v4 = c463v0:Name__8b1f0505(c463v1, c463v7)
      if c463v4 then
        p9 = 5
      else
        p9 = 4
      end
    end
    if p9 == 4 then
      c463v4 = vT[17]
      c463v4 = c463v4.ShowMessage
      c463v4(c463v3)
      p9 = 5
    end
    if p9 == 5 then
      c463v4 = true
      do return c463v4 end
    end
    if p9 == 6 then
      c463v3 = false
      do return c463v3 end
    end
  end
  vT[158] = function(c464v0, c464v1)
    local c464v2
    c464v2 = vT[157]
    do return c464v2(c464v0, c464v1) end
  end
  FriendLimitReached = vT[158]
  vT[158] = function(c468v0, c468v1)
    local c468v2, c468v3
    c468v2 = vT[41]
    c468v2 = c468v2()
    c468v3 = function(c465v0, c465v1)
      local c465v2, c465v3, c465v4, c465v5, c465v6, c465v7, c465v8
      if not c465v0 then
        c465v3 = c468v2
        c465v3 = c465v3.mMovie
        c465v5 = vT[17]
        c465v5 = c465v5.ParseAddFriendErrorMsg
        c465v5 = c465v5(c465v1)
        c465v6 = true
        c465v2 = c465v3:GetLocalized(c465v5, c465v6)
      else
        c465v3 = c468v2
        c465v3 = c465v3.mMovie
        c465v5 = "/Lotus/Language/Menu/SocialOverlay_FriendAddConfirm"
        c465v6 = true
        c465v7 = { NAME = nil }
        c465v8 = c468v0
        c465v7.NAME = c465v8
        c465v2 = c465v3:GetLocalized(c465v5, c465v6, c465v7)
      end
      c465v4 = c468v2
      c465v5 = c468v1
      c465v3 = c465v4[c465v5]
      if c465v0 then
        c465v3 = c468v2
        c465v3 = c465v3.mMovie
        c465v5 = c468v1
        c465v6 = {}
        if c465v0 then
          c465v7 = "true"
        else
          c465v7 = "false"
        end
        c465v6 = {c465v7, c465v2, c465v1}
        c465v3 = c465v3:Name__8b1f0505(c465v5, c465v6)
        if not c465v3 then
          c465v3 = vT[17]
          c465v3 = c465v3.ShowMessage
          c465v3(c465v2)
        end
      end
      do return end
    end
    c468v2.UtilOnAddFriend = c468v3
    c468v3 = function(c466v0, c466v1, c466v2)
      local c466v3, c466v4, c466v6, c466v8
      c466v3 = IsNull
      c466v3 = c466v3(c466v2)
      if not c466v3 then
        c466v3 = tonumber
        c466v3 = c466v3(c466v2)
        c466v4 = 4
        if c466v3 == c466v4 then
          c466v3 = Engine.Name__735cc29c
          c466v4 = c468v0
          c466v3 = c466v3(c466v4)
          if c466v3 ~= "" then
            c468v0 = c466v3
          end
          c466v4 = gGameData
          c466v6 = c468v0
          c466v8 = "UtilOnAddFriend"
          c466v4:AddFriend(c466v6, c466v0, c466v8)
        end
      end
      do return end
    end
    c468v2.UtilAddFriendMessage = c468v3
    c468v3 = function(c467v0, c467v1)
      local c467v2, c467v3, c467v5, c467v7
      if not c467v0 then
        c467v2 = Engine.Name__735cc29c
        c467v3 = c468v0
        c467v2 = c467v2(c467v3)
        if c467v2 ~= "" then
          c468v0 = c467v2
        end
        c467v3 = gGameData
        c467v5 = c468v0
        c467v7 = "UtilOnAddFriend"
        c467v3:AddFriend(c467v5, c467v1, c467v7)
      end
      do return end
    end
    c468v2.UtilAddFriendMessageOSK = c468v3
    c468v3 = c468v2.mMovie
    do return c468v3 end
  end
  vT[159] = function(c469v0, c469v1)
    local c469v2, c469v3, c469v4, c469v5, c469v6, c469v7, c469v8, c469v9, c469v10, c469v11
    c469v2 = false
    c469v4 = _G
    c469v3 = c469v4[c469v1]
    if not c469v3 then
      c469v3 = {}
    end
    c469v6 = #c469v3
    c469v4 = 1
    c469v5 = -1
    for c469v6 = c469v6, c469v4, c469v5 do
      c469v7 = c469v3[c469v6]
      c469v9 = Time
      c469v9 = c469v9()
      c469v10 = c469v7.mTimeStamp
      c469v8 = c469v9 - c469v10
      c469v9 = 600
      if c469v9 < c469v8 then
        c469v8 = table.remove
        c469v8(c469v3, c469v6)
      else
        c469v8 = c469v7.mDisplayName
        if c469v8 == c469v0 then
          c469v2 = true
        end
      end
    end
    if not c469v2 then
      c469v4 = #c469v3
      c469v5 = 9
      if c469v5 < c469v4 then
        c469v6 = Time
        c469v6 = c469v6()
        c469v7 = c469v3[1]
        c469v7 = c469v7.mTimeStamp
        c469v5 = c469v6 - c469v7
        c469v4 = 600 - c469v5
        c469v5 = vT[17]
        c469v5 = c469v5.ShowMessage
        c469v6 = Localize
        c469v8 = "/Lotus/Language/Labels/"
        c469v7 = c469v8 .. c469v1
        c469v8 = { TIME = nil }
        c469v9 = vT[44]
        c469v11 = "HoursOrMinutesOrSeconds"
        c469v9 = c469v9(c469v4, c469v11)
        c469v8.TIME = c469v9
        c469v5(c469v6(c469v7, c469v8))
        c469v5 = true
        do return c469v5 end
      end
      c469v6 = { mDisplayName = nil, mTimeStamp = nil }
      c469v6.mDisplayName = c469v0
      c469v7 = Time
      c469v7 = c469v7()
      c469v6.mTimeStamp = c469v7
      c469v4 = table.insert
      c469v4(c469v3, c469v6)
      c469v5 = #c469v3
      c469v4 = c469v3[c469v5]
    end
    c469v4 = _G
    c469v4[c469v1] = c469v3
    c469v4 = false
    do return c469v4 end
  end
  InviteThrottleReached = vT[159]
  vT[159] = function(c470v0, c470v1, c470v2)
    local c470v3, c470v4, c470v5, c470v6, c470v7, c470v8, c470v9, c470v10, c470v11, c470v12
    c470v4 = gGameData
    c470v3 = IsNull
    c470v3 = c470v3(c470v4)
    if c470v3 then
      do return end
    end
    c470v3 = vT[158]
    c470v5 = c470v1 or "OnAddFriend"
    c470v3 = c470v3(c470v0, c470v5)
    c470v4 = vT[157]
    c470v4 = c470v4(c470v3, c470v1)
    if c470v4 then
      do return end
    end
    c470v4 = InviteThrottleReached
    c470v6 = "ThrottleAddFriend"
    c470v4 = c470v4(c470v0, c470v6)
    if c470v4 then
      do return end
    end
    c470v4 = Engine.Name__f45a364e
    c470v4 = c470v4(c470v0)
    c470v5 = Engine.Name__3d4ef9f7
    c470v5 = c470v5()
    if not c470v3 then
      local p21 = 7
      if p21 == 7 then
        c470v5 = 1
        if c470v4 == c470v5 then
          p21 = 9
        else
          p21 = 8
        end
      end
      if p21 == 8 then
        c470v5 = 7
        if c470v4 ~= c470v5 then
        else
          p21 = 9
        end
      end
      if p21 == 9 then
        c470v7 = "UtilAddFriendMessage"
        c470v9 = ""
        c470v10 = ""
        c470v11 = 4
        c470v8 = {c470v9, c470v10, c470v11}
        c470v3:Name__8b1f0505(c470v7, c470v8)
        do return end
      end
    end
    if c470v2 == nil then
      c470v5 = vT[121]
      c470v7 = "/Lotus/Language/Menu/Message"
      c470v8 = ""
      c470v9 = 200
      c470v10 = "UtilAddFriendMessage"
      c470v11 = "UtilAddFriendMessageOSK"
      c470v12 = { isMultiline = true }
      c470v5(c470v3, c470v7, c470v8, c470v9, c470v10, c470v11, c470v12)
      do return end
    end
    c470v7 = "UtilAddFriendMessage"
    c470v10 = ""
    c470v11 = 4
    c470v8 = {c470v2, c470v10, c470v11}
    c470v3:Name__8b1f0505(c470v7, c470v8)
    do return end
  end
  AddFriend = vT[159]
  vT[159] = function(c471v0)
    local c471v1, c471v2, c471v3, c471v4
    c471v2 = gGameData
    c471v1 = IsNull
    c471v1 = c471v1(c471v2)
    if c471v1 then
      do return end
    end
    c471v1 = InviteThrottleReached
    c471v3 = "ThrottleAddGuildMember"
    c471v1 = c471v1(c471v0, c471v3)
    if c471v1 then
      do return end
    end
    c471v1 = gGameData
    c471v4 = "OnAddToGuild"
    c471v1:AddToGuild(c471v0, c471v4)
    do return c471v0 end
  end
  AddGuildMember = vT[159]
  vT[159] = function(c472v0)
    local c472v1, c472v2, c472v3
    c472v2 = vT[23]
    c472v1 = c472v2[c472v0]
    c472v2 = IsNull
    c472v2 = c472v2(c472v1)
    if c472v2 then
      c472v2 = vT[23]
      c472v2 = c472v2.Default
      do return c472v2 end
    end
    c472v3 = c472v1.Alpha
    c472v2 = IsNull
    c472v2 = c472v2(c472v3)
    if c472v2 then
      c472v2 = vT[23]
      c472v2 = c472v2.Default
      c472v2 = c472v2.Alpha
      c472v1.Alpha = c472v2
    end
    do return c472v1 end
  end
  GetSyndicateBackgroundAlignments = vT[159]
  vT[159] = function(c473v0)
    local c473v1, c473v2, c473v3, c473v4, c473v5
    c473v1 = gFlashMgr
    c473v3 = _G
    c473v3 = c473v3.UIMovie_TransmissionMovie
    c473v1 = c473v1:FindMovie(c473v3)
    c473v2 = IsNull
    c473v2 = c473v2(c473v1)
    if not c473v2 then
      c473v4 = "PreviewClose"
      c473v5 = "true"
      c473v1:Execute(c473v4, c473v5)
    end
    if c473v0 then
      c473v2 = _T
      c473v3 = {}
      c473v2.QueuedTransmissions = c473v3
    end
    do return end
  end
  ForceCloseTransmission = vT[159]
  vT[159] = function(c474v0)
    local c474v1, c474v2, c474v3, c474v5, c474v6
    c474v1 = ""
    if c474v0 ~= "error" then
      c474v2 = Engine.STACKSFollies
      c474v2 = c474v2()
      if c474v2 then
        if c474v0 == "firewall" then
          c474v1 = "https://kf.qq.com/faq/201107VJry2m201107A3YJvA.html"
        else
          if c474v0 == "dnsfailure" then
            c474v1 = "https://kf.qq.com/faq/201107Vb2uiA201107JNBZbq.html"
          else
            if c474v0 == "strictNAT" then
              c474v1 = "https://kf.qq.com/faq/201107zmeaQz201107MZv22I.html"
            else
              if c474v0 == "upnpnotdetected" then
                c474v1 = "https://kf.qq.com/faq/201107N77bYJ201107VvUzqQ.html"
              else
                if c474v0 == "upnpenabled" then
                  c474v1 = "https://kf.qq.com/faq/201107b22QBR201107mYR32Q.html"
                else
                  if c474v0 == "portinuse" then
                    c474v1 = "https://wf.qq.com/newsDetail.shtml?tid=13969838"
                  end
                end
              end
            end
          end
        end
        if c474v1 == "" then
          c474v2 = "https://warframe.com/zh-hans/"
          c474v1 = c474v2 .. c474v0
          do return c474v1 end
        end
      else
        c474v3 = Name__2f367bb5
        c474v2 = tostring
        c474v2 = c474v2(c474v3())
        c474v5 = 2
        c474v6 = #c474v2
        c474v2 = c474v2:sub(c474v5, c474v6)
        if c474v2 == "pt" then
          c474v2 = "pt-br"
        else
          if c474v2 == "zh" then
            c474v2 = "zh-hans"
          else
            if c474v2 == "tc" then
              c474v2 = "zh-hant"
            end
          end
        end
        c474v3 = "https://warframe.com/"
        c474v5 = "/"
        c474v1 = c474v3 .. c474v2 .. c474v5 .. c474v0
      end
    end
    do return c474v1 end
  end
  GetNetworkAnalysisURL = vT[159]
  vT[159] = function(c475v0, c475v1, c475v2, c475v3)
    local c475v4, c475v5, c475v6
    c475v4 = c475v0:holderRoar()
    if c475v4 then
      c475v4 = true
      do return c475v4 end
    end
    c475v4 = c475v0:Name__cb8bb185()
    c475v4 = c475v4:TrackPartsMISSION()
    c475v6 = IsNull
    c475v6 = c475v6(c475v4)
    c475v5 = not c475v6
    if not c475v4 then
      if c475v2 then
        c475v4:Disable()
        do return c475v5 end
      end
      if c475v3 == nil then
        c475v3 = false
      end
      c475v0:AbortContextAction(c475v3)
    end
    do return c475v5 end
  end
  AvatarHasActiveActions = vT[159]
  vT[159] = function(c476v0)
    local c476v1, c476v3
    c476v1 = IsNull
    c476v1 = c476v1(c476v0)
    if not c476v1 then
      c476v3 = vT[9]
      c476v1 = c476v0:IsA(c476v3)
      if not c476v1 then
        c476v1 = false
        do return c476v1 end
      end
    end
    c476v1 = true
    do return c476v1 end
  end
  ShouldHideConsumable = vT[159]
  vT[159] = function(c477v0)
    local c477v1, c477v2, c477v3, c477v4, c477v5, c477v6, c477v7, c477v8, c477v9, c477v10, c477v11, c477v12, c477v13, c477v14, c477v15, c477v16, c477v17, c477v18, c477v19
    c477v2 = gGameRules
    c477v1 = IsNull
    c477v1 = c477v1(c477v2)
    if c477v1 then
      c477v1 = ""
      do return c477v1 end
    end
    c477v1 = c477v0
    if not c477v1 then
      c477v1 = gGameRules
      c477v1 = c477v1:GetMission()
    end
    c477v2 = c477v1.location
    c477v3 = tostring
    c477v4 = c477v3(c477v2)
    c477v5 = vT[57]
    c477v5 = c477v5()
    c477v6 = IsNull
    c477v6 = c477v6(c477v5)
    if not c477v6 then
      c477v6 = c477v5:GetNodeLabel(c477v2)
      c477v6 = c477v6:c_str()
      c477v7 = WeakResource
      c477v8 = "/Lotus/Types/GameRules/Lotus1999GameRules"
      c477v7 = c477v7(c477v8)
      c477v9 = c477v1.gameRules
      c477v8 = IsNull
      c477v8 = c477v8(c477v9)
      if not c477v8 then
        c477v8 = c477v1.gameRules
        c477v8 = c477v8:IsA(c477v7)
        if c477v8 then
          c477v9 = "StreetName"
          c477v6 = c477v6 .. c477v9
        end
      end
      c477v8 = Localize
      c477v10 = false
      c477v4 = c477v8(c477v6, c477v10)
    end
    c477v7 = gGameData
    c477v6 = IsNull
    c477v6 = c477v6(c477v7)
    if not c477v1 then
      c477v6 = gGameData
      c477v6 = c477v6:GetWorldState()
      c477v9 = 1
      c477v10 = c477v6.mGoals
      c477v7 = #c477v10
      c477v8 = 1
      for c477v9 = c477v9, c477v7, c477v8 do
        c477v11 = c477v6.mGoals
        c477v10 = c477v11[c477v9]
        c477v12 = c477v10.mId
        c477v11 = tostring
        c477v11 = c477v11(c477v12)
        c477v12 = c477v1.goalId
        c477v11 = c477v10.mNode
        c477v11 = c477v10.mNode
        if c477v11 == c477v3 then break end
        c477v11 = false
        c477v14 = 1
        c477v15 = c477v10.mConcurrentNodes
        c477v12 = #c477v15
        c477v13 = 1
        for c477v14 = c477v14, c477v12, c477v13 do
          c477v16 = c477v10.mConcurrentNodes
          c477v15 = c477v16[c477v14]
          c477v16 = c477v10.mConcurrentNodes
          c477v15 = c477v16[c477v14]
          if c477v15 == c477v3 then break end
        end
        if c477v11 then break end
        c477v15 = Localize
        c477v16 = c477v10.mDesc
        c477v17 = false
        c477v4 = c477v15(c477v16, c477v17)
        c477v16 = c477v10.mConcurrentNodeReqs
        c477v15 = #c477v16
        if c477v14 <= c477v15 then
          c477v16 = c477v10.mConcurrentNodeReqs
          c477v15 = c477v16[c477v14]
          c477v16 = c477v10.mGoal
          if c477v16 <= c477v15 then
            c477v15 = c477v10.mTag
            c477v16 = Symbol
            c477v17 = "WaterFight"
            c477v16 = c477v16(c477v17)
            if c477v15 ~= c477v16 then
              c477v16 = " "
              c477v17 = Localize
              c477v18 = "/Lotus/Language/Menu/WorldStateChallengeMode"
              c477v19 = false
              c477v17 = c477v17(c477v18, c477v19)
              c477v4 = c477v4 .. c477v16 .. c477v17
            end
          end
        end
        c477v11 = true
        if c477v11 ~= c477v12 then
          c477v11 = Localize
          c477v12 = c477v10.mDesc
          c477v13 = false
          c477v4 = c477v11(c477v12, c477v13)
        end
      end
      c477v7 = c477v1.alertId
      if c477v7 ~= "" then
        c477v9 = 1
        c477v10 = c477v6.mAlerts
        c477v7 = #c477v10
        c477v8 = 1
        for c477v9 = c477v9, c477v7, c477v8 do
          c477v11 = c477v6.mAlerts
          c477v10 = c477v11[c477v9]
          c477v12 = c477v10.mId
          c477v11 = tostring
          c477v11 = c477v11(c477v12)
          c477v12 = c477v1.alertId
          if c477v11 == c477v12 then
            c477v11 = c477v10.mTag
            c477v12 = EMPTY_SYMBOL
            if c477v11 ~= c477v12 then
              c477v11 = Localize
              c477v13 = c477v10.mMissionInfo
              c477v13 = c477v13.descText
              c477v12 = tostring
              c477v12 = c477v12(c477v13)
              c477v13 = false
              c477v4 = c477v11(c477v12, c477v13)
            end
          end
        end
      end
    end
    local p82 = 32
    if p82 == 32 then
      c477v6 = #c477v4
      if c477v6 ~= 0 then
        p82 = 34
      else
        p82 = 33
      end
    end
    if p82 == 33 then
      c477v6 = Localize
      c477v7 = c477v1.uniqueName
      c477v8 = false
      c477v4 = c477v6(c477v7, c477v8)
      p82 = 34
    end
    if p82 == 34 then
      c477v7 = c477v1.keyChainName
      c477v6 = IsNull
      c477v6 = c477v6(c477v7)
      if not c477v6 then
        p82 = 36
      else
        p82 = 35
      end
    end
    if p82 == 35 then
      c477v6 = #c477v4
      if c477v6 ~= 0 then
        p82 = 38
      else
        p82 = 36
      end
    end
    if p82 == 36 then
      c477v6 = Resource
      c477v7 = c477v1.levelKeyName
      c477v6 = c477v6(c477v7)
      c477v7 = IsNull
      c477v7 = c477v7(c477v6)
      if c477v7 then
        p82 = 38
      else
        p82 = 37
      end
    end
    if p82 == 37 then
      c477v7 = c477v6:GetLocalizeTag()
      c477v8 = Localize
      c477v9 = c477v7:c_str()
      c477v10 = false
      c477v4 = c477v8(c477v9, c477v10)
      p82 = 38
    end
    if p82 == 38 then
      c477v6 = #c477v4
      if c477v6 ~= 0 then
        p82 = 44
      else
        p82 = 39
      end
    end
    if p82 == 39 then
      c477v7 = c477v1.levelOverride
      c477v6 = IsNull
      c477v6 = c477v6(c477v7)
      if c477v6 then
        p82 = 44
      else
        p82 = 40
      end
    end
    if p82 == 40 then
      c477v6 = c477v1.levelOverride
      c477v6 = c477v6:GetFullName()
      c477v7 = string.find
      c477v9 = "Derelict"
      c477v7 = c477v7(c477v6, c477v9)
      if not c477v7 then
        p82 = 42
      else
        p82 = 41
      end
    end
    if p82 == 41 then
      c477v7 = Localize
      c477v8 = "/Lotus/Language/Locations/Derelict"
      c477v9 = false
      c477v4 = c477v7(c477v8, c477v9)
      p82 = 44
    end
    if p82 == 42 then
      c477v7 = string.find
      c477v9 = "OrokinTower"
      c477v7 = c477v7(c477v6, c477v9)
      if not c477v7 then
        p82 = 44
      else
        p82 = 43
      end
    end
    if p82 == 43 then
      c477v7 = Localize
      c477v8 = "/Lotus/Language/Locations/Void"
      c477v9 = false
      c477v4 = c477v7(c477v8, c477v9)
      p82 = 44
    end
    if p82 == 44 then
      c477v6 = gGameRules
      c477v8 = gLotusBaseGameRulesType
      c477v6 = c477v6:IsA(c477v8)
      if not c477v6 then
        p82 = 47
      else
        p82 = 45
      end
    end
    if p82 == 45 then
      c477v6 = gGameRules
      c477v6 = c477v6:Name__84c483f1()
      if not c477v6 then
        p82 = 47
      else
        p82 = 46
      end
    end
    if p82 == 46 then
      c477v6 = Localize
      c477v7 = "/Lotus/Language/Missions/MissionName_Badlands"
      c477v8 = { MISSION_NAME = nil }
      c477v8.MISSION_NAME = c477v4
      c477v4 = c477v6(c477v7, c477v8)
      p82 = 47
    end
    if p82 == 47 then
      c477v6 = #c477v4
      if c477v6 ~= 0 then
        p82 = 50
      else
        p82 = 48
      end
    end
    if p82 == 48 then
      c477v6 = string.find
      c477v8 = "Kullervo"
      c477v6 = c477v6(c477v3, c477v8)
      if not c477v6 then
        p82 = 50
      else
        p82 = 49
      end
    end
    if p82 == 49 then
      c477v6 = Localize
      c477v7 = "/Lotus/Language/Duviri/ThePrison"
      c477v8 = false
      c477v4 = c477v6(c477v7, c477v8)
      p82 = 50
    end
    if p82 == 50 then
      do return c477v4 end
    end
  end
  GetMissionName = vT[159]
  vT[159] = function()
    local c478v0, c478v1, c478v2, c478v3
    c478v0 = Symbol
    c478v1 = "TeshinHardModeUnlocked"
    c478v0 = c478v0(c478v1)
    c478v2 = gGameData
    c478v1 = IsNull
    c478v1 = c478v1(c478v2)
    if not c478v1 then
      c478v1 = gGameData
      c478v1 = c478v1:HasCompletedNodeIntro(c478v0)
      do return c478v1 end
    end
    c478v2 = gPlayerProfileMgr
    c478v1 = IsNull
    c478v1 = c478v1(c478v2)
    if not c478v1 then
      c478v1 = gPlayerProfileMgr
      c478v3 = 0
      c478v1 = c478v1:GetPlayerProfile(c478v3)
      c478v2 = IsNull
      c478v2 = c478v2(c478v1)
      if not c478v2 then
        c478v2 = c478v1:GetGameSpecificData()
        c478v3 = IsNull
        c478v3 = c478v3(c478v2)
        if not c478v3 then
          c478v3 = c478v2:HasCompletedNodeIntro(c478v0)
          do return c478v3 end
        end
      end
    end
    c478v1 = false
    do return c478v1 end
  end
  HasUnlockedHardMode = vT[159]
  vT[159] = function()
    local c479v0, c479v1
    c479v0 = Engine.Name__b38e1642
    c479v1 = "1742774400"
    c479v0 = c479v0(c479v1)
    c479v1 = 0
    if c479v1 < c479v0 then
      c479v1 = true
      do return c479v1 end
    end
    c479v1 = false
    do return c479v1 end
  end
  IsDeepArchemedeaModeReleaseGracePeriod = vT[159]
  vT[159] = function()
    local c480v0, c480v1, c480v2
    c480v0 = gGameData
    c480v0 = c480v0:Name__c1774d1f()
    c480v1 = Engine.Name__b38e1642
    c480v2 = gGameData
    c480v1 = c480v1(c480v2:Name__58cf3598())
    c480v2 = 0
    if c480v1 <= c480v2 then
      c480v0 = 0
    end
    c480v2 = IsDeepArchemedeaModeReleaseGracePeriod
    c480v2 = c480v2()
    if c480v2 then
      c480v2 = MAX_PULSES
      c480v0 = c480v0 - c480v2
    end
    do return c480v0 end
  end
  GetDeepArchemedeaPulsesSpent = vT[159]
  vT[159] = function()
    local c481v0, c481v1, c481v2
    c481v0 = false
    c481v1 = Engine.Name__b38e1642
    c481v2 = gGameData
    c481v1 = c481v1(c481v2:Name__58cf3598())
    c481v2 = 0
    if c481v1 <= c481v2 then
      c481v0 = true
    end
    do return c481v0 end
  end
  CheckDeepArchemedeaResetDate = vT[159]
  vT[159] = function(c482v0)
    local c482v1, c482v3, c482v4
    c482v1 = 1
    if c482v0 == c482v1 then
      c482v1 = gGameData
      c482v3 = Symbol
      c482v4 = "EntratiLabConquestHardModeUnlocked"
      do return c482v1:HasCompletedNodeIntro(c482v3(c482v4)) end
    end
    c482v1 = gGameData
    c482v3 = Symbol
    c482v4 = "EchoesHexConquestHardModeUnlocked"
    do return c482v1:HasCompletedNodeIntro(c482v3(c482v4)) end
  end
  CheckConquestHardModeUnlocked = vT[159]
  vT[159] = function(c483v0)
    local c483v1, c483v2, c483v3
    c483v1 = gGameData
    c483v1 = c483v1:GetConquestUnlocked(c483v0)
    c483v2 = CheckDeepArchemedeaResetDate
    c483v2 = c483v2()
    if c483v2 then
      c483v1 = 0
    end
    c483v3 = 0
    if c483v1 <= c483v3 then
      c483v2 = false
    else
      c483v2 = true
    end
    do return c483v2 end
  end
  CheckConquestUnlocked = vT[159]
  vT[159] = function(c484v0, c484v1, c484v2)
    local c484v3, c484v4, c484v5, c484v6, c484v7, c484v8, c484v9, c484v10, c484v11, c484v12, c484v13
    c484v6 = 1
    c484v7 = c484v3.sectors
    c484v4 = #c484v7
    c484v5 = 1
    for c484v6 = c484v6, c484v4, c484v5 do
      c484v8 = c484v3.sectors
      c484v7 = c484v8[c484v6]
      c484v8 = c484v7.name
      if c484v8 == c484v1 then break end
      if c484v8 == c484v1 then
        c484v10 = c484v7.name
        c484v8 = c484v0:BuildMissionForLocation(c484v10)
        if c484v2 then
          c484v9 = print
          c484v10 = "Found sector mission"
          c484v9(c484v10)
          c484v9 = print
          c484v11 = "Unique name: "
          c484v13 = c484v8.uniqueName
          c484v12 = tostring
          c484v12 = c484v12(c484v13)
          c484v10 = c484v11 .. c484v12
          c484v9(c484v10)
        end
        do return c484v3, c484v7, c484v8 end
      end
    end
    c484v3 = ResetLineCount
    c484v4 = 0
    c484v3(c484v4)
    if c484v2 then
      c484v3 = print
      c484v5 = "GetRegionSectorForNode "
      c484v6 = tostring
      c484v6 = c484v6(c484v1)
      c484v4 = c484v5 .. c484v6
      c484v3(c484v4)
    end
    c484v3 = IsNull
    c484v3 = c484v3(c484v0)
    if not ((not (c484v3) and c484v1 ~= nil)) then
      c484v3 = nil
      c484v4 = nil
      do return c484v3, c484v4 end
    end
    c484v3 = c484v0:DisableCheckZone(c484v1)
    c484v4 = nil
    c484v5 = nil
    do return c484v4, c484v5 end
  end
  vT[160] = function(c485v0, c485v1, c485v2)
    local c485v3, c485v4, c485v5, c485v6, c485v7, c485v8, c485v9, c485v10, c485v11, c485v12, c485v13, c485v14, c485v15, c485v16, c485v17, c485v18, c485v19, c485v20, c485v21, c485v22, c485v23, c485v24, c485v25, c485v26, c485v27, c485v28
    local p377 = 139
    if p377 == 0 then
      c485v3 = IsNull
      c485v3 = c485v3(c485v1)
      if c485v3 then
        p377 = 234
      else
        p377 = 1
      end
    end
    if p377 == 1 then
      c485v4 = c485v1.name
      c485v3 = IsNull
      c485v3 = c485v3(c485v4)
      if c485v3 then
        p377 = 234
      else
        p377 = 2
      end
    end
    if p377 == 2 then
      c485v4 = c485v1.name
      c485v3 = tostring
      c485v3 = c485v3(c485v4)
      c485v4 = c485v1.baseNodeName
      c485v5 = c485v1.hubMission
      if not c485v5 then
        p377 = 6
      else
        p377 = 3
      end
    end
    if p377 == 3 then
      c485v5 = c485v1.hubMission
      c485v3 = c485v5
      c485v6 = string.find
      c485v8 = TAG_SEPERATOR
      c485v6 = c485v6(c485v5, c485v8)
      if c485v6 == nil then
        p377 = 5
      else
        p377 = 4
      end
    end
    if p377 == 4 then
      c485v9 = 1
      c485v10 = c485v6 - 1
      c485v7 = string.sub
      c485v5 = c485v7(c485v5, c485v9, c485v10)
      p377 = 5
    end
    if p377 == 5 then
      c485v7 = Symbol
      c485v4 = c485v7(c485v5)
      p377 = 6
    end
    if p377 == 6 then
      c485v5 = vT[159]
      c485v5, c485v6, c485v7 = c485v5(c485v0, c485v4, c485v2)
      c485v8 = nil
      c485v9 = nil
      c485v10 = nil
      c485v11 = nil
      c485v12 = false
      c485v13 = false
      c485v14 = false
      if not c485v6 then
        p377 = 186
      else
        p377 = 7
      end
    end
    if p377 == 7 then
      if not c485v2 then
        p377 = 9
      else
        p377 = 8
      end
    end
    if p377 == 8 then
      c485v15 = print
      c485v17 = "Sector: "
      c485v19 = c485v6.name
      c485v18 = tostring
      c485v18 = c485v18(c485v19)
      c485v16 = c485v17 .. c485v18
      c485v15(c485v16)
      c485v15 = print
      c485v17 = "Pending mission: "
      c485v16 = c485v17 .. c485v3
      c485v15(c485v16)
      p377 = 9
    end
    if p377 == 9 then
      c485v15 = string.find
      c485v17 = ALERT_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if not c485v15 then
        p377 = 16
      else
        p377 = 10
      end
    end
    if p377 == 10 then
      c485v15 = _T.CachedAlerts
      if not c485v15 then
        p377 = 139
      else
        p377 = 11
      end
    end
    if p377 == 11 then
      c485v16 = _T.CachedAlerts
      c485v17 = tostring
      c485v17 = c485v17(c485v4)
      c485v15 = c485v16[c485v17]
      if not c485v15 then
        p377 = 139
      else
        p377 = 12
      end
    end
    if p377 == 12 then
      c485v16 = c485v15.mAlertInfo
      c485v8 = c485v16.mMissionInfo
      c485v17 = c485v15.mAlertInfo
      c485v17 = c485v17.mId
      c485v16 = tostring
      c485v16 = c485v16(c485v17)
      c485v8.alertId = c485v16
      c485v16 = Localize
      c485v17 = "/Lotus/Language/Menu/Notification_Alert"
      c485v18 = nil
      c485v10 = c485v16(c485v17, c485v18)
      c485v16 = tostring
      c485v16 = c485v16(c485v4)
      c485v18 = _T.CachedAlerts
      c485v17 = c485v18[c485v16]
      if not c485v17 then
        p377 = 139
      else
        p377 = 13
      end
    end
    if p377 == 13 then
      c485v18 = _T.CachedAlerts
      c485v17 = c485v18[c485v16]
      c485v17 = c485v17.mAlertInfo
      c485v17 = c485v17.mTag
      c485v18 = EMPTY_SYMBOL
      if c485v17 == c485v18 then
        p377 = 139
      else
        p377 = 14
      end
    end
    if p377 == 14 then
      c485v18 = _T.CachedAlerts
      c485v17 = c485v18[c485v16]
      c485v17 = c485v17.mAlertInfo
      c485v17 = c485v17.mMissionInfo
      c485v17 = c485v17.descText
      c485v18 = EMPTY_SYMBOL
      if c485v17 == c485v18 then
        p377 = 139
      else
        p377 = 15
      end
    end
    if p377 == 15 then
      c485v17 = Localize
      c485v20 = _T.CachedAlerts
      c485v19 = c485v20[c485v16]
      c485v19 = c485v19.mAlertInfo
      c485v19 = c485v19.mMissionInfo
      c485v19 = c485v19.descText
      c485v18 = tostring
      c485v18 = c485v18(c485v19)
      c485v19 = false
      c485v9 = c485v17(c485v18, c485v19)
      p377 = 139
    end
    if p377 == 16 then
      c485v15 = string.find
      c485v17 = EVENT_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if c485v15 then
        p377 = 18
      else
        p377 = 17
      end
    end
    if p377 == 17 then
      c485v15 = string.find
      c485v17 = HARD_EVENT_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if not c485v15 then
        p377 = 33
      else
        p377 = 18
      end
    end
    if p377 == 18 then
      c485v15 = _G
      c485v15 = c485v15.CachedGoalInfo
      if not c485v15 then
        p377 = 139
      else
        p377 = 19
      end
    end
    if p377 == 19 then
      c485v16 = _G
      c485v16 = c485v16.CachedGoalInfo
      c485v17 = tostring
      c485v17 = c485v17(c485v4)
      c485v15 = c485v16[c485v17]
      if c485v15 ~= nil then
        p377 = 24
      else
        p377 = 20
      end
    end
    if p377 == 20 then
      c485v16 = _T.LockedGoalList
      if c485v16 == nil then
        p377 = 24
      else
        p377 = 21
      end
    end
    if p377 == 21 then
      c485v17 = _T.LockedGoalList
      c485v18 = tostring
      c485v18 = c485v18(c485v4)
      c485v16 = c485v17[c485v18]
      if not c485v16 then
        p377 = 24
      else
        p377 = 22
      end
    end
    if p377 == 22 then
      c485v16 = _T.LockedGoalMissionInfo
      if c485v16 == nil then
        p377 = 24
      else
        p377 = 23
      end
    end
    if p377 == 23 then
      c485v16 = _T.LockedGoalMissionInfo
      c485v17 = tostring
      c485v17 = c485v17(c485v4)
      c485v15 = c485v16[c485v17]
      p377 = 24
    end
    if p377 == 24 then
      if not c485v15 then
        p377 = 28
      else
        p377 = 25
      end
    end
    if p377 == 25 then
      c485v8 = c485v15.mMissionInfo
      c485v17 = c485v15.mId
      c485v16 = tostring
      c485v16 = c485v16(c485v17)
      c485v8.goalId = c485v16
      c485v16 = c485v8.goalTag
      c485v17 = EMPTY_SYMBOL
      if c485v16 ~= c485v17 then
        p377 = 27
      else
        p377 = 26
      end
    end
    if p377 == 26 then
      c485v16 = c485v15.mTag
      c485v8.goalTag = c485v16
      p377 = 27
    end
    if p377 == 27 then
      c485v16 = Localize
      c485v17 = c485v15.mDesc
      c485v18 = false
      c485v9 = c485v16(c485v17, c485v18)
      p377 = 31
    end
    if p377 == 28 then
      c485v16 = _T.LockedGoalList
      if not c485v16 then
        p377 = 31
      else
        p377 = 29
      end
    end
    if p377 == 29 then
      c485v17 = _T.LockedGoalList
      c485v18 = tostring
      c485v18 = c485v18(c485v4)
      c485v16 = c485v17[c485v18]
      if not c485v16 then
        p377 = 31
      else
        p377 = 30
      end
    end
    if p377 == 30 then
      c485v16 = Localize
      c485v18 = _T.LockedGoalList
      c485v19 = tostring
      c485v19 = c485v19(c485v4)
      c485v17 = c485v18[c485v19]
      c485v17 = c485v17.mDesc
      c485v18 = false
      c485v9 = c485v16(c485v17, c485v18)
      p377 = 31
    end
    if p377 == 31 then
      c485v16 = string.find
      c485v18 = HARD_EVENT_TAG
      c485v16 = c485v16(c485v3, c485v18)
      if not c485v16 then
        p377 = 139
      else
        p377 = 32
      end
    end
    if p377 == 32 then
      c485v16 = Localize
      c485v17 = "/Lotus/Language/Labels/HardMode"
      c485v18 = nil
      c485v10 = c485v16(c485v17, c485v18)
      p377 = 139
    end
    if p377 == 33 then
      c485v15 = string.find
      c485v17 = SYNDICATE_MISSION_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if not c485v15 then
        p377 = 37
      else
        p377 = 34
      end
    end
    if p377 == 34 then
      c485v15 = _T.CachedSyndicateMissions
      if not c485v15 then
        p377 = 139
      else
        p377 = 35
      end
    end
    if p377 == 35 then
      c485v16 = _T.CachedSyndicateMissions
      c485v17 = tostring
      c485v17 = c485v17(c485v4)
      c485v15 = c485v16[c485v17]
      if not c485v15 then
        p377 = 139
      else
        p377 = 36
      end
    end
    if p377 == 36 then
      c485v8 = c485v15.mMissionInfo
      c485v16 = Localize
      c485v17 = "/Lotus/Language/Menu/SyndicateMissionName"
      c485v18 = nil
      c485v10 = c485v16(c485v17, c485v18)
      p377 = 139
    end
    if p377 == 37 then
      c485v15 = string.find
      c485v17 = SORTIE_MISSION_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if not c485v15 then
        p377 = 41
      else
        p377 = 38
      end
    end
    if p377 == 38 then
      c485v15 = _T.CachedSortieMissions
      if not c485v15 then
        p377 = 139
      else
        p377 = 39
      end
    end
    if p377 == 39 then
      c485v16 = _T.CachedSortieMissions
      c485v17 = tostring
      c485v17 = c485v17(c485v4)
      c485v15 = c485v16[c485v17]
      if not c485v15 then
        p377 = 139
      else
        p377 = 40
      end
    end
    if p377 == 40 then
      c485v8 = c485v15.mMissionInfo
      c485v16 = Localize
      c485v17 = "/Lotus/Language/Menu/SortieMissionName"
      c485v18 = nil
      c485v10 = c485v16(c485v17, c485v18)
      p377 = 139
    end
    if p377 == 41 then
      c485v15 = string.find
      c485v17 = LITE_SORTIE_MISSION_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if not c485v15 then
        p377 = 45
      else
        p377 = 42
      end
    end
    if p377 == 42 then
      c485v15 = _T.CachedLiteSortieMissions
      if not c485v15 then
        p377 = 139
      else
        p377 = 43
      end
    end
    if p377 == 43 then
      c485v16 = _T.CachedLiteSortieMissions
      c485v17 = tostring
      c485v17 = c485v17(c485v4)
      c485v15 = c485v16[c485v17]
      if not c485v15 then
        p377 = 139
      else
        p377 = 44
      end
    end
    if p377 == 44 then
      c485v8 = c485v15.mMissionInfo
      c485v16 = Localize
      c485v17 = "/Lotus/Language/WorldStateWindow/LiteSortieMissionName"
      c485v18 = nil
      c485v10 = c485v16(c485v17, c485v18)
      p377 = 139
    end
    if p377 == 45 then
      c485v15 = string.find
      c485v17 = ACTIVE_MISSION_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if not c485v15 then
        p377 = 49
      else
        p377 = 46
      end
    end
    if p377 == 46 then
      c485v15 = _T.CachedActiveMissions
      if not c485v15 then
        p377 = 139
      else
        p377 = 47
      end
    end
    if p377 == 47 then
      c485v16 = _T.CachedActiveMissions
      c485v17 = tostring
      c485v17 = c485v17(c485v4)
      c485v15 = c485v16[c485v17]
      if not c485v15 then
        p377 = 139
      else
        p377 = 48
      end
    end
    if p377 == 48 then
      c485v8 = c485v15.mMissionInfo
      c485v17 = c485v15.mMissionInfo
      c485v17 = c485v17.descText
      c485v16 = tostring
      c485v10 = c485v16(c485v17)
      p377 = 139
    end
    if p377 == 49 then
      c485v15 = string.find
      c485v17 = INVASION_DEFENDER_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if not c485v15 then
        p377 = 61
      else
        p377 = 50
      end
    end
    if p377 == 50 then
      c485v15 = _T.CachedInvasionInfo
      if not c485v15 then
        p377 = 139
      else
        p377 = 51
      end
    end
    if p377 == 51 then
      c485v15 = tostring
      c485v15 = c485v15(c485v4)
      c485v17 = _T.CachedInvasionInfo
      c485v16 = c485v17[c485v15]
      if not c485v16 then
        p377 = 139
      else
        p377 = 52
      end
    end
    if p377 == 52 then
      c485v8 = c485v16.mDefenderMissionInfo
      c485v18 = c485v16.mId
      c485v17 = tostring
      c485v17 = c485v17(c485v18)
      c485v8.invasionId = c485v17
      c485v17 = c485v16.mAttackerMissionInfo
      c485v17 = c485v17.faction
      c485v8.invasionAllyFaction = c485v17
      c485v22 = Localize
      c485v23 = "/Lotus/Language/Menu/MissionIntro_Invasion"
      c485v24 = false
      c485v18 = c485v22(c485v23, c485v24)
      c485v19 = " ("
      c485v22 = Localize
      c485v24 = "/Lotus/Language/Game/Faction_"
      c485v28 = c485v16.mAttackerMissionInfo
      c485v27 = tostring
      c485v25 = c485v27(c485v28:GetFactionTag())
      c485v26 = "UC"
      c485v23 = c485v24 .. c485v25 .. c485v26
      c485v24 = false
      c485v20 = c485v22(c485v23, c485v24)
      c485v21 = ")"
      c485v17 = c485v18 .. c485v19 .. c485v20 .. c485v21
      c485v18 = c485v16.mDefenderName
      c485v19 = EMPTY_SYMBOL
      if c485v18 ~= c485v19 then
        p377 = 54
      else
        p377 = 53
      end
    end
    if p377 == 53 then
      c485v10 = c485v17
      p377 = 55
    end
    if p377 == 54 then
      c485v18 = Localize
      c485v20 = c485v16.mDefenderName
      c485v19 = tostring
      c485v19 = c485v19(c485v20)
      c485v20 = false
      c485v10 = c485v18(c485v19, c485v20)
      p377 = 55
    end
    if p377 == 55 then
      c485v18 = pairs
      c485v19 = _G
      c485v19 = c485v19.CachedGoalInfo
      c485v18, c485v19, c485v20 = c485v18(c485v19)
      p377 = 59
    end
    if p377 == 56 then
      if not c485v22 then
        p377 = 59
      else
        p377 = 57
      end
    end
    if p377 == 57 then
      c485v23 = c485v22.mInvasionNode
      if c485v23 ~= c485v4 then
        p377 = 59
      else
        p377 = 58
      end
    end
    if p377 == 58 then
      c485v23 = Localize
      c485v24 = c485v22.mDesc
      c485v25 = false
      c485v9 = c485v23(c485v24, c485v25)
      p377 = 139
    end
    if p377 == 59 then
      p377 = 60
    end
    if p377 == 60 then
      p377 = 139
    end
    if p377 == 61 then
      c485v15 = string.find
      c485v17 = INVASION_ATTACKER_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if not c485v15 then
        p377 = 73
      else
        p377 = 62
      end
    end
    if p377 == 62 then
      c485v15 = _T.CachedInvasionInfo
      if not c485v15 then
        p377 = 139
      else
        p377 = 63
      end
    end
    if p377 == 63 then
      c485v15 = tostring
      c485v15 = c485v15(c485v4)
      c485v17 = _T.CachedInvasionInfo
      c485v16 = c485v17[c485v15]
      if not c485v16 then
        p377 = 139
      else
        p377 = 64
      end
    end
    if p377 == 64 then
      c485v8 = c485v16.mAttackerMissionInfo
      c485v18 = c485v16.mId
      c485v17 = tostring
      c485v17 = c485v17(c485v18)
      c485v8.invasionId = c485v17
      c485v17 = c485v16.mDefenderMissionInfo
      c485v17 = c485v17.faction
      c485v8.invasionAllyFaction = c485v17
      c485v22 = Localize
      c485v23 = "/Lotus/Language/Menu/MissionIntro_Invasion"
      c485v24 = false
      c485v18 = c485v22(c485v23, c485v24)
      c485v19 = " ("
      c485v22 = Localize
      c485v24 = "/Lotus/Language/Game/Faction_"
      c485v28 = c485v16.mDefenderMissionInfo
      c485v27 = tostring
      c485v25 = c485v27(c485v28:GetFactionTag())
      c485v26 = "UC"
      c485v23 = c485v24 .. c485v25 .. c485v26
      c485v24 = false
      c485v20 = c485v22(c485v23, c485v24)
      c485v21 = ")"
      c485v17 = c485v18 .. c485v19 .. c485v20 .. c485v21
      c485v18 = c485v16.mAttackerName
      c485v19 = EMPTY_SYMBOL
      if c485v18 ~= c485v19 then
        p377 = 66
      else
        p377 = 65
      end
    end
    if p377 == 65 then
      c485v10 = c485v17
      p377 = 67
    end
    if p377 == 66 then
      c485v18 = Localize
      c485v20 = c485v16.mAttackerName
      c485v19 = tostring
      c485v19 = c485v19(c485v20)
      c485v20 = false
      c485v10 = c485v18(c485v19, c485v20)
      p377 = 67
    end
    if p377 == 67 then
      c485v18 = pairs
      c485v19 = _G
      c485v19 = c485v19.CachedGoalInfo
      c485v18, c485v19, c485v20 = c485v18(c485v19)
      p377 = 71
    end
    if p377 == 68 then
      if not c485v22 then
        p377 = 71
      else
        p377 = 69
      end
    end
    if p377 == 69 then
      c485v23 = c485v22.mInvasionNode
      if c485v23 ~= c485v4 then
        p377 = 71
      else
        p377 = 70
      end
    end
    if p377 == 70 then
      c485v23 = Localize
      c485v24 = c485v22.mDesc
      c485v25 = false
      c485v9 = c485v23(c485v24, c485v25)
      p377 = 139
    end
    if p377 == 71 then
      p377 = 72
    end
    if p377 == 72 then
      p377 = 139
    end
    if p377 == 73 then
      c485v15 = string.find
      c485v17 = NIGHTMARE_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if not c485v15 then
        p377 = 75
      else
        p377 = 74
      end
    end
    if p377 == 74 then
      c485v15 = Localize
      c485v16 = "/Lotus/Language/Menu/NightmareModeName"
      c485v17 = nil
      c485v10 = c485v15(c485v16, c485v17)
      c485v12 = true
      p377 = 139
    end
    if p377 == 75 then
      c485v15 = string.find
      c485v17 = PVP_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if c485v15 then
        p377 = 77
      else
        p377 = 76
      end
    end
    if p377 == 76 then
      c485v15 = c485v6.nodeType
      c485v16 = 2
      if c485v15 ~= c485v16 then
        p377 = 81
      else
        p377 = 77
      end
    end
    if p377 == 77 then
      c485v15 = _G
      c485v15 = c485v15.CachedGoalInfo
      if not c485v15 then
        p377 = 139
      else
        p377 = 78
      end
    end
    if p377 == 78 then
      c485v16 = _G
      c485v16 = c485v16.CachedGoalInfo
      c485v17 = tostring
      c485v17 = c485v17(c485v4)
      c485v15 = c485v16[c485v17]
      if not c485v15 then
        p377 = 80
      else
        p377 = 79
      end
    end
    if p377 == 79 then
      c485v16 = Localize
      c485v17 = c485v15.mDesc
      c485v18 = false
      c485v9 = c485v16(c485v17, c485v18)
      p377 = 80
    end
    if p377 == 80 then
      c485v14 = true
      p377 = 139
    end
    if p377 == 81 then
      c485v15 = string.find
      c485v17 = SORTIE_MISSION_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if not c485v15 then
        p377 = 85
      else
        p377 = 82
      end
    end
    if p377 == 82 then
      c485v15 = _T.CachedSortieMissions
      if not c485v15 then
        p377 = 85
      else
        p377 = 83
      end
    end
    if p377 == 83 then
      c485v16 = _T.CachedSortieMissions
      c485v17 = tostring
      c485v17 = c485v17(c485v4)
      c485v15 = c485v16[c485v17]
      if not c485v15 then
        p377 = 139
      else
        p377 = 84
      end
    end
    if p377 == 84 then
      c485v8 = c485v15.mMissionInfo
      c485v16 = Localize
      c485v17 = "/Lotus/Language/Menu/Notification_Sortie"
      c485v18 = nil
      c485v10 = c485v16(c485v17, c485v18)
      p377 = 139
    end
    if p377 == 85 then
      c485v15 = string.find
      c485v17 = ACTIVE_MISSION_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if not c485v15 then
        p377 = 89
      else
        p377 = 86
      end
    end
    if p377 == 86 then
      c485v15 = _T.CachedActiveMissions
      if not c485v15 then
        p377 = 89
      else
        p377 = 87
      end
    end
    if p377 == 87 then
      c485v16 = _T.CachedActiveMissions
      c485v17 = tostring
      c485v17 = c485v17(c485v4)
      c485v15 = c485v16[c485v17]
      if not c485v15 then
        p377 = 139
      else
        p377 = 88
      end
    end
    if p377 == 88 then
      c485v8 = c485v15.mMissionInfo
      c485v16 = Localize
      c485v17 = "/Lotus/Language/Menu/Notification_ActiveMission"
      c485v18 = nil
      c485v10 = c485v16(c485v17, c485v18)
      p377 = 139
    end
    if p377 == 89 then
      c485v15 = string.find
      c485v17 = KUVA_TOWER_MISSION_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if not c485v15 then
        p377 = 96
      else
        p377 = 90
      end
    end
    if p377 == 90 then
      c485v15 = _T.CachedGhostTowerMissions
      if not c485v15 then
        p377 = 96
      else
        p377 = 91
      end
    end
    if p377 == 91 then
      c485v16 = _T.CachedGhostTowerMissions
      c485v17 = tostring
      c485v17 = c485v17(c485v4)
      c485v15 = c485v16[c485v17]
      if not c485v15 then
        p377 = 139
      else
        p377 = 92
      end
    end
    if p377 == 92 then
      c485v8 = c485v15.mMissionInfo
      c485v16 = vT[17]
      c485v16 = c485v16.Ternary
      c485v18 = c485v8.minEnemyLevel
      c485v19 = 80
      if c485v19 <= c485v18 then
        p377 = 94
      else
        p377 = 93
      end
    end
    if p377 == 93 then
      c485v17 = false
      p377 = 95
    end
    if p377 == 94 then
      c485v17 = true
      p377 = 95
    end
    if p377 == 95 then
      c485v18 = "/Lotus/Language/Menu/GhostTowerHardMissionName"
      c485v19 = "/Lotus/Language/Menu/GhostTowerMissionName"
      c485v16 = c485v16(c485v17, c485v18, c485v19)
      c485v17 = Localize
      c485v19 = nil
      c485v10 = c485v17(c485v16, c485v19)
      p377 = 139
    end
    if p377 == 96 then
      c485v15 = string.find
      c485v17 = NEMESIS_MISSION_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if not c485v15 then
        p377 = 102
      else
        p377 = 97
      end
    end
    if p377 == 97 then
      c485v15 = _T.CachedNemesisMissions
      if not c485v15 then
        p377 = 100
      else
        p377 = 98
      end
    end
    if p377 == 98 then
      c485v16 = _T.CachedNemesisMissions
      c485v17 = tostring
      c485v17 = c485v17(c485v4)
      c485v15 = c485v16[c485v17]
      if not c485v15 then
        p377 = 100
      else
        p377 = 99
      end
    end
    if p377 == 99 then
      c485v16 = _T.CachedNemesisMissions
      c485v17 = tostring
      c485v17 = c485v17(c485v4)
      c485v15 = c485v16[c485v17]
      c485v15 = c485v15.mMissionInfo
      c485v8 = c485v15:Copy()
      p377 = 101
    end
    if p377 == 100 then
      c485v15 = c485v1.nemesis
      c485v15 = c485v15.rank
      c485v16 = c485v1.nemesis
      c485v16 = c485v16.faction
      c485v17 = c485v1.nemesis
      c485v17 = c485v17.name
      c485v18 = vT[156]
      c485v18 = c485v18(c485v4, c485v15, c485v16, c485v17)
      c485v8 = c485v18:Copy()
      p377 = 101
    end
    if p377 == 101 then
      c485v10 = c485v8.uniqueName
      p377 = 139
    end
    if p377 == 102 then
      c485v15 = string.find
      c485v17 = VOID_STORM_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if not c485v15 then
        p377 = 104
      else
        p377 = 103
      end
    end
    if p377 == 103 then
      c485v13 = true
      p377 = 139
    end
    if p377 == 104 then
      c485v16 = c485v1.job
      c485v15 = IsNull
      c485v15 = c485v15(c485v16)
      if c485v15 then
        p377 = 111
      else
        p377 = 105
      end
    end
    if p377 == 105 then
      c485v15 = Resource
      c485v16 = c485v1.job
      c485v15 = c485v15(c485v16)
      c485v16 = IsNull
      c485v16 = c485v16(c485v15)
      if c485v16 then
        p377 = 107
      else
        p377 = 106
      end
    end
    if p377 == 106 then
      c485v16 = Localize
      c485v17 = tostring
      c485v17 = c485v17(c485v15:GetLocTag())
      c485v18 = nil
      c485v10 = c485v16(c485v17, c485v18)
      p377 = 109
    end
    if p377 == 107 then
      c485v17 = c485v1.locTag
      c485v16 = IsNull
      c485v16 = c485v16(c485v17)
      if c485v16 then
        p377 = 109
      else
        p377 = 108
      end
    end
    if p377 == 108 then
      c485v16 = Localize
      c485v17 = c485v1.locTag
      c485v18 = nil
      c485v10 = c485v16(c485v17, c485v18)
      p377 = 109
    end
    if p377 == 109 then
      c485v16 = c485v1.isHardJob
      if not c485v16 then
        p377 = 139
      else
        p377 = 110
      end
    end
    if p377 == 110 then
      c485v17 = " ("
      c485v20 = Localize
      c485v21 = "/Lotus/Language/Labels/HardMode"
      c485v22 = true
      c485v18 = c485v20(c485v21, c485v22)
      c485v19 = ")"
      c485v10 = c485v10 .. c485v17 .. c485v18 .. c485v19
      p377 = 139
    end
    if p377 == 111 then
      c485v15 = string.find
      c485v17 = "_Cell"
      c485v15 = c485v15(c485v3, c485v17)
      if not c485v15 then
        p377 = 115
      else
        p377 = 112
      end
    end
    if p377 == 112 then
      c485v15 = _T.CachedCellMissions
      if not c485v15 then
        p377 = 115
      else
        p377 = 113
      end
    end
    if p377 == 113 then
      c485v16 = _T.CachedCellMissions
      c485v17 = tostring
      c485v17 = c485v17(c485v4)
      c485v15 = c485v16[c485v17]
      if not c485v15 then
        p377 = 139
      else
        p377 = 114
      end
    end
    if p377 == 114 then
      c485v8 = c485v15.mMissionInfo
      p377 = 139
    end
    if p377 == 115 then
      c485v15 = string.find
      c485v17 = ELITE_ALERT_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if not c485v15 then
        p377 = 119
      else
        p377 = 116
      end
    end
    if p377 == 116 then
      c485v15 = _T.CachedEliteAlertMissions
      if not c485v15 then
        p377 = 139
      else
        p377 = 117
      end
    end
    if p377 == 117 then
      c485v15 = Localize
      c485v16 = "/Lotus/Language/Menu/AlertHardMode"
      c485v17 = nil
      c485v10 = c485v15(c485v16, c485v17)
      c485v16 = _T.CachedEliteAlertMissions
      c485v17 = tostring
      c485v17 = c485v17(c485v4)
      c485v15 = c485v16[c485v17]
      if not c485v15 then
        p377 = 139
      else
        p377 = 118
      end
    end
    if p377 == 118 then
      c485v8 = c485v15.mMissionInfo
      p377 = 139
    end
    if p377 == 119 then
      c485v15 = string.find
      c485v17 = HARD_DAILY_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if not c485v15 then
        p377 = 123
      else
        p377 = 120
      end
    end
    if p377 == 120 then
      c485v15 = _T.CachedHardModeDailyMissions
      if not c485v15 then
        p377 = 123
      else
        p377 = 121
      end
    end
    if p377 == 121 then
      c485v15 = Localize
      c485v16 = "/Lotus/Language/Labels/SteelPathDaily"
      c485v17 = nil
      c485v10 = c485v15(c485v16, c485v17)
      c485v16 = _T.CachedHardModeDailyMissions
      c485v17 = tostring
      c485v17 = c485v17(c485v4)
      c485v15 = c485v16[c485v17]
      if not c485v15 then
        p377 = 139
      else
        p377 = 122
      end
    end
    if p377 == 122 then
      c485v16 = _T.CachedHardModeDailyMissions
      c485v17 = tostring
      c485v17 = c485v17(c485v4)
      c485v15 = c485v16[c485v17]
      c485v8 = c485v15.mission
      p377 = 139
    end
    if p377 == 123 then
      c485v15 = string.find
      c485v17 = HARD_MODE_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if c485v15 then
        p377 = 126
      else
        p377 = 124
      end
    end
    if p377 == 124 then
      c485v15 = c485v1.hubMission
      if not c485v15 then
        p377 = 127
      else
        p377 = 125
      end
    end
    if p377 == 125 then
      c485v15 = string.find
      c485v16 = c485v1.hubMission
      c485v17 = HARD_MODE_TAG
      c485v15 = c485v15(c485v16, c485v17)
      if c485v15 == nil then
        p377 = 127
      else
        p377 = 126
      end
    end
    if p377 == 126 then
      c485v15 = Localize
      c485v16 = "/Lotus/Language/Labels/HardMode"
      c485v17 = nil
      c485v10 = c485v15(c485v16, c485v17)
      p377 = 139
    end
    if p377 == 127 then
      c485v15 = c485v1.hubMission
      if not c485v15 then
        p377 = 131
      else
        p377 = 128
      end
    end
    if p377 == 128 then
      c485v15 = string.find
      c485v16 = c485v1.hubMission
      c485v17 = LAB_CONQUEST_MISSION_TAG
      c485v15 = c485v15(c485v16, c485v17)
      if not c485v15 then
        p377 = 131
      else
        p377 = 129
      end
    end
    if p377 == 129 then
      c485v15 = _T.ActiveLabConquest
      if not c485v15 then
        p377 = 139
      else
        p377 = 130
      end
    end
    if p377 == 130 then
      c485v15 = _T.ActiveLabConquest.Missions
      c485v8 = c485v15[1]
      c485v15 = Localize
      c485v16 = "/Lotus/Language/Conquest/SolarMapLabConquestNode"
      c485v17 = nil
      c485v10 = c485v15(c485v16, c485v17)
      p377 = 139
    end
    if p377 == 131 then
      c485v15 = c485v1.hubMission
      if not c485v15 then
        p377 = 135
      else
        p377 = 132
      end
    end
    if p377 == 132 then
      c485v15 = string.find
      c485v16 = c485v1.hubMission
      c485v17 = HEX_CONQUEST_MISSION_TAG
      c485v15 = c485v15(c485v16, c485v17)
      if not c485v15 then
        p377 = 135
      else
        p377 = 133
      end
    end
    if p377 == 133 then
      c485v15 = _T.ActiveHexConquest
      if not c485v15 then
        p377 = 139
      else
        p377 = 134
      end
    end
    if p377 == 134 then
      c485v15 = _T.ActiveHexConquest.Missions
      c485v8 = c485v15[1]
      c485v15 = Localize
      c485v16 = "/Lotus/Language/1999Echoes/1999HexConquestNode"
      c485v17 = nil
      c485v10 = c485v15(c485v16, c485v17)
      p377 = 139
    end
    if p377 == 135 then
      c485v15 = string.find
      c485v17 = PVPVE_VS_AI_NAME_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if not c485v15 then
        p377 = 137
      else
        p377 = 136
      end
    end
    if p377 == 136 then
      c485v15 = Localize
      c485v16 = "/Lotus/Language/1999/1999NodeH"
      c485v17 = nil
      c485v10 = c485v15(c485v16, c485v17)
      p377 = 139
    end
    if p377 == 137 then
      c485v15 = string.find
      c485v17 = PVPVE_VS_TENNO_NAME_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if not c485v15 then
        p377 = 139
      else
        p377 = 138
      end
    end
    if p377 == 138 then
      c485v15 = Localize
      c485v16 = "/Lotus/Language/1999PvPvE/PvPvEMatchmaking_ModeName"
      c485v17 = nil
      c485v10 = c485v15(c485v16, c485v17)
      p377 = 139
    end
    if p377 == 139 then
      if c485v8 then
        p377 = 170
      else
        p377 = 140
      end
    end
    if p377 == 140 then
      if not c485v2 then
        p377 = 142
      else
        p377 = 141
      end
    end
    if p377 == 141 then
      c485v15 = print
      c485v16 = "Using sector data"
      c485v15(c485v16)
      p377 = 142
    end
    if p377 == 142 then
      c485v8 = c485v7
      c485v8.nightmare = c485v12
      c485v8.voidStorm = c485v13
      if not c485v13 then
        p377 = 149
      else
        p377 = 143
      end
    end
    if p377 == 143 then
      c485v15 = _T.CachedVoidStormMissions
      if c485v15 == nil then
        p377 = 149
      else
        p377 = 144
      end
    end
    if p377 == 144 then
      c485v16 = _T.CachedVoidStormMissions
      c485v17 = tostring
      c485v17 = c485v17(c485v4)
      c485v15 = c485v16[c485v17]
      if not c485v15 then
        p377 = 149
      else
        p377 = 145
      end
    end
    if p377 == 145 then
      c485v16 = c485v15.tier
      c485v8.activeMissionTag = c485v16
      c485v16 = c485v15.enemyLevelIncrease
      c485v18 = c485v8.minEnemyLevel
      c485v17 = c485v18 + c485v16
      c485v8.minEnemyLevel = c485v17
      c485v18 = c485v8.maxEnemyLevel
      c485v17 = c485v18 + c485v16
      c485v8.maxEnemyLevel = c485v17
      c485v18 = c485v8.minSpaceEnemyLevel
      c485v17 = c485v18 + c485v16
      c485v8.minSpaceEnemyLevel = c485v17
      c485v18 = c485v8.maxSpaceEnemyLevel
      c485v17 = c485v18 + c485v16
      c485v8.maxSpaceEnemyLevel = c485v17
      c485v18 = c485v15.descText
      c485v17 = tostring
      c485v10 = c485v17(c485v18)
      c485v17 = string.find
      c485v19 = HARD_MODE_TAG
      c485v17 = c485v17(c485v3, c485v19)
      if c485v17 then
        p377 = 148
      else
        p377 = 146
      end
    end
    if p377 == 146 then
      c485v17 = c485v1.hubMission
      if not c485v17 then
        p377 = 149
      else
        p377 = 147
      end
    end
    if p377 == 147 then
      c485v17 = string.find
      c485v18 = c485v1.hubMission
      c485v19 = HARD_MODE_TAG
      c485v17 = c485v17(c485v18, c485v19)
      if c485v17 == nil then
        p377 = 149
      else
        p377 = 148
      end
    end
    if p377 == 148 then
      c485v18 = " ("
      c485v21 = Localize
      c485v22 = "/Lotus/Language/Labels/HardMode"
      c485v23 = nil
      c485v19 = c485v21(c485v22, c485v23)
      c485v20 = ")"
      c485v10 = c485v10 .. c485v18 .. c485v19 .. c485v20
      p377 = 149
    end
    if p377 == 149 then
      if not c485v12 then
        p377 = 152
      else
        p377 = 150
      end
    end
    if p377 == 150 then
      c485v15 = c485v8.missionType
      c485v16 = 8
      if c485v15 ~= c485v16 then
        p377 = 152
      else
        p377 = 151
      end
    end
    if p377 == 151 then
      c485v15 = 6
      c485v8.maxWaveNum = c485v15
      p377 = 152
    end
    if p377 == 152 then
      c485v15 = c485v8.archwingRequired
      if c485v15 then
        p377 = 166
      else
        p377 = 153
      end
    end
    if p377 == 153 then
      c485v16 = c485v8.keyChainName
      c485v15 = IsNull
      c485v15 = c485v15(c485v16)
      if not c485v15 then
        p377 = 166
      else
        p377 = 154
      end
    end
    if p377 == 154 then
      c485v16 = c485v8.levelOverride
      c485v15 = IsNull
      c485v15 = c485v15(c485v16)
      if c485v15 then
        p377 = 166
      else
        p377 = 155
      end
    end
    if p377 == 155 then
      c485v15 = string.find
      c485v17 = c485v8.levelOverride
      c485v16 = tostring
      c485v16 = c485v16(c485v17:GetFullName())
      c485v17 = "Zariman"
      c485v15 = c485v15(c485v16, c485v17)
      if c485v15 ~= nil then
        p377 = 166
      else
        p377 = 156
      end
    end
    if p377 == 156 then
      c485v15 = nil
      c485v16 = gMatchingService
      c485v16 = c485v16:GetSquadMembers()
      c485v17 = WeakResource
      c485v18 = "/Lotus/Types/Enemies/AdvancedSpawners/LarvlingSpawner"
      c485v17 = c485v17(c485v18)
      c485v18 = WeakResource
      c485v19 = "/Lotus/Types/Enemies/AdvancedSpawners/LawyerTreasurerSpawner"
      c485v18 = c485v18(c485v19)
      c485v19 = pairs
      c485v19, c485v20, c485v21 = c485v19(c485v16)
      p377 = 165
    end
    if p377 == 157 then
      c485v24 = cjson.decode
      c485v25 = c485v23.loadout
      c485v24 = c485v24(c485v25)
      if not c485v24 then
        p377 = 165
      else
        p377 = 158
      end
    end
    if p377 == 158 then
      c485v25 = c485v24.Nemesis
      if c485v25 then
        p377 = 165
      else
        p377 = 159
      end
    end
    if p377 == 159 then
      c485v25 = c485v8.faction
      c485v26 = 0
      if c485v25 ~= c485v26 then
        p377 = 161
      else
        p377 = 160
      end
    end
    if p377 == 160 then
      c485v15 = c485v17
      p377 = 163
    end
    if p377 == 161 then
      c485v25 = c485v8.faction
      c485v26 = 1
      if c485v25 ~= c485v26 then
        p377 = 163
      else
        p377 = 162
      end
    end
    if p377 == 162 then
      c485v15 = c485v18
      p377 = 163
    end
    if p377 == 163 then
      if not c485v15 then
        p377 = 165
      else
        p377 = 164
      end
    end
    if p377 == 164 then
      c485v8:Name__36e599df(c485v15)
      p377 = 166
    end
    if p377 == 165 then
      p377 = 166
    end
    if p377 == 166 then
      c485v15 = c485v6.name
      c485v16 = ENTRATI_LANDSCAPE_NODE_TAG
      if c485v15 ~= c485v16 then
        p377 = 170
      else
        p377 = 167
      end
    end
    if p377 == 167 then
      c485v15 = vT[91]
      c485v15 = c485v15()
      if c485v15 then
        p377 = 170
      else
        p377 = 168
      end
    end
    if p377 == 168 then
      c485v16 = gClient
      c485v15 = IsNull
      c485v15 = c485v15(c485v16)
      if c485v15 then
        p377 = 170
      else
        p377 = 169
      end
    end
    if p377 == 169 then
      c485v15 = true
      c485v8.soloMode = c485v15
      p377 = 170
    end
    if p377 == 170 then
      c485v15 = c485v6.missionTag
      c485v16 = Symbol
      c485v17 = "RECONSTRUCTION"
      c485v16 = c485v16(c485v17)
      if c485v15 == c485v16 then
        c485v15 = _T.CachedConstructionProjects
        c485v15 = pairs
        c485v16 = _T.CachedConstructionProjects
        c485v15, c485v16, c485v17 = c485v15(c485v16)
        for c485v18, c485v19 in c485v15, c485v16, c485v17 do
          c485v20 = c485v19.info
          c485v20 = c485v20.mNode
          if c485v20 == c485v4 then
            c485v20 = c485v19.progress
            if c485v20 == 1 then
              c485v20 = Localize
              c485v21 = c485v6.locTag
              c485v21 = c485v21:c_str()
              c485v22 = nil
              c485v20 = c485v20(c485v21, c485v22)
              c485v21 = Localize
              c485v22 = "/Lotus/Language/RelayReconstruction/ReconstructionSiteAttack"
              c485v23 = { LOCATION = nil }
              c485v23.LOCATION = c485v20
              c485v9 = c485v21(c485v22, c485v23)
            end
          end
        end
        for c485v18, c485v19 in c485v15, c485v16, c485v17 do
        end
      end
      c485v15 = c485v6.name
      c485v16 = APARTMENT_NODE_TAG
      if c485v15 == c485v16 then
        c485v15 = Localize
        c485v16 = "/Lotus/Language/Zariman/ZarimanApartment"
        c485v17 = {}
        c485v9 = c485v15(c485v16, c485v17)
      end
      c485v15 = nil
      c485v8.levelKeyName = c485v15
      if not c485v9 then
        c485v15 = Localize
        c485v16 = c485v6.locTag
        c485v16 = c485v16:c_str()
        c485v17 = nil
        c485v9 = c485v15(c485v16, c485v17)
      end
      c485v15 = IsDuviriNode
      c485v15 = c485v15(c485v3)
      if c485v15 then
        c485v15 = Localize
        c485v16 = "/Lotus/Language/Duviri/Duviri"
        c485v17 = {}
        c485v11 = c485v15(c485v16, c485v17)
      else
        c485v15 = c485v6.name
        c485v16 = Symbol
        c485v17 = "TennoConBHUB6"
        c485v16 = c485v16(c485v17)
        if c485v15 == c485v16 then
          c485v11 = "/Lotus/Language/Duviri/DuviriQuest/StageOneNameSol"
        else
          c485v11 = c485v5.name
        end
      end
      p377 = 219
    end
    if p377 == 186 then
      if not c485v2 then
        p377 = 188
      else
        p377 = 187
      end
    end
    if p377 == 187 then
      c485v15 = print
      c485v16 = "No sector"
      c485v15(c485v16)
      p377 = 188
    end
    if p377 == 188 then
      if c485v3 ~= "Photobooth" then
        p377 = 190
      else
        p377 = 189
      end
    end
    if p377 == 189 then
      c485v15 = Lotus_Game.LotusMissionInfo
      c485v8 = c485v15()
      c485v15 = WeakResource
      c485v16 = "/Lotus/Types/GameRules/LotusPhotoBoothGameRules"
      c485v15 = c485v15(c485v16)
      c485v8.gameRules = c485v15
      c485v15 = Localize
      c485v16 = "/Lotus/Language/Menu/Loadout_Photobooth"
      c485v17 = nil
      c485v9 = c485v15(c485v16, c485v17)
      do return c485v8, c485v9 end
    end
    if p377 == 190 then
      if c485v3 ~= "Simulacrum" then
        p377 = 192
      else
        p377 = 191
      end
    end
    if p377 == 191 then
      c485v15 = Lotus_Game.LotusMissionInfo
      c485v8 = c485v15()
      c485v15 = WeakResource
      c485v16 = "/Lotus/Types/GameRules/LotusDangerRoomGameRules"
      c485v15 = c485v15(c485v16)
      c485v8.gameRules = c485v15
      c485v15 = Localize
      c485v16 = "/Lotus/Language/Game/DangerRoomConsole"
      c485v17 = nil
      c485v9 = c485v15(c485v16, c485v17)
      do return c485v8, c485v9 end
    end
    if p377 == 192 then
      c485v15 = string.find
      c485v17 = KEY_TAG
      c485v15 = c485v15(c485v3, c485v17)
      if c485v15 == nil then
        p377 = 210
      else
        p377 = 193
      end
    end
    if p377 == 193 then
      if not c485v2 then
        p377 = 195
      else
        p377 = 194
      end
    end
    if p377 == 194 then
      c485v16 = print
      c485v17 = "Key index found"
      c485v16(c485v17)
      p377 = 195
    end
    if p377 == 195 then
      c485v18 = 1
      c485v19 = c485v15 - 1
      c485v16 = string.sub
      c485v16 = c485v16(c485v3, c485v18, c485v19)
      c485v17 = Resource
      c485v17 = c485v17(c485v16)
      c485v18 = IsNull
      c485v18 = c485v18(c485v17)
      if c485v18 then
        p377 = 210
      else
        p377 = 196
      end
    end
    if p377 == 196 then
      c485v18 = c485v17:GetRegionIdx()
      if not c485v2 then
        p377 = 198
      else
        p377 = 197
      end
    end
    if p377 == 197 then
      c485v19 = print
      c485v20 = "Getting mission from key"
      c485v19(c485v20)
      p377 = 198
    end
    if p377 == 198 then
      c485v8 = c485v17:GetMission()
      c485v19 = WeakResource
      c485v19 = c485v19(c485v16)
      c485v8.levelKeyName = c485v19
      c485v19 = c485v1.quest
      if c485v19 == nil then
        p377 = 200
      else
        p377 = 199
      end
    end
    if p377 == 199 then
      c485v19 = WeakResource
      c485v20 = c485v1.quest
      c485v19 = c485v19(c485v20)
      c485v8.keyChainName = c485v19
      p377 = 200
    end
    if p377 == 200 then
      c485v19 = c485v1.difficulty
      if c485v19 == nil then
        p377 = 203
      else
        p377 = 201
      end
    end
    if p377 == 201 then
      c485v19 = c485v1.difficulty
      c485v20 = 0
      if c485v19 < c485v20 then
        p377 = 203
      else
        p377 = 202
      end
    end
    if p377 == 202 then
      c485v19 = c485v1.difficulty
      c485v8.difficulty = c485v19
      p377 = 203
    end
    if p377 == 203 then
      c485v19 = c485v8.uniqueName
      if c485v19 == "" then
        p377 = 205
      else
        p377 = 204
      end
    end
    if p377 == 204 then
      c485v19 = Localize
      c485v20 = c485v8.uniqueName
      c485v21 = false
      c485v9 = c485v19(c485v20, c485v21)
      p377 = 206
    end
    if p377 == 205 then
      c485v19 = Localize
      c485v20 = tostring
      c485v20 = c485v20(c485v17:GetLocalizeTag())
      c485v21 = false
      c485v9 = c485v19(c485v20, c485v21)
      p377 = 206
    end
    if p377 == 206 then
      c485v19 = IsDuviriNode
      c485v19 = c485v19(c485v3)
      if not c485v19 then
        p377 = 209
      else
        p377 = 207
      end
    end
    if p377 == 207 then
      c485v19 = Localize
      c485v20 = "/Lotus/Language/Duviri/Duviri"
      c485v21 = {}
      c485v11 = c485v19(c485v20, c485v21)
      c485v19 = string.find
      c485v21 = HARD_MODE_TAG
      c485v19 = c485v19(c485v3, c485v21)
      if not c485v19 then
        p377 = 210
      else
        p377 = 208
      end
    end
    if p377 == 208 then
      c485v19 = Localize
      c485v20 = "/Lotus/Language/Labels/HardMode"
      c485v21 = nil
      c485v10 = c485v19(c485v20, c485v21)
      p377 = 210
    end
    if p377 == 209 then
      c485v20 = c485v0:GetRegions()
      c485v19 = c485v20[c485v18]
      c485v11 = c485v19.name
      p377 = 210
    end
    if p377 == 210 then
      if not c485v8 then
        p377 = 219
      else
        p377 = 211
      end
    end
    if p377 == 211 then
      c485v16 = c485v1.scenarioId
      if not c485v16 then
        p377 = 213
      else
        p377 = 212
      end
    end
    if p377 == 212 then
      c485v16 = c485v1.scenarioId
      c485v8.scenarioId = c485v16
      c485v11 = nil
      c485v19 = Localize
      c485v20 = "/Lotus/Language/G1Quests/FlotillaOperation"
      c485v21 = nil
      c485v16 = c485v19(c485v20, c485v21)
      c485v17 = ": "
      c485v9 = c485v16 .. c485v17 .. c485v9
      p377 = 213
    end
    if p377 == 213 then
      c485v16 = c485v1.goalId
      if not c485v16 then
        p377 = 215
      else
        p377 = 214
      end
    end
    if p377 == 214 then
      c485v16 = c485v1.goalId
      c485v8.goalId = c485v16
      p377 = 215
    end
    if p377 == 215 then
      c485v16 = c485v1.metadata
      if not c485v16 then
        p377 = 217
      else
        p377 = 216
      end
    end
    if p377 == 216 then
      c485v16 = c485v1.metadata
      c485v8.metadata = c485v16
      p377 = 217
    end
    if p377 == 217 then
      c485v16 = c485v1.syndicateId
      if not c485v16 then
        p377 = 219
      else
        p377 = 218
      end
    end
    if p377 == 218 then
      c485v16 = c485v1.syndicateId
      c485v8.syndicateId = c485v16
      p377 = 219
    end
    if p377 == 219 then
      if c485v9 ~= c485v10 then
        p377 = 221
      else
        p377 = 220
      end
    end
    if p377 == 220 then
      c485v10 = nil
      p377 = 221
    end
    if p377 == 221 then
      if (not c485v11 or c485v14) then
        p377 = 229
      else
        p377 = 223
      end
    end
    if p377 == 223 then
      c485v15 = c485v8.missionType
      c485v16 = 30
      if c485v15 == c485v16 then
        p377 = 229
      else
        p377 = 224
      end
    end
    if p377 == 224 then
      c485v15 = c485v8.goalTag
      c485v16 = Symbol
      c485v17 = "KahlMission"
      c485v16 = c485v16(c485v17)
      if c485v15 == c485v16 then
        p377 = 229
      else
        p377 = 225
      end
    end
    if p377 == 225 then
      c485v15 = vT[17]
      c485v15 = c485v15.Ternary
      c485v17 = c485v8.missionType
      c485v18 = 32
      if c485v17 == c485v18 then
        p377 = 227
      else
        p377 = 226
      end
    end
    if p377 == 226 then
      c485v16 = false
      p377 = 228
    end
    if p377 == 227 then
      c485v16 = true
      p377 = 228
    end
    if p377 == 228 then
      c485v17 = "_SPACE"
      c485v18 = ""
      c485v15 = c485v15(c485v16, c485v17, c485v18)
      c485v17 = " ("
      c485v20 = Localize
      c485v21 = c485v11 .. c485v15
      c485v22 = false
      c485v18 = c485v20(c485v21, c485v22)
      c485v19 = ")"
      c485v9 = c485v9 .. c485v17 .. c485v18 .. c485v19
      p377 = 229
    end
    if p377 == 229 then
      if not c485v10 then
        p377 = 231
      else
        p377 = 230
      end
    end
    if p377 == 230 then
      c485v16 = " - "
      c485v9 = c485v9 .. c485v16 .. c485v10
      p377 = 231
    end
    if p377 == 231 then
      if not c485v8 then
        p377 = 233
      else
        p377 = 232
      end
    end
    if p377 == 232 then
      do return c485v8, c485v9 end
    end
    if p377 == 233 then
      c485v15 = print
      c485v17 = "GetMissionVoteInfo failed for "
      c485v19 = c485v1.name
      c485v18 = tostring
      c485v18 = c485v18(c485v19)
      c485v16 = c485v17 .. c485v18
      c485v15(c485v16)
      p377 = 234
    end
    if p377 == 234 then
      c485v3 = nil
      c485v4 = nil
      c485v5 = nil
      do return c485v3, c485v4, c485v5 end
    end
  end
  GetMissionVoteInfo = vT[160]
  vT[160] = function(c486v0, c486v1)
    local c486v2, c486v3, c486v4, c486v5, c486v6
    c486v2 = false
    if c486v0 ~= nil then
      if c486v0 == "" then
        c486v2 = false
      else
        c486v2 = true
      end
    end
    c486v3 = Name__6dd598b2
    c486v4 = 0
    c486v3 = c486v3(c486v4)
    if c486v0 == nil then
      if c486v2 then
        c486v5 = "_"
        c486v6 = tostring
        c486v6 = c486v6(c486v1)
        c486v3 = c486v0 .. c486v5 .. c486v6
        do return c486v3 end
      end
      c486v3 = tostring
      c486v3 = c486v3(c486v1)
      do return c486v3 end
    end
    if c486v2 then
      do return c486v0 end
    end
    c486v3 = ""
    do return c486v3 end
  end
  BuildMissionMapString = vT[160]
  vT[160] = function()
    local c487v0, c487v1, c487v2, c487v3, c487v4, c487v5, c487v6
    c487v1 = gGameData
    c487v0 = IsNull
    c487v0 = c487v0(c487v1)
    if not c487v0 then
      c487v0 = gGameData
      c487v0:Name__4c0a8c95()
      c487v0 = gGameData
      c487v0 = c487v0:GetLoadOut()
      c487v3 = 1
      c487v4 = 0
      c487v1 = c487v0:GetWeaponInfo(c487v3, c487v4)
      c487v3 = c487v1.mItemType
      c487v2 = IsNull
      c487v2 = c487v2(c487v3)
      if c487v2 then
        c487v2 = vT[48]
        c487v2 = c487v2()
        c487v3 = IsNull
        c487v3 = c487v3(c487v2)
        if not c487v3 then
          c487v5 = false
          c487v6 = true
          c487v2:SetVisibility(c487v5, c487v6)
          c487v5 = true
          c487v2:Name__881bcdc3(c487v5)
        end
        c487v3 = vT[17]
        c487v3 = c487v3.GetEntityFromTag
        c487v4 = "MoaInteractionAction"
        c487v3 = c487v3(c487v4)
        c487v4 = IsNull
        c487v4 = c487v4(c487v3)
        if not c487v4 then
          c487v3:Disable()
        end
      end
    end
    do return end
  end
  RefreshPetsAfterSell = vT[160]
  vT[160] = function(c488v0)
    local c488v1, c488v2, c488v3, c488v4, c488v5, c488v6, c488v7, c488v8, c488v9, c488v10, c488v11, c488v12, c488v13, c488v14, c488v15, c488v16
    c488v1 = Resource
    c488v2 = c488v0.mItemType
    c488v1 = c488v1(c488v2)
    c488v2 = c488v1:Name__aa50aeaf()
    c488v3 = c488v0.mReqCredits
    c488v6 = c488v2 - c488v3
    c488v5 = c488v6 / c488v2
    c488v4 = c488v5 * 0.2
    c488v5 = c488v1:GetResearchIngredients()
    c488v8 = 1
    c488v6 = #c488v5
    c488v7 = 1
    for c488v8 = c488v8, c488v6, c488v7 do
      c488v11 = 1
      c488v12 = c488v0.mReqItems
      c488v9 = #c488v12
      c488v10 = 1
      for c488v11 = c488v11, c488v9, c488v10 do
        c488v13 = c488v0.mReqItems
        c488v12 = c488v13[c488v11]
        c488v12 = c488v12.mItemType
        c488v13 = c488v5[c488v8]
        c488v13 = c488v13.mItemType
        if c488v12 == c488v13 then
          c488v13 = c488v0.mReqItems
          c488v12 = c488v13[c488v11]
          c488v12 = c488v12.mItemCount
          c488v16 = c488v5[c488v8]
          c488v16 = c488v16.mItemCount
          c488v15 = c488v16 - c488v12
          c488v16 = c488v5[c488v8]
          c488v16 = c488v16.mItemCount
          c488v14 = c488v15 / c488v16
          c488v13 = c488v14 * 0.2
          c488v4 = c488v4 + c488v13
        end
      end
    end
    do return c488v4 end
  end
  GetResearchProgress = vT[160]
  vT[160] = function(c489v0)
    local c489v1, c489v2, c489v3, c489v4, c489v5, c489v6, c489v7, c489v8, c489v9, c489v10, c489v11
    local p12 = 0
    if p12 == 0 then
      c489v2 = gGameData
      c489v1 = IsNull
      c489v1 = c489v1(c489v2)
      if c489v1 then
        p12 = 2
      else
        p12 = 1
      end
    end
    if p12 == 1 then
      c489v1 = gGameData
      c489v1 = c489v1:Name__1d1bb34a()
      c489v2 = 30
      if c489v2 <= c489v1 then
        p12 = 7
      else
        p12 = 2
      end
    end
    if p12 == 2 then
      c489v1 = nil
      c489v2 = nil
      c489v3 = ipairs
      c489v6 = "truemaster"
      c489v7 = "truemasteralt"
      c489v4 = {c489v6, c489v7}
      c489v3, c489v4, c489v5 = c489v3(c489v4)
      for c489v6, c489v7 in c489v3, c489v4, c489v5 do
        c489v8 = ":"
        c489v10 = ":"
        c489v7 = c489v8 .. c489v7 .. c489v10
        c489v8 = string.find
        c489v9 = ToSearchable
        c489v9 = c489v9(c489v0)
        c489v1, c489v2 = c489v8(c489v9, c489v7)
        while c489v1 ~= nil do
          c489v8 = string.gsub
          c489v10 = string.sub
          c489v10 = c489v10(c489v0, c489v1, c489v2)
          c489v11 = ":clem:"
          c489v0 = c489v8(c489v0, c489v10, c489v11)
          c489v8 = string.find
          c489v9 = ToSearchable
          c489v9 = c489v9(c489v0)
          c489v1, c489v2 = c489v8(c489v9, c489v7)
        end
      end
      p12 = 7
    end
    if p12 == 7 then
      do return c489v0 end
    end
  end
  vT[161] = function(c490v0)
    local c490v1
    c490v1 = vT[160]
    do return c490v1(c490v0) end
  end
  ValidateTrueMaster = vT[161]
  vT[161] = function(c491v0, c491v1, c491v2)
    local c491v3, c491v4
    if c491v2 == nil then
      c491v2 = false
    end
    c491v4 = gGameData
    c491v3 = IsNull
    c491v3 = c491v3(c491v4)
    if not c491v3 then
      c491v3 = vT[160]
      c491v0 = c491v3(c491v0)
      c491v3 = gGameData
      c491v3:SetMessageOfTheDay(c491v0, c491v1, c491v2)
    end
    do return end
  end
  SetMOTD = vT[161]
  vT[161] = function(c492v0)
    local c492v1, c492v2, c492v3
    c492v3 = SLOT_TYPES
    c492v2 = c492v3[c492v0]
    c492v1 = c492v2 or "NOT_RECOGNIZED"
    do return c492v1 end
  end
  GetSlotType = vT[161]
  vT[161] = function(c493v0)
    local c493v1, c493v2, c493v3, c493v4, c493v5, c493v7, c493v8
    c493v1 = Engine.IsPlayingWithController
    c493v1 = c493v1()
    if not c493v1 then
      c493v1 = _T.ChatMaximized
      if not c493v1 then
        c493v1 = IsNull
        c493v1 = c493v1(c493v0)
        if c493v1 then
          c493v1 = true
          do return c493v1 end
        end
        c493v1 = gPlayerProfileMgr
        c493v3 = 0
        c493v1 = c493v1:GetPlayerProfile(c493v3)
        c493v2 = IsNull
        c493v2 = c493v2(c493v1)
        if c493v2 then
          c493v2 = true
          do return c493v2 end
        end
        c493v2 = c493v1:Settings()
        c493v3 = IsNull
        c493v3 = c493v3(c493v2)
        if c493v3 then
          c493v3 = true
          do return c493v3 end
        end
        c493v3 = c493v2:AutofocusMode()
        if c493v3 == 2 then
          c493v7 = "IsEndOfMatch"
          c493v8 = ""
          c493v5 = c493v0:Execute(c493v7, c493v8)
          c493v4 = not c493v5
          do return c493v4 end
        end
        if c493v3 ~= 1 then
          c493v4 = false
        else
          c493v4 = true
        end
        do return c493v4 end
      end
    end
    c493v1 = false
    do return c493v1 end
  end
  AutofocusTextfield = vT[161]
  vT[161] = function(c494v0)
    local c494v1, c494v2, c494v3, c494v4, c494v5, c494v6
    c494v1 = gRegion
    c494v1 = c494v1:IsMaster()
    if c494v1 then
      c494v1 = gGameData
      c494v1 = c494v1:HasDojoKey()
      if not c494v1 then
        c494v1 = Engine.Disconnect
        c494v2 = false
        c494v1(c494v2)
        do return end
      end
      c494v1 = _T.RailjackStopHullBreach
      if c494v1 then
        c494v1 = _T.RailjackStopHullBreach
        c494v1()
      end
      c494v1 = gRegion
      c494v1 = c494v1:GetLocalPlayerAvatar()
      c494v2 = c494v1:IsPreDeath()
      if c494v2 then
        c494v1:InstantRevive()
        c494v1:SetHealth(c494v1:GetMaxHealth())
        c494v2 = c494v1:DamageControl()
        c494v4 = c494v1:DamageControl()
        c494v2:SetShield(c494v4:GetMaxShield())
      end
    end
    c494v1 = _T
    c494v1.AbortedRailjackMission = c494v0
    c494v1 = _T
    c494v2 = true
    c494v1.ReturningToDojo = c494v2
    c494v1 = _T
    c494v2 = nil
    c494v1.RailjackAutoLaunchPending = c494v2
    c494v1 = _T.AbortedRailjackMission
    if c494v1 then
      c494v1 = gRegion
      c494v1 = c494v1:IsMaster()
      if c494v1 then
        c494v1 = gGameRules
        c494v3 = Symbol
        c494v4 = "RJMissionAborted"
        c494v3 = c494v3(c494v4)
        c494v4 = 1
        c494v1:SetNetPersistentVar(c494v3, c494v4)
      end
    end
    c494v1 = InQuestCommitment
    c494v2 = gGameData
    c494v1 = c494v1(c494v2)
    if not c494v1 then
      c494v1 = _T
      c494v2 = RAILJACK_QUEST_REPLAY_TAG
      c494v1.RailJackNextMissionNode = c494v2
    else
      c494v1 = "CrewBattleNodeDojo"
      c494v3 = gGameData
      c494v2 = IsNull
      c494v2 = c494v2(c494v3)
      if not c494v2 then
        c494v2 = gMatchingService
        c494v2 = c494v2:Name__4673aca8()
        if c494v2 then
          c494v2 = gGameData
          c494v2 = c494v2:GetScenarioHubReconnectInfo()
          c494v6 = c494v2.location
          c494v5 = tostring
          c494v3 = c494v5(c494v6)
          c494v4 = "_HUB"
          c494v1 = c494v3 .. c494v4
        end
      end
      c494v2 = _T
      c494v3 = Symbol
      c494v3 = c494v3(c494v1)
      c494v2.RailJackNextMissionNode = c494v3
      c494v2 = _T
      c494v3 = gGameRules
      c494v5 = gLotusAttractModeGameRulesType
      c494v3 = c494v3:IsA(c494v5)
      c494v2.SeamlessRailJackTransition = c494v3
      c494v2 = { name = nil, difficulty = 0 }
      c494v2.name = c494v1
      c494v3 = cjson.encode
      c494v3 = c494v3(c494v2)
      c494v4 = gMatchingService
      c494v4:SendSquadMission(c494v3)
    end
    c494v1 = vT[57]
    c494v1 = c494v1()
    c494v4 = Symbol
    c494v5 = "CrewShipGenericTunnel"
    c494v2 = c494v1:Name__19dfa8ea(c494v4(c494v5))
    c494v3 = gGameRules
    c494v3 = c494v3:GetCrewShipManager()
    c494v4 = IsNull
    c494v4 = c494v4(c494v3)
    if not c494v4 then
      c494v6 = c494v2.mission
      c494v3:SetNextMission(c494v6)
    end
    c494v5 = _T.ClearRailjackMissionState
    c494v4 = IsNull
    c494v4 = c494v4(c494v5)
    if not c494v4 then
      c494v4 = _T.ClearRailjackMissionState
      c494v4()
    end
    do return end
  end
  ReturnToDojo = vT[161]
  vT[161] = function()
    local c495v0, c495v1, c495v2, c495v3
    c495v0 = gGameRules
    c495v0 = c495v0:GetCrewShipManager()
    c495v1 = gRegion
    c495v1 = c495v1:GetLocalPlayerAvatar()
    c495v3 = IsNull
    c495v3 = c495v3(c495v0)
    c495v2 = not c495v3
    if c495v2 then
      c495v3 = IsNull
      c495v3 = c495v3(c495v1)
      c495v2 = not c495v3
      if c495v2 then
        c495v3 = IsNull
        c495v3 = c495v3(c495v0:CheckChanceExcalibur(c495v1:GetZone()))
        c495v2 = not c495v3
      end
    end
    do return c495v2 end
  end
  IsPlayerInCrewship = vT[161]
  vT[161] = function(c496v0, c496v1, c496v2, c496v3, c496v4)
    local c496v5, c496v6, c496v7, c496v8, c496v9, c496v10, c496v11, c496v12, c496v13
    c496v5 = IsChinaBuild
    c496v5 = c496v5()
    c496v5 = GetConfigBool
    c496v6 = "Graphics.UseWeGameCensoring"
    c496v5 = c496v5(c496v6)
    c496v12 = c496v2[c496v7]
    c496v13 = Symbol
    c496v13 = c496v13()
    c496v0:Attach(c496v12, c496v13, c496v8, c496v9)
    c496v7 = 1
    c496v5 = #c496v1
    c496v6 = 1
    for c496v7 = c496v7, c496v5, c496v6 do
      c496v10 = c496v7 - 1
      c496v11 = c496v1[c496v7]
      c496v12 = false
      c496v0:SetOverrideMaterial(c496v10, c496v11, c496v12)
    end
    c496v7 = 1
    c496v5 = #c496v2
    c496v6 = 1
    c496v8 = Vector
    c496v8 = c496v8()
    c496v9 = Rotation
    c496v9 = c496v9()
    c496v10 = #c496v3
    if c496v7 <= c496v10 then
      c496v8 = c496v3[c496v7]
    end
    c496v10 = #c496v4
    if c496v7 <= c496v10 then
      c496v9 = c496v4[c496v7]
    end
    do return end
  end
  ApplyCensorshipOverridesAndAttachments = vT[161]
  vT[161] = function(c497v0, c497v1, c497v2, c497v3)
    local c497v4, c497v5, c497v6, c497v8, c497v10
    c497v5 = tonumber
    c497v5 = c497v5(c497v0)
    c497v6 = 4
    if c497v5 == c497v6 then
      c497v5 = gGameData
      c497v4 = c497v5:ToggleIgnoreUser(c497v1)
    end
    c497v5 = IsNull
    c497v5 = c497v5(c497v2)
    if not c497v5 then
      c497v5 = #c497v3
      c497v6 = 0
      if c497v6 < c497v5 then
        c497v10 = tostring
        c497v10 = c497v10(c497v4)
        c497v8 = {c497v1, c497v10}
        c497v2:Name__8b1f0505(c497v3, c497v8)
      end
    end
    do return end
  end
  vT[162] = function(c501v0, c501v1, c501v2)
    local c501v3, c501v4, c501v5, c501v6, c501v8, c501v9
    c501v3 = #c501v0
    c501v4 = 0
    if c501v3 < c501v4 then
      c501v3 = vT[17]
      c501v3 = c501v3.ShowErrorMessage
      c501v4 = Localize
      c501v5 = "/Lotus/Language/Menu/Chat_InvalidUser"
      c501v6 = { USER = nil }
      c501v6.USER = c501v0
      c501v3(c501v4(c501v5, c501v6))
      do return end
    end
    c501v3 = vT[41]
    c501v3 = c501v3()
    c501v4 = function()
      local c499v0, c499v1, c499v2, c499v3, c499v4
      c499v0 = gGameData
      c499v2 = Engine.Name__664442be
      c499v3 = c501v0
      c499v0 = c499v0:Name__cfd69999(c499v2(c499v3))
      if not c499v0 then
        c499v1 = gGameData
        c499v1 = c499v1:Name__bba4d3ac()
        c499v0 = #c499v1
        c499v1 = 100
        if c499v1 <= c499v0 then
          c499v0 = c501v3
          c499v1 = function(c498v0)
            local c498v1, c498v3, c498v4, c498v5
            c498v1 = c501v0
            c498v3 = c501v0
            c498v4 = c501v3
            c498v4 = c498v4.mMovie
            c498v5 = c501v2
            c498v1(c498v0, c498v3, c498v4, c498v5)
            do return end
          end
          c499v0.UtilOnIgnoreUser = c499v1
          c499v0 = vT[17]
          c499v0 = c499v0.ShowConfirmMessage
          c499v1 = Localize
          c499v2 = "/Lotus/Language/Labels/IgnoreLimitReached"
          c499v3 = { PLAYER_NAME = nil }
          c499v4 = c501v0
          c499v3.PLAYER_NAME = c499v4
          c499v1 = c499v1(c499v2, c499v3)
          c499v2 = "UtilOnIgnoreUser"
          c499v0(c499v1, c499v2)
          do return end
        end
      end
      c499v0 = c501v3
      c499v2 = 4
      c499v1 = tostring
      c499v1 = c499v1(c499v2)
      c499v2 = c501v0
      c499v3 = c501v3
      c499v3 = c499v3.mMovie
      c499v4 = c501v2
      c499v0(c499v1, c499v2, c499v3, c499v4)
      do return end
    end
    if not c501v1 then
      c501v4()
      do return end
    end
    c501v5 = function(c500v0, c500v1)
      local c500v2, c500v3, c500v4, c500v5, c500v6
      if not c500v0 then
        c500v2 = vT[17]
        c500v2 = c500v2.ShowErrorMessage
        c500v3 = Localize
        c500v4 = "/Lotus/Language/Menu/SocialOverlay_NonExistentUserError"
        c500v5 = { USER = nil }
        c500v6 = c501v0
        c500v5.USER = c500v6
        c500v2(c500v3(c500v4, c500v5))
        do return end
      end
      c500v2 = c501v4
      c500v2()
      do return end
    end
    c501v3.UtilAccountIdResult = c501v5
    c501v5 = gGameData
    c501v8 = true
    c501v9 = "UtilAccountIdResult"
    c501v5:Name__a4e7db6e(c501v0, c501v8, c501v9)
    do return end
  end
  ToggleIgnoreUser = vT[162]
  vT[162] = function()
    local c502v0, c502v1, c502v2, c502v3, c502v5
    c502v0 = gRegion
    c502v0 = c502v0:GetLevel()
    c502v1 = IsNull
    c502v1 = c502v1(c502v0)
    if c502v1 then
      c502v1 = false
      do return c502v1 end
    end
    c502v1 = c502v0:GetFullName()
    c502v3 = string.find
    c502v5 = "EmptyLevel"
    c502v3 = c502v3(c502v1, c502v5)
    if c502v3 == nil then
      c502v2 = false
    else
      c502v2 = true
    end
    do return c502v2 end
  end
  IsEmptyLevel = vT[162]
  vT[30] = function(c503v0)
    local c503v1, c503v2, c503v3, c503v4, c503v5, c503v6, c503v7, c503v8
    c503v1 = gRegion
    c503v1 = c503v1:GetLevel()
    c503v2 = IsNull
    c503v2 = c503v2(c503v1)
    if c503v2 then
      c503v2 = false
      do return c503v2 end
    end
    c503v2 = c503v1:GetFullName()
    c503v4 = string.find
    c503v6 = "TNWDrifterCamp"
    c503v4 = c503v4(c503v2, c503v6)
    if c503v4 == nil then
      c503v3 = false
    else
      c503v3 = true
    end
    if (not c503v3 or c503v0 == nil) then
      do return c503v3 end
    end
    c503v4 = gPlayerProfileMgr
    c503v6 = 0
    c503v7 = false
    c503v4 = c503v4:GetPlayerProfile(c503v6, c503v7)
    c503v5 = IsNull
    c503v5 = c503v5(c503v4)
    if not c503v2 then
      c503v5 = c503v4:GetGameSpecificData()
      c503v6 = IsNull
      c503v6 = c503v6(c503v5)
      if not c503v6 then
        c503v6 = c503v5:GetInventory()
        c503v6 = c503v6:GetActiveQuest()
        c503v7 = WeakResource
        c503v8 = "/Lotus/Types/Keys/NewWarQuest/NewWarQuestKeyChain"
        c503v7 = c503v7(c503v8)
        if c503v6 ~= c503v7 then
          c503v8 = true
          c503v6 = c503v5:GetPlayerShip(c503v8)
          c503v6 = c503v6.mBootLocation
          c503v7 = 1
          if c503v6 == c503v7 then
            do return c503v0 end
          end
        end
        c503v6 = not c503v0
        do return c503v6 end
      end
    end
    c503v5 = true
    do return c503v5 end
  end
  vT[162] = function(c504v0)
    local c504v1
    c504v1 = vT[30]
    c504v1 = c504v1(c504v0)
    do return c504v1 end
  end
  IsCampLevel = vT[162]
  vT[31] = function()
    local c505v0, c505v1, c505v2, c505v5
    c505v1 = gRegion
    c505v0 = IsNull
    c505v0 = c505v0(c505v1)
    if c505v0 then
      c505v0 = false
      do return c505v0 end
    end
    c505v0 = gRegion
    c505v0 = c505v0:GetLevel()
    c505v1 = IsNull
    c505v1 = c505v1(c505v0)
    if c505v1 then
      c505v1 = false
      do return c505v1 end
    end
    c505v1 = c505v0:GetFullName()
    c505v2 = true
    local c505v3 = string.find
    c505v5 = "ZarimanHubApartment"
    c505v3 = c505v3(c505v1, c505v5)
    if c505v3 == nil then
      c505v3 = string.find
      c505v5 = "PBZarApartment"
      c505v3 = c505v3(c505v1, c505v5)
      if c505v3 == nil then
        c505v2 = false
      else
        c505v2 = true
      end
    end
    do return c505v2 end
  end
  vT[162] = function()
    local c506v0
    c506v0 = vT[31]
    c506v0 = c506v0()
    do return c506v0 end
  end
  IsApartmentLevel = vT[162]
  vT[162] = function()
    local c507v0, c507v1, c507v2, c507v3, c507v5
    c507v1 = gRegion
    c507v0 = IsNull
    c507v0 = c507v0(c507v1)
    if c507v0 then
      c507v0 = false
      do return c507v0 end
    end
    c507v0 = gRegion
    c507v0 = c507v0:GetLevel()
    c507v1 = IsNull
    c507v1 = c507v1(c507v0)
    if c507v1 then
      c507v1 = false
      do return c507v1 end
    end
    c507v1 = c507v0:GetFullName()
    c507v3 = string.find
    c507v5 = "TailorShop"
    c507v3 = c507v3(c507v1, c507v5)
    if c507v3 == nil then
      c507v2 = false
    else
      c507v2 = true
    end
    do return c507v2 end
  end
  IsTailorShopLevel = vT[162]
  vT[162] = function()
    local c508v0, c508v1, c508v2, c508v3, c508v4, c508v6
    c508v1 = vT[30]
    c508v2 = false
    c508v1 = c508v1(c508v2)
    if c508v1 then
      c508v1 = gGameRules
      c508v3 = WeakResource
      c508v4 = "/Lotus/Types/GameRules/CampFirstLoadFrontEndGameRules"
      c508v1 = c508v1:IsA(c508v3(c508v4))
      if c508v1 then
        c508v0 = "LoginCampPreview"
      end
      if c508v0 == nil then
        c508v0 = "LoginCamp"
        c508v1 = _T
        c508v2 = true
        c508v1.SkipDropShipCinematic = c508v2
      end
    else
      c508v1 = gPlayerProfileMgr
      c508v3 = 0
      c508v4 = false
      c508v1 = c508v1:GetPlayerProfile(c508v3, c508v4)
      c508v2 = IsNull
      c508v2 = c508v2(c508v1)
      if not c508v2 then
        c508v2 = IsParadoxPath
        c508v2 = c508v2(c508v1:GetGameSpecificData())
        if c508v2 then
          c508v0 = "ParadoxPathLogin"
        end
      end
    end
    if not c508v0 then
      c508v0 = "Login"
    end
    c508v1 = _T.BackgroundMovie
    c508v3 = "PlayCameraTransition"
    c508v6 = 0.1
    c508v4 = {c508v0, c508v6}
    c508v1:Name__8b1f0505(c508v3, c508v4)
    do return end
  end
  SetLoginCameraSpot = vT[162]
  vT[162] = function(c509v0)
    local c509v1, c509v2, c509v3, c509v6
    c509v1 = IsNull
    c509v1 = c509v1(c509v0)
    if not c509v1 then
      c509v1 = ipairs
      c509v2 = vT[37]
      c509v1, c509v2, c509v3 = c509v1(c509v2)
      for c509v4, c509v5 in c509v1, c509v2, c509v3 do
        c509v6 = c509v0:IsA(c509v5)
        if c509v6 then
          c509v6 = true
          do return c509v6 end
        end
      end
    end
    c509v1 = false
    do return c509v1 end
  end
  QuestRequiresLotusHelmet = vT[162]
  vT[162] = function(c511v0, c511v1, c511v2, c511v3, c511v4)
    local c511v5, c511v6, c511v7, c511v8, c511v9, c511v10, c511v11, c511v12, c511v13, c511v14, c511v15, c511v16, c511v17, c511v18, c511v19, c511v21
    c511v5 = ""
    c511v6 = _T.Notifications
    if c511v6 ~= nil then
      c511v7 = c511v6:GetCurrentNotifications()
      c511v8 = #c511v7
      c511v9 = 0
      if c511v9 < c511v8 then
        c511v9 = c511v6.ATTACK_POLARITY
        c511v10 = c511v6.DEFENSE_POLARITY
        c511v11 = c511v6.TACTIC_POLARITY
        c511v12 = c511v6.POWER_POLARITY
        c511v13 = c511v6.WARD_POLARITY
        c511v8 = {c511v9, c511v10, c511v11, c511v12, c511v13}
        c511v9 = c511v8[1]
        c511v10 = gGameData
        c511v10 = c511v10:Name__30a0e60b()
        c511v13 = 1
        c511v11 = #c511v2
        c511v12 = 1
        for c511v13 = c511v13, c511v11, c511v12 do
          c511v14 = c511v2[c511v13]
          if c511v14 == c511v10 then break end
          if c511v14 == c511v10 then
            c511v9 = c511v8[c511v13]
          end
        end
        c511v11 = c511v7[c511v9]
        if c511v11 ~= nil then
          c511v11 = c511v7[c511v9]
          c511v11 = c511v11.Value
          if c511v11 == 1 then
            c511v12 = Localize
            c511v13 = "/Lotus/Language/ZarimanQuest/BeginWarningFocusDesc"
            c511v14 = {}
            c511v12 = c511v12(c511v13, c511v14)
            c511v5 = c511v5 .. c511v12
          end
        end
      end
    end
    c511v7 = gGameData
    c511v7 = c511v7:GetInventory()
    c511v8 = IsNull
    c511v8 = c511v8(c511v7)
    if c511v6 == nil then
      c511v8 = gGameData
      c511v8 = c511v8:GetLoadOut()
      c511v9 = 5
      c511v10 = c511v8.mOperatorType
      c511v11 = 4
      if c511v10 == c511v11 then
        c511v9 = 9
      end
      c511v10 = c511v7:GetPreset(c511v9, c511v7:Name__9adc88cf(c511v9))
      c511v13 = 2
      c511v11 = c511v10:GetEntry(c511v13)
      c511v12 = c511v11.mItemId
      c511v12 = c511v12.mId
      c511v13 = c511v7:GetOperatorAmps()
      c511v14 = nil
      c511v17 = 1
      c511v15 = #c511v13
      c511v16 = 1
      for c511v17 = c511v17, c511v15, c511v16 do
        c511v18 = c511v13[c511v17]
        c511v19 = c511v18.mItemId
        c511v19 = c511v19.mId
        if c511v12 == c511v19 then break end
        if c511v12 == c511v19 then
          c511v14 = c511v18
        end
      end
      local p32 = 16
      if p32 == 16 then
        c511v15 = IsNull
        c511v15 = c511v15(c511v14)
        if c511v15 then
          p32 = 18
        else
          p32 = 17
        end
      end
      if p32 == 17 then
        c511v15 = c511v14.mItemType
        c511v15 = c511v15:IsA(c511v3)
        if not c511v15 then
        else
          p32 = 18
        end
      end
      if p32 == 18 then
        c511v15 = #c511v5
        c511v16 = 0
        if c511v15 <= c511v16 then
          p32 = 20
        else
          p32 = 19
        end
      end
      if p32 == 19 then
        c511v16 = "\r\n\r\n"
        c511v5 = c511v5 .. c511v16
        p32 = 20
      end
      if p32 == 20 then
        c511v16 = Localize
        c511v17 = "/Lotus/Language/ZarimanQuest/BeginWarningMoteAmpDesc"
        c511v18 = {}
        c511v16 = c511v16(c511v17, c511v18)
        c511v5 = c511v5 .. c511v16
      end
    end
    c511v8 = #c511v5
    c511v9 = 0
    if c511v9 < c511v8 then
      c511v8 = vT[41]
      c511v8 = c511v8()
      c511v9 = Localize
      c511v10 = tostring
      c511v10 = c511v10(c511v1:GetLocalizeTag())
      c511v11 = {}
      c511v9 = c511v9(c511v10, c511v11)
      c511v10 = Localize
      c511v11 = "/Lotus/Language/ZarimanQuest/BeginWarningConfirm"
      c511v12 = {}
      c511v10 = c511v10(c511v11, c511v12)
      c511v11 = Localize
      c511v12 = "/Lotus/Language/G1Quests/QuestCommitmentConfirm"
      c511v13 = { WORD = nil }
      c511v14 = string.upper
      c511v14 = c511v14(c511v10)
      c511v13.WORD = c511v14
      c511v11 = c511v11(c511v12, c511v13)
      c511v15 = Localize
      c511v16 = "/Lotus/Language/ZarimanQuest/BeginWarningCommonDesc"
      c511v17 = {}
      c511v12 = c511v15(c511v16, c511v17)
      c511v13 = "\r\n\r\n"
      c511v5 = c511v12 .. c511v13 .. c511v5
      c511v12 = function(c510v0)
        local c510v1, c510v2, c510v4
        c510v1 = c511v4
        c510v2 = false
        c510v4 = c511v10
        c510v1(c510v2, c510v0, c510v4)
        do return end
      end
      c511v8.ConfirmZarimanQuestWarning = c511v12
      c511v12 = vT[153]
      c511v14 = string.lower
      c511v14 = c511v14(c511v10)
      c511v18 = "ConfirmZarimanQuestWarning"
      c511v21 = "\r\n\r\n"
      c511v19 = c511v5 .. c511v21 .. c511v11
      c511v12(c511v0, c511v14, c511v9, c511v5, c511v11, c511v18, c511v19)
      c511v12 = true
      do return c511v12 end
    end
    c511v8 = false
    do return c511v8 end
  end
  ShowBeginZarimanQuestWarning = vT[162]
  vT[162] = function()
    local c512v0, c512v1, c512v3
    c512v0 = "/Lotus/Language/Bosses/Lotus"
    local c512v2 = gGameData
    c512v1 = IsNull
    c512v1 = c512v1(c512v2)
    if not c512v1 then
      c512v1 = gGameData
      c512v1 = c512v1:GetInventory()
      c512v2 = IsNull
      c512v2 = c512v2(c512v1)
      if not c512v2 then
        c512v2 = c512v1:GetLotusPersona()
        c512v3 = 0
        if c512v2 == c512v3 then
          c512v0 = "/Lotus/Language/Inbox/TNWQuestNatahInboxMsgSubject"
        else
          c512v3 = 2
          if c512v2 == c512v3 then
            c512v0 = "/Lotus/Language/Bosses/Margulis"
          end
        end
      end
    end
    c512v1 = Localize
    c512v3 = {}
    do return c512v1(c512v0, c512v3) end
  end
  GetLocalizedLotusName = vT[162]
  vT[162] = function(c513v0, c513v1)
    local c513v2, c513v3, c513v4, c513v5, c513v6, c513v7, c513v8, c513v9, c513v10
    local p22 = 0
    if p22 == 0 then
      c513v3 = gRegion
      c513v2 = IsNull
      c513v2 = c513v2(c513v3)
      if c513v2 then
        p22 = 17
      else
        p22 = 1
      end
    end
    if p22 == 1 then
      c513v2 = gRegion
      c513v2 = c513v2:GetLocalPlayerAvatar()
      c513v3 = IsNull
      c513v3 = c513v3(c513v2)
      if c513v3 then
        p22 = 17
      else
        p22 = 2
      end
    end
    if p22 == 2 then
      c513v5 = Symbol
      c513v6 = "IDLE"
      c513v2:SetAnimAction(c513v5(c513v6))
      c513v3 = vT[30]
      c513v4 = false
      c513v3 = c513v3(c513v4)
      if not c513v3 then
        p22 = 4
      else
        p22 = 3
      end
    end
    if p22 == 3 then
      c513v5 = Rotation
      c513v6 = 230
      c513v7 = 0
      c513v8 = 0
      c513v2:SetView(c513v5(c513v6, c513v7, c513v8))
      c513v5 = 0
      c513v2:ResetattackXL(c513v5)
      do return end
    end
    if p22 == 4 then
      c513v3 = IsParadoxPath
      c513v3 = c513v3()
      if not c513v3 then
        p22 = 6
      else
        p22 = 5
      end
    end
    if p22 == 5 then
      c513v5 = Rotation
      c513v6 = 30
      c513v7 = 0
      c513v8 = 0
      c513v2:SetView(c513v5(c513v6, c513v7, c513v8))
      p22 = 11
    end
    if p22 == 6 then
      c513v3 = vT[30]
      c513v3 = c513v3()
      if c513v3 then
        p22 = 11
      else
        p22 = 7
      end
    end
    if p22 == 7 then
      c513v3 = IsTailorShopLevel
      c513v3 = c513v3()
      if c513v3 then
        p22 = 11
      else
        p22 = 8
      end
    end
    if p22 == 8 then
      if not c513v1 then
        p22 = 10
      else
        p22 = 9
      end
    end
    if p22 == 9 then
      c513v3 = Engine.IsPS
      c513v3 = c513v3()
      if not c513v3 then
        p22 = 11
      else
        p22 = 10
      end
    end
    if p22 == 10 then
      c513v5 = Rotation
      c513v2:SetView(c513v5())
      p22 = 11
    end
    if p22 == 11 then
      if not c513v1 then
        p22 = 14
      else
        p22 = 12
      end
    end
    if p22 == 12 then
      c513v3 = Engine.IsPS
      c513v3 = c513v3()
      if not c513v3 then
        p22 = 17
      else
        p22 = 13
      end
    end
    if p22 == 13 then
      c513v3 = _T.streaming_prevLevel
      if c513v3 ~= nil then
        p22 = 17
      else
        p22 = 14
      end
    end
    if p22 == 14 then
      c513v3 = c513v2:InventoryControl()
      c513v3 = c513v3:GetActivePowerSuit()
      c513v4 = IsNull
      c513v4 = c513v4(c513v3)
      if c513v4 then
        p22 = 16
      else
        p22 = 15
      end
    end
    if p22 == 15 then
      c513v6 = Symbol
      c513v7 = "KneelToStandTurn"
      c513v4 = c513v3:GetResType(c513v6(c513v7))
      c513v0 = c513v4 or c513v0
      p22 = 16
    end
    if p22 == 16 then
      c513v7 = false
      c513v8 = 3
      c513v9 = 1
      c513v10 = true
      c513v2:PlayAnimation(c513v0, c513v7, c513v8, c513v9, c513v10)
      p22 = 17
    end
    if p22 == 17 then
      do return end
    end
  end
  PlayLoginAnim = vT[162]
  vT[162] = function(c514v0)
    local c514v1, c514v2, c514v3, c514v4, c514v5
    c514v1 = gRegion
    c514v3 = gDynamicSkyType
    c514v1 = c514v1:FindAll(c514v3)
    c514v2 = IsNull
    c514v2 = c514v2(c514v1)
    c514v4 = 1
    c514v2 = #c514v1
    c514v3 = 1
    for c514v4 = c514v4, c514v2, c514v3 do
      c514v5 = c514v1[c514v4]
      c514v5 = c514v5:IsMain()
      if c514v5 then break end
      if c514v5 then
        c514v5 = c514v1[c514v4]
        c514v5:SetTimeOfDay(c514v0)
        do return end
      end
    end
    do return end
  end
  SetTimeOfDay = vT[162]
  vT[162] = function(c515v0)
    local c515v1, c515v2, c515v3, c515v4, c515v5, c515v6, c515v7, c515v8, c515v9, c515v10, c515v11
    c515v5 = IsNull
    c515v5 = c515v5(c515v4)
    c515v5 = Engine.Name__b38e1642
    c515v6 = c515v4.mInitialStartDate
    c515v5 = c515v5(c515v6)
    c515v6 = 0
    c515v7 = 1
    c515v8 = c515v4.mScheduleInfo
    c515v5 = #c515v8
    c515v6 = 1
    for c515v7 = c515v7, c515v5, c515v6 do
      c515v9 = c515v4.mScheduleInfo
      c515v8 = c515v9[c515v7]
      c515v9 = Engine.Name__b38e1642
      c515v10 = c515v8.mExpiry
      c515v9 = c515v9(c515v10)
      c515v10 = 0
      if c515v10 < c515v9 then break end
      if c515v10 < c515v9 then
        c515v1 = true
        do return c515v1 end
      end
    end
    local c23 = -1
    repeat
      c515v2 = gGameData
      c515v2 = c515v2:GetWorldState()
      c515v3 = c515v2.mPrimeVaultTraders
      c515v4 = nil
      c515v5 = pairs
      c515v5, c515v6, c515v7 = c515v5(c515v3)
      for c515v8, c515v9 in c515v5, c515v6, c515v7 do
        c515v10 = Engine.Name__b38e1642
        c515v11 = c515v9.mActivation
        c515v10 = c515v10(c515v11)
        c515v11 = 0
        if c515v10 <= c515v11 then
          c23 = 8
          break
        end
        c515v1 = vT[120]
        c515v1 = c515v1()
        c515v2 = UI_MODE_IN_SPACE_SHIP
        if c515v1 ~= c515v2 then
          c515v1 = false
          do return c515v1 end
        end
        if c515v0 ~= 1 then
          c515v1 = false
        else
          c515v1 = true
        end
        if c515v1 then
          c23 = 16
          break
        end
      end
      if c23 ~= -1 then break end
      break
    until true
    if c23 == 8 then
      c515v4 = c515v9
    end
    do return c515v1 end
  end
  vT[163] = function(c516v0)
    local c516v1
    c516v1 = vT[162]
    do return c516v1(c516v0) end
  end
  PrimeVaultTraderPresent = vT[163]
  vT[163] = function(c518v0, c518v1, c518v2)
    local c518v3, c518v4, c518v5, c518v6, c518v7, c518v8, c518v9, c518v10, c518v11, c518v12
    c518v3 = vT[162]
    c518v3 = c518v3(c518v0)
    if not c518v3 then
      do return end
    end
    c518v3 = vT[57]
    c518v3 = c518v3()
    c518v4 = IsNull
    c518v4 = c518v4(c518v3)
    if c518v3 then
      c518v4 = Symbol
      c518v5 = "TradeHUB1"
      c518v7 = c518v4(c518v5)
      c518v5 = c518v3:Name__19dfa8ea(c518v7)
      c518v7 = c518v5.region
      c518v6 = c518v7 + 1
      c518v7 = IsRegionUnlocked
      c518v9 = gGameData
      c518v7 = c518v7(c518v3, c518v9, c518v6)
      if c518v7 then
        c518v8 = vT[41]
        c518v8 = c518v8()
        c518v9 = function(c517v0)
          local c517v1, c517v2, c517v3, c517v4, c517v5, c517v6
          c517v1 = tonumber
          c517v1 = c517v1(c517v0)
          c517v2 = 4
          if c517v1 ~= c517v2 then
            do return end
          end
          c517v1 = _T.InStarChart
          if c517v1 then
            c517v1 = _T
            c517v3 = c518v4
            c517v2 = tostring
            c517v2 = c517v2(c517v3)
            c517v1.DesiredGoToNode = c517v2
            c517v2 = c518v2
            c517v1 = IsNull
            c517v1 = c517v1(c517v2)
            if not c517v1 then
              c517v1 = c518v2
              c517v3 = "Close"
              c517v4 = "true"
              c517v1:Execute(c517v3, c517v4)
              do return end
            end
          else
            c517v1 = { name = nil }
            c517v6 = c518v4
            c517v5 = tostring
            c517v3 = c517v5(c517v6)
            c517v4 = HUB_TAG
            c517v2 = c517v3 .. c517v4
            c517v1.name = c517v2
            c517v2 = cjson.encode
            c517v2 = c517v2(c517v1)
            c517v3 = gGameData
            c517v5 = 23
            c517v3:SetHubSpawnLocation(c517v5)
            c517v3 = gMatchingService
            c517v3:SendSquadMission(c517v2)
          end
          do return end
        end
        c518v8.ConfirmMaroo = c518v9
        c518v9 = Engine.DialogSettings
        c518v9 = c518v9()
        c518v10 = 1
        c518v9.dialogType = c518v10
        c518v10 = "/Lotus/Language/Store/PrimeVaultTraderGotoConfirm"
        c518v9.locString = c518v10
        c518v10 = IsNull
        c518v10 = c518v10(c518v1)
        if not c518v10 then
          c518v11 = c518v1:GetFullName()
          c518v12 = ",512,256,0,left,nil,-50"
          c518v10 = c518v11 .. c518v12
          c518v9.icon = c518v10
        end
        c518v12 = "ConfirmMaroo"
        c518v9:SetCallback(c518v12)
        c518v10 = vT[17]
        c518v10 = c518v10.ShowCustomMessage
        c518v10(c518v9)
        do return end
      end
      c518v8 = vT[17]
      c518v8 = c518v8.ShowMessage
      c518v9 = "/Lotus/Language/Store/PrimeVaultTraderNodeLocked"
      c518v8(c518v9)
    end
    do return end
  end
  PrimeVaultTraderFastTravel = vT[163]
  vT[163] = function(c520v0, c520v1)
    local c520v2, c520v3, c520v4, c520v5, c520v6, c520v7, c520v8, c520v9, c520v10, c520v11
    c520v2 = vT[57]
    c520v2 = c520v2()
    c520v3 = IsNull
    c520v3 = c520v3(c520v2)
    if not c520v3 then
      c520v3 = Symbol
      c520v4 = "TradeHUB1"
      c520v6 = c520v3(c520v4)
      c520v4 = c520v2:Name__19dfa8ea(c520v6)
      c520v6 = c520v4.region
      c520v5 = c520v6 + 1
      c520v6 = IsRegionUnlocked
      c520v8 = gGameData
      c520v6 = c520v6(c520v2, c520v8, c520v5)
      if c520v6 then
        c520v7 = vT[41]
        c520v7 = c520v7()
        c520v8 = function(c519v0)
          local c519v1, c519v2, c519v3, c519v4, c519v5, c519v6
          c519v1 = tonumber
          c519v1 = c519v1(c519v0)
          c519v2 = 4
          if c519v1 ~= c519v2 then
            do return end
          end
          c519v1 = _T.InStarChart
          if c519v1 then
            c519v1 = _T
            c519v3 = c520v3
            c519v2 = tostring
            c519v2 = c519v2(c519v3)
            c519v1.DesiredGoToNode = c519v2
            c519v2 = c520v1
            c519v1 = IsNull
            c519v1 = c519v1(c519v2)
            if not c519v1 then
              c519v1 = c520v1
              c519v3 = "Close"
              c519v4 = "true"
              c519v1:Execute(c519v3, c519v4)
              do return end
            end
          else
            c519v1 = { name = nil }
            c519v6 = c520v3
            c519v5 = tostring
            c519v3 = c519v5(c519v6)
            c519v4 = HUB_TAG
            c519v2 = c519v3 .. c519v4
            c519v1.name = c519v2
            c519v2 = cjson.encode
            c519v2 = c519v2(c519v1)
            c519v3 = gGameData
            c519v5 = 25
            c519v3:SetHubSpawnLocation(c519v5)
            c519v3 = gMatchingService
            c519v3:SendSquadMission(c519v2)
          end
          do return end
        end
        c520v7.ConfirmMaroo = c520v8
        c520v8 = Engine.DialogSettings
        c520v8 = c520v8()
        c520v9 = 1
        c520v8.dialogType = c520v9
        c520v9 = "/Lotus/Language/Store/MarooGotoConfirm"
        c520v8.locString = c520v9
        c520v9 = IsNull
        c520v9 = c520v9(c520v0)
        if not c520v9 then
          c520v10 = c520v0:GetFullName()
          c520v11 = ",512,256,0,left,nil,-50"
          c520v9 = c520v10 .. c520v11
          c520v8.icon = c520v9
        end
        c520v11 = "ConfirmMaroo"
        c520v8:SetCallback(c520v11)
        c520v9 = vT[17]
        c520v9 = c520v9.ShowCustomMessage
        c520v9(c520v8)
        do return end
      end
      c520v7 = vT[17]
      c520v7 = c520v7.ShowMessage
      c520v8 = "/Lotus/Language/Store/MarooNodeLocked"
      c520v7(c520v8)
    end
    do return end
  end
  MarooFastTravel = vT[163]
  vT[163] = function(c521v0)
    local c521v1, c521v2, c521v3, c521v4, c521v5, c521v6, c521v7, c521v8
    c521v3 = gGameData
    c521v2 = IsNull
    c521v2 = c521v2(c521v3)
    if not c521v2 then
      local p29 = 1
      if p29 == 1 then
        c521v2 = vT[27]
        c521v3 = gGameData
        c521v2 = c521v2(c521v3)
        c521v3 = IsNull
        c521v3 = c521v3(c521v2)
        if c521v3 then
        else
          p29 = 2
        end
      end
      if p29 == 2 then
        c521v3 = WeakResource
        c521v4 = "/Lotus/Types/Keys/JadeShadows/JadeShadowQuestKeyChain"
        c521v3 = c521v3(c521v4)
        if c521v2 == c521v3 then
          p29 = 4
        else
          p29 = 3
        end
      end
      if p29 == 3 then
        c521v3 = WeakResource
        c521v4 = "/Lotus/Types/Keys/JadeShadowsPart2Constellations/JadeShadowsPart2QuestKeyChain"
        c521v3 = c521v3(c521v4)
        if c521v2 ~= c521v3 then
        else
          p29 = 4
        end
      end
      if p29 == 4 then
        c521v3 = false
        do return c521v3 end
      end
    end
    c521v2 = gMatchingService
    c521v2 = c521v2:GetSquadMembers()
    c521v5 = 1
    c521v3 = #c521v2
    c521v4 = 1
    for c521v5 = c521v5, c521v3, c521v4 do
      c521v6 = c521v2[c521v5]
      c521v7 = c521v6.isHost
      if c521v7 then break end
      c521v7 = c521v6.isLocal
      if c521v7 then break end
      if not c521v0 then
        c521v7 = cjson.decode
        c521v8 = c521v6.loadout
        c521v1 = c521v7(c521v8)
      end
    end
    local p32 = 12
    if p32 == 12 then
      c521v3 = IsNull
      c521v3 = c521v3(c521v1)
      if c521v3 then
        p32 = 26
      else
        p32 = 13
      end
    end
    if p32 == 13 then
      c521v3 = WeakResource
      c521v4 = "/Lotus/Types/Items/Ships/GrineerShip"
      c521v3 = c521v3(c521v4)
      c521v5 = c521v1.ShipType
      if c521v5 == nil then
        p32 = 15
      else
        p32 = 14
      end
    end
    if p32 == 14 then
      c521v4 = WeakResource
      c521v5 = c521v1.ShipType
      c521v4 = c521v4(c521v5)
      p32 = 16
    end
    if p32 == 15 then
      c521v4 = nil
      p32 = 16
    end
    if p32 == 16 then
      if c521v4 ~= c521v3 then
        p32 = 26
      else
        p32 = 17
      end
    end
    if p32 == 17 then
      c521v6 = c521v1.ShipCustomizations
      if c521v6 == nil then
        p32 = 20
      else
        p32 = 18
      end
    end
    if p32 == 18 then
      c521v6 = c521v1.ShipCustomizations
      c521v6 = c521v6.SkinFlavourItem
      if c521v6 == nil then
        p32 = 20
      else
        p32 = 19
      end
    end
    if p32 == 19 then
      c521v5 = WeakResource
      c521v6 = c521v1.ShipCustomizations
      c521v6 = c521v6.SkinFlavourItem
      c521v5 = c521v5(c521v6)
      p32 = 21
    end
    if p32 == 20 then
      c521v5 = nil
      p32 = 21
    end
    if p32 == 21 then
      c521v6 = IsNull
      c521v6 = c521v6(c521v5)
      if c521v6 then
        p32 = 25
      else
        p32 = 22
      end
    end
    if p32 == 22 then
      c521v6 = WeakResource
      c521v7 = "/Lotus/Upgrades/Skins/Liset/ZephyrDeluxeShipSkin"
      c521v6 = c521v6(c521v7)
      c521v7 = WeakResource
      c521v8 = "/Lotus/Upgrades/Skins/Liset/StalkerShipDeluxeSkin"
      c521v7 = c521v7(c521v8)
      c521v8 = c521v5:IsA(c521v6)
      if c521v8 then
        p32 = 24
      else
        p32 = 23
      end
    end
    if p32 == 23 then
      c521v8 = c521v5:IsA(c521v7)
      if not c521v8 then
        p32 = 25
      else
        p32 = 24
      end
    end
    if p32 == 24 then
      c521v8 = false
      do return c521v8 end
    end
    if p32 == 25 then
      c521v6 = true
      do return c521v6 end
    end
    if p32 == 26 then
      c521v3 = false
      do return c521v3 end
    end
  end
  UseGrineerShipAltsForCinematics = vT[163]
  vT[163] = function(c522v0)
    local c522v1, c522v2, c522v3, c522v4, c522v5, c522v6, c522v7, c522v8, c522v9, c522v10
    c522v2 = gGameData
    c522v1 = IsNull
    c522v1 = c522v1(c522v2)
    if c522v1 then
      c522v1 = false
      do return c522v1 end
    end
    c522v1 = gGameData
    c522v1 = c522v1:GetInventory()
    c522v2 = c522v1:GetUpgrades()
    c522v3 = ipairs
    c522v3, c522v4, c522v5 = c522v3(c522v2)
    for c522v6, c522v7 in c522v3, c522v4, c522v5 do
      c522v8 = c522v7.mItemCount
      c522v9 = 0
      if c522v9 < c522v8 then
        c522v8 = c522v7.mItemType
        c522v8 = c522v8:IsA(c522v0)
        if c522v8 then
          c522v8 = true
          do return c522v8 end
        end
      end
    end
    c522v3 = c522v1:GetRawUpgrades()
    c522v4 = ipairs
    c522v4, c522v5, c522v6 = c522v4(c522v3)
    for c522v7, c522v8 in c522v4, c522v5, c522v6 do
      c522v9 = c522v8.mItemCount
      c522v10 = 0
      if c522v10 < c522v9 then
        c522v9 = c522v8.mItemType
        c522v9 = c522v9:IsA(c522v0)
        if c522v9 then
          c522v9 = true
          do return c522v9 end
        end
      end
    end
    c522v4 = false
    do return c522v4 end
  end
  PlayerOwnsArcanes = vT[163]
  vT[164] = WeakResource
  vT[165] = "/Lotus/Weapons/Tenno/Shotgun/QuadShotgun"
  vT[164] = vT[164](vT[165])
  vT[165] = WeakResource
  vT[166] = "/Lotus/Weapons/Tenno/Melee/Dagger/DarkDagger"
  vT[163] = {vT[164], vT[165](vT[166])}
  vT[164] = function(c523v0, c523v1)
    local c523v2, c523v3, c523v4, c523v5, c523v6, c523v7, c523v8, c523v9, c523v10, c523v11, c523v12, c523v13, c523v14
    c523v9 = WeakResource
    c523v11 = c523v8:GetFullName()
    c523v12 = "Base"
    c523v10 = c523v11 .. c523v12
    c523v9 = c523v9(c523v10)
    c523v10 = IsNull
    c523v10 = c523v10(c523v9)
    c523v12 = 0
    c523v13 = 6
    c523v10 = c523v13 - 1
    c523v11 = 1
    for c523v12 = c523v12, c523v10, c523v11 do
      c523v13 = c523v2:GetWeaponVariant(c523v9, c523v12)
      c523v14 = IsNull
      c523v14 = c523v14(c523v13)
      if not c523v14 then
        c523v14 = table.insert
        c523v14(c523v3, c523v13)
      end
    end
    for c523v7, c523v8 in c523v4, c523v5, c523v6 do
      do return c523v3 end
    end
    c523v10 = c523v0:IsA(c523v9)
    if not ((not c523v10 or c523v0 == c523v8)) then
      c523v10 = table.insert
      c523v10(c523v3, c523v8)
    end
    c523v2 = c523v1
    if not c523v2 then
      c523v2 = gGameRules
      c523v2 = c523v2:GetVariantManifest()
    end
    c523v3 = IsNull
    c523v3 = c523v3(c523v2)
    if c523v3 then
      do return c523v0 end
    end
    c523v3 = {}
    c523v6 = 0
    c523v7 = 6
    c523v4 = c523v7 - 1
    c523v5 = 1
    for c523v6 = c523v6, c523v4, c523v5 do
      c523v7 = c523v2:Name__09c40e13(c523v0, c523v6)
      c523v8 = pairs
      c523v8, c523v9, c523v10 = c523v8(c523v7)
      for c523v11, c523v12 in c523v8, c523v9, c523v10 do
        c523v13 = IsNull
        c523v13 = c523v13(c523v12)
        if not c523v13 then
          c523v13 = table.insert
          c523v13(c523v3, c523v12)
        end
      end
    end
    c523v4 = ipairs
    c523v5 = vT[163]
    c523v4, c523v5, c523v6 = c523v4(c523v5)
  end
  vT[165] = function(c524v0, c524v1)
    local c524v2
    c524v2 = vT[164]
    do return c524v2(c524v0, c524v1) end
  end
  GetAllWeaponVariants = vT[165]
  vT[165] = function(c525v0, c525v1, c525v2)
    local c525v3, c525v4, c525v5, c525v6, c525v7, c525v8, c525v9, c525v10, c525v11, c525v12, c525v13, c525v14, c525v15, c525v16, c525v17, c525v18, c525v19, c525v20, c525v21, c525v22, c525v23
    c525v3 = gGameRules
    c525v3 = c525v3:GetVariantManifest()
    c525v4 = IsNull
    c525v4 = c525v4(c525v3)
    if c525v4 then
      do return c525v0 end
    end
    c525v4 = c525v0
    c525v5 = vT[17]
    c525v5 = c525v5.IsValueInTable
    c525v6 = vT[163]
    c525v5 = c525v5(c525v6, c525v0)
    if c525v5 then
      c525v5 = WeakResource
      c525v7 = c525v0:GetFullName()
      c525v8 = "Base"
      c525v6 = c525v7 .. c525v8
      c525v0 = c525v5(c525v6)
    end
    c525v5 = IsNull
    c525v5 = c525v5(c525v0)
    if c525v5 then
      do return c525v4 end
    end
    c525v5 = c525v2[c525v1]
    c525v7 = 4
    c525v8 = 5
    c525v9 = 2
    c525v10 = 3
    c525v11 = 0
    c525v12 = 1
    c525v6 = {c525v7, c525v8, c525v9, c525v10, c525v11, c525v12}
    c525v7 = nil
    c525v8 = {}
    c525v9 = ipairs
    c525v9, c525v10, c525v11 = c525v9(c525v5)
    for c525v12, c525v13 in c525v9, c525v10, c525v11 do
      c525v14 = c525v13.mItemType
      c525v14 = c525v14:GetFullName()
      c525v17 = 9
      c525v15 = c525v13:HasFeature(c525v17)
      c525v8[c525v14] = c525v15
    end
    c525v9 = ipairs
    c525v9, c525v10, c525v11 = c525v9(c525v6)
    for c525v12, c525v13 in c525v9, c525v10, c525v11 do
      c525v9 = IsNull
      c525v9 = c525v9(c525v7)
      if not c525v9 then
        do return c525v7 end
      end
      do return c525v4 end
    end
    c525v14 = c525v3:Name__09c40e13(c525v0, c525v13)
    c525v15 = IsNull
    c525v15 = c525v15(c525v14)
    if not c525v15 then
      c525v15 = #c525v14
      c525v16 = 0
      c525v15 = {}
      c525v16 = ipairs
      c525v16, c525v17, c525v18 = c525v16(c525v14)
      for c525v19, c525v20 in c525v16, c525v17, c525v18 do
        c525v22 = c525v20:GetFullName()
        c525v21 = c525v8[c525v22]
        if c525v21 then
          c525v21 = table.insert
          c525v21(c525v15, c525v20)
        end
      end
      c525v16 = #c525v15
      c525v17 = 0
      if c525v17 < c525v16 then
        c525v14 = c525v15
      end
      c525v17 = SRandomInt
      c525v18 = 1
      c525v19 = #c525v14
      c525v17 = c525v17(c525v18, c525v19)
      c525v16 = c525v14[c525v17]
      c525v17 = IsNull
      c525v17 = c525v17(c525v16)
      c525v17 = ipairs
      c525v17, c525v18, c525v19 = c525v17(c525v5)
      for c525v20, c525v21 in c525v17, c525v18, c525v19 do
        c525v22 = c525v21.mItemType
        if c525v22 == c525v16 then
          c525v23 = c525v16:GetFullName()
          c525v22 = c525v8[c525v23]
          if c525v22 then break end
          if c525v22 then
            do return c525v16 end
          end
          if c525v7 == nil then
            c525v7 = c525v16
          end
        end
      end
      for c525v20, c525v21 in c525v17, c525v18, c525v19 do
      end
      for c525v19, c525v20 in c525v16, c525v17, c525v18 do
      end
    end
  end
  vT[166] = function(c526v0, c526v1)
    local c526v2, c526v3, c526v4, c526v5, c526v6, c526v7, c526v8, c526v9
    c526v2 = gGameRules
    c526v2 = c526v2:GetVariantManifest()
    c526v3 = IsNull
    c526v3 = c526v3(c526v2)
    if c526v3 then
      do return end
    end
    c526v3 = vT[164]
    c526v3 = c526v3(c526v1)
    c526v4 = #c526v3
    if c526v4 == 0 then
      c526v4 = table.insert
      c526v4(c526v3, c526v1)
    end
    c526v4 = 1
    while true do
      c526v5 = #c526v0
      if c526v5 < c526v4 then
        do return end
      end
      c526v5 = ResetLineCount
      c526v6 = 0
      c526v5(c526v6)
      c526v5 = c526v0[c526v4]
      c526v6 = type
      c526v6 = c526v6(c526v5)
      if c526v6 == "string" then
        c526v6 = string.gsub
        c526v8 = "/StoreItems"
        c526v9 = ""
        c526v6 = c526v6(c526v5, c526v8, c526v9)
        c526v7 = WeakResource
        c526v5 = c526v7(c526v6)
      else
        c526v6 = c526v0[c526v4]
        c526v5 = c526v6.mItemType
      end
      c526v6 = vT[17]
      c526v6 = c526v6.IsValueInTable
      c526v6 = c526v6(c526v3, c526v5)
      if c526v6 then
        c526v6 = table.remove
        c526v6(c526v0, c526v4)
      else
        c526v4 = c526v4 + 1
      end
    end
  end
  vT[167] = function(c527v0, c527v1)
    local c527v2, c527v3, c527v4, c527v5, c527v6, c527v7, c527v8, c527v9, c527v10, c527v11, c527v12, c527v13, c527v14, c527v15
    c527v3 = {}
    c527v4 = -1
    c527v5 = -1
    c527v6 = ipairs
    c527v6, c527v7, c527v8 = c527v6(c527v0)
    for c527v9, c527v10 in c527v6, c527v7, c527v8 do
      c527v11 = c527v10.mItemType
      if c527v1 == c527v11 then
        c527v11 = c527v10.mPolarized
        c527v12 = gGameConfig
        c527v14 = c527v10.mXP
        c527v15 = c527v10.mItemType
        c527v12 = c527v12:GetItemLevel(c527v14, c527v15)
        if c527v4 < c527v11 then
          c527v4 = c527v11
          c527v5 = c527v12
        else
          if not ((c527v11 ~= c527v4 or c527v12 <= c527v5)) then
            c527v5 = c527v12
          end
        end
      end
    end
    c527v6 = ipairs
    c527v6, c527v7, c527v8 = c527v6(c527v0)
    for c527v9, c527v10 in c527v6, c527v7, c527v8 do
      c527v11 = c527v10.mItemType
      if c527v1 == c527v11 then
        c527v11 = c527v10.mPolarized
        if c527v11 == c527v4 then
          c527v11 = gGameConfig
          c527v13 = c527v10.mXP
          c527v14 = c527v10.mItemType
          c527v11 = c527v11:GetItemLevel(c527v13, c527v14)
          c527v12 = IsNull
          c527v12 = c527v12(c527v11)
          if not ((c527v12 or c527v11 ~= c527v5)) then
            c527v12 = table.insert
            c527v12(c527v3, c527v10)
          end
        end
      end
    end
    c527v6 = #c527v3
    c527v7 = 0
    if c527v7 < c527v6 then
      c527v6 = SRandomInt
      c527v7 = 1
      c527v8 = #c527v3
      c527v6 = c527v6(c527v7, c527v8)
      c527v2 = c527v3[c527v6]
    end
    do return c527v2 end
  end
  vT[168] = function(c528v0)
    local c528v1, c528v2, c528v3, c528v4, c528v5, c528v6, c528v7
    c528v2 = gGameData
    c528v1 = IsNull
    c528v1 = c528v1(c528v2:GetInventory())
    c528v1 = gGameData
    c528v1 = c528v1:GetInventory()
    c528v1 = c528v1.mXPInfo
    c528v4 = 1
    c528v2 = #c528v1
    c528v3 = 1
    for c528v4 = c528v4, c528v2, c528v3 do
      c528v6 = c528v1[c528v4]
      c528v6 = c528v6.mItemType
      c528v5 = IsNull
      c528v5 = c528v5(c528v6)
      if not c528v5 then
        c528v6 = _T.xpInfoDictionary
        c528v5 = IsNull
        c528v5 = c528v5(c528v6)
        if c528v5 then
          c528v5 = _T
          c528v6 = {}
          c528v5.xpInfoDictionary = c528v6
        end
        c528v5 = _T.xpInfoDictionary
        c528v6 = c528v1[c528v4]
        c528v6 = c528v6.mItemType
        c528v6 = c528v6:GetFullName()
        c528v7 = c528v1[c528v4]
        c528v7 = c528v7.mXP
        c528v5[c528v6] = c528v7
      end
    end
    if c528v0 == nil then
      c528v0 = false
    end
    if not c528v0 then
      c528v1 = _T.xpInfoDictionary
      if c528v1 ~= nil then
        do return end
      end
    end
    c528v2 = gGameData
    c528v1 = IsNull
    c528v1 = c528v1(c528v2)
    do return end
  end
  CacheWeaponXp = vT[168]
  vT[168] = function(c529v0)
    local c529v1, c529v2, c529v3, c529v4
    c529v2 = _T.xpInfoDictionary
    c529v1 = IsNull
    c529v1 = c529v1(c529v2)
    if c529v1 then
      c529v1 = false
      do return c529v1 end
    end
    c529v2 = _T.xpInfoDictionary
    c529v3 = c529v0:GetFullName()
    c529v1 = c529v2[c529v3]
    if c529v1 == nil then
      c529v2 = false
      do return c529v2 end
    end
    c529v2 = gGameConfig
    c529v2 = c529v2:GetItemLevel(c529v1, c529v0)
    c529v4 = gGameConfig
    c529v4 = c529v4:GetLevelCap(c529v0)
    if c529v2 ~= c529v4 then
      c529v3 = false
    else
      c529v3 = true
    end
    do return c529v3 end
  end
  IsWeaponMastered = vT[168]
  vT[168] = function(c530v0)
    local c530v1, c530v2, c530v3, c530v4, c530v5, c530v6, c530v7, c530v9, c530v10
    c530v2 = gGameData
    c530v1 = IsNull
    c530v1 = c530v1(c530v2)
    c530v1 = gGameData
    c530v1 = c530v1:GetInventory()
    c530v2 = IsNull
    c530v2 = c530v2(c530v1)
    c530v2 = c530v1:GetOwnedItems(c530v0)
    c530v3 = nil
    c530v4 = c530v2
    c530v5 = nil
    c530v6 = nil
    for c530v7, c530v8 in c530v4, c530v5, c530v6 do
      c530v9 = c530v3.mXP
      c530v10 = c530v8.mXP
      c530v3 = c530v8
    end
    if c530v1 then
      c530v4 = IsNull
      c530v4 = c530v4(c530v3)
      if not c530v4 then
        c530v4 = c530v3.mXP
        c530v5 = 0
        if c530v5 < c530v4 then
          c530v4 = gGameConfig
          c530v6 = c530v3.mXP
          c530v6 = c530v4:GetItemLevel(c530v6, c530v0)
          c530v7 = gGameConfig
          c530v10 = c530v3.mPolarized
          c530v5 = math.min
          c530v4 = c530v5(c530v6, c530v7:Name__123bb887(c530v0, c530v10))
          c530v5 = gGameConfig
          c530v5 = c530v5:GetLevelCap(c530v0)
          if c530v4 < c530v5 then
            c530v6 = false
          else
            c530v6 = true
          end
          do return c530v6 end
        end
      end
    end
    c530v1 = IsWeaponMastered
    do return c530v1(c530v0) end
  end
  IsWeaponMasteredRealWeaponPref = vT[168]
  vT[168] = function(c531v0, c531v1, c531v2, c531v3, c531v4)
    local c531v5, c531v6, c531v7, c531v8, c531v9, c531v10, c531v11, c531v12, c531v13, c531v14, c531v15, c531v16, c531v17
    local p58 = 0
    if p58 == 0 then
      if c531v0 ~= nil then
        p58 = 2
      else
        p58 = 1
      end
    end
    if p58 == 1 then
      do return end
    end
    if p58 == 2 then
      c531v5 = nil
      c531v6 = nil
      c531v9 = c531v3[c531v0]
      c531v8 = #c531v9
      c531v9 = 0
      if c531v9 < c531v8 then
        p58 = 4
      else
        p58 = 3
      end
    end
    if p58 == 3 then
      c531v7 = false
      p58 = 5
    end
    if p58 == 4 then
      c531v7 = true
      p58 = 5
    end
    if p58 == 5 then
      c531v9 = c531v2[c531v0]
      c531v8 = #c531v9
      if c531v8 == 0 then
        p58 = 10
      else
        p58 = 6
      end
    end
    if p58 == 6 then
      if c531v1 == nil then
        p58 = 29
      else
        p58 = 7
      end
    end
    if p58 == 7 then
      c531v8 = 0
      if c531v1 <= c531v8 then
        p58 = 29
      else
        p58 = 8
      end
    end
    if p58 == 8 then
      c531v8 = SRandom
      c531v9 = 0
      c531v10 = 1
      c531v8 = c531v8(c531v9, c531v10)
      if (c531v1 < c531v8 or not c531v7) then
        p58 = 29
      else
        p58 = 10
      end
    end
    if p58 == 10 then
      if c531v4 then
        c531v8 = vT[17]
        c531v8 = c531v8.CopyTable
        c531v9 = c531v3[c531v0]
        c531v5 = c531v8(c531v9)
        c531v8 = 1
        while true do
          c531v9 = #c531v5
          if c531v9 < c531v8 then break end
          c531v9 = c531v5[c531v8]
          c531v10 = string.gsub
          c531v12 = "/StoreItems"
          c531v13 = ""
          c531v10 = c531v10(c531v9, c531v12, c531v13)
          c531v11 = WeakResource
          c531v11 = c531v11(c531v10)
          c531v12 = IsWeaponMastered
          c531v12 = c531v12(c531v11)
          if c531v12 then
            c531v12 = table.remove
            c531v12(c531v5, c531v8)
          else
            c531v8 = c531v8 + 1
          end
        end
        c531v9 = #c531v5
        if c531v9 == 0 then
          c531v5 = c531v3[c531v0]
        end
      else
        c531v5 = c531v3[c531v0]
      end
      c531v8 = SRandomInt
      c531v9 = 1
      c531v10 = #c531v5
      c531v8 = c531v8(c531v9, c531v10)
      c531v9 = c531v5[c531v8]
      c531v10 = IsNull
      c531v10 = c531v10(c531v9)
      if not c531v10 then
        c531v10 = string.gsub
        c531v12 = "/StoreItems"
        c531v13 = ""
        c531v10 = c531v10(c531v9, c531v12, c531v13)
        c531v11 = WeakResource
        c531v6 = c531v11(c531v10)
        c531v11 = 3
        if c531v0 ~= c531v11 then
          c531v11 = IsWeaponMastered
          c531v11 = c531v11(c531v6)
          if not ((not c531v11 or c531v4)) then
            c531v11 = SRandom
            c531v12 = 0
            c531v13 = 1
            c531v11 = c531v11(c531v12, c531v13)
            c531v12 = 0.25
            if c531v11 <= c531v12 then
              c531v12 = vT[168]
              c531v14 = 1
              c531v17 = true
              c531v6 = c531v12(c531v0, c531v14, c531v2, c531v3, c531v17)
              c531v12 = print
              c531v14 = "GenerateWeaponSelection - Rerolling mastered, unowned weapon. Original weapon: "
              c531v15 = c531v6:GetName()
              c531v16 = ". New weapon: "
              c531v17 = c531v6:GetName()
              c531v13 = c531v14 .. c531v15 .. c531v16 .. c531v17
              c531v12(c531v13)
            end
          end
        end
        c531v11 = IsNull
        c531v11 = c531v11(c531v6)
        if not c531v11 then
          c531v11 = print
          c531v13 = c531v6:GetFullName()
          c531v14 = " generated as an unowned Cave selection for category: "
          c531v15 = tostring
          c531v15 = c531v15(c531v0)
          c531v12 = c531v13 .. c531v14 .. c531v15
          c531v11(c531v12)
        end
        c531v11 = vT[166]
        c531v12 = c531v3[c531v0]
        c531v11(c531v12, c531v6)
        c531v11 = vT[166]
        c531v12 = c531v2[c531v0]
        c531v11(c531v12, c531v6)
      end
      p58 = 32
    end
    if p58 == 29 then
      c531v5 = c531v2[c531v0]
      c531v8 = SRandomInt
      c531v9 = 1
      c531v10 = #c531v5
      c531v8 = c531v8(c531v9, c531v10)
      c531v9 = c531v5[c531v8]
      c531v6 = c531v9.mItemType
      c531v9 = vT[165]
      c531v6 = c531v9(c531v6, c531v0, c531v2)
      c531v9 = IsNull
      c531v9 = c531v9(c531v6)
      if c531v9 then
        p58 = 31
      else
        p58 = 30
      end
    end
    if p58 == 30 then
      c531v9 = print
      c531v11 = c531v6:GetFullName()
      c531v12 = " generated as an owned Cave selection for category: "
      c531v13 = tostring
      c531v13 = c531v13(c531v0)
      c531v10 = c531v11 .. c531v12 .. c531v13
      c531v9(c531v10)
      p58 = 31
    end
    if p58 == 31 then
      c531v9 = vT[166]
      c531v10 = c531v2[c531v0]
      c531v9(c531v10, c531v6)
      c531v9 = vT[166]
      c531v10 = c531v3[c531v0]
      c531v9(c531v10, c531v6)
      p58 = 32
    end
    if p58 == 32 then
      c531v8 = IsNull
      c531v8 = c531v8(c531v6)
      if not c531v8 then
        p58 = 34
      else
        p58 = 33
      end
    end
    if p58 == 33 then
      c531v8 = print
      c531v10 = "Null WeaponInfo generated as a Cave selection for category: "
      c531v11 = tostring
      c531v11 = c531v11(c531v0)
      c531v9 = c531v10 .. c531v11
      c531v8(c531v9)
      p58 = 34
    end
    if p58 == 34 then
      do return c531v6 end
    end
  end
  vT[169] = function(c532v0)
    local c532v1, c532v2, c532v3, c532v4, c532v5, c532v8, c532v9
    c532v1 = {}
    c532v2 = {}
    c532v3 = ipairs
    c532v3, c532v4, c532v5 = c532v3(c532v0)
    for c532v6, c532v7 in c532v3, c532v4, c532v5 do
      if c532v7 ~= nil then
        c532v8 = c532v7.mItemType
        if c532v8 ~= nil then
          c532v9 = c532v7.mItemType
          c532v9 = c532v9:GetFullName()
          c532v8 = c532v1[c532v9]
          if not c532v8 then
            c532v8 = table.insert
            c532v8(c532v2, c532v7)
            c532v8 = c532v7.mItemType
            c532v8 = c532v8:GetFullName()
            c532v9 = true
            c532v1[c532v8] = c532v9
          end
        end
      end
    end
    do return c532v2 end
  end
  vT[170] = function(c533v0)
    local c533v1, c533v2, c533v3, c533v4, c533v5, c533v6, c533v7, c533v9
    c533v1 = 1
    c533v2 = WeakResource
    c533v3 = "/Lotus/Weapons/Tenno/Gear/MiningLaserWeapon"
    c533v2 = c533v2(c533v3)
    c533v3 = WeakResource
    c533v4 = "/Lotus/Weapons/Tenno/LotusLongGun"
    c533v3 = c533v3(c533v4)
    c533v4 = WeakResource
    c533v5 = "/Lotus/Types/Game/LotusMeleeWeapon"
    c533v4 = c533v4(c533v5)
    while true do
      c533v5 = #c533v0
      if c533v5 < c533v1 then
        do return end
      end
      c533v5 = c533v0[c533v1]
      c533v6 = c533v5.mItemType
      c533v6 = c533v5.mItemType
      c533v6 = c533v6:GetFullName()
      c533v7 = string.find
      c533v9 = "PlayerPowerSuit"
      c533v7 = c533v7(c533v6, c533v9)
      c533v7 = string.find
      c533v9 = "Operator"
      c533v7 = c533v7(c533v6, c533v9)
      c533v7 = string.find
      c533v9 = "Npc"
      c533v7 = c533v7(c533v6, c533v9)
      c533v7 = string.find
      c533v9 = "Platformer"
      c533v7 = c533v7(c533v6, c533v9)
      c533v7 = c533v5.mItemType
      c533v7 = c533v7:IsA(c533v2)
      c533v7 = c533v5.mItemType
      c533v7 = c533v5.mItemType
      c533v7 = c533v5.mAltWeaponModeId
      c533v7 = c533v7:IsZero()
      c533v7 = table.remove
      c533v7(c533v0, c533v1)
      c533v1 = c533v1 + 1
      c533v1 = c533v1 + 1
    end
  end
  vT[171] = function(c535v0)
    local c535v1, c535v2, c535v3, c535v4, c535v5, c535v6, c535v7, c535v8, c535v9, c535v10, c535v11, c535v12, c535v13, c535v14, c535v15, c535v16, c535v17, c535v18, c535v19, c535v20, c535v21, c535v22, c535v23, c535v24, c535v25, c535v26, c535v27, c535v28, c535v29, c535v30, c535v31, c535v32, c535v34, c535v35, c535v36, c535v37, c535v38, c535v39, c535v40, c535v41, c535v43
    c535v38 = c535v37.mItemType
    c535v32 = true
    local c535v33 = pairs
    c535v36 = c535v29.mSlot
    c535v34 = c535v3[c535v36]
    c535v33, c535v34, c535v35 = c535v33(c535v34)
    for c535v36, c535v37 in c535v33, c535v34, c535v35 do
      c535v38 = string.gsub
      c535v40 = "/StoreItems"
      c535v41 = ""
      c535v38 = c535v38(c535v37, c535v40, c535v41)
      c535v39 = WeakResource
      c535v39 = c535v39(c535v38)
      c535v32 = true
      c535v43 = 0
      c535v40 = c535v7:GetWeaponVariant(c535v31, c535v43)
      c535v32 = true
      c535v33 = print
      c535v35 = "override is not available for: "
      c535v36 = tostring
      c535v36 = c535v36(c535v31:GetFullName())
      c535v34 = c535v35 .. c535v36
      c535v33(c535v34)
      c535v33 = c535v29.mSlot
      c535v34 = 3
      c535v35 = 1
      c535v33 = 3
      c535v34 = 1
      c535v36 = print
      c535v38 = "overriding suit "
      c535v39 = tostring
      c535v39 = c535v39(c535v35)
      c535v37 = c535v38 .. c535v39
      c535v36(c535v37)
      c535v36 = print
      c535v38 = "overriding suit "
      c535v40 = c535v1[c535v35]
      c535v39 = tostring
      c535v39 = c535v39(c535v40:GetFullName())
      c535v37 = c535v38 .. c535v39
      c535v36(c535v37)
      c535v36 = print
      c535v38 = "with "
      c535v39 = tostring
      c535v39 = c535v39(c535v31:GetFullName())
      c535v37 = c535v38 .. c535v39
      c535v36(c535v37)
      c535v1[c535v35] = c535v31
      c535v33 = c535v29.mSlot
      c535v34 = 1
      if c535v33 == c535v34 then
        c535v33 = print
        c535v35 = "overriding primary "
        c535v37 = c535v2[1]
        c535v36 = tostring
        c535v36 = c535v36(c535v37:GetFullName())
        c535v34 = c535v35 .. c535v36
        c535v33(c535v34)
        c535v33 = print
        c535v35 = "with "
        c535v36 = tostring
        c535v36 = c535v36(c535v31:GetFullName())
        c535v34 = c535v35 .. c535v36
        c535v33(c535v34)
        c535v2[1] = c535v31
      else
        c535v33 = c535v29.mSlot
        c535v34 = 0
        if c535v33 == c535v34 then
          c535v33 = print
          c535v35 = "overriding secondary "
          c535v37 = c535v2[2]
          c535v36 = tostring
          c535v36 = c535v36(c535v37:GetFullName())
          c535v34 = c535v35 .. c535v36
          c535v33(c535v34)
          c535v33 = print
          c535v35 = "with "
          c535v36 = tostring
          c535v36 = c535v36(c535v31:GetFullName())
          c535v34 = c535v35 .. c535v36
          c535v33(c535v34)
          c535v2[2] = c535v31
        else
          c535v33 = c535v29.mSlot
          c535v34 = 5
          if c535v33 == c535v34 then
            c535v33 = print
            c535v35 = "overriding melee "
            c535v37 = c535v2[3]
            c535v36 = tostring
            c535v36 = c535v36(c535v37:GetFullName())
            c535v34 = c535v35 .. c535v36
            c535v33(c535v34)
            c535v33 = print
            c535v35 = "with "
            c535v36 = tostring
            c535v36 = c535v36(c535v31:GetFullName())
            c535v34 = c535v35 .. c535v36
            c535v33(c535v34)
            c535v2[3] = c535v31
          end
        end
      end
      for c535v28, c535v29 in c535v25, c535v26, c535v27 do
        c535v25 = Lotus_Game.DuviriCaveOffers
        c535v25 = c535v25()
        c535v25.mSeed = c535v0
        c535v25.mWarframes = c535v1
        c535v25.mWeapons = c535v2
        c535v26 = gGameData
        c535v26:SetDuviriCaveOffers(c535v25)
        do return end
      end
      c535v30 = print
      c535v32 = "Checking "
      c535v38 = c535v29.mSlot
      c535v37 = tostring
      c535v33 = c535v37(c535v38)
      c535v34 = " override with "
      c535v39 = c535v29.mTypeNames
      c535v38 = #c535v39
      c535v37 = tostring
      c535v35 = c535v37(c535v38)
      c535v36 = " typenames."
      c535v31 = c535v32 .. c535v33 .. c535v34 .. c535v35 .. c535v36
      c535v30(c535v31)
      c535v30 = SRandom
      c535v31 = 0
      c535v32 = 1
      c535v30 = c535v30(c535v31, c535v32)
      c535v31 = c535v29.mChance
      c535v30 = print
      c535v31 = "Override chance failed."
      c535v30(c535v31)
      c535v30 = SRandomInt
      c535v31 = 1
      c535v33 = c535v29.mTypeNames
      c535v32 = #c535v33
      c535v30 = c535v30(c535v31, c535v32)
      c535v31 = string.gsub
      c535v33 = c535v29.mTypeNames
      c535v32 = c535v33[c535v30]
      c535v33 = "/StoreItems"
      c535v34 = ""
      c535v31 = c535v31(c535v32, c535v33, c535v34)
      c535v32 = WeakResource
      c535v31 = c535v32(c535v31)
      c535v32 = IsNull
      c535v32 = c535v32(c535v31)
      c535v32 = print
      c535v33 = "Override type is null"
      c535v32(c535v33)
      c535v32 = false
      c535v33 = pairs
      c535v36 = c535v29.mSlot
      c535v34 = c535v4[c535v36]
      c535v33, c535v34, c535v35 = c535v33(c535v34)
      c535v28 = 5
      c535v20 = ResetLineCount
      c535v21 = 0
      c535v20(c535v21)
      c535v20 = 1
      c535v22 = c535v4[c535v18]
      c535v21 = #c535v22
      c535v22 = c535v4[c535v18]
      c535v21 = c535v22[c535v20]
      c535v23 = c535v21.mModularParts
      c535v22 = #c535v23
      c535v23 = 0
      c535v22 = c535v21.mAltWeaponModeId
      c535v22 = c535v22:IsZero()
      c535v22 = c535v21.mItemType
      c535v23 = WeakResource
      c535v24 = "/Lotus/Weapons/Tenno/Bows/ValentinesConclaveVariantBow"
      c535v23 = c535v23(c535v24)
      c535v22 = table.remove
      c535v23 = c535v4[c535v18]
      c535v22(c535v23, c535v20)
      c535v22 = vT[164]
      c535v23 = c535v21.mItemType
      c535v22 = c535v22(c535v23)
      c535v23 = #c535v22
      if c535v23 == 0 then
        c535v25 = c535v21.mItemType
        c535v23 = table.insert
        c535v23(c535v22, c535v25)
      end
      c535v23 = 1
      while true do
        c535v25 = c535v14[c535v18]
        c535v24 = #c535v25
        if c535v24 < c535v23 then break end
        c535v24 = ResetLineCount
        c535v25 = 0
        c535v24(c535v25)
        c535v24 = vT[17]
        c535v24 = c535v24.IsValueInTable
        c535v27 = c535v14[c535v18]
        c535v26 = c535v27[c535v23]
        c535v24 = c535v24(c535v22, c535v26)
        if c535v24 then
          c535v24 = table.remove
          c535v25 = c535v14[c535v18]
          c535v24(c535v25, c535v23)
          c535v24 = table.remove
          c535v25 = c535v3[c535v18]
          c535v24(c535v25, c535v23)
        else
          c535v23 = c535v23 + 1
        end
      end
      c535v20 = c535v20 + 1
      c535v6 = gGameData
      c535v6 = c535v6:GetInventory()
      c535v6 = nil
      c535v7 = gGameRules
      c535v7 = c535v7:GetVariantManifest()
      c535v8 = IsNull
      c535v8 = c535v8(c535v6)
      c535v8 = IsNull
      c535v8 = c535v8(c535v7)
      c535v8 = gGameData
      c535v8 = c535v8:GetInventory()
      c535v8 = c535v8.mXPInfo
      c535v11 = 1
      c535v9 = #c535v8
      c535v10 = 1
      for c535v11 = c535v11, c535v9, c535v10 do
        c535v13 = c535v8[c535v11]
        c535v13 = c535v13.mItemType
        c535v12 = IsNull
        c535v12 = c535v12(c535v13)
        if not c535v12 then
          c535v13 = _T.xpInfoDictionary
          c535v12 = IsNull
          c535v12 = c535v12(c535v13)
          if c535v12 then
            c535v12 = _T
            c535v13 = {}
            c535v12.xpInfoDictionary = c535v13
          end
          c535v12 = _T.xpInfoDictionary
          c535v13 = c535v8[c535v11]
          c535v13 = c535v13.mItemType
          c535v13 = c535v13:GetFullName()
          c535v14 = c535v8[c535v11]
          c535v14 = c535v14.mXP
          c535v12[c535v13] = c535v14
        end
      end
      c535v2 = _G
      c535v2 = c535v2.RollableItemsTypeNameCache
      c535v1 = IsNull
      c535v1 = c535v1(c535v2)
      if c535v1 then
        do return end
      end
      c535v1 = {}
      c535v2 = {}
      c535v3 = {}
      c535v4 = {}
      c535v6 = 3
      c535v7 = 1
      c535v8 = 0
      c535v9 = 5
      c535v5 = {c535v6, c535v7, c535v8, c535v9}
      c535v8 = gGameData
      c535v7 = IsNull
      c535v7 = c535v7(c535v8)
      c535v8 = 3
      c535v9 = c535v6:GetSuits()
      c535v4[c535v8] = c535v9
      c535v8 = 1
      c535v9 = c535v6:GetLongGuns()
      c535v4[c535v8] = c535v9
      c535v8 = 0
      c535v9 = c535v6:GetPistols()
      c535v4[c535v8] = c535v9
      c535v8 = 5
      c535v9 = c535v6:GetMelee()
      c535v4[c535v8] = c535v9
      c535v8 = 3
      c535v9 = {}
      c535v3[c535v8] = c535v9
      c535v8 = ipairs
      c535v9 = _G
      c535v9 = c535v9.RollableItemsTypeNameCache
      c535v9 = c535v9.suits
      c535v8, c535v9, c535v10 = c535v8(c535v9)
      for c535v11, c535v12 in c535v8, c535v9, c535v10 do
        c535v15 = 3
        c535v14 = c535v3[c535v15]
        c535v13 = table.insert
        c535v13(c535v14, c535v12)
      end
      c535v8 = 1
      c535v9 = {}
      c535v3[c535v8] = c535v9
      c535v8 = 0
      c535v9 = {}
      c535v3[c535v8] = c535v9
      c535v8 = 5
      c535v9 = {}
      c535v3[c535v8] = c535v9
      c535v8 = pairs
      c535v8, c535v9, c535v10 = c535v8(c535v4)
      for c535v11, c535v12 in c535v8, c535v9, c535v10 do
        c535v13 = vT[170]
        c535v14 = c535v4[c535v11]
        c535v13(c535v14)
        c535v13 = vT[169]
        c535v14 = c535v4[c535v11]
        c535v13 = c535v13(c535v14)
        c535v4[c535v11] = c535v13
      end
      c535v9 = gGameData
      c535v8 = IsNull
      c535v8 = c535v8(c535v9:GetInventory())
      if c535v6 then
        do return end
      end
      c535v8 = pairs
      c535v9 = _G
      c535v9 = c535v9.RollableItemsTypeNameCache
      c535v9 = c535v9.weapons
      c535v8, c535v9, c535v10 = c535v8(c535v9)
      for c535v11, c535v12 in c535v8, c535v9, c535v10 do
        c535v13 = c535v12.category
        if c535v13 ~= nil then
          c535v13 = c535v12.category
          c535v14 = 3
          if c535v13 ~= c535v14 then
            c535v15 = c535v12.category
            c535v14 = c535v3[c535v15]
            c535v15 = c535v12.itemName
            c535v13 = table.insert
            c535v13(c535v14, c535v15)
          end
        end
      end
      c535v9 = WeakResource
      c535v10 = "/Lotus/StoreItems/Powersuits/Excalibur/Excalibur"
      c535v9 = c535v9(c535v10)
      c535v10 = WeakResource
      c535v11 = "/Lotus/StoreItems/Powersuits/Mag/Mag"
      c535v10 = c535v10(c535v11)
      c535v11 = WeakResource
      c535v12 = "/Lotus/StoreItems/Powersuits/Volt/Volt"
      c535v11 = c535v11(c535v12)
      c535v12 = WeakResource
      c535v13 = "/Lotus/StoreItems/Powersuits/Frost/Frost"
      c535v12 = c535v12(c535v13)
      c535v13 = WeakResource
      c535v14 = "/Lotus/StoreItems/Powersuits/Harlequin/Harlequin"
      c535v13 = c535v13(c535v14)
      c535v14 = WeakResource
      c535v15 = "/Lotus/StoreItems/Powersuits/Nezha/Nezha"
      c535v14 = c535v14(c535v15)
      c535v15 = WeakResource
      c535v16 = "/Lotus/StoreItems/Powersuits/Paladin/Paladin"
      c535v15 = c535v15(c535v16)
      c535v16 = WeakResource
      c535v17 = "/Lotus/StoreItems/Powersuits/Odalisk/Odalisk"
      c535v16 = c535v16(c535v17)
      c535v17 = WeakResource
      c535v18 = "/Lotus/StoreItems/Powersuits/Rhino/Rhino"
      c535v17 = c535v17(c535v18)
      c535v18 = WeakResource
      c535v19 = "/Lotus/StoreItems/Powersuits/Saryn/Saryn"
      c535v18 = c535v18(c535v19)
      c535v19 = WeakResource
      c535v20 = "/Lotus/StoreItems/Powersuits/Hoplite/Hoplite"
      c535v19 = c535v19(c535v20)
      c535v20 = WeakResource
      c535v21 = "/Lotus/StoreItems/Powersuits/MonkeyKing/MonkeyKing"
      c535v8 = {c535v9, c535v10, c535v11, c535v12, c535v13, c535v14, c535v15, c535v16, c535v17, c535v18, c535v19, c535v20(c535v21)}
      c535v9 = gGameData
      c535v9 = c535v9:Name__1d1bb34a()
      c535v10 = 5
      for c535v11, c535v12 in c535v8, c535v9, c535v10 do
        c535v10 = {}
        c535v11 = ipairs
        c535v11, c535v12, c535v13 = c535v11(c535v8)
        for c535v14, c535v15 in c535v11, c535v12, c535v13 do
          c535v16 = c535v15:GetFullName()
          c535v17 = true
          c535v10[c535v16] = c535v17
        end
        c535v11 = 1
        while true do
          c535v14 = 3
          c535v13 = c535v3[c535v14]
          c535v12 = #c535v13
          if c535v12 < c535v11 then break end
          c535v12 = ResetLineCount
          c535v13 = 0
          c535v12(c535v13)
          c535v15 = 3
          c535v14 = c535v3[c535v15]
          c535v13 = c535v14[c535v11]
          c535v12 = c535v10[c535v13]
          if not c535v12 then
            c535v12 = table.remove
            c535v14 = 3
            c535v13 = c535v3[c535v14]
            c535v12(c535v13, c535v11)
          else
            c535v11 = c535v11 + 1
          end
        end
      end
      c535v11 = WeakResource
      c535v12 = "/Lotus/StoreItems/Powersuits/SiriusOrion/SiriusSuit"
      c535v10 = {c535v11(c535v12)}
      c535v12 = WeakResource
      c535v13 = "/Lotus/Powersuits/SiriusOrion/SiriusSuit"
      c535v11 = {c535v12(c535v13)}
      c535v12 = {}
      c535v13 = ipairs
      c535v13, c535v14, c535v15 = c535v13(c535v10)
      for c535v16, c535v17 in c535v13, c535v14, c535v15 do
        c535v18 = c535v17:GetFullName()
        c535v19 = false
        c535v12[c535v18] = c535v19
      end
      c535v13 = 1
      while true do
        c535v16 = 3
        c535v15 = c535v3[c535v16]
        c535v14 = #c535v15
        if c535v14 < c535v13 then break end
        c535v14 = ResetLineCount
        c535v15 = 0
        c535v14(c535v15)
        c535v17 = 3
        c535v16 = c535v3[c535v17]
        c535v15 = c535v16[c535v13]
        c535v14 = c535v12[c535v15]
        if c535v14 == false then
          c535v14 = print
          c535v16 = "Excluded due to blacklist : "
          c535v19 = 3
          c535v18 = c535v3[c535v19]
          c535v17 = c535v18[c535v13]
          c535v15 = c535v16 .. c535v17
          c535v14(c535v15)
          c535v14 = table.remove
          c535v16 = 3
          c535v15 = c535v3[c535v16]
          c535v14(c535v15, c535v13)
        else
          c535v13 = c535v13 + 1
        end
      end
      c535v12 = {}
      c535v14 = ipairs
      c535v14, c535v15, c535v16 = c535v14(c535v11)
      for c535v17, c535v18 in c535v14, c535v15, c535v16 do
        c535v19 = c535v18:GetFullName()
        c535v20 = false
        c535v12[c535v19] = c535v20
      end
      c535v13 = 1
      while true do
        c535v16 = 3
        c535v15 = c535v4[c535v16]
        c535v14 = #c535v15
        if c535v14 < c535v13 then break end
        c535v14 = ResetLineCount
        c535v15 = 0
        c535v14(c535v15)
        c535v16 = 3
        c535v15 = c535v4[c535v16]
        c535v14 = c535v15[c535v13]
        c535v15 = c535v14.mItemType
        c535v16 = c535v14.mItemType
        c535v16 = c535v16:GetFullName()
        c535v15 = c535v12[c535v16]
        c535v15 = print
        c535v17 = "Excluded due to blacklist : "
        c535v18 = c535v14.mItemType
        c535v18 = c535v18:GetFullName()
        c535v16 = c535v17 .. c535v18
        c535v15(c535v16)
        c535v15 = table.remove
        c535v17 = 3
        c535v16 = c535v4[c535v17]
        c535v15(c535v16, c535v13)
        c535v13 = c535v13 + 1
      end
      c535v14 = {}
      c535v15 = pairs
      c535v15, c535v16, c535v17 = c535v15(c535v3)
      for c535v18, c535v19 in c535v15, c535v16, c535v17 do
        c535v20 = {}
        c535v14[c535v18] = c535v20
        c535v22 = 1
        c535v23 = c535v3[c535v18]
        c535v20 = #c535v23
        c535v21 = 1
        for c535v22 = c535v22, c535v20, c535v21 do
          c535v23 = ResetLineCount
          c535v24 = 0
          c535v23(c535v24)
          c535v24 = c535v3[c535v18]
          c535v23 = c535v24[c535v22]
          c535v24 = string.gsub
          c535v26 = "/StoreItems"
          c535v27 = ""
          c535v24 = c535v24(c535v23, c535v26, c535v27)
          c535v26 = c535v14[c535v18]
          c535v27 = WeakResource
          c535v25 = table.insert
          c535v25(c535v26, c535v27(c535v24))
        end
      end
      c535v15 = pairs
      c535v15, c535v16, c535v17 = c535v15(c535v4)
      c535v15 = {}
      c535v16 = pairs
      c535v16, c535v17, c535v18 = c535v16(c535v3)
      for c535v19, c535v20 in c535v16, c535v17, c535v18 do
        c535v22 = c535v3[c535v19]
        c535v21 = #c535v22
        c535v15[c535v19] = c535v21
      end
      c535v16 = function(c534v0, c534v1)
        local c534v2, c534v3, c534v4, c534v5, c534v6, c534v7, c534v8
        c534v2 = 0
        c534v4 = c535v15
        c534v3 = c534v4[c534v1]
        c534v4 = 0
        if c534v4 < c534v3 then
          c534v3 = Clamp
          c534v6 = c535v15
          c534v5 = c534v6[c534v1]
          c534v4 = c534v5 / 10
          c534v5 = 0.1
          c534v6 = 1
          c534v2 = c534v3(c534v4, c534v5, c534v6)
        end
        if c534v2 == 1 then
          c534v5 = c535v4
          c534v4 = c534v5[c534v1]
          c534v3 = #c534v4
          c534v4 = 0
          if c534v4 < c534v3 then
            c534v3 = 1 - c534v0
            c534v4 = Clamp
            c534v8 = c535v4
            c534v7 = c534v8[c534v1]
            c534v6 = #c534v7
            c534v5 = c534v6 / 10
            c534v6 = 0.1
            c534v7 = 1
            c534v4 = c534v4(c534v5, c534v6, c534v7)
            c534v3 = c534v3 * c534v4
            c534v0 = 1 - c534v3
          end
        end
        c534v3 = c534v0 * c534v2
        do return c534v3 end
      end
      c535v17 = SRandomInt
      c535v18 = 1
      c535v19 = 3
      c535v17 = c535v17(c535v18, c535v19)
      c535v18 = vT[168]
      c535v19 = 3
      c535v21 = 1
      c535v22 = 3
      c535v20 = c535v16(c535v21, c535v22)
      c535v18 = c535v18(c535v19, c535v20, c535v4, c535v3)
      c535v1[c535v17] = c535v18
      c535v20 = 1
      c535v18 = 3
      c535v19 = 1
      for c535v20 = c535v20, c535v18, c535v19 do
        if c535v20 ~= c535v17 then
          c535v21 = vT[168]
          c535v22 = 3
          c535v23 = 0
          c535v21 = c535v21(c535v22, c535v23, c535v4, c535v3)
          c535v1[c535v20] = c535v21
        end
      end
      c535v18 = WeakResource
      c535v19 = "/Lotus/Powersuits/Stalker/Stalker"
      c535v18 = c535v18(c535v19)
      c535v19 = SRandomInt
      c535v20 = 4
      c535v21 = 5
      c535v19 = c535v19(c535v20, c535v21)
      c535v22 = 4
      c535v20 = 5
      c535v21 = 1
      for c535v22 = c535v22, c535v20, c535v21 do
        c535v23 = vT[17]
        c535v23 = c535v23.Ternary
        if c535v22 ~= c535v19 then
          c535v24 = false
        else
          c535v24 = true
        end
        c535v26 = 0.5
        c535v27 = 3
        c535v25 = c535v16(c535v26, c535v27)
        c535v26 = 0
        c535v23 = c535v23(c535v24, c535v25, c535v26)
        c535v24 = vT[168]
        c535v25 = 3
        c535v24 = c535v24(c535v25, c535v23, c535v4, c535v3)
        c535v1[c535v22] = c535v24
        if c535v22 ~= c535v19 then
          c535v24 = SRandom
          c535v25 = 0
          c535v26 = 1
          c535v24 = c535v24(c535v25, c535v26)
          c535v25 = gGameData
          c535v27 = 8
          c535v25 = c535v25:GetPlayerSkill(c535v27)
          c535v26 = 10
          if c535v26 <= c535v25 then
            c535v27 = c535v6.mDuviriInfo
            c535v27 = c535v27.mStalkerChance
            c535v26 = c535v27 / 255
            if not ((c535v24 == 0 or c535v26 < c535v24)) then
              c535v1[c535v22] = c535v18
            end
          end
        end
      end
      c535v21 = SRandomInt
      c535v22 = 2
      c535v23 = #c535v5
      c535v21 = c535v21(c535v22, c535v23)
      c535v20 = c535v5[c535v21]
      c535v21 = SRandomInt
      c535v22 = 1
      c535v23 = 3
      c535v21 = c535v21(c535v22, c535v23)
      c535v23 = c535v2
      c535v24 = vT[168]
      c535v25 = 1
      c535v26 = c535v16
      if c535v21 == 1 then
        c535v27 = 1
      else
        c535v27 = 0
      end
      c535v28 = 1
      c535v26 = c535v26(c535v27, c535v28)
      c535v22 = table.insert
      c535v22(c535v23, c535v24(c535v25, c535v26, c535v4, c535v3))
      c535v23 = c535v2
      c535v24 = vT[168]
      c535v25 = 0
      c535v26 = c535v16
      if c535v21 == 2 then
        c535v27 = 1
      else
        c535v27 = 0
      end
      c535v28 = 0
      c535v26 = c535v26(c535v27, c535v28)
      c535v22 = table.insert
      c535v22(c535v23, c535v24(c535v25, c535v26, c535v4, c535v3))
      c535v23 = c535v2
      c535v24 = vT[168]
      c535v25 = 5
      c535v26 = c535v16
      if c535v21 == 3 then
        c535v27 = 1
      else
        c535v27 = 0
      end
      c535v28 = 5
      c535v26 = c535v26(c535v27, c535v28)
      c535v22 = table.insert
      c535v22(c535v23, c535v24(c535v25, c535v26, c535v4, c535v3))
      c535v22 = {}
      c535v23 = pairs
      c535v23, c535v24, c535v25 = c535v23(c535v5)
      for c535v26, c535v27 in c535v23, c535v24, c535v25 do
        c535v28 = 3
        if not ((c535v27 == c535v28 or c535v27 == c535v20)) then
          c535v28 = table.insert
          c535v28(c535v22, c535v27)
        end
      end
      c535v25 = vT[168]
      c535v28 = 0.5
      c535v27 = c535v16(c535v28, c535v20)
      c535v23 = table.insert
      c535v23(c535v2, c535v25(c535v20, c535v27, c535v4, c535v3))
      c535v23 = pairs
      c535v23, c535v24, c535v25 = c535v23(c535v22)
      for c535v26, c535v27 in c535v23, c535v24, c535v25 do
        c535v30 = vT[168]
        c535v33 = 0.5
        c535v32 = c535v16(c535v33, c535v27)
        c535v28 = table.insert
        c535v28(c535v2, c535v30(c535v27, c535v32, c535v4, c535v3))
      end
      c535v25 = vT[168]
      c535v26 = 5
      c535v28 = 0.5
      c535v29 = 5
      c535v27 = c535v16(c535v28, c535v29)
      c535v23 = table.insert
      c535v23(c535v2, c535v25(c535v26, c535v27, c535v4, c535v3))
      c535v23 = pairs
      c535v23, c535v24, c535v25 = c535v23(c535v22)
      if c535v27 == c535v28 then
        c535v28 = table.remove
        c535v28(c535v22, c535v26)
      end
      c535v24 = SRandomInt
      c535v25 = 1
      c535v26 = #c535v22
      c535v24 = c535v24(c535v25, c535v26)
      c535v23 = c535v22[c535v24]
      c535v26 = vT[168]
      c535v29 = 0.5
      c535v28 = c535v16(c535v29, c535v23)
      c535v24 = table.insert
      c535v24(c535v2, c535v26(c535v23, c535v28, c535v4, c535v3))
      c535v24 = gGameData
      c535v24 = c535v24:Name__3e4ab61a()
      c535v25 = print
      c535v27 = "Found "
      c535v31 = #c535v24
      c535v30 = tostring
      c535v28 = c535v30(c535v31)
      c535v29 = " overrides."
      c535v26 = c535v27 .. c535v28 .. c535v29
      c535v25(c535v26)
      c535v25 = pairs
      c535v25, c535v26, c535v27 = c535v25(c535v24)
    end
  end
  vT[172] = function(c538v0)
    local c538v1, c538v2, c538v3, c538v4, c538v5, c538v6, c538v7, c538v8, c538v9, c538v10, c538v11, c538v12, c538v13, c538v14, c538v16, c538v17, c538v18, c538v19, c538v20, c538v21, c538v24, c538v25, c538v26, c538v27
    c538v18 = vT[167]
    c538v17 = c538v18(c538v9, c538v16)
    c538v11 = 0
    c538v18 = vT[167]
    c538v17 = c538v18(c538v10, c538v16)
    c538v11 = 5
    c538v18 = Lotus_Game.WeaponInfo
    c538v17 = c538v18()
    c538v17.mItemType = c538v16
    c538v18 = 10000000
    c538v17.mXP = c538v18
    c538v11 = -1
    c538v18 = c538v16:GetFullName()
    c538v19 = pairs
    c538v20 = _G
    c538v20 = c538v20.RollableItemsTypeNameCache
    c538v20 = c538v20.weapons
    c538v19, c538v20, c538v21 = c538v19(c538v20)
    for c538v22, c538v23 in c538v19, c538v20, c538v21 do
      c538v24 = c538v23.category
      c538v24 = string.gsub
      c538v25 = c538v23.itemName
      c538v26 = "/StoreItems"
      c538v27 = ""
      c538v24 = c538v24(c538v25, c538v26, c538v27)
      c538v11 = c538v23.category
      c538v19 = ResetLineCount
      c538v20 = 0
      c538v19(c538v20)
      if c538v11 ~= -1 then
        c538v18 = { wepInfo = nil, category = nil, order = nil }
        c538v18.wepInfo = c538v17
        c538v18.category = c538v11
        c538v19 = c538v7(c538v11)
        c538v18.order = c538v19
        c538v20 = _G
        c538v20 = c538v20.DuviriCaveSelections
        c538v20 = c538v20.weapons
        c538v19 = table.insert
        c538v19(c538v20, c538v18)
      else
        c538v18 = print
        c538v20 = "ERROR! COuldnt find category for "
        c538v21 = c538v16:GetFullName()
        c538v19 = c538v20 .. c538v21
        c538v18(c538v19)
      end
      for c538v15, c538v16 in c538v12, c538v13, c538v14 do
        c538v12 = print
        c538v13 = "Generated weapons:"
        c538v12(c538v13)
        c538v12 = ipairs
        c538v13 = _G
        c538v13 = c538v13.DuviriCaveSelections
        c538v13 = c538v13.weapons
        c538v12, c538v13, c538v14 = c538v12(c538v13)
        for c538v15, c538v16 in c538v12, c538v13, c538v14 do
          c538v17 = print
          c538v20 = "> "
          c538v21 = c538v16.category
          c538v22 = "> "
          c538v23 = c538v16.wepInfo
          c538v23 = c538v23.mItemType
          c538v23 = c538v23:GetFullName()
          c538v18 = c538v15 .. c538v20 .. c538v21 .. c538v22 .. c538v23
          c538v17(c538v18)
        end
        c538v12 = 4
        c538v13 = gGameData
        c538v15 = 8
        c538v13 = c538v13:GetPlayerSkill(c538v15)
        c538v14 = 7
        if c538v14 <= c538v13 then
          c538v12 = 8
        else
          c538v14 = 2
          if c538v14 <= c538v13 then
            c538v12 = 6
          end
        end
        c538v14 = {}
        c538v17 = 1
        c538v15 = c538v12
        c538v16 = 1
        for c538v17 = c538v17, c538v15, c538v16 do
          c538v21 = _G
          c538v21 = c538v21.DuviriCaveSelections
          c538v21 = c538v21.weapons
          c538v20 = c538v21[c538v17]
          c538v18 = table.insert
          c538v18(c538v14, c538v20)
        end
        c538v15 = table.sort
        c538v17 = function(c536v0, c536v1)
          local c536v2, c536v3, c536v4
          c536v3 = c536v0.order
          c536v4 = c536v1.order
          if c536v4 <= c536v3 then
            c536v2 = false
          else
            c536v2 = true
          end
          do return c536v2 end
        end
        c538v15(c538v14, c538v17)
        c538v17 = c538v12 + 1
        c538v18 = _G
        c538v18 = c538v18.DuviriCaveSelections
        c538v18 = c538v18.weapons
        c538v15 = #c538v18
        c538v16 = 1
        for c538v17 = c538v17, c538v15, c538v16 do
          c538v21 = _G
          c538v21 = c538v21.DuviriCaveSelections
          c538v21 = c538v21.weapons
          c538v20 = c538v21[c538v17]
          c538v18 = table.insert
          c538v18(c538v14, c538v20)
        end
        c538v15 = _G
        c538v15 = c538v15.DuviriCaveSelections
        c538v15.weapons = c538v14
        c538v1:UnClock()
        c538v15 = print
        c538v17 = "Generating Cave Selections took: "
        c538v22 = c538v1:Seconds()
        c538v21 = c538v22 * 1000
        c538v20 = tostring
        c538v18 = c538v20(c538v21)
        c538v19 = "ms"
        c538v16 = c538v17 .. c538v18 .. c538v19
        c538v15(c538v16)
        c538v15 = SetSeed
        c538v15(c538v3)
        do return end
      end
      c538v17 = vT[167]
      c538v17 = c538v17(c538v8, c538v16)
      c538v11 = 1
      local p64 = 0
      if p64 == 0 then
        c538v1 = ClockValue
        c538v1 = c538v1()
        c538v1:Clock()
        c538v2 = Lotus_Game.Name__2ae4b4de
        c538v2 = c538v2()
        if not c538v0 then
          p64 = 2
        else
          p64 = 1
        end
      end
      if p64 == 1 then
        c538v3 = Name__6dd598b2
        c538v4 = math.random
        c538v5 = 500000
        c538v2 = c538v3(c538v4(c538v5))
        p64 = 2
      end
      if p64 == 2 then
        c538v3 = GetSeed
        c538v3 = c538v3()
        c538v5 = gGameData
        c538v4 = IsNull
        c538v4 = c538v4(c538v5)
        if not c538v4 then
          p64 = 4
        else
          p64 = 3
        end
      end
      if p64 == 3 then
        do return end
      end
      if p64 == 4 then
        c538v4 = gGameData
        c538v4 = c538v4:GetDuviriCaveOffers()
        c538v5 = SetSeed
        c538v5(c538v2)
        c538v5 = c538v4.mSeed
        if c538v5 ~= c538v2 then
          p64 = 7
        else
          p64 = 5
        end
      end
      if p64 == 5 then
        c538v6 = c538v4.mWarframes
        c538v5 = #c538v6
        c538v6 = 5
        if c538v5 < c538v6 then
          p64 = 7
        else
          p64 = 6
        end
      end
      if p64 == 6 then
        c538v6 = c538v4.mWeapons
        c538v5 = #c538v6
        c538v6 = 8
        if c538v6 <= c538v5 then
          p64 = 8
        else
          p64 = 7
        end
      end
      if p64 == 7 then
        c538v5 = print
        c538v6 = "RollDuviriOffers - Generating new Duviri offers"
        c538v5(c538v6)
        c538v5 = vT[171]
        c538v5(c538v2)
        p64 = 9
      end
      if p64 == 8 then
        c538v5 = print
        c538v6 = "RollDuviriOffers - Using cached duviri offers"
        c538v5(c538v6)
        p64 = 9
      end
      if p64 == 9 then
        c538v5 = print
        c538v7 = "RollDuviriOffers - Duviri Seed: "
        c538v8 = tostring
        c538v8 = c538v8(c538v2)
        c538v6 = c538v7 .. c538v8
        c538v5(c538v6)
        c538v5 = _G
        c538v6 = {}
        c538v5.DuviriCaveSelections = c538v6
        c538v5 = _G
        c538v5 = c538v5.DuviriCaveSelections
        c538v6 = {}
        c538v5.suits = c538v6
        c538v5 = _G
        c538v5 = c538v5.DuviriCaveSelections
        c538v6 = {}
        c538v5.weapons = c538v6
        c538v5 = gGameData
        c538v5 = c538v5:GetInventory()
        c538v6 = c538v5:GetSuits()
        c538v7 = ipairs
        c538v8 = c538v4.mWarframes
        c538v7, c538v8, c538v9 = c538v7(c538v8)
        for c538v10, c538v11 in c538v7, c538v8, c538v9 do
          c538v12 = vT[167]
          c538v12 = c538v12(c538v6, c538v11)
          if c538v12 == nil then
            c538v13 = Lotus_Game.WeaponInfo
            c538v12 = c538v13()
            c538v12.mItemType = c538v11
            c538v13 = 10000000
            c538v12.mXP = c538v13
          end
          c538v14 = _G
          c538v14 = c538v14.DuviriCaveSelections
          c538v14 = c538v14.suits
          c538v13 = table.insert
          c538v13(c538v14, c538v12)
        end
        c538v7 = function(c537v0)
          local c537v1, c537v2
          c537v1 = 0
          c537v2 = 1
          if c537v0 == c537v2 then
            c537v1 = 1
            do return c537v1 end
          end
          c537v2 = 5
          if c537v0 == c537v2 then
            c537v1 = 2
            do return c537v1 end
          end
          c537v2 = 0
          if c537v0 == c537v2 then
            c537v1 = 3
          end
          do return c537v1 end
        end
        c538v8 = c538v5:GetLongGuns()
        c538v9 = c538v5:GetPistols()
        c538v10 = c538v5:GetMelee()
        c538v11 = nil
        c538v12 = ipairs
        c538v13 = c538v4.mWeapons
        c538v12, c538v13, c538v14 = c538v12(c538v13)
      end
    end
  end
  RollDuviriOffers = vT[172]
  vT[172] = function(c539v0, c539v1, c539v2, c539v3, c539v4)
    local c539v5, c539v6, c539v7, c539v9
    c539v5 = IsNull
    c539v5 = c539v5(c539v0)
    if not c539v5 then
      c539v5 = IsNull
      c539v5 = c539v5(c539v1)
      if not c539v5 then
        c539v5 = c539v1:GetCurEnergy()
        c539v1:IncreaseEnergy(c539v2)
        c539v7 = c539v1:GetCurEnergy()
        c539v6 = c539v7 - c539v5
        c539v7 = 0
        if c539v7 < c539v6 then
          c539v7 = IsNull
          c539v7 = c539v7(c539v3)
          if not c539v7 then
            if c539v4 == nil then
              c539v4 = 0
            end
            c539v9 = c539v3:GetPlayer()
            c539v0:NotifyEnergyGain(c539v9, c539v6, c539v4)
          end
        end
      end
    end
    do return end
  end
  GiveEnergy = vT[172]
  vT[172] = function(c540v0, c540v1, c540v2, c540v3, c540v4)
    local c540v5, c540v6, c540v7, c540v9, c540v10
    c540v5 = IsNull
    c540v5 = c540v5(c540v0)
    if not c540v5 then
      c540v5 = 0
      if c540v5 < c540v1 then
        c540v5 = c540v0:DamageControl()
        c540v5 = c540v5:GetShield()
        c540v6 = c540v0:DamageControl()
        c540v6:HealShield(c540v1, c540v2)
        c540v7 = c540v0:DamageControl()
        c540v7 = c540v7:GetShield()
        c540v6 = c540v7 - c540v5
        c540v7 = 0
        if c540v7 < c540v6 then
          c540v7 = IsNull
          c540v7 = c540v7(c540v3)
          if not c540v7 then
            if c540v4 == nil then
              c540v4 = 0
            end
            c540v9 = c540v3:GetPlayer()
            c540v10 = 0
            c540v0:NotifyHeal(c540v9, c540v10, c540v6, c540v4)
          end
        end
      end
    end
    do return end
  end
  HealShield = vT[172]
  vT[172] = function(c541v0)
    local c541v1, c541v2, c541v4
    c541v1 = c541v0.mInstance
    c541v2 = IsNull
    c541v2 = c541v2(c541v1)
    if c541v2 then
      do return end
    end
    c541v4 = c541v0:GetLocalPosition()
    c541v1:Name__967d219d(c541v4, c541v0:GetLocalRotation())
    do return end
  end
  RefreshAutoChild = vT[172]
  vT[172] = function()
    local c542v1, c542v2
    c542v1 = gGameRules
    local c542v0 = IsNull
    c542v0 = c542v0(c542v1)
    if not c542v0 then
      c542v0 = gGameRules
      c542v2 = gLotusGameRulesType
      c542v0 = c542v0:IsA(c542v2)
      if c542v0 then
        c542v0 = gGameRules
        c542v0 = c542v0:Name__22bf209c()
        if c542v0 then
          c542v0 = _T
          c542v1 = gGameRules
          c542v1 = c542v1:GetNetPersistentString()
          c542v0.netPersistentString = c542v1
          c542v0 = _T
          c542v1 = cjson.decode
          c542v2 = _T.netPersistentString
          c542v1 = c542v1(c542v2)
          c542v0.netPersistentArray = c542v1
          c542v0 = gGameRules
          c542v0:TrackSetupFX()
        end
      else
        c542v0 = _T
        c542v1 = ""
        c542v0.netPersistentString = c542v1
        c542v0 = _T
        c542v1 = {}
        c542v0.netPersistentArray = c542v1
      end
    end
    c542v0 = _T.netPersistentString
    if c542v0 == nil then
      c542v0 = _T
      c542v1 = ""
      c542v0.netPersistentString = c542v1
    end
    c542v0 = _T.netPersistentString
    if c542v0 == "" then
      c542v0 = _T
      c542v1 = {}
      c542v0.netPersistentArray = c542v1
    end
    do return end
  end
  CheckNetPersistentString = vT[172]
  vT[172] = function()
    local c543v0
    c543v0 = CheckNetPersistentString
    c543v0()
    c543v0 = _T.netPersistentArray
    do return c543v0 end
  end
  GetNetPersistentArray = vT[172]
  vT[172] = function(c544v0, c544v1)
    local c544v2, c544v4, c544v5
    c544v2 = gGameRules
    c544v4 = gLotusGameRulesType
    c544v2 = c544v2:IsA(c544v4)
    if not c544v2 then
      do return end
    end
    c544v2 = CheckNetPersistentString
    c544v2()
    c544v2 = _T.netPersistentArray
    c544v2[c544v0] = c544v1
    c544v2 = gGameRules
    c544v4 = cjson.encode
    c544v5 = _T.netPersistentArray
    c544v2:SetNetPersistentString(c544v4(c544v5))
    do return end
  end
  SetNetArrayValue = vT[172]
  vT[172] = function(c545v0)
    local c545v1, c545v2, c545v3, c545v4
    c545v1 = gGameRules
    c545v3 = gLotusGameRulesType
    c545v1 = c545v1:IsA(c545v3)
    if not c545v1 then
      do return end
    end
    c545v1 = CheckNetPersistentString
    c545v1()
    c545v2 = _T.netPersistentArray
    c545v1 = #c545v2
    c545v2 = 0
    if c545v2 < c545v1 then
      c545v3 = _T.netPersistentArray
      c545v2 = c545v3[c545v0]
      c545v1 = IsNull
      c545v1 = c545v1(c545v2)
      if not c545v1 then
        c545v1 = _T.netPersistentArray
        c545v2 = nil
        c545v1[c545v0] = c545v2
        c545v1 = gGameRules
        c545v3 = cjson.encode
        c545v4 = _T.netPersistentArray
        c545v1:SetNetPersistentString(c545v3(c545v4))
      end
    end
    do return end
  end
  ClearNetArrayValue = vT[172]
  vT[172] = function(c546v0, c546v1)
    local c546v2, c546v3, c546v4, c546v5
    c546v3 = IsNull
    c546v3 = c546v3(c546v1)
    if not c546v3 then
      c546v3 = WeakResource
      c546v4 = "/Lotus/Types/Items/MiscItems/WeaponMeleeArcaneUnlocker"
      c546v3 = c546v3(c546v4)
      if c546v1 == c546v3 then
        c546v2 = "/Lotus/Language/Categories/MELEE"
      else
        c546v3 = WeakResource
        c546v4 = "/Lotus/Types/Items/MiscItems/WeaponPrimaryArcaneUnlocker"
        c546v3 = c546v3(c546v4)
        if c546v1 == c546v3 then
          c546v2 = "/Lotus/Language/Categories/RIFLE"
        else
          c546v3 = WeakResource
          c546v4 = "/Lotus/Types/Items/MiscItems/WeaponSecondaryArcaneUnlocker"
          c546v3 = c546v3(c546v4)
          if c546v1 == c546v3 then
            c546v2 = "/Lotus/Language/Categories/HAND_GUN"
          else
            c546v3 = WeakResource
            c546v4 = "/Lotus/Types/Items/MiscItems/WeaponArchGunArcaneUnlocker"
            c546v3 = c546v3(c546v4)
            if c546v1 == c546v3 then
              c546v2 = "/Lotus/Language/Items/ArchwingGun"
            end
          end
        end
      end
    end
    if not ((c546v2 ~= nil or c546v0 == nil)) then
      c546v3 = 2
      if c546v0 == c546v3 then
        c546v2 = "/Lotus/Language/Categories/RIFLE"
      else
        c546v3 = 1
        if c546v0 == c546v3 then
          c546v2 = "/Lotus/Language/Categories/HAND_GUN"
        else
          c546v3 = 3
          if c546v0 == c546v3 then
            c546v2 = "/Lotus/Language/Categories/MELEE"
          end
        end
      end
    end
    if c546v2 ~= nil then
      c546v3 = Localize
      c546v5 = nil
      c546v2 = c546v3(c546v2, c546v5)
      c546v3 = Localize
      c546v4 = "/Lotus/Language/Menu/ArcaneSlot_ItemName"
      c546v5 = { ITEM = nil }
      c546v5.ITEM = c546v2
      c546v2 = c546v3(c546v4, c546v5)
      c546v3 = "/Lotus/Language/Menu/ArcaneSlot_RequiresAperture"
      c546v4 = TitleCase
      do return c546v3, c546v4(c546v2) end
    end
    c546v3 = nil
    c546v4 = nil
    do return c546v3, c546v4 end
  end
  GetArcaneSlotRequirementMessage = vT[172]
  vT[172] = function(c547v0)
    local c547v1, c547v2, c547v3
    if c547v0 == nil then
      c547v1 = false
      do return c547v1 end
    end
    c547v2 = c547v0.location
    c547v3 = OROKIN_TOWER_NODE_TAG
    if c547v2 ~= c547v3 then
      c547v1 = false
    else
      c547v1 = true
    end
    do return c547v1 end
  end
  IsNecraliskHub = vT[172]
  vT[172] = function(c548v0)
    local c548v1, c548v2, c548v3
    if c548v0 == nil then
      c548v1 = false
      do return c548v1 end
    end
    c548v2 = c548v0.location
    c548v3 = ENTRATI_LAB_NODE_TAG
    if c548v2 ~= c548v3 then
      c548v1 = false
    else
      c548v1 = true
    end
    do return c548v1 end
  end
  IsEntratiHub = vT[172]
  vT[172] = function()
    local c549v0, c549v1, c549v2, c549v3, c549v4
    c549v0 = GetUIMode
    c549v0 = c549v0()
    c549v1 = UI_MODE_IN_SPACE_HUB
    if c549v0 == c549v1 then
      c549v1 = gMatchingService
      c549v1 = c549v1:GetSquadHostHubLevelName()
      if c549v1 then
        c549v2 = string.find
        c549v4 = ENTRATI_LAB_NODE_TAG
        c549v2 = c549v2(c549v1, c549v4:c_str())
        if c549v2 ~= nil then
          c549v2 = true
          do return c549v2 end
        end
      end
    end
    c549v2 = gGameRules
    c549v1 = IsNull
    c549v1 = c549v1(c549v2)
    if not c549v1 then
      c549v1 = gGameRules
      c549v3 = gLotusBaseGameRulesType
      c549v1 = c549v1:IsA(c549v3)
      if c549v1 then
        c549v1 = IsEntratiHub
        c549v2 = gGameRules
        do return c549v1(c549v2:GetMission()) end
      end
    end
    c549v1 = false
    do return c549v1 end
  end
  IsInEntratiHub = vT[172]
  vT[172] = function(c550v0)
    local c550v1, c550v2, c550v3
    if c550v0 == nil then
      c550v1 = false
      do return c550v1 end
    end
    c550v2 = c550v0.location
    c550v3 = WF1999_MISSION_TAG
    if c550v2 ~= c550v3 then
      c550v1 = false
    else
      c550v1 = true
    end
    do return c550v1 end
  end
  Is1999Hub = vT[172]
  vT[172] = function(c551v0)
    local c551v1, c551v3
    c551v1 = IsNodeInList
    c551v3 = VANIA_MISSION_NODES
    do return c551v1(c551v0, c551v3) end
  end
  Is1999Mission = vT[172]
  vT[172] = function(c552v0)
    local c552v1, c552v3
    c552v1 = IsNodeInList
    c552v3 = DESCENT_MISSION_NODES
    do return c552v1(c552v0, c552v3) end
  end
  IsDescentMission = vT[172]
  vT[172] = function(c553v0)
    local c553v1, c553v3
    c553v1 = IsNodeInList
    c553v3 = TAU_BATTLE_MISSION_NODES
    do return c553v1(c553v0, c553v3) end
  end
  IsTauBattleMission = vT[172]
  vT[172] = function(c554v0)
    local c554v1, c554v2, c554v3
    c554v2 = gGameData
    c554v1 = IsNull
    c554v1 = c554v1(c554v2)
    if c554v1 then
      c554v1 = false
      do return c554v1 end
    end
    c554v1 = gGameData
    c554v1 = c554v1:Name__9709aaf8(c554v0)
    c554v2 = IsNull
    c554v2 = c554v2(c554v1)
    if c554v2 then
      c554v2 = true
      do return c554v2 end
    end
    if not c554v0 then
      c554v2 = false
      do return c554v2 end
    end
    c554v2 = Engine.Name__b38e1642
    c554v3 = c554v1.mExpiry
    c554v2 = c554v2(c554v3)
    c554v3 = 0
    if c554v2 <= c554v3 then
      c554v3 = true
      do return c554v3 end
    end
    c554v3 = false
    do return c554v3 end
  end
  CheckHellTowerProgressResetDate = vT[172]
  vT[172] = function()
    local c555v0, c555v1, c555v2, c555v3, c555v4
    c555v0 = GetUIMode
    c555v0 = c555v0()
    c555v1 = UI_MODE_IN_SPACE_HUB
    if c555v0 == c555v1 then
      c555v1 = gMatchingService
      c555v1 = c555v1:GetSquadHostHubLevelName()
      if c555v1 then
        c555v2 = string.find
        c555v4 = WF1999_MISSION_TAG
        c555v2 = c555v2(c555v1, c555v4:c_str())
        if c555v2 ~= nil then
          c555v2 = true
          do return c555v2 end
        end
      end
    end
    c555v2 = gGameRules
    c555v1 = IsNull
    c555v1 = c555v1(c555v2)
    if not c555v1 then
      c555v1 = gGameRules
      c555v3 = gLotusBaseGameRulesType
      c555v1 = c555v1:IsA(c555v3)
      if c555v1 then
        c555v1 = Is1999Hub
        c555v2 = gGameRules
        do return c555v1(c555v2:GetMission()) end
      end
    end
    c555v1 = false
    do return c555v1 end
  end
  IsIn1999Hub = vT[172]
  vT[172] = function()
    local c556v0, c556v1, c556v2, c556v3, c556v4, c556v5, c556v6
    c556v1 = gGameRules
    c556v0 = IsNull
    c556v0 = c556v0(c556v1)
    if not c556v0 then
      c556v0 = gGameRules
      c556v2 = gLotusBaseGameRulesType
      c556v0 = c556v0:IsA(c556v2)
      if c556v0 then
        c556v0 = gGameRules
        c556v0 = c556v0:GetMission()
        c556v0 = c556v0.location
        c556v2 = CETUS_NODE_TAG
        if c556v0 ~= c556v2 then
          c556v1 = false
        else
          c556v1 = true
        end
        c556v3 = FORTUNA_NODE_TAG
        if c556v0 ~= c556v3 then
          c556v2 = false
        else
          c556v2 = true
        end
        c556v3 = true
        c556v4 = OROKIN_TOWER_NODE_TAG
        if c556v0 ~= c556v4 then
          c556v4 = ENTRATI_LAB_NODE_TAG
          if c556v0 ~= c556v4 then
            c556v3 = false
          else
            c556v3 = true
          end
        end
        c556v5 = ZARIMAN_NODE_TAG
        if c556v0 ~= c556v5 then
          c556v4 = false
        else
          c556v4 = true
        end
        c556v6 = WF1999_MISSION_TAG
        if c556v0 ~= c556v6 then
          c556v5 = false
        else
          c556v5 = true
        end
        c556v6 = c556v1
        if not c556v6 then
          c556v6 = c556v2
          if not c556v6 then
            c556v6 = c556v3
            if not c556v6 then
              c556v6 = c556v4
              if not c556v6 then
                c556v6 = c556v5
              end
            end
          end
        end
        do return c556v6 end
      end
    end
    c556v0 = false
    do return c556v0 end
  end
  IsInTown = vT[172]
  vT[172] = function()
    local c557v0, c557v1, c557v2
    c557v1 = gGameRules
    c557v0 = IsNull
    c557v0 = c557v0(c557v1)
    if not c557v0 then
      c557v0 = gGameRules
      c557v2 = gLotusBaseGameRulesType
      c557v0 = c557v0:IsA(c557v2)
      if c557v0 then
        c557v1 = gGameRules
        c557v1 = c557v1:GetMissionType()
        c557v2 = 41
        if c557v1 ~= c557v2 then
          c557v0 = false
        else
          c557v0 = true
        end
        do return c557v0 end
      end
    end
    c557v0 = false
    do return c557v0 end
  end
  IsSayasVision = vT[172]
  vT[172] = function()
    local c558v0, c558v1, c558v2
    local p8 = 0
    if p8 == 0 then
      c558v2 = gRegion
      c558v1 = IsNull
      c558v1 = c558v1(c558v2)
      if c558v1 then
        p8 = 2
      else
        p8 = 1
      end
    end
    if p8 == 1 then
      c558v1 = gRegion
      c558v0 = c558v1:GetPlayingCinematic()
      p8 = 2
    end
    if p8 == 2 then
      c558v2 = IsNull
      c558v2 = c558v2(c558v0)
      if c558v2 then
        p8 = 4
      else
        p8 = 3
      end
    end
    if p8 == 3 then
      c558v2 = c558v0:IsSkipable()
      c558v1 = not c558v2
      if c558v1 then
        p8 = 5
      else
        p8 = 4
      end
    end
    if p8 == 4 then
      c558v1 = _T.QuestUnskippableCinPlaying
      p8 = 5
    end
    if p8 == 5 then
      do return c558v1 end
    end
  end
  IsAnyUnskippableCinematicPlaying = vT[172]
  vT[172] = function()
    local c559v0, c559v1, c559v2, c559v3
    local p14 = 0
    if p14 == 0 then
      c559v2 = gRegion
      c559v1 = IsNull
      c559v1 = c559v1(c559v2)
      if c559v1 then
        p14 = 2
      else
        p14 = 1
      end
    end
    if p14 == 1 then
      c559v1 = gRegion
      c559v0 = c559v1:GetPlayingCinematic()
      p14 = 2
    end
    if p14 == 2 then
      c559v3 = _T.QuestStartCinPlaying
      c559v2 = IsNull
      c559v2 = c559v2(c559v3)
      c559v1 = not c559v2
      if not c559v1 then
        p14 = 5
      else
        p14 = 3
      end
    end
    if p14 == 3 then
      c559v1 = _T.QuestStartCinPlaying
      if not c559v1 then
        p14 = 5
      else
        p14 = 4
      end
    end
    if p14 == 4 then
      c559v2 = _T.QuestUnskippableCinPlaying
      c559v1 = not c559v2
      p14 = 5
    end
    if p14 == 5 then
      c559v3 = IsNull
      c559v3 = c559v3(c559v0)
      if c559v3 then
        p14 = 7
      else
        p14 = 6
      end
    end
    if p14 == 6 then
      c559v2 = c559v0:IsSkipable()
      if c559v2 then
        p14 = 8
      else
        p14 = 7
      end
    end
    if p14 == 7 then
      c559v2 = c559v1
      p14 = 8
    end
    if p14 == 8 then
      do return c559v2 end
    end
  end
  IsAnySkippableCinematicPlaying = vT[172]
  vT[172] = function()
    local c560v0, c560v1, c560v2
    c560v2 = gRegion
    c560v1 = IsNull
    c560v1 = c560v1(c560v2)
    if not c560v1 then
      c560v1 = gRegion
      c560v0 = c560v1:GetPlayingCinematic()
    end
    c560v2 = IsNull
    c560v2 = c560v2(c560v0)
    c560v1 = not c560v2
    do return c560v1 end
  end
  CheckAnyCinematicPlaying = vT[172]
  vT[172] = function()
    local c561v0, c561v1, c561v2
    c561v2 = gBackgroundRegion
    c561v1 = IsNull
    c561v1 = c561v1(c561v2)
    if not c561v1 then
      c561v1 = gBackgroundRegion
      c561v0 = c561v1:GetPlayingCinematic()
    end
    c561v2 = IsNull
    c561v2 = c561v2(c561v0)
    c561v1 = not c561v2
    if c561v1 then
      c561v1 = c561v0:IsPlaying()
      if c561v1 then
        c561v1 = _T.QuestStartCinPlaying
      end
    end
    do return c561v1 end
  end
  CheckQuestCinematicIsPlaying = vT[172]
  vT[172] = function()
    local c562v0, c562v1, c562v2, c562v3, c562v4, c562v5, c562v6, c562v7, c562v10, c562v11, c562v12, c562v13, c562v14, c562v15, c562v16
    c562v0 = {}
    c562v2 = gGameData
    c562v1 = IsNull
    c562v1 = c562v1(c562v2)
    c562v1 = gRegion
    c562v1 = c562v1:GetLocalPlayerAvatar()
    c562v2 = IsNull
    c562v2 = c562v2(c562v1)
    c562v2 = c562v1:InventoryControl()
    c562v4 = 0
    c562v5 = 1
    c562v6 = 5
    c562v3 = {c562v4, c562v5, c562v6}
    c562v5 = 1
    c562v6 = 2
    c562v7 = 3
    c562v4 = {c562v5, c562v6, c562v7}
    c562v5 = ipairs
    c562v5, c562v6, c562v7 = c562v5(c562v3)
    for c562v8, c562v9 in c562v5, c562v6, c562v7 do
      c562v10 = c562v2:GetWeaponInSlot(c562v9)
      c562v11 = IsNull
      c562v11 = c562v11(c562v10)
      c562v11 = c562v10:IsEvolvingWeapon()
      c562v11 = IsNull
      c562v11 = c562v11(c562v10:GetEvolutionReq())
      c562v13 = 9
      c562v11 = c562v10:HasFeature(c562v13)
      c562v11 = gGameData
      c562v11 = c562v11:GetEvolutionProgress(c562v10:GetEvolutionType())
      c562v12 = IsNull
      c562v12 = c562v12(c562v11)
      if not c562v12 then
        c562v12 = gGameData
        c562v12 = c562v12:GetInventory()
        c562v14 = 0
        c562v15 = c562v4[c562v8]
        c562v16 = tostring
        c562v16 = c562v16(c562v10:Name__90f99e29())
        c562v12 = c562v12:Name__80a6a021(c562v14, c562v15, c562v16)
        c562v14 = c562v11.rank
        c562v13 = math.min
        c562v13 = c562v13(c562v14, c562v10:NumEvolutions())
        if c562v12 < c562v13 then
          c562v16 = c562v10:GetLocalizeTag()
          c562v14 = table.insert
          c562v14(c562v0, c562v16:c_str())
        end
      end
    end
    do return c562v0 end
  end
  GetEvolvingWeaponsUpgradeAvailable = vT[172]
  vT[172] = function()
    local c563v0, c563v1, c563v2, c563v3, c563v4
    c563v0 = gMatchingService
    c563v0 = c563v0:GetSquadMembers()
    c563v3 = 1
    c563v1 = #c563v0
    c563v2 = 1
    for c563v3 = c563v3, c563v1, c563v2 do
      c563v4 = c563v0[c563v3]
      c563v4 = c563v4.isHost
      if c563v4 then break end
      if c563v4 then
        c563v4 = c563v0[c563v3]
        c563v4 = c563v4.hubLevel
        do return c563v4 end
      end
    end
    c563v1 = ""
    do return c563v1 end
  end
  GetHostHubLevel = vT[172]
  vT[172] = function(c564v0)
    local c564v1, c564v2, c564v3
    if c564v0 == nil then
      c564v1 = false
      do return c564v1 end
    end
    c564v2 = c564v0.missionType
    c564v3 = 39
    if c564v2 ~= c564v3 then
      c564v1 = false
    else
      c564v1 = true
    end
    do return c564v1 end
  end
  IsAscensionMission = vT[172]
  vT[172] = function(c565v0)
    local c565v1, c565v2, c565v3, c565v4
    local p8 = 0
    if p8 == 0 then
      c565v1 = c565v0
      if not c565v1 then
        p8 = 6
      else
        p8 = 1
      end
    end
    if p8 == 1 then
      c565v2 = string.find
      c565v4 = c565v0.mTag
      c565v3 = tostring
      c565v3 = c565v3(c565v4)
      c565v4 = "JadeShadows"
      c565v2 = c565v2(c565v3, c565v4)
      if c565v2 ~= nil then
        p8 = 3
      else
        p8 = 2
      end
    end
    if p8 == 2 then
      c565v1 = false
      c565v2 = string.find
      c565v4 = c565v0.mTag
      c565v3 = tostring
      c565v3 = c565v3(c565v4)
      c565v4 = "12MinWarEvent"
      c565v2 = c565v2(c565v3, c565v4)
      if c565v2 == nil then
        p8 = 6
      else
        p8 = 3
      end
    end
    if p8 == 3 then
      c565v2 = gGameData
      c565v2 = c565v2:GetMissionDifficultyTier()
      c565v3 = 0
      if c565v3 < c565v2 then
        p8 = 5
      else
        p8 = 4
      end
    end
    if p8 == 4 then
      c565v1 = false
      p8 = 6
    end
    if p8 == 5 then
      c565v1 = true
      p8 = 6
    end
    if p8 == 6 then
      do return c565v1 end
    end
  end
  IsSteelPathEventAlert = vT[172]
  vT[172] = function(c566v0)
    local c566v1, c566v3, c566v4
    c566v1 = IsNull
    c566v1 = c566v1(c566v0)
    if not c566v1 then
      c566v1 = type
      c566v1 = c566v1(c566v0)
      if c566v1 == "userdata" then
        c566v3 = WeakResource
        c566v4 = "/Lotus/Powersuits/Khora/KhoraWhipclawWeapon"
        c566v1 = c566v0:IsA(c566v3(c566v4))
        if not c566v1 then
          c566v3 = WeakResource
          c566v4 = "/Lotus/Powersuits/Glass/GaraShankWeapon"
          c566v1 = c566v0:IsA(c566v3(c566v4))
          if not c566v1 then
            c566v3 = WeakResource
            c566v4 = "/Lotus/Powersuits/Brawler/AtlasPunchWeapon"
            c566v1 = c566v0:IsA(c566v3(c566v4))
            if not c566v1 then
              c566v3 = WeakResource
              c566v4 = "/Lotus/Powersuits/Ninja/NinjaStormWeapon"
              c566v1 = c566v0:IsA(c566v3(c566v4))
            end
          end
        end
        do return c566v1 end
      end
    end
    do return end
  end
  IsPseudoExalted = vT[172]
  vT[172] = function(c567v0)
    local c567v1, c567v2, c567v3
    c567v2 = vT[39]
    c567v1 = c567v2[c567v0]
    if c567v1 == nil then
      c567v1 = 1
    end
    c567v3 = _G
    c567v3 = c567v3.UIMaterials_StickerDecoMaterials
    c567v2 = c567v3[c567v1]
    do return c567v2 end
  end
  GetStickerFrameMaterial = vT[172]
  vT[172] = function(c568v0)
    local c568v1, c568v2, c568v3
    c568v1 = vT[39]
    c568v2 = nil
    c568v3 = nil
    for c568v4, c568v5 in c568v1, c568v2, c568v3 do
      if c568v5 == c568v0 then
        do return c568v4 end
      end
    end
    c568v1 = "Basic"
    do return c568v1 end
  end
  GetStickerFrameMaterialTag = vT[172]
  vT[172] = function(c569v0)
    local c569v1, c569v2
    c569v2 = vT[39]
    c569v1 = c569v2[c569v0]
    if c569v1 == nil then
      c569v2 = 1
      do return c569v2 end
    end
    do return c569v1 end
  end
  GetStickerFrameRankFromMaterialTag = vT[172]
  do return end
