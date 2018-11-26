#include "faction_inc"
#include "nwnx_time"

void main()
{
    object oPC = GetPCSpeaker();
    int nFaction = fctn_GetFaction(oPC);

    // Make sure PC and NPC are same faction..
    if (fctn_GetFaction(OBJECT_SELF) != nFaction)
    {
        dbg_Warning("PC requested payout from non faction member "+GetName(OBJECT_SELF), oPC);
        SendMessageToPC(oPC, "Only your faction quartermaster can give you a payout");
        SetCustomToken(12555, "I'm afraid we only pay out our own members.");
        return;
    }
    int nLevel = util_GetLevel(oPC);
    if (nLevel < 2)
    {
        SetCustomToken(12555, "I'm afraid we don't give payouts to fresh recruits. Once you've proven yourself, an officer will add your name to the list.");
        return;
    }

    int tNow = NWNX_Time_GetTimeStamp();
    int pcid = chr_GetPCID(oPC);

    int interval = sql_GetVarInt("ANPH_PAYOUT_"+IntToString(nFaction)+"_INTERVAL");
    int tLastPayout = SQLExecAndFetchInt("SELECT MAX(timestamp) FROM "+SQL_TABLE_PAYOUTS+" WHERE PCID="+IntToString(pcid));
    if ((tNow - tLastPayout) < interval)
    {
        SetCustomToken(12555, "Hrm.. [checks the logs] I believe you've already received this week's compensation.");
        return;
    }

    string sMainQuery = "SELECT Item, Pool, BaseAmount, ExtraPerLevel, CostMultiplier FROM "+SQL_TABLE_PAYOUTDATA+
        " WHERE Faction="+IntToString(nFaction)+" AND IsActive=1 AND MinLevel<="+IntToString(nLevel) + " LIMIT 1";
    NWNX_SQL_ExecuteQuery(sMainQuery);

    if (!NWNX_SQL_ReadyToReadNextRow())
    {
        SetCustomToken(12555, "By order of the captain, all payouts are currently suspended.");
        return;
    }
    string sStuff = "";

    string sMissing = "";
    int offset = 1; // Need to run queries in the loop, so offset the main one each iteration.
    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        string sResRef = NWNX_SQL_ReadDataInActiveRow(0);
        string sPool = NWNX_SQL_ReadDataInActiveRow(1);
        int nBaseAmount = StringToInt(NWNX_SQL_ReadDataInActiveRow(2));
        float fExtraPerLevel = StringToFloat(NWNX_SQL_ReadDataInActiveRow(3));
        float fCostMultiplier = StringToFloat(NWNX_SQL_ReadDataInActiveRow(4));
        int nAmount = nBaseAmount + FloatToInt(fExtraPerLevel * nLevel);

        object oTmpItem = CreateItemOnObject(sResRef, OBJECT_SELF);
        int nPrice = max(GetGoldPieceValue(oTmpItem), 1) * nAmount;
        if (sResRef == "GOLD")
            nPrice = 10*nAmount;

        nPrice = FloatToInt(nPrice * fCostMultiplier);

        string sName = (sResRef == "GOLD") ? "Gold Piece" : GetName(oTmpItem);
        if (fctn_Pay(nFaction, nPrice, sPool))
        {
            sStuff += IntToString(nAmount) + "x " + sName + "; ";
            if (sResRef == "GOLD")
                GiveGoldToCreature(oPC, nAmount);
            else
                while (nAmount--) CreateItemOnObject(sResRef, oPC);
        }
        else
        {
            sMissing += (sMissing == "" ? " " : ", ") + sName;
            fctn_SendMessageToFaction(color_ConvertString("Your faction's "+sPool+" reserves have been depleted.", COLOR_RED), nFaction);
        }

        DestroyObject(oTmpItem);
        NWNX_SQL_ExecuteQuery(sMainQuery + " OFFSET " + IntToString(offset++));
    }

    if (sStuff != "")
    {
        NWNX_SQL_PrepareQuery("INSERT INTO "+SQL_TABLE_PAYOUTS+" (PCID,Faction,Timestamp,Stuff) VALUES(?,?,?,?)");
        NWNX_SQL_PreparedInt(0, pcid);
        NWNX_SQL_PreparedInt(1, nFaction);
        NWNX_SQL_PreparedInt(2, tNow);
        NWNX_SQL_PreparedString(3, sStuff);
        NWNX_SQL_ExecutePreparedQuery();

        string sReply = "Here you go: " + sStuff;
        if (sMissing != "")
            sReply += "I'm afraid that we are all out of " + sMissing + ". I will notify the captian.";
        SetCustomToken(12555, sReply);
    }
    else
    {
        SetCustomToken(12555, "I'm afraid our resreves are completely gone. Come again in a bit, there might be something then.");
    }
}
