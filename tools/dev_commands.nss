#include "anph_cfg"
#include "dbg_inc"
#include "dev_inc"
#include "faction_inc"
#include "nwnx_player"
#include "nwnx_creature"
#include "nwnx_webhook"
#include "nwnx_admin"
#include "nwnx_time"
#include "pat_inc"

const string WEBHOOK_DM = "/api/webhooks/451344020606812161/th1si5n0tar43lAPiK3y-n3v3rPuTaPiKEY5inS0urceRep0_Y_amIap0tat0lalalaF/slack";

const string BADPARSE = "[BADPARSE]";
string ParseCommand(string sMessage, string sCommand)
{
    int sCommandLen = GetStringLength(sCommand);
    if (GetStringLeft(sMessage, sCommandLen) == sCommand)
        return GetSubString(sMessage, sCommandLen+1, GetStringLength(sMessage)-sCommandLen-1);
    else
        return BADPARSE;
}

void main()
{
    object oDM = GetPCChatSpeaker();
    if (!dev_IsTeamMember(oDM))
    {
        dbg_Warning("dev_commands called on non-team PC", oDM);
        return;
    }

    string sParams;
    string sMessage = GetPCChatMessage();

    if ((sParams = ParseCommand(sMessage, "#modname")) != BADPARSE)
    {
        if (sParams == "" || sParams == " ")
            sParams = "Anphillia " + ANPH_VERSION + " (" + NWNX_Time_GetSystemDate() +")";
        NWNX_Administration_SetModuleName(sParams);
    }
    else if ((sParams = ParseCommand(sMessage, "#password")) != BADPARSE)
    {
        if (sParams == "" || sParams == " ")
            NWNX_Administration_ClearPlayerPassword();
        else
            NWNX_Administration_SetPlayerPassword(sParams);
    }
    else if ((sParams = ParseCommand(sMessage, "#xp")) != BADPARSE)
    {
        if (sParams == "reload")
            ExecuteScript("xp_reload", OBJECT_SELF);

        string sNotification = COLOR_CODE_BLUE_DARK + "XP tables reloaded from database" + COLOR_CODE_END;
        SendMessageToPC(oDM, sNotification);
        SendMessageToAllDMs(sNotification);
    }
    else if ((sParams = ParseCommand(sMessage, "#faction")) != BADPARSE)
    {
        if (sParams == "reset")
        {
            object oPC = GetFirstPC();
            while (oPC != OBJECT_INVALID)
            {
                fctn_UpdateReputation(oPC);
                oPC = GetNextPC();
            }
        }
        string sNotification = COLOR_CODE_BLUE_DARK + "Faction relations for PCs reset." + COLOR_CODE_END;
        SendMessageToPC(oDM, sNotification);
        SendMessageToAllDMs(sNotification);
    }
    else if ((sParams = ParseCommand(sMessage, "#gainxp")) != BADPARSE)
    {
        GiveXPToCreature(oDM, StringToInt(sParams));
    }
    else if ((sParams = ParseCommand(sMessage, "#area")) != BADPARSE)
    {
        if (sParams == "neutral")
        {
            SetLocalInt(GetArea(oDM), "AREA_NEUTRAL_ZONE", 1);
            string sNotification = COLOR_CODE_BLUE_DARK + "Area " + GetName(GetArea(oDM)) + " is now a neutral zone." + COLOR_CODE_END;
            SendMessageToPC(oDM, sNotification);
            SendMessageToAllDMs(sNotification);
        }
        else if (sParams == "pvp")
        {
            SetLocalInt(GetArea(oDM), "AREA_NEUTRAL_ZONE", 0);
            string sNotification = COLOR_CODE_BLUE_DARK + "Area " + GetName(GetArea(oDM)) + " is now a pvp zone." + COLOR_CODE_END;
            SendMessageToPC(oDM, sNotification);
            SendMessageToAllDMs(sNotification);
        }
    }
    else if ((sParams = ParseCommand(sMessage, "#encounter")) != BADPARSE)
    {
        if (sParams == "on")
        {
            util_ToggleEncountersInArea(GetArea(oDM), TRUE);
            string sNotification = COLOR_CODE_BLUE_DARK + "Enabled encounters in " + GetName(GetArea(oDM)) + COLOR_CODE_END;
            SendMessageToPC(oDM, sNotification);
            SendMessageToAllDMs(sNotification);
        }
        else if (sParams == "off")
        {
            util_ToggleEncountersInArea(GetArea(oDM), FALSE);
            string sNotification = COLOR_CODE_BLUE_DARK + "Disabled encounters in " + GetName(GetArea(oDM)) + COLOR_CODE_END;
            SendMessageToPC(oDM, sNotification);
            SendMessageToAllDMs(sNotification);
        }
    }
    else if ((sParams = ParseCommand(sMessage, "#gainitem")) != BADPARSE)
    {
        CreateItemOnObject(sParams, oDM, max(1, StringToInt(sParams)));
    }
    else if ((sParams = ParseCommand(sMessage, "#pat")) != BADPARSE)
    {
        if (sParams == "clearareacache")
        {
            pat_ClearAreaCache();
            string sNotification = COLOR_CODE_BLUE_DARK + "PAT Area CR Cache cleared" + COLOR_CODE_END;
            SendMessageToPC(oDM, sNotification);
            SendMessageToAllDMs(sNotification);
        }
        if (sParams == "updateareas")
        {
            pat_UpdateAreasTable();
            string sNotification = COLOR_CODE_BLUE_DARK + "PAT Area table updated" + COLOR_CODE_END;
            SendMessageToPC(oDM, sNotification);
            SendMessageToAllDMs(sNotification);
        }
    }
    else return;

    string sMsg = GetName(oDM) + " used command " + sMessage;
    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", WEBHOOK_DM, sMsg, GetName(oDM));
    WriteTimestampedLogEntry(sMsg);
    SetPCChatMessage("");
}
