//:://////////////////////////////////////////////////
//:: NW_C2_DEFAULT7
/*
  Default OnDeath event handler for NPCs.

  Adjusts killer's alignment if appropriate and
  alerts allies to our death.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/22/2002
//:://////////////////////////////////////////////////
//:://////////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified On: April 1st, 2008
//:: Added Support for Dying Wile Mounted
//:://///////////////////////////////////////////////
//#include "x2_inc_compon"
#include "x0_i0_spawncond"
//#include "x3_inc_horse"
#include "xp_inc"
#include "lgs_inc"
#include "creature_inc"


void main()
{
    // Set Name (Original Name only)
    creature_SetName(OBJECT_SELF, CREATURE_NAME_DISPLAY_ORIGINAL);

    int nClass = GetLevelByClass(CLASS_TYPE_COMMONER);
    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
    object oKiller = GetLastKiller();

    // Get a controlled undead's master
    if(GetLocalString(oKiller, "MY_MASTER_IS") != "")
    {
        object oKillerMaster = GetMaster(oKiller);
        oKiller = oKillerMaster;
    }

    if (GetLocalInt(GetModule(),"X3_ENABLE_MOUNT_DB")&&GetIsObjectValid(GetMaster(OBJECT_SELF))) SetLocalInt(GetMaster(OBJECT_SELF),"bX3_STORE_MOUNT_INFO",TRUE);


    // If we're a good/neutral commoner,
    // adjust the killer's alignment evil
    if(nClass > 0 && (nAlign == ALIGNMENT_GOOD || nAlign == ALIGNMENT_NEUTRAL))
    {
        AdjustAlignment(oKiller, ALIGNMENT_EVIL, 5);
    }

    // Call to allies to let them know we're dead
    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);

    //Shout Attack my target, only works with the On Spawn In setup
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);

    // NOTE: the OnDeath user-defined event does not
    // trigger reliably and should probably be removed
    if(GetSpawnInCondition(NW_FLAG_DEATH_EVENT))
    {
         SignalEvent(OBJECT_SELF, EventUserDefined(1007));
    }
    else if(GetRacialType(OBJECT_SELF)==RACIAL_TYPE_ANIMAL)
    {
        SetIsDestroyable(FALSE, FALSE, TRUE);
        DelayCommand(30.0,SetIsDestroyable(TRUE, FALSE, TRUE));
    }
    else
    {
        // LeaveCorpse();

        // Get the location of the dead monster
        location lCorpseLoc = GetLocation(OBJECT_SELF);

        // Make the corpse NOT fade
        SetIsDestroyable(FALSE, TRUE, FALSE);

        // Create Blood Stain under the coprse
        object oBlood = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_bloodstain", lCorpseLoc, FALSE);

        // Create Loot Container on the corpse
        object oLootObject = CreateObject(OBJECT_TYPE_PLACEABLE, "invis_corpse_obj", lCorpseLoc, FALSE, GetTag(OBJECT_SELF));
        SetName(oLootObject, "Dead " + GetName(OBJECT_SELF));
        SetDescription(oLootObject, GetDescription(OBJECT_SELF));

        // Create Loot
        if ((GetStandardFactionReputation(STANDARD_FACTION_HOSTILE, OBJECT_SELF) >= 90)      // Only Faction Hostile creatures will drop stuff
            //|| FindSubString(GetName(OBJECT_SELF), "Kobold") >= 0                            // HACK! Make kobolds drop loot too!
            || FindSubString(GetName(OBJECT_SELF), "Spider") >= 0)                           // HACK! Make spiders drop loot too!
        {
            int nMinLoot = GetLocalInt(OBJECT_SELF, "lgs_lootcount");
            if (nMinLoot == 0)
                nMinLoot = -1;

            object oContainer = GetNearestObjectByTag(CS_LGS_CHEST_VAR_RESREF, OBJECT_SELF);
            if (!GetIsObjectValid(oContainer))
            {
               lgs_CreateLoot(OBJECT_SELF, oLootObject, OBJECT_INVALID, FALSE, nMinLoot);
            }
            else
            {
               lgs_CreateLoot(OBJECT_SELF, oContainer, oLootObject, FALSE, nMinLoot);

               // Inform the Loot Container to (re)start it's countdown
               if (GetLocalInt(oContainer, CS_LGS_CHEST_CHECK_ISCHECKING))
                   SetLocalInt(oContainer, CS_LGS_CHEST_CHECK_COUNT, 1);
               else
                   ExecuteScript("lgs_chest_check", oContainer);
            }
        }

        // Check if there's anything in the loot container
        if (!GetIsObjectValid(GetFirstItemInInventory(oLootObject)))
            DestroyObject(oLootObject);

        // Plan for everything to decay
        float fFade = 240.0f;
        object oModule = GetModule();
        ActionWait(fFade);
        DelayCommand(fFade, lgs_ClearInventory(oLootObject));
        DelayCommand(fFade, lgs_ClearInventory(OBJECT_SELF));
        DelayCommand(fFade + 0.1f, DestroyObject(oLootObject));
        DelayCommand(fFade + 0.1f, DestroyObject(oBlood));
        DelayCommand(fFade + 0.3f, SetIsDestroyable(TRUE,TRUE,FALSE));
        DelayCommand(fFade + 0.5f, DestroyObject(OBJECT_SELF));

    }
    xp_GiveXPForKill(OBJECT_SELF, oKiller);

    //AnphRewardXP (OBJECT_SELF, oKiller);
}
