///////////////////////////////////////////////////////////////////////////////
// egs_inc
// written by: eyesolated
// written at: June 17, 2004
//
// Notes: Include File for Equipment Generation System

///////////
// Includes
//
// Needs:
#include "nwnx_sql"
#include "eas_inc"
#include "mod_cfg"
#include "egs_cfg"


///////////////////////
// Function Declaration
//

// Help for EGS
void egs_Help();

// Recreates the Area Table in the Database
void egs_CreateTable();

// Returns FALSE if any of the required System Tables is missing
int egs_GetTableExists();

// Drops all System Tables
void egs_DropTable();

// Add an item to the catalog. The tag and resref of the specified item MUST
// be identical, else the system won't work.
// iCategoryMain: CI_EGS_ITEM_MAIN_*
// iCategorySub: CI_EGS_ITEM_SUB_*
// iBaseItem: BASE_ITEM_*
//
// You can use CI_EGS_ITEM_UNDEFINED for iCategoryMain, iCategorySub and iBaseItem
// if you have no need for those
//
// You need to set iBlueprintCount to 0 if you want the exact sItemTag as the ResRef
void egs_AddItem(string sItemTag, int iCategoryMain, int iCategorySub, int iBaseItem, int iBaseValue, int iBlueprintCount = 1, int iWeaponSize = CI_EGS_WEAPONSIZE_UNDEFINED);

// Get the category of sItem
int egs_GetMainCategory(string sItem);

// Get the Subcategory of sItem
int egs_GetSubCategory(string sItem);

// Get the BASE_ITEM_* of sItem
int egs_GetBaseItem(string sItem);

// Get the base Value of sItem
int egs_GetBaseValue(string sItem);

// Get all info about sItem
struct STRUCT_EGS_ITEMINFO egs_GetItemInfo(string sItem);

// Get all info about oItem (Category, SubCategory) if known to EGS
struct STRUCT_EGS_ITEMINFO egs_GetItemObjectInfo(object oItem);

// Get a random item that meets the criteria set.
// Setting any criteria to -1 will disable that criteria
// Leaving all criteria set to -1 will return a totally random item
//
// iMaxWeaponSize is the LARGEST item that can be retrieved.
// Use CI_EGS_WEAPONSIZE_* to define this.
//
// iWillBeMagical determines wheter the item will have a random appearance
// besides the basic one
//
// Returns "error" if no matching item is found
//
// Note: when ignoring the categories, this function will randomly select an
//       item (unbiased). The more items a category has, the better chance for
//       an item of this category to drop. For a better balanced function, use
//       egs_GetItem_Any(int iBaseValue = -1);
string egs_GetRandomItem(int iMainCategory = -1, int iSubCategory = -1, int iBaseItem = -1, int iBaseValue = -1, int iMaxWeaponSize = -1, int iWillBeMagical = FALSE);

// Will retrieve a random item
// Note: Some Items are worthless without a Magic Property added to them
//       so use this function with care or to get an idea about how to do it
string egs_GetItem_Any(int iBaseValue = -1, int iWeaponSize = -1, int iWillBeMagical = FALSE);

// Get a random Armor (BodyArmor/Shield/Helmet)
string egs_GetItem_Armor(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get a random Armor (Clothing)
string egs_GetItem_ArmorClothing(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get a random Armor (Light)
string egs_GetItem_ArmorLight(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get a random Armor (Medium)
string egs_GetItem_ArmorMedium(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get a random Armor (Heavy)
string egs_GetItem_ArmorHeavy(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get a random Body Armor (Clothing, Light, Medium, Heavy)
string egs_GetItem_ArmorBody(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get a random Helmet
string egs_GetItem_ArmorHelmet(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get a random Shield
string egs_GetItem_ArmorShield(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get a random Small Shield
string egs_GetItem_ArmorShieldSmall(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get a random Large Shield
string egs_GetItem_ArmorShieldLarge(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get a random Tower Shield
string egs_GetItem_ArmorShieldTower(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get a random Weapon (Melee/Ranged/Thrown)
string egs_GetItem_Weapon(int iBaseValue = -1, int iWeaponSize = -1, int iWillBeMagical = FALSE);

// Get a random Melee Weapon (Staff Included)
string egs_GetItem_WeaponMelee(int iBaseValue = -1, int iWeaponSize = -1, int iWillBeMagical = FALSE);

// Get a random Ranged Weapon
string egs_GetItem_WeaponRanged(int iBaseValue = -1, int iWeaponSize = -1, int iWillBeMagical = FALSE);

// Get a random Thrown Weapon (thrown weapons are always small!)
string egs_GetItem_WeaponThrown(int iBaseValue = -1, int iWeaponSize = -1, int iWillBeMagical = FALSE);

// Get random Ammunition
string egs_GetItem_Ammo(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get random Jewelry (Rings/Amulets)
string egs_GetItem_Jewelry(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get random Ring
string egs_GetItem_JewelryRing(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get random Amulet
string egs_GetItem_JewelryAmulet(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get random Accessory (Belt, Boots, Cloak, Gloves, Bracers, Rings, Amulets)
string egs_GetItem_Accessory(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get random Belt
string egs_GetItem_AccessoryBelt(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get random Boots
string egs_GetItem_AccessoryBoots(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get random Cloak
string egs_GetItem_AccessoryCloak(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get random Gloves
string egs_GetItem_AccessoryGlove(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get random Bracers
string egs_GetItem_AccessoryBracers(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get random Bomb (Alchemist's Fire etc...)
string egs_GetItem_Bomb(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get random Wand/Rod
string egs_GetItem_Wand(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get random Staff
string egs_GetItem_Staff(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get random Potion
string egs_GetItem_Potion(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get Healing Kit
string egs_GetItem_HealingKit(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get Thieves' Tools
string egs_GetItem_ThievesTools(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get Trap Kit
string egs_GetItem_TrapKit(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get Misc. Item
string egs_GetItem_Misc(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get Torch
string egs_GetItem_MiscTorch(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get random Container
string egs_GetItem_Container(int iBaseValue = -1, int iWillBeMagical = FALSE);

// Get random Book
string egs_GetItem_Book(int iBaseValue = -1, int iWillBeMagical = FALSE);

////////////////
// Function Code
//
void egs_Help()
{
}

// Private NON-NWNx helper code
void egs_Array_SetItemInfo(object oStore, string sArray, string sItemTag, int iBaseValue, int iWeaponSize)
{
    // Create the default array
    eas_Array_Create(oStore, sArray, EAS_ARRAY_TYPE_STRING);
    eas_SArray_Entry_Add(oStore, sArray, sItemTag);

    // Create the Base-Valued Array
    eas_Array_Create(oStore, sArray + "_BV" + IntToString(iBaseValue), EAS_ARRAY_TYPE_STRING);
    eas_SArray_Entry_Add(oStore, sArray + "_BV" + IntToString(iBaseValue), sItemTag);

    // Create the Weapon-Size Array
    eas_Array_Create(oStore, sArray + "_WS" + IntToString(iWeaponSize), EAS_ARRAY_TYPE_STRING);
    eas_SArray_Entry_Add(oStore, sArray + "_WS" + IntToString(iWeaponSize), sItemTag);

    // Create the Combined Array
    eas_Array_Create(oStore, sArray + "_BV" + IntToString(iBaseValue) + "_WS" + IntToString(iWeaponSize), EAS_ARRAY_TYPE_STRING);
    eas_SArray_Entry_Add(oStore, sArray + "_BV" + IntToString(iBaseValue) + "_WS" + IntToString(iWeaponSize), sItemTag);
}

int egs_GetTableExists()
{
    if (CI_EGS_USE_NWNX)
    {
        int nExists_Table = NWNX_SQL_ExecuteQuery("DESCRIBE " + CS_EGS_TABLE);
        return (nExists_Table);
    }
    else
        return FALSE;
}

void egs_DropTable()
{
    if (CI_EGS_USE_NWNX)
        NWNX_SQL_ExecuteQuery("DROP TABLE " + CS_EGS_TABLE);
}

void egs_CreateTable()
{
    if (CI_EGS_USE_NWNX)
    {
        NWNX_SQL_ExecuteQuery("DROP TABLE " + CS_EGS_TABLE);
        string sSQL = "CREATE TABLE " + CS_EGS_TABLE + " (" + CS_EGS_ITEMTAG + " varchar(32) NOT NULL, ";
        sSQL += CS_EGS_CATEGORY_MAIN + " int DEFAULT NULL, ";
        sSQL += CS_EGS_CATEGORY_SUB + " int DEFAULT NULL, ";
        sSQL += CS_EGS_BASEITEM + " int DEFAULT NULL, ";
        sSQL += CS_EGS_BASEVALUE + " int DEFAULT NULL, ";
        sSQL += CS_EGS_BPCOUNT + " int DEFAULT NULL, ";
        sSQL += CS_EGS_WEAPONSIZE + " int DEFAULT NULL, ";
        sSQL += "PRIMARY KEY (" + CS_EGS_ITEMTAG + "), ";
        sSQL += "KEY idx (" + CS_EGS_CATEGORY_MAIN + ", " + CS_EGS_CATEGORY_SUB + ", " + CS_EGS_BASEITEM + ", " + CS_EGS_BASEVALUE + ", " + CS_EGS_BPCOUNT + ", " + CS_EGS_WEAPONSIZE + "))";
        NWNX_SQL_ExecuteQuery(sSQL);
    }
    else
    {
        object oStoreWaypoint = GetObjectByTag(CS_EGS_DB_WAYPOINT);
        CreateObject(OBJECT_TYPE_STORE, CS_EGS_DB_MERCHANT_RESREF, GetLocation(oStoreWaypoint), FALSE, CS_EGS_DB_MERCHANT_NEWTAG);
    }
}

void egs_AddItem(string sItemTag, int iCategoryMain, int iCategorySub, int iBaseItem, int iBaseValue, int iBlueprintCount = 1, int iWeaponSize = CI_EGS_WEAPONSIZE_UNDEFINED)
{
    if (CI_EGS_USE_NWNX)
    {
        string sSQL = "INSERT  " + CS_EGS_TABLE;
        sSQL += " (" + CS_EGS_ITEMTAG + ", " + CS_EGS_CATEGORY_MAIN + ", " + CS_EGS_CATEGORY_SUB;
        sSQL += ", " + CS_EGS_BASEITEM + ", " + CS_EGS_BASEVALUE + ", " + CS_EGS_BPCOUNT + ", " + CS_EGS_WEAPONSIZE + ")";
        sSQL += " VALUES (?, ?, ?, ?, ?, ?, ?)";
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedString(0, sItemTag);
        NWNX_SQL_PreparedInt(1, iCategoryMain);
        NWNX_SQL_PreparedInt(2, iCategorySub);
        NWNX_SQL_PreparedInt(3, iBaseItem);
        NWNX_SQL_PreparedInt(4, iBaseValue);
        NWNX_SQL_PreparedInt(5, iBlueprintCount);
        NWNX_SQL_PreparedInt(6, iWeaponSize);
        NWNX_SQL_ExecutePreparedQuery();
    }
    else
    {
        // Get the Merchant Object
        object oStore = GetObjectByTag(CS_EGS_DB_MERCHANT_NEWTAG);

        // Save the item Info to the store
        SetLocalInt(oStore, CS_EGS_CATEGORY_MAIN + sItemTag, iCategoryMain);
        SetLocalInt(oStore, CS_EGS_CATEGORY_SUB + sItemTag, iCategorySub);
        SetLocalInt(oStore, CS_EGS_BASEITEM + sItemTag, iBaseItem);
        SetLocalInt(oStore, CS_EGS_BASEVALUE + sItemTag, iBaseValue);
        SetLocalInt(oStore, CS_EGS_BPCOUNT + sItemTag, iBlueprintCount);
        SetLocalInt(oStore, CS_EGS_WEAPONSIZE + sItemTag, iWeaponSize);

        // Create the arrays with references to the items
        string sArrayName = CS_EGS_ARRAY_UNFILTERED;
        egs_Array_SetItemInfo(oStore, sArrayName, sItemTag, iBaseValue, iWeaponSize);

        sArrayName = CS_EGS_ARRAY_CATEGORY_MAIN + IntToString(iCategoryMain);
        egs_Array_SetItemInfo(oStore, sArrayName, sItemTag, iBaseValue, iWeaponSize);
        sArrayName = CS_EGS_ARRAY_CATEGORY_MAIN + IntToString(iCategoryMain) + CS_EGS_ARRAY_CATEGORY_SUB + IntToString(iCategorySub);
        egs_Array_SetItemInfo(oStore, sArrayName, sItemTag, iBaseValue, iWeaponSize);
        sArrayName = CS_EGS_ARRAY_CATEGORY_MAIN + IntToString(iCategoryMain) + CS_EGS_ARRAY_BASEITEM + IntToString(iBaseItem);
        egs_Array_SetItemInfo(oStore, sArrayName, sItemTag, iBaseValue, iWeaponSize);
        sArrayName = CS_EGS_ARRAY_CATEGORY_MAIN + IntToString(iCategoryMain) + CS_EGS_ARRAY_CATEGORY_SUB + IntToString(iCategorySub) + CS_EGS_ARRAY_BASEITEM + IntToString(iBaseItem);
        egs_Array_SetItemInfo(oStore, sArrayName, sItemTag, iBaseValue, iWeaponSize);

        sArrayName = CS_EGS_ARRAY_CATEGORY_SUB + IntToString(iCategorySub) + CS_EGS_ARRAY_BASEITEM + IntToString(iBaseItem);
        egs_Array_SetItemInfo(oStore, sArrayName, sItemTag, iBaseValue, iWeaponSize);
        sArrayName = CS_EGS_ARRAY_CATEGORY_SUB + IntToString(iCategorySub);
        egs_Array_SetItemInfo(oStore, sArrayName, sItemTag, iBaseValue, iWeaponSize);

        sArrayName = CS_EGS_ARRAY_BASEITEM + IntToString(iBaseItem);
        egs_Array_SetItemInfo(oStore, sArrayName, sItemTag, iBaseValue, iWeaponSize);

        /*
        SendMessageToAllDMs("Item Added" + "\n" +
                            "Item Tag: " + sItemTag + "\n" +
                            "Main Category: " + IntToString(iCategoryMain) + "\n" +
                            "Sub Category: " + IntToString(iCategorySub) + "\n" +
                            "Base Item: " + IntToString(iBaseItem) + "\n" +
                            "Base Value: " + IntToString(iBaseValue) + "\n" +
                            "BP Count: " + IntToString(iBlueprintCount) + "\n" +
                            "Weapon Size: " + IntToString(iWeaponSize) + "\n" + "\n" +
                            "Main Store: " + GetTag(oStore_CategoryMain) + "\n" +
                            "Container: " + GetTag(oContainer_CategorySub) + "\n" +
                            "Items in Container: " + IntToString(eas_Array_GetSize(oContainer_CategorySub, CS_EGS_DB_SUBCATEGORY_UNFILTERED)));
        */
    }
}

int egs_GetMainCategory(string sItem)
{
    sItem = GetStringLeft(sItem, GetStringLength(sItem) - 2);
    if (CI_EGS_USE_NWNX)
    {
        string sSQL = "SELECT " + CS_EGS_CATEGORY_MAIN + " FROM " + CS_EGS_TABLE + " WHERE ";
        sSQL += CS_EGS_ITEMTAG + " = ?";
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedString(0, sItem);
        NWNX_SQL_ExecutePreparedQuery();
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            return (StringToInt(NWNX_SQL_ReadDataInActiveRow(0)));
        }
        else
        {
            return (0);
        }
    }
    else
    {
        // Get the Merchant Object
        object oStore = GetObjectByTag(CS_EGS_DB_MERCHANT_NEWTAG);
        return (GetLocalInt(oStore, CS_EGS_CATEGORY_MAIN + sItem));
    }
}

int egs_GetSubCategory(string sItem)
{
    sItem = GetStringLeft(sItem, GetStringLength(sItem) - 2);
    if (CI_EGS_USE_NWNX)
    {
        string sSQL = "SELECT " + CS_EGS_CATEGORY_SUB + " FROM " + CS_EGS_TABLE + " WHERE ";
        sSQL += CS_EGS_ITEMTAG + " = ?";
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedString(0, sItem);
        NWNX_SQL_ExecutePreparedQuery();
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            return (StringToInt(NWNX_SQL_ReadDataInActiveRow(0)));
        }
        else
        {
            return (0);
        }
    }
    else
    {
        // Get the Merchant Object
        object oStore = GetObjectByTag(CS_EGS_DB_MERCHANT_NEWTAG);
        return (GetLocalInt(oStore, CS_EGS_CATEGORY_SUB + sItem));
    }
}

int egs_GetBaseItem(string sItem)
{
    string sOriginalString = sItem;
    sItem = GetStringLeft(sItem, GetStringLength(sItem) - 2);
    if (CI_EGS_USE_NWNX)
    {
        string sSQL = "SELECT " + CS_EGS_BASEITEM + " FROM " + CS_EGS_TABLE + " WHERE ";
        sSQL += CS_EGS_ITEMTAG + " = ?";
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedString(0, sItem);
        NWNX_SQL_ExecutePreparedQuery();
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            return (StringToInt(NWNX_SQL_ReadDataInActiveRow(0)));
        }
        else
        {
            return (0);
        }
    }
    else
    {
        // Get the Merchant Object
        object oStore = GetObjectByTag(CS_EGS_DB_MERCHANT_NEWTAG);
        return (GetLocalInt(oStore, CS_EGS_BASEITEM + sItem));
    }
}

int egs_GetBaseValue(string sItem)
{
    string sOriginalString = sItem;
    sItem = GetStringLeft(sItem, GetStringLength(sItem) - 2);
    if (CI_EGS_USE_NWNX)
    {
        string sSQL = "SELECT " + CS_EGS_BASEVALUE + " FROM " + CS_EGS_TABLE + " WHERE ";
        sSQL += CS_EGS_ITEMTAG + " = ?";
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedString(0, sItem);
        NWNX_SQL_ExecutePreparedQuery();
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            return (StringToInt(NWNX_SQL_ReadDataInActiveRow(0)));
        }
        else
        {
            return (0);
        }
    }
    else
    {
        // Get the Merchant Object
        object oStore = GetObjectByTag(CS_EGS_DB_MERCHANT_NEWTAG);
        return (GetLocalInt(oStore, CS_EGS_BASEVALUE + sItem));
    }
}

struct STRUCT_EGS_ITEMINFO egs_GetItemInfo(string sItem)
{
    sItem = GetStringLeft(sItem, GetStringLength(sItem) - 2);
    struct STRUCT_EGS_ITEMINFO structResult;
    structResult.MainCategory = 0;
    structResult.SubCategory = 0;
    structResult.BaseItem = 0;
    structResult.BaseValue = 0;
    if (CI_EGS_USE_NWNX)
    {
        string sSQL = "SELECT " + CS_EGS_CATEGORY_MAIN + ", " + CS_EGS_CATEGORY_SUB + ", " + CS_EGS_BASEITEM + ", " + CS_EGS_BASEVALUE + " FROM " + CS_EGS_TABLE + " WHERE ";
        sSQL += CS_EGS_ITEMTAG + " = ?";
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedString(0, sItem);
        NWNX_SQL_ExecutePreparedQuery();
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            structResult.MainCategory = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
            structResult.SubCategory = StringToInt(NWNX_SQL_ReadDataInActiveRow(1));
            structResult.BaseItem = StringToInt(NWNX_SQL_ReadDataInActiveRow(2));
            structResult.BaseValue = StringToInt(NWNX_SQL_ReadDataInActiveRow(3));
        }
    }
    else
    {
        // Get the Merchant Object
        object oStore = GetObjectByTag(CS_EGS_DB_MERCHANT_NEWTAG);
        if (GetIsObjectValid(oStore))
        {
            structResult.MainCategory = GetLocalInt(oStore, CS_EGS_CATEGORY_MAIN + sItem);
            structResult.SubCategory = GetLocalInt(oStore, CS_EGS_CATEGORY_SUB + sItem);
            structResult.BaseItem = GetLocalInt(oStore, CS_EGS_BASEITEM + sItem);
            structResult.BaseValue = GetLocalInt(oStore, CS_EGS_BASEVALUE + sItem);
        }
   }
   return (structResult);
}

struct STRUCT_EGS_ITEMINFO egs_GetItemObjectInfo(object oItem)
{
    struct STRUCT_EGS_ITEMINFO structResult;
    structResult.MainCategory = 0;
    structResult.SubCategory = 0;
    structResult.BaseItem = 0;
    structResult.BaseValue = 0;
    if (CI_EGS_USE_NWNX)
    {
        string sSQL = "SELECT " + CS_EGS_CATEGORY_MAIN + ", " + CS_EGS_CATEGORY_SUB + ", " + CS_EGS_BASEITEM + ", " + CS_EGS_BASEVALUE + " FROM " + CS_EGS_TABLE + " WHERE ";
        sSQL += CS_EGS_BASEITEM + " = ?";
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedInt(0, GetBaseItemType(oItem));
        NWNX_SQL_ExecutePreparedQuery();
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            structResult.MainCategory = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
            structResult.SubCategory = StringToInt(NWNX_SQL_ReadDataInActiveRow(1));
            structResult.BaseItem = StringToInt(NWNX_SQL_ReadDataInActiveRow(2));
            structResult.BaseValue = StringToInt(NWNX_SQL_ReadDataInActiveRow(3));
        }
    }
    else
    {
        // Get the Merchant Object
        object oStore = GetObjectByTag(CS_EGS_DB_MERCHANT_NEWTAG);
        if (GetIsObjectValid(oStore))
        {
            // Not Implemented
        }
   }
   return (structResult);
}

string egs_GetRandomItem(int iMainCategory = -1, int iSubCategory = -1, int iBaseItem = -1, int iBaseValue = -1, int iMaxWeaponSize = -1, int iWillBeMagical = FALSE)
{
    string sReturn = "";
    int iNumOfBP = 0;
    string sInfo = "";
    if (CI_EGS_USE_NWNX)
    {
        string sSQL;
        int iAND = FALSE;

        sSQL = "SELECT " + CS_EGS_ITEMTAG + ", " + CS_EGS_BPCOUNT + " FROM " + CS_EGS_TABLE;
        if ( (iMainCategory + iSubCategory + iBaseItem + iBaseValue + iMaxWeaponSize) > -5)
            sSQL += " WHERE ";

        iAND = FALSE;
        if (iMainCategory != -1)
        {
            sSQL += CS_EGS_CATEGORY_MAIN + " = " + IntToString(iMainCategory);
            iAND = TRUE;
        }
        if (iSubCategory != -1)
        {
            if (iAND)
                sSQL += " AND ";
            sSQL += CS_EGS_CATEGORY_SUB + " = " + IntToString(iSubCategory);
            iAND = TRUE;
        }
        if (iBaseItem != -1)
        {
            if (iAND)
                sSQL += " AND ";
            sSQL += CS_EGS_BASEITEM + " = " + IntToString(iBaseItem);
            iAND = TRUE;
        }
        if (iBaseValue != -1)
        {
            if (iAND)
                sSQL += " AND ";
            sSQL += CS_EGS_BASEVALUE + " <= " + IntToString(iBaseValue);
            iAND = TRUE;
        }
        if (iMaxWeaponSize != -1)
        {
            if (iAND)
                sSQL += " AND ";
            sSQL += CS_EGS_WEAPONSIZE + " <= " + IntToString(iMaxWeaponSize);
            iAND = TRUE;
        }

        // If not specifically set, we do NOT want the "Ring of Xtra Difficulty" to
        // be selected.
        if (iMainCategory != CI_EGS_ITEM_MAIN_MONSTERRING)
        {
            if (iAND)
                sSQL += " AND ";
            else
                sSQL += " WHERE ";
            sSQL += CS_EGS_CATEGORY_MAIN + " != " + IntToString(CI_EGS_ITEM_MAIN_MONSTERRING);
        }

        sSQL += " ORDER BY RAND() LIMIT 1";

        NWNX_SQL_ExecuteQuery(sSQL);
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            sReturn = NWNX_SQL_ReadDataInActiveRow(0);
            iNumOfBP = StringToInt(NWNX_SQL_ReadDataInActiveRow(1));
        }
    }
    else
    {
        // Get the Merchant Object
        object oStore = GetObjectByTag(CS_EGS_DB_MERCHANT_NEWTAG);

        // Determine which Array we have to query
        string sArrayToSearch = "";
        string sBVSearch;
        int nBaseValueModifier = 1;

        if (iMainCategory != -1)
            sArrayToSearch += CS_EGS_ARRAY_CATEGORY_MAIN + IntToString(iMainCategory);
        if (iSubCategory != -1)
            sArrayToSearch += CS_EGS_ARRAY_CATEGORY_SUB + IntToString(iSubCategory);
        if (iBaseItem != -1)
            sArrayToSearch += CS_EGS_ARRAY_BASEITEM + IntToString(iBaseItem);
        if (sArrayToSearch == "")
            sArrayToSearch = CS_EGS_ARRAY_UNFILTERED;

        if (iBaseValue != -1)
        {
            sBVSearch = sArrayToSearch + "_BV" + IntToString(iBaseValue);

            // Find the highest iBaseValue where items exist
            while (eas_Array_GetSize(oStore, sBVSearch) == 0 &&
                   nBaseValueModifier < iBaseValue)
            {
                sBVSearch = sArrayToSearch + "_BV" + IntToString(iBaseValue - nBaseValueModifier);
                nBaseValueModifier++;
            }

            int nMaxLevel = iBaseValue - (nBaseValueModifier - 1);
            int nCurrentLevel;
            int nTotalItemCount = 0;
            for (nCurrentLevel = nMaxLevel; nCurrentLevel > 0; nCurrentLevel--)
            {
                // Get the amount of items in the current level and add that to the total item count
                nTotalItemCount += eas_Array_GetSize(oStore, sArrayToSearch + "_BV" + IntToString(nCurrentLevel));
            }

            // Select a random number of the total item count
            int nRandom = Random(nTotalItemCount) + 1;

            // Find the Array to select the item from
            int nItemCount;
            nTotalItemCount = 0;
            for (nCurrentLevel = 1; nCurrentLevel <= nMaxLevel; nCurrentLevel++)
            {
                // Get the amount of items in the current level
                sBVSearch = sArrayToSearch + "_BV" + IntToString(nCurrentLevel);
                nItemCount = eas_Array_GetSize(oStore, sBVSearch);
                if (nItemCount == 0)
                   continue;
                else
                   nTotalItemCount += nItemCount;

                if (nRandom <= nTotalItemCount)
                {
                    sArrayToSearch = sBVSearch;
                    break;
                }
            }
        }

        if (iMaxWeaponSize != -1)
            sArrayToSearch += "_WS" + IntToString(Random(iMaxWeaponSize) + 1);

        //SendMessageToAllDMs("Searching for item in '" + sArrayToSearch + "'");
        //SendMessageToAllDMs("# of items: " + IntToString(eas_Array_GetSize(oStore, sArrayToSearch)));

        sReturn = eas_SArray_Entry_Get(oStore, sArrayToSearch, Random(eas_Array_GetSize(oStore, sArrayToSearch)));
        iNumOfBP = GetLocalInt(oStore, CS_EGS_BPCOUNT + sReturn);
        //SendMessageToAllDMs("# of BPs: " + IntToString(iNumOfBP));
    }

    if (sReturn != "")
    {
        if (iNumOfBP > 0)
        {
            int iSelectedBlueprint = Random(iNumOfBP) + 1;
            if (iWillBeMagical)
            {
                if (iSelectedBlueprint < 10)
                {
                    sReturn += "0";
                }
            }
            else
            {
                sReturn += "0";
                iSelectedBlueprint = 1;
            }

            sReturn += IntToString(iSelectedBlueprint);
        }
        return ( sReturn );
    }
    else
    {
        // DEBUG
       // SendMessageToAllDMs("Error selecting a random item");
       // SendMessageToAllDMs(sInfo);
       // SendMessageToAllDMs("Main Category: " + IntToString(iMainCategory) + "\n" +
       //                     "Sub Category: " + IntToString(iSubCategory) + "\n" +
       //                     "Base Item: " + IntToString(iBaseItem) + "\n" +
       //                     "Base Value: " + IntToString(iBaseValue) + "\n" +
      //                     "Max Weapon Size: " + IntToString(iMaxWeaponSize) + "\n" +
      //                      "Magical: " + IntToString(iWillBeMagical));
        return ("error");
   }
}

string egs_GetItem_Any(int iBaseValue = -1, int iWeaponSize = -1, int iWillBeMagical = FALSE)
{
   int iCategory = Random(22);
   int iRandom;
   string sResult;
   switch (iCategory)
   {
      // Body Armor
      case 0: sResult = egs_GetItem_ArmorBody(iBaseValue, iWillBeMagical); break;
      // Shield
      case 1: sResult = egs_GetItem_ArmorShield(iBaseValue, iWillBeMagical); break;
      // Helmet
      case 2: sResult = egs_GetItem_ArmorHelmet(iBaseValue, iWillBeMagical); break;
      // Weapons
      case 3: iRandom = Random(3);
            switch (iRandom)
            {
               case 0: sResult = egs_GetItem_WeaponMelee(iBaseValue, iWeaponSize, iWillBeMagical); break;
               case 1: sResult = egs_GetItem_WeaponRanged(iBaseValue, iWeaponSize, iWillBeMagical); break;
               case 2: sResult = egs_GetItem_WeaponThrown(iBaseValue, iWeaponSize, iWillBeMagical); break;
            }
         break;
      // Ammo
      case 4: sResult = egs_GetItem_Ammo(iBaseValue, iWillBeMagical); break;
      // Ring
      case 5: sResult = egs_GetItem_JewelryRing(iBaseValue, iWillBeMagical); break;
      // Amulet
      case 6: sResult = egs_GetItem_JewelryAmulet(iBaseValue, iWillBeMagical); break;
      // Belt
      case 7: sResult = egs_GetItem_AccessoryBelt(iBaseValue, iWillBeMagical); break;
      // Bracers
      case 8: sResult = egs_GetItem_AccessoryBracers(iBaseValue, iWillBeMagical); break;
      // Gloves
      case 9: sResult = egs_GetItem_AccessoryGlove(iBaseValue, iWillBeMagical); break;
      // Cloaks
      case 10: sResult = egs_GetItem_AccessoryCloak(iBaseValue, iWillBeMagical); break;
      // Boots
      case 11: sResult = egs_GetItem_AccessoryBoots(iBaseValue, iWillBeMagical); break;
      // Bombs
      case 12: sResult = egs_GetItem_Bomb(iBaseValue, iWillBeMagical); break;
      // Containers
      case 13: sResult = egs_GetItem_Container(iBaseValue, iWillBeMagical); break;
      // Healing Kit
      case 14: sResult = egs_GetItem_HealingKit(iBaseValue, iWillBeMagical); break;
      // Trap Kit
      case 15: sResult = egs_GetItem_TrapKit(iBaseValue, iWillBeMagical); break;
      // Thieves Tools
      case 16: sResult = egs_GetItem_ThievesTools(iBaseValue, iWillBeMagical); break;
      // Potion
      case 17: sResult = egs_GetItem_Potion(iBaseValue, iWillBeMagical); break;
      // Wand
      case 18: sResult = egs_GetItem_Wand(iBaseValue, iWillBeMagical); break;
      // Misc. Stuff
      case 19: sResult = egs_GetItem_Misc(iBaseValue, iWillBeMagical); break;
      // Books
      case 20: sResult = egs_GetItem_Book(iBaseValue, iWillBeMagical); break;

      // Scrolls (not included in here because of their nature
      // Scrolls can be from Level 0 - 9. the Level is determined using
      // iBaseValue / 2.5
      // case 21: sResult = ip_GetRandomScroll(FloatToInt(iBaseValue / 2.5)); break;
   }
   return (sResult);
}

string egs_GetItem_Armor(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(CI_EGS_ITEM_MAIN_ARMOR, -1, -1, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_ArmorClothing(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, CI_EGS_ITEM_SUB_ARMOR_BODY_CLOTHING, -1, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_ArmorLight(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, CI_EGS_ITEM_SUB_ARMOR_BODY_LIGHT, -1, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_ArmorMedium(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, CI_EGS_ITEM_SUB_ARMOR_BODY_MEDIUM, -1, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_ArmorHeavy(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, CI_EGS_ITEM_SUB_ARMOR_BODY_HEAVY, -1, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_ArmorBody(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   int iRandom = Random(4);
   string sResult;
   switch (iRandom)
   {
      case 0: sResult = egs_GetItem_ArmorClothing(iBaseValue, iWillBeMagical); break;
      case 1: sResult = egs_GetItem_ArmorLight(iBaseValue, iWillBeMagical); break;
      case 2: sResult = egs_GetItem_ArmorMedium(iBaseValue, iWillBeMagical); break;
      case 3: sResult = egs_GetItem_ArmorHeavy(iBaseValue, iWillBeMagical); break;
   }
   return (sResult);
}

string egs_GetItem_ArmorHelmet(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, CI_EGS_ITEM_SUB_ARMOR_HELMET, -1, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_ArmorShield(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, CI_EGS_ITEM_SUB_ARMOR_SHIELD, -1, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_ArmorShieldSmall(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, -1, BASE_ITEM_SMALLSHIELD, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_ArmorShieldLarge(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, -1, BASE_ITEM_LARGESHIELD, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_ArmorShieldTower(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, -1, BASE_ITEM_TOWERSHIELD, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_Weapon(int iBaseValue = -1, int iWeaponSize = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(CI_EGS_ITEM_MAIN_WEAPON, -1, -1, iBaseValue, iWeaponSize, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_WeaponMelee(int iBaseValue = -1, int iWeaponSize = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, CI_EGS_ITEM_SUB_WEAPON_MELEE, -1, iBaseValue, iWeaponSize, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_WeaponRanged(int iBaseValue = -1, int iWeaponSize = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, CI_EGS_ITEM_SUB_WEAPON_RANGED, -1, iBaseValue, iWeaponSize, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_WeaponThrown(int iBaseValue = -1, int iWeaponSize = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, CI_EGS_ITEM_SUB_WEAPON_THROWN, -1, iBaseValue, iWeaponSize, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_Ammo(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(CI_EGS_ITEM_MAIN_AMMO, -1, -1, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_Jewelry(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, CI_EGS_ITEM_SUB_ACCESSORY_JEWELRY, -1, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_JewelryRing(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, -1, BASE_ITEM_RING, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_JewelryAmulet(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, -1, BASE_ITEM_AMULET, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_Accessory(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(CI_EGS_ITEM_MAIN_ACCESSORY, -1, -1, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_AccessoryBelt(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, -1, BASE_ITEM_BELT, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_AccessoryBoots(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, -1, BASE_ITEM_BOOTS, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_AccessoryCloak(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, -1, BASE_ITEM_CLOAK, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_AccessoryGlove(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, -1, BASE_ITEM_GLOVES, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_AccessoryBracers(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, -1, BASE_ITEM_BRACER, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_Bomb(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(CI_EGS_ITEM_MAIN_BOMB, -1, -1, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_Wand(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(CI_EGS_ITEM_MAIN_RODWAND, -1, -1, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_Staff(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, CI_EGS_ITEM_SUB_WEAPON_STAFF, -1, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_Potion(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, -1, BASE_ITEM_POTIONS, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_HealingKit(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, -1, BASE_ITEM_HEALERSKIT, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_ThievesTools(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, -1, BASE_ITEM_THIEVESTOOLS, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_TrapKit(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, -1, BASE_ITEM_TRAPKIT, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_Misc(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(CI_EGS_ITEM_MAIN_MISC, -1, -1, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_MiscTorch(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, -1, BASE_ITEM_TORCH, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_Container(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(CI_EGS_ITEM_MAIN_CONTAINER, -1, -1, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_Book(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(-1, -1, BASE_ITEM_BOOK, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}

string egs_GetItem_Food(int iBaseValue = -1, int iWillBeMagical = FALSE)
{
   string sResult = egs_GetRandomItem(CI_EGS_ITEM_MAIN_FOOD, -1, -1, iBaseValue, -1, iWillBeMagical);
   return (sResult);
}
