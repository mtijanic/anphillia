#include "chr_inc"
#include "sql_inc"
#include "xp_inc"

void main()
{
    object oPC = GetFirstPC();
    while (oPC != OBJECT_INVALID)
    {
        if (GetIsDM(oPC))
        {
            oPC = GetNextPC();
            continue;
        }
        // Skip players that just logged in
        if (!GetLocalInt(oPC, "SANITY_CHECK_AREA_ENTER"))
        {
            RemoveFromParty(oPC);
            string sArea = GetTag(GetArea(oPC));
            if (sArea != "ADream" && !(FindSubString(sArea, "Fugue") >= 0))
                sql_UpdatePC(chr_GetPCID(oPC), GetLocation(oPC), GetCurrentHitPoints(oPC), GetXP(oPC));
        }

     //   if (!GetLocalInt(oPC, CHR_AFK_VAR_STATUS)) // AFK players don't get XP
        {
            int nAFKTimer = GetLocalInt(oPC, "XP_AFK_TIMER");
            int bAFK = TRUE;

            location loc = GetLocation(oPC);
            location locOld = GetLocalLocation(oPC, "XP_LAST_LOCATION");
            if (loc != locOld)
            {
                SetLocalLocation(oPC, "XP_LAST_LOCATION", loc);
                bAFK = FALSE;
            }

            string sLastMsg = chr_GetPlayerChatMessage(oPC);
            string sLastStoredMsg = GetLocalString(oPC, "XP_LAST_CHAT_MESSAGE");
            if (sLastMsg != sLastStoredMsg)
            {
                bAFK = FALSE;
                SetLocalString(oPC, "XP_LAST_CHAT_MESSAGE", sLastMsg);
            }

            if (bAFK)
            {
                if (--nAFKTimer <= 0)
                {
                    SendMessageToPC(oPC, "You are AFK and no longer gain XP.");
                    nAFKTimer = 0;
                }
            }
            else
            {
                nAFKTimer = 10;
                SendMessageToPC(oPC, "Thank you for roleplaying");
                xp_GiveXP(oPC, nAFKTimer, XP_TYPE_TIMED);
            }
            SetLocalInt(oPC, "XP_AFK_TIMER", nAFKTimer);
        }
        xp_SyncToDatabase(oPC);
        oPC = GetNextPC();
    }
    WriteTimestampedLogEntry("Character update complete");
}
