#if defined _dsc_sup_included
	#endinput
#endif
#define _dsc_sup_included
#pragma library dsc_sup

//Natives
native WP_Hash(buffer[], len, const str[]);

//Defines
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))

//Enumerators
enum GangInfo
{
	gname[30],
	gtag[6],
	gcolor,
	ghouse,
	ghouseid,
	gkills,
	gdeaths,
	gturfs,
	gscore
}
enum pInfo
{
	banned,
	muted,
	jailed,
	jailtime,
	mutetime,

	ppass[129],
	plevel, 
	pcash, 
	pkills,
	pdeaths,  
	blockpm,
	pid,
	revenges,
	hshots,
	bramp,
	bkills,
	robbs,

	dplayed,
	dwon,
	dwep1,
	dwep2, 
	dwep3,
	dplace,
	dbet,
	lmsplayed,
	lmswon,
	ggw,
	ggp,

	vowned,
	vmodel,
	vcolor_1,
	vcolor_2,
	vwheel,
	vnitro,
	vhydra,
	vneon_1,
	vneon_2,
	vpjob,

	ingang,
	gid,
	glevel,
	gskin,

	moving, 
	onduty
}
enum ZoneInfo
{
	zname[40],
	Float:zminx,
	Float:zminy,
	Float:zmaxx,
	Float:zmaxy,
	zteamid,
	ZoneAttacker,
	ZoneAttackTime
}
enum HouseInfo
{   
	Float:entercp[3],
	Float:exitcp[3],
	Float:enterpos[4],
	Float:exitpos[4],
	Float:spawn[4],
	hintid,
	hprice,
	hinttype[20],
	hextype[20],
	howned,    
	hteamid,
	icon_id
}
enum ShopInfo 
{
	Float:entercp[3],
	Float:exitcp[3],
	Float:buycp[3], 
	Float:enterpos[4],
	Float:exitpos[4],
	Float:actorpos[4],
	askin, 
	sintid,
	mapico,  
	label[30]
}

//Forwards
forward DuelDeadLine(id, playerid);
forward OnPlayerRequestClassEx(playerid, classid);
forward CloseMoneyTD(playerid);
forward ImNotMoving(playerid);
forward ExpireGangRequest(playerid);
forward HideZoneTD(playerid);
forward OnPlayerConnectEx(playerid);
forward HideVehTD(playerid);
forward KillMe(playerid);
forward GiveCash(playerid);
forward Delay_Kick(id);
forward EndJustRobbed(i);
forward LMSStartedJustNow();
forward UncuffForLMS();
forward StartLastManStanding();
forward ServerSaveTimer();
forward RandomServerMessage();
forward GunGameEndTime();
forward ExtraGunGameTime();
forward TDUpdate();
forward RobTimer();
forward TurfTimer();
forward UnjailandUnmuteTimer();
forward HideCashTD();
forward NeonTimer();
forward TurfMoney();
forward RandomWeather();


//Variables
/* Structural indexed variables (If you are adding new Zones or Shops or Gang Houses, Add them from bottom!!!*/
new SHOPINFO[][ShopInfo] = 
{
	{{2400.4546,-1981.0305,13.5469},{316.3385,-169.3107,999.6010},{312.5260,-165.4501,999.6010},{316.3890,-168.1086,999.5938,357.8714},{2400.4617,-1979.9575,13.5469,5.5610},{312.4288,-167.9619,999.5938,359.3154},179,6,6,"Ammunation"},
	{{1368.1385,-1279.8617,13.5469},{285.7780,-86.1066,1001.5229},{295.5310,-80.4978,1001.5156},{285.9504,-84.5581,1001.5156,358.3700},{1366.6174,-1279.7938,13.5469,90.9713},{295.4844,-82.6128,1001.5156,356.3829},179,4,6,"Ammunation"},
	{{1199.2911,-919.1228,43.1156},{363.4276,-74.8162,1001.5078},{376.5351,-67.8185,1001.5151},{364.3999,-74.3191,1001.5078,308.5025},{1199.7247,-920.8951,43.1059,187.8015},{376.5461,-65.8446,1001.5078,177.5868},167,10,10,"Burger shot"},
	{{811.0928,-1616.1610,13.5469},{363.4276,-74.8162,1001.5078},{376.5351,-67.8185,1001.5151},{364.3999,-74.3191,1001.5078,308.5025},{812.4869,-1616.1178,13.5469,266.8114},{376.5461,-65.8446,1001.5078,177.5868},167,10,10,"Burger shot"},
	{{928.4016,-1352.8529,13.3438},{364.9274,-11.3540,1001.8516},{370.9161,-6.6344,1001.8589},{364.8034,-9.8963,1001.8516,356.4257},{927.0389,-1352.8301,13.3766,89.6940},{370.8996,-4.4926,1001.8589,180.5422},167,9,14,"Cluckin' Bell"},
	{{2420.5327,-1508.9663,24.0000},{364.9274,-11.3540,1001.8516},{370.9161,-6.6344,1001.8589},{364.8034,-9.8963,1001.8516,356.4257},{2422.3423,-1508.8251,23.9922,271.4259},{370.8996,-4.4926,1001.8589,180.5422},167,9,14,"Cluckin' Bell"},
	{{2397.8445,-1898.7992,13.5469},{364.9274,-11.3540,1001.8516},{370.9161,-6.6344,1001.8589},{364.8034,-9.8963,1001.8516,356.4257},{2397.7148,-1897.4608,13.5469,0.3261},{370.8996,-4.4926,1001.8589,180.5422},167,9,14,"Cluckin' Bell"},
	{{2104.6030,-1806.4536,13.5547},{372.2772,-132.9766,1001.4922},{374.7301,-119.0155,1001.4995},{372.0168,-131.4597,1001.4922,358.8821},{2102.2542,-1806.9558,13.5547,87.4307},{374.7266,-117.0388,1001.4922,180.2829},155,5,29,"Well Stacked\nPizza"}
};
new HOUSEINFO[][HouseInfo] = 
{
	{{1298.6082,-799.6471,84.1406},{1298.9232,-796.0192,1084.0078},{1298.7500,-793.8243,1084.0078,356.7032},{1299.1433,-801.4569,84.1406,201.0896},{1301.9410,-787.5530,1084.0078,163.7114},5,325000,"Large","Large"},
	{{1310.1251,-1368.1191,13.5449},{140.4003,1366.9370,1083.8594},{140.2262,1368.3163,1083.8628,357.2354},{1310.3553,-1369.9587,13.5695,179.5571},{140.2879,1380.0179,1088.3672,178.8218},5,300000,"Medium","Large"},
	{{2066.2937,-1703.5804,14.1484},{234.2266,1064.3260,1084.2114},{234.1197,1066.8673,1084.2076,356.1310},{2067.2673,-1703.5109,14.1484,269.1463},{231.3083,1081.2069,1087.8203,91.3618},6,250000,"Medium","Small"},
	{{1083.7985,-1226.5649,15.8203},{-261.5857,1456.7648,1084.3672},{-263.2533,1457.0913,1084.3672,94.6203},{1085.4049,-1226.7224,15.8203,266.2560},{-275.3660,1456.4829,1088.8672,214.3775},4,155000,"Small","Small"},
	{{2421.5176,-1220.1774,25.5014},{2269.8735,-1210.5597,1047.5625},{2266.7363,-1210.5397,1048.4819,90.1632},{2421.4297,-1222.6329,25.3431,180.5060},{2249.3477,-1208.6302,1049.0234,225.8562},10,200000,"Medium","Medium"},
	{{2047.2332,-1913.1669,13.5469},{2195.9280,-1204.4780,1049.0234},{2192.9846,-1204.4305,1049.5134,83.7498},{2050.5957,-1912.7507,13.5469,271.3482},{2193.3616,-1224.5542,1049.0234,0.7391},6,150000,"Small","Small"},
	{{816.0690,-1387.5021,13.6114},{2282.9648,-1139.7607,1050.8984},{2282.6809,-1137.1254,1050.8984,0.0058},{816.4049,-1390.6664,13.4644,179.4328},{2278.4565,-1134.9429,1050.8984,290.5730},11,130000,"Small","Small"},
	{{726.7897,-1276.1465,13.6484 },{-284.5470,1471.0468,1084.3750},{-287.2862,1471.0637,1084.3750,90.9222},{729.5864,-1275.9059,13.5670,272.1151},{-288.7464,1478.3192,1088.8823,105.3578},15,175000,"Medium","Large"},
	{{253.0975,-1222.5415,75.3125},{2317.6958,-1026.0873,1050.2178},{2318.4500,-1024.2358,1050.2109,359.7871},{255.8200,-1225.5272,74.4618,218.3053},{2320.3108,-1009.3900,1054.7188,143.8984},9,175000,"Medium","Medium"}
};
new ZONEINFO[][ZoneInfo] =
{
	{ "Commerce",                     1370.80, -1577.50, 1463.90, -1384.90 },
	{ "Commerce",                     1583.50, -1722.20, 1758.90, -1577.50 },
	{ "Commerce",                     1667.90, -1577.50, 1812.60, -1430.80 },
	{ "Downtown_Los_Santos",          1370.80, -1384.90, 1463.90, -1170.80 },
	{ "Downtown_Los_Santos",          1378.30, -1130.80, 1463.90, -1026.30 },
	{ "Downtown_Los_Santos",          1391.00, -1026.30, 1463.90,  -926.90 },
	{ "East_Beach",                   2632.80, -1852.80, 2959.30, -1668.10 },
	{ "East_Beach",                   2632.80, -1668.10, 2747.70, -1393.40 },
	{ "East_Beach",                   2747.70, -1498.60, 2959.30, -1120.00 },
	{ "East_Los_Santos",              2222.50, -1628.50, 2421.00, -1494.00 },
	{ "East_Los_Santos",              2266.20, -1494.00, 2381.60, -1372.00 },
	{ "East_Los_Santos",              2281.40, -1372.00, 2381.60, -1135.00 },
	{ "El_Corona",                    1812.60, -2179.20, 1970.60, -1852.80 },
	{ "El_Corona",                    1692.60, -2179.20, 1812.60, -1842.20 },
	{ "Ganton",                       2222.50, -1852.80, 2632.80, -1722.30 },
	{ "Ganton",                       2222.50, -1722.30, 2632.80, -1628.50 },
	{ "Glen_Park",                    1812.60, -1449.60, 1996.90, -1350.70 },
	{ "Glen_Park",                    1812.60, -1100.80, 1994.30,  -973.30 },
	{ "Glen_Park",                    1812.60, -1350.70, 2056.80, -1100.80 },
	{ "Idlewood",                     1812.60, -1852.80, 1971.60, -1742.30 },
	{ "Idlewood",                     1812.60, -1742.30, 1951.60, -1602.30 },
	{ "Idlewood",                     1812.60, -1602.30, 2124.60, -1449.60 },
	{ "Jefferson",                    1996.90, -1449.60, 2056.80, -1350.70 },
	{ "Jefferson",                    2124.60, -1494.00, 2266.20, -1449.60 },
	{ "Jefferson",                    2056.80, -1372.00, 2281.40, -1210.70 },
	{ "Jefferson",                    2056.80, -1210.70, 2185.30, -1126.30 },
	{ "Las_Colinas",                  2056.80, -1126.30, 2126.80,  -920.80 },
	{ "Las_Colinas",                  2185.30, -1154.50, 2281.40,  -934.40 },
	{ "Las_Colinas",                  2126.80, -1126.30, 2185.30,  -934.40 },
	{ "Linden_Station",               2749.90,  1198.90, 2923.30,  1548.90 },
	{ "Linden_Station",               2811.20,  1229.50, 2861.20,  1407.50 },
	{ "Marina",                        647.70, -1804.20,  851.40, -1577.50 },
	{ "Marina",                        647.70, -1577.50,  807.90, -1416.20 },
	{ "Marina",                        807.90, -1577.50,  926.90, -1416.20 },
	{ "Market",                        787.40, -1416.20, 1072.60, -1310.20 },
	{ "Market",                        952.60, -1310.20, 1072.60, -1130.80 },
	{ "Market",                       1072.60, -1416.20, 1370.80, -1130.80 },
	{ "Mulholland_Intersection",      1463.90, -1150.80, 1812.60,  -768.00 },
	{ "Ocean_Docks",                  2373.70, -2697.00, 2809.20, -2330.40 },
	{ "Ocean_Docks",                  2324.00, -2302.30, 2703.50, -2145.10 },
	{ "Ocean_Docks",                  2089.00, -2394.30, 2201.80, -2235.80 },
	{ "Pershing_Square",              1440.90, -1722.20, 1583.50, -1577.50 },
	{ "Playa_del_Seville",            2703.50, -2126.90, 2959.30, -1852.80 },
	{ "Rodeo",                          72.60, -1684.60,  225.10, -1544.10 },
	{ "Rodeo",                         422.60, -1684.60,  558.00, -1570.20 },
	{ "Temple",                       1252.30, -1130.80, 1378.30, -1026.30 },
	{ "Temple",                       1252.30, -1026.30, 1391.00,  -926.90 },
	{ "Temple",                       1252.30,  -926.90, 1357.00,  -910.10 },
	{ "Verdant_Bluffs",                930.20, -2488.40, 1249.60, -2006.70 },
	{ "Verdant_Bluffs",               1249.60, -2179.20, 1692.60, -1842.20 },
	{ "Verona_Beach",                  647.70, -2173.20,  930.20, -1804.20 },
	{ "Verona_Beach",                  851.40, -1804.20, 1046.10, -1577.50 },
	{ "Verona_Beach",                 1046.10, -1722.20, 1161.50, -1577.50 },
	{ "Vinewood",                      787.40, -1310.20,  952.60, -1130.80 },
	{ "Vinewood",                      787.40, -1130.80,  952.60,  -954.60 },
	{ "Vinewood",                      647.50, -1227.20,  787.40, -1118.20 },
	{ "Vinewood",                      647.70, -1416.20,  787.40, -1227.20 },
	{ "Willowfield",                  1970.60, -2179.20, 2089.00, -1852.80 },
	{ "Willowfield",                  2089.00, -2235.80, 2201.80, -1989.90 },
	{ "Willowfield",                  2089.00, -1989.90, 2324.00, -1852.80 }
};
new VehicleNames[212][] =
{
	{"Landstalker"},{"Bravura"},{"Buffalo"},{"Linerunner"},{"Perrenial"},{"Sentinel"},
	{"Dumper"},{"Firetruck"},{"Trashmaster"},{"Stretch"},{"Manana"},{"Infernus"},{"Voodoo"},
	{"Pony"},{"Mule"},{"Cheetah"},{"Ambulance"},{"Leviathan"},{"Moonbeam"},{"Esperanto"},{"Taxi"},
	{"Washington"},{"Bobcat"},{"Mr. Whoopee"},{"BF. Injection"},{"Hunter"},{"Premier"},{"Enforcer"},
	{"Securicar"},{"Banshee"},{"Predator"},{"Bus"},{"Rhino"},{"Barracks"},{"Hotknife"},{"Article Trailer"},
	{"Previon"},{"Coach"},{"Cabbie"},{"Stallion"},{"Rumpo"},{"RC Bandit"},{"Romero"},{"Packer"},{"Monster"},
	{"Admiral"},{"Squalo"},{"Seasparrow"},{"Pizzaboy"},{"Tram"},{"Article Trailer 2"},{"Turismo"},{"Speeder"},
	{"Reefer"},{"Tropic"},{"Flatbed"},{"Yankee"},{"Caddy"},{"Solair"},{"Berkley's RC Van"},{"Skimmer"},
	{"PCJ-600"},{"Faggio"},{"Freeway"},{"RC Baron"},{"RC Raider"},{"Glendale"},{"Oceanic"},{"Sanchez"},
	{"Sparrow"},{"Patriot"},{"Quad"},{"Coastguard"},{"Dinghy"},{"Hermes"},{"Sabre"},{"Rustler"},{"ZR-350"},
	{"Walton"},{"Regina"},{"Comet"},{"BMX"},{"Burrito"},{"Camper"},{"Marquis"},{"Baggage"},{"Dozer"},
	{"Maverick"},{"News Chopper"},{"Rancher"},{"FBI Rancher"},{"Virgo"},{"Greenwood"},{"Jetmax"},{"Hotring"},
	{"Sandking"},{"Blista Compact"},{"Police Maverick"},{"Boxville"},{"Benson"},{"Mesa"},{"RC Goblin"},
	{"Hotring Racer A"},{"Hotring Racer B"},{"Bloodring Banger"},{"Rancher"},{"Super GT"},{"Elegant"},
	{"Journey"},{"Bike"},{"Mountain Bike"},{"Beagle"},{"Cropdust"},{"Stunt"},{"Tanker"},{"Roadtrain"},
	{"Nebula"},{"Majestic"},{"Buccaneer"},{"Shamal"},{"Hydra"},{"FCR-900"},{"NRG-500"},{"HPV1000"},
	{"Cement Truck"},{"Tow Truck"},{"Fortune"},{"Cadrona"},{"FBI Truck"},{"Willard"},{"Forklift"},
	{"Tractor"},{"Combine"},{"Feltzer"},{"Remington"},{"Slamvan"},{"Blade"},{"Freight"},{"Streak"},
	{"Vortex"},{"Vincent"},{"Bullet"},{"Clover"},{"Sadler"},{"Firetruck LA"},{"Hustler"},{"Intruder"},
	{"Primo"},{"Cargobob"},{"Tampa"},{"Sunrise"},{"Merit"},{"Utility"},{"Nevada"},{"Yosemite"},{"Windsor"},
	{"Monster A"},{"Monster B"},{"Uranus"},{"Jester"},{"Sultan"},{"Stratum"},{"Elegy"},{"Raindance"},
	{"RC Tiger"},{"Flash"},{"Tahoma"},{"Savanna"},{"Bandito"},{"Freight Flat"},{"Streak Carriage"},
	{"Kart"},{"Mower"},{"Dunerider"},{"Sweeper"},{"Broadway"},{"Tornado"},{"AT-400"},{"DFT-30"},{"Huntley"},
	{"Stafford"},{"BF-400"},{"Newsvan"},{"Tug"},{"Article Trailer 3"},{"Emperor"},{"Wayfarer"},{"Euros"},{"Mobile Hotdog"},
	{"Club"},{"Freight Carriage"},{"Trailer 3"},{"Andromada"},{"Dodo"},{"RC Cam"},{"Launch"},{"Police Car (LSPD)"},
	{"Police Car (SFPD)"},{"Police Car (LVPD)"},{"Police Ranger"},{"Picador"},{"S.W.A.T Van"},{"Alpha"},
	{"Phoenix"},{"Glendale"},{"Sadler"},{"Luggage Trailer A"},{"Luggage Trailer B"},{"Stair Trailer"},
	{"Boxville"},{"Farm Plow"},{"Utility Trailer"}
};
new s_AnimationLibraries[][] = 
{
		!"AIRPORT",    !"ATTRACTORS",   !"BAR",             !"BASEBALL",
		!"BD_FIRE",    !"BEACH",        !"BENCHPRESS",      !"BF_INJECTION",
		!"BIKED",      !"BIKEH",        !"BIKELEAP",        !"BIKES",
		!"BIKEV",      !"BIKE_DBZ",     !"BMX",             !"BOMBER",
		!"BOX",        !"BSKTBALL",     !"BUDDY",           !"BUS",
		!"CAMERA",     !"CAR",          !"CARRY",           !"CAR_CHAT",
		!"CASINO",     !"CHAINSAW",     !"CHOPPA",          !"CLOTHES",
		!"COACH",      !"COLT45",       !"COP_AMBIENT",     !"COP_DVBYZ",
		!"CRACK",      !"CRIB",         !"DAM_JUMP",        !"DANCING",
		!"DEALER",     !"DILDO",        !"DODGE",           !"DOZER",
		!"DRIVEBYS",   !"FAT",          !"FIGHT_B",         !"FIGHT_C",
		!"FIGHT_D",    !"FIGHT_E",      !"FINALE",          !"FINALE2",
		!"FLAME",      !"FLOWERS",      !"FOOD",            !"FREEWEIGHTS",
		!"GANGS",      !"GHANDS",       !"GHETTO_DB",       !"GOGGLES",
		!"GRAFFITI",   !"GRAVEYARD",    !"GRENADE",         !"GYMNASIUM",
		!"HAIRCUTS",   !"HEIST9",       !"INT_HOUSE",       !"INT_OFFICE",
		!"INT_SHOP",   !"JST_BUISNESS", !"KART",            !"KISSING",
		!"KNIFE",      !"LAPDAN1",      !"LAPDAN2",         !"LAPDAN3",
		!"LOWRIDER",   !"MD_CHASE",     !"MD_END",          !"MEDIC",
		!"MISC",       !"MTB",          !"MUSCULAR",        !"NEVADA",
		!"ON_LOOKERS", !"OTB",          !"PARACHUTE",       !"PARK",
		!"PAULNMAC",   !"PED",          !"PLAYER_DVBYS",    !"PLAYIDLES",
		!"POLICE",     !"POOL",         !"POOR",            !"PYTHON",
		!"QUAD",       !"QUAD_DBZ",     !"RAPPING",         !"RIFLE",
		!"RIOT",       !"ROB_BANK",     !"ROCKET",          !"RUSTLER",
		!"RYDER",      !"SCRATCHING",   !"SHAMAL",          !"SHOP",
		!"SHOTGUN",    !"SILENCED",     !"SKATE",           !"SMOKING",
		!"SNIPER",     !"SPRAYCAN",     !"STRIP",           !"SUNBATHE",
		!"SWAT",       !"SWEET",        !"SWIM",            !"SWORD",
		!"TANK",       !"TATTOOS",      !"TEC",             !"TRAIN",
		!"TRUCK",      !"UZI",          !"VAN",             !"VENDING",
		!"VORTEX",     !"WAYFARER",     !"WEAPONS",         !"WUZI",
		!"WOP",        !"GFUNK",        !"RUNNINGMAN"
};
new ServerMessages[][] =
{
	"Are_you_new_here,_get_started_with_/cmds!",
	"Go_and_register_on_our_forums_today.",
	"Join_Us_at_Discord_too.",
	"Shoot_enemies,_kill_them_and_earn_money_to_buy_new_stuff.",
	"Found_a_cheater/rule_breaker,_use_/report.",
	"Use_/rules_to_view_server_rules.",
	"Need_money?_You_can_start_turfing_with_3_players_of_your_gang.",
	"Unlock_more_exciting_and_premium_features_by_becoming_a_VIP.",
	"Need_help?_try_/cmds_or_Ask_an_online_admin.",
	"Use_/pm_to_privatly_message_a_player.",
	"Feeling_tired_reading_PMS?,_Use_/blockpm_to_disable_PMs!.",
	"You_can_also_check_your_stats_by_/stats.",
	"Bored_of_playing_TDM,_try_out_our_exclusive_deathmatches_(/dm).",
	"Thank_you_for_playing_and_stay_in_touch_with_us.",
	"Want_buy_powerful_weapons_and_kill_others_easily?_Ammunation_is_the_place_for_you."
};
new Float:GGRandoms[][] = 
{
	{-1424.3176,929.8211,1036.4011,1.2594},
	{-1462.5979,937.5638,1036.6046,341.9788},
	{-1443.1783,934.0751,1036.5001,349.5823},
	{-1349.6974,933.4794,1036.3354,47.0665},
	{-1284.3796,984.3537,1037.0651,91.8736},
	{-1330.7817,1048.0403,1038.2056,167.3668},
	{-1459.4106,1055.2855,1038.5537,203.8421},
	{-1364.1587,1027.4327,1026.0555,135.3942},
	{-1338.8990,1008.6232,1025.1545,97.1045},
	{-1343.7426,972.8263,1024.9725,66.1468},
	{-1388.7572,964.5891,1024.8502,348.7526},
	{-1442.9393,966.6888,1025.1619,296.0703},
	{-1462.1206,1003.9750,1025.3579,262.6685}
};
new Float:LSRandoms[][] = 
{
	{2693.0300,-1700.8091,10.6074,38.8973}, 
	{2055.0896,-2081.4724,13.5469,237.6100},
	{1786.8683,-1305.2595,13.6208,6.2561},
	{1172.8413,-1323.1978,15.3999,266.1578},
	{827.9908,-1357.3317,-0.4806,136.3823},
	{834.1077,-2063.7366,12.8672,352.6725},
	{1219.8381,-1813.0919,16.5938,183.3374},
	{1767.1799,-2049.0134,13.8049,269.9950},
	{2296.4617,-1883.4878,14.2344,177.7048},
	{2685.7993,-1429.0988,30.5113,91.7024},
	{2779.6201,-1416.3250,24.7453,274.0844},
	{2910.7578,-1103.5582,11.1211,90.2983},
	{2321.0664,-1217.7804,22.8135,98.5837},
	{2423.1606,-1355.6110,24.1432,83.4392}
};
new Float:LMS1Randoms[][] = //bloodbowl
{
	{-1399.0604,992.0749,1024.0472,181.0433},  
	{-1394.8666,992.6061,1024.0476,252.4631},  
	{-1402.1326,993.6147,1024.0759,182.1296},  
	{-1397.7029,994.6725,1024.0841,251.9200},  
	{-1394.2991,1000.3604,1024.1711,277.7180},
	{-1398.9524,1000.6335,1024.1877,10.8623},  
	{-1402.3956,996.6895,1024.1260,90.4288},
	{-1391.8325,997.1111,1024.1150,182.7586},  
	{-1395.7009,999.1021,1024.1530,8.6898}, 
	{-1403.4211,999.8877,1024.1866,33.9448}, 
	{-1407.0728,997.3740,1024.1465,108.3517} 
};
new Float:LMS2Randoms[][] = //rc Battlefield
{
	{-1067.5377,1060.5869,1344.0585,90.7610}, 
	{-1063.1788,1060.9998,1347.2094,212.9622}, 
	{-1061.8965,1062.7317,1346.6740,124.6347}, 
	{-1063.4073,1062.2261,1347.1222,2.5908},  
	{-1060.4254,1061.0087,1345.7579,283.5674}, 
	{-1060.4336,1064.5461,1343.8209,330.0038}, 
	{-1062.9540,1057.5420,1347.5349,171.6855}, 
	{-1062.3723,1061.7487,1347.0939,172.0099}, 
	{-1064.0403,1056.4017,1347.6122,81.5811}, 
	{-1060.5323,1057.5994,1345.1707,272.6719}, 
	{-1070.6835,1059.3749,1344.0234,57.1409}, 
	{-1068.5652,1060.9397,1343.9967,300.6424}, 
	{-1068.9292,1058.2244,1344.1602,184.9587}, 
	{-1071.4182,1056.4596,1344.2297,150.1992} 
};
new Float:DM1Randoms[][] =
{
	{1394.8962,2163.8765,9.7578,77.0915},
	{1393.6285,2154.5886,11.0234,126.6614},
	{1390.5864,2110.8823,11.0156,44.6299},
	{1352.1062,2110.1611,11.0156,1.6401},
	{1303.9574,2108.5049,11.0156,310.7542},
	{1305.5309,2155.5645,11.0234,269.9577},
	{1307.1626,2192.1667,11.0234,228.7225},
	{1367.1720,2195.6216,9.7578,176.5207},
	{1389.7062,2191.7002,11.0234,138.7951}
};
new Float:DM2Randoms[][] =
{
	{299.8549,191.2059,1007.1719,92.8495},
	{299.6268,171.2344,1007.1719,66.9679},
	{245.9618,186.6376,1008.1719,358.0966},
	{263.9229,171.6439,1003.0234,52.4916},
	{244.9740,142.1823,1003.0234,28.3647},
	{211.5222,147.3280,1003.0234,158.9398},
	{229.5165,182.1025,1003.0313,136.2777},
	{190.5076,179.0975,1003.0234,272.9943},
	{191.1204,157.7374,1003.0234,271.6781}
};
new Float:DM3Randoms[][] =
{
	{1305.7388,5.1727,1001.0289,135.5493},
	{1304.9875,-23.4904,1001.0328,97.3849},
	{1255.7964,1.2352,1001.0234,216.2647},
	{1251.2056,-25.2684,1001.0347,265.3959},
	{1249.8237,-67.2432,1002.4982,319.3525},
	{1307.9066,-67.3345,1002.4922,44.8934}
};
new Float:DM4Randoms[][] =
{
	{-971.3034,1020.1909,1345.0682,49.1311},
	{-974.0743,1061.2969,1345.6733,93.7268},
	{-974.2203,1089.6129,1344.9800,86.5593},
	{-1041.6479,1066.4843,1346.3698,102.7902},
	{-1063.2939,1058.3568,1347.4714,269.7750},
	{-1131.5018,1057.2994,1346.4126,273.2844},
	{-1131.1830,1029.3280,1345.7264,269.3363},
	{-1135.3628,1097.8984,1345.8186,230.7331}
};
new Float:DM5Randoms[][] =
{
	{1414.2346,4.4162,1000.9264,126.7759},
	{1380.4648,5.3185,1000.9169,177.9516},
	{1360.2059,5.1992,1000.9219,219.6253},
	{1359.8674,-22.7358,1000.9219,274.8978},
	{1360.5477,-47.2759,1000.9248,309.9915},
	{1382.8845,-47.8357,1000.9213,356.9292},
	{1417.9607,-44.9432,1000.9270,46.4990},
	{1418.8813,-21.8715,1000.9274,82.4700}
};
new Float:DM6Randoms[][] =
{
	{-250.3860,2314.4714,110.4074,35.5326},
	{-231.7803,2379.3232,110.2815,146.0049},
	{-277.6268,2362.2244,109.7923,185.6036},
	{-307.9205,2366.9297,113.0747,213.4842}
};
new RobRandoms[] = 
{
	1475,
	1250,
	725,
	950,
	1650,
	470
};
new NeonRandoms[] =
{
	18647,
	18648,
	18649,
	18650,
	18651,
	18652
};
new TeamRandoms[] = 
{
	TEAM_GROVE, 
	TEAM_BALLAS,
	TEAM_JUSTICE,
	TEAM_AZTECA,
	TEAM_MAFIA,
	TEAM_VAGOS
};
new LMSWeapons[][] = 
{
   {16, 26},
   {22, 27},
   {23, 28},
   {24, 30},
   {25, 34}
};

/* Integer */
new class_gselection[MAX_PLAYERS];
new class_selected[MAX_PLAYERS];
new inminigame[MAX_PLAYERS];
new ingg[MAX_PLAYERS];
new hospicked[MAX_PLAYERS];
new justconnected[MAX_PLAYERS];
new picked[MAX_PLAYERS];
new ucontrol[MAX_PLAYERS];
new frozen[MAX_PLAYERS];
new duelinvited[MAX_PLAYERS];
new duelinviter[MAX_PLAYERS];
new inanim[MAX_PLAYERS];
new induel[MAX_PLAYERS];
new killinginprogress[MAX_PLAYERS];
new indm[MAX_PLAYERS];
new vehowned[MAX_VEHICLES];
new remneons[MAX_PLAYERS];
new inlms[MAX_PLAYERS];
new grequested[MAX_PLAYERS];
new revenge[MAX_PLAYERS];
new JustRobbed[MAX_ACTORS];
new gg_started;
new lmsstarted;
new lmsjustnow;

new user_table;
new gang_table;
new house_table;
new zone_table;
new ip_table;
new tdlvl;
new egg_timer;
new DM1PLAYERS;
new DM2PLAYERS;
new DM3PLAYERS;
new DM4PLAYERS;
new DM5PLAYERS;
new DM6PLAYERS;
new lmsplace;
new WEAPS[MAX_PLAYERS][2][13];
new editvneon[MAX_PLAYERS][3];
new vehneon[MAX_VEHICLES][3];
new USERINFO[MAX_PLAYERS][pInfo];
new GANGINFO[MAX_GANGS][GangInfo];
new ZONEID[sizeof(ZONEINFO)];
new DZONEID[sizeof(ZONEINFO)];
new GENTERCP[sizeof(HOUSEINFO)];
new GEXITCP[sizeof(HOUSEINFO)];
new SENTERCP[sizeof(SHOPINFO)];
new SEXITCP[sizeof(SHOPINFO)];
new SBUYCP[sizeof(SHOPINFO)];
new hospick[2];
new GANG_HOUSE[12];
new PVEH[2];
new gangpick[6];
new pDrunkLevelLast[MAX_PLAYERS];
new pFPS[MAX_PLAYERS];
new af_page[MAX_PLAYERS];
new class_saved[MAX_PLAYERS];
new gg_lvl[MAX_PLAYERS];
new adm_id[MAX_PLAYERS];
new spamcount[MAX_PLAYERS];
new spectating[MAX_PLAYERS];
new adminveh[MAX_PLAYERS];
new rconattempts[MAX_PLAYERS];
new dstimer[MAX_PLAYERS];
new duelsender[MAX_PLAYERS];
new duelreciever[MAX_PLAYERS];
new enemy[MAX_PLAYERS];
new ds[MAX_PLAYERS];
new dmid[MAX_PLAYERS];
new dmkills[MAX_PLAYERS];
new dmdeaths[MAX_PLAYERS];
new dmspree[MAX_PLAYERS];
new INT[MAX_PLAYERS];
new VW[MAX_PLAYERS];
new TEAM[MAX_PLAYERS];
new COLOR[MAX_PLAYERS];
new SKIN[MAX_PLAYERS];
new SAWNBOUGHT[MAX_PLAYERS];
new ARMOURBOUGHT[MAX_PLAYERS];
new lmskills[MAX_PLAYERS];
new grequestedid[MAX_PLAYERS];
new reqtimer[MAX_PLAYERS];
new rampage[MAX_PLAYERS];
new revengeid[MAX_PLAYERS];
new vehitem[MAX_PLAYERS];
new robber[MAX_ACTORS] = {-1, ...};
new vehowner[MAX_VEHICLES] = {INVALID_PLAYER_ID, ...};
new priveh[MAX_PLAYERS] = {INVALID_VEHICLE_ID, ...};

/* Float */
new Float:DX[MAX_PLAYERS], Float:DY[MAX_PLAYERS], Float:DZ[MAX_PLAYERS];
new Float:HP[MAX_PLAYERS];
new Float:ARMOUR[MAX_PLAYERS];
new Float:FA[MAX_PLAYERS];
new Float:robgtv[MAX_PLAYERS];
new Float:robtime[MAX_ACTORS];

/* String */
new tempgname[MAX_PLAYERS][30];
new tempgtag[MAX_PLAYERS][6];
new lastmsg[MAX_PLAYERS][256];

/* Graphical */
new PlayerBar:rbar[MAX_PLAYERS];
new PlayerBar:turfbar[MAX_PLAYERS][2];

new Text3D:glabel[MAX_PLAYERS] = {Text3D:INVALID_3DTEXT_ID, ...};
new Text3D:hlabel[sizeof(HOUSEINFO)];
new Text3D:alabel[MAX_PLAYERS];
new Text3D:vehlabel[MAX_VEHICLES];

new Text:zonetd;
new Text:gangtd;
new Text:DSC[9];
new Text:vtunetd[3];
new Text:statstd[5];
new Text:takeovertd[5];
new Text:DM[2];
new Text:wastedtd[5];
new Text:connecttd[6];

new PlayerText:fplabel_1[MAX_PLAYERS];
new PlayerText:vtunetd_1[MAX_PLAYERS];
new PlayerText:wastedtd_1[MAX_PLAYERS];
new PlayerText:vehtd_1[MAX_PLAYERS];
new PlayerText:turfcashtd[MAX_PLAYERS];
new PlayerText:moneytd_1[MAX_PLAYERS];
new PlayerText:DM_1[MAX_PLAYERS][4];
new PlayerText:zonetd_1[MAX_PLAYERS][2];
new PlayerText:takeovertd_1[MAX_PLAYERS][3];
new PlayerText:statstd_1[MAX_PLAYERS][16];
new PlayerText:gangtd_1[MAX_PLAYERS][4];