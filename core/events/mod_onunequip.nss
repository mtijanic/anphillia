///////////////////////////////////////////////////////////////////////////////
// mod_onunequip
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: Placeholder for the module-wide OnUnEquip Event

///////////
// Includes
//
#include "x2_inc_itemprop"

///////////////////////
// Function Declaration
//

////////////////
// Function Code
//

void main()
{
    object oItem = GetPCItemLastUnequipped();
    object oPC = GetPCItemLastUnequippedBy();
    string tag = GetTag(oItem);
}
