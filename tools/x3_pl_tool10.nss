// Anphillia UNSTUCK Tool.

#include "dbg_inc"
#include "util_inc"
#include "color_inc"
#include "dev_inc"
void main()
{
    object oPC = OBJECT_SELF;
    location loc = GetSpellTargetLocation();

    string sMsg = "UNSTUCK tool used. Source:"+util_EncodeLocation(GetLocation(oPC)) + "  Target:"+util_EncodeLocation(loc) + " PC:"+GetName(oPC) + "(" + GetPCPublicCDKey(oPC) + ")";
    WriteTimestampedLogEntry(sMsg);
    if (!dev_IsTeamMember(oPC))
        dbg_Warning(sMsg, oPC);
    SendMessageToPC(oPC, COLOR_CODE_ORANGE_LIGHT+"UNSTUCK tool used. This tool is OOC and should only be used for fixing bugs when a PC gets stuck. Every use is logged and abuse will be punished." + COLOR_CODE_END);

    AssignCommand(oPC, JumpToLocation(loc));
}
