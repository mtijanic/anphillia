///////////////////////////////////////////////////////////////////////////////
// dlg_cfg
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: Configuration File for the Dialogue System

// Use NWNX?
const int CI_DLG_USE_NWNX = TRUE;

const string CS_DLG_INI_USERDEFINEDEVENTNUMBER = "DLG_EVENTID";
const int CI_DLG_NUMBEROFDIALOGOBJECTS = 5;
const string CS_DLG_MAINTABLE = "dlg_Dialogs";
const string CS_DLG_CONTENTTABLE = "dlg_DialogContents";
const string CS_DLG_DIALOGOBJECT = "dlg_DialogObject";

// Variables stored on the PC
const string CS_DLG_PC_DIALOGID = "dlg_PC_ID";
const string CS_DLG_PC_OVERRIDE = "dlg_PC_Override";
const string CS_DLG_OVERRIDETEXT = "dlg_OverrideText";
const string CS_DLG_PC_NODE = "dlg_PC_Node";
const string CS_DLG_PC_NODE_BACKUP = "dlg_PC_Node_Backup";
const string CS_DLG_PC_PAGE = "dlg_PC_Page";
const string CS_DLG_PC_PAGE_BACKUP = "dlg_PC_Page_Backup";
const string CS_DLG_PC_DIALOGOBJECT = "dlg_PC_Object";
const string CS_DLG_PC_TOKEN = "dlg_PC_Token";
const string CS_DLG_PC_SCRIPT = "dlg_PC_Script";
const string CS_DLG_PC_CONDITIONAL_ID = "dlg_PC_Conditional";
const string CS_DLG_PC_ACTION_ID = "dlg_PC_Action";
const string CS_DLG_PC_RESULT = "dlg_PC_Result";
const string CS_DLG_PC_PARENTNODE = "dlg_PC_ParentNode";
const string CS_DLG_PC_FIRSTOPTIONFORPAGE = "dlg_PC_fopt_";
const string CS_DLG_PC_CURRENTOPTIONFORPAGE = "dlg_PC_lopt_";
const string CS_DLG_PC_OPTION1 = "dlg_PC_opt1_";
const string CS_DLG_PC_OPTIONX = "dlg_PC_opt";
const string CS_DLG_PC_OPTION6 = "dlg_PC_opt6_";
const string CS_DLG_PC_NODETEXT = "dlg_PC_NodeText";
const string CS_DLG_PC_CONVERSATIONNPC = "dlg_PC_NPC";
const string CS_DLG_PC_ADDITIONALOBJECT = "dlg_PC_addObject";

// Dialog Structure
struct STRUCT_DLG_INFO
{
   int ID;
   string Tag;
   string Description;
};

struct STRUCT_DLG_NODEINFO
{
   string Text;
   int Condition;
   int Action;
   string Target;
   int RememberPage;
};

// Main Table
const string CS_DLG_ID = "DLG_ID";
const string CS_DLG_TAG = "TAG";
const string CS_DLG_DESCRIPTION = "Description";

// Dialog Content Table
const string CS_DLG_INDEX = "Node";
const string CS_DLG_OPTION = "OptionID";
const string CS_DLG_TEXT = "Textstring";
const string CS_DLG_CONDITIONAL_ID = "Conditional";
const string CS_DLG_ACTION_ID = "ActionTaken";
const string CS_DLG_TARGETNODE = "TargetNode";
const string CS_DLG_REMEMBERPAGE = "RememberPage";

// Some various variables
const string CS_DLG_PREFIX_NPC = "N";
const string CS_DLG_PREFIX_PC = "P";
const string CS_DLG_PREFIX_NEXT = "NE";
const string CS_DLG_PREFIX_PREVIOUS = "PR";
const string CS_DLG_PREFIX_BACK = "B";
const string CS_DLG_PREFIX_EXIT = "E";

const int CI_DLG_FIRSTTOKEN = 17000;

// Variables stored on the module in case we don't use NWNX
const string CS_DLG_MOD_DIALOGCOUNT = "dlg_Count";
const string CS_DLG_MOD_PREFIX = "dlg_DLG_";              // This will be the Identifier of the Dialogue
const string CS_DLG_MOD_ID = "dlg_ID_";
const string CS_DLG_MOD_TAG = "dlg_TAG_";
const string CS_DLG_MOD_DESCRIPTION = "dlg_DESC_";
const string CS_DLG_MOD_NODE = "dlg_NODE_";
