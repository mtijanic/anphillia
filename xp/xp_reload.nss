#include "xp_inc"

void _initDefaults()
{
    // These will fail if anything exists in the database
    int lvl;
    for (lvl = 1; lvl <= 16; lvl++)
        NWNX_SQL_ExecuteQuery("INSERT INTO "+SQL_TABLE_XPDATA+" (Level) VALUES("+IntToString(lvl)+")");
}
void main()
{
    WriteTimestampedLogEntry("XP reload");
    _initDefaults();
    xp_ReloadTables();
}
