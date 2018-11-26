#include "hc_inc"
#include "anph_inc"
#include "sql_inc"
#include "chr_inc"
#include "faction_inc"

void main()
{
    object oPC = GetLastUsedBy();
    if (GetMaster(oPC) != OBJECT_INVALID || !GetIsPC(oPC))
        return;

    location lJump;
    fctn_UpdateReputation(oPC);

    int nPCID = chr_GetPCID(oPC);
    int nFaction = fctn_GetFaction(oPC);

    if (sql_GetPCDead(nPCID))
    {
        lJump = fctn_GetFactionFugueLocation(nFaction);
        WriteTimestampedLogEntry ("Creating corpse for " + GetName (oPC) + ", dead on enter.");
        AnphSendCorpseHome(oPC);
    }

    else if (GetName(OBJECT_SELF) == "Wake up in the field!")
    {
        lJump = sql_GetPCLocation(chr_GetPCID(oPC));
    }
    else
    {
        lJump = fctn_GetFactionStartingLocation(nFaction);
    }

    AssignCommand (oPC, ClearAllActions ());
    AssignCommand (oPC, JumpToLocation (lJump));
}

