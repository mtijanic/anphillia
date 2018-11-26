/************************************************************************
 * script name  : pat_inc
 * created by   : eyesolated
 * date         : 2018/7/31
 *
 * description  : Include script for PAT
 *
 * changes      : 2018/7/31 - eyesolated - Initial creation
 ************************************************************************/
#include "pat_cfg"
#include "sql_inc"
#include "nwnx_creature"
#include "x0_i0_stringlib"
#include "lgs_inc"

// Creates the database tables used by PAT
void pat_CreateTables();

// Returns FALSE if any of the required PAT Tables is missing
int pat_GetTablesExist();

// Drops all PAT Tables
void pat_DropTables();

// Clears the CR Cache of all areas
void pat_ClearAreaCache();

// Inserts new Areas into PAT_TABLE_AREAS and removes areas that are no longer
// existing
void pat_UpdateAreasTable();

// Returns the ID of Role sRoleName. Returns 0 on error
int pat_GetRole_ID(string sRole_Name);

// Returns the Name of Role nRoleID. Returns an empty string on error
string pat_GetRole_Name(int nRole_ID);

// Adds an area into the PAT Database
void pat_AddArea(string sResRef, string sTag, string sName, int nCR);

// Adds a Role Entry to PAT
void pat_AddRoleEntry(int nRole_ID, string sRole_Name, int nCR, int nAbility_STR, int nAbility_DEX, int nAbility_CON, int nAbility_WIS, int nAbility_INT, int nAbility_CHA, int nSavingThrow_Fortitude, int nSavingThrow_Reflex, int nSavingThrow_Will, int nAC, int nBaseAttackBonus, int nBaseHitPoints);

// Retrieves a Role Entry from the database
struct PAT_STRUCT_ROLE pat_GetRoleEntryByID(int nRole_ID, int nCR);

// Retrieves a Role Entry from the database
struct PAT_STRUCT_ROLE pat_GetRoleEntryByName(string sRole_Name, int nCR);

// Adds a Class Setup
// nRole_ID:        The Role ID that will have access to this Class Setup
// nClass_1:        The first class to use in this setup (CLASS_TYPE_*)
// nClass_2:        The second class to use in this setup (CLASS_TYPE_*)
// nClass_3:        The third class to use in this setup (CLASS_TYPE_*)
// nSpell_Source:   Bitmask of PAT_SPELL_SOURCE_* the setup should use
// nSpell_Category: Bitmask of PAT_SPELL_CATEGORY_* the setup should use
// nFeat_PAck:      The Feat Pack to use in this setup
// nSkillset:       The Skillset to use in this setup
void pat_AddClassSetup(int nRole_ID, int nClass_1, int nClass_2, int nClass_3, int nSpell_Source, int nSpell_Category, int nFeat_Pack, int nSkillset);

// Retrieves a Class Setup
// nRole_ID:    The Role ID to use in searching a Class Setup
// nClass_1:    The Class that the Setup should use in first position. -1 for "any class"
// nClass_2:    The Class that the Setup should use in second position. -1 for "any class"
// nClass_3:    The Class that the Setup should use in third position. -1 for "any class"
//
// Returns an empty struct if no matching Setup is found
struct PAT_STRUCT_CLASS_SETUP pat_GetClassSetup(int nRole_ID, int nClass_1 = -1, int nClass_2 = -1, int nClass_3 = -1);

// Adds a spell to the list of available spells
// nSpell_ID:       SPELL_*
// nSpell_Level:    The level of the spell
// nSource:         PAT_SPELL_SOURCE_*
// nCategory:       PAT_SPELL_CATEGORY_*
// nTarget:         PAT_SPELL_TARGET_*
// nCR_Minimum:     The minimum CR needed to have access to this spell
void pat_AddSpell(int nSpell_ID, int nSpell_Level, int nSource, int nCategory, int nTarget, int nCR_Minimum);

// Adds a feat to the list of available Feats
// nFeat_ID:            FEAT_*
// sPAcks:              The Packs that use this Feat (eg "0;" or "2;4;")
// nChance_Base:        The base chance of a mob taking this feat
// nChance_Modifier:    Added chance / CR of a mob taking this feat
// nCR_Minimum:         The minimum CR required to use this feat
// nCR_Maximum:         The maximum CR allowed to use this feat
void pat_AddFeat(int nFeat_ID, string sPacks, int nChance_Base, int nChance_Modifier, int nCR_Minimum, int nCR_Maximum = PAT_CR_MAXIMUM);

// Add a skill set
void pat_AddSkillset(int nID, string sSkills_Extreme, string sSkills_High, string sSkills_Medium, string sSkills_Low);

// Returns the ability score for nCR at nGain_Rate. See PAT_GAIN_* for available values
int pat_CalculateAbilityScore(int nCR, int nGain_Rate);

// Returns the Saving Throw score for nCR at nGain_Rate. See PAT_GAIN_* for available values
int pat_CalculateSavingThrowValue(int nCR, int nGain_Rate);

// Returns the Armor Class value for nCR at nGain_Rate. See PAT_GAIN_* for available values
int pat_CalculateACValue(int nCR, int nGain_Rate);

// Returns the base attack bonus for nCR at nGain_Rate. See PAT_GAIN_* for available values
int pat_CalculateBaseAttackBonus(int nCR, int nGain_Rate);

// Returns the Base hit points for nCR at nGain_Rate. See PAT_GAIN_* for available values
int pat_CalculateBaseHitPoints(int nCR, int nGain_Rate);

// Applies PAT to oCreature
// If you set nCR to anything but 0, PAT will skip CR Detection and use the provided value
// If you set nRole_ID to anything but PAT_ROLE_UNDEFINED, PAT will skip Role detection and use the provided value
int pat_Apply(object oCreature, int nCR = 0, int nRole_ID = PAT_ROLE_UNDEFINED);

////////////////////////////////////////////////////////////////////////////////
// Function implementation
//////////////////////////

// internal functions

object pat_GetCache()
{
    object oCache = GetLocalObject(GetModule(), PAT_CACHE);
    if (!GetIsObjectValid(oCache))
    {
        oCache = GetObjectByTag(PAT_CACHE);
        SetLocalObject(GetModule(), PAT_CACHE, oCache);
    }
    return oCache;
}

// This method selects a random specific Role if a generic Role is given
int pat_Verify_Role_ID(int nRole_ID)
{
    int nSpecific;
    switch (nRole_ID)
    {
        case PAT_ROLE_DPS:
            nSpecific = Random(7);
            switch (nSpecific)
            {
                case 0: nRole_ID = PAT_ROLE_DPS_MELEE_STR; break;
                case 1: nRole_ID = PAT_ROLE_DPS_MELEE_DEX; break;
                case 2: nRole_ID = PAT_ROLE_DPS_RANGE_DEX; break;
                case 3: nRole_ID = PAT_ROLE_DPS_RANGE_WIS; break;
                case 4: nRole_ID = PAT_ROLE_DPS_CASTER_INT; break;
                case 5: nRole_ID = PAT_ROLE_DPS_CASTER_WIS; break;
                case 6: nRole_ID = PAT_ROLE_DPS_CASTER_CHA; break;
            }
            break;
        case PAT_ROLE_DPS_MELEE:
            nSpecific = Random(2);
            switch (nSpecific)
            {
                case 0: nRole_ID = PAT_ROLE_DPS_MELEE_STR; break;
                case 1: nRole_ID = PAT_ROLE_DPS_MELEE_DEX; break;
            }
            break;
        case PAT_ROLE_DPS_RANGE:
            nSpecific = Random(2);
            switch (nSpecific)
            {
                case 0: nRole_ID = PAT_ROLE_DPS_RANGE_DEX; break;
                case 1: nRole_ID = PAT_ROLE_DPS_RANGE_WIS; break;
            }
            break;
        case PAT_ROLE_DPS_CASTER:
            nSpecific = Random(3);
            switch (nSpecific)
            {
                case 0: nRole_ID = PAT_ROLE_DPS_CASTER_INT; break;
                case 1: nRole_ID = PAT_ROLE_DPS_CASTER_WIS; break;
                case 2: nRole_ID = PAT_ROLE_DPS_CASTER_CHA; break;
            }
            break;
        case PAT_ROLE_HEAL:
            nRole_ID = PAT_ROLE_HEAL_WIS;
            break;
        case PAT_ROLE_SUPPORT:
            nSpecific = Random(3);
            switch (nSpecific)
            {
                case 0: nRole_ID = PAT_ROLE_SUPPORT_INT; break;
                case 1: nRole_ID = PAT_ROLE_SUPPORT_WIS; break;
                case 2: nRole_ID = PAT_ROLE_SUPPORT_CHA; break;
            }
            break;
        case PAT_ROLE_TANK:
            nRole_ID = PAT_ROLE_TANK_STR;
            break;
        case PAT_ROLE_NAKED:
            nSpecific = Random(3);
            switch (nSpecific)
            {
                case 0: nRole_ID = PAT_ROLE_NAKED_DPS_STR; break;
                case 1: nRole_ID = PAT_ROLE_NAKED_DPS_DEX; break;
                case 2: nRole_ID = PAT_ROLE_NAKED_TANK_STR; break;
            }
            break;
        case PAT_ROLE_NAKED_DPS:
            nSpecific = Random(2);
            switch (nSpecific)
            {
                case 0: nRole_ID = PAT_ROLE_NAKED_DPS_STR; break;
                case 1: nRole_ID = PAT_ROLE_NAKED_DPS_DEX; break;
            }
            break;
        case PAT_ROLE_NAKED_TANK:
            nRole_ID = PAT_ROLE_NAKED_TANK_STR;
            break;
    }

    return nRole_ID;
}

string pat_Verify_Role_Name(string sName)
{
    if (sName == PAT_ROLE_NAME_DPS)
        return (pat_GetRole_Name(pat_Verify_Role_ID(PAT_ROLE_DPS)));
    else if (sName == PAT_ROLE_NAME_DPS_MELEE)
        return (pat_GetRole_Name(pat_Verify_Role_ID(PAT_ROLE_DPS_MELEE)));
    else if (sName == PAT_ROLE_NAME_DPS_CASTER)
        return (pat_GetRole_Name(pat_Verify_Role_ID(PAT_ROLE_DPS_CASTER)));
    else if (sName == PAT_ROLE_NAME_HEAL)
        return (pat_GetRole_Name(pat_Verify_Role_ID(PAT_ROLE_HEAL)));
    else if (sName == PAT_ROLE_NAME_SUPPORT)
        return (pat_GetRole_Name(pat_Verify_Role_ID(PAT_ROLE_SUPPORT)));
    else if (sName == PAT_ROLE_NAME_TANK)
        return (pat_GetRole_Name(pat_Verify_Role_ID(PAT_ROLE_TANK)));
    else if (sName == PAT_ROLE_NAME_NAKED)
        return (pat_GetRole_Name(pat_Verify_Role_ID(PAT_ROLE_NAKED)));
    else if (sName == PAT_ROLE_NAME_NAKED_DPS)
        return (pat_GetRole_Name(pat_Verify_Role_ID(PAT_ROLE_NAKED_DPS)));
    else if (sName == PAT_ROLE_NAME_NAKED_TANK)
        return (pat_GetRole_Name(pat_Verify_Role_ID(PAT_ROLE_NAKED_TANK)));
    else
        return sName;
}

void pat_ClearAreaCache()
{
    object oArea = GetFirstArea();
    while (GetIsObjectValid(oArea))
    {
        DeleteLocalInt(oArea, PAT_VAR_CR_DB);
        oArea = GetNextArea();
    }
}

void pat_UpdateAreasTable()
{
    string sResRef;
    string sTag;
    string sName;
    string sResRefs = "";
    string sQuery;
    object oArea = GetFirstArea();
    int n = 0;
    while (GetIsObjectValid(oArea))
    {
        n++;
        sResRef = GetResRef(oArea);
        sTag = GetTag(oArea);
        sName = GetName(oArea);
        sResRefs += "'" + sResRef + "', ";
        NWNX_SQL_PrepareQuery("INSERT INTO " + PAT_TABLE_AREAS + " (ResRef, Tag, Name) VALUES (?,?,?)");
        NWNX_SQL_PreparedString(0, sResRef);
        NWNX_SQL_PreparedString(1, sTag);
        NWNX_SQL_PreparedString(2, sName);
        if (!NWNX_SQL_ExecutePreparedQuery())
        {
            // INSERT failed, run an UPDATE for the ResRef
            NWNX_SQL_PrepareQuery("UPDATE " + PAT_TABLE_AREAS + " SET Tag = ?, Name = ? WHERE ResRef = ?");
            NWNX_SQL_PreparedString(0, sTag);
            NWNX_SQL_PreparedString(1, sName);
            NWNX_SQL_PreparedString(2, sResRef);
            NWNX_SQL_ExecutePreparedQuery();
        }

        oArea = GetNextArea();
    }

    sResRefs = GetStringLeft(sResRefs, GetStringLength(sResRefs) - 2);
    sQuery = "DELETE FROM " + PAT_TABLE_AREAS + " WHERE ResRef NOT IN (" + sResRefs + ")";
    NWNX_SQL_ExecuteQuery(sQuery);
}

int pat_GetCreatureCR(object oCreature)
{
    // Retrieve a possibly set CR from the creature
    int nCR = GetLocalInt(oCreature, PAT_VAR_CR);

    // If no CR was set on the creature, try to find the db value for the current
    // area
    object oArea = GetArea(oCreature);
    if (nCR == 0)
    {
        nCR = GetLocalInt(oArea, PAT_VAR_CR_DB);
        // If there is no CR here, try to get it from the database
        if (nCR == 0)
        {
            string sQuery = "SELECT CR FROM " + PAT_TABLE_AREAS + " WHERE ResRef = '" + GetResRef(oArea) + "'";
            NWNX_SQL_ExecuteQuery(sQuery);
            if (NWNX_SQL_ReadyToReadNextRow())
            {
                NWNX_SQL_ReadNextRow();
                nCR = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
                SetLocalInt(oArea, PAT_VAR_CR_DB, nCR);
            }
            else
                SetLocalInt(oArea, PAT_VAR_CR_DB, -1);
        }

        if (nCR == -1) // No entry in DB or DB set to -1
            nCR = 0;
    }

    // If no CR was not set on the creature / in the DB, retrieve the one on the area
    if (nCR == 0)
        nCR = GetLocalInt(oArea, PAT_VAR_CR);

    // If CR is still 0, return here
    if (nCR == 0)
        return nCR;

    int nModifier = GetLocalInt(oCreature, PAT_VAR_CR_MODIFIER);
    if (nModifier != 0)
        nCR += nModifier;

    if (PAT_AUTO_CR_ENABLE)
    {
        string sName;
        // If the creature uses our suffixes in it's name, rename them
        sName = GetName(oCreature);
        if (GetStringRight(sName, 6) == " Elite")
            SetName(oCreature, GetStringLeft(sName, GetStringLength(sName) - 6));
        else if (GetStringRight(sName, 9) == " Champion")
            SetName(oCreature, GetStringLeft(sName, GetStringLength(sName) - 9));

        int nElite = d100();
        if (nElite <= PAT_AUTO_CR_CHANCE_CHAMPION)
        {
            sName = GetLocalString(oCreature, PAT_VAR_NAME_CHAMPION);
            if (sName == "")
                sName = GetName(oCreature) + " Champion";
            SetName(oCreature, sName);
            nCR += PAT_AUTO_CR_MODIFIER_CHAMPION;
        }
        else if (nElite <= PAT_AUTO_CR_CHANCE_CHAMPION + PAT_AUTO_CR_CHANCE_ELITE)
        {
            sName = GetLocalString(oCreature, PAT_VAR_NAME_ELITE);
            if (sName == "")
                sName = GetName(oCreature) + " Elite";
            SetName(oCreature, sName);
            nCR += PAT_AUTO_CR_MODIFIER_ELITE;
        }
    }

    if (nCR > PAT_CR_MAXIMUM)
        nCR =PAT_CR_MAXIMUM;

    return nCR;
}

int pat_GetHighestCreatureClass(object oCreature)
{
    int nHighestLevel = 0;
    int nHighestClass = CLASS_TYPE_FIGHTER; // Default
    int nClass;
    int nNew;
    int nCurrent;
    for (nCurrent = 1; nCurrent <=3; nCurrent++)
    {
        nClass = GetClassByPosition(nCurrent, oCreature);
        // Unsupported class? These classes are not evaluated in regards to
        // highest class because they are not a class in the sense of representing
        // an archetype.
        switch (nClass)
        {
            case CLASS_TYPE_INVALID: continue;
            case CLASS_TYPE_COMMONER:
            case CLASS_TYPE_CONSTRUCT:
            case CLASS_TYPE_EYE_OF_GRUUMSH:
            case CLASS_TYPE_FEY:
            case CLASS_TYPE_GIANT:
            case CLASS_TYPE_HUMANOID:
            case CLASS_TYPE_MONSTROUS:
            case CLASS_TYPE_OUTSIDER:
            case CLASS_TYPE_SHOU_DISCIPLE:
            case CLASS_TYPE_UNDEAD: continue;
        }
        nNew = GetLevelByPosition(nCurrent, oCreature);
        if (nNew > nHighestLevel)
        {
            nHighestClass = nClass;
            nHighestLevel = nNew;
        }
    }

    return nHighestClass;
}

int pat_GetRandomClass(struct PAT_STRUCT_CLASS_SETUP stClassSet)
{
    int nCount = 0;
    if (stClassSet.Class_3 != -1)
        nCount = Random(3);
    else if (stClassSet.Class_2 != -1)
        nCount = Random(2);

    switch (nCount)
    {
        case 0: return stClassSet.Class_1;
        case 1: return stClassSet.Class_2;
        case 2: return stClassSet.Class_3;
    }

    return stClassSet.Class_1;
}

int pat_GetHasRangedWeaponEquipped(object oCreature)
{
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);
    int nWeaponType = GetBaseItemType(oWeapon);
    switch (nWeaponType)
    {
        case BASE_ITEM_DART:
        case BASE_ITEM_HEAVYCROSSBOW:
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_LONGBOW:
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_SHURIKEN:
        case BASE_ITEM_SLING:
        case BASE_ITEM_THROWINGAXE: return TRUE;
    }

    return FALSE;
}

int pat_GetCreatureRole(object oCreature)
{
    int nRole_ID = GetLocalInt(oCreature, PAT_VAR_ROLE_ID);

    if (nRole_ID == 0)
    {
        string sRole_Name = GetLocalString(oCreature, PAT_VAR_ROLE_NAME);

        // if also no string is set, we don't know the role of this creature and
        // have to "guess"
        if (sRole_Name == "")
        {
            // Check Classes
            int nHighestClass = pat_GetHighestCreatureClass(oCreature);
            int nRandom;
            switch (nHighestClass)
            {
                /***************************************************************
                 * PC Playable Classes
                 **************************************************************/
                case CLASS_TYPE_ABERRATION:
                case CLASS_TYPE_ANIMAL:
                case CLASS_TYPE_BEAST:
                case CLASS_TYPE_DRAGON:
                case CLASS_TYPE_ELEMENTAL:
                case CLASS_TYPE_MAGICAL_BEAST:
                case CLASS_TYPE_OOZE:
                case CLASS_TYPE_VERMIN:
                    if (GetAbilityScore(oCreature, ABILITY_STRENGTH, TRUE) >= GetAbilityScore(oCreature, ABILITY_DEXTERITY, TRUE))
                    {
                        nRandom = Random(2);
                        switch (nRandom)
                        {
                            case 0: nRole_ID = PAT_ROLE_NAKED_DPS_STR; break;
                            case 1: nRole_ID = PAT_ROLE_NAKED_TANK_STR; break;
                        }
                    }
                    else
                    {
                        nRole_ID = PAT_ROLE_NAKED_DPS_DEX;
                    }
                    break;
                /***************************************************************
                 * PC Playable Classes
                 **************************************************************/
                case CLASS_TYPE_ARCANE_ARCHER: nRole_ID = PAT_ROLE_DPS_RANGE_DEX; break;
                case CLASS_TYPE_ASSASSIN: nRole_ID = PAT_ROLE_DPS_MELEE_DEX; break;
                case CLASS_TYPE_BARBARIAN: nRole_ID = PAT_ROLE_DPS_MELEE_STR; break;
                case CLASS_TYPE_BARD: nRole_ID = PAT_ROLE_SUPPORT_CHA; break;
                case CLASS_TYPE_BLACKGUARD: nRole_ID = PAT_ROLE_TANK_STR; break;
                case CLASS_TYPE_CLERIC:
                    nRandom = Random(4);
                    switch (nRandom)
                    {
                        case 0:
                        case 1: nRole_ID = PAT_ROLE_HEAL_WIS; break;
                        case 2: nRole_ID = PAT_ROLE_DPS_CASTER_WIS; break;
                        case 3: nRole_ID = PAT_ROLE_SUPPORT_WIS; break;
                    }
                    break;
                case CLASS_TYPE_DRUID:
                    nRandom = Random(3);
                    switch (nRandom)
                    {
                        case 0: nRole_ID = PAT_ROLE_HEAL_WIS; break;
                        case 1: nRole_ID = PAT_ROLE_DPS_CASTER_WIS; break;
                        case 2: nRole_ID = PAT_ROLE_SUPPORT_WIS; break;
                    }
                    break;
                case CLASS_TYPE_MONK: nRole_ID = PAT_ROLE_DPS_MELEE_DEX; break;
                case CLASS_TYPE_RANGER: nRole_ID = PAT_ROLE_DPS_RANGE_WIS; break;
                case CLASS_TYPE_ROGUE: nRole_ID = PAT_ROLE_DPS_MELEE_DEX; break;
                case CLASS_TYPE_SHADOWDANCER: nRole_ID = PAT_ROLE_DPS_MELEE_DEX; break;
                case CLASS_TYPE_SORCERER:
                    nRandom = Random(3);
                    switch (nRandom)
                    {
                        case 0: nRole_ID = PAT_ROLE_SUPPORT_CHA; break;
                        default: nRole_ID = PAT_ROLE_DPS_CASTER_CHA; break;
                    }
                    break;
                case CLASS_TYPE_WIZARD:
                    nRandom = Random(3);
                    switch (nRandom)
                    {
                        case 0: nRole_ID = PAT_ROLE_SUPPORT_INT; break;
                        default: nRole_ID = PAT_ROLE_DPS_CASTER_INT; break;
                    }
                    break;
                default:
                    // Do we have a ranged weapon equipped? In this case, the mob was probably designed to be a ranged mob
                    if (pat_GetHasRangedWeaponEquipped(oCreature))
                        nRole_ID = PAT_ROLE_DPS_RANGE_DEX;
                    // Use Ability Scores to determine the correct Role
                    else if (GetAbilityScore(oCreature, ABILITY_STRENGTH, TRUE) >= GetAbilityScore(oCreature, ABILITY_DEXTERITY, TRUE))
                    {
                        nRandom = Random(10);
                        switch (nRandom)
                        {
                            case 0: nRole_ID = PAT_ROLE_TANK_STR; break;
                            default: nRole_ID = PAT_ROLE_DPS_MELEE_STR; break;
                        }
                    }
                    else
                    {
                        nRandom = Random(4);
                        switch (nRandom)
                        {
                            case 0: nRole_ID = PAT_ROLE_DPS_RANGE_DEX; break;
                            default: nRole_ID = PAT_ROLE_DPS_MELEE_DEX; break;
                        }
                    }
                    break;
            }
        }
        else
            nRole_ID = pat_GetRole_ID(sRole_Name);
    }

    // Return the verified Role ID
    return pat_Verify_Role_ID(nRole_ID);
}

void pat_RemoveAllSpells(object oCreature)
{
    int nth;
    int nSpellCount;
    int nClass;
    int nSpellClass;
    for (nClass = 1; nClass <= 3; nClass++)
    {
        nSpellClass = GetClassByPosition(nClass, oCreature);
        if (nSpellClass == CLASS_TYPE_INVALID)
            continue;

        for (nth = 0; nth <= 9 ; nth++)
        {
            // Clear Known spells
            nSpellCount = NWNX_Creature_GetKnownSpellCount(oCreature, nSpellClass, nth);
            while (nSpellCount)
                NWNX_Creature_RemoveKnownSpell(oCreature, nSpellClass, nth, NWNX_Creature_GetKnownSpell(oCreature, nSpellClass, nth, --nSpellCount));

            // Clear Memorized spells
            nSpellCount = NWNX_Creature_GetMemorisedSpellCountByLevel(oCreature, nSpellClass, nth);
            while (nSpellCount)
                NWNX_Creature_ClearMemorisedSpell(oCreature, nSpellClass, nth, --nSpellCount);
        }
    }
}

void pat_RemoveAllFeats(object oCreature)
{
    int nFeatCount = NWNX_Creature_GetFeatCount(oCreature);
    while (nFeatCount)
        NWNX_Creature_RemoveFeat(oCreature, NWNX_Creature_GetFeatByIndex(oCreature, --nFeatCount));
}

void pat_ApplyAbilities(object oCreature, struct PAT_STRUCT_ROLE stRole)
{
    NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_STRENGTH, stRole.Ability_STR);
    NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_DEXTERITY, stRole.Ability_DEX);
    NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CONSTITUTION, stRole.Ability_CON);
    NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_WISDOM, stRole.Ability_WIS);
    NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_INTELLIGENCE, stRole.Ability_INT);
    NWNX_Creature_SetRawAbilityScore(oCreature, ABILITY_CHARISMA, stRole.Ability_CHA);
}

void pat_ApplySavingThrows(object oCreature, struct PAT_STRUCT_ROLE stRole)
{
    NWNX_Creature_SetBaseSavingThrow(oCreature, SAVING_THROW_FORT, stRole.SavingThrow_Fortitude);
    NWNX_Creature_SetBaseSavingThrow(oCreature, SAVING_THROW_REFLEX, stRole.SavingThrow_Reflex);
    NWNX_Creature_SetBaseSavingThrow(oCreature, SAVING_THROW_WILL, stRole.SavingThrow_Will);
}

void pat_ApplyArmorClass(object oCreature, struct PAT_STRUCT_ROLE stRole)
{
    NWNX_Creature_SetBaseAC(oCreature, stRole.AC);
}

void pat_ApplyBaseAttackBonus(object oCreature, struct PAT_STRUCT_ROLE stRole)
{
    NWNX_Creature_SetBaseAttackBonus(oCreature, stRole.BaseAttackBonus);
}

void pat_ApplyBaseHitPoints(object oCreature, struct PAT_STRUCT_ROLE stRole)
{
    NWNX_Object_SetMaxHitPoints(oCreature, stRole.BaseHitPoints);
    NWNX_Object_SetCurrentHitPoints(oCreature, GetMaxHitPoints(oCreature));
}

void pat_SelectSpells(object oCreature, int nCR, int nSource, int nCategory)
{
    struct PAT_STRUCT_SPELL stResult;
    string sQuery;
    int nCastingClass = GetClassByPosition(1, oCreature);

    int nLevel = nCR + (nCR % 2);
    // Build the Query string
    sQuery = "(SELECT Spell_ID, Spell_Level FROM " + PAT_TABLE_SPELLS +
            " WHERE CR_Minimum = " + IntToString(nLevel) +
            " AND Source = " + IntToString(nSource) +
            " AND Category & " + IntToString(nCategory) + " != 0" +
            " ORDER BY RAND() LIMIT " + IntToString(PAT_SPELL_KNOWNSPELLS) + ")";

    for (nLevel = nCR + (nCR % 2) - 1; nLevel >= 0; nLevel--)
    {
        // Select 3 spells per Level
        sQuery += " UNION ALL (SELECT Spell_ID, Spell_Level FROM " + PAT_TABLE_SPELLS +
            " WHERE CR_Minimum = " + IntToString(nLevel) +
            " AND Source = " + IntToString(nSource) +
            " AND Category & " + IntToString(nCategory) + " != 0" +
            " ORDER BY RAND() LIMIT " + IntToString(PAT_SPELL_KNOWNSPELLS) + ")";
    }
    NWNX_SQL_ExecuteQuery(sQuery);
    int nCurrentSpellLevel = -1;
    int nMaxSpellSlots;
    int nRemainingSpellSlots = 0;
    int nSpellIndex = 0;
    int nth;
    int nUseSlots;
    int nSpellWithinLevel = 0;
    struct NWNX_Creature_MemorisedSpell stSpell;
    stSpell.ready = TRUE;
    stSpell.meta = 0;
    stSpell.domain = 0;
    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        stResult.Spell_ID = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
        stResult.Spell_Level = StringToInt(NWNX_SQL_ReadDataInActiveRow(1));

        // New spell level, reset stats
        if (nCurrentSpellLevel != stResult.Spell_Level)
        {
            // Fill remaining spell slots
            for (nth = 0; nth < nRemainingSpellSlots; nth++)
                NWNX_Creature_SetMemorisedSpell(oCreature, nCastingClass, nCurrentSpellLevel, (nMaxSpellSlots - nth) - 1, NWNX_Creature_GetMemorisedSpell(oCreature, nCastingClass, nCurrentSpellLevel, Random(nMaxSpellSlots - nRemainingSpellSlots)));

            nCurrentSpellLevel = stResult.Spell_Level;
            nMaxSpellSlots = NWNX_Creature_GetMaxSpellSlots(oCreature, nCastingClass, nCurrentSpellLevel);
            //SendMessageToAllDMs("Max spell slots for level " + IntToString(nCurrentSpellLevel) + ": " + IntToString(nMaxSpellSlots));
            nRemainingSpellSlots = nMaxSpellSlots;
            nSpellWithinLevel = 0;
            nSpellIndex = 0;
        }

        NWNX_Creature_AddKnownSpell(oCreature, nCastingClass, stResult.Spell_Level, stResult.Spell_ID);
        if (nRemainingSpellSlots > 0)
        {
            stSpell.id = stResult.Spell_ID;
            nUseSlots = FloatToInt(nRemainingSpellSlots / IntToFloat(PAT_SPELL_KNOWNSPELLS - nSpellWithinLevel));
            if (nUseSlots == 0 &&
                nUseSlots < nRemainingSpellSlots)
                nUseSlots = 1;
            for (nth = 1; nth <= nUseSlots ; nth++)
            {
                //SendMessageToAllDMs("Memorizing spell " + IntToString(stSpell.id) + " (Level " + IntToString(nCurrentSpellLevel) + ") at Index #" + IntToString(nSpellIndex));
                NWNX_Creature_SetMemorisedSpell(oCreature, nCastingClass, nCurrentSpellLevel, nSpellIndex, stSpell);
                nSpellIndex++;
                nRemainingSpellSlots--;
            }
        }
        nSpellWithinLevel++;
    }

    NWNX_Creature_RestoreSpells(oCreature);
}

void pat_SelectFeats(object oCreature, int nCR, int nPack)
{
    int nChance = d100();
    struct PAT_STRUCT_FEAT stResult;
    string sQuery = "SELECT Feat_ID FROM " + PAT_TABLE_FEATS +
        " WHERE (Packs LIKE '%;0;%' OR Packs LIKE '%;" + IntToString(nPack) + ";%')" +
        " AND (Chance_Base + (Chance_Modifier * " + IntToString(nCR) + ")) >= " + IntToString(nChance) +
        " AND CR_Minimum <=" + IntToString(nCR) +
        " AND CR_Maximum >=" + IntToString(nCR);

    NWNX_SQL_ExecuteQuery(sQuery);
    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        stResult.Feat_ID = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));

        NWNX_Creature_AddFeat(oCreature, stResult.Feat_ID);
    }
}

void pat_ApplySkillString(object oCreature, int nCR, string sSkillString, float nMultiplier)
{
    if (sSkillString == "")
        return;

    struct sStringTokenizer tokenSkills = GetStringTokenizer(sSkillString, ";");
    string sSkill;
    while (HasMoreTokens(tokenSkills))
    {
        tokenSkills = AdvanceToNextToken(tokenSkills);
        sSkill = GetNextToken(tokenSkills);
        if (sSkill != "")
            NWNX_Creature_SetSkillRank(oCreature, StringToInt(sSkill), FloatToInt(PAT_SKILLS_BASE + nCR * nMultiplier));
    }
}

void pat_ApplySkills(object oCreature, int nCR, int nSkillset)
{
    struct PAT_STRUCT_SKILLSET stResult;
    string sQuery = "SELECT Skills_Extreme, Skills_High, Skills_Medium, Skills_Low FROM " + PAT_TABLE_SKILLSETS +
        " WHERE ID=" + IntToString(nSkillset);

    NWNX_SQL_ExecuteQuery(sQuery);
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        stResult.Skills_Extreme = NWNX_SQL_ReadDataInActiveRow(0);
        stResult.Skills_High = NWNX_SQL_ReadDataInActiveRow(1);
        stResult.Skills_Medium = NWNX_SQL_ReadDataInActiveRow(2);
        stResult.Skills_Low = NWNX_SQL_ReadDataInActiveRow(3);

        pat_ApplySkillString(oCreature, nCR, stResult.Skills_Extreme, PAT_SKILLS_EXTREME);
        pat_ApplySkillString(oCreature, nCR, stResult.Skills_High, PAT_SKILLS_HIGH);
        pat_ApplySkillString(oCreature, nCR, stResult.Skills_Medium, PAT_SKILLS_MEDIUM);
        pat_ApplySkillString(oCreature, nCR, stResult.Skills_Low, PAT_SKILLS_LOW);
    }
}

// public functions

int pat_GetTablesExist()
{
    int nExists_Base = NWNX_SQL_ExecuteQuery("DESCRIBE " + PAT_TABLE_BASE);
    int nExists_Class_Setup = NWNX_SQL_ExecuteQuery("DESCRIBE " + PAT_TABLE_CLASS_SETUP);
    int nExists_Spells = NWNX_SQL_ExecuteQuery("DESCRIBE " + PAT_TABLE_SPELLS);
    int nExists_Feats = NWNX_SQL_ExecuteQuery("DESCRIBE " + PAT_TABLE_FEATS);
    int nExists_Skillsets = NWNX_SQL_ExecuteQuery("DESCRIBE " + PAT_TABLE_SKILLSETS);
    int nExists_Areas = NWNX_SQL_ExecuteQuery("DESCRIBE " + PAT_TABLE_AREAS);

    return (nExists_Base &&
            nExists_Class_Setup &&
            nExists_Spells &&
            nExists_Feats &&
            nExists_Skillsets &&
            nExists_Areas);
}

void pat_DropTables()
{
    NWNX_SQL_ExecuteQuery("DROP TABLE " + PAT_TABLE_BASE);
    NWNX_SQL_ExecuteQuery("DROP TABLE " + PAT_TABLE_CLASS_SETUP);
    NWNX_SQL_ExecuteQuery("DROP TABLE " + PAT_TABLE_SPELLS);
    NWNX_SQL_ExecuteQuery("DROP TABLE " + PAT_TABLE_FEATS);
    NWNX_SQL_ExecuteQuery("DROP TABLE " + PAT_TABLE_SKILLSETS);
    // The areas table is not dropped by the system and needs to be dropped manually
    // for it to reinitialize
    // NWNX_SQL_ExecuteQuery("DROP TABLE " + PAT_TABLE_AREAS);
}

void pat_CreateTables()
{
    // Base Table
    string Table_Base = PAT_TABLE_BASE + " (" +
        "Role_ID                int         NOT NULL," +
        "Role_Name              varchar(16) NOT NULL," +
        "CR                     int         NOT NULL," +
        "Ability_STR            int         NOT NULL DEFAULT 8," +
        "Ability_DEX            int         NOT NULL DEFAULT 8," +
        "Ability_CON            int         NOT NULL DEFAULT 8," +
        "Ability_WIS            int         NOT NULL DEFAULT 8," +
        "Ability_INT            int         NOT NULL DEFAULT 8," +
        "Ability_CHA            int         NOT NULL DEFAULT 8," +
        "SavingThrow_Fortitude  int         NOT NULL DEFAULT 1," +
        "SavingThrow_Reflex     int         NOT NULL DEFAULT 1," +
        "SavingThrow_Will       int         NOT NULL DEFAULT 1," +
        "AC                     int         NOT NULL DEFAULT 10," +
        "BaseAttackBonus        int         NOT NULL DEFAULT 1," +
        "BaseHitPoints          int         NOT NULL DEFAULT 10" +
        ")";

    string Table_ClassSetup = PAT_TABLE_CLASS_SETUP + " (" +
        "Role_ID                int         NOT NULL," +
        "Class_1                int         NOT NULL DEFAULT " + IntToString(CLASS_TYPE_FIGHTER) + ", " +
        "Class_2                int         NOT NULL DEFAULT -1, " +
        "Class_3                int         NOT NULL DEFAULT -1, " +
        "Spell_Source           int         NOT NULL DEFAULT 0, " +
        "Spell_Category         int         NOT NULL DEFAULT 0, " +
        "Feat_Pack              int         NOT NULL DEFAULT 1, " +
        "Skillset               int         NOT NULL DEFAULT 1" +
        ")";

    string Table_Spells = PAT_TABLE_SPELLS + " (" +
        "Spell_ID               int         NOT NULL, " +
        "Spell_Level            int         NOT NULL, " +
        "Source                 int         NOT NULL, " +
        "Category               int         NOT NULL, " +
        "Target                 int         NOT NULL, " +
        "CR_Minimum             int         NOT NULL DEFAULT 1" +
        ")";

    string Table_Feats = PAT_TABLE_FEATS + " (" +
        "Feat_ID                int         NOT NULL, " +
        "Packs                  varchar(64) NOT NULL DEFAULT ';0;', " +
        "Chance_Base            int         NOT NULL DEFAULT 100, " +
        "Chance_Modifier        int         NOT NULL DEFAULT 0, " +
        "CR_Minimum             int         NOT NULL DEFAULT 1, " +
        "CR_Maximum             int         NOT NULL DEFAULT " + IntToString(PAT_CR_MAXIMUM) +
        ")";

    string Table_Skillsets = PAT_TABLE_SKILLSETS + " (" +
        "ID                     int         NOT NULL PRIMARY KEY, " +
        "Skills_Extreme         varchar(64) DEFAULT NULL, " +
        "Skills_High            varchar(64) DEFAULT NULL, " +
        "Skills_Medium          varchar(64) DEFAULT NULL, " +
        "Skills_Low             varchar(64) DEFAULT NULL" +
        ")";

    string Table_Areas = PAT_TABLE_AREAS + " (" +
        "ResRef                 varchar(64) NOT NULL PRIMARY KEY, " +
        "Tag                    varchar(64) NULL, " +
        "Name                   varchar(64) NULL, " +
        "CR                     int         NOT NULL DEFAULT -1" +
        ")";

    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS " + Table_Base);
    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS " + Table_ClassSetup);
    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS " + Table_Spells);
    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS " + Table_Feats);
    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS " + Table_Skillsets);
    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS " + Table_Areas);
}

int pat_GetRole_ID(string sRole_Name)
{
    // Verify role name
    sRole_Name = pat_Verify_Role_Name(sRole_Name);

    object Cache = pat_GetCache();
    int nRole_ID = GetLocalInt(Cache, "RoleID_" + sRole_Name);
    if (nRole_ID == 0)
    {
        nRole_ID = SQLExecAndFetchInt("SELECT Role_ID FROM " + PAT_TABLE_BASE + " WHERE upper(Role_Name)='" + GetStringUpperCase(sRole_Name) + "'");
        SetLocalInt(Cache, "Role_" + sRole_Name, nRole_ID);
    }
    return nRole_ID;
}

string pat_GetRole_Name(int nRole_ID)
{
    // Verify role id
    nRole_ID = pat_Verify_Role_ID(nRole_ID);

    object Cache = pat_GetCache();
    string sRole_Name = GetLocalString(Cache, "RoleName_" + IntToString(nRole_ID));
    if (sRole_Name == "")
    {
        sRole_Name = SQLExecAndFetchString("SELECT Role_Name FROM " + PAT_TABLE_BASE + " WHERE ID=" + IntToString(nRole_ID));
        SetLocalString(Cache, "RoleName_" + IntToString(nRole_ID), sRole_Name);
    }
    return sRole_Name;
}

void pat_AddArea(string sResRef, string sTag, string sName, int nCR)
{
    NWNX_SQL_PrepareQuery("INSERT INTO " + PAT_TABLE_AREAS + " (ResRef, Tag, Name, CR) VALUES (?, ?, ?, ?)");
    NWNX_SQL_PreparedString(0, sResRef);
    NWNX_SQL_PreparedString(1, sTag);
    NWNX_SQL_PreparedString(2, sName);
    NWNX_SQL_PreparedInt(3, nCR);
    NWNX_SQL_ExecutePreparedQuery();
}

void pat_AddRoleEntry(int nRole_ID, string sRole_Name, int nCR, int nAbility_STR, int nAbility_DEX, int nAbility_CON, int nAbility_WIS, int nAbility_INT, int nAbility_CHA, int nSavingThrow_Fortitude, int nSavingThrow_Reflex, int nSavingThrow_Will, int nAC, int nBaseAttackBonus, int nBaseHitPoints)
{
    NWNX_SQL_PrepareQuery("INSERT INTO " + PAT_TABLE_BASE + " (Role_ID,Role_Name,CR,Ability_STR,Ability_DEX,Ability_CON,Ability_WIS,Ability_INT,Ability_CHA,SavingThrow_Fortitude,SavingThrow_Reflex,SavingThrow_Will,AC,BaseAttackBonus,BaseHitPoints) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
    NWNX_SQL_PreparedInt(0, nRole_ID);
    NWNX_SQL_PreparedString(1, sRole_Name);
    NWNX_SQL_PreparedInt(2, nCR);
    NWNX_SQL_PreparedInt(3, nAbility_STR);
    NWNX_SQL_PreparedInt(4, nAbility_DEX);
    NWNX_SQL_PreparedInt(5, nAbility_CON);
    NWNX_SQL_PreparedInt(6, nAbility_WIS);
    NWNX_SQL_PreparedInt(7, nAbility_INT);
    NWNX_SQL_PreparedInt(8, nAbility_CHA);
    NWNX_SQL_PreparedInt(9, nSavingThrow_Fortitude);
    NWNX_SQL_PreparedInt(10, nSavingThrow_Reflex);
    NWNX_SQL_PreparedInt(11, nSavingThrow_Will);
    NWNX_SQL_PreparedInt(12, nAC);
    NWNX_SQL_PreparedInt(13, nBaseAttackBonus);
    NWNX_SQL_PreparedInt(14, nBaseHitPoints);
    NWNX_SQL_ExecutePreparedQuery();
}

void pat_AddRoleEntry_Struct(struct PAT_STRUCT_ROLE stRole)
{
    pat_AddRoleEntry(stRole.Role_ID, stRole.Role_Name, stRole.CR,stRole.Ability_STR, stRole.Ability_DEX, stRole.Ability_CON, stRole.Ability_WIS, stRole.Ability_INT, stRole.Ability_CHA, stRole.SavingThrow_Fortitude, stRole.SavingThrow_Reflex, stRole.SavingThrow_Will, stRole.AC, stRole.BaseAttackBonus, stRole.BaseHitPoints);
}

void pat_AddClassSetup(int nRole_ID, int nClass_1, int nClass_2, int nClass_3, int nSpell_Source, int nSpell_Category, int nFeat_Pack, int nSkillset)
{
    NWNX_SQL_PrepareQuery("INSERT INTO " + PAT_TABLE_CLASS_SETUP + " (Role_ID,Class_1,Class_2,Class_3,Spell_Source,Spell_Category,Feat_Pack,Skillset) VALUES (?,?,?,?,?,?,?,?)");
    NWNX_SQL_PreparedInt(0, nRole_ID);
    NWNX_SQL_PreparedInt(1, nClass_1);
    NWNX_SQL_PreparedInt(2, nClass_2);
    NWNX_SQL_PreparedInt(3, nClass_3);
    NWNX_SQL_PreparedInt(4, nSpell_Source);
    NWNX_SQL_PreparedInt(5, nSpell_Category);
    NWNX_SQL_PreparedInt(6, nFeat_Pack);
    NWNX_SQL_PreparedInt(7, nSkillset);
    NWNX_SQL_ExecutePreparedQuery();
}

void pat_AddSpell(int nSpell_ID, int nSpell_Level, int nSource, int nCategory, int nTarget, int nCR_Minimum)
{
    NWNX_SQL_PrepareQuery("INSERT INTO " + PAT_TABLE_SPELLS + " (Spell_ID, Spell_Level, Source, Category, Target, CR_Minimum) VALUES (?,?,?,?,?,?)");
    NWNX_SQL_PreparedInt(0, nSpell_ID);
    NWNX_SQL_PreparedInt(1, nSpell_Level);
    NWNX_SQL_PreparedInt(2, nSource);
    NWNX_SQL_PreparedInt(3, nCategory);
    NWNX_SQL_PreparedInt(4, nTarget);
    NWNX_SQL_PreparedInt(5, nCR_Minimum);
    NWNX_SQL_ExecutePreparedQuery();
}

void pat_AddFeat(int nFeat_ID, string sPacks, int nChance_Base, int nChance_Modifier, int nCR_Minimum, int nCR_Maximum = PAT_CR_MAXIMUM)
{
    NWNX_SQL_PrepareQuery("INSERT INTO " + PAT_TABLE_FEATS + " (Feat_ID, Packs, Chance_Base, Chance_Modifier, CR_Minimum, CR_Maximum) VALUES (?,?,?,?,?,?)");
    NWNX_SQL_PreparedInt(0, nFeat_ID);
    NWNX_SQL_PreparedString(1, sPacks);
    NWNX_SQL_PreparedInt(2, nChance_Base);
    NWNX_SQL_PreparedInt(3, nChance_Modifier);
    NWNX_SQL_PreparedInt(4, nCR_Minimum);
    NWNX_SQL_PreparedInt(5, nCR_Maximum);
    NWNX_SQL_ExecutePreparedQuery();
}

void pat_AddSkillset(int nID, string sSkills_Extreme, string sSkills_High, string sSkills_Medium, string sSkills_Low)
{
    NWNX_SQL_PrepareQuery("INSERT INTO " + PAT_TABLE_SKILLSETS + " (ID,Skills_Extreme,Skills_High,Skills_Medium,Skills_Low) VALUES (?,?,?,?,?)");
    NWNX_SQL_PreparedInt(0, nID);
    NWNX_SQL_PreparedString(1, sSkills_Extreme);
    NWNX_SQL_PreparedString(2, sSkills_High);
    NWNX_SQL_PreparedString(3, sSkills_Medium);
    NWNX_SQL_PreparedString(4, sSkills_Low);
    NWNX_SQL_ExecutePreparedQuery();
}

struct PAT_STRUCT_ROLE pat_GetRoleEntryByID(int nRole_ID, int nCR)
{
    struct PAT_STRUCT_ROLE stResult;
    string sQuery = "SELECT Role_ID, Role_Name, CR, Ability_STR, Ability_DEX, Ability_CON, Ability_WIS, Ability_INT, Ability_CHA, SavingThrow_Fortitude, SavingThrow_Reflex, SavingThrow_Will, AC, BaseHitPoints FROM " + PAT_TABLE_BASE +
        " WHERE Role_ID="+IntToString(pat_Verify_Role_ID(nRole_ID))+" AND CR="+IntToString(nCR);
    NWNX_SQL_ExecuteQuery(sQuery);

    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        stResult.Role_ID = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
        stResult.Role_Name = NWNX_SQL_ReadDataInActiveRow(1);
        stResult.CR = StringToInt(NWNX_SQL_ReadDataInActiveRow(2));
        stResult.Ability_STR = StringToInt(NWNX_SQL_ReadDataInActiveRow(3));
        stResult.Ability_DEX = StringToInt(NWNX_SQL_ReadDataInActiveRow(4));
        stResult.Ability_CON = StringToInt(NWNX_SQL_ReadDataInActiveRow(5));
        stResult.Ability_WIS = StringToInt(NWNX_SQL_ReadDataInActiveRow(6));
        stResult.Ability_INT = StringToInt(NWNX_SQL_ReadDataInActiveRow(7));
        stResult.Ability_CHA = StringToInt(NWNX_SQL_ReadDataInActiveRow(8));
        stResult.SavingThrow_Fortitude = StringToInt(NWNX_SQL_ReadDataInActiveRow(9));
        stResult.SavingThrow_Reflex = StringToInt(NWNX_SQL_ReadDataInActiveRow(10));
        stResult.SavingThrow_Will = StringToInt(NWNX_SQL_ReadDataInActiveRow(11));
        stResult.AC = StringToInt(NWNX_SQL_ReadDataInActiveRow(12));
        stResult.BaseHitPoints = StringToInt(NWNX_SQL_ReadDataInActiveRow(13));
    }

    return stResult;
}

struct PAT_STRUCT_ROLE pat_GetRoleEntryByName(string sRoleName, int nCR)
{
    return pat_GetRoleEntryByID(pat_GetRole_ID(sRoleName), nCR);
}

struct PAT_STRUCT_CLASS_SETUP pat_GetClassSetup(int nRole_ID, int nClass_1 = -1, int nClass_2 = -1, int nClass_3 = -1)
{
    struct PAT_STRUCT_CLASS_SETUP stResult;
    string sQuery = "SELECT Role_ID, Class_1, Class_2, Class_3, Spell_Source, Spell_Category, Feat_Pack, Skillset FROM " + PAT_TABLE_CLASS_SETUP +
        " WHERE Role_ID=" + IntToString(nRole_ID);

    if (nClass_1 != -1)
        sQuery += " AND Class_1=" + IntToString(nClass_1);
    if (nClass_2 != -1)
        sQuery += " AND Class_2=" + IntToString(nClass_2);
    if (nClass_3 != -1)
        sQuery += " AND Class_3=" + IntToString(nClass_3);

    sQuery += " ORDER BY RAND() LIMIT 1";

    NWNX_SQL_ExecuteQuery(sQuery);

    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        stResult.Role_ID = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
        stResult.Class_1 = StringToInt(NWNX_SQL_ReadDataInActiveRow(1));
        stResult.Class_2 = StringToInt(NWNX_SQL_ReadDataInActiveRow(2));
        stResult.Class_3 = StringToInt(NWNX_SQL_ReadDataInActiveRow(3));
        stResult.Spell_Source = StringToInt(NWNX_SQL_ReadDataInActiveRow(4));
        stResult.Spell_Category = StringToInt(NWNX_SQL_ReadDataInActiveRow(5));
        stResult.Feat_Pack = StringToInt(NWNX_SQL_ReadDataInActiveRow(6));
        stResult.Skillset = StringToInt(NWNX_SQL_ReadDataInActiveRow(7));
    }

    return stResult;
}

int pat_CalculateAbilityScore(int nCR, int nGain_Rate)
{
    float fCR = IntToFloat(nCR);
    switch (nGain_Rate)
    {
        case PAT_GAIN_EXTREME: return PAT_ABILITY_BASE + FloatToInt(fCR * PAT_ABILITY_GAIN_EXTREME);
        case PAT_GAIN_HIGH: return PAT_ABILITY_BASE + FloatToInt(fCR * PAT_ABILITY_GAIN_HIGH);
        case PAT_GAIN_MEDIUM: return PAT_ABILITY_BASE + FloatToInt(fCR * PAT_ABILITY_GAIN_MEDIUM);
        case PAT_GAIN_LOW: return PAT_ABILITY_BASE + FloatToInt(fCR * PAT_ABILITY_GAIN_LOW);
    }
    return pat_CalculateAbilityScore(nCR, PAT_GAIN_MEDIUM);
}

int pat_CalculateSavingThrowValue(int nCR, int nGain_Rate)
{
    float fCR = IntToFloat(nCR);
    switch (nGain_Rate)
    {
        case PAT_GAIN_EXTREME: // No extreme level for Saving Throws
        case PAT_GAIN_HIGH: return PAT_SAVINGTHROW_BASE + FloatToInt(fCR * PAT_SAVINGTHROW_GAIN_HIGH);
        case PAT_GAIN_MEDIUM: return PAT_SAVINGTHROW_BASE + FloatToInt(fCR * PAT_SAVINGTHROW_GAIN_MEDIUM);
        case PAT_GAIN_LOW: return PAT_SAVINGTHROW_BASE + FloatToInt(fCR * PAT_SAVINGTHROW_GAIN_LOW);
    }
    return pat_CalculateSavingThrowValue(nCR, PAT_GAIN_MEDIUM);
}

int pat_CalculateACValue(int nCR, int nGain_Rate)
{
    int nResult;
    float fCR = IntToFloat(nCR);
    switch (nGain_Rate)
    {
        case PAT_GAIN_EXTREME: // No extreme level for Armor Class
        case PAT_GAIN_HIGH: nResult = PAT_AC_BASE + FloatToInt(fCR / PAT_AC_GAIN_HIGH + fCR * fCR / (10 * PAT_AC_GAIN_HIGH)); break;
        case PAT_GAIN_MEDIUM: nResult = PAT_AC_BASE + FloatToInt(fCR / PAT_AC_GAIN_MEDIUM + fCR * fCR / (10 * PAT_AC_GAIN_MEDIUM)); break;
        case PAT_GAIN_LOW: nResult = PAT_AC_BASE + FloatToInt(fCR / PAT_AC_GAIN_LOW + fCR * fCR / (10 * PAT_AC_GAIN_LOW)); break;
    }

    if (nResult > PAT_AC_MAXIMUM)
        nResult = PAT_AC_MAXIMUM;

    return nResult;
}

int pat_CalculateBaseAttackBonus(int nCR, int nGain_Rate)
{
    float fCR = IntToFloat(nCR);
    switch (nGain_Rate)
    {
        case PAT_GAIN_EXTREME: // No extreme level for Base Attack Bonus
        case PAT_GAIN_HIGH: return PAT_BAB_BASE + FloatToInt(fCR * PAT_BAB_GAIN_HIGH);
        case PAT_GAIN_MEDIUM: return PAT_BAB_BASE + FloatToInt(fCR * PAT_BAB_GAIN_MEDIUM);
        case PAT_GAIN_LOW: return PAT_BAB_BASE + FloatToInt(fCR * PAT_BAB_GAIN_LOW);
    }
    return pat_CalculateBaseAttackBonus(nCR, PAT_GAIN_MEDIUM);
}

int pat_CalculateBaseHitPoints(int nCR, int nGain_Rate)
{
    float fCR = IntToFloat(nCR);
    switch (nGain_Rate)
    {
        case PAT_GAIN_EXTREME: // No extreme level for Armor Class
        case PAT_GAIN_HIGH: return FloatToInt(PAT_HP_BASE / PAT_HP_GAIN_HIGH + fCR * (6 - PAT_HP_GAIN_HIGH) + fCR * fCR * fCR / (10 * PAT_HP_GAIN_HIGH));
        case PAT_GAIN_MEDIUM: return FloatToInt(PAT_HP_BASE / PAT_HP_GAIN_MEDIUM + fCR * (6 - PAT_HP_GAIN_MEDIUM) + fCR * fCR * fCR / (10 * PAT_HP_GAIN_MEDIUM));
        case PAT_GAIN_LOW: return FloatToInt(PAT_HP_BASE / PAT_HP_GAIN_LOW + fCR * (6 - PAT_HP_GAIN_LOW) + fCR * fCR * fCR / (10 * PAT_HP_GAIN_LOW));
    }
    return pat_CalculateBaseHitPoints(nCR, PAT_GAIN_MEDIUM);
}

int pat_Apply(object oCreature, int nCR = 0, int nRole_ID = PAT_ROLE_UNDEFINED)
{
    // Is PAT disabled for this creature?
    if (GetLocalInt(oCreature, PAT_VAR_DISABLE) != 0)
        return FALSE;

    // Do we use an override? If not, detect creature CR
    if (nCR == 0)
        nCR = pat_GetCreatureCR(oCreature);

    // If CR is 0, we're unable to apply PAT to this creature
    if (nCR == 0)
        return FALSE;

    // Retreive PAT Role of oCreature
    if (nRole_ID == PAT_ROLE_UNDEFINED)
        nRole_ID = pat_GetCreatureRole(oCreature);

    // If Role is 0, we're unable to apply PAT to this creature
    if (nRole_ID == 0)
        return FALSE;

    // Load Role
    struct PAT_STRUCT_ROLE stRoleEntry = pat_GetRoleEntryByID(nRole_ID, nCR);

    // What Level is this creature?
    int nLevel = GetHitDice(oCreature);

    // Select a random Class Setup for oCreature
    // If this creature has more than 1 level, it probably is NOT a PAT_Creature
    int nClass_1 = -1;
    if (nLevel > 1)
        nClass_1 = pat_GetHighestCreatureClass(oCreature);

    struct PAT_STRUCT_CLASS_SETUP stClassSetup = pat_GetClassSetup(nRole_ID, nClass_1);

    // If we didn't find anything, search without the Class
    if (stClassSetup.Role_ID == 0)
        stClassSetup = pat_GetClassSetup(nRole_ID);

    // If we still didn't find aynthing, we're unable to apply PAT to this creature
    if (stClassSetup.Role_ID == 0)
        return FALSE;

    // Remove all spells prior to (de)levelling
    pat_RemoveAllSpells(oCreature);

    int nth;
    // Delevel to 1
    if (nLevel > 1)
    {
        NWNX_Creature_LevelDown(oCreature, nLevel - 1);
        nLevel = 1;
    }

    // Get current class setup
    nClass_1 = GetClassByPosition(1, oCreature);
    int nClass_2 = GetClassByPosition(2, oCreature);
    int nClass_3 = GetClassByPosition(3, oCreature);

    // Change class at position one
    // If the creature uses this class at position 2 or three, set current
    // class 1 as class 2/3 first
    if (nClass_2 == stClassSetup.Class_1)
    {
        // Only modify class if we have one
        NWNX_Creature_SetClassByPosition(oCreature, 1, nClass_1);
        nClass_2 = nClass_1;
    }
    else if (nClass_3 == stClassSetup.Class_1)
    {
        NWNX_Creature_SetClassByPosition(oCreature, 2, nClass_1);
        nClass_3 = nClass_1;
    }

    if (stClassSetup.Class_1 != -1)
        NWNX_Creature_SetClassByPosition(oCreature, 0, stClassSetup.Class_1);

    if (stClassSetup.Class_2 != -1)
    {
        // If the creature uses tihs class at position 3, set current class
        // 2 as 3 first
        if (nClass_3 == stClassSetup.Class_2)
            NWNX_Creature_SetClassByPosition(oCreature, 2, nClass_2);

        if (nClass_2 != CLASS_TYPE_INVALID)
            NWNX_Creature_SetClassByPosition(oCreature, 1, stClassSetup.Class_2);
    }
    if (stClassSetup.Class_3 != -1)
    {
        if (nClass_3 != CLASS_TYPE_INVALID)
            NWNX_Creature_SetClassByPosition(oCreature, 2, stClassSetup.Class_3);
    }

    // Set correct alignment for base classes
    switch (stClassSetup.Class_1)
    {
        case CLASS_TYPE_BARBARIAN:
        case CLASS_TYPE_BARD: NWNX_Creature_SetAlignmentLawChaos(oCreature, Random(70)); break;
        case CLASS_TYPE_DRUID: NWNX_Creature_SetAlignmentLawChaos(oCreature, Random(39) + 31); break;
        case CLASS_TYPE_MONK: NWNX_Creature_SetAlignmentLawChaos(oCreature, Random(31) + 70); break;
        case CLASS_TYPE_PALADIN: NWNX_Creature_SetAlignmentLawChaos(oCreature, Random(31) + 70);
            NWNX_Creature_SetAlignmentGoodEvil(oCreature, Random(31) + 70);
            break;
    }

    // Level Up
    if (nLevel < nCR)
        NWNX_Creature_LevelUp(oCreature, pat_GetRandomClass(stClassSetup), nCR - nLevel);

    // Remove all spells again after levelling
    pat_RemoveAllSpells(oCreature);

    // Replace all Feats if we are told to
    if (stClassSetup.Feat_Pack != -1)
    {
        pat_RemoveAllFeats(oCreature);
        pat_SelectFeats(oCreature, nCR, stClassSetup.Feat_Pack);
    }

    // Apply Role stats to the creature
    pat_ApplyAbilities(oCreature, stRoleEntry);
    pat_ApplySavingThrows(oCreature, stRoleEntry);
    pat_ApplyArmorClass(oCreature, stRoleEntry);
    pat_ApplyBaseAttackBonus(oCreature, stRoleEntry);
    pat_ApplyBaseHitPoints(oCreature, stRoleEntry);

    // Add spells to creature
    DelayCommand(0.5f, pat_SelectSpells(oCreature, nCR, stClassSetup.Spell_Source, stClassSetup.Spell_Category));

    // Set skills of creature
    pat_ApplySkills(oCreature, nCR, stClassSetup.Skillset);

    // Give out some weapons that fit the role
    // and mark it to not be replaced
    if (stRoleEntry.Role_ID < PAT_ROLE_NAKED &&
        GetLocalInt(oCreature, CS_LGS_EQUIP_DISABLE) != 1)  // No equipment for mobs set to not get equipped by LGS
    {
        object oEquipment;
        switch (stRoleEntry.Role_ID)
        {
            case PAT_ROLE_DPS_RANGE_DEX:
            case PAT_ROLE_DPS_RANGE_WIS:
                oEquipment = lgs_CreateWeaponMelee(oCreature, nCR, -1);      // Create a backup melee weapon
                oEquipment = lgs_CreateWeaponRanged(oCreature, nCR, INVENTORY_SLOT_RIGHTHAND, GetCreatureSize(oCreature));         // Create a ranged weapon with ammunition
                SetLocalInt(oEquipment, CS_LGS_EQUIP_DONTREPLACE, 1);
                break;
            case PAT_ROLE_TANK_STR:
                oEquipment = lgs_CreateWeaponMelee(oCreature, nCR, INVENTORY_SLOT_RIGHTHAND, CI_EGS_WEAPONSIZE_MEDIUM);          // Create a melee weapon (maximum size medium)
                SetLocalInt(oEquipment, CS_LGS_EQUIP_DONTREPLACE, 1);
                oEquipment = lgs_CreateShield(oCreature, nCR);               // Create a shield
                SetLocalInt(oEquipment, CS_LGS_EQUIP_DONTREPLACE, 1);
                break;
            default:
                // Everyone else gets at least a melee weapon of some description, the rest is handled via the Monster equip system of LGS
                oEquipment = lgs_CreateWeaponMelee(oCreature, nCR);
                SetLocalInt(oEquipment, CS_LGS_EQUIP_DONTREPLACE, 1);
                break;
        }

        // Get some suitable Body Armor
        oEquipment = lgs_CreateArmorBody(oCreature, nCR);
        SetLocalInt(oEquipment, CS_LGS_EQUIP_DONTREPLACE, 1);
    }
    else
    {
        // Improve Creature Items on Naked Roles
        object oCreatureItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCreature);
        lgs_AdditionalChance(oCreatureItem, nCR, CI_IP_EnhancementBonus, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        oCreatureItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCreature);
        lgs_AdditionalChance(oCreatureItem, nCR, CI_IP_EnhancementBonus, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        oCreatureItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oCreature);
        lgs_AdditionalChance(oCreatureItem, nCR, CI_IP_EnhancementBonus, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        //oCreatureItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
        //lgs_AdditionalChance(oCreatureItem, nCR, CI_IP_ACBonus, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        //lgs_AdditionalChance(oCreatureItem, nCR, CI_IP_DamageReduction, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    }

    // Set the Challenge Rating variable on the monster
    NWNX_Creature_SetChallengeRating(oCreature, IntToFloat(nCR));

    // PAT was successfully applied
    SetLocalInt(oCreature, PAT_VAR_APPLIED, 1);

    // Set AI scripts
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_BLOCKED_BY_DOOR, "j_ai_onblocked");
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_DAMAGED, "j_ai_ondamaged");
    // Don't modify cnr Skin Death
    if (GetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_DEATH) != "cnr_skin_ondeath")
        SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_DEATH, "j_ai_ondeath");
    else
        SetLocalString(oCreature, "PAT_post_cnr_skin_ondeath", "j_ai_ondeath");
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_DIALOGUE, "j_ai_onconversat");
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_DISTURBED, "j_ai_ondisturbed");
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND, "j_ai_oncombatrou");
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT, "j_ai_onheartbeat");
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED, "j_ai_onphiattack");
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_NOTICE, "j_ai_onpercieve");
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_RESTED, "j_ai_onrest");
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_SPAWN_IN, "j_ai_onspawn");
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_SPELLCASTAT, "j_ai_onspellcast");
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_USER_DEFINED_EVENT, "j_ai_onuserdef");

    // Execute the spawn script of Jasperre's AI
    ExecuteScript("j_ai_onspawn", oCreature);

    return TRUE;
}
