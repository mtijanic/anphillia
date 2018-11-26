//::///////////////////////////////////////////////
//:: True Seeing
//:: NW_S0_TrueSee.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The creature can seen all invisible, sanctuared,
    or hidden opponents.
*/
/*
    Anphillia Changes
    True Seeing does not reveal hidden creatures but is composed of the
    following effects:
    . See Invisibility
    . Spell School Immunity (Illusion)
    . Spell Immunity (Sanctuary)
    . Spell Immunity (Phantasmal Killer)
    . UltraVision
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: [date]
//:://////////////////////////////////////////////

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

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSight1 = EffectSeeInvisible();
    effect eSight2 = EffectSpellImmunity(SPELL_SCHOOL_ILLUSION);
    effect eSight3 = EffectSpellImmunity(SPELL_SANCTUARY);
    effect eSight4 = EffectUltravision();
    effect eSight5 = EffectSpellImmunity(SPELL_PHANTASMAL_KILLER);
    effect eLink = EffectLinkEffects(eSight1, eSight2);
    eLink = EffectLinkEffects(eLink, eSight3);
    eLink = EffectLinkEffects(eLink, eSight4);
    eLink = EffectLinkEffects(eLink, eVis);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eSight5);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_TRUE_SEEING, FALSE));
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    //Apply the VFX impact and effects
    if (GetIsDM(GetLastSpellCaster()))
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTrueSeeing(), oTarget, TurnsToSeconds(nDuration));
    else
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
}

