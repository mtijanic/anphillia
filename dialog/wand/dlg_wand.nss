///////////////////////////////////////////////////////////////////////////////
// dlg_wand
// written by: eyesolated
// written at: April 12, 2018
//
// Notes: the conditional/action script for the wand dialog


///////////
// Includes
//
#include "eas_inc"
#include "dlg_inc"
#include "dlg_wand_const"
#include "color_inc"
#include "chr_inc"
#include "esm_inc"
#include "eye_altarelem"

///////////////////////
// Function Declaration
//

////////////////
// Function Code
//
string GetDruidWildShape(object oPC, int TargetSpell)
{
    int TargetShape = GetLocalInt(oPC, CS_DRUID_VAR_SHAPE + "_" + IntToString(TargetSpell)) - 1;
    string sColor = COLOR_ORANGE;
    switch (TargetShape)
    {
        case -1: return "default"; break;
        case POLYMORPH_TYPE_BADGER: return color_ConvertString("Badger", sColor); break;
        case POLYMORPH_TYPE_BOAR: return color_ConvertString("Boar", sColor); break;
        case POLYMORPH_TYPE_BROWN_BEAR: return color_ConvertString("Brown Bear", sColor); break;
        case POLYMORPH_TYPE_CHICKEN: return color_ConvertString("Chicken", sColor); break;
        case POLYMORPH_TYPE_COW: return color_ConvertString("Cow", sColor); break;
        case POLYMORPH_TYPE_DIRE_BADGER: return color_ConvertString("Dire Badger", sColor); break;
        case POLYMORPH_TYPE_DIRE_BOAR: return color_ConvertString("Dire Boar", sColor); break;
        case POLYMORPH_TYPE_DIRE_BROWN_BEAR: return color_ConvertString("Dire Brown Bear", sColor); break;
        case POLYMORPH_TYPE_DIRE_PANTHER: return color_ConvertString("Dire Panther", sColor); break;
        case POLYMORPH_TYPE_DIRE_WOLF: return color_ConvertString("Dire Wolf", sColor); break;
        case POLYMORPH_TYPE_DIRETIGER: return color_ConvertString("Dire Tiger", sColor); break;
        case POLYMORPH_TYPE_GIANT_SPIDER: return color_ConvertString("Giant Spider", sColor); break;
        case POLYMORPH_TYPE_PANTHER: return color_ConvertString("Panther", sColor); break;
        case POLYMORPH_TYPE_PENGUIN: return color_ConvertString("Penguin", sColor); break;
        case POLYMORPH_TYPE_WOLF: return color_ConvertString("Wolf", sColor); break;
        case 102: return color_ConvertString("Winter Wolf", sColor); break;
        case 210: return color_ConvertString("Black Bear", sColor); break;
        case 211: return color_ConvertString("Grizzly Bear", sColor); break;
        case 212: return color_ConvertString("Polar Bear", sColor); break;
        case 213: return color_ConvertString("Wild Dog", sColor); break;
        case 214: return color_ConvertString("Winter Wolf", sColor); break;
        case 215: return color_ConvertString("Puppy", sColor); break;
        case 216: return color_ConvertString("Cougar", sColor); break;
        case 217: return color_ConvertString("White Tiger", sColor); break;
        case 218: return color_ConvertString("Cat", sColor); break;
        case 219: return color_ConvertString("Pig", sColor); break;
        case 220: return color_ConvertString("Falcon", sColor); break;
        case 221: return color_ConvertString("Raven", sColor); break;
        case 222: return color_ConvertString("Bat", sColor); break;
        case 223: return color_ConvertString("Penguin", sColor); break;
        case 224: return color_ConvertString("Chicken", sColor); break;
        case 225: return color_ConvertString("Deer", sColor); break;
        case 226: return color_ConvertString("White Stag", sColor); break;
        case 227: return color_ConvertString("Cow", sColor); break;
        case 228: return color_ConvertString("Rat", sColor); break;
        case 229: return color_ConvertString("Mouse", sColor); break;
        case 230: return color_ConvertString("Racoon", sColor); break;
        case 231: return color_ConvertString("Ferret", sColor); break;
        case 232: return color_ConvertString("Skunk", sColor); break;
        case 233: return color_ConvertString("Swamp Viper", sColor); break;
        case 234: return color_ConvertString("Treant", sColor); break;
    }
    return "default";
}

void SetDruidWildShape(object oPC, int TargetShape)
{
    int TargetSpell = GetLocalInt(oPC, CS_DRUID_VAR_TARGETSPELL);
    SetLocalInt(oPC, CS_DRUID_VAR_SHAPE + "_" + IntToString(TargetSpell), TargetShape + 1);
}

//Smoking Function by Jason Robinson
location GetLocationAboveAndInFrontOf(object oPC, float fDist, float fHeight)
{
    float fDistance = -fDist;
    object oTarget = (oPC);
    object oArea = GetArea(oTarget);
    vector vPosition = GetPosition(oTarget);
    vPosition.z += fHeight;
    float fOrientation = GetFacing(oTarget);
    vector vNewPos = AngleToVector(fOrientation);
    float vZ = vPosition.z;
    float vX = vPosition.x - fDistance * vNewPos.x;
    float vY = vPosition.y - fDistance * vNewPos.y;
    fOrientation = GetFacing(oTarget);
    vX = vPosition.x - fDistance * vNewPos.x;
    vY = vPosition.y - fDistance * vNewPos.y;
    vNewPos = AngleToVector(fOrientation);
    vZ = vPosition.z;
    vNewPos = Vector(vX, vY, vZ);
    return Location(oArea, vNewPos, fOrientation);
}

//Smoking Function by Jason Robinson
void SmokePipe(object oActivator)
{
    string sEmote1 = "*puffs on a pipe*";
    string sEmote2 = "*inhales from a pipe*";
    string sEmote3 = "*pulls a mouthful of smoke from a pipe*";
    float fHeight = 1.7;
    float fDistance = 0.1;
    // Set height based on race and gender
    if (GetGender(oActivator) == GENDER_MALE)
    {
        switch (GetRacialType(oActivator))
        {
            case RACIAL_TYPE_HUMAN:
            case RACIAL_TYPE_HALFELF: fHeight = 1.7; fDistance = 0.12; break;
            case RACIAL_TYPE_ELF: fHeight = 1.55; fDistance = 0.08; break;
            case RACIAL_TYPE_GNOME:
            case RACIAL_TYPE_HALFLING: fHeight = 1.15; fDistance = 0.12; break;
            case RACIAL_TYPE_DWARF: fHeight = 1.2; fDistance = 0.12; break;
            case RACIAL_TYPE_HALFORC: fHeight = 1.9; fDistance = 0.2; break;
        }
    }
    else
    {
        // FEMALES
        switch (GetRacialType(oActivator))
        {
            case RACIAL_TYPE_HUMAN:
            case RACIAL_TYPE_HALFELF: fHeight = 1.6; fDistance = 0.12; break;
            case RACIAL_TYPE_ELF: fHeight = 1.45; fDistance = 0.12; break;
            case RACIAL_TYPE_GNOME:
            case RACIAL_TYPE_HALFLING: fHeight = 1.1; fDistance = 0.075; break;
            case RACIAL_TYPE_DWARF: fHeight = 1.2; fDistance = 0.1; break;
            case RACIAL_TYPE_HALFORC: fHeight = 1.8; fDistance = 0.13; break;
        }
    }
    location lAboveHead = GetLocationAboveAndInFrontOf(oActivator, fDistance, fHeight);
    // emotes
    switch (d3())
    {
        case 1: AssignCommand(oActivator, ActionSpeakString(sEmote1)); break;
        case 2: AssignCommand(oActivator, ActionSpeakString(sEmote2)); break;
        case 3: AssignCommand(oActivator, ActionSpeakString(sEmote3));break;
    }
    // glow red
    AssignCommand(oActivator, ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_LIGHT_RED_5), oActivator, 0.15)));
    // wait a moment
    AssignCommand(oActivator, ActionWait(3.0));
    // puff of smoke above and in front of head
    AssignCommand(oActivator, ActionDoCommand(ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), lAboveHead)));
    // if female, turn head to left
    if ((GetGender(oActivator) == GENDER_FEMALE) && (GetRacialType(oActivator) != RACIAL_TYPE_DWARF))
        AssignCommand(oActivator, ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 1.0, 5.0));
}

// EmoteDance credit DMFI
void EmoteDance(object oPC)
{
    object oRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object oLeftHand =  GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);

    AssignCommand(oPC,ActionUnequipItem(oRightHand));
    AssignCommand(oPC,ActionUnequipItem(oLeftHand));

    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_FIREFORGET_VICTORY2,1.0));
    AssignCommand(oPC,ActionDoCommand(PlayVoiceChat(VOICE_CHAT_LAUGH,oPC)));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_LOOPING_TALK_LAUGHING, 2.0, 2.0));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_FIREFORGET_VICTORY1,1.0));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_FIREFORGET_VICTORY3,2.0));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_LOOPING_GET_MID, 3.0, 1.0));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_LOOPING_TALK_FORCEFUL,1.0));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_FIREFORGET_VICTORY2,1.0));
    AssignCommand(oPC,ActionDoCommand(PlayVoiceChat(VOICE_CHAT_LAUGH,oPC)));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_LOOPING_TALK_LAUGHING, 2.0, 2.0));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_FIREFORGET_VICTORY1,1.0));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_FIREFORGET_VICTORY3,2.0));
    AssignCommand(oPC,ActionDoCommand(PlayVoiceChat(VOICE_CHAT_LAUGH,oPC)));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_LOOPING_GET_MID, 3.0, 1.0));
    AssignCommand(oPC,ActionPlayAnimation( ANIMATION_FIREFORGET_VICTORY2,1.0));

    AssignCommand(oPC,ActionDoCommand(ActionEquipItem(oLeftHand,INVENTORY_SLOT_LEFTHAND)));
    AssignCommand(oPC,ActionDoCommand(ActionEquipItem(oRightHand,INVENTORY_SLOT_RIGHTHAND)));
}

void DoEmote(object oPC, int nAnimation, float fDuration = 0.0f)
{
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionPlayAnimation(nAnimation, 1.0, fDuration));
}

string GetRollPrivacy(object oPC, int nShort)
{
    int nRollPrivacy = GetLocalInt(oPC, CS_ROLLS_VAR_PRIVACY);
    string sReturn;
    switch (nRollPrivacy)
    {
        case CHR_ROLL_PRIVACY_PUBLIC:
            sReturn = color_ConvertString("Public", COLOR_GREY);
            if (!nShort)
                sReturn += " - nearby players can see your rolls";
            return sReturn;
            break;
        case CHR_ROLL_PRIVACY_PRIVATE:
            sReturn = color_ConvertString("Private", COLOR_GREY);
            if (!nShort)
                sReturn += " - only you can see your rolls";
            return sReturn;
            break;
    }
    return "Error";
}

void Roll(object oPC, int nCount)
{
    int nDieType = GetLocalInt(oPC, CS_ROLLS_VAR_DIETYPE);
    switch (nDieType)
    {
        case CI_ACTION_ROLLS_DIE_D4: chr_DoDieRoll(oPC, 4, nCount, TRUE, TRUE, TRUE); break;
        case CI_ACTION_ROLLS_DIE_D6: chr_DoDieRoll(oPC, 6, nCount, TRUE, TRUE, TRUE); break;
        case CI_ACTION_ROLLS_DIE_D8: chr_DoDieRoll(oPC, 8, nCount, TRUE, TRUE, TRUE); break;
        case CI_ACTION_ROLLS_DIE_D10: chr_DoDieRoll(oPC, 10, nCount, TRUE, TRUE, TRUE); break;
        case CI_ACTION_ROLLS_DIE_D12: chr_DoDieRoll(oPC, 12, nCount, TRUE, TRUE, TRUE); break;
        case CI_ACTION_ROLLS_DIE_D20: chr_DoDieRoll(oPC, 20, nCount, TRUE, TRUE, TRUE); break;
        case CI_ACTION_ROLLS_DIE_D100: chr_DoDieRoll(oPC, 100, nCount, TRUE, TRUE, TRUE); break;
    }
    DeleteLocalInt(oPC, CS_ROLLS_VAR_DIETYPE);
}

void main()
{
   object oPC = OBJECT_SELF;
   int nConditional = GetLocalInt(oPC, CS_DLG_PC_CONDITIONAL_ID);
   int nAction = GetLocalInt(oPC, CS_DLG_PC_ACTION_ID);
   string sNodeText = GetLocalString(oPC, CS_DLG_PC_NODETEXT);
   object oAdditional = GetLocalObject(oPC, CS_DLG_PC_ADDITIONALOBJECT);

   switch (nConditional)
   {
      case -1: SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE); break;
      case CI_CONDITIONAL_ISDM:
         SetLocalInt(oPC, CS_DLG_PC_RESULT, GetIsDM(oPC));
         break;
      case CI_CONDITION_ROLLS_PRIVACY_OVERRIDE:
         dlg_OverrideNodeText(oPC, "Change Privacy (Currently: " + GetRollPrivacy(oPC, TRUE) + ")");
         SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         break;
      case CI_CONDITION_ROLLS_NODIETYPE:
         if (GetLocalInt(oPC, CS_ROLLS_VAR_DIETYPE) == 0)
            SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         else
            SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
         break;
      case CI_CONDITIONAL_BROWNBEAR:
         dlg_OverrideNodeText(oPC, "Brown Bear (Currently set to " + GetDruidWildShape(oAdditional, CI_ACTION_DRUID_POLYMORPH_SET_BROWNBEAR) + ")");
         SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         break;
      case CI_CONDITIONAL_PANTHER:
         dlg_OverrideNodeText(oPC, "Panther (Currently set to " + GetDruidWildShape(oAdditional, CI_ACTION_DRUID_POLYMORPH_SET_PANTHER) + ")");
         SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         break;
      case CI_CONDITIONAL_WOLF:
         dlg_OverrideNodeText(oPC, "Wolf (Currently set to " + GetDruidWildShape(oAdditional, CI_ACTION_DRUID_POLYMORPH_SET_WOLF) + ")");
         SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         break;
      case CI_CONDITIONAL_BOAR:
         dlg_OverrideNodeText(oPC, "Boar (Currently set to " + GetDruidWildShape(oAdditional, CI_ACTION_DRUID_POLYMORPH_SET_BOAR) + ")");
         SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         break;
      case CI_CONDITIONAL_BADGER:
         dlg_OverrideNodeText(oPC, "Badger (Currently set to " + GetDruidWildShape(oAdditional, CI_ACTION_DRUID_POLYMORPH_SET_BADGER) + ")");
         SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         break;
      case CI_CONDITIONAL_IS_DRUID:
         if (GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0)
            SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         else
            SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
         break;
      case CI_CONDITIONAL_HAS_DRUID_LEVELS_5:
         if (GetLevelByClass(CLASS_TYPE_DRUID, oPC) < 5)
            SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
         else
            SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         break;
      case CI_CONDITIONAL_HAS_DRUID_LEVELS_ADDITIONAL_OPTIONS:
         if (GetLevelByClass(CLASS_TYPE_DRUID, oPC) < CI_REQUIRED_DRUID_LEVELS_FOR_ADDITONAL_OPTIONS)
            SetLocalInt(oPC, CS_DLG_PC_RESULT, FALSE);
         else
            SetLocalInt(oPC, CS_DLG_PC_RESULT, TRUE);
         break;
   }

   object oElementalAltar;
   switch (nAction)
   {
      case -1: break;
      // AFK
      case CI_ACTION_AFK_ACTIVATE: chr_SetAFKStatus(oPC, TRUE); break;
      case CI_ACTION_AFK_DEACTIVATE: chr_SetAFKStatus(oPC, FALSE); break;
      // Emotes: Fire and Forget
      case CI_ACTION_EMOTE_FF_BOW: DoEmote(oPC, ANIMATION_FIREFORGET_BOW); break;
      case CI_ACTION_EMOTE_FF_DODGE_DUCK: DoEmote(oPC, ANIMATION_FIREFORGET_DODGE_DUCK); break;
      case CI_ACTION_EMOTE_FF_DODGE_SIDE: DoEmote(oPC, ANIMATION_FIREFORGET_DODGE_SIDE); break;
      case CI_ACTION_EMOTE_FF_DRINK: DoEmote(oPC, ANIMATION_FIREFORGET_DRINK); break;
      case CI_ACTION_EMOTE_FF_GREETING: DoEmote(oPC, ANIMATION_FIREFORGET_GREETING); break;
      case CI_ACTION_EMOTE_FF_PAUSE_BORED: DoEmote(oPC, ANIMATION_FIREFORGET_PAUSE_BORED); break;
      case CI_ACTION_EMOTE_FF_PAUSE_SCRATCH_HEAD: DoEmote(oPC, ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD); break;
      case CI_ACTION_EMOTE_FF_READ: DoEmote(oPC, ANIMATION_FIREFORGET_READ); break;
      case CI_ACTION_EMOTE_FF_SALUTE: DoEmote(oPC, ANIMATION_FIREFORGET_SALUTE); break;
      case CI_ACTION_EMOTE_FF_SPASM: DoEmote(oPC, ANIMATION_FIREFORGET_SPASM); break;
      case CI_ACTION_EMOTE_FF_STEAL: DoEmote(oPC, ANIMATION_FIREFORGET_STEAL); break;
      case CI_ACTION_EMOTE_FF_TAUNT: DoEmote(oPC, ANIMATION_FIREFORGET_TAUNT); break;
      case CI_ACTION_EMOTE_FF_VICTORY1: DoEmote(oPC, ANIMATION_FIREFORGET_VICTORY1); break;
      case CI_ACTION_EMOTE_FF_VICTORY2: DoEmote(oPC, ANIMATION_FIREFORGET_VICTORY2); break;
      case CI_ACTION_EMOTE_FF_VICTORY3: DoEmote(oPC, ANIMATION_FIREFORGET_VICTORY3); break;
      // Emotes: Continous
      case CI_ACTION_EMOTE_LOOP_CONJURE1: DoEmote(oPC, ANIMATION_LOOPING_CONJURE1, 9999.0f); break;
      case CI_ACTION_EMOTE_LOOP_CONJURE2: DoEmote(oPC, ANIMATION_LOOPING_CONJURE2, 9999.0f); break;
      case CI_ACTION_EMOTE_LOOP_DEAD_BACK: DoEmote(oPC, ANIMATION_LOOPING_DEAD_BACK, 9999.0f); break;
      case CI_ACTION_EMOTE_LOOP_DEAD_FRONT: DoEmote(oPC, ANIMATION_LOOPING_DEAD_FRONT, 9999.0f); break;
      case CI_ACTION_EMOTE_LOOP_GET_LOW: DoEmote(oPC, ANIMATION_LOOPING_GET_LOW, 9999.0f); break;
      case CI_ACTION_EMOTE_LOOP_GET_MID: DoEmote(oPC, ANIMATION_LOOPING_GET_MID, 9999.0f); break;
      case CI_ACTION_EMOTE_LOOP_LISTEN: DoEmote(oPC, ANIMATION_LOOPING_LISTEN, 9999.0f); break;
      case CI_ACTION_EMOTE_LOOP_LOOK_FAR: DoEmote(oPC, ANIMATION_LOOPING_LOOK_FAR, 9999.0f); break;
      case CI_ACTION_EMOTE_LOOP_MEDITATE:
         DoEmote(oPC, ANIMATION_LOOPING_MEDITATE, 9999.0f);

         // Elemental Trial
         oElementalAltar = GetNearestObjectByTag ("ElementalAltar", oPC);
         if (oElementalAltar != OBJECT_INVALID &&
             GetDistanceBetween(oPC, oElementalAltar) < 5.0)
            Elemental_Altar(GetName(oElementalAltar), oPC);

         break;
      case CI_ACTION_EMOTE_LOOP_PAUSE: DoEmote(oPC, ANIMATION_LOOPING_PAUSE, 9999.0f); break;
      case CI_ACTION_EMOTE_LOOP_PAUSE_DRUNK: DoEmote(oPC, ANIMATION_LOOPING_PAUSE_DRUNK, 9999.0f); break;
      case CI_ACTION_EMOTE_LOOP_PAUSE_TIRED: DoEmote(oPC, ANIMATION_LOOPING_PAUSE_TIRED, 9999.0f); break;
      case CI_ACTION_EMOTE_LOOP_PAUSE2: DoEmote(oPC, ANIMATION_LOOPING_PAUSE2, 9999.0f); break;
      case CI_ACTION_EMOTE_LOOP_SIT_CROSS: DoEmote(oPC, ANIMATION_LOOPING_SIT_CROSS, 9999.0f); break;
      case CI_ACTION_EMOTE_LOOP_SPASM: DoEmote(oPC, ANIMATION_LOOPING_SPASM, 9999.0f); break;
      case CI_ACTION_EMOTE_LOOP_TALK_FORCEFUL: DoEmote(oPC, ANIMATION_LOOPING_TALK_FORCEFUL, 9999.0f); break;
      case CI_ACTION_EMOTE_LOOP_TALK_LAUGHING: DoEmote(oPC, ANIMATION_LOOPING_TALK_LAUGHING, 9999.0f); break;
      case CI_ACTION_EMOTE_LOOP_TALK_NORMAL: DoEmote(oPC, ANIMATION_LOOPING_TALK_NORMAL, 9999.0f); break;
      case CI_ACTION_EMOTE_LOOP_TALK_PLEADING: DoEmote(oPC, ANIMATION_LOOPING_TALK_PLEADING, 9999.0f); break;
      case CI_ACTION_EMOTE_LOOP_WORSHIP: DoEmote(oPC, ANIMATION_LOOPING_WORSHIP, 9999.0f); break;
      // Emotes: Custom
      case CI_ACTION_EMOTE_CUSTOM_DANCE: EmoteDance(oPC); break;
      case CI_ACTION_EMOTE_CUSTOM_SMOKE: SmokePipe(oPC); break;
      // Privacy
      case CI_ACTION_PRIVACY_SET_PRIVATE: SetLocalInt(oPC, CS_ROLLS_VAR_PRIVACY, CHR_ROLL_PRIVACY_PRIVATE); break;
      case CI_ACTION_PRIVACY_SET_PUBLIC: SetLocalInt(oPC, CS_ROLLS_VAR_PRIVACY, CHR_ROLL_PRIVACY_PUBLIC); break;
      // Checks
      case CI_ACTION_ABILITY_STRENGTH: chr_DoAbilityCheck(oPC, ABILITY_STRENGTH, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_ABILITY_DEXTERITY: chr_DoAbilityCheck(oPC, ABILITY_DEXTERITY, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_ABILITY_CONSTITUTION: chr_DoAbilityCheck(oPC, ABILITY_CONSTITUTION, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_ABILITY_WISDOM: chr_DoAbilityCheck(oPC, ABILITY_WISDOM, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_ABILITY_INTELLIGENCE: chr_DoAbilityCheck(oPC, ABILITY_INTELLIGENCE, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_ABILITY_CHARISMA: chr_DoAbilityCheck(oPC, ABILITY_CHARISMA, 0, TRUE, TRUE, TRUE); break;
      // Saving Throws
      case CI_ACTION_SAVINGTHROW_FORTITUDE: chr_DoSavingThrow(oPC, SAVING_THROW_FORT, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SAVINGTHROW_REFLEX: chr_DoSavingThrow(oPC, SAVING_THROW_REFLEX, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SAVINGTHROW_WILL: chr_DoSavingThrow(oPC, SAVING_THROW_WILL, 0, TRUE, TRUE, TRUE); break;
      // Die Rolls
      case CI_ACTION_ROLLS_DIE_D4: SetLocalInt(oPC, CS_ROLLS_VAR_DIETYPE, nAction); break;
      case CI_ACTION_ROLLS_DIE_D6: SetLocalInt(oPC, CS_ROLLS_VAR_DIETYPE, nAction); break;
      case CI_ACTION_ROLLS_DIE_D8: SetLocalInt(oPC, CS_ROLLS_VAR_DIETYPE, nAction); break;
      case CI_ACTION_ROLLS_DIE_D10: SetLocalInt(oPC, CS_ROLLS_VAR_DIETYPE, nAction); break;
      case CI_ACTION_ROLLS_DIE_D12: SetLocalInt(oPC, CS_ROLLS_VAR_DIETYPE, nAction); break;
      case CI_ACTION_ROLLS_DIE_D20: SetLocalInt(oPC, CS_ROLLS_VAR_DIETYPE, nAction); break;
      case CI_ACTION_ROLLS_DIE_D100: SetLocalInt(oPC, CS_ROLLS_VAR_DIETYPE, nAction); break;
      case CI_ACTION_ROLLS_DICE_1: Roll(oPC, 1); break;
      case CI_ACTION_ROLLS_DICE_2: Roll(oPC, 2); break;
      case CI_ACTION_ROLLS_DICE_3: Roll(oPC, 3); break;
      case CI_ACTION_ROLLS_DICE_4: Roll(oPC, 4); break;
      case CI_ACTION_ROLLS_DICE_5: Roll(oPC, 5); break;
      case CI_ACTION_ROLLS_DICE_6: Roll(oPC, 6); break;
      case CI_ACTION_ROLLS_DICE_7: Roll(oPC, 7); break;
      case CI_ACTION_ROLLS_DICE_8: Roll(oPC, 8); break;
      case CI_ACTION_ROLLS_DICE_9: Roll(oPC, 9); break;
      case CI_ACTION_ROLLS_DICE_10: Roll(oPC, 10); break;
      case CI_ACTION_ROLLS_DIE_DELETE: DeleteLocalInt(oPC, CS_ROLLS_VAR_DIETYPE); break;
      // Skill Checks
      case CI_ACTION_SKILLCHECK_ANIMALEMPATHY: chr_DoSkillCheck(oPC, SKILL_ANIMAL_EMPATHY, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_APPRAISE: chr_DoSkillCheck(oPC, SKILL_APPRAISE, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_BLUFF: chr_DoSkillCheck(oPC, SKILL_BLUFF, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_CONCENTRATION: chr_DoSkillCheck(oPC, SKILL_CONCENTRATION, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_CRAFT_ARMOR: chr_DoSkillCheck(oPC, SKILL_CRAFT_ARMOR, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_CRAFT_TRAP: chr_DoSkillCheck(oPC, SKILL_CRAFT_TRAP, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_CRAFT_WEAPON: chr_DoSkillCheck(oPC, SKILL_CRAFT_WEAPON, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_DISABLE_TRAP: chr_DoSkillCheck(oPC, SKILL_DISABLE_TRAP, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_DISCIPLINE: chr_DoSkillCheck(oPC, SKILL_DISCIPLINE, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_HEAL: chr_DoSkillCheck(oPC, SKILL_HEAL, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_HIDE: chr_DoSkillCheck(oPC, SKILL_HIDE, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_INTIMIDATE: chr_DoSkillCheck(oPC, SKILL_INTIMIDATE, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_LISTEN: chr_DoSkillCheck(oPC, SKILL_LISTEN, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_LORE: chr_DoSkillCheck(oPC, SKILL_LORE, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_MOVE_SILENTLY: chr_DoSkillCheck(oPC, SKILL_MOVE_SILENTLY, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_OPEN_LOCK: chr_DoSkillCheck(oPC, SKILL_OPEN_LOCK, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_PARRY: chr_DoSkillCheck(oPC, SKILL_PARRY, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_PERFORM: chr_DoSkillCheck(oPC, SKILL_PERFORM, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_PERSUADE: chr_DoSkillCheck(oPC, SKILL_PERSUADE, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_PICK_POCKET: chr_DoSkillCheck(oPC, SKILL_PICK_POCKET, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_RIDE: chr_DoSkillCheck(oPC, SKILL_RIDE, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_SEARCH: chr_DoSkillCheck(oPC, SKILL_SEARCH, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_SET_TRAP: chr_DoSkillCheck(oPC, SKILL_SET_TRAP, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_SPELLCRAFT: chr_DoSkillCheck(oPC, SKILL_SPELLCRAFT, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_SPOT: chr_DoSkillCheck(oPC, SKILL_SPOT, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_TAUNT: chr_DoSkillCheck(oPC, SKILL_TAUNT, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_TUMBLE: chr_DoSkillCheck(oPC, SKILL_TUMBLE, 0, TRUE, TRUE, TRUE); break;
      case CI_ACTION_SKILLCHECK_USE_MAGIC_DEVICE: chr_DoSkillCheck(oPC, SKILL_USE_MAGIC_DEVICE, 0, TRUE, TRUE, TRUE); break;
      // Druid Wild Shape
      case CI_ACTION_DRUID_POLYMORPH_SET_BROWNBEAR: SetLocalInt(oAdditional, CS_DRUID_VAR_TARGETSPELL, nAction); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_PANTHER: SetLocalInt(oAdditional, CS_DRUID_VAR_TARGETSPELL, nAction); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_WOLF: SetLocalInt(oAdditional, CS_DRUID_VAR_TARGETSPELL, nAction); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_BOAR: SetLocalInt(oAdditional, CS_DRUID_VAR_TARGETSPELL, nAction); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_BADGER: SetLocalInt(oAdditional, CS_DRUID_VAR_TARGETSPELL, nAction); break;

      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_BADGER: SetDruidWildShape(oAdditional, POLYMORPH_TYPE_BADGER); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_BOAR: SetDruidWildShape(oAdditional, POLYMORPH_TYPE_BOAR); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_BROWNBEAR: SetDruidWildShape(oAdditional, POLYMORPH_TYPE_BROWN_BEAR); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_CHICKEN: SetDruidWildShape(oAdditional, POLYMORPH_TYPE_CHICKEN); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_COW: SetDruidWildShape(oAdditional, POLYMORPH_TYPE_COW); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_DIREBADGER: SetDruidWildShape(oAdditional, POLYMORPH_TYPE_DIRE_BADGER); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_DIREBOAR: SetDruidWildShape(oAdditional, POLYMORPH_TYPE_DIRE_BOAR); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_DIREBROWNBEAR: SetDruidWildShape(oAdditional, POLYMORPH_TYPE_DIRE_BROWN_BEAR); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_DIREPANTHER: SetDruidWildShape(oAdditional, POLYMORPH_TYPE_DIRE_PANTHER); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_DIREWOLF: SetDruidWildShape(oAdditional, POLYMORPH_TYPE_DIRE_WOLF); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_DIRETIGER: SetDruidWildShape(oAdditional, POLYMORPH_TYPE_DIRETIGER); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_GIANTSPIDER: SetDruidWildShape(oAdditional, POLYMORPH_TYPE_GIANT_SPIDER); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_PANTHER: SetDruidWildShape(oAdditional, POLYMORPH_TYPE_PANTHER); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_PENGUIN: SetDruidWildShape(oAdditional, POLYMORPH_TYPE_PENGUIN); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_WOLF: SetDruidWildShape(oAdditional, POLYMORPH_TYPE_WOLF); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_WINTERWOLF: SetDruidWildShape(oAdditional, 102); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_BLACK_BEAR: SetDruidWildShape(oAdditional, 210); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_GRIZZLY_BEAR: SetDruidWildShape(oAdditional, 211); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_POLAR_BEAR: SetDruidWildShape(oAdditional, 212); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_WILDDOG: SetDruidWildShape(oAdditional, 213); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_WINTERWOLF_OVERRIDE: SetDruidWildShape(oAdditional, 214); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_PUPPY: SetDruidWildShape(oAdditional, 215); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_COUGAR: SetDruidWildShape(oAdditional, 216); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_WHITETIGER: SetDruidWildShape(oAdditional, 217); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_HOUSECAT: SetDruidWildShape(oAdditional, 218); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_PIG: SetDruidWildShape(oAdditional, 219); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_FALCON: SetDruidWildShape(oAdditional, 220); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_RAVEN: SetDruidWildShape(oAdditional, 221); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_BAT: SetDruidWildShape(oAdditional, 222); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_PENGUIN_OVERRIDE: SetDruidWildShape(oAdditional, 223); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_CHICKEN_OVERRIDE: SetDruidWildShape(oAdditional, 224); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_DEER: SetDruidWildShape(oAdditional, 225); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_WHITESTAG: SetDruidWildShape(oAdditional, 226); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_COW_OVERRIDE: SetDruidWildShape(oAdditional, 227); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_RAT: SetDruidWildShape(oAdditional, 228); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_MOUSE: SetDruidWildShape(oAdditional, 229); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_RACOON: SetDruidWildShape(oAdditional, 230); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_FERRET: SetDruidWildShape(oAdditional, 231); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_SKUNK: SetDruidWildShape(oAdditional,232 ); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_SWAMPVIPER: SetDruidWildShape(oAdditional, 233); break;
      case CI_ACTION_DRUID_POLYMORPH_SET_SHAPE_TREANT: SetDruidWildShape(oAdditional, 234); break;
   }
}
