///////////////////////////////////////////////////////////////////////////////
// dlg_act_PC04
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: This script is fired when the player selects the "fourth" option in a dialogue


///////////
// Includes
//
#include "dlg_inc"

void main()
{
   // Get our PC object
   object oPC = GetPCSpeaker();
   // What dialog are we using?
   int iDialogID = GetLocalInt(oPC, CS_DLG_PC_DIALOGID);
   // Get the dialog script
   string sScript = GetLocalString(oPC, CS_DLG_PC_SCRIPT);
   // What node are we at?
   string sNode = GetLocalString(oPC, CS_DLG_PC_NODE);
   // What's the current page?
   int iPage = GetLocalInt(oPC, CS_DLG_PC_PAGE);
   // What's this option?
   int iOption = GetLocalInt(oPC, CS_DLG_PC_OPTIONX + "4_");
   // Reset the counter for the evaluation script
   SetLocalInt(oPC, CS_DLG_PC_TOKEN, 0);

   // Execute the Action Script
   struct STRUCT_DLG_NODEINFO strInfo;
   strInfo = dlg_GetNodeInfo(iDialogID, sNode + "P", iOption);
   SetLocalInt(oPC, CS_DLG_PC_CONDITIONAL_ID, -1);
   SetLocalInt(oPC, CS_DLG_PC_ACTION_ID, strInfo.Action);
   SetLocalString(oPC, CS_DLG_PC_NODETEXT, strInfo.Text);
   ExecuteScript(sScript, oPC);

   // What node did the player click?
   if (strInfo.Target != "0")
   {
      if (strInfo.Target != sNode)
      {
         sNode = strInfo.Target;
         SetLocalInt(oPC, CS_DLG_PC_PAGE, 0);
      }

      if (strInfo.RememberPage)
      {
         // Remember the current Page
         SetLocalString(oPC, CS_DLG_PC_NODE_BACKUP, sNode);
         SetLocalInt(oPC, CS_DLG_PC_PAGE_BACKUP, iPage);
      }
   }
   else
   {
      sNode = sNode + CS_DLG_PREFIX_PC + IntToString (iOption);
      // Remember to reset page number
      SetLocalInt(oPC, CS_DLG_PC_PAGE, 0);
   }

   // Set the new Node we're at
   SetLocalString(oPC, CS_DLG_PC_NODE, sNode);

   // Reset Options
   SetLocalInt(oPC, CS_DLG_PC_FIRSTOPTIONFORPAGE + "0", 1);
}
