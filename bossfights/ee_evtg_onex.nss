/************************************************************************
 * script name	: eE_eventgroup_onexhausted 
 * created by	: eyesolated
 * date			: 2011/6/1
 *
 * description	: OnExhausted script for eyesolated Encounters Event Groups.
 *
 * notes        : This script is called by eyesolated Encounters, do NOT
 *                add it anywhere yourself!
 *
 * changes		: 2011/6/1 - eyesolated - Initial creation
 ************************************************************************/
 
#include "ee_inc"

void main()
{
   string sEventGroup = GetTag(OBJECT_SELF);
   object oEncounter = eE_GetEventEncounter(OBJECT_SELF);
   eE_DebugMSG(oEncounter, "Event Group " + sEventGroup + " exhausted");
   // Retrieve the eE Event Object Tag for this Event Group's OnExhaust
   string sEventTag = GetLocalString(oEncounter, sEventGroup + "_OnExhaust");
   
   // If the EventTag is empty, there no events associated with this creature's OnSpawn
   if (sEventTag != "")
   {
      eE_HandleEvents(oEncounter, sEventTag);
   }
}