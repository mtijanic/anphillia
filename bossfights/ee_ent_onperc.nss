/************************************************************************
 * script name  : eE_ent_OnSpawn
 * created by   : eyesolated
 * date         : 2011/6/1
 *
 * description  : OnPerceived script for entities (creatures/placeables) spawned
 *                using eyesolated Encounters.
 *
 * changes      : 2011/6/1 - eyesolated - Initial creation
 ************************************************************************/
#include "ee_inc"

void main()
{
   // Retrieve necessary eE Variables for this creature
   object oEncounter = eE_GetEntityEncounter(OBJECT_SELF);
   object oPerceived = GetLastPerceived();
   // if the encounter object is invalid or
   // if the perceived object is not a PC able to activate the encounter,
   // execute the default script and exit immediately
   if (
       !GetIsObjectValid(oEncounter) ||
       !GetIsPC(oPerceived) ||
       GetIsDM(oPerceived)
      )
   {
      if (eE_SCRIPT_CREATURE_ONPERCEPTION != "")
         ExecuteScript(eE_SCRIPT_CREATURE_ONPERCEPTION, OBJECT_SELF);
      else
         ExecuteScript(GetLocalString(OBJECT_SELF, eE_VAR_ENTITY_AI_ONPERCEPTION), OBJECT_SELF);
      return;
   }

   // Activate the encounter if it is Initialized
   if (eE_GetEncounterStatus(oEncounter) == eE_ENCOUNTER_STATUS_INITIALIZED)
   {
      ExecuteScript(eE_SCRIPT_ENCOUNTER_START, oEncounter);
   }

   // Now execute the standard NWN thingie if this is a creature
   if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_CREATURE)
   {
      ExecuteScript(GetLocalString(OBJECT_SELF, eE_VAR_ENTITY_AI_ONPERCEPTION), OBJECT_SELF);
   }
 }
