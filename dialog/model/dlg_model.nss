///////////////////////////////////////////////////////////////////////////////
// dlg_wand
// written by: eyesolated
// written at: April 12, 2018
//
// Notes: the conditional/action script for the wand dialog


///////////
// Includes
//
#include "eas_inc"
#include "dlg_inc"
#include "dlg_model_const"
#include "color_inc"
#include "chr_inc"
#include "esm_inc"

///////////////////////
// Function Declaration
//

////////////////
// Function Code
//

void PreReadArmorAC(string sArmorClass)
{
    object oModule = GetModule();
    string sArrayName = CS_DEF_ARRAY_ARMOR + sArmorClass;

    // If the array already exists, quit
    if (eas_Array_Exists(oModule, sArrayName))
        return;

    // Create Array
    eas_Array_Create(oModule, sArrayName, EAS_ARRAY_TYPE_INTEGER);

    // Cache Armor Parts
    string sReadArmorClass;
    int nth = 1;
    while (nth <= 255)
    {
        sReadArmorClass = GetStringLeft(Get2DAString("parts_chest", "ACBONUS", nth), 1);
        if (sReadArmorClass == sArmorClass)
            eas_IArray_Entry_Add(oModule, sArrayName, nth);

        nth++;
    }
}

void PreReadArmorParts(int nPart)
{
    object oModule = GetModule();
    string sArrayName = CS_DEF_ARRAY_ARMOR_PART + IntToString(nPart);

    // If the array already exists, quit
    if (eas_Array_Exists(oModule, sArrayName))
        return;

    // Create Array
    eas_Array_Create(oModule, sArrayName, EAS_ARRAY_TYPE_INTEGER);

    string s2DA = "parts_";
    switch (nPart) {
        case ITEM_APPR_ARMOR_MODEL_LBICEP:
        case ITEM_APPR_ARMOR_MODEL_RBICEP: s2DA+= "bicep"; break;
        case ITEM_APPR_ARMOR_MODEL_LFOOT:
        case ITEM_APPR_ARMOR_MODEL_RFOOT: s2DA+= "foot"; break;
        case ITEM_APPR_ARMOR_MODEL_LFOREARM:
        case ITEM_APPR_ARMOR_MODEL_RFOREARM: s2DA+= "forearm"; break;
        case ITEM_APPR_ARMOR_MODEL_LHAND:
        case ITEM_APPR_ARMOR_MODEL_RHAND: s2DA+= "hand"; break;
        case ITEM_APPR_ARMOR_MODEL_LSHIN:
        case ITEM_APPR_ARMOR_MODEL_RSHIN: s2DA+= "shin"; break;
        case ITEM_APPR_ARMOR_MODEL_LSHOULDER:
        case ITEM_APPR_ARMOR_MODEL_RSHOULDER: s2DA+= "shoulder"; break;
        case ITEM_APPR_ARMOR_MODEL_LTHIGH:
        case ITEM_APPR_ARMOR_MODEL_RTHIGH: s2DA+= "legs"; break;
        case ITEM_APPR_ARMOR_MODEL_NECK: s2DA+= "neck"; break;
        case ITEM_APPR_ARMOR_MODEL_BELT: s2DA+= "belt"; break;
        case ITEM_APPR_ARMOR_MODEL_PELVIS: s2DA+= "pelvis"; break;
        case ITEM_APPR_ARMOR_MODEL_ROBE: s2DA+= "robe"; break;
    }

    string sArmorClass;
    string sHasModel = Get2DAString(s2DA, "HASMODEL", 1);
    int nCEP = TRUE;
    if (sHasModel == "")
        nCEP = FALSE;

    int nth= 1;
    while (nth <= 255)
    {
        sArmorClass = Get2DAString(s2DA, "ACBONUS", nth);
        sHasModel = Get2DAString(s2DA, "HASMODEL", nth);
        if (sArmorClass != "" && (!nCEP || sHasModel != ""))
            eas_IArray_Entry_Add(oModule, sArrayName, nth);

        nth++;
    }
}

void CopyItemToModel(object oItem, object oModel, int nInventorySlot)
{
    if (!GetIsObjectValid(oItem))
        return;

    object oCopy = CopyItem(oItem, oModel, TRUE);
    object oCurrentItem = GetItemInSlot(nInventorySlot, oModel);

    // Store the source item on the copied item to prevent duping when buying/copying back later
    SetLocalObject(oCopy, "model_ItemReference", oItem);

    AssignCommand(oModel, ActionEquipItem(oCopy, nInventorySlot));

    if (GetIsObjectValid(oCurrentItem) &&
        GetTag(oCurrentItem) != CS_DEF_INVISIBLEWEAPON)
        DelayCommand(CF_MODEL_DELAY_DESTROYWEAPON, DestroyObject(oCurrentItem));
}

string Get2da(int nBaseType)
{
    switch (nBaseType)
    {
        case BASE_ITEM_CLOAK: return "cloakmodel"; break;
        case BASE_ITEM_SMALLSHIELD: return "cepshieldmodel"; break;
        case BASE_ITEM_LARGESHIELD: return "cepshieldmodel"; break;
        case BASE_ITEM_TOWERSHIELD: return "cepshieldmodel"; break;
    }

    return "";
}

string Get2daColumn(int nBaseType)
{
    switch (nBaseType)
    {
        case BASE_ITEM_CLOAK: return "LABEL"; break;
        case BASE_ITEM_SMALLSHIELD: return "BASE_ITEM_SMALLSHIELD"; break;
        case BASE_ITEM_LARGESHIELD: return "BASE_ITEM_LARGESHIELD"; break;
        case BASE_ITEM_TOWERSHIELD: return "BASE_ITEM_TOWERSHIELD"; break;
    }

    return "";
}

int Verify2da(string s2da, string sColumn)
{
    if (s2da == "" ||
        sColumn == "" ||
        Get2DAString(s2da, sColumn, 1) == "")
        return FALSE;

    return TRUE;
}

void SetColorType(object oPC, int nIndex)
{
    SetLocalInt(oPC, "model_SelColType", nIndex + 1);
    switch (nIndex)
    {
        case ITEM_APPR_ARMOR_COLOR_METAL1:
        case ITEM_APPR_ARMOR_COLOR_METAL2: SetLocalInt(oPC, "model_SelColTypeMetal", TRUE); break;
    }
}

int GetColorType(object oPC)
{
    return (GetLocalInt(oPC, "model_SelColType") - 1);
}

void DeleteColorType(object oPC)
{
    DeleteLocalInt(oPC, "model_SelColType");
    DeleteLocalInt(oPC, "model_SelColTypeMetal");
}

int SetOriginalColor(object oItem, int nIndex, int nColor)
{
    int nOriginal = GetLocalInt(oItem, CS_DEF_VAR_COLOR_ORIGINAL + IntToString(nIndex)) - 1;

    // Set the given appearance as the original appearance if not set yet
    if (nOriginal == -1)
    {
        nOriginal = nColor;
        SetLocalInt(oItem, CS_DEF_VAR_COLOR_ORIGINAL + IntToString(nIndex), nOriginal + 1);
    }

    return nOriginal;
}

void ChangeWeaponColor(object oModel, int nInventorySlot, int nItemIndex, int nValue)
{
    object oCurrentItem = GetItemInSlot(nInventorySlot, oModel);
    if (!GetIsObjectValid(oCurrentItem))
        return;

    int nIndex;
    switch (nItemIndex)
    {
        case ITEM_APPR_WEAPON_MODEL_BOTTOM: nIndex = ITEM_APPR_WEAPON_COLOR_BOTTOM; break;
        case ITEM_APPR_WEAPON_MODEL_MIDDLE: nIndex = ITEM_APPR_WEAPON_COLOR_MIDDLE; break;
        case ITEM_APPR_WEAPON_MODEL_TOP: nIndex = ITEM_APPR_WEAPON_COLOR_TOP; break;
    }
    int nStartColor = GetItemAppearance(oCurrentItem, ITEM_APPR_TYPE_WEAPON_COLOR, nIndex);
    object oItem = CopyItemAndModify(oCurrentItem, ITEM_APPR_TYPE_WEAPON_COLOR, nIndex, nValue, TRUE);

    if (GetIsObjectValid(oItem))
    {
        object oNewItem = CopyItem(oItem, oModel, TRUE);
        DestroyObject(oItem);

        AssignCommand(oModel, ActionEquipItem(oNewItem, nInventorySlot));
        DelayCommand(CF_MODEL_DELAY_DESTROYWEAPON, DestroyObject(oCurrentItem));

        // Check Color things
        int nOriginalColor;
        nOriginalColor = SetOriginalColor(oNewItem, nIndex, nStartColor);

        if (nOriginalColor != nValue)             // the new Color Value isn't the original color
        {
            if (nOriginalColor == nStartColor)    // and we're at the start color
            {
                eas_Array_Create(oNewItem, CS_DEF_ARRAY_COLORS, EAS_ARRAY_TYPE_INTEGER);
                eas_IArray_Entry_Add(oNewItem, CS_DEF_ARRAY_COLORS, nIndex); // add nIndex to the changed indices

            }

            SetLocalInt(oNewItem, CS_DEF_VAR_COLOR + IntToString(nIndex), nValue); // set the Appearance for index
        }
        else                                                // the new Appearance is the original appearance
        {
            eas_IArray_Entry_DeleteByValue(oNewItem, CS_DEF_ARRAY_COLORS, nIndex); // remove nIndex from the changed indices
            DeleteLocalInt(oNewItem, CS_DEF_VAR_COLOR + IntToString(nIndex));
        }
    }
}

void ChangeArmorColor(object oModel, int nInventorySlot, int nIndex, int nValue, int nColorType = 0)
{
    object oCurrentItem = GetItemInSlot(nInventorySlot, oModel);
    if (!GetIsObjectValid(oCurrentItem))
        return;

    SetLocalInt(oModel, "Color_LastSelected", nValue + 1);
    int nCounterpart = -1;

    if (nIndex < 0)
    {
        switch (nIndex)
        {
            case CI_DEF_ARMOR_SAME_BICEPS: nIndex = ITEM_APPR_ARMOR_NUM_COLORS + (ITEM_APPR_ARMOR_MODEL_LBICEP * ITEM_APPR_ARMOR_NUM_COLORS) + nColorType; nCounterpart = ITEM_APPR_ARMOR_NUM_COLORS + (ITEM_APPR_ARMOR_MODEL_RBICEP * ITEM_APPR_ARMOR_NUM_COLORS) + nColorType; break;
            case CI_DEF_ARMOR_SAME_FEET: nIndex = ITEM_APPR_ARMOR_NUM_COLORS + (ITEM_APPR_ARMOR_MODEL_LFOOT * ITEM_APPR_ARMOR_NUM_COLORS) + nColorType; nCounterpart = ITEM_APPR_ARMOR_NUM_COLORS + (ITEM_APPR_ARMOR_MODEL_RFOOT * ITEM_APPR_ARMOR_NUM_COLORS) + nColorType; break;
            case CI_DEF_ARMOR_SAME_FOREARMS: nIndex = ITEM_APPR_ARMOR_NUM_COLORS + (ITEM_APPR_ARMOR_MODEL_LFOREARM * ITEM_APPR_ARMOR_NUM_COLORS) + nColorType; nCounterpart = ITEM_APPR_ARMOR_NUM_COLORS + (ITEM_APPR_ARMOR_MODEL_RFOREARM * ITEM_APPR_ARMOR_NUM_COLORS) + nColorType; break;
            case CI_DEF_ARMOR_SAME_HANDS: nIndex = ITEM_APPR_ARMOR_NUM_COLORS + (ITEM_APPR_ARMOR_MODEL_LHAND * ITEM_APPR_ARMOR_NUM_COLORS) + nColorType; nCounterpart = ITEM_APPR_ARMOR_NUM_COLORS + (ITEM_APPR_ARMOR_MODEL_RHAND * ITEM_APPR_ARMOR_NUM_COLORS) + nColorType; break;
            case CI_DEF_ARMOR_SAME_SHINS: nIndex = ITEM_APPR_ARMOR_NUM_COLORS + (ITEM_APPR_ARMOR_MODEL_LSHIN * ITEM_APPR_ARMOR_NUM_COLORS) + nColorType; nCounterpart = ITEM_APPR_ARMOR_NUM_COLORS + (ITEM_APPR_ARMOR_MODEL_RSHIN * ITEM_APPR_ARMOR_NUM_COLORS) + nColorType; break;
            case CI_DEF_ARMOR_SAME_SHOULDERS: nIndex = ITEM_APPR_ARMOR_NUM_COLORS + (ITEM_APPR_ARMOR_MODEL_LSHOULDER * ITEM_APPR_ARMOR_NUM_COLORS) + nColorType; nCounterpart = ITEM_APPR_ARMOR_NUM_COLORS + (ITEM_APPR_ARMOR_MODEL_RSHOULDER * ITEM_APPR_ARMOR_NUM_COLORS) + nColorType; break;
            case CI_DEF_ARMOR_SAME_THIGHS: nIndex = ITEM_APPR_ARMOR_NUM_COLORS + (ITEM_APPR_ARMOR_MODEL_LTHIGH * ITEM_APPR_ARMOR_NUM_COLORS) + nColorType; nCounterpart = ITEM_APPR_ARMOR_NUM_COLORS + (ITEM_APPR_ARMOR_MODEL_RTHIGH * ITEM_APPR_ARMOR_NUM_COLORS) + nColorType; break;
        }
    }

    int nStartColor = GetItemAppearance(oCurrentItem, ITEM_APPR_TYPE_ARMOR_COLOR, nIndex);
    object oItem = CopyItemAndModify(oCurrentItem, ITEM_APPR_TYPE_ARMOR_COLOR, nIndex, nValue, TRUE);
    if (nCounterpart != -1)
    {
        DelayCommand(CF_MODEL_DELAY_DESTROYWEAPON, DestroyObject(oItem));
        oItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, nCounterpart, nValue, TRUE);
    }

    if (GetIsObjectValid(oItem))
    {
        object oNewItem = CopyItem(oItem, oModel, TRUE);
        DestroyObject(oItem);

        AssignCommand(oModel, ActionEquipItem(oNewItem, nInventorySlot));
        DelayCommand(CF_MODEL_DELAY_DESTROYWEAPON, DestroyObject(oCurrentItem));

        // Check Color things
        int nOriginalColor;
        if (nCounterpart != -1)
        {
            nOriginalColor = SetOriginalColor(oNewItem, nIndex, nStartColor);
            SetOriginalColor(oNewItem, nCounterpart, nStartColor);
        }
        else
            nOriginalColor = SetOriginalColor(oNewItem, nIndex, nStartColor);

        if (nOriginalColor != nValue)             // the new Color Value isn't the original color
        {
            if (nOriginalColor == nStartColor)    // and we're at the start color
            {
                eas_Array_Create(oNewItem, CS_DEF_ARRAY_COLORS, EAS_ARRAY_TYPE_INTEGER);
                eas_IArray_Entry_Add(oNewItem, CS_DEF_ARRAY_COLORS, nIndex); // add nIndex to the changed indices

                if (nCounterpart != -1)
                    eas_IArray_Entry_Add(oNewItem, CS_DEF_ARRAY_COLORS, nCounterpart); // add nIndex to the changed indices
            }

            SetLocalInt(oNewItem, CS_DEF_VAR_COLOR + IntToString(nIndex), nValue); // set the Appearance for index
            if (nCounterpart != -1)
                SetLocalInt(oNewItem, CS_DEF_VAR_COLOR + IntToString(nCounterpart), nValue); // set the Appearance for the counterpart
        }
        else                                                // the new Appearance is the original appearance
        {
            eas_IArray_Entry_DeleteByValue(oNewItem, CS_DEF_ARRAY_COLORS, nIndex); // remove nIndex from the changed indices
            DeleteLocalInt(oNewItem, CS_DEF_VAR_COLOR + IntToString(nIndex));

            if (nCounterpart != -1)
            {
                eas_IArray_Entry_DeleteByValue(oNewItem, CS_DEF_ARRAY_COLORS, nCounterpart); // remove nIndex from the changed indices
                DeleteLocalInt(oNewItem, CS_DEF_VAR_COLOR + IntToString(nCounterpart));
            }
        }
    }
}

int SetOriginalAppearance(object oItem, int nIndex, int nAppearance)
{
    int nOriginal = GetLocalInt(oItem, CS_DEF_VAR_APPEARANCE_ORIGINAL + IntToString(nIndex)) - 1;

    // Set the given appearance as the original appearance if not set yet
    if (nOriginal == -1)
    {
        nOriginal = nAppearance;
        SetLocalInt(oItem, CS_DEF_VAR_APPEARANCE_ORIGINAL + IntToString(nIndex), nOriginal + 1);
    }

    return nOriginal;
}

void ChangeItemAppearance(object oModel, int nInventorySlot, int nIndex = 0, int nChangeDirection = 1)
{
    object oModule = GetModule();

    object oCurrentItem = GetItemInSlot(nInventorySlot, oModel);
    if (!GetIsObjectValid(oCurrentItem))
        return;

    int nBase = GetBaseItemType(oCurrentItem);
    int nAppearance;
    int nStartAppearance;

    int nMin = StringToInt(Get2DAString("baseitems", "MinRange", nBase));
    int nMax = StringToInt(Get2DAString("baseitems", "MaxRange", nBase));
    if (nMax == 0)
        nMax = 255;

    int nChangesMade = 1;
    object oItem;
    string s2da = Get2da(nBase);
    string s2daColumn = Get2daColumn(nBase);
    int n2da;
    string sTest;
    int nPos;
    string sAC;
    string sArrayName;
    int nArraySize;
    int nRealIndex = nIndex;
    int nCounterpart = -1;
    object oCounterpart;
    switch (nBase)
    {
        case BASE_ITEM_ARMOR:
            if (nIndex < 0)
            {
                switch (nIndex)
                {
                    case CI_DEF_ARMOR_SAME_BICEPS: nRealIndex = ITEM_APPR_ARMOR_MODEL_LBICEP; nCounterpart = ITEM_APPR_ARMOR_MODEL_RBICEP; break;
                    case CI_DEF_ARMOR_SAME_FEET: nRealIndex = ITEM_APPR_ARMOR_MODEL_LFOOT; nCounterpart = ITEM_APPR_ARMOR_MODEL_RFOOT; break;
                    case CI_DEF_ARMOR_SAME_FOREARMS: nRealIndex = ITEM_APPR_ARMOR_MODEL_LFOREARM; nCounterpart = ITEM_APPR_ARMOR_MODEL_RFOREARM; break;
                    case CI_DEF_ARMOR_SAME_HANDS: nRealIndex = ITEM_APPR_ARMOR_MODEL_LHAND; nCounterpart = ITEM_APPR_ARMOR_MODEL_RHAND; break;
                    case CI_DEF_ARMOR_SAME_SHINS: nRealIndex = ITEM_APPR_ARMOR_MODEL_LSHIN; nCounterpart = ITEM_APPR_ARMOR_MODEL_RSHIN; break;
                    case CI_DEF_ARMOR_SAME_SHOULDERS: nRealIndex = ITEM_APPR_ARMOR_MODEL_LSHOULDER; nCounterpart = ITEM_APPR_ARMOR_MODEL_RSHOULDER; break;
                    case CI_DEF_ARMOR_SAME_THIGHS: nRealIndex = ITEM_APPR_ARMOR_MODEL_LTHIGH; nCounterpart = ITEM_APPR_ARMOR_MODEL_RTHIGH; break;
                }
            }

            nAppearance = GetItemAppearance(oCurrentItem, ITEM_APPR_TYPE_ARMOR_MODEL, nRealIndex);
            nStartAppearance = nAppearance;
            switch (nRealIndex)
            {
                case ITEM_APPR_ARMOR_MODEL_TORSO:
                    sAC = GetStringLeft(Get2DAString("parts_chest", "ACBONUS", nAppearance), 1);
                    sArrayName = CS_DEF_ARRAY_ARMOR + sAC;
                    PreReadArmorAC(sAC);
                    break;
                default:
                    sArrayName = CS_DEF_ARRAY_ARMOR_PART + IntToString(nRealIndex);
                    PreReadArmorParts(nRealIndex);
                    break;
            }

            // Get the position of the current entry in the Array
            nPos = eas_IArray_Entry_IndexOf(oModule, sArrayName, nAppearance);
            nArraySize = eas_Array_GetSize(oModule, sArrayName);
            if (nChangeDirection == 1)
            {
                if (nPos == nArraySize - 1)
                    nAppearance = eas_IArray_Entry_Get(oModule, sArrayName, 0);
                else
                    nAppearance = eas_IArray_Entry_Get(oModule, sArrayName, nPos + 1);
            }
            else
            {
                if (nPos == 0)
                    nAppearance = eas_IArray_Entry_Get(oModule, sArrayName, nArraySize - 1);
                else
                    nAppearance = eas_IArray_Entry_Get(oModule, sArrayName, nPos - 1);
            }

            if (nIndex < 0)
            {
                switch (nIndex)
                {
                    case CI_DEF_ARMOR_SAME_BICEPS:
                        oCounterpart = CopyItemAndModify(oCurrentItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LBICEP, nAppearance, TRUE);
                        oItem = CopyItemAndModify(oCounterpart, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RBICEP, nAppearance, TRUE);
                        break;
                    case CI_DEF_ARMOR_SAME_FEET:
                        oCounterpart = CopyItemAndModify(oCurrentItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOOT, nAppearance, TRUE);
                        oItem = CopyItemAndModify(oCounterpart, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOOT, nAppearance, TRUE);
                        break;
                    case CI_DEF_ARMOR_SAME_FOREARMS:
                        oCounterpart = CopyItemAndModify(oCurrentItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOREARM, nAppearance, TRUE);
                        oItem = CopyItemAndModify(oCounterpart, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOREARM, nAppearance, TRUE);
                        break;
                    case CI_DEF_ARMOR_SAME_HANDS:
                        oCounterpart = CopyItemAndModify(oCurrentItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LHAND, nAppearance, TRUE);
                        oItem = CopyItemAndModify(oCounterpart, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RHAND, nAppearance, TRUE);
                        break;
                    case CI_DEF_ARMOR_SAME_SHINS:
                        oCounterpart = CopyItemAndModify(oCurrentItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHIN, nAppearance, TRUE);
                        oItem = CopyItemAndModify(oCounterpart, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHIN, nAppearance, TRUE);
                        break;
                    case CI_DEF_ARMOR_SAME_SHOULDERS:
                        oCounterpart = CopyItemAndModify(oCurrentItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHOULDER, nAppearance, TRUE);
                        oItem = CopyItemAndModify(oCounterpart, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHOULDER, nAppearance, TRUE);
                        break;
                    case CI_DEF_ARMOR_SAME_THIGHS:
                        oCounterpart = CopyItemAndModify(oCurrentItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LTHIGH, nAppearance, TRUE);
                        oItem = CopyItemAndModify(oCounterpart, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RTHIGH, nAppearance, TRUE);
                        break;
                }
                DelayCommand(CF_MODEL_DELAY_DESTROYWEAPON, DestroyObject(oCounterpart));
            }
            else
                oItem = CopyItemAndModify(oCurrentItem, ITEM_APPR_TYPE_ARMOR_MODEL, nRealIndex, nAppearance, TRUE);

            break;
        case BASE_ITEM_HELMET:
            // Helmets need no 2da-checks
            nAppearance = GetItemAppearance(oCurrentItem, ITEM_APPR_TYPE_ARMOR_MODEL, 0);
            nStartAppearance = nAppearance;
            do {
                if ( nChangeDirection == 1 ) {
                    if ( ++nAppearance > nMax ) nAppearance = nMin;
                } else {
                    if ( --nAppearance < nMin ) nAppearance = nMax;
                }

                oItem = CopyItemAndModify(oCurrentItem, ITEM_APPR_TYPE_ARMOR_MODEL, 0, nAppearance, TRUE);
            } while ( !GetIsObjectValid(oItem) );
            break;
        case BASE_ITEM_CLOAK:
            // Test 2da availability
            n2da = Verify2da(s2da, s2daColumn);
            nAppearance = GetItemAppearance(oCurrentItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
            nStartAppearance = nAppearance;
            if (n2da)
            {
                do {
                    if ( nChangeDirection == 1 ) {
                        if ( ++nAppearance > nMax ) nAppearance = nMin;
                    } else {
                        if ( --nAppearance < nMin ) nAppearance = nMax;
                    }

                    sTest = Get2DAString(s2da, s2daColumn, nAppearance);
                } while (sTest == "" & nAppearance != nStartAppearance);

                oItem = CopyItemAndModify(oCurrentItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nAppearance, TRUE);
            }
            else
            {
                do {
                    if ( nChangeDirection == 1 ) {
                        if ( ++nAppearance > nMax ) nAppearance = nMin;
                    } else {
                        if ( --nAppearance < nMin ) nAppearance = nMax;
                    }

                    oItem = CopyItemAndModify(oCurrentItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nAppearance, TRUE);
                } while (!GetIsObjectValid(oItem));
            }
            break;
        case BASE_ITEM_SMALLSHIELD:
        case BASE_ITEM_LARGESHIELD:
        case BASE_ITEM_TOWERSHIELD:
            // Test 2da availability
            n2da = Verify2da(s2da, s2daColumn);
            nAppearance = GetItemAppearance(oCurrentItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
            nStartAppearance = nAppearance;
            if (n2da)
            {
                do {
                    if ( nChangeDirection == 1 ) {
                        if ( ++nAppearance > nMax ) nAppearance = nMin;
                    } else {
                        if ( --nAppearance < nMin ) nAppearance = nMax;
                    }

                    sTest = Get2DAString(s2da, s2daColumn, nAppearance);
                } while (sTest == "" & nAppearance != nStartAppearance);

                oItem = CopyItemAndModify(oCurrentItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nAppearance, TRUE);
            }
            else
            {
                do {
                    if ( nChangeDirection == 1 ) {
                        if ( ++nAppearance > nMax ) nAppearance = nMin;
                    } else {
                        if ( --nAppearance < nMin ) nAppearance = nMax;
                    }

                    oItem = CopyItemAndModify(oCurrentItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nAppearance, TRUE);
                } while (!GetIsObjectValid(oItem));
            }
            break;
        default: // Weapons
            // Weapons need no 2da-checks
            nMin /= 10;
            nMax /= 10;
            nAppearance = GetItemAppearance(oCurrentItem, ITEM_APPR_TYPE_WEAPON_MODEL, nIndex);
            nStartAppearance = nAppearance;
            do {
                if ( nChangeDirection == 1 ) {
                    if ( ++nAppearance > nMax ) nAppearance = nMin;
                } else {
                    if ( --nAppearance < nMin ) nAppearance = nMax;
                }

                oItem = CopyItemAndModify(oCurrentItem, ITEM_APPR_TYPE_WEAPON_MODEL, nIndex, nAppearance, TRUE);
            } while ( !GetIsObjectValid(oItem) );
            break;
        break;
    }

    if (GetIsObjectValid(oItem))
    {
        object oNewItem = CopyItem(oItem, oModel, TRUE);
        DestroyObject(oItem);

        AssignCommand(oModel, ActionEquipItem(oNewItem, nInventorySlot));
        DelayCommand(CF_MODEL_DELAY_DESTROYWEAPON, DestroyObject(oCurrentItem));

        // Check appearance things
        int nOriginalAppearance;
        if (nIndex < 0)
        {
            nOriginalAppearance = SetOriginalAppearance(oNewItem, nRealIndex, nStartAppearance);
            SetOriginalAppearance(oNewItem, nCounterpart, nStartAppearance);

            // Set nIndex to the Real Index now
            nIndex = nRealIndex;
        }
        else
            nOriginalAppearance = SetOriginalAppearance(oNewItem, nIndex, nStartAppearance);

        if (nOriginalAppearance != nAppearance)             // the new Appearance isn't the original appearance
        {
            if (nOriginalAppearance == nStartAppearance)    // and we're at the start appearance
            {
                eas_Array_Create(oNewItem, CS_DEF_ARRAY_CHANGES, EAS_ARRAY_TYPE_INTEGER);
                eas_IArray_Entry_Add(oNewItem, CS_DEF_ARRAY_CHANGES, nIndex); // add nIndex to the changed indices

                if (nCounterpart != -1)
                    eas_IArray_Entry_Add(oNewItem, CS_DEF_ARRAY_CHANGES, nCounterpart); // add nIndex to the changed indices
            }

            SetLocalInt(oNewItem, CS_DEF_VAR_CHANGE + IntToString(nIndex), nAppearance); // set the Appearance for index
            if (nCounterpart != -1)
                SetLocalInt(oNewItem, CS_DEF_VAR_CHANGE + IntToString(nCounterpart), nAppearance); // set the Appearance for the counterpart
        }
        else                                                // the new Appearance is the original appearance
        {
            eas_IArray_Entry_DeleteByValue(oNewItem, CS_DEF_ARRAY_CHANGES, nIndex); // remove nIndex from the changed indices
            DeleteLocalInt(oNewItem, CS_DEF_VAR_CHANGE + IntToString(nIndex));

            if (nCounterpart != -1)
            {
                eas_IArray_Entry_DeleteByValue(oNewItem, CS_DEF_ARRAY_CHANGES, nCounterpart); // remove nIndex from the changed indices
                DeleteLocalInt(oNewItem, CS_DEF_VAR_CHANGE + IntToString(nCounterpart));
            }
        }
    }
}

void CheckColor(object oItem, object oTargetItem, int nMainIndex, int nIndex)
{
    int nAppearance = GetItemAppearance(oItem, nMainIndex, nIndex);
    if (nAppearance != GetItemAppearance(oTargetItem, nMainIndex, nIndex))
    {
        eas_IArray_Entry_Add(oItem, CS_DEF_ARRAY_COLORS_ANALYZE, nIndex);
        SetLocalInt(oItem, CS_DEF_VAR_COLOR_ANALYZE + IntToString(nIndex), nAppearance);
    }
}

void Analyze(object oItem, object oTargetItem, int nMainIndex, int nMainIndexColor, int nIndex, int nIndexColor = -1)
{
    int nAppearance = GetItemAppearance(oItem, nMainIndex, nIndex);
    if (nAppearance != GetItemAppearance(oTargetItem, nMainIndex, nIndex))
    {
        eas_IArray_Entry_Add(oItem, CS_DEF_ARRAY_CHANGES_ANALYZE, nIndex);
        SetLocalInt(oItem, CS_DEF_VAR_CHANGE_ANALYZE + IntToString(nIndex), nAppearance);
    }

    if (nMainIndexColor == ITEM_APPR_TYPE_ARMOR_COLOR)
    {
        int nBaseType = GetBaseItemType(oItem);
        switch (nBaseType)
        {
            case BASE_ITEM_ARMOR:
                if (nIndex == -1)   // Non-Individual Colors of Armor
                {
                    CheckColor(oItem, oTargetItem, nMainIndexColor, ITEM_APPR_ARMOR_COLOR_CLOTH1);
                    CheckColor(oItem, oTargetItem, nMainIndexColor, ITEM_APPR_ARMOR_COLOR_CLOTH2);
                    CheckColor(oItem, oTargetItem, nMainIndexColor, ITEM_APPR_ARMOR_COLOR_LEATHER1);
                    CheckColor(oItem, oTargetItem, nMainIndexColor, ITEM_APPR_ARMOR_COLOR_LEATHER2);
                    CheckColor(oItem, oTargetItem, nMainIndexColor, ITEM_APPR_ARMOR_COLOR_METAL1);
                    CheckColor(oItem, oTargetItem, nMainIndexColor, ITEM_APPR_ARMOR_COLOR_METAL2);
                }
                else                // Individual Colors of Armor
                {
                    /* Impossible at this time because of a bug in GetItemAppearance
                    CheckColor(oItem, oTargetItem, nMainIndexColor, ITEM_APPR_ARMOR_NUM_COLORS + (nIndex * ITEM_APPR_ARMOR_NUM_COLORS) + ITEM_APPR_ARMOR_COLOR_CLOTH1);
                    CheckColor(oItem, oTargetItem, nMainIndexColor, ITEM_APPR_ARMOR_NUM_COLORS + (nIndex * ITEM_APPR_ARMOR_NUM_COLORS) + ITEM_APPR_ARMOR_COLOR_CLOTH2);
                    CheckColor(oItem, oTargetItem, nMainIndexColor, ITEM_APPR_ARMOR_NUM_COLORS + (nIndex * ITEM_APPR_ARMOR_NUM_COLORS) + ITEM_APPR_ARMOR_COLOR_LEATHER1);
                    CheckColor(oItem, oTargetItem, nMainIndexColor, ITEM_APPR_ARMOR_NUM_COLORS + (nIndex * ITEM_APPR_ARMOR_NUM_COLORS) + ITEM_APPR_ARMOR_COLOR_LEATHER2);
                    CheckColor(oItem, oTargetItem, nMainIndexColor, ITEM_APPR_ARMOR_NUM_COLORS + (nIndex * ITEM_APPR_ARMOR_NUM_COLORS) + ITEM_APPR_ARMOR_COLOR_METAL1);
                    CheckColor(oItem, oTargetItem, nMainIndexColor, ITEM_APPR_ARMOR_NUM_COLORS + (nIndex * ITEM_APPR_ARMOR_NUM_COLORS) + ITEM_APPR_ARMOR_COLOR_METAL2);
                    */
                }
                break;
            default:
                CheckColor(oItem, oTargetItem, nMainIndexColor, ITEM_APPR_ARMOR_COLOR_CLOTH1);
                CheckColor(oItem, oTargetItem, nMainIndexColor, ITEM_APPR_ARMOR_COLOR_CLOTH2);
                CheckColor(oItem, oTargetItem, nMainIndexColor, ITEM_APPR_ARMOR_COLOR_LEATHER1);
                CheckColor(oItem, oTargetItem, nMainIndexColor, ITEM_APPR_ARMOR_COLOR_LEATHER2);
                CheckColor(oItem, oTargetItem, nMainIndexColor, ITEM_APPR_ARMOR_COLOR_METAL1);
                CheckColor(oItem, oTargetItem, nMainIndexColor, ITEM_APPR_ARMOR_COLOR_METAL2);
                break;
        }
    }
    else if (nMainIndexColor == ITEM_APPR_TYPE_WEAPON_COLOR)
        CheckColor(oItem, oTargetItem, nMainIndexColor, nIndexColor);
}

int GetChangeCount(object oItem, object oTargetItem)
{
    if (GetLocalObject(oItem, "model_ItemReference") == oTargetItem)
        return eas_Array_GetSize(oItem, CS_DEF_ARRAY_CHANGES);
    else if (GetLocalObject(oItem, CS_DEF_ARRAY_ANALYZEREFERENCE) == oTargetItem)
        return eas_Array_GetSize(oItem, CS_DEF_ARRAY_CHANGES_ANALYZE);
    else
    {
        // Create the array if it doesn't exist yet
        eas_Array_Create(oItem, CS_DEF_ARRAY_CHANGES_ANALYZE, EAS_ARRAY_TYPE_INTEGER);

        // Delete the array's entries
        eas_Array_Delete(oItem, CS_DEF_ARRAY_CHANGES_ANALYZE, FALSE);

        // Analyze changes
        int nBaseType = GetBaseItemType(oItem);
        int nAppearance;
        switch (nBaseType)
        {
            case BASE_ITEM_ARMOR:
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_TYPE_ARMOR_COLOR, -1);
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_MODEL_BELT);
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_MODEL_LBICEP);
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_MODEL_LFOOT);
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_MODEL_LFOREARM);
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_MODEL_LHAND);
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_MODEL_LSHIN);
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_MODEL_LSHOULDER);
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_MODEL_LTHIGH);
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_MODEL_NECK);
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_MODEL_PELVIS);
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_MODEL_RBICEP);
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_MODEL_RFOOT);
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_MODEL_RFOREARM);
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_MODEL_RHAND);
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_MODEL_ROBE);
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_MODEL_RSHIN);
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_MODEL_RSHOULDER);
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_MODEL_RTHIGH);
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_MODEL_TORSO);
                break;
            case BASE_ITEM_CLOAK:
            case BASE_ITEM_HELMET:
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_TYPE_ARMOR_COLOR, 0);
                break;
            case BASE_ITEM_SMALLSHIELD:
            case BASE_ITEM_LARGESHIELD:
            case BASE_ITEM_TOWERSHIELD:
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_SIMPLE_MODEL, -1, 0);
                break;
            default:
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_MODEL_BOTTOM, ITEM_APPR_WEAPON_COLOR_BOTTOM);
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_MODEL_MIDDLE, ITEM_APPR_WEAPON_COLOR_MIDDLE);
                Analyze(oItem, oTargetItem, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_MODEL_TOP, ITEM_APPR_WEAPON_COLOR_TOP);
                break;
        }

        // Set the TargetItem as the Analyze Reference
        SetLocalObject(oItem, CS_DEF_ARRAY_ANALYZEREFERENCE, oTargetItem);

        // Return the analyzation result
        return eas_Array_GetSize(oItem, CS_DEF_ARRAY_CHANGES_ANALYZE);
    }
}

int GetColorChangeCount(object oItem, object oTargetItem)
{
    if (GetLocalObject(oItem, "model_ItemReference") == oTargetItem)
        return eas_Array_GetSize(oItem, CS_DEF_ARRAY_COLORS);
    else if (GetLocalObject(oItem, CS_DEF_ARRAY_ANALYZEREFERENCE) == oTargetItem)
        return eas_Array_GetSize(oItem, CS_DEF_ARRAY_COLORS_ANALYZE);
    else
        return 0;
}

int GetChangeCost_Gold(object oItem)
{
    return (GetLocalInt(oItem, "model_chgcost_gld"));
}

int CalculateChangeCost_Color(object oItem, object oTargetItem)
{
    if (GetLocalInt(GetItemPossessor(oItem), CS_MODEL_COST_NODYE) == 1)        // No color cost
        return 0;
    else
        return GetColorChangeCount(oItem, oTargetItem);
}

int CalculateChangeCost_Gold(object oItem, object oTargetItem)
{
    if (!GetIsObjectValid(oItem))
        return 0;

    int nChangeCount = GetChangeCount(oItem, oTargetItem);
    int nMultiplier;
    int nOverride;
    int nBaseType = GetBaseItemType(oItem);
    int nAC;
    switch (nBaseType)
    {
        case BASE_ITEM_ARMOR:
            nAC = StringToInt(GetStringLeft(Get2DAString("parts_chest", "ACBONUS", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO)), 1));
            nOverride = GetLocalInt(GetItemPossessor(oItem), CS_MODEL_COST_PER_CHANGE_GOLD_ARMOR_OVERRIDE);
            if (nOverride != 0)
            {
                if (nOverride == -1)
                    nMultiplier = 0;
                else
                    nMultiplier = nOverride;
            }
            else
                nMultiplier = CI_MODEL_COST_PER_CHANGE_GOLD_ARMOR * (nAC + 1);
            break;
        case BASE_ITEM_CLOAK:
            nOverride = GetLocalInt(GetItemPossessor(oItem), CS_MODEL_COST_PER_CHANGE_GOLD_CLOAK_OVERRIDE);
            if (nOverride != 0)
            {
                if (nOverride == -1)
                    nMultiplier = 0;
                else
                    nMultiplier = nOverride;
            }
            else
                nMultiplier = CI_MODEL_COST_PER_CHANGE_GOLD_CLOAK;
            break;
        case BASE_ITEM_HELMET:
            nOverride = GetLocalInt(GetItemPossessor(oItem), CS_MODEL_COST_PER_CHANGE_GOLD_HELMET_OVERRIDE);
            if (nOverride != 0)
            {
                if (nOverride == -1)
                    nMultiplier = 0;
                else
                    nMultiplier = nOverride;
            }
            else
                nMultiplier = CI_MODEL_COST_PER_CHANGE_GOLD_HELMET;
            break;
        case BASE_ITEM_SMALLSHIELD:
            nOverride = GetLocalInt(GetItemPossessor(oItem), CS_MODEL_COST_PER_CHANGE_GOLD_SHIELD_OVERRIDE);
            if (nOverride != 0)
            {
                if (nOverride == -1)
                    nMultiplier = 0;
                else
                    nMultiplier = nOverride;
            }
            else
                nMultiplier = CI_MODEL_COST_PER_CHANGE_GOLD_SHIELD * 1;
            break;
        case BASE_ITEM_LARGESHIELD:
            nOverride = GetLocalInt(GetItemPossessor(oItem), CS_MODEL_COST_PER_CHANGE_GOLD_SHIELD_OVERRIDE);
            if (nOverride != 0)
            {
                if (nOverride == -1)
                    nMultiplier = 0;
                else
                    nMultiplier = nOverride;
            }
            else
                nMultiplier = CI_MODEL_COST_PER_CHANGE_GOLD_SHIELD * 2;
            break;
        case BASE_ITEM_TOWERSHIELD:
            nOverride = GetLocalInt(GetItemPossessor(oItem), CS_MODEL_COST_PER_CHANGE_GOLD_SHIELD_OVERRIDE);
            if (nOverride != 0)
            {
                if (nOverride == -1)
                    nMultiplier = 0;
                else
                    nMultiplier = nOverride;
            }
            else
                nMultiplier = CI_MODEL_COST_PER_CHANGE_GOLD_SHIELD * 3;
            break;
        default:
            nOverride = GetLocalInt(GetItemPossessor(oItem), CS_MODEL_COST_PER_CHANGE_GOLD_WEAPON_OVERRIDE);
            if (nOverride != 0)
            {
                if (nOverride == -1)
                    nMultiplier = 0;
                else
                    nMultiplier = nOverride;
            }
            else
                nMultiplier = CI_MODEL_COST_PER_CHANGE_GOLD_WEAPON;
            break;
    }

    SetLocalInt(oItem, "model_chgcost_gld", nChangeCount * nMultiplier);
    return (nChangeCount * nMultiplier);
}

int hasItemInSlot(object oCreature, int nInventorySlot, int nHasToBeShield = FALSE)
{
    object oItem = GetItemInSlot(nInventorySlot, oCreature);
    int nBase = GetBaseItemType(oItem);


    return (GetIsObjectValid(oItem) &&
            GetTag(oItem) != CS_DEF_INVISIBLEWEAPON &&
            (!nHasToBeShield ||
             nBase == BASE_ITEM_SMALLSHIELD ||
             nBase == BASE_ITEM_LARGESHIELD ||
             nBase == BASE_ITEM_TOWERSHIELD));
}

int GetIsItemPartIdentical(object oItem, int nItemType, int nIndex_A, int nIndex_B)
{

    int nItemAppearance_A = GetItemAppearance(oItem, nItemType, nIndex_A);
    int nItemAppearance_B = GetItemAppearance(oItem, nItemType, nIndex_B);

    return (nItemAppearance_A == nItemAppearance_B);
}

void SetItemSlot(object oPC, int nItemSlot, int nIsShield = FALSE)
{
    SetLocalInt(oPC, "model_SelSlot", nItemSlot + 1);
    SetLocalInt(oPC, "model_Sel_isShield", nIsShield);
}

int GetItemSlot(object oPC)
{
    return (GetLocalInt(oPC, "model_SelSlot") - 1);
}

void DeleteItemSlot(object oPC)
{
    DeleteLocalInt(oPC, "model_SelSlot");
    DeleteLocalInt(oPC, "model_Sel_isShield");
}

int GetItemSlotUsesIndex(object oPC)
{
    int nItemSlot = GetItemSlot(oPC);
    int nIsShield = GetLocalInt(oPC, "model_Sel_isShield");

    if (nItemSlot != -1 &&
        (nItemSlot == INVENTORY_SLOT_CHEST ||
         (nItemSlot == INVENTORY_SLOT_LEFTHAND && !nIsShield) ||
         nItemSlot == INVENTORY_SLOT_RIGHTHAND))
        return TRUE;

    return FALSE;
}

void SetItemIndex(object oPC, int nIndex)
{
    SetLocalInt(oPC, "model_SelIndex", nIndex + 1);
}

int GetItemIndex(object oPC)
{
    return (GetLocalInt(oPC, "model_SelIndex") - 1);
}

void DeleteItemIndex(object oPC)
{
    DeleteLocalInt(oPC, "model_SelIndex");
}

string GetPartName_Armor(int nIndex)
{
    switch (nIndex)
    {
        case ITEM_APPR_ARMOR_MODEL_BELT: return "Belt"; break;
        case ITEM_APPR_ARMOR_MODEL_LBICEP: return "Left Biceps"; break;
        case ITEM_APPR_ARMOR_MODEL_RBICEP: return "Right Biceps"; break;
        case CI_DEF_ARMOR_SAME_BICEPS: return "Both Biceps"; break;
        case ITEM_APPR_ARMOR_MODEL_LFOOT: return "Left Foot"; break;
        case ITEM_APPR_ARMOR_MODEL_RFOOT: return "Right Foot"; break;
        case CI_DEF_ARMOR_SAME_FEET: return "Both Feet"; break;
        case ITEM_APPR_ARMOR_MODEL_LFOREARM: return "Left Forearm"; break;
        case ITEM_APPR_ARMOR_MODEL_RFOREARM: return "Right Forearm"; break;
        case CI_DEF_ARMOR_SAME_FOREARMS: return "Both Forearms"; break;
        case ITEM_APPR_ARMOR_MODEL_LHAND: return "Left Hand"; break;
        case ITEM_APPR_ARMOR_MODEL_RHAND: return "Right Hand"; break;
        case CI_DEF_ARMOR_SAME_HANDS: return "Both Hands"; break;
        case ITEM_APPR_ARMOR_MODEL_NECK: return "Neck"; break;
        case ITEM_APPR_ARMOR_MODEL_PELVIS: return "Pelvis"; break;
        case ITEM_APPR_ARMOR_MODEL_ROBE: return "Robe"; break;
        case ITEM_APPR_ARMOR_MODEL_LSHIN: return "Left Shin"; break;
        case ITEM_APPR_ARMOR_MODEL_RSHIN: return "Right Shin"; break;
        case CI_DEF_ARMOR_SAME_SHINS: return "Both Shins"; break;
        case ITEM_APPR_ARMOR_MODEL_LSHOULDER: return "Left Shoulder"; break;
        case ITEM_APPR_ARMOR_MODEL_RSHOULDER: return "Right Shoulder"; break;
        case CI_DEF_ARMOR_SAME_SHOULDERS: return "Both Shoulders"; break;
        case ITEM_APPR_ARMOR_MODEL_LTHIGH: return "Left Thigh"; break;
        case ITEM_APPR_ARMOR_MODEL_RTHIGH: return "Right Thigh"; break;
        case CI_DEF_ARMOR_SAME_THIGHS: return "Both Thighs"; break;
        case ITEM_APPR_ARMOR_MODEL_TORSO: return "Torso"; break;
    }

    return "";
}

string GetPartName_Weapon(int nIndex)
{
    switch (nIndex)
    {
        case ITEM_APPR_WEAPON_MODEL_BOTTOM: return "Bottom"; break;
        case ITEM_APPR_WEAPON_MODEL_MIDDLE: return "Middle"; break;
        case ITEM_APPR_WEAPON_MODEL_TOP: return "Top"; break;
    }

    return "";
}

string GetCostText(int nGoldCost, int nColorChanges)
{
    string sDyes = CS_MODEL_DYE_NAME;
    if (nGoldCost > 0)
    {
        if (CS_MODEL_ITEM_COLORING != "" &&
            nColorChanges > 0)
            return (" (" + color_ConvertString(IntToString(nGoldCost), COLOR_YELLOW) + " gold, " + color_ConvertString(IntToString(nColorChanges), COLOR_CYAN) + " " + sDyes + ")");
        else
            return (" (" + color_ConvertString(IntToString(nGoldCost), COLOR_YELLOW) + " gold)");
    }
    else if (CS_MODEL_ITEM_COLORING != "" &&
             nColorChanges > 0)
        return (" (" + color_ConvertString(IntToString(nColorChanges), COLOR_CYAN) + " " + sDyes + ")");
    else
        return "";
}

void EquipInvisibleWeapon(object oModel)
{
    object oInvisibleWeapon = GetItemPossessedBy(oModel, CS_DEF_INVISIBLEWEAPON);
    if (!GetIsObjectValid(oInvisibleWeapon))
    {
        // Create it
        oInvisibleWeapon = CreateItemOnObject("nw_wswdg001", oModel, 1, CS_DEF_INVISIBLEWEAPON);
        SetHiddenWhenEquipped(oInvisibleWeapon, TRUE);
    }

    AssignCommand(oModel, ActionEquipItem(oInvisibleWeapon, INVENTORY_SLOT_RIGHTHAND));
}

void BuyItemAppearance(object oSource, object oTarget, int nSlot, int nDesignOnly)
{
    object oSourceItem = GetItemInSlot(nSlot, oSource);
    object oTargetItem = GetItemInSlot(nSlot, oTarget);

    // If source or target object is invalid, return
    // Also return if source item is our invisible weapon
    if (!GetIsObjectValid(oSourceItem) ||
        GetTag(oSourceItem) == CS_DEF_INVISIBLEWEAPON)
        return;

    if (!GetIsObjectValid(oTargetItem))
    {
        SendMessageToPC(oTarget, "You have no item equipped to copy the appearance of [" + color_ConvertString(GetName(oSourceItem), COLOR_GREY) + "] to.");
        return;
    }

    // Gold
    int nGoldCost = CalculateChangeCost_Gold(oSourceItem, oTargetItem);
    if (nGoldCost > GetGold(oTarget))
    {
        SendMessageToPC(oTarget, "You can't afford to buy the appearance for [" + color_ConvertString(GetName(oTargetItem), COLOR_GREY) + "].");
        return;
    }

    // Dyes
    int nth;
    if (CS_MODEL_ITEM_COLORING != "" &&
        !nDesignOnly &&                                 // No color costs when only buying the designs
        GetLocalInt(oSource, CS_MODEL_COST_NODYE) != 1)
    {
        int nColorChanges = GetColorChangeCount(oSourceItem, oTargetItem);
        int nDyeCount = 0;
        object oDye = GetFirstItemInInventory(oTarget);
        while (GetIsObjectValid(oDye) &&
               nDyeCount < nColorChanges)
        {
            if (GetTag(oDye) == CS_MODEL_ITEM_COLORING)
            {
                nDyeCount++;
                SetLocalObject(oSourceItem, "model_dyeref" + IntToString(nDyeCount), oDye);
            }

            oDye = GetNextItemInInventory(oTarget);
        }

        if (nDyeCount < nColorChanges)
        {
            SendMessageToPC(oTarget, "You do not have enough dye to color [" + GetName(oTargetItem) + "].");
            return;
        }
        else
        {
            for (nth = 1; nth <= nColorChanges; nth++)
            {
                DestroyObject(GetLocalObject(oSourceItem, "model_dyeref" + IntToString(nth)));
                DeleteLocalInt(oSourceItem, "model_dyeref" + IntToString(nth));
            }
        }
    }

    // Take gold
    TakeGoldFromCreature(nGoldCost, oTarget, TRUE);

    object oCopySource = CopyItem(oTargetItem, oSource, TRUE);
    object oCreatedItem = oCopySource;
    // Get Base Item Type and Appearance Type
    int nBaseType = GetBaseItemType(oSourceItem);
    int nAppearanceType;
    int nColorType;
    switch (nBaseType)
    {
        case BASE_ITEM_ARMOR:
        case BASE_ITEM_HELMET: nAppearanceType = ITEM_APPR_TYPE_ARMOR_MODEL; nColorType = ITEM_APPR_TYPE_ARMOR_COLOR; break;
        case BASE_ITEM_CLOAK: nAppearanceType = ITEM_APPR_TYPE_SIMPLE_MODEL; nColorType = ITEM_APPR_TYPE_ARMOR_COLOR; break;
        case BASE_ITEM_SMALLSHIELD:
        case BASE_ITEM_LARGESHIELD:
        case BASE_ITEM_TOWERSHIELD: nAppearanceType = ITEM_APPR_TYPE_SIMPLE_MODEL; break;
        default: nAppearanceType = ITEM_APPR_TYPE_WEAPON_MODEL; nColorType = ITEM_APPR_TYPE_WEAPON_COLOR; break;
    }

    // Is our TargetItem the item that was used to create oSourceItem?
    // If so, use the fast way to modify by only touching the changed parts
    if (GetLocalObject(oSourceItem, "model_ItemReference") == oTargetItem)
    {
        int nAppearanceChanges = GetChangeCount(oSourceItem, oTargetItem);
        int nColorChanges = GetColorChangeCount(oSourceItem, oTargetItem);

        // Do every appearance change
        int nIndex;
        int nAppearance;
        for (nth = 0; nth < nAppearanceChanges; nth++)
        {
            // Get the nth appearance change
            nIndex = eas_IArray_Entry_Get(oSourceItem, CS_DEF_ARRAY_CHANGES, nth);
            nAppearance = GetLocalInt(oSourceItem, CS_DEF_VAR_CHANGE + IntToString(nIndex));

            oCreatedItem = CopyItemAndModify(oCopySource, nAppearanceType, nIndex, nAppearance, TRUE);
            DestroyObject(oCopySource);
            oCopySource = oCreatedItem;
        }

        // Do every color change
        if (!nDesignOnly)
        {
            for (nth = 0; nth < nColorChanges; nth++)
            {
                // Get the nth appearance change
                nIndex = eas_IArray_Entry_Get(oSourceItem, CS_DEF_ARRAY_COLORS, nth);
                nAppearance = GetLocalInt(oSourceItem, CS_DEF_VAR_COLOR + IntToString(nIndex));

                oCreatedItem = CopyItemAndModify(oCopySource, nColorType, nIndex, nAppearance, TRUE);
                DestroyObject(oCopySource);
                oCopySource = oCreatedItem;
            }
        }

        // Put the new item into Target Item Possessor'S inventory
        object oPC = GetItemPossessor(oTargetItem);
        object oNew = CopyItem(oCreatedItem, oPC, TRUE);
        DestroyObject(oCreatedItem);
        if (nSlot == INVENTORY_SLOT_RIGHTHAND)
        {
            // Set PC uncommandable to avoid errors
            SetCommandable(FALSE, oPC);
            DelayCommand(0.2f, SetCommandable(TRUE, oPC));

            EquipInvisibleWeapon(oSource);
            DelayCommand(CF_MODEL_DELAY_DESTROYWEAPON, DestroyObject(oSourceItem));
            DelayCommand(0.1f, DestroyObject(oTargetItem));
        }
        else
        {
            DestroyObject(oSourceItem);
            DestroyObject(oTargetItem);
        }

        AssignCommand(oPC, ActionEquipItem(oNew, nSlot));
    }
    else
    {
        // If the target slot is chest, make sure the AC of both items is the same
        if (nSlot == INVENTORY_SLOT_CHEST)
        {
            int nSourceAC = StringToInt(GetStringLeft(Get2DAString("parts_chest", "ACBONUS", GetItemAppearance(oSourceItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO)), 1));
            int nTargetAC = StringToInt(GetStringLeft(Get2DAString("parts_chest", "ACBONUS", GetItemAppearance(oTargetItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO)), 1));

            if (nSourceAC != nTargetAC)
                return;
        }

        int nAppearanceChanges = GetChangeCount(oSourceItem, oTargetItem);
        int nColorChanges = GetColorChangeCount(oSourceItem, oTargetItem);

        // Do every appearance change
        int nth;
        int nIndex;
        int nAppearance;
        for (nth = 0; nth < nAppearanceChanges; nth++)
        {
            // Get the nth appearance change
            nIndex = eas_IArray_Entry_Get(oSourceItem, CS_DEF_ARRAY_CHANGES_ANALYZE, nth);
            nAppearance = GetLocalInt(oSourceItem, CS_DEF_VAR_CHANGE_ANALYZE + IntToString(nIndex));

            oCreatedItem = CopyItemAndModify(oCopySource, nAppearanceType, nIndex, nAppearance, TRUE);
            DestroyObject(oCopySource);
            oCopySource = oCreatedItem;
        }

        // Do every color change
        if (!nDesignOnly)
        {
            for (nth = 0; nth < nColorChanges; nth++)
            {
                // Get the nth appearance change
                nIndex = eas_IArray_Entry_Get(oSourceItem, CS_DEF_ARRAY_COLORS_ANALYZE, nth);
                nAppearance = GetLocalInt(oSourceItem, CS_DEF_VAR_COLOR_ANALYZE + IntToString(nIndex));

                oCreatedItem = CopyItemAndModify(oCopySource, nColorType, nIndex, nAppearance, TRUE);
                DestroyObject(oCopySource);
                oCopySource = oCreatedItem;
            }
        }

        // Put the new item into Target Item Possessor'S inventory
        object oPC = GetItemPossessor(oTargetItem);
        object oNew = CopyItem(oCreatedItem, oPC, TRUE);
        DestroyObject(oCreatedItem);
        if (nSlot == INVENTORY_SLOT_RIGHTHAND)
        {
            // Set PC uncommandable to avoid errors
            SetCommandable(FALSE, oPC);
            DelayCommand(0.2f, SetCommandable(TRUE, oPC));

            EquipInvisibleWeapon(oSource);
            DelayCommand(CF_MODEL_DELAY_DESTROYWEAPON, DestroyObject(oSourceItem));
            DelayCommand(0.1f, DestroyObject(oTargetItem));
        }
        else
        {
            DestroyObject(oSourceItem);
            DestroyObject(oTargetItem);
        }

        AssignCommand(oPC, ActionEquipItem(oNew, nSlot));
    }
}

void main()
{
   object oPC = OBJECT_SELF;
   object oNPC = GetLocalObject(oPC, CS_DLG_PC_CONVERSATIONNPC);
   int nConditional = GetLocalInt(oPC, CS_DLG_PC_CONDITIONAL_ID);
   int nAction = GetLocalInt(oPC, CS_DLG_PC_ACTION_ID);
   string sNodeText = GetLocalString(oPC, CS_DLG_PC_NODETEXT);
   object oAdditional = GetLocalObject(oPC, CS_DLG_PC_ADDITIONALOBJECT);

   int nSlot;
   int nIndex;
   int nColor;
   string sColor;
   int nGoldCost;
   int nColorChanges;
   switch (nConditional)
   {
      case -1: SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE); break;
      case CI_CONDITION_MODEL_HAS_HELMET: SetLocalInt(oPC, CS_DLG_PC_RESULT, hasItemInSlot(oNPC, INVENTORY_SLOT_HEAD)); break;
      case CI_CONDITION_MODEL_HAS_ARMOR: SetLocalInt(oPC, CS_DLG_PC_RESULT, hasItemInSlot(oNPC, INVENTORY_SLOT_CHEST)); break;
      case CI_CONDITION_MODEL_HAS_WEAPON_LEFT: SetLocalInt(oPC, CS_DLG_PC_RESULT, (hasItemInSlot(oNPC, INVENTORY_SLOT_LEFTHAND) && !hasItemInSlot(oNPC, INVENTORY_SLOT_LEFTHAND, TRUE))); break;
      case CI_CONDITION_MODEL_HAS_WEAPON_RIGHT: SetLocalInt(oPC, CS_DLG_PC_RESULT, hasItemInSlot(oNPC, INVENTORY_SLOT_RIGHTHAND)); break;
      case CI_CONDITION_MODEL_HAS_SHIELD: SetLocalInt(oPC, CS_DLG_PC_RESULT, hasItemInSlot(oNPC, INVENTORY_SLOT_LEFTHAND, TRUE)); break;
      case CI_CONDITION_MODEL_HAS_CLOAK: SetLocalInt(oPC, CS_DLG_PC_RESULT, hasItemInSlot(oNPC, INVENTORY_SLOT_CLOAK)); break;

      case CI_CONDITION_PC_HAS_CLOAK: SetLocalInt(oPC, CS_DLG_PC_RESULT, hasItemInSlot(oPC, INVENTORY_SLOT_CLOAK)); break;
      case CI_CONDITION_PC_HAS_ARMOR: SetLocalInt(oPC, CS_DLG_PC_RESULT, hasItemInSlot(oPC, INVENTORY_SLOT_CHEST)); break;
      case CI_CONDITION_PC_HAS_HELMET: SetLocalInt(oPC, CS_DLG_PC_RESULT, hasItemInSlot(oPC, INVENTORY_SLOT_HEAD)); break;
      case CI_CONDITION_PC_HAS_SHIELD: SetLocalInt(oPC, CS_DLG_PC_RESULT, hasItemInSlot(oPC, INVENTORY_SLOT_LEFTHAND, TRUE)); break;
      case CI_CONDITION_PC_HAS_WEAPON_LEFT: SetLocalInt(oPC, CS_DLG_PC_RESULT, (hasItemInSlot(oPC, INVENTORY_SLOT_LEFTHAND) && !hasItemInSlot(oPC, INVENTORY_SLOT_LEFTHAND, TRUE))); break;
      case CI_CONDITION_PC_HAS_WEAPON_RIGHT: SetLocalInt(oPC, CS_DLG_PC_RESULT, hasItemInSlot(oPC, INVENTORY_SLOT_RIGHTHAND)); break;

      case CI_CONDITION_ARMOR_SAME_BICEPS: SetLocalInt(oPC, CS_DLG_PC_RESULT, GetIsItemPartIdentical(GetItemInSlot(INVENTORY_SLOT_CHEST, oNPC), ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LBICEP, ITEM_APPR_ARMOR_MODEL_RBICEP)); break;
      case CI_CONDITION_ARMOR_SAME_FEET: SetLocalInt(oPC, CS_DLG_PC_RESULT, GetIsItemPartIdentical(GetItemInSlot(INVENTORY_SLOT_CHEST, oNPC), ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOOT, ITEM_APPR_ARMOR_MODEL_RFOOT)); break;
      case CI_CONDITION_ARMOR_SAME_FOREARMS: SetLocalInt(oPC, CS_DLG_PC_RESULT, GetIsItemPartIdentical(GetItemInSlot(INVENTORY_SLOT_CHEST, oNPC), ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOREARM, ITEM_APPR_ARMOR_MODEL_RFOREARM)); break;
      case CI_CONDITION_ARMOR_SAME_HANDS: SetLocalInt(oPC, CS_DLG_PC_RESULT, GetIsItemPartIdentical(GetItemInSlot(INVENTORY_SLOT_CHEST, oNPC), ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LHAND, ITEM_APPR_ARMOR_MODEL_RHAND)); break;
      case CI_CONDITION_ARMOR_SAME_SHINS: SetLocalInt(oPC, CS_DLG_PC_RESULT, GetIsItemPartIdentical(GetItemInSlot(INVENTORY_SLOT_CHEST, oNPC), ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHIN, ITEM_APPR_ARMOR_MODEL_RSHIN)); break;
      case CI_CONDITION_ARMOR_SAME_SHOULDERS: SetLocalInt(oPC, CS_DLG_PC_RESULT, GetIsItemPartIdentical(GetItemInSlot(INVENTORY_SLOT_CHEST, oNPC), ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHOULDER, ITEM_APPR_ARMOR_MODEL_RSHOULDER)); break;
      case CI_CONDITION_ARMOR_SAME_THIGHS: SetLocalInt(oPC, CS_DLG_PC_RESULT, GetIsItemPartIdentical(GetItemInSlot(INVENTORY_SLOT_CHEST, oNPC), ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LTHIGH, ITEM_APPR_ARMOR_MODEL_RTHIGH)); break;

      case CI_CONDITION_OVERRIDE_BUY_ALL:
         nGoldCost = CalculateChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_CLOAK, oNPC), GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC));
         nColorChanges = CalculateChangeCost_Color(GetItemInSlot(INVENTORY_SLOT_CLOAK, oNPC), GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC));
         nGoldCost += CalculateChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_CHEST, oNPC), GetItemInSlot(INVENTORY_SLOT_CHEST, oPC));
         nColorChanges += CalculateChangeCost_Color(GetItemInSlot(INVENTORY_SLOT_CHEST, oNPC), GetItemInSlot(INVENTORY_SLOT_CHEST, oPC));
         nGoldCost += CalculateChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_HEAD, oNPC), GetItemInSlot(INVENTORY_SLOT_HEAD, oPC));
         nColorChanges += CalculateChangeCost_Color(GetItemInSlot(INVENTORY_SLOT_HEAD, oNPC), GetItemInSlot(INVENTORY_SLOT_HEAD, oPC));
         nGoldCost += CalculateChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oNPC), GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC));
         nColorChanges += CalculateChangeCost_Color(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oNPC), GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC));
         if (hasItemInSlot(oNPC, INVENTORY_SLOT_RIGHTHAND))
         {
            nGoldCost += CalculateChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oNPC), GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
            nColorChanges += CalculateChangeCost_Color(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oNPC), GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
         }
         dlg_OverrideNodeText(oPC, "All" + GetCostText(nGoldCost, nColorChanges));
         SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         break;
      case CI_CONDITION_OVERRIDE_BUY_CLOAK:
         if (hasItemInSlot(oNPC, INVENTORY_SLOT_CLOAK))
         {
            nGoldCost = GetChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_CLOAK, oNPC));
            nColorChanges = CalculateChangeCost_Color(GetItemInSlot(INVENTORY_SLOT_CLOAK, oNPC), GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC));
            dlg_OverrideNodeText(oPC, "Cloak" + GetCostText(nGoldCost, nColorChanges));
            SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         }
         else
            SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
         break;
      case CI_CONDITION_OVERRIDE_BUY_ARMOR:
         if (hasItemInSlot(oNPC, INVENTORY_SLOT_CHEST))
         {
            nGoldCost = GetChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_CHEST, oNPC));
            nColorChanges = CalculateChangeCost_Color(GetItemInSlot(INVENTORY_SLOT_CHEST, oNPC), GetItemInSlot(INVENTORY_SLOT_CHEST, oPC));
            dlg_OverrideNodeText(oPC, "Armor / Clothing" + GetCostText(nGoldCost, nColorChanges));
            SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         }
         else
            SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
         break;
      case CI_CONDITION_OVERRIDE_BUY_HELMET:
         if (hasItemInSlot(oNPC, INVENTORY_SLOT_HEAD))
         {
            nGoldCost = GetChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_HEAD, oNPC));
            nColorChanges = CalculateChangeCost_Color(GetItemInSlot(INVENTORY_SLOT_HEAD, oNPC), GetItemInSlot(INVENTORY_SLOT_HEAD, oPC));
            dlg_OverrideNodeText(oPC, "Helmet" + GetCostText(nGoldCost, nColorChanges));
            SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         }
         else
            SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
         break;
      case CI_CONDITION_OVERRIDE_BUY_SHIELD:
         if (hasItemInSlot(oNPC, INVENTORY_SLOT_LEFTHAND, TRUE))
         {
            nGoldCost = GetChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oNPC));
            nColorChanges = 0; // Can't change shield colors
            dlg_OverrideNodeText(oPC, "Shield (" + color_ConvertString(IntToString(nGoldCost), COLOR_YELLOW) + " gold)");
            SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         }
         else
            SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
         break;
      case CI_CONDITION_OVERRIDE_BUY_WEAPON_LEFT:
         if (hasItemInSlot(oNPC, INVENTORY_SLOT_LEFTHAND) &&
             !hasItemInSlot(oNPC, INVENTORY_SLOT_LEFTHAND, TRUE))
         {
            nGoldCost = GetChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oNPC));
            nColorChanges = CalculateChangeCost_Color(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oNPC), GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC));
            dlg_OverrideNodeText(oPC, "Weapon (Left)" + GetCostText(nGoldCost, nColorChanges));
            SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         }
         else
            SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
         break;
      case CI_CONDITION_OVERRIDE_BUY_WEAPON_RIGHT:
         if (hasItemInSlot(oNPC, INVENTORY_SLOT_RIGHTHAND))
         {
            nGoldCost = GetChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oNPC));
            nColorChanges = CalculateChangeCost_Color(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oNPC), GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
            dlg_OverrideNodeText(oPC, "Weapon (Right)" + GetCostText(nGoldCost, nColorChanges));
            SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         }
         else
            SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
         break;

      case CI_CONDITION_OVERRIDE_BUY_DESIGN_ALL:
         nGoldCost = CalculateChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_CLOAK, oNPC), GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC));
         nGoldCost += CalculateChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_CHEST, oNPC), GetItemInSlot(INVENTORY_SLOT_CHEST, oPC));
         nGoldCost += CalculateChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_HEAD, oNPC), GetItemInSlot(INVENTORY_SLOT_HEAD, oPC));
         nGoldCost += CalculateChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oNPC), GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC));
         if (hasItemInSlot(oNPC, INVENTORY_SLOT_RIGHTHAND))
         {
            nGoldCost += CalculateChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oNPC), GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
         }
         dlg_OverrideNodeText(oPC, "All" + GetCostText(nGoldCost, nColorChanges));
         SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         break;
      case CI_CONDITION_OVERRIDE_BUY_DESIGN_CLOAK:
         if (hasItemInSlot(oNPC, INVENTORY_SLOT_CLOAK))
         {
            nGoldCost = GetChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_CLOAK, oNPC));
            dlg_OverrideNodeText(oPC, "Cloak" + GetCostText(nGoldCost, nColorChanges));
            SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         }
         else
            SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
         break;
      case CI_CONDITION_OVERRIDE_BUY_DESIGN_ARMOR:
         if (hasItemInSlot(oNPC, INVENTORY_SLOT_CHEST))
         {
            nGoldCost = GetChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_CHEST, oNPC));
            dlg_OverrideNodeText(oPC, "Armor / Clothing" + GetCostText(nGoldCost, nColorChanges));
            SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         }
         else
            SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
         break;
      case CI_CONDITION_OVERRIDE_BUY_DESIGN_HELMET:
         if (hasItemInSlot(oNPC, INVENTORY_SLOT_HEAD))
         {
            nGoldCost = GetChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_HEAD, oNPC));
            dlg_OverrideNodeText(oPC, "Helmet" + GetCostText(nGoldCost, nColorChanges));
            SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         }
         else
            SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
         break;
      case CI_CONDITION_OVERRIDE_BUY_DESIGN_SHIELD:
         if (hasItemInSlot(oNPC, INVENTORY_SLOT_LEFTHAND, TRUE))
         {
            nGoldCost = GetChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oNPC));
            nColorChanges = 0; // Can't change shield colors
            dlg_OverrideNodeText(oPC, "Shield (" + color_ConvertString(IntToString(nGoldCost), COLOR_YELLOW) + " gold)");
            SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         }
         else
            SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
         break;
      case CI_CONDITION_OVERRIDE_BUY_DESIGN_WEAPON_LEFT:
         if (hasItemInSlot(oNPC, INVENTORY_SLOT_LEFTHAND) &&
             !hasItemInSlot(oNPC, INVENTORY_SLOT_LEFTHAND, TRUE))
         {
            nGoldCost = GetChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oNPC));
            dlg_OverrideNodeText(oPC, "Weapon (Left)" + GetCostText(nGoldCost, nColorChanges));
            SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         }
         else
            SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
         break;
      case CI_CONDITION_OVERRIDE_BUY_DESIGN_WEAPON_RIGHT:
         if (hasItemInSlot(oNPC, INVENTORY_SLOT_RIGHTHAND))
         {
            nGoldCost = GetChangeCost_Gold(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oNPC));
            dlg_OverrideNodeText(oPC, "Weapon (Right)" + GetCostText(nGoldCost, nColorChanges));
            SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         }
         else
            SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
         break;

      case CI_CONDITION_OVERRIDE_CHANGE_ITEM:
         nSlot = GetItemSlot(oPC);
         if (nSlot != -1)
         {
            nIndex = GetItemIndex(oPC);
            if (nIndex == -1 ||
                nIndex == CI_DEF_ARMOR_ALL)
                dlg_OverrideNodeText(oPC, "What do you want to do with [" + color_ConvertString(GetStringByStrRef(StringToInt(Get2DAString("baseitems", "Name", GetBaseItemType(GetItemInSlot(nSlot, oNPC))))), COLOR_ORANGE) + "]?");
            else if (GetItemSlot(oPC) == INVENTORY_SLOT_CHEST)
                dlg_OverrideNodeText(oPC, "What do you want to do with [" + color_ConvertString(GetPartName_Armor(GetItemIndex(oPC)), COLOR_GREY) + "] of [" + color_ConvertString(GetStringByStrRef(StringToInt(Get2DAString("baseitems", "Name", GetBaseItemType(GetItemInSlot(nSlot, oNPC))))), COLOR_ORANGE) + "]?");
            else
                dlg_OverrideNodeText(oPC, "What do you want to do with [" + color_ConvertString(GetPartName_Weapon(GetItemIndex(oPC)), COLOR_GREY) + "] of [" + color_ConvertString(GetStringByStrRef(StringToInt(Get2DAString("baseitems", "Name", GetBaseItemType(GetItemInSlot(nSlot, oNPC))))), COLOR_ORANGE) + "]?");
            SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         }
         else
            SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
         break;
      case CI_CONDITION_OVERRIDE_REMOVE_ITEM:
         nSlot = GetItemSlot(oPC);
         dlg_OverrideNodeText(oPC, "Remove [" + color_ConvertString(GetStringByStrRef(StringToInt(Get2DAString("baseitems", "Name", GetBaseItemType(GetItemInSlot(nSlot, oNPC))))), COLOR_ORANGE) + "] from Model");
         SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         break;
      case CI_CONDITION_SELECTED_NOT_SHIELD: SetLocalInt(oPC, CS_DLG_PC_RESULT, !GetLocalInt(oPC, "model_Sel_isShield")); break;
      case CI_CONDITION_SELECTED_NO_INDEX: SetLocalInt(oPC, CS_DLG_PC_RESULT, !GetItemSlotUsesIndex(oPC)); break;
      case CI_CONDITION_SELECTED_INDEX: SetLocalInt(oPC, CS_DLG_PC_RESULT, GetItemSlotUsesIndex(oPC)); break;
      case CI_CONDITION_SELECTED_ARMOR: SetLocalInt(oPC, CS_DLG_PC_RESULT, GetItemSlot(oPC) == INVENTORY_SLOT_CHEST); break;
      case CI_CONDITION_SELECTED_WEAPON_LEFT: SetLocalInt(oPC, CS_DLG_PC_RESULT, GetItemSlot(oPC) == INVENTORY_SLOT_LEFTHAND && !GetLocalInt(oPC, "model_Sel_isShield")); break;
      case CI_CONDITION_SELECTED_WEAPON_RIGHT: SetLocalInt(oPC, CS_DLG_PC_RESULT, GetItemSlot(oPC) == INVENTORY_SLOT_RIGHTHAND); break;
      case CI_CONDITION_SELECTED_WEAPON: SetLocalInt(oPC, CS_DLG_PC_RESULT, GetItemSlot(oPC) == INVENTORY_SLOT_RIGHTHAND || (GetItemSlot(oPC) == INVENTORY_SLOT_LEFTHAND && !GetLocalInt(oPC, "model_Sel_isShield"))); break;
      case CI_CONDITION_SELECTED_NOWEAPON: SetLocalInt(oPC, CS_DLG_PC_RESULT, GetItemSlot(oPC) != INVENTORY_SLOT_RIGHTHAND && (GetItemSlot(oPC) != INVENTORY_SLOT_LEFTHAND || GetLocalInt(oPC, "model_Sel_isShield"))); break;
      case CI_CONDITION_SELECTED_ARMOR_PART_ALL: SetLocalInt(oPC, CS_DLG_PC_RESULT, GetItemIndex(oPC) == CI_DEF_ARMOR_ALL); break;
      case CI_CONDITION_NOTSELECTED_ARMOR_PART_ALL: SetLocalInt(oPC, CS_DLG_PC_RESULT, GetItemIndex(oPC) != CI_DEF_ARMOR_ALL); break;
      case CI_CONDITION_COLOR_WEAPON:
         nIndex = GetItemIndex(oPC);
         switch (nIndex)
         {
             case ITEM_APPR_WEAPON_MODEL_BOTTOM: nIndex = ITEM_APPR_WEAPON_COLOR_BOTTOM; break;
             case ITEM_APPR_WEAPON_MODEL_MIDDLE: nIndex = ITEM_APPR_WEAPON_COLOR_MIDDLE; break;
             case ITEM_APPR_WEAPON_MODEL_TOP: nIndex = ITEM_APPR_WEAPON_COLOR_TOP; break;
         }

         nColor = GetItemAppearance(GetItemInSlot(GetItemSlot(oPC), oNPC), ITEM_APPR_TYPE_WEAPON_COLOR, nIndex);
         if (IntToString(nColor) == GetStringRight(sNodeText, 1))
            dlg_OverrideNodeText(oPC, color_ConvertString(sNodeText, COLOR_GREEN));
         SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         break;
      case CI_CONDITION_SELECTED_NOWEAPON_OVERRIDE_COLOR:
         SetLocalInt(oPC, CS_DLG_PC_RESULT, GetItemSlot(oPC) != INVENTORY_SLOT_RIGHTHAND && (GetItemSlot(oPC) != INVENTORY_SLOT_LEFTHAND || GetLocalInt(oPC, "model_Sel_isShield")));
         if (GetLocalInt(oNPC, "Color_LastSelected") -1 != -1)   // Cheat to get the correct color after the PC selected a color
         {
            if (GetLocalInt(oPC, "model_SelColTypeMetal") == TRUE) // Metal color
                sColor = GetColorName(CI_DEF_COLOR_INDEX_METAL, GetLocalInt(oNPC, "Color_LastSelected") -1);
            else
                sColor = GetColorName(CI_DEF_COLOR_INDEX_CLOTHLEATHER, GetLocalInt(oNPC, "Color_LastSelected") -1);
            DeleteLocalInt(oNPC, "Color_LastSelected");
         }
         else
         {
             nIndex = GetItemIndex(oPC);
             switch (nIndex)
             {
                case CI_DEF_ARMOR_ALL:
                   nColor = GetItemAppearance(GetItemInSlot(GetItemSlot(oPC), oNPC), ITEM_APPR_TYPE_ARMOR_COLOR, GetColorType(oPC));
                   break;
                default:
                   nColor = GetItemAppearance(GetItemInSlot(GetItemSlot(oPC), oNPC), ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_NUM_COLORS + (nIndex * ITEM_APPR_ARMOR_NUM_COLORS) + GetColorType(oPC));
                   break;
             }
             if (GetLocalInt(oPC, "model_SelColTypeMetal") == TRUE) // Metal color
                sColor = GetColorName(CI_DEF_COLOR_INDEX_METAL, nColor);
             else
                sColor = GetColorName(CI_DEF_COLOR_INDEX_CLOTHLEATHER, nColor);
         }
         dlg_OverrideNodeText(oPC, "Choose a color [Current: " + color_ConvertString(sColor, COLOR_GREEN) + "]");
         break;
      case CI_CONDITION_COLOR_NONMETAL:
         nIndex = GetItemIndex(oPC);
         switch (nIndex)
         {
            case CI_DEF_ARMOR_ALL:
               nColor = GetItemAppearance(GetItemInSlot(GetItemSlot(oPC), oNPC), ITEM_APPR_TYPE_ARMOR_COLOR, GetColorType(oPC));
               break;
            default:
               nColor = GetItemAppearance(GetItemInSlot(GetItemSlot(oPC), oNPC), ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_NUM_COLORS + (nIndex * ITEM_APPR_ARMOR_NUM_COLORS) + GetColorType(oPC));
               break;
         }
         sColor = GetColorName(CI_DEF_COLOR_INDEX_CLOTHLEATHER, nColor);
         if (sColor == sNodeText)
            dlg_OverrideNodeText(oPC, color_ConvertString(sNodeText, COLOR_GREEN));
         SetLocalInt(oPC, CS_DLG_PC_RESULT, !GetLocalInt(oPC, "model_SelColTypeMetal")); break;
      case CI_CONDITION_COLOR_METAL:
         nIndex = GetItemIndex(oPC);
         switch (nIndex)
         {
            case CI_DEF_ARMOR_ALL:
               nColor = GetItemAppearance(GetItemInSlot(GetItemSlot(oPC), oNPC), ITEM_APPR_TYPE_ARMOR_COLOR, GetColorType(oPC));
               break;
            default:
               nColor = GetItemAppearance(GetItemInSlot(GetItemSlot(oPC), oNPC), ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_NUM_COLORS + (nIndex * ITEM_APPR_ARMOR_NUM_COLORS) + GetColorType(oPC));
               break;
         }
         sColor = GetColorName(CI_DEF_COLOR_INDEX_METAL, nColor);
         if (sColor == sNodeText)
            dlg_OverrideNodeText(oPC, color_ConvertString(sNodeText, COLOR_GREEN));
         SetLocalInt(oPC, CS_DLG_PC_RESULT, GetLocalInt(oPC, "model_SelColTypeMetal")); break;
      case CI_CONDITION_COLOR_TYPE_NOTSELECTED: SetLocalInt(oPC, CS_DLG_PC_RESULT, GetColorType(oPC) == -1); break;
      case CI_CONDITION_SELECTED_ARMORPART_SPECIFIC: SetLocalInt(oPC, CS_DLG_PC_RESULT, GetItemIndex(oPC) < CI_DEF_ARMOR_ALL && GetItemSlot(oPC) == INVENTORY_SLOT_CHEST); break;
      case CI_CONDITION_NOTSELECTED_ARMORPART_SPECIFIC: SetLocalInt(oPC, CS_DLG_PC_RESULT, GetItemIndex(oPC) == CI_DEF_ARMOR_ALL || GetItemSlot(oPC) != INVENTORY_SLOT_CHEST); break;
   }

   // Actions
   if (nAction >= CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_CLOTHLEATHER &&
       nAction <= CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_CLOTHLEATHER + 175)
   {
      nIndex = GetItemIndex(oPC);
      if (nIndex < CI_DEF_ARMOR_ALL)
         ChangeArmorColor(oNPC, GetItemSlot(oPC), nIndex, nAction - CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_CLOTHLEATHER, GetColorType(oPC));
      else
      {
          switch (nIndex)
          {
             case CI_DEF_ARMOR_ALL: ChangeArmorColor(oNPC, GetItemSlot(oPC), GetColorType(oPC), nAction - CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_CLOTHLEATHER); break;
             default: ChangeArmorColor(oNPC, GetItemSlot(oPC), ITEM_APPR_ARMOR_NUM_COLORS + (nIndex * ITEM_APPR_ARMOR_NUM_COLORS) + GetColorType(oPC), nAction - CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_CLOTHLEATHER); break;
          }
      }
      return;
   }
   else if (nAction >= CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_METAL &&
       nAction <= CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_METAL + 175)
   {
      nIndex = GetItemIndex(oPC);
      if (nIndex < CI_DEF_ARMOR_ALL)
         ChangeArmorColor(oNPC, GetItemSlot(oPC), nIndex, nAction - CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_METAL, GetColorType(oPC));
      else
      {
          switch (nIndex)
          {
             case CI_DEF_ARMOR_ALL: ChangeArmorColor(oNPC, GetItemSlot(oPC), GetColorType(oPC), nAction - CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_METAL); break;
             default: ChangeArmorColor(oNPC, GetItemSlot(oPC), ITEM_APPR_ARMOR_NUM_COLORS + (nIndex * ITEM_APPR_ARMOR_NUM_COLORS) + GetColorType(oPC), nAction - CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_METAL); break;
          }
      }
      return;
   }

   object oItem;
   switch (nAction)
   {
      case -1: break;
      case CI_ACTION_MODEL_INITIALIZE:
         if (!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oNPC)))
            EquipInvisibleWeapon(oNPC);
         break;
      case CI_ACTION_MODEL_CLONE_APPEARANCE: SetCreatureAppearanceType(oNPC, GetAppearanceType(oPC)); break;
      case CI_ACTION_MODEL_CHANGE_HELMET: SetItemSlot(oPC, INVENTORY_SLOT_HEAD); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR: SetItemSlot(oPC, INVENTORY_SLOT_CHEST); break;
      case CI_ACTION_MODEL_CHANGE_WEAPON_LEFT: SetItemSlot(oPC, INVENTORY_SLOT_LEFTHAND); break;
      case CI_ACTION_MODEL_CHANGE_WEAPON_RIGHT: SetItemSlot(oPC, INVENTORY_SLOT_RIGHTHAND); break;
      case CI_ACTION_MODEL_CHANGE_SHIELD: SetItemSlot(oPC, INVENTORY_SLOT_LEFTHAND, TRUE); break;
      case CI_ACTION_MODEL_CHANGE_CLOAK: SetItemSlot(oPC, INVENTORY_SLOT_CLOAK); break;

      case CI_ACTION_APPEARANCE_TYPE_DWARF: SetCreatureAppearanceType(oNPC, APPEARANCE_TYPE_DWARF); break;
      case CI_ACTION_APPEARANCE_TYPE_ELF: SetCreatureAppearanceType(oNPC, APPEARANCE_TYPE_ELF); break;
      case CI_ACTION_APPEARANCE_TYPE_GNOME: SetCreatureAppearanceType(oNPC, APPEARANCE_TYPE_GNOME); break;
      case CI_ACTION_APPEARANCE_TYPE_HALFELF: SetCreatureAppearanceType(oNPC, APPEARANCE_TYPE_HALF_ELF); break;
      case CI_ACTION_APPEARANCE_TYPE_HALFLING: SetCreatureAppearanceType(oNPC, APPEARANCE_TYPE_HALFLING); break;
      case CI_ACTION_APPEARANCE_TYPE_HALFORC: SetCreatureAppearanceType(oNPC, APPEARANCE_TYPE_HALF_ORC); break;
      case CI_ACTION_APPEARANCE_TYPE_HUMAN: SetCreatureAppearanceType(oNPC, APPEARANCE_TYPE_HUMAN); break;

      case CI_ACTION_MODEL_CHANGE_ARMOR_BELT: SetItemIndex(oPC, ITEM_APPR_ARMOR_MODEL_BELT); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_BICEPS_LEFT: SetItemIndex(oPC, ITEM_APPR_ARMOR_MODEL_LBICEP); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_BICEPS_RIGHT: SetItemIndex(oPC, ITEM_APPR_ARMOR_MODEL_RBICEP); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_BICEPS_BOTH: SetItemIndex(oPC, CI_DEF_ARMOR_SAME_BICEPS); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_FOOT_LEFT: SetItemIndex(oPC, ITEM_APPR_ARMOR_MODEL_LFOOT); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_FOOT_RIGHT: SetItemIndex(oPC, ITEM_APPR_ARMOR_MODEL_RFOOT); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_FOOT_BOTH: SetItemIndex(oPC, CI_DEF_ARMOR_SAME_FEET); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_FOREARM_LEFT: SetItemIndex(oPC, ITEM_APPR_ARMOR_MODEL_LFOREARM); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_FOREARM_RIGHT: SetItemIndex(oPC, ITEM_APPR_ARMOR_MODEL_RFOREARM); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_FOREARM_BOTH: SetItemIndex(oPC, CI_DEF_ARMOR_SAME_FOREARMS); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_HAND_LEFT: SetItemIndex(oPC, ITEM_APPR_ARMOR_MODEL_LHAND); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_HAND_RIGHT: SetItemIndex(oPC, ITEM_APPR_ARMOR_MODEL_RHAND); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_HAND_BOTH: SetItemIndex(oPC, CI_DEF_ARMOR_SAME_HANDS); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_NECK: SetItemIndex(oPC, ITEM_APPR_ARMOR_MODEL_NECK); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_PELVIS: SetItemIndex(oPC, ITEM_APPR_ARMOR_MODEL_PELVIS); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_ROBE: SetItemIndex(oPC, ITEM_APPR_ARMOR_MODEL_ROBE); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_SHIN_LEFT: SetItemIndex(oPC, ITEM_APPR_ARMOR_MODEL_LSHIN); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_SHIN_RIGHT: SetItemIndex(oPC, ITEM_APPR_ARMOR_MODEL_RSHIN); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_SHIN_BOTH: SetItemIndex(oPC, CI_DEF_ARMOR_SAME_SHINS); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_SHOULDER_LEFT: SetItemIndex(oPC, ITEM_APPR_ARMOR_MODEL_LSHOULDER); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_SHOULDER_RIGHT: SetItemIndex(oPC, ITEM_APPR_ARMOR_MODEL_RSHOULDER); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_SHOULDER_BOTH: SetItemIndex(oPC, CI_DEF_ARMOR_SAME_SHOULDERS); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_THIGH_LEFT: SetItemIndex(oPC, ITEM_APPR_ARMOR_MODEL_LTHIGH); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_THIGH_RIGHT: SetItemIndex(oPC, ITEM_APPR_ARMOR_MODEL_RTHIGH); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_THIGH_BOTH: SetItemIndex(oPC, CI_DEF_ARMOR_SAME_THIGHS); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_TORSO: SetItemIndex(oPC, ITEM_APPR_ARMOR_MODEL_TORSO); break;
      case CI_ACTION_MODEL_CHANGE_ARMOR_ALL: SetItemIndex(oPC, CI_DEF_ARMOR_ALL); break;

      case CI_ACTION_MODEL_CHANGE_WEAPON_BOTTOM: SetItemIndex(oPC, ITEM_APPR_WEAPON_MODEL_BOTTOM); break;
      case CI_ACTION_MODEL_CHANGE_WEAPON_MIDDLE: SetItemIndex(oPC, ITEM_APPR_WEAPON_MODEL_MIDDLE); break;
      case CI_ACTION_MODEL_CHANGE_WEAPON_TOP: SetItemIndex(oPC, ITEM_APPR_WEAPON_MODEL_TOP); break;

      case CI_ACTION_MODEL_COPY_ALL:
         CopyItemToModel(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC), oNPC, INVENTORY_SLOT_CLOAK);
         CopyItemToModel(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC), oNPC, INVENTORY_SLOT_CHEST);
         CopyItemToModel(GetItemInSlot(INVENTORY_SLOT_HEAD, oPC), oNPC, INVENTORY_SLOT_HEAD);
         CopyItemToModel(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC), oNPC, INVENTORY_SLOT_LEFTHAND);
         CopyItemToModel(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC), oNPC, INVENTORY_SLOT_RIGHTHAND);
         break;
      case CI_ACTION_MODEL_COPY_CLOAK: CopyItemToModel(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC), oNPC, INVENTORY_SLOT_CLOAK); break;
      case CI_ACTION_MODEL_COPY_ARMOR: CopyItemToModel(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC), oNPC, INVENTORY_SLOT_CHEST); break;
      case CI_ACTION_MODEL_COPY_HELMET: CopyItemToModel(GetItemInSlot(INVENTORY_SLOT_HEAD, oPC), oNPC, INVENTORY_SLOT_HEAD); break;
      case CI_ACTION_MODEL_COPY_SHIELD: CopyItemToModel(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC), oNPC, INVENTORY_SLOT_LEFTHAND); break;
      case CI_ACTION_MODEL_COPY_WEAPON_LEFT: CopyItemToModel(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC), oNPC, INVENTORY_SLOT_LEFTHAND); break;
      case CI_ACTION_MODEL_COPY_WEAPON_RIGHT: CopyItemToModel(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC), oNPC, INVENTORY_SLOT_RIGHTHAND); break;

      case CI_ACTION_MODEL_SELECT_COLOR_ARMOR_CLOTH1: SetColorType(oPC, ITEM_APPR_ARMOR_COLOR_CLOTH1); break;
      case CI_ACTION_MODEL_SELECT_COLOR_ARMOR_CLOTH2: SetColorType(oPC, ITEM_APPR_ARMOR_COLOR_CLOTH2); break;
      case CI_ACTION_MODEL_SELECT_COLOR_ARMOR_LEATHER1: SetColorType(oPC, ITEM_APPR_ARMOR_COLOR_LEATHER1); break;
      case CI_ACTION_MODEL_SELECT_COLOR_ARMOR_LEATHER2: SetColorType(oPC, ITEM_APPR_ARMOR_COLOR_LEATHER2); break;
      case CI_ACTION_MODEL_SELECT_COLOR_ARMOR_METAL1: SetColorType(oPC, ITEM_APPR_ARMOR_COLOR_METAL1); break;
      case CI_ACTION_MODEL_SELECT_COLOR_ARMOR_METAL2: SetColorType(oPC, ITEM_APPR_ARMOR_COLOR_METAL2); break;

      case CI_ACTION_COLOR_WEAPON_1: ChangeWeaponColor(oNPC, GetItemSlot(oPC), GetItemIndex(oPC), 1); break;
      case CI_ACTION_COLOR_WEAPON_2: ChangeWeaponColor(oNPC, GetItemSlot(oPC), GetItemIndex(oPC), 2); break;
      case CI_ACTION_COLOR_WEAPON_3: ChangeWeaponColor(oNPC, GetItemSlot(oPC), GetItemIndex(oPC), 3); break;
      case CI_ACTION_COLOR_WEAPON_4: ChangeWeaponColor(oNPC, GetItemSlot(oPC), GetItemIndex(oPC), 4); break;

      case CI_ACTION_BUY_ALL:
         BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_CLOAK, FALSE);
         BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_CHEST, FALSE);
         BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_HEAD, FALSE);
         BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_LEFTHAND, FALSE);
         BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_RIGHTHAND, FALSE);
         break;
      case CI_ACTION_BUY_CLOAK: BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_CLOAK, FALSE); break;
      case CI_ACTION_BUY_ARMOR: BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_CHEST, FALSE); break;
      case CI_ACTION_BUY_HELMET: BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_HEAD, FALSE); break;
      case CI_ACTION_BUY_SHIELD: BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_LEFTHAND, FALSE); break;
      case CI_ACTION_BUY_WEAPON_LEFT: BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_LEFTHAND, FALSE); break;
      case CI_ACTION_BUY_WEAPON_RIGHT: BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_RIGHTHAND, FALSE); break;

      case CI_ACTION_BUY_DESIGN_ALL:
         BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_CLOAK, TRUE);
         BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_CHEST, TRUE);
         BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_HEAD, TRUE);
         BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_LEFTHAND, TRUE);
         BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_RIGHTHAND, TRUE);
         break;
      case CI_ACTION_BUY_DESIGN_CLOAK: BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_CLOAK, TRUE); break;
      case CI_ACTION_BUY_DESIGN_ARMOR: BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_CHEST, TRUE); break;
      case CI_ACTION_BUY_DESIGN_HELMET: BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_HEAD, TRUE); break;
      case CI_ACTION_BUY_DESIGN_SHIELD: BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_LEFTHAND, TRUE); break;
      case CI_ACTION_BUY_DESIGN_WEAPON_LEFT: BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_LEFTHAND, TRUE); break;
      case CI_ACTION_BUY_DESIGN_WEAPON_RIGHT: BuyItemAppearance(oNPC, oPC, INVENTORY_SLOT_RIGHTHAND, TRUE); break;

      case CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_NEXT:
         nIndex = GetItemIndex(oPC);
         if (nIndex < CI_DEF_ARMOR_ALL)
         {
            nColor = GetItemAppearance(GetItemInSlot(GetItemSlot(oPC), oNPC), ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_NUM_COLORS + (nIndex * ITEM_APPR_ARMOR_NUM_COLORS) + GetColorType(oPC));
            nColor++;
            if (nColor > 175)
                nColor = 0;
            ChangeArmorColor(oNPC, GetItemSlot(oPC), nIndex, nColor, GetColorType(oPC));
         }
         else
         {
             switch (nIndex)
             {
                case CI_DEF_ARMOR_ALL:
                   nColor = GetItemAppearance(GetItemInSlot(GetItemSlot(oPC), oNPC), ITEM_APPR_TYPE_ARMOR_COLOR, GetColorType(oPC));
                   nColor++;
                   if (nColor > 175)
                      nColor = 0;
                   ChangeArmorColor(oNPC, GetItemSlot(oPC), GetColorType(oPC), nColor); break;
                default:
                   nColor = GetItemAppearance(GetItemInSlot(GetItemSlot(oPC), oNPC), ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_NUM_COLORS + (nIndex * ITEM_APPR_ARMOR_NUM_COLORS) + GetColorType(oPC));
                   nColor++;
                   if (nColor > 175)
                      nColor = 0;
                   ChangeArmorColor(oNPC, GetItemSlot(oPC), ITEM_APPR_ARMOR_NUM_COLORS + (nIndex * ITEM_APPR_ARMOR_NUM_COLORS) + GetColorType(oPC), nColor); break;
             }
         }
         break;
      case CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_PREVIOUS:
         nIndex = GetItemIndex(oPC);
         if (nIndex < CI_DEF_ARMOR_ALL)
         {
            nColor = GetItemAppearance(GetItemInSlot(GetItemSlot(oPC), oNPC), ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_NUM_COLORS + (nIndex * ITEM_APPR_ARMOR_NUM_COLORS) + GetColorType(oPC));
            nColor--;
            if (nColor < 0)
                nColor = 175;
            ChangeArmorColor(oNPC, GetItemSlot(oPC), nIndex, nColor, GetColorType(oPC));
         }
         else
         {
             switch (nIndex)
             {
                case CI_DEF_ARMOR_ALL:
                   nColor = GetItemAppearance(GetItemInSlot(GetItemSlot(oPC), oNPC), ITEM_APPR_TYPE_ARMOR_COLOR, GetColorType(oPC));
                   nColor--;
                   if (nColor < 0)
                      nColor = 175;
                   ChangeArmorColor(oNPC, GetItemSlot(oPC), GetColorType(oPC), nColor); break;
                default:
                   nColor = GetItemAppearance(GetItemInSlot(GetItemSlot(oPC), oNPC), ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_NUM_COLORS + (nIndex * ITEM_APPR_ARMOR_NUM_COLORS) + GetColorType(oPC));
                   nColor--;
                   if (nColor < 0)
                      nColor = 175;
                   ChangeArmorColor(oNPC, GetItemSlot(oPC), ITEM_APPR_ARMOR_NUM_COLORS + (nIndex * ITEM_APPR_ARMOR_NUM_COLORS) + GetColorType(oPC), nColor); break;
             }
         }
         break;
      case CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_ORIGINAL:
         nIndex = GetItemIndex(oPC);
         if (nIndex < CI_DEF_ARMOR_ALL)
         {
            nColor = GetLocalInt(GetItemInSlot(GetItemSlot(oPC), oNPC), CS_DEF_VAR_COLOR_ORIGINAL + IntToString(ITEM_APPR_ARMOR_NUM_COLORS + (nIndex * ITEM_APPR_ARMOR_NUM_COLORS) + GetColorType(oPC))) - 1;
            if (nColor != -1)
               ChangeArmorColor(oNPC, GetItemSlot(oPC), nIndex, nColor, GetColorType(oPC));
         }
         else
         {
             switch (nIndex)
             {
                case CI_DEF_ARMOR_ALL:
                   nColor = GetLocalInt(GetItemInSlot(GetItemSlot(oPC), oNPC), CS_DEF_VAR_COLOR_ORIGINAL + IntToString(GetColorType(oPC))) - 1;
                   if (nColor != -1)
                      ChangeArmorColor(oNPC, GetItemSlot(oPC), GetColorType(oPC), nColor); break;
                default:
                   nColor = GetLocalInt(GetItemInSlot(GetItemSlot(oPC), oNPC), CS_DEF_VAR_COLOR_ORIGINAL + IntToString(ITEM_APPR_ARMOR_NUM_COLORS + (nIndex * ITEM_APPR_ARMOR_NUM_COLORS) + GetColorType(oPC))) - 1;
                   if (nColor != -1)
                      ChangeArmorColor(oNPC, GetItemSlot(oPC), ITEM_APPR_ARMOR_NUM_COLORS + (nIndex * ITEM_APPR_ARMOR_NUM_COLORS) + GetColorType(oPC), nColor); break;
             }
         }
         break;

      /* Unused
      case CI_ACTION_MODEL_REMOVE_ITEM:
         if (GetItemSlot(oPC) == INVENTORY_SLOT_RIGHTHAND)
         {
            oItem = GetItemInSlot(GetItemSlot(oPC), oNPC);
            EquipInvisibleWeapon(oNPC);
            DelayCommand(CF_MODEL_DELAY_DESTROYWEAPON, DestroyObject(oItem));
         }
         else
            DestroyObject(GetItemInSlot(GetItemSlot(oPC), oNPC));
         DeleteItemSlot(oPC);
         break;
      */

      case CI_ACTION_MODEL_REMOVE_ALL:
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_CLOAK, oNPC));
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_CHEST, oNPC));
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_HEAD, oNPC));
         DestroyObject(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oNPC));
         oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oNPC);
         if (GetTag(oItem) != CS_DEF_INVISIBLEWEAPON)
         {
            EquipInvisibleWeapon(oNPC);
            DelayCommand(CF_MODEL_DELAY_DESTROYWEAPON, DestroyObject(oItem));
         }
         break;
      case CI_ACTION_MODEL_REMOVE_CLOAK: DestroyObject(GetItemInSlot(INVENTORY_SLOT_CLOAK, oNPC)); break;
      case CI_ACTION_MODEL_REMOVE_ARMOR: DestroyObject(GetItemInSlot(INVENTORY_SLOT_CHEST, oNPC)); break;
      case CI_ACTION_MODEL_REMOVE_HELMET: DestroyObject(GetItemInSlot(INVENTORY_SLOT_HEAD, oNPC)); break;
      case CI_ACTION_MODEL_REMOVE_SHIELD: DestroyObject(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oNPC)); break;
      case CI_ACTION_MODEL_REMOVE_WEAPON_LEFT: DestroyObject(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oNPC)); break;
      case CI_ACTION_MODEL_REMOVE_WEAPON_RIGHT:
         oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oNPC);
         EquipInvisibleWeapon(oNPC);
         DelayCommand(CF_MODEL_DELAY_DESTROYWEAPON, DestroyObject(oItem));
         break;

      case CI_ACTION_MODEL_APPEARANCE_NEXT: ChangeItemAppearance(oNPC, GetItemSlot(oPC), GetItemIndex(oPC), 1); break;
      case CI_ACTION_MODEL_APPEARANCE_PREVIOUS: ChangeItemAppearance(oNPC, GetItemSlot(oPC), GetItemIndex(oPC), -1); break;

      case CI_ACTION_REMOVE_SELECTION_ITEM: DeleteItemSlot(oPC); DeleteItemIndex(oPC); break;
      case CI_ACTION_REMOVE_SELECTION_INDEX: DeleteItemIndex(oPC); break;

      case CI_ACTION_REMOVE_COLOR_TYPE: DeleteColorType(oPC); break;

      case CI_ACTION_MODEL_REMOVE_INDIVIDUAL_COLOR:
         nIndex = GetItemIndex(oPC);
         if (nIndex < CI_DEF_ARMOR_ALL)
         {
            ChangeArmorColor(oNPC, GetItemSlot(oPC), nIndex, 255, GetColorType(oPC));
         }
         else
            ChangeArmorColor(oNPC, GetItemSlot(oPC), ITEM_APPR_ARMOR_NUM_COLORS + (GetItemIndex(oPC) * ITEM_APPR_ARMOR_NUM_COLORS) + GetColorType(oPC), 255);
         break;
   }
}

