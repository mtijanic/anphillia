

// Returns the name of nAbility
// (NOTE: All first letters are capitals)
string util_GetAbilityName(int nAbility);

// Returns the name of nRacialType.  (NOTE: All first letters are capitals)
string util_GetRaceName(int nRacialType);

// Returns the name of nFeat
string util_GetFeatName(int nFeat);

// Returns the description of nFeat
string util_GetFeatDescription(int nFeat);

// Returns the description of nSkill
string util_GetSkillDescription(int nSkill);

// Returns the name of nSkill. (NOTE: All first letters are capitals)
string util_GetSkillName(int nSkill);

// Returns the name of nRacialType.  (NOTE: All first letters are capitals)
string util_GetGenderName(int nGender);

// Returns the name of nClass (NOTE: All first letters are capitals)
string util_GetClassName(int nClass);

// Returns the name of nBaseItem (First letter is capital)
string util_GetBaseItemName(int nBaseItem);

// Returns the name of nDamageType
string util_GetDamageTypeName(int nDamageType);






string util_GetAbilityName(int nAbility)
{
    switch (nAbility)
    {
        case ABILITY_CHARISMA:        return "Charisma";
        case ABILITY_CONSTITUTION:    return "Constitution";
        case ABILITY_DEXTERITY:       return "Dexterity";
        case ABILITY_INTELLIGENCE:    return "Intelligence";
        case ABILITY_STRENGTH:        return "Strength";
        case ABILITY_WISDOM:          return "Wisdom";
    }
    return "(unknown ability)";
}

string util_GetRaceName(int nRacialType)
{
    switch(nRacialType)
    {
        case RACIAL_TYPE_ABERRATION:          return "Aberration";
        case RACIAL_TYPE_ANIMAL:              return "Animal";
        case RACIAL_TYPE_BEAST:               return "Beast";
        case RACIAL_TYPE_CONSTRUCT:           return "Construct";
        case RACIAL_TYPE_DRAGON:              return "Dragon";
        case RACIAL_TYPE_DWARF:               return "Dwarf";
        case RACIAL_TYPE_ELEMENTAL:           return "Elemental";
        case RACIAL_TYPE_ELF:                 return "Elf";
        case RACIAL_TYPE_FEY:                 return "Fey";
        case RACIAL_TYPE_GIANT:               return "Giant";
        case RACIAL_TYPE_GNOME:               return "Gnome";
        case RACIAL_TYPE_HALFELF:             return "Half Elf";
        case RACIAL_TYPE_HALFLING:            return "Halfling";
        case RACIAL_TYPE_HALFORC:             return "Half Orc";
        case RACIAL_TYPE_HUMAN:               return "Human";
        case RACIAL_TYPE_HUMANOID_GOBLINOID:  return "Goblinoid";
        case RACIAL_TYPE_HUMANOID_MONSTROUS:  return "Monstrous";
        case RACIAL_TYPE_HUMANOID_ORC:        return "Orc";
        case RACIAL_TYPE_HUMANOID_REPTILIAN:  return "Reptilian";
        case RACIAL_TYPE_MAGICAL_BEAST:       return "Magical Beast";
        case RACIAL_TYPE_OOZE:                return "Ooze";
        case RACIAL_TYPE_OUTSIDER:            return "Outsider";
        case RACIAL_TYPE_SHAPECHANGER:        return "Shapechanger";
        case RACIAL_TYPE_UNDEAD:              return "Undead";
        case RACIAL_TYPE_VERMIN:              return "Vermin";
    }
    return "(unknown race)";
}

string util_GetFeatName(int nFeat)
{
    return GetStringByStrRef(StringToInt(Get2DAString("feat", "FEAT", nFeat)));
}

string util_GetFeatDescription(int nFeat)
{
    return GetStringByStrRef(StringToInt(Get2DAString("feat", "DESCRIPTION", nFeat)));
}

string util_GetSkillDescription(int nSkill)
{
    return GetStringByStrRef(StringToInt(Get2DAString("skills", "Description", nSkill)));
}

string util_GetSkillName(int nSkill)
{
//    return GetStringByStrRef(StringToInt(util_Get2DAString("skills", "Name", nSkill)));
    switch (nSkill)
    {
        case SKILL_ANIMAL_EMPATHY:      return "Animal Empathy";
        case SKILL_APPRAISE:            return "Appraise";
        case SKILL_BLUFF:               return "Bluff";
        case SKILL_CONCENTRATION:       return "Concentration";
        case SKILL_CRAFT_ARMOR:         return "Craft Armour";
        case SKILL_CRAFT_TRAP:          return "Craft Trap";
        case SKILL_CRAFT_WEAPON:        return "Craft Weapon";
        case SKILL_DISABLE_TRAP:        return "Disable Trap";
        case SKILL_DISCIPLINE:          return "Discipline";
        case SKILL_HEAL:                return "Heal";
        case SKILL_HIDE:                return "Hide";
        case SKILL_INTIMIDATE:          return "Intimidate";
        case SKILL_LISTEN:              return "Listen";
        case SKILL_LORE:                return "Lore";
        case SKILL_MOVE_SILENTLY:       return "Move Silently";
        case SKILL_OPEN_LOCK:           return "Open Lock";
        case SKILL_PARRY:               return "Parry";
        case SKILL_PERFORM:             return "Perform";
        case SKILL_PERSUADE:            return "Persuade";
        case SKILL_PICK_POCKET:         return "Pick Pocket";
        case SKILL_SEARCH:              return "Search";
        case SKILL_SET_TRAP:            return "Set Trap";
        case SKILL_SPELLCRAFT:          return "Spellcraft";
        case SKILL_SPOT:                return "Spot";
        case SKILL_TAUNT:               return "Taunt";
        case SKILL_TUMBLE:              return "Tumble";
        case SKILL_USE_MAGIC_DEVICE:    return "Use Magic Device";
        case SKILL_RIDE:                return "Ride";
    }
    return "(unknown skill)";
}
string util_GetGenderName(int nGender)
{
    switch (nGender)
    {
        case GENDER_MALE:    return "Male";
        case GENDER_FEMALE:  return "Female";
        case GENDER_BOTH:    return "Both";
        case GENDER_OTHER:   return "Other";
        case GENDER_NONE:    return "None";
    }
    return "(unknown gender)";
}

string util_GetClassName(int nClass)
{
    switch (nClass)
    {
        case CLASS_TYPE_ABERRATION:           return "Aberration";
        case CLASS_TYPE_ANIMAL:               return "Animal";
        case CLASS_TYPE_ARCANE_ARCHER:        return "Arcane Archer";
        case CLASS_TYPE_ASSASSIN:             return "Assassin";
        case CLASS_TYPE_BARBARIAN:            return "Barbarian";
        case CLASS_TYPE_BARD:                 return "Bard";
        case CLASS_TYPE_BEAST:                return "Beast";
        case CLASS_TYPE_BLACKGUARD:           return "Blackguard";
        case CLASS_TYPE_CLERIC:               return "Cleric";
        case CLASS_TYPE_COMMONER:             return "Commoner";
        case CLASS_TYPE_CONSTRUCT:            return "Construct";
        case CLASS_TYPE_DIVINE_CHAMPION:      return "Divine Champion";
        case CLASS_TYPE_DRAGON:               return "Dragon";
        case CLASS_TYPE_DRAGON_DISCIPLE:      return "Dragon Disciple";
        case CLASS_TYPE_DRUID:                return "Druid";
        case CLASS_TYPE_DWARVEN_DEFENDER:     return "Dwarven Defender";
        case CLASS_TYPE_ELEMENTAL:            return "Elemental";
        case CLASS_TYPE_EYE_OF_GRUUMSH:       return "Eye of Gruumsh";
        case CLASS_TYPE_FEY:                  return "Fey";
        case CLASS_TYPE_FIGHTER:              return "Fighter";
        case CLASS_TYPE_GIANT:                return "Giant";
        case CLASS_TYPE_HARPER:               return "Harper";
        case CLASS_TYPE_HUMANOID:             return "Humanoid";
        case CLASS_TYPE_MAGICAL_BEAST:        return "Magical Beast";
        case CLASS_TYPE_MONK:                 return "Monk";
        case CLASS_TYPE_MONSTROUS:            return "Monstrous";
        case CLASS_TYPE_OOZE:                 return "Ooze";
        case CLASS_TYPE_OUTSIDER:             return "Outsider";
        case CLASS_TYPE_PALADIN:              return "Paladin";
        case CLASS_TYPE_PALE_MASTER:          return "Pale master";
        case CLASS_TYPE_RANGER:               return "Ranger";
        case CLASS_TYPE_ROGUE:                return "Rogue";
        case CLASS_TYPE_SHADOWDANCER:         return "Shadowdancer";
        case CLASS_TYPE_SHAPECHANGER:         return "Shapechanger";
        case CLASS_TYPE_SHIFTER:              return "Shifter";
        case CLASS_TYPE_SHOU_DISCIPLE:        return "Disciple";
        case CLASS_TYPE_SORCERER:             return "Sorcerer";
        case CLASS_TYPE_UNDEAD:               return "Undead";
        case CLASS_TYPE_VERMIN:               return "Vermin";
        case CLASS_TYPE_WEAPON_MASTER:        return "Weapon Master";
        case CLASS_TYPE_WIZARD:               return "Wizard";
        case CLASS_TYPE_PURPLE_DRAGON_KNIGHT: return "Purple Dragon Knight";
    }
    return "(unknown class)";
}

string util_GetBaseItemName(int nBaseItem)
{
    switch (nBaseItem)
    {
        /* the numbers 23, 30, 48 and 67 do not exist as base item constants */
        case BASE_ITEM_AMULET:              return "Amulet";
        case BASE_ITEM_ARMOR:               return "Armour";
        case BASE_ITEM_ARROW:               return "Arrow";
        case BASE_ITEM_BASTARDSWORD:        return "Bastard sword";
        case BASE_ITEM_BATTLEAXE:           return "Battleaxe";
        case BASE_ITEM_BELT:                return "Belt";
        case BASE_ITEM_BLANK_POTION:        return "Empty potion";
        case BASE_ITEM_BLANK_SCROLL:        return "Blank scroll";
        case BASE_ITEM_BLANK_WAND:          return "Unused wand";
        case BASE_ITEM_BOLT:                return "Bolt";
        case BASE_ITEM_BOOK:                return "Book";
        case BASE_ITEM_BOOTS:               return "Boots";
        case BASE_ITEM_BRACER:              return "Bracer";
        case BASE_ITEM_BULLET:              return "Bullet";
        case BASE_ITEM_CBLUDGWEAPON:        return "Creature bludgeoning weapon";
        case BASE_ITEM_CLOAK:               return "Cloak";
        case BASE_ITEM_CLUB:                return "Club";
        case BASE_ITEM_CPIERCWEAPON:        return "Creature piercing weapon";
        case BASE_ITEM_CRAFTMATERIALMED:    return "Crafting material medium";
        case BASE_ITEM_CRAFTMATERIALSML:    return "Crafting material small";
        case BASE_ITEM_CREATUREITEM:        return "Creature item";
        case BASE_ITEM_CSLASHWEAPON:        return "Creature slashing weapon";
        case BASE_ITEM_CSLSHPRCWEAP:        return "Creature slashing/piercing weapon";
        case BASE_ITEM_DAGGER:              return "Dagger";
        case BASE_ITEM_DART:                return "Dart";
        case BASE_ITEM_DIREMACE:            return "Dire mace";
        case BASE_ITEM_DOUBLEAXE:           return "Double axe";
        case BASE_ITEM_DWARVENWARAXE:       return "Waraxe";
        case BASE_ITEM_ENCHANTED_POTION:    return "Filled potion";
        case BASE_ITEM_ENCHANTED_SCROLL:    return "Scribed scroll";
        case BASE_ITEM_ENCHANTED_WAND:      return "Enchanted wand";
        case BASE_ITEM_GEM:                 return "Gem";
        case BASE_ITEM_GLOVES:              return "Gloves";
        case BASE_ITEM_GOLD:                return "Gold";
        case BASE_ITEM_GREATAXE:            return "Greataxe";
        case BASE_ITEM_GREATSWORD:          return "Greatsword";
        case BASE_ITEM_GRENADE:             return "Grenade";
        case BASE_ITEM_HALBERD:             return "Halberd";
        case BASE_ITEM_HANDAXE:             return "Hand axe";
        case BASE_ITEM_HEALERSKIT:          return "Healer's kit";
        case BASE_ITEM_HEAVYCROSSBOW:       return "Heavy crossbow";
        case BASE_ITEM_HEAVYFLAIL:          return "Heavy flail";
        case BASE_ITEM_HELMET:              return "Helmet";
        case BASE_ITEM_KAMA:                return "Kama";
        case BASE_ITEM_KATANA:              return "Katana";
        case BASE_ITEM_KEY:                 return "Key";
        case BASE_ITEM_KUKRI:               return "Kukri";
        case BASE_ITEM_LARGEBOX:            return "Large Box";
        case BASE_ITEM_LARGESHIELD:         return "Large shield";
        case BASE_ITEM_LIGHTCROSSBOW:       return "Light crossbow";
        case BASE_ITEM_LIGHTFLAIL:          return "Light flail";
        case BASE_ITEM_LIGHTHAMMER:         return "Light hammer";
        case BASE_ITEM_LIGHTMACE:           return "Light mace";
        case BASE_ITEM_LONGBOW:             return "Longbow";
        case BASE_ITEM_LONGSWORD:           return "Longsword";
        case BASE_ITEM_MAGICROD:            return "Magic rod";
        case BASE_ITEM_MAGICSTAFF:          return "Magic staff";
        case BASE_ITEM_MAGICWAND:           return "Magic wand";
        case BASE_ITEM_MISCLARGE:           return "Miscelaneous large";
        case BASE_ITEM_MISCMEDIUM:          return "Miscelaneous medium";
        case BASE_ITEM_MISCSMALL:           return "Miscelaneous small";
        case BASE_ITEM_MISCTALL:            return "Miscelaneous tall";
        case BASE_ITEM_MISCTHIN:            return "Miscelaneous thin";
        case BASE_ITEM_MISCWIDE:            return "Miscelaneous wide";
        case BASE_ITEM_MORNINGSTAR:         return "Morningstar";
        case BASE_ITEM_POTIONS:             return "Potion";
        case BASE_ITEM_QUARTERSTAFF:        return "Quarterstaff";
        case BASE_ITEM_RAPIER:              return "Rapier";
        case BASE_ITEM_RING:                return "Ring";
        case BASE_ITEM_SCIMITAR:            return "Scimitar";
        case BASE_ITEM_SCROLL:              return "Scroll";
        case BASE_ITEM_SCYTHE:              return "Scythe";
        case BASE_ITEM_SHORTBOW:            return "Shortbow";
        case BASE_ITEM_SHORTSPEAR:          return "Short spear";
        case BASE_ITEM_SHORTSWORD:          return "Short sword";
        case BASE_ITEM_SHURIKEN:            return "Shuriken";
        case BASE_ITEM_SICKLE:              return "Sickle";
        case BASE_ITEM_SLING:               return "Sling";
        case BASE_ITEM_SMALLSHIELD:         return "Small shield";
        case BASE_ITEM_SPELLSCROLL:         return "Spell scroll";
        case BASE_ITEM_THIEVESTOOLS:        return "Thieves tools";
        case BASE_ITEM_THROWINGAXE:         return "Throwing axe";
        case BASE_ITEM_TORCH:               return "Torch";
        case BASE_ITEM_TOWERSHIELD:         return "Tower shield";
        case BASE_ITEM_TRAPKIT:             return "Trap kit";
        case BASE_ITEM_TRIDENT:             return "Trident";
        case BASE_ITEM_TWOBLADEDSWORD:      return "Two-bladed sword";
        case BASE_ITEM_WARHAMMER:           return "Warhammer";
        case BASE_ITEM_WHIP:                return "Whip";
    }
    return "(unknown base item)";
}

string util_GetDamageTypeName(int nDamageType)
{
    switch (nDamageType)
    {
        case DAMAGE_TYPE_ACID:          return "Acid";
        case DAMAGE_TYPE_BASE_WEAPON:   return "Physical";
        case DAMAGE_TYPE_BLUDGEONING:   return "Bludgeoning";
        case DAMAGE_TYPE_COLD:          return "Cold";
        case DAMAGE_TYPE_DIVINE:        return "Divine";
        case DAMAGE_TYPE_ELECTRICAL:    return "Electrical";
        case DAMAGE_TYPE_FIRE:          return "Fire";
        case DAMAGE_TYPE_MAGICAL:       return "Magical";
        case DAMAGE_TYPE_NEGATIVE:      return "Negative";
        case DAMAGE_TYPE_PIERCING:      return "Piercing";
        case DAMAGE_TYPE_POSITIVE:      return "Positive";
        case DAMAGE_TYPE_SLASHING:      return "Slashing";
        case DAMAGE_TYPE_SONIC:         return "Sonic";
    }
    return "(unknown damage type)";
}


