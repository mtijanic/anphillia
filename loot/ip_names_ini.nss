///////////////////////////////////////////////////////////////////////////////
// ipnames_ini
// written by: eyesolated
// written at: June 17, 2004
//
// Notes: IP Name Initialization

///////////
// Includes
//
#include "eas_inc"
#include "color_inc"
#include "egs_inc"
#include "ip_inc"
#include "eas_inc"

void InitAll()
{
   object oLog = GetObjectByTag("LOG");

   // Let's setup our properties
   ip_InitializeItemNames_01();
   ip_InitializeItemNames_02();
   ip_InitializeItemNames_03();
   ip_InitializeItemNames_04();
   ip_InitializeItemNames_05();
   ip_InitializeItemNames_06();
   ip_InitializeItemNames_07();
   ip_InitializeItemNames_08();
   ip_InitializeItemNames_09();

   SetDescription(oLog, GetDescription(oLog) + "\nIP - Item Names initialized.");
   WriteTimestampedLogEntry("IP - Item Names initialized.");
}

void main()
{
    // If all tables exist, do not (re)initialize
    if (ip_GetNameTableExists())
    {
        object oLog = GetObjectByTag("LOG");
        SetDescription(oLog, GetDescription(oLog) + "\nIP_Names - database already exists.");
        WriteTimestampedLogEntry("IP_Names - database already exists - skipping initialization.");
        return;
    }

    // Drop any existing tables
    ip_DropNameTable();

    // Create table
    ip_CreateNameTable();

    // Initialize
    DelayCommand(0.2, InitAll());
}
