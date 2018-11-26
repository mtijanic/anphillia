/************************************************************************
 * script name  : enc_constructor
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
const string ENCOUNTER_NAME             = "The Constructor";
const string ENCOUNTER_TAG              = "ee_constructor";
const int ENCOUNTER_DEBUGLEVEL          = eE_MESSAGELEVEL_LOW;

const string EVENT_INITIALIZE           = "event_Initialize";
const string EVENT_INPROGRESS           = "event_InProgress";
const string EVENT_GOLEM_FIRE           = "event_GolemFire";
const string EVENT_GOLEM_ICE            = "event_GolemIce";
const string EVENT_GOLEM_EARTH          = "event_GolemEarth";
const string EVENT_BOSS                 = "event_Boss";
const string EVENT_VICTORY              = "event_Victory";

const string WAYPOINT_ENCOUNTER         = "wp_ee_constructor";
const string WAYPOINT_BOSS_SPAWN        = "wp_boss_spawn";
const string WAYPOINT_EQUIPMENT         = "wp_equipment";
const string WAYPOINT_GOLEM_FIRE        = "wp_golem_fire_spawn";
const string WAYPOINT_GOLEM_ICE         = "wp_golem_ice_spawn";
const string WAYPOINT_GOLEM_EARTH       = "wp_golem_earth_spawn";

const int DOORS_LOCK                    = FALSE;
const string DOOR_ENTRANCE              = "door_entrance";
const string DOOR_BOSSROOM              = "door_bossroom";

const string RESREF_BOSS                = "con_constructor";
const string RESREF_EQUIPMENT           = "con_equipment";
const string RESREF_GOLEM_FIRE          = "con_golem_fire";
const string RESREF_GOLEM_ICE           = "con_golem_ice";
const string RESREF_GOLEM_EARTH         = "con_golem_earth";

const string EFFECT_TAG_PARALYZE        = "fx_paralyze";

const string DAMAGE_FIRE_PLACEABLE      = "x3_plc_flame001";
const int DAMAGE_FIRE_AMOUNT            = 25;
const int DAMAGE_FIRE_TICKS             = 120;
const float DAMAGE_FIRE_DURATION        = 180.0f;
const float DAMAGE_FIRE_INTERVAL        = 3.0f;

const int DAMAGE_FIRE_CLOSERANGE_AMOUNT     = 50;
const float DAMAGE_FIRE_CLOSERANGE_INTERVAL = 3.0f;

const float ICE_FREEZE_DURATION         = 6.0f;
const float ICE_FREEZE_INTERVAL         = 2.0f;

const int DAMAGE_ICE_AMOUNT             = 10;
const float DAMAGE_ICE_INTERVAL         = 6.0f;

const int DAMAGE_SPIKE_AMOUNT           = 50;
const float DAMAGE_SPIKE_WARNINGDELAY   = 1.75f;
const float DAMAGE_SPIKE_INTERVAL       = 11.0f;

void main()
{
    // Look for an existing encounter
    object oEncounter = GetObjectByTag(ENCOUNTER_TAG);

    // Create the encounter object
    if (!GetIsObjectValid(oEncounter))
    {
        // Create the encounter
        eE_CreateEncounter(ENCOUNTER_NAME, WAYPOINT_ENCOUNTER, ENCOUNTER_TAG, eE_VAR_CONDITION_NONE, 12.0f, EVENT_INITIALIZE, EVENT_INPROGRESS, 1800.0f, ENCOUNTER_DEBUGLEVEL);

        // Create the equipment placeable
        eE_CreateEvent_Placeable("SPAWN_Equipment",             // Event Name
                                 ENCOUNTER_TAG,                 // Encounter Tag
                                 EVENT_INITIALIZE,              // Event Tag
                                 eE_EVENTOWNER_NONE,            // Owner
                                 RESREF_EQUIPMENT,              // Blueprint ResRef
                                 -1,                            // Quantity
                                 0,                             // MaxConcurrent
                                 WAYPOINT_EQUIPMENT,            // Spawn Point
                                 0.0f,                          // Spawn Delay
                                 eE_SPAWNMETHOD_FIXED,          // Spawn Method
                                 0,                             // Spawn Effect
                                 RESREF_EQUIPMENT,              // New Tag
                                 "",                            // OnSpawn
                                 "",                            // OnDamaged Event
                                 EVENT_GOLEM_FIRE);             // OnDeath

        // Create the Constructor
        eE_CreateEvent_Creature("SPAWN_Constructor",            // Event Name
                                ENCOUNTER_TAG,                  // Encounter Tag
                                EVENT_INITIALIZE,               // Event Tag
                                eE_EVENTOWNER_NONE,             // Owner
                                RESREF_BOSS,                    // Blueprint ResRef
                                -1,                             // Quantity
                                0,                              // MaxConcurrent
                                WAYPOINT_BOSS_SPAWN,            // Spawn Point
                                0.0f,                           // Spawn Delay
                                eE_SPAWNMETHOD_FIXED,           // Spawn Method
                                0,                              // Spawn Effect
                                RESREF_BOSS,                    // New Tag
                                "",                             // OnSpawn Event
                                "",                             // OnDamaged Event
                                EVENT_VICTORY,                  // OnDeath Event
                                "",                             // OnExhaust
                                1);                             // Key Event

        // Create the Golems
        eE_CreateEvent_Creature("SPAWN_Golem_Fire",             // Event Name
                                ENCOUNTER_TAG,                  // Encounter Tag
                                EVENT_INITIALIZE,               // Event Tag
                                eE_EVENTOWNER_NONE,             // Owner
                                RESREF_GOLEM_FIRE,              // Blueprint ResRef
                                -1,                             // Quantity
                                0,                              // MaxConcurrent
                                WAYPOINT_GOLEM_FIRE,            // Spawn Point
                                0.0f,                           // Spawn Delay
                                eE_SPAWNMETHOD_FIXED,           // Spawn Method
                                0,                              // Spawn Effect
                                RESREF_GOLEM_FIRE,              // New Tag
                                "",                             // OnSpawn Event
                                "",                             // OnDamaged Event
                                EVENT_GOLEM_ICE);               // OnDeath Event

        eE_CreateEvent_Creature("SPAWN_Golem_Ice",              // Event Name
                                ENCOUNTER_TAG,                  // Encounter Tag
                                EVENT_INITIALIZE,               // Event Tag
                                eE_EVENTOWNER_NONE,             // Owner
                                RESREF_GOLEM_ICE,               // Blueprint ResRef
                                -1,                             // Quantity
                                0,                              // MaxConcurrent
                                WAYPOINT_GOLEM_ICE,             // Spawn Point
                                0.0f,                           // Spawn Delay
                                eE_SPAWNMETHOD_FIXED,           // Spawn Method
                                0,                              // Spawn Effect
                                RESREF_GOLEM_ICE,               // New Tag
                                "",                             // OnSpawn Event
                                "",                             // OnDamaged Event
                                EVENT_GOLEM_EARTH);             // OnDeath Event

        eE_CreateEvent_Creature("SPAWN_Golem_Earth",            // Event Name
                                ENCOUNTER_TAG,                  // Encounter Tag
                                EVENT_INITIALIZE,               // Event Tag
                                eE_EVENTOWNER_NONE,             // Owner
                                RESREF_GOLEM_EARTH,             // Blueprint ResRef
                                -1,                             // Quantity
                                0,                              // MaxConcurrent
                                WAYPOINT_GOLEM_EARTH,           // Spawn Point
                                0.0f,                           // Spawn Delay
                                eE_SPAWNMETHOD_FIXED,           // Spawn Method
                                0,                              // Spawn Effect
                                RESREF_GOLEM_EARTH,             // New Tag
                                "",                             // OnSpawn Event
                                "",                             // OnDamaged Event
                                EVENT_BOSS);                    // OnDeath Event

        // And paralyze them
        eE_CreateEvent_Effect("FX_PARALYZE_Golem_Fire",         // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_INITIALIZE,                 // Event Tag
                              eE_EVENTOWNER_NONE,               // Owner
                              -1,                               // Quantity
                              0.0f,                             // Delay between Owners / Tags
                              RESREF_GOLEM_FIRE,                // Target object
                              eE_TARGETMETHOD_FIXED,            // Target Method
                              DURATION_TYPE_PERMANENT,          // Duration Type
                              0.0f,                             // Duration
                              eE_EFFECT_TYPE_DURATION,          // eE Effect Type
                              eE_EFFECT_EFFECT_CUTSCENEPARALYZE,// Effect
                              "",                               // Effect variables (none needed)
                              VFX_DUR_PETRIFY,                  // Visual Effect
                              EFFECT_TAG_PARALYZE,              // Effect Tag
                              0.5f);                            // Initial Delay

        eE_CreateEvent_Effect("FX_PARALYZE_Golem_Ice",          // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_INITIALIZE,                 // Event Tag
                              eE_EVENTOWNER_NONE,               // Owner
                              -1,                               // Quantity
                              0.0f,                             // Delay between Owners / Tags
                              RESREF_GOLEM_ICE,                 // Target object
                              eE_TARGETMETHOD_FIXED,            // Target Method
                              DURATION_TYPE_PERMANENT,          // Duration Type
                              0.0f,                             // Duration
                              eE_EFFECT_TYPE_DURATION,          // eE Effect Type
                              eE_EFFECT_EFFECT_CUTSCENEPARALYZE,// Effect
                              "",                               // Effect variables (none needed)
                              VFX_DUR_PETRIFY,                  // Visual Effect
                              EFFECT_TAG_PARALYZE,              // Effect Tag
                              0.5f);                            // Initial Delay

        eE_CreateEvent_Effect("FX_PARALYZE_Golem_Earth",        // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_INITIALIZE,                 // Event Tag
                              eE_EVENTOWNER_NONE,               // Owner
                              -1,                               // Quantity
                              0.0f,                             // Delay between Owners / Tags
                              RESREF_GOLEM_EARTH,               // Target object
                              eE_TARGETMETHOD_FIXED,            // Target Method
                              DURATION_TYPE_PERMANENT,          // Duration Type
                              0.0f,                             // Duration
                              eE_EFFECT_TYPE_DURATION,          // eE Effect Type
                              eE_EFFECT_EFFECT_CUTSCENEPARALYZE,// Effect
                              "",                               // Effect variables (none needed)
                              VFX_DUR_PETRIFY,                  // Visual Effect
                              EFFECT_TAG_PARALYZE,              // Effect Tag
                              0.5f);                            // Initial Delay

        // And make them immortal
        eE_CreateEvent_Special("PLOT_Golem_Fire",               // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_INITIALIZE,                 // Event Tag
                              eE_EVENTOWNER_NONE,               // Owner
                              eE_VAR_SPECIAL_SETIMMORTALALL,    // Activate Plot Flag
                              RESREF_GOLEM_FIRE,                // Target Tag
                              0.25f);                           // Initial Delay

        eE_CreateEvent_Special("PLOT_Golem_Ice",                // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_INITIALIZE,                 // Event Tag
                              eE_EVENTOWNER_NONE,               // Owner
                              eE_VAR_SPECIAL_SETIMMORTALALL,    // Activate Plot Flag
                              RESREF_GOLEM_ICE,                 // Target Tag
                              0.25f);                           // Initial Delay

        eE_CreateEvent_Special("PLOT_Golem_Earth",              // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_INITIALIZE,                 // Event Tag
                              eE_EVENTOWNER_NONE,               // Owner
                              eE_VAR_SPECIAL_SETIMMORTALALL,    // Activate Plot Flag
                              RESREF_GOLEM_EARTH,               // Target Tag
                              0.25f);                           // Initial Delay

        // Fire golem is even slower than the rest
        eE_CreateEvent_Effect("FX_SLOW_Golem_Fire",             // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_INITIALIZE,                 // Event Tag
                              eE_EVENTOWNER_NONE,               // Owner
                              -1,                               // Quantity
                              0.0f,                             // Delay between Owners / Tags
                              RESREF_GOLEM_FIRE,                // Target object
                              eE_TARGETMETHOD_FIXED,            // Target Method
                              DURATION_TYPE_PERMANENT,          // Duration Type
                              0.0f,                             // Duration
                              eE_EFFECT_TYPE_DURATION,          // eE Effect Type
                              eE_EFFECT_EFFECT_MOVEMENTSPEEDDECREASE,// Effect
                              "50",                             // Effect variables (none needed)
                              -1,                               // Visual Effect
                              "",                               // Effect Tag
                              0.5f);                            // Initial Delay

        // Fire Golem Phase

        // Lock door
        if (DOORS_LOCK)
        {
            eE_CreateEvent_Special("LOCK_Entrance",                 // Event Name
                                   ENCOUNTER_TAG,                   // Encounter Tag
                                   EVENT_GOLEM_FIRE,                // Event Tag
                                   RESREF_GOLEM_FIRE,               // Owner
                                   eE_VAR_SPECIAL_LOCKALL,          // Event ID: Activate Plot Flag
                                   DOOR_ENTRANCE);                  // Target Tag
        }

        // Play the "hello" sound
        eE_CreateEvent_Special("SOUND_HELLO",
                               ENCOUNTER_TAG,
                               EVENT_GOLEM_FIRE,
                               eE_EVENTOWNER_NONE,
                               eE_VAR_SPECIAL_SOUNDOBJECTPLAY,
                               "con_s_inprogress");

        // Activate Golem
        eE_CreateEvent_Action("UNPARALYZE_Golem_Fire",          // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_GOLEM_FIRE,                 // Event Tag
                              RESREF_GOLEM_FIRE,                // Owner
                              -1,                               // Quantity
                              eE_VAR_EVENT_ACTION_REMOVEEFFECT, // Remove Effect
                              EFFECT_TAG_PARALYZE);             // Effect Tag to Remove

        eE_CreateEvent_Effect("FX_HEAL_Golem_Fire",             // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_GOLEM_FIRE,                 // Event Tag
                              eE_EVENTOWNER_NONE,               // Owner
                              -1,                               // Quantity
                              0.0f,                             // Delay between Owners / Tags
                              RESREF_GOLEM_FIRE,                // Target object
                              eE_TARGETMETHOD_FIXED,            // Target Method
                              DURATION_TYPE_INSTANT,            // Duration Type
                              0.0f,                             // Duration
                              eE_EFFECT_TYPE_IMPACT,            // eE Effect Type
                              eE_EFFECT_EFFECT_HEAL,            // Effect
                              "10000",                          // Effect variables
                              VFX_IMP_PULSE_FIRE,               // Visual Effect
                              "",                               // Effect Tag
                              0.1f);                            // Initial Delay

        eE_CreateEvent_Special("UNPLOT_Golem_Fire",             // Event Name
                               ENCOUNTER_TAG,                   // Encounter Tag
                               EVENT_GOLEM_FIRE,                // Event Tag
                               RESREF_GOLEM_FIRE,               // Owner
                               eE_VAR_SPECIAL_SETMORTALALL,     // Event ID: Activate Plot Flag
                               RESREF_GOLEM_FIRE,               // Target Tag
                               0.2f);                           // Initial Delay

        /* shouldn't be needed, the OnDamaged script that is responsible for target switching has been removed
           from the golem blueprint
        // Fire golem selects nearest target and follows that target until it's no longer valid
        eE_CreateEvent_Action("ATTACK_TARGET_Golem_Fire",       // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_GOLEM_FIRE,                 // Event Tag
                              RESREF_GOLEM_FIRE,                // Owner
                              1,                                // Quantity
                              eE_VAR_EVENT_ACTION_ATTACK,       // Attack
                              eE_SPAWNTAG_PC,                   // Target
                              eE_TARGETMETHOD_LASTTARGET_NEAREST, // Last Target or nearest
                              eE_OBJECTLOCATION_OBJECT,         // Object
                              0,                                // No Spell
                              -1,                               // No Spell Warning
                              0.0f,                             // No Spell Warning Delay
                              0.1f,                             // Initial Delay
                              6.0f);                            // Interval
        */

        // Fire golem lays patches of fire whereever he walks
        eE_CreateEvent_Damage("GOLEM_FIRE_LayFire",             // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_GOLEM_FIRE,                 // Event Tag
                              RESREF_GOLEM_FIRE,                // Owner
                              -1,                               // Quantity
                              RESREF_GOLEM_FIRE,                // Target
                              eE_DAMAGE_OBJECTTYPE_PC,          // ObjectType that will be damaged
                              eE_TARGETMETHOD_FIXED,            // Target Method
                              eE_OBJECTLOCATION_LOCATION,       // Target Type
                              -1,                               // VFX
                              DAMAGE_FIRE_PLACEABLE,            // VFX_Placeable
                              DAMAGE_FIRE_AMOUNT,               // Damage Amount
                              DAMAGE_TYPE_FIRE,                 // Damage Type
                              DAMAGE_FIRE_TICKS,                // Tick Count
                              DAMAGE_FIRE_DURATION,             // Damage Duration
                              0,                                // Warning VFX
                              "",                               // Warning Placeable
                              0.0f,                             // Warning Delay
                              SHAPE_SPHERE,                     // Shape Type
                              1.5f,                             // Shape Size
                              0.0f,                             // Safe Zone
                              0.0f,                             // Initial Delay
                              DAMAGE_FIRE_INTERVAL);            // Interval

        // Fire Golem damages all melee players with fire every round
        eE_CreateEvent_Damage("GOLEM_Fire_MeleeDamage",         // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_GOLEM_FIRE,                 // Event Tag
                              RESREF_GOLEM_FIRE,                // Owner
                              -1,                               // Quantity
                              RESREF_GOLEM_FIRE,                // Target
                              eE_DAMAGE_OBJECTTYPE_PC,          // ObjectType that will be damaged
                              eE_TARGETMETHOD_FIXED,            // Target Method
                              eE_OBJECTLOCATION_OBJECT,         // Target Type
                              VFX_IMP_FLAME_M,                  // VFX
                              "",                               // VFX_Placeable
                              DAMAGE_FIRE_CLOSERANGE_AMOUNT,    // Damage Amount
                              DAMAGE_TYPE_FIRE,                 // Damage Type
                              0,                                // Damage Repeats
                              0.0f,                             // Damage Duration
                              0,                                // Warning VFX
                              "",                               // Warning Placeable
                              0.0f,                             // Warning Delay
                              SHAPE_SPHERE,                     // Shape Type
                              4.0f,                             // Shape Size
                              0.0f,                             // Safe Zone
                              0.0f,                             // Initial Delay
                              DAMAGE_FIRE_CLOSERANGE_INTERVAL); // Interval

        // Ice golem phase

        // Activate Ice Golem
        eE_CreateEvent_Action("UNPARALYZE_Golem_Ice",           // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_GOLEM_ICE,                  // Event Tag
                              RESREF_GOLEM_ICE,                 // Owner
                              -1,                               // Quantity
                              eE_VAR_EVENT_ACTION_REMOVEEFFECT, // Remove Effect
                              EFFECT_TAG_PARALYZE);             // Effect Tag to Remove

        eE_CreateEvent_Effect("FX_HEAL_Golem_Ice",              // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_GOLEM_ICE,                  // Event Tag
                              eE_EVENTOWNER_NONE,               // Owner
                              -1,                               // Quantity
                              0.0f,                             // Delay between Owners / Tags
                              RESREF_GOLEM_ICE,                 // Target object
                              eE_TARGETMETHOD_FIXED,            // Target Method
                              DURATION_TYPE_INSTANT,            // Duration Type
                              0.0f,                             // Duration
                              eE_EFFECT_TYPE_IMPACT,            // eE Effect Type
                              eE_EFFECT_EFFECT_HEAL,            // Effect
                              "10000",                          // Effect variables
                              VFX_IMP_PULSE_COLD,               // Visual Effect
                              "",                               // Effect Tag
                              0.1f);                            // Initial Delay

        eE_CreateEvent_Special("UNPLOT_Golem_Ice",              // Event Name
                               ENCOUNTER_TAG,                   // Encounter Tag
                               EVENT_GOLEM_ICE,                 // Event Tag
                               RESREF_GOLEM_ICE,                // Owner
                               eE_VAR_SPECIAL_SETMORTALALL,     // Event ID: Activate Plot Flag
                               RESREF_GOLEM_ICE,                // Target Tag
                               0.2f);                           // Initial Delay

        // Ice golem freezes a random player
        // They create a beam to the target first and then freeze it
        eE_CreateEvent_Effect("FX_FREEZEBEAM",
                              ENCOUNTER_TAG,
                              EVENT_GOLEM_ICE,
                              RESREF_GOLEM_ICE,
                              -1,
                              0.0f,
                              eE_SPAWNTAG_PC,
                              eE_TARGETMETHOD_RANDOM,
                              DURATION_TYPE_TEMPORARY,
                              1.0f,
                              eE_EFFECT_TYPE_BEAM,
                              0,
                              "",
                              VFX_BEAM_COLD,
                              "vfxBeamCold",
                              0.5f,
                              ICE_FREEZE_INTERVAL);

        eE_CreateEvent_Effect("FX_FREEZE_Player",               // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_GOLEM_ICE,                  // Event Tag
                              RESREF_GOLEM_ICE,                 // Owner
                              1,                                // Quantity
                              0.0f,                             // Delay between Owners / Tags
                              eE_SPAWNTAG_PC,                   // Target object
                              eE_TARGETMETHOD_LASTTARGET_RANDOM,// Target Method
                              DURATION_TYPE_TEMPORARY,          // Duration Type
                              ICE_FREEZE_DURATION,              // Duration
                              eE_EFFECT_TYPE_DURATION,          // eE Effect Type
                              eE_EFFECT_EFFECT_CUTSCENEPARALYZE,// Effect
                              "",                               // Effect variables (none needed)
                              VFX_DUR_ICESKIN,                  // Visual Effect
                              "FreezePC",                       // Effect Tag
                              0.55f,                            // Initial Delay
                              ICE_FREEZE_INTERVAL);             // Interval

        // Ice Golem damages all players with cold every round
        eE_CreateEvent_Damage("GOLEM_Ice_Damage",               // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_GOLEM_ICE,                  // Event Tag
                              RESREF_GOLEM_ICE,                 // Owner
                              -1,                               // Quantity
                              RESREF_GOLEM_ICE,                 // Target
                              eE_DAMAGE_OBJECTTYPE_PC,          // ObjectType that will be damaged
                              eE_TARGETMETHOD_FIXED,            // Target Method
                              eE_OBJECTLOCATION_OBJECT,         // Target Type
                              VFX_IMP_PULSE_COLD,               // VFX
                              "",                               // VFX_Placeable
                              DAMAGE_ICE_AMOUNT,                // Damage Amount
                              DAMAGE_TYPE_COLD,                 // Damage Type
                              0,                                // Tick Count
                              0.0f,                             // Damage Duration
                              0,                                // Warning VFX
                              "",                               // Warning Placeable
                              0.0f,                             // Warning Delay
                              SHAPE_SPHERE,                     // Shape Type
                              40.0f,                            // Shape Size
                              0.0f,                             // Safe Zone
                              0.0f,                             // Initial Delay
                              DAMAGE_ICE_INTERVAL);             // Interval

        // Activate Earth Golem
        eE_CreateEvent_Action("UNPARALYZE_Golem_Earth",         // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_GOLEM_EARTH,                // Event Tag
                              RESREF_GOLEM_EARTH,               // Owner
                              -1,                               // Quantity
                              eE_VAR_EVENT_ACTION_REMOVEEFFECT, // Remove Effect
                              EFFECT_TAG_PARALYZE);             // Effect Tag to Remove

        eE_CreateEvent_Effect("FX_HEAL_Golem_Earth",            // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_GOLEM_EARTH,                // Event Tag
                              eE_EVENTOWNER_NONE,               // Owner
                              -1,                               // Quantity
                              0.0f,                             // Delay between Owners / Tags
                              RESREF_GOLEM_EARTH,               // Target object
                              eE_TARGETMETHOD_FIXED,            // Target Method
                              DURATION_TYPE_INSTANT,            // Duration Type
                              0.0f,                             // Duration
                              eE_EFFECT_TYPE_IMPACT,            // eE Effect Type
                              eE_EFFECT_EFFECT_HEAL,            // Effect
                              "10000",                          // Effect variables
                              VFX_IMP_PULSE_COLD,               // Visual Effect
                              "",                               // Effect Tag
                              0.1f);                            // Initial Delay

        eE_CreateEvent_Special("UNPLOT_Golem_Earth",            // Event Name
                               ENCOUNTER_TAG,                   // Encounter Tag
                               EVENT_GOLEM_EARTH,               // Event Tag
                               RESREF_GOLEM_EARTH,              // Owner
                               eE_VAR_SPECIAL_SETMORTALALL,     // Event ID: Activate Plot Flag
                               RESREF_GOLEM_EARTH,              // Target Tag
                               0.2f);                           // Initial Delay

        // The earth golem casts Spike Trap below players after a short warning,
        eE_CreateEvent_Damage("GOLEM_Earth_Spike",              // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_GOLEM_EARTH,                // Event Tag
                              RESREF_GOLEM_EARTH,               // Owner
                              -1,                               // Quantity
                              eE_SPAWNTAG_PC,                   // Target
                              eE_DAMAGE_OBJECTTYPE_PC,          // ObjectType that will be damaged
                              eE_TARGETMETHOD_RANDOM,           // Target Method
                              eE_OBJECTLOCATION_LOCATION,       // Target Type
                              VFX_IMP_SPIKE_TRAP,               // VFX
                              "",                               // VFX_Placeable
                              DAMAGE_SPIKE_AMOUNT,              // Damage Amount
                              DAMAGE_TYPE_PIERCING,             // Damage Type
                              0,                                // Tick Count
                              0.0f,                             // Damage Duration
                              VFX_IMP_DUST_EXPLOSION,           // Warning VFX
                              "",                               // Warning Placeable
                              DAMAGE_SPIKE_WARNINGDELAY,        // Warning Delay
                              SHAPE_SPHERE,                     // Shape Type
                              2.0f,                             // Shape Size
                              0.0f,                             // Safe Zone
                              3.0f,                             // Initial Delay
                              DAMAGE_SPIKE_INTERVAL);           // Interval

        // Open the boss door
        eE_CreateEvent_Special("UNLOCK_Boss_Door",              // Event Name
                               ENCOUNTER_TAG,                   // Encounter Tag
                               EVENT_BOSS,                      // Event Tag
                               eE_EVENTOWNER_NONE,              // Owner
                               eE_VAR_SPECIAL_OPENALL,          // Event ID: Open Door
                               DOOR_BOSSROOM);                  // Target Tag

        // Tell the boss to go attack a random player
        eE_CreateEvent_Action("ATTACK_Player",                  // Event Name
                              ENCOUNTER_TAG,                    // Encounter Tag
                              EVENT_BOSS,                       // Event Tag
                              RESREF_BOSS,                      // Owner
                              -1,                               // Quantity
                              eE_VAR_EVENT_ACTION_ATTACK,       // Action
                              eE_SPAWNTAG_PC,                   // Target
                              eE_TARGETMETHOD_RANDOM,           // Target Method
                              eE_OBJECTLOCATION_OBJECT,         // Target Type
                              -1,                               // Spell
                              -1,                               // Spell Warning
                              0.0f,                             // Spell Warning Delay
                              0.25f);                           // Initial Delay

        // Unlock entrance door
        if (DOORS_LOCK)
        {
            eE_CreateEvent_Special("UNLOCK_Entrance",               // Event Name
                                   ENCOUNTER_TAG,                   // Encounter Tag
                                   EVENT_VICTORY,                   // Event Tag
                                   eE_EVENTOWNER_NONE,              // Owner
                                   eE_VAR_SPECIAL_OPENALL,          // Event ID: Activate Plot Flag
                                   DOOR_ENTRANCE,                   // Target Tag
                                   0.0f,                            // Initial Delay
                                   0.0f,                            // Interval
                                   0,                               // Max Repeats
                                   eE_UNDO_MANUAL);                 // Manual Undo
        }
    }
}
