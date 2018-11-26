///////////////////////////////////////////////////////////////////////////////
// mod_onequip
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: Placeholder for the module-wide OnEquip Event

///////////
// Includes
//
#include "x2_inc_itemprop"

///////////////////////
// Function Declaration
//

////////////////
// Function Code
//
#include "nwnx_player"
#include "color_inc"

void main()
{
    object oItem = GetPCItemLastEquipped();
    object oPC = GetPCItemLastEquippedBy();

    if (GetIsInCombat(oPC))
    {
        int i;
        for (i = 0; i <= INVENTORY_SLOT_BOLTS; i++)
        {
            if (GetItemInSlot(i, oPC) == oItem)
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,SupernaturalEffect(EffectSlow()),oPC,1.5);
                NWNX_Player_StartGuiTimingBar(oPC, 1.5, "");
            }
        }
    }

    // Does the item have class restrictions and the PCs UMD score is below 15?
    int nUMD = GetSkillRank(SKILL_USE_MAGIC_DEVICE, oPC);
    if (!GetIsDM(oPC) &&
        nUMD < 15 &&
        GetItemHasItemProperty(oItem, ITEM_PROPERTY_USE_LIMITATION_CLASS))
    {
        // How many classes does oPC have?
        int nClassCount = 1;
        if (GetLevelByPosition(3, oPC) != 0)
            nClassCount = 3;
        else if (GetLevelByPosition(2, oPC) != 0)
            nClassCount = 2;

        // The coming checks are only needed if the player has levels in more
        // than one class
        if (nClassCount > 1)
        {
            itemproperty ip = GetFirstItemProperty(oItem);
            int nClass;
            int nLevels_Total = GetHitDice(oPC);
            int nLevels_Class;
            int nAllowUse = 0;
            int nHighestClassMatch = FALSE;
            int nClass_Restrictions = 0;

            while (GetIsItemPropertyValid(ip))
            {
                if (GetItemPropertyType(ip) == ITEM_PROPERTY_USE_LIMITATION_CLASS)
                {
                    nClass_Restrictions++;

                    // What class is this item restricted for?
                    nClass = GetItemPropertySubType(ip);

                    // Retrieve the Levels the player has in the given class
                    nLevels_Class = GetLevelByClass(nClass, oPC);

                    // If the character has no levels in nClass, he must be using UMD
                    // OR have another class that is restricted on the item, so this
                    // restriction gets an OK!
                    if (nLevels_Class == 0)
                        nAllowUse++;
                    // If nClass is the highest Class of the player,
                    // this item gets an OK immediately!
                    else if (IntToFloat(nLevels_Total) / IntToFloat(nClassCount) <= IntToFloat(nLevels_Class))
                    {
                        nHighestClassMatch = TRUE;
                        break;
                    }
                }
                ip = GetNextItemProperty(oItem);
            }

            if (!nHighestClassMatch &&
                nAllowUse < nClass_Restrictions)
            {
                AssignCommand(oPC, ClearAllActions(TRUE));
                AssignCommand(oPC, ActionUnequipItem(oItem));
                SendMessageToPC(oPC, "You cannot equip [" + color_Item(GetName(oItem)) + "] due to class restrictions.");
            }
        }
    }
}
