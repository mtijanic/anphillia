///////////////////////////////////////////////////////////////////////////////
// ip_ini
// written by: eyesolated
// written at: April 2, 2015
//
// Notes: IP Initialization w/o NWNX

///////////
// Includes
//
#include "eas_inc"
#include "color_inc"
#include "egs_inc"
#include "ip_inc"
#include "eas_inc"

const int ITERATION = 20;
void main()
{
    object oModule = OBJECT_SELF;
    object oStorePreload = GetLocalObject(oModule, CS_IP_DB_PRELOAD_STORE_OBJ);

    int iCurrentPropertyID = GetLocalInt(oModule, CS_IP_ARRAY_INIT);
    int iTotalProperties = eas_Array_GetSize(oStorePreload, CS_IP_DB_PRELOAD_ARRAY);

    if (iCurrentPropertyID >= iTotalProperties)
    {
        object oLog = GetObjectByTag("LOG");
        SetDescription(oLog, GetDescription(oLog) + "\nIP INI B - Item properties store preload finished (" + IntToString(iTotalProperties) + ").");
        WriteTimestampedLogEntry("IP INI B - Item properties store preload finished");
        return;
    }

    string sID;
    int iProperty;
    int iType;
    string sCategoriesMain;
    string sCategoriesSub;
    string sBaseItems;
    int iCount;
    int iVarOne;
    int iVarTwo;
    int iVarThree;
    int iMonsterOnly;

    int n = iCurrentPropertyID;
    while (n < iTotalProperties &&
           n < iCurrentPropertyID + ITERATION)
    {
        sID = IntToString(n);
        iProperty = GetLocalInt(oStorePreload, CS_IP_ID + sID);
        iType = GetLocalInt(oStorePreload, CS_IP_TYPE + sID);
        sCategoriesMain = GetLocalString(oStorePreload, CS_IP_CATEGORIES_MAIN + sID);
        sCategoriesSub = GetLocalString(oStorePreload, CS_IP_CATEGORIES_SUB + sID);
        sBaseItems = GetLocalString(oStorePreload, CS_IP_BASEITEMS + sID);
        iCount = GetLocalInt(oStorePreload, CS_IP_LEVEL + sID);
        iVarOne = GetLocalInt(oStorePreload, CS_IP_VARONE + sID);
        iVarTwo = GetLocalInt(oStorePreload, CS_IP_VARTWO + sID);
        iVarThree = GetLocalInt(oStorePreload, CS_IP_VARTHREE + sID);
        iMonsterOnly = GetLocalInt(oStorePreload, CS_IP_MONSTERONLY + sID);
        ip_AddProperty(iProperty, iType, sCategoriesMain, sCategoriesSub, sBaseItems, iCount, iVarOne, iVarTwo, iVarThree, iMonsterOnly);

        n++;
    }

    SetLocalInt(oModule, CS_IP_ARRAY_INIT, n);
    DelayCommand(0.1f, ExecuteScript("ip_ini_b", OBJECT_SELF));
}
