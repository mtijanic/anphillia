///////////////////////////////////////////////////////////////////////////////
// dlg_lgs_ini
// written by: eyesolated
// written at: Mar. 16, 2018
//
// Notes: Initialization File for the LGS Dialog

///////////
// Includes
//
#include "dlg_inc"
#include "x3_inc_string"

////////////////
// Function Code
//
void main()
{
   int iDialog;
   int iCount;
   string sTopNode;
   string sSubNode;
   string sSubSubNode;
   string sSubSubSubNode;

   // LGS / IP Dialogue
    iDialog = dlg_CreateDialog("dlg_lgs", "Loot Generation System Dialog");
    sTopNode = dlg_AddNPCNode(iDialog, "T", "Welcome to the Loot Generation System Dialog.\nPlease choose an option below.");
        sSubNode = dlg_AddPCNode(iDialog, sTopNode, "Create Item.", -1, 998);
            string sNode_NPC_SelectMagicLevel = dlg_AddNPCNode(iDialog, sSubNode, "Please select the desired Item Level for the created item.", 1);
                for (iCount = 1; iCount <= 50; iCount++)
                {
                    sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectMagicLevel, "Item Level " + IntToString(iCount), -1, iCount, sSubNode);
                }
            string sNode_NPC_Config = dlg_AddNPCNode(iDialog, sSubNode, "Please choose an Option below.", 2);
                dlg_AddPCNode(iDialog, sNode_NPC_Config, "Change Item Level", -1, 997, sSubNode);
                string sNode_PC_SetNumberOfProperties = dlg_AddPCNode(iDialog, sNode_NPC_Config, "Change desired positive Property Count", 2, -1);
                string sNode_PC_SetItemMainCategory = dlg_AddPCNode(iDialog, sNode_NPC_Config, "Change Item Main Category", 2, -1);
                string sNode_PC_SetItemSubCategory = dlg_AddPCNode(iDialog, sNode_NPC_Config, "Change Item Sub Category", 3, -1);
                string sNode_PC_SetItemBaseItem = dlg_AddPCNode(iDialog, sNode_NPC_Config, "Change Base Item", 4, -1);
                dlg_AddPCNode(iDialog, sNode_NPC_Config, "Construct Item (Regular Loot)", 2, 999, sSubNode);
                dlg_AddPCNode(iDialog, sNode_NPC_Config, "Construct Item (Force Magic Level)", 2, 1000, sSubNode);
                //dlg_AddJumpOption(iDialog, sNode_NPC_Config, sSubNode, "Construct Item", 2, 999);
                dlg_AddExitOption(iDialog, sNode_NPC_Config);
                    string sNode_NPC_SelectPropertyCount = dlg_AddNPCNode(iDialog, sNode_PC_SetNumberOfProperties, "Please select the desired positive Property Count.", 2);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectPropertyCount, "Random", -1, 80, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectPropertyCount, "One", -1, 81, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectPropertyCount, "Two", -1, 82, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectPropertyCount, "Three", -1, 83, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectPropertyCount, "Four", -1, 84, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectPropertyCount, "Five", -1, 85, sSubNode);

                    string sNode_NPC_SelectItemMainCategory = dlg_AddNPCNode(iDialog, sNode_PC_SetItemMainCategory, "Please select the desired Main Category for the created item.", 2);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemMainCategory, "Armor", -1, 51, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemMainCategory, "Accessory", -1, 52, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemMainCategory, "Weapon", -1, 53, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemMainCategory, "Ammo", -1, 54, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemMainCategory, "Wand/Rod", -1, 55, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemMainCategory, "Container", -1, 56, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemMainCategory, "Bomb", -1, 57, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemMainCategory, "Others", -1, 58, sSubNode);

                    string sNode_NPC_SelectItemSubCategory = dlg_AddNPCNode(iDialog, sNode_PC_SetItemSubCategory, "Please select the desired Sub Category for the created item.", 3);
                        // MAIN CATEGORY ARMOR
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemSubCategory, "Cloth Armor", 51, 60, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemSubCategory, "Light Armor", 51, 61, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemSubCategory, "Medium Armor", 51, 62, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemSubCategory, "Heavy Armor", 51, 63, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemSubCategory, "Shields", 51, 64, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemSubCategory, "Helmets", 51, 65, sSubNode);

                        // MAIN CATEGORY ACCESSORIES
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemSubCategory, "Clothing", 52, 66, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemSubCategory, "Jewelry", 52, 67, sSubNode);

                        // MAIN CATEGORY WEAPONS
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemSubCategory, "Melee Weapon", 53, 68, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemSubCategory, "Ranged Weapon", 53, 69, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemSubCategory, "Thrown Weapon", 53, 70, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemSubCategory, "Wizard Staff", 53, 71, sSubNode);

                    string sNode_NPC_SelectItemBaseItem = dlg_AddNPCNode(iDialog, sNode_PC_SetItemBaseItem, "Please select the desired Item.", 4);
                        // CLOTH ARMOR
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Tunic", 60, 100, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Robe", 60, 101, sSubNode);

                        // LIGHT ARMOR
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Padded Armor", 61, 110, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Leather Armor", 61, 111, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Studded Leather Armor", 61, 112, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Chain Shirt", 61, 113, sSubNode);

                        // MEDIUM ARMOR
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Hide Armor", 62, 120, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Chain Mail", 62, 121, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Scale Mail", 62, 122, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Breast Plate", 62, 123, sSubNode);

                        // HEAVY ARMOR
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Banded Mail", 63, 130, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Splint Mail", 63, 131, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Half Plate", 63, 132, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Full Plate", 63, 133, sSubNode);

                        // SHIELDS
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Small Shield", 61, 140, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Large Shield", 61, 141, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Tower Shield", 61, 142, sSubNode);

                        // CLOTHING
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Belt", 66, 150, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Boots", 66, 151, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Bracers", 66, 152, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Cloak", 66, 153, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Gloves", 66, 154, sSubNode);

                        // JEWELRY
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Amulet", 67, 160, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Ring", 67, 161, sSubNode);

                        // MELEE WEAPONS
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Club", 68, 170, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Dagger", 68, 171, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Mace", 68, 172, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Sickle", 68, 173, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Spear", 68, 174, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Morningstar", 68, 175, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Quarterstaff", 68, 176, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Bastard Sword", 68, 177, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Battleaxe", 68, 178, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Greataxe", 68, 179, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Greatsword", 68, 180, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Halberd", 68, 181, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Handaxe", 68, 182, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Heavy Flail", 68, 183, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Light Flail", 68, 184, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Light Hammer", 68, 185, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Longsword", 68, 186, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Rapier", 68, 187, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Scimitar", 68, 188, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Shortsword", 68, 189, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Warhammer", 68, 190, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Dwarven Waraxe", 68, 191, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Dire Mace", 68, 192, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Double Axe", 68, 193, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Kama", 68, 194, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Katana", 68, 195, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Kukri", 68, 196, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Scythe", 68, 197, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Two-Bladed Sword", 68, 198, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Whip", 68, 199, sSubNode);

                        // RANGED WEAPONS
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Crossbow (Light)", 69, 210, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Crossbow (Heavy)", 69, 211, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Sling", 69, 212, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Longbow", 69, 213, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Shortbow", 69, 214, sSubNode);

                        // THROWN WEAPONS
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Dart", 70, 220, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Throwing Axe", 70, 221, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Shuriken", 70, 222, sSubNode);

                        // AMMO
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Arrows", 54, 230, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Bolts", 54, 231, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Bullets", 54, 232, sSubNode);

                        // OTHERS
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Potion", 58, 240, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Thives' Tools", 58, 241, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Healer's Kit", 58, 242, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Trap Kit", 58, 243, sSubNode);
                        sSubSubSubNode = dlg_AddPCNode(iDialog, sNode_NPC_SelectItemBaseItem, "Book", 58, 244, sSubNode);
        dlg_AddExitOption(iDialog, sTopNode);
}
