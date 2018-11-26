///////////////////////////////////////////////////////////////////////////////
// mod_onacquire
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: Placeholder for the module-wide OnAcquire Event


///////////
// Includes
//
#include "eas_inc"
#include "color_inc"
#include "egs_inc"
#include "ip_inc"
#include "store_inc"
#include "chr_inc"

///////////////////////
// Function Declaration
//

////////////////
// Function Code
//

void main()
{
    // Call the current script
    ExecuteScript("hc_on_acq_item", OBJECT_SELF);

    // Determine some important variables
    object oNewPossessor = GetModuleItemAcquiredBy();
    if (!GetIsPC(oNewPossessor) && !GetIsDM(oNewPossessor))
        return;

    object oLastPossessor = GetModuleItemAcquiredFrom();
    object oItem = GetModuleItemAcquired();
    string sItemName = "";
    string sBaseItemName = GetStringByStrRef(StringToInt(Get2DAString("baseitems", "Name", GetBaseItemType(oItem))));
    // If the item is identified, set it's real name, if not, use the base name
    if (GetIdentified(oItem))
       sItemName = GetName(oItem);
    else
       sItemName = sBaseItemName;

    SetPickpocketableFlag(oItem, FALSE);

    int iStackSize = GetModuleItemAcquiredStackSize();
    if (GetBaseItemType(oItem) == BASE_ITEM_GOLD)
    {
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
    }

    if (sItemName == "" ||
        sItemName == "Bad Strref")
        return;

    // Determine the message to be sent
    string sMessage;
    string sMessageByStander = "";
    int iLastPossessorType = GetObjectType(oLastPossessor);
    switch (iLastPossessorType)
    {
        case OBJECT_TYPE_STORE:
            if (GetBaseItemType(oItem) ==  BASE_ITEM_GOLD)
                return;

            store_ItemSold(oLastPossessor, oItem);
            sMessage = color_Text("] bought [") + color_Item(sItemName) + color_Text("]");
            sMessageByStander = color_Text("] bought [") + color_Item(sBaseItemName) + color_Text("]");
            // In case of Stores, aside the message we have to check up on the inventory and see if it's below
            // it's treshold so we can refill it
            break;
        case OBJECT_TYPE_CREATURE:
            if (!GetIsDM(oLastPossessor))
            {
                sMessage = color_Text("] were given [") + color_Item(sItemName) + color_Text("] from [") + color_Object(GetName(oLastPossessor)) + color_Text("]");
                sMessageByStander = color_Text("] was given [") + color_Item(sBaseItemName) + color_Text("] from [") + color_Object(GetName(oLastPossessor)) + color_Text("]");
            }
            break;
        case OBJECT_TYPE_PLACEABLE:
            sMessage = color_Text("] took [") + color_Item(sItemName) + color_Text("] out of [") + color_Object(GetName(oLastPossessor)) + color_Text("]");
            sMessageByStander = color_Text("] took [") + color_Item(sBaseItemName) + color_Text("] out of [") + color_Object(GetName(oLastPossessor)) + color_Text("]");
            break;
        case -1:
            sMessage = color_Text("] acquired [") + color_Item(sItemName) + color_Text("]");
            sMessageByStander = color_Text("] acquired [") + color_Item(sBaseItemName) + color_Text("]");
            break;
        default:
            sMessage = color_Text("] acquired [") + color_Item(sItemName) + color_Text("]");
            sMessageByStander = color_Text("] acquired [") + color_Item(sBaseItemName) + color_Text("]");
            break;
    }

    // Now, the player that took the item always gets that message
    // SendMessageToPC(oNewPossessor, color_Text("[") + color_GetColorFriendlyHostile("You", oNewPossessor, oNewPossessor) + sMessage);

    // Here comes the code for nearby players that might see the player taking the item
    int nth = 1;
    object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oNewPossessor, nth);
    float fDistance;
    int nDC = chr_DoSkillCheck(oNewPossessor, SKILL_PICK_POCKET, 0, FALSE, FALSE, FALSE, TRUE);
    string sName = GetName(oNewPossessor);
    while (GetIsObjectValid(oPC))
    {
        fDistance = GetDistanceBetween(oNewPossessor, oPC);
        if (fDistance < 2.5f &&
            chr_DoSkillCheck(oPC, SKILL_SPOT, nDC))
            SendMessageToPC(oPC, color_Text("[") + color_GetColorFriendlyHostile(sName, oPC, oNewPossessor) + sMessageByStander);
        else if (fDistance < 5.0f &&
                 chr_DoSkillCheck(oPC, SKILL_SPOT, FloatToInt(nDC * 1.1)))
            SendMessageToPC(oPC, color_Text("[") + color_GetColorFriendlyHostile(sName, oPC, oNewPossessor) + sMessageByStander);
        else
            break;

        nth++;
        oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oNewPossessor, nth);
    }

    ExecuteScript("_item_migrate", oItem);
}
