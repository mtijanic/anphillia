///////////////////////////////////////////////////////////////////////////////
// ip_ini
// written by: eyesolated
// written at: June 17, 2004
//
// Notes: IP Initialization

///////////
// Includes
//
#include "eas_inc"
#include "color_inc"
#include "egs_inc"
#include "ip_inc"

void ip_AutoPropertyPlus(int iProperty, int iType, string sCategoriesMain, string sCategoriesSub, string sBaseItems, int iVarOne, int iVarTwo, int iVarThree, int iMagicLevelFrom, int iJumpValue, int iEndLevel, int iMonsterOnly = FALSE, int iIncreaseBy = 1);

////////////////
// Function Code
//
void ip_AutoPropertyPlus_Delayed(int iProperty, int iType, string sCategoriesMain, string sCategoriesSub, string sBaseItems, int iVarOne, int iVarTwo, int iVarThree, int iMagicLevelFrom, int iJumpValue, int iEndLevel, int iMonsterOnly = FALSE, int iIncreaseBy = 1)
{
    int iCount;
    int iJumpCount = 0;
    if (CI_IP_USE_NWNX)
    {
        for (iCount = iMagicLevelFrom; iCount < iEndLevel + 1; iCount++)
        {
            ip_AddProperty(iProperty, iType, sCategoriesMain, sCategoriesSub, sBaseItems, iCount, iVarOne, iVarTwo, iVarThree, iMonsterOnly);
            iJumpCount++;
            if (iJumpCount == iJumpValue)
            {
                iJumpCount = 0;
                iVarOne += iIncreaseBy;
            }
        }
    }
    else
    {
        object oMod = GetModule();
        object oStorePreload = GetLocalObject(oMod, CS_IP_DB_PRELOAD_STORE_OBJ);
        string sID;
        for (iCount = iMagicLevelFrom; iCount < iEndLevel + 1; iCount++)
        {
            //s_ip_AddProperty(iProperty, iType, sCategoriesMain, sCategoriesSub, sBaseItems, iCount, iVarOne, iVarTwo, iVarThree, iMonsterOnly);
            sID = IntToString(eas_SArray_Entry_Add(oStorePreload, CS_IP_DB_PRELOAD_ARRAY, "DelayedProp"));

            SetLocalInt(oStorePreload, CS_IP_ID + sID, iProperty);
            SetLocalInt(oStorePreload, CS_IP_TYPE + sID, iType);
            SetLocalString(oStorePreload, CS_IP_CATEGORIES_MAIN + sID, sCategoriesMain);
            SetLocalString(oStorePreload, CS_IP_CATEGORIES_SUB + sID, sCategoriesSub);
            SetLocalString(oStorePreload, CS_IP_BASEITEMS + sID, sBaseItems);
            SetLocalInt(oStorePreload, CS_IP_LEVEL + sID, iCount);
            SetLocalInt(oStorePreload, CS_IP_VARONE + sID, iVarOne);
            SetLocalInt(oStorePreload, CS_IP_VARTWO + sID, iVarTwo);
            SetLocalInt(oStorePreload, CS_IP_VARTHREE + sID, iVarThree);
            SetLocalInt(oStorePreload, CS_IP_MONSTERONLY + sID, iMonsterOnly);

            iJumpCount++;
            if (iJumpCount == iJumpValue)
            {
                iJumpCount = 0;
                iVarOne += iIncreaseBy;
            }
        }
    }
}

void ip_AutoPropertyPlus(int iProperty, int iType, string sCategoriesMain, string sCategoriesSub, string sBaseItems, int iVarOne, int iVarTwo, int iVarThree, int iMagicLevelFrom, int iJumpValue, int iEndLevel, int iMonsterOnly = FALSE, int iIncreaseBy = 1)
{
    // This method delays the actual call to ip_AutoPropertyPlus to remove the Instruction Limit problems
    DelayCommand(0.1, ip_AutoPropertyPlus_Delayed(iProperty, iType, sCategoriesMain, sCategoriesSub, sBaseItems, iVarOne, iVarTwo, iVarThree, iMagicLevelFrom, iJumpValue, iEndLevel, iMonsterOnly, iIncreaseBy));
}

void InitAll()
{
   object oMod = GetModule();
   string sCategoriesMain;
   string sCategoriesSub;
   string sBaseItems;
   int iMonsterOnly;

   // Let's setup our properties
      // Create the Table

      if (!CI_IP_USE_NWNX)
      {
        // If we're not using NWNx, we need to reduce the script calls
        object oStorePreload = CreateObject(OBJECT_TYPE_STORE, CS_IP_DB_MERCHANT_RESREF, GetLocation(GetObjectByTag(CS_IP_DB_WAYPOINT)), FALSE, CS_IP_DB_PRELOAD_STORE);
        eas_Array_Create(oStorePreload, CS_IP_DB_PRELOAD_ARRAY, EAS_ARRAY_TYPE_STRING);

        SetLocalObject(oMod, CS_IP_DB_PRELOAD_STORE_OBJ, GetObjectByTag(CS_IP_DB_PRELOAD_STORE));
      }

      // Random Ability Bonus , applicable to Armor, Accessories, Melee and Ranged Weapons
      // Starting on Level 7, then every 4th level
      // From Level 27 every 3rd Level
      // At Level 45 highest value is reached and continued to level 50
      if (CI_IP_RESTRICT_AbilityBonus)
      {
        sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON_CREATURE) + ";";
        sCategoriesSub = "";
        sBaseItems = ";" + IntToString(BASE_ITEM_BELT) + ";" + IntToString(BASE_ITEM_GLOVES) + ";" + IntToString(BASE_ITEM_CLOAK) + ";";
      }
      else
      {
        sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_MONSTERRING) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR) + ";" + IntToString(CI_EGS_ITEM_MAIN_ACCESSORY) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON_CREATURE) + ";";
        sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_MELEE) + ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_RANGED) + ";";
        sBaseItems = "";
      }
      if (CI_IP_ENABLE_AbilityBonus != CI_IP_PROPERTY_DISABLED)
      {
        iMonsterOnly = (CI_IP_ENABLE_AbilityBonus == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
        ip_AutoPropertyPlus(CI_IP_AbilityBonus, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 6, 8, 50, iMonsterOnly, 1);
      }

      // AC Bonus (Armor)
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";";
      sCategoriesSub = "";
      sBaseItems = ";" + IntToString(BASE_ITEM_ARMOR) + ";";
      if (CI_IP_ENABLE_ACBonus != CI_IP_PROPERTY_DISABLED)
      {
        iMonsterOnly = (CI_IP_ENABLE_ACBonus == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
        ip_AutoPropertyPlus(CI_IP_ACBonus, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 7, 11, 50, iMonsterOnly, 1);
      }
      // AC Bonus (Shield)
      sCategoriesMain = "";
      sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_ARMOR_SHIELD) + ";";
      sBaseItems = "";
      if (CI_IP_ENABLE_ACBonus != CI_IP_PROPERTY_DISABLED)
      {
        iMonsterOnly = (CI_IP_ENABLE_ACBonus == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
        ip_AutoPropertyPlus(CI_IP_ACBonus, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 19, 11, 50, iMonsterOnly, 1);
      }
      // AC Bonus (Accessories)
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_MONSTERRING) + ";" + IntToString(CI_EGS_ITEM_MAIN_ACCESSORY) + ";";
      sCategoriesSub = "";
      sBaseItems = "";
      if (CI_IP_ENABLE_ACBonus != CI_IP_PROPERTY_DISABLED)
      {
        iMonsterOnly = (CI_IP_ENABLE_ACBonus == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
        ip_AutoPropertyPlus(CI_IP_ACBonus, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 19, 11, 50, iMonsterOnly, 1);
      }
      // AC Bonus vs. Alignment Group, applicable to Wearables
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR) + ";" + IntToString(CI_EGS_ITEM_MAIN_ACCESSORY) + ";";
      if (CI_IP_ENABLE_ACBonusVsAlignment != CI_IP_PROPERTY_DISABLED)
      {
        iMonsterOnly = (CI_IP_ENABLE_ACBonusVsAlignment == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
        ip_AutoPropertyPlus(CI_IP_ACBonusVsAlign, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 6, 11, 50, iMonsterOnly, 1);
      }
      // AC Bonus vs. Damage Type, applicable to Wearables
      if (CI_IP_ENABLE_ACBonusVsDmgType != CI_IP_PROPERTY_DISABLED)
      {
        iMonsterOnly = (CI_IP_ENABLE_ACBonusVsDmgType == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
        ip_AutoPropertyPlus(CI_IP_ACBonusVsDmgType, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 4, 10, 50, iMonsterOnly, 1);
      }
      // AC Bonus vs. Race, applicable to Wearables
      if (CI_IP_ENABLE_ACBonusVsRace != CI_IP_PROPERTY_DISABLED)
      {
        iMonsterOnly = (CI_IP_ENABLE_ACBonusVsRace == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
        ip_AutoPropertyPlus(CI_IP_ACBonusVsRace, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 6, 11, 50, iMonsterOnly, 1);
      }
      // AC Bonus vs. Specific Alignment, applicable to Wearables
      if (CI_IP_ENABLE_ACBonusVsSpecificAlignment != CI_IP_PROPERTY_DISABLED)
      {
        iMonsterOnly = (CI_IP_ENABLE_ACBonusVsSpecificAlignment == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
        ip_AutoPropertyPlus(CI_IP_ACBonusVsSAlign, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 4, 10, 50, iMonsterOnly, 1);
      }

      // Additional Property, applicable to Armor, Weapons and Accessories
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR) + ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON) + ";" + IntToString(CI_EGS_ITEM_MAIN_ACCESSORY) + ";";
      sCategoriesSub = ";" + ";";
      sBaseItems = "";
      if (CI_IP_ENABLE_AdditionalProperty != CI_IP_PROPERTY_DISABLED)
      {
        iMonsterOnly = (CI_IP_ENABLE_AdditionalProperty == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
        ip_AutoPropertyPlus(CI_IP_AdditionalProperty, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 2, 0, 0, 10, 10, 50, iMonsterOnly, 1);
      }

      // Arcane Spell Failure, applicable to light/medium/heavy armor and shields
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";";
      sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_ARMOR_BODY_LIGHT) + ";" + IntToString(CI_EGS_ITEM_SUB_ARMOR_BODY_MEDIUM) + ";" + IntToString(CI_EGS_ITEM_SUB_ARMOR_BODY_HEAVY) + ";" + IntToString(CI_EGS_ITEM_SUB_ARMOR_SHIELD) + ";";
      sBaseItems = "";
      // First, increased Arcane Spell Failure
      if (CI_IP_ENABLE_ArcaneSpellFailure_Increased != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_ArcaneSpellFailure_Increased == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_ArcaneSpellFailure, CI_IP_TYPE_NEGATIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 10, 0, 0, 10, 5, 50, iMonsterOnly, 1);
      }
      // Now the decreased Arcane Spell Failure
      if (CI_IP_ENABLE_ArcaneSpellFailure_Decreased != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_ArcaneSpellFailure_Decreased == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_ArcaneSpellFailure, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 9, 0, 0, 10, 5, 50, iMonsterOnly, -1);
      }

      // Attack Bonus, Melee, Ranged, Thrown, Staves, Gloves
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON_CREATURE) + ";";
      sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_MELEE) + ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_RANGED) + ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_THROWN) + ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_STAFF) + ";";
      sBaseItems = ";" + IntToString(BASE_ITEM_GLOVES) + ";";
      if (CI_IP_ENABLE_AttackBonus != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_AttackBonus == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_AttackBonus, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 6, 6, 50, iMonsterOnly, 1);
      }
      // Attack Bonus vs. Alignment Group, Wieldables (doesn't work on Gloves)
      sBaseItems = "";
      if (CI_IP_ENABLE_AttackBonusVsAlignment != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_AttackBonusVsAlignment == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_AttackBonusVsAlign, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 4, 6, 50, iMonsterOnly, 1);
      }
      // Attack Bonus vs. Race, Wieldables (doesn't work on Gloves)
      if (CI_IP_ENABLE_AttackBonusVsRace != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_AttackBonusVsRace == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_AttackBonusVsRace, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 4, 6, 50, iMonsterOnly, 1);
      }
      // Attack Bonus vs. Specific Alignment, Wieldables (doesn't work on Gloves)
      if (CI_IP_ENABLE_AttackBonusVsSpecificAlignment != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_AttackBonusVsSpecificAlignment == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_AttackBonusVsSAlign, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 2, 6, 50, iMonsterOnly, 1);
      }
      // Attack Penalty, Melee,  Thrown, Staves, Gloves
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON_CREATURE) + ";";
      sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_MELEE) + ";"  + IntToString(CI_EGS_ITEM_SUB_WEAPON_THROWN) + ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_STAFF) + ";";
      sBaseItems = ";" + IntToString(BASE_ITEM_GLOVES) + ";";
      if (CI_IP_ENABLE_AttackPenalty != CI_IP_PROPERTY_DISABLED)
      {
        iMonsterOnly = (CI_IP_ENABLE_AttackPenalty == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
        ip_AutoPropertyPlus(CI_IP_AttackPenalty, CI_IP_TYPE_NEGATIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 6, 6, 50, iMonsterOnly, 1);
      }

      // Bonus Feat, applicable to all wearables and Weapons
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_MONSTERRING) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR) + ";" + IntToString(CI_EGS_ITEM_MAIN_ACCESSORY) + ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON_CREATURE) + ";";
      sCategoriesSub = "";
      sBaseItems = "";
      if (CI_IP_ENABLE_BonusFeat != CI_IP_PROPERTY_DISABLED)
      {
        iMonsterOnly = (CI_IP_ENABLE_BonusFeat == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
        ip_AutoPropertyPlus(CI_IP_BonusFeat, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, 0, 0, 15, 15, 50, iMonsterOnly, 1);
      }
      // Bonus Level Spell, applicable to Jewelry, Staves
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_MONSTERRING) + ";";
      sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_STAFF) + ";";
      sBaseItems = ";" + IntToString(BASE_ITEM_AMULET) + ";" + IntToString(BASE_ITEM_RING) + ";";
      if (CI_IP_ENABLE_BonusLevelSpell != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_BonusLevelSpell == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_BonusLevelSpell, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 6, 5, 50, iMonsterOnly, 1);
      }
      // Bonus Saving Throw (Reflex, Fortitude, Death), applicable to Jewelry, Armor, Clothing, Shields, Helmets, Accessories
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_MONSTERRING) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR) + ";" + IntToString(CI_EGS_ITEM_MAIN_ACCESSORY) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";";
      sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_MELEE) + ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_RANGED) + ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_STAFF) + ";";
      sBaseItems = ";" + IntToString(BASE_ITEM_AMULET) + ";" + IntToString(BASE_ITEM_RING) + ";";
      if (CI_IP_ENABLE_BonusSavingThrow != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_BonusSavingThrow == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_BonusSavingThrow, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 6, 4, 50, iMonsterOnly, 1);
      }
      // Bonus Saving Throw vs. Specific Effect or Damage Type (Universal excluded),
      if (CI_IP_ENABLE_BonusSavingThrowVsX != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_BonusSavingThrowVsX == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_BonusSavingThrowVsX, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 2, 4, 50, iMonsterOnly, 1);
      }
      // Bonus Saving Throw vs. Specific Effect or Damage Type (Universal included),
      if (CI_IP_ENABLE_BonusSavingThrowVsXUniversalIncluded != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_BonusSavingThrowVsXUniversalIncluded == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_BonusSavingThrowVsXUniversalIncluded, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 10, 10, 50, iMonsterOnly, 1);
      }

      // Spell Resistance
      // Applicable to Jewelry, Clothing, Armor, Shields, Helmets
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_MONSTERRING) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";";
      sCategoriesSub = "";
      sBaseItems = ";" + IntToString(BASE_ITEM_AMULET) + ";" + IntToString(BASE_ITEM_RING) + ";";
      if (CI_IP_ENABLE_BonusSpellResistance != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_BonusSpellResistance == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_BonusSpellResistance, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, 0, 0, 10, 4, 50, iMonsterOnly, 1);
      }
      // Cast Spell (Potions)
      sCategoriesMain = "";
      sCategoriesSub = "";
      sBaseItems = ";" + IntToString(BASE_ITEM_POTIONS) + ";" + IntToString(BASE_ITEM_BLANK_POTION) + ";";
      if (CI_IP_ENABLE_CastSpellPotion != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_CastSpellPotion == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_CastSpellPotion, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, 0, 0, 1, 2, 40, iMonsterOnly, 1);
          ip_AutoPropertyPlus(CI_IP_CastSpellPotion, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 20, 0, 0, 41, 0, 50, iMonsterOnly, 0);
      }

      // Cast Spell (Wands and Rods)
      sCategoriesMain = "";
      sCategoriesSub = "";
      sBaseItems = ";" + IntToString(BASE_ITEM_MAGICWAND) + ";" + IntToString(BASE_ITEM_BLANK_WAND) + ";" + IntToString(BASE_ITEM_MAGICROD) + ";";
      // 5 Charges per Use
      if (CI_IP_ENABLE_CastSpellWand_5ChargesPerUse != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_CastSpellWand_5ChargesPerUse == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_CastSpellWand, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE, 0, 1, 2, 40, iMonsterOnly, 1);
          ip_AutoPropertyPlus(CI_IP_CastSpellWand, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 20, IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE, 0, 41, 0, 50, iMonsterOnly, 1);
      }
      // 1 Charge per Use
      if (CI_IP_ENABLE_CastSpellWand_1ChargePerUse != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_CastSpellWand_1ChargePerUse == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_CastSpellWand, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE, 0, 5, 3, 50, iMonsterOnly, 1);
      }
      // 1 Use/Day
      if (CI_IP_ENABLE_CastSpellWand_1PerDay != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_CastSpellWand_1PerDay == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_CastSpellWand, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY, 0, 5, 3, 50, iMonsterOnly, 1);
      }
      // 2 Uses/Day
      if (CI_IP_ENABLE_CastSpellWand_2PerDay != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_CastSpellWand_2PerDay == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_CastSpellWand, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY, 0, 15, 3, 50, iMonsterOnly, 1);
      }
      // 3 Uses/Day
      if (CI_IP_ENABLE_CastSpellWand_3PerDay != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_CastSpellWand_3PerDay == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_CastSpellWand, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY, 0, 25, 3, 50, iMonsterOnly, 1);
      }
      // Unlimited Use
      if (CI_IP_ENABLE_CastSpellWand_Unlimited != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_CastSpellWand_Unlimited == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_CastSpellWand, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE, 0, 35, 5, 50, iMonsterOnly, 1);
      }
      // Cast Spell (Staves and Books)
      if (CI_IP_ENABLE_CastSpell != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_CastSpell == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          sCategoriesMain = "";
          sCategoriesSub = "";
          sBaseItems = ";" + IntToString(BASE_ITEM_MAGICSTAFF) + ";" + IntToString(BASE_ITEM_BOOK) + ";";
          ip_AutoPropertyPlus(CI_IP_CastSpell, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE, 0, 5, 3, 50, iMonsterOnly, 1);
          sCategoriesMain = "";
          sCategoriesSub = "";
          sBaseItems = ";" + IntToString(BASE_ITEM_MAGICSTAFF) + ";";
          ip_AutoPropertyPlus(CI_IP_CastSpell, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE, 0, 1, 3, 50, iMonsterOnly, 1);
          ip_AutoPropertyPlus(CI_IP_CastSpell, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE, 0, 3, 3, 50, iMonsterOnly, 1);
          ip_AutoPropertyPlus(CI_IP_CastSpell, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE, 0, 5, 4, 50, iMonsterOnly, 1);
          ip_AutoPropertyPlus(CI_IP_CastSpell, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE, 0, 7, 4, 50, iMonsterOnly, 1);
      }

      // Container reduced weight, applicable to containers only
      sCategoriesMain = "";
      sCategoriesSub = "";
      sBaseItems = ";" + IntToString(BASE_ITEM_LARGEBOX) + ";";
      if (CI_IP_ENABLE_ContainerReducedWeight != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_ContainerReducedWeight == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_ContainerReducedWeight, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 15, 15, 50, iMonsterOnly, 1);
      }

      // Damage Bonus, applicable to Melee, Thrown Weapons, Ammo, Staves, Gloves
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_AMMO) + ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON_CREATURE) + ";";
      sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_MELEE) + ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_THROWN) + ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_STAFF) + ";";
      sBaseItems = ";" + IntToString(BASE_ITEM_GLOVES) + ";";
      if (CI_IP_ENABLE_DamageBonus != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_DamageBonus == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_DamageBonus, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 1, 3, 15, iMonsterOnly, 1);
          ip_AutoPropertyPlus(CI_IP_DamageBonus, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 6, 0, 0, 5, 5, 34, iMonsterOnly, 1);
          ip_AutoPropertyPlus(CI_IP_DamageBonus, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 13, 0, 0, 35, 0, 50, iMonsterOnly, 0);
      }

      // Damage Bonus vs. Alignment Group, applicable to Wieldables and Ammo
      if (CI_IP_ENABLE_DamageBonusVsAlignment != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_DamageBonusVsAlignment == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_DamageBonus, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 3, 3, 17, iMonsterOnly, 1);
          ip_AutoPropertyPlus(CI_IP_DamageBonus, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 8, 0, 0, 15, 5, 34, iMonsterOnly, 1);
          ip_AutoPropertyPlus(CI_IP_DamageBonus, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 13, 0, 0, 35, 0, 50, iMonsterOnly, 0);
      }

      // Damage Bonus vs. Race, applicable to Wieldables and Ammo
      if (CI_IP_ENABLE_DamageBonusVsRace != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_DamageBonusVsRace == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_DamageBonus, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 3, 3, 17, iMonsterOnly, 1);
          ip_AutoPropertyPlus(CI_IP_DamageBonus, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 8, 0, 0, 15, 5, 34, iMonsterOnly, 1);
          ip_AutoPropertyPlus(CI_IP_DamageBonus, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 13, 0, 0, 35, 0, 50, iMonsterOnly, 0);
      }

      // Damage Bonus vs. Specific Alignment, applicable to Wieldables and Ammo
      if (CI_IP_ENABLE_DamageBonusVsSpecificAlignment != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_DamageBonusVsSpecificAlignment == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_DamageBonus, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 3, 3, 17, iMonsterOnly, 1);
          ip_AutoPropertyPlus(CI_IP_DamageBonus, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 8, 0, 0, 15, 5, 34, iMonsterOnly, 1);
          ip_AutoPropertyPlus(CI_IP_DamageBonus, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 13, 0, 0, 35, 0, 50, iMonsterOnly, 0);
      }

      // Damage Immunity, applicable to All Armor Types and Accessories
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_MONSTERRING) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR) + ";" + IntToString(CI_EGS_ITEM_MAIN_ACCESSORY) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";";
      sCategoriesSub = "";
      sBaseItems = "";
      if (CI_IP_ENABLE_DamageImmunity != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_DamageImmunity == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_DamageImmunity, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 52, 0, 0, 1, 2, 50, iMonsterOnly, 2);
      }
      // Damage Penalty, Applicable to Weapons and Ammo
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON_CREATURE) + ";";
      sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_MELEE) + ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_THROWN) + ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_STAFF) + ";";
      sBaseItems = ";" + IntToString(BASE_ITEM_GLOVES) + ";";
      if (CI_IP_ENABLE_DamagePenalty != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_DamagePenalty == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_DamagePenalty, CI_IP_TYPE_NEGATIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 5, 5, 50, iMonsterOnly, 1);
      }

      // Damage Reduction, Applicable to Clothing, Armor, Shields, Helmets, Jewelry and Cloaks
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_MONSTERRING) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";";
      sCategoriesSub = "";
      sBaseItems = ";" + IntToString(BASE_ITEM_AMULET) + ";" + IntToString(BASE_ITEM_RING) + ";" + IntToString(BASE_ITEM_CLOAK) + ";";
      if (CI_IP_ENABLE_DamageReduction != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_DamageReduction == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_DamageReduction, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, IP_CONST_DAMAGESOAK_5_HP, 0, 7, 8, 50, iMonsterOnly, 1);
          ip_AutoPropertyPlus(CI_IP_DamageReduction, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, IP_CONST_DAMAGESOAK_10_HP, 0, 14, 8, 50, iMonsterOnly, 1);
          ip_AutoPropertyPlus(CI_IP_DamageReduction, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, IP_CONST_DAMAGESOAK_15_HP, 0, 21, 8, 50, TRUE, 1);
      }
      // Damage Resistance, Applicable to Clothing, Armor, Shields, Helmets and MonsterRing
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_MONSTERRING) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";";
      sCategoriesSub = "";
      sBaseItems = "";
      if (CI_IP_ENABLE_DamageResistance != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_DamageResistance == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_DamageResistance, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 10, 10, 50, iMonsterOnly, 1);
      }
      // Damage Vulnerability, Applicable to Clothing, Armor, Shields, Helmets
      if (CI_IP_ENABLE_DamageVulnerability != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_DamageVulnerability == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_DamageVulnerability, CI_IP_TYPE_NEGATIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 5, 10, 50, iMonsterOnly, 1);
      }

      // DarkVision, Applicable to Helmets and Amulets;
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";";
      sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_ARMOR_HELMET) + ";";
      sBaseItems = ";" + IntToString(BASE_ITEM_AMULET) + ";";
      if (CI_IP_ENABLE_Darkvision != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_Darkvision == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_Darkvision, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, 0, 0, 15, 0, 50, iMonsterOnly, 0);
      }
      // Decrease Ability, applicable to Wearables and Weapons
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR) + ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON) + ";" + IntToString(CI_EGS_ITEM_MAIN_ACCESSORY) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";";
      sCategoriesSub = "";
      sBaseItems = "";
      if (CI_IP_ENABLE_DecreaseAbility != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_DecreaseAbility == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_DecreaseAbility, CI_IP_TYPE_NEGATIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 6, 8, 50, iMonsterOnly, 1);
      }
      // Decrease Armor Class, applicable to Wearables and Weapons
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR) + ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON) + ";" + IntToString(CI_EGS_ITEM_MAIN_ACCESSORY) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";";
      sCategoriesSub = "";
      sBaseItems = "";
      if (CI_IP_ENABLE_DecreaseAC != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_DecreaseAC == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_DecreaseAC, CI_IP_TYPE_NEGATIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 7, 11, 50, iMonsterOnly, 1);
      }
      // Decrease Skill, applicable to Wearables and Weapons
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR) + ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON) + ";" + IntToString(CI_EGS_ITEM_MAIN_ACCESSORY) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";";
      sCategoriesSub = "";
      sBaseItems = "";
      if (CI_IP_ENABLE_DecreaseSkill != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_DecreaseSkill == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_DecreaseSkill, CI_IP_TYPE_NEGATIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 12, 2, 50, iMonsterOnly, 1);
      }
      // Decrease Skill ("All Skills" included, applicable to Wearables and Weapons
      if (CI_IP_ENABLE_DecreaseSkillAllSkillsIncluded != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_DecreaseSkillAllSkillsIncluded == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_DecreaseSkillAllSkillsIncluded, CI_IP_TYPE_NEGATIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 30, 10, 50, iMonsterOnly, 1);
      }

      // Enhancement Bonus, applicable to Weapons and Ammo
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON_CREATURE) + ";";
      sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_MELEE) + ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_THROWN) + ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_STAFF) + ";";
      sBaseItems = "";
      if (CI_IP_ENABLE_EnhancementBonus != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_EnhancementBonus == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_EnhancementBonus, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 6, 8, 50, iMonsterOnly, 1);
      }
      // Enhancement Bonus vs. Alignment Group, applicable to Weapons and Ammo
      if (CI_IP_ENABLE_EnhancementBonusVsAlignment != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_EnhancementBonusVsAlignment == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_EnhancementBonusVsAlign, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 4, 8, 50, iMonsterOnly, 1);
      }
      // Enhancement Bonus vs. Race, applicable to Weapons and Ammo
      if (CI_IP_ENABLE_EnhancementBonusVsRace != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_EnhancementBonusVsRace == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_EnhancementBonusVsRace, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 4, 8, 50, iMonsterOnly, 1);
      }
      // Enhancement Bonus vs. Specific Alignment, applicable to Weapons and Ammo
      if (CI_IP_ENABLE_EnhancementBonusVsSpecificAlignment != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_EnhancementBonusVsSpecificAlignment == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_EnhancementBonusVsSAlign, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 2, 8, 50, iMonsterOnly, 1);
      }
      /* Not sure if this Property even exists
      // Enhancement Penalty, Applicable to Weapons and Ammo
      ip_AutoPropertyPlus(CI_IP_EnhancementPenalty, 10, 5, 29, CI_IP_TYPE_NEGATIVE, 1, 0, 0, iCategories, iMonsterOnly);
      ip_AutoPropertyPlus(CI_IP_EnhancementPenalty, 30, 0, 50, CI_IP_TYPE_NEGATIVE, 5, 0, 0, iCategories, iMonsterOnly);
      */

      // Extra Melee Damage Type, Weapons only
      sCategoriesMain = "";
      sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_MELEE) + ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_STAFF) + ";";
      sBaseItems = "";
      if (CI_IP_ENABLE_ExtraMeleeDamageType != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_ExtraMeleeDamageType == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_ExtraMeleeDamageType, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, 0, 0, 5, 0, 50, iMonsterOnly, 0);
      }
      // Extra Ranged Damage Type, Weapons only
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_AMMO) + ";";
      sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_RANGED) + ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_THROWN) + ";";
      sBaseItems = "";
      if (CI_IP_ENABLE_ExtraRangeDamageType != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_ExtraRangeDamageType == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_ExtraRangeDamageType, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, 0, 0, 5, 0, 50, iMonsterOnly, 0);
      }
      /* Not sure if that property exists
      // Free Action, Applicable to Accessories only
      iCategories = CI_EGS_CATEGORY_ACCESSORIES;
      ip_AutoPropertyPlus(CI_IP_FreeAction, 40, 0, 50, CI_IP_TYPE_POSITIVE, 0, 0, 0, iCategories, iMonsterOnly);
      */

      // Haste, Applicable to Jewelry and Boots
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_MONSTERRING) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";";
      sCategoriesSub = "";
      sBaseItems = ";" + IntToString(BASE_ITEM_AMULET) + ";" + IntToString(BASE_ITEM_RING) + ";" + IntToString(BASE_ITEM_BOOTS) + ";";
      if (CI_IP_ENABLE_Haste != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_Haste == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_Haste, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, 0, 0, 45, 0, 50, iMonsterOnly, 0);
      }
      // Healer's Kit
      sCategoriesMain = "";
      sCategoriesSub = "";
      sBaseItems = ";" + IntToString(BASE_ITEM_HEALERSKIT) + ";";
      if (CI_IP_ENABLE_HealersKit != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_HealersKit == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_HealersKit, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 1, 5, 50, iMonsterOnly, 1);
      }
      // Holy Avenger, applicable to Melee Weapons
      sCategoriesMain = "";
      sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_MELEE) + ";";
      sBaseItems = "";
      if (CI_IP_ENABLE_HolyAvenger != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_HolyAvenger == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_HolyAvenger, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, 0, 0, 40, 0, 50, iMonsterOnly, 0);
      }

      // Immunity Misc., Applicable to Armor, Shields, Helmets, Jewelry
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_MONSTERRING) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";";
      sCategoriesSub = "";
      sBaseItems = ";" + IntToString(BASE_ITEM_AMULET) + ";" + IntToString(BASE_ITEM_RING) + ";";
      if (CI_IP_ENABLE_ImmunityMisc != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_ImmunityMisc == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_ImmunityMisc, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 5, 0, 0, 25, 0, 50, iMonsterOnly, 0);
          ip_AutoPropertyPlus(CI_IP_ImmunityMisc, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 9, 0, 0, 35, 0, 50, iMonsterOnly, 0);
          // Rest is monster-only
          ip_AutoPropertyPlus(CI_IP_ImmunityMisc, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 3, 0, 0, 20, 0, 50, TRUE, 0);
          ip_AutoPropertyPlus(CI_IP_ImmunityMisc, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 4, 0, 0, 25, 0, 50, TRUE, 0);
          ip_AutoPropertyPlus(CI_IP_ImmunityMisc, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, 0, 0, 25, 0, 50, TRUE, 0);
          ip_AutoPropertyPlus(CI_IP_ImmunityMisc, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 8, 0, 0, 25, 0, 50, TRUE, 0);
          ip_AutoPropertyPlus(CI_IP_ImmunityMisc, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 6, 0, 0, 25, 0, 50, TRUE, 0);
          ip_AutoPropertyPlus(CI_IP_ImmunityMisc, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 2, 0, 0, 25, 0, 50, TRUE, 0);
          ip_AutoPropertyPlus(CI_IP_ImmunityMisc, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 7, 0, 0, 25, 0, 50, TRUE, 0);
      }
      // Immunity to Spell Level, Applicable to Armor, Helmets, Jewelry and Staves
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_MONSTERRING) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";";
      sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_STAFF) + ";";
      sBaseItems = ";" + IntToString(BASE_ITEM_AMULET) + ";" + IntToString(BASE_ITEM_RING) + ";";
      if (CI_IP_ENABLE_ImmunityToSpellLevel != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_ImmunityToSpellLevel == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_ImmunityToSpellLevel, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 20, 15, 50, iMonsterOnly, 1);
          // Immunity to Spell Level > Lvl 2, Applicable to Monsters only regardless of setting
          ip_AutoPropertyPlus(CI_IP_ImmunityToSpellLevel, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 2, 0, 0, 25, 5, 50, TRUE, 1);
      }

      // Improved Evasion, Applicable to Boots, Cloaks, Armor and Jewelry
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_MONSTERRING) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";";
      sCategoriesSub = "";
      sBaseItems = ";" + IntToString(BASE_ITEM_AMULET) + ";" + IntToString(BASE_ITEM_RING) + ";" + IntToString(BASE_ITEM_CLOAK) + ";" + IntToString(BASE_ITEM_BOOTS) + ";";
      if (CI_IP_ENABLE_ImprovedEvasion != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_ImprovedEvasion == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_ImprovedEvasion, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, 0, 0, 30, 0, 50, iMonsterOnly, 0);
      }
      // Keen, Applicable to Melee Weapons
      sCategoriesMain = "";
      sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_MELEE) + ";";
      sBaseItems = "";
      if (CI_IP_ENABLE_Keen != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_Keen == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_Keen, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, 0, 0, 25, 0, 50, iMonsterOnly, 0);
      }
      // Light, Applicable to all Equippable
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR) + ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON) + ";" + IntToString(CI_EGS_ITEM_MAIN_ACCESSORY) + ";";
      sCategoriesSub = "";
      sBaseItems = "";
      if (CI_IP_ENABLE_Light != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_Light == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_Light, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, IP_CONST_LIGHTBRIGHTNESS_DIM, 0, 0, 1, 0, 4, iMonsterOnly);
          ip_AutoPropertyPlus(CI_IP_Light, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, IP_CONST_LIGHTBRIGHTNESS_LOW, 0, 0, 1, 0, 8, iMonsterOnly);
          ip_AutoPropertyPlus(CI_IP_Light, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, IP_CONST_LIGHTBRIGHTNESS_NORMAL, 0, 0, 1, 0, 12, iMonsterOnly);
          ip_AutoPropertyPlus(CI_IP_Light, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, IP_CONST_LIGHTBRIGHTNESS_BRIGHT, 0, 0, 5, 0, 50, iMonsterOnly);
      }
      // Limit Use by Alignment Group, Applicable to ALL items
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR) + ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON) + ";" + IntToString(CI_EGS_ITEM_MAIN_ACCESSORY) + ";" + IntToString(CI_EGS_ITEM_MAIN_AMMO) + ";" + IntToString(CI_EGS_ITEM_MAIN_RODWAND) + ";";
      sCategoriesSub = "";
      sBaseItems = "";
      if (CI_IP_ENABLE_LimitUseByAlignment != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_LimitUseByAlignment == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_LimitUseByAlign, CI_IP_TYPE_RESTRICTIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, 0, 0, 1, 0, 50, iMonsterOnly, 0);
      }
      // Limit Use by Class, Applicable to ALL items
      if (CI_IP_ENABLE_LimitUseByClass != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_LimitUseByClass == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_LimitUseByClass, CI_IP_TYPE_RESTRICTIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, 0, 0, 1, 0, 50, iMonsterOnly, 0);
      }
      // Limit Use by Race, Applicable to ALL items
      if (CI_IP_ENABLE_LimitUseByRace != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_LimitUseByRace == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_LimitUseByRace, CI_IP_TYPE_RESTRICTIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, 0, 0, 1, 0, 50, iMonsterOnly, 0);
      }
      // Limit Use by Specific Alignment, Applicable to ALL items
      if (CI_IP_ENABLE_LimitUseBySpecificAlignment != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_LimitUseBySpecificAlignment == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_LimitUseBySAlign, CI_IP_TYPE_RESTRICTIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, 0, 0, 1, 0, 50, iMonsterOnly, 0);
      }
      // Massive Critial, applicable to Weapons
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON) + ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON_CREATURE) + ";";
      sCategoriesSub = "";
      sBaseItems = "";
      if (CI_IP_ENABLE_MassiveCritical != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_MassiveCritical == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_MassiveCritical, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 1, 5, 25, iMonsterOnly, 1);
          ip_AutoPropertyPlus(CI_IP_MassiveCritical, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 6, 0, 0, 11, 5, 40, iMonsterOnly, 1);
          ip_AutoPropertyPlus(CI_IP_MassiveCritical, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 13, 0, 0, 41, 0, 50, iMonsterOnly, 0);
      }

      // Mighty, applicable only to ranged weapons
      sCategoriesMain = "";
      sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_RANGED) + ";";
      sBaseItems = "";
      if (CI_IP_ENABLE_Mighty != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_Mighty == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_MassiveCritical, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 13, 0, 0, 41, 0, 50, iMonsterOnly, 0);
      }

      // Monster Damage, applicable to creature Weapons
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON_CREATURE) + ";";
      sCategoriesSub = "";
      sBaseItems = "";
      if (CI_IP_ENABLE_MonsterDamage != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_MonsterDamage == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_MonsterDamage, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 1, 3, 12, iMonsterOnly, 1);
          ip_AutoPropertyPlus(CI_IP_MonsterDamage, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 8, 0, 0, 7, 3, 21, iMonsterOnly, 10);
          ip_AutoPropertyPlus(CI_IP_MonsterDamage, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 10, 0, 0, 19, 3, 30, iMonsterOnly, 10);
          ip_AutoPropertyPlus(CI_IP_MonsterDamage, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 48, 0, 0, 22, 5, 50, iMonsterOnly, 1);
      }

      // No Combat Damage, Applicable to Weapons and Ammo
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON) + ";";
      sCategoriesSub = "";
      sBaseItems = "";
      if (CI_IP_ENABLE_NoDamage != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_NoDamage == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_NoDamage, CI_IP_TYPE_NEGATIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, 0, 0, 1, 0, 50, iMonsterOnly, 0);
      }
      // OnHit: Cast Spell Applicable to Clothing, Armor and Weapons

      // OnHit Properties, Applicable to Weapons only

      // OnHit Monster props, unused

      // Reduced Saving Throw, Applicable to All Wearable + Wieldable
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR) + ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON) + ";" + IntToString(CI_EGS_ITEM_MAIN_ACCESSORY) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";";
      sCategoriesSub = "";
      sBaseItems = "";
      if (CI_IP_ENABLE_ReducedSavingThrow != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_ReducedSavingThrow == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_ReducedSavingThrow, CI_IP_TYPE_NEGATIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 6, 4, 50, iMonsterOnly, 1);
      }
      // Reduced Saving Throw vs. Specific Effect or Damage Type (Universal excluded) , Applicable to All Wearable + Wieldable
      if (CI_IP_ENABLE_ReducedSavingThrowVsX != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_ReducedSavingThrowVsX == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_ReducedSavingThrowVsX, CI_IP_TYPE_NEGATIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 2, 4, 50, iMonsterOnly, 1);
      }
      // Reduced Saving Throw vs. Specific Effect or Damage Type (Universal included) , Applicable to All Wearable + Wieldable
      if (CI_IP_ENABLE_ReducedSavingThrowVsXUniversalIncluded != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_ReducedSavingThrowVsXUniversalIncluded == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_ReducedSavingThrowVsXUniversalIncluded, CI_IP_TYPE_NEGATIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 10, 10, 50, iMonsterOnly, 1);
      }
      // Regeneration, Applicable to Jewelry and Accessories
      if (CI_IP_RESTRICT_Regeneration)
      {
          sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_MONSTERRING) + ";";
          sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_ACCESSORY_JEWELRY) + ";";
      }
      else
      {
          sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_MONSTERRING) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR) + ";" + IntToString(CI_EGS_ITEM_MAIN_ACCESSORY) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";";
          sCategoriesSub = "";
      }
      sBaseItems = "";

      if (CI_IP_ENABLE_Regeneration != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_Regeneration == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_Regeneration, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 12, 8, 50, iMonsterOnly, 1);
      }

      // Skill Bonus, Applicable to everything Wearable
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_MONSTERRING) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR) + ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON) + ";" + IntToString(CI_EGS_ITEM_MAIN_ACCESSORY) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON_CREATURE) + ";";
      sCategoriesSub = "";
      sBaseItems = "";
      if (CI_IP_ENABLE_SkillBonus != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_SkillBonus == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_SkillBonus, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 3, 3, 50, iMonsterOnly, 1);
      }
      // Skill Bonus ("All Skills" included), Applicable to everything Wearable
      if (CI_IP_ENABLE_SkillBonusAllIncluded != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_SkillBonusAllIncluded == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_SkillBonusAllIncluded, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 30, 10, 50, iMonsterOnly, 1);
      }
      /*
      // Special Walk (Zombie), Applicable to Creature Hides only, therefor not used for now
      ip_AutoPropertyPlus(CI_IP_SpecialWalk, 10, 0, 50, CI_IP_TYPE_NEGATIVE, 0, 0, 0, iCategories, iMonsterOnly);
      */

      // Spell Immunity School, Rings and Amulets, Monsters only
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_MONSTERRING) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";";
      sCategoriesSub = "";
      sBaseItems = ";" + IntToString(BASE_ITEM_RING) + ";" + IntToString(BASE_ITEM_AMULET) + ";";
      if (CI_IP_ENABLE_SpellImmunitySchool != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_SpellImmunitySchool == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_SpellImmunitySchool, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, 0, 0, 25, 0, 50, iMonsterOnly, 0);
      }
      // Spell Immunity Specific not used

      // Thieves Tools
      sCategoriesMain = "";
      sCategoriesSub = "";
      sBaseItems = ";" + IntToString(BASE_ITEM_THIEVESTOOLS) + ";";
      if (CI_IP_ENABLE_ThievesTools != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_ThievesTools == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_ThievesTools, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 1, 4, 44, iMonsterOnly, 1);
          ip_AutoPropertyPlus(CI_IP_ThievesTools, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 12, 0, 0, 45, 0, 50, iMonsterOnly, 0);
      }
      // Trap
      sCategoriesMain = "";
      sCategoriesSub = "";
      sBaseItems = ";" + IntToString(BASE_ITEM_TRAPKIT) + ";";
      if (CI_IP_ENABLE_Trap != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_Trap == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_Trap, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, 0, 0, 1, 10, 50, iMonsterOnly, 1);
      }
      // True Seeing, Applicable to Helmets and Jewelry
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_MONSTERRING) + ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR_CREATURE) + ";";
      sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_ARMOR_HELMET) + ";";
      sBaseItems = ";" + IntToString(BASE_ITEM_RING) + ";" + IntToString(BASE_ITEM_AMULET) + ";";
      if (CI_IP_ENABLE_TrueSeeing != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_TrueSeeing == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_TrueSeeing, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, 0, 0, 50, 0, 50, TRUE, 0);
      }

      // Turn Resistance, applicable to Creature Hides ONLY
      // iCategories = CI_EGS_CATEGORY_WIELDABLE + CI_EGS_CATEGORY_WEARABLE;
      // ip_AutoPropertyPlus(CI_IP_TurnResistance, 1, 1, 25, CI_IP_TYPE_POSITIVE, 1, 0, 0, iCategories, iMonsterOnly);
      // ip_AutoPropertyPlus(CI_IP_TurnResistance, 26, 1, 50, CI_IP_TYPE_POSITIVE, 26, 0, 0, iCategories, iMonsterOnly);

      // Unlimited Ammo, applicable to Ranged Weapons
      sCategoriesMain = "";
      sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_RANGED) + ";";
      sBaseItems = "";
      if (CI_IP_ENABLE_UnlimitedAmmo != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_UnlimitedAmmo == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_UnlimitedAmmo, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 15, 0, 24, iMonsterOnly, 0);
          ip_AutoPropertyPlus(CI_IP_UnlimitedAmmo, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 11, 0, 0, 25, 0, 29, iMonsterOnly, 0);
          ip_AutoPropertyPlus(CI_IP_UnlimitedAmmo, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 12, 0, 0, 30, 0, 34, iMonsterOnly, 0);
          ip_AutoPropertyPlus(CI_IP_UnlimitedAmmo, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 13, 0, 0, 35, 0, 39, iMonsterOnly, 0);
          ip_AutoPropertyPlus(CI_IP_UnlimitedAmmo, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 14, 0, 0, 40, 0, 44, iMonsterOnly, 0);
          ip_AutoPropertyPlus(CI_IP_UnlimitedAmmo, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 15, 0, 0, 45, 0, 50, iMonsterOnly, 0);
          ip_AutoPropertyPlus(CI_IP_UnlimitedAmmo, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 2, 0, 0, 30, 0, 50, iMonsterOnly, 0);
          ip_AutoPropertyPlus(CI_IP_UnlimitedAmmo, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 3, 0, 0, 30, 0, 50, iMonsterOnly, 0);
          ip_AutoPropertyPlus(CI_IP_UnlimitedAmmo, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 4, 0, 0, 30, 0, 50, iMonsterOnly, 0);
      }
      // Vampiric Regeneration, Ammo, Melee, Thrown, Staves
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_AMMO) + ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON_CREATURE) + ";";
      sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_MELEE) + ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_THROWN) + ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_STAFF)+ ";";
      sBaseItems = "";
      if (CI_IP_ENABLE_VampiricRegeneration != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_VampiricRegeneration == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_VampiricRegeneration, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 20, 5, 50, iMonsterOnly, 1);
      }
      /* Deactivated
      // Visual Effect, Melee Weapons only
      sCategoriesMain = "";
      sCategoriesSub = ";" + IntToString(CI_EGS_ITEM_SUB_WEAPON_MELEE) + ";";
      sBaseItems = "";
      ip_AutoPropertyPlus(CI_IP_VisualEffect, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 0, 0, 0, 10, 0, 50, iMonsterOnly);
      */

      // Weight Increase, Wands and Rods only (Doesn't work)
      /*
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_RODWAND) + ";";
      sCategoriesSub = "";
      sBaseItems = "";
      ip_AutoPropertyPlus(CI_IP_WeightIncrease, CI_IP_TYPE_NEGATIVE, sCategoriesMain, sCategoriesSub, sBaseItems, IP_CONST_WEIGHTINCREASE_5_LBS, 0, 0, 6, 0, 9, iMonsterOnly);
      ip_AutoPropertyPlus(CI_IP_WeightIncrease, CI_IP_TYPE_NEGATIVE, sCategoriesMain, sCategoriesSub, sBaseItems, IP_CONST_WEIGHTINCREASE_10_LBS, 0, 0, 10, 0, 13, iMonsterOnly);
      ip_AutoPropertyPlus(CI_IP_WeightIncrease, CI_IP_TYPE_NEGATIVE, sCategoriesMain, sCategoriesSub, sBaseItems, IP_CONST_WEIGHTINCREASE_15_LBS, 0, 0, 14, 0, 17, iMonsterOnly);
      ip_AutoPropertyPlus(CI_IP_WeightIncrease, CI_IP_TYPE_NEGATIVE, sCategoriesMain, sCategoriesSub, sBaseItems, IP_CONST_WEIGHTINCREASE_30_LBS, 0, 0, 18, 0, 21, iMonsterOnly);
      ip_AutoPropertyPlus(CI_IP_WeightIncrease, CI_IP_TYPE_NEGATIVE, sCategoriesMain, sCategoriesSub, sBaseItems, IP_CONST_WEIGHTINCREASE_50_LBS, 0, 0, 22, 0, 25, iMonsterOnly);
      ip_AutoPropertyPlus(CI_IP_WeightIncrease, CI_IP_TYPE_NEGATIVE, sCategoriesMain, sCategoriesSub, sBaseItems, IP_CONST_WEIGHTINCREASE_100_LBS, 0, 0, 26, 0, 50, iMonsterOnly);
      */
      // Weight Decrease, applicable to everything
      sCategoriesMain = ";" + IntToString(CI_EGS_ITEM_MAIN_ARMOR) + ";" + IntToString(CI_EGS_ITEM_MAIN_WEAPON) + ";" + IntToString(CI_EGS_ITEM_MAIN_ACCESSORY) + ";" + IntToString(CI_EGS_ITEM_MAIN_AMMO) + ";";
      sCategoriesSub = "";
      sBaseItems = "";
      if (CI_IP_ENABLE_WeightReduction != CI_IP_PROPERTY_DISABLED)
      {
          iMonsterOnly = (CI_IP_ENABLE_WeightReduction == CI_IP_PROPERTY_ENABLED_MONSTERONLY);
          ip_AutoPropertyPlus(CI_IP_WeightReduction, CI_IP_TYPE_POSITIVE, sCategoriesMain, sCategoriesSub, sBaseItems, 1, 0, 0, 5, 10, 50, iMonsterOnly, 1);
      }

      if (!CI_IP_USE_NWNX)
      {
         // We need to stay right here until everything was added
         //object oStorePreload = GetLocalObject(oMod, CS_IP_DB_PRELOAD_STORE_OBJ);
         //int iCurrentPropertyID = GetLocalInt(oMod, CS_IP_ARRAY_INIT);
         //int iTotalProperties = eas_Array_GetSize(oStorePreload, CS_IP_DB_PRELOAD_ARRAY);
         //if (iCurrentPropertyID % 250 == 0)
         //SendMessageToAllDMs("Inserting Property " + IntToString(iCurrentPropertyID) + "/" + IntToString(iTotalProperties));
         //if (iCurrentPropertyID < iTotalProperties)
         //{
            DelayCommand(0.1, ExecuteScript("ip_ini_b", oMod));
         //}
      }

      object oLog = GetObjectByTag("LOG");
      SetDescription(oLog, GetDescription(oLog) + "\nIP - Item Properties initialized.");
      WriteTimestampedLogEntry("IP - Item Properties initalized");
}


void main()
{
    // If all tables exist, do not (re)initialize
    if (ip_GetTableExists())
    {
        object oLog = GetObjectByTag("LOG");
        SetDescription(oLog, GetDescription(oLog) + "\nIP - database already exists.");
        WriteTimestampedLogEntry("IP - database already exists - skipping initialization.");
        return;
    }

    // Drop any existing tables
    ip_DropTable();

    // Create table
    ip_CreateTable();

    // Initialize
    DelayCommand(0.2, InitAll());
}

