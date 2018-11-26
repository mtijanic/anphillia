const string NOTE_TAG = "NOTE_ITEM";
// Note On used

void note_Finish(object oPC, object oNote)
{
    SendMessageToPC(oPC, "Note finished");
    DeleteLocalObject(oPC, "NOTE_CURRENT");
    DeleteLocalString(oPC, "ON_PLAYER_CHAT_SCRIPT");
    itemproperty ip = GetFirstItemProperty(oNote);
    while (GetIsItemPropertyValid(ip))
    {
        RemoveItemProperty(oNote, ip);
        ip = GetNextItemProperty(oNote);
    }
}

void note_Abort(object oPC, object oNote)
{
    SendMessageToPC(oPC, "Note writing aborted");
    DeleteLocalObject(oPC, "NOTE_CURRENT");
    DeleteLocalString(oPC, "ON_PLAYER_CHAT_SCRIPT");
    SetName(oNote, "");
    SetDescription(oNote, "");
}

void note_Clear(object oPC, object oNote)
{
    SendMessageToPC(oPC, "Note body cleared");
    SetName(oNote, "");
    SetDescription(oNote, " ");
}

void note_Preview(object oPC, object oNote)
{
    AssignCommand(oPC, ActionExamine(oNote));
}
void note_Title(object oPC, object oNote, string sTitle)
{
    SetName(oNote, sTitle);
    SendMessageToPC(oPC, "Note title set to '" + sTitle + "'");
}

void note_AddText(object oPC, object oNote, string sText)
{
    SetDescription(oNote, GetDescription(oNote) + "\n" + sText);
    SendMessageToPC(oPC, "Added text to note: " + sText);
}

void activate()
{
    object oNote = GetItemActivated();
    object oPC = GetItemActivator();

    object oCopy = GetItemActivatedTarget();
    if (GetTag(oNote) == GetTag(oCopy))
    {
        SetName(oNote, GetName(oCopy));
        SetDescription(oNote, GetDescription(oCopy));
        SendMessageToPC(oPC, "You copy '" + GetName(oNote) + "'");

        note_Finish(oPC, oNote);
        AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_READ, 0.5));
        return;
    }
    else if (oCopy != OBJECT_INVALID)
    {
        SendMessageToPC(oPC, "Only other notes can be targetted for copying");
        return;
    }

    SendMessageToPC(oPC, "New note started. Chat has been muted  Commands: \n" +
        "<text>        - Add <text> to the note\n" +
        "/title <text> - Specify the note title, overriding previous title\n" +
        "/finish       - End note editing and save item \n" +
        "/clear        - Delete entire note (except title) and start over\n" +
        "/preview      - Show the note state so far\n" +
        "/abort        - Abandon note taking\n");
    SetLocalString(oPC, "ON_PLAYER_CHAT_SCRIPT", "note");
    SetLocalObject(oPC, "NOTE_CURRENT", oNote);
    SetDescription(oNote, " ");
    SetName(oNote, "Note");
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_READ, 0.2));
}

void onchat()
{
    object oPC = GetPCChatSpeaker();
    string sMessage = GetPCChatMessage();

    object oNote = GetLocalObject(oPC, "NOTE_CURRENT");
    if (GetItemPossessor(oNote) != oPC)
    {
        note_Abort(oPC, oNote);
        return;
    }

    if (GetStringLeft(sMessage, 6) == "/title")
    {
        note_Title(oPC, oNote, GetSubString(sMessage, 6, GetStringLength(sMessage)-6));
        AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
    }
    else if (GetStringLeft(sMessage, 6) == "/clear")
    {
        note_Clear(oPC, oNote);
        AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
    }
    else if (GetStringLeft(sMessage, 8) == "/preview")
    {
        AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
        note_Preview(oPC, oNote);
    }
    else if (GetStringLeft(sMessage, 7) == "/finish")
    {
        note_Finish(oPC, oNote);
    }
    else if (GetStringLeft(sMessage, 6) == "/abort")
    {
        note_Abort(oPC, oNote);
    }
    else
    {
        note_AddText(oPC, oNote, sMessage);
    }
    SetPCChatMessage("");
}


void main()
{
    switch (GetLocalInt(OBJECT_SELF, "CURRENT_SCRIPT"))
    {
        case EVENT_SCRIPT_MODULE_ON_ACTIVATE_ITEM: activate(); return;
        case EVENT_SCRIPT_MODULE_ON_PLAYER_CHAT:   onchat(); return;
    }
}
