///////////////////////////////////////////////////////////////////////////////
// dlg_start
// written by: eyesolated
// written at: March 31, 2015
//
// Notes: Starts a conersation between the PC and the object calling this script
//        If the caller is an NPC, this will be a normal conversation.
//        If the caller is an object, the PC will talk to himself.
//
//        The conversation that will be started needs to be saved on the
//        calling object as a string variable named "DLG"
#include "dlg_inc"

void main()
{
    // Get the type of the calling instance
    object oPC;
    object oConversationPartner;
    int Caller_Type = GetObjectType(OBJECT_SELF);
    if (Caller_Type == OBJECT_TYPE_CREATURE)
    {
        oPC = GetLastSpeaker();
        oConversationPartner = OBJECT_SELF;
    }
    else
    {
        oPC = GetLastUsedBy();
        oConversationPartner = oPC;
    }

    string sDialog = GetLocalString(OBJECT_SELF, "DLG");
    dlg_StartConversation(sDialog, oConversationPartner, oPC);
}
