#include "anph_inc"
#include "nwnx_time"

void main()
{
    object oUser = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    if (oTarget == OBJECT_INVALID)
    {
        SendMessageToPC(oUser, "This tool is used to grow an object, must target a valid object.");
        return;
    }

    float fScale = GetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_SCALE);
    fScale += 0.02;
    SetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_SCALE, fScale);
}

