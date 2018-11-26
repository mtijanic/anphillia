///////////////////////////////////////////////////////////////////////////////
// egs_tst
// written by: eyesolated
// written at: June 17, 2004
//
// Notes: Test script for the IP

///////////
// Includes
//
#include "eas_inc"
#include "color_inc"
#include "egs_inc"
#include "ip_inc"

void main()
{
   object oUser = GetLastUsedBy();
   string sTag = GetTag(OBJECT_SELF);
   if (sTag == "o_ip_rnditem")
   {
      string sItem = egs_GetItem_Any(-1, -1, TRUE);
      object oItem = CreateItemOnObject(sItem, oUser);
      if (!GetIsObjectValid(oItem))
      {
         SendMessageToAllDMs("Error creating " + sItem);
         return;
      }
      ip_InfuseItemWithMagic(oItem, 20, TRUE, TRUE);
   }
   else if (sTag == "o_ip_wand")
   {
      string sItem = egs_GetItem_Wand(-1, TRUE);//"i_egs_wand01";
      object oItem = CreateItemOnObject(sItem, oUser);
      ip_InfuseItemWithMagic(oItem, 50, FALSE, TRUE);
   }
   else if (sTag == "o_ip_weapon")
   {
      string sItem = egs_GetItem_Weapon(-1, -1, TRUE);
      object oItem = CreateItemOnObject(sItem, oUser);
      ip_InfuseItemWithMagic(oItem, 25, FALSE, TRUE);
   }
   else if (sTag == "o_ip_armor")
   {
      string sItem = egs_GetItem_Armor(-1, TRUE);
      object oItem = CreateItemOnObject(sItem, oUser);
      ip_InfuseItemWithMagic(oItem, 20, FALSE, TRUE);
   }
}
