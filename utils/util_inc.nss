#include "nwnx_object"
#include "nwnx_player"


const int PERIOD_DAY   = 1;
const int PERIOD_NIGHT = 2;
const int PERIOD_DAWN  = 3;
const int PERIOD_DUSK  = 4;

// Clear all items from object's inventory
void util_ClearInventory(object o);

// SendMessageToPC() for all PCs
void util_SendMessageToAllPCs(string message);

// Delete all items in owners inventory that have a resref in reslist
// Separate reslist with # or ; or other resref-invalid characters
void util_DestroyAllItemsByResRef(object owner, string reslist);

// Returns a random location in oArea
location util_GetRandomLocation(object oArea);

void util_PopUp(object oPC, string sTitle, string sMsg, string sIcon="");

int util_GetLevelByXP (int nXP);

int util_GetLevel(object oPC);

int util_GetXPByLevel(int nLevel);

void util_ToggleEncountersInArea(object oArea, int bActive);

int util_GetItemEquipSlot(object oItem);
int util_GetDayPeriod();

// Convert a location to string and back
string util_EncodeLocation(location l);
location util_DecodeLocation(string s);

// Returns true if oItem's base type is some weapon
int util_IsWeapon(object oItem);


int max(int a, int b) { return (a>b) ? a : b; }
int min(int a, int b) { return (a<b) ? a : b; }

void util_ClearInventory(object o)
{
    object item = GetFirstItemInInventory(o);
    while (item != OBJECT_INVALID)
    {
        if (GetHasInventory(item))
        {
            object item2 = GetFirstItemInInventory(item);
            while (item2 != OBJECT_INVALID)
            {
                DestroyObject(item2);
                item2 = GetNextItemInInventory(item);
            }
        }
        DestroyObject(item);
        item = GetNextItemInInventory(o);
    }

    if (GetObjectType(o) == OBJECT_TYPE_CREATURE)
    {
        int i;
        for (i = 0; i < NUM_INVENTORY_SLOTS; i++)
            DestroyObject(GetItemInSlot(i, o));
    }
}

void util_SendMessageToAllPCs(string message)
{
    object pc = GetFirstPC();
    while (pc != OBJECT_INVALID)
    {
        SendMessageToPC(pc, message);
        pc = GetNextPC();
    }
}


void util_DestroyAllItemsByResRef(object owner, string reslist)
{
    object item = GetFirstItemInInventory(owner);
    while (item != OBJECT_INVALID)
    {
        if (GetHasInventory(item))
        {
            object item2 = GetFirstItemInInventory(item);
            while (item2 != OBJECT_INVALID)
            {

                if (FindSubString(reslist, GetResRef(item2)) >= 0)
                    DestroyObject(item2);
                item2 = GetNextItemInInventory(item);
            }
        }

        if (FindSubString(reslist, GetResRef(item)) >= 0)
            DestroyObject(item);
        item = GetNextItemInInventory(owner);
    }

    if (GetObjectType(owner) == OBJECT_TYPE_CREATURE)
    {
        int i;
        for (i = 0; i < NUM_INVENTORY_SLOTS; i++)
        {
            item = GetItemInSlot(i, owner);
            if (FindSubString(reslist, GetResRef(item)) >= 0)
                DestroyObject(item);
        }
    }
}

location util_GetRandomLocation(object oArea)
{
    int nX = Random(GetAreaSize(AREA_WIDTH, oArea)*100);
    int nY = Random(GetAreaSize(AREA_HEIGHT, oArea)*100);

    float fX = IntToFloat(nX)/100;
    float fY = IntToFloat(nY)/100;

    return Location(oArea, Vector(fX, fY, 0.0), 0.0);
}

void util_PopUp(object oPC, string sTitle, string sMsg, string sIcon="")
{
    object oPlc = GetObjectByTag("PLC_POPUP");
    SetName(oPlc, sTitle);
    SetDescription(oPlc, sMsg);
    NWNX_Object_SetPortrait(oPlc, sIcon);
    SendMessageToPC(oPC, sMsg);
    NWNX_Player_ForcePlaceableExamineWindow(oPC, oPlc);
}



int util_GetLevelByXP (int nXP)
{
    float fXP    = IntToFloat(nXP) / 1000;
    float fLevel = (sqrt(8 * fXP + 1) + 1) / 2;
    int   nLevel = FloatToInt(fLevel);
    return nLevel;
}

int util_GetLevel (object oPC)
{
    return GetHitDice(oPC);
}

int util_GetXPByLevel(int nLevel)
{
    int nXP = (((nLevel - 1)*nLevel)/2)*1000;
    return nXP;
}

void util_ToggleEncountersInArea(object oArea, int bActive)
{
    object oEncounter = GetFirstInPersistentObject(oArea, OBJECT_TYPE_ENCOUNTER);
    while (oEncounter != OBJECT_INVALID)
    {
         SetEncounterActive(bActive, oEncounter);
         oEncounter = GetNextInPersistentObject(oArea, OBJECT_TYPE_ENCOUNTER);
    }
}


int util_GetItemEquipSlot(object oItem)
{
     switch (GetBaseItemType(oItem))
     {
        case BASE_ITEM_AMULET:            return INVENTORY_SLOT_NECK;
        case BASE_ITEM_ARMOR:             return INVENTORY_SLOT_CHEST;
        case BASE_ITEM_ARROW:             return INVENTORY_SLOT_ARROWS;
        case BASE_ITEM_BASTARDSWORD:      return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_BATTLEAXE:         return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_BELT:              return INVENTORY_SLOT_BELT;
        case BASE_ITEM_BOLT:              return INVENTORY_SLOT_BOLTS;
        case BASE_ITEM_BOOTS:             return INVENTORY_SLOT_BOOTS;
        case BASE_ITEM_BRACER:            return INVENTORY_SLOT_ARMS;
        case BASE_ITEM_BULLET:            return INVENTORY_SLOT_BULLETS;
        case BASE_ITEM_CLOAK:             return INVENTORY_SLOT_CLOAK;
        case BASE_ITEM_CLUB:              return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_DAGGER:            return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_DART:              return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_DIREMACE:          return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_DOUBLEAXE:         return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_GLOVES:            return INVENTORY_SLOT_ARMS;
        case BASE_ITEM_GREATAXE:          return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_GREATSWORD:        return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_HALBERD:           return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_HANDAXE:           return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_HEAVYCROSSBOW:     return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_HEAVYFLAIL:        return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_HELMET:            return INVENTORY_SLOT_HEAD;
        case BASE_ITEM_KAMA:              return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_KATANA:            return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_KUKRI:             return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_LARGESHIELD:       return INVENTORY_SLOT_LEFTHAND;
        case BASE_ITEM_LIGHTCROSSBOW:     return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_LIGHTFLAIL:        return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_LIGHTHAMMER:       return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_LIGHTMACE:         return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_LONGBOW:           return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_LONGSWORD:         return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_MAGICSTAFF:        return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_MORNINGSTAR:       return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_QUARTERSTAFF:      return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_RAPIER:            return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_RING:              return INVENTORY_SLOT_RIGHTRING;
        case BASE_ITEM_SCIMITAR:          return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_SCYTHE:            return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_SHORTBOW:          return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_SHORTSPEAR:        return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_SHORTSWORD:        return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_SHURIKEN:          return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_SICKLE:            return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_SLING:             return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_SMALLSHIELD:       return INVENTORY_SLOT_LEFTHAND;
        case BASE_ITEM_THROWINGAXE:       return INVENTORY_SLOT_RIGHTHAND;
        case BASE_ITEM_TORCH:             return INVENTORY_SLOT_LEFTHAND;
        case BASE_ITEM_TOWERSHIELD:       return INVENTORY_SLOT_LEFTHAND;
        case BASE_ITEM_TWOBLADEDSWORD:    return INVENTORY_SLOT_RIGHTHAND;
      }
      return -1;
}
int ss_GetEncumberanceLevel(object oPC = OBJECT_SELF)
{

    int nWeight = GetWeight(oPC);
    int nStr = GetAbilityScore(oPC, ABILITY_STRENGTH);

    int nEnc = StringToInt(Get2DAString("encumbrance", "Heavy", nStr));
    if(nWeight > nEnc) return 2;

    nEnc = StringToInt(Get2DAString("encumbrance", "Normal", nStr));
    if(nWeight > nEnc) return 1;

    return 0;
}

int util_GetDayPeriod()
{
    if (GetIsNight())
        return PERIOD_NIGHT;
    else if (GetIsDawn())
        return PERIOD_DAWN;
    else if (GetIsDusk())
        return PERIOD_DUSK;
    else
        return PERIOD_DAY;
}


string util_EncodeLocation(location l)
{
    object area = GetAreaFromLocation(l);
    vector pos = GetPositionFromLocation(l);
    float facing = GetFacingFromLocation(l);
    string sReturnValue;

    return  "#TAG#" + GetTag(area) + "#RESREF#" + GetResRef(area) +
            "#X#" + FloatToString(pos.x, 5, 2) +
            "#Y#" + FloatToString(pos.y, 5, 2) +
            "#Z#" + FloatToString(pos.z, 5, 2) +
            "#F#" + FloatToString(facing,5, 2) + "#";
}

location util_DecodeLocation(string s)
{
    float facing, x, y, z;

    int idx, cnt;
    int strlen = GetStringLength(s);

    idx = FindSubString(s, "#TAG#") + 5;
    cnt = FindSubString(GetSubString(s, idx, strlen - idx), "#");
    string tag = GetSubString(s, idx, cnt);

    idx = FindSubString(s, "#RESREF#") + 8;
    cnt = FindSubString(GetSubString(s, idx, strlen - idx), "#");
    string resref = GetSubString(s, idx, cnt);

    object area = GetFirstArea();
    while (area != OBJECT_INVALID)
    {
        if (GetTag(area) == tag && GetResRef(area) == resref)
            break;
        area = GetNextArea();
    }

    idx = FindSubString(s, "#X#") + 3;
    cnt = FindSubString(GetSubString(s, idx, strlen - idx), "#");
    x = StringToFloat(GetSubString(s, idx, cnt));

    idx = FindSubString(s, "#Y#") + 3;
    cnt = FindSubString(GetSubString(s, idx, strlen - idx), "#");
    y = StringToFloat(GetSubString(s, idx, cnt));

    idx = FindSubString(s, "#Z#") + 3;
    cnt = FindSubString(GetSubString(s, idx, strlen - idx), "#");
    z = StringToFloat(GetSubString(s, idx, cnt));

    idx = FindSubString(s, "#F#") + 3;
    cnt = FindSubString(GetSubString(s, idx, strlen - idx), "#");
    facing = StringToFloat(GetSubString(s, idx, cnt));

    return Location(area, Vector(x, y, z), facing);
}

int util_IsWeapon(object oItem)
{
    switch (GetBaseItemType(oItem))
    {
        case BASE_ITEM_SHORTSWORD:
        case BASE_ITEM_LONGSWORD:
        case BASE_ITEM_BATTLEAXE:
        case BASE_ITEM_BASTARDSWORD:
        case BASE_ITEM_LIGHTFLAIL:
        case BASE_ITEM_WARHAMMER:
        case BASE_ITEM_HEAVYCROSSBOW:
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_LONGBOW:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_HALBERD:
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_TWOBLADEDSWORD:
        case BASE_ITEM_GREATSWORD:
        case BASE_ITEM_GREATAXE:
        case BASE_ITEM_ARROW:
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BULLET:
        case BASE_ITEM_CLUB:
        case BASE_ITEM_DART:
        case BASE_ITEM_DIREMACE:
        case BASE_ITEM_DOUBLEAXE:
        case BASE_ITEM_HEAVYFLAIL:
        case BASE_ITEM_LIGHTHAMMER:
        case BASE_ITEM_HANDAXE:
        case BASE_ITEM_KAMA:
        case BASE_ITEM_KATANA:
        case BASE_ITEM_KUKRI:
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_RAPIER:
        case BASE_ITEM_SCYTHE:
        case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_SHURIKEN:
        case BASE_ITEM_SICKLE:
        case BASE_ITEM_SCIMITAR:
        case BASE_ITEM_SLING:
        case BASE_ITEM_DWARVENWARAXE:
        case BASE_ITEM_WHIP:
        case BASE_ITEM_GRENADE:
        case BASE_ITEM_TRIDENT:
        case BASE_ITEM_THROWINGAXE:
        case BASE_ITEM_GLOVES:
        case BASE_ITEM_CSLASHWEAPON:
        case BASE_ITEM_CPIERCWEAPON:
        case BASE_ITEM_CBLUDGWEAPON:
        case BASE_ITEM_CSLSHPRCWEAP:
        // CEP weapons:
        case 300: //        trident_1h
        case 301: //        heavypick
        case 302: //        lightpick
        case 303: //        sai
        case 304: //        nunchaku
        case 305: //        falchion
        case 308: //        sap
        case 309: //        daggerassn
        case 310: //        katar
        case 312: //        lightmace2
        case 313: //        kukri2
        case 316: //        falchion_2
        case 317: //        heavy_mace
        case 318: //        maul
        case 319: //        mercurial_longsword
        case 320: //        mercurial_greatsword
        case 321: //        scimitar_double
        case 322: //        goad
        case 323: //        windfirewheel
        case 324: //        maugdoublesword
        case 327: //        Flowers_Crystal
        case 329: //        tool_2handed
        case 330: //        Longsword_2
            return TRUE;
    }
    return FALSE;
}
