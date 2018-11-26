/************************************************************************
 * script name  : enc_spiderqueen
 * created by   : eyesolated
 * date         : 2018/5/14
 *
 * description  : This script defines the Spider Queen encounter
 *
 * changes      : 2018/5/14 - eyesolated - Initial creation
 ************************************************************************/

// Includes
#include "ee_inc"

// Constants
const string ENCOUNTER_NAME             = "Spider Queen";
const string ENCOUNTER_TAG              = "ee_spiderqueen";
const float ENCOUNTER_DESPAWNINTERVAL   = 12.0f;
const float ENCOUNTER_RESPAWN           = 3600.0f;
const int ENCOUNTER_DEBUGLEVEL          = eE_MESSAGELEVEL_LOW;

const string EVENT_INITIALIZE           = "event_Initialize";
const string EVENT_INPROGRESS           = "event_InProgress";
const string EVENT_WEBBER_ATTACK        = "event_Webber";

const string WAYPOINT_ENCOUNTER         = "wp_ee_spiderqueen";
const string WAYPOINT_SPAWN_QUEEN       = "wp_spawn_queen";
const string WAYPOINT_SPAWN_WEBBER      = "wp_spawn_webber";

const string RESREF_BOSS                = "ee_sq_queen";
const string RESREF_WEBBER              = "ee_sq_webber";
const string RESREF_POISONWARNING       = "ee_sq_poiswarn";

const float QUEEN_FLEE_INITIALDELAY     = 18.0f;        // 24.0f seconds
const float QUEEN_FLEE_INTERVAL         = 42.0f;
const int QUEEN_FLEE_DURATION_ROUNDS    = 3;            // 18.0f seconds
const string QUEEN_FLEE_EFFECTTAG       = "sq_flee";

const int QUEEN_POISON_DAMAGE           = 9;
const int QUEEN_POISON_TICKS            = 9;
const float QUEEN_POISON_WARNING        = 2.75f;        // 2.75 seconds warning
const float QUEEN_POISON_DURATION       = 12.0f;        // Poison overlaps a bit

const int WEBBER_COUNT                  = -3;           // 1 / 3 players
const float WEBBER_SPAWN_INITIALDELAY   = 36.0f;        // First Webbers appear when queen is back
const float WEBBER_SPAWN_INTERVAL       = 42.0f;        // And every reappearance thereafter

void main()
{
    // Look for an existing encounter
    object oEncounter = GetObjectByTag(ENCOUNTER_TAG);

    // Create the encounter object
    if (!GetIsObjectValid(oEncounter))
    {
        // Create the encounter
        eE_CreateEncounter(ENCOUNTER_NAME, WAYPOINT_ENCOUNTER, ENCOUNTER_TAG, eE_VAR_CONDITION_NONE, ENCOUNTER_DESPAWNINTERVAL, EVENT_INITIALIZE, EVENT_INPROGRESS, ENCOUNTER_RESPAWN, ENCOUNTER_DEBUGLEVEL);

        // Spawn the Spider Queen
        eE_CreateEvent_Creature("SPAWN_SpiderQueen",            // Event Name
                                ENCOUNTER_TAG,                  // Encounter Tag
                                EVENT_INITIALIZE,               // Event Tag
                                eE_EVENTOWNER_NONE,             // Owner
                                RESREF_BOSS,                    // Blueprint ResRef
                                -1,                             // Quantity
                                0,                              // MaxConcurrent
                                WAYPOINT_SPAWN_QUEEN,           // Spawn Point
                                0.0f,                           // Spawn Delay
                                eE_SPAWNMETHOD_FIXED,           // Spawn Method
                                0,                              // Spawn Effect
                                RESREF_BOSS,                    // New Tag
                                "",                             // OnSpawn
                                "",                             // OnDamaged Event
                                "",                             // OnDeath
                                "",                             // OnExhaust
                                1);                             // Key Event

        // The spider queen leaves the battle and returns at a random players position shortly after
        eE_CreateEvent_Effect("JUMP_SpiderQueen",               // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_INPROGRESS,                 // Event Tag
                              RESREF_BOSS,                      // Owner
                              -1,                               // Quantity
                              0.0f,                             // Delay between Owners
                              RESREF_BOSS,                      // VFX_Target (no VFX for DisappearAppear)
                              eE_TARGETMETHOD_RANDOM,           // Target Method
                              DURATION_TYPE_TEMPORARY,          // Duration Type
                              QUEEN_FLEE_DURATION_ROUNDS * 6.0f,// Duration
                              eE_EFFECT_TYPE_DURATION,          // eE Effect Type
                              eE_EFFECT_EFFECT_DISAPPEARAPPEAR, // Effect
                              "",                               // Effect Variables
                              -1,                               // VFX (no VFX for DisappearAppear)
                              QUEEN_FLEE_EFFECTTAG,             // Effect Tag
                              QUEEN_FLEE_INITIALDELAY,          // Initial Delay
                              QUEEN_FLEE_INTERVAL,              // Interval
                              0,                                // Max Repeats
                              eE_UNDO_MANUAL);                  // Undo Mode

        // While the queen is gone to the ceiling, she sprays poison on one player from above twice per round
        int nRound;
        for (nRound = 1; nRound < (QUEEN_FLEE_DURATION_ROUNDS * 2); nRound++)
        {
            eE_CreateEvent_Damage("POISON_Round_" + IntToString(nRound), // Event Name
                                  ENCOUNTER_TAG,                    // Encounter Tag
                                  EVENT_INPROGRESS,                 // Event Tag
                                  eE_EVENTOWNER_NONE,               // Owner
                                  1,                                // Quantity / Target Count
                                  eE_SPAWNTAG_PC,                   // Tag / Target
                                  eE_DAMAGE_OBJECTTYPE_PC,          // ObjectTypes
                                  eE_TARGETMETHOD_RANDOM,           // Target Method
                                  eE_OBJECTLOCATION_LOCATION,       // Target Type
                                  AOE_PER_FOGACID,                  // VFX
                                  "",                               // VFX Placeable
                                  QUEEN_POISON_DAMAGE,              // Damage Amount
                                  DAMAGE_TYPE_ACID,                 // Damage Type
                                  QUEEN_POISON_TICKS,               // Ticks
                                  QUEEN_POISON_DURATION,            // Damage Duration
                                  -1,                               // Warning VFX
                                  RESREF_POISONWARNING,             // Warning Placeable
                                  QUEEN_POISON_WARNING,             // Warning Delay
                                  SHAPE_SPHERE,                     // Shape Type
                                  RADIUS_SIZE_LARGE,                // Shape Size
                                  0.0f,                             // Safe Zone
                                  QUEEN_FLEE_INITIALDELAY + (3.0f * nRound), // Initial Delay
                                  QUEEN_FLEE_INTERVAL);             // Interval
        }

        // After returning to the ground, the queen will attack a random PC
        eE_CreateEvent_Action("ATTACK_Queen",                   // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_INPROGRESS,                 // Event Tag
                              RESREF_BOSS,                      // Owner
                              1,                                // Quantity
                              eE_VAR_EVENT_ACTION_ATTACK,       // Attack
                              eE_SPAWNTAG_PC,                   // Target
                              eE_TARGETMETHOD_NEARESTINDIVIDUAL,// Nearest Target
                              eE_OBJECTLOCATION_OBJECT,         // Object
                              0,                                // No Spell
                              -1,                               // No Spell Warning
                              0.0f,                             // No Spell Warning Delay
                              QUEEN_FLEE_INITIALDELAY + (6.0f * QUEEN_FLEE_DURATION_ROUNDS) + 0.5f, // Initial Delay
                              QUEEN_FLEE_INTERVAL);             // Interval

        // Spawn a Webber Add
        eE_CreateEvent_Creature("SPAWN_Webber",                 // Event Name
                                ENCOUNTER_TAG,                  // Encounter Tag
                                EVENT_INPROGRESS,               // Event Tag
                                eE_EVENTOWNER_NONE,             // Owner
                                RESREF_WEBBER,                  // Blueprint
                                WEBBER_COUNT,                   // Quantity
                                0,                              // MaxConcurrent
                                eE_SPAWNTAG_PC,                 // SpawnAt
                                0.0f,                           // SpawnDelay
                                eE_SPAWNMETHOD_RANDOM,          // SpawnMethod
                                0,                              // Spawn Effect
                                RESREF_WEBBER,                  // New Tag
                                EVENT_WEBBER_ATTACK,            // OnSpawn
                                "",                             // OnDamaged Event
                                "",                             // OnDeath
                                "",                             // OnExhaust
                                0,                              // Key Event
                                WEBBER_SPAWN_INITIALDELAY,      // Initial Delay
                                WEBBER_SPAWN_INTERVAL);         // Interval

        // Webbers go after the nearest PC
        eE_CreateEvent_Action("ATTACK_Webber",                  // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_WEBBER_ATTACK,              // Event Tag
                              eE_EVENTOWNER_SELF,               // Owner
                              1,                                // Quantity
                              eE_VAR_EVENT_ACTION_ATTACK,       // Attack
                              eE_SPAWNTAG_PC,                   // Target
                              eE_TARGETMETHOD_NEARESTINDIVIDUAL,// Nearest Target
                              eE_OBJECTLOCATION_OBJECT,         // Object
                              0,                                // No Spell
                              -1,                               // No Spell Warning
                              0.0f,                             // No Spell Warning Delay
                              0.1f);                            // Initial Delay
    }
}
