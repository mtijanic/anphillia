///////////////////////////////////////////////////////////////////////////////
// ip_rnd_inc
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: This file is responsible for creating all sort of random stuff for
//        for the magic system


///////////
// Includes
//

///////////////////////
// Function Declaration
//
int ip_GetRandomAbility(int iBaseItem, int iIgnoreRestriction);
int ip_GetRandomAlignmentGroup(int iAllIncluded = FALSE);
int ip_GetRandomDamageType(int iReduced = FALSE);
int ip_GetRandomRacialType(int iPlayableRacesOnly = FALSE);
int ip_GetRandomSpecificAlignment();
int ip_GetRandomBonusFeat();
int ip_GetRandomClass(int iCasterOnly = FALSE);
int ip_GetRandomSaveBaseType();
int ip_GetRandomSavingThrowVS(int iIncludeUniversal = FALSE);
int ip_GetRandomACModifierType();
int ip_GetRandomSkill(int iIncludeALL = FALSE);
int ip_GetRandomExtraDamageType();
int ip_GetRandomLightColor();
int ip_GetRandomDisease();
int ip_GetRandomItemPoison();
int ip_GetRandomWalkType();
int ip_GetRandomSpellSchool();
int ip_GetRandomTrapType();
int ip_GetRandomItemVisualEffect();
string ip_GetRandomScroll(int iLevel = 0, int iIncludePrC = FALSE);
int ip_GetRandomPotionSpell(int iLevel = 0);
int ip_GetRandomWandSpell(int iLevel = 1, int iIncludePrCSpells = FALSE);
int ip_GetRandomSpell(int iLevel = 1);

////////////////
// Function Code
//
int ip_GetRandomAbility(int iBaseItem, int iIgnoreRestriction)
{
    int iResult;
    int iRandomizer;
    if (CI_IP_RESTRICT_AbilityBonus &&
        !iIgnoreRestriction)
    {
        iRandomizer = Random(4);
        switch (iBaseItem)
        {
            case BASE_ITEM_BELT:
                switch (iRandomizer)
                {
                    case 0: iResult = IP_CONST_ABILITY_STR; break;
                    case 1: iResult = IP_CONST_ABILITY_CON; break;
                    case 2: iResult = IP_CONST_ABILITY_WIS; break;
                    case 3: iResult = IP_CONST_ABILITY_CHA; break;
                }
                break;
            case BASE_ITEM_GLOVES:
                switch (iRandomizer)
                {
                    case 0: iResult = IP_CONST_ABILITY_STR; break;
                    case 1: iResult = IP_CONST_ABILITY_DEX; break;
                    case 2: iResult = IP_CONST_ABILITY_INT; break;
                    case 3: iResult = IP_CONST_ABILITY_CHA; break;
                }
                break;
            case BASE_ITEM_CLOAK:
                switch (iRandomizer)
                {
                    case 0: iResult = IP_CONST_ABILITY_DEX; break;
                    case 1: iResult = IP_CONST_ABILITY_CON; break;
                    case 2: iResult = IP_CONST_ABILITY_INT; break;
                    case 3: iResult = IP_CONST_ABILITY_WIS; break;
                }
                break;
        }
    }
    else
    {
       iRandomizer = Random(6);
       switch (iRandomizer)
       {
          case 0: iResult = IP_CONST_ABILITY_STR; break;
          case 1: iResult = IP_CONST_ABILITY_DEX; break;
          case 2: iResult = IP_CONST_ABILITY_CON; break;
          case 3: iResult = IP_CONST_ABILITY_INT; break;
          case 4: iResult = IP_CONST_ABILITY_WIS; break;
          case 5: iResult = IP_CONST_ABILITY_CHA; break;
       }
    }
    return (iResult);
}

int ip_GetRandomAlignmentGroup(int iAllIncluded = FALSE)
{
   int iCount;
   if (iAllIncluded)
   {
      iCount = 6;
   }
   else
   {
      iCount = 5;
   }
   int iRandomizer = Random(iCount);
   int iResult;
   switch (iRandomizer)
   {
      case 0: iResult = IP_CONST_ALIGNMENTGROUP_CHAOTIC; break;
      case 1: iResult = IP_CONST_ALIGNMENTGROUP_EVIL; break;
      case 2: iResult = IP_CONST_ALIGNMENTGROUP_GOOD; break;
      case 3: iResult = IP_CONST_ALIGNMENTGROUP_LAWFUL; break;
      case 4: iResult = IP_CONST_ALIGNMENTGROUP_NEUTRAL; break;
      case 5: iResult = IP_CONST_ALIGNMENTGROUP_ALL; break;
   }
   return (iResult);
}

int ip_GetRandomDamageType(int iReduced = 2)
{
   int iCount;
   if (iReduced == 0)
   {
      iCount = 3;
   }
   else if (iReduced == 1)
   {
      iCount = 8;
   }
   else
   {
      iCount = 14;
   }
   int iRandomizer = Random(iCount);
   int iResult;
   switch (iRandomizer)
   {
      // Reduced first
      case 0: iResult = IP_CONST_DAMAGETYPE_BLUDGEONING; break;
      case 1: iResult = IP_CONST_DAMAGETYPE_SLASHING; break;
      case 2: iResult = IP_CONST_DAMAGETYPE_PIERCING; break;
      // then the not so reduced
      case 3: iResult = IP_CONST_DAMAGETYPE_ACID; break;
      case 4: iResult = IP_CONST_DAMAGETYPE_COLD; break;
      case 5: iResult = IP_CONST_DAMAGETYPE_ELECTRICAL; break;
      case 6: iResult = IP_CONST_DAMAGETYPE_SONIC; break;
      case 7: iResult = IP_CONST_DAMAGETYPE_FIRE; break;
      // then the rest
      case 8: iResult = IP_CONST_DAMAGETYPE_DIVINE; break;
      case 9: iResult = IP_CONST_DAMAGETYPE_MAGICAL; break;
      case 10: iResult = IP_CONST_DAMAGETYPE_NEGATIVE; break;
      case 11: iResult = IP_CONST_DAMAGETYPE_PHYSICAL; break;
      case 12: iResult = IP_CONST_DAMAGETYPE_POSITIVE; break;
      case 13: iResult = IP_CONST_DAMAGETYPE_SUBDUAL; break;
   }
   return (iResult);
}

int ip_GetRandomRacialType(int iPlayableRacesOnly = FALSE)
{
   int iCount;
   if (iPlayableRacesOnly)
   {
      iCount = 7;
   }
   else
   {
      iCount = 24;
   }
   int iRandomizer = Random(iCount);
   int iResult;
   switch (iRandomizer)
   {
      // Playable Races
      case 0: iResult = IP_CONST_RACIALTYPE_DWARF; break;
      case 1: iResult = IP_CONST_RACIALTYPE_ELF; break;
      case 2: iResult = IP_CONST_RACIALTYPE_GNOME; break;
      case 3: iResult = IP_CONST_RACIALTYPE_HALFELF; break;
      case 4: iResult = IP_CONST_RACIALTYPE_HALFLING; break;
      case 5: iResult = IP_CONST_RACIALTYPE_HALFORC; break;
      case 6: iResult = IP_CONST_RACIALTYPE_HUMAN; break;
      // non-playable Races
      case 7: iResult = IP_CONST_RACIALTYPE_ABERRATION; break;
      case 8: iResult = IP_CONST_RACIALTYPE_ANIMAL; break;
      case 9: iResult = IP_CONST_RACIALTYPE_BEAST; break;
      case 10: iResult = IP_CONST_RACIALTYPE_CONSTRUCT; break;
      case 11: iResult = IP_CONST_RACIALTYPE_DRAGON; break;
      case 12: iResult = IP_CONST_RACIALTYPE_ELEMENTAL; break;
      case 13: iResult = IP_CONST_RACIALTYPE_FEY; break;
      case 14: iResult = IP_CONST_RACIALTYPE_GIANT; break;
      case 15: iResult = IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID; break;
      case 16: iResult = IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS; break;
      case 17: iResult = IP_CONST_RACIALTYPE_HUMANOID_ORC; break;
      case 18: iResult = IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN; break;
      case 19: iResult = IP_CONST_RACIALTYPE_MAGICAL_BEAST; break;
      case 20: iResult = IP_CONST_RACIALTYPE_OUTSIDER; break;
      case 21: iResult = IP_CONST_RACIALTYPE_SHAPECHANGER; break;
      case 22: iResult = IP_CONST_RACIALTYPE_UNDEAD; break;
      case 23: iResult = IP_CONST_RACIALTYPE_VERMIN; break;
   }
   return (iResult);
}

int ip_GetRandomSpecificAlignment()
{
   int iRandomizer = Random(9);
   int iResult;
   switch (iRandomizer)
   {
      case 0: iResult = IP_CONST_ALIGNMENT_CE; break;
      case 1: iResult = IP_CONST_ALIGNMENT_CG; break;
      case 2: iResult = IP_CONST_ALIGNMENT_CN; break;
      case 3: iResult = IP_CONST_ALIGNMENT_LE; break;
      case 4: iResult = IP_CONST_ALIGNMENT_LG; break;
      case 5: iResult = IP_CONST_ALIGNMENT_LN; break;
      case 6: iResult = IP_CONST_ALIGNMENT_NE; break;
      case 7: iResult = IP_CONST_ALIGNMENT_NG; break;
      case 8: iResult = IP_CONST_ALIGNMENT_TN; break;
   }
   return (iResult);
}

int ip_GetRandomBonusFeat()
{
   int iRandomizer = Random(27);
   int iResult;
   switch (iRandomizer)
   {
      case 0: iResult = IP_CONST_FEAT_ALERTNESS; break;
      case 1: iResult = IP_CONST_FEAT_AMBIDEXTROUS; break;
      case 2: iResult = IP_CONST_FEAT_ARMOR_PROF_HEAVY; break;
      case 3: iResult = IP_CONST_FEAT_ARMOR_PROF_LIGHT; break;
      case 4: iResult = IP_CONST_FEAT_ARMOR_PROF_MEDIUM; break;
      case 5: iResult = IP_CONST_FEAT_CLEAVE; break;
      case 6: iResult = IP_CONST_FEAT_COMBAT_CASTING; break;
      case 7: iResult = IP_CONST_FEAT_DODGE; break;
      case 8: iResult = IP_CONST_FEAT_EXTRA_TURNING; break;
      case 9: iResult = IP_CONST_FEAT_IMPCRITUNARM; break;
      case 10: iResult = IP_CONST_FEAT_KNOCKDOWN; break;
      case 11: iResult = IP_CONST_FEAT_POINTBLANK; break;
      case 12: iResult = IP_CONST_FEAT_POWERATTACK; break;
      case 13: iResult = IP_CONST_FEAT_SPELLFOCUSABJ; break;
      case 14: iResult = IP_CONST_FEAT_SPELLFOCUSCON; break;
      case 15: iResult = IP_CONST_FEAT_SPELLFOCUSDIV; break;
      case 16: iResult = IP_CONST_FEAT_SPELLFOCUSENC; break;
      case 17: iResult = IP_CONST_FEAT_SPELLFOCUSEVO; break;
      case 18: iResult = IP_CONST_FEAT_SPELLFOCUSILL; break;
      case 19: iResult = IP_CONST_FEAT_SPELLFOCUSNEC; break;
      case 20: iResult = IP_CONST_FEAT_SPELLPENETRATION; break;
      case 21: iResult = IP_CONST_FEAT_TWO_WEAPON_FIGHTING; break;
      case 22: iResult = IP_CONST_FEAT_WEAPFINESSE; break;
      case 23: iResult = IP_CONST_FEAT_WEAPON_PROF_EXOTIC; break;
      case 24: iResult = IP_CONST_FEAT_WEAPON_PROF_MARTIAL; break;
      case 25: iResult = IP_CONST_FEAT_WEAPON_PROF_SIMPLE; break;
      case 26: iResult = IP_CONST_FEAT_WEAPSPEUNARM; break;
   }
   return (iResult);
}

int ip_GetRandomClass(int iCasterOnly = FALSE)
{
   int iCount;
   if (iCasterOnly)
   {
      iCount = 7;
   }
   else
   {
      iCount = 11;
   }

   int iRandomizer = Random(iCount);
   int iResult;
   switch (iRandomizer)
   {
      // Caster Classes
      case 0: iResult = IP_CONST_CLASS_BARD; break;
      case 1: iResult = IP_CONST_CLASS_CLERIC; break;
      case 2: iResult = IP_CONST_CLASS_DRUID; break;
      case 3: iResult = IP_CONST_CLASS_PALADIN; break;
      case 4: iResult = IP_CONST_CLASS_SORCERER; break;
      case 5: iResult = IP_CONST_CLASS_WIZARD; break;
      case 6: iResult = IP_CONST_CLASS_RANGER; break;
      // Non-Caster
      case 7: iResult = IP_CONST_CLASS_BARBARIAN; break;
      case 8: iResult = IP_CONST_CLASS_FIGHTER; break;
      case 9: iResult = IP_CONST_CLASS_MONK; break;
      case 10: iResult = IP_CONST_CLASS_ROGUE; break;
   }
   return (iResult);
}

int ip_GetRandomSaveBaseType()
{
   int iRandomizer = Random(3);
   int iResult;
   switch (iRandomizer)
   {
      case 0: iResult = IP_CONST_SAVEBASETYPE_FORTITUDE; break;
      case 1: iResult = IP_CONST_SAVEBASETYPE_REFLEX; break;
      case 2: iResult = IP_CONST_SAVEBASETYPE_WILL; break;
   }
   return (iResult);
}

int ip_GetRandomSavingThrowVS(int iIncludeUniversal = FALSE)
{
   int iCount;
   if (iIncludeUniversal)
   {
      iCount = 14;
   }
   else
   {
      iCount = 13;
   }
   int iRandomizer = Random(iCount);
   int iResult;
   switch (iRandomizer)
   {
      case 0: iResult = IP_CONST_SAVEVS_ACID; break;
      case 1: iResult = IP_CONST_SAVEVS_COLD; break;
      case 2: iResult = IP_CONST_SAVEVS_DEATH; break;
      case 3: iResult = IP_CONST_SAVEVS_DISEASE; break;
      case 4: iResult = IP_CONST_SAVEVS_DIVINE; break;
      case 5: iResult = IP_CONST_SAVEVS_ELECTRICAL; break;
      case 6: iResult = IP_CONST_SAVEVS_FEAR; break;
      case 7: iResult = IP_CONST_SAVEVS_FIRE; break;
      case 8: iResult = IP_CONST_SAVEVS_MINDAFFECTING; break;
      case 9: iResult = IP_CONST_SAVEVS_NEGATIVE; break;
      case 10: iResult = IP_CONST_SAVEVS_POISON; break;
      case 11: iResult = IP_CONST_SAVEVS_POSITIVE; break;
      case 12: iResult = IP_CONST_SAVEVS_SONIC; break;
      case 13: iResult = IP_CONST_SAVEVS_UNIVERSAL; break;
   }
   return (iResult);
}

int ip_GetRandomACModifierType()
{
   int iRandomizer = Random(5);
   int iResult;
   switch (iRandomizer)
   {
      case 0: iResult = IP_CONST_ACMODIFIERTYPE_ARMOR; break;
      case 1: iResult = IP_CONST_ACMODIFIERTYPE_DEFLECTION; break;
      case 2: iResult = IP_CONST_ACMODIFIERTYPE_DODGE; break;
      case 3: iResult = IP_CONST_ACMODIFIERTYPE_NATURAL; break;
      case 4: iResult = IP_CONST_ACMODIFIERTYPE_SHIELD; break;
   }
   return (iResult);
}

int ip_GetRandomSkill(int iIncludeAll = FALSE)
{
   int iCount;
   if (iIncludeAll)
   {
      iCount = 28;
   }
   else
   {
      iCount = 27;
   }
   int iRandomizer = Random(iCount);
   int iResult;
   switch (iRandomizer)
   {
      case 0: iResult = SKILL_ANIMAL_EMPATHY; break;
      case 1: iResult = SKILL_APPRAISE; break;
      case 2: iResult = SKILL_BLUFF; break;
      case 3: iResult = SKILL_CONCENTRATION; break;
      //case 4: iResult = SKILL_CRAFT_ARMOR; break;
      //case 5: iResult = SKILL_CRAFT_TRAP; break;
      //case 6: iResult = SKILL_CRAFT_WEAPON; break;
      case 7: iResult = SKILL_DISABLE_TRAP; break;
      case 8: iResult = SKILL_DISCIPLINE; break;
      case 9: iResult = SKILL_HEAL; break;
      case 10: iResult = SKILL_HIDE; break;
      case 11: iResult = SKILL_INTIMIDATE; break;
      case 12: iResult = SKILL_LISTEN; break;
      case 13: iResult = SKILL_LORE; break;
      case 14: iResult = SKILL_MOVE_SILENTLY; break;
      case 15: iResult = SKILL_OPEN_LOCK; break;
      case 16: iResult = SKILL_PARRY; break;
      case 17: iResult = SKILL_PERFORM; break;
      case 18: iResult = SKILL_PERSUADE; break;
      case 19: iResult = SKILL_PICK_POCKET; break;
      case 20: iResult = SKILL_SEARCH; break;
      case 21: iResult = SKILL_SET_TRAP; break;
      case 22: iResult = SKILL_SPELLCRAFT; break;
      case 23: iResult = SKILL_SPOT; break;
      case 24: iResult = SKILL_TAUNT; break;
      case 25: iResult = SKILL_TUMBLE; break;
      case 26: iResult = SKILL_USE_MAGIC_DEVICE; break;
      case 27: iResult = SKILL_ALL_SKILLS; break;
      default: iResult = ip_GetRandomSkill(iIncludeAll); break;
   }
   return (iResult);
}

int ip_GetRandomExtraDamageType()
{
   int iRandomizer = Random(3);
   int iResult;
   switch (iRandomizer)
   {
      case 0: iResult = IP_CONST_DAMAGETYPE_BLUDGEONING; break;
      case 1: iResult = IP_CONST_DAMAGETYPE_PIERCING; break;
      case 2: iResult = IP_CONST_DAMAGETYPE_SLASHING; break;
   }
   return (iResult);
}

int ip_GetRandomLightColor()
{
   int iRandomizer = Random(7);
   int iResult;
   switch (iRandomizer)
   {
      case 0: iResult = IP_CONST_LIGHTCOLOR_BLUE; break;
      case 1: iResult = IP_CONST_LIGHTCOLOR_GREEN; break;
      case 2: iResult = IP_CONST_LIGHTCOLOR_ORANGE; break;
      case 3: iResult = IP_CONST_LIGHTCOLOR_PURPLE; break;
      case 4: iResult = IP_CONST_LIGHTCOLOR_RED; break;
      case 5: iResult = IP_CONST_LIGHTCOLOR_WHITE; break;
      case 6: iResult = IP_CONST_LIGHTCOLOR_YELLOW; break;
   }
   return (iResult);
}

int ip_GetRandomDisease()
{
   int iRandomizer = Random(17);
   int iResult;
   switch (iRandomizer)
   {
      case 0: iResult = DISEASE_BLINDING_SICKNESS; break;
      case 1: iResult = DISEASE_BURROW_MAGGOTS; break;
      case 2: iResult = DISEASE_CACKLE_FEVER; break;
      case 3: iResult = DISEASE_DEMON_FEVER; break;
      case 4: iResult = DISEASE_DEVIL_CHILLS; break;
      case 5: iResult = DISEASE_DREAD_BLISTERS; break;
      case 6: iResult = DISEASE_FILTH_FEVER; break;
      case 7: iResult = DISEASE_GHOUL_ROT; break;
      case 8: iResult = DISEASE_MINDFIRE; break;
      case 9: iResult = DISEASE_MUMMY_ROT; break;
      case 10: iResult = DISEASE_RED_ACHE; break;
      case 11: iResult = DISEASE_RED_SLAAD_EGGS; break;
      case 12: iResult = DISEASE_SHAKES; break;
      case 13: iResult = DISEASE_SLIMY_DOOM; break;
      case 14: iResult = DISEASE_SOLDIER_SHAKES; break;
      case 15: iResult = DISEASE_VERMIN_MADNESS; break;
      case 16: iResult = DISEASE_ZOMBIE_CREEP; break;
   }
   return (iResult);
}

int ip_GetRandomItemPoison()
{
   int iRandomizer = Random(6);
   int iResult;
   switch (iRandomizer)
   {
      case 0: iResult = IP_CONST_POISON_1D2_CHADAMAGE; break;
      case 1: iResult = IP_CONST_POISON_1D2_CONDAMAGE; break;
      case 2: iResult = IP_CONST_POISON_1D2_DEXDAMAGE; break;
      case 3: iResult = IP_CONST_POISON_1D2_INTDAMAGE; break;
      case 4: iResult = IP_CONST_POISON_1D2_STRDAMAGE; break;
      case 5: iResult = IP_CONST_POISON_1D2_WISDAMAGE; break;
   }
   return (iResult);
}

int ip_GetRandomSpellSchool()
{
   int iRandomizer = Random(8);
   int iResult;
   switch (iRandomizer)
   {
      case 0: iResult = IP_CONST_SPELLSCHOOL_ABJURATION; break;
      case 1: iResult = IP_CONST_SPELLSCHOOL_CONJURATION; break;
      case 2: iResult = IP_CONST_SPELLSCHOOL_DIVINATION; break;
      case 3: iResult = IP_CONST_SPELLSCHOOL_ENCHANTMENT; break;
      case 4: iResult = IP_CONST_SPELLSCHOOL_EVOCATION; break;
      case 5: iResult = IP_CONST_SPELLSCHOOL_ILLUSION; break;
      case 6: iResult = IP_CONST_SPELLSCHOOL_NECROMANCY; break;
      case 7: iResult = IP_CONST_SPELLSCHOOL_TRANSMUTATION; break;
   }
   return (iResult);
}

int ip_GetRandomTrapType()
{
   int iRandomizer = Random(11);
   int iResult;
   switch (iRandomizer)
   {
      case 0: iResult = IP_CONST_TRAPTYPE_ACID_SPLASH; break;
      case 1: iResult = IP_CONST_TRAPTYPE_BLOBOFACID; break;
      case 2: iResult = IP_CONST_TRAPTYPE_ELECTRICAL; break;
      case 3: iResult = IP_CONST_TRAPTYPE_FIRE; break;
      case 4: iResult = IP_CONST_TRAPTYPE_FROST; break;
      case 5: iResult = IP_CONST_TRAPTYPE_GAS; break;
      case 6: iResult = IP_CONST_TRAPTYPE_HOLY; break;
      case 7: iResult = IP_CONST_TRAPTYPE_NEGATIVE; break;
      case 8: iResult = IP_CONST_TRAPTYPE_SONIC; break;
      case 9: iResult = IP_CONST_TRAPTYPE_SPIKE; break;
      case 10: iResult = IP_CONST_TRAPTYPE_TANGLE; break;
   }
   return (iResult);
}

int ip_GetRandomItemVisualEffect()
{
   int iRandomizer = Random(7);
   int iResult;
   switch (iRandomizer)
   {
      case 0: iResult = ITEM_VISUAL_ACID; break;
      case 1: iResult = ITEM_VISUAL_COLD; break;
      case 2: iResult = ITEM_VISUAL_ELECTRICAL; break;
      case 3: iResult = ITEM_VISUAL_EVIL; break;
      case 4: iResult = ITEM_VISUAL_FIRE; break;
      case 5: iResult = ITEM_VISUAL_HOLY; break;
      case 6: iResult = ITEM_VISUAL_SONIC; break;
   }
   return (iResult);
}

string ip_GetRandomScroll(int iLevel = 0, int iIncludePrC = FALSE)
{
   int iNumber;
   if (iIncludePrC)
   {
      switch (iLevel)
      {
         case 0: iNumber = 10; break;
         case 1: iNumber = 51; break;
         case 2: iNumber = 55; break;
         case 3: iNumber = 55; break;
         case 4: iNumber = 45; break;
         case 5: iNumber = 38; break;
         case 6: iNumber = 31; break;
         case 7: iNumber = 24; break;
         case 8: iNumber = 23; break;
         case 9: iNumber = 22; break;
      }
   }
   else
   {
      switch (iLevel)
      {
         case 0: iNumber = 10; break;
         case 1: iNumber = 39; break;
         case 2: iNumber = 43; break;
         case 3: iNumber = 44; break;
         case 4: iNumber = 31; break;
         case 5: iNumber = 31; break;
         case 6: iNumber = 41; break;
         case 7: iNumber = 19; break;
         case 8: iNumber = 20; break;
         case 9: iNumber = 19; break;
      }
   }
   int iRandomizer = Random(iNumber);
   string sResult;
   switch (iLevel)
   {
      case 0:
         switch (iRandomizer)
         {
            case 0: sResult = "x1_it_sparscr002"; break;
            case 1: sResult = "x2_it_spdvscr001"; break;
            case 2: sResult = "nw_it_sparscr003"; break;
            case 3: sResult = "x1_it_sparscr003"; break;
            case 4: sResult = "x1_it_sparscr001"; break;
            case 5: sResult = "x1_it_spdvscr001"; break;
            case 6: sResult = "nw_it_sparscr004"; break;
            case 7: sResult = "nw_it_sparscr002"; break;
            case 8: sResult = "nw_it_sparscr001"; break;
            case 9: sResult = "x2_it_spdvscr002"; break;
         }
         break;

      case 1:
         switch (iRandomizer)
         {
            case 0: sResult = "x1_it_sparscr102"; break;
            case 1: sResult = "x1_it_spdvscr101"; break;
            case 2: sResult = "x2_it_spdvscr103"; break;
            case 3: sResult = "x2_it_spdvscr102"; break;
            case 4: sResult = "nw_it_sparscr112"; break;
            case 5: sResult = "x1_it_spdvscr107"; break;
            case 6: sResult = "nw_it_sparscr107"; break;
            case 7: sResult = "nw_it_sparscr110"; break;
            case 8: sResult = "x2_it_spdvscr104"; break;
            case 9: sResult = "x2_it_spdvscr101"; break;
            case 10: sResult = "x1_it_spdvscr102"; break;
            case 11: sResult = "x2_it_spdvscr105"; break;
            case 12: sResult = "nw_it_sparscr101"; break;
            case 13: sResult = "x2_it_spdvscr106"; break;
            case 14: sResult = "x1_it_spdvscr103"; break;
            case 15: sResult = "x1_it_sparscr101"; break;
            case 16: sResult = "nw_it_sparscr103"; break;
            case 17: sResult = "x2_it_spavscr101"; break;
            case 18: sResult = "x2_it_spavscr104"; break;
            case 19: sResult = "nw_it_sparscr106"; break;
            case 20: sResult = "x1_it_spdvscr104"; break;
            case 21: sResult = "x2_it_spavscr102"; break;
            case 22: sResult = "nw_it_sparscr104"; break;
            case 23: sResult = "x1_it_spdvscr106"; break;
            case 24: sResult = "nw_it_sparscr109"; break;
            case 25: sResult = "x2_it_spavscr105"; break;
            case 26: sResult = "nw_it_sparscr113"; break;
            case 27: sResult = "x2_it_sparscral"; break;
            case 28: sResult = "nw_it_sparscr102"; break;
            case 29: sResult = "nw_it_sparscr111"; break;
            case 30: sResult = "x2_it_spdvscr107"; break;
            case 31: sResult = "x2_it_spdvscr108"; break;
            case 32: sResult = "nw_it_sparscr210"; break;
            case 33: sResult = "x2_it_spavscr103"; break;
            case 34: sResult = "x1_it_sparscr103"; break;
            case 35: sResult = "x1_it_spdvscr105"; break;
            case 36: sResult = "nw_it_sparscr108"; break;
            case 37: sResult = "nw_it_sparscr105"; break;
            case 38: sResult = "x1_it_sparscr104"; break;
            // PrC SpellScrolls
            case 39: sResult = "sp_it_sparscr107"; break; // Benign Transposition - Sorc/Wiz 1 (Mini) - Swaps the locations of the target and the caster, target must be a member of the caster's party.
            case 40: sResult = "sp_it_sparscr101"; break; // Burning Bolt - Sorc/Wiz 1 (R&R) - Bolts of fire, each bolt requires a ranged touch attack to hit, 1d4+1 damage / bolt.  One bolt every 2 levels (like magic missile) but no cap on the number of bolts you get (but each bolt requires a separate touch attack roll).
            case 41: sResult = "sp_it_spdvscr101"; break; // Conviction - Cle 1 (Mini) - Gives the target a +2 bonus to saves, with an additional +1 per 6 caster levels (max +5).
            case 42: sResult = "sp_it_sparscr110"; break; // Hail of Stone - Sorc/Wiz 1 (UND) - Ranged touch attack to all targets in small area for 1d4 bludgeoning damage / level, max 5d4.
            case 43: sResult = "sp_it_sparscr102"; break; // Lesser Acid Orb - Sorc/Wiz 1 (Mini) - Fires orb of acid that does 1d8/2 lvls, max 5d8.
            case 44: sResult = "sp_it_sparscr103"; break; // Lesser Cold Orb - Sorc/Wiz 1 (Mini) - Fires orb of cold that does 1d8/2 lvls, max 5d8.
            case 45: sResult = "sp_it_sparscr104"; break; // Lesser Electric Orb - Sorc/Wiz 1 (Mini) - Fires orb of electricity that does 1d8/2 lvls, max 5d8.
            case 46: sResult = "sp_it_sparscr105"; break; // Lesser Fire Orb - Sorc/Wiz 1 (Mini) - Fires orb of fire that does 1d8/2 lvls, max 5d8.
            case 47: sResult = "sp_it_sparscr106"; break; // Lesser Sonic Orb - Sorc/Wiz 1 (Mini) - Fires orb of sound that does 1d8/2 lvls, max 5d8.
            case 48: sResult = "sp_it_spdvscr102"; break; // Lionheart - Pal 1 (Mini) - Target becomes immune to fear.
            case 49: sResult = "sp_it_sparscr109"; break; // Snilloc's Snowball - Sorc/Wiz 1 (UE) - Range touch attack to do 1d6+1 / level (max 5d6+5) cold damage.
            case 50: sResult = "sp_it_sparscr108"; break; // Nybor's Gentle Reminder - Sorc/Wiz 1 (UE) - Target is dazed for 1 round, -2 to attacks, saves, checks for 1 round / level, fort negates.
         }
         break;

      case 2:
         switch (iRandomizer)
         {
            case 0: sResult = "x2_it_spdvscr201"; break;
            case 1: sResult = "x1_it_spdvscr204"; break;
            case 2: sResult = "x1_it_sparscr201"; break;
            case 3: sResult = "x2_it_spdvscr202"; break;
            case 4: sResult = "nw_it_sparscr211"; break;
            case 5: sResult = "x1_it_spdvscr202"; break;
            case 6: sResult = "nw_it_sparscr212"; break;
            case 7: sResult = "nw_it_sparscr213"; break;
            case 8: sResult = "x2_it_spavscr207"; break;
            case 9: sResult = "nw_it_spdvscr202"; break;
            case 10: sResult = "x2_it_spavscr206"; break;
            case 11: sResult = "x2_it_spavscr201"; break;
            case 12: sResult = "x1_it_sparscr301"; break;
            case 13: sResult = "x2_it_spdvscr203"; break;
            case 14: sResult = "nw_it_sparscr206"; break;
            case 15: sResult = "x2_it_spavscr201"; break;
            case 16: sResult = "nw_it_sparscr219"; break;
            case 17: sResult = "nw_it_sparscr215"; break;
            case 18: sResult = "x1_it_spdvscr205"; break;
            case 19: sResult = "x2_it_spavscr205"; break;
            case 20: sResult = "nw_it_sparscr220"; break;
            case 21: sResult = "x2_it_spavscr203"; break;
            case 22: sResult = "nw_it_sparscr208"; break;
            case 23: sResult = "nw_it_sparscr209"; break;
            case 24: sResult = "x2_it_spdvscr204"; break;
            case 25: sResult = "x1_it_spdvscr201"; break;
            case 26: sResult = "nw_it_sparscr207"; break;
            case 27: sResult = "nw_it_sparscr216"; break;
            case 28: sResult = "nw_it_sparscr218"; break;
            case 29: sResult = "nw_it_spdvscr201"; break;
            case 30: sResult = "nw_it_sparscr202"; break;
            case 31: sResult = "x1_it_spdvscr203"; break;
            case 32: sResult = "nw_it_sparscr221"; break;
            case 33: sResult = "x2_it_spdvscr205"; break;
            case 34: sResult = "nw_it_sparscr201"; break;
            case 35: sResult = "nw_it_sparscr205"; break;
            case 36: sResult = "nw_it_spdvscr203"; break;
            case 37: sResult = "nw_it_spdvscr204"; break;
            case 38: sResult = "x2_it_spavscr204"; break;
            case 39: sResult = "nw_it_sparscr203"; break;
            case 40: sResult = "x1_it_sparscr202"; break;
            case 41: sResult = "nw_it_sparscr214"; break;
            case 42: sResult = "nw_it_sparscr204"; break;
            // PrC SpellScrolls
            case 43: sResult = "sp_it_sparscr209"; break; // Snilloc's Snowball Swarm - Sorc/Wiz 2 (FRCS) - Medium burst does 2d6 + 1d6 / 2 levels (max 5d6) cold damage.  Reflex save for half.
            case 44: sResult = "sp_it_sparscr202"; break; // Heroism - Bard 2, Sorc/Wiz 3 (3.5) - Gives target +2 bonus to attack rolls, saves, and skill checks.  Lasts 1 turn/lvl.
            case 45: sResult = "sp_it_sparscr206"; break; // Aganazzar's Scorcher - Sorc/Wiz 2 (FRCS) - Beam of fire, 1d8/2 levels, max 5d8.
            case 46: sResult = "sp_it_sparscr203"; break; // Baleful Transposition - Sorc/Wiz 2 (Mini) - Swaps the locations of the target and the caster, hostile targets receive a will save to negate.
            case 47: sResult = "sp_it_spdvscr203"; break; // Clarity of Mind - Paladin 2 (UND) - +4 bonus vs. mind affecting spells for 1 hour / level.
            case 48: sResult = "sp_it_sparscr207"; break; // Create Magic Tatoo - Sorc/Wiz 2 (FRCS) - Creates various magical effects as tatoos on the target.  A target may have up to 3 tatoos.  What you can make varies depending on your caster level; creating a lore tatoo requires a lore check of varying DC's.
            case 49: sResult = "sp_it_sparscr204"; break; // Curse of Impending Blades - Bard/Rgr/Sorc/Wiz 2 (Mini) - Target receives a -2 AC penalty.
            case 50: sResult = "sp_it_spdvscr201"; break; // Divine Protection - Cle 2 Pal 2 (Mini) - All allies in a huge burst receive a +1 bonus to attacks and saves.
            case 51: sResult = "sp_it_sparscr205"; break; // Fireburst - Sorc/Wiz 2 (Mini) - Small burst of fire centered on caster does 1d8/lvl (max 5d8), reflex save for half.
            case 52: sResult = "sp_it_sparscr201"; break; // Glitterdust - Bard/Sorc/Wiz 2 (3.0) - Makes creatures in area visible, gives them a -40 penalty to hide checks, and blinds them if they fail a will save.  Lasts 1 round / level.
            case 53: sResult = "sp_it_spdvscr202"; break; // Living Undeath - Cle 2 (Mini) - Target becomes immune to critical hits, and takes -4 CHA penalty.
            case 54: sResult = "sp_it_sparscr208"; break; // Shadow Spray - Sorc/Wiz 2 (FRCS) - Small burst, targets take 2 points str damage, dazed for 1 round, -2 to saves vs. fear effects for 1 round / level.  Fort negates.
         }
         break;

      case 3:
         switch (iRandomizer)
         {
            case 0: sResult = "nw_it_spdvscr301"; break;
            case 1: sResult = "x2_it_spdvscr303"; break;
            case 2: sResult = "x2_it_spdvscr307"; break;
            case 3: sResult = "nw_it_sparscr307"; break;
            case 4: sResult = "nw_it_sparscr217"; break;
            case 5: sResult = "x2_it_spdvscr308"; break;
            case 6: sResult = "x2_it_spdvscr305"; break;
            case 7: sResult = "nw_it_sparscr301"; break;
            case 8: sResult = "x1_it_sparscr301"; break;
            case 9: sResult = "x2_it_spdvscr309"; break;
            case 10: sResult = "x2_it_spavscr305"; break;
            case 11: sResult = "nw_it_sparscr309"; break;
            case 12: sResult = "nw_it_sparscr304"; break;
            case 13: sResult = "x2_it_spdvscr306"; break;
            case 14: sResult = "x1_it_spdvscr303"; break;
            case 15: sResult = "x2_it_spavscr304"; break;
            case 16: sResult = "x1_it_sparscr303"; break;
            case 17: sResult = "nw_it_sparscr312"; break;
            case 18: sResult = "x2_it_spdvscr302"; break;
            case 19: sResult = "nw_it_sparscr308"; break;
            case 20: sResult = "x2_it_spdvscr301"; break;
            case 21: sResult = "x1_it_spdvscr302"; break;
            case 22: sResult = "x2_it_spdvscr310"; break;
            case 23: sResult = "nw_it_sparscr314"; break;
            case 24: sResult = "x2_it_spavscr303"; break;
            case 25: sResult = "nw_it_sparscr310"; break;
            case 26: sResult = "nw_it_sparscr302"; break;
            case 27: sResult = "x2_it_sparscrmc"; break;
            case 28: sResult = "x2_it_spdvscr304"; break;
            case 29: sResult = "x2_it_spavscr301"; break;
            case 30: sResult = "nw_it_sparscr315"; break;
            case 31: sResult = "x2_it_spdvscr311"; break;
            case 32: sResult = "x2_it_spdvscr312"; break;
            case 33: sResult = "nw_it_sparscr303"; break;
            case 34: sResult = "x1_it_spdvscr305"; break;
            case 35: sResult = "nw_it_spdvscr302"; break;
            case 36: sResult = "x2_it_spavscr302"; break;
            case 37: sResult = "x2_it_spdvscr313"; break;
            case 38: sResult = "nw_it_sparscr313"; break;
            case 39: sResult = "x1_it_spdvscr304"; break;
            case 40: sResult = "nw_it_sparscr305"; break;
            case 41: sResult = "nw_it_sparscr306"; break;
            case 42: sResult = "nw_it_sparscr311"; break;
            case 43: sResult = "x1_it_sparscr302"; break;
            // PrC Spells
            case 44: sResult = "sp_it_sparscr305"; break; // Flashburst - Sorc/Wiz 3 (FRCS) - Dazzles targets for 1 round and blinds for 2d8 rounds, will save to negate blindness
            case 45: sResult = "sp_it_spdvscr302"; break; // Curse of Petty Failing Cle 3 (Mini) - Target receives a -2 penalty to attacks and saves.
            case 46: sResult = "sp_it_sparscr301"; break; // Forceblast - Sorc/Wiz 3 (BoEM 2) - Bolt of force, 1d4/lvl, max 10d4, all targets of size large or smaller that fail their save are knocked down.
            case 47: sResult = "sp_it_spdvscr304"; break; // Greenfire - Druid 3 (UE) - Creates an AOE of green fire that lasts for 1 round, does 2d6 + (1 / level) acid damage, max 2d6+10.
            case 48: sResult = "sp_it_sparscr302"; break; // Ice Burst - Sorc/Wiz 3 (T&B) - Burst of ice, 1d4+1/lvl cold damage, max 10d4+10, reflex save for 1/2.  Larger radius than fireball (next size category up).
            case 49: sResult = "sp_it_sparscr306"; break; // Improved Mage Armor - Sorc/Wiz 3 (UE) - Target gets armor bonus of 3 + (1 / 2 levels), max +8 for 1 minute / level.
            case 50: sResult = "sp_it_spdvscr301"; break; // Legion's Conviction Cle 3 (Mini) - Gives all allies in a huge burst a +2 bonus to saves, with an additional +1 per 6 caster levels (max +5).
            case 51: sResult = "sp_it_sparscr304"; break; // Legion's Curse of Impending Blades Bard/Rgr/Sorc/Wiz 3 - All targets in a huge burst receive a -2 AC penalty.
            case 52: sResult = "sp_it_sparscr303"; break; // Serpent's Sigh - Sorc/Wiz 3 (R&R) - Allows caster to emulate dragon's breath weapon, may fire either a bolt of acid, bolt of electricity, cone of acid, cone of cold, or cone of fire, 1d6/lvl damage, max 10d6, ref save for 1/2.  Caster takes 1 point of damage per die of damage dealt.
            case 53: sResult = "sp_it_spdvscr303"; break; // Slashing Darkness - Cle 3 (Mini) - Ranged touch attack does 1d8/2 lvls (max 5d8), heals undead instead of harming them.
            case 54: sResult = "sp_it_sparscr307"; break; // Spiderskin - Druid/Sorc/Wiz 3 (UND) - Target gains bonus to natural armor, saves vs. poison, and hide checks.  Bonus is 1 + (1 / 3 levels), max +5.
         }
         break;

      case 4:
         switch (iRandomizer)
         {
            case 0: sResult = "nw_it_sparscr414"; break;
            case 1: sResult = "nw_it_sparscr405"; break;
            case 2: sResult = "nw_it_sparscr406"; break;
            case 3: sResult = "nw_it_sparscr411"; break;
            case 4: sResult = "x2_it_spdvscr402"; break;
            case 5: sResult = "x2_it_spdvscr403"; break;
            case 6: sResult = "x2_it_spdvscr404"; break;
            case 7: sResult = "nw_it_sparscr416"; break;
            case 8: sResult = "nw_it_sparscr412"; break;
            case 9: sResult = "nw_it_sparscr418"; break;
            case 10: sResult = "nw_it_sparscr413"; break;
            case 11: sResult = "x2_it_spdvscr405"; break;
            case 12: sResult = "x2_it_spdvscr406"; break;
            case 13: sResult = "x2_it_spdvscr401"; break;
            case 14: sResult = "x2_it_spavscr401"; break;
            case 15: sResult = "nw_it_sparscr408"; break;
            case 16: sResult = "x1_it_spdvscr401"; break;
            case 17: sResult = "x1_it_sparscr401"; break;
            case 18: sResult = "nw_it_sparscr417"; break;
            case 19: sResult = "x1_it_spdvscr402"; break;
            case 20: sResult = "nw_it_sparscr401"; break;
            case 21: sResult = "nw_it_spdvscr402"; break;
            case 22: sResult = "nw_it_sparscr409"; break;
            case 23: sResult = "x2_it_spdvscr407"; break;
            case 24: sResult = "nw_it_sparscr415"; break;
            case 25: sResult = "nw_it_sparscr402"; break;
            case 26: sResult = "nw_it_spdvscr401"; break;
            case 27: sResult = "nw_it_sparscr410"; break;
            case 28: sResult = "nw_it_sparscr403"; break;
            case 29: sResult = "nw_it_sparscr404"; break;
            case 30: sResult = "nw_it_sparscr407"; break;
            // PrC Spells
            case 31: sResult = "sp_it_sparscr401"; break; // Acid Orb - Sorc/Wiz 4 (T&B) - Fires orb of acid that does 1d6/lvl, max 15d6.  Fort save for 1/2, target is stunned for one round on a failed save.
            case 32: sResult = "sp_it_sparscr402"; break; // Blast of Flame - Sorc/Wiz 4 (Mini) - Cone of flame, 1d6/lvl damage, max 10d6, reflex save for 1/2.
            case 33: sResult = "sp_it_sparscr403"; break; // Cold Orb - Sorc/Wiz 4 (T&B) - Fires orb of cold that does 1d6/lvl, max 15d6.  Fort save for 1/2, target is blinded for one round on a failed save.
            case 34: sResult = "sp_it_sparscr404"; break; // Electric Orb - Sorc/Wiz 4 (T&B) - Fires orb of electricity that does 1d6/lvl, max 15d6.  Fort save for 1/2, target is slowed for one round on a failed save.
            case 35: sResult = "sp_it_sparscr405"; break; // Fire Orb - Sorc/Wiz 4 (T&B) - Fires orb of fire that does 1d6/lvl, max 15d6.  Fort save for 1/2, target is dazed for one round on a failed save.
            case 36: sResult = "sp_it_sparscr409"; break; // Ilyykur's Mantle - Sorc/Wiz 4 (UE) - Electricty resistance 10 and +1 / 3 levels (max +5) bonus to saves vs. spells.  Lasts 1 round / level, personal only.
            case 37: sResult = "sp_it_spdvscr403"; break; // Legion's Shield of Faith - Cle 4 (Mini) - Allies in a huge burst gain a +2 AC bonus, with an additional +1 for every 6 caster levels (max +5).
            case 38: sResult = "sp_it_sparscr407"; break; // Lower Spell Resistance - Sorc/Wiz 4 (Drac) - Lowers targets spell resistance (SR) by 1/lvl, max 15, fort save negates, but target creature takes a penalty equal to the caster's level on their fort save. Takes a full round to cast (in game terms 2x as long to cast as a normal spell and cannot be quickened).
            case 39: sResult = "sp_it_spdvscr402"; break; // Panacea - Cle 4 Dru 5 (Mini) - Heals 1d8+1/lvl (max 1d8+20), cures the following conditions: blinded, confused, dazed, deafened, diseased, frightened, paralyzed, poisoned, sleep, and stunned.  Used on undead it causes damage instead of curing (will save for half) and does not remove effects.
            case 40: sResult = "sp_it_spdvscr401"; break; // Recitation - Cle 4 (DoTF with WotC errata) - All allies in colossal burst (centered on you) gain +2 to attack rolls, saves, and skill checks, all enemies in burst suffer -2 penalty to same, no save for enemies, but spell resistance applies. Lasts 1 round/lvl.
            case 41: sResult = "sp_it_sparscr410"; break; // Sinsabur's Baleful Bolt - Sorc/Wiz 4 (UE) - Bold that does 1d3 + (1 / 4 levels), max 1d3+3 of str and con damage.
            case 42: sResult = "sp_it_sparscr411"; break; // Viscid Glob - Sorc/Wiz 4 (UND) - Ranged touch attack, reflex save or target is stuck in place, and paralyzed if medium or smaller.
            case 43: sResult = "sp_it_sparscr406"; break; // Sonic Orb - Sorc/Wiz 4 (T&B) - Fires orb of sound that does 1d6/lvl, max 15d6.  Fort save for 1/2, target is deafened for one round on a failed save.
            case 44: sResult = "sp_it_sparscr408"; break; // Mass Ultravision - Druid/Ranger 3, Bard/Cleric/Sorc/Wiz 4 (T&B) - As ultravision but all friendly targets in a large burst.
         }
         break;

      case 5:
         switch (iRandomizer)
         {
            case 0: sResult = "nw_it_sparscr509"; break;
            case 1: sResult = "x2_it_spdvscr508"; break;
            case 2: sResult = "x2_it_spavscr501"; break;
            case 3: sResult = "x2_it_spdvscr501"; break;
            case 4: sResult = "x1_it_sparscr502"; break;
            case 5: sResult = "x2_it_spdvscr504"; break;
            case 6: sResult = "nw_it_sparscr502"; break;
            case 7: sResult = "nw_it_sparscr507"; break;
            case 8: sResult = "nw_it_sparscr501"; break;
            case 9: sResult = "nw_it_sparscr503"; break;
            case 10: sResult = "x2_it_spavscr503"; break;
            case 11: sResult = "x2_it_spdvscr509"; break;
            case 12: sResult = "nw_it_sparscr504"; break;
            case 13: sResult = "x1_it_sparscr501"; break;
            case 14: sResult = "x1_it_spdvscr403"; break;
            case 15: sResult = "nw_it_sparscr508"; break;
            case 16: sResult = "x2_it_spdvscr505"; break;
            case 17: sResult = "nw_it_sparscr505"; break;
            case 18: sResult = "x1_it_spdvscr501"; break;
            case 19: sResult = "nw_it_sparscr511"; break;
            case 20: sResult = "nw_it_sparscr512"; break;
            case 21: sResult = "nw_it_sparscr513"; break;
            case 22: sResult = "x2_it_spavscr502"; break;
            case 23: sResult = "nw_it_sparscr506"; break;
            case 24: sResult = "x2_it_spdvscr502"; break;
            case 25: sResult = "x1_it_spdvscr502"; break;
            case 26: sResult = "nw_it_spdvscr501"; break;
            case 27: sResult = "x2_it_spdvscr506"; break;
            case 28: sResult = "x2_it_spdvscr507"; break;
            case 29: sResult = "nw_it_sparscr510"; break;
            case 30: sResult = "x2_it_spdvscr503"; break;
            // PrC Spells
            case 31: sResult = "sp_it_sparscr503"; break; // Beltyn's Burning Blood - Sorc/Wiz 5 (UE) - 1d8 acid and 1d8 fire damage per round, 1 round / level.  Fort save to negate damage for that round, target is slowed on any round that it fails it's save.
            case 32: sResult = "sp_it_sparscr502"; break; // Greater Fireburst Sorc/Wiz 5 (Mini) - Medium burst of fire centered on caster does 1d8/lvl (max 15d8), reflex save for half.
            case 33: sResult = "sp_it_sparscr501"; break; // Greater Heroism - Bard 5, Sorc/Wiz 6 (3.5) - Gives target +4 bonus to attack rolls, saves, and skill checks, immune to fear, and temporary hit points equal to caster level, max 20.  Lasts 1 turn/lvl.
            case 34: sResult = "sp_it_spdvscr503"; break; // Legion's Curse of Petty Failing - Cle 5 (Mini) - All targets in a huge burst receive a -2 penalty to attacks and saves.
            case 35: sResult = "sp_it_spdvscr502"; break; // Righteous Might - Cle 5 (3.5) - Caster receives +8 to strength, +4 to constitution, +4 natural armor bonus, and damage reduction varying from 5/+1 to 15/+1 depending on caster level.  Lasts 1 round/lvl.
            case 36: sResult = "sp_it_spdvscr504"; break; // Soul Scour - Cleric 5 (UE) - Target takes 2d6 cha and 1d6 wis damage, will negates.  One minute later takes 1d6 additional cha damage.
            case 37: sResult = "sp_it_spdvscr501"; break; // Mass Cure Light Wounds - Cle 5, Dru 6 (3.5) - Huge burst, heals 2d8+1/lvl, max 1d8+30, to friendly targets, harms undead by same amount, up to 1 target/lvl.
         }
         break;

      case 6:
         switch (iRandomizer)
         {
            case 0: sResult = "x1_it_spdvscr601"; break;
            case 1: sResult = "x1_it_spdvscr605"; break;
            case 2: sResult = "nw_it_sparscr603"; break;
            case 3: sResult = "x1_it_sparscr602"; break;
            case 4: sResult = "x2_it_spdvscr603"; break;
            case 5: sResult = "nw_it_sparscr607"; break;
            case 6: sResult = "nw_it_sparscr610"; break;
            case 7: sResult = "x2_it_spdvscr601"; break;
            case 8: sResult = "x1_it_sparscr601"; break;
            case 9: sResult = "x1_it_spdvscr604"; break;
            case 10: sResult = "nw_it_sparscr608"; break;
            case 11: sResult = "x1_it_sparscr605"; break;
            case 12: sResult = "nw_it_sparscr601"; break;
            case 13: sResult = "nw_it_sparscr602"; break;
            case 14: sResult = "x2_it_spdvscr606"; break;
            case 15: sResult = "nw_it_sparscr612"; break;
            case 16: sResult = "nw_it_sparscr613"; break;
            case 17: sResult = "x2_it_spdvscr604"; break;
            case 18: sResult = "x2_it_spdvscr605"; break;
            case 19: sResult = "x1_it_sparscr603"; break;
            case 20: sResult = "x2_it_spavscr602"; break;
            case 21: sResult = "nw_it_sparscr611"; break;
            case 22: sResult = "x1_it_spdvscr603"; break;
            case 23: sResult = "nw_it_sparscr604"; break;
            case 24: sResult = "nw_it_sparscr609"; break;
            case 25: sResult = "x1_it_sparscr604"; break;
            case 26: sResult = "x2_it_spdvscr602"; break;
            case 27: sResult = "nw_it_sparscr605"; break;
            case 28: sResult = "nw_it_sparscr614"; break;
            case 29: sResult = "nw_it_sparscr606"; break;
            case 30: sResult = "x2_it_spavscr601"; break;
            // PrC Spells
            case 31: sResult = "sp_it_sparscr609"; break; // Mass Owl's Wisdom - Bard/Cle/Dru/Sorc/Wiz 6 (3.5 but using 3.0 stats) - As owl's wisdom but all friendly targets in a large burst.
            case 32: sResult = "sp_it_sparscr601"; break; // Acid Storm - Sorc/Wiz 6 (FRCS) - Rain of acid, 1d6/lvl dmage, max 15d6 to all in area, reflex save for 1/2.
            case 33: sResult = "sp_it_sparscr602"; break; // Disintegrate - Sorc/Wiz 6 (3.0) - Ray, ranged touch attack, if successful target must make a fort save or be destroyed, if the save is successful the target takes 5d6 damage.
            case 34: sResult = "sp_it_sparscr605"; break; // Energy Immunity - Cle/Dru 6, Sorc/Wiz 7 (T&B) - Makes the target immune to 1 element for 24 hours.
            case 35: sResult = "sp_it_sparscr603"; break; // Mass Bull's Strength - Bard/Cle/Dru/Sorc/Wiz 6 (3.5 but using 3.0 stats) - As bull's strength but all friendly targets in a large burst.
            case 36: sResult = "sp_it_sparscr604"; break; // Mass Cat's Grace - Bard/Dru/Sorc/Wiz 6 (3.5 but using 3.0 stats) - As cat's grace but all friendly targets in a large burst.
            case 37: sResult = "sp_it_spdvscr601"; break; // Mass Cure Moderate Wounds - Cle 6, Dru 7 (3.5) - Huge burst, heals 3d8+1/lvl, max 1d8+35, to friendly targets, harms undead by same amount, up to 1 target/lvl.
            case 38: sResult = "sp_it_sparscr606"; break; // Mass Eagle's Splendor - Bard/Cle/Dru/Sorc/Wiz 6 (3.5 but using 3.0 stats) - As eagle's splendor but all friendly targets in a large burst.
            case 39: sResult = "sp_it_sparscr607"; break; // Mass Endurance - Cle/Dru/Sorc/Wiz 6 (3.5 but using 3.0 stats) - As endurance but all friendly targets in a large burst.
            case 40: sResult = "sp_it_sparscr608"; break; // Mass Fox's Cunning - Bard/Cle/Dru/Sorc/Wiz 6 (3.5 but using 3.0 stats) - As fox's cunning but all friendly targets in a large burst.
         }
         break;

      case 7:
         switch (iRandomizer)
         {
            case 0: sResult = "x1_it_spdvscr701"; break;
            case 1: sResult = "x1_it_sparscr701"; break;
            case 2: sResult = "nw_it_sparscr707"; break;
            case 3: sResult = "x1_it_spdvscr702"; break;
            case 4: sResult = "nw_it_sparscr704"; break;
            case 5: sResult = "x1_it_spdvscr703"; break;
            case 6: sResult = "nw_it_sparscr708"; break;
            case 7: sResult = "x2_it_spavscr701"; break;
            case 8: sResult = "nw_it_spdvscr701"; break;
            case 9: sResult = "nw_it_sparscr705"; break;
            case 10: sResult = "nw_it_sparscr702"; break;
            case 11: sResult = "nw_it_sparscr706"; break;
            case 12: sResult = "nw_it_sparscr802"; break;
            case 13: sResult = "x2_it_spdvscr702"; break;
            case 14: sResult = "nw_it_spdvscr702"; break;
            case 15: sResult = "x2_it_spavscr703"; break;
            case 16: sResult = "nw_it_sparscr701"; break;
            case 17: sResult = "nw_it_sparscr703"; break;
            case 18: sResult = "x2_it_spdvscr701"; break;
            // PrC Spells
            case 19: sResult = "sp_it_spdvscr701"; break; // Mass Cure Serious Wounds - Cle 7, Dru 8 (3.5) - Huge burst, heals 4d8+1/lvl, max 1d8+40, to friendly targets, harms undead by same amount, up to 1 target/lvl.
            case 20: sResult = "sp_it_sparscr704"; break; // Mass Hold Person - Sorc/Wiz 7 (3.5) - As hold person but but up to 1 target/lvl in huge burst.
            case 21: sResult = "sp_it_sparscr702"; break; // Mordenkainen's Magnificent Mansion - Sorc/Wiz 7 (3.0) - Conjures extradimensional mansion to provide a place of rest.  Only those the caster allows (i.e. the caster's party) may enter the mansion.  Party enters/exits mansion as a whole, lasts until party exits the mansion.
            case 22: sResult = "sp_it_sparscr705"; break; // Nybor's Stern Reproof - Sorc/Wiz 7 (UE) - Fort save or die, if made will save or dazed for 1d4 rounds.  Takes a -2 penalty to attacks, saves, and checks for 1 round / level, no save.
            case 23: sResult = "sp_it_spdvscr702"; break; // Word of Balance - Druid 7 (UND) - Gargantuan
         }
         break;

      case 8:
         switch (iRandomizer)
         {
            case 0: sResult = "x1_it_spdvscr802"; break;
            case 1: sResult = "x2_it_spdvscr804"; break;
            case 2: sResult = "x1_it_sparscr801"; break;
            case 3: sResult = "x2_it_spavscr801"; break;
            case 4: sResult = "x1_it_spdvscr803"; break;
            case 5: sResult = "x1_it_spdvscr804"; break;
            case 6: sResult = "x1_it_spdvscr801"; break;
            case 7: sResult = "x1_it_spdvscr704"; break;
            case 8: sResult = "nw_it_sparscr803"; break;
            case 9: sResult = "x1_it_spdvscr602"; break;
            case 10: sResult = "nw_it_sparscr809"; break;
            case 11: sResult = "nw_it_sparscr804"; break;
            case 12: sResult = "nw_it_sparscr807"; break;
            case 13: sResult = "nw_it_sparscr806"; break;
            case 14: sResult = "x2_it_spdvscr801"; break;
            case 15: sResult = "nw_it_sparscr801"; break;
            case 16: sResult = "x2_it_spdvscr802"; break;
            case 17: sResult = "nw_it_sparscr808"; break;
            case 18: sResult = "nw_it_sparscr805"; break;
            case 19: sResult = "x2_it_spdvscr803"; break;
            // PrC Spells
            case 20: sResult = "sp_it_sparscr802"; break; // Flensing - Sorc/Wiz 8 (FRCS) - Target takes 2d6 damage, 1d6 cha and con damage each round for 4 rounds.  Fort save on each round to half the damage and negate the ability damage for that round.
            case 21: sResult = "sp_it_sparscr801"; break; // Mantle of Egregious Might - Sorc/Wiz 8 (BoEM 2) - Target receives +4 bonus to all ability scores, AC, attack rolls, and saving throws.  Lasts 10 min/lvl.
            case 22: sResult = "sp_it_spdvscr801"; break; // Mass Cure Critical Wounds - Cle 8, Dru 9 (3.5) - Huge burst, heals 1d8+1/lvl, max 1d8+25, to friendly targets, harms undead by same amount, up to 1 target/lvl.
         }
         break;

      case 9:
         switch (iRandomizer)
         {
            case 0: sResult = "x1_it_sparscr901"; break;
            case 1: sResult = "x2_it_spavscr901"; break;
            case 2: sResult = "nw_it_sparscr905"; break;
            case 3: sResult = "x2_it_spdvscr901"; break;
            case 4: sResult = "nw_it_sparscr908"; break;
            case 5: sResult = "nw_it_sparscr902"; break;
            case 6: sResult = "nw_it_sparscr912"; break;
            case 7: sResult = "x2_it_spdvscr902"; break;
            case 8: sResult = "nw_it_sparscr906"; break;
            case 9: sResult = "nw_it_sparscr901"; break;
            case 10: sResult = "nw_it_sparscr903"; break;
            case 11: sResult = "nw_it_sparscr910"; break;
            case 12: sResult = "x2_it_spdvscr903"; break;
            case 13: sResult = "nw_it_sparscr904"; break;
            case 14: sResult = "x2_it_spavscr902"; break;
            case 15: sResult = "nw_it_sparscr911"; break;
            case 16: sResult = "x1_it_spdvscr901"; break;
            case 17: sResult = "nw_it_sparscr909"; break;
            case 18: sResult = "nw_it_sparscr907"; break;
            // PrC Spells
            case 19: sResult = "sp_it_spdvscr901"; break; // Drown, Mass - Druid 9 (UND) - As drown, but all targets in a huge radius.
            case 20: sResult = "sp_it_sparscr901"; break; // Mass Hold Monster - Sorc/Wiz 9 (3.5) - As hold monster but but up to 1 target/lvl in huge burst.
            case 21: sResult = "sp_it_sparscr902"; break; // Sphere of Ultimate Destruction - Sorc/Wiz 9 (UE) - Summons a sphere of energy for 1 round / level that disintegrates opponents.
         }
         break;
   }
   return (sResult);
}

int ip_GetRandomPotionSpell(int iLevel = 0)
{
   // Potions have
   // a 15% chance to be of the desired level
   // a 20% chance to be of 3 levels within the desired level
   // a 30% chance to be of 6 levels within the desired level
   // a 35% chance to roll totally random
   int nChance = Random(100) + 1;
   if (nChance < 36)
      iLevel = Random(iLevel) + 1;
   else if (nChance < 66)
      iLevel = iLevel - Random(6);
   else if (nChance < 86)
      iLevel = iLevel - Random(3);

   // if we reduced iLevel below 0, set to 0
   if (iLevel < 0)
      iLevel = 0;

   int iNumber;
   switch (iLevel)
   {
      case 0: iNumber = 5; break;
      case 1: iNumber = 11; break;
      case 2: iNumber = 6; break;
      case 3: iNumber = 25; break;
      case 4: iNumber = 25; iLevel = 3; break;
      case 5: iNumber = 25; break;
      case 6: iNumber = 3; break;
      case 7: iNumber = 15; break;
      case 8: iNumber = 15; iLevel = 7; break;
      case 9: iNumber = 8; break;
      case 10: iNumber = 14; break;
      case 11: iNumber = 10; break;
      case 12: iNumber = 3; break;
      case 13: iNumber = 6; break;
      case 14: iNumber = 6; iLevel = 13; break;
      case 15: iNumber = 17; break;
      case 16: iNumber = 17; iLevel = 15; break;
      case 17: iNumber = 3; break;
      case 18: iNumber = 1; break;
      case 19: iNumber = 1; iLevel = 18; break;
      case 20: iNumber = 1; break;
   }
   int iRandomizer = Random(iNumber);
   int iResult;
   switch (iLevel)
   {
      case 0:
         switch (iRandomizer)
         {
            // Potions/Wands Reduced Spell Number
            // Potions Only, no other item can hold that (Wands could hold them too, but wtf??)
            case 0: iResult = IP_CONST_CASTSPELL_SPECIAL_ALCOHOL_BEER; break;
            case 1: iResult = IP_CONST_CASTSPELL_SPECIAL_ALCOHOL_WINE; break;
            case 2: iResult = IP_CONST_CASTSPELL_SPECIAL_ALCOHOL_SPIRITS; break;
            case 3: iResult = IP_CONST_CASTSPELL_SPECIAL_HERB_BELLADONNA; break;
            case 4: iResult = IP_CONST_CASTSPELL_SPECIAL_HERB_GARLIC; break;
         }
         break;

      case 1:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_GRENADE_ACID_1; break;
            case 1: iResult = IP_CONST_CASTSPELL_GRENADE_CALTROPS_1; break;
            case 2: iResult = IP_CONST_CASTSPELL_GRENADE_CHICKEN_1; break;
            case 3: iResult = IP_CONST_CASTSPELL_GRENADE_CHOKING_1; break;
            case 4: iResult = IP_CONST_CASTSPELL_GRENADE_FIRE_1; break;
            case 5: iResult = IP_CONST_CASTSPELL_GRENADE_HOLY_1; break;
            case 6: iResult = IP_CONST_CASTSPELL_GRENADE_TANGLE_1; break;
            case 7: iResult = IP_CONST_CASTSPELL_GRENADE_THUNDERSTONE_1; break;
            case 8: iResult = IP_CONST_CASTSPELL_CURE_MINOR_WOUNDS_1; break;
            case 9: iResult = IP_CONST_CASTSPELL_LIGHT_1; break;
            case 10: iResult = IP_CONST_CASTSPELL_VIRTUE_1; break;
         }
         break;

      case 2:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_BLESS_2; break;
            case 1: iResult = IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_2; break;
            case 2: iResult = IP_CONST_CASTSPELL_ENDURE_ELEMENTS_2; break;
            case 3: iResult = IP_CONST_CASTSPELL_MAGE_ARMOR_2; break;
            case 4: iResult = IP_CONST_CASTSPELL_REMOVE_FEAR_2; break;
            case 5: iResult = IP_CONST_CASTSPELL_RESISTANCE_2; break;
         }
         break;

      case 3:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_ROGUES_CUNNING_3; break;
            case 1: iResult = IP_CONST_CASTSPELL_AID_3; break;
            case 2: iResult = IP_CONST_CASTSPELL_BARKSKIN_3; break;
            case 3: iResult = IP_CONST_CASTSPELL_BULLS_STRENGTH_3; break;
            case 4: iResult = IP_CONST_CASTSPELL_CATS_GRACE_3; break;
            case 5: iResult = IP_CONST_CASTSPELL_CLARITY_3; break;
            case 6: iResult = IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_3; break;
            case 7: iResult = IP_CONST_CASTSPELL_DARKNESS_3; break;
            case 8: iResult = IP_CONST_CASTSPELL_DARKVISION_3; break;
            case 9: iResult = IP_CONST_CASTSPELL_EAGLE_SPLEDOR_3; break;
            case 10: iResult = IP_CONST_CASTSPELL_ENDURANCE_3; break;
            case 11: iResult = IP_CONST_CASTSPELL_FIND_TRAPS_3; break;
            case 12: iResult = IP_CONST_CASTSPELL_FOXS_CUNNING_3; break;
            case 13: iResult = IP_CONST_CASTSPELL_GHOSTLY_VISAGE_3; break;
            case 14: iResult = IP_CONST_CASTSPELL_HOLD_ANIMAL_3; break;
            case 15: iResult = IP_CONST_CASTSPELL_HOLD_PERSON_3; break;
            case 16: iResult = IP_CONST_CASTSPELL_IDENTIFY_3; break;
            case 17: iResult = IP_CONST_CASTSPELL_INVISIBILITY_3; break;
            case 18: iResult = IP_CONST_CASTSPELL_LESSER_DISPEL_3; break;
            case 19: iResult = IP_CONST_CASTSPELL_LESSER_RESTORATION_3; break;
            case 20: iResult = IP_CONST_CASTSPELL_OWLS_WISDOM_3; break;
            case 21: iResult = IP_CONST_CASTSPELL_PROTECTION_FROM_ELEMENTS_3; break;
            case 22: iResult = IP_CONST_CASTSPELL_REMOVE_PARALYSIS_3; break;
            case 23: iResult = IP_CONST_CASTSPELL_RESIST_ELEMENTS_3; break;
            case 24: iResult = IP_CONST_CASTSPELL_SEE_INVISIBILITY_3; break;
         }
         break;

      case 5:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_AMPLIFY_5; break;
            case 1: iResult = IP_CONST_CASTSPELL_BANE_5; break;
            case 2: iResult = IP_CONST_CASTSPELL_CAMOFLAGE_5; break;
            case 3: iResult = IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_5; break;
            case 4: iResult = IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_5; break;
            case 5: iResult = IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_5; break;
            case 6: iResult = IP_CONST_CASTSPELL_DISPEL_MAGIC_5; break;
            case 7: iResult = IP_CONST_CASTSPELL_DIVINE_FAVOR_5; break;
            case 8: iResult = IP_CONST_CASTSPELL_DIVINE_MIGHT_5; break;
            case 9: iResult = IP_CONST_CASTSPELL_DIVINE_SHIELD_5; break;
            case 10: iResult = IP_CONST_CASTSPELL_ENTROPIC_SHIELD_5; break;
            case 11: iResult = IP_CONST_CASTSPELL_EXPEDITIOUS_RETREAT_5; break;
            case 12: iResult = IP_CONST_CASTSPELL_HASTE_5; break;
            case 13: iResult = IP_CONST_CASTSPELL_LESSER_DISPEL_5; break;
            case 14: iResult = IP_CONST_CASTSPELL_LIGHT_5; break;
            case 15: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_5; break;
            case 16: iResult = IP_CONST_CASTSPELL_NEUTRALIZE_POISON_5; break;
            case 17: iResult = IP_CONST_CASTSPELL_PRAYER_5; break;
            case 18: iResult = IP_CONST_CASTSPELL_REMOVE_BLINDNESS_DEAFNESS_5; break;
            case 19: iResult = IP_CONST_CASTSPELL_REMOVE_CURSE_5; break;
            case 20: iResult = IP_CONST_CASTSPELL_REMOVE_DISEASE_5; break;
            case 21: iResult = IP_CONST_CASTSPELL_RESISTANCE_5; break;
            case 22: iResult = IP_CONST_CASTSPELL_SHIELD_5; break;
            case 23: iResult = IP_CONST_CASTSPELL_SHIELD_OF_FAITH_5; break;
            case 24: iResult = IP_CONST_CASTSPELL_TRUE_STRIKE_5; break;
         }
         break;

      case 6:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_BARKSKIN_6; break;
            case 1: iResult = IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_6; break;
            case 2: iResult = IP_CONST_CASTSPELL_DARKVISION_6; break;
         }
         break;

      case 7:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_GREATER_DISPELLING_7; break;
            case 1: iResult = IP_CONST_CASTSPELL_MINOR_GLOBE_OF_INVULNERABILITY_7; break;
            case 2: iResult = IP_CONST_CASTSPELL_AURAOFGLORY_7; break;
            case 3: iResult = IP_CONST_CASTSPELL_BLOOD_FRENZY_7; break;
            case 4: iResult = IP_CONST_CASTSPELL_CONTINUAL_FLAME_7; break;
            case 5: iResult = IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_7; break;
            case 6: iResult = IP_CONST_CASTSPELL_DEATH_WARD_7; break;
            case 7: iResult = IP_CONST_CASTSPELL_DIVINE_POWER_7; break;
            case 8: iResult = IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_7; break;
            case 9: iResult = IP_CONST_CASTSPELL_FREEDOM_OF_MOVEMENT_7; break;
            case 10: iResult = IP_CONST_CASTSPELL_HOLD_MONSTER_7; break;
            case 11: iResult = IP_CONST_CASTSPELL_ONE_WITH_THE_LAND_7; break;
            case 12: iResult = IP_CONST_CASTSPELL_POLYMORPH_SELF_7; break;
            case 13: iResult = IP_CONST_CASTSPELL_RESTORATION_7; break;
            case 14: iResult = IP_CONST_CASTSPELL_STONESKIN_7; break;
         }
         break;

      case 9:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_ETHEREAL_VISAGE_9; break;
            case 1: iResult = IP_CONST_CASTSPELL_LESSER_MIND_BLANK_9; break;
            case 2: iResult = IP_CONST_CASTSPELL_LESSER_SPELL_MANTLE_9; break;
            case 3: iResult = IP_CONST_CASTSPELL_RAISE_DEAD_9; break;
            case 4: iResult = IP_CONST_CASTSPELL_SPELL_RESISTANCE_9; break;
            case 5: iResult = IP_CONST_CASTSPELL_TRUE_SEEING_9; break;
            case 6: iResult = IP_CONST_CASTSPELL_DISPLACEMENT_9; break;
            case 7: iResult = IP_CONST_CASTSPELL_GHOSTLY_VISAGE_9; break;
         }
         break;

      case 10:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_BULLS_STRENGTH_10; break;
            case 1: iResult = IP_CONST_CASTSPELL_CATS_GRACE_10; break;
            case 2: iResult = IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_10; break;
            case 3: iResult = IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_10; break;
            case 4: iResult = IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_10; break;
            case 5: iResult = IP_CONST_CASTSPELL_DISPEL_MAGIC_10; break;
            case 6: iResult = IP_CONST_CASTSPELL_EAGLE_SPLEDOR_10; break;
            case 7: iResult = IP_CONST_CASTSPELL_ENDURANCE_10; break;
            case 8: iResult = IP_CONST_CASTSPELL_FOXS_CUNNING_10; break;
            case 9: iResult = IP_CONST_CASTSPELL_HASTE_10; break;
            case 10: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_10; break;
            case 11: iResult = IP_CONST_CASTSPELL_OWLS_WISDOM_10; break;
            case 12: iResult = IP_CONST_CASTSPELL_PROTECTION_FROM_ELEMENTS_10; break;
            case 13: iResult = IP_CONST_CASTSPELL_RESIST_ELEMENTS_10; break;
         }
         break;

      case 11:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_GLOBE_OF_INVULNERABILITY_11; break;
            case 1: iResult = IP_CONST_CASTSPELL_GREATER_BULLS_STRENGTH_11; break;
            case 2: iResult = IP_CONST_CASTSPELL_GREATER_CATS_GRACE_11; break;
            case 3: iResult = IP_CONST_CASTSPELL_GREATER_EAGLES_SPLENDOR_11; break;
            case 4: iResult = IP_CONST_CASTSPELL_GREATER_ENDURANCE_11; break;
            case 5: iResult = IP_CONST_CASTSPELL_GREATER_FOXS_CUNNING_11; break;
            case 6: iResult = IP_CONST_CASTSPELL_HEAL_11; break;
            case 7: iResult = IP_CONST_CASTSPELL_GREATER_OWLS_WISDOM_11; break;
            case 8: iResult = IP_CONST_CASTSPELL_GREATER_STONESKIN_11; break;
            case 9: iResult = IP_CONST_CASTSPELL_TENSERS_TRANSFORMATION_11; break;
         }
         break;

      case 12:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_BARKSKIN_12; break;
            case 1: iResult = IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_12; break;
            case 2: iResult = IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_12; break;
         }
         break;

      case 13:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_GREATER_RESTORATION_13; break;
            case 1: iResult = IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_13; break;
            case 2: iResult = IP_CONST_CASTSPELL_RESURRECTION_13; break;
            case 3: iResult = IP_CONST_CASTSPELL_SHADOW_SHIELD_13; break;
            case 4: iResult = IP_CONST_CASTSPELL_SPELL_MANTLE_13; break;
            case 5: iResult = IP_CONST_CASTSPELL_MASS_CAMOFLAGE_13; break;
         }
         break;

      case 15:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_ETHEREAL_VISAGE_15; break;
            case 1: iResult = IP_CONST_CASTSPELL_GREATER_DISPELLING_15; break;
            case 2: iResult = IP_CONST_CASTSPELL_MINOR_GLOBE_OF_INVULNERABILITY_15; break;
            case 3: iResult = IP_CONST_CASTSPELL_PREMONITION_15; break;
            case 4: iResult = IP_CONST_CASTSPELL_SPELL_RESISTANCE_15; break;
            case 5: iResult = IP_CONST_CASTSPELL_BULLS_STRENGTH_15; break;
            case 6: iResult = IP_CONST_CASTSPELL_CATS_GRACE_15; break;
            case 7: iResult = IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_15; break;
            case 8: iResult = IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_15; break;
            case 9: iResult = IP_CONST_CASTSPELL_EAGLE_SPLEDOR_15; break;
            case 10: iResult = IP_CONST_CASTSPELL_ENDURANCE_15; break;
            case 11: iResult = IP_CONST_CASTSPELL_FOXS_CUNNING_15; break;
            case 12: iResult = IP_CONST_CASTSPELL_GHOSTLY_VISAGE_15; break;
            case 13: iResult = IP_CONST_CASTSPELL_MIND_BLANK_15; break;
            case 14: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_15; break;
            case 15: iResult = IP_CONST_CASTSPELL_OWLS_INSIGHT_15; break;
            case 16: iResult = IP_CONST_CASTSPELL_OWLS_WISDOM_15; break;
         }
         break;

      case 17:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_GREATER_SPELL_MANTLE_17; break;
            case 1: iResult = IP_CONST_CASTSPELL_MORDENKAINENS_DISJUNCTION_17; break;
            case 2: iResult = IP_CONST_CASTSPELL_SHAPECHANGE_17; break;
         }
         break;

      case 18:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_ETHEREALNESS_18; break;
         }
         break;

      case 20:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_20; break;
         }
         break;
   }
   return (iResult);
}

int ip_GetRandomWandSpell(int iLevel, int iIncludePrCSpells = FALSE)
{
   // Wandspells have
   // a 15% chance to be of the desired level
   // a 20% chance to be of 3 levels within the desired level
   // a 30% chance to be of 6 levels within the desired level
   // a 35% chance to roll totally random
   int nChance = Random(100) + 1;
   if (nChance < 36)
      iLevel = Random(iLevel) + 1;
   else if (nChance < 66)
      iLevel = iLevel - Random(6);
   else if (nChance < 86)
      iLevel = iLevel - Random(3);

   // if we reduced iLevel below 0, set to 0
   if (iLevel < 0)
      iLevel = 0;

   int iNumber;
   if (iIncludePrCSpells)
   {
      switch (iLevel)
      {
         case 0: iNumber = 14; iLevel = 1; break;
         case 1: iNumber = 14; break;
         case 2: iNumber = 20; break;
         case 3: iNumber = 54; break;
         case 4: iNumber = 54; iLevel = 3; break;
         case 5: iNumber = 72; break;
         case 6: iNumber = 4; break;
         case 7: iNumber = 43; break;
         case 8: iNumber = 1; break;
         case 9: iNumber = 20; break;
         case 10: iNumber = 35; break;
         case 11: iNumber = 35; iLevel = 10; break;
         case 12: iNumber = 12; break;
         case 13: iNumber = 3; break;
         case 14: iNumber = 3; iLevel = 13; break;
         case 15: iNumber = 31; break;
         case 16: iNumber = 31; iLevel = 15; break;
         case 17: iNumber = 3; break;
         case 18: iNumber = 5; break;
         case 19: iNumber = 5; iLevel = 18; break;
         case 20: iNumber = 8; break;
      }
   }
   else
   {
      switch (iLevel)
      {
         case 0: iNumber = 10; iLevel = 1; break;
         case 1: iNumber = 10; break;
         case 2: iNumber = 18; break;
         case 3: iNumber = 36; break;
         case 4: iNumber = 36; iLevel = 3; break;
         case 5: iNumber = 55; break;
         case 6: iNumber = 4; break;
         case 7: iNumber = 27; break;
         case 8: iNumber = 1; break;
         case 9: iNumber = 12; break;
         case 10: iNumber = 25; break;
         case 11: iNumber = 25; iLevel = 10; break;
         case 12: iNumber = 8; break;
         case 13: iNumber = 2; break;
         case 14: iNumber = 2; iLevel = 13; break;
         case 15: iNumber = 22; break;
         case 16: iNumber = 22; iLevel = 15; break;
         case 17: iNumber = 2; break;
         case 18: iNumber = 4; break;
         case 19: iNumber = 4; iLevel = 18; break;
         case 20: iNumber = 6; break;
      }
   }
   int iRandomizer = Random(iNumber);
   int iResult;
   switch (iLevel)
   {
      case 1:
         switch (iRandomizer)
         {
            // Wands and other Items, but no Potions
            case 0: iResult = IP_CONST_CASTSPELL_ACID_SPLASH_1; break;
            case 1: iResult = IP_CONST_CASTSPELL_DAZE_1; break;
            case 2: iResult = IP_CONST_CASTSPELL_ELECTRIC_JOLT_1; break;
            case 3: iResult = IP_CONST_CASTSPELL_FLARE_1; break;
            case 4: iResult = IP_CONST_CASTSPELL_INFLICT_MINOR_WOUNDS_1; break;
            case 5: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_1; break;
            case 6: iResult = IP_CONST_CASTSPELL_RAY_OF_FROST_1; break;
            case 7: iResult = IP_CONST_CASTSPELL_CURE_MINOR_WOUNDS_1; break;
            case 8: iResult = IP_CONST_CASTSPELL_LIGHT_1; break;
            case 9: iResult = IP_CONST_CASTSPELL_VIRTUE_1; break;
            // PrC Spells
            case 10: iResult = 1079; break; //  Lionheart                         16830415 1         1         750    3160       0         1       1          iss_lionheart
            case 11: iResult = 1066; break; //  Conviction                        16830402 1         1         750    3151       1         1       1          iss_convict
            case 12: iResult = 1065; break; //  Benign_Transposition              16830401 1         1         750    3150       0         1       1          iss_benitrans
            case 13: iResult = 1106; break; //  Nybors_Gentle_Reminder            16830484 1         1         750    3175       0         1       1          iss_nybgentrem
         }
         break;

      case 2:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_BURNING_HANDS_2; break;
            case 1: iResult = IP_CONST_CASTSPELL_CHARM_PERSON_2; break;
            case 2: iResult = IP_CONST_CASTSPELL_COLOR_SPRAY_2; break;
            case 3: iResult = IP_CONST_CASTSPELL_DOOM_2; break;
            case 4: iResult = IP_CONST_CASTSPELL_ENTANGLE_2; break;
            case 5: iResult = IP_CONST_CASTSPELL_GREASE_2; break;
            case 6: iResult = IP_CONST_CASTSPELL_PROTECTION_FROM_ALIGNMENT_2; break;
            case 7: iResult = IP_CONST_CASTSPELL_RAY_OF_ENFEEBLEMENT_2; break;
            case 8: iResult = IP_CONST_CASTSPELL_SANCTUARY_2; break;
            case 9: iResult = IP_CONST_CASTSPELL_SCARE_2; break;
            case 10: iResult = IP_CONST_CASTSPELL_SLEEP_2; break;
            case 11: iResult = IP_CONST_CASTSPELL_SUMMON_CREATURE_I_2; break;
            case 12: iResult = IP_CONST_CASTSPELL_BLESS_2; break;
            case 13: iResult = IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_2; break;
            case 14: iResult = IP_CONST_CASTSPELL_ENDURE_ELEMENTS_2; break;
            case 15: iResult = IP_CONST_CASTSPELL_MAGE_ARMOR_2; break;
            case 16: iResult = IP_CONST_CASTSPELL_REMOVE_FEAR_2; break;
            case 17: iResult = IP_CONST_CASTSPELL_RESISTANCE_2; break;
            // PrC Spells
            case 18: iResult = 1118; break; //  Hail_of_Stone                     16830496 2         1         1500   3183       0         1       1          iss_hailofstone
            case 19: iResult = 1112; break; //  Snillocs_Snowball                 16830490 2         1         1500   3178       0         1       1          iss_snsnow
         }
         break;

      case 3:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_BLINDNESS_DEAFNESS_3; break;
            case 1: iResult = IP_CONST_CASTSPELL_CHARM_PERSON_OR_ANIMAL_3; break;
            case 2: iResult = IP_CONST_CASTSPELL_FLAME_LASH_3; break;
            case 3: iResult = IP_CONST_CASTSPELL_GHOUL_TOUCH_3; break;
            case 4: iResult = IP_CONST_CASTSPELL_KNOCK_3; break;
            case 5: iResult = IP_CONST_CASTSPELL_MAGIC_MISSILE_3; break;
            case 6: iResult = IP_CONST_CASTSPELL_MELFS_ACID_ARROW_3; break;
            case 7: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_3; break;
            case 8: iResult = IP_CONST_CASTSPELL_SILENCE_3; break;
            case 9: iResult = IP_CONST_CASTSPELL_SOUND_BURST_3; break;
            case 10: iResult = IP_CONST_CASTSPELL_SUMMON_CREATURE_II_3; break;
            case 11: iResult = IP_CONST_CASTSPELL_WEB_3; break;
            case 12: iResult = IP_CONST_CASTSPELL_AID_3; break;
            case 13: iResult = IP_CONST_CASTSPELL_BARKSKIN_3; break;
            case 14: iResult = IP_CONST_CASTSPELL_BULLS_STRENGTH_3; break;
            case 15: iResult = IP_CONST_CASTSPELL_CATS_GRACE_3; break;
            case 16: iResult = IP_CONST_CASTSPELL_CLARITY_3; break;
            case 17: iResult = IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_3; break;
            case 18: iResult = IP_CONST_CASTSPELL_DARKNESS_3; break;
            case 19: iResult = IP_CONST_CASTSPELL_DARKVISION_3; break;
            case 20: iResult = IP_CONST_CASTSPELL_EAGLE_SPLEDOR_3; break;
            case 21: iResult = IP_CONST_CASTSPELL_ENDURANCE_3; break;
            case 22: iResult = IP_CONST_CASTSPELL_FIND_TRAPS_3; break;
            case 23: iResult = IP_CONST_CASTSPELL_FOXS_CUNNING_3; break;
            case 24: iResult = IP_CONST_CASTSPELL_GHOSTLY_VISAGE_3; break;
            case 25: iResult = IP_CONST_CASTSPELL_HOLD_ANIMAL_3; break;
            case 26: iResult = IP_CONST_CASTSPELL_HOLD_PERSON_3; break;
            case 27: iResult = IP_CONST_CASTSPELL_IDENTIFY_3; break;
            case 28: iResult = IP_CONST_CASTSPELL_INVISIBILITY_3; break;
            case 29: iResult = IP_CONST_CASTSPELL_LESSER_DISPEL_3; break;
            case 30: iResult = IP_CONST_CASTSPELL_LESSER_RESTORATION_3; break;
            case 31: iResult = IP_CONST_CASTSPELL_OWLS_WISDOM_3; break;
            case 32: iResult = IP_CONST_CASTSPELL_PROTECTION_FROM_ELEMENTS_3; break;
            case 33: iResult = IP_CONST_CASTSPELL_REMOVE_PARALYSIS_3; break;
            case 34: iResult = IP_CONST_CASTSPELL_RESIST_ELEMENTS_3; break;
            case 35: iResult = IP_CONST_CASTSPELL_SEE_INVISIBILITY_3; break;
            // PrC Spells
            case 36: iResult = 1094; break; //  Shadow_Spray                      16830472 3         2         4500   3170       0         1       1          iss_shadspray
            case 37: iResult = 1060; break; //  Lesser_Fire_Orb                   16830362 3         1         999    3147       0         1       1          iss_lfireorb
            case 38: iResult = 1096; break; //  Snillocs_Snowball_Swarm           16830474 3         2         4500   3171       0         1       1          iss_snsnowsw
            case 39: iResult = 1058; break; //  Lesser_Electric_Orb               16830358 3         1         999    3146       0         1       1          iss_lelecorb
            case 40: iResult = 1089; break; //  Create_Magic_Tatoo                16830467 3         2         4500   3166       0         1       1          iss_createtatoo
            case 41: iResult = 1064; break; //  Baleful_Transposition             16830400 3         2         4500   3149       0         1       1          iss_baletrans
            case 42: iResult = 1087; break; //  Agnazzars_Scorcher                16830465 3         2         4500   3165       0         1       1          iss_agnazscorch
            case 43: iResult = 1054; break; //  Lesser_Acid_Orb                   16830350 3         1         999    3144       0         1       1          iss_lacidorb
            case 44: iResult = 1062; break; //  Lesser_Sonic_Orb                  16830366 3         1         999    3148       0         1       1          iss_lsonicorb
            case 45: iResult = 1056; break; //  Lesser_Cold_Orb                   16830354 3         1         999    3145       0         1       1          iss_lcoldorb
            case 46: iResult = 1051; break; //  Glitterdust                       16830343 3         2         4500   3142       0         1       1          iss_gdust
            case 47: iResult = 1070; break; //  Curse_of_Impending_Blades         16830406 3         2         4500   3153       0         1       1          iss_curimpbl
            case 48: iResult = 1035; break; //  Heroism                           16830327 3         2         1250   3133       1         1       1          iss_heroism
            case 49: iResult = 1116; break; //  Clarity_of_Mind                   16830494 3         2         4500   3181       0         1       1          iss_clarityofmind
            case 50: iResult = 1074; break; //  Divine_Protection                 16830410 3         2         4500   3157       0         1       1          iss_divprot
            case 51: iResult = 1075; break; //  Fireburst                         16830411 3         2         4500   3158       0         1       1          iss_fireburst
            case 52: iResult = 1080; break; //  Living_Undeath                    16830416 3         2         4500   3161       1         1       1          iss_livund
            case 53: iResult = 1016; break; //  Burning_Bolt                      16830308 3         1         999    3109       0         1       1          iss_burnbol
         }
         break;

      case 5:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_ANIMATE_DEAD_5; break;
            case 1: iResult = IP_CONST_CASTSPELL_BESTOW_CURSE_5; break;
            case 2: iResult = IP_CONST_CASTSPELL_BURNING_HANDS_5; break;
            case 3: iResult = IP_CONST_CASTSPELL_CALL_LIGHTNING_5; break;
            case 4: iResult = IP_CONST_CASTSPELL_CHARM_MONSTER_5; break;
            case 5: iResult = IP_CONST_CASTSPELL_CONFUSION_5; break;
            case 6: iResult = IP_CONST_CASTSPELL_DOMINATE_ANIMAL_5; break;
            case 7: iResult = IP_CONST_CASTSPELL_DOOM_5; break;
            case 8: iResult = IP_CONST_CASTSPELL_ENTANGLE_5; break;
            case 9: iResult = IP_CONST_CASTSPELL_FEAR_5; break;
            case 10: iResult = IP_CONST_CASTSPELL_FIREBALL_5; break;
            case 11: iResult = IP_CONST_CASTSPELL_FLAME_ARROW_5; break;
            case 12: iResult = IP_CONST_CASTSPELL_INFLICT_LIGHT_WOUNDS_5; break;
            case 13: iResult = IP_CONST_CASTSPELL_INVISIBILITY_PURGE_5; break;
            case 14: iResult = IP_CONST_CASTSPELL_INVISIBILITY_SPHERE_5; break;
            case 15: iResult = IP_CONST_CASTSPELL_LIGHTNING_BOLT_5; break;
            case 16: iResult = IP_CONST_CASTSPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT_5; break;
            case 17: iResult = IP_CONST_CASTSPELL_MAGIC_FANG_5; break;
            case 18: iResult = IP_CONST_CASTSPELL_MAGIC_MISSILE_5; break;
            case 19: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_BURST_5; break;
            case 20: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_5; break;
            case 21: iResult = IP_CONST_CASTSPELL_POISON_5; break;
            case 22: iResult = IP_CONST_CASTSPELL_PROTECTION_FROM_ALIGNMENT_5; break;
            case 23: iResult = IP_CONST_CASTSPELL_SEARING_LIGHT_5; break;
            case 24: iResult = IP_CONST_CASTSPELL_SLEEP_5; break;
            case 25: iResult = IP_CONST_CASTSPELL_SLOW_5; break;
            case 26: iResult = IP_CONST_CASTSPELL_STINKING_CLOUD_5; break;
            case 27: iResult = IP_CONST_CASTSPELL_SUMMON_CREATURE_III_5; break;
            case 28: iResult = IP_CONST_CASTSPELL_SUMMON_CREATURE_I_5; break;
            case 29: iResult = IP_CONST_CASTSPELL_VAMPIRIC_TOUCH_5; break;
            case 30: iResult = IP_CONST_CASTSPELL_AMPLIFY_5; break;
            case 31: iResult = IP_CONST_CASTSPELL_BANE_5; break;
            case 32: iResult = IP_CONST_CASTSPELL_CAMOFLAGE_5; break;
            case 33: iResult = IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_5; break;
            case 34: iResult = IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_5; break;
            case 35: iResult = IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_5; break;
            case 36: iResult = IP_CONST_CASTSPELL_DISPEL_MAGIC_5; break;
            case 37: iResult = IP_CONST_CASTSPELL_DIVINE_FAVOR_5; break;
            case 38: iResult = IP_CONST_CASTSPELL_DIVINE_MIGHT_5; break;
            case 39: iResult = IP_CONST_CASTSPELL_DIVINE_SHIELD_5; break;
            case 40: iResult = IP_CONST_CASTSPELL_ENTROPIC_SHIELD_5; break;
            case 41: iResult = IP_CONST_CASTSPELL_EXPEDITIOUS_RETREAT_5; break;
            case 42: iResult = IP_CONST_CASTSPELL_HASTE_5; break;
            case 43: iResult = IP_CONST_CASTSPELL_LESSER_DISPEL_5; break;
            case 44: iResult = IP_CONST_CASTSPELL_LIGHT_5; break;
            case 45: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_5; break;
            case 46: iResult = IP_CONST_CASTSPELL_NEUTRALIZE_POISON_5; break;
            case 47: iResult = IP_CONST_CASTSPELL_PRAYER_5; break;
            case 48: iResult = IP_CONST_CASTSPELL_REMOVE_BLINDNESS_DEAFNESS_5; break;
            case 49: iResult = IP_CONST_CASTSPELL_REMOVE_CURSE_5; break;
            case 50: iResult = IP_CONST_CASTSPELL_REMOVE_DISEASE_5; break;
            case 51: iResult = IP_CONST_CASTSPELL_RESISTANCE_5; break;
            case 52: iResult = IP_CONST_CASTSPELL_SHIELD_5; break;
            case 53: iResult = IP_CONST_CASTSPELL_SHIELD_OF_FAITH_5; break;
            case 54: iResult = IP_CONST_CASTSPELL_TRUE_STRIKE_5; break;
            // PrC Spells
            case 55: iResult = 1076; break; //  Fireburst                         16830412 5         2         7500   3158       0         1       1          iss_fireburst
            case 56: iResult = 1072; break; //  Curse_of_Petty_Failing            16830408 5         3         11250  3155       0         1       1          iss_curpfail
            case 57: iResult = 1071; break; //  Legions_Curse_of_Impending_Blades 16830407 5         3         11250  3154       0         1       1          iss_lcurimpbl
            case 58: iResult = 1049; break; //  Forceblast                        16830341 5         3         11250  3141       0         1       1          iss_forceblast
            case 59: iResult = 1067; break; //  Legions_Conviction                16830403 5         3         11250  3152       0         1       1          iss_lconvict
            case 60: iResult = 1085; break; //  Slashing_Darkness                 16830421 5         3         11250  3164       0         1       1          iss_slashdark
            case 61: iResult = 1017; break; //  Burning_Bolt                      16830309 5         1         1750   3109       0         1       1          iss_burnbol
            case 62: iResult = 1125; break; //  Greenfire                         16830505 5         3         11250  3187       0         1       1          iss_greenfire
            case 63: iResult = 1119; break; //  Hail_of_Stone                     16830497 5         1         3750   3183       0         1       1          iss_hailofstone
            case 64: iResult = 1107; break; //  Nybors_Gentle_Reminder            16830485 5         1         3750   3175       0         1       1          iss_nybgentrem
            case 65: iResult = 1103; break; //  Improved_Mage_Armor               16830481 5         3         11250  3174       0         1       1          iss_impmagearm
            case 66: iResult = 1033; break; //  Serpents_Sigh                     16830325 5         3         11250  3127       0         1       1          iss_serpsigh
            case 67: iResult = 1092; break; //  Flashburst                        16830470 5         3         11250  3168       0         1       1          iss_flashburst
            case 68: iResult = 1010; break; //  Ice_Burst                         16830302 5         3         11250  3105       0         1       1          iss_iceburst
            case 69: iResult = 1095; break; //  Shadow_Spray                      16830473 5         2         7500   3170       0         1       1          iss_shadspray
            case 70: iResult = 1113; break; //  Snillocs_Snowball                 16830491 5         1         3750   3178       0         1       1          iss_snsnow
            case 71: iResult = 1120; break; //  Spiderskin                        16830498 5         3         11250  3184       0         1       1          iss_spiderskin
         }
         break;

      case 6:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_MELFS_ACID_ARROW_6; break;
            case 1: iResult = IP_CONST_CASTSPELL_BARKSKIN_6; break;
            case 2: iResult = IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_6; break;
            case 3: iResult = IP_CONST_CASTSPELL_DARKVISION_6; break;
         }
         break;

      case 7:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_BALAGARNSIRONHORN_7; break;
            case 1: iResult = IP_CONST_CASTSPELL_DISMISSAL_7; break;
            case 2: iResult = IP_CONST_CASTSPELL_DOMINATE_PERSON_7; break;
            case 3: iResult = IP_CONST_CASTSPELL_ENERVATION_7; break;
            case 4: iResult = IP_CONST_CASTSPELL_FLAME_STRIKE_7; break;
            case 5: iResult = IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_7; break;
            case 6: iResult = IP_CONST_CASTSPELL_IMPROVED_INVISIBILITY_7; break;
            case 7: iResult = IP_CONST_CASTSPELL_INFLICT_MODERATE_WOUNDS_7; break;
            case 8: iResult = IP_CONST_CASTSPELL_LESSER_SPELL_BREACH_7; break;
            case 9: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_7; break;
            case 10: iResult = IP_CONST_CASTSPELL_PHANTASMAL_KILLER_7; break;
            case 11: iResult = IP_CONST_CASTSPELL_SHADOW_CONJURATION_7; break;
            case 12: iResult = IP_CONST_CASTSPELL_SUMMON_CREATURE_IV_7; break;
            case 13: iResult = IP_CONST_CASTSPELL_TASHAS_HIDEOUS_LAUGHTER_7; break;
            case 14: iResult = IP_CONST_CASTSPELL_AURAOFGLORY_7; break;
            case 15: iResult = IP_CONST_CASTSPELL_BLOOD_FRENZY_7; break;
            case 16: iResult = IP_CONST_CASTSPELL_CONTINUAL_FLAME_7; break;
            case 17: iResult = IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_7; break;
            case 18: iResult = IP_CONST_CASTSPELL_DEATH_WARD_7; break;
            case 19: iResult = IP_CONST_CASTSPELL_DIVINE_POWER_7; break;
            case 20: iResult = IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_7; break;
            case 21: iResult = IP_CONST_CASTSPELL_FREEDOM_OF_MOVEMENT_7; break;
            case 22: iResult = IP_CONST_CASTSPELL_HOLD_MONSTER_7; break;
            case 23: iResult = IP_CONST_CASTSPELL_ONE_WITH_THE_LAND_7; break;
            case 24: iResult = IP_CONST_CASTSPELL_POLYMORPH_SELF_7; break;
            case 25: iResult = IP_CONST_CASTSPELL_RESTORATION_7; break;
            case 26: iResult = IP_CONST_CASTSPELL_STONESKIN_7; break;
            // PrC Spells
            case 27: iResult = 1101; break; //  Ilyykurs_Mantle                   16830479 7         4         21000  3173       0         1       1          iss_ilyykmant
            case 28: iResult = 1132; break; //  Blessing_of_bahamut               16825357 7         4         21000  2099       1         1       1          is_GhostVis
            case 29: iResult = 1090; break; //  Create_Magic_Tatoo                16830468 7         2         10500  3166       0         1       1          iss_createtatoo
            case 30: iResult = 1002; break; //  Cold_Orb                          16830294 7         4         21000  3101       0         1       1          iss_coldorb
            case 31: iResult = 1084; break; //  Legions_Shield_of_Faith           16830420 7         4         21000  3163       0         1       1          iss_lshlfat
            case 32: iResult = 1081; break; //  Panacea                           16830417 7         4         21000  3162       0         1       1          iss_panacea
            case 33: iResult = 1004; break; //  Electric_Orb                      16830296 7         4         21000  3102       0         1       1          iss_elecorb
            case 34: iResult = 1006; break; //  Fire_Orb                          16830298 7         4         21000  3103       0         1       1          iss_fireorb
            case 35: iResult = 1110; break; //  Sinsaburs_Baleful_Bolt            16830488 7         4         28000  3177       0         1       1          iss_sinsbbolt
            case 36: iResult = 1008; break; //  Sonic_Orb                         16830300 7         4         21000  3104       0         1       1          iss_sonicorb
            case 37: iResult = 1122; break; //  Viscid_Glob                       16830500 7         4         28000  3185       0         1       1          iss_viscidglob
            case 38: iResult = 1019; break; //  Blast_of_Flame                    16830311 7         4         21000  3110       0         1       1          iss_blsflm
            case 39: iResult = 1047; break; //  Recitation                        16830339 7         4         21000  3140       0         1       1          iss_recitat
            case 40: iResult = 1031; break; //  Lower_Spell_Resistance            16830323 7         4         21000  3126       0         1       1          iss_lowersr
            case 41: iResult = 1030; break; //  Mass_Ultravision                  16830322 7         4         10500  3125       0         1       1          iss_multra
            case 42: iResult = 1000; break; //  Acid_Orb                           16830292 7         4         21000  3100       0         1       1          iss_acidorb
         }
         break;

      case 8:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_QUILLFIRE_8; break;
         }
         break;

      case 9:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_GREATER_MAGIC_FANG_9; break;
            case 1: iResult = IP_CONST_CASTSPELL_ICE_STORM_9; break;
            case 2: iResult = IP_CONST_CASTSPELL_INFLICT_SERIOUS_WOUNDS_9; break;
            case 3: iResult = IP_CONST_CASTSPELL_MAGIC_MISSILE_9; break;
            case 4: iResult = IP_CONST_CASTSPELL_MELFS_ACID_ARROW_9; break;
            case 5: iResult = IP_CONST_CASTSPELL_MIND_FOG_9; break;
            case 6: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_9; break;
            case 7: iResult = IP_CONST_CASTSPELL_SPIKE_GROWTH_9; break;
            case 8: iResult = IP_CONST_CASTSPELL_WALL_OF_FIRE_9; break;
            case 9: iResult = IP_CONST_CASTSPELL_WOUNDING_WHISPERS_9; break;
            case 10: iResult = IP_CONST_CASTSPELL_DISPLACEMENT_9; break;
            case 11: iResult = IP_CONST_CASTSPELL_GHOSTLY_VISAGE_9; break;
            // PrC Spells
            case 12: iResult = 1018; break; //  Burning_Bolt                      16830310 9         1         3750   3109       0         1       1          iss_burnbol
            case 13: iResult = 1057; break; //  Lesser_Cold_Orb                   16830355 9         1         3750   3145       0         1       1          iss_lcoldorb
            case 14: iResult = 1059; break; //  Lesser_Electric_Orb               16830359 9         1         3750   3146       0         1       1          iss_lelecorb
            case 15: iResult = 1061; break; //  Lesser_Fire_Orb                   16830363 9         1         3750   3147       0         1       1          iss_lfireorb
            case 16: iResult = 1063; break; //  Lesser_Sonic_Orb                  16830367 9         1         3750   3148       0         1       1          iss_lsonicorb
            case 17: iResult = 1086; break; //  Slashing_Darkness                 16830422 9         3         20250  3164       0         1       1          iss_slashdark
            case 18: iResult = 1097; break; //  Snillocs_Snowball_Swarm           16830475 9         2         9000   3171       0         1       1          iss_snsnowsw
            case 19: iResult = 1055; break; //  Lesser_Acid_Orb                   16830351 9         1         3750   3144       0         1       1          iss_lacidorb
         }
         break;

      case 10:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_ANIMATE_DEAD_10; break;
            case 1: iResult = IP_CONST_CASTSPELL_CALL_LIGHTNING_10; break;
            case 2: iResult = IP_CONST_CASTSPELL_CHARM_MONSTER_10; break;
            case 3: iResult = IP_CONST_CASTSPELL_CHARM_PERSON_10; break;
            case 4: iResult = IP_CONST_CASTSPELL_CHARM_PERSON_OR_ANIMAL_10; break;
            case 5: iResult = IP_CONST_CASTSPELL_CONFUSION_10; break;
            case 6: iResult = IP_CONST_CASTSPELL_FIREBALL_10; break;
            case 7: iResult = IP_CONST_CASTSPELL_FLAME_LASH_10; break;
            case 8: iResult = IP_CONST_CASTSPELL_GUST_OF_WIND_10; break;
            case 9: iResult = IP_CONST_CASTSPELL_LIGHTNING_BOLT_10; break;
            case 10: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_BURST_10; break;
            case 11: iResult = IP_CONST_CASTSPELL_BULLS_STRENGTH_10; break;
            case 12: iResult = IP_CONST_CASTSPELL_CATS_GRACE_10; break;
            case 13: iResult = IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_10; break;
            case 14: iResult = IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_10; break;
            case 15: iResult = IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_10; break;
            case 16: iResult = IP_CONST_CASTSPELL_DISPEL_MAGIC_10; break;
            case 17: iResult = IP_CONST_CASTSPELL_EAGLE_SPLEDOR_10; break;
            case 18: iResult = IP_CONST_CASTSPELL_ENDURANCE_10; break;
            case 19: iResult = IP_CONST_CASTSPELL_FOXS_CUNNING_10; break;
            case 20: iResult = IP_CONST_CASTSPELL_HASTE_10; break;
            case 21: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_10; break;
            case 22: iResult = IP_CONST_CASTSPELL_OWLS_WISDOM_10; break;
            case 23: iResult = IP_CONST_CASTSPELL_PROTECTION_FROM_ELEMENTS_10; break;
            case 24: iResult = IP_CONST_CASTSPELL_RESIST_ELEMENTS_10; break;
            // PrC Spells
            case 25: iResult = 1020; break; //  Blast_of_Flame                    16830312 10        4         30000  3110       0         1       1          iss_blsflm
            case 26: iResult = 1126; break; //  Greenfire                         16830506 10        3         22500  3187       0         1       1          iss_greenfire
            case 27: iResult = 1088; break; //  Agnazzars_Scorcher                16830466 10        2         15000  3165       0         1       1          iss_agnazscorch
            case 28: iResult = 1108; break; //  Nybors_Gentle_Reminder            16830486 10        1         7500   3175       0         1       1          iss_nybgentrem
            case 29: iResult = 1104; break; //  Improved_Mage_Armor               16830482 10        3         22500  3174       0         1       1          iss_impmagearm
            case 30: iResult = 1034; break; //  Serpents_Sigh                     16830326 10        3         22500  3127       0         1       1          iss_serpsigh
            case 31: iResult = 1048; break; //  Recitation                        16830340 10        4         30000  3140       0         1       1          iss_recitat
            case 32: iResult = 1011; break; //  Ice_Burst                         16830303 10        3         22500  3105       0         1       1          iss_iceburst
            case 33: iResult = 1052; break; //  Glitterdust                       16830344 10        2         15000  3142       0         1       1          iss_gdust
            case 34: iResult = 1050; break; //  Forceblast                        16830342 10        3         22250  3141       0         1       1          iss_forceblast

         }
         break;

      case 12:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_DISMISSAL_12; break;
            case 1: iResult = IP_CONST_CASTSPELL_FLAME_ARROW_12; break;
            case 2: iResult = IP_CONST_CASTSPELL_FLAME_STRIKE_12; break;
            case 3: iResult = IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_12; break;
            case 4: iResult = IP_CONST_CASTSPELL_INFLICT_CRITICAL_WOUNDS_12; break;
            case 5: iResult = IP_CONST_CASTSPELL_BARKSKIN_12; break;
            case 6: iResult = IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_12; break;
            case 7: iResult = IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_12; break;
            // PrC Spells
            case 8: iResult = 1133; break; //  Contagion                         16825365 11        6         49500  2122       0         1       1          is_mContagion
            case 9: iResult = 1068; break; //  Legions_Conviction                16830404 12        3         27000  3152       0         1       1          iss_lconvict
            case 10: iResult = 1111; break; //  Sinsaburs_Baleful_Bolt            16830489 12        4         36000  3177       0         1       1          iss_sinsbbolt
            case 11: iResult = 1121; break; //  Spiderskin                        16830499 12        3         27000  3184       0         1       1          iss_spiderskin
         }
         break;

      case 13:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_ISAACS_LESSER_MISSILE_STORM_13; break;
            case 1: iResult = IP_CONST_CASTSPELL_MASS_CAMOFLAGE_13; break;
            // PrC Spells
            case 2: iResult = 1091; break; //  Create_Magic_Tatoo                16830469 13        2         19500  3166       0         1       1          iss_createtatoo
         }
         break;

      case 15:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_ANIMATE_DEAD_15; break;
            case 1: iResult = IP_CONST_CASTSPELL_BANISHMENT_15; break;
            case 2: iResult = IP_CONST_CASTSPELL_BIGBYS_FORCEFUL_HAND_15; break;
            case 3: iResult = IP_CONST_CASTSPELL_BIGBYS_INTERPOSING_HAND_15; break;
            case 4: iResult = IP_CONST_CASTSPELL_DIRGE_15; break;
            case 5: iResult = IP_CONST_CASTSPELL_DROWN_15; break;
            case 6: iResult = IP_CONST_CASTSPELL_FIREBRAND_15; break;
            case 7: iResult = IP_CONST_CASTSPELL_INFERNO_15; break;
            case 8: iResult = IP_CONST_CASTSPELL_ISAACS_GREATER_MISSILE_STORM_15; break;
            case 9: iResult = IP_CONST_CASTSPELL_PLANAR_ALLY_15; break;
            case 10: iResult = IP_CONST_CASTSPELL_BULLS_STRENGTH_15; break;
            case 11: iResult = IP_CONST_CASTSPELL_CATS_GRACE_15; break;
            case 12: iResult = IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_15; break;
            case 13: iResult = IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_15; break;
            case 14: iResult = IP_CONST_CASTSPELL_EAGLE_SPLEDOR_15; break;
            case 15: iResult = IP_CONST_CASTSPELL_ENDURANCE_15; break;
            case 16: iResult = IP_CONST_CASTSPELL_FOXS_CUNNING_15; break;
            case 17: iResult = IP_CONST_CASTSPELL_GHOSTLY_VISAGE_15; break;
            case 18: iResult = IP_CONST_CASTSPELL_MIND_BLANK_15; break;
            case 19: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_15; break;
            case 20: iResult = IP_CONST_CASTSPELL_OWLS_INSIGHT_15; break;
            case 21: iResult = IP_CONST_CASTSPELL_OWLS_WISDOM_15; break;
            // PrC Spells
            case 22: iResult = 1032; break; //  Lower_Spell_Resistance            16830324 15        4         45000  3126       0         1       1          iss_lowersr
            case 23: iResult = 1005; break; //  Electric_Orb                      16830297 15        4         45000  3102       0         1       1          iss_elecorb
            case 24: iResult = 1001; break; //  Acid_Orb                          16830293 15        4         45000  3100       0         1       1          iss_acidorb
            case 25: iResult = 1082; break; //  Panacea                           16830418 15        4         45000  3162       0         1       1          iss_panacea
            case 26: iResult = 1003; break; //  Cold_Orb                          16830295 15        4         45000  3101       0         1       1          iss_coldorb
            case 27: iResult = 1129; break; //  Wall_Greater_Dispel_Magic         16825361 15        8         90000  2096       0         1       1          iss_WallFire
            case 28: iResult = 1102; break; //  Ilyykurs_Mantle                   16830480 15        4         60000  3173       0         1       1          iss_ilyykmant
            case 29: iResult = 1007; break; //  Fire_Orb                          16830299 15        4         45000  3103       0         1       1          iss_fireorb
            case 30: iResult = 1009; break; //  Sonic_Orb                         16830301 15        4         45000  3104       0         1       1          iss_sonicorb
         }
         break;

      case 17:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_BIGBYS_GRASPING_HAND_17; break;
            case 1: iResult = IP_CONST_CASTSPELL_METEOR_SWARM_17; break;
            // PrC Spells
            case 2: iResult = 1131; break; //  Unyielding_Roots                  16825359 17        9         114750 2098       1         1       1          iss_Entangle
         }
         break;

      case 18:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_DISMISSAL_18; break;
            case 1: iResult = IP_CONST_CASTSPELL_FLAME_ARROW_18; break;
            case 2: iResult = IP_CONST_CASTSPELL_FLAME_STRIKE_18; break;
            case 3: iResult = IP_CONST_CASTSPELL_ETHEREALNESS_18; break;
            // PrC Spells
            case 4: iResult = 1069; break; //  Legions_Conviction                16830405 18        3         40500  3152       0         1       1          iss_lconvict
         }
         break;

      case 20:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_BIGBYS_CLENCHED_FIST_20; break;
            case 1: iResult = IP_CONST_CASTSPELL_BIGBYS_CRUSHING_HAND_20; break;
            case 2: iResult = IP_CONST_CASTSPELL_BOMBARDMENT_20; break;
            case 3: iResult = IP_CONST_CASTSPELL_EARTHQUAKE_20; break;
            case 4: iResult = IP_CONST_CASTSPELL_SUNBURST_20; break;
            case 5: iResult = IP_CONST_CASTSPELL_UNDEATHS_ETERNAL_FOE_20; break;
            // PrC Spells
            case 6: iResult = 1083; break; //  Panacea                           16830419 20        4         60000  3162       0         1       1          iss_panacea
            case 7: iResult = 1105; break; //  Improved_Mage_Armor               16830483 20        3         45000  3174       0         1       1          iss_impmagearm
         }
         break;
   }
   return (iResult);
}

int ip_GetRandomSpell(int iLevel)
{
   // Spells have
   // a 15% chance to be of the desired level
   // a 20% chance to be of 3 levels within the desired level
   // a 30% chance to be of 6 levels within the desired level
   // a 35% chance to roll totally random
   int nChance = Random(100) + 1;
   if (nChance < 36)
      iLevel = Random(iLevel) + 1;
   else if (nChance < 66)
      iLevel = iLevel - Random(6);
   else if (nChance < 86)
      iLevel = iLevel - Random(3);

   // if we reduced iLevel below 0, set to 0
   if (iLevel < 0)
      iLevel = 0;

   int iNumber;
   switch (iLevel)
   {
      case 0: iNumber = 10; iLevel = 1; break;
      case 1: iNumber = 10; break;
      case 2: iNumber = 18; break;
      case 3: iNumber = 37; break;
      case 4: iNumber = 37; iLevel = 3; break;
      case 5: iNumber = 59; break;
      case 6: iNumber = 4; break;
      case 7: iNumber = 31; break;
      case 8: iNumber = 1; break;
      case 9: iNumber = 28; break;
      case 10: iNumber = 25; break;
      case 11: iNumber = 22; break;
      case 12: iNumber = 8; break;
      case 13: iNumber = 21; break;
      case 14: iNumber = 1; break;
      case 15: iNumber = 45; break;
      case 16: iNumber = 3; break;
      case 17: iNumber = 16; break;
      case 18: iNumber = 7; break;
      case 19: iNumber = 7; iLevel = 18; break;
      case 20: iNumber = 14; break;
   }
   int iRandomizer = Random(iNumber);
   int iResult;
   switch (iLevel)
   {
      case 1:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_ACID_SPLASH_1; break;
            case 1: iResult = IP_CONST_CASTSPELL_DAZE_1; break;
            case 2: iResult = IP_CONST_CASTSPELL_ELECTRIC_JOLT_1; break;
            case 3: iResult = IP_CONST_CASTSPELL_FLARE_1; break;
            case 4: iResult = IP_CONST_CASTSPELL_INFLICT_MINOR_WOUNDS_1; break;
            case 5: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_1; break;
            case 6: iResult = IP_CONST_CASTSPELL_RAY_OF_FROST_1; break;
            case 7: iResult = IP_CONST_CASTSPELL_CURE_MINOR_WOUNDS_1; break;
            case 8: iResult = IP_CONST_CASTSPELL_LIGHT_1; break;
            case 9: iResult = IP_CONST_CASTSPELL_VIRTUE_1; break;
         }
         break;

      case 2:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_BURNING_HANDS_2; break;
            case 1: iResult = IP_CONST_CASTSPELL_CHARM_PERSON_2; break;
            case 2: iResult = IP_CONST_CASTSPELL_COLOR_SPRAY_2; break;
            case 3: iResult = IP_CONST_CASTSPELL_DOOM_2; break;
            case 4: iResult = IP_CONST_CASTSPELL_ENTANGLE_2; break;
            case 5: iResult = IP_CONST_CASTSPELL_GREASE_2; break;
            case 6: iResult = IP_CONST_CASTSPELL_PROTECTION_FROM_ALIGNMENT_2; break;
            case 7: iResult = IP_CONST_CASTSPELL_RAY_OF_ENFEEBLEMENT_2; break;
            case 8: iResult = IP_CONST_CASTSPELL_SANCTUARY_2; break;
            case 9: iResult = IP_CONST_CASTSPELL_SCARE_2; break;
            case 10: iResult = IP_CONST_CASTSPELL_SLEEP_2; break;
            case 11: iResult = IP_CONST_CASTSPELL_SUMMON_CREATURE_I_2; break;
            case 12: iResult = IP_CONST_CASTSPELL_BLESS_2; break;
            case 13: iResult = IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_2; break;
            case 14: iResult = IP_CONST_CASTSPELL_ENDURE_ELEMENTS_2; break;
            case 15: iResult = IP_CONST_CASTSPELL_MAGE_ARMOR_2; break;
            case 16: iResult = IP_CONST_CASTSPELL_REMOVE_FEAR_2; break;
            case 17: iResult = IP_CONST_CASTSPELL_RESISTANCE_2; break;
         }
         break;

      case 3:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_ROGUES_CUNNING_3; break;
            case 1: iResult = IP_CONST_CASTSPELL_BLINDNESS_DEAFNESS_3; break;
            case 2: iResult = IP_CONST_CASTSPELL_CHARM_PERSON_OR_ANIMAL_3; break;
            case 3: iResult = IP_CONST_CASTSPELL_FLAME_LASH_3; break;
            case 4: iResult = IP_CONST_CASTSPELL_GHOUL_TOUCH_3; break;
            case 5: iResult = IP_CONST_CASTSPELL_KNOCK_3; break;
            case 6: iResult = IP_CONST_CASTSPELL_MAGIC_MISSILE_3; break;
            case 7: iResult = IP_CONST_CASTSPELL_MELFS_ACID_ARROW_3; break;
            case 8: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_3; break;
            case 9: iResult = IP_CONST_CASTSPELL_SILENCE_3; break;
            case 10: iResult = IP_CONST_CASTSPELL_SOUND_BURST_3; break;
            case 11: iResult = IP_CONST_CASTSPELL_SUMMON_CREATURE_II_3; break;
            case 12: iResult = IP_CONST_CASTSPELL_WEB_3; break;
            case 13: iResult = IP_CONST_CASTSPELL_AID_3; break;
            case 14: iResult = IP_CONST_CASTSPELL_BARKSKIN_3; break;
            case 15: iResult = IP_CONST_CASTSPELL_BULLS_STRENGTH_3; break;
            case 16: iResult = IP_CONST_CASTSPELL_CATS_GRACE_3; break;
            case 17: iResult = IP_CONST_CASTSPELL_CLARITY_3; break;
            case 18: iResult = IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_3; break;
            case 19: iResult = IP_CONST_CASTSPELL_DARKNESS_3; break;
            case 20: iResult = IP_CONST_CASTSPELL_DARKVISION_3; break;
            case 21: iResult = IP_CONST_CASTSPELL_EAGLE_SPLEDOR_3; break;
            case 22: iResult = IP_CONST_CASTSPELL_ENDURANCE_3; break;
            case 23: iResult = IP_CONST_CASTSPELL_FIND_TRAPS_3; break;
            case 24: iResult = IP_CONST_CASTSPELL_FOXS_CUNNING_3; break;
            case 25: iResult = IP_CONST_CASTSPELL_GHOSTLY_VISAGE_3; break;
            case 26: iResult = IP_CONST_CASTSPELL_HOLD_ANIMAL_3; break;
            case 27: iResult = IP_CONST_CASTSPELL_HOLD_PERSON_3; break;
            case 28: iResult = IP_CONST_CASTSPELL_IDENTIFY_3; break;
            case 29: iResult = IP_CONST_CASTSPELL_INVISIBILITY_3; break;
            case 30: iResult = IP_CONST_CASTSPELL_LESSER_DISPEL_3; break;
            case 31: iResult = IP_CONST_CASTSPELL_LESSER_RESTORATION_3; break;
            case 32: iResult = IP_CONST_CASTSPELL_OWLS_WISDOM_3; break;
            case 33: iResult = IP_CONST_CASTSPELL_PROTECTION_FROM_ELEMENTS_3; break;
            case 34: iResult = IP_CONST_CASTSPELL_REMOVE_PARALYSIS_3; break;
            case 35: iResult = IP_CONST_CASTSPELL_RESIST_ELEMENTS_3; break;
            case 36: iResult = IP_CONST_CASTSPELL_SEE_INVISIBILITY_3; break;
          }
         break;

      case 5:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_ANIMATE_DEAD_5; break;
            case 1: iResult = IP_CONST_CASTSPELL_BESTOW_CURSE_5; break;
            case 2: iResult = IP_CONST_CASTSPELL_BURNING_HANDS_5; break;
            case 3: iResult = IP_CONST_CASTSPELL_CALL_LIGHTNING_5; break;
            case 4: iResult = IP_CONST_CASTSPELL_CHARM_MONSTER_5; break;
            case 5: iResult = IP_CONST_CASTSPELL_CONFUSION_5; break;
            case 6: iResult = IP_CONST_CASTSPELL_DOMINATE_ANIMAL_5; break;
            case 7: iResult = IP_CONST_CASTSPELL_DOOM_5; break;
            case 8: iResult = IP_CONST_CASTSPELL_ENTANGLE_5; break;
            case 9: iResult = IP_CONST_CASTSPELL_FEAR_5; break;
            case 10: iResult = IP_CONST_CASTSPELL_FIREBALL_5; break;
            case 11: iResult = IP_CONST_CASTSPELL_FLAME_ARROW_5; break;
            case 12: iResult = IP_CONST_CASTSPELL_INFLICT_LIGHT_WOUNDS_5; break;
            case 13: iResult = IP_CONST_CASTSPELL_INVISIBILITY_PURGE_5; break;
            case 14: iResult = IP_CONST_CASTSPELL_INVISIBILITY_SPHERE_5; break;
            case 15: iResult = IP_CONST_CASTSPELL_LIGHTNING_BOLT_5; break;
            case 16: iResult = IP_CONST_CASTSPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT_5; break;
            case 17: iResult = IP_CONST_CASTSPELL_MAGIC_FANG_5; break;
            case 18: iResult = IP_CONST_CASTSPELL_MAGIC_MISSILE_5; break;
            case 19: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_BURST_5; break;
            case 20: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_5; break;
            case 21: iResult = IP_CONST_CASTSPELL_POISON_5; break;
            case 22: iResult = IP_CONST_CASTSPELL_PROTECTION_FROM_ALIGNMENT_5; break;
            case 23: iResult = IP_CONST_CASTSPELL_SEARING_LIGHT_5; break;
            case 24: iResult = IP_CONST_CASTSPELL_SLEEP_5; break;
            case 25: iResult = IP_CONST_CASTSPELL_SLOW_5; break;
            case 26: iResult = IP_CONST_CASTSPELL_STINKING_CLOUD_5; break;
            case 27: iResult = IP_CONST_CASTSPELL_SUMMON_CREATURE_III_5; break;
            case 28: iResult = IP_CONST_CASTSPELL_SUMMON_CREATURE_I_5; break;
            case 29: iResult = IP_CONST_CASTSPELL_VAMPIRIC_TOUCH_5; break;
            case 30: iResult = IP_CONST_CASTSPELL_AMPLIFY_5; break;
            case 31: iResult = IP_CONST_CASTSPELL_BANE_5; break;
            case 32: iResult = IP_CONST_CASTSPELL_CAMOFLAGE_5; break;
            case 33: iResult = IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_5; break;
            case 34: iResult = IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_5; break;
            case 35: iResult = IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_5; break;
            case 36: iResult = IP_CONST_CASTSPELL_DISPEL_MAGIC_5; break;
            case 37: iResult = IP_CONST_CASTSPELL_DIVINE_FAVOR_5; break;
            case 38: iResult = IP_CONST_CASTSPELL_DIVINE_MIGHT_5; break;
            case 39: iResult = IP_CONST_CASTSPELL_DIVINE_SHIELD_5; break;
            case 40: iResult = IP_CONST_CASTSPELL_ENTROPIC_SHIELD_5; break;
            case 41: iResult = IP_CONST_CASTSPELL_EXPEDITIOUS_RETREAT_5; break;
            case 42: iResult = IP_CONST_CASTSPELL_HASTE_5; break;
            case 43: iResult = IP_CONST_CASTSPELL_LESSER_DISPEL_5; break;
            case 44: iResult = IP_CONST_CASTSPELL_LIGHT_5; break;
            case 45: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_5; break;
            case 46: iResult = IP_CONST_CASTSPELL_NEUTRALIZE_POISON_5; break;
            case 47: iResult = IP_CONST_CASTSPELL_PRAYER_5; break;
            case 48: iResult = IP_CONST_CASTSPELL_REMOVE_BLINDNESS_DEAFNESS_5; break;
            case 49: iResult = IP_CONST_CASTSPELL_REMOVE_CURSE_5; break;
            case 50: iResult = IP_CONST_CASTSPELL_REMOVE_DISEASE_5; break;
            case 51: iResult = IP_CONST_CASTSPELL_RESISTANCE_5; break;
            case 52: iResult = IP_CONST_CASTSPELL_SHIELD_5; break;
            case 53: iResult = IP_CONST_CASTSPELL_SHIELD_OF_FAITH_5; break;
            case 54: iResult = IP_CONST_CASTSPELL_TRUE_STRIKE_5; break;
            case 55: iResult = IP_CONST_CASTSPELL_CONTAGION_5; break;
            case 56: iResult = IP_CONST_CASTSPELL_FLESH_TO_STONE_5; break;
            case 57: iResult = IP_CONST_CASTSPELL_LEGEND_LORE_5; break;
            case 58: iResult = IP_CONST_CASTSPELL_STONE_TO_FLESH_5; break;
         }
         break;

      case 6:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_MELFS_ACID_ARROW_6; break;
            case 1: iResult = IP_CONST_CASTSPELL_BARKSKIN_6; break;
            case 2: iResult = IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_6; break;
            case 3: iResult = IP_CONST_CASTSPELL_DARKVISION_6; break;
         }
         break;

      case 7:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_GREATER_DISPELLING_7; break;
            case 1: iResult = IP_CONST_CASTSPELL_MINOR_GLOBE_OF_INVULNERABILITY_7; break;
            case 2: iResult = IP_CONST_CASTSPELL_BALAGARNSIRONHORN_7; break;
            case 3: iResult = IP_CONST_CASTSPELL_DISMISSAL_7; break;
            case 4: iResult = IP_CONST_CASTSPELL_DOMINATE_PERSON_7; break;
            case 5: iResult = IP_CONST_CASTSPELL_ENERVATION_7; break;
            case 6: iResult = IP_CONST_CASTSPELL_FLAME_STRIKE_7; break;
            case 7: iResult = IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_7; break;
            case 8: iResult = IP_CONST_CASTSPELL_IMPROVED_INVISIBILITY_7; break;
            case 9: iResult = IP_CONST_CASTSPELL_INFLICT_MODERATE_WOUNDS_7; break;
            case 10: iResult = IP_CONST_CASTSPELL_LESSER_SPELL_BREACH_7; break;
            case 11: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_7; break;
            case 12: iResult = IP_CONST_CASTSPELL_PHANTASMAL_KILLER_7; break;
            case 13: iResult = IP_CONST_CASTSPELL_SHADOW_CONJURATION_7; break;
            case 14: iResult = IP_CONST_CASTSPELL_SUMMON_CREATURE_IV_7; break;
            case 15: iResult = IP_CONST_CASTSPELL_TASHAS_HIDEOUS_LAUGHTER_7; break;
            case 16: iResult = IP_CONST_CASTSPELL_AURAOFGLORY_7; break;
            case 17: iResult = IP_CONST_CASTSPELL_BLOOD_FRENZY_7; break;
            case 18: iResult = IP_CONST_CASTSPELL_CONTINUAL_FLAME_7; break;
            case 19: iResult = IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_7; break;
            case 20: iResult = IP_CONST_CASTSPELL_DEATH_WARD_7; break;
            case 21: iResult = IP_CONST_CASTSPELL_DIVINE_POWER_7; break;
            case 22: iResult = IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_7; break;
            case 23: iResult = IP_CONST_CASTSPELL_FREEDOM_OF_MOVEMENT_7; break;
            case 24: iResult = IP_CONST_CASTSPELL_HOLD_MONSTER_7; break;
            case 25: iResult = IP_CONST_CASTSPELL_ONE_WITH_THE_LAND_7; break;
            case 26: iResult = IP_CONST_CASTSPELL_POLYMORPH_SELF_7; break;
            case 27: iResult = IP_CONST_CASTSPELL_RESTORATION_7; break;
            case 28: iResult = IP_CONST_CASTSPELL_STONESKIN_7; break;
            case 29: iResult = IP_CONST_CASTSPELL_EVARDS_BLACK_TENTACLES_7; break;
            case 30: iResult = IP_CONST_CASTSPELL_WAR_CRY_7; break;
         }
         break;

      case 8:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_QUILLFIRE_8; break;
         }
         break;

      case 9:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_ETHEREAL_VISAGE_9; break;
            case 1: iResult = IP_CONST_CASTSPELL_LESSER_MIND_BLANK_9; break;
            case 2: iResult = IP_CONST_CASTSPELL_LESSER_SPELL_MANTLE_9; break;
            case 3: iResult = IP_CONST_CASTSPELL_RAISE_DEAD_9; break;
            case 4: iResult = IP_CONST_CASTSPELL_SPELL_RESISTANCE_9; break;
            case 5: iResult = IP_CONST_CASTSPELL_TRUE_SEEING_9; break;
            case 6: iResult = IP_CONST_CASTSPELL_GREATER_MAGIC_FANG_9; break;
            case 7: iResult = IP_CONST_CASTSPELL_ICE_STORM_9; break;
            case 8: iResult = IP_CONST_CASTSPELL_INFLICT_SERIOUS_WOUNDS_9; break;
            case 9: iResult = IP_CONST_CASTSPELL_MAGIC_MISSILE_9; break;
            case 10: iResult = IP_CONST_CASTSPELL_MELFS_ACID_ARROW_9; break;
            case 11: iResult = IP_CONST_CASTSPELL_MIND_FOG_9; break;
            case 12: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_9; break;
            case 13: iResult = IP_CONST_CASTSPELL_SPIKE_GROWTH_9; break;
            case 14: iResult = IP_CONST_CASTSPELL_WALL_OF_FIRE_9; break;
            case 15: iResult = IP_CONST_CASTSPELL_WOUNDING_WHISPERS_9; break;
            case 16: iResult = IP_CONST_CASTSPELL_DISPLACEMENT_9; break;
            case 17: iResult = IP_CONST_CASTSPELL_GHOSTLY_VISAGE_9; break;
            case 18: iResult = IP_CONST_CASTSPELL_AWAKEN_9; break;
            case 19: iResult = IP_CONST_CASTSPELL_CIRCLE_OF_DOOM_9; break;
            case 20: iResult = IP_CONST_CASTSPELL_CLOUDKILL_9; break;
            case 21: iResult = IP_CONST_CASTSPELL_CONE_OF_COLD_9; break;
            case 22: iResult = IP_CONST_CASTSPELL_FEEBLEMIND_9; break;
            case 23: iResult = IP_CONST_CASTSPELL_GREATER_SHADOW_CONJURATION_9; break;
            case 24: iResult = IP_CONST_CASTSPELL_HEALING_CIRCLE_9; break;
            case 25: iResult = IP_CONST_CASTSPELL_LESSER_PLANAR_BINDING_9; break;
            case 26: iResult = IP_CONST_CASTSPELL_SLAY_LIVING_9; break;
            case 27: iResult = IP_CONST_CASTSPELL_SUMMON_CREATURE_V_9; break;
         }
         break;

      case 10:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_ANIMATE_DEAD_10; break;
            case 1: iResult = IP_CONST_CASTSPELL_CALL_LIGHTNING_10; break;
            case 2: iResult = IP_CONST_CASTSPELL_CHARM_MONSTER_10; break;
            case 3: iResult = IP_CONST_CASTSPELL_CHARM_PERSON_10; break;
            case 4: iResult = IP_CONST_CASTSPELL_CHARM_PERSON_OR_ANIMAL_10; break;
            case 5: iResult = IP_CONST_CASTSPELL_CONFUSION_10; break;
            case 6: iResult = IP_CONST_CASTSPELL_FIREBALL_10; break;
            case 7: iResult = IP_CONST_CASTSPELL_FLAME_LASH_10; break;
            case 8: iResult = IP_CONST_CASTSPELL_GUST_OF_WIND_10; break;
            case 9: iResult = IP_CONST_CASTSPELL_LIGHTNING_BOLT_10; break;
            case 10: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_BURST_10; break;
            case 11: iResult = IP_CONST_CASTSPELL_BULLS_STRENGTH_10; break;
            case 12: iResult = IP_CONST_CASTSPELL_CATS_GRACE_10; break;
            case 13: iResult = IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_10; break;
            case 14: iResult = IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_10; break;
            case 15: iResult = IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_10; break;
            case 16: iResult = IP_CONST_CASTSPELL_DISPEL_MAGIC_10; break;
            case 17: iResult = IP_CONST_CASTSPELL_EAGLE_SPLEDOR_10; break;
            case 18: iResult = IP_CONST_CASTSPELL_ENDURANCE_10; break;
            case 19: iResult = IP_CONST_CASTSPELL_FOXS_CUNNING_10; break;
            case 20: iResult = IP_CONST_CASTSPELL_HASTE_10; break;
            case 21: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_10; break;
            case 22: iResult = IP_CONST_CASTSPELL_OWLS_WISDOM_10; break;
            case 23: iResult = IP_CONST_CASTSPELL_PROTECTION_FROM_ELEMENTS_10; break;
            case 24: iResult = IP_CONST_CASTSPELL_RESIST_ELEMENTS_10; break;
         }
         break;

      case 11:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_GLOBE_OF_INVULNERABILITY_11; break;
            case 1: iResult = IP_CONST_CASTSPELL_GREATER_BULLS_STRENGTH_11; break;
            case 2: iResult = IP_CONST_CASTSPELL_GREATER_CATS_GRACE_11; break;
            case 3: iResult = IP_CONST_CASTSPELL_GREATER_EAGLES_SPLENDOR_11; break;
            case 4: iResult = IP_CONST_CASTSPELL_GREATER_ENDURANCE_11; break;
            case 5: iResult = IP_CONST_CASTSPELL_GREATER_FOXS_CUNNING_11; break;
            case 6: iResult = IP_CONST_CASTSPELL_HEAL_11; break;
            case 7: iResult = IP_CONST_CASTSPELL_GREATER_OWLS_WISDOM_11; break;
            case 8: iResult = IP_CONST_CASTSPELL_GREATER_STONESKIN_11; break;
            case 9: iResult = IP_CONST_CASTSPELL_TENSERS_TRANSFORMATION_11; break;
            case 10: iResult = IP_CONST_CASTSPELL_ACID_FOG_11; break;
            case 11: iResult = IP_CONST_CASTSPELL_BLADE_BARRIER_11; break;
            case 12: iResult = IP_CONST_CASTSPELL_CHAIN_LIGHTNING_11; break;
            case 13: iResult = IP_CONST_CASTSPELL_CIRCLE_OF_DEATH_11; break;
            case 14: iResult = IP_CONST_CASTSPELL_CREATE_UNDEAD_11; break;
            case 15: iResult = IP_CONST_CASTSPELL_ENERGY_BUFFER_11; break;
            case 16: iResult = IP_CONST_CASTSPELL_GREATER_SPELL_BREACH_11; break;
            case 17: iResult = IP_CONST_CASTSPELL_HARM_11; break;
            case 18: iResult = IP_CONST_CASTSPELL_MASS_HASTE_11; break;
            case 19: iResult = IP_CONST_CASTSPELL_PLANAR_BINDING_11; break;
            case 20: iResult = IP_CONST_CASTSPELL_SHADES_11; break;
            case 21: iResult = IP_CONST_CASTSPELL_SUMMON_CREATURE_VI_11; break;
         }
         break;

      case 12:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_DISMISSAL_12; break;
            case 1: iResult = IP_CONST_CASTSPELL_FLAME_ARROW_12; break;
            case 2: iResult = IP_CONST_CASTSPELL_FLAME_STRIKE_12; break;
            case 3: iResult = IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_12; break;
            case 4: iResult = IP_CONST_CASTSPELL_INFLICT_CRITICAL_WOUNDS_12; break;
            case 5: iResult = IP_CONST_CASTSPELL_BARKSKIN_12; break;
            case 6: iResult = IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_12; break;
            case 7: iResult = IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_12; break;
         }
         break;

      case 13:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_GREATER_RESTORATION_13; break;
            case 1: iResult = IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_13; break;
            case 2: iResult = IP_CONST_CASTSPELL_RESURRECTION_13; break;
            case 3: iResult = IP_CONST_CASTSPELL_SHADOW_SHIELD_13; break;
            case 4: iResult = IP_CONST_CASTSPELL_SPELL_MANTLE_13; break;
            case 5: iResult = IP_CONST_CASTSPELL_ISAACS_LESSER_MISSILE_STORM_13; break;
            case 6: iResult = IP_CONST_CASTSPELL_MASS_CAMOFLAGE_13; break;
            case 7: iResult = IP_CONST_CASTSPELL_AURA_OF_VITALITY_13; break;
            case 8: iResult = IP_CONST_CASTSPELL_CONTROL_UNDEAD_13; break;
            case 9: iResult = IP_CONST_CASTSPELL_CREEPING_DOOM_13; break;
            case 10: iResult = IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_13; break;
            case 11: iResult = IP_CONST_CASTSPELL_DESTRUCTION_13; break;
            case 12: iResult = IP_CONST_CASTSPELL_FINGER_OF_DEATH_13; break;
            case 13: iResult = IP_CONST_CASTSPELL_FIRE_STORM_13; break;
            case 14: iResult = IP_CONST_CASTSPELL_MORDENKAINENS_SWORD_13; break;
            case 15: iResult = IP_CONST_CASTSPELL_POWER_WORD_STUN_13; break;
            case 16: iResult = IP_CONST_CASTSPELL_PRISMATIC_SPRAY_13; break;
            case 17: iResult = IP_CONST_CASTSPELL_REGENERATE_13; break;
            case 18: iResult = IP_CONST_CASTSPELL_SUMMON_CREATURE_VII_13; break;
            case 19: iResult = IP_CONST_CASTSPELL_SUNBEAM_13; break;
            case 20: iResult = IP_CONST_CASTSPELL_WORD_OF_FAITH_13; break;
         }
         break;

      case 14:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_CREATE_UNDEAD_14; break;
         }
         break;

      case 15:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_ETHEREAL_VISAGE_15; break;
            case 1: iResult = IP_CONST_CASTSPELL_GREATER_DISPELLING_15; break;
            case 2: iResult = IP_CONST_CASTSPELL_MINOR_GLOBE_OF_INVULNERABILITY_15; break;
            case 3: iResult = IP_CONST_CASTSPELL_PREMONITION_15; break;
            case 4: iResult = IP_CONST_CASTSPELL_SPELL_RESISTANCE_15; break;
            case 5: iResult = IP_CONST_CASTSPELL_ANIMATE_DEAD_15; break;
            case 6: iResult = IP_CONST_CASTSPELL_BANISHMENT_15; break;
            case 7: iResult = IP_CONST_CASTSPELL_BIGBYS_FORCEFUL_HAND_15; break;
            case 8: iResult = IP_CONST_CASTSPELL_BIGBYS_INTERPOSING_HAND_15; break;
            case 9: iResult = IP_CONST_CASTSPELL_DIRGE_15; break;
            case 10: iResult = IP_CONST_CASTSPELL_DROWN_15; break;
            case 11: iResult = IP_CONST_CASTSPELL_FIREBRAND_15; break;
            case 12: iResult = IP_CONST_CASTSPELL_INFERNO_15; break;
            case 13: iResult = IP_CONST_CASTSPELL_ISAACS_GREATER_MISSILE_STORM_15; break;
            case 14: iResult = IP_CONST_CASTSPELL_PLANAR_ALLY_15; break;
            case 15: iResult = IP_CONST_CASTSPELL_BULLS_STRENGTH_15; break;
            case 16: iResult = IP_CONST_CASTSPELL_CATS_GRACE_15; break;
            case 17: iResult = IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_15; break;
            case 18: iResult = IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_15; break;
            case 19: iResult = IP_CONST_CASTSPELL_EAGLE_SPLEDOR_15; break;
            case 20: iResult = IP_CONST_CASTSPELL_ENDURANCE_15; break;
            case 21: iResult = IP_CONST_CASTSPELL_FOXS_CUNNING_15; break;
            case 22: iResult = IP_CONST_CASTSPELL_GHOSTLY_VISAGE_15; break;
            case 23: iResult = IP_CONST_CASTSPELL_MIND_BLANK_15; break;
            case 24: iResult = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_15; break;
            case 25: iResult = IP_CONST_CASTSPELL_OWLS_INSIGHT_15; break;
            case 26: iResult = IP_CONST_CASTSPELL_OWLS_WISDOM_15; break;
            case 27: iResult = IP_CONST_CASTSPELL_AURA_VERSUS_ALIGNMENT_15; break;
            case 28: iResult = IP_CONST_CASTSPELL_BLADE_BARRIER_15; break;
            case 29: iResult = IP_CONST_CASTSPELL_CHAIN_LIGHTNING_15; break;
            case 30: iResult = IP_CONST_CASTSPELL_CIRCLE_OF_DEATH_15; break;
            case 31: iResult = IP_CONST_CASTSPELL_CIRCLE_OF_DOOM_15; break;
            case 32: iResult = IP_CONST_CASTSPELL_CONE_OF_COLD_15; break;
            case 33: iResult = IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_15; break;
            case 34: iResult = IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_15; break;
            case 35: iResult = IP_CONST_CASTSPELL_ENERGY_BUFFER_15; break;
            case 36: iResult = IP_CONST_CASTSPELL_EVARDS_BLACK_TENTACLES_15; break;
            case 37: iResult = IP_CONST_CASTSPELL_GREATER_PLANAR_BINDING_15; break;
            case 38: iResult = IP_CONST_CASTSPELL_HORRID_WILTING_15; break;
            case 39: iResult = IP_CONST_CASTSPELL_INCENDIARY_CLOUD_15; break;
            case 40: iResult = IP_CONST_CASTSPELL_MASS_BLINDNESS_DEAFNESS_15; break;
            case 41: iResult = IP_CONST_CASTSPELL_MASS_CHARM_15; break;
            case 42: iResult = IP_CONST_CASTSPELL_MASS_HEAL_15; break;
            case 43: iResult = IP_CONST_CASTSPELL_NATURES_BALANCE_15; break;
            case 44: iResult = IP_CONST_CASTSPELL_SUMMON_CREATURE_VIII_15; break;
         }
         break;

      case 16:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_16; break;
            case 1: iResult = IP_CONST_CASTSPELL_CREATE_UNDEAD_16; break;
            case 2: iResult = IP_CONST_CASTSPELL_HEALING_CIRCLE_16; break;
         }
         break;

      case 17:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_GREATER_SPELL_MANTLE_17; break;
            case 1: iResult = IP_CONST_CASTSPELL_MORDENKAINENS_DISJUNCTION_17; break;
            case 2: iResult = IP_CONST_CASTSPELL_SHAPECHANGE_17; break;
            case 3: iResult = IP_CONST_CASTSPELL_BIGBYS_GRASPING_HAND_17; break;
            case 4: iResult = IP_CONST_CASTSPELL_METEOR_SWARM_17; break;
            case 5: iResult = IP_CONST_CASTSPELL_DOMINATE_MONSTER_17; break;
            case 6: iResult = IP_CONST_CASTSPELL_ELEMENTAL_SWARM_17; break;
            case 7: iResult = IP_CONST_CASTSPELL_ENERGY_DRAIN_17; break;
            case 8: iResult = IP_CONST_CASTSPELL_GATE_17; break;
            case 9: iResult = IP_CONST_CASTSPELL_IMPLOSION_17; break;
            case 10: iResult = IP_CONST_CASTSPELL_POWER_WORD_KILL_17; break;
            case 11: iResult = IP_CONST_CASTSPELL_STORM_OF_VENGEANCE_17; break;
            case 12: iResult = IP_CONST_CASTSPELL_SUMMON_CREATURE_IX_17; break;
            case 13: iResult = IP_CONST_CASTSPELL_TIME_STOP_17; break;
            case 14: iResult = IP_CONST_CASTSPELL_WAIL_OF_THE_BANSHEE_17; break;
            case 15: iResult = IP_CONST_CASTSPELL_WEIRD_17; break;
         }
         break;

      case 18:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_DISMISSAL_18; break;
            case 1: iResult = IP_CONST_CASTSPELL_FLAME_ARROW_18; break;
            case 2: iResult = IP_CONST_CASTSPELL_FLAME_STRIKE_18; break;
            case 3: iResult = IP_CONST_CASTSPELL_ETHEREALNESS_18; break;
            case 4: iResult = IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_18; break;
            case 5: iResult = IP_CONST_CASTSPELL_FIRE_STORM_18; break;
            case 6: iResult = IP_CONST_CASTSPELL_MORDENKAINENS_SWORD_18; break;
         }
         break;

      case 20:
         switch (iRandomizer)
         {
            case 0: iResult = IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_20; break;
            case 1: iResult = IP_CONST_CASTSPELL_BIGBYS_CLENCHED_FIST_20; break;
            case 2: iResult = IP_CONST_CASTSPELL_BIGBYS_CRUSHING_HAND_20; break;
            case 3: iResult = IP_CONST_CASTSPELL_BOMBARDMENT_20; break;
            case 4: iResult = IP_CONST_CASTSPELL_EARTHQUAKE_20; break;
            case 5: iResult = IP_CONST_CASTSPELL_SUNBURST_20; break;
            case 6: iResult = IP_CONST_CASTSPELL_UNDEATHS_ETERNAL_FOE_20; break;
            case 7: iResult = IP_CONST_CASTSPELL_CHAIN_LIGHTNING_20; break;
            case 8: iResult = IP_CONST_CASTSPELL_CIRCLE_OF_DEATH_20; break;
            case 9: iResult = IP_CONST_CASTSPELL_CIRCLE_OF_DOOM_20; break;
            case 10: iResult = IP_CONST_CASTSPELL_CONTROL_UNDEAD_20; break;
            case 11: iResult = IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_20; break;
            case 12: iResult = IP_CONST_CASTSPELL_ENERGY_BUFFER_20; break;
            case 13: iResult = IP_CONST_CASTSPELL_HORRID_WILTING_20; break;
         }
         break;
   }
   return (iResult);
}

/* for reference only
      // Potions and other Items, but no Wands
      IP_CONST_CASTSPELL_ROGUES_CUNNING_3
      IP_CONST_CASTSPELL_GREATER_DISPELLING_7
      IP_CONST_CASTSPELL_MINOR_GLOBE_OF_INVULNERABILITY_7
      IP_CONST_CASTSPELL_ETHEREAL_VISAGE_9
      IP_CONST_CASTSPELL_LESSER_MIND_BLANK_9
      IP_CONST_CASTSPELL_LESSER_SPELL_MANTLE_9
      IP_CONST_CASTSPELL_RAISE_DEAD_9
      IP_CONST_CASTSPELL_SPELL_RESISTANCE_9
      IP_CONST_CASTSPELL_TRUE_SEEING_9
      IP_CONST_CASTSPELL_GLOBE_OF_INVULNERABILITY_11
      IP_CONST_CASTSPELL_GREATER_BULLS_STRENGTH_11
      IP_CONST_CASTSPELL_GREATER_CATS_GRACE_11
      IP_CONST_CASTSPELL_GREATER_EAGLES_SPLENDOR_11
      IP_CONST_CASTSPELL_GREATER_ENDURANCE_11
      IP_CONST_CASTSPELL_GREATER_FOXS_CUNNING_11
      IP_CONST_CASTSPELL_HEAL_11
      IP_CONST_CASTSPELL_GREATER_OWLS_WISDOM_11
      IP_CONST_CASTSPELL_GREATER_STONESKIN_11
      IP_CONST_CASTSPELL_TENSERS_TRANSFORMATION_11
      IP_CONST_CASTSPELL_GREATER_RESTORATION_13
      IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_13
      IP_CONST_CASTSPELL_RESURRECTION_13
      IP_CONST_CASTSPELL_SHADOW_SHIELD_13
      IP_CONST_CASTSPELL_SPELL_MANTLE_13
      IP_CONST_CASTSPELL_ETHEREAL_VISAGE_15
      IP_CONST_CASTSPELL_GREATER_DISPELLING_15
      IP_CONST_CASTSPELL_MINOR_GLOBE_OF_INVULNERABILITY_15
      IP_CONST_CASTSPELL_PREMONITION_15
      IP_CONST_CASTSPELL_SPELL_RESISTANCE_15
      IP_CONST_CASTSPELL_GREATER_SPELL_MANTLE_17
      IP_CONST_CASTSPELL_MORDENKAINENS_DISJUNCTION_17
      IP_CONST_CASTSPELL_SHAPECHANGE_17
      IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_20

      // Wands and other Items, but no Potions
      IP_CONST_CASTSPELL_ACID_SPLASH_1
      IP_CONST_CASTSPELL_DAZE_1
      IP_CONST_CASTSPELL_ELECTRIC_JOLT_1
      IP_CONST_CASTSPELL_FLARE_1
      IP_CONST_CASTSPELL_INFLICT_MINOR_WOUNDS_1
      IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_1
      IP_CONST_CASTSPELL_RAY_OF_FROST_1
      IP_CONST_CASTSPELL_BURNING_HANDS_2
      IP_CONST_CASTSPELL_CHARM_PERSON_2
      IP_CONST_CASTSPELL_COLOR_SPRAY_2
      IP_CONST_CASTSPELL_DOOM_2
      IP_CONST_CASTSPELL_ENTANGLE_2
      IP_CONST_CASTSPELL_GREASE_2
      IP_CONST_CASTSPELL_PROTECTION_FROM_ALIGNMENT_2
      IP_CONST_CASTSPELL_RAY_OF_ENFEEBLEMENT_2
      IP_CONST_CASTSPELL_SANCTUARY_2
      IP_CONST_CASTSPELL_SCARE_2
      IP_CONST_CASTSPELL_SLEEP_2
      IP_CONST_CASTSPELL_SUMMON_CREATURE_I_2
      IP_CONST_CASTSPELL_BLINDNESS_DEAFNESS_3
      IP_CONST_CASTSPELL_CHARM_PERSON_OR_ANIMAL_3
      IP_CONST_CASTSPELL_FLAME_LASH_3
      IP_CONST_CASTSPELL_GHOUL_TOUCH_3
      IP_CONST_CASTSPELL_KNOCK_3
      IP_CONST_CASTSPELL_MAGIC_MISSILE_3
      IP_CONST_CASTSPELL_MELFS_ACID_ARROW_3
      IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_3
      IP_CONST_CASTSPELL_SILENCE_3
      IP_CONST_CASTSPELL_SOUND_BURST_3
      IP_CONST_CASTSPELL_SUMMON_CREATURE_II_3
      IP_CONST_CASTSPELL_WEB_3
      IP_CONST_CASTSPELL_ANIMATE_DEAD_5
      IP_CONST_CASTSPELL_BESTOW_CURSE_5
      IP_CONST_CASTSPELL_BURNING_HANDS_5
      IP_CONST_CASTSPELL_CALL_LIGHTNING_5
      IP_CONST_CASTSPELL_CHARM_MONSTER_5
      IP_CONST_CASTSPELL_CONFUSION_5
      IP_CONST_CASTSPELL_DOMINATE_ANIMAL_5
      IP_CONST_CASTSPELL_DOOM_5
      IP_CONST_CASTSPELL_ENTANGLE_5
      IP_CONST_CASTSPELL_FEAR_5
      IP_CONST_CASTSPELL_FIREBALL_5
      IP_CONST_CASTSPELL_FLAME_ARROW_5
      IP_CONST_CASTSPELL_INFLICT_LIGHT_WOUNDS_5
      IP_CONST_CASTSPELL_INVISIBILITY_PURGE_5
      IP_CONST_CASTSPELL_INVISIBILITY_SPHERE_5
      IP_CONST_CASTSPELL_LIGHTNING_BOLT_5
      IP_CONST_CASTSPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT_5
      IP_CONST_CASTSPELL_MAGIC_FANG_5
      IP_CONST_CASTSPELL_MAGIC_MISSILE_5
      IP_CONST_CASTSPELL_NEGATIVE_ENERGY_BURST_5
      IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_5
      IP_CONST_CASTSPELL_POISON_5
      IP_CONST_CASTSPELL_PROTECTION_FROM_ALIGNMENT_5
      IP_CONST_CASTSPELL_SEARING_LIGHT_5
      IP_CONST_CASTSPELL_SLEEP_5
      IP_CONST_CASTSPELL_SLOW_5
      IP_CONST_CASTSPELL_STINKING_CLOUD_5
      IP_CONST_CASTSPELL_SUMMON_CREATURE_III_5
      IP_CONST_CASTSPELL_SUMMON_CREATURE_I_5
      IP_CONST_CASTSPELL_VAMPIRIC_TOUCH_5
      IP_CONST_CASTSPELL_MELFS_ACID_ARROW_6
      IP_CONST_CASTSPELL_BALAGARNSIRONHORN_7
      IP_CONST_CASTSPELL_DISMISSAL_7
      IP_CONST_CASTSPELL_DOMINATE_PERSON_7
      IP_CONST_CASTSPELL_ENERVATION_7
      IP_CONST_CASTSPELL_FLAME_STRIKE_7
      IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_7
      IP_CONST_CASTSPELL_IMPROVED_INVISIBILITY_7
      IP_CONST_CASTSPELL_INFLICT_MODERATE_WOUNDS_7
      IP_CONST_CASTSPELL_LESSER_SPELL_BREACH_7
      IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_7
      IP_CONST_CASTSPELL_PHANTASMAL_KILLER_7
      IP_CONST_CASTSPELL_SHADOW_CONJURATION_7
      IP_CONST_CASTSPELL_SUMMON_CREATURE_IV_7
      IP_CONST_CASTSPELL_TASHAS_HIDEOUS_LAUGHTER_7
      IP_CONST_CASTSPELL_QUILLFIRE_8
      IP_CONST_CASTSPELL_GREATER_MAGIC_FANG_9
      IP_CONST_CASTSPELL_ICE_STORM_9
      IP_CONST_CASTSPELL_INFLICT_SERIOUS_WOUNDS_9
      IP_CONST_CASTSPELL_MAGIC_MISSILE_9
      IP_CONST_CASTSPELL_MELFS_ACID_ARROW_9
      IP_CONST_CASTSPELL_MIND_FOG_9
      IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_9
      IP_CONST_CASTSPELL_SPIKE_GROWTH_9
      IP_CONST_CASTSPELL_WALL_OF_FIRE_9
      IP_CONST_CASTSPELL_WOUNDING_WHISPERS_9
      IP_CONST_CASTSPELL_ANIMATE_DEAD_10
      IP_CONST_CASTSPELL_CALL_LIGHTNING_10
      IP_CONST_CASTSPELL_CHARM_MONSTER_10
      IP_CONST_CASTSPELL_CHARM_PERSON_10
      IP_CONST_CASTSPELL_CHARM_PERSON_OR_ANIMAL_10
      IP_CONST_CASTSPELL_CONFUSION_10
      IP_CONST_CASTSPELL_FIREBALL_10
      IP_CONST_CASTSPELL_FLAME_LASH_10
      IP_CONST_CASTSPELL_GUST_OF_WIND_10
      IP_CONST_CASTSPELL_LIGHTNING_BOLT_10
      IP_CONST_CASTSPELL_NEGATIVE_ENERGY_BURST_10
      IP_CONST_CASTSPELL_DISMISSAL_12
      IP_CONST_CASTSPELL_FLAME_ARROW_12
      IP_CONST_CASTSPELL_FLAME_STRIKE_12
      IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_12
      IP_CONST_CASTSPELL_INFLICT_CRITICAL_WOUNDS_12
      IP_CONST_CASTSPELL_ISAACS_LESSER_MISSILE_STORM_13
      IP_CONST_CASTSPELL_ANIMATE_DEAD_15
      IP_CONST_CASTSPELL_BANISHMENT_15
      IP_CONST_CASTSPELL_BIGBYS_FORCEFUL_HAND_15
      IP_CONST_CASTSPELL_BIGBYS_INTERPOSING_HAND_15
      IP_CONST_CASTSPELL_DIRGE_15
      IP_CONST_CASTSPELL_DROWN_15
      IP_CONST_CASTSPELL_FIREBRAND_15
      IP_CONST_CASTSPELL_INFERNO_15
      IP_CONST_CASTSPELL_ISAACS_GREATER_MISSILE_STORM_15
      IP_CONST_CASTSPELL_PLANAR_ALLY_15
      IP_CONST_CASTSPELL_BIGBYS_GRASPING_HAND_17
      IP_CONST_CASTSPELL_METEOR_SWARM_17
      IP_CONST_CASTSPELL_DISMISSAL_18
      IP_CONST_CASTSPELL_FLAME_ARROW_18
      IP_CONST_CASTSPELL_FLAME_STRIKE_18
      IP_CONST_CASTSPELL_BIGBYS_CLENCHED_FIST_20
      IP_CONST_CASTSPELL_BIGBYS_CRUSHING_HAND_20
      IP_CONST_CASTSPELL_BOMBARDMENT_20
      IP_CONST_CASTSPELL_EARTHQUAKE_20
      IP_CONST_CASTSPELL_SUNBURST_20
      IP_CONST_CASTSPELL_UNDEATHS_ETERNAL_FOE_20

      // Wands/Potions and other Items
      IP_CONST_CASTSPELL_CURE_MINOR_WOUNDS_1
      IP_CONST_CASTSPELL_LIGHT_1
      IP_CONST_CASTSPELL_VIRTUE_1
      IP_CONST_CASTSPELL_BLESS_2
      IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_2
      IP_CONST_CASTSPELL_ENDURE_ELEMENTS_2
      IP_CONST_CASTSPELL_MAGE_ARMOR_2
      IP_CONST_CASTSPELL_REMOVE_FEAR_2
      IP_CONST_CASTSPELL_RESISTANCE_2
      IP_CONST_CASTSPELL_AID_3
      IP_CONST_CASTSPELL_BARKSKIN_3
      IP_CONST_CASTSPELL_BULLS_STRENGTH_3
      IP_CONST_CASTSPELL_CATS_GRACE_3
      IP_CONST_CASTSPELL_CLARITY_3
      IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_3
      IP_CONST_CASTSPELL_DARKNESS_3
      IP_CONST_CASTSPELL_DARKVISION_3
      IP_CONST_CASTSPELL_EAGLE_SPLEDOR_3
      IP_CONST_CASTSPELL_ENDURANCE_3
      IP_CONST_CASTSPELL_FIND_TRAPS_3
      IP_CONST_CASTSPELL_FOXS_CUNNING_3
      IP_CONST_CASTSPELL_GHOSTLY_VISAGE_3
      IP_CONST_CASTSPELL_HOLD_ANIMAL_3
      IP_CONST_CASTSPELL_HOLD_PERSON_3
      IP_CONST_CASTSPELL_IDENTIFY_3
      IP_CONST_CASTSPELL_INVISIBILITY_3
      IP_CONST_CASTSPELL_LESSER_DISPEL_3
      IP_CONST_CASTSPELL_LESSER_RESTORATION_3
      IP_CONST_CASTSPELL_OWLS_WISDOM_3
      IP_CONST_CASTSPELL_PROTECTION_FROM_ELEMENTS_3
      IP_CONST_CASTSPELL_REMOVE_PARALYSIS_3
      IP_CONST_CASTSPELL_RESIST_ELEMENTS_3
      IP_CONST_CASTSPELL_SEE_INVISIBILITY_3
      IP_CONST_CASTSPELL_AMPLIFY_5
      IP_CONST_CASTSPELL_BANE_5
      IP_CONST_CASTSPELL_CAMOFLAGE_5
      IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_5
      IP_CONST_CASTSPELL_AURAOFGLORY_7
      IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_5
      IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_5
      IP_CONST_CASTSPELL_DISPEL_MAGIC_5
      IP_CONST_CASTSPELL_DIVINE_FAVOR_5
      IP_CONST_CASTSPELL_DIVINE_MIGHT_5
      IP_CONST_CASTSPELL_DIVINE_SHIELD_5
      IP_CONST_CASTSPELL_ENTROPIC_SHIELD_5
      IP_CONST_CASTSPELL_EXPEDITIOUS_RETREAT_5
      IP_CONST_CASTSPELL_HASTE_5
      IP_CONST_CASTSPELL_LESSER_DISPEL_5
      IP_CONST_CASTSPELL_LIGHT_5
      IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_5
      IP_CONST_CASTSPELL_NEUTRALIZE_POISON_5
      IP_CONST_CASTSPELL_PRAYER_5
      IP_CONST_CASTSPELL_REMOVE_BLINDNESS_DEAFNESS_5
      IP_CONST_CASTSPELL_REMOVE_CURSE_5
      IP_CONST_CASTSPELL_REMOVE_DISEASE_5
      IP_CONST_CASTSPELL_RESISTANCE_5
      IP_CONST_CASTSPELL_SHIELD_5
      IP_CONST_CASTSPELL_SHIELD_OF_FAITH_5
      IP_CONST_CASTSPELL_TRUE_STRIKE_5
      IP_CONST_CASTSPELL_BARKSKIN_6
      IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_6
      IP_CONST_CASTSPELL_DARKVISION_6
      IP_CONST_CASTSPELL_BLOOD_FRENZY_7
      IP_CONST_CASTSPELL_CONTINUAL_FLAME_7
      IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_7
      IP_CONST_CASTSPELL_DEATH_WARD_7
      IP_CONST_CASTSPELL_DIVINE_POWER_7
      IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_7
      IP_CONST_CASTSPELL_FREEDOM_OF_MOVEMENT_7
      IP_CONST_CASTSPELL_HOLD_MONSTER_7
      IP_CONST_CASTSPELL_ONE_WITH_THE_LAND_7
      IP_CONST_CASTSPELL_POLYMORPH_SELF_7
      IP_CONST_CASTSPELL_RESTORATION_7
      IP_CONST_CASTSPELL_STONESKIN_7
      IP_CONST_CASTSPELL_DISPLACEMENT_9
      IP_CONST_CASTSPELL_GHOSTLY_VISAGE_9
      IP_CONST_CASTSPELL_BULLS_STRENGTH_10
      IP_CONST_CASTSPELL_CATS_GRACE_10
      IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_10
      IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_10
      IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_10
      IP_CONST_CASTSPELL_DISPEL_MAGIC_10
      IP_CONST_CASTSPELL_EAGLE_SPLEDOR_10
      IP_CONST_CASTSPELL_ENDURANCE_10
      IP_CONST_CASTSPELL_FOXS_CUNNING_10
      IP_CONST_CASTSPELL_HASTE_10
      IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_10
      IP_CONST_CASTSPELL_OWLS_WISDOM_10
      IP_CONST_CASTSPELL_PROTECTION_FROM_ELEMENTS_10
      IP_CONST_CASTSPELL_RESIST_ELEMENTS_10
      IP_CONST_CASTSPELL_BARKSKIN_12
      IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_12
      IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_12
      IP_CONST_CASTSPELL_MASS_CAMOFLAGE_13
      IP_CONST_CASTSPELL_BULLS_STRENGTH_15
      IP_CONST_CASTSPELL_CATS_GRACE_15
      IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_15
      IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_15
      IP_CONST_CASTSPELL_EAGLE_SPLEDOR_15
      IP_CONST_CASTSPELL_ENDURANCE_15
      IP_CONST_CASTSPELL_FOXS_CUNNING_15
      IP_CONST_CASTSPELL_GHOSTLY_VISAGE_15
      IP_CONST_CASTSPELL_MIND_BLANK_15
      IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_15
      IP_CONST_CASTSPELL_OWLS_INSIGHT_15
      IP_CONST_CASTSPELL_OWLS_WISDOM_15
      IP_CONST_CASTSPELL_ETHEREALNESS_18

      // Only other items
      IP_CONST_CASTSPELL_CONTAGION_5
      IP_CONST_CASTSPELL_FLESH_TO_STONE_5
      IP_CONST_CASTSPELL_LEGEND_LORE_5
      IP_CONST_CASTSPELL_STONE_TO_FLESH_5
      IP_CONST_CASTSPELL_EVARDS_BLACK_TENTACLES_7
      IP_CONST_CASTSPELL_WAR_CRY_7
      IP_CONST_CASTSPELL_AWAKEN_9
      IP_CONST_CASTSPELL_CIRCLE_OF_DOOM_9
      IP_CONST_CASTSPELL_CLOUDKILL_9
      IP_CONST_CASTSPELL_CONE_OF_COLD_9
      IP_CONST_CASTSPELL_FEEBLEMIND_9
      IP_CONST_CASTSPELL_GREATER_SHADOW_CONJURATION_9
      IP_CONST_CASTSPELL_HEALING_CIRCLE_9
      IP_CONST_CASTSPELL_LESSER_PLANAR_BINDING_9
      IP_CONST_CASTSPELL_SLAY_LIVING_9
      IP_CONST_CASTSPELL_SUMMON_CREATURE_V_9
      IP_CONST_CASTSPELL_ACID_FOG_11
      IP_CONST_CASTSPELL_BLADE_BARRIER_11
      IP_CONST_CASTSPELL_CHAIN_LIGHTNING_11
      IP_CONST_CASTSPELL_CIRCLE_OF_DEATH_11
      IP_CONST_CASTSPELL_CREATE_UNDEAD_11
      IP_CONST_CASTSPELL_ENERGY_BUFFER_11
      IP_CONST_CASTSPELL_GREATER_SPELL_BREACH_11
      IP_CONST_CASTSPELL_HARM_11
      IP_CONST_CASTSPELL_MASS_HASTE_11
      IP_CONST_CASTSPELL_PLANAR_BINDING_11
      IP_CONST_CASTSPELL_SHADES_11
      IP_CONST_CASTSPELL_SUMMON_CREATURE_VI_11
      IP_CONST_CASTSPELL_AURA_OF_VITALITY_13
      IP_CONST_CASTSPELL_CONTROL_UNDEAD_13
      IP_CONST_CASTSPELL_CREEPING_DOOM_13
      IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_13
      IP_CONST_CASTSPELL_DESTRUCTION_13
      IP_CONST_CASTSPELL_FINGER_OF_DEATH_13
      IP_CONST_CASTSPELL_FIRE_STORM_13
      IP_CONST_CASTSPELL_MORDENKAINENS_SWORD_13
      IP_CONST_CASTSPELL_POWER_WORD_STUN_13
      IP_CONST_CASTSPELL_PRISMATIC_SPRAY_13
      IP_CONST_CASTSPELL_REGENERATE_13
      IP_CONST_CASTSPELL_SUMMON_CREATURE_VII_13
      IP_CONST_CASTSPELL_SUNBEAM_13
      IP_CONST_CASTSPELL_WORD_OF_FAITH_13
      IP_CONST_CASTSPELL_CREATE_UNDEAD_14
      IP_CONST_CASTSPELL_AURA_VERSUS_ALIGNMENT_15
      IP_CONST_CASTSPELL_BLADE_BARRIER_15
      IP_CONST_CASTSPELL_CHAIN_LIGHTNING_15
      IP_CONST_CASTSPELL_CIRCLE_OF_DEATH_15
      IP_CONST_CASTSPELL_CIRCLE_OF_DOOM_15
      IP_CONST_CASTSPELL_CONE_OF_COLD_15
      IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_15
      IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_15
      IP_CONST_CASTSPELL_CHAIN_LIGHTNING_20
      IP_CONST_CASTSPELL_CIRCLE_OF_DEATH_20
      IP_CONST_CASTSPELL_CIRCLE_OF_DOOM_20
      IP_CONST_CASTSPELL_CONTROL_UNDEAD_20
      IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_16
      IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_18
      IP_CONST_CASTSPELL_CREATE_UNDEAD_16
      IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_20
      IP_CONST_CASTSPELL_DOMINATE_MONSTER_17
      IP_CONST_CASTSPELL_ELEMENTAL_SWARM_17
      IP_CONST_CASTSPELL_ENERGY_BUFFER_15
      IP_CONST_CASTSPELL_ENERGY_BUFFER_20
      IP_CONST_CASTSPELL_ENERGY_DRAIN_17
      IP_CONST_CASTSPELL_EVARDS_BLACK_TENTACLES_15
      IP_CONST_CASTSPELL_FIRE_STORM_18
      IP_CONST_CASTSPELL_GATE_17
      IP_CONST_CASTSPELL_GREATER_PLANAR_BINDING_15
      IP_CONST_CASTSPELL_HEALING_CIRCLE_16
      IP_CONST_CASTSPELL_HORRID_WILTING_15
      IP_CONST_CASTSPELL_HORRID_WILTING_20
      IP_CONST_CASTSPELL_IMPLOSION_17
      IP_CONST_CASTSPELL_INCENDIARY_CLOUD_15
      IP_CONST_CASTSPELL_MASS_BLINDNESS_DEAFNESS_15
      IP_CONST_CASTSPELL_MASS_CHARM_15
      IP_CONST_CASTSPELL_MASS_HEAL_15
      IP_CONST_CASTSPELL_MORDENKAINENS_SWORD_18
      IP_CONST_CASTSPELL_NATURES_BALANCE_15
      IP_CONST_CASTSPELL_POWER_WORD_KILL_17
      IP_CONST_CASTSPELL_STORM_OF_VENGEANCE_17
      IP_CONST_CASTSPELL_SUMMON_CREATURE_IX_17
      IP_CONST_CASTSPELL_SUMMON_CREATURE_VIII_15
      IP_CONST_CASTSPELL_TIME_STOP_17
      IP_CONST_CASTSPELL_WAIL_OF_THE_BANSHEE_17
      IP_CONST_CASTSPELL_WEIRD_17

      // unused: IP_CONST_CASTSPELL_ACTIVATE_ITEM
      // unused: IP_CONST_CASTSPELL_UNIQUE_POWER
      // unused: IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY
      // unused: IP_CONST_CASTSPELL_MANIPULATE_PORTAL_STONE
      // unused: IP_CONST_CASTSPELL_DRAGON_BREATH_ACID_10
      // unused: IP_CONST_CASTSPELL_DRAGON_BREATH_COLD_10
      // unused: IP_CONST_CASTSPELL_DRAGON_BREATH_FEAR_10
      // unused: IP_CONST_CASTSPELL_DRAGON_BREATH_FIRE_10
      // unused: IP_CONST_CASTSPELL_DRAGON_BREATH_GAS_10
      // unused: IP_CONST_CASTSPELL_DRAGON_BREATH_LIGHTNING_10
      // unused: IP_CONST_CASTSPELL_DRAGON_BREATH_PARALYZE_10
      // unused: IP_CONST_CASTSPELL_DRAGON_BREATH_SLEEP_10
      // unused: IP_CONST_CASTSPELL_DRAGON_BREATH_SLOW_10
      // unused: IP_CONST_CASTSPELL_DRAGON_BREATH_WEAKEN_10
*/

