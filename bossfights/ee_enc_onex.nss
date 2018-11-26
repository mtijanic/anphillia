/************************************************************************
 * script name  : eE_encounter_onexhausted
 * created by   : eyesolated
 * date         : 2011/6/1
 *
 * description  : OnExhausted script for eyesolated Encounters.
 *
 * notes        : This script is called by eyesolated Encounters, do NOT
 *                add it anywhere yourself!
 *
 * changes      : 2011/6/1 - eyesolated - Initial creation
 ************************************************************************/

#include "ee_inc"

void Undo(object oEncounter)
{
   // Try to Soft-Undo all Events
   int iRegisteredEvents = eE_GetRegisteredEvents(oEncounter);
   int i;
   object oEvent;
   string sTag;
   string sCheck = "";
   //float fDelay = 0.0f;
   //float fInterval = 0.0f;
   for (i = 1; i <= iRegisteredEvents; i++)
   {
      oEvent = eE_GetEvent(oEncounter, i);
      eE_SetActiveKeyEvents(oEncounter, GetTag(oEvent), 0);

      eE_HandleEvent(oEncounter, oEvent, eE_ENCOUNTER_STATUS_ONCOOLDOWN, eE_EVENTMODE_UNDO);

      // Find out the hightest Interval of all Events
      //fInterval = GetLocalFloat(oEvent, eE_VAR_ENTITY_INTERVAL);
      //if (fInterval > fDelay)
      //   fDelay = fInterval;

      // Reset all important event variables
      eE_SetEventStatus(oEvent, eE_EVENTSTATUS_INACTIVE);
      DeleteLocalInt(oEvent, eE_VAR_EVENTCREATURECOUNT);
      DeleteLocalInt(oEvent, eE_VAR_ENTITY_MAXDYNAMICQUANTITY);
   }

   // Reset all important encounter variables
   eE_SetRegisteredEvents(oEncounter, 0);
}

void main()
{
   object oEncounter = OBJECT_SELF;
   string sMessage = "Encounter exhausted";

   float fEncounterCD = GetLocalFloat(oEncounter, eE_VAR_COOLDOWN);

   // if respawn CD is 0, this is a one-time encounter
   if (fEncounterCD != 0.0f)
   {
      sMessage += "\nCooldown finished in " + FloatToString(fEncounterCD, 0, 2) + " Seconds";
      eE_SetEncounterStatus(oEncounter, eE_ENCOUNTER_STATUS_ONCOOLDOWN);
      AssignCommand(GetModule(), DelayCommand(fEncounterCD, eE_SetEncounterStatus(oEncounter, eE_ENCOUNTER_STATUS_IDLE)));
   }

   // Shortly before the encounter is active again, undo it's stuff
   AssignCommand(GetModule(), DelayCommand(fEncounterCD - 5.0f, Undo(oEncounter)));

   // Remove the encounter from the In Progress Area Array
   eE_Encounter_RemoveFromArea(oEncounter, GetArea(oEncounter), eE_VAR_AREA_ENCOUNTERARRAY_PROG);

   // Debug MSG
   eE_DebugMSG(oEncounter, sMessage);

   // Send a victory message to players
   eE_SendMessageToActivePlayers(oEncounter, "Congratulations, you defeated [" + eE_GetEncounterName(oEncounter) + "]");
}
