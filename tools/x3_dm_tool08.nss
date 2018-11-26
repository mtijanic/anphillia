#include "anph_inc"
#include "nwnx_time"

void main()
{
    object oUser = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    if (GetObjectType(oTarget) != OBJECT_TYPE_CREATURE  || GetIsPC(oTarget))
    {
        SendMessageToPC(oUser, "NPC randomizer tool should only be used on (NPC) creatures");
        return;
    }

    string sWhat = GetStringUpperCase(chr_GetPlayerChatMessage(oUser));

    string sMsg = "";

    if (FindSubString(sWhat, "G") >= 0) sMsg += " Gender";
    if (FindSubString(sWhat, "R") >= 0) sMsg += " Race";
    if (FindSubString(sWhat, "N") >= 0) sMsg += " Name";
    if (FindSubString(sWhat, "S") >= 0) sMsg += " Scaling";
    if (FindSubString(sWhat, "L") >= 0) sMsg += " Levels";
    if (FindSubString(sWhat, "A") >= 0) sMsg += " Armor";
    if (FindSubString(sWhat, "W") >= 0) sMsg += " Weapons";
    if (FindSubString(sWhat, "H") >= 0) sMsg += " Head";
    if (FindSubString(sWhat, "C") >= 0) sMsg += " Color";
    if (FindSubString(sWhat, "P") >= 0) sMsg += " PhenoType";

    if (sMsg != "")
    {
        SendMessageToPC(oUser, "Randomizing: " + sMsg);
        SetLocalString(oTarget, "NPC_RANDOMIZE", sWhat);
        ExecuteScript("npc_randomize", oTarget);
    }
    else
    {
        SendMessageToPC(oUser, "Speak any of GRNSLAWHPC to randomize the NPC:\n" +
            "G: Gender\n" +
            "R: Race\n" +
            "N: Name\n" +
            "S: Scaling\n" +
            "L: Levels\n" +
            "A: Armor\n" +
            "W: Weapons\n"+
            "H: Head\n"+
            "P: PhenoType\n"+
            "C: Color\n"
            );
    }
}

