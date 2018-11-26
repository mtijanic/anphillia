/************************************************************************
 * script name  : eE_inc_const
 * created by   : eyesolated
 * date         : 2011/6/1
 *
 * description  : Provides constants for eyesolated Encounters
 *
 * changes      : 2011/6/1 - eyesolated - Initial creation
 ************************************************************************/

/************************************************************************
 * STRUCT DECLARATIONS
 ************************************************************************/

// Structure holding the various Event Types
struct eE_EVENT_ENTITYEVENTS
{
   string OnSpawn;
   string OnDeath;
   string OnDamaged;
};

// Structure holding Data about Entities
struct eE_EVENT_ENTITY
{
   string Blueprint;
   int Quantity;
   int MaxConcurrent;
   string SpawnAt;
   int SpawnMethod;
   float SpawnDelay;
   int SpawnEffect;
   string Tag;
};

// Structure holding Data about Special Events
struct eE_EVENT_SPECIAL
{
   int EventID;
   string Tag;
};

// Structure holding Data about VFX Events
struct eE_EVENT_EFFECT
{
   string Owner;
   object OwnerObject;
   int Quantity;
   float Delay;
   int TargetMethod;
   int DurationType;
   float Duration;
   int Effect;
   int Effect_Var1;
   int Effect_Var2;
   int Effect_Var3;
   int Effect_Var4;
   int Effect_Var5;
   int Effect_Var6;
   int VisualEffect;
   int EffectType;
   string EffectTag;
   string Tag;
};

// Structure holding Data about Damage Events
struct eE_EVENT_DAMAGE
{
   string Owner;
   object OwnerObject;
   int Quantity;
   int TargetMethod;
   int ObjectOrLocation;
   int DamageAmount;
   int DamageType;
   int DamageRepeats;
   int Effect;
   string EffectPlaceable;
   float Duration;
   int WarningEffect;
   string WarningPlaceable;
   float WarningDelay;
   string Tag;
   int ObjectTypes;
   int ShapeType;
   float ShapeSize;
   float SafeZone;
};

// Structure holding Data about Action Events
struct eE_EVENT_ACTION
{
   string Owner;
   object OwnerObject;
   int EventID;
   string Tag;
   int Quantity;
   int TargetMethod;
   int ObjectOrLocation;
   int Spell;
   int SpellWarning;
   float SpellWarningDelay;
};

// Structure holding Variables necessary to enable basic handling of an Event
struct eE_EVENT
{
   int Type;
   int Mode;
   string Owner;
   object OwnerObject;
   float StartDelay;
   float Interval;
   int MaxRepeat;
   int AutoUndo;
   int KeyEvent;
};

/************************************************************************
 * ENCOUNTER OBJECT
 ************************************************************************/

// Encounter Status
const string eE_VAR_ENCOUNTER_STATUS          = "eE_Status";
const int eE_ENCOUNTER_STATUS_IDLE            = 0;
const int eE_ENCOUNTER_STATUS_INITIALIZING    = 1;
const int eE_ENCOUNTER_STATUS_INITIALIZED     = 2;
const int eE_ENCOUNTER_STATUS_INPROGRESS      = 3;
const int eE_ENCOUNTER_STATUS_ONCOOLDOWN      = 4;
const int eE_ENCOUNTER_STATUS_RESETTING       = 5;

// Encounter Message Level
const string eE_VAR_ENCOUNTER_MESSAGELEVEL    = "Message Level";
const int eE_MESSAGELEVEL_NONE            = 0;
const int eE_MESSAGELEVEL_LOW             = 1;
const int eE_MESSAGELEVEL_DEBUG_LOG       = 2;
const int eE_MESSAGELEVEL_DEBUG_FULL      = 3;

// Encounter Name - if the value this is "", GetName(EncounterObject) is used instead
const string eE_VAR_ENCOUNTERNAME             = "Encounter Name";

// The Waypoint associated with creating this encounter
const string eE_VAR_WAYPOINT                  = "eE_EncWayPoint";

// Event Owner Array (Stored on the Encounter Object)
const string eE_VAR_EVENTOWNERS               = "eE_EventOwners";

// Encounter Area Array Index
const string eE_VAR_ENCOUNTER_ARRAYINDEX      = "EncAreaIndex";

// Encounter Enabled/Disabled
const string eE_VAR_ENCOUNTER_DISABLED        = "Disabled";
const int eE_ENABLED = 0;
const int eE_DISABLED = 1;

// Encounter Events
const string eE_VAR_ACTIVEKEYEVENTS           = "eE_ActiveEvents";
const string eE_VAR_REGISTEREDEVENTS          = "eE_RegEvents";

// Encounter Size
const string eE_VAR_SIZE                      = "ee_Size";
const int eE_ENCOUNTER_SIZE_AREA              = 0;
const int eE_ENCOUNTER_SIZE_TRIGGER           = 1;

// Auto Initialize
const string eE_VAR_ENCOUNTER_AUTOINI         = "Auto Initialize";
const int eE_ENCOUNTER_AUTOINI_DISABLED       = 0;
const int eE_ENCOUNTER_AUTOINI_ENABLED        = 1;

// Encounter Despawn Check Interval
const string eE_VAR_DESPAWNINTERVAL           = "Despawn Interval";

// Encounter Respawn Cooldown
const string eE_VAR_COOLDOWN                  = "Respawn Cooldown";

// Sets wheter the encounter goes on cooldown after a wipe
const string eE_VAR_CDAFTERWIPE               = "CD after Wipe";
const int eE_VAR_CDAFTERWIPE_DISABLED         = 0;
const int eE_VAR_CDAFTERWIPE_ENABLED          = 1;

// Encounter Condition
const string eE_VAR_CONDITION                 = "Condition";
const int eE_VAR_CONDITION_NONE               = 0;
const int eE_VAR_CONDITION_DAYTIME            = 1;
const int eE_VAR_CONDITION_NIGHTTIME          = 2;

// Event Tags
const string eE_VAR_INITIALIZETAG             = "Initialize Event Tag";
const string eE_VAR_EVENTTAG                  = "InProgress Event Tag";

// Player List
const string eE_VAR_PLAYERLIST                = "eE_PCs";
const string eE_VAR_ACTIVEPLAYERS             = "eE_ActPCs";

// Player Array
const string eE_VAR_ARRAY_PLAYERS             = "eE_Array_PC";

// Event List
const string eE_VAR_EVENTS_PREFIX             = "eE_Event";

/************************************************************************
 * EVENT OBJECT
 ************************************************************************/

// Event Types
const string eE_VAR_EVENTTYPE                 = "Type";
const int eE_EVENTTYPE_CREATURE               = 1;
const int eE_EVENTTYPE_PLACEABLE              = 2;
const int eE_EVENTTYPE_SPECIAL                = 3;
const int eE_EVENTTYPE_ACTION                 = 4;
const int eE_EVENTTYPE_EXECUTESCRIPT          = 5;
const int eE_EVENTTYPE_EFFECT                 = 6;
const int eE_EVENTTYPE_DAMAGE                 = 7;

// Event Phase
const string eE_VAR_EVENTPHASE                = "Phase";

// Event Encounter
const string eE_VAR_EVENTENCOUNTER            = "eE_Encounter";

// Event OnExhaust
const string eE_VAR_EVENT_ONEXHAUST           = "OnExhaust Event Tag";

// Event Status
const string eE_VAR_EVENTSTATUS               = "Status";
const int eE_EVENTSTATUS_INACTIVE             = 0;
const int eE_EVENTSTATUS_ACTIVE               = 1;

// Event Creature Count
const string eE_VAR_EVENTCREATURECOUNT        = "eE_CreatureCount";

// Event Mode
const string eE_VAR_EVENTMODE                 = "Mode";
const int eE_EVENTMODE_CREATE                 = 0;
const int eE_EVENTMODE_UNDO                   = 1;

// Event UnDo
const string eE_VAR_EVENTUNDO                 = "Automatic Undo";
const int eE_UNDO_MANUAL                      = 1;
const int eE_UNDO_AUTOMATIC                   = 0;

// Event Owner
const string eE_VAR_EVENTOWNER                = "Owner";
const string eE_VAR_EVENTOWNER_OBJECT         = "eE_OwnerObject";
// Special Owner NONE
const string eE_EVENTOWNER_NONE               = "";
// Special Owner SELF
const string eE_EVENTOWNER_SELF               = "SELF";
// Special Owner ENCOUNTER
const string eE_EVENTOWNER_ENCOUNTER          = "ENCOUNTER";

// Event ID
const string eE_VAR_EVENTID                   = "Event ID";

// Key Event
const string eE_VAR_KEYEVENT                  = "Key Event";

// Event Variables
const string eE_VAR_ENTITY_BLUEPRINT          = "Blueprint";
const string eE_VAR_ENTITY_INITIALDELAY       = "Initial Delay";
const string eE_VAR_ENTITY_INTERVAL           = "Interval";
const string eE_VAR_ENTITY_QUANTITY           = "Quantity";
const string eE_VAR_ENTITY_MAXCONCURRENT      = "Maximum Concurrent";
const string eE_VAR_ENTITY_SPAWNAT            = "SpawnAt";
const string eE_VAR_ENTITY_SPAWNMETHOD        = "SpawnMethod";
const string eE_VAR_ENTITY_SPAWNDELAY         = "SpawnDelay";
const string eE_VAR_ENTITY_SPAWNEFFECT        = "SpawnEffect";
const string eE_VAR_ENTITY_TAG                = "Tag";
const string eE_VAR_ENTITY_ONSPAWN            = "OnSpawn Event Tag";
const string eE_VAR_ENTITY_ONDEATH            = "OnDeath Event Tag";
const string eE_VAR_ENTITY_ONDAMAGED          = "OnDamaged Event Tag";
const string eE_VAR_ENTITY_MAXREPEAT          = "Maximum Repeats";
const string eE_VAR_ENTITY_CURRENTREPEAT      = "eE_CurrentRepeat";
const string eE_VAR_EVENT_SCRIPTNAME          = "Scriptname";
const string eE_VAR_ENTITY_MAXDYNAMICQUANTITY = "MaxDynQuantity";

// Action Event Target Method Value
const string eE_VAR_TARGETMETHOD              = "TargetMethod";
const int eE_TARGETMETHOD_RANDOM              = 0;
const int eE_TARGETMETHOD_FIXED               = 1;
const int eE_TARGETMETHOD_RANDOMINDIVIDUAL    = 2;
const int eE_TARGETMETHOD_FIXEDINDIVIDUAL     = 3;
const int eE_TARGETMETHOD_NEARESTINDIVIDUAL   = 4;
const int eE_TARGETMETHOD_LASTTARGET_NEAREST  = 5;
const int eE_TARGETMETHOD_LASTTARGET_RANDOM   = 6;

// The variable to save the last target in
const string eE_VAR_LASTTARGET                = "eE_LastTarget";

// The variable to save already handled dmg percentages in
const string eE_VAR_ONDAMAGED_EXECUTED        = "eE_OnDmg_Executed";

// Action Event ObjectOrLocation
const string eE_VAR_OBJECTLOCATION            = "ObjectORLocation";
const int eE_OBJECTLOCATION_OBJECT            = 0;
const int eE_OBJECTLOCATION_LOCATION          = 1;

// Action Event Spell Variables
const string eE_VAR_SPELL                     = "Spell";
const string eE_VAR_SPELLWARNING              = "Spell Warning";
const string eE_VAR_SPELLWARNINGDELAY         = "Spell Warning Delay";

// Effect Event Variables
const string eE_VAR_EFFECT_DURATIONTYPE       = "DurationType";
const string eE_VAR_EFFECT_DURATION           = "Duration";
const string eE_VAR_EFFECT_EFFECT             = "Effect";
const string eE_VAR_EFFECT_EFFECT_VARS        = "Effect Variables";
const string eE_VAR_EFFECT_VFX                = "VFX";
const string eE_VAR_EFFECT_VFX_PLACEABLE      = "VFXPlaceable";
const string eE_VAR_EFFECT_TYPE               = "EffectType";
const string eE_VAR_EFFECT_DELAY              = "EffectDelay";
const string eE_VAR_EFFECT_EFFECTTAG          = "EffectTag";
const int eE_EFFECT_TYPE_BEAM                 = 0;
const int eE_EFFECT_TYPE_COMBAT               = 1;
const int eE_EFFECT_TYPE_IMPACT               = 2;
const int eE_EFFECT_TYPE_FNF                  = 3;
const int eE_EFFECT_TYPE_DURATION             = 4;
const int eE_EFFECT_TYPE_AOE_LOCATION         = 5;
const int eE_EFFECT_TYPE_AOE_OBJECT           = 6;

// Effect_None
const int eE_NULL                             = -1;

// Effect Types (needs up to 6 int vars), atm effect using variables are not implemented
const int eE_EFFECT_EFFECT_ABILITYDECREASE    = 1;
const int eE_EFFECT_EFFECT_ABILITYINCREASE    = 2;
const int eE_EFFECT_EFFECT_ACDECREASE         = 3;
const int eE_EFFECT_EFFECT_ACINCREASE         = 4;
const int eE_EFFECT_EFFECT_APPEAR             = 5;
const int eE_EFFECT_EFFECT_ATTACKDECREASE     = 6;
const int eE_EFFECT_EFFECT_ATTACKINCREASE     = 7;
const int eE_EFFECT_EFFECT_BLINDNESS          = 8;
const int eE_EFFECT_EFFECT_CHARMED            = 9;
const int eE_EFFECT_EFFECT_CONCEALMENT        = 10;
const int eE_EFFECT_EFFECT_CONFUSED           = 11;
const int eE_EFFECT_EFFECT_CURSE              = 12;
const int eE_EFFECT_EFFECT_CUTSCENEDOMINATED  = 13;
const int eE_EFFECT_EFFECT_CUTSCENEGHOST      = 14;       // 6 variables...
const int eE_EFFECT_EFFECT_CUTSCENEIMMOBILIZE = 15;
const int eE_EFFECT_EFFECT_CUTSCENEPARALYZE   = 16;
const int eE_EFFECT_EFFECT_DAMAGEDECREASE     = 17;
const int eE_EFFECT_EFFECT_DAMAGEIMMUNITYDECREASE = 18;
const int eE_EFFECT_EFFECT_DAMAGEIMMUNITYINCREASE = 19;
const int eE_EFFECT_EFFECT_DAMAGEINCREASE     = 20;
const int eE_EFFECT_EFFECT_DAMAGEREDUCTION    = 21;
const int eE_EFFECT_EFFECT_DAMAGERESISTANCE   = 22;
const int eE_EFFECT_EFFECT_DAMAGESHIELD       = 23;
const int eE_EFFECT_EFFECT_DARKNESS           = 24;
const int eE_EFFECT_EFFECT_DAZED              = 25;
const int eE_EFFECT_EFFECT_DEAF               = 26;
const int eE_EFFECT_EFFECT_DISAPPEAR          = 27;
const int eE_EFFECT_EFFECT_DISEASE            = 28;
const int eE_EFFECT_EFFECT_DISPELMAGICALL     = 29;
const int eE_EFFECT_EFFECT_DISPELMAGICBEAST   = 30;
const int eE_EFFECT_EFFECT_DOMINATED          = 31;
const int eE_EFFECT_EFFECT_ENTANGLE           = 32;
const int eE_EFFECT_EFFECT_ETHEREAL           = 33;
const int eE_EFFECT_EFFECT_FRIGHTENED         = 34;
const int eE_EFFECT_EFFECT_HASTE              = 35;
const int eE_EFFECT_EFFECT_HEAL               = 36;
const int eE_EFFECT_EFFECT_IMMUNITY           = 37;
const int eE_EFFECT_EFFECT_INVISIBILITY       = 38;
const int eE_EFFECT_EFFECT_KNOCKDOWN          = 39;
const int eE_EFFECT_EFFECT_MISSCHANCE         = 40;
const int eE_EFFECT_EFFECT_MODIFYATTACKS      = 41;
const int eE_EFFECT_EFFECT_MOVEMENTSPEEDDECREASE = 42;
const int eE_EFFECT_EFFECT_MOVEMENTSPEEDINCREASE = 43;
const int eE_EFFECT_EFFECT_NEGATIVELEVEL      = 44;
const int eE_EFFECT_EFFECT_PARALYZE           = 45;
const int eE_EFFECT_EFFECT_PETRIFY            = 46;
const int eE_EFFECT_EFFECT_POISON             = 47;
const int eE_EFFECT_EFFECT_POLYMORPH          = 48;
const int eE_EFFECT_EFFECT_REGENERATE         = 49;
const int eE_EFFECT_EFFECT_RESURRECTION       = 50;
const int eE_EFFECT_EFFECT_SANCTUARY          = 51;
const int eE_EFFECT_EFFECT_SAVINGTHROWDECREASE= 52;
const int eE_EFFECT_EFFECT_SAVINGTHROWINCREASE= 53;
const int eE_EFFECT_EFFECT_SEEINVISIBLE       = 54;
const int eE_EFFECT_EFFECT_SILENCE            = 55;
const int eE_EFFECT_EFFECT_SKILLDECREASE      = 56;
const int eE_EFFECT_EFFECT_SKILLINCREASE      = 57;
const int eE_EFFECT_EFFECT_SLEEP              = 58;
const int eE_EFFECT_EFFECT_SLOW               = 59;
const int eE_EFFECT_EFFECT_SPELLFAILURE       = 60;
const int eE_EFFECT_EFFECT_SPELLIMMUNITY      = 61;
const int eE_EFFECT_EFFECT_SPELLLEVELABSORPTION = 62;
const int eE_EFFECT_EFFECT_SPELLRESISTANCEDECREASE = 63;
const int eE_EFFECT_EFFECT_SPELLRESISTANCEINCREASE = 64;
const int eE_EFFECT_EFFECT_STUNNED            = 65;
const int eE_EFFECT_EFFECT_TEMPORARYHITPOINTS = 66;
const int eE_EFFECT_EFFECT_TIMESTOP           = 67;
const int eE_EFFECT_EFFECT_TRUESEEING         = 68;
const int eE_EFFECT_EFFECT_TURNED             = 69;
const int eE_EFFECT_EFFECT_TURNRESISTANCEDECREASE = 70;
const int eE_EFFECT_EFFECT_TURNRESISTANCEINCREASE = 71;
const int eE_EFFECT_EFFECT_ULTRAVISION        = 72;
const int eE_EFFECT_EFFECT_DAMAGE             = 73;
const int eE_EFFECT_EFFECT_DISAPPEARAPPEAR    = 74;

// Damage FX Event Variables
const string eE_VAR_DAMAGE_AMOUNT             = "Damage Amount";
const string eE_VAR_DAMAGE_TYPE               = "Damage Type";
const string eE_VAR_DAMAGE_REPEATS            = "Damage Repeats";
const string eE_VAR_DAMAGE_DAMAGE_SHAPETYPE   = "Damage Shape Type";
const string eE_VAR_DAMAGE_DAMAGE_SHAPESIZE   = "Damage Shape Size";
const string eE_VAR_DAMAGE_DAMAGE_SAFEZONE    = "Damage Safe Zone";
const string eE_VAR_DAMAGE_WARNING            = "Warning VFX";
const string eE_VAR_DAMAGE_WARNINGPLACEABLE   = "Warning Placeable";
const string eE_VAR_DAMAGE_WARNINGDELAY       = "Warning Delay";
const string eE_VAR_DAMAGE_OBJECTTYPES        = "Object Types";
const int eE_DAMAGE_OBJECTTYPE_PC             = 1;
const int eE_DAMAGE_OBJECTTYPE_CREATURE       = 2;
const int eE_DAMAGE_OBJECTTYPE_PLACEABLE      = 4;

// eE Tag for effects (needed to identify eE effects for automatic undo
const string eE_VAR_EFFECT_TAG                = "eE_Effect";

// Special SPAWNAT Value PC Spawn Tag
const string eE_SPAWNTAG_PC                   = "PC";

// Spawn Method
const string eE_VAR_SPAWNMETHOD               = "Spawn Method";
const int eE_SPAWNMETHOD_RANDOM               = 0;
const int eE_SPAWNMETHOD_FIXED                = 1;

// Special Event IDs
const int eE_VAR_SPECIAL_ENCOUNTER_DISABLE    = 1;
const int eE_VAR_SPECIAL_ENCOUNTER_ENABLE     = 2;
const int eE_VAR_SPECIAL_ENCOUNTER_INITIALIZE = 3;
const int eE_VAR_SPECIAL_ENCOUNTER_START      = 4;
const int eE_VAR_SPECIAL_ENCOUNTER_END        = 5;
const int eE_VAR_SPECIAL_ENCOUNTER_RESET      = 6;
const int eE_VAR_SPECIAL_OPENNEAREST          = 7;
const int eE_VAR_SPECIAL_OPENALL              = 8;
const int eE_VAR_SPECIAL_UNLOCKNEAREST        = 9;
const int eE_VAR_SPECIAL_UNLOCKALL            = 10;
const int eE_VAR_SPECIAL_CLOSENEAREST         = 11;
const int eE_VAR_SPECIAL_CLOSEALL             = 12;
const int eE_VAR_SPECIAL_LOCKNEAREST          = 13;
const int eE_VAR_SPECIAL_LOCKALL              = 14;
const int eE_VAR_SPECIAL_DESTROYNEAREST       = 15;
const int eE_VAR_SPECIAL_DESTROYALL           = 16;
const int eE_VAR_SPECIAL_KILLNEAREST          = 17;
const int eE_VAR_SPECIAL_KILLALL              = 18;
const int eE_VAR_SPECIAL_FORCERESTALL         = 19;
const int eE_VAR_SPECIAL_SOUNDOBJECTPLAY      = 20;
const int eE_VAR_SPECIAL_SETPLOTFLAGNEAREST   = 21;
const int eE_VAR_SPECIAL_SETPLOTFLAGALL       = 22;
const int eE_VAR_SPECIAL_UNSETPLOTFLAGNEAREST = 23;
const int eE_VAR_SPECIAL_UNSETPLOTFLAGALL     = 24;
const int eE_VAR_SPECIAL_SETIMMORTALNEAREST   = 25;
const int eE_VAR_SPECIAL_SETIMMORTALALL       = 26;
const int eE_VAR_SPECIAL_SETMORTALNEAREST     = 27;
const int eE_VAR_SPECIAL_SETMORTALALL         = 28;

// Action Event IDs
const int eE_VAR_EVENT_ACTION_ATTACK          = 1;
const int eE_VAR_EVENT_ACTION_CASTSPELL       = 2;
const int eE_VAR_EVENT_ACTION_CASTFAKESPELL   = 3;
const int eE_VAR_EVENT_ACTION_OPENDOOR        = 4;
const int eE_VAR_EVENT_ACTION_CLOSEDOOR       = 5;
const int eE_VAR_EVENT_ACTION_JUMPTO          = 6;
const int eE_VAR_EVENT_ACTION_WALKTO          = 7;
const int eE_VAR_EVENT_ACTION_RUNTO           = 8;
const int eE_VAR_EVENT_ACTION_INTERACT        = 9;
const int eE_VAR_EVENT_ACTION_LOCK            = 10;
const int eE_VAR_EVENT_ACTION_UNLOCK          = 11;
const int eE_VAR_EVENT_ACTION_SPEAKSTRING     = 12;
const int eE_VAR_EVENT_ACTION_PLAYANIMATION   = 13;
const int eE_VAR_EVENT_ACTION_SETAPPEARANCE   = 14;
const int eE_VAR_EVENT_ACTION_REMOVEEFFECT    = 15;
const int eE_VAR_EVENT_ACTION_FLOATINGTEXT    = 16;

/************************************************************************
 * ENTITY OBJECT
 ************************************************************************/

// Associated Encounter
const string eE_VAR_ENTITY_ENCOUNTER          = "Entity Encounter";

// Associated Event
const string eE_VAR_ENTITY_EVENT              = "Entity Event";

// Event Scripts
const string eE_VAR_ENTITY_AI_ONDEATH         = "OnDeath_Original";
const string eE_VAR_ENTITY_AI_ONDAMAGED       = "OnDamaged_Original";
const string eE_VAR_ENTITY_AI_ONPERCEPTION    = "OnPerception_Original";

/************************************************************************
 * AREA
 ************************************************************************/

// Encounter Array
const string eE_VAR_AREA_ENCOUNTERARRAY_INI   = "EncArray_Ini";
const string eE_VAR_AREA_ENCOUNTERARRAY_PROG  = "EncArray_InProgress";
