/************************************************************************
 * script name  : eE_start
 * created by   : eyesolated
 * date         : 2011/6/1
 *
 * description  : Starts an eE encounter (activates associated events).
 *                The encounter object must be the script executor.
 *
 * changes      : 2010/6/1 - eyesolated - Initial creation
 ************************************************************************/

#include "ee_inc"

void main()
{
   object oEncounter = OBJECT_SELF;

   // Only start oEncounter if it's ready to start, i.e. not already in
   // progress or on cooldown
   if (eE_GetEncounterStatus(oEncounter) != eE_ENCOUNTER_STATUS_INITIALIZED)
   {
      eE_DebugMSG(oEncounter, "Encounter Status not [Initialized]!");
      return;
   }
   // Set the encounter as being in progress
   eE_SetEncounterStatus(oEncounter, eE_ENCOUNTER_STATUS_INPROGRESS);

   // Inform DMs on an encounter with MessageLevel of at least 1
   int iEncounterMessageLevel = GetLocalInt(oEncounter, eE_VAR_ENCOUNTER_MESSAGELEVEL);
   if (iEncounterMessageLevel >= eE_MESSAGELEVEL_LOW)
      SendMessageToAllDMs(eE_GetEncounterName(oEncounter) + " started in " + GetName(GetArea(oEncounter)));

   // If the EventTag is empty, there no events associated with this encounters Activation
   if (GetLocalString(oEncounter, eE_VAR_EVENTTAG) != "")
   {
      string sTag = GetLocalString(oEncounter, eE_VAR_EVENTTAG);
      eE_HandleEvents(oEncounter, sTag);
   }

   // Get the encounter's Area
   object oArea = GetArea(oEncounter);

   // Remove the encounter from the Area Array of initialized encounters
   eE_Encounter_RemoveFromArea(oEncounter, oArea, eE_VAR_AREA_ENCOUNTERARRAY_INI);

   // Add the encounter to the Area Array of inprogress encounters
   eE_Encounter_AddToArea(oEncounter, oArea, eE_VAR_AREA_ENCOUNTERARRAY_PROG);
}
