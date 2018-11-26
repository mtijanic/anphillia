void main()
{
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    location lTarget = GetLocation(OBJECT_SELF);

    float fRadius = GetLocalFloat(OBJECT_SELF, "DAMAGE_RADIUS");
    int nDice = GetLocalInt(OBJECT_SELF, "DAMAGE_DICE");
    int nRoll = GetLocalInt(OBJECT_SELF, "DAMAGE_ROLL");

    //Apply the fireball explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget,
        TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) || oTarget == OBJECT_SELF)
    {
        // Get the distance between the explosion and the target to calculate delay
        float fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

        int nDamage = 0;
        int i;
        for(i = 0; i < nDice; ++i)
        {
            nDamage += Random(nRoll - 1) + 1;
        }

        //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
        nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
        effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
        if(nDamage > 0)
        {
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }

       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE,
            OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
