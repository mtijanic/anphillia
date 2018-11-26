#include "anph_inc"
#include "nwnx_time"

void main()
{
    object oUser = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    if (!GetIsPC(oTarget))
    {
        SendMessageToPC(oUser, "This tool is used to get detailed PC info, must target a PC.");
        return;
    }

    SendMessageToPC(oUser, "------------------------------------------");
    SendMessageToPC(oUser, anph_DescribePC(oTarget));


    int nPCID = chr_GetPCID(oTarget);
    NWNX_SQL_ExecuteQuery("SELECT Deaths, PVPKills, Playtime, DonatedStuff, IsDead FROM "
                            +SQL_TABLE_CHARDATA+" WHERE PCID="+IntToString(nPCID));

    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        string sDeaths = NWNX_SQL_ReadDataInActiveRow(0);
        string sPVPKills = NWNX_SQL_ReadDataInActiveRow(1);
        string sPlaytime = NWNX_SQL_ReadDataInActiveRow(2);
        string sDonated = NWNX_SQL_ReadDataInActiveRow(3);
        string sIsDead = NWNX_SQL_ReadDataInActiveRow(4);

        SendMessageToPC(oUser, "Total deaths:"+sDeaths + "; Total PvP Kills:"+sPVPKills +
            "; Total playtime: "+sPlaytime+" seconds (~" + IntToString((StringToInt(sPlaytime)+1800) / 3600) + " hours)" +
            "; Total gear donated worth: " + sDonated + "; IsDead:" + sIsDead);
    }

    int tNow = NWNX_Time_GetTimeStamp();
    int tLastFlush = GetLocalInt(oTarget, "XP_LastFlush");
    int nUnflushed = GetLocalInt(oTarget, "XP_Unflushed");
    int nBanked    = GetLocalInt(oTarget, "XP_Banked");
    int nLost      = GetLocalInt(oTarget, "XP_Lost");
    float fMod     = GetLocalFloat(oTarget, "XP_Multipler");
    SendMessageToPC(oUser, "\nXP system data: " +
        IntToString(tNow - tLastFlush) + "s (~" + IntToString((tNow - tLastFlush+1800)/3600) + " hours) since flush. " +
        IntToString(nUnflushed) + " unflushed XP, " +
        IntToString(nBanked) + " banked XP, " +
        IntToString(nLost) + " lost XP, " +
        " personal XP multiplier: " + FloatToString(fMod, 3, 2));

    SendMessageToPC(oUser, "------------------------------------------");
}

