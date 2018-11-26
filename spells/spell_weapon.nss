
#include "nw_i0_spells"
#include "x2_i0_spells"

#include "x2_inc_spellhook"
#include "util_inc"

object GetTargetCreature()
{
    object oTarget = GetSpellTargetObject();
    if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        return oTarget;
    else if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
        return GetItemPossessor(oTarget);
    else
        return OBJECT_INVALID;
}

object GetTargetWeapon()
{
    object oTarget = GetSpellTargetObject();
    object oWeapon;
    if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
    {
        oWeapon = oTarget;
    }
    else
    {
        oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
        if (oWeapon == OBJECT_INVALID || !util_IsWeapon(oWeapon))
        {
            oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
        }
        if (oWeapon == OBJECT_INVALID || !util_IsWeapon(oWeapon))
        {
            oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget);
        }
        if (oWeapon == OBJECT_INVALID || !util_IsWeapon(oWeapon))
        {
            oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
        }
        if (oWeapon == OBJECT_INVALID || !util_IsWeapon(oWeapon))
        {
            oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
        }
        if (oWeapon == OBJECT_INVALID || !util_IsWeapon(oWeapon))
        {
            oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
        }
    }
    if (!util_IsWeapon(oWeapon))
    {
        oWeapon = OBJECT_INVALID;
    }
    return oWeapon;
}


float GetSpellDuration()
{
    int nSpellID   = GetSpellId();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    float fDuration;

    switch (nSpellID)
    {
        case SPELL_MAGIC_WEAPON:
        case SPELL_GREATER_MAGIC_WEAPON:
        case SPELL_DARKFIRE:
        case SPELL_FLAME_WEAPON:
            fDuration = TurnsToSeconds(2*nCasterLvl); break;
        case SPELL_BLADE_THIRST:
            fDuration = RoundsToSeconds(2*nCasterLvl); break;
        default:
            return 0.0;
    }


    if (nMetaMagic == METAMAGIC_EXTEND)
        fDuration *= 2;
    return fDuration;
}

void  AddGreaterEnhancementEffectToWeapon(object oMyWeapon, float fDuration, int nBonus)
{
   IPSafeAddItemProperty(oMyWeapon,ItemPropertyEnhancementBonus(nBonus), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
   return;
}

void AddItemEnhancementEffect(object oItem, float fDuration, int nEnhancementBonus)
{
    int nBaseItemType = GetBaseItemType(oItem);
    // Ranged weapons and bracers/gauntlets can only gain attac bonuses
         if (  nBaseItemType == BASE_ITEM_LONGBOW
            || nBaseItemType == BASE_ITEM_HEAVYCROSSBOW
            || nBaseItemType == BASE_ITEM_GLOVES
            || nBaseItemType == BASE_ITEM_SHORTBOW
            || nBaseItemType == BASE_ITEM_SLING
            || nBaseItemType == BASE_ITEM_LIGHTCROSSBOW)
        IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(nEnhancementBonus), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
    // Ranged ammunition can only gain damage bonuses
    else if (  nBaseItemType == BASE_ITEM_ARROW
            || nBaseItemType == BASE_ITEM_BOLT
            || nBaseItemType == BASE_ITEM_BULLET)
        IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(nBaseItemType == BASE_ITEM_BULLET ? IP_CONST_DAMAGETYPE_BLUDGEONING : IP_CONST_DAMAGETYPE_PIERCING,nEnhancementBonus),
                                fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, TRUE);
    // All other weapons can gain enhancement bonuses
    else if (  nBaseItemType == BASE_ITEM_ARMOR)
        IPSafeAddItemProperty(oItem, ItemPropertyACBonus(nEnhancementBonus), fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, TRUE);
    // All other weapons can gain enhancement bonuses
    else if (util_IsWeapon(oItem))
        IPSafeAddItemProperty(oItem, ItemPropertyEnhancementBonus(nEnhancementBonus), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
}

void AddItemEnergyEffect(object oItem, float fDuration, int nDamageType, int nDamageBonus)
{
    // Abort for non-weapons
    int nBaseItemType = GetBaseItemType(oItem);
    if (util_IsWeapon(oItem) || nBaseItemType == BASE_ITEM_GLOVES)
    {
        itemproperty ip = GetFirstItemProperty(oItem);
        while (GetIsItemPropertyValid(ip))
        {
            if (GetItemPropertyTag(ip) == "SPELL_ENERGY_EFFECT")
            {
                FloatingTextStringOnCreature("You override an existing enchantment", OBJECT_SELF, FALSE);
                RemoveItemProperty(oItem, ip);
            }
            ip = GetNextItemProperty(oItem);
        }

        IPSafeAddItemProperty(oItem, TagItemProperty(ItemPropertyDamageBonus(nDamageType, nDamageBonus), "SPELL_ENERGY_EFFECT"), fDuration,
                                X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

        int nItemVisual = -1;
        switch (nDamageType)
        {
            case IP_CONST_DAMAGETYPE_ACID:          nItemVisual = ITEM_VISUAL_ACID;         break;
            case IP_CONST_DAMAGETYPE_COLD:          nItemVisual = ITEM_VISUAL_COLD;         break;
            case IP_CONST_DAMAGETYPE_DIVINE:
                switch (GetAlignmentGoodEvil(OBJECT_SELF))
                {
                    case ALIGNMENT_GOOD:            nItemVisual = ITEM_VISUAL_HOLY;       break;
                    case ALIGNMENT_NEUTRAL:         nItemVisual = ITEM_VISUAL_SONIC;      break;
                    case ALIGNMENT_EVIL:            nItemVisual = ITEM_VISUAL_EVIL;       break;
                }
                break;
            case IP_CONST_DAMAGETYPE_ELECTRICAL:    nItemVisual = ITEM_VISUAL_ELECTRICAL;   break;
            case IP_CONST_DAMAGETYPE_FIRE:          nItemVisual = ITEM_VISUAL_FIRE;         break;
            case IP_CONST_DAMAGETYPE_MAGICAL:       nItemVisual = ITEM_VISUAL_SONIC;        break;
            case IP_CONST_DAMAGETYPE_NEGATIVE:      nItemVisual = ITEM_VISUAL_EVIL;         break;
            case IP_CONST_DAMAGETYPE_POSITIVE:      nItemVisual = ITEM_VISUAL_HOLY;         break;
            case IP_CONST_DAMAGETYPE_SONIC:         nItemVisual = ITEM_VISUAL_SONIC;        break;
        }
        // Add the item visual only if needed
        if (nItemVisual != -1)
            IPSafeAddItemProperty(oItem, ItemPropertyVisualEffect(nItemVisual), fDuration,
                                    X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
    }
}


void main()
{
    int nSpellID     = GetSpellId();
    object oCaster   = OBJECT_SELF;
    object oCreature = GetTargetCreature();
    object oWeapon   = GetTargetWeapon();
    float fDuration  = GetSpellDuration();
    int nCasterLvl   = GetCasterLevel(oCaster);

    if (fDuration <= 0.0 || oWeapon == OBJECT_INVALID)
    {
        FloatingTextStringOnCreature("Your spell did not take hold", oCaster, FALSE);
        return;
    }

    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCreature);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oCreature, fDuration);

    switch (nSpellID)
    {
        case SPELL_MAGIC_WEAPON:
            AddItemEnhancementEffect(oWeapon, fDuration, 1);
            break;
        case SPELL_GREATER_MAGIC_WEAPON:
            AddItemEnhancementEffect(oWeapon, fDuration, min(nCasterLvl/3, 3));
            break;
        case SPELL_BLADE_THIRST:
            // If we targeted a creature that's dual wielding, apply +2 to both
            if (GetSpellTargetObject() == oCreature &&
                GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature) == oWeapon &&
                util_IsWeapon(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature)))
            {
                AddItemEnhancementEffect(oWeapon, fDuration, 2);
                AddItemEnhancementEffect(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature), fDuration, 2);
            }
            else
            {
                AddItemEnhancementEffect(oWeapon, fDuration, 3);
            }
            break;
        case SPELL_FLAME_WEAPON:
        case SPELL_DARKFIRE:
            {
                int nDamageType = GetLocalInt(oCaster, "SPELL_DAMAGE_TYPE");
                if (nDamageType == 0)
                {
                    SendMessageToPC(oCaster, "No damage type selected, defaulting to fire. Type '/dmg [f|c|l|a]' to select");
                    nDamageType = IP_CONST_DAMAGETYPE_FIRE;
                }
                AddItemEnergyEffect(oWeapon, fDuration, nDamageType, IP_CONST_DAMAGEBONUS_1d6);
            }
            break;

        default: return;
    }

    string sItemName = GetName(oWeapon);
    if (GetIsObjectValid(oCreature) && oCreature != oCaster)
    {
        DelayCommand(1.0, FloatingTextStringOnCreature("You enchanted " + GetName(oCreature) + "'s " + sItemName, oCaster, FALSE));
        DelayCommand(1.0, FloatingTextStringOnCreature(GetName(oCaster) + " enchanted your " + sItemName, oCreature, FALSE));
    }
    else if (oCreature == oCaster)
        DelayCommand(1.0, FloatingTextStringOnCreature("You enchanted your " + sItemName, oCaster, FALSE));
    else
        DelayCommand(1.0, FloatingTextStringOnCreature("You enchanted the targeted " + sItemName, oCaster, FALSE));
}
