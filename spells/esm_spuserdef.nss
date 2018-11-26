/************************************************************************
 * script name  : esm_spuserdef
 * created by   : eyesolated
 * date         : 2018/4/15
 *
 * description  : The user defined Spell script for eyesolated spell macros
 *                This script needs to be defined as the user defined spell
 *                script on the module.
 *                Either you set the variable X2_S_UD_SPELLSCRIPT manually or
 *                call SetModuleOverrideSpellscript
 *
 * changes      : 2018/4/15 - eyesolated - Initial creation
 ************************************************************************/

// Includes
#include "color_inc"
#include "eas_inc"
#include "esm_inc"

void main()
{
    object oPC = OBJECT_SELF;
    int nSpell = GetSpellId();
    int nMetaMagic = GetMetaMagicFeat();

    if (esm_IsRecording(oPC))
    {
        esm_AddSpell_Temporary_PC(oPC, nSpell, nMetaMagic);
        SendMessageToPC(oPC, "Added [" + esm_GetSpellName(nSpell) + "] to macro.");
    }
}
