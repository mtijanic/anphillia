///////////////////////////////////////////////////////////////////////////////
// ip_names_inc
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: This script is responsible for sorting out the item naming

///////////
// Includes
//
#include "nwnx_sql"
#include "ip_names_cfg"
#include "color_inc"
#include "eas_inc"

///////////////////////
// Function Declaration
//

// Recreate the naming table
void ip_CreateNameTable();

// Returns FALSE if any of the required System Tables is missing
int ip_GetNameTableExists();

// Drops all System Tables
void ip_DropNameTable();

// This function sets up a property's pre- and postfixes
// iID, iVar1, iVar2 and iVar3 resemble the exact property setup
// Special value for all iVar is -1, which makes them irrelevant on compare
// Setting iBelowLevel to 100 will make sure the property is available for all levels
void ip_SetPropertyName(int iID, int iVar1, int iVar2, int iVar3, int iLowerEnd, int iHigherEnd, string sPrefix1, string sPrefix2, string sPostfix);

// This returns the Name for Property iID with the set Variables and iLvl
// sFix can be CS_IP_NAME_PREFIX_I, CS_IP_NAME_PREFIX_II or CS_IP_NAME_POSTFIX
// Items are generally created using the following way
// PREFIX_I PREFIX_II <itemname> POSTFIX
string ip_GetPropertyName(int iID, int iVar1, int iVar2 = 0, int iVar3 = 0, int iLvl = 0, string sFix = CS_IP_NAME_PREFIX_I);

// Evaluate the item and name it according to it's properties
void ip_EvaluateItem(object oItem, int iPositiveProps, int iNegativeProps, int iRestrictiveProps, int iPositivePropsWithinRareDeviation, int iPositivePropsWithinEpicDeviation);

// This sets up the Item Naming System
void ip_InitializeItemNames();

////////////////
// Function Code
//

// Non NWNX Helper Code
void ip_Array_SetNameInfo(object oStore, string sArray, string sReference, int iVar1, int iVar2, int iVar3)
{
    // Create the default array
    eas_Array_Create(oStore, sArray, EAS_ARRAY_TYPE_STRING);
    eas_SArray_Entry_Add(oStore, sArray, sReference);

    // Create the Base-Valued Array
    eas_Array_Create(oStore, sArray + "_V1_" + IntToString(iVar1), EAS_ARRAY_TYPE_STRING);
    eas_SArray_Entry_Add(oStore, sArray + "_V1_" + IntToString(iVar1), sReference);

    // Create the Weapon-Size Array
    eas_Array_Create(oStore, sArray + "_V2_" + IntToString(iVar2), EAS_ARRAY_TYPE_STRING);
    eas_SArray_Entry_Add(oStore, sArray + "_V2_" + IntToString(iVar2), sReference);

    // Create the Combined Array
    eas_Array_Create(oStore, sArray + "_V1_" + IntToString(iVar1) + "_V2_" + IntToString(iVar2), EAS_ARRAY_TYPE_STRING);
    eas_SArray_Entry_Add(oStore, sArray + "_V1_" + IntToString(iVar1) + "_V2_" + IntToString(iVar2), sReference);
}

int ip_GetNameTableExists()
{
    if (CI_IP_USE_NWNX)
    {
        int nExists_Names = NWNX_SQL_ExecuteQuery("DESCRIBE " + CS_IP_NAMETABLE);
        return (nExists_Names);
    }
    else
        return FALSE;
}

void ip_DropNameTable()
{
    if (CI_IP_USE_NWNX)
        NWNX_SQL_ExecuteQuery("DROP TABLE " + CS_IP_NAMETABLE);
}

void ip_CreateNameTable()
{
    if (CI_IP_USE_NWNX)
    {
        NWNX_SQL_ExecuteQuery("DROP TABLE " + CS_IP_NAMETABLE);
        string sSQL = "CREATE TABLE " + CS_IP_NAMETABLE + " (" + CS_IP_NAME_PROPID + " int NOT NULL, ";
        sSQL += CS_IP_NAME_VAR_I + " int DEFAULT NULL, ";
        sSQL += CS_IP_NAME_VAR_II + " int DEFAULT NULL, ";
        sSQL += CS_IP_NAME_VAR_III + " int DEFAULT NULL, ";
        sSQL += CS_IP_NAME_PREFIX_I + " varchar(32) DEFAULT NULL, ";
        sSQL += CS_IP_NAME_PREFIX_II + " varchar(32) DEFAULT NULL, ";
        sSQL += CS_IP_NAME_POSTFIX + " varchar(32) DEFAULT NULL, ";
        sSQL += CS_IP_NAME_LOWLEVEL + " int DEFAULT NULL, ";
        sSQL += CS_IP_NAME_HIGHLEVEL + " int DEFAULT NULL, ";
        sSQL += "KEY idx (" + CS_IP_NAME_PROPID + ", " + CS_IP_NAME_VAR_I + ", " + CS_IP_NAME_VAR_II + ", " + CS_IP_NAME_VAR_III + ", " + CS_IP_NAME_PREFIX_I + ", " + CS_IP_NAME_PREFIX_II + ", " + CS_IP_NAME_POSTFIX + ", " + CS_IP_NAME_LOWLEVEL + ", " + CS_IP_NAME_HIGHLEVEL + "))";
        NWNX_SQL_ExecuteQuery(sSQL);
    }
    else
    {
        object oStoreWaypoint = GetObjectByTag(CS_IPNAMES_DB_WAYPOINT);
        CreateObject(OBJECT_TYPE_STORE, CS_IPNAMES_DB_MERCHANT_RESREF, GetLocation(oStoreWaypoint), FALSE, CS_IPNAMES_DB_MERCHANT_NEWTAG);
    }
}

void ip_SetPropertyName(int iID, int iVar1, int iVar2, int iVar3, int iLowerEnd, int iHigherEnd, string sPrefix1, string sPrefix2, string sPostfix)
{
    if (CI_IP_USE_NWNX)
    {
        string sSQL = "INSERT INTO " + CS_IP_NAMETABLE + " (" + CS_IP_NAME_PROPID + ", " + CS_IP_NAME_VAR_I + ", " + CS_IP_NAME_VAR_II + ", " + CS_IP_NAME_VAR_III + ", " + CS_IP_NAME_PREFIX_I + ", " + CS_IP_NAME_PREFIX_II + ", " + CS_IP_NAME_POSTFIX + ", " + CS_IP_NAME_LOWLEVEL + ", " + CS_IP_NAME_HIGHLEVEL + ") ";
        sSQL += "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedInt(0, iID);
        NWNX_SQL_PreparedInt(1, iVar1);
        NWNX_SQL_PreparedInt(2, iVar2);
        NWNX_SQL_PreparedInt(3, iVar3);
        NWNX_SQL_PreparedString(4, sPrefix1);
        NWNX_SQL_PreparedString(5, sPrefix2);
        NWNX_SQL_PreparedString(6, sPostfix);
        NWNX_SQL_PreparedInt(7, iLowerEnd);
        NWNX_SQL_PreparedInt(8, iHigherEnd);
        NWNX_SQL_ExecutePreparedQuery();
    }
    else
    {
        // Get the Merchant Object
        object oStore = GetObjectByTag(CS_IPNAMES_DB_MERCHANT_NEWTAG);
        string sReference = "N" +
                            "_I" + IntToString(iID) +
                            "_V1_" + IntToString(iVar1) +
                            "_V2_" + IntToString(iVar2) +
                            "_V3_" + IntToString(iVar3);

        // Save the item Info to the store
        SetLocalString(oStore, CS_IP_NAME_PREFIX_I + sReference, sPrefix1);
        SetLocalString(oStore, CS_IP_NAME_PREFIX_II + sReference, sPrefix2);
        SetLocalString(oStore, CS_IP_NAME_POSTFIX + sReference, sPostfix);

        // Create the arrays with references to the items
        string sArrayName = CS_IPNAMES_ARRAY_IP + IntToString(iID);
        ip_Array_SetNameInfo(oStore, sArrayName, sReference, iVar1, iVar2, iVar3);
    }
}

string ip_GetPropertyName(int iID, int iVar1, int iVar2 = 0, int iVar3 = 0, int iLvl = 0, string sFix = CS_IP_NAME_PREFIX_I)
{
    string sResult;
    if (CI_IP_USE_NWNX)
    {
        string sSQL = "SELECT " + sFix + " FROM " + CS_IP_NAMETABLE + " WHERE ";
        sSQL += CS_IP_NAME_PROPID + " = ?";
        sSQL += " AND (" + CS_IP_NAME_VAR_I + " = ? OR " + CS_IP_NAME_VAR_I + " = -1)";
        sSQL += " AND (" + CS_IP_NAME_VAR_II + " = ? OR " + CS_IP_NAME_VAR_II + " = -1)";
        sSQL += " AND (" + CS_IP_NAME_VAR_III + " = ? OR " + CS_IP_NAME_VAR_III + " = -1)";
        sSQL += " AND " + CS_IP_NAME_LOWLEVEL + " <= ?";
        sSQL += " AND " + CS_IP_NAME_HIGHLEVEL + " >= ?";
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedInt(0, iID);
        NWNX_SQL_PreparedInt(1, iVar1);
        NWNX_SQL_PreparedInt(2, iVar2);
        NWNX_SQL_PreparedInt(3, iVar3);
        NWNX_SQL_PreparedInt(4, iLvl);
        NWNX_SQL_PreparedInt(5, iLvl);
        NWNX_SQL_ExecutePreparedQuery();
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            sResult = NWNX_SQL_ReadDataInActiveRow(0);
        }
        else
        {
            //SendMessageToAllDMs("Error fetching property name string");
            sResult = "";
        }
    }
    else
    {
        // Get the Merchant Object
        object oStore = GetObjectByTag(CS_IPNAMES_DB_MERCHANT_NEWTAG);

        // Determine which Array we have to query
        string sArrayToSearch = CS_IPNAMES_ARRAY_IP + IntToString(iID);
        if (iVar1 != -1)
            sArrayToSearch += "_V1_" + IntToString(iVar1);
        if (iVar2 != -1)
            sArrayToSearch += "_V2_" + IntToString(iVar2);

        //SendMessageToAllDMs("Searching for Name in: " + sArrayToSearch);
        string sNameInfo = eas_SArray_Entry_Get(oStore, sArrayToSearch, Random(eas_Array_GetSize(oStore, sArrayToSearch)));

        // if sNameInfo is empty, try without V2 when it was set
        if (sNameInfo == "" && iVar2 != -1)
        {
            sArrayToSearch = CS_IPNAMES_ARRAY_IP + IntToString(iID) + "_V1_" + IntToString(iVar1);
            //SendMessageToAllDMs("Not found, trying: " + sArrayToSearch);
            sNameInfo = eas_SArray_Entry_Get(oStore, sArrayToSearch, Random(eas_Array_GetSize(oStore, sArrayToSearch)));
        }

        // if there is still no result, try without V1 when it was set
        if (sNameInfo == "" && iVar1 != -1)
        {
            sArrayToSearch = CS_IPNAMES_ARRAY_IP + IntToString(iID);
            //SendMessageToAllDMs("Not found, trying: " + sArrayToSearch);
            sNameInfo = eas_SArray_Entry_Get(oStore, sArrayToSearch, Random(eas_Array_GetSize(oStore, sArrayToSearch)));
        }

        //SendMessageToAllDMs("Found Info Item: " + sNameInfo);
        sResult = GetLocalString(oStore, sFix + sNameInfo);

        if (sResult == "")
        {
            //SendMessageToAllDMs("Error fetching property name string");
        }
    }
    return (sResult);
}

void ip_EvaluateItem(object oItem, int iPositiveProps, int iNegativeProps, int iRestrictiveProps, int iPositivePropsWithinRareDeviation, int iPositivePropsWithinEpicDeviation)
{
   int iNumberOfProperties = iPositiveProps + iNegativeProps + iRestrictiveProps;
   string sMessage = "Added " + color_ConvertString(IntToString(iNumberOfProperties), COLOR_CYAN) + " Properties to " + color_ConvertString(GetName(oItem), COLOR_PURPLE) + "\n";

   // If Item is a potion, name it after the spell
   int iBaseItemType = GetBaseItemType(oItem);
   itemproperty specialprop;
   int nRandom;
   switch (iBaseItemType)
   {
   case BASE_ITEM_BOOK:
            if (iPositiveProps == 1)
            {
                specialprop = GetFirstItemProperty(oItem);
                SetName(oItem, color_ConvertString("Book of " + GetStringByStrRef(StringToInt(Get2DAString("iprp_spells", "Name", GetItemPropertySubType(specialprop)))), COLOR_PREDEFINED_ITEM_UNCOMMON));
            }
            else
            {
                nRandom = Random(6);
                switch (nRandom)
                {
                    case 0: SetName(oItem, color_ConvertString("Tome of Magic", COLOR_PREDEFINED_ITEM_RARE)); break;
                    case 1: SetName(oItem, color_ConvertString("Magical Tome", COLOR_PREDEFINED_ITEM_RARE)); break;
                    case 2: SetName(oItem, color_ConvertString("Book of Magic", COLOR_PREDEFINED_ITEM_RARE)); break;
                    case 3: SetName(oItem, color_ConvertString("Magical Book", COLOR_PREDEFINED_ITEM_RARE)); break;
                    case 4: SetName(oItem, color_ConvertString("Magical Almanac", COLOR_PREDEFINED_ITEM_RARE)); break;
                    case 5: SetName(oItem, color_ConvertString("Almanac of Magic", COLOR_PREDEFINED_ITEM_RARE)); break;
                }
            }
        break;
   case BASE_ITEM_POTIONS:
            specialprop = GetFirstItemProperty(oItem);
            SetName(oItem, "Potion of " + GetStringByStrRef(StringToInt(Get2DAString("iprp_spells", "Name", GetItemPropertySubType(specialprop)))));
            return;
        break;
   case BASE_ITEM_MAGICWAND:
            specialprop = GetFirstItemProperty(oItem);
            SetName(oItem, "Wand of " + GetStringByStrRef(StringToInt(Get2DAString("iprp_spells", "Name", GetItemPropertySubType(specialprop)))));
            return;
        break;
   case BASE_ITEM_MAGICROD:
            specialprop = GetFirstItemProperty(oItem);
            SetName(oItem, "Rod of " + GetStringByStrRef(StringToInt(Get2DAString("iprp_spells", "Name", GetItemPropertySubType(specialprop)))));
            return;
        break;
   case BASE_ITEM_THIEVESTOOLS:
            specialprop = GetFirstItemProperty(oItem);
            SetName(oItem, "Thieves' Tools +" + IntToString(GetItemPropertyCostTableValue(specialprop)));
            return;
        break;
   case BASE_ITEM_HEALERSKIT:
            specialprop = GetFirstItemProperty(oItem);
            SetName(oItem, "Healer's Kit +" + IntToString(GetItemPropertyCostTableValue(specialprop)));
            return;
        break;
   case BASE_ITEM_TRAPKIT:
            specialprop = GetFirstItemProperty(oItem);
            SetName(oItem, "Trap Kit (" + GetStringByStrRef(StringToInt(Get2DAString("iprp_traps", "Name", GetItemPropertySubType(specialprop)))) + " " +
                                          GetStringByStrRef(StringToInt(Get2DAString("iprp_trapcost", "Name", GetItemPropertyCostTableValue(specialprop)))) + ")");
            return;
        break;
   }

   string sPrefix1 = "";
   string sPrefix2 = "";
   string sPostfix = "";
   string sItemName = "";
   int iCurrentProp;
   int iID;
   int iVar1;
   int iVar2;
   int iVar3;
   int iLvl;
   int iItemLevel = GetLocalInt(oItem, "Property1Lvl");

   /* DEBUG STUFF
   for (iCurrentProp = 1; iCurrentProp < iNumberOfProperties + 1; iCurrentProp++)
   {
      iID = GetLocalInt(oItem, "Property" + IntToString(iCurrentProp) + "ID");
      iVar1 = GetLocalInt(oItem, "Property" + IntToString(iCurrentProp) + "Var1");
      iVar2 = GetLocalInt(oItem, "Property" + IntToString(iCurrentProp) + "Var2");
      iVar3 = GetLocalInt(oItem, "Property" + IntToString(iCurrentProp) + "Var3");
      iLvl = GetLocalInt(oItem, "Property" + IntToString(iCurrentProp) + "Lvl");
      sMessage += "Property " + color_ConvertString(IntToString(iCurrentProp), "606") + "\n";
      sMessage += "ID: " + color_ConvertString(IntToString(iID), "060") + "\n";
      sMessage += "Level: " + color_ConvertString(IntToString(iLvl), "606" + "\n";
      sMessage += "Var1: " + color_ConvertString(IntToString(iVar1), "060" + "\n";
      sMessage += "Var2: " + color_ConvertString(IntToString(iVar2), "060" + "\n";
      sMessage += "Var3: " + color_ConvertString(IntToString(iVar3), "060" + "\n";
   }
   */

   // Select the appropriate item color, standard is UNCOMMON
   string sColor = COLOR_PREDEFINED_ITEM_UNCOMMON;
   if (iPositivePropsWithinEpicDeviation >= CI_IP_EPIC_MINPOSITIVE &&
       iNegativeProps <= CI_IP_EPIC_MAXNEGATIVE)
       sColor = COLOR_PREDEFINED_ITEM_EPIC;
   else if (iPositivePropsWithinRareDeviation >= CI_IP_RARE_MINPOSITIVE &&
       iNegativeProps <= CI_IP_RARE_MAXNEGATIVE)
       sColor = COLOR_PREDEFINED_ITEM_RARE;

   if (iNumberOfProperties > 3)
   {
      int nRareVariant = Random(2);
      switch (nRareVariant)
      {
         case 0: sItemName = color_ConvertString(RandomName(Random(24)-1) + "'s " + GetName(oItem), sColor); break;
         case 1: sItemName = color_ConvertString(GetName(oItem) + " of " + RandomName(Random(24)-1), sColor); break;
      }
   }
   else if (iNumberOfProperties == 1)
   {
      // For only one property, we can kinda decide wheter we want a pre- or postfix
      int nPropertyID_1 = GetLocalInt(oItem, "Property1ID");
      int iRandom = Random(2);
      if (iRandom == 0)
      {
         // Prefix selected
         sPrefix1 = ip_GetPropertyName(GetLocalInt(oItem, "Property1ID"),
                                         GetLocalInt(oItem, "Property1Var1"),
                                         GetLocalInt(oItem, "Property1Var2"),
                                         GetLocalInt(oItem, "Property1Var3"),
                                         GetLocalInt(oItem, "Property1Lvl"),
                                         CS_IP_NAME_PREFIX_I);
      }
      else
      {
         // Postfix selected
         sPostfix = ip_GetPropertyName(GetLocalInt(oItem, "Property1ID"),
                                         GetLocalInt(oItem, "Property1Var1"),
                                         GetLocalInt(oItem, "Property1Var2"),
                                         GetLocalInt(oItem, "Property1Var3"),
                                         GetLocalInt(oItem, "Property1Lvl"),
                                         CS_IP_NAME_POSTFIX);
      }
   }
   else if (iNumberOfProperties == 2)
   {
      int nPropertyID_1 = GetLocalInt(oItem, "Property1ID");
      int nPropertyID_2 = GetLocalInt(oItem, "Property2ID");
      // Get Prefix_I
      sPrefix1 = ip_GetPropertyName(GetLocalInt(oItem, "Property1ID"),
                                         GetLocalInt(oItem, "Property1Var1"),
                                         GetLocalInt(oItem, "Property1Var2"),
                                         GetLocalInt(oItem, "Property1Var3"),
                                         GetLocalInt(oItem, "Property1Lvl"),
                                         CS_IP_NAME_PREFIX_I);

      // if property one and two are the same, don't add a second name
      if (nPropertyID_1 != nPropertyID_2)
      {
         // For two properties, do we want the second thing be Prefix_II or Postfix?
         int iRandom = Random(2);
         if (iRandom == 0)
         {
            // Prefix selected
            sPrefix2 = ip_GetPropertyName(GetLocalInt(oItem, "Property2ID"),
                                            GetLocalInt(oItem, "Property2Var1"),
                                            GetLocalInt(oItem, "Property2Var2"),
                                            GetLocalInt(oItem, "Property2Var3"),
                                            GetLocalInt(oItem, "Property2Lvl"),
                                            CS_IP_NAME_PREFIX_II);
            if (sPrefix2 == sPrefix1)
               sPrefix2 = "";
         }
         else
         {
            // Postfix selected
            sPostfix = ip_GetPropertyName(GetLocalInt(oItem, "Property2ID"),
                                            GetLocalInt(oItem, "Property2Var1"),
                                            GetLocalInt(oItem, "Property2Var2"),
                                            GetLocalInt(oItem, "Property2Var3"),
                                            GetLocalInt(oItem, "Property2Lvl"),
                                            CS_IP_NAME_POSTFIX);
         }
      }
   }
   else if (iNumberOfProperties == 3)
   {
      int nPropertyID_1 = GetLocalInt(oItem, "Property1ID");
      int nPropertyID_2 = GetLocalInt(oItem, "Property2ID");
      int nPropertyID_3 = GetLocalInt(oItem, "Property2ID");

      // Three Properties, get them one by one
      sPrefix1 = ip_GetPropertyName(GetLocalInt(oItem, "Property1ID"),
                                         GetLocalInt(oItem, "Property1Var1"),
                                         GetLocalInt(oItem, "Property1Var2"),
                                         GetLocalInt(oItem, "Property1Var3"),
                                         GetLocalInt(oItem, "Property1Lvl"),
                                         CS_IP_NAME_PREFIX_I);

      // if property one and two are the same, don't add a second name
      if (nPropertyID_1 != nPropertyID_2)
      {
         sPrefix2 = ip_GetPropertyName(GetLocalInt(oItem, "Property2ID"),
                                         GetLocalInt(oItem, "Property2Var1"),
                                         GetLocalInt(oItem, "Property2Var2"),
                                         GetLocalInt(oItem, "Property2Var3"),
                                         GetLocalInt(oItem, "Property2Lvl"),
                                         CS_IP_NAME_PREFIX_II);
         if (sPrefix2 == sPrefix1)
            sPrefix2 = "";
      }

      // if property one and two are the same, don't add a second name
      if (nPropertyID_1 != nPropertyID_3 &&
          nPropertyID_2 != nPropertyID_3)
      {
         sPostfix = ip_GetPropertyName(GetLocalInt(oItem, "Property3ID"),
                                         GetLocalInt(oItem, "Property3Var1"),
                                         GetLocalInt(oItem, "Property3Var2"),
                                         GetLocalInt(oItem, "Property3Var3"),
                                         GetLocalInt(oItem, "Property3Lvl"),
                                         CS_IP_NAME_POSTFIX);
      }
   }

   // Fix up the whole pre and postfixes
   if (sPrefix1 != "")
      sPrefix1 += " ";
   if (sPrefix2 != "")
      sPrefix2 += " ";
   if (sPostfix != "")
      sPostfix = " " + sPostfix;

   // If Item not rare, then build the name
   if (sItemName == "")
   {
      if (iNumberOfProperties != 0)
         sItemName = color_ConvertString(sPrefix1 + sPrefix2 + GetName(oItem) + sPostfix, sColor);
   }

   // Delete all info on the item
   DeleteLocalInt(oItem, "Property" + IntToString(iCurrentProp) + "ID");
   DeleteLocalInt(oItem, "Property" + IntToString(iCurrentProp) + "Var1");
   DeleteLocalInt(oItem, "Property" + IntToString(iCurrentProp) + "Var2");
   DeleteLocalInt(oItem, "Property" + IntToString(iCurrentProp) + "Var3");
   DeleteLocalInt(oItem, "Property" + IntToString(iCurrentProp) + "Lvl");

   // Finally set the brand new item name
   sMessage += "Naming Item " + sItemName;
   //SendMessageToAllDMs(sMessage);
   SetName(oItem, sItemName);
}

void ip_InitializeItemNames_01()
{
   // Ability Bonus (Strength)
   ip_SetPropertyName(CI_IP_AbilityBonus, IP_CONST_ABILITY_STR, -1, -1, 1, 50, "Mighty", "Mighty", "of Bulls Strength");
   // Ability Bonus (Dexterity)
   ip_SetPropertyName(CI_IP_AbilityBonus, IP_CONST_ABILITY_DEX, -1, -1, 1, 50, "Agile", "Dexterous", "of Cats Grace");
   // Ability Bonus (Constitution)
   ip_SetPropertyName(CI_IP_AbilityBonus, IP_CONST_ABILITY_CON, -1, -1, 1, 50, "Hearty", "Hearty", "of Bear Endurance");
   // Ability Bonus (Wisdom)
   ip_SetPropertyName(CI_IP_AbilityBonus, IP_CONST_ABILITY_WIS, -1, -1, 1, 50, "Enlightened", "Enlightening", "of Owls Wisdom");
   // Ability Bonus (Intelligence)
   ip_SetPropertyName(CI_IP_AbilityBonus, IP_CONST_ABILITY_INT, -1, -1, 1, 50, "Cunning", "Witty", "of Fox Cunning");
   // Ability Bonus (Charisma)
   ip_SetPropertyName(CI_IP_AbilityBonus, IP_CONST_ABILITY_CHA, -1, -1, 1, 50, "Magestic", "Alluring", "of Eagle Splendors");

   // AC Bonus
   ip_SetPropertyName(CI_IP_ACBonus, -1, -1, -1, 1, 50, "Shielding", "Defending", "of Protection");
   // AC Bonus vs. Alignmentgroup (Good)
   ip_SetPropertyName(CI_IP_ACBonusVsAlign, IP_CONST_ALIGNMENTGROUP_GOOD, -1, -1, 1, 50, "Demonic", "Fiendish", "of the Demon");
   // AC Bonus vs. Alignmentgroup (Evil)
   ip_SetPropertyName(CI_IP_ACBonusVsAlign, IP_CONST_ALIGNMENTGROUP_EVIL, -1, -1, 1, 50, "Pure", "Good", "of the Avatar");
   // AC Bonus vs. Alignmentgroup (Lawful)
   ip_SetPropertyName(CI_IP_ACBonusVsAlign, IP_CONST_ALIGNMENTGROUP_LAWFUL, -1, -1, 1, 50, "Turbulent", "Chaotic", "of Unrest");
   // AC Bonus vs. Alignmentgroup (Neutral)
   ip_SetPropertyName(CI_IP_ACBonusVsAlign, IP_CONST_ALIGNMENTGROUP_NEUTRAL, -1, -1, 1, 50, "Irregular", "Irregular", "of Difference");
   // AC Bonus vs. Alignmentgroup (Chaotic)
   ip_SetPropertyName(CI_IP_ACBonusVsAlign, IP_CONST_ALIGNMENTGROUP_CHAOTIC, -1, -1, 1, 50, "Just", "Lawful", "of Order");
   // AC Bonus vs. Damage Type (Slashing)
   ip_SetPropertyName(CI_IP_ACBonusVsDmgType, IP_CONST_DAMAGETYPE_SLASHING, -1, -1, 1, 50, "Mesh", "Mesh", "of Mesh");
   // AC Bonus vs. Damage Type (Piercing)
   ip_SetPropertyName(CI_IP_ACBonusVsDmgType, IP_CONST_DAMAGETYPE_PIERCING, -1, -1, 1, 50, "Woven", "Woven", "of Tight Weave");
   // AC Bonus vs. Damage Type (Bludgeoning)
   ip_SetPropertyName(CI_IP_ACBonusVsDmgType, IP_CONST_DAMAGETYPE_BLUDGEONING, -1, -1, 1, 50, "Padded", "Padded", "of Dampening");
   // AC Bonus vs. Racial Type (Abberations)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_ABERRATION, -1, -1, 1, 50, "Securing", "Securing", "of Conforming");
   // AC Bonus vs. Racial Type (Animals)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_ANIMAL, -1, -1, 1, 50, "Harmonious", "Harmonious", "of Harmony");
   // AC Bonus vs. Racial Type (Beasts)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_BEAST, -1, -1, 1, 50, "Domesticating", "Taming", "of Domestication");
   // AC Bonus vs. Racial Type (Constructs)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_CONSTRUCT, -1, -1, 1, 50, "Disjucting", "Disjucting", "of Disjunction");
   // AC Bonus vs. Racial Type (Dragons)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_DRAGON, -1, -1, 1, 50, "Draconic", "Draconic", "of Dragon");
   // AC Bonus vs. Racial Type (Dwarves)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_DWARF, -1, -1, 1, 50, "Tenuous", "Tenuous", "of Tenuity");
   // AC Bonus vs. Racial Type (Elementals)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_ELEMENTAL, -1, -1, 1, 50, "Supernatural", "Supernatural", "of Supernature");
   // AC Bonus vs. Racial Type (Elves)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_ELF, -1, -1, 1, 50, "Inelegant", "Truculent", "of Disgrace");
   // AC Bonus vs. Racial Type (Fey)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_FEY, -1, -1, 1, 50, "Factual", "Factual", "of Reality");
   // AC Bonus vs. Racial Type (Giants)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_GIANT, -1, -1, 1, 50, "Giants", "Giants", "of Giant Defense");
   // AC Bonus vs. Racial Type (Gnome)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_GNOME, -1, -1, 1, 50, "Gnomes", "Gnomes", "of Gnome Defense");
   // AC Bonus vs. Racial Type (Halfelf)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_HALFELF, -1, -1, 1, 50, "Half Elves", "Half Elf", "of Half Elf Defence");
   // AC Bonus vs. Racial Type (Halfling)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_HALFLING, -1, -1, 1, 50, "Halflings", "Halflings", "of Halfling Defense");
   // AC Bonus vs. Racial Type (Halforc)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_HALFORC, -1, -1, 1, 50, "Orcish", "Orcish", "of Orcish Defence");
   // AC Bonus vs. Racial Type (Human)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_HUMAN, -1, -1, 1, 50, "Humans", "Humans", "of Human Defence");
   // AC Bonus vs. Racial Type (Goblinoid)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, -1, -1, 1, 50, "Goblins", "Goblins", "of Goblin Defense");
   // AC Bonus vs. Racial Type (Humanoid Monstrous)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, -1, -1, 1, 50, "Monstrous", "Monstrous", "of Monstrous Defense");
   // AC Bonus vs. Racial Type (Orc)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_HUMANOID_ORC, -1, -1, 1, 50, "Orcs", "Orcs", "of Orcish Defense");
   // AC Bonus vs. Racial Type (Humanoid Reptilian)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN, -1, -1, 1, 50, "Reptiles", "Reptiles", "of Snake Defense");
   // AC Bonus vs. Racial Type (Magical Beast)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_MAGICAL_BEAST, -1, -1, 1, 50, "Beasts", "Beasts", "of Beastial Defense");
   // AC Bonus vs. Racial Type (Outsider)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_OUTSIDER, -1, -1, 1, 50, "Outsiders", "Outsiders", "of Outsider Defense");
   // AC Bonus vs. Racial Type (Shapechanger)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_SHAPECHANGER, -1, -1, 1, 50, "Shape Changers", "Shape Changers", "of Changer Defense");
   // AC Bonus vs. Racial Type (Undead)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_UNDEAD, -1, -1, 1, 50, "Holy", "Holy", "of the Holy");
   // AC Bonus vs. Racial Type (Vermin)
   ip_SetPropertyName(CI_IP_ACBonusVsRace, IP_CONST_RACIALTYPE_VERMIN, -1, -1, 1, 50, "Vermin", "Vermin", "of Vermin Defense");
   // AC Bonus vs. Specific Alignment (Lawful Good)
   ip_SetPropertyName(CI_IP_ACBonusVsSAlign, IP_CONST_ALIGNMENT_LG, -1, -1, 1, 50, "Chaotic", "Chaotic", "of Chaos");
   // AC Bonus vs. Specific Alignment (Neutral Good)
   ip_SetPropertyName(CI_IP_ACBonusVsSAlign, IP_CONST_ALIGNMENT_NG, -1, -1, 1, 50, "Atrocious", "Atrocious", "of defined Evil");
   // AC Bonus vs. Specific Alignment (Chaotic Good)
   ip_SetPropertyName(CI_IP_ACBonusVsSAlign, IP_CONST_ALIGNMENT_CG, -1, -1, 1, 50, "Wicked", "Wicked", "of Adversary");
   // AC Bonus vs. Specific Alignment (Lawful Neutral)
   ip_SetPropertyName(CI_IP_ACBonusVsSAlign, IP_CONST_ALIGNMENT_LN, -1, -1, 1, 50, "Deciding", "Deciding", "of Freedom");
   // AC Bonus vs. Specific Alignment (True Neutral)
   ip_SetPropertyName(CI_IP_ACBonusVsSAlign, IP_CONST_ALIGNMENT_TN, -1, -1, 1, 50, "Resolute", "Resolute", "of Choice");
   // AC Bonus vs. Specific Alignment (Chaotic Neutral)
   ip_SetPropertyName(CI_IP_ACBonusVsSAlign, IP_CONST_ALIGNMENT_CN, -1, -1, 1, 50, "Contracting", "Contracting", "of Stipulation");
   // AC Bonus vs. Specific Alignment (Lawful Evil)
   ip_SetPropertyName(CI_IP_ACBonusVsSAlign, IP_CONST_ALIGNMENT_LE, -1, -1, 1, 50, "Rebellious", "Rebellious", "of the Rebels");
   // AC Bonus vs. Specific Alignment (Neutral Evil)
   ip_SetPropertyName(CI_IP_ACBonusVsSAlign, IP_CONST_ALIGNMENT_NE, -1, -1, 1, 50, "Selfish", "Selfish", "of Selfishness");
   // AC Bonus vs. Specific Alignment (Chaotic Evil)
   ip_SetPropertyName(CI_IP_ACBonusVsSAlign, IP_CONST_ALIGNMENT_CE, -1, -1, 1, 50, "Protective", "Protective", "of the Protector");

   // Arcane Spell Failure
   ip_SetPropertyName(CI_IP_ArcaneSpellFailure, -1, -1, -1, 1, 50, "Delicate", "Delicate", "of the Weave");
}

void ip_InitializeItemNames_02()
{
   // Attack Bonus
   ip_SetPropertyName(CI_IP_AttackBonus, -1, -1, -1, 1, 50, "Enhanced", "Accurate", "of Accuracy");
   // Attack Bonus vs. Alignment Group (Good)
   ip_SetPropertyName(CI_IP_AttackBonusVsAlign, ALIGNMENT_GOOD, -1, -1, 1, 50, "Evil", "Destructive", "of Evil Deeds");
   // Attack Bonus vs. Alignment Group (Evil)
   ip_SetPropertyName(CI_IP_AttackBonusVsAlign, ALIGNMENT_EVIL, -1, -1, 1, 50, "Good", "Pure", "of Good Deeds");
   // Attack Bonus vs. Alignment Group (Lawful)
   ip_SetPropertyName(CI_IP_AttackBonusVsAlign, ALIGNMENT_LAWFUL, -1, -1, 1, 50, "Chaotic", "Chatoic", "of Chaos");
   // Attack Bonus vs. Alignment Group (Neutral)
   ip_SetPropertyName(CI_IP_AttackBonusVsAlign, ALIGNMENT_NEUTRAL, -1, -1, 1, 50, "Irregular", "Unstable", "of Unstability");
   // Attack Bonus vs. Alignment Group (Chaotic)
   ip_SetPropertyName(CI_IP_AttackBonusVsAlign, ALIGNMENT_CHAOTIC, -1, -1, 1, 50, "Lawful", "Lawful", "of Justice");
   // Attack Bonus vs. Race (Abberations)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_ABERRATION, -1, -1, 1, 50, "Regular", "Regular", "of Regularity");
   // Attack Bonus vs. Race (Animals)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_ANIMAL, -1, -1, 1, 50, "Unnatural", "Unnatural", "of Extinction");
   // Attack Bonus vs. Race (Beasts)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_BEAST, -1, -1, 1, 50, "Beastmaster's", "Beastmaster's", "of Taming");
   // Attack Bonus vs. Race (Constructs)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_CONSTRUCT, -1, -1, 1, 50, "Demolishing", "Demolishing", "of Wrecking");
   // Attack Bonus vs. Race (Dragon)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_DRAGON, -1, -1, 1, 50, "Dragonslayer's", "Dragonslayer's", "of Dragonslaying");
   // Attack Bonus vs. Race (Dwarves)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_DWARF, -1, -1, 1, 50, "", "", "");
   // Attack Bonus vs. Race (Elemental)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_ELEMENTAL, -1, -1, 1, 50, "Calming", "Calming", "of Calming");
   // Attack Bonus vs. Race (Elf)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_ELF, -1, -1, 1, 50, "", "", "");
   // Attack Bonus vs. Race (Fey)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_FEY, -1, -1, 1, 50, "", "", "");
   // Attack Bonus vs. Race (Giant)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_GIANT, -1, -1, 1, 50, "Giantslayer's", "Giantslayer's", "of Giantslaying");
   // Attack Bonus vs. Race (Gnome)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_GNOME, -1, -1, 1, 50, "", "", "");
   // Attack Bonus vs. Race (Halfelf)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_HALFELF, -1, -1, 1, 50, "", "", "");
   // Attack Bonus vs. Race (Halfling)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_HALFLING, -1, -1, 1, 50, "", "", "");
   // Attack Bonus vs. Race (Halforc)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_HALFORC, -1, -1, 1, 50, "", "", "");
   // Attack Bonus vs. Race (Human)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_HUMAN, -1, -1, 1, 50, "Assassin's", "Assassin's", "of the Assassin");
   // Attack Bonus vs. Race (Goblinoid)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, -1, -1, 1, 50, "", "", "");
   // Attack Bonus vs. Race (Monstrous)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, -1, -1, 1, 50, "", "", "");
   // Attack Bonus vs. Race (Orc)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_HUMANOID_ORC, -1, -1, 1, 50, "", "", "");
   // Attack Bonus vs. Race (Reptilian)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN, -1, -1, 1, 50, "", "", "");
   // Attack Bonus vs. Race (Magical Beasts)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_MAGICAL_BEAST, -1, -1, 1, 50, "", "", "");
   // Attack Bonus vs. Race (Outsider)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_OUTSIDER, -1, -1, 1, 50, "", "", "");
   // Attack Bonus vs. Race (Shapechanger)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_SHAPECHANGER, -1, -1, 1, 50, "", "", "");
   // Attack Bonus vs. Race (Undead)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_UNDEAD, -1, -1, 1, 50, "Silver", "Silver", "of Shimmering");
   // Attack Bonus vs. Race (Vermin)
   ip_SetPropertyName(CI_IP_AttackBonusVsRace, IP_CONST_RACIALTYPE_VERMIN, -1, -1, 1, 50, "", "", "");
   // Attack Bonus vs. Specific Alignment (Lawful Good)
   ip_SetPropertyName(CI_IP_AttackBonusVsSAlign, IP_CONST_ALIGNMENT_LG, -1, -1, 1, 50, "", "","");
   // Attack Bonus vs. Specific Alignment (Neutral Good)
   ip_SetPropertyName(CI_IP_AttackBonusVsSAlign, IP_CONST_ALIGNMENT_NG, -1, -1, 1, 50, "", "","");
   // Attack Bonus vs. Specific Alignment (Chaotic Good)
   ip_SetPropertyName(CI_IP_AttackBonusVsSAlign, IP_CONST_ALIGNMENT_CG, -1, -1, 1, 50, "", "","");
   // Attack Bonus vs. Specific Alignment (Lawful Neutral)
   ip_SetPropertyName(CI_IP_AttackBonusVsSAlign, IP_CONST_ALIGNMENT_LN, -1, -1, 1, 50, "", "","");
   // Attack Bonus vs. Specific Alignment (True Neutral)
   ip_SetPropertyName(CI_IP_AttackBonusVsSAlign, IP_CONST_ALIGNMENT_TN, -1, -1, 1, 50, "", "","");
   // Attack Bonus vs. Specific Alignment (Chaotic Neutral)
   ip_SetPropertyName(CI_IP_AttackBonusVsSAlign, IP_CONST_ALIGNMENT_CN, -1, -1, 1, 50, "", "","");
   // Attack Bonus vs. Specific Alignment (Lawful Evil)
   ip_SetPropertyName(CI_IP_AttackBonusVsSAlign, IP_CONST_ALIGNMENT_LE, -1, -1, 1, 50, "", "","");
   // Attack Bonus vs. Specific Alignment (Neutral Evil)
   ip_SetPropertyName(CI_IP_AttackBonusVsSAlign, IP_CONST_ALIGNMENT_NE, -1, -1, 1, 50, "", "","");
   // Attack Bonus vs. Specific Alignment (Chaotic Evil)
   ip_SetPropertyName(CI_IP_AttackBonusVsSAlign, IP_CONST_ALIGNMENT_CE, -1, -1, 1, 50, "", "","");

   // Attack Penalty
   ip_SetPropertyName(CI_IP_AttackPenalty, -1, -1, -1, 1, 50, "Clumsy", "Clumsy", "of Failing");

   // Bonus Feat (Alertness)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_ALERTNESS, -1, -1, 1, 50, "Observant", "Perceptive", "of Awareness");
   // Bonus Feat (Ambidexterity)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_AMBIDEXTROUS, -1, -1, 1, 50, "Ambidextrous", "Ambidextrous", "of Ambidexterity");
   // Bonus Feat (Armor Proficiency: Heavy)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_ARMOR_PROF_HEAVY, -1, -1, 1, 50, "Greater Defensive", "Greater Defensive", "of Greater Defense");
   // Bonus Feat (Armor Proficiency: Light)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_ARMOR_PROF_LIGHT, -1, -1, 1, 50, "Lesser Defensive", "Lesser Defensive", "of Lesser Defense");
   // Bonus Feat (Armor Proficiency: Medium)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_ARMOR_PROF_MEDIUM, -1, -1, 1, 50, "Defensive", "Defensive", "of Defense");
   // Bonus Feat (Cleave)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_CLEAVE, -1, -1, 1, 50, "Carving", "Hacking", "of Seperation");
   // Bonus Feat (Combat Casting)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_COMBAT_CASTING, -1, -1, 1, 50, "Stable", "Stable", "of Stability");
   // Bonus Feat (Dodge)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_DODGE, -1, -1, 1, 50, "Avoiding", "Eluding", "of Recoil");
   // Bonus Feat (Extra Turning)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_EXTRA_TURNING, -1, -1, 1, 50, "Crumbling", "Crumbling", "of Crumbling Bones");
   // Bonus Feat (Improved Critical: Unarmed)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_IMPCRITUNARM, -1, -1, 1, 50, "Critical", "Thrashing", "of Pain");
   // Bonus Feat (Knockdown)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_KNOCKDOWN, -1, -1, 1, 50, "Tripping", "Sweeping", "of Abuse");
   // Bonus Feat (Point Blank Shot)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_POINTBLANK, -1, -1, 1, 50, "Sharpened", "Marked", "of Intention");
   // Bonus Feat (Power Attack)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_POWERATTACK, -1, -1, 1, 50, "Forceful", "Forceful", "of Force");
   // Bonus Feat (Spell Focus: Abjuration)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_SPELLFOCUSABJ, -1, -1, 1, 50, "Abjuring", "Abjuring", "of Abjuration");
   // Bonus Feat (Spell Focus: Conjuration)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_SPELLFOCUSCON, -1, -1, 1, 50, "Conjuring", "Commanding", "of Conjuration");
   // Bonus Feat (Spell Focus: Divination)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_SPELLFOCUSDIV, -1, -1, 1, 50, "Divinatory", "Faithful", "of Divination");
   // Bonus Feat (Spell Focus: Enchantment)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_SPELLFOCUSENC, -1, -1, 1, 50, "Enchanting", "Blissful", "of Enchantment");
   // Bonus Feat (Spell Focus: Evocation)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_SPELLFOCUSEVO, -1, -1, 1, 50, "Spiritual", "Spiritual", "of Evocation");
   // Bonus Feat (Spell Focus: Illusion)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_SPELLFOCUSILL, -1, -1, 1, 50, "Tricky", "Tricky", "of Illusion");
   // Bonus Feat (Spell Focus: Necromancy)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_SPELLFOCUSNEC, -1, -1, 1, 50, "Undead", "Deadly", "of the Dead");
   // Bonus Feat (Spell Penetration)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_SPELLPENETRATION, -1, -1, 1, 50, "Piercing", "Piercing", "of Penetration");
   // Bonus Feat (Two-Weapon Fighting)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_TWO_WEAPON_FIGHTING, -1, -1, 1, 50, "Dual", "Dual", "of Dual Wielding");
   // Bonus Feat (Weapon Finesse)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_WEAPFINESSE, -1, -1, 1, 50, "Quick", "Cunning", "of Ingenuity");
   // Bonus Feat (Weapon Proficiency: Exotic)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_WEAPON_PROF_EXOTIC, -1, -1, 1, 50, "Exotic", "Exotic", "of Exotic Combat");
   // Bonus Feat (Weapon Proficiency: Martial)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_WEAPON_PROF_MARTIAL, -1, -1, 1, 50, "Martial", "Martial", "of Martial Combat");
   // Bonus Feat (Weapon Proficiency: Simple)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_WEAPON_PROF_SIMPLE, -1, -1, 1, 50, "Simple", "Simple", "of Simple Combat");
   // Bonus Feat (Weapon Specialization: Unarmed)
   ip_SetPropertyName(CI_IP_BonusFeat, IP_CONST_FEAT_WEAPSPEUNARM, -1, -1, 1, 50, "Specialized", "Specialized", "of Martial Arts");

   // Bonus Level Spell (Bard)
   ip_SetPropertyName(CI_IP_BonusLevelSpell, IP_CONST_CLASS_BARD, -1, -1, 1, 50, "Artistic", "Artistic", "of Music");
   // Bonus Level Spell (Cleric)
   ip_SetPropertyName(CI_IP_BonusLevelSpell, IP_CONST_CLASS_CLERIC, -1, -1, 1, 50, "Divine", "Divine", "of Healing");
   // Bonus Level Spell (Druid)
   ip_SetPropertyName(CI_IP_BonusLevelSpell, IP_CONST_CLASS_DRUID, -1, -1, 1, 50, "Natural", "Natural", "of Nature");
   // Bonus Level Spell (Paladin)
   ip_SetPropertyName(CI_IP_BonusLevelSpell, IP_CONST_CLASS_PALADIN, -1, -1, 1, 50, "Righteous", "Righteous", "of Justice");
   // Bonus Level Spell (Ranger)
   ip_SetPropertyName(CI_IP_BonusLevelSpell, IP_CONST_CLASS_RANGER, -1, -1, 1, 50, "Spiritual", "Spritual", "of the Woods");
   // Bonus Level Spell (Sorcerer)
   ip_SetPropertyName(CI_IP_BonusLevelSpell, IP_CONST_CLASS_SORCERER, -1, -1, 1, 50, "Intuitive", "Intuitive", "of Innate Power");
   // Bonus Level Spell (Wizard)
   ip_SetPropertyName(CI_IP_BonusLevelSpell, IP_CONST_CLASS_WIZARD, -1, -1, 1, 50, "Arcane", "Arcane", "of Arcane Knowledge");
}

void ip_InitializeItemNames_03()
{
   // Bonus Saving Throw (Fortitude)
   ip_SetPropertyName(CI_IP_BonusSavingThrow, IP_CONST_SAVEBASETYPE_FORTITUDE, -1, -1, 1, 50, "Bold", "Firm", "of Valor");
   // Bonus Saving Throw (Reflex)
   ip_SetPropertyName(CI_IP_BonusSavingThrow, IP_CONST_SAVEBASETYPE_REFLEX, -1, -1, 1, 50, "Mobile", "Quick", "of Lightning Reflexes");
   // Bonus Saving Throw (Will)
   ip_SetPropertyName(CI_IP_BonusSavingThrow, IP_CONST_SAVEBASETYPE_WILL, -1, -1, 1, 50, "Wishful", "Mindful", "of Determination");
   // Bonus Saving Throw (Acid)
   ip_SetPropertyName(CI_IP_BonusSavingThrowVsX, IP_CONST_SAVEVS_ACID, -1, -1, 1, 50, "Basic", "Basic", "of Alkaline");
   // Bonus Saving Throw (Cold)
   ip_SetPropertyName(CI_IP_BonusSavingThrowVsX, IP_CONST_SAVEVS_COLD, -1, -1, 1, 50, "Warming", "Toasty", "of Warmth");
   // Bonus Saving Throw (Death)
   ip_SetPropertyName(CI_IP_BonusSavingThrowVsX, IP_CONST_SAVEVS_DEATH, -1, -1, 1, 50, "Vital", "Animating", "of Strong Soul");
   // Bonus Saving Throw (Disease)
   ip_SetPropertyName(CI_IP_BonusSavingThrowVsX, IP_CONST_SAVEVS_DISEASE, -1, -1, 1, 50, "Robust", "Robust", "of Health");
   // Bonus Saving Throw (Divine)
   ip_SetPropertyName(CI_IP_BonusSavingThrowVsX, IP_CONST_SAVEVS_DIVINE, -1, -1, 1, 50, "Profane", "Profane", "of Defilement");
   // Bonus Saving Throw (Electrical)
   ip_SetPropertyName(CI_IP_BonusSavingThrowVsX, IP_CONST_SAVEVS_ELECTRICAL, -1, -1, 1, 50, "Insulating", "Insulating", "of Insulation");
   // Bonus Saving Throw (Fear)
   ip_SetPropertyName(CI_IP_BonusSavingThrowVsX, IP_CONST_SAVEVS_FEAR, -1, -1, 1, 50, "Brave", "Fearless", "of Bravery");
   // Bonus Saving Throw (Fire)
   ip_SetPropertyName(CI_IP_BonusSavingThrowVsX, IP_CONST_SAVEVS_FIRE, -1, -1, 1, 50, "Extinguishing", "Cooling", "of Extinguishing");
   // Bonus Saving Throw (MindAffecting)
   ip_SetPropertyName(CI_IP_BonusSavingThrowVsX, IP_CONST_SAVEVS_MINDAFFECTING, -1, -1, 1, 50, "Untenible", "Untenible", "of Untentible Mind");
   // Bonus Saving Throw (Negative Energy)
   ip_SetPropertyName(CI_IP_BonusSavingThrowVsX, IP_CONST_SAVEVS_NEGATIVE, -1, -1, 1, 50, "Holy", "Heavenly", "from Heaven");
   // Bonus Saving Throw (Poison)
   ip_SetPropertyName(CI_IP_BonusSavingThrowVsX, IP_CONST_SAVEVS_POISON, -1, -1, 1, 50, "Robust", "Robust", "of Health");
   // Bonus Saving Throw (Positive Energy)
   ip_SetPropertyName(CI_IP_BonusSavingThrowVsX, IP_CONST_SAVEVS_POSITIVE, -1, -1, 1, 50, "Unholy", "Hellish", "from Hell");
   // Bonus Saving Throw (Sonic)
   ip_SetPropertyName(CI_IP_BonusSavingThrowVsX, IP_CONST_SAVEVS_SONIC, -1, -1, 1, 50, "Quiet", "Silencing", "of Silence");
   // Bonus Saving Throw (Universal) (Not used)
   ip_SetPropertyName(CI_IP_BonusSavingThrowVsX, IP_CONST_SAVEVS_UNIVERSAL, -1, -1, 1, 50, "Universal", "Universal", "of the Planes");

   // Bonus Spell Resistance
   ip_SetPropertyName(CI_IP_BonusSpellResistance, -1, -1, -1, 1, 50, "Resisting", "Resisting", "of Resistance");

   // Cast Spell
   ip_SetPropertyName(CI_IP_CastSpell, -1, -1, -1, 1, 50, "Magical", "Magical", "of Magic");

   // Container Reduced Weight
   ip_SetPropertyName(CI_IP_ContainerReducedWeight, -1, -1, -1, 1, 50, "Light", "Nimble", "of Holding");

   // Damage Bonus (Slashing)
   ip_SetPropertyName(CI_IP_DamageBonus, IP_CONST_DAMAGETYPE_SLASHING, -1, -1, 1, 50, "Gashing", "Carving", "of Slashing");
   // Damage Bonus (Piercing)
   ip_SetPropertyName(CI_IP_DamageBonus, IP_CONST_DAMAGETYPE_PIERCING, -1, -1, 1, 50, "Drilling", "Puncturing", "of Penetration");
   // Damage Bonus (Bludgeoning)
   ip_SetPropertyName(CI_IP_DamageBonus, IP_CONST_DAMAGETYPE_BLUDGEONING, -1, -1, 1, 50, "Battering", "Clobbering", "of Pounding");
   // Damage Bonus (Acid)
   ip_SetPropertyName(CI_IP_DamageBonus, IP_CONST_DAMAGETYPE_ACID, -1, -1, 1, 50, "Corrosive", "Corrosive", "of Corrosion");
   // Damage Bonus (Cold)
   ip_SetPropertyName(CI_IP_DamageBonus, IP_CONST_DAMAGETYPE_COLD, -1, -1, 1, 50, "Shivering", "Freezing", "of the Arctic");
   // Damage Bonus (Electrical)
   ip_SetPropertyName(CI_IP_DamageBonus, IP_CONST_DAMAGETYPE_ELECTRICAL, -1, -1, 1, 50, "Shocking", "Charged", "of the Storm");
   // Damage Bonus (Fire)
   ip_SetPropertyName(CI_IP_DamageBonus, IP_CONST_DAMAGETYPE_FIRE, -1, -1, 1, 50, "Fiery", "Scorching", "of Flames");
   // Damage Bonus (Sonic)
   ip_SetPropertyName(CI_IP_DamageBonus, IP_CONST_DAMAGETYPE_SONIC, -1, -1, 1, 50, "Audible", "Wailing", "of Sound");
}

void ip_InitializeItemNames_04()
{
   // In theory, we could check for both the Alignment Group/Race/Specific Alignment
   // AND the Damage Type, but that's overkill, so we're settling for the base information
   // Damage Bonus vs. Alignment Group (Good)
   ip_SetPropertyName(CI_IP_DamageBonusVsAlign, IP_CONST_ALIGNMENTGROUP_GOOD, -1, -1, 1, 50, "Hellish", "Unholy", "from Hell");
   // Damage Bonus vs. Alignment Group (Evil)
   ip_SetPropertyName(CI_IP_DamageBonusVsAlign, IP_CONST_ALIGNMENTGROUP_EVIL, -1, -1, 1, 50, "Heavenly", "Holy", "from Heaven");
   // Damage Bonus vs. Alignment Group (Lawful)
   ip_SetPropertyName(CI_IP_DamageBonusVsAlign, IP_CONST_ALIGNMENTGROUP_LAWFUL, -1, -1, 1, 50, "Chaotic", "Deranged", "of Disorder");
   // Damage Bonus vs. Alignment Group (Neutral)
   ip_SetPropertyName(CI_IP_DamageBonusVsAlign, IP_CONST_ALIGNMENTGROUP_NEUTRAL, -1, -1, 1, 50, "Unbalanced", "Unbalanced", "of Imbalance");
   // Damage Bonus vs. Alignment Group (Chaotic)
   ip_SetPropertyName(CI_IP_DamageBonusVsAlign, IP_CONST_ALIGNMENTGROUP_CHAOTIC, -1, -1, 1, 50, "Lawful", "Innocent", "of Order");
   // Damage Bonus vs. Race (Aberration)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_ABERRATION, -1, -1, 1, 50, "Typical", "Typical", "of Dead Oddities");
   // Damage Bonus vs. Race (Animals)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_ANIMAL, -1, -1, 1, 50, "Rotting", "Rotting", "of Chandler");
   // Damage Bonus vs. Race (Beast)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_BEAST, -1, -1, 1, 50, "Controlling", "Training", "of the Beastmaster");
   // Damage Bonus vs. Race (Construct)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_CONSTRUCT, -1, -1, 1, 50, "Demolishing", "Demolishing", "of Undoing");
   // Damage Bonus vs. Race (Dragons)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_DRAGON, -1, -1, 1, 50, "", "", "of Dragon Hearts");
   // Damage Bonus vs. Race (Dwarves)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_DWARF, -1, -1, 1, 50, "", "", "of the Short Beard");
   // Damage Bonus vs. Race (Elementals)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_ELEMENTAL, -1, -1, 1, 50, "", "", "of the Elements");
   // Damage Bonus vs. Race (Elf)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_ELF, -1, -1, 1, 50, "", "", "of Lolth");
   // Damage Bonus vs. Race (Fey)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_FEY, -1, -1, 1, 50, "", "", "of the Imp");
   // Damage Bonus vs. Race (Giant)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_GIANT, -1, -1, 1, 50, "", "", "of the Gnome");
   // Damage Bonus vs. Race (Gnome)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_GNOME, -1, -1, 1, 50, "", "", "");
   // Damage Bonus vs. Race (Halfelf)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_HALFELF, -1, -1, 1, 50, "", "", "");
   // Damage Bonus vs. Race (Halfling)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_HALFLING, -1, -1, 1, 50, "", "", "");
   // Damage Bonus vs. Race (Halforc)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_HALFORC, -1, -1, 1, 50, "", "", "");
   // Damage Bonus vs. Race (Human)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_HUMAN, -1, -1, 1, 50, "", "", "of Kinslaying");
   // Damage Bonus vs. Race (Goblinoids)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, -1, -1, 1, 50, "", "", "");
   // Damage Bonus vs. Race (Monstrous)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, -1, -1, 1, 50, "", "", "");
   // Damage Bonus vs. Race (Orc)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_HUMANOID_ORC, -1, -1, 1, 50, "", "", "");
   // Damage Bonus vs. Race (Reptilian)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN, -1, -1, 1, 50, "", "", "");
   // Damage Bonus vs. Race (Magical Beast)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_MAGICAL_BEAST, -1, -1, 1, 50, "", "", "");
   // Damage Bonus vs. Race (Outsider)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_OUTSIDER, -1, -1, 1, 50, "", "", "");
   // Damage Bonus vs. Race (Shapechanger)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_SHAPECHANGER, -1, -1, 1, 50, "", "", "");
   // Damage Bonus vs. Race (Undead)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_UNDEAD, -1, -1, 1, 50, "Blessed", "", "");
   // Damage Bonus vs. Race (Vermin)
   ip_SetPropertyName(CI_IP_DamageBonusVsRace, IP_CONST_RACIALTYPE_VERMIN, -1, -1, 1, 50, "", "", "");
   // Damage Bonus vs. Specific Alignment (Lawful Good)
   ip_SetPropertyName(CI_IP_DamageBonusVsSAlign, IP_CONST_ALIGNMENT_LG, -1, -1, 1, 50, "", "", "");
   // Damage Bonus vs. Specific Alignment (Neutral Good)
   ip_SetPropertyName(CI_IP_DamageBonusVsSAlign, IP_CONST_ALIGNMENT_NG, -1, -1, 1, 50, "", "", "");
   // Damage Bonus vs. Specific Alignment (Chaotic Good)
   ip_SetPropertyName(CI_IP_DamageBonusVsSAlign, IP_CONST_ALIGNMENT_CG, -1, -1, 1, 50, "", "", "");
   // Damage Bonus vs. Specific Alignment (Lawful Neutral)
   ip_SetPropertyName(CI_IP_DamageBonusVsSAlign, IP_CONST_ALIGNMENT_LN, -1, -1, 1, 50, "", "", "");
   // Damage Bonus vs. Specific Alignment (True Neutral)
   ip_SetPropertyName(CI_IP_DamageBonusVsSAlign, IP_CONST_ALIGNMENT_TN, -1, -1, 1, 50, "", "", "");
   // Damage Bonus vs. Specific Alignment (Chaotic Neutral)
   ip_SetPropertyName(CI_IP_DamageBonusVsSAlign, IP_CONST_ALIGNMENT_CN, -1, -1, 1, 50, "", "", "");
   // Damage Bonus vs. Specific Alignment (Lawful Evil)
   ip_SetPropertyName(CI_IP_DamageBonusVsSAlign, IP_CONST_ALIGNMENT_LE, -1, -1, 1, 50, "", "", "");
   // Damage Bonus vs. Specific Alignment (Neutral Evil)
   ip_SetPropertyName(CI_IP_DamageBonusVsSAlign, IP_CONST_ALIGNMENT_NE, -1, -1, 1, 50, "", "", "");
   // Damage Bonus vs. Specific Alignment (Chaotic Evil)
   ip_SetPropertyName(CI_IP_DamageBonusVsSAlign, IP_CONST_ALIGNMENT_CE, -1, -1, 1, 50, "", "", "");

   // Note: Damage Immunity is not total immunity. It's a percentage based immunity
   //       that goes 5, 10, 25, 50% for players, and 75, 90, 100% only on monsters
   // Damage Immunity (Slashing)
   ip_SetPropertyName(CI_IP_DamageImmunity, IP_CONST_DAMAGETYPE_SLASHING, -1, -1, 1, 50, "Heavily Augmented", "Heavily Augmented", "of Improved Augmentation");
   // Damage Immunity (Piercing)
   ip_SetPropertyName(CI_IP_DamageImmunity, IP_CONST_DAMAGETYPE_PIERCING, -1, -1, 1, 50, "Deflecting", "Deflecting", "of Total Deflection");
   // Damage Immunity (Bludgeoning)
   ip_SetPropertyName(CI_IP_DamageImmunity, IP_CONST_DAMAGETYPE_BLUDGEONING, -1, -1, 1, 50, "Iron-Sturdy", "Iron-Sturdy", "of Fortified Sturdiness");
   // Damage Immunity (Acid)
   ip_SetPropertyName(CI_IP_DamageImmunity, IP_CONST_DAMAGETYPE_ACID, -1, -1, 1, 50, "Stainless", "Stainless", "of Perfect Neturalisation");
   // Damage Immunity (Cold)
   ip_SetPropertyName(CI_IP_DamageImmunity, IP_CONST_DAMAGETYPE_COLD, -1, -1, 1, 50, "Soothing", "", "of Fierce Temperation");
   // Damage Immunity (Electrical)
   ip_SetPropertyName(CI_IP_DamageImmunity, IP_CONST_DAMAGETYPE_ELECTRICAL, -1, -1, 1, 50, "Rubbery", "Rubbery", "of Complete Impedence");
   // Damage Immunity (Fire)
   ip_SetPropertyName(CI_IP_DamageImmunity, IP_CONST_DAMAGETYPE_FIRE, -1, -1, 1, 50, "Smothering", "Smothering", "of Extinguishing");
   // Damage Immunity (Sonic)
   ip_SetPropertyName(CI_IP_DamageImmunity, IP_CONST_DAMAGETYPE_SONIC, -1, -1, 1, 50, "Insensible", "Insensible", "of Insensibility");

   // Damage Penalty
   ip_SetPropertyName(CI_IP_DamagePenalty, -1, -1, -1, 1, 50, "Harmless", "Harmless", "of Kindness");

   // Damage Reduction
   ip_SetPropertyName(CI_IP_DamageReduction, -1, -1, -1, 1, 50, "Absorbing", "Absorbing", "of Absorption");
}

void ip_InitializeItemNames_05()
{
   // Damage Resistance (Slashing)
   ip_SetPropertyName(CI_IP_DamageResistance, IP_CONST_DAMAGETYPE_SLASHING, -1, -1, 1, 50, "Augmented", "Augmented", "of Augmentation");
   // Damage Resistance (Piercing)
   ip_SetPropertyName(CI_IP_DamageResistance, IP_CONST_DAMAGETYPE_PIERCING, -1, -1, 1, 50, "Deflecting", "Deflecting", "of Deflection");
   // Damage Resistance (Bludgeoning)
   ip_SetPropertyName(CI_IP_DamageResistance, IP_CONST_DAMAGETYPE_BLUDGEONING, -1, -1, 1, 50, "Sturdy", "Sturdy", "of Sturdiness");
   // Damage Resistance (Acid)
   ip_SetPropertyName(CI_IP_DamageResistance, IP_CONST_DAMAGETYPE_ACID, -1, -1, 1, 50, "Alkaline", "Alkaline", "of Neutralisation");
   // Damage Resistance (Cold)
   ip_SetPropertyName(CI_IP_DamageResistance, IP_CONST_DAMAGETYPE_COLD, -1, -1, 1, 50, "Temperate", "Temperate", "of Temperation");
   // Damage Resistance (Electrical)
   ip_SetPropertyName(CI_IP_DamageResistance, IP_CONST_DAMAGETYPE_ELECTRICAL, -1, -1, 1, 50, "Impeding", "Faraday's", "of Impedence");
   // Damage Resistance (Fire)
   ip_SetPropertyName(CI_IP_DamageResistance, IP_CONST_DAMAGETYPE_FIRE, -1, -1, 1, 50, "Chilled", "Chilled", "of Chilling Security");
   // Damage Resistance (Sonic)
   ip_SetPropertyName(CI_IP_DamageResistance, IP_CONST_DAMAGETYPE_SONIC, -1, -1, 1, 50, "Acoustic", "Acoustic", "of Dampening Sound");
   // Damage Resistance (Divine)
   ip_SetPropertyName(CI_IP_DamageResistance, IP_CONST_DAMAGETYPE_DIVINE, -1, -1, 1, 50, "Heretic", "Heretic", "of Heretics");
   // Damage Resistance (Magical)
   ip_SetPropertyName(CI_IP_DamageResistance, IP_CONST_DAMAGETYPE_MAGICAL, -1, -1, 1, 50, "Nullifying", "Nullifying", "of Spell Battle");
   // Damage Resistance (Negative)
   ip_SetPropertyName(CI_IP_DamageResistance, IP_CONST_DAMAGETYPE_NEGATIVE, -1, -1, 1, 50, "Positive", "Positive", "of Negative Protection");
   // Damage Resistance (Physical)
   ip_SetPropertyName(CI_IP_DamageResistance, IP_CONST_DAMAGETYPE_PHYSICAL, -1, -1, 1, 50, "Brawler's", "Brawler's", "of Brawling");
   // Damage Resistance (Positive)
   ip_SetPropertyName(CI_IP_DamageResistance, IP_CONST_DAMAGETYPE_POSITIVE, -1, -1, 1, 50, "Negative", "Negative", "of Positive Protection");
   // Damage Resistance (Subdual)
   ip_SetPropertyName(CI_IP_DamageResistance, IP_CONST_DAMAGETYPE_SUBDUAL, -1, -1, 1, 50, "Wrestler's", "Wrestler's", "of Wrestling");

   // Damage Vulnerability (Slashing)
   ip_SetPropertyName(CI_IP_DamageVulnerability, IP_CONST_DAMAGETYPE_SLASHING, -1, -1, 1, 50, "", "", "");
   // Damage Vulnerability (Piercing)
   ip_SetPropertyName(CI_IP_DamageVulnerability, IP_CONST_DAMAGETYPE_PIERCING, -1, -1, 1, 50, "", "", "");
   // Damage Vulnerability (Bludgeoning)
   ip_SetPropertyName(CI_IP_DamageVulnerability, IP_CONST_DAMAGETYPE_BLUDGEONING, -1, -1, 1, 50, "", "", "");
   // Damage Vulnerability (Acid)
   ip_SetPropertyName(CI_IP_DamageVulnerability, IP_CONST_DAMAGETYPE_ACID, -1, -1, 1, 50, "", "", "");
   // Damage Vulnerability (Cold)
   ip_SetPropertyName(CI_IP_DamageVulnerability, IP_CONST_DAMAGETYPE_COLD, -1, -1, 1, 50, "", "", "");
   // Damage Vulnerability (Electrical)
   ip_SetPropertyName(CI_IP_DamageVulnerability, IP_CONST_DAMAGETYPE_ELECTRICAL, -1, -1, 1, 50, "Conducting", "Metallic", "of Conductance");
   // Damage Vulnerability (Fire)
   ip_SetPropertyName(CI_IP_DamageVulnerability, IP_CONST_DAMAGETYPE_FIRE, -1, -1, 1, 50, "Combusting", "Combusting", "of Combustion");
   // Damage Vulnerability (Sonic)
   ip_SetPropertyName(CI_IP_DamageVulnerability, IP_CONST_DAMAGETYPE_SONIC, -1, -1, 1, 50, "", "", "");
   // Damage Vulnerability (Divine)
   ip_SetPropertyName(CI_IP_DamageVulnerability, IP_CONST_DAMAGETYPE_DIVINE, -1, -1, 1, 50, "", "", "");
   // Damage Vulnerability (Magical)
   ip_SetPropertyName(CI_IP_DamageVulnerability, IP_CONST_DAMAGETYPE_MAGICAL, -1, -1, 1, 50, "", "", "");
   // Damage Vulnerability (Negative)
   ip_SetPropertyName(CI_IP_DamageVulnerability, IP_CONST_DAMAGETYPE_NEGATIVE, -1, -1, 1, 50, "", "", "");
   // Damage Vulnerability (Physical)
   ip_SetPropertyName(CI_IP_DamageVulnerability, IP_CONST_DAMAGETYPE_PHYSICAL, -1, -1, 1, 50, "", "", "");
   // Damage Vulnerability (Positive)
   ip_SetPropertyName(CI_IP_DamageVulnerability, IP_CONST_DAMAGETYPE_POSITIVE, -1, -1, 1, 50, "", "", "");
   // Damage Vulnerability (Subdual)
   ip_SetPropertyName(CI_IP_DamageVulnerability, IP_CONST_DAMAGETYPE_SUBDUAL, -1, -1, 1, 50, "", "", "");

   // Darkvision
   ip_SetPropertyName(CI_IP_Darkvision, -1, -1, -1, 1, 50, "Glaring", "Glaring", "of Improved Sight");

   // Decrease Ability (Strength)
   ip_SetPropertyName(CI_IP_DecreaseAbility, IP_CONST_ABILITY_STR, -1, -1, 1, 50, "Forceless", "Forceless", "of Weakness");
   // Decrease Ability (Dexterity)
   ip_SetPropertyName(CI_IP_DecreaseAbility, IP_CONST_ABILITY_DEX, -1, -1, 1, 50, "Stumbling", "Ungraceful", "of Lost Grace");
   // Decrease Ability (Constitution)
   ip_SetPropertyName(CI_IP_DecreaseAbility, IP_CONST_ABILITY_CON, -1, -1, 1, 50, "Fragile", "Shaky", "of Futility");
   // Decrease Ability (Wisdom)
   ip_SetPropertyName(CI_IP_DecreaseAbility, IP_CONST_ABILITY_WIS, -1, -1, 1, 50, "Foolish", "Foolish", "of the Simple-Minded");
   // Decrease Ability (Intelligence)
   ip_SetPropertyName(CI_IP_DecreaseAbility, IP_CONST_ABILITY_INT, -1, -1, 1, 50, "Dull", "Dull", "of the Brainless");
   // Decrease Ability (Charisma)
   ip_SetPropertyName(CI_IP_DecreaseAbility, IP_CONST_ABILITY_CHA, -1, -1, 1, 50, "Repulsive", "Repulsive", "of Mutation");

   // Decreased AC
   ip_SetPropertyName(CI_IP_DecreaseAC, -1, -1, -1, 1, 50, "Penetrable", "Penetrable", "of Easy Penetration");

   // Decreased Skill (All Skills)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_ALL_SKILLS, -1, -1, 1, 50, "Fumbling", "Inept", "of Fumbling");
   // Decreased Skill (Animal Empathy)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_ANIMAL_EMPATHY, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Appraise)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_APPRAISE, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Bluff)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_BLUFF, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Concentration)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_CONCENTRATION, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Craft Armor)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_CRAFT_ARMOR, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Craft Trap)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_CRAFT_TRAP, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Craft Weapon)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_CRAFT_WEAPON, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Disable Trap)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_DISABLE_TRAP, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Discipline)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_DISCIPLINE, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Heal)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_HEAL, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Hide)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_HIDE, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Intimidate)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_INTIMIDATE, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Listen)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_LISTEN, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Lore)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_LORE, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Move Silently)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_MOVE_SILENTLY, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Open Lock)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_OPEN_LOCK, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Parry)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_PARRY, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Perform)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_PERFORM, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Persuade)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_PERSUADE, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Pick Pocket)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_PICK_POCKET, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Search)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_SEARCH, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Set Trap)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_SET_TRAP, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Spellcraft)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_SPELLCRAFT, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Spot)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_SPOT, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Taunt)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_TAUNT, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Tumble)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_TUMBLE, -1, -1, 1, 50, "", "", "");
   // Decreased Skill (Use Magic Device)
   ip_SetPropertyName(CI_IP_DecreaseSkill, SKILL_USE_MAGIC_DEVICE, -1, -1, 1, 50, "", "", "");
}

void ip_InitializeItemNames_06()
{
   // Enhancement Bonus
   ip_SetPropertyName(CI_IP_EnhancementBonus, -1, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Alignment Group (Good)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsAlign, IP_CONST_ALIGNMENTGROUP_GOOD, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Alignment Group (Evil)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsAlign, IP_CONST_ALIGNMENTGROUP_EVIL, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Alignment Group (Lawful)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsAlign, IP_CONST_ALIGNMENTGROUP_LAWFUL, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Alignment Group (Neutral)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsAlign, IP_CONST_ALIGNMENTGROUP_NEUTRAL, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Alignment Group (Chaotic)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsAlign, IP_CONST_ALIGNMENTGROUP_CHAOTIC, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Abberation)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_ABERRATION, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Animal)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_ANIMAL, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Beasts)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_BEAST, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Construct)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_CONSTRUCT, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Dragon)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_DRAGON, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Dwarf)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_DWARF, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Elemental)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_ELEMENTAL, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Elf)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_ELF, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Fey)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_FEY, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Giant)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_GIANT, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Gnome)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_GNOME, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Halfelf)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_HALFELF, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Halfling)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_HALFLING, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Halforc)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_HALFORC, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Human)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_HUMAN, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Goblinoid)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Monstrous)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Orc)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_HUMANOID_ORC, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Reptilian)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Beast)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_MAGICAL_BEAST, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Outsider)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_OUTSIDER, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Shapechanger)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_SHAPECHANGER, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Undead)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_UNDEAD, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Race (Vermin)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsRace, IP_CONST_RACIALTYPE_VERMIN, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Specific Alignment (Lawful Good)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsSAlign, IP_CONST_ALIGNMENT_LG, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Specific Alignment (Neutral Good)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsSAlign, IP_CONST_ALIGNMENT_NG, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Specific Alignment (Chaotic Good)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsSAlign, IP_CONST_ALIGNMENT_CG, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Specific Alignment (Lawful Neutral)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsSAlign, IP_CONST_ALIGNMENT_LN, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Specific Alignment (True Neutral)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsSAlign, IP_CONST_ALIGNMENT_TN, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Specific Alignment (Chaotic Neutral)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsSAlign, IP_CONST_ALIGNMENT_CN, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Specific Alignment (Lawful Evil)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsSAlign, IP_CONST_ALIGNMENT_LE, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Specific Alignment (Neutral Evil)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsSAlign, IP_CONST_ALIGNMENT_NE, -1, -1, 1, 50, "", "", "");
   // Enhancement Bonus vs. Specific Alignment (Chaotic Evil)
   ip_SetPropertyName(CI_IP_EnhancementBonusVsSAlign, IP_CONST_ALIGNMENT_CE, -1, -1, 1, 50, "", "", "");

   // Extra Melee Damage Type (Slashing)
   ip_SetPropertyName(CI_IP_ExtraMeleeDamageType, IP_CONST_DAMAGETYPE_SLASHING, -1, -1, 1, 50, "", "", "");
   // Extra Melee Damage Type (Piercing)
   ip_SetPropertyName(CI_IP_ExtraMeleeDamageType, IP_CONST_DAMAGETYPE_PIERCING, -1, -1, 1, 50, "", "", "");
   // Extra Melee Damage Type (Bludgeoning)
   ip_SetPropertyName(CI_IP_ExtraMeleeDamageType, IP_CONST_DAMAGETYPE_BLUDGEONING, -1, -1, 1, 50, "", "", "");

   // Extra Ranged Damage Type (Slashing)
   ip_SetPropertyName(CI_IP_ExtraRangeDamageType, IP_CONST_DAMAGETYPE_SLASHING, -1, -1, 1, 50, "", "", "");
   // Extra Ranged Damage Type (Piercing)
   ip_SetPropertyName(CI_IP_ExtraRangeDamageType, IP_CONST_DAMAGETYPE_PIERCING, -1, -1, 1, 50, "", "", "");
   // Extra Ranged Damage Type (Bludgeoning)
   ip_SetPropertyName(CI_IP_ExtraRangeDamageType, IP_CONST_DAMAGETYPE_BLUDGEONING, -1, -1, 1, 50, "", "", "");

   // Haste
   ip_SetPropertyName(CI_IP_Haste, -1, -1, -1, 1, 50, "Swift", "Fast", "of Rapidity");

   // Holy Avenger
   ip_SetPropertyName(CI_IP_HolyAvenger, -1, -1, -1, 1, 50, "", "", "");

   // Immunity Misc. (Backstab)
   ip_SetPropertyName(CI_IP_ImmunityMisc, IP_CONST_IMMUNITYMISC_BACKSTAB, -1, -1, 1, 50, "", "", "");
   // Immunity Misc. (Critical Hits)
   ip_SetPropertyName(CI_IP_ImmunityMisc, IP_CONST_IMMUNITYMISC_CRITICAL_HITS, -1, -1, 1, 50, "", "", "of Fortified Defense");
   // Immunity Misc. (Death Magic)
   ip_SetPropertyName(CI_IP_ImmunityMisc, IP_CONST_IMMUNITYMISC_DEATH_MAGIC, -1, -1, 1, 50, "", "", "of Unyielding Soul");
   // Immunity Misc. (Disease)
   ip_SetPropertyName(CI_IP_ImmunityMisc, IP_CONST_IMMUNITYMISC_DISEASE, -1, -1, 1, 50, "", "", "of Vibrant Health");
   // Immunity Misc. (Fear)
   ip_SetPropertyName(CI_IP_ImmunityMisc, IP_CONST_IMMUNITYMISC_FEAR, -1, -1, 1, 50, "Heroic", "Fearless", "of Heroic Bravery");
   // Immunity Misc. (Knockdown)
   ip_SetPropertyName(CI_IP_ImmunityMisc, IP_CONST_IMMUNITYMISC_KNOCKDOWN, -1, -1, 1, 50, "", "", "of Braced Stance");
   // Immunity Misc. (Leveldrain)
   ip_SetPropertyName(CI_IP_ImmunityMisc, IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN, -1, -1, 1, 50, "", "", "");
   // Immunity Misc. (Mindspells)
   ip_SetPropertyName(CI_IP_ImmunityMisc, IP_CONST_IMMUNITYMISC_MINDSPELLS, -1, -1, 1, 50, "", "", "of Unpenetrable Mind");
   // Immunity Misc. (Paralysis)
   ip_SetPropertyName(CI_IP_ImmunityMisc, IP_CONST_IMMUNITYMISC_PARALYSIS, -1, -1, 1, 50, "", "", "");
   // Immunity Misc. (Poison)
   ip_SetPropertyName(CI_IP_ImmunityMisc, IP_CONST_IMMUNITYMISC_POISON, -1, -1, 1, 50, "Viperous", "Viperous", "of the Viper");

   // Immunity to Spell Level (1)
   ip_SetPropertyName(CI_IP_ImmunityToSpellLevel, 1, -1, -1, 1, 50, "Acolyte's", "Acolyte's", "of Acolyte Protection");
   // Immunity to Spell Level (2)
   ip_SetPropertyName(CI_IP_ImmunityToSpellLevel, 2, -1, -1, 1, 50, "Apprentice's", "Apprentice's", "of Apprentice Protection");
   // Immunity to Spell Level (3)
   ip_SetPropertyName(CI_IP_ImmunityToSpellLevel, 3, -1, -1, 1, 50, "Arcanist's", "Arcanist's", "of Arcanist Protection");
   // Immunity to Spell Level (4)
   ip_SetPropertyName(CI_IP_ImmunityToSpellLevel, 4, -1, -1, 1, 50, "Wizard's", "Wizard's", "of Wizard Protection");
   // Immunity to Spell Level (5)
   ip_SetPropertyName(CI_IP_ImmunityToSpellLevel, 5, -1, -1, 1, 50, "Battlemage's", "Battlemage's", "of Battlemage Protection");
   // Immunity to Spell Level (6)
   ip_SetPropertyName(CI_IP_ImmunityToSpellLevel, 6, -1, -1, 1, 50, "Archmage's", "Archmage's", "of Archmage Protection");
   // Immunity to Spell Level (7)
   ip_SetPropertyName(CI_IP_ImmunityToSpellLevel, 7, -1, -1, 1, 50, "Magister's", "Magister's", "of Magister Protection");
   // Immunity to Spell Level (8)
   ip_SetPropertyName(CI_IP_ImmunityToSpellLevel, 8, -1, -1, 1, 50, "Lich's", "Lich's", "of Lich Protection");
   // Immunity to Spell Level (9)
   ip_SetPropertyName(CI_IP_ImmunityToSpellLevel, 9, -1, -1, 1, 50, "Mystra's", "Mystra's", "of Mystra's Protection");
}

void ip_InitializeItemNames_07()
{
   // Improved Evasion
   ip_SetPropertyName(CI_IP_ImprovedEvasion, -1, -1, -1, 1, 50, "Evasive", "Evasive", "of Evasion");

   // Keen
   ip_SetPropertyName(CI_IP_Keen, -1, -1, -1, 1, 50, "Keen", "Keen", "of Violence");

   // Light (Dim)
   ip_SetPropertyName(CI_IP_Light, IP_CONST_LIGHTBRIGHTNESS_DIM, -1, -1, 1, 50, "Glimmering", "Glimmering", "of Dawn");
   // Light (Low)
   ip_SetPropertyName(CI_IP_Light, IP_CONST_LIGHTBRIGHTNESS_LOW, -1, -1, 1, 50, "Sparkling", "Sparkling", "of Dusk");
   // Light (Normal)
   ip_SetPropertyName(CI_IP_Light, IP_CONST_LIGHTBRIGHTNESS_NORMAL, -1, -1, 1, 50, "Shining", "Shining", "of Moonlight");
   // Light (Bright)
   ip_SetPropertyName(CI_IP_Light, IP_CONST_LIGHTBRIGHTNESS_BRIGHT, -1, -1, 1, 50, "Illuminating", "Illuminating", "of Guiding Light");

   // Limit Use by Alignment Group (Good)
   ip_SetPropertyName(CI_IP_LimitUseByAlign, IP_CONST_ALIGNMENTGROUP_GOOD, -1, -1, 1, 50, "", "", "of Kind-Spirit");
   // Limit Use by Alignment Group (Evil)
   ip_SetPropertyName(CI_IP_LimitUseByAlign, IP_CONST_ALIGNMENTGROUP_EVIL, -1, -1, 1, 50, "", "", "of Ill-Spirit");
   // Limit Use by Alignment Group (Lawful)
   ip_SetPropertyName(CI_IP_LimitUseByAlign, IP_CONST_ALIGNMENTGROUP_LAWFUL, -1, -1, 1, 50, "", "", "");
   // Limit Use by Alignment Group (Neutral)
   ip_SetPropertyName(CI_IP_LimitUseByAlign, IP_CONST_ALIGNMENTGROUP_NEUTRAL, -1, -1, 1, 50, "Impartial", "Impartial", "of Impartial");
   // Limit Use by Alignment Group (Chaotic)
   ip_SetPropertyName(CI_IP_LimitUseByAlign, IP_CONST_ALIGNMENTGROUP_CHAOTIC, -1, -1, 1, 50, "", "", "");
   // Limit Use by Class (Barbarian)
   ip_SetPropertyName(CI_IP_LimitUseByClass, IP_CONST_CLASS_BARBARIAN, -1, -1, 1, 50, "", "", "");
   // Limit Use by Class (Bard)
   ip_SetPropertyName(CI_IP_LimitUseByClass, IP_CONST_CLASS_BARD, -1, -1, 1, 50, "Elegant", "Elegant", "for the performer");
   // Limit Use by Class (Cleric)
   ip_SetPropertyName(CI_IP_LimitUseByClass, IP_CONST_CLASS_CLERIC, -1, -1, 1, 50, "Godsent", "Godsent", "for the Believer");
   // Limit Use by Class (Druid)
   ip_SetPropertyName(CI_IP_LimitUseByClass, IP_CONST_CLASS_DRUID, -1, -1, 1, 50, "Earthly", "Earthly", "from Nature");
   // Limit Use by Class (Fighter)
   ip_SetPropertyName(CI_IP_LimitUseByClass, IP_CONST_CLASS_FIGHTER, -1, -1, 1, 50, "", "", "");
   // Limit Use by Class (Monk)
   ip_SetPropertyName(CI_IP_LimitUseByClass, IP_CONST_CLASS_MONK, -1, -1, 1, 50, "Spiritual", "Spiritual", "for the Spirit");
   // Limit Use by Class (Paladin)
   ip_SetPropertyName(CI_IP_LimitUseByClass, IP_CONST_CLASS_PALADIN, -1, -1, 1, 50, "Paladin's", "Paladin's", "for the Enforcer");
   // Limit Use by Class (Ranger)
   ip_SetPropertyName(CI_IP_LimitUseByClass, IP_CONST_CLASS_RANGER, -1, -1, 1, 50, "Guiding", "Guiding", "for the Woodsman");
   // Limit Use by Class (Rogue)
   ip_SetPropertyName(CI_IP_LimitUseByClass, IP_CONST_CLASS_ROGUE, -1, -1, 1, 50, "", "", "for the Shadow");
   // Limit Use by Class (Sorcerer)
   ip_SetPropertyName(CI_IP_LimitUseByClass, IP_CONST_CLASS_SORCERER, -1, -1, 1, 50, "", "", "for the Gifted");
   // Limit Use by Class (Wizard)
   ip_SetPropertyName(CI_IP_LimitUseByClass, IP_CONST_CLASS_WIZARD, -1, -1, 1, 50, "Academic", "Academic", "for the Studied");
   // Limit Use by Race (Dwarf)
   ip_SetPropertyName(CI_IP_LimitUseByRace, IP_CONST_RACIALTYPE_DWARF, -1, -1, 1, 50, "Drawven", "Stonemaster's", "");
   // Limit Use by Race (Elf)
   ip_SetPropertyName(CI_IP_LimitUseByRace, IP_CONST_RACIALTYPE_ELF, -1, -1, 1, 50, "Elven", "", "");
   // Limit Use by Race (Gnome)
   ip_SetPropertyName(CI_IP_LimitUseByRace, IP_CONST_RACIALTYPE_GNOME, -1, -1, 1, 50, "Gnomish", "", "");
   // Limit Use by Race (Halfelf)
   ip_SetPropertyName(CI_IP_LimitUseByRace, IP_CONST_RACIALTYPE_HALFELF, -1, -1, 1, 50, "", "", "");
   // Limit Use by Race (Halfling)
   ip_SetPropertyName(CI_IP_LimitUseByRace, IP_CONST_RACIALTYPE_HALFLING, -1, -1, 1, 50, "Hin", "", "");
   // Limit Use by Race (Halforc)
   ip_SetPropertyName(CI_IP_LimitUseByRace, IP_CONST_RACIALTYPE_HALFORC, -1, -1, 1, 50, "Orcish", "", "");
   // Limit Use by Race (Human)
   ip_SetPropertyName(CI_IP_LimitUseByRace, IP_CONST_RACIALTYPE_HUMAN, -1, -1, 1, 50, "", "", "");
   // Limit Use by Specific Alignment (Lawful Good)
   ip_SetPropertyName(CI_IP_LimitUseBySAlign, IP_CONST_ALIGNMENT_LG, -1, -1, 1, 50, "Righteous", "Righteous", "of Righteousness");
   // Limit Use by Specific Alignment (Neutral Good)
   ip_SetPropertyName(CI_IP_LimitUseBySAlign, IP_CONST_ALIGNMENT_NG, -1, -1, 1, 50, "", "", "");
   // Limit Use by Specific Alignment (Chaotic Good)
   ip_SetPropertyName(CI_IP_LimitUseBySAlign, IP_CONST_ALIGNMENT_CG, -1, -1, 1, 50, "", "", "of Free-spirit");
   // Limit Use by Specific Alignment (Lawful Neutral)
   ip_SetPropertyName(CI_IP_LimitUseBySAlign, IP_CONST_ALIGNMENT_LN, -1, -1, 1, 50, "", "", "of the Follower");
   // Limit Use by Specific Alignment (True Neutral)
   ip_SetPropertyName(CI_IP_LimitUseBySAlign, IP_CONST_ALIGNMENT_TN, -1, -1, 1, 50, "Balanced", "Balanced", "of Balance");
   // Limit Use by Specific Alignment (Chaotic Neutral)
   ip_SetPropertyName(CI_IP_LimitUseBySAlign, IP_CONST_ALIGNMENT_CN, -1, -1, 1, 50, "", "", "of Indecisive");
   // Limit Use by Specific Alignment (Lawful Evil)
   ip_SetPropertyName(CI_IP_LimitUseBySAlign, IP_CONST_ALIGNMENT_LE, -1, -1, 1, 50, "", "", "of the Mastermind");
   // Limit Use by Specific Alignment (Neutral Evil)
   ip_SetPropertyName(CI_IP_LimitUseBySAlign, IP_CONST_ALIGNMENT_NE, -1, -1, 1, 50, "", "", "");
   // Limit Use by Specific Alignment (Chaotic Evil)
   ip_SetPropertyName(CI_IP_LimitUseBySAlign, IP_CONST_ALIGNMENT_CE, -1, -1, 1, 50, "Insane", "Insane", "of Insanity");

   // Massive Critical
   ip_SetPropertyName(CI_IP_MassiveCritical, -1, -1, -1, 1, 50, "Devastating", "Devastating", "of Crushing");

   // Mighty
   ip_SetPropertyName(CI_IP_MaxRangeStrengthMod, -1, -1, -1, 1, 50, "Strong", "Strong", "of the Wood Elves");

   // No Combat Damage
   ip_SetPropertyName(CI_IP_NoDamage, -1, -1, -1, 1, 50, "Practice", "Practice", "of Practicing");

   // OnHit: Cast Spell
   ip_SetPropertyName(CI_IP_OnHitCastSpell, -1, -1, -1, 1, 50, "Reactive", "Reactive", "of Arcane Reaction");

   // OnHit Properties (Ability Drain)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_ABILITYDRAIN, -1, -1, 1, 50, "", "", "");
   // OnHit Properties (Blindness)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_BLINDNESS, -1, -1, 1, 50, "Blinding", "Blinding", "of Blindness");
   // OnHit Properties (Confusion)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_CONFUSION, -1, -1, 1, 50, "Confusing", "Confusing", "of Confusion");
   // OnHit Properties (Daze)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_DAZE, -1, -1, 1, 50, "", "", "");
   // OnHit Properties (Deafness)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_DEAFNESS, -1, -1, 1, 50, "Deafening", "Deafening", "of Deafening");
   // OnHit Properties (Disease)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_DISEASE, -1, -1, 1, 50, "Plagued", "Plagues", "of the Plague");
   // OnHit Properties (Dispel Magic)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_DISPELMAGIC, -1, -1, 1, 50, "", "", "");
   // OnHit Properties (Doom)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_DOOM, -1, -1, 1, 50, "", "", "");
   // OnHit Properties (Fear)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_FEAR, -1, -1, 1, 50, "Frightening", "Fearful", "of Horror");
   // OnHit Properties (Greater Dispel)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_GREATERDISPEL, -1, -1, 1, 50, "", "", "");
   // OnHit Properties (Hold)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_HOLD, -1, -1, 1, 50, "", "", "");
   // OnHit Properties (Poison)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_ITEMPOISON, -1, -1, 1, 50, "", "", "");
   // OnHit Properties (Knock)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_KNOCK, -1, -1, 1, 50, "", "", "");
   // OnHit Properties (Lesser Dispel)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_LESSERDISPEL, -1, -1, 1, 50, "", "", "");
   // OnHit Properties (Level Drain)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_LEVELDRAIN, -1, -1, 1, 50, "", "", "");
   // OnHit Properties (Mordenkainen's Disjunction)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_MORDSDISJUNCTION, -1, -1, 1, 50, "", "", "");
   // OnHit Properties (Silence)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_SILENCE, -1, -1, 1, 50, "", "", "");
   // OnHit Properties (Slay Specific Alignment)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_SLAYALIGNMENT, -1, -1, 1, 50, "", "", "");
   // OnHit Properties (Slay Alignment Group)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_SLAYALIGNMENTGROUP, -1, -1, 1, 50, "", "", "");
   // OnHit Properties (Slay Race)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_SLAYRACE, -1, -1, 1, 50, "", "", "");
   // OnHit Properties (Sleep)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_SLEEP, -1, -1, 1, 50, "", "", "");
   // OnHit Properties (Slow)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_SLOW, -1, -1, 1, 50, "", "", "");
   // OnHit Properties (Stun)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_STUN, -1, -1, 1, 50, "", "", "");
   // OnHit Properties (Vorpal)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_VORPAL, -1, -1, 1, 50, "", "", "");
   // OnHit Properties (Wounding)
   ip_SetPropertyName(CI_IP_OnHitProps, IP_CONST_ONHIT_WOUNDING, -1, -1, 1, 50, "", "", "");
}

void ip_InitializeItemNames_08()
{
   // Reduced Saving Throw (Fortitude)
   ip_SetPropertyName(CI_IP_ReducedSavingThrow, IP_CONST_SAVEBASETYPE_FORTITUDE, -1, -1, 1, 50, "Feeble", "Weak", "of Bad Fortitude");
   // Reduced Saving Throw (Reflex)
   ip_SetPropertyName(CI_IP_ReducedSavingThrow, IP_CONST_SAVEBASETYPE_REFLEX, -1, -1, 1, 50, "Slow", "Tardy", "of Slowness");
   // Reduced Saving Throw (Will)
   ip_SetPropertyName(CI_IP_ReducedSavingThrow, IP_CONST_SAVEBASETYPE_WILL, -1, -1, 1, 50, "Irritating", "Abulic", "of the Weakening Mind");
   // Reduced Saving Throw vs. Acid
   ip_SetPropertyName(CI_IP_ReducedSavingThrowVsX, IP_CONST_SAVEVS_ACID, -1, -1, 1, 50, "", "", "");
   // Reduced Saving Throw vs. Cold
   ip_SetPropertyName(CI_IP_ReducedSavingThrowVsX, IP_CONST_SAVEVS_COLD, -1, -1, 1, 50, "", "", "");
   // Reduced Saving Throw vs. Death
   ip_SetPropertyName(CI_IP_ReducedSavingThrowVsX, IP_CONST_SAVEVS_DEATH, -1, -1, 1, 50, "", "", "");
   // Reduced Saving Throw vs. Disease
   ip_SetPropertyName(CI_IP_ReducedSavingThrowVsX, IP_CONST_SAVEVS_DISEASE, -1, -1, 1, 50, "", "", "");
   // Reduced Saving Throw vs. Divine
   ip_SetPropertyName(CI_IP_ReducedSavingThrowVsX, IP_CONST_SAVEVS_DIVINE, -1, -1, 1, 50, "", "", "");
   // Reduced Saving Throw vs. Electrical
   ip_SetPropertyName(CI_IP_ReducedSavingThrowVsX, IP_CONST_SAVEVS_ELECTRICAL, -1, -1, 1, 50, "", "", "");
   // Reduced Saving Throw vs. Fear
   ip_SetPropertyName(CI_IP_ReducedSavingThrowVsX, IP_CONST_SAVEVS_FEAR, -1, -1, 1, 50, "", "", "");
   // Reduced Saving Throw vs. Fire
   ip_SetPropertyName(CI_IP_ReducedSavingThrowVsX, IP_CONST_SAVEVS_FIRE, -1, -1, 1, 50, "", "", "");
   // Reduced Saving Throw vs. Mind Affecting
   ip_SetPropertyName(CI_IP_ReducedSavingThrowVsX, IP_CONST_SAVEVS_MINDAFFECTING, -1, -1, 1, 50, "", "", "");
   // Reduced Saving Throw vs. Negative Energy
   ip_SetPropertyName(CI_IP_ReducedSavingThrowVsX, IP_CONST_SAVEVS_NEGATIVE, -1, -1, 1, 50, "", "", "");
   // Reduced Saving Throw vs. Poison
   ip_SetPropertyName(CI_IP_ReducedSavingThrowVsX, IP_CONST_SAVEVS_POISON, -1, -1, 1, 50, "", "", "");
   // Reduced Saving Throw vs. Positive Energy
   ip_SetPropertyName(CI_IP_ReducedSavingThrowVsX, IP_CONST_SAVEVS_POSITIVE, -1, -1, 1, 50, "", "", "");
   // Reduced Saving Throw vs. Sonic
   ip_SetPropertyName(CI_IP_ReducedSavingThrowVsX, IP_CONST_SAVEVS_SONIC, -1, -1, 1, 50, "", "", "");
   // Reduced Saving Throw (Universal)
   ip_SetPropertyName(CI_IP_ReducedSavingThrowVsX, IP_CONST_SAVEVS_UNIVERSAL, -1, -1, 1, 50, "", "", "");

   // Regeneration
   ip_SetPropertyName(CI_IP_Regeneration, -1, -1, -1, 1, 50, "Regenerating", "Regenerating", "of Troll Regeneration");

   // Skill Bonus (Animal Empathy)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_ANIMAL_EMPATHY, -1, -1, 1, 50, "Druidic", "Animal-Handling", "of the Wild");
   // Skill Bonus (Appraise)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_APPRAISE, -1, -1, 1, 50, "Bargaining", "Whaukeen's", "of Merchant Insight");
   // Skill Bonus (Bluff)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_BLUFF, -1, -1, 1, 50, "Trickster's", "Trickster's", "of Confidence");
   // Skill Bonus (Concentration)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_CONCENTRATION, -1, -1, 1, 50, "Focussing", "Mental", "of Mental Focus");
   // Skill Bonus (Craft Armor)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_CRAFT_ARMOR, -1, -1, 1, 50, "Armorer's", "Armorer's", "of the Armorsmith");
   // Skill Bonus (Craft Trap)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_CRAFT_TRAP, -1, -1, 1, 50, "Gnomish", "Gnomish", "of Contraption");
   // Skill Bonus (Craft Weapon)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_CRAFT_WEAPON, -1, -1, 1, 50, "Weaponsmith's", "Weaponsmith's", "of Craftmanship");
   // Skill Bonus (Disable Trap)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_DISABLE_TRAP, -1, -1, 1, 50, "", "", "");
   // Skill Bonus (Discipline)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_DISCIPLINE, -1, -1, 1, 50, "", "", "");
   // Skill Bonus (Heal)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_HEAL, -1, -1, 1, 50, "", "", "");
   // Skill Bonus (Hide)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_HIDE, -1, -1, 1, 50, "", "", "of Rabbit Timid");
   // Skill Bonus (Intimidate)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_INTIMIDATE, -1, -1, 1, 50, "", "", "");
   // Skill Bonus (Listen)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_LISTEN, -1, -1, 1, 50, "", "", "of Attuned Hearing");
   // Skill Bonus (Lore)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_LORE, -1, -1, 1, 50, "Bardic", "Sage's", "of Knowledge");
   // Skill Bonus (Move Silently)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_MOVE_SILENTLY, -1, -1, 1, 50, "Quiet", "Soundless", "of Light Step");
   // Skill Bonus (Open Lock)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_OPEN_LOCK, -1, -1, 1, 50, "Thief's", "Unlocking", "of the Thief");
   // Skill Bonus (Parry)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_PARRY, -1, -1, 1, 50, "", "", "");
   // Skill Bonus (Perform)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_PERFORM, -1, -1, 1, 50, "Entertaining", "Entertaining", "of the Jester");
   // Skill Bonus (Persuade)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_PERSUADE, -1, -1, 1, 50, "Convincing", "Convincing", "of Convincing Charm");
   // Skill Bonus (Pick Pocked)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_PICK_POCKET, -1, -1, 1, 50, "Nimble Finger", "Quick Finger", "of Nimble Fingers");
   // Skill Bonus (Search)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_SEARCH, -1, -1, 1, 50, "Thorough", "Thorough", "of Thoroughness");
   // Skill Bonus (Set Trap)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_SET_TRAP, -1, -1, 1, 50, "Luring", "Luring", "of Hunter's Bait");
   // Skill Bonus (Spellcraft)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_SPELLCRAFT, -1, -1, 1, 50, "", "", "of Magical Insight");
   // Skill Bonus (Spot)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_SPOT, -1, -1, 1, 50, "", "", "of Eagle Sight");
   // Skill Bonus (Taunt)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_TAUNT, -1, -1, 1, 50, "Mocking", "Taunting", "of Taunting");
   // Skill Bonus (Tumble)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_TUMBLE, -1, -1, 1, 50, "", "", "");
   // Skill Bonus (Use Magic Device)
   ip_SetPropertyName(CI_IP_SkillBonus, SKILL_USE_MAGIC_DEVICE, -1, -1, 1, 50, "", "", "");
}

void ip_InitializeItemNames_09()
{
   // Immunity to Spell School (Abjuration)
   ip_SetPropertyName(CI_IP_SpellImmunitySchool, IP_CONST_SPELLSCHOOL_ABJURATION, -1, -1, 1, 50, "", "", "of Someone's Barrier");
   // Immunity to Spell School (Conjuration)
   ip_SetPropertyName(CI_IP_SpellImmunitySchool, IP_CONST_SPELLSCHOOL_CONJURATION, -1, -1, 1, 50, "", "", "of Someone's Dispelling");
   // Immunity to Spell School (Divination)
   ip_SetPropertyName(CI_IP_SpellImmunitySchool, IP_CONST_SPELLSCHOOL_DIVINATION, -1, -1, 1, 50, "", "", "of Somone's Protection");
   // Immunity to Spell School (Enchantment)
   ip_SetPropertyName(CI_IP_SpellImmunitySchool, IP_CONST_SPELLSCHOOL_ENCHANTMENT, -1, -1, 1, 50, "", "", "of Someone's Shielding");
   // Immunity to Spell School (Evocation)
   ip_SetPropertyName(CI_IP_SpellImmunitySchool, IP_CONST_SPELLSCHOOL_EVOCATION, -1, -1, 1, 50, "", "", "of Someone's Buffer");
   // Immunity to Spell School (Illusion)
   ip_SetPropertyName(CI_IP_SpellImmunitySchool, IP_CONST_SPELLSCHOOL_ILLUSION, -1, -1, 1, 50, "", "", "of Someone's Dismissal");
   // Immunity to Spell School (Necromancy)
   ip_SetPropertyName(CI_IP_SpellImmunitySchool, IP_CONST_SPELLSCHOOL_NECROMANCY, -1, -1, 1, 50, "", "", "of Somone's Warding");
   // Immunity to Spell School (Transmutation)
   ip_SetPropertyName(CI_IP_SpellImmunitySchool, IP_CONST_SPELLSCHOOL_TRANSMUTATION, -1, -1, 1, 50, "", "", "of Someone's Stability");

   // True Seeing
   ip_SetPropertyName(CI_IP_TrueSeeing, -1, -1, -1, 1, 50, "Revealing", "Truthful", "of True Sight");

   // Unlimited Ammo (Basic)
   ip_SetPropertyName(CI_IP_UnlimitedAmmo, IP_CONST_UNLIMITEDAMMO_BASIC, -1, -1, 1, 50, "Infinite", "Unlimited", "of Endless Supply");
   // Unlimited Ammo (+1)
   ip_SetPropertyName(CI_IP_UnlimitedAmmo, IP_CONST_UNLIMITEDAMMO_PLUS1, -1, -1, 1, 50, "Painful", "Painful", "of Lasting Pain");
   // Unlimited Ammo (+2)
   ip_SetPropertyName(CI_IP_UnlimitedAmmo, IP_CONST_UNLIMITEDAMMO_PLUS2, -1, -1, 1, 50, "Hunter's", "Hunter's", "of Lasting Punctures");
   // Unlimited Ammo (+3)
   ip_SetPropertyName(CI_IP_UnlimitedAmmo, IP_CONST_UNLIMITEDAMMO_PLUS3, -1, -1, 1, 50, "Bowman's", "Bowman's", "of Lasting Pierce");
   // Unlimited Ammo (+4)
   ip_SetPropertyName(CI_IP_UnlimitedAmmo, IP_CONST_UNLIMITEDAMMO_PLUS4, -1, -1, 1, 50, "Archer's", "Archer's", "of Lasting Wounds");
   // Unlimited Ammo (+5)
   ip_SetPropertyName(CI_IP_UnlimitedAmmo, IP_CONST_UNLIMITEDAMMO_PLUS5, -1, -1, 1, 50, "Marksman's", "Marksman's", "of Lasting Death");
   // Unlimited Ammo (1d6 cold)
   ip_SetPropertyName(CI_IP_UnlimitedAmmo, IP_CONST_UNLIMITEDAMMO_1D6COLD, -1, -1, 1, 50, "Infinite Chilling", "Everlasting Chilling", "of Endless Chill");
   // Unlimited Ammo (1d6 fire)
   ip_SetPropertyName(CI_IP_UnlimitedAmmo, IP_CONST_UNLIMITEDAMMO_1D6FIRE, -1, -1, 1, 50, "Infinite Flaming", "Everlasting Flaming", "of Endless Flame");
   // Unlimited Ammo (1d6 electricity)
   ip_SetPropertyName(CI_IP_UnlimitedAmmo, IP_CONST_UNLIMITEDAMMO_1D6LIGHT, -1, -1, 1, 50, "Infinite Shocking", "Everlasting Shocking", "of Endless Shock");

   // Vampiric Regeneration
   ip_SetPropertyName(CI_IP_VampiricRegeneration, -1, -1, -1, 1, 50, "Bloody", "Crimson", "of Thirst");

   // Weight Reduction
   ip_SetPropertyName(CI_IP_WeightReduction, -1, -1, -1, 1, 50, "Light", "Nimble", "of the Feather");
}
