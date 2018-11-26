///////////////////////////////////////////////////////////////////////////////
// datetime_inc
// written by: eyesolated
// written at: July 29, 2004
//
// Notes:


///////////
// Includes
//
#include "sql_inc"
#include "mod_cfg"
#include "datetime_cfg"

///////////////////////
// Function Declaration
//

// Help
void datetime_Help();

// Gets the current Date/Time in form of a struct that holds all the date/time
// integers
struct STRUCT_DATETIME datetime_GetCurrentDateTime();

// Returns the number of hours (in-game hours) that have passed since server
// start. (Lowest possible checkup = Hours).
// NOTE: the second Date/Time has to be the LATER one!!!
struct STRUCT_DATETIME datetime_TimeDifference(struct STRUCT_DATETIME DateTime1, struct STRUCT_DATETIME DateTime2);

// Drops/Creates the DateTime Table
void datetime_CreateTable();

// Sets dtDateTime on oObject
void SetLocalDateTime(object oObject, struct STRUCT_DATETIME dtDateTime);

// Gets last set DateTime from oObject
struct STRUCT_DATETIME GetLocalDateTime(object oObject);

// Saves the current Date/Time to the SQL Database
void datetime_SaveCurrentDateTime();

// Loads the last saved Date/Time out of the Database and sets the Mod to that
// Time. Returns FALSE on error
int datetime_LoadDateTime();

////////////////
// Function Code
//
void datetime_Help()
{
}

struct STRUCT_DATETIME datetime_GetCurrentDateTime()
{
   struct STRUCT_DATETIME strResult;
   strResult.Year = GetCalendarYear();
   strResult.Month = GetCalendarMonth();
   strResult.Day = GetCalendarDay();
   strResult.Hour = GetTimeHour();
   strResult.Minute = GetTimeMinute();
   strResult.Second = GetTimeSecond();
   strResult.Millisecond = GetTimeMillisecond();
   return (strResult);
}

struct STRUCT_DATETIME datetime_TimeDifference(struct STRUCT_DATETIME DateTime1, struct STRUCT_DATETIME DateTime2)
{
   struct STRUCT_DATETIME strResult;

   // Convert the first Date/Time Value into minutes
   int iMinutes1 = DateTime1.Year * 12 * 28 * 24 * 60;
   iMinutes1 += DateTime1.Month * 28 * 24 * 60;
   iMinutes1 += DateTime1.Day * 24 * 60;
   iMinutes1 += DateTime1.Hour * 60;
   iMinutes1 += DateTime1.Minute;

   // Convert the second Date/Time Value into minutes
   int iMinutes2 = DateTime2.Year * 12 * 28 * 24 * 60;
   iMinutes2 += DateTime2.Month * 28 * 24 * 60;
   iMinutes2 += DateTime2.Day * 24 * 60;
   iMinutes2 += DateTime2.Hour * 60;
   iMinutes2 += DateTime2.Minute;

   // Get the difference in minutes between the two values
   int iDifferenceInMinutes = iMinutes2 - iMinutes1;
   // Do a modulo operation to find out the Minutes
   strResult.Minute = iDifferenceInMinutes % 60;

   // Get the difference in hours between the two values
   int iDifferenceInHours = (iDifferenceInMinutes - strResult.Minute) / 60;
   // Do a modulo operation to find out the Hours
   strResult.Hour = iDifferenceInHours % 24;

   // Get the difference in days between the two values
   int iDifferenceInDays = (iDifferenceInHours - strResult.Hour) / 24;
   // Do a modulo operation to find out the days
   strResult.Day = iDifferenceInDays % 28;

   // Get the difference in months between the two values
   int iDifferenceInMonths = (iDifferenceInDays - strResult.Day) / 28;
   // Do a modulo operation to find out the days
   strResult.Month = iDifferenceInMonths % 12;

   // Get the difference in years between the two values
   int iDifferenceInYears = (iDifferenceInMonths - strResult.Month) / 12;
   // Do a modulo operation to find out the days
   strResult.Year = iDifferenceInYears;

   return (strResult);
}

void SetLocalDateTime(object oObject, struct STRUCT_DATETIME dtDateTime)
{
    SetLocalInt(oObject, CS_VAR_DATETIME_YEAR, dtDateTime.Year);
    SetLocalInt(oObject, CS_VAR_DATETIME_MONTH, dtDateTime.Month);
    SetLocalInt(oObject, CS_VAR_DATETIME_DAY, dtDateTime.Day);
    SetLocalInt(oObject, CS_VAR_DATETIME_HOUR, dtDateTime.Hour);
    SetLocalInt(oObject, CS_VAR_DATETIME_MINUTE, dtDateTime.Minute);
    SetLocalInt(oObject, CS_VAR_DATETIME_SECOND, dtDateTime.Second);
}

struct STRUCT_DATETIME GetLocalDateTime(object oObject)
{
    struct STRUCT_DATETIME dtResult;
    dtResult.Year = GetLocalInt(oObject, CS_VAR_DATETIME_YEAR);
    dtResult.Month = GetLocalInt(oObject, CS_VAR_DATETIME_MONTH);
    dtResult.Day = GetLocalInt(oObject, CS_VAR_DATETIME_DAY);
    dtResult.Hour = GetLocalInt(oObject, CS_VAR_DATETIME_HOUR);
    dtResult.Minute = GetLocalInt(oObject, CS_VAR_DATETIME_MINUTE);
    dtResult.Second = GetLocalInt(oObject, CS_VAR_DATETIME_SECOND);
    return dtResult;
}

void datetime_CreateTable()
{
  // Uses generic variable table
}

void datetime_SaveCurrentDateTime()
{
    int year = GetCalendarYear();
    int month = GetCalendarMonth();
    int day = GetCalendarDay();
    int hour = GetTimeHour();
    int minute = GetTimeMinute();
    int sec = GetTimeSecond();
    int msec = GetTimeMillisecond();

    //SetTime(hour, min, sec, msec);

    sql_SetVar(CS_DATETIME_YEAR,        IntToString(year));
    sql_SetVar(CS_DATETIME_MONTH,       IntToString(month));
    sql_SetVar(CS_DATETIME_DAY,         IntToString(day));
    sql_SetVar(CS_DATETIME_HOUR,        IntToString(hour));
    sql_SetVar(CS_DATETIME_MINUTE,      IntToString(minute));
    sql_SetVar(CS_DATETIME_SECOND,      IntToString(sec));
    sql_SetVar(CS_DATETIME_MILLISECOND, IntToString(msec));
}

int datetime_LoadDateTime()
{
    int year  = StringToInt(sql_GetVar(CS_DATETIME_YEAR));
    if (year == 0)
        return FALSE;

    int month = StringToInt(sql_GetVar(CS_DATETIME_MONTH));
    int day   = StringToInt(sql_GetVar(CS_DATETIME_DAY));
    int hour  = StringToInt(sql_GetVar(CS_DATETIME_HOUR));
    int minute= StringToInt(sql_GetVar(CS_DATETIME_MINUTE));
    int sec   = StringToInt(sql_GetVar(CS_DATETIME_SECOND));
    int msec  = StringToInt(sql_GetVar(CS_DATETIME_MILLISECOND));

    SetCalendar(year, month, day);
    SetTime(hour, minute, sec, msec);

    return TRUE;
}
