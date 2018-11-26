#include "nwnx_events"
#include "nwnx_object"
#include "color_inc"

// OnExamine BEFORE event
void main()
{
    object oPC = OBJECT_SELF;
    if (!GetIsPC(oPC))
        return;

    object oExamined = NWNX_Object_StringToObject(NWNX_Events_GetEventData("EXAMINEE_OBJECT_ID"));
    if (!GetIsObjectValid(oExamined))
        return;

    string sOldDesc = GetDescription(oExamined);
    SetLocalString(oExamined, "XEVENT_EXAMINE_DESC", sOldDesc);

    string sEffects = "\n\n" + COLOR_CODE_VIOLET + "Magical effects:\n";

    sEffects += "You are unable to spot any magical effects on this object";

    sEffects += COLOR_CODE_END;
    SetDescription(oExamined, sOldDesc + sEffects);
}
