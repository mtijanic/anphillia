/************************************************************************
 * script name  : lycan_onspawn
 * created by   : eyesolated
 * date         : 2018/7/10
 *
 * description  : OnSpawn script for Lycanthropes
 ************************************************************************/
#include "lycan_inc"
void main()
{
    // Check for Lycanthropy Change
    int nTurned = lycan_Check(OBJECT_SELF);

    // Execute standard Heartbeat script
    if (!nTurned)
        ExecuteScript("nw_c2_default9", OBJECT_SELF);
}
