///////////////////////////////////////////////////////////////////////////////
// mod_onheart
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: Placeholder for the module-wide OnHeartbeat Event


///////////
// Includes
//
#include "datetime_inc"

void main()
{
    int hb = GetLocalInt(OBJECT_SELF, "MOD_HEARTBEAT");

    if (hb % 100 == 0)
        datetime_SaveCurrentDateTime();

    if (hb % 20 == 0)
        ExecuteScript("chr_update_all", OBJECT_SELF);

    if (hb % 70 == 0)
        ExportAllCharacters();

    SetLocalInt(OBJECT_SELF, "MOD_HEARTBEAT", hb+1);
}
