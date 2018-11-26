///////////////////////////////////////////////////////////////////////////////
// store_cfg
// written by: eyesolated
// written at: Sept. 22, 2004
//
// Notes: Store Configuration

// Constants
const string CS_STORE_SYSTEMREADY = "STORE_READY";
const string CS_STORE_SCRIPT_OPEN = "store_open";

const string CS_STORE_DEFAULTHEARTBEATSCRIPT = "nw_c2_default1";
const string CS_STORE_INITIALIZED = "StoreInitialized";
const string CS_STORE_NEEDSRESET = "StoreNeedsReset";
const string CS_STORE_CATNEEDSRESET = "CAT_";
const string CS_STORE_ITEMAMOUNT = "StoreItemAmount";

// Store reset time in Heartbeats (= 6 seconds)
const int CS_STORE_RESETTIME = 600; // 1 hour = 600 heartbeats

//Store Variables

// What kinds of stuff does this store sell?
// The value of these INTEGER values sets the Maximum of items available
// for this category. If set to 0, the store won't have these items, and items
// from this category that are sold to the store will disappear.
//
// SH_Everything gets added to EACH category.
const string CS_STORE_StoreHas_EVERYTHING = "SH_EVERYTHING";
const string CS_STORE_StoreHas_ARMOR_BODY_CLOTHING = "SH_ARMOR_CLOTHING";
const string CS_STORE_StoreHas_ARMOR_BODY_LIGHT = "SH_ARMOR_LIGHT";
const string CS_STORE_StoreHas_ARMOR_BODY_MEDIUM = "SH_ARMOR_MEDIUM";
const string CS_STORE_StoreHas_ARMOR_BODY_HEAVY = "SH_ARMOR_HEAVY";
const string CS_STORE_StoreHas_ARMOR_SHIELD = "SH_ARMOR_SHIELD";
const string CS_STORE_StoreHas_ARMOR_HELMET = "SH_ARMOR_HELMET";
const string CS_STORE_StoreHas_WEAPON_MELEE = "SH_WEAPON_MELEE";
const string CS_STORE_StoreHas_WEAPON_RANGED = "SH_WEAPON_RANGED";
const string CS_STORE_StoreHas_WEAPON_THROWN = "SH_WEAPON_THROWN";
const string CS_STORE_StoreHas_AMMO = "SH_AMMO";
const string CS_STORE_StoreHas_ACCESSORIES_CLOTHING = "SH_ACC_CLOTHING";
const string CS_STORE_StoreHas_ACCESSORIES_JEWELRY = "SH_ACC_JEWELRY";
const string CS_STORE_StoreHas_RODSWANDS = "SH_RODSWANDS";
const string CS_STORE_StoreHas_SCROLLS = "SH_SCROLLS";
const string CS_STORE_StoreHas_POTIONS = "SH_POTIONS";
const string CS_STORE_StoreHas_CONTAINERS = "SH_CONTAINERS";
const string CS_STORE_StoreHas_BOMBS = "SH_BOMBS";
const string CS_STORE_StoreHas_THIEVESTOOLS = "SH_THIEVESTOOLS";
const string CS_STORE_StoreHas_TRAPS = "SH_TRAPS";
const string CS_STORE_StoreHas_MEDKITS = "SH_MEDKITS";
const string CS_STORE_StoreHas_MISC = "SH_MISC";

// Suffix for counting the current amount
const string CS_STORE_AMOUNTSUFFIX = "_CA";

// How many items does the store have MINIMUM per category?
// The value of this variable sets the DIVISOR by which the above maximums are
// divided to see what the minimum is.
// Example: If a store has a maximum of 12 Melee Weapons, and this divisor is
//          set to 3, the store will always carry a minimum of 4 Melee Weapons.
//          If it was set to 2, the store would always have at least 6 Melee
//          Weapons.
const string CS_STORE_StoreHasMinimum = "SHMinimum";

// The Chance of Magic Items for this store
const string CS_STORE_MAGICCHANCE = "S_MAGICCHANCE";

// The Maximum Magic Level for this store
const string CS_STORE_MAGICLEVEL = "S_MAGICLEVEL";

// Chance that these Magic items are identified
const string CS_STORE_IDENTIFIEDCHANCE = "S_IDENTIFIEDCHANCE";
