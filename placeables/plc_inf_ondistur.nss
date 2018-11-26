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
        CopyItem(item, pc, TRUE);
        DestroyObject(item);
        SendMessageToPC(pc, "Please do not put anything in these chests");
    }
    else if (type == INVENTORY_DISTURB_TYPE_REMOVED)
    {
        CopyItem(item, chest, TRUE);
    }
}

