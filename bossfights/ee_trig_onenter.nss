/************************************************************************
 * script name  : eE_trig_onenter
 * created by   : eyesolated
 * date         : 2011/6/1
 *
 * description  : Adds the entering object (PC) to the Active Players
 *
 * changes      : 2010/6/1 - eyesolated - Initial creation
 ************************************************************************/

// Includes
#include "eE_inc"

void main()
{
   object oPC = GetEnteringObject();
   if (!GetIsPC(oPC))
      return;
   if (GetIsDM(oPC))
      return;

   string sTriggerTag = GetTag(OBJECT_SELF);
   string sEncounterTag = GetStringRight(sTriggerTag, GetStringLength(sTriggerTag) - 3);
   object oEncounter = GetNearestObjectByTag(sEncounterTag, OBJECT_SELF);

   // Set this encounter to be trigger-size driven
   SetLocalInt(oEncounter, eE_VAR_SIZE, eE_ENCOUNTER_SIZE_TRIGGER);

   // Create the player Array
   eE_AddPlayerToArray(oEncounter, oPC);

   //SendMessageToPC(oPC, "You entered the area of [" + eE_GetEncounterName(oEncounter) + "]. There now are " + IntToString(eE_GetPlayerCountFromArray(oEncounter)) + " active players.");
}
