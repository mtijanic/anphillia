/************************************************************************
 * script name  : pat_ini_base
 * created by   : eyesolated
 * date         : 2018/7/31
 *
 * description  : Base Initialization script for PAT
 *
 * changes      : 2018/7/31 - eyesolated - Initial creation
 ************************************************************************/
#include "pat_inc"

void main()
{
    object oCache = pat_GetCache();
    struct PAT_STRUCT_ROLE stRole;
    int nCR;

    int nStep = GetLocalInt(oCache, PAT_INITIALIZATION_BASE);

    switch (nStep)
    {
        case 0:
            // DPS_Melee_STR
            stRole.Role_ID                      = PAT_ROLE_DPS_MELEE_STR;
            stRole.Role_Name                    = PAT_ROLE_NAME_DPS_MELEE_STR;
            for (nCR = 1; nCR <= PAT_CR_MAXIMUM; nCR++)
            {
                stRole.CR                       = nCR;
                stRole.Ability_STR              = pat_CalculateAbilityScore(nCR, PAT_GAIN_EXTREME);
                stRole.Ability_DEX              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_CON              = pat_CalculateAbilityScore(nCR, PAT_GAIN_HIGH);
                stRole.Ability_WIS              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.Ability_INT              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.Ability_CHA              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.SavingThrow_Fortitude    = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_HIGH);
                stRole.SavingThrow_Reflex       = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_MEDIUM);
                stRole.SavingThrow_Will         = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_LOW);
                stRole.AC                       = pat_CalculateACValue(nCR, PAT_GAIN_MEDIUM);
                stRole.BaseAttackBonus          = pat_CalculateBaseAttackBonus(nCR, PAT_GAIN_HIGH);
                stRole.BaseHitPoints            = pat_CalculateBaseHitPoints(nCR, PAT_GAIN_MEDIUM);
                pat_AddRoleEntry_Struct(stRole);
            }
        break;

        case 1:
            // DPS_Melee_DEX
            stRole.Role_ID                      = PAT_ROLE_DPS_MELEE_DEX;
            stRole.Role_Name                    = PAT_ROLE_NAME_DPS_MELEE_DEX;
            for (nCR = 1; nCR <= PAT_CR_MAXIMUM; nCR++)
            {
                stRole.CR                       = nCR;
                stRole.Ability_STR              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_DEX              = pat_CalculateAbilityScore(nCR, PAT_GAIN_EXTREME);
                stRole.Ability_CON              = pat_CalculateAbilityScore(nCR, PAT_GAIN_HIGH);
                stRole.Ability_WIS              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.Ability_INT              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.Ability_CHA              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.SavingThrow_Fortitude    = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_MEDIUM);
                stRole.SavingThrow_Reflex       = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_HIGH);
                stRole.SavingThrow_Will         = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_LOW);
                stRole.AC                       = pat_CalculateACValue(nCR, PAT_GAIN_MEDIUM);
                stRole.BaseAttackBonus          = pat_CalculateBaseAttackBonus(nCR, PAT_GAIN_HIGH);
                stRole.BaseHitPoints            = pat_CalculateBaseHitPoints(nCR, PAT_GAIN_MEDIUM);
                pat_AddRoleEntry_Struct(stRole);
            }
        break;

        case 2:
            // DPS_Range_DEX
            stRole.Role_ID                      = PAT_ROLE_DPS_RANGE_DEX;
            stRole.Role_Name                    = PAT_ROLE_NAME_DPS_RANGE_DEX;
            for (nCR = 1; nCR <= PAT_CR_MAXIMUM; nCR++)
            {
                stRole.CR                       = nCR;
                stRole.Ability_STR              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_DEX              = pat_CalculateAbilityScore(nCR, PAT_GAIN_EXTREME);
                stRole.Ability_CON              = pat_CalculateAbilityScore(nCR, PAT_GAIN_HIGH);
                stRole.Ability_WIS              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_INT              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.Ability_CHA              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.SavingThrow_Fortitude    = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_MEDIUM);
                stRole.SavingThrow_Reflex       = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_HIGH);
                stRole.SavingThrow_Will         = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_LOW);
                stRole.AC                       = pat_CalculateACValue(nCR, PAT_GAIN_MEDIUM);
                stRole.BaseAttackBonus          = pat_CalculateBaseAttackBonus(nCR, PAT_GAIN_HIGH);
                stRole.BaseHitPoints            = pat_CalculateBaseHitPoints(nCR, PAT_GAIN_MEDIUM);
                pat_AddRoleEntry_Struct(stRole);
            }
        break;

        case 3:
            // DPS_Range_WIS
            stRole.Role_ID                      = PAT_ROLE_DPS_RANGE_WIS;
            stRole.Role_Name                    = PAT_ROLE_NAME_DPS_RANGE_WIS;
            for (nCR = 1; nCR <= PAT_CR_MAXIMUM; nCR++)
            {
                stRole.CR                       = nCR;
                stRole.Ability_STR              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_DEX              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_CON              = pat_CalculateAbilityScore(nCR, PAT_GAIN_HIGH);
                stRole.Ability_WIS              = pat_CalculateAbilityScore(nCR, PAT_GAIN_EXTREME);
                stRole.Ability_INT              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.Ability_CHA              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.SavingThrow_Fortitude    = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_MEDIUM);
                stRole.SavingThrow_Reflex       = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_LOW);
                stRole.SavingThrow_Will         = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_HIGH);
                stRole.AC                       = pat_CalculateACValue(nCR, PAT_GAIN_MEDIUM);
                stRole.BaseAttackBonus          = pat_CalculateBaseAttackBonus(nCR, PAT_GAIN_HIGH);
                stRole.BaseHitPoints            = pat_CalculateBaseHitPoints(nCR, PAT_GAIN_MEDIUM);
                pat_AddRoleEntry_Struct(stRole);
            }
        break;

        case 4:
            // DPS_Caster_INT
            stRole.Role_ID                      = PAT_ROLE_DPS_CASTER_INT;
            stRole.Role_Name                    = PAT_ROLE_NAME_DPS_CASTER_INT;
            for (nCR = 1; nCR <= PAT_CR_MAXIMUM; nCR++)
            {
                stRole.CR                       = nCR;
                stRole.Ability_STR              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.Ability_DEX              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.Ability_CON              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.Ability_WIS              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_INT              = pat_CalculateAbilityScore(nCR, PAT_GAIN_EXTREME);
                stRole.Ability_CHA              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.SavingThrow_Fortitude    = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_LOW);
                stRole.SavingThrow_Reflex       = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_LOW);
                stRole.SavingThrow_Will         = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_HIGH);
                stRole.AC                       = pat_CalculateACValue(nCR, PAT_GAIN_LOW);
                stRole.BaseAttackBonus          = pat_CalculateBaseAttackBonus(nCR, PAT_GAIN_LOW);
                stRole.BaseHitPoints            = pat_CalculateBaseHitPoints(nCR, PAT_GAIN_LOW);
                pat_AddRoleEntry_Struct(stRole);
            }
        break;

        case 5:
            // DPS_Caster_WIS
            stRole.Role_ID                      = PAT_ROLE_DPS_CASTER_WIS;
            stRole.Role_Name                    = PAT_ROLE_NAME_DPS_CASTER_WIS;
            for (nCR = 1; nCR <= PAT_CR_MAXIMUM; nCR++)
            {
                stRole.CR                       = nCR;
                stRole.Ability_STR              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.Ability_DEX              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.Ability_CON              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.Ability_WIS              = pat_CalculateAbilityScore(nCR, PAT_GAIN_EXTREME);
                stRole.Ability_INT              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_CHA              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.SavingThrow_Fortitude    = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_LOW);
                stRole.SavingThrow_Reflex       = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_LOW);
                stRole.SavingThrow_Will         = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_HIGH);
                stRole.AC                       = pat_CalculateACValue(nCR, PAT_GAIN_LOW);
                stRole.BaseAttackBonus          = pat_CalculateBaseAttackBonus(nCR, PAT_GAIN_LOW);
                stRole.BaseHitPoints            = pat_CalculateBaseHitPoints(nCR, PAT_GAIN_LOW);
                pat_AddRoleEntry_Struct(stRole);
            }
        break;

        case 6:
            // DPS_Caster_CHA
            stRole.Role_ID                      = PAT_ROLE_DPS_CASTER_CHA;
            stRole.Role_Name                    = PAT_ROLE_NAME_DPS_CASTER_CHA;
            for (nCR = 1; nCR <= PAT_CR_MAXIMUM; nCR++)
            {
                stRole.CR                       = nCR;
                stRole.Ability_STR              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.Ability_DEX              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_CON              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.Ability_WIS              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_INT              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_CHA              = pat_CalculateAbilityScore(nCR, PAT_GAIN_EXTREME);
                stRole.SavingThrow_Fortitude    = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_LOW);
                stRole.SavingThrow_Reflex       = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_LOW);
                stRole.SavingThrow_Will         = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_HIGH);
                stRole.AC                       = pat_CalculateACValue(nCR, PAT_GAIN_LOW);
                stRole.BaseAttackBonus          = pat_CalculateBaseAttackBonus(nCR, PAT_GAIN_LOW);
                stRole.BaseHitPoints            = pat_CalculateBaseHitPoints(nCR, PAT_GAIN_LOW);
                pat_AddRoleEntry_Struct(stRole);
            }
        break;

        case 7:
            // Heal_WIS
            stRole.Role_ID                      = PAT_ROLE_HEAL_WIS;
            stRole.Role_Name                    = PAT_ROLE_NAME_HEAL_WIS;
            for (nCR = 1; nCR <= PAT_CR_MAXIMUM; nCR++)
            {
                stRole.CR                       = nCR;
                stRole.Ability_STR              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_DEX              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.Ability_CON              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_WIS              = pat_CalculateAbilityScore(nCR, PAT_GAIN_EXTREME);
                stRole.Ability_INT              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_CHA              = pat_CalculateAbilityScore(nCR, PAT_GAIN_HIGH);
                stRole.SavingThrow_Fortitude    = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_MEDIUM);
                stRole.SavingThrow_Reflex       = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_MEDIUM);
                stRole.SavingThrow_Will         = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_MEDIUM);
                stRole.AC                       = pat_CalculateACValue(nCR, PAT_GAIN_MEDIUM);
                stRole.BaseAttackBonus          = pat_CalculateBaseAttackBonus(nCR, PAT_GAIN_LOW);
                stRole.BaseHitPoints            = pat_CalculateBaseHitPoints(nCR, PAT_GAIN_MEDIUM);
                pat_AddRoleEntry_Struct(stRole);
            }
        break;

        case 8:
            // Support_INT
            stRole.Role_ID                      = PAT_ROLE_SUPPORT_INT;
            stRole.Role_Name                    = PAT_ROLE_NAME_SUPPORT_INT;
            for (nCR = 1; nCR <= PAT_CR_MAXIMUM; nCR++)
            {
                stRole.CR                       = nCR;
                stRole.Ability_STR              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_DEX              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_CON              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_WIS              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_INT              = pat_CalculateAbilityScore(nCR, PAT_GAIN_EXTREME);
                stRole.Ability_CHA              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.SavingThrow_Fortitude    = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_MEDIUM);
                stRole.SavingThrow_Reflex       = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_MEDIUM);
                stRole.SavingThrow_Will         = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_MEDIUM);
                stRole.AC                       = pat_CalculateACValue(nCR, PAT_GAIN_MEDIUM);
                stRole.BaseAttackBonus          = pat_CalculateBaseAttackBonus(nCR, PAT_GAIN_MEDIUM);
                stRole.BaseHitPoints            = pat_CalculateBaseHitPoints(nCR, PAT_GAIN_MEDIUM);
                pat_AddRoleEntry_Struct(stRole);
            }
        break;

        case 9:
            // Support_WIS
            stRole.Role_ID                      = PAT_ROLE_SUPPORT_WIS;
            stRole.Role_Name                    = PAT_ROLE_NAME_SUPPORT_WIS;
            for (nCR = 1; nCR <= PAT_CR_MAXIMUM; nCR++)
            {
                stRole.CR                       = nCR;
                stRole.Ability_STR              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_DEX              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_CON              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_WIS              = pat_CalculateAbilityScore(nCR, PAT_GAIN_EXTREME);
                stRole.Ability_INT              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_CHA              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.SavingThrow_Fortitude    = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_MEDIUM);
                stRole.SavingThrow_Reflex       = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_MEDIUM);
                stRole.SavingThrow_Will         = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_MEDIUM);
                stRole.AC                       = pat_CalculateACValue(nCR, PAT_GAIN_MEDIUM);
                stRole.BaseAttackBonus          = pat_CalculateBaseAttackBonus(nCR, PAT_GAIN_MEDIUM);
                stRole.BaseHitPoints            = pat_CalculateBaseHitPoints(nCR, PAT_GAIN_MEDIUM);
                pat_AddRoleEntry_Struct(stRole);
            }
        break;

        case 10:
            // Support_CHA
            stRole.Role_ID                      = PAT_ROLE_SUPPORT_CHA;
            stRole.Role_Name                    = PAT_ROLE_NAME_SUPPORT_CHA;
            for (nCR = 1; nCR <= PAT_CR_MAXIMUM; nCR++)
            {
                stRole.CR                       = nCR;
                stRole.Ability_STR              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_DEX              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_CON              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_WIS              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_INT              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_CHA              = pat_CalculateAbilityScore(nCR, PAT_GAIN_EXTREME);
                stRole.SavingThrow_Fortitude    = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_MEDIUM);
                stRole.SavingThrow_Reflex       = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_MEDIUM);
                stRole.SavingThrow_Will         = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_MEDIUM);
                stRole.AC                       = pat_CalculateACValue(nCR, PAT_GAIN_MEDIUM);
                stRole.BaseAttackBonus          = pat_CalculateBaseAttackBonus(nCR, PAT_GAIN_MEDIUM);
                stRole.BaseHitPoints            = pat_CalculateBaseHitPoints(nCR, PAT_GAIN_MEDIUM);
                pat_AddRoleEntry_Struct(stRole);
            }
        break;

        case 11:
            // Tank_STR
            stRole.Role_ID                      = PAT_ROLE_TANK_STR;
            stRole.Role_Name                    = PAT_ROLE_NAME_TANK_STR;
            for (nCR = 1; nCR <= PAT_CR_MAXIMUM; nCR++)
            {
                stRole.CR                       = nCR;
                stRole.Ability_STR              = pat_CalculateAbilityScore(nCR, PAT_GAIN_HIGH);
                stRole.Ability_DEX              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.Ability_CON              = pat_CalculateAbilityScore(nCR, PAT_GAIN_EXTREME);
                stRole.Ability_WIS              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_INT              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_CHA              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.SavingThrow_Fortitude    = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_HIGH);
                stRole.SavingThrow_Reflex       = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_LOW);
                stRole.SavingThrow_Will         = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_LOW);
                stRole.AC                       = pat_CalculateACValue(nCR, PAT_GAIN_HIGH);
                stRole.BaseAttackBonus          = pat_CalculateBaseAttackBonus(nCR, PAT_GAIN_MEDIUM);
                stRole.BaseHitPoints            = pat_CalculateBaseHitPoints(nCR, PAT_GAIN_HIGH);
                pat_AddRoleEntry_Struct(stRole);
            }
        break;
        case 12:
            // Naked_DPS_STR
            stRole.Role_ID                      = PAT_ROLE_NAKED_DPS_STR;
            stRole.Role_Name                    = PAT_ROLE_NAME_NAKED_DPS_STR;
            for (nCR = 1; nCR <= PAT_CR_MAXIMUM; nCR++)
            {
                stRole.CR                       = nCR;
                stRole.Ability_STR              = pat_CalculateAbilityScore(nCR, PAT_GAIN_EXTREME);
                stRole.Ability_DEX              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_CON              = pat_CalculateAbilityScore(nCR, PAT_GAIN_HIGH);
                stRole.Ability_WIS              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.Ability_INT              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.Ability_CHA              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.SavingThrow_Fortitude    = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_HIGH);
                stRole.SavingThrow_Reflex       = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_MEDIUM);
                stRole.SavingThrow_Will         = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_LOW);
                stRole.AC                       = pat_CalculateACValue(nCR, PAT_GAIN_MEDIUM);
                stRole.BaseAttackBonus          = pat_CalculateBaseAttackBonus(nCR, PAT_GAIN_HIGH);
                stRole.BaseHitPoints            = pat_CalculateBaseHitPoints(nCR, PAT_GAIN_MEDIUM);
                pat_AddRoleEntry_Struct(stRole);
            }
        break;
        case 13:
            // Naked_DPS_DEX
            stRole.Role_ID                      = PAT_ROLE_NAKED_DPS_DEX;
            stRole.Role_Name                    = PAT_ROLE_NAME_NAKED_DPS_DEX;
            for (nCR = 1; nCR <= PAT_CR_MAXIMUM; nCR++)
            {
                stRole.CR                       = nCR;
                stRole.Ability_STR              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_DEX              = pat_CalculateAbilityScore(nCR, PAT_GAIN_EXTREME);
                stRole.Ability_CON              = pat_CalculateAbilityScore(nCR, PAT_GAIN_HIGH);
                stRole.Ability_WIS              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.Ability_INT              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.Ability_CHA              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.SavingThrow_Fortitude    = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_MEDIUM);
                stRole.SavingThrow_Reflex       = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_HIGH);
                stRole.SavingThrow_Will         = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_LOW);
                stRole.AC                       = pat_CalculateACValue(nCR, PAT_GAIN_MEDIUM);
                stRole.BaseAttackBonus          = pat_CalculateBaseAttackBonus(nCR, PAT_GAIN_HIGH);
                stRole.BaseHitPoints            = pat_CalculateBaseHitPoints(nCR, PAT_GAIN_MEDIUM);
                pat_AddRoleEntry_Struct(stRole);
            }
        break;
        case 14:
            // Naked_TANK_STR
            stRole.Role_ID                      = PAT_ROLE_NAKED_TANK_STR;
            stRole.Role_Name                    = PAT_ROLE_NAME_NAKED_TANK_STR;
            for (nCR = 1; nCR <= PAT_CR_MAXIMUM; nCR++)
            {
                stRole.CR                       = nCR;
                stRole.Ability_STR              = pat_CalculateAbilityScore(nCR, PAT_GAIN_HIGH);
                stRole.Ability_DEX              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.Ability_CON              = pat_CalculateAbilityScore(nCR, PAT_GAIN_EXTREME);
                stRole.Ability_WIS              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_INT              = pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
                stRole.Ability_CHA              = pat_CalculateAbilityScore(nCR, PAT_GAIN_LOW);
                stRole.SavingThrow_Fortitude    = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_HIGH);
                stRole.SavingThrow_Reflex       = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_LOW);
                stRole.SavingThrow_Will         = pat_CalculateSavingThrowValue(nCR, PAT_GAIN_LOW);
                stRole.AC                       = pat_CalculateACValue(nCR, PAT_GAIN_HIGH);
                stRole.BaseAttackBonus          = pat_CalculateBaseAttackBonus(nCR, PAT_GAIN_MEDIUM);
                stRole.BaseHitPoints            = pat_CalculateBaseHitPoints(nCR, PAT_GAIN_HIGH);
                pat_AddRoleEntry_Struct(stRole);
            }
        break;

        case 15:
            return;
    }

    SetLocalInt(oCache, PAT_INITIALIZATION_BASE, nStep + 1);
    DelayCommand(0.1f, ExecuteScript("pat_ini_base", OBJECT_SELF));
}

