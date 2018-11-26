/************************************************************************
 * script name  : eas_inc
 * created by   : eyesolated
 * date         : 2011/6/16
 *
 * description  : The central include file for eyesolated Arrays and
 *                StringLists
 *
 * changes      : 2010/6/16 - eyesolated - Initial creation
 ************************************************************************/

const int EAS_ARRAY_EXIST = 1;
const int EAS_ARRAY_NOTEXIST = 0;

const string EAS_ARRAY_NAME = "_AName";
const string EAS_ARRAY_SIZE = "_Asize";
const string EAS_ARRAY_TYPE = "_AType";
const int EAS_ARRAY_TYPE_STRING = 1;
const int EAS_ARRAY_TYPE_INTEGER = 2;
const int EAS_ARRAY_TYPE_FLOAT = 3;
const int EAS_ARRAY_TYPE_LOCATION = 4;
const int EAS_ARRAY_TYPE_OBJECT = 5;

void eas_Array_SetSize(object oStore, string sArrayName, int nArraySize);
int eas_Array_GetSize(object oStore, string sArrayName);
void eas_Array_SetType(object oStore, string sArrayName, int nArrayType);
int eas_Array_GetType(object oStore, string sArrayName);

// Checks if the Array exists
// oStore      : The store on which the Array is saved
// sArrayName  : The Array to check
int eas_Array_Exists(object oStore, string sArrayName);

// Deletes an Array
// oStore      : The store on which the Array is saved
// sArrayName  : The Array to delete
// bRealDelete : Really delete the stored objects instead of just setting ArraySize to 0
void eas_Array_Delete(object oStore, string sArrayName, int bRealDelete = FALSE);

// Creates an Array sArrayName on oStore
// nArrayType is unused for speed reasons, you can save any type on any array, just make sure
// you know what you do :)
int eas_Array_Create(object oStore, string sArrayName, int nArrayType = EAS_ARRAY_TYPE_STRING);

// String Arrays

// Adds an Entry to an Array
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// sEntry      : The Entry to add to the Array
//
// Returns     : The index of the added Entry
int eas_SArray_Entry_Add(object oStore, string sArrayName, string sEntry);

// Changes the Value of an existing Entry in an Array
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// nIndex      : The Index of the Entry to change
// sEntry      : The new value to save
void eas_SArray_Entry_Set(object oStore, string sArrayName, int nIndex, string sEntry);

// Returns the value of an Entry in an Array
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// nIndex      : The Index of the Entry to retrieve
string eas_SArray_Entry_Get(object oStore, string sArrayName, int nIndex);

// Returns the Index of sEntry in Array sArrayName on object oStore
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// sEntry      : The Value to get the Index of
// Returns -1 if the entry is not found
int eas_SArray_Entry_IndexOf(object oStore, string sArrayName, string sEntry);

// Swaps the Index/Position of two entries in an Array
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// nIndex1     : The first Index
// nIndex2     : The second Index
void eas_SArray_Entry_Swap(object oStore, string sArrayName, int nIndex1, int nIndex2);

// Inserts an Entry at a specified Index in an Array
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// nIndex      : The Index at which to insert the Entry
// sEntry      : The Value to insert
void eas_SArray_Entry_Insert(object oStore, string sArrayName, int nIndex, string sEntry);

// Deletes an Entry from an Array. All following Entries are reordered
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// nIndex      : The Index of the Entry to delete
void eas_SArray_Entry_Delete(object oStore, string sArrayName, int nIndex);

// Delete an Entry from an Array by Value. The first Entry matching will be deleted
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// sValue      : The value to delete
// Returns the Index of the deleted Entry, -1 on Error
int eas_SArray_Entry_DeleteByValue(object oStore, string sArrayName, string sValue);

// Integer Arrays

// Adds an Entry to an Array
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// sEntry      : The Entry to add to the Array
//
// Returns     : The index of the added Entry
int eas_IArray_Entry_Add(object oStore, string sArrayName, int iValue);

// Changes the Value of an existing Entry in an Array
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// nIndex      : The Index of the Entry to change
// sEntry      : The new value to save
void eas_IArray_Entry_Set(object oStore, string sArrayName, int nIndex, int iValue);

// Returns the value of an Entry in an Array
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// nIndex      : The Index of the Entry to retrieve
int eas_IArray_Entry_Get(object oStore, string sArrayName, int nIndex);

// Returns the Index of sEntry in Array sArrayName on object oStore
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// sEntry      : The Value to get the Index of
// Returns -1 if the entry is not found
int eas_IArray_Entry_IndexOf(object oStore, string sArrayName, int iValue);

// Swaps the Index/Position of two entries in an Array
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// nIndex1     : The first Index
// nIndex2     : The second Index
void eas_IArray_Entry_Swap(object oStore, string sArrayName, int nIndex1, int nIndex2);

// Inserts an Entry at a specified Index in an Array
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// nIndex      : The Index at which to insert the Entry
// sEntry      : The Value to insert
void eas_IArray_Entry_Insert(object oStore, string sArrayName, int nIndex, int iValue);

// Deletes an Entry from an Array. All following Entries are reordered
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// nIndex      : The Index of the Entry to delete
void eas_IArray_Entry_Delete(object oStore, string sArrayName, int nIndex);

// Delete an Entry from an Array by Value. The first Entry matching will be deleted
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// sValue      : The value to delete
// Returns the Index of the deleted Entry, -1 on Error
int eas_IArray_Entry_DeleteByValue(object oStore, string sArrayName, int iValue);

// Object Arrays

// Adds an Entry to an Array
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// sEntry      : The Entry to add to the Array
//
// Returns     : The index of the added Entry
int eas_OArray_Entry_Add(object oStore, string sArrayName, object oEntry);

// Changes the Value of an existing Entry in an Array
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// nIndex      : The Index of the Entry to change
// sEntry      : The new value to save
void eas_OArray_Entry_Set(object oStore, string sArrayName, int nIndex, object sEntry);

// Returns the value of an Entry in an Array
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// nIndex      : The Index of the Entry to retrieve
object eas_OArray_Entry_Get(object oStore, string sArrayName, int nIndex);

// Returns the Index of sEntry in Array sArrayName on object oStore
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// sEntry      : The Value to get the Index of
// Returns -1 if the entry is not found
int eas_OArray_Entry_IndexOf(object oStore, string sArrayName, object oEntry);

// Swaps the Index/Position of two entries in an Array
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// nIndex1     : The first Index
// nIndex2     : The second Index
void eas_OArray_Entry_Swap(object oStore, string sArrayName, int nIndex1, int nIndex2);

// Inserts an Entry at a specified Index in an Array
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// nIndex      : The Index at which to insert the Entry
// sEntry      : The Value to insert
void eas_OArray_Entry_Insert(object oStore, string sArrayName, int nIndex, object oEntry);

// Deletes an Entry from an Array. All following Entries are reordered
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// nIndex      : The Index of the Entry to delete
void eas_OArray_Entry_Delete(object oStore, string sArrayName, int nIndex);

// Delete an Entry from an Array by Value. The first Entry matching will be deleted
// oStore      : The object the Array is stored on
// sArrayName  : The name of the Array
// sValue      : The value to delete
// Returns the Index of the deleted Entry, -1 on Error
int eas_OArray_Entry_DeleteByValue(object oStore, string sArrayName, object oValue);

// Implementation

// STRING ARRAY
int eas_SArray_Entry_Add(object oStore, string sArrayName, string sEntry)
{
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   SetLocalString(oStore, sArrayName + IntToString(nArraySize), sEntry);
   eas_Array_SetSize(oStore, sArrayName, nArraySize + 1);
   return (nArraySize);
}

void eas_SArray_Entry_Set(object oStore, string sArrayName, int nIndex, string sEntry)
{
   if (eas_Array_GetSize(oStore, sArrayName) > nIndex)
   {
      SetLocalString(oStore, sArrayName + IntToString(nIndex), sEntry);
   }
}

string eas_SArray_Entry_Get(object oStore, string sArrayName, int nIndex)
{
   return (GetLocalString(oStore, sArrayName + IntToString(nIndex)));
}

int eas_SArray_Entry_IndexOf(object oStore, string sArrayName, string sEntry)
{
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   int nIndex;
   for (nIndex = 0; nIndex < nArraySize; nIndex++)
   {
      if (eas_SArray_Entry_Get(oStore, sArrayName, nIndex) == sEntry)
      {
         return (nIndex);
      }
   }
   return (-1);
}

void eas_SArray_Entry_Swap(object oStore, string sArrayName, int nIndex1, int nIndex2)
{
   string sEntry1 = eas_SArray_Entry_Get(oStore, sArrayName, nIndex1);
   string sEntry2 = eas_SArray_Entry_Get(oStore, sArrayName, nIndex2);
   eas_SArray_Entry_Set(oStore, sArrayName, nIndex1, sEntry2);
   eas_SArray_Entry_Set(oStore, sArrayName, nIndex2, sEntry1);
}

void eas_SArray_Entry_Insert(object oStore, string sArrayName, int nIndex, string sEntry)
{
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   // Only able to insert something if it is within the array
   if (nArraySize > nIndex)
   {
      // Increase the Array Size
      eas_Array_SetSize(oStore, sArrayName, nArraySize + 1);

      // Add 1 to the index of each Entry before the Insert Position
      int nOldIndex;
      for (nOldIndex = nArraySize - 1; nOldIndex >= nIndex; nOldIndex--)
      {
         eas_SArray_Entry_Set(oStore, sArrayName, nOldIndex + 1, eas_SArray_Entry_Get(oStore, sArrayName, nOldIndex));
      }

      // Finally, set the inserted value
      eas_SArray_Entry_Set(oStore, sArrayName, nIndex, sEntry);
   }
}

void eas_SArray_Entry_Delete(object oStore, string sArrayName, int nIndex)
{
   // Only able to delete something if it is within the array
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   if (nArraySize > nIndex)
   {
      // Get the next entry and pull it to the deleted one until the end
      int nNewIndex;
      for (nNewIndex = nIndex; nNewIndex < nArraySize - 1; nNewIndex++)
      {
         eas_SArray_Entry_Set(oStore, sArrayName, nNewIndex, eas_SArray_Entry_Get(oStore, sArrayName, nNewIndex +1));
      }

      // Finally, delete the last entry and decrease the Array's Size
      DeleteLocalString(oStore, sArrayName + IntToString(nArraySize - 1));
      eas_Array_SetSize(oStore, sArrayName, nArraySize - 1);
   }
}

int eas_SArray_Entry_DeleteByValue(object oStore, string sArrayName, string sValue)
{
   // Deletes an entry by Object
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   int nIndex;
   string sCompare;
   for (nIndex = 0; nIndex < nArraySize; nIndex++)
   {
      sCompare = eas_SArray_Entry_Get(oStore, sArrayName, nIndex);
      if (sCompare == sValue)
      {
         eas_SArray_Entry_Delete(oStore, sArrayName, nIndex);
         return (nIndex);
      }
   }
   return (-1);
}

// INTEGER ARRAY
int eas_IArray_Entry_Add(object oStore, string sArrayName, int iEntry)
{
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   SetLocalInt(oStore, sArrayName + IntToString(nArraySize), iEntry);
   eas_Array_SetSize(oStore, sArrayName, nArraySize + 1);
   return (nArraySize);
}

void eas_IArray_Entry_Set(object oStore, string sArrayName, int nIndex, int iEntry)
{
   if (eas_Array_GetSize(oStore, sArrayName) > nIndex)
   {
      SetLocalInt(oStore, sArrayName + IntToString(nIndex), iEntry);
   }
}

int eas_IArray_Entry_Get(object oStore, string sArrayName, int nIndex)
{
   return (GetLocalInt(oStore, sArrayName + IntToString(nIndex)));
}

int eas_IArray_Entry_IndexOf(object oStore, string sArrayName, int iEntry)
{
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   int nIndex;
   for (nIndex = 0; nIndex < nArraySize; nIndex++)
   {
      if (eas_IArray_Entry_Get(oStore, sArrayName, nIndex) == iEntry)
      {
         return (nIndex);
      }
   }
   return (-1);
}

void eas_IArray_Entry_Swap(object oStore, string sArrayName, int nIndex1, int nIndex2)
{
   int iEntry1 = eas_IArray_Entry_Get(oStore, sArrayName, nIndex1);
   int iEntry2 = eas_IArray_Entry_Get(oStore, sArrayName, nIndex2);
   eas_IArray_Entry_Set(oStore, sArrayName, nIndex1, iEntry2);
   eas_IArray_Entry_Set(oStore, sArrayName, nIndex2, iEntry1);
}

void eas_IArray_Entry_Insert(object oStore, string sArrayName, int nIndex, int iEntry)
{
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   // Only able to insert something if it is within the array
   if (nArraySize > nIndex)
   {
      // Increase the Array Size
      eas_Array_SetSize(oStore, sArrayName, nArraySize + 1);

      // Add 1 to the index of each Entry before the Insert Position
      int nOldIndex;
      for (nOldIndex = nArraySize - 1; nOldIndex >= nIndex; nOldIndex--)
      {
         eas_IArray_Entry_Set(oStore, sArrayName, nOldIndex + 1, eas_IArray_Entry_Get(oStore, sArrayName, nOldIndex));
      }

      // Finally, set the inserted value
      eas_IArray_Entry_Set(oStore, sArrayName, nIndex, iEntry);
   }
}

void eas_IArray_Entry_Delete(object oStore, string sArrayName, int nIndex)
{
   // Only able to delete something if it is within the array
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   if (nArraySize > nIndex)
   {
      // Get the next entry and pull it to the deleted one until the end
      int nNewIndex;
      for (nNewIndex = nIndex; nNewIndex < nArraySize - 1; nNewIndex++)
      {
         eas_IArray_Entry_Set(oStore, sArrayName, nNewIndex, eas_IArray_Entry_Get(oStore, sArrayName, nNewIndex +1));
      }

      // Finally, delete the last entry and decrease the Array's Size
      DeleteLocalInt(oStore, sArrayName + IntToString(nArraySize - 1));
      eas_Array_SetSize(oStore, sArrayName, nArraySize - 1);
   }
}

int eas_IArray_Entry_DeleteByValue(object oStore, string sArrayName, int nValue)
{
   // Deletes an entry by Object
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   int nIndex;
   int nCompare;
   for (nIndex = 0; nIndex < nArraySize; nIndex++)
   {
      nCompare = eas_IArray_Entry_Get(oStore, sArrayName, nIndex);
      if (nCompare == nValue)
      {
         eas_IArray_Entry_Delete(oStore, sArrayName, nIndex);
         return (nIndex);
      }
   }
   return (-1);
}

// FLOAT ARRAY
int eas_FArray_Entry_Add(object oStore, string sArrayName, float fEntry)
{
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   SetLocalFloat(oStore, sArrayName + IntToString(nArraySize), fEntry);
   eas_Array_SetSize(oStore, sArrayName, nArraySize + 1);
   return (nArraySize);
}

void eas_FArray_Entry_Set(object oStore, string sArrayName, int nIndex, float fEntry)
{
   if (eas_Array_GetSize(oStore, sArrayName) > nIndex)
   {
      SetLocalFloat(oStore, sArrayName + IntToString(nIndex), fEntry);
   }
}

float eas_FArray_Entry_Get(object oStore, string sArrayName, int nIndex)
{
   return (GetLocalFloat(oStore, sArrayName + IntToString(nIndex)));
}

int eas_FArray_Entry_IndexOf(object oStore, string sArrayName, float fEntry)
{
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   int nIndex;
   for (nIndex = 0; nIndex < nArraySize; nIndex++)
   {
      if (eas_FArray_Entry_Get(oStore, sArrayName, nIndex) == fEntry)
      {
         return (nIndex);
      }
   }
   return (-1);
}

void eas_FArray_Entry_Swap(object oStore, string sArrayName, int nIndex1, int nIndex2)
{
   float fEntry1 = eas_FArray_Entry_Get(oStore, sArrayName, nIndex1);
   float fEntry2 = eas_FArray_Entry_Get(oStore, sArrayName, nIndex2);
   eas_FArray_Entry_Set(oStore, sArrayName, nIndex1, fEntry2);
   eas_FArray_Entry_Set(oStore, sArrayName, nIndex2, fEntry1);
}

void eas_FArray_Entry_Insert(object oStore, string sArrayName, int nIndex, float fEntry)
{
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   // Only able to insert something if it is within the array
   if (nArraySize > nIndex)
   {
      // Increase the Array Size
      eas_Array_SetSize(oStore, sArrayName, nArraySize + 1);

      // Add 1 to the index of each Entry before the Insert Position
      int nOldIndex;
      for (nOldIndex = nArraySize - 1; nOldIndex >= nIndex; nOldIndex--)
      {
         eas_FArray_Entry_Set(oStore, sArrayName, nOldIndex + 1, eas_FArray_Entry_Get(oStore, sArrayName, nOldIndex));
      }

      // Finally, set the inserted value
      eas_FArray_Entry_Set(oStore, sArrayName, nIndex, fEntry);
   }
}

void eas_FArray_Entry_Delete(object oStore, string sArrayName, int nIndex)
{
   // Only able to delete something if it is within the array
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   if (nArraySize > nIndex)
   {
      // Get the next entry and pull it to the deleted one until the end
      int nNewIndex;
      for (nNewIndex = nIndex; nNewIndex < nArraySize - 1; nNewIndex++)
      {
         eas_FArray_Entry_Set(oStore, sArrayName, nNewIndex, eas_FArray_Entry_Get(oStore, sArrayName, nNewIndex +1));
      }

      // Finally, delete the last entry and decrease the Array's Size
      DeleteLocalFloat(oStore, sArrayName + IntToString(nArraySize - 1));
      eas_Array_SetSize(oStore, sArrayName, nArraySize - 1);
   }
}

int eas_FArray_Entry_DeleteByValue(object oStore, string sArrayName, float fValue)
{
   // Deletes an entry by Object
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   int nIndex;
   float fCompare;
   for (nIndex = 0; nIndex < nArraySize; nIndex++)
   {
      fCompare = eas_FArray_Entry_Get(oStore, sArrayName, nIndex);
      if (fCompare == fValue)
      {
         eas_FArray_Entry_Delete(oStore, sArrayName, nIndex);
         return (nIndex);
      }
   }
   return (-1);
}

// OBJECT ARRAY
int eas_OArray_Entry_Add(object oStore, string sArrayName, object oEntry)
{
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   SetLocalObject(oStore, sArrayName + IntToString(nArraySize), oEntry);
   eas_Array_SetSize(oStore, sArrayName, nArraySize + 1);
   return (nArraySize);
}

void eas_OArray_Entry_Set(object oStore, string sArrayName, int nIndex, object oEntry)
{
   if (eas_Array_GetSize(oStore, sArrayName) > nIndex)
   {
      SetLocalObject(oStore, sArrayName + IntToString(nIndex), oEntry);
   }
}

object eas_OArray_Entry_Get(object oStore, string sArrayName, int nIndex)
{
   return (GetLocalObject(oStore, sArrayName + IntToString(nIndex)));
}

int eas_OArray_Entry_IndexOf(object oStore, string sArrayName, object oEntry)
{
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   int nIndex;
   for (nIndex = 0; nIndex < nArraySize; nIndex++)
   {
      if (eas_OArray_Entry_Get(oStore, sArrayName, nIndex) == oEntry)
      {
         return (nIndex);
      }
   }
   return (-1);
}

void eas_OArray_Entry_Swap(object oStore, string sArrayName, int nIndex1, int nIndex2)
{
   object oEntry1 = eas_OArray_Entry_Get(oStore, sArrayName, nIndex1);
   object oEntry2 = eas_OArray_Entry_Get(oStore, sArrayName, nIndex2);
   eas_OArray_Entry_Set(oStore, sArrayName, nIndex1, oEntry2);
   eas_OArray_Entry_Set(oStore, sArrayName, nIndex2, oEntry1);
}

void eas_OArray_Entry_Insert(object oStore, string sArrayName, int nIndex, object oEntry)
{
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   // Only able to insert something if it is within the array
   if (nArraySize > nIndex)
   {
      // Increase the Array Size
      eas_Array_SetSize(oStore, sArrayName, nArraySize + 1);

      // Add 1 to the index of each Entry before the Insert Position
      int nOldIndex;
      for (nOldIndex = nArraySize - 1; nOldIndex >= nIndex; nOldIndex--)
      {
         eas_OArray_Entry_Set(oStore, sArrayName, nOldIndex + 1, eas_OArray_Entry_Get(oStore, sArrayName, nOldIndex));
      }

      // Finally, set the inserted value
      eas_OArray_Entry_Set(oStore, sArrayName, nIndex, oEntry);
   }
}

void eas_OArray_Entry_Delete(object oStore, string sArrayName, int nIndex)
{
   // Only able to delete something if it is within the array
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   if (nArraySize > nIndex)
   {
      // Get the next entry and pull it to the deleted one until the end
      int nNewIndex;
      for (nNewIndex = nIndex; nNewIndex < nArraySize - 1; nNewIndex++)
      {
         eas_OArray_Entry_Set(oStore, sArrayName, nNewIndex, eas_OArray_Entry_Get(oStore, sArrayName, nNewIndex +1));
      }

      // Finally, delete the last entry and decrease the Array's Size
      DeleteLocalObject(oStore, sArrayName + IntToString(nArraySize - 1));
      eas_Array_SetSize(oStore, sArrayName, nArraySize - 1);
   }
}

int eas_OArray_Entry_DeleteByValue(object oStore, string sArrayName, object oValue)
{
   // Deletes an entry by Object
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   int nIndex;
   object oCompare;
   for (nIndex = 0; nIndex < nArraySize; nIndex++)
   {
      oCompare = eas_OArray_Entry_Get(oStore, sArrayName, nIndex);
      if (oCompare == oValue)
      {
         eas_OArray_Entry_Delete(oStore, sArrayName, nIndex);
         return (nIndex);
      }
   }
   return (-1);
}

// LOCATION ARRAY
int eas_LArray_Entry_Add(object oStore, string sArrayName, location lEntry)
{
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   SetLocalLocation(oStore, sArrayName + IntToString(nArraySize), lEntry);
   eas_Array_SetSize(oStore, sArrayName, nArraySize + 1);
   return (nArraySize);
}

void eas_LArray_Entry_Set(object oStore, string sArrayName, int nIndex, location lEntry)
{
   if (eas_Array_GetSize(oStore, sArrayName) > nIndex)
   {
      SetLocalLocation(oStore, sArrayName + IntToString(nIndex), lEntry);
   }
}

location eas_LArray_Entry_Get(object oStore, string sArrayName, int nIndex)
{
   return (GetLocalLocation(oStore, sArrayName + IntToString(nIndex)));
}

int eas_LArray_Entry_IndexOf(object oStore, string sArrayName, location lEntry)
{
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   int nIndex;
   for (nIndex = 0; nIndex < nArraySize; nIndex++)
   {
      if (eas_LArray_Entry_Get(oStore, sArrayName, nIndex) == lEntry)
      {
         return (nIndex);
      }
   }
   return (-1);
}

void eas_LArray_Entry_Swap(object oStore, string sArrayName, int nIndex1, int nIndex2)
{
   location lEntry1 = eas_LArray_Entry_Get(oStore, sArrayName, nIndex1);
   location lEntry2 = eas_LArray_Entry_Get(oStore, sArrayName, nIndex2);
   eas_LArray_Entry_Set(oStore, sArrayName, nIndex1, lEntry2);
   eas_LArray_Entry_Set(oStore, sArrayName, nIndex2, lEntry1);
}

void eas_LArray_Entry_Insert(object oStore, string sArrayName, int nIndex, location lEntry)
{
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   // Only able to insert something if it is within the array
   if (nArraySize > nIndex)
   {
      // Increase the Array Size
      eas_Array_SetSize(oStore, sArrayName, nArraySize + 1);

      // Add 1 to the index of each Entry before the Insert Position
      int nOldIndex;
      for (nOldIndex = nArraySize - 1; nOldIndex >= nIndex; nOldIndex--)
      {
         eas_LArray_Entry_Set(oStore, sArrayName, nOldIndex + 1, eas_LArray_Entry_Get(oStore, sArrayName, nOldIndex));
      }

      // Finally, set the inserted value
      eas_LArray_Entry_Set(oStore, sArrayName, nIndex, lEntry);
   }
}

void eas_LArray_Entry_Delete(object oStore, string sArrayName, int nIndex)
{
   // Only able to delete something if it is within the array
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   if (nArraySize > nIndex)
   {
      // Get the next entry and pull it to the deleted one until the end
      int nNewIndex;
      for (nNewIndex = nIndex; nNewIndex < nArraySize - 1; nNewIndex++)
      {
         eas_LArray_Entry_Set(oStore, sArrayName, nNewIndex, eas_LArray_Entry_Get(oStore, sArrayName, nNewIndex +1));
      }

      // Finally, delete the last entry and decrease the Array's Size
      DeleteLocalLocation(oStore, sArrayName + IntToString(nArraySize - 1));
      eas_Array_SetSize(oStore, sArrayName, nArraySize - 1);
   }
}

int eas_LArray_Entry_DeleteByValue(object oStore, string sArrayName, location lValue)
{
   // Deletes an entry by Location Comparison
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   int nIndex;
   location lCompare;
   for (nIndex = 0; nIndex < nArraySize; nIndex++)
   {
      lCompare = eas_LArray_Entry_Get(oStore, sArrayName, nIndex);
      if (lCompare == lValue)
      {
         eas_LArray_Entry_Delete(oStore, sArrayName, nIndex);
         return (nIndex);
      }
   }
   return (-1);
}

// GENERAL
void eas_Array_SetSize(object oStore, string sArrayName, int nArraySize)
{
   SetLocalInt(oStore, sArrayName + EAS_ARRAY_SIZE, nArraySize);
}

int eas_Array_GetSize(object oStore, string sArrayName)
{
   return (GetLocalInt(oStore, sArrayName + EAS_ARRAY_SIZE));
}

void eas_Array_SetType(object oStore, string sArrayName, int nArrayType)
{
   SetLocalInt(oStore, sArrayName + EAS_ARRAY_TYPE, nArrayType);
}

int eas_Array_GetType(object oStore, string sArrayName)
{
   return (GetLocalInt(oStore, sArrayName + EAS_ARRAY_TYPE));
}

void eas_Array_Delete(object oStore, string sArrayName, int bRealDelete = FALSE)
{
   int nIndex;
   int nArraySize = eas_Array_GetSize(oStore, sArrayName);
   int nArrayType = eas_Array_GetType(oStore, sArrayName);

   if (bRealDelete)
   {
   switch (nArrayType)
   {
      case EAS_ARRAY_TYPE_STRING:
         for (nIndex = 0; nIndex < nArraySize; nIndex++)
         {
            DeleteLocalString(oStore, sArrayName + IntToString(nIndex));
         }
         break;
      case EAS_ARRAY_TYPE_INTEGER:
         for (nIndex = 0; nIndex < nArraySize; nIndex++)
         {
            DeleteLocalInt(oStore, sArrayName + IntToString(nIndex));
         }
         break;
      case EAS_ARRAY_TYPE_FLOAT:
         for (nIndex = 0; nIndex < nArraySize; nIndex++)
         {
            DeleteLocalFloat(oStore, sArrayName + IntToString(nIndex));
         }
         break;
      case EAS_ARRAY_TYPE_OBJECT:
         for (nIndex = 0; nIndex < nArraySize; nIndex++)
         {
            DeleteLocalObject(oStore, sArrayName + IntToString(nIndex));
         }
         break;
      case EAS_ARRAY_TYPE_LOCATION:
         for (nIndex = 0; nIndex < nArraySize; nIndex++)
         {
            DeleteLocalLocation(oStore, sArrayName + IntToString(nIndex));
         }
         break;
   }
   }
   DeleteLocalInt(oStore, sArrayName + EAS_ARRAY_NAME);
   DeleteLocalInt(oStore, sArrayName + EAS_ARRAY_SIZE);
   DeleteLocalInt(oStore, sArrayName + EAS_ARRAY_TYPE);
}

int eas_Array_Exists(object oStore, string sArrayName)
{
    if (GetLocalInt(oStore, sArrayName + EAS_ARRAY_NAME) != EAS_ARRAY_NOTEXIST)
   {
      return (TRUE);
   }

   return (FALSE);
}

int eas_Array_Create(object oStore, string sArrayName, int nArrayType = EAS_ARRAY_TYPE_STRING)
{
   // If the Array already exists, return false
   if (GetLocalInt(oStore, sArrayName + EAS_ARRAY_NAME) != EAS_ARRAY_NOTEXIST)
   {
      return (FALSE);
   }
   else
   {
      SetLocalInt(oStore, sArrayName + EAS_ARRAY_NAME, EAS_ARRAY_EXIST);
      eas_Array_SetSize(oStore, sArrayName, 0);
      eas_Array_SetType(oStore, sArrayName, nArrayType);
      return (TRUE);
   }
}
