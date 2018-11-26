/************************************************************************
 * script name  : eE_mob_OnSpawn
 * created by   : eyesolated
 * date         : 2011/6/1
 *
 * description  : OnSpawn script for creature entities spawned using
 *                eyesolated Encounters.
 *
 * notes        : This script is called by eyesolated Encounters, do NOT
 *                add it to a creatures OnSpawn Event yourself! Calling it
 *                from a creature's OnSpawn script wouldn't work because
 *                eE_GetEntityEncounter wouldn't return anything.
 *
 * changes      : 2011/6/1 - eyesolated - Initial creation
 ************************************************************************/
#include "ee_inc"

void main()
{
   // Retrieve necessary eE Variables for this creature
   object oEncounter = eE_GetEntityEncounter(OBJECT_SELF);

   // If anyone called this from the wrong place, oEncounter is not a valid
   // object and therefor we exit this function.
   if (!GetIsObjectValid(oEncounter))
   {
      return;
   }

   // Set the entity's AI Scripts to eE while remembering their current scripts
   if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_CREATURE)
   {
      SetLocalString(OBJECT_SELF, eE_VAR_ENTITY_AI_ONDEATH, GetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_DEATH));
      SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_DEATH, eE_SCRIPT_ENTITY_ONDEATH);

      SetLocalString(OBJECT_SELF, eE_VAR_ENTITY_AI_ONDAMAGED, GetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_DAMAGED));
      SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_DAMAGED, eE_SCRIPT_ENTITY_ONDAMAGED);

      SetLocalString(OBJECT_SELF, eE_VAR_ENTITY_AI_ONPERCEPTION, GetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_NOTICE));
      SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_NOTICE, eE_SCRIPT_ENTITY_ONPERCEPTION);
   }
   else if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE)
   {
      SetLocalString(OBJECT_SELF, eE_VAR_ENTITY_AI_ONDEATH, GetEventScript(OBJECT_SELF, EVENT_SCRIPT_PLACEABLE_ON_DEATH));
      SetEventScript(OBJECT_SELF, EVENT_SCRIPT_PLACEABLE_ON_DEATH, eE_SCRIPT_ENTITY_ONDEATH);

      SetLocalString(OBJECT_SELF, eE_VAR_ENTITY_AI_ONDAMAGED, GetEventScript(OBJECT_SELF, EVENT_SCRIPT_PLACEABLE_ON_DAMAGED));
      SetEventScript(OBJECT_SELF, EVENT_SCRIPT_PLACEABLE_ON_DAMAGED, eE_SCRIPT_ENTITY_ONDAMAGED);
   }

   // Rename the mob if there's a variable on the encounter object or an associated waypoint object
   string sNewName = GetLocalString(oEncounter, GetTag(OBJECT_SELF));
   if (sNewName == "")
   {
      // Try to find an associated waypoint
      object oWaypoint = GetLocalObject(oEncounter, eE_VAR_WAYPOINT);
      if (GetIsObjectValid(oWaypoint))
      {
         sNewName = GetLocalString(oWaypoint, GetTag(OBJECT_SELF));
      }
   }
   if (sNewName != "")
      SetName(OBJECT_SELF, sNewName);

   // Retrieve the eE Event Object Tag for this creatures OnSpawn
   string sEventTag = eE_GetEntityEventTag(OBJECT_SELF, eE_VAR_ENTITY_ONSPAWN);

   // If the EventTag is empty, there no events associated with this creature's OnSpawn
   if (sEventTag != "")
   {
      eE_HandleEvents(oEncounter, sEventTag);
   }
}
