#include "dev_inc"
#include "chr_inc"

void main()
{
    object oUser = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    // Team members can rename anything..
    if (!dev_IsTeamMember(oUser))
    {
        dbg_ReportBug("Team-only tool used. How did you get this?", oUser);
        return;
    }

    if (oTarget == OBJECT_INVALID || oTarget == OBJECT_SELF)
    {
        SendMessageToPC(oUser, "You will now speak normally.");
        DeleteLocalObject(oUser, "SPEAK_THROUGH_OTHER");
    }
    else
    {
        SetLocalObject(oUser, "SPEAK_THROUGH_OTHER", oTarget);
        SendMessageToPC(oUser, "You will now speak through " + GetName(oTarget));
    }
}
