#include "egs_inc"
#include "lgs_inc"
#include "nwnx_creature"
#include "nwnx_object"
void main()
{
    object oNPC = OBJECT_SELF;

    string sWhat = GetLocalString(oNPC, "NPC_RANDOMIZE");
    if (sWhat == "")
        return;

    int bGender  = FindSubString(sWhat, "G") >= 0;
    int bRace    = FindSubString(sWhat, "R") >= 0;
    int bName    = FindSubString(sWhat, "N") >= 0;
    int bScaling = FindSubString(sWhat, "S") >= 0;
    int bLevel   = FindSubString(sWhat, "L") >= 0;
    int bArmor   = FindSubString(sWhat, "A") >= 0;
    int bWeapon  = FindSubString(sWhat, "W") >= 0;
    int bHead    = FindSubString(sWhat, "H") >= 0;
    int bColor   = FindSubString(sWhat, "C") >= 0;
    int bPheno   = FindSubString(sWhat, "P") >= 0;


    if (bGender)
    {
        NWNX_Creature_SetGender(oNPC, Random(2));
    }

    if (bPheno)
    {
        SetPhenoType(Random(100) < 20 ? PHENOTYPE_BIG : PHENOTYPE_NORMAL, oNPC);
    }

    if (bRace)
    {
        NWNX_Creature_SetRacialType(oNPC, Random(7));// Dwarf..Human
    }


    if (bColor)
    {
        int nHair = d20();
        switch (nHair)
        {
            case 15: nHair = 166; break;
            case 16: nHair = 167; break;
            case 17: nHair = 124; break;
            case 18: nHair = 31;  break;
            case 19: nHair = 47;  break;
            case 20: nHair = 0;   break;
        }
        SetColor(oNPC, COLOR_CHANNEL_HAIR, nHair);

        int nSkin = d6();
        switch (nSkin)
        {
        case 5: nSkin = 12; break;
        case 6: nSkin = 0;  break;
        }
        SetColor(oNPC, COLOR_CHANNEL_SKIN, nSkin);

        SetColor(oNPC, COLOR_CHANNEL_TATTOO_1, Random(176));
        SetColor(oNPC, COLOR_CHANNEL_TATTOO_2, Random(176));
    }

    if (bHead)
    {
        int nModel = 0;
        switch (GetGender(oNPC))
        {
        case GENDER_MALE:

            switch (GetRacialType(oNPC))
            {
                case RACIAL_TYPE_DWARF:    nModel = Random(14) + 1; break;
                case RACIAL_TYPE_ELF:      nModel = Random(20) + 1; break;
                case RACIAL_TYPE_GNOME:    nModel = Random(13) + 1; break;
                case RACIAL_TYPE_HALFELF:  nModel = Random(49) + 1; break;
                case RACIAL_TYPE_HALFLING: nModel = Random(12) + 1; break;
                case RACIAL_TYPE_HALFORC:  nModel = Random(14) + 1; break;
                case RACIAL_TYPE_HUMAN:    nModel = Random(49) + 1; break;
            }
            break;

        case GENDER_FEMALE:
            switch (GetRacialType(oNPC))
            {
                case RACIAL_TYPE_DWARF:    nModel = Random(12) + 1; break;
                case RACIAL_TYPE_ELF:      nModel = Random(33) + 1; break;
                case RACIAL_TYPE_GNOME:    nModel = Random(9)  + 1; break;
                case RACIAL_TYPE_HALFELF:  nModel = Random(49) + 1; break;
                case RACIAL_TYPE_HALFLING: nModel = Random(15) + 1; break;
                case RACIAL_TYPE_HALFORC:  nModel = Random(12) + 1; break;
                case RACIAL_TYPE_HUMAN:    nModel = Random(49) + 1; break;
            }
            break;
        }

        if (nModel > 0)
            SetCreatureBodyPart(CREATURE_PART_HEAD, nModel, oNPC);
    }

    if (bName)
    {
        string sName;
        int nLTR1 = 3*GetRacialType(oNPC) + GetGender(oNPC) + 2;
        int nLTR2 = 3*GetRacialType(oNPC) + 4;

        if (nLTR1 > 22)
            sName = RandomName(Random(3) - 1); // Generic male, familiar or female
        else
            sName = RandomName(nLTR1) + " " + RandomName(nLTR2);

        SetName(oNPC, sName);
    }

    if (bScaling)
    {
        SetObjectVisualTransform(oNPC, OBJECT_VISUAL_TRANSFORM_SCALE, 0.85 + IntToFloat(Random(30))/100);
    }

    if (bLevel)
    {
        int nLevels = Random(7)/2;
        while (nLevels--)
            LevelUpHenchman(oNPC, CLASS_TYPE_INVALID, TRUE);
    }

    if (bArmor)
    {
        lgs_CreateEquipmentOnTarget(CI_EGS_ITEM_MAIN_ARMOR, Random(3)+2, -1,
            oNPC, INVENTORY_SLOT_CHEST, FloatToInt(GetChallengeRating(oNPC)));

        if (Random(100) < 50)
            lgs_CreateEquipmentOnTarget(CI_EGS_ITEM_MAIN_ARMOR, CI_EGS_ITEM_SUB_ARMOR_HELMET, -1,
                oNPC, INVENTORY_SLOT_HEAD, FloatToInt(GetChallengeRating(oNPC)));
    }

    if (bWeapon)
    {
        int bMelee = Random(100) < 70;
        if (bMelee)
        {
            lgs_CreateEquipmentOnTarget(CI_EGS_ITEM_MAIN_WEAPON, CI_EGS_ITEM_SUB_WEAPON_MELEE, -1,
                oNPC, INVENTORY_SLOT_RIGHTHAND, FloatToInt(GetChallengeRating(oNPC)));

            if (Random(100) < 30)
                lgs_CreateEquipmentOnTarget(CI_EGS_ITEM_MAIN_ARMOR, CI_EGS_ITEM_SUB_ARMOR_SHIELD, -1,
                    oNPC, INVENTORY_SLOT_HEAD, FloatToInt(GetChallengeRating(oNPC)));
        }
        else
        {
            lgs_CreateEquipmentOnTarget(CI_EGS_ITEM_MAIN_WEAPON, CI_EGS_ITEM_SUB_WEAPON_RANGED, -1,
                oNPC, INVENTORY_SLOT_RIGHTHAND, FloatToInt(GetChallengeRating(oNPC)));

            lgs_CreateEquipmentOnTarget(CI_EGS_ITEM_MAIN_AMMO, -1, -1, oNPC, -1, FloatToInt(GetChallengeRating(oNPC)));
            lgs_CreateEquipmentOnTarget(CI_EGS_ITEM_MAIN_AMMO, -1, -1, oNPC, -1, FloatToInt(GetChallengeRating(oNPC)));
            lgs_CreateEquipmentOnTarget(CI_EGS_ITEM_MAIN_AMMO, -1, -1, oNPC, -1, FloatToInt(GetChallengeRating(oNPC)));
            lgs_CreateEquipmentOnTarget(CI_EGS_ITEM_MAIN_AMMO, -1, -1, oNPC, -1, FloatToInt(GetChallengeRating(oNPC)));
            lgs_CreateEquipmentOnTarget(CI_EGS_ITEM_MAIN_AMMO, -1, -1, oNPC, -1, FloatToInt(GetChallengeRating(oNPC)));
        }

    }

    // Refresh appearance for player races
    int nRace = GetRacialType(oNPC);
    if (nRace <= 6)
        SetCreatureAppearanceType(oNPC, nRace);
    // Gender changes require a full object reload to be visible
    if (bGender)
    {
        CopyObject(oNPC, GetLocation(oNPC));
        DestroyObject(oNPC);
    }
}

