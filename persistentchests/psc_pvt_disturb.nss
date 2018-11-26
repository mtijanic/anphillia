#include "sql_inc"
#include "chr_inc"
#include "dbg_inc"

void main()
{
    object chest = OBJECT_SELF;
    object item = GetInventoryDisturbItem();
    int type = GetInventoryDisturbType();
    object pc = GetLastDisturbed();
    string tag = GetTag(chest);
    int pcid = chr_GetPCID(pc);

    if (GetObjectType(pc) != OBJECT_TYPE_CREATURE)
        return;

    if (pcid != GetLocalInt(chest, "PSC_PVT_PCID"))
    {
        SendMessageToPC(pc, "Someone else is using this chest, please wait until they are finished.");
        if (type == INVENTORY_DISTURB_TYPE_ADDED)
        {
            CopyItem(item, pc, TRUE);
            DestroyObject(item);
        }
        else if (type == INVENTORY_DISTURB_TYPE_REMOVED)
        {
            CopyItem(item, pc, TRUE);
            DestroyObject(item);
        }
        return;
    }

    string goldvar = "PSC_PVT_" + tag + "_" + IntToString(pcid) + "_GOLD";
    int gold = GetGold(chest);
    if (gold != GetLocalInt(chest, goldvar))
    {
        SetLocalInt(chest, goldvar, gold);
        sql_SetVarInt(goldvar, gold);
        return;
    }

    if (type == INVENTORY_DISTURB_TYPE_ADDED)
    {
        NWNX_SQL_PrepareQuery("INSERT INTO " + SQL_TABLE_PLAYERCHESTS + "(Tag,Object,Name,PCID) VALUES(?,?,?,?)");
        NWNX_SQL_PreparedString(0, tag);
        NWNX_SQL_PreparedObjectFull(1, item);
        NWNX_SQL_PreparedString(2, GetName(item));
        NWNX_SQL_PreparedInt(3, pcid);
        NWNX_SQL_ExecutePreparedQuery();

        SetLocalInt(item, "PSC_ID", SQLExecAndFetchInt("SELECT MAX(ID) FROM "+ SQL_TABLE_PLAYERCHESTS));
    }
    else if (type == INVENTORY_DISTURB_TYPE_REMOVED)
    {
        int id = GetLocalInt(item, "PSC_ID");
        NWNX_SQL_ExecuteQuery("DELETE FROM " + SQL_TABLE_PLAYERCHESTS + " WHERE ID="+IntToString(id) + " AND PCID=" + IntToString(pcid));
        if (NWNX_SQL_GetAffectedRows() == 0)
        {
            dbg_ReportBug("Item " + GetName(item) + "(" + GetTag(item) + ") id=" + IntToString(id) + " stack=" + IntToString(GetItemStackSize(item)) + " not found in database.", pc);
        }
        DeleteLocalInt(item, "PSC_ID");
    }
}

