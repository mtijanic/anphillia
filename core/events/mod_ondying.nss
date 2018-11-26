///////////////////////////////////////////////////////////////////////////////
// mod_ondying
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: Placeholder for the module-wide OnPlayerDying Event

///////////
// Constants
//

///////////
// Includes
//
#include "anph_inc"
#include "chr_death_inc"

///////////////////////
// Function Declaration
//

//

////////////////
// Function Code
//


void main()
{
    object oPC = GetLastPlayerDying();

    // Get the hostile entity that killed oPC
    object oHostile = GetLastHostileActor(oPC);
    if (GetIsObjectValid(GetMaster(oHostile)))
        oHostile = GetMaster(oHostile);

    if (GetLocalInt(oHostile, "FACTION_SPARRING_MODE"))
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT,  EffectHeal(1 - GetCurrentHitPoints(oPC)),oPC);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,SupernaturalEffect(EffectKnockdown()),oPC,RoundsToSeconds(2));
        return;
    }

    // Remember the hostile actor
    SetLocalObject(oPC, "LastHostileActor", oHostile);
    if ((GetIsPC(oHostile) ||
         GetIsPC(GetMaster(oHostile)) ||
         !GetIsObjectValid(oHostile) ||
         GetName(oHostile) == ""
        )
       )
    {
        if (AnphGetPlayerTeam(oPC) != AnphGetPlayerTeam(oHostile))
            SetLocalInt(oPC, "PvPDeath", 1);
        else if (AnphGetPlayerTeam(oPC) != AnphGetPlayerTeam(GetMaster(oHostile)) &&
                 GetIsPC(GetMaster(oHostile)))
            SetLocalInt(oPC, "PvPDeath", 1);
    }

    // Unsummon a possible Associate of oPC
    object oFam = GetAssociate (ASSOCIATE_TYPE_FAMILIAR, oPC);
    if (GetIsObjectValid (oFam))
        RemoveSummonedAssociate (oPC, oFam);

    // Drop the player's backpack if he isn't in a safe location
    object oNoFugue = GetNearestObjectByTag("noFugue", oPC);
    if (!GetIsObjectValid(oNoFugue))
        chr_Drop_Backpack(oPC);

    int nth = 1;
    object oOther = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC, nth,
                                       CREATURE_TYPE_IS_ALIVE, TRUE);
    while (oOther != OBJECT_INVALID)
    {
        if (oOther != oPC)
        {
            if (GetDistanceBetween(oPC, oOther) <= 100.0)
            {
                effect eDR = EffectDamageReduction(10, DAMAGE_POWER_PLUS_ONE, 50);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDR, oPC, 30.0);
            }
            break;
        }
        oOther = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC, ++nth,
                                       CREATURE_TYPE_IS_ALIVE, TRUE);
    }

    // Start bleeding
    DelayCommand(CHR_BLEED_INTERVAL, chr_Death_OnDying_Bleed(oPC));
}
