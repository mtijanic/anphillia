#include "sql_inc"
#include "util_inc"
#include "dbg_inc"

void main()
{
    object chest = OBJECT_SELF;
    object oPC = GetLastOpenedBy();
    if (GetLocalInt(chest, "PSC_INITIALIZED"))
        return;

    string tag = GetTag(chest);
    // Make sure we didn't accidentally place multiple instances
    int n = 0;
    while (TRUE)
    {
        object other = GetObjectByTag(tag, n++);
        if (other == OBJECT_INVALID)
            break;

        if (other != chest)
        {
            dbg_ReportBug("Duplicate PSC tags found, aborting and destroying", chest);
            SendMessageToPC(oPC, "BUG! This chest is not configured properly, it will not work as persistent storage!");
            DestroyObject(OBJECT_SELF);
            return;
        }
    }

    util_ClearInventory(chest);

    NWNX_SQL_PrepareQuery("SELECT ID, Object FROM " + SQL_TABLE_STORAGECHESTS + " WHERE Tag=?");
    NWNX_SQL_PreparedString(0, tag);
    NWNX_SQL_ExecutePreparedQuery();

    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        int id = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
        object item = NWNX_SQL_ReadFullObjectInActiveRow(1, chest);
        SetLocalInt(item, "PSC_ID", id);
        if (GetBaseItemType(item) == BASE_ITEM_GOLD)
        {
            int amount = GetItemStackSize(item);
            dbg_Warning("Found gold in chest, destroying " + IntToString(amount), chest);
            DestroyObject(item);
        }
    }

    SetLocalInt(chest, "PSC_INITIALIZED", 1);
    SendMessageToPC(oPC, "Do not put more than 50000 gold pieces in the chest");
}


