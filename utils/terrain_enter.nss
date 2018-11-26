//#include "color_inc"


const string TERRAIN_EFFECT_SPEED               = "SpeedAdjustment";
const string TERRAIN_EFFECT_ARMOR_CLASS         = "ArmorClassAdjustment";
const string TERRAIN_EFFECT_ATTACK_BONUS        = "AttackBonusAdjustment";
const string TERRAIN_EFFECT_MISS_CHANCE         = "RangedAttackMissChance";
const string TERRAIN_EFFECT_DEX_BONUS           = "DexterityAdjustment";
const string TERRAIN_EFFECT_CONCEALMENT         = "Concealment";
const string TERRAIN_EFFECT_DAMAGE_BONUS        = "DamageAdjustment";
const string TERRAIN_EFFECT_DAMAGE_REDUCTION    = "DamageReductionAdjustment";
const string TERRAIN_EFFECT_HASTE               = "Haste";
const string TERRAIN_EFFECT_REGENERATE          = "Regeneration";
const string TERRAIN_EFFECT_SAVE_UNIVERSAL      = "SavingThrowUniversal";
const string TERRAIN_EFFECT_SAVE_REFLEX         = "SavingThrowReflex";
const string TERRAIN_EFFECT_SAVE_WILL           = "SavingThrowWill";
const string TERRAIN_EFFECT_SAVE_FORTITUDE      = "SavingThrowFortitude";
const string TERRAIN_EFFECT_SLOW                = "Slow";
const string TERRAIN_EFFECT_SPELL_FAILURE       = "SpellFailure";
const string TERRAIN_EFFECT_SPELL_RESISTANCE    = "SpellResistance";
const string TERRAIN_EFFECT_SKILL_HIDE          = "HideAdjustment";
const string TERRAIN_EFFECT_SKILL_MOVE_SILENTLY = "MoveSilentlyAdjustment";
const string TERRAIN_EFFECT_SKILL_DISCIPLINE    = "DisciplineAdjustment";
const string TERRAIN_EFFECT_SKILL_SPOT          = "SpotAdjustment";
const string TERRAIN_EFFECT_SKILL_SEARCH        = "SearchAdjustment";
const string TERRAIN_EFFECT_SKILL_LISTEN        = "ListenAdjustment";
const string TERRAIN_EFFECT_SKILL_TUMBLE        = "TumbleAdjustment";
const string TERRAIN_EFFECT_SKILL_RIDE          = "RideAdjustment";
const string TERRAIN_EFFECT_SKILL_SPELLCRAFT    = "SpellcraftAdjustment";
const string TERRAIN_EFFECT_SKILL_CONCENTRATION = "ConcentrationAdjustment";
const string TERRAIN_EFFECT_SKILL_PARRY         = "ParryAdjustment";

effect terrain_GetEffect(object oTrigger)
{
    int nValue;

    effect eSpeed;
    effect eArmorClass;
    effect eAttackBonus;
    effect eDamageBonus;
    effect eDexBonus;
    effect eSaveUniversal;
    effect eSaveWill;
    effect eSaveReflex;
    effect eSaveFortitude;
    effect eSkillHide;
    effect eSkillMoveSilently;
    effect eSkillDiscipline;
    effect eSkillListen;
    effect eSkillSpot;
    effect eSkillSearch;
    effect eSkillTumble;
    effect eSkillRide;
    effect eSkillConcentration;
    effect eSkillParry;
    effect eSkillSpellcraft;
    effect eSpellFailure;
    effect eSpellResistance;
    effect eConcealment;
    effect eDamageReduction;
    effect eMissChance;
    effect eRegenerate;
    effect eHaste;
    effect eSlow;
    effect eLink;

    // Speed
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_SPEED);
    eSpeed = (nValue > 0)               ? EffectMovementSpeedIncrease(nValue)                    : EffectMovementSpeedDecrease(-nValue);
    // Armor Class
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_ARMOR_CLASS);
    eArmorClass = (nValue > 0)          ? EffectACIncrease(nValue)                               : EffectACDecrease(-nValue);
    // Attack Bonus
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_ATTACK_BONUS);
    eAttackBonus = (nValue > 0)         ? EffectAttackIncrease(nValue)                           : EffectAttackDecrease(-nValue);
    // Damage Bonus
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_DAMAGE_BONUS);
    eDamageBonus = (nValue > 0)         ? EffectDamageIncrease(nValue, DAMAGE_TYPE_BASE_WEAPON)  : EffectDamageDecrease(-nValue, DAMAGE_TYPE_BASE_WEAPON);
    // Dexterity Bonus
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_DEX_BONUS);
    eDexBonus = (nValue > 0)            ? EffectAbilityIncrease(ABILITY_DEXTERITY, nValue)       : EffectAbilityDecrease(ABILITY_DEXTERITY, -nValue);
    // Universal Save Bonus
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_SAVE_UNIVERSAL);
    eSaveUniversal = (nValue > 0)       ? EffectSavingThrowIncrease(SAVING_THROW_ALL, nValue)    : EffectSavingThrowDecrease(SAVING_THROW_ALL, -nValue);
    // Will Save Bonus
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_SAVE_WILL);
    eSaveWill = (nValue > 0)            ? EffectSavingThrowIncrease(SAVING_THROW_WILL, nValue)   : EffectSavingThrowDecrease(SAVING_THROW_WILL, -nValue);
    // Reflex Save Bonus
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_SAVE_REFLEX);
    eSaveReflex = (nValue > 0)          ? EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nValue) : EffectSavingThrowDecrease(SAVING_THROW_REFLEX, -nValue);
    // Fortitude Save Bonus
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_SAVE_FORTITUDE);
    eSaveFortitude = (nValue > 0)       ? EffectSavingThrowIncrease(SAVING_THROW_FORT, nValue)   : EffectSavingThrowDecrease(SAVING_THROW_FORT, -nValue);
    // Hide Bonus
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_SKILL_HIDE);
    eSkillHide = (nValue > 0)           ? EffectSkillIncrease(SKILL_HIDE, nValue)                : EffectSkillDecrease(SKILL_HIDE, -nValue);
    // Move Silently Bonus
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_SKILL_MOVE_SILENTLY);
    eSkillMoveSilently = (nValue > 0)   ? EffectSkillIncrease(SKILL_MOVE_SILENTLY, nValue)       : EffectSkillDecrease(SKILL_MOVE_SILENTLY, -nValue);
    // Discipline Bonus
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_SKILL_DISCIPLINE);
    eSkillDiscipline = (nValue > 0)     ? EffectSkillIncrease(SKILL_DISCIPLINE, nValue)          : EffectSkillDecrease(SKILL_DISCIPLINE, -nValue);
    // Listen Bonus
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_SKILL_LISTEN);
    eSkillListen = (nValue > 0)         ? EffectSkillIncrease(SKILL_LISTEN, nValue)              : EffectSkillDecrease(SKILL_LISTEN, -nValue);
    // Spot Bonus
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_SKILL_SPOT);
    eSkillSpot = (nValue > 0)           ? EffectSkillIncrease(SKILL_SPOT, nValue)                : EffectSkillDecrease(SKILL_SPOT, -nValue);
    // Search Bonus
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_SKILL_SEARCH);
    eSkillSearch = (nValue > 0)         ? EffectSkillIncrease(SKILL_SEARCH, nValue)              : EffectSkillDecrease(SKILL_SEARCH, -nValue);
    // Tumble Bonus
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_SKILL_TUMBLE);
    eSkillTumble = (nValue > 0)         ? EffectSkillIncrease(SKILL_TUMBLE, nValue)              : EffectSkillDecrease(SKILL_TUMBLE, -nValue);
    // Ride Bonus
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_SKILL_RIDE);
    eSkillRide = (nValue > 0)           ? EffectSkillIncrease(SKILL_RIDE, nValue)                : EffectSkillDecrease(SKILL_RIDE, -nValue);
    // Concentration Bonus
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_SKILL_CONCENTRATION);
    eSkillConcentration = (nValue > 0)  ? EffectSkillIncrease(SKILL_CONCENTRATION, nValue)       : EffectSkillDecrease(SKILL_CONCENTRATION, -nValue);
    // Parry Bonus
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_SKILL_PARRY);
    eSkillParry = (nValue > 0)          ? EffectSkillIncrease(SKILL_PARRY, nValue)               : EffectSkillDecrease(SKILL_PARRY, -nValue);
    // Spellcraft Bonus
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_SKILL_SPELLCRAFT);
    eSkillSpellcraft = (nValue > 0)     ? EffectSkillIncrease(SKILL_SPELLCRAFT, nValue)          : EffectSkillDecrease(SKILL_SPELLCRAFT, -nValue);
    // Concealment Bonus
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_CONCEALMENT);
    if (nValue) eConcealment = EffectConcealment(nValue);
    // Damage Reduction
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_DAMAGE_REDUCTION);
    if (nValue) eDamageReduction = EffectDamageReduction(nValue, DAMAGE_POWER_NORMAL);
    // Miss Chance
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_MISS_CHANCE);
    if (nValue) eMissChance = EffectMissChance(nValue, MISS_CHANCE_TYPE_VS_RANGED);
    // Regenerate Bonus
    nValue = GetLocalInt(oTrigger, TERRAIN_EFFECT_REGENERATE);
    if (nValue) eRegenerate = EffectRegenerate(nValue, 6.0f);
    // Haste and slow
    if (GetLocalInt(oTrigger, TERRAIN_EFFECT_HASTE)) eHaste = EffectHaste();
    if (GetLocalInt(oTrigger, TERRAIN_EFFECT_SLOW))  eSlow  = EffectSlow();

    eLink = EffectLinkEffects(eAttackBonus, eArmorClass);
    eLink = EffectLinkEffects(eLink, eConcealment);
    eLink = EffectLinkEffects(eLink, eDamageBonus);
    eLink = EffectLinkEffects(eLink, eDamageReduction);
    eLink = EffectLinkEffects(eLink, eDexBonus);
    eLink = EffectLinkEffects(eLink, eHaste);
    eLink = EffectLinkEffects(eLink, eMissChance);
    eLink = EffectLinkEffects(eLink, eRegenerate);
    eLink = EffectLinkEffects(eLink, eSaveFortitude);
    eLink = EffectLinkEffects(eLink, eSaveReflex);
    eLink = EffectLinkEffects(eLink, eSaveUniversal);
    eLink = EffectLinkEffects(eLink, eSaveWill);
    eLink = EffectLinkEffects(eLink, eSkillConcentration);
    eLink = EffectLinkEffects(eLink, eSkillDiscipline);
    eLink = EffectLinkEffects(eLink, eSkillHide);
    eLink = EffectLinkEffects(eLink, eSkillListen);
    eLink = EffectLinkEffects(eLink, eSkillMoveSilently);
    eLink = EffectLinkEffects(eLink, eSkillParry);
    eLink = EffectLinkEffects(eLink, eSkillRide);
    eLink = EffectLinkEffects(eLink, eSkillSearch);
    eLink = EffectLinkEffects(eLink, eSkillSpellcraft);
    eLink = EffectLinkEffects(eLink, eSkillSpot);
    eLink = EffectLinkEffects(eLink, eSkillTumble);
    eLink = EffectLinkEffects(eLink, eSlow);
    eLink = EffectLinkEffects(eLink, eSpeed);
    eLink = EffectLinkEffects(eLink, eSpellFailure);
    eLink = EffectLinkEffects(eLink, eSpellResistance);

    //eLink = TagEffect(eLink, "TERRAIN_BONUS_" + ObjectToString(oTrigger));
    return SupernaturalEffect(eLink);
}


void main()
{
    object oCreature = GetEnteringObject();
    if (GetIsDM(oCreature))
        return;

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, terrain_GetEffect(OBJECT_SELF), oCreature);
    if(GetIsPC(oCreature))
        FloatingTextStringOnCreature("Entering special terrain, effects applied", oCreature);
}
