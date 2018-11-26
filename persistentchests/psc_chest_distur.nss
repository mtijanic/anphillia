#include "sql_inc"
#include "chr_inc"
#include "dbg_inc"

void main()
{
    object chest = OBJECT_SELF;
    object item = GetInventoryDisturbItem();
    int type = GetInventoryDisturbType();
    object pc = GetLastDisturbed();

    if (type == INVENTORY_DISTURB_TYPE_ADDED)
    {
        string filter = GetLocalString(chest, "PSC_FILTER_TAGS");
        if (filter != "" && FindSubString(filter, GetTag(item)) < 0)
        {
            string msg = GetLocalString(chest, "PSC_FILTER_MESSAGE");
            if (msg == "")
                msg = "This container accepts only specific items";
            SendMessageToPC(pc, msg);
            CopyItem(item, pc, TRUE);
            DestroyObject(item);
            return;
        }

        if (GetBaseItemType(item) == BASE_ITEM_GOLD)
        {
            SendMessageToPC(pc, "You cannot put gold in these chests");
            int amount = GetItemStackSize(item);
            DestroyObject(item);
            GiveGoldToCreature(pc, amount);
            return;
        }
        NWNX_SQL_PrepareQuery("INSERT INTO " + SQL_TABLE_STORAGECHESTS + "(Tag,Object,Name,AddedByPCID) VALUES(?,?,?,?)");
        NWNX_SQL_PreparedString(0, GetTag(chest));
        NWNX_SQL_PreparedObjectFull(1, item);
        NWNX_SQL_PreparedString(2, GetName(item));
        NWNX_SQL_PreparedInt(3, chr_GetPCID(pc));
        NWNX_SQL_ExecutePreparedQuery();

        SetLocalInt(item, "PSC_ID", SQLExecAndFetchInt("SELECT MAX(ID) FROM "+ SQL_TABLE_STORAGECHESTS));
    }
    else if (type == INVENTORY_DISTURB_TYPE_REMOVED)
    {
        int id = GetLocalInt(item, "PSC_ID");
        NWNX_SQL_ExecuteQuery("DELETE FROM " + SQL_TABLE_STORAGECHESTS + " WHERE ID="+IntToString(id));
        if (NWNX_SQL_GetAffectedRows() == 0)
        {
            dbg_ReportBug("Item " + GetName(item) + "(" + GetTag(item) + ") id=" + IntToString(id) + " stack=" + IntToString(GetItemStackSize(item)) + " not found in database.", pc);
        }
        DeleteLocalInt(item, "PSC_ID");
    }
}

