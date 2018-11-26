///////////////////////////////////////////////////////////////////////////////
// anph_gate_ondmg
// written by: eyesolated
// written at: May 19, 2018
//
// Notes: Deals with bashing in doors

// Defines how long a door takes to regenerate. The Health of the door is multiplied
// with this value to get the seconds until it is fully healed/repaired again
const int DOOR_HITPOINTS_DELAY_MULTIPLIER               = 1;

const string DOOR_VAR_HITPOINTS                         = "Hitpoints";
const string DOOR_VAR_KEYTAG                            = "door_KeyTag";

// this const is also used in "anph_close_door" and "anph_gate_closed",
// be sure to change it there as well if you change it here
const string DOOR_KEYTAG_BASHED                         = "door_Bashed_NoKey";

#include "nwnx_webhook"
#include "nwnx_time"
const string WEBHOOK_ALARM = "/api/webhooks/451346097038819329/th1si5n0tar43lAPiK3y-n3v3rPuTaPiKEY5inS0urceRep0_Y_amIap0tat0lalalaF/slack";

void door_Repaired(object oDoor)
{
    // Change the Key Tag
    SetLockKeyTag(oDoor, GetLocalString(oDoor, DOOR_VAR_KEYTAG));

    // Open the door
    ActionCloseDoor(oDoor);

    // Lock the door again
    SetLocked(oDoor, TRUE);

    // Make the door NOT PLOT so it can be damaged again
    SetPlotFlag(oDoor, FALSE);
}

void main()
{
    object oDoor = OBJECT_SELF;
    int nRealMaxHitPoints = GetLocalInt(oDoor, DOOR_VAR_HITPOINTS);
    int nCurrentHitPoints = GetCurrentHitPoints(oDoor);
    int nMaxHitPoints = GetMaxHitPoints(oDoor);

    int nTimestamp = NWNX_Time_GetTimeStamp();
    int nLastAlarmTime = GetLocalInt(oDoor, "LAST_ALARM_TIME");
    int nDisableDiscord = GetLocalInt(oDoor, "Discord_Disable");
    if (nDisableDiscord == 0 &&
        (nTimestamp - nLastAlarmTime) > 30) // 30 seconds between alarms
    {
        SetLocalInt(oDoor, "LAST_ALARM_TIME", nTimestamp);
        string sMessage = "Gate under attack!";
        NWNX_WebHook_SendWebHookHTTPS("discordapp.com", WEBHOOK_ALARM, sMessage, GetTag(oDoor));
    }

    if (!GetPlotFlag(oDoor) &&
        nCurrentHitPoints < (nMaxHitPoints - nRealMaxHitPoints)) // The door is below it's max hitpoings
    {
        // Remember the keytag to open the door when it's not bashed in
        SetLocalString(oDoor, DOOR_VAR_KEYTAG, GetLockKeyTag(oDoor));

        // Change the Key Tag
        SetLockKeyTag(oDoor, DOOR_KEYTAG_BASHED);

        // Unlock the door
        SetLocked(oDoor, FALSE);

        // Open the door
        ActionOpenDoor(oDoor);

        // Make the door PLOT so it can't be damaged any more
        SetPlotFlag(oDoor, TRUE);

        // Heal the door to full
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nRealMaxHitPoints), oDoor);

        // Close the door again after a delay
        DelayCommand(IntToFloat(nRealMaxHitPoints * DOOR_HITPOINTS_DELAY_MULTIPLIER), door_Repaired(oDoor));

        if (nDisableDiscord == 0)
        {
            string sMessage = "Gate has been breached!";
            NWNX_WebHook_SendWebHookHTTPS("discordapp.com", WEBHOOK_ALARM, sMessage, GetTag(oDoor));
        }
    }
}
