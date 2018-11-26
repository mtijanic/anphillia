
// Temporary for spell names..
#include "cnr_spells_inc"

int spell_GetLevel(int nSpellID, int nCasterClass = -1);
string spell_GetName(int nSpellID);
int spell_GetSchool(int nSpellID);
int spell_GetSpellFocusFeat(int nSpellSchool, int bGreaterFocusFeat=FALSE);






string spell_GetName(int nSpellID)
{
    return CnrGetNameForSpell(nSpellID);
}

int spell_GetLevel(int nSpellID, int nCasterClass = -1)
{
    string sColumn;

    switch (nCasterClass)
    {
       case CLASS_TYPE_BARD: sColumn="Bard";         break;
       case CLASS_TYPE_CLERIC: sColumn="Cleric";     break;
       case CLASS_TYPE_DRUID: sColumn="Druid";       break;
       case CLASS_TYPE_PALADIN: sColumn="Paladin";   break;
       case CLASS_TYPE_RANGER: sColumn="Ranger";     break;
       case CLASS_TYPE_WIZARD:
       case CLASS_TYPE_SORCERER:       // Wizards and Sorcerers use the same column.
                                sColumn="Wiz_Sorc";  break;
       default: sColumn="Innate";                    break;
   }

    string sLevel = Get2DAString("spells", sColumn, nSpellID);
    return (sLevel=="") ? -1 : StringToInt(sLevel);
}

int spell_GetSchool(int nSpellID)
{
    string sSchool = Get2DAString("spells", "School", nSpellID);

    if (sSchool == "A") return SPELL_SCHOOL_ABJURATION;
    if (sSchool == "C") return SPELL_SCHOOL_CONJURATION;
    if (sSchool == "D") return SPELL_SCHOOL_DIVINATION;
    if (sSchool == "E") return SPELL_SCHOOL_ENCHANTMENT;
    if (sSchool == "V") return SPELL_SCHOOL_EVOCATION;
    if (sSchool == "I") return SPELL_SCHOOL_ILLUSION;
    if (sSchool == "N") return SPELL_SCHOOL_NECROMANCY;
    if (sSchool == "T") return SPELL_SCHOOL_TRANSMUTATION;

    return SPELL_SCHOOL_GENERAL;
}

int spell_GetSpellFocusFeat(int nSpellSchool, int bGreaterFocusFeat=FALSE)
{
    switch (nSpellSchool)
    {
        case SPELL_SCHOOL_ABJURATION:
            return bGreaterFocusFeat ? FEAT_GREATER_SPELL_FOCUS_ABJURATION : FEAT_SPELL_FOCUS_ABJURATION;
        case SPELL_SCHOOL_CONJURATION:
            return bGreaterFocusFeat ? FEAT_GREATER_SPELL_FOCUS_CONJURATION : FEAT_SPELL_FOCUS_CONJURATION;
        case SPELL_SCHOOL_DIVINATION:
            return bGreaterFocusFeat ? FEAT_GREATER_SPELL_FOCUS_DIVINATION : FEAT_SPELL_FOCUS_DIVINATION;
        case SPELL_SCHOOL_ENCHANTMENT:
            return bGreaterFocusFeat ? FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT : FEAT_SPELL_FOCUS_ENCHANTMENT;
        case SPELL_SCHOOL_EVOCATION:
            return bGreaterFocusFeat ? FEAT_GREATER_SPELL_FOCUS_EVOCATION : FEAT_SPELL_FOCUS_EVOCATION;
        case SPELL_SCHOOL_ILLUSION:
            return bGreaterFocusFeat ? FEAT_GREATER_SPELL_FOCUS_ILLUSION : FEAT_SPELL_FOCUS_ILLUSION;
        case SPELL_SCHOOL_NECROMANCY:
            return bGreaterFocusFeat ? FEAT_GREATER_SPELL_FOCUS_NECROMANCY : FEAT_SPELL_FOCUS_NECROMANCY;
        case SPELL_SCHOOL_TRANSMUTATION:
            return bGreaterFocusFeat ? FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION : FEAT_SPELL_FOCUS_TRANSMUTATION;
    }

    return -1;
}
