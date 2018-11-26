#include "faction_inc"

int GetCanonicalAnphRelation(int f1, int f2);

void main()
{
    NWNX_SQL_PrepareQuery("INSERT INTO " + SQL_TABLE_FACTIONS +
        " (ID, Name, StartingLoc, FugueLoc, DreamLoc, ItemKey, ItemHorn, ItemRing, ItemOther) VALUES(?,?,?,?,?,?,?,?,?)");

    NWNX_SQL_PreparedInt(0, ANPH_FACTION_NONE);
    NWNX_SQL_PreparedString(1, "None");
    NWNX_SQL_PreparedString(2, "StartingLocNone");
    NWNX_SQL_PreparedString(3, "FugueLocNone");
    NWNX_SQL_PreparedString(4, "DreamLocNone");
    NWNX_SQL_PreparedString(5, "");
    NWNX_SQL_PreparedString(6, "");
    NWNX_SQL_PreparedString(7, "");
    NWNX_SQL_PreparedString(8, "");
    NWNX_SQL_ExecutePreparedQuery();

    NWNX_SQL_PreparedInt(0, ANPH_FACTION_CLEAVEN);
    NWNX_SQL_PreparedString(1, "Cleaven");
    NWNX_SQL_PreparedString(2, "CleavenStartLocation");
    NWNX_SQL_PreparedString(3, "CleavenFugue");
    NWNX_SQL_PreparedString(4, "CleavenDreamStartLocation");
    NWNX_SQL_PreparedString(5, "cleavengatekey");
    NWNX_SQL_PreparedString(6, "cleavenhorn");
    NWNX_SQL_PreparedString(7, "cleavenmilitiari");
    NWNX_SQL_PreparedString(8, "");
    NWNX_SQL_ExecutePreparedQuery();

    NWNX_SQL_PreparedInt(0, ANPH_FACTION_AXFELL);
    NWNX_SQL_PreparedString(1, "Axfell");
    NWNX_SQL_PreparedString(2, "AxfellStartLocation");
    NWNX_SQL_PreparedString(3, "AxfellFugue");
    NWNX_SQL_PreparedString(4, "DreamStartLocation");
    NWNX_SQL_PreparedString(5, "axfellgatekey");
    NWNX_SQL_PreparedString(6, "axfellbattlehorn");
    NWNX_SQL_PreparedString(7, "axfellwarriorrin");
    NWNX_SQL_PreparedString(8, "");
    NWNX_SQL_ExecutePreparedQuery();

    NWNX_SQL_PreparedInt(0, ANPH_FACTION_RANZINGTON);
    NWNX_SQL_PreparedString(1, "Ranzington");
    NWNX_SQL_PreparedString(2, "RanzingtonStartLocation");
    NWNX_SQL_PreparedString(3, "RanzingtonFugue");
    NWNX_SQL_PreparedString(4, "DreamStartLocation");
    NWNX_SQL_PreparedString(5, "ranzingtongateke");
    NWNX_SQL_PreparedString(6, "ranzingtonhorn");
    NWNX_SQL_PreparedString(7, "ranzingtoncitize");
    NWNX_SQL_PreparedString(8, "");
    NWNX_SQL_ExecutePreparedQuery();

    NWNX_SQL_PreparedInt(0, ANPH_FACTION_DROW);
    NWNX_SQL_PreparedString(1, "Drow");
    NWNX_SQL_PreparedString(2, "DrowStartLocation");
    NWNX_SQL_PreparedString(3, "DrowHell");
    NWNX_SQL_PreparedString(4, "DrowDreamStartLocation");
    NWNX_SQL_PreparedString(5, "drowgatekey");
    NWNX_SQL_PreparedString(6, "drowhorn");
    NWNX_SQL_PreparedString(7, "drowring");
    NWNX_SQL_PreparedString(8, "faeriefire");
    NWNX_SQL_ExecutePreparedQuery();

    NWNX_SQL_PreparedInt(0, ANPH_FACTION_SHILLAR);
    NWNX_SQL_PreparedString(1, "Shilar");
    NWNX_SQL_PreparedString(2, "ShilarStartLocation");
    NWNX_SQL_PreparedString(3, "ShilarFugue");
    NWNX_SQL_PreparedString(4, "DreamStartLocation");
    NWNX_SQL_PreparedString(5, "shilarkey");
    NWNX_SQL_PreparedString(6, "shilarhorn");
    NWNX_SQL_PreparedString(7, "shilarring");
    NWNX_SQL_PreparedString(8, "");
    NWNX_SQL_ExecutePreparedQuery();

    NWNX_SQL_PreparedInt(0, ANPH_FACTION_DAHGMAR);
    NWNX_SQL_PreparedString(1, "Dahgmar");
    NWNX_SQL_PreparedString(2, "DahgmarStartLocation");
    NWNX_SQL_PreparedString(3, "DahgmarFugue");
    NWNX_SQL_PreparedString(4, "DreamStartLocation");
    NWNX_SQL_PreparedString(5, "shilarkey001"); // lol
    NWNX_SQL_PreparedString(6, "dahgmabattleh");
    NWNX_SQL_PreparedString(7, "cleavenmiliti002"); // lol
    NWNX_SQL_PreparedString(8, "");
    NWNX_SQL_ExecutePreparedQuery();

    NWNX_SQL_PreparedInt(0, ANPH_FACTION_BANISHED);
    NWNX_SQL_PreparedString(1, "Banished");
    NWNX_SQL_PreparedString(2, "BanishedStartLocation");
    NWNX_SQL_PreparedString(3, "BanishedFugue");
    NWNX_SQL_PreparedString(4, "BanishedDream");
    NWNX_SQL_PreparedString(5, "");
    NWNX_SQL_PreparedString(6, "");
    NWNX_SQL_PreparedString(7, "");
    NWNX_SQL_PreparedString(8, "");
    NWNX_SQL_ExecutePreparedQuery();

    //
    // Init all factions to neutral for now
    //
    NWNX_SQL_PrepareQuery("INSERT INTO " + SQL_TABLE_FACTIONRELATIONS + " (Faction1,Faction2,Relation) VALUES(?,?,?)");
    int f1, f2;
    for (f1 = 0; f1 < ANPH_FACTION_COUNT; f1++)
    {
        for (f2 = 0; f2 < ANPH_FACTION_COUNT; f2++)
        {
            NWNX_SQL_PreparedInt(0, f1);
            NWNX_SQL_PreparedInt(1, f2);
            NWNX_SQL_PreparedInt(2, GetCanonicalAnphRelation(f1, f2));
            NWNX_SQL_ExecutePreparedQuery();
        }
    }
}

int GetCanonicalAnphRelation(int f1, int f2)
{
    if (f1 == f2)
        return 100;

    // Everyone hates drow
    if (f1 == ANPH_FACTION_DROW || f2 == ANPH_FACTION_DROW)
        return 0;

    // Everyone hates banished too
    if (f1 == ANPH_FACTION_BANISHED || f2 == ANPH_FACTION_BANISHED)
        return 0;

    // everyone is neutral with Ranz and shillar
    if (f1 == ANPH_FACTION_RANZINGTON || f2 == ANPH_FACTION_RANZINGTON)
        return 50;
    if (f1 == ANPH_FACTION_SHILLAR || f2 == ANPH_FACTION_SHILLAR)
        return 50;

    // Cleaven and Axfell hate each other's guts
    if ((f1 == ANPH_FACTION_CLEAVEN && f2 == ANPH_FACTION_AXFELL) ||
        (f2 == ANPH_FACTION_CLEAVEN && f1 == ANPH_FACTION_AXFELL))
        return 0;

    // Axfell and Dahgmar are friendly-neutral
    if ((f1 == ANPH_FACTION_DAHGMAR && f2 == ANPH_FACTION_AXFELL) ||
        (f2 == ANPH_FACTION_DAHGMAR && f1 == ANPH_FACTION_AXFELL))
        return 75;

    // Cleaven and Dahgmar are unfriendly-neutral
    if ((f1 == ANPH_FACTION_DAHGMAR && f2 == ANPH_FACTION_CLEAVEN) ||
        (f2 == ANPH_FACTION_DAHGMAR && f1 == ANPH_FACTION_CLEAVEN))
        return 25;

    return 50;
}

