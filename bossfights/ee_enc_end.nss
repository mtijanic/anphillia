/************************************************************************
 * script name  : eE_end
 * created by   : eyesolated
 * date         : 2011/6/1
 *
 * description  : Ends an eE encounter.
 *                The encounter object must be the script executor.
 *
 * changes      : 2010/6/1 - eyesolated - Initial creation
 ************************************************************************/

#include "ee_inc"

void main()
{
   object oEncounter = OBJECT_SELF;

   // An encounter can enter a cooldown if it's either Initialized or InProgress
   int iStatus = eE_GetEncounterStatus(oEncounter);
   if ((iStatus == eE_ENCOUNTER_STATUS_INITIALIZED) ||
       (iStatus == eE_ENCOUNTER_STATUS_INPROGRESS))
   {
      // End an Encounter and activate it's cooldown
      eE_StartCooldown(oEncounter);

      // Reset the Encounter too, undoing all create events registered
      eE_ResetEncounter(oEncounter);
   }
   else
   {
      eE_DebugMSG(oEncounter, "Couldn't set on cooldown");
   }
}
