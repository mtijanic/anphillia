///////////////////////////////////////////////////////////////////////////////
// mod_onactivate
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: Placeholder for the module-wide OnActivate Event


///////////
// Includes
//
#include "datetime_inc"
#include "dlg_inc"
#include "eas_inc"
#include "color_inc"
#include "chr_inc"
#include "esm_inc"

///////////////////////
// Function Declaration
//

////////////////
// Function Code
//

void main()
{
    SetLocalInt(OBJECT_SELF, "CURRENT_SCRIPT", EVENT_SCRIPT_MODULE_ON_ACTIVATE_ITEM);
    // Call the current script
    ExecuteScript("hc_on_act_item", OBJECT_SELF);

    object oActivated = GetItemActivated();
    object oActivator = GetItemActivator();
    object oTarget = GetItemActivatedTarget();
    location lTargetLocation = GetItemActivatedTargetLocation();

    string sTag = GetTag(oActivated);

    if (sTag == "pc_actionwand")
        dlg_StartConversation("dlg_wand", oActivator, oActivator, oActivated);

    // Check if Food should be queued
    chr_QueueFood(oActivator, oActivated);

    // Call ESM
    esm_OnActivateItem(oActivator, oActivated, oTarget, lTargetLocation);

    // Tag based scripting if available
    string sExtraScript = GetLocalString(oActivated, "ON_ACTIVATE_ITEM_SCRIPT");
    if (sExtraScript != "")
        ExecuteScript(sExtraScript, OBJECT_SELF);

    DeleteLocalInt(OBJECT_SELF, "CURRENT_SCRIPT");
}
