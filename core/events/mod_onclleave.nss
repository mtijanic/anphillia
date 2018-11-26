///////////////////////////////////////////////////////////////////////////////
// mod_onclleave
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: Placeholder for the module-wide OnClientLeave Event


///////////
// Includes
//
#include "color_inc"
#include "chr_inc"
#include "nwnx_time"
#include "sql_inc"
#include "anph_inc"
///////////////////////
// Function Declaration
//



////////////////
// Function Code
//

void main()
{
    object oPC = GetExitingObject();

    //  NWNX will handle the DB update, but need to update playtime
    int jointime = GetLocalInt(oPC, "CLIENT_ENTER_TIME");
    int playtime = jointime ? (NWNX_Time_GetTimeStamp() - jointime) : 0;
    sql_SetPCOnline(chr_GetPCID(oPC), FALSE, playtime);

    chr_OnPlayerExit(oPC);

    string sExitMsg = color_ConvertString("PLAYER EXIT", COLOR_RED) + ": " + anph_DescribePC(oPC);
    sExitMsg += "  - Played for " + IntToString(playtime) + " seconds";
    WriteTimestampedLogEntry(sExitMsg);
    SendMessageToAllDMs(sExitMsg);

}

