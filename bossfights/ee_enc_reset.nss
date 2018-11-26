/************************************************************************
 * script name  : eE_encounter_reset
 * created by   : eyesolated
 * date         : 2011/6/1
 *
 * description  : Resets an eE Encounter.
 *
 * notes        : The caller of this script must be an eE Object.
 *
 * changes      : 2011/6/1 - eyesolated - Initial creation
 ************************************************************************/

#include "ee_inc"

void main()
{
   object oEncounter = OBJECT_SELF;

   int nEncounterStatus = eE_GetEncounterStatus(oEncounter);

   if (
       (nEncounterStatus != eE_ENCOUNTER_STATUS_INITIALIZED) &&
       (nEncounterStatus != eE_ENCOUNTER_STATUS_INPROGRESS) &&
       (nEncounterStatus != eE_ENCOUNTER_STATUS_ONCOOLDOWN)
      )
   {
      eE_DebugMSG(oEncounter, "Reset aborted - wrong Encounter Status");
      return;
   }

   // This is a hard-reset of an encounter. Destroy everything and set
   // The encounter status back to idle
   eE_SetEncounterStatus(oEncounter, eE_ENCOUNTER_STATUS_RESETTING);

   int nRegisteredEvents = eE_GetRegisteredEvents(oEncounter);
   int n;
   object oEvent;
   string sTag;
   string sCheck = "";
   float fDelay = 0.0f;
   float fInterval = 0.0f;
   for (n = 1; n <= nRegisteredEvents; n++)
   {
      oEvent = eE_GetEvent(oEncounter, n);
      eE_SetActiveKeyEvents(oEncounter, GetTag(oEvent), 0);

      // Undo the event
      eE_HandleEvent(oEncounter, oEvent, eE_ENCOUNTER_STATUS_RESETTING, eE_EVENTMODE_UNDO);

      // Destroy all Event Entities (Once per unique Tag)
      /*sTag = GetLocalString(oEvent, eE_VAR_ENTITY_TAG);
      if (FindSubString(sCheck, "[" + sTag + "]") == -1)
      {
         sCheck += "[" + sTag + "]";
         eE_DestroyEncounterEntity(oEncounter, sTag);
      }*/

      // Find out the hightest Interval of all Events
      fInterval = GetLocalFloat(oEvent, eE_VAR_ENTITY_INTERVAL);
      if (fInterval > fDelay)
         fDelay = fInterval;

      // Reset all important event variables
      eE_SetEventStatus(oEvent, eE_EVENTSTATUS_INACTIVE);
      DeleteLocalInt(oEvent, eE_VAR_EVENTCREATURECOUNT);
      DeleteLocalInt(oEvent, eE_VAR_ENTITY_MAXDYNAMICQUANTITY);
   }

   // Reset all important encounter variables
   eE_SetRegisteredEvents(oEncounter, 0);

   // eE_ReportRegisteredEvents(oEncounter);

   // Add a second to our Delay to be sure
   fDelay += 1.0f;
   AssignCommand(GetModule(), DelayCommand(0.1f, eE_DebugMSG(oEncounter, "Encounter will be Reset in " + FloatToString(fDelay, 0, 1) + " Seconds")));
   // If the Encounter isn't on Cooldown, set it's status to IDLE after the reset
   if (nEncounterStatus != eE_ENCOUNTER_STATUS_ONCOOLDOWN)
   {
      AssignCommand(GetModule(), DelayCommand(fDelay, eE_SetEncounterStatus(oEncounter, eE_ENCOUNTER_STATUS_IDLE)));
   }
   AssignCommand(GetModule(), DelayCommand(fDelay + 0.1f, eE_DebugMSG(oEncounter, "Reset Finished")));

   // Remove the Encounter from the Area Arrays
   eE_Encounter_RemoveFromArea(oEncounter, GetArea(oEncounter), eE_VAR_AREA_ENCOUNTERARRAY_INI);
   eE_Encounter_RemoveFromArea(oEncounter, GetArea(oEncounter), eE_VAR_AREA_ENCOUNTERARRAY_PROG);
}
