#include "util_inc"
#include "dbg_inc"
#include "spell_inc"
#include "nwnx_creature"
#include "nw_i0_spells"


object GetClosestMissileTarget(location lTarget)
{
    int nth = 1;
    object oTarget;

    while (1)
    {
        oTarget = GetNearestCreatureToLocation(CREATURE_TYPE_IS_ALIVE, TRUE, lTarget, nth++);
        if (oTarget == OBJECT_INVALID)
            return oTarget;

        if (GetPlotFlag(oTarget) || oTarget == OBJECT_SELF || !GetObjectSeen(oTarget) || !GetIsEnemy(oTarget))
            continue;

        if (GetDistanceBetweenLocations(lTarget, GetLocation(oTarget)) <= RADIUS_SIZE_GARGANTUAN)
            return oTarget;
        else
            return OBJECT_INVALID;
    }
    return OBJECT_INVALID;
}

struct missiles
{
    int vfx;
    int vfximpact;
    int count;
    int numdice;
    int whichdice;
    int dmgmod;
    int dmgtype;
    int continous;
};

struct missiles GetMissiles(int nSpellId, object oCaster, int nMetaMagic)
{
    struct missiles m;
    int nCasterLevel = GetCasterLevel(oCaster);

    switch (nSpellId)
    {
        case SPELL_MAGIC_MISSILE:
        case SPELL_SHADOW_CONJURATION_MAGIC_MISSILE:
            m.vfx = VFX_IMP_MIRV;
            m.vfximpact = VFX_IMP_MAGBLUE;
            m.count = min((1+nCasterLevel)/2, 5);
            m.numdice = 1;
            m.whichdice = 4;
            m.dmgmod = 1;
            m.dmgtype = DAMAGE_TYPE_MAGICAL;
            m.continous = 0;
            break;
        case SPELL_ISAACS_LESSER_MISSILE_STORM:
            m.vfx = VFX_IMP_MIRV;
            m.vfximpact = VFX_IMP_MAGBLUE;
            m.count = min(nCasterLevel, 10);
            m.numdice = 1;
            m.whichdice = 6;
            m.dmgmod = 0;
            m.dmgtype = DAMAGE_TYPE_MAGICAL;
            m.continous = 0;
            break;
        case SPELL_ISAACS_GREATER_MISSILE_STORM:
            m.vfx = VFX_IMP_MIRV;
            m.vfximpact = VFX_IMP_MAGBLUE;
            m.count = min(nCasterLevel, 20);
            m.numdice = 2;
            m.whichdice = 6;
            m.dmgmod = 0;
            m.dmgtype = DAMAGE_TYPE_MAGICAL;
            m.continous = 0;
            break;
        case SPELL_BALL_LIGHTNING:
            m.vfx = VFX_IMP_MIRV_ELECTRIC;
            m.vfximpact = VFX_IMP_LIGHTNING_S;
            m.count = min(nCasterLevel, 15);
            m.numdice = 1;
            m.whichdice = 6;
            m.dmgmod = 0;
            m.dmgtype = DAMAGE_TYPE_ELECTRICAL;
            m.continous = 0;
            break;
        case SPELL_FLAME_ARROW:
            m.vfx = VFX_IMP_MIRV_FLAME;
            m.vfximpact = VFX_IMP_FLAME_S;
            m.count = (3+nCasterLevel)/4;
            m.numdice = 4;
            m.whichdice = 6;
            m.dmgmod = 1;
            m.dmgtype = DAMAGE_TYPE_FIRE;
            m.continous = 0;
            break;
        case SPELL_FIREBRAND:
            m.vfx = VFX_IMP_MIRV_FLAME;
            m.vfximpact = VFX_IMP_FLAME_M;
            m.count = min(nCasterLevel, 15);
            m.numdice = 1;
            m.whichdice = 6;
            m.dmgmod = nCasterLevel;
            m.dmgtype = DAMAGE_TYPE_FIRE;
            m.continous = 0;
            break;
        case SPELL_MELFS_ACID_ARROW:
        case SPELL_GREATER_SHADOW_CONJURATION_ACID_ARROW:
            m.vfx = VFX_DUR_MIRV_ACID;
            m.vfximpact = VFX_IMP_ACID_L;
            m.count = 1;
            m.numdice = 3;
            m.whichdice = 6;
            m.dmgmod = 0;
            m.dmgtype = DAMAGE_TYPE_ACID;
            m.continous = 1 + (2+nCasterLevel)/3;
            break;
        default:
            dbg_ReportBug("Spell " + IntToString(nSpellId) + " calling into missile script", OBJECT_SELF);
            break;
    }

    return m;
}

int ApplyMissilesToTarget(object oCaster, object oTarget, struct missiles m, int nMetaMagic, int nMissiles=-1)
{
    if (nMissiles != -1)
        m.count = nMissiles;

    if (m.count == 0)
        return 0;

    effect eMissile = EffectVisualEffect(m.vfx);
    effect eVis = EffectVisualEffect(m.vfximpact);

    int nHits = 0, nCrits = 0, i, d;

    float fDist = GetDistanceBetween(oCaster, oTarget);
    float fDelay = fDist / (3.0 * log(fDist) + 2.0);

    int nCasterBonus = 0;

    int nSpellSchool = spell_GetSchool(GetSpellId());

    nCasterBonus += GetHasFeat(spell_GetSpellFocusFeat(nSpellSchool),       oCaster)*2;
    nCasterBonus += GetHasFeat(spell_GetSpellFocusFeat(nSpellSchool, TRUE), oCaster)*3;
    nCasterBonus += GetHasFeat(FEAT_COMBAT_CASTING, oCaster)*4;
    nCasterBonus += GetLocalInt(oCaster, "SPELL_MISSILE_ATTACK_BOUNS");

    int nOldBab = GetBaseAttackBonus(oCaster);
    NWNX_Creature_SetBaseAttackBonus(oCaster, nOldBab + nCasterBonus);

    for (i = 0; i < m.count; i++)
    {
        // try to hit.
        int nAttackResult = TouchAttackRanged(oTarget, TRUE);
        if (nAttackResult && !MyResistSpell(oCaster, oTarget, fDelay))
        {
            int nDamage = m.dmgmod;
            if (nMetaMagic == METAMAGIC_MAXIMIZE)
            {
                nDamage += m.numdice * m.whichdice;
            }
            else
            {
                for (d = 0; d < m.numdice; d++)
                    nDamage += Random(m.whichdice)+1;
            }
            if (nAttackResult == 2)
                nDamage *= 2;

            if (nMetaMagic == METAMAGIC_EMPOWER)
                nDamage = FloatToInt(1.5 * nDamage);

            //Apply the MIRV and damage effect
            effect eDam = EffectDamage(nDamage, m.dmgtype);
            DelayCommand(fDelay+0.1,     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
            DelayCommand(0.1,            ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
            DelayCommand(fDelay+0.1,     ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        }
        else if (nAttackResult > 0) // Resisted
        {
             ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
        }
        else // missed
        {
            vector v = GetPosition(oTarget);
            v.x +=  IntToFloat(Random(100)-50)/25.0;
            v.y +=  IntToFloat(Random(100)-50)/25.0;
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eMissile, Location(GetArea(oTarget), v, 0.0));
        }
        nHits += nAttackResult == 1;
        nCrits += nAttackResult == 2;
    }

    SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
    NWNX_Creature_SetBaseAttackBonus(oCaster, nOldBab);

    return nCrits << 16 | nHits;
}

void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    location lTarget = GetSpellTargetLocation();
    int nSpell = GetSpellId();
    int nMetaMagic = GetMetaMagicFeat();

    if (GetIsObjectValid(oTarget))
        oTarget = GetClosestMissileTarget(lTarget);
    if (oTarget == OBJECT_INVALID)
    {
        FloatingTextStringOnCreature("You cannot see a valid target in range", oCaster, FALSE);
        return;
    }

    struct missiles m = GetMissiles(nSpell, oCaster, nMetaMagic);

    if (GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
    {
        ApplyMissilesToTarget(oCaster, oTarget, m, nMetaMagic);
        return;
    }

    int nMissiles = m.count/2; // At least half of all missiles always go to primary target
    int nResults = ApplyMissilesToTarget(oCaster, oTarget, m, nMetaMagic, nMissiles);

    // For the rest, keep applying to nearby targets until we run out of missiles
    nMissiles = m.count - nMissiles;
    int nth = 1;
    while (nMissiles > 0)
    {
        oTarget = GetNearestCreatureToLocation(CREATURE_TYPE_IS_ALIVE, TRUE, lTarget, nth++);
        if (oTarget == OBJECT_INVALID)
        {
            nth = 1;
            continue;
        }

        if (GetPlotFlag(oTarget) || oTarget == oCaster || !GetObjectSeen(oTarget, oCaster) || !GetIsEnemy(oTarget, oCaster))
            continue;

        if (GetDistanceBetweenLocations(lTarget, GetLocation(oTarget)) <= RADIUS_SIZE_GARGANTUAN)
        {
            nResults += ApplyMissilesToTarget(oCaster, oTarget, m, nMetaMagic, 1);
            nMissiles--;
        }
        else
            nth = 1;
    }
    // Display the hit data
    int nHits = nResults & 0xFFFF;
    int nCrits = nResults >> 16;
    int nMisses = m.count - nHits - nCrits;
    string sHitString = "You scored ";
    int bCrits = nCrits > 0;
    int bHits = nHits > 0;
    int bMisses = nMisses > 0;
    if (bHits || bCrits)
    {
        sHitString += IntToString(nCrits + nHits);

        if (!bHits)
            sHitString += " criticals";
        else
            sHitString += " hits";

        if (bHits && bCrits)
            sHitString += " (" + IntToString(nCrits) + " criticals)";
    }
    if (bMisses)
    {
        if (bHits || bCrits)
            sHitString += " and ";
        sHitString += IntToString(nMisses) + " misses";
    }
    DelayCommand(2.0, SendMessageToPC(oCaster, sHitString));

}

