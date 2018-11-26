///////////////////////////////////////////////////////////////////////////////
// dlg_gettexts
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: This script handles selection and setting of Custom Tokens in the
//        Dialogue System


///////////
// Includes
//
#include "dlg_inc"
#include "color_inc"

///////////////////////
// Function Declaration
//

////////////////
// Function Code
//

string ValidateNPCText(object oPC, int iDialogID, string sNode, string sScript, int iTry = 1)
{
   struct STRUCT_DLG_NODEINFO strInfo;
   strInfo = dlg_GetNodeInfo(iDialogID, sNode + "N", iTry);
   SetLocalInt(oPC, CS_DLG_PC_CONDITIONAL_ID, strInfo.Condition);
   SetLocalInt(oPC, CS_DLG_PC_ACTION_ID, -1);
   SetLocalString(oPC, CS_DLG_PC_NODETEXT, strInfo.Text);
   DeleteLocalInt(oPC, CS_DLG_PC_OVERRIDE);
   ExecuteScript(sScript, oPC);
   if ( GetLocalInt(oPC, CS_DLG_PC_RESULT ))
   {
      SetLocalInt(oPC, CS_DLG_PC_CONDITIONAL_ID, -1);
      SetLocalInt(oPC, CS_DLG_PC_ACTION_ID, strInfo.Action);
      ExecuteScript(sScript, oPC);
      if (GetLocalInt(oPC, CS_DLG_PC_OVERRIDE))
         strInfo.Text = GetLocalString(oPC, CS_DLG_OVERRIDETEXT);
      SetLocalString(oPC, CS_DLG_PC_NODE, sNode + CS_DLG_PREFIX_NPC + IntToString(iTry));
      return (strInfo.Text);
   }
   else
   {
      string sResult = ValidateNPCText(oPC, iDialogID, sNode, sScript, iTry + 1);
      return (sResult);
   }
}

string ValidateFirstPCText(object oPC, int iDialogID, string sNode, string sScript, int iOption = 1, int iPage = 1)
{
   struct STRUCT_DLG_NODEINFO strInfo;
   strInfo = dlg_GetNodeInfo(iDialogID, sNode + CS_DLG_PREFIX_PC, iOption);
   SetLocalInt(oPC, CS_DLG_PC_CONDITIONAL_ID, strInfo.Condition);
   SetLocalInt(oPC, CS_DLG_PC_ACTION_ID, -1);
   SetLocalString(oPC, CS_DLG_PC_NODETEXT, strInfo.Text);
   DeleteLocalInt(oPC, CS_DLG_PC_OVERRIDE);
   ExecuteScript(sScript, oPC);
   if ( GetLocalInt(oPC, CS_DLG_PC_RESULT ))
   {
      if (GetLocalInt(oPC, CS_DLG_PC_OVERRIDE))
         strInfo.Text = GetLocalString(oPC, CS_DLG_OVERRIDETEXT);
      SetLocalInt(oPC, CS_DLG_PC_OPTION1, iOption);
      SetLocalInt(oPC, CS_DLG_PC_FIRSTOPTIONFORPAGE + IntToString(iPage), iOption);
      SetLocalInt(oPC, CS_DLG_PC_CURRENTOPTIONFORPAGE + IntToString(iPage), iOption + 1);
      return (strInfo.Text);
   }
   else
   {
      int iPCOptions = dlg_GetNumberOfPCOptions(iDialogID, sNode);
      if (iPCOptions >= iOption + 1)
      {
         string sResult = ValidateFirstPCText(oPC, iDialogID, sNode, sScript, iOption + 1, iPage);
         return (sResult);
      }
      else
      {
         SetLocalInt(oPC, CS_DLG_PC_CURRENTOPTIONFORPAGE + IntToString(iPage), iOption + 1);
         return ("");
      }
   }
}

string ValidatePCText(object oPC, int iDialogID, string sNode, string sScript, int iOption = 1, int iPage = 1, int iVisibleOption = 1)
{
   struct STRUCT_DLG_NODEINFO strInfo;
   strInfo = dlg_GetNodeInfo(iDialogID, sNode + CS_DLG_PREFIX_PC, iOption);
   SetLocalInt(oPC, CS_DLG_PC_CONDITIONAL_ID, strInfo.Condition);
   SetLocalInt(oPC, CS_DLG_PC_ACTION_ID, -1);
   SetLocalString(oPC, CS_DLG_PC_NODETEXT, strInfo.Text);
   DeleteLocalInt(oPC, CS_DLG_PC_OVERRIDE);
   ExecuteScript(sScript, oPC);
   if ( GetLocalInt(oPC, CS_DLG_PC_RESULT ))
   {
      if (GetLocalInt(oPC, CS_DLG_PC_OVERRIDE))
         strInfo.Text = GetLocalString(oPC, CS_DLG_OVERRIDETEXT);
      SetLocalInt(oPC, CS_DLG_PC_OPTIONX + IntToString(iVisibleOption) + "_", iOption);
      SetLocalInt(oPC, CS_DLG_PC_CURRENTOPTIONFORPAGE + IntToString(iPage), iOption + 1);
      return (strInfo.Text);
   }
   else
   {
      int iPCOptions = dlg_GetNumberOfPCOptions(iDialogID, sNode);
      if (iPCOptions >= iOption + 1)
      {
         string sResult = ValidatePCText(oPC, iDialogID, sNode, sScript, iOption + 1, iPage, iVisibleOption);
         return (sResult);
      }
      else
      {
         SetLocalInt(oPC, CS_DLG_PC_CURRENTOPTIONFORPAGE + IntToString(iPage), iOption + 1);
         return ("");
      }
   }
}

string ValidateNextPagePCText(object oPC, int iDialogID, string sNode, string sScript, int iOption = 1, int iPage = 1)
{
   struct STRUCT_DLG_NODEINFO strInfo;
   strInfo = dlg_GetNodeInfo(iDialogID, sNode + CS_DLG_PREFIX_PC, iOption);
   SetLocalInt(oPC, CS_DLG_PC_CONDITIONAL_ID, strInfo.Condition);
   SetLocalInt(oPC, CS_DLG_PC_ACTION_ID, -1);
   SetLocalString(oPC, CS_DLG_PC_NODETEXT, strInfo.Text);
   DeleteLocalInt(oPC, CS_DLG_PC_OVERRIDE);
   ExecuteScript(sScript, oPC);
   if ( GetLocalInt(oPC, CS_DLG_PC_RESULT ))
   {
      if (GetLocalInt(oPC, CS_DLG_PC_OVERRIDE))
         strInfo.Text = GetLocalString(oPC, CS_DLG_OVERRIDETEXT);
      //SetLocalInt(oPC, CS_DLG_PC_OPTION6, iOption);
      SetLocalInt(oPC, CS_DLG_PC_FIRSTOPTIONFORPAGE + IntToString(iPage + 1), iOption);
      //SetLocalInt(oPC, CS_DLG_PC_CURRENTOPTIONFORPAGE + IntToString(iPage), iOption + 1);
      return (strInfo.Text);
   }
   else
   {
      int iPCOptions = dlg_GetNumberOfPCOptions(iDialogID, sNode);
      if (iPCOptions >= iOption + 1)
      {
         string sResult = ValidateNextPagePCText(oPC, iDialogID, sNode, sScript, iOption + 1, iPage);
         return (sResult);
      }
      else
      {
         //SetLocalInt(oPC, CS_DLG_PC_CURRENTOPTIONFORPAGE + IntToString(iPage), iOption + 1);
         return ("");
      }
   }
}

string ValidateExitText(object oPC, int iDialogID, string sNode, string sScript, int iOption = 1)
{
   struct STRUCT_DLG_NODEINFO strInfo;
   strInfo = dlg_GetNodeInfo(iDialogID, sNode + CS_DLG_PREFIX_EXIT, iOption);
   SetLocalInt(oPC, CS_DLG_PC_CONDITIONAL_ID, strInfo.Condition);
   SetLocalInt(oPC, CS_DLG_PC_ACTION_ID, -1);
   SetLocalString(oPC, CS_DLG_PC_NODETEXT, strInfo.Text);
   DeleteLocalInt(oPC, CS_DLG_PC_OVERRIDE);
   ExecuteScript(sScript, oPC);
   if ( GetLocalInt(oPC, CS_DLG_PC_RESULT ))
   {
      if (GetLocalInt(oPC, CS_DLG_PC_OVERRIDE))
         strInfo.Text = GetLocalString(oPC, CS_DLG_OVERRIDETEXT);
      SetLocalInt(oPC, CS_DLG_PC_CONDITIONAL_ID, -1);
      SetLocalInt(oPC, CS_DLG_PC_ACTION_ID, strInfo.Action);
      //ExecuteScript(sScript, oPC);
      return (strInfo.Text);
   }
   else
   {
      return ("");
   }
}

string ValidateJumpText(object oPC, int iDialogID, string sNode, string sScript, int iOption = 1)
{
   struct STRUCT_DLG_NODEINFO strInfo;
   strInfo = dlg_GetNodeInfo(iDialogID, sNode + CS_DLG_PREFIX_BACK, iOption);
   SetLocalInt(oPC, CS_DLG_PC_CONDITIONAL_ID, strInfo.Condition);
   SetLocalInt(oPC, CS_DLG_PC_ACTION_ID, -1);
   SetLocalString(oPC, CS_DLG_PC_NODETEXT, strInfo.Text);
   ExecuteScript(sScript, oPC);
   DeleteLocalInt(oPC, CS_DLG_PC_OVERRIDE);
   if ( GetLocalInt(oPC, CS_DLG_PC_RESULT ))
   {
      if (GetLocalInt(oPC, CS_DLG_PC_OVERRIDE))
         strInfo.Text = GetLocalString(oPC, CS_DLG_OVERRIDETEXT);
      return (strInfo.Text);
   }
   else
   {
      return ("");
   }
}

int StartingConditional()
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
    // What dialog object number are we using?
    int iDialogObject = GetLocalInt(oPC, CS_DLG_PC_DIALOGOBJECT);
    // Let's see how often we ran this script
    int iToken = GetLocalInt(oPC, CS_DLG_PC_TOKEN);
    // so which customtoken's text will we set?
    int iTokenToSet = CI_DLG_FIRSTTOKEN + iToken + (iDialogObject - 1) * 11;
    // Get the Previous Node we were at
    string sParentNode = GetLocalString(oPC, CS_DLG_PC_PARENTNODE);
    // What's the first dialoge option for this page?
    int iDialogOptionFirst = GetLocalInt(oPC, CS_DLG_PC_FIRSTOPTIONFORPAGE + IntToString(iPage));
    // What's the dialoge option we're at?
    int iDialogOption = GetLocalInt(oPC, CS_DLG_PC_CURRENTOPTIONFORPAGE + IntToString(iPage));
    // Get Backup Info
    string sNodeBackup = GetLocalString(oPC, CS_DLG_PC_NODE_BACKUP);
    if (sNodeBackup != "")
    {
        if (sNodeBackup == sNode)
        {
           int iPageBackup = GetLocalInt(oPC, CS_DLG_PC_PAGE_BACKUP);
           SetLocalInt(oPC, CS_DLG_PC_PAGE, iPageBackup);
           iPage = iPageBackup;
        }

        DeleteLocalString(oPC, CS_DLG_PC_NODE_BACKUP);
        DeleteLocalInt(oPC, CS_DLG_PC_PAGE_BACKUP);
    }

    struct STRUCT_DLG_NODEINFO strInfo;

    // Reset any conditional results on our PC
    // This variable MUST be set in your dialog-base script
    // if you want to use any conditionals
    SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);

    string sTokenText = "";
    int iPCOptions;

    switch (iToken)
    {
       // NPC Text
       case 0:
          // Rememer the initial node starter, we need that for next/previous
          SetLocalString(oPC, CS_DLG_PC_PARENTNODE, sNode);
          sTokenText = ValidateNPCText(oPC, iDialogID, sNode, sScript, 1);
          break;
       // PC Option #1
       case 1: sTokenText = ValidateFirstPCText(oPC, iDialogID, sNode, sScript, iDialogOptionFirst, iPage);
          break;
       // PC Option #2
       case 2: sTokenText = ValidatePCText(oPC, iDialogID, sNode, sScript, iDialogOption, iPage, 2);
          break;
       // PC Option #3
       case 3: sTokenText = ValidatePCText(oPC, iDialogID, sNode, sScript, iDialogOption, iPage, 3);
          break;
       // PC Option #4
       case 4: sTokenText = ValidatePCText(oPC, iDialogID, sNode, sScript, iDialogOption, iPage, 4);
          break;
       // PC Option #5
       case 5: sTokenText = ValidatePCText(oPC, iDialogID, sNode, sScript, iDialogOption, iPage, 5);
          break;
       // PC Option #6
       case 6: sTokenText = ValidatePCText(oPC, iDialogID, sNode, sScript, iDialogOption, iPage, 6);
          break;
       // Next Page
       case 7:
          // How many PC options are in the under the current node?
          iPCOptions = dlg_GetNumberOfPCOptions(iDialogID, sNode);
          if ( (iDialogOption - 1) < iPCOptions &&
               iPCOptions > 8)
          {
             sTokenText = ValidateNextPagePCText(oPC, iDialogID, sNode, sScript, iDialogOption, iPage);
             if (sTokenText != "")
                sTokenText = color_ConvertString("[ Next Page ]", COLOR_GREY);
          }
          else
          {
             sTokenText = ValidatePCText(oPC, iDialogID, sNode, sScript, iDialogOption, iPage, 7);
          }
          break;
       // Previous Page
       case 8:
          if (iPage > 0)
          {
             sTokenText = color_ConvertString("[ Previous Page ]", COLOR_GREY);
          }
          else if (iPCOptions == 8)
          {
             sTokenText = ValidatePCText(oPC, iDialogID, sNode, sScript, iDialogOption, iPage, 8);
          }
          break;
       // Jump to Node
       case 9: sTokenText = ValidateJumpText(oPC, iDialogID, sNode, sScript, 1);
               if (sTokenText != "")
                    sTokenText = color_ConvertString(sTokenText , COLOR_GREY);
          break;
       // Exit Dialog
       case 10: sTokenText = ValidateExitText(oPC, iDialogID, sNode, sScript, 1);
                if (sTokenText != "")
                    sTokenText = color_ConvertString(sTokenText , COLOR_BROWN);
          break;
    }

    SetLocalInt(oPC, CS_DLG_PC_TOKEN, iToken + 1);

    if (sTokenText != "")
    {
       SetCustomToken(iTokenToSet , sTokenText);
       return (TRUE);
    }
    else
    {
       return (FALSE);
    }
}
