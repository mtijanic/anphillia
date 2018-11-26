#include "nwnx_events"
#include "nwnx_time"
#include "nwnx_object"
#include "sql_inc"
#include "faction_inc"


const int TELEPORT_INTERVAL_SECONDS = 300; // 5 minute teleport cooldown
void main()
{
    object oPC = OBJECT_SELF;
    if (!GetIsPC(oPC))
        return;

    DelayCommand(3.0, RemoveFromParty(oPC));

    object oJumpTo = NWNX_Object_StringToObject(NWNX_Events_GetEventData("INVITED_BY"));
    if (!GetIsObjectValid(oJumpTo))
    {
        oJumpTo = GetFactionLeader(oPC);
        if (!GetIsObjectValid(oJumpTo))
            return;
    }

    string sDisabled = sql_GetVar("PARTY_TELEPORT_DISABLE");
    if (sDisabled != "")
    {
        FloatingTextStringOnCreature("Party teleporting is temporarily disabled: " + sDisabled, oPC);
        return;
    }
    if (sql_GetPCDead(chr_GetPCID(oPC)) || GetCurrentHitPoints(oPC) <= 0)
    {
        FloatingTextStringOnCreature("*You cannot teleport to your party while dead or dying*", oPC);
        return;
    }
    if (GetIsInCombat(oPC))
    {
        FloatingTextStringOnCreature("*You cannot teleport to your party while in combat*", oPC);
        return;
    }
    if (fctn_GetFaction(oPC) != fctn_GetFaction(oJumpTo))
    {
        FloatingTextStringOnCreature("*You cannot teleport to someone from a different faction*", oPC);
        return;
    }

    int nTimestamp = NWNX_Time_GetTimeStamp();
    int nTimeTillNextJump = TELEPORT_INTERVAL_SECONDS - (nTimestamp - GetLocalInt(oPC, "LAST_PARTY_JUMP_TIME"));
    if (nTimeTillNextJump > 0)
    {
        FloatingTextStringOnCreature("*You can teleport to a party member again in "+IntToString(nTimeTillNextJump)+" seconds*", oPC, FALSE);
        return;
    }

    SetLocalInt(oPC, "LAST_PARTY_JUMP_TIME", nTimestamp);
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, JumpToObject(oJumpTo));
    FloatingTextStringOnCreature("*The party teleport is an OOC tool, please use common sense*", oPC);

    WriteTimestampedLogEntry(GetName(oPC) + " has joined the party of " + GetName(oJumpTo) + " and has jumped from " + GetName(GetArea(oPC)) + " to " +  GetName(GetArea(oJumpTo)));
}
