///////////////////////////////////////////////////////////////////////////////
// mod_ondeath
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: Placeholder for the module-wide OnPlayerDeath Event


///////////
// Includes
//
#include "datetime_inc"
#include "chr_inc"
#include "chr_death_inc"
#include "nwnx_object"
///////////////////////
// Function Declaration
//

////////////////
// Function Code
//

void main()
{
    object oPC = GetLastPlayerDied();
    object oLastHostileActor = GetLastHostileActor();

    if (GetLocalInt(oLastHostileActor, "FACTION_SPARRING_MODE"))
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
        NWNX_Object_SetCurrentHitPoints(oPC, 1);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,SupernaturalEffect(EffectKnockdown()),oPC,RoundsToSeconds(2));
        return;
    }

    // Drop the player's backpack if he isn't in a safe location
    object oNoFugue = GetNearestObjectByTag("noFugue", oPC);
    if (!GetIsObjectValid(oNoFugue))
        chr_Drop_Backpack(oPC);

    // Call Death
    chr_Death_OnDeath(oPC, oLastHostileActor);
}
