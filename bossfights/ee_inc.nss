/************************************************************************
 * script name  : eE_inc
 * created by   : eyesolated
 * date         : 2011/6/1
 *
 * description  : The central include file for eyesolated Encounters
 *
 * changes      : 2010/6/1 - eyesolated - Initial creation
 ************************************************************************/

// Includes
#include "x0_i0_stringlib"
#include "eE_inc_const"
#include "eE_cfg"
#include "eas_inc"

// Function Declarations

// Sends a Message to all Players that are actively participating in oEncounter, if
// oEncounter's MessageLevel is high enough
// oEncounter   : the Encounter Object to use
// sMessage     : the Message to send to Players
// iMessageLevel: the MessageLevel the Encounter must be set to at minimum to send the Message
void eE_Message(object oEncounter, string sMessage, int iMessageLevel);

// Sends a Debug Message to all Players. This function just calls eE_Message with iMessageLevel set
// to eE_MESSAGELEVEL_DEBUG.
void eE_DebugMSG(object oEncounter, string sMessage);

// Sends a Message to all Players that are actively participating in oEncounter
// oEncounter   : the Encounter Object to use
// sDebugMessage: the Message to send to Players
void eE_SendMessageToActivePlayers(object oEncounter, string sMessage);

// Returns the name of oEncounter
string eE_GetEncounterName(object oEncounter);

// Returns the nth nearest Event Object
// oEncounter: the Encounter Object to use
// sTag      : the Tag of the Event Object that is being searched
// nth       : look for the nth nearest Object
object eE_GetEncounterEvent(object oEncounter, string sTag, int nth = 1);

// Returns the Size of oEncounter
// oEncounter: the Encounter Object
int eE_GetEncounterSize(object oEncounter);

// Adds an encounter to an Area (using an eas Array)
// This is used for cleanup. Only Encounters that enter the Status eE_ENCOUNTER_STATUS_INITIALIZED
// are added to an Area's Array. When all players have left the Area, all Encounters
// in this Array get reset
// oEncounter: the Encounter Object
// oArea     : the Area on which to save the Array
// sArray    : the Array to use (eE_VAR_AREA_ENCOUNTERARRAY_*)
void eE_Encounter_AddToArea(object oEncounter, object oArea, string sArray);

// Removes an encounter from an Area (using an eas Array)
// This is used for cleanup. As soon as an encounter leaves the Status eE_ENCOUNTER_STATUS_INITIALIZED
// it removes itself from this Array. When all players have left the Area, all Encounters
// in this Array get reset. As soon as the Array Size reaches 0 (no more Encounters registered),
// the Array deletes itself and frees memory.
// oEncounter: the Encounter Object
// oArea     : the Area on which to save the Array
// sArray    : the Array to use (eE_VAR_AREA_ENCOUNTERARRAY_*)
void eE_Encounter_RemoveFromArea(object oEncounter, object oArea, string sArray);

// Adds a player to the Active Player Array. This Array is used as a quick way to determine active players
// for functions where the current player location is irrelevant (e.g. Debug Message, Wipe Check...)
int eE_AddPlayerToArray(object oEncounter, object oPC);

// Returns the Player Object from the Active Player Array at the specified Index
object eE_GetPlayerFromArray(object oEncounter, int nIndex);

// Removes a player from the Active Player Array. This Array is used as a quick way to determine active players
// for functions where the current player location is irrelevant (e.g. Debug Message, Wipe Check...)
int eE_RemovePlayerFromArray(object oEncounter, object oPC);

// Returns the number of Active Players. This Array is used as a quick way to determine active players
// for functions where the current player location is irrelevant (e.g. Debug Message, Wipe Check...)
int eE_GetPlayerCountFromArray(object oEncounter);

// Returns a random active player by using the Array
object eE_GetRandomActivePlayerFromArray(object oEncounter);

// Sets the active Player Count for later use
// oEncounter  : the Encounter Object to save to
// iPlayerCount: the Player Count to save
void eE_SetActivePlayerCount(object oEncounter, int iPlayerCount);

// Returns the active Player Count
// oEncounter  : the Encounter Object to read the active players from
int eE_GetActivePlayerCount(object oEncounter);

// Creates a relation between a Player ID and a Player object. When using
// eE_CountActivePlayers with iSavePCObjects set to TRUE, this function is called.
// oEncounter  : the Encounter Object to use
// iPlayerID   : the Player ID to relate the PC to
// oPC         : the PC Object to relate to the ID
void eE_SetActivePlayer(object oEncounter, int iPlayerID, object oPC);

// Returns the PC Object from the active player with the given ID
// oEncounter  : the Encounter Object to use
// iPlayerID   : the player ID to retrieve the related Object from
object eE_GetActivePlayer(object oEncounter, int iPlayerID);

// Returns a random Active Player.
// oEncounter   : the Encounter Object to use
// iDoFreshCount: TRUE  - calls eE_CountActivePlayers to do a fresh count
//                FALSE - relies on information that was previously saved on
//                        oEncounter. If no such information is found, the returned
//                        object will either be OBJECT_INVALID or a previously saved
//                        player who possible isn't even active anymore. Use with caution
object eE_GetRandomActivePlayer(object oEncounter, int iDoFreshCount = FALSE);

// Returns the number of Active Players for an Encounter.
// oEncounter    : the Encounter Object to use
// iSavePCObjects: TRUE - saves all PC objects found on the oEncounter
//                 FALSE - does not save anything on oEncounter
int eE_CountActivePlayers(object oEncounter, int iSavePCObjects = FALSE);

// Wrapper around eE_GetActivePlayer and eE_GetPlayerFromArray
// Automatically uses the correct function depending on encounter Size Variable
object eE_GetEncounterPlayer(object oEncounter, int nth);

// Wrapper around eE_CountActivePlayers and eE_GetPlayerCountFromArray
// Automatically uses the correct function depending on encounter Size Variable
int eE_GetEncounterPlayerCount(object oEncounter);

// Wrapper around eE_GetRandomActivePlayer and eE_GetRandomActivePlayerFromArray
// Automatically uses the correct function depending on encounter Size Variable
object eE_GetRandomEncounterPlayer(object oEncounter);

// Sets the number of Locations for Objects with a specific Tag on an Encounter
// oEncounter    : the Encounter Object to save to
// sSpawnAt      : the Tag for which to set the location count
// iLocationCount: the Count to save
void eE_SetSpawnLocationCount(object oEncounter, string sSpawnAt, int iLocationCount);

// Returns the number of Locations for Objects with a specific Tag from an Encounter
// oEncounter    : the Encounter Object to load from
// sSpawnAt      : the Tag for which to get the location count
int eE_GetSpawnLocationCount(object oEncounter, string sSpawnAt);

// Creates a relation between a Location ID and a Location that was found by
// eE_CountSpawnLocations for later use.
// oEncounter  : the Encounter Object to use
// iLocationID : the Location ID to relate the Location to
// sSpawnAt    : the Tag that was used to find this Location
// lLocation   : the Location to relate to the ID
void eE_SetSpawnLocation(object oEncounter, int iLocationID, string sSpawnAt, location lLocation);

// Returns the Location that was previously associated with a Location ID
// oEncounter  : the Encounter Object o use
// iLocationID : the ID of the location to load
// sSpawnAt    : the Tag that is used to find this Location
location eE_GetSpawnLocation(object oEncounter, int iLocationID, string sSpawnAt);

// Returns a random Location of an Object with sTag in the same Area as an Encounter.
// oEncounter  : the Encounter Object to use
// sSpawnAt    : the Tag of the Object(s) to get a location from
//
// NOTE: This function will return 0 if you didn't call eE_CountSpawnLocations with the
//       corresponding variables first.
location eE_GetRandomSpawnLocation(object oEncounter, string sSpawnAt);

// Returns the number of Objects with a specific Tag in the same Area as an Encounter.
// This function is used for Spawn Point finding.
// Contrary to eE_CountActivePlayers, this method always saves everything found to
// the Encounter Object for later use.
// oEncounter  : the Encounter Object to use
// sSpawnAt    : the Tag of the Objects to count
int eE_CountSpawnLocations(object oEncounter, string sSpawnAt);

// Sets the number of Targets with a specific Tag for an Encounter
// oEncounter  : the Encounter Object to save to
// sTarget     : the Tag of the Target Object(s)
// iTargetCount: the Value to save as the Count
void eE_SetTargetCount(object oEncounter, string sTarget, int iTargetCount);

// Returns the number of Targets with a specific Tag for an Encounter
// oEncounter  : the Encounter Object to load from
// sTarget     : the Tag of the Target Object(s)
int eE_GetTargetCount(object oEncounter, string sTarget);

// Creates a relation between a Target ID and a Target object
// oEncounter  : the Encounter to save to
// iTargetID   : the ID to relate to the Target Object
// sTarget     : the Tag used to identify the Target Object(s)
// oTarget     : the Target Object to relate to the ID
void eE_SetTarget(object oEncounter, int iTargetID, string sTarget, object oTarget);

// Returns the Target Object that is related to a specific Target ID from an Encounter
// oEncounter  : the Encounter to load from
// iTargetID   : the ID of the Target Object to load
// sTarget     : the Tag used to identify the Target Object(s)
object eE_GetTarget(object oEncounter, int iTargetID, string sTarget);

// Returns a random Target Object from an Encounter
// oEncounter  : the Encounter to retrieve the Target from
// sTarget     : the Tag used to identify the Target Object
object eE_GetRandomTarget(object oEncounter, string sTarget);

// Returns the number of Objects with a specific Tag in the area of an Encounter.
// Contrary to eE_CountActivePlayers, this method always saves everything found to
// the Encounter Object for later use.
// oEncounter  : the Encounter to use
// sTarget     : the Tag of the Object(s) to count
int eE_CountTargets(object oEncounter, string sTarget);

// Returns the Cooldown Time for an Encounter
// oEncounter  : the Encounter Object to use
float eE_GetEncounterCooldown(object oEncounter);

// Sets the Status of an Encounter
// oEncounter  : the Encounter Object to set the Status of
// iStatus     : see eE_STATUS_*
void eE_SetEncounterStatus(object oEncounter, int iStatus);

// Returns the Status of an Encounter
// oEncounter  : the Encounter Object to get the Status from
// For possible return values, see eE_STATUS_*
int eE_GetEncounterStatus(object oEncounter);

// Sets the Status of an Event
// oEvent      : the Event Object to set the Status of
// iStatus     : see eE_EVENTSTATUS_*
void eE_SetEventStatus(object oEvent, int iStatus);

// Sets the Status of an Event
// oEvent      : the Event Object to get the Status from
// For possible return values, see eE_EVENTSTATUS_*
int eE_GetEventStatus(object oEvent);

// Saves the associated encounter on an event for later use
// oEvent      : the Event to save to
// oEncounter  : the Encounter to associate this event with
void eE_SetEventEncounter(object oEvent, object oEncounter);

// Returns the encounter an Event is associated with
// oEvent      : the Event to retrieve the associated Encounter from
object eE_GetEventEncounter(object oEvent);

// Sets the number of Active Events for a specific Phase of an Encounter
// oEncounter   : the Encounter Object to save to
// sPhase       : the Phase to save to
// iActiveEvents: the number of Events that are Active
void eE_SetActiveKeyEvents(object oEncounter, string sPhase, int iActiveKeyEvents);

// Returns the number of Active Events for a specific Phase of an Encounter
// oEncounter   : the Encounter Object to load from
// sPhase       : the Phase to retrieve the Active Events from
int eE_GetActiveKeyEvents(object oEncounter, string sPhase);

// Increases the number of Active Events for a specific Phase of an Encounter
// oEncounter  : the Encounter Object to use
// oEvent      : the Event Object that increases the events
// sPhase      : the Phase to manipulate
void eE_ActiveKeyEvents_Increase(object oEncounter, object oEvent, string sPhase);

// Decreases the number of Active Events for a specific Event Group (Phase) of an Encounter
// oEncounter  : the Encounter Object to use
// oEvent      : the Event Object that decreases the active events
// sPhase      : the Phase to manipulate
void eE_ActiveKeyEvents_Decrease(object oEncounter, object oEvent, string sPhase);

// Sets the number of Registered Events for an Encounter
// oEncounter       : the Encounter Object to use
// iRegisteredEvents: the number of Registered Events to save
void eE_SetRegisteredEvents(object oEncounter, int iRegisteredEvents);

// Returns the number of Registered Events from an Encounter
// oEncounter       : the Encounter Object to use
int eE_GetRegisteredEvents(object oEncounter);

// DEBUG function which sends eE Debug MSGs containing the Registered Events
void eE_ReportRegisteredEvents(object oEncounter);

// Registers an Event with an Encounter
// oEncounter  : the Encounter Object to use
// oEvent      : the Event to Register
void eE_RegisterEvent(object oEncounter, object oEvent);

// Checks if an Encounter is exhausted. This is called whenever a Key Event is exhausted.
// When there are no Key events left, the Encounter is exhausted.
// oEncounter  : the Encounter Object to chek
// Returns TRUE if the encounter is exhausted, FALSE if not
int eE_GetIsEncounterExhausted(object oEncounter);

// Saves a relation between an ID and an Event Object on an Encounter
// oEncounter  : the Encounter Object to save to
// iEventID    : the ID to relate the Event Object to
// oEvent      : the Event Object to relate the ID to
void eE_SetEvent(object oEncounter, int iEventID, object oEvent);

// Returns the Event Object related to an ID saved on an Encounter
// oEncounter  : the Encounter Object to load from
// iEventID    : the ID of the Event Object to load
object eE_GetEvent(object oEncounter, int iEventID);

// Sets the Phase an Event Object belongs to
// oEvent      : the Event Object to save the Phase to
// iEventPhase : the Phase to save
void eE_SetEventPhase(object oEvent, int iEventPhase);

// Returns the Phase an Event Object belongs to
// oEvent      : the Event Object to read the Phase from
int eE_GetEventPhase(object oEvent);

// Saves the Encounter an Entity belongs to on an Entity
// oEntity     : the Entity to save to
// oEncounter  : the Encounter to relate the Entity to
void eE_SetEntityEncounter(object oEntity, object oEncounter);

// Returns the Encounter object an Entity belongs to
// oEntity     : the Entity to get the Encounter from
object eE_GetEntityEncounter(object oEntity);

// Saves the Event Object an Entity belongs to on an Entity
// oEntity     : the Entity to save to
// oEvent      : the Event Object to relate the Entity to
void eE_SetEntityEvent(object oEntity, object oEvent);

// Returns the Event Object an Entity belongs to
// oEntity     : the Entity to get the Event from
object eE_GetEntityEvent(object oEntity);

// Sets an Event Tag for an Event on an Entity
// oEntity     : the Entity so save to
// sEventTag   : the Tag associated with this Event
// sEvent      : the Event to associate the Tag with
// Currently, only eE_VAR_ENTITY_ONSPAWN, eE_VAR_ENTITY_ONDAMAGED and eE_VAR_ENTITY_ONDEATH are used
// for sEvent
void eE_SetEntityEventTag(object oEntity, string sEventTag, string sEvent);

// Returns the Event Tag for an Event on an Entity
// oEntity     : the Entity so load from
// sEvent      : the Event to get the Tag for
// Currently, only eE_VAR_ENTITY_ONSPAWN, eE_VAR_ENTITY_ONDAMAGED and  eE_VAR_ENTITY_ONDEATH are used
string eE_GetEntityEventTag(object oEntity, string sEvent);

// Starts the Cooldown of an Encounter
// The Encounter Status is immediately set to eE_ENCOUNTER_STATUS_ONCOOLDOWN and after
// the cooldown is finished, the Status is set to eE_ENCOUNTER_STATUS_IDLE
void eE_StartCooldown(object oEncounter);

// Creates an Entity (Creature/Placeable). This is where Entities are created and
// several needed variables get set on the newly created entities to link them to
// their respective Events/Encounters and inform about their various Event Tags.
// oEncounter    : the Encounter Object to use
// oEvent        : the Event Object to use
// iObjectType   : OBJECT_TYPE_CREATURE or OBJECT_TYPE_PLACEABLE
// sBlueprint    : the Blueprint (resref) of the Entity to create
// lLocation     : the Location where to create the Entity
// sTag          : the Tag that will be assigned to the newly created entity
// EntityEvents  : a structure holding information on the various On* Events
// nSpawnEffect  : the Visual Effect (VFX_FNF_*) to apply at the spawn location
// nMaxConcurrent: the maximum concurrent amount of creatures to be spawned in oEvent
void eE_CreateEntity(object oEncounter, object oEvent, int iObjectType, string sBlueprint, location lLocation, string sTag, struct eE_EVENT_ENTITYEVENTS EntityEvents, int nSpawnEffect, int nMaxConcurrent);

// Does everything regarding creating Entities but the actual creation itself
void eE_CreateEncounterEntity(object oEncounter, object oEvent, int iObjectType, struct eE_EVENT_ENTITY Entity, struct eE_EVENT_ENTITYEVENTS EntityEvents);

// Destroys all objects within an Encounters Area with a specific Tag
// oEncounter  : the Encounter Object to use
// sNewTag     : the Tag of the Objects to destroy
void eE_DestroyEncounterEntity(object oEncounter, string sNewTag);

// This method retrieves the Target Object for an Action Event
// oEncounter   : the Encounter Object to use
// sTarget      : the Tag of the Target Object(s)
// nTargetMethod: eE_TARGETMETHOD_*
// nth          : if we're using the two FIXED variants of TargetMethod, tell the function to
//                find the nth target
// oSource      : the source of eE_TARGETMETHOD_NEARESTINDIVIDUAL/eE_TARGETMETHOD_FIXEDINDIVIDUAL
object eE_GetActionTarget(object oEncounter, string sTarget, int nTargetMethod, int nth = 1, object oSource = OBJECT_INVALID);

// Reads Event Information from an Event Object
struct eE_EVENT eE_GetInfo_Event(object oEvent);

// Reads Event Information from an Event Object
struct eE_EVENT_ENTITY eE_GetInfo_Entity(object oEvent);

// Reads Event Information from an Event Object
struct eE_EVENT_ENTITYEVENTS eE_GetInfo_EntityEvents(object oEvent);

// Reads Event Information from an Event Object
struct eE_EVENT_SPECIAL eE_GetInfo_EventSpecial(object oEvent);

// Reads Event Information from an Event Object
struct eE_EVENT_ACTION eE_GetInfo_EventAction(object oEvent);

// Handles an Event and prepares it for Execution
void eE_HandleEvent(object oEncounter, object oEvent, int iEncounterStatus = eE_ENCOUNTER_STATUS_INPROGRESS, int iMode = eE_EVENTMODE_CREATE);

// Handles an entire Event Group and sends the Events to eE_HandleEvent
void eE_HandleEvents(object oEncounter, string sTag, int nEncounterStatus = eE_ENCOUNTER_STATUS_INPROGRESS, string sMessagePrefix = "");

// Validates the Conditions of a given Encounter or Event
// Returns TRUE if conditions are met, FALSE if not
int eE_CheckConditions(object oObject);

// Executes ee_evt_onex
// oEvent      : the Event that executes the Script
void eE_OnEventExhausted(object oEvent);

// Executes ee_evtg_onex
// oEvent      : the Event that executes the Script
void eE_OnEventGroupExhausted(object oEvent);

// Executes ee_enc_onex
// oEncounter  : the Encounter that executes the Script
void eE_OnEncounterExhausted(object oEncounter);

// Executes ee_enc_reset
// oEncounter  : the Encounter that executes the Script
void eE_ResetEncounter(object oEncounter);

// Creates a Creature Event on all Encounters of a specific Tag
//
// Name:          The Name of the Event
// sEncounterTag:     The Tag of the Encounters
// sEventTag:         The Tag of the event to create
// Owner:             The Tag of the "Owner" of this Event. Whenever the Event fires, the existence of this "Owner" is checked. If there are more "Owners" (i.e. more Objects
//                    with the same tag), this event will fire as long as at least one Owner is still available. If the Owner refers to a creature, the event will fire as long
//                    as at least one creature that is still alive is found.
//
//                    Special Values: eE_EVENTOWNER_NONE - No checks will be made and the event will execute as long as the Encounter is still active.
//                                    eE_EVENTOWNER_SELF – This makes the creature that this event is attached to the Owner, and ONLY this creature. Only works in OnSpawn Creature Events
//                                                         (Theoretically, this would work in OnDeath Creature Events too, but as the creature dies when the event is registered, the owner
//                                                         would be dead and the event would not get executed)
//                                    eE_EVENTOWNER_ENCOUNTER – Defines the Encounter that this event belongs to as the Event Owner.
// Blueprint:         The resref/blueprint of the Creature to spawn
// Quantity:          Sets the quantity of Creatures to spawn when the Event is triggered. Setting this to -1 automatically sets the quantity to the available Spawnpoint count
// MaxConcurrent:     Sets the maximum amount of concurrently spawned creatures for this event. If this is set to 0, there is no maximum.
// SpawnAt:           Sets the tag of the waypoint(s) where this Event should create it's Creature(s)/Placeable(s).
//                    Special Value: eE_SPAWNTAG_PC - instead of waypoint markers, PCs are used as spawnpoints.
//                    If you set Quantity to <= -1, the number spawns are equal to FloatToInt(PCs / Abs(Quantity) + 1;
//                    -1 => 1/PC, -2 => 1/2 PCs, -3 => 1/3 PCs etc., always rounded up to the next nearest Integer
// SpawnDelay:        Sets the delay between spawns if Quantity is greater than 1.
// SpawnMethod:       eE_SPAWNMETHOD_RANDOM - the Spawnlocation is randomly selected from all available locations (or PCs, if SpawnAt is set to eE_SPAWNTAG_PC).
//                    eE_SPAWNMETHOD_FIXED  - the Spawnlocations are used on a basis of "nearest first".
// SpawnEffect:       Sets an effect for spawning. See VFX_FNF_* for possible values. The effect will be played when the Entity is spawned, no delays are used, so it might look
//                    a little weird if you use an effect that plays long here.
// Tag:               Sets the Tag of all created objects
// Event_OnSpawn:     The Tag of the Event Object(s) that should be triggered when this Event spawns it's Entities
// Event_OnDamaged:   The Tag of the Event Object(s) that should be triggered when the Creatures/Placeable spawned by this Event reaches a HP Treshold.
//                    The associated events need to be suffixed with "_<Percentage>"
//                    Example: Event_OnDamaged = "MyDmgEvent", the associated event for a 25% event would be "MyDmgEvent_25".
// Event_OnDeath:     The Tag of the Event Object(s) that should be triggered when the Creatures/Placeable spawned by this Event dies. Attention – this Event is triggered for EVERY entity
//                    spawned by this event. If you only want an event when all entities are dead, use OnExhaust Event Tag.
// Event_OnExhaust:   The Tag of the Event Object(s) that should be triggered when this event is exhausted (all spawned entities killed).
// KeyEvent:          0 - no Key event
//                    1 - Key event
//                    If set to 1, this event is added to the list of events needed to be defeated (exhausted) before the encounter itself is considered “exhausted”.
//                    Whenever no (active) Key Event is left, the encounter is Exhausted and goes on Cooldown. Every Encounter needs at least 1 Key Event to determine if the encounter is
//                    exhausted (won).
// InitialDelay:      Sets the delay after which this Event is first executed
// Interval:          Sets the Interval for triggering this Event after it is triggered first. If set to 0, this Event is only triggered once.
// MaxRepeats:        Sets the Maximum Times an event will execute when an Interval is set. If set to 1, the Event behaves like a non-interval event and will only execute once. If set to 0, the
//                    event will repeat as long as the check for it's owner is positive and the encounter is active.
// Undo:              Sets Automatic Undo for this event. Only works for Creature, Placeable and certain Special Events. With automatic undo, the system tries to undo all events executed
//                    during an encounter.
//                    Possible Values: eE_UNDO_AUTOMATIC – Automatic Undo (Default) - the Encounter tries to undo all executed Events automatically when exhausted.
//                                     eE_UNDO_MANUAL    – Manual Undo - the Encounter doesn ont try to undo anything.
void eE_CreateEvent_Creature(string Name, string sEncounterTag, string sEventTag, string Owner, string Blueprint, int Quantity, int MaxConcurrent, string SpawnAt, float SpawnDelay, int SpawnMethod, int SpawnEffect, string Tag, string Event_OnSpawn = "", string Event_OnDamaged = "", string Event_OnDeath = "", string Event_OnExhaust = "", int KeyEvent = 0, float InitialDelay = 0.0f, float Interval = 0.0f, int MaxRepeats = 0, int Undo = eE_UNDO_AUTOMATIC);

// Creates a Placeable Event on all Encounters of a specific Tag
//
// Name:          The Name of the Event
// sEncounterTag:     The Tag of the Encounters
// sEventTag:         The Tag of the event to create
// Owner:             The Tag of the "Owner" of this Event. Whenever the Event fires, the existence of this "Owner" is checked. If there are more "Owners" (i.e. more Objects
//                    with the same tag), this event will fire as long as at least one Owner is still available. If the Owner refers to a creature, the event will fire as long
//                    as at least one creature that is still alive is found.
//
//                    Special Values: eE_EVENTOWNER_NONE - No checks will be made and the event will execute as long as the Encounter is still active.
//                                    eE_EVENTOWNER_SELF – This makes the creature that this event is attached to the Owner, and ONLY this creature. Only works in OnSpawn Creature Events
//                                                         (Theoretically, this would work in OnDeath Creature Events too, but as the creature dies when the event is registered, the owner
//                                                         would be dead and the event would not get executed)
//                                    eE_EVENTOWNER_ENCOUNTER – Defines the Encounter that this event belongs to as the Event Owner.
// Blueprint:         The resref/blueprint of the Placeable to spawn
// Quantity:          Sets the quantity of Placeables to spawn when the Event is triggered. Setting this to -1 automatically sets the quantity to the available Spawnpoint count
// MaxConcurrent:     Sets the maximum amount of concurrently spawned creatures for this event. If this is set to 0, there is no maximum.
// SpawnAt:           Sets the tag of the waypoint(s) where this Event should create it's Creature(s)/Placeable(s).
//                    Special Value: eE_SPAWNTAG_PC - instead of waypoint markers, PCs are used as spawnpoints.
//                    If you set Quantity to <= -1, the number spawns are equal to FloatToInt(PCs / Abs(Quantity) + 1;
//                    -1 => 1/PC, -2 => 1/2 PCs, -3 => 1/3 PCs etc., always rounded up to the next nearest Integer
// SpawnDelay:        Sets the delay between spawns if Quantity is greater than 1.
// SpawnMethod:       eE_SPAWNMETHOD_RANDOM - the Spawnlocation is randomly selected from all available locations (or PCs, if SpawnAt is set to eE_SPAWNTAG_PC).
//                    eE_SPAWNMETHOD_FIXED  - the Spawnlocations are used on a basis of "nearest first".
// SpawnEffect:       Sets an effect for spawning. See VFX_FNF_* for possible values. The effect will be played when the Entity is spawned, no delays are used, so it might look
//                    a little weird if you use an effect that plays long here.
// Tag:               Sets the Tag of all created objects
// Event_OnSpawn:     The Tag of the Event Object(s) that should be triggered when this Event spawns it's Entities
// Event_OnDamaged:   The Tag of the Event Object(s) that should be triggered when the Creatures/Placeable spawned by this Event reaches a HP Treshold.
//                    The associated events need to be suffixed with "_<Percentage>"
//                    Example: Event_OnDamaged = "MyDmgEvent", the associated event for a 25% event would be "MyDmgEvent_25".
// Event_OnDeath:     The Tag of the Event Object(s) that should be triggered when the Creatures/Placeable spawned by this Event dies. Attention – this Event is triggered for EVERY entity
//                    spawned by this event. If you only want an event when all entities are dead, use OnExhaust Event Tag.
// Event_OnExhaust:   The Tag of the Event Object(s) that should be triggered when this event is exhausted (all spawned entities killed).
// KeyEvent:          0 - no Key event
//                    1 - Key event
//                    If set to 1, this event is added to the list of events needed to be defeated (exhausted) before the encounter itself is considered “exhausted”.
//                    Whenever no (active) Key Event is left, the encounter is Exhausted and goes on Cooldown. Every Encounter needs at least 1 Key Event to determine if the encounter is
//                    exhausted (won).
// InitialDelay:      Sets the delay after which this Event is first executed
// Interval:          Sets the Interval for triggering this Event after it is triggered first. If set to 0, this Event is only triggered once.
// MaxRepeats:        Sets the Maximum Times an event will execute when an Interval is set. If set to 1, the Event behaves like a non-interval event and will only execute once. If set to 0, the
//                    event will repeat as long as the check for it's owner is positive and the encounter is active.
// Undo:              Sets Automatic Undo for this event. Only works for Creature, Placeable and certain Special Events. With automatic undo, the system tries to undo all events executed
//                    during an encounter.
//                    Possible Values: eE_UNDO_AUTOMATIC – Automatic Undo (Default) - the Encounter tries to undo all executed Events automatically when exhausted.
//                                     eE_UNDO_MANUAL    – Manual Undo - the Encounter doesn ont try to undo anything.
void eE_CreateEvent_Placeable(string Name, string sEncounterTag, string sEventTag, string Owner, string Blueprint, int Quantity, int MaxConcurrent, string SpawnAt, float SpawnDelay, int SpawnMethod, int SpawnEffect, string Tag, string Event_OnSpawn = "", string Event_OnDamaged = "", string Event_OnDeath = "", string Event_OnExhaust = "", int KeyEvent = 0, float InitialDelay = 0.0f, float Interval = 0.0f, int MaxRepeats = 0, int Undo = eE_UNDO_AUTOMATIC);

// Creates a Special Event on all Encounters of a specific Tag
// Special Events are pre-defined Events that will manipulate an Object.
//
// Name:          The Name of the Event
// sEncounterTag: The Tag of the Encounters
// sEventTag:     The Tag of the event to create
// Owner:         The Tag of the "Owner" of this Event. Whenever the Event fires, the existence of this "Owner" is checked. If there are more "Owners" (i.e. more Objects
//                with the same tag), this event will fire as long as at least one Owner is still available. If the Owner refers to a creature, the event will fire as long
//                as at least one creature that is still alive is found.
//
//                Special Values: eE_EVENTOWNER_NONE - No checks will be made and the event will execute as long as the Encounter is still active.
//                                eE_EVENTOWNER_SELF – This makes the creature that this event is attached to the Owner, and ONLY this creature. Only works in OnSpawn Creature Events
//                                                     (Theoretically, this would work in OnDeath Creature Events too, but as the creature dies when the event is registered, the owner
//                                                     would be dead and the event would not get executed)
//                                eE_EVENTOWNER_ENCOUNTER – Defines the Encounter that this event belongs to as the Event Owner.
// EventID:       The Event ID of the special event (eE_VAR_SPECIAL_*)
//                NOTE: Automatic Undo not available for: eE_VAR_SPECIAL_ENCOUNTER_INITIALIZE
//                                                        eE_VAR_SPECIAL_ENCOUNTER_START
//                                                        eE_VAR_SPECIAL_ENCOUNTER_END
//                                                        eE_VAR_SPECIAL_ENCOUNTER_RESET
//                                                        eE_VAR_SPECIAL_FORCERESTALL
// Tag:           The Tag of the object(s) to manipulate (Note: The nearest Object with this Tag is selected).
//                Special Value: eE_SPAWNTAG_PC - the player Characters will be used (i.e. for Killing)
// InitialDelay:  Sets the delay after which this Event is first executed
// Interval:      Sets the Interval for triggering this Event after it is triggered first. If set to 0, this Event is only triggered once.
// MaxRepeats:    Sets the Maximum Times an event will execute when an Interval is set. If set to 1, the Event behaves like a non-interval event and will only execute once. If set to 0, the
//                event will repeat as long as the check for it's owner is positive and the encounter is active.
// Undo:          Sets Automatic Undo for this event. Only works for Creature, Placeable and certain Special Events. With automatic undo, the system tries to undo all events executed
//                during an encounter.
//                Possible Values: eE_UNDO_AUTOMATIC – Automatic Undo (Default) - the Encounter tries to undo all executed Events automatically when exhausted.
//                                 eE_UNDO_MANUAL    – Manual Undo - the Encounter doesn ont try to undo anything.
void eE_CreateEvent_Special(string Name, string sEncounterTag, string sEventTag, string Owner, int EventID, string Tag, float InitialDelay = 0.0f, float Interval = 0.0f, int MaxRepeats = 0, int Undo = eE_UNDO_AUTOMATIC);

// Creates an Action Event on all Encounters of a specific Tag
// Action Events assign Actions to a creature’s Action Queue. Action Events cannot be Undone automatically.
//
// Name:              The Name of the Event
// sEncounterTag:     The Tag of the Encounters
// sEventTag:         The Tag of the event to create
// Owner:             The Tag of the "Owner" of this Event. Whenever the Event fires, the existence of this "Owner" is checked. If there are more "Owners" (i.e. more Objects
//                    with the same tag), this event will fire as long as at least one Owner is still available. If the Owner refers to a creature/placeable, the event will fire as long
//                    as at least one entity that is still alive is found.
//                    Special Value: eE_EVENTOWNER_SELF – This makes the entity (creature/placealbe) that this event is attached to (defined Creature/Placeable Event'S OnSpawn
//                                                        variable) perform the selected action, and ONLY this creature. Also ignores the Quantity Setting.
// Quantity:          The number of Creatures found as "Owner" that should perform this action.
//                    Special Value: -1 - All "Owners" should perform this action.
//                    NOTE: The Target (Tag) remains the same regardless of the number of Entities performing the action.
// EventID:           The Event ID of the action that should be performed (eE_VAR_EVENT_ACTION_*)
// Tag:               The tag of the target object to perform the action on.
//                    Special Values: eE_SPAWNTAG_PC - this will make a PC the target.
//                                    For eE_VAR_EVENT_ACTION_SPEAKSTRING, this is the string to speak
//                                    For eE_VAR_EVENT_ACTION_PLAYANIMATION, this is the Animation to play (see ANIMATION_*), just use the number as string
//                                    For eE_VAR_EVENT_ACTION_SETAPPEARANCE, this is the Appearance to change to (see APPEARANCE_TYPE_*), just use the number as string
//                                    For eE_VAR_EVENT_ACTION_REMOVEEFFECT, this is the EffectTag to remove from the Owner
// TargetMethod:      eE_TARGETMETHOD_RANDOM             - a random matching target will be selected
//                    eE_TARGETMETHOD_FIXED              - the nearest matching target will be selected
//                    eE_TARGETMETHOD_RANDOMINDIVIDUAL   - Every onwer entity randomly selects a Target (multiple selects of the same target are possible)
//                    eE_TARGETMETHOD_FIXEDINDIVIDUAL    - Every owner entity selects the nth nearest Target to the encounter object (Restarts at nearest if necessary)
//                    eE_TARGETMETHOD_NEARESTINDIVISUAL  - Every owner entity selects the nearest Target to itself
//                    eE_TARGETMETHOD_LASTTARGET_RANDOM  - Every owner will select it's last target (set by ActionEvents and BeamEffects).
//                                                         If the last target isn't valid (anymore), a random new target will be selected
//                    eE_TARGETMETHOD_LASTTARGET_NEAREST - Every owner will select it's last target (set by ActionEvents and BeamEffects)
//                                                         If the last target isn't valid (anymore), a new target (nearest available) will be selected
// TargetType:        eE_OBJECTLOCATION_OBJECT         - use found Object as target
//                    eE_OBJECTLOCATION_LOCATION       - use found Object's location as target (only applicable to eE_VAR_EVENT_ACTION_CASTSPELL,
//                                                                                                                 eE_VAR_EVENT_ACTION_CASTFAKESPELL,
//                                                                                                                 eE_VAR_EVENT_ACTION_JUMPTO,
//                                                                                                                 eE_VAR_EVENT_ACTION_WALKTO
// Spell:             The spell to cast, see SPELL_* for possible values
// SpellWarning:      Causes a Visual Effect to be cast at the target prior to casting the real spell. You have to get the values from VFX_DUR_* for object targeting, and VFX_FNF_*
//                    for location targeting. If you set this to -1, no Warning will be done.
// SpellWarningDelay: Determines the delay between the warning effect and the actual Spellcast.
// InitialDelay:      Sets the delay after which this Event is first executed
// Interval:          Sets the Interval for triggering this Event after it is triggered first. If set to 0, this Event is only triggered once.
// MaxRepeats:        Sets the Maximum Times an event will execute when an Interval is set. If set to 1, the Event behaves like a non-interval event and will only execute once. If set to 0, the
//                    event will repeat as long as the check for it's owner is positive and the encounter is active.
void eE_CreateEvent_Action(string Name, string sEncounterTag, string sEventTag, string Owner, int Quantity, int EventID, string Tag, int TargetMethod = eE_TARGETMETHOD_FIXED, int TargetType = eE_OBJECTLOCATION_OBJECT, int Spell = 0, int SpellWarning = 0, float SpellWarningDelay = 0.0f, float InitialDelay = 0.0f, float Interval = 0.0f, int MaxRepeats = 0);

// Creates an Effect/VFX Event on all Encounters of a specific Tag
//
// Name:              The Name of the Event
// sEncounterTag:     The Tag of the Encounters
// sEventTag:         The Tag of the event to create
// Owner:             The Tag of the "Owner" of this Event. Whenever the Event fires, the existence of this "Owner" is checked. If there are more "Owners" (i.e. more Objects
//                    with the same tag), this event will fire as long as at least one Owner is still available. If the Owner refers to a creature/placeable, the event will fire as long
//                    as at least one entity that is still alive is found.
//                    Special Value: eE_EVENTOWNER_SELF – This makes the entity (creature/placealbe) that this event is attached to (defined Creature/Placeable Event'S OnSpawn
//                                                        variable) perform the selected action, and ONLY this creature. Also ignores the Quantity Setting.
//                    The Owner is also the source of eE_EFFECT_TYPE_BEAM Effects.
// Quantity:          The number of objects found as "Owner" that should perform this action.
//                    Special Value: -1 - All "Owners" should perform this action.
//                    NOTE: The Target (Tag) remains the same regardless of the number of Entities performing the action. If the VFX does not need a Source, the Quantity defines the number of
//                          targets affected.
// Delay:             The delay between the Owners / Tags, for delayed effects with more than one
// Tag:               The tag of the target object to apply the VFX on.
//                    Special Values: eE_SPAWNTAG_PC - this will make a PC the target.
// TargetMethod:      eE_TARGETMETHOD_RANDOM             - a random matching target will be selected
//                    eE_TARGETMETHOD_FIXED              - the nearest matching target will be selected
//                    eE_TARGETMETHOD_RANDOMINDIVIDUAL   - Every onwer entity randomly selects a Target (multiple selects of the same target are possible)
//                    eE_TARGETMETHOD_FIXEDINDIVIDUAL    - Every owner entity selects the nth nearest Target to the encounter object (Restarts at nearest if necessary)
//                    eE_TARGETMETHOD_NEARESTINDIVISUAL  - Every owner entity selects the nearest Target to itself
//                    eE_TARGETMETHOD_LASTTARGET_RANDOM  - Every owner will select it's last target (set by ActionEvents and BeamEffects).
//                                                         If the last target isn't valid (anymore), a random new target will be selected
//                    eE_TARGETMETHOD_LASTTARGET_NEAREST - Every owner will select it's last target (set by ActionEvents and BeamEffects)
//                                                         If the last target isn't valid (anymore), a new target (nearest available) will be selected
// DurationType:      See DURATION_TYPE_*
// Duration:          The time the effect should stay active (only works with DURATION_TYPE_TEMPORARY and compatible visual effects)
// EffectType:        The type of effect to use (eE_EFFECT_TYPE_*). This is used to determine the needed methods as well as if the effect needs an object or location as the target
//                    If you use eE_EFFECT_TYPE_AOE, you need to use AOE_* for VFX.
// Effect:            The effect to apply to the target, see eE_EFFECT_EFFECT_*.
// EffectVariables:   A delimited (,) string containing the Integer values for the variables needed for the desired effect.
//                    Example: EffectAbilityIncrease(ABILITY_STRENGTH, 5) => "0,5"
// VFX:               See VFX_*, set to -1 to use no effect
// EffectTag:         The string to Tag the effects with (for later use)
// InitialDelay:      Sets the delay after which this Event is first executed
// Interval:          Sets the Interval for triggering this Event after it is triggered first. If set to 0, this Event is only triggered once.
// MaxRepeats:        Sets the Maximum Times an event will execute when an Interval is set. If set to 1, the Event behaves like a non-interval event and will only execute once. If set to 0, the
//                    event will repeat as long as the check for it's owner is positive and the encounter is active.
// Undo:              Sets Automatic Undo for this event. Only works for Creature, Placeable and certain Special Events. With automatic undo, the system tries to undo all events executed
//                    during an encounter.
//                    Possible Values: eE_UNDO_AUTOMATIC – Automatic Undo (Default) - the Encounter tries to undo all executed Events automatically when exhausted.
//                                     eE_UNDO_MANUAL    – Manual Undo - the Encounter doesn ont try to undo anything.
void eE_CreateEvent_Effect(string Name, string sEncounterTag, string sEventTag, string Owner, int Quantity, float Delay, string Tag, int TargetMethod, int DurationType, float Duration, int EffectType, int Effect, string EffectVariables, int VFX, string EffectTag = eE_VAR_EFFECT_TAG, float InitialDelay = 0.0f, float Interval = 0.0f, int MaxRepeats = 0, int Undo = eE_UNDO_AUTOMATIC);

// Creates a Damage Event on all Encounters of a specific Tag
//
// Name:              The Name of the Event
// sEncounterTag:     The Tag of the Encounters
// sEventTag:         The Tag of the event to create
// Owner:             The Tag of the "Owner" of this Event. Whenever the Event fires, the existence of this "Owner" is checked. If there are more "Owners" (i.e. more Objects
//                    with the same tag), this event will fire as long as at least one Owner is still available. If the Owner refers to a creature/placeable, the event will fire as long
//                    as at least one entity that is still alive is found.
//                    Special Value: eE_EVENTOWNER_SELF – This makes the entity (creature/placealbe) that this event is attached to (defined Creature/Placeable Event'S OnSpawn
//                                                        variable) perform the selected action, and ONLY this creature. Also ignores the Quantity Setting.
// Quantity:          The number of objects that should be affected by this event.
//                    Special Value: -1 - All found targets will be affected.
//                    NOTE: The Target (Tag) remains the same regardless of the number of Entities performing the action. If the VFX does not need a Source, the Quantity defines the number of
//                          targets affected.
// Tag:               The tag of the target object to apply the VFX on.
//                    Special Values: eE_SPAWNTAG_PC - this will make a PC the target.
// ObjectTypes:       The Object Types to be affected by the Damage, see eE_DAMAGE_OBJECTTYPE_* (bitmask, you can combine them)
// TargetMethod:      eE_TARGETMETHOD_RANDOM           - a random matching target will be selected
//                    eE_TARGETMETHOD_FIXED            - the nearest matching target will be selected
//                    eE_TARGETMETHOD_RANDOMINDIVIDUAL - Every owner entity randomly selects a Target (multiple selects of the same target are possible)
//                    eE_TARGETMETHOD_FIXEDINDIVIDUAL  - Every owner entity selects the nth nearest Target to the encounter object (Restarts at nearest if necessary)
//                    eE_TARGETMETHOD_NEARESTINDIVISUAL- Every owner entity selects the nearest Target to itself
// TargetType:        eE_OBJECTLOCATION_OBJECT         - use found Object as target
//                    eE_OBJECTLOCATION_LOCATION       - use found Object's location as target (for delayed Effects, the original locaiton is used)
// VFX:               See VFX_*. Set to -1 to not use a VFX.
// VFX_Placeable:     The resref of the placeable to use as the visual effect. If this is "" or Duration is 0.0f, no placeable will be used. Only works with TargetType Location!
// DamageAmount:      The Amount of Damage to deal. Set this to a negative number if you want to heal instead.
// DamageType:        DAMAGE_TYPE_*
// DamageRepeats:     The number of times Damage should be dealth within the duration. if you set this to 0, damage will be dealt only initially
// Duration:          The duration of the damaging effect. If you set this to anything but 0.0f, you need to use a AOE_* effect for the VFX value and/or a VFX_Placeable
// WarningVFX:        See VFX_* - if you set this to -1, no warning will be displayed
// WarningPlaceable:  The resref of the placeable to use as a visual warning. If this is "" or WarningDelay is 0.0f, no warning placeable will be shown.
// WarningDelay:      The delay until the actual damage effect is done, even if there is no visible warning.
// ShapeType:         See SHAPE_*
// ShapeSize:         The size of the Shape
// SafeZone:          The distance to the center of the effect where the effect isn't felt (a Circle gets transformed to a "Donut" with this)
// InitialDelay:      Sets the delay after which this Event is first executed
// Interval:          Sets the Interval for triggering this Event after it is triggered first. If set to 0, this Event is only triggered once.
// MaxRepeats:        Sets the Maximum Times an event will execute when an Interval is set. If set to 1, the Event behaves like a non-interval event and will only execute once. If set to 0, the
//                    event will repeat as long as the check for it's owner is positive and the encounter is active.
void eE_CreateEvent_Damage(string Name, string sEncounterTag, string sEventTag, string Owner, int Quantity, string Tag, int ObjectTypes, int TargetMethod, int TargetType, int VFX, string VFX_Placeable, int DamageAmount, int DamageType, int DamageRepeats, float Duration, int WarningVFX, string WarningPlaceable, float WarningDelay, int ShapeType, float ShapeSize, float SafeZone, float InitialDelay = 0.0f, float Interval = 0.0f, int MaxRepeats = 0);

// Creates a Script Event on all Encounters of a specific Tag
// The event Owner will be the Executor (i.e. OBJECT_SELF) in the called script. If Automatic Undo is set, eE tries to Execute <ScriptName>_UNDO when in undo-mode.
// NOTE: The Owner Object needs to still be available at that time to be able to execute the UndoScript.
//
// Name:          The Name of the Event
// sEncounterTag: The Tag of the Encounters
// sEventTag:     The Tag of the event to create
// Scriptname:    The script to associate with this event
// Owner:         The Tag of the "Owner" of this Event. Whenever the Event fires, the existence of this "Owner" is checked. If there are more "Owners" (i.e. more Objects
//                with the same tag), this event will fire as long as at least one Owner is still available. If the Owner refers to a creature, the event will fire as long
//                as at least one creature that is still alive is found.
//
//                Special Values: eE_EVENTOWNER_NONE - No checks will be made and the event will execute as long as the Encounter is still active.
//                                eE_EVENTOWNER_SELF – This makes the creature that this event is attached to the Owner, and ONLY this creature. Only works in OnSpawn Creature Events
//                                                     (Theoretically, this would work in OnDeath Creature Events too, but as the creature dies when the event is registered, the owner
//                                                     would be dead and the event would not get executed)
//                                eE_EVENTOWNER_ENCOUNTER – Defines the Encounter that this event belongs to as the Event Owner.
// InitialDelay:  Sets the delay after which this Event is first executed
// Interval:      Sets the Interval for triggering this Event after it is triggered first. If set to 0, this Event is only triggered once.
// MaxRepeats:    Sets the Maximum Times an event will execute when an Interval is set. If set to 1, the Event behaves like a non-interval event and will only execute once. If set to 0, the
//                event will repeat as long as the check for it's owner is positive and the encounter is active.
// Undo:          Sets Automatic Undo for this event. Only works for Creature, Placeable and certain Special Events. With automatic undo, the system tries to undo all events executed
//                during an encounter.
//                Possible Values: eE_UNDO_AUTOMATIC – Automatic Undo (Default) - the Encounter tries to undo all executed Events automatically when exhausted.
//                                 eE_UNDO_MANUAL    – Manual Undo - the Encounter doesn ont try to undo anything.
void eE_CreateEvent_Script(string Name, string sEncounterTag, string sEventTag, string Scriptname, string Owner, float InitialDelay = 0.0f, float Interval = 0.0f, int MaxRepeats = 0, int Undo = eE_UNDO_AUTOMATIC);

// Adds an event that should trigger if the given group of Key Events are exhausted
//
// Example: You have three events with tag "eE_Enc_Ini". Two of those three events are considered Key Events. As soon as those two Key Events are exhausted, the encounter is
//          informed that the Event Group "eE_Enc_Ini" is exhausted. The encounter can then react on this event if you used this method to create an Event to be executed in that
//          case, like "eE_Enc_PhaseTwo".
//          eE_CreateEvent_KeyEvents_Exhausted("Encounter", "eE_Enc_Ini", "eE_Enc_PhaseTwo");
void eE_CreateEvent_KeyEvents_Exhausted(string sEncounterTag, string Event_Key_Tag, string Event_Execute_Tag);

// Creates a new Encounter on all Waypoints specified
// Name:            The Name of the encounter
// sWayPointTag:    The Tag of the waypoints on which to create the encounter
void eE_CreateEncounter(string Name, string sWayPointTag, string sEncounterTag, int Condition = eE_VAR_CONDITION_NONE, float DespawnInterval = 120.0f, string Event_Initialize = "event_initialize", string Event_InProgress = "event_inprogress", float Cooldown = 1800.0f, int MessageLevel = eE_MESSAGELEVEL_NONE);

// Code
void eE_Message(object oEncounter, string sMessage, int iMessageLevel)
{
   int iEncounterMessageLevel = GetLocalInt(oEncounter, eE_VAR_ENCOUNTER_MESSAGELEVEL);
   if (iMessageLevel <= iEncounterMessageLevel)
      eE_SendMessageToActivePlayers(oEncounter, "[" + eE_GetEncounterName(oEncounter) + "] - " + sMessage);

   // Log Entry for encounters set to do so
   if (iEncounterMessageLevel >= eE_MESSAGELEVEL_DEBUG_LOG)
      WriteTimestampedLogEntry("eE Log: " + "[" + eE_GetEncounterName(oEncounter) + "] - " + sMessage);
}

void eE_DebugMSG(object oEncounter, string sMessage)
{
   eE_Message(oEncounter, sMessage, eE_MESSAGELEVEL_DEBUG_FULL);
}

void eE_SendMessageToActivePlayers(object oEncounter, string sMessage)
{
   int iPlayerCount = eE_GetEncounterPlayerCount(oEncounter);
   int i;
   object oPC;
   for (i=1; i <= iPlayerCount; i++)
   {
      oPC = eE_GetEncounterPlayer(oEncounter, i);
      SendMessageToPC(oPC, sMessage);
   }
}

string eE_GetEncounterName(object oEncounter)
{
    string sName = GetLocalString(oEncounter, eE_VAR_ENCOUNTERNAME);
    if (sName == "")
        return GetName(oEncounter);
    else
        return sName;
}

object eE_GetEncounterEvent(object oEncounter, string sTag, int nth = 1)
{
   return (GetNearestObjectByTag(sTag, oEncounter, nth));
}

int eE_GetEncounterSize(object oEncounter)
{
   return (GetLocalInt(oEncounter, eE_VAR_SIZE));
}

void eE_Encounter_AddToArea(object oEncounter, object oArea, string sArray)
{
   // Try to create the Array.
   // This function only creats the Array if it wasn't already created
   eas_Array_Create(oArea, sArray, EAS_ARRAY_TYPE_STRING);
   int nIndex = eas_OArray_Entry_Add(oArea, sArray, oEncounter);
   eE_DebugMSG(oEncounter, "Added Index #" + IntToString(nIndex) + " to Area Array [" + sArray + "].");
}

void eE_Encounter_RemoveFromArea(object oEncounter, object oArea, string sArray)
{
   int nIndex = eas_OArray_Entry_DeleteByValue(oArea, sArray, oEncounter);
   if (nIndex != -1)
   {
      eE_DebugMSG(oEncounter, "Deleted Index #" + IntToString(nIndex) + " from Area Array [" + sArray + "].");
   }
}

/*************************************************************************
 * The following Player Functions are used for Encounters with Size set to
 * eE_ENCOUNTER_SIZE_TRIGGER
 *************************************************************************/
int eE_AddPlayerToArray(object oEncounter, object oPC)
{
   eas_Array_Create(oEncounter, eE_VAR_ARRAY_PLAYERS, EAS_ARRAY_TYPE_OBJECT);
   return (eas_OArray_Entry_Add(oEncounter, eE_VAR_ARRAY_PLAYERS, oPC));
}

object eE_GetPlayerFromArray(object oEncounter, int nIndex)
{
   return (eas_OArray_Entry_Get(oEncounter, eE_VAR_ARRAY_PLAYERS, nIndex));
}

int eE_RemovePlayerFromArray(object oEncounter, object oPC)
{
   eas_OArray_Entry_DeleteByValue(oEncounter, eE_VAR_ARRAY_PLAYERS, oPC);
   return (eas_Array_GetSize(oEncounter, eE_VAR_ARRAY_PLAYERS));
}

int eE_GetPlayerCountFromArray(object oEncounter)
{
   return (eas_Array_GetSize(oEncounter, eE_VAR_ARRAY_PLAYERS));
}

object eE_GetRandomActivePlayerFromArray(object oEncounter)
{
   int nPlayercount = eE_GetPlayerCountFromArray(oEncounter);
   int nRandom = Random(nPlayercount);
   return (eE_GetPlayerFromArray(oEncounter, nRandom));
}

/*************************************************************************
 * The following Player Functions are used for Encounters with Size set to
 * eE_ENCOUNTER_SIZE_AREA
 *************************************************************************/
void eE_SetActivePlayerCount(object oEncounter, int iPlayerCount)
{
   SetLocalInt(oEncounter, eE_VAR_ACTIVEPLAYERS, iPlayerCount);
}

int eE_GetActivePlayerCount(object oEncounter)
{
   return (GetLocalInt(oEncounter, eE_VAR_ACTIVEPLAYERS));
}

void eE_SetActivePlayer(object oEncounter, int iPlayerID, object oPC)
{
   SetLocalObject(oEncounter, eE_VAR_PLAYERLIST + IntToString(iPlayerID), oPC);
}

object eE_GetActivePlayer(object oEncounter, int iPlayerID)
{
   return (GetLocalObject(oEncounter, eE_VAR_PLAYERLIST + IntToString(iPlayerID)));
}

object eE_GetRandomActivePlayer(object oEncounter, int iDoFreshCount = FALSE)
{
   // Initialize variable
   int iPlayerCount;
   object oPC;
   int iRandom;

   // If wanted, do a fresh count
   if (iDoFreshCount)
   {
      iPlayerCount = eE_CountActivePlayers(oEncounter, TRUE);
      iRandom = Random(iPlayerCount) + 1;
      return (eE_GetActivePlayer(oEncounter, iRandom));
   }

   // If we don't do a fresh count, we use what's already saved and hope it's there ;)
   iPlayerCount = eE_GetActivePlayerCount(oEncounter);
   iRandom = Random(iPlayerCount) + 1;
   return (eE_GetActivePlayer(oEncounter, iRandom));
}

int eE_CountActivePlayers(object oEncounter, int iSavePCObjects = FALSE)
{
   // Count the number of players in the encounter's area
   int iCount = 1;
   int iPlayerCount = 0;
   object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oEncounter, iCount);
   while (GetIsObjectValid(oPC) && !GetIsDead(oPC))
   {
      // DMs don't count
      if (!GetIsDM(oPC))
      {
         // Increase the player number
         iPlayerCount += 1;
         // Save the player objects on the encounter object if needed
         if (iSavePCObjects)
            eE_SetActivePlayer(oEncounter, iPlayerCount, oPC);
      }

      // Look for the next player
      iCount += 1;
      oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oEncounter, iCount);
   }
   // Save the player count to the encounter object and return it as well
   eE_SetActivePlayerCount(oEncounter, iPlayerCount);
   return (iPlayerCount);
}

/*************************************************************************
 * The following Player Functions are used for Encounters and choose thre
 * right "Top Level" function based on Encounter Size
 *************************************************************************/
object eE_GetEncounterPlayer(object oEncounter, int nth)
{
   if (GetLocalInt(oEncounter, eE_VAR_SIZE) == eE_ENCOUNTER_SIZE_TRIGGER)
   {
      return (eE_GetPlayerFromArray(oEncounter, nth - 1));
   }
   else if (GetLocalInt(oEncounter, eE_VAR_SIZE) == eE_ENCOUNTER_SIZE_AREA)
   {
      return (eE_GetActivePlayer(oEncounter, nth));
   }
   return (OBJECT_INVALID);
}

int eE_GetEncounterPlayerCount(object oEncounter)
{
   if (GetLocalInt(oEncounter, eE_VAR_SIZE) == eE_ENCOUNTER_SIZE_TRIGGER)
   {
      return (eE_GetPlayerCountFromArray(oEncounter));
   }
   else if (GetLocalInt(oEncounter, eE_VAR_SIZE) == eE_ENCOUNTER_SIZE_AREA)
   {
      return (eE_CountActivePlayers(oEncounter, TRUE));
   }
   return (-1);
}

object eE_GetRandomEncounterPlayer(object oEncounter)
{
   if (GetLocalInt(oEncounter, eE_VAR_SIZE) == eE_ENCOUNTER_SIZE_TRIGGER)
   {
      return (eE_GetRandomActivePlayerFromArray(oEncounter));
   }
   else if (GetLocalInt(oEncounter, eE_VAR_SIZE) == eE_ENCOUNTER_SIZE_AREA)
   {
      return (eE_GetRandomActivePlayer(oEncounter));
   }
   return (OBJECT_INVALID);
}

void eE_SetSpawnLocationCount(object oEncounter, string sSpawnAt, int iLocationCount)
{
   SetLocalInt(oEncounter, "cnt_" + sSpawnAt, iLocationCount);
}

int eE_GetSpawnLocationCount(object oEncounter, string sSpawnAt)
{
   return (GetLocalInt(oEncounter, "cnt_" + sSpawnAt));
}

void eE_SetSpawnLocation(object oEncounter, int iLocationID, string sSpawnAt, location lLocation)
{
   SetLocalLocation(oEncounter, "l" + IntToString(iLocationID) + "_" + sSpawnAt, lLocation);
}

location eE_GetSpawnLocation(object oEncounter, int iLocationID, string sSpawnAt)
{
   return (GetLocalLocation(oEncounter, "l" + IntToString(iLocationID) + "_" + sSpawnAt));
}

location eE_GetRandomSpawnLocation(object oEncounter, string sSpawnAt)
{
   // Get the data from the encounter object
   int iLocationCount = eE_GetSpawnLocationCount(oEncounter, sSpawnAt);
   int iRandom = Random(iLocationCount) + 1;
   return (eE_GetSpawnLocation(oEncounter, iRandom, sSpawnAt));
}

int eE_CountSpawnLocations(object oEncounter, string sSpawnAt)
{
   // Count the number of players in the encounter's area
   int iCount = 1;
   int iLocationCount = 0;
   object oSpawn = GetNearestObjectByTag(sSpawnAt, oEncounter, iCount);
   while (GetIsObjectValid(oSpawn))
   {
      // Increase the location number
      iLocationCount += 1;
      // Save the location on the encounter object
      eE_SetSpawnLocation(oEncounter, iLocationCount, sSpawnAt, GetLocation(oSpawn));
      // Look for the next player
      iCount += 1;
      oSpawn = GetNearestObjectByTag(sSpawnAt, oEncounter, iCount);
   }
   // Save the location count to the encounter object and return it as well
   eE_SetSpawnLocationCount(oEncounter, sSpawnAt, iLocationCount);
   return (iLocationCount);
}

void eE_SetTargetCount(object oEncounter, string sTarget, int iTargetCount)
{
   SetLocalInt(oEncounter, "tar_cnt_" + sTarget, iTargetCount);
}

int eE_GetTargetCount(object oEncounter, string sTarget)
{
   return (GetLocalInt(oEncounter, "tar_cnt_" + sTarget));
}

void eE_SetTarget(object oEncounter, int iTargetID, string sTarget, object oTarget)
{
   SetLocalObject(oEncounter, "tar" + IntToString(iTargetID) + "_" + sTarget, oTarget);
}

object eE_GetTarget(object oEncounter, int iTargetID, string sTarget)
{
   return (GetLocalObject(oEncounter, "tar" + IntToString(iTargetID) + "_" + sTarget));
}

object eE_GetRandomTarget(object oEncounter, string sTarget)
{
   // Get the data from the encounter object
   int iTargetCount = eE_GetTargetCount(oEncounter, sTarget);
   int iRandom = Random(iTargetCount) + 1;
   return (eE_GetTarget(oEncounter, iRandom, sTarget));
}

int eE_CountTargets(object oEncounter, string sTarget)
{
   // Count the number of players in the encounter's area
   int iCount = 1;
   int iTargetCount = 0;
   object oTarget = GetNearestObjectByTag(sTarget, oEncounter, iCount);
   while (GetIsObjectValid(oTarget))
   {
      // Increase the location number
      iTargetCount += 1;
      // Save the location on the encounter object
      eE_SetTarget(oEncounter, iTargetCount, sTarget, oTarget);
      // Look for the next player
      iCount += 1;
      oTarget = GetNearestObjectByTag(sTarget, oEncounter, iCount);
   }
   // Save the location count to the encounter object and return it as well
   eE_SetTargetCount(oEncounter, sTarget, iTargetCount);
   return (iTargetCount);
}

float eE_GetEncounterCooldown(object oEncounter)
{
   return (GetLocalFloat(oEncounter, eE_VAR_COOLDOWN));
}

void eE_SetEncounterStatus(object oEncounter, int iStatus)
{
   SetLocalInt(oEncounter, eE_VAR_ENCOUNTER_STATUS, iStatus);
}

int eE_GetEncounterStatus(object oEncounter)
{
   return (GetLocalInt(oEncounter, eE_VAR_ENCOUNTER_STATUS));
}

void eE_SetEventStatus(object oEvent, int iStatus)
{
   SetLocalInt(oEvent, eE_VAR_EVENTSTATUS, iStatus);
}

int eE_GetEventStatus(object oEvent)
{
   return (GetLocalInt(oEvent, eE_VAR_EVENTSTATUS));
}

void eE_SetEventEncounter(object oEvent, object oEncounter)
{
   SetLocalObject(oEvent, eE_VAR_EVENTENCOUNTER, oEncounter);
}

object eE_GetEventEncounter(object oEvent)
{
   return (GetLocalObject(oEvent, eE_VAR_EVENTENCOUNTER));
}

void eE_SetActiveKeyEvents(object oEncounter, string sPhase, int iActiveKeyEvents)
{
   SetLocalInt(oEncounter, eE_VAR_ACTIVEKEYEVENTS + sPhase, iActiveKeyEvents);
}

int eE_GetActiveKeyEvents(object oEncounter, string sPhase)
{
   return (GetLocalInt(oEncounter, eE_VAR_ACTIVEKEYEVENTS + sPhase));
}

void eE_ActiveKeyEvents_Increase(object oEncounter, object oEvent, string sPhase)
{
   sPhase = GetTag(oEvent);
   int iActiveKeyEvents = eE_GetActiveKeyEvents(oEncounter, sPhase);
   iActiveKeyEvents += 1;
   eE_SetActiveKeyEvents(oEncounter, sPhase, iActiveKeyEvents);
   //eE_DebugMSG(oEncounter, "There are " + IntToString(iActiveKeyEvents) + " Key Phase " + sPhase + " Events left.");
}

void eE_ActiveKeyEvents_Decrease(object oEncounter, object oEvent, string sPhase)
{
   sPhase = GetTag(oEvent);
   int iActiveKeyEvents = eE_GetActiveKeyEvents(oEncounter, sPhase);
   iActiveKeyEvents--;
   eE_SetActiveKeyEvents(oEncounter, sPhase, iActiveKeyEvents);
   //eE_DebugMSG(oEncounter, "There are " + IntToString(iActiveKeyEvents) + " Key Phase " + sPhase + " Events left.");
   if (iActiveKeyEvents == 0)
   {
      eE_OnEventGroupExhausted(oEvent);
   }
}

void eE_SetRegisteredEvents(object oEncounter, int iRegisteredEvents)
{
   SetLocalInt(oEncounter, eE_VAR_REGISTEREDEVENTS, iRegisteredEvents);
}

int eE_GetRegisteredEvents(object oEncounter)
{
   return (GetLocalInt(oEncounter, eE_VAR_REGISTEREDEVENTS));
}

void eE_ReportRegisteredEvents(object oEncounter)
{
   int iRegisteredEvents = eE_GetRegisteredEvents(oEncounter);
   int i;
   object oEvent;
   string sMessage = "There are " + IntToString(iRegisteredEvents) + " registered Events:\n";
   for (i = 1; i <= iRegisteredEvents; i++)
   {
      oEvent = eE_GetEvent(oEncounter, i);
      sMessage += "[" + IntToString(i) + "] " + GetTag(oEvent);
      if (GetLocalInt(oEvent, eE_VAR_KEYEVENT))
         sMessage += " (KEY)";
      sMessage += "\n";
   }
   eE_DebugMSG(oEncounter, sMessage);
}

void eE_RegisterEvent(object oEncounter, object oEvent)
{
   int iRegisteredEvents = eE_GetRegisteredEvents(oEncounter);
   iRegisteredEvents += 1;
   eE_SetRegisteredEvents(oEncounter, iRegisteredEvents);
   eE_SetEvent(oEncounter, iRegisteredEvents, oEvent);
}

int eE_GetIsEncounterExhausted(object oEncounter)
{
   int iRegisteredEvents = eE_GetRegisteredEvents(oEncounter);
   int i;
   int iCount = 0;
   int iTotalCount = 0;
   object oEvent;
   int iEventPhase;
   int iActiveEvents;
   string sEventTag;
   string sCheck = "";
   for (i = 1; i <= iRegisteredEvents; i++)
   {
      oEvent = eE_GetEvent(oEncounter, i);
      if (GetLocalInt(oEvent, eE_VAR_KEYEVENT))
      {
         sEventTag = GetTag(oEvent);
         if (FindSubString(sCheck, "[" + sEventTag + "]") == -1)
         {
            sCheck += "[" + sEventTag + "]";
            iCount++;
            iEventPhase = eE_GetEventPhase(oEvent);
            iActiveEvents = eE_GetActiveKeyEvents(oEncounter, sEventTag);
            iTotalCount += iActiveEvents;
         }
      }
   }
   if (iTotalCount == 0)
      return (TRUE);

   return (FALSE);
}

void eE_SetEvent(object oEncounter, int iEventID, object oEvent)
{
   SetLocalObject(oEncounter, eE_VAR_EVENTS_PREFIX + IntToString(iEventID), oEvent);
}

object eE_GetEvent(object oEncounter, int iEventID)
{
   return (GetLocalObject(oEncounter, eE_VAR_EVENTS_PREFIX + IntToString(iEventID)));
}

void eE_SetEventPhase(object oEvent, int iEventPhase)
{
   SetLocalInt(oEvent, eE_VAR_EVENTPHASE, iEventPhase);
}

int eE_GetEventPhase(object oEvent)
{
   return (GetLocalInt(oEvent, eE_VAR_EVENTPHASE));
}

void eE_SetEntityEncounter(object oEntity, object oEncounter)
{
   SetLocalObject(oEntity, eE_VAR_ENTITY_ENCOUNTER, oEncounter);
}

object eE_GetEntityEncounter(object oEntity)
{
   return (GetLocalObject(oEntity, eE_VAR_ENTITY_ENCOUNTER));
}

void eE_SetEntityEvent(object oEntity, object oEvent)
{
   SetLocalObject(oEntity, eE_VAR_ENTITY_EVENT, oEvent);
}

object eE_GetEntityEvent(object oEntity)
{
   return (GetLocalObject(oEntity, eE_VAR_ENTITY_EVENT));
}

void eE_SetEntityEventTag(object oEntity, string sEventTag, string sEvent)
{
   SetLocalString(oEntity, sEvent, sEventTag);
}

string eE_GetEntityEventTag(object oEntity, string sEvent)
{
   return (GetLocalString(oEntity, sEvent));
}

void eE_StartCooldown(object oEncounter)
{
   eE_DebugMSG(oEncounter, "Going on Cooldown...");
   eE_SetEncounterStatus(oEncounter, eE_ENCOUNTER_STATUS_ONCOOLDOWN);
   AssignCommand(GetModule(), DelayCommand(eE_GetEncounterCooldown(oEncounter), eE_SetEncounterStatus(oEncounter, eE_ENCOUNTER_STATUS_IDLE)));
}

void eE_CreateEntity(object oEncounter, object oEvent, int iObjectType, string sBlueprint, location lLocation, string sTag, struct eE_EVENT_ENTITYEVENTS EntityEvents, int nSpawnEffect, int nMaxConcurrent)
{
   // Check if the maximum count of concurrent entities spawned for this event is reached
   int iCurrentEventCreatures = GetLocalInt(oEvent, eE_VAR_EVENTCREATURECOUNT);
   if (nMaxConcurrent > 0 &&
       iCurrentEventCreatures >= nMaxConcurrent)
   {
      eE_DebugMSG(oEncounter, GetName(oEvent) + " - Maximum number of creatures (" + IntToString(iCurrentEventCreatures) + "/" + IntToString(nMaxConcurrent) + ") active.");
      return;
   }

   // Does this entity have a spawn-in effect?
   if (nSpawnEffect != 0)
   {
      effect eSpawnEffect = EffectVisualEffect(nSpawnEffect);
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSpawnEffect, lLocation);
   }

   object oEntity = CreateObject(iObjectType, sBlueprint, lLocation, FALSE, sTag);

   // Now that oEntity is created, we should tell it the encounter and event it's associated with.
   // This will be of use in event entity scripts.
   eE_SetEntityEncounter(oEntity, oEncounter);
   eE_SetEntityEvent(oEntity, oEvent);

   // Also, the Entity needs to know what to do OnDeath, OnDamaged and OnSpawn
   eE_SetEntityEventTag(oEntity, EntityEvents.OnDeath, eE_VAR_ENTITY_ONDEATH);
   eE_SetEntityEventTag(oEntity, EntityEvents.OnSpawn, eE_VAR_ENTITY_ONSPAWN);
   eE_SetEntityEventTag(oEntity, EntityEvents.OnDamaged, eE_VAR_ENTITY_ONDAMAGED);

   // Finally, tell the entity to execute it's eE OnSpawn Script
   ExecuteScript(eE_SCRIPT_ENTITY_ONSPAWN, oEntity);

   // NWN 1
   // SetName(oEntity, GetName(oEvent));
   // NWN 2
   // SetLastName(oEntity, GetName(oEvent));

   // Add the Entity to the event's entity count.
   // Already got this at the start of method // int iCurrentEventCreatures = GetLocalInt(oEvent, eE_VAR_EVENTCREATURECOUNT);
   iCurrentEventCreatures++;
   SetLocalInt(oEvent, eE_VAR_EVENTCREATURECOUNT, iCurrentEventCreatures);

   eE_DebugMSG(oEncounter, "Spawned " + GetName(oEntity) + " [Blueprint '" + sBlueprint + "'], Active Event Entities: " + IntToString(iCurrentEventCreatures));
}

void eE_CreateEncounterEntity(object oEncounter, object oEvent, int iObjectType, struct eE_EVENT_ENTITY Entity, struct eE_EVENT_ENTITYEVENTS EntityEvents)
{
   // Now we need some variables initialized
   int iCount;
   int i;
   object oEntity;

   // First, we check if the SpawnTag is one of our specials
   if (Entity.SpawnAt == eE_SPAWNTAG_PC)
   {
      // Do a fresh count of the players
      //iCount = eE_CountActivePlayers(oEncounter, TRUE);
      //iCount = eE_GetPlayerCountFromArray(oEncounter);
      iCount = eE_GetEncounterPlayerCount(oEncounter);

      // if iNumberOfAdds is set to -1, we need to override the Spawn Method
      // to eE_SPAWNMETHOD_FIXED and adjust the number of adds to be spawned
      if (Entity.Quantity <= -1)
      {
         // Retrieve previously stored entity Quantity
         int nPreviousQuantity = GetLocalInt(oEvent, eE_VAR_ENTITY_MAXDYNAMICQUANTITY);

         Entity.SpawnMethod = eE_SPAWNMETHOD_FIXED;
         float fQuantity = IntToFloat(iCount) / IntToFloat(abs(Entity.Quantity));
         int nQuantity = FloatToInt(fQuantity);
         Entity.Quantity = nQuantity;
         if (IntToFloat(nQuantity) < fQuantity)
            Entity.Quantity += 1;

         // Remember the calculated event quantity if it's higher than the previous entry
         // or set the rememberd quantity as quantity
         if (nPreviousQuantity >= Entity.Quantity)
            Entity.Quantity = nPreviousQuantity;
         else
            SetLocalInt(oEvent, eE_VAR_ENTITY_MAXDYNAMICQUANTITY, Entity.Quantity);
      }

      // if there is no player (iCount == 0), exit
      if (iCount == 0)
         return;

      // For every add to spawn, select a random player from the list
      // it's possible that the same player will be selected multiple times
      object oPC;

      // if we use eE_SPAWNMETHOD_RANDOM, then the following loop will
      // be done
      if (Entity.SpawnMethod == eE_SPAWNMETHOD_RANDOM)
      {
         for (i = 1; i <= Entity.Quantity; i++)
         {
            // For this procedure, we do a fresh count of active players
            // so we don't select a dead one
            //oPC = eE_GetRandomActivePlayer(oEncounter, FALSE);
            //oPC = eE_GetRandomActivePlayerFromArray(oEncounter);
            oPC = eE_GetRandomEncounterPlayer(oEncounter);

            // And now, we can spawn the creature right at his position
            AssignCommand(GetModule(), DelayCommand(Entity.SpawnDelay * (i - 1), eE_CreateEntity(oEncounter, oEvent, iObjectType, Entity.Blueprint, GetLocation(oPC), Entity.Tag, EntityEvents, Entity.SpawnEffect, Entity.MaxConcurrent)));
         }
      }
      else if (Entity.SpawnMethod == eE_SPAWNMETHOD_FIXED)
      {
         int nRecursiveCount;
         for (i = 1; i <= Entity.Quantity; i++)
         {
            if (i > iCount) // Searching for a player number that isn't there, we need to start at 1 again
            {
               nRecursiveCount = i % iCount;
               if (nRecursiveCount == 0)
                  nRecursiveCount = iCount;
               oPC = eE_GetEncounterPlayer(oEncounter, nRecursiveCount);
            }
            else
               oPC = eE_GetEncounterPlayer(oEncounter, i);

            AssignCommand(GetModule(), DelayCommand(Entity.SpawnDelay * (i - 1), eE_CreateEntity(oEncounter, oEvent, iObjectType, Entity.Blueprint, GetLocation(oPC), Entity.Tag, EntityEvents, Entity.SpawnEffect, Entity.MaxConcurrent)));
         }
      }
      // Exit this function
      return;
   }
   else if (Entity.SpawnAt == "")
   {
      // If we have no spawn-Tag, set, we'll use the location of the encounter object to spawn our stuff
      if (Entity.Quantity == -1)
      {
         Entity.Quantity = 1;
      }
      for (i = 1; i <= Entity.Quantity; i++)
         {
            // And now, we can spawn the creature right at his position
            AssignCommand(GetModule(), DelayCommand(Entity.SpawnDelay * (i - 1), eE_CreateEntity(oEncounter, oEvent, iObjectType, Entity.Blueprint, GetLocation(oEncounter), Entity.Tag, EntityEvents, Entity.SpawnEffect, Entity.MaxConcurrent)));
         }
      return;
   }

   // If no special spawn tag was found, do the standard spawn method
   // First, if it did not already happen, get the possible spawn locations
   int iLocationCount = eE_GetSpawnLocationCount(oEncounter, Entity.SpawnAt);

   // if location count is 1 or less, search again because it's possible we have a moving object as target
   if (iLocationCount <= 1)
   {
      iLocationCount = eE_CountSpawnLocations(oEncounter, Entity.SpawnAt);
   }

   // If our location count is still 0, something is setup very wrong
   // and we'll exit the function ASAP
   if (iLocationCount == 0)
   {
      // Debug Message to all active players
      eE_DebugMSG(oEncounter, "No Spawn locations found for Object " + Entity.Blueprint);
   }

   // if iNumberOfAdds is set to -1, we need to override the Spawn Method
   // to eE_SPAWNMETHOD_FIXED and adjust the number of adds to be spawned
   if (Entity.Quantity == -1)
   {
      Entity.SpawnMethod = eE_SPAWNMETHOD_FIXED;
      Entity.Quantity = iLocationCount;
   }

   location lLocation;
   // if we use eE_SPAWNMETHOD_RANDOM, then do the following loop
   if (Entity.SpawnMethod == eE_SPAWNMETHOD_RANDOM)
   {
      // Now that we have our locations, pick a random one for each Creature and spawn them in
      for (i = 1; i <= Entity.Quantity; i++)
      {
         lLocation = eE_GetRandomSpawnLocation(oEncounter, Entity.SpawnAt);
         AssignCommand(GetModule(), DelayCommand(Entity.SpawnDelay * (i - 1), eE_CreateEntity(oEncounter, oEvent, iObjectType, Entity.Blueprint, lLocation, Entity.Tag, EntityEvents, Entity.SpawnEffect, Entity.MaxConcurrent)));
      }
   }
   else if (Entity.SpawnMethod == eE_SPAWNMETHOD_FIXED)
   {
      for (i = 1; i <= Entity.Quantity; i++)
      {
         lLocation = eE_GetSpawnLocation(oEncounter, i, Entity.SpawnAt);
         AssignCommand(GetModule(), DelayCommand(Entity.SpawnDelay * (i - 1), eE_CreateEntity(oEncounter, oEvent, iObjectType, Entity.Blueprint, lLocation, Entity.Tag, EntityEvents, Entity.SpawnEffect, Entity.MaxConcurrent)));
      }
   }
}

void eE_DestroyEncounterEntity(object oEncounter, string sNewTag)
{
   // Let's loop through the active creatures and give them a delayed destroy command
   int iCount = 1;
   object oEntity = GetNearestObjectByTag(sNewTag, oEncounter, iCount);
   while (GetIsObjectValid(oEntity))
   {
      // We need to delay the actualy destroying because of the loop. Without a delay,
      // some objects wouldn't be destroyed. Another method would be using the
      // nearest creature exclusively, but i rather use this variant.
      // eE_DebugMSG(oEncounter, "Destroying Entity [" + GetName(oEntity) + "]");

      DestroyObject(oEntity, eE_CFG_DELAY_CREATUREDESTROY);

      // NWN2 Codepath DestroyObject(oEntity, eE_CFG_DELAY_CREATUREDESTROY, FALSE);
      iCount++;
      oEntity = GetNearestObjectByTag(sNewTag, oEncounter, iCount);
   }
}

object eE_GetActionTarget(object oEncounter, string sTarget, int nTargetMethod, int nth = 1, object oSource = OBJECT_INVALID)
{
   // Determine the target of the action
   object oTarget;
   if ((nTargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST ||
        nTargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
       &&
       GetIsObjectValid(oSource))
   {
      // Get last Target of oSource
      oTarget = GetLocalObject(oSource, eE_VAR_LASTTARGET);

      // If the stored target is still valid,
      // alive and
      // in the same area as oSource, use it
      if (GetIsObjectValid(oTarget) &&
          !GetIsDead(oTarget) &&
          GetArea(oTarget) == GetArea(oSource))
         return oTarget;
   }

   if (sTarget == eE_SPAWNTAG_PC)
   {
      //int nPlayerCount = eE_CountActivePlayers(oEncounter, TRUE);
      //int nPlayerCount = eE_GetPlayerCountFromArray(oEncounter);
      int nPlayerCount = eE_GetEncounterPlayerCount(oEncounter);

      // If Player count is 0, return invalid object
      if (nPlayerCount == 0)
         return OBJECT_INVALID;

      // Modulo operation for recursive fixed targeting
      nth = ((nth - 1) % nPlayerCount) + 1;
      if (nTargetMethod == eE_TARGETMETHOD_RANDOM || nTargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || eE_TARGETMETHOD_LASTTARGET_RANDOM)
         oTarget = eE_GetRandomEncounterPlayer(oEncounter);
      else if (nTargetMethod == eE_TARGETMETHOD_FIXED || nTargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL)
         oTarget = eE_GetEncounterPlayer(oEncounter, nth);
      else if ((nTargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || eE_TARGETMETHOD_LASTTARGET_NEAREST) && GetIsObjectValid(oSource))
         oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oSource);
      else // FailSafe
         oTarget = eE_GetRandomEncounterPlayer(oEncounter);
   }
   else
   {
      //int nTargetCount = eE_GetTargetCount(oEncounter, sTarget);
      //if (nTargetCount == 0)
      int nTargetCount = eE_CountTargets(oEncounter, sTarget);

      // If Target count is 0, return invalid object
      if (nTargetCount == 0)
         return OBJECT_INVALID;

      nth = ((nth - 1) % nTargetCount) + 1;
      if (nTargetMethod == eE_TARGETMETHOD_RANDOM || nTargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || eE_TARGETMETHOD_LASTTARGET_RANDOM)
         oTarget = eE_GetRandomTarget(oEncounter, sTarget);
      else if ((nTargetMethod == eE_TARGETMETHOD_FIXED) || (nTargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL))
         oTarget = eE_GetTarget(oEncounter, nth, sTarget);
      else if ((nTargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || eE_TARGETMETHOD_LASTTARGET_NEAREST) && GetIsObjectValid(oSource))
         oTarget = GetNearestObjectByTag(sTarget, oSource);
      else // FailSafe
         oTarget = eE_GetRandomTarget(oEncounter, sTarget);
   }
   return (oTarget);
}

void eE_SetLastTarget(object oObject, object oTarget)
{
   // Store the selected target on oObject
   if (GetIsObjectValid(oObject))
      SetLocalObject(oObject, eE_VAR_LASTTARGET, oTarget);
}

struct eE_EVENT eE_GetInfo_Event(object oEvent)
{
   struct eE_EVENT stEvent;
   stEvent.Type = GetLocalInt(oEvent, eE_VAR_EVENTTYPE);
   stEvent.Mode = GetLocalInt(oEvent, eE_VAR_EVENTMODE);
   stEvent.Owner = GetLocalString(oEvent, eE_VAR_EVENTOWNER);
   stEvent.OwnerObject = GetLocalObject(oEvent, eE_VAR_EVENTOWNER_OBJECT);
   stEvent.StartDelay = GetLocalFloat(oEvent, eE_VAR_ENTITY_INITIALDELAY);
   stEvent.Interval = GetLocalFloat(oEvent, eE_VAR_ENTITY_INTERVAL);
   stEvent.MaxRepeat = GetLocalInt(oEvent, eE_VAR_ENTITY_MAXREPEAT);
   stEvent.AutoUndo = GetLocalInt(oEvent, eE_VAR_EVENTUNDO);
   stEvent.KeyEvent = GetLocalInt(oEvent, eE_VAR_KEYEVENT);
   return (stEvent);
}

struct eE_EVENT_ENTITY eE_GetInfo_Entity(object oEvent)
{
   struct eE_EVENT_ENTITY stEventEntity;
   stEventEntity.Blueprint = GetLocalString(oEvent, eE_VAR_ENTITY_BLUEPRINT);
   stEventEntity.Quantity = GetLocalInt(oEvent, eE_VAR_ENTITY_QUANTITY);
   stEventEntity.MaxConcurrent = GetLocalInt(oEvent, eE_VAR_ENTITY_MAXCONCURRENT);
   stEventEntity.SpawnAt = GetLocalString(oEvent, eE_VAR_ENTITY_SPAWNAT);
   stEventEntity.SpawnMethod = GetLocalInt(oEvent, eE_VAR_ENTITY_SPAWNMETHOD);
   stEventEntity.SpawnDelay = GetLocalFloat(oEvent, eE_VAR_ENTITY_SPAWNDELAY);
   stEventEntity.SpawnEffect = GetLocalInt(oEvent, eE_VAR_ENTITY_SPAWNEFFECT);
   stEventEntity.Tag = GetLocalString(oEvent, eE_VAR_ENTITY_TAG);
   return (stEventEntity);
}

struct eE_EVENT_ENTITYEVENTS eE_GetInfo_EntityEvents(object oEvent)
{
   struct eE_EVENT_ENTITYEVENTS stEventEntityEvents;
   stEventEntityEvents.OnSpawn = GetLocalString(oEvent, eE_VAR_ENTITY_ONSPAWN);
   stEventEntityEvents.OnDeath = GetLocalString(oEvent, eE_VAR_ENTITY_ONDEATH);
   stEventEntityEvents.OnDamaged = GetLocalString(oEvent, eE_VAR_ENTITY_ONDAMAGED);
   return (stEventEntityEvents);
}

struct eE_EVENT_SPECIAL eE_GetInfo_EventSpecial(object oEvent)
{
   struct eE_EVENT_SPECIAL stEventSpecial;
   stEventSpecial.EventID = GetLocalInt(oEvent, eE_VAR_EVENTID);
   stEventSpecial.Tag = GetLocalString(oEvent, eE_VAR_ENTITY_TAG);
   return (stEventSpecial);
}

struct eE_EVENT_EFFECT eE_GetInfo_EventEffect(object oEvent)
{
   struct eE_EVENT_EFFECT stEventEffect;
   stEventEffect.Owner = GetLocalString(oEvent, eE_VAR_EVENTOWNER);
   stEventEffect.OwnerObject = GetLocalObject(oEvent, eE_VAR_EVENTOWNER_OBJECT);
   stEventEffect.Quantity = GetLocalInt(oEvent, eE_VAR_ENTITY_QUANTITY);
   stEventEffect.TargetMethod = GetLocalInt(oEvent, eE_VAR_TARGETMETHOD);
   stEventEffect.Delay = GetLocalFloat(oEvent, eE_VAR_EFFECT_DELAY);
   stEventEffect.DurationType = GetLocalInt(oEvent, eE_VAR_EFFECT_DURATIONTYPE);
   stEventEffect.Duration = GetLocalFloat(oEvent, eE_VAR_EFFECT_DURATION);
   stEventEffect.EffectType = GetLocalInt(oEvent, eE_VAR_EFFECT_TYPE);
   stEventEffect.Effect = GetLocalInt(oEvent, eE_VAR_EFFECT_EFFECT);
   stEventEffect.VisualEffect = GetLocalInt(oEvent, eE_VAR_EFFECT_VFX);
   stEventEffect.EffectTag = GetLocalString(oEvent, eE_VAR_EFFECT_EFFECTTAG);
   stEventEffect.Tag = GetLocalString(oEvent, eE_VAR_ENTITY_TAG);

   // Effect Variables
   if (stEventEffect.Effect != 0)
   {
      string sVariables = GetLocalString(oEvent, eE_VAR_EFFECT_EFFECT_VARS);
      string sToken = GetTokenByPosition(sVariables, ",", 0);
      if (sToken != "")
      {
         stEventEffect.Effect_Var1 = StringToInt(sToken);
         sToken = GetTokenByPosition(sVariables, ",", 1);
         if (sToken != "")
         {
            stEventEffect.Effect_Var2 = StringToInt(sToken);
            sToken = GetTokenByPosition(sVariables, ",", 2);
            if (sToken != "")
            {
               stEventEffect.Effect_Var3 = StringToInt(sToken);
               sToken = GetTokenByPosition(sVariables, ",", 3);
               if (sToken != "")
               {
                  stEventEffect.Effect_Var4 = StringToInt(sToken);
                  sToken = GetTokenByPosition(sVariables, ",", 4);
                  if (sToken != "")
                  {
                     stEventEffect.Effect_Var5 = StringToInt(sToken);
                     sToken = GetTokenByPosition(sVariables, ",", 5);
                     if (sToken != "")
                     {
                        stEventEffect.Effect_Var6 = StringToInt(sToken);
                     }
                  }
               }
            }
         }
      }
   }
   return (stEventEffect);
}

struct eE_EVENT_DAMAGE eE_GetInfo_EventDamage(object oEvent)
{
   struct eE_EVENT_DAMAGE stEventDamage;
   stEventDamage.Owner = GetLocalString(oEvent, eE_VAR_EVENTOWNER);
   stEventDamage.OwnerObject = GetLocalObject(oEvent, eE_VAR_EVENTOWNER_OBJECT);
   stEventDamage.Quantity = GetLocalInt(oEvent, eE_VAR_ENTITY_QUANTITY);
   stEventDamage.TargetMethod = GetLocalInt(oEvent, eE_VAR_TARGETMETHOD);
   stEventDamage.ObjectOrLocation = GetLocalInt(oEvent, eE_VAR_OBJECTLOCATION);
   stEventDamage.Effect = GetLocalInt(oEvent, eE_VAR_EFFECT_VFX);
   stEventDamage.EffectPlaceable = GetLocalString(oEvent, eE_VAR_EFFECT_VFX_PLACEABLE);
   stEventDamage.DamageAmount = GetLocalInt(oEvent, eE_VAR_DAMAGE_AMOUNT);
   stEventDamage.DamageType = GetLocalInt(oEvent, eE_VAR_DAMAGE_TYPE);
   stEventDamage.DamageRepeats = GetLocalInt(oEvent, eE_VAR_DAMAGE_REPEATS);
   stEventDamage.Duration = GetLocalFloat(oEvent, eE_VAR_EFFECT_DURATION);
   stEventDamage.WarningEffect = GetLocalInt(oEvent, eE_VAR_DAMAGE_WARNING);
   stEventDamage.WarningPlaceable = GetLocalString(oEvent, eE_VAR_DAMAGE_WARNINGPLACEABLE);
   stEventDamage.WarningDelay = GetLocalFloat(oEvent, eE_VAR_DAMAGE_WARNINGDELAY);
   stEventDamage.ShapeType = GetLocalInt(oEvent, eE_VAR_DAMAGE_DAMAGE_SHAPETYPE);
   stEventDamage.ShapeSize = GetLocalFloat(oEvent, eE_VAR_DAMAGE_DAMAGE_SHAPESIZE);
   stEventDamage.SafeZone = GetLocalFloat(oEvent, eE_VAR_DAMAGE_DAMAGE_SAFEZONE);
   stEventDamage.Tag = GetLocalString(oEvent, eE_VAR_ENTITY_TAG);
   stEventDamage.ObjectTypes = GetLocalInt(oEvent, eE_VAR_DAMAGE_OBJECTTYPES);

   return (stEventDamage);
}

struct eE_EVENT_ACTION eE_GetInfo_EventAction(object oEvent)
{
   struct eE_EVENT_ACTION stEventAction;
   stEventAction.Owner = GetLocalString(oEvent, eE_VAR_EVENTOWNER);
   stEventAction.OwnerObject = GetLocalObject(oEvent, eE_VAR_EVENTOWNER_OBJECT);
   stEventAction.EventID = GetLocalInt(oEvent, eE_VAR_EVENTID);
   stEventAction.Quantity = GetLocalInt(oEvent, eE_VAR_ENTITY_QUANTITY);
   stEventAction.Tag = GetLocalString(oEvent, eE_VAR_ENTITY_TAG);
   stEventAction.TargetMethod = GetLocalInt(oEvent, eE_VAR_TARGETMETHOD);
   stEventAction.ObjectOrLocation = GetLocalInt(oEvent, eE_VAR_OBJECTLOCATION);
   stEventAction.Spell = GetLocalInt(oEvent, eE_VAR_SPELL);
   stEventAction.SpellWarning = GetLocalInt(oEvent, eE_VAR_SPELLWARNING);
   stEventAction.SpellWarningDelay = GetLocalFloat(oEvent, eE_VAR_SPELLWARNINGDELAY);
   return (stEventAction);
}

void eE_HandleEvent(object oEncounter, object oEvent, int iEncounterStatus = eE_ENCOUNTER_STATUS_INPROGRESS, int iMode = eE_EVENTMODE_CREATE)
{
   // Check the Conditions for this Event
   if (!eE_CheckConditions(oEvent))
   {
      eE_DebugMSG(oEncounter, "Event [" + GetName(oEvent) + "] has failed it's condition check.");
      return;
   }

   // Tell the event object which encounter is activating it
   eE_SetEventEncounter(oEvent, oEncounter);

   // Get/Set important Event variables
   struct eE_EVENT Event;
   Event.Type = GetLocalInt(oEvent, eE_VAR_EVENTTYPE);
   Event.Mode = iMode;
   SetLocalInt(oEvent, eE_VAR_EVENTMODE, iMode);
   Event.Owner = GetLocalString(oEvent, eE_VAR_EVENTOWNER);
   Event.StartDelay = GetLocalFloat(oEvent, eE_VAR_ENTITY_INITIALDELAY);
   Event.AutoUndo = GetLocalInt(oEvent, eE_VAR_EVENTUNDO);
   Event.KeyEvent = GetLocalInt(oEvent, eE_VAR_KEYEVENT);

   // Reset the repeat counter for intervals
   SetLocalInt(oEvent, eE_VAR_ENTITY_CURRENTREPEAT, 0);

   // If Owner is not set in the Event, do not handle this event, but inform everyone using the Debug Message
   object oOwner;
   if (Event.Owner == "")
   {
      //eE_DebugMSG(oEncounter, "Event [" + GetName(oEvent) + "] has no owner set and is ignored.");
      //return;
      Event.Owner = eE_EVENTOWNER_ENCOUNTER;
      SetLocalString(oEvent, eE_VAR_EVENTOWNER, eE_EVENTOWNER_ENCOUNTER);
      oOwner = oEncounter;
      Event.OwnerObject = oOwner;
      SetLocalObject(oEvent, eE_VAR_EVENTOWNER_OBJECT, oOwner);
   }
   else
   {
      // Get Event.Owner as an object (oOwner) for later use
      if (Event.Owner == eE_EVENTOWNER_SELF)
      {
         oOwner = OBJECT_SELF;
         if ((GetObjectType(oOwner) != OBJECT_TYPE_CREATURE) && (GetObjectType(oOwner) != OBJECT_TYPE_PLACEABLE))
         {
            eE_DebugMSG(oEncounter, "Event [" + GetName(oEvent) + "] has 'SELF' as owner but is no creature or placeable - Event ignored.");
            return;
         }
      }
      else if (Event.Owner == eE_EVENTOWNER_ENCOUNTER)
         oOwner = oEncounter;
      else
      {
         object oContainer = GetItemPossessor(oEvent);
         oOwner = GetNearestObjectByTag(Event.Owner, oEvent);
         if (oContainer != OBJECT_INVALID)
         {
            if (GetTag(oContainer) == Event.Owner)
               oOwner = oContainer;
            else
               oOwner = GetNearestObjectByTag(Event.Owner, oEncounter);
         }
      }
      Event.OwnerObject = oOwner;
      SetLocalObject(oEvent, eE_VAR_EVENTOWNER_OBJECT, oOwner);
   }

   if (Event.Mode == eE_EVENTMODE_CREATE)
   {
      eE_DebugMSG(oEncounter, "Event [" + GetTag(oEvent) + "] active\nOwner (Name/Tag): " + GetName(Event.OwnerObject) + " / " + GetTag(Event.OwnerObject));
      // Register the event in the encounter object and mark the event as active
      // An event is active as long as it is either executed again because of a
      // set interval or as long as creatures spawned by it aren't exhausted.
      eE_RegisterEvent(oEncounter, oEvent);

      // IF this is a key event, add it to the list of key events
      if (Event.KeyEvent == 1)
      {
         // In Theory, even Events with an Interval can be Key-Events. They turn exhausted
         // everytime their active Entity-Count reaches 0. If it once reaches 0, the event
         // is marked inactive and won't fire again.
         eE_ActiveKeyEvents_Increase(oEncounter, oEvent, IntToString(iEncounterStatus));
      }
      eE_SetEventPhase(oEvent, iEncounterStatus);
      eE_SetEventStatus(oEvent, eE_EVENTSTATUS_ACTIVE);

      // Run ExecuteEvent

      // Because of timing considerations, we have to use different ways
      if (Event.StartDelay > 0.0f)
         AssignCommand(GetModule(), DelayCommand(Event.StartDelay, ExecuteScript(eE_SCRIPT_EVENT_EXECUTE, oEvent)));
      else
         ExecuteScript(eE_SCRIPT_EVENT_EXECUTE, oEvent);
   }
   else
   {
      // We're in UNDO mode here, so only Execute the UNDO of the event if Automatic Undo is set
      // and the Event is applicable for automatic undoing
      if (
          (Event.AutoUndo == eE_UNDO_AUTOMATIC) &&
          (Event.Type != 4)
         )
      {
         eE_DebugMSG(oEncounter, "Event [" + GetName(oEvent) + "] entered UNDO-Mode");
         ExecuteScript(eE_SCRIPT_EVENT_EXECUTE, oEvent);
      }
   }
}

void eE_HandleEvents(object oEncounter, string sTag, int nEncounterStatus = eE_ENCOUNTER_STATUS_INPROGRESS, string sMessagePrefix = "")
{
   // Are we working with a container or a waypoint?
   if (GetHasInventory(oEncounter))
   {
      // Get all inventory Events
      object oEvent = GetFirstItemInInventory(oEncounter);
      while (GetIsObjectValid(oEvent))
      {
         if (GetTag(oEvent) == sTag)
         {
            eE_HandleEvent(oEncounter, oEvent, nEncounterStatus);
         }
         oEvent = GetNextItemInInventory(oEncounter);
      }
   }
   else
   {
      // Get all associated Event Waypoints
      int iInitializeCount = 1;
      object oEvent = eE_GetEncounterEvent(oEncounter, sTag, iInitializeCount);
      while (GetIsObjectValid(oEvent))
      {
         eE_HandleEvent(oEncounter, oEvent, nEncounterStatus);
         iInitializeCount++;
         oEvent = eE_GetEncounterEvent(oEncounter, sTag, iInitializeCount);
      }
   }
}

int eE_CheckConditions(object oObject)
{
   int nCondition = GetLocalInt(oObject, eE_VAR_CONDITION);
   if (nCondition ==  eE_VAR_CONDITION_NONE)
      return (TRUE);

   if (nCondition & eE_VAR_CONDITION_DAYTIME)
   {
      if (!GetIsDay())
         return (FALSE);
   }
   if (nCondition & eE_VAR_CONDITION_NIGHTTIME)
   {
      if (!GetIsNight())
         return (FALSE);
   }

   // If nothing was returned yet, return TRUE
   return (TRUE);
}

void eE_OnEventExhausted(object oEvent)
{
   ExecuteScript(eE_SCRIPT_EVENT_ONEXHAUSTED, oEvent);
}

void eE_OnEventGroupExhausted(object oEvent)
{
   ExecuteScript(eE_SCRIPT_EVENTGROUP_ONEXHAUSTED, oEvent);
}

void eE_OnEncounterExhausted(object oEncounter)
{
   ExecuteScript(eE_SCRIPT_ENCOUNTER_ONEXHAUSTED, oEncounter);
}

void eE_ResetEncounter(object oEncounter)
{
   ExecuteScript(eE_SCRIPT_ENCOUNTER_RESET, oEncounter);
}

void eE_Event_Setup_General(object oEvent, int Type, string Owner, float InitialDelay, float Interval, int MaxRepeats, int Undo)
{
   SetLocalInt(oEvent, eE_VAR_EVENTTYPE, Type);
   SetLocalString(oEvent, eE_VAR_EVENTOWNER, Owner);
   SetLocalFloat(oEvent, eE_VAR_ENTITY_INITIALDELAY, InitialDelay);
   SetLocalFloat(oEvent, eE_VAR_ENTITY_INTERVAL, Interval);
   SetLocalInt(oEvent, eE_VAR_ENTITY_MAXREPEAT, MaxRepeats);
   SetLocalInt(oEvent, eE_VAR_EVENTUNDO, Undo);
}

void eE_Event_Setup_CreaturePlaceable(object oEvent, string Blueprint, int Quantity, int MaxConcurrent, string SpawnAt, float SpawnDelay, int SpawnMethod, int SpawnEffect, string Tag, string Event_OnSpawn, string Event_OnDamaged, string Event_OnDeath, string Event_OnExhaust, int KeyEvent)
{
   SetLocalString(oEvent, eE_VAR_ENTITY_BLUEPRINT, Blueprint);
   SetLocalInt(oEvent, eE_VAR_ENTITY_QUANTITY, Quantity);
   SetLocalInt(oEvent, eE_VAR_ENTITY_MAXCONCURRENT, MaxConcurrent);
   SetLocalString(oEvent, eE_VAR_ENTITY_SPAWNAT, SpawnAt);
   SetLocalFloat(oEvent, eE_VAR_ENTITY_SPAWNDELAY, SpawnDelay);
   SetLocalInt(oEvent, eE_VAR_ENTITY_SPAWNMETHOD, SpawnMethod);
   SetLocalInt(oEvent, eE_VAR_ENTITY_SPAWNEFFECT, SpawnEffect);
   SetLocalString(oEvent, eE_VAR_ENTITY_TAG, Tag);
   SetLocalString(oEvent, eE_VAR_ENTITY_ONSPAWN, Event_OnSpawn);
   SetLocalString(oEvent, eE_VAR_ENTITY_ONDAMAGED, Event_OnDamaged);
   SetLocalString(oEvent, eE_VAR_ENTITY_ONDEATH, Event_OnDeath);
   SetLocalString(oEvent, eE_VAR_EVENT_ONEXHAUST, Event_OnExhaust);
   SetLocalInt(oEvent, eE_VAR_KEYEVENT, KeyEvent);
}

void eE_CreateEvent_Creature(string Name, string sEncounterTag, string sEventTag, string Owner, string Blueprint, int Quantity, int MaxConcurrent, string SpawnAt, float SpawnDelay, int SpawnMethod, int SpawnEffect, string Tag, string Event_OnSpawn = "", string Event_OnDamaged = "", string Event_OnDeath = "", string Event_OnExhaust = "", int KeyEvent = 0, float InitialDelay = 0.0f, float Interval = 0.0f, int MaxRepeats = 0, int Undo = eE_UNDO_AUTOMATIC)
{
   object oEncounter = GetObjectByTag(sEncounterTag);
   object oEvent;
   int n = 0;
   while (GetIsObjectValid(oEncounter))
   {
      oEvent = CreateItemOnObject(eE_BLUEPRINT_BOOK, oEncounter, 1, sEventTag);
      SetName(oEvent, sEventTag + " - " + Name);
      eE_Event_Setup_General(oEvent, eE_EVENTTYPE_CREATURE, Owner, InitialDelay, Interval, MaxRepeats, Undo);
      eE_Event_Setup_CreaturePlaceable(oEvent, Blueprint, Quantity, MaxConcurrent, SpawnAt, SpawnDelay, SpawnMethod, SpawnEffect, Tag, Event_OnSpawn, Event_OnDamaged, Event_OnDeath, Event_OnExhaust, KeyEvent);

      n++;
      oEncounter = GetObjectByTag(sEncounterTag, n);
   }
}

void eE_CreateEvent_Placeable(string Name, string sEncounterTag, string sEventTag, string Owner, string Blueprint, int Quantity, int MaxConcurrent, string SpawnAt, float SpawnDelay, int SpawnMethod, int SpawnEffect, string Tag, string Event_OnSpawn = "", string Event_OnDamaged = "", string Event_OnDeath = "", string Event_OnExhaust = "", int KeyEvent = 0, float InitialDelay = 0.0f, float Interval = 0.0f, int MaxRepeats = 0, int Undo = eE_UNDO_AUTOMATIC)
{
   object oEncounter = GetObjectByTag(sEncounterTag);
   object oEvent;
   int n = 0;
   while (GetIsObjectValid(oEncounter))
   {
      oEvent = CreateItemOnObject(eE_BLUEPRINT_BOOK, oEncounter, 1, sEventTag);
      SetName(oEvent, sEventTag + " - " + Name);
      eE_Event_Setup_General(oEvent, eE_EVENTTYPE_PLACEABLE, Owner, InitialDelay, Interval, MaxRepeats, Undo);
      eE_Event_Setup_CreaturePlaceable(oEvent, Blueprint, Quantity, MaxConcurrent, SpawnAt, SpawnDelay, SpawnMethod, SpawnEffect, Tag, Event_OnSpawn, Event_OnDamaged, Event_OnDeath, Event_OnExhaust, KeyEvent);

      n++;
      oEncounter = GetObjectByTag(sEncounterTag, n);
   }
}

void eE_CreateEvent_Special(string Name, string sEncounterTag, string sEventTag, string Owner, int EventID, string Tag, float InitialDelay = 0.0f, float Interval = 0.0f, int MaxRepeats = 0, int Undo = eE_UNDO_AUTOMATIC)
{
   object oEncounter = GetObjectByTag(sEncounterTag);
   object oEvent;
   int n = 0;
   while (GetIsObjectValid(oEncounter))
   {
      oEvent = CreateItemOnObject(eE_BLUEPRINT_BOOK, oEncounter, 1, sEventTag);
      SetName(oEvent, sEventTag + " - " + Name);
      eE_Event_Setup_General(oEvent, eE_EVENTTYPE_SPECIAL, Owner, InitialDelay, Interval, MaxRepeats, Undo);
      SetLocalInt(oEvent, eE_VAR_EVENTID, EventID);
      SetLocalString(oEvent, eE_VAR_ENTITY_TAG, Tag);

      n++;
      oEncounter = GetObjectByTag(sEncounterTag, n);
   }
}

void eE_CreateEvent_Action(string Name, string sEncounterTag, string sEventTag, string Owner, int Quantity, int EventID, string Tag, int TargetMethod = eE_TARGETMETHOD_FIXED, int TargetType = eE_OBJECTLOCATION_OBJECT, int Spell = 0, int SpellWarning = 0, float SpellWarningDelay = 0.0f, float InitialDelay = 0.0f, float Interval = 0.0f, int MaxRepeats = 0)
{
   object oEncounter = GetObjectByTag(sEncounterTag);
   object oEvent;
   int n = 0;
   while (GetIsObjectValid(oEncounter))
   {
      oEvent = CreateItemOnObject(eE_BLUEPRINT_BOOK, oEncounter, 1, sEventTag);
      SetName(oEvent, sEventTag + " - " + Name);
      eE_Event_Setup_General(oEvent, eE_EVENTTYPE_ACTION, Owner, InitialDelay, Interval, MaxRepeats, eE_UNDO_MANUAL);
      SetLocalInt(oEvent, eE_VAR_ENTITY_QUANTITY, Quantity);
      SetLocalInt(oEvent, eE_VAR_EVENTID, EventID);
      SetLocalString(oEvent, eE_VAR_ENTITY_TAG, Tag);
      SetLocalInt(oEvent, eE_VAR_TARGETMETHOD, TargetMethod);
      SetLocalInt(oEvent, eE_VAR_OBJECTLOCATION, TargetType);
      SetLocalInt(oEvent, eE_VAR_SPELL, Spell);
      SetLocalInt(oEvent, eE_VAR_SPELLWARNING, SpellWarning);
      SetLocalFloat(oEvent, eE_VAR_SPELLWARNINGDELAY, SpellWarningDelay);

      n++;
      oEncounter = GetObjectByTag(sEncounterTag, n);
   }
}

void eE_CreateEvent_Effect(string Name, string sEncounterTag, string sEventTag, string Owner, int Quantity, float Delay, string Tag, int TargetMethod, int DurationType, float Duration, int EffectType, int Effect, string EffectVariables, int VFX, string EffectTag = eE_VAR_EFFECT_TAG, float InitialDelay = 0.0f, float Interval = 0.0f, int MaxRepeats = 0, int Undo = eE_UNDO_AUTOMATIC)
{
   object oEncounter = GetObjectByTag(sEncounterTag);
   object oEvent;
   int n = 0;
   while (GetIsObjectValid(oEncounter))
   {
      oEvent = CreateItemOnObject(eE_BLUEPRINT_BOOK, oEncounter, 1, sEventTag);
      SetName(oEvent, sEventTag + " - " + Name);
      eE_Event_Setup_General(oEvent, eE_EVENTTYPE_EFFECT, Owner, InitialDelay, Interval, MaxRepeats, Undo);
      SetLocalString(oEvent, eE_VAR_ENTITY_TAG, Tag);
      SetLocalInt(oEvent, eE_VAR_ENTITY_QUANTITY, Quantity);
      SetLocalFloat(oEvent, eE_VAR_EFFECT_DELAY, Delay);
      SetLocalInt(oEvent, eE_VAR_TARGETMETHOD, TargetMethod);
      SetLocalInt(oEvent, eE_VAR_EFFECT_DURATIONTYPE, DurationType);
      SetLocalFloat(oEvent, eE_VAR_EFFECT_DURATION, Duration);
      SetLocalInt(oEvent, eE_VAR_EFFECT_TYPE, EffectType);
      SetLocalInt(oEvent, eE_VAR_EFFECT_EFFECT, Effect);
      SetLocalString(oEvent, eE_VAR_EFFECT_EFFECT_VARS, EffectVariables);
      SetLocalInt(oEvent, eE_VAR_EFFECT_VFX, VFX);
      SetLocalString(oEvent, eE_VAR_EFFECT_EFFECTTAG, EffectTag);

      n++;
      oEncounter = GetObjectByTag(sEncounterTag, n);
   }
}

void eE_CreateEvent_Damage(string Name, string sEncounterTag, string sEventTag, string Owner, int Quantity, string Tag, int ObjectTypes, int TargetMethod, int TargetType, int VFX, string VFX_Placeable, int DamageAmount, int DamageType, int DamageRepeats, float Duration, int WarningVFX, string WarningPlaceable, float WarningDelay, int ShapeType, float ShapeSize, float SafeZone = 0.0f, float InitialDelay = 0.0f, float Interval = 0.0f, int MaxRepeats = 0)
{

   object oEncounter = GetObjectByTag(sEncounterTag);
   object oEvent;
   int n = 0;
   while (GetIsObjectValid(oEncounter))
   {
      oEvent = CreateItemOnObject(eE_BLUEPRINT_BOOK, oEncounter, 1, sEventTag);
      SetName(oEvent, sEventTag + " - " + Name);
      eE_Event_Setup_General(oEvent, eE_EVENTTYPE_DAMAGE, Owner, InitialDelay, Interval, MaxRepeats, eE_UNDO_MANUAL);
      SetLocalString(oEvent, eE_VAR_ENTITY_TAG, Tag);
      SetLocalInt(oEvent, eE_VAR_DAMAGE_OBJECTTYPES, ObjectTypes);
      SetLocalInt(oEvent, eE_VAR_ENTITY_QUANTITY, Quantity);
      SetLocalInt(oEvent, eE_VAR_TARGETMETHOD, TargetMethod);
      SetLocalInt(oEvent, eE_VAR_OBJECTLOCATION, TargetType);
      SetLocalInt(oEvent, eE_VAR_EFFECT_VFX, VFX);
      SetLocalString(oEvent, eE_VAR_EFFECT_VFX_PLACEABLE, VFX_Placeable);
      SetLocalInt(oEvent, eE_VAR_DAMAGE_AMOUNT, DamageAmount);
      SetLocalInt(oEvent, eE_VAR_DAMAGE_TYPE, DamageType);
      SetLocalInt(oEvent, eE_VAR_DAMAGE_WARNING, WarningVFX);
      SetLocalString(oEvent, eE_VAR_DAMAGE_WARNINGPLACEABLE, WarningPlaceable);
      SetLocalInt(oEvent, eE_VAR_DAMAGE_REPEATS, DamageRepeats);
      SetLocalFloat(oEvent, eE_VAR_EFFECT_DURATION, Duration);
      SetLocalFloat(oEvent, eE_VAR_DAMAGE_WARNINGDELAY, WarningDelay);
      SetLocalInt(oEvent, eE_VAR_DAMAGE_DAMAGE_SHAPETYPE, ShapeType);
      SetLocalFloat(oEvent, eE_VAR_DAMAGE_DAMAGE_SHAPESIZE, ShapeSize);
      SetLocalFloat(oEvent, eE_VAR_DAMAGE_DAMAGE_SAFEZONE, SafeZone);

      n++;
      oEncounter = GetObjectByTag(sEncounterTag, n);
   }
}

void eE_CreateEvent_Script(string Name, string sEncounterTag, string sEventTag, string Scriptname, string Owner, float InitialDelay = 0.0f, float Interval = 0.0f, int MaxRepeats = 0, int Undo = eE_UNDO_AUTOMATIC)
{
   object oEncounter = GetObjectByTag(sEncounterTag);
   object oEvent;
   int n = 0;
   while (GetIsObjectValid(oEncounter))
   {
      oEvent = CreateItemOnObject(eE_BLUEPRINT_BOOK, oEncounter, 1, sEventTag);
      SetName(oEvent, sEventTag + " - " + Name);
      eE_Event_Setup_General(oEvent, eE_EVENTTYPE_EXECUTESCRIPT, Owner, InitialDelay, Interval, MaxRepeats, Undo);
      SetLocalString(oEvent, eE_VAR_EVENT_SCRIPTNAME, Scriptname);

      n++;
      oEncounter = GetObjectByTag(sEncounterTag, n);
   }
}

void eE_CreateEvent_KeyEvents_Exhausted(string sEncounterTag, string Event_Key_Tag, string Event_Execute_Tag)
{
   object oEncounter = GetObjectByTag(sEncounterTag);
   int n = 0;
   while (GetIsObjectValid(oEncounter))
   {
      SetLocalString(oEncounter, Event_Key_Tag + "_OnExhaust", Event_Execute_Tag);

      n++;
      oEncounter = GetObjectByTag(sEncounterTag, n);
   }
}

void eE_CreateEncounter(string Name, string sWayPointTag, string sEncounterTag, int Condition = eE_VAR_CONDITION_NONE, float DespawnInterval = 120.0f, string Event_Initialize = "event_initialize", string Event_InProgress = "event_inprogress", float Cooldown = 1800.0f, int MessageLevel = eE_MESSAGELEVEL_NONE)
{
   // Get the first Waypoint
   object oWaypoint = GetObjectByTag(sWayPointTag);
   location lLocation;
   object oEncounter;
   int n = 0;
   while (GetIsObjectValid(oWaypoint))
   {
      lLocation = GetLocation(oWaypoint);
      oEncounter = CreateObject(OBJECT_TYPE_STORE, eE_BLUEPRINT_STORE, lLocation, FALSE, sEncounterTag);
      SetLocalObject(oEncounter, eE_VAR_WAYPOINT, oWaypoint);
      SetLocalString(oEncounter, eE_VAR_ENCOUNTERNAME, Name);
      SetLocalInt(oEncounter, eE_VAR_CONDITION, Condition);
      SetLocalFloat(oEncounter, eE_VAR_DESPAWNINTERVAL, DespawnInterval);
      SetLocalString(oEncounter, eE_VAR_INITIALIZETAG, Event_Initialize);
      SetLocalString(oEncounter, eE_VAR_EVENTTAG, Event_InProgress);
      SetLocalFloat(oEncounter, eE_VAR_COOLDOWN, Cooldown);
      SetLocalInt(oEncounter, eE_VAR_ENCOUNTER_MESSAGELEVEL, MessageLevel);
      n++;
      oWaypoint = GetObjectByTag(sWayPointTag, n);
   }
}
