#include "nwnx_dialog"
void main()
{
    object oPC = GetPCSpeaker();
    SetLocalString(oPC, "DLGX_LAST_SELECTION", NWNX_Dialog_GetCurrentNodeText());
    SetLocalInt(oPC, "DLGX_LAST_SELECTION_INDEX", NWNX_Dialog_GetCurrentNodeIndex());
// save current text in some local
}
