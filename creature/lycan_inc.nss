/************************************************************************
 * script name  : lycan_inc
 * created by   : eyesolated
 * date         : 2018/7/10
 *
 * description  : Central include file for Lycanthropy system
 ************************************************************************/

#include "lycan_cfg"

// Turns oObject into sResRef; Returns TRUE if the creature was Turned
int lycan_TurnInto(object oObject, int nTurnInto, int nVisualEffect);

// Performs a Morph if necessary; Returns TRUE if oObject was turned
int lycan_Check(object oObject);

// Gets a random speak string when turning intot he lycan
string lycan_GetRandomSpeakString();

string lycan_GetRandomSpeakString()
{
    string sReturn = "";
    int nRandom = Random(7);
    switch (nRandom)
    {
        case 0: break; // no string
        case 1: sReturn = "Aaargh... the... paaaiiiiin"; break;
        case 2: sReturn = "What is happening to meeeaarrgh..."; break;
        case 3: sReturn = "No.. this can't be happening..."; break;
        case 4: sReturn = "Ruun away... ack... RUN AWAY!.."; break;
        case 5: sReturn = "What is happening to meeeaarrgh..."; break;
        case 6: sReturn = "*Howls in agony*"; break;
    }
    return sReturn;
}

void lycan_SpawnIn(string sResRef, location lLocation, float fHPFactor, int nTurnInto, string sResRefFrom)
{
    object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lLocation);

    // Set correct TurnInto Target
    if (nTurnInto == LYCAN_TURNINTO_NIGHT)
        SetLocalString(oCreature, LYCAN_VAR_DAY_TURNINTO, sResRefFrom);
    else
        SetLocalString(oCreature, LYCAN_VAR_NIGHT_TURNINTO, sResRefFrom);

    int nHPMax = GetMaxHitPoints(oCreature);
    int nHPCurrent = FloatToInt(nHPMax * fHPFactor);

    effect eDamage = EffectDamage(nHPMax - nHPCurrent, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_PLUS_TWENTY);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oCreature);
}

int lycan_TurnInto(object oObject, int nTurnInto, int nVisualEffect)
{
    // Check if we're supposed to turn
    string sResRef;
    if (nTurnInto == LYCAN_TURNINTO_DAY)
    {
        sResRef = GetLocalString(oObject, LYCAN_VAR_DAY_TURNINTO);
        if (sResRef == "")
            return FALSE;
    }
    else
    {
        sResRef = GetLocalString(oObject, LYCAN_VAR_NIGHT_TURNINTO);
        if (sResRef == "")
            return FALSE;

        SpeakString(lycan_GetRandomSpeakString());
        // Make them cringe
        PlayAnimation(ANIMATION_LOOPING_SPASM, 1.0f, 3.0f);
    }

    // Get Module
    object oModule = GetModule();

    // Get Location
    location lLocation = GetLocation(oObject);

    // Get Hitpoints
    int nHPMax = GetMaxHitPoints(oObject);
    int nHPCurrent = GetCurrentHitPoints(oObject);
    float fFactor = IntToFloat(nHPCurrent) / IntToFloat(nHPMax);

    // Activate SpawnIn
    AssignCommand(oModule, DelayCommand(3.25f, lycan_SpawnIn(sResRef, lLocation, fFactor, nTurnInto, GetResRef(oObject))));

    // Destroy self
    if (nVisualEffect != -1)
    {
        effect eVis = EffectVisualEffect(nVisualEffect);
        AssignCommand(oModule, DelayCommand(2.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oObject)));
    }

    AssignCommand(oModule, DelayCommand(3.0f, DestroyObject(oObject)));

    return TRUE;
}

int lycan_Check(object oObject)
{
    // Prevent multiple checks / spawns
    if (GetLocalInt(oObject, "lycan_checking") == 0)
    {
        SetLocalInt(oObject, "lycan_checking", 1);
        int nIsDay = GetIsDay();
        int nIsNight = GetIsNight();

        int nResult;
        if (nIsDay)
            nResult = lycan_TurnInto(oObject, LYCAN_TURNINTO_DAY, VFX_COM_CHUNK_RED_MEDIUM);
        else if (nIsNight)
            nResult = lycan_TurnInto(oObject, LYCAN_TURNINTO_NIGHT, VFX_COM_CHUNK_RED_MEDIUM);
        else
            nResult = FALSE;

        DeleteLocalInt(oObject, "lycan_checking");
        return nResult;
    }

    return FALSE;
}
