/************************************************************************
 * script name  : eE_trig_init
 * created by   : eyesolated
 * date         : 2011/6/1
 *
 * description  : Initializes the linked eE Encounter upon a PC entering
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

   // Initialize this Encounter
   ExecuteScript(eE_SCRIPT_ENCOUNTER_INITIALIZE, oEncounter);
}
