/************************************************************************
 * script name  : eE_initialize
 * created by   : eyesolated
 * date         : 2011/6/1
 *
 * description  : Initializes an eE encounter. The encounter object must be
 *                the script executor.
 *
 * changes      : 2010/6/1 - eyesolated - Initial creation
 ************************************************************************/

#include "ee_inc"

void main()
{
   object oEncounter = OBJECT_SELF;

   // Check if our Encounter object has the variable Event Tag set.
   if (GetLocalString(oEncounter, eE_VAR_INITIALIZETAG) == "")
   {
      eE_DebugMSG(oEncounter, "Invalid Encounter Object");
      return;
   }

   // Only enabled encounters can be initialized
   int iDisabled = GetLocalInt(oEncounter, eE_VAR_ENCOUNTER_DISABLED);
   if (iDisabled != 0)
   {
      eE_DebugMSG(oEncounter, "Initialize failed - Encounter Disabled");
      return;
   }

   // Only initialize oEncounter if it meets the set Condition(s)
   if (!eE_CheckConditions(oEncounter))
   {
      eE_DebugMSG(oEncounter, "Initialize failed - Condition check failed");
      return;
   }

   // Only initialize oEncounter if it's ready to start, i.e. not already in
   // progress or on cooldown
   int nEncounterStatus = eE_GetEncounterStatus(oEncounter);
   if (nEncounterStatus != eE_ENCOUNTER_STATUS_IDLE)
   {
      string sStatus;
      switch (nEncounterStatus)
      {
         case eE_ENCOUNTER_STATUS_INITIALIZING: sStatus = "Initializing"; break;
         case eE_ENCOUNTER_STATUS_INITIALIZED: sStatus = "Initialized"; break;
         case eE_ENCOUNTER_STATUS_INPROGRESS: sStatus = "In Progress"; break;
         case eE_ENCOUNTER_STATUS_ONCOOLDOWN: sStatus = "On Cooldown"; break;
         case eE_ENCOUNTER_STATUS_RESETTING: sStatus = "Resetting"; break;
      }
      eE_DebugMSG(oEncounter, "Initialize failed - Encounter not [" + sStatus + "]!");
      return;
   }
   // Set Encounter Status to Initializing
   eE_SetEncounterStatus(oEncounter, eE_ENCOUNTER_STATUS_INITIALIZING);

   string sTag = GetLocalString(oEncounter, eE_VAR_INITIALIZETAG);
   eE_HandleEvents(oEncounter, sTag, eE_ENCOUNTER_STATUS_INITIALIZING);

   // Set the encounter as Initialized
   eE_DebugMSG(oEncounter, "Initialized...");
   eE_SetEncounterStatus(oEncounter, eE_ENCOUNTER_STATUS_INITIALIZED);

   // we need to tell the area oEncounter is in that this encounter has entered the
   // initialized state and should despawn if all players left.
   // The encounter is removed from this Array as soon as it is started or all
   // players left the area. The Array in the area always knows which encounters it
   // has to manage
   eE_Encounter_AddToArea(oEncounter, GetArea(oEncounter), eE_VAR_AREA_ENCOUNTERARRAY_INI);
}
