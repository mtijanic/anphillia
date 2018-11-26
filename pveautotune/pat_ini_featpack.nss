/************************************************************************
 * script name  : pat_ini_featpack
 * created by   : eyesolated
 * date         : 2018/7/31
 *
 * description  : Feat Initialization script for PAT
 *
 * changes      : 2018/7/31 - eyesolated - Initial creation
 ************************************************************************/
#include "pat_inc"

string pat_FeatString(int nFeatPack)
{
    return (IntToString(nFeatPack) + ";");
}

void main()
{
    string sFeatPacks_All = ";0;";
    string sFeatPacks;

/*******************************************************************************
* Feats for all Packs
*******************************************************************************/
    // Feats for all (Pack 0)
    pat_AddFeat(FEAT_WEAPON_FINESSE, sFeatPacks_All, 100, 0, 1);
    pat_AddFeat(FEAT_WEAPON_PROFICIENCY_CREATURE, sFeatPacks_All, 100, 0, 1);

/*******************************************************************************
* Armor Proficiencies
*******************************************************************************/
    // Armor Proficiency Heavy
    sFeatPacks = ";" +
                 pat_FeatString(PAT_FEATPACK_CLASS_BLACKGUARD) +
                 pat_FeatString(PAT_FEATPACK_CLASS_CLERIC) +
                 pat_FeatString(PAT_FEATPACK_CLASS_DIVINE_CHAMPION) +
                 pat_FeatString(PAT_FEATPACK_CLASS_DWARVEN_DEFENDER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_FIGHTER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_PALADIN) +
                 pat_FeatString(PAT_FEATPACK_CLASS_PURPLE_DRAGON_KNIGHT) +
                 pat_FeatString(PAT_FEATPACK_CLASS_WEAPON_MASTER);
    pat_AddFeat(FEAT_ARMOR_PROFICIENCY_HEAVY, sFeatPacks, 100, 0, 1);

    // Armor Proficiency Medium + Shield Proficiency
    sFeatPacks += pat_FeatString(PAT_FEATPACK_CLASS_ARCANE_ARCHER) +
                  pat_FeatString(PAT_FEATPACK_CLASS_BARBARIAN) +
                  pat_FeatString(PAT_FEATPACK_CLASS_BARD) +
                  pat_FeatString(PAT_FEATPACK_CLASS_DRAGON_DISCIPLE) +
                  pat_FeatString(PAT_FEATPACK_CLASS_DRUID) +
                  pat_FeatString(PAT_FEATPACK_CLASS_RANGER)+
                  pat_FeatString(PAT_FEATPACK_CLASS_SHIFTER);
    pat_AddFeat(FEAT_ARMOR_PROFICIENCY_MEDIUM, sFeatPacks, 100, 0, 1);
    pat_AddFeat(FEAT_SHIELD_PROFICIENCY, sFeatPacks, 100, 0, 1);

    // Armor Proficiency Light
    sFeatPacks += pat_FeatString(PAT_FEATPACK_CLASS_ASSASSIN) +
                  pat_FeatString(PAT_FEATPACK_CLASS_HARPER) +
                  pat_FeatString(PAT_FEATPACK_CLASS_ROGUE) +
                  pat_FeatString(PAT_FEATPACK_CLASS_SHADOWDANCER);
    pat_AddFeat(FEAT_ARMOR_PROFICIENCY_LIGHT, sFeatPacks, 100, 0, 1);

/*******************************************************************************
* Ambidexterity / Two-Weapon-Fighting / Improved Two-Weapon Fighting
*******************************************************************************/
    sFeatPacks = ";" +
                 pat_FeatString(PAT_FEATPACK_CLASS_ASSASSIN) +
                 pat_FeatString(PAT_FEATPACK_CLASS_BARBARIAN) +
                 pat_FeatString(PAT_FEATPACK_CLASS_RANGER)+
                 pat_FeatString(PAT_FEATPACK_CLASS_ROGUE) +
                 pat_FeatString(PAT_FEATPACK_CLASS_SHADOWDANCER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_WEAPON_MASTER);
    pat_AddFeat(FEAT_AMBIDEXTERITY, sFeatPacks, 100, 0, 1);
    pat_AddFeat(FEAT_TWO_WEAPON_FIGHTING, sFeatPacks, 100, 0, 1);
    pat_AddFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING, sFeatPacks, 100, 0, 9);

/*******************************************************************************
* Barbarian Endurance
*******************************************************************************/
    sFeatPacks = ";" + pat_FeatString(PAT_FEATPACK_CLASS_BARBARIAN);
    pat_AddFeat(FEAT_BARBARIAN_ENDURANCE, sFeatPacks, 100, 0, 1);

/*******************************************************************************
* Barbarian Rage
*******************************************************************************/
    sFeatPacks = ";" + pat_FeatString(PAT_FEATPACK_CLASS_BARBARIAN);
    pat_AddFeat(FEAT_BARBARIAN_RAGE, sFeatPacks, 100, 0, 1);

/*******************************************************************************
* Barbarian Damage Reduction
*******************************************************************************/
    sFeatPacks = ";" + pat_FeatString(PAT_FEATPACK_CLASS_BARBARIAN);
    pat_AddFeat(FEAT_DAMAGE_REDUCTION, sFeatPacks, 100, 0, 11);

/*******************************************************************************
* Blind Fighting
*******************************************************************************/
    sFeatPacks = ";" +
                 pat_FeatString(PAT_FEATPACK_CLASS_ARCANE_ARCHER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_ASSASSIN) +
                 pat_FeatString(PAT_FEATPACK_CLASS_BARBARIAN) +
                 pat_FeatString(PAT_FEATPACK_CLASS_BLACKGUARD)+
                 pat_FeatString(PAT_FEATPACK_CLASS_DIVINE_CHAMPION) +
                 pat_FeatString(PAT_FEATPACK_CLASS_DWARVEN_DEFENDER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_FIGHTER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_MONK) +
                 pat_FeatString(PAT_FEATPACK_CLASS_PALADIN) +
                 pat_FeatString(PAT_FEATPACK_CLASS_PURPLE_DRAGON_KNIGHT) +
                 pat_FeatString(PAT_FEATPACK_CLASS_RANGER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_ROGUE) +
                 pat_FeatString(PAT_FEATPACK_CLASS_SHADOWDANCER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_WEAPON_MASTER) +
                 pat_FeatString(PAT_FEATPACK_NAKED_DPS);
    pat_AddFeat(FEAT_BLIND_FIGHT, sFeatPacks, 60, 1, 5);

/*******************************************************************************
* Combat Casting
*******************************************************************************/
    sFeatPacks = ";" +
                 pat_FeatString(PAT_FEATPACK_CLASS_BARD) +
                 pat_FeatString(PAT_FEATPACK_CLASS_CLERIC) +
                 pat_FeatString(PAT_FEATPACK_CLASS_DRUID) +
                 pat_FeatString(PAT_FEATPACK_CLASS_PALE_MASTER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_SHIFTER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_SORCERER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_WIZARD);
    pat_AddFeat(FEAT_COMBAT_CASTING, sFeatPacks, 100, 0, 1);

/*******************************************************************************
* Diamond Soul
*******************************************************************************/
    sFeatPacks = ";" + pat_FeatString(PAT_FEATPACK_CLASS_MONK);
    pat_AddFeat(FEAT_DIAMOND_SOUL, sFeatPacks, 100, 0, 12);

/*******************************************************************************
* Flurry of Blows
*******************************************************************************/
    sFeatPacks = ";" + pat_FeatString(PAT_FEATPACK_CLASS_MONK);
    pat_AddFeat(FEAT_FLURRY_OF_BLOWS, sFeatPacks, 100, 0, 1);

/*******************************************************************************
* Improved Unarmed Strike
*******************************************************************************/
    sFeatPacks = ";" + pat_FeatString(PAT_FEATPACK_CLASS_MONK);
    pat_AddFeat(FEAT_IMPROVED_UNARMED_STRIKE, sFeatPacks, 100, 0, 1);

/*******************************************************************************
* Knockdown / Improved Knockdown
*******************************************************************************/
    sFeatPacks = ";" +
                 pat_FeatString(PAT_FEATPACK_CLASS_ASSASSIN) +
                 pat_FeatString(PAT_FEATPACK_CLASS_BARBARIAN) +
                 pat_FeatString(PAT_FEATPACK_CLASS_BLACKGUARD)+
                 pat_FeatString(PAT_FEATPACK_CLASS_DIVINE_CHAMPION) +
                 pat_FeatString(PAT_FEATPACK_CLASS_DWARVEN_DEFENDER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_FIGHTER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_MONK) +
                 pat_FeatString(PAT_FEATPACK_CLASS_PALADIN) +
                 pat_FeatString(PAT_FEATPACK_CLASS_PURPLE_DRAGON_KNIGHT) +
                 pat_FeatString(PAT_FEATPACK_CLASS_RANGER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_ROGUE) +
                 pat_FeatString(PAT_FEATPACK_CLASS_SHADOWDANCER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_WEAPON_MASTER) +
                 pat_FeatString(PAT_FEATPACK_NAKED_DPS) +
                 pat_FeatString(PAT_FEATPACK_NAKED_TANK);
    pat_AddFeat(FEAT_KNOCKDOWN, sFeatPacks, 30, 1, 5);
    pat_AddFeat(FEAT_IMPROVED_KNOCKDOWN, sFeatPacks, 20, 1, 10);

/*******************************************************************************
* Mobility
*******************************************************************************/
    sFeatPacks = ";" +
                 pat_FeatString(PAT_FEATPACK_CLASS_ASSASSIN) +
                 pat_FeatString(PAT_FEATPACK_CLASS_BARBARIAN) +
                 pat_FeatString(PAT_FEATPACK_CLASS_BLACKGUARD)+
                 pat_FeatString(PAT_FEATPACK_CLASS_DIVINE_CHAMPION) +
                 pat_FeatString(PAT_FEATPACK_CLASS_DWARVEN_DEFENDER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_FIGHTER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_MONK) +
                 pat_FeatString(PAT_FEATPACK_CLASS_PALADIN) +
                 pat_FeatString(PAT_FEATPACK_CLASS_PURPLE_DRAGON_KNIGHT) +
                 pat_FeatString(PAT_FEATPACK_CLASS_RANGER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_ROGUE) +
                 pat_FeatString(PAT_FEATPACK_CLASS_SHADOWDANCER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_WEAPON_MASTER);
    pat_AddFeat(FEAT_MOBILITY, sFeatPacks, 80, 0, 12);

/*******************************************************************************
* Point Blank Shot / Rapid Shot / Rapid Reload
*******************************************************************************/
    sFeatPacks = ";" +
                 pat_FeatString(PAT_FEATPACK_CLASS_ASSASSIN) +
                 pat_FeatString(PAT_FEATPACK_CLASS_ARCANE_ARCHER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_DIVINE_CHAMPION) +
                 pat_FeatString(PAT_FEATPACK_CLASS_FIGHTER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_RANGER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_ROGUE);
    pat_AddFeat(FEAT_POINT_BLANK_SHOT, sFeatPacks, 100, 0, 1);
    pat_AddFeat(FEAT_RAPID_SHOT, sFeatPacks, 100, 0, 6);
    pat_AddFeat(FEAT_RAPID_RELOAD, sFeatPacks, 100, 0, 6);

/*******************************************************************************
* Sneak Attacks
*******************************************************************************/
    sFeatPacks = ";" +
                 pat_FeatString(PAT_FEATPACK_CLASS_ASSASSIN) +
                 pat_FeatString(PAT_FEATPACK_CLASS_ROGUE) +
                 pat_FeatString(PAT_FEATPACK_CLASS_SHADOWDANCER);
    pat_AddFeat(FEAT_SNEAK_ATTACK, sFeatPacks, 100, 0, 1, 2);
    pat_AddFeat(345, sFeatPacks, 100, 0, 3, 4);
    pat_AddFeat(346, sFeatPacks, 100, 0, 5, 6);
    pat_AddFeat(347, sFeatPacks, 100, 0, 7, 8);
    pat_AddFeat(348, sFeatPacks, 100, 0, 9, 10);
    pat_AddFeat(349, sFeatPacks, 100, 0, 11, 12);
    pat_AddFeat(350, sFeatPacks, 100, 0, 13, 14);
    pat_AddFeat(351, sFeatPacks, 100, 0, 15, 16);
    pat_AddFeat(352, sFeatPacks, 100, 0, 17, 18);
    pat_AddFeat(353, sFeatPacks, 100, 0, 19, 20);
    pat_AddFeat(1032, sFeatPacks, 100, 0, 21, 22);
    pat_AddFeat(1033, sFeatPacks, 100, 0, 23, 24);
    pat_AddFeat(1034, sFeatPacks, 100, 0, 25, 26);

/*******************************************************************************
* Weapon Proficiencies & Zen Archery
*******************************************************************************/
    sFeatPacks = ";" +
                 pat_FeatString(PAT_FEATPACK_CLASS_ARCANE_ARCHER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_ASSASSIN) +
                 pat_FeatString(PAT_FEATPACK_CLASS_BARBARIAN) +
                 pat_FeatString(PAT_FEATPACK_CLASS_BARD) +
                 pat_FeatString(PAT_FEATPACK_CLASS_BLACKGUARD) +
                 pat_FeatString(PAT_FEATPACK_CLASS_CLERIC) +
                 pat_FeatString(PAT_FEATPACK_CLASS_DIVINE_CHAMPION) +
                 pat_FeatString(PAT_FEATPACK_CLASS_DRAGON_DISCIPLE) +
                 pat_FeatString(PAT_FEATPACK_CLASS_DRUID) +
                 pat_FeatString(PAT_FEATPACK_CLASS_DWARVEN_DEFENDER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_FIGHTER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_HARPER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_MONK) +
                 pat_FeatString(PAT_FEATPACK_CLASS_PALADIN) +
                 pat_FeatString(PAT_FEATPACK_CLASS_PALE_MASTER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_PURPLE_DRAGON_KNIGHT) +
                 pat_FeatString(PAT_FEATPACK_CLASS_RANGER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_ROGUE) +
                 pat_FeatString(PAT_FEATPACK_CLASS_SHADOWDANCER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_SHIFTER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_SORCERER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_WEAPON_MASTER) +
                 pat_FeatString(PAT_FEATPACK_CLASS_WIZARD);
    pat_AddFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, sFeatPacks, 100, 0, 1);
    pat_AddFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, sFeatPacks, 100, 0, 1);
    pat_AddFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, sFeatPacks, 100, 0, 1);
    pat_AddFeat(FEAT_ZEN_ARCHERY, sFeatPacks, 100, 0, 1);
}
