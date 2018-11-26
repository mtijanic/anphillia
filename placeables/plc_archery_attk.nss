#include "color_inc"


void main()
{
    object oTarget = OBJECT_SELF;
    object oAttacker = GetLastAttacker(oTarget);
    object oWeapon = GetLastWeaponUsed(oAttacker);

    // Sanity check - Ranged weapon?
    if(!GetWeaponRanged(oWeapon)) return;

    // d20 roll as base, apply penalties/bonuses to this:
    int nRoll = d20();

    // Critical Miss.
    if(nRoll == 1)
    {
       SpeakString(color_ConvertString("[missed]", "700"));
       return;
    }

    // Critical hit. Rather than automatic hit, just a nice bonus
    if(nRoll == 20) nRoll += 5;


    //Base Attack Bonus
    nRoll += GetBaseAttackBonus(oAttacker);
    //Dexterity Bonus
    nRoll += GetAbilityModifier(ABILITY_DEXTERITY, oAttacker);

    // +3 bonus for called shot
    nRoll += 3 * GetHasFeat(FEAT_CALLED_SHOT, oAttacker);


    // Weapon focus/specialization and Improved Critical all add +1 bonus.
    switch(GetBaseItemType(oWeapon))
    {
        case BASE_ITEM_DART:
            nRoll += GetHasFeat(FEAT_WEAPON_FOCUS_DART, oAttacker);
            nRoll += GetHasFeat(FEAT_WEAPON_SPECIALIZATION_DART, oAttacker);
            nRoll += GetHasFeat(FEAT_IMPROVED_CRITICAL_DART, oAttacker);
            break;

        case BASE_ITEM_HEAVYCROSSBOW:
            nRoll += GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW, oAttacker);
            nRoll += GetHasFeat(FEAT_WEAPON_SPECIALIZATION_HEAVY_CROSSBOW, oAttacker);
            nRoll += GetHasFeat(FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW, oAttacker);
            break;

        case BASE_ITEM_LIGHTCROSSBOW:
            nRoll += GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW, oAttacker);
            nRoll += GetHasFeat(FEAT_WEAPON_SPECIALIZATION_LIGHT_CROSSBOW, oAttacker);
            nRoll += GetHasFeat(FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW, oAttacker);
            break;

        case BASE_ITEM_LONGBOW:
            nRoll += GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW, oAttacker);
            nRoll += GetHasFeat(FEAT_WEAPON_SPECIALIZATION_LONGBOW, oAttacker);
            nRoll += GetHasFeat(FEAT_IMPROVED_CRITICAL_LONGBOW, oAttacker);
            break;

        case BASE_ITEM_SHORTBOW:
            nRoll += GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW, oAttacker);
            nRoll += GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SHORTBOW, oAttacker);
            nRoll += GetHasFeat(FEAT_IMPROVED_CRITICAL_SHORTBOW, oAttacker);
            break;

        case BASE_ITEM_SHURIKEN:
            nRoll += GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN, oAttacker);
            nRoll += GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SHURIKEN, oAttacker);
            nRoll += GetHasFeat(FEAT_IMPROVED_CRITICAL_SHURIKEN, oAttacker);
            break;

        case BASE_ITEM_SLING:
            nRoll += GetHasFeat(FEAT_WEAPON_FOCUS_SLING, oAttacker);
            nRoll += GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SLING, oAttacker);
            nRoll += GetHasFeat(FEAT_IMPROVED_CRITICAL_SLING, oAttacker);
            break;

        case BASE_ITEM_THROWINGAXE:
            nRoll += GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE, oAttacker);
            nRoll += GetHasFeat(FEAT_WEAPON_SPECIALIZATION_THROWING_AXE, oAttacker);
            nRoll += GetHasFeat(FEAT_IMPROVED_CRITICAL_THROWING_AXE, oAttacker);
            break;
    }

    // Distance penalty is double the number of meters to the target
    float fDistance = GetDistanceBetween(oAttacker, oTarget);
    nRoll -= 2 * FloatToInt(fDistance);


    // Find out where it hit.
    int nHit;

         if (nRoll < 2)  nHit = 0;
    else if (nRoll < 4)  nHit = 1;
    else if (nRoll < 6)  nHit = 2;
    else if (nRoll < 8)  nHit = 3;
    else if (nRoll < 10) nHit = 4;
    else if (nRoll < 12) nHit = 5;
    else if (nRoll < 14) nHit = 6;
    else if (nRoll < 16) nHit = 7;
    else if (nRoll < 18) nHit = 8;
    else if (nRoll < 20) nHit = 9;
    else                 nHit = 10;

    // Notify the players
    string sMessage;

    switch (nHit)
    {
        case 0: sMessage = color_ConvertString("[missed]", "700");      break;
        case 1: sMessage = color_ConvertString("[1]", "720");           break;
        case 2: sMessage = color_ConvertString("[2]", "740");           break;
        case 3: sMessage = color_ConvertString("[3]", "750");           break;
        case 4: sMessage = color_ConvertString("[4]", "760");           break;
        case 5: sMessage = color_ConvertString("[5]", "770");           break;
        case 6: sMessage = color_ConvertString("[6]", "670");           break;
        case 7: sMessage = color_ConvertString("[7]", "570");           break;
        case 8: sMessage = color_ConvertString("[8]", "470");           break;
        case 9: sMessage = color_ConvertString("[9]", "270");           break;
        case 10: sMessage = color_ConvertString("[BULLSEYE]", "070");   break;
    }

    SpeakString(sMessage);

}
