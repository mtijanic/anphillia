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

    string sOldDesc = GetLocalString(oExamined, "XEVENT_EXAMINE_DESC");
    SetDescription(oExamined, sOldDesc);
}
