// Module Configuration

//------------------------------------------------------------------------------
// * Enable/Disable the use of NWNx for various systems in this module
//------------------------------------------------------------------------------
const int CI_MOD_USE_NWNX = FALSE;

//------------------------------------------------------------------------------
// * Set the various Bonus Limits
//------------------------------------------------------------------------------
const int CI_MOD_BONUSLIMIT_ABILITY                         = 36;   // Default: 12
const int CI_MOD_BONUSLIMIT_ATTACKBONUS                     = 60;   // Default: 20
const int CI_MOD_BONUSLIMIT_DAMAGEBONUS                     = 300;  // Default: 100
const int CI_MOD_BONUSLIMIT_SAVINGTHROW                     = 60;   // Default: 20
const int CI_MOD_BONUSLIMIT_SKILL                           = 150;  // Default: 50

//------------------------------------------------------------------------------
// * Set a spell override scirpt that is called before every spell in the game
//------------------------------------------------------------------------------
const string CI_MOD_OVERRIDE_SPELLSCRIPT                    = "esm_spuserdef";

//------------------------------------------------------------------------------
// * Force Use Magic Device Skillchecks, Default = FALSE except for GAME_DIFFICULTY_CORE_RULES+
// * If switched to TRUE, a rogue has to succeed in a UMD check against DC 25+SpellLevel
// * in order to use a scroll. See x2_pc_umdcheck.nss for details
//------------------------------------------------------------------------------
const int CI_MOD_ENABLE_UMD_SCROLLS                         = FALSE;

//------------------------------------------------------------------------------
// * Toggle on/off the Item Creation Feats, Default = O
// * Disable the Item Creation Feats that come with Hordes of the Underdark for the
// * module.
//------------------------------------------------------------------------------
const int CI_MOD_DISABLE_ITEM_CREATION_FEATS                = TRUE;

//------------------------------------------------------------------------------
// * Toggle Area of Effect Spell behaviour
// * If set to TRUE, AOE Spells will hurt NPCS that are neutral to the caster if they are
// * caught in the effect
//------------------------------------------------------------------------------
const int CI_MOD_AOE_HURT_NEUTRAL_NPCS                      = TRUE;

//------------------------------------------------------------------------------
// * For balancing reasons the crafting system will create 50 charges on a new wand
// * instead it will create 10 + casterlevel charges. if you want to be "hard core rules compliant"
// * 50 charges, enable thiis switch
//------------------------------------------------------------------------------
const int CI_MOD_ENABLE_CRAFT_WAND_50_CHARGES               = FALSE;

//------------------------------------------------------------------------------
// * Some epic spells, namely Hellball, do damage to the caster. We found this too confusing
// * in testing, so it was disabled. You can reactivate using this flag
//------------------------------------------------------------------------------
const int CI_MOD_EPIC_SPELLS_HURT_CASTER                    = TRUE;

//------------------------------------------------------------------------------
// * Deathless master touch is not supposed to affect creatures of size > large
// * but we do not check this condition by default to balance the fact that the slain
// * creature is not raised under the command of the pale master.
// * by setting this switch to TRUE, the ability will no longer effect creatures of
// * huge+ size.
//------------------------------------------------------------------------------
const int CI_MOD_SPELL_CORERULES_DMASTERTOUCH               = TRUE;

//------------------------------------------------------------------------------
// * By default, all characters can use the various poisons that can be found to poison their weapons if
// * they win a Dex check. Activating this flag will restrict the use of poison to chars with the UsePoison
// * feat only
//------------------------------------------------------------------------------
const int CI_MOD_RESTRICT_USE_POISON_TO_FEAT                = TRUE;

//------------------------------------------------------------------------------
// * Multiple Henchmen: By default, henchmen will never damage each other with AoE spells.
// * By activating this switch, henchmen will be able to damage each other with AoE spells
// * and potentially go on each other's throats.
// * Warning: Activating this switch has the potential of introducing game breaking bugs. Do
// *          not use on the official SoU campaign. Use at your own risk. Really, its dangerous!
//------------------------------------------------------------------------------
const int CI_MOD_ENABLE_MULTI_HENCH_AOE_DAMAGE              = FALSE;

//------------------------------------------------------------------------------
// * Spell Targeting: Pre Hordes of the underdark, in hardcore mode, creatures would not hurt each other
// * with their AOE spells if they were no PCs. Setting this switch to true, will activate the correct
// * behaviour. Activating this on older modules can break things, unless you know what you are doing!
//------------------------------------------------------------------------------
const int CI_MOD_ENABLE_NPC_AOE_HURT_ALLIES                 = FALSE;

//------------------------------------------------------------------------------
// * If set to TRUE, the Bebilith Ruin Armor ability is going to actually destroy
// * the armor it hits. Would be very annoying for players...
//------------------------------------------------------------------------------
const int CI_MOD_ENABLE_BEBILITH_RUIN_ARMOR                 = FALSE;

//------------------------------------------------------------------------------
// * Setting this switch to TRUE will make the Glyph of warding symbol disappear after 6 seconds, but
// * the glyph will stay active....
//------------------------------------------------------------------------------
const int CI_MOD_ENABLE_INVISIBLE_GLYPH_OF_WARDING          = FALSE;

//------------------------------------------------------------------------------
// * Setting this switch to TRUE will enable the allow NPCs running between waypoints using the WalkWaypoints
// * function to cross areas, like they did in the original NWN. This was changed in 1.30 to use only
// * waypoints in one area.
//------------------------------------------------------------------------------
const int CI_MOD_ENABLE_CROSSAREA_WALKWAYPOINTS             = TRUE;

//------------------------------------------------------------------------------
// * Setting this switch to TRUE will enable execution of tagbased item scripts
//------------------------------------------------------------------------------
const int CI_MOD_ENABLE_TAGBASED_SCRIPTS                    = FALSE;

//------------------------------------------------------------------------------
// * Setting thsi switch to TRUE will enable the XP2 Wandering Monster System
// * for this module (if you are using the default rest script and you have set
// * up the correct variables for each area
//------------------------------------------------------------------------------
const int CI_MOD_USE_XP2_RESTSYSTEM                         = FALSE;

//------------------------------------------------------------------------------
// * if this variable is set, the AI will not use Dispel Magic against harmfull AOE
// * spells.
//------------------------------------------------------------------------------
const int CI_MOD_DISABLE_AI_DISPEL_AOE                      = FALSE;

//------------------------------------------------------------------------------
// * Setting this variable to TRUE on the module will disable the call to the
// * random loot generation in most creatures' OnSpawn script.
//------------------------------------------------------------------------------
const int CI_MOD_NO_RANDOM_MONSTER_LOOT                     = TRUE;

//------------------------------------------------------------------------------
// * Setting this variable to TRUE on the module will disable built-in craft skills
//------------------------------------------------------------------------------
const int CI_MOD_DO_NOT_ALLOW_CRAFTSKILLS                   = TRUE;
