/************************************************************************
 * script name  : eE_evt_execute
 * created by   : eyesolated
 * date         : 2011/6/1
 *
 * description  : Executes the calling Event.
 *
 * changes      : 2010/6/1 - eyesolated - Initial creation
 ************************************************************************/

// Includes
#include "eE_inc"

void EventType_Entity(object oEncounter, object oEvent, int nObjectType, int nEventMode)
{
   struct eE_EVENT_ENTITY stEntity = eE_GetInfo_Entity(oEvent);
   struct eE_EVENT_ENTITYEVENTS stEntityEvents = eE_GetInfo_EntityEvents(oEvent);

   if (nEventMode == eE_EVENTMODE_CREATE)
   {
      eE_CreateEncounterEntity(oEncounter, oEvent, nObjectType, stEntity, stEntityEvents);
   }
   else if (nEventMode == eE_EVENTMODE_UNDO)
   {
      eE_DestroyEncounterEntity(oEncounter, stEntity.Tag);
   }
}

void EventEffect_RemoveEffect(object oTarget, string EffectTag)
{
   effect eEffect = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffect))
   {
      //eE_DebugMSG(oEncounter, "Found effect [" + GetEffectTag(eEffect) + "] on " + GetName(oTarget));
      if (GetEffectTag(eEffect) == EffectTag)
      {
         //eE_DebugMSG(oEncounter, "Removing effect [" + stVFX.EffectTag + "] from " + GetName(oTarget));
         RemoveEffect(oTarget, eEffect);
      }
      eEffect = GetNextEffect(oTarget);
   }
}

// Helper method for EffectDisappearAppear to Destroy an "appearing" object if the encounter is no longer active
void Effect_DisappearAppear_OnAppear(object oEncounter, object oTarget)
{
    // Turn off immortality
    SetImmortal(oTarget, FALSE);

    // If the encounter is no longer active, Destroy oObject
    if (eE_GetEncounterStatus(oEncounter) != eE_ENCOUNTER_STATUS_INPROGRESS)
        DestroyObject(oTarget);
}

// Helper method for EffectDisappearAppear
void Effect_DisappearAppear_Disappear(object oTarget, struct eE_EVENT_EFFECT stEffect, effect eEffect)
{
    // Immortalize Target
    SetImmortal(oTarget, TRUE);

    // Apply eEffect
    ApplyEffectToObject(stEffect.DurationType, eEffect, oTarget, stEffect.Duration);
}

void EventType_Effect(object oEncounter, object oEvent, int nEventMode, int nAutomaticUndo)
{
   struct eE_EVENT_EFFECT stEffect = eE_GetInfo_EventEffect(oEvent);
   object oOwner = stEffect.OwnerObject;
   string sArrayName = "VFX_t_" + stEffect.Owner;

   if (nEventMode == eE_EVENTMODE_CREATE)
   {
      // Create an Object Array for the "Owners" of this VFX Event
      eas_Array_Create(oEncounter, eE_VAR_EVENTOWNERS, EAS_ARRAY_TYPE_OBJECT);

      int nOwnerCount;
      if (stEffect.Owner == eE_EVENTOWNER_SELF)
      {
         // Only one "Owner"
         eas_OArray_Entry_Add(oEncounter, eE_VAR_EVENTOWNERS, oOwner);
      }
      else
      {
         // Multiple "Owners"
         nOwnerCount = 0;
         oOwner = GetNearestObjectByTag(stEffect.Owner, oEncounter, nOwnerCount + 1);
         while (
                (
                 (GetIsObjectValid(oOwner))
                )
                &&
                (
                 (nOwnerCount <= stEffect.Quantity) ||
                 (stEffect.Quantity == -1)
                )
               )
         {
            eas_OArray_Entry_Add(oEncounter, eE_VAR_EVENTOWNERS, oOwner);
            nOwnerCount += 1;
            oOwner = GetNearestObjectByTag(stEffect.Owner, oEncounter, nOwnerCount + 1);
         }
      }

      object oTarget;
      location lTargetLocation;
      int nArraySize = eas_Array_GetSize(oEncounter, eE_VAR_EVENTOWNERS);
      effect eEffect;
      object oOwner;

      if (stEffect.EffectType == eE_EFFECT_TYPE_BEAM)
      {
         // Create the array to hold all target objects for later removal of effects
         eas_Array_Create(oEncounter, sArrayName, EAS_ARRAY_TYPE_OBJECT);

         if ((stEffect.TargetMethod == eE_TARGETMETHOD_RANDOM) || (stEffect.TargetMethod == eE_TARGETMETHOD_FIXED))
         {
            // Determine the target of the action
            oTarget = eE_GetActionTarget(oEncounter, stEffect.Tag, stEffect.TargetMethod);
            if (nAutomaticUndo == eE_UNDO_AUTOMATIC){eas_OArray_Entry_Add(oEncounter, sArrayName, oTarget);}
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               eE_SetLastTarget(oOwner, oTarget);
               eEffect = EffectBeam(stEffect.VisualEffect, oOwner, BODY_NODE_CHEST);
               eEffect = TagEffect(eEffect, stEffect.EffectTag);
               AssignCommand(oOwner, DelayCommand(stEffect.Delay * (nOwnerCount - 1), ApplyEffectToObject(stEffect.DurationType, eEffect, oTarget, stEffect.Duration)));
            }
         }
         else if (stEffect.TargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || stEffect.TargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
         {
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               oTarget = eE_GetActionTarget(oEncounter, stEffect.Tag, stEffect.TargetMethod, 1, oOwner);
               eE_SetLastTarget(oOwner, oTarget);
               if (nAutomaticUndo == eE_UNDO_AUTOMATIC) { eas_OArray_Entry_Add(oEncounter, sArrayName, oTarget); }
               eEffect = EffectBeam(stEffect.VisualEffect, oOwner, BODY_NODE_CHEST);
               eEffect = TagEffect(eEffect, stEffect.EffectTag);
               AssignCommand(oOwner, DelayCommand(stEffect.Delay * (nOwnerCount - 1), ApplyEffectToObject(stEffect.DurationType, eEffect, oTarget, stEffect.Duration)));
            }
         }
         else if (stEffect.TargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL || stEffect.TargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || stEffect.TargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST)
         {
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               oTarget = eE_GetActionTarget(oEncounter, stEffect.Tag, stEffect.TargetMethod, nOwnerCount, oOwner);
               eE_SetLastTarget(oOwner, oTarget);
               if (nAutomaticUndo == eE_UNDO_AUTOMATIC) { eas_OArray_Entry_Add(oEncounter, sArrayName, oTarget); }
               eEffect = EffectBeam(stEffect.VisualEffect, oOwner, BODY_NODE_CHEST);
               eEffect = TagEffect(eEffect, stEffect.EffectTag);
               AssignCommand(oOwner, DelayCommand(stEffect.Delay * (nOwnerCount - 1), ApplyEffectToObject(stEffect.DurationType, eEffect, oTarget, stEffect.Duration)));
            }
         }
      }
      else if (stEffect.Effect == eE_EFFECT_EFFECT_DISAPPEARAPPEAR)
      {
         if ((stEffect.TargetMethod == eE_TARGETMETHOD_RANDOM) || (stEffect.TargetMethod == eE_TARGETMETHOD_FIXED))
         {
            // Determine the target of the action
            oTarget = eE_GetActionTarget(oEncounter, stEffect.Tag, stEffect.TargetMethod);
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               eE_SetLastTarget(oOwner, oTarget);
               eEffect = EffectDisappearAppear(GetLocation(oTarget));
               AssignCommand(oEncounter, DelayCommand(stEffect.Delay * (nOwnerCount - 1), Effect_DisappearAppear_Disappear(oTarget, stEffect, eEffect)));
               AssignCommand(oEncounter, DelayCommand(stEffect.Delay * (nOwnerCount - 1) + stEffect.Duration + 0.1f, Effect_DisappearAppear_OnAppear(oEncounter, oTarget)));
            }
         }
         else if (stEffect.TargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || stEffect.TargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
         {
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               oTarget = eE_GetActionTarget(oEncounter, stEffect.Tag, stEffect.TargetMethod, 1, oOwner);
               eE_SetLastTarget(oOwner, oTarget);
               eEffect = EffectDisappearAppear(GetLocation(oTarget));
               AssignCommand(oEncounter, DelayCommand(stEffect.Delay * (nOwnerCount - 1), Effect_DisappearAppear_Disappear(oTarget, stEffect, eEffect)));
               AssignCommand(oEncounter, DelayCommand(stEffect.Delay * (nOwnerCount - 1) + stEffect.Duration + 0.1f, Effect_DisappearAppear_OnAppear(oEncounter, oTarget)));
            }
         }
         else if (stEffect.TargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL || stEffect.TargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || stEffect.TargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST)
         {
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               oTarget = eE_GetActionTarget(oEncounter, stEffect.Tag, stEffect.TargetMethod, nOwnerCount, oOwner);
               eE_SetLastTarget(oOwner, oTarget);
               eEffect = EffectDisappearAppear(GetLocation(oTarget));
               AssignCommand(oEncounter, DelayCommand(stEffect.Delay * (nOwnerCount - 1), ApplyEffectToObject(stEffect.DurationType, eEffect, oTarget, stEffect.Duration)));
               AssignCommand(oEncounter, DelayCommand(stEffect.Delay * (nOwnerCount - 1) + stEffect.Duration + 0.1f, Effect_DisappearAppear_OnAppear(oEncounter, oTarget)));
            }
         }
      }
      else
      {
         effect eVisual;
         effect eApplied;

         if (stEffect.EffectType == eE_EFFECT_TYPE_AOE_LOCATION ||
             stEffect.EffectType == eE_EFFECT_TYPE_AOE_OBJECT)
            eVisual = EffectAreaOfEffect(stEffect.VisualEffect, "***", "***", "***");
         else
            eVisual = EffectVisualEffect(stEffect.VisualEffect);

         switch (stEffect.Effect)
         {
            case eE_NULL: break;
            case eE_EFFECT_EFFECT_ABILITYDECREASE: eApplied = EffectAbilityDecrease(stEffect.Effect_Var1, stEffect.Effect_Var2); break;
            case eE_EFFECT_EFFECT_ABILITYINCREASE: eApplied = EffectAbilityIncrease(stEffect.Effect_Var1, stEffect.Effect_Var2); break;
            case eE_EFFECT_EFFECT_ACDECREASE: eApplied = EffectACDecrease(stEffect.Effect_Var1, stEffect.Effect_Var2, stEffect.Effect_Var3); break;
            case eE_EFFECT_EFFECT_ACINCREASE: eApplied = EffectACIncrease(stEffect.Effect_Var1, stEffect.Effect_Var2, stEffect.Effect_Var3); break;
            case eE_EFFECT_EFFECT_APPEAR: eApplied = EffectAppear(); break;
            case eE_EFFECT_EFFECT_ATTACKDECREASE: eApplied = EffectAttackDecrease(stEffect.Effect_Var1, stEffect.Effect_Var2); break;
            case eE_EFFECT_EFFECT_ATTACKINCREASE: eApplied = EffectAttackIncrease(stEffect.Effect_Var1, stEffect.Effect_Var2); break;
            case eE_EFFECT_EFFECT_BLINDNESS: eApplied = EffectBlindness(); break;
            case eE_EFFECT_EFFECT_CHARMED: eApplied = EffectCharmed(); break;
            case eE_EFFECT_EFFECT_CONCEALMENT: eApplied = EffectConcealment(stEffect.Effect_Var1, stEffect.Effect_Var2); break;
            case eE_EFFECT_EFFECT_CONFUSED: eApplied = EffectConfused(); break;
            case eE_EFFECT_EFFECT_CURSE: eApplied = EffectCurse(stEffect.Effect_Var1, stEffect.Effect_Var2, stEffect.Effect_Var3, stEffect.Effect_Var4, stEffect.Effect_Var5, stEffect.Effect_Var6); break;
            case eE_EFFECT_EFFECT_CUTSCENEDOMINATED: eApplied = EffectCutsceneDominated(); break;
            case eE_EFFECT_EFFECT_CUTSCENEGHOST: eApplied = EffectCutsceneGhost(); break;
            case eE_EFFECT_EFFECT_CUTSCENEIMMOBILIZE: eApplied = EffectCutsceneImmobilize(); break;
            case eE_EFFECT_EFFECT_CUTSCENEPARALYZE: eApplied = EffectCutsceneParalyze(); break;
            case eE_EFFECT_EFFECT_DAMAGE: eApplied = EffectDamage(stEffect.Effect_Var1, stEffect.Effect_Var2, stEffect.Effect_Var3); break;
            case eE_EFFECT_EFFECT_DAMAGEDECREASE: eApplied = EffectDamageDecrease(stEffect.Effect_Var1, stEffect.Effect_Var2); break;
            case eE_EFFECT_EFFECT_DAMAGEIMMUNITYDECREASE: eApplied = EffectDamageImmunityDecrease(stEffect.Effect_Var1, stEffect.Effect_Var2); break;
            case eE_EFFECT_EFFECT_DAMAGEIMMUNITYINCREASE: eApplied = EffectDamageImmunityIncrease(stEffect.Effect_Var1, stEffect.Effect_Var2); break;
            case eE_EFFECT_EFFECT_DAMAGEINCREASE: eApplied = EffectDamageIncrease(stEffect.Effect_Var1, stEffect.Effect_Var2); break;
            case eE_EFFECT_EFFECT_DAMAGEREDUCTION: eApplied = EffectDamageReduction(stEffect.Effect_Var1, stEffect.Effect_Var2, stEffect.Effect_Var3); break;
            case eE_EFFECT_EFFECT_DAMAGERESISTANCE: eApplied = EffectDamageResistance(stEffect.Effect_Var1, stEffect.Effect_Var2, stEffect.Effect_Var3); break;
            case eE_EFFECT_EFFECT_DAMAGESHIELD: eApplied = EffectDamageShield(stEffect.Effect_Var1, stEffect.Effect_Var2, stEffect.Effect_Var3); break;
            case eE_EFFECT_EFFECT_DARKNESS: eApplied = EffectDarkness(); break;
            case eE_EFFECT_EFFECT_DAZED: eApplied = EffectDazed(); break;
            case eE_EFFECT_EFFECT_DEAF: eApplied = EffectDeaf(); break;
            case eE_EFFECT_EFFECT_DISAPPEAR: eApplied = EffectDisappear(stEffect.Effect_Var1); break;
            case eE_EFFECT_EFFECT_DISEASE: eApplied = EffectDisease(stEffect.Effect_Var1); break;
            case eE_EFFECT_EFFECT_DISPELMAGICALL: eApplied = EffectDispelMagicAll(stEffect.Effect_Var1); break;
            case eE_EFFECT_EFFECT_DISPELMAGICBEAST: eApplied = EffectDispelMagicBest(stEffect.Effect_Var1); break;
            case eE_EFFECT_EFFECT_DOMINATED: eApplied = EffectDominated(); break;
            case eE_EFFECT_EFFECT_ENTANGLE: eApplied = EffectEntangle(); break;
            case eE_EFFECT_EFFECT_ETHEREAL: eApplied = EffectEthereal(); break;
            case eE_EFFECT_EFFECT_FRIGHTENED: eApplied = EffectFrightened(); break;
            case eE_EFFECT_EFFECT_HASTE: eApplied = EffectHaste(); break;
            case eE_EFFECT_EFFECT_HEAL: eApplied = EffectHeal(stEffect.Effect_Var1); break;
            case eE_EFFECT_EFFECT_IMMUNITY: eApplied = EffectImmunity(stEffect.Effect_Var1); break;
            case eE_EFFECT_EFFECT_INVISIBILITY: eApplied = EffectInvisibility(stEffect.Effect_Var1); break;
            case eE_EFFECT_EFFECT_KNOCKDOWN: eApplied = EffectKnockdown(); break;
            case eE_EFFECT_EFFECT_MISSCHANCE: eApplied = EffectMissChance(stEffect.Effect_Var1, stEffect.Effect_Var2); break;
            case eE_EFFECT_EFFECT_MODIFYATTACKS: eApplied = EffectModifyAttacks(stEffect.Effect_Var1); break;
            case eE_EFFECT_EFFECT_MOVEMENTSPEEDDECREASE: eApplied = EffectMovementSpeedDecrease(stEffect.Effect_Var1); break;
            case eE_EFFECT_EFFECT_MOVEMENTSPEEDINCREASE: eApplied = EffectMovementSpeedIncrease(stEffect.Effect_Var1); break;
            case eE_EFFECT_EFFECT_NEGATIVELEVEL: eApplied = EffectNegativeLevel(stEffect.Effect_Var1, stEffect.Effect_Var2); break;
            case eE_EFFECT_EFFECT_PARALYZE: eApplied = EffectParalyze(); break;
            case eE_EFFECT_EFFECT_PETRIFY: eApplied = EffectPetrify(); break;
            case eE_EFFECT_EFFECT_POISON: eApplied = EffectPoison(stEffect.Effect_Var1); break;
            case eE_EFFECT_EFFECT_POLYMORPH: eApplied = EffectPolymorph(stEffect.Effect_Var1, stEffect.Effect_Var2); break;
            case eE_EFFECT_EFFECT_REGENERATE: eApplied = EffectRegenerate(stEffect.Effect_Var1, IntToFloat(stEffect.Effect_Var2)); break; // Regenerate works in INT
            case eE_EFFECT_EFFECT_RESURRECTION: eApplied = EffectResurrection(); break;
            case eE_EFFECT_EFFECT_SANCTUARY: eApplied = EffectSanctuary(stEffect.Effect_Var1); break;
            case eE_EFFECT_EFFECT_SAVINGTHROWDECREASE: eApplied = EffectSavingThrowDecrease(stEffect.Effect_Var1, stEffect.Effect_Var2, stEffect.Effect_Var3); break;
            case eE_EFFECT_EFFECT_SAVINGTHROWINCREASE: eApplied = EffectSavingThrowIncrease(stEffect.Effect_Var1, stEffect.Effect_Var2, stEffect.Effect_Var3); break;
            case eE_EFFECT_EFFECT_SEEINVISIBLE: eApplied = EffectSeeInvisible(); break;
            case eE_EFFECT_EFFECT_SILENCE: eApplied = EffectSilence(); break;
            case eE_EFFECT_EFFECT_SKILLDECREASE: eApplied = EffectSkillDecrease(stEffect.Effect_Var1, stEffect.Effect_Var2); break;
            case eE_EFFECT_EFFECT_SKILLINCREASE: eApplied = EffectSkillIncrease(stEffect.Effect_Var1, stEffect.Effect_Var2); break;
            case eE_EFFECT_EFFECT_SLEEP: eApplied = EffectSleep(); break;
            case eE_EFFECT_EFFECT_SLOW: eApplied = EffectSlow(); break;
            case eE_EFFECT_EFFECT_SPELLFAILURE: eApplied = EffectSpellFailure(stEffect.Effect_Var1, stEffect.Effect_Var2); break;
            case eE_EFFECT_EFFECT_SPELLIMMUNITY: eApplied = EffectSpellImmunity(stEffect.Effect_Var1); break;
            case eE_EFFECT_EFFECT_SPELLLEVELABSORPTION: eApplied = EffectSpellLevelAbsorption(stEffect.Effect_Var1, stEffect.Effect_Var2, stEffect.Effect_Var3); break;
            case eE_EFFECT_EFFECT_SPELLRESISTANCEDECREASE: eApplied = EffectSpellResistanceDecrease(stEffect.Effect_Var1); break;
            case eE_EFFECT_EFFECT_SPELLRESISTANCEINCREASE: eApplied = EffectSpellResistanceIncrease(stEffect.Effect_Var1); break;
            case eE_EFFECT_EFFECT_STUNNED: eApplied = EffectStunned(); break;
            case eE_EFFECT_EFFECT_TEMPORARYHITPOINTS: eApplied = EffectTemporaryHitpoints(stEffect.Effect_Var1); break;
            case eE_EFFECT_EFFECT_TIMESTOP: eApplied = EffectTimeStop(); break;
            case eE_EFFECT_EFFECT_TRUESEEING: eApplied = EffectTrueSeeing(); break;
            case eE_EFFECT_EFFECT_TURNED: eApplied = EffectTurned(); break;
            case eE_EFFECT_EFFECT_TURNRESISTANCEDECREASE: eApplied = EffectTurnResistanceDecrease(stEffect.Effect_Var1); break;
            case eE_EFFECT_EFFECT_TURNRESISTANCEINCREASE: eApplied = EffectTurnResistanceIncrease(stEffect.Effect_Var1); break;
            case eE_EFFECT_EFFECT_ULTRAVISION: eApplied = EffectUltravision(); break;
         }

         if (stEffect.VisualEffect != eE_NULL)
         {
            if (stEffect.Effect != eE_NULL)
                eEffect = EffectLinkEffects(eVisual, eApplied);
            else
                eEffect = eVisual;
         }
         else if (stEffect.Effect != eE_NULL)
            eEffect = eApplied;

         if (stEffect.EffectTag != "")
            eEffect = TagEffect(eEffect, stEffect.EffectTag);

         int nth;
         if (stEffect.Quantity == -1) // We have to find ALL targets and apply the effect
         {
            if (stEffect.Tag == eE_SPAWNTAG_PC)
            {
               int nPCCount = eE_GetEncounterPlayerCount(oEncounter);
               for (nth = 1; nth <= nPCCount; nth++)
               {
                  oTarget = eE_GetEncounterPlayer(oEncounter, nth);
                  if (nAutomaticUndo == eE_UNDO_AUTOMATIC) { eas_OArray_Entry_Add(oEncounter, sArrayName, oTarget); }
                  if (stEffect.EffectType == eE_EFFECT_TYPE_FNF ||
                      stEffect.EffectType == eE_EFFECT_TYPE_AOE_LOCATION)
                  {
                     AssignCommand(oEncounter, DelayCommand(stEffect.Delay * (nOwnerCount - 1), ApplyEffectAtLocation(stEffect.DurationType, eEffect, GetLocation(oTarget), stEffect.Duration)));
                  }
                  else
                  {
                     AssignCommand(oEncounter, DelayCommand(stEffect.Delay * (nOwnerCount - 1), ApplyEffectToObject(stEffect.DurationType, eEffect, oTarget, stEffect.Duration)));
                  }
               }
            }
            else
            {
               int nTargetCount = eE_CountTargets(oEncounter, stEffect.Tag);
               for (nth = 1; nth <= nTargetCount; nth++)
               {
                  oTarget = eE_GetActionTarget(oEncounter, stEffect.Tag, stEffect.TargetMethod, nth);
                  if (nAutomaticUndo == eE_UNDO_AUTOMATIC) { eas_OArray_Entry_Add(oEncounter, sArrayName, oTarget); }
                  if (stEffect.EffectType == eE_EFFECT_TYPE_FNF ||
                      stEffect.EffectType == eE_EFFECT_TYPE_AOE_LOCATION)
                  {
                     AssignCommand(oEncounter, DelayCommand(stEffect.Delay * (nOwnerCount - 1), ApplyEffectAtLocation(stEffect.DurationType, eEffect, GetLocation(oTarget), stEffect.Duration)));
                  }
                  else
                  {
                     AssignCommand(oEncounter, DelayCommand(stEffect.Delay * (nOwnerCount - 1), ApplyEffectToObject(stEffect.DurationType, eEffect, oTarget, stEffect.Duration)));
                  }
               }
            }
         }
         else
         {
            if ((stEffect.TargetMethod == eE_TARGETMETHOD_RANDOM) || (stEffect.TargetMethod == eE_TARGETMETHOD_FIXED))
            {
               oTarget = eE_GetActionTarget(oEncounter, stEffect.Tag, stEffect.TargetMethod);
               if (nAutomaticUndo == eE_UNDO_AUTOMATIC) { eas_OArray_Entry_Add(oEncounter, sArrayName, oTarget); }
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  eE_SetLastTarget(oOwner, oTarget);
                  if (stEffect.EffectType == eE_EFFECT_TYPE_FNF ||
                      stEffect.EffectType == eE_EFFECT_TYPE_AOE_LOCATION)
                  {
                     AssignCommand(oEncounter, DelayCommand(stEffect.Delay * (nOwnerCount - 1), ApplyEffectAtLocation(stEffect.DurationType, eEffect, GetLocation(oTarget), stEffect.Duration)));
                  }
                  else
                  {
                     AssignCommand(oEncounter, DelayCommand(stEffect.Delay * (nOwnerCount - 1), ApplyEffectToObject(stEffect.DurationType, eEffect, oTarget, stEffect.Duration)));
                  }
               }
            }
            else if (stEffect.TargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || stEffect.TargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
            {
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  oTarget = eE_GetActionTarget(oEncounter, stEffect.Tag, stEffect.TargetMethod, 1, oOwner);
                  eE_SetLastTarget(oOwner, oTarget);
                  if (nAutomaticUndo == eE_UNDO_AUTOMATIC) { eas_OArray_Entry_Add(oEncounter, sArrayName, oTarget); }
                  if (stEffect.EffectType == eE_EFFECT_TYPE_FNF ||
                      stEffect.EffectType == eE_EFFECT_TYPE_AOE_LOCATION)
                  {
                     AssignCommand(oEncounter, DelayCommand(stEffect.Delay * (nOwnerCount - 1), ApplyEffectAtLocation(stEffect.DurationType, eEffect, GetLocation(oTarget), stEffect.Duration)));
                  }
                  else
                  {
                     AssignCommand(oEncounter, DelayCommand(stEffect.Delay * (nOwnerCount - 1), ApplyEffectToObject(stEffect.DurationType, eEffect, oTarget, stEffect.Duration)));
                  }
               }
            }
            else if (stEffect.TargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL || stEffect.TargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || stEffect.TargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST)
            {
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  oTarget = eE_GetActionTarget(oEncounter, stEffect.Tag, stEffect.TargetMethod, nOwnerCount, oOwner);
                  eE_SetLastTarget(oOwner, oTarget);
                  if (nAutomaticUndo == eE_UNDO_AUTOMATIC) { eas_OArray_Entry_Add(oEncounter, sArrayName, oTarget); }
                  if (stEffect.EffectType == eE_EFFECT_TYPE_FNF ||
                      stEffect.EffectType == eE_EFFECT_TYPE_AOE_LOCATION)
                  {
                     AssignCommand(oEncounter, DelayCommand(stEffect.Delay * (nOwnerCount - 1), ApplyEffectAtLocation(stEffect.DurationType, eEffect, GetLocation(oTarget), stEffect.Duration)));
                  }
                  else
                  {
                     AssignCommand(oEncounter, DelayCommand(stEffect.Delay * (nOwnerCount - 1), ApplyEffectToObject(stEffect.DurationType, eEffect, oTarget, stEffect.Duration)));
                  }
               }
            }
         }
      }

      // Delete the Owner Array
      eas_Array_Delete(oEncounter, eE_VAR_EVENTOWNERS);
   }
   else if (nEventMode == eE_EVENTMODE_UNDO)
   {
      // Remove all created effects
      int nSize = eas_Array_GetSize(oEncounter, sArrayName);

      // If the size of this array is 0, return
      if (nSize == 0)
         return;

      int n;
      object oTarget;
      for (n = 0; n < nSize; n++)
      {
         oTarget = eas_OArray_Entry_Get(oEncounter, sArrayName, n);
         EventEffect_RemoveEffect(oTarget, stEffect.EffectTag);
      }

      // Delete the Owner Array
      eas_Array_Delete(oEncounter, sArrayName);
   }
}

void EventType_Damage_Location(object oEncounter, location lAffectedLocation, effect eEffect, int ShapeType, float ShapeSize, float SafeZone, int ObjectTypes, float Duration, int Repeats, int Repeat = 0, object oSource = OBJECT_INVALID)
{
   vector vOrigin;
   if (ShapeType != SHAPE_SPHERE &&
       ShapeType != SHAPE_CUBE)
       vOrigin = GetPositionFromLocation(lAffectedLocation);

   object oAffected = GetFirstObjectInShape(ShapeType, ShapeSize, lAffectedLocation, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE, vOrigin);
   int oType;
   int nOK;
   while (GetIsObjectValid(oAffected))
   {
      // SafeZone?
      if (SafeZone == 0.0f ||
          GetDistanceBetweenLocations(lAffectedLocation, GetLocation(oAffected)) > SafeZone)
      {
          nOK = 1;
          oType = GetObjectType(oAffected);
          if (oType == OBJECT_TYPE_CREATURE)
          {
             if (GetIsPC(oAffected) ||
                 GetIsPC(GetMaster(oAffected)))
             {
                if (GetIsDM(oAffected) ||
                    !(ObjectTypes & eE_DAMAGE_OBJECTTYPE_PC))
                {
                   nOK = 0;
                }
             }
             else if (!(ObjectTypes & eE_DAMAGE_OBJECTTYPE_CREATURE))
             {
                nOK = 0;
             }
          }
          else if (oType == OBJECT_TYPE_PLACEABLE &&
                   !(ObjectTypes & eE_DAMAGE_OBJECTTYPE_PLACEABLE))
          {
             nOK = 0;
          }

          if (nOK == 1)
             AssignCommand(oEncounter, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oAffected));
      }
      oAffected = GetNextObjectInShape(ShapeType, ShapeSize, lAffectedLocation, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE, vOrigin);
   }

   if (Repeat < Repeats)
   {
      AssignCommand(oEncounter, DelayCommand(Duration / Repeats, EventType_Damage_Location(oEncounter, lAffectedLocation, eEffect, ShapeType, ShapeSize, SafeZone, ObjectTypes, Duration, Repeats, Repeat + 1, oSource)));
   }
}

void EventType_Damage_Object(object oEncounter, object oTarget, effect eEffect, int ShapeType, float ShapeSize, float SafeZone, int ObjectTypes, float Duration, int Repeats, object oSource = OBJECT_INVALID)
{
   location lAffectedLocation = GetLocation(oTarget);
   EventType_Damage_Location(oEncounter, lAffectedLocation, eEffect, ShapeType, ShapeSize, SafeZone, ObjectTypes, Duration, Repeats, 0, oSource);
}

void EventType_Damage_CreatePlaceable(object oEncounter, string sPlaceable, location lAffectedLocation, float Duration)
{
   object oPlaceable = CreateObject(OBJECT_TYPE_PLACEABLE, sPlaceable, lAffectedLocation);
   SetPlotFlag(oPlaceable, TRUE);
   AssignCommand(oEncounter, DelayCommand(Duration - 0.25f, SetPlotFlag(oPlaceable, FALSE)));
   AssignCommand(oEncounter, DelayCommand(Duration - 0.1f, DestroyObject(oPlaceable)));
}

void EventType_Damage_Execute(object oEncounter, struct eE_EVENT_DAMAGE stDamage, object oTarget, effect eWarning, effect eVFX, effect eDMG, int Duration)
{
    if (stDamage.ObjectOrLocation == eE_OBJECTLOCATION_LOCATION)
    {
        location lAffectedLocation = GetLocation(oTarget);

        if (stDamage.WarningEffect != eE_NULL)
            AssignCommand(oEncounter, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eWarning, GetLocation(oTarget)));
        if (stDamage.WarningPlaceable != "" &&
            stDamage.WarningDelay != 0.0f)
            AssignCommand(oEncounter, EventType_Damage_CreatePlaceable(oEncounter, stDamage.WarningPlaceable, lAffectedLocation, stDamage.WarningDelay));

        if (stDamage.Effect != eE_NULL)
            AssignCommand(oEncounter, DelayCommand(stDamage.WarningDelay, ApplyEffectAtLocation(Duration, eVFX, lAffectedLocation, stDamage.Duration)));
        if (stDamage.EffectPlaceable != "")
            AssignCommand(oEncounter, DelayCommand(stDamage.WarningDelay, EventType_Damage_CreatePlaceable(oEncounter, stDamage.EffectPlaceable, lAffectedLocation, stDamage.Duration)));

        AssignCommand(oEncounter, DelayCommand(stDamage.WarningDelay, EventType_Damage_Location(oEncounter, lAffectedLocation, eDMG, stDamage.ShapeType, stDamage.ShapeSize, stDamage.SafeZone, stDamage.ObjectTypes, stDamage.Duration, stDamage.DamageRepeats)));
    }
    else
    {
        if (stDamage.WarningEffect != eE_NULL)
            AssignCommand(oEncounter, ApplyEffectToObject(DURATION_TYPE_INSTANT, eWarning, oTarget));

        if (stDamage.Effect != eE_NULL)
            AssignCommand(oEncounter, DelayCommand(stDamage.WarningDelay, ApplyEffectToObject(Duration, eVFX, oTarget, stDamage.Duration)));

        AssignCommand(oEncounter, DelayCommand(stDamage.WarningDelay, EventType_Damage_Object(oEncounter, oTarget, eDMG, stDamage.ShapeType, stDamage.ShapeSize, stDamage.SafeZone, stDamage.ObjectTypes, stDamage.Duration, stDamage.DamageRepeats)));
    }
}

void EventType_Damage(object oEncounter, object oEvent)
{
   struct eE_EVENT_DAMAGE stDamage = eE_GetInfo_EventDamage(oEvent);
   object oOwner = stDamage.OwnerObject;

   // Create an Object Array for the "Targets" of this DAMAGE Event
   eas_Array_Create(oEncounter, eE_VAR_EVENTOWNERS, EAS_ARRAY_TYPE_OBJECT);
   int nOwnerCount;
   if (stDamage.Owner == eE_EVENTOWNER_SELF)
   {
      // Only one "Owner"
      eas_OArray_Entry_Add(oEncounter, eE_VAR_EVENTOWNERS, oOwner);
   }
   else
   {
      // Multiple "Owners"
      nOwnerCount = 0;
      oOwner = GetNearestObjectByTag(stDamage.Owner, oEncounter, nOwnerCount + 1);
      while (
             (
              (GetIsObjectValid(oOwner))
             )
             &&
             (
              (nOwnerCount <= stDamage.Quantity) ||
              (stDamage.Quantity == -1)
             )
            )
      {
         eas_OArray_Entry_Add(oEncounter, eE_VAR_EVENTOWNERS, oOwner);
         nOwnerCount += 1;
         oOwner = GetNearestObjectByTag(stDamage.Owner, oEncounter, nOwnerCount + 1);
      }
   }

   object oTarget;
   location lTargetLocation;
   object oAffected;
   location lAffectedLocation;
   int Duration;
   effect eVFX;
   if (stDamage.Duration > 0.0f)
   {
      Duration = DURATION_TYPE_TEMPORARY;
      eVFX = EffectAreaOfEffect(stDamage.Effect, "***", "***", "***");
   }
   else
   {
      Duration = DURATION_TYPE_INSTANT;
      eVFX = EffectVisualEffect(stDamage.Effect);
   }
   effect eDMG;
   if (stDamage.DamageAmount >= 0)
      eDMG = EffectDamage(stDamage.DamageAmount, stDamage.DamageType);
   else
      eDMG = EffectHeal(-stDamage.DamageAmount);
   effect eWarning = EffectVisualEffect(stDamage.WarningEffect);


   int nth;
   if (stDamage.Quantity == -1) // We have to find ALL targets and apply the effect
   {
      if (stDamage.Tag == eE_SPAWNTAG_PC)
      {
         int nPCCount = eE_GetEncounterPlayerCount(oEncounter);
         for (nth = 1; nth <= nPCCount; nth++)
         {
            oTarget = eE_GetEncounterPlayer(oEncounter, nth);
            EventType_Damage_Execute(oEncounter, stDamage, oTarget, eWarning, eVFX, eDMG, Duration);
         }
      }
      else
      {
         int nTargetCount = eE_CountTargets(oEncounter, stDamage.Tag);
         for (nth = 1; nth <= nTargetCount; nth++)
         {
            oTarget = eE_GetActionTarget(oEncounter, stDamage.Tag, stDamage.TargetMethod, nth);
            EventType_Damage_Execute(oEncounter, stDamage, oTarget, eWarning, eVFX, eDMG, Duration);
         }
      }
   }
   else
   {
      int nTries = 0;
      for (nth = 1; nth <= stDamage.Quantity; nth++)
      {
         oTarget = eE_GetActionTarget(oEncounter, stDamage.Tag, stDamage.TargetMethod, nth);
         while (nTries < stDamage.Quantity &&
                eas_OArray_Entry_IndexOf(oEncounter, eE_VAR_EVENTOWNERS, oTarget) != -1)
         {
            nTries++;
            oTarget = eE_GetActionTarget(oEncounter, stDamage.Tag, stDamage.TargetMethod, nth);
         }
         eas_OArray_Entry_Add(oEncounter, eE_VAR_EVENTOWNERS, oTarget);
         if (!GetIsObjectValid(oTarget))
            break;

         EventType_Damage_Execute(oEncounter, stDamage, oTarget, eWarning, eVFX, eDMG, Duration);
      }
   }
   // Delete the Object Array
   eas_Array_Delete(oEncounter, eE_VAR_EVENTOWNERS);
}


void EventType_Special_OpenDoor(object oDoor)
{
   int nLocked = GetLocked(oDoor);
   if (nLocked)
   {
      SetLocalInt(oDoor, "ee_Locked", 1);
      SetLocked(oDoor, FALSE);
   }
   AssignCommand(oDoor, ActionOpenDoor(oDoor));
}

void EventType_Special_CloseDoor(object oDoor)
{
   int nLocked = GetLocalInt(oDoor, "ee_Locked");
   AssignCommand(oDoor, ActionCloseDoor(oDoor));
   if (nLocked == 1)
   {
      DeleteLocalInt(oDoor, "ee_Locked");
      SetLocked(oDoor, TRUE);
   }
}

void EventType_Special_LockDoor(object oDoor)
{
   if (GetIsOpen(oDoor))
   {
      EventType_Special_CloseDoor(oDoor);
      SetLocked(oDoor, TRUE);
   }
}

void EventType_Special_UnlockDoor(object oDoor)
{
   SetLocked(oDoor, FALSE);
}

void EventType_Special_ForceRest(object oObject)
{
   ForceRest(oObject);
}

void EventType_Special_DestroyKillObject(object oObject, object oEncounter, int nAutoUndo, int nDestroyKill)
{
   // If AutoUndo is not set for this event, we don't need to keep track
   // of the things we destroy
   if (nAutoUndo != eE_UNDO_AUTOMATIC)
   {
      if (nDestroyKill == 0)
      {
         DestroyObject(oObject);
      }
      else
      {
         // NWN1
         effect eDeath = EffectDeath(FALSE, TRUE);
         // NWN2
         // effect eDeath = EffectDeath(FALSE, TRUE, TRUE, TRUE);
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oObject);
      }
      return;
   }

   // Retrieve the location and blueprint of this object
   location lLocation = GetLocation(oObject);
   string sResRef = GetResRef(oObject);
   string sTag = GetTag(oObject);
   int nType = GetObjectType(oObject);

   // We need an array for all three variables, stored on the encounter object
   eas_Array_Create(oEncounter, "evts_objLocs", EAS_ARRAY_TYPE_LOCATION);
   eas_Array_Create(oEncounter, "evts_objResRefs", EAS_ARRAY_TYPE_STRING);
   eas_Array_Create(oEncounter, "evts_objTags", EAS_ARRAY_TYPE_STRING);
   eas_Array_Create(oEncounter, "evts_objTypes", EAS_ARRAY_TYPE_INTEGER);

   // Now add the objects information to the Array and remember the Index
   int nIndex = eas_LArray_Entry_Add(oEncounter, "evts_objLocs", lLocation);
   eas_SArray_Entry_Add(oEncounter, "evts_objResRefs", sResRef);
   eas_SArray_Entry_Add(oEncounter, "evts_objTags", sTag);
   eas_IArray_Entry_Add(oEncounter, "evts_objTypes", nType);

   // Destroy/Kill the Object
   if (nDestroyKill == 0)
   {
      DestroyObject(oObject);
   }
   else
   {
      // NWN1
      effect eDeath = EffectDeath(FALSE, TRUE);
      // NWN2
      // effect eDeath = EffectDeath(FALSE, TRUE, TRUE, TRUE);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oObject);
   }
}

void EventType_Special_ReCreateObjects(object oEncounter)
{
   // Recreate all destroyed objects
   int nSize = eas_Array_GetSize(oEncounter, "evts_objLocs");

   // If the size of this array is 0, return
   if (nSize == 0)
      return;

   int n;
   location lLocation;
   string sResRef;
   string sTag;
   int nType;
   for (n = 0; n < nSize; n++)
   {
      lLocation = eas_LArray_Entry_Get(oEncounter, "evts_objLocs", n);
      sResRef = eas_SArray_Entry_Get(oEncounter, "evts_objResRefs", n);
      sTag = eas_SArray_Entry_Get(oEncounter, "evts_objTags", n);
      nType = eas_IArray_Entry_Get(oEncounter, "evts_objTypes", n);

      // Recreate the current object
      CreateObject(nType, sResRef, lLocation, FALSE, sTag);
   }

   // Finally, destroy the Arrays
   eas_Array_Delete(oEncounter, "evts_objLocs");
   eas_Array_Delete(oEncounter, "evts_objResRefs");
   eas_Array_Delete(oEncounter, "evts_objTags");
   eas_Array_Delete(oEncounter, "evts_objTypes");
}

void EventType_Special(object oEncounter, object oEvent, int nEventMode, int nAutomaticUndo)
{
   struct eE_EVENT_SPECIAL stEventSpecial = eE_GetInfo_EventSpecial(oEvent);

   switch (stEventSpecial.EventID)
   {
      case eE_VAR_SPECIAL_ENCOUNTER_DISABLE: // disables an encounter
         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            SetLocalInt(GetObjectByTag(stEventSpecial.Tag), eE_VAR_ENCOUNTER_DISABLED, eE_DISABLED);
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            SetLocalInt(GetObjectByTag(stEventSpecial.Tag), eE_VAR_ENCOUNTER_DISABLED, eE_ENABLED);
         }
      break;
      case eE_VAR_SPECIAL_ENCOUNTER_ENABLE:  // actives an encounter
         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            SetLocalInt(GetObjectByTag(stEventSpecial.Tag), eE_VAR_ENCOUNTER_DISABLED, eE_ENABLED);
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            SetLocalInt(GetObjectByTag(stEventSpecial.Tag), eE_VAR_ENCOUNTER_DISABLED, eE_DISABLED);
         }
      break;
      case eE_VAR_SPECIAL_ENCOUNTER_INITIALIZE: // initializes an encounter
         // Try to initialize the encounter with "Event.Tag"
         if (nEventMode == eE_EVENTMODE_CREATE)
            ExecuteScript(eE_SCRIPT_ENCOUNTER_INITIALIZE, GetObjectByTag(stEventSpecial.Tag));
      break;
      case eE_VAR_SPECIAL_ENCOUNTER_START:
         // Try to start an initialized encounter
         if (nEventMode == eE_EVENTMODE_CREATE)
            ExecuteScript(eE_SCRIPT_ENCOUNTER_START, GetObjectByTag(stEventSpecial.Tag));
      break;
      case eE_VAR_SPECIAL_ENCOUNTER_END:
         // End an encounter and reset it
         if (nEventMode == eE_EVENTMODE_CREATE)
            ExecuteScript(eE_SCRIPT_ENCOUNTER_END, GetObjectByTag(stEventSpecial.Tag));
      break;
      case eE_VAR_SPECIAL_ENCOUNTER_RESET:
         // Reset an encounter
         if (nEventMode == eE_EVENTMODE_CREATE)
            ExecuteScript(eE_SCRIPT_ENCOUNTER_RESET, GetObjectByTag(stEventSpecial.Tag));
      break;
      case eE_VAR_SPECIAL_OPENNEAREST:
         // Open nearest object with Tag
         // The door is automatically unlocked if it is locked and in UNDO mode
         // will automatically be locked again. Doors that aren't locked simply
         // open up and close upon Undo
         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            EventType_Special_OpenDoor(GetNearestObjectByTag(stEventSpecial.Tag, oEncounter));
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            EventType_Special_CloseDoor(GetNearestObjectByTag(stEventSpecial.Tag, oEncounter));
         }
      break;
      case eE_VAR_SPECIAL_OPENALL:
         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            object oDoor = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter);
            int nth = 1;
            while (GetIsObjectValid(oDoor))
            {
               nth += 1;
               EventType_Special_OpenDoor(oDoor);
               oDoor = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter, nth);
            }
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            object oDoor = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter);
            int nth = 1;
            while (GetIsObjectValid(oDoor))
            {
               nth += 1;
               EventType_Special_CloseDoor(oDoor);
               oDoor = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter, nth);
            }
         }
      break;
      case eE_VAR_SPECIAL_CLOSENEAREST:
         // Closes nearest object with Tag
         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            EventType_Special_CloseDoor(GetNearestObjectByTag(stEventSpecial.Tag, oEncounter));
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            EventType_Special_OpenDoor(GetNearestObjectByTag(stEventSpecial.Tag, oEncounter));
         }
      break;
      case eE_VAR_SPECIAL_CLOSEALL:
         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            object oDoor = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter);
            int nth = 1;
            while (GetIsObjectValid(oDoor))
            {
               nth += 1;
               EventType_Special_CloseDoor(oDoor);
               oDoor = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter, nth);
            }
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            object oDoor = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter);
            int nth = 1;
            while (GetIsObjectValid(oDoor))
            {
               nth += 1;
               EventType_Special_OpenDoor(oDoor);
               oDoor = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter, nth);
            }
         }
      break;
      case eE_VAR_SPECIAL_UNLOCKNEAREST:
         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            EventType_Special_UnlockDoor(GetNearestObjectByTag(stEventSpecial.Tag, oEncounter));
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            EventType_Special_LockDoor(GetNearestObjectByTag(stEventSpecial.Tag, oEncounter));
         }
      break;
      case eE_VAR_SPECIAL_UNLOCKALL:
         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            object oDoor = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter);
            int nth = 1;
            while (GetIsObjectValid(oDoor))
            {
               nth += 1;
               EventType_Special_UnlockDoor(oDoor);
               oDoor = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter, nth);
            }
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            object oDoor = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter);
            int nth = 1;
            while (GetIsObjectValid(oDoor))
            {
               nth += 1;
               EventType_Special_LockDoor(oDoor);
               oDoor = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter, nth);
            }
         }
      break;
      case eE_VAR_SPECIAL_LOCKNEAREST:
         // Closes nearest object with Tag
         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            EventType_Special_LockDoor(GetNearestObjectByTag(stEventSpecial.Tag, oEncounter));
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            EventType_Special_UnlockDoor(GetNearestObjectByTag(stEventSpecial.Tag, oEncounter));
         }
      break;
      case eE_VAR_SPECIAL_LOCKALL:
         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            object oDoor = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter);
            int nth = 1;
            while (GetIsObjectValid(oDoor))
            {
               nth += 1;
               EventType_Special_LockDoor(oDoor);
               oDoor = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter, nth);
            }
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            object oDoor = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter);
            int nth = 1;
            while (GetIsObjectValid(oDoor))
            {
               nth += 1;
               EventType_Special_UnlockDoor(oDoor);
               oDoor = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter, nth);
            }
         }
      break;
      case eE_VAR_SPECIAL_SETPLOTFLAGNEAREST:
         // Closes nearest object with Tag
         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            SetPlotFlag(GetNearestObjectByTag(stEventSpecial.Tag, oEncounter), TRUE);
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            SetPlotFlag(GetNearestObjectByTag(stEventSpecial.Tag, oEncounter), FALSE);
         }
      break;
      case eE_VAR_SPECIAL_SETPLOTFLAGALL:
         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            object oTarget = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter);
            int nth = 1;
            while (GetIsObjectValid(oTarget))
            {
               nth += 1;
               SetPlotFlag(oTarget, TRUE);
               oTarget = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter, nth);
            }
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            object oTarget = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter);
            int nth = 1;
            while (GetIsObjectValid(oTarget))
            {
               nth += 1;
               SetPlotFlag(oTarget, FALSE);
               oTarget = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter, nth);
            }
         }
      break;
      case eE_VAR_SPECIAL_UNSETPLOTFLAGNEAREST:
         // Closes nearest object with Tag
         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            SetPlotFlag(GetNearestObjectByTag(stEventSpecial.Tag, oEncounter), FALSE);
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            SetPlotFlag(GetNearestObjectByTag(stEventSpecial.Tag, oEncounter), TRUE);
         }
      break;
      case eE_VAR_SPECIAL_UNSETPLOTFLAGALL:
         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            object oTarget = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter);
            int nth = 1;
            while (GetIsObjectValid(oTarget))
            {
               nth += 1;
               SetPlotFlag(oTarget, FALSE);
               oTarget = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter, nth);
            }
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            object oTarget = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter);
            int nth = 1;
            while (GetIsObjectValid(oTarget))
            {
               nth += 1;
               SetPlotFlag(oTarget, TRUE);
               oTarget = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter, nth);
            }
         }
      break;
      case eE_VAR_SPECIAL_SETIMMORTALNEAREST:
         // Closes nearest object with Tag
         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            SetImmortal(GetNearestObjectByTag(stEventSpecial.Tag, oEncounter), TRUE);
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            SetImmortal(GetNearestObjectByTag(stEventSpecial.Tag, oEncounter), FALSE);
         }
      break;
      case eE_VAR_SPECIAL_SETIMMORTALALL:
         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            object oTarget = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter);
            int nth = 1;
            while (GetIsObjectValid(oTarget))
            {
               nth += 1;
               SetImmortal(oTarget, TRUE);
               oTarget = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter, nth);
            }
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            object oTarget = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter);
            int nth = 1;
            while (GetIsObjectValid(oTarget))
            {
               nth += 1;
               SetImmortal(oTarget, FALSE);
               oTarget = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter, nth);
            }
         }
      break;
      case eE_VAR_SPECIAL_SETMORTALNEAREST:
         // Closes nearest object with Tag
         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            SetImmortal(GetNearestObjectByTag(stEventSpecial.Tag, oEncounter), FALSE);
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            SetImmortal(GetNearestObjectByTag(stEventSpecial.Tag, oEncounter), TRUE);
         }
      break;
      case eE_VAR_SPECIAL_SETMORTALALL:
         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            object oTarget = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter);
            int nth = 1;
            while (GetIsObjectValid(oTarget))
            {
               nth += 1;
               SetImmortal(oTarget, FALSE);
               oTarget = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter, nth);
            }
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            object oTarget = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter);
            int nth = 1;
            while (GetIsObjectValid(oTarget))
            {
               nth += 1;
               SetImmortal(oTarget, TRUE);
               oTarget = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter, nth);
            }
         }
      break;
      case eE_VAR_SPECIAL_DESTROYNEAREST:
         // This will destroy the object with the specified Tag and if this Event
         // has AutoUndo enabled, will remember doing so by saving it to the destroyed Objects Array
         // beforehand (well, it's location, resref, tag and objecttype) and will then try to recreate it
         // in Undo-Mode
         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            EventType_Special_DestroyKillObject(GetNearestObjectByTag(stEventSpecial.Tag, oEncounter), oEncounter, nAutomaticUndo, 0);
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            EventType_Special_ReCreateObjects(oEncounter);
         }
      break;
      case eE_VAR_SPECIAL_DESTROYALL:
         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            object oToDestroy = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter);
            int nth = 1;
            while (GetIsObjectValid(oToDestroy))
            {
               nth += 1;
               EventType_Special_DestroyKillObject(oToDestroy, oEncounter, nAutomaticUndo, 0);
               oToDestroy = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter, nth);
            }
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            EventType_Special_ReCreateObjects(oEncounter);
         }
      break;
      case eE_VAR_SPECIAL_KILLNEAREST:
         // Works similar to DESTROYNEAREST, but the object is killed instead of destroyed.

         // If the Target is the player, well, kill him :) BUT, no Undo mode here obviously
         if (stEventSpecial.Tag == eE_SPAWNTAG_PC)
         {
            if (nEventMode == eE_EVENTMODE_CREATE)
            {
               object oPC = eE_GetEncounterPlayer(oEncounter, 1);
               EventType_Special_DestroyKillObject(oPC, oEncounter, nAutomaticUndo, 1);
            }
            return;
         }

         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            EventType_Special_DestroyKillObject(GetNearestObjectByTag(stEventSpecial.Tag, oEncounter), oEncounter, nAutomaticUndo, 1);
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            EventType_Special_ReCreateObjects(oEncounter);
         }
      break;
      case eE_VAR_SPECIAL_KILLALL:
         // If the Target is the player, well, kill him :) BUT, no Undo mode here obviously
         if (stEventSpecial.Tag == eE_SPAWNTAG_PC)
         {
            if (nEventMode == eE_EVENTMODE_CREATE)
            {
               int nPCCount = eE_GetEncounterPlayerCount(oEncounter);
               object oPC;
               int nth;
               for (nth = 1; nth <= nPCCount; nth++)
               {
                  oPC = eE_GetEncounterPlayer(oEncounter, nth);
                  EventType_Special_DestroyKillObject(oPC, oEncounter, nAutomaticUndo, 1);
               }
            }
            return;
         }

         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            object oToDestroy = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter);
            int nth = 1;
            while (GetIsObjectValid(oToDestroy))
            {
               nth += 1;
               EventType_Special_DestroyKillObject(oToDestroy, oEncounter, nAutomaticUndo, 1);
               oToDestroy = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter, nth);
            }
         }
         else if (nEventMode == eE_EVENTMODE_UNDO)
         {
            EventType_Special_ReCreateObjects(oEncounter);
         }
      break;
      case eE_VAR_SPECIAL_FORCERESTALL:
         // If the Target is the player, well, rest him
         if (stEventSpecial.Tag == eE_SPAWNTAG_PC)
         {
            if (nEventMode == eE_EVENTMODE_CREATE)
            {
               int nPCCount = eE_GetEncounterPlayerCount(oEncounter);
               object oPC;
               int nth;
               for (nth = 1; nth <= nPCCount; nth++)
               {
                  oPC = eE_GetEncounterPlayer(oEncounter, nth);
                  EventType_Special_ForceRest(oPC);
               }
            }
            return;
         }

         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            object oToRest = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter);
            int nth = 1;
            while (GetIsObjectValid(oToRest))
            {
               nth += 1;
               EventType_Special_ForceRest(oToRest);
               oToRest = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter, nth);
            }
         }
      break;
      case eE_VAR_SPECIAL_SOUNDOBJECTPLAY:
         if (nEventMode == eE_EVENTMODE_CREATE)
         {
            object oSound = GetNearestObjectByTag(stEventSpecial.Tag, oEncounter);
            if (GetIsObjectValid(oSound))
            {
               SoundObjectPlay(oSound);
            }
         }
      break;
   }
}

void EventType_Action(object oEncounter, object oEvent)
{
   struct eE_EVENT stEvent = eE_GetInfo_Event(oEvent);
   struct eE_EVENT_ACTION stEventAction = eE_GetInfo_EventAction(oEvent);
   object oOwner = stEventAction.OwnerObject;

   // Create an Object Array for the "Owners" of this Action Event
   eas_Array_Create(oEncounter, eE_VAR_EVENTOWNERS, EAS_ARRAY_TYPE_OBJECT);

   int nOwnerCount;
   if (stEventAction.Owner == eE_EVENTOWNER_SELF)
   {
      // Only one "Owner"
      eas_OArray_Entry_Add(oEncounter, eE_VAR_EVENTOWNERS, oOwner);
   }
   else
   {
      // Multiple "Owners"
      nOwnerCount = 0;
      oOwner = GetNearestObjectByTag(stEventAction.Owner, oEncounter, nOwnerCount + 1);
      while (
             (
              (GetIsObjectValid(oOwner))
             )
             &&
             (
              (nOwnerCount <= stEventAction.Quantity) ||
              (stEventAction.Quantity == -1)
             )
            )
      {
         eas_OArray_Entry_Add(oEncounter, eE_VAR_EVENTOWNERS, oOwner);
         nOwnerCount += 1;

         oOwner = GetNearestObjectByTag(stEventAction.Owner, oEncounter, nOwnerCount + 1);
      }
   }

   object oTarget;
   location lTargetLocation;
   int nArraySize = eas_Array_GetSize(oEncounter, eE_VAR_EVENTOWNERS);

   switch (stEventAction.EventID)
   {
      case eE_VAR_EVENT_ACTION_ATTACK:
         if ((stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOM) || (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXED))
         {
            oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod);
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               eE_SetLastTarget(oOwner, oTarget);
               AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionAttack(oTarget));
            }
         }
         else if (stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
         {
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, 1, oOwner);
               eE_SetLastTarget(oOwner, oTarget);
               AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionAttack(oTarget));
            }
         }
         else if (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST)
         {
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, nOwnerCount, oOwner);
               eE_SetLastTarget(oOwner, oTarget);
               AssignCommand(oOwner, ActionAttack(oTarget));
            }
         }
      break;
      case eE_VAR_EVENT_ACTION_CASTSPELL:
         // Casts a spell with warning
         if (stEventAction.SpellWarning != eE_NULL)
         {
            // Generate the effect
            effect eWarning = EffectVisualEffect(stEventAction.SpellWarning);
            if (stEventAction.ObjectOrLocation == eE_OBJECTLOCATION_OBJECT)
            {
               if ((stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOM) || (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXED))
               {
                  // Determine the target of the action
                  oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod);
                  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWarning, oTarget, stEventAction.SpellWarningDelay);
                  for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
                  {
                     oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                     eE_SetLastTarget(oOwner, oTarget);
                     AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), DelayCommand(stEventAction.SpellWarningDelay, ActionCastSpellAtObject(stEventAction.Spell, oTarget, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, FALSE)));
                  }
               }
               else if (stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
               {
                  for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
                  {
                     oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                     oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, 1, oOwner);
                     eE_SetLastTarget(oOwner, oTarget);
                     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWarning, oTarget, stEventAction.SpellWarningDelay);
                     AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), DelayCommand(stEventAction.SpellWarningDelay, ActionCastSpellAtObject(stEventAction.Spell, oTarget, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, FALSE)));
                  }
               }
               else if (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST)
               {
                  for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
                  {
                     oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                     oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, nOwnerCount, oOwner);
                     eE_SetLastTarget(oOwner, oTarget);
                     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWarning, oTarget, stEventAction.SpellWarningDelay);
                     AssignCommand(oOwner, DelayCommand(stEventAction.SpellWarningDelay, ActionCastSpellAtObject(stEventAction.Spell, oTarget, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, FALSE)));
                  }
               }
            }
            else if (stEventAction.ObjectOrLocation == eE_OBJECTLOCATION_LOCATION)
            {
               if ((stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOM) || (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXED))
               {
                  // Determine the target of the action
                  lTargetLocation = GetLocation(eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod));
                  ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eWarning, lTargetLocation, stEventAction.SpellWarningDelay);
                  for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
                  {
                     AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), DelayCommand(stEventAction.SpellWarningDelay, ActionCastSpellAtLocation(stEventAction.Spell, lTargetLocation, METAMAGIC_ANY, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, FALSE)));
                  }
               }
               else if (stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
               {
                  for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
                  {
                     oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                     lTargetLocation = GetLocation(eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, 1, oOwner));
                     ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eWarning, lTargetLocation, stEventAction.SpellWarningDelay);
                     AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), DelayCommand(stEventAction.SpellWarningDelay, ActionCastSpellAtLocation(stEventAction.Spell, lTargetLocation, METAMAGIC_ANY, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, FALSE)));
                  }
               }
               else if (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST)
               {
                  object oOwner;
                  for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
                  {
                     oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                     lTargetLocation = GetLocation(eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, nOwnerCount, oOwner));
                     ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eWarning, lTargetLocation, stEventAction.SpellWarningDelay);
                     AssignCommand(oOwner, DelayCommand(stEventAction.SpellWarningDelay, ActionCastSpellAtLocation(stEventAction.Spell, lTargetLocation, METAMAGIC_ANY, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, FALSE)));
                  }
               }
            }
         }
         else
         {
            // Casts a spell without warning
            if (stEventAction.ObjectOrLocation == eE_OBJECTLOCATION_OBJECT)
            {
               if ((stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOM) || (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXED))
               {
                  // Determine the target of the action
                  oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod);
                  for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
                  {
                     oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                     eE_SetLastTarget(oOwner, oTarget);
                     AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionCastSpellAtObject(stEventAction.Spell, oTarget, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, FALSE));
                  }
               }
               else if (stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
               {
                  for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
                  {
                     oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                     oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, 1, oOwner);
                     eE_SetLastTarget(oOwner, oTarget);
                     AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionCastSpellAtObject(stEventAction.Spell, oTarget, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, FALSE));
                  }
               }
               else if (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST)
               {
                  for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
                  {
                     oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                     oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, nOwnerCount, oOwner);
                     eE_SetLastTarget(oOwner, oTarget);
                     AssignCommand(oOwner, ActionCastSpellAtObject(stEventAction.Spell, oTarget, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, FALSE));
                  }
               }
            }
            else if (stEventAction.ObjectOrLocation == eE_OBJECTLOCATION_LOCATION)
            {
               if ((stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOM) || (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXED))
               {
                  // Determine the target of the action
                  lTargetLocation = GetLocation(eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod));
                  for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
                  {
                     AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionCastSpellAtLocation(stEventAction.Spell, lTargetLocation, METAMAGIC_ANY, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, FALSE));
                  }
               }
               else if (stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
               {
                  for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
                  {
                     oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                     lTargetLocation = GetLocation(eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, 1, oOwner));
                     AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionCastSpellAtLocation(stEventAction.Spell, lTargetLocation, METAMAGIC_ANY, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, FALSE));
                  }
               }
               else if (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST)
               {
                  for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
                  {
                     oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                     lTargetLocation = GetLocation(eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, nOwnerCount, oOwner));
                     AssignCommand(oOwner, ActionCastSpellAtLocation(stEventAction.Spell, lTargetLocation, METAMAGIC_ANY, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, FALSE));
                  }
               }
            }
         }
      break;
      case eE_VAR_EVENT_ACTION_CASTFAKESPELL:
         if (stEventAction.ObjectOrLocation == eE_OBJECTLOCATION_OBJECT)
         {
            if ((stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOM) || (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXED))
            {
               // Determine the target of the action
               oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod);
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  eE_SetLastTarget(oOwner, oTarget);
                  AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionCastFakeSpellAtObject(stEventAction.Spell, oTarget));
               }
            }
            else if (stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
            {
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, 1, oOwner);
                  eE_SetLastTarget(oOwner, oTarget);
                  AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionCastFakeSpellAtObject(stEventAction.Spell, oTarget));
               }
            }
            else if (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST)
            {
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, nOwnerCount, oOwner);
                  eE_SetLastTarget(oOwner, oTarget);
                  AssignCommand(oOwner, ActionCastFakeSpellAtObject(stEventAction.Spell, oTarget));
               }
            }
         }
         else if (stEventAction.ObjectOrLocation == eE_OBJECTLOCATION_LOCATION)
         {
            if ((stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOM) || (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXED))
            {
               // Determine the target of the action
               lTargetLocation = GetLocation(eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod));
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  eE_DebugMSG(oEncounter, "Casting Fake Spell: " + GetName(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1)) + " at location of " + GetName(eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod)));
                  AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionCastFakeSpellAtLocation(stEventAction.Spell, lTargetLocation));
               }
            }
            else if (stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
            {
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  lTargetLocation = GetLocation(eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, 1, oOwner));
                  AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionCastFakeSpellAtLocation(stEventAction.Spell, lTargetLocation));
               }
            }
            else if (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST)
            {
               object oOwner;
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  lTargetLocation = GetLocation(eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, nOwnerCount, oOwner));
                  AssignCommand(oOwner, ActionCastFakeSpellAtLocation(stEventAction.Spell, lTargetLocation));
               }
            }
         }
      break;
      case eE_VAR_EVENT_ACTION_OPENDOOR:
         if ((stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOM) || (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXED))
         {
            oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod);
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               eE_SetLastTarget(oOwner, oTarget);
               AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionOpenDoor(oTarget));
            }
         }
         else if (stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
         {
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, 1, oOwner);
               eE_SetLastTarget(oOwner, oTarget);
               AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionOpenDoor(oTarget));
            }
         }
         else if (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST)
         {
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, nOwnerCount, oOwner);
               eE_SetLastTarget(oOwner, oTarget);
               AssignCommand(oOwner, ActionOpenDoor(oTarget));
            }
         }
      break;
      case eE_VAR_EVENT_ACTION_CLOSEDOOR:
         if ((stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOM) || (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXED))
         {
            oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod);
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               eE_SetLastTarget(oOwner, oTarget);
               AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionCloseDoor(oTarget));
            }
         }
         else if (stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
         {
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, 1, oOwner);
               eE_SetLastTarget(oOwner, oTarget);
               AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionCloseDoor(oTarget));
            }
         }
         else if (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST)
         {
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, nOwnerCount, oOwner);
               eE_SetLastTarget(oOwner, oTarget);
               AssignCommand(oOwner, ActionCloseDoor(oTarget));
            }
         }
      break;
      case eE_VAR_EVENT_ACTION_JUMPTO:
         if (stEventAction.ObjectOrLocation == eE_OBJECTLOCATION_OBJECT)
         {
            if ((stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOM) || (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXED))
            {
               // Determine the target of the action
               oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod);
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  eE_SetLastTarget(oOwner, oTarget);
                  AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), JumpToObject(oTarget));
               }
            }
            else if (stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
            {
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, 1, oOwner);
                  eE_SetLastTarget(oOwner, oTarget);
                  AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), JumpToObject(oTarget));
               }
            }
            else if (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST)
            {
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, nOwnerCount, oOwner);
                  eE_SetLastTarget(oOwner, oTarget);
                  AssignCommand(oOwner, JumpToObject(oTarget));
               }
            }
         }
         else if (stEventAction.ObjectOrLocation == eE_OBJECTLOCATION_LOCATION)
         {
            if ((stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOM) || (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXED))
            {
               // Determine the target of the action
               lTargetLocation = GetLocation(eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod));
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), JumpToLocation(lTargetLocation));
               }
            }
            else if (stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
            {
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  lTargetLocation = GetLocation(eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, 1, oOwner));
                  AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), JumpToLocation(lTargetLocation));
               }
            }
            else if (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST)
            {
               object oOwner;
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  lTargetLocation = GetLocation(eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, nOwnerCount, oOwner));
                  AssignCommand(oOwner, JumpToLocation(lTargetLocation));
               }
            }
         }
      break;
      case eE_VAR_EVENT_ACTION_WALKTO:
         if (stEventAction.ObjectOrLocation == eE_OBJECTLOCATION_OBJECT)
         {
            if ((stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOM) || (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXED))
            {
               // Determine the target of the action
               oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod);
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  eE_SetLastTarget(oOwner, oTarget);
                  AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionMoveToObject(oTarget));
               }
            }
            else if (stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
            {
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, 1, oOwner);
                  eE_SetLastTarget(oOwner, oTarget);
                  AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionMoveToObject(oTarget));
               }
            }
            else if (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST)
            {
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, nOwnerCount, oOwner);
                  eE_SetLastTarget(oOwner, oTarget);
                  AssignCommand(oOwner, ActionMoveToObject(oTarget));
               }
            }
         }
         else if (stEventAction.ObjectOrLocation == eE_OBJECTLOCATION_LOCATION)
         {
            if ((stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOM) || (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXED))
            {
               // Determine the target of the action
               lTargetLocation = GetLocation(eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod));
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionMoveToLocation(lTargetLocation));
               }
            }
            else if (stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
            {
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  lTargetLocation = GetLocation(eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, 1, oOwner));
                  AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionMoveToLocation(lTargetLocation));
               }
            }
            else if (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST)
            {
               object oOwner;
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  lTargetLocation = GetLocation(eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, nOwnerCount, oOwner));
                  AssignCommand(oOwner, ActionMoveToLocation(lTargetLocation));
               }
            }
         }
      break;
      case eE_VAR_EVENT_ACTION_RUNTO:
         if (stEventAction.ObjectOrLocation == eE_OBJECTLOCATION_OBJECT)
         {
            if ((stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOM) || (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXED))
            {
               // Determine the target of the action
               oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod);
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  eE_SetLastTarget(oOwner, oTarget);
                  AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionMoveToObject(oTarget, TRUE));
               }
            }
            else if (stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
            {
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, 1, oOwner);
                  eE_SetLastTarget(oOwner, oTarget);
                  AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionMoveToObject(oTarget, TRUE));
               }
            }
            else if (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST)
            {
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, nOwnerCount, oOwner);
                  eE_SetLastTarget(oOwner, oTarget);
                  AssignCommand(oOwner, ActionMoveToObject(oTarget, TRUE));
               }
            }
         }
         else if (stEventAction.ObjectOrLocation == eE_OBJECTLOCATION_LOCATION)
         {
            if ((stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOM) || (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXED))
            {
               // Determine the target of the action
               lTargetLocation = GetLocation(eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod));
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionMoveToLocation(lTargetLocation, TRUE));
               }
            }
            else if (stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
            {
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  lTargetLocation = GetLocation(eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, 1, oOwner));
                  AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionMoveToLocation(lTargetLocation, TRUE));
               }
            }
            else if (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST)
            {
               object oOwner;
               for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
               {
                  oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
                  lTargetLocation = GetLocation(eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, nOwnerCount, oOwner));
                  AssignCommand(oOwner, ActionMoveToLocation(lTargetLocation, TRUE));
               }
            }
         }
      break;
      case eE_VAR_EVENT_ACTION_INTERACT:
         if ((stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOM) || (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXED))
         {
            oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod);
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               eE_SetLastTarget(oOwner, oTarget);
               AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionInteractObject(oTarget));
            }
         }
         else if (stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
         {
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, 1, oOwner);
               eE_SetLastTarget(oOwner, oTarget);
               AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionInteractObject(oTarget));
            }
         }
         else if (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST)
         {
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, nOwnerCount, oOwner);
               eE_SetLastTarget(oOwner, oTarget);
               AssignCommand(oOwner, ActionInteractObject(oTarget));
            }
         }
      break;
      case eE_VAR_EVENT_ACTION_LOCK:
         if ((stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOM) || (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXED))
         {
            oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod);
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               eE_SetLastTarget(oOwner, oTarget);
               AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionLockObject(oTarget));
            }
         }
         else if (stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
         {
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, 1, oOwner);
               eE_SetLastTarget(oOwner, oTarget);
               AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionLockObject(oTarget));
            }
         }
         else if (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST)
         {
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, nOwnerCount, oOwner);
               eE_SetLastTarget(oOwner, oTarget);
               AssignCommand(oOwner, ActionLockObject(oTarget));
            }
         }
      break;
      case eE_VAR_EVENT_ACTION_UNLOCK:
         if ((stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOM) || (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXED))
         {
            oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod);
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               eE_SetLastTarget(oOwner, oTarget);
               AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionUnlockObject(oTarget));
            }
         }
         else if (stEventAction.TargetMethod == eE_TARGETMETHOD_RANDOMINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_RANDOM)
         {
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, 1, oOwner);
               eE_SetLastTarget(oOwner, oTarget);
               AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionUnlockObject(oTarget));
            }
         }
         else if (stEventAction.TargetMethod == eE_TARGETMETHOD_FIXEDINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_NEARESTINDIVIDUAL || stEventAction.TargetMethod == eE_TARGETMETHOD_LASTTARGET_NEAREST)
         {
            for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
            {
               oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
               oTarget = eE_GetActionTarget(oEncounter, stEventAction.Tag, stEventAction.TargetMethod, nOwnerCount, oOwner);
               eE_SetLastTarget(oOwner, oTarget);
               AssignCommand(oOwner, ActionUnlockObject(oTarget));
            }
         }
      break;
      case eE_VAR_EVENT_ACTION_FLOATINGTEXT:
         for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
         {
            oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
            FloatingTextStringOnCreature(stEventAction.Tag, oOwner);
         }
      break;
      case eE_VAR_EVENT_ACTION_SPEAKSTRING:
         for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
         {
            AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), SpeakString(stEventAction.Tag));
         }
      break;
      case eE_VAR_EVENT_ACTION_PLAYANIMATION:
         for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
         {
            AssignCommand(eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1), ActionPlayAnimation(StringToInt(stEventAction.Tag), 1.0f, stEvent.Interval));
         }
      break;
      case eE_VAR_EVENT_ACTION_SETAPPEARANCE:
         for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
         {
            // Determine a random target for each Owner
            object oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
            AssignCommand(oOwner, SetCreatureAppearanceType(oOwner, StringToInt(stEventAction.Tag)));
         }
      break;
      case eE_VAR_EVENT_ACTION_REMOVEEFFECT:
         for (nOwnerCount = 1; nOwnerCount <= nArraySize; nOwnerCount++)
         {
            // Determine a random target for each Owner
            object oOwner = eas_OArray_Entry_Get(oEncounter, eE_VAR_EVENTOWNERS, nOwnerCount - 1);
            EventEffect_RemoveEffect(oOwner, stEventAction.Tag);
         }
      break;
   }
   // Delete the Object Array
   eas_Array_Delete(oEncounter, eE_VAR_EVENTOWNERS);
}

void main()
{
   // Retrieve important variables
   object oEvent = OBJECT_SELF;
   object oEncounter = eE_GetEventEncounter(oEvent);
   struct eE_EVENT stEvent = eE_GetInfo_Event(oEvent);
   object oOwner = stEvent.OwnerObject;

   eE_DebugMSG(oEncounter, "Executing Event [" + GetName(oEvent) + "] - Type [" + IntToString(stEvent.Type) + "] - Mode [" + IntToString(stEvent.Mode) + "]");

   // Events in EVENTMODE_DESTROY ignore some checks
   if (stEvent.Mode == eE_EVENTMODE_CREATE)
   {
      // If this event is marked inactive, return immediately
      if (eE_GetEventStatus(oEvent) == eE_EVENTSTATUS_INACTIVE)
      {
         eE_DebugMSG(oEncounter, "Execution of [" + GetName(oEvent) + "] aborted - Event Inactive");
         return;
      }

      // Check all Conditions before executing this event
      // This event should only be executed if the associated encounter is either in
      // Initializing, Initialized or InProgress Phase
      int nCurrentEncStatus = eE_GetEncounterStatus(oEncounter);
      if ((nCurrentEncStatus != eE_ENCOUNTER_STATUS_INITIALIZING) && (nCurrentEncStatus != eE_ENCOUNTER_STATUS_INITIALIZED) && (nCurrentEncStatus != eE_ENCOUNTER_STATUS_INPROGRESS))
      {
         eE_DebugMSG(oEncounter, "Execution of [" + GetName(oEvent) + "] aborted - wrong Encounter Phase");
         return;
      }

      // If the specified owner of this event is not a valid object in the current area, do not trigger this event
      if (!GetIsObjectValid(oOwner))
      {
         // Try to find the owner again for delayed events
         object oContainer = GetItemPossessor(oEvent);
         oOwner = GetNearestObjectByTag(stEvent.Owner, oEvent);
         if (oContainer != OBJECT_INVALID)
         {
            if (GetTag(oContainer) == stEvent.Owner)
               oOwner = oContainer;
            else
               oOwner = GetNearestObjectByTag(stEvent.Owner, oEncounter);
         }
      }

      // If still not valid...
      if (!GetIsObjectValid(oOwner))
      {
         eE_DebugMSG(oEncounter, "Execution of [" + GetName(oEvent) + "] aborted - Owner (" + stEvent.Owner + ") not found");
         return;
      }
      // If the owner is a creature, make sure at least one is still alive
      else if (GetObjectType(oOwner) == OBJECT_TYPE_CREATURE)
      {
         int nAlive = FALSE;
         if (stEvent.Owner != eE_EVENTOWNER_SELF)
         {
            int iCount = 1;
            oOwner = GetNearestObjectByTag(stEvent.Owner, oEncounter, iCount);
            while (GetIsObjectValid(oOwner))
            {
               if (GetObjectType(oOwner) == OBJECT_TYPE_CREATURE &&
                   !GetIsDead(oOwner))
                  nAlive = TRUE;

               iCount++;
               oOwner = GetNearestObjectByTag(stEvent.Owner, oEncounter, iCount);
            }
         }
         else
         {
            if (!GetIsDead(oOwner))
               nAlive = TRUE;
         }
         if (!nAlive)
         {
            eE_DebugMSG(oEncounter, "Execution of [" + GetName(oEvent) + "] aborted - Owner dead");
            return;
         }
      }

      // In case of the interval being 0.0f, this will be a one-time event.
      // At any other interval, trigger the timer to start the script again
      if (stEvent.Interval > 0.0f)
      {
         // Check the Repeat Counter against the MaxRepeats Value
         int iCurrentRepeat = GetLocalInt(oEvent, eE_VAR_ENTITY_CURRENTREPEAT);

         // We have to increase this, as this method WILL be executed no matter what
         iCurrentRepeat++;

         // Now, if MaxRepeats are either 0 (unlimited) or we have not reached maximum Repeats, initiate the repeater
         // and set the correct value for the Current Repeat counter
         if ((iCurrentRepeat < stEvent.MaxRepeat) || (stEvent.MaxRepeat == 0))
         {
            SetLocalInt(oEvent, eE_VAR_ENTITY_CURRENTREPEAT, iCurrentRepeat);
            AssignCommand(GetModule(), DelayCommand(stEvent.Interval, ExecuteScript(eE_SCRIPT_EVENT_EXECUTE, oEvent)));
         }
      }
   }

   // Depending on the type of Event, we have to do different things
   // For some events, we need a pre-declared object and counter
   switch (stEvent.Type)
   {
      case eE_EVENTTYPE_CREATURE: // This event handles Creatures
         EventType_Entity(oEncounter, oEvent, OBJECT_TYPE_CREATURE, stEvent.Mode);
         break;
      case eE_EVENTTYPE_PLACEABLE: // Placeables, like portals, are created by this eventtype;
         EventType_Entity(oEncounter, oEvent, OBJECT_TYPE_PLACEABLE, stEvent.Mode);
         break;
      case eE_EVENTTYPE_SPECIAL: // Special Events work using the field "Event ID", doing something with "Tag"
         EventType_Special(oEncounter, oEvent, stEvent.Mode, stEvent.AutoUndo);
         break;
      case eE_EVENTTYPE_ACTION: // Actions are Commands assigned and added to an Entity's action queue
         if (stEvent.Mode == eE_EVENTMODE_CREATE) // Actions cannot be undone
            EventType_Action(oEncounter, oEvent);
         break;
      case eE_EVENTTYPE_EFFECT:
         EventType_Effect(oEncounter, oEvent, stEvent.Mode, stEvent.AutoUndo);
         break;
      case eE_EVENTTYPE_DAMAGE:
         if (stEvent.Mode == eE_EVENTMODE_CREATE) // Damage events cannot be undone
            EventType_Damage(oEncounter, oEvent);
         break;
      case eE_EVENTTYPE_EXECUTESCRIPT:
         // Here the encounter designer can execute scripts made by himself to
         // further enhance the encounter. This will only be usable for scripts
         // that aren't assigned to creatures or placeables in their OnSpawn
         // events. The event owner will be the script executor and OBJECT_SELF in
         // said script. In Undo-Mode, eE tries to Execute the same Script with
         // _UNDO suffixed to the Scriptname.
         if (stEvent.Mode == eE_EVENTMODE_CREATE)
         {
            ExecuteScript(GetLocalString(oEvent, eE_VAR_EVENT_SCRIPTNAME), oOwner);
         }
         else if (stEvent.Mode == eE_EVENTMODE_UNDO)
         {
            ExecuteScript(GetLocalString(oEvent, eE_VAR_EVENT_SCRIPTNAME) + "_UNDO", oOwner);
         }
         break;
   }
}
