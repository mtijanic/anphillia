///////////////////////////////////////////////////////////////////////////////
// lgs_chest_check
// written by: eyesolated
// written at: April 27, 2018
//
// Notes: Check the chest for reinitialization

///////////
// Includes
//
// Needs
#include "mod_cfg"
#include "lgs_cfg"
#include "lgs_inc"

///////////////////////
// Function Declaration
//

void main()
{
    // Someone called this script, we're in Check Mode
    SetLocalInt(OBJECT_SELF, CS_LGS_CHEST_CHECK_ISCHECKING, TRUE);

    // Get Check Count
    int nCheck = GetLocalInt(OBJECT_SELF, CS_LGS_CHEST_CHECK_COUNT);

    // If Check Count * Interval >= Reset Time, do the reset
    if ((nCheck == 0 ||
        (nCheck * CS_LGS_CHEST_CHECK_INTERVAL) >= CS_LGS_CHEST_RESET_IDLE) &&
        !GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF)))
    {
        // Clear our inventory
        lgs_ClearInventory(OBJECT_SELF);

        // Set Plot flag
        SetPlotFlag(OBJECT_SELF, TRUE);

        // Reconfigure
        int nLockChance = GetLocalInt(OBJECT_SELF, CS_LGS_CHEST_VAR_LOCKCHANCE);
        int nLockDC = GetLocalInt(OBJECT_SELF, CS_LGS_CHEST_VAR_LOCKDC);
        int nTrapChance = GetLocalInt(OBJECT_SELF, CS_LGS_CHEST_VAR_TRAPCHANCE);
        int nTrapStrength = GetLocalInt(OBJECT_SELF, CS_LGS_CHEST_VAR_TRAPSTRENGTH);
        int nTrapDetectDC = GetLocalInt(OBJECT_SELF, CS_LGS_CHEST_VAR_TRAPDETECTDC);
        int nTrapDisarmDC = GetLocalInt(OBJECT_SELF, CS_LGS_CHEST_VAR_TRAPDISARMDC);

        // Standards
        if (nLockChance == 0)   nLockChance     = CI_LGS_CHEST_DEFAULT_LOCKCHANCE;
        if (nLockDC == 0)       nLockDC         = CI_LGS_CHEST_DEFAULT_LOCKDC;
        if (nTrapChance == 0)   nTrapChance     = CI_LGS_CHEST_DEFAULT_TRAPCHANCE;
        if (nTrapStrength == 0) nTrapStrength   = CI_LGS_CHEST_DEFAULT_TRAPSTRENGTH;
        if (nTrapDetectDC == 0) nTrapDetectDC   = CI_LGS_CHEST_DEFAULT_TRAPDETECTDC;
        if (nTrapDisarmDC == 0) nTrapDisarmDC   = CI_LGS_CHEST_DEFAULT_TRAPDISARMDC;

        // Relock
        if (nLockChance >= d100(1))
        {
            SetLocked(OBJECT_SELF, TRUE);
            SetLockUnlockDC(OBJECT_SELF, nLockDC);

            // Remove Plot Flag if the chest is locked to make it bashable
            if (CI_LGS_CHESTS_ALLOW_BASH)
                SetPlotFlag(OBJECT_SELF, FALSE);
        }

        // Trap
        if (!GetIsTrapped(OBJECT_SELF) &&
            nTrapChance >= d100(1))
        {
            int nSelectedTrap;
            switch (nTrapStrength)
            {
                case 1: // Minor
                    nSelectedTrap = Random(11);
                    switch (nSelectedTrap)
                    {
                        case 0: CreateTrapOnObject(TRAP_BASE_TYPE_MINOR_ACID, OBJECT_SELF); break;
                        case 1: CreateTrapOnObject(TRAP_BASE_TYPE_MINOR_ACID_SPLASH, OBJECT_SELF); break;
                        case 2: CreateTrapOnObject(TRAP_BASE_TYPE_MINOR_ELECTRICAL, OBJECT_SELF); break;
                        case 3: CreateTrapOnObject(TRAP_BASE_TYPE_MINOR_FIRE, OBJECT_SELF); break;
                        case 4: CreateTrapOnObject(TRAP_BASE_TYPE_MINOR_FROST, OBJECT_SELF); break;
                        case 5: CreateTrapOnObject(TRAP_BASE_TYPE_MINOR_GAS, OBJECT_SELF); break;
                        case 6: CreateTrapOnObject(TRAP_BASE_TYPE_MINOR_HOLY, OBJECT_SELF); break;
                        case 7: CreateTrapOnObject(TRAP_BASE_TYPE_MINOR_NEGATIVE, OBJECT_SELF); break;
                        case 8: CreateTrapOnObject(TRAP_BASE_TYPE_MINOR_SONIC, OBJECT_SELF); break;
                        case 9: CreateTrapOnObject(TRAP_BASE_TYPE_MINOR_SPIKE, OBJECT_SELF); break;
                        case 10: CreateTrapOnObject(TRAP_BASE_TYPE_MINOR_TANGLE, OBJECT_SELF); break;
                    }
                    break;
                case 2: // Average
                    nSelectedTrap = Random(11);
                    switch (nSelectedTrap)
                    {
                        case 0: CreateTrapOnObject(TRAP_BASE_TYPE_AVERAGE_ACID, OBJECT_SELF); break;
                        case 1: CreateTrapOnObject(TRAP_BASE_TYPE_AVERAGE_ACID_SPLASH, OBJECT_SELF); break;
                        case 2: CreateTrapOnObject(TRAP_BASE_TYPE_AVERAGE_ELECTRICAL, OBJECT_SELF); break;
                        case 3: CreateTrapOnObject(TRAP_BASE_TYPE_AVERAGE_FIRE, OBJECT_SELF); break;
                        case 4: CreateTrapOnObject(TRAP_BASE_TYPE_AVERAGE_FROST, OBJECT_SELF); break;
                        case 5: CreateTrapOnObject(TRAP_BASE_TYPE_AVERAGE_GAS, OBJECT_SELF); break;
                        case 6: CreateTrapOnObject(TRAP_BASE_TYPE_AVERAGE_HOLY, OBJECT_SELF); break;
                        case 7: CreateTrapOnObject(TRAP_BASE_TYPE_AVERAGE_NEGATIVE, OBJECT_SELF); break;
                        case 8: CreateTrapOnObject(TRAP_BASE_TYPE_AVERAGE_SONIC, OBJECT_SELF); break;
                        case 9: CreateTrapOnObject(TRAP_BASE_TYPE_AVERAGE_SPIKE, OBJECT_SELF); break;
                        case 10: CreateTrapOnObject(TRAP_BASE_TYPE_AVERAGE_TANGLE, OBJECT_SELF); break;
                    }
                    break;
                case 3: // Strong
                    nSelectedTrap = Random(11);
                    switch (nSelectedTrap)
                    {
                        case 0: CreateTrapOnObject(TRAP_BASE_TYPE_STRONG_ACID, OBJECT_SELF); break;
                        case 1: CreateTrapOnObject(TRAP_BASE_TYPE_STRONG_ACID_SPLASH, OBJECT_SELF); break;
                        case 2: CreateTrapOnObject(TRAP_BASE_TYPE_STRONG_ELECTRICAL, OBJECT_SELF); break;
                        case 3: CreateTrapOnObject(TRAP_BASE_TYPE_STRONG_FIRE, OBJECT_SELF); break;
                        case 4: CreateTrapOnObject(TRAP_BASE_TYPE_STRONG_FROST, OBJECT_SELF); break;
                        case 5: CreateTrapOnObject(TRAP_BASE_TYPE_STRONG_GAS, OBJECT_SELF); break;
                        case 6: CreateTrapOnObject(TRAP_BASE_TYPE_STRONG_HOLY, OBJECT_SELF); break;
                        case 7: CreateTrapOnObject(TRAP_BASE_TYPE_STRONG_NEGATIVE, OBJECT_SELF); break;
                        case 8: CreateTrapOnObject(TRAP_BASE_TYPE_STRONG_SONIC, OBJECT_SELF); break;
                        case 9: CreateTrapOnObject(TRAP_BASE_TYPE_STRONG_SPIKE, OBJECT_SELF); break;
                        case 10: CreateTrapOnObject(TRAP_BASE_TYPE_STRONG_TANGLE, OBJECT_SELF); break;
                    }
                    break;
                case 4: // Deadly
                    nSelectedTrap = Random(11);
                    switch (nSelectedTrap)
                    {
                        case 0: CreateTrapOnObject(TRAP_BASE_TYPE_DEADLY_ACID, OBJECT_SELF); break;
                        case 1: CreateTrapOnObject(TRAP_BASE_TYPE_DEADLY_ACID_SPLASH, OBJECT_SELF); break;
                        case 2: CreateTrapOnObject(TRAP_BASE_TYPE_DEADLY_ELECTRICAL, OBJECT_SELF); break;
                        case 3: CreateTrapOnObject(TRAP_BASE_TYPE_DEADLY_FIRE, OBJECT_SELF); break;
                        case 4: CreateTrapOnObject(TRAP_BASE_TYPE_DEADLY_FROST, OBJECT_SELF); break;
                        case 5: CreateTrapOnObject(TRAP_BASE_TYPE_DEADLY_GAS, OBJECT_SELF); break;
                        case 6: CreateTrapOnObject(TRAP_BASE_TYPE_DEADLY_HOLY, OBJECT_SELF); break;
                        case 7: CreateTrapOnObject(TRAP_BASE_TYPE_DEADLY_NEGATIVE, OBJECT_SELF); break;
                        case 8: CreateTrapOnObject(TRAP_BASE_TYPE_DEADLY_SONIC, OBJECT_SELF); break;
                        case 9: CreateTrapOnObject(TRAP_BASE_TYPE_DEADLY_SPIKE, OBJECT_SELF); break;
                        case 10: CreateTrapOnObject(TRAP_BASE_TYPE_DEADLY_TANGLE, OBJECT_SELF); break;
                    }
                    break;
                case 5: // Epic
                    nSelectedTrap = Random(4);
                    switch (nSelectedTrap)
                    {
                        case 0: CreateTrapOnObject(TRAP_BASE_TYPE_EPIC_ELECTRICAL, OBJECT_SELF); break;
                        case 1: CreateTrapOnObject(TRAP_BASE_TYPE_EPIC_FIRE, OBJECT_SELF); break;
                        case 2: CreateTrapOnObject(TRAP_BASE_TYPE_EPIC_FROST, OBJECT_SELF); break;
                        case 3: CreateTrapOnObject(TRAP_BASE_TYPE_EPIC_SONIC, OBJECT_SELF); break;
                    }
                    break;
            }
            SetTrapDetectDC(OBJECT_SELF, nTrapDetectDC);
            SetTrapDisarmDC(OBJECT_SELF, nTrapDisarmDC);
        }

        // We are now reset, no need for further checks until the Execution of this
        // script is triggered from the outside
        SetLocalInt(OBJECT_SELF, CS_LGS_CHEST_CHECK_COUNT, 1);
        DeleteLocalInt(OBJECT_SELF, CS_LGS_CHEST_CHECK_ISCHECKING);
        return;
    }

    // Increase Check Count
    SetLocalInt(OBJECT_SELF, CS_LGS_CHEST_CHECK_COUNT, nCheck + 1);

    // Next check
    DelayCommand(CS_LGS_CHEST_CHECK_INTERVAL, ExecuteScript("lgs_chest_check", OBJECT_SELF));
}
