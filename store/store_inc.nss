///////////////////////////////////////////////////////////////////////////////
// store_inc
// written by: eyesolated
// written at: Sept. 22, 2004
//
// Notes: Store Include File

///////////
// Includes
//
#include "mod_cfg"
#include "store_cfg"
#include "ip_inc"

///////////////////////
// Function Declaration
//

// Store System Help
void store_Help();

// Initializes a store, do this when a store is opened
void store_Initialize(object oStore);

// Get the name of oStore's owner
string store_GetOwnerName(object oStore);

// Get the current amount of wares this store has to offer
int store_GetAmountOfItems(object oStore);

// Get the Owner object of this store
object store_GetOwner(object oStore);

// Get the store associated with oCreature
object store_GetStore(object oCreature);

// This function should be called when the store sells something
void store_ItemSold(object oStore, object oItem);

// This function should be called when the store buys something
void store_ItemBought(object oStore, object oItem, object oBoughtFrom);

// Clears the store of all items and sets it to "uninitialized"
void store_ResetStore(object oStore);

////////////////
// Function Code
//
void store_Help()
{
}

void store_FillStore(object oStore, string sCategory, int iAmount, int iMinAmount, int iMagicChance, int iMagicLevel, int iIdentifiedChance, int iMainCategory, int iSubCategory, int iBaseItem, int iForceMagical = FALSE, int iDisallowMagical = FALSE)
{
   int iNumberOfItems = 0;
   if (iMinAmount != 0)
      iNumberOfItems = Random(iAmount - (iAmount / iMinAmount)) + (iAmount / iMinAmount);
   else
      iNumberOfItems = Random(iAmount);

   int iCount;
   string sItem;
   object oItem;
   int iMagicChanceRoll;
   int iIdentifiedRoll;
   int iMagical;

   for (iCount = 0; iCount < iNumberOfItems; iCount++)
   {
      iMagical = FALSE;
      iMagicChanceRoll = d100();
      if (
          (iMagicChanceRoll <= iMagicChance || iForceMagical) &&
          (!iDisallowMagical)
         )
      {
         iMagical = TRUE;
         sItem = egs_GetRandomItem(iMainCategory, iSubCategory, iBaseItem, -1, -1, TRUE);
      }
      else
         sItem = egs_GetRandomItem(iMainCategory, iSubCategory, iBaseItem);

      oItem = CreateItemOnObject(sItem, oStore);

      if (GetIsObjectValid(oItem))
      {
         SetDroppableFlag(oItem, TRUE);
         SetIdentified(oItem, TRUE);

         if (iMagical)
         {
            ip_InfuseItemWithMagic(oItem, iMagicLevel, FALSE, TRUE, TRUE, -1);
            iIdentifiedRoll = d100();
            if (iIdentifiedRoll > iIdentifiedChance)
               SetIdentified(oItem, FALSE);
         }

         if (sCategory == CS_STORE_StoreHas_AMMO)
            SetItemStackSize(oItem, 99);
         else if (sCategory == CS_STORE_StoreHas_WEAPON_THROWN)
            SetItemStackSize(oItem, 50);

         SetLocalInt(oStore, sCategory + CS_STORE_AMOUNTSUFFIX, GetLocalInt(oStore, sCategory + CS_STORE_AMOUNTSUFFIX) + 1);
         SetLocalInt(oStore, CS_STORE_ITEMAMOUNT, GetLocalInt(oStore, CS_STORE_ITEMAMOUNT) + 1);
      }
   }
}

void store_Initialize(object oStore)
{
   // If this store already is initialized, don't do a complete Initialization return
   int iInitialized = GetLocalInt(oStore, CS_STORE_INITIALIZED);
   if (iInitialized == 1)
   {
      // Because we can't detect sold items that the store infinitely has, we'll
      // set the current store gold to what he really has
      // This is a workaround that at least works between store openings
      SetLocalInt(oStore, "GoldAmount", GetStoreGold(oStore));
      return;
   }
   // Find out how much gold the store has
   int nStoreGold = GetStoreGold(oStore);
   if (nStoreGold == -1 &&
       GetLocalInt(oStore, "UnlimitedGold") != 1)
   {
      nStoreGold = Random(10) + 5;
      SetStoreGold(oStore, nStoreGold);
   }

   // Set the GoldAmount Variable on the Store
   SetLocalInt(oStore, "GoldAmount", nStoreGold);

   // If Starting Gold variable is not set, this must be the first time the store
   // is opened
   int iStartGold = GetLocalInt(oStore, "StartGold");
   if (iStartGold == 0)
   {
      // Save the starting gold of this store
      SetLocalInt(oStore, "StartGold", nStoreGold);
   }
   else
   {
      SetStoreGold(oStore, iStartGold);
   }

   int iMinAmount = GetLocalInt(oStore, CS_STORE_StoreHasMinimum);
   int iMagicChance = GetLocalInt(oStore, CS_STORE_MAGICCHANCE);
   int iMagicLevel = GetLocalInt(oStore, CS_STORE_MAGICLEVEL);
   int iIdentifiedChance = GetLocalInt(oStore, CS_STORE_IDENTIFIEDCHANCE);

   // Clothing
   int nEverything = GetLocalInt(oStore, CS_STORE_StoreHas_EVERYTHING);
   int iAmount = nEverything + GetLocalInt(oStore, CS_STORE_StoreHas_ARMOR_BODY_CLOTHING);
   if (iAmount > 0)
      store_FillStore(oStore, CS_STORE_StoreHas_ARMOR_BODY_CLOTHING, iAmount, iMinAmount, iMagicChance, iMagicLevel, iIdentifiedChance, -1, CI_EGS_ITEM_SUB_ARMOR_BODY_CLOTHING, -1);
   // Light Armor
   iAmount = nEverything + GetLocalInt(oStore, CS_STORE_StoreHas_ARMOR_BODY_LIGHT);
   if (iAmount > 0)
      store_FillStore(oStore, CS_STORE_StoreHas_ARMOR_BODY_LIGHT, iAmount, iMinAmount, iMagicChance, iMagicLevel, iIdentifiedChance, -1, CI_EGS_ITEM_SUB_ARMOR_BODY_LIGHT, -1);
   // Medium Armor
   iAmount = nEverything + GetLocalInt(oStore, CS_STORE_StoreHas_ARMOR_BODY_MEDIUM);
   if (iAmount > 0)
      store_FillStore(oStore, CS_STORE_StoreHas_ARMOR_BODY_MEDIUM, iAmount, iMinAmount, iMagicChance, iMagicLevel, iIdentifiedChance, -1, CI_EGS_ITEM_SUB_ARMOR_BODY_MEDIUM, -1);
   // Heavy Armor
   iAmount = nEverything + GetLocalInt(oStore, CS_STORE_StoreHas_ARMOR_BODY_HEAVY);
   if (iAmount > 0)
      store_FillStore(oStore, CS_STORE_StoreHas_ARMOR_BODY_HEAVY, iAmount, iMinAmount, iMagicChance, iMagicLevel, iIdentifiedChance, -1, CI_EGS_ITEM_SUB_ARMOR_BODY_HEAVY, -1);
   // Shields
   iAmount = nEverything + GetLocalInt(oStore, CS_STORE_StoreHas_ARMOR_SHIELD);
   if (iAmount > 0)
      store_FillStore(oStore, CS_STORE_StoreHas_ARMOR_SHIELD, iAmount, iMinAmount, iMagicChance, iMagicLevel, iIdentifiedChance, -1, CI_EGS_ITEM_SUB_ARMOR_SHIELD, -1);
   // Helmets
   iAmount = nEverything + GetLocalInt(oStore, CS_STORE_StoreHas_ARMOR_HELMET);
   if (iAmount > 0)
      store_FillStore(oStore, CS_STORE_StoreHas_ARMOR_HELMET, iAmount, iMinAmount, iMagicChance, iMagicLevel, iIdentifiedChance, -1, CI_EGS_ITEM_SUB_ARMOR_HELMET, -1);
   // Melee Weapons
   iAmount = nEverything + GetLocalInt(oStore, CS_STORE_StoreHas_WEAPON_MELEE);
   if (iAmount > 0)
      store_FillStore(oStore, CS_STORE_StoreHas_WEAPON_MELEE, iAmount, iMinAmount, iMagicChance, iMagicLevel, iIdentifiedChance, -1, CI_EGS_ITEM_SUB_WEAPON_MELEE, -1);
   // Ranged Weapons
   iAmount = nEverything + GetLocalInt(oStore, CS_STORE_StoreHas_WEAPON_RANGED);
   if (iAmount > 0)
      store_FillStore(oStore, CS_STORE_StoreHas_WEAPON_RANGED, iAmount, iMinAmount, iMagicChance, iMagicLevel, iIdentifiedChance, -1, CI_EGS_ITEM_SUB_WEAPON_RANGED, -1);
   // Thrown Weapons
   iAmount = nEverything + GetLocalInt(oStore, CS_STORE_StoreHas_WEAPON_THROWN);
   if (iAmount > 0)
      store_FillStore(oStore, CS_STORE_StoreHas_WEAPON_THROWN, iAmount, iMinAmount, iMagicChance, iMagicLevel, iIdentifiedChance, -1, CI_EGS_ITEM_SUB_WEAPON_THROWN, -1);
   // Ammunition
   iAmount = nEverything + GetLocalInt(oStore, CS_STORE_StoreHas_AMMO);
   if (iAmount > 0)
      store_FillStore(oStore, CS_STORE_StoreHas_AMMO, iAmount, iMinAmount, iMagicChance, iMagicLevel, iIdentifiedChance, CI_EGS_ITEM_MAIN_AMMO, -1, -1);
   // Clothing Accessories (Belts, Cloaks etc...)
   iAmount = nEverything + GetLocalInt(oStore, CS_STORE_StoreHas_ACCESSORIES_CLOTHING);
   if (iAmount > 0)
      store_FillStore(oStore, CS_STORE_StoreHas_ACCESSORIES_CLOTHING, iAmount, iMinAmount, iMagicChance, iMagicLevel, iIdentifiedChance, -1, CI_EGS_ITEM_SUB_ACCESSORY_CLOTHING, -1);
   // Jewelry
   iAmount = nEverything + GetLocalInt(oStore, CS_STORE_StoreHas_ACCESSORIES_JEWELRY);
   if (iAmount > 0)
      store_FillStore(oStore, CS_STORE_StoreHas_ACCESSORIES_JEWELRY, iAmount, iMinAmount, iMagicChance, iMagicLevel, iIdentifiedChance, -1, CI_EGS_ITEM_SUB_ACCESSORY_JEWELRY, -1);
   // Rods and Wands
   iAmount = nEverything + GetLocalInt(oStore, CS_STORE_StoreHas_RODSWANDS);
   if (iAmount > 0)
      store_FillStore(oStore, CS_STORE_StoreHas_RODSWANDS, iAmount, iMinAmount, iMagicChance, iMagicLevel, iIdentifiedChance, CI_EGS_ITEM_MAIN_RODWAND, -1, -1, TRUE);
   // Scrolls
   iAmount = nEverything + GetLocalInt(oStore, CS_STORE_StoreHas_SCROLLS);
   if (iAmount > 0)
   {
      int iScrollLevel;
      int iIdentifiedRoll;
      object oScroll;
      int iCount;

      for (iCount = 0; iCount < iAmount; iCount++)
      {
         iScrollLevel = Random(iMagicLevel / 2) - 1;
         if (iScrollLevel > 9)
         {
            iScrollLevel = 9;
         }
         else if (iScrollLevel < 0)
         {
            iScrollLevel = 0;
         }

         oScroll = CreateItemOnObject(ip_GetRandomScroll(iScrollLevel), oStore);
         SetDroppableFlag(oScroll, TRUE);
         iIdentifiedRoll = d100();
         if (iIdentifiedRoll <= iIdentifiedChance)
         {
            SetIdentified(oScroll, TRUE);
         }
         else
         {
            SetIdentified(oScroll, TRUE);
         }
         SetLocalInt(oStore, CS_STORE_StoreHas_SCROLLS + CS_STORE_AMOUNTSUFFIX, GetLocalInt(oStore, CS_STORE_StoreHas_SCROLLS + CS_STORE_AMOUNTSUFFIX) + 1);
      }
   }
   // Potions
   iAmount = nEverything + GetLocalInt(oStore, CS_STORE_StoreHas_POTIONS);
   if (iAmount > 0)
      store_FillStore(oStore, CS_STORE_StoreHas_POTIONS, iAmount, iMinAmount, iMagicChance, iMagicLevel, iIdentifiedChance, -1, -1, BASE_ITEM_POTIONS, TRUE);
   // Containers
   iAmount = nEverything + GetLocalInt(oStore, CS_STORE_StoreHas_CONTAINERS);
   if (iAmount > 0)
      store_FillStore(oStore, CS_STORE_StoreHas_CONTAINERS, iAmount, iMinAmount, iMagicChance, iMagicLevel, iIdentifiedChance, CI_EGS_ITEM_MAIN_CONTAINER, -1, -1);
   // Bombs
   iAmount = nEverything + GetLocalInt(oStore, CS_STORE_StoreHas_BOMBS);
   if (iAmount > 0)
      store_FillStore(oStore, CS_STORE_StoreHas_BOMBS, iAmount, iMinAmount, iMagicChance, iMagicLevel, iIdentifiedChance, CI_EGS_ITEM_MAIN_BOMB, -1, -1, FALSE, TRUE);
   // Thieve's Tools
   iAmount = nEverything + GetLocalInt(oStore, CS_STORE_StoreHas_THIEVESTOOLS);
   if (iAmount > 0)
      store_FillStore(oStore, CS_STORE_StoreHas_THIEVESTOOLS, iAmount, iMinAmount, iMagicChance, iMagicLevel, iIdentifiedChance, -1, -1, BASE_ITEM_THIEVESTOOLS, TRUE);
   // Traps
   iAmount = nEverything + GetLocalInt(oStore, CS_STORE_StoreHas_TRAPS);
   if (iAmount > 0)
      store_FillStore(oStore, CS_STORE_StoreHas_TRAPS, iAmount, iMinAmount, iMagicChance, iMagicLevel, iIdentifiedChance, -1, -1, BASE_ITEM_TRAPKIT, TRUE);
   // MedKits
   iAmount = nEverything + GetLocalInt(oStore, CS_STORE_StoreHas_MEDKITS);
   if (iAmount > 0)
      store_FillStore(oStore, CS_STORE_StoreHas_MEDKITS, iAmount, iMinAmount, iMagicChance, iMagicLevel, iIdentifiedChance, -1, -1, BASE_ITEM_HEALERSKIT, TRUE);
   // Misc.
   iAmount = nEverything + GetLocalInt(oStore, CS_STORE_StoreHas_MISC);
   if (iAmount > 0)
      store_FillStore(oStore, CS_STORE_StoreHas_MISC, iAmount, iMinAmount, iMagicChance, iMagicLevel, iIdentifiedChance, CI_EGS_ITEM_MAIN_MISC, -1, -1, FALSE, TRUE);

   SetLocalInt(oStore, CS_STORE_INITIALIZED, 1);
}

string store_GetOwnerName(object oStore)
{
   return (GetName(store_GetOwner(oStore)));
}

int store_GetAmountOfItems(object oStore)
{
   return (GetLocalInt(oStore, CS_STORE_ITEMAMOUNT));
}

object store_GetOwner(object oStore)
{
   string sStoreTag = GetTag(oStore);
   string sOwnerTag = GetStringLeft(sStoreTag, GetStringLength(sStoreTag) - 6);
   object oOwner = GetObjectByTag(sOwnerTag);
   if (!GetIsObjectValid(oOwner))
   {
      sOwnerTag = GetStringRight(sStoreTag, GetStringLength(sStoreTag) - 6);
      oOwner = GetObjectByTag(sOwnerTag);
   }
   return (oOwner);
}

object store_GetStore(object oCreature)
{
   object oStore = GetLocalObject(oCreature, "store_store");
   if (!GetIsObjectValid(oStore))
   {
       string sTag = GetTag(oCreature);
       oStore = GetNearestObjectByTag(sTag+ "_store");
       if (!GetIsObjectValid (oStore))
       {
           oStore = GetNearestObjectByTag("store_" + sTag);
           if (!GetIsObjectValid (oStore))
               return OBJECT_INVALID;
       }
       SetLocalObject(oCreature, "store_store", oStore);
   }

   return oStore;
}

string store_Evaluate_ItemInfo(struct STRUCT_EGS_ITEMINFO strItem)
{
   int iFoundCategory = FALSE;
   string sCategory = "";
   switch (strItem.SubCategory)
   {
      case CI_EGS_ITEM_SUB_ARMOR_BODY_CLOTHING: iFoundCategory = TRUE; sCategory = CS_STORE_StoreHas_ARMOR_BODY_CLOTHING; break;
      case CI_EGS_ITEM_SUB_ARMOR_BODY_LIGHT: iFoundCategory = TRUE; sCategory = CS_STORE_StoreHas_ARMOR_BODY_LIGHT; break;
      case CI_EGS_ITEM_SUB_ARMOR_BODY_MEDIUM: iFoundCategory = TRUE; sCategory = CS_STORE_StoreHas_ARMOR_BODY_MEDIUM; break;
      case CI_EGS_ITEM_SUB_ARMOR_BODY_HEAVY: iFoundCategory = TRUE; sCategory = CS_STORE_StoreHas_ARMOR_BODY_HEAVY; break;
      case CI_EGS_ITEM_SUB_ARMOR_SHIELD: iFoundCategory = TRUE; sCategory = CS_STORE_StoreHas_ARMOR_SHIELD; break;
      case CI_EGS_ITEM_SUB_ARMOR_HELMET: iFoundCategory = TRUE; sCategory = CS_STORE_StoreHas_ARMOR_HELMET; break;
      case CI_EGS_ITEM_SUB_WEAPON_MELEE: iFoundCategory = TRUE; sCategory = CS_STORE_StoreHas_WEAPON_MELEE; break;
      case CI_EGS_ITEM_SUB_WEAPON_RANGED: iFoundCategory = TRUE; sCategory = CS_STORE_StoreHas_WEAPON_RANGED; break;
      case CI_EGS_ITEM_SUB_WEAPON_THROWN: iFoundCategory = TRUE; sCategory = CS_STORE_StoreHas_WEAPON_THROWN; break;
      case CI_EGS_ITEM_SUB_ACCESSORY_CLOTHING: iFoundCategory = TRUE; sCategory = CS_STORE_StoreHas_ACCESSORIES_CLOTHING; break;
      case CI_EGS_ITEM_SUB_ACCESSORY_JEWELRY: iFoundCategory = TRUE; sCategory = CS_STORE_StoreHas_ACCESSORIES_JEWELRY; break;
   }

   if (!iFoundCategory)
   {
      switch (strItem.MainCategory)
      {
         case CI_EGS_ITEM_MAIN_AMMO: iFoundCategory = TRUE; sCategory = CS_STORE_StoreHas_AMMO; break;
         case CI_EGS_ITEM_MAIN_RODWAND: iFoundCategory = TRUE; sCategory = CS_STORE_StoreHas_RODSWANDS; break;
         case CI_EGS_ITEM_MAIN_MISC: iFoundCategory = TRUE; sCategory = CS_STORE_StoreHas_MISC; break;
         case CI_EGS_ITEM_MAIN_CONTAINER: iFoundCategory = TRUE; sCategory = CS_STORE_StoreHas_CONTAINERS; break;
         case CI_EGS_ITEM_MAIN_BOMB: iFoundCategory = TRUE; sCategory = CS_STORE_StoreHas_BOMBS; break;
      }

      if (!iFoundCategory)
      {
         switch (strItem.BaseItem)
         {
            case BASE_ITEM_HEALERSKIT: iFoundCategory = TRUE; sCategory = CS_STORE_StoreHas_MEDKITS; break;
            case BASE_ITEM_SCROLL: iFoundCategory = TRUE; sCategory = CS_STORE_StoreHas_SCROLLS; break;
            case BASE_ITEM_POTIONS: iFoundCategory = TRUE; sCategory = CS_STORE_StoreHas_POTIONS; break;
            case BASE_ITEM_THIEVESTOOLS: iFoundCategory = TRUE; sCategory = CS_STORE_StoreHas_THIEVESTOOLS; break;
            case BASE_ITEM_TRAPKIT: iFoundCategory = TRUE; sCategory = CS_STORE_StoreHas_TRAPS; break;
         }
      }
   }

   return (sCategory);
}

string store_GetItemStoreCategory(object oItem)
{
   struct STRUCT_EGS_ITEMINFO strItem = egs_GetItemInfo(GetTag(oItem));
   string sCategory = store_Evaluate_ItemInfo(strItem);

   /* Uncomment this to get information about items NOT created by EGS but still
      known to the system */
   if (sCategory == "")
   {
      strItem = egs_GetItemObjectInfo(oItem);
      sCategory = store_Evaluate_ItemInfo(strItem);
   }

   return sCategory;
}

void store_ItemSold(object oStore, object oItem)
{
   string sCategory = store_GetItemStoreCategory(oItem);
   SetLocalInt(oStore, "GoldAmount", GetStoreGold(oStore));

   int iNewAmount = GetLocalInt(oStore, sCategory + CS_STORE_AMOUNTSUFFIX) - 1;
   SetLocalInt(oStore, sCategory + CS_STORE_AMOUNTSUFFIX, iNewAmount);
   SetLocalInt(oStore, CS_STORE_ITEMAMOUNT, GetLocalInt(oStore, CS_STORE_ITEMAMOUNT) - 1);

   // SendMessageToAllDMs("Someone bought an item of Category [" + sCategory + "] from a store");
}

int store_ItemBought(object oStore, object oItem, object oBoughtFrom)
{
   int iGoldBefore = GetLocalInt(oStore, "GoldAmount");
   int iGoldNow = GetStoreGold(oStore);

   object oOwner = store_GetOwner(oStore);
   string sCategory = store_GetItemStoreCategory(oItem);
   if (GetLocalInt(oStore, sCategory) == 0)
   {
      AssignCommand(oOwner, ActionSpeakString("Sorry, i don't trade with items of this type"));
      object oNewItem = CopyItem(oItem, oOwner, TRUE);
      DestroyObject(oItem);
      AssignCommand(oOwner, ActionGiveItem(oNewItem, oBoughtFrom));
      AssignCommand(oStore, TakeGoldFromCreature(iGoldBefore - iGoldNow, oBoughtFrom, TRUE));
      SetLocalInt(oStore, "GoldAmount", iGoldBefore);
      SetStoreGold(oStore, iGoldBefore);
      return FALSE;
   }
   int iNewAmount = GetLocalInt(oStore, sCategory + CS_STORE_AMOUNTSUFFIX) + 1;

   if (iNewAmount > GetLocalInt(oStore, sCategory) * 2)
   {
      AssignCommand(oOwner, ActionSpeakString("Sorry, i don't buy any more items of this type at this time"));
      object oNewItem = CopyItem(oItem, oOwner, TRUE);
      DestroyObject(oItem);
      AssignCommand(oOwner, ActionGiveItem(oNewItem, oBoughtFrom));
      AssignCommand(oStore, TakeGoldFromCreature(iGoldBefore - iGoldNow, oBoughtFrom, TRUE));
      SetLocalInt(oStore, "GoldAmount", iGoldBefore);
      SetStoreGold(oStore, iGoldBefore);
      return FALSE;
   }
   else
   {
      SetLocalInt(oStore, sCategory + CS_STORE_AMOUNTSUFFIX, iNewAmount);
      SetLocalInt(oStore, CS_STORE_ITEMAMOUNT, GetLocalInt(oStore, CS_STORE_ITEMAMOUNT) + 1);
   }

   SetLocalInt(oStore, "GoldAmount", iGoldNow);
   //SendMessageToAllDMs("Someone sold an item of Category [" + sCategory + "] to a store");
   return TRUE;
}

void store_ResetStore(object oStore)
{
   object oItem = GetFirstItemInInventory(oStore);
   while (oItem != OBJECT_INVALID)
   {
      DestroyObject(oItem);
      oItem = GetNextItemInInventory(oStore);
   }
   DeleteLocalInt(oStore, CS_STORE_StoreHas_ARMOR_BODY_CLOTHING + CS_STORE_AMOUNTSUFFIX);
   DeleteLocalInt(oStore, CS_STORE_StoreHas_ARMOR_BODY_LIGHT + CS_STORE_AMOUNTSUFFIX);
   DeleteLocalInt(oStore, CS_STORE_StoreHas_ARMOR_BODY_MEDIUM + CS_STORE_AMOUNTSUFFIX);
   DeleteLocalInt(oStore, CS_STORE_StoreHas_ARMOR_BODY_HEAVY + CS_STORE_AMOUNTSUFFIX);
   DeleteLocalInt(oStore, CS_STORE_StoreHas_ARMOR_SHIELD + CS_STORE_AMOUNTSUFFIX);
   DeleteLocalInt(oStore, CS_STORE_StoreHas_ARMOR_HELMET + CS_STORE_AMOUNTSUFFIX);
   DeleteLocalInt(oStore, CS_STORE_StoreHas_WEAPON_MELEE + CS_STORE_AMOUNTSUFFIX);
   DeleteLocalInt(oStore, CS_STORE_StoreHas_WEAPON_RANGED + CS_STORE_AMOUNTSUFFIX);
   DeleteLocalInt(oStore, CS_STORE_StoreHas_WEAPON_THROWN + CS_STORE_AMOUNTSUFFIX);
   DeleteLocalInt(oStore, CS_STORE_StoreHas_AMMO + CS_STORE_AMOUNTSUFFIX);
   DeleteLocalInt(oStore, CS_STORE_StoreHas_ACCESSORIES_CLOTHING + CS_STORE_AMOUNTSUFFIX);
   DeleteLocalInt(oStore, CS_STORE_StoreHas_ACCESSORIES_JEWELRY + CS_STORE_AMOUNTSUFFIX);
   DeleteLocalInt(oStore, CS_STORE_StoreHas_RODSWANDS + CS_STORE_AMOUNTSUFFIX);
   DeleteLocalInt(oStore, CS_STORE_StoreHas_SCROLLS + CS_STORE_AMOUNTSUFFIX);
   DeleteLocalInt(oStore, CS_STORE_StoreHas_POTIONS + CS_STORE_AMOUNTSUFFIX);
   DeleteLocalInt(oStore, CS_STORE_StoreHas_CONTAINERS + CS_STORE_AMOUNTSUFFIX);
   DeleteLocalInt(oStore, CS_STORE_StoreHas_BOMBS + CS_STORE_AMOUNTSUFFIX);
   DeleteLocalInt(oStore, CS_STORE_StoreHas_THIEVESTOOLS + CS_STORE_AMOUNTSUFFIX);
   DeleteLocalInt(oStore, CS_STORE_StoreHas_TRAPS + CS_STORE_AMOUNTSUFFIX);
   DeleteLocalInt(oStore, CS_STORE_StoreHas_MEDKITS + CS_STORE_AMOUNTSUFFIX);
   DeleteLocalInt(oStore, CS_STORE_StoreHas_MISC + CS_STORE_AMOUNTSUFFIX);
   DeleteLocalInt(oStore, CS_STORE_ITEMAMOUNT);
   DeleteLocalInt(oStore, CS_STORE_INITIALIZED);
}
