#include "nwnx_webhook"
#include "color_inc"


const string WEBHOOK_BUG = "/api/webhooks/453873022315659275/th1si5n0tar43lAPiK3y-n3v3rPuTaPiKEY5inS0urceRep0_Y_amIap0tat0lalalaF/slack";

// Report a bug, sending it everywhere
void dbg_ReportBug(string sMessage, object oReporter=OBJECT_INVALID);
// Print a warning
void dbg_Warning(string sMessage, object oReporter=OBJECT_INVALID);

string dbg_GetReporterInfo(object oReporter);

string dbg_GetReporterInfo(object oReporter)
{
    if (GetIsObjectValid(oReporter))
    {
        return GetName(oReporter) + "(" + (GetIsPC(oReporter) ? GetPCPublicCDKey(oReporter) : GetTag(oReporter)) + ")"
               + " @ " + GetName(GetArea(oReporter)) + "(" + GetTag(GetArea(oReporter)) + ")";
    }
    return "";
}

void dbg_ReportBug(string sMessage, object oReporter=OBJECT_INVALID)
{
    string sPrefix = "[BUG] " + dbg_GetReporterInfo(oReporter);
    string sBug =  sPrefix + "\n" + sMessage;
    string sBugColor = COLOR_CODE_RED + sBug + COLOR_CODE_END;

    WriteTimestampedLogEntry(sBug);
    SendMessageToAllDMs(sBugColor);
    if (GetIsPC(oReporter)) SendMessageToPC(oReporter, sBugColor);
    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", WEBHOOK_BUG, sMessage, "BUG - " + GetName(oReporter));
}

void dbg_Warning(string sMessage, object oReporter=OBJECT_INVALID)
{
    string sPrefix = "[WARNING] " + dbg_GetReporterInfo(oReporter);
    string sBug =  sPrefix + "\n" + sMessage;
    string sBugColor = COLOR_CODE_ORANGE + sBug + COLOR_CODE_END;

    WriteTimestampedLogEntry(sBug);
    SendMessageToAllDMs(sBugColor);
    if (GetIsPC(oReporter)) SendMessageToPC(oReporter, sBugColor);
    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", WEBHOOK_BUG, sMessage, "Warning - " + GetName(oReporter));
}
