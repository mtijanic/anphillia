///////////////////////////////////////////////////////////////////////////////
// wand_ini
// written by: eyesolated
// written at: May 5, 2015
//
// Notes: Initialization File for the Emote/DM/FX Wand

///////////
// Includes
//
#include "dlg_inc"
#include "x3_inc_string"
#include "dlg_wand_const"
#include "color_inc"

//#include "god_inc"

////////////////
// Function Code
//
void Druid_Wildshapes(int iDialog, string sParent, string sTargetNode)
{
    string sTestFor2da = Get2DAString("polymorph", "Name", 234);
    string sTestForCEP = Get2DAString("portraits", "Name", 2218);

    dlg_AddPCNode(iDialog, sParent, "Badger", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_BADGER, sTargetNode);
    if (sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Bat", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_BAT, sTargetNode);
    if (sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Black Bear", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_BLACK_BEAR, sTargetNode);
    dlg_AddPCNode(iDialog, sParent, "Boar", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_BOAR, sTargetNode);
    dlg_AddPCNode(iDialog, sParent, "Brown Bear", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_BROWNBEAR, sTargetNode);
    if (sTestForCEP != "" && sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Cat", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_HOUSECAT, sTargetNode);
    if (sTestFor2da == "") dlg_AddPCNode(iDialog, sParent, "Chicken", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_CHICKEN, sTargetNode);
    if (sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Chicken", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_CHICKEN_OVERRIDE, sTargetNode);
    if (sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Cougar", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_COUGAR, sTargetNode);
    if (sTestFor2da == "") dlg_AddPCNode(iDialog, sParent, "Cow", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_COW, sTargetNode);
    if (sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Cow", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_COW_OVERRIDE, sTargetNode);
    if (sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Deer", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_DEER, sTargetNode);
    dlg_AddPCNode(iDialog, sParent, "Dire Badger", CI_CONDITIONAL_HAS_DRUID_LEVELS_ADDITIONAL_OPTIONS, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_DIREBADGER, sTargetNode);
    dlg_AddPCNode(iDialog, sParent, "Dire Boar", CI_CONDITIONAL_HAS_DRUID_LEVELS_ADDITIONAL_OPTIONS, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_DIREBOAR, sTargetNode);
    dlg_AddPCNode(iDialog, sParent, "Dire Brown Bear", CI_CONDITIONAL_HAS_DRUID_LEVELS_ADDITIONAL_OPTIONS, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_DIREBROWNBEAR, sTargetNode);
    dlg_AddPCNode(iDialog, sParent, "Dire Panther", CI_CONDITIONAL_HAS_DRUID_LEVELS_ADDITIONAL_OPTIONS, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_DIREPANTHER, sTargetNode);
    dlg_AddPCNode(iDialog, sParent, "Dire Wolf", CI_CONDITIONAL_HAS_DRUID_LEVELS_ADDITIONAL_OPTIONS, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_DIREWOLF, sTargetNode);
    dlg_AddPCNode(iDialog, sParent, "Dire Tiger", CI_CONDITIONAL_HAS_DRUID_LEVELS_ADDITIONAL_OPTIONS, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_DIRETIGER, sTargetNode);
    if (sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Falcon", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_FALCON, sTargetNode);
    if (sTestForCEP != "" && sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Ferret", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_FERRET, sTargetNode);
    dlg_AddPCNode(iDialog, sParent, "Giant Spider", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_GIANTSPIDER, sTargetNode);
    if (sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Grizzly Bear", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_GRIZZLY_BEAR, sTargetNode);
    if (sTestForCEP != "" && sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Mouses", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_MOUSE, sTargetNode);
    dlg_AddPCNode(iDialog, sParent, "Panther", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_PANTHER, sTargetNode);
    if (sTestFor2da == "") dlg_AddPCNode(iDialog, sParent, "Penguin", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_PENGUIN, sTargetNode);
    if (sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Penguin", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_PENGUIN_OVERRIDE, sTargetNode);
    if (sTestForCEP != "" && sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Pig", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_PIG, sTargetNode);
    if (sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Polar Bear", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_POLAR_BEAR, sTargetNode);
    if (sTestForCEP != "" && sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Puppy", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_PUPPY, sTargetNode);
    if (sTestForCEP != "" && sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Racoon", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_RACOON, sTargetNode);
    if (sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Rat", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_RAT, sTargetNode);
    if (sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Raven", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_RAVEN, sTargetNode);
    if (sTestForCEP != "" && sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Skunk", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_SKUNK, sTargetNode);
    if (sTestForCEP != "" && sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Swamp Viper", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_SWAMPVIPER, sTargetNode);
    if (sTestForCEP != "" && sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Treant", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_TREANT, sTargetNode);
    if (sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "White Stag", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_WHITESTAG, sTargetNode);
    if (sTestForCEP != "" && sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "White Tiger", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_WHITETIGER, sTargetNode);
    if (sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Wild Dog", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_WILDDOG, sTargetNode);
    if (sTestFor2da == "") dlg_AddPCNode(iDialog, sParent, "Winter Wolf", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_WINTERWOLF, sTargetNode);
    if (sTestFor2da == "POLYMORPH_TYPE_TREANT") dlg_AddPCNode(iDialog, sParent, "Winter Wolf", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_WINTERWOLF_OVERRIDE, sTargetNode);
    dlg_AddPCNode(iDialog, sParent, "Wolf", -1, CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_WOLF, sTargetNode);
    dlg_AddJumpOption(iDialog, sParent, sTargetNode, "I don't want to change anything.");
}

void main()
{
    int iDialog;
    string sRoot;
    string sL1;
    string sL2;
    string sL3;
    string sL4;
    string sL5;
    string sL6;
    int nth;

    iDialog = dlg_CreateDialog("dlg_wand", "This the Dialog for eyesolated's enhanced Wand System");
    sRoot = dlg_AddNPCNode(iDialog, "T", "Hello and welcome to " + color_ConvertString("eyesolated PC Actions", COLOR_ORANGE) + ".\nWhat would you like to do?");

        // AFK
        sL1 = dlg_AddPCNode(iDialog, sRoot, "I want to go AFK.", -1, CI_ACTION_AFK_ACTIVATE);
            sL2 = dlg_AddNPCNode(iDialog, sL1, "You are now AFK.");
                dlg_AddExitOption(iDialog, sL2, "I'm back!", -1, CI_ACTION_AFK_DEACTIVATE);

        // Emotes
        sL1 = dlg_AddPCNode(iDialog, sRoot, "I want to do an Emote.");
            sL2 = dlg_AddNPCNode(iDialog, sL1, "Which Emotes do you want to select from?");
                sL3 = dlg_AddPCNode(iDialog, sL2, "Normal Emotes", -1, 1);
                    sL4 = dlg_AddNPCNode(iDialog, sL3, "Which normal Emote do you want to do?");
                        // Fire and Forget
                        dlg_AddPCNode(iDialog, sL4, "Bored", -1, CI_ACTION_EMOTE_FF_PAUSE_BORED, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Bow", -1, CI_ACTION_EMOTE_FF_BOW, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Cheer 1", -1, CI_ACTION_EMOTE_FF_VICTORY1, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Cheer 2", -1, CI_ACTION_EMOTE_FF_VICTORY2, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Cheer 3", -1, CI_ACTION_EMOTE_FF_VICTORY3, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Dance", -1, CI_ACTION_EMOTE_CUSTOM_DANCE, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Dodge", -1, CI_ACTION_EMOTE_FF_DODGE_SIDE, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Duck", -1, CI_ACTION_EMOTE_FF_DODGE_DUCK, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Drink", -1, CI_ACTION_EMOTE_FF_DRINK, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Greet", -1, CI_ACTION_EMOTE_FF_GREETING, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Read", -1, CI_ACTION_EMOTE_FF_READ, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Salute", -1, CI_ACTION_EMOTE_FF_SALUTE, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Spasm", -1, CI_ACTION_EMOTE_FF_SPASM, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Steal", -1, CI_ACTION_EMOTE_FF_STEAL, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Taunt", -1, CI_ACTION_EMOTE_FF_TAUNT, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Scratch Head", -1, CI_ACTION_EMOTE_FF_PAUSE_SCRATCH_HEAD, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Smoke", -1, CI_ACTION_EMOTE_CUSTOM_SMOKE, sL3);
                        dlg_AddJumpOption(iDialog, sL4, sL1);

                sL3 = dlg_AddPCNode(iDialog, sL2, "Continous Emotes", -1, 1);
                    sL4 = dlg_AddNPCNode(iDialog, sL3, "Which continous Emote do you want to do?");
                        // Continuous
                        dlg_AddPCNode(iDialog, sL4, "Conjure 1", -1, CI_ACTION_EMOTE_LOOP_CONJURE1, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Conjure 2", -1, CI_ACTION_EMOTE_LOOP_CONJURE2, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Fall down backward", -1, CI_ACTION_EMOTE_LOOP_DEAD_BACK, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Fall down forward", -1, CI_ACTION_EMOTE_LOOP_DEAD_FRONT, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Pick up something", -1, CI_ACTION_EMOTE_LOOP_GET_LOW, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Give something", -1, CI_ACTION_EMOTE_LOOP_GET_MID, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Listen", -1, CI_ACTION_EMOTE_LOOP_LISTEN, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Look Far", -1, CI_ACTION_EMOTE_LOOP_LOOK_FAR, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Meditate", -1, CI_ACTION_EMOTE_LOOP_MEDITATE, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Pause 1", -1, CI_ACTION_EMOTE_LOOP_PAUSE, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Pause (Drunk)", -1, CI_ACTION_EMOTE_LOOP_PAUSE_DRUNK, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Pause (Tired)", -1, CI_ACTION_EMOTE_LOOP_PAUSE_TIRED, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Pause 2", -1, CI_ACTION_EMOTE_LOOP_PAUSE2, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Sit on the floor", -1, CI_ACTION_EMOTE_LOOP_SIT_CROSS, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Spasm", -1, CI_ACTION_EMOTE_LOOP_SPASM, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Talk Forceful", -1, CI_ACTION_EMOTE_LOOP_TALK_FORCEFUL, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Talk Laughing", -1, CI_ACTION_EMOTE_LOOP_TALK_LAUGHING, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Talk Normal", -1, CI_ACTION_EMOTE_LOOP_TALK_NORMAL, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Talk Pleading", -1, CI_ACTION_EMOTE_LOOP_TALK_PLEADING, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Worship", -1, CI_ACTION_EMOTE_LOOP_WORSHIP, sL3);
                        dlg_AddJumpOption(iDialog, sL4, sL1);
                dlg_AddJumpOption(iDialog, sL2);

        // Rolls
        sL1 = dlg_AddPCNode(iDialog, sRoot, "I want to roll the dice.");
            sL2 = dlg_AddNPCNode(iDialog, sL1, "What do you want to do?");
                // Privacy Mode
                sL3 = dlg_AddPCNode(iDialog, sL2, "Privacy Level.", CI_CONDITION_ROLLS_PRIVACY_OVERRIDE);
                    sL4 = dlg_AddNPCNode(iDialog, sL3, "Please choose your desired privacy level.");
                        dlg_AddPCNode(iDialog, sL4, "Private (only you and DMs can see your rolls)", -1, CI_ACTION_PRIVACY_SET_PRIVATE, sL1);
                        dlg_AddPCNode(iDialog, sL4, "Public (nearby players can see your rolls)", -1, CI_ACTION_PRIVACY_SET_PUBLIC, sL1);
                        dlg_AddJumpOption(iDialog, sL4, sL1);
                // Dice Rolls
                sL3 = dlg_AddPCNode(iDialog, sL2, "I want to do a Dice Roll.");
                    sL4 = dlg_AddNPCNode(iDialog, sL3, "What kind of Dice do you want to roll?", CI_CONDITION_ROLLS_NODIETYPE);
                    // Create the number of dice to roll directly here, only accessible via a jump command from the dice rolls
                    string sL4_1 = dlg_AddNPCNode(iDialog, sL3, "How many Dice do you want to roll?");
                        for (nth = 1; nth <=10; nth++)
                            dlg_AddPCNode(iDialog, sL4_1, IntToString(nth), -1, CI_ACTION_ROLLS_DICE_1 + (nth -1), sL3);
                        dlg_AddJumpOption(iDialog, sL4_1, sL3, "[ Back ]", -1, CI_ACTION_ROLLS_DIE_DELETE);
                        dlg_AddPCNode(iDialog, sL4, "d4", -1, CI_ACTION_ROLLS_DIE_D4, sL3);
                        dlg_AddPCNode(iDialog, sL4, "d6", -1, CI_ACTION_ROLLS_DIE_D6, sL3);
                        dlg_AddPCNode(iDialog, sL4, "d8", -1, CI_ACTION_ROLLS_DIE_D8, sL3);
                        dlg_AddPCNode(iDialog, sL4, "d10", -1, CI_ACTION_ROLLS_DIE_D10, sL3);
                        dlg_AddPCNode(iDialog, sL4, "d12", -1, CI_ACTION_ROLLS_DIE_D12, sL3);
                        dlg_AddPCNode(iDialog, sL4, "d20", -1, CI_ACTION_ROLLS_DIE_D20, sL3);
                        dlg_AddPCNode(iDialog, sL4, "d100", -1, CI_ACTION_ROLLS_DIE_D100, sL3);
                        dlg_AddJumpOption(iDialog, sL4, sL1);

                // Ability Checks
                sL3 = dlg_AddPCNode(iDialog, sL2, "I want to do an Ability Check.");
                    sL4 = dlg_AddNPCNode(iDialog, sL3, "What Ability Check do you want to do?");
                        dlg_AddPCNode(iDialog, sL4, "Do a Strength Check.", -1, CI_ACTION_ABILITY_STRENGTH, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Do a Dexterity Check.", -1, CI_ACTION_ABILITY_DEXTERITY, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Do a Constitution Check.", -1, CI_ACTION_ABILITY_CONSTITUTION, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Do a Wisdom Check.", -1, CI_ACTION_ABILITY_WISDOM, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Do an Intelligence Check.", -1, CI_ACTION_ABILITY_INTELLIGENCE, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Do a Charisma Check.", -1, CI_ACTION_ABILITY_CHARISMA, sL3);
                        dlg_AddJumpOption(iDialog, sL4, sL1);

                // Saving Throws
                sL3 = dlg_AddPCNode(iDialog, sL2, "I want to do a Saving Throw.");
                    sL4 = dlg_AddNPCNode(iDialog, sL3, "What Saving Throw you want to do?");
                        dlg_AddPCNode(iDialog, sL4, "Do a Fortitude Check.", -1, CI_ACTION_SAVINGTHROW_FORTITUDE, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Do a Reflex Check.", -1, CI_ACTION_SAVINGTHROW_REFLEX, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Do a Will Check.", -1, CI_ACTION_SAVINGTHROW_WILL, sL3);
                        dlg_AddJumpOption(iDialog, sL4, sL1);

                // Skill Checks
                sL3 = dlg_AddPCNode(iDialog, sL2, "I want to do a Skill Check.");
                    sL4 = dlg_AddNPCNode(iDialog, sL3, "What Skill Check do you want to do?");
                        dlg_AddPCNode(iDialog, sL4, "Animal Empathy", -1, CI_ACTION_SKILLCHECK_ANIMALEMPATHY, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Appraise", -1, CI_ACTION_SKILLCHECK_APPRAISE, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Bluff", -1, CI_ACTION_SKILLCHECK_BLUFF, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Concentration", -1, CI_ACTION_SKILLCHECK_CONCENTRATION, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Craft Armor", -1, CI_ACTION_SKILLCHECK_CRAFT_ARMOR, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Craft Trap", -1, CI_ACTION_SKILLCHECK_CRAFT_TRAP, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Craft Weapon", -1, CI_ACTION_SKILLCHECK_CRAFT_WEAPON, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Disable Trap", -1, CI_ACTION_SKILLCHECK_DISABLE_TRAP, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Discipline", -1, CI_ACTION_SKILLCHECK_DISCIPLINE, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Heal", -1, CI_ACTION_SKILLCHECK_HEAL, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Hide", -1, CI_ACTION_SKILLCHECK_HIDE, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Intimidate", -1, CI_ACTION_SKILLCHECK_INTIMIDATE, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Listen", -1, CI_ACTION_SKILLCHECK_LISTEN, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Lore", -1, CI_ACTION_SKILLCHECK_LORE, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Move Silently", -1, CI_ACTION_SKILLCHECK_MOVE_SILENTLY, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Open Lock", -1, CI_ACTION_SKILLCHECK_OPEN_LOCK, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Parry", -1, CI_ACTION_SKILLCHECK_PARRY, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Perform", -1, CI_ACTION_SKILLCHECK_PERFORM, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Persuade", -1, CI_ACTION_SKILLCHECK_PERSUADE, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Pick Pocket", -1, CI_ACTION_SKILLCHECK_PICK_POCKET, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Ride", -1, CI_ACTION_SKILLCHECK_RIDE, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Search", -1, CI_ACTION_SKILLCHECK_SEARCH, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Set Trap", -1, CI_ACTION_SKILLCHECK_SET_TRAP, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Spell Craft", -1, CI_ACTION_SKILLCHECK_SPELLCRAFT, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Spot", -1, CI_ACTION_SKILLCHECK_SPOT, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Taunt", -1, CI_ACTION_SKILLCHECK_TAUNT, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Tumble", -1, CI_ACTION_SKILLCHECK_TUMBLE, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Use Magic Device", -1, CI_ACTION_SKILLCHECK_USE_MAGIC_DEVICE, sL3);
                        dlg_AddJumpOption(iDialog, sL4, sL1);

                dlg_AddJumpOption(iDialog, sL2);

        // Druid Wild Shape
        sL1 = dlg_AddPCNode(iDialog, sRoot, "[" + color_ConvertString("DRUID", COLOR_ORANGE) + "] I want to configure Wildshape", CI_CONDITIONAL_IS_DRUID);
            sL2 = dlg_AddNPCNode(iDialog, sL1, "Which shape do you want to modify?", CI_CONDITIONAL_HAS_DRUID_LEVELS_5);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Brown Bear", CI_CONDITIONAL_BROWNBEAR, CI_ACTION_DRUID_POLYMORPH_SET_BROWNBEAR);
                    sL4 = dlg_AddNPCNode(iDialog, sL3, "Brown Bear", CI_CONDITIONAL_BROWNBEAR);
                        Druid_Wildshapes(iDialog, sL4, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Panther", CI_CONDITIONAL_PANTHER, CI_ACTION_DRUID_POLYMORPH_SET_PANTHER);
                    sL4 = dlg_AddNPCNode(iDialog, sL3, "Panther", CI_CONDITIONAL_PANTHER);
                        Druid_Wildshapes(iDialog, sL4, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Wolf", CI_CONDITIONAL_WOLF, CI_ACTION_DRUID_POLYMORPH_SET_WOLF);
                    sL4 = dlg_AddNPCNode(iDialog, sL3, "Wolf", CI_CONDITIONAL_WOLF);
                        Druid_Wildshapes(iDialog, sL4, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Boar", CI_CONDITIONAL_BOAR, CI_ACTION_DRUID_POLYMORPH_SET_BOAR);
                    sL4 = dlg_AddNPCNode(iDialog, sL3, "Boar", CI_CONDITIONAL_BOAR);
                        Druid_Wildshapes(iDialog, sL4, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Badger", CI_CONDITIONAL_BADGER, CI_ACTION_DRUID_POLYMORPH_SET_BADGER);
                    sL4 = dlg_AddNPCNode(iDialog, sL3, "Badger", CI_CONDITIONAL_BADGER);
                        Druid_Wildshapes(iDialog, sL4, sL1);
                dlg_AddJumpOption(iDialog, sL2);
            sL2 = dlg_AddNPCNode(iDialog, sL1, "Sorry, you don't have enough " + color_ConvertString("Druid", COLOR_ORANGE) + " Levels.");
                dlg_AddJumpOption(iDialog, sL2);

        // DM Stuff
        sL1 = dlg_AddPCNode(iDialog, sRoot, "I want to do DM Stuff", CI_CONDITIONAL_ISDM);

        // End Dialog
        dlg_AddExitOption(iDialog, sRoot);
}
