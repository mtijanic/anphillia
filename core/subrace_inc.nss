#include "nwnx_creature"

int subrace_Apply(object oPC, string sSubrace)
{
    int bMatched = FALSE;
    // Halfling
    if (sSubrace == "Tallfellow")
    {
        if (GetRacialType(oPC) != RACIAL_TYPE_HALFLING)
            return FALSE;

        NWNX_Creature_RemoveFeat(oPC, FEAT_SKILL_AFFINITY_MOVE_SILENTLY);
        NWNX_Creature_AddFeat(oPC, FEAT_SKILL_AFFINITY_SPOT);
        NWNX_Creature_AddFeat(oPC, FEAT_SKILL_AFFINITY_SEARCH);
        bMatched = TRUE;
    }
    if (sSubrace == "Lightfoot")
    {
        if (GetRacialType(oPC) != RACIAL_TYPE_HALFLING)
            return FALSE;

        NWNX_Creature_RemoveFeat(oPC, FEAT_SKILL_AFFINITY_LISTEN);
        NWNX_Creature_SetSkillRank(oPC, SKILL_MOVE_SILENTLY, GetSkillRank(SKILL_MOVE_SILENTLY, oPC, TRUE) + 2);
        bMatched = TRUE;
    }

    // Elf
    if (sSubrace == "Drow")
    {
        if (GetRacialType(oPC) != RACIAL_TYPE_ELF)
            return FALSE;

        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, 2);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_STRENGTH, -2);
        NWNX_Creature_AddFeat(oPC, FEAT_DARKVISION);
        NWNX_Creature_AddFeat(oPC, FEAT_HARDINESS_VERSUS_SPELLS);
        bMatched = TRUE;
    }
    if (sSubrace == "Moon Elf")
    {
        if (GetRacialType(oPC) != RACIAL_TYPE_ELF)
            return FALSE;

        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, 2);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_STRENGTH, -2);
        bMatched = TRUE;
    }
    if (sSubrace == "Wild Elf")
    {
        if (GetRacialType(oPC) != RACIAL_TYPE_ELF)
            return FALSE;

        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, 2);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, -2);
        bMatched = TRUE;
    }
    if (sSubrace == "Wood Elf")
    {
        if (GetRacialType(oPC) != RACIAL_TYPE_ELF)
            return FALSE;

        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_STRENGTH, 2);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, -2);
        bMatched = TRUE;
    }

    // Half-Elf
    if (sSubrace == "Half-Drow")
    {
        if (GetRacialType(oPC) != RACIAL_TYPE_HALFELF)
            return FALSE;

        NWNX_Creature_AddFeat(oPC, FEAT_DARKVISION);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_INTELLIGENCE, 2);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CONSTITUTION, -2);
        bMatched = TRUE;
    }

    // Human
    if (sSubrace == "Nordsman")
    {
        if (GetRacialType(oPC) != RACIAL_TYPE_HUMAN)
            return FALSE;

        NWNX_Creature_AddFeat(oPC, FEAT_BATTLE_TRAINING_VERSUS_GIANTS);
        NWNX_Creature_SetSkillRank(oPC, SKILL_APPRAISE,   GetSkillRank(SKILL_APPRAISE, oPC, TRUE) - 1);
        NWNX_Creature_SetSkillRank(oPC, SKILL_SPELLCRAFT, GetSkillRank(SKILL_SPELLCRAFT, oPC, TRUE) - 1);
        NWNX_Creature_SetSkillRank(oPC, SKILL_LORE,       GetSkillRank(SKILL_LORE, oPC, TRUE) - 1);
        bMatched = TRUE;
    }
    if (sSubrace == "Highlander")
    {
        if (GetRacialType(oPC) != RACIAL_TYPE_HUMAN)
            return FALSE;

        NWNX_Creature_AddFeat(oPC, FEAT_FEARLESS);
        NWNX_Creature_SetSkillRank(oPC, SKILL_PICK_POCKET, GetSkillRank(SKILL_PICK_POCKET, oPC, TRUE) - 2);
        NWNX_Creature_SetSkillRank(oPC, SKILL_OPEN_LOCK,   GetSkillRank(SKILL_OPEN_LOCK, oPC, TRUE) - 2);
        bMatched = TRUE;
    }
    if (sSubrace == "Illumiam")
    {
        if (GetRacialType(oPC) != RACIAL_TYPE_HUMAN)
            return FALSE;

        NWNX_Creature_AddFeat(oPC, FEAT_SKILL_AFFINITY_LORE);
        NWNX_Creature_SetSkillRank(oPC, SKILL_DISCIPLINE, GetSkillRank(SKILL_DISCIPLINE, oPC, TRUE) - 1);
        NWNX_Creature_SetSkillRank(oPC, SKILL_TUMBLE,     GetSkillRank(SKILL_TUMBLE, oPC, TRUE) - 1);
        bMatched = TRUE;
    }
    if (sSubrace == "Deep Imaskari")
    {
        if (GetRacialType(oPC) != RACIAL_TYPE_HUMAN)
            return FALSE;

        NWNX_Creature_AddFeat(oPC, FEAT_LOWLIGHTVISION);
        NWNX_Creature_SetSkillRank(oPC, SKILL_LISTEN, GetSkillRank(SKILL_LISTEN, oPC, TRUE) - 2);
        bMatched = TRUE;
    }

    // Half-orc
    if (sSubrace == "Red Tribe Offspring")
    {
        if (GetRacialType(oPC) != RACIAL_TYPE_HALFORC)
            return FALSE;

        NWNX_Creature_RemoveFeat(oPC, FEAT_DARKVISION);
        NWNX_Creature_AddFeat(oPC, FEAT_LOWLIGHTVISION);
        NWNX_Creature_AddFeat(oPC, FEAT_FEARLESS);
        bMatched = TRUE;
    }

    // Dwarf
    if (sSubrace == "Gold Dwarf")
    {
        if (GetRacialType(oPC) != RACIAL_TYPE_DWARF)
            return FALSE;

        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, 2);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, -2);
        NWNX_Creature_AddFeat(oPC, FEAT_SKILL_AFFINITY_CONCENTRATION);
        NWNX_Creature_RemoveFeat(oPC, FEAT_BATTLE_TRAINING_VERSUS_ORCS);
        NWNX_Creature_RemoveFeat(oPC, FEAT_BATTLE_TRAINING_VERSUS_GOBLINS);
        NWNX_Creature_AddFeat(oPC, FEAT_BATTLE_TRAINING_VERSUS_REPTILIANS);
        bMatched = TRUE;
    }
    if (sSubrace == "Dream Dwarf")
    {
        if (GetRacialType(oPC) != RACIAL_TYPE_DWARF)
            return FALSE;

        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, 2);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, -2);
        NWNX_Creature_RemoveFeat(oPC, FEAT_BATTLE_TRAINING_VERSUS_ORCS);
        NWNX_Creature_RemoveFeat(oPC, FEAT_BATTLE_TRAINING_VERSUS_GOBLINS);
        NWNX_Creature_AddFeat(oPC, FEAT_SPELL_FOCUS_DIVINATION);
        bMatched = TRUE;
    }
    if (sSubrace == "Duergar")
    {
        if (GetRacialType(oPC) != RACIAL_TYPE_DWARF)
            return FALSE;

        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, -2);
        NWNX_Creature_AddFeat(oPC, FEAT_SKILL_AFFINITY_MOVE_SILENTLY);
        NWNX_Creature_AddFeat(oPC, FEAT_PARTIAL_SKILL_AFFINITY_SPOT);
        NWNX_Creature_AddFeat(oPC, FEAT_PARTIAL_SKILL_AFFINITY_LISTEN);
        NWNX_Creature_AddFeat(oPC, FEAT_DIAMOND_BODY);
        bMatched = TRUE;
    }

    if (sSubrace == "Whisper Gnome")
    {
        if (GetRacialType(oPC) != RACIAL_TYPE_GNOME)
            return FALSE;

        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_DEXTERITY, 2);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, -2);
        NWNX_Creature_AddFeat(oPC, FEAT_DARKVISION);
        NWNX_Creature_AddFeat(oPC, FEAT_SKILL_AFFINITY_SPOT);
        NWNX_Creature_RemoveFeat(oPC, FEAT_HARDINESS_VERSUS_ILLUSIONS);
        NWNX_Creature_RemoveFeat(oPC, FEAT_SPELL_FOCUS_ILLUSION);
        bMatched = TRUE;
    }
    if (sSubrace == "Svirfneblin")
    {
        if (GetRacialType(oPC) != RACIAL_TYPE_GNOME)
            return FALSE;

        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_WISDOM, 2);
        NWNX_Creature_ModifyRawAbilityScore(oPC, ABILITY_CHARISMA, -2);
        NWNX_Creature_SetSkillRank(oPC, SKILL_HIDE, GetSkillRank(SKILL_HIDE, oPC, TRUE) + 2);
        NWNX_Creature_AddFeat(oPC, FEAT_DARKVISION);
        bMatched = TRUE;
    }

    SetSubRace(oPC, sSubrace);
    ExportSingleCharacter(oPC);
    FloatingTextStringOnCreature("Subrace bonuses applied.", oPC);
    return bMatched;
}
