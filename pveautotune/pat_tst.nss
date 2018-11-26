/************************************************************************
 * script name  : pat_tst
 * created by   : eyesolated
 * date         : 2018/7/31
 *
 * description  : Test script for PAT
 *
 * changes      : 2018/7/31 - eyesolated - Initial creation
 ************************************************************************/
#include "pat_cfg"

void main()
{
    object oUser = GetLastUsedBy();
    string sTest = GetTag(OBJECT_SELF);

    // Get target CR
    int nCR = StringToInt(GetStringRight(sTest, 2));

    // Get Area
    object oArea = GetArea(OBJECT_SELF);

    // Set PAT CR on the Area
    SetLocalInt(oArea, PAT_VAR_CR, nCR);
}
