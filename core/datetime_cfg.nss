///////////////////////////////////////////////////////////////////////////////
// datetime_cfg
// written by: eyesolated
// written at: July 29, 2004
//
// Notes:

const string CS_DATETIME_TABLE = "DateTime";

const string CS_DATETIME_ID = "DTC";

const string CS_DATETIME_YEAR = "Year";
const string CS_DATETIME_MONTH = "Month";
const string CS_DATETIME_DAY = "Day";

const string CS_DATETIME_HOUR = "Hour";
const string CS_DATETIME_MINUTE = "Minute";
const string CS_DATETIME_SECOND = "Second";
const string CS_DATETIME_MILLISECOND = "Millisecond";

struct STRUCT_DATETIME
{
   int Year;
   int Month;
   int Day;
   int Hour;
   int Minute;
   int Second;
   int Millisecond;
};

// Variables for local setting of dates
const string CS_VAR_DATETIME_YEAR = "datetime_yea";
const string CS_VAR_DATETIME_MONTH = "datetime_mon";
const string CS_VAR_DATETIME_DAY = "datetime_day";
const string CS_VAR_DATETIME_HOUR = "datetime_hou";
const string CS_VAR_DATETIME_MINUTE = "datetime_min";
const string CS_VAR_DATETIME_SECOND = "datetime_ses";
const string CS_VAR_DATETIME_MILLISECOND = "datetime_mil";
