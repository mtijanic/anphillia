/************************************************************************
 * script name  : pat_ini_skillset
 * created by   : eyesolated
 * date         : 2018/7/31
 *
 * description  : Skillset Initialization script for PAT
 *
 * changes      : 2018/7/31 - eyesolated - Initial creation
 ************************************************************************/
#include "pat_inc"
#include "x0_i0_stringlib"

string pat_SkillString(int nSkill)
{
    return (IntToString(nSkill) + ";");
}

void main()
{
    // Generic Melee DPS Skillset
    pat_AddSkillset(PAT_SKILLSET_DPS_MELEE_GENERIC,
                    "",
                    pat_SkillString(SKILL_DISCIPLINE),
                    pat_SkillString(SKILL_TUMBLE),
                    "");

    // Generic Range DPS Skillset
    pat_AddSkillset(PAT_SKILLSET_DPS_RANGE_GENERIC,
                    "",
                    pat_SkillString(SKILL_DISCIPLINE) + pat_SkillString(SKILL_TUMBLE),
                    "",
                    "");

    // Generic Caster DPS Skillset
    pat_AddSkillset(PAT_SKILLSET_DPS_CASTER_GENERIC,
                    pat_SkillString(SKILL_CONCENTRATION) + pat_SkillString(SKILL_SPELLCRAFT),
                    "",
                    "",
                    "");

    // Generic Heal Skillset
    pat_AddSkillset(PAT_SKILLSET_HEAL_GENERIC,
                    pat_SkillString(SKILL_HEAL) + pat_SkillString(SKILL_CONCENTRATION),
                    pat_SkillString(SKILL_DISCIPLINE),
                    pat_SkillString(SKILL_SPELLCRAFT),
                    "");

    // Generic Support Skillset
    pat_AddSkillset(PAT_SKILLSET_SUPPORT_GENERIC,
                    pat_SkillString(SKILL_CONCENTRATION),
                    pat_SkillString(SKILL_SPELLCRAFT),
                    pat_SkillString(SKILL_DISCIPLINE) + pat_SkillString(SKILL_TUMBLE),
                    "");

    // Generic Tank Skillset
    pat_AddSkillset(PAT_SKILLSET_TANK_GENERIC,
                    pat_SkillString(SKILL_DISCIPLINE) + pat_SkillString(SKILL_INTIMIDATE),
                    pat_SkillString(SKILL_TUMBLE) + pat_SkillString(SKILL_TAUNT),
                    "",
                    "");

    // Rogue Skillset
    pat_AddSkillset(PAT_SKILLSET_ROGUE,
                    pat_SkillString(SKILL_HIDE) + pat_SkillString(SKILL_MOVE_SILENTLY),
                    pat_SkillString(SKILL_TUMBLE),
                    pat_SkillString(SKILL_DISCIPLINE),
                    "");
}
