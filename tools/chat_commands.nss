#include "color_inc"
#include "dbg_inc"
#include "chr_inc"
#include "nwnx_player"
#include "nwnx_creature"
#include "nwnx_time"
#include "nwnx_admin"
#include "anph_inc"

const string BADPARSE = "[BADPARSE]";
string ParseCommand(string sMessage, string sCommand)
{
    int sCommandLen = GetStringLength(sCommand);
    if (GetStringLeft(sMessage, sCommandLen) == sCommand)
        return GetSubString(sMessage, sCommandLen+1, GetStringLength(sMessage)-sCommandLen-1);
    else
        return BADPARSE;
}

void main()
{
    object oPC = GetPCChatSpeaker();
    string sMessage = GetPCChatMessage();
    int nVolume = GetPCChatVolume();
    string sParams;

    if ((sParams = ParseCommand(sMessage, "/help")) != BADPARSE)
    {
        string sHelp = "Available chat commands:\n" +
            COLOR_CODE_GREEN + "/bug [text]  "  + COLOR_CODE_END + "- Report a bug to the team\n" +
            COLOR_CODE_GREEN + "/walk        "  + COLOR_CODE_END + "- Toggle always walk mode\n" +
            COLOR_CODE_GREEN + "/helm        "  + COLOR_CODE_END + "- Toggle helm visibility\n" +
            COLOR_CODE_GREEN + "/cloak       "  + COLOR_CODE_END + "- Toggle cloak visibility\n" +
            COLOR_CODE_GREEN + "/roll        "  + COLOR_CODE_END + "- Roll dice, ability/skill check or save\n" +
            COLOR_CODE_GREEN + "/e           "  + COLOR_CODE_END + "- perform a quick emote\n" +
            COLOR_CODE_GREEN + "/note        "  + COLOR_CODE_END + "- Start writing a new note\n" +
            COLOR_CODE_GREEN + "/deity [name] " + COLOR_CODE_END + "- Convert to worship a deity\n" +
            COLOR_CODE_GREEN + "/dmg [f|c|a|l] " + COLOR_CODE_END + "- Switch spell damage type\n" +
            COLOR_CODE_GREEN + "/spar        "  + COLOR_CODE_END + "- Toggle sparring mode\n" +
            COLOR_CODE_GREEN + "/horn [signal] "  + COLOR_CODE_END + "- Blow your faction's horn\n" +
            COLOR_CODE_GREEN + "/rest        "  + COLOR_CODE_END + "- Check your current rest timer\n" +
            COLOR_CODE_GREEN + "/soundset [number]   "  + COLOR_CODE_END + "- Change your current soundset\n" +
            COLOR_CODE_GREEN + "/head [number]   "  + COLOR_CODE_END + "- Change your current head model\n" +
            COLOR_CODE_GREEN + "/delete [password] "  + COLOR_CODE_END + "- Delete current character from vault\n" +
            COLOR_CODE_GREEN + "/stats        "  + COLOR_CODE_END + "- See some stats about the current character\n" +
            COLOR_CODE_GREEN + "/vfx [1-18] "  + COLOR_CODE_END + "- Apply an additional visual effect to character\n" +
            COLOR_CODE_GREEN + "/dispell        "  + COLOR_CODE_END + "- Remove all beneficial spell effects from self\n" +
            "To quickslot a command macro, it needs to be prefixed with /tk, such as '/tk /walk'";

        SendMessageToPC(oPC, sHelp);
    }
    else if ((sParams = ParseCommand(sMessage, "/bug")) != BADPARSE)
    {
        dbg_ReportBug(sParams, oPC);
    }
    else if ((sParams = ParseCommand(sMessage, "/walk")) != BADPARSE)
    {
        int bWalk = !GetLocalInt(oPC, "WALK_MODE");
        SendMessageToPC(oPC, "Always walk mode " + (bWalk ? "on" : "off"));
        SetLocalInt(oPC, "WALK_MODE", bWalk);
        NWNX_Player_SetAlwaysWalk(oPC, bWalk);
        NWNX_Creature_SetWalkRateCap(oPC, bWalk ? 2000.0f : -1.0f);
    }
    else if ((sParams = ParseCommand(sMessage, "/helm")) != BADPARSE)
    {
        object oHelm = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC);
        int bHidden = !GetHiddenWhenEquipped(oHelm);
        SetHiddenWhenEquipped(oHelm, bHidden);
        SendMessageToPC(oPC, "Helmet appearance " + (bHidden ? "hidden" : "shown"));
    }
    else if ((sParams = ParseCommand(sMessage, "/cloak")) != BADPARSE)
    {
        object oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);
        int bHidden = !GetHiddenWhenEquipped(oCloak);
        SetHiddenWhenEquipped(oCloak, bHidden);
        SendMessageToPC(oPC, "Cloak appearance " + (bHidden ? "hidden" : "shown"));
    }
    else if ((sParams = ParseCommand(sMessage, "/roll")) != BADPARSE)
    {
        sParams = GetStringLowerCase(sParams);
        string sRollHelp = "Available rolls:\n" +
                "d2, d3, d4, d6, d8, d10, d12, d20, d100 - Roll a die without modifiers\n" +
                "str, dex, con, int, wis, cha            - Roll d20 + ability modifier\n" +
                "reflex, will, fort                      - Roll d20 + save\n" +
                "animal, appraise, bluff, conc, \n" +
                "distrap, disc, heal, hide, intim, \n" +
                "listen, lore, ms, lock, parry, perform\n" +
                "persuade, pp, search, spell, spot\n" +
                "settrap, taunt, tumble, umd             - Roll d20 + skill modifier\n" +
                "Type '/roll #[cmd]' to roll in private (only visible to DMs)";
        int bPrivate = FALSE;

        if (GetStringLeft(sParams, 1) == "#")
        {
            bPrivate = TRUE;
            sParams = GetSubString(sParams, 1, GetStringLength(sParams)-1);
        }
        SetLocalInt(oPC, CS_ROLLS_VAR_PRIVACY, bPrivate ? CHR_ROLL_PRIVACY_PRIVATE : CHR_ROLL_PRIVACY_PUBLIC);

             if (sParams == "d2")    chr_DoDieRoll(oPC, 2, 1, TRUE, FALSE, TRUE);
        else if (sParams == "d3")    chr_DoDieRoll(oPC, 3, 1, TRUE, FALSE, TRUE);
        else if (sParams == "d4")    chr_DoDieRoll(oPC, 4, 1, TRUE, FALSE, TRUE);
        else if (sParams == "d6")    chr_DoDieRoll(oPC, 6, 1, TRUE, FALSE, TRUE);
        else if (sParams == "d8")    chr_DoDieRoll(oPC, 8, 1, TRUE, FALSE, TRUE);
        else if (sParams == "d10")   chr_DoDieRoll(oPC, 10, 1, TRUE, FALSE, TRUE);
        else if (sParams == "d12")   chr_DoDieRoll(oPC, 12, 1, TRUE, FALSE, TRUE);
        else if (sParams == "d20")   chr_DoDieRoll(oPC, 20, 1, TRUE, FALSE, TRUE);
        else if (sParams == "d100")  chr_DoDieRoll(oPC, 100, 1, TRUE, FALSE, TRUE);
        // Abilities
        else if (sParams == "str")   chr_DoAbilityCheck(oPC, ABILITY_STRENGTH, 0, !bPrivate);
        else if (sParams == "dex")   chr_DoAbilityCheck(oPC, ABILITY_DEXTERITY, 0, !bPrivate);
        else if (sParams == "con")   chr_DoAbilityCheck(oPC, ABILITY_CONSTITUTION, 0, !bPrivate);
        else if (sParams == "int")   chr_DoAbilityCheck(oPC, ABILITY_INTELLIGENCE, 0, !bPrivate);
        else if (sParams == "wis")   chr_DoAbilityCheck(oPC, ABILITY_WISDOM, 0, !bPrivate);
        else if (sParams == "cha")   chr_DoAbilityCheck(oPC, ABILITY_CHARISMA, 0, !bPrivate);
        // Saves
        else if (sParams == "fort")    chr_DoSavingThrow(oPC, SAVING_THROW_FORT, 0, !bPrivate);
        else if (sParams == "will")    chr_DoSavingThrow(oPC, SAVING_THROW_WILL, 0, !bPrivate);
        else if (sParams == "reflex")  chr_DoSavingThrow(oPC, SAVING_THROW_REFLEX, 0, !bPrivate);
        // skills
        else if (sParams == "animal")    chr_DoSkillCheck(oPC, SKILL_ANIMAL_EMPATHY, 0, !bPrivate);
        else if (sParams == "appraise")  chr_DoSkillCheck(oPC, SKILL_APPRAISE, 0, !bPrivate);
        else if (sParams == "bluff")     chr_DoSkillCheck(oPC, SKILL_BLUFF, 0, !bPrivate);
        else if (sParams == "conc")      chr_DoSkillCheck(oPC, SKILL_CONCENTRATION, 0, !bPrivate);
        else if (sParams == "distrap")   chr_DoSkillCheck(oPC, SKILL_DISABLE_TRAP, 0, !bPrivate);
        else if (sParams == "disc")      chr_DoSkillCheck(oPC, SKILL_DISCIPLINE, 0, !bPrivate);
        else if (sParams == "heal")      chr_DoSkillCheck(oPC, SKILL_HEAL, 0, !bPrivate);
        else if (sParams == "hide")      chr_DoSkillCheck(oPC, SKILL_HIDE, 0, !bPrivate);
        else if (sParams == "intim")     chr_DoSkillCheck(oPC, SKILL_INTIMIDATE, 0, !bPrivate);
        else if (sParams == "listen")    chr_DoSkillCheck(oPC, SKILL_LISTEN, 0, !bPrivate);
        else if (sParams == "lore")      chr_DoSkillCheck(oPC, SKILL_LORE, 0, !bPrivate);
        else if (sParams == "ms")        chr_DoSkillCheck(oPC, SKILL_MOVE_SILENTLY, 0, !bPrivate);
        else if (sParams == "lock")      chr_DoSkillCheck(oPC, SKILL_OPEN_LOCK, 0, !bPrivate);
        else if (sParams == "parry")     chr_DoSkillCheck(oPC, SKILL_PARRY, 0, !bPrivate);
        else if (sParams == "perform")   chr_DoSkillCheck(oPC, SKILL_PERFORM, 0, !bPrivate);
        else if (sParams == "persuade")  chr_DoSkillCheck(oPC, SKILL_PERSUADE, 0, !bPrivate);
        else if (sParams == "pp")        chr_DoSkillCheck(oPC, SKILL_PICK_POCKET, 0, !bPrivate);
        else if (sParams == "search")    chr_DoSkillCheck(oPC, SKILL_SEARCH, 0, !bPrivate);
        else if (sParams == "spell")     chr_DoSkillCheck(oPC, SKILL_SPELLCRAFT, 0, !bPrivate);
        else if (sParams == "spot")      chr_DoSkillCheck(oPC, SKILL_SPOT, 0, !bPrivate);
        else if (sParams == "settrap")   chr_DoSkillCheck(oPC, SKILL_SET_TRAP, 0, !bPrivate);
        else if (sParams == "taunt")     chr_DoSkillCheck(oPC, SKILL_TAUNT, 0, !bPrivate);
        else if (sParams == "tumble")    chr_DoSkillCheck(oPC, SKILL_TUMBLE, 0, !bPrivate);
        else if (sParams == "umd")       chr_DoSkillCheck(oPC, SKILL_USE_MAGIC_DEVICE, 0, !bPrivate);

        else if (sParams == "") SendMessageToPC(oPC, sRollHelp);
        else SendMessageToPC(oPC, "Unknown roll '" + sParams + "'\n" + sRollHelp);
    }
    else if ((sParams = ParseCommand(sMessage, "/e")) != BADPARSE)
    {
        AssignCommand(oPC, ClearAllActions());
        if (sParams == "worship")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0, 1000.0));
        else if (sParams == "dance")
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
        else if (sParams == "read")
        {
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
            DelayCommand(3.0, AssignCommand( oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_READ)));
        }
        else if (sParams == "sit")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, 1000.0));
        else if (sParams == "drunk")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK, 1.0, 1000.0));
        else if (sParams == "plead")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 1000.0));
        else if (sParams == "tired")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED, 1.0, 1000.0));
        else if (sParams == "forceful")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL, 1.0, 1000.0));
        else if (sParams == "laugh")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0, 1000.0));
        else if (sParams == "victory")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1, 1.0, 1000.0));
        else if (sParams == "victory2")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2, 1.0, 1000.0));
        else if (sParams == "victory3")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY3, 1.0, 1000.0));
        else if (sParams == "low")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1000.0));
        else if (sParams == "mid")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1000.0));
        else if (sParams == "dead")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 1000.0));
        else if (sParams == "deadback")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 1000.0));
        else if (sParams == "listen")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_LISTEN, 1.0, 1000.0));
        else if (sParams == "cast")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0, 1000.0));
        else if (sParams == "cast2")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2, 1.0, 1000.0));
        else if (sParams == "look")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_LOOK_FAR, 1.0, 1000.0));
        else if (sParams == "meditate")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 1000.0));
        else if (sParams == "bow")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_BOW));
        else if (sParams == "duck")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DODGE_DUCK));
        else if (sParams == "dodge")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DODGE_SIDE));
        else if (sParams == "drink")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
        else if (sParams == "greet")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_GREETING));
        else if (sParams == "salute")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_SALUTE));
        else if (sParams == "taunt")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT));
        else if (sParams == "spasm")
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM));
        else
        {
            SendMessageToPC(oPC, "Available emotes: worship, dance, read, sit, drunk, plead, tired, "
                + "forceful, laugh, victory, victory2, victory3, low, mid, dead, deadback, listen, "
                + "cast, cast2, look, meditate, bow, duck, dodge, drink, greet, salute, taunt, spasm");
        }

    }
    else if ((sParams = ParseCommand(sMessage, "/note")) != BADPARSE)
    {
        object oNote = CreateItemOnObject("note_item", oPC);
        SignalEvent(GetModule(), EventActivateItem(oNote, GetLocation(oPC)));
    }
    else if ((sParams = ParseCommand(sMessage, "/deity")) != BADPARSE)
    {
        SetDeity(oPC, sParams);
        ExportSingleCharacter(oPC);
        SendMessageToPC(oPC, "You are now worshipping " + COLOR_CODE_GREEN + sParams + COLOR_CODE_END);
        string sMsg = GetName(oPC) + " has converted to " + sParams;
        SendMessageToAllDMs(COLOR_CODE_BLUE_DARK + sMsg + COLOR_CODE_END);
        WriteTimestampedLogEntry(sMsg);
    }
    else if ((sParams = ParseCommand(sMessage, "/dmg")) != BADPARSE)
    {
        string sDmg = GetStringLowerCase(GetSubString(sParams, 0, 1));
        if (sDmg == "f")
        {
            SendMessageToPC(oPC, "Switching to fire-based spells.");
            SetLocalInt(oPC, "SPELL_DAMAGE_TYPE", IP_CONST_DAMAGETYPE_FIRE);
        }
        else if (sDmg == "c")
        {
            SendMessageToPC(oPC, "Switching to cold-based spells.");
            SetLocalInt(oPC, "SPELL_DAMAGE_TYPE", IP_CONST_DAMAGETYPE_COLD);
        }
        else if (sDmg == "a")
        {
            SendMessageToPC(oPC, "Switching to acid-based spells.");
            SetLocalInt(oPC, "SPELL_DAMAGE_TYPE", IP_CONST_DAMAGETYPE_ACID);
        }
        else if (sDmg == "l")
        {
            SendMessageToPC(oPC, "Switching to lightning-based spells.");
            SetLocalInt(oPC, "SPELL_DAMAGE_TYPE", IP_CONST_DAMAGETYPE_ELECTRICAL);
        }
        else
        {
            SendMessageToPC(oPC, "Set the damage type for some customizable spells. Availble: [f]ire, [a]cid, [c]old, [l]ightning.");
        }
    }
    else if ((sParams = ParseCommand(sMessage, "/spar")) != BADPARSE)
    {
        int bSpar = !GetLocalInt(oPC, "FACTION_SPARRING_MODE");
        SendMessageToPC(oPC, "Sparring mode " + (bSpar ? "on" : "off"));
        SetLocalInt(oPC, "FACTION_SPARRING_MODE", bSpar);
        fctn_UpdateReputation(oPC);
    }
    else if ((sParams = ParseCommand(sMessage, "/horn")) != BADPARSE)
    {
        AnphSendWarningCall(oPC, StringToInt(sParams));
    }
    else if ((sParams = ParseCommand(sMessage, "/rest")) != BADPARSE)
    {
        int tNow = NWNX_Time_GetTimeStamp();
        int tLastRest = GetLocalInt(oPC, CHR_REST_VAR_REST_TIME);
        int tDifference = tNow - tLastRest;

        if (tDifference < FloatToInt(HoursToSeconds(CHR_REST_INTERVAL_HOURS)))
        {
            float fHoursToWait = (HoursToSeconds(CHR_REST_INTERVAL_HOURS) - tDifference) / HoursToSeconds(1);
            SendMessageToPC(oPC, "You may rest again in " + FloatToString(fHoursToWait, 2, 1) + " hours.");
        }
        else
        {
            SendMessageToPC(oPC, "You are tired enough to rest now.");
        }
    }
    else if ((sParams = ParseCommand(sMessage, "/soundset")) != BADPARSE)
    {
        int nCurrentVoice = NWNX_Creature_GetSoundset(oPC);
        int nNew = StringToInt(sParams);
        if (nNew > 0 || sParams == "0")
        {
            NWNX_Creature_SetSoundset(oPC, nNew);
            SendMessageToPC(oPC, "Soundset changed from " + IntToString(nCurrentVoice) + " to " + IntToString(nNew));
        }
        else
        {
            SendMessageToPC(oPC, "Your current soundset is " + IntToString(nCurrentVoice));
        }
    }
    else if ((sParams = ParseCommand(sMessage, "/delete")) != BADPARSE)
    {
        string sPassword = "yes I really do want to delete this character immediately";
        if (sParams == sPassword)
        {
            NWNX_Administration_DeletePlayerCharacter(oPC, TRUE);
        }
        else
        {
            SendMessageToPC(oPC, COLOR_CODE_RED + "This command will delete your character from the server!" + COLOR_CODE_END);
            SendMessageToPC(oPC, COLOR_CODE_RED + "------------------------" + COLOR_CODE_END);
            SendMessageToPC(oPC, "To proceed, type '/detete " + sPassword + "' without the quotes. You must match the case perfectly.");
            SendMessageToPC(oPC, COLOR_CODE_RED + "------------------------" + COLOR_CODE_END);
            SendMessageToPC(oPC, COLOR_CODE_RED + "This command will delete your character from the server!" + COLOR_CODE_END);
        }
    }
    else if ((sParams = ParseCommand(sMessage, "/head")) != BADPARSE)
    {
        int nCurrentModel = GetCreatureBodyPart(CREATURE_PART_HEAD, oPC);
        int nNew = StringToInt(sParams);
        if (nNew > 0 || sParams == "0")
        {
            SetCreatureBodyPart(CREATURE_PART_HEAD, nNew, oPC);
            SendMessageToPC(oPC, "Head model changed from " + IntToString(nCurrentModel) + " to " + IntToString(nNew));
        }
        else
        {
            SendMessageToPC(oPC, "Your current head model is " + IntToString(nCurrentModel));
        }
    }
    else if ((sParams = ParseCommand(sMessage, "/stats")) != BADPARSE)
    {
        string sPCID = IntToString(chr_GetPCID(oPC));
        NWNX_SQL_ExecuteQuery("SELECT Deaths, PVPKills, Playtime, DonatedStuff, xp/playtime, playtime/xp FROM "
                                +SQL_TABLE_CHARDATA+" WHERE PCID="+sPCID);

        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            string sDeaths = NWNX_SQL_ReadDataInActiveRow(0);
            string sPVPKills = NWNX_SQL_ReadDataInActiveRow(1);
            string sPlaytime = NWNX_SQL_ReadDataInActiveRow(2);
            string sDonated = NWNX_SQL_ReadDataInActiveRow(3);
            string sXPPerSec = NWNX_SQL_ReadDataInActiveRow(4);
            string sSecPerXP = NWNX_SQL_ReadDataInActiveRow(5);

            string sMessage = "---------------------------\n" +
                              "You are PCID " + COLOR_CODE_GREEN + sPCID + COLOR_CODE_END + "\n" +
                              "Total deaths: "+ COLOR_CODE_GREEN + sDeaths + COLOR_CODE_END + "\n" +
                              "Total PvP Kills: "+ COLOR_CODE_GREEN + sPVPKills + COLOR_CODE_END + "\n" +
                              "Total playtime: "+ COLOR_CODE_GREEN + sPlaytime + COLOR_CODE_END +" seconds (~" + COLOR_CODE_GREEN+ IntToString((StringToInt(sPlaytime)+1800) / 3600) + COLOR_CODE_END + " hours)\n" +
                              "Total gear donated worth: " +  COLOR_CODE_GREEN + sDonated + COLOR_CODE_END + "\n" +
                              "Average XP points gained per second: " + COLOR_CODE_GREEN + sXPPerSec + COLOR_CODE_END + "\n" +
                              "Average playtime (seconds) per XP point: " + COLOR_CODE_GREEN + sSecPerXP + COLOR_CODE_END + "\n" +
                              "---------------------------\n";
            SendMessageToPC(oPC, sMessage);
        }
        else
        {
            dbg_Warning("Error getting stats from database", oPC);
        }
    }
    else if ((sParams = ParseCommand(sMessage, "/vfx")) != BADPARSE)
    {
        effect e = GetFirstEffect(oPC);
        while (GetIsEffectValid(e))
        {
            if (GetEffectTag(e) == "CHAT_CMD_VFX")
            {
                RemoveEffect(oPC, e);
                break;
            }
            e = GetNextEffect(oPC);
        }

        int n = StringToInt(sParams);
        if (n > 0 && n < 19)
        {
            n--; // 0 based
            if (n < 14) // Helms
            {
                n += 4300 + GetRacialType(oPC)*60 + GetGender(oPC)*30;
            }
            else if (n < 17)
            {
                n = (n-14) + 4760 + GetRacialType(oPC)*20 + GetGender(oPC)*10;
            }
            else if (n < 18)
            {
                n = (n-17) + 6736 + GetRacialType(oPC)*2 + GetGender(oPC);
            }

            e = EffectVisualEffect(n);
            e = TagEffect(e, "CHAT_CMD_VFX");
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, e, oPC);
        }
        else
        {
            SendMessageToPC(oPC, "Invalid VFX number specified, removing.");
        }
    }
    else if ((sParams = ParseCommand(sMessage, "/dispell")) != BADPARSE)
    {
        effect e = GetFirstEffect(oPC);
        while (GetIsEffectValid(e))
        {
            // Dispell positive efects only
            switch (GetEffectType(e))
            {
                case EFFECT_TYPE_DAMAGE_RESISTANCE:
                case EFFECT_TYPE_REGENERATE:
                case EFFECT_TYPE_DAMAGE_REDUCTION:
                case EFFECT_TYPE_TEMPORARY_HITPOINTS:
                case EFFECT_TYPE_INVULNERABLE:
                case EFFECT_TYPE_IMMUNITY:
                case EFFECT_TYPE_HASTE:
                case EFFECT_TYPE_ABILITY_INCREASE:
                case EFFECT_TYPE_ATTACK_INCREASE:
                case EFFECT_TYPE_DAMAGE_INCREASE:
                case EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE:
                case EFFECT_TYPE_AC_INCREASE:
                case EFFECT_TYPE_MOVEMENT_SPEED_INCREASE:
                case EFFECT_TYPE_SAVING_THROW_INCREASE:
                case EFFECT_TYPE_SPELL_RESISTANCE_INCREASE:
                case EFFECT_TYPE_SKILL_INCREASE:
                case EFFECT_TYPE_INVISIBILITY:
                case EFFECT_TYPE_IMPROVEDINVISIBILITY:
                case EFFECT_TYPE_ELEMENTALSHIELD:
                case EFFECT_TYPE_POLYMORPH:
                case EFFECT_TYPE_SANCTUARY:
                case EFFECT_TYPE_TRUESEEING:
                case EFFECT_TYPE_SEEINVISIBLE:
                case EFFECT_TYPE_TIMESTOP:
                case EFFECT_TYPE_SPELLLEVELABSORPTION:
                case EFFECT_TYPE_ULTRAVISION:
                case EFFECT_TYPE_CONCEALMENT:
                case EFFECT_TYPE_SPELL_IMMUNITY:
                case EFFECT_TYPE_VISUALEFFECT:
                case EFFECT_TYPE_TURN_RESISTANCE_INCREASE:
                case EFFECT_TYPE_ETHEREAL:

                if (GetEffectSubType(e) == SUBTYPE_MAGICAL && GetEffectDurationType(e) == DURATION_TYPE_TEMPORARY)
                    RemoveEffect(oPC, e);
            }
            e = GetNextEffect(oPC);
        }
    }
    else
    {
        // Don't handle unknown commands
        return;
    }
    SetPCChatMessage("");
}
