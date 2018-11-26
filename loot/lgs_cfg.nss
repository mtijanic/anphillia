///////////////////////////////////////////////////////////////////////////////
// lgs_cfg
// written by: eyesolated
// written at: July 5, 2004
//
// Notes: Configuration File for the Loot Generation System, responsible
//        for outfitting monsters and generating loot
const string CS_LGS_FIXEDLOOT_WAYPOINT          = "WP_LGS_FL";
const string CS_LGS_FIXEDLOOT_ITEMCOUNT         = "LGS_ICnt";
const string CS_LGS_FIXEDLOOT_ARRAY             = "LGS_Arr";
const int CS_LGS_FIXEDLOOT_COUNT_DEFAULT        = 2;

// Set the following variable on a monster to the tag of a Chest in LGS Loot Chest
// area to make the monster use that chest for fetching it's loot
const string CS_LGS_VAR_CUSTOMLOOT_CHEST        = "lgs_customchest_tag";

// The chance to actually pull from the customloot instead of randomly generating
// If there is a custom chest tag and no chance set, chance will be CI_LGS_VAR_CUSTOMLOOT_CHANCE_DEFAULT
const string CS_LGS_VAR_CUSTOMLOOT_CHANCE       = "lgs_customchest_chance";
const int CI_LGS_VAR_CUSTOMLOOT_CHANCE_DEFAULT  = 5;

// Allow bashing of loot chests to open locks
const int CI_LGS_CHESTS_ALLOW_BASH              = TRUE;

// Defines the FixedLoot Randomizer, which is always +/- the value.
// When the loot count is 2, and the randomizer is 1, then the loot count will be
// 1-3
const int CS_LGS_FIXEDLOOT_COUNT_RANDOM         = 0;

const int CI_LGS_DROPEQUIPMENT = FALSE;

const int CI_LGS_CHANCE_LOW = 1;
const int CI_LGS_CHANCE_MEDIUM = 2;
const int CI_LGS_CHANCE_HIGH = 3;
const int CI_LGS_CHANCE_VERYHIGH = 4;

// Monsters with a CR below CI_LGS_CR_BOOST_UNTIL will get CI_LGS_CR_BOOST_VALUE
// added to their CR for magical loot calculations
const int CI_LGS_CR_BOOST_UNTIL = 6;
const int CI_LGS_CR_BOOST_VALUE = 2;

// Chance of a created equipment item being magical in %
// The actual chance is this value + 1 * Creature Difficulty
const int CI_LGS_CHANCE_MAGICAL_EQ = 15;

// Loot Chances
// CI_LGS_CHANCE_LOOT sets the chance of the creature dropping anything at all
// If the creature fails this check, all following checks are omitted and the
// creature won't drop anything at all
const int CI_LGS_CHANCE_LOOT = 30;                  // Sets the chance of getting Loot
const int CI_LGS_CHANCE_LOOT_IDENTIFIED = 100;      // Sets the chance of a magical loot item being identified

// Chance of Getting Gold
// The actual chance is this value + 1 * Creature Difficulty
const int CI_LGS_CHANCE_GOLD = 75;                  // Sets the chance of getting Gold via LGS if loot is to be dropped

// Chance of a created loot item being magical in %, which will be modified
// by the creature difficulty -> CI_LGS_CHANCE_MAGICAL_LOOT_BASE + (Difficulty * CI_LGS_CHANCE_MAGICAL_LOOT_MODIFIER)
// Example: BASE =  5, Modifier = 0.5, CR = 10 --> 10%
//          BASE = 10, Modifier = 2.0, CR = 10 --> 20%
const int CI_LGS_CHANCE_MAGICAL_LOOT_BASE = 100;
const float CF_LGS_CHANCE_MAGICAL_LOOT_MODIFIER = 0.0f;

// Chance of a monster that goes melee to get a second weapon to go dual-wielding
const int CI_LGS_CHANCE_DUALWIELD = 5;

// Equipment chances
// Equipment chances are calculated the following way:
//
// Creature Difficulty (or CR if Difficulty is not set) * Chance + (Chance * 20) = Actual Chance
//
// Preset Values are: CI_LGS_CHANCE_LOW      (CR * 1 + 20)
//                    CI_LGS_CHANCE_MEDIUM   (CR * 2 + 40)
//                    CI_LGS_CHANCE_HIGH     (CR * 3 + 60)
//                    CI_LGS_CHANCE_VERYHIGH (CR * 4 + 80)
//
// VERYHIGH means that only creatures of really low level have a chance of
// not getting an item.
const int CI_LGS_CHANCE_BODYARMOR = CI_LGS_CHANCE_MEDIUM;
const int CI_LGS_CHANCE_HELMET = CI_LGS_CHANCE_MEDIUM;
const int CI_LGS_CHANCE_SHIELD = CI_LGS_CHANCE_MEDIUM;
const int CI_LGS_CHANCE_WEAPON = CI_LGS_CHANCE_HIGH;
const int CI_LGS_CHANCE_RANGEDRESERVE = CI_LGS_CHANCE_LOW;
const int CI_LGS_CHANCE_AMULET = CI_LGS_CHANCE_MEDIUM;
const int CI_LGS_CHANCE_RING = CI_LGS_CHANCE_MEDIUM;
const int CI_LGS_CHANCE_BELT = CI_LGS_CHANCE_MEDIUM;
const int CI_LGS_CHANCE_BRACERS_OR_GLOVES = CI_LGS_CHANCE_MEDIUM;
const int CI_LGS_CHANCE_CLOAK = CI_LGS_CHANCE_MEDIUM;
const int CI_LGS_CHANCE_BOOTS = CI_LGS_CHANCE_MEDIUM;

// Loot Type relative Chances
const int CI_LGS_LOOT_CLOTHING = 25; // 2.5%
const int CI_LGS_LOOT_ARMOR_LIGHT = 20; // 2%
const int CI_LGS_LOOT_ARMOR_MEDIUM = 15; // 1.5%
const int CI_LGS_LOOT_ARMOR_HEAVY = 15; // 1.5%
const int CI_LGS_LOOT_SHIELD_SMALL = 10; // 1%
const int CI_LGS_LOOT_SHIELD_LARGE = 10; // 1%
const int CI_LGS_LOOT_SHIELD_TOWER = 10; // 1%
const int CI_LGS_LOOT_HELMET = 50; // 5%
const int CI_LGS_LOOT_WEAPON_MELEE = 25; // 2.5%
const int CI_LGS_LOOT_WEAPON_RANGED = 20; // 2%
const int CI_LGS_LOOT_WEAPON_THROWN = 15; // 1.5%
const int CI_LGS_LOOT_AMMO = 40; // 4%
const int CI_LGS_LOOT_JEWELRY_RING = 30; // 3%
const int CI_LGS_LOOT_JEWELRY_AMULET = 20; // 2%
const int CI_LGS_LOOT_ACCESSORY_BRACERS = 50; // 5%
const int CI_LGS_LOOT_ACCESSORY_GLOVES = 50; // 5%
const int CI_LGS_LOOT_ACCESSORY_BELT = 50; // 5%
const int CI_LGS_LOOT_ACCESSORY_CLOAK = 50; // 5%
const int CI_LGS_LOOT_ACCESSORY_BOOTS = 50; // 5%
const int CI_LGS_LOOT_SCROLL = 75; // 7.5%
const int CI_LGS_LOOT_BOOK = 15; // 1.5%
const int CI_LGS_LOOT_POTION = 90; // 9%
const int CI_LGS_LOOT_WAND = 50; // 5%
const int CI_LGS_LOOT_MEDKIT = 70; // 7%
const int CI_LGS_LOOT_TRAPKIT = 15; // 1.5%
const int CI_LGS_LOOT_THIEVESTOOLS = 25; // 2.5%
const int CI_LGS_LOOT_CONTAINER = 20; // 2%
const int CI_LGS_LOOT_MISC = 10; // 1%
const int CI_LGS_LOOT_BOMB = 15; // 1.5%
const int CI_LGS_LOOT_FOOD = 60; // 6%

// CR Variable on Placeables
const string CS_LGS_PLACEABLE_CR        = "LGS_CR";

// Put this var on items where you want to have drop chance
const string CS_LGS_EQUIP_DROPCHANCE    = "LGS_DROPCHANCE";

// Set this var to 1 on Monsters you don't want to be equipped even if the
// Equip method is called
const string CS_LGS_EQUIP_DISABLE       = "LGS_NOEQUIP";

// Set this var to 1 on Items you don't want to be replaced even if the
// Equip method is called
const string CS_LGS_EQUIP_DONTREPLACE   = "LGS_NOREPLACE";

// Set this var to 1 on Monsters you don't want to drop loot even if the
// Drop Loot method is called
const string CS_LGS_LOOT_DISABLE        = "LGS_NOLOOT";

// LGS Chest Waypoint Blueprint
const string CS_LGS_CHEST_VAR_WAYPOINT  = "wp_lgs_chest";
const string CS_LGS_CHEST_VAR_RESREF    = "lgs_chest";

// Weight for items in the loot chest
// The item will be counted the entered number of times in comparison to
// other items.
const string CS_LGS_FIXEDLOOT_WEIGHT    = "lgs_weight";

// The time in seconds a chest has to be idle (nothing put in via script)
// before wiping contents, relocking, retrapping etc.
const float CS_LGS_CHEST_RESET_IDLE     = 300.0f;

// Chest check interval in seconds
const float CS_LGS_CHEST_CHECK_INTERVAL = 60.0f;

// Variable for counting on Chests
const string CS_LGS_CHEST_CHECK_ISCHECKING  = "LGS_Chest_IsChckn";
const string CS_LGS_CHEST_CHECK_COUNT       = "LGS_Chest_ChCount";

// Variables for setting up Chests
const string CS_LGS_CHEST_VAR_LOCKCHANCE    = "lgs_LockChance";
const string CS_LGS_CHEST_VAR_LOCKDC        = "lgs_LockDC";
const string CS_LGS_CHEST_VAR_TRAPCHANCE    = "lgs_TrapChance";
const string CS_LGS_CHEST_VAR_TRAPSTRENGTH  = "lgs_TrapStrength";
const string CS_LGS_CHEST_VAR_TRAPDETECTDC  = "lgs_TrapDetectDC";
const string CS_LGS_CHEST_VAR_TRAPDISARMDC  = "lgs_TrapDisarmDC";
const string CS_LGS_CHEST_VAR_HITPOINTS     = "lgs_HitPoints";

// Drop on Self
const string CS_LGS_DROPONSELF_TAGS         = "NW_IT_MSMLMISC13;NW_IT_MSMLMISC08;";     // Skeleton Knuckles; Fire Beetle Belly;
const string CS_LGS_DROPONSELF_TAGS_WILD    = "x2_it_poison0*;";                        // All Poisons added in x2
const string CS_LGS_VAR_DROPONSELF          = "lgs_DropOnSelf";

const int CI_LGS_CHEST_DEFAULT_LOCKCHANCE   = 90;
const int CI_LGS_CHEST_DEFAULT_LOCKDC       = 25;
const int CI_LGS_CHEST_DEFAULT_TRAPCHANCE   = 66;
const int CI_LGS_CHEST_DEFAULT_TRAPSTRENGTH = 1;
const int CI_LGS_CHEST_DEFAULT_TRAPDETECTDC = 25;
const int CI_LGS_CHEST_DEFAULT_TRAPDISARMDC = 25;
