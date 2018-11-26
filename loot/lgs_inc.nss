///////////////////////////////////////////////////////////////////////////////
// lgs_inc
// written by: eyesolated
// written at: July 5, 2004
//
// Notes:

///////////
// Includes
//
// Needs
#include "ip_inc"
//#include "x0_i0_treasure"
#include "mod_cfg"
#include "lgs_cfg"
#include "pat_cfg"

///////////////////////
// Function Declaration
//

// Help
void lgs_Help();

// Clears the inventory of oMonster
void lgs_ClearInventory(object oMonster);

// Creates the specified item on oTarget
// if iInventorySlot is set to -1, the item won't be equipped
// These items are named and unidentified if CI_LGS_DROPEQUIPMENT = TRUE,
// unnamed and identified if CI_LGS_DROPEQUIPMENT = FALSE
//
// Setting iMaxWeaponSize to anything but -1 for items that are not weapons
// will cause NO ITEMS to be found
object lgs_CreateEquipmentOnTarget(int iMainCategory, int iSubCategory, int iBaseItem, object oTarget, int iInventorySlot, int iLevel, int iMaxWeaponSize = -1);

// Creates the specified item on oTarget
// if iInventorySlot is set to -1, the item won't be equipped
// These items always are named and unidentified
//
// Setting iMaxWeaponSize to anything but -1 for items that are not weapons
// will cause NO ITEMS to be found
object lgs_CreateItemOnTarget(int iMainCategory, int iSubCategory, int iBaseItem, object oTarget, int iInventorySlot, int iLevel, int iOverrideMaxMagicLevel = -1, int iForceMagical = FALSE, int iDisallowMagical = FALSE, int iMaxWeaponSize = -1);

// Adds nProperty to oItem with a chance based on creature CR if Equipment is
// set to not drop
void lgs_AdditionalChance(object oItem, int iLevel, int nProperty, int nPolicy = X2_IP_ADDPROP_POLICY_KEEP_EXISTING);

// Equip monster oMonster
// iAddedDropChance gets added to every DropChance-Check.
// Set to 100 to ensure every possible item will be created
// Set to -500 to ensure no item will be created
void lgs_EquipMonster(object oMonster, int iAddedDropChance = 0);

// Create loot for oMonster on oLootContainer according to it's difficulty/CR
// If oLootContainer isn't a valid object, oMonster will be used as loot container
//
// iFixedLootOnly:     if this is set to true, the method only checks for fixed loot and
//                     ignores it's random ways of generating loot
// iNumberOfLootItems: sets the number of loot items to generate. If this is set to -1
//                     LGS handles the number of loot items.
//
// NOTE: if oMonster refers to a placeable, the System looks for a variabla named "LGS_CR" on that placeable to
//       determine difficulty/CR
void lgs_CreateLoot(object oMonster, object oLootContainer = OBJECT_INVALID, object oLootContainer_Self = OBJECT_INVALID, int iFixedLootOnly = FALSE, int iNumberOfLootItems = -1);

////////////////
// Function Code
//

void lgs_Help()
{
}

void lgs_ClearInventory(object oMonster)
{
    int nAmtGold = GetGold(oMonster); //Get any gold from the dead creature
    if(nAmtGold) TakeGoldFromCreature(nAmtGold, oMonster, TRUE);

    DestroyObject(GetItemInSlot(INVENTORY_SLOT_ARMS, oMonster));
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_ARROWS, oMonster));
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_BELT, oMonster));
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_BOLTS, oMonster));
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_BOOTS, oMonster));
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_BULLETS, oMonster));
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oMonster));
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_CHEST, oMonster));
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_CLOAK, oMonster));
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oMonster));
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMonster));
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oMonster));
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_HEAD, oMonster));
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oMonster));
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_LEFTRING, oMonster));
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_NECK, oMonster));
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMonster));
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oMonster));

    object oLootEQ = GetFirstItemInInventory(oMonster);
    while(GetIsObjectValid(oLootEQ))
    {
        DestroyObject(oLootEQ);
        oLootEQ = GetNextItemInInventory(oMonster);
    }
}

void lgs_EquipItem(object oTarget, object oItem, int iInventorySlot)
{
    // Get currently equipped item
    object oEquippedItem = GetItemInSlot(iInventorySlot, oTarget);

    // If the item is set to not be replaced, don't even generate a replacement item
    if (GetLocalInt(oEquippedItem, CS_LGS_EQUIP_DONTREPLACE) == 1)
        return;

    AssignCommand(oTarget, ActionEquipItem(oItem, iInventorySlot));
}

object lgs_CreateEquipmentOnTarget(int iMainCategory, int iSubCategory, int iBaseItem, object oTarget, int iInventorySlot, int iLevel, int iMaxWeaponSize = -1)
{
   // Get currently equipped item
   object oEquippedItem = GetItemInSlot(iInventorySlot, oTarget);

   // If the item is set to not be replaced, don't even generate a replacement item
   if (GetLocalInt(oEquippedItem, CS_LGS_EQUIP_DONTREPLACE) == 1)
      return OBJECT_INVALID;

   int iMagical = FALSE;
   int iIdentify = FALSE;
   int iForceLevel = FALSE;
   int iIncludeMonsterOnlyProps = FALSE;
   string sItem;
   int iMagicChance = d100();

   // If the equipment isn't dropped, no harm in givin more magic items to the monsters
   // to be competitive, besides, we'll force the magic level to help that even more
   int iChance = CI_LGS_CHANCE_MAGICAL_EQ;
   if (CI_LGS_DROPEQUIPMENT == FALSE)
   {
      iIdentify = TRUE;
      iForceLevel = TRUE;
      iIncludeMonsterOnlyProps = TRUE;
      iChance += 2*iLevel;
   }

   if (iMagicChance <= iChance)
   {
      iMagical = TRUE;
      sItem = egs_GetRandomItem(iMainCategory, iSubCategory, iBaseItem, iLevel, iMaxWeaponSize, TRUE);
   }
   else
   {
      sItem = egs_GetRandomItem(iMainCategory, iSubCategory, iBaseItem, iLevel, iMaxWeaponSize);
   }
   int nStackSize = (iMainCategory == CI_EGS_ITEM_MAIN_AMMO) ? Random(50) + 20 : 1;
   object oItem = CreateItemOnObject(sItem, oTarget, nStackSize);
   if (GetIsObjectValid(oItem))
   {
      SetDroppableFlag(oItem, CI_LGS_DROPEQUIPMENT);
      SetIdentified(oItem, TRUE);

      if (iMagical)
      {
         if (iLevel < CI_LGS_CR_BOOST_UNTIL)
         {
            iLevel += CI_LGS_CR_BOOST_VALUE;
            if (iLevel > CI_LGS_CR_BOOST_UNTIL)
                iLevel = CI_LGS_CR_BOOST_UNTIL;
         }

         ip_InfuseItemWithMagic(oItem, iLevel, iForceLevel, iIdentify, TRUE, iIncludeMonsterOnlyProps, -1);
      }
      if (iInventorySlot != -1)
         DelayCommand(3.0, lgs_EquipItem(oTarget, oItem, iInventorySlot));
   }
   return (oItem);
}

object lgs_CreateItemOnTarget(int iMainCategory, int iSubCategory, int iBaseItem, object oTarget, int iInventorySlot, int iLevel, int iOverrideMaxMagicLevel = -1, int iForceMagical = FALSE, int iDisallowMagical = FALSE, int iMaxWeaponSize = -1)
{
   int iMagical = FALSE;
   string sItem;

   int iMagicChance = d100();
   if (
       (iMagicChance <= (CI_LGS_CHANCE_MAGICAL_LOOT_BASE + FloatToInt(iLevel * CF_LGS_CHANCE_MAGICAL_LOOT_MODIFIER)) || iForceMagical) &&
       (!iDisallowMagical)
      )
   {
      iMagical = TRUE;
      sItem = egs_GetRandomItem(iMainCategory, iSubCategory, iBaseItem, iLevel, iMaxWeaponSize, TRUE);
   }
   else
   {
      sItem = egs_GetRandomItem(iMainCategory, iSubCategory, iBaseItem, iLevel, iMaxWeaponSize);
   }

   object oItem = CreateItemOnObject(sItem, oTarget);
   if (GetIsObjectValid(oItem))
   {
      //SendMessageToAllDMs("Loot Item created");
      SetDroppableFlag(oItem, TRUE);
      SetIdentified(oItem, TRUE);
      if (iMagical)
      {
         int iIdentified = FALSE;
         if (d100(1) <= CI_LGS_CHANCE_LOOT_IDENTIFIED)
            iIdentified = TRUE;
         ip_InfuseItemWithMagic(oItem, iLevel, FALSE, iIdentified, TRUE, FALSE, -1, iOverrideMaxMagicLevel);
      }
      if (iInventorySlot != -1)
         DelayCommand(3.0, AssignCommand(oTarget, ActionEquipItem(oItem, iInventorySlot)));
   }
   else
   {
   //   SendMessageToAllDMs("Error creating loot item");
   }
   return (oItem);
}

void lgs_AdditionalChance(object oItem, int iLevel, int nProperty, int nPolicy = X2_IP_ADDPROP_POLICY_KEEP_EXISTING)
{
   if (CI_LGS_DROPEQUIPMENT ||
       oItem == OBJECT_INVALID)
      return;

   struct STRUCT_IP_PropertyDetails strIP;

   int iChance = (iLevel * iLevel) / 10; // Level 10 -> 10%, Level 15 -> 22,5%, Level 20 -> 40%, Level 25 -> 62,5%, Level 30 -> 90%
   int iRandom = Random(100) + 1;
   iLevel -= Random(3);
   if (iLevel < 1)
      iLevel = 1;

   if (iRandom < iChance)
   {
      strIP = ip_GetProperty(-1, -1, -1, iLevel, CI_IP_TYPE_POSITIVE, -1, nProperty);
      IPSafeAddItemProperty(oItem, strIP.IP, 0.0f, nPolicy);
   }
}

object lgs_CreateRingOfXtraDifficulty(object oTarget, int iLevel)
{
   string sItem = egs_GetRandomItem(CI_EGS_ITEM_MAIN_MONSTERRING, -1, -1, iLevel);
   object oItem = CreateItemOnObject(sItem, oTarget);
   if (GetIsObjectValid(oItem))
   {
      SetDroppableFlag(oItem, FALSE);
      SetIdentified(oItem, FALSE);

      // Find out the number of additional properties, on top of the
      // standard properties for this difficulty level if the monster is level 5
      // or higher
      if (iLevel > 4)
      {
         int iNumberOfProps = (iLevel / 8) + 1;
         ip_InfuseItemWithMagic(oItem, iLevel, TRUE, TRUE, FALSE, TRUE, iNumberOfProps);
      }

      AssignCommand(oTarget, ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTRING));
   }
   return oItem;
}

object lgs_CreateArmorBody(object oTarget, int iLevel)
{
   int iRandom;
   if (GetHasFeat(FEAT_ARMOR_PROFICIENCY_HEAVY, oTarget))
      iRandom = Random(2) + 2;
   else if (GetHasFeat(FEAT_ARMOR_PROFICIENCY_MEDIUM, oTarget))
      iRandom = Random(2) + 1;
   else if (GetHasFeat(FEAT_ARMOR_PROFICIENCY_LIGHT, oTarget))
      iRandom = Random(2);
   else
      iRandom = 0;

   object oItem;
   switch (iRandom)
   {
      case 0: oItem = lgs_CreateEquipmentOnTarget(-1, CI_EGS_ITEM_SUB_ARMOR_BODY_CLOTHING, -1, oTarget, INVENTORY_SLOT_CHEST, iLevel);
         break;
      case 1: oItem = lgs_CreateEquipmentOnTarget(-1, CI_EGS_ITEM_SUB_ARMOR_BODY_LIGHT, -1, oTarget, INVENTORY_SLOT_CHEST, iLevel);
         break;
      case 2: oItem = lgs_CreateEquipmentOnTarget(-1, CI_EGS_ITEM_SUB_ARMOR_BODY_MEDIUM, -1, oTarget, INVENTORY_SLOT_CHEST, iLevel);
         break;
      case 3: oItem = lgs_CreateEquipmentOnTarget(-1, CI_EGS_ITEM_SUB_ARMOR_BODY_HEAVY, -1, oTarget, INVENTORY_SLOT_CHEST, iLevel);
         break;
   }

   // We want a good chance of AC Bonus and Damage Reduction on higher levels if we are not set to drop equipment
   lgs_AdditionalChance(oItem, iLevel, CI_IP_DamageReduction);

   return oItem;
}

object lgs_CreateHelmet(object oTarget, int iLevel)
{
   return lgs_CreateEquipmentOnTarget(-1, CI_EGS_ITEM_SUB_ARMOR_HELMET, -1, oTarget, INVENTORY_SLOT_HEAD, iLevel);
}

object lgs_CreateWeaponMelee(object oTarget, int iLevel, int iSlot = INVENTORY_SLOT_RIGHTHAND, int iMaxWeaponSize = -1)
{
   object oItem = lgs_CreateEquipmentOnTarget(-1, CI_EGS_ITEM_SUB_WEAPON_MELEE, -1, oTarget, iSlot, iLevel, iMaxWeaponSize);

   // We need a good chance of getting an Enhancement Bonus at higher levels
   lgs_AdditionalChance(oItem, iLevel, CI_IP_EnhancementBonus);

   return oItem;
}

object lgs_CreateShield(object oTarget, int iLevel, int iMaxWeaponSize = -1)
{
   return lgs_CreateEquipmentOnTarget(-1, CI_EGS_ITEM_SUB_ARMOR_SHIELD, -1, oTarget, INVENTORY_SLOT_LEFTHAND, iLevel, iMaxWeaponSize);
}

object lgs_CreateArrows(object oTarget, int iLevel)
{
   object oAmmo = lgs_CreateEquipmentOnTarget(-1, -1, BASE_ITEM_ARROW, oTarget, -1, iLevel);
   SetItemStackSize(oAmmo, Random(50) + 40);
   return oAmmo;
}

object lgs_CreateBolts(object oTarget, int iLevel)
{
   object oAmmo = lgs_CreateEquipmentOnTarget(-1, -1, BASE_ITEM_BOLT, oTarget, -1, iLevel);
   SetItemStackSize(oAmmo, Random(50) + 40);
   return oAmmo;
}

object lgs_CreateBullets(object oTarget, int iLevel)
{
   object oAmmo = lgs_CreateEquipmentOnTarget(-1, -1, BASE_ITEM_BULLET, oTarget, -1, iLevel);
   SetItemStackSize(oAmmo, Random(50) + 40);
   return oAmmo;
}

object lgs_CreateWeaponRanged(object oTarget, int iLevel, int iSlot = INVENTORY_SLOT_RIGHTHAND, int iMaxWeaponSize = -1)
{
   int iRandom;
   if (iMaxWeaponSize == -1)
      iRandom = Random(5);
   else if (iMaxWeaponSize < CI_EGS_WEAPONSIZE_MEDIUM)
      iRandom = 0;
   else if (iMaxWeaponSize < CI_EGS_WEAPONSIZE_LARGE)
      iRandom = Random(3);
   else
      iRandom = Random(5);

   int iAmmoCount = Random(3) + 1 + FloatToInt(IntToFloat(iLevel) / 8);
   int iCount;
   object oItem;
   switch (iRandom)
   {
      case 0:
         oItem = lgs_CreateEquipmentOnTarget(-1, -1, BASE_ITEM_SLING, oTarget, iSlot, iLevel);
         for (iCount = 0; iCount < iAmmoCount; iCount++)
            lgs_CreateBullets(oTarget, iLevel);
         break;
      case 1:
         oItem = lgs_CreateEquipmentOnTarget(-1, -1, BASE_ITEM_LIGHTCROSSBOW, oTarget, iSlot, iLevel);
         for (iCount = 0; iCount < iAmmoCount; iCount++)
            lgs_CreateBolts(oTarget, iLevel);
         break;
      case 2:
         oItem = lgs_CreateEquipmentOnTarget(-1, -1, BASE_ITEM_SHORTBOW, oTarget, iSlot, iLevel);
         for (iCount = 0; iCount < iAmmoCount; iCount++)
            lgs_CreateArrows(oTarget, iLevel);
         break;
      case 3:
         oItem = lgs_CreateEquipmentOnTarget(-1, -1, BASE_ITEM_HEAVYCROSSBOW, oTarget, iSlot, iLevel);
         for (iCount = 0; iCount < iAmmoCount; iCount++)
            lgs_CreateBolts(oTarget, iLevel);
         break;
      case 4:
         oItem = lgs_CreateEquipmentOnTarget(-1, -1, BASE_ITEM_LONGBOW, oTarget, iSlot, iLevel);
         for (iCount = 0; iCount < iAmmoCount; iCount++)
            lgs_CreateArrows(oTarget, iLevel);
         break;
   }

   // We need a good chance of getting an attack bonus on ranged weapons on higher levels
   lgs_AdditionalChance(oItem, iLevel, CI_IP_AttackBonus);

   return oItem;
}

object lgs_CreateWeaponThrown(object oTarget, int iLevel, int iMaxWeaponSize = -1)
{
   object oThrown;
   int iStacks = Random(3) + 1;
   int iCount;

   // Create the stack used
   oThrown = lgs_CreateEquipmentOnTarget(-1, CI_EGS_ITEM_SUB_WEAPON_THROWN, -1, oTarget, INVENTORY_SLOT_RIGHTHAND, iLevel, iMaxWeaponSize);
   SetItemStackSize(oThrown, Random(30) + 20);

   // We need a good chance of an enhancement bonus on thrown weapons on higher levels
   lgs_AdditionalChance(oThrown, iLevel, CI_IP_EnhancementBonus);

   return oThrown;
}

object lgs_CreateAmulet(object oTarget, int iLevel)
{
   return lgs_CreateEquipmentOnTarget(-1, -1, BASE_ITEM_AMULET, oTarget, INVENTORY_SLOT_NECK, iLevel);
}

object lgs_CreateRing(object oTarget, int iLevel)
{
   return lgs_CreateEquipmentOnTarget(-1, -1, BASE_ITEM_RING, oTarget, INVENTORY_SLOT_LEFTRING, iLevel);
}

object lgs_CreateBelt(object oTarget, int iLevel)
{
   return lgs_CreateEquipmentOnTarget(-1, -1, BASE_ITEM_BELT, oTarget, INVENTORY_SLOT_BELT, iLevel);
}

object lgs_CreateGlovesOrBracers(object oTarget, int iLevel)
{
   return lgs_CreateEquipmentOnTarget(-1, -1, BASE_ITEM_GLOVES, oTarget, INVENTORY_SLOT_ARMS, iLevel);
}

object lgs_CreateCloak(object oTarget, int iLevel)
{
   return lgs_CreateEquipmentOnTarget(-1, -1, BASE_ITEM_CLOAK, oTarget, INVENTORY_SLOT_CLOAK, iLevel);
}

object lgs_CreateBoots(object oTarget, int iLevel)
{
   return lgs_CreateEquipmentOnTarget(-1, -1, BASE_ITEM_BOOTS, oTarget, INVENTORY_SLOT_BOOTS, iLevel);
}

float lgs_GetChallengeRating(object oCreature)
{
   return GetChallengeRating(oCreature);
}

void lgs_EquipMonster(object oMonster, int iAddedDropChances = 0)
{
   // Check if our oMonster is valid or set to not be equipped
   if (!GetIsObjectValid(oMonster) ||
       GetLocalInt(oMonster, CS_LGS_EQUIP_DISABLE) == 1)
   {
    //  SendMessageToAllDMs("Monster to be equipped is invalid!");
      return;
   }

   // Get the Difficulty of our Monster
   string sMonsterResRef = GetResRef(oMonster);

   int iDifficulty = FloatToInt (lgs_GetChallengeRating (oMonster));

   // Get the Size of our Monster
   int iSize = GetCreatureSize(oMonster);

   int iChance;

   // Create a Ring of Xtra Difficulty for our monster
   lgs_CreateRingOfXtraDifficulty(oMonster, iDifficulty);

   // Body Armor
   iChance = d100();
   if (iChance < (iDifficulty * CI_LGS_CHANCE_BODYARMOR) + (CI_LGS_CHANCE_BODYARMOR * 20))
      lgs_CreateArmorBody(oMonster, iDifficulty);

   // Helmet
   iChance = d100();
   if (iChance < (iDifficulty * CI_LGS_CHANCE_HELMET) + (CI_LGS_CHANCE_HELMET * 20))
      lgs_CreateHelmet(oMonster, iDifficulty);


   // Force Ranged Fighting Style for Archer Types
   int iFightingStyle;
   // Determine if this monster is:
   // .) Going for Weapon + Shield  - 45%
   // .) One/Two-Handed Fighting    - 45%
   // .) Ranged Fighting            - 10%
   iFightingStyle = d100();
   if (iFightingStyle <= 45)
      iFightingStyle = 0;
   else if (iFightingStyle <= 90)
      iFightingStyle = 1;
   else
      iFightingStyle = 2;

   int nDualWield = 0;

   switch(iFightingStyle)
   {
      // Weapon + Shield
      case 0: iChance = d100();
         if (iChance < (iDifficulty * CI_LGS_CHANCE_WEAPON) + (CI_LGS_CHANCE_WEAPON * 20))
         {
            lgs_CreateWeaponMelee(oMonster, iDifficulty, INVENTORY_SLOT_RIGHTHAND, iSize);

            iChance = d100();
            if (iChance < (iDifficulty * CI_LGS_CHANCE_SHIELD) + (CI_LGS_CHANCE_SHIELD * 20))
            {
               lgs_CreateShield(oMonster, iDifficulty, iSize);
            }

            // Create a Ranged Reserve just in case it could be needed ;)
            if (iChance < (iDifficulty * CI_LGS_CHANCE_RANGEDRESERVE) + (CI_LGS_CHANCE_RANGEDRESERVE * 20))
            {
               lgs_CreateWeaponRanged(oMonster, iDifficulty, -1);
            }
         }
         break;
      // One-Handed / Two-Handed
      case 1: iChance = d100();
         if (iChance < (iDifficulty * CI_LGS_CHANCE_WEAPON) + (CI_LGS_CHANCE_WEAPON * 20))
         {
            iChance = d100();
            if (GetHasFeat(FEAT_AMBIDEXTERITY, oMonster))
                nDualWield += 10;
            if (GetHasFeat(FEAT_TWO_WEAPON_FIGHTING, oMonster))
                nDualWield += 20;
            if (GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING, oMonster))
                nDualWield += 40;

            if (iChance < CI_LGS_CHANCE_DUALWIELD + nDualWield)
            {
               lgs_CreateWeaponMelee(oMonster, iDifficulty, INVENTORY_SLOT_RIGHTHAND, iSize);
               lgs_CreateWeaponMelee(oMonster, iDifficulty, INVENTORY_SLOT_LEFTHAND, iSize);
            }
            else
            {
               lgs_CreateWeaponMelee(oMonster, iDifficulty, INVENTORY_SLOT_RIGHTHAND, iSize + 1);
            }
         }
         break;
      // Ranged / Thrown
      case 2: int iRangedOrThrown = Random(2);
         switch (iRangedOrThrown)
         {
            // Ranged
            case 0: iChance = d100();
               if (iChance < (iDifficulty * CI_LGS_CHANCE_WEAPON) + (CI_LGS_CHANCE_WEAPON * 20))
               {
                  lgs_CreateWeaponRanged(oMonster, iDifficulty);
               }
            break;
            // Thrown
            case 1: iChance = d100();
               if (iChance < (iDifficulty * CI_LGS_CHANCE_WEAPON) + (CI_LGS_CHANCE_WEAPON * 20))
               {
                  lgs_CreateWeaponThrown(oMonster, iDifficulty, iSize);
               }
               // Doods with Thrown Weapons should have at least a reserve melee weapon
               // This weapon should be of size Tiny or Small
               lgs_CreateWeaponMelee(oMonster, iDifficulty, INVENTORY_SLOT_RIGHTHAND, CI_EGS_WEAPONSIZE_SMALL);
            break;
         }
         break;
   }

   // Amulet
   iChance = d100();
   if (iChance < (iDifficulty * CI_LGS_CHANCE_AMULET) + (CI_LGS_CHANCE_AMULET * 20))
      lgs_CreateAmulet(oMonster, iDifficulty);

   // Ring
   iChance = d100();
   if (iChance < (iDifficulty * CI_LGS_CHANCE_RING) + (CI_LGS_CHANCE_RING * 20))
      lgs_CreateRing(oMonster, iDifficulty);

   // Belt
   iChance = d100();
   if (iChance < (iDifficulty * CI_LGS_CHANCE_BELT) + (CI_LGS_CHANCE_BELT * 20))
      lgs_CreateBelt(oMonster, iDifficulty);

   // Gloves or Bracers
   iChance = d100();
   if (iChance < (iDifficulty * CI_LGS_CHANCE_BRACERS_OR_GLOVES) + (CI_LGS_CHANCE_BRACERS_OR_GLOVES * 20))
      lgs_CreateGlovesOrBracers(oMonster, iDifficulty);

   // Cloak
   iChance = d100();
   if (iChance < (iDifficulty * CI_LGS_CHANCE_CLOAK) + (CI_LGS_CHANCE_CLOAK * 20))
      lgs_CreateCloak(oMonster, iDifficulty);

   // Boots
   iChance = d100();
   if (iChance < (iDifficulty * CI_LGS_CHANCE_BOOTS) + (CI_LGS_CHANCE_BOOTS * 20))
      lgs_CreateBoots(oMonster, iDifficulty);
}

int lgs_DropOnSelf(object oItem)
{
    string sTag = GetTag(oItem);
    string sTag_Wild_One = GetStringLeft(sTag, GetStringLength(sTag) - 1) + "*";
    string sTag_Wild_Two = GetStringLeft(sTag, GetStringLength(sTag) - 2) + "*";
    string sTag_Wild_Three = GetStringLeft(sTag, GetStringLength(sTag) - 3) + "*";
    if (GetLocalInt(oItem, CS_LGS_VAR_DROPONSELF) == 1 ||
        FindSubString(CS_LGS_DROPONSELF_TAGS, sTag) >= 0 ||
        FindSubString(CS_LGS_DROPONSELF_TAGS_WILD, sTag_Wild_One) >= 0 ||
        FindSubString(CS_LGS_DROPONSELF_TAGS_WILD, sTag_Wild_Two) >= 0 ||
        FindSubString(CS_LGS_DROPONSELF_TAGS_WILD, sTag_Wild_Three) >= 0)
        return TRUE;

    return FALSE;
}

void lgs_GetFixedLoot(object oMonster, object oLootContainer, object oLootContainer_Self, object oContainer_FixedLoot)
{
   // Find out the number of items to be dropped by checking for a local override variable or
   // using the default setting.
   int nLootCount = GetLocalInt(oMonster, "FixedLoot_Count");
   if (nLootCount == 0)
      nLootCount = CS_LGS_FIXEDLOOT_COUNT_DEFAULT;

   // Add a random number of loot
   if (CS_LGS_FIXEDLOOT_COUNT_RANDOM != 0)
   {
      int nRandom = Random(2);
      if (nRandom == 0)
      {
         nLootCount += Random(CS_LGS_FIXEDLOOT_COUNT_RANDOM + 1);
      }
      else if (nRandom == 1)
      {
         nLootCount -= Random(CS_LGS_FIXEDLOOT_COUNT_RANDOM + 1);
      }
   }

   // Count the number of items in this monster's loot container
   object oLoot;
   int nWeight;
   int nth;
   if (!eas_Array_Exists(oContainer_FixedLoot, CS_LGS_FIXEDLOOT_ARRAY))
   {
      eas_Array_Create(oContainer_FixedLoot, CS_LGS_FIXEDLOOT_ARRAY, EAS_ARRAY_TYPE_OBJECT);
      oLoot = GetFirstItemInInventory(oContainer_FixedLoot);
      while (GetIsObjectValid(oLoot))
      {
         // Retrieve the weight of this item
         nWeight = GetLocalInt(oLoot, CS_LGS_FIXEDLOOT_WEIGHT);
         if (nWeight == 0)
            nWeight = 1;

         for (nth = 1; nth <= nWeight; nth++)
            eas_OArray_Entry_Add(oContainer_FixedLoot, CS_LGS_FIXEDLOOT_ARRAY, oLoot);

         oLoot = GetNextItemInInventory(oContainer_FixedLoot);
      }
   }

   // Create loot and name it purple
   object oCopy;
   int n;
   for (n = 1; n <= nLootCount; n++)
   {
      oLoot = eas_OArray_Entry_Get(oContainer_FixedLoot, CS_LGS_FIXEDLOOT_ARRAY, Random(eas_Array_GetSize(oContainer_FixedLoot, CS_LGS_FIXEDLOOT_ARRAY)));
      if (GetIsObjectValid(oLootContainer_Self) &&
          lgs_DropOnSelf(oLoot))
         oCopy = CopyItem(oLoot, oLootContainer_Self, TRUE);
      else
         oCopy = CopyItem(oLoot, oLootContainer, TRUE);

      int nRarity = GetLocalInt(oCopy, "Rarity");
      string sColor;
      switch (nRarity)
      {
         case 1: sColor = COLOR_PREDEFINED_ITEM_COMMON; break;
         case 2: sColor = COLOR_PREDEFINED_ITEM_UNCOMMON; break;
         case 3: sColor = COLOR_PREDEFINED_ITEM_RARE; break;
         case 4: sColor = COLOR_PREDEFINED_ITEM_EPIC; break;
         case 5: sColor = COLOR_PREDEFINED_ITEM_LEGENDARY; break;
         default: sColor = COLOR_PREDEFINED_ITEM_RARE; break;
      }
      SetName(oCopy, color_ConvertString(GetName(oCopy), sColor));
   }
}

void lgs_MoveEquipment(object oItem, object oLootContainer, object oLootContainer_Self)
{
    // Some items aren't allowed to be transferred and have to be deleted instantly
    if(FindSubString(GetTag(oItem),"NW_IT_CRE")>-1 ||
       GetName(oItem) == "PC Properties")
    {
        DestroyObject(oItem);
        return;
    }

    if (GetDroppableFlag(oItem))
    {
        // Copy the item to the loot container
        int nLGS_DropChance = GetLocalInt(oItem, CS_LGS_EQUIP_DROPCHANCE);
        if (nLGS_DropChance == 0 || d100(1) <= nLGS_DropChance)
        {
            if (GetIsObjectValid(oLootContainer_Self) &&
                lgs_DropOnSelf(oItem))
                CopyItem(oItem, oLootContainer_Self, TRUE);
            else
                CopyItem(oItem, oLootContainer, TRUE);
        }

        // Flag the original item undroppable
        SetDroppableFlag(oItem, FALSE);
    }
}

void lgs_CreateLoot(object oMonster, object oLootContainer = OBJECT_INVALID, object oLootContainer_Self = OBJECT_INVALID, int iFixedLootOnly = FALSE, int iNumberOfLootItems = -1)
{
   // Check if our oMonster is valid
   if (!GetIsObjectValid(oMonster))
   {
   //   SendMessageToAllDMs("Monster to create loot for is invalid!");
      return;
   }

   // If the monster is set to NoLoot, return
   if (GetLocalInt(oMonster, CS_LGS_LOOT_DISABLE) == 1)
      return;

   // If LootContainer isn't valid, the Monster will be the Loot Container
   if (!GetIsObjectValid(oLootContainer))
      oLootContainer = oMonster;

   // Move inventory items to the lootcontainer
   // if the monster is not the container
   if (oLootContainer != oMonster)
   {
        // Move equipped items
        lgs_MoveEquipment(GetItemInSlot(INVENTORY_SLOT_ARMS, oMonster), oLootContainer, oLootContainer_Self);
        lgs_MoveEquipment(GetItemInSlot(INVENTORY_SLOT_ARROWS, oMonster), oLootContainer, oLootContainer_Self);
        lgs_MoveEquipment(GetItemInSlot(INVENTORY_SLOT_BELT, oMonster), oLootContainer, oLootContainer_Self);
        lgs_MoveEquipment(GetItemInSlot(INVENTORY_SLOT_BOLTS, oMonster), oLootContainer, oLootContainer_Self);
        lgs_MoveEquipment(GetItemInSlot(INVENTORY_SLOT_BOOTS, oMonster), oLootContainer, oLootContainer_Self);
        lgs_MoveEquipment(GetItemInSlot(INVENTORY_SLOT_BULLETS, oMonster), oLootContainer, oLootContainer_Self);
        lgs_MoveEquipment(GetItemInSlot(INVENTORY_SLOT_CHEST, oMonster), oLootContainer, oLootContainer_Self);
        lgs_MoveEquipment(GetItemInSlot(INVENTORY_SLOT_CLOAK, oMonster), oLootContainer, oLootContainer_Self);
        lgs_MoveEquipment(GetItemInSlot(INVENTORY_SLOT_HEAD, oMonster), oLootContainer, oLootContainer_Self);
        lgs_MoveEquipment(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oMonster), oLootContainer, oLootContainer_Self);
        lgs_MoveEquipment(GetItemInSlot(INVENTORY_SLOT_LEFTRING, oMonster), oLootContainer, oLootContainer_Self);
        lgs_MoveEquipment(GetItemInSlot(INVENTORY_SLOT_NECK, oMonster), oLootContainer, oLootContainer_Self);
        lgs_MoveEquipment(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMonster), oLootContainer, oLootContainer_Self);
        lgs_MoveEquipment(GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oMonster), oLootContainer, oLootContainer_Self);

        object oInventoryItem = GetFirstItemInInventory(oMonster);
        while(GetIsObjectValid(oInventoryItem))
        {
            // Move it
            lgs_MoveEquipment(oInventoryItem, oLootContainer, oLootContainer_Self);

            oInventoryItem = GetNextItemInInventory(oMonster);
        }
   }

   // Get the Difficulty of our Monster
   int iDifficulty;
   int iSize;
   if (GetObjectType(oMonster) == OBJECT_TYPE_PLACEABLE)                // PLACEABLE
   {
      iDifficulty = GetLocalInt(oMonster, CS_LGS_PLACEABLE_CR);
      iSize = -1;   // Size doesn't matter ;)
   }
   else
   {
      string sMonsterResRef = GetResRef(oMonster);                      // MONSTER
      iDifficulty = FloatToInt (lgs_GetChallengeRating (oMonster));
      // Get the Size of our Monster
      iSize = GetCreatureSize(oMonster);
   }

   // Will it drop gold?
   int iChance = d100();
   if (iChance < CI_LGS_CHANCE_GOLD + iDifficulty)
   {
      int iGold = Random(2 * iDifficulty + iDifficulty * iDifficulty);
      //GiveGoldToCreature(oMonster, (iGold) + Random(iGold));
      CreateItemOnObject("nw_it_gold001", oLootContainer, iGold);
   }

   // Then, let's see if our Monster has fixed loot table, i.e. a loot container
   string sMonsterTag = GetTag(oMonster);
   object oWaypoint_FixedLoot = GetObjectByTag(CS_LGS_FIXEDLOOT_WAYPOINT);
   object oContainer_FixedLoot = GetNearestObjectByTag(sMonsterTag, oWaypoint_FixedLoot);

   if (GetIsObjectValid(oContainer_FixedLoot))
   {
      lgs_GetFixedLoot(oMonster, oLootContainer, oLootContainer_Self, oContainer_FixedLoot);
      return;
   }

   // If we are only to check for fixed loot, leave now
   if (iFixedLootOnly)
      return;


   if (iDifficulty < CI_LGS_CR_BOOST_UNTIL)
   {
      iDifficulty += CI_LGS_CR_BOOST_VALUE;
      if (iDifficulty > CI_LGS_CR_BOOST_UNTIL)
         iDifficulty = CI_LGS_CR_BOOST_UNTIL;
   }

   // First, we'll determine IF the monster will drop anything at all
   iChance = d100();
   //SendMessageToAllDMs("Loot Roll for [" + GetName(oMonster) + "]: " + IntToString(iChance));
   if (iChance > CI_LGS_CHANCE_LOOT &&
       iNumberOfLootItems == -1)
      return;

/*
   // we'll set a 15% chance of using Bioware Treasure instead of ours
   iChance = d100();
   if (iChance <= 15)
   {
      CTG_GenerateNPCTreasure(TREASURE_TYPE_MONSTER, oMonster);
      return;
   }
*/

   // Now, for our proprietary stuff...

   // Maybe our monster is set to use loot container that's not linked to it's tag
   string sContainer_CustomLoot = GetLocalString(oMonster, CS_LGS_VAR_CUSTOMLOOT_CHEST);
   if (sContainer_CustomLoot != "")
   {
      object oContainer_CustomLoot = GetNearestObjectByTag(sContainer_CustomLoot, oWaypoint_FixedLoot);
      if (GetIsObjectValid(oContainer_CustomLoot))
      {
         // Retrieve custom loot chance and set to default if not set on monster
         int nCustomLootChance = GetLocalInt(oMonster, CS_LGS_VAR_CUSTOMLOOT_CHANCE);
         if (nCustomLootChance == 0)
            nCustomLootChance = CI_LGS_VAR_CUSTOMLOOT_CHANCE_DEFAULT;

         // Roll for using the custom loot container
         int nCustomLootRoll = d100();
         if (nCustomLootRoll <= nCustomLootChance)
         {
            lgs_GetFixedLoot(oMonster, oLootContainer, oLootContainer_Self, oContainer_FixedLoot);
            return;
         }
      }
   }

   // For Random loot, first check how many items will be dropped
   if (iNumberOfLootItems == -1)
   {
      iNumberOfLootItems = 1;
      iChance = d100();
      if (iChance < CI_LGS_CHANCE_LOOT)
         iNumberOfLootItems++;
      iChance = d100();
      if (iChance < CI_LGS_CHANCE_LOOT / 2)
         iNumberOfLootItems++;
   }

   //SendMessageToAllDMs("Number of Items: " + IntToString(iNumberOfLootItems));

   // PAT Creatures use another MAX Magic level for Loot
   int iOverrideMaxMagicLevel = -1;
   if (GetLocalInt(oMonster, PAT_VAR_APPLIED) == 1)
      iOverrideMaxMagicLevel = PAT_IP_MAXMAGICLEVEL;

   int iCheck;
   int iCount;
   int iSubSelection;
   object oCreatedLoot;

   int iLootRandomizer = CI_LGS_LOOT_CLOTHING + CI_LGS_LOOT_ARMOR_LIGHT + CI_LGS_LOOT_ARMOR_MEDIUM +
                         CI_LGS_LOOT_ARMOR_HEAVY + CI_LGS_LOOT_SHIELD_SMALL + CI_LGS_LOOT_SHIELD_LARGE +
                         CI_LGS_LOOT_SHIELD_TOWER + CI_LGS_LOOT_HELMET + CI_LGS_LOOT_WEAPON_MELEE +
                         CI_LGS_LOOT_WEAPON_RANGED + CI_LGS_LOOT_WEAPON_THROWN + CI_LGS_LOOT_AMMO +
                         CI_LGS_LOOT_JEWELRY_RING + CI_LGS_LOOT_JEWELRY_AMULET + CI_LGS_LOOT_ACCESSORY_BRACERS +
                         CI_LGS_LOOT_ACCESSORY_GLOVES + CI_LGS_LOOT_ACCESSORY_BELT + CI_LGS_LOOT_ACCESSORY_CLOAK +
                         CI_LGS_LOOT_ACCESSORY_BOOTS + CI_LGS_LOOT_SCROLL + CI_LGS_LOOT_BOOK + CI_LGS_LOOT_POTION +
                         CI_LGS_LOOT_WAND + CI_LGS_LOOT_MEDKIT + CI_LGS_LOOT_TRAPKIT + CI_LGS_LOOT_THIEVESTOOLS +
                         CI_LGS_LOOT_CONTAINER + CI_LGS_LOOT_MISC + CI_LGS_LOOT_BOMB + CI_LGS_LOOT_FOOD;

   for (iCount = 0; iCount < iNumberOfLootItems; iCount++)
   {
      iChance = Random(iLootRandomizer);

      // Clothing
      iCheck = CI_LGS_LOOT_CLOTHING;
      if (CI_LGS_LOOT_CLOTHING != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(-1, CI_EGS_ITEM_SUB_ARMOR_BODY_CLOTHING, -1, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel);
            continue;
      }
      // Light Armor
      iCheck += CI_LGS_LOOT_ARMOR_LIGHT;
      if (CI_LGS_LOOT_ARMOR_LIGHT != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(-1, CI_EGS_ITEM_SUB_ARMOR_BODY_LIGHT, -1, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel);
            continue;
      }
      // Medium Armor
      iCheck += CI_LGS_LOOT_ARMOR_MEDIUM;
      if (CI_LGS_LOOT_ARMOR_MEDIUM != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(-1, CI_EGS_ITEM_SUB_ARMOR_BODY_MEDIUM, -1, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel);
            continue;
      }
      // Heavy Armor
      iCheck += CI_LGS_LOOT_ARMOR_HEAVY;
      if (CI_LGS_LOOT_ARMOR_HEAVY != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(-1, CI_EGS_ITEM_SUB_ARMOR_BODY_HEAVY, -1, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel);
            continue;
      }
      // Small Shield
      iCheck += CI_LGS_LOOT_SHIELD_SMALL;
      if (CI_LGS_LOOT_SHIELD_SMALL != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(-1, -1, BASE_ITEM_SMALLSHIELD, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel);
            continue;
      }
      // Large Shield
      iCheck += CI_LGS_LOOT_SHIELD_LARGE;
      if (CI_LGS_LOOT_SHIELD_LARGE != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(-1, -1, BASE_ITEM_LARGESHIELD, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel);
            continue;
      }
      // Tower Shield
      iCheck += CI_LGS_LOOT_SHIELD_TOWER;
      if (CI_LGS_LOOT_SHIELD_TOWER != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(-1, -1, BASE_ITEM_TOWERSHIELD, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel);
            continue;
      }
      // Helmet
      iCheck += CI_LGS_LOOT_HELMET;
      if (CI_LGS_LOOT_HELMET != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(-1, CI_EGS_ITEM_SUB_ARMOR_HELMET, -1, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel);
            continue;
      }
      // Weapon Melee
      iCheck += CI_LGS_LOOT_WEAPON_MELEE;
      if (CI_LGS_LOOT_WEAPON_MELEE != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(-1, CI_EGS_ITEM_SUB_WEAPON_MELEE, -1, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel, FALSE, FALSE, iSize);
            continue;
      }
      // Weapon Ranged
      iCheck += CI_LGS_LOOT_WEAPON_RANGED;
      if (CI_LGS_LOOT_WEAPON_RANGED != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(-1, CI_EGS_ITEM_SUB_WEAPON_RANGED, -1, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel, FALSE, FALSE, iSize);
            continue;
      }
      // Weapon Thrown
      iCheck += CI_LGS_LOOT_WEAPON_THROWN;
      if (CI_LGS_LOOT_WEAPON_THROWN != 0 && iChance <= iCheck)
      {
            oCreatedLoot = lgs_CreateItemOnTarget(-1, CI_EGS_ITEM_SUB_WEAPON_THROWN, -1, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel, FALSE, FALSE, iSize);
            SetItemStackSize(oCreatedLoot, Random(30) + 15);
            continue;
      }
      // Ammunition
      iCheck += CI_LGS_LOOT_AMMO;
      if (CI_LGS_LOOT_AMMO != 0 && iChance <= iCheck)
      {
            oCreatedLoot = lgs_CreateItemOnTarget(CI_EGS_ITEM_MAIN_AMMO, -1, -1, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel);
            SetItemStackSize(oCreatedLoot, Random(50) + 30);
            continue;
      }
      // Ring
      iCheck += CI_LGS_LOOT_JEWELRY_RING;
      if (CI_LGS_LOOT_JEWELRY_RING != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(-1, -1, BASE_ITEM_RING, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel);
            continue;
      }
      // Amulet
      iCheck += CI_LGS_LOOT_JEWELRY_AMULET;
      if (CI_LGS_LOOT_JEWELRY_AMULET != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(-1, -1, BASE_ITEM_AMULET, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel);
            continue;
      }
      // Bracers
      iCheck += CI_LGS_LOOT_ACCESSORY_BRACERS;
      if (CI_LGS_LOOT_ACCESSORY_BRACERS != 0 && iChance <= iCheck)
      {
            iSubSelection = Random(2);
            switch (iSubSelection)
            {
                case 0: lgs_CreateItemOnTarget(-1, -1, BASE_ITEM_BRACER, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel); break;
                case 1: lgs_CreateItemOnTarget(-1, -1, BASE_ITEM_BRACER_SHIELD, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel); break;
            }
            continue;
      }
      // Gloves
      iCheck += CI_LGS_LOOT_ACCESSORY_GLOVES;
      if (CI_LGS_LOOT_ACCESSORY_GLOVES != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(-1, -1, BASE_ITEM_GLOVES, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel);
            continue;
      }
      // Belt
      iCheck += CI_LGS_LOOT_ACCESSORY_BELT;
      if (CI_LGS_LOOT_ACCESSORY_BELT != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(-1, -1, BASE_ITEM_BELT, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel);
            continue;
      }
      // Cloak
      iCheck += CI_LGS_LOOT_ACCESSORY_CLOAK;
      if (CI_LGS_LOOT_ACCESSORY_CLOAK != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(-1, -1, BASE_ITEM_CLOAK, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel);
            continue;
      }
      // Boots
      iCheck += CI_LGS_LOOT_ACCESSORY_BOOTS;
      if (CI_LGS_LOOT_ACCESSORY_BOOTS != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(-1, -1, BASE_ITEM_BOOTS, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel);
            continue;
      }
      // Scroll
      iCheck += CI_LGS_LOOT_SCROLL;
      if (CI_LGS_LOOT_SCROLL != 0 && iChance <= iCheck)
      {
         int iScrollLevel = (iDifficulty / 2) - 1;
         if (iScrollLevel > 9)
         {
            iScrollLevel = 9;
         }
         else if (iScrollLevel < 0)
         {
            iScrollLevel = 0;
         }

         object oScroll = CreateItemOnObject(ip_GetRandomScroll(iScrollLevel), oLootContainer);
         SetDroppableFlag(oScroll, TRUE);

         int iIdentified = FALSE;
         if (d100(1) <= CI_LGS_CHANCE_LOOT_IDENTIFIED)
            iIdentified = TRUE;

         SetIdentified(oScroll, iIdentified);
         continue;
      }
      // Book
      iCheck += CI_LGS_LOOT_BOOK;
      if (CI_LGS_LOOT_BOOK != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(-1, -1, BASE_ITEM_BOOK, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel, TRUE);
            continue;
      }
      // Potion
      iCheck += CI_LGS_LOOT_POTION;
      if (CI_LGS_LOOT_POTION != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(-1, -1, BASE_ITEM_POTIONS, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel, TRUE);
            continue;
      }
      // Wand
      iCheck += CI_LGS_LOOT_WAND;
      if (CI_LGS_LOOT_WAND != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(CI_EGS_ITEM_MAIN_RODWAND, -1, -1, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel, TRUE);
            continue;
      }
      // Medkit
      iCheck += CI_LGS_LOOT_MEDKIT;
      if (CI_LGS_LOOT_MEDKIT != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(-1, -1, BASE_ITEM_HEALERSKIT, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel, TRUE);
            continue;
      }
      // Trapkit
      iCheck += CI_LGS_LOOT_TRAPKIT;
      if (CI_LGS_LOOT_TRAPKIT != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(-1, -1, BASE_ITEM_TRAPKIT, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel, TRUE);
            continue;
      }
      // Thieve's Tools
      iCheck += CI_LGS_LOOT_THIEVESTOOLS;
      if (CI_LGS_LOOT_THIEVESTOOLS != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(-1, -1, BASE_ITEM_THIEVESTOOLS, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel, TRUE);
            continue;
      }
      // Container
      iCheck += CI_LGS_LOOT_CONTAINER;
      if (CI_LGS_LOOT_CONTAINER != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(CI_EGS_ITEM_MAIN_CONTAINER, -1, -1, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel);
            continue;
      }
      // Misc
      iCheck += CI_LGS_LOOT_MISC;
      if (CI_LGS_LOOT_MISC != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(CI_EGS_ITEM_MAIN_MISC, -1, -1, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel, FALSE, TRUE);
            continue;
      }
      // Bomb
      iCheck += CI_LGS_LOOT_BOMB;
      if (CI_LGS_LOOT_BOMB != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(CI_EGS_ITEM_MAIN_BOMB, -1, -1, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel, FALSE, TRUE);
            continue;
      }
      // Food
      iCheck += CI_LGS_LOOT_FOOD;
      if (CI_LGS_LOOT_FOOD != 0 && iChance <= iCheck)
      {
            lgs_CreateItemOnTarget(CI_EGS_ITEM_MAIN_FOOD, -1, -1, oLootContainer, -1, iDifficulty, iOverrideMaxMagicLevel, FALSE, TRUE);
            continue;
      }
   }
}
