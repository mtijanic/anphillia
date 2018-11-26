/************************************************************************
 * script name  : eE_trig_onexit
 * created by   : eyesolated
 * date         : 2011/6/1
 *
 * description  : Removes the exiting object (PC) to the Active Players
 *
 * changes      : 2010/6/1 - eyesolated - Initial creation
 ************************************************************************/

// Includes
#include "eE_inc"

void main()
{
   object oPC = GetExitingObject();
   if (!GetIsPC(oPC))
      return;
   if (GetIsDM(oPC))
      return;

   string sTriggerTag = GetTag(OBJECT_SELF);
   string sEncounterTag = GetStringRight(sTriggerTag, GetStringLength(sTriggerTag) - 3);
   object oEncounter = GetNearestObjectByTag(sEncounterTag, OBJECT_SELF);

   eE_RemovePlayerFromArray(oEncounter, oPC);

   //SendMessageToPC(oPC, "You left the area of [" + eE_GetEncounterName(oEncounter) + "]. There are " + IntToString(eE_GetPlayerCountFromArray(oEncounter)) + " active players left.");

   // When there are no more players left and the encounter is in progress, this is a wipe
   if ((eE_GetPlayerCountFromArray(oEncounter) == 0) && (eE_GetEncounterStatus(oEncounter) == eE_ENCOUNTER_STATUS_INPROGRESS))
   {
      float fDespawn = GetLocalFloat(oEncounter, eE_VAR_DESPAWNINTERVAL);
      SendMessageToPC(oPC, "You are the last player that left the encounter area. You have " + FloatToString(fDespawn, 0, 2) + " seconds to return to the encounter area and prevent a wipe.");
      AssignCommand(GetModule(), DelayCommand(fDespawn, ExecuteScript(eE_SCRIPT_ENCOUNTER_WIPE, oEncounter)));
   }
}
