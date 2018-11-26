#include "sql_inc"
#include "nwnx_dialog"
// [Select] or "Select faction"
void main()
{
    object oPC = GetPCSpeaker();
    string sSubrace = GetLocalString(oPC, "DLGX_LAST_SELECTION");

    SendMessageToPC(oPC, "Old SubRace:" + GetSubRace(oPC) + "; New SubRace:" + sSubrace);
    SetSubRace(oPC, sSubrace);
}
