#include "dev_inc"
#include "chr_inc"

void main()
{
    object oUser = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    // Team members can rename anything..
    if (!dev_IsTeamMember(oUser))
    {
        if (GetObjectType(oTarget) != OBJECT_TYPE_ITEM || GetItemPossessor(oTarget) != oUser)
        {
            SendMessageToPC(oUser, "This tool is used to rename an item you own. Must target an item in your possession");
            return;
        }
    }

    if (oTarget == OBJECT_INVALID)
        oTarget = GetAreaFromLocation(GetSpellTargetLocation());

    string sOldName = GetName(oTarget);
    string sMsg = chr_GetPlayerChatMessage(oUser);

    SendMessageToPC(oUser, "Renaming " + sOldName + " to " + sMsg);
    SetName(oTarget, sMsg);
}
