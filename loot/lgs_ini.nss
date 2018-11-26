///////////////////////////////////////////////////////////////////////////////
// lgs_ini
// written by: eyesolated
// written at: April 27, 2018
//
// Notes: Initialized LGS

///////////
// Includes
//
// Needs
#include "ip_inc"
//#include "x0_i0_treasure"
#include "mod_cfg"
#include "lgs_cfg"

///////////////////////
// Function Declaration
//

void main()
{
    // Place Chests
    int nth = 0;
    object oWaypoint = GetObjectByTag(CS_LGS_CHEST_VAR_WAYPOINT, nth);
    object oChest;
    int nLockDC;
    while (GetIsObjectValid(oWaypoint))
    {
        oChest = CreateObject(OBJECT_TYPE_PLACEABLE, CS_LGS_CHEST_VAR_RESREF, GetLocation(oWaypoint), FALSE, CS_LGS_CHEST_VAR_RESREF);

        nLockDC = GetLocalInt(oWaypoint, CS_LGS_CHEST_VAR_LOCKDC);
        // Save Waypoint Variables on Chest
        SetLocalInt(oChest, CS_LGS_CHEST_VAR_LOCKCHANCE, GetLocalInt(oWaypoint, CS_LGS_CHEST_VAR_LOCKCHANCE));
        SetLocalInt(oChest, CS_LGS_CHEST_VAR_LOCKDC, nLockDC);
        SetLocalInt(oChest, CS_LGS_CHEST_VAR_TRAPCHANCE, GetLocalInt(oWaypoint, CS_LGS_CHEST_VAR_TRAPCHANCE));
        SetLocalInt(oChest, CS_LGS_CHEST_VAR_TRAPSTRENGTH, GetLocalInt(oWaypoint, CS_LGS_CHEST_VAR_TRAPSTRENGTH));
        SetLocalInt(oChest, CS_LGS_CHEST_VAR_TRAPDETECTDC, GetLocalInt(oWaypoint, CS_LGS_CHEST_VAR_TRAPDETECTDC));
        SetLocalInt(oChest, CS_LGS_CHEST_VAR_TRAPDISARMDC, GetLocalInt(oWaypoint, CS_LGS_CHEST_VAR_TRAPDISARMDC));

        // Set the chests hardness and fortitude save
        nLockDC -= 20;
        if (nLockDC < 5)
            nLockDC = 5;
        SetHardness(nLockDC , oChest);
        SetFortitudeSavingThrow(oChest, nLockDC + 10);

        // Set the chests hitpoints
        SetLocalInt(oChest, CS_LGS_CHEST_VAR_HITPOINTS, nLockDC * 3);

        ExecuteScript("lgs_chest_check", oChest);

        nth++;
        oWaypoint = GetObjectByTag(CS_LGS_CHEST_VAR_WAYPOINT, nth);
    }

    object oLog = GetObjectByTag("LOG");
    SetDescription(oLog, GetDescription(oLog) + "\nLGS - Loot Generation System initialized.");
    WriteTimestampedLogEntry("LGS - Loot Generation System initialized");
}
