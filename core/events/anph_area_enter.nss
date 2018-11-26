#include "dbg_inc"
#include "faction_inc"

void main()
{
    object oArea = OBJECT_SELF;
    object oPC = GetEnteringObject();
    if (!GetIsPC(oPC))
    {
        if (GetLocalInt(oArea, "AREA_NO_MONSTERS"))
        {
            if (GetLocalInt(oPC, "AREA_TRANSITION_IN_PROGRESS") && GetIsEncounterCreature(oPC) && !GetIsDMPossessed(oPC))
                DestroyObject(oPC);
        }
        return;
    }

    int bDM = GetIsDM(oPC);
    if (!bDM)
    {
        int nPlayersInArea = GetLocalInt(oArea, "AREA_PLAYER_COUNT");
        SetLocalInt(oArea, "AREA_PLAYER_COUNT", ++nPlayersInArea);

        if (GetLocalInt(oArea, "AREA_EXPLORED"))
            ExploreAreaForPlayer(oArea, oPC);


        if (nPlayersInArea == 1) // first one in, reset AIs for non-despawned creatures
        {
            if (GetLocalInt(oArea, "AREA_AI_LOWERED"))
            {
                object oCreature = GetFirstObjectInArea(oArea);
                while (oCreature != OBJECT_INVALID)
                {
                    if (GetIsEncounterCreature(oCreature) && !GetIsDMPossessed(oCreature) && !GetPlotFlag(oCreature))
                    {
                        SetAILevel(oCreature, AI_LEVEL_DEFAULT);
                    }
                    oCreature = GetNextObjectInArea(oArea);
                }
                DeleteLocalInt(oArea, "AREA_AI_LOWERED");
            }
        }

        if (nPlayersInArea > 1)
        {
            if (GetLocalInt(oArea, "AREA_NEUTRAL_ZONE"))
            {
                object oOtherPC = GetFirstPC();
                while (oOtherPC != OBJECT_INVALID)
                {
                    if (oPC != oOtherPC && GetArea(oOtherPC) == OBJECT_SELF && !GetIsDM(oOtherPC))
                    {
                        SetPCLike(oPC, oOtherPC);
                        SetPCLike(oOtherPC, oPC);
                    }
                    oOtherPC = GetNextPC();
                }
            }
        }
    }


    // Update PC in database after every transition
    if (!bDM)
    {
        DelayCommand(0.2, ExecuteScript("sql_update_pc", oPC));
        ExportSingleCharacter(oPC);
    }

    // Execute eE's OnAreaEnter Script
    ExecuteScript("ee_area_onenter", oArea);

    // Does nothing, but let's keep for now..
    DeleteLocalInt(oPC, "FromFugue");
    DeleteLocalInt(oPC, "AREA_TRANSITION_IN_PROGRESS");
}
