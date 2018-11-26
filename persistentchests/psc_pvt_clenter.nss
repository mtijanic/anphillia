#include "chr_inc"
#include "sql_inc"

const int PSC_CACHE_ITEMS_IN_ONE_GO = 20;
void PopulateCache(object oCache, string tag, string pcid)
{
    int offset = GetLocalInt(oCache, "PSC_CACHE_OFFSET");

    // Deal with gold first
    if (offset == 0)
    {
        int gold = StringToInt(sql_GetVar("PSC_PVT_" + tag + "_" + pcid + "_GOLD"));
        if (gold > 0)
            CreateItemOnObject("NW_IT_GOLD001", oCache, gold);
    }

    NWNX_SQL_ExecuteQuery("SELECT ID, Object FROM " + SQL_TABLE_PLAYERCHESTS + " WHERE Tag=? AND PCID=" + pcid +
        " LIMIT " + IntToString(PSC_CACHE_ITEMS_IN_ONE_GO) + " OFFSET " + IntToString(offset));

    NWNX_SQL_PreparedString(0, tag);
    NWNX_SQL_ExecutePreparedQuery();

    if (!NWNX_SQL_ReadyToReadNextRow()) // DONE!
    {
        DeleteLocalInt(oCache, "PSC_CACHE_OFFSET");
        SetLocalInt(oCache, "PSC_CACHE_INITIALIZED", 1);
        return;
    }

    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        int id = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
        object item = NWNX_SQL_ReadFullObjectInActiveRow(1, oCache);
        SetLocalInt(item, "PSC_ID", id);
    }

    offset += PSC_CACHE_ITEMS_IN_ONE_GO;
    SetLocalInt(oCache, "PSC_CACHE_OFFSET", offset);

    DelayCommand(0.5, PopulateCache(oCache, tag, pcid));
}

void InitCache(object oPC, string tag, string pcid)
{
    string cachetag = "PSC_CACHE_" + tag + "_" + pcid;
    if (GetObjectByTag(cachetag) != OBJECT_INVALID)
        return; // already initialized.

    object oWP = GetWaypointByTag("PSC_CACHE_WP");
    if (oWP == OBJECT_INVALID)
        oWP = GetWaypointByTag("PSC_CACHE_WP_END");

    object oCache = CreateObject(OBJECT_TYPE_PLACEABLE, "psc_cache", GetLocation(oWP), FALSE, cachetag);
    if (GetTag(oWP) == "PSC_CACHE_WP")
        DestroyObject(oWP);

    DelayCommand(0.1, PopulateCache(oCache, tag, pcid));
}

void main()
{
    object oPC = OBJECT_SELF;
    string pcid = IntToString(chr_GetPCID(oPC));

    NWNX_SQL_ExecuteQuery("SELECT Tag FROM "+SQL_TABLE_PLAYERCHESTS+" WHERE PCID="+pcid);
    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        string tag = NWNX_SQL_ReadDataInActiveRow();
        InitCache(oPC, tag, pcid);
    }
}
