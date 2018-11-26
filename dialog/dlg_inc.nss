///////////////////////////////////////////////////////////////////////////////
// dlg_inc
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes:The central include file of the Dialogue System


///////////
// Includes
//
#include "nwnx_sql"
#include "mod_cfg"
#include "dlg_cfg"

///////////////////////
// Function Declaration
//

// Help
void dlg_Help();

// For internal use, builds the variable strings for non-NWNx Use
string dlg_GetVariableIdentifier(int nDialogcount, string sVariable);

// Recreate the dialogue table
void dlg_CreateTables();

// Returns FALSE if any of the required System Tables is missing
int dlg_GetTablesExist();

// Drops all System Tables
void dlg_DropTables();

// Creates a new Dialog and returns it's unique ID for later use
// sTag will be the readable identifier for this dialog as well as the name
// for it's associated script. So if you create a dialog with sTag = "npcConvo"
// then you will have to create a script named "npcConvo" too. Refer to
// dlg_example for how to properly use this system
//
// Description is an optional parameter that's stored int he database
// in case anyone has access to that and checks what dialog is for what
int dlg_CreateDialog(string sDialogTag, string sDescription = "no description");

// Creates a new NPC Node
// sParentNode is the Node under which this node will be created, the default "T"
// stands for TOP
string dlg_AddNPCNode(int iDialogID, string sParentNode = "T", string sText = "Text", int iConditional = -1, int iActionTaken = -1);

// Creates a new PC Node
// sParentNode is the Node under which this node will be created, the default "TN1"
// stands for first PC Node
string dlg_AddPCNode(int iDialogID, string sParentNode = "TN1", string sText = "Text", int iConditional = -1, int iActionTaken = -1, string sTargetNode = "0", int iRememberPage = FALSE);

// Adds an exit option to this "Dialog" (will be visible on every page of a multi
// page dialog
void dlg_AddExitOption(int iDialogID, string sParentNode = "TN1", string sText = "[ End Dialog ]", int iConditional = -1, int iActionTaken = -1);

// Adds a "back" option to your dialogue, leading back to the previous level
// sTarget needs to be "T" for top level OR the PLAYER-NODE that leads to the NPC
// options you want to link to
void dlg_AddJumpOption(int iDialogID, string sParentNode = "TN1", string sTargetNode = "T", string sText = "[ Back ]", int iConditional = -1, int iActionTaken = -1);

// Gets Number of available PC Options for the given node
int dlg_GetNumberOfPCOptions(int iDialogID, string sNode);

// Get Text for the given node
struct STRUCT_DLG_NODEINFO dlg_GetNodeInfo(int iDialogID, string sNode, int iOption);

// Starts a conversation between oNPC and oPC
// oNPC can be the PC object too, to initiate a convo with himself
void dlg_StartConversation(string sDialogTag, object oNPC, object oPC, object oAdditionalObject=OBJECT_INVALID);

// With this, you can override the text of any given node (NPC and PC Nodes)
// with sOverrideText through a condition (see example in dlg_example)
void dlg_OverrideNodeText(object oPC, string sOverrideText);

////////////////
// Function Code
//

void dlg_Help()
{
}

string dlg_GetVariableIdentifier(int nDialogCount, string sVariable)
{
    string sResult = CS_DLG_MOD_PREFIX + IntToString(nDialogCount) + "_" + sVariable;
    return sResult;
}

int dlg_GetTablesExist()
{
    if (CI_DLG_USE_NWNX == TRUE)
    {
        int nExists_Main = NWNX_SQL_ExecuteQuery("DESCRIBE " + CS_DLG_MAINTABLE);
        int nExists_Content = NWNX_SQL_ExecuteQuery("DESCRIBE " + CS_DLG_CONTENTTABLE);

        return (nExists_Main &&
                nExists_Content);
    }
    else
        return FALSE;
}

void dlg_DropTables()
{
    if (CI_DLG_USE_NWNX == TRUE)
    {
        NWNX_SQL_ExecuteQuery("DROP TABLE " + CS_DLG_MAINTABLE);
        NWNX_SQL_ExecuteQuery("DROP TABLE " + CS_DLG_CONTENTTABLE);
    }
}

void dlg_CreateTables()
{
    // Table creation is only need when NWNX is active
    if (CI_DLG_USE_NWNX == TRUE)
    {
        NWNX_SQL_ExecuteQuery("DROP TABLE " + CS_DLG_MAINTABLE);
        NWNX_SQL_ExecuteQuery("DROP TABLE " + CS_DLG_CONTENTTABLE);

        string sSQL = "CREATE TABLE " + CS_DLG_MAINTABLE + " (" + CS_DLG_ID + " integer NOT NULL AUTO_INCREMENT, ";
        sSQL += CS_DLG_TAG + " varchar(16) DEFAULT NULL, ";
        sSQL += CS_DLG_DESCRIPTION + " varchar(64) DEFAULT NULL, ";
        sSQL += "PRIMARY Key (" + CS_DLG_ID + "), ";
        sSQL += "KEY idx (" + CS_DLG_DESCRIPTION + "))";
        NWNX_SQL_ExecuteQuery(sSQL);

        sSQL = "CREATE TABLE " + CS_DLG_CONTENTTABLE + " (" + CS_DLG_ID + " int(11) NOT NULL, ";
        sSQL += CS_DLG_INDEX + " varchar(128) DEFAULT NULL, ";
        sSQL += CS_DLG_OPTION + " int(11) DEFAULT NULL, ";
        sSQL += CS_DLG_TEXT + " text DEFAULT NULL, ";
        sSQL += CS_DLG_CONDITIONAL_ID + " int(11) DEFAULT NULL, ";
        sSQL += CS_DLG_ACTION_ID + " int(11) DEFAULT NULL, ";
        sSQL += CS_DLG_TARGETNODE + " varchar(128) DEFAULT '0', ";
        sSQL += CS_DLG_REMEMBERPAGE + " int(11) DEFAULT 0, ";
        sSQL += "KEY idx (" + CS_DLG_ID + ", " + CS_DLG_INDEX + ", " + CS_DLG_OPTION + ", " + CS_DLG_CONDITIONAL_ID + ", " + CS_DLG_ACTION_ID + ", " + CS_DLG_TARGETNODE + "))";
        NWNX_SQL_ExecuteQuery(sSQL);
    }
}

int dlg_CreateDialog(string sDialogTag, string sDescription = "no description")
{
    if (CI_DLG_USE_NWNX == TRUE)
    {
        string sSQL = "INSERT INTO " + CS_DLG_MAINTABLE;
        sSQL += " (" + CS_DLG_TAG + ", " + CS_DLG_DESCRIPTION + ") ";
        sSQL += " VALUES (?, ?)";
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedString(0, sDialogTag);
        NWNX_SQL_PreparedString(1, sDescription);
        NWNX_SQL_ExecutePreparedQuery();

        // Return this dialog's unique ID for future use.
        NWNX_SQL_ExecuteQuery("SELECT LAST_INSERT_ID()");
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            return (StringToInt(NWNX_SQL_ReadDataInActiveRow(0)));
        }
        else
            return (0);
    }
    else
    {
        // Get the module object and query the current amount of dialogues
        object oMod = GetModule();

        // Query the module to see if there already is a dialog with the given tag. If so, return 0
        if (GetLocalInt(oMod, sDialogTag) != 0)
            return (0);

        int nDialogCount = GetLocalInt(oMod, CS_DLG_MOD_DIALOGCOUNT);
        // Increase the Dialog Count by one and add the new Dialog Object
        nDialogCount++;
        string sVAR_ID   = dlg_GetVariableIdentifier(nDialogCount, CS_DLG_MOD_ID);
        string sVAR_DESC = dlg_GetVariableIdentifier(nDialogCount, CS_DLG_MOD_DESCRIPTION);
        SetLocalString(oMod, sVAR_ID, sDialogTag);       // Create a connection ID --> Tag
        SetLocalString(oMod, sVAR_DESC, sDescription);   // Create a connection ID --> Description
        SetLocalInt(oMod, sDialogTag, nDialogCount);     // Create a connection Tag --> ID

        // Save the new Dialog count to the module
        SetLocalInt(oMod, CS_DLG_MOD_DIALOGCOUNT, nDialogCount);

        return nDialogCount;
    }
}

struct STRUCT_DLG_INFO dlg_GetDialogInfo(string sDialogTag)
{
    struct STRUCT_DLG_INFO strResult;

    if (CI_DLG_USE_NWNX == TRUE)
    {
        string sSQL = "SELECT " + CS_DLG_ID + ", " + CS_DLG_TAG + ", " + CS_DLG_DESCRIPTION + " FROM ";
        sSQL += CS_DLG_MAINTABLE + " WHERE " + CS_DLG_TAG + " = ?";
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedString(0, sDialogTag);
        NWNX_SQL_ExecutePreparedQuery();

        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            strResult.ID = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
            strResult.Tag = NWNX_SQL_ReadDataInActiveRow(1);
            strResult.Description = NWNX_SQL_ReadDataInActiveRow(2);
        }
        else
        {
            strResult.ID = 0;
        }
    }
    else
    {
        object oMod = GetModule();
        strResult.ID = GetLocalInt(oMod, sDialogTag);
        strResult.Tag = sDialogTag;
        strResult.Description = GetLocalString(oMod, dlg_GetVariableIdentifier(strResult.ID, CS_DLG_MOD_DESCRIPTION));
    }

    return (strResult);
}

string dlg_AddNPCNode(int iDialogID, string sParentNode = "T", string sText = "Text", int iConditional = -1, int iActionTaken = -1)
{
    int nOption;

    if (CI_DLG_USE_NWNX == TRUE)
    {
        string sSQL = "SELECT MAX(" + CS_DLG_OPTION + ") FROM " + CS_DLG_CONTENTTABLE + " WHERE ";
        sSQL += CS_DLG_INDEX + " = ? AND " +
                CS_DLG_ID + " = ?";
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedString(0, sParentNode + CS_DLG_PREFIX_NPC);
        NWNX_SQL_PreparedInt(1, iDialogID);
        NWNX_SQL_ExecutePreparedQuery();
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            nOption = StringToInt(NWNX_SQL_ReadDataInActiveRow(0)) + 1;
        }
        else
            nOption = 1;

        if (GetStringLength(sText) > 512)
            sText = GetStringLeft(sText, 512);

        sSQL = "INSERT " + CS_DLG_CONTENTTABLE;
        sSQL += " (" + CS_DLG_ID + ", " + CS_DLG_INDEX + ", " + CS_DLG_OPTION + ", " + CS_DLG_TEXT;
        sSQL += ", " + CS_DLG_CONDITIONAL_ID + ", " + CS_DLG_ACTION_ID + ")";
        sSQL += " VALUES (?, ?, ?, ?, ?, ?)";
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedInt(0, iDialogID);
        NWNX_SQL_PreparedString(1, sParentNode + CS_DLG_PREFIX_NPC);
        NWNX_SQL_PreparedInt(2, nOption);
        NWNX_SQL_PreparedString(3, sText);
        NWNX_SQL_PreparedInt(4, iConditional);
        NWNX_SQL_PreparedInt(5, iActionTaken);
        NWNX_SQL_ExecutePreparedQuery();
    }
    else
    {
        object oMod = GetModule();
        // Get Current Options Count
        string sVAR_NODE_NPCOptions = dlg_GetVariableIdentifier(iDialogID, CS_DLG_MOD_NODE + "_" + sParentNode + "_" + CS_DLG_PREFIX_NPC + "_Count");
        // For Dialog ID #1, Node "T", the following line looks like this
        // int nOptions = GetLocalInt(oMod, "DLG_1_NODE_T_N_Count");
        nOption = GetLocalInt(oMod, sVAR_NODE_NPCOptions);
        nOption++;

        // Variable Prefix of the new Node
        // string sNodePrefix = "DLG_1_NODE_TN1";
        string sNodePrefix = dlg_GetVariableIdentifier(iDialogID, CS_DLG_MOD_NODE + "_" + sParentNode + CS_DLG_PREFIX_NPC + IntToString(nOption));

        // Node Text
        // SetLocalString(oMod, "DLG_1_NODE_TN1_Text", "Text");
        SetLocalString(oMod, sNodePrefix + "_Text", sText);

        // Conditional and Action
        SetLocalInt(oMod, sNodePrefix + "_CO", iConditional);
        SetLocalInt(oMod, sNodePrefix + "_AC", iActionTaken);

        // Save new option count to module
        SetLocalInt(oMod, sVAR_NODE_NPCOptions, nOption);
    }

    return (sParentNode + CS_DLG_PREFIX_NPC + IntToString(nOption));
}

string dlg_AddPCNode(int iDialogID, string sParentNode = "T", string sText = "Text", int iConditional = -1, int iActionTaken = -1, string sTargetNode = "std", int iRememberPage = FALSE)
{
    int nOption;

    if (CI_DLG_USE_NWNX == TRUE)
    {
        string sSQL = "SELECT MAX(" + CS_DLG_OPTION + ") FROM " + CS_DLG_CONTENTTABLE + " WHERE ";
        sSQL += CS_DLG_INDEX + " = ? AND " + CS_DLG_ID + " = ?";
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedString(0, sParentNode + CS_DLG_PREFIX_PC);
        NWNX_SQL_PreparedInt(1, iDialogID);
        NWNX_SQL_ExecutePreparedQuery();
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            nOption = StringToInt(NWNX_SQL_ReadDataInActiveRow(0)) + 1;
        }
        else
            nOption = 1;

        if (GetStringLength(sText) > 512)
            sText = GetStringLeft(sText, 512);

        sSQL = "INSERT " + CS_DLG_CONTENTTABLE;
        sSQL += " (" + CS_DLG_ID + ", " + CS_DLG_INDEX + ", " + CS_DLG_OPTION + ", " + CS_DLG_TEXT;
        sSQL += ", " + CS_DLG_CONDITIONAL_ID + ", " + CS_DLG_ACTION_ID + ", " + CS_DLG_TARGETNODE + ", " + CS_DLG_REMEMBERPAGE + ")";
        sSQL += " VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedInt(0, iDialogID);
        NWNX_SQL_PreparedString(1, sParentNode + CS_DLG_PREFIX_PC);
        NWNX_SQL_PreparedInt(2, nOption);
        NWNX_SQL_PreparedString(3, sText);
        NWNX_SQL_PreparedInt(4, iConditional);
        NWNX_SQL_PreparedInt(5, iActionTaken);
        NWNX_SQL_PreparedString(6, sTargetNode);
        NWNX_SQL_PreparedInt(7, iRememberPage);
        NWNX_SQL_ExecutePreparedQuery();

        /*string sSQL = "SET @optionid = SELECT COALESCE(MAX(" + CS_DLG_OPTION + "), 0) + 1 FROM " + CS_DLG_CONTENTTABLE + " WHERE " +
                      CS_DLG_INDEX + " = ? AND " +
                      CS_DLG_ID + " = ?; ";
        sSQL += "INSERT " + CS_DLG_CONTENTTABLE;
        sSQL += " (" + CS_DLG_ID + ", " + CS_DLG_INDEX + ", " + CS_DLG_OPTION + ", " + CS_DLG_TEXT;
        sSQL += ", " + CS_DLG_CONDITIONAL_ID + ", " + CS_DLG_ACTION_ID + ", " + CS_DLG_TARGETNODE + ", " + CS_DLG_REMEMBERPAGE + ")";
        sSQL += " VALUES (?, ?, @optionid, ?, ?, ?, ?, ?)";
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedString(0, sParentNode + CS_DLG_PREFIX_NPC);
        NWNX_SQL_PreparedInt(1, iDialogID);
        NWNX_SQL_PreparedInt(2, iDialogID);
        NWNX_SQL_PreparedString(3, sParentNode + CS_DLG_PREFIX_NPC);
        NWNX_SQL_PreparedString(4, sText);
        NWNX_SQL_PreparedInt(5, iConditional);
        NWNX_SQL_PreparedInt(6, iActionTaken);
        NWNX_SQL_PreparedString(7, sTargetNode);
        NWNX_SQL_PreparedInt(8, iRememberPage);
        NWNX_SQL_ExecutePreparedQuery();*/
    }
    else
    {
        object oMod = GetModule();
        // Get Current Options Count
        string sVAR_NODE_PCOptions = dlg_GetVariableIdentifier(iDialogID, CS_DLG_MOD_NODE + "_" + sParentNode + "_" + CS_DLG_PREFIX_PC + "_Count");
        // For Dialog ID #1, Node "T", the following line looks like this
        // int nOptions = GetLocalInt(oMod, "DLG_1_NODE_T_P_Count");
        nOption = GetLocalInt(oMod, sVAR_NODE_PCOptions);
        nOption++;

        // Variable Prefix of the new Node
        // string sNodePrefix = "DLG_1_NODE_TN1";
        string sNodePrefix = dlg_GetVariableIdentifier(iDialogID, CS_DLG_MOD_NODE + "_" + sParentNode + CS_DLG_PREFIX_PC + IntToString(nOption));

        // Node Text
        // SetLocalString(oMod, "DLG_1_NODE_TN1_Text", "Text");
        SetLocalString(oMod, sNodePrefix + "_Text", sText);

        // Conditional and Action
        SetLocalInt(oMod, sNodePrefix + "_CO", iConditional);
        SetLocalInt(oMod, sNodePrefix + "_AC", iActionTaken);

        // Set TargetNode
        SetLocalString(oMod, sNodePrefix + "_TG", sTargetNode);

        // Set RememberPage
        SetLocalInt(oMod, sNodePrefix + "_RP", iRememberPage);

        // Save new option count to module
        SetLocalInt(oMod, sVAR_NODE_PCOptions, nOption);
    }

    return (sParentNode + CS_DLG_PREFIX_PC + IntToString(nOption));
}

void dlg_AddJumpOption(int iDialogID, string sParentNode = "TN1", string sTargetNode = "T", string sText = "[ Back ]", int iConditional = -1, int iActionTaken = -1)
{
    if (CI_DLG_USE_NWNX == TRUE)
    {
        string sSQL = "INSERT  " + CS_DLG_CONTENTTABLE;
        sSQL += " (" + CS_DLG_ID + ", " + CS_DLG_INDEX + ", " + CS_DLG_OPTION + ", " + CS_DLG_TEXT;
        sSQL += ", " + CS_DLG_CONDITIONAL_ID + ", " + CS_DLG_ACTION_ID + ", " + CS_DLG_TARGETNODE + ")";
        sSQL += " VALUES (?, ?, ?, ?, ?, ?, ?)";
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedInt(0, iDialogID);
        NWNX_SQL_PreparedString(1, sParentNode + CS_DLG_PREFIX_BACK);
        NWNX_SQL_PreparedInt(2, 1);
        NWNX_SQL_PreparedString(3, sText);
        NWNX_SQL_PreparedInt(4, iConditional);
        NWNX_SQL_PreparedInt(5, iActionTaken);
        NWNX_SQL_PreparedString(6, sTargetNode);
        NWNX_SQL_ExecutePreparedQuery();
    }
    else
    {
        object oMod = GetModule();
        // Variable Prefix of the new Node
        // string sNodePrefix = "DLG_1_NODE_TN1";
        string sNodePrefix = dlg_GetVariableIdentifier(iDialogID, CS_DLG_MOD_NODE + "_" + sParentNode + CS_DLG_PREFIX_BACK + "1");

        // Node Text
        // SetLocalString(oMod, "DLG_1_NODE_TN1_Text", "Text");
        SetLocalString(oMod, sNodePrefix + "_Text", sText);

        // Conditional and Action
        SetLocalInt(oMod, sNodePrefix + "_CO", iConditional);
        SetLocalInt(oMod, sNodePrefix + "_AC", iActionTaken);

        // Set TargetNode
        SetLocalString(oMod, sNodePrefix + "_TG", sTargetNode);
    }
}

void dlg_AddExitOption(int iDialogID, string sParentNode = "TN1", string sText = "[ End Dialog ]", int iConditional = -1, int iActionTaken = -1)
{
    if (CI_DLG_USE_NWNX == TRUE)
    {
        string sSQL = "INSERT  " + CS_DLG_CONTENTTABLE;
        sSQL += " (" + CS_DLG_ID + ", " + CS_DLG_INDEX + ", " + CS_DLG_OPTION + ", " + CS_DLG_TEXT;
        sSQL += ", " + CS_DLG_CONDITIONAL_ID + ", " + CS_DLG_ACTION_ID + ")";
        sSQL += " VALUES (?, ?, ?, ?, ?, ?)";
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedInt(0, iDialogID);
        NWNX_SQL_PreparedString(1, sParentNode + CS_DLG_PREFIX_EXIT);
        NWNX_SQL_PreparedInt(2, 1);
        NWNX_SQL_PreparedString(3, sText);
        NWNX_SQL_PreparedInt(4, iConditional);
        NWNX_SQL_PreparedInt(5, iActionTaken);
        NWNX_SQL_ExecutePreparedQuery();
    }
    else
    {
        object oMod = GetModule();
        // Variable Prefix of the new Node
        // string sNodePrefix = "DLG_1_NODE_TN1";
        string sNodePrefix = dlg_GetVariableIdentifier(iDialogID, CS_DLG_MOD_NODE + "_" + sParentNode + CS_DLG_PREFIX_EXIT + "1");

        // Node Text
        // SetLocalString(oMod, "DLG_1_NODE_TN1_Text", "Text");
        SetLocalString(oMod, sNodePrefix + "_Text", sText);

        // Conditional and Action
        SetLocalInt(oMod, sNodePrefix + "_CO", iConditional);
        SetLocalInt(oMod, sNodePrefix + "_AC", iActionTaken);
    }
}

int dlg_GetNumberOfPCOptions(int iDialogID, string sNode)
{
    if (CI_DLG_USE_NWNX == TRUE)
    {
        string sSQL = "SELECT MAX(" + CS_DLG_OPTION + ") FROM " + CS_DLG_CONTENTTABLE + " WHERE ";
        sSQL += CS_DLG_INDEX + " = ? AND " +
                CS_DLG_ID + " = ?";
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedString(0, sNode + CS_DLG_PREFIX_PC);
        NWNX_SQL_PreparedInt(1, iDialogID);
        NWNX_SQL_ExecutePreparedQuery();

        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            return (StringToInt(NWNX_SQL_ReadDataInActiveRow(0)));
        }
        else
            return (-1);
    }
    else
    {
        object oMod = GetModule();
        string sVAR_NODE_PCOptions = dlg_GetVariableIdentifier(iDialogID, CS_DLG_MOD_NODE + "_" + sNode + "_" + CS_DLG_PREFIX_PC + "_Count");
        // For Dialog ID #1, Node "T", the following line looks like this
        // int nOptions = GetLocalInt(oMod, "DLG_1_NODE_T_P_Count");
        int nOptions = GetLocalInt(oMod, sVAR_NODE_PCOptions);

        return (nOptions);
    }
}

struct STRUCT_DLG_NODEINFO dlg_GetNodeInfo(int iDialogID, string sNode, int iOption)
{
    struct STRUCT_DLG_NODEINFO strResult;

    if (CI_DLG_USE_NWNX == TRUE)
    {
        string sSQL = "SELECT " + CS_DLG_TEXT + ", " + CS_DLG_CONDITIONAL_ID + ", " + CS_DLG_ACTION_ID + ", " + CS_DLG_TARGETNODE + ", " + CS_DLG_REMEMBERPAGE + " FROM " + CS_DLG_CONTENTTABLE + " WHERE ";
        sSQL += CS_DLG_ID + " = ? AND ";
        sSQL += CS_DLG_INDEX + " = ? AND ";
        sSQL += CS_DLG_OPTION + " = ?";
        NWNX_SQL_PrepareQuery(sSQL);
        NWNX_SQL_PreparedInt(0, iDialogID);
        NWNX_SQL_PreparedString(1, sNode);
        NWNX_SQL_PreparedInt(2, iOption);
        NWNX_SQL_ExecutePreparedQuery();

        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            strResult.Text = NWNX_SQL_ReadDataInActiveRow(0);
            strResult.Condition = StringToInt(NWNX_SQL_ReadDataInActiveRow(1));
            strResult.Action = StringToInt(NWNX_SQL_ReadDataInActiveRow(2));
            strResult.Target = NWNX_SQL_ReadDataInActiveRow(3);
            strResult.RememberPage = StringToInt(NWNX_SQL_ReadDataInActiveRow(4));
            return ( strResult );
        }
        else
        {
            strResult.Text = "";
            return ( strResult );
        }
    }
    else
    {
        object oMod = GetModule();
        string sNodePrefix = dlg_GetVariableIdentifier(iDialogID, CS_DLG_MOD_NODE + "_" + sNode + IntToString(iOption));

        strResult.Text = GetLocalString(oMod, sNodePrefix + "_Text");
        strResult.Condition = GetLocalInt(oMod, sNodePrefix + "_CO");
        strResult.Action = GetLocalInt(oMod, sNodePrefix + "_AC");
        strResult.Target = GetLocalString(oMod, sNodePrefix + "_TG");
        strResult.RememberPage = GetLocalInt(oMod, sNodePrefix + "_RP");
        return ( strResult );
    }
}

void dlg_StartConversation(string sDialogTag, object oNPC, object oPC, object oAdditionalObject=OBJECT_INVALID)
{
   object oMod = GetModule();
   int iDialog = GetLocalInt(oMod, CS_DLG_DIALOGOBJECT);
   switch (iDialog)
   {
      case 0: iDialog = 1;
           break;
      case CI_DLG_NUMBEROFDIALOGOBJECTS: iDialog = 1;
           break;
      default: iDialog++;
           break;
   }
   string sDialogToUse = "d_dlg_" + IntToString(iDialog);

   struct STRUCT_DLG_INFO strDialog = dlg_GetDialogInfo(sDialogTag);

   SetLocalInt(oPC, CS_DLG_PC_DIALOGID, strDialog.ID);
   SetLocalString(oPC, CS_DLG_PC_SCRIPT, strDialog.Tag);
   SetLocalString(oPC, CS_DLG_PC_NODE, "T");
   SetLocalInt(oPC, CS_DLG_PC_PAGE, 0);
   SetLocalInt(oPC, CS_DLG_PC_DIALOGOBJECT, iDialog);
   SetLocalInt(oPC, CS_DLG_PC_TOKEN, 0);
   SetLocalInt(oPC, CS_DLG_PC_FIRSTOPTIONFORPAGE + "0", 1);
   SetLocalObject(oPC, CS_DLG_PC_CONVERSATIONNPC, oNPC);
   if (GetIsObjectValid(oAdditionalObject))
       SetLocalObject(oPC, CS_DLG_PC_ADDITIONALOBJECT, oAdditionalObject);

   //SendMessageToAllDMs("Starting conversation '" + sDialogTag + "' (ID: #" + IntToString(strDialog.ID) + ")\n" + "Dialog Object: " + sDialogToUse);
   SetLocalInt(oMod, CS_DLG_DIALOGOBJECT, iDialog);

   AssignCommand(oNPC, ActionStartConversation(oPC, sDialogToUse, TRUE));
}

void dlg_OverrideNodeText(object oPC, string sOverrideText)
{
   SetLocalInt(oPC, CS_DLG_PC_OVERRIDE, TRUE);
   SetLocalString(oPC, CS_DLG_OVERRIDETEXT, sOverrideText);
}
