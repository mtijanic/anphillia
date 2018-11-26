/************************************************************************
 * script name  : creature_inc
 * created by   : eyesolated
 * date         : 2018/8/28
 *
 * description  : central include file for creature related functions
 *
 * changes      : 2018/8/28 - eyesolated - Initial creation
 ************************************************************************/

#include "creature_cfg"
#include "color_inc"

string creature_GetOriginalName(object oCreature);

void creature_SetName(object oCreature, int nDisplay = CREATURE_NAME_DISPLAY_ORIGINAL_HEALTH);

// Retrieves the original Name of oCreature
string creature_GetOriginalName(object oCreature)
{
    return GetName(oCreature, TRUE);
}

void creature_SetName(object oCreature, int nDisplay = CREATURE_NAME_DISPLAY_ORIGINAL_HEALTH)
{
    string sName = "";

    // Original Name
    if ((nDisplay & CREATURE_NAME_DISPLAY_ORIGINAL) != 0)
    {
        sName += creature_GetOriginalName(oCreature);
    }

    // Health Percentage
    if ((nDisplay & CREATURE_NAME_DISPLAY_HEALTH) != 0)
    {
        int nMaxHitPoints = GetMaxHitPoints(oCreature);
        int nCurrentHitPoints = GetCurrentHitPoints(oCreature);

        float fPercentage = IntToFloat(nCurrentHitPoints) / IntToFloat(nMaxHitPoints) * 100;
        int nPercentage = FloatToInt(fPercentage);
        if (IntToFloat(nPercentage) < fPercentage)
            nPercentage++;

        // If the calculated Percentage is the same as before, return
        if (nPercentage != GetLocalInt(oCreature, CREATURE_VAR_LAST_HEALTH_PERCENTAGE_SET))
        {
            if (nCurrentHitPoints > 0 &&
                nPercentage > 0)
            {
                int nGreen;
                int nRed;

                if (nPercentage >= 50)
                {
                    nGreen = 7;
                    nRed = FloatToInt(IntToFloat(100 - nPercentage) / 7);
                }
                else
                {
                    nRed = 7;
                    nGreen = FloatToInt(IntToFloat(nPercentage) / 7);
                }
                string sColor = IntToString(nRed) + IntToString(nGreen) + "0";

                if (sName != "")
                    sName += " - ";

                sName += color_ConvertString(IntToString(nPercentage) + "%", sColor);
                SetLocalInt(oCreature, CREATURE_VAR_LAST_HEALTH_PERCENTAGE_SET, nPercentage);
            }
        }
    }

    SetName(oCreature, sName);
}
