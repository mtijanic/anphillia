/************************************************************************
 * script name  : pat_ini
 * created by   : eyesolated
 * date         : 2018/7/31
 *
 * description  : Initialization script for PAT
 *
 * changes      : 2018/7/31 - eyesolated - Initial creation
 ************************************************************************/
#include "pat_inc"

void Initialize_Base(object oMod, object PAT_Cache)
{
    // Initialize Roles
    ExecuteScript("pat_ini_base", oMod);
    SetDescription(PAT_Cache, GetDescription(PAT_Cache) + "\nPAT - Initialized Roles.");
}

void Initialize_ClassSetups(object oMod, object PAT_Cache)
{
    // Initialize Class Setups
    ExecuteScript("pat_ini_class", oMod);
    SetDescription(PAT_Cache, GetDescription(PAT_Cache) + "\nPAT - Initialized Class Setups.");
}

void Initialize_Spells(object oMod, object PAT_Cache)
{
    // Initialize Spells
    ExecuteScript("pat_ini_spells", oMod);
    SetDescription(PAT_Cache, GetDescription(PAT_Cache) + "\nPAT - Initialized Spells.");
}

void Initialize_Featpacks(object oMod, object PAT_Cache)
{
    // Initialize Feat Packs
    ExecuteScript("pat_ini_featpack", oMod);
    SetDescription(PAT_Cache, GetDescription(PAT_Cache) + "\nPAT - Initialized Feat Packs.");
}

void Initialize_Skillsets(object oMod, object PAT_Cache)
{
    // Initialize Skill Sets
    ExecuteScript("pat_ini_skillset", oMod);
    SetDescription(PAT_Cache, GetDescription(PAT_Cache) + "\nPAT - Initialized Skill Sets.");
}

void Initialize_Areas(object oMod, object PAT_Cache)
{
    // Initialize Areas
    ExecuteScript("pat_ini_areas", oMod);
    SetDescription(PAT_Cache, GetDescription(PAT_Cache) + "\nPAT - Initialized Areas.");
}

void Initialize_All(object oMod)
{
    object PAT_Cache = pat_GetCache();

    DelayCommand(0.1f, Initialize_Base(oMod, PAT_Cache));
    DelayCommand(0.2f, Initialize_ClassSetups(oMod, PAT_Cache));
    DelayCommand(0.3f, Initialize_Spells(oMod, PAT_Cache));
    DelayCommand(0.4f, Initialize_Featpacks(oMod, PAT_Cache));
    DelayCommand(0.5f, Initialize_Skillsets(oMod, PAT_Cache));
    DelayCommand(0.6f, Initialize_Areas(oMod, PAT_Cache));
}

void main()
{
    // If all tables exist, do not (re)initialize
    if (pat_GetTablesExist())
    {
        object oLog = GetObjectByTag("LOG");
        SetDescription(oLog, GetDescription(oLog) + "\nPAT - database already exists.");
        WriteTimestampedLogEntry("PAT - database already exists - skipping initialization.");
        return;
    }

    // Drop any existing tables
    pat_DropTables();

    // Create all tables
    pat_CreateTables();

    object oMod = GetModule();
    DelayCommand(0.2, Initialize_All(oMod));
}
