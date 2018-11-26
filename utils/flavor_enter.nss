#include "color_inc"
#include "util_inc"
#include "dbg_inc"


void main()
{
    object oTrigger = OBJECT_SELF;
    object oPC = GetEnteringObject();

    string sText = "";

    if (GetLocalInt(oTrigger, "FLAVOR_ONCE_PER_PC"))
    {
        if (GetLocalInt(oPC, "FLAVOR_TEXT_" + ObjectToString(oTrigger)))
            return;
        SetLocalInt(oPC, "FLAVOR_TEXT_" + ObjectToString(oTrigger), 1);
    }

    switch (util_GetDayPeriod())
    {
        case PERIOD_DAY:   sText = GetLocalString(oTrigger, "FLAVOR_TEXT_DAY");   break;
        case PERIOD_NIGHT: sText = GetLocalString(oTrigger, "FLAVOR_TEXT_NIGHT"); break;
        case PERIOD_DAWN:  sText = GetLocalString(oTrigger, "FLAVOR_TEXT_DAWN");  break;
        case PERIOD_DUSK:  sText = GetLocalString(oTrigger, "FLAVOR_TEXT_DUSK");  break;
    }

    if (sText == "")
        sText = GetLocalString(oTrigger, "FLAVOR_TEXT");
    if (sText == "")
    {
        dbg_Warning("Terrain trigger string not found", oPC);
        return;
    }

    // Apply color effects
    string sRGB  = GetLocalString(oTrigger, "FLAVOR_TEXT_RGB");
    if (sRGB != "")
        sText = color_ConvertString(sText, sRGB);

    // Send the message to the PC
    FloatingTextStringOnCreature(sText, oPC, FALSE);
}
