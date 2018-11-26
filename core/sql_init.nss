#include "sql_inc"
#include "nwnx_events"

void main()
{
    sql_CreateTables();
    NWNX_Events_SubscribeEvent("NWNX_ON_CLIENT_DISCONNECT_BEFORE", "sql_update_pc");
}
