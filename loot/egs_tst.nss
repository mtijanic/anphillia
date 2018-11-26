///////////////////////////////////////////////////////////////////////////////
// egs_tst
// written by: eyesolated
// written at: June 17, 2004
//
// Notes: Test script for the EGS

///////////
// Includes
//
#include "eas_inc"
#include "egs_inc"

void main()
{
    object oUser = GetLastUsedBy();
    string sTest = GetTag(OBJECT_SELF);
    string sItem;
    if (sTest == "Get_ItemAny")
    {
        SendMessageToPC(oUser, "Testing '" + sTest + "'");
        sItem = egs_GetItem_Any();
    }
    else if (sTest == "Get_ItemWeaponMelee")
    {
        SendMessageToPC(oUser, "Testing '" + sTest + "'");
        sItem = egs_GetItem_WeaponMelee();
    }
    else if (sTest == "Get_ItemWeaponTiny")
    {
        SendMessageToPC(oUser, "Testing '" + sTest + "'");
        sItem = egs_GetItem_Weapon(-1, CI_EGS_WEAPONSIZE_TINY);
    }
    else if (sTest == "Get_ItemWand")
    {
        SendMessageToPC(oUser, "Testing '" + sTest + "'");
        sItem = egs_GetItem_Wand();
    }
    else if (sTest == "Get_ItemFood")
    {
        SendMessageToPC(oUser, "Testing '" + sTest + "'");
        sItem = egs_GetRandomItem(CI_EGS_ITEM_MAIN_FOOD);
    }
    CreateItemOnObject(sItem, oUser);
    SendMessageToPC(oUser, "Created Object: '" + sItem + "'");
}
