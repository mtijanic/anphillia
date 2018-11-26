/************************************************************************
 * script name  : eE_ent_OnDmg
 * created by   : eyesolated
 * date         : 2018/7/17
 *
 * description  : OnDamaged script for entities (creatures/placeables) spawned
 *                using eyesolated Encounters
 *
 * changes      : 2018/7/17 - eyesolated - Initial creation
 ************************************************************************/
 #include "ee_inc"
 #include "x0_i0_enemy"

void main()
{
    // Retrieve necessary eE Variables for this creature
    object oEncounter = eE_GetEntityEncounter(OBJECT_SELF);

    // If anyone called this from the wrong place, oEncounter is not a valid
    // object and therefor we exit this function.
    if (!GetIsObjectValid(oEncounter))
    {
        if (eE_SCRIPT_CREATURE_ONDAMAGED != "")
            ExecuteScript(eE_SCRIPT_CREATURE_ONDAMAGED, OBJECT_SELF);
        else
            ExecuteScript(GetLocalString(OBJECT_SELF, eE_VAR_ENTITY_AI_ONDAMAGED), OBJECT_SELF);

        return;
    }

    // Retrieve the eE Event Object Tag for this creatures OnDamaged
    string sEventTag = eE_GetEntityEventTag(OBJECT_SELF, eE_VAR_ENTITY_ONDAMAGED);

    int nCurrentHitPoints = GetCurrentHitPoints();
    int nRestriction = GetLocalInt(OBJECT_SELF, eE_VAR_RESTRICT_DAMAGERANGE);
    if (nRestriction != 0 &&
        nCurrentHitPoints > 0)
    {
        object oLastDamager = GetLastDamager();
        float fDistance = GetDistanceToObject(oLastDamager);

        int nUndoDamage = FALSE;
        string sMessage;
        switch (nRestriction)
        {
            case eE_RESTRICT_DAMAGERANGE_MELEE:
                if (fDistance > MELEE_DISTANCE)
                {
                    sMessage = "You are too far away to damage " + GetName(OBJECT_SELF);
                    nUndoDamage = TRUE;
                }
                break;
            case eE_RESTRICT_DAMAGERANGE_RANGE:
                if (fDistance <= MELEE_DISTANCE)
                {
                    sMessage = "You are too close to deal damage to " + GetName(OBJECT_SELF);
                    nUndoDamage = TRUE;
                }
                break;
        }

        if (nUndoDamage)
        {
            int nDamageDealt = GetTotalDamageDealt();
            effect eHeal = EffectHeal(nDamageDealt);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, OBJECT_SELF);

            // Tell the player the attack didn't work
            SendMessageToPC(oLastDamager, sMessage);
        }
    }

    // Find out our current HP
    int nMaxHitPoints = GetMaxHitPoints();
    float fPercentage = IntToFloat(nCurrentHitPoints) / IntToFloat(nMaxHitPoints) * 100;
    int nPercentage = FloatToInt(fPercentage);
    if (IntToFloat(nPercentage) < fPercentage)
        nPercentage++;

    // If the EventTag is not empty, handle the Events
    if (sEventTag != "")
    {
        // Find out what Dmg Threshold got executed last
        int nLastExecuted = GetLocalInt(OBJECT_SELF, eE_VAR_ONDAMAGED_EXECUTED) - 1;
        if (nLastExecuted == -1)  // No execution yet
            nLastExecuted = 100;

        // Handle all events that we missed
        int nExecute;
        for (nExecute = nLastExecuted; nExecute >= nPercentage; nExecute--)
            eE_HandleEvents(oEncounter, sEventTag + "_" + IntToString(nExecute));

        // Save the new value for handled Events on the Creature
        SetLocalInt(OBJECT_SELF, eE_VAR_ONDAMAGED_EXECUTED, nExecute);
    }

    // Now execute the standard NWN thingie if this is a creature or placeable
    int nObjectType = GetObjectType(OBJECT_SELF);
    if (nObjectType == OBJECT_TYPE_CREATURE ||
        nObjectType == OBJECT_TYPE_PLACEABLE)
    {
        ExecuteScript(GetLocalString(OBJECT_SELF, eE_VAR_ENTITY_AI_ONDAMAGED), OBJECT_SELF);
    }
}
