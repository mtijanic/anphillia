///////////////////////////////////////////////////////////////////////////////
// datetime_ini
// written by: eyesolated
// written at: July 29, 2004
//
// Notes: The initialization script for the Date/Time System

/////////////
// Includes
//
#include "datetime_inc"

////////////
// Functions
//
void main()
{
   if (!datetime_LoadDateTime())
   {
      datetime_CreateTable();
      datetime_SaveCurrentDateTime();
   }
}
