/************************************************************************
 * script name  : eE_cfg
 * created by   : eyesolated
 * date         : 2011/6/1
 *
 * description  : Configuration file for  eyesolated Encounters
 *
 * changes      : 2011/6/1 - eyesolated - Initial creation
 ************************************************************************/

// Script settings.
// Set these to the OnDeath and OnPerception Scripts that
// you use for your creatures. Set these two to "" if you don't want eE
// to call these scripts
//
// Note: this needs to be empty for NWN: Enhanced Edition as eE sets references to the original scripts itself
const string eE_SCRIPT_CREATURE_ONDEATH             = ""; // "nw_c2_default7";
const string eE_SCRIPT_CREATURE_ONPERCEPTION        = ""; // "nw_c2_default2";
const string eE_SCRIPT_CREATURE_ONDAMAGED           = "";

// Set the following variable on a Creature / Placeable to restrict the range a player has to be in to deal damage to the entity
const string eE_VAR_RESTRICT_DAMAGERANGE            = "eE_RestrictDamageRange";
const int eE_RESTRICT_DAMAGERANGE_MELEE             = 1;
const int eE_RESTRICT_DAMAGERANGE_RANGE             = 2;

// Don't touch anything below this

// These are the various eE Scripts
const string eE_SCRIPT_ENCOUNTER_INITIALIZE         = "ee_enc_init";
const string eE_SCRIPT_ENCOUNTER_ONEXHAUSTED        = "ee_enc_onex";
const string eE_SCRIPT_ENCOUNTER_RESET              = "ee_enc_reset";
const string eE_SCRIPT_ENCOUNTER_END                = "ee_enc_end";
const string eE_SCRIPT_ENCOUNTER_START              = "ee_enc_start";
const string eE_SCRIPT_ENTITY_ONDEATH               = "ee_ent_ondeath";
const string eE_SCRIPT_ENTITY_ONSPAWN               = "ee_ent_onspawn";
const string eE_SCRIPT_ENTITY_ONDAMAGED             = "ee_ent_ondmg";
const string eE_SCRIPT_ENTITY_ONPERCEPTION          = "ee_ent_onperc";
const string eE_SCRIPT_EVENT_EXECUTE                = "ee_evt_execute";
const string eE_SCRIPT_EVENT_ONEXHAUSTED            = "ee_evt_onex";
const string eE_SCRIPT_EVENTGROUP_ONEXHAUSTED       = "ee_evtg_onex";
const string eE_SCRIPT_ENCOUNTER_WIPE               = "ee_enc_wipe";

// Don't touch this
const float eE_CFG_DELAY_CREATUREDESTROY            = 0.1f; // a 0.1f delay should be enough

// ResRefs
const string eE_BLUEPRINT_STORE                     = "ee_encounter_str";
const string eE_BLUEPRINT_BOOK                      = "ee_event";
