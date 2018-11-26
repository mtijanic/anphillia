#include "nwnx_dialog"
// +1% or something
// "Scaling"
void main()
{
    object oPC = GetPCSpeaker();
    string sText = NWNX_Dialog_GetCurrentNodeText();

    float fScale = GetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE);
    if (GetStringRight(sText, 1) == "%")
    {
        float fMod = StringToFloat(GetStringLeft(sText, 2));
        fScale += fMod * 0.01;
        if (fScale > 1.2) fScale = 1.2;
        else if (fScale < 0.8) fScale = 0.8;

        SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fScale);
    }
    SetCustomToken(5551, FloatToString(fScale * 100.0, 3, 0) + "%");
}
