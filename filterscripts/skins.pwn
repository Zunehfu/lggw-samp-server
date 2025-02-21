#include <a_samp>
#include <Pawn.CMD>
#include <a_mysql>
#define GANG_SCORE_PER_TURF 20
enum ZoneData
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
enum HouseData
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
new TeamRandoms[] = 
{
	0, 
	1,
	2,
	3,
	4,
	5,
	6
};
GetTeamName(teamid) 
{
	new str[50];
	switch(teamid)
	{
		case 0: format(str, sizeof(str), "%s", "Grove_street");
		case 1: format(str, sizeof(str), "%s", "Ballas");
		case 2: format(str, sizeof(str), "%s", "Vagos");
		case 3: format(str, sizeof(str), "%s", "Azteca");
		case 4: format(str, sizeof(str), "%s", "Justice");
		case 5: format(str, sizeof(str), "%s", "Russian_mafia");
		case 6: format(str, sizeof(str), "%s", "VIP");
	}
	return str;
}
GetTeamColor(teamid)
{
	switch(teamid)
	{
		case 0: return 3231;
		case 1: return 322;
		case 2: return 4343;
		case 3: return 9358;
		case 4: return 636;
		case 5: return 422;
		case 6: return 424;
	}
	return 1;
}

GetTeamTag(teamid)
{
	new str[50];
	switch(teamid)		
	{
		case 0: format(str, sizeof(str), "%s", "GS");
		case 1: format(str, sizeof(str), "%s", "BS");
		case 2: format(str, sizeof(str), "%s", "VG");
		case 3: format(str, sizeof(str), "%s", "AZT");
		case 4: format(str, sizeof(str), "%s", "JTC");
		case 5: format(str, sizeof(str), "%s", "RM");
		case 6: format(str, sizeof(str), "%s", "VIP");
	}
	return str;
}
new houseinfo[][HouseData] = 
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
new zoneinfo[][ZoneData] =
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

#define MAX_GANGS 30
public OnFilterScriptInit()
{
	new MySQLOpt: option_id = mysql_init_options(); 
	mysql_set_option(option_id, AUTO_RECONNECT, true); 

	new MySQL:Database = mysql_connect("localhost", "root", "", "lggw", option_id); 

	if(Database == MYSQL_INVALID_HANDLE || mysql_errno(Database) != 0) 
	{
		print("[ SERVER ] MySQL - > I couldn't connect to the MySQL server, closing..."); 
		SendRconCommand("exit"); 
		return 1; 
	}

	print("[ SERVER ] I connected to MySQL server successfully!");

	new turfs[sizeof(TeamRandoms)];
	new str[128];
	new Cache:r = mysql_query(Database, "SELECT * FROM `Gangs`");
	new rows;
    cache_get_row_count(rows);
    cache_delete(r);
	if(rows < MAX_GANGS)
	{
		for(new i = 0; i < MAX_GANGS; i ++)
		{
			if(i > (rows - 1))
			{
				printf("gang %i", i);
				if(i < 7)
				{
					mysql_format(Database, str, sizeof(str), "INSERT INTO `Gangs` (`Name`, `Tag`, `Color`) VALUES('%e', '%e', '%d')", GetTeamName(i), GetTeamTag(i), GetTeamColor(i));
					mysql_query(Database, str);
				}
				else mysql_query(Database, "INSERT INTO `Gangs` (`Name`, `Tag`, `Color`) VALUES('-1', '-1', '0')");
				printf("cache_insert_id -  %i", cache_insert_id());
			}
		}
	}

	r = mysql_query(Database, "SELECT * FROM `Zones`");
    cache_get_row_count(rows);
    new Rand;
    cache_delete(r);
	if(rows < sizeof(zoneinfo))
	{
		for(new i = 0; i < sizeof(zoneinfo); i ++)
		{
			printf("zone %i", i);
			if(i > (rows - 1))
			{
				Rand = random(sizeof(TeamRandoms)); 
                turfs[TeamRandoms[Rand]] ++;
				mysql_format(Database, str, sizeof(str), "INSERT INTO `Zones` (`Zone_owned_team_ID`) VALUES('%d')", TeamRandoms[Rand]);
				mysql_query(Database, str);
				printf("cache_insert_id -  %i", cache_insert_id());
			} 
		}

		for(new i = 0; i < 7; i++)
		{
			mysql_format(Database, str, sizeof(str), "UPDATE `Gangs` SET `Turfs`=Turfs+%d, `Score` = Score+%d WHERE `Gang_ID` = %d LIMIT 1", turfs[i], turfs[i] * GANG_SCORE_PER_TURF, i + 1);
			mysql_query(Database, str, false);
		}
	}

	r = mysql_query(Database, "SELECT * FROM `Houses`");
    cache_get_row_count(rows);
    cache_delete(r);
	if(rows < sizeof(houseinfo))
	{
		for(new i = 0; i < sizeof(houseinfo); i ++)
		{
			if(i > (rows - 1))
            {
            	printf("house %i", i);
                mysql_query(Database, "INSERT INTO `Houses` (`House_owned`) VALUES('0')");
                printf("cache_insert_id -  %i", cache_insert_id());
            }
		}
	}
	return 1;
}
