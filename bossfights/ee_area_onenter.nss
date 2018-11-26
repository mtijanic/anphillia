/************************************************************************
 * script name  : eE_OnAreaEnter
 * created by   : eyesolated
 * date         : 2011/6/1
 *
 * description  : eE's OnAreaEnter Script keeps track of current players
 *                in the Area.
 *
 * changes      : 2010/6/1 - eyesolated - Initial creation
 ************************************************************************/
#include "ee_inc"

void main()
{
   object oArea = OBJECT_SELF;
   object oPC = GetEnteringObject();

   // If the entering object is not a PC, exit
   if (!GetIsPC(oPC))
      return;

   // If the entering object is a DM, exit
   if (GetIsDM(oPC))
      return;

   int n = 1;
   object oEncounter = GetNearestObject(OBJECT_TYPE_STORE, oPC, n);

   while (GetIsObjectValid(oEncounter))
   {
      if (GetLocalInt(oEncounter, eE_VAR_ENCOUNTER_AUTOINI) == eE_ENCOUNTER_AUTOINI_ENABLED)
      {
         // Initialize this Encounter
         ExecuteScript(eE_SCRIPT_ENCOUNTER_INITIALIZE, oEncounter);
      }
      n++;
      oEncounter = GetNearestObject(OBJECT_TYPE_STORE, oPC, n);
   }
}
