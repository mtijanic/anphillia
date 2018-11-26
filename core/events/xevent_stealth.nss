#include "nwnx_events"
#include "nwnx_time"

const int STEALTH_INTERVAL_SECONDS = 12;
void main()
{
    object oPC = OBJECT_SELF;
    if (!GetIsPC(oPC))
        return;

    int nTimestamp = NWNX_Time_GetTimeStamp();
    int nTimeTillNextStealth = STEALTH_INTERVAL_SECONDS - (nTimestamp - GetLocalInt(oPC, "LAST_STEALTH_TIME"));
    if (nTimeTillNextStealth > 0)
    {
        SetActionMode(oPC, ACTION_MODE_STEALTH, FALSE);
        FloatingTextStringOnCreature("*You can enter stealth again in "+IntToString(nTimeTillNextStealth)+" seconds*", oPC, FALSE);
    }
    else
    {
        SetLocalInt(oPC, "LAST_STEALTH_TIME", nTimestamp);
    }
}
