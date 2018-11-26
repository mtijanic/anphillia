///////////////////////////////////////////////////////////////////////////////
// chr_inc
// written by: eyesolated
// written at: April 13, 2018
//
// Notes: Include File for Character related stuff


///////////
// Includes
//
#include "datetime_inc"
#include "color_inc"
#include "chr_cfg"
#include "cnr_property_inc"
#include "sql_inc"
#include "util_inc"
#include "util_names_inc"
#include "nwnx_time"

///////////////////////
// Function Declaration
//

// Rest functions

// Queues oObject as the Food object to use for next rest
void chr_QueueFood(object oPC, object oObject);

// Starts the OnRest for oPC and nRestEvent
void chr_OnRest(object oPC, int nRestEvent);

// Sets the AFK status on a player, including a nice effect
void chr_SetAFKStatus(object oPC, int nIsAFK);

// Creates a player Backpack with Gold and items on the location of oPC
void chr_Drop_Backpack(object oPC);

// Gets Ability name
string chr_GetAbilityName(int nAbility, int nShort = FALSE);

// Gets Skill name
string chr_GetSkillName(int nSkill);

// Does an ability check
// DC:           The DC to roll against, returns TRUE if Check succeded
// nAbility:     ABILITY_*
// ShowMessage:  Show a message to the player about the roll
// ForceDelay:   Don't do the roll if other rolls (Ability Checks, Saving Throws etc.) are currently active
// ShowAnimation:Show an animation for rolling
int chr_DoAbilityCheck(object oPC, int nAbility, int DC = 0, int ShowMessage = FALSE, int ForceDelay = FALSE, int ShowAnimation = FALSE);

// Does an ability check
// DC:           The DC to roll against, returns TRUE if Check succeded
// nAbility:     ABILITY_*
// ShowMessage:  Show a message to the player about the roll
// ForceDelay:   Don't do the roll if other rolls (Ability Checks, Saving Throws etc.) are currently active
// ShowAnimation:Show an animation for rolling
// AllowUntrained: Allow rolling skills that would require training even if the character isn't trained in them
int chr_DoSkillCheck(object oPC, int nSkill, int DC = 0, int ShowMessage = FALSE, int ForceDelay = FALSE, int ShowAnimation = FALSE, int AllowUntrained = FALSE);

// Does a saving throw
// DC:           The DC to roll against, returns TRUE if Check succeded
// nAbility:     ABILITY_*
// ShowMessage:  Show a message to the player about the roll
// ForceDelay:   Don't do the roll if other rolls (Ability Checks, Saving Throws etc.) are currently active
// ShowAnimation:Show an animation for rolling
int chr_DoSavingThrow(object oPC, int nSaveType, int nDC = 0, int bShowMessage = FALSE, int bForceDelay = FALSE, int bShowAnimation = FALSE);

// Does a saving throw
// DC:           The DC to roll against, returns TRUE if Check succeded
// nAbility:     ABILITY_*
// ShowMessage:  Show a message to the player about the roll
// ForceDelay:   Don't do the roll if other rolls (Ability Checks, Saving Throws etc.) are currently active
// ShowAnimation:Show an animation for rolling
int chr_DoDieRoll(object oPC, int nSides, int nCount = 1, int ShowMessage = FALSE, int ForceDelay = FALSE, int ShowAnimation = FALSE);

// This function should be called on ClientLeave, so the Character System can undo necessary things
void chr_OnPlayerExit(object OPC);

// Returns the PC's persistence item that they will always have on them
object chr_GetPCItem(object oPC);

// Returns the PC's unique integer ID, which is always >0
// Returns <= 0 on error
int chr_GetPCID(object oPC);

// Initializes the PC tracking system. Returns new PCID, or 0 if character already initialized
int chr_InitializePC(object oPC);

// Returns the PC object corresponding to the given ID, if the PC is online at the time
object chr_GetPCByPCID(int nPCID);

// Stores the message in the players last messages log
void chr_LogPlayerChatMessage(object oPC, string sMessage);
// Returns the nthLast message of the PC
string chr_GetPlayerChatMessage(object oPC, int nthLast=0);
// Sets whether the oPC's messages will be displayed as usual.
void chr_SetPlayerCanSpeak(object oPC, int bCanSpeak=TRUE);
// Gets whether the oPC's messages will be displayed as usual.
int chr_GetPlayerCanSpeak(object oPC);

////////////////////////////////////////////////////////////////////////////////
// Internal Functions
//

void DoRest(object oPC)
{
   FadeToBlack(oPC);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_IMP_SLEEP), oPC, 7.0f);
   DelayCommand(7.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_IMP_SLEEP), oPC, 7.0f));
}

void SaveRestTime(object oPC)
{
   SetLocalInt(oPC, CHR_REST_VAR_REST_TIME, NWNX_Time_GetTimeStamp());
}

string GetNearbyHealer(object oPC)
{
    object oHealer = GetNearestObjectByTag ("KaliaCain", oPC);
    if (GetIsObjectValid(oHealer) && !GetIsDead(oHealer))
        return GetName(oHealer);

    oHealer = GetNearestObjectByTag ("ElrielDesifer", oPC);
    if (GetIsObjectValid(oHealer) && !GetIsDead(oHealer))
        return GetName(oHealer);

    oHealer = GetNearestObjectByTag ("KadCulling", oPC);
    if (GetIsObjectValid(oHealer) && !GetIsDead(oHealer))
        return GetName(oHealer);

    oHealer = GetNearestObjectByTag ("ClaraFenson", oPC);
    if (GetIsObjectValid(oHealer) && !GetIsDead(oHealer))
        return GetName(oHealer);

    oHealer = GetNearestObjectByTag ("WanreDLloth", oPC);
    if (GetIsObjectValid(oHealer) && !GetIsDead(oHealer))
        return GetName(oHealer);

    oHealer = GetNearestObjectByTag ("Wacoel", oPC);
    if (GetIsObjectValid(oHealer) && !GetIsDead(oHealer))
        return GetName(oHealer);

    return "";
}

int GetIsPCInFreeRestArea(object oPC)
{
    object oArea = GetArea(oPC);
    if (GetLocalInt(oArea, "FreeRest") == 1)
        return TRUE;

    return FALSE;
}

object GetPCRestFood(object oPC)
{
    object oMyFood;

    // Is there any queued food available?
    oMyFood = GetLocalObject(oPC, CHR_REST_VAR_FOOD_QUEUE);
    if (GetIsObjectValid(oMyFood) &&
        GetItemPossessor(oMyFood) == oPC)
    {
        return oMyFood;
    }

    // If not, cycle through the available food items
    object oEquip = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oEquip)) {
        if(!FindSubString(CnrGetHcrCompatibleTag(GetTag(oEquip)),"Food")) {
            oMyFood = oEquip;
            break;
        }
        oEquip = GetNextItemInInventory(oPC);
    }
    return oMyFood;
}

void doMonsterSurprise(object oPlayer)
{
    // Possibly spawn monsters to a lonely resting player
    int nChanceToJump = d100(1);
    if (nChanceToJump <= CHR_REST_SURPRISE_CHANCE)
        return;

    int nCreaturesToJump = Random(CHR_REST_SURPRISE_MONSTERS_MAX) + 1;

    if (nCreaturesToJump > 0)
    {
        int nCreatureCount = 0;
        int nCreatureNumber = 1;
        object oNearestPCToCreature;
        float fDistanceToPC;
        object oCreatureSelected = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPlayer, nCreatureNumber, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
        while (GetIsObjectValid(oCreatureSelected) &&
               nCreatureCount < nCreaturesToJump)
        {
            oNearestPCToCreature = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oCreatureSelected);
            fDistanceToPC = GetDistanceBetween(oCreatureSelected, oNearestPCToCreature);
            if (fDistanceToPC > 35.0f)
            {
                DelayCommand(1.0f, AssignCommand(oCreatureSelected, ActionJumpToObject(oPlayer)));
                nCreatureCount++;
            }
            nCreatureNumber++;
            oCreatureSelected = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPlayer, nCreatureNumber, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
        }
    }
}

int isGuarded(object oPC, int nRequiredGuards = 1)
{
    int nth = 1;
    int nFoundGuards = 0;
    string sGuards = "";
    object oOtherPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC, nth);
    float fDistance;
    while (GetIsObjectValid(oOtherPC))
    {
        if (!GetIsResting(oOtherPC) &&
            !GetIsDM(oOtherPC))
        {
            fDistance = GetDistanceBetween(oPC, oOtherPC);
            if (fDistance > 35.0f)
                break;

            nFoundGuards++;
            sGuards += " [" + color_ConvertString(GetName(oOtherPC), COLOR_GREEN) + "]";
        }
        nth++;
        oOtherPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC, nth);
    }
    if (nRequiredGuards <= nFoundGuards)
    {
        if (nFoundGuards > 4)
            sGuards = " " + IntToString(nFoundGuards) + " people.";
        SendMessageToPC(oPC, "You are guarded by:" + sGuards);
        //SendMessageToAllDMs(GetName(oPC) +  " is resting in " + GetName(GetArea(oPC)) + " and is guarded by:" + sGuards);
        return TRUE;
    }
    else
    {
        SendMessageToPC(oPC, "You are resting alone.");
        SendMessageToAllDMs(COLOR_CODE_BLUE_DARK + GetName(oPC) + " is resting alone in " + GetName(GetArea(oPC)) + "." + COLOR_CODE_END);
        return FALSE;
    }
}

void CancelRest(object oPC)
{
    SetLocalInt(oPC, CHR_REST_VAR_REST_CANCELLED_BY_SCRIPT, 1);
}

int AllowRestByTime(object oPC)
{
   // Get the current date/time
   int tNow = NWNX_Time_GetTimeStamp();
   // Get the last time the PC rested
   int tLastRest = GetLocalInt(oPC, CHR_REST_VAR_REST_TIME);

   int tDifference = tNow - tLastRest;

   if (tDifference < FloatToInt(HoursToSeconds(CHR_REST_INTERVAL_HOURS)))
   {
      float fHoursToWait = (HoursToSeconds(CHR_REST_INTERVAL_HOURS) - tDifference) / HoursToSeconds(1);
      SendMessageToPC(oPC, "You can't rest at this time, try again in " + FloatToString(fHoursToWait, 2, 1) + " hours.");
      CancelRest(oPC);
      AssignCommand(oPC, ClearAllActions());
      return (FALSE);
   }
   return (TRUE);
}

void SendFamiliarAway(object oPC)
{
   object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC);
   if(!GetIsObjectValid(oFamiliar))
      oFamiliar= GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);
   DestroyObject(oFamiliar);
}

void RemoveBlackScreen(object oPC)
{
   FadeFromBlack(oPC);
}

////////////////////////////////////////////////////////////////////////////////
// Function Code
//

void chr_ZombieWalk(object oPC, int nDuration)
{
    object oPCSkin = GetItemInSlot (INVENTORY_SLOT_CARMOUR, oPC);
    // We only relate this message once, it's just so they know what is going on.
    if (!GetLocalInt (oPC, CHR_NEARDEATH_VAR_MESSAGE))
    {
        FloatingTextStringOnCreature (CHR_NEARDEATH_MESSAGE, oPC, FALSE);
        SetLocalInt (oPC, CHR_NEARDEATH_VAR_MESSAGE, 1);
    }

    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertySpecialWalk(0), oPCSkin, IntToFloat (nDuration));
}

void ApplyFoodEffect(object oPC)
{
    string sFoodTag = GetLocalString(oPC, CHR_REST_VAR_FOOD_TAG);
    effect eEffect;
    if (sFoodTag == "cnrRyeBread")
        eEffect = EffectAbilityIncrease(ABILITY_STRENGTH, 1);
    else if (sFoodTag == "cnrWheatBread")
        eEffect = EffectAbilityIncrease(ABILITY_DEXTERITY, 1);
    else if (sFoodTag == "cnrRiceBread")
        eEffect = EffectAbilityIncrease(ABILITY_CONSTITUTION, 1);
    else if (sFoodTag == "cnrOatsBread")
        eEffect = EffectAbilityIncrease(ABILITY_INTELLIGENCE, 1);
    else if (sFoodTag == "cnrCornBread")
        eEffect = EffectAbilityIncrease(ABILITY_WISDOM, 1);
    else if (sFoodTag == "cnrApplePie")
        eEffect = EffectSavingThrowIncrease(SAVING_THROW_FORT, 1, SAVING_THROW_TYPE_POISON);
    else if (sFoodTag == "cnrCherryPie")
        eEffect = EffectAbilityIncrease(ABILITY_CHARISMA, 1);
    else if (sFoodTag == "cnrBlkberryPie")
        eEffect = EffectSavingThrowIncrease(SAVING_THROW_FORT, 1, SAVING_THROW_TYPE_DISEASE);
    else if (sFoodTag == "cnrBluberryPie")
        eEffect = EffectAttackIncrease(1);
    else if (sFoodTag == "cnrPecanPie")
        eEffect = EffectAbilityIncrease(ABILITY_INTELLIGENCE, 1);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, TurnsToSeconds(6));
}

void chr_QueueFood(object oPC, object oObject)
{
    if(!FindSubString(CnrGetHcrCompatibleTag(GetTag(oObject)),"Food"))
    {
        SetLocalObject(oPC, CHR_REST_VAR_FOOD_QUEUE, oObject);
        SendMessageToPC(oPC, "You will eat [" + color_ConvertString(GetName(oObject), COLOR_GREY) + "] on your next rest.");
    }
}

void chr_OnRest(object oPC, int nRestEvent)
{
    string sHealer;
    object oFood;
    string sFoodTag;
    switch (nRestEvent)
    {
        case REST_EVENTTYPE_REST_STARTED:
            SetLocalInt(oPC, CHR_REST_VAR_HITPOINTS_BEFORE_REST, GetCurrentHitPoints(oPC));
            sHealer = GetNearbyHealer(oPC);
            if (GetIsPCInFreeRestArea(oPC))
            {
                SetLocalInt(oPC, CHR_REST_VAR_NEARBYHEALER, 1);
            }
            else if (sHealer != "")
            {
                SetLocalInt(oPC, CHR_REST_VAR_NEARBYHEALER, 1);
                SendMessageToPC(oPC, sHealer + "'s presence is soothing you.");
            }
            else if (AllowRestByTime(oPC))
            {
                oFood = GetPCRestFood(oPC);
                if (!GetIsObjectValid(oFood))
                {
                    FloatingTextStringOnCreature("You try to rest but you are too hungry.", oPC, FALSE);
                    CancelRest(oPC);
                    AssignCommand(oPC, ClearAllActions());
                    return;
                }
                SendFamiliarAway(oPC);
                SetLocalString(oPC, CHR_REST_VAR_FOOD_TAG, GetTag(oFood));
                DestroyObject(oFood);
                DeleteLocalObject(oPC, CHR_REST_VAR_FOOD_QUEUE);
                SendMessageToPC(oPC, "You eat [" + color_ConvertString(GetName(oFood), COLOR_GREY) + "]");
                DoRest(oPC);
                if (!isGuarded(oPC, CHR_REST_SURPRISE_GUARDS_NEEDED))
                    doMonsterSurprise(oPC);
            }
            break;
        case REST_EVENTTYPE_REST_CANCELLED:
            if (GetLocalInt(oPC, CHR_REST_VAR_NEARBYHEALER) == 1)
            {
                DeleteLocalInt(oPC, CHR_REST_VAR_NEARBYHEALER);
                DeleteLocalInt(oPC, CHR_REST_VAR_REST_CANCELLED_BY_SCRIPT);
                return;
            }

            // Delete the info on what food the PC ate
            DeleteLocalString(oPC, CHR_REST_VAR_FOOD_TAG);

            if (GetLocalInt(oPC, CHR_REST_VAR_REST_CANCELLED_BY_SCRIPT) == 1)
            {
                DeleteLocalInt(oPC, CHR_REST_VAR_REST_CANCELLED_BY_SCRIPT);
                return;
            }
            // 120 seconds delay.
            SetLocalInt(oPC, CHR_REST_VAR_REST_TIME, GetLocalInt(oPC, CHR_REST_VAR_REST_TIME) + 120);

            NWNX_Object_SetCurrentHitPoints(oPC, GetLocalInt(oPC, CHR_REST_VAR_HITPOINTS_BEFORE_REST));
            RemoveBlackScreen(oPC);
            break;
        case REST_EVENTTYPE_REST_FINISHED:
            // Apply banked XP
            ExecuteScript("xp_apply", oPC);
            SetLocalInt(oPC, CHR_REST_VAR_REST_TIME, NWNX_Time_GetTimeStamp());

            if (GetLocalInt(oPC, CHR_REST_VAR_NEARBYHEALER) == 1)
            {
                DeleteLocalInt(oPC, CHR_REST_VAR_NEARBYHEALER);
                DeleteLocalInt(oPC, CHR_REST_VAR_REST_CANCELLED_BY_SCRIPT);
                return;
            }

            NWNX_Object_SetCurrentHitPoints(oPC,
                min(GetMaxHitPoints(oPC), GetLocalInt(oPC, CHR_REST_VAR_HITPOINTS_BEFORE_REST) + 5 + GetHitDice(oPC)));

            RemoveBlackScreen(oPC);
            DeleteLocalInt(oPC, CHR_REST_VAR_REST_CANCELLED_BY_SCRIPT);

            // Apply Food effect and delete the info on what food the PC ate
            ApplyFoodEffect(oPC);
            DeleteLocalString(oPC, CHR_REST_VAR_FOOD_TAG);
            break;
    }
}

void chr_SetAFKStatus(object oPC, int nIsAFK)
{
    if (nIsAFK)
    {
        effect eImmobilize = EffectCutsceneImmobilize();
        eImmobilize = TagEffect(eImmobilize, CHR_AFK_EFFECTTAG);

        vector vVector = GetPosition(oPC);
        int nCreatureSize = GetCreatureSize(oPC);
        switch (nCreatureSize)
        {
            case CREATURE_SIZE_SMALL: vVector.z += 0.7f; break;
            case CREATURE_SIZE_MEDIUM: vVector.z += 1.0f; break;
            case CREATURE_SIZE_LARGE: vVector.z += 1.3f; break;
        }
        location lLocation = Location(GetArea(oPC), vVector, GetFacing(oPC));

        object oButterFlies = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_butterflies", lLocation);
        AssignCommand(oButterFlies, SetIsDestroyable(FALSE, FALSE, FALSE));
        SetLocalObject(oPC, CHR_AFK_VAR_PLACEABLE, oButterFlies);
        SetLocalInt(oPC, CHR_AFK_VAR_STATUS, TRUE);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmobilize, oPC);
    }
    else
    {
        object oButterFlies = GetLocalObject(oPC, CHR_AFK_VAR_PLACEABLE);
        if (GetIsObjectValid(oButterFlies))
        {
            AssignCommand(oButterFlies, SetIsDestroyable(TRUE, FALSE, FALSE));
            DestroyObject(oButterFlies, 0.1f);
        }
        DeleteLocalObject(oPC, CHR_AFK_VAR_PLACEABLE);
        DeleteLocalInt(oPC, CHR_AFK_VAR_STATUS);

        effect eEffect = GetFirstEffect(oPC);
        while (GetIsEffectValid(eEffect))
        {
            if (GetEffectTag(eEffect) == CHR_AFK_EFFECTTAG)
            {
                RemoveEffect(oPC, eEffect);
                break;
            }
            eEffect = GetNextEffect(oPC);
        }
    }
}

void chr_MoveInventoryToBackpack(object oOwner, object oDest, string sDropTags="")
{
    if (!GetIsObjectValid(oDest))
        return;

    object oItem = GetFirstItemInInventory(oOwner);
    while(oItem != OBJECT_INVALID)
    {
        if (GetItemCursedFlag(oItem))
        {
            oItem = GetNextItemInInventory(oOwner);
            continue;
        }

        if (GetHasInventory(oItem))
        {
            chr_MoveInventoryToBackpack(oItem, oDest, sDropTags);
        }

        if (sDropTags == "" || FindSubString(sDropTags, GetTag(oItem)) >= 0)
        {
            CopyItem(oItem, oDest, TRUE);
            DestroyObject(oItem);
        }

        oItem = GetNextItemInInventory (oOwner);
    }
}

void chr_Drop_Backpack(object oPC)
{
    location lDiedHere = GetLocation(oPC);
    object oMod = GetModule();
    object oBackpack;
    string sID=GetName(oPC)+GetPCPublicCDKey(oPC);

    // Create a Backpack if there is none yet at this location
    oBackpack=GetLocalObject(oMod, "PlayerBackpack"+sID);
    if (!GetIsObjectValid(oBackpack) ||
        GetLocation(oBackpack) != lDiedHere)
    {
        oBackpack = CreateObject (OBJECT_TYPE_PLACEABLE, "playerbackpack", lDiedHere);

        if (!GetIsObjectValid (oBackpack))
            SendMessageToPC (oPC, "invalid backpack");

        SetLocalObject(oMod,"PlayerBackpack"+sID, oBackpack);
    }

    // Drop player gold
    int nAmtGold=GetGold(oPC);
    WriteTimestampedLogEntry ("Dropping gold from player - " + IntToString (nAmtGold));
    AssignCommand(oPC, TakeGoldFromCreature(nAmtGold, oPC, TRUE));
    if (nAmtGold > CHR_DROP_GOLDMAXIMUM)
        nAmtGold = CHR_DROP_GOLDMAXIMUM;
    if (nAmtGold > 0)
        CreateItemOnObject("NW_IT_GOLD001", oBackpack, nAmtGold);

    // Drop Items
    if (CHR_DROP_ITEMS)
    {
        string sDropTags = "playercorpse;";
        sDropTags += "cnrNuggetCopp;cnrNuggetTin;cnrNuggetIron;cnrNuggetGold;cnrNuggetPlat;cnrNuggetAdam;cnrNuggetCoba;cnrNuggetSilv;cnrNuggetTita;cnrNuggetMith;";
        sDropTags += "cnrGemMineral001;cnrGemMineral007;cnrGemMineral002;cnrGemMineral014;cnrGemMineral004;cnrGemMineral003;cnrGemMineral015;cnrGemMineral011;cnrGemMineral013;cnrGemMineral010;cnrGemMineral008;cnrGemMineral009;cnrGemMineral005;cnrGemMineral006;cnrGemMineral012;";
        sDropTags += "cnrBranchHic;cnrBranchOak;cnrBranchMah;";
        sDropTags += "ANPH_SUPPLIES_GOLD;ANPH_SUPPLIES_MAGIC;ANPH_SUPPLIES_ARMS;ANPH_SUPPLIES_ARMOR;";

        chr_MoveInventoryToBackpack(oPC, oBackpack, sDropTags);
    }

    // If the Backpack is empty, destroy it
    object oItem = GetFirstItemInInventory (oBackpack);
    if (!GetIsObjectValid (oItem))
        DestroyObject (oBackpack);
}

string chr_GetAbilityName(int nAbility, int nShort = FALSE)
{
    switch (nAbility)
    {
        case ABILITY_STRENGTH:
            if (nShort)
                return "STR";
            else
                return "Strength";
            break;
        case ABILITY_DEXTERITY:
            if (nShort)
                return "DEX";
            else
                return "Dexterity";
            break;
        case ABILITY_CONSTITUTION:
            if (nShort)
                return "CON";
            else
                return "Constitution";
            break;
        case ABILITY_WISDOM:
        if (nShort)
                return "WIS";
            else
                return "Wisdom";
            break;
        case ABILITY_INTELLIGENCE:
            if (nShort)
                return "INT";
            else
                return "Intelligence";
            break;
        case ABILITY_CHARISMA:
            if (nShort)
                return "CHA";
            else
                return "Charisma";
            break;
    }
    return "";
}

string chr_GetSkillName(int nSkill)
{
    return GetStringByStrRef(StringToInt(Get2DAString("skills", "Name", nSkill)));
}

int chr_GetCurrentlyChecking(object oPC, int ShowMessage)
{
    if (GetLocalInt(oPC, CHR_ROLL_VAR_CURRENTLYCHECKING))
    {
        if (ShowMessage)
            SendMessageToPC(oPC, "You recently did a Roll, please don't spam.");

        return TRUE;
    }
    return FALSE;
}

void chr_DoMessage(object oPC, string sMessage)
{
    SendMessageToPC(oPC, sMessage);

    // Always send Message to DMs regardless of privacy status
    SendMessageToAllDMs(color_ConvertString(GetName(oPC), COLOR_GREY) + " - " + sMessage);
    float fDistance = 30.0f;

    int nPrivacy = GetLocalInt(oPC, CS_ROLLS_VAR_PRIVACY);
    if (nPrivacy == CHR_ROLL_PRIVACY_PUBLIC)
    {
        location lLocation = GetLocation(oPC);
        object oByStander = GetFirstObjectInShape(SHAPE_SPHERE, fDistance, lLocation, TRUE, OBJECT_TYPE_CREATURE);
        while (GetIsObjectValid(oByStander))
        {
            if (GetIsPC(oByStander) &&
                !GetIsDM(oByStander) &&
                oPC != oByStander)
            {
                SendMessageToPC(oByStander, color_ConvertString(GetName(oPC), COLOR_GREY) + " - " + sMessage);
            }

            oByStander = GetNextObjectInShape(SHAPE_SPHERE, fDistance, lLocation, TRUE, OBJECT_TYPE_CREATURE);
        }
    }
}

void chr_DoCheckAnimationAndMessage(object oPC, int ShowMessage, int ShowAnimation, string sMessage, int nAnimation = ANIMATION_LOOPING_GET_MID, float fDuration = 2.0f)
{
    // Roll Animation
    if (ShowAnimation)
    {
        AssignCommand(oPC, ClearAllActions());
        AssignCommand(oPC, ActionPlayAnimation(nAnimation, 1.0f, fDuration));
    }

    if (ShowMessage)
        AssignCommand(GetModule(), DelayCommand(2.1f, chr_DoMessage(oPC, sMessage)));
}

void chr_DeleteCheck(object oPC)
{
    DeleteLocalInt(oPC, CHR_ROLL_VAR_CURRENTLYCHECKING);
}

int chr_DoAbilityCheck(object oPC, int nAbility, int nDC = 0, int ShowMessage = FALSE, int ForceDelay = FALSE, int ShowAnimation = FALSE)
{
    if (ForceDelay)
    {
        if (chr_GetCurrentlyChecking(oPC, ShowMessage))
            return FALSE;

        SetLocalInt(oPC, CHR_ROLL_VAR_CURRENTLYCHECKING, TRUE);
        // Reset Check in Progress
        AssignCommand(GetModule(), DelayCommand(3.0f, chr_DeleteCheck(oPC)));
    }

    int nAbilityModifier = GetAbilityModifier(nAbility, oPC);
    int nRoll = d20();
    int nResult = nAbilityModifier + nRoll;

    // Build Message
    string sMessage = "[" + color_ConvertString(chr_GetAbilityName(nAbility, TRUE), COLOR_ORANGE) + "] Check: ";
    sMessage += color_ConvertString(IntToString(nResult), COLOR_GREY);
    if (nDC != 0)
        sMessage += " (DC: " + color_ConvertString(IntToString(nDC), COLOR_GREY) + ")";

    chr_DoCheckAnimationAndMessage(oPC, ShowMessage, ShowAnimation, sMessage);

    if (nDC != 0)
        return (nDC <= nResult);

    return nResult;
}

int chr_DoSkillCheck(object oPC, int nSkill, int nDC = 0, int ShowMessage = FALSE, int ForceDelay = FALSE, int ShowAnimation = FALSE, int AllowUntrained = FALSE)
{
    if (ForceDelay)
    {
        if (chr_GetCurrentlyChecking(oPC, ShowMessage))
            return FALSE;

        SetLocalInt(oPC, CHR_ROLL_VAR_CURRENTLYCHECKING, TRUE);
        // Reset Check in Progress
        AssignCommand(GetModule(), DelayCommand(3.0f, chr_DeleteCheck(oPC)));
    }

    int nBaseScore = GetSkillRank(nSkill, oPC, TRUE);
    if (nBaseScore == -1 &&
        !AllowUntrained)
    {
        if (ShowMessage)
            SendMessageToPC(oPC, "You don't have that skill.");

        return FALSE;
    }
    int nSkillScore = GetSkillRank(nSkill, oPC);

    int nRoll = d20();
    int nResult = nSkillScore + nRoll;

    // Build Message
    string sMessage = "[" + color_ConvertString(chr_GetSkillName(nSkill), COLOR_ORANGE) + "] Check: ";
    sMessage += color_ConvertString(IntToString(nResult), COLOR_GREY);
    if (nDC != 0)
        sMessage += " (DC: " + color_ConvertString(IntToString(nDC), COLOR_GREY) + ")";

    chr_DoCheckAnimationAndMessage(oPC, ShowMessage, ShowAnimation, sMessage);

    if (nDC != 0)
        return (nDC <= nResult);

    return nResult;
}

int chr_DoSavingThrow(object oPC, int nSaveType, int nDC = 0, int bShowMessage = FALSE, int bForceDelay = FALSE, int bShowAnimation = FALSE)
{
    if (bForceDelay)
    {
        if (chr_GetCurrentlyChecking(oPC, bShowMessage))
            return FALSE;

        SetLocalInt(oPC, CHR_ROLL_VAR_CURRENTLYCHECKING, TRUE);
        // Reset Check in Progress
        AssignCommand(GetModule(), DelayCommand(3.0f, chr_DeleteCheck(oPC)));
    }

    int nSavingThrow;
    string sSaveType;
    switch (nSaveType)
    {
        case SAVING_THROW_FORT: nSavingThrow = GetFortitudeSavingThrow(oPC); sSaveType = "Fortitude"; break;
        case SAVING_THROW_REFLEX: nSavingThrow = GetReflexSavingThrow(oPC); sSaveType = "Reflex"; break;
        case SAVING_THROW_WILL: nSavingThrow = GetWillSavingThrow(oPC); sSaveType = "Will"; break;
    }
    int nRoll = d20();
    int nResult = nSavingThrow + nRoll;

    // Build Message
    string sMessage = "[" + color_ConvertString(sSaveType, COLOR_ORANGE) + "] Saving Throw: ";
    sMessage += color_ConvertString(IntToString(nResult), COLOR_GREY);
    if (nDC != 0)
        sMessage += " (DC: " + color_ConvertString(IntToString(nDC), COLOR_GREY) + ")";

    chr_DoCheckAnimationAndMessage(oPC, bShowMessage, bShowAnimation, sMessage);

    if (nDC != 0)
        return (nDC <= nResult);

    return nResult;
}

int chr_DoDieRoll(object oPC, int nSides, int nCount = 1, int ShowMessage = FALSE, int ForceDelay = FALSE, int ShowAnimation = FALSE)
{
    if (ForceDelay)
    {
        if (chr_GetCurrentlyChecking(oPC, ShowMessage))
            return FALSE;

        SetLocalInt(oPC, CHR_ROLL_VAR_CURRENTLYCHECKING, TRUE);
        // Reset Check in Progress
        AssignCommand(GetModule(), DelayCommand(3.0f, chr_DeleteCheck(oPC)));
    }

    int nth;
    int nRoll;
    int nResult = 0;
    for (nth = 1; nth <= nCount; nth++)
    {
        nRoll = Random(nSides) + 1;
        nResult += nRoll;
    }

    // Build Message
    string sMessage = "[" + IntToString(nCount) + "d" + color_ConvertString(IntToString(nSides), COLOR_ORANGE) + "]: ";
    sMessage += color_ConvertString(IntToString(nResult), COLOR_GREY);

    chr_DoCheckAnimationAndMessage(oPC, ShowMessage, ShowAnimation, sMessage);

    return nResult;
}

void chr_OnPlayerExit(object oPC)
{
    chr_SetAFKStatus(oPC, FALSE);
}

object chr_GetPCItem(object oPC)
{
    object oPCItem = GetLocalObject(oPC, "chr_PCITEM");
    if (!GetIsObjectValid(oPCItem))
    {
        oPCItem = GetItemPossessedBy(oPC, CHR_PCITEM_TAG);
        if (oPCItem == OBJECT_INVALID)
        {
            oPCItem = CreateItemOnObject(CHR_PCITEM_RESREF, oPC);
        }
        SetLocalObject(oPC, "chr_PCITEM", oPCItem);
    }
    return oPCItem;
}

int chr_GetPCID(object oPC)
{
    if (!GetIsPC(oPC) || GetIsObjectValid(GetMaster(oPC)))
        return -1;

    int nID = StringToInt(GetTag(oPC));
    if (!nID)
    {
        nID = GetLocalInt(chr_GetPCItem(oPC), "chr_PCID");
        if (!nID)
            nID = sql_GetPCID(oPC);
        SetTag(oPC, IntToString(nID));
        //SetLocalObject(GetModule(), "chr_PCID_" + IntToString(nID), oPC);
    }
    return nID;
}

int chr_InitializePC(object oPC)
{
    //if (!GetIsPC(oPC) || GetIsObjectValid(GetMaster(oPC)))
    //    return 0;

    object oPCItem = chr_GetPCItem(oPC);

    // Sanity check, avoid double inits
    if (StringToInt(GetTag(oPC)) || GetLocalInt(oPCItem, "chr_PCID"))
        return 0;

    int nPCID = sql_RegisterNewPC(oPC);
    if (!GetIsObjectValid(oPCItem))
    {
        oPCItem = CreateItemOnObject(CHR_PCITEM_RESREF, oPC, 1, CHR_PCITEM_TAG);
        SetItemCursedFlag(oPCItem, TRUE);
        SetStolenFlag(oPCItem, TRUE);
    }

    SetTag(oPC, IntToString(nPCID));

    SetLocalInt(oPC, "chr_PCID", nPCID);
    SetLocalObject(oPC, "chr_PCITEM", oPCItem);
    return nPCID;
}

object chr_GetPCByPCID(int nPCID)
{
    object oPC = GetLocalObject(GetModule(), "chr_PCID_" + IntToString(nPCID));
    if (oPC != OBJECT_INVALID) // may still not be valid, but caller will check
        return oPC;
    oPC = GetFirstPC();
    while (oPC != OBJECT_INVALID)
    {
        if (chr_GetPCID(oPC) > 0)
            return oPC;
        oPC = GetNextPC();
    }
    return oPC;
}


void chr_LogPlayerChatMessage(object oPC, string sMessage)
{
    int nPos = GetLocalInt(oPC, "CHR_CHAT_MESSAGE_BUFFER_POS");
    SetLocalString(oPC, "CHR_CHAT_MESSAGE_BUFFER_" + IntToString(nPos), sMessage);
    nPos = (nPos + 1) % CHR_CHAT_MESSAGE_BUFFER_SIZE;
    SetLocalInt(oPC, "CHR_CHAT_MESSAGE_BUFFER_POS", nPos);
}

string chr_GetPlayerChatMessage(object oPC, int nthLast=0)
{
    if (nthLast >= CHR_CHAT_MESSAGE_BUFFER_SIZE)
        return "";

    int nPos = GetLocalInt(oPC, "CHR_CHAT_MESSAGE_BUFFER_POS");
    nPos = (CHR_CHAT_MESSAGE_BUFFER_SIZE + nPos - nthLast - 1) % CHR_CHAT_MESSAGE_BUFFER_SIZE;
    return GetLocalString(oPC, "CHR_CHAT_MESSAGE_BUFFER_" + IntToString(nPos));
}

void chr_SetPlayerCanSpeak(object oPC, int bCanSpeak=TRUE)
{
    SetLocalInt(oPC, "CHR_CHAT_IS_MUTED", !bCanSpeak);
}

int chr_GetPlayerCanSpeak(object oPC)
{
    return !GetLocalInt(oPC, "CHR_CHAT_IS_MUTED");
}
