///////////////////////////////////////////////////////////////////////////////
// dlg_example
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: the conditional/action script for the example dialog


///////////
// Includes
//
#include "eas_inc"
#include "color_inc"
#include "egs_inc"
#include "ip_inc"
#include "dlg_inc"
#include "store_inc"

///////////////////////
// Function Declaration
//

////////////////
// Function Code
//

void main()
{
   object oPC = OBJECT_SELF;
   object oNPC = GetLocalObject(oPC, CS_DLG_PC_CONVERSATIONNPC);
   int iConditional = GetLocalInt(oPC, CS_DLG_PC_CONDITIONAL_ID);
   int iAction = GetLocalInt(oPC, CS_DLG_PC_ACTION_ID);
   string sNodeText = GetLocalString(oPC, CS_DLG_PC_NODETEXT);


   switch (iConditional)
   {
      case -1: SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE); break;
   }

   switch (iAction)
   {
      case -1: break;
      case 1: ExecuteScript(CS_STORE_SCRIPT_OPEN, oNPC);
         break;
   }
}
