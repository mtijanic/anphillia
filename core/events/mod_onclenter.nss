///////////////////////////////////////////////////////////////////////////////
// mod_onclenter
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: Placeholder for the module-wide OnClientEnter Event

///////////////////////////////////////////////////////////////////////////////
// Function Code
//
#include "nwnx_object"
#include "nwnx_time"
#include "sql_inc"
#include "chr_inc"
#include "dbg_inc"
#include "anph_cfg"
#include "anph_inc"
#include "cheat_inc"
#include "dev_inc"
#include "color_inc"

void GiveItem(object oPC, string sTag, string sResRef="", int nClass=-1);
///////////////////////////////////////////////////////////////////////////////
// Main entry point
//
void main()
{
    object oPC = GetEnteringObject();
    int bDM = GetIsDM(oPC);
    int bTeam = dev_IsTeamMember(oPC);

    if (!bDM && !bTeam && !cheat_Validate(oPC))
    {
        string sEnterMsg = "PLAYER DENIED: " + anph_DescribePC(oPC);
        WriteTimestampedLogEntry(sEnterMsg);
        SendMessageToAllDMs(sEnterMsg);

        AssignCommand(oPC, ClearAllActions());
        AssignCommand(oPC, JumpToObject(GetWaypointByTag("CHEATER_AREA")));
        return;
    }

    ExecuteScript("cnr_module_oce", OBJECT_SELF);

    int nPCID = chr_GetPCID(oPC);

    if (nPCID == 0)
    {
        nPCID = chr_InitializePC(oPC);
        if (nPCID && !bDM)
        {
            util_ClearInventory(oPC);
            NWNX_Creature_SetGold(oPC, 200);
            NWNX_Creature_AddFeat(oPC, FEAT_PLAYER_TOOL_10); // Unstuck tool
            NWNX_Creature_AddFeat(oPC, FEAT_PLAYER_TOOL_09); // Rename tool

            if (bTeam)
            {
                // No constants for DM tools
                NWNX_Creature_AddFeat(oPC, FEAT_PLAYER_TOOL_01 - 10);
                NWNX_Creature_AddFeat(oPC, FEAT_PLAYER_TOOL_02 - 10);
                NWNX_Creature_AddFeat(oPC, FEAT_PLAYER_TOOL_03 - 10);
                NWNX_Creature_AddFeat(oPC, FEAT_PLAYER_TOOL_04 - 10);
                NWNX_Creature_AddFeat(oPC, FEAT_PLAYER_TOOL_05 - 10);
                NWNX_Creature_AddFeat(oPC, FEAT_PLAYER_TOOL_06 - 10);
                NWNX_Creature_AddFeat(oPC, FEAT_PLAYER_TOOL_07 - 10);
                NWNX_Creature_AddFeat(oPC, FEAT_PLAYER_TOOL_08 - 10);
                NWNX_Creature_AddFeat(oPC, FEAT_PLAYER_TOOL_09 - 10);
                NWNX_Creature_AddFeat(oPC, FEAT_PLAYER_TOOL_10 - 10);
            }
        }
    }
    else if (!bDM)
    {
        int nHP = sql_GetPCHP(nPCID);
        if (nHP)
            NWNX_Object_SetCurrentHitPoints(oPC, nHP);

        // For system migration
        ExecuteScript("_migrate_pc", oPC);
    }

    sql_SetPCOnline(nPCID, TRUE);

    // Reset AFK Status to FALSE
    chr_SetAFKStatus(oPC, FALSE);

    // Not a server reset
    if (!bDM && GetLocalInt(OBJECT_SELF, "LOGGED_PCID_" + IntToString(nPCID)))
    {
        location lStoredLoc = sql_GetPCLocation(nPCID);
        if (!GetIsObjectValid(GetAreaFromLocation(lStoredLoc)))
        {
            dbg_Warning("No valid location found for this PC, jumping back to dream", oPC);
            AssignCommand(oPC, ClearAllActions());
            AssignCommand(oPC, JumpToLocation(GetStartingLocation()));
        }
        else if (GetArea(oPC) != GetAreaFromLocation(lStoredLoc))
        {
           // dbg_Warning("TURD reporting different location than stored. Trusting database", oPC);
            AssignCommand(oPC, ClearAllActions());
            AssignCommand(oPC, JumpToLocation(lStoredLoc));
            DelayCommand(0.5f, AssignCommand(oPC, ClearAllActions()));
            DelayCommand(0.8f, AssignCommand(oPC, JumpToLocation(lStoredLoc)));
        }
    }
    else if (!bDM)
    {
        // Initialize PSC_PVT caches
        //ExecuteScript("psc_pvt_clenter", oPC);
    }

    SetLocalInt(OBJECT_SELF, "LOGGED_PCID_" + IntToString(nPCID), 1);
    SetLocalInt(oPC, "CLIENT_ENTER_TIME", NWNX_Time_GetTimeStamp());

    DelayCommand(10.0, fctn_UpdateReputation(oPC));

    string sEnterMsg = color_ConvertString("PLAYER ENTER", COLOR_GREEN) + ": " + anph_DescribePC(oPC);
    WriteTimestampedLogEntry(sEnterMsg);
    SendMessageToAllDMs(sEnterMsg);

    // Remove unused items
    DestroyObject(GetItemPossessedBy(oPC, "WandofAFK"));          // Wand of AFK
    DestroyObject(GetItemPossessedBy(oPC, "AmuletOfLife"));       // Amulet of Life "I'm alive" token
    DestroyObject(GetItemPossessedBy(oPC, "NW_WSWMLS013"));       // Tensor's sword
    // Elemental trial stones
    DestroyObject(GetItemPossessedBy(oPC, "stoneofearth"));
    DestroyObject(GetItemPossessedBy(oPC, "stoneofwater"));
    DestroyObject(GetItemPossessedBy(oPC, "stoneoffire"));
    DestroyObject(GetItemPossessedBy(oPC, "stoneofair"));


    GiveItem(oPC, "pc_actionwand");

    // Give class specific items if they were misplaced somehow
    GiveItem(oPC, "DruidEar",        "druidear",         CLASS_TYPE_DRUID);
    GiveItem(oPC, "TrackerTool",     "trackertool",      CLASS_TYPE_RANGER);
    GiveItem(oPC, "hc_palbadgecour", "paladinsbadgeofc", CLASS_TYPE_PALADIN);
    GiveItem(oPC, "hc_paladinsymb",  "paladinsholysymb", CLASS_TYPE_PALADIN);

    // DM Items
    if (bDM)
    {
        GiveItem(oPC,"DMsHelper");
        GiveItem(oPC,"WandOfFX");
        GiveItem(oPC,"XPWand");
        GiveItem(oPC,"BlessWand");
        GiveItem(oPC,"WandOfSubscribe");
    }


    string sBeta = "Welcome to Anphillia. Visit us at " + COLOR_CODE_TURQUOISE + "anphillia.pw" + COLOR_CODE_END + "\n" +
                   "Type " + COLOR_CODE_GREEN + "/help" + COLOR_CODE_END + " for a list of available commands.\n";
    SendMessageToPC(oPC, sBeta);
}

void GiveItem(object oPC, string sTag, string sResRef="", int nClass=-1)
{
    if (nClass != -1 && GetLevelByClass(nClass, oPC) == 0)
        return;

    if (GetItemPossessedBy(oPC, sTag) == OBJECT_INVALID)
        CreateItemOnObject(sResRef==""?sTag:sResRef, oPC);
}
