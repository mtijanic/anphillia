#include "color_inc"

void main()
{
    object oMod = GetModule();
    object oOther = GetLocalObject(oMod, "PLC_LINK_OTHER");
    if (!GetIsObjectValid(oOther))
    {
        SendMessageToAllDMs(COLOR_CODE_BLUE_DARK + "First link placed. Next time you place a link placeable it will be linked to this one" + COLOR_CODE_END);
        SetLocalObject(oMod, "PLC_LINK_OTHER", OBJECT_SELF);
    }
    else
    {
        SetLocalObject(OBJECT_SELF, "PLC_LINK_OTHER", oOther);
        SetLocalObject(oOther, "PLC_LINK_OTHER", OBJECT_SELF);
        SendMessageToAllDMs(COLOR_CODE_BLUE_DARK + 
            "Linked " + GetName(OBJECT_SELF) + " in " + GetName(GetArea(OBJECT_SELF)) +
            " with "  + GetName(oOther) + " in " + GetName(GetArea(oOther)) + COLOR_CODE_END);
        DeleteLocalObject(oMod, "PLC_LINK_OTHER");
    }

    SetEventScript(OBJECT_SELF, EVENT_SCRIPT_PLACEABLE_ON_HEARTBEAT, "");
}
