/************************************************************************
 * script name  : eE_ent_OnDeath
 * created by   : eyesolated
 * date         : 2011/6/1
 *
 * description  : OnDeath script for entities (creatures/placeables) spawned
 *                using eyesolated Encounters
 *
 * changes      : 2011/6/1 - eyesolated - Initial creation
 ************************************************************************/
 #include "ee_inc"

void main()
{
   // Retrieve necessary eE Variables for this creature
   object oEncounter = eE_GetEntityEncounter(OBJECT_SELF);

   // If anyone called this from the wrong place, oEncounter is not a valid
   // object and therefor we exit this function.
   if (!GetIsObjectValid(oEncounter))
   {
      if (eE_SCRIPT_CREATURE_ONDEATH != "")
         ExecuteScript(eE_SCRIPT_CREATURE_ONDEATH, OBJECT_SELF);
      else
      {
         string sDeathScript = GetLocalString(OBJECT_SELF, eE_VAR_ENTITY_AI_ONDEATH);
         if (sDeathScript != "")
            ExecuteScript(sDeathScript, OBJECT_SELF);
      }

      return;
   }

   object oParentEvent = eE_GetEntityEvent(OBJECT_SELF);

   // Retrieve the eE Event Object Tag for this creatures OnDeath
   string sEventTag = eE_GetEntityEventTag(OBJECT_SELF, eE_VAR_ENTITY_ONDEATH);

   // If the EventTag is not empty, handle the Events
   if (sEventTag != "")
      eE_HandleEvents(oEncounter, sEventTag);

   // If caller is an entity that belongs to a Key Event, check if
   // the Event is exhausted or not.
   int iObjectType = GetObjectType(OBJECT_SELF);
   //if (GetLocalInt(oParentEvent, eE_VAR_KEYEVENT))
   //{
      int iCurrentEventCreatures = GetLocalInt(oParentEvent, eE_VAR_EVENTCREATURECOUNT);
      iCurrentEventCreatures--;
      SetLocalInt(oParentEvent, eE_VAR_EVENTCREATURECOUNT, iCurrentEventCreatures);

      eE_DebugMSG(oEncounter, GetName(OBJECT_SELF) + " died - Current event creatures: " + IntToString(iCurrentEventCreatures) + ".");
      //If there are no more creatures in this event, set it to inactive
      // but only if it's either a non-repeating event OR has an onexhaustscript
      if (iCurrentEventCreatures == 0)
      {
         // maybe this is a repeating event w/o OnExhaust Event
         float fInterval = GetLocalFloat(oParentEvent, eE_VAR_ENTITY_INTERVAL);
         string sOnExhaust = GetLocalString(oParentEvent, eE_VAR_EVENT_ONEXHAUST);

         if (
             (fInterval == 0.0f) ||
             (sOnExhaust != "")
            )
         {
            // Reset all important event variables
            eE_SetEventStatus(oParentEvent, eE_EVENTSTATUS_INACTIVE);
            DeleteLocalInt(oParentEvent, eE_VAR_ENTITY_MAXDYNAMICQUANTITY);

            // Key-Event?
            if (GetLocalInt(oParentEvent, eE_VAR_KEYEVENT))
            {
               eE_DebugMSG(oEncounter, GetName(OBJECT_SELF) + " died - Decreasing Active Keyevents.");
               eE_ActiveKeyEvents_Decrease(oEncounter, oParentEvent, IntToString(eE_GetEventPhase(oParentEvent)));
            }

            eE_OnEventExhausted(oParentEvent);
         }
      }
      // Check if the encounter is exhausted if this was a key event
      if (
          (eE_GetIsEncounterExhausted(oEncounter)) &&
          ((GetLocalInt(oParentEvent, eE_VAR_KEYEVENT)))
         )
      {
         // Debug Message that creature died
         eE_DebugMSG(oEncounter, GetName(OBJECT_SELF) + " died - Encounter exhausted.");
         eE_OnEncounterExhausted(oEncounter);
      }
   //}

   // Now execute the standard NWN thingie if this is a creature or placeable
   int nObjectType = GetObjectType(OBJECT_SELF);
   if (nObjectType == OBJECT_TYPE_CREATURE ||
       nObjectType == OBJECT_TYPE_PLACEABLE)
   {
      ExecuteScript(GetLocalString(OBJECT_SELF, eE_VAR_ENTITY_AI_ONDEATH), OBJECT_SELF);
   }
 }
