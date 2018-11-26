///////////////////////////////////////////////////////////////////////////////
// mod_onrest
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: Placeholder for the module-wide OnRest Event

///////////
// Includes
//
#include "datetime_inc"
#include "dlg_inc"
#include "chr_inc"
///////////////////////
// Function Declaration
//

////////////////
// Function Code
//

void main()
{
    object oPC = GetLastPCRested();
    int nRestEvent = GetLastRestEventType();

    // Call the OnRest function in chr_inc
    chr_OnRest(oPC, nRestEvent);
}
