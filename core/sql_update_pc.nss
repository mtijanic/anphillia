#include "nwnx_events"
#include "sql_inc"
#include "chr_inc"
#include "xp_inc"

void main()
{
    object oPC = OBJECT_SELF;
    string sArea = GetTag(GetArea(oPC));
    int nPCID = chr_GetPCID(oPC);

    xp_SyncToDatabase(oPC);
    if (sArea != "ADream")  // Don't fuck up their location if they're in the dream.
        sql_UpdatePC(nPCID, GetLocation(oPC), GetCurrentHitPoints(oPC), GetXP(oPC));
}
