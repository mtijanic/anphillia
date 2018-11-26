#include "nwnx_sql"
#include "dbg_inc"
#include "util_inc"

const string SQL_TABLE_CHARDATA         = "chardata";
const string SQL_TABLE_PVPKILLS         = "pvpkills";
const string SQL_TABLE_STORAGECHESTS    = "storagechests";
const string SQL_TABLE_PLAYERCHESTS     = "playerchests";
const string SQL_TABLE_LEVELUPS         = "levelups";
const string SQL_TABLE_TEAM             = "team";
const string SQL_TABLE_MISCDATA         = "miscdata";
const string SQL_TABLE_FACTIONS         = "factions";
const string SQL_TABLE_FACTIONRELATIONS = "factionrelations";
const string SQL_TABLE_XPDATA           = "xpdata";
const string SQL_TABLE_PAYOUTS          = "payouts";
const string SQL_TABLE_PAYOUTDATA       = "payoutdata";


// Create all the necessary tables if they don't exist
void sql_CreateTables();

// Insert a new PC into the database, returning their unique PCID
int sql_RegisterNewPC(object pc);

// Update a PCs stats in the database.
// Arguments left as -1 are not updated
void sql_UpdatePC(int pcid, location loc, int hp=-1, int xp=-1, int faction=-1);

// Check whether the PC is registered as dead
int sql_GetPCDead(int pcid);
// Set the PC's dead status in the database
void sql_SetPCDead(int pcid, int dead);

// Set a generic variable in the DB
void sql_SetVar(string varname, string value);
// Get a generic variable from the DB
string sql_GetVar(string varname);

// Returns the stored HP value for given PCID
int sql_GetPCHP(int pcid);

// Returns the stored location for given PCID
location sql_GetPCLocation(int pcid);

// Get the PCID from the database
int sql_GetPCID(object pc);

// Log the PvP kill in the database
void sql_LogPvPDeath(int killer, int deadguy, location loc);

// Returns the stored HP value for given PCID
int sql_GetPCFaction(int pcid);

// Sets whether the PC is online currently
void sql_SetPCOnline(int pcid, int online, int playtime=0);

string SQLExecAndFetchString(string sQuery);
int SQLExecAndFetchInt(string sQuery);
float SQLExecAndFetchFloat(string sQuery);

void sql_CreateTables()
{
    string chardata = SQL_TABLE_CHARDATA + " (" +
        "PCID      int          NOT NULL AUTO_INCREMENT PRIMARY KEY, " +
        "CDKey     varchar(16)  NOT NULL DEFAULT '', "     +
        "Name      varchar(128) NOT NULL DEFAULT '', "     +
        "Title     varchar(32)  NOT NULL DEFAULT '', "     +
        "Location  varchar(128) NOT NULL DEFAULT '', "     +
        "HitPoints int          NOT NULL DEFAULT 0,  "     +
        "XP        int          NOT NULL DEFAULT 0,  "     +
        "Faction   int          NOT NULL DEFAULT 0,  "     +
        "Deaths    int          NOT NULL DEFAULT 0,  "     +
        "PVPKills  int          NOT NULL DEFAULT 0,  "     +
        "IsDead    int          NOT NULL DEFAULT 0,  "     +
        "Playtime  int          NOT NULL DEFAULT 0,  "     +
        "IsOnline  int          NOT NULL DEFAULT 0,  "     +
        "XPMultiplier  float    NOT NULL DEFAULT 1.0, " +
        "XPBanked      int      NOT NULL DEFAULT 0, " +
        "XPUnflushed   int      NOT NULL DEFAULT 0, " +
        "XPLastFlush   int      NOT NULL DEFAULT 0, " +
        "XPLost        int      NOT NULL DEFAULT 0, " +
        "DonatedStuff  int      NOT NULL DEFAULT 0, " +
        "LastLogin timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP," +
        "LastIP    varchar(20)  NOT NULL DEFAULT ''" +
        ") AUTO_INCREMENT=1";

    string pvpkills =  SQL_TABLE_PVPKILLS + " (" +
        "KillerID    int          NOT NULL, " +
        "DeadGuyID   int          NOT NULL, " +
        "Location    varchar(128) NOT NULL DEFAULT '', "     +
        "Time        timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP" +
        ")";

    string storagechests = SQL_TABLE_STORAGECHESTS + " (" +
        "ID          int         NOT NULL AUTO_INCREMENT PRIMARY KEY, " +
        "Tag         varchar(32) NOT NULL, " +
        "Object      TEXT        NOT NULL, " +
        "Name        varchar(64) NOT NULL DEFAULT '', " +
        "AddedByPCID int         NOT NULL DEFAULT -1, " +
        "Time        timestamp   NOT NULL DEFAULT CURRENT_TIMESTAMP" +
        ") AUTO_INCREMENT=1";

    string playerchests = SQL_TABLE_PLAYERCHESTS + " (" +
        "ID          int         NOT NULL AUTO_INCREMENT PRIMARY KEY, " +
        "PCID        int         NOT NULL, " +
        "Tag         varchar(32) NOT NULL, " +
        "Name        varchar(64) NOT NULL DEFAULT '', " +
        "Object      TEXT        NOT NULL"   +
        ")";

    string levelups = SQL_TABLE_LEVELUPS + " (" +
        "PCID        int        NOT NULL, " +
        "Level       int        NOT NULL, " +
        "ClassTaken  int        NOT NULL, " +
        "Time        timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP" +
        ")";

    string team = SQL_TABLE_TEAM + " (" +
        "Username  varchar(64) NOT NULL DEFAULT '', "     +
        "CDKey     varchar(16) NOT NULL DEFAULT '', "     +
        "LastLogin timestamp   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP," +
        "LastIP    varchar(20) NOT NULL DEFAULT ''" +
        ")";

    string miscdata = SQL_TABLE_MISCDATA + " (" +
        "Varname     varchar(64)  NOT NULL PRIMARY KEY, " +
        "Value       varchar(128) NOT NULL DEFAULT '',  " +
        "Time        timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" +
        ")";

    string factions = SQL_TABLE_FACTIONS + " (" +
        "ID            int          NOT NULL PRIMARY KEY, " +
        "Name          varchar(64)  NOT NULL, " +
        "StartingLoc   varchar(32)  NOT NULL, " +
        "FugueLoc      varchar(32)  NOT NULL, " +
        "DreamLoc      varchar(32)  NOT NULL, " +
        "ItemKey       varchar(16), " +
        "ItemHorn      varchar(16), " +
        "ItemRing      varchar(16), " +
        "ItemOther     varchar(16), " +
        "Population    int          NOT NULL DEFAULT 0, " +
        "Gold          int          NOT NULL DEFAULT 0, " +
        "Arms          int          NOT NULL DEFAULT 0, " +
        "Armor         int          NOT NULL DEFAULT 0, " +
        "Magic         int          NOT NULL DEFAULT 0, " +
        "XPMultiplier  float        NOT NULL DEFAULT 1.0 " +
        ")";

    string factionrelations = SQL_TABLE_FACTIONRELATIONS + " (" +
        "Faction1    int          NOT NULL, " +
        "Faction2    int          NOT NULL, " +
        "Relation    int          NOT NULL, " +
        "PRIMARY KEY (Faction1, Faction2))";

    string xpdata = SQL_TABLE_XPDATA + " (" +
        "Level                  int          NOT NULL PRIMARY KEY, " +
        "MultiplierAll          float        NOT NULL DEFAULT 1.0, " +
        "MultiplierCombat       float        NOT NULL DEFAULT 1.0, " +
        "MultiplierExploration  float        NOT NULL DEFAULT 1.0, " +
        "MultiplierTimed        float        NOT NULL DEFAULT 1.0, " +
        "Threshold1             int          NOT NULL DEFAULT 1000, " +
        "Throttle1              float        NOT NULL DEFAULT 0.8, " +
        "Threshold2             int          NOT NULL DEFAULT 2000, " +
        "Throttle2              float        NOT NULL DEFAULT 0.5, " +
        "Threshold3             int          NOT NULL DEFAULT 3000, " +
        "Throttle3              float        NOT NULL DEFAULT 0.2, " +
        "PenaltyDeath           float        NOT NULL DEFAULT 0.05, " +
        "PenaltyOrb             float        NOT NULL DEFAULT 0.1, " +
        "PenaltyScalp           float        NOT NULL DEFAULT 0.05, " +
        "MaxPerRest             int          NOT NULL DEFAULT 750 " +
        ")";

    string payouts = SQL_TABLE_PAYOUTS + " (" +
        "ID           int NOT NULL AUTO_INCREMENT PRIMARY KEY, " +
        "PCID         int NOT NULL," +
        "Faction      int NOT NULL," +
        "Timestamp    int NOT NULL," +
        "Stuff        varchar(512) NOT NULL," +
        "Walltime     timestamp   NOT NULL DEFAULT CURRENT_TIMESTAMP" +
        ")";

    string payoutdata = SQL_TABLE_PAYOUTDATA + " (" +
        "ID             int         NOT NULL AUTO_INCREMENT PRIMARY KEY, " +
        "Faction        int         NOT NULL," +
        "Item           varchar(16) NOT NULL," +
        "Pool           varchar(16) NOT NULL DEFAULT 'gold'," +
        "BaseAmount     int         NOT NULL DEFAULT 1," +
        "ExtraPerLevel  float       NOT NULL DEFAULT 1.0," +
        "CostMultiplier float       NOT NULL DEFAULT 1.0," +
        "IsActive       int         NOT NULL DEFAULT 1," +
        "MinLevel       int         NOT NULL DEFAULT 2" +
        ")";

    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS " + chardata);
    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS " + pvpkills);
    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS " + storagechests);
    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS " + playerchests);
    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS " + levelups);
    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS " + team);
    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS " + miscdata);
    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS " + factions);
    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS " + factionrelations);
    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS " + xpdata);
    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS " + payouts);
    NWNX_SQL_ExecuteQuery("CREATE TABLE IF NOT EXISTS " + payoutdata);
}

string SQLExecAndFetchString(string sQuery)
{
    NWNX_SQL_ExecuteQuery(sQuery);
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        return NWNX_SQL_ReadDataInActiveRow();
    }
    return "";
}

int SQLExecAndFetchInt(string sQuery)
{
    return StringToInt(SQLExecAndFetchString(sQuery));
}

float SQLExecAndFetchFloat(string sQuery)
{
    return StringToFloat(SQLExecAndFetchString(sQuery));
}

int sql_RegisterNewPC(object pc)
{
    int pcid = sql_GetPCID(pc);
    if (pcid)
    {
        if (!GetIsDM(pc))
            dbg_Warning("PC already registered in the database as PCID " + IntToString(pcid), pc);
        return pcid;
    }

    string query = "INSERT INTO "+SQL_TABLE_CHARDATA+"(CDKey, Name, HitPoints, XP, LastIP) VALUES(?,?,?,?,?)";
    if (!NWNX_SQL_PrepareQuery(query))
    {
        WriteTimestampedLogEntry("[ERROR] Failed to prepare query for registering characters");
        return -1;
    }

    NWNX_SQL_PreparedString(0, GetPCPublicCDKey(pc));
    NWNX_SQL_PreparedString(1, GetName(pc));
    NWNX_SQL_PreparedInt(2, GetCurrentHitPoints(pc));
    NWNX_SQL_PreparedInt(3, GetXP(pc));
    NWNX_SQL_PreparedString(4, GetPCIPAddress(pc));

    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        WriteTimestampedLogEntry("[ERROR] Failed to execute query for registering characters");
        return -1;
    }

    NWNX_SQL_ExecuteQuery("SELECT MAX(PCID) FROM "+SQL_TABLE_CHARDATA+"");
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        return StringToInt(NWNX_SQL_ReadDataInActiveRow());
    }

    return -1;
}

void sql_UpdatePC(int pcid, location loc, int hp=-1, int xp=-1, int faction=-1)
{
    // Forget updating if location not valid..
    if (!GetIsObjectValid(GetAreaFromLocation(loc)))
        return;

    string query = "UPDATE "+SQL_TABLE_CHARDATA+" SET Location=?" +
                    (hp>=0      ? ", HitPoints=?" : "")     +
                    (xp>=0      ? ", XP=?"        : "")     +
                    (faction>=0 ? ", Faction=?"   : "")     +
                    " WHERE PCID=" + IntToString(pcid);

    NWNX_SQL_PrepareQuery(query);

    int arg = 0;
    NWNX_SQL_PreparedString(arg++, util_EncodeLocation(loc));
    if (hp>=0)      NWNX_SQL_PreparedInt(arg++, hp);
    if (xp>=0)      NWNX_SQL_PreparedInt(arg++, xp);
    if (faction>=0) NWNX_SQL_PreparedInt(arg++, faction);
    NWNX_SQL_ExecutePreparedQuery();
}

int sql_GetPCDead(int pcid)
{
    return SQLExecAndFetchInt("SELECT IsDead FROM "+SQL_TABLE_CHARDATA+" WHERE PCID=" + IntToString(pcid));
}

void sql_SetPCDead(int pcid, int dead)
{
    if (dead == sql_GetPCDead(pcid))
        return;

    if (dead)
        NWNX_SQL_ExecuteQuery("UPDATE "+SQL_TABLE_CHARDATA+" SET IsDead=1, Deaths=Deaths+1 WHERE PCID=" + IntToString(pcid));
    else
        NWNX_SQL_ExecuteQuery("UPDATE "+SQL_TABLE_CHARDATA+" SET IsDead=0 WHERE PCID=" + IntToString(pcid));

    if (NWNX_SQL_GetAffectedRows() != 1)
        WriteTimestampedLogEntry("[ERROR] Updating IsDead failed for PCID " + IntToString(pcid));
}

void sql_SetVar(string varname, string value)
{
    NWNX_SQL_PrepareQuery("INSERT INTO " + SQL_TABLE_MISCDATA + " (varname, value) VALUES(?,?) ON DUPLICATE KEY UPDATE value=?");
    NWNX_SQL_PreparedString(0, varname);
    NWNX_SQL_PreparedString(1, value);
    NWNX_SQL_PreparedString(2, value);
    NWNX_SQL_ExecutePreparedQuery();
    WriteTimestampedLogEntry(" > WRITING " + varname +": " + value);
}

string sql_GetVar(string varname)
{
    string value = "";
    NWNX_SQL_PrepareQuery("SELECT value FROM " + SQL_TABLE_MISCDATA + " WHERE varname=?");
    NWNX_SQL_PreparedString(0, varname);
    NWNX_SQL_ExecutePreparedQuery();
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        value = NWNX_SQL_ReadDataInActiveRow();
    }
    WriteTimestampedLogEntry(" > READING " + varname +": " + value);
    return value;
}

int sql_GetVarInt(string varname) { return StringToInt(sql_GetVar(varname)); }
void sql_SetVarInt(string varname, int value) { sql_SetVar(varname, IntToString(value)); }

// Returns the stored HP value for given PCID
int sql_GetPCHP(int pcid)
{
    return SQLExecAndFetchInt("SELECT HitPoints FROM "+SQL_TABLE_CHARDATA+" WHERE PCID=" + IntToString(pcid));
}

// Returns the stored location for given PCID
location sql_GetPCLocation(int pcid)
{
    NWNX_SQL_ExecuteQuery("SELECT Location FROM "+SQL_TABLE_CHARDATA+" WHERE PCID=" + IntToString(pcid));
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        return util_DecodeLocation(NWNX_SQL_ReadDataInActiveRow());
    }
    return Location(OBJECT_INVALID, Vector(), 0.0);
}

int sql_GetPCID(object pc)
{
    NWNX_SQL_PrepareQuery("SELECT PCID FROM "+SQL_TABLE_CHARDATA+" WHERE CDKey=? AND Name=?");
    NWNX_SQL_PreparedString(0, GetPCPublicCDKey(pc));
    NWNX_SQL_PreparedString(1, GetName(pc));
    NWNX_SQL_ExecutePreparedQuery();
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        return StringToInt(NWNX_SQL_ReadDataInActiveRow());
    }
    return 0;
}

void sql_LogPvPDeath(int killer, int deadguy, location loc)
{
    NWNX_SQL_PrepareQuery("INSERT INTO " + SQL_TABLE_PVPKILLS + " (KillerID, DeadGuyID, Location) VALUES(?,?,?)");
    NWNX_SQL_PreparedInt(0, killer);
    NWNX_SQL_PreparedInt(1, deadguy);
    NWNX_SQL_PreparedString(2, util_EncodeLocation(loc));
    NWNX_SQL_ExecutePreparedQuery();

    NWNX_SQL_ExecuteQuery("UPDATE " + SQL_TABLE_CHARDATA + " SET PVPKills=PVPKills + 1 WHERE PCID=" + IntToString(killer));
}

int sql_GetPCFaction(int pcid)
{
    return SQLExecAndFetchInt("SELECT Faction FROM "+SQL_TABLE_CHARDATA+" WHERE PCID=" + IntToString(pcid));
}

void sql_SetPCOnline(int pcid, int online, int playtime=0)
{
    NWNX_SQL_ExecuteQuery("UPDATE " + SQL_TABLE_CHARDATA + " SET IsOnline=" + IntToString(online) +
        " , Playtime=Playtime+" + IntToString(playtime) + " WHERE PCID=" + IntToString(pcid));
}

