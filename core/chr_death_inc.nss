///////////////////////////////////////////////////////////////////////////////
// chr_death_inc
// written by: eyesolated
// written at: May 17, 2018
//
// Notes: Include File for Character Death related stuff


///////////
// Includes
//
#include "datetime_inc"
#include "color_inc"
#include "chr_cfg"
#include "chr_inc"
#include "cnr_property_inc"
#include "sql_inc"
#include "anph_inc"
#include "anphrez_inc"
#include "faction_inc"


const string WEBHOOK_PVP = "/api/webhooks/451343864733761536/th1si5n0tar43lAPiK3y-n3v3rPuTaPiKEY5inS0urceRep0_Y_amIap0tat0lalalaF/slack";

///////////////////////
// Function Declaration
//

// Jumps a player to his faction's Fugue plane
void chr_Death_JumpToFugue(object oPC);

// Bleed check OnDying
void chr_Death_OnDying_Bleed(object oPC);

// This function should be called OnDeath for a player
void chr_Death_OnDeath(object oPC, object oLastHostileActor);

///////////////////////
// Function Implementation
//
void chr_Death_JumpToFugue(object oPC)
{
    location lFugue = fctn_GetFactionFugueLocation(fctn_GetFaction(oPC));
    AssignCommand (oPC, JumpToLocation (lFugue));
}

void chr_Death_OnDying_Bleed (object oPC)
{
    object oMod = GetModule();

    // Set at which -HitPoints death occurs
    int nDeathAt = -10;
    if (CHR_DEATH_CONSTITUTION_BONUS_ENABLED)
        nDeathAt -= GetAbilityModifier(ABILITY_CONSTITUTION, oPC);

    // Get current hitpoints
    int nCurrentHitPoints = GetCurrentHitPoints(oPC);
    if (nCurrentHitPoints <= 0 &&
        nCurrentHitPoints >= nDeathAt)
    {
        if (d100() <= (CHR_RECOVERY_CHANCE_BASE + (GetAbilityModifier(ABILITY_CONSTITUTION, oPC)) * CHR_RECOVERY_CHANCE_MODIFIER_CONSTITUTION))
        {
            int nHitpoints = GetCurrentHitPoints (oPC);
            int nHeal = abs (nHitpoints) + 1;
            effect eHeal = EffectHeal (nHeal);

            SendMessageToPC(oPC, CHR_RECOVERY_MESSAGE);
            ApplyEffectToObject (DURATION_TYPE_INSTANT, eHeal, oPC);
        }
        else if (GetLocalInt(oPC, "DelayBleed") == 1)  // This is for use of HCR Healkits and can be deleted if HCR Healkits are not in the game
        {
            if (d4() == 1)
                SetLocalInt(oPC, "DelayBleed", 0);
        }
        else
        {
            effect eDamage = EffectDamage(1, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY);
            ApplyEffectToObject (DURATION_TYPE_INSTANT, eDamage, oPC);
            SendMessageToPC (oPC, CHR_DYING_MESSAGE);
            int nVoiceChat = d6();
            switch (nVoiceChat)
            {
                case 1: PlayVoiceChat (VOICE_CHAT_PAIN1, oPC); break;
                case 2: PlayVoiceChat (VOICE_CHAT_PAIN2, oPC); break;
                case 3: PlayVoiceChat (VOICE_CHAT_PAIN3, oPC); break;
                case 4: PlayVoiceChat (VOICE_CHAT_HEALME, oPC); break;
                case 5: PlayVoiceChat (VOICE_CHAT_NEARDEATH, oPC); break;
                case 6: PlayVoiceChat (VOICE_CHAT_HELP, oPC); break;
            }

            // remember hitpoints instantly to prevent cheating
            string sName = GetName (oPC);
            string sPlayerName = GetPCPlayerName (oPC);

            // Set hit points for PC so we can remember them on join.
            SetLocalInt (oMod, sName + sPlayerName + "RHP", 1);
            SetLocalInt (oMod, sName + sPlayerName + "CHP", GetCurrentHitPoints (oPC));
        }

        DelayCommand(CHR_BLEED_INTERVAL, chr_Death_OnDying_Bleed(oPC));
    }
    else if (nCurrentHitPoints < 0)
    {
        effect eDeath = EffectDeath(FALSE, TRUE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oPC);
    }
}

void chr_Death_OnDeath(object oPC, object oLastHostileActor)
{
    string sPCName = GetName(oPC);

    // If the player has a henchman, remove it
    object oHenchman = GetHenchman(oPC);
    if (GetIsObjectValid(oHenchman))
        RemoveHenchman(oPC, oHenchman);

    int PvPDeath = FALSE;

    // If there is a noFugue Waypoint in the area, rez, jump there and return
    object oNoFugue = GetNearestObjectByTag("noFugue", oPC);
    if (GetIsObjectValid(oNoFugue))
    {
        DelayCommand(1.0, ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectResurrection (), oPC));
        DelayCommand(1.0, ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectHeal (GetMaxHitPoints (oPC)), oPC));
        AssignCommand(oPC, ClearAllActions());
        DelayCommand(0.2, AssignCommand(oPC, JumpToObject(oNoFugue)));
        DelayCommand(1.0, AssignCommand(oPC, ClearAllActions()));
        DelayCommand(1.2, AssignCommand(oPC, JumpToObject(oNoFugue)));
        DelayCommand(3.0, AssignCommand(oPC, ClearAllActions()));
        DelayCommand(3.2, AssignCommand(oPC, JumpToObject(oNoFugue)));
        return;
    }

    // Get the real Killer
    object oKiller;
    if (GetLocalObject(oPC, "LastHostileActor") == OBJECT_INVALID ||
        GetObjectType(oLastHostileActor) == OBJECT_TYPE_CREATURE)
       oKiller = oLastHostileActor;
    else
       oKiller = GetLocalObject(oPC, "LastHostileActor");

    // Find out if this death was PvP Related
    if ((GetLocalInt(oPC, "PvPDeath") == 1 ||
         GetIsPC(oKiller) ||
         GetIsPC(GetMaster(oKiller)) ||
         !GetIsObjectValid(oKiller) ||
         GetName(oKiller) == "") &&
        (AnphGetPlayerTeam(oPC) != AnphGetPlayerTeam(oKiller) ||
         (AnphGetPlayerTeam(oPC) != AnphGetPlayerTeam(GetMaster(oKiller)) &&
          GetIsPC(GetMaster(oKiller))
         )
        )
       )
    {
       PvPDeath = TRUE;
    }

    // A DM kill is never PvP Related
    if (GetIsDM(oKiller) ||
        GetIsDM(GetMaster(oKiller)))
        PvPDeath = FALSE;

    // Remove the local PVP Death Integer
    DeleteLocalInt(oPC, "PvPDeath");

    // Sanity Check on player's hitpoints
    int nDeathAt = -10;
    if (CHR_DEATH_CONSTITUTION_BONUS_ENABLED)
        nDeathAt -= GetAbilityModifier(ABILITY_CONSTITUTION, oPC);

    if (GetCurrentHitPoints(oPC) > nDeathAt)
        return;

    // Remember PCs Death Location
    location lDiedHere = GetLocation (oPC);
    SetLocalLocation (oPC, "DeathLocation", lDiedHere);

    // ensure we do not take xp more than once.
    int iDidXPLoss = GetLocalInt (oPC, "DidXPLoss");
    if (iDidXPLoss != 1)
        doXPLoss(oPC, oKiller, FALSE, OBJECT_INVALID, FALSE, PvPDeath);
    SetLocalInt (oPC, "DidXPLoss", 1);

    DelayCommand (12.0, DeleteLocalInt (oPC, "DidXPLoss"));

    // Send DMs a message
    if (GetName(oKiller) == "")
    {
        oKiller = oLastHostileActor;
        if (GetMaster(oKiller) != OBJECT_INVALID)
            oKiller = GetMaster(oKiller);
    }
    PvPDeath = GetIsPC(oKiller);

    string sMessage = "** " + sPCName + " was killed by " + GetName(oKiller) + " in " + GetName(GetArea(oKiller));
    SendMessageToAllDMs(sMessage);

    AnphCheckPK (oPC, oKiller);

    // Delete the last hostile actor
    DeleteLocalObject(oPC, "LastHostileActor");

    // Resurrect the player
    DelayCommand(1.0, ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectResurrection (), oPC));
    DelayCommand(1.0, ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectHeal (GetMaxHitPoints (oPC)), oPC));

    sql_SetPCDead(chr_GetPCID(oPC), TRUE);
    if (PvPDeath)
    {
        sql_LogPvPDeath(chr_GetPCID(oKiller), chr_GetPCID(oPC), GetLocation(oPC));
        NWNX_WebHook_SendWebHookHTTPS("discordapp.com", WEBHOOK_PVP, sMessage, "PvP Kill");
    }

    // Jump player to Fugue
    AssignCommand(oPC, ClearAllActions());
    DelayCommand(0.2, chr_Death_JumpToFugue(oPC));
    DelayCommand(1.0, AssignCommand(oPC, ClearAllActions()));
    DelayCommand(1.2, chr_Death_JumpToFugue(oPC));
    DelayCommand(3.0, AssignCommand(oPC, ClearAllActions()));
    DelayCommand(3.2, chr_Death_JumpToFugue(oPC));
}

