/************************************************************************
 * script name  : esm_inc
 * created by   : eyesolated
 * date         : 2018/4/15
 *
 * description  : The central include file for eyesolated spell macros
 *
 * changes      : 2018/4/15 - eyesolated - Initial creation
 ************************************************************************/

// Includes
#include "eas_inc"
#include "color_inc"
#include "esm_cfg"

// Function Declarations

// OnActivateItem Code for ESM. Call in your module's OnItemActivated event.
void esm_OnActivateItem(object oActivator, object oActivated, object oTarget, location lTargetLocation);
string esm_GetSpellName(int nSpell);
void esm_Recording_Start(object oPC, object oMacroItem = OBJECT_INVALID);
void esm_OnPlayerChat(object oPC, string sMessage);
void esm_Recording_Stop(object oPC, object oMacroItem);
void esm_ExecuteMacro(object oPC, object oMacro, object oTarget, location lLocation);
int esm_IsRecording(object oPC);
void esm_AddSpell_Temporary_PC(object oPC, int nSpell, int nMetaMagic);

// Function Code
string esm_GetSpellName(int nSpell)
{
    string sReturn = color_ConvertString(GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", nSpell))), COLOR_CYAN);
    return sReturn;
}

int esm_Spell_CanBeCastOnCreatures(int nSpell)
{
    int nSpellTargetType = StringToInt(GetStringRight(Get2DAString("spells", "TargetType", nSpell), 2));
    return ((nSpellTargetType & 2) != 0);
}

void esm_Recording_Start(object oPC, object oMacroItem = OBJECT_INVALID)
{
    // Set Recording TRUE
    SetLocalInt(oPC, ESM_VAR_RECORDING, ESM_RECORDING_ENABLED);

    // (re)Create the temporary arrays on the PC
    eas_Array_Delete(oPC, ESM_ARRAY_TEMP, TRUE);
    eas_Array_Delete(oPC, ESM_ARRAY_TEMP_METAMAGIC, TRUE);
    eas_Array_Create(oPC, ESM_ARRAY_TEMP, EAS_ARRAY_TYPE_INTEGER);
    eas_Array_Create(oPC, ESM_ARRAY_TEMP_METAMAGIC, EAS_ARRAY_TYPE_INTEGER);

    // Remember current Tag
    SetLocalString(oMacroItem, ESM_VAR_ORIGINALTAG, GetTag(oMacroItem));

    // Set Recording Tag
    SetTag(oMacroItem, ESM_ITEMTAG_RECORDING);

    // Inform the PC
    SendMessageToPC(oPC, "Recording started, please cast your spells and then use this item again. While recording, typing in chat will set the Name for your Macro item. Setting the name to 'cancel' will prevent saving the Macro.");
}

void esm_OnPlayerChat(object oPC, string sMessage)
{
    if (GetLocalInt(oPC, ESM_VAR_RECORDING))
    {
        SetLocalString(oPC, ESM_VAR_MACRONAME, sMessage);
        SendMessageToPC(oPC, "Spell Macro Name is now [" + sMessage + "]");
        if (GetStringLowerCase(sMessage) == "cancel")
        {
            SendMessageToPC(oPC, "Your Macro will not be saved when using the item again.");
        }
        SetPCChatMessage("");
    }
}

int esm_SaveMacro(object oPC, object oTarget)
{
    int nSpells = eas_Array_GetSize(oPC, ESM_ARRAY_TEMP);

    if (nSpells == 0 ||
        !GetIsObjectValid(oTarget))
        return FALSE;

    // Delete a possibly existing Macro Array on target object
    eas_Array_Delete(oTarget, ESM_ARRAY_ONOBJECT);
    eas_Array_Delete(oTarget, ESM_ARRAY_ONOBJECT_METAMAGIC);
    int nth;
    string sDescription = "This macro contains the following spells:";
    int nSpell;
    for (nth = 0; nth < nSpells; nth++)
    {
        nSpell = eas_IArray_Entry_Get(oPC, ESM_ARRAY_TEMP, nth);
        eas_IArray_Entry_Add(oTarget, ESM_ARRAY_ONOBJECT, nSpell);
        eas_IArray_Entry_Add(oTarget, ESM_ARRAY_ONOBJECT_METAMAGIC, eas_IArray_Entry_Get(oPC, ESM_ARRAY_TEMP_METAMAGIC, nth));
        sDescription += "\n" + esm_GetSpellName(nSpell);
    }

    SetName(oTarget, GetLocalString(oPC, ESM_VAR_MACRONAME));
    SetDescription(oTarget, sDescription);

    RemoveItemProperty(oTarget, GetFirstItemProperty(oTarget));
    itemproperty nProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_UNIQUE_POWER, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
    AddItemProperty(DURATION_TYPE_PERMANENT, nProp, oTarget);
    return TRUE;
}

void esm_Recording_Stop(object oPC, object oMacroItem = OBJECT_INVALID)
{
    // Set Recording FALSE
    DeleteLocalInt(oPC, ESM_VAR_RECORDING);

    // Save on object
    if (GetIsObjectValid(oMacroItem))
    {
        if (GetStringLowerCase(GetLocalString(oPC, ESM_VAR_MACRONAME)) == "cancel")
        {
            SetTag(oMacroItem, GetLocalString(oMacroItem, ESM_VAR_ORIGINALTAG));
            // Inform the PC
            SendMessageToPC(oPC, "Recording cancelled.");
        }
        else
        {
            SetTag(oMacroItem, ESM_ITEMTAG_FINISHED);
            esm_SaveMacro(oPC, oMacroItem);
            // Inform the PC
            SendMessageToPC(oPC, "Recording stopped, Macro created.");
        }
    }

    // Delete the temporary array on the PC
    eas_Array_Delete(oPC, ESM_ARRAY_TEMP, FALSE);
    eas_Array_Delete(oPC, ESM_ARRAY_TEMP_METAMAGIC, FALSE);

    // Delete the macro name variable
    DeleteLocalString(oPC, ESM_VAR_MACRONAME);
}

void esm_AddSpell_Temporary_PC(object oPC, int nSpell, int nMetaMagic)
{
    eas_IArray_Entry_Add(oPC, ESM_ARRAY_TEMP, nSpell);
    eas_IArray_Entry_Add(oPC, ESM_ARRAY_TEMP_METAMAGIC, nMetaMagic);
}

void esm_ExecuteMacro(object oPC, object oMacro, object oTarget, location lLocation)
{
    int nSpells = eas_Array_GetSize(oMacro, ESM_ARRAY_ONOBJECT);
    if (nSpells == 0)
        return;

    int nth;
    int nSpell;
    int nMetaMagic;
    int nSmartCast = GetLocalInt(oMacro, ESM_VAR_SMARTCAST);
    for (nth = 0; nth < nSpells; nth++)
    {
        nSpell = eas_IArray_Entry_Get(oMacro, ESM_ARRAY_ONOBJECT, nth);
        nMetaMagic = eas_IArray_Entry_Get(oMacro, ESM_ARRAY_ONOBJECT_METAMAGIC, nth);

        if (GetIsObjectValid(oTarget))
        {
            if (oPC != oTarget &&
                !esm_Spell_CanBeCastOnCreatures(nSpell))
            {
                SendMessageToPC(oPC, "[" + color_ConvertString("Spell Macro", COLOR_GREY) + "] Skipping " + esm_GetSpellName(nSpell) + " (Can't cast on spell target)");
            }
            else if (!nSmartCast || !GetHasSpellEffect(nSpell, oTarget))
            {
                if (GetHasSpell(nSpell, oPC) != 0)
                    AssignCommand(oPC, ActionCastSpellAtObject(nSpell, oTarget, nMetaMagic));
                else
                    SendMessageToPC(oPC, "[" + color_ConvertString("Spell Macro", COLOR_GREY) + "] Skipping " + esm_GetSpellName(nSpell) + " (Can't cast spell)");
            }
            else
                SendMessageToPC(oPC, "[" + color_ConvertString("Spell Macro", COLOR_GREY) + "] Skipping " + esm_GetSpellName(nSpell) + " (Smart Cast)");
        }
        else if (GetHasSpell(nSpell, oPC) != 0)
            AssignCommand(oPC, ActionCastSpellAtLocation(nSpell, lLocation, nMetaMagic));
        else
            SendMessageToPC(oPC, "[" + color_ConvertString("Spell Macro", COLOR_GREY) + "] Skipping " + esm_GetSpellName(nSpell) + " (Can't cast spell)");
    }
}

int esm_IsRecording(object oPC)
{
    return (GetLocalInt(oPC, ESM_VAR_RECORDING));
}

void esm_OnActivateItem(object oActivator, object oActivated, object oTarget, location lTargetLocation)
{
    string sTag = GetTag(oActivated);
    if (sTag == ESM_BLUEPRINT || sTag == ESM_BLUEPRINT_SMART)
        esm_Recording_Start(oActivator, oActivated);
    else if (sTag == ESM_ITEMTAG_RECORDING)
        esm_Recording_Stop(oActivator, oActivated);
    else if (sTag == ESM_ITEMTAG_FINISHED)
        esm_ExecuteMacro(oActivator, oActivated, oTarget, lTargetLocation);
}
