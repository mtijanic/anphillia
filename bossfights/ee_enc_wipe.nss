/************************************************************************
 * script name  : eE_enc_wipe
 * created by   : eyesolated
 * date         : 2011/6/1
 *
 * description  : This script checks wheter the encounter wiped and initiates
 *                appropriate actions.
 *
 * changes      : 2010/6/1 - eyesolated - Initial creation
 ************************************************************************/

// Includes
#include "eE_inc"

void main()
{
   // This script self-checks every 15 seconds as long as the encounter
   // is in Progress.
   object oEncounter = OBJECT_SELF;

   if (eE_GetEncounterStatus(oEncounter) == eE_ENCOUNTER_STATUS_INPROGRESS)
   {
      // Get the player count again
      if (eE_GetEncounterPlayerCount(oEncounter) > 0)
      {
         eE_DebugMSG(oEncounter, "Wipe prevented.");
         return;
      }

      if (GetLocalInt(oEncounter, eE_VAR_CDAFTERWIPE) == eE_VAR_CDAFTERWIPE_ENABLED)
      {
         // End the encounter
         eE_DebugMSG(oEncounter, "Wipe, initiating reset and cooldown...");
         ExecuteScript(eE_SCRIPT_ENCOUNTER_END, oEncounter);
      }
      else
      {
         // Reset the encounter
         eE_DebugMSG(oEncounter, "Wipe, initiating reset...");
         eE_ResetEncounter(oEncounter);
      }
   }
}
