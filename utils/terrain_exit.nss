//#include "terrain_inc"
//#include "color_inc"

void main()
{
    object oCreature = GetExitingObject();
    if (GetIsDM(oCreature))
        return;

    object oTrigger = OBJECT_SELF;
    effect eEffect = GetFirstEffect(oCreature);
    while (GetEffectCreator(eEffect) != oTrigger)
        eEffect = GetNextEffect(oCreature);

    RemoveEffect(oCreature, eEffect);

    if(GetIsPC(oCreature))
        FloatingTextStringOnCreature("Exiting special terrain, effects removed", oCreature);
}
