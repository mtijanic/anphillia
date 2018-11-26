///////////////////////////////////////////////////////////////////////////////
// store_hrtbeat
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: The special heartbeat for Store owners, responsible for resetting
//        the store

///////////
// Includes
//
#include "eas_inc"
#include "color_inc"
#include "egs_inc"
#include "ip_inc"
#include "store_inc"
#include "store_cfg"

///////////////////////
// Function Declaration
//

////////////////
// Function Code
//
void main()
{
    ExecuteScript(CS_STORE_DEFAULTHEARTBEATSCRIPT, OBJECT_SELF);
    object oStore = store_GetStore(OBJECT_SELF);

    // If the store is valid, move on
    if (GetIsObjectValid(oStore))
    {
        // See if the store is initialized, if not, return
        if (GetLocalInt(oStore, CS_STORE_INITIALIZED) == 0)
            return;

        // If the store is initialized, we increase the heartbeat counter
        int iNumHeartbeats = GetLocalInt(oStore, "heartbeats") + 1;
        SetLocalInt(oStore, "heartbeats", iNumHeartbeats);

        // If we reach the number of heartbeats needed, we reset the store
        if(iNumHeartbeats > CS_STORE_RESETTIME)
        {
            DeleteLocalInt(oStore, "heartbeats");
            store_ResetStore(oStore);
        }
    }
}
