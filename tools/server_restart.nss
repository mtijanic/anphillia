#include "nwnx_admin"

void BootAll()
{
    ExportAllCharacters();
    object pc = GetFirstPC();
    while (pc != OBJECT_INVALID)
    {
        BootPC(pc, "Anphillia is updating, please log again in a minute");
        pc = GetNextPC();
    }
    WriteTimestampedLogEntry("All players booted");
}

void main()
{
    object oUsedBy = GetLastUsedBy();
    if (!GetIsDM(oUsedBy))
    {
        SendMessageToPC(oUsedBy, "Only a DM can initiate a server restart.");
        return;
    }

    WriteTimestampedLogEntry("Server restart requested.");
    AssignCommand(GetModule(), SpeakString("The server will restart in 1 minute.", TALKVOLUME_SHOUT));
    object pc = GetFirstPC();
    while (pc != OBJECT_INVALID)
    {
        SendMessageToPC(pc, "The server will restart in 1 minute.");
        pc = GetNextPC();
    }

    DelayCommand(60.0, BootAll());
    DelayCommand(63.0, NWNX_Administration_ShutdownServer());
}
