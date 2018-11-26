///////////////////////////////////////////////////////////////////////////////
// egs_cfg
// written by: eyesolated
// written at: June 17, 2004
//
// Notes: The configuration file for the Equipment Generation System

// Use NWNX?
const int CI_EGS_USE_NWNX = TRUE;

const string CS_EGS_INI_USERDEFINEDEVENTNUMBER = "EGS_EVENTID";
const string CS_EGS_TABLE = "egs";

// Without NWNx, we have to use a different Method
const string CS_EGS_DB_AREA = "A_EGS";
const string CS_EGS_DB_WAYPOINT = "WP_EGS";
const string CS_EGS_DB_MERCHANT_RESREF = "M_EGS";
const string CS_EGS_DB_MERCHANT_NEWTAG = "M_EGS";
const string CS_EGS_ARRAY_UNFILTERED = "EGS_A_UF";
const string CS_EGS_ARRAY_CATEGORY_MAIN = "EGS_MC";
const string CS_EGS_ARRAY_CATEGORY_SUB = "EGS_SC";
const string CS_EGS_ARRAY_BASEITEM = "EGS_BI";

// Standard Variable Names for Equipment Properties
const string CS_EGS_ITEMTAG = "Tag";
const string CS_EGS_CATEGORY_MAIN = "MainCategory";
const string CS_EGS_CATEGORY_SUB = "SubCategory";
const string CS_EGS_BASEITEM = "BaseItem";
const string CS_EGS_BASEVALUE = "BaseValue";
const string CS_EGS_BPCOUNT = "BlueprintCount";
const string CS_EGS_WEAPONSIZE = "WeaponSize";

// Main Item Categories
const int CI_EGS_ITEM_UNDEFINED = 99;

const int CI_EGS_ITEM_MAIN_ARMOR                    = 1;
const int CI_EGS_ITEM_MAIN_WEAPON                   = 2;
const int CI_EGS_ITEM_MAIN_AMMO                     = 3;
const int CI_EGS_ITEM_MAIN_ACCESSORY                = 4;
const int CI_EGS_ITEM_MAIN_MISC                     = 5;
const int CI_EGS_ITEM_MAIN_BOMB                     = 6;
const int CI_EGS_ITEM_MAIN_RODWAND                  = 7;
const int CI_EGS_ITEM_MAIN_CONTAINER                = 8;
const int CI_EGS_ITEM_MAIN_MONSTERRING              = 9;
const int CI_EGS_ITEM_MAIN_FOOD                     = 10;
const int CI_EGS_ITEM_MAIN_ARMOR_CREATURE           = 11;
const int CI_EGS_ITEM_MAIN_WEAPON_CREATURE          = 12;

// Item SubCategories
const int CI_EGS_ITEM_SUB_ARMOR_BODY_CLOTHING       = 1;
const int CI_EGS_ITEM_SUB_ARMOR_BODY_LIGHT          = 2;
const int CI_EGS_ITEM_SUB_ARMOR_BODY_MEDIUM         = 3;
const int CI_EGS_ITEM_SUB_ARMOR_BODY_HEAVY          = 4;
const int CI_EGS_ITEM_SUB_ARMOR_SHIELD              = 5;
const int CI_EGS_ITEM_SUB_ARMOR_HELMET              = 6;

const int CI_EGS_ITEM_SUB_WEAPON_MELEE              = 7;
const int CI_EGS_ITEM_SUB_WEAPON_RANGED             = 8;
const int CI_EGS_ITEM_SUB_WEAPON_THROWN             = 9;
const int CI_EGS_ITEM_SUB_WEAPON_STAFF              = 10;     // Special category for Staves

const int CI_EGS_ITEM_SUB_ACCESSORY_JEWELRY         = 11;
const int CI_EGS_ITEM_SUB_ACCESSORY_CLOTHING        = 12;

// Item Information Structure
struct STRUCT_EGS_ITEMINFO
{
   int MainCategory;
   int SubCategory;
   int BaseItem;
   int BaseValue;
};

// Weapon Sizes
const int CI_EGS_WEAPONSIZE_UNDEFINED = 0;
const int CI_EGS_WEAPONSIZE_TINY = 1;
const int CI_EGS_WEAPONSIZE_SMALL = 2;
const int CI_EGS_WEAPONSIZE_MEDIUM = 3;
const int CI_EGS_WEAPONSIZE_LARGE = 4;

/* These are the corresponding Bioware Creature Size Constants
int CREATURE_SIZE_INVALID = 0;
int CREATURE_SIZE_TINY =    1;
int CREATURE_SIZE_SMALL =   2;
int CREATURE_SIZE_MEDIUM =  3;
int CREATURE_SIZE_LARGE =   4;
int CREATURE_SIZE_HUGE =    5;
*/

// Ring of Xtra Difficulty
const string CS_EGS_BP_MONSTERRING                  = "i_egs_moring";

// Armor - Clothing
const string CS_EGS_BP_TUNIC                        = "i_egs_tunic";
const string CS_EGS_BP_ROBE                         = "i_egs_robe";

// Armor - Creature
const string CS_EGS_BP_CREATURE_ARMOR               = "i_egs_carmor";

// Armor - Light Armor
const string CS_EGS_BP_LEATHERARMOR                 = "i_egs_larmor";
const string CS_EGS_BP_PADDEDARMOR                  = "i_egs_parmor";
const string CS_EGS_BP_STUDDEDLEATHER               = "i_egs_slarmor";
const string CS_EGS_BP_CHAINSHIRT                   = "i_egs_cshirt";

// Armor - Medium Armor
const string CS_EGS_BP_HIDEARMOR                    = "i_egs_harmor";
const string CS_EGS_BP_CHAINMAIL                    = "i_egs_cmail";
const string CS_EGS_BP_SCALEMAIL                    = "i_egs_scmail";
const string CS_EGS_BP_BREASTPLATE                  = "i_egs_bplate";

// Armor - Heavy Armor
const string CS_EGS_BP_BANDEDMAIL                   = "i_egs_bmail";
const string CS_EGS_BP_SPLINTMAIL                   = "i_egs_spmail";
const string CS_EGS_BP_HALFPLATE                    = "i_egs_hplate";
const string CS_EGS_BP_FULLPLATE                    = "i_egs_fplate";

// Armor - Helmets
const string CS_EGS_BP_HELMET                       = "i_egs_helm";

// Armor - Shields
const string CS_EGS_BP_SHIELDSMALL                  = "i_egs_sshield";
const string CS_EGS_BP_SHIELDLARGE                  = "i_egs_lshield";
const string CS_EGS_BP_SHIELDTOWER                  = "i_egs_tshield";

// Miscellaneous - Clothing
const string CS_EGS_BP_BELT                         = "i_egs_belt";
const string CS_EGS_BP_BOOTS                        = "i_egs_boots";
const string CS_EGS_BP_BRACERS                      = "i_egs_bracers";
const string CS_EGS_BP_BRACERSSHIELD                = "i_egs_bracshld";
const string CS_EGS_BP_CLOAK                        = "i_egs_cloak";
const string CS_EGS_BP_GLOVES                       = "i_egs_gloves";

// Miscellaneous - Jewelry
const string CS_EGS_BP_AMULET                       = "i_egs_amulet";
const string CS_EGS_BP_RING                         = "i_egs_ring";

// Miscellaneous - Scrolls
const string CS_EGS_BP_SCROLL                       = "i_egs_scroll";

// Weapons - Ammunition
const string CS_EGS_BP_ARROW                        = "i_egs_arrow";
const string CS_EGS_BP_BOLT                         = "i_egs_bolt";
const string CS_EGS_BP_BULLET                       = "i_egs_bullet";

// Weapons - Axes - Great
const string CS_EGS_BP_GREATAXE                     = "i_egs_graxe";

// Weapons - Axes - One Handed
const string CS_EGS_BP_HANDAXE                      = "i_egs_haxe";
const string CS_EGS_BP_DWARVENWARAXE                = "i_egs_dwaxe";

// Weapons - Axes - Two Handed
const string CS_EGS_BP_BATTLEAXE                    = "i_egs_baxe";

// Weapons - Bladed
const string CS_EGS_BP_BASTARDSWORD                 = "i_egs_basword";
const string CS_EGS_BP_DAGGER                       = "i_egs_dagger";
const string CS_EGS_BP_GREATSWORD                   = "i_egs_gsword";
const string CS_EGS_BP_LONGSWORD                    = "i_egs_lsword";
const string CS_EGS_BP_KATANA                       = "i_egs_katana";
const string CS_EGS_BP_RAPIER                       = "i_egs_rapier";
const string CS_EGS_BP_SCIMITAR                     = "i_egs_scimitar";
const string CS_EGS_BP_SHORTSWORD                   = "i_egs_ssword";

// Weapons - Blunts
const string CS_EGS_BP_CLUB                         = "i_egs_club";
const string CS_EGS_BP_LIGHTFLAIL                   = "i_egs_lflail";
const string CS_EGS_BP_HEAVYFLAIL                   = "i_egs_hflail";
const string CS_EGS_BP_LIGHTHAMMER                  = "i_egs_lhammer";
const string CS_EGS_BP_WARHAMMER                    = "i_egs_whammer";
const string CS_EGS_BP_MACE                         = "i_egs_mace";
const string CS_EGS_BP_MORNINGSTAR                  = "i_egs_mstar";

// Weapons - Creature
const string CS_EGS_BP_CREATURE_WEAPON_BLUDGEON     = "i_egs_cweapb";
const string CS_EGS_BP_CREATURE_WEAPON_PIERCE       = "i_egs_cweapp";
const string CS_EGS_BP_CREATURE_WEAPON_SLASH        = "i_egs_cweaps";
const string CS_EGS_BP_CREATURE_WEAPON_SLASHPIERCE  = "i_egs_cweasp";

// Weapons - Double-Sided
const string CS_EGS_BP_DIREMACE                     = "i_egs_dmace";
const string CS_EGS_BP_DOUBLEAXE                    = "i_egs_dblaxe";
const string CS_EGS_BP_QUARTERSTAFF                 = "i_egs_qstaff";
const string CS_EGS_BP_TWOBLADEDSWORD               = "i_egs_tbsword";

// Weapons - Exotic
const string CS_EGS_BP_KAMA                         = "i_egs_kama";
const string CS_EGS_BP_KUKRI                        = "i_egs_kukri";
const string CS_EGS_BP_SICKLE                       = "i_egs_sickle";
const string CS_EGS_BP_WHIP                         = "i_egs_whip";

// Weapons - Polearms
const string CS_EGS_BP_HALBERD                      = "i_egs_halberd";
const string CS_EGS_BP_SCYTHE                       = "i_egs_scythe";
const string CS_EGS_BP_SPEAR                        = "i_egs_spear";

// Weapons - Ranged
const string CS_EGS_BP_LIGHTCROSSBOW                = "i_egs_lcbow";
const string CS_EGS_BP_HEAVYCROSSBOW                = "i_egs_hcbow";
const string CS_EGS_BP_LONGBOW                      = "i_egs_lbow";
const string CS_EGS_BP_SHORTBOW                     = "i_egs_sbow";
const string CS_EGS_BP_SLING                        = "i_egs_sling";

// Weapons - Throwing
const string CS_EGS_BP_DART                         = "i_egs_dart";
const string CS_EGS_BP_SHURIKEN                     = "i_egs_shuriken";
const string CS_EGS_BP_THROWINGAXE                  = "i_egs_thaxe";

// Weapons - Bombs/Flasks
const string CS_EGS_BP_ACIDFLASK                    = "i_egs_acflask";
const string CS_EGS_BP_ALCHEMISTSFIRE               = "i_egs_alchfire";
const string CS_EGS_BP_CALTROPS                     = "i_egs_caltrops";
const string CS_EGS_BP_CHOKINGPOWDER                = "i_egs_chpowder";
const string CS_EGS_BP_HOLYWATER                    = "i_egs_hwater";
const string CS_EGS_BP_TANGLEFOOTBAG                = "i_egs_tfootbag";
const string CS_EGS_BP_THUNDERSTONE                 = "i_egs_thstone";

// Mage Specific
const string CS_EGS_BP_ROD                          = "i_egs_rod";
const string CS_EGS_BP_STAFF                        = "i_egs_staff";
const string CS_EGS_BP_WAND                         = "i_egs_wand";

// Misc. Items
const string CS_EGS_BP_TORCH                        = "i_egs_torch";
const string CS_EGS_BP_THIEVESTOOLS                 = "i_egs_thietool";
const string CS_EGS_BP_POTION                       = "i_egs_potion";
const string CS_EGS_BP_LARGEBOX                     = "i_egs_lbox";
const string CS_EGS_BP_BAG                          = "i_egs_bag";
const string CS_EGS_BP_SMALLBOX                     = "i_egs_sbox";
const string CS_EGS_BP_SMALLBAG                     = "i_egs_sbag";
const string CS_EGS_BP_GEM                          = "i_egs_gem";
const string CS_EGS_BP_BOOK                         = "i_egs_book";
const string CS_EGS_BP_TRAP                         = "i_egs_trap";
const string CS_EGS_BP_MEDKIT                       = "i_egs_medkit";

// CEP Weapons
const string CS_EGS_BP_ASSASSINDAGGER = "i_egs_assdag";   // Dagger
const string CS_EGS_BP_CHAKRAM = "i_egs_chakram";         // Throwing Axe - Ranged Weapon
const string CS_EGS_BP_DAIKYU = "i_egs_daikyu";           // Longbow
const string CS_EGS_BP_DOUBLESCIMITAR = "i_egs_dblscim";  // Double-Sided - Melee
const string CS_EGS_BP_FALCHION = "i_egs_falchion";       // Falchion - Sword
const string CS_EGS_BP_GOAD = "i_egs_goad";               // Exotic - Melee
const string CS_EGS_BP_HEAVYMACE = "i_egs_hvymace";       // Mace
const string CS_EGS_BP_HEAVYPICK = "i_egs_hvypick";       // Picks - Melee
const string CS_EGS_BP_KATAR = "i_egs_katar";             // Exotic - Melee
const string CS_EGS_BP_LIGHTPICK = "i_egs_ltpick";        // Picks - Melee
const string CS_EGS_BP_MAUL = "i_egs_maul";               // Hammer
const string CS_EGS_BP_NAGAMAKI = "i_egs_nagama";         // Polearm
const string CS_EGS_BP_NINJATO = "i_egs_ninja";           // Short Sword
const string CS_EGS_BP_NODACHI = "i_egs_nodach";          // Greatsword
const string CS_EGS_BP_NUNCHAKU = "i_egs_nunch";          // Exotic
const string CS_EGS_BP_SAI = "i_egs_sai";                 // Exotic - Melee
const string CS_EGS_BP_SAP = "i_egs_sap";                 // Exotic - Melee
const string CS_EGS_BP_TANTO = "i_egs_tanto";             // Dagger
const string CS_EGS_BP_TRIDENT = "i_egs_trident";         // Trident - Melee
const string CS_EGS_BP_WAKIZASHI = "i_egs_wakiz";         // Short Sword

// BASE_ITEM Constants for CEP Stuff
const int BASE_ITEM_ASSASSIN_DAGGER                 = 309;
const int BASE_ITEM_BRACER_SHIELD                   = 362;
const int BASE_ITEM_FALCHION                        = 305;
const int BASE_ITEM_GOAD                            = 322;
const int BASE_ITEM_KATAR                           = 310;
const int BASE_ITEM_MACE_HEAVY                      = 317;
const int BASE_ITEM_MAUL                            = 318;
const int BASE_ITEM_NUNCHAKU                        = 304;
const int BASE_ITEM_PICK_HEAVY                      = 301;
const int BASE_ITEM_PICK_LIGHT                      = 302;
const int BASE_ITEM_SAI                             = 303;
const int BASE_ITEM_SAP                             = 308;
const int BASE_ITEM_SCIMITAR_DOUBLE                 = 321;
const int BASE_ITEM_TRIDENT_1HAND                   = 300;

