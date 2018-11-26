//::///////////////////////////////////////////////
//:: Summon Familiar
//:: NW_S2_Familiar
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons an Arcane casters familiar
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////

void main()
{
    //Yep thats it
    SummonFamiliar();
    object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR);
    if (GetAppearanceType(oFamiliar) == APPEARANCE_TYPE_FAERIE_DRAGON)
        SetCreatureAppearanceType(oFamiliar, 3371); // Cute purple dragon

    int nFamiliarLevel = GetHitDice(oFamiliar);
    float fScale = 0.6 + nFamiliarLevel*0.05;
    SetObjectVisualTransform(oFamiliar, OBJECT_VISUAL_TRANSFORM_SCALE, fScale);
}
