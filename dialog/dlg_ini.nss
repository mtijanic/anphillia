///////////////////////////////////////////////////////////////////////////////
// dlg_ini
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: Initialization File for the Dialogue System

///////////
// Includes
//
#include "dlg_inc"
#include "x3_inc_string"

//#include "god_inc"

////////////////
// Function Code
//

void Log(object oLog, string sDialog)
{
    SetDescription(oLog, GetDescription(oLog) + "\nDLG_ - inserted '" + sDialog + "'");
    WriteTimestampedLogEntry("DLG - '" + sDialog + "' inserted to DB");
}

void Init(object oMod, object oLog, string sDialogScript)
{
    ExecuteScript(sDialogScript, oMod);
    Log(oLog, sDialogScript);
}

void InitAll(object oLog)
{
    object oMod = GetModule();

    DelayCommand(0.1, Init(oMod, oLog, "dlg_lgs_ini"));
    DelayCommand(0.1, Init(oMod, oLog, "dlg_store_ini"));
    DelayCommand(0.1, Init(oMod, oLog, "dlg_wand_ini"));
    DelayCommand(0.1, Init(oMod, oLog, "dlg_model_ini"));
}

void main()
{
    // If all tables exist, do not (re)initialize
    object oLog = GetObjectByTag("LOG");
    if (dlg_GetTablesExist())
    {
        SetDescription(oLog, GetDescription(oLog) + "\nDLG - database already exists.");
        WriteTimestampedLogEntry("DLG - database already exists - skipping initialization.");
        return;
    }

    // Drop any existing tables
    dlg_DropTables();

    // Create Tables
    dlg_CreateTables();

    // Initialize table content
    DelayCommand(0.1, InitAll(oLog));
}
