#include "faction_inc"


int checkAlignment(object oPC, int faction)
{
    int goodevil = GetAlignmentGoodEvil (oPC);
    int lawchaos = GetAlignmentLawChaos (oPC);
    if (faction == ANPH_FACTION_AXFELL)
    {
        if (goodevil == ALIGNMENT_GOOD && lawchaos == ALIGNMENT_LAWFUL)
        {
            SendMessageToPC(oPC, "Lawful good characters are not allowed in Axfell");
            return FALSE;
        }
    }

    if (faction == ANPH_FACTION_CLEAVEN)
    {
        if (goodevil == ALIGNMENT_EVIL && lawchaos == ALIGNMENT_CHAOTIC)
        {
            SendMessageToPC(oPC, "Chaotic Evil characters are not allowed in Cleaven");
            return FALSE;
        }
    }
    return TRUE;
}

int checkClass(object oPC, int faction)
{

    return TRUE;
}

int checkRace(object oPC, int faction)
{
    int race = GetRacialType(oPC);
    string subrace = GetSubRace(oPC);

    if (faction == ANPH_FACTION_CLEAVEN)
    {
        if (FindSubString("Drow###Duergar###Dark Elf###Gray Dwarf###Grey Dwarf###Deep Gnome###Svirfneblin", subrace) > 0)
        {
            SendMessageToPC(oPC, "Underdark race characters are not allowed in Cleaven");
            return FALSE;
        }
    }
    return TRUE;
}

void giveStartingGear(object oPC, int faction)
{
    CreateItemOnObject("FoodRation", oPC);
    CreateItemOnObject("FoodRation", oPC);
    CreateItemOnObject("FoodRation", oPC);
    CreateItemOnObject("FoodRation", oPC);
    CreateItemOnObject("FoodRation", oPC);
    CreateItemOnObject("FoodRation", oPC);
    GiveGoldToCreature(oPC, 140);

    // Give druids Ear of the Druid
    if(GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0 && !GetIsObjectValid(GetItemPossessedBy(oPC, "DruidEar")))
    {
        CreateItemOnObject("DruidEar", oPC);
    }

    if (GetXP(oPC) < 3000)
        GiveXPToCreature(oPC, 3001 - GetXP(oPC));
}
void main()
{
    object oPC = GetLastUsedBy();
    if (!GetIsPC(oPC) || GetIsDM(oPC) || GetMaster(oPC) != OBJECT_INVALID)
        return;

    string tag = GetTag(OBJECT_SELF);
    string factname = GetStringRight(tag, GetStringLength(tag)-4); // join[faction]
    int faction = fctn_GetFactionIdFromName(factname);

    if (!checkAlignment(oPC, faction))
        return;
    if (!checkClass(oPC, faction))
        return;
    if (!checkRace(oPC, faction))
        return;

    giveStartingGear(oPC, faction);

    fctn_JoinFaction(oPC, faction);
    location loc = fctn_GetFactionStartingLocation(faction);
    AssignCommand (oPC, JumpToLocation(loc));
}
