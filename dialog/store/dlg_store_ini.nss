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

   iDialog = dlg_CreateDialog("dlg_store", "Generic Store Dialog");
    sTopNode = dlg_AddNPCNode(iDialog, "T", "Welcome.\nWhat can i do for you today?.");
        dlg_AddPCNode(iDialog, sTopNode, "Show me your wares.", -1, 1);
        dlg_AddExitOption(iDialog, sTopNode, "Nothing");
}
