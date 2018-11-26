//::///////////////////////////////////////////////
//:: Knock
//:: NW_S0_Knock
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Opens doors not locked by magical means.
*/
/*
    Anphillia Changes
    This spell now unlocks DCs of d20 + Caster Level + Int Modifier. If the
    lock DC is higher, the spell will weaken the DC by
    Caser Level + Int Modifier for 30 seconds.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 29, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Georg 2003/07/31 - Added signal event and custom door flags
//:: VFX Pass By: Preston W, On: June 22, 2001
#include "nw_i0_spells"

#include "x2_inc_spellhook"


void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    location loc = GetLocation(OBJECT_SELF);
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nRoll = (GetIsInCombat(OBJECT_SELF) ? d20() : 20);
    int nModifier = nCasterLevel + GetAbilityModifier(ABILITY_INTELLIGENCE);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 50.0, loc, FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTarget))
    {
        SignalEvent(oTarget,EventSpellCastAt(OBJECT_SELF,GetSpellId()));
        float fDelay = GetRandomDelay(0.5, 2.5);
        if(GetLocked(oTarget) && GetStringUpperCase(GetStringLeft(GetTag(oTarget), 3)) != "CNR")
        {
            int nResist =  GetDoorFlag(oTarget,DOOR_FLAG_RESIST_KNOCK);

            // Knock shouldn't open doors that require special keys
            if (GetLockKeyRequired(oTarget))
            {
                FloatingTextStringOnCreature(GetName(oTarget) + " requires a special key.", OBJECT_SELF);
            }
            else if (nResist == 0)
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_KNOCK), oTarget));

                int nDC = GetLockUnlockDC(oTarget);
                if (nDC <= (nRoll + nModifier))
                {
                    AssignCommand(oTarget, ActionUnlockObject(oTarget));
                    FloatingTextStringOnCreature(GetName(oTarget) + " has been unlocked.", OBJECT_SELF);
                }
                else
                {
                    SetLockUnlockDC(oTarget, nDC - nModifier);
                    DelayCommand(30.0, SetLockUnlockDC(oTarget, nDC));
                    FloatingTextStringOnCreature(GetName(oTarget) + " has been weakened.", OBJECT_SELF);
                }
            }
            else if  (nResist == 1)
            {
                FloatingTextStrRefOnCreature(83887,OBJECT_SELF);   //
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 50.0, loc, FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}

