///////////////////////////////////////////////////////////////////////////////
// dlg_act_back
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: This script fires when the player hits the "Back" button


///////////
// Includes
//
#include "dlg_inc"

void main()
{
   int iOption = 1;
   // Get our PC object
   object oPC = GetPCSpeaker();
   // What dialog are we using?
   int iDialogID = GetLocalInt(oPC, CS_DLG_PC_DIALOGID);
   // Get the dialog script
   string sScript = GetLocalString(oPC, CS_DLG_PC_SCRIPT);
   // What node are we at?
   string sNode = GetLocalString(oPC, CS_DLG_PC_NODE);
   // Reset the current page?
   int iPage = GetLocalInt(oPC, CS_DLG_PC_PAGE);
   // Reset the counter for the evaluation script
   SetLocalInt(oPC, CS_DLG_PC_TOKEN, 0);

   // Execute the Action Script
   struct STRUCT_DLG_NODEINFO strInfo;
   strInfo = dlg_GetNodeInfo(iDialogID, sNode + CS_DLG_PREFIX_BACK, iOption);
   SetLocalInt(oPC, CS_DLG_PC_CONDITIONAL_ID, -1);
   SetLocalInt(oPC, CS_DLG_PC_ACTION_ID, strInfo.Action);
   SetLocalString(oPC, CS_DLG_PC_NODETEXT, strInfo.Text);
   ExecuteScript(sScript, oPC);

   // Set the new Node we're at
   SetLocalString(oPC, CS_DLG_PC_NODE, strInfo.Target);

   // Reset the page
   SetLocalInt(oPC, CS_DLG_PC_PAGE, 0);

   // Reset Options
   SetLocalInt(oPC, CS_DLG_PC_FIRSTOPTIONFORPAGE + "0", 1);
}
