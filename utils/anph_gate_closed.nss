void main()
{
    // Automatically lock the door after it was close if it's not bashed in
    if (GetLockKeyTag(OBJECT_SELF) != "door_Bashed_NoKey")
        SetLocked (OBJECT_SELF, TRUE);
}
