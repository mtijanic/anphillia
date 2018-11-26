#include "faction_inc"
#include "sql_inc"
#include "nwnx_dialog"
// [Select] or "Select faction"
void main()
{
    object oPC = GetPCSpeaker();
    
    if (NWNX_Dialog_GetCurrentNodeText() == "[Select]")
    {
        SetLocalString(oPC, "INTRO_FACTION", GetLocalString(oPC, "DLGX_LAST_SELECTION"));
    }
    SetCustomToken(5552, GetLocalString(oPC, "INTRO_FACTION"));

    NWNX_SQL_ExecuteQuery("SELECT Faction, COUNT(*) FROM " + SQL_TABLE_CHARDATA + " WHERE IsOnline=1 GROUP BY Faction");

    string sMessage = "There are currently\n";
    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();

        string faction = fctn_GetFactionName(StringToInt(NWNX_SQL_ReadDataInActiveRow(0)));
        if (faction == "None") continue;

        string count = NWNX_SQL_ReadDataInActiveRow(1);
        sMessage += ".) " + count + " " + faction + "\n";
    }

    sMessage = sMessage + "\nonline. If you have any doubts on which side to join, it is best to pick the one with fewer warriors";
    SetCustomToken(5550, sMessage);
}
