/************************************************************************
 * script name  : enc_banditchief
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
const string ENCOUNTER_NAME             = "Bandit Chief";
const string ENCOUNTER_TAG              = "enc_bandit";
const float ENCOUNTER_DESPAWNINTERVAL   = 12.0f;
const float ENCOUNTER_RESPAWN           = 3600.0f;
const int ENCOUNTER_DEBUGLEVEL          = eE_MESSAGELEVEL_LOW;

const string EVENT_INITIALIZE           = "event_Initialize";
const string EVENT_INPROGRESS           = "event_InProgress";
const string EVENT_BOSS_ONDAMAGE        = "event_Boss_OnDmg";
const string EVENT_ILLUSION_ONDEATH     = "event_Illu_Death";
const string EVENT_ILLUSION_ONSPAWN     = "event_Illu_Spawn";

const string WAYPOINT_ENCOUNTER         = "wp_enc_banditchief";
const string WAYPOINT_SPAWN_CHIEF       = "wp_spawn_chief";
const string WAYPOINT_SPAWN_ILLUSION    = "wp_spawn_illusion";
const string WAYPOINT_SPAWN_RIGHTHAND   = "wp_spawn_rhand";
const string WAYPOINT_SPAWN_LEFTHAND    = "wp_spawn_lhand";
const string WAYPOINT_CHIEF_SAFE        = "wp_safepoint";

const string RESREF_BOSS                = "enc_bc_chief";
const string RESREF_ILLUSION            = "enc_bc_illusion";
const string RESREF_RIGHTHAND           = "enc_bc_rhand";
const string RESREF_LEFTHAND            = "enc_bc_lhand";

const float ILLUSION_JUMP_DELAY         = 3.0f;

const int VFX_VANISH_BOSS               = VFX_FNF_SUMMON_MONSTER_1;
const int VFX_APPEAR_BOSS               = VFX_FNF_SUMMON_MONSTER_1;
const int VFX_VANISH_ILLUSION           = VFX_FNF_GAS_EXPLOSION_GREASE;
const int VFX_APPEAR_ILLUSION           = VFX_FNF_GAS_EXPLOSION_GREASE;

void main()
{
    // Look for an existing encounter
    object oEncounter = GetObjectByTag(ENCOUNTER_TAG);

    // Create the encounter object
    if (!GetIsObjectValid(oEncounter))
    {
        // Create the encounter
        eE_CreateEncounter(ENCOUNTER_NAME, WAYPOINT_ENCOUNTER, ENCOUNTER_TAG, eE_VAR_CONDITION_NONE, ENCOUNTER_DESPAWNINTERVAL, EVENT_INITIALIZE, EVENT_INPROGRESS, ENCOUNTER_RESPAWN, ENCOUNTER_DEBUGLEVEL);

        // Spawn the Bandit Chief
        eE_CreateEvent_Creature("SPAWN_Chief",                  // Event Name
                                ENCOUNTER_TAG,                  // Encounter Tag
                                EVENT_INITIALIZE,               // Event Tag
                                eE_EVENTOWNER_NONE,             // Owner
                                RESREF_BOSS,                    // Blueprint ResRef
                                -1,                             // Quantity
                                0,                              // MaxConcurrent
                                WAYPOINT_SPAWN_CHIEF,           // Spawn Point
                                0.0f,                           // Spawn Delay
                                eE_SPAWNMETHOD_FIXED,           // Spawn Method
                                0,                              // Spawn Effect
                                RESREF_BOSS,                    // New Tag
                                "",                             // OnSpawn
                                EVENT_BOSS_ONDAMAGE,            // OnDamaged
                                "",                             // OnDeath
                                "",                             // OnExhaust
                                1);                             // Key Event

        // Spawn Left and Right Hand
        eE_CreateEvent_Creature("SPAWN_RightHand",              // Event Name
                                ENCOUNTER_TAG,                  // Encounter Tag
                                EVENT_INITIALIZE,               // Event Tag
                                eE_EVENTOWNER_NONE,             // Owner
                                RESREF_RIGHTHAND,               // Blueprint
                                -1,                             // Quantity
                                0,                              // MaxConcurrent
                                WAYPOINT_SPAWN_RIGHTHAND,       // SpawnAt
                                0.0f,                           // SpawnDelay
                                eE_SPAWNMETHOD_FIXED,           // SpawnMethod
                                0,                              // Spawn Effect
                                RESREF_RIGHTHAND);              // New Tag

        eE_CreateEvent_Creature("SPAWN_LeftHand",               // Event Name
                                ENCOUNTER_TAG,                  // Encounter Tag
                                EVENT_INITIALIZE,               // Event Tag
                                eE_EVENTOWNER_NONE,             // Owner
                                RESREF_LEFTHAND,                // Blueprint
                                -1,                             // Quantity
                                0,                              // MaxConcurrent
                                WAYPOINT_SPAWN_LEFTHAND,        // SpawnAt
                                0.0f,                           // SpawnDelay
                                eE_SPAWNMETHOD_FIXED,           // SpawnMethod
                                0,                              // Spawn Effect
                                RESREF_LEFTHAND);               // New Tag

        // At 75%, 50% and 25%, the boss disappears in a cloud of smoke
        // And one illusion for every 4 players spawns
        int nth;
        for (nth = 3; nth > 0; nth--)
        {
            // Do a vanish effect on the chief
            eE_CreateEvent_Effect("VANISH_Chief",               // Event Name
                                  ENCOUNTER_TAG,                // Encounter Tag
                                  EVENT_BOSS_ONDAMAGE + "_" + IntToString(nth * 25),    // Event Tag
                                  RESREF_BOSS,                  // Owner
                                  1,                            // Quantity
                                  0.0f,                         // Delay
                                  RESREF_BOSS,                  // Tag / Target
                                  eE_TARGETMETHOD_FIXED,        // Target Method
                                  DURATION_TYPE_INSTANT,        // Duration Type
                                  0.0f,                         // Duration
                                  eE_EFFECT_TYPE_FNF,           // Effect Type
                                  -1,                           // No Effect
                                  "",                           // No Effect Variables
                                  VFX_VANISH_BOSS);             // VFX

            eE_CreateEvent_Action("JUMP_Chief_Safe",                                    // Event Name
                                  ENCOUNTER_TAG,                                        // Encounter Tag
                                  EVENT_BOSS_ONDAMAGE + "_" + IntToString(nth * 25),    // Event Tag
                                  RESREF_BOSS,                                          // Owner
                                  1,                                                    // Quantity
                                  eE_VAR_EVENT_ACTION_JUMPTO,                           // Event ID
                                  WAYPOINT_CHIEF_SAFE);                                 // Target

            // Spawn the Illusions
            eE_CreateEvent_Creature("SPAWN_Illusion",               // Event Name
                                    ENCOUNTER_TAG,                  // Encounter Tag
                                    EVENT_BOSS_ONDAMAGE + "_" + IntToString(nth * 25),               // Event Tag
                                    eE_EVENTOWNER_NONE,             // Owner
                                    RESREF_ILLUSION,                // Blueprint ResRef
                                    1,                              // Quantity
                                    0,                              // MaxConcurrent
                                    WAYPOINT_SPAWN_ILLUSION,        // Spawn Point
                                    0.0f,                           // Spawn Delay
                                    eE_SPAWNMETHOD_RANDOM,          // Spawn Method
                                    0,                              // Spawn Effect
                                    RESREF_ILLUSION,                // New Tag
                                    "",                             // OnSpawn
                                    "",                             // OnDamaged
                                    "",                             // OnDeath
                                    EVENT_ILLUSION_ONDEATH,         // OnExhaust
                                    0);                             // Key Event

            // Do a vanish effect on the illusions on disappearance AND appearance
            eE_CreateEvent_Effect("VANISH_Illusion",            // Event Name
                                  ENCOUNTER_TAG,                // Encounter Tag
                                  EVENT_BOSS_ONDAMAGE + "_" + IntToString(nth * 25),    // Event Tag
                                  RESREF_ILLUSION,              // Owner
                                  1,                            // Quantity
                                  0.0f,                         // Delay
                                  RESREF_ILLUSION,              // Tag / Target
                                  eE_TARGETMETHOD_FIXED,        // Target Method
                                  DURATION_TYPE_INSTANT,        // Duration Type
                                  0.0f,                         // Duration
                                  eE_EFFECT_TYPE_FNF,           // Effect Type
                                  -1,                           // No Effect
                                  "",                           // No Effect Variables
                                  VFX_VANISH_ILLUSION,          // VFX
                                  "",                           // Effect Tag
                                  ILLUSION_JUMP_DELAY,          // Initial Delay
                                  ILLUSION_JUMP_DELAY);         // Interval

            eE_CreateEvent_Effect("APPEAR_Illusion",            // Event Name
                                  ENCOUNTER_TAG,                // Encounter Tag
                                  EVENT_BOSS_ONDAMAGE + "_" + IntToString(nth * 25),    // Event Tag
                                  RESREF_ILLUSION,              // Owner
                                  1,                            // Quantity
                                  0.0f,                         // Delay
                                  RESREF_ILLUSION,              // Tag / Target
                                  eE_TARGETMETHOD_FIXED,        // Target Method
                                  DURATION_TYPE_INSTANT,        // Duration Type
                                  0.0f,                         // Duration
                                  eE_EFFECT_TYPE_FNF,           // Effect Type
                                  -1,                           // No Effect
                                  "",                           // No Effect Variables
                                  VFX_APPEAR_ILLUSION,          // VFX
                                  "",                           // Effect Tag
                                  ILLUSION_JUMP_DELAY + 0.05f,  // Initial Delay
                                  ILLUSION_JUMP_DELAY);         // Interval

            // Illusions jump around all the time
            eE_CreateEvent_Action("JUMP_Illusion",                                      // Event Name
                                  ENCOUNTER_TAG,                                        // Encounter Tag
                                  EVENT_BOSS_ONDAMAGE + "_" + IntToString(nth * 25),    // Event Tag
                                  RESREF_ILLUSION,                                      // Owner
                                  -1,                                                   // Quantity
                                  eE_VAR_EVENT_ACTION_JUMPTO,                           // Event ID
                                  WAYPOINT_SPAWN_ILLUSION,                              // Target
                                  eE_TARGETMETHOD_RANDOMINDIVIDUAL,                     // Target Method
                                  eE_OBJECTLOCATION_LOCATION,                           // Target Type
                                  0,                                                    // Spell
                                  -1,                                                   // Spell Warning
                                  0.0f,                                                 // Spell Warning Delay
                                  ILLUSION_JUMP_DELAY,                                  // Initial Delay
                                  ILLUSION_JUMP_DELAY);                                 // Interval

            // Illusions go after the nearest PC after each jump
            eE_CreateEvent_Action("ATTACK_Illusion",                                    // Event Name
                                  ENCOUNTER_TAG,                                        // Encounter Tag
                                  EVENT_BOSS_ONDAMAGE + "_" + IntToString(nth * 25),    // Event Tag
                                  RESREF_ILLUSION,                                      // Owner
                                  -1,                                                   // Quantity
                                  eE_VAR_EVENT_ACTION_ATTACK,                           // Attack
                                  eE_SPAWNTAG_PC,                                       // Target
                                  eE_TARGETMETHOD_NEARESTINDIVIDUAL,                    // Nearest Target
                                  eE_OBJECTLOCATION_OBJECT,                             // Object
                                  0,                                                    // No Spell
                                  -1,                                                   // No Spell Warning
                                  0.0f,                                                 // No Spell Warning Delay
                                  ILLUSION_JUMP_DELAY + 0.1f,                           // Initial Delay
                                  ILLUSION_JUMP_DELAY);                                 // Interval
        }

        // Upon death, the illusion disappears
        eE_CreateEvent_Special("DESTROY_Illusion",              // Event Name
                               ENCOUNTER_TAG,                   // Encounter Tag
                               EVENT_ILLUSION_ONDEATH,          // Event Tag
                               eE_EVENTOWNER_NONE,              // Owner
                               eE_VAR_SPECIAL_DESTROYALL,       // Event ID
                               RESREF_ILLUSION,                 // Target
                               0.0f,                            // Initial Delay
                               0.0f,                            // Interval
                               0,                               // Max Repeats
                               eE_UNDO_MANUAL);                 // Manual Undo

        // Once the illusion is dead, the chief returns to battle
        eE_CreateEvent_Action("JUMP_Chief_Back",                // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_ILLUSION_ONDEATH,           // Event Tag
                              RESREF_BOSS,                      // Owner
                              -1,                               // Quantity
                              eE_VAR_EVENT_ACTION_JUMPTO,       // Event ID
                              WAYPOINT_SPAWN_CHIEF);            // Target

        // Do an appear effect on the chief
        eE_CreateEvent_Effect("APPEAR_Chief",                   // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_ILLUSION_ONDEATH,           // Event Tag
                              RESREF_BOSS,                      // Owner
                              -1,                               // Quantity
                              0.0f,                             // Delay
                              RESREF_BOSS,                      // Tag / Target
                              eE_TARGETMETHOD_FIXED,            // Target Method
                              DURATION_TYPE_INSTANT,            // Duration Type
                              0.0f,                             // Duration
                              eE_EFFECT_TYPE_FNF,               // Effect Type
                              -1,                               // No Effect
                              "",                               // No Effect Variables
                              VFX_APPEAR_BOSS,                  // VFX
                              "",                               // Effect Tag
                              0.05f);                           // Initial Delay
    }
}
