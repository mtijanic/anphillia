/************************************************************************
 * script name  : eE_event_onexhausted
 * created by   : eyesolated
 * date         : 2011/6/1
 *
 * description  : OnExhausted script for eyesolated Encounters Events.
 *
 * notes        : This script is called by eyesolated Encounters, do NOT
 *                add it anywhere yourself!
 *
 * changes      : 2011/6/1 - eyesolated - Initial creation
 ************************************************************************/

#include "ee_inc"

void main()
{
   object oEncounter = eE_GetEventEncounter(OBJECT_SELF);

   eE_DebugMSG(oEncounter, GetName(OBJECT_SELF) + " exhausted");
   // Retrieve the eE Event Object Tag for this Events OnExhaust
   string sEventTag = GetLocalString(OBJECT_SELF, eE_VAR_EVENT_ONEXHAUST);

   // If the EventTag is empty, there no events associated with this creature's OnSpawn
   if (sEventTag != "")
   {
      eE_HandleEvents(oEncounter, sEventTag);
   }
}
