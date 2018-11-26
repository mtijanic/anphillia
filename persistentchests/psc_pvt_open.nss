#include "sql_inc"
#include "util_inc"
#include "dbg_inc"
#include "chr_inc"

void main()
{
    object chest = OBJECT_SELF;
    object pc = GetLastOpenedBy();

    if (!GetIsPC(pc) || GetIsDM(pc))
        return;

    int pcid = chr_GetPCID(pc);

    // Already initialized for this PCID
    if (GetLocalInt(chest, "PSC_PVT_PCID") == pcid)
        return;

    string tag = GetTag(chest);

    int n = 0;
    while (TRUE)
    {
        object other = GetObjectByTag(tag, n++);
        if (other == OBJECT_INVALID)
            break;

        if (other != chest && GetLocalInt(other, "PSC_PVT_PCID") == pcid)
        {
            SendMessageToPC(pc, "You already have your personal chest open elsewhere");
            return;
        }
    }


    //SendMessageToPC(pc, "Personal chests have not been extensively tested yet. Please don't put anything of value in it today.");
    util_ClearInventory(chest);

    NWNX_SQL_PrepareQuery("SELECT ID, Object FROM " + SQL_TABLE_PLAYERCHESTS + " WHERE Tag=? AND PCID=?");
    NWNX_SQL_PreparedString(0, tag);
    NWNX_SQL_PreparedInt(1, pcid);
    NWNX_SQL_ExecutePreparedQuery();

    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        int id = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
        object item = NWNX_SQL_ReadFullObjectInActiveRow(1, chest);
        SetLocalInt(item, "PSC_ID", id);
    }

    string goldvar = "PSC_PVT_" + tag + "_" + IntToString(pcid) + "_GOLD";
    int gold = sql_GetVarInt(goldvar);
    if (gold > 0)
    {
        CreateItemOnObject("NW_IT_GOLD001", chest, gold);
        SetLocalInt(chest, goldvar, gold);
    }

    SetLocalInt(chest, "PSC_PVT_PCID", pcid);
}


