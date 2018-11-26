#include "anph_inc"
#include "nwnx_time"

void main()
{
    object oUser = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    

    if (oTarget == oUser)
    {
        SendMessageToPC(oUser, "Cloning tool disarmed. Use it again to pick an object to clone (select ground for areas)");
        DeleteLocalObject(oUser, "DMTOOL_CLONE_OBJECT");
        return;
    }


    object oToClone = GetLocalObject(oUser, "DMTOOL_CLONE_OBJECT");
    if (!GetIsObjectValid(oToClone))
    {
        if (oTarget == OBJECT_INVALID)
        {
            oTarget = GetAreaFromLocation(GetSpellTargetLocation());
        }
        else if (GetObjectType(oTarget) != OBJECT_TYPE_CREATURE && GetObjectType(oTarget) != OBJECT_TYPE_ITEM)
        {
            SendMessageToPC(oUser, "Only creatures, items and ground (areas) can be cloned with this tool.");
            return;
        }

        SetLocalObject(oUser, "DMTOOL_CLONE_OBJECT", oTarget);
        SendMessageToPC(oUser, "Cloning " + GetName(oTarget) + ". Use the tool again and select the location.");
        SendMessageToPC(oUser, "If you're cloning an area, select any location.");
        return;
    }
    else
    {
        if (GetObjectType(oToClone) == OBJECT_TYPE_CREATURE)
        {
            CopyObject(oToClone, GetSpellTargetLocation());
        }
        if (GetObjectType(oToClone) == OBJECT_TYPE_ITEM)
        {
            if (GetIsObjectValid(oTarget))
            {
                CopyItem(oToClone, oTarget, TRUE);
                SendMessageToPC(oUser, GetName(oToClone) + " cloned into " + GetName(oTarget) + "'s inventory.");
            }
            else
                CopyObject(oToClone, GetSpellTargetLocation());
        }
        else if (GetIsAreaNatural(oToClone) != AREA_INVALID)
        {
            string sName = GetName(oToClone);
            if (sName == "Axfell" || sName == "Fort Cleaven" || sName == "Ranzington")
            {
                SendMessageToPC(oUser, "Bad! Don't use this to clone fort areas, other systems might get messed");
                SendMessageToPC(oUser, "(if you really know what you're doing, you know how to bypass this)");
                return;
            }
            CreateArea(GetResRef(oToClone), "", " Clone - " + GetName(oToClone));
            SendMessageToPC(oUser, "Area cloned as ' Clone - "+ GetName(oToClone)+"', find it in the Chooser");
        }

        SendMessageToPC(oUser, "Note that your tool is still armed, and you can create more clones. Use on self to disarm.");
    }
}

