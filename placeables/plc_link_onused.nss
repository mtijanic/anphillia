#include "color_inc"

void main()
{
    object oOther = GetLocalObject(OBJECT_SELF, "PLC_LINK_OTHER");
    if (!GetIsObjectValid(oOther))
    {
        SendMessageToAllDMs(COLOR_CODE_RED + "Link " + GetName(OBJECT_SELF) + " in " + GetName(GetArea(OBJECT_SELF))+ " has no other end."+ COLOR_CODE_END);
    }
    else
    {
        AssignCommand(GetLastUsedBy(), JumpToObject(oOther));
    }
}
