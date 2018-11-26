///////////////////////////////////////////////////////////////////////////////
// store_ini
// written by: eyesolated
// written at: Sept. 22, 2004
//
// Notes: Store Initialization

///////////
// Includes
//
//#include "store_inc"
#include "store_cfg"

///////////////////////
// Function Declaration
//

////////////////
// Function Code
//
void main()
{
    object oModule = GetModule();

    SetLocalInt(oModule, CS_STORE_SYSTEMREADY, 1);
}
