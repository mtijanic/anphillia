
int dev_IsTeamMember(object oPC);

int dev_IsTeamMember(object oPC)
{
    if (GetIsDM(oPC) || GetIsDMPossessed(oPC))
        return TRUE;

    string sCDKey = GetPCPublicCDKey(oPC);
    if (sCDKey == "XXXXXXXX" || // Zerak
        sCDKey == "XXXXXXXX" || // Sherincall
        sCDKey == "XXXXXXXX" || // Samurai
        sCDKey == "XXXXXXXX" || // PastorPug
        sCDKey == "XXXXXXXX" || // Styke
        sCDKey == "XXXXXXXX" || // eyesolated
        // Trusted players:
        sCDKey == "XXXXXXXX" || // Goodpart
        sCDKey == "XXXXXXXX"    // Lux
    )
        return TRUE;

    return FALSE;
}
