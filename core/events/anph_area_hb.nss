#include "faction_inc"
void main()
{
    object oArea = OBJECT_SELF;
    string sOldScript = GetLocalString(oArea, "AREA_HEARTBEAT_SCRIPT");

    int nPlayerCount = GetLocalInt(oArea, "AREA_PLAYER_COUNT");
    if (nPlayerCount == 0)
    {
        int nHB = GetLocalInt(oArea, "AREA_HEARTBEAT_COUNT");
        if (nHB >= 50) // 5 minutes till depop
        {
            SetEventScript(oArea, EVENT_SCRIPT_AREA_ON_HEARTBEAT, sOldScript);
            object oCreature = GetFirstObjectInArea(oArea);
            while (oCreature != OBJECT_INVALID)
            {
                if (GetIsEncounterCreature(oCreature) && !GetIsDMPossessed(oCreature) && !GetPlotFlag(oCreature))
                {
                    if ((GetStandardFactionReputation(STANDARD_FACTION_HOSTILE, oCreature) >= 90) ||
                        fctn_GetFaction(oCreature) == ANPH_FACTION_NONE)
                    {
                        DestroyObject(oCreature);
                    }
                    else
                    {
                        SetLocalInt(oArea, "AREA_AI_LOWERED", 1);
                        SetAILevel(oCreature, AI_LEVEL_VERY_LOW);
                    }
                }
                oCreature = GetNextObjectInArea(oArea);
            }
        }
        else
        {
            SetLocalInt(oArea, "AREA_HEARTBEAT_COUNT", nHB+1);
        }
    }
    else
    {
        SetLocalInt(oArea, "AREA_HEARTBEAT_COUNT", 0);
        SetEventScript(oArea, EVENT_SCRIPT_AREA_ON_HEARTBEAT, sOldScript);
    }
    ExecuteScript(sOldScript, oArea);

}
