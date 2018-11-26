///////////////////////////////////////////////////////////////////////////////
// mod_onchat
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: Placeholder for the module-wide OnPlayerChat Event
#include "eas_inc"
#include "color_inc"
#include "esm_inc"
#include "dbg_inc"
#include "chr_inc"
#include "nwnx_webhook"
#include "dev_inc"

const string WEBHOOK_DM = "/api/webhooks/451344020606812161/th1si5n0tar43lAPiK3y-n3v3rPuTaPiKEY5inS0urceRep0_Y_amIap0tat0lalalaF/slack";

void main()
{
    SetLocalInt(OBJECT_SELF, "CURRENT_SCRIPT", EVENT_SCRIPT_MODULE_ON_PLAYER_CHAT);
    object oPC = GetPCChatSpeaker();
    string sMessage = GetPCChatMessage();
    int nVolume = GetPCChatVolume();
    int bTeam = dev_IsTeamMember(oPC);

    // Call esm OnPlayerChat
    esm_OnPlayerChat(oPC, sMessage);

    if (nVolume == TALKVOLUME_SHOUT && !bTeam)
    {
        SetPCChatMessage("");
    }
    string sParam;

    // OOC talk
    if (GetStringLeft(sMessage, 2) == "//" || GetStringLeft(sMessage, 2) == "((")
    {
        SetPCChatMessage(COLOR_CODE_ORANGE + sMessage + COLOR_CODE_END);
    }
    else if (GetStringLeft(sMessage, 1) == "/")
    {
        ExecuteScript("chat_commands", OBJECT_SELF);
    }

    chr_LogPlayerChatMessage(oPC, sMessage);
    if (nVolume == TALKVOLUME_TALK || nVolume == TALKVOLUME_WHISPER)
        if (!chr_GetPlayerCanSpeak(oPC))
            SetPCChatMessage("");

    // DM commands start with # (to match ## builtins)
    if (GetStringLeft(sMessage, 1) == "#" && bTeam)
        ExecuteScript("dev_commands", OBJECT_SELF);


    if (nVolume == TALKVOLUME_PARTY && !bTeam)
    {
        SendMessageToPC(oPC, "Party chat has been disabled");
        SetPCChatMessage("");
    }

    if (nVolume == TALKVOLUME_SILENT_SHOUT)
    {
        NWNX_WebHook_SendWebHookHTTPS("discordapp.com", WEBHOOK_DM, sMessage, GetSubString(GetName(oPC), 0, 20));
    }

    object oOther = GetLocalObject(oPC, "SPEAK_THROUGH_OTHER");
    if (GetIsObjectValid(oOther))
    {
        AssignCommand(oOther, SpeakString(sMessage, nVolume));
        SetPCChatMessage("");
    }

    string sExtraScript = GetLocalString(oPC, "ON_PLAYER_CHAT_SCRIPT");
    if (sExtraScript != "")
        ExecuteScript(sExtraScript, OBJECT_SELF);

    DeleteLocalInt(OBJECT_SELF, "CURRENT_SCRIPT");
}
