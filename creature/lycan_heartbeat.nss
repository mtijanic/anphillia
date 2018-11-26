/************************************************************************
 * script name  : lycan_heartbeat
 * created by   : eyesolated
 * date         : 2018/7/10
 *
 * description  : Heartbeat script for Lycanthropes
 ************************************************************************/
#include "lycan_inc"
void main()
{
    // Check for Lycanthropy Change
    int nTurned = lycan_Check(OBJECT_SELF);

    // Execute standard Heartbeat script if we haven't turned
    if (!nTurned)
        ExecuteScript("nw_c2_default1", OBJECT_SELF);
}
