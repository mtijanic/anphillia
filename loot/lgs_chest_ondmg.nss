///////////////////////////////////////////////////////////////////////////////
// lgs_chest_ondmg
// written by: eyesolated
// written at: May 19, 2018
//
// Notes: Deals with bashing in loot chests

#include "lgs_cfg"
void main()
{
    object oChest = OBJECT_SELF;
    int nRealMaxHitPoints = GetLocalInt(oChest, CS_LGS_CHEST_VAR_HITPOINTS);
    int nCurrentHitPoints = GetCurrentHitPoints(oChest);
    int nMaxHitPoints = GetMaxHitPoints(oChest);

    if (!GetPlotFlag(oChest) &&
        nCurrentHitPoints < (nMaxHitPoints - nRealMaxHitPoints)) // The chest is below it's max hitpoings
    {
        // Destroy some inventory
        object oItem = GetFirstItemInInventory(oChest);
        int nBaseItemType;
        while (GetIsObjectValid(oItem))
        {
            nBaseItemType = GetBaseItemType(oItem);
            switch (nBaseItemType)
            {
                case BASE_ITEM_GOLD:
                    SetItemStackSize(oItem, GetItemStackSize(oItem) / (Random(3) + 2));
                    break;
                default:
                    if (d100() <= 33)
                        DestroyObject(oItem);
                    break;
            }
            oItem = GetNextItemInInventory(oChest);
        }

        // Unlock the chest
        SetLocked(oChest, FALSE);

        // Make the chest PLOT so it can't be damaged any more
        SetPlotFlag(oChest, TRUE);

        // Heal the chest to full
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nRealMaxHitPoints), oChest);

        // Tell the PC that he broke the lock
        SendMessageToPC(GetLastDamager(oChest), "You successfully bashed the lock to pieces.");
    }
}
