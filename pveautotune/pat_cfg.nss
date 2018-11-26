/************************************************************************
 * script name  : pat_cfg
 * created by   : eyesolated
 * date         : 2018/7/31
 *
 * description  : Configuration script for PAT
 *
 * changes      : 2018/7/31 - eyesolated - Initial creation
 ************************************************************************/

/*******************************************************************************
 * General Configuration Settings
 *
 * This section covers generic settings regarding PAT.
 ******************************************************************************/

// Enable/Disable PAT
const int PAT_ENABLED                   = TRUE;

// Maximum CR that PAT can produce
const int PAT_CR_MAXIMUM                = 30;
const int PAT_IP_MAXMAGICLEVEL          = 30;

// Elite / Champion System
const int PAT_AUTO_CR_ENABLE            = TRUE;
const int PAT_AUTO_CR_CHANCE_ELITE      = 10;
const int PAT_AUTO_CR_CHANCE_CHAMPION   = 5;
const int PAT_AUTO_CR_MODIFIER_ELITE    = 1;
const int PAT_AUTO_CR_MODIFIER_CHAMPION = 3;

/*******************************************************************************
 * Progression Configuration Settings
 *
 * This section covers the mathematical configuration setting up the progression
 * curves of the various creature statistics.
 ******************************************************************************/

// Ability Gain constants
const int PAT_ABILITY_BASE              = 6;
const float PAT_ABILITY_GAIN_EXTREME    = 1.5f;
const float PAT_ABILITY_GAIN_HIGH       = 1.25f;
const float PAT_ABILITY_GAIN_MEDIUM     = 1.0f;
const float PAT_ABILITY_GAIN_LOW        = 0.5f;

// Saving Throw Gain constants
const int PAT_SAVINGTHROW_BASE          = 4;
const float PAT_SAVINGTHROW_GAIN_HIGH   = 1.0f;
const float PAT_SAVINGTHROW_GAIN_MEDIUM = 0.7f;
const float PAT_SAVINGTHROW_GAIN_LOW    = 0.4f;

// AC Gain constants
// AC calculation: PAT_AC_BASE + (CR / PAT_AC_GAIN + CR * CR / (PAT_AC_GAIN * 10))
const int PAT_AC_BASE                   = 0;        // Natural Armor = 10
const int PAT_AC_MAXIMUM                = 30;
const float PAT_AC_GAIN_HIGH            = 3.0f;
const float PAT_AC_GAIN_MEDIUM          = 4.0f;
const float PAT_AC_GAIN_LOW             = 5.0f;

// BAB Gain constants
const int PAT_BAB_BASE                  = 0;
const float PAT_BAB_GAIN_HIGH           = 1.0f;
const float PAT_BAB_GAIN_MEDIUM         = 0.75f;
const float PAT_BAB_GAIN_LOW            = 0.5f;

// Hitpoint Gain constants
// HP calculation: PAT_HP_BASE + (CR * (6 - PAT_HP_GAIN) + CR * CR * CR / (10 * PAT_HP_GAIN))
const int PAT_HP_BASE                   = 6;
const float PAT_HP_GAIN_HIGH            = 1.1f;
const float PAT_HP_GAIN_MEDIUM          = 2.2f;
const float PAT_HP_GAIN_LOW             = 3.3f;

// Skill Gains
const int PAT_SKILLS_BASE               = 3;
const float PAT_SKILLS_EXTREME          = 1.5f;
const float PAT_SKILLS_HIGH             = 1.25f;
const float PAT_SKILLS_MEDIUM           = 0.75f;
const float PAT_SKILLS_LOW              = 0.5f;

// Gain Rate Constants
// These are used to reference the actual Gain_Rates
const int PAT_GAIN_EXTREME              = 1;
const int PAT_GAIN_HIGH                 = 2;
const int PAT_GAIN_MEDIUM               = 3;
const int PAT_GAIN_LOW                  = 4;

/*******************************************************************************
 * Role Configuration
 *
 * In this section you can configure constants for Role_IDs and Role_Names to
 * make referencing them easier
 ******************************************************************************/
const int PAT_ROLE_UNDEFINED                        = 0;

const int PAT_ROLE_DPS                              = 99;
const int PAT_ROLE_DPS_MELEE                        = 100;
const int PAT_ROLE_DPS_MELEE_STR                    = 101;
const int PAT_ROLE_DPS_MELEE_DEX                    = 102;

const int PAT_ROLE_DPS_RANGE                        = 200;
const int PAT_ROLE_DPS_RANGE_DEX                    = 201;
const int PAT_ROLE_DPS_RANGE_WIS                    = 202;

const int PAT_ROLE_DPS_CASTER                       = 300;
const int PAT_ROLE_DPS_CASTER_INT                   = 301;
const int PAT_ROLE_DPS_CASTER_WIS                   = 302;
const int PAT_ROLE_DPS_CASTER_CHA                   = 303;

const int PAT_ROLE_HEAL                             = 400;
const int PAT_ROLE_HEAL_WIS                         = 401;

const int PAT_ROLE_SUPPORT                          = 500;
const int PAT_ROLE_SUPPORT_INT                      = 501;
const int PAT_ROLE_SUPPORT_WIS                      = 502;
const int PAT_ROLE_SUPPORT_CHA                      = 503;

const int PAT_ROLE_TANK                             = 600;
const int PAT_ROLE_TANK_STR                         = 601;

// From 10000 and up, roles won't get equipped
const int PAT_ROLE_NAKED                            = 10000;

const int PAT_ROLE_NAKED_DPS                        = 10100;
const int PAT_ROLE_NAKED_DPS_STR                    = 10101;
const int PAT_ROLE_NAKED_DPS_DEX                    = 10102;

const int PAT_ROLE_NAKED_TANK                       = 10200;
const int PAT_ROLE_NAKED_TANK_STR                   = 10201;

const string PAT_ROLE_NAME_DPS                      = "DPS";
const string PAT_ROLE_NAME_DPS_MELEE                = "DPS_Melee";
const string PAT_ROLE_NAME_DPS_MELEE_STR            = "DPS_Melee_STR";
const string PAT_ROLE_NAME_DPS_MELEE_DEX            = "DPS_Melee_DEX";

const string PAT_ROLE_NAME_DPS_RANGE                = "DPS_Range";
const string PAT_ROLE_NAME_DPS_RANGE_DEX            = "DPS_Range_DEX";
const string PAT_ROLE_NAME_DPS_RANGE_WIS            = "DPS_Range_WIS";

const string PAT_ROLE_NAME_DPS_CASTER               = "DPS_Caster";
const string PAT_ROLE_NAME_DPS_CASTER_INT           = "DPS_Caster_INT";
const string PAT_ROLE_NAME_DPS_CASTER_WIS           = "DPS_Caster_WIS";
const string PAT_ROLE_NAME_DPS_CASTER_CHA           = "DPS_Caster_CHA";

const string PAT_ROLE_NAME_HEAL                     = "Heal";
const string PAT_ROLE_NAME_HEAL_WIS                 = "Heal_WIS";

const string PAT_ROLE_NAME_SUPPORT                  = "Support";
const string PAT_ROLE_NAME_SUPPORT_INT              = "Support_INT";
const string PAT_ROLE_NAME_SUPPORT_WIS              = "Support_WIS";
const string PAT_ROLE_NAME_SUPPORT_CHA              = "Support_CHA";

const string PAT_ROLE_NAME_TANK                     = "Tank";
const string PAT_ROLE_NAME_TANK_STR                 = "Tank_STR";

const string PAT_ROLE_NAME_NAKED                    = "Naked";
const string PAT_ROLE_NAME_NAKED_DPS                = "Naked_DPS";
const string PAT_ROLE_NAME_NAKED_DPS_STR            = "Naked_DPS_STR";
const string PAT_ROLE_NAME_NAKED_DPS_DEX            = "Naked_DPS_DEX";

const string PAT_ROLE_NAME_NAKED_TANK               = "Naked_DPS_STR";
const string PAT_ROLE_NAME_NAKED_TANK_STR           = "Naked_DPS_DEX";

/*******************************************************************************
 * Skillset / Feat Pack Configuration
 *
 * In this section you can configure constants for Skillsets and Feat Packs to
 * make referencing them easier / consistent
 ******************************************************************************/

// Skill Sets
const int PAT_SKILLSET_DPS_MELEE_GENERIC            = 1;
const int PAT_SKILLSET_DPS_RANGE_GENERIC            = 2;
const int PAT_SKILLSET_DPS_CASTER_GENERIC           = 3;
const int PAT_SKILLSET_HEAL_GENERIC                 = 4;
const int PAT_SKILLSET_SUPPORT_GENERIC              = 5;
const int PAT_SKILLSET_TANK_GENERIC                 = 6;
const int PAT_SKILLSET_ROGUE                        = 7;

// Feat Packs
const int PAT_FEATPACK_CLASS_ARCANE_ARCHER          = 1;
const int PAT_FEATPACK_CLASS_ASSASSIN               = 2;
const int PAT_FEATPACK_CLASS_BARBARIAN              = 3;
const int PAT_FEATPACK_CLASS_BARD                   = 4;
const int PAT_FEATPACK_CLASS_BLACKGUARD             = 5;
const int PAT_FEATPACK_CLASS_CLERIC                 = 6;
const int PAT_FEATPACK_CLASS_DIVINE_CHAMPION        = 7;
const int PAT_FEATPACK_CLASS_DRAGON_DISCIPLE        = 8;
const int PAT_FEATPACK_CLASS_DRUID                  = 9;
const int PAT_FEATPACK_CLASS_DWARVEN_DEFENDER       = 10;
const int PAT_FEATPACK_CLASS_FIGHTER                = 11;
const int PAT_FEATPACK_CLASS_HARPER                 = 12;
const int PAT_FEATPACK_CLASS_MONK                   = 13;
const int PAT_FEATPACK_CLASS_PALADIN                = 14;
const int PAT_FEATPACK_CLASS_PALE_MASTER            = 15;
const int PAT_FEATPACK_CLASS_PURPLE_DRAGON_KNIGHT   = 16;
const int PAT_FEATPACK_CLASS_RANGER                 = 17;
const int PAT_FEATPACK_CLASS_ROGUE                  = 18;
const int PAT_FEATPACK_CLASS_SHADOWDANCER           = 19;
const int PAT_FEATPACK_CLASS_SHIFTER                = 20;
const int PAT_FEATPACK_CLASS_SORCERER               = 21;
const int PAT_FEATPACK_CLASS_WEAPON_MASTER          = 22;
const int PAT_FEATPACK_CLASS_WIZARD                 = 23;

const int PAT_FEATPACK_NAKED_DPS                    = 100;
const int PAT_FEATPACK_NAKED_TANK                   = 101;

/*******************************************************************************
 * Spell Configuration
 *
 * Known Spell count / level
 ******************************************************************************/
const int PAT_SPELL_KNOWNSPELLS                     = 3;

/*******************************************************************************
 * Spell Configuration
 *
 * Internal Section - Spell sources, categories and target types
 ******************************************************************************/
// Spell Sources
const int PAT_SPELL_SOURCE_NONE                     = 0;
const int PAT_SPELL_SOURCE_ARCANE_BARD              = 1;
const int PAT_SPELL_SOURCE_ARCANE_WIZ_SORC          = 2;
const int PAT_SPELL_SOURCE_DIVINE_CLERIC            = 3;
const int PAT_SPELL_SOURCE_DIVINE_DRUID             = 4;
const int PAT_SPELL_SOURCE_DIVINE_PALADIN           = 5;
const int PAT_SPELL_SOURCE_DIVINE_RANGER            = 6;

// Spell Categories
const int PAT_SPELL_CATEGORY_NONE                   = 0;
const int PAT_SPELL_CATEGORY_DAMAGE                 = 1;
const int PAT_SPELL_CATEGORY_HEAL                   = 2;
const int PAT_SPELL_CATEGORY_BUFF                   = 4;
const int PAT_SPELL_CATEGORY_DEBUFF                 = 8;
const int PAT_SPELL_CATEGORY_SUMMON                 = 16;
const int PAT_SPELL_CATEGORY_DISPEL                 = 32;
const int PAT_SPELL_CATEGORY_ALL                    = 63;

// Spell Targets
const int PAT_SPELL_TARGET_UNKNOWN                  = 0;
const int PAT_SPELL_TARGET_SELF                     = 1;
const int PAT_SPELL_TARGET_SINGLE                   = 2;
const int PAT_SPELl_TARGET_AOE                      = 3;

/*******************************************************************************
 * Variable / Database Configuration
 *
 * Do not touch unless you know what you're doing
 ******************************************************************************/

// Cache Object Reference
// You need to place an object with the set Tag somewhere in the module for the
// Cache to work
const string PAT_CACHE                              = "PAT_Cache";

// Local Variable Names
const string PAT_VAR_CR                             = "PAT_CR";
const string PAT_VAR_CR_DB                          = "PAT_CR_DB";
const string PAT_VAR_CR_MODIFIER                    = "PAT_Modifier";
const string PAT_VAR_ROLE_ID                        = "PAT_Role_ID";
const string PAT_VAR_ROLE_NAME                      = "PAT_Role_Name";
const string PAT_VAR_DISABLE                        = "PAT_Disable";
const string PAT_VAR_NAME_ELITE                     = "PAT_Name_Elite";
const string PAT_VAR_NAME_CHAMPION                  = "PAT_Name_Champion";

const string PAT_INITIALIZATION_BASE                = "PAT_Init_Base";

// PAT sets this to 1 if the creature was given the PAT Treatment
const string PAT_VAR_APPLIED                        = "PAT_Applied";

// Database Table Names
const string PAT_TABLE_BASE                         = "PAT_Base";
const string PAT_TABLE_CLASS_SETUP                  = "PAT_ClassSetup";
const string PAT_TABLE_SPELLS                       = "PAT_Spells";
const string PAT_TABLE_FEATS                        = "PAT_Feats";
const string PAT_TABLE_SKILLSETS                    = "PAT_Skillsets";
const string PAT_TABLE_AREAS                        = "PAT_Areas";

/*******************************************************************************
 * Struct Configuration
 *
 * This section is internal and shouldn't be modified
 ******************************************************************************/

// Structs
struct PAT_STRUCT_ROLE
{
   int Role_ID;
   string Role_Name;
   int CR;
   int Ability_STR;
   int Ability_DEX;
   int Ability_CON;
   int Ability_WIS;
   int Ability_INT;
   int Ability_CHA;
   int SavingThrow_Fortitude;
   int SavingThrow_Reflex;
   int SavingThrow_Will;
   int AC;
   int BaseAttackBonus;
   int BaseHitPoints;
};

struct PAT_STRUCT_CLASS_SETUP
{
    int Role_ID;
    int Class_1;
    int Class_2;
    int Class_3;
    int Spell_Source;
    int Spell_Category;
    int Feat_Pack;
    int Skillset;
};


struct PAT_STRUCT_SPELL
{
    int Spell_ID;
    int Spell_Level;
    int Source;
    int Category;
    int Target;
    int CR_Minimum;
};

struct PAT_STRUCT_FEAT
{
    int Feat_ID;
    string Packs;
    int Chance_Base;
    int Chance_Modifier;
    int CR_Minimum;
    int CR_Maximum;
};

struct PAT_STRUCT_SKILLSET
{
    int ID;
    string Skills_Extreme;
    string Skills_High;
    string Skills_Medium;
    string Skills_Low;
};
