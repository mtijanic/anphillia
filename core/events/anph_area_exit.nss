#include "faction_inc"
void main()
{
    object oArea = OBJECT_SELF;
    object oPC = GetExitingObject();
    SetLocalInt(oPC, "AREA_TRANSITION_IN_PROGRESS", 1);

    if (!GetIsPC(oPC))
        return;

    if (!GetIsDM(oPC))
    {
        int nPlayerCount = GetLocalInt(oArea, "AREA_PLAYER_COUNT");
        SetLocalInt(oArea, "AREA_PLAYER_COUNT", --nPlayerCount);
        if (nPlayerCount == 0)
        {
            string sOldScript = GetEventScript(oArea, EVENT_SCRIPT_AREA_ON_HEARTBEAT);
            if (sOldScript != "")
                SetLocalString(oArea, "AREA_HEARTBEAT_SCRIPT", sOldScript);
            SetEventScript(oArea, EVENT_SCRIPT_AREA_ON_HEARTBEAT, "anph_area_hb");
        }
    }

    if (GetLocalInt(oArea, "AREA_NEUTRAL_ZONE"))
    {
        int nFaction = fctn_GetFaction(oPC);
        object oOtherPC = GetFirstPC();
        while (oOtherPC != OBJECT_INVALID)
        {
            if (oPC != oOtherPC && GetArea(oOtherPC) == OBJECT_SELF && !GetIsDM(oOtherPC))
            {
                if (fctn_GetIsFactionHostile(nFaction, fctn_GetFaction(oOtherPC)))
                {
                    SetPCDislike(oPC, oOtherPC);
                    SetPCDislike(oOtherPC, oPC);
                }
            }
            oOtherPC = GetNextPC();
        }
    }

    // Execute eE's OnAreaExit Script
    ExecuteScript("ee_area_onexit", oArea);

}
