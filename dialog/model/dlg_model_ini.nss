///////////////////////////////////////////////////////////////////////////////
// dlg_model_ini
// written by: eyesolated
// written at: May 5, 2015
//
// Notes: Initialization File for the Emote/DM/FX Wand

///////////
// Includes
//
#include "dlg_inc"
#include "x3_inc_string"
#include "dlg_model_const"
#include "color_inc"

//#include "god_inc"

////////////////
// Function Code
//
void main()
{
    int iDialog;
    string sRoot;
    string sL1;
    string sL2;
    string sL2_1;
    string sL3;
    string sL4;
    string sL4_1;
    string sL4_2;
    string sL5;
    string sL6;
    int nth;

    string sChooseColor = "Choose a color";
    if (CS_MODEL_ITEM_COLORING != "")
        sChooseColor = "Choose a color\n\n" + color_ConvertString("Note", COLOR_RED) + ": coloring items requires [" + color_ConvertString(CS_MODEL_DYE_NAME, COLOR_CYAN) + "]";

    iDialog = dlg_CreateDialog("dlg_model", "This the Dialog for eyesolated's Model System");
    sRoot = dlg_AddNPCNode(iDialog, "T", "Hello and welcome to " + color_ConvertString("eyesolated Item Appearance", COLOR_ORANGE) + ".\nWhat would you like to do?", -1, CI_ACTION_MODEL_CLONE_APPEARANCE);
        sL1 = dlg_AddPCNode(iDialog, sRoot, "Copy an equipped item to the model.", -1, CI_ACTION_MODEL_INITIALIZE);
            sL2 = dlg_AddNPCNode(iDialog, sL1, "Which items do you want to copy to the model?");
                sL3 = dlg_AddPCNode(iDialog, sL2, "All", -1, CI_ACTION_MODEL_COPY_ALL, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Cloak", CI_CONDITION_PC_HAS_CLOAK, CI_ACTION_MODEL_COPY_CLOAK, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Clothing / Armor", CI_CONDITION_PC_HAS_ARMOR, CI_ACTION_MODEL_COPY_ARMOR, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Helmet", CI_CONDITION_PC_HAS_HELMET, CI_ACTION_MODEL_COPY_HELMET, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Shield", CI_CONDITION_PC_HAS_SHIELD, CI_ACTION_MODEL_COPY_SHIELD, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Weapon (Left)", CI_CONDITION_PC_HAS_WEAPON_LEFT, CI_ACTION_MODEL_COPY_WEAPON_LEFT, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Weapon (Right)", CI_CONDITION_PC_HAS_WEAPON_RIGHT, CI_ACTION_MODEL_COPY_WEAPON_RIGHT, sL1);
                dlg_AddJumpOption(iDialog, sL2);

        sL1 = dlg_AddPCNode(iDialog, sRoot, "Remove an item from the model.");
            sL2 = dlg_AddNPCNode(iDialog, sL1, "Which items do you want to remove from the model?");
                sL3 = dlg_AddPCNode(iDialog, sL2, "All", -1, CI_ACTION_MODEL_REMOVE_ALL, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Cloak", CI_CONDITION_MODEL_HAS_CLOAK, CI_ACTION_MODEL_REMOVE_CLOAK, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Clothing / Armor", CI_CONDITION_MODEL_HAS_ARMOR, CI_ACTION_MODEL_REMOVE_ARMOR, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Helmet", CI_CONDITION_MODEL_HAS_HELMET, CI_ACTION_MODEL_REMOVE_HELMET, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Shield", CI_CONDITION_MODEL_HAS_SHIELD, CI_ACTION_MODEL_REMOVE_SHIELD, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Weapon (Left)", CI_CONDITION_MODEL_HAS_WEAPON_LEFT, CI_ACTION_MODEL_REMOVE_WEAPON_LEFT, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Weapon (Right)", CI_CONDITION_MODEL_HAS_WEAPON_RIGHT, CI_ACTION_MODEL_REMOVE_WEAPON_RIGHT, sL1);
                dlg_AddJumpOption(iDialog, sL2);

        sL1 = dlg_AddPCNode(iDialog, sRoot, "Change the racial appearance of the model.");
            sL2 = dlg_AddNPCNode(iDialog, sL1, "Which racial appearance do you want?");
                sL3 = dlg_AddPCNode(iDialog, sL2, "Dwarf", -1, CI_ACTION_APPEARANCE_TYPE_DWARF, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Elf", -1, CI_ACTION_APPEARANCE_TYPE_ELF, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Gnome", -1, CI_ACTION_APPEARANCE_TYPE_GNOME, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Half Elf", -1, CI_ACTION_APPEARANCE_TYPE_HALFELF, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Halfling", -1, CI_ACTION_APPEARANCE_TYPE_HALFLING, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Half Orc", -1, CI_ACTION_APPEARANCE_TYPE_HALFORC, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Human", -1, CI_ACTION_APPEARANCE_TYPE_HUMAN, sL1);
                dlg_AddJumpOption(iDialog, sL2);

        sL1 = dlg_AddPCNode(iDialog, sRoot, "Change the appearance of the model's current gear.");

            // Show options to modify the selected item after it was selected
            sL2_1 = dlg_AddNPCNode(iDialog, sL1, "What do you want to do with %item%?", CI_CONDITION_OVERRIDE_CHANGE_ITEM);
                //sL3 = dlg_AddPCNode(iDialog, sL2_1, "Remove %item% from model", CI_CONDITION_OVERRIDE_REMOVE_ITEM, CI_ACTION_MODEL_REMOVE_ITEM, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2_1, "Next Appearance", CI_CONDITION_NOTSELECTED_ARMOR_PART_ALL, CI_ACTION_MODEL_APPEARANCE_NEXT, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2_1, "Previous Appearance", CI_CONDITION_NOTSELECTED_ARMOR_PART_ALL, CI_ACTION_MODEL_APPEARANCE_PREVIOUS, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2_1, "Change Color", CI_CONDITION_SELECTED_NOT_SHIELD, -1);

                    // For weapons, we directly choose a color
                    sL4 = dlg_AddNPCNode(iDialog, sL3, "Choose a color", CI_CONDITION_SELECTED_WEAPON);
                        dlg_AddPCNode(iDialog, sL4, "Color 1", CI_CONDITION_COLOR_WEAPON, CI_ACTION_COLOR_WEAPON_1, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Color 2", CI_CONDITION_COLOR_WEAPON, CI_ACTION_COLOR_WEAPON_2, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Color 3", CI_CONDITION_COLOR_WEAPON, CI_ACTION_COLOR_WEAPON_3, sL3);
                        dlg_AddPCNode(iDialog, sL4, "Color 4", CI_CONDITION_COLOR_WEAPON, CI_ACTION_COLOR_WEAPON_4, sL3);
                        dlg_AddJumpOption(iDialog, sL4, sL1, "[ Back ]", -1, CI_ACTION_REMOVE_COLOR_TYPE);

                    // For the other items (Armor, Cloak, Helmet) we first select a Type of color, then the color
                    sL4_1 = dlg_AddNPCNode(iDialog, sL3, "Which color type do you want to change?", CI_CONDITION_COLOR_TYPE_NOTSELECTED);
                        // Armor / Helmet / Cloak Colors
                        sL5 = dlg_AddPCNode(iDialog, sL4_1, "Cloth 1", CI_CONDITION_SELECTED_NOWEAPON, CI_ACTION_MODEL_SELECT_COLOR_ARMOR_CLOTH1, sL3);
                        sL5 = dlg_AddPCNode(iDialog, sL4_1, "Cloth 2", CI_CONDITION_SELECTED_NOWEAPON, CI_ACTION_MODEL_SELECT_COLOR_ARMOR_CLOTH2, sL3);
                        sL5 = dlg_AddPCNode(iDialog, sL4_1, "Leather 1", CI_CONDITION_SELECTED_NOWEAPON, CI_ACTION_MODEL_SELECT_COLOR_ARMOR_LEATHER1, sL3);
                        sL5 = dlg_AddPCNode(iDialog, sL4_1, "Leather 2", CI_CONDITION_SELECTED_NOWEAPON, CI_ACTION_MODEL_SELECT_COLOR_ARMOR_LEATHER2, sL3);
                        sL5 = dlg_AddPCNode(iDialog, sL4_1, "Metal 1", CI_CONDITION_SELECTED_NOWEAPON, CI_ACTION_MODEL_SELECT_COLOR_ARMOR_METAL1, sL3);
                        sL5 = dlg_AddPCNode(iDialog, sL4_1, "Metal 2", CI_CONDITION_SELECTED_NOWEAPON, CI_ACTION_MODEL_SELECT_COLOR_ARMOR_METAL2, sL3);
                        dlg_AddJumpOption(iDialog, sL4_1, sL1, "[ Back ]");

                    sL4_2 = dlg_AddNPCNode(iDialog, sL3, "Choose a color", CI_CONDITION_SELECTED_NOWEAPON_OVERRIDE_COLOR);
                        dlg_AddPCNode(iDialog, sL4_2, "[ Clear individual color ]", CI_CONDITION_SELECTED_ARMORPART_SPECIFIC, CI_ACTION_MODEL_REMOVE_INDIVIDUAL_COLOR , sL3);
                        dlg_AddPCNode(iDialog, sL4_2, "[ Original color ]", CI_CONDITION_NOTSELECTED_ARMORPART_SPECIFIC, CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_ORIGINAL , sL3);
                        dlg_AddPCNode(iDialog, sL4_2, "[ Next color ]", CI_CONDITION_NOTSELECTED_ARMORPART_SPECIFIC, CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_NEXT , sL3);
                        dlg_AddPCNode(iDialog, sL4_2, "[ Previous color ]", CI_CONDITION_NOTSELECTED_ARMORPART_SPECIFIC, CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_PREVIOUS , sL3);
                        for (nth = 0; nth <= 175; nth++)
                        {
                            dlg_AddPCNode(iDialog, sL4_2, GetColorName(CI_DEF_COLOR_INDEX_CLOTHLEATHER, nth), CI_CONDITION_COLOR_NONMETAL, CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_CLOTHLEATHER + nth, sL3, TRUE);
                            dlg_AddPCNode(iDialog, sL4_2, GetColorName(CI_DEF_COLOR_INDEX_METAL, nth), CI_CONDITION_COLOR_METAL, CI_ACTION_MODEL_SELECT_COLOR_SPECIFIC_METAL + nth, sL3, TRUE);
                        }
                        dlg_AddJumpOption(iDialog, sL4_2, sL1, "[ Back ]", -1, CI_ACTION_REMOVE_COLOR_TYPE);

                dlg_AddJumpOption(iDialog, sL2_1, sL1, "[ Back ]", -1, CI_ACTION_REMOVE_SELECTION_ITEM);

            // Let the PC select an item to modify
            sL2 = dlg_AddNPCNode(iDialog, sL1, "Which item do you want to modify?");
                sL3 = dlg_AddPCNode(iDialog, sL2, "Cloak", CI_CONDITION_MODEL_HAS_CLOAK, CI_ACTION_MODEL_CHANGE_CLOAK, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Clothing / Armor", CI_CONDITION_MODEL_HAS_ARMOR, CI_ACTION_MODEL_CHANGE_ARMOR);
                    // this sL3 node needs to be reachable from the "Next /previous apperance" dialog
                    dlg_AddPCNode(iDialog, sL2_1, "[ " + color_ConvertString("Select another Armor Part", COLOR_BROWN) + " ]", CI_CONDITION_SELECTED_ARMOR, CI_ACTION_REMOVE_SELECTION_INDEX, sL3);
                    sL4 = dlg_AddNPCNode(iDialog, sL3, "Which part of the Clothing / Armor do you want to modify?\n\n" + color_ConvertString("NOTE", COLOR_RED) + ": Due to a bug in NWN:EE, every recolor of individual parts increases the dye counter.");
                        sL5 = dlg_AddPCNode(iDialog, sL4, "All (Colors Only)", -1, CI_ACTION_MODEL_CHANGE_ARMOR_ALL, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Belt", -1, CI_ACTION_MODEL_CHANGE_ARMOR_BELT, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Biceps (Left)", -1, CI_ACTION_MODEL_CHANGE_ARMOR_BICEPS_LEFT, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Biceps (Right)", -1, CI_ACTION_MODEL_CHANGE_ARMOR_BICEPS_RIGHT, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Biceps (Both)", CI_CONDITION_ARMOR_SAME_BICEPS, CI_ACTION_MODEL_CHANGE_ARMOR_BICEPS_BOTH, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Foot (Left)", -1, CI_ACTION_MODEL_CHANGE_ARMOR_FOOT_LEFT, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Foot (Right)", -1, CI_ACTION_MODEL_CHANGE_ARMOR_FOOT_RIGHT, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Feet (Both)", CI_CONDITION_ARMOR_SAME_FEET, CI_ACTION_MODEL_CHANGE_ARMOR_FOOT_BOTH, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Forearm (Left)", -1, CI_ACTION_MODEL_CHANGE_ARMOR_FOREARM_LEFT, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Forearm (Right)", -1, CI_ACTION_MODEL_CHANGE_ARMOR_FOREARM_RIGHT, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Forearms (Both)", CI_CONDITION_ARMOR_SAME_FOREARMS, CI_ACTION_MODEL_CHANGE_ARMOR_FOREARM_BOTH, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Hand (Left)", -1, CI_ACTION_MODEL_CHANGE_ARMOR_HAND_LEFT, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Hand (Right)", -1, CI_ACTION_MODEL_CHANGE_ARMOR_HAND_RIGHT, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Hands (Both)", CI_CONDITION_ARMOR_SAME_HANDS, CI_ACTION_MODEL_CHANGE_ARMOR_HAND_BOTH, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Neck", -1, CI_ACTION_MODEL_CHANGE_ARMOR_NECK, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Pelvis", -1, CI_ACTION_MODEL_CHANGE_ARMOR_PELVIS, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Robe", -1, CI_ACTION_MODEL_CHANGE_ARMOR_ROBE, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Shin (Left)", -1, CI_ACTION_MODEL_CHANGE_ARMOR_SHIN_LEFT, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Shin (Right)", -1, CI_ACTION_MODEL_CHANGE_ARMOR_SHIN_RIGHT, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Shins (Both)", CI_CONDITION_ARMOR_SAME_SHINS, CI_ACTION_MODEL_CHANGE_ARMOR_SHIN_BOTH, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Shoulder (Left)", -1, CI_ACTION_MODEL_CHANGE_ARMOR_SHOULDER_LEFT, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Shoulder (Right)", -1, CI_ACTION_MODEL_CHANGE_ARMOR_SHOULDER_RIGHT, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Shoulders (Both)", CI_CONDITION_ARMOR_SAME_SHOULDERS, CI_ACTION_MODEL_CHANGE_ARMOR_SHOULDER_BOTH, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Thigh (Left)", -1, CI_ACTION_MODEL_CHANGE_ARMOR_THIGH_LEFT, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Thigh (Right)", -1, CI_ACTION_MODEL_CHANGE_ARMOR_THIGH_RIGHT, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Thighs (Both)", CI_CONDITION_ARMOR_SAME_THIGHS, CI_ACTION_MODEL_CHANGE_ARMOR_THIGH_BOTH, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Torso", -1, CI_ACTION_MODEL_CHANGE_ARMOR_TORSO, sL1);
                        dlg_AddJumpOption(iDialog, sL4, sL1, "[ Back ]", -1, CI_ACTION_REMOVE_SELECTION_ITEM);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Helmet", CI_CONDITION_MODEL_HAS_HELMET, CI_ACTION_MODEL_CHANGE_HELMET, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Shield", CI_CONDITION_MODEL_HAS_SHIELD, CI_ACTION_MODEL_CHANGE_SHIELD, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Weapon (Left)", CI_CONDITION_MODEL_HAS_WEAPON_LEFT, CI_ACTION_MODEL_CHANGE_WEAPON_LEFT);
                    sL4 = dlg_AddNPCNode(iDialog, sL3, "Which part of the Weapon do you want to modify?");
                        dlg_AddPCNode(iDialog, sL2_1, "[ " + color_ConvertString("Select another Weapon Part", COLOR_BROWN) + " ]", CI_CONDITION_SELECTED_WEAPON_LEFT, CI_ACTION_REMOVE_SELECTION_INDEX, sL3);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Bottom", -1, CI_ACTION_MODEL_CHANGE_WEAPON_BOTTOM, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Middle", -1, CI_ACTION_MODEL_CHANGE_WEAPON_MIDDLE, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Top", -1, CI_ACTION_MODEL_CHANGE_WEAPON_TOP, sL1);
                        dlg_AddJumpOption(iDialog, sL4, sL1, "[ Back ]", -1, CI_ACTION_REMOVE_SELECTION_ITEM);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Weapon (Right)", CI_CONDITION_MODEL_HAS_WEAPON_RIGHT, CI_ACTION_MODEL_CHANGE_WEAPON_RIGHT);
                    sL4 = dlg_AddNPCNode(iDialog, sL3, "Which part of the Weapon do you want to modify?");
                        dlg_AddPCNode(iDialog, sL2_1, "[ " + color_ConvertString("Select another Weapon Part", COLOR_BROWN) + " ]", CI_CONDITION_SELECTED_WEAPON_RIGHT, CI_ACTION_REMOVE_SELECTION_INDEX, sL3);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Bottom", -1, CI_ACTION_MODEL_CHANGE_WEAPON_BOTTOM, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Middle", -1, CI_ACTION_MODEL_CHANGE_WEAPON_MIDDLE, sL1);
                        sL5 = dlg_AddPCNode(iDialog, sL4, "Top", -1, CI_ACTION_MODEL_CHANGE_WEAPON_TOP, sL1);
                        dlg_AddJumpOption(iDialog, sL4, sL1, "[ Back ]", -1, CI_ACTION_REMOVE_SELECTION_ITEM);
                dlg_AddJumpOption(iDialog, sL2);

        sL1 = dlg_AddPCNode(iDialog, sRoot, "Buy the appearance (design and coloring) of the model's gear.", -1);
            sL2 = dlg_AddNPCNode(iDialog, sL1, "Which items' apperance do you want to buy?\n\n" + color_ConvertString("NOTE", COLOR_RED) + ": displayed prices are for items equipped when entering this part of the dialog. If you equip different items, click back and reenter this menu to get the correct prices displayed.");
                sL3 = dlg_AddPCNode(iDialog, sL2, "All", CI_CONDITION_OVERRIDE_BUY_ALL, CI_ACTION_BUY_ALL, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Cloak", CI_CONDITION_OVERRIDE_BUY_CLOAK, CI_ACTION_BUY_CLOAK, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Clothing / Armor", CI_CONDITION_OVERRIDE_BUY_ARMOR, CI_ACTION_BUY_ARMOR, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Helmet", CI_CONDITION_OVERRIDE_BUY_HELMET, CI_ACTION_BUY_HELMET, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Shield", CI_CONDITION_OVERRIDE_BUY_SHIELD, CI_ACTION_BUY_SHIELD, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Weapon (Left)", CI_CONDITION_OVERRIDE_BUY_WEAPON_LEFT, CI_ACTION_BUY_WEAPON_LEFT, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Weapon (Right)", CI_CONDITION_OVERRIDE_BUY_WEAPON_RIGHT, CI_ACTION_BUY_WEAPON_RIGHT, sL1);
                dlg_AddJumpOption(iDialog, sL2);

        sL1 = dlg_AddPCNode(iDialog, sRoot, "Buy the design of the model's gear.", -1);
            sL2 = dlg_AddNPCNode(iDialog, sL1, "Which items' apperance do you want to buy?\n\n" + color_ConvertString("NOTE", COLOR_RED) + ": displayed prices are for items equipped when entering this part of the dialog. If you equip different items, click back and reenter this menu to get the correct prices displayed.");
                sL3 = dlg_AddPCNode(iDialog, sL2, "All", CI_CONDITION_OVERRIDE_BUY_DESIGN_ALL, CI_ACTION_BUY_DESIGN_ALL, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Cloak", CI_CONDITION_OVERRIDE_BUY_DESIGN_CLOAK, CI_ACTION_BUY_DESIGN_CLOAK, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Clothing / Armor", CI_CONDITION_OVERRIDE_BUY_DESIGN_ARMOR, CI_ACTION_BUY_DESIGN_ARMOR, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Helmet", CI_CONDITION_OVERRIDE_BUY_DESIGN_HELMET, CI_ACTION_BUY_DESIGN_HELMET, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Shield", CI_CONDITION_OVERRIDE_BUY_DESIGN_SHIELD, CI_ACTION_BUY_DESIGN_SHIELD, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Weapon (Left)", CI_CONDITION_OVERRIDE_BUY_DESIGN_WEAPON_LEFT, CI_ACTION_BUY_DESIGN_WEAPON_LEFT, sL1);
                sL3 = dlg_AddPCNode(iDialog, sL2, "Weapon (Right)", CI_CONDITION_OVERRIDE_BUY_DESIGN_WEAPON_RIGHT, CI_ACTION_BUY_DESIGN_WEAPON_RIGHT, sL1);
                dlg_AddJumpOption(iDialog, sL2);
        dlg_AddExitOption(iDialog, sRoot);
}
