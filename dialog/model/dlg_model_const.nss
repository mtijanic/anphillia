///////////////////////////////////////////////////////////////////////////////
// wand_cfg
// written by: eyesolated
// written at: May 5, 2015
//
// Notes: Configuration File for the Wand Dialogue

// If the following string is not empty, an item with the given Tag is needed
// for every color change
const string CS_MODEL_ITEM_COLORING                         = "model_dye";
const string CS_MODEL_DYE_NAME                              = "Magical Dye";

// Defines the gold cost of a single change to an item of the corresponding type
// For armors, this value is multiplied by (AC value + 1)
// For shields, this value is multiplied by (AC value)
const int CI_MODEL_COST_PER_CHANGE_GOLD_ARMOR               = 5;
const int CI_MODEL_COST_PER_CHANGE_GOLD_CLOAK               = 30;
const int CI_MODEL_COST_PER_CHANGE_GOLD_HELMET              = 50;
const int CI_MODEL_COST_PER_CHANGE_GOLD_SHIELD              = 75;
const int CI_MODEL_COST_PER_CHANGE_GOLD_WEAPON              = 50;

// You can override the costs on specific Models by setting the following variables
// to anything but 0 on the model. A value of -1 means "0 Gold Cost"
const string CS_MODEL_COST_PER_CHANGE_GOLD_ARMOR_OVERRIDE   = "model_Gold_Armor";
const string CS_MODEL_COST_PER_CHANGE_GOLD_CLOAK_OVERRIDE   = "model_Gold_Cloak";
const string CS_MODEL_COST_PER_CHANGE_GOLD_HELMET_OVERRIDE  = "model_Gold_Helmet";
const string CS_MODEL_COST_PER_CHANGE_GOLD_SHIELD_OVERRIDE  = "model_Gold_Shield";
const string CS_MODEL_COST_PER_CHANGE_GOLD_WEAPON_OVERRIDE  = "model_Gold_Weapon";

// You can disable the Dye Requirment on specific Models by setting the following
// variable to 1 on the model.
const string CS_MODEL_COST_NODYE                            = "model_NoDye";

const float CF_MODEL_DELAY_DESTROYWEAPON                    = 0.2f;

const string CS_DEF_INVISIBLEWEAPON                         = "model_invright";
const string CS_DEF_ARRAY_ARMOR                             = "model_arr_armor_";
const string CS_DEF_ARRAY_ARMOR_PART                        = "model_arr_part_";
const string CS_DEF_ARRAY_CHANGES                           = "model_arr_chg";
const string CS_DEF_ARRAY_COLORS                            = "model_arr_col";
const string CS_DEF_ARRAY_ANALYZEREFERENCE                  = "model_analyzeref";
const string CS_DEF_ARRAY_CHANGES_ANALYZE                   = "model_arr_chgana";
const string CS_DEF_ARRAY_COLORS_ANALYZE                    = "model_arr_colana";
const string CS_DEF_VAR_CHANGE                              = "model_chg_";
const string CS_DEF_VAR_COLOR                               = "model_col_";
const string CS_DEF_VAR_CHANGE_ANALYZE                      = "model_chgana_";
const string CS_DEF_VAR_COLOR_ANALYZE                       = "model_colana_";
const string CS_DEF_VAR_APPEARANCE_ORIGINAL                 = "model_OAppr_";
const string CS_DEF_VAR_COLOR_ORIGINAL                      = "model_OCol_";

const int CI_DEF_COLOR_INDEX_CLOTHLEATHER                   = 1;
const int CI_DEF_COLOR_INDEX_METAL                          = 2;

const int CI_DEF_ARMOR_ALL                                  = -5;

const int CI_DEF_ARMOR_SAME_BICEPS                          = -10;
const int CI_DEF_ARMOR_SAME_FEET                            = -11;
const int CI_DEF_ARMOR_SAME_FOREARMS                        = -12;
const int CI_DEF_ARMOR_SAME_HANDS                           = -13;
const int CI_DEF_ARMOR_SAME_SHINS                           = -14;
const int CI_DEF_ARMOR_SAME_SHOULDERS                       = -15;
const int CI_DEF_ARMOR_SAME_THIGHS                          = -16;

const int CI_CONDITION_MODEL_HAS_HELMET                     = 100;
const int CI_CONDITION_MODEL_HAS_ARMOR                      = 101;
const int CI_CONDITION_MODEL_HAS_WEAPON_LEFT                = 102;
const int CI_CONDITION_MODEL_HAS_WEAPON_RIGHT               = 103;
const int CI_CONDITION_MODEL_HAS_SHIELD                     = 104;
const int CI_CONDITION_MODEL_HAS_CLOAK                      = 105;

const int CI_CONDITION_PC_HAS_CLOAK                         = 201;
const int CI_CONDITION_PC_HAS_ARMOR                         = 202;
const int CI_CONDITION_PC_HAS_HELMET                        = 203;
const int CI_CONDITION_PC_HAS_SHIELD                        = 204;
const int CI_CONDITION_PC_HAS_WEAPON_LEFT                   = 205;
const int CI_CONDITION_PC_HAS_WEAPON_RIGHT                  = 206;

const int CI_CONDITION_OVERRIDE_BUY_ALL                     = 220;
const int CI_CONDITION_OVERRIDE_BUY_CLOAK                   = 221;
const int CI_CONDITION_OVERRIDE_BUY_ARMOR                   = 222;
const int CI_CONDITION_OVERRIDE_BUY_HELMET                  = 223;
const int CI_CONDITION_OVERRIDE_BUY_SHIELD                  = 224;
const int CI_CONDITION_OVERRIDE_BUY_WEAPON_LEFT             = 225;
const int CI_CONDITION_OVERRIDE_BUY_WEAPON_RIGHT            = 226;

const int CI_CONDITION_OVERRIDE_BUY_DESIGN_ALL              = 230;
const int CI_CONDITION_OVERRIDE_BUY_DESIGN_CLOAK            = 231;
const int CI_CONDITION_OVERRIDE_BUY_DESIGN_ARMOR            = 232;
const int CI_CONDITION_OVERRIDE_BUY_DESIGN_HELMET           = 233;
const int CI_CONDITION_OVERRIDE_BUY_DESIGN_SHIELD           = 234;
const int CI_CONDITION_OVERRIDE_BUY_DESIGN_WEAPON_LEFT      = 235;
const int CI_CONDITION_OVERRIDE_BUY_DESIGN_WEAPON_RIGHT     = 236;

const int CI_CONDITION_OVERRIDE_CHANGE_ITEM                 = 250;
const int CI_CONDITION_OVERRIDE_REMOVE_ITEM                 = 251;

const int CI_CONDITION_SELECTED_NOT_SHIELD                  = 300;
const int CI_CONDITION_SELECTED_NO_INDEX                    = 301;
const int CI_CONDITION_SELECTED_INDEX                       = 302;
const int CI_CONDITION_SELECTED_ARMOR                       = 303;
const int CI_CONDITION_SELECTED_WEAPON_LEFT                 = 304;
const int CI_CONDITION_SELECTED_WEAPON_RIGHT                = 305;
const int CI_CONDITION_SELECTED_WEAPON                      = 306;
const int CI_CONDITION_SELECTED_NOWEAPON                    = 307;
const int CI_CONDITION_SELECTED_ARMOR_PART_ALL              = 308;
const int CI_CONDITION_NOTSELECTED_ARMOR_PART_ALL           = 309;
const int CI_CONDITION_SELECTED_ARMORPART_SPECIFIC          = 310;
const int CI_CONDITION_NOTSELECTED_ARMORPART_SPECIFIC       = 311;
const int CI_CONDITION_SELECTED_NOWEAPON_OVERRIDE_COLOR     = 312;

const int CI_CONDITION_ARMOR_SAME_BICEPS                    = 400;
const int CI_CONDITION_ARMOR_SAME_FEET                      = 401;
const int CI_CONDITION_ARMOR_SAME_FOREARMS                  = 402;
const int CI_CONDITION_ARMOR_SAME_HANDS                     = 403;
const int CI_CONDITION_ARMOR_SAME_SHINS                     = 404;
const int CI_CONDITION_ARMOR_SAME_SHOULDERS                 = 405;
const int CI_CONDITION_ARMOR_SAME_THIGHS                    = 406;

const int CI_CONDITION_COLOR_TYPE_NOTSELECTED               = 500;
const int CI_CONDITION_COLOR_NONMETAL                       = 501;
const int CI_CONDITION_COLOR_METAL                          = 502;
const int CI_CONDITION_COLOR_WEAPON                         = 503;

const int CI_ACTION_MODEL_INITIALIZE                        = 1;
const int CI_ACTION_MODEL_CLONE_APPEARANCE                  = 99;
const int CI_ACTION_MODEL_CHANGE_HELMET                     = 100;
const int CI_ACTION_MODEL_CHANGE_ARMOR                      = 101;
const int CI_ACTION_MODEL_CHANGE_WEAPON_LEFT                = 102;
const int CI_ACTION_MODEL_CHANGE_WEAPON_RIGHT               = 103;
const int CI_ACTION_MODEL_CHANGE_SHIELD                     = 104;
const int CI_ACTION_MODEL_CHANGE_CLOAK                      = 105;

const int CI_ACTION_MODEL_COPY_ALL                          = 200;
const int CI_ACTION_MODEL_COPY_CLOAK                        = 201;
const int CI_ACTION_MODEL_COPY_ARMOR                        = 202;
const int CI_ACTION_MODEL_COPY_HELMET                       = 203;
const int CI_ACTION_MODEL_COPY_SHIELD                       = 204;
const int CI_ACTION_MODEL_COPY_WEAPON_LEFT                  = 205;
const int CI_ACTION_MODEL_COPY_WEAPON_RIGHT                 = 206;

const int CI_ACTION_MODEL_REMOVE_ITEM                       = 207;
const int CI_ACTION_MODEL_REMOVE_ALL                        = 208;
const int CI_ACTION_MODEL_REMOVE_CLOAK                      = 209;
const int CI_ACTION_MODEL_REMOVE_ARMOR                      = 210;
const int CI_ACTION_MODEL_REMOVE_HELMET                     = 211;
const int CI_ACTION_MODEL_REMOVE_SHIELD                     = 212;
const int CI_ACTION_MODEL_REMOVE_WEAPON_LEFT                = 213;
const int CI_ACTION_MODEL_REMOVE_WEAPON_RIGHT               = 214;

const int CI_ACTION_MODEL_APPEARANCE_NEXT                   = 220;
const int CI_ACTION_MODEL_APPEARANCE_PREVIOUS               = 221;

const int CI_ACTION_REMOVE_SELECTION_ITEM                   = 250;
const int CI_ACTION_REMOVE_SELECTION_INDEX                  = 251;

const int CI_ACTION_MODEL_CHANGE_ARMOR_BELT                 = 400;
const int CI_ACTION_MODEL_CHANGE_ARMOR_BICEPS_LEFT          = 401;
const int CI_ACTION_MODEL_CHANGE_ARMOR_BICEPS_RIGHT         = 402;
const int CI_ACTION_MODEL_CHANGE_ARMOR_BICEPS_BOTH          = 403;
const int CI_ACTION_MODEL_CHANGE_ARMOR_FOOT_LEFT            = 404;
const int CI_ACTION_MODEL_CHANGE_ARMOR_FOOT_RIGHT           = 405;
const int CI_ACTION_MODEL_CHANGE_ARMOR_FOOT_BOTH            = 406;
const int CI_ACTION_MODEL_CHANGE_ARMOR_FOREARM_LEFT         = 407;
const int CI_ACTION_MODEL_CHANGE_ARMOR_FOREARM_RIGHT        = 408;
const int CI_ACTION_MODEL_CHANGE_ARMOR_FOREARM_BOTH         = 409;
const int CI_ACTION_MODEL_CHANGE_ARMOR_HAND_LEFT            = 410;
const int CI_ACTION_MODEL_CHANGE_ARMOR_HAND_RIGHT           = 411;
const int CI_ACTION_MODEL_CHANGE_ARMOR_HAND_BOTH            = 412;
const int CI_ACTION_MODEL_CHANGE_ARMOR_NECK                 = 413;
const int CI_ACTION_MODEL_CHANGE_ARMOR_PELVIS               = 414;
const int CI_ACTION_MODEL_CHANGE_ARMOR_ROBE                 = 415;
const int CI_ACTION_MODEL_CHANGE_ARMOR_SHIN_LEFT            = 416;
const int CI_ACTION_MODEL_CHANGE_ARMOR_SHIN_RIGHT           = 417;
const int CI_ACTION_MODEL_CHANGE_ARMOR_SHIN_BOTH            = 418;
const int CI_ACTION_MODEL_CHANGE_ARMOR_SHOULDER_LEFT        = 419;
const int CI_ACTION_MODEL_CHANGE_ARMOR_SHOULDER_RIGHT       = 420;
const int CI_ACTION_MODEL_CHANGE_ARMOR_SHOULDER_BOTH        = 421;
const int CI_ACTION_MODEL_CHANGE_ARMOR_THIGH_LEFT           = 422;
const int CI_ACTION_MODEL_CHANGE_ARMOR_THIGH_RIGHT          = 423;
const int CI_ACTION_MODEL_CHANGE_ARMOR_THIGH_BOTH           = 424;
const int CI_ACTION_MODEL_CHANGE_ARMOR_TORSO                = 425;
const int CI_ACTION_MODEL_CHANGE_ARMOR_ALL                  = 450;

const int CI_ACTION_MODEL_CHANGE_WEAPON_BOTTOM              = 500;
const int CI_ACTION_MODEL_CHANGE_WEAPON_MIDDLE              = 501;
const int CI_ACTION_MODEL_CHANGE_WEAPON_TOP                 = 502;

const int CI_ACTION_MODEL_SELECT_COLOR_ARMOR_CLOTH1         = 600;
const int CI_ACTION_MODEL_SELECT_COLOR_ARMOR_CLOTH2         = 601;
const int CI_ACTION_MODEL_SELECT_COLOR_ARMOR_LEATHER1       = 602;
const int CI_ACTION_MODEL_SELECT_COLOR_ARMOR_LEATHER2       = 603;
const int CI_ACTION_MODEL_SELECT_COLOR_ARMOR_METAL1         = 604;
const int CI_ACTION_MODEL_SELECT_COLOR_ARMOR_METAL2         = 605;

const int CI_ACTION_REMOVE_COLOR_TYPE                       = 650;

const int CI_ACTION_COLOR_WEAPON_1                          = 700;
const int CI_ACTION_COLOR_WEAPON_2                          = 701;
const int CI_ACTION_COLOR_WEAPON_3                          = 702;
const int CI_ACTION_COLOR_WEAPON_4                          = 703;

const int CI_ACTION_MODEL_REMOVE_INDIVIDUAL_COLOR           = 800;
const int CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_NEXT        = 801;
const int CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_PREVIOUS    = 802;
const int CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_ORIGINAL    = 803;

const int CI_ACTION_BUY_ALL                                 = 900;
const int CI_ACTION_BUY_CLOAK                               = 901;
const int CI_ACTION_BUY_ARMOR                               = 902;
const int CI_ACTION_BUY_HELMET                              = 903;
const int CI_ACTION_BUY_SHIELD                              = 904;
const int CI_ACTION_BUY_WEAPON_LEFT                         = 905;
const int CI_ACTION_BUY_WEAPON_RIGHT                        = 906;

const int CI_ACTION_BUY_DESIGN_ALL                          = 910;
const int CI_ACTION_BUY_DESIGN_CLOAK                        = 911;
const int CI_ACTION_BUY_DESIGN_ARMOR                        = 912;
const int CI_ACTION_BUY_DESIGN_HELMET                       = 913;
const int CI_ACTION_BUY_DESIGN_SHIELD                       = 914;
const int CI_ACTION_BUY_DESIGN_WEAPON_LEFT                  = 915;
const int CI_ACTION_BUY_DESIGN_WEAPON_RIGHT                 = 916;

const int CI_ACTION_APPEARANCE_TYPE_DWARF                   = 1000;
const int CI_ACTION_APPEARANCE_TYPE_ELF                     = 1001;
const int CI_ACTION_APPEARANCE_TYPE_GNOME                   = 1002;
const int CI_ACTION_APPEARANCE_TYPE_HALFELF                 = 1003;
const int CI_ACTION_APPEARANCE_TYPE_HALFLING                = 1004;
const int CI_ACTION_APPEARANCE_TYPE_HALFORC                 = 1005;
const int CI_ACTION_APPEARANCE_TYPE_HUMAN                   = 1006;


const int CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_CLOTHLEATHER= 10000;
const int CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_METAL       = 15000;

// Colors
string GetColorName(int nIndex, int nColorID)
{
    switch (nColorID)
    {
        case 0: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Bleach"; else return "Bleach"; break;
        case 1: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Light Brown"; else return "Light Iron"; break;
        case 2: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Brown"; else return "Dark Iron"; break;
        case 3: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Brown"; else return "Black"; break;
        case 4: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Bright Ruddy Brown"; else return "Bright Steel"; break;
        case 5: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Light Ruddy Brown"; else return "Light Steel"; break;
        case 6: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Ruddy Brown"; else return "Steel"; break;
        case 7: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Ruddy Brown"; else return "Dark Steel"; break;
        case 8: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Bright Tan"; else return "Bright Gold"; break;
        case 9: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Light Tan"; else return "Light Gold"; break;
        case 10: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Tan"; else return "Gold"; break;
        case 11: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Tan"; else return "Dark Gold"; break;
        case 12: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Bright Chocolate Brown"; else return "Bright Brass"; break;
        case 13: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Light Choclate Brown"; else return "Light Brass"; break;
        case 14: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Chocolate Brown"; else return "Brass"; break;
        case 15: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Chocolate Brown"; else return "Dark Brass"; break;
        case 16: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Bright Olive Green"; else return "Bright Copper"; break;
        case 17: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Light Olive Green"; else return "Light Copper"; break;
        case 18: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Olive Green"; else return "Copper"; break;
        case 19: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Olive Green"; else return "Dark Copper"; break;
        case 20: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Light Grey"; else return "Bright Bronze"; break;
        case 21: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Grey"; else return "Light Bronze"; break;
        case 22: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Grey"; else return "Bronze"; break;
        case 23: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Black"; else return "Dark Bronze"; break;
        case 24: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Bright Navy Blue"; else return "Bright Red"; break;
        case 25: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Navy Blue"; else return "Red"; break;
        case 26: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Bright Blue"; else return "Light Red"; break;
        case 27: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Blue"; else return "Dark Red"; break;
        case 28: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Bright Turquoise"; else return "Bright Purple"; break;
        case 29: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Turquoise"; else return "Purple"; break;
        case 30: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Bright Green"; else return "Light Purple"; break;
        case 31: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Green"; else return "Dark Purple"; break;
        case 32: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Yellow"; else return "Bright Navy Blue"; break;
        case 33: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Gold"; else return "Navy Blue"; break;
        case 34: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Bright Orange"; else return "Light Navy Blue"; break;
        case 35: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Orange"; else return "Dark Navy Blue"; break;
        case 36: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Bright Red"; else return "Bright Turquoise"; break;
        case 37: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Red"; else return "Turquoise"; break;
        case 38: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Bright Pink"; else return "Light Turquoise"; break;
        case 39: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Pink"; else return "Dark Turquoise"; break;
        case 40: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Bright Purple"; else return "Bright Green"; break;
        case 41: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Purple"; else return "Green"; break;
        case 42: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Bright Violet"; else return "Light Green"; break;
        case 43: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Violet"; else return "Dark Green"; break;
        case 44: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Grey Silk"; else return "Bright Olive Green"; break;
        case 45: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Black Silk"; else return "Olive Green"; break;
        case 46: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Navy Blue Silk"; else return "Bright Sage"; break;
        case 47: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Blue Silk"; else return "Dark Sage"; break;
        case 48: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Turquoise Silk"; else return "Rainbow"; break;
        case 49: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Green Silk"; else return "Dark Rainbow"; break;
        case 50: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Gold Silk"; else return "Rusted Light Iron"; break;
        case 51: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Orange Silk"; else return "Heavily Rusted Light Iron"; break;
        case 52: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Red Silk"; else return "Rusted Dark Iron"; break;
        case 53: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Pink Silk"; else return "Heavily Rusted Dark Iron"; break;
        case 54: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Purple Silk"; else return "Worn Light Steel"; break;
        case 55: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Violet Silk"; else return "Worn Steel"; break;
        case 56: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Light Grey Silk"; else return "Polished Silver"; break;
        case 57: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Metallic Black"; else return "Polished Black Steel"; break;
        case 58: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Metallic Gold"; else return "Polished Gold"; break;
        case 59: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Metallic Copper"; else return "Polished Copper"; break;
        case 60: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Metallic Steel"; else return "Polished Steel"; break;
        case 61: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Metallic Platinum"; else return "Polished Platinum"; break;
        case 62: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Stark White"; else return "Stark White"; break;
        case 63: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Midnight Black"; else return "Midnight Black"; break;
        case 64: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Wet Brick"; else return "Sanguine Red"; break;
        case 65: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Riverbank Brown"; else return "Chocolate Steel"; break;
        case 66: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Mustard"; else return "Amber Gold"; break;
        case 67: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Moss"; else return "Smoky Sage"; break;
        case 68: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Forest Green"; else return "Emerald Steel"; break;
        case 69: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Forest Drab"; else return "Moonlight Moss"; break;
        case 70: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Indigo Purple"; else return "Elysian Violet"; break;
        case 71: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Violet Shadow"; else return "Stormreaver Gray"; break;
        case 72: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Orchid"; else return "Jechran Purple"; break;
        case 73: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Orchid Shadow"; else return "Legionnaire Steel"; break;
        case 74: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Acorn Brown"; else return "Burnished Bronze"; break;
        case 75: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Pale Brown"; else return "Cold Iron"; break;
        case 76: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Sea Green"; else return "Bug Green"; break;
        case 77: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Aqua Shadow"; else return "Drotid Steel"; break;
        case 78: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Storm Blue"; else return "Kurathene Blue"; break;
        case 79: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Charcoal"; else return "Granite"; break;
        case 80: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "T'Nanshi Green"; else return "Fern Steel"; break;
        case 81: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Pine"; else return "Dull Steel"; break;
        case 82: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Azure"; else return "Skymetal"; break;
        case 83: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Azure Shadow"; else return "Iron"; break;
        case 84: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Raw Umber"; else return "Tarnished Silver"; break;
        case 85: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Umber Shadow"; else return "Gnomish Steel"; break;
        case 86: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Mud Brown"; else return "Deglosian Silver"; break;
        case 87: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Walnut"; else return "Tarnished Bronze"; break;
        case 88: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Scarlet"; else return "Ember Red"; break;
        case 89: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Crimson"; else return "Demon Red"; break;
        case 90: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Blood Red"; else return "Blood Red"; break;
        case 91: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Burgundy"; else return "Crimson"; break;
        case 92: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Goldenrod"; else return "Glorious Gold"; break;
        case 93: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Goldenrod"; else return "Mustard Gold"; break;
        case 94: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Rich Ochre"; else return "Bandit Bronze"; break;
        case 95: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Old Leather"; else return "Woodsman Bronze"; break;
        case 96: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Mauve"; else return "Lizard Scale Pink"; break;
        case 97: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Mauve"; else return "Eggplant"; break;
        case 98: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Maroon"; else return "Merlot"; break;
        case 99: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Wine Red"; else return "Swamp Purple"; break;
        case 100: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Coral"; else return "Brick Red"; break;
        case 101: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Firebrick Red"; else return "Fire Brick Red"; break;
        case 102: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Firebrick"; else return "Steak"; break;
        case 103: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Red"; else return "Old Crimson Steel"; break;
        case 104: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Ferrell Green"; else return "Slime Green"; break;
        case 105: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Green"; else return "Dark Slime Green"; break;
        case 106: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Oak Green"; else return "Forest Steel"; break;
        case 107: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Pine Green"; else return "Deep Forest Steel"; break;
        case 108: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Light Swamp Green"; else return "Verdigris Silver"; break;
        case 109: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Swamp Green"; else return "Dark Verdigris Silver"; break;
        case 110: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "M'Chekian Olive"; else return "Olive Drab"; break;
        case 111: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "M'Chekian Dark Olive"; else return "Dark Olive Drab"; break;
        case 112: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Deglossian Ash Green"; else return "Derrington Steel"; break;
        case 113: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Deglossian Dark Ash Green"; else return "Bazgamph Iron"; break;
        case 114: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Faded Sepia"; else return "Smoky Steel"; break;
        case 115: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Deep Earth"; else return "Underdark Iron"; break;
        case 116: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Khaki"; else return "Burnished Copper"; break;
        case 117: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Sienna"; else return "Earthmetal"; break;
        case 118: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Sienna"; else return "Russet"; break;
        case 119: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Mahogany"; else return "Deep Brown"; break;
        case 120: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Sand"; else return "Ancient Silver"; break;
        case 121: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Driftwood"; else return "Smoky Silver"; break;
        case 122: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Bark"; else return "Journeyman's Steel"; break;
        case 123: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Bark"; else return "Coldforged Iron"; break;
        case 124: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Ash"; else return "Stormmetal"; break;
        case 125: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Smoke"; else return "Infantry Steel"; break;
        case 126: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Light Bistre"; else return "Shadow Steel"; break;
        case 127: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Bistre"; else return "Midnight Steel"; break;
        case 128: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Wheat"; else return "Champagne Silver"; break;
        case 129: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Buckskin"; else return "Harvest Bronze"; break;
        case 130: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Saddle Brown"; else return "Chocolate Bronze"; break;
        case 131: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Autumn Brown"; else return "Deep Chocolate Bronze"; break;
        case 132: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Slate"; else return "Slate Steel"; break;
        case 133: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Slate"; else return "Smoky Slate Steel"; break;
        case 134: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Midnight Ash"; else return "Shadow Slate"; break;
        case 135: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Midnight Smoke"; else return "Navy Steel"; break;
        case 136: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Royal Blue"; else return "Bright Cobalt"; break;
        case 137: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Cobalt"; else return "Cobalt"; break;
        case 138: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Ingoren Blue"; else return "Visimontium Blue"; break;
        case 139: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Indigo Blue"; else return "Twilight Steel"; break;
        case 140: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Cyan Shadow"; else return "Aqua"; break;
        case 141: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Light Teal"; else return "Dark Aqua"; break;
        case 142: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Teal"; else return "Teal Steel"; break;
        case 143: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Teal Shadow"; else return "Dark Teal Steel"; break;
        case 144: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Magenta"; else return "Heliotrope Pink"; break;
        case 145: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Magenta"; else return "Grape"; break;
        case 146: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Grape"; else return "Imperial Purple"; break;
        case 147: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Imperial Purple"; else return "Deep Purple"; break;
        case 148: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Cornflower Blue"; else return "Cornflower Steel"; break;
        case 149: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Steele Blue"; else return "Royal Blue"; break;
        case 150: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Pale Turquoise"; else return "Aquamarine"; break;
        case 151: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Aquamarine"; else return "Deep Turquoise"; break;
        case 152: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Sapling Green"; else return "Light Ferrell Green"; break;
        case 153: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Emerald"; else return "Dark Ferrell Green"; break;
        case 154: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Honey"; else return "Old Bronze"; break;
        case 155: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Honey"; else return "Rich Bronze"; break;
        case 156: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Desert Brown"; else return "Galdosian Copper"; break;
        case 157: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Ash Brown"; else return "Rich Copper"; break;
        case 158: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Pale Rust"; else return "Chestnut Copper"; break;
        case 159: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Rust"; else return "Rust"; break;
        case 160: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Lilac"; else return "Lilac"; break;
        case 161: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Mauve Shadow"; else return "Mauve"; break;
        case 162: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Burnt Sienna"; else return "Puce"; break;
        case 163: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Dark Violet"; else return "Violet-Eggplant"; break;
        case 164: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Silver Gray"; else return "Mithril"; break;
        case 165: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Kurathene Steel Blue"; else return "Sunset Steel"; break;
        case 166: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Snow"; else return "Ice"; break;
        case 167: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Midnight Camouflage"; else return "Hunter Green"; break;
        case 168: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Drotid Tan"; else return "Cheap Silver"; break;
        case 169: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Viridian Shadow"; else return "Summerleaf Slate"; break;
        case 170: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Corsair Purple"; else return "Indigo Smoke"; break;
        case 171: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Shadow"; else return "Dark Slate Grey"; break;
        case 172: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Lizard Belly Olive"; else return "Fish Belly Green"; break;
        case 173: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Russet Shadow"; else return "Indigo Shadow"; break;
        case 174: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Cinnamon"; else return "Brown"; break;
        case 175: if (nIndex == CI_DEF_COLOR_INDEX_CLOTHLEATHER) return "Forian's Gold"; else return "Forian's Gold"; break;
    }

    return "unkown";
}
