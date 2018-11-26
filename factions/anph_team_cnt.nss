#include "sql_inc"
#include "faction_inc"

int StartingConditional()
{
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
    return TRUE;
}

