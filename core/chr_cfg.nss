///////////////////////////////////////////////////////////////////////////////
// chr_cfg
// written by: eyesolated
// written at: April 13, 2018
//
// Notes: Configuration Script for XP related stuff

/////////////////////
// Drop Configuration
/////////////////////

// Defines the maximum amount of gold to drop in a backpack, surplus is destroyed
const int CHR_DROP_GOLDMAXIMUM                          = 30000;

// Define if inventory items should drop
const int CHR_DROP_ITEMS                                = TRUE; // Filter on which items in chr_inc

// Only Items with the following Variable set to 1 will be dropped
const string CHR_DROP_VARIABLE                          = "DropOnDying";

////////////////////////
// OnDying Configuration
////////////////////////

// The base chance to recover
const int CHR_RECOVERY_CHANCE_BASE                      = 5;

// Enable Constitution Bonus extending OnDying beyond -10
// This works only if the base game is changed via NWNX!!!
const int CHR_DEATH_CONSTITUTION_BONUS_ENABLED          = FALSE;

// The multiplier for CON Ability Bonus that is added to the base Chance
// If this is 2 and CON Bonus is 3, the resuling modifier = +6
const int CHR_RECOVERY_CHANCE_MODIFIER_CONSTITUTION     = 1;

const float CHR_BLEED_INTERVAL                          = 12.0f;

const string CHR_RECOVERY_MESSAGE                       = "You have recovered from your wounds.";
const string CHR_DYING_MESSAGE                          = "You slip closer to death...";

//////////////////////////////
// Rest Surprise Configuration
//////////////////////////////

const int CHR_REST_SURPRISE_CHANCE                      = 66;                   // Chance to be surprised - set to 0 to deactivate
const int CHR_REST_SURPRISE_MONSTERS_MAX                = 3;
const int CHR_REST_SURPRISE_GUARDS_NEEDED               = 1;

const int CHR_REST_INTERVAL_HOURS                       = 6;

////////////////////////////////////
// Internal Constants, do not touch!
////////////////////////////////////
const string CHR_AFK_VAR_STATUS                         = "chr_AFK";
const string CHR_AFK_VAR_PLACEABLE                      = "chr_AFKPlac";
const string CHR_AFK_EFFECTTAG                          = "chr_Effect";

const string CHR_ROLL_VAR_CURRENTLYCHECKING             = "chr_CheckActive";

const string CS_ROLLS_VAR_PRIVACY                       = "chr_RollPrivacy";
const int CHR_ROLL_PRIVACY_PUBLIC                       = 0;
const int CHR_ROLL_PRIVACY_PRIVATE                      = 1;

const string CHR_NEARDEATH_VAR_MESSAGE                  = "chr_ndmessage";
const string CHR_NEARDEATH_MESSAGE                      = "You are near death and cannot run.";

const string CHR_REST_VAR_NEARBYHEALER                  = "chr_Rest_NearbyHealer";
const string CHR_REST_VAR_HITPOINTS_BEFORE_REST         = "chr_Rest_HPBeforeRest";
const string CHR_REST_VAR_REST_CANCELLED_BY_SCRIPT      = "chr_Rest_CancelledScript";
const string CHR_REST_VAR_REST_TIME                     = "chr_Rest_Time";
const string CHR_REST_VAR_REST_YEAR                     = "chr_Rest_Year";
const string CHR_REST_VAR_REST_MONTH                    = "chr_Rest_Month";
const string CHR_REST_VAR_REST_DAY                      = "chr_Rest_Day";
const string CHR_REST_VAR_REST_HOUR                     = "chr_Rest_Hour";
const string CHR_REST_VAR_FOOD_TAG                      = "chr_Rest_FoodEaten";
const string CHR_REST_VAR_FOOD_QUEUE                    = "chr_Rest_FoodQueue";

const string CHR_PCITEM_RESREF                          = "pc_actionwand";
const string CHR_PCITEM_TAG                             = "pc_actionwand";

///////////////////////////
// Chat related config
///////////////////////////

// How many last messages to track
const int CHR_CHAT_MESSAGE_BUFFER_SIZE = 10;
