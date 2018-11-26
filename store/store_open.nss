#include "eas_inc"
#include "color_inc"
#include "egs_inc"
#include "ip_inc"
#include "store_inc"

void main()
{
    object oNPC = OBJECT_SELF;
    object oStore;
    object oPC = GetPCSpeaker ();
    string sTag = GetTag (oNPC);

    oStore = store_GetStore(OBJECT_SELF);
    if (!GetIsObjectValid (oStore))
    {
        ActionSpeakString ("Sorry, the store is closed.");
        return;
    }

    object oModule = GetModule();
    int nReady = GetLocalInt(oModule, CS_STORE_SYSTEMREADY);
    if (nReady == 0)
    {
        ActionSpeakString ("Sorry, the store is closed, but will open very soon.");
        return;
    }

    store_Initialize(oStore);

    if (store_GetAmountOfItems(oStore) == 0)
    {
       int iMinutesToRefill = (CS_STORE_RESETTIME - GetLocalInt(oStore, "heartbeats")) / 10;
       ActionSpeakString ("I am out of stock. The next delivery of items is scheduled in about " + color_ConvertString(IntToString(iMinutesToRefill), COLOR_GREEN) + " minutes.\nYou can still sell items to me though.");
    }

    OpenStore (oStore, oPC);
}
