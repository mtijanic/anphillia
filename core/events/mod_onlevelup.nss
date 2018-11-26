///////////////////////////////////////////////////////////////////////////////
// mod_onlevelup
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: Placeholder for the module-wide OnLevelUp Event

///////////
// Includes
//

///////////////////////
// Function Declaration
//

////////////////
// Function Code
//

#include "sql_inc"
#include "dbg_inc"
#include "chr_inc"
#include "util_inc"
#include "nwnx_creature"
/*
int GetLevelUpClass(object oPC)
{
    int level = util_GetLevel(oPC);
    int nClass1 = GetClassByPosition(1, oPC);
    int nClass2 = GetClassByPosition(2, oPC);
    int nClass3 = GetClassByPosition(3, oPC);
    int nLevel1 = GetLevelByPosition(1, oPC);
    int nLevel2 = GetLevelByPosition(2, oPC);
    int nLevel3 = GetLevelByPosition(3, oPC);

    if (level == 2)
        return nClass2 == CLASS_TYPE_INVALID ? nClass1 : nClass2;

    if (level == 3)
    {
        if (nClass3 != CLASS_TYPE_INVALID)
            return nClass3;
        return (nLevel2 > nLevel1) ? nClass2 : nClass1;
    }

    string sQuery = "SELECT COUNT(*) FROM "+SQL_TABLE_LEVELUPS+" WHERE PCID="+IntToString(chr_GetPCID(oPC))+" AND ClassTaken=";

    if ((nLevel1-1) > SQLExecAndFetchInt(sQuery+IntToString(nClass1)))
        return nClass1;

    if (nClass2 != CLASS_TYPE_INVALID && nLevel2 > SQLExecAndFetchInt(sQuery+IntToString(nClass2)))
        return nClass2;

    if (nClass3 != CLASS_TYPE_INVALID && nLevel3 > SQLExecAndFetchInt(sQuery+IntToString(nClass3)))
        return nClass3;

    dbg_ReportBug("PC leveled in unknown class?", oPC);
    return CLASS_TYPE_INVALID;
}

*/
void main()
{
    object oPC = GetPCLevellingUp();
    int nLevel = util_GetLevel(oPC);

    int nINT = GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE);
    int nMaxBankedSkillPoints = max(1, 1+(nINT - 10)/2);
    if (NWNX_Creature_GetSkillPointsRemaining(oPC) > nMaxBankedSkillPoints)
    {
        int nXP = GetXP(oPC);
        SetXP(oPC, util_GetXPByLevel(nLevel) - 1);
        DelayCommand(0.5, SetXP(oPC, nXP));
        SendMessageToPC(oPC, "You can only leave " + IntToString(nMaxBankedSkillPoints) + " skill points unspent at level up.");
        return;
    }

    NWNX_SQL_ExecuteQuery("INSERT INTO "+SQL_TABLE_LEVELUPS+" (PCID, Level, ClassTaken) VALUES("+
        IntToString(chr_GetPCID(oPC)) +","+ IntToString(nLevel) +","+IntToString(NWNX_Creature_GetClassByLevel(oPC, nLevel)) + ")");


    if (GetCreatureWingType(oPC) != CREATURE_WING_TYPE_NONE)
        SetCreatureWingType(CREATURE_WING_TYPE_NONE, oPC);

    if (GetHasFeat(FEAT_DRAGON_IMMUNE_FIRE, oPC))
    {
        NWNX_Creature_RemoveFeat(oPC, FEAT_DRAGON_IMMUNE_FIRE);
        NWNX_Creature_AddFeatByLevel(oPC, FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_10, nLevel);
    }
    NWNX_Creature_RemoveFeat(oPC, FEAT_PALADIN_SUMMON_MOUNT);

}
