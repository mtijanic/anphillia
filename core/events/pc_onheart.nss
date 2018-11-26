#include "util_inc"
#include "nwnx_creature"

void main()
{
    object oPC = OBJECT_SELF;
    int nMovementType = NWNX_Creature_GetMovementType(oPC);

    int nRunCounter = GetLocalInt(oPC, "PC_RUN_COUNTER");
    if (nMovementType == NWNX_CREATURE_MOVEMENT_TYPE_RUN)
    {
        nRunCounter++;
        if (nRunCounter > 4)
        {
            SendMessageToPC(oPC, "You've been running for a while now. Please don't run without reason.");
            if (nRunCounter % 10 == 0)
            {
                SendMessageToAllDMs(GetName(oPC) + " has been running for " + IntToString(nRunCounter) + " ticks.");
            }
        }
        SetLocalInt(oPC, "PC_RUN_COUNTER", nRunCounter);
        return; // Bail early since you can't run if encumbered.
    }
    else if (nRunCounter > 0)
    {
        SetLocalInt(oPC, "PC_RUN_COUNTER", --nRunCounter);
    }

    // Not moving at all nor fighting, carry on..
    int bInCombat = GetIsInCombat(oPC);
    if (nMovementType == NWNX_CREATURE_MOVEMENT_TYPE_STATIONARY && !bInCombat)
        return;

    int nWeight = GetWeight(oPC);
    int nSTR = GetAbilityScore(oPC, ABILITY_STRENGTH);
    int nLightEnc = StringToInt(Get2DAString("encumbrance", "Normal", nSTR));

    // Not running, not encumbered, carry on..
    if (nWeight < nLightEnc)
        return;

    int nFallChance = 0;
    int nHeavyEnc = StringToInt(Get2DAString("encumbrance", "Heavy", nSTR));

    int bSidestep = nMovementType == NWNX_CREATURE_MOVEMENT_TYPE_SIDESTEP;
    if (bSidestep)
        nFallChance += 15;

    int nExtra = nWeight - nHeavyEnc - 30;
    if (nExtra > 0)
    {
        int nPercent = (nExtra*100) / nHeavyEnc;
        nPercent = min(99, nPercent);

        nFallChance += nPercent/2;
        if (bSidestep)
            nFallChance += 25;
        if (bInCombat)
            nFallChance += 10;
    }

    if (nFallChance > 0)
    {
        int nRoll = Random(100);
        if (nRoll < nFallChance)
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectKnockdown()), oPC, 3.0);
            string sMessage = "Due to your heavy load";
            if (bInCombat) sMessage += " and combat";
            if (bSidestep) sMessage += " and sidestepping";
            sMessage += " you slip and fall to the ground.";
            SendMessageToPC(oPC, sMessage);
        }
        else if (nRoll + 20 < nFallChance)
        {
            SendMessageToPC(oPC, "You slip but manage to keep your balance.");
        }
    }

}
