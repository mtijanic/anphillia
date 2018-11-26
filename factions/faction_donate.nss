// OnDisturbed placeable item for donating to your faction
#include "sql_inc"
#include "faction_inc"
#include "chr_inc"
#include "dbg_inc"

void main()
{
    object chest = OBJECT_SELF;
    object item = GetInventoryDisturbItem();
    int type = GetInventoryDisturbType();
    object pc = GetLastDisturbed();

    string tag = GetTag(chest);
    string sFaction = GetStringRight(tag, GetStringLength(tag) - GetStringLength("FactionArmory_"));
    int faction = fctn_GetFactionIdFromName(sFaction);

    if (type == INVENTORY_DISTURB_TYPE_ADDED)
    {
        string pool;

        int basetype = GetBaseItemType(item);
        string tag = GetTag(item);
        if (GetStringLeft(tag, 14) == "ANPH_SUPPLIES_")
        {
            pool = GetStringRight(tag, GetStringLength(tag) - 14);
        }
        else
        {
            switch (basetype)
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
                    pool = "Arms";
                    break;

                case BASE_ITEM_ARMOR:
                case BASE_ITEM_SMALLSHIELD:
                case BASE_ITEM_LARGESHIELD:
                case BASE_ITEM_TOWERSHIELD:
                case BASE_ITEM_BELT:
                case BASE_ITEM_HELMET:
                case BASE_ITEM_GLOVES:
                case BASE_ITEM_BOOTS:
                case BASE_ITEM_CLOAK:
                case BASE_ITEM_BRACER:
                    pool = "Armor";
                    break;

                case BASE_ITEM_MAGICROD:
                case BASE_ITEM_MAGICSTAFF:
                case BASE_ITEM_MAGICWAND:
                case BASE_ITEM_POTIONS:
                case BASE_ITEM_SCROLL:
                case BASE_ITEM_ENCHANTED_POTION:
                case BASE_ITEM_ENCHANTED_SCROLL:
                case BASE_ITEM_ENCHANTED_WAND:
                case BASE_ITEM_SPELLSCROLL:
                case BASE_ITEM_BOOK:
                    pool = "Magic";
                    break;

                default:
                    pool = "Gold";
                    break;
            }
        }

        int value = GetGoldPieceValue(item);
        value *= GetItemStackSize(item);

        if (basetype == BASE_ITEM_GOLD)
            value *= 10;
        else value /= 10;

        NWNX_SQL_ExecuteQuery("UPDATE " + SQL_TABLE_FACTIONS + " SET " + pool +"="+ pool + " + " + IntToString(value) + " WHERE ID="+IntToString(faction));
        SendMessageToPC(pc, "Your contribution to your faction has been noted");
        WriteTimestampedLogEntry("Donation: " + GetName(pc) + " has donated " + GetName(item) + " worth " + IntToString(value) +" gp to " + sFaction + "'s " + pool + " pool");
        NWNX_SQL_ExecuteQuery("UPDATE " + SQL_TABLE_CHARDATA + " SET DonatedStuff=DonatedStuff+" + IntToString(value) + " WHERE PCID="+IntToString(chr_GetPCID(pc)));
        DestroyObject(item);
    }
}

