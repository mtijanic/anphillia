#include "sql_inc"
#include "chr_inc"
#include "util_inc"

const int ANPH_FACTION_NONE        = 0;
const int ANPH_FACTION_CLEAVEN     = 1;
const int ANPH_FACTION_AXFELL      = 2;
const int ANPH_FACTION_RANZINGTON  = 3;
const int ANPH_FACTION_DROW        = 4;
const int ANPH_FACTION_SHILLAR     = 5;
const int ANPH_FACTION_DAHGMAR     = 6;
const int ANPH_FACTION_BANISHED    = 7;

const int ANPH_FACTION_COUNT       = 8; // including NONE

int fctn_GetFaction(object creature);
string fctn_GetFactionName(int faction);
object fctn_GetRepresentative(int faction);
void fctn_GiveFactionItems(object creature, int faction);
void fctn_TakeFactionItems(object creature);
void fctn_JoinFaction(object creature, int faction);
void fctn_UpdateReputation(object creature);
int fctn_GetFactionIdFromName(string name);
location fctn_GetFactionStartingLocation(int faction);
location fctn_GetFactionFugueLocation(int faction);
location fctn_GetFactionDreamLocation(int faction);
void fctn_SendMessageToFaction(string msg, int faction);
int fctn_GetIsFactionHostile(int faction1, int faction2);

int fctn_Pay(int faction, int amount, string pool, string pool2="gold");

int fctn_GetFaction(object creature)
{
    int fctn = GetLocalInt(creature, "ANPH_FACTION");
    if (!fctn)
    {
        if (GetIsPC(creature))
        {
            if (GetIsDM(creature))
                return ANPH_FACTION_NONE;

            fctn = sql_GetPCFaction(chr_GetPCID(creature));
            SetLocalInt(creature, "ANPH_FACTION", fctn);
            return fctn;
        }

        int f;
        for (f = 0; f < ANPH_FACTION_COUNT; f++)
            if (GetFactionEqual(creature, fctn_GetRepresentative(f)))
                return f;
    }
    return fctn;
}

string fctn_GetFactionName(int faction)
{
    // Fastpath
    switch (faction)
    {
        case ANPH_FACTION_NONE:       return "None";
        case ANPH_FACTION_CLEAVEN:    return "Cleaven";
        case ANPH_FACTION_AXFELL:     return "Axfell";
        case ANPH_FACTION_RANZINGTON: return "Ranzington";
        case ANPH_FACTION_DROW:       return "Drow";
        case ANPH_FACTION_SHILLAR:    return "Shillar";
        case ANPH_FACTION_DAHGMAR:    return "Dahgmar";
        case ANPH_FACTION_BANISHED:   return "Banished";
    }

    return SQLExecAndFetchString("SELECT Name FROM "+SQL_TABLE_FACTIONS+" WHERE ID=" + IntToString(faction));
}
int fctn_GetFactionIdFromName(string name)
{
    return SQLExecAndFetchInt("SELECT ID FROM "+SQL_TABLE_FACTIONS+" WHERE upper(Name)='" +GetStringUpperCase(name)+"'");
}
object fctn_GetRepresentative(int faction)
{
    object oRep = GetLocalObject(GetModule(), "ANPH_FACTION_REPRESENTATIVE_" + IntToString(faction));
    if (oRep == OBJECT_INVALID)
    {
        string sFaction = fctn_GetFactionName(faction);
        oRep = GetObjectByTag(sFaction + "Faction");
        SetLocalObject(GetModule(), "ANPH_FACTION_REPRESENTATIVE_" + IntToString(faction), oRep);
    }
    return oRep;
}

void fctn_GiveFactionItems(object creature, int faction)
{
    NWNX_SQL_ExecuteQuery("SELECT ItemKey, ItemHorn, ItemRing, ItemOther FROM " + SQL_TABLE_FACTIONS + " WHERE ID=" + IntToString(faction));
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();

        object oKey   = CreateItemOnObject(NWNX_SQL_ReadDataInActiveRow(0), creature, 1);
        object oHorn  = CreateItemOnObject(NWNX_SQL_ReadDataInActiveRow(1), creature, 1);
        object oRing  = CreateItemOnObject(NWNX_SQL_ReadDataInActiveRow(2), creature, 1);
        object oOther = CreateItemOnObject(NWNX_SQL_ReadDataInActiveRow(3), creature, 1);
    }
}

void fctn_TakeFactionItems(object creature)
{
    int faction = fctn_GetFaction(creature);
    NWNX_SQL_ExecuteQuery("SELECT ItemKey, ItemHorn, ItemRing, ItemOther FROM " + SQL_TABLE_FACTIONS + " WHERE ID=" + IntToString(faction));
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        string reslist = NWNX_SQL_ReadDataInActiveRow(0) + "###" +
                         NWNX_SQL_ReadDataInActiveRow(1) + "###" +
                         NWNX_SQL_ReadDataInActiveRow(2) + "###" +
                         NWNX_SQL_ReadDataInActiveRow(3);

        util_DestroyAllItemsByResRef(creature, reslist);
    }
}

void fctn_JoinFaction(object creature, int faction)
{
    fctn_TakeFactionItems(creature);
    fctn_GiveFactionItems(creature, faction);

    // No effect on PCs
    ChangeFaction(creature, fctn_GetRepresentative(faction));

    if (GetIsPC(creature))
        sql_UpdatePC(chr_GetPCID(creature), GetLocation(creature), -1, -1, faction);

    fctn_UpdateReputation(creature);
}


int fctn_GetIsFactionHostile(int faction1, int faction2)
{
    if (faction1 == faction2)
        return FALSE;

    // Fast path exceptions
    if ((faction1 == ANPH_FACTION_CLEAVEN && faction2 == ANPH_FACTION_AXFELL) ||
        (faction2 == ANPH_FACTION_CLEAVEN && faction1 == ANPH_FACTION_AXFELL))
    {
        return TRUE;
    }

    int relation = SQLExecAndFetchInt("SELECT Relation FROM " + SQL_TABLE_FACTIONRELATIONS + " WHERE Faction1=" +
                                        IntToString(faction1) + " AND Faction2=" + IntToString(faction2));

    return relation <= 10;
}

void fctn_UpdateReputation(object creature)
{
    int faction = fctn_GetFaction(creature);

    NWNX_SQL_ExecuteQuery("SELECT Faction2, Relation FROM " + SQL_TABLE_FACTIONRELATIONS + " WHERE Faction1=" + IntToString(faction));
    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();

        int other = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
        int relation = StringToInt(NWNX_SQL_ReadDataInActiveRow(1));

        if (GetLocalInt(creature, "FACTION_SPARRING_MODE"))
            relation = min(50, relation);

        object rep = fctn_GetRepresentative(other);

        int oldRel = GetReputation(rep, creature);
        AdjustReputation(creature, rep, relation - oldRel);
        //util_SendMessageToAllPCs("Updating reputation for " + GetName(creature) + " with " + GetName(rep) + " old:" + IntToString(oldRel) + "; new:" + IntToString(relation-oldRel));
    }

    // Update like/dislike
    if (GetIsPC(creature))
    {
        object player = GetFirstPC();
        while (player != OBJECT_INVALID)
        {
            if (fctn_GetIsFactionHostile(faction, fctn_GetFaction(player)))
            {
                SetPCDislike(creature, player);
                SetPCDislike(player, creature);
            }
            player = GetNextPC();
        }
    }

    SetStandardFactionReputation(STANDARD_FACTION_HOSTILE, 0, creature);
    SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 50, creature);
    SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 50, creature);
    SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 100, creature);
}

location fctn_GetFactionStartingLocation(int faction)
{
    string startloc = SQLExecAndFetchString("SELECT StartingLoc FROM " + SQL_TABLE_FACTIONS + " WHERE ID=" + IntToString(faction));
    return GetLocation(GetWaypointByTag(startloc));
}

location fctn_GetFactionFugueLocation(int faction)
{
    string fugueloc = SQLExecAndFetchString("SELECT FugueLoc FROM " + SQL_TABLE_FACTIONS + " WHERE ID=" + IntToString(faction));
    return GetLocation(GetWaypointByTag(fugueloc));
}
location fctn_GetFactionDreamLocation(int faction)
{
    string dreamloc = SQLExecAndFetchString("SELECT DreamLoc FROM " + SQL_TABLE_FACTIONS + " WHERE ID=" + IntToString(faction));
    return GetLocation(GetWaypointByTag(dreamloc));
}

void fctn_SendMessageToFaction(string msg, int faction)
{
    object pc = GetFirstPC();
    while (pc != OBJECT_INVALID)
    {
        if (fctn_GetFaction(pc) == faction)
            SendMessageToPC(pc, msg);

        pc = GetNextPC();
    }
}

int fctn_Pay(int faction, int amount, string pool1, string pool2="gold")
{
    string sFaction = IntToString(faction);
    int nPool1, nPool2;
    NWNX_SQL_ExecuteQuery("SELECT "+pool1+", " + pool2 +" FROM "+SQL_TABLE_FACTIONS+" WHERE ID="+sFaction);
    if (!NWNX_SQL_ReadyToReadNextRow())
        return FALSE;

    NWNX_SQL_ReadNextRow();
    nPool1 = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
    nPool2 = StringToInt(NWNX_SQL_ReadDataInActiveRow(1));

    if (nPool1 >= amount)
    {
        nPool1 -= amount;
    }
    else if ((nPool1 + nPool2) >= amount  &&  pool1!=pool2)
    {
        nPool2 -= amount - nPool1;
        nPool1 = 0;
    }
    else return FALSE;

    if (pool1 != pool2)
        NWNX_SQL_ExecuteQuery("UPDATE " + SQL_TABLE_FACTIONS + " SET " + pool1 +"="+ IntToString(nPool1) + ", " + pool2 +"=" +IntToString(nPool2) + " WHERE ID="+sFaction);
    else
        NWNX_SQL_ExecuteQuery("UPDATE " + SQL_TABLE_FACTIONS + " SET " + pool1 +"="+ IntToString(nPool1) + " WHERE ID="+sFaction);

    return TRUE;
}

