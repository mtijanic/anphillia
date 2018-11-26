///////////////////////////////////////////////////////////////////////////////
// mod_onload
// written by: eyesolated
// written at: March 31, 2015
//
// Notes: This script is run at Module Load and initializes the different Systems
//        Dialogue System
#include "anph_cfg"
#include "mod_cfg"
#include "x2_inc_spellhook"
#include "nwnx"
#include "nwnx_admin"
#include "nwnx_events"
#include "nwnx_time"
#include "sql_inc"


void CreateObjectOnWaypoints(string sWaypoint, string sObject);

void main()
{
    object oMod = OBJECT_SELF;

    NWNX_Administration_SetModuleName("Anphillia " + ANPH_VERSION + " (" + NWNX_Time_GetSystemDate() +")");
    WriteTimestampedLogEntry ("*** Loading Anphillia " + ANPH_VERSION + " ***");
    AnphConfigSaveToLocalVars(oMod);

    ExecuteScript("sql_init", oMod);
    ExecuteScript("datetime_ini", oMod);

    ExecuteScript("dlg_ini", oMod);
    ExecuteScript("egs_ini", oMod);
    ExecuteScript("ip_names_ini", oMod);
    ExecuteScript("ip_ini", oMod);
    ExecuteScript("store_ini", oMod);
    ExecuteScript("lgs_ini", oMod);
    ExecuteScript("pat_ini", oMod);
    ExecuteScript("hc_defaults",oMod);

    // Initialize eE Encounters
    ExecuteScript("enc_constructor", oMod);
    ExecuteScript("enc_crypt_01", oMod);
    ExecuteScript("enc_spiderqueen", oMod);
    ExecuteScript("enc_banditchief", oMod);

    if (ANPH_CNR_ACTIVE)
    {
        // TODO clean up CNR
        ExecuteScript("cnr_module_oml", oMod);
        ExecuteScript("cnr_res_spawn", oMod);
    }
    ExecuteScript("weather_init", oMod);
    ExecuteScript("faction_init", oMod);

    // Load the XP tables
    SetModuleXPScale(0);
    ExecuteScript("xp_reload", oMod);


    // Set Bonus Limits
    SetAbilityBonusLimit(CI_MOD_BONUSLIMIT_ABILITY);
    SetAttackBonusLimit(CI_MOD_BONUSLIMIT_ATTACKBONUS);
    SetDamageBonusLimit(CI_MOD_BONUSLIMIT_DAMAGEBONUS);
    SetSavingThrowBonusLimit(CI_MOD_BONUSLIMIT_SAVINGTHROW);
    SetSkillBonusLimit(CI_MOD_BONUSLIMIT_SKILL);

    // Execute Module Configuration Switches (use mod_cfg for setup)
    SetLocalInt(oMod, "X2_L_DO_NOT_ALLOW_CRAFTSKILLS", CI_MOD_DO_NOT_ALLOW_CRAFTSKILLS);
    //SetLocalString(oMod, MODULE_VAR_OVERRIDE_SPELLSCRIPT, CI_MOD_OVERRIDE_SPELLSCRIPT);
    SetLocalInt(oMod, MODULE_SWITCH_ENABLE_UMD_SCROLLS, CI_MOD_ENABLE_UMD_SCROLLS);
    SetLocalInt(oMod, MODULE_SWITCH_DISABLE_ITEM_CREATION_FEATS, CI_MOD_DISABLE_ITEM_CREATION_FEATS);
    SetLocalInt(oMod, MODULE_SWITCH_AOE_HURT_NEUTRAL_NPCS, CI_MOD_AOE_HURT_NEUTRAL_NPCS);
    SetLocalInt(oMod, MODULE_SWITCH_ENABLE_CRAFT_WAND_50_CHARGES, CI_MOD_ENABLE_CRAFT_WAND_50_CHARGES);
    SetLocalInt(oMod, MODULE_SWITCH_EPIC_SPELLS_HURT_CASTER, CI_MOD_EPIC_SPELLS_HURT_CASTER);
    SetLocalInt(oMod, MODULE_SWITCH_SPELL_CORERULES_DMASTERTOUCH, CI_MOD_SPELL_CORERULES_DMASTERTOUCH);
    SetLocalInt(oMod, MODULE_SWITCH_RESTRICT_USE_POISON_TO_FEAT, CI_MOD_RESTRICT_USE_POISON_TO_FEAT);
    SetLocalInt(oMod, MODULE_SWITCH_ENABLE_MULTI_HENCH_AOE_DAMAGE, CI_MOD_ENABLE_MULTI_HENCH_AOE_DAMAGE);
    SetLocalInt(oMod, MODULE_SWITCH_ENABLE_NPC_AOE_HURT_ALLIES, CI_MOD_ENABLE_NPC_AOE_HURT_ALLIES);
    SetLocalInt(oMod, MODULE_SWITCH_ENABLE_BEBILITH_RUIN_ARMOR, CI_MOD_ENABLE_BEBILITH_RUIN_ARMOR);
    SetLocalInt(oMod, MODULE_SWITCH_ENABLE_INVISIBLE_GLYPH_OF_WARDING, CI_MOD_ENABLE_INVISIBLE_GLYPH_OF_WARDING);
    SetLocalInt(oMod, MODULE_SWITCH_ENABLE_CROSSAREA_WALKWAYPOINTS, CI_MOD_ENABLE_CROSSAREA_WALKWAYPOINTS);
    SetLocalInt(oMod, MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, CI_MOD_ENABLE_TAGBASED_SCRIPTS);
    SetLocalInt(oMod, MODULE_SWITCH_USE_XP2_RESTSYSTEM, CI_MOD_USE_XP2_RESTSYSTEM);
    SetLocalInt(oMod, MODULE_SWITCH_DISABLE_AI_DISPEL_AOE, CI_MOD_DISABLE_AI_DISPEL_AOE);
    SetLocalInt(oMod, MODULE_SWITCH_NO_RANDOM_MONSTER_LOOT, CI_MOD_NO_RANDOM_MONSTER_LOOT);

    SetLocalString(GetModule(), "X2_S_UD_SPELLSCRIPT", "spell_hook");

    /* Generate all Dream Items and placeables */
    CreateObjectOnWaypoints("dreamroleplaysign", "dreamrpsign");
    CreateObjectOnWaypoints("dreamupdatesign",   "dreamupdate");

    // Set up additional events
    NWNX_Events_SubscribeEvent("NWNX_ON_ENTER_STEALTH_AFTER", "xevent_stealth");
    NWNX_Events_SubscribeEvent("NWNX_ON_PARTY_ACCEPT_INVITATION_AFTER", "xevent_joinparty");
    NWNX_Events_SubscribeEvent("NWNX_ON_EXAMINE_OBJECT_BEFORE", "xevent_examine_b");
    NWNX_Events_SubscribeEvent("NWNX_ON_EXAMINE_OBJECT_AFTER", "xevent_examine_a");

    // Call UserDefined Script
    SignalEvent(oMod, EventUserDefined(1));
    WriteTimestampedLogEntry ("*** Anphillia Loaded Successfully ***");

    DelayCommand(10.0, ExecuteScript("_area_scripts", OBJECT_SELF));
}


void CreateObjectOnWaypoints(string sWaypoint, string sObject)
{
   int nSign = 0;
   object oSign = GetObjectByTag(sWaypoint, nSign);
   while (oSign != OBJECT_INVALID)
   {
      CreateObject(OBJECT_TYPE_PLACEABLE, sObject, GetLocation(oSign));
      nSign++;
      oSign = GetObjectByTag(sWaypoint, nSign);
   }
}

