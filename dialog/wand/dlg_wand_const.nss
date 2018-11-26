///////////////////////////////////////////////////////////////////////////////
// wand_cfg
// written by: eyesolated
// written at: May 5, 2015
//
// Notes: Configuration File for the Wand Dialogue

const int CI_CONDITIONAL_ISDM = 1;

// AFK Constants
const int CI_ACTION_AFK_ACTIVATE                    = 100;
const int CI_ACTION_AFK_DEACTIVATE                  = 101;

// Emote Constants
const int CI_ACTION_EMOTE_FF_BOW                    = 200;
const int CI_ACTION_EMOTE_FF_DODGE_DUCK             = 201;
const int CI_ACTION_EMOTE_FF_DODGE_SIDE             = 202;
const int CI_ACTION_EMOTE_FF_DRINK                  = 203;
const int CI_ACTION_EMOTE_FF_GREETING               = 204;
// NOT WORKING AS INTENDED const int CI_ACTION_EMOTE_CUSTOM_SHAKEHEAD          = 205;  // ANIMATION_FIREFORGET_HEAD_TURN_LEFT & ANIMATION_FIREFORGET_HEAD_TURN_RIGHT
const int CI_ACTION_EMOTE_FF_PAUSE_BORED            = 206;
const int CI_ACTION_EMOTE_FF_PAUSE_SCRATCH_HEAD     = 207;
const int CI_ACTION_EMOTE_FF_READ                   = 208;
const int CI_ACTION_EMOTE_FF_SALUTE                 = 209;
const int CI_ACTION_EMOTE_FF_SPASM                  = 210;
const int CI_ACTION_EMOTE_FF_STEAL                  = 211;
const int CI_ACTION_EMOTE_FF_TAUNT                  = 212;
const int CI_ACTION_EMOTE_FF_VICTORY1               = 213;
const int CI_ACTION_EMOTE_FF_VICTORY2               = 214;
const int CI_ACTION_EMOTE_FF_VICTORY3               = 215;
const int CI_ACTION_EMOTE_LOOP_CONJURE1             = 216;
const int CI_ACTION_EMOTE_LOOP_CONJURE2             = 217;
const int CI_ACTION_EMOTE_LOOP_DEAD_BACK            = 218;
const int CI_ACTION_EMOTE_LOOP_DEAD_FRONT           = 219;
const int CI_ACTION_EMOTE_LOOP_GET_LOW              = 220;
const int CI_ACTION_EMOTE_LOOP_GET_MID              = 221;
const int CI_ACTION_EMOTE_LOOP_LISTEN               = 222;
const int CI_ACTION_EMOTE_LOOP_LOOK_FAR             = 223;
const int CI_ACTION_EMOTE_LOOP_MEDITATE             = 224;
const int CI_ACTION_EMOTE_LOOP_PAUSE                = 225;
const int CI_ACTION_EMOTE_LOOP_PAUSE_DRUNK          = 226;
const int CI_ACTION_EMOTE_LOOP_PAUSE_TIRED          = 227;
const int CI_ACTION_EMOTE_LOOP_PAUSE2               = 228;
const int CI_ACTION_EMOTE_LOOP_SIT_CROSS            = 229;
const int CI_ACTION_EMOTE_LOOP_SPASM                = 230;
const int CI_ACTION_EMOTE_LOOP_TALK_FORCEFUL        = 231;
const int CI_ACTION_EMOTE_LOOP_TALK_LAUGHING        = 232;
const int CI_ACTION_EMOTE_LOOP_TALK_NORMAL          = 233;
const int CI_ACTION_EMOTE_LOOP_TALK_PLEADING        = 234;
const int CI_ACTION_EMOTE_LOOP_WORSHIP              = 235;
const int CI_ACTION_EMOTE_CUSTOM_DANCE              = 236;
const int CI_ACTION_EMOTE_CUSTOM_SMOKE              = 237;

//////////////////////////////////////////////////////////
// Rolls

// Ability Checks
const int CI_ACTION_ABILITY_STRENGTH                = 400;
const int CI_ACTION_ABILITY_DEXTERITY               = 401;
const int CI_ACTION_ABILITY_CONSTITUTION            = 402;
const int CI_ACTION_ABILITY_WISDOM                  = 403;
const int CI_ACTION_ABILITY_INTELLIGENCE            = 404;
const int CI_ACTION_ABILITY_CHARISMA                = 405;

// Saving Throws
const int CI_ACTION_SAVINGTHROW_FORTITUDE           = 410;
const int CI_ACTION_SAVINGTHROW_REFLEX              = 411;
const int CI_ACTION_SAVINGTHROW_WILL                = 412;

// Die Rolls
const string CS_ROLLS_VAR_DIETYPE                   = "dlgw_dietype";
const int CI_CONDITION_ROLLS_NODIETYPE              = 420;
const int CI_CONDITION_ROLLS_PRIVACY_OVERRIDE       = 421;

const int CI_ACTION_ROLLS_DIE_D4                    = 420;
const int CI_ACTION_ROLLS_DIE_D6                    = 421;
const int CI_ACTION_ROLLS_DIE_D8                    = 422;
const int CI_ACTION_ROLLS_DIE_D10                   = 423;
const int CI_ACTION_ROLLS_DIE_D12                   = 424;
const int CI_ACTION_ROLLS_DIE_D20                   = 425;
const int CI_ACTION_ROLLS_DIE_D100                  = 426;
const int CI_ACTION_ROLLS_DICE_1                    = 427;
const int CI_ACTION_ROLLS_DICE_2                    = 428;
const int CI_ACTION_ROLLS_DICE_3                    = 429;
const int CI_ACTION_ROLLS_DICE_4                    = 430;
const int CI_ACTION_ROLLS_DICE_5                    = 431;
const int CI_ACTION_ROLLS_DICE_6                    = 432;
const int CI_ACTION_ROLLS_DICE_7                    = 433;
const int CI_ACTION_ROLLS_DICE_8                    = 434;
const int CI_ACTION_ROLLS_DICE_9                    = 435;
const int CI_ACTION_ROLLS_DICE_10                   = 436;
const int CI_ACTION_ROLLS_DIE_DELETE                = 437;

// Skill Checks
const int CI_ACTION_SKILLCHECK_ANIMALEMPATHY        = 450;
const int CI_ACTION_SKILLCHECK_APPRAISE             = 451;
const int CI_ACTION_SKILLCHECK_BLUFF                = 452;
const int CI_ACTION_SKILLCHECK_CONCENTRATION        = 453;
const int CI_ACTION_SKILLCHECK_CRAFT_ARMOR          = 454;
const int CI_ACTION_SKILLCHECK_CRAFT_TRAP           = 455;
const int CI_ACTION_SKILLCHECK_CRAFT_WEAPON         = 456;
const int CI_ACTION_SKILLCHECK_DISABLE_TRAP         = 457;
const int CI_ACTION_SKILLCHECK_DISCIPLINE           = 458;
const int CI_ACTION_SKILLCHECK_HEAL                 = 459;
const int CI_ACTION_SKILLCHECK_HIDE                 = 460;
const int CI_ACTION_SKILLCHECK_INTIMIDATE           = 461;
const int CI_ACTION_SKILLCHECK_LISTEN               = 462;
const int CI_ACTION_SKILLCHECK_LORE                 = 463;
const int CI_ACTION_SKILLCHECK_MOVE_SILENTLY        = 464;
const int CI_ACTION_SKILLCHECK_OPEN_LOCK            = 465;
const int CI_ACTION_SKILLCHECK_PARRY                = 466;
const int CI_ACTION_SKILLCHECK_PERFORM              = 467;
const int CI_ACTION_SKILLCHECK_PERSUADE             = 468;
const int CI_ACTION_SKILLCHECK_PICK_POCKET          = 469;
const int CI_ACTION_SKILLCHECK_RIDE                 = 470;
const int CI_ACTION_SKILLCHECK_SEARCH               = 471;
const int CI_ACTION_SKILLCHECK_SET_TRAP             = 472;
const int CI_ACTION_SKILLCHECK_SPELLCRAFT           = 473;
const int CI_ACTION_SKILLCHECK_SPOT                 = 474;
const int CI_ACTION_SKILLCHECK_TAUNT                = 475;
const int CI_ACTION_SKILLCHECK_TUMBLE               = 476;
const int CI_ACTION_SKILLCHECK_USE_MAGIC_DEVICE     = 477;

const int CI_ACTION_PRIVACY_SET_PRIVATE             = 490;
const int CI_ACTION_PRIVACY_SET_PUBLIC              = 491;


//////////////////////////////////////////////////////////
// Druid Wildshape

// Druid Conditionals
const int CI_CONDITIONAL_BROWNBEAR                              = 300;
const int CI_CONDITIONAL_PANTHER                                = 301;
const int CI_CONDITIONAL_WOLF                                   = 302;
const int CI_CONDITIONAL_BOAR                                   = 303;
const int CI_CONDITIONAL_BADGER                                 = 304;
const int CI_CONDITIONAL_IS_DRUID                               = 305;
const int CI_CONDITIONAL_HAS_DRUID_LEVELS_5                     = 306;
const int CI_CONDITIONAL_HAS_DRUID_LEVELS_ADDITIONAL_OPTIONS    = 307;

// Required level for additional (Dire) options
const int CI_REQUIRED_DRUID_LEVELS_FOR_ADDITONAL_OPTIONS        = 12;

// Druid Wildshape Constants
const string CS_DRUID_VAR_TARGETSPELL               = "dlgw_wilds_Trgt";
const string CS_DRUID_VAR_SHAPE                     = "dlgw_wilds_Shpe";
const int CI_ACTION_DRUID_POLYMORPH_SET_BROWNBEAR   = 300;
const int CI_ACTION_DRUID_POLYMORPH_SET_PANTHER     = 301;
const int CI_ACTION_DRUID_POLYMORPH_SET_WOLF        = 302;
const int CI_ACTION_DRUID_POLYMORPH_SET_BOAR        = 303;
const int CI_ACTION_DRUID_POLYMORPH_SET_BADGER      = 304;

const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_BADGER        = 310;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_BOAR          = 311;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_BROWNBEAR     = 312;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_CHICKEN       = 313;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_COW           = 314;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_DIREBADGER    = 315;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_DIREBOAR      = 316;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_DIREBROWNBEAR = 317;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_DIREPANTHER   = 318;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_DIREWOLF      = 319;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_DIRETIGER     = 320;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_GIANTSPIDER   = 321;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_PANTHER       = 322;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_PENGUIN       = 323;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_WOLF          = 324;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_WINTERWOLF    = 325;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_BLACK_BEAR    = 326;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_GRIZZLY_BEAR  = 327;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_POLAR_BEAR    = 328;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_WILDDOG       = 329;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_PUPPY         = 330;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_COUGAR        = 331;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_WHITETIGER    = 332;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_HOUSECAT      = 333;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_PIG           = 334;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_FALCON        = 335;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_RAVEN         = 336;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_BAT           = 337;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_DEER          = 338;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_WHITESTAG     = 339;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_RAT           = 340;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_MOUSE         = 341;      // needs CEP
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_RACOON        = 342;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_FERRET        = 343;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_SKUNK         = 344;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_SWAMPVIPER    = 345;      // needs CEP
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_TREANT        = 346;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_CHICKEN_OVERRIDE       = 347;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_COW_OVERRIDE           = 348;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_PENGUIN_OVERRIDE       = 349;
const int CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_WINTERWOLF_OVERRIDE    = 350;
