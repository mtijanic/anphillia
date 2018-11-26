#include "x2_inc_spellhook"
#include "x2_inc_switches"
#include "spell_inc"
#include "nwnx_creature"

void main()
{
    // eyesolated spell macros script
    ExecuteScript("esm_spuserdef", OBJECT_SELF);

    int nSpellID   = GetSpellId();
    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetCasterLevel(oCaster);
    int nMetaMagic = GetMetaMagicFeat();




    if (spell_GetLevel(nSpellID, GetLastSpellCastClass()) == 0)
        NWNX_Creature_RestoreSpells(oCaster, 0);

    // Special spell failure conditions
    switch (nSpellID)
    {
        case SPELL_CALL_LIGHTNING:
            if (GetIsAreaInterior(GetArea(oCaster)))
            {
                FloatingTextStringOnCreature("You cannot cast this spell indoors.", oCaster);
                SetModuleOverrideSpellScriptFinished();
                return;
            }
            break;
    }

    // Custom spells not using Bioware implementation
    switch (nSpellID)
    {
        case SPELL_MAGIC_WEAPON:
        case SPELL_GREATER_MAGIC_WEAPON:
        case SPELL_DARKFIRE:
        case SPELL_BLADE_THIRST:
        case SPELL_FLAME_WEAPON:
            ExecuteScript("spell_weapon", OBJECT_SELF);
            SetModuleOverrideSpellScriptFinished();
            break;
        case SPELL_MAGIC_MISSILE:
        case SPELL_SHADOW_CONJURATION_MAGIC_MISSILE:
        case SPELL_ISAACS_LESSER_MISSILE_STORM:
        case SPELL_ISAACS_GREATER_MISSILE_STORM:
        case SPELL_BALL_LIGHTNING:
        case SPELL_FLAME_ARROW:
        case SPELL_FIREBRAND:
//        case SPELL_MELFS_ACID_ARROW:
//        case SPELL_GREATER_SHADOW_CONJURATION_ACID_ARROW:
            ExecuteScript("spell_missile", OBJECT_SELF);
            SetModuleOverrideSpellScriptFinished();
            break;
    }
}

