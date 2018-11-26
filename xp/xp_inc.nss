///////////////////////////////////////////////////////////////////////////////
// xp_inc
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: Include File for XP related stuff


///////////
// Includes
//
//#include "s_mss_inc"
#include "xp_cfg"
#include "sql_inc"
#include "chr_inc"
#include "faction_inc"
#include "nwnx_time"

const int XP_TYPE_NONE        = 0;
const int XP_TYPE_COMBAT      = 1;
const int XP_TYPE_TIMED       = 2;
const int XP_TYPE_EXPLORATION = 3;
///////////////////////
// Function Declaration
//

// Gives oPC nPercentage % of the needed XP to the next level
void xp_GiveXPPercentage(object oPC, float fPercentage);

// This function gives XP to players for killing a monster
void xp_GiveXPForKill(object oMonster, object oKiller);

struct XP_Multiplers
{
   float fPC, fFaction, fAll, fType, fThrottle;
};

object xp_GetXPManager()
{
    object oXP = GetLocalObject(GetModule(), "XP_MANAGER");
    if (oXP == OBJECT_INVALID)
    {
        oXP = GetObjectByTag("XP_MANAGER");
        SetLocalObject(GetModule(), "XP_MANAGER", oXP);
    }
    return oXP;
}

void xp_ReloadTables()
{
    object oXP = xp_GetXPManager();

    NWNX_SQL_ExecuteQuery("SELECT * FROM " + SQL_TABLE_XPDATA);
    /*
        Level                  int          NOT NULL PRIMARY KEY,
        MultiplierAll          float        NOT NULL DEFAULT 1.0,
        MultiplierCombat       float        NOT NULL DEFAULT 1.0,
        MultiplierExploration  float        NOT NULL DEFAULT 1.0,
        MultiplierTimed        float        NOT NULL DEFAULT 1.0,
        Threshold1             int          NOT NULL DEFAULT 1000,
        Throttle1              float        NOT NULL DEFAULT 0.8,
        Threshold2             int          NOT NULL DEFAULT 2000,
        Throttle2              float        NOT NULL DEFAULT 0.5,
        Threshold3             int          NOT NULL DEFAULT 3000,
        Throttle3              float        NOT NULL DEFAULT 0.2,
        PenaltyDeath           float        NOT NULL DEFAULT 0.05,
        PenaltyOrb             float        NOT NULL DEFAULT 0.1,
        PenaltyScalp           float        NOT NULL DEFAULT 0.05
        MaxPerRest             int          NOT NULL DEFAULT 750
    */
    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();

        string sLevel = NWNX_SQL_ReadDataInActiveRow(0);
        SetLocalFloat(oXP, "XP_" + sLevel + "_MultiplierAll", StringToFloat(NWNX_SQL_ReadDataInActiveRow(1)));
        SetLocalFloat(oXP, "XP_" + sLevel + "_MultiplierCombat", StringToFloat(NWNX_SQL_ReadDataInActiveRow(2)));
        SetLocalFloat(oXP, "XP_" + sLevel + "_MultiplierExploration", StringToFloat(NWNX_SQL_ReadDataInActiveRow(3)));
        SetLocalFloat(oXP, "XP_" + sLevel + "_MultiplierTimed", StringToFloat(NWNX_SQL_ReadDataInActiveRow(4)));

        SetLocalInt(oXP, "XP_" + sLevel + "_Threshold1", StringToInt(NWNX_SQL_ReadDataInActiveRow(5)));
        SetLocalFloat(oXP, "XP_" + sLevel + "_Throttle1", StringToFloat(NWNX_SQL_ReadDataInActiveRow(6)));
        SetLocalInt(oXP, "XP_" + sLevel + "_Threshold2", StringToInt(NWNX_SQL_ReadDataInActiveRow(7)));
        SetLocalFloat(oXP, "XP_" + sLevel + "_Throttle2", StringToFloat(NWNX_SQL_ReadDataInActiveRow(8)));
        SetLocalInt(oXP, "XP_" + sLevel + "_Threshold3", StringToInt(NWNX_SQL_ReadDataInActiveRow(9)));
        SetLocalFloat(oXP, "XP_" + sLevel + "_Throttle3", StringToFloat(NWNX_SQL_ReadDataInActiveRow(10)));

        SetLocalFloat(oXP, "XP_" + sLevel + "_PenaltyDeath", StringToFloat(NWNX_SQL_ReadDataInActiveRow(11)));
        SetLocalFloat(oXP, "XP_" + sLevel + "_PenaltyOrb",   StringToFloat(NWNX_SQL_ReadDataInActiveRow(12)));
        SetLocalFloat(oXP, "XP_" + sLevel + "_PenaltyScalp", StringToFloat(NWNX_SQL_ReadDataInActiveRow(13)));

        SetLocalInt(oXP, "XP_" + sLevel + "_MaxPerRest", StringToInt(NWNX_SQL_ReadDataInActiveRow(14)));
    }

    NWNX_SQL_ExecuteQuery("SELECT ID, XPMultiplier FROM " + SQL_TABLE_FACTIONS);
    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();

        string sFactionID = NWNX_SQL_ReadDataInActiveRow(0);
        SetLocalFloat(oXP, "XP_FACTION_" + sFactionID + "_Multiplier", StringToFloat(NWNX_SQL_ReadDataInActiveRow(1)));
    }

    WriteTimestampedLogEntry("XP system tables written to XP_MANAGER object");
}

void xp_LoadFromDatabase(object oPC)
{
     NWNX_SQL_ExecuteQuery("SELECT XPMultiplier, XPBanked, XPUnflushed, XPLastFlush, XPLost FROM "+SQL_TABLE_CHARDATA+" WHERE PCID="+IntToString(chr_GetPCID(oPC)));
     if (NWNX_SQL_ReadyToReadNextRow())
     {
         NWNX_SQL_ReadNextRow();
         SetLocalFloat(oPC, "XP_Multipler", StringToFloat(NWNX_SQL_ReadDataInActiveRow(0)));
         SetLocalInt(oPC, "XP_Banked", StringToInt(NWNX_SQL_ReadDataInActiveRow(1)));
         SetLocalInt(oPC, "XP_Unflushed", StringToInt(NWNX_SQL_ReadDataInActiveRow(2)));
         SetLocalInt(oPC, "XP_LastFlush", StringToInt(NWNX_SQL_ReadDataInActiveRow(3)));
         SetLocalInt(oPC, "XP_Lost", StringToInt(NWNX_SQL_ReadDataInActiveRow(4)));
     }
}

struct XP_Multiplers xp_GetAllMultipliers(object oPC, int nType = XP_TYPE_NONE)
{
    struct XP_Multiplers xpm;

    object oXP = xp_GetXPManager();
    string sLevel = IntToString(util_GetLevelByXP(GetXP(oPC)));
    int nPCID = chr_GetPCID(oPC);

    int nBanked, tLastFlush, nUnflushed, nLost;
    xpm.fPC = GetLocalFloat(oPC, "XP_Multipler");
    tLastFlush = GetLocalInt(oPC, "XP_LastFlush");
    nUnflushed = GetLocalInt(oPC, "XP_Unflushed");
    if (tLastFlush == 0 && nUnflushed == 0 && xpm.fPC == 0.0)
    {
        xp_LoadFromDatabase(oPC);
        xpm.fPC = GetLocalFloat(oPC, "XP_Multipler");
        tLastFlush = GetLocalInt(oPC, "XP_LastFlush");
        nUnflushed = GetLocalInt(oPC, "XP_Unflushed");
    }

    xpm.fFaction = GetLocalFloat(oXP, "XP_FACTION_"+IntToString(fctn_GetFaction(oPC))+"_Multiplier");
    xpm.fAll = GetLocalFloat(oXP, "XP_"+sLevel+"_MultiplierAll");
    string sType = "";
    switch (nType)
    {
        case XP_TYPE_COMBAT:      sType = "Combat";      break;
        case XP_TYPE_EXPLORATION: sType = "Exploration"; break;
        case XP_TYPE_TIMED:       sType = "Timed";       break;
    }
    xpm.fType = sType=="" ? 1.0 : GetLocalFloat(oXP, "XP_"+sLevel+"_Multiplier"+sType);

    xpm.fThrottle = 1.0;
    int now = NWNX_Time_GetTimeStamp();
    if ((now - tLastFlush) > (24*60*60)) // Flush every 24 hours
    {
        SetLocalInt(oPC, "XP_LastFlush", now);
        SetLocalInt(oPC, "XP_Unflushed", 0);
        NWNX_SQL_ExecuteQuery("UPDATE "+SQL_TABLE_CHARDATA+" SET XPLastFlush="+IntToString(now)+" WHERE PCID="+IntToString(nPCID));
        nUnflushed = 0;
    }
    if (nUnflushed > GetLocalInt(oXP, "XP_"+sLevel+"_Threshold3"))
        xpm.fThrottle = GetLocalFloat(oXP, "XP_"+sLevel+"_Throttle3");
    else if (nUnflushed > GetLocalInt(oXP, "XP_"+sLevel+"_Threshold2"))
        xpm.fThrottle = GetLocalFloat(oXP, "XP_"+sLevel+"_Throttle2");
    else if (nUnflushed > GetLocalInt(oXP, "XP_"+sLevel+"_Threshold1"))
        xpm.fThrottle = GetLocalFloat(oXP, "XP_"+sLevel+"_Throttle1");

    return xpm;
}

float xp_GetMultiplier(object oPC, int nType = XP_TYPE_NONE)
{
    struct XP_Multiplers xpm = xp_GetAllMultipliers(oPC, nType);
    return xpm.fPC * xpm.fFaction * xpm.fAll * xpm.fType * xpm.fThrottle;
}

void xp_SyncToDatabase(object oPC)
{
    int tLastFlush = GetLocalInt(oPC, "XP_LastFlush");
    int nUnflushed = GetLocalInt(oPC, "XP_Unflushed");
    int nBanked    = GetLocalInt(oPC, "XP_Banked");
    int nLost      = GetLocalInt(oPC, "XP_Lost");

    if (tLastFlush || nUnflushed || nBanked)
    {
        NWNX_SQL_ExecuteQuery("UPDATE "+SQL_TABLE_CHARDATA+" SET XPLastFlush="+IntToString(tLastFlush)+
         ", XPBanked="+IntToString(nBanked) +
         ", XPUnflushed="+IntToString(nUnflushed) +
         ", XPLost="+IntToString(nLost) +
         " WHERE PCID="+IntToString(chr_GetPCID(oPC)));
    }
}

void xp_GiveXP(object oPC, int nXP, int nType = XP_TYPE_NONE)
{
    struct XP_Multiplers xpm = xp_GetAllMultipliers(oPC, nType);
    int nUnthrottled = FloatToInt(xpm.fPC * xpm.fFaction * xpm.fAll * xpm.fType * nXP);
    nXP = FloatToInt(xpm.fThrottle * nUnthrottled);

    int nLost = nUnthrottled - nXP;
    if (nLost > 0)
        SetLocalInt(oPC, "XP_Lost", GetLocalInt(oPC, "XP_Lost") + nLost);

    SetLocalInt(oPC, "XP_Unflushed", GetLocalInt(oPC, "XP_Unflushed") + nXP);

    if (CI_XP_GIVE_XP_ON_REST)
    {
        int nBanked = GetLocalInt(oPC, "XP_Banked");
        int nMax = GetLocalInt(xp_GetXPManager(), "XP_" + IntToString(util_GetLevelByXP(GetXP(oPC))) + "_MaxPerRest");

        if (nMax == 0)
            return;

        int nNewBanked = nBanked + nXP;
        if (nNewBanked > nMax)
            nNewBanked = nMax;

        float fRatio = IntToFloat(nNewBanked) / nMax;
        if (fRatio > 0.99)
            SendMessageToPC(oPC, "You are exhausted and can't learn anything further.");
        else if (fRatio > 0.9)
            SendMessageToPC(oPC, "You are tired and not learning at your full potential.");
        else if (fRatio > 0.8)
            SendMessageToPC(oPC, "You are beginning to feel tired.");

        if (nNewBanked > nBanked)
        {
            int tLastMsg = GetLocalInt(oPC, "XP_LAST_MSG_TIME_"+IntToString(nType));
            int now = NWNX_Time_GetTimeStamp();
            if ((now - tLastMsg) > 30)
            {
                SetLocalInt(oPC, "XP_LAST_MSG_TIME_"+IntToString(nType), now);
                string sType = "";
                if (nType == XP_TYPE_COMBAT) sType = " (combat)";
                else if (nType == XP_TYPE_TIMED) sType = " (roleplay)";
                else if (nType == XP_TYPE_EXPLORATION) sType = " (exploration)";
                SendMessageToPC(oPC, "You have gained experience" +sType+". It will be applied next time you rest.");
            }
            SetLocalInt(oPC, "XP_Banked", nNewBanked);
            NWNX_SQL_ExecuteQuery("UPDATE "+SQL_TABLE_CHARDATA+" SET XPBanked="+IntToString(nBanked)+" WHERE PCID="+IntToString(chr_GetPCID(oPC)));
        }
    }
    else
    {
        GiveXPToCreature(oPC, nXP);
    }
}

void xp_ApplyBankedXP(object oPC)
{
    int nXP = GetLocalInt(oPC, "XP_Banked");
    if (nXP == 0)
    {
        xp_LoadFromDatabase(oPC);
        nXP = GetLocalInt(oPC, "XP_Banked");
    }
    GiveXPToCreature(oPC, nXP);
    SetLocalInt(oPC, "XP_Banked", 0);
    xp_SyncToDatabase(oPC);
}

void xp_GiveXPPercentage(object oPC, float fPercentage)
{
    int nLevel = util_GetLevelByXP(GetXP(oPC));
    float fXPToNextLevel = IntToFloat(nLevel * 1000);

    int nXP = FloatToInt(fXPToNextLevel * (fPercentage / 100));
    xp_GiveXP(oPC, nXP, XP_TYPE_NONE);
}


void xp_GiveXPForKill(object oMonster, object oKiller)
{
   int iHD;
   string sDebug;

   // First, we'll get all variables we need, starting with the Monster
   // difficulty.
   int iMonsterDifficulty = FloatToInt (GetChallengeRating(oMonster));
   int iOverride = GetLocalInt(oMonster, CS_XP_XPOVERRIDE);

   // Return if there's no XP to gain from this creature
   if (iOverride == -1)
      return;

   object oCenter;
   if (CI_XP_CIRCLERELATIVE == 1)
   {
      oCenter = oMonster;
   }
   else
   {
      oCenter = oKiller;
   }

   // Now, we'll evaluate which players in the radius are to get XP from this
   // kill.
   // Reset the current number of players to receive XP
   DeleteLocalInt(oMonster, CS_XP_PLAYERNUMBER);
   int iCount = 1;
   object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oCenter, iCount);

   while (GetIsObjectValid(oPC))
   {
      // If it's a DM, ignore him
      if (GetIsDM(oPC))
         continue;

      // If this player is too far away, get the next one...
      if (GetDistanceBetween (oPC, oCenter) > CF_XP_CIRCLERADIUS)
      {
         break;
         //oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oCenter, iCount);
         //continue;
      }

      // Set the current number of players to receive XP
      SetLocalInt(oMonster, CS_XP_PLAYERNUMBER, iCount);

      // Set the current player object and his Level
      SetLocalObject(oMonster, CS_XP_PLAYERPREFIX + IntToString(iCount), oPC);

      iHD = GetHitDice(oPC);
      SetLocalInt(oMonster, CS_XP_PLAYERLEVEL + IntToString(iCount), GetHitDice(oPC));

      if (iHD > GetLocalInt(oMonster, CS_XP_HIGHESTLEVEL))
         SetLocalInt(oMonster, CS_XP_HIGHESTLEVEL, iHD);

      iCount += 1;
      oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oCenter, iCount);
   }
   // Now that we know all players and the highest level in the group, we can
   // calculate the base XP. First, we calculate the average level of the group.
   int iPlayerNumber = GetLocalInt(oMonster, CS_XP_PLAYERNUMBER);
   if (iPlayerNumber == 0)
      return;
   int iGroupLevel = 0;
   int iLevelsToAdd;
   int iHighestLevel = GetLocalInt(oMonster, CS_XP_HIGHESTLEVEL);
   for (iCount = 1; iCount < iPlayerNumber + 1; iCount++)
   {
      iLevelsToAdd = GetLocalInt(oMonster, CS_XP_PLAYERLEVEL + IntToString(iCount));
      if (iLevelsToAdd < iHighestLevel - CI_XP_MINLEVEL)
      {
         iLevelsToAdd = iHighestLevel - CI_XP_MINLEVEL;
      }
      iGroupLevel += iLevelsToAdd;
   }
   iGroupLevel /= iPlayerNumber;

   // Given the Group Level and the Monster Difficulty, we can determine BaseXP
   int iLevelDifference = iGroupLevel - iMonsterDifficulty;
   if (
       (iLevelDifference < 0 - CI_XP_MAXDIFFERENCE ||
        iLevelDifference > 0 + CI_XP_MAXDIFFERENCE) &&
       (CI_XP_MAXDIFFERENCE != -1)
      )
      return;

   int iXPChangeByLevel = ( iLevelDifference * CI_XP_XPCHANGE );
   int iBaseXP;

   if (iOverride != 0)
   {
      iBaseXP = iOverride;
   }
   else
   {
      int nGroupSizeDeviation = CI_XP_GROUP_SIZE_STANDARD - iPlayerNumber;
      if (nGroupSizeDeviation > CI_XP_GROUP_SIZE_MAXDEVIATON)
         nGroupSizeDeviation = CI_XP_GROUP_SIZE_MAXDEVIATON;
      else if (nGroupSizeDeviation < 0 - CI_XP_GROUP_SIZE_MAXDEVIATON)
         nGroupSizeDeviation = 0 - CI_XP_GROUP_SIZE_MAXDEVIATON;

      if (CF_XP_BASEXP_SQUARE_CR)
         iBaseXP = CI_XP_BASEXP + FloatToInt(CF_XP_BASEXP_CR * iMonsterDifficulty * iMonsterDifficulty) - iXPChangeByLevel + (nGroupSizeDeviation * CI_XP_GROUP_SIZE_XPCHANGE);
      else
         iBaseXP = CI_XP_BASEXP + FloatToInt(CF_XP_BASEXP_CR * iMonsterDifficulty) - iXPChangeByLevel + (nGroupSizeDeviation * CI_XP_GROUP_SIZE_XPCHANGE);
   }

   // Now that we know the BaseXP value of the kill, it's time to give XP to
   // all players involved in the kill
   int iXPModifier;
   int iPCLevel;
   int iPlayMode;

/* DEBUG
   sDebug = "Killed [" + GetName(oMonster) + "], Difficulty [" + IntToString(iMonsterDifficulty) + "]\n";
   sDebug += "Player Group Size: " + IntToString(iPlayerNumber) + ", Group Level: " + IntToString(iGroupLevel) + "\n";
   sDebug += "Base XP: 30 - (" + IntToString(iXPChangeByLevel) + ") + (" + IntToString((4 - iPlayerNumber) * 2) + ") = " + IntToString(iBaseXP) + "\n";
*/
   int iSavedBaseXP = iBaseXP;
   for (iCount = 1; iCount < iPlayerNumber + 1; iCount++)
   {
      iBaseXP = iSavedBaseXP;
      oPC = GetLocalObject(oMonster, CS_XP_PLAYERPREFIX + IntToString(iCount));
      iPCLevel = util_GetLevelByXP(GetXP(oPC));

      // For every level the player is above/below the average group level,
      // calculate the changes in XP
      iLevelDifference = iGroupLevel - iPCLevel;
      if (iLevelDifference < 0 - CI_XP_PERSONALMAXDIFFERENCE)
      {
         iLevelDifference = 0 - CI_XP_PERSONALMAXDIFFERENCE;
      }
      else if (iLevelDifference > 0 + CI_XP_PERSONALMAXDIFFERENCE)
      {
         iLevelDifference = 0 + CI_XP_PERSONALMAXDIFFERENCE;
      }
      iXPModifier = iLevelDifference * CI_XP_PERSONALXPCHANGE;

      // DEBUG
      // SendMessageToPC(oPC, sDebug + "---\n" + "Your Level: " + IntToString(iPCLevel) + "\n" + "Your Base XP: BaseXP (" + IntToString(iBaseXP) + ") + (" + IntToString(iXPModifier) + ")\n");
      iBaseXP += iXPModifier;

      // Now, take Play Mode into Account
      /*
      iPlayMode = s_chr_GetMode(oPC);
      switch (iPlayMode)
      {
         case CI_CHR_MODE_DEATHLESS: iBaseXP = FloatToInt(iBaseXP * 0.7f);
            //SendMessageToPC(oPC, "Your Mode: Deathless Warrior (easy), Mod. XP: " + IntToString(iBaseXP));
            break;
         case CI_CHR_MODE_AVENGER:
            //SendMessageToPC(oPC, "Your Mode: God's Avenger (normal), Mod. XP: " + IntToString(iBaseXP));
            break;
         case CI_CHR_MODE_CHOSEN: iBaseXP = FloatToInt(iBaseXP * 1.5f);
            //SendMessageToPC(oPC, "Your Mode: God's Chosen (hard), Mod. XP: " + IntToString(iBaseXP));
            break;
      }
      */

      // Now add a little randomizer for variation if Base XP is still > 0
      if (iBaseXP > 0)
         iBaseXP += Random(4) - 1; // can be -1 to +2

      int iMinimumXP = CI_XP_MINIMUM_XP + FloatToInt(CF_XP_MINIMUM_XP_CR * iMonsterDifficulty);
      if (iBaseXP < iMinimumXP)
         iBaseXP = iMinimumXP;

      if (iBaseXP > 0)
      {
          xp_GiveXP(oPC, iBaseXP, XP_TYPE_COMBAT);
      }

      if (CI_XP_GIVEGOLD)
      {
         int iGold = (iMonsterDifficulty * CI_XP_MULTIPLIER) + Random(iMonsterDifficulty);
         GiveGoldToCreature(oPC, iGold);
      }
   }
}
