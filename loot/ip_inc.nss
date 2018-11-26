///////////////////////////////////////////////////////////////////////////////
// ip_inc
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: Include File for the Magic Property System

///////////
// Includes
//
// Needs:
// #include "egs_inc"
#include "nwnx_sql"
#include "mod_cfg"
#include "egs_inc"
#include "ip_cfg"
#include "ip_rnd_inc"
#include "ip_names_inc"
#include "x2_inc_itemprop"
#include "x0_i0_stringlib"
#include "eas_inc"

///////////////////////
// Function Declaration
//

// Help for IP
void ip_Help();

// Recreate the DB Table
void ip_CreateTable();

// Returns FALSE if any of the required System Tables is missing
int ip_GetTableExists();

// Drops all System Tables
void ip_DropTable();

// ip_AddProperty
// PlayerOnly does not work w/o NWNX
// VarThree should always be 0 and is not used w/o NWNX to improve performance
void ip_AddProperty(int iProperty, int iType, string sCategoriesMain, string sCategoriesSub, string sBaseItems, int iLevel, int iVarOne, int iVarTwo, int iVarThree, int iMonsterOnly = FALSE, int iPlayerOnly = FALSE);

// Get a Random Item Property with the given criteria
struct STRUCT_IP_PropertyDetails ip_GetProperty(int iItemMainCategory = -1, int iItemSubCategory = -1, int iItemBaseItem = -1, int iLevel = -1, int iType = -1, int iMonster = FALSE, int iProperty = -1);

// Infuse an item with Magic
void ip_InfuseItemWithMagic(object oItem, int iMaxMagicLevel = 50, int iForceLevel = FALSE, int iIdentified = FALSE, int iNameItem = TRUE, int iIncludeMonsterOnly = FALSE, int iNumberOfProperties = -1, int iOverrideMaxAllowedConfig = -1);

// Returns a specific property
struct STRUCT_IP_PropertyDetails ip_GetSpecificProperty(int iBaseItem, int iProperty, int iVar1 = 0, int iVar2 = 0, int iVar3 = 0);

////////////////
// Function Code
//
void ip_Help()
{
}

// Private NON-NWNx helper code
void Create_IP_Item(object oStore, string sArray, string sPropertyIdentifier, int iPropID, int iVarOne, int iVarTwo, int iVarThree, string sVarOne, string sVarTwo, string sVarThree)
{
    SetLocalInt(oStore, CS_IP_ID + sPropertyIdentifier, iPropID);
    SetLocalInt(oStore, CS_IP_VARONE + sPropertyIdentifier, iVarOne);
    SetLocalInt(oStore, CS_IP_VARTWO + sPropertyIdentifier, iVarTwo);
    SetLocalInt(oStore, CS_IP_VARTHREE + sPropertyIdentifier, iVarThree);

    // Create the default array
    eas_Array_Create(oStore, sArray, EAS_ARRAY_TYPE_STRING);
    eas_SArray_Entry_Add(oStore, sArray, sPropertyIdentifier);

    // Create the VarOne Array
    eas_Array_Create(oStore, sArray + sVarOne, EAS_ARRAY_TYPE_STRING);
    eas_SArray_Entry_Add(oStore, sArray + sVarOne, sPropertyIdentifier);

    // Create the VarTwo Array
    eas_Array_Create(oStore, sArray + sVarTwo, EAS_ARRAY_TYPE_STRING);
    eas_SArray_Entry_Add(oStore, sArray + sVarTwo, sPropertyIdentifier);

    // Create the VarThree Array
    //eas_Array_Create(oStore, sArray + sVarThree);
    //eas_SArray_Entry_Add(oStore, sArray + sVarThree, sPropertyIdentifier);

    // Create the Combined Arrays
    eas_Array_Create(oStore, sArray + sVarOne + sVarTwo, EAS_ARRAY_TYPE_STRING);
    eas_SArray_Entry_Add(oStore, sArray + sVarOne + sVarTwo, sPropertyIdentifier);
    //eas_Array_Create(oStore, sArray + sVarOne + sVarTwo + sVarThree);
    //eas_SArray_Entry_Add(oStore, sArray + sVarOne + sVarTwo + sVarThree, sPropertyIdentifier);
    //eas_Array_Create(oStore, sArray + sVarOne + sVarThree);
    //eas_SArray_Entry_Add(oStore, sArray + sVarOne + sVarThree, sPropertyIdentifier);

    //eas_Array_Create(oStore, sArray + sVarTwo + sVarThree);
    //eas_SArray_Entry_Add(oStore, sArray + sVarTwo + sVarThree, sPropertyIdentifier);
}

int ip_GetTableExists()
{
    if (CI_IP_USE_NWNX)
    {
        int nExists_Table = NWNX_SQL_ExecuteQuery("DESCRIBE " + CS_IP_TABLE);
        return (nExists_Table);
    }
    else
        return FALSE;
}

void ip_DropTable()
{
    if (CI_IP_USE_NWNX)
        NWNX_SQL_ExecuteQuery("DROP TABLE " + CS_IP_TABLE);
}

void ip_CreateTable()
{
    if (CI_IP_USE_NWNX)
    {
        NWNX_SQL_ExecuteQuery("DROP TABLE " + CS_IP_TABLE);
        string sSQL = "CREATE TABLE " + CS_IP_TABLE + " (";
        sSQL += CS_IP_ID + " int NOT NULL, ";
        sSQL += CS_IP_TYPE + " int DEFAULT NULL, ";
        sSQL += CS_IP_CATEGORIES_MAIN + " varchar(32) DEFAULT NULL, ";
        sSQL += CS_IP_CATEGORIES_SUB + " varchar(32) DEFAULT NULL, ";
        sSQL += CS_IP_BASEITEMS + " varchar(32) DEFAULT NULL, ";
        sSQL += CS_IP_LEVEL + " int DEFAULT NULL, ";
        sSQL += CS_IP_VARONE + " int DEFAULT NULL, ";
        sSQL += CS_IP_VARTWO + " int DEFAULT NULL, ";
        sSQL += CS_IP_VARTHREE + " int DEFAULT NULL, ";
        sSQL += CS_IP_MONSTERONLY + " int NOT NULL default 0, ";
        sSQL += CS_IP_PLAYERONLY + " int NOT NULL default 0, ";
        sSQL += "KEY idx (" + CS_IP_ID + ", " + CS_IP_TYPE + ", " + CS_IP_CATEGORIES_MAIN + ", " + CS_IP_CATEGORIES_SUB + ", " + CS_IP_BASEITEMS + ", " + CS_IP_LEVEL + ", " + CS_IP_VARONE + ", " + CS_IP_VARTWO + ", " + CS_IP_VARTHREE + ", " + CS_IP_MONSTERONLY + ", " + CS_IP_PLAYERONLY + "))";
        NWNX_SQL_ExecuteQuery(sSQL);
    }
    else
    {
        object oStoreWaypoint = GetObjectByTag(CS_IP_DB_WAYPOINT);
        CreateObject(OBJECT_TYPE_STORE, CS_IP_DB_MERCHANT_RESREF, GetLocation(oStoreWaypoint), FALSE, CS_IP_DB_MERCHANT_ID);
        CreateObject(OBJECT_TYPE_STORE, CS_IP_DB_MERCHANT_RESREF, GetLocation(oStoreWaypoint), FALSE, CS_IP_DB_MERCHANT_MAIN);
        CreateObject(OBJECT_TYPE_STORE, CS_IP_DB_MERCHANT_RESREF, GetLocation(oStoreWaypoint), FALSE, CS_IP_DB_MERCHANT_SUB);
        CreateObject(OBJECT_TYPE_STORE, CS_IP_DB_MERCHANT_RESREF, GetLocation(oStoreWaypoint), FALSE, CS_IP_DB_MERCHANT_BASE);
        CreateObject(OBJECT_TYPE_STORE, CS_IP_DB_MERCHANT_RESREF, GetLocation(oStoreWaypoint), FALSE, CS_IP_DB_MERCHANT_MONSTERONLY_ID);
        CreateObject(OBJECT_TYPE_STORE, CS_IP_DB_MERCHANT_RESREF, GetLocation(oStoreWaypoint), FALSE, CS_IP_DB_MERCHANT_MONSTERONLY_MAIN);
        CreateObject(OBJECT_TYPE_STORE, CS_IP_DB_MERCHANT_RESREF, GetLocation(oStoreWaypoint), FALSE, CS_IP_DB_MERCHANT_MONSTERONLY_SUB);
        CreateObject(OBJECT_TYPE_STORE, CS_IP_DB_MERCHANT_RESREF, GetLocation(oStoreWaypoint), FALSE, CS_IP_DB_MERCHANT_MONSTERONLY_BASE);
    }
}

void ip_AddProperty(int iProperty,
                    int iType,
                    string sCategoriesMain,
                    string sCategoriesSub,
                    string sBaseItems,
                    int iLevel,
                    int iVarOne,
                    int iVarTwo,
                    int iVarThree,
                    int iMonsterOnly = FALSE,
                    int iPlayerOnly = FALSE)
{
    if (CI_IP_USE_NWNX)
    {
        sCategoriesMain = "'" + sCategoriesMain + "'";
        sCategoriesSub = "'" + sCategoriesSub + "'";
        sBaseItems = "'" + sBaseItems + "'";
        string sSQL = "INSERT INTO " + CS_IP_TABLE + " (" + CS_IP_ID + ", " + CS_IP_TYPE + ", " + CS_IP_CATEGORIES_MAIN + ", " + CS_IP_CATEGORIES_SUB + ", " + CS_IP_BASEITEMS + ", " + CS_IP_LEVEL + ", " + CS_IP_VARONE + ", " + CS_IP_VARTWO + ", " + CS_IP_VARTHREE + ", " + CS_IP_MONSTERONLY + ", " + CS_IP_PLAYERONLY + ") ";
        sSQL += "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedInt(0, iProperty);
        NWNX_SQL_PreparedInt(1, iType);
        NWNX_SQL_PreparedString(2, sCategoriesMain);
        NWNX_SQL_PreparedString(3, sCategoriesSub);
        NWNX_SQL_PreparedString(4, sBaseItems);
        NWNX_SQL_PreparedInt(5, iLevel);
        NWNX_SQL_PreparedInt(6, iVarOne);
        NWNX_SQL_PreparedInt(7, iVarTwo);
        NWNX_SQL_PreparedInt(8, iVarThree);
        NWNX_SQL_PreparedInt(9, iMonsterOnly);
        NWNX_SQL_PreparedInt(10, iPlayerOnly);
        NWNX_SQL_ExecutePreparedQuery();
    }
    else
    {
        // First, we have to split the category strings and put them in a string array
        object oArrayStore = GetObjectByTag(CS_IP_DB_AREA);
        int n;
        string sToken;

        // Create the Temporary Arrays
        eas_Array_Create(oArrayStore, CS_IP_DB_TEMPARRAY_MAINCATEGORIES, EAS_ARRAY_TYPE_STRING);
        eas_Array_Create(oArrayStore, CS_IP_DB_TEMPARRAY_SUBCATEGORIES, EAS_ARRAY_TYPE_STRING);
        eas_Array_Create(oArrayStore, CS_IP_DB_TEMPARRAY_BASEITEMS, EAS_ARRAY_TYPE_STRING);

        // Fill the Arrays
        if (sCategoriesMain != "")
        {
            n = 1;
            sToken = GetTokenByPosition(sCategoriesMain, ";", n);
            while (sToken != "")
            {
                eas_SArray_Entry_Add(oArrayStore, CS_IP_DB_TEMPARRAY_MAINCATEGORIES, sToken);
                n++;
                sToken = GetTokenByPosition(sCategoriesMain, ";", n);
            }
        }
        if (sCategoriesSub != "")
        {
            n = 1;
            sToken = GetTokenByPosition(sCategoriesSub, ";", n);
            while (sToken != "")
            {
                eas_SArray_Entry_Add(oArrayStore, CS_IP_DB_TEMPARRAY_SUBCATEGORIES, sToken);
                n++;
                sToken = GetTokenByPosition(sCategoriesSub, ";", n);
            }
        }
        if (sBaseItems != "")
        {
            n = 1;
            sToken = GetTokenByPosition(sBaseItems, ";", n);
            while (sToken != "")
            {
                eas_SArray_Entry_Add(oArrayStore, CS_IP_DB_TEMPARRAY_BASEITEMS, sToken);
                n++;
                sToken = GetTokenByPosition(sBaseItems, ";", n);
            }
        }

        // Get the Merchant Object
        // For Item Properties, we HAVE to use more than one else things slow down really hard
        object oStore_ID = GetObjectByTag(CS_IP_DB_MERCHANT_ID);
        object oStore_Main = GetObjectByTag(CS_IP_DB_MERCHANT_MAIN);
        object oStore_Sub = GetObjectByTag(CS_IP_DB_MERCHANT_SUB);
        object oStore_Base = GetObjectByTag(CS_IP_DB_MERCHANT_BASE);
        object oStore_MonsterOnly_ID = GetObjectByTag(CS_IP_DB_MERCHANT_MONSTERONLY_ID);
        object oStore_MonsterOnly_Main = GetObjectByTag(CS_IP_DB_MERCHANT_MONSTERONLY_MAIN);
        object oStore_MonsterOnly_Sub = GetObjectByTag(CS_IP_DB_MERCHANT_MONSTERONLY_SUB);
        object oStore_MonsterOnly_Base = GetObjectByTag(CS_IP_DB_MERCHANT_MONSTERONLY_BASE);

        string sPropertyIdentifier;
        string sArrayName;
        int nCategory;

        string sVarOne = "_V1" + IntToString(iVarOne);
        string sVarTwo = "_V2" + IntToString(iVarTwo);
        string sVarThree = "_V3" + IntToString(iVarThree);

        int nMainCategories = eas_Array_GetSize(oArrayStore, CS_IP_DB_TEMPARRAY_MAINCATEGORIES);
        int nSubCategories = eas_Array_GetSize(oArrayStore, CS_IP_DB_TEMPARRAY_SUBCATEGORIES);
        int nBaseItems = eas_Array_GetSize(oArrayStore, CS_IP_DB_TEMPARRAY_BASEITEMS);
        string sCategoryID;

        // Create the IP in the ID Store
        sPropertyIdentifier = "IP_" + IntToString(iProperty)+ "_L" + IntToString(iLevel) + "_T" + IntToString(iType);
        if (!iMonsterOnly)
        {
           SetLocalInt(oStore_ID, CS_IP_ID + sPropertyIdentifier, iProperty);
           SetLocalInt(oStore_ID, CS_IP_VARONE + sPropertyIdentifier, iVarOne);
           SetLocalInt(oStore_ID, CS_IP_VARTWO + sPropertyIdentifier, iVarTwo);
           SetLocalInt(oStore_ID, CS_IP_VARTHREE + sPropertyIdentifier, iVarThree);
        }
        SetLocalInt(oStore_MonsterOnly_ID, CS_IP_ID + sPropertyIdentifier, iProperty);
        SetLocalInt(oStore_MonsterOnly_ID, CS_IP_VARONE + sPropertyIdentifier, iVarOne);
        SetLocalInt(oStore_MonsterOnly_ID, CS_IP_VARTWO + sPropertyIdentifier, iVarTwo);
        SetLocalInt(oStore_MonsterOnly_ID, CS_IP_VARTHREE + sPropertyIdentifier, iVarThree);

        // Create the IP in the MainCategory Store
        for (nCategory = 0; nCategory < nMainCategories; nCategory++)
        {
            sCategoryID = eas_SArray_Entry_Get(oArrayStore, CS_IP_DB_TEMPARRAY_MAINCATEGORIES, nCategory);
            sArrayName = CS_IP_ARRAY_MAINCATEGORY + sCategoryID + "_L" + IntToString(iLevel) + "_T" + IntToString(iType);
            sPropertyIdentifier = "IP_" + IntToString(iProperty) + "_MC" + sCategoryID + "_L" + IntToString(iLevel) + "_T" + IntToString(iType) + sVarOne + sVarTwo + sVarThree;
            if (!iMonsterOnly)
                Create_IP_Item(oStore_Main, sArrayName, sPropertyIdentifier, iProperty, iVarOne, iVarTwo, iVarThree, sVarOne, sVarTwo, sVarThree);
            Create_IP_Item(oStore_MonsterOnly_Main, sArrayName, sPropertyIdentifier, iProperty, iVarOne, iVarTwo, iVarThree, sVarOne, sVarTwo, sVarThree);
        }

        // Create the IP in the SubCategory Store
        for (nCategory = 0; nCategory < nSubCategories; nCategory++)
        {
            sCategoryID = eas_SArray_Entry_Get(oArrayStore, CS_IP_DB_TEMPARRAY_SUBCATEGORIES, nCategory);
            sArrayName = CS_IP_ARRAY_SUBCATEGORY + sCategoryID + "_L" + IntToString(iLevel) + "_T" + IntToString(iType);
            sPropertyIdentifier = "IP_" + IntToString(iProperty) + "_SC" + sCategoryID + "_L" + IntToString(iLevel) + "_T" + IntToString(iType) + sVarOne + sVarTwo + sVarThree;
            if (!iMonsterOnly)
                Create_IP_Item(oStore_Sub, sArrayName, sPropertyIdentifier, iProperty, iVarOne, iVarTwo, iVarThree, sVarOne, sVarTwo, sVarThree);
            Create_IP_Item(oStore_MonsterOnly_Sub, sArrayName, sPropertyIdentifier, iProperty, iVarOne, iVarTwo, iVarThree, sVarOne, sVarTwo, sVarThree);
        }

        // Create the IP in the BaseItem Store
        for (nCategory = 0; nCategory < nBaseItems; nCategory++)
        {
            sCategoryID = eas_SArray_Entry_Get(oArrayStore, CS_IP_DB_TEMPARRAY_BASEITEMS, nCategory);
            sArrayName = CS_IP_ARRAY_BASEITEM + sCategoryID + "_L" + IntToString(iLevel) + "_T" + IntToString(iType);
            sPropertyIdentifier = "IP_" + IntToString(iProperty) + "_BI" + sCategoryID + "_L" + IntToString(iLevel) + "_T" + IntToString(iType) + sVarOne + sVarTwo + sVarThree;
            if (!iMonsterOnly)
                Create_IP_Item(oStore_Base, sArrayName, sPropertyIdentifier, iProperty, iVarOne, iVarTwo, iVarThree, sVarOne, sVarTwo, sVarThree);
            Create_IP_Item(oStore_MonsterOnly_Base, sArrayName, sPropertyIdentifier, iProperty, iVarOne, iVarTwo, iVarThree, sVarOne, sVarTwo, sVarThree);
        }

        // Destroy the temporary string arrays
        eas_Array_Delete(oArrayStore, CS_IP_DB_TEMPARRAY_MAINCATEGORIES);
        eas_Array_Delete(oArrayStore, CS_IP_DB_TEMPARRAY_SUBCATEGORIES);
        eas_Array_Delete(oArrayStore, CS_IP_DB_TEMPARRAY_BASEITEMS);
    }
}

int WeightedRandom(int nPossibilities, int nRandomMax, object oArrayStore)
{
    int nRoll = Random(nRandomMax);
    int n;
    int nWorth;
    for (n = 0 ; n < nPossibilities; n++)
    {
        nWorth = GetLocalInt(oArrayStore, IntToString(n));
        if(nRoll < nWorth)
        {
            return ( n );
        }
        nRoll -= nWorth;
    }

    return 0;
}

struct STRUCT_IP_PropertyDetails ip_GetProperty(int iItemMainCategory = -1,
                              int iItemSubCategory = -1,
                              int iItemBaseItem = -1,
                              int iLevel = -1,
                              int iType = -1,
                              int iMonster = FALSE,
                              int iProperty = -1)
{
    struct STRUCT_IP_PropertyDetails strResult;
    if (CI_IP_USE_NWNX)
    {
        string sSQL_Property_ID = "SELECT DISTINCT " + CS_IP_ID + " FROM " + CS_IP_TABLE + " WHERE ";
        string sSQL = "SELECT " + CS_IP_ID + ", " + CS_IP_VARONE + ", " + CS_IP_VARTWO + ", " + CS_IP_VARTHREE + " FROM " + CS_IP_TABLE + " WHERE ";

        int iAND = FALSE;
        string sWhere = "";
        if (iItemMainCategory > -1)
        {
            sWhere += "(" + CS_IP_CATEGORIES_MAIN + " LIKE '%;" + IntToString(iItemMainCategory) + ";%'";
            iAND = TRUE;
        }
        if (iItemSubCategory > -1)
        {
            if (iAND)
                sWhere += " OR ";
            else
                sWhere += "(";

            sWhere += CS_IP_CATEGORIES_SUB + " LIKE '%;" + IntToString(iItemSubCategory) + ";%'";
            iAND = TRUE;
        }
        if (iItemBaseItem > -1)
        {
            if (iAND)
                sWhere += " OR ";

            else
                sWhere += "(";

            sWhere += CS_IP_BASEITEMS + " LIKE '%;" + IntToString(iItemBaseItem) + ";%'";
            iAND = TRUE;
        }

        if (iAND)
            sWhere += ")";

        if (iLevel > -1)
        {
            if (iAND)
                sWhere += " AND ";

            sWhere += CS_IP_LEVEL + " = " + IntToString(iLevel);
            iAND = TRUE;
        }
        if (iType > -1)
        {
            if (iAND)
                sWhere += " AND ";

            sWhere += CS_IP_TYPE + " = " + IntToString(iType);
            iAND = TRUE;
        }
        if (iProperty > -1)
        {
            if (iAND)
                sWhere += " AND ";

            sWhere += CS_IP_ID + " = " + IntToString(iProperty);
            iAND = TRUE;
        }

        if (iAND && iMonster == FALSE)
            sWhere += " AND ";
        if (iMonster == FALSE)
            sWhere += CS_IP_MONSTERONLY + " = 0";

        sSQL += sWhere;
        sSQL_Property_ID += sWhere;
        sSQL_Property_ID += " ORDER BY rand() LIMIT 1";

        // Execute first query to determine property
        NWNX_SQL_ExecuteQuery(sSQL_Property_ID);
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            string sProperty_ID = NWNX_SQL_ReadDataInActiveRow(0);
            if (iAND)
                sSQL += " AND ";
            sSQL += CS_IP_ID + " = " + sProperty_ID;
        }

        sSQL += " ORDER BY rand() LIMIT 1";

        NWNX_SQL_ExecuteQuery(sSQL);
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            int iPropID = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
            int iVar1 = StringToInt(NWNX_SQL_ReadDataInActiveRow(1));
            int iVar2 = StringToInt(NWNX_SQL_ReadDataInActiveRow(2));
            int iVar3 = StringToInt(NWNX_SQL_ReadDataInActiveRow(3));
            strResult = ( ip_GetSpecificProperty( iItemBaseItem, iPropID, iVar1, iVar2, iVar3 ) );
            strResult.PropID = iPropID;
            return (strResult);
        }
        else
        {
            strResult.PropID = CI_IP_Invalid;
            return (strResult);
        }
    }
    else
    {
        // Get the Merchant Object
        object oStore_ID;
        object oStore_Main;
        object oStore_Sub;
        object oStore_Base;
        if (!iMonster)
        {
            oStore_ID = GetObjectByTag(CS_IP_DB_MERCHANT_ID);
            oStore_Main = GetObjectByTag(CS_IP_DB_MERCHANT_MAIN);
            oStore_Sub = GetObjectByTag(CS_IP_DB_MERCHANT_SUB);
            oStore_Base = GetObjectByTag(CS_IP_DB_MERCHANT_BASE);
        }
        else
        {
            oStore_ID = GetObjectByTag(CS_IP_DB_MERCHANT_MONSTERONLY_ID);
            oStore_Main = GetObjectByTag(CS_IP_DB_MERCHANT_MONSTERONLY_MAIN);
            oStore_Sub = GetObjectByTag(CS_IP_DB_MERCHANT_MONSTERONLY_SUB);
            oStore_Base = GetObjectByTag(CS_IP_DB_MERCHANT_MONSTERONLY_BASE);
        }

        // Select the array that contains appropriate Item Properties
        int nArray_ID;
        int nArray_Main;
        int nArray_Sub;
        int nArray_Base;
        string sMonsterOnly = "_MO" + IntToString(iMonster);
        string sArray_ID = CS_IP_ARRAY_ID + "_L" + IntToString(iLevel) + "_T" + IntToString(iType);
        string sArray_Main = CS_IP_ARRAY_MAINCATEGORY + IntToString(iItemMainCategory) + "_L" + IntToString(iLevel) + "_T" + IntToString(iType);
        string sArray_Sub = CS_IP_ARRAY_SUBCATEGORY + IntToString(iItemSubCategory) + "_L" + IntToString(iLevel) + "_T" + IntToString(iType);
        string sArray_Base = CS_IP_ARRAY_BASEITEM + IntToString(iItemBaseItem) + "_L" + IntToString(iLevel) + "_T" + IntToString(iType);

        if (iItemMainCategory != -1)
        {
            nArray_Main = eas_Array_Exists(oStore_Main, sArray_Main);
        }
        if (iItemSubCategory != -1)
        {
            nArray_Sub = eas_Array_Exists(oStore_Sub, sArray_Sub);
        }
        if (iItemBaseItem != -1)
        {
            nArray_Base = eas_Array_Exists(oStore_Base, sArray_Base);
        }

        // If no usable Array was found, exit this method
        if (iProperty == -1 &&
            !nArray_Main &&
            !nArray_Sub &&
            !nArray_Base)
        {
            strResult.PropID = CI_IP_Invalid;
            return (strResult);
        }

        string sPropertyInfo = "";
        object oSelectedStore;
        // If we want a specific property, do that
        if (iProperty != -1)
        {
           string sPropertyIdentifier = "IP_" + IntToString(iProperty)+ "_L" + IntToString(iLevel) + "_T" + IntToString(iType);

           int iPropID = GetLocalInt(oStore_ID, CS_IP_ID + sPropertyIdentifier);
           int iVar1 = GetLocalInt(oStore_ID, CS_IP_VARONE + sPropertyIdentifier);
           int iVar2 = GetLocalInt(oStore_ID, CS_IP_VARTWO + sPropertyIdentifier);
           int iVar3 = GetLocalInt(oStore_ID, CS_IP_VARTHREE + sPropertyIdentifier);
           strResult = ( ip_GetSpecificProperty( iItemBaseItem, iPropID, iVar1, iVar2, iVar3 ) );
           strResult.PropID = iPropID;

           return (strResult);
        }
        else
        {
           object oArrayStore = GetObjectByTag(CS_IP_DB_AREA);
           // Now get a random Property from the selected store(s), beginning by Base
           string sPropertyInfo_Base = "";
           string sPropertyInfo_Sub = "";
           string sPropertyInfo_Main = "";
           int nArraySize_Base = eas_Array_GetSize(oStore_Base, sArray_Base);
           int nArraySize_Sub = eas_Array_GetSize(oStore_Sub, sArray_Sub);
           int nArraySize_Main = eas_Array_GetSize(oStore_Main, sArray_Main);

           if (nArray_Base)
               sPropertyInfo_Base = eas_SArray_Entry_Get(oStore_Base, sArray_Base, Random(nArraySize_Base));

           if (nArray_Sub)
               sPropertyInfo_Sub = eas_SArray_Entry_Get(oStore_Sub, sArray_Sub, Random(nArraySize_Sub));

           if (nArray_Main)
               sPropertyInfo_Main = eas_SArray_Entry_Get(oStore_Main, sArray_Main, Random(nArraySize_Main));

           eas_Array_Create(oArrayStore, CS_IP_DB_TEMPARRAY_STORE, EAS_ARRAY_TYPE_OBJECT);
           eas_Array_Create(oArrayStore, CS_IP_DB_TEMPARRAY_SELECTIP, EAS_ARRAY_TYPE_STRING);
           int nRandomMax = 0;
           int nWorth;
           int nPossibilities = 0;

           if (sPropertyInfo_Base != "")
           {
               nWorth = nArraySize_Base;
               eas_OArray_Entry_Add(oArrayStore, CS_IP_DB_TEMPARRAY_STORE, oStore_Base);
               eas_SArray_Entry_Add(oArrayStore, CS_IP_DB_TEMPARRAY_SELECTIP, sPropertyInfo_Base);
               nRandomMax += nWorth;
               SetLocalInt(oArrayStore, IntToString(nPossibilities), nWorth);
               nPossibilities += 1;
           }
           if (sPropertyInfo_Sub != "")
           {
               nWorth = nArraySize_Sub;
               eas_OArray_Entry_Add(oArrayStore, CS_IP_DB_TEMPARRAY_STORE, oStore_Sub);
               eas_SArray_Entry_Add(oArrayStore, CS_IP_DB_TEMPARRAY_SELECTIP, sPropertyInfo_Sub);
               nRandomMax += nWorth;
               SetLocalInt(oArrayStore, IntToString(nPossibilities), nWorth);
               nPossibilities += 1;
           }
           if (sPropertyInfo_Main != "")
           {
               nWorth = nArraySize_Main;
               eas_OArray_Entry_Add(oArrayStore, CS_IP_DB_TEMPARRAY_STORE, oStore_Main);
               eas_SArray_Entry_Add(oArrayStore, CS_IP_DB_TEMPARRAY_SELECTIP, sPropertyInfo_Main);
               nRandomMax += nWorth;
               SetLocalInt(oArrayStore, IntToString(nPossibilities), nWorth);
               nPossibilities += 1;
           }
           // Do the weighted randomizer
           int nRandom = WeightedRandom(nPossibilities, nRandomMax, oArrayStore);

           object oSelectedStore = eas_OArray_Entry_Get(oArrayStore, CS_IP_DB_TEMPARRAY_STORE, nRandom);
           sPropertyInfo = eas_SArray_Entry_Get(oArrayStore, CS_IP_DB_TEMPARRAY_SELECTIP, nRandom);

           eas_Array_Delete(oArrayStore, CS_IP_DB_TEMPARRAY_SELECTIP);
           eas_Array_Delete(oArrayStore, CS_IP_DB_TEMPARRAY_STORE);

           if (sPropertyInfo != "")
           {
              int iPropID = GetLocalInt(oSelectedStore, CS_IP_ID + sPropertyInfo);
              int iVar1 = GetLocalInt(oSelectedStore, CS_IP_VARONE + sPropertyInfo);
              int iVar2 = GetLocalInt(oSelectedStore, CS_IP_VARTWO + sPropertyInfo);
              int iVar3 = GetLocalInt(oSelectedStore, CS_IP_VARTHREE + sPropertyInfo);
              strResult = ( ip_GetSpecificProperty( iItemBaseItem, iPropID, iVar1, iVar2, iVar3 ) );
              strResult.PropID = iPropID;

              return (strResult);
           }
           else
           {
              SendMessageToAllDMs("Invalid property");
              strResult.PropID = CI_IP_Invalid;
              return (strResult);
           }
       }
   }
}

void ip_InfuseItemWithMagic(object oItem, int iMaxMagicLevel = 50, int iForceLevel = FALSE, int iIdentified = FALSE, int iNameItem = TRUE, int iIncludeMonsterOnly = FALSE, int iNumberOfProperties = -1, int iOverrideMaxAllowedConfig = -1)
{
   // If oItem is Invalid, quit right away
   if (!GetIsObjectValid(oItem))
      return;

   // Let's get all info on this item first
   struct STRUCT_EGS_ITEMINFO strItem;
   string sItemTag = GetTag(oItem);
   strItem = egs_GetItemInfo(sItemTag);

   // If no item was found, try using the item object
   if (strItem.MainCategory == 0)
      strItem = egs_GetItemObjectInfo(oItem);

   /*DEBUG
   SendMessageToAllDMs("Infusing Item '" + sItemTag + "'\n" +
                       "Main Category: " + IntToString(strItem.MainCategory) + "\n" +
                       "Sub Category: " + IntToString(strItem.SubCategory) + "\n" +
                       "Base Item: " + IntToString(strItem.BaseItem));
   END DEBUG*/

   // Let's do some precalculations here

   // What's the true MagicLevel we start with?
   // int iActualLevel = Random(iMaxMagicLevel) + 1;
   int iActualLevel = iMaxMagicLevel;

   // Now we will further reduce the magic level by chance
   int iMinusChance;
   int iCount;
   int iReduceLoop = iMaxMagicLevel / 2;
   for (iCount = 0; iCount < iReduceLoop; iCount++)
   {
      iMinusChance = d100();
      if (iMinusChance < (99 - (iCount * 4)) )
         iActualLevel--;
      else
         break;
   }

   if (iForceLevel)
      iActualLevel = iMaxMagicLevel;

   // Retrieve the maximum allowed iLevel
   int nMaxAllowedByConfig = iOverrideMaxAllowedConfig;
   if (nMaxAllowedByConfig == -1)
      nMaxAllowedByConfig = CI_IP_MAXMAGICLEVEL;

   if (iActualLevel < 1)                                    // if level < 1, set to 1
      iActualLevel = 1;
   else if (iActualLevel > nMaxAllowedByConfig &&           // if level > max allowed and NOT only monsters, set to max allowed
            !iIncludeMonsterOnly)
      iActualLevel = nMaxAllowedByConfig;
   else if (iActualLevel > CI_IP_MAXMAGICLEVEL_MONSTERONLY) // if level > max allowed monsterlevel, set to max allowed monsterlevel
      iActualLevel = CI_IP_MAXMAGICLEVEL_MONSTERONLY;

   // Some items can't be magical
   switch (strItem.MainCategory)
   {
      case CI_EGS_ITEM_MAIN_FOOD:
         return;
      case CI_EGS_ITEM_MAIN_BOMB:
         return;
      break;
   }

   // Some items need to be created with a Property in the toolset, here we're
   // deleting that temporary Property. Furthermore, these items are only
   // allowed to have ONE Property, we set them here.
   //
   // Some items are not getting properties at all
   int iStopAfterFirst = FALSE;
   int iAddedRestrictiveChance = 0;
   switch (strItem.BaseItem)
   {
      case BASE_ITEM_POTIONS:
         iStopAfterFirst = TRUE;
         RemoveItemProperty(oItem, GetFirstItemProperty(oItem));
      break;
      case BASE_ITEM_TRAPKIT:
         iStopAfterFirst = TRUE;
         RemoveItemProperty(oItem, GetFirstItemProperty(oItem));
      break;
      case BASE_ITEM_MAGICWAND:
         iStopAfterFirst = TRUE;
         RemoveItemProperty(oItem, GetFirstItemProperty(oItem));
         iAddedRestrictiveChance = CI_IP_RODWAND_EXTRA_CHANCE_RESTRICTIVE;
      break;
      case BASE_ITEM_MAGICROD:
         iStopAfterFirst = TRUE;
         RemoveItemProperty(oItem, GetFirstItemProperty(oItem));
         iAddedRestrictiveChance = CI_IP_RODWAND_EXTRA_CHANCE_RESTRICTIVE;
      break;
      case BASE_ITEM_BOOK:
         SetPlotFlag(oItem, TRUE); // Books can have more than one property and should not be destroyed when using up one
      break;
      case BASE_ITEM_LARGEBOX: iStopAfterFirst = TRUE; break;
      case BASE_ITEM_HEALERSKIT: iStopAfterFirst = TRUE; break;
      case BASE_ITEM_THIEVESTOOLS: iStopAfterFirst = TRUE; break;
   }

   struct STRUCT_IP_PropertyDetails strIP;

   // Save the determined ActualLevel for later use
   int iSavedLevel = iActualLevel;

   // Get positive properties
   int iPropCount = 0; // no properties atm
   int iTries = 0;
   int iMaxProps = CI_IP_MAX_POSITIVE;
   if (iMaxProps < 1)
      iMaxProps = 1;
   if (iMaxProps > CI_IP_MAX_POSITIVE)
      iMaxProps = CI_IP_MAX_POSITIVE;

   int iPositivePropsWithinRareDeviation = 0;
   int iPositivePropsWithinEpicDeviation = 0;
   int iPositiveProps = 0;
   int iNegativeProps = 0;
   int iRestrictiveProps = 0;

   int iAnotherProp;
   while (
          (
           (iTries < iMaxProps) &&
           (
            (iPropCount == 0) ||
            (iAnotherProp <= CI_IP_ADDITIONAL_POSITIVE_PROPERTY_CHANCE_BASE - (iPropCount * CI_IP_ADDITIONAL_POSITIVE_PROPERTY_CHANCE_MODIFIER)) && (iPropCount < iMaxProps)
           )
          ) ||
          (
           (iPropCount < iNumberOfProperties) &&
           (iTries < iNumberOfProperties * 2)
          )
         )
   {
      iTries++;
      strIP = ip_GetProperty(strItem.MainCategory, strItem.SubCategory, strItem.BaseItem, iActualLevel, CI_IP_TYPE_POSITIVE, iIncludeMonsterOnly);
      //SendMessageToAllDMs("Selected property for: " + GetName(oItem) + "\nLevel: " + IntToString(iActualLevel) + " = " + IntToString(GetItemPropertyType(strIP.IP)));
      if (strIP.PropID == CI_IP_Invalid)
      {
         //SendMessageToAllDMs("Error getting positive property for: " + GetName(oItem) + "\nLevel: " + IntToString(iActualLevel));
         WriteTimestampedLogEntry("Error getting positive property for: " + GetName(oItem) + "\nLevel: " + IntToString(iActualLevel));
         continue;
      }

      // if the chosen property is already on the item, try again
      if (!iStopAfterFirst && // we don't need this check if we only apply one property
          (strItem.BaseItem != BASE_ITEM_BOOK && strIP.PropID != CI_IP_CastSpell) &&        // Books can have more spells to cast
          (strItem.BaseItem != BASE_ITEM_MAGICSTAFF && strIP.PropID != CI_IP_CastSpell) &&  // Staves can have more spells to cast
          GetItemHasItemProperty(oItem, GetItemPropertyType(strIP.IP)))
      {
         //SendMessageToAllDMs("Chosen property already exists... Trying again");
         continue;
      }
      IPSafeAddItemProperty(oItem, strIP.IP, 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
      iPropCount++;
      iPositiveProps++;
      if (CI_IP_EPIC_ALLOWED_POSITIVE_DEVIATION == -1 ||
          iActualLevel >= (iMaxMagicLevel - CI_IP_EPIC_ALLOWED_POSITIVE_DEVIATION))
         iPositivePropsWithinEpicDeviation++;
      if (CI_IP_RARE_ALLOWED_POSITIVE_DEVIATION == -1 ||
          iActualLevel >= (iMaxMagicLevel - CI_IP_RARE_ALLOWED_POSITIVE_DEVIATION))
         iPositivePropsWithinRareDeviation++;

      // Store this property on the item as variables
      SetLocalInt(oItem, "Property" + IntToString(iPropCount) + "ID", strIP.PropID);
      SetLocalInt(oItem, "Property" + IntToString(iPropCount) + "Var1", strIP.Var1);
      SetLocalInt(oItem, "Property" + IntToString(iPropCount) + "Var2", strIP.Var2);
      SetLocalInt(oItem, "Property" + IntToString(iPropCount) + "Var3", strIP.Var3);
      SetLocalInt(oItem, "Property" + IntToString(iPropCount) + "Lvl", iActualLevel);

      // If this is a one-property item, stop looping
      if (iStopAfterFirst)
         break;

      iAnotherProp = d100();
      iActualLevel -= Random(CI_IP_ADDITIONAL_POSITIVE_PROPERTY_LEVEL_MODIFIER_RANDOM) + CI_IP_ADDITIONAL_POSITIVE_PROPERTY_LEVEL_MODIFIER_BASE;
      if (iActualLevel < 1)
         iActualLevel = 1;
   }

   if (strItem.MainCategory == CI_EGS_ITEM_MAIN_MONSTERRING)
      iStopAfterFirst = TRUE;

   // Get back the saved actual level
   iActualLevel = iSavedLevel;
   // Get Negative properties
   iMaxProps = iPropCount + CI_IP_MAX_NEGATIVE;
   iAnotherProp = Random(100);

   if (!iStopAfterFirst &&
       !iIncludeMonsterOnly)       // if the gear is set to be undroppable monster equipment, skip negative properties
   while (
          (iTries < iMaxProps) &&
          (iAnotherProp <= iPositiveProps * (CI_IP_ADDITIONAL_NEGATIVE_PROPERTY_CHANCE_BASE - (iPropCount - iPositiveProps) * CI_IP_ADDITIONAL_NEGATIVE_PROPERTY_CHANCE_REDUCTION)) &&
          (iPropCount < iMaxProps)
         )
   {
      iTries++;
      strIP = ip_GetProperty(strItem.MainCategory, strItem.SubCategory, strItem.BaseItem, iActualLevel, CI_IP_TYPE_NEGATIVE, iIncludeMonsterOnly);
      if (strIP.PropID == CI_IP_Invalid)
      {
         //SendMessageToAllDMs("Error getting negative property for: " + GetName(oItem) + "\nLevel: " + IntToString(iActualLevel));
         continue;
      }
      // if the chosen property is already on the item, try again
      if (GetItemHasItemProperty(oItem, GetItemPropertyType(strIP.IP)))
      {
         //SendMessageToAllDMs("Chosen property already exists... Trying again");
         continue;
      }
      IPSafeAddItemProperty(oItem, strIP.IP, 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
      iPropCount++;
      iNegativeProps++;

      // Store this property on the item as variables
      SetLocalInt(oItem, "Property" + IntToString(iPropCount) + "ID", strIP.PropID);
      SetLocalInt(oItem, "Property" + IntToString(iPropCount) + "Var1", strIP.Var1);
      SetLocalInt(oItem, "Property" + IntToString(iPropCount) + "Var2", strIP.Var2);
      SetLocalInt(oItem, "Property" + IntToString(iPropCount) + "Var3", strIP.Var3);
      SetLocalInt(oItem, "Property" + IntToString(iPropCount) + "Lvl", iActualLevel);

      iAnotherProp = Random(100);
      iActualLevel -= Random(CI_IP_ADDITIONAL_NEGATIVE_PROPERTY_LEVEL_MODIFIER_RANDOM) + CI_IP_ADDITIONAL_NEGATIVE_PROPERTY_LEVEL_MODIFIER_BASE;
      if (iActualLevel < 1)
         iActualLevel = 1;
   }

   // Get back the saved actual level
   iActualLevel = iSavedLevel;
   // Get Restrictive properties
   iMaxProps = iPropCount + CI_IP_MAX_RESTRICTIVE;
   iAnotherProp = Random(100) - iAddedRestrictiveChance;

   if (!iStopAfterFirst &&
       !iIncludeMonsterOnly)       // if the gear is set to be undroppable monster equipment, skip restrictive properties
   while (
          (iTries < iMaxProps) &&
          (iAnotherProp <= iPositiveProps * CI_IP_CHANCE_RESTRICTIVE ) && (iPropCount < iMaxProps)
         )
   {
      iTries++;
      strIP = ip_GetProperty(strItem.MainCategory, strItem.SubCategory, strItem.BaseItem, iActualLevel, CI_IP_TYPE_RESTRICTIVE, iIncludeMonsterOnly);
      if (strIP.PropID == CI_IP_Invalid)
      {
         //SendMessageToAllDMs("Error getting restrictive property for: " + GetName(oItem) + "\nLevel: " + IntToString(iActualLevel));
         continue;
      }
      // if the chosen property is already on the item, try again
      if (GetItemHasItemProperty(oItem, GetItemPropertyType(strIP.IP)))
      {
         //SendMessageToAllDMs("Chosen property already exists... Trying again");
         continue;
      }
      IPSafeAddItemProperty(oItem, strIP.IP, 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
      iPropCount++;
      iRestrictiveProps++;

      // Store this property on the item as variables
      SetLocalInt(oItem, "Property" + IntToString(iPropCount) + "ID", strIP.PropID);
      SetLocalInt(oItem, "Property" + IntToString(iPropCount) + "Var1", strIP.Var1);
      SetLocalInt(oItem, "Property" + IntToString(iPropCount) + "Var2", strIP.Var2);
      SetLocalInt(oItem, "Property" + IntToString(iPropCount) + "Var3", strIP.Var3);
      SetLocalInt(oItem, "Property" + IntToString(iPropCount) + "Lvl", iActualLevel);

      iAnotherProp = Random(100);
      iActualLevel -= Random(CI_IP_ADDITIONAL_RESTRICTIVE_PROPERTY_LEVEL_MODIFIER_RANDOM) + CI_IP_ADDITIONAL_RESTRICTIVE_PROPERTY_LEVEL_MODIFIER_BASE;
      if (iActualLevel < 1)
         iActualLevel = 1;
   }

   // EVALUATE WHAT WE ADDED
   if (iNameItem)
      ip_EvaluateItem(oItem, iPositiveProps, iNegativeProps, iRestrictiveProps, iPositivePropsWithinRareDeviation, iPositivePropsWithinEpicDeviation);

   /*
   // DEBUG Stuff
   itemproperty ipProperty = GetFirstItemProperty(oItem);
   int iType;
   int iSubType;
   int iParam1;
   int iParam1Value;
   string sItemInfo = "Info for " + GetName(oItem) + " (Level " + IntToString(iActualLevel) + "):\n";
   while (GetIsItemPropertyValid(ipProperty))
   {
      iType = GetItemPropertyType(ipProperty);
      iSubType = GetItemPropertySubType(ipProperty);
      iParam1 = GetItemPropertyParam1(ipProperty);
      iParam1Value = GetItemPropertyParam1Value(ipProperty);
      sItemInfo += "Type: " + IntToString(iType) + " (" + Get2DAString("itempropdef", "Label", iType) + ")\nSubType: " + IntToString(iSubType) + " (" + Get2DAString(Get2DAString("itempropdef", "SubTypeResRef", iType), "Label", iSubType) + ")\nParam1: " + IntToString(iParam1) + " | Value: " + IntToString(iParam1Value) + ".\n";
      ipProperty = GetNextItemProperty(oItem);
   }
   SendMessageToAllDMs(sItemInfo);
   */

   // Save Version and original iLevel on Item
   SetLocalInt(oItem, CS_IP_VAR_CREATION_VERSION, CI_IP_VERSION);
   SetLocalInt(oItem, CS_IP_VAR_CREATION_LEVEL, iSavedLevel);

   // Set Identified Flag
   SetIdentified(oItem, iIdentified);
}

struct STRUCT_IP_PropertyDetails ip_GetSpecificProperty(int iBaseItem, int iProperty, int iVar1 = 0, int iVar2 = 0, int iVar3 = 0)
{
   itemproperty ipResult;
   struct STRUCT_IP_PropertyDetails strResult;
   int iRandomizer;
   int iHelper;
   int iHelperI;
   switch (iProperty)
   {
      // Ability Bonus
      // For Ability Bonus, the Ability is randomized, the strength of the boost
      // is set by iVar1
      case CI_IP_AbilityBonus:
         iHelper = ip_GetRandomAbility(iBaseItem, FALSE);
         ipResult = ItemPropertyAbilityBonus(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      // Armor Class Bonus
      // Here, the AC Bonus is set by iVar1
      case CI_IP_ACBonus:
         ipResult = ItemPropertyACBonus(iVar1);
         strResult.Var1 = iVar1;
         break;

      // Armor Bonus vs. Specific Alignment
      // The alignment group is randomized, the strenght is set by iVar1
      // Value "All Alignments" Excluded in this one
      case CI_IP_ACBonusVsAlign:
         iHelper = ip_GetRandomAlignmentGroup(FALSE);
         ipResult = ItemPropertyACBonusVsAlign(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      // Armor Bonus vs. Specific Alignment
      // The alignment group is randomized, the strenght is set by iVar1
      // Value "All Alignments" Included in this one
      /*case CI_IP_ACBonusVsAlignAllIncluded:
         iHelper = ip_GetRandomAlignmentGroup(TRUE);
         ipResult = ItemPropertyACBonusVsAlign(iHelper, iVar1);
         break;*/

      // Armor Bonus vs. Damage Type
      // Damage Type is randomized, strength is set by iVar1
      case CI_IP_ACBonusVsDmgType:
         iHelper = ip_GetRandomDamageType(0);
         ipResult = ItemPropertyACBonusVsDmgType(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      // Armor Bonus vs. Race
      // Race is randomized, strength is set by iVar1
      case CI_IP_ACBonusVsRace:
         iHelper = ip_GetRandomRacialType();
         ipResult = ItemPropertyACBonusVsRace(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      // Armor Bonus vs. Specific Alignment
      // Alignment is randomized, strength set by iVar1
      case CI_IP_ACBonusVsSAlign:
         iHelper = ip_GetRandomSpecificAlignment();
         ipResult = ItemPropertyACBonusVsSAlign(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      // Arcane Spell Failure
      // iVar1 must hold IP_CONST_ARCANE_SPELL_FAILURE_*
      case CI_IP_ArcaneSpellFailure:
         ipResult = ItemPropertyArcaneSpellFailure(iVar1);
         strResult.Var1 = iVar1;
         break;

      // Attack Bonus
      // iVar1 holds the strength
      case CI_IP_AttackBonus:
         ipResult = ItemPropertyAttackBonus(iVar1);
         strResult.Var1 = iVar1;
         break;

      case CI_IP_AttackBonusVsAlign:
         iHelper = ip_GetRandomAlignmentGroup(FALSE);
         ipResult = ItemPropertyAttackBonusVsAlign(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      /*case CI_IP_AttackBonusVsAlignAllIncluded:
         iHelper = ip_GetRandomAlignmentGroup(TRUE);
         ipResult = ItemPropertyAttackBonusVsAlign(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;*/

      case CI_IP_AttackBonusVsRace:
         iHelper = ip_GetRandomRacialType();
         ipResult = ItemPropertyAttackBonusVsRace(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      case CI_IP_AttackBonusVsSAlign:
         iHelper = ip_GetRandomSpecificAlignment();
         ipResult = ItemPropertyAttackBonusVsSAlign(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      case CI_IP_AttackPenalty:
         ipResult = ItemPropertyAttackPenalty(iVar1);
         strResult.Var1 = iVar1;
         break;

      // Bonus Feat
      // Entirely Random Feat is selected
      case CI_IP_BonusFeat:
         iHelper = ip_GetRandomBonusFeat();
         ipResult = ItemPropertyBonusFeat(iHelper);
         strResult.Var1 = iHelper;
         break;

      // Bonus Spell Level
      // The Casting Class is randomized, iVar1 holds the spell level
      case CI_IP_BonusLevelSpell:
         iHelper = ip_GetRandomClass(TRUE);
         ipResult = ItemPropertyBonusLevelSpell(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      // Bonus Saving Throw
      // Save-Type is random, iVar1 holds the strength of the bonus
      case CI_IP_BonusSavingThrow:
         iHelper = ip_GetRandomSaveBaseType();
         ipResult = ItemPropertyBonusSavingThrow(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      // Bonus Saving Throw vs. Specific Effect or Damage Type
      // Effect/Damage Type is randomized, iVar1 holds the amount of bonus
      // Universal Save excluded
      case CI_IP_BonusSavingThrowVsX:
         iHelper = ip_GetRandomSavingThrowVS(FALSE);
         ipResult = ItemPropertyBonusSavingThrowVsX(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      // Bonus Saving Throw vs. Specific Effect or Damage Type
      // Effect/Damage Type is randomized, iVar1 holds the amount of bonus
      // Universal Save included
      case CI_IP_BonusSavingThrowVsXUniversalIncluded:
         iHelper = ip_GetRandomSavingThrowVS(TRUE);
         ipResult = ItemPropertyBonusSavingThrowVsX(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      // Spell Resistance
      // iVar1 holds IP_CONST_SPELLRESISTANCEBONUS_*
      case CI_IP_BonusSpellResistance:
         ipResult = ItemPropertyBonusSpellResistance(iVar1);
         strResult.Var1 = iVar1;
         break;

      // Cast Spell (all items except wands/potions
      // iVar1 holds the Caster Level (1-20) of the spell
      // iVar 2 holds IP_CONST_CASTSPELL_NUMUSES_*
      case CI_IP_CastSpell:
         iHelper = ip_GetRandomSpell(iVar1);
         ipResult = ItemPropertyCastSpell(iHelper, iVar2);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar2;
         break;

      // Cast Spell (Potion)
      // iVar1 holds the Caster Level (0-20) of the spell
      case CI_IP_CastSpellPotion:
         iHelper = ip_GetRandomPotionSpell(iVar1);
         ipResult = ItemPropertyCastSpell(iHelper, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE);
         strResult.Var1 = iHelper;
      break;

      // Cast Spell (Wand)
      // iVar1 holds the Caster Level (0-20) of the spell
      // iVar 2 holds IP_CONST_CASTSPELL_NUMUSES_*
      case CI_IP_CastSpellWand:
         iHelper = ip_GetRandomWandSpell(iVar1);
         ipResult = ItemPropertyCastSpell(iHelper, iVar2);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar2;
      break;

      // Container Reduced Weight
      // iVar1 must hold IP_CONST_CONTAINERWEIGHTRED_*
      case CI_IP_ContainerReducedWeight:
         ipResult = ItemPropertyContainerReducedWeight(iVar1);
         strResult.Var1 = iVar1;
         break;

      // Damage Bonus
      // DamageType is randomized, iVar1 has to be IP_CONST_DAMAGEBONUS_*
      case CI_IP_DamageBonus:
         iHelper = ip_GetRandomDamageType(1);
         ipResult = ItemPropertyDamageBonus(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      // Damage Bonus vs. Alignment Group
      // Damage Type and Alignment Group are randomized,
      // iVar1 holds IP_CONST_DAMAGEBONUS_*
      case CI_IP_DamageBonusVsAlign:
         iHelper = ip_GetRandomAlignmentGroup(FALSE);
         iHelperI = ip_GetRandomDamageType(1);
         ipResult = ItemPropertyDamageBonusVsAlign(iHelper, iHelperI, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iHelperI;
         strResult.Var3 = iVar1;
         break;

      // Damage Bonus vs. Alignment Group
      // Damage Type and Alignment Group are randomized,
      // iVar1 holds IP_CONST_DAMAGEBONUS_*
      /*case CI_IP_DamageBonusVsAlignAllIncluded:
         iHelper = ip_GetRandomAlignmentGroup(TRUE);
         iHelperI = ip_GetRandomDamageType(TRUE);
         ipResult = ItemPropertyDamageBonusVsAlign(iHelper, iHelperI, iVar1);
         break;*/

      // Damage Bonus vs. Race
      // Damage Type and Race are randomized, iVar1 holds IP_CONST_DAMAGEBONUS_*
      case CI_IP_DamageBonusVsRace:
         iHelper = ip_GetRandomRacialType();
         iHelperI = ip_GetRandomDamageType(1);
         ipResult = ItemPropertyDamageBonusVsRace(iHelper, iHelperI, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iHelperI;
         strResult.Var3 = iVar1;
         break;

      // Damage Bonus vs. Specific Alignment
      // Damage Type and Alignment are randomized,
      // iVar1 holds IP_CONST_DAMAGEBONUS_*
      case CI_IP_DamageBonusVsSAlign:
         iHelper = ip_GetRandomSpecificAlignment();
         iHelperI = ip_GetRandomDamageType(1);
         ipResult = ItemPropertyDamageBonusVsSAlign(iHelper, iHelperI, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iHelperI;
         strResult.Var3 = iVar1;
         break;

      // Damage Immunity
      // Damage Type is randomized, iVar1 holds IP_CONST_DAMAGEIMMUNITY_*
      case CI_IP_DamageImmunity:
         iHelper = ip_GetRandomDamageType(1);
         ipResult = ItemPropertyDamageImmunity(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      // Damage Penalty
      // iVar1 = 1 to 5
      case CI_IP_DamagePenalty:
         ipResult = ItemPropertyDamagePenalty(iVar1);
         strResult.Var1 = iVar1;
         break;

      // Damage Reduction
      // iVar1 holds IP_CONST_DAMAGEREDUCTION_*, iVar2 holds IP_CONST_DAMAGESOAK_*
      case CI_IP_DamageReduction:
         ipResult = ItemPropertyDamageReduction(iVar1, iVar2);
         strResult.Var1 = iVar1;
         strResult.Var2 = iVar2;
         break;

      // Damage Resistance
      // Damage Type is randomized, iVar1 holds IP_CONST_DAMAGERESIST_*
      case CI_IP_DamageResistance:
         iHelper = ip_GetRandomDamageType(2);
         ipResult = ItemPropertyDamageResistance(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      // Damage Vulnerability
      // Damage Type is randomized, iVar1 holds IP_CONST_DAMAGEVULNERABILITY_*
      case CI_IP_DamageVulnerability:
         iHelper = ip_GetRandomDamageType(2);
         ipResult = ItemPropertyDamageVulnerability(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      case CI_IP_Darkvision:
         ipResult = ItemPropertyDarkvision();
         break;

      // Decrease Ability
      // Ability is randomized, iVar1 is 1-10
      case CI_IP_DecreaseAbility:
         iHelper = ip_GetRandomAbility(iBaseItem, TRUE);
         ipResult = ItemPropertyDecreaseAbility(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      // Decrease Armor Class
      // Modifier Type is random, iVar1 holds the strength of the modification
      case CI_IP_DecreaseAC:
         iHelper = ip_GetRandomACModifierType();
         ipResult = ItemPropertyDecreaseAC(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      // Decrease Skill
      // Skill is randomized, iVar1 holds the strength of the decrease (1-10)
      // The ALLSKILLS skill is included in this one
      case CI_IP_DecreaseSkill:
         iHelper = ip_GetRandomSkill(TRUE);
         ipResult = ItemPropertyDecreaseSkill(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      /* Deactivated
      // Decrease Skill
      // Skill is randomized, iVar1 holds the strength of the decrease (1-10)
      // The ALLSKILLS skill is included in this one
      case CI_IP_DecreaseSkillAllSkillsIncluded:
         iHelper = ip_GetRandomSkill(TRUE);
         ipResult = ItemPropertyDecreaseSkill(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;
      */

      // Enhancement Bonus
      // iVar1 is the Bonus (1-20)
      case CI_IP_EnhancementBonus:
         ipResult = ItemPropertyEnhancementBonus(iVar1);
         strResult.Var1 = iVar1;
         break;

      // Enhancement Bonus vs. Alignment Group
      // Alignment Group is randomized, the bonus is iVar1
      // ALL Alignments not included
      case CI_IP_EnhancementBonusVsAlign:
         iHelper = ip_GetRandomAlignmentGroup(FALSE);
         ipResult = ItemPropertyEnhancementBonusVsAlign(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      // Enhancement Bonus vs. Alignment Group
      // Alignment Group is randomized, the bonus is iVar1
      // ALL Alignments included
      /*case CI_IP_EnhancementBonusVsAlignAllIncluded:
         iHelper = ip_GetRandomAlignmentGroup(TRUE);
         ipResult = ItemPropertyEnhancementBonusVsAlign(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;*/

      // Enhancement Bonus vs. Racial Group
      // Racial Group is randomized, the bonus is iVar1
      case CI_IP_EnhancementBonusVsRace:
         iHelper = ip_GetRandomRacialType();
         ipResult = ItemPropertyEnhancementBonusVsRace(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      // Enhancement Bonus vs. Specific Alignment
      // Alignment randomized, iVar1 is the bonus
      case CI_IP_EnhancementBonusVsSAlign:
         iHelper = ip_GetRandomSpecificAlignment();
         ipResult = ItemPropertyEnhancementBonusVsSAlign(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      /* Deactivated
      // Enhancement Penalty
      // iVar1 = 1-5
      case CI_IP_EnhancementPenalty:
         ipResult = ItemPropertyEnhancementPenalty(iVar1);
         strResult.Var1 = iVar1;
         break;
      */

      // Extra Melee Damage Type
      // All randomized here
      case CI_IP_ExtraMeleeDamageType:
         iHelper = ip_GetRandomExtraDamageType();
         ipResult = ItemPropertyExtraMeleeDamageType(iHelper);
         strResult.Var1 = iHelper;
         break;

      // Extra Ranged Damage Type
      // All randomized here
      case CI_IP_ExtraRangeDamageType:
         iHelper = ip_GetRandomExtraDamageType();
         ipResult = ItemPropertyExtraRangeDamageType(iHelper);
         strResult.Var1 = iHelper;
         break;

      /* Non-Existant
      // Free Action
      case CI_IP_FreeAction:
         ipResult = ItemPropertyFreeAction();
         break;
      */

      // Haste
      case CI_IP_Haste:
         ipResult = ItemPropertyHaste();
         break;

      // Healers Kit
      // iVar 1 holds the strength (1-12)
      case CI_IP_HealersKit:
         ipResult = ItemPropertyHealersKit(iVar1);
         strResult.Var1 = iVar1;
         break;

      // Holy Avenger
      case CI_IP_HolyAvenger:
         ipResult = ItemPropertyHolyAvenger();
         break;

      // Miscellaneous Immunity
      // iVar1 holds IP_CONST_IMMUNITYMISC_*
      case CI_IP_ImmunityMisc:
         ipResult = ItemPropertyImmunityMisc(iVar1);
         strResult.Var1 = iVar1;
         break;

      // Immunity to Spell Level
      // iVar1 holds the spell level
      case CI_IP_ImmunityToSpellLevel:
         ipResult = ItemPropertyImmunityToSpellLevel(iVar1);
         strResult.Var1 = iVar1;
         break;

      // Improved Evasion
      case CI_IP_ImprovedEvasion:
         ipResult = ItemPropertyImprovedEvasion();
         break;

      // Keen
      case CI_IP_Keen:
         ipResult = ItemPropertyKeen();
         break;

      // Light
      // iVar1 holds the intensity -> IP_CONST_LIGHTBRIGHTNESS_*
      case CI_IP_Light:
         iHelper = ip_GetRandomLightColor();
         ipResult = ItemPropertyLight(iVar1, iHelper);
         strResult.Var1 = iVar1;
         strResult.Var2 = iHelper;
         break;

      // Limit use By Align
      case CI_IP_LimitUseByAlign:
         iHelper = ip_GetRandomAlignmentGroup(FALSE);
         ipResult = ItemPropertyLimitUseByAlign(iHelper);
         strResult.Var1 = iHelper;
         break;

      // Limit Use By Class
      case CI_IP_LimitUseByClass:
         iHelper = ip_GetRandomClass(FALSE);
         ipResult = ItemPropertyLimitUseByClass(iHelper);
         strResult.Var1 = iHelper;
         break;

      // Limit Use By Race
      case CI_IP_LimitUseByRace:
         iHelper = ip_GetRandomRacialType(TRUE);
         ipResult = ItemPropertyLimitUseByRace(iHelper);
         strResult.Var1 = iHelper;
         break;

      // Limit Use by Specific Alignment
      case CI_IP_LimitUseBySAlign:
         iHelper = ip_GetRandomSpecificAlignment();
         ipResult = ItemPropertyLimitUseBySAlign(iHelper);
         strResult.Var1 = iHelper;
         break;

      // Massive Damage
      // iVar1 holds IP_CONST_DAMAGEBONUS_*
      case CI_IP_MassiveCritical:
         ipResult = ItemPropertyMassiveCritical(iVar1);
         strResult.Var1 = iVar1;
         break;

      // Mighty
      // iVar1 = 1-20
      case CI_IP_MaxRangeStrengthMod:
         ipResult = ItemPropertyMaxRangeStrengthMod(iVar1);
         strResult.Var1 = iVar1;
         break;

      // Monster Damage only works on Monster Items
      // Therefor, this property is not included
      case CI_IP_MonsterDamage:
         //ipResult = ;
         break;

      // No Damage
      case CI_IP_NoDamage:
         ipResult = ItemPropertyNoDamage();
         break;

      // On Hit: Cast Spell
      // Not done yet
      case CI_IP_OnHitCastSpell:
         //ipResult = ;
         break;

      // On Hit Properties
      // iVar1 holds IP_CONST_ONHIT_*
      // iVar2 holds IP_CONST_ONHIT_SAVEDC_*
      // iVar3 holds the Special Variable Duration (all other special variables
      // are randomized)
      case CI_IP_OnHitProps:
         switch (iVar1)
         {
            case IP_CONST_ONHIT_ABILITYDRAIN: iVar3 = ip_GetRandomAbility(iBaseItem, TRUE); break;
            case IP_CONST_ONHIT_DISEASE: iVar3 = ip_GetRandomDisease(); break;
            case IP_CONST_ONHIT_ITEMPOISON: iVar3 = ip_GetRandomItemPoison(); break;
            case IP_CONST_ONHIT_SLAYRACE: iVar3 = ip_GetRandomRacialType(); break;
            case IP_CONST_ONHIT_SLAYALIGNMENTGROUP: iVar3 = ip_GetRandomAlignmentGroup(); break;
            case IP_CONST_ONHIT_SLAYALIGNMENT: iVar3 = ip_GetRandomSpecificAlignment(); break;
         }
         ipResult = ItemPropertyOnHitProps(iVar1, iVar2, iVar3);
         strResult.Var1 = iVar1;
         strResult.Var2 = iVar2;
         strResult.Var3 = iVar3;
         break;

      // Unused
      case CI_IP_OnMonsterHitProperties:
         //ipResult = ;
         break;

      // Reduced Saving Throw
      // SaveBase Type is randomized, iVar1 = 1-20
      case CI_IP_ReducedSavingThrow:
         iHelper = ip_GetRandomSaveBaseType();
         ipResult = ItemPropertyReducedSavingThrow(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      // Reduced Saving Throw vs. Specific Effect/Damage
      // Effect/Damage is randomized, iVar1 holds the value
      // Universal is included
      case CI_IP_ReducedSavingThrowVsX:
         iHelper = ip_GetRandomSavingThrowVS(TRUE);
         ipResult = ItemPropertyReducedSavingThrowVsX(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      /* Deactivated
      // Reduced Saving Throw vs. Specific Effect/Damage
      // Effect/Damage is randomized, iVar1 holds the value
      // Universal included
      case CI_IP_ReducedSavingThrowVsXUniversalIncluded:
         iHelper = ip_GetRandomSavingThrowVS(TRUE);
         ipResult = ItemPropertyReducedSavingThrowVsX(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;
      */

      // Regeneration
      // iVar1 holds the amount of regeneration (1-20)
      case CI_IP_Regeneration:
         ipResult = ItemPropertyRegeneration(iVar1);
         strResult.Var1 = iVar1;
         break;

      // Skill Bonus
      // Skill is randomized, iVar1 holds the boost (1-50)
      // "All Skills" not included
      case CI_IP_SkillBonus:
         iHelper = ip_GetRandomSkill(FALSE);
         ipResult = ItemPropertySkillBonus(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      /* Deactivated
      // Skill Bonus
      // Skill is randomized, iVar1 holds the boost (1-50)
      // "All Skills" included
      case CI_IP_SkillBonusAllIncluded:
         iHelper = ip_GetRandomSkill(TRUE);
         ipResult = ItemPropertySkillBonus(iHelper, iVar1);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;
      */

      // Special Walk (Zombie)
      case CI_IP_SpecialWalk:
         ipResult = ItemPropertySpecialWalk();
         break;

      // Immunity vs. SpellSchool
      case CI_IP_SpellImmunitySchool:
         iHelper = ip_GetRandomSpellSchool();
         ipResult = ItemPropertySpellImmunitySchool(iHelper);
         strResult.Var1 = iHelper;
         break;

      // unused
      case CI_IP_SpellImmunitySpecific:
         //ipResult = ;
         break;

      // Thieves Tools
      // iVar1 holds the bonus (1-12)
      case CI_IP_ThievesTools:
         ipResult = ItemPropertyThievesTools(iVar1);
         strResult.Var1 = iVar1;
         break;

      // Trap
      // Trap Type is randomized, iVar1 holds IP_CONST_TRAPSTRENGTH_*
      case CI_IP_Trap:
         iHelper = ip_GetRandomTrapType();
         ipResult = ItemPropertyTrap(iVar1, iHelper);
         strResult.Var1 = iHelper;
         strResult.Var2 = iVar1;
         break;

      // True Seeing
      case CI_IP_TrueSeeing:
         ipResult = ItemPropertyTrueSeeing();
         break;

      // Turn Resistance
      // iVar1 holds the strength of the resistance (1-50)
      case CI_IP_TurnResistance:
         ipResult = ItemPropertyTurnResistance(iVar1);
         strResult.Var1 = iVar1;
         break;

      // Unlimited Ammo
      // iVar1 holds IP_CONST_UNLIMITEDAMMO_*
      case CI_IP_UnlimitedAmmo:
         ipResult = ItemPropertyUnlimitedAmmo(iVar1);
         strResult.Var1 = iVar1;
         break;

      // Vampiric Regeneration
      // iVar1 holds the amount (1-20)
      case CI_IP_VampiricRegeneration:
         ipResult = ItemPropertyVampiricRegeneration(iVar1);
         strResult.Var1 = iVar1;
         break;

      // Adds a random Visual Effect to melee weapons
      case CI_IP_VisualEffect:
         iHelper = ip_GetRandomItemVisualEffect();
         ipResult = ItemPropertyVisualEffect(iHelper);
         strResult.Var1 = iHelper;
         break;

      // Weight Increase
      // iVar1 holds IP_CONST_WEIGHTINCREASE_*
      case CI_IP_WeightIncrease:
         ipResult = ItemPropertyWeightIncrease(iVar1);
         strResult.Var1 = iVar1;
         break;

      // Weight Reduction
      // iVar1 holds IP_CONST_REDUCEDWEIGHT_*
      case CI_IP_WeightReduction:
         ipResult = ItemPropertyWeightReduction(iVar1);
         strResult.Var1 = iVar1;
         break;
   }

   strResult.IP = ipResult;
   return (strResult);
}
