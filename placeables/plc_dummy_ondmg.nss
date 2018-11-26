#include "xp_inc"
#include "nwnx_time"


void main()
{
    object oPC = GetLastDamager();

    if (!GetIsPC(oPC))
        return;

    int tNow = NWNX_Time_GetTimeStamp();
    int tLast = GetLocalInt(oPC, "DUMMY_LAST_HIT_TIME");
    int nSession = GetLocalInt(oPC, "DUMMY_SESSION");
    int tSince = (tNow - tLast);
    if (tSince > 60 && tSince < 120)
    {
        xp_GiveXP(oPC, 10, XP_TYPE_COMBAT);
        AssignCommand(oPC, ClearAllActions());
        if (++nSession > 10)
        {
            DeleteLocalInt(oPC, "DUMMY_SESSION");
            SetLocalInt(oPC, "DUMMY_LAST_HIT_TIME", tNow + 3600);
            SendMessageToPC(oPC, "You have finished with this training session. Come back at a later time");
        }
        else
        {
            SetLocalInt(oPC, "DUMMY_LAST_HIT_TIME", tNow);
        }
    }
    else if (tSince > 120)
    {
        SetLocalInt(oPC, "DUMMY_LAST_HIT_TIME", tNow);
        if (nSession == 0)
        {
            SendMessageToPC(oPC, "You start a new training session...");
            NWNX_Object_SetCurrentHitPoints(OBJECT_SELF, GetMaxHitPoints(OBJECT_SELF));
        }
        else
            SendMessageToPC(oPC, "You continue your training session...");
    }
    else if (tSince < 0)
    {
        SendMessageToPC(oPC, "You have finished with this training session. Come back at a later time");
    }
}
