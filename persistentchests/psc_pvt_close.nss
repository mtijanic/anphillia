#include "sql_inc"
#include "chr_inc"
#include "dbg_inc"

void main()
{
    object chest = OBJECT_SELF;
    object pc = GetLastClosedBy();

    util_ClearInventory(chest);
    DeleteLocalInt(chest, "PSC_PVT_PCID");
}
