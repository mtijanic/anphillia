/************************************************************************
 * script name  : eE_OnAreaExit
 * created by   : eyesolated
 * date         : 2011/6/1
 *
 * description  : eE's OnAreaExit Script keeps track of current players
 *                in the Area and resets encounters as necessary when no more
 *                players are in the Area
 *
 * changes      : 2010/6/1 - eyesolated - Initial creation
 ************************************************************************/
#include "ee_inc"

void main()
{
   object oArea = OBJECT_SELF;
   object oPC = GetExitingObject();

   // If the exiting object is not a PC, exit
   if (!GetIsPC(oPC))
      return;

   // If the exiting object is a DM, exit
   if (GetIsDM(oPC))
      return;

   int nPlayerCount = GetLocalInt(oArea, "AREA_PLAYER_COUNT");

   //SendMessageToPC(oPC, "Exiting Area... there are now " + IntToString(nPlayerCount) + " players left.");

   // If the player count reached 0, reset all initialized encounters
   if (nPlayerCount == 0)
   {
      // We need to get all Encounters in the Area Encounter Array and reset those
      object oEncounter;
      while (eas_Array_GetSize(oArea, eE_VAR_AREA_ENCOUNTERARRAY_INI) > 0)
      {
         eE_DebugMSG(oEncounter, "no more players in Area, resetting encounter");
         oEncounter = eas_OArray_Entry_Get(oArea, eE_VAR_AREA_ENCOUNTERARRAY_INI, 0);
         ExecuteScript(eE_SCRIPT_ENCOUNTER_RESET, oEncounter);
      }

      // Then, we need to do silent wipe checks for all encounters that are in Progress
      int nEncountersInProgress = eas_Array_GetSize(oArea, eE_VAR_AREA_ENCOUNTERARRAY_PROG);
      int n;
      for (n = 0; n < nEncountersInProgress; n++)
      {
         eE_DebugMSG(oEncounter, "no more players in Area, initiating wipe check");
         oEncounter = eas_OArray_Entry_Get(oArea, eE_VAR_AREA_ENCOUNTERARRAY_PROG, n);
         float fDespawn = GetLocalFloat(oEncounter, eE_VAR_DESPAWNINTERVAL);

         /* Area sized encounters don't give a wipe warning
         SendMessageToPC(oPC, "You have " + FloatToString(fDespawn, 0, 2) + " seconds to return to the encounter area and prevent a wipe.");
         */
         AssignCommand(GetModule(), DelayCommand(fDespawn, ExecuteScript(eE_SCRIPT_ENCOUNTER_WIPE, oEncounter)));
      }
   }
}
