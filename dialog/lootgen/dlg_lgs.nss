///////////////////////////////////////////////////////////////////////////////
// dlg_lgs
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: the conditional/action script for the example dialog


///////////
// Includes
//
#include "eas_inc"
#include "color_inc"
#include "dlg_inc"
#include "egs_inc"
#include "ip_inc"

///////////////////////
// Function Declaration
//
void SetMagicLevel(object oPC, int iLevel);
int GetMagicLevel(object oPC);
void DeleteMagicLevel(object oPC);

void SetDesiredPropertyCount(object oPC, int iCount);
int GetDesiredPropertyCount(object oPC);
void DeleteDesiredPropertyCount(object oPC);

void SetMainCategory(object oPC, int iMainCategory);
int GetMainCategory(object oPC);
void DeleteMainCategory(object oPC);

void SetSubCategory(object oPC, int iSubCategory);
int GetSubCategory(object oPC);
void DeleteSubCategory(object oPC);

void SetBaseItem(object oPC, int iBaseItem);
int GetBaseItem(object oPC);
void DeleteBaseItem(object oPC);

void SetBlueprint(object oPC, string sBlueprint);
string GetBlueprint(object oPC);
void DeleteBlueprint(object oPC);
////////////////
// Function Code
//

void SetMagicLevel(object oPC, int iLevel)
{
    SetLocalInt(oPC, "LGS_DLG_ML", iLevel);
}

int GetMagicLevel(object oPC)
{
    return (GetLocalInt(oPC, "LGS_DLG_ML"));
}

void DeleteMagicLevel(object oPC)
{
    DeleteLocalInt(oPC, "LGS_DLG_ML");
}

void SetDesiredPropertyCount(object oPC, int iCount)
{
    SetLocalInt(oPC, "LGS_DLG_DPC", iCount);
}

int GetDesiredPropertyCount(object oPC)
{
    return (GetLocalInt(oPC, "LGS_DLG_DPC"));
}

void DeleteDesiredPropertyCount(object oPC)
{
    DeleteLocalInt(oPC, "LGS_DLG_DPC");
}

void SetMainCategory(object oPC, int iMainCategory)
{
    SetLocalInt(oPC, "LGS_DLG_MC", iMainCategory);
    DeleteSubCategory(oPC);
}

int GetMainCategory(object oPC)
{
    return (GetLocalInt(oPC, "LGS_DLG_MC"));
}

void DeleteMainCategory(object oPC)
{
    DeleteLocalInt(oPC, "LGS_DLG_MC");
    DeleteSubCategory(oPC);
}

void SetSubCategory(object oPC, int iSubCategory)
{
    SetLocalInt(oPC, "LGS_DLG_SC", iSubCategory);
    DeleteBaseItem(oPC);
    DeleteBlueprint(oPC);
}

int GetSubCategory(object oPC)
{
    return (GetLocalInt(oPC, "LGS_DLG_SC"));
}

void DeleteSubCategory(object oPC)
{
    DeleteLocalInt(oPC, "LGS_DLG_SC");
    DeleteBaseItem(oPC);
    DeleteBlueprint(oPC);
}

void SetBaseItem(object oPC, int iBaseItem)
{
    SetLocalInt(oPC, "LGS_DLG_BI", iBaseItem);
}

int GetBaseItem(object oPC)
{
    return (GetLocalInt(oPC, "LGS_DLG_BI"));
}

void DeleteBaseItem(object oPC)
{
    DeleteLocalInt(oPC, "LGS_DLG_BI");
}

void SetBlueprint(object oPC, string sBlueprint)
{
    SetLocalString(oPC, "LGS_DLG_BP", sBlueprint);
}

string GetBlueprint(object oPC)
{
    return (GetLocalString(oPC, "LGS_DLG_BP"));
}

void DeleteBlueprint(object oPC)
{
    DeleteLocalString(oPC, "LGS_DLG_BP");
}

void CreateItem(object oPC, int nForce)
{
    int iDesiredPropertyCount = GetDesiredPropertyCount(oPC);
    if (iDesiredPropertyCount == 0)
        iDesiredPropertyCount = -1;
    int iMainCategory = GetMainCategory(oPC);
    int iSubCategory = GetSubCategory(oPC);
    int iBaseItem = GetBaseItem(oPC);
    string sBlueprint = GetBlueprint(oPC);
    if (iMainCategory == 0)
        iMainCategory = -1;
    if (iSubCategory == 0)
        iSubCategory = -1;
    if (iBaseItem == 0)
        iBaseItem = -1;

    object oItem;
    if (sBlueprint != "")
        oItem = CreateItemOnObject(sBlueprint, oPC);
    else
        oItem = CreateItemOnObject(egs_GetRandomItem(iMainCategory, iSubCategory, iBaseItem, -1, -1, TRUE), oPC);

    ip_InfuseItemWithMagic(oItem, GetMagicLevel(oPC), TRUE, TRUE, TRUE, nForce, iDesiredPropertyCount);
}

void main()
{
    object oPC = OBJECT_SELF;
    int iConditional = GetLocalInt(oPC, CS_DLG_PC_CONDITIONAL_ID);
    int iAction = GetLocalInt(oPC, CS_DLG_PC_ACTION_ID);
    string sNodeText = GetLocalString(oPC, CS_DLG_PC_NODETEXT);

    int iDesiredPropertyCount;
    int iMainCategory;
    int iSubCategory;
    int iBaseItem;
    string sBlueprint;

    switch (iConditional)
    {
        case -1: SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE); break;
        case 1:
            if (GetMagicLevel(oPC) == 0)
                SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
            else
                SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
            break;
        case 2:
            if (GetMagicLevel(oPC) != 0)
                SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
            else
                SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
            break;
        case 3:
            iMainCategory = GetMainCategory(oPC);
            if (iMainCategory != 0 &&
                (
                 iMainCategory == CI_EGS_ITEM_MAIN_ARMOR ||
                 iMainCategory == CI_EGS_ITEM_MAIN_ACCESSORY ||
                 iMainCategory == CI_EGS_ITEM_MAIN_WEAPON
                )
               )
                SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
            else
                SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
            break;
        case 4:
            if (GetSubCategory(oPC) != 0)
                SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
            else
                SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
            break;
        case 51:
            if (GetMainCategory(oPC) == CI_EGS_ITEM_MAIN_ARMOR)
                SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
            else
                SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
            break;
        case 52:
            if (GetMainCategory(oPC) == CI_EGS_ITEM_MAIN_ACCESSORY)
                SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
            else
                SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
            break;
        case 53:
            if (GetMainCategory(oPC) == CI_EGS_ITEM_MAIN_WEAPON)
                SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
            else
                SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
            break;
        case 54:
            if (GetMainCategory(oPC) == CI_EGS_ITEM_MAIN_AMMO)
                SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
            else
                SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
            break;
        case 58:
            if (GetMainCategory(oPC) == CI_EGS_ITEM_UNDEFINED)
                SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
            else
                SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
            break;
        case 60:
            if (GetSubCategory(oPC) == CI_EGS_ITEM_SUB_ARMOR_BODY_CLOTHING)
                SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
            else
                SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
            break;
        case 61:
            if (GetSubCategory(oPC) == CI_EGS_ITEM_SUB_ARMOR_BODY_LIGHT)
                SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
            else
                SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
            break;
        case 62:
            if (GetSubCategory(oPC) == CI_EGS_ITEM_SUB_ARMOR_BODY_MEDIUM)
                SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
            else
                SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
            break;
        case 63:
            if (GetSubCategory(oPC) == CI_EGS_ITEM_SUB_ARMOR_BODY_HEAVY)
                SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
            else
                SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
            break;
        case 64:
            if (GetSubCategory(oPC) == CI_EGS_ITEM_SUB_ARMOR_SHIELD)
                SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
            else
                SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
            break;
        case 65:
            if (GetSubCategory(oPC) == CI_EGS_ITEM_SUB_ARMOR_HELMET)
                SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
            else
                SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
            break;
        case 66:
            if (GetSubCategory(oPC) == CI_EGS_ITEM_SUB_ACCESSORY_CLOTHING)
                SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
            else
                SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
            break;
        case 67:
            if (GetSubCategory(oPC) == CI_EGS_ITEM_SUB_ACCESSORY_JEWELRY)
                SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
            else
                SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
            break;
        case 68:
            if (GetSubCategory(oPC) == CI_EGS_ITEM_SUB_WEAPON_MELEE)
                SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
            else
                SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
            break;
        case 69:
            if (GetSubCategory(oPC) == CI_EGS_ITEM_SUB_WEAPON_RANGED)
                SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
            else
                SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
            break;
        case 70:
            if (GetSubCategory(oPC) == CI_EGS_ITEM_SUB_WEAPON_THROWN)
                SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
            else
                SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
            break;
        case 71:
            if (GetSubCategory(oPC) == CI_EGS_ITEM_SUB_WEAPON_STAFF)
                SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
            else
                SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
            break;
    }

    if (iAction >= 1 &&
        iAction <= 50)
    {
        SetMagicLevel(oPC, iAction);
        return;
    }

    object oItem;
    switch (iAction)
    {
        case -1: break;

        case 51: SetMainCategory(oPC, CI_EGS_ITEM_MAIN_ARMOR); break;
        case 52: SetMainCategory(oPC, CI_EGS_ITEM_MAIN_ACCESSORY); break;
        case 53: SetMainCategory(oPC, CI_EGS_ITEM_MAIN_WEAPON); break;
        case 54: SetMainCategory(oPC, CI_EGS_ITEM_MAIN_AMMO); SetSubCategory(oPC, CI_EGS_ITEM_UNDEFINED); break;
        case 55: SetMainCategory(oPC, CI_EGS_ITEM_MAIN_RODWAND); SetSubCategory(oPC, CI_EGS_ITEM_UNDEFINED); break;
        case 56: SetMainCategory(oPC, CI_EGS_ITEM_MAIN_CONTAINER); SetSubCategory(oPC, CI_EGS_ITEM_UNDEFINED); break;
        case 57: SetMainCategory(oPC, CI_EGS_ITEM_MAIN_BOMB); SetSubCategory(oPC, CI_EGS_ITEM_UNDEFINED); break;
        case 58: SetMainCategory(oPC, CI_EGS_ITEM_UNDEFINED); SetSubCategory(oPC, CI_EGS_ITEM_UNDEFINED); break;

        case 60: SetSubCategory(oPC, CI_EGS_ITEM_SUB_ARMOR_BODY_CLOTHING); break;
        case 61: SetSubCategory(oPC, CI_EGS_ITEM_SUB_ARMOR_BODY_LIGHT); break;
        case 62: SetSubCategory(oPC, CI_EGS_ITEM_SUB_ARMOR_BODY_MEDIUM); break;
        case 63: SetSubCategory(oPC, CI_EGS_ITEM_SUB_ARMOR_BODY_HEAVY); break;
        case 64: SetSubCategory(oPC, CI_EGS_ITEM_SUB_ARMOR_SHIELD); break;
        case 65: SetSubCategory(oPC, CI_EGS_ITEM_SUB_ARMOR_HELMET); SetBaseItem(oPC, BASE_ITEM_HELMET); break;
        case 66: SetSubCategory(oPC, CI_EGS_ITEM_SUB_ACCESSORY_CLOTHING); break;
        case 67: SetSubCategory(oPC, CI_EGS_ITEM_SUB_ACCESSORY_JEWELRY); break;
        case 68: SetSubCategory(oPC, CI_EGS_ITEM_SUB_WEAPON_MELEE); break;
        case 69: SetSubCategory(oPC, CI_EGS_ITEM_SUB_WEAPON_RANGED); break;
        case 70: SetSubCategory(oPC, CI_EGS_ITEM_SUB_WEAPON_THROWN); break;
        case 71: SetSubCategory(oPC, CI_EGS_ITEM_SUB_WEAPON_STAFF); break;

        case 80: DeleteDesiredPropertyCount(oPC); break;
        case 81: SetDesiredPropertyCount(oPC, 1); break;
        case 82: SetDesiredPropertyCount(oPC, 2); break;
        case 83: SetDesiredPropertyCount(oPC, 3); break;
        case 84: SetDesiredPropertyCount(oPC, 4); break;
        case 85: SetDesiredPropertyCount(oPC, 5); break;

        case 100: SetBlueprint(oPC, "i_egs_tunic01"); break;
        case 101: SetBlueprint(oPC, "i_egs_robe01"); break;

        case 110: SetBlueprint(oPC, "i_egs_parmor01"); break;
        case 111: SetBlueprint(oPC, "i_egs_larmor01"); break;
        case 112: SetBlueprint(oPC, "i_egs_slarmor01"); break;
        case 113: SetBlueprint(oPC, "i_egs_cshirt01"); break;

        case 120: SetBlueprint(oPC, "i_egs_harmor01"); break;
        case 121: SetBlueprint(oPC, "i_egs_cmail01"); break;
        case 122: SetBlueprint(oPC, "i_egs_scmail01"); break;
        case 123: SetBlueprint(oPC, "i_egs_bplate01"); break;

        case 130: SetBlueprint(oPC, "i_egs_bmail01"); break;
        case 131: SetBlueprint(oPC, "i_egs_spmail01"); break;
        case 132: SetBlueprint(oPC, "i_egs_hplate01"); break;
        case 133: SetBlueprint(oPC, "i_egs_fplate01"); break;

        case 140: SetBaseItem(oPC, BASE_ITEM_SMALLSHIELD); break;
        case 141: SetBaseItem(oPC, BASE_ITEM_LARGESHIELD); break;
        case 142: SetBaseItem(oPC, BASE_ITEM_TOWERSHIELD); break;

        case 150: SetBaseItem(oPC, BASE_ITEM_BELT); break;
        case 151: SetBaseItem(oPC, BASE_ITEM_BOOTS); break;
        case 152: SetBaseItem(oPC, BASE_ITEM_BRACER); break;
        case 153: SetBaseItem(oPC, BASE_ITEM_CLOAK); break;
        case 154: SetBaseItem(oPC, BASE_ITEM_GLOVES); break;

        case 160: SetBaseItem(oPC, BASE_ITEM_AMULET); break;
        case 161: SetBaseItem(oPC, BASE_ITEM_RING); break;

        case 170: SetBaseItem(oPC, BASE_ITEM_CLUB); break;
        case 171: SetBaseItem(oPC, BASE_ITEM_DAGGER); break;
        case 172: SetBaseItem(oPC, BASE_ITEM_LIGHTMACE); break;
        case 173: SetBaseItem(oPC, BASE_ITEM_SICKLE); break;
        case 174: SetBaseItem(oPC, BASE_ITEM_SHORTSPEAR); break;
        case 175: SetBaseItem(oPC, BASE_ITEM_MORNINGSTAR); break;
        case 176: SetBaseItem(oPC, BASE_ITEM_QUARTERSTAFF); break;
        case 177: SetBaseItem(oPC, BASE_ITEM_BASTARDSWORD); break;
        case 178: SetBaseItem(oPC, BASE_ITEM_BATTLEAXE); break;
        case 179: SetBaseItem(oPC, BASE_ITEM_GREATAXE); break;
        case 180: SetBaseItem(oPC, BASE_ITEM_GREATSWORD); break;
        case 181: SetBaseItem(oPC, BASE_ITEM_HALBERD); break;
        case 182: SetBaseItem(oPC, BASE_ITEM_HANDAXE); break;
        case 183: SetBaseItem(oPC, BASE_ITEM_HEAVYFLAIL); break;
        case 184: SetBaseItem(oPC, BASE_ITEM_LIGHTFLAIL); break;
        case 185: SetBaseItem(oPC, BASE_ITEM_LIGHTHAMMER); break;
        case 186: SetBaseItem(oPC, BASE_ITEM_LONGSWORD); break;
        case 187: SetBaseItem(oPC, BASE_ITEM_RAPIER); break;
        case 188: SetBaseItem(oPC, BASE_ITEM_SCIMITAR); break;
        case 189: SetBaseItem(oPC, BASE_ITEM_SHORTSWORD); break;
        case 190: SetBaseItem(oPC, BASE_ITEM_WARHAMMER); break;
        case 191: SetBaseItem(oPC, BASE_ITEM_DWARVENWARAXE); break;
        case 192: SetBaseItem(oPC, BASE_ITEM_DIREMACE); break;
        case 193: SetBaseItem(oPC, BASE_ITEM_DOUBLEAXE); break;
        case 194: SetBaseItem(oPC, BASE_ITEM_KAMA); break;
        case 195: SetBaseItem(oPC, BASE_ITEM_KATANA); break;
        case 196: SetBaseItem(oPC, BASE_ITEM_KUKRI); break;
        case 197: SetBaseItem(oPC, BASE_ITEM_SCYTHE); break;
        case 198: SetBaseItem(oPC, BASE_ITEM_TWOBLADEDSWORD); break;
        case 199: SetBaseItem(oPC, BASE_ITEM_WHIP); break;

        case 210: SetBaseItem(oPC, BASE_ITEM_LIGHTCROSSBOW); break;
        case 211: SetBaseItem(oPC, BASE_ITEM_HEAVYCROSSBOW); break;
        case 212: SetBaseItem(oPC, BASE_ITEM_SLING); break;
        case 213: SetBaseItem(oPC, BASE_ITEM_LONGBOW); break;
        case 214: SetBaseItem(oPC, BASE_ITEM_SHORTBOW); break;

        case 220: SetBaseItem(oPC, BASE_ITEM_DART); break;
        case 221: SetBaseItem(oPC, BASE_ITEM_THROWINGAXE); break;
        case 222: SetBaseItem(oPC, BASE_ITEM_SHURIKEN); break;

        case 230: SetBaseItem(oPC, BASE_ITEM_ARROW); break;
        case 231: SetBaseItem(oPC, BASE_ITEM_BOLT); break;
        case 232: SetBaseItem(oPC, BASE_ITEM_BULLET); break;

        case 240: SetBaseItem(oPC, BASE_ITEM_POTIONS); break;
        case 241: SetBaseItem(oPC, BASE_ITEM_THIEVESTOOLS); break;
        case 242: SetBaseItem(oPC, BASE_ITEM_HEALERSKIT); break;
        case 243: SetBaseItem(oPC, BASE_ITEM_TRAPKIT); break;
        case 244: SetBaseItem(oPC, BASE_ITEM_BOOK); break;

        case 997: DeleteMagicLevel(oPC); break;
        case 998:
            DeleteMagicLevel(oPC);
            DeleteDesiredPropertyCount(oPC);
            DeleteMainCategory(oPC);
            break;
        case 999:
            CreateItem(oPC, FALSE);
            break;
        case 1000:
            CreateItem(oPC, TRUE);
            break;
    }
}
