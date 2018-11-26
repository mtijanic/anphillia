///////////////////////////////////////////////////////////////////////////////
// ip_cfg
// written by: eyesolated
// written at: June 17, 2004
//
// Notes: ItemProperty Config File

// The system version will be safed on infused items
const int CI_IP_VERSION = 1;

// Use NWNX?
const int CI_IP_USE_NWNX = TRUE;

// Sets the maximum number of positive properties an item can receive
const int CI_IP_MAX_POSITIVE                            = 3;

// Sets the maximum number of negative properties an item can receive
const int CI_IP_MAX_NEGATIVE                            = 2;

// Sets the maximum number of restrictive properties an item can receive
const int CI_IP_MAX_RESTRICTIVE                         = 1;

// Sets the required/allowed numbers of properties an item needs to be colored Rare.
// These conditinos are AND-related
const int CI_IP_RARE_MINPOSITIVE                        = 2;
const int CI_IP_RARE_MAXNEGATIVE                        = 0;

// The following number defines how much a positive property is allowed to be below
// the maximum theoretical level achievable for the given item for it to be considered
// RARE. Set this to -1 to deactivate this feature
const int CI_IP_RARE_ALLOWED_POSITIVE_DEVIATION         = 2;

// Sets the required/allowed numbers of properties an item needs to be colored Rare.
// These conditinos are AND-related
const int CI_IP_EPIC_MINPOSITIVE                        = 3;
const int CI_IP_EPIC_MAXNEGATIVE                        = 0;

// The following number defines how much a positive property is allowed to be below
// the maximum theoretical level achievable for the given item for it to be considered
// RARE. Set this to -1 to deactivate this feature
const int CI_IP_EPIC_ALLOWED_POSITIVE_DEVIATION         = 1;

// This sets the maximum Magic Item Level the System will be able to produce.
// Default: 50
const int CI_IP_MAXMAGICLEVEL                           = 10;

// This sets the maximum Magic Item Level the System will be able to produce for
// undroppable Monster Equipment.
// Default: 50
const int CI_IP_MAXMAGICLEVEL_MONSTERONLY = 50;

// These values set the chances for additional properties beyond the first one
// CI_IP_ADDITIONAL_x_PROPERTY_BASE is the base % of getting an additional
// property while CI_IP_ADDITIONAL_x_PROPERTY_MODIFIER is multiplied with the
// existing properties on the item and is subtracted from the base chance.
// Example: An item has 1 property. With BASE set to 15% and MODIFIER set to 3%, there
//          is a 12% chance to get a second property.
//          An item already has 2 properties. With BASE set to 15% and MODIFIER set
//          to 3%, there is a 9% chance to get a third property.
const int CI_IP_ADDITIONAL_POSITIVE_PROPERTY_CHANCE_BASE = 27;
const int CI_IP_ADDITIONAL_POSITIVE_PROPERTY_CHANCE_MODIFIER = 9;

// The LEVEL_MODIFIER rolls a random value by which the magic level of an additional property
// is reduced.
// CI_IP_ADDITIONAL_x_PROPERTY_LEVEL_MODIFIER_BASE is the base reduction for an
// additional property, while CI_IP_ADDITIONAL_x_PROPERTY_LEVEL_MODIFIER_RANDOM adds
// a random element to the subtraction. The minimum Magic Level is always 1.
const int CI_IP_ADDITIONAL_POSITIVE_PROPERTY_LEVEL_MODIFIER_BASE = 0;
const int CI_IP_ADDITIONAL_POSITIVE_PROPERTY_LEVEL_MODIFIER_RANDOM = 3;
const int CI_IP_ADDITIONAL_NEGATIVE_PROPERTY_LEVEL_MODIFIER_BASE = 0;
const int CI_IP_ADDITIONAL_NEGATIVE_PROPERTY_LEVEL_MODIFIER_RANDOM = 3;
const int CI_IP_ADDITIONAL_RESTRICTIVE_PROPERTY_LEVEL_MODIFIER_BASE = 0;
const int CI_IP_ADDITIONAL_RESTRICTIVE_PROPERTY_LEVEL_MODIFIER_RANDOM = 3;

// The Base % of getting a negative property on the item. The formula used is
// Positive_Properties * (CI_IP_ADDITIONAL_NEGATIVE_PROPERTY_CHANCE_BASE - (Total_Properties - Positive_Properties) * CI_IP_ADDITIONAL_NEGATIVE_PROPERTY_CHANCE_REDUCTION)
// Example A: If the item has 3 positive properties and CHANCE_BASE is set to 8 while CHANCE_REDUCTION is set to 1
//            First negative property : 3 * (8 - (3 - 3) * 1) = 24%
//            Second negative proeprty: 3 * (8 - (4 - 3) * 1) = 21%
// Example B: If the item has 3 positive properties and CHANCE_BASE is set to 10 while CHANCE_REDUCTION is set to 3
//            First negative property : 3 * (10 - (3 - 3) * 3) = 30%
//            Second negative proeprty: 3 * (10 - (4 - 3) * 3) = 21%
const int CI_IP_ADDITIONAL_NEGATIVE_PROPERTY_CHANCE_BASE = 20;
const int CI_IP_ADDITIONAL_NEGATIVE_PROPERTY_CHANCE_REDUCTION = 15;

// This sets the Basic Chance / Positive Property for an item to receive a restrictive
// Property.
const int CI_IP_CHANCE_RESTRICTIVE = 5;

// This sets the added chance for a restrictive property for wands and rods
const int CI_IP_RODWAND_EXTRA_CHANCE_RESTRICTIVE = 50;

// These constants define the possible values regarding enabling/disabling properties
// within the system. Do not modify these.
const int CI_IP_PROPERTY_DISABLED                               = 0;
const int CI_IP_PROPERTY_ENABLED                                = 1;
const int CI_IP_PROPERTY_ENABLED_MONSTERONLY                    = 2;

// If Ability Bonus is activated, should the abilities be restricted to the following slots?
// Belt:   STR, CON, WIS, CHA
// Gloves: STR, DEX, INT, CHA
// Cloak:  DEX, CON, INT, WIS
const int CI_IP_RESTRICT_AbilityBonus                           = TRUE;

// If Regeneration is activated, should it be restricted to jewelry only?
const int CI_IP_RESTRICT_Regeneration                           = TRUE;

// Enable/Disable Properties within the system
// These settings affect the sysetm itself, properties set to CI_IP_PROPERTY_DISABLED here won't
// appear on any item created. CI_IP_PROPERTY_ENABLED means the item will appear on items,
// CI_IP_PROPERTY_ENABLED_MONSTERONLY means only items generated for monsters only will have
// this property on them.
//
// If you want properties to scale differently or change wheter they are
// available to players or monsters only on differenr power levels, modify the script "ip_ini".
const int CI_IP_ENABLE_AbilityBonus                             = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_ACBonus                                  = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_ACBonusVsAlignment                       = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_ACBonusVsDmgType                         = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_ACBonusVsRace                            = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_ACBonusVsSpecificAlignment               = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_AdditionalProperty                       = CI_IP_PROPERTY_ENABLED_MONSTERONLY;   // Unknown, Cursed, used for Socketing for now
const int CI_IP_ENABLE_ArcaneSpellFailure_Increased             = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_ArcaneSpellFailure_Decreased             = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_AttackBonus                              = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_AttackBonusVsAlignment                   = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_AttackBonusVsRace                        = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_AttackBonusVsSpecificAlignment           = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_AttackPenalty                            = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_BonusFeat                                = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_BonusLevelSpell                          = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_BonusSavingThrow                         = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_BonusSavingThrowVsX                      = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_BonusSavingThrowVsXUniversalIncluded     = CI_IP_PROPERTY_DISABLED;              // Shouldn't enable this, too powerful
const int CI_IP_ENABLE_BonusSpellResistance                     = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_CastSpell                                = CI_IP_PROPERTY_ENABLED;               // This is for books and staves
const int CI_IP_ENABLE_CastSpellPotion                          = CI_IP_PROPERTY_ENABLED;               // Potions won't work at all if this is FALSE
const int CI_IP_ENABLE_CastSpellWand_5ChargesPerUse             = CI_IP_PROPERTY_ENABLED;               // If you disable all CastSpellWand switches, wands
const int CI_IP_ENABLE_CastSpellWand_1ChargePerUse              = CI_IP_PROPERTY_ENABLED;               // and rods won't work at all
const int CI_IP_ENABLE_CastSpellWand_1PerDay                    = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_CastSpellWand_2PerDay                    = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_CastSpellWand_3PerDay                    = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_CastSpellWand_Unlimited                  = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_ContainerReducedWeight                   = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_DamageBonus                              = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_DamageBonusVsAlignment                   = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_DamageBonusVsRace                        = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_DamageBonusVsSpecificAlignment           = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_DamageImmunity                           = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_DamagePenalty                            = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_DamageReduction                          = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_DamageResistance                         = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_DamageVulnerability                      = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_Darkvision                               = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_DecreaseAbility                          = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_DecreaseAC                               = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_DecreaseSkill                            = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_DecreaseSkillAllSkillsIncluded           = CI_IP_PROPERTY_DISABLED;              // Shouldn't enable this, too powerful
const int CI_IP_ENABLE_EnhancementBonus                         = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_EnhancementBonusVsAlignment              = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_EnhancementBonusVsRace                   = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_EnhancementBonusVsSpecificAlignment      = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_ExtraMeleeDamageType                     = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_ExtraRangeDamageType                     = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_Haste                                    = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_HealersKit                               = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_HolyAvenger                              = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_ImmunityMisc                             = CI_IP_PROPERTY_ENABLED;               // Immunities included for players: Poison, Fear, Death Magic
const int CI_IP_ENABLE_ImmunityToSpellLevel                     = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_ImprovedEvasion                          = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_Keen                                     = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_Light                                    = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_LimitUseByAlignment                      = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_LimitUseByClass                          = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_LimitUseByRace                           = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_LimitUseBySpecificAlignment              = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_MassiveCritical                          = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_Mighty                                   = CI_IP_PROPERTY_ENABLED;               // Mighty property for Ranged Weapons like Bows, allowing STR Bonus on Damage rolls
const int CI_IP_ENABLE_MonsterDamage                            = CI_IP_PROPERTY_ENABLED_MONSTERONLY;   // Only works on Creature Weapons
const int CI_IP_ENABLE_NoDamage                                 = CI_IP_PROPERTY_DISABLED;
// NOT AVAILABLE const int CI_IP_ENABLE_OnHitCastSpell = CI_IP_PROPERTY_ENABLED;
// NOT AVAILABLE const int CI_IP_ENABLE_OnHitProps = CI_IP_PROPERTY_ENABLED;
// NOT AVAILABLE const int CI_IP_ENABLE_OnMonsterHitProperties = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_ReducedSavingThrow                       = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_ReducedSavingThrowVsX                    = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_ReducedSavingThrowVsXUniversalIncluded   = CI_IP_PROPERTY_DISABLED;              // Shouldn't enable this, too powerful
const int CI_IP_ENABLE_Regeneration                             = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_SkillBonus                               = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_SkillBonusAllIncluded                    = CI_IP_PROPERTY_DISABLED;              // Shouldn't enable this, too powerful
// NOT AVAILABLE const int CI_IP_ENABLE_SpecialWalk = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_SpellImmunitySchool                      = CI_IP_PROPERTY_ENABLED_MONSTERONLY;
const int CI_IP_ENABLE_SpellImmunitySpecific                    = CI_IP_PROPERTY_DISABLED;
const int CI_IP_ENABLE_ThievesTools                             = CI_IP_PROPERTY_ENABLED;               // Thieves' Tools won't work at all if this is FALSE
const int CI_IP_ENABLE_Trap                                     = CI_IP_PROPERTY_ENABLED;               // Traps won't work at all if this is FALSE
const int CI_IP_ENABLE_TrueSeeing                               = CI_IP_PROPERTY_DISABLED;              // TRUE Seeing is bugged in regards to Hide/Move Silently
// NOT AVAILABLE const int CI_IP_ENABLE_TurnResistance = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_UnlimitedAmmo                            = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_VampiricRegeneration                     = CI_IP_PROPERTY_ENABLED;
// NOT AVAILABLE const int CI_IP_ENABLE_VisualEffect = CI_IP_PROPERTY_ENABLED;
// NOT AVAILABLE const int CI_IP_ENABLE_WeightIncrease = CI_IP_PROPERTY_ENABLED;
const int CI_IP_ENABLE_WeightReduction                          = CI_IP_PROPERTY_ENABLED;



////////////////////////////////////////////
// !!! DON'T TOUCH ANYTHING BELOW THIS !!! /
// !!! DON'T TOUCH ANYTHING BELOW THIS !!! /
// !!! DON'T TOUCH ANYTHING BELOW THIS !!! /
////////////////////////////////////////////

const string CS_IP_VAR_CREATION_VERSION                         = "ip_Creation_Version";
const string CS_IP_VAR_CREATION_LEVEL                           = "ip_Creation_Level";

const string CS_IP_INI_USERDEFINEDEVENTNUMBER                   = "IP_EVENTID";
const string CS_IP_INIB_USERDEFINEDEVENTNUMBER                  = "IPB_EVENTID";

const string CS_IP_TABLE                                        = "ip_Properties";
const string CS_IP_ARRAY_INIT                                   = "IP_ARRAY_INIT";

// In case we don't use NWNx, we need alternatives
const string CS_IP_DB_PRELOAD_STORE_OBJ                         = "IP_PRE_STORE";
const string CS_IP_DB_PRELOAD_STORE                             = "IP_PRE_S_TAG";
const string CS_IP_DB_PRELOAD_AREA_OBJ                          = "IP_PRE_AREA";

const string CS_IP_DB_PRELOAD_ARRAY                             = "IP_PRE_ARRAY";

const string CS_IP_DB_AREA = "A_EGS";
const string CS_IP_DB_WAYPOINT = "WP_EGS";
const string CS_IP_DB_MERCHANT_RESREF = "M_EGS";
const string CS_IP_DB_ITEMINFO_RESREF = "I_EGS_ItemInfo";
const string CS_IP_DB_MERCHANT_ID = "M_IP_ID";
const string CS_IP_DB_MERCHANT_MAIN = "M_IP_M";
const string CS_IP_DB_MERCHANT_SUB = "M_IP_S";
const string CS_IP_DB_MERCHANT_BASE = "M_IP_B";
const string CS_IP_DB_MERCHANT_MONSTERONLY_ID = "M_IP_MID";
const string CS_IP_DB_MERCHANT_MONSTERONLY_MAIN = "M_IP_MOM";
const string CS_IP_DB_MERCHANT_MONSTERONLY_SUB = "M_IP_MOS";
const string CS_IP_DB_MERCHANT_MONSTERONLY_BASE = "M_IP_MOB";
const string CS_IP_ARRAY_ID = "IP_A_ID";
const string CS_IP_ARRAY_MAINCATEGORY = "IP_MC";
const string CS_IP_ARRAY_SUBCATEGORY = "IP_SC";
const string CS_IP_ARRAY_BASEITEM = "IP_BI";

const string CS_IP_DB_TEMPARRAY_MAINCATEGORIES = "IP_TMP_C";
const string CS_IP_DB_TEMPARRAY_SUBCATEGORIES = "IP_TMP_S";
const string CS_IP_DB_TEMPARRAY_BASEITEMS = "IP_TMP_B";

const string CS_IP_DB_TEMPARRAY_SELECTIP = "IP_TMP_SIP";
const string CS_IP_DB_TEMPARRAY_STORE = "IP_TMP_STO";

struct STRUCT_IP_PropertyDetails
{
   itemproperty IP;
   string Prefix1;
   string Prefix2;
   string Postfix;
   int PropID;
   int Var1;
   int Var2;
   int Var3;
};

// Field Definitions
const string CS_IP_ENTRY_ID = "Entry_ID";
const string CS_IP_ID = "Property_ID";
const string CS_IP_TYPE = "Type";
const string CS_IP_CATEGORIES_MAIN = "MainCategories";
const string CS_IP_CATEGORIES_SUB = "SubCategories";
const string CS_IP_BASEITEMS = "BaseItems";
const string CS_IP_LEVEL = "Level";
const string CS_IP_VARONE = "Variable1";
const string CS_IP_VARTWO = "Variable2";
const string CS_IP_VARTHREE = "Variable3";
const string CS_IP_MONSTERONLY = "MonsterOnly";
const string CS_IP_PLAYERONLY = "PlayerOnly";
const string CS_IP_PREFIX_I = "Prefix1";
const string CS_IP_PREFIX_II = "Prefix2";
const string CS_IP_POSTFIX = "Postfix";

// Property Types
const int CI_IP_TYPE_POSITIVE = 0;
const int CI_IP_TYPE_NEGATIVE = 1;
const int CI_IP_TYPE_RESTRICTIVE = 2;

// SpellType constants
const int CI_IP_POTION = 1;
const int CI_IP_WAND = 2;
const int CI_IP_OTHER = 3;

// Property constants
const int CI_IP_Invalid = 0;
const int CI_IP_AbilityBonus = 1;
const int CI_IP_ACBonus = 2;
const int CI_IP_ACBonusVsAlign = 3;
// NON_EXISTANT! const int CI_IP_ACBonusVsAlignAllIncluded = 4;
const int CI_IP_ACBonusVsDmgType = 5;
const int CI_IP_ACBonusVsRace = 6;
const int CI_IP_ACBonusVsSAlign = 7;
const int CI_IP_AdditionalProperty = 86;
const int CI_IP_ArcaneSpellFailure = 8;
const int CI_IP_AttackBonus = 9;
const int CI_IP_AttackBonusVsAlign = 10;
// NON_EXISTANT! const int CI_IP_AttackBonusVsAlignAllIncluded = 11;
const int CI_IP_AttackBonusVsRace = 12;
const int CI_IP_AttackBonusVsSAlign = 13;
const int CI_IP_AttackPenalty = 14;
const int CI_IP_BonusFeat = 15;
const int CI_IP_BonusLevelSpell = 16;
const int CI_IP_BonusSavingThrow = 17;
const int CI_IP_BonusSavingThrowVsX = 18;
const int CI_IP_BonusSavingThrowVsXUniversalIncluded = 83;
const int CI_IP_BonusSpellResistance = 19;
const int CI_IP_CastSpell = 20;
const int CI_IP_CastSpellPotion = 84;
const int CI_IP_CastSpellWand = 85;
const int CI_IP_ContainerReducedWeight = 21;
const int CI_IP_DamageBonus = 22;
const int CI_IP_DamageBonusVsAlign = 23;
// NON_EXISTANT! const int CI_IP_DamageBonusVsAlignAllIncluded = 24;
const int CI_IP_DamageBonusVsRace = 25;
const int CI_IP_DamageBonusVsSAlign = 26;
const int CI_IP_DamageImmunity = 27;
const int CI_IP_DamagePenalty = 28;
const int CI_IP_DamageReduction = 29;
const int CI_IP_DamageResistance = 30;
const int CI_IP_DamageVulnerability = 31;
const int CI_IP_Darkvision = 32;
const int CI_IP_DecreaseAbility = 33;
const int CI_IP_DecreaseAC = 34;
const int CI_IP_DecreaseSkill = 35;
const int CI_IP_DecreaseSkillAllSkillsIncluded = 36;
const int CI_IP_EnhancementBonus = 37;
const int CI_IP_EnhancementBonusVsAlign = 38;
// NON_EXISTANT! const int CI_IP_EnhancementBonusVsAlignAllIncluded = 39;
const int CI_IP_EnhancementBonusVsRace = 40;
const int CI_IP_EnhancementBonusVsSAlign = 41;
// Deactivated const int CI_IP_EnhancementPenalty = 42;
const int CI_IP_ExtraMeleeDamageType = 43;
const int CI_IP_ExtraRangeDamageType = 44;
// NON_EXISTANT! const int CI_IP_FreeAction = 45;
const int CI_IP_Haste = 46;
const int CI_IP_HealersKit = 47;
const int CI_IP_HolyAvenger = 48;
const int CI_IP_ImmunityMisc = 49;
const int CI_IP_ImmunityToSpellLevel = 50;
const int CI_IP_ImprovedEvasion = 51;
const int CI_IP_Keen = 52;
const int CI_IP_Light = 53;
const int CI_IP_LimitUseByAlign = 54;
const int CI_IP_LimitUseByClass = 55;
const int CI_IP_LimitUseByRace = 56;
const int CI_IP_LimitUseBySAlign = 57;
const int CI_IP_MassiveCritical = 58;
const int CI_IP_MaxRangeStrengthMod = 59;
const int CI_IP_MonsterDamage = 60;
const int CI_IP_NoDamage = 61;
const int CI_IP_OnHitCastSpell = 62;
const int CI_IP_OnHitProps = 63;
const int CI_IP_OnMonsterHitProperties = 64;
const int CI_IP_ReducedSavingThrow = 65;
const int CI_IP_ReducedSavingThrowVsX = 67;
const int CI_IP_ReducedSavingThrowVsXUniversalIncluded = 66;
const int CI_IP_Regeneration = 68;
const int CI_IP_SkillBonus = 69;
const int CI_IP_SkillBonusAllIncluded = 70;
const int CI_IP_SpecialWalk = 71;
const int CI_IP_SpellImmunitySchool = 72;
const int CI_IP_SpellImmunitySpecific = 73;
const int CI_IP_ThievesTools = 74;
const int CI_IP_Trap = 75;
const int CI_IP_TrueSeeing = 76;
const int CI_IP_TurnResistance = 77;
const int CI_IP_UnlimitedAmmo = 78;
const int CI_IP_VampiricRegeneration = 79;
const int CI_IP_VisualEffect = 80;
const int CI_IP_WeightIncrease = 81;
const int CI_IP_WeightReduction = 82;
// const int CI_IP_BonusSavingThrowVsXUniversalIncluded = 83; // Declared above !!! Just for reference
// const int CI_IP_CastSpellPotion = 84; // Declared above !!! Just for reference
// const int CI_IP_CastSpellWand = 85; // Declared above !!! Just for reference
// const int CI_IP_AdditionalProperty = 86; // Declared above !!! Just for reference
