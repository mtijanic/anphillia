/************************************************************************
 * script name  : enc_crypt_01
 * created by   : eyesolated
 * date         : 2018/5/14
 *
 * description  : This script defines the Constructor encounter
 *
 * changes      : 2018/5/14 - eyesolated - Initial creation
 ************************************************************************/

// Includes
#include "ee_inc"

// Constants
const string ENCOUNTER_NAME             = "Crypt Level 1";
const string ENCOUNTER_TAG              = "ee_crypt_01";
const float ENCOUNTER_RESPAWN           = 3600.0f;
const int ENCOUNTER_DEBUGLEVEL          = eE_MESSAGELEVEL_DEBUG_LOG;

const int LOCK_DOORS                    = FALSE;

const string EVENT_INITIALIZE           = "event_Initialize";
const string EVENT_INPROGRESS           = "event_InProgress";
const string EVENT_PHASE1               = "event_Phase_01";
const string EVENT_MUMMY                = "event_Mummy";
const string EVENT_BOSS                 = "event_Boss";
const string EVENT_VICTORY              = "event_Victory";

const string WAYPOINT_ENCOUNTER         = "wp_ee_crypt_01";
const string WAYPOINT_URN               = "wp_urn";
const string WAYPOINT_SCARAB            = "wp_scarab_spawn";
const string WAYPOINT_SARCOPHAGUS       = "wp_sarcophagus";

const string DOOR_ALL                   = "crypt_01_door";

const string RESREF_BOSS                = "crypt_01_boss";
const string RESREF_SCARAB              = "crypt_01_scarab";
const string RESREF_URN                 = "crypt_01_urn";
const string RESREF_SARCOPHAGUS         = "crypt_01_sarcoph";
const string RESREF_LESSERMUMMY         = "crypt_01_mummy";

const int SCARAB_COUNT                  = 6;
const int SCARAB_MUMMIES_PER_SCARAB     = 2;

void main()
{
    // Look for an existing encounter
    object oEncounter = GetObjectByTag(ENCOUNTER_TAG);

    // Create the encounter object
    if (!GetIsObjectValid(oEncounter))
    {
        // Create the encounter
        eE_CreateEncounter(ENCOUNTER_NAME, WAYPOINT_ENCOUNTER, ENCOUNTER_TAG, eE_VAR_CONDITION_NONE, 12.0f, EVENT_INITIALIZE, EVENT_INPROGRESS, ENCOUNTER_RESPAWN, ENCOUNTER_DEBUGLEVEL);

        // Create the urn placeable
        eE_CreateEvent_Placeable("SPAWN_Urn",                   // Event Name
                                 ENCOUNTER_TAG,                 // Encounter Tag
                                 EVENT_INITIALIZE,              // Event Tag
                                 eE_EVENTOWNER_NONE,            // Owner
                                 RESREF_URN,                    // Blueprint ResRef
                                 -1,                            // Quantity
                                 0,                             // MaxConcurrent
                                 WAYPOINT_URN,                  // Spawn Point
                                 0.0f,                          // Spawn Delay
                                 eE_SPAWNMETHOD_FIXED,          // Spawn Method
                                 0,                             // Spawn Effect
                                 RESREF_URN,                    // New Tag
                                 "",                            // OnSpawn
                                 "",                            // OnDamaged Event
                                 EVENT_PHASE1);                 // OnDeath

        // Create the sarcophagus placeables
        eE_CreateEvent_Placeable("SPAWN_Sarcophagus",           // Event Name
                                 ENCOUNTER_TAG,                 // Encounter Tag
                                 EVENT_INITIALIZE,              // Event Tag
                                 eE_EVENTOWNER_NONE,            // Owner
                                 RESREF_SARCOPHAGUS,            // Blueprint ResRef
                                 -1,                            // Quantity
                                 0,                             // MaxConcurrent
                                 WAYPOINT_SARCOPHAGUS,          // Spawn Point
                                 0.0f,                          // Spawn Delay
                                 eE_SPAWNMETHOD_FIXED,          // Spawn Method
                                 0,                             // Spawn Effect
                                 RESREF_SARCOPHAGUS,            // New Tag
                                 "",                            // OnSpawn
                                 "",                            // OnDamaged Event
                                 EVENT_PHASE1);                 // OnDeath

        // Lock all door
        if (LOCK_DOORS)
        {
            eE_CreateEvent_Special("LOCK_Doors",                // Event Name
                                   ENCOUNTER_TAG,               // Encounter Tag
                                   EVENT_PHASE1,                // Event Tag
                                   eE_EVENTOWNER_NONE,          // Owner
                                   eE_VAR_SPECIAL_LOCKALL,      // Event ID: Activate Plot Flag
                                   DOOR_ALL);                   // Target Tag
        }

        // Spawn Scarabs
        eE_CreateEvent_Creature("SPAWN_Scarabs",                // Event Name
                                ENCOUNTER_TAG,                  // Encounter Tag
                                EVENT_PHASE1,                   // Event Tag
                                eE_EVENTOWNER_NONE,             // Owner
                                RESREF_SCARAB,                  // Blueprint
                                SCARAB_COUNT,                   // Quantity
                                0,                              // MaxConcurrent
                                WAYPOINT_SCARAB,                // SpawnAt
                                0.0f,                           // SpawnDelay
                                eE_SPAWNMETHOD_RANDOM,          // SpawnMethod
                                VFX_FNF_GAS_EXPLOSION_NATURE,   // Spawn Effect
                                RESREF_SCARAB,                  // New Tag
                                "",                             // OnSpawn
                                "",                             // OnDamaged Event
                                EVENT_MUMMY,                    // OnDeath
                                EVENT_BOSS);                    // OnExhaust

        // Spawn a Mummy Add
        eE_CreateEvent_Creature("SPAWN_Mummy",                  // Event Name
                                ENCOUNTER_TAG,                  // Encounter Tag
                                EVENT_MUMMY,                    // Event Tag
                                eE_EVENTOWNER_NONE,             // Owner
                                RESREF_LESSERMUMMY,             // Blueprint
                                SCARAB_MUMMIES_PER_SCARAB,      // Quantity
                                0,                              // MaxConcurrent
                                WAYPOINT_SARCOPHAGUS,           // SpawnAt
                                0.0f,                           // SpawnDelay
                                eE_SPAWNMETHOD_RANDOM,          // SpawnMethod
                                VFX_FNF_GAS_EXPLOSION_NATURE,   // Spawn Effect
                                RESREF_LESSERMUMMY,             // New Tag
                                "",                             // OnSpawn
                                "",                             // OnDamaged Event
                                "",                             // OnDeath
                                "");                            // OnExhaust

        // Spawn the Boss
        eE_CreateEvent_Creature("SPAWN_Boss",                   // Event Name
                                ENCOUNTER_TAG,                  // Encounter Tag
                                EVENT_BOSS,                     // Event Tag
                                eE_EVENTOWNER_NONE,             // Owner
                                RESREF_BOSS,                    // Blueprint ResRef
                                -1,                             // Quantity
                                0,                              // MaxConcurrent
                                WAYPOINT_URN,                   // Spawn Point
                                0.0f,                           // Spawn Delay
                                eE_SPAWNMETHOD_FIXED,           // Spawn Method
                                0,                              // Spawn Effect
                                RESREF_BOSS,                    // New Tag
                                "",                             // OnSpawn Event
                                "",                             // OnDamaged Event
                                EVENT_VICTORY,                  // OnDeath Event
                                "",                             // OnExhaust
                                1);                             // Key Event

        // Make boss announce that players WILL die!
        eE_CreateEvent_Special("SOUND_BOSS_SPAWN",
                               ENCOUNTER_TAG,
                               EVENT_BOSS,
                               eE_EVENTOWNER_NONE,
                               eE_VAR_SPECIAL_SOUNDOBJECTPLAY,
                               "s_crypt_01_boss");

        // Unlock entrance door
        if (LOCK_DOORS)
        {
            eE_CreateEvent_Special("UNLOCK_Doors",              // Event Name
                                   ENCOUNTER_TAG,               // Encounter Tag
                                   EVENT_VICTORY,               // Event Tag
                                   eE_EVENTOWNER_NONE,          // Owner
                                   eE_VAR_SPECIAL_OPENALL,      // Event ID: Activate Plot Flag
                                   DOOR_ALL,                    // Target Tag
                                   0.0f,                        // Initial Delay
                                   0.0f,                        // Interval
                                   0,                           // Max Repeats
                                   eE_UNDO_MANUAL);             // Manual Undo
        }
    }
}
