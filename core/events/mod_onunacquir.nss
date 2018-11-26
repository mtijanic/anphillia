///////////////////////////////////////////////////////////////////////////////
// mod_onunacquir
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: Placeholder for the module-wide OnUnAcquire Event


///////////
// Includes
//
#include "eas_inc"
#include "color_inc"
#include "egs_inc"
#include "ip_inc"
#include "store_inc"

///////////////////////
// Function Declaration
//

////////////////
// Function Code
//

void main()
{

    ExecuteScript("cnr_module_oui", OBJECT_SELF);

    // Call the current script
    ExecuteScript("hc_on_unacq_item", OBJECT_SELF);

    // Determine some important variables
    object oLastPossessor = GetModuleItemLostBy();
    if (!GetIsPC(oLastPossessor) && !GetIsDM(oLastPossessor))
        return;

    object oItem = GetModuleItemLost();
    object oNewPossessor = GetItemPossessor(oItem);

    /* not working, waiting for sherincall nwnx-ing this functionality
    // If oNewPossessor is OBJECT_INVALID, the item is on the ground, check for disarm
    if (!GetIsObjectValid(oNewPossessor))
    {
        object oLastAttacker = GetLastHostileActor(oLastPossessor);
        if (GetIsObjectValid(oLastAttacker))
        {
            int nLastAttackType = GetLastAttackType(oLastAttacker);
            if (nLastAttackType == SPECIAL_ATTACK_DISARM ||
                nLastAttackType == SPECIAL_ATTACK_IMPROVED_DISARM)
            {
                // Put oItem back into the players inventory
                CopyItem(oItem, oLastPossessor, TRUE);
                DestroyObject(oItem);
                SendMessageToPC(oLastPossessor, "You have been disarmed! [" + color_Item(GetName(oItem)) + "] has been put into your inventory.");
                return;
            }
        }
    }
    */

    string sItemName = "";
    string sBaseItemName = GetStringByStrRef(StringToInt(Get2DAString("baseitems", "Name", GetBaseItemType(oItem))));
    // If the item is identified, set it's real name, if not, use the base name
    if (GetIdentified(oItem))
        sItemName = GetName(oItem);
    else
        sItemName = sBaseItemName;
    if (GetBaseItemType(oItem) == BASE_ITEM_GOLD)
    {
        /* this is optional
        if (iStackSize < 50)
            sItemName = "a few gold pieces";
        else if (iStackSize < 250)
            sItemName = "some gold pieces";
        else if (iStackSize < 700)
            sItemName = "quite a few gold pieces";
        else if (iStackSize < 1500)
            sItemName = "a bag of gold pieces";
        else
            sItemName = "lots of gold";
        */
        sItemName = "Gold";
    }

    if (!GetIsPC(oNewPossessor))
        SetPickpocketableFlag(oItem, TRUE);

    if (sItemName == "")
        return;

    // Determine the message to be sent
    string sMessage;
    int iNewPossessorType = GetObjectType(oNewPossessor);
    switch (iNewPossessorType)
    {
        case OBJECT_TYPE_STORE:
             sMessage = color_Text("] sold [") + color_Item(sItemName) + color_Text("]");
             // In case of Stores, aside the message we have to check up on the inventory and see if it's below
             // it's treshold so we can refill it
             store_ItemBought(oNewPossessor, oItem, oLastPossessor);
             break;
        case OBJECT_TYPE_CREATURE: sMessage = color_Text("] have given [") + color_Item(sItemName) + color_Text("] to [") + color_Object(GetName(oNewPossessor)) + color_Text("]"); break;
        case OBJECT_TYPE_PLACEABLE: sMessage = color_Text("] put [") + color_Item(sItemName) + color_Text("] into [") + color_Object(GetName(oNewPossessor)) + color_Text("]"); break;
        case -1: sMessage = color_Text("] lost [") + color_Item(sItemName) + color_Text("]"); break;
        default: sMessage = color_Text("] lost [") + color_Item(sItemName) + color_Text("]"); break;
    }

    // Now, the player that took the item always gets that message
    // SendMessageToPC(oLastPossessor, color_Text("[") + color_GetColorFriendlyHostile("You", oLastPossessor, oLastPossessor) + sMessage);

    // Here comes the code for nearby players that might see the player taking the item




    // ----- SYSTEM FOR DROPPING PLACEABLES.
    // When unacquiring an item, check whether it correspond to a droppable
    // placeable.
    int nDroppablePlaceable = GetLocalInt(oItem, "DROP_PLACEABLE");
    if(nDroppablePlaceable == TRUE)
    {
         // Now grab the resref within the tag of the item of the placeable
         // that's going to be dropped.
         string sResRef = GetLocalString(oItem, "RESREF");

         // Grab the player location to get proper facing.
         location lPlayerLocation = GetLocation(oLastPossessor);
         DestroyObject(oItem, 0.1f);
         CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lPlayerLocation);
    }
}
