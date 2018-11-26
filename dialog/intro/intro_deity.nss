#include "chr_inc"
// [Change Deity]
void main()
{
    object oPC = GetPCSpeaker();
    string sMsg = chr_GetPlayerChatMessage(oPC);
    SendMessageToPC(oPC, "Old Deity:" + GetDeity(oPC) + "; New Deity:" + sMsg);
    SetDeity(oPC, sMsg);
}
