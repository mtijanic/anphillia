/************************************************************************
 * script name  : pat_ini_areas
 * created by   : eyesolated
 * date         : 2018/7/31
 *
 * description  : Area Initialization script for PAT
 *
 * changes      : 2018/7/31 - eyesolated - Initial creation
 ************************************************************************/
#include "pat_inc"

void main()
{
    /* *************************************************************************
     * Use the following SQL statement to generate the contents of this file:
     *
     * SELECT CONCAT('pat_AddArea("', ResRef, '", "', Tag, '", "', Name, '", ', CR, ');') FROM PAT_Areas ORDER BY Name;
     **************************************************************************/
    pat_AddArea("adream2", "ADream", " A Dream", -1);
    pat_AddArea("fugueplane", "FuguePlane", " Fugue Plane", -1);
    pat_AddArea("a_egs", "A_EGS", "! A_EGS !", -1);
    pat_AddArea("a_lgs001", "A_LGS", "! A_LGS !", -1);
    pat_AddArea("dmhq001", "DMHQ", "! DM HQ", -1);
    pat_AddArea("area115", "MeetingHallOOC", "! Meeting Hall (OOC)", -1);
    pat_AddArea("pat_area", "PAT", "! PAT !", -1);
    pat_AddArea("dev_pscpvt", "dev_pscpvt", "! PSC_PersonalStorage", -1);
    pat_AddArea("abbeyhq", "AbbeyHQ_in", "Abbey HQ", -1);
    pat_AddArea("area002", "AsiramCanyonNorth", "Asiram Canyon - North", 10);
    pat_AddArea("asiramcanyon", "AsiramCanyon", "Asiram Canyon - South", 9);
    pat_AddArea("axfell", "Axfell", "Axfell", -1);
    pat_AddArea("area030", "AxfellBarracks", "Axfell - Barracks", -1);
    pat_AddArea("area015", "AxfellCardsBlacksmithing", "Axfell - Blacksmith and Tinkery", -1);
    pat_AddArea("area039", "AxfellCave", "Axfell - Cave", 1);
    pat_AddArea("area004", "AxfellGoblinCave_ud", "Axfell - Goblin Cave", 1);
    pat_AddArea("axfellgcavedeep", "AxfellGoblinCave_ud", "Axfell - Goblin Cave - Deep", 2);
    pat_AddArea("area026", "AxfellJeweler", "Axfell - Jeweler", -1);
    pat_AddArea("axfellmarys", "AxfellMarys_in", "Axfell - Mary's", -1);
    pat_AddArea("area040", "AxfellScribeandEnchanter", "Axfell - Scribe and Enchanter", -1);
    pat_AddArea("eastofaxfell", "AxfellCreek", "Axfell Creek", 1);
    pat_AddArea("axfellcrypts", "AxfellCreekCrypt_ud", "Axfell Creek - Crypt", 3);
    pat_AddArea("axfellcryp2", "CleavenCryptFloor2", "Axfell Creek - Crypt - Floor 2", 4);
    pat_AddArea("axfellcrypt3", "CleavenCryptsFloor3", "Axfell Creek - Crypt - Floor 3", 6);
    pat_AddArea("koboldcaverns", "koboldcaverns", "Axfell Creek - Kobold Caverns", 1);
    pat_AddArea("axfellfarmhouse", "CleavenFarmhouse_in", "Axfell Farmhouse", -1);
    pat_AddArea("axfellfarm", "AxfellFarm", "Axfell Farmlands", -1);
    pat_AddArea("axfellmine", "AxfellMine_ud", "Axfell Mine", -1);
    pat_AddArea("brampfcave", "BrampfCave_ud", "Brampf Cave", 9);
    pat_AddArea("brievalley", "BrieValley", "Brie Valley", 3);
    pat_AddArea("cheeldelorbbe_ud", "cheeldelorbbe_ud", "Che'el del Orbben", -1);
    pat_AddArea("dalsarena", "DalsCheeldelOrbbenArena", "Che'el del Orbben - Arena", -1);
    pat_AddArea("djalilzhaunilmag", "DjalilZhaunilMagthere_ud", "Che'el del Orbben - D'jalil Zhaunil Magthere", -1);
    pat_AddArea("area124", "CheeldelOrbbenEllardFaern", "Che'el del Orbben - El'lar d'Faern", -1);
    pat_AddArea("area010", "CheeldelOrbbenFaerlogElend_ud", "Che'el del Orbben - Faerl og'Elend", -1);
    pat_AddArea("area011", "CheeldelOrbbenklardelghinyrr_ud", "Che'el del Orbben - k'lar d'elghinyrr", -1);
    pat_AddArea("drowcrypt2", "drowcrypt2_ud", "Che'el del Orbben - k'lar d'elghinyrr - Level 2", -1);
    pat_AddArea("cheeldelorbbenkl", "klardehyrren_ud", "Che'el del Orbben - K'lar de'Hyrren", -1);
    pat_AddArea("cheeldelorbbenke", "KelRensKyostalen_ud", "Che'el del Orbben - Kel'Ren's Ky'ostalen", -1);
    pat_AddArea("cheeldelorbbenme", "MeleeMagthere_ud", "Che'el del Orbben - Melee Magthere", -1);
    pat_AddArea("cheeldelorbbenna", "CheeldelOrbbenNarelsIlinsaren_ud", "Che'el del Orbben - Narel's Ilinsaren", -1);
    pat_AddArea("cheeldelorbennor", "NorthernUnderdark_ud", "Che'el del Orbben - Northern Underdark", -1);
    pat_AddArea("area032", "CheeldelOrbbenPlaklaLani", "Che'el del Orbben - Plak'la Lani", -1);
    pat_AddArea("cheeldelorbbente", "CheeldelOrbbenTerrensSarolen_ud", "Che'el del Orbben - Terren's Sarolen", -1);
    pat_AddArea("dalsjail", "DalsCheeldelOrbbenVelXundussa", "Che'el del Orbben - Vel'Xundussa", -1);
    pat_AddArea("dalstemple", "DalsCheeldelOrbbenYathdQuarvalSh", "Che'el del Orbben - Yath d'Quarval - Sharess", -1);
    pat_AddArea("headlandscaves", "LowerCliffCaves_ud", "Cliff Caves - Lower", 11);
    pat_AddArea("uppercliffcaves", "UpperCliffCaves_ud", "Cliff Caves - Upper", 12);
    pat_AddArea("cloudcity001", "Cloudcity", "Cloudcity", 16);
    pat_AddArea("area012", "CloudcityEnchanters_in", "Cloudcity - Enchanter's", 17);
    pat_AddArea("area014", "CloudcityLibrary_in", "Cloudcity - Library", 17);
    pat_AddArea("area019", "CoastCrabcave", "Coast - Crabcave", 7);
    pat_AddArea("coastdevilsisle", "ZN100_CoastDevilsIsle", "Coast - Devils Isle", 5);
    pat_AddArea("coastsoutheast", "ZN100_CoastSoutheast", "Coast - East", 6);
    pat_AddArea("coastfarsoutheas", "ZN100_CoastSoutheast", "Coast - Far Southeast", 5);
    pat_AddArea("coastnortheast", "ZN100_CoastNortheast", "Coast - Northeast", 6);
    pat_AddArea("coastsouthsouthe", "ZN100_CoastSouthsoutheast", "Coast - Southeast", 4);
    pat_AddArea("coastsouthwest", "ZN100_CoastSouthwest", "Coast - Southwest", 4);
    pat_AddArea("area045", "CoastUndergroundPassage", "Coast - Underground Passage", 6);
    pat_AddArea("digsite", "DigSite", "Dig Site", 12);
    pat_AddArea("dmfi_custom_enc", "dmfi_custom_enc", "DMFI Custom Encounter Region", -1);
    pat_AddArea("elementalpocketp", "ElementalPocketPlaneofFlame", "Elemental Pocket Plane of Flame", -1);
    pat_AddArea("elementaltrial", "ElementalTrial_in", "Elemental Trial", -1);
    pat_AddArea("fortcleaven", "FortCleaven", "Fort Cleaven", -1);
    pat_AddArea("area047", "FortCleavenBarracks", "Fort Cleaven - Barracks", -1);
    pat_AddArea("area049", "FortCleavenBlacksmith", "Fort Cleaven - Blacksmith", -1);
    pat_AddArea("cleavenfarmhouse", "CleavenFarmhouse_in", "Fort Cleaven - Farmhouse", -1);
    pat_AddArea("area038", "FortCleavenJail", "Fort Cleaven - Jail", -1);
    pat_AddArea("area052", "FortCleavenJeweler", "Fort Cleaven - Jeweler", -1);
    pat_AddArea("area024", "FortCleavenNadies2", "Fort Cleaven - Nadie's", -1);
    pat_AddArea("area001", "FortCleavenOfficersQuarters", "Fort Cleaven - Officer's Quarters", -1);
    pat_AddArea("area051", "FortCleavenScribeandEnchanter", "Fort Cleaven - Scribe and Enchanter", -1);
    pat_AddArea("area048", "FortCleavenTailor", "Fort Cleaven - Tailor", -1);
    pat_AddArea("area050", "FortCleavenTinker", "Fort Cleaven - Tinker", -1);
    pat_AddArea("fortcleavenfarml", "ZN100_FortCleavenFarmlands", "Fort Cleaven Farmlands", -1);
    pat_AddArea("cleavenmine001", "FortCleavenCopperMine_ud", "Fort Cleaven Mine", -1);
    pat_AddArea("gracultcave", "GraCultCave_ud", "Gra Cult Cave", 10);
    pat_AddArea("area", "GrandForestSouth", "Grand Forest", 9);
    pat_AddArea("area020", "ZN100_GrandForestNorth", "Grand Forest", 10);
    pat_AddArea("grandforestcente", "ZN100_GrandForestFortRaut", "Grand Forest", 20);
    pat_AddArea("grandforestso001", "ZN100_GrandForestSouthwest", "Grand Forest", 9);
    pat_AddArea("grandforestso002", "ZN100_GrandForestSoutheast", "Grand Forest", 9);
    pat_AddArea("area043", "GrandForestCave", "Grand Forest - Cave", -1);
    pat_AddArea("area005", "GrandForestDruidsGroveNew", "Grand Forest - Druids Grove", -1);
    pat_AddArea("area072", "GrandForestDyemerchant", "Grand Forest - Dye Merchant", -1);
    pat_AddArea("grandforest", "GrandForestCleavenRuins", "Grand Forest - Fort Ramsallis", 9);
    pat_AddArea("area081", "GrandForestDawns", "Grand Forest - Fort Ramsallis Dawn's Downstairs", -1);
    pat_AddArea("area082", "GrandForestDawnsUpstairs", "Grand Forest - Fort Ramsallis Dawn's Upstairs", -1);
    pat_AddArea("area079", "GrandForestCleavenOutpost", "Grand Forest - Fort Ramsallis General Stores", -1);
    pat_AddArea("area003", "CleavenFortressRuins_in", "Grand Forest - Fort Ramsallis Ruins", 10);
    pat_AddArea("area121", "GrandForestTempleRuins", "Grand Forest - Temple Ruins", 10);
    pat_AddArea("headlands", "ZN104_Headlands", "Headlands", 10);
    pat_AddArea("cleavenforesti", "ZN100_HiddenCleavenForest", "Hidden Cleaven Forest", -1);
    pat_AddArea("homeofthegods001", "HomeoftheGods_ud", "Home of the Gods", -1);
    pat_AddArea("hopecanyongraths", "HopeCanyonLamirs_in", "Hope Canyon - Lamirs'", -1);
    pat_AddArea("hopevalleyn", "ZN100_HopeCanyon", "Hope Canyon - North", 11);
    pat_AddArea("hopevalley", "ZN100_HopeCanyon", "Hope Canyon - South", 12);
    pat_AddArea("hopevalleyw", "ZN100_HopeCanyon", "Hope Canyon - Southwest", 11);
    pat_AddArea("insanemagelai001", "InsaneMageLair_in", "Insane Mage Lair", -1);
    pat_AddArea("kahalalacanyons", "ZN103_KahalalaCanyons", "Kahalala Canyons", 13);
    pat_AddArea("desert2", "ZN103_KahalalaEast", "Kahalala East", 11);
    pat_AddArea("kahalalaentrance", "KahalalaEntrance_ud", "Kahalala Entrance", 10);
    pat_AddArea("kahalalanorth", "ZN103_KahalalaNorth", "Kahalala North", 13);
    pat_AddArea("kahalalanorth001", "KahalalaNorthPassage_in", "Kahalala North Passage", 12);
    pat_AddArea("desert3", "ZN103_KahalalaOasis", "Kahalala Oasis", 12);
    pat_AddArea("desert1", "KahalalaPassage_in", "Kahalala Passage", 11);
    pat_AddArea("despa", "UG01_in", "Kahalala Ruin", 14);
    pat_AddArea("kahalalawest", "ZN103_KahalalaWest", "Kahalala West", 13);
    pat_AddArea("krillanspass", "KrillansPass_ud", "Krillan's Pass", 9);
    pat_AddArea("krust_drowmines", "krust_drowmines_ud", "Krust Cave - Drow Mines", -1);
    pat_AddArea("duergarcave", "KrustCaveDuergarMines_ud", "Krust Cave - Duergar Mines", 14);
    pat_AddArea("grandforestcave", "KrustCaveLevel1_ud", "Krust Cave - Level 1", 12);
    pat_AddArea("grandforestno001", "KrustCaveLevel2_ud", "Krust Cave - Level 2", 13);
    pat_AddArea("krustcaveunderda", "KrustCaveUnderdark_ud", "Krust Cave - Underdark", -1);
    pat_AddArea("kuruh", "ZN103_Kuruh", "Kuruh", 14);
    pat_AddArea("kuruhcanyons", "ZN103_KuruhCanyons", "Kuruh Canyons", 14);
    pat_AddArea("kuruhcatacomb", "KuruhCatacomb", "Kuruh Catacomb", 15);
    pat_AddArea("kuruhinn", "KuruhInn_in", "Kuruh Inn", -1);
    pat_AddArea("kuruhtemple001", "KuruhTemple_in", "Kuruh Temple", 15);
    pat_AddArea("area017", "LajaaIlfaadTombLower_in", "Lajaa Ilf'aad Tomb Lower", 14);
    pat_AddArea("area016", "LajaaIlfaadTombUpper_in", "Lajaa Ilf'aad Tomb Upper", 13);
    pat_AddArea("area018", "LizardMarshNEW", "Lizard Marsh - North", 11);
    pat_AddArea("area025", "LizardMarshSouthNew", "Lizard Marsh - South", 12);
    pat_AddArea("lorietteforest", "ZN100_LorietteForestEast", "Loriette Forest - East", 7);
    pat_AddArea("area061", "LorietteForestNorth", "Loriette Forest - North", 5);
    pat_AddArea("lorietteforests", "ZN100_LorietteForestSouth", "Loriette Forest - South", 8);
    pat_AddArea("lorietteforesw", "ZN100_LorietteForestWest", "Loriette Forest - West", 8);
    pat_AddArea("lorietteforestpa", "LorietteForestPassage_ud", "Loriette Forest Passage", 8);
    pat_AddArea("madiahtahgreedto", "MadiahTahgreedTomb", "Madiah Tahgreed Tomb", 14);
    pat_AddArea("madiahtahgree001", "MadiahTahgreedTombLevel1", "Madiah Tahgreed Tomb - Lower", 15);
    pat_AddArea("madisonkeep", "Madisonkeep", "Madison Keep", 14);
    pat_AddArea("cap_ooc", "MtEskaNorth", "Mt. Eska", 10);
    pat_AddArea("area053", "DEVMtEskaDarneys", "Mt. Eska - Darney's", 11);
    pat_AddArea("area054", "DEVMtEskaInn", "Mt. Eska - Inn", 10);
    pat_AddArea("area055", "MtEskaSilanas", "Mt. Eska - Silana's", 11);
    pat_AddArea("mtower_construct", "mtower_construct_in", "Mysterious Tower - Constructor's Workshop", -1);
    pat_AddArea("area006", "MTower_01_in", "Mysterious Tower - Level 1", 13);
    pat_AddArea("mtower_02", "MTower_02_in", "Mysterious Tower - Level 2", 13);
    pat_AddArea("mtower_03", "MTower_03_in", "Mysterious Tower - Level 3", 13);
    pat_AddArea("norisbasement", "NorisBasement_in", "Nori's - Basement", -1);
    pat_AddArea("northoffortcleav", "ZN100_NorthofFortCleaven", "North of Fort Cleaven", 1);
    pat_AddArea("fortcleavencrypt", "NorthOfFortCleavenCrypts_ud", "North of Fort Cleaven - Crypt", 3);
    pat_AddArea("area041", "CleavenCryptFloor2", "North of Fort Cleaven - Crypt - Floor 2", 4);
    pat_AddArea("area042", "CleavenCryptsFloor3", "North of Fort Cleaven - Crypt - Floor 3", 6);
    pat_AddArea("northcleavengc", "NorthOfFortCleavenGoblinCave_ud", "North of Fort Cleaven - Goblin Cave", 2);
    pat_AddArea("northoffortcl001", "NorthOfFortCleavenKoboldCave_ud", "North of Fort Cleaven - Kobold Cave", 1);
    pat_AddArea("area013", "OasisHabibFenal_in", "Oasis - Habib Fenal", -1);
    pat_AddArea("maheri001", "MaHeri_in", "Oasis - MaHeri", -1);
    pat_AddArea("area077", "PlainsBanditsHideout", "Plains - Bandits Hideout", -1);
    pat_AddArea("plainscave", "PlainsCave_ud", "Plains - Cave", 9);
    pat_AddArea("plainseast", "ZN100_PlainsEast", "Plains - East", 7);
    pat_AddArea("plains", "ZN100_Plains", "Plains - Northeast", 8);
    pat_AddArea("plainsnorthwest", "PlainsNorthwest", "Plains - Northwest", 6);
    pat_AddArea("plainssoutheast", "ZN100_PlainsSouthEast", "Plains - Southeast", 7);
    pat_AddArea("plainssouthwest", "ZN100_PlainsSouthWest", "Plains - Southwest", 6);
    pat_AddArea("plainswest", "ZN100_PlainsWest", "Plains - West", 5);
    pat_AddArea("ranzingtonnew", "RanzingtonNew", "Ranzington", -1);
    pat_AddArea("area028", "Ranzington1stMansion", "Ranzington - 1st Mansion", -1);
    pat_AddArea("area083", "RanzingtonBank", "Ranzington - Bank", -1);
    pat_AddArea("ranzingtontownha", "RanzingtonTownHall_in", "Ranzington - City Castle", -1);
    pat_AddArea("area099", "RanzingtonCityCouncil", "Ranzington - Courtroom", -1);
    pat_AddArea("ranzblacksmith", "FortCleavenBlacksmithing_in", "Ranzington - Doric's Blacksmith", -1);
    pat_AddArea("area023", "RanzingtonBragonbar", "Ranzington - Dragon Bar", -1);
    pat_AddArea("area116", "RanzingtonDragonBar1stFloor", "Ranzington - Dragon Bar - Upstairs", -1);
    pat_AddArea("ranzingtonfloras", "RanzingtonFloras_in", "Ranzington - Floras'", -1);
    pat_AddArea("area046", "RanzingtonGuildofMerchantsNew", "Ranzington - Guild of Merchants", -1);
    pat_AddArea("area100", "RanzingtonJails", "Ranzington - Jails", -1);
    pat_AddArea("ranztailoring", "FortCleavenVilmars_in", "Ranzington - John's Tailoring", -1);
    pat_AddArea("area084", "RanzingtonLibrary", "Ranzington - Library", -1);
    pat_AddArea("ranzingtonmagus", "RanzingtonMagus_in", "Ranzington - Magus' House", -1);
    pat_AddArea("ranzgem", "FortCleavenBiams_in", "Ranzington - Mich's", -1);
    pat_AddArea("ranzingtonsewers", "RanzingtonSewers_ud", "Ranzington - Sewers", 5);
    pat_AddArea("ranztinkering", "FortCleavenTailoring_in", "Ranzington - Tinkering Workshop", -1);
    pat_AddArea("ranzingtontanner", "RanzingtonTanner_in", "Ranzington - Zach's Tanning", -1);
    pat_AddArea("area007", "RanzingtonPathNEW", "Ranzington Path", 1);
    pat_AddArea("area101", "RanzingtonPathAntHill", "Ranzington Path - Ant Hill", -1);
    pat_AddArea("ranzcoppermine", "FortCleavenCopperMine_ud", "Ranzington Path - Copper Mine", -1);
    pat_AddArea("ranzingtonscrypt", "AxfellCreekCrypt_ud", "Ranzington Path - Crypt", 3);
    pat_AddArea("area104", "RanzingtonPathCryptsLower", "Ranzington Path - Crypts - Lower", 4);
    pat_AddArea("ranzfarmhouse", "CleavenFarmhouse_in", "Ranzington Path - Farmhouse", -1);
    pat_AddArea("area027", "RedTribeCanyonTest", "Red Tribe Canyon", 12);
    pat_AddArea("redtribecave", "RedTribeCave_ud", "Red Tribe Cave", 14);
    pat_AddArea("area021", "RedTribeValleyNew", "Red Tribe Valley", 11);
    pat_AddArea("area022", "RustinCaveKingsCave", "Rustin Cave - Kings Cave", -1);
    pat_AddArea("rustinmountain", "ZN104_RustinMountain", "Rustin Mountain - North", 6);
    pat_AddArea("rustinmountainpe", "ZN104_RustinMountainPeak", "Rustin Mountain - Peak", 7);
    pat_AddArea("rustinmountais", "ZN104_RustinMountain", "Rustin Mountain - South", 6);
    pat_AddArea("rustinpoint", "ZN100_RustinPoint", "Rustin Point", 4);
    pat_AddArea("rustinroad", "ZN100_RustinRoad", "Rustin Road", 2);
    pat_AddArea("rustinroadbeetle", "RustinRoadBeetleHive_ud", "Rustin Road - Beetle Hive", 4);
    pat_AddArea("rustinroadcave", "RustinRoadCave_ud", "Rustin Road - Cave", 5);
    pat_AddArea("rustinvalley", "ZN100_RustinValley", "Rustin Valley", 6);
    pat_AddArea("serisisland", "ZN100_SerisIsland", "Seris Island", 1);
    pat_AddArea("serisislandbu001", "SerisIslandBugbearsCave_ud", "Seris Island - Bugbears Cave", 3);
    pat_AddArea("area034", "ZN100_SerisIslandForest", "Seris Island - Forest", -1);
    pat_AddArea("serisislandkobol", "SerisIslandKoboldsCave_ud", "Seris Island - Kobolds Cave", 2);
    pat_AddArea("serisislandbugbe", "SerisIslandBugbearsCave_ud", "Seris Island - Ogres Cave", 4);
    pat_AddArea("shilar", "Shilar", "Shilar", -1);
    pat_AddArea("shilarabhall", "shilarabhall", "Shilar - Abbey - Hall", -1);
    pat_AddArea("shilarablib", "shilarablib", "Shilar - Abbey - Library", -1);
    pat_AddArea("shilarablivq", "shilarablivq", "Shilar - Abbey - Quarters", -1);
    pat_AddArea("shilarabshr", "shilarabshr", "Shilar - Abbey - Shrine to the Crying God", -1);
    pat_AddArea("shilarabsup", "shilarabsup", "Shilar - Abbey - Supplier's", -1);
    pat_AddArea("shilarhouse", "ShilarHouse_in", "Shilar - House of Crafts", -1);
    pat_AddArea("shilarmine", "ShilarMine_AreaXP050_ud", "Shilar - Mine", -1);
    pat_AddArea("shilartomb", "ShilarTomb_in", "Shilar - Tomb", -1);
    pat_AddArea("snowshamanhouse", "SnowShamanHouse", "Snow Shaman House", -1);
    pat_AddArea("spidercave", "SpiderCave_ud", "Spider Cave - North", 6);
    pat_AddArea("spidercavesouth", "SpiderCaveSouth_ud", "Spider Cave - Queen's Lair", 6);
    pat_AddArea("lowersumanmounta", "ZN104_LowerSumanMountain", "Suman Mountain", 3);
    pat_AddArea("sumanmountainpea", "ZN104_SumanMountainPeak", "Suman Mountain - Peak", 4);
    pat_AddArea("sumanvalley", "SumanValley", "Suman Valley", 2);
    pat_AddArea("sumanvalleybeetl", "SumanValleyBeetleHive_ud", "Suman Valley - Beetle Hive", 4);
    pat_AddArea("sumanvalleycave", "SumanValleyCave_ud", "Suman Valley - Cave", 5);
    pat_AddArea("area033", "ZN100_SumanValleyHills", "Suman Valley - Hills", 3);
    pat_AddArea("area036", "SumanValleyHillsCave", "Suman Valley - Hills Cave", 4);
    pat_AddArea("area037", "SumanValleyHillsCrypt", "Suman Valley - Hills Crypt", 4);
    pat_AddArea("area035", "SumanValleyHillsMansion", "Suman Valley - Hills Mansion", 4);
    pat_AddArea("brokencliffssumm", "ZN100_SummitOfTheBrokenCliffs", "Summit Of The Broken Cliffs", -1);
    pat_AddArea("area009", "TheAbyssAnUnkownLayer", "The Abyss - An Unknown Layer", -1);
    pat_AddArea("thebrokencliffs", "ZN100_TheBrokenCliffs", "The Broken Cliffs", 13);
    pat_AddArea("yip_thedarkplace", "TheDarkPlace", "The Dark Place", -1);
    pat_AddArea("thedungeonave002", "TheDungeonAvernus", "The Dungeon Avernus - Abyss", -1);
    pat_AddArea("thedungeonaver", "TheDungeonAvernusEntrance", "The Dungeon Avernus - Entrance", -1);
    pat_AddArea("thedungeonave001", "TheDungeonAvernusHiddenRoom", "The Dungeon Avernus - Hidden Portal Room", -1);
    pat_AddArea("thedungeonave003", "TheDungeonAvernusSingingRoom", "The Dungeon Avernus - Riddle Room", -1);
    pat_AddArea("thedungeonave004", "TheDungeonAvernusTreasureRoom", "The Dungeon Avernus - Treasure Room", -1);
    pat_AddArea("thedungeonavernu", "TheDungeonAvernusUpperLevel", "The Dungeon Avernus - Upper Level", -1);
    pat_AddArea("area062", "TheGreatLakeWest", "The Great Lake", 12);
    pat_AddArea("banditcamp", "Area001", "The Great Lake - Bandit Camp", 13);
    pat_AddArea("testthechasm", "TestTheChasm_in", "The Underground Chasm", -1);
    pat_AddArea("underdark", "Underdark_ud", "Underdark", 16);
    pat_AddArea("underdark001", "UDMazeEast_AreaXP033_ud", "Underdark", 12);
    pat_AddArea("underdark002", "UDMazeWest_AreaXP033_ud", "Underdark", 11);
    pat_AddArea("underdark003", "UDBelowHopeSouthwest_ud", "Underdark", 16);
    pat_AddArea("underdark004", "UDBelowUndergroundpassage_ud", "Underdark", 13);
    pat_AddArea("underdark005", "UDBelowLoriette_ud", "Underdark", 11);
    pat_AddArea("underdark006", "UnderdarkLorietteEast_ud", "Underdark", 12);
    pat_AddArea("underdark007", "UDNorthernWestern_ud", "Underdark", 11);
    pat_AddArea("underdark008", "UDBelowSumanSouth_ud", "Underdark", 10);
    pat_AddArea("underdark009", "UDUnderRustinSouth_ud", "Underdark", 10);
    pat_AddArea("underdark010", "TILESET_Underdark_ud", "Underdark", 11);
    pat_AddArea("underdarkbelgfc", "UnderdarkBelowGF_ud", "Underdark", 14);
    pat_AddArea("underdarkbelgfe", "UnderdarkBelowGFE_ud", "Underdark", 14);
    pat_AddArea("underdarkbelo001", "UnderdarkBelowPlainsSouthwest_ud", "Underdark", 12);
    pat_AddArea("underdarkbelo002", "UnderdarkBelowPlainsNortheast_ud", "Underdark", 12);
    pat_AddArea("underdarkbelo003", "UnderdarkBelowPlainsEast_ud", "Underdark", 13);
    pat_AddArea("underdarkbelowcl", "UnderdarkBelowCleavenRuins_ud", "Underdark", 15);
    pat_AddArea("underdarkbelowgf", "UnderdarkBelowGFW_ud", "Underdark", 16);
    pat_AddArea("underdarkbelowho", "UnderdarkBelowHopeSouthwest_ud", "Underdark", 16);
    pat_AddArea("underdarkbelowkr", "UnderdarkBelowKrillansPass_ud", "Underdark", 15);
    pat_AddArea("underdarkbelowpl", "UnderdarkBelowPlainsSoutheast_ud", "Underdark", 13);
    pat_AddArea("utterseaud1", "a_Underdark035_Utt", "Underdark", 16);
    pat_AddArea("utterseaud2", "a_Underdark034_Utt", "Underdark", 16);
    pat_AddArea("uttud036", "a_Underdark036_Utt", "Underdark", 16);
    pat_AddArea("area008", "UnderdarkGoblinChieftainHut_in", "Underdark - Goblin Chieftain Hut", 4);
    pat_AddArea("area078", "Area001", "Underground Passage - Axfell Outpost", 9);
    pat_AddArea("area080", "KorahsBaracks", "Underground Passage - Korah's Baracks", 9);
    pat_AddArea("undergroundpassa", "UndergroundPassageNorth_ud", "Underground Passage - North", 9);
    pat_AddArea("undergroundpa001", "UndergroundPassageSouth_ud", "Underground Passage - South", 9);
    pat_AddArea("unknownhideout", "UnknownHideout", "Unknown Hideout", -1);
pat_AddArea("utterseacoldc", "a_UtterseaIsleColdCavern", "Uttersea Isle - Cold Cavern", 14);
    pat_AddArea("utterseadeadf", "a_UtterseaIsleDeadFC", "Uttersea Isle - Dead Forest Cemetery", 14);
    pat_AddArea("utterseacovec", "a_UtterseaIsleDFCCrypt", "Uttersea Isle - Dead Forest Cemetery - Crypt", 15);
    pat_AddArea("utterseaecv2", "a_UtterseaIsleEastCoast", "Uttersea Isle - East Coast", 12);
    pat_AddArea("utterseweabhs001", "a_UtterseaECABhse", "Uttersea Isle - East Coast - Abandoned House", 13);
    pat_AddArea("utterseaeastp", "a_UtterseaIsleEPath", "Uttersea Isle - Eastern Path", 12);
    pat_AddArea("uttersealaket001", "a_UtterseaFrozenLITom", "Uttersea Isle - Frozen Lake Ice Tomb", 14);
    pat_AddArea("uttersealaketupp", "a_UtterseaIFLtomc", "Uttersea Isle - Frozen Lake Ice Tomb - Crypt", 15);
    pat_AddArea("uttersealaket1", "a_UtterseaIFrozenLake", "Uttersea Isle - Frozen Lake Tuern", 14);
    pat_AddArea("uttersalargeb", "a_UtterseaILargeBarn", "Uttersea Isle - Large Barn", 11);
    pat_AddArea("utterseallintha", "a_UtterseaILlintharsSpells", "Uttersea Isle - Llinthars Spells, Scrolls & Sorcery", 11);
    pat_AddArea("utterseanorthc", "a_UtterseaINorthCove", "Uttersea Isle - North Cove", 12);
    pat_AddArea("utterseagtower", "a_UtterseaINorthGuardTower", "Uttersea Isle - North Cove - Guard Tower", 13);
    pat_AddArea("area029", "ZN102_nwasteland1", "Uttersea Isle - Northern Wasteland", 13);
    pat_AddArea("northerncastl001", "ZN102_NorthernCastle", "Uttersea Isle - Northern Wasteland - Castle", 14);
    pat_AddArea("northerncastlein", "NorthernCastleInterior", "Uttersea Isle - Northern Wasteland - Castle Interior", 14);
    pat_AddArea("area044", "NothernWastesACave", "Uttersea Isle - Northern Wasteland - Cave", 13);
    pat_AddArea("area031", "Area001", "Uttersea Isle - Northern Wasteland - Crypts", 14);
    pat_AddArea("wastelandcyrptsl", "WastelandCyrptsLower", "Uttersea Isle - Northern Wasteland - Crypts - Lower", 15);
    pat_AddArea("northenwasteland", "ZN102_nWastelandsFrozenTundra", "Uttersea Isle - Northern Wasteland - Frozen Tundra", 13);
    pat_AddArea("utterseapathttl", "a_UtterseaIPtoTuernLa", "Uttersea Isle - Path to Tuern Lake", 13);
    pat_AddArea("utterseaisleswpa", "a_UtterseaIPathtoTuernTo", "Uttersea Isle - Path to Tuern Town", 13);
    pat_AddArea("utterseseafrcave", "a_UtterseaISeafrostCave", "Uttersea Isle - Seafrost Cave", 14);
    pat_AddArea("utterseaisleswpe", "a_UtterseaISouthWestPenin", "Uttersea Isle - South West Peninsula", 12);
    pat_AddArea("utt_templeofbane", "a_UtterseaITempleofBane", "Uttersea Isle - Temple of Bane", 13);
    pat_AddArea("utterseatobhpch", "a_UtterseaITempofBHPQ", "Uttersea Isle - Temple of Bane - High Priests Chambers", 14);
    pat_AddArea("utt_baneholdcell", "a_UtterseaITempleofBHC", "Uttersea Isle - Temple of Bane - Holding Cell", 13);
    pat_AddArea("utt_banesacrif", "a_UtterseaITempleofBSA", "Uttersea Isle - Temple of Bane - Sacrificial Altar", 13);
    pat_AddArea("utterseatempshan", "a_UtterseaITempleofSha", "Uttersea Isle - Temple of Shaundakul", 12);
    pat_AddArea("utterseadewdrop", "a_UtterseaITDDropInn", "Uttersea Isle - The Dew Drop Inn", 11);
    pat_AddArea("utterseadewdropu", "a_UtterseaITDDInnUpstair", "Uttersea Isle - The Dew Drop Inn - Upstairs", 11);
    pat_AddArea("utterseathrend", "a_UtterseaIThrendilsSmithy", "Uttersea Isle - Threndils Smithy", 11);
    pat_AddArea("utterseathome", "a_UtterseaITuernHome", "Uttersea Isle - Tuern Home", 11);
    pat_AddArea("utterseatsewer", "a_UtterseaITuernSewers", "Uttersea Isle - Tuern Sewers", 13);
    pat_AddArea("utterseatuern", "a_UtterseaITuernTown", "Uttersea Isle - Tuern Town", 12);
    pat_AddArea("utterseatuerntth", "a_UtterseaITuernTownHall", "Uttersea Isle - Tuern Town Hall", 11);
    pat_AddArea("utterseatuernhse", "a_Utterseaturenhouse", "Uttersea Isle - Tuern Town House", 11);
    pat_AddArea("utterseawgaint", "a_UtterseaIWagonInterior", "Uttersea Isle - Wagon Interior", 11);
    pat_AddArea("webbycavern", "WebbyCavern_ud", "Webby Cavern", 6);
    pat_AddArea("webbycavernqueen", "WebbyCavernQueensLair_ud", "Webby Cavern - Queen's Lair", 6);
    pat_AddArea("obsidianisle", "ObsidianIsle", "[DEV] Obsidian Isle", -1);
    pat_AddArea("sharpteethcliffs", "SharpTeethCliffs", "[DEV] Sharp Teeth Cliffs", -1);
    pat_AddArea("thegreatlake001", "TheGreatLake", "[DEV] The Great Lake", -1);
    pat_AddArea("quest_ship", "quest_ship", "[Q] Aboard a ship", -1);
    pat_AddArea("quest_crypt", "quest_crypt", "[Q] Crypts", -1);
    pat_AddArea("quest_desisland", "quest_desisland", "[Q] Desert Island", -1);
    pat_AddArea("q_z_shroom", "Q_Z_Shroom", "[Q] Fungal Caves", -1);
    pat_AddArea("quest_interior1", "quest_interior1", "[Q] Interiors 1", -1);
    pat_AddArea("q_z_island_c", "q_z_island_c", "[Q] Melgar's Isle - Caves", -1);
    pat_AddArea("q_z_island_i", "q_z_island_i", "[Q] Melgar's Isle - Interiors", -1);
    pat_AddArea("q_z_island_n", "q_z_island_n", "[Q] Melgar's Isle - North", -1);
    pat_AddArea("q_z_island_s", "q_z_island_s", "[Q] Melgar's Isle - South", -1);
}