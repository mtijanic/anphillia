///////////////////////////////////////////////////////////////////////////////
// xp_cfg
// written by: eyesolated
// written at: Jan. 30, 2004
//
// Notes: Configuration Script for XP related stuff

const int CI_XP_GIVE_XP_ON_REST = TRUE;

// Set the BaseXP a monster is worth. BaseXP is what is rewarded if
// Average Group Level == Monster Difficulty
const int CI_XP_BASEXP = 25;

// Set the XP per Challenge Rating of a monster.
// If set to 1, a CR 15 monster will add 15 XP to it's BASE XP.
// Set to 0 to deactivate this feature.
const float CF_XP_BASEXP_CR = 0.15f;

// If this is set to TRUE, CR is squared for the above calculation
const int CF_XP_BASEXP_SQUARE_CR = TRUE;

// Set the minimum amount of XP a player will receive for a kill.
// Formula used is
// MINIMUM_XP = CI_XP_MINIMUM_XP + (CF_XP_MINIMUM_XP_CR * MONSTER_CR)
const int CI_XP_MINIMUM_XP = 0;
const float CF_XP_MINIMUM_XP_CR = 0.75f;

// Set the number by which the BaseXP are increased/reduced for each
// Level they differ
const int CI_XP_XPCHANGE = 3;

// Should the XP vary based on group size?
// If so, what is the "default" group size and the deviation in each direction
// If the default Group Size is 4 and the XPChange is 2, then the following will
// happen:
// Group Size 4 : +-0 Base XP
// Group Size 1 :  +6 Base XP
// Group Size 10: -12 Base XP
// Group Size 20: -32 Base XP
//
// If Base XP gets below 0 because of too big Group Size, Base XP is set to 0.
// Set CI_XP_GROUP_SIZE_XPCHANGE to 0 to deactivate this feature
// If you set this to a negative value, the effect will be reversed
const int CI_XP_GROUP_SIZE_XPCHANGE = -1;
const int CI_XP_GROUP_SIZE_STANDARD = 1;

// This sets the maximum group size deviation for the calculations
const int CI_XP_GROUP_SIZE_MAXDEVIATON = 4;

// Set the maximal difference between group average level and monster difficulty
// to still gain xp. if the difference is greater than this number, no xp is
// gained. set to -1 to deactivate this feature
const int CI_XP_MAXDIFFERENCE = -1;

// Set the change of PERSONAL XP per level the player differs from the average
// group level. Set to 0 to deactivate
const int CI_XP_PERSONALXPCHANGE = 2;

// Set the maximum level difference between the player and the average group
// level that modifies the XP-Change.
// Example:
// If you set CI_XP_PERSONALXPCHANGE = 2 and CI_XP_PERSONALMAXDIFFERENCE = 3 and
// the Average Group Level was 10 and the calculated BASEXP was 26, then XP gain
// will be as follows:
// Level 1-6: 34
// Level 7  : 32
// Level 8  : 30
// Level 9  : 28
// Level 10 : 26
// Level 11 : 24
// Level 12 : 22
// Level 13 : 20
// Level 14+: 18
const int CI_XP_PERSONALMAXDIFFERENCE = 5;

// This constant determines the size of the circle in which you have to
// be to get xp from a kill
const float CF_XP_CIRCLERADIUS = 40.0f;

// This constant determines wheter the center of the xp circle is the
// killed creature OR the player that killed it
// 1 = Killed Creature
// 2 = Player that killed
const int CI_XP_CIRCLERELATIVE = 1;

// How many levels below HIGHEST PARTY LEVEL will a player with a level even
// lower than that be treated as?
// Example:
// If you set this to 3 and the highest player in a group is lvl 10, ALL players
// in this group will be treated as AT LEAST level 7 in calculating BaseXP.
// NOTE: This is only used for BaseXP, for personal XP the player's REAL level
//       counts
const int CI_XP_MINLEVEL = 5;

// Should the XP script give gold as well?
const int CI_XP_GIVEGOLD = FALSE;

// The Multiplier: CR * this is the base amount of gold, then Random(CR) is added on top
const int CI_XP_MULTIPLIER = 5;

// Some variable strings
const string CS_XP_PLAYERNUMBER = "xp_players";
const string CS_XP_PLAYERPREFIX = "xp_player_";
const string CS_XP_PLAYERLEVEL = "xp_player_level_";
const string CS_XP_HIGHESTLEVEL = "xp_highest_level";
const string CS_XP_XPOVERRIDE = "XPOverride";
