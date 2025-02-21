/*
										
											██╗░░░░░░██████╗░░██████╗░░██╗░░░░░░░██╗
											██║░░░░░██╔════╝░██╔════╝░░██║░░██╗░░██║
											██║░░░░░██║░░██╗░██║░░██╗░░╚██╗████╗██╔╝
											██║░░░░░██║░░╚██╗██║░░╚██╗░░████╔═████║░
											███████╗╚██████╔╝╚██████╔╝░░╚██╔╝░╚██╔╝░
											╚══════╝░╚═════╝░░╚═════╝░░░░╚═╝░░░╚═╝░░ Build 3

LGGW - Lazer Gaming Gang WarZ
Version - v 1.03
Forum - https://www.lg-gw.ga

>> Script By GameOvr <<

Contribution :-
	GameOvr : Scripting + minor mappings
	EvilExecutor : LGGW Forum
	Scorpion : Mapping
	Cypress : Host
	
@All Rights Reserved
*/

#include <a_samp>

#define     FIXES_ServerVarMsg      0
#define 	FIXES_Single 			1 
#define 	FIX_OnPlayerSpawn       0

#undef      MAX_PLAYERS
#define     MAX_PLAYERS 			50

#include <a_mysql>
#include <fixes>	
#include <timerfix>
#include <progress2>
#include <playerstats>
#include <playercalls>
#include <playerstates>
#include <streamer>
#include <Pawn.CMD>
#include <foreach> 
#include <YSI\y_classes>
#include <YSI\y_va>
#include <playerzone>
#include <sscanf2>
#include <easyDialog>
#include <strlib> 
#include <OPA>
#include <nex-ac>
#include <weaponconfig>
#include <antiadvertising>
#include <discord-connector>

#define GANGZONE_DEFAULT_BORDER_SIZE 2.0 // default thickness of borders
#define GANGZONE_DEFAULT_NUMBER_SIZE 0.0 // default thickness of numbers 

#include <gangzones>
#include <a_angles>


// 
// ░█▀▀▀█ ░█▀▀▀ ▀▀█▀▀ ▀▀█▀▀ ▀█▀ ░█▄─░█ ░█▀▀█ ░█▀▀▀█ 
// ─▀▀▀▄▄ ░█▀▀▀ ─░█── ─░█── ░█─ ░█░█░█ ░█─▄▄ ─▀▀▀▄▄ 
// ░█▄▄▄█ ░█▄▄▄ ─░█── ─░█── ▄█▄ ░█──▀█ ░█▄▄█ ░█▄▄▄█
	
#define    			    HOSTED_IP               				"127.0.0.1" // MOST IMPORTANT     

#define 				MYSQL_HOST 								"localhost"
#define 				MYSQL_USER 								"root"
#define                 MYSQL_PASS	                            ""
#define                 MYSQL_DATABASE 							"lggw"
//127.0.0.1  
//5.253.86.231

//NzE1MjYxNzcwMDQ1OTgwNzgy.Xs81vA.FITlLRs8YJzfGyNke7ydp9VKATw - Discord BOT TOKEN

/* 
   HOSTED_IP is the IP that the SERVER is hosted
   If somebody steals the AMX and going to host
   in the another SERVER that doesn't match with this  
   IP, server is gonna close automatically...
*/

// #define 				MAX_PLAYERS								50    > Goto the 30th line to edit MAX_PLAYERS (if needed) <
#define         		MAX_GANGS                       		30
#define 				MAX_WARNS								4
#define         		MAX_GANG_MEMBERS                       	20
#define 				MAX_IP_SAVES							20

#define    			    ROCN_PASS               				"LGGW2003123"  //Tip: Name of the SERVER + B'year of the owners + 123
#define 				SCRIPT_VERSION							1.03
#define 				GAMEMODE_TEXT							"LGGW v"#SCRIPT_VERSION": GangWars/TDM/DM"
		
#define     			LOG_ADMINLVLCHANGES      				"/LGGW_Logs/Admin_Level_Changes.lggwlog"
#define     			LOG_ADMINACTIONS         				"/LGGW_Logs/Admin_actions.lggwlog"
#define     			LOG_DISCONNECTS          				"/LGGW_Logs/Player_Disconnects.lggwlog"
#define     			LOG_CONNECTS             				"/LGGW_Logs/Player_Connects.lggwlog"
#define     			LOG_REPORTS              				"/LGGW_Logs/Player_Reports.lggwlog"
#define     			LOG_PASS                 				"/LGGW_Logs/Player_Pass_Changes.lggwlog" 
#define     			LOG_BANS                 				"/LGGW_Logs/Player_Bans.lggwlog"
#define     			LOG_PM                   				"/LGGW_Logs/Player_PM.lggwlog"
#define     			LOG_COMMANDS                   			"/LGGW_Logs/Player_chat.lggwlog"
#define     			LOG_CHAT                  				"/LGGW_Logs/Player_commands.lggwlog"

#define 				TEAM_GROVE    							0
#define 				TEAM_AZTECA   							1
#define 				TEAM_JUSTICE  							2
#define 				TEAM_BALLAS   							3
#define 				TEAM_VAGOS    							4
#define 				TEAM_MAFIA    							5
#define 				TEAM_VIP    							6
#define     			TEAM_ADMIN              				34 //Always use a number greater than MAX_GANGS
		
#define     			COLOR_GROVE                 			0x008000FF
#define     			COLOR_AZTECA                			0x00CED1FF
#define     			COLOR_JUSTICE               			0x0000CCFF
#define     			COLOR_BALLAS                			0x9400D3FF
#define     			COLOR_VAGOS                 			0xFFFF33FF
#define     			COLOR_MAFIA                 			0xAA3333FF
#define     			COLOR_VIP 	                 			0xFF0033FF
#define 				COLOR_ADMIN								0x000000FF
#define     			COLOR_DM                    			0xDB4302FF
#define     			COLOR_DUEL                  			0xFF0000FF
#define                 COLOR_GG								0xFF0000FF
#define 				COLOR_SPEC								0xFFFFFFFF
		
#define     		    MIN_PLAYERS_TO_START_TURF    			3
#define     		    MIN_PLAYERS_TO_START_LMS                4
#define     		    MIN_PLAYERS_TO_START_GUNGAME            4

#define     		    TIME_FOR_TURF               		    30  //seconds
#define     			TIME_FOR_ROB_END       		 			20  //seconds
#define     			TIME_FOR_ROB_REST           			20  //minutes
#define        		    TIME_FOR_TURF_PAYDAY            		12  //minutes
#define            	    TIME_FOR_SPAM_MUTE              		5  //minutes
#define            	    TIME_FOR_ADVERTISE_MUTE              	10  //minutes
#define 				TIME_FOR_LMS_COOLDOWN					20	//minutes
#define 				TIME_FOR_GUNGAME_END					8 // minutes
		
#define     		    GANG_SCORE_PER_TURF         			25  
#define     		    GANG_SCORE_PER_KILL         			8             
		
#define     		    MONEY_PER_LMS_KILL              		775
#define         		MONEY_PER_KILL_IN_RAMPAGE       		50
#define         		MONEY_PER_TURF                 		    215
#define 				MONEY_PER_GUNGAME_LEVEL					275
   
		
#define				    MIN_CASH_TO_CREATE_A_GANG       		200000
#define            	    MIN_CASH_TO_CHANGE_SKIN         		3000
#define         	    MIN_CASH_TO_CHANGE_GANG_COLOR   		50000
#define        			MIN_CASH_TO_USE_MEDKIT         			10000
#define        			MIN_CASH_TO_USE_HOSPITAL         		2000
		
#define            		MIN_SCORE_TO_CREATE_GANG      			500
		
#define            		MIN_SPAM_COUNT          				5
#define         		INT_VW                          		55

#define 				MIN_LAG_SHOT_DIFF						698
#define 				DCC_REPORT_CHANNEL_ID					"705411336389263430"
#define 				DCC_COMMANDS_CHANNEL_ID                 "705110630285180979"
#define 				DCC_CON_DISCON_CHANNEL_ID				"715512961426259968"
#define 				DCC_CHAT_CHANNEL_ID                     "715514258426822736"
#define 				DCC_RCON_CHANNEL_ID                     "716612704277757962"

new AutoC[MAX_PLAYERS];
new AutoC_tick[MAX_PLAYERS];
new spec[MAX_PLAYERS];
new specid[MAX_PLAYERS];

/*  Do not change anything from here */

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
	VIP, 
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
	ptime,

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
	onduty,

	Cache:Player_Cache
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

new
    MySQL: Database, Corrupt_Check[MAX_PLAYERS];

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
forward RandomConnectTD();


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
	{{2104.6030,-1806.4536,13.5547},{372.2772,-132.9766,1001.4922},{374.7301,-119.0155,1001.4995},{372.0168,-131.4597,1001.4922,358.8821},{2102.2542,-1806.9558,13.5547,87.4307},{374.7266,-117.0388,1001.4922,180.2829},155,5,29,"Well Stacked\nPizza"},
	{{1833.0645,-1842.6135,13.5781},{-30.9627,-91.5635,1003.5469},{-28.1096,-89.8219,1003.5469},{-30.9467,-89.6096,1003.5469,0.0000},{1831.3077,-1842.8346,13.5781,90.3946},{-28.4405,-91.6726,1003.5469,0.3945},155,18,17,"24/7"},
	{{1352.3044,-1758.5543,13.5078},{-30.9627,-91.5635,1003.5469},{-28.1096,-89.8219,1003.5469},{-30.9467,-89.6096,1003.5469,0.0000},{1352.8480,-1756.4745,13.5078,356.3977},{-28.4405,-91.6726,1003.5469,0.3945},155,18,17,"24/7"},
	{{1315.5337,-898.3387,39.5781},{-30.9627,-91.5635,1003.5469},{-28.1096,-89.8219,1003.5469},{-30.9467,-89.6096,1003.5469,0.0000},{1315.4900,-900.8430,39.5781,180.0000},{-28.4405,-91.6726,1003.5469,0.3945},155,18,17,"24/7"},
	{{999.9112,-919.9799,42.3281},{-30.9627,-91.5635,1003.5469},{-28.1096,-89.8219,1003.5469},{-30.9467,-89.6096,1003.5469,0.0000},{998.3270,-919.9240,42.1797,97.0000},{-28.4405,-91.6726,1003.5469,0.3945},155,18,17,"24/7"}
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
	"Are_you_new_here?_get_started_with_/help!",
	"Go_and_register_on_our_forums_right_now!.",
	"Join_Us_at_Discord_too.",
	"Shoot_enemies,_kill_them_and_earn_money_to_buy_cool_stuff.",
	"Found_a_cheater/rule_breaker?,_use_/report.",
	"Use_/rules_to_view_server_rules.",
	"Need_money?_You_can_start_turfing_with_"#MIN_PLAYERS_TO_START_TURF"_players_of_your_gang.",
	"Unlock_more_exciting_and_premium_features_by_becoming_a_VIP.",
	"Need_help?_try_/cmds_or_Ask_an_online_admin.",
	"Use_/pm_to_privatly_message_a_player.",
	"Feeling_tired_reading_PMS?,_Use_/blockpm_to_disable_PMs!.",
	"You_can_also_check_your_stats_by_/stats.",
	"Bored_of_playing_TDM,_try_out_our_exclusive_deathmatches_(/dm).",
	"Thank_you_for_playing_and_stay_in_touch_with_us.",
	"Want_buy_powerful_weapons_and_kill_others_without_effort?_Ammunation_is_the_place_for_you."
};
new Float:GGRandoms[][] = 
{
	{1684.6122,1926.1812,11.9844,78.0651},
	{1683.9255,1949.2543,11.9844,98.2167},
	{1596.8834,1915.9469,13.8722,359.6137},
	{1619.1338,1937.7052,13.8722,178.3032},
	{1601.4429,1945.6409,11.0156,86.2900},
	{1620.2445,1953.1869,13.8722,358.4791},
	{1622.7151,1972.2310,13.8722,186.0508},
	{1667.9760,1967.4427,10.8203,98.6217},
	{1644.3765,1913.5028,10.8203,359.6366},
	{1625.4111,1892.3228,10.8203,358.1086},
	{1562.7307,1931.3159,14.5678,275.2638},
	{1568.4476,1890.7869,10.9672,0.4007}
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
new Float:LMS1Randoms[][] = //Jefforson Motel
{
	{2220.8191,-1149.7998,1025.7969,357.4006},   
	{2220.5662,-1150.2167,1025.7969,181.9724},
	{2221.1257,-1149.5125,1025.7969,282.3562},
	{2219.8259,-1149.2054,1025.7969,88.9522},
	{2221.4639,-1149.5211,1025.7969,289.0092},
	{2221.1555,-1151.4945,1025.7969,231.8325},
	{2220.2544,-1150.6908,1025.7969,116.7213},
	{2220.3140,-1148.4087,1025.7969,25.4336},
	{2222.7039,-1149.5896,1025.7969,331.0724},
	{2222.0667,-1150.9814,1025.7969,240.2180},
	{2222.2053,-1149.7941,1025.7969,290.6808}
};
new Float:LMS2Randoms[][] = //RC Battlefield
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
new Float:LMS3Randoms[][] = //Russian Mafia exterior
{
	{2151.4277,-2269.3030,14.4545,223.3617},
	{2149.7722,-2268.7861,14.4545,151.7827}, 
	{2150.7498,-2267.6577,14.4545,325.4647}, 
	{2146.8713,-2264.6030,14.4545,43.4801},
	{2146.7825,-2265.0698,14.4545,141.3733}, 
	{2147.1001,-2265.7156,14.4545,159.5659}, 
	{2148.0139,-2266.7632,14.4545,140.1822}, 
	{2149.2236,-2267.6753,14.4545,138.6661}, 
	{2150.5671,-2267.3408,14.4545,307.4278}, 
	{2149.8706,-2266.6987,14.4545,310.5682}, 
	{2148.8201,-2265.3447,14.4545,321.1805}
};
new Float:LMS4Randoms[][] = //Valle Ocultado
{
	{-844.2441,2754.7317,45.8516,92.3658},
 	{-844.3339,2755.0295,45.8516,348.9340}, 
 	{-843.6850,2755.4983,45.8516,301.1815}, 
 	{-842.7448,2754.9810,45.8516,256.6762}, 
 	{-843.0494,2753.9316,45.8516,198.7048}, 
 	{-844.3807,2754.0374,45.8516,150.3792}, 
 	{-844.6961,2755.3748,45.8516,114.2784}, 
 	{-844.5203,2756.1223,45.8516,95.2729},
 	{-844.9740,2756.0554,45.8516,98.2335},
 	{-845.2258,2755.2573,45.8516,98.2335},
 	{-842.5803,2756.3091,45.8516,278.8333}
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
	TEAM_VAGOS,
	TEAM_VIP
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
new warns[MAX_PLAYERS];
new picked[MAX_PLAYERS];
new nocmd[MAX_PLAYERS];
new frozen[MAX_PLAYERS];
new duelinvited[MAX_PLAYERS];
new duelinviter[MAX_PLAYERS];
new inanim[MAX_PLAYERS];
new induel[MAX_PLAYERS];
new killinginprogress[MAX_PLAYERS];
new indm[MAX_PLAYERS];
new vehowned[MAX_VEHICLES];
new remneons[MAX_PLAYERS];
new logged[MAX_PLAYERS];
new inlms[MAX_PLAYERS];
new grequested[MAX_PLAYERS];
new revenge[MAX_PLAYERS];
new JustRobbed[MAX_ACTORS];
new lockedv_id[7];
new last_weather;
new gg_started;
new lmsstarted;
new lmsjustnow;
new tdlvl;
new egg_timer;
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
new GANG_HOUSE[14];
new PVEH[2];
new gangpick[6];
new pDrunkLevelLast[MAX_PLAYERS];
new pFPS[MAX_PLAYERS];
new af_page[MAX_PLAYERS];
new class_saved[MAX_PLAYERS];
new gg_lvl[MAX_PLAYERS];
new adm_id[MAX_PLAYERS];
new spamcount[MAX_PLAYERS];
new adminveh[MAX_PLAYERS];
new rconattempts[MAX_PLAYERS];
new dstimer[MAX_PLAYERS];
new duelbet[MAX_PLAYERS];
new enemy[MAX_PLAYERS];
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
new Text:statstd;
new Text:LGGW[10];
new Text:vtunetd[3];
new Text:takeovertd[5];
new Text:DM__[2];
new Text:wastedtd[5];
new Text:connecttd[12];

new PlayerText:fplabel_1[MAX_PLAYERS];
new PlayerText:vtunetd_1[MAX_PLAYERS];
new PlayerText:wastedtd_1[MAX_PLAYERS];
new PlayerText:vehtd_1[MAX_PLAYERS];
new PlayerText:turfcashtd[MAX_PLAYERS];
new PlayerText:moneytd_1[MAX_PLAYERS];
new PlayerText:DM_1[MAX_PLAYERS];
new PlayerText:zonetd_1[MAX_PLAYERS][2];
new PlayerText:takeovertd_1[MAX_PLAYERS][3];
new PlayerText:statstd_1[MAX_PLAYERS][6];
new PlayerText:gangtd_1[MAX_PLAYERS][5];

//Main

new DCC_Channel:dcc_channel_reports;
new DCC_Channel:dcc_channel_commands;
new DCC_Channel:dcc_channel_chat;
new DCC_Channel:dcc_channel_con_discon;
new DCC_Channel:dcc_channel_rcon;

main()
{
	print("_________________________________________________________________");
	print("|								|");
	print("|								|");
	print("|		//      ////////  ////////  //       //		|");
	print("|		//	//	  //	    //	    //		|");
	print("|		//	//  ////  //  ////  //	   //		|");
	print("|		//	//    //  //    //  // // // 		|");
	print("|		///////	////////  ////////  /// ///		|");
	print("|								|");
	print("| 								|");
	print("|                                                                |");
	print("| LGGW - Lazer Gaming Gang WarZ                                	|");
	print("| Version - v "#SCRIPT_VERSION"                              	|");
	print("| Forum - https://www.lg-gw.ga                   		|");
	print("|                                                                |");
	print("| >> Script By GameOvr <<                                        |");
	print("|                                                                |");
	print("| Contributors :-                                                |");
	print("| 	GameOvr : Scripting + Mapping                           |");
	print("| 	GREAT_BATTLER : LGGW Forum                              |");
	print("| 	Scorpion : Discord server                               |");
	print("| 	Husam_Haider : Sponsership                              |");
	print("| 	                                                        |");
	print("| @All Rights Reserved                                           |");
	print("|________________________________________________________________|");

	dcc_channel_reports = DCC_FindChannelById(DCC_REPORT_CHANNEL_ID);
	dcc_channel_commands = DCC_FindChannelById(DCC_COMMANDS_CHANNEL_ID);
	dcc_channel_con_discon = DCC_FindChannelById(DCC_CON_DISCON_CHANNEL_ID);
	dcc_channel_chat = DCC_FindChannelById(DCC_CHAT_CHANNEL_ID);
	dcc_channel_rcon = DCC_FindChannelById(DCC_RCON_CHANNEL_ID);
}



//Functions
RetGGWep(playerid)
{
	new str[50];
	if(gg_lvl[playerid] == 1) format(str, sizeof(str), "%s", "Chainsaw");
	if(gg_lvl[playerid] == 2) format(str, sizeof(str), "%s", "Knife");
	if(gg_lvl[playerid] == 3) format(str, sizeof(str), "%s", "AK-47");
	if(gg_lvl[playerid] == 4) format(str, sizeof(str), "%s", "9mm Pistol");
	if(gg_lvl[playerid] == 5) format(str, sizeof(str), "%s", "MP5");
	if(gg_lvl[playerid] == 6) format(str, sizeof(str), "%s", "Country Rifle");
	if(gg_lvl[playerid] == 7) format(str, sizeof(str), "%s", "Spass 12");
	if(gg_lvl[playerid] == 8) format(str, sizeof(str), "%s", "Shotgun");
	if(gg_lvl[playerid] == 9) format(str, sizeof(str), "%s", "Silenced Pistol");
	if(gg_lvl[playerid] == 10) format(str, sizeof(str), "%s", "Deagle");
	if(gg_lvl[playerid] == 11) format(str, sizeof(str), "%s", "RPG");
	if(gg_lvl[playerid] == 12) format(str, sizeof(str), "%s", "Sawn-Off");
	if(gg_lvl[playerid] == 13) format(str, sizeof(str), "%s", "Uzi");
	if(gg_lvl[playerid] == 14) format(str, sizeof(str), "%s", "M4");
	if(gg_lvl[playerid] == 15) format(str, sizeof(str), "%s", "Sniper");
	if(gg_lvl[playerid] == 16) format(str, sizeof(str), "%s", "Grenade");
	if(gg_lvl[playerid] == 17) format(str, sizeof(str), "%s", "Flame Thrower");
	if(gg_lvl[playerid] == 18) format(str, sizeof(str), "%s", "Katana");
	if(gg_lvl[playerid] == 19) format(str, sizeof(str), "%s", "Shovel");
	if(gg_lvl[playerid] >= 20) format(str, sizeof(str), "%s", "Brass Knuckles");
	return str;
}

LoadUserData(playerid)
{
	cache_get_value_int(0, "User_ID", USERINFO[playerid][pid]);
	cache_get_value_int(0, "Level", USERINFO[playerid][plevel]); 
	cache_get_value_int(0, "VIP", USERINFO[playerid][VIP]); 
	cache_get_value_int(0, "Cash", USERINFO[playerid][pcash]); 
	cache_get_value_int(0, "Kills", USERINFO[playerid][pkills]); 
	cache_get_value_int(0, "Deaths", USERINFO[playerid][pdeaths]); 
	cache_get_value_int(0, "Block_PM", USERINFO[playerid][blockpm]); 
	cache_get_value_int(0, "Revenges", USERINFO[playerid][revenges]); 
	cache_get_value_int(0, "Brutal_kills", USERINFO[playerid][bkills]); 
	cache_get_value_int(0, "Highest_rampage", USERINFO[playerid][bramp]); 
	cache_get_value_int(0, "Robberies", USERINFO[playerid][robbs]); 
	cache_get_value_int(0, "Head_shots", USERINFO[playerid][hshots]); 
	cache_get_value_int(0, "Play_time", USERINFO[playerid][ptime]); 

	cache_get_value_int(0, "Duels_played", USERINFO[playerid][dplayed]); 
	cache_get_value_int(0, "Duels_won", USERINFO[playerid][dwon]); 
	cache_get_value_int(0, "Duel_place_ID", USERINFO[playerid][dplace]); 
	cache_get_value_int(0, "Duel_weapon_1", USERINFO[playerid][dwep1]); 
	cache_get_value_int(0, "Duel_weapon_2", USERINFO[playerid][dwep2]); 
	cache_get_value_int(0, "Duel_weapon_3", USERINFO[playerid][dwep3]); 
	cache_get_value_int(0, "Duel_bet", USERINFO[playerid][dbet]); 
	cache_get_value_int(0, "LMS_plalyed", USERINFO[playerid][lmsplayed]); 
	cache_get_value_int(0, "LMS_won", USERINFO[playerid][lmswon]); 
	cache_get_value_int(0, "GunGames_played", USERINFO[playerid][ggp]);  
	cache_get_value_int(0, "GunGames_won", USERINFO[playerid][ggw]);  

	cache_get_value_int(0, "Vehicle_owned", USERINFO[playerid][vowned]); 
	cache_get_value_int(0, "Vehicle_model", USERINFO[playerid][vmodel]); 
	cache_get_value_int(0, "Vehicle_wheel", USERINFO[playerid][vwheel]); 
	cache_get_value_int(0, "Vehicle_color_1", USERINFO[playerid][vcolor_1]); 
	cache_get_value_int(0, "Vehicle_color_2", USERINFO[playerid][vcolor_2]); 
	cache_get_value_int(0, "Vehicle_neon_1", USERINFO[playerid][vneon_1]); 
	cache_get_value_int(0, "Vehicle_neon_2", USERINFO[playerid][vneon_2]); 
	cache_get_value_int(0, "Vehicle_paintjob", USERINFO[playerid][vpjob]); 
	cache_get_value_int(0, "Vehicle_nitro", USERINFO[playerid][vnitro]); 
	cache_get_value_int(0, "Vehicle_hydraulics", USERINFO[playerid][vhydra]); 

	cache_get_value_int(0, "In_gang", USERINFO[playerid][ingang]); 
	cache_get_value_int(0, "Gang_ID", USERINFO[playerid][gid]); 
	cache_get_value_int(0, "Gang_level", USERINFO[playerid][glevel]); 
	cache_get_value_int(0, "Gang_skin", USERINFO[playerid][gskin]); 

	cache_get_value_int(0, "Banned", USERINFO[playerid][banned]); 
	cache_get_value_int(0, "Jailed", USERINFO[playerid][jailed]); 
	cache_get_value_int(0, "Unjail_time", USERINFO[playerid][jailtime]); 
	cache_get_value_int(0, "Muted", USERINFO[playerid][muted]); 
	cache_get_value_int(0, "Unmute_time", USERINFO[playerid][mutetime]);
	return 1;
}

LoadGangData(g_id)
{
	new str[128];
	mysql_format(Database, str, sizeof(str), "SELECT * FROM Gangs WHERE `Gang_ID` = %d LIMIT 1", g_id + 1);
	mysql_tquery(Database, str, "mysql_LoadGangData", "i", g_id);
	return 1;
}

forward mysql_LoadGangData(g_id);
public mysql_LoadGangData(g_id)
{
	cache_get_value_name(0, "Name", GANGINFO[g_id][gname], 30);
	cache_get_value_name(0, "Tag", GANGINFO[g_id][gtag], 6);
	cache_get_value_name(0, "Color", GANGINFO[g_id][gcolor]);
	cache_get_value_name(0, "HQ", GANGINFO[g_id][ghouse]);
	cache_get_value_name(0, "HQ_ID", GANGINFO[g_id][ghouseid]); 
	cache_get_value_name(0, "Kills", GANGINFO[g_id][gkills]); 
	cache_get_value_name(0, "Deaths", GANGINFO[g_id][gdeaths]); 
	cache_get_value_name(0, "Score", GANGINFO[g_id][gscore]); 
	cache_get_value_name(0, "Turfs", GANGINFO[g_id][gturfs]); 
	return 1;
}

LoadHouseData(h_id)
{
	new str[128];
	mysql_format(Database, str, sizeof(str), "SELECT * FROM Houses WHERE `House_ID` = %d LIMIT 1", h_id + 1);
	mysql_tquery(Database, str, "mysql_LoadHouseData", "i", h_id);
	return 1;
}

forward mysql_LoadHouseData(h_id);
public mysql_LoadHouseData(h_id)
{
	cache_get_value_name_int(0, "House_owned", HOUSEINFO[h_id][howned]);
	cache_get_value_name_int(0, "House_owned_team_ID", HOUSEINFO[h_id][hteamid]);
	return 1;
}

LoadZoneData(z_id)
{
	new str[128];
	mysql_format(Database, str, sizeof(str), "SELECT * FROM Zones WHERE `Zone_ID` = %d LIMIT 1", z_id + 1);
	mysql_tquery(Database, str, "mysql_LoadZoneData", "i", z_id);
	return 1;
}

forward mysql_LoadZoneData(z_id);
public mysql_LoadZoneData(z_id)
{
	cache_get_value_name_int(0, "Zone_owned_team_ID", ZONEINFO[z_id][zteamid]);
	return 1;
}

Zone_ColorAlpha(color)
{
	new alpha_col;
	alpha_col = (color - (color & 0x000000FF) + 88);
	return alpha_col;
}


IsValidName(const p_name[]) 
{ 
	for(new i, j = strlen(p_name); i != j; i++) 
	{ 
		switch (p_name[i]) 
		{ 
			case  '0' .. '9', 'A' .. 'Z', 'a' .. 'z', '[', ']', '(', ')', '$', '@', '.', '_', '=': continue; 
			default: return 0; 
		} 
	} 
	return 1; 
}  

IsValidGangNameOrTag(const g_name[]) 
{ 
	for(new i, j = strlen(g_name); i != j; i++) 
	{ 
		switch (g_name[i]) 
		{ 
			case  '0' .. '9', 'A' .. 'Z', 'a' .. 'z': continue; 
			case ' ': continue;
			default: return 0; 
		} 
	} 
	return 1; 
}  

GivePlayerCash(playerid, amount, show = 1)
{
	new mstr[128];
	if(amount >= 0)
	{
		GivePlayerMoney(playerid, amount);
		format(mstr, sizeof(mstr), "~g~+$%d", amount);
	}
	else
	{
		new idx = (0 - amount);
		if(0 > (GetPlayerMoney(playerid) + amount)) GivePlayerMoney(playerid, -GetPlayerMoney(playerid));
		else GivePlayerMoney(playerid, amount); 
		format(mstr, sizeof(mstr), "~r~-$%d", idx);
	}
	USERINFO[playerid][pcash] += amount;
	if(show)
	{
		PlayerTextDrawShow(playerid, moneytd_1[playerid]);
		PlayerTextDrawSetString(playerid, moneytd_1[playerid], mstr); 
		SetTimerEx("CloseMoneyTD", 5000, false, "i", playerid);
	}
	return 1;
}

AntiDeAMX()
{
	new a[][] = 
	{
		"Unarmed (Fist)",
		"Brass K"
	};
	#pragma unused a
}

PreloadActorAnimations(actorid)
{
	for(new i = 0; i < sizeof(s_AnimationLibraries); i ++)
	{
		ApplyActorAnimation(actorid, s_AnimationLibraries[i], "null", 0.0, 0, 0, 0, 0, 0); 
	}
}

PreloadPlayerAnimations(playerid)
{
	for(new i = 0; i < sizeof(s_AnimationLibraries); i ++)
	{
		ApplyAnimation(playerid, s_AnimationLibraries[i], "null", 0.0, 0, 0, 0, 0, 0);
	}
}

ReplaceUwithS(str[])
{
	new s_[128];
	format(s_, 128, "%s", str);
	strreplace(s_, "_", " ");
	return s_;
}

CreateTextDraws()
{
	statstd = TextDrawCreate(323.000000, 165.000000, "_");
	TextDrawFont(statstd, 0);
	TextDrawLetterSize(statstd, 0.583332, 14.350119);
	TextDrawTextSize(statstd, 296.500000, 249.000000);
	TextDrawSetOutline(statstd, 1);
	TextDrawSetShadow(statstd, 0);
	TextDrawAlignment(statstd, 2);
	TextDrawColor(statstd, -1);
	TextDrawBackgroundColor(statstd, 255);
	TextDrawBoxColor(statstd, 135);
	TextDrawUseBox(statstd, 1);
	TextDrawSetProportional(statstd, 1);
	TextDrawSetSelectable(statstd, 0);

	gangtd = TextDrawCreate(75.000000, 201.000000, "_");
	TextDrawFont(gangtd, 1);
	TextDrawLetterSize(gangtd, 0.608333, 6.949990);
	TextDrawTextSize(gangtd, 282.500000, 115.500000);
	TextDrawSetOutline(gangtd, 1);
	TextDrawSetShadow(gangtd, 0);
	TextDrawAlignment(gangtd, 2);
	TextDrawColor(gangtd, -1);
	TextDrawBackgroundColor(gangtd, 255);
	TextDrawBoxColor(gangtd, 135);
	TextDrawUseBox(gangtd, 1);
	TextDrawSetProportional(gangtd, 1);
	TextDrawSetSelectable(gangtd, 0);

	connecttd[0] = TextDrawCreate(320.000000, 329.000000, "_");
	TextDrawFont(connecttd[0], 2);
	TextDrawLetterSize(connecttd[0], 1.191666, 13.050010);
	TextDrawTextSize(connecttd[0], 363.500000, 636.500000);
	TextDrawSetOutline(connecttd[0], 1);
	TextDrawSetShadow(connecttd[0], 0);
	TextDrawAlignment(connecttd[0], 2);
	TextDrawColor(connecttd[0], -1);
	TextDrawBackgroundColor(connecttd[0], 255);
	TextDrawBoxColor(connecttd[0], 135); 
	TextDrawUseBox(connecttd[0], 1);
	TextDrawSetProportional(connecttd[0], 1);
	TextDrawSetSelectable(connecttd[0], 0);
	
	connecttd[1] = TextDrawCreate(320.000000, 0.000000, "_");
	TextDrawFont(connecttd[1], 2);
	TextDrawLetterSize(connecttd[1], 1.191666, 13.050010);
	TextDrawTextSize(connecttd[1], 363.500000, 636.500000);
	TextDrawSetOutline(connecttd[1], 1);
	TextDrawSetShadow(connecttd[1], 0);
	TextDrawAlignment(connecttd[1], 2);
	TextDrawColor(connecttd[1], -1);
	TextDrawBackgroundColor(connecttd[1], 255);
	TextDrawBoxColor(connecttd[1], 135);
	TextDrawUseBox(connecttd[1], 1);
	TextDrawSetProportional(connecttd[1], 1);
	TextDrawSetSelectable(connecttd[1], 0);
	
	new tds_[40];
	new t = random(14);
	format(tds_, sizeof(tds_), "loadsc%d:loadsc%d", t + 1, t + 1);

	connecttd[2] = TextDrawCreate(0.000000, 0.000000, tds_);
	TextDrawFont(connecttd[2], 4);
	TextDrawLetterSize(connecttd[2], 0.600000, 2.000000);
	TextDrawTextSize(connecttd[2], 640.500000, 447.000000);
	TextDrawSetOutline(connecttd[2], 1);
	TextDrawSetShadow(connecttd[2], 0);
	TextDrawAlignment(connecttd[2], 1);
	TextDrawColor(connecttd[2], -1);
	TextDrawBackgroundColor(connecttd[2], 255);
	TextDrawBoxColor(connecttd[2], 50);
	TextDrawUseBox(connecttd[2], 1);
	TextDrawSetProportional(connecttd[2], 1);
	TextDrawSetSelectable(connecttd[2], 0);
	
	connecttd[3] = TextDrawCreate(452.000000, 23.000000, "Lazer_Gaming~n~Gang_WarZ");
	TextDrawFont(connecttd[3], 1);
	TextDrawLetterSize(connecttd[3], 0.679166, 2.599999);
	TextDrawTextSize(connecttd[3], 400.000000, 17.000000);
	TextDrawSetOutline(connecttd[3], 4);
	TextDrawSetShadow(connecttd[3], 0);
	TextDrawAlignment(connecttd[3], 1);
	TextDrawColor(connecttd[3], 9145343);
	TextDrawBackgroundColor(connecttd[3], -1523963137);
	TextDrawBoxColor(connecttd[3], 50);
	TextDrawUseBox(connecttd[3], 0);
	TextDrawSetProportional(connecttd[3], 1);
	TextDrawSetSelectable(connecttd[3], 0);

	connecttd[4] = TextDrawCreate(208.000000, 20.000000, "~g~l_Lazer_l~n~~p~______l_Gaming_l~n~~y~______________l_Gang_l~b~____________________l_WarZ_l");
	TextDrawFont(connecttd[4], 1);
	TextDrawLetterSize(connecttd[4], 0.537500, 2.149991);
	TextDrawTextSize(connecttd[4], 400.000000, 17.000000);
	TextDrawSetOutline(connecttd[4], 0);
	TextDrawSetShadow(connecttd[4], 2);
	TextDrawAlignment(connecttd[4], 1);
	TextDrawColor(connecttd[4], -1);
	TextDrawBackgroundColor(connecttd[4], 255);
	TextDrawBoxColor(connecttd[4], 50);
	TextDrawUseBox(connecttd[4], 0);
	TextDrawSetProportional(connecttd[4], 1);
	TextDrawSetSelectable(connecttd[4], 0);
	
	connecttd[5] = TextDrawCreate(154.000000, 372.000000, "~r~Place_where_the_Next_Gen_Gang_WarZ_begins...");
	TextDrawFont(connecttd[5], 1);
	TextDrawLetterSize(connecttd[5], 0.362499, 1.299998);
	TextDrawTextSize(connecttd[5], 400.000000, 17.000000);
	TextDrawSetOutline(connecttd[5], 3);
	TextDrawSetShadow(connecttd[5], 0);
	TextDrawAlignment(connecttd[5], 1);
	TextDrawColor(connecttd[5], -1);
	TextDrawBackgroundColor(connecttd[5], 255);
	TextDrawBoxColor(connecttd[5], 50);
	TextDrawUseBox(connecttd[5], 0);
	TextDrawSetProportional(connecttd[5], 1);
	TextDrawSetSelectable(connecttd[5], 0);
	
	connecttd[6] = TextDrawCreate(460.000000, -6.000000 + 2, "Preview_Model");
	TextDrawFont(connecttd[6], 5);
	TextDrawLetterSize(connecttd[6], 0.600000, 2.000000);
	TextDrawTextSize(connecttd[6], 103.500000, 105.000000);
	TextDrawSetOutline(connecttd[6], 0);
	TextDrawSetShadow(connecttd[6], 0);
	TextDrawAlignment(connecttd[6], 1);
	TextDrawColor(connecttd[6], -1);
	TextDrawBackgroundColor(connecttd[6], 0);
	TextDrawBoxColor(connecttd[6], 0);
	TextDrawUseBox(connecttd[6], 0);
	TextDrawSetProportional(connecttd[6], 1);
	TextDrawSetSelectable(connecttd[6], 0);
	TextDrawSetPreviewModel(connecttd[6], 106);
	TextDrawSetPreviewRot(connecttd[6], -10.000000, 0.000000, -20.000000, 1.000000);
	TextDrawSetPreviewVehCol(connecttd[6], 1, 1);
	
	connecttd[7] = TextDrawCreate(406.000000, -6.000000 + 2, "Preview_Model");
	TextDrawFont(connecttd[7], 5);
	TextDrawLetterSize(connecttd[7], 0.600000, 2.000000);
	TextDrawTextSize(connecttd[7], 103.500000, 105.000000);
	TextDrawSetOutline(connecttd[7], 0);
	TextDrawSetShadow(connecttd[7], 0);
	TextDrawAlignment(connecttd[7], 1);
	TextDrawColor(connecttd[7], -1);
	TextDrawBackgroundColor(connecttd[7], 0);
	TextDrawBoxColor(connecttd[7], 0);
	TextDrawUseBox(connecttd[7], 0);
	TextDrawSetProportional(connecttd[7], 1);
	TextDrawSetSelectable(connecttd[7], 0);
	TextDrawSetPreviewModel(connecttd[7], 116);
	TextDrawSetPreviewRot(connecttd[7], -10.000000, 0.000000, -20.000000, 1.000000);
	TextDrawSetPreviewVehCol(connecttd[7], 1, 1);
	
	connecttd[8] = TextDrawCreate(517.000000, -6.000000 + 2, "Preview_Model");
	TextDrawFont(connecttd[8], 5);
	TextDrawLetterSize(connecttd[8], 0.600000, 2.000000);
	TextDrawTextSize(connecttd[8], 103.500000, 105.000000);
	TextDrawSetOutline(connecttd[8], 0);
	TextDrawSetShadow(connecttd[8], 0);
	TextDrawAlignment(connecttd[8], 1);
	TextDrawColor(connecttd[8], -1);
	TextDrawBackgroundColor(connecttd[8], 0);
	TextDrawBoxColor(connecttd[8], 0);
	TextDrawUseBox(connecttd[8], 0);
	TextDrawSetProportional(connecttd[8], 1);
	TextDrawSetSelectable(connecttd[8], 0);
	TextDrawSetPreviewModel(connecttd[8], 284);
	TextDrawSetPreviewRot(connecttd[8], -10.000000, 0.000000, -20.000000, 1.000000);
	TextDrawSetPreviewVehCol(connecttd[8], 1, 1);
	
	connecttd[9] = TextDrawCreate(130.000000, -6.000000 + 2, "Preview_Model");
	TextDrawFont(connecttd[9], 5);
	TextDrawLetterSize(connecttd[9], 0.600000, 2.000000);
	TextDrawTextSize(connecttd[9], 103.500000, 105.000000);
	TextDrawSetOutline(connecttd[9], 0);
	TextDrawSetShadow(connecttd[9], 0);
	TextDrawAlignment(connecttd[9], 1);
	TextDrawColor(connecttd[9], -1);
	TextDrawBackgroundColor(connecttd[9], 0);
	TextDrawBoxColor(connecttd[9], 0);
	TextDrawUseBox(connecttd[9], 0);
	TextDrawSetProportional(connecttd[9], 1);
	TextDrawSetSelectable(connecttd[9], 0);
	TextDrawSetPreviewModel(connecttd[9], 103);
	TextDrawSetPreviewRot(connecttd[9], -10.000000, 0.000000, 11.000000, 1.000000);
	TextDrawSetPreviewVehCol(connecttd[9], 1, 1);
	
	connecttd[10] = TextDrawCreate(76.000000, -6.000000 + 2, "Preview_Model");
	TextDrawFont(connecttd[10], 5);
	TextDrawLetterSize(connecttd[10], 0.600000, 2.000000);
	TextDrawTextSize(connecttd[10], 103.500000, 105.000000);
	TextDrawSetOutline(connecttd[10], 0);
	TextDrawSetShadow(connecttd[10], 0);
	TextDrawAlignment(connecttd[10], 1);
	TextDrawColor(connecttd[10], -1);
	TextDrawBackgroundColor(connecttd[10], 0);
	TextDrawBoxColor(connecttd[10], 0);
	TextDrawUseBox(connecttd[10], 0);
	TextDrawSetProportional(connecttd[10], 1);
	TextDrawSetSelectable(connecttd[10], 0);
	TextDrawSetPreviewModel(connecttd[10], 110);
	TextDrawSetPreviewRot(connecttd[10], -10.000000, 0.000000, 11.000000, 1.000000);
	TextDrawSetPreviewVehCol(connecttd[10], 1, 1);
	
	connecttd[11] = TextDrawCreate(24.000000, -6.000000 + 2, "Preview_Model");
	TextDrawFont(connecttd[11], 5);
	TextDrawLetterSize(connecttd[11], 0.600000, 2.000000);
	TextDrawTextSize(connecttd[11], 103.500000, 105.000000);
	TextDrawSetOutline(connecttd[11], 0);
	TextDrawSetShadow(connecttd[11], 0);
	TextDrawAlignment(connecttd[11], 1);
	TextDrawColor(connecttd[11], -1);
	TextDrawBackgroundColor(connecttd[11], 0);
	TextDrawBoxColor(connecttd[11], 0);
	TextDrawUseBox(connecttd[11], 0);
	TextDrawSetProportional(connecttd[11], 1);
	TextDrawSetSelectable(connecttd[11], 0);
	TextDrawSetPreviewModel(connecttd[11], 163);
	TextDrawSetPreviewRot(connecttd[11], -10.000000, 0.000000, 11.000000, 1.000000);
	TextDrawSetPreviewVehCol(connecttd[11], 1, 1);

	LGGW[0] = TextDrawCreate(326.000000, 424.000000, "_");
	TextDrawFont(LGGW[0], 1);
	TextDrawLetterSize(LGGW[0], 0.358332, 2.900002);
	TextDrawTextSize(LGGW[0], 298.500000, 734.500000);
	TextDrawSetOutline(LGGW[0], 0);
	TextDrawSetShadow(LGGW[0], 0);
	TextDrawAlignment(LGGW[0], 2);
	TextDrawColor(LGGW[0], -1);
	TextDrawBackgroundColor(LGGW[0], 255);
	TextDrawBoxColor(LGGW[0], 170);
	TextDrawUseBox(LGGW[0], 1);
	TextDrawSetProportional(LGGW[0], 1);
	TextDrawSetSelectable(LGGW[0], 0);

	LGGW[1] = TextDrawCreate(9.000000, 425.000000, "No_any_player/gang_actions_yet");
	TextDrawFont(LGGW[1], 1);
	TextDrawLetterSize(LGGW[1], 0.179162, 1.199998);
	TextDrawTextSize(LGGW[1], 400.000000, 17.000000);
	TextDrawSetOutline(LGGW[1], 1);
	TextDrawSetShadow(LGGW[1], 0);
	TextDrawAlignment(LGGW[1], 1);
	TextDrawColor(LGGW[1], -1);
	TextDrawBackgroundColor(LGGW[1], 255);
	TextDrawBoxColor(LGGW[1], 50);
	TextDrawUseBox(LGGW[1], 0);
	TextDrawSetProportional(LGGW[1], 1);
	TextDrawSetSelectable(LGGW[1], 0);

	LGGW[2] = TextDrawCreate(314.000000, 433.000000, "Are_you_new_here,_get_started_with_/help!");
	TextDrawFont(LGGW[2], 1);
	TextDrawLetterSize(LGGW[2], 0.170829, 1.350000);
	TextDrawTextSize(LGGW[2], 400.000000, 17.000000);
	TextDrawSetOutline(LGGW[2], 1);
	TextDrawSetShadow(LGGW[2], 0);
	TextDrawAlignment(LGGW[2], 2);
	TextDrawColor(LGGW[2], -1);
	TextDrawBackgroundColor(LGGW[2], 255);
	TextDrawBoxColor(LGGW[2], 50);
	TextDrawUseBox(LGGW[2], 0);
	TextDrawSetProportional(LGGW[2], 1);
	TextDrawSetSelectable(LGGW[2], 0);

	LGGW[3] = TextDrawCreate(596.000000, 380.000000, "~g~Lazer_Gaming~n~~p~Gang_WarZ");
	TextDrawFont(LGGW[3], 1);
	TextDrawLetterSize(LGGW[3], 0.379166, 1.350000);
	TextDrawTextSize(LGGW[3], 400.000000, 17.000000);
	TextDrawSetOutline(LGGW[3], 1);
	TextDrawSetShadow(LGGW[3], 0);
	TextDrawAlignment(LGGW[3], 3);
	TextDrawColor(LGGW[3], -1);
	TextDrawBackgroundColor(LGGW[3], 255);
	TextDrawBoxColor(LGGW[3], 50);
	TextDrawUseBox(LGGW[3], 0);
	TextDrawSetProportional(LGGW[3], 1);
	TextDrawSetSelectable(LGGW[3], 0);

	LGGW[4] = TextDrawCreate(301.000000, 423.000000, "_");
	TextDrawFont(LGGW[4], 1);
	TextDrawLetterSize(LGGW[4], 0.600000, -0.299995);
	TextDrawTextSize(LGGW[4], 294.000000, 681.000000);
	TextDrawSetOutline(LGGW[4], 1);
	TextDrawSetShadow(LGGW[4], 0);
	TextDrawAlignment(LGGW[4], 2);
	TextDrawColor(LGGW[4], -1);
	TextDrawBackgroundColor(LGGW[4], 255);
	TextDrawBoxColor(LGGW[4], -1094795687);
	TextDrawUseBox(LGGW[4], 1);
	TextDrawSetProportional(LGGW[4], 1);
	TextDrawSetSelectable(LGGW[4], 0);

	LGGW[5] = TextDrawCreate(616.000000, 432.000000, "]_www.lg-gw.ga_]");
	TextDrawFont(LGGW[5], 2);
	TextDrawLetterSize(LGGW[5], 0.170833, 0.950000);
	TextDrawTextSize(LGGW[5], 400.000000, 17.000000);
	TextDrawSetOutline(LGGW[5], 1);
	TextDrawSetShadow(LGGW[5], 0);
	TextDrawAlignment(LGGW[5], 3);
	TextDrawColor(LGGW[5], -1);
	TextDrawBackgroundColor(LGGW[5], 255);
	TextDrawBoxColor(LGGW[5], 50);
	TextDrawUseBox(LGGW[5], 0);
	TextDrawSetProportional(LGGW[5], 1);
	TextDrawSetSelectable(LGGW[5], 0);
	
	LGGW[6] = TextDrawCreate(462.000000, 358.000000, "Preview_Model");
	TextDrawFont(LGGW[6], 5);
	TextDrawLetterSize(LGGW[6], 0.600000, 2.000000);
	TextDrawTextSize(LGGW[6], 62.000000, 68.000000);
	TextDrawSetOutline(LGGW[6], 0);
	TextDrawSetShadow(LGGW[6], 0);
	TextDrawAlignment(LGGW[6], 1);
	TextDrawColor(LGGW[6], -1);
	TextDrawBackgroundColor(LGGW[6], 0);
	TextDrawBoxColor(LGGW[6], 0);
	TextDrawUseBox(LGGW[6], 0);
	TextDrawSetProportional(LGGW[6], 1);
	TextDrawSetSelectable(LGGW[6], 0);
	TextDrawSetPreviewModel(LGGW[6], 107);
	TextDrawSetPreviewRot(LGGW[6], -10.000000, 0.000000, 14.000000, 1.000000);
	TextDrawSetPreviewVehCol(LGGW[6], 1, 1);
	
	LGGW[7] = TextDrawCreate(590.000000, 358.000000, "Preview_Model");
	TextDrawFont(LGGW[7], 5);
	TextDrawLetterSize(LGGW[7], 0.600000, 2.000000);
	TextDrawTextSize(LGGW[7], 62.000000, 68.000000);
	TextDrawSetOutline(LGGW[7], 0);
	TextDrawSetShadow(LGGW[7], 0);
	TextDrawAlignment(LGGW[7], 1);
	TextDrawColor(LGGW[7], -1);
	TextDrawBackgroundColor(LGGW[7], 0);
	TextDrawBoxColor(LGGW[7], 0);
	TextDrawUseBox(LGGW[7], 0);
	TextDrawSetProportional(LGGW[7], 1);
	TextDrawSetSelectable(LGGW[7], 0);
	TextDrawSetPreviewModel(LGGW[7], 102);
	TextDrawSetPreviewRot(LGGW[7], -10.000000, 0.000000, -15.000000, 1.000000);
	TextDrawSetPreviewVehCol(LGGW[7], 1, 1);
	
	LGGW[8] = TextDrawCreate(479.000000, 411.000000, "I");
	TextDrawFont(LGGW[8], 1);
	TextDrawLetterSize(LGGW[8], 12.095853, -0.249999);
	TextDrawTextSize(LGGW[8], 400.000000, 17.000000);
	TextDrawSetOutline(LGGW[8], 1);
	TextDrawSetShadow(LGGW[8], 0);
	TextDrawAlignment(LGGW[8], 1);
	TextDrawColor(LGGW[8], 255);
	TextDrawBackgroundColor(LGGW[8], -1);
	TextDrawBoxColor(LGGW[8], 50);
	TextDrawUseBox(LGGW[8], 0);
	TextDrawSetProportional(LGGW[8], 1);
	TextDrawSetSelectable(LGGW[8], 0);

	LGGW[9] = TextDrawCreate(559.000000, 103.000000, "LGGW_~w~v"#SCRIPT_VERSION"");
	TextDrawFont(LGGW[9], 2);
	TextDrawLetterSize(LGGW[9], 0.241666, 1.249999);
	TextDrawTextSize(LGGW[9], 640, 480);
	TextDrawSetOutline(LGGW[9], 0);
	TextDrawSetShadow(LGGW[9], 1);
	TextDrawAlignment(LGGW[9], 1);
	TextDrawColor(LGGW[9], -1962934017);
	TextDrawBackgroundColor(LGGW[9], 255);
	TextDrawBoxColor(LGGW[9], 255);
	TextDrawUseBox(LGGW[9], 1);
	TextDrawSetProportional(LGGW[9], 1);
	TextDrawSetSelectable(LGGW[9], 0);

	vtunetd[0] = TextDrawCreate(60.000000 + 256, 142.000000 + 195, "_");
	TextDrawFont(vtunetd[0], 1);
	TextDrawLetterSize(vtunetd[0], 0.600000, 6.749989);
	TextDrawTextSize(vtunetd[0], 298.500000, 75.000000);
	TextDrawSetOutline(vtunetd[0], 1);
	TextDrawSetShadow(vtunetd[0], 0);
	TextDrawAlignment(vtunetd[0], 2);
	TextDrawColor(vtunetd[0], -1);
	TextDrawBackgroundColor(vtunetd[0], 255);
	TextDrawBoxColor(vtunetd[0], 152);
	TextDrawUseBox(vtunetd[0], 1);
	TextDrawSetProportional(vtunetd[0], 1);
	TextDrawSetSelectable(vtunetd[0], 0);
	
	vtunetd[1] = TextDrawCreate(36.000000 + 256, 181.000000 + 195, "Purchase");
	TextDrawFont(vtunetd[1], 1);
	TextDrawLetterSize(vtunetd[1], 0.312500, 1.550000);
	TextDrawTextSize(vtunetd[1], 82.000000 + 256, 17.000000 + 195);
	TextDrawSetOutline(vtunetd[1], 1);
	TextDrawSetShadow(vtunetd[1], 0);
	TextDrawAlignment(vtunetd[1], 1);
	TextDrawColor(vtunetd[1], -1);
	TextDrawBackgroundColor(vtunetd[1], 255);
	TextDrawBoxColor(vtunetd[1], -1523963137);
	TextDrawUseBox(vtunetd[1], 1);
	TextDrawSetProportional(vtunetd[1], 1);
	TextDrawSetSelectable(vtunetd[1], 1);
	
	vtunetd[2] = TextDrawCreate(34.000000 + 256, 135.000000 + 195, "Tune_Shop");
	TextDrawFont(vtunetd[2], 3);
	TextDrawLetterSize(vtunetd[2], 0.275000, 1.200000);
	TextDrawTextSize(vtunetd[2], 400.000000, 17.000000);
	TextDrawSetOutline(vtunetd[2], 1);
	TextDrawSetShadow(vtunetd[2], 0);
	TextDrawAlignment(vtunetd[2], 1);
	TextDrawColor(vtunetd[2], 9145343);
	TextDrawBackgroundColor(vtunetd[2], 255);
	TextDrawBoxColor(vtunetd[2], 50);
	TextDrawUseBox(vtunetd[2], 0);
	TextDrawSetProportional(vtunetd[2], 1);
	TextDrawSetSelectable(vtunetd[2], 0);

	takeovertd[0] = TextDrawCreate(566.000000, 283.000000, "_");
	TextDrawFont(takeovertd[0], 1);
	TextDrawLetterSize(takeovertd[0], 0.600000, 6.000001);
	TextDrawTextSize(takeovertd[0], 298.500000, 75.000000);
	TextDrawSetOutline(takeovertd[0], 0);
	TextDrawSetShadow(takeovertd[0], 0);
	TextDrawAlignment(takeovertd[0], 2);
	TextDrawColor(takeovertd[0], -1);
	TextDrawBackgroundColor(takeovertd[0], 255);
	TextDrawBoxColor(takeovertd[0], 83);
	TextDrawUseBox(takeovertd[0], 1);
	TextDrawSetProportional(takeovertd[0], 1);
	TextDrawSetSelectable(takeovertd[0], 0);
	
	takeovertd[1] = TextDrawCreate(566.000000, 284.000000, "_");
	TextDrawFont(takeovertd[1], 1);
	TextDrawLetterSize(takeovertd[1], 0.600000, 0.700002);
	TextDrawTextSize(takeovertd[1], 298.500000, 75.000000);
	TextDrawSetOutline(takeovertd[1], 1);
	TextDrawSetShadow(takeovertd[1], 0);
	TextDrawAlignment(takeovertd[1], 2);
	TextDrawColor(takeovertd[1], -1);
	TextDrawBackgroundColor(takeovertd[1], 255);
	TextDrawBoxColor(takeovertd[1], 255);
	TextDrawUseBox(takeovertd[1], 1);
	TextDrawSetProportional(takeovertd[1], 1);
	TextDrawSetSelectable(takeovertd[1], 0);
	
	takeovertd[2] = TextDrawCreate(566.000000, 331.000000, "_");
	TextDrawFont(takeovertd[2], 1);
	TextDrawLetterSize(takeovertd[2], 0.600000, 0.900000);
	TextDrawTextSize(takeovertd[2], 298.500000, 75.000000);
	TextDrawSetOutline(takeovertd[2], 1);
	TextDrawSetShadow(takeovertd[2], 0);
	TextDrawAlignment(takeovertd[2], 2);
	TextDrawColor(takeovertd[2], -1);
	TextDrawBackgroundColor(takeovertd[2], 255);
	TextDrawBoxColor(takeovertd[2], 255);
	TextDrawUseBox(takeovertd[2], 1);
	TextDrawSetProportional(takeovertd[2], 1);
	TextDrawSetSelectable(takeovertd[2], 0);

	takeovertd[3] = TextDrawCreate(527.000000, 277.000000, "turf_progress");
	TextDrawFont(takeovertd[3], 3);
	TextDrawLetterSize(takeovertd[3], 0.199999, 1.199999);
	TextDrawTextSize(takeovertd[3], 400.000000, 17.000000);
	TextDrawSetOutline(takeovertd[3], 1);
	TextDrawSetShadow(takeovertd[3], 0);
	TextDrawAlignment(takeovertd[3], 1);
	TextDrawColor(takeovertd[3], 1097458175);
	TextDrawBackgroundColor(takeovertd[3], 255);
	TextDrawBoxColor(takeovertd[3], 50);
	TextDrawUseBox(takeovertd[3], 0);
	TextDrawSetProportional(takeovertd[3], 1);
	TextDrawSetSelectable(takeovertd[3], 0);

	takeovertd[4] = TextDrawCreate(553.000000, 303.000000, "against");
	TextDrawFont(takeovertd[4], 1);
	TextDrawLetterSize(takeovertd[4], 0.175000, 1.349999);
	TextDrawTextSize(takeovertd[4], 400.000000, 17.000000);
	TextDrawSetOutline(takeovertd[4], 1);
	TextDrawSetShadow(takeovertd[4], 0);
	TextDrawAlignment(takeovertd[4], 1);
	TextDrawColor(takeovertd[4], -1);
	TextDrawBackgroundColor(takeovertd[4], 255);
	TextDrawBoxColor(takeovertd[4], 50);
	TextDrawUseBox(takeovertd[4], 0);
	TextDrawSetProportional(takeovertd[4], 1);
	TextDrawSetSelectable(takeovertd[4], 0);

	zonetd = TextDrawCreate(62.000000, 229.000000, "_"); 
	TextDrawFont(zonetd, 1);
	TextDrawLetterSize(zonetd, 0.450000, 5.849989);
	TextDrawTextSize(zonetd, 298.500000, 99.500000);
	TextDrawSetOutline(zonetd, 1);
	TextDrawSetShadow(zonetd, 0);
	TextDrawAlignment(zonetd, 2);
	TextDrawColor(zonetd, -1);
	TextDrawBackgroundColor(zonetd, 255);
	TextDrawBoxColor(zonetd, 135);
	TextDrawUseBox(zonetd, 1);
	TextDrawSetProportional(zonetd, 1);
	TextDrawSetSelectable(zonetd, 0);

	DM__[0] = TextDrawCreate(581.000000, 341.000000 - 70, "_");
	TextDrawFont(DM__[0], 3);
	TextDrawLetterSize(DM__[0], 0.616666, 5.299993);
	TextDrawTextSize(DM__[0], 297.000000, 77.500000);
	TextDrawSetOutline(DM__[0], 1);
	TextDrawSetShadow(DM__[0], 0);
	TextDrawAlignment(DM__[0], 2);
	TextDrawColor(DM__[0], -1);
	TextDrawBackgroundColor(DM__[0], 255);
	TextDrawBoxColor(DM__[0], 141);
	TextDrawUseBox(DM__[0], 1);
	TextDrawSetProportional(DM__[0], 1);
	TextDrawSetSelectable(DM__[0], 0);

	DM__[1] = TextDrawCreate(553.000000, 331.000000 - 70, "deathmatch");
	TextDrawFont(DM__[1], 3);
	TextDrawLetterSize(DM__[1], 0.262499, 1.450000);
	TextDrawTextSize(DM__[1], 400.000000, 17.000000);
	TextDrawSetOutline(DM__[1], 1);
	TextDrawSetShadow(DM__[1], 0);
	TextDrawAlignment(DM__[1], 1);
	TextDrawColor(DM__[1], -1962934017);
	TextDrawBackgroundColor(DM__[1], 255);
	TextDrawBoxColor(DM__[1], 50);
	TextDrawUseBox(DM__[1], 0);
	TextDrawSetProportional(DM__[1], 1);
	TextDrawSetSelectable(DM__[1], 0);

	wastedtd[0] = TextDrawCreate(-117.333343, -119.192596, "ld_spac:black");
	TextDrawLetterSize(wastedtd[0], 0.000000, 0.000000);
	TextDrawTextSize(wastedtd[0],  914.333129, 783.984985);
	TextDrawAlignment(wastedtd[0], 1);
	TextDrawColor(wastedtd[0], -186);
	TextDrawSetShadow(wastedtd[0], 0);
	TextDrawSetOutline(wastedtd[0], 0);
	TextDrawBackgroundColor(wastedtd[0], 255);
	TextDrawFont(wastedtd[0], 4);
	TextDrawSetProportional(wastedtd[0], 0);
	TextDrawSetShadow(wastedtd[0], 0);

	wastedtd[1] = TextDrawCreate(320.000000, 190.000000, "wasted");
	TextDrawLetterSize(wastedtd[1], 0.730997, 3.043555);
	TextDrawAlignment(wastedtd[1], 2);
	TextDrawColor(wastedtd[1], -76);
	TextDrawSetShadow(wastedtd[1], 0);
	TextDrawSetOutline(wastedtd[1], 0);
	TextDrawBackgroundColor(wastedtd[1], 255);
	TextDrawFont(wastedtd[1], 3);
	TextDrawSetProportional(wastedtd[1], 1);
	TextDrawSetShadow(wastedtd[1], 0);

	wastedtd[2] = TextDrawCreate(-17.666658, 165.300109, "");
	TextDrawLetterSize(wastedtd[2], 0.000000, 0.000000);
	TextDrawTextSize(wastedtd[2], 668.000061, 86.266624);
	TextDrawAlignment(wastedtd[2], 1);
	TextDrawColor(wastedtd[2], 140);
	TextDrawSetShadow(wastedtd[2], 0);
	TextDrawSetOutline(wastedtd[2], 0);
	TextDrawBackgroundColor(wastedtd[2], 0);
	TextDrawFont(wastedtd[2], 5);
	TextDrawSetProportional(wastedtd[2], 0);
	TextDrawSetShadow(wastedtd[2], 0);
	TextDrawSetPreviewModel(wastedtd[2], 19454);
	TextDrawSetPreviewRot(wastedtd[2], 0.000000, 0.000000, 70.000000, 0.375391);

	wastedtd[3] = TextDrawCreate(300.000000, 329.000000, "_");
	TextDrawFont(wastedtd[3], 1);
	TextDrawLetterSize(wastedtd[3], 0.600000, 21.850002);
	TextDrawTextSize(wastedtd[3], 315.500000, 727.500000);
	TextDrawSetOutline(wastedtd[3], 1);
	TextDrawSetShadow(wastedtd[3], 0);
	TextDrawAlignment(wastedtd[3], 2);
	TextDrawColor(wastedtd[3], -1); 
	TextDrawBackgroundColor(wastedtd[3], 255);
	TextDrawBoxColor(wastedtd[3], 255);
	TextDrawUseBox(wastedtd[3], 1);
	TextDrawSetProportional(wastedtd[3], 1);
	TextDrawSetSelectable(wastedtd[3], 0);

	wastedtd[4] = TextDrawCreate(300.000000, -83.000000, "_");
	TextDrawFont(wastedtd[4], 1);
	TextDrawLetterSize(wastedtd[4], 0.600000, 21.850002);
	TextDrawTextSize(wastedtd[4], 315.500000, 727.500000);
	TextDrawSetOutline(wastedtd[4], 1);
	TextDrawSetShadow(wastedtd[4], 0);
	TextDrawAlignment(wastedtd[4], 2);
	TextDrawColor(wastedtd[4], -1);
	TextDrawBackgroundColor(wastedtd[4], 255);
	TextDrawBoxColor(wastedtd[4], 255);
	TextDrawUseBox(wastedtd[4], 1);
	TextDrawSetProportional(wastedtd[4], 1);
	TextDrawSetSelectable(wastedtd[4], 0);
	return 1;
}

CreatePlayerTextDraws(playerid)
{
	gangtd_1[playerid][0] = CreatePlayerTextDraw(playerid, 74.000000, 189.000000, "Name_of_the_gang");
	PlayerTextDrawFont(playerid, gangtd_1[playerid][0], 3);
	PlayerTextDrawLetterSize(playerid, gangtd_1[playerid][0], 0.287500, 1.500000);
	PlayerTextDrawTextSize(playerid, gangtd_1[playerid][0], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, gangtd_1[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, gangtd_1[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, gangtd_1[playerid][0], 2);
	PlayerTextDrawColor(playerid, gangtd_1[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, gangtd_1[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, gangtd_1[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, gangtd_1[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, gangtd_1[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, gangtd_1[playerid][0], 0);

	gangtd_1[playerid][1] = CreatePlayerTextDraw(playerid, 23.000000, 212.000000, "Score:_amount");
	PlayerTextDrawFont(playerid, gangtd_1[playerid][1], 2);
	PlayerTextDrawLetterSize(playerid, gangtd_1[playerid][1], 0.141666, 1.300000);
	PlayerTextDrawTextSize(playerid, gangtd_1[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, gangtd_1[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, gangtd_1[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, gangtd_1[playerid][1], 1);
	PlayerTextDrawColor(playerid, gangtd_1[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, gangtd_1[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, gangtd_1[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, gangtd_1[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, gangtd_1[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, gangtd_1[playerid][1], 0);

	gangtd_1[playerid][2] = CreatePlayerTextDraw(playerid, 23.000000, 228.000000, "Members_online:_amount");
	PlayerTextDrawFont(playerid, gangtd_1[playerid][2], 2);
	PlayerTextDrawLetterSize(playerid, gangtd_1[playerid][2], 0.133333, 1.300000);
	PlayerTextDrawTextSize(playerid, gangtd_1[playerid][2], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, gangtd_1[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, gangtd_1[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, gangtd_1[playerid][2], 1);
	PlayerTextDrawColor(playerid, gangtd_1[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, gangtd_1[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, gangtd_1[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, gangtd_1[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, gangtd_1[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, gangtd_1[playerid][2], 0);

	gangtd_1[playerid][3] = CreatePlayerTextDraw(playerid, 23.000000, 245.000000, "Controlled_turfs:_amount");
	PlayerTextDrawFont(playerid, gangtd_1[playerid][3], 2);
	PlayerTextDrawLetterSize(playerid, gangtd_1[playerid][3], 0.129166, 1.250000);
	PlayerTextDrawTextSize(playerid, gangtd_1[playerid][3], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, gangtd_1[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, gangtd_1[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, gangtd_1[playerid][3], 1);
	PlayerTextDrawColor(playerid, gangtd_1[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, gangtd_1[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, gangtd_1[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, gangtd_1[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, gangtd_1[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, gangtd_1[playerid][3], 0);

	gangtd_1[playerid][4] = CreatePlayerTextDraw(playerid, 320.000000, 122.000000, "~w~] ~g~grove street ~w~]");
	PlayerTextDrawFont(playerid, gangtd_1[playerid][4], 2);
	PlayerTextDrawLetterSize(playerid, gangtd_1[playerid][4], 0.400000, 2.200000);
	PlayerTextDrawTextSize(playerid, gangtd_1[playerid][4], 399.000000, 638.000000);
	PlayerTextDrawSetOutline(playerid, gangtd_1[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, gangtd_1[playerid][4], 4);
	PlayerTextDrawAlignment(playerid, gangtd_1[playerid][4], 2);
	PlayerTextDrawColor(playerid, gangtd_1[playerid][4], 16711935);
	PlayerTextDrawBackgroundColor(playerid, gangtd_1[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, gangtd_1[playerid][4], 175);
	PlayerTextDrawUseBox(playerid, gangtd_1[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, gangtd_1[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, gangtd_1[playerid][4], 0);

	fplabel_1[playerid] = CreatePlayerTextDraw(playerid, 5.000000, 396.000000, "~r~FPS:_~y~fps~n~~r~Ping:_~y~ping");
	PlayerTextDrawFont(playerid, fplabel_1[playerid], 1);
	PlayerTextDrawLetterSize(playerid, fplabel_1[playerid], 0.212500, 1.100000);
	PlayerTextDrawTextSize(playerid, fplabel_1[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, fplabel_1[playerid], 1);
	PlayerTextDrawSetShadow(playerid, fplabel_1[playerid], 0);
	PlayerTextDrawAlignment(playerid, fplabel_1[playerid], 1);
	PlayerTextDrawColor(playerid, fplabel_1[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, fplabel_1[playerid], 255);
	PlayerTextDrawBoxColor(playerid, fplabel_1[playerid], 50);
	PlayerTextDrawUseBox(playerid, fplabel_1[playerid], 0);
	PlayerTextDrawSetProportional(playerid, fplabel_1[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, fplabel_1[playerid], 0);
	
	vtunetd_1[playerid] = CreatePlayerTextDraw(playerid, 56.000000 + 256, 154.000000 + 195, "Item"); 
	PlayerTextDrawFont(playerid, vtunetd_1[playerid], 1);
	PlayerTextDrawLetterSize(playerid, vtunetd_1[playerid], 0.237500, 1.400000);
	PlayerTextDrawTextSize(playerid, vtunetd_1[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, vtunetd_1[playerid], 1);
	PlayerTextDrawSetShadow(playerid, vtunetd_1[playerid], 0);
	PlayerTextDrawAlignment(playerid, vtunetd_1[playerid], 2);
	PlayerTextDrawColor(playerid, vtunetd_1[playerid], -8433409);
	PlayerTextDrawBackgroundColor(playerid, vtunetd_1[playerid], 255);
	PlayerTextDrawBoxColor(playerid, vtunetd_1[playerid], 50);
	PlayerTextDrawUseBox(playerid, vtunetd_1[playerid], 0);
	PlayerTextDrawSetProportional(playerid, vtunetd_1[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, vtunetd_1[playerid], 0); 
	
	DM_1[playerid] = CreatePlayerTextDraw(playerid, 544.000000, 345.000000 - 70, "kills:");
	PlayerTextDrawFont(playerid, DM_1[playerid], 2);
	PlayerTextDrawLetterSize(playerid, DM_1[playerid], 0.179166, 1.200000);
	PlayerTextDrawTextSize(playerid, DM_1[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, DM_1[playerid], 1);
	PlayerTextDrawSetShadow(playerid, DM_1[playerid], 0);
	PlayerTextDrawAlignment(playerid, DM_1[playerid], 1);
	PlayerTextDrawColor(playerid, DM_1[playerid], 852308735);
	PlayerTextDrawBackgroundColor(playerid, DM_1[playerid], 255);
	PlayerTextDrawBoxColor(playerid, DM_1[playerid], 50);
	PlayerTextDrawUseBox(playerid, DM_1[playerid], 0);
	PlayerTextDrawSetProportional(playerid, DM_1[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, DM_1[playerid], 0);

	vehtd_1[playerid] = CreatePlayerTextDraw(playerid, 310.000000, 378.000000, "Vehicle");
	PlayerTextDrawFont(playerid, vehtd_1[playerid], 3);
	PlayerTextDrawLetterSize(playerid, vehtd_1[playerid], 0.637499, 2.199999);
	PlayerTextDrawTextSize(playerid, vehtd_1[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, vehtd_1[playerid], 2);
	PlayerTextDrawSetShadow(playerid, vehtd_1[playerid], 0);
	PlayerTextDrawAlignment(playerid, vehtd_1[playerid], 2);
	PlayerTextDrawColor(playerid, vehtd_1[playerid], 1433087999);
	PlayerTextDrawBackgroundColor(playerid, vehtd_1[playerid], 255);
	PlayerTextDrawBoxColor(playerid, vehtd_1[playerid], 50);
	PlayerTextDrawUseBox(playerid, vehtd_1[playerid], 0);
	PlayerTextDrawSetProportional(playerid, vehtd_1[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, vehtd_1[playerid], 0);

	wastedtd_1[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 215.100479, "Death_Message");
	PlayerTextDrawLetterSize(playerid, wastedtd_1[playerid], 0.352331, 1.583407);
	PlayerTextDrawAlignment(playerid, wastedtd_1[playerid], 2);
	PlayerTextDrawColor(playerid, wastedtd_1[playerid], -2359116);
	PlayerTextDrawSetShadow(playerid, wastedtd_1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, wastedtd_1[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, wastedtd_1[playerid], 255);
	PlayerTextDrawFont(playerid, wastedtd_1[playerid], 1);
	PlayerTextDrawSetProportional(playerid, wastedtd_1[playerid], 1);
	PlayerTextDrawSetShadow(playerid, wastedtd_1[playerid], 0);
	
	zonetd_1[playerid][0] = CreatePlayerTextDraw(playerid, 59.000000, 232.000000, "name");
	PlayerTextDrawFont(playerid, zonetd_1[playerid][0], 2);
	PlayerTextDrawLetterSize(playerid, zonetd_1[playerid][0], 0.208333, 1.300000);
	PlayerTextDrawTextSize(playerid, zonetd_1[playerid][0], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, zonetd_1[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, zonetd_1[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, zonetd_1[playerid][0], 2);
	PlayerTextDrawColor(playerid, zonetd_1[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, zonetd_1[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, zonetd_1[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, zonetd_1[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, zonetd_1[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, zonetd_1[playerid][0], 0);
	
	zonetd_1[playerid][1] = CreatePlayerTextDraw(playerid, 16.000000, 262.000000, "turf_-_gangname");
	PlayerTextDrawFont(playerid, zonetd_1[playerid][1], 2);
	PlayerTextDrawLetterSize(playerid, zonetd_1[playerid][1], 0.179166, 1.250000);
	PlayerTextDrawTextSize(playerid, zonetd_1[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, zonetd_1[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, zonetd_1[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, zonetd_1[playerid][1], 1);
	PlayerTextDrawColor(playerid, zonetd_1[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, zonetd_1[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, zonetd_1[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, zonetd_1[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, zonetd_1[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, zonetd_1[playerid][1], 0);
	
	takeovertd_1[playerid][0] = CreatePlayerTextDraw(playerid, 530.000000, 328.000000, "turf");
	PlayerTextDrawFont(playerid, takeovertd_1[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, takeovertd_1[playerid][0], 0.216667, 1.249999);
	PlayerTextDrawTextSize(playerid, takeovertd_1[playerid][0], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, takeovertd_1[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, takeovertd_1[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, takeovertd_1[playerid][0], 1);
	PlayerTextDrawColor(playerid, takeovertd_1[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, takeovertd_1[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, takeovertd_1[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, takeovertd_1[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, takeovertd_1[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, takeovertd_1[playerid][0], 0);
	
	takeovertd_1[playerid][1] = CreatePlayerTextDraw(playerid, 563.000000, 292.000000, "gang_1");
	PlayerTextDrawFont(playerid, takeovertd_1[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, takeovertd_1[playerid][1], 0.175000, 1.250000);
	PlayerTextDrawTextSize(playerid, takeovertd_1[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, takeovertd_1[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, takeovertd_1[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, takeovertd_1[playerid][1], 2);
	PlayerTextDrawColor(playerid, takeovertd_1[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, takeovertd_1[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, takeovertd_1[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, takeovertd_1[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, takeovertd_1[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, takeovertd_1[playerid][1], 0);
	
	takeovertd_1[playerid][2] = CreatePlayerTextDraw(playerid, 564.000000, 315.000000, "gang_2");
	PlayerTextDrawFont(playerid, takeovertd_1[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, takeovertd_1[playerid][2], 0.187500, 1.300000);
	PlayerTextDrawTextSize(playerid, takeovertd_1[playerid][2], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, takeovertd_1[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, takeovertd_1[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, takeovertd_1[playerid][2], 2);
	PlayerTextDrawColor(playerid, takeovertd_1[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, takeovertd_1[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, takeovertd_1[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, takeovertd_1[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, takeovertd_1[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, takeovertd_1[playerid][2], 0);

	statstd_1[playerid][0] = CreatePlayerTextDraw(playerid, 321.000000, 153.000000, "GameOvr's_Stats");
	PlayerTextDrawFont(playerid, statstd_1[playerid][0], 3);
	PlayerTextDrawLetterSize(playerid, statstd_1[playerid][0], 0.304166, 1.300000);
	PlayerTextDrawTextSize(playerid, statstd_1[playerid][0], 640, 480);
	PlayerTextDrawSetOutline(playerid, statstd_1[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, statstd_1[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, statstd_1[playerid][0], 2);
	PlayerTextDrawColor(playerid, statstd_1[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, statstd_1[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, statstd_1[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, statstd_1[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, statstd_1[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, statstd_1[playerid][0], 0);

	statstd_1[playerid][1] = CreatePlayerTextDraw(playerid, 320.000000, 169.000000, "Hopeless_Fighters~n~[_HLF_[");
	PlayerTextDrawFont(playerid, statstd_1[playerid][1], 2);
	PlayerTextDrawLetterSize(playerid, statstd_1[playerid][1], 0.162500, 1.250000);
	PlayerTextDrawTextSize(playerid, statstd_1[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, statstd_1[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, statstd_1[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, statstd_1[playerid][1], 2);
	PlayerTextDrawColor(playerid, statstd_1[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, statstd_1[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, statstd_1[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, statstd_1[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, statstd_1[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, statstd_1[playerid][1], 0);

	statstd_1[playerid][2] = CreatePlayerTextDraw(playerid, 207.000000, 193.000000, "VIP_status:_VIP_Level_1~n~Kills:_50~n~Deaths:_50~n~Ratio:_50~n~Play_time:_50~n~Income:_500~n~Highest_rampage:_50");
	PlayerTextDrawFont(playerid, statstd_1[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, statstd_1[playerid][2], 0.195833, 1.250000);
	PlayerTextDrawTextSize(playerid, statstd_1[playerid][2], 640, 480);
	PlayerTextDrawSetOutline(playerid, statstd_1[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, statstd_1[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, statstd_1[playerid][2], 1);
	PlayerTextDrawColor(playerid, statstd_1[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, statstd_1[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, statstd_1[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, statstd_1[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, statstd_1[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, statstd_1[playerid][2], 0);

	statstd_1[playerid][3] = CreatePlayerTextDraw(playerid, 365.000000, 193.000000, "VIP_status:_VIP_Level_1~n~Kills:_50~n~Deaths:_50~n~Ratio:_50~n~Play_time:_50~n~Income:_500~n~Highest_rampage:_50");
	PlayerTextDrawFont(playerid, statstd_1[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, statstd_1[playerid][3], 0.195833, 1.250000);
	PlayerTextDrawTextSize(playerid, statstd_1[playerid][3], 640, 480);
	PlayerTextDrawSetOutline(playerid, statstd_1[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, statstd_1[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, statstd_1[playerid][3], 1);
	PlayerTextDrawColor(playerid, statstd_1[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, statstd_1[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, statstd_1[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, statstd_1[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, statstd_1[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, statstd_1[playerid][3], 0);

	statstd_1[playerid][4] = CreatePlayerTextDraw(playerid, 272.000000, 192.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, statstd_1[playerid][4], 5);
	PlayerTextDrawLetterSize(playerid, statstd_1[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, statstd_1[playerid][4], 94.000000, 107.000000);
	PlayerTextDrawSetOutline(playerid, statstd_1[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, statstd_1[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, statstd_1[playerid][4], 1);
	PlayerTextDrawColor(playerid, statstd_1[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, statstd_1[playerid][4], 0);
	PlayerTextDrawBoxColor(playerid, statstd_1[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, statstd_1[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, statstd_1[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, statstd_1[playerid][4], 0);
	PlayerTextDrawSetPreviewModel(playerid, statstd_1[playerid][4], 230);
	PlayerTextDrawSetPreviewRot(playerid, statstd_1[playerid][4], -10.000000, 0.000000, -2.000000, 0.920000);
	PlayerTextDrawSetPreviewVehCol(playerid, statstd_1[playerid][4], 1, 1);

	statstd_1[playerid][5] = CreatePlayerTextDraw(playerid, 278.000000, 298.000000, "Nowy_TextDraw");
	PlayerTextDrawFont(playerid, statstd_1[playerid][5], 5);
	PlayerTextDrawLetterSize(playerid, statstd_1[playerid][5], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, statstd_1[playerid][5], 88.000000, 88.500000);
	PlayerTextDrawSetOutline(playerid, statstd_1[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, statstd_1[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, statstd_1[playerid][5], 2);
	PlayerTextDrawColor(playerid, statstd_1[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, statstd_1[playerid][5], 135);
	PlayerTextDrawBoxColor(playerid, statstd_1[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, statstd_1[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, statstd_1[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, statstd_1[playerid][5], 0);
	PlayerTextDrawSetPreviewModel(playerid, statstd_1[playerid][5], 411);
	PlayerTextDrawSetPreviewRot(playerid, statstd_1[playerid][5], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, statstd_1[playerid][5], 1, 1);

	turfcashtd[playerid] = CreatePlayerTextDraw(playerid, 316.000000, 367.000000, "You have recieved $5000000 by your gang Cuteless_KillerZ_Hopeless_Fighters for controlling 60 turfs over Los Santos");
	PlayerTextDrawFont(playerid, turfcashtd[playerid], 1);
	PlayerTextDrawLetterSize(playerid, turfcashtd[playerid], 0.195830, 1.099994);
	PlayerTextDrawTextSize(playerid, turfcashtd[playerid], 258.000000, 222.500000);
	PlayerTextDrawSetOutline(playerid, turfcashtd[playerid], 1);
	PlayerTextDrawSetShadow(playerid, turfcashtd[playerid], 0);
	PlayerTextDrawAlignment(playerid, turfcashtd[playerid], 2);
	PlayerTextDrawColor(playerid, turfcashtd[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, turfcashtd[playerid], 255);
	PlayerTextDrawBoxColor(playerid, turfcashtd[playerid], 190);
	PlayerTextDrawUseBox(playerid, turfcashtd[playerid], 1);
	PlayerTextDrawSetProportional(playerid, turfcashtd[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, turfcashtd[playerid], 0);

	moneytd_1[playerid] = CreatePlayerTextDraw(playerid, 608.000000, 98.000000, "$cash");
	PlayerTextDrawFont(playerid, moneytd_1[playerid], 3);
	PlayerTextDrawLetterSize(playerid, moneytd_1[playerid], 0.579166, 2.149999);
	PlayerTextDrawTextSize(playerid, moneytd_1[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, moneytd_1[playerid], 2);
	PlayerTextDrawSetShadow(playerid, moneytd_1[playerid], 0);
	PlayerTextDrawAlignment(playerid, moneytd_1[playerid], 3);
	PlayerTextDrawColor(playerid, moneytd_1[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, moneytd_1[playerid], 255);
	PlayerTextDrawBoxColor(playerid, moneytd_1[playerid], 50);
	PlayerTextDrawUseBox(playerid, moneytd_1[playerid], 0);
	PlayerTextDrawSetProportional(playerid, moneytd_1[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, moneytd_1[playerid], 0);
	return 1;
}

CreateVehicles()
{
	AddStaticVehicleEx(487,2050.3052,-1694.4078,17.6442,267.9156,26,3, 60 * 3); //gang Vehicle by BloodHunter_
	AddStaticVehicleEx(555,2066.0356,-1697.7218,13.2310,270.1191,58,1, 60 * 3); 
	AddStaticVehicleEx(510,2070.5134,-1706.4775,13.1552,233.9024,46,46, 60 * 3); 
	AddStaticVehicleEx(463,2070.4846,-1699.4821,13.0875,270.8516,7,7, 60 * 3); 
	AddStaticVehicleEx(461,2070.5112,-1701.3529,13.1299,271.1385,75,1, 60 * 3); 
	AddStaticVehicleEx(429,2073.9705,-1708.6409,13.2288,271.8380,2,1, 60 * 3); 
	AddStaticVehicleEx(402,2071.4927,-1690.4690,13.3825,270.1930,13,13, 60 * 3); 
	AddStaticVehicleEx(487,2047.5197,-1890.1469,20.2500,265.4940,12,39, 60 * 3); 
	AddStaticVehicleEx(510,2048.3240,-1899.7191,13.1552,228.8434,39,39, 60 * 3); 
	AddStaticVehicleEx(424,2052.5286,-1902.8069,13.3272,180.1976,2,2, 60 * 3); 
	AddStaticVehicleEx(429,2050.9807,-1918.1919,13.2266,179.9386,13,13, 60 * 3); 
	AddStaticVehicleEx(461,2062.9211,-1919.2445,13.1224,178.4014,128,255, 60 * 3); 
	AddStaticVehicleEx(468,2062.0320,-1919.1531,13.2163,183.7534,6,6, 60 * 3); 
	AddStaticVehicleEx(461,2060.7820,-1919.0872,13.1357,178.6886,61,1, 60 * 3); 
	AddStaticVehicleEx(497,1552.8933,-1609.9475,13.5585,142.7637,0,1, 60 * 3); 
	AddStaticVehicleEx(487,1150.6158,-2020.3108,69.1972,269.6392,74,35, 60 * 3); 
	AddStaticVehicleEx(487,1150.5963,-2052.8835,69.1915,271.4837,26,14, 60 * 3); 
	AddStaticVehicleEx(555,1261.4601,-2010.0002,59.0622,0.5308,68,1, 60 * 3); 
	AddStaticVehicleEx(555,1252.1614,-803.7568,83.8245,167.6100,58,1, 60 * 3); 
	AddStaticVehicleEx(560,1245.0131,-803.4440,83.8456,168.0584,17,1, 60 * 3); 
	AddStaticVehicleEx(461,1299.0231,-804.2794,83.7300,303.6593,79,1, 60 * 3);
	AddStaticVehicleEx(461,1298.7006,-809.2598,83.7247,302.2619,88,1, 60 * 3); 
	AddStaticVehicleEx(487,1284.2021,-827.8125,83.3906,179.3584,26,57, 60 * 3); 
	AddStaticVehicleEx(487,1304.2423,-1380.1681,13.9091,180.2378,54,29, 60 * 3); 
	AddStaticVehicleEx(555,1329.2079,-1369.3181,13.3651,270.1212,60,1, 60 * 3); 
	AddStaticVehicleEx(439,1325.3503,-1375.9314,13.7338,179.3055,37,78, 60 * 3); 
	AddStaticVehicleEx(402,1318.2467,-1380.4982,13.6553,179.6103,13,13, 60 * 3); 
	AddStaticVehicleEx(429,1313.8585,-1380.6046,13.4061,179.2462,1,2, 60 * 3); 
	AddStaticVehicleEx(461,1314.2023,-1369.4952,13.1570,181.3939,53,1, 60 * 3); 
	AddStaticVehicleEx(461,1317.4529,-1369.3142,13.1681,186.8571,61,1, 60 * 3); 
	AddStaticVehicleEx(439,1295.1191,-1377.3073,13.6817,179.5653,65,79, 60 * 3); 
	AddStaticVehicleEx(510,1304.4141,-1369.7004,13.1734,174.2131,46,46, 60 * 3); 
	AddStaticVehicleEx(429,1101.9417,-1225.7065,15.5034,177.2475,10,10, 60 * 3); 
	AddStaticVehicleEx(402,1086.3585,-1251.5990,15.6588,268.6965,22,22, 60 * 3); 
	AddStaticVehicleEx(424,1092.7089,-1225.1332,15.6003,176.5051,2,2, 60 * 3); 
	AddStaticVehicleEx(536,809.8713,-1388.6364,13.3547,179.8051,26,96, 60 * 3); 
	AddStaticVehicleEx(402,822.6026,-1388.3512,13.4508,179.5506,39,39, 60 * 3); 
	AddStaticVehicleEx(471,819.3466,-1386.6023,13.0845,178.2803,103,111, 60 * 3); 
	AddStaticVehicleEx(461,813.8742,-1387.6547,13.1945,182.5773,88,1, 60 * 3); 
	AddStaticVehicleEx(461,812.4167,-1387.6215,13.1922,171.4878,88,1, 60 * 3); 
	AddStaticVehicleEx(467,1101.4470,-1218.4135,17.5446,358.3337,68,8, 60 * 3); 
	AddStaticVehicleEx(400,1085.2526,-1242.6229,15.9195,269.9104,62,1, 60 * 3); 
	AddStaticVehicleEx(415,844.6416,-1420.4915,12.4747,358.5623,40,1, 60 * 3); 
	AddStaticVehicleEx(560,859.8986,-1420.3416,12.4132,358.6467,33,0, 60 * 3); 
	AddStaticVehicleEx(487,747.8326,-1259.5079,13.8112,270.7998,26,3, 60 * 3); 
	AddStaticVehicleEx(461,726.4941,-1273.9799,13.2339,273.7609,43,1, 60 * 3); 
	AddStaticVehicleEx(461,727.0530,-1278.8939,13.2326,269.6416,43,1, 60 * 3);  
	AddStaticVehicleEx(434,728.4836,-1295.4282,13.5354,269.9404,12,12, 60 * 3);  
	AddStaticVehicleEx(424,728.0316,-1257.3281,13.3349,270.5651,3,2, 60 * 3);  
	AddStaticVehicleEx(560,730.5157,-1265.8954,13.2579,359.7838,37,0, 60 * 3);  
	AddStaticVehicleEx(402,730.1053,-1285.6658,13.3981,181.6057,90,90, 60 * 3);  
	AddStaticVehicleEx(461,2433.1768,-1221.0995,24.8323,147.9305,43,1, 60 * 3);  
	AddStaticVehicleEx(461,2427.8972,-1220.8259,25.0251,139.4601,61,1, 60 * 3);  
	AddStaticVehicleEx(487,2400.2256,-1234.5665,28.5173,184.0050,3,29, 60 * 3);  
	AddStaticVehicleEx(402,2422.9453,-1241.2670,24.0064,180.0479,98,98, 60 * 3);  
	AddStaticVehicleEx(560,2438.7988,-1222.2675,24.7728,180.1222,52,39, 60 * 3);  
	AddStaticVehicleEx(555,2417.5044,-1224.3641,24.6707,353.7825,68,1, 60 * 3);  
	AddStaticVehicleEx(510,2424.2808,-1220.9044,25.0570,168.4189,39,39, 60 * 3); 
	AddStaticVehicleEx(541,1086.3900,-1184.6632,17.9267,269.7681,68,8, 60 * 3);  
	AddStaticVehicleEx(541,1108.2057,-1180.8838,18.4934,270.3571,2,1, 60 * 3); 
	AddStaticVehicleEx(487,1130.2794,-1222.3463,25.5520,358.0731,12,39, 60 * 3); 
	AddStaticVehicleEx(487,1129.7041,-1245.1582,25.5020,359.3068,74,35, 60 * 3); 
	AddStaticVehicleEx(517,2299.5071,-1767.3784,13.4396,359.6973,36,36, 60 * 3); 
	AddStaticVehicleEx(456,1789.4865,-1624.1389,13.6929,272.2005,91,63, 60 * 3); 
	AddStaticVehicleEx(426,1806.4152,-1583.0343,13.2538,310.9771,7,7, 60 * 3); 
	AddStaticVehicleEx(560,1795.8770,-1592.2664,13.2330,128.2097,17,1, 60 * 3); 
	AddStaticVehicleEx(554,1806.1375,-1684.3353,13.6072,270.4196,65,32, 60 * 3); 
	AddStaticVehicleEx(429,1739.9811,-1613.4016,13.2266,359.7740,1,3, 60 * 3); 
	AddStaticVehicleEx(483,1704.3732,-1607.6449,13.5464,0.3948,1,31, 60 * 3); 
	AddStaticVehicleEx(436,1735.3499,-1686.5228,13.2859,271.3087,87,1, 60 * 3); 
	AddStaticVehicleEx(495,1705.2269,-1685.8593,13.8947,91.0344,118,117, 60 * 3); 
	AddStaticVehicleEx(495,1212.2488,-1686.8215,13.8967,180.7296,116,115, 60 * 3); 
	AddStaticVehicleEx(415,1144.4125,-1763.4756,13.4107,0.4871,62,1, 60 * 3); 
	AddStaticVehicleEx(541,1240.6265,-1424.4877,14.0893,343.2572,13,8, 60 * 3); 
	AddStaticVehicleEx(547,1209.5724,-1486.5035,13.2828,90.7557,123,1, 60 * 3); 
	AddStaticVehicleEx(547,1216.3541,-1557.1946,13.2825,179.8785,123,1, 60 * 3); 
	AddStaticVehicleEx(560,1207.7418,-1555.3094,13.2526,180.3390,9,39, 60 * 3); 
	AddStaticVehicleEx(495,613.5044,-1348.5411,14.0268,279.6028,114,108, 60 * 3); 
	AddStaticVehicleEx(489,2419.1597,-1104.7865,40.8763,358.3017,84,110, 60 * 3); 
	AddStaticVehicleEx(439,2425.2356,-1099.8359,41.4993,10.6573,8,17, 60 * 3); 
	AddStaticVehicleEx(429,1728.6591,-1330.4855,13.2655,64.8039,10,10, 60 * 3); 
	AddStaticVehicleEx(429,1501.4850,-1317.9822,13.8033,1.3703,10,10, 60 * 3); 
	AddStaticVehicleEx(426,1524.1987,-1176.8271,23.7998,359.0453,37,37, 60 * 3); 
	AddStaticVehicleEx(413,1496.0942,-1111.8909,24.1354,89.5083,88,1, 60 * 3); 
	AddStaticVehicleEx(567,1434.4799,-1049.9753,23.7002,0.0067,99,81, 60 * 3); 
	AddStaticVehicleEx(567,1298.5533,-1059.6028,29.1408,0.9314,99,81, 60 * 3); 
	AddStaticVehicleEx(560,1313.1495,-1061.2506,28.8948,1.3657,52,39, 60 * 3); 
	AddStaticVehicleEx(560,1287.7843,-1024.1376,31.0602,181.0918,52,39, 60 * 3); 
	AddStaticVehicleEx(415,1249.1212,-1067.8987,28.8492,270.4905,40,1, 60 * 3); 
	AddStaticVehicleEx(415,1254.7151,-1163.5721,23.5997,359.4823,40,1, 60 * 3); 
	AddStaticVehicleEx(573,1245.0701,-1089.2933,26.8140,268.9789,115,43, 60 * 3); 
	AddStaticVehicleEx(579,1236.0890,-1086.2893,29.1000,271.0203,42,42, 60 * 3); 
	AddStaticVehicleEx(560,1212.2505,-1128.7396,23.7710,182.7382,37,0, 60 * 3); 
	AddStaticVehicleEx(560,1096.7997,-1083.0996,26.3226,88.7909,37,0, 60 * 3); 
	AddStaticVehicleEx(542,1195.0801,-1019.9775,32.2902,184.1564,119,113, 60 * 3); 
	AddStaticVehicleEx(542,1248.4432,-972.7236,39.9460,268.2815,119,113, 60 * 3); 
	AddStaticVehicleEx(448,1191.1658,-917.7927,42.8075,193.3018,3,6, 60 * 3); 
	AddStaticVehicleEx(448,1189.9120,-918.6534,42.8226,197.3931,3,6, 60 * 3); 
	AddStaticVehicleEx(561,1320.4679,-1077.0453,28.9932,270.1606,8,17, 60 * 3); 
	AddStaticVehicleEx(561,1320.4288,-1164.2310,23.6419,3.0547,8,17, 60 * 3); 
	AddStaticVehicleEx(400,1391.1647,-1167.4142,23.9127,358.3529,36,1, 60 * 3); 
	AddStaticVehicleEx(400,1425.7166,-1145.9573,23.9732,177.9815,36,1, 60 * 3); 
	AddStaticVehicleEx(409,1276.1406,-1370.8835,13.0570,180.4902,1,1, 60 * 3); 
	AddStaticVehicleEx(402,1276.6010,-1322.6477,13.1700,359.0474,22,22, 60 * 3); 
	AddStaticVehicleEx(402,1276.9452,-1302.3647,13.1560,359.1013,22,22, 60 * 3); 
	AddStaticVehicleEx(416,1177.3871,-1308.1705,14.0189,269.7366,1,3, 60 * 3); 
	AddStaticVehicleEx(416,1178.0341,-1338.2245,14.0271,272.5762,1,3, 60 * 3); 
	AddStaticVehicleEx(541,1219.7743,-1424.3719,12.9452,0.3415,36,8, 60 * 3); 
	AddStaticVehicleEx(467,785.2601,-1800.5122,12.7634,356.6745,58,8, 60 * 3); 
	AddStaticVehicleEx(475,1210.8298,-1486.1558,13.3504,90.9611,37,0, 60 * 3); 
	AddStaticVehicleEx(449,2284.8750,-1133.2894,27.2674,180.0000,1,74, 60 * 3); 
	AddStaticVehicleEx(449,1688.0338,-1953.6306,13.9973,270.0359,1,74, 60 * 3); 
	AddStaticVehicleEx(535,2498.5098,-2022.1201,13.3099,0.2961,28,1, 60 * 3); 
	AddStaticVehicleEx(535,2158.5457,-1794.9449,13.1239,271.7294,31,1, 60 * 3); 
	AddStaticVehicleEx(477,2158.7534,-1805.6167,13.1326,273.3397,94,1, 60 * 3); 
	AddStaticVehicleEx(474,2249.9731,-1908.8552,13.3097,0.1644,84,1, 60 * 3); 
	AddStaticVehicleEx(474,2273.1030,-1907.6173,13.3082,359.1305,84,1, 60 * 3); 
	AddStaticVehicleEx(470,1949.3920,-1873.0367,13.5553,0.4738,43,0, 60 * 3); 
	AddStaticVehicleEx(560,1672.5359,-1750.1141,13.2508,359.5661,9,39, 60 * 3); 
	AddStaticVehicleEx(560,1375.1896,-1822.1531,13.2680,268.4660,9,39, 60 * 3); 
	AddStaticVehicleEx(565,1404.5232,-1838.8760,13.1719,89.2787,42,42, 60 * 3); 
	AddStaticVehicleEx(579,1368.0479,-1885.3054,13.4577,0.6806,42,42, 60 * 3); 
	AddStaticVehicleEx(491,1311.1588,-1485.7760,13.3031,269.5330,30,72, 60 * 3); 
	AddStaticVehicleEx(489,1360.6267,-1488.9408,13.6887,68.4406,76,102, 60 * 3);


	lockedv_id[0] = AddStaticVehicleEx(541,1683.3878,-1466.9287,14.0107,294.4879,60,1, 60 * 3); //
	lockedv_id[1] = AddStaticVehicleEx(411,1671.3521,-1456.5626,13.3211,0.9845,12,1, 60 * 3); //
	lockedv_id[2] = AddStaticVehicleEx(415,1675.7317,-1456.4467,13.3660,0.3479,75,1, 60 * 3); //
	lockedv_id[3] = AddStaticVehicleEx(557,1691.9600,-1453.1942,14.2039,90.3203,1,1, 60 * 3); //
	lockedv_id[4] = AddStaticVehicleEx(451,1680.9901,-1458.2240,13.2984,0.5611,75,75, 60 * 3); //
	lockedv_id[5] = AddStaticVehicleEx(506,1686.5209,-1457.8973,13.2985,359.4959,7,7, 60 * 3); //
	lockedv_id[6] = AddStaticVehicleEx(495,1693.0632,-1458.0544,13.9486,90.2793,88,99, 60 * 3); //

	AddStaticVehicleEx(429,1655.9208000,1642.3665000,10.5006000,180.7649000,14,14,60 * 3); //Banshee
	AddStaticVehicleEx(411,1660.2482000,1642.7637000,10.5479000,182.6514000,116,1,60 * 3); //Infernus
	AddStaticVehicleEx(411,1664.6333000,1642.7318000,10.5471000,183.7029000,123,1,60 * 3); //Infernus
	AddStaticVehicleEx(411,1669.0636000,1643.2683000,10.5474000,183.8507000,106,1,60 * 3); //Infernus
	AddStaticVehicleEx(411,1673.5128000,1643.3058000,10.5377000,178.4510000,112,1,60 * 3); //Infernus
	AddStaticVehicleEx(411,1677.5502000,1643.2028000,10.5339000,175.3664000,123,1,60 * 3); //Infernus
	AddStaticVehicleEx(429,1681.9150000,1642.7546000,10.4869000,176.6382000,1,3,60 * 3); //Banshee
	AddStaticVehicleEx(429,1685.9857000,1642.4720000,10.5000000,178.6411000,2,1,60 * 3); //Banshee
	AddStaticVehicleEx(429,1690.1969000,1642.4861000,10.5007000,181.9761000,3,1,60 * 3); //Banshee
	AddStaticVehicleEx(429,1694.3719000,1642.2825000,10.4983000,179.3228000,10,10,60 * 3); //Banshee
	AddStaticVehicleEx(429,1698.7502000,1642.4268000,10.4362000,180.2960000,1,2,60 * 3); //Banshee
	AddStaticVehicleEx(429,1655.7488000,1633.2616000,10.5005000,179.5339000,12,12,60 * 3); //Banshee
	AddStaticVehicleEx(415,1660.6801000,1633.1615000,10.5924000,180.5180000,36,1,60 * 3); //Cheetah
	AddStaticVehicleEx(541,1664.8441000,1632.9302000,10.4375000,178.3520000,58,8,60 * 3); //Bullet
	AddStaticVehicleEx(541,1669.3906000,1632.5950000,10.4458000,181.8489000,36,8,60 * 3); //Bullet
	AddStaticVehicleEx(541,1672.9016000,1632.5107000,10.4457000,181.0729000,51,1,60 * 3); //Bullet
	AddStaticVehicleEx(541,1676.8007000,1632.3711000,10.4458000,179.0332000,60,1,60 * 3); //Bullet
	AddStaticVehicleEx(415,1680.9681000,1632.5798000,10.5925000,173.4881000,75,1,60 * 3); //Cheetah
	AddStaticVehicleEx(415,1685.2404000,1632.0709000,10.5933000,173.1798000,40,1,60 * 3); //Cheetah
	AddStaticVehicleEx(415,1689.9032000,1631.6860000,10.5921000,176.6379000,62,1,60 * 3); //Cheetah
	AddStaticVehicleEx(415,1694.2104000,1631.3993000,10.5927000,177.2358000,92,1,60 * 3); //Cheetah
	AddStaticVehicleEx(415,1698.5383000,1631.2443000,10.5369000,176.2140000,-1,1,60 * 3); //Cheetah
	AddStaticVehicleEx(522,1697.9119000,1593.7115000,10.2973000,82.7232000,39,106,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1697.9391000,1591.3123000,10.2952000,87.1416000,51,118,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1697.8402000,1588.5409000,10.2997000,87.0222000,3,3,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1697.5122000,1585.1505000,10.3454000,85.7465000,8,82,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1697.8799000,1582.5188000,10.3719000,87.1286000,51,118,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1693.0145000,1582.2963000,10.3899000,94.2703000,3,3,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1692.5485000,1585.4117000,10.3930000,87.1239000,36,105,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1692.7688000,1588.7714000,10.3886000,86.7768000,7,79,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1692.8180000,1591.5223000,10.3865000,85.9074000,3,8,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1693.0026000,1594.0889000,10.3905000,82.9544000,6,25,60 * 3); //NRG-500
	AddStaticVehicleEx(487,1619.6760000,1548.5018000,10.9799000,16.1459000,3,29,60 * 3); //Maverick
	AddStaticVehicleEx(487,1631.2566000,1549.7717000,10.9810000,9.9061000,12,39,60 * 3); //Maverick
	AddStaticVehicleEx(487,1641.4315000,1550.4819000,10.9802000,11.1811000,26,3,60 * 3); //Maverick
	AddStaticVehicleEx(487,1655.6323000,1551.5857000,10.9676000,9.2740000,54,29,60 * 3); //Maverick
	AddStaticVehicleEx(560,1284.2753000,1377.5320000,10.5268000,273.2056000,37,-1,60 * 3); //Sultan
	AddStaticVehicleEx(560,1283.7607000,1383.2258000,10.5273000,274.1044000,41,29,60 * 3); //Sultan
	AddStaticVehicleEx(560,1283.3611000,1388.7393000,10.5258000,274.6066000,56,29,60 * 3); //Sultan
	AddStaticVehicleEx(461,1283.3011000,1393.2603000,10.3879000,274.2324000,36,1,60 * 3); //PCJ-600
	AddStaticVehicleEx(461,1283.1737000,1395.2871000,10.4021000,273.6257000,37,1,60 * 3); //PCJ-600
	AddStaticVehicleEx(522,1339.1959000,1740.3950000,10.3945000,265.9358000,8,82,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1339.4606000,1737.2952000,10.3940000,268.0981000,7,79,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1339.3619000,1734.3013000,10.3816000,271.5591000,36,105,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1339.3208000,1730.7899000,10.3873000,272.5353000,39,106,60 * 3); //NRG-500
	AddStaticVehicleEx(429,1301.5032000,1814.4768000,164.5489000,178.3633000,14,14,60 * 3); //Banshee
	AddStaticVehicleEx(429,1307.1051000,1814.5065000,164.5486000,179.3540000,1,2,60 * 3); //Banshee
	AddStaticVehicleEx(429,1312.2147000,1814.6180000,164.5487000,179.2378000,13,13,60 * 3); //Banshee
	AddStaticVehicleEx(541,1317.5325000,1814.7063000,164.4942000,179.1380000,68,8,60 * 3); //Bullet
	AddStaticVehicleEx(541,1322.4954000,1814.8119000,164.4943000,181.5038000,60,1,60 * 3); //Bullet
	AddStaticVehicleEx(541,1327.2260000,1815.1117000,164.4946000,179.7712000,58,8,60 * 3); //Bullet
	AddStaticVehicleEx(468,1344.6868000,1813.4519000,164.5026000,174.0581000,53,53,60 * 3); //Sanchez
	AddStaticVehicleEx(468,1344.6267000,1818.3899000,164.5358000,181.0209000,3,3,60 * 3); //Sanchez
	AddStaticVehicleEx(468,1344.5162000,1824.5908000,164.5360000,174.8425000,46,46,60 * 3); //Sanchez
	AddStaticVehicleEx(468,1349.4957000,1824.5369000,164.5363000,178.0057000,6,6,60 * 3); //Sanchez
	AddStaticVehicleEx(468,1349.2789000,1819.1287000,164.5365000,177.5958000,46,46,60 * 3); //Sanchez
	AddStaticVehicleEx(468,1349.3748000,1813.4135000,164.5373000,178.1345000,6,6,60 * 3); //Sanchez
	AddStaticVehicleEx(522,1354.2587000,1812.9691000,164.4326000,167.2118000,51,118,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1354.4315000,1818.6985000,164.4373000,186.1605000,3,3,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1354.5636000,1823.8934000,164.4376000,181.0670000,7,79,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1357.6964000,1823.8452000,164.4374000,183.2559000,6,25,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1360.8447000,1823.9532000,164.4371000,180.9702000,3,8,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1360.9888000,1818.9830000,164.4377000,181.5969000,36,105,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1357.8497000,1818.8241000,164.4368000,183.9656000,39,106,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1360.9384000,1813.0028000,164.4380000,183.0402000,7,79,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1357.2985000,1812.9642000,164.4293000,186.1985000,8,82,60 * 3); //NRG-500
	AddStaticVehicleEx(487,1300.5432000,1791.7111000,165.0438000,172.5888000,12,39,60 * 3); //Maverick
	AddStaticVehicleEx(487,1290.1729000,1791.6967000,165.0452000,177.3074000,3,29,60 * 3); //Maverick
	AddStaticVehicleEx(522,1489.0012000,2167.4763000,193.2821000,179.4562000,8,82,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1488.8512000,2175.4539000,193.4410000,179.8461000,3,8,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1483.9684000,2167.5076000,193.2347000,178.8230000,6,25,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1483.8577000,2175.3953000,193.3869000,178.1291000,3,3,60 * 3); //NRG-500
	AddStaticVehicleEx(468,1478.7694000,2167.5520000,193.2784000,179.5557000,6,6,60 * 3); //Sanchez
	AddStaticVehicleEx(468,1478.5626000,2175.6736000,193.4312000,178.1458000,46,46,60 * 3); //Sanchez
	AddStaticVehicleEx(468,1473.6232000,2167.5066000,193.2195000,175.2520000,53,53,60 * 3); //Sanchez
	AddStaticVehicleEx(468,1473.6246000,2175.5425000,193.3729000,179.6709000,3,3,60 * 3); //Sanchez
	AddStaticVehicleEx(411,1464.5854000,2168.9409000,193.2056000,182.7867000,123,1,60 * 3); //Infernus
	AddStaticVehicleEx(411,1458.0469000,2168.7014000,193.1298000,179.4131000,64,1,60 * 3); //Infernus
	AddStaticVehicleEx(541,1449.6879000,2168.0703000,192.9129000,180.6783000,51,1,60 * 3); //Bullet
	AddStaticVehicleEx(541,1442.8586000,2168.2356000,192.8446000,181.3883000,36,8,60 * 3); //Bullet
	AddStaticVehicleEx(560,1442.7740000,2177.8298000,193.1056000,182.6749000,56,29,60 * 3); //Sultan
	AddStaticVehicleEx(560,1450.2139000,2178.9783000,193.2122000,180.7835000,41,29,60 * 3); //Sultan
	AddStaticVehicleEx(560,1454.5231000,2178.9143000,193.2550000,180.3447000,37,-1,60 * 3); //Sultan
	AddStaticVehicleEx(409,1461.6187000,2179.8496000,193.4528000,269.4276000,1,1,60 * 3); //Stretch
	AddStaticVehicleEx(411,1738.9934000,-765.9148000,795.3682000,92.0994000,112,1,60 * 3); //Infernus
	AddStaticVehicleEx(411,1739.0957000,-759.4797000,795.3682000,91.5744000,3,3,60 * 3); //Infernus
	AddStaticVehicleEx(541,1739.1307000,-746.4301000,795.2669000,88.5604000,3,3,60 * 3); //Bullet
	AddStaticVehicleEx(541,1738.7797000,-741.8997000,795.2648000,89.8365000,60,1,60 * 3); //Bullet
	AddStaticVehicleEx(560,1738.7678000,-728.6745000,795.3611000,85.5824000,1,1,60 * 3); //Sultan
	AddStaticVehicleEx(560,1739.1310000,-723.3232000,795.3463000,86.5612000,3,3,60 * 3); //Sultan
	AddStaticVehicleEx(429,1738.9084000,-711.1821000,795.3206000,88.9755000,3,3,60 * 3); //Banshee
	AddStaticVehicleEx(429,1739.2667000,-704.0451000,795.3207000,86.8668000,1,1,60 * 3); //Banshee
	AddStaticVehicleEx(561,1738.1525000,-692.8290000,795.4558000,87.2641000,43,21,60 * 3); //Stratum
	AddStaticVehicleEx(561,1737.9772000,-686.3063000,795.4542000,89.2677000,1,1,60 * 3); //Stratum
	AddStaticVehicleEx(559,1738.4734000,-674.4963000,795.3284000,90.8322000,60,1,60 * 3); //Jester
	AddStaticVehicleEx(559,1738.8090000,-667.7557000,795.3277000,88.7671000,58,8,60 * 3); //Jester
	AddStaticVehicleEx(558,1738.4583000,-656.3011000,795.2728000,90.6715000,1,1,60 * 3); //Uranus
	AddStaticVehicleEx(558,1738.6346000,-649.4459000,795.2830000,88.0161000,3,3,60 * 3); //Uranus
	AddStaticVehicleEx(415,1738.6415000,-638.0726000,795.4139000,86.9129000,1,1,60 * 3); //Cheetah
	AddStaticVehicleEx(415,1739.1042000,-631.2102000,795.4127000,89.3708000,3,3,60 * 3); //Cheetah
	AddStaticVehicleEx(522,1664.7966000,-747.2823000,795.1541000,266.1894000,1,1,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1664.9058000,-739.4644000,795.1823000,268.3190000,3,3,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1665.0770000,-729.0731000,795.2087000,256.8934000,1,1,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1665.6235000,-721.7543000,795.2122000,263.6300000,3,3,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1665.6309000,-710.3435000,795.2139000,271.2437000,1,1,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1665.7499000,-704.0633000,795.2142000,263.4637000,3,3,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1665.8054000,-692.8148000,795.2167000,273.7361000,1,1,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1665.2697000,-684.6215000,795.2216000,267.2160000,3,3,60 * 3); //NRG-500
	AddStaticVehicleEx(463,1665.3372000,-675.1737000,795.1816000,269.6362000,1,1,60 * 3); //Freeway
	AddStaticVehicleEx(463,1665.5187000,-666.3317000,795.1791000,266.0754000,3,3,60 * 3); //Freeway
	AddStaticVehicleEx(463,1665.3621000,-656.5930000,795.1037000,273.1395000,1,1,60 * 3); //Freeway
	AddStaticVehicleEx(463,1665.2748000,-648.0149000,795.1834000,264.8587000,3,3,60 * 3); //Freeway
	AddStaticVehicleEx(468,1665.1090000,-630.1891000,795.3170000,265.1226000,3,3,60 * 3); //Sanchez
	AddStaticVehicleEx(468,1665.1331000,-638.8880000,795.3087000,268.3611000,3,3,60 * 3); //Sanchez
	AddStaticVehicleEx(437,1703.1519000,-600.8555000,795.7788000,230.7238000,87,7,60 * 3); //Coach
	AddStaticVehicleEx(437,1680.9720000,-601.5411000,795.7779000,224.6074000,79,7,60 * 3); //Coach
	AddStaticVehicleEx(437,1727.1329000,-600.2183000,795.7747000,229.8087000,95,16,60 * 3); //Coach

    AddStaticVehicleEx(415,1280.1957,-830.7766,82.9129,359.8688,11,11, 60 * 3); // Ownage's Cheetah
	AddStaticVehicleEx(494,1276.4733,-830.0457,83.0365,359.5997,0,2, 60 * 3); // Ownage's Hotring
	AddStaticVehicleEx(411,1272.4432,-830.4450,82.8681,359.3767,3,3, 60 * 3); // Ownage's Infernus
    AddStaticVehicleEx(402,300.1478,-1332.6942,53.2755,34.7745,5,5, 60 * 3); // [eVo]Torch's Buffalo
	AddStaticVehicleEx(451,292.9796,-1338.6676,53.1471,37.0175,5,5, 60 * 3); // [eVo]Torch's Turismo
	AddStaticVehicleEx(522,1377.9468,-1101.4674,23.9848,93.6276,5,1, 60 * 3); // BlazeRay_ NRG [Second Donation]
	AddStaticVehicleEx(480,1377.3156,-1096.4209,24.8927,93.1781,5,1, 60 * 3); // BlazeRay_ Comet [Second Donation]
	AddStaticVehicleEx(571,1376.6814,-1103.6816,23.6961,89.3723,0,0, 60 * 3); // BlazeRay_ Kart [Pending Veh]

	AddStaticVehicleEx(522,1244.6918000,-2044.6211000,59.4263000,268.6664000,0,0,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1244.5231000,-2043.4037000,59.4366000,273.6889000,0,0,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1244.3361000,-2042.3900000,59.4440000,270.8987000,3,0,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1244.3835000,-2041.4050000,59.4464000,275.0805000,3,0,60 * 3); //NRG-500
	AddStaticVehicleEx(560,1245.0376000,-2030.3622000,59.5540000,300.9092000,1,0,60 * 3); //Sultan
	AddStaticVehicleEx(560,1245.5114000,-2025.8401000,59.5426000,300.5261000,0,0,60 * 3); //Sultan
	AddStaticVehicleEx(560,1245.3755000,-2021.6290000,59.5488000,299.3607000,1,0,60 * 3); //Sultan
	AddStaticVehicleEx(560,1245.0406000,-2017.5251000,59.5589000,295.7648000,0,0,60 * 3); //Sultan
	AddStaticVehicleEx(490,1277.3075000,-2012.3669000,59.0608000,89.6596000,0,0,60 * 3); //FBI Rancher
	AddStaticVehicleEx(490,1277.3374000,-2019.0785000,59.0563000,91.0054000,0,0,60 * 3); //FBI Rancher
	AddStaticVehicleEx(488,1263.6011000,-2009.6555000,59.5319000,174.5145000,0,0,60 * 3); //News Chopper
	AddStaticVehicleEx(541,1277.3774000,-2044.3832000,58.6292000,50.4201000,3,0,60 * 3); //Bullet
	AddStaticVehicleEx(541,1278.1311000,-2039.6671000,58.6897000,43.1249000,0,0,60 * 3); //Bullet
	AddStaticVehicleEx(541,1277.7059000,-2035.2888000,58.5913000,47.1151000,1,0,60 * 3); //Bullet
	AddStaticVehicleEx(598,1277.4059000,-2029.5911000,58.7216000,91.1525000,0,1,60 * 3); //Police Car (LVPD)
	AddStaticVehicleEx(598,1277.4412000,-2024.6464000,58.6907000,89.3874000,0,1,60 * 3); //Police Car (LVPD)
	AddStaticVehicleEx(481,2440.7151000,-1581.7744000,24.0776000,179.5349000,3,3,60 * 3); //BMX
	AddStaticVehicleEx(481,2420.9880000,-1579.1620000,23.8850000,179.1077000,12,9,60 * 3); //BMX
	AddStaticVehicleEx(560,2447.0720000,-1556.7079000,23.7091000,0.2415000,234,0,60 * 3); //Sultan
	AddStaticVehicleEx(461,2393.2451000,-1681.5518000,14.2479000,358.9532000,43,1,60 * 3); //PCJ-600
	AddStaticVehicleEx(481,2182.7598000,-1665.0269000,14.2832000,306.6104000,46,46,60 * 3); //BMX
	AddStaticVehicleEx(481,2182.5144000,-1666.9778000,14.2028000,296.2337000,6,6,60 * 3); //BMX
	AddStaticVehicleEx(481,2182.2595000,-1668.8175000,14.1226000,300.0238000,3,3,60 * 3); //BMX
	AddStaticVehicleEx(481,2181.6833000,-1670.4454000,14.0187000,285.7150000,26,1,60 * 3); //BMX
	AddStaticVehicleEx(481,2181.4553000,-1672.8750000,13.9097000,291.3530000,1,1,60 * 3); //BMX
	AddStaticVehicleEx(492,2491.5715000,-1655.8092000,13.1920000,91.3697000,234,0,60 * 3); //Greenwood
	AddStaticVehicleEx(492,2507.3364000,-1667.8542000,13.1679000,12.0309000,234,0,60 * 3); //Greenwood
	AddStaticVehicleEx(492,2481.1985000,-1655.4291000,13.0977000,88.3731000,234,0,60 * 3); //Greenwood
	AddStaticVehicleEx(461,2494.7419000,-1646.6962000,13.1238000,184.8744000,234,0,60 * 3); //PCJ-600
	AddStaticVehicleEx(461,2495.9895000,-1646.7271000,13.1245000,186.1461000,234,0,60 * 3); //PCJ-600
	AddStaticVehicleEx(468,2497.3149000,-1646.7277000,13.2108000,181.4453000,234,0,60 * 3); //Sanchez
	AddStaticVehicleEx(468,2498.4285000,-1646.7308000,13.2134000,181.0005000,234,0,60 * 3); //Sanchez
	AddStaticVehicleEx(481,2499.9707000,-1646.8601000,13.0653000,177.9681000,1,1,60 * 3); //BMX
	AddStaticVehicleEx(560,2488.8828000,-1682.5521000,13.0394000,88.4135000,234,0,60 * 3); //Sultan
	AddStaticVehicleEx(560,2505.8083000,-1676.9359000,13.0822000,145.1534000,234,0,60 * 3); //Sultan
	AddStaticVehicleEx(560,2473.2930000,-1692.8815000,13.2188000,359.3069000,234,0,60 * 3); //Sultan
	AddStaticVehicleEx(487,2532.1384000,-1677.3931000,20.1521000,90.7859000,234,0,60 * 3); //Maverick
	AddStaticVehicleEx(522,2384.3425000,-1646.3175000,13.0906000,181.5380000,234,0,60 * 3); //NRG-500
	AddStaticVehicleEx(522,2383.7666000,-1637.1252000,13.0622000,182.4022000,234,0,60 * 3); //NRG-500
	AddStaticVehicleEx(495,2228.7925000,-1344.1483000,24.3405000,53.8436000,213,0,60 * 3); //Sandking
	AddStaticVehicleEx(448,2231.3062000,-1359.2870000,23.5833000,55.1351000,3,6,60 * 3); //Pizzaboy
	AddStaticVehicleEx(448,2230.9031000,-1361.3885000,23.5847000,55.3699000,3,6,60 * 3); //Pizzaboy
	AddStaticVehicleEx(448,2230.4331000,-1363.6921000,23.5867000,55.7453000,3,6,60 * 3); //Pizzaboy
	AddStaticVehicleEx(566,1942.1090000,-1131.7537000,25.2074000,269.9331000,242,0,60 * 3); //Tahoma
	AddStaticVehicleEx(566,1922.3438000,-1131.6237000,24.7665000,269.3204000,242,0,60 * 3); //Tahoma
	AddStaticVehicleEx(517,1932.2507000,-1139.7896000,25.0630000,271.0153000,242,0,60 * 3); //Majestic
	AddStaticVehicleEx(517,1934.5586000,-1117.5331000,26.3277000,180.1526000,242,0,60 * 3); //Majestic
	AddStaticVehicleEx(412,1904.4812000,-1139.7844000,24.3612000,271.3817000,242,0,60 * 3); //Voodoo
	AddStaticVehicleEx(468,1893.1187000,-1127.8568000,23.9725000,180.4935000,242,0,60 * 3); //Sanchez
	AddStaticVehicleEx(468,1891.0948000,-1127.6781000,23.9236000,179.2465000,242,0,60 * 3); //Sanchez
	AddStaticVehicleEx(461,1889.2263000,-1127.7280000,23.7949000,178.7430000,242,0,60 * 3); //PCJ-600
	AddStaticVehicleEx(461,1887.1187000,-1128.0178000,23.7401000,175.7701000,242,0,60 * 3); //PCJ-600
	AddStaticVehicleEx(522,1903.0062000,-1168.6576000,23.8106000,123.7299000,242,0,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1943.4567000,-1157.8273000,20.7644000,89.2032000,242,0,60 * 3); //NRG-500
	AddStaticVehicleEx(560,2004.9836000,-1275.4242000,23.5271000,359.7504000,242,0,60 * 3); //Sultan
	AddStaticVehicleEx(522,1999.7885000,-1275.1379000,23.3048000,357.6044000,242,0,60 * 3); //NRG-500
	AddStaticVehicleEx(475,1990.5764000,-1275.5338000,23.6250000,359.6972000,242,0,60 * 3); //Sabre
	AddStaticVehicleEx(560,1984.1321000,-1275.6128000,23.4207000,357.9471000,242,0,60 * 3); //Sultan
	AddStaticVehicleEx(427,1574.7769000,-1710.3876000,6.0233000,356.9806000,0,1,60 * 3); //Enforcer
	AddStaticVehicleEx(599,1519.5420000,-1673.7174000,13.7409000,180.7947000,0,1,60 * 3); //Police Ranger
	AddStaticVehicleEx(599,1519.5344000,-1682.5839000,13.7362000,182.3962000,0,1,60 * 3); //Police Ranger
	AddStaticVehicleEx(490,1536.3152000,-1686.6855000,13.6771000,0.2634000,0,0,60 * 3); //FBI Rancher
	AddStaticVehicleEx(490,1535.9216000,-1677.1670000,13.5094000,0.2980000,0,0,60 * 3); //FBI Rancher
	AddStaticVehicleEx(597,1535.9736000,-1667.6161000,13.1518000,358.7612000,0,1,60 * 3); //Police Car (SFPD)
	AddStaticVehicleEx(596,1536.0414000,-1659.6714000,13.2516000,359.6009000,0,1,60 * 3); //Police Car (LSPD)
	AddStaticVehicleEx(523,1558.4581000,-1632.1503000,12.9526000,88.3731000,0,0,60 * 3); //HPV1000
	AddStaticVehicleEx(523,1558.4709000,-1630.3142000,12.9461000,88.5401000,0,0,60 * 3); //HPV1000
	AddStaticVehicleEx(523,1558.5076000,-1620.4822000,13.0288000,88.5088000,0,0,60 * 3); //HPV1000
	AddStaticVehicleEx(523,1562.7982000,-1620.4220000,13.1212000,90.6587000,0,0,60 * 3); //HPV1000
	AddStaticVehicleEx(597,1568.9692000,-1620.2595000,13.3156000,90.6868000,0,1,60 * 3); //Police Car (SFPD)
	AddStaticVehicleEx(596,1565.4484000,-1631.2847000,13.1030000,88.2925000,0,1,60 * 3); //Police Car (LSPD)
	AddStaticVehicleEx(596,1573.7822000,-1631.3890000,13.0999000,88.9948000,0,1,60 * 3); //Police Car (LSPD)
	AddStaticVehicleEx(497,1562.0393000,-1608.1948000,13.6353000,91.8789000,0,1,60 * 3); //Police Maverick
	AddStaticVehicleEx(497,1556.6813000,-1644.0449000,28.5798000,94.1756000,0,1,60 * 3); //Police Maverick
	AddStaticVehicleEx(535,1766.4539000,-1896.0609000,13.3267000,268.1153000,240,0,60 * 3); //Slamvan
	AddStaticVehicleEx(535,1766.5015000,-1891.8252000,13.3254000,267.9618000,240,0,60 * 3); //Slamvan
	AddStaticVehicleEx(466,1797.0143000,-1887.0624000,13.1438000,269.2337000,240,0,60 * 3); //Glendale
	AddStaticVehicleEx(466,1788.9431000,-1886.6229000,13.1379000,266.5638000,240,0,60 * 3); //Glendale
	AddStaticVehicleEx(487,1803.4468000,-1916.7710000,13.5249000,356.2359000,240,0,60 * 3); //Maverick
	AddStaticVehicleEx(468,1805.2656000,-1928.0687000,13.0577000,85.5748000,240,0,60 * 3); //Sanchez
	AddStaticVehicleEx(468,1805.0251000,-1930.2151000,13.0594000,93.0751000,240,0,60 * 3); //Sanchez
	AddStaticVehicleEx(468,1804.9706000,-1932.3654000,13.0566000,91.0180000,240,0,60 * 3); //Sanchez
	AddStaticVehicleEx(468,1805.3569000,-1934.5549000,13.0528000,90.0563000,240,0,60 * 3); //Sanchez
	AddStaticVehicleEx(534,1788.0222000,-1932.3197000,13.0165000,358.8269000,240,0,60 * 3); //Remington
	AddStaticVehicleEx(534,1793.4213000,-1932.3069000,13.0162000,359.5490000,240,0,60 * 3); //Remington
	AddStaticVehicleEx(560,1776.7200000,-1913.1426000,13.0914000,271.1873000,240,0,60 * 3); //Sultan
	AddStaticVehicleEx(560,1776.6604000,-1917.2689000,13.0926000,271.8476000,240,0,60 * 3); //Sultan
	AddStaticVehicleEx(560,1776.6300000,-1921.3145000,13.0906000,274.4808000,240,0,60 * 3); //Sultan
	AddStaticVehicleEx(467,2456.4463000,-1270.5428000,23.6309000,180.9803000,6,6,60 * 3); //Oceanic
	AddStaticVehicleEx(467,2445.7803000,-1271.0825000,23.6485000,179.5014000,6,6,60 * 3); //Oceanic
	AddStaticVehicleEx(467,2445.4707000,-1292.7327000,23.6473000,0.1590000,6,6,60 * 3); //Oceanic
	AddStaticVehicleEx(466,2456.1025000,-1324.7745000,23.6568000,358.7246000,6,6,60 * 3); //Glendale
	AddStaticVehicleEx(474,2445.3430000,-1325.7814000,23.6705000,0.8372000,6,6,60 * 3); //Hermes
	AddStaticVehicleEx(474,2456.3201000,-1318.1158000,23.6768000,359.3808000,6,6,60 * 3); //Hermes
	AddStaticVehicleEx(468,2456.9224000,-1282.0367000,23.6692000,177.5946000,6,6,60 * 3); //Sanchez
	AddStaticVehicleEx(468,2438.1069000,-1302.4076000,24.0563000,270.0579000,6,6,60 * 3); //Sanchez
	AddStaticVehicleEx(468,2437.9824000,-1304.9277000,24.1857000,271.2780000,6,6,60 * 3); //Sanchez
	AddStaticVehicleEx(468,2457.0901000,-1277.0818000,23.6670000,176.1003000,6,6,60 * 3); //Sanchez
	AddStaticVehicleEx(487,2469.5083000,-1322.1862000,31.0850000,180.4267000,6,6,60 * 3); //Maverick
	AddStaticVehicleEx(468,2464.5986000,-1349.0846000,24.5512000,100.0781000,6,6,60 * 3); //Sanchez
	AddStaticVehicleEx(461,2503.1472000,-1302.1002000,34.4382000,177.5445000,53,1,60 * 3); //PCJ-600
	AddStaticVehicleEx(461,2505.6748000,-1302.1523000,34.4243000,183.5753000,61,1,60 * 3); //PCJ-600
	AddStaticVehicleEx(487,2428.9275000,-1383.2628000,28.5988000,269.2320000,6,6,60 * 3); //Maverick
	AddStaticVehicleEx(476,2037.6962000,-2536.3425000,14.2488000,30.4495000,1,6,60 * 3); //Rustler
	AddStaticVehicleEx(476,2033.1482000,-2555.8188000,14.2700000,28.7511000,77,87,60 * 3); //Rustler
	AddStaticVehicleEx(476,2016.9904000,-2563.6621000,14.2583000,32.9380000,71,77,60 * 3); //Rustler
	AddStaticVehicleEx(476,1998.3538000,-2562.2937000,14.1918000,26.4827000,89,91,60 * 3); //Rustler
	AddStaticVehicleEx(476,1983.0830000,-2555.6765000,14.2683000,34.0745000,119,117,60 * 3); //Rustler
	AddStaticVehicleEx(592,1789.8540000,-2540.0281000,14.7411000,358.2566000,1,1,60 * 3); //Andromada
	AddStaticVehicleEx(519,1752.6368000,-2541.2620000,14.4692000,357.9419000,1,1,60 * 3); //Shamal
	AddStaticVehicleEx(519,1726.5344000,-2431.9460000,14.4754000,222.8902000,1,1,60 * 3); //Shamal
	AddStaticVehicleEx(593,1765.9513000,-2452.8821000,14.0136000,206.2297000,60,1,60 * 3); //Dodo
	AddStaticVehicleEx(593,1729.7977000,-2541.7388000,14.0098000,1.6706000,58,8,60 * 3); //Dodo
	AddStaticVehicleEx(444,1890.0095000,-2432.1248000,13.9091000,307.1144000,32,66,60 * 3); //Monster
	AddStaticVehicleEx(444,1894.9589000,-2438.0867000,13.9092000,299.7513000,32,53,60 * 3); //Monster
	AddStaticVehicleEx(444,1898.0697000,-2444.7085000,13.9088000,289.0035000,32,42,60 * 3); //Monster
	AddStaticVehicleEx(487,1972.6232000,-2361.9495000,13.7246000,90.8256000,3,0,60 * 3); //Maverick
	AddStaticVehicleEx(487,1974.7212000,-2350.8291000,13.7239000,80.6168000,54,29,60 * 3); //Maverick
	AddStaticVehicleEx(487,1898.5112000,-2349.8860000,13.7245000,274.4889000,26,3,60 * 3); //Maverick
	AddStaticVehicleEx(487,1978.4230000,-2335.1030000,13.7060000,91.8645000,26,57,60 * 3); //Maverick
	AddStaticVehicleEx(487,1912.0035000,-2289.5566000,13.7294000,269.3829000,3,29,60 * 3); //Maverick
	AddStaticVehicleEx(487,1991.8904000,-2283.7976000,13.7234000,85.5322000,54,29,60 * 3); //Maverick
	AddStaticVehicleEx(409,1476.2286000,-1447.3713000,13.3468000,89.1404000,239,0,60 * 3); //Stretch
	AddStaticVehicleEx(560,1493.1738000,-1435.7092000,13.1651000,91.8876000,239,0,60 * 3); //Sultan
	AddStaticVehicleEx(579,1478.1548000,-1436.1643000,13.3875000,89.5471000,239,0,60 * 3); //Huntley
	AddStaticVehicleEx(405,1469.8954000,-1435.8312000,13.3353000,88.3306000,239,0,60 * 3); //Sentinel
	AddStaticVehicleEx(405,1461.6672000,-1423.4570000,13.4217000,181.3559000,239,0,60 * 3); //Sentinel
	AddStaticVehicleEx(405,1447.2880000,-1427.5317000,13.4212000,179.5946000,239,0,60 * 3); //Sentinel
	AddStaticVehicleEx(579,1447.4044000,-1419.7328000,13.4748000,178.9309000,239,0,60 * 3); //Huntley
	AddStaticVehicleEx(579,1461.5850000,-1414.5131000,13.4747000,180.4480000,239,0,60 * 3); //Huntley
	AddStaticVehicleEx(579,1461.6138000,-1406.1893000,13.4818000,179.4314000,239,0,60 * 3); //Huntley
	AddStaticVehicleEx(560,1447.3575000,-1411.2352000,13.2493000,177.7300000,239,0,60 * 3); //Sultan
	AddStaticVehicleEx(461,1461.1128000,-1399.8267000,13.1211000,178.4996000,239,0,60 * 3); //PCJ-600
	AddStaticVehicleEx(461,1462.6718000,-1399.5437000,13.1348000,181.9273000,239,0,60 * 3); //PCJ-600
	AddStaticVehicleEx(522,1531.5944000,-1451.9625000,12.9548000,4.1184000,239,0,60 * 3); //NRG-500
	AddStaticVehicleEx(461,1533.5966000,-1451.8245000,12.9704000,7.6838000,239,0,60 * 3); //PCJ-600
	AddStaticVehicleEx(487,1476.7988000,-1292.9109000,13.7690000,87.8844000,29,42,60 * 3); //Maverick
	AddStaticVehicleEx(416,2029.8054000,-1418.6552000,17.1432000,132.4931000,1,3,60 * 3); //Ambulance
	AddStaticVehicleEx(416,2002.9579000,-1415.3356000,17.1411000,177.9899000,1,3,60 * 3); //Ambulance
	AddStaticVehicleEx(522,1973.2185000,-1439.8990000,13.0730000,94.9563000,3,0,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1972.9475000,-1437.5325000,13.0775000,90.5696000,3,0,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1973.6080000,-1442.1852000,13.0674000,93.0322000,6,25,60 * 3); //NRG-500
	AddStaticVehicleEx(481,1884.6495000,-1369.5531000,13.0838000,82.0393000,12,9,60 * 3); //BMX
	AddStaticVehicleEx(481,1890.1118000,-1362.8639000,13.0205000,173.7132000,26,1,60 * 3); //BMX
	AddStaticVehicleEx(481,1885.5587000,-1355.7878000,13.0010000,276.7696000,14,1,60 * 3); //BMX
	AddStaticVehicleEx(579,1715.6182000,-1576.7150000,13.4833000,176.5975000,62,62,60 * 3); //Huntley
	AddStaticVehicleEx(522,1746.1989000,-1583.8654000,13.1096000,170.8160000,36,105,60 * 3); //NRG-500
	AddStaticVehicleEx(400,1742.9714000,-1747.5903000,13.6323000,359.0181000,123,1,60 * 3); //Landstalker
	AddStaticVehicleEx(541,1731.5750000,-1747.6261000,13.1539000,359.7256000,58,8,60 * 3); //Bullet
	AddStaticVehicleEx(522,1740.0298000,-1746.7567000,13.1103000,0.6352000,6,25,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1738.2513000,-1747.0044000,13.1057000,3.4372000,7,79,60 * 3); //NRG-500
	AddStaticVehicleEx(468,1735.6724000,-1747.2864000,13.1994000,5.7769000,53,53,60 * 3); //Sanchez
	AddStaticVehicleEx(482,1345.9530000,-1753.6694000,13.4808000,358.5551000,0,0,60 * 3); //Burrito
	AddStaticVehicleEx(448,2117.6392000,-1784.6228000,12.9866000,358.3927000,3,6,60 * 3); //Pizzaboy
	AddStaticVehicleEx(448,2118.6680000,-1784.7036000,12.9992000,357.2917000,3,6,60 * 3); //Pizzaboy
	AddStaticVehicleEx(448,2111.6201000,-1784.6499000,12.9832000,355.7061000,3,6,60 * 3); //Pizzaboy
	AddStaticVehicleEx(448,2110.4790000,-1784.4723000,12.9866000,352.8771000,3,6,60 * 3); //Pizzaboy
	AddStaticVehicleEx(400,2099.9338000,-1783.1802000,13.5294000,351.0157000,113,1,60 * 3); //Landstalker
	AddStaticVehicleEx(402,2476.0110000,-2117.6929000,13.3797000,358.5579000,22,22,60 * 3); //Buffalo
	AddStaticVehicleEx(402,2469.4058000,-2117.9854000,13.3792000,2.5414000,30,30,60 * 3); //Buffalo
	AddStaticVehicleEx(461,2451.8093000,-2120.3416000,13.1205000,46.0395000,88,1,60 * 3); //PCJ-600
	AddStaticVehicleEx(461,2448.0063000,-2120.2498000,13.1291000,36.7806000,79,1,60 * 3); //PCJ-600
	AddStaticVehicleEx(461,2445.5457000,-2120.1182000,13.1293000,34.5774000,61,1,60 * 3); //PCJ-600
	AddStaticVehicleEx(521,2457.2290000,-2081.6399000,13.1075000,179.8145000,92,3,60 * 3); //FCR-900
	AddStaticVehicleEx(521,2455.3450000,-2081.3892000,13.1157000,176.1868000,87,118,60 * 3); //FCR-900
	AddStaticVehicleEx(588,2397.1694000,-1889.3961000,13.2935000,270.6021000,1,1,60 * 3); //Hotdog
	AddStaticVehicleEx(493,2596.5444000,-2476.9480000,-0.0123000,268.0885000,36,13,60 * 3); //Jetmax
	AddStaticVehicleEx(433,2747.4211000,-2423.0447000,14.0727000,270.3517000,43,0,60 * 3); //Barracks
	AddStaticVehicleEx(470,2745.2161000,-2431.7715000,13.6316000,271.5039000,43,0,60 * 3); //Patriot
	AddStaticVehicleEx(433,2746.9146000,-2445.2197000,14.0363000,270.0372000,43,0,60 * 3); //Barracks
	AddStaticVehicleEx(433,2744.8904000,-2460.4514000,14.2127000,270.7411000,43,0,60 * 3); //Barracks
	AddStaticVehicleEx(433,2745.0796000,-2465.0823000,14.1854000,272.7816000,43,0,60 * 3); //Barracks
	AddStaticVehicleEx(470,2764.5906000,-2466.4238000,13.5197000,359.5534000,43,0,60 * 3); //Patriot
	AddStaticVehicleEx(470,2764.5908000,-2459.1599000,13.4858000,357.4129000,43,0,60 * 3); //Patriot
	AddStaticVehicleEx(461,2763.7847000,-2453.3967000,13.0445000,358.0330000,110,0,60 * 3); //PCJ-600
	AddStaticVehicleEx(461,2765.5374000,-2453.2598000,13.0671000,355.5417000,110,0,60 * 3); //PCJ-600
	AddStaticVehicleEx(470,2769.9844000,-2408.0479000,13.6136000,359.3335000,43,0,60 * 3); //Patriot
	AddStaticVehicleEx(493,598.5419000,-1921.1670000,0.1814000,244.1086000,36,13,60 * 3); //Jetmax
	AddStaticVehicleEx(539,849.1185000,-1873.8999000,12.2272000,173.0175000,86,70,60 * 3); //Vortex
	AddStaticVehicleEx(539,845.5626000,-1873.8358000,12.2272000,175.3985000,75,91,60 * 3); //Vortex
	AddStaticVehicleEx(539,841.8859000,-1873.9276000,12.2272000,178.4086000,75,75,60 * 3); //Vortex
	AddStaticVehicleEx(539,837.7437000,-1873.7941000,12.2272000,182.2082000,96,67,60 * 3); //Vortex
	AddStaticVehicleEx(568,-707.9844000,-1848.3096000,14.0363000,164.2650000,41,29,60 * 3); //Bandito
	AddStaticVehicleEx(568,-711.0758000,-1847.5968000,14.0067000,162.4003000,17,1,60 * 3); //Bandito
	AddStaticVehicleEx(568,-714.6538000,-1847.0098000,14.0220000,162.9635000,56,29,60 * 3); //Bandito
	AddStaticVehicleEx(568,-718.1217000,-1846.0725000,14.0720000,163.7988000,21,1,60 * 3); //Bandito
	AddStaticVehicleEx(568,-721.2296000,-1845.7028000,14.0274000,169.8138000,37,0,60 * 3); //Bandito
	AddStaticVehicleEx(568,-724.5586000,-1845.7849000,13.8970000,173.9469000,9,39,60 * 3); //Bandito
	AddStaticVehicleEx(568,-727.6759000,-1845.6980000,13.8124000,177.1189000,33,0,60 * 3); //Bandito
	AddStaticVehicleEx(568,-731.0407000,-1845.6594000,13.7111000,179.9667000,2,39,60 * 3); //Bandito
	AddStaticVehicleEx(476,346.2031000,2540.8423000,17.4565000,179.0861000,6,7,60 * 3); //Rustler
	AddStaticVehicleEx(476,327.1325000,2541.7886000,17.4682000,175.3636000,71,77,60 * 3); //Rustler
	AddStaticVehicleEx(476,290.8682000,2540.2251000,17.4836000,184.6723000,77,87,60 * 3); //Rustler
	AddStaticVehicleEx(513,268.9001000,2544.3323000,17.3030000,177.1655000,54,34,60 * 3); //Stunt
	AddStaticVehicleEx(476,243.2674000,2544.7981000,17.4563000,178.1107000,89,91,60 * 3); //Rustler
	AddStaticVehicleEx(511,214.3248000,2543.6411000,17.9556000,180.6095000,2,6,60 * 3); //Beagle
	AddStaticVehicleEx(511,191.4234000,2543.2227000,17.8960000,181.8266000,3,6,60 * 3); //Beagle
	AddStaticVehicleEx(513,310.1944000,2464.2844000,17.0165000,18.5096000,48,18,60 * 3); //Stunt
	AddStaticVehicleEx(513,338.3680000,2464.9207000,17.0158000,21.4670000,55,20,60 * 3); //Stunt
	AddStaticVehicleEx(476,352.4409000,2467.3123000,17.1894000,17.9505000,1,6,60 * 3); //Rustler
	AddStaticVehicleEx(476,367.5130000,2461.7800000,17.1900000,23.0959000,7,6,60 * 3); //Rustler
	AddStaticVehicleEx(593,428.4526000,2488.2473000,16.9429000,88.1001000,22,1,60 * 3); //Dodo
	AddStaticVehicleEx(593,428.5022000,2501.7515000,16.9319000,87.3777000,13,8,60 * 3); //Dodo
	AddStaticVehicleEx(593,428.4421000,2515.2961000,16.9144000,89.4779000,68,8,60 * 3); //Dodo
	AddStaticVehicleEx(417,365.4971000,2536.7708000,16.7123000,182.2461000,0,0,60 * 3); //Leviathan
	AddStaticVehicleEx(519,404.2703000,2454.3184000,17.3796000,358.2518000,1,1,60 * 3); //Shamal
	AddStaticVehicleEx(563,384.5582000,2536.5476000,17.2447000,174.8565000,1,6,60 * 3); //Raindance
	AddStaticVehicleEx(541,2039.8352000,997.5930000,10.2985000,0.9639000,6,3,60 * 3); //Bullet
	AddStaticVehicleEx(409,2039.7195000,1005.6006000,10.4735000,0.5033000,123,149,60 * 3); //Stretch
	AddStaticVehicleEx(429,2039.5974000,1013.6149000,10.3507000,358.8629000,2,3,60 * 3); //Banshee
	AddStaticVehicleEx(603,2039.4260000,1019.8506000,10.5115000,358.9070000,3,0,60 * 3); //Phoenix
	AddStaticVehicleEx(561,2039.3816000,1026.5226000,10.4857000,359.2970000,0,3,60 * 3); //Stratum
	AddStaticVehicleEx(521,2038.4814000,1032.4636000,10.2425000,3.7811000,87,118,60 * 3); //FCR-900
	AddStaticVehicleEx(521,2040.4330000,1032.5781000,10.2429000,359.8937000,75,13,60 * 3); //FCR-900
	AddStaticVehicleEx(581,2037.8889000,1036.6439000,10.2630000,4.9257000,58,1,60 * 3); //BF-400
	AddStaticVehicleEx(581,2040.3643000,1036.7612000,10.2694000,0.6512000,66,1,60 * 3); //BF-400
	AddStaticVehicleEx(522,2037.9706000,1042.2931000,10.2350000,2.5339000,3,8,60 * 3); //NRG-500
	AddStaticVehicleEx(522,2040.2340000,1042.3126000,10.2425000,0.5515000,6,25,60 * 3); //NRG-500
	AddStaticVehicleEx(468,-395.7064000,2237.7053000,42.0960000,286.4376000,46,46,60 * 3); //Sanchez
	AddStaticVehicleEx(468,-394.7085000,2234.9241000,42.0977000,293.4692000,6,6,60 * 3); //Sanchez
	AddStaticVehicleEx(468,-393.8262000,2232.2427000,42.0636000,287.1849000,3,3,60 * 3); //Sanchez
	AddStaticVehicleEx(468,-390.2872000,2222.0808000,42.0990000,286.9149000,53,53,60 * 3); //Sanchez
	AddStaticVehicleEx(468,-390.1137000,2211.8550000,42.0931000,275.4990000,46,46,60 * 3); //Sanchez
	AddStaticVehicleEx(495,-395.7191000,2193.4175000,42.7407000,280.4581000,118,117,60 * 3); //Sandking
	AddStaticVehicleEx(495,-394.4633000,2187.2200000,42.5459000,282.0477000,116,115,60 * 3); //Sandking
	AddStaticVehicleEx(495,-358.1926000,2195.2312000,42.7638000,99.8491000,119,122,60 * 3); //Sandking
	AddStaticVehicleEx(495,-360.6103000,2202.7500000,42.7762000,103.0005000,101,106,60 * 3); //Sandking
	AddStaticVehicleEx(568,-363.6795000,2211.9170000,42.3129000,101.2628000,21,1,60 * 3); //Bandito
	AddStaticVehicleEx(568,-365.4912000,2216.6489000,42.3515000,103.5198000,37,0,60 * 3); //Bandito
	AddStaticVehicleEx(568,-368.3914000,2225.6838000,42.3535000,105.5466000,9,39,60 * 3); //Bandito
	AddStaticVehicleEx(568,-369.7080000,2229.6169000,42.3420000,103.2074000,33,0,60 * 3); //Bandito
	AddStaticVehicleEx(568,-370.9055000,2234.0059000,42.3496000,103.4582000,17,1,60 * 3); //Bandito
	AddStaticVehicleEx(495,-374.3486000,2269.3711000,42.4119000,95.5953000,88,99,60 * 3); //Sandking
	AddStaticVehicleEx(495,-374.5809000,2274.6636000,41.9681000,102.2968000,114,108,60 * 3); //Sandking
	AddStaticVehicleEx(424,-779.1224000,2444.6636000,156.8273000,172.5489000,2,2,60 * 3); //BF Injection
	AddStaticVehicleEx(568,-783.0840000,2444.9700000,156.9053000,182.5076000,41,29,60 * 3); //Bandito
	AddStaticVehicleEx(568,-787.1168000,2444.5479000,156.9050000,182.9340000,56,29,60 * 3); //Bandito
	AddStaticVehicleEx(424,-792.1566000,2444.6931000,156.8169000,181.0554000,3,2,60 * 3); //BF Injection
	AddStaticVehicleEx(463,510.3554000,-1767.4922000,5.1178000,181.4862000,19,19,60 * 3); //Freeway
	AddStaticVehicleEx(463,504.2779000,-1767.4050000,5.0981000,176.0915000,36,36,60 * 3); //Freeway
	AddStaticVehicleEx(463,500.5455000,-1767.3551000,5.0976000,179.6800000,11,11,60 * 3); //Freeway
	AddStaticVehicleEx(463,494.9489000,-1767.0951000,5.0913000,175.9095000,22,22,60 * 3); //Freeway
	AddStaticVehicleEx(463,489.0911000,-1767.1393000,5.0837000,173.2824000,53,53,60 * 3); //Freeway
	AddStaticVehicleEx(482,515.3393000,-1767.0791000,5.6216000,178.3167000,41,41,60 * 3); //Burrito
	AddStaticVehicleEx(487,504.3589000,-1796.0552000,6.0465000,173.2168000,41,0,60 * 3); //Maverick
	AddStaticVehicleEx(482,520.9885000,-1767.0609000,5.7712000,180.9592000,48,48,60 * 3); //Burrito
	AddStaticVehicleEx(490,745.7175000,-1293.3507000,13.6930000,270.0052000,0,0,60 * 3); //FBI Rancher
	AddStaticVehicleEx(560,745.2972000,-1287.2671000,13.2647000,271.4352000,0,0,60 * 3); //Sultan
	AddStaticVehicleEx(560,745.2401000,-1272.7728000,13.2623000,269.0181000,0,0,60 * 3); //Sultan
	AddStaticVehicleEx(541,745.4940000,-1268.8285000,13.1803000,269.9022000,3,0,60 * 3); //Bullet
	AddStaticVehicleEx(541,745.4043000,-1250.9348000,13.1847000,267.5708000,0,0,60 * 3); //Bullet
	AddStaticVehicleEx(560,745.5299000,-1247.3076000,13.2097000,268.0338000,0,0,60 * 3); //Sultan
	AddStaticVehicleEx(490,747.1693000,-1241.3002000,13.6849000,268.7546000,0,0,60 * 3); //FBI Rancher
	AddStaticVehicleEx(522,765.9439000,-1224.2443000,13.1183000,3.2038000,0,0,60 * 3); //NRG-500
	AddStaticVehicleEx(522,767.9388000,-1224.1785000,13.1231000,5.2152000,3,0,60 * 3); //NRG-500
	AddStaticVehicleEx(522,770.7883000,-1224.1497000,13.1109000,1.9362000,3,0,60 * 3); //NRG-500
	AddStaticVehicleEx(522,773.1688000,-1224.3339000,13.1178000,359.5991000,0,0,60 * 3); //NRG-500
	AddStaticVehicleEx(488,747.0955000,-1221.0542000,13.7438000,272.6141000,4,0,60 * 3); //News Chopper
	AddStaticVehicleEx(409,764.4934000,-1250.8940000,13.3590000,269.3806000,0,0,60 * 3); //Stretch
	AddStaticVehicleEx(409,767.0392000,-1272.9113000,13.3663000,270.2549000,0,0,60 * 3); //Stretch
	AddStaticVehicleEx(497,766.4412000,-1286.9491000,13.7393000,267.5712000,0,0,60 * 3); //Police Maverick
	AddStaticVehicleEx(534,1811.1873000,-2117.3640000,13.2097000,271.5523000,240,0,60 * 3); //Remington
	AddStaticVehicleEx(535,1799.0608000,-2117.3301000,13.2459000,269.9667000,240,0,60 * 3); //Slamvan
	AddStaticVehicleEx(535,1782.0593000,-2117.1411000,13.2458000,271.5252000,240,0,60 * 3); //Slamvan
	AddStaticVehicleEx(535,1782.2927000,-2108.0144000,13.2430000,270.3024000,240,0,60 * 3); //Slamvan
	AddStaticVehicleEx(534,1794.8571000,-2107.6555000,13.1008000,272.4251000,240,0,60 * 3); //Remington
	AddStaticVehicleEx(492,1809.5171000,-2107.1318000,13.2479000,272.0408000,240,0,60 * 3); //Greenwood
	AddStaticVehicleEx(468,1773.8088000,-2097.5376000,13.2148000,183.2032000,240,0,60 * 3); //Sanchez
	AddStaticVehicleEx(468,1771.3361000,-2097.3582000,13.2188000,176.7385000,240,0,60 * 3); //Sanchez
	AddStaticVehicleEx(468,1773.6471000,-2128.7297000,13.2165000,357.2117000,240,0,60 * 3); //Sanchez
	AddStaticVehicleEx(468,1771.3823000,-2128.4929000,13.2161000,5.4866000,240,0,60 * 3); //Sanchez
	AddStaticVehicleEx(487,1803.5618000,-2146.8782000,17.7945000,82.9009000,240,0,60 * 3); //Maverick
	AddStaticVehicleEx(487,1787.2329000,-2092.9700000,17.5968000,91.4793000,240,0,60 * 3); //Maverick
	AddStaticVehicleEx(427,1569.8048000,-1710.4363000,6.0225000,357.8555000,0,1,60 * 3); //Enforcer
	AddStaticVehicleEx(463,1952.7753000,-1770.2029000,13.0852000,315.1322000,79,79,60 * 3); //Freeway
	AddStaticVehicleEx(463,1952.2970000,-1767.9891000,13.0932000,311.2477000,53,53,60 * 3); //Freeway
	AddStaticVehicleEx(522,1954.7129000,-1775.4447000,13.1131000,225.3770000,3,3,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1953.5861000,-1777.5029000,13.1217000,233.9649000,4,0,60 * 3); //NRG-500
	AddStaticVehicleEx(461,1919.8605000,-1789.0764000,12.9672000,274.1993000,79,1,60 * 3); //PCJ-600
	AddStaticVehicleEx(461,1916.3053000,-1789.2915000,12.9658000,271.7777000,61,1,60 * 3); //PCJ-600
	AddStaticVehicleEx(548,2740.5461000,-2362.0503000,18.3631000,0.0475000,1,1,60 * 3); //Cargobob
	return 1;
}

CreateMappings()
{
	//dm6
	CreateObject(8615, 2483.124267, -1715.256469, 15.625640, 0.000000, 0.000000, -90.400024);
	CreateObject(8375, -269.509399, 2313.379394, 109.125770, 0.000000, 0.000000, 0.000000);
	CreateObject(9076, -277.587402, 2376.422363, 123.384140, 0.000000, 0.000000, 91.900001);
	CreateObject(11081, -249.333618, 2356.867919, 114.013885, 0.000000, 0.000000, 80.299972);
	CreateObject(18758, 1754.126953, -1912.028442, 14.519185, 0.000000, 0.000000, 0.000000);
	CreateObject(18755, 1750.168945, -1912.136718, 14.479488, 0.000000, 0.000000, -179.400100);
	CreateObject(18756, 1753.867919, -1912.021606, 14.429342, 0.000000, 0.000000, 2.599997);
	CreateObject(1505, 1752.067138, -1911.883911, 12.618414, 0.000000, 0.000000, 90.500007);
	CreateObject(18843, -264.367614, 2354.807617, 112.100822, 0.000000, 0.000000, 0.000000);
	CreateObject(19277, -307.458648, 2366.168701, 113.058288, 0.000000, 4.000000, 0.000000);
	CreateObject(19901, -266.132324, 2382.196533, 112.475494, 0.000000, 0.000000, 0.000000);
	CreateObject(19608, -277.138610, 2361.265380, 108.703895, 1.099999, 2.699999, 0.000000);
	CreateObject(19339, -274.064666, 2356.307617, 108.801223, 0.000000, 0.000000, 91.799980);
	CreateObject(19339, -280.011535, 2357.089843, 109.121200, 0.000000, 0.000000, 91.799980);
	CreateObject(11726, -274.200469, 2367.912841, 123.855049, 0.000000, 0.000000, 0.000000);
	CreateObject(11726, -280.270507, 2367.841796, 123.985038, 0.000000, 0.000000, 0.000000);
	CreateObject(19632, -303.791259, 2365.963867, 111.637451, 0.000000, 0.000000, 0.000000);
	CreateObject(8615, 2483.124267, -1715.256469, 15.625640, 0.000000, 0.000000, -90.400024);
	CreateObject(18758, 1754.126953, -1912.028442, 14.519185, 0.000000, 0.000000, 0.000000);
	CreateObject(18755, 1750.168945, -1912.136718, 14.479488, 0.000000, 0.000000, -179.400100);
	CreateObject(18756, 1753.867919, -1912.021606, 14.429342, 0.000000, 0.000000, 2.599998);
	CreateObject(1505, 1752.067138, -1911.883911, 12.618415, 0.000000, 0.000000, 90.500007);

	new tmpobjid;
	//tune shop + vehicle shop  (map by GameOvr) mapped with pottus texture studio
	tmpobjid = CreateDynamicObject(19379, 1701.491577, -1455.676391, 12.476868, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 12844, "cos_liquorstore", "b_wtilesreflect", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, 1691.009765, -1455.676391, 12.466875, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, 1701.491577, -1465.157714, 12.466875, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 12844, "cos_liquorstore", "b_wtilesreflect", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, 1691.009643, -1465.157714, 12.466875, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, 1680.517822, -1465.157714, 12.466875, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, 1680.517822, -1455.674194, 12.466875, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, 1673.227172, -1455.674194, 12.476875, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, 1673.227172, -1465.147705, 12.476874, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1706.664184, -1455.660888, 14.282814, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9507, "boxybld2_sfw", "gz_vic4e", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1706.664184, -1465.153198, 14.282814, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9507, "boxybld2_sfw", "gz_vic4e", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1706.664184, -1465.153198, 17.722816, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9507, "boxybld2_sfw", "gz_vic4e", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1706.664184, -1455.662475, 17.732805, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9507, "boxybld2_sfw", "gz_vic4e", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1699.798828, -1463.328979, 13.462800, 0.000000, 90.000000, 180.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14612, "ab_abattoir_box", "pipes_csite_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1696.325073, -1459.170166, 17.782815, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9507, "boxybld2_sfw", "gz_vic4e", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1696.315063, -1462.059936, 14.322801, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9507, "boxybld2_sfw", "gz_vic4e", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1696.315063, -1465.181762, 14.322801, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9507, "boxybld2_sfw", "gz_vic4e", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1699.798828, -1458.477539, 13.462800, 0.000000, 90.000000, 180.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14612, "ab_abattoir_box", "pipes_csite_256", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1702.869873, -1458.477539, 13.462800, 0.000000, 90.000000, 180.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14612, "ab_abattoir_box", "pipes_csite_256", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1699.927856, -1463.508422, 13.462800, 0.000000, 90.000000, 270.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 7418, "vgnbballsign2", "ws_chipboard2", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1699.927856, -1458.637329, 13.462800, 0.000000, 90.000000, 270.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 7418, "vgnbballsign2", "ws_chipboard2", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1702.998779, -1458.637329, 13.462800, 0.000000, 90.000000, 270.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 7418, "vgnbballsign2", "ws_chipboard2", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, 1701.491577, -1455.676391, 19.606914, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 17298, "weefarmcuntw", "sjmscruffhut4", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, 1701.491577, -1465.118408, 19.606914, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 17298, "weefarmcuntw", "sjmscruffhut4", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1696.315063, -1465.181762, 17.792818, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9507, "boxybld2_sfw", "gz_vic4e", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1701.061401, -1469.905395, 14.282814, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9507, "boxybld2_sfw", "gz_vic4e", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1701.061401, -1469.905395, 17.772808, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9507, "boxybld2_sfw", "gz_vic4e", 0x00000000);
	tmpobjid = CreateDynamicObject(19087, 1697.293701, -1463.610961, 13.402810, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
	tmpobjid = CreateDynamicObject(19454, 1701.771972, -1469.885375, 14.282814, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9507, "boxybld2_sfw", "gz_vic4e", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1701.771972, -1469.885375, 17.762819, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9507, "boxybld2_sfw", "gz_vic4e", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1696.323120, -1452.593627, 14.712821, 90.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9507, "boxybld2_sfw", "gz_vic4e", 0x00000000);
	tmpobjid = CreateDynamicObject(19398, 1696.324096, -1455.663085, 14.302819, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9507, "boxybld2_sfw", "gz_vic4e", 0x00000000);
	tmpobjid = CreateDynamicObject(3761, 1703.464843, -1469.046142, 14.502816, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1701.935791, -1450.930419, 18.186895, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9507, "boxybld2_sfw", "gz_vic4e", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1701.065063, -1450.920410, 18.186895, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9507, "boxybld2_sfw", "gz_vic4e", 0x00000000);
	tmpobjid = CreateDynamicObject(19435, 1705.771606, -1450.938354, 11.816884, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9507, "boxybld2_sfw", "gz_vic4e", 0x00000000);
	tmpobjid = CreateDynamicObject(19435, 1705.771606, -1450.938354, 15.296889, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9507, "boxybld2_sfw", "gz_vic4e", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1702.998779, -1463.508422, 13.462800, 0.000000, 90.000000, 270.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 7418, "vgnbballsign2", "ws_chipboard2", 0x00000000);
	tmpobjid = CreateDynamicObject(19435, 1697.209228, -1450.938354, 15.296889, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9507, "boxybld2_sfw", "gz_vic4e", 0x00000000);
	tmpobjid = CreateDynamicObject(19893, 1705.845825, -1463.635131, 13.448348, 0.000000, 0.000000, -113.300003);
	SetDynamicObjectMaterial(tmpobjid, 1, 14530, "estate2", "Auto_windsor", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, 1682.274414, -1469.883056, 14.072814, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(19483, 1696.434448, -1455.832275, 17.210899, -7.699998, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "Auto_hustler", 0x00000000);
	tmpobjid = CreateDynamicObject(19483, 1696.434448, -1464.699707, 17.975900, 2.999995, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "Auto_Slamvan2", 0x00000000);
	tmpobjid = CreateDynamicObject(19483, 1706.535400, -1464.072265, 17.087511, 2.999995, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "Auto_feltzer", 0x00000000);
	tmpobjid = CreateDynamicObject(19483, 1706.535400, -1458.180053, 15.673946, -4.100006, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14859, "gf1", "mp_apt1_pos4", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14612, "ab_abattoir_box", "pipes_csite_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19435, 1697.209228, -1450.938354, 11.826886, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9507, "boxybld2_sfw", "gz_vic4e", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1702.868896, -1463.328979, 13.462800, 0.000000, 90.000000, 180.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14612, "ab_abattoir_box", "pipes_csite_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19482, 1701.492675, -1451.062866, 17.892808, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 13598, "destructo", "sunshinebillboard", 0x00000000);
	tmpobjid = CreateDynamicObject(19482, 1701.492675, -1450.812622, 17.892808, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 11301, "carshow_sfse", "ws_Transfender_dirty", 0x00000000);
	tmpobjid = CreateDynamicObject(19826, 1699.947998, -1463.585449, 14.052815, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 1, -1, "none", "none", 0xFF9900FF);
	tmpobjid = CreateDynamicObject(9131, 1695.859741, -1451.220947, 13.646877, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1695.859741, -1451.220947, 15.916878, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1695.859741, -1451.220947, 18.176879, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1694.338867, -1451.219360, 12.706877, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1692.077880, -1451.219360, 12.706877, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1689.807373, -1451.219360, 12.706877, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1687.537353, -1451.219360, 12.706877, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1685.266723, -1451.219360, 12.706877, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1683.758056, -1451.220947, 13.646877, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1694.338867, -1451.219360, 18.926893, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1668.346191, -1451.220947, 13.646877, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1669.835693, -1451.219360, 12.706877, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1672.105590, -1451.219360, 12.706877, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1674.376098, -1451.219360, 12.706877, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1676.646484, -1451.219360, 12.706877, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1678.917358, -1451.219360, 12.706877, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1680.417236, -1451.220947, 13.646877, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1692.068603, -1451.219360, 18.926893, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1689.798217, -1451.219360, 18.926893, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1687.527832, -1451.219360, 18.926893, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1685.257446, -1451.219360, 18.926893, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1682.986816, -1451.219360, 18.926893, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1680.716552, -1451.219360, 18.926893, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1678.446411, -1451.219360, 18.926893, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1676.176147, -1451.219360, 18.926893, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1673.905395, -1451.219360, 18.926893, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1671.634765, -1451.219360, 18.926893, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1669.374267, -1451.219360, 18.926893, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1668.346191, -1451.220947, 15.896882, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1668.346191, -1451.220947, 18.156894, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1683.758056, -1451.220947, 15.896883, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1683.758056, -1451.220947, 18.166885, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1680.417236, -1451.220947, 15.886871, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1680.417236, -1451.220947, 18.126874, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, 1691.009765, -1455.676391, 19.246925, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, 1691.009643, -1465.157714, 19.256898, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, 1680.509277, -1465.157714, 19.256898, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, 1673.227172, -1465.147705, 19.236864, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, 1680.519409, -1455.676391, 19.256925, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, 1673.226440, -1455.676391, 19.246925, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, 1668.053710, -1455.651245, 14.082822, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, 1668.053710, -1465.152343, 14.072815, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, 1677.534912, -1465.152343, 14.072814, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1672.796142, -1460.426513, 17.422845, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1669.841918, -1460.396484, 11.072818, 90.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1675.692260, -1460.396484, 11.072818, 90.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1673.836669, -1460.694458, 12.272812, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1671.716064, -1460.694458, 14.532814, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1673.836669, -1460.694458, 14.542822, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1671.716064, -1460.694458, 12.282814, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(9131, 1672.757812, -1460.692138, 15.292818, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-80-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, 1691.894897, -1469.883056, 14.072814, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1687.148803, -1465.148681, 19.092805, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "wrappingpaper28", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1682.508789, -1465.148681, 19.072807, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "wrappingpaper28", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1677.998291, -1465.148681, 19.072790, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "wrappingpaper28", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1674.267456, -1465.148681, 19.042779, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "wrappingpaper28", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1695.550903, -1465.148681, 19.102804, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "wrappingpaper28", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1691.290405, -1465.148681, 19.092807, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "wrappingpaper28", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1670.496704, -1465.148681, 19.062799, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "wrappingpaper28", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1670.496704, -1455.647094, 19.052799, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "wrappingpaper28", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1674.258422, -1455.657470, 19.082794, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "wrappingpaper28", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1678.009277, -1455.657470, 19.072790, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "wrappingpaper28", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1682.489990, -1455.657470, 19.082794, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "wrappingpaper28", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1687.171020, -1455.657470, 19.102806, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "wrappingpaper28", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1691.332031, -1455.657470, 19.092802, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "wrappingpaper28", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1695.543212, -1455.657470, 19.062795, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "wrappingpaper28", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1699.842163, -1465.148681, 19.102804, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "wrappingpaper28", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1703.192382, -1465.148681, 19.102804, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "wrappingpaper28", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1699.822875, -1455.657470, 19.092802, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "wrappingpaper28", 0x00000000);
	tmpobjid = CreateDynamicObject(2960, 1703.153320, -1455.657470, 19.092802, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "wrappingpaper28", 0x00000000);
	tmpobjid = CreateDynamicObject(19893, 1693.626708, -1462.418212, 13.332813, 0.000000, 0.000000, 110.699951);
	SetDynamicObjectMaterial(tmpobjid, 1, 2813, "gb_books01", "GB_novels09", 0x00000000);
	tmpobjid = CreateDynamicObject(19482, 1682.141723, -1450.742187, 19.532800, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{6d6868}Vehicle Shop", 130, "Ariel", 70, 1, 0x00000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19482, 1682.171752, -1450.771606, 17.712772, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{6d6868} Los Santos City", 130, "Ariel", 50, 1, 0x00000000, 0x00000000, 0);
	tmpobjid = CreateDynamicObject(19482, 1682.141723, -1450.772216, 17.742763, 0.000000, 0.000000, 90.000000); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{000000} Los Santos City", 130, "Ariel", 50, 1, 0x00000000, 0x00000000, 0);
	tmpobjid = CreateDynamicObject(19482, 1682.091674, -1450.802246, 19.892803, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(19482, 1682.091674, -1450.772216, 19.542797, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{000000}Vehicle Shop", 130, "Ariel", 70, 1, 0x00000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19483, 1682.177978, -1450.786743, 20.768850, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{000000}/", 130, "Webdings", 100, 1, 0x00000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19483, 1681.937866, -1450.796752, 20.768850, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{6d6868}/", 130, "Webdings", 100, 1, 0x00000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19483, 1681.927734, -1450.796752, 20.248849, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{000000}/", 130, "Webdings", 100, 1, 0x00000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19483, 1682.178100, -1450.786743, 20.248846, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{6d6868}/", 130, "Webdings", 100, 1, 0x00000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19482, 1672.650146, -1460.542236, 18.374271, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{FF8000} Los Santos", 130, "Ariel", 100, 1, 0x00000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19482, 1672.650146, -1460.542236, 17.134260, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{FF8000} Vehicle Shop", 130, "Ariel", 85, 1, 0x00000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19872, 1692.827148, -1466.767700, 10.672801, 0.000000, 0.000000, 90.199996);
	SetDynamicObjectMaterial(tmpobjid, 0, 7520, "vgnretail72", "solairwheel64", 0x00000000);  
	tmpobjid = CreateDynamicObject(19872, 1686.586303, -1466.789306, 10.672801, 0.000000, 0.000000, 180.199996);
	SetDynamicObjectMaterial(tmpobjid, 0, 7520, "vgnretail72", "solairwheel64", 0x00000000);
	tmpobjid = CreateDynamicObject(19872, 1680.955566, -1466.809326, 10.672801, 0.000000, 0.000000, 180.199996);
	SetDynamicObjectMaterial(tmpobjid, 0, 7520, "vgnretail72", "solairwheel64", 0x00000000);
	tmpobjid = CreateDynamicObject(19872, 1680.924438, -1457.859252, 10.672801, 0.000000, 0.000000, 180.199996);
	SetDynamicObjectMaterial(tmpobjid, 0, 7520, "vgnretail72", "solairwheel64", 0x00000000);
	tmpobjid = CreateDynamicObject(19872, 1686.555297, -1457.839355, 10.672801, 0.000000, 0.000000, 180.199996);
	SetDynamicObjectMaterial(tmpobjid, 0, 7520, "vgnretail72", "solairwheel64", 0x00000000);
	tmpobjid = CreateDynamicObject(19872, 1692.796630, -1458.027587, 10.672801, 0.000000, 0.000000, 90.199996);
	SetDynamicObjectMaterial(tmpobjid, 0, 7520, "vgnretail72", "solairwheel64", 0x00000000);
	tmpobjid = CreateDynamicObject(19872, 1692.778686, -1453.056274, 10.672801, 0.000000, 0.000000, 90.199996);
	SetDynamicObjectMaterial(tmpobjid, 0, 7520, "vgnretail72", "solairwheel64", 0x00000000);
	tmpobjid = CreateDynamicObject(19872, 1671.218750, -1456.152343, 10.672801, 0.000000, 0.000000, 180.199996);
	SetDynamicObjectMaterial(tmpobjid, 0, 7520, "vgnretail72", "solairwheel64", 0x00000000);
	tmpobjid = CreateDynamicObject(19872, 1675.799560, -1456.136230, 10.672801, 0.000000, 0.000000, 180.199996);
	SetDynamicObjectMaterial(tmpobjid, 0, 7520, "vgnretail72", "solairwheel64", 0x00000000);

	CreateDynamicObject(1897, 1696.462280, -1463.621337, 12.673006, -54.999996, 0.000000, 270.000000);
	CreateDynamicObject(1080, 1696.943847, -1465.847778, 13.742817, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1080, 1696.943847, -1465.417358, 13.742817, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1080, 1696.943847, -1465.047119, 13.742817, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1080, 1696.943847, -1464.656982, 13.742817, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1080, 1696.943847, -1464.296630, 13.742817, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1327, 1698.466796, -1468.590576, 13.092814, 0.000000, 90.000000, -22.500007);
	CreateDynamicObject(1327, 1698.466796, -1468.590576, 12.512810, 0.000000, 90.000000, 0.000000);
	CreateDynamicObject(1327, 1698.466796, -1468.590576, 13.732815, 0.000000, 90.000000, -49.600025);
	CreateDynamicObject(1080, 1696.943847, -1463.926391, 13.742817, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1003, 1705.351806, -1469.048217, 12.552809, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(1003, 1702.721801, -1468.827758, 12.572918, -36.900012, 0.000000, 0.000000);
	CreateDynamicObject(1009, 1704.515502, -1468.825317, 13.322805, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(638, 1669.736816, -1460.837280, 13.252819, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1009, 1704.150512, -1468.695434, 13.332805, 0.000000, 0.000000, 127.599990);
	CreateDynamicObject(1010, 1702.935302, -1468.749267, 13.372820, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1010, 1702.604980, -1468.749267, 13.372820, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1010, 1702.104858, -1468.749267, 13.372820, 0.000000, 0.000000, 121.499977);
	CreateDynamicObject(1142, 1705.678466, -1468.684692, 14.122809, 0.000000, 0.000000, -16.399999);
	CreateDynamicObject(1142, 1705.172607, -1468.776000, 14.122809, 0.000000, 0.000000, -16.399999);
	CreateDynamicObject(1144, 1704.261474, -1468.930786, 14.122808, 0.000000, 0.000000, 58.299999);
	CreateDynamicObject(1144, 1703.599243, -1469.203369, 14.122808, 0.000000, 0.000000, 58.299999);
	CreateDynamicObject(2798, 1702.625366, -1468.914794, 14.152817, 90.000000, 41.499996, 0.000000);
	CreateDynamicObject(19921, 1701.282104, -1468.896850, 13.392809, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(1650, 1705.932006, -1468.737792, 13.652812, 0.000000, 0.000000, -135.500015);
	CreateDynamicObject(1650, 1705.701171, -1468.966796, 13.652812, 0.000000, 0.000000, -63.200012);
	CreateDynamicObject(1650, 1705.534057, -1468.609619, 13.652812, 0.000000, 0.000000, -114.500007);
	CreateDynamicObject(1116, 1701.203979, -1468.285034, 14.142808, 90.000000, 0.000000, 0.000000);
	CreateDynamicObject(1116, 1701.203979, -1468.619506, 14.331352, 121.599960, 0.000000, 0.000000);
	CreateDynamicObject(1897, 1696.462280, -1466.031616, 12.673006, -54.999996, 0.000000, 270.000000);
	CreateDynamicObject(941, 1705.999877, -1463.232543, 12.972811, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(2690, 1706.379638, -1467.357543, 12.912461, -0.099999, -0.200000, -86.399986);
	CreateDynamicObject(2690, 1706.351440, -1466.908447, 12.910889, -0.099999, -0.200000, -86.399986);
	CreateDynamicObject(2690, 1706.186157, -1467.149169, 12.912010, -0.099999, -0.200000, -86.399986);
	CreateDynamicObject(19815, 1706.578979, -1465.799194, 14.402810, 0.000000, 0.000000, -90.000000);
	CreateDynamicObject(11728, 1706.624633, -1464.072509, 14.362819, 0.000000, 0.000000, -90.000000);
	CreateDynamicObject(1010, 1706.014160, -1462.610107, 13.402812, 0.000000, 0.000000, 146.899993);
	CreateDynamicObject(19835, 1705.912109, -1463.239135, 13.552816, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(19483, 1702.377319, -1455.883789, 12.562807, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(1897, 1704.856201, -1451.949584, 16.342802, 90.000000, 0.000000, 0.000000);
	CreateDynamicObject(1897, 1698.085327, -1451.949584, 16.342802, 90.000000, 0.000000, 0.000000);
	CreateDynamicObject(1722, 1706.504882, -1458.593750, 12.562807, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1722, 1706.504882, -1458.043701, 12.562807, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1722, 1706.504882, -1457.473266, 12.562807, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1722, 1706.504882, -1456.902832, 12.562807, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1722, 1706.504882, -1456.342773, 12.562807, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(19903, 1702.820312, -1464.546752, 12.552811, 0.000000, 0.000000, -38.500000);
	CreateDynamicObject(19826, 1697.146118, -1451.040893, 13.922807, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(19325, 1693.127685, -1451.014892, 13.036890, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(19325, 1693.127685, -1451.014892, 17.156902, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(19325, 1686.775878, -1451.014892, 13.036890, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(19325, 1686.775878, -1451.014892, 17.126901, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(19325, 1677.435424, -1451.014892, 17.126901, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(19325, 1671.294555, -1451.014892, 17.126901, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(19325, 1671.294555, -1451.014892, 13.036899, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(19325, 1677.445800, -1451.014892, 13.036899, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(638, 1675.838134, -1460.837280, 13.252819, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1893, 1682.451171, -1456.296142, 18.812801, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1893, 1677.970825, -1456.296142, 18.812801, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1893, 1674.309814, -1456.296142, 18.812801, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1893, 1670.528930, -1456.296142, 18.812801, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1893, 1687.182495, -1456.296142, 18.812801, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1893, 1691.332641, -1456.296142, 18.812801, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1893, 1695.503295, -1456.296142, 18.812801, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1893, 1695.503295, -1465.566894, 18.812801, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1893, 1691.312377, -1465.566894, 18.812801, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1893, 1687.121582, -1465.566894, 18.812801, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1893, 1682.501342, -1465.566894, 18.812801, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1893, 1677.970703, -1465.566894, 18.812801, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1893, 1674.200195, -1465.566894, 18.812801, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1893, 1670.520019, -1465.566894, 18.812801, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1893, 1699.803344, -1456.296142, 18.812801, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1893, 1703.122680, -1456.296142, 18.812801, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1893, 1699.873657, -1465.566894, 18.812801, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1893, 1703.194091, -1465.566894, 18.812801, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1502, 1696.275512, -1454.882324, 12.552812, 0.000000, 0.000000, -90.000000);
	CreateDynamicObject(2173, 1693.656616, -1462.566650, 12.552811, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(2253, 1693.288452, -1462.886108, 13.592818, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(2253, 1693.288452, -1461.225952, 13.592818, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(19807, 1693.703369, -1462.826538, 13.502819, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(19564, 1693.334838, -1461.470214, 13.352812, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(2196, 1693.685791, -1461.484008, 13.342820, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(2485, 1693.740844, -1461.505615, 13.322813, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(1671, 1694.719604, -1462.041259, 12.972812, 0.000000, 0.000000, 270.000000);
	CreateDynamicObject(1671, 1692.429443, -1462.653686, 12.972812, 0.000000, 0.000000, 117.999954);
	CreateDynamicObject(1671, 1692.285034, -1461.348510, 12.972812, 0.000000, 0.000000, 52.699970);
	CreateDynamicObject(644, 1683.782958, -1449.932617, 12.866871, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(644, 1680.372802, -1449.932617, 12.866871, 0.000000, 0.000000, 0.000000);

	//tune shop++
	CreateDynamicObject(19458, 1682.227661, -1464.004760, 11.562800, 0.000000, 0.000000, 90.099884);
	CreateDynamicObject(19458, 1688.153320, -1465.676879, 8.444732, 89.899978, -0.700000, -179.800140);
	CreateDynamicObject(19458, 1688.131347, -1468.208129, 8.440316, 89.899978, -0.700000, -179.800140);
	CreateDynamicObject(19458, 1682.227661, -1464.004760, 11.562800, 0.000000, 0.000000, 90.099884);
	CreateDynamicObject(14394, 1683.808959, -1463.097412, 12.482813, 0.000000, -0.799999, -90.099967);
	CreateDynamicObject(19125, 1677.792602, -1464.222778, 13.442810, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(19125, 1687.813598, -1464.222778, 13.102807, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(19125, 1687.853759, -1469.644653, 13.102808, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(18653, 1677.967529, -1469.325561, 13.232810, 0.000000, 0.000000, -147.500076);
	CreateDynamicObject(2631, 1679.380249, -1466.990478, 13.288981, 0.000000, -0.600002, 0.100000);
	CreateDynamicObject(2631, 1679.369750, -1465.113281, 13.297826, 0.000000, -0.600002, 0.100000);
	CreateDynamicObject(2631, 1683.149658, -1465.161987, 13.329716, 0.000000, -0.600002, 0.400000);
	CreateDynamicObject(2631, 1685.865844, -1468.792480, 13.357883, 0.000000, -0.600002, 0.400000);
	CreateDynamicObject(2631, 1685.858886, -1465.140869, 13.358096, 0.000000, -0.600002, 0.400000);
	CreateDynamicObject(2631, 1685.863159, -1467.109863, 13.357991, 0.000000, -0.600002, 0.400000);
	CreateDynamicObject(2631, 1683.163574, -1467.160400, 13.329717, 0.000000, -0.600002, 0.400000);
	CreateDynamicObject(2631, 1679.373413, -1468.838134, 13.289925, 0.000000, -0.600002, 0.400000);
	CreateDynamicObject(2631, 1683.175292, -1468.811279, 13.329717, 0.000000, -0.600002, 0.400000);
	CreateDynamicObject(19458, 1687.791015, -1468.205078, 8.440320, 89.899978, -0.700000, -179.800140);
	CreateDynamicObject(19458, 1682.377197, -1464.114746, 11.562800, 0.000000, 0.000000, 88.999900);
	CreateDynamicObject(19458, 1687.792968, -1465.673950, 8.444734, 89.899978, -0.700000, -179.800140);
	
	//Gun Game
	CreateDynamicObject(19313, 1559.335327, 1917.478393, 13.210295, 0.000000, 0.000000, -83.300010);
	CreateDynamicObject(19313, 1557.695678, 1931.431762, 13.210295, 0.000000, 0.000000, -83.300010);
	CreateDynamicObject(5821, 1565.801391, 1931.984008, 9.590299, 0.000000, 0.000000, -84.899971);
	CreateDynamicObject(3593, 1664.893920, 1973.995117, 11.510308, 0.000000, 0.000000, -57.699989);
	CreateDynamicObject(3475, 1670.025146, 1999.335449, 14.160312, 0.000000, 0.000000, -88.299987);
	CreateDynamicObject(3475, 1664.027099, 1999.158203, 14.160312, 0.000000, 0.000000, -88.299987);
	CreateDynamicObject(19608, 1568.263793, 1891.517089, 9.920308, 0.000000, 0.000000, 178.800109);
	CreateDynamicObject(19339, 1568.392700, 1892.631835, 10.360308, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(3475, 1579.815307, 1961.267822, 13.330307, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(3475, 1579.815307, 1967.077636, 13.330307, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(3475, 1579.815307, 1972.937744, 13.330307, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(3475, 1565.023925, 1888.570556, 13.380311, 0.000000, 0.000000, -90.100028);
	CreateDynamicObject(3475, 1570.844970, 1888.560913, 13.380311, 0.000000, 0.000000, -90.100028);
	CreateDynamicObject(3406, 1563.729858, 1925.043823, 11.360321, 0.000000, 0.000000, -81.499984);
	CreateDynamicObject(3515, 1630.770385, 1944.976440, 9.265646, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(3475, 1627.979614, 1888.375976, 13.190312, 0.000000, 0.000000, -89.999946);
	CreateDynamicObject(19313, 1557.695678, 1931.431762, 13.210294, 0.000000, 0.000000, -83.300010);
	CreateDynamicObject(19313, 1559.335327, 1917.478393, 13.210294, 0.000000, 0.000000, -83.300010);
	CreateDynamicObject(5821, 1565.801391, 1931.984008, 9.590298, 0.000000, 0.000000, -84.899971);
	CreateDynamicObject(13591, 1666.453979, 1972.512451, 10.700311, 0.000000, 0.000000, -39.999996);
	CreateDynamicObject(18251, 1671.521362, 1933.388916, 18.820297, 0.000000, 0.000000, -179.800064);
	CreateDynamicObject(3515, 1609.779296, 1945.646728, 9.265646, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(19870, 1674.318115, 1923.104614, 12.924360, 0.000000, 0.000000, -92.599945);
	CreateDynamicObject(3475, 1622.109619, 1888.375976, 13.190312, 0.000000, 0.000000, -89.999946);

	//Easter eggs
	CreateDynamicObject(3524, 818.590881, -1092.026733, 24.101152, 0.000000, 0.000000, 0.000000); 
	CreateDynamicObject(3524, 812.470703, -1092.026733, 24.101152, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(19056, 815.564025, -1093.239379, 25.370080, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(19056, 393.374176, -2055.077148, 13.425203, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(18655, 396.289916, -2055.139648, 12.046230, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(19056, 1117.794311, -2037.017333, 78.420944, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(18655, 1118.433227, -2034.062988, 76.816551, 0.000000, 0.000000, 81.000000);
	CreateDynamicObject(19056, 1415.894042, -807.208984, 84.596931, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(18655, 1418.925415, -806.281127, 83.828819, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(18655, 1412.563842, -806.281127, 83.828819, 0.000000, 0.000000, 172.299987);
	CreateDynamicObject(19056, 2940.310302, -2051.727050, 3.198043, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(18655, 2940.539550, -2054.636962, 2.008044, 0.000000, 0.000000, -79.899978);

	/*//Hunting pack  //By xCrafter [MAP_FORCE] owner
	tmpobjid = CreateDynamicObject(18753, 37.706542, 1794.517333, 127.719238, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 162.703125, 1794.517333, 127.719238, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 287.702392, 1794.517333, 127.719238, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 287.702392, 1919.515747, 127.719238, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 287.702392, 2044.513793, 127.719238, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 287.702148, 2169.512207, 127.719238, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 287.702148, 2294.507568, 127.719238, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, -87.282226, 1794.517333, 127.719238, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, -150.189941, 1794.517333, 83.129150, 0.000000, 90.000000, 180.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, -212.187988, 1794.517333, 146.129516, 0.000000, 180.000000, 180.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, -337.177246, 1794.517333, 146.129516, 0.000000, 180.000000, 180.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, -337.177246, 1794.517333, 146.129516, 0.000000, 180.000000, 180.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, -462.175781, 1794.517333, 146.129516, 0.000000, 180.000000, 180.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, -587.153320, 1794.517333, 146.129516, 0.000000, 180.000000, 180.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 412.701660, 2294.507568, 127.719238, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 537.700927, 2294.507568, 127.719238, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 662.689697, 2294.507568, 127.719238, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 703.515625, 2294.507568, 129.611206, -4.800002, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 828.240722, 2294.507568, 134.849243, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 828.240722, 2169.527832, 134.849243, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 828.240722, 2044.540649, 134.849243, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 828.240722, 1919.551513, 134.849243, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 828.240722, 1794.562622, 134.849243, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 953.230468, 1794.562622, 134.849243, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1078.229980, 1794.562622, 134.849243, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1078.229980, 1794.562622, 134.849243, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1203.209472, 1794.562622, 134.849243, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1292.132812, 1794.562622, 143.142211, -10.099989, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 662.689697, 2294.507568, 127.719238, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1436.350097, 1794.562622, 127.189392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1561.346801, 1794.562622, 127.189392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1686.335571, 1794.562622, 127.189392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1811.333984, 1794.562622, 127.189392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1811.333984, 1919.562011, 127.189392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1811.333984, 2044.542968, 127.189392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1686.335205, 2044.542968, 127.189392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1561.337158, 2044.542968, 127.189392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1436.337646, 2044.542968, 127.189392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1311.348999, 2044.542968, 127.189392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1186.368408, 2044.542968, 127.189392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1186.368408, 2044.542968, 127.189392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18815, 1162.034790, 2044.144897, 102.763374, 0.000000, 0.000000, 0.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_whiteplaster_top", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "ws_whiteplaster_top", 0xFFFF009E);
	tmpobjid = CreateDynamicObject(18753, 1189.458007, 2044.542968, 65.229354, 0.000000, 90.000000, 180.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1134.407226, 2044.542968, 65.229354, 0.000000, 90.000000, 180.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1134.407226, 2044.542968, 65.229354, 0.000000, 90.000000, 180.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1311.348999, 1982.284301, 68.999481, 0.000000, 90.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1436.338378, 1982.324340, 68.999481, 0.000000, 90.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1601.499145, 1982.394409, 68.999481, 0.000000, 90.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1686.327514, 1982.425415, 69.000480, 0.000000, 90.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1311.348999, 2106.584960, 68.999481, 0.000000, 90.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1436.338745, 2106.584960, 68.999481, 0.000000, 90.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1601.441284, 2106.584960, 68.999481, 0.000000, 90.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1726.430175, 2106.584960, 68.999481, 0.000000, 90.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1811.321533, 2106.585937, 69.000480, 0.000000, 90.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1873.360595, 2044.566528, 69.000480, 0.000000, 90.000000, 180.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1873.360595, 1883.397094, 69.000480, 0.000000, 90.000000, 180.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1748.359008, 1920.527221, 69.000480, 0.000000, 90.000000, 180.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1686.359008, 1857.546752, 69.000480, 0.000000, 90.000000, 270.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1873.361572, 1794.638916, 69.001480, 0.000000, 90.000000, 180.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1811.351440, 1732.549194, 69.001480, 0.000000, 90.000000, 270.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1638.831054, 1732.549194, 69.001480, 0.000000, 90.000000, 270.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1513.852661, 1732.549194, 69.001480, 0.000000, 90.000000, 270.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1513.852661, 1856.640136, 69.001480, 0.000000, 90.000000, 270.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1291.354614, 1856.640136, 107.661468, 0.000000, 90.000000, 270.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1291.354614, 1732.238159, 107.661468, 0.000000, 90.000000, 270.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1115.683959, 1732.238159, 78.081520, 0.000000, 90.000000, 270.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 1115.683959, 1856.669555, 78.081520, 0.000000, 90.000000, 270.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 990.703430, 1856.669555, 78.081520, 0.000000, 90.000000, 270.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 990.703430, 1732.238525, 78.081520, 0.000000, 90.000000, 270.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 865.753234, 1732.238525, 78.081520, 0.000000, 90.000000, 270.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 828.225708, 1732.241455, 78.081520, 0.000000, 90.000000, 270.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 766.185791, 1794.321899, 78.081520, 0.000000, 90.000000, 360.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 766.185791, 1919.319580, 78.081520, 0.000000, 90.000000, 360.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 766.185791, 2044.319946, 78.081520, 0.000000, 90.000000, 360.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 766.185791, 2169.289062, 78.081520, 0.000000, 90.000000, 360.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 704.176330, 2231.550781, 78.081520, 0.000000, 90.000000, 450.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 537.657043, 2356.730468, 70.631515, 0.000000, 90.000000, 450.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 412.636840, 2231.550781, 78.081520, 0.000000, 90.000000, 450.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 412.701660, 2344.266113, 126.345100, 0.000000, -6.200000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 287.731384, 2344.266113, 126.345100, 0.000000, -6.200000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 412.636840, 2405.992431, 78.081520, 0.000000, 90.000000, 450.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 287.646545, 2405.992431, 78.081520, 0.000000, 90.000000, 450.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 224.847259, 2295.116455, 70.941528, 0.000000, 90.000000, 540.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 224.846252, 2218.995117, 70.941528, 0.000000, 90.000000, 540.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 350.606079, 2169.476318, 70.941528, 0.000000, 90.000000, 540.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 350.606079, 2044.496582, 70.941528, 0.000000, 90.000000, 540.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 350.606079, 1862.456665, 70.941528, 0.000000, 90.000000, 540.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 350.606079, 1862.456665, 70.941528, 0.000000, 90.000000, 540.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 224.846252, 2093.999755, 70.941528, 0.000000, 90.000000, 540.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 224.846252, 1969.011840, 70.941528, 0.000000, 90.000000, 540.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 224.848266, 1919.363769, 70.941528, 0.000000, 90.000000, 540.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 162.838165, 1857.253295, 70.941528, 0.000000, 90.000000, 630.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 37.848167, 1857.253295, 70.941528, 0.000000, 90.000000, 630.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, -87.141746, 1857.253295, 70.941528, 0.000000, 90.000000, 630.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, -87.141746, 1731.723876, 70.941528, 0.000000, 90.000000, 630.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 37.848289, 1731.723876, 70.941528, 0.000000, 90.000000, 630.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 662.656494, 2356.730468, 70.631515, 0.000000, 90.000000, 450.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 287.838104, 1731.723876, 70.941528, 0.000000, 90.000000, 630.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 350.618286, 1793.732788, 70.941528, 0.000000, 90.000000, 720.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 579.176940, 2231.550781, 78.081520, 0.000000, 90.000000, 450.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 787.656005, 2356.730468, 123.131507, 0.000000, 90.000000, 450.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 828.310180, 2356.733398, 123.131507, 0.000000, 90.000000, 450.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 890.798156, 2295.515625, 123.131507, 0.000000, 90.000000, 540.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 890.798156, 2170.518310, 78.211471, 0.000000, 90.000000, 540.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 890.798156, 2128.418701, 78.211471, 0.000000, 90.000000, 540.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 890.798156, 2003.438720, 78.211471, 0.000000, 90.000000, 540.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 890.799133, 1919.568725, 78.211471, 0.000000, 90.000000, 540.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, 952.788208, 1856.666625, 78.211471, 0.000000, 90.000000, 630.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, -212.121780, 1857.253295, 103.261535, 0.000000, 90.000000, 630.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, -337.101715, 1857.253295, 103.261535, 0.000000, 90.000000, 630.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, -462.061584, 1857.253295, 103.261535, 0.000000, 90.000000, 630.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, -587.061218, 1857.253295, 103.261535, 0.000000, 90.000000, 630.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, -649.871093, 1794.664306, 103.261535, 0.000000, 90.000000, 720.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, -587.601806, 1732.303100, 103.261535, 0.000000, 90.000000, 810.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, -462.601745, 1732.303100, 103.261535, 0.000000, 90.000000, 810.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, -337.631561, 1732.303100, 103.261535, 0.000000, 90.000000, 810.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18753, -212.631423, 1732.303100, 103.261535, 0.000000, 90.000000, 810.000000, 103406, -1, -1 1000.00, 1000.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6102, "gazlaw1", "law_gazwhitefloor", 0xFFFF009E);
	SetDynamicObjectMaterial(tmpobjid, 1, 6102, "gazlaw1", "law_gazwhitefloor", 0x00000000);

	tmpobjid = CreateDynamicObject(19425, 1133.437866, 1983.702636, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 1987.002075, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 1990.291625, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 1993.581420, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 1996.881103, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2000.181396, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2003.481201, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2006.780029, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2010.080078, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2013.369628, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2016.659423, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2019.958984, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2023.259399, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2026.559448, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2029.848754, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2033.138793, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2036.429565, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2039.719848, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2043.009521, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2046.309570, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2049.610107, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2052.909667, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2056.199218, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2059.468994, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2062.769287, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2066.060058, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2069.339843, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2072.630859, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2075.930664, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2079.230712, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2082.530761, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2085.830810, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2089.130859, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2095.730957, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2092.430908, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2099.031005, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2102.331054, 127.689392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00); 
	tmpobjid = CreateDynamicObject(19425, 1133.437866, 2105.380859, 127.688392, 0.000000, 0.000000, 90.000000, 103406, -1, -1 1000.00, 1000.00);*/
	return 1;
}

GetLastGangID()
{
	for(new i = 0; i < MAX_GANGS; i++)
	{
		if(isequal(GANGINFO[i][gname], "-1")) return i;
	}
	print("[ LGGW ] There's a problem in `GetLastGangID`");
	return -1;
}

IsValidGang(g_id)
{
	if(!isequal(GANGINFO[g_id][gname], "-1")) return true;
	return false;
}

IsPlayerInZone(playerid, zoneid)
{
	if(IsPlayerInDynamicArea(playerid, DZONEID[zoneid]) && !IsPlayerInAnyVehicle(playerid) && GetPlayerInterior(playerid) == 0 && IsPlayerSpawned(playerid) && !IsPlayerInClassSelection(playerid) && GetPlayerVirtualWorld(playerid) == 0 && GetPlayerState(playerid) != PLAYER_STATE_WASTED && GetPlayerState(playerid) != PLAYER_STATE_SPECTATING) return true;
	return false;
}

PVehIs2ColorVehicle(modelid)
{
	switch(modelid)
	{
		case 541: return true;
		case 471: return true;
		case 462: return true;
		case 463: return true; 
	}
	return false;
}

PVehIsPaintjobAvailable(modelid)
{
	switch(modelid)
	{
		case 567: return true;
		case 534: return true;
		case 558: return true;
		case 560: return true;
		case 562: return true;
	}
	return false;
}

PVehIsBike(modelid)
{
	switch(modelid)
	{
		case 471: return true;
		case 462: return true;
		case 463: return true;
		case 468: return true;
		case 461: return true;
		case 581: return true;
		case 521: return true;
	}
	return false;
}

SetVehicleRealData(playerid) 
{ 
	if(IsValidObject(editvneon[playerid][0])) DestroyObject(editvneon[playerid][0]);
	if(IsValidObject(editvneon[playerid][1])) DestroyObject(editvneon[playerid][1]);
	if(IsValidObject(editvneon[playerid][2])) DestroyObject(editvneon[playerid][2]);
	if(IsValidObject(vehneon[priveh[playerid]][0])) DestroyObject(vehneon[priveh[playerid]][0]);
	if(IsValidObject(vehneon[priveh[playerid]][1])) DestroyObject(vehneon[priveh[playerid]][1]);
	if(IsValidObject(vehneon[priveh[playerid]][2])) DestroyObject(vehneon[priveh[playerid]][2]);
	RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1087);
	RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1008);
	RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1009);
	RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1010); 
	ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), USERINFO[playerid][vpjob]);
	AddVehicleComponent(GetPlayerVehicleID(playerid), USERINFO[playerid][vwheel]);
	if(USERINFO[playerid][vhydra] == 1) AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);
	if(USERINFO[playerid][vnitro] != -1) AddVehicleComponent(GetPlayerVehicleID(playerid), USERINFO[playerid][vnitro]);
	ChangeVehicleColor(GetPlayerVehicleID(playerid), USERINFO[playerid][vcolor_1], USERINFO[playerid][vcolor_2]);
	if(USERINFO[playerid][vneon_1] == 1)
	{
		vehneon[priveh[playerid]][0] = CreateObject(18651,0,0,0,0,0,0); 
		vehneon[priveh[playerid]][1] = CreateObject(18651,0,0,0,0,0,0);
		AttachObjectToVehicle(vehneon[priveh[playerid]][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		AttachObjectToVehicle(vehneon[priveh[playerid]][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	}
	if(USERINFO[playerid][vneon_2] == 1)
	{ 
		vehneon[priveh[playerid]][2] = CreateObject(18646,0,0,0,0,0,0);
		AttachObjectToVehicle(vehneon[priveh[playerid]][2], GetPlayerVehicleID(playerid), 0.0, -0.35, 0.90, 0.0, 0.0, 0.0);
	} 
	remneons[playerid] = 0;        
	return 1;
}

DestroyPrivateVehicle(playerid)
{
	if(IsValidObject(vehneon[priveh[playerid]][0])) DestroyObject(vehneon[priveh[playerid]][0]); 
	if(IsValidObject(vehneon[priveh[playerid]][1])) DestroyObject(vehneon[priveh[playerid]][1]); 
	if(IsValidObject(vehneon[priveh[playerid]][2])) DestroyObject(vehneon[priveh[playerid]][2]); 
	RemoveVehicleComponent(priveh[playerid], 1087);
	RemoveVehicleComponent(priveh[playerid], 1008);
	RemoveVehicleComponent(priveh[playerid], 1009);  
	RemoveVehicleComponent(priveh[playerid], 1010);
	Delete3DTextLabel(vehlabel[priveh[playerid]]);
	vehowner[priveh[playerid]] = INVALID_PLAYER_ID;
	vehowned[priveh[playerid]] = 0;
	Delete3DTextLabel(vehlabel[priveh[playerid]]);
	DestroyVehicle(priveh[playerid]);
    priveh[playerid] = INVALID_VEHICLE_ID;
	return 1;
}

ModifyTuneShopTextDraws(playerid, str[])
{
	TextDrawShowForPlayer(playerid, vtunetd[0]);
	TextDrawShowForPlayer(playerid, vtunetd[1]);
	TextDrawShowForPlayer(playerid, vtunetd[2]);

	PlayerTextDrawShow(playerid, vtunetd_1[playerid]);

	PlayerTextDrawSetString(playerid, vtunetd_1[playerid], str);

	SelectTextDraw(playerid, 0x80800066);
	return 1;
}

HideTextDraws(playerid)
{
	TextDrawHideForPlayer(playerid, vtunetd[0]);
	TextDrawHideForPlayer(playerid, vtunetd[1]);
	TextDrawHideForPlayer(playerid, vtunetd[2]);

	PlayerTextDrawHide(playerid, vtunetd_1[playerid]);

	CancelSelectTextDraw(playerid);
	return 1;
}

GangLevelName(level)
{
	new str[20];
	switch(level)
	{
		case 1: format(str, sizeof(str), "%s", "Thug");
		case 2: format(str, sizeof(str), "%s", "Warrior");
		case 3: format(str, sizeof(str), "%s", "Under-Boss");
		case 4: format(str, sizeof(str), "%s", "Boss");
	}
	return str;
}

SendToAdmins(color, text[], level)
{
	foreach(new j : Player)
	{
		if(USERINFO[j][plevel] >= level)
		{
			SendClientMessage(j, color, text);
		}
	} 
	return 1;
}

GameTextForAdmins(text[], time, style)
{
	foreach(new j : Player)
	{
		if(USERINFO[j][plevel] > 0)
		{
			GameTextForPlayer(j, text, time, style);
		}
	}
	return 1;
}

WriteLog(const LogFile[], formattext[], va_args<>)
{
	new logyear, logmonth, logdate, loghour, logminute, logsecond; 
	new text[512]; 
	new File:FILE = fopen(LogFile, io_append);
	va_format(text, sizeof(text), formattext, va_start<2>);
	gettime(loghour, logminute, logsecond);
	getdate(logyear, logmonth, logdate);
	new done[550];
	format(done, sizeof(done), "[%d:%d:%d | %d:%d:%d] %s\r\n", logdate, logmonth, logyear, loghour, logminute, logsecond, text);
	fwrite(FILE, done);
	fclose(FILE);
	return 1;
}

GetVehicleName(vehihcleid)
{
	new str[56];
	format(str, sizeof(str), VehicleNames[GetVehicleModel(vehihcleid)- 400]);
	return str;
}

PlayerName(playerid)
{
	new name[MAX_PLAYER_NAME]; 
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

PlayerIP(playerid)
{
	new pip[30];  
	GetPlayerIp(playerid, pip, sizeof(pip));
	return pip;
}

GunName(id)
{
	new N_ame[50];
	if(id == 0) format(N_ame, sizeof(N_ame), "%s", "None");
	else GetWeaponName(id, N_ame, sizeof(N_ame));
	return N_ame;
}

GetDuelPlaceName(id)
{
	new str[20];
	if(id < 0 || id > 3) print("[ERROR] Invalid duel place ID found in the script");
	switch(id)
	{
		case 0:format(str, sizeof(str), "%s", "LV Stadium");
		case 1:format(str, sizeof(str), "%s", "Warehouse");
		case 2:format(str, sizeof(str), "%s", "RC Battlefield");
		case 3:format(str, sizeof(str), "%s", "Bloodbowl");
	}
	return str;
}

GetPlayerDetails(playerid)
{
	new weapid, weapammo;
	for(new l, j = 0; l < 13; l++)
	{
		GetPlayerWeaponData(playerid, l, weapid, weapammo);
		if(weapid != 0)
		{
			WEAPS[playerid][0][j] = weapid;
			WEAPS[playerid][1][j] = weapammo;
			j++;
		}
	}
	GetPlayerPos(playerid, DX[playerid], DY[playerid], DZ[playerid]);
	COLOR[playerid] = GetPlayerColor(playerid);
	GetPlayerHealth(playerid, HP[playerid]);
	GetPlayerArmour(playerid, ARMOUR[playerid]);
	INT[playerid] = GetPlayerInterior(playerid);
	VW[playerid] = GetPlayerVirtualWorld(playerid);
	TEAM[playerid] = GetPlayerTeam(playerid);
	SKIN[playerid] = GetPlayerSkin(playerid);
	GetPlayerFacingAngle(playerid, FA[playerid]);
	return 1;
}

SetPlayerDetails(playerid)
{
	for(new k = 0; k < sizeof(WEAPS[][]); k++)
	{
		GivePlayerWeapon(playerid, WEAPS[playerid][0][k], WEAPS[playerid][1][k]);
	}
	SetPlayerTeam(playerid, TEAM[playerid]);
	SetPlayerPos(playerid, DX[playerid], DY[playerid], DZ[playerid]);
	SetPlayerInterior(playerid, INT[playerid]);
	SetPlayerVirtualWorld(playerid, VW[playerid]);
	SetPlayerFacingAngle(playerid,FA[playerid]);
	SetPlayerHealth(playerid, HP[playerid]);
	SetPlayerArmour(playerid, ARMOUR[playerid]);
	SetPlayerColor(playerid, COLOR[playerid]);
	SetPlayerSkin(playerid, SKIN[playerid]);
	return 1;
}

GetPlayersInZone(zoneid, teamid)
{
	new count;
	foreach(new j : Player)
	{
		if(GetPlayerTeam(j) == teamid && IsPlayerInZone(j, zoneid))
		{
			count++;
		}
	}
	return count;
}

GetTeamName(teamid) 
{
	new str[50];
	switch(teamid)
	{
		case TEAM_GROVE: format(str, sizeof(str), "%s", "Grove_street");
		case TEAM_BALLAS: format(str, sizeof(str), "%s", "Ballas");
		case TEAM_VAGOS: format(str, sizeof(str), "%s", "Vagos");
		case TEAM_AZTECA: format(str, sizeof(str), "%s", "Azteca");
		case TEAM_JUSTICE: format(str, sizeof(str), "%s", "Justice");
		case TEAM_MAFIA: format(str, sizeof(str), "%s", "Russian_mafia");
		case TEAM_VIP: format(str, sizeof(str), "%s", "VIP");
	}
	return str;
}

GetTeamColor(teamid)
{
	switch(teamid)
	{
		case TEAM_GROVE: return COLOR_GROVE;
		case TEAM_BALLAS: return COLOR_BALLAS;
		case TEAM_VAGOS: return COLOR_VAGOS;
		case TEAM_AZTECA: return COLOR_AZTECA;
		case TEAM_JUSTICE: return COLOR_JUSTICE;
		case TEAM_MAFIA: return COLOR_MAFIA;
		case TEAM_VIP: return COLOR_VIP;
	}
	return 1;
}

GetTeamTag(teamid)
{
	new str[50];
	switch(teamid)
	{
		case TEAM_GROVE: format(str, sizeof(str), "%s", "GS");
		case TEAM_BALLAS: format(str, sizeof(str), "%s", "BS");
		case TEAM_VAGOS: format(str, sizeof(str), "%s", "VG");
		case TEAM_AZTECA: format(str, sizeof(str), "%s", "AZT");
		case TEAM_JUSTICE: format(str, sizeof(str), "%s", "JTC");
		case TEAM_MAFIA: format(str, sizeof(str), "%s", "RM");
		case TEAM_VIP: format(str, sizeof(str), "%s", "VIP");
	}
	return str;
}

SaveServerData()
{
	foreach(new i : Player)
	{
		SavePlayerData(i);
	}
	SaveGangData();
	SaveHouseData();
	SaveZoneData();
	return 1;
}

SavePlayerData(playerid)
{
	if(logged[playerid] == 1)
	{
		new Float:ratio;
		new str[1500], str1[350];
		if(USERINFO[playerid][pdeaths] == 0) ratio = 0.00;
		else ratio = floatdiv(USERINFO[playerid][pkills], USERINFO[playerid][pdeaths]);
		
		mysql_format(Database, str1, sizeof(str1), 
		"UPDATE `Users` SET `Level` = %d`, VIP` = %d, `Cash` = %d, `Kills` = %d`, Deaths` = %d, `Ratio` = %f,\
		`Block_PM` = %d, `Revenges` = %d, `Brutal_kills` = %d`, `Highest_rampage` = %d, `Robberies` = %d, ",
		USERINFO[playerid][plevel], USERINFO[playerid][VIP], USERINFO[playerid][pcash], USERINFO[playerid][pkills], USERINFO[playerid][pdeaths], 
		ratio, USERINFO[playerid][blockpm], USERINFO[playerid][revenges], USERINFO[playerid][bkills], USERINFO[playerid][bramp], USERINFO[playerid][robbs]);
		strcat(str, str1, sizeof(str));

		mysql_format(Database ,str1, sizeof(str1), 
		"`Head_shots` = %d`, Play_time` = %d, `Duels_played` = %d, `Duels_won` = %d, `Duel_place_ID` = %d`, \
		`Duel_weapon_1` = %d, `Duel_weapon_2` = %d, `Duel_weapon_3` = %d, `Duel_bet` = %d, `LMS_plalyed` = %d`, LMS_won` = %d, ",                                                                                                                
		USERINFO[playerid][hshots], USERINFO[playerid][ptime], USERINFO[playerid][dplayed], USERINFO[playerid][dwon], USERINFO[playerid][dplace], 
		USERINFO[playerid][dwep1], USERINFO[playerid][dwep2], USERINFO[playerid][dwep3], USERINFO[playerid][dbet], USERINFO[playerid][lmsplayed], 
		USERINFO[playerid][lmswon]);
		strcat(str, str1, sizeof(str));

		mysql_format(Database ,str1, sizeof(str1), 
		"`GunGames_played` = %d, `GunGames_won` = %d, `Vehicle_owned` = %d, `Vehicle_model` = %d, `Vehicle_wheel` = %d, `Vehicle_color_1` = %d, \
		`Vehicle_color_2` = %d, `Vehicle_neon_1` = %d,  `Vehicle_neon_2` = %d,  `Vehicle_paintjob` = %d,  `Vehicle_nitro` = %d, ", 
		USERINFO[playerid][ggp] , USERINFO[playerid][ggw], USERINFO[playerid][vowned], USERINFO[playerid][vmodel], USERINFO[playerid][vwheel], USERINFO[playerid][vcolor_1], 
		USERINFO[playerid][vcolor_2], USERINFO[playerid][vneon_1], USERINFO[playerid][vneon_2], USERINFO[playerid][vpjob], USERINFO[playerid][vnitro]);
		strcat(str, str1, sizeof(str));

		mysql_format(Database ,str1, sizeof(str1), 
	    "`Vehicle_hydraulics` = %d, `In_gang` = %d,`Gang_ID` = %d, `Gang_level` = %d,`Gang_skin` = %d, `Banned` = %d, `Jailed` = %d, \
	    `Unjail_time` = %d, `Muted` = %d,  `Unmute_time` = %d WHERE `User_ID` = %d LIMIT 1",  
	    USERINFO[playerid][vhydra], USERINFO[playerid][ingang], USERINFO[playerid][gid], USERINFO[playerid][glevel], USERINFO[playerid][gskin], USERINFO[playerid][banned], 
	    USERINFO[playerid][jailed], USERINFO[playerid][jailtime], USERINFO[playerid][muted], USERINFO[playerid][mutetime]);
		strcat(str, str1, sizeof(str));

		mysql_tquery(Database, str);
	}
	return 1;
}

SaveGangData()
{
	new str[256];
	for(new g = 0; g < MAX_GANGS; g++)
	{
		if(IsValidGang(g))
		{
			mysql_format(Database, str, sizeof(str), 
			"UPDATE `gangs` SET `Name` = %e,\
			`Tag` = %e,\
			`Color` = %d,\
			`HQ` = %d\
			`HQ_ID` = %d,\
			`Kills` = %d,\
			`Deaths` = %d,\
			`Score` = %d,\
			`Turfs` = %d \
			WHERE `Gang_ID` = %d", GANGINFO[g][gname], GANGINFO[g][gtag],  GANGINFO[g][ghouse],  GANGINFO[g][ghouseid],  GANGINFO[g][gkills],
			GANGINFO[g][gdeaths], GANGINFO[g][gscore], GANGINFO[g][gturfs], g + 1);
		}
	}
	return 1;
}


SaveHouseData()
{
	new str[128];
	for(new h = 0; h < sizeof(HOUSEINFO); h++)
	{
		mysql_format(Database, str, sizeof(str), 
		"UPDATE `Houses` \
		SET `House_owned` = %d,\
		`House_owned_team_ID` = %d,\
		WHERE `House_ID` = %d", HOUSEINFO[h][howned], HOUSEINFO[h][hteamid],  h + 1);
		mysql_tquery(Database, str);
	}
	return 1;
}

SaveZoneData()
{
	new str[128];
	for(new z = 0; z < sizeof(ZONEINFO); z++)
	{
		mysql_format(Database, str, sizeof(str), 
		"UPDATE `Zones` \
		SET `Zone_owned_team_ID` = %d,\
		WHERE `Zone_ID` = %d", ZONEINFO[z][zteamid], z + 1);
		mysql_tquery(Database, str);
	}
	return 1;
}

stock HexToInt(string[])
{
    if (string[0] == 0)
    {
        return 0;
    }
    new j;
    new cur = 1;
    new res = 0;
    for (j = strlen(string); j > 0; j--)
    {
        if (string[j-1] < 58)
        {
            res = res + cur * (string[j - 1] - 48);
        }
        else
        {
            res = res + cur * (string[j-1] - 65 + 10);
            cur = cur * 16;
        }
    }
    return res;
}

ResetPlayerVars(playerid)
{
	USERINFO[playerid][onduty] = 0;
	justconnected[playerid] = 1;
	killinginprogress[playerid] = 0;
	inlms[playerid] = 0;
	grequested[playerid] = 0;
	inanim[playerid] = 0;
	indm[playerid] = 0;
	ingg[playerid] = 0;
	inminigame[playerid] = 0;
	duelinvited[playerid] = 0;
	duelinviter[playerid] = 0;
	induel[playerid] = 0;
	warns[playerid] = 0;
	revenge[playerid] = 0;
	nocmd[playerid] = 0;
	class_selected[playerid] = 0;
	class_gselection[playerid] = 0;
	class_saved[playerid] = -1;
	logged[playerid] = 0;
	pDrunkLevelLast[playerid] = 0;
	pFPS[playerid] = 0;
	rampage[playerid] = 0;
	adm_id[playerid] = -1;
	spec[playerid] = 0;
	specid[playerid] = -1;
	format(lastmsg[playerid], 256, "%s", "");
	return 1;
}

GetFreeAdminID()
{
	new used = -1, val = -1;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		foreach(new j : Player)
		{
			if(adm_id[j] == i) used = 1;
		}

		if(used == -1)
		{
			val = i;
			break;
		}
		used = -1;
	}
	return val;
}

IsPlayerBanned(name[])
{
	new str[128];
	mysql_format(Database, str, sizeof(str), "SELECT * FROM Users WHERE `Name` = '%e' LIMIT 1", name);
	mysql_query(Database, str);
	new ban;
	cache_get_value_name_int(0, "Banned", ban);
	return ban;
}

BanPlayer(name[], now_online = 1)
{
	new id, str_[128], key_;
	mysql_format(Database, str_, sizeof(str_), "SELECT * FROM Users WHERE `Name` = '%e' LIMIT 1", name);
	mysql_query(Database, str_);
	cache_get_value_name_int(0, "User_ID", key_);
	mysql_format(Database, str_, sizeof(str_), "UPDATE `Users` SET `Banned` = '1' WHERE `User_ID` = %d ", key_);
	mysql_query(Database, str_);
	mysql_format(Database, str_, sizeof(str_), "SELECT * FROM IPs WHERE `User_ID` = '%e' LIMIT 1", name);
	mysql_query(Database, str_);
	new ip[50];
	for(new p = 0; p < MAX_IP_SAVES; p++)
	{
		
		format(str_, sizeof(str_), "IP_%i", p + 1);
		cache_get_value_name(0, str_, ip, sizeof(ip));
		format(str_, sizeof(str_),"banip %s", ip);
		SendRconCommand(str_);
	}

	if(now_online == 1)
	{	
		for(new k = 0; k < MAX_PLAYERS; k++)
		{
			if(isequal(name, PlayerName(k), true))
			{
				id = k;
			}
		}
		USERINFO[id][banned] = 1;
		SetTimerEx("Delay_Kick", 500, false, "i", id);
	}
	return 1;
}

UnbanPlayer(name[])
{
	new str_[128];
	new key_;
	mysql_format(Database, str_, sizeof(str_), "SELECT * FROM Users WHERE `Name` = '%e' LIMIT 1", name);
	mysql_query(Database, str_);
	cache_get_value_name_int(0, "User_ID", key_);
	mysql_format(Database, str_, sizeof(str_), "UPDATE `Users` SET `Banned` = '0' WHERE `User_ID` = %d ", key_);
	mysql_query(Database, str_);
	mysql_format(Database, str_, sizeof(str_), "SELECT * FROM IPs WHERE `User_ID` = '%e' LIMIT 1", name);
	mysql_query(Database, str_);
	new ip[50];
	for(new p = 0; p < MAX_IP_SAVES; p++)
	{
		format(str_, sizeof(str_), "IP_%i", p + 1);
		cache_get_value_name(0, str_, ip, sizeof(ip));
		format(str_, sizeof(str_),"unbanip %s", ip);
		SendRconCommand(str_);
	}
	SendRconCommand("reloadbans");
	return 1;
}

//Publics
public OnGameModeInit()
{
	AntiDeAMX();

    new ip[16];
	GetServerVarAsString("bind", ip, sizeof (ip));
	if (!ip[0] || strcmp(ip, HOSTED_IP)) SendRconCommand("exit");

	new MySQLOpt: option_id = mysql_init_options();
	mysql_set_option(option_id, AUTO_RECONNECT, true); 

	Database = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DATABASE, option_id); 

	if(Database == MYSQL_INVALID_HANDLE || mysql_errno(Database) != 0) 
	{
		print("[ SERVER ] I couldn't connect to the MySQL server, closing..."); 

		SendRconCommand("exit"); 
		return 1;
	}

	print("[ SERVER ] I connected to MySQL server successfully!");

	for(new i = 0; i < sizeof(ZONEINFO); i++) ZONEINFO[i][ZoneAttacker] = -1;

	SetWeather(3);
	SetWorldTime(0);
	last_weather = 0;

	SetGameModeText(GAMEMODE_TEXT);

	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	UsePlayerPedAnims();

	CreateTextDraws();
	CreateVehicles();
	CreateMappings();

	Class_Add(0,0,0,0,0,0,0,0,0,0,0);
	Class_Add(0,0,0,0,0,0,0,0,0,0,0);
	Class_Add(0,0,0,0,0,0,0,0,0,0,0); 
	Class_Add(0,0,0,0,0,0,0,0,0,0,0);
	Class_Add(0,0,0,0,0,0,0,0,0,0,0); 
	Class_Add(0,0,0,0,0,0,0,0,0,0,0); 
	Class_Add(0,0,0,0,0,0,0,0,0,0,0); 

	Class_Add(0,0,0,0,0,0,0,0,0,0,0);
	Class_Add(105,0,0,0,0,0,0,0,0,0,0);
	Class_Add(106,0,0,0,0,0,0,0,0,0,0);
	Class_Add(107,0,0,0,0,0,0,0,0,0,0);
	Class_Add(270,0,0,0,0,0,0,0,0,0,0);
	Class_Add(269,0,0,0,0,0,0,0,0,0,0);
	Class_Add(271,0,0,0,0,0,0,0,0,0,0);

	Class_Add(114,0,0,0,0,0,0,0,0,0,0);
	Class_Add(115,0,0,0,0,0,0,0,0,0,0);
	Class_Add(116,0,0,0,0,0,0,0,0,0,0);
	Class_Add(41,0,0,0,0,0,0,0,0,0,0);

	Class_Add(265,0,0,0,0,0,0,0,0,0,0);
	Class_Add(266,0,0,0,0,0,0,0,0,0,0);
	Class_Add(267,0,0,0,0,0,0,0,0,0,0);
	Class_Add(284,0,0,0,0,0,0,0,0,0,0);
	Class_Add(286,0,0,0,0,0,0,0,0,0,0);
	Class_Add(285,0,0,0,0,0,0,0,0,0,0);

	Class_Add(102,0,0,0,0,0,0,0,0,0,0);
	Class_Add(103,0,0,0,0,0,0,0,0,0,0);
	Class_Add(104,0,0,0,0,0,0,0,0,0,0);
	Class_Add(85,0,0,0,0,0,0,0,0,0,0);

	Class_Add(108,0,0,0,0,0,0,0,0,0,0);
	Class_Add(109,0,0,0,0,0,0,0,0,0,0);
	Class_Add(110,0,0,0,0,0,0,0,0,0,0);
	Class_Add(63,0,0,0,0,0,0,0,0,0,0);

	Class_Add(55,0,0,0,0,0,0,0,0,0,0);
	Class_Add(117,0,0,0,0,0,0,0,0,0,0);
	Class_Add(163,0,0,0,0,0,0,0,0,0,0);
	Class_Add(164,0,0,0,0,0,0,0,0,0,0);
	Class_Add(165,0,0,0,0,0,0,0,0,0,0);

	Class_Add(23,0,0,0,0,0,0,0,0,0,0); 
	Class_Add(24,0,0,0,0,0,0,0,0,0,0);
	Class_Add(29,0,0,0,0,0,0,0,0,0,0);
	Class_Add(34,0,0,0,0,0,0,0,0,0,0);
	Class_Add(100,0,0,0,0,0,0,0,0,0,0);
	Class_Add(122,0,0,0,0,0,0,0,0,0,0);
	Class_Add(133,0,0,0,0,0,0,0,0,0,0);
	Class_Add(169,0,0,0,0,0,0,0,0,0,0);
	Class_Add(185,0,0,0,0,0,0,0,0,0,0);
	Class_Add(188,0,0,0,0,0,0,0,0,0,0);
	Class_Add(216,0,0,0,0,0,0,0,0,0,0);
	Class_Add(219,0,0,0,0,0,0,0,0,0,0);
	Class_Add(225,0,0,0,0,0,0,0,0,0,0);
	Class_Add(250,0,0,0,0,0,0,0,0,0,0);
	Class_Add(261,0,0,0,0,0,0,0,0,0,0);
	Class_Add(306,0,0,0,0,0,0,0,0,0,0);
	Class_Add(211,0,0,0,0,0,0,0,0,0,0);
	Class_Add(223,0,0,0,0,0,0,0,0,0,0);

	GANG_HOUSE[0] = CreateDynamicCP(2495.2998,-1691.1389,14.7656, 1);//Groves
	GANG_HOUSE[1] = CreateDynamicCP(1939.0807,-1114.5100,27.4523, 1);//Ballas
	GANG_HOUSE[2] = CreateDynamicCP(1568.7046,-1689.9738,6.2188, 1);//Justice
	GANG_HOUSE[3] = CreateDynamicCP(1752.4976,-1912.0046,13.5674, 1);//Aztacaz
	GANG_HOUSE[4] = CreateDynamicCP(2137.6482,-2282.4194,20.6719, 1);//Russian
	GANG_HOUSE[5] = CreateDynamicCP(2288.2556,-1104.6617,38.5961, 1);//Vagos
	GANG_HOUSE[6] = CreateDynamicCP(1022.5154,-1121.8988,23.8717, 1);//VIP
	GANG_HOUSE[7] = CreateDynamicCP(322.1903,302.3582,999.1484, 1);//Justice interior
	GANG_HOUSE[8] = CreateDynamicCP(318.6027,1114.4797,1083.8828, 1);// Ballas interior
	GANG_HOUSE[9] = CreateDynamicCP(2496.0115,-1692.0834,1014.7422, 1);//Grove interior
	GANG_HOUSE[10] = CreateDynamicCP(2324.4900,-1149.5475,1050.7101, 1);//Aztecas interior
	GANG_HOUSE[11] = CreateDynamicCP(2352.9385,-1180.8865,1027.9766, 1);//Vergos interior
	GANG_HOUSE[12] = CreateDynamicCP(2468.8435,-1698.2288,1013.5078, 1);//Russian interior
	GANG_HOUSE[13] = CreateDynamicCP(235.2529,1187.3334,1080.2578, 1);//VIP interior
	PVEH[0] = CreateDynamicCP(1689.1766,-1461.9138,13.5528 - 1, 2);//pveh shop 
	PVEH[1] = CreateDynamicCP(1701.4545,-1460.5839,13.5528 - 1, 2);//pveh mod shop
	
	for(new i = 0; i < sizeof(SHOPINFO); i++)
	{
		Create3DTextLabel(SHOPINFO[i][label], 0xD9BC17FF, SHOPINFO[i][entercp][0], SHOPINFO[i][entercp][1], SHOPINFO[i][entercp][2], 50.0, 0, 0);
		SENTERCP[i] = CreateDynamicCP(SHOPINFO[i][entercp][0], SHOPINFO[i][entercp][1], SHOPINFO[i][entercp][2], 1);
		SEXITCP[i] = CreateDynamicCP(SHOPINFO[i][exitcp][0], SHOPINFO[i][exitcp][1], SHOPINFO[i][exitcp][2], 1, (i + 1));
		SBUYCP[i] = CreateDynamicCP(SHOPINFO[i][buycp][0], SHOPINFO[i][buycp][1], SHOPINFO[i][buycp][2], 1, (i + 1));
		CreateActor(SHOPINFO[i][askin], SHOPINFO[i][actorpos][0], SHOPINFO[i][actorpos][1], SHOPINFO[i][actorpos][2], SHOPINFO[i][actorpos][3]);
		SetActorVirtualWorld(i, (i + 1));
	}

	for(new a = 0; a < MAX_ACTORS; a++)
	{
		if(IsValidActor(a)) PreloadActorAnimations(a);
	}

	Create3DTextLabel("[Head Qauters]\nRussian Mafia", COLOR_MAFIA, 2137.6482, -2282.4194, 20.6719, 50.0, 0, 0);
	Create3DTextLabel("[Head Qauters]\nGrove Street", COLOR_GROVE, 2495.2998, -1691.1389, 14.7656, 50.0, 0, 0); 
	Create3DTextLabel("[Head Qauters]\nBallas", COLOR_BALLAS, 1939.0807, -1114.5100, 27.4523, 50.0, 0, 0);
	Create3DTextLabel("[Head Qauters]\nAztecas", COLOR_AZTECA, 1752.4976, -1912.0046, 13.5674, 50.0, 0, 0);
	Create3DTextLabel("[Head Qauters]\nVagos", COLOR_VAGOS, 2288.2556, -1104.6617, 38.5961, 50.0, 0, 0);
	Create3DTextLabel("[Head Qauters]\nJustice", COLOR_JUSTICE, 1568.7046, -1689.9738, 6.2188, 50.0, 0, 0);
	Create3DTextLabel("[Head Qauters]\nVIP", COLOR_VIP, 1022.5154,-1121.8988,23.8717, 50.0, 0, 0);

	Create3DTextLabel("{FF0000}[Medical Center]\n{FF69B4}Refill your health!", -1, 2017.7156,-1430.5802,13.5428, 50.0, 0, 0);
	Create3DTextLabel("{FF0000}[Medical Center]\n{FF69B4}Refill your health!", -1, 1178.6342,-1324.1819,14.1298, 50.0, 0, 0);

	gangpick[0] = CreatePickup(1242,1,2495.8767,-1710.3760,1014.7422, -1);
	gangpick[1] = CreatePickup(1242,1,2324.4883,-1140.6951,1050.4922, -1);   
	gangpick[2] = CreatePickup(1242,1,326.4333,307.1617,999.1484, -1); 
	gangpick[3] = CreatePickup(1242,1,323.9256,1131.2457,1083.8828, -1); 
	gangpick[4] = CreatePickup(1242,1,2345.1301,-1173.3184,1027.9834, -1); 
	gangpick[5] = CreatePickup(1242,1,2454.6406,-1705.3527,1013.5078, -1);
	hospick[0] = CreatePickup(1240,1,2017.7156,-1430.5802,13.5428);   
	hospick[1] = CreatePickup(1240,1,1178.6342,-1324.1819,14.1298); 

	//=================================== Creation of database structure

	new str[2300], substr[128];
	strcat(str, "CREATE TABLE IF NOT EXISTS `Users` ", sizeof(str));
	strcat(str, "(`User_ID` int(11) NOT NULL AUTO_INCREMENT,", sizeof(str));
	strcat(str, "`Name` varchar(24) NOT NULL,", sizeof(str));
	strcat(str, "`Password` char(129)  NOT NULL,", sizeof(str));
	strcat(str, "`Level` tinyint(1) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`VIP` tinyint(1) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Cash` mediumint(7) NOT NULL DEFAULT '5000',", sizeof(str));
	strcat(str, "`Kills` mediumint(7) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Deaths` mediumint(7) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Ratio` float(7,4) NOT NULL DEFAULT '0.00',", sizeof(str));
	strcat(str, "`Block_PM` tinyint(1) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Revenges` mediumint(7) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Brutal_kills` mediumint(7) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Highest_rampage` mediumint(7) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Robberies` mediumint(7) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Head_shots` mediumint(7) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Play_time` int(11) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Duels_played` mediumint(7) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Duels_won` mediumint(7) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Duel_place_ID` tinyint(1) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Duel_weapon_1` tinyint(3) NOT NULL DEFAULT '24',", sizeof(str));
	strcat(str, "`Duel_weapon_2` tinyint(3) NOT NULL DEFAULT '25',", sizeof(str));
	strcat(str, "`Duel_weapon_3` tinyint(3) NOT NULL DEFAULT '30',", sizeof(str));
	strcat(str, "`Duel_bet` mediumint(7) NOT NULL DEFAULT '10',", sizeof(str));
	strcat(str, "`LMS_plalyed` mediumint(7) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`LMS_won` mediumint(7) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`GunGames_played` mediumint(7) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`GunGames_won` mediumint(7) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Vehicle_owned` tinyint(1) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Vehicle_model` tinyint(3) NOT NULL DEFAULT '-1',", sizeof(str));
	strcat(str, "`Vehicle_wheel` tinyint(3) NOT NULL DEFAULT '-1',", sizeof(str));
	strcat(str, "`Vehicle_color_1` tinyint(3) NOT NULL DEFAULT '-1',", sizeof(str));
	strcat(str, "`Vehicle_color_2` tinyint(3) NOT NULL DEFAULT '-1',", sizeof(str));
	strcat(str, "`Vehicle_neon_1` tinyint(1) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Vehicle_neon_2` tinyint(1) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Vehicle_paintjob` tinyint(1) NOT NULL DEFAULT '-1',", sizeof(str));
	strcat(str, "`Vehicle_nitro` tinyint(4) NOT NULL DEFAULT '-1',", sizeof(str));
	strcat(str, "`Vehicle_hydraulics` tinyint(1) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`In_gang` tinyint(1) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Gang_ID` tinyint(3) NOT NULL DEFAULT '-1',", sizeof(str));
	strcat(str, "`Gang_level` tinyint(1) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Gang_skin` tinyint(3) NOT NULL DEFAULT '1',", sizeof(str));
	strcat(str, "`Banned` tinyint(1) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Jailed` tinyint(1) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Unjail_time` mediumint(7) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Muted` tinyint(1) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "`Unmute_time` mediumint(7) NOT NULL DEFAULT '0',", sizeof(str));
	strcat(str, "PRIMARY KEY (`User_ID`), UNIQUE KEY `Name` (`Name`))", sizeof(str));
	mysql_tquery(Database, str);

	format(str, sizeof(str), 
	"CREATE TABLE IF NOT EXISTS `Gangs` \
	(`Gang_ID` tinyint(3) NOT NULL AUTO_INCREMENT,\
	`Name` varchar(30) NOT NULL,\
	`Tag` varchar(10) NOT NULL,\
	`Color` int(11) NOT NULL DEFAULT '%d',\
	`HQ` tinyint(3) NOT NULL DEFAULT '0',\
	`HQ_ID` tinyint(3) NOT NULL DEFAULT '-1',\
	`Kills` mediumint(7) NOT NULL DEFAULT '0',\
	`Deaths` mediumint(7) NOT NULL DEFAULT '0',\
	`Score` int(11) NOT NULL DEFAULT '0',\
	`Turfs` tinyint(3) NOT NULL DEFAULT '0',", HexToInt("0xFFFFFFFF"));
	
	for(new i = 0; i < MAX_GANG_MEMBERS; i++)
	{					
		mysql_format(Database, substr, sizeof(substr), "`Member_%d` int(11) NOT NULL DEFAULT '-1',", i + 1);
		strcat(str, substr, sizeof(str)); 
	}
	strcat(str, "PRIMARY KEY (`Gang_ID`))", sizeof(str));
	mysql_tquery(Database, str);
	mysql_tquery(Database, "SELECT * FROM Gangs", "SetupGangs");

	mysql_tquery(Database,
	"CREATE TABLE IF NOT EXISTS `Zones`\
	(`Zone_ID` tinyint(3) NOT NULL AUTO_INCREMENT,\
	`Zone_name` varchar(30) NOT NULL,\
	`Zone_owned_team_ID` tinyint(3) NOT NULL,\
	PRIMARY KEY (`Zone_ID`))");
	mysql_tquery(Database, "SELECT * FROM Zones", "SetupZones");

	mysql_tquery(Database,
	"CREATE TABLE IF NOT EXISTS `Houses`\
	(`House_ID` tinyint(3) NOT NULL AUTO_INCREMENT,\
	`House_owned` tinyint(3) NOT NULL DEFAULT '0',\
	`House_owned_team_ID` tinyint(3) NOT NULL DEFAULT '-1',\
	PRIMARY KEY (`House_ID`))");
	mysql_tquery(Database, "SELECT * FROM Houses", "SetupHouses");

	format(str, sizeof(str), 
	"%s", "CREATE TABLE IF NOT EXISTS `IPs`\
	(`User_ID` int(11) NOT NULL AUTO_INCREMENT,");
	for(new i = 0; i < MAX_IP_SAVES; i++)
	{
		format(substr, sizeof(substr), "`IP_%d` varchar(20) DEFAULT ' ', ", i + 1);
		strcat(str, substr, sizeof(str));
	}
	strcat(str, "PRIMARY KEY (`User_ID`))", sizeof(str));
	mysql_tquery(Database, str);

	//================================================= Loading from database

	for(new i = 0; i < MAX_GANGS; i ++) LoadGangData(i);
	for(new i = 0; i < sizeof(HOUSEINFO); i++) LoadHouseData(i);
	for(new i = 0; i < sizeof(ZONEINFO); i ++) LoadZoneData(i);

	for(new c = 0; c < sizeof(HOUSEINFO); c++)
	{
		GENTERCP[c] = CreateDynamicCP(HOUSEINFO[c][entercp][0], HOUSEINFO[c][entercp][1], HOUSEINFO[c][entercp][2], 1);
		GEXITCP[c] = CreateDynamicCP(HOUSEINFO[c][exitcp][0], HOUSEINFO[c][exitcp][1], HOUSEINFO[c][exitcp][2], 1);
		if(HOUSEINFO[c][howned] == 0)
		{
			hlabel[c] = Create3DTextLabel("{FF6347}[Head Qauters]\n* Unowned", -1, HOUSEINFO[c][entercp][0], HOUSEINFO[c][entercp][1], HOUSEINFO[c][entercp][2], 50.0, 0, 0);
		}
		else
		{
			format(str, sizeof(str), "[Head Qauters]\n%s", ReplaceUwithS(GANGINFO[HOUSEINFO[c][hteamid]][gname]));
			hlabel[c] = Create3DTextLabel(str, GANGINFO[HOUSEINFO[c][hteamid]][gcolor], HOUSEINFO[c][entercp][0], HOUSEINFO[c][entercp][1], HOUSEINFO[c][entercp][2], 50.0, 0, 0);
		}
	}

	for(new j = 0; j < sizeof(ZONEINFO); j++)
	{
		ZONEID[j] = GangZoneCreate(ZONEINFO[j][zminx], ZONEINFO[j][zminy], ZONEINFO[j][zmaxx], ZONEINFO[j][zmaxy]);
		DZONEID[j] = CreateDynamicRectangle(ZONEINFO[j][zminx], ZONEINFO[j][zminy], ZONEINFO[j][zmaxx], ZONEINFO[j][zmaxy]);
	}

	CreateDynamicMapIcon(1752.4976,-1912.0046,13.5674, 58, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
	CreateDynamicMapIcon(1939.0807,-1114.5100,27.4523, 59, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
	CreateDynamicMapIcon(2288.25576,-1104.6617,38.5961, 60, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
	CreateDynamicMapIcon(2137.6482,-2282.4194,20.6719, 61, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
	CreateDynamicMapIcon(2495.2998,-1691.1389,14.7656, 62, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
	CreateDynamicMapIcon(1552.3999,-1675.7057,16.1953, 30, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
	CreateDynamicMapIcon(1689.166,-1461.9138,13.5528, 55, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);   
	CreateDynamicMapIcon(1701.4545,-1460.5839,13.5528, 27, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
	CreateDynamicMapIcon(1044.933, -1018.641, 15.0, 63, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
	CreateDynamicMapIcon(523.9448, -1748.974, 15.0, 63, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
	CreateDynamicMapIcon(2052.685, -1839.771, 15.0, 63, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
	CreateDynamicMapIcon(1200.85, -1326.565, 15.0, 22, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
	CreateDynamicMapIcon(2029.868, -1421.311, 15.0, 22, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
	CreateDynamicMapIcon(2029.868, -1421.311, 15.0, 22, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL); //24/7
	CreateDynamicMapIcon(2029.868, -1421.311, 15.0, 22, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL); //24/7
	CreateDynamicMapIcon(2029.868, -1421.311, 15.0, 22, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL); //24/7
	CreateDynamicMapIcon(2029.868, -1421.311, 15.0, 22, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL); //24/7

	for(new i = 0; i < sizeof(SHOPINFO); i++)
	{
		CreateDynamicMapIcon(SHOPINFO[i][entercp][0], SHOPINFO[i][entercp][1], SHOPINFO[i][entercp][2], SHOPINFO[i][mapico], 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);  
	}

	for(new i = 0; i < sizeof(HOUSEINFO); i++)
	{
		if(HOUSEINFO[i][howned] == 1) HOUSEINFO[i][icon_id] = CreateDynamicMapIcon(HOUSEINFO[i][entercp][0], HOUSEINFO[i][entercp][1], HOUSEINFO[i][entercp][2], 32, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
		else HOUSEINFO[i][icon_id] = CreateDynamicMapIcon(HOUSEINFO[i][entercp][0], HOUSEINFO[i][entercp][1], HOUSEINFO[i][entercp][2], 31, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
	}

	SetTimer("ServerSaveTimer", 180000, true);
	SetTimer("RobTimer", 500, true);
	SetTimer("UnjailandUnmuteTimer", 1000, true);
	SetTimer("TurfMoney", TIME_FOR_TURF_PAYDAY * 60 * 1000, true);
	SetTimer("NeonTimer", 5000, true);
	SetTimer("TurfTimer", 1000, true);
	SetTimer("RandomServerMessage", 180000, true);
	SetTimer("TDUpdate", 1000, true); 
	SetTimer("RandomWeather", 1000 * 60 * 4, true); 
	SetTimer("RandomConnectTD", 1000 * 60 * 10, true);

	SaveServerData();
	return 1;
}

forward SetupHouses();
public SetupHouses()
{
	new str[128];
	new rows;
	cache_get_row_count(rows);
	if(rows != sizeof(HOUSEINFO))
	{
		for(new i = 0; i < sizeof(HOUSEINFO); i ++)
		{
			if(i > (rows - 1))
			{
				mysql_format(Database, str, sizeof(str), "INSERT INTO `Houses` ", GetTeamName(i), GetTeamTag(i), GetTeamColor(i));
				mysql_tquery(Database, "INSERT INTO `Houses` (`House_owned`) VALUES('0')");
			}
		}
	}
	return 1;
}

forward SetupGangs();
public SetupGangs()
{
	new str[128];
	new rows;
	cache_get_row_count(rows);
	if(rows != MAX_GANGS)
	{
		for(new i = 0; i < MAX_GANGS; i ++)
		{
			if(i > (rows - 1))
			{
				if(i < 7)
				{
					mysql_format(Database, str, sizeof(str), "INSERT INTO `Gangs` (`Name`, `Tag`, `Color`) VALUES('%e', '%e', '%d')", GetTeamName(i), GetTeamTag(i), GetTeamColor(i));
					mysql_tquery(Database, str);
				}
				else mysql_tquery(Database, "INSERT INTO `Gangs` (`Name`, `Tag`, `Turfs`) VALUES('-1', '-1', '5')");
			}
		}
	}
	return 1;
}

new turfs[7];

forward SetupZones();
public SetupZones()
{
	new rows, Rand;
	cache_get_row_count(rows);
	new str[128];
	if(rows != sizeof(ZONEINFO))
	{
		for(new i = 0; i < sizeof(ZONEINFO); i ++)
		{
			if(i > (rows - 1))
			{
				Rand = random(sizeof(TeamRandoms));
				mysql_format(Database, str, sizeof(str), "INSERT INTO `Zones` (`Zone_name`, `Zone_owned_team_ID`) VALUES('%e', '%d')", ZONEINFO[i][zname], TeamRandoms[Rand]);
				mysql_tquery(Database, str);
				turfs[TeamRandoms[Rand]] ++;
			}
		}

		for(new i = 0; i < 7; i++)
		{
			mysql_format(Database, str, sizeof(str), "UPDATE `Gangs` SET `Turfs`=Turfs+%d, `Score` = Score+%d WHERE `Gang_ID` = %d LIMIT 1", turfs[i], turfs[i] * GANG_SCORE_PER_TURF, i + 1);
			mysql_tquery(Database, str);
		}
	}
	return 1;
}

public OnGameModeExit() 
{
	foreach(new i : Player)
	{
		OnPlayerDisconnect(i, 1);
	}

	mysql_close(Database);

	TextDrawDestroy(statstd);
	TextDrawDestroy(gangtd);
	TextDrawDestroy(zonetd); 

	for(new i = 0; i < 12; i++) TextDrawDestroy(connecttd[i]);
	for(new i = 0; i < 10; i++) TextDrawDestroy(LGGW[i]);
	for(new i = 0; i < 3; i++) TextDrawDestroy(vtunetd[i]);
	for(new i = 0; i < 5; i++) TextDrawDestroy(takeovertd[i]);
	for(new i = 0; i < 2; i++) TextDrawDestroy(DM__[i]);
	for(new i = 0; i < 5; i++) TextDrawDestroy(wastedtd[i]);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(logged[playerid] == 0) return 0;

	SetPlayerColor(playerid, 0xAFAFAF88);
	SetPlayerVirtualWorld(playerid, playerid + 1);
	SetPlayerInterior(playerid, 0);
	
	PlayerTextDrawHide(playerid, wastedtd_1[playerid]);
	TextDrawHideForPlayer(playerid, wastedtd[0]);
	TextDrawHideForPlayer(playerid, wastedtd[1]);
	TextDrawHideForPlayer(playerid, wastedtd[2]);
	TextDrawHideForPlayer(playerid, wastedtd[3]);
	TextDrawHideForPlayer(playerid, wastedtd[4]);
	
	if(inminigame[playerid] == 1) return SpawnPlayer(playerid);
	if(USERINFO[playerid][ingang] == 1) return SpawnPlayer(playerid);
	if(class_selected[playerid]) classid = 3;
	if(class_gselection[playerid] == 0) for(new i = 7; i < 55; i++) Class_SetPlayer(i, playerid, false);
	PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
	class_selected[playerid] = 0;
	switch(classid)
	{
		case 0..6:
		{
			USERINFO[playerid][gid] = -1;
			USERINFO[playerid][gskin] = -1;
			TextDrawShowForPlayer(playerid, gangtd);
			for(new i = 0; i < 5; i ++) PlayerTextDrawShow(playerid, gangtd_1[playerid][i]);
			new str[50];
			format(str, sizeof(str), "~y~Score:_~w~%d", GANGINFO[classid][gscore]);
			PlayerTextDrawSetString(playerid, gangtd_1[playerid][1], str);
			new count = 0;
			foreach(new i : Player)
			{
				if(USERINFO[i][gid] == classid)
				{
					count++;
				}
			}
			format(str, sizeof(str), "~y~Members_Online:_~w~%d", count);
			PlayerTextDrawSetString(playerid, gangtd_1[playerid][2], str);
			format(str, sizeof(str), "~y~Controlled_Turfs:_~w~%d", GANGINFO[classid][gturfs]);
			PlayerTextDrawSetString(playerid, gangtd_1[playerid][3], str);
			class_saved[playerid] = classid;
			CallLocalFunction("OnPlayerRequestClassEx", "ii", playerid, classid);
		}
	}

	switch(classid)
	{
		case TEAM_GROVE:
		{
			PlayerTextDrawSetString(playerid, gangtd_1[playerid][0], "~g~Grove_Street_Families");
			PlayerTextDrawSetString(playerid, gangtd_1[playerid][4], "~w~]_~g~grove_street_~w~]");
			InterpolateCameraPos(playerid, 2319.449218, -1622.686523, 64.635452, 2471.233398, -1662.675537, 29.131023, 2000);
			InterpolateCameraLookAt(playerid, 2319.975830, -1627.555297, 63.626800, 2474.705810, -1665.924194, 27.585163, 2000);
		}
		case TEAM_AZTECA:
		{
			PlayerTextDrawSetString(playerid, gangtd_1[playerid][0], "~b~Aztecas");
			PlayerTextDrawSetString(playerid, gangtd_1[playerid][4], "~w~]_~b~aztecas_~w~]");
			InterpolateCameraPos(playerid, 1861.639648, -1844.021606, 44.626201, 1783.382568, -1904.509765, 31.318225, 2000);
			InterpolateCameraLookAt(playerid, 1857.749877, -1840.880004, 44.631408, 1779.026489, -1905.638427, 29.138710, 2000);
		}
		case TEAM_JUSTICE:
		{
			PlayerTextDrawSetString(playerid, gangtd_1[playerid][0], "~b~Justice");
			PlayerTextDrawSetString(playerid, gangtd_1[playerid][4], "~w~]_~b~justice_~w~]");
			InterpolateCameraPos(playerid, 1370.549072, -1649.119995, 32.404632, 1497.753295, -1675.863769, 49.390430, 2000);
			InterpolateCameraLookAt(playerid, 1375.507202, -1649.711059, 32.664932, 1502.374145, -1675.999267, 47.485393, 2000);
		}
		case TEAM_BALLAS:
		{
			PlayerTextDrawSetString(playerid, gangtd_1[playerid][0], "~p~Ballas");
			PlayerTextDrawSetString(playerid, gangtd_1[playerid][4], "~w~]_~p~ballas_~w~]");
			InterpolateCameraPos(playerid, 1939.794067, -1222.808837, 21.845754, 1931.146118, -1140.666992, 42.193244, 2000);
			InterpolateCameraLookAt(playerid, 1940.745605, -1217.946166, 22.515609, 1932.703369, -1136.448730, 40.006698, 2000);
		}
		case TEAM_VAGOS:
		{
			PlayerTextDrawSetString(playerid, gangtd_1[playerid][0], "~y~Vagos");
			PlayerTextDrawSetString(playerid, gangtd_1[playerid][4], "~w~]_~y~vagos_~w~]");		
			InterpolateCameraPos(playerid, 2161.056640, -1212.964477, 54.431701, 2301.262451, -1132.500854, 59.928718, 2000);
			InterpolateCameraLookAt(playerid, 2156.548828, -1210.918823, 53.728313, 2299.283447, -1128.518432, 57.643180, 2000);
		}
		case TEAM_MAFIA:
		{
			PlayerTextDrawSetString(playerid, gangtd_1[playerid][0], "~r~Russian_Mafia");
			PlayerTextDrawSetString(playerid, gangtd_1[playerid][4], "~w~]_~r~Russian_Mafia_~w~]");
			InterpolateCameraPos(playerid, 2165.907714, -2303.100830, 14.266811, 2207.555664, -2266.463378, 29.055604, 2000);
			InterpolateCameraLookAt(playerid, 2162.726806, -2299.258300, 14.608991, 2203.309326, -2265.023193, 26.843336, 2000);
		}
		case TEAM_VIP:
		{
			PlayerTextDrawSetString(playerid, gangtd_1[playerid][0], "~r~VIP");
			PlayerTextDrawSetString(playerid, gangtd_1[playerid][4], "~w~]_]_]~r~_VIP_~w~]_]_]");
			InterpolateCameraPos(playerid, 963.266601, -1160.232421, 53.812442, 1052.617797, -1160.796630, 55.495792, 2000);
			InterpolateCameraLookAt(playerid, 960.418640, -1156.287231, 52.661403, 1050.388916, -1157.074707, 53.010036, 2000);
		}
		case 7..13: //Groves
		{
			if(classid == 7) USERINFO[playerid][gskin] = 0;
			if(classid == 8) USERINFO[playerid][gskin] = 105;
			if(classid == 9) USERINFO[playerid][gskin] = 106;
			if(classid == 10) USERINFO[playerid][gskin] = 107;
			if(classid == 11) USERINFO[playerid][gskin] = 270;
			if(classid == 12) USERINFO[playerid][gskin] = 269;
			if(classid == 13) USERINFO[playerid][gskin] = 271;	
			SetPlayerPos(playerid, 2495.3616,-1687.8169,13.5163);
			SetPlayerFacingAngle(playerid, 0);
			//ClearAnimations(playerid);
			//ApplyAnimation(playerid,"DANCING","DNCE_M_B",4.0,1,0,0,0,-1);
		}
		case 14..17: //Azteca
		{
			if(classid == 14) USERINFO[playerid][gskin] = 114;
			if(classid == 15) USERINFO[playerid][gskin] = 115;
			if(classid == 16) USERINFO[playerid][gskin] = 116;
			if(classid == 17) USERINFO[playerid][gskin] = 41;
			SetPlayerPos(playerid, 1755.1818,-1911.9816,13.5680);
			SetPlayerFacingAngle(playerid, 270);
			//ClearAnimations(playerid);
			//ApplyAnimation(playerid,"DANCING","DNCE_M_B",4.0,1,0,0,0,-1);
		}
		case 18..23: //Justice
		{
			if(classid == 18) USERINFO[playerid][gskin] = 265;
			if(classid == 19) USERINFO[playerid][gskin] = 266;
			if(classid == 20) USERINFO[playerid][gskin] = 267;
			if(classid == 21) USERINFO[playerid][gskin] = 284;
			if(classid == 22) USERINFO[playerid][gskin] = 286;
			if(classid == 23) USERINFO[playerid][gskin] = 285;
			SetPlayerPos(playerid, 1552.3999,-1675.7057,16.1953);
			SetPlayerFacingAngle(playerid, 90);
			//ClearAnimations(playerid);
			//ApplyAnimation(playerid,"DANCING","DNCE_M_B",4.0,1,0,0,0,-1);
		}
		case 24..27: //Ballas
		{
			if(classid == 24) USERINFO[playerid][gskin] = 102;
			if(classid == 25) USERINFO[playerid][gskin] = 103;
			if(classid == 26) USERINFO[playerid][gskin] = 104;
			if(classid == 27) USERINFO[playerid][gskin] = 85;
			SetPlayerPos(playerid, 1939.3193,-1116.9648,26.5312);
			SetPlayerFacingAngle(playerid, 180);
			//ClearAnimations(playerid);
			//ApplyAnimation(playerid,"DANCING","DNCE_M_B",4.0,1,0,0,0,-1);
		}
		case 28..31: //Vagos
		{
			if(classid == 28) USERINFO[playerid][gskin] = 108;
			if(classid == 29) USERINFO[playerid][gskin] = 109;
			if(classid == 30) USERINFO[playerid][gskin] = 110;
			if(classid == 31) USERINFO[playerid][gskin] = 63;
			SetPlayerPos(playerid, 2287.5903,-1107.4723,37.9766);
			SetPlayerFacingAngle(playerid, 180);
			//ClearAnimations(playerid);
			//ApplyAnimation(playerid,"DANCING","DNCE_M_B",4.0,1,0,0,0,-1);
		}
		case 32..36: //Russian
		{
			if(classid == 32) USERINFO[playerid][gskin] = 55;
			if(classid == 33) USERINFO[playerid][gskin] = 117;
			if(classid == 34) USERINFO[playerid][gskin] = 163;
			if(classid == 35) USERINFO[playerid][gskin] = 164;
			if(classid == 36) USERINFO[playerid][gskin] = 165;
			SetPlayerPos(playerid, 2180.0186,-2256.8735,14.7734);
			SetPlayerFacingAngle(playerid, 240);
			//ClearAnimations(playerid);
			//ApplyAnimation(playerid,"DANCING","DNCE_M_B",4.0,1,0,0,0,-1);
		}
		case 37..54: //VIP
		{
			if(classid == 37) USERINFO[playerid][gskin] = 23;
			if(classid == 38) USERINFO[playerid][gskin] = 24;
			if(classid == 39) USERINFO[playerid][gskin] = 29;
			if(classid == 40) USERINFO[playerid][gskin] = 34;
			if(classid == 41) USERINFO[playerid][gskin] = 100;
			if(classid == 42) USERINFO[playerid][gskin] = 122;
			if(classid == 43) USERINFO[playerid][gskin] = 133;
			if(classid == 44) USERINFO[playerid][gskin] = 169;
			if(classid == 45) USERINFO[playerid][gskin] = 185;
			if(classid == 46) USERINFO[playerid][gskin] = 188;
			if(classid == 47) USERINFO[playerid][gskin] = 216;
			if(classid == 48) USERINFO[playerid][gskin] = 219;
			if(classid == 49) USERINFO[playerid][gskin] = 225;
			if(classid == 50) USERINFO[playerid][gskin] = 250;
			if(classid == 51) USERINFO[playerid][gskin] = 261;
			if(classid == 52) USERINFO[playerid][gskin] = 306;
			if(classid == 53) USERINFO[playerid][gskin] = 211;
			if(classid == 54) USERINFO[playerid][gskin] = 223;
			SetPlayerPos(playerid, 1022.4600,-1123.6239,23.8702);
			SetPlayerFacingAngle(playerid, 180);
			//ClearAnimations(playerid);
			//ApplyAnimation(playerid,"DANCING","DNCE_M_B",4.0,1,0,0,0,-1);
		}	
	}
	return 1;
}

public OnPlayerRequestClassEx(playerid, classid)
{
	switch(classid)
	{
		case TEAM_GROVE: SetPlayerPos(playerid, 2509.4551,-1695.8652,13.5238);
		case TEAM_AZTECA: SetPlayerPos(playerid, 1755.6006,-1943.0302,13.5718);
		case TEAM_JUSTICE: SetPlayerPos(playerid, 1552.0704,-1637.4517,13.5559);
		case TEAM_BALLAS: SetPlayerPos(playerid, 1940.5020,-1104.8237,26.4531);
		case TEAM_VAGOS: SetPlayerPos(playerid, 2275.3394,-1097.8798,37.9766);
		case TEAM_MAFIA: SetPlayerPos(playerid, 2176.4033,-2229.8257,13.4371);
		case TEAM_VIP: SetPlayerPos(playerid, 1016.6958,-1115.9430,23.8978);
	} 
	return 1;
}

public OnPlayerRequestSpawn(playerid) 
{
	if(logged[playerid] == 0) return 0;
	if(class_gselection[playerid] == 0)
	{
		if(class_saved[playerid] == TEAM_VIP && USERINFO[playerid][VIP] == 0)
		{
			GameTextForPlayer(playerid, "~r~ONLY FOR VIPs", 1000, 3);
			return 0;
		}

		class_gselection[playerid] = 1;
		TextDrawHideForPlayer(playerid, gangtd);
		for(new i = 0; i < 5; i++) PlayerTextDrawHide(playerid, gangtd_1[playerid][i]);

		switch(class_saved[playerid])
		{
			case TEAM_GROVE:
			{	
				for(new i = 0; i < 7; i++) Class_SetPlayer(i, playerid, false);
				for(new i = 7; i < 14; i++) Class_SetPlayer(i, playerid, true);
				USERINFO[playerid][gid] = TEAM_GROVE;
				USERINFO[playerid][gskin] = 0;
				SetPlayerTeam(playerid, TEAM_GROVE);
				SetPlayerPos(playerid, 2495.3616,-1687.8169,13.5163);
				SetPlayerFacingAngle( playerid, 0);
				InterpolateCameraPos(playerid, 2471.233398, -1662.675537, 29.131023, 2494.8152,-1675.8546,13.3359, 2000);
				InterpolateCameraLookAt(playerid, 2474.705810, -1665.924194, 27.585163,2495.3616,-1687.8169,13.516, 2000);
				//ClearAnimations(playerid);
				//ApplyAnimation(playerid,"DANCING","DNCE_M_B",4.0,1,0,0,0,-1);
				Class_Goto(playerid, 7);
				return 0;
			}
			case TEAM_AZTECA:
			{
				for(new i = 0; i < 7; i++) Class_SetPlayer(i, playerid, false);
				for(new i = 14; i < 18; i++) Class_SetPlayer(i, playerid, true);
				USERINFO[playerid][gid] = TEAM_AZTECA;
				USERINFO[playerid][gskin] = 114;
				SetPlayerTeam(playerid, TEAM_AZTECA);
				SetPlayerPos(playerid, 1755.1818,-1911.9816,13.5680);
				SetPlayerFacingAngle( playerid, 270);
				InterpolateCameraPos(playerid, 1783.382568, -1904.509765, 31.318225, 1763.0292,-1912.2617,13.5701, 2000);
				InterpolateCameraLookAt(playerid, 1779.026489, -1905.638427, 29.138710,1755.1818,-1911.9816,13.5680, 2000);
				//ClearAnimations(playerid);
				//ApplyAnimation(playerid,"DANCING","DNCE_M_B",4.0,1,0,0,0,-1);
				Class_Goto(playerid, 14);
				return 0;
			}
			case TEAM_JUSTICE:
			{
				for(new i = 0; i < 7; i++) Class_SetPlayer(i, playerid, false);
				for(new i = 18; i < 24; i++) Class_SetPlayer(i, playerid, true);
				USERINFO[playerid][gid] = TEAM_JUSTICE;
				USERINFO[playerid][gskin] = 265;
				SetPlayerTeam(playerid, TEAM_JUSTICE);				
				SetPlayerPos(playerid, 1552.3999,-1675.7057,16.1953);
				SetPlayerFacingAngle( playerid, 90);
				InterpolateCameraPos(playerid, 1497.753295, -1675.863769, 49.390430, 1546.2343,-1675.8071,13.5619, 2000);
				InterpolateCameraLookAt(playerid, 1502.374145, -1675.999267, 47.485393,1552.3999,-1675.7057,16.1953, 2000);
				//ClearAnimations(playerid);
				//ApplyAnimation(playerid,"DANCING","DNCE_M_B",4.0,1,0,0,0,-1);
				Class_Goto(playerid, 18);
				return 0;
			}
			case TEAM_BALLAS:
			{
				for(new i = 0; i < 7; i++) Class_SetPlayer(i, playerid, false);
				for(new i = 24; i < 28; i++) Class_SetPlayer(i, playerid, true);
				USERINFO[playerid][gid] = TEAM_BALLAS;
				USERINFO[playerid][gskin] = 102;
				SetPlayerTeam(playerid, TEAM_BALLAS);
				SetPlayerPos(playerid, 1939.3193,-1116.9648,26.5312);
				SetPlayerFacingAngle( playerid, 180);
				InterpolateCameraPos(playerid, 1931.146118, -1140.666992, 42.193244, 1939.4532,-1121.6401,26.5256, 2000);
				InterpolateCameraLookAt(playerid, 1932.703369, -1136.448730, 40.006698,1939.3193,-1116.9648,26.5312, 2000);
				//ClearAnimations(playerid);
				//ApplyAnimation(playerid,"DANCING","DNCE_M_B",4.0,1,0,0,0,-1);
				Class_Goto(playerid, 24);
				return 0;
			}
			case TEAM_VAGOS:
			{
				for(new i = 0; i < 7; i++) Class_SetPlayer(i, playerid, false);
				for(new i = 28; i < 32; i++) Class_SetPlayer(i, playerid, true);
				USERINFO[playerid][gid] = TEAM_VAGOS;
				USERINFO[playerid][gskin] = 108;
				SetPlayerTeam(playerid, TEAM_VAGOS);
				SetPlayerPos(playerid, 2287.5903,-1107.4723,37.9766);
				SetPlayerFacingAngle( playerid, 180); 
				InterpolateCameraPos(playerid, 2301.262451, -1132.500854, 59.928718, 2284.7876,-1117.1827,37.9766, 2000);
				InterpolateCameraLookAt(playerid, 2299.283447, -1128.518432, 57.643180,2287.5903,-1107.4723,37.9766, 2000);
				//ClearAnimations(playerid);
				//ApplyAnimation(playerid,"DANCING","DNCE_M_B",4.0,1,0,0,0,-1);
				Class_Goto(playerid, 28);
				return 0;
			}
			case TEAM_MAFIA:
			{
				for(new i = 0; i < 7; i++) Class_SetPlayer(i, playerid, false);
				for(new i = 32; i < 37; i++) Class_SetPlayer(i, playerid, true);
				USERINFO[playerid][gid] = TEAM_MAFIA;
				USERINFO[playerid][gskin] = 55;
				SetPlayerTeam(playerid, USERINFO[playerid][gid]);
				SetPlayerPos(playerid,2180.0186,-2256.8735,14.7734);
				SetPlayerFacingAngle( playerid, 240);
				InterpolateCameraPos(playerid, 2207.555664, -2266.463378, 29.055604, 2187.0168,-2262.7578,13.4510, 2000);
				InterpolateCameraLookAt(playerid, 2203.309326, -2265.023193, 26.843336,2180.0186,-2256.8735,14.7734, 2000);
				//ClearAnimations(playerid);
				//ApplyAnimation(playerid,"DANCING","DNCE_M_B",4.0,1,0,0,0,-1);
				Class_Goto(playerid, 32);
				return 0;
			}
			case TEAM_VIP:
			{
				for(new i = 0; i < 7; i++) Class_SetPlayer(i, playerid, false);
				for(new i = 37; i < 55; i++) Class_SetPlayer(i, playerid, true);
				USERINFO[playerid][gid] = TEAM_VIP;
				USERINFO[playerid][gskin] = 23;
				SetPlayerTeam(playerid, USERINFO[playerid][gid]);
				SetPlayerPos(playerid, 1022.4600,-1123.6239,23.8702);
				SetPlayerFacingAngle( playerid, 180);
				InterpolateCameraPos(playerid, 1052.617797, -1160.796630, 55.495792, 1022.266906, -1138.560791, 26.024034, 2000);
				InterpolateCameraLookAt(playerid, 1050.388916, -1157.074707, 53.010036,1022.405822, -1133.603515, 25.386693, 2000);
				//ClearAnimations(playerid);
				//ApplyAnimation(playerid,"DANCING","DNCE_M_B",4.0,1,0,0,0,-1);
				Class_Goto(playerid, 37);
				return 0;
			}
		}
	}
	else
	{
		for(new i = 0; i < 55; i++) Class_SetPlayer(i, playerid, true);
		class_gselection[playerid] = 0;
		class_selected[playerid] = 1;
		//ClearAnimations(playerid);
		SetSpawnInfo(playerid, USERINFO[playerid][gid], USERINFO[playerid][gskin], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
		SetCameraBehindPlayer(playerid);
	}
	return 1;
}

public OnPlayerConnect(playerid)
{ 
	new str[180];
    new h, m, s;
    new y, mn, d;
    getdate(y, mn, d);
    gettime(h, m, s);
    format(str, sizeof(str), ":green_circle: `[ %d:%d:%d | %d:%d:%d ]` (`%s`) **%s[%d]** has joined the server", y, mn, d, h, m, s, PlayerIP(playerid), PlayerName(playerid), playerid);
	DCC_SendChannelMessage(dcc_channel_con_discon, str);
	
	ResetPlayerVars(playerid);
	PreloadPlayerAnimations(playerid);

	SetPlayerInterior(playerid, 0);
	SetPlayerPos(playerid, -231.7803,2379.3232,110.2815);

	TogglePlayerClock(playerid, false);

	PlayAudioStreamForPlayer(playerid, "https://www.mboxdrive.com/coffin.mp3"); 

	CreatePlayerTextDraws(playerid);

	TextDrawShowForPlayer(playerid, connecttd[2]);
	TextDrawShowForPlayer(playerid, connecttd[3]);

	Corrupt_Check[playerid]++;

	mysql_format(Database, str, sizeof(str), "SELECT * FROM `PLAYERS` WHERE `USERNAME` = '%e' LIMIT 1", PlayerName(playerid));
	mysql_tquery(Database, str, "OnPlayerDataCheck", "ii", playerid, Corrupt_Check[playerid]);

	SetTimerEx("OnPlayerConnectEx", 5000, false, "i", playerid);

	for(new i = 0; i < 100; i++) SendClientMessage(playerid, -1, "");
	return 1; 
}

new registered[MAX_PLAYERS];

forward  OnPlayerDataCheck(playerid, corrupt_check);
public OnPlayerDataCheck(playerid, corrupt_check)
{
	if(cache_num_rows() > 0)
	{
		cache_get_value(0, "Password", USERINFO[playerid][ppass], 129);
		registered[playerid] = 1;
		USERINFO[playerid][Player_Cache] = cache_save();
	}
	else registered[playerid] = 0;
	return 1;
}

new camtimer[MAX_PLAYERS];
new con_cam[MAX_PLAYERS];

forward ChangeCamera(playerid);
public ChangeCamera(playerid)
{
	switch(con_cam[playerid])
	{
		case 0:
		{ 
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid, -231.7803,2379.3232,110.2815);
			InterpolateCameraPos(playerid, -299.023437, 2382.302246, 112.256263, -248.933288, 2382.252685, 112.734977, 10000);
			InterpolateCameraLookAt(playerid, -294.030334, 2382.164794, 112.480148, -243.933776, 2382.197021, 112.776641, 10000);
			camtimer[playerid] = SetTimerEx("ChangeCamera", 10000, 0, "i", playerid);
		}
		case 1:
		{
			InterpolateCameraPos(playerid, -292.969665, 2319.386230, 118.957069, -238.585525, 2319.801513, 118.957069, 10000);
			InterpolateCameraLookAt(playerid, -293.033264, 2324.385498, 118.907592, -237.912933, 2324.755859, 118.998733, 10000);
			camtimer[playerid] = SetTimerEx("ChangeCamera", 10000, 0, "i", playerid);
		}
		case 2:
		{
			SetPlayerInterior(playerid, 10);
			SetPlayerPos(playerid, -974.2203,1089.6129,1344.9800);
			InterpolateCameraPos(playerid, -967.523437, 1060.484741, 1348.892578, -1130.473632, 1072.298950, 1369.214233, 10000);
			InterpolateCameraLookAt(playerid, -972.479736, 1060.608520, 1348.244628, -1125.967407, 1071.078613, 1367.424194, 10000);
			camtimer[playerid] = SetTimerEx("ChangeCamera", 10000, 0, "i", playerid);
		}
		case 3:
		{
			SetPlayerInterior(playerid, 18);
			SetPlayerPos(playerid, 1251.2056,-25.2684,1001.0347);
			InterpolateCameraPos(playerid, 1267.452514, 5.661926, 1008.270385, 1285.548339, 5.310754, 1002.339294, 10000);
			InterpolateCameraLookAt(playerid, 1272.014648, 5.540562, 1006.227844, 1285.231811, 0.342287, 1001.876525, 12000);
			camtimer[playerid] = SetTimerEx("ChangeCamera", 12000, 0, "i", playerid);
		}
		case 4:
		{
			SetPlayerInterior(playerid, 3);
			SetPlayerPos(playerid, 244.9740,142.1823,1003.0234);
			InterpolateCameraPos(playerid, 238.796234, 194.843811, 1008.599975, 238.569137, 184.553054, 1003.095092, 10000);
			InterpolateCameraLookAt(playerid, 238.687301, 190.380950, 1006.348083, 238.520050, 179.554733, 1003.214965, 11000);
			camtimer[playerid] = SetTimerEx("ChangeCamera", 11000, 0, "i", playerid);
		}
		case 5:
		{
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid, 1357.611938, -1348.428222, 12.863492);
			InterpolateCameraPos(playerid, 1357.611938, -1348.428222, 12.863492, 1357.581665, -1233.927490, 12.794725, 25000);
			InterpolateCameraLookAt(playerid, 1357.498413, -1343.438476, 12.564220, 1357.495361, -1228.931884, 12.604695, 25000);
			con_cam[playerid] = 0;
			return camtimer[playerid] = SetTimerEx("ChangeCamera", 25000, 0, "i", playerid);
		}
	}
	con_cam[playerid] ++; 
	return 1;
}

SendClientMessageToAll_(color, message[])
{
	SendClientMessageToAll(color, message);

	new str[170];
    new h, m, s;
    new y, mn, d;

    getdate(y, mn, d);
    gettime(h, m, s);

    new st, end;

    for(new i = 0; i < 10; i++)
    {
       st = strfind(message, "{");
       end = strfind(message, "}");
       if(st != -1 && end != -1) strdel(message, st, end + 1);
    }
    format(str, sizeof(str), "``[ %d:%d:%d | %d:%d:%d ] %s``", y, mn, d, h, m, s, message);
	DCC_SendChannelMessage(dcc_channel_chat, str);
	return 1;
}


public OnPlayerConnectEx(playerid)
{
	con_cam[playerid] = 0;
	CallLocalFunction("ChangeCamera", "i", playerid);

	TextDrawHideForPlayer(playerid, connecttd[3]);
	TextDrawHideForPlayer(playerid, connecttd[2]);

	TextDrawShowForPlayer(playerid, connecttd[0]);
	TextDrawShowForPlayer(playerid, connecttd[1]);
	TextDrawShowForPlayer(playerid, connecttd[4]);
	TextDrawShowForPlayer(playerid, connecttd[5]);
	TextDrawShowForPlayer(playerid, connecttd[6]);
	TextDrawShowForPlayer(playerid, connecttd[7]);
	TextDrawShowForPlayer(playerid, connecttd[8]);
	TextDrawShowForPlayer(playerid, connecttd[9]);
	TextDrawShowForPlayer(playerid, connecttd[10]);
	TextDrawShowForPlayer(playerid, connecttd[11]);

	SetPlayerVirtualWorld(playerid, playerid + 1);

	SetPlayerColor(playerid, 0xAFAFAF88);
	new str[256];
	format(str, sizeof(str), "~y~%s ~w~has ~g~connected ~w~to the server", PlayerName(playerid));
	TextDrawSetString(LGGW[1], str);
	format(str, sizeof(str), "{AFAFAF}* %s has connected to the server.", PlayerName(playerid));
	SendClientMessageToAll_(-1, str);
	SetPlayerColor(playerid, 0xAFAFAF88);
	SendDeathMessage(INVALID_PLAYER_ID, playerid, 200);

	rbar[playerid] = CreatePlayerProgressBar(playerid, 501.000000, 350.000000, 109.500000, 3.200000, -1642851073, TIME_FOR_ROB_END, 0);
	turfbar[playerid][0] = CreatePlayerProgressBar(playerid, 314.000000, 388.000000, 134.500000, 12.699999, -1429936641, TIME_FOR_TURF, 1);
	turfbar[playerid][1]  = CreatePlayerProgressBar(playerid, 313.000000, 388.000000, 134.500000, 12.699999, -1429936641, TIME_FOR_TURF, 0);
	
	//tune shop + vehicle shop
	RemoveBuildingForPlayer(playerid, 4178, 1686.880, -1459.959, 16.296, 0.250);
	RemoveBuildingForPlayer(playerid, 4179, 1686.880, -1459.959, 16.296, 0.250);
	
	//summer camp(gg position)
	RemoveBuildingForPlayer(playerid, 705, -1081.593, -1143.250, 128.335, 0.250);
	
	WriteLog(LOG_CONNECTS, "Name: %s | IP: %s", PlayerName(playerid), PlayerIP(playerid));
	
	switch(registered[playerid])
	{
		case 0:
		{
			format(str, sizeof(str), "Welcome back to Lazer Gaming Gang WarZ\n\n%s account is registered. Please enter your password below to login", PlayerName(playerid));
			Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,"LGGW - Login",str,"Login","Quit");
		}
		case 1:
		{
			format(str, sizeof(str), "Welcome to Lazer Gaming Gang WarZ\n\nYour account \"%s\" is not registered. Please enter a desired password below to register", PlayerName(playerid));
			Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT,"LGGW - Registration",str,"Register","Quit"); 
		}
	}

	for(new i = 0; i < 100; i++) SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "{801500}[ Warning ] {ff0000}If You Are Here To Advertise, Good Bye!  ");
	return 1;
}


public OnRconLoginAttempt(ip[], password[], success) 
{
	new id = -1;
	
	foreach(new i : Player)
	{
		if(isequal(ip, PlayerIP(i)))
		{
			id = i;
			break;
		}
	}

	new str[256];
	format(str, sizeof(str), "[ STEP 1 ] `%s[%d]` is trying to access RCON... @Developers use /aka to check who is this! May be he is an enemy :angry: (password: `%s`)", PlayerName(id), id, password);
	DCC_SendChannelMessage(dcc_channel_rcon, str);
	
	if(success)																			
	{
		format(str, sizeof(str), "[ STEP 1 ] **`%s[%d]` has accessed RCON partialy! :face_with_monocle:**", PlayerName(id), id);
		DCC_SendChannelMessage(dcc_channel_rcon, str);
		Dialog_Show(id, DIALOG_RCON, DIALOG_STYLE_PASSWORD, "LGGW - Rcon protection", "You have logged in RCON partially,\nNow input the 2nd RCON security password to access the SERVER features", "Access", "Quit");
		rconattempts[id] = 0;
	}
	return 1;
}

public OnPlayerUpdate(playerid)
{
	new str[50];
	format(str, sizeof(str), "~r~FPS:_~y~%d~n~~r~Ping:_~y~%d", pFPS[playerid] - 1, GetPlayerPing(playerid));
	PlayerTextDrawSetString(playerid, fplabel_1[playerid], str);
	
	new drunk_new;
	drunk_new = GetPlayerDrunkLevel(playerid);
	
	if (drunk_new < 100) 
	{ 
		SetPlayerDrunkLevel(playerid, 2000);
	} 
	else 
	{
		if (pDrunkLevelLast[playerid] != drunk_new) 
		{
			new wfps = pDrunkLevelLast[playerid] - drunk_new;
			
			if ((wfps > 0) && (wfps < 200))
				pFPS[playerid] = wfps;
			
			pDrunkLevelLast[playerid] = drunk_new;
		}
	}

	if(spec[playerid])
	{
		if(GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(specid[playerid])) SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(specid[playerid]));
		if(GetPlayerInterior(playerid) != GetPlayerInterior(specid[playerid])) SetPlayerInterior(playerid, GetPlayerInterior(specid[playerid]));
	}
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	new str[128];
	PlayerTextDrawDestroy(playerid, fplabel_1[playerid]);
	PlayerTextDrawDestroy(playerid, vtunetd_1[playerid]);
	PlayerTextDrawDestroy(playerid, wastedtd_1[playerid]);
	PlayerTextDrawDestroy(playerid, vehtd_1[playerid]);
	PlayerTextDrawDestroy(playerid, turfcashtd[playerid]);
	PlayerTextDrawDestroy(playerid, moneytd_1[playerid]);
	PlayerTextDrawDestroy(playerid, DM_1[playerid]);

	for(new i = 0; i < 5; i++) PlayerTextDrawDestroy(playerid, gangtd_1[playerid][i]);
	for(new i = 0; i < 2; i++) PlayerTextDrawDestroy(playerid, zonetd_1[playerid][i]);
	for(new i = 0; i < 3; i++) PlayerTextDrawDestroy(playerid, takeovertd_1[playerid][i]);
	for(new i = 0; i < 6; i++) PlayerTextDrawDestroy(playerid, statstd_1[playerid][i]);

	DestroyPlayerProgressBar(playerid, rbar[playerid]);
	DestroyPlayerProgressBar(playerid, turfbar[playerid][0]);
	DestroyPlayerProgressBar(playerid, turfbar[playerid][1]);

	SendDeathMessage(INVALID_PLAYER_ID, playerid, 201);

	new szDisconnectReason[3][] =
    {
        "Timeout/Crash",
        "Quit",
        "Kick/Ban"
    };
	
	format(str, sizeof(str), "~y~%s ~w~has ~r~left ~w~the server (%s)", PlayerName(playerid), szDisconnectReason[reason]);
	TextDrawSetString(LGGW[1], str);
	format(str, sizeof(str), "* %s has left the server (%s)", PlayerName(playerid), szDisconnectReason[reason]);
	SendClientMessageToAll_(-1, str); 

	new h, m, s;
    new y, mn, d;
    getdate(y, mn, d);
    gettime(h, m, s);
    format(str, sizeof(str), ":red_circle: `[ %d:%d:%d | %d:%d:%d ]` **%s[%d]** has left the server (`%s`)", y, mn, d, h, m, s, PlayerName(playerid), playerid, szDisconnectReason[reason]);
	DCC_SendChannelMessage(dcc_channel_con_discon, str);

	if(logged[playerid] == 1)
	{
		SaveServerData();

		if(INVALID_VEHICLE_ID != priveh[playerid])   
		{
			DestroyPrivateVehicle(playerid);
		}
		if(INVALID_VEHICLE_ID != adminveh[playerid])
		{
			DestroyVehicle(adminveh[playerid]); 
			adminveh[playerid] = INVALID_VEHICLE_ID;
		}

		WriteLog(LOG_DISCONNECTS, "Name: %s | Reason: %s", PlayerName(playerid), szDisconnectReason[reason]);

		new id = enemy[playerid];

		if(inminigame[playerid] == 1) 
		{
			inminigame[playerid] = 0;
			if(indm[playerid] == 1)
			{
				indm[playerid] = 0;
			}
			else if(induel[playerid] == 1)
			{
				GivePlayerCash(id, duelbet[playerid]);
				GivePlayerCash(playerid, -duelbet[playerid]);
				new Float:hp;
				GetPlayerHealth(id, hp);
				format(str, sizeof(str), "{004000}[ Duel ] {00FF00}\"%s\" won the duel against \"%s\" with %.2f HP (Oponnent disconnected)", PlayerName(id), PlayerName(playerid), hp);
				SendClientMessageToAll_(-1, str);
				USERINFO[id][dwon]++;
				induel[id] = 0;
				inminigame[id] = 0;
				duelinvited[id] = 0;
				duelinviter[id] = 0;
				ResetPlayerWeapons(id);
				SetPlayerDetails(id);
			}
			else if(inlms[playerid] == 1)
			{
				inlms[playerid] = 0;
				format(str, sizeof(str), "{800080}[ LMS ] {8000FF}\"%s[%d]\" dropped out of LMS with %d kills (Player disconnected)", PlayerName(playerid), playerid, lmskills[playerid]);
				SendClientMessageToAll_(-1, str);
				new count;
				foreach(new i : Player) if(inlms[i] == 1) count ++;
				if(count == 1)
				{
					foreach(new i : Player)
					{
						if(inlms[i] == 1)
						{
							format(str, sizeof(str), "{800080}[ LMS ] {8000FF}\"%s[%d]\" survived in the event as the Last Man Standing with %d number of kills and won %d$", PlayerName(i), i, lmskills[i], MONEY_PER_LMS_KILL * lmskills[i]);
							SendClientMessageToAll_(-1, str);
							lmsstarted = 0;
							inlms[i] = 0;
							inminigame[i] = 0;
							USERINFO[i][lmswon] ++;
							ResetPlayerWeapons(i);
							SetPlayerDetails(i);
							foreach(new k : Player)
							{
								SetPlayerMarkerForPlayer(k, i, COLOR[i]);
								SetPlayerMarkerForPlayer(k, playerid, COLOR[playerid]);
							}
							if(lmskills[i] == 0)
							{
								GivePlayerCash(i, MONEY_PER_LMS_KILL / 2);
								break;
							}
							else
							{
								GivePlayerCash(i, MONEY_PER_LMS_KILL * lmskills[playerid]);
								break;
							}
						}
					}
				}
			}
		}
		if(duelinviter[playerid] == 1)
		{
			KillTimer(dstimer[playerid]);
			duelinvited[id] = 0;
			format(str, sizeof(str), "{004000}[ Duel ] {00FF00}Duel request by %s has been expired (Oponnent disconnected)", PlayerName(playerid));
			SendClientMessage(id, -1, str);
		}
		if(duelinvited[playerid] == 1)
		{
			KillTimer(dstimer[id]);
			duelinviter[id] = 0;
			format(str, sizeof(str), "{004000}[ Duel ] {00FF00}Duel request for %s has been expired (Oponnent disconnected)", PlayerName(playerid));
			SendClientMessage(id, -1, str);
		}

		foreach(new i : Player)
		{
			if(spec[i] == 1 && specid[i] == playerid)
			{
				PC_EmulateCommand(i, "/specoff");
			}
		}

		ResetPlayerVars(playerid);
		
		if(spec[playerid] == 1) TogglePlayerSpectating(playerid, 0);
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	new str[128];
	PlayerTextDrawShow(playerid, fplabel_1[playerid]);
	SetCameraBehindPlayer(playerid);
	if(USERINFO[playerid][jailed] == 1)
	{
		if(justconnected[playerid] == 1)
		{
			PC_EmulateCommand(playerid, "/rules");
			SendClientMessage(playerid, -1, "{0000FF}[ Use ] {00BFFF}/cmds to see server commands");
			SendClientMessage(playerid, -1, "{0000FF}[ Use ] {00BFFF}/keys to see server available keys");
			SendClientMessage(playerid, -1, "{0000FF}[ Use ] {00BFFF}/help get help in detail");
			SendClientMessage(playerid, -1, "{0000FF}[ Use ] {00BFFF}/credits to see server creators");
			if(USERINFO[playerid][ingang] == 1)
			{
				format(str, sizeof(str), "{6800b3}[ Gang ] {9370DB}%s | Level | %s ", ReplaceUwithS(GANGINFO[USERINFO[playerid][gid]][gname]), GangLevelName(USERINFO[playerid][glevel]));
				SendClientMessage(playerid, -1, str);
			}
			justconnected[playerid] = 0;
		}
		SetPlayerPos(playerid, 264.4176, 77.8930, 1001.0391);
		SetPlayerInterior(playerid, 6);
		StopAudioStreamForPlayer(playerid);
		return SetPlayerHealth(playerid, 100);
	}   

	if(justconnected[playerid] == 1)
	{	
		PC_EmulateCommand(playerid, "/rules");
		SendClientMessage(playerid, -1, "{0000FF}[ Use ] {00BFFF}/cmds to see server commands");
		SendClientMessage(playerid, -1, "{0000FF}[ Use ] {00BFFF}/keys to see server available keys");
		SendClientMessage(playerid, -1, "{0000FF}[ Use ] {00BFFF}/help get help in detail");
		SendClientMessage(playerid, -1, "{0000FF}[ Use ] {00BFFF}/credits to see server creators");
		if(USERINFO[playerid][ingang] == 1)
		{
			format(str, sizeof(str), "{6800b3}[ Gang ] {9370DB}%s | Level | %s ", ReplaceUwithS(GANGINFO[USERINFO[playerid][gid]][gname]), GangLevelName(USERINFO[playerid][glevel]));
			SendClientMessage(playerid, -1, str);
		}
		justconnected[playerid] = 0;
	}

	if(frozen[playerid] == 1) TogglePlayerControllable(playerid, 0);

	StopAudioStreamForPlayer(playerid);

	if(USERINFO[playerid][onduty] == 0)
	{
		if(Text3D:INVALID_3DTEXT_ID != glabel[playerid]) Delete3DTextLabel(glabel[playerid]);
		new lstr[50]; 
		format(lstr, sizeof(lstr), "| %s |", GANGINFO[USERINFO[playerid][gid]][gtag]);
		glabel[playerid] = Create3DTextLabel(lstr, GANGINFO[USERINFO[playerid][gid]][gcolor], 0.0, 0.0, 0.0, 50.0, 0); 
		Attach3DTextLabelToPlayer(glabel[playerid], playerid, 0.0, 0.0, 0.3);
	}

	for(new i = 0; i < sizeof(ZONEINFO); i++) 
	{
		GangZoneShowForPlayer(playerid, ZONEID[i], Zone_ColorAlpha(GANGINFO[ZONEINFO[i][zteamid]][gcolor]));
		if(ZONEINFO[i][ZoneAttacker] != -1) GangZoneFlashForPlayer(playerid, ZONEID[i], Zone_ColorAlpha(GANGINFO[ZONEINFO[i][ZoneAttacker]][gcolor])); 
	}

	PlayerTextDrawHide(playerid, wastedtd_1[playerid]);
	TextDrawHideForPlayer(playerid, wastedtd[0]);
	TextDrawHideForPlayer(playerid, wastedtd[1]);
	TextDrawHideForPlayer(playerid, wastedtd[2]);
	TextDrawHideForPlayer(playerid, wastedtd[3]);
	TextDrawHideForPlayer(playerid, wastedtd[4]);

	if(spec[playerid] == 1){
		spec[playerid] = 0;
		return SetPlayerDetails(playerid);
	}

	SAWNBOUGHT[playerid] = 0;
	ARMOURBOUGHT[playerid] = 0;

	ResetPlayerWeapons(playerid);

	if(inminigame[playerid] == 1)
	{
		SetPlayerSkin(playerid, USERINFO[playerid][gskin]);
		if(indm[playerid] == 1)
		{
			for(new t = 0; t < 2; t++) TextDrawShowForPlayer(playerid, DM__[t]);
			PlayerTextDrawShow(playerid, DM_1[playerid]);
			SetPlayerColor(playerid, COLOR_DM);
			SetPlayerVirtualWorld(playerid, INT_VW);
			if(dmid[playerid] == 1)
			{
				SetPlayerInterior(playerid,0);
				new Rand = random(sizeof(DM1Randoms));
				SetPlayerPos(playerid, DM1Randoms[Rand][0], DM1Randoms[Rand][1], DM1Randoms[Rand][2]);
				SetPlayerFacingAngle(playerid,DM1Randoms[Rand][3]);
				GivePlayerWeapon(playerid, 24, 2000);
				GivePlayerWeapon(playerid, 25, 2000);
			}
			else if(dmid[playerid] == 2)
			{
				SetPlayerInterior(playerid,3);
				new Rand = random(sizeof(DM2Randoms));
				SetPlayerPos(playerid, DM2Randoms[Rand][0], DM2Randoms[Rand][1], DM2Randoms[Rand][2]);
				SetPlayerFacingAngle(playerid,DM2Randoms[Rand][3]);
				GivePlayerWeapon(playerid, 24, 2000);
				GivePlayerWeapon(playerid, 25, 2000);
				GivePlayerWeapon(playerid, 30, 2000);
			}
			else if(dmid[playerid] == 3)
			{
				SetPlayerInterior(playerid,18);
				new Rand = random(sizeof(DM3Randoms));
				SetPlayerPos(playerid, DM3Randoms[Rand][0], DM3Randoms[Rand][1], DM3Randoms[Rand][2]);
				SetPlayerFacingAngle(playerid,DM3Randoms[Rand][3]);
				GivePlayerWeapon(playerid, 34, 2000);
				GivePlayerWeapon(playerid, 27, 2000);
			}
			else if(dmid[playerid] == 4)
			{
				SetPlayerInterior(playerid,10);
				new Rand = random(sizeof(DM4Randoms));
				SetPlayerPos(playerid, DM4Randoms[Rand][0], DM4Randoms[Rand][1], DM4Randoms[Rand][2]);
				SetPlayerFacingAngle(playerid,DM4Randoms[Rand][3]);
				GivePlayerWeapon(playerid, 38, 2000);
			}
			else if(dmid[playerid] == 5)
			{
				SetPlayerInterior(playerid,1);
				new Rand = random(sizeof(DM5Randoms));
				SetPlayerPos(playerid, DM5Randoms[Rand][0], DM5Randoms[Rand][1], DM5Randoms[Rand][2]);
				SetPlayerFacingAngle(playerid,DM5Randoms[Rand][3]);
				GivePlayerWeapon(playerid, 26, 2000);
				GivePlayerWeapon(playerid, 28, 2000);
			}
			else if(dmid[playerid] == 6)
			{
				SetPlayerInterior(playerid,0);
				new Rand = random(sizeof(DM6Randoms));
				SetPlayerPos(playerid, DM6Randoms[Rand][0], DM6Randoms[Rand][1], DM6Randoms[Rand][2]);
				SetPlayerFacingAngle(playerid, DM6Randoms[Rand][3]);
				GivePlayerWeapon(playerid, 24, 2000);
				GivePlayerWeapon(playerid, 25, 2000);
				GivePlayerWeapon(playerid, 4, 2000);
			}
		}
		else if(ingg[playerid] == 1)
		{
			SetPlayerHealth(playerid, 100);
			new rand = random(sizeof(GGRandoms));
			SetPlayerPos(playerid, GGRandoms[rand][0], GGRandoms[rand][1], GGRandoms[rand][2]);
			SetPlayerFacingAngle(playerid, GGRandoms[rand][3]);
			if(gg_lvl[playerid] == 1) GivePlayerWeapon(playerid, 9, 2000);
			if(gg_lvl[playerid] == 2) GivePlayerWeapon(playerid, 4, 2000);
			if(gg_lvl[playerid] == 3) GivePlayerWeapon(playerid, 30, 2000);
			if(gg_lvl[playerid] == 4) GivePlayerWeapon(playerid, 22, 2000);
			if(gg_lvl[playerid] == 5) GivePlayerWeapon(playerid, 29, 2000);
			if(gg_lvl[playerid] == 6) GivePlayerWeapon(playerid, 33, 2000);
			if(gg_lvl[playerid] == 7) GivePlayerWeapon(playerid, 27, 2000);
			if(gg_lvl[playerid] == 8) GivePlayerWeapon(playerid, 25, 2000);
			if(gg_lvl[playerid] == 9) GivePlayerWeapon(playerid, 23, 2000);
			if(gg_lvl[playerid] == 10) GivePlayerWeapon(playerid, 24, 2000);
			if(gg_lvl[playerid] == 11) GivePlayerWeapon(playerid, 35, 2000);
			if(gg_lvl[playerid] == 12) GivePlayerWeapon(playerid, 36, 2000);
			if(gg_lvl[playerid] == 13) GivePlayerWeapon(playerid, 28, 2000);
			if(gg_lvl[playerid] == 14) GivePlayerWeapon(playerid, 31, 2000);
			if(gg_lvl[playerid] == 15) GivePlayerWeapon(playerid, 34, 2000);
			if(gg_lvl[playerid] == 16) GivePlayerWeapon(playerid, 37, 2000);
			if(gg_lvl[playerid] == 17) GivePlayerWeapon(playerid, 16, 2000);
			if(gg_lvl[playerid] == 18) GivePlayerWeapon(playerid, 8, 2000);
			if(gg_lvl[playerid] == 19) GivePlayerWeapon(playerid, 6, 2000);
			if(gg_lvl[playerid] >= 20) GivePlayerWeapon(playerid, 1, 2000);
		}
		else if(induel[playerid] == 1)
		{
			inminigame[playerid] = 0;
			induel[playerid] = 0;
			ResetPlayerWeapons(playerid);
			SetPlayerDetails(playerid);
		}
		else if(inlms[playerid] == 1)
		{
			inminigame[playerid] = 0;
			inlms[playerid] = 0;
			ResetPlayerWeapons(playerid);
			SetPlayerDetails(playerid);
			foreach(new k : Player)
			{
				SetPlayerMarkerForPlayer(k, playerid, COLOR[playerid]);
			}
		}
	}
	else
	{
		picked[playerid] = 0;
		hospicked[playerid] = 0;
		killinginprogress[playerid] = 0;
		SetPlayerSkin(playerid, USERINFO[playerid][gskin]);
		SetPlayerArmour(playerid, 0);
		SetPlayerHealth(playerid, 100);
		GivePlayerWeapon(playerid, 30, 150);
		GivePlayerWeapon(playerid, 24, 100);
		GivePlayerWeapon(playerid, 25, 150);
		if(USERINFO[playerid][ingang] == 0)
		{    
			SetPlayerVirtualWorld(playerid, INT_VW);    
			switch(USERINFO[playerid][gid])
			{
				case TEAM_GROVE:
				{
					SetPlayerTeam(playerid, TEAM_GROVE);
					SetPlayerPos(playerid,2495.9734,-1705.2390,1014.7422);
					SetPlayerInterior(playerid, 3);
					SetPlayerColor(playerid, COLOR_GROVE);
				}
				case TEAM_AZTECA:
				{
					SetPlayerTeam(playerid, TEAM_AZTECA);
					SetPlayerPos(playerid,2324.3496,-1135.6730,1051.3047);
					SetPlayerInterior(playerid, 12);
					SetPlayerColor(playerid, COLOR_AZTECA);
				}
				case TEAM_JUSTICE:
				{
					SetPlayerTeam(playerid, TEAM_JUSTICE);
					SetPlayerPos(playerid,322.2002,310.1391,999.1484);
					SetPlayerInterior(playerid, 5);
					SetPlayerColor(playerid, COLOR_JUSTICE);
				}
				case TEAM_BALLAS:
				{
					SetPlayerTeam(playerid, TEAM_BALLAS);
					SetPlayerPos(playerid,323.7699,1125.5558,1083.8828);
					SetPlayerInterior(playerid, 5);
					SetPlayerColor(playerid, COLOR_BALLAS);
				}
				case TEAM_VAGOS:
				{
					SetPlayerTeam(playerid, TEAM_VAGOS);
					SetPlayerPos(playerid,2344.9517,-1179.2848,1027.9766);
					SetPlayerInterior(playerid, 5);
					SetPlayerColor(playerid, COLOR_VAGOS);
				}
				case TEAM_MAFIA:
				{
					SetPlayerTeam(playerid, TEAM_MAFIA);
					SetPlayerPos(playerid,2449.2959,-1703.5011,1013.5078);
					SetPlayerInterior(playerid, 2);
					SetPlayerColor(playerid, COLOR_MAFIA);
				} 
				case TEAM_VIP:
				{
					SetPlayerTeam(playerid, TEAM_VIP);
					SetPlayerPos(playerid,232.7027,1202.4850,1084.4160);
					SetPlayerInterior(playerid, 3);
					SetPlayerColor(playerid, COLOR_VIP);
					SetPlayerArmour(playerid, 100);
				} 
			}
		}
		else
		{
			SetPlayerSkin(playerid, USERINFO[playerid][gskin]);
			SetPlayerTeam(playerid, USERINFO[playerid][gid]);
			SetPlayerColor(playerid, GANGINFO[USERINFO[playerid][gid]][gcolor]);
			SetPlayerInterior(playerid, 0);
			if(GANGINFO[USERINFO[playerid][gid]][ghouse] == 0)
			{
				new Rand = random(sizeof(LSRandoms));
				SetPlayerPos(playerid, LSRandoms[Rand][0], LSRandoms[Rand][1], LSRandoms[Rand][2]);
				SetPlayerFacingAngle(playerid, LSRandoms[Rand][3]);
				SetPlayerVirtualWorld(playerid, 0);
			}
			else
			{
				SetPlayerVirtualWorld(playerid, INT_VW);    
				SetPlayerInterior(playerid, HOUSEINFO[GANGINFO[USERINFO[playerid][gid]][ghouseid]][hintid]);
				SetPlayerPos(playerid, HOUSEINFO[GANGINFO[USERINFO[playerid][gid]][ghouseid]][spawn][0], HOUSEINFO[GANGINFO[USERINFO[playerid][gid]][ghouseid]][spawn][1], HOUSEINFO[GANGINFO[USERINFO[playerid][gid]][ghouseid]][spawn][2]);
				SetPlayerFacingAngle(playerid, HOUSEINFO[GANGINFO[USERINFO[playerid][gid]][ghouseid]][spawn][3]);
			}
			
		}
	}
	if(USERINFO[playerid][onduty] == 1)
	{
		SetPlayerHealth(playerid, 100);
		SetPlayerArmour(playerid, 0);
		SetPlayerTeam(playerid, TEAM_ADMIN);
		SetPlayerColor(playerid, COLOR_ADMIN);
		SetPlayerSkin(playerid, 294);
		GivePlayerWeapon(playerid, 38, 9999);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		new Rand = random(sizeof(LSRandoms));
		SetPlayerPos(playerid, LSRandoms[Rand][0], LSRandoms[Rand][1], LSRandoms[Rand][2]);
		SetPlayerFacingAngle(playerid, LSRandoms[Rand][3]);
	}
	
	foreach(new i : Player)
	{
		if(spec[i] == 1 && specid[i] == playerid)
		{
			PC_EmulateCommand(i, "/specoff");
			format(str, sizeof(str), "/spec %d", playerid);
			PC_EmulateCommand(i, str);
		}
	}

	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	SendDeathMessage(killerid, playerid, reason);
	
	TextDrawHideForPlayer(playerid, zonetd);
	TextDrawHideForPlayer(playerid, statstd);

	for(new i = 0; i < 3; i++) TextDrawHideForPlayer(playerid, vtunetd[i]);
	for(new i = 0; i < 5; i++) TextDrawHideForPlayer(playerid, takeovertd[i]);
	for(new i = 0; i < 2; i++) TextDrawHideForPlayer(playerid, DM__[i]);
	
	PlayerTextDrawHide(playerid,fplabel_1[playerid]);
	PlayerTextDrawHide(playerid,vtunetd_1[playerid]);
	PlayerTextDrawHide(playerid,vehtd_1[playerid]);
	PlayerTextDrawHide(playerid,turfcashtd[playerid]);
	PlayerTextDrawHide(playerid,moneytd_1[playerid]);
	PlayerTextDrawHide(playerid,DM_1[playerid]);
	
	for(new i = 0; i < 2; i++) PlayerTextDrawHide(playerid,zonetd_1[playerid][i]);
	for(new i = 0; i < 3; i++) PlayerTextDrawHide(playerid,takeovertd_1[playerid][i]);
	for(new i = 0; i < 6; i++) PlayerTextDrawHide(playerid,statstd_1[playerid][i]);

	HidePlayerProgressBar(playerid, rbar[playerid]);
	HidePlayerProgressBar(playerid, turfbar[playerid][0]);
	HidePlayerProgressBar(playerid, turfbar[playerid][1]);

	TextDrawShowForPlayer(playerid, wastedtd[0]);
	TextDrawShowForPlayer(playerid, wastedtd[1]);
	TextDrawShowForPlayer(playerid, wastedtd[2]);
	TextDrawShowForPlayer(playerid, wastedtd[3]);
	TextDrawShowForPlayer(playerid, wastedtd[4]);

	if(killerid != INVALID_PLAYER_ID)
	{
		new dstr[128];
		format(dstr, sizeof(dstr), "%s_~w~killed you", PlayerName(killerid));
		PlayerTextDrawColor(playerid, wastedtd_1[playerid], GetPlayerColor(playerid)); 
		PlayerTextDrawSetString(playerid, wastedtd_1[playerid], dstr);
		PlayerTextDrawShow(playerid, wastedtd_1[playerid]);

	    USERINFO[playerid][pdeaths] ++;
	    USERINFO[killerid][pkills] ++;

	    SetPlayerScore(killerid, GetPlayerScore(killerid) + 1);

		if(inminigame[playerid] == 1)
		{
			if(indm[playerid] == 1)
			{
				SetPlayerHealth(killerid, 100);
				GivePlayerCash(killerid, 5);

				new str[128];
				dmkills[killerid]++;
				dmspree[killerid]++;
				dmdeaths[playerid]++;
				dmspree[playerid] = 0;

				if(dmdeaths[killerid] == 0) format(str, sizeof(str), "~g~kills:_%d______________ ~r~deaths:_%d______________ ~y~killingspree:_%d______________ ~p~ratio:_0.00", dmkills[killerid], dmdeaths[killerid], dmspree[killerid]);
				else format(str, sizeof(str), "~g~kills:_%d______________ ~r~deaths:_%d______________ ~y~killingspree:_%d______________ ~p~ratio:_%.2f", dmkills[killerid], dmdeaths[killerid], dmspree[killerid], floatdiv(dmkills[killerid], dmdeaths[killerid]));
				PlayerTextDrawSetString(killerid, DM_1[killerid], str);

				format(str, sizeof(str), "~g~kills:_%d______________ ~r~deaths:_%d______________ ~y~killingspree:_0______________ ~p~ratio:_%.2f", dmkills[playerid], dmdeaths[playerid], floatdiv(dmkills[playerid], dmdeaths[playerid]));
				PlayerTextDrawSetString(playerid, DM_1[playerid], str);
			}
			else if(induel[playerid] == 1)
			{
				new id = enemy[playerid];

				inminigame[id] = 0;
				GivePlayerCash(id, duelbet[playerid]);
				GivePlayerCash(playerid, -duelbet[playerid]);
				new Float:hp;
				GetPlayerHealth(id, hp);
				new str[128];
				format(str, sizeof(str), "{004000}[ Duel ] {00FF00}\"%s\" won the duel against \"%s\" with %.2f HP", PlayerName(id), PlayerName(playerid), hp);
				SendClientMessageToAll_(-1, str);
				USERINFO[id][dwon]++;
				induel[id] = 0;
				duelinvited[id] = 0;
				duelinvited[playerid] = 0;
				duelinviter[id] = 0;
				duelinviter[playerid] = 0;
				ResetPlayerWeapons(id);
				SetPlayerDetails(id);
				PlayerPlaySound(playerid,1069,0.0,0.0,0.0);
				PlayerPlaySound(id,1069,0.0,0.0,0.0);
			}
			else if(inlms[playerid] == 1)
			{
				new str[180];
				lmskills[killerid] ++;
				format(str, sizeof(str), "{800080}[ LMS ] {8000FF}\"%s[%d]\" dropped out of LMS with %d kills (killed by %s[%d])", PlayerName(playerid), playerid, lmskills[playerid], PlayerName(killerid), killerid);
				SendClientMessageToAll_(-1, str);
				new count;
				foreach(new i : Player)
				{
					if(inlms[i] == 1 && inminigame[i] == 1)
					{
						count++;
					}
				}
				if(count == 2)
				{
					format(str, sizeof(str), "{800080}[ LMS ] {8000FF}\"%s[%d]\" survived in the event as the Last Man Standing with %d number of kills and won %d$", PlayerName(killerid), killerid, lmskills[killerid], lmskills[killerid] * MONEY_PER_LMS_KILL); 
					SendClientMessageToAll_(-1, str);
					ResetPlayerWeapons(killerid);
					SetPlayerDetails(killerid);
					foreach(new k : Player)
					{
						SetPlayerMarkerForPlayer(k, killerid, COLOR[killerid]);
					}
					GivePlayerCash(killerid, lmskills[killerid] * MONEY_PER_LMS_KILL);
					USERINFO[killerid][lmswon] ++;
					inlms[killerid] = 0;
					inminigame[killerid] = 0;
					lmsstarted = 0;
				}
			}
			else if(ingg[playerid] == 1)
			{
				gg_lvl[killerid]++;
				ResetPlayerWeapons(killerid);
				if(gg_lvl[killerid] == 2) GivePlayerWeapon(killerid, 4, 2000);
				if(gg_lvl[killerid] == 3) GivePlayerWeapon(killerid, 30, 2000);
				if(gg_lvl[killerid] == 4) GivePlayerWeapon(killerid, 22, 2000);
				if(gg_lvl[killerid] == 5) GivePlayerWeapon(killerid, 29, 2000);
				if(gg_lvl[killerid] == 6) GivePlayerWeapon(killerid, 33, 2000);
				if(gg_lvl[killerid] == 7) GivePlayerWeapon(killerid, 27, 2000);
				if(gg_lvl[killerid] == 8) GivePlayerWeapon(killerid, 25, 2000);
				if(gg_lvl[killerid] == 9) GivePlayerWeapon(killerid, 23, 2000);
				if(gg_lvl[killerid] == 10) GivePlayerWeapon(killerid, 24, 2000);
				if(gg_lvl[killerid] == 11) GivePlayerWeapon(killerid, 35, 2000);
				if(gg_lvl[killerid] == 12) GivePlayerWeapon(killerid, 36, 2000);
				if(gg_lvl[killerid] == 13) GivePlayerWeapon(killerid, 28, 2000);
				if(gg_lvl[killerid] == 14) GivePlayerWeapon(killerid, 31, 2000);
				if(gg_lvl[killerid] == 15) GivePlayerWeapon(killerid, 34, 2000);
				if(gg_lvl[killerid] == 16) GivePlayerWeapon(killerid, 37, 2000);
				if(gg_lvl[killerid] == 17) GivePlayerWeapon(killerid, 16, 2000);
				if(gg_lvl[killerid] == 18) GivePlayerWeapon(killerid, 8, 2000);
				if(gg_lvl[killerid] == 19) GivePlayerWeapon(killerid, 6, 2000);
				if(gg_lvl[killerid] >= 20) GivePlayerWeapon(killerid, 1, 2000);

				new str[128];
				if(gg_lvl[killerid] == 20) format(str, sizeof(str), "{408080}OMG! OMG!! OMG!!! \"%s\" reached the maximum level (%d) by killing \"%s\" and got %s", PlayerName(killerid), gg_lvl[killerid], PlayerName(playerid), RetGGWep(killerid));
			 	else if(gg_lvl[killerid] > 20) format(str, sizeof(str), "{408080}\"%s\" killed \"%s\" and he is at the maximum level(20) with %s", PlayerName(killerid), PlayerName(playerid), RetGGWep(killerid));
			 	else format(str, sizeof(str), "{408080}\"%s\" killed '%s' in gungame and got \"%s\" (level: %d)", PlayerName(killerid), PlayerName(playerid), RetGGWep(killerid), gg_lvl[killerid]);
				SendClientMessageToAll_(-1, str);
			}
		}
		else
		{
			new str[128];
			rampage[killerid] ++;
			
			if(GetPlayerWeapon(killerid) == 0)
			{
				format(str, sizeof(str), "{8967B8}* \"%s\" has brutally murdered \"%s\" with bare hands", PlayerName(killerid), PlayerName(playerid));
				SendClientMessageToAll_(-1, str);
				USERINFO[killerid][bkills] ++;
			}
			if(rampage[playerid] >= 5)
			{
				format(str, sizeof(str), "{8967B8}* \"%s\" has finished %s's rampage on %d kills (reward : $%d)", PlayerName(killerid), PlayerName(playerid), rampage[playerid], MONEY_PER_KILL_IN_RAMPAGE * rampage[playerid]);
				SendClientMessageToAll_(-1, str);
				format(str, sizeof(str), "~r~You ruined someone's~n~party~n~~n~~g~$%d", MONEY_PER_KILL_IN_RAMPAGE * rampage[playerid]);
				GameTextForPlayer(killerid, str, 5000, 5);
				GivePlayerCash(killerid, MONEY_PER_KILL_IN_RAMPAGE * rampage[playerid]);
				revenge[playerid] = 1;
				revengeid[playerid] = killerid;
			}
			if(rampage[killerid] % 5 == 0)
			{
				format(str, sizeof(str), "{8967B8}* \"%s\" is on rampage with %d consicutive killings, KILL HIM AND GET A REWARD (reward : $%d) |He is now in \"%s\"|", PlayerName(killerid), rampage[killerid], MONEY_PER_KILL_IN_RAMPAGE * rampage[killerid], GetPlayerZone(killerid));
				SendClientMessageToAll_(-1, str);
			}
			if(revenge[killerid] == 1 && revengeid[killerid] == playerid)
			{
				format(str, sizeof(str), "{8967B8}* \"%s\" got his revenge on \"%s\"", PlayerName(killerid), PlayerName(playerid));
				SendClientMessageToAll_(-1, str);
				GameTextForPlayer(killerid, "~r~revenge", 5000 ,5);
				USERINFO[killerid][revenges] ++;
				revenge[killerid] = 0; 
			}

			if(USERINFO[killerid][bramp] < rampage[killerid]) USERINFO[killerid][bramp] = rampage[killerid];

			rampage[playerid] = 0;
			
			GivePlayerCash(killerid, 300);
			GivePlayerCash(playerid, -100);
			GANGINFO[USERINFO[playerid][gid]][gdeaths]++;
			if(GANGINFO[USERINFO[playerid][gid]][gscore] > 20) GANGINFO[USERINFO[playerid][gid]][gscore] -= (GANG_SCORE_PER_KILL - 3);
			GANGINFO[USERINFO[killerid][gid]][gkills]++;
			GANGINFO[USERINFO[killerid][gid]][gscore] += GANG_SCORE_PER_KILL;
		}
	}
	else
	{
		GivePlayerCash(playerid, -100);
		PlayerTextDrawSetString(playerid, wastedtd_1[playerid], "~r~commited_suicide");
		PlayerTextDrawShow(playerid, wastedtd_1[playerid]);
		rampage[playerid] = 0;
		if(induel[playerid] == 1)
		{
			new id = enemy[playerid];
			inminigame[playerid] = 0;
			inminigame[id] = 0;
			GivePlayerCash(id, duelbet[playerid]);
			GivePlayerCash(playerid, -duelbet[playerid]);
			new Float:hp;
			GetPlayerHealth(id, hp);
			new str[128];
			format(str, sizeof(str), "{004000}[ Duel ] {00FF00}\"%s\" won the duel against \"%s\" with %.2f HP (Opponent suicide)", PlayerName(id), PlayerName(playerid), hp);
			SendClientMessageToAll_(-1, str);
			USERINFO[id][dwon]++;
			induel[playerid] = 0;
			induel[id] = 0;
			duelinvited[id] = 0;
			duelinvited[playerid] = 0;
			duelinviter[id] = 0;
			duelinviter[playerid] = 0;
			ResetPlayerWeapons(playerid);
			ResetPlayerWeapons(id);
			SetPlayerDetails(playerid);
			SetPlayerDetails(id);
			PlayerPlaySound(playerid,1069,0.0,0.0,0.0);
			PlayerPlaySound(id,1069,0.0,0.0,0.0);
		}
		else if(inlms[playerid] == 1)
		{
			new str[180];
			lmskills[killerid] ++;
			format(str, sizeof(str), "{800080}[ LMS ] {8000FF}\"%s[%d]\" dropped out of LMS with %d kills (suicide)", PlayerName(playerid), playerid, lmskills[playerid]);
			SendClientMessageToAll_(-1, str);
			new count, id = -1;
			foreach(new i : Player)
			{
				if(inlms[i] == 1 && inminigame[i] == 1)
				{
					count++;
					id = i;
				}
			}
			if(count == 2)
			{
				format(str, sizeof(str), "{800080}[ LMS ] {8000FF}\"%s[%d]\" survived in the event as the Last Man Standing with %d number of kills and won %d$", PlayerName(id), id, lmskills[id], lmskills[id] * MONEY_PER_LMS_KILL); 
				SendClientMessageToAll_(-1, str);
				ResetPlayerWeapons(id);
				SetPlayerDetails(id);
				foreach(new k : Player)
				{
					SetPlayerMarkerForPlayer(k, id, COLOR[id]);
				}
				GivePlayerCash(id, lmskills[id] * MONEY_PER_LMS_KILL);
				USERINFO[id][lmswon] ++;
				inlms[id] = 0;
				inminigame[id] = 0;
				lmsstarted = 0;
			}
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	new param[50];
	format(param, sizeof(param), "/stats %d", clickedplayerid);
	return PC_EmulateCommand(playerid, param);
}

public OnPlayerEnterDynamicCP(playerid, STREAMER_TAG_CP checkpointid)
{
	if(IsPlayerInAnyVehicle(playerid) && checkpointid != PVEH[1]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a vehicle");
	new str[1024];
	if(checkpointid == GANG_HOUSE[0])
	{
		if(GetPlayerTeam(playerid) ==  TEAM_GROVE)
		{
			SetPlayerVirtualWorld(playerid, USERINFO[playerid][gid] + 1);
			SetPlayerInterior(playerid,3);
			SetPlayerPos(playerid,2496.049804,-1695.238159,1014.742187);
		}
	}
	else if(checkpointid == GANG_HOUSE[1])
	{
		if(GetPlayerTeam(playerid) ==  TEAM_BALLAS)
		{
			SetPlayerVirtualWorld(playerid, USERINFO[playerid][gid] + 1);
			SetPlayerInterior(playerid,5);
			SetPlayerPos(playerid,318.564971,1118.209960,1083.882812);
		}
	}
	else if(checkpointid == GANG_HOUSE[2])
	{
		if(GetPlayerTeam(playerid) ==  TEAM_JUSTICE)
		{
			SetPlayerVirtualWorld(playerid, USERINFO[playerid][gid] + 1);
			SetPlayerInterior(playerid,5);
			SetPlayerPos(playerid,321.8513,304.1907,999.1484);
		}
	}
	else if(checkpointid == GANG_HOUSE[3])
	{
		if(GetPlayerTeam(playerid) ==  TEAM_AZTECA)
		{
			SetPlayerVirtualWorld(playerid, USERINFO[playerid][gid] + 1);
			SetPlayerInterior(playerid,12);
			SetPlayerPos(playerid,2324.419921,-1145.568359,1050.710083);
		}
	}
	else if(checkpointid == GANG_HOUSE[4])
	{
		if(GetPlayerTeam(playerid) ==  TEAM_MAFIA)
		{
			SetPlayerVirtualWorld(playerid, USERINFO[playerid][gid] + 1);
			SetPlayerInterior(playerid,2);
			SetPlayerPos(playerid,2467.7971,-1698.0714,1013.5078);
		}

	}
	else if(checkpointid == GANG_HOUSE[5])
	{
		if(GetPlayerTeam(playerid) ==  TEAM_VAGOS)
		{
			SetPlayerVirtualWorld(playerid, USERINFO[playerid][gid] + 1);
			SetPlayerInterior(playerid,5);
			SetPlayerPos(playerid,2350.339843,-1181.649902,1027.976562);
		}
	}
	else if(checkpointid == GANG_HOUSE[6])
	{
		if(GetPlayerTeam(playerid) ==  TEAM_VIP)
		{
			SetPlayerVirtualWorld(playerid, USERINFO[playerid][gid] + 1);
			SetPlayerInterior(playerid,3);
			SetPlayerPos(playerid,234.3365,1188.4749,1080.2578);
		}
	}
	else if(checkpointid == GANG_HOUSE[7])
	{
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,1568.8167,-1691.6838,5.8906);
	}
	else if(checkpointid == GANG_HOUSE[8])
	{
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,1939.0334,-1115.5330,27.4523);
	}
	else if(checkpointid == GANG_HOUSE[9])
	{
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,2495.2566,-1689.8093,14.6630);
	}
	else if(checkpointid == GANG_HOUSE[10])
	{
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,1754.6986,-1911.8551,13.5679);
	}
	else if(checkpointid == GANG_HOUSE[11])
	{
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,2288.2871,-1105.8959,37.9766);
	}
	else if(checkpointid == GANG_HOUSE[12])
	{
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid, 2139.5347,-2280.4258,20.6719);
	}
	else if(checkpointid == GANG_HOUSE[13])
	{
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid, 1022.9094,-1123.6510,23.8711);
	}
	else if(checkpointid == PVEH[0])
	{
		strcat(str, "ID\tType\n\n");
		strcat(str, "1 \tCars\n");
		strcat(str, "2 \tMotor bikes\n");
		strcat(str, "3 \tSell vehicle");
		Dialog_Show(playerid, DIALOG_VEH_PREVIEW, DIALOG_STYLE_INPUT, "LGGW - Vehicle Shop", str, "Enter", "Close");
	}
	else if(checkpointid == PVEH[1])
	{
		if(USERINFO[playerid][vowned] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You must have a Personal Vehicle to access Vehicle Shop");
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You need to come with your Personal Vehicle");
		if(vehowned[GetPlayerVehicleID(playerid)] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You need to come with your Personal Vehicle");
		if(vehowner[GetPlayerVehicleID(playerid)] != playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You need to come with your Personal Vehicle");
		SetPlayerVirtualWorld(playerid, playerid + 1);
		SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), playerid + 1);
		Dialog_Show(playerid, DIALOG_VEH_MOD_PREVIEW, DIALOG_STYLE_LIST, "LGGW - Vehicle Shop", "Vehicle Colors\nVehicle Paint Jobs\nVehicle Neons\nVehicle Hydraulics\nVehicle Nitro\nVehicle Wheels", "Select", "Close");
		SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}Click \"purchase\" to buy anything that you have selected");
		SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}After you purchase nitrous, It will be added everytime you spawn your vehicle");
		SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}Neon type 1 is a tube neon and Neon type 2 is a cup neon");
		SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}Read the top of your game screen for more details");
	}

	for(new i = 0; i < sizeof(HOUSEINFO); i++)
	{
		if(checkpointid == GENTERCP[i])
		{  
			if(USERINFO[playerid][ingang]  == 1 && HOUSEINFO[i][howned] == 1 && USERINFO[playerid][gid] == HOUSEINFO[i][hteamid])
			{
				SetPlayerVirtualWorld(playerid, USERINFO[playerid][gid] + 1);
				SetPlayerPos(playerid, HOUSEINFO[i][enterpos][0], HOUSEINFO[i][enterpos][1], HOUSEINFO[i][enterpos][2]);
				SetPlayerInterior(playerid, HOUSEINFO[i][hintid]);
				SetPlayerFacingAngle(playerid, HOUSEINFO[i][enterpos][3]);
				break;
			}
		}
	}

	for(new i = 0; i < sizeof(HOUSEINFO); i++)
	{
		if(checkpointid == GEXITCP[i])
		{
			SetPlayerPos(playerid, HOUSEINFO[i][exitpos][0], HOUSEINFO[i][exitpos][1], HOUSEINFO[i][exitpos][2]);
			SetPlayerInterior(playerid, 0);
			SetPlayerFacingAngle(playerid, HOUSEINFO[i][exitpos][3]);
			SetPlayerVirtualWorld(playerid, 0);
			break;
		}
	}

	for(new i = 0; i < sizeof(SHOPINFO); i++)
	{
		if(checkpointid == SENTERCP[sizeof(SHOPINFO) -1] || checkpointid == SENTERCP[sizeof(SHOPINFO) -2] || checkpointid == SENTERCP[sizeof(SHOPINFO) -3] || checkpointid == SENTERCP[sizeof(SHOPINFO) -4])
		{
			return SendClientMessage(playerid, -1, "[ NOTICE ] 24/7 shop is under construction! It will be open soon");
		}
		if(checkpointid == SENTERCP[i])
		{ 
			SetPlayerInterior(playerid, SHOPINFO[i][sintid]);  
			SetPlayerVirtualWorld(playerid, (i + 1));
			SetPlayerPos(playerid, SHOPINFO[i][enterpos][0], SHOPINFO[i][enterpos][1], SHOPINFO[i][enterpos][2]);
			SetPlayerFacingAngle(playerid, SHOPINFO[i][enterpos][3]);   
			break;
		}
	}

	for(new i = 0; i < sizeof(SHOPINFO); i++)
	{
		if(checkpointid == SEXITCP[i])
		{
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, SHOPINFO[i][exitpos][0], SHOPINFO[i][exitpos][1], SHOPINFO[i][exitpos][2]);
			SetPlayerFacingAngle(playerid, SHOPINFO[i][exitpos][3]);
			break;
		}
	}

	for(new i = 0; i < sizeof(SHOPINFO); i++)
	{
		if(checkpointid == SBUYCP[i])
		{
			if( i == 0 || i == 1)
			{
				strcat(str, "ID\tWeapon       \tPrice\n\n");
				strcat(str, "1 \tArmour       \t$2000\n");
				strcat(str, "2 \t9mm          \t$100\n");
				strcat(str, "3 \tSilenced 9mm \t$120\n");
				strcat(str, "4 \tDesert Eagle \t$300\n");
				strcat(str, "5 \tShotgun      \t$450\n");
				strcat(str, "6 \tSawn-Off     \t$750\n");
				strcat(str, "7 \tSpass12      \t$800\n");
				strcat(str, "8 \tUzi          \t$150\n");
				strcat(str, "9 \tAK47         \t$250\n");
				strcat(str, "10\tM4           \t$200\n");
				strcat(str, "11\tTec-9        \t$150\n");
				strcat(str, "12\tSniper Rifle \t$1200\n");
				strcat(str, "13\tCountry Rifle\t$1300\n\n");
				strcat(str, "[ Note ] You cannot buy Sawn-Off and Armour\n");
				strcat(str, "         at one time");
				Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "LGGW - Ammu Nation", str, "Purchase", "Close");
			}
			else
			{
				strcat(str, "ID\tMeal         \tPrice\n\n");
				strcat(str, "1 \tLarge        \t$750\n");
				strcat(str, "2 \tHot & spicy  \t$400\n");
				strcat(str, "3 \tJumbo chicken\t$150\n\n");
				strcat(str, "[ Note ] Large - Increase your health by 100%\n");
				strcat(str, "         Hot & spicy - Increase your health by 75%\n");
				strcat(str, "         Jumbo chicken - Increase your health by 50%\n");
				Dialog_Show(playerid, DIALOG_BUY_SHOP, DIALOG_STYLE_INPUT, "LGGW - Restaurant", str, "purchase", "Close");
			}
		}
	}
	return 1;
}

/*new HeyRandoms[][] = 
{
	"Hello, sunshine! How are you? Oh, your rays are already making my day brighter!",
	"Hey, howdy, hi! How is it going?",
	"What’s kicking, little chicken?",
	"Howdy-doody! Tell me what’s new!",
	"Hey there, freshman! Wassup?",
	"My name is Scarlett, and I am a bad, bad girl. I like you!",
	"Hi, mister! What is going on?",
	"I come in peace! Chow chow.",
	"Hello-hello! Who’s there? It’s me Scarlett talking.",
	"Hello! There is my pumpkin! I miiiissed you <3",
	"What’s up with you, old soul? Wanna chat?",
	"Hello belle! You are glowing!",
	"Hey love!",
	"Hi, cutie pie, sugar bun!",
	"This is where my bae is at!",
	"Hi, butterfly! Holaaa!",
	"What’s up, handsome? You are making the temperatures soar this season!"
};

new ByeRandoms[][] = 
{
	"See you later, alligator!",
    "Stay out of trouble.",
    "Okay...bye, fry guy!",
    "If I don’t see you around, I'll see you square.",
    "Catch you on the rebound.",
    "Peace out!",
    "Long live and prosper!",
    "Bye bye, butterfly.",
    "It has been emotional, bye.",
    "Out to the door, dinosaur.",
    "Catch you on the flip side.",
    "See you soon, racoon.",
    "You're still here? It's over. Go home. Go!",
    "Don't get run over!"
};

new InvalidIDRandoms[][] = 
{
	"You have mistakenly typed an invalid player ID :woman_facepalming:",
    "This player ID is invalid mister! :p",
    "If I were you, I'll use ``/players`` see who is online before before performing commands :smirk:",
    "Hey kid! This is an invalid player ID",
    "Arghh! An invalid player ID man! :woman_facepalming:",
    "Oh! An invalid player ID hon! :kissing_heart:"
};

new m_[][] = 
{
	"What? did you say it to me? We are not friends anymore don't talk with me!",
	"umm.. :rolling_eyes:.. So you said it, I'm done with you!",
	"who me? No way!! I hate you :angry:"
};

new m__[][] = 
{
	":thinking:",
	"hmm",
	"umm.. :rolling_eyes:",
	"I'll think about it..",
	"Tell me smth about you",
	"I didn't get it",
	"so?",
	"oh! :joy:",
	"really?",
	"He he he :D"
};

new wtfm[][] = 
{
	"Why? What happend! :rolling_eyes:",
	"tbh I don't know what are you talking about! :confused:",
	"hah! Mind your own business! I do what I want to :smirk:"
};

new l1[][] =
{
	"are",
	"r",
	"hv",
	"have",
	"did",
	"is"
};

new l_[][] = 
{
	"tf",
	"what",
	"wt"
};

stock isNumeric(const string[])
{
  new length=strlen(string);
  if (length==0) return false;
  for (new i = 0; i < length; i++)
    {
      if (
            (string[i] > '9' || string[i] < '0' && string[i]!='-' && string[i]!='+') // Not a number,'+' or '-'
             || (string[i]=='-' && i!=0)                                             // A '-' but not at first.
             || (string[i]=='+' && i!=0)                                             // A '+' but not at first.
         ) return false;
    }
  if (length==1 && (string[0]=='-' || string[0]=='+')) return false;
  return true;
}

public DCC_OnMessageCreate(DCC_Message:message)
{
	new DCC_Channel:channel;
	new DCC_User:author;

	DCC_GetMessageChannel(message, channel);
	DCC_GetMessageAuthor(message, author);

	new channel_name[100 + 1];
    if(!DCC_GetChannelName(channel, channel_name)) return 0;

	new user_name[32 + 1];
	if(!DCC_GetUserName(author, user_name)) return 0;

	new bool:bot;
	DCC_IsUserBot(author, bot);

	if(bot) return 0;

	new str_[300]; 
	new cmd[128], id__[256], reason[128];

	new str[350], id[DCC_ID_SIZE];
	DCC_GetUserId(author, id);

	DCC_GetMessageContent(message, str_);
	new iscmd;
	if(str_[0] == '/') iscmd = 1;

	if(iscmd)
	{
		if(str_[1] == ' ')
		{
			format(str, sizeof(str), "<@%s> It looks like you haven't typed it correctly :confused: (``[ USAGE ] /command``)", id);
			return DCC_SendChannelMessage(channel, str);
		}

		if(sscanf(str_, "s[20]S(-1)[256]S(-1)[256]", cmd, id__, reason))
		{
			if(!isequal(cmd, "/cmds", true) && !isequal(cmd, "/kick", true) && !isequal(cmd, "/players", true) && !isequal(cmd, "/teach", true)) format(str, sizeof(str), "<@%s> Sorry honey, I can't perform the command you typed, love you! ummahh! :kissing_heart:", id);
			return DCC_SendChannelMessage(channel, str);
		}
		new id_ = strval(id__);

		if(id_ < 0 && isequal(cmd, "/kick", true))
		{
			format(str, sizeof(str), "<@%s> don't you know that IDs are positive :woman_facepalming:, You gotta goto pre-school!", id);
			return DCC_SendChannelMessage(channel, str);
		}
		if(isequal(cmd, "/cmds", true)) 
		{
			format(str, sizeof(str), "<@%s> Aww! I knew that you will need me sometime :smile:. This is my commands list", id);
			DCC_SendChannelMessage(channel, str);
			DCC_SendChannelMessage(channel, "```/cmds\n/kick\n/players```");
			format(str, sizeof(str), "<@%s> I know what you are thinking, 'lmfao only 3?', yeah only 3.. Tell that GameOvr to add some commands :pensive:", id);
			return DCC_SendChannelMessage(channel, str);
		}
		else if(isequal(cmd, "/kick", true)) 
		{

			if(id_ == -23)
			{
				format(str, sizeof(str), "<@%s> You didn't type it correctly :woman_facepalming: (``[ USAGE ] /kick <id> <reason>``)", id);
				return DCC_SendChannelMessage(channel, str);
			}	
			
			if(!IsPlayerConnected(id_))
			{ 
				new rand = random(sizeof(InvalidIDRandoms));
				format(str, sizeof(str), "<@%s> %s", id, InvalidIDRandoms[rand]);
				return DCC_SendChannelMessage(channel, str);
			}                                                      

			if(isequal(reason, "-1"))
			{
				format(str, sizeof(str), "<@%s> reason! reason!! Type it, You should have a fair reason to kick that innocent :rolling_eyes:(``[ USAGE ] /kick <id> <reason>``)\nI had a crush on him! :kissing_heart:", id);
				return DCC_SendChannelMessage(channel, str);
			}                                                                                               
                                                                                                                    
			if(USERINFO[id][plevel] >= USERINFO[playerid][plevel])
			{
				format(str, sizeof(str), "<@%s> Sorry mister!, player you are going to kick out is at the same level or a higher level than you :rolling_eyes:", id); 
				return DCC_SendChannelMessage(channel, str);
			}  
				
			format(str,sizeof(str), "<@%s>, Kicked that rat bastard as you orderd mister (Name: ``%s[%d]``| Reason: ``%s``)\nBut tbh I had a crush on him :sob:", id, PlayerName(id_), id_, reason);                
		    DCC_SendChannelMessage(channel, str);

			format(str, sizeof(str), "{FF8000}* \"%s[%d]\" kicked from the server by a [DISCORD] Admin (%s)", PlayerName(id_), id_, reason);                               
			SendClientMessageToAll_(-1, str);

			WriteLog(LOG_ADMINACTIONS, "COMMAND: Kick[DISCORD] | Admin: %s | Affected: %s | Reason: %s", user_name, PlayerName(id_), reason);
			return Kick(id_); 
		}
		else if(isequal(cmd, "/players", true))
		{
			new count;
			for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i)) count++;
			if(count == 0)
			{
				format(str, sizeof(str), "<@%s> No one is online at the moment :sob:, I feel sad", id);
				return DCC_SendChannelMessage(channel, str);
			}
			new players[MAX_PLAYER_NAME + 7 * MAX_PLAYERS];
			strcat(players, "```\n");
			strcat(players, "--------------------------------------\n");
			strcat(players, "ID\tName\n");
			new hmm[70];
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					format(hmm, sizeof(hmm), "%d\t%s\n", i, PlayerName(i));
					strcat(players, hmm);
				}
			}
			strcat(players, "--------------------------------------```");
			DCC_SendChannelMessage(channel, players);
			if(count > 1) format(str, sizeof(str), "<@%s>, Woah! %d Players are online :sunglasses:", id, count);
			else format(str, sizeof(str), "<@%s>, Only one player is online :confused:", id);
			return DCC_SendChannelMessage(channel, str);
		}
		else if(isequal(cmd, "/teach", true))
		{
			if(isequal(id__, "-1") || isequal(reason, "-1")) 
			{
				format(str, sizeof(str), "<@%s>, Thank you so much for trying to teach me :kissing_heart:, but your format is wrong (`[ USAGE ] /teach <message> <response>`)", id);
				DCC_SendChannelMessage(channel, str);
				DCC_SendChannelMessage(channel, "Don't forget to use `_` instead of `space`, if you didn't do that I'll get wrong things in my mind! :| ");
				return DCC_SendChannelMessage(channel, "And I beg you! Please.. just don't teach me wrong things! :confused:");
			}
			if(isempty(id__))
			{
				format(str, sizeof(str), "<@%s> What are you going to teach me :pensive:, It's empty!", id);
				return DCC_SendChannelMessage(channel, str);
			}	
			if(isempty(reason))
			{
				format(str, sizeof(str), "<@%s> What are you going to teach me :pensive:, It's empty!", id);
				return DCC_SendChannelMessage(channel, str);
			}

			new idx = DB_RetrieveKey(user_table, "", 0, "Message", id__);
			if(idx != DB_INVALID_KEY)
			{
				format(str, sizeof(str), "<@%s>, Oh someone has tought me the exact same thing before. May be it's you xD, Anyway thank you for trying to teach me :kissing_heart:!!", id);
				return DCC_SendChannelMessage(channel, str);
			}
			
			strreplace(id__, "_", " ");
			DB_CreateRow(scarlett_table, "Message", id__);
			new val = DB_RetrieveKey(scarlett_table, "", 0, "Message", id__);
			strreplace(reason, "_", " ");
			DB_SetStringEntry(scarlett_table, val, "Response", reason);

			if(val == 1) format(str, sizeof(str), "Oh thank you so much <@%s> now I know a response for a message :smile:", id, val);
			else format(str, sizeof(str), "Oh thank you so much <@%s> now I know %d responses for different messages :smile:", id, val);
			return DCC_SendChannelMessage(channel, str);
		}
		else
		{
			format(str, sizeof(str), "<@%s> Sorry honey, I can't perform the command you typed, love you! ummahh! :kissing_heart:", id);
			return DCC_SendChannelMessage(channel, str);
		}
	}

	if((strfind(str_, "bye", true) != -1 || strfind(str_, "gtg", true) != -1 || strfind(str_, "gotta go", true) != -1 || strfind(str_, "cya", true) != -1))
	{
		new rand = random(sizeof(ByeRandoms));
   		format(str, sizeof(str), "<@%s>!, %s", id, ByeRandoms[rand]);
   		return DCC_SendChannelMessage(channel, str);
	}

	new p[50];
	if(strfind(str_, "scar") != -1)
	{
		for(new i = 0; i < sizeof(l_); i++)
		{
			for(new j = 0; j < sizeof(l1); j++)
			{
				format(p, sizeof(p), "%s %s", l_[i], l1[j]);
				if(strfind(str_, p, true) != -1 && j != sizeof(l1) - 1)
				{
					new rand = random(sizeof(wtfm));
					format(str, sizeof(str), "<@%s>, %s", id, wtfm[rand]);
					return DCC_SendChannelMessage(channel, str);
				}
				else if(strfind(str_, p, true) != -1 && j == sizeof(l1) - 1)
				{
					new str_1[256]; 
					new s = strfind(str_, "is");
					strmid(str_1, str, s+2, sizeof(str_) + 1);
					format(str, sizeof(str), "str_1 - %s", str_1);
					DCC_SendChannelMessage(channel, str);
					strreplace(str_1, "scarlettttt", "", true);
					strreplace(str_1, "scarletttt", "", true);
					strreplace(str_1, "scarlettt", "", true);
					strreplace(str_1, "scarlett", "", true);
					strreplace(str_1, "scarlet", "", true);
					strreplace(str_1, "scarle", "", true);
					strreplace(str_1, "scarl", "", true);
					strreplace(str_1, "scar", "", true);
					strreplace(str_1, " ", "+");
					format(str, sizeof(str), "<@%s> mmm... search wiki! I dont have any idea about that :confused:\n https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go&ns0=1", id, str_1);
					return DCC_SendChannelMessage(channel, str);
				}
			}
		}
	}

	if(strfind("hi", str_, true) != -1 || strfind("hello", str_, true) != -1 || strfind("sup", str_, true) != -1|| strfind("hey", str_, true) != -1 || strfind("yo", str_, true) != -1 )
	{
		new rand = random(sizeof(HeyRandoms));
		format(str, sizeof(str), "%s", HeyRandoms[rand]);
	   	return DCC_SendChannelMessage(channel, str);
	}


	new k[8] = {-1, ...};
	if((k[0] = strfind(str_, "gay", true)) != -1 || (k[1] = strfind(str_, "lesbian", true)) != -1 || (k[2] = strfind(str_, "fuck", true)) != -1 || (k[3] = strfind(str_, "bitch", true)) != -1 || (k[4] = strfind(str_, "noob", true)) != -1 || (k[5] = strfind(str_, "nub", true)) != -1 || (k[6] = strfind(str_, "nab", true)) != -1 || (k[7] = strfind(str_, "shit", true)) != -1)
	{
		if(strfind(str_, "scar", true) != -1)
		{
			new rand = random(sizeof(m_));
			format(str, sizeof(str), "<@%s>, %s", id, m_[rand]);
			return DCC_SendChannelMessage(channel, str);
		}
	   	else
	   	{
	   		new r = random(2);
	   		switch(r)
	   		{
	   			case 0:
	   			{
	   				if(k[0] != -1) format(str, sizeof(str), "<@%s>, Yeh! he is gay!", id);
			   		else if(k[1] != -1) format(str, sizeof(str), "<@%s>, Yeh! he is lesbian!", id);
			   		else if(k[2] != -1) format(str, sizeof(str), "<@%s>, Yeh! fuck him!", id);
			   		else if(k[3] != -1) format(str, sizeof(str), "<@%s>, Yeh! he is a bitch!", id);
			   		else if(k[4] != -1 || k[5] != -1 || k[6] != -1) format(str, sizeof(str), "<@%s>, Yeh! he is a nub! (Just like you xD)", id);
			   		else if(k[7] != -1) format(str, sizeof(str), "<@%s>, Yeh! he is a piece of shit", id);
			   		return DCC_SendChannelMessage(channel, str);
	   			}
	   			case 1:
	   			{
	   				if(k[0] != -1) format(str, sizeof(str), "<@%s>, Nope! he is not a gay :smile:", id);
			   		else if(k[1] != -1) format(str, sizeof(str), "<@%s>, Nope are you crazy he is not lesbian :woman_facepalming:", id);
			   		else if(k[2] != -1) format(str, sizeof(str), "<@%s>, he he don't fuck that innocent guy :joy:", id);
			   		else if(k[3] != -1) format(str, sizeof(str), "<@%s>, bitch? he? are you serious? he is a dog xD", id);
			   		else if(k[4] != -1 || k[5] != -1 || k[6] != -1) format(str, sizeof(str), "<@%s>, Nope! He is a pro in my opinion! :sunglasses:", id);
			   		else if(k[7] != -1) format(str, sizeof(str), "<@%s>, Nah! he is not shit! I like him :kissing_heart:", id);
			   		return DCC_SendChannelMessage(channel, str);
	   			}
	   		}
	   	}
	}

	if(strfind(str_, "scar", true) != -1)
	{
		new message_[256];
		for(new i = 0; i < DB_CountRows(scarlett_table); i++)
		{
			DB_GetStringEntry(scarlett_table, i + 1, "Message", message_, sizeof(message_));
			if(strfind(str_, message_, true) != -1)
			{
				DB_GetStringEntry(scarlett_table, i + 1, "Response", message_, sizeof(message_));
				format(str, sizeof(str), "<@%s>, %s", id, message_);
				return DCC_SendChannelMessage(channel, str);
			}
		}

		new rand = random(sizeof(m__));
		return DCC_SendChannelMessage(channel, m__[rand]);
	}
	return 1;
}*/

public OnPlayerLeaveDynamicCP(playerid, STREAMER_TAG_CP checkpointid)  
{
	if(checkpointid == PVEH[1])
	{   
		SetPlayerVirtualWorld(playerid, 0);
		SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), 0);
	}
	return 1;
}

public OnPlayerDamage(&playerid, &Float:amount, &issuerid, &weapon, &bodypart)
{
	if(issuerid != INVALID_PLAYER_ID && playerid != INVALID_PLAYER_ID)
	{
		if(USERINFO[playerid][onduty] == 1 || USERINFO[playerid][jailed] == 1 || USERINFO[issuerid][onduty] == 1) return 0;
	}
	return 1;
}

public OnPlayerDamageDone(playerid, Float:amount, issuerid, weapon, bodypart)
{
	if(issuerid != INVALID_PLAYER_ID && playerid != INVALID_PLAYER_ID)
	{
		if(GetPlayerTeam(playerid) != GetPlayerTeam(issuerid)) 
		{
			PlayerPlaySound(issuerid,17802,0.0,0.0,0.0);
		}
	}
	return 1;
}




public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
	{
		PlayerTextDrawShow(playerid, vehtd_1[playerid]);
		PlayerTextDrawSetString(playerid, vehtd_1[playerid], GetVehicleName(GetPlayerVehicleID(playerid)));
		SetTimerEx("HideVehTD", 5000, false, "i", playerid);
		
		TextDrawHideForPlayer(playerid, takeovertd[0]);
		TextDrawHideForPlayer(playerid, takeovertd[1]);
		TextDrawHideForPlayer(playerid, takeovertd[2]);
		TextDrawHideForPlayer(playerid, takeovertd[3]);
		TextDrawHideForPlayer(playerid, takeovertd[4]);

		PlayerTextDrawHide(playerid, takeovertd_1[playerid][0]);
		PlayerTextDrawHide(playerid, takeovertd_1[playerid][1]);
		PlayerTextDrawHide(playerid, takeovertd_1[playerid][2]);

		HidePlayerProgressBar(playerid, turfbar[playerid][0]);
		HidePlayerProgressBar(playerid, turfbar[playerid][1]);
	}
	else if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
	{
		PlayerTextDrawHide(playerid, vehtd_1[playerid]);
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_FIRE)) // 'lctrl, lmb'
	{
		if(inanim[playerid] == 1)
		{
			inanim[playerid] = 0;
			ClearAnimations(playerid);
		}
	}
	if(PRESSED(KEY_SECONDARY_ATTACK)) // 'enter, F'
	{
		if(inanim[playerid] == 1)
		{
			inanim[playerid] = 0;
			ClearAnimations(playerid);
		}
	}
	else if(PRESSED(KEY_YES)) // 'Y'
	{
		for(new i = 0; i < 6; i++) PlayerTextDrawHide(playerid, statstd_1[playerid][i]);
		TextDrawHideForPlayer(playerid, statstd);
	}
	else if(PRESSED(KEY_CROUCH))
	{
		AutoC[playerid] = 0;
	}
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(GetPlayerWeapon(playerid) == WEAPON_DEAGLE)
	{
		new diff = GetTickCount() - AutoC_tick[playerid];
		AutoC_tick[playerid] = GetTickCount();
		
		if(diff < MIN_LAG_SHOT_DIFF && AutoC[playerid])
		{
			CallLocalFunction("OnPlayerAutoCBug", "i", playerid);
		}

		AutoC[playerid] = 1;
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(vehowned[vehicleid] == 1 && vehowner[vehicleid] != playerid && !ispassenger)
	{
		new str[128];
		format(str, sizeof(str), "~r~This is ~g~%s~r~'s~n~vehicle", PlayerName(vehowner[vehicleid]));
		GameTextForPlayer(playerid, str, 3000, 3);
		PlayerPlaySound(playerid,1190,0.0,0.0,0.0);
		ClearAnimations(playerid);
	}
	else if(lockedv_id[0] == vehicleid || lockedv_id[1] == vehicleid || lockedv_id[2] == vehicleid || lockedv_id[3] == vehicleid || lockedv_id[4] == vehicleid || lockedv_id[5] == vehicleid || lockedv_id[6] == vehicleid)
	{
		GameTextForPlayer(playerid, "~r~You can't enter showroom ~n~vehicles", 3000, 3);
		PlayerPlaySound(playerid,1190,0.0,0.0,0.0);
		ClearAnimations(playerid);
	} 
	return 1;
}

public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z)
{
	new Float:X, Float:	Y, Float:	Z;
	GetVehiclePos(vehicleid, X, Y, Z);
    if(lockedv_id[0] == vehicleid  && (new_x > (X + 0.1) || new_x < (X - 0.1) || new_y > (Y + 0.1) || new_y < (Y - 0.1)))
    {
        SetVehicleToRespawn(vehicleid);
    }
    if(lockedv_id[1] == vehicleid  && (new_x > (X + 0.1) || new_x < (X - 0.1) || new_y > (Y + 0.1) || new_y < (Y - 0.1)))
    {
        SetVehicleToRespawn(vehicleid);
    }
    if(lockedv_id[2] == vehicleid  && (new_x > (X + 0.1) || new_x < (X - 0.1) || new_y > (Y + 0.1) || new_y < (Y - 0.1)))
    {
        SetVehicleToRespawn(vehicleid);
    }
    if(lockedv_id[3] == vehicleid  && (new_x > (X + 0.1) || new_x < (X - 0.1) || new_y > (Y + 0.1) || new_y < (Y - 0.1)))
    {
        SetVehicleToRespawn(vehicleid);
    }
    if(lockedv_id[4] == vehicleid  && (new_x > (X + 0.1) || new_x < (X - 0.1) || new_y > (Y + 0.1) || new_y < (Y - 0.1)))
    {
        SetVehicleToRespawn(vehicleid);
    }
    if(lockedv_id[5] == vehicleid  && (new_x > (X + 0.1) || new_x < (X - 0.1) || new_y > (Y + 0.1) || new_y < (Y - 0.1)))
    {        
    	SetVehicleToRespawn(vehicleid);
    }
    if(lockedv_id[6] == vehicleid  && (new_x > (X + 0.1) || new_x < (X - 0.1) || new_y > (Y + 0.1) || new_y < (Y - 0.1)))
    {
        SetVehicleToRespawn(vehicleid);
    }
    return 1;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags) 
{
	if(!IsPlayerSpawned(playerid) || IsPlayerInClassSelection(playerid) || GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) return 0;
	if(nocmd[playerid] == 1) 
	{
		SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are not allowed to type any command at the moment");
		return 0;
	}
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{ 
	printf("[ COMMAND ] /%s executed by \"%s\"", cmd, PlayerName(playerid));
    WriteLog(LOG_COMMANDS, "Name: %s | Command: %s", PlayerName(playerid), cmd);

    new str[128];
	if(result == -1)
	{ 
		SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
		SendClientMessage(playerid, -1, "{0000FF}[ Use ] {00BFFF}/cmds to see available cmds");
		format(str, sizeof(str), "**`@everyone` %s[%d] typed a non-existing command, maybe this is a cheat command! (``command: /%s``)**", PlayerName(playerid), playerid, cmd);
		DCC_SendChannelMessage(dcc_channel_commands, str);
		return 0; 
	}     

	format(str, sizeof(str), "``%s[%d] executed /%s``", PlayerName(playerid), playerid, cmd);
	DCC_SendChannelMessage(dcc_channel_commands, str);
	return 1; 
} 

public OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA areaid)
{
	new str[128], id;
	for(new i = 0; i < sizeof(ZONEINFO); i++)
	{
		if(areaid == DZONEID[i])
		{
			id = i; 
			break;
		}
	}
	
	if(GetPlayerInterior(playerid) == 0 && IsPlayerSpawned(playerid) && !IsPlayerInClassSelection(playerid) && GetPlayerVirtualWorld(playerid) == 0 && GetPlayerState(playerid) != PLAYER_STATE_WASTED)
	{
		TextDrawShowForPlayer(playerid, zonetd);
		PlayerTextDrawShow(playerid, zonetd_1[playerid][0]);
		PlayerTextDrawShow(playerid, zonetd_1[playerid][1]);
	
		format(str, sizeof(str),"~y~%s", ZONEINFO[id][zname]);
		PlayerTextDrawSetString(playerid, zonetd_1[playerid][0], str);
	
		format(str, sizeof(str),"~w~turf_-_~r~%s", GANGINFO[ZONEINFO[id][zteamid]][gname]);
		PlayerTextDrawSetString(playerid, zonetd_1[playerid][1], str);
	
		SetTimerEx("HideZoneTD", 10000, false, "i", playerid);
	}
	printf("%d- %d", areaid, id);
	return 1;  
}

public OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA areaid)
{
	printf("%d", areaid);
	TextDrawHideForPlayer(playerid, zonetd);

	PlayerTextDrawHide(playerid, zonetd_1[playerid][0]);
	PlayerTextDrawHide(playerid, zonetd_1[playerid][1]);

	TextDrawHideForPlayer(playerid, takeovertd[0]);
	TextDrawHideForPlayer(playerid, takeovertd[1]);
	TextDrawHideForPlayer(playerid, takeovertd[2]);
	TextDrawHideForPlayer(playerid, takeovertd[3]);
	TextDrawHideForPlayer(playerid, takeovertd[4]);

	PlayerTextDrawHide(playerid, takeovertd_1[playerid][0]);
	PlayerTextDrawHide(playerid, takeovertd_1[playerid][1]);
	PlayerTextDrawHide(playerid, takeovertd_1[playerid][2]);

	HidePlayerProgressBar(playerid, turfbar[playerid][0]);
	HidePlayerProgressBar(playerid, turfbar[playerid][1]);
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	for(new i = 0; i < 6; i++)
	{
		if(pickupid == gangpick[i])
		{
			if(picked[playerid] == 0)
			{
				SetPlayerArmour(playerid, 50.0);
				picked[playerid] = 1;
			}
			else return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can pick armour again after your death");
		}
	}

	for(new i = 0; i < 2; i++)
	{
		if(pickupid == hospick[i])
		{
			new str[512];
			strcat(str, "               Welcome to Los Santos              \n");
			strcat(str, "                     Hospital                     \n\n");
			strcat(str, "* Here you can refill your health for $1000\n");
			strcat(str, "* If you want to refill use \"Purchase\"\n");
			strcat(str, "* Use \"Close\" to dismiss\n\n");
			strcat(str, "[ Note ] You can refill your health only one time\n");
			strcat(str, "         for one spawn");
			Dialog_Show(playerid, DIALOG_REFILL_HP, DIALOG_STYLE_MSGBOX, "LGGW - Medical center", str, "Purchase", "Close");
		}
	}
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == vtunetd[1])
	{
		HideTextDraws(playerid);
		switch(vehitem[playerid])
		{
			case 0:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_1] = 0;
				USERINFO[playerid][vcolor_2] = 0;
			}
			case 1:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_1] = 1;
				USERINFO[playerid][vcolor_2] = 1;
			}
			case 2:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_1] = 128;
				USERINFO[playerid][vcolor_2] = 128;
			}
			case 3:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_1] = 135;
				USERINFO[playerid][vcolor_2] = 135;
			}
			case 4:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_1] = 152;
				USERINFO[playerid][vcolor_2] = 152;
			}
			case 5:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_1] = 6;
				USERINFO[playerid][vcolor_2] = 6;
			}
			case 6:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_1] = 252;
				USERINFO[playerid][vcolor_2] = 252;
			}
			case 7:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_1] = 146;
				USERINFO[playerid][vcolor_2] = 146;
			}
			case 8:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_1] = 219;
				USERINFO[playerid][vcolor_2] = 219;
			}
			case 9:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_1] = 0;
			}
			case 10:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_1] = 1;
			}
			case 11:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_1] = 128;
			}
			case 12:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_1] = 135;
			}
			case 13:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_1] = 152;
			}
			case 14:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_1] = 6;
			}
			case 15:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_1] = 252;
			}
			case 16:
			{   
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_1] = 146;
			}
			case 17:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_1] = 219;
			}
			case 18:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_2] = 0;
			}
			case 19:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_2] = 1;
			}
			case 20:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_2] = 128;
			}
			case 21:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_2] = 135;
			}
			case 22:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);              
				USERINFO[playerid][vcolor_2] = 152;
			}
			case 23:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_2] = 6;
			}
			case 24:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_2] = 252;
			}
			case 25:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_2] = 146;
			}
			case 26:
			{
				if(GetPlayerMoney(playerid) < 150) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -150);
				USERINFO[playerid][vcolor_2] = 219;
			}
			case 27:
			{
				if(GetPlayerMoney(playerid) < 750) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -750);
				USERINFO[playerid][vpjob] = 0;
			}
			case 28:
			{
				if(GetPlayerMoney(playerid) < 750) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -750);
				USERINFO[playerid][vpjob] = 1;
			}
			case 29:
			{
				if(GetPlayerMoney(playerid) < 750) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				GivePlayerCash(playerid, -750);
				USERINFO[playerid][vpjob] = 2;
			}
			case 30: USERINFO[playerid][vpjob] = 3;
			case 31: //neon
			{
				if(GetPlayerMoney(playerid) < 3000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				DestroyObject(editvneon[playerid][0]);
				DestroyObject(editvneon[playerid][1]);
				vehneon[GetPlayerVehicleID(playerid)][0] = CreateObject(18651,0,0,0,0,0,0); 
				vehneon[GetPlayerVehicleID(playerid)][1] = CreateObject(18651,0,0,0,0,0,0);
				AttachObjectToVehicle(vehneon[GetPlayerVehicleID(playerid)][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(vehneon[GetPlayerVehicleID(playerid)][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				USERINFO[playerid][vneon_1] = 1;
				GivePlayerCash(playerid, -3000); 
			}
			case 32: //neon
			{
				if(GetPlayerMoney(playerid) < 2000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				DestroyObject(editvneon[playerid][2]);
				vehneon[GetPlayerVehicleID(playerid)][2] = CreateObject(18646,0,0,0,0,0,0); 
				AttachObjectToVehicle(vehneon[GetPlayerVehicleID(playerid)][2], GetPlayerVehicleID(playerid), 0.0, -0.35, 0.90, 0.0, 0.0, 0.0);
				USERINFO[playerid][vneon_2] = 1;
				GivePlayerCash(playerid, -2000);
			}
			case 33: // remove neon
			{
				if(USERINFO[playerid][vneon_1] == 1)
				{
					DestroyObject(vehneon[GetPlayerVehicleID(playerid)][0]);
					DestroyObject(vehneon[GetPlayerVehicleID(playerid)][1]);
				}
				if(USERINFO[playerid][vneon_2] == 1) DestroyObject(vehneon[GetPlayerVehicleID(playerid)][2]); 
				USERINFO[playerid][vneon_1] = 0;
				USERINFO[playerid][vneon_2] = 0;
			}
			case 34: 
			{
				if(GetPlayerMoney(playerid) < 1000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				USERINFO[playerid][vhydra] = 1;
				GivePlayerCash(playerid, -1000);
			}
			case 35: USERINFO[playerid][vhydra] = 0;
			case 36:
			{
				if(GetPlayerMoney(playerid) < 200) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				USERINFO[playerid][vnitro] = 1008;
				GivePlayerCash(playerid, -200);
			}
			case 37:
			{
				if(GetPlayerMoney(playerid) < 500) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				USERINFO[playerid][vnitro] = 1009;
				GivePlayerCash(playerid, -500);
			}
			case 38: 
			{
				if(GetPlayerMoney(playerid) < 1000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				USERINFO[playerid][vnitro] = 1010;
				GivePlayerCash(playerid, -1000);
			}
			case 39:USERINFO[playerid][vnitro] = -1;
			case 40: 
			{
				if(GetPlayerMoney(playerid) < 350) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				USERINFO[playerid][vwheel] = 1073;
				GivePlayerCash(playerid, -350);
			}
			case 41:
			{
				if(GetPlayerMoney(playerid) < 350) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				USERINFO[playerid][vwheel] = 1074;
				GivePlayerCash(playerid, -350);
			}
			case 42:
			{
				if(GetPlayerMoney(playerid) < 350) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				USERINFO[playerid][vwheel] = 1075;
				GivePlayerCash(playerid, -350);
			}
			case 43:
			{
				if(GetPlayerMoney(playerid) < 350) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				USERINFO[playerid][vwheel] = 1076;
				GivePlayerCash(playerid, -350);
			}
			case 44:
			{
				if(GetPlayerMoney(playerid) < 350) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				USERINFO[playerid][vwheel] = 1077;
				GivePlayerCash(playerid, -350);
			}
			case 45:
			{
				if(GetPlayerMoney(playerid) < 350) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				USERINFO[playerid][vwheel] = 1078;
				GivePlayerCash(playerid, -350);
			}
			case 46:
			{   
				if(GetPlayerMoney(playerid) < 350) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				USERINFO[playerid][vwheel] = 1079;
				GivePlayerCash(playerid, -350);
			}
			case 47:
			{
				if(GetPlayerMoney(playerid) < 350) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				USERINFO[playerid][vwheel] = 1083;
				GivePlayerCash(playerid, -350);
			}
			case 48:
			{
				if(GetPlayerMoney(playerid) < 350) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				USERINFO[playerid][vwheel] = 1085;
				GivePlayerCash(playerid, -350);
			}
		}
		vehitem[playerid] = -1;
	}
	return 1;
}

public OnPlayerText(playerid, text[])
{	
	if(USERINFO[playerid][muted] == 1)
	{
		new str[128];
		format(str, sizeof(str), "{e60000}[ Error ] {FF6347}You can't talk while you are muted (Remaining time: %d seconds)", USERINFO[playerid][mutetime]);
		if(justconnected[playerid] == 0) SendClientMessage(playerid, -1, str);
	} 
	else
	{
		new str[256];
		format(str, sizeof(str), "{%06x}%s{E7E6A9} [%d]: {FFFFFF}%s", GetPlayerColor(playerid) >>> 8, PlayerName(playerid), playerid, text);
		if(USERINFO[playerid][VIP] == 1) format(str, sizeof(str), "{%06x}%s{E7E6A9} [%d]: {CC9999}%s", GetPlayerColor(playerid) >>> 8, PlayerName(playerid), playerid, text);
		WriteLog(LOG_CHAT, "%s[%d]: %s", PlayerName(playerid), playerid, text);
		if(stringContainsIP(text))
		{
			USERINFO[playerid][muted] = 1;
			USERINFO[playerid][mutetime] = TIME_FOR_ADVERTISE_MUTE * 60;
			format(str, sizeof(str), "{FF8000}* \"%s[%d]\" has been muted by the server for %d minutes (Advertising)", PlayerName(playerid), playerid, TIME_FOR_ADVERTISE_MUTE);
			WriteLog(LOG_CHAT, "[ \"%s[%d]\" muted by the server for advertising \"%s\" ]", PlayerName(playerid), playerid, text);
			return SendClientMessageToAll_(-1, str);
		}
		foreach(new i : Player)
		{
			if(justconnected[i] == 0)
			{
				SendClientMessage(i, -1, str);
			}
		}
		if(justconnected[playerid] == 0) SetPlayerChatBubble(playerid, text, 0xB8860BAA, 20, 7000);
		if(isequal(lastmsg[playerid], text)) 
		{
			spamcount[playerid]++;
			if(spamcount[playerid] == MIN_SPAM_COUNT)
			{
				USERINFO[playerid][muted] = 1;
				USERINFO[playerid][mutetime] = TIME_FOR_SPAM_MUTE * 60;
				format(str, sizeof(str), "{FF8000}* \"%s[%d]\" has been muted by the server for %d minutes (Spam)", PlayerName(playerid), playerid, TIME_FOR_SPAM_MUTE);
				SendClientMessageToAll_(-1, str);
				WriteLog(LOG_CHAT, "[ \"%s[%d]\" muted by the server for spamming \"%s\" ]", PlayerName(playerid), playerid, text);
			}
		}
		else spamcount[playerid] = 1;

		new h, m, s;
	    new y, mn, d;
	    getdate(y, mn, d);
	    gettime(h, m, s);
	    format(str, sizeof(str), "``[ %d:%d:%d | %d:%d:%d ] %s[%d]: %s``", y, mn, d, h, m, s, PlayerName(playerid), playerid, text);
		DCC_SendChannelMessage(dcc_channel_chat, str);

		format(lastmsg[playerid], 256, "%s", text);
	}
	return 0;
}

public OnPlayerPosChange(playerid, Float:newx, Float:newy, Float:newz, Float:oldx, Float:oldy, Float:oldz)
{
	USERINFO[playerid][moving] = 1;
	SetTimerEx("ImNotMoving", 3000, false, "i", playerid);
	return 1;
}
											
public OnPlayerHeadshot(playerid, issuerid, weaponid)
{
	if(inminigame[playerid] == 0)
	{ 
		USERINFO[issuerid][hshots] ++; 
		GameTextForPlayer(issuerid, "~r~Boom! ~g~Head shot", 3000, 5);
	}
	return 1;
}

public ImNotMoving(playerid)
{
	USERINFO[playerid][moving] = 0;
	return 1;
}

public Delay_Kick(id)
{
	Kick(id);
	SendRconCommand("reloadbans");
	return 1;
}

public HideZoneTD(playerid)
{
	TextDrawHideForPlayer(playerid, zonetd);
	PlayerTextDrawHide(playerid, zonetd_1[playerid][0]);
	PlayerTextDrawHide(playerid, zonetd_1[playerid][1]);
	return 1;
}

public ExpireGangRequest(playerid)
{
	grequested[playerid] = 0;
	grequestedid[playerid] = -1;
	return 1;
}

public HideVehTD(playerid)
{
	PlayerTextDrawHide(playerid, vehtd_1[playerid]);
	return 1;
}

public UncuffForLMS()
{
	foreach( new i : Player)
	{
		if(inlms[i] == 1)
		{
			SetPlayerSpecialAction(i, SPECIAL_ACTION_NONE);
			GameTextForPlayer(i, "~r~Fight!~n~~y~Good Luck", 5000, 5);
		}
	}
	return 1;
}

public LMSStartedJustNow()
{
	new count;
	foreach( new i : Player)
	{
		if(inlms[i] == 1)
		{
			count++;
		}
	}
	if(count == 0) lmsjustnow = 0;
	return 1;
}

public DuelDeadLine(id, playerid)
{
	duelinvited[id] = 0;
	duelinviter[playerid] = 0;
	new str[128];
	format(str, sizeof(str), "{004000}[ Duel ] {00FF00}Your duel request for %s has been expired", PlayerName(id));
	SendClientMessage(playerid, -1, str);
	format(str, sizeof(str), "{004000}[ Duel ] {00FF00}Duel request by %s has been expired ", PlayerName(playerid));
	SendClientMessage(id, -1, str);
	return 1;
}

public KillMe(playerid)
{
	SetPlayerHealth(playerid, 0.0);
	return 1;
}
public StartLastManStanding()
{
	new count;
	foreach( new i : Player)
	{
		if(inlms[i] == 1)
		{
			count++;
		}
	}
	if(count < MIN_PLAYERS_TO_START_LMS)
	{
		foreach( new i : Player)
		{
			inlms[i] = 0;
		}

		lmsstarted = 0;
		lmsjustnow = 0;
		SendClientMessageToAll_(-1, "{800080}[ LMS ] {8000FF}Last Man Standing cancelled... (Not enough players)");
	}
	else    
	{
		lmsjustnow = 1;
		TextDrawSetString(LGGW[1], "~p~Last Man Standing ~g~started ~w~just now");
		SendClientMessageToAll_(-1, "{800080}[ LMS ] {8000FF}Last Man Standing started just now");
		new Rand = random(sizeof(LMSWeapons));
		foreach( new i : Player)
		{
			if(inlms[i] == 1)
			{
				USERINFO[i][lmsplayed] ++;
				inminigame[i] = 1;
				lmskills[i] = 0;
				GetPlayerDetails(i);
				foreach(new k : Player)
				{
					SetPlayerMarkerForPlayer(k, i, 0x99339900);
				}
				GivePlayerWeapon(i, LMSWeapons[Rand][0], 2000);
				GivePlayerWeapon(i, LMSWeapons[Rand][1], 2000);
				SetPlayerSpecialAction(i, SPECIAL_ACTION_CUFFED);
				SetPlayerTeam(i, NO_TEAM);
				SetPlayerVirtualWorld(i, 100);
				SetPlayerHealth(i, 100);
				SetPlayerArmour(i, 0);
				switch(lmsplace)
				{
					case 1: 
					{                                   
						new rand = random(sizeof(LMS1Randoms));
						SetPlayerPos(i, LMS1Randoms[rand][0], LMS1Randoms[rand][1], LMS1Randoms[rand][2]);
						SetPlayerFacingAngle(i, LMS1Randoms[rand][3]);
						SetPlayerInterior(i, 15);
					}           
					case 2:
					{
						new rand = random(sizeof(LMS2Randoms));
						SetPlayerPos(i, LMS2Randoms[rand][0], LMS2Randoms[rand][1], LMS2Randoms[rand][2]);
						SetPlayerFacingAngle(i, LMS2Randoms[rand][3]);
						SetPlayerInterior(i, 10);
					}
					case 3:
					{
						new rand = random(sizeof(LMS3Randoms));
						SetPlayerPos(i, LMS3Randoms[rand][0], LMS3Randoms[rand][1], LMS3Randoms[rand][2]);
						SetPlayerFacingAngle(i, LMS3Randoms[rand][3]);
						SetPlayerInterior(i, 0);
					}
					case 4:
					{
						new rand = random(sizeof(LMS4Randoms));
						SetPlayerPos(i, LMS4Randoms[rand][0], LMS4Randoms[rand][1], LMS4Randoms[rand][2]);
						SetPlayerFacingAngle(i, LMS4Randoms[rand][3]);
						SetPlayerInterior(i, 0);
					}
				}
			}
		}
		SetTimer("UncuffForLMS", 20000, false);
		SetTimer("LMSStartedJustNow", TIME_FOR_LMS_COOLDOWN * 60 * 1000, false);
	}  
	return 1;
}

public TurfMoney()
{
	new str[128];   
	foreach(new j : Player)
	{
		if(IsPlayerSpawned(j) && !IsPlayerInClassSelection(j))
		{
			format(str, sizeof(str), "You have recieved ~y~$%d ~w~by your ~p~gang ~r~\"%s\" ~w~for controlling ~y~%d ~p~turfs ~w~over ~g~Los_Santos", MONEY_PER_TURF * GANGINFO[USERINFO[j][gid]][gturfs], GANGINFO[USERINFO[j][gid]][gname], GANGINFO[USERINFO[j][gid]][gturfs]);
			PlayerTextDrawShow(j, turfcashtd[j]);
			PlayerTextDrawSetString(j, turfcashtd[j], str);
			GivePlayerCash(j, MONEY_PER_TURF * GANGINFO[USERINFO[j][gid]][gturfs]);
		}
	}
	SetTimer("HideCashTD", 10000, false);
	return 1;
}

public NeonTimer()
{
	foreach(new i : Player)
	{
		if(USERINFO[i][vowned] == 1 && USERINFO[i][vneon_1] == 1 && IsPlayerInAnyVehicle(i) && vehowner[GetPlayerVehicleID(i)] == i && remneons[i] == 0)
		{
			new Rand = random(sizeof(NeonRandoms));
			DestroyObject(vehneon[GetPlayerVehicleID(i)][0]); 
			DestroyObject(vehneon[GetPlayerVehicleID(i)][1]);  
			vehneon[GetPlayerVehicleID(i)][0] = CreateObject(NeonRandoms[Rand],0,0,0,0,0,0);
			vehneon[GetPlayerVehicleID(i)][1] = CreateObject(NeonRandoms[Rand],0,0,0,0,0,0);
			AttachObjectToVehicle(vehneon[GetPlayerVehicleID(i)][0], GetPlayerVehicleID(i), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			AttachObjectToVehicle(vehneon[GetPlayerVehicleID(i)][1], GetPlayerVehicleID(i), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		}
	}
	return 1;
}

public HideCashTD()
{
	foreach(new i : Player)
	{
		PlayerTextDrawHide(i, turfcashtd[i]);
	}
	return 1;
}

public UnjailandUnmuteTimer()
{
	new str[128];
	foreach(new j : Player)
	{
		if(USERINFO[j][jailed] == 1 && !IsPlayerInClassSelection(j) && IsPlayerSpawned(j))
		{
			USERINFO[j][jailtime] --;
			format(str, sizeof(str), "~g~Remaining Time: ~w~%d", USERINFO[j][jailtime]);
			GameTextForPlayer(j, str, 1000, 5);
			ResetPlayerWeapons(j);
			if(USERINFO[j][jailtime] == 0)
			{
				GameTextForPlayer(j, "~g~UNJAILED!", 5000, 5);
				SetSpawnInfo(j, GetPlayerTeam(j), GetPlayerSkin(j), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
				SpawnPlayer(j);
				USERINFO[j][jailed] = 0;
				USERINFO[j][jailtime] = 0;
			}
		}
		if(USERINFO[j][muted] == 1)
		{
			USERINFO[j][mutetime] --;
			if(USERINFO[j][mutetime] == 0)
			{
				USERINFO[j][muted] = 0;
				SendClientMessage(j, -1, "{006400}[ Info ] {00FF00}You have been unmuted");
			}
		}
	}
	return 1;
}

public TurfTimer()
{
	new tstr[128];
	for(new i = 0; i < sizeof(ZONEINFO); i++) // loop all zones
	{
		if(ZONEINFO[i][ZoneAttacker] != -1) // zone is being attacked
		{
			if(GetPlayersInZone(i, ZONEINFO[i][ZoneAttacker]) >= MIN_PLAYERS_TO_START_TURF) // team has enough members in the zone
			{
				ZONEINFO[i][ZoneAttackTime] ++;
				
				foreach(new j : Player)
				{
					if(GetPlayerTeam(j) == ZONEINFO[i][ZoneAttacker] && IsPlayerInZone(j, i))
					{
						SetPlayerProgressBarValue(j, turfbar[j][0], ZONEINFO[i][ZoneAttackTime]);
						SetPlayerProgressBarValue(j, turfbar[j][1], ZONEINFO[i][ZoneAttackTime]);      
					}
				}

				if(ZONEINFO[i][ZoneAttackTime] == TIME_FOR_TURF) // zone has been under attack for enough time and attackers take over the zone
				{
					foreach(new j : Player)
					{
						if(GetPlayerTeam(j) == ZONEINFO[i][ZoneAttacker] && IsPlayerInZone(j, i))
						{
							HidePlayerProgressBar(j, turfbar[j][0]);
							HidePlayerProgressBar(j, turfbar[j][1]);

							PlayerTextDrawHide(j, takeovertd_1[j][0]);
							PlayerTextDrawHide(j, takeovertd_1[j][1]);
							PlayerTextDrawHide(j, takeovertd_1[j][2]);
							
							TextDrawHideForPlayer(j, takeovertd[0]);
							TextDrawHideForPlayer(j, takeovertd[1]);
							TextDrawHideForPlayer(j, takeovertd[2]);
							TextDrawHideForPlayer(j, takeovertd[3]);
							TextDrawHideForPlayer(j, takeovertd[4]);
						}
					}

					GangZoneStopFlashForAll(ZONEID[i]);
					GangZoneShowForAll(ZONEID[i], Zone_ColorAlpha(GANGINFO[ZONEINFO[i][ZoneAttacker]][gcolor])); // update the zone color for new team

					format(tstr, sizeof(tstr), "~p~Gang_~r~\"%s\"_~g~won_~w~the_~p~turf_war_~w~against_~b~\"%s\"_~w~at_~y~%s", GANGINFO[ZONEINFO[i][ZoneAttacker]][gname], GANGINFO[ZONEINFO[i][zteamid]][gname], ZONEINFO[i][zname]);
					TextDrawSetString(LGGW[1], tstr);

					new st[150];
					format(st, sizeof(st), "{FF80FF}\"%s\" won the turf war against \"%s\" in \"%s\"", ReplaceUwithS(GANGINFO[ZONEINFO[i][ZoneAttacker]][gname]), ReplaceUwithS(GANGINFO[ZONEINFO[i][zteamid]][gname]), ReplaceUwithS(ZONEINFO[i][zname]));
					SendClientMessageToAll_(-1, st);

					GANGINFO[ZONEINFO[i][ZoneAttacker]][gscore] += GANG_SCORE_PER_TURF;
					GANGINFO[ZONEINFO[i][ZoneAttacker]][gturfs] ++;
					GANGINFO[ZONEINFO[i][zteamid]][gturfs] --;
					if(GANGINFO[ZONEINFO[i][zteamid]][gscore] > 20 ) GANGINFO[ZONEINFO[i][zteamid]][gscore] -= (GANG_SCORE_PER_TURF - 10);

					ZONEINFO[i][zteamid] = ZONEINFO[i][ZoneAttacker];

					ZONEINFO[i][ZoneAttacker] = -1;

					SaveServerData();
				} 
			}
			else // attackers failed to take over the zone
			{
				GangZoneStopFlashForAll(ZONEID[i]);
				foreach(new j : Player)
				{
					if(GetPlayerTeam(j) == ZONEINFO[i][ZoneAttacker] && IsPlayerInZone(j, i))
					{
						HidePlayerProgressBar(j, turfbar[j][0]);
						HidePlayerProgressBar(j, turfbar[j][1]);

						PlayerTextDrawHide(j, takeovertd_1[j][0]);
						PlayerTextDrawHide(j, takeovertd_1[j][1]);
						PlayerTextDrawHide(j, takeovertd_1[j][2]);
						
						TextDrawHideForPlayer(j, takeovertd[0]);
						TextDrawHideForPlayer(j, takeovertd[1]);
						TextDrawHideForPlayer(j, takeovertd[2]);
						TextDrawHideForPlayer(j, takeovertd[3]);
						TextDrawHideForPlayer(j, takeovertd[4]);
					}
				}
				ZONEINFO[i][ZoneAttacker] = -1;
			}
		}
		else // check if somebody is attacking
		{
			for(new t = 0; t < MAX_GANGS; t++) // loop all teams
			{
				if(t != ZONEINFO[i][zteamid] && GetPlayersInZone(i, t) >= MIN_PLAYERS_TO_START_TURF) // if there are enough enemies in the zone
				{
					ZONEINFO[i][ZoneAttacker] = t;
					ZONEINFO[i][ZoneAttackTime] = 0;
					GangZoneFlashForAll(ZONEID[i], Zone_ColorAlpha(GANGINFO[ZONEINFO[i][ZoneAttacker]][gcolor]));
					foreach(new k : Player)
					{
						if(GetPlayerTeam(k) == t && IsPlayerInZone(k, i)) 
						{
							SetPlayerProgressBarValue(k, turfbar[k][0], 0);
							SetPlayerProgressBarValue(k, turfbar[k][1], 0);
							SetPlayerProgressBarColour(k, turfbar[k][0], GANGINFO[ZONEINFO[i][ZoneAttacker]][gcolor]);
							SetPlayerProgressBarColour(k, turfbar[k][1], GANGINFO[ZONEINFO[i][ZoneAttacker]][gcolor]);
			
							format(tstr, sizeof(tstr), "~r~%s", GANGINFO[ZONEINFO[i][ZoneAttacker]][gname]);
							PlayerTextDrawSetString(k, takeovertd_1[k][1], tstr);
	
							format(tstr, sizeof(tstr), "~b~%s", GANGINFO[ZONEINFO[i][zteamid]][gname]);
							PlayerTextDrawSetString(k, takeovertd_1[k][2], tstr);

							format(tstr, sizeof(tstr), "~y~%s", ZONEINFO[i][zname]);
							PlayerTextDrawSetString(k, takeovertd_1[k][0], tstr);

							ShowPlayerProgressBar(k, turfbar[k][0]);
							ShowPlayerProgressBar(k, turfbar[k][1]);

							PlayerTextDrawShow(k, takeovertd_1[k][0]);
							PlayerTextDrawShow(k, takeovertd_1[k][1]);
							PlayerTextDrawShow(k, takeovertd_1[k][2]);
	
							TextDrawShowForPlayer(k, takeovertd[0]);
							TextDrawShowForPlayer(k, takeovertd[1]);
							TextDrawShowForPlayer(k, takeovertd[2]);
							TextDrawShowForPlayer(k, takeovertd[3]);
							TextDrawShowForPlayer(k, takeovertd[4]);
						}
					}
				}
			}
		}
	}
	return 1;
}

public RobTimer()
{
	for(new i = 2; i < MAX_ACTORS; i++)
	{
		if(IsValidActor(i)) 
		{ 
			if(JustRobbed[i] == 0)
			{
				if(robber[i] != -1) // shop is under rob
				{
					if(GetPlayerTargetActor(robber[i]) == i && GetPlayerWeapon(robber[i]) != 0) 
					{
						robtime[i] += 0.5;
						SetPlayerProgressBarValue(robber[i], rbar[robber[i]], robtime[i]);
						if(robgtv[robber[i]] == 0) GameTextForPlayer(robber[i], "~r~Robbing", 1000, 1);
						else if(robgtv[robber[i]] == 1) GameTextForPlayer(robber[i], "~r~Robbing.", 1000, 1);
						else if(robgtv[robber[i]] == 2) GameTextForPlayer(robber[i], "~r~Robbing..", 1000, 1);
						else if(robgtv[robber[i]] == 3) GameTextForPlayer(robber[i], "~r~Robbing...", 1000, 1);
						else if(robgtv[robber[i]] == 4)
						{
							robgtv[robber[i]] = 0;
							GameTextForPlayer(robber[i], "~r~Robbing", 1000, 1);
						}

						robgtv[robber[i]] += 0.5;

						if(robtime[i] == TIME_FOR_ROB_END) // successfully robbed
						{
							new str[128];
							GameTextForPlayer(robber[i], " ", 100, 1);
							ClearActorAnimations(i); 
							HidePlayerProgressBar(robber[i], rbar[robber[i]]);
							USERINFO[robber[i]][robbs] ++;
							new Rand = random(sizeof(RobRandoms));
							GivePlayerCash(robber[i], RobRandoms[Rand]);
							format(str, sizeof(str), "* {FF8000}%s[%d] has robbed a %s shop in %s and got $%d", PlayerName(robber[i]), robber[i], SHOPINFO[i][label], GetPlayerZone(robber[i]), RobRandoms[Rand]);
							SendClientMessageToAll_(-1, str);
							robber[i] = -1;
							JustRobbed[i] = 1;
							SetTimerEx("EndJustRobbed", TIME_FOR_ROB_REST * 60 * 1000, false, "i", i);
						}
					}
					else //failed to rob
					{
						GameTextForPlayer(robber[i], " ", 100, 1);
						ClearActorAnimations(i);
						HidePlayerProgressBar(robber[i], rbar[robber[i]]);
						robber[i] = -1;
					}
				}
				else // checking if somebody is robbing
				{
					foreach(new j : Player)
					{
						if(GetPlayerTargetActor(j) == i && GetPlayerWeapon(j) != 0)
						{
							robber[i] = j;
							robtime[i] = 0;
							robgtv[j] = 0;
							SetPlayerProgressBarValue(j, rbar[j], 0);
							ShowPlayerProgressBar(j, rbar[j]);
							ApplyActorAnimation(i, "ped","handsup",4.1,0,1,1,1,0);
							GameTextForPlayer(robber[i], " ", 100, 1);
						}
					}
				}
			}
			else
			{
				foreach(new j : Player)
				{
					if(GetPlayerTargetActor(j) == i) return SendClientMessage(j, -1, "{e60000}[ Error ] {FF6347}The shop has been robbed before few minutes, No cash left with the cashier!");
				}
			}
		}
	}
	return 1;
}

public EndJustRobbed(i)
{
	JustRobbed[i] = 0;
	return 1;
}

public TDUpdate()
{
	foreach(new k : Player)
	{
		if(logged[k] == 1)
		{
			USERINFO[k][ptime]++;
		}
	}
	switch(tdlvl)
	{
		case 0:
		{
			TextDrawSetString(LGGW[5], "~w~]_~y~www.lg-gw.ga~w~_]");  
			tdlvl ++;
		}
		case 1:
		{
			TextDrawSetString(LGGW[5], "~w~]_~r~w~y~ww.lg-gw.ga~w~_]");  
			tdlvl ++;
		}
		case 2:
		{
			TextDrawSetString(LGGW[5], "~w~]_~y~w~r~w~y~w.lg-gw.ga~w~_]");
			tdlvl ++;
		}
		case 3:
		{
			TextDrawSetString(LGGW[5], "~w~]_~y~ww~r~w~y~.lg-gw.ga~w~_]");
			tdlvl ++;
		}
		case 4:
		{
			TextDrawSetString(LGGW[5], "~w~]_~y~www~r~.~y~lg-gw.ga~w~_]");
			tdlvl ++;
		}
		case 5:
		{
			TextDrawSetString(LGGW[5], "~w~]_~y~www.~r~l~y~g-gw.ga~w~_]");
			tdlvl ++;
		}
		case 6:
		{
			TextDrawSetString(LGGW[5], "~w~]_~y~www.l~r~g~y~-gw.ga~w~_]");
			tdlvl ++;
		}
		case 7:
		{
			TextDrawSetString(LGGW[5], "~w~]_~y~www.lg~r~-~y~gw.ga~w~_]");
			tdlvl ++;
		}
		case 8:
		{
			TextDrawSetString(LGGW[5], "~w~]_~y~www.lg-~r~g~y~w.ga~w~_]");
			tdlvl ++;
		}
		case 9:
		{
			TextDrawSetString(LGGW[5], "~w~]_~y~www.lg-g~r~w~y~.ga~w~_]");
			tdlvl ++;
		}
		case 10:
		{
			TextDrawSetString(LGGW[5], "~w~]_~y~www.lg-gw~r~.~y~ga~w~_]");
			tdlvl ++;
		}   
		case 11:
		{
			TextDrawSetString(LGGW[5], "~w~]_~y~www.lg-gw.~r~g~y~a~w~_]");
			tdlvl ++;
		}
		case 12:
		{
			TextDrawSetString(LGGW[5], "~w~]_~y~www.lg-gw.g~r~a~w~_]");
			tdlvl = 0;
		}
	}
	return 1;
}

public RandomConnectTD()
{
	TextDrawDestroy(connecttd[2]);
	
	new tds_[40];
	new t = random(14);
	format(tds_, sizeof(tds_), "loadsc%d:loadsc%d", t + 1, t + 1);

	connecttd[2] = TextDrawCreate(0.000000, 0.000000, tds_);
	TextDrawFont(connecttd[2], 4);
	TextDrawLetterSize(connecttd[2], 0.600000, 2.000000);
	TextDrawTextSize(connecttd[2], 640.500000, 447.000000);
	TextDrawSetOutline(connecttd[2], 1);
	TextDrawSetShadow(connecttd[2], 0);
	TextDrawAlignment(connecttd[2], 1);
	TextDrawColor(connecttd[2], -1);
	TextDrawBackgroundColor(connecttd[2], 255);
	TextDrawBoxColor(connecttd[2], 50);
	TextDrawUseBox(connecttd[2], 1);
	TextDrawSetProportional(connecttd[2], 1);
	TextDrawSetSelectable(connecttd[2], 0);
	return 1;
}

public RandomWeather()
{
	if(last_weather == 18)
	{
		last_weather = 6;
		SetWorldTime(6);
	}
	else if(last_weather == 6)
	{
		last_weather = 12;
		SetWorldTime(12);
	}
	else if(last_weather == 12)
	{
		last_weather = 20;
		SetWorldTime(20);
	}
	else if(last_weather == 20)
	{
		last_weather = 22;
		SetWorldTime(22);
	}
	else if(last_weather == 22)
	{
		last_weather = 0;
		SetWorldTime(0);
	}
	else if(last_weather == 0)
	{
		last_weather = 6;
		SetWorldTime(6);
	}
	return 1;
}

public RandomServerMessage()
{
	new rand = random(sizeof(ServerMessages));
	TextDrawSetString(LGGW[2], ServerMessages[rand]);
	SendClientMessageToAll_(-1, "{8000FF}========================================================");
	SendClientMessageToAll_(-1, "       {FF69B4}Join our forums at >>> {FFFFFF}https://lg-gw.ga  ");
	SendClientMessageToAll_(-1, "{8000FF}========================================================");
	return 1;
}

public ServerSaveTimer()
{
	SaveServerData();
	return 1;
}

public CloseMoneyTD(playerid)
{
	PlayerTextDrawHide(playerid, moneytd_1[playerid]);
	return 1;
}

public GunGameEndTime()
{
	new hl = -1, hid = -1;
	foreach(new i : Player)
	{
		if(inminigame[i] == 1 && ingg[i] == 1)
		{
			if(gg_lvl[i] > hl)
			{
				hid = i;
				hl = gg_lvl[i];
			}
		}
	}

	if(hid == -1)
	{
		return SendClientMessageToAll_(-1, "Gun Game has ended without a winner!");
	}

	foreach(new i : Player)
	{
		if(ingg[i] == 1 && hl == gg_lvl[i] && hid != i)
		{
			return egg_timer = SetTimer("ExtraGunGameTime", 1000, true);
		}
	}

	new str[128];
	if(hl <= 20) format(str, sizeof(str), "%s won the GunGame with the level %d (Reward: $%d)", PlayerName(hid), hl, MONEY_PER_GUNGAME_LEVEL * hl);
	else format(str, sizeof(str), "%s won the GunGame with the level 20(maximum level) (Reward: $%d)", PlayerName(hid), hl, MONEY_PER_GUNGAME_LEVEL * 20);
	SendClientMessageToAll_(-1, str);
	if(hl <= 20) GivePlayerCash(hid, MONEY_PER_GUNGAME_LEVEL * hl);
	else GivePlayerCash(hid, MONEY_PER_GUNGAME_LEVEL * 20);
	USERINFO[hid][ggw] ++;

	foreach(new i : Player)
	{
		if(ingg[i] == 1 && inminigame[i])
		{
			ResetPlayerWeapons(i);
			SetPlayerDetails(i);
			ingg[i] = 0;
			inminigame[i] = 0;
			gg_started = 0;
			USERINFO[i][ggp]++;
		}
	}
	return 1;
}

public ExtraGunGameTime()
{
	new still_there, hl, hid;
	foreach(new i : Player)
	{
		if(ingg[i])
		{
			if(gg_lvl[i] > hl)
			{
				hid = i;
				hl = gg_lvl[i];
			}
		}
	}

	foreach(new i : Player)
	{
		if(ingg[i] == 1 && hl == gg_lvl[i] && hid != i)
		{
			still_there = 1;
		}
	}

	if(still_there == 0)
	{
		new str[128];
		if(hl <= 20) format(str, sizeof(str), "%s won the GunGame with the level %d (Reward: $%d)", PlayerName(hid), hl, MONEY_PER_GUNGAME_LEVEL * hl);
		else format(str, sizeof(str), "%s won the GunGame with the level 20(maximum level) (Reward: $%d)", PlayerName(hid), hl, MONEY_PER_GUNGAME_LEVEL * 20);
		SendClientMessageToAll_(-1, str);
		if(hl <= 20) GivePlayerCash(hid, MONEY_PER_GUNGAME_LEVEL * hl);
		else GivePlayerCash(hid, MONEY_PER_GUNGAME_LEVEL * 20);
		USERINFO[hid][ggw] ++;
		KillTimer(egg_timer);
		foreach(new i : Player)
		{
			if(ingg[i] == 1 && inminigame[i])
			{
				ResetPlayerWeapons(i);
				SetPlayerDetails(i);
				ingg[i] = 0;
				gg_started = 0;
				USERINFO[i][ggp]++;
			}
		}
	}
	return 1;
}

forward OnPlayerAutoCBug(playerid);
public OnPlayerAutoCBug(playerid)
{
	new str[128];
	format(str, sizeof(str), "{FF8000}* %s[%d] has been kicked by the system (Auto C-Bug)", PlayerName(playerid), playerid);
	SendClientMessageToAll_(-1, str);
	Kick(playerid);
	return 1;
}

public OnPlayerAirbreak(playerid) 
{
    new str[128];
    format(str, sizeof(str), "{FF8000}* %s[%d] has been kicked from the server by the system (Air break)", PlayerName(playerid), playerid);
    SendClientMessageToAll_(-1, str);
    Kick(playerid);
    return 1;
}

//Dialogs
Dialog:DIALOG_HELP(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new k = strval(inputtext);
		if(k != 1 && k != 2 && k != 3 && k != 4 && k != 5) 
		{	
			SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid input ID");
			return PC_EmulateCommand(playerid, "/help");
		}
		new str[2048];
		ShowPlayerDialog(playerid, 455, DIALOG_STYLE_INPUT,"COL_WHITE""Login","COL_WHITE""Type your password below to login.","Login","Quit");
		switch(k)
		{
			case 1:
			{
				strcat(str, "* The way of getting score is killing players (score <=> kills).\n", sizeof(str)); 
				strcat(str, "  You can do it in normal world as well as in Death Match.\n\n", sizeof(str)); 
				strcat(str, "* If you are more into increasing score than money we recommend playing more\n" , sizeof(str));
				strcat(str, "  in Death Matches and killing the opponets as much as possible.\n\n", sizeof(str));
				strcat(str, "* Also you can duel with opponents to increase your score along with money.\n\n", sizeof(str));
				strcat(str, "Now lets's see how to join Death Match or start Duels and get some easy kills\n", sizeof(str));
				strcat(str, "-----------------------------------------------------------------------------\n\n", sizeof(str));
				strcat(str, "- Death Matches\n", sizeof(str)); 
				strcat(str, "* To join Death Matches you can simple smash the command /dm and choose a Death Match arena\n", sizeof(str)); 
				strcat(str, "  along with weapons or you can directly use /dm<id>.\n", sizeof(str)); 
				strcat(str, "* As an example if you want to join deagle shotgun DM simply type /dm1 command and hit Enter.\n\n", sizeof(str));
				strcat(str, "- Duels\n", sizeof(str)); 
				strcat(str, "* Starting a duel is quite simple. If you are gonna duel for the first time use /duelsettings\n", sizeof(str)); 
				strcat(str, "  and set the weapons and arena as you wish.\n\n", sizeof(str)); 
				strcat(str, "* Then simply hit /duel <id> to start a duel against your opponent.\n\n", sizeof(str)); 
				strcat(str, "* The next time you want to duel simply hit /duel <id> you have nothing to mussup with\n", sizeof(str)); 
				strcat(str, "  weapons or arenas since its automatically saved.\n\n", sizeof(str)); 
				strcat(str, "* In case you want to change the the weapons or arenas you can use /duelsettings again.", sizeof(str));
				Dialog_Show(playerid, DIALOG_HELP_2, DIALOG_STYLE_MSGBOX, "LGGW - Help - How to be the top killer?", str, "Back", "Close");
			}
			case 2:
			{
				strcat(str, "* Earning money while you play in the server is another important thing you should.\n", sizeof(str)); 
				strcat(str, "  First we'll see what we can do with moey so it make the reading more worth.\n\n", sizeof(str));
				strcat(str, "* Let me list out some of the things you can do with the earned money.\n\n", sizeof(str));
				strcat(str, "        - You can buy much more powerful weapons and armour from the Ammu Nation.\n\n", sizeof(str));
				strcat(str, "        - You can create your own gang with the money collected along with\n", sizeof(str)); 
				strcat(str, "          a stunning Head Qauters and rule Los Santos.\n\n", sizeof(str));
				strcat(str, "        - You can refill your health from medical centers and also using /medkitn\n", sizeof(str)); 
				strcat(str, "          command with your money.\n\n", sizeof(str));
				strcat(str, "        - And bored driving the cars stopped at corners of the street? Oh come on you can\n", sizeof(str)); 
				strcat(str, "          drive your own vehicle like a king.\n\n", sizeof(str));
				strcat(str, "        - You can upgrade your vehicles, character and stuf and do many awesome things!\n\n", sizeof(str));
				strcat(str, "* Okay all cool but if you have zero budget how can you do all these?\n", sizeof(str)); 
				strcat(str, "  So let's look at how can you be one of the richest.\n\n", sizeof(str));
				strcat(str, "       1.Turfs are the best way to earn in LG | GW. Staying on foot in a turf with 3 team mates\n", sizeof(str)); 
				strcat(str, "         provokes a turf war. Then you should stay on it for 30 seconds to get the turf in the\n", sizeof(str)); 
				strcat(str, "         account of your gang.\n\n", sizeof(str)); 
				strcat(str, "       2.Robbing stores is another way of earning easy cash. Go to the nearest store aim at the\n", sizeof(str)); 
				strcat(str, "         clerk you the robbery will start. And then wait until the progress bar filles.\n", sizeof(str)); 
				strcat(str, "         COOL! Now you know how to Rob!\n\n", sizeof(str));
				strcat(str, "       3.Killing players is another way of earning money. There is a bonus with this step because\n", sizeof(str));
				strcat(str, "         you can earn money along with increasing your score.\n\n", sizeof(str));
				strcat(str, "       4.Winning events is another cool way to earn money. More you win more you get.\n\n", sizeof(str));
				strcat(str, "       5.Ruining rampages is ugly way you can earn money. Though it't ugly to be honest I love it.\n", sizeof(str)); 
				strcat(str, "         Hope you will too :D\n\n", sizeof(str));
				strcat(str, "* SECRET TIP : Let me share a secret with you how I earn ugly money :). While you duel you can set the\n", sizeof(str)); 
				strcat(str, "               bet to a higher value if you are sure the opponent isn't skilled enough when compared\n", sizeof(str)); 
				strcat(str, "               to you. Heh don't tell anyone elase about this though.", sizeof(str));
				Dialog_Show(playerid, DIALOG_HELP_2, DIALOG_STYLE_MSGBOX, "LGGW - Help - How to be the richest?", str, "Back", "Close");
			}
			case 3:
			{
				strcat(str, "* We think we have the most advanced gang and gang wars sytem so let's look at it.\n\n", sizeof(str));
				strcat(str, "* There are 6 main gangs but the coolest part is the custom gang system.\n\n", sizeof(str));
				strcat(str, "* You can create your own gang with /gang create or use /gang join <gang id> to join an existing gang.\n", sizeof(str)); 
				strcat(str, "  NOTE:You need 500 score to make your own gang.\n\n", sizeof(str));
				strcat(str, "Let me list down some useful gang commands and tips\n", sizeof(str));
				strcat(str, "---------------------------------------------------\n\n", sizeof(str));
				strcat(str, "* You can change your skin if you are in a custom gang using /gang skin <skin id>\n\n", sizeof(str));
				strcat(str, "* You can buy a new gang HQ for your gang by going to a checkpoint of a unowned gang.\n\n", sizeof(str));
				strcat(str, "* To change the gang color use /gang color command.\n\n", sizeof(str));
				strcat(str, "* You can browse through all the available gang commands using /gang", sizeof(str));
				Dialog_Show(playerid, DIALOG_HELP_2, DIALOG_STYLE_MSGBOX, "LGGW - Help - How can your gang rule Los Santos?", str, "Back", "Close");
			}
			case 4:
			{
				strcat(str, "* Coming into the events LMS and GunGame are the main events. Let's Look at both of them seperately.\n\n", sizeof(str));
				strcat(str, "- LMS\n", sizeof(str));
				strcat(str, "* LMS Stands for Last Man Standing.\n\n", sizeof(str));
				strcat(str, "* The aim is to survive among the others.\n\n", sizeof(str));
				strcat(str, "* We have given the previlage for everyone to start LMS. Just hit the /lms command.\n", sizeof(str));
				strcat(str, "  Atleast 3 players should sign up for LMS to start the event successfully.\n\n", sizeof(str));
				strcat(str, "- GunGame\n", sizeof(str));
				strcat(str, "* In gun game you have to quickly upgrade your wepons by killing people.\n\n", sizeof(str));
				strcat(str, "* You first person kills a player from the last weapon level wins the event.\n\n", sizeof(str));
				strcat(str, "* Only admins can start the gun game while you can join it by using /gungame command.\n\n", sizeof(str));
				Dialog_Show(playerid, DIALOG_HELP_2, DIALOG_STYLE_MSGBOX, "LGGW - Help - How to deal with Minigames?", str, "Back", "Close");
			}
			case 5:
			{
				strcat(str, "* Personal vehicle is another cool system we have gathered to our server.\n\n", sizeof(str));
				strcat(str, "* The vehicle shop in Commerce(which is denoted by car sign on the map) provides you\n", sizeof(str)); 
				strcat(str, "  a variety of cars and bikes.\n\n", sizeof(str));
				strcat(str, "* What you have to do is buy the car or bike you want.\n\n", sizeof(str));
				strcat(str, "* Then use /v to spawn it\n", sizeof(str));
				strcat(str, "  The tune shop is next to the vehicle shop so you can modify(tune)\n", sizeof(str)); 
				strcat(str, "  your vehicle as you wish and be the knight rider of Los Santos ;).\n\n", sizeof(str)); 
				strcat(str, "* Nitrous will make you faster while wheels will increase your grip and controls.\n", sizeof(str)); 
				strcat(str, "  Neons and paints will make your vehicle cooler and cooler and Hydraulics is also there.", sizeof(str));
				Dialog_Show(playerid, DIALOG_HELP_2, DIALOG_STYLE_MSGBOX, "LGGW - Help - How to be the knightrider of Los Santos?", str, "Back", "Close");
			}
		}
	}
	else return Dialog_Close(playerid);
	return 1;
}

Dialog:DIALOG_HELP_2(playerid, response, listitem, inputtext[])
{
	if(response) 
		return PC_EmulateCommand(playerid, "/help");
	else Dialog_Close(playerid);	
	return 1;
}

Dialog:DIALOG_REFILL_HP(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(hospicked[playerid] == 1) {
			SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can refill health again after your death");
			return PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
		}
		if(GetPlayerMoney(playerid) < MIN_CASH_TO_USE_HOSPITAL) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
		new str[128];
		format(str, sizeof(str), "* %s refilled his health at LGGW medical center", PlayerName(playerid));
		GivePlayerCash(playerid, -MIN_CASH_TO_USE_HOSPITAL);
		PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0);
		hospicked[playerid] = 1;
	}
	else Dialog_Close(playerid);
	return 1;
}
Dialog:DIALOG_DM(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
			case 0: return PC_EmulateCommand(playerid, "/dm1");
			case 1: return PC_EmulateCommand(playerid, "/dm2");
			case 2: return PC_EmulateCommand(playerid, "/dm3");
			case 3: return PC_EmulateCommand(playerid, "/dm4");
			case 4: return PC_EmulateCommand(playerid, "/dm5");
			case 5: return PC_EmulateCommand(playerid, "/dm6");
		}
	}
	else Dialog_Close(playerid);
	return 1;
}

Dialog:DIALOG_AMMU(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new str[1024];
		strcat(str, "ID\tWeapon       \tPrice\n\n");
		strcat(str, "1 \tArmour       \t$2000\n");
		strcat(str, "2 \t9mm          \t$100\n");
		strcat(str, "3 \tSilenced 9mm \t$120\n");
		strcat(str, "4 \tDesert Eagle \t$300\n");
		strcat(str, "5 \tShotgun      \t$450\n");
		strcat(str, "6 \tSawn-Off     \t$750\n");
		strcat(str, "7 \tSpass12      \t$800\n");
		strcat(str, "8 \tUzi          \t$150\n");
		strcat(str, "9 \tAK47         \t$250\n");
		strcat(str, "10\tM4           \t$200\n");
		strcat(str, "11\tTec-9        \t$150\n");
		strcat(str, "12\tSniper Rifle \t$1200\n");
		strcat(str, "13\tCountry Rifle\t$1300\n\n");
		strcat(str, "[ Note ] You cannot buy Sawn-Off and Armour\n");
		strcat(str, "         at one time");
		Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "LGGW - Ammu Nation", str, "Purchase", "Close");
		if(isequal(inputtext, "1"))
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "LGGW - Ammu Nation", str, "Purchase", "Close");
			if(SAWNBOUGHT[playerid] == 0)
			{
				if(GetPlayerMoney(playerid) >= 2000) //armour
				{
					PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
					SetPlayerArmour(playerid, 100.0);
					GivePlayerCash(playerid, -2000);
					ARMOURBOUGHT[playerid] = 1;
				}
				else
				{
					PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
					SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to buy an armour ");
				}
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You cannot buy an armour while you have a Sawn-Off");
			}
		}
		else if(isequal(inputtext, "2"))//9mm
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "LGGW - Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerMoney(playerid) >= 100)
			{
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 22, 100);
				GivePlayerCash(playerid, -100);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to buy a 9mm ");
			}
		}
		else if(isequal(inputtext, "3"))//silenced 9mm
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "LGGW - Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerMoney(playerid) >= 120)
			{
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 23, 100);
				GivePlayerCash(playerid, -120);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to buy a Silenced 9mm ");
			}
		}
		else if(isequal(inputtext, "4"))//deagle
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "LGGW - Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerMoney(playerid) >= 300)
			{
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 24, 80);
				GivePlayerCash(playerid, -300);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to buy a Desert Eagle ");
			}
		}
		else if(isequal(inputtext, "5"))//shotgun
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "LGGW - Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerMoney(playerid) >= 450)
			{
				
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 25, 70);
				GivePlayerCash(playerid, -400);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to buy a Shotgun ");
			}
		}
		else if(isequal(inputtext, "6"))//sawn
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "LGGW - Ammu Nation", str, "Purchase", "Close");
			if(ARMOURBOUGHT[playerid] == 0)
			{
				if(GetPlayerMoney(playerid) >= 750)
				{
					PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
					GivePlayerWeapon(playerid, 26, 60);
					GivePlayerCash(playerid, -750);
					SAWNBOUGHT[playerid] = 1;
				}
				else
				{
					PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
					SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to buy a Sawn-Off ");
				}
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You cannot buy a Sawn-Off while you have an Armour");
			}
		}
		else if(isequal(inputtext, "7"))//spass
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "LGGW - Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerMoney(playerid) >= 800)
			{
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 27, 60);
				GivePlayerCash(playerid, -800);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to buy a Spass12 ");
			}
		}
		else if(isequal(inputtext, "8"))//uzi 150 28
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "LGGW - Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerMoney(playerid) >= 150)
			{
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 28, 120);
				GivePlayerCash(playerid, -150);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to buy an Uzi/Micro SMG ");
			}
		}
		else if(isequal(inputtext, "9"))//ak47 250 30
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "LGGW - Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerMoney(playerid) >= 250)
			{
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 30, 150);
				GivePlayerCash(playerid, -250);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to buy an AK47 ");
			}
		}
		else if(isequal(inputtext, "10"))//m4 200 31
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "LGGW - Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerMoney(playerid) >= 200)
			{
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 31, 150);
				GivePlayerCash(playerid, -200);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to buy a M4");
			}
		}
		else if(isequal(inputtext, "11"))//tec9 150 32
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "LGGW - Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerMoney(playerid) >= 150)
			{
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 32, 120);
				GivePlayerCash(playerid, -150);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to buy a Tec-9");
			}
		}
		else if(isequal(inputtext, "12"))//sr 1200 34
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "LGGW - Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerMoney(playerid) >= 1200)
			{
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 34, 20);
				GivePlayerCash(playerid, -1200);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to buy a Sniper Rifle ");
			}
		}
		else if(isequal(inputtext, "13"))//cr 1300 33
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "LGGW - Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerMoney(playerid) >= 1300)
			{
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 33, 30);
				GivePlayerCash(playerid, -1300);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to buy a Country Rifle ");
			}
		}
		else
		{
			PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "LGGW - Ammu Nation", str, "Purchase", "Close");
			SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid selection");
		}
	}
	else Dialog_Close(playerid);
	return 1;
}

Dialog:DIALOG_DUEL_PREVIEW(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
			case 0: Dialog_Show(playerid, DIALOG_DUEL_PLACE, DIALOG_STYLE_LIST, "LGGW - Duel Settings - Duel place", "LV Stadium\nWarehouse\nRC Battlefield\nBloodbowl", "Select", "");
			case 1: Dialog_Show(playerid, DIALOG_DUEL_WEAPONS_1, DIALOG_STYLE_LIST, "LGGW - Duel Settings - Weapon 1", "Brass Knuckles\nKnife\nBaseball Bat\nChain Saw\nPurple Dildo\nGrenade\n9mm\nSilenced 9mm\nDesert Eagle\nShotgun\nSawn-Off Shotgun\nCombat Shotgun\nUzi\nAk-47\nSniper Rifle\nMinigun", "Select", "");
			case 2: Dialog_Show(playerid, DIALOG_DUEL_WEAPONS_2, DIALOG_STYLE_LIST, "LGGW - Duel Settings - Weapon 2", "None\nBrass Knuckles\nKnife\nBaseball Bat\nChain Saw\nPurple Dildo\nGrenade\n9mm\nSilenced 9mm\nDesert Eagle\nShotgun\nSawn-Off Shotgun\nCombat Shotgun\nUzi\nAk-47\nSniper Rifle\nMinigun", "Select", "");
			case 3: Dialog_Show(playerid, DIALOG_DUEL_WEAPONS_3, DIALOG_STYLE_LIST, "LGGW - Duel Settings - Weapon 3", "None\nBrass Knuckles\nKnife\nBaseball Bat\nChain Saw\nPurple Dildo\nGrenade\n9mm\nSilenced 9mm\nDesert Eagle\nShotgun\nSawn-Off Shotgun\nCombat Shotgun\nUzi\nAk-47\nSniper Rifle\nMinigun", "Select", "");
			case 4: Dialog_Show(playerid, DIALOG_DUEL_BET, DIALOG_STYLE_INPUT, "LGGW - Duel Settings - Duel bet", "Insert a value to bet with the player\nwho you are dueling\n\nInsert a value between $5 - $5000", "Enter", "");
		}
	}
	else Dialog_Close(playerid);
	return 1;
}

Dialog:DIALOG_DUEL_PLACE(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new str[128];
		Dialog_Show(playerid, DIALOG_DUEL_PREVIEW, DIALOG_STYLE_LIST, "LGGW - Duel Settings", "Place\nWeapon - 1\nWeapon - 2\nWeapon - 3\nBet", "Select", "Close");
		switch(listitem)
		{
			case 0: USERINFO[playerid][dplace] = 0;
			case 1: USERINFO[playerid][dplace] = 1;
			case 2: USERINFO[playerid][dplace] = 2;
			case 3: USERINFO[playerid][dplace] = 3;
		}
		format(str, sizeof(str), "{004000}[ Duel ] {00FF00}Duel settings updated! (Place: %s)", GetDuelPlaceName(USERINFO[playerid][dplace]));
		SendClientMessage(playerid, -1, str);
	}
}

Dialog:DIALOG_DUEL_WEAPONS_1(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new str[128];
		Dialog_Show(playerid, DIALOG_DUEL_PREVIEW, DIALOG_STYLE_LIST, "LGGW - Duel Settings", "Place\nWeapon - 1\nWeapon - 2\nWeapon - 3\nBet", "Select", "Close");
		switch(listitem)
		{
			case 0: USERINFO[playerid][dwep1] = 1;
			case 1: USERINFO[playerid][dwep1] = 4;
			case 2: USERINFO[playerid][dwep1] = 5;
			case 3: USERINFO[playerid][dwep1] = 9;
			case 4: USERINFO[playerid][dwep1] = 10;
			case 5: USERINFO[playerid][dwep1] = 16;
			case 6: USERINFO[playerid][dwep1] = 22;
			case 7: USERINFO[playerid][dwep1] = 23;
			case 8: USERINFO[playerid][dwep1] = 24;
			case 9: USERINFO[playerid][dwep1] = 25;
			case 10: USERINFO[playerid][dwep1] = 26;
			case 11: USERINFO[playerid][dwep1] = 27;
			case 12: USERINFO[playerid][dwep1] = 28;
			case 13: USERINFO[playerid][dwep1] = 30;
			case 14: USERINFO[playerid][dwep1] = 34;
			case 15: USERINFO[playerid][dwep1] = 38;
		}
		format(str, sizeof(str), "{004000}[ Duel ] {00FF00}Duel settings updated! (Weapon 1: %s)", GunName(USERINFO[playerid][dwep1]));
		SendClientMessage(playerid, -1, str);
	}
}

Dialog:DIALOG_DUEL_WEAPONS_2(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new str[128];
		Dialog_Show(playerid, DIALOG_DUEL_PREVIEW, DIALOG_STYLE_LIST, "LGGW - Duel Settings", "Place\nWeapon - 1\nWeapon - 2\nWeapon - 3\nBet", "Select", "Close");
		switch(listitem)
		{
			case 0: USERINFO[playerid][dwep2] = 0;
			case 1: USERINFO[playerid][dwep2] = 1;
			case 2: USERINFO[playerid][dwep2] = 4;
			case 3: USERINFO[playerid][dwep2] = 5;
			case 4: USERINFO[playerid][dwep2] = 9;
			case 5: USERINFO[playerid][dwep2] = 10;
			case 6: USERINFO[playerid][dwep2] = 16;
			case 7: USERINFO[playerid][dwep2] = 22;
			case 8: USERINFO[playerid][dwep2] = 23;
			case 9: USERINFO[playerid][dwep2] = 24;
			case 10: USERINFO[playerid][dwep2] = 25;
			case 11: USERINFO[playerid][dwep2] = 26;
			case 12: USERINFO[playerid][dwep2] = 27;
			case 13: USERINFO[playerid][dwep2] = 28;
			case 14: USERINFO[playerid][dwep2] = 30;
			case 15: USERINFO[playerid][dwep2] = 34;
			case 16: USERINFO[playerid][dwep2] = 38;
		}
		format(str, sizeof(str), "{004000}[ Duel ] {00FF00}Duel settings updated! (Weapon 2: %s)", GunName(USERINFO[playerid][dwep2]));
		SendClientMessage(playerid, -1, str);
	}
}

Dialog:DIALOG_DUEL_WEAPONS_3(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new str[128];
		Dialog_Show(playerid, DIALOG_DUEL_PREVIEW, DIALOG_STYLE_LIST, "LGGW - Duel Settings", "Place\nWeapon - 1\nWeapon - 2\nWeapon - 3\nBet", "Select", "Close");
		switch(listitem)
		{
			case 0: USERINFO[playerid][dwep3] = 0;
			case 1: USERINFO[playerid][dwep3] = 1;
			case 2: USERINFO[playerid][dwep3] = 4;
			case 3: USERINFO[playerid][dwep3] = 5;
			case 4: USERINFO[playerid][dwep3] = 9;
			case 5: USERINFO[playerid][dwep3] = 10;
			case 6: USERINFO[playerid][dwep3] = 16;
			case 7: USERINFO[playerid][dwep3] = 22;
			case 8: USERINFO[playerid][dwep3] = 23;
			case 9: USERINFO[playerid][dwep3] = 24;
			case 10: USERINFO[playerid][dwep3] = 25;
			case 11: USERINFO[playerid][dwep3] = 26;
			case 12: USERINFO[playerid][dwep3] = 27;
			case 13: USERINFO[playerid][dwep3] = 28;
			case 14: USERINFO[playerid][dwep3] = 30;
			case 15: USERINFO[playerid][dwep3] = 34;
			case 16: USERINFO[playerid][dwep3] = 38;
		}
		format(str, sizeof(str), "{004000}[ Duel ] {00FF00}Duel settings updated! (Weapon 3: %s)", GunName(USERINFO[playerid][dwep3]));
		SendClientMessage(playerid, -1, str);
	}
}

Dialog:DIALOG_DUEL_BET(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new str[128];
		if(strval(inputtext) > 5000 || strval(inputtext) < 5)
		{
			SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Your bet value must be in between $5 - $5000");
			Dialog_Show(playerid, DIALOG_DUEL_BET, DIALOG_STYLE_INPUT, "LGGW - Duel Settings", "Duel Bet\n\n Insert a value to bet with the player\nwho you are dueling\n\nInsert a value between $5 - $5000", "Enter", "");
		}
		else
		{
			USERINFO[playerid][dbet] = strval(inputtext);
			Dialog_Show(playerid, DIALOG_DUEL_PREVIEW, DIALOG_STYLE_LIST, "LGGW - Duel Settings", "Place\nWeapon - 1\nWeapon - 2\nWeapon - 3\nBet", "Select", "Close");
			format(str, sizeof(str), "{004000}[ Duel ] {00FF00}Duel settings updated! (Duel bet: $%d)", USERINFO[playerid][dbet]);
			SendClientMessage(playerid, -1, str);
		}
	}
}

Dialog:DIALOG_VEH_PREVIEW(playerid, response, listitem, inputtext[])
{
	if(!response) Dialog_Close(playerid);
	if(response)
	{
		new str[1024];
		if(isempty(inputtext))
		{
			strcat(str, "ID\tType\n\n");
			strcat(str, "1 \tCars\n");
			strcat(str, "2 \tMotor bikes\n");
			strcat(str, "3 \tSell vehicle");
			SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid selection");
			Dialog_Show(playerid, DIALOG_VEH_PREVIEW, DIALOG_STYLE_INPUT, "LGGW - Vehicle Shop", str, "Enter", "Close");
		}
		else if(isequal("1", inputtext))
		{
			strcat(str, "ID\tCar      \tPrice\n\n");
			strcat(str, "1 \tSabre    \t$100000\n");
			strcat(str, "2 \tSavanna  \t$120000\n");
			strcat(str, "3 \tRemington\t$150000\n");
			strcat(str, "4 \tBuffalo  \t$170000\n");
			strcat(str, "5 \tUranus   \t$180000\n");
			strcat(str, "6 \tElegy    \t$210000\n");
			strcat(str, "7 \tSultan   \t$240000\n");
			strcat(str, "8 \tSuper GT \t$270000\n");
			strcat(str, "9 \tCheetah  \t$290000\n");
			strcat(str, "10\tBullet   \t$310000");
			Dialog_Show(playerid, DIALOG_VEH_CAR, DIALOG_STYLE_INPUT, "LGGW - Vehicle Shop", str, "Purchase", "Close");
		}
		else if(isequal("2", inputtext))
		{
			strcat(str, "ID\tBike   \tPrice\n\n");
			strcat(str, "1 \tQuad   \t$30000\n");
			strcat(str, "2 \tFaggio \t$40000\n");
			strcat(str, "3 \tFreeway\t$60000\n");
			strcat(str, "4 \tSanchez\t$70000\n");
			strcat(str, "5 \tPCJ-600\t$90000\n");
			strcat(str, "6 \tBF-400 \t$90000\n");
			strcat(str, "7 \tFCR-900\t$100000");
			Dialog_Show(playerid, DIALOG_VEH_BIKE, DIALOG_STYLE_INPUT, "LGGW - Vehicle Shop ", str, "Purchase", "Close");
		}
		else if(isequal("3", inputtext))
		{
			Dialog_Show(playerid, DIALOG_VEH_SELL, DIALOG_STYLE_MSGBOX, "LGGW - Vehicle Shop ", "Are you sure that you want\nto sell your vehicle\n\n[ Important ]This action is irreversable\n\n[ Note ]You will recieve only half\nof the price of your\nvehicle", "Sell", "Close");
		}
		else
		{
			SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid selection");
			Dialog_Show(playerid, DIALOG_VEH_PREVIEW, DIALOG_STYLE_INPUT, "LGGW - Vehicle Shop", "ID\tType\n\n1\tCars\n2\tMotor bikes\n3\tSell vehicle", "Enter", "Close");
		}
	}
	return 1;
}

Dialog:DIALOG_VEH_CAR(playerid, response, listitem, inputtext[])
{
	if(!response) Dialog_Close(playerid);
	if(response)
	{
		new str[700];
		strcat(str, "ID\tCar      \tPrice\n\n");
		strcat(str, "1 \tSabre    \t$100000\n");
		strcat(str, "2 \tSavanna  \t$120000\n");
		strcat(str, "3 \tRemington\t$150000\n");
		strcat(str, "4 \tBuffalo  \t$170000\n");
		strcat(str, "5 \tUranus   \t$180000\n");
		strcat(str, "6 \tElegy    \t$210000\n");
		strcat(str, "7 \tSultan   \t$240000\n");
		strcat(str, "8 \tSuper GT \t$270000\n");
		strcat(str, "9 \tCheetah  \t$290000\n");
		strcat(str, "10\tBullet   \t$310000");
		if(isempty(inputtext))
		{
			SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid selection");
			Dialog_Show(playerid, DIALOG_VEH_CAR, DIALOG_STYLE_INPUT, "LGGW - Vehicle Shop", str, "Purchase", "Close");
		}
		else if(isequal("1", inputtext))
		{
			if(USERINFO[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have a vehicle");
			if(GetPlayerMoney(playerid) < 100000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to purchase this vehicle");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You have bought \"Sabre\", Use /v to spawn it");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You can upgrade your vehicle by Tune shop");
			GivePlayerCash(playerid, -100000);
			USERINFO[playerid][vowned] = 1;
			USERINFO[playerid][vmodel] = 475;
			USERINFO[playerid][vcolor_1] = 51;
			USERINFO[playerid][vcolor_2] = 51;
			USERINFO[playerid][vnitro] = -1;
			USERINFO[playerid][vneon_1] = 0;
			USERINFO[playerid][vneon_2] = 0;
			USERINFO[playerid][vpjob] = 3;
			USERINFO[playerid][vwheel] = 1077;
			USERINFO[playerid][vhydra] = 0;
		}
		else if(isequal("2", inputtext))
		{
			if(USERINFO[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have a vehicle");
			if(GetPlayerMoney(playerid) < 120000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to purchase this vehicle");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You have bought \"Savana\", Use /v to spawn it");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You can upgrade your vehicle by Tune shop");
			GivePlayerCash(playerid, -120000);
			USERINFO[playerid][vowned] = 1;
			USERINFO[playerid][vmodel] = 567;
			USERINFO[playerid][vcolor_1] = 51;
			USERINFO[playerid][vcolor_2] = 51;
			USERINFO[playerid][vnitro] = -1;
			USERINFO[playerid][vneon_1] = 0;
			USERINFO[playerid][vneon_2] = 0;
			USERINFO[playerid][vpjob] = 3;
			USERINFO[playerid][vwheel] = 1077;
			USERINFO[playerid][vhydra] = 0;
		}
		else if(isequal("3", inputtext))
		{
			if(USERINFO[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have a vehicle");
			if(GetPlayerMoney(playerid) < 150000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to purchase this vehicle");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You have bought \"Remington\", Use /v to spawn it");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You can upgrade your vehicle by Tune shop");
			GivePlayerCash(playerid, -150000);
			USERINFO[playerid][vowned] = 1;
			USERINFO[playerid][vmodel] = 534;
			USERINFO[playerid][vcolor_1] = 51;
			USERINFO[playerid][vcolor_2] = 51;
			USERINFO[playerid][vnitro] = -1;
			USERINFO[playerid][vneon_1] = 0;
			USERINFO[playerid][vneon_2] = 0;
			USERINFO[playerid][vpjob] = 3;
			USERINFO[playerid][vwheel] = 1077;
			USERINFO[playerid][vhydra] = 0;
		}
		else if(isequal("4", inputtext))
		{
			if(USERINFO[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have a vehicle");
			if(GetPlayerMoney(playerid) < 170000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to purchase this vehicle");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You have bought \"Buffalo\", Use /v to spawn it");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You can upgrade your vehicle by Tune shop");
			GivePlayerCash(playerid, -170000);
			USERINFO[playerid][vowned] = 1;
			USERINFO[playerid][vmodel] = 402;
			USERINFO[playerid][vcolor_1] = 51;
			USERINFO[playerid][vcolor_2] = 51;
			USERINFO[playerid][vnitro] = -1;
			USERINFO[playerid][vneon_1] = 0;
			USERINFO[playerid][vneon_2] = 0;
			USERINFO[playerid][vpjob] = 3;
			USERINFO[playerid][vwheel] = 1077;
			USERINFO[playerid][vhydra] = 0;
		}
		else if(isequal("5", inputtext))
		{
			if(USERINFO[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have a vehicle");
			if(GetPlayerMoney(playerid) < 180000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to purchase this vehicle");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You have bought \"Uranus\", Use /v to spawn it");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You can upgrade your vehicle by Tune shop");
			GivePlayerCash(playerid, -180000);
			USERINFO[playerid][vowned] = 1;
			USERINFO[playerid][vmodel] = 558;
			USERINFO[playerid][vcolor_1] = 51;
			USERINFO[playerid][vcolor_2] = 51;
			USERINFO[playerid][vnitro] = -1;
			USERINFO[playerid][vneon_1] = 0;
			USERINFO[playerid][vneon_2] = 0;
			USERINFO[playerid][vpjob] = 3;
			USERINFO[playerid][vwheel] = 1077;
			USERINFO[playerid][vhydra] = 0;
		}
		else if(isequal("6", inputtext))
		{
			if(USERINFO[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have a vehicle");
			if(GetPlayerMoney(playerid) < 210000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to purchase this vehicle");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You have bought \"Elegy\", Use /v to spawn it");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You can upgrade your vehicle by Tune shop");
			GivePlayerCash(playerid, -210000);
			USERINFO[playerid][vowned] = 1;
			USERINFO[playerid][vmodel] = 562;
			USERINFO[playerid][vcolor_1] = 51;
			USERINFO[playerid][vcolor_2] = 51;
			USERINFO[playerid][vnitro] = -1;
			USERINFO[playerid][vneon_1] = 0;
			USERINFO[playerid][vneon_2] = 0;
			USERINFO[playerid][vpjob] = 3;
			USERINFO[playerid][vwheel] = 1077;
			USERINFO[playerid][vhydra] = 0;
		}
		else if(isequal("7", inputtext))
		{
			if(USERINFO[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have a vehicle");
			if(GetPlayerMoney(playerid) < 240000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to purchase this vehicle");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You have bought \"Sultan\", Use /v to spawn it");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You can upgrade your vehicle by Tune shop");
			GivePlayerCash(playerid, -240000);
			USERINFO[playerid][vowned] = 1;
			USERINFO[playerid][vmodel] = 560;
			USERINFO[playerid][vcolor_1] = 51;
			USERINFO[playerid][vcolor_2] = 51;
			USERINFO[playerid][vnitro] = -1;
			USERINFO[playerid][vneon_1] = 0;
			USERINFO[playerid][vneon_2] = 0;
			USERINFO[playerid][vpjob] = 3;
			USERINFO[playerid][vwheel] = 1077;
			USERINFO[playerid][vhydra] = 0;
		}
		else if(isequal("8", inputtext))
		{
			if(USERINFO[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have a vehicle");
			if(GetPlayerMoney(playerid) < 270000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to purchase this vehicle");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You have bought \"Super GT\", Use /v to spawn it");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You can upgrade your vehicle by Tune shop");
			GivePlayerCash(playerid, -270000);
			USERINFO[playerid][vowned] = 1;
			USERINFO[playerid][vmodel] = 506;
			USERINFO[playerid][vcolor_1] = 51;
			USERINFO[playerid][vcolor_2] = 51;
			USERINFO[playerid][vnitro] = -1;
			USERINFO[playerid][vneon_1] = 0;
			USERINFO[playerid][vneon_2] = 0;
			USERINFO[playerid][vpjob] = 3;
			USERINFO[playerid][vwheel] = 1077;
			USERINFO[playerid][vhydra] = 0;
		}
		else if(isequal("9", inputtext))
		{
			if(USERINFO[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have a vehicle");
			if(GetPlayerMoney(playerid) < 290000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to purchase this vehicle");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You have bought \"Cheetah\", Use /v to spawn it");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You can upgrade your vehicle by Tune shop");
			GivePlayerCash(playerid, -290000);
			USERINFO[playerid][vowned] = 1;
			USERINFO[playerid][vmodel] = 415;
			USERINFO[playerid][vcolor_1] = 51;
			USERINFO[playerid][vcolor_2] = 51;
			USERINFO[playerid][vnitro] = -1;
			USERINFO[playerid][vneon_1] = 0;
			USERINFO[playerid][vneon_2] = 0;
			USERINFO[playerid][vpjob] = 3;
			USERINFO[playerid][vwheel] = 1077;
			USERINFO[playerid][vhydra] = 0;
		}
		else if(isequal("10", inputtext))
		{
			if(USERINFO[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have a vehicle");
			if(GetPlayerMoney(playerid) < 310000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to purchase this vehicle");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You have bought \"Bullet\", Use /v to spawn it");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You can upgrade your vehicle by Tune shop");
			GivePlayerCash(playerid, -310000);
			USERINFO[playerid][vowned] = 1;
			USERINFO[playerid][vmodel] = 541;
			USERINFO[playerid][vcolor_1] = 51;
			USERINFO[playerid][vcolor_2] = 53;
			USERINFO[playerid][vnitro] = -1;
			USERINFO[playerid][vneon_1] = 0;
			USERINFO[playerid][vneon_2] = 0;
			USERINFO[playerid][vpjob] = 3;
			USERINFO[playerid][vwheel] = 1077;
			USERINFO[playerid][vhydra] = 0;
		}
		else
		{
			SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid selection");
			Dialog_Show(playerid, DIALOG_VEH_CAR, DIALOG_STYLE_INPUT, "LGGW - Vehicle Shop", str, "Purchase", "Close");
		}
	}
	return 1;
}

Dialog:DIALOG_VEH_BIKE(playerid, response, listitem, inputtext[])
{
	if(!response) Dialog_Close(playerid);
	if(response)
	{
		new str[700];
		strcat(str, "ID\tBike   \tPrice\n\n");
		strcat(str, "1 \tQuad   \t$30000\n");
		strcat(str, "2 \tFaggio \t$40000\n");
		strcat(str, "3 \tFreeway\t$60000\n");
		strcat(str, "4 \tSanchez\t$70000\n");
		strcat(str, "5 \tPCJ-600\t$90000\n");
		strcat(str, "6 \tBF-400 \t$90000\n");
		strcat(str, "7 \tFCR-900\t$100000");
		if(isempty(inputtext))
		{
			SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid selection");
			Dialog_Show(playerid, DIALOG_VEH_BIKE, DIALOG_STYLE_INPUT, "LGGW - Vehicle Shop ", str, "Purchase", "Close");
		}
		else if(isequal("1", inputtext))
		{
			if(USERINFO[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have a vehicle");
			if(GetPlayerMoney(playerid) < 30000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to purchase this vehicle");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You have bought \"Quad\", Use /v to spawn it");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You can upgrade your vehicle by Tune shop");
			GivePlayerCash(playerid, -30000);
			USERINFO[playerid][vowned] = 1;
			USERINFO[playerid][vmodel] = 471;
			USERINFO[playerid][vcolor_1] = 51;
			USERINFO[playerid][vcolor_2] = 53;
			USERINFO[playerid][vnitro] = -1;
			USERINFO[playerid][vneon_1] = 0;
			USERINFO[playerid][vneon_2] = 0;
			USERINFO[playerid][vpjob] = 3;
			USERINFO[playerid][vwheel] = 1077;
			USERINFO[playerid][vhydra] = 0;
		}
		else if(isequal("2", inputtext))
		{
			if(USERINFO[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have a vehicle");
			if(GetPlayerMoney(playerid) < 40000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to purchase this vehicle");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You have bought \"Faggio\", Use /v to spawn it");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You can upgrade your vehicle by Tune shop");
			GivePlayerCash(playerid, -40000);
			USERINFO[playerid][vowned] = 1;
			USERINFO[playerid][vmodel] = 462;
			USERINFO[playerid][vcolor_1] = 51;
			USERINFO[playerid][vcolor_2] = 53;
			USERINFO[playerid][vnitro] = -1;
			USERINFO[playerid][vneon_1] = 0;
			USERINFO[playerid][vneon_2] = 0;
			USERINFO[playerid][vpjob] = 3;
			USERINFO[playerid][vwheel] = 1077;
			USERINFO[playerid][vhydra] = 0;
		}
		else if(isequal("3", inputtext))
		{
			if(USERINFO[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have a vehicle");
			if(GetPlayerMoney(playerid) < 60000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to purchase this vehicle");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You have bought \"Freeway\", Use /v to spawn it");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You can upgrade your vehicle by Tune shop");
			GivePlayerCash(playerid, -60000);
			USERINFO[playerid][vowned] = 1;
			USERINFO[playerid][vmodel] = 463;
			USERINFO[playerid][vcolor_1] = 51;
			USERINFO[playerid][vcolor_2] = 53;
			USERINFO[playerid][vnitro] = -1;
			USERINFO[playerid][vneon_1] = 0;
			USERINFO[playerid][vneon_2] = 0;
			USERINFO[playerid][vpjob] = 3;
			USERINFO[playerid][vwheel] = 1077;
			USERINFO[playerid][vhydra] = 0;
		}
		else if(isequal("4", inputtext))
		{
			if(USERINFO[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have a vehicle");
			if(GetPlayerMoney(playerid) < 70000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to purchase this vehicle");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You have bought \"Sanchez\", Use /v to spawn it");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You can upgrade your vehicle by Tune shop");
			GivePlayerCash(playerid, -70000);
			USERINFO[playerid][vowned] = 1;
			USERINFO[playerid][vmodel] = 468;
			USERINFO[playerid][vcolor_1] = 51;
			USERINFO[playerid][vcolor_2] = 51;
			USERINFO[playerid][vnitro] = -1;
			USERINFO[playerid][vneon_1] = 0;
			USERINFO[playerid][vneon_2] = 0;
			USERINFO[playerid][vpjob] = 3;
			USERINFO[playerid][vwheel] = 1077;
			USERINFO[playerid][vhydra] = 0;
		}
		else if(isequal("5", inputtext))
		{
			if(USERINFO[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have a vehicle");
			if(GetPlayerMoney(playerid) < 90000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to purchase this vehicle");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You have bought \"PCJ-600\", Use /v to spawn it");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You can upgrade your vehicle by Tune shop");
			GivePlayerCash(playerid, -90000);
			USERINFO[playerid][vowned] = 1;
			USERINFO[playerid][vmodel] = 461;
			USERINFO[playerid][vcolor_1] = 51;
			USERINFO[playerid][vcolor_2] = 51;
			USERINFO[playerid][vnitro] = -1;
			USERINFO[playerid][vneon_1] = 0;
			USERINFO[playerid][vneon_2] = 0;
			USERINFO[playerid][vpjob] = 3;
			USERINFO[playerid][vwheel] = 1077;
			USERINFO[playerid][vhydra] = 0;
		}
		else if(isequal("6", inputtext))
		{
			if(USERINFO[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have a vehicle");
			if(GetPlayerMoney(playerid) < 90000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to purchase this vehicle");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You have bought \"BF-400\", Use /v to spawn it");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You can upgrade your vehicle by Tune shop");
			GivePlayerCash(playerid, -90000);
			USERINFO[playerid][vowned] = 1;
			USERINFO[playerid][vmodel] = 581;
			USERINFO[playerid][vcolor_1] = 51;
			USERINFO[playerid][vcolor_2] = 51;
			USERINFO[playerid][vnitro] = -1;
			USERINFO[playerid][vneon_1] = 0;
			USERINFO[playerid][vneon_2] = 0;
			USERINFO[playerid][vpjob] = 3;
			USERINFO[playerid][vwheel] = 1077;
			USERINFO[playerid][vhydra] = 0;
		}
		else if(isequal("7", inputtext))
		{
			if(USERINFO[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have a vehicle");
			if(GetPlayerMoney(playerid) < 100000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to purchase this vehicle");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You have bought \"FCR-900\", Use /v to spawn it");
			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You can upgrade your vehicle by Tune shop");
			GivePlayerCash(playerid, -100000);
			USERINFO[playerid][vowned] = 1;
			USERINFO[playerid][vmodel] = 521;
			USERINFO[playerid][vcolor_1] = 51;
			USERINFO[playerid][vcolor_2] = 51;
			USERINFO[playerid][vnitro] = -1;
			USERINFO[playerid][vneon_1] = 0;
			USERINFO[playerid][vneon_2] = 0;
			USERINFO[playerid][vpjob] = 3;
			USERINFO[playerid][vwheel] = 1077;
			USERINFO[playerid][vhydra] = 0;
		}
		else
		{
			SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid selection");
			Dialog_Show(playerid, DIALOG_VEH_BIKE, DIALOG_STYLE_INPUT, "LGGW - Vehicle Shop ", str, "Purchase", "Close");
		}
	}
	return 1;
}

Dialog:DIALOG_VEH_SELL(playerid, response, listitem, inputtext[])
{ 
	if(!response) Dialog_Close(playerid);
	if(response)
	{
		if(USERINFO[playerid][vowned] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have any vehicle to sell");
		if(priveh[playerid] == INVALID_VEHICLE_ID) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You must spawn your vehicle first");
		USERINFO[playerid][vowned] = 0;    
		DestroyPrivateVehicle(playerid); 
		switch(USERINFO[playerid][vmodel])
		{
			case 475: GivePlayerCash(playerid, 50000); //Sabre
			case 567: GivePlayerCash(playerid, 60000); //Savana
			case 534: GivePlayerCash(playerid, 75000); //Remington
			case 402: GivePlayerCash(playerid, 85000); //Buffalo
			case 558: GivePlayerCash(playerid, 90000); //Uranus
			case 562: GivePlayerCash(playerid, 105000); //Elegy
			case 560: GivePlayerCash(playerid, 120000); //Sultan
			case 506: GivePlayerCash(playerid, 135000); //Super GT
			case 415: GivePlayerCash(playerid, 145000); //Cheetah
			case 541: GivePlayerCash(playerid, 150000); //Bullet

			case 471: GivePlayerCash(playerid, 15000); //Quad
			case 462: GivePlayerCash(playerid, 20000); //Faggio
			case 463: GivePlayerCash(playerid, 30000); //Freeway
			case 468: GivePlayerCash(playerid, 35000); //Sanchez
			case 461: GivePlayerCash(playerid, 45000); //PCJ 600
			case 581: GivePlayerCash(playerid, 45000); //BF 400
			case 521: GivePlayerCash(playerid, 50000); //FCR-900
		}
	}
	return 1;
}

Dialog:DIALOG_REGISTER(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		
		if(strlen(inputtext) < 5 || strlen(inputtext) > 20) 
		{
			new str[256];
			format(str, sizeof(str), "Welcome to Lazer Gaming Gang WarZ\n\nYour account \"%s\" is not registered. Please enter a desired password below to register", PlayerName(playerid));
			Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT,"LGGW - Registreation",str,"Register","Quit");
			SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Your password must include 5 - 20 characters");
		}
		else
		{
			new str[128];
			GameTextForPlayer(playerid, "~g~$5000", 5000, 1);
			format(str, sizeof(str), "{006400}[ Info ] {00FF00}Registered and Logged in successfully! (Password: %s)", inputtext);
			SendClientMessage(playerid, -1, str);

			mysql_format(Database, str, sizeof(str), "INSERT INTO `Users` (`Name`, `Password`) VALUES ('%e', '%s')", PlayerName(playerid), USERINFO[playerid][ppass]);
		    mysql_tquery(Database, str, "OnPlayerRegister", "d", playerid);
		}
	}
	else return Kick(playerid);
	return 1;
}

forward OnPlayerRegister(playerid);
public OnPlayerRegister(playerid)
{
	SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You have been registered and logged in successfully!");
    logged[playerid] = 1;
    USERINFO[playerid][pid] = cache_insert_id();
    LoadUserData(playerid);
    return 1;
}

Dialog:DIALOG_LOGIN(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new buf[129];
		WP_Hash(buf, sizeof(buf), inputtext);
		if(isequal(buf, USERINFO[playerid][ppass]))
		{
			cache_set_active(USERINFO[playerid][Player_Cache]);
			LoadUserData(playerid);
			cache_delete(USERINFO[playerid][Player_Cache]);
			USERINFO[playerid][Player_Cache] = MYSQL_INVALID_CACHE;

			for(new i = 0; i < 12; i++) if(i != 2 && i != 3) TextDrawHideForPlayer(playerid, connecttd[i]);
			for(new i = 0; i < 10; i++) TextDrawShowForPlayer(playerid, LGGW[i]);

			SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}Logged in successfully");

			if(USERINFO[playerid][plevel] > 0) adm_id[playerid] = GetFreeAdminID();
			if(USERINFO[playerid][jailed] == 1) nocmd[playerid] = 1;

			GivePlayerCash(playerid, USERINFO[playerid][pcash]);
			SetPlayerScore(playerid, USERINFO[playerid][pkills]);

			logged[playerid] = 1;

			new field[128], ip[30];
			for(new i = 0; i < MAX_IP_SAVES; i++)
			{
				mysql_format(Database, field, sizeof(field), "SELECT * FROM IPs WHERE `User_ID` = %d LIMIT 1", USERINFO[playerid][pid]);
				mysql_tquery(Database, field);

				format(field, sizeof(field), "IP_%d", i + 1);
				cache_get_value_name(0, field, ip, sizeof(ip));

				if(isequal(ip, PlayerIP(playerid))) break;
				else
				{
					if(isempty(ip))
					{
						mysql_format(Database, field, sizeof(field), "UPDATE `IPs` SET `%s` = %e WHERE `User_ID` = %d LIMIT 1", field, ip, USERINFO[playerid][pid]);
						mysql_tquery(Database, field);
						break;
					}
				}
			}

			if(IsPlayerBanned(PlayerName(playerid)))
			{
				SendClientMessage(playerid, -1, "*** Contact admins in FORUM or DISCORD group for ban appeals and info ***");
				return BanPlayer(PlayerName(playerid));
			}

			if(IsValidTimer(camtimer[playerid])) KillTimer(camtimer[playerid]);

			if(USERINFO[playerid][ingang] == 1)	return SpawnPlayer(playerid);
			
			CallLocalFunction("OnPlayerRequestClass", "ii", playerid, 0);

		}
		else
		{
			new str[256];
			format(str, sizeof(str), "Welcome back to Lazer Gaming Gang WarZ\n\n\"%s\" account is registered. Please enter your password below to login", PlayerName(playerid));
			Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,"LGGW - Login", str,"Login","Quit");
			SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Incorrect password");
		}
	}
	else return Kick(playerid);
	return 1;
}

Dialog:DIALOG_CLOSE_DIALOG(playerid, response, listitem, inputtext[])
{
	Dialog_Close(playerid); 
	return 1;
}

Dialog:DIALOG_RULES(playerid, response, listitem, inputtext[])
{
	if(response) Dialog_Close(playerid); 
	else
	{
		new str[128];
		Kick(playerid);
		format(str, sizeof(str), "{FF8000}* \"%s[%d]\" kicked from the Server (Rejecting rules)", PlayerName(playerid), playerid);
	}
	return 1;
}

Dialog:DIALOG_RCON(playerid, response, listitem, inputtext[])
{
	new str[256];
	if(response)
	{
		if(isequal(inputtext, ROCN_PASS)) 
		{
			SendClientMessage(playerid, -1, "* You have accessed the SERVER succesfully");
			GameTextForPlayer(playerid,"~g~Welcome administrator",5000,5);
			format(str, sizeof(str), "[ STEP 2 ] `%s[%d]` accessed 2nd RCON successfully :open_mouth: and got the power to control the server!", PlayerName(playerid), playerid);
			DCC_SendChannelMessage(dcc_channel_rcon, str);
		}
		else if(rconattempts[playerid] >= 3) 
		{ 
			format(str, sizeof(str), "{FF8000}* \"%s[%d]\" banned from the Server (Trying to access RCON)", PlayerName(playerid), playerid);
			SendClientMessageToAll_(-1, str);
			BanPlayer(PlayerName(playerid));
			format(str, sizeof(str), "[ STEP 2 ] `%s[%d]` got banned because of trying to access RCON! :joy:", PlayerName(playerid), playerid);
			DCC_SendChannelMessage(dcc_channel_rcon, str);
		}
		else 
		{
			rconattempts[playerid]++;
			SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Incorrect RCON password (If you are not a community owner don't try to access RCON, It will result you in a permanat ban)");
			format(str, sizeof(str), "{006400}[ Info ] {00FF00}Remaining RCON login attempts: %d", 4 - rconattempts[playerid]);
			SendClientMessage(playerid, -1, str);
			Dialog_Show(playerid, DIALOG_RCON, DIALOG_STYLE_PASSWORD, "LGGW - Rcon protection", "You have logged in RCON partially, \nNow input the 2nd RCON security password to access the SERVER features", "Access", "Quit");
			format(str, sizeof(str), "[ STEP 2 ] (attempts: %d/3) `%s[%d]` is trying to access 2nd RCON... @developers use /aka to check who is this! May be he is an enemy :angry: (password: `%s`)", rconattempts[playerid], PlayerName(playerid), playerid, inputtext);
			DCC_SendChannelMessage(dcc_channel_rcon, str);
		}
	}
	else 
	{
		format(str, sizeof(str), "{FF8000}* \"%s[%d]\" kicked from the Server (Trying to access RCON)", PlayerName(playerid), playerid);
		SendClientMessageToAll_(-1, str);
		Kick(playerid);
		format(str, sizeof(str), "[ STEP 2 ] `%s[%d]` got kicked because of trying to access RCON! :joy:", PlayerName(playerid), playerid);
		DCC_SendChannelMessage(dcc_channel_rcon, str);
	}
	return 1;
}

Dialog:DIALOG_TOP_SELECTION(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new completed[1024], str[200], name_[30];
		new val, rows;
		switch(listitem)
		{
			case 0:
			{
				SaveServerData();
				strcat(completed, "Rank\tName\tKills\n", sizeof(completed));
				mysql_query(Database, "SELECT `Name`,`Kills` FROM `Users` ORDER BY `Kills` DESC LIMIT 10");
				cache_get_row_count(rows);
				for(new a; a < rows; a++) 
				{ 
					cache_get_value_name(a, "Name", name_, sizeof(name_));
					cache_get_value_name_int(a, "Kills", val);
					format(str, sizeof(str), "%d\t%s\t%d\n", a + 1, name_, val);
					strcat(completed, str);
				}                       
				Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Top Killers", completed, "Close", "");
			}
			case 1:
			{
				SaveServerData();
				strcat(completed, "Rank\tName\tDeaths\n", sizeof(completed));
				mysql_query(Database, "SELECT `Name`,`Deaths` FROM `Users` ORDER BY `Deaths` DESC LIMIT 10");
				cache_get_row_count(rows);
				for(new a; a < rows; a++) 
				{ 
					cache_get_value_name(a, "Name", name_, sizeof(name_));
					cache_get_value_name_int(a, "Deaths", val);
					format(str, sizeof(str), "%d\t%s\t%d\n", a + 1, name_, val);
					strcat(completed, str);
				}                       
				Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Top Weakest", completed, "Close", "");
			}
			case 2:
			{
				SaveServerData();
				strcat(completed, "Rank\tName\tCash\n", sizeof(completed));
				mysql_query(Database, "SELECT `Name`,`Cash` FROM `Users` ORDER BY `Cash` DESC LIMIT 10");
				cache_get_row_count(rows);
				for(new a; a < rows; a++) 
				{ 
					cache_get_value_name(a, "Name", name_, sizeof(name_));
					cache_get_value_name_int(a, "Cash", val);
					format(str, sizeof(str), "%d\t%s\t%d\n", a + 1, name_, val);
					strcat(completed, str);
				}                                   
				Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Top Richest", completed, "Close", "");
			}
			case 3:
			{
				SaveServerData();
				strcat(completed, "Rank\tName\tRatio\n", sizeof(completed));
				mysql_query(Database, "SELECT `Name`,`Ratio` FROM `Users` ORDER BY `Ratio` DESC LIMIT 10");
				cache_get_row_count(rows);
				new Float:vlu;
				for(new a; a < rows; a++) 
				{ 
					cache_get_value_name(a, "Name", name_, sizeof(name_));
					cache_get_value_name_float(a, "Ratio", vlu);
					format(str, sizeof(str), "%d\t%s\t%.2f\n", a + 1, name_, vlu);
					strcat(completed, str);
				}   
				Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Top Ratio maintainers", completed, "Close", "");
			}
			case 4:
			{
				SaveServerData();
				strcat(completed, "Rank\tName\tDuels won\n", sizeof(completed));
				mysql_query(Database, "SELECT `Name`,`Duels_won` FROM `Users` ORDER BY `Duels_won` DESC LIMIT 10");
				cache_get_row_count(rows);
				for(new a; a < rows; a++) 
				{ 
					cache_get_value_name(a, "Name", name_, sizeof(name_));
					cache_get_value_name_int(a, "Duels_won", val);
					format(str, sizeof(str), "%d\t%s\t%d\n", a + 1, name_, val);
					strcat(completed, str);
				}   
				Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Top Duels won", completed, "Close", "");
			}
			case 5:
			{
				SaveServerData();
				strcat(completed, "Rank\tName\tRampage\n", sizeof(completed));
				mysql_query(Database, "SELECT `Name`,`Highest_rampage` FROM `Users` ORDER BY `Highest_rampage` DESC LIMIT 10");
				cache_get_row_count(rows);
				for(new a; a < rows; a++) 
				{ 
					cache_get_value_name(a, "Name", name_, sizeof(name_));
					cache_get_value_name_int(a, "Highest_rampage", val);
					format(str, sizeof(str), "%d\t%s\t%d\n", a + 1, name_, val);
					strcat(completed, str);
				}   
				Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Top Rampages", completed, "Close", "");
			}
			case 6:
			{
				SaveServerData();
				strcat(completed, "Rank\tName\tRobberies\n", sizeof(completed));
				mysql_query(Database, "SELECT `Name`,`Robberies` FROM `Users` ORDER BY `Robberies` DESC LIMIT 10");
				cache_get_row_count(rows);
				for(new a; a < rows; a++) 
				{ 
					cache_get_value_name(a, "Name", name_, sizeof(name_));
					cache_get_value_name_int(a, "Robberies", val);
					format(str, sizeof(str), "%d\t%s\t%d\n", a + 1, name_, val);
					strcat(completed, str);
				}   
				Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Top Robbers", completed, "Close", "");
			}
			case 7:
			{
				SaveServerData();
				strcat(completed, "Rank\tName\tRevenges\n", sizeof(completed));
				mysql_query(Database, "SELECT `Name`,`Revenges` FROM `Users` ORDER BY `Revenges` DESC LIMIT 10");
				cache_get_row_count(rows);
				for(new a; a < rows; a++) 
				{ 
					cache_get_value_name(a, "Name", name_, sizeof(name_));
					cache_get_value_name_int(a, "Revenges", val);
					format(str, sizeof(str), "%d\t%s\t%d\n", a + 1, name_, val);
					strcat(completed, str);
				}   
				Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Top Revenges", completed, "Close", "");
			}
			case 8:
			{
				SaveServerData();
				strcat(completed, "Rank\tName\tTurfs\n", sizeof(completed));
				mysql_query(Database, "SELECT `Name`,`Turfs` FROM `Gangs` WHERE `Name` != '-1' ORDER BY `Turfs` DESC LIMIT 10");
				cache_get_row_count(rows);
				for(new a; a < rows; a++) 
				{ 
					cache_get_value_name(a, "Name", name_, sizeof(name_));
					cache_get_value_name_int(a, "Turfs", val);
					strreplace(name_, "_", " ");
					format(str, sizeof(str), "%d\t%s\t%d\n", a + 1, name_, val); 
					strcat(completed, str); 
				}   
				Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Top Turf owners", completed, "Close", "");
			}
			case 9:
			{
				SaveServerData();
				strcat(completed, "Rank\tName\tScore\n", sizeof(completed));
				mysql_query(Database, "SELECT `Name`,`Score` FROM `Gangs` WHERE `Name` != '-1' ORDER BY `Score` DESC LIMIT 10");
				cache_get_row_count(rows);
				for(new a; a < rows; a++) 
				{ 
					cache_get_value_name(a, "Name", name_, sizeof(name_));
					cache_get_value_name_int(a, "Score", val);
					strreplace(name_, "_", " ");
					format(str, sizeof(str), "%d\t%s\t%d\n", a + 1, name_, val);
					strcat(completed, str);
				}   
				Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Top Gangs", completed, "Close", "");
			}
			case 10:
			{
				SaveServerData();
				strcat(completed, "Rank\tName\tBrutal kills\n", sizeof(completed));
				mysql_query(Database, "SELECT `Name`,`Brutal_kills` FROM `Users` ORDER BY `Brutal_kills` DESC LIMIT 10");
				cache_get_row_count(rows);
				for(new a; a < rows; a++) 
				{ 
					cache_get_value_name(a, "Name", name_, sizeof(name_));
					cache_get_value_name_int(a, "Brutal_kills", val);
					format(str, sizeof(str), "%d\t%s\t%d\n", a + 1, name_, val);
					strcat(completed, str);
				}   
				Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Top Brutal killers", completed, "Close", "");
			}
			case 11:
			{
				SaveServerData();
				strcat(completed, "Rank\tName\tLMS won\n", sizeof(completed));
				mysql_query(Database, "SELECT `Name`,`LMS_Won` FROM `Users` ORDER BY `LMS_Won` DESC LIMIT 10");
				cache_get_row_count(rows);
				for(new a; a < rows; a++) 
				{ 
					cache_get_value_name(a, "Name", name_, sizeof(name_));
					cache_get_value_name_int(a, "LMS_Won", val);
					format(str, sizeof(str), "%d\t%s\t%d\n", a + 1, name_, val);
					strcat(completed, str);
				}   
				Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Top LMS winners", completed, "Close", "");
			}
			case 12:
			{
				SaveServerData();
				strcat(completed, "Rank\tName\tGunGames won\n", sizeof(completed));
				mysql_query(Database, "SELECT `Name`,`GunGames_won` FROM `Users` ORDER BY `GunGames_won` DESC LIMIT 10");
				cache_get_row_count(rows);
				for(new a; a < rows; a++) 
				{ 
					cache_get_value_name(a, "Name", name_, sizeof(name_));
					cache_get_value_name_int(a, "GunGames_won", val);
					format(str, sizeof(str), "%d\t%s\t%d\n", a + 1, name_, val);
					strcat(completed, str);
				}   
				Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Top GunGame winners", completed, "Close", "");
			}
			case 13:
			{
				SaveServerData();
				strcat(completed, "Rank\tName\tHead shots\n", sizeof(completed));
				mysql_query(Database, "SELECT `Name`,`Head_shots` FROM `Users` ORDER BY `Head_shots` DESC LIMIT 10");
				cache_get_row_count(rows);
				for(new a; a < rows; a++) 
				{ 
					cache_get_value_name(a, "Name", name_, sizeof(name_));
					cache_get_value_name_int(a, "Head_shots", val);
					format(str, sizeof(str), "%d\t%s\t%d\n", a + 1, name_, val);
					strcat(completed, str);
				}   
				Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Top Head shotters", completed, "Close", "");
			}
		}
	}
	return 1;
}

Dialog:DIALOG_LMS_PLACE(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(lmsstarted == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Last Man Standing event has already started");
		if(isequal("1", inputtext))
		{
			inlms[playerid] = 1;
			lmsstarted = 1;
			lmsplace = 1;
			SetTimer("StartLastManStanding", 60000, false);
			SendClientMessageToAll_(-1, "{800080}[ LMS ] {8000FF}Player counting for Last Man Standing started (for join use /lms)");
			SendClientMessageToAll_(-1, "{800080}[ LMS ] {8000FF}Last Man Standing will start in 1 more minute (stay tuned)");
			GameTextForAll("Last Man Standing counting started!!!~n~/LMS", 15000, 4);
			TextDrawSetString(LGGW[1], "~w~Player counting for ~p~Last Man Standing ~g~started ~r~(/lms)");
		}
		else if(isequal("2", inputtext))
		{
			inlms[playerid] = 1;
			lmsstarted = 1;
			lmsplace = 2;
			SetTimer("StartLastManStanding", 60000, false);
			SendClientMessageToAll_(-1, "{800080}[ LMS ] {8000FF}Player counting for Last Man Standing started (for join use /lms)");
			SendClientMessageToAll_(-1, "{800080}[ LMS ] {8000FF}Last Man Standing will start in 1 more minute (stay tuned)");
			GameTextForAll("Last Man Standing counting started!!!~n~/LMS", 15000, 4);
			TextDrawSetString(LGGW[1], "~w~Player counting for ~p~Last Man Standing ~g~started ~r~(/lms)");
		}
		else if(isequal("3", inputtext))
		{
			inlms[playerid] = 1;
			lmsstarted = 1;
			lmsplace = 3;
			SetTimer("StartLastManStanding", 60000, false);
			SendClientMessageToAll_(-1, "{800080}[ LMS ] {8000FF}Player counting for Last Man Standing started (for join use /lms)");
			SendClientMessageToAll_(-1, "{800080}[ LMS ] {8000FF}Last Man Standing will start in 1 more minute (stay tuned)");
			GameTextForAll("Last Man Standing counting started!!!~n~/LMS", 15000, 4);
			TextDrawSetString(LGGW[1], "~w~Player counting for ~p~Last Man Standing ~g~started ~r~(/lms)");
		}
		else if(isequal("4", inputtext))
		{
			inlms[playerid] = 1;
			lmsstarted = 1;
			lmsplace = 4;
			SetTimer("StartLastManStanding", 60000, false);
			SendClientMessageToAll_(-1, "{800080}[ LMS ] {8000FF}Player counting for Last Man Standing started (for join use /lms)");
			SendClientMessageToAll_(-1, "{800080}[ LMS ] {8000FF}Last Man Standing will start in 1 more minute (stay tuned)");
			GameTextForAll("Last Man Standing counting started!!!~n~/LMS", 15000, 4);
			TextDrawSetString(LGGW[1], "~w~Player counting for ~p~Last Man Standing ~g~started ~r~(/lms)");
		}
		else
		{
			Dialog_Show(playerid, DIALOG_LMS_PLACE, DIALOG_STYLE_INPUT, "LGGW - Last Man Standing", "ID\tPlace\n\n1\tJefforson Motel\n2\tRC Battlefield\n3\tRussian Mafia Base\n4\tValle Ocultado", "Enter", "Close");
			SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid selection");
		}
		
	}
	else Dialog_Close(playerid);
	return 1;
}

Dialog:DIALOG_GANG_ENTER_NAME(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(strlen(inputtext) > 29 || strlen(inputtext) < 6)
		{
			Dialog_Show(playerid, DIALOG_GANG_ENTER_NAME, DIALOG_STYLE_INPUT, "LGGW - Create a gang (Step - 1)", "Insert the name of the gang that you want to create\n\n[ Note ] Name length should in between 6 - 29", "Enter", "Close");
			SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Name length of the gang should in between 6 - 29");
		}
		else 
		{
			if(!IsValidGangNameOrTag(inputtext)) 
			{
				Dialog_Show(playerid, DIALOG_GANG_ENTER_NAME, DIALOG_STYLE_INPUT, "LGGW - Create a gang (Step - 1)", "Insert the name of the gang that you want to create\n\n[ Note ] Name length should in between 6 - 29", "Enter", "Close");
				return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}This gang name contains invalid characters");
			}
			format(tempgname[playerid], 30, "%s", inputtext);
			strreplace(tempgname[playerid], " ", "_");
			for(new i = 0; i < MAX_GANGS; i++)
			{
				if(IsValidGang(i))
				{
					if(isequal(tempgname[playerid], GANGINFO[i][gname], true))
					{
						Dialog_Show(playerid, DIALOG_GANG_ENTER_NAME, DIALOG_STYLE_INPUT, "LGGW - Create a gang (Step - 1)", "Insert the name of the gang that you want to create\n\n[ Note ] Name length should in between 6 - 29", "Enter", "Close");
						return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}A gang with this name already exists");
					}
				}
			}
			
			Dialog_Show(playerid, DIALOG_GANG_ENTER_TAG, DIALOG_STYLE_INPUT, "LGGW - Create a gang (Step - 2)", "Insert a name to display as the tag of the gang\n[ Example ] Tag \"HlF\" for a gang named \"Hopeless Fighters\"\n\n[ Note ] Tag length should in between 2 - 4", "Enter", "Close");
		}
	}
	else Dialog_Close(playerid);
	return 1;
}

Dialog:DIALOG_GANG_ENTER_TAG(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(strlen(inputtext) > 4 || strlen(inputtext) < 2) 
		{
			SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Name length of the tag should in between 3 - 4");
			Dialog_Show(playerid, DIALOG_GANG_ENTER_TAG, DIALOG_STYLE_INPUT, "LGGW - Create a gang (Step - 2)", "Insert a name to display as the tag of the gang\n[ Example ] Tag \"HlF\" for a gang named \"Hopeless Fighters\"\n\n[ Note ] Tag length should in between 2 - 4", "Enter", "Close");
		}
		else
		{
			if(!IsValidGangNameOrTag(inputtext)) 
			{
				Dialog_Show(playerid, DIALOG_GANG_ENTER_TAG, DIALOG_STYLE_INPUT, "LGGW - Create a gang (Step - 2)", "Insert a name to display as the tag of the gang\n[ Example ] Tag \"HlF\" for a gang named \"Hopeless Fighters\"\n\n[ Note ] Tag length should in between 2 - 4", "Enter", "Close");
				return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}This gang tag contains invalid characters");
			}
			format(tempgtag[playerid], 30, "%s", inputtext);
			strreplace(tempgtag[playerid], " ", "_");
			for(new i = 0; i < MAX_GANGS; i++)
			{
				new key = i;
				if(IsValidGang(key))
				{
					if(isequal(tempgtag[playerid], GANGINFO[key][gtag], true))
					{
						Dialog_Show(playerid, DIALOG_GANG_ENTER_TAG, DIALOG_STYLE_INPUT, "LGGW - Create a gang (Step - 2)", "Insert a name to display as the tag of the gang\n[ Example ] Tag \"HlF\" for a gang named \"Hopeless Fighters\"\n\n[ Note ] Tag length should in between 2 - 4", "Enter", "Close");
						return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}A gang with this tag already exists");
					}
				}
			}
			new str[256];
			format(str, sizeof(str), "~ Gang Confirmation ~\n\nYour gang Info...\nGang name: %s\nGang tag: %s\n\n[ Note ]This action is irreversable\nyou will cost $%d and look again what you have entered ", tempgname[playerid], tempgtag[playerid], MIN_CASH_TO_CREATE_A_GANG);
			Dialog_Show(playerid, DIALOG_GANG_CONFIRMATION, DIALOG_STYLE_MSGBOX, "LGGW - Create a gang (Step - 3)", str, "Create", "Close");
		}
	}
	else Dialog_Close(playerid);
	return 1;
}

Dialog:DIALOG_GANG_CONFIRMATION(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in an interior");
		if(USERINFO[playerid][ingang] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a gang");
		if(GetPlayerMoney(playerid) < MIN_CASH_TO_CREATE_A_GANG) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to create a gang");
		GivePlayerCash(playerid, -MIN_CASH_TO_CREATE_A_GANG);
		new str[300];
		
		new key = GetLastGangID();
        mysql_format(Database, str, sizeof(str), "UPDATE `Gangs` SET `Name` = %e, `Tag` = %e, `Member_1` = %d WHERE `Gang_ID`  = %d LIMIT 1", tempgname[playerid], tempgtag[playerid], USERINFO[playerid][pid], key + 1);
        mysql_query(Database, str);
		
		LoadGangData(key);

		USERINFO[playerid][ingang] = 1;
		USERINFO[playerid][gid] = key;
		USERINFO[playerid][glevel] = 4;
		USERINFO[playerid][gskin] = 1;

		SetPlayerTeam(playerid, key);
		SetPlayerColor(playerid, GANGINFO[key][gcolor]);
		SetPlayerSkin(playerid, USERINFO[playerid][gskin]);

		
		Delete3DTextLabel(glabel[playerid]); 
		format(str, sizeof(str), "| %s |", GANGINFO[key][gtag]);
		glabel[playerid] = Create3DTextLabel(str, GANGINFO[key][gcolor], 0.0, 0.0, 0.0, 50.0, 0);
		Attach3DTextLabelToPlayer(glabel[playerid], playerid, 0.0, 0.0, 0.3);

		if(USERINFO[playerid][vowned] == 1 && priveh[playerid] != INVALID_VEHICLE_ID)
		{
			Delete3DTextLabel(vehlabel[priveh[playerid]]); 
			new color = GANGINFO[key][gcolor];
			format(str, sizeof(str), "[Private vehicle]\n{%06x}%s", color >>> 8, PlayerName(playerid));
			vehlabel[priveh[playerid]] = Create3DTextLabel(str, -1, 0.0, 0.0, 0.0, 50.0, 0);
			Attach3DTextLabelToVehicle(vehlabel[priveh[playerid]], priveh[playerid], 0.0, 0.0, 1.25);
		}

		SaveServerData();
	}
	else Dialog_Close(playerid);
	return 1;
}

Dialog:DIALOG_GANG_WARNING(playerid, response, listitem, inputtext[])
{
	if(response) return PC_EmulateCommand(playerid, "/gang destroy");
	else Dialog_Close(playerid);
	return 1;
}

Dialog:DIALOG_GANG_COLOR(playerid, response, listitem, inputtext[])
{
	new str[128];
	if(response)
	{
		new tempgcolor;
		if(isequal("1", inputtext)) tempgcolor = 0x696969ff;
		else if(isequal("2", inputtext)) tempgcolor = 0x2f4f4fff;
		else if(isequal("3", inputtext)) tempgcolor = 0xf0e68cff;
		else if(isequal("4", inputtext)) tempgcolor = 0xff0000ff;
		else if(isequal("5", inputtext)) tempgcolor = 0xFF6347ff;
		else if(isequal("6", inputtext)) tempgcolor = 0xff69b4ff;
		else if(isequal("7", inputtext)) tempgcolor = 0x8b4513ff;
		else if(isequal("8", inputtext)) tempgcolor = 0xcd853fff;
		else if(isequal("9", inputtext)) tempgcolor = 0xb22222ff;
		else if(isequal("10", inputtext)) tempgcolor = 0x9370dbff;
		else if(isequal("11", inputtext)) tempgcolor = 0xc1cdc1ff;
		else if(isequal("12", inputtext)) tempgcolor = 0x000033ff;
		else if(isequal("13", inputtext)) tempgcolor = 0x6495edff;
		else if(isequal("14", inputtext)) tempgcolor = 0x7cfc00ff;
		else if(isequal("15", inputtext)) tempgcolor = 0x556b2fff;
		else 
		{
			SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid selection");
			Dialog_Show(playerid, DIALOG_GANG_COLOR, DIALOG_STYLE_INPUT, "LGGW - Gang Color", "For each color it will cost $50000\n\nID\tColor\n\n{696969}1\tDim Gray\n{2f4f4f}2\tDark Slate Gray\n{f0e68c}3\tKhaki\n{ff0000}4\tRed\n{FF6347}5\tSalmon\n{ff69b4}6\tHot Pink\n{8b4513}7\tSaddle Brown\n{cd853f}8\tPeru\n{b22222}9\tFirebrick\n{9370db}10\tMedium Purple\n{c1cdc1}11\tHoneydew\n{000033}12\tBlackish Blue\n{6495ed}13\tCornflower Blue\n{7cfc00}14\tLawn Green\n{556b2f}15\tDark Olive Green", "Enter", "Close");
		}

		if(tempgcolor == GANGINFO[USERINFO[playerid][gid]][gcolor]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Your gang already own this colour");
		if(GetPlayerMoney(playerid) < MIN_CASH_TO_CHANGE_GANG_COLOR) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
	
		for(new g = 0; g < MAX_GANGS; g++)
		{
			if(IsValidGang(g))
			{
				if(GANGINFO[g][gcolor] == tempgcolor && g != USERINFO[playerid][gid] && GANGINFO[USERINFO[playerid][gid]][gscore] <= GANGINFO[g][gscore]) 
				{   
					format(str, sizeof(str), "{e60000}[ Error ] {FF6347}This gang colour is owned by \"%s[%d]\" which has a higher gang score than your gang", ReplaceUwithS(GANGINFO[g][gname]), g);
					return SendClientMessage(playerid, -1, str);
				}
				else if(GANGINFO[g][gcolor] == tempgcolor && g != USERINFO[playerid][gid] && GANGINFO[USERINFO[playerid][gid]][gscore] > GANGINFO[g][gscore]) 
				{ 
					GANGINFO[g][gcolor] = 0xFFFFFFFF;
					foreach(new k : Player)
					{
						if(USERINFO[k][gid] == g && !IsPlayerInClassSelection(k))
						{
							Delete3DTextLabel(glabel[k]); 
							format(str, sizeof(str), "| %s |", GANGINFO[g][gtag]);
							glabel[k] = Create3DTextLabel(str, GANGINFO[g][gcolor], 0.0, 0.0, 0.0, 50.0, 0);
							Attach3DTextLabelToPlayer(glabel[k], k, 0.0, 0.0, 0.3);

							if(USERINFO[k][vowned] == 1)
							{
								if(INVALID_VEHICLE_ID != priveh[k])
								{
									Delete3DTextLabel(vehlabel[priveh[k]]); 
									new color = GANGINFO[g][gcolor];
									format(str, sizeof(str), "[Private vehicle]\n{%06x}%s", color >>> 8, PlayerName(k));
									vehlabel[priveh[k]] = Create3DTextLabel(str, -1, 0.0, 0.0, 0.0, 50.0, 0);
									Attach3DTextLabelToVehicle(vehlabel[priveh[k]], priveh[k], 0.0, 0.0, 1.25);
								}
							}
							
							if(inminigame[k] == 0) SetPlayerColor(k, GANGINFO[g][gcolor]);
							else COLOR[k] =  GANGINFO[g][gcolor];
						}
					}
					for(new i = 0; i < sizeof(ZONEINFO); i++)
					{
						if(ZONEINFO[i][zteamid] == g) GangZoneShowForAll(ZONEID[i], Zone_ColorAlpha(GANGINFO[ZONEINFO[i][zteamid]][gcolor]));
					}
					if(GANGINFO[g][ghouse] == 1)
					{        
						new c = GANGINFO[g][ghouseid];
						Delete3DTextLabel(hlabel[c]);
						format(str, sizeof(str), "[Head Qauters]\n%s", ReplaceUwithS(GANGINFO[HOUSEINFO[c][hteamid]][gname]));
						hlabel[c] = Create3DTextLabel(str, GANGINFO[g][gcolor], HOUSEINFO[c][entercp][0], HOUSEINFO[c][entercp][1], HOUSEINFO[c][entercp][2], 50.0, 0, 0);
					}
				}
			}
		}

		GANGINFO[USERINFO[playerid][gid]][gcolor] = tempgcolor;
		GivePlayerCash(playerid, -MIN_CASH_TO_CHANGE_GANG_COLOR);
		
		foreach(new j : Player)
		{
			if(USERINFO[j][gid] == USERINFO[playerid][gid] && !IsPlayerInClassSelection(j))
			{
				Delete3DTextLabel(glabel[j]); 
				format(str, sizeof(str), "| %s |", GANGINFO[USERINFO[playerid][gid]][gtag]);
				glabel[j] = Create3DTextLabel(str, GANGINFO[USERINFO[playerid][gid]][gcolor], 30.0, 40.0, 50.0, 50.0, 0);
				Attach3DTextLabelToPlayer(glabel[j], j, 0.0, 0.0, 0.3);
				
				if(inminigame[j] == 0) SetPlayerColor(j, GANGINFO[USERINFO[playerid][gid]][gcolor]);
				else COLOR[j] =  GANGINFO[USERINFO[playerid][gid]][gcolor];

				if(USERINFO[j][vowned] == 1)
				{
					if(INVALID_VEHICLE_ID != priveh[j])
					{
						Delete3DTextLabel(vehlabel[priveh[j]]); 
						new color = GANGINFO[USERINFO[playerid][gid]][gcolor];
						format(str, sizeof(str), "[Private vehicle]\n{%06x}%s", color >>> 8, PlayerName(j));
						vehlabel[priveh[j]] = Create3DTextLabel(str, -1, 0.0, 0.0, 0.0, 50.0, 0);
						Attach3DTextLabelToVehicle(vehlabel[priveh[j]], priveh[j], 0.0, 0.0, 1.25);
					}
				}
			}
		}
		
		for(new i = 0; i < sizeof(ZONEINFO); i++)
		{
			if(ZONEINFO[i][zteamid] == USERINFO[playerid][gid])
			{
				GangZoneShowForAll(ZONEID[i], Zone_ColorAlpha(GANGINFO[ZONEINFO[i][zteamid]][gcolor]));
			}
		}
		if(GANGINFO[USERINFO[playerid][gid]][ghouse] == 1)
		{
			new c = GANGINFO[USERINFO[playerid][gid]][ghouseid];
			Delete3DTextLabel(hlabel[c]);
			format(str, sizeof(str), "[Head Qauters]\n%s", ReplaceUwithS(GANGINFO[HOUSEINFO[c][hteamid]][gname]));
			hlabel[c] = Create3DTextLabel(str, GANGINFO[HOUSEINFO[c][hteamid]][gcolor], HOUSEINFO[c][entercp][0], HOUSEINFO[c][entercp][1], HOUSEINFO[c][entercp][2], 50.0, 0, 0);
		}
	}
	else Dialog_Close(playerid);
	return 1;
}

Dialog:DIALOG_VEH_MOD_PREVIEW(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		Dialog_Show(playerid, DIALOG_VEH_MOD_PREVIEW, DIALOG_STYLE_LIST, "LGGW - Vehicle Shop", "Vehicle Colors\nVehicle Paint Jobs\nVehicle Neons\nVehicle Hydraulics\nVehicle Nitro\nVehicle Wheels", "Select", "Close");
		switch(listitem)
		{
			case 0:
			{
				if(PVehIs2ColorVehicle(GetVehicleModel(GetPlayerVehicleID(playerid)))) Dialog_Show(playerid, DIALOG_VEH_MOD_PCOLOR, DIALOG_STYLE_LIST, "LGGW - Vehicle Shop - Color", "Color 1\nColor 2\n    \nBack", "Select", "Close");
				else Dialog_Show(playerid, DIALOG_VEH_MOD_COLOR, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Vehicle Shop - Color", "Color\tPrice\nBlack\t$150\nWhite\t$150\nGreen\t$150\nCyan\t$150\nBlue\t$150\nYellow\t$150\nGrey\t$150\nPink\t$150\nOrange\t$150\n    \nBack", "Select", "Close");
			}
			case 1: 
			{
				if(PVehIsPaintjobAvailable(GetVehicleModel(GetPlayerVehicleID(playerid)))) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Paint jobs are not available for your vehicle");
				Dialog_Show(playerid, DIALOG_VEH_MOD_PJOBS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Vehicle Shop - Paint Jobs","Option\tPrice\nAdd Paint Job 1\t$750\nAdd Paint Job 2\t$750\nAdd Paint Job 3\t$750\nRemove Paint Job\tFree\n    \nBack", "Select", "Close");
			}
			case 2: Dialog_Show(playerid, DIALOG_VEH_MOD_NEON, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Vehicle Shop - Neons", "Option\tPrice\nAdd neon 1\t$3000\nAdd neon 2\t$2000\nRemove All neons\tFree\n    \nBack", "Select", "Close"); 
			case 3:
			{
				if(PVehIsBike(GetVehicleModel(GetPlayerVehicleID(playerid)))) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Hydraulics are not available for your vehicle");
				Dialog_Show(playerid, DIALOG_VEH_MOD_HYDRA, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Vehicle Shop - Hydraulics", "Option\tPrice\nAdd Hydraulics\t$1000\nRemove Hydraulics\tFree\n    \nBack", "Select", "Close");
			}
			case 4:
			{
				if(PVehIsBike(GetVehicleModel(GetPlayerVehicleID(playerid)))) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Nitros are not available for your vehicle");
				Dialog_Show(playerid, DIALOG_VEH_MOD_NITRO, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Vehicle Shop - Nitrous", "Option\tPrice\nAdd Nitro x2\t$200\nAdd Nitro x5\t$500\nAdd Nitro x10\t$1000\nRemove Nitro\tFree\n    \nBack", "Select", "Close");
			} 
			case 5: Dialog_Show(playerid, DIALOG_VEH_MOD_WHEEL, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Vehicle Shop - Wheels", "Wheel type\tPrice\nShadow\t$350\nMega\t$350\nRinshine\t$350\nWires\t$350\nClassic\t$350\nTwist\t$350\nCutter\t$350\nDollar\t$350\nAtomic\t$350\n    \nBack", "Select", "Close")   ;
		}
	}
	else Dialog_Close(playerid); 
	return 1;
}

Dialog:DIALOG_VEH_MOD_PCOLOR(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
			case 0: Dialog_Show(playerid, DIALOG_VEH_MOD_COLOR_1, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Vehicle Shop - Color - Color 1", "Color\tPrice\nBlack\t$150\nWhite\t$150\nGreen\t$150\nCyan\t$150\nBlue\t$150\nYellow\t$150\nGrey\t$150\nPink\t$150\nOrange\t$150\n    \nBack", "Select", "Close");
			case 1: Dialog_Show(playerid, DIALOG_VEH_MOD_COLOR_2, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Vehicle Shop - Color - Color 2", "Color\tPrice\nBlack\t$150\nWhite\t$150\nGreen\t$150\nCyan\t$150\nBlue\t$150\nYellow\t$150\nGrey\t$150\nPink\t$150\nOrange\t$150\n    \nBack", "Select", "Close");
			case 2: Dialog_Show(playerid, DIALOG_VEH_MOD_PCOLOR, DIALOG_STYLE_LIST, "LGGW - Vehicle Shop - Color", "Color 1\nColor 2\n    \nBack", "Select", "Close");
			case 3: Dialog_Show(playerid, DIALOG_VEH_MOD_PREVIEW, DIALOG_STYLE_LIST, "LGGW - Vehicle Shop", "Vehicle Colors\nVehicle Paint Jobs\nVehicle Neons\nVehicle Hydraulics\nVehicle Nitro\nVehicle Wheels", "Select", "Close");
		}
	}
	else Dialog_Close(playerid); 
	return 1;
}

Dialog:DIALOG_VEH_MOD_COLOR(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		HideTextDraws(playerid);
		Dialog_Show(playerid, DIALOG_VEH_MOD_COLOR, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Vehicle Shop - Color", "Color\tPrice\nBlack\t$150\nWhite\t$150\nGreen\t$150\nCyan\t$150\nBlue\t$150\nYellow\t$150\nGrey\t$150\nPink\t$150\nOrange\t$150\n    \nBack", "Select", "Close");
		switch(listitem)
		{
			case 0: 
			{
				if(USERINFO[playerid][vcolor_1] == 0 && USERINFO[playerid][vcolor_2] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), 0, 0);
				ModifyTuneShopTextDraws(playerid, "Color:_Black");
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				vehitem[playerid] = 0;
			} //black
			case 1: 
			{
				if(USERINFO[playerid][vcolor_1] == 1 && USERINFO[playerid][vcolor_2] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), 1, 1);
				ModifyTuneShopTextDraws(playerid, "Color:_White");
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				vehitem[playerid] = 1;
			} //white
			case 2: 
			{
				if(USERINFO[playerid][vcolor_1] == 128 && USERINFO[playerid][vcolor_2] == 128) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), 128, 128);
				ModifyTuneShopTextDraws(playerid, "Color:_Green");
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				vehitem[playerid] = 2;
			} //green
			case 3: 
			{
				if(USERINFO[playerid][vcolor_1] == 135 && USERINFO[playerid][vcolor_2] == 135) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), 135, 135);
				ModifyTuneShopTextDraws(playerid, "Color:_Cyan");
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				vehitem[playerid] = 3;
			} //cyan
			case 4: 
			{
				if(USERINFO[playerid][vcolor_1] == 152 && USERINFO[playerid][vcolor_2] == 152) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), 152, 152);
				ModifyTuneShopTextDraws(playerid, "Color:_Blue");
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				vehitem[playerid] = 4;
			} //blue
			case 5: 
			{
				if(USERINFO[playerid][vcolor_1] == 6 && USERINFO[playerid][vcolor_2] == 6) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), 6, 6);
				ModifyTuneShopTextDraws(playerid, "Color:_Yellow");
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				vehitem[playerid] = 5;
			} //yellow
			case 6: 
			{
				if(USERINFO[playerid][vcolor_1] == 252 && USERINFO[playerid][vcolor_2] == 252) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), 252, 252);
				ModifyTuneShopTextDraws(playerid, "Color:_Grey");
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				vehitem[playerid] = 6;
			} //grey 
			case 7: 
			{
				if(USERINFO[playerid][vcolor_1] == 146 && USERINFO[playerid][vcolor_2] == 146) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), 146, 146);
				ModifyTuneShopTextDraws(playerid, "Color:_Pink");
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				vehitem[playerid] = 7;
			} //pink
			case 8: 
			{
				if(USERINFO[playerid][vcolor_1] == 219 && USERINFO[playerid][vcolor_2] == 219) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), 219, 219);
				ModifyTuneShopTextDraws(playerid, "Color:_Orange");
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				vehitem[playerid] = 8;
			} //orange
			case 9:  SetVehicleRealData(playerid);
			case 10: 
			{
				SetVehicleRealData(playerid);
				Dialog_Show(playerid, DIALOG_VEH_MOD_PREVIEW, DIALOG_STYLE_LIST, "LGGW - Vehicle Shop", "Vehicle Colors\nVehicle Paint Jobs\nVehicle Neons\nVehicle Hydraulics\nVehicle Nitro\nVehicle Wheels", "Select", "Close");          
			}
		}
	}
	else
	{
		HideTextDraws(playerid);
		SetVehicleRealData(playerid);
		Dialog_Close(playerid);
	}
	return 1;
}

Dialog:DIALOG_VEH_MOD_COLOR_1(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		HideTextDraws(playerid);
		Dialog_Show(playerid, DIALOG_VEH_MOD_COLOR_1, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Vehicle Shop - Color - Color 1", "Color\tPrice\nBlack\t$150\nWhite\t$150\nGreen\t$150\nCyan\t$150\nBlue\t$150\nYellow\t$150\nGrey\t$150\nPink\t$150\nOrange\t$150\n    \nBack", "Select", "Close");
		switch(listitem) 
		{
			case 0: 
			{                
				if(USERINFO[playerid][vcolor_1] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), 0, USERINFO[playerid][vcolor_2]);
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				ModifyTuneShopTextDraws(playerid, "Color_1:_Black"); 
				vehitem[playerid] = 9;          
			} //black
			case 1: 
			{
				if(USERINFO[playerid][vcolor_1] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), 1, USERINFO[playerid][vcolor_2]);
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				ModifyTuneShopTextDraws(playerid, "Color_1:_White");
				vehitem[playerid] = 10;
			} //white
			case 2: 
			{
				if(USERINFO[playerid][vcolor_1] == 128) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), 128, USERINFO[playerid][vcolor_2]);
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				ModifyTuneShopTextDraws(playerid, "Color_1:_Green");
				vehitem[playerid] = 11;
			} //green
			case 3: 
			{
				if(USERINFO[playerid][vcolor_1] == 135) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), 135, USERINFO[playerid][vcolor_2]);
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				ModifyTuneShopTextDraws(playerid, "Color_1:_Cyan");
				vehitem[playerid] = 12;
			} //cyan
			case 4: 
			{
				if(USERINFO[playerid][vcolor_1] == 152) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), 152, USERINFO[playerid][vcolor_2]);
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				ModifyTuneShopTextDraws(playerid, "Color_1:_Blue");
				vehitem[playerid] = 13;
			} //blue
			case 5: 
			{
				if(USERINFO[playerid][vcolor_1] == 6) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), 6, USERINFO[playerid][vcolor_2]);
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				ModifyTuneShopTextDraws(playerid, "Color_1:_Yellow");
				vehitem[playerid] = 14;
			} //yellow
			case 6: 
			{
				if(USERINFO[playerid][vcolor_1] == 252) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), 252, USERINFO[playerid][vcolor_2]);
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				ModifyTuneShopTextDraws(playerid, "Color_1:_Grey");
				vehitem[playerid] = 15;
			} //grey 
			case 7: 
			{
				if(USERINFO[playerid][vcolor_1] == 146) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), 146, USERINFO[playerid][vcolor_2]);
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				ModifyTuneShopTextDraws(playerid, "Color_1:_Pink");
				vehitem[playerid] = 16;
			} //pink
			case 8: 
			{
				if(USERINFO[playerid][vcolor_1] == 219) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), 219, USERINFO[playerid][vcolor_2]);
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				ModifyTuneShopTextDraws(playerid, "Color_1:_Orange");
				vehitem[playerid] = 17;
			} //orange
			case 9: 
			{
				SetVehicleRealData(playerid);
			}
			case 10: 
			{
				SetVehicleRealData(playerid);
				Dialog_Show(playerid, DIALOG_VEH_MOD_PCOLOR, DIALOG_STYLE_LIST, "LGGW - Vehicle Shop - Colors", "Color 1\nColor 2\n    \nBack", "Select", "Close");
			}
		}
	}
	else
	{
		HideTextDraws(playerid);
		SetVehicleRealData(playerid);
		Dialog_Close(playerid);
	}
	return 1;
}

Dialog:DIALOG_VEH_MOD_COLOR_2(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		HideTextDraws(playerid);
		Dialog_Show(playerid, DIALOG_VEH_MOD_COLOR_2, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Vehicle Shop - Color - Color 2", "Color\tPrice\nBlack\t$150\nWhite\t$150\nGreen\t$150\nCyan\t$150\nBlue\t$150\nYellow\t$150\nGrey\t$150\nPink\t$150\nOrange\t$150\n    \nBack", "Select", "Close");
		switch(listitem)
		{
			case 0:
			{ 
				if(USERINFO[playerid][vcolor_2] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), USERINFO[playerid][vcolor_1], 0);
				ModifyTuneShopTextDraws(playerid, "Color_2:_Black");
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				vehitem[playerid] = 18;

			} //black
			case 1:
			{ 
				if(USERINFO[playerid][vcolor_2] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), USERINFO[playerid][vcolor_1], 1);
				ModifyTuneShopTextDraws(playerid, "Color_2:_White");
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				vehitem[playerid] = 19;
			} //white
			case 2:
			{ 
				if(USERINFO[playerid][vcolor_2] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), USERINFO[playerid][vcolor_1], 128);
				ModifyTuneShopTextDraws(playerid, "Color_2:_Green");
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				vehitem[playerid] = 20;
			} //green
			case 3:
			{
				if(USERINFO[playerid][vcolor_2] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), USERINFO[playerid][vcolor_1], 135);
				ModifyTuneShopTextDraws(playerid, "Color_2:_Cyan");
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				vehitem[playerid] = 21;
			} //cyan
			case 4:
			{ 
				if(USERINFO[playerid][vcolor_2] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), USERINFO[playerid][vcolor_1], 152);
				ModifyTuneShopTextDraws(playerid, "Color_2:_Blue");
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				vehitem[playerid] = 22;
			} //blue
			case 5:
			{ 
				if(USERINFO[playerid][vcolor_2] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), USERINFO[playerid][vcolor_1], 6);
				ModifyTuneShopTextDraws(playerid, "Color_2:_Yellow");
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				vehitem[playerid] = 23;
			} //yellow
			case 6:
			{ 
				if(USERINFO[playerid][vcolor_2] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), USERINFO[playerid][vcolor_1], 252);
				ModifyTuneShopTextDraws(playerid, "Color_2:_Grey");
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				vehitem[playerid] = 24;
			} //grey 
			case 7:
			{ 
				if(USERINFO[playerid][vcolor_2] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), USERINFO[playerid][vcolor_1], 146);
				ModifyTuneShopTextDraws(playerid, "Color_2:_Pink");
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				vehitem[playerid] = 25;
			} //pink
			case 8:
			{ 
				if(USERINFO[playerid][vcolor_2] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this color");
				ChangeVehicleColor(GetPlayerVehicleID(playerid), USERINFO[playerid][vcolor_1], 219);
				ModifyTuneShopTextDraws(playerid, "Color_2:_Orange");
				PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
				vehitem[playerid] = 26;
			} //orange
			case 9: SetVehicleRealData(playerid); 
			case 10:
			{ 
				SetVehicleRealData(playerid);
				Dialog_Show(playerid, DIALOG_VEH_MOD_PCOLOR, DIALOG_STYLE_LIST, "LGGW - Vehicle Shop -  Color", "Color 1\nColor 2\n    \nBack", "Select", "Close");
			}
		}
	}
	else
	{
		HideTextDraws(playerid);
		SetVehicleRealData(playerid);
		Dialog_Close(playerid);
	}
	return 1;
}

Dialog:DIALOG_VEH_MOD_PJOBS(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		HideTextDraws(playerid);
		Dialog_Show(playerid, DIALOG_VEH_MOD_PJOBS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Vehicle Shop - Paint Jobs","Option\tPrice\nAdd Paint Job 1\t$750\nAdd Paint Job 2\t$750\nAdd Paint Job 3\t$750\nRemove Paint Job\tFree\n    \nBack", "Select", "Close");
		switch(listitem)
		{
			case 0: 
			{
				if(USERINFO[playerid][vpjob] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this paintjob");
				ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), 0);
				ModifyTuneShopTextDraws(playerid, "Paint_Job:_type_1");
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				vehitem[playerid] = 27;
			}
			case 1:
			{ 
				if(USERINFO[playerid][vpjob] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this paintjob");
				ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), 1);
				ModifyTuneShopTextDraws(playerid, "Paint_Job:_type_2");
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				vehitem[playerid] = 28;
			}
			case 2: 
			{
				if(USERINFO[playerid][vpjob] == 2) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this paintjob");
				ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), 2);
				ModifyTuneShopTextDraws(playerid, "Paint_Job:_type_3");
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				vehitem[playerid] = 29;
			}
			case 3: 
			{
				if(USERINFO[playerid][vpjob] != 0 && USERINFO[playerid][vpjob] != 1 && USERINFO[playerid][vpjob] != 2) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have any paintjobs to remove");
				ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), 3);
				ModifyTuneShopTextDraws(playerid, "Paint_Job:_Remove");
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				vehitem[playerid] = 30;
			}
			case 4: SetVehicleRealData(playerid);
			case 5: 
			{
				SetVehicleRealData(playerid);
				Dialog_Show(playerid, DIALOG_VEH_MOD_PREVIEW, DIALOG_STYLE_LIST, "LGGW - Vehicle Shop", "Vehicle Colors\nVehicle Paint Jobs\nVehicle Neons\nVehicle Hydraulics\nVehicle Nitro\nVehicle Wheels", "Select", "Close");
			}
		} 
	}
	else
	{
		HideTextDraws(playerid);
		SetVehicleRealData(playerid);
		Dialog_Close(playerid);
	}
	return 1;
}

Dialog:DIALOG_VEH_MOD_NEON(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		HideTextDraws(playerid);
		Dialog_Show(playerid, DIALOG_VEH_MOD_NEON, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Vehicle Shop - Neons", "Option\tPrice\nAdd neon 1\t$3000\nAdd neon 2\t$2000\nRemove All neons\tFree\n    \nBack", "Select", "Close");  
		switch(listitem)
		{
			case 0:
			{
				if(USERINFO[playerid][vneon_1] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this neon");
				if(IsValidObject(editvneon[playerid][0])) DestroyObject(editvneon[playerid][0]);
				if(IsValidObject(editvneon[playerid][1])) DestroyObject(editvneon[playerid][1]);
				if(IsValidObject(editvneon[playerid][2])) DestroyObject(editvneon[playerid][2]); 
				editvneon[playerid][0] = CreateObject(18651,0,0,0,0,0,0);  
				editvneon[playerid][1] = CreateObject(18651,0,0,0,0,0,0);  
				AttachObjectToVehicle(editvneon[playerid][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(editvneon[playerid][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				ModifyTuneShopTextDraws(playerid, "Neon:_type_1");
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				vehitem[playerid] = 31; 
			}
			case 1:
			{
				if(USERINFO[playerid][vneon_2] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this neon");
				if(IsValidObject(editvneon[playerid][0])) DestroyObject(editvneon[playerid][0]);
				if(IsValidObject(editvneon[playerid][1])) DestroyObject(editvneon[playerid][1]);
				if(IsValidObject(editvneon[playerid][2])) DestroyObject(editvneon[playerid][2]);
				editvneon[playerid][2] = CreateObject(18646,0,0,0,0,0,0);
				AttachObjectToVehicle(editvneon[playerid][2], GetPlayerVehicleID(playerid), 0.0, -0.35, 0.90, 0.0, 0.0, 0.0);
				ModifyTuneShopTextDraws(playerid, "Neon:_type_2"); 
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0); 
				vehitem[playerid] = 32;
			}
			case 2:
			{
				if(USERINFO[playerid][vneon_1] == 0 && USERINFO[playerid][vneon_2] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have any neon to remove");
				remneons[playerid] = 1;
				ModifyTuneShopTextDraws(playerid, "Neon:_Remove");
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				if(IsValidObject(vehneon[priveh[playerid]][0])) DestroyObject(vehneon[priveh[playerid]][0]);
				if(IsValidObject(vehneon[priveh[playerid]][1])) DestroyObject(vehneon[priveh[playerid]][1]);
				if(IsValidObject(vehneon[priveh[playerid]][2])) DestroyObject(vehneon[priveh[playerid]][2]); 
				if(IsValidObject(editvneon[playerid][0])) DestroyObject(editvneon[playerid][0]);
				if(IsValidObject(editvneon[playerid][1])) DestroyObject(editvneon[playerid][1]);
				if(IsValidObject(editvneon[playerid][2])) DestroyObject(editvneon[playerid][2]);
				vehitem[playerid] = 33;
			}
			case 3: SetVehicleRealData(playerid);
			case 4:
			{
				SetVehicleRealData(playerid);
				Dialog_Show(playerid, DIALOG_VEH_MOD_PREVIEW, DIALOG_STYLE_LIST, "LGGW - Vehicle Shop", "Vehicle Colors\nVehicle Paint Jobs\nVehicle Neons\nVehicle Hydraulics\nVehicle Nitro\nVehicle Wheels", "Select", "Close");
			}
		}
	}
	else
	{
		HideTextDraws(playerid);
		SetVehicleRealData(playerid);
		Dialog_Close(playerid);
	}
	return 1;
}

Dialog:DIALOG_VEH_MOD_HYDRA(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		HideTextDraws(playerid);
		Dialog_Show(playerid, DIALOG_VEH_MOD_HYDRA, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Vehicle Shop - Hydraulics", "Option\tPrice\nAdd Hydraulics\t$1000\nRemove Hydraulics\tFree\n    \nBack", "Select", "Close");
		switch(listitem)
		{
			case 0: 
			{
				if(USERINFO[playerid][vhydra] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have Hydraulics");
				AddVehicleComponent(GetPlayerVehicleID(playerid), 1087); 
				ModifyTuneShopTextDraws(playerid, "Hydraulics:_Add");
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				vehitem[playerid] = 34;
			}
			case 1:
			{
				if(USERINFO[playerid][vhydra] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have Hydraulics to remove");
				RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1087);
				ModifyTuneShopTextDraws(playerid, "Hydraulics:_Remove");
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				vehitem[playerid] = 35;
			}
			case 2: SetVehicleRealData(playerid);  
			case 3:
			{ 
				SetVehicleRealData(playerid);
				Dialog_Show(playerid, DIALOG_VEH_MOD_PREVIEW, DIALOG_STYLE_LIST, "LGGW - Vehicle Shop", "Vehicle Colors\nVehicle Paint Jobs\nVehicle Neons\nVehicle Hydraulics\nVehicle Nitro\nVehicle Wheels", "Select", "Close");
			} 
		}
	}
	else
	{
		HideTextDraws(playerid);
		SetVehicleRealData(playerid);
		Dialog_Close(playerid);
	}
	return 1;
}

Dialog:DIALOG_VEH_MOD_NITRO(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		HideTextDraws(playerid);
		Dialog_Show(playerid, DIALOG_VEH_MOD_NITRO, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Vehicle Shop - Nitrous", "Option\tPrice\nAdd Nitro x2\t$200\nAdd Nitro x5\t$500\nAdd Nitro x10\t$1000\nRemove Nitro\tFree\n    \nBack", "Select", "Close");
		switch(listitem)
		{
			case 0: 
			{
				if(USERINFO[playerid][vnitro] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have x2 Nitrous");
				AddVehicleComponent(GetPlayerVehicleID(playerid), 1008);
				ModifyTuneShopTextDraws(playerid, "Nitro:_x2");
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				vehitem[playerid] = 36;
			}//nitro x2
			case 1: 
			{
				if(USERINFO[playerid][vnitro] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have x5 Nitrous");
				AddVehicleComponent(GetPlayerVehicleID(playerid), 1009);
				ModifyTuneShopTextDraws(playerid, "Nitro:_x5");
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				vehitem[playerid] = 37;
			}//nitro x5
			case 2: 
			{
				if(USERINFO[playerid][vnitro] == 2) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have x10 Nitrous");
				AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
				ModifyTuneShopTextDraws(playerid, "Nitro:_x10");
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				vehitem[playerid] = 38;
			}//nitro x10
			case 3: //remove nitro
			{
				if(USERINFO[playerid][vnitro] != 0 && USERINFO[playerid][vnitro] != 1 && USERINFO[playerid][vnitro] != 2) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have any type of nitro to remove");
				RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1008); 
				RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1009);
				RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1010);
				ModifyTuneShopTextDraws(playerid, "Nitro:_Remove");
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				vehitem[playerid] = 39;
			}
			case 4: SetVehicleRealData(playerid);
			case 5: 
			{
				SetVehicleRealData(playerid);
				Dialog_Show(playerid, DIALOG_VEH_MOD_PREVIEW, DIALOG_STYLE_LIST, "LGGW - Vehicle Shop", "Vehicle Colors\nVehicle Paint Jobs\nVehicle Neons\nVehicle Hydraulics\nVehicle Nitro\nVehicle Wheels", "Select", "Close");   
			}
		}
	}
	else
	{
		HideTextDraws(playerid);
		SetVehicleRealData(playerid);
		Dialog_Close(playerid);
	}
	return 1;
}

Dialog:DIALOG_VEH_MOD_WHEEL(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		HideTextDraws(playerid);
		Dialog_Show(playerid, DIALOG_VEH_MOD_WHEEL, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Vehicle Shop - Wheels", "Wheel type\tPrice\nShadow\t$350\nMega\t$350\nRinshine\t$350\nWires\t$350\nClassic\t$350\nTwist\t$350\nCutter\t$350\nDollar\t$350\nAtomic\t$350\n    \nBack", "Select", "Close");
		switch(listitem)
		{
			case 0:
			{
				if(USERINFO[playerid][vwheel] == 1073) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this wheel type");
				ModifyTuneShopTextDraws(playerid, "Wheel:_Shadow");
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				vehitem[playerid] = 40;
				AddVehicleComponent(GetPlayerVehicleID(playerid), 1073);
			} //shadow
			case 1: 
			{
				if(USERINFO[playerid][vwheel] == 1074) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this wheel type");
				ModifyTuneShopTextDraws(playerid, "Wheel:_Mega");
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				vehitem[playerid] = 41;
				AddVehicleComponent(GetPlayerVehicleID(playerid), 1074);
			} //mega
			case 2: 
			{
				if(USERINFO[playerid][vwheel] == 1075) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this wheel type");
				ModifyTuneShopTextDraws(playerid, "Wheel:_Rinshine");
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				vehitem[playerid] = 42;
				AddVehicleComponent(GetPlayerVehicleID(playerid), 1075);
			} //rinshine
			case 3: 
			{
				if(USERINFO[playerid][vwheel] == 1076) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this wheel type");
				ModifyTuneShopTextDraws(playerid, "Wheel:_Wires");
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				vehitem[playerid] = 43;
				AddVehicleComponent(GetPlayerVehicleID(playerid), 1076);
			} //wires
			case 4: 
			{
				if(USERINFO[playerid][vwheel] == 1077) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this wheel type");
				ModifyTuneShopTextDraws(playerid, "Wheel:_Classic");
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				vehitem[playerid] = 44;
				AddVehicleComponent(GetPlayerVehicleID(playerid), 1077);

			} //classic
			case 5: 
			{
				if(USERINFO[playerid][vwheel] == 1078) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this wheel type");
				ModifyTuneShopTextDraws(playerid, "Wheel:_Twist");
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				vehitem[playerid] = 45;

				AddVehicleComponent(GetPlayerVehicleID(playerid), 1078);
			} //twist
			case 6: 
			{
				if(USERINFO[playerid][vwheel] == 1079) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this wheel type");
				ModifyTuneShopTextDraws(playerid, "Wheel:_Cutter");
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				vehitem[playerid] = 46;
				AddVehicleComponent(GetPlayerVehicleID(playerid), 1079);
			} //cutter
			case 7: 
			{
				if(USERINFO[playerid][vwheel] == 1083) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this wheel type");
				ModifyTuneShopTextDraws(playerid, "Wheel:_Dollar");
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				vehitem[playerid] = 47;
				AddVehicleComponent(GetPlayerVehicleID(playerid), 1083);
			} //dollar
			case 8: 
			{
				if(USERINFO[playerid][vwheel] == 1085) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this wheel type");
				ModifyTuneShopTextDraws(playerid, "Wheel:_Atomic");
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				vehitem[playerid] = 48;
				AddVehicleComponent(GetPlayerVehicleID(playerid), 1085);
			} //atomic
			case 9: SetVehicleRealData(playerid);
			case 10:
			{ 
				SetVehicleRealData(playerid);
				Dialog_Show(playerid, DIALOG_VEH_MOD_PREVIEW, DIALOG_STYLE_LIST, "LGGW - Vehicle Shop", "Vehicle Colors\nVehicle Paint Jobs\nVehicle Neons\nVehicle Hydraulics\nVehicle Nitro\nVehicle Wheels", "Select", "Close");
			}
		}
	}
	else
	{
		HideTextDraws(playerid);
		SetVehicleRealData(playerid);
		Dialog_Close(playerid);
	}
	return 1;
}

Dialog:DIALOG_SELL_HOUSE(playerid, response, listitem, inputtext[])
{
	if(!response) return Dialog_Close(playerid);
	if(response)
	{
		new id = USERINFO[playerid][gid];
		Delete3DTextLabel(hlabel[GANGINFO[id][ghouseid]]);
		hlabel[GANGINFO[id][ghouseid]] = Create3DTextLabel("{FF6347}[Head Qauters]\n* Unowned", -1, HOUSEINFO[GANGINFO[id][ghouseid]][entercp][0], HOUSEINFO[GANGINFO[id][ghouseid]][entercp][1], HOUSEINFO[GANGINFO[id][ghouseid]][entercp][2], 50.0, 0, 0);
		DestroyDynamicMapIcon(HOUSEINFO[GANGINFO[id][ghouseid]][icon_id]);  
		HOUSEINFO[GANGINFO[id][ghouseid]][icon_id] = CreateDynamicMapIcon(HOUSEINFO[GANGINFO[id][ghouseid]][entercp][0], HOUSEINFO[GANGINFO[id][ghouseid]][entercp][1], HOUSEINFO[GANGINFO[id][ghouseid]][entercp][2], 31, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
		SendClientMessage(playerid, -1, "{6800b3}[ Gang ] {9370DB}You sold the Gang House");
		GANGINFO[id][ghouse] = 0;
		HOUSEINFO[GANGINFO[id][ghouseid]][howned] = 0;
	}
	return 1;
}

Dialog:DIALOG_BUY_HOUSE(playerid, response, listitem, inputtext[])
{
	if(!response) return Dialog_Close(playerid);
	if(response)
	{
		new id = -1;
		for(new i = 0; i < sizeof(HOUSEINFO); i++) if(IsPlayerInDynamicCP(playerid, STREAMER_TAG_CP GENTERCP[i])) id = i;
		if(isequal(inputtext, "1"))
		{
			SetPlayerPos(playerid, HOUSEINFO[id][enterpos][0], HOUSEINFO[id][enterpos][1], HOUSEINFO[id][enterpos][2]);
			SetPlayerFacingAngle(playerid, HOUSEINFO[id][enterpos][3]);
			SetPlayerInterior(playerid, HOUSEINFO[id][hintid]);
			SetPlayerVirtualWorld(playerid, playerid + 1);
		}
		else if(isequal(inputtext, "2"))
		{
			new i = id;
			if(HOUSEINFO[i][howned] == 1 &&  GANGINFO[HOUSEINFO[i][hteamid]][gscore] >= GANGINFO[USERINFO[playerid][gid]][gscore]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}This house is owned by a gang that has a higher score than your gang (use \"/top\" and select \"Top Gangs\" to view gang ranks)");
			else if(GetPlayerMoney(playerid) < HOUSEINFO[i][hprice]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
			else
			{
				if(HOUSEINFO[i][howned] == 1) GANGINFO[HOUSEINFO[i][hteamid]][ghouse] = 0;
	 
				GivePlayerCash(playerid, -HOUSEINFO[i][hprice]);
				SendClientMessage(playerid, -1, "{6800b3}[ Gang ] {9370DB}You bought a new Gang House");
				HOUSEINFO[i][howned] = 1;
				HOUSEINFO[i][hteamid] = USERINFO[playerid][gid];

				new str[50];
				format(str, sizeof(str), "[Head Qauters]\n%s", ReplaceUwithS(GANGINFO[HOUSEINFO[i][hteamid]][gname]));
	 
				Delete3DTextLabel(hlabel[i]);
				hlabel[i] = Create3DTextLabel(str, GANGINFO[HOUSEINFO[i][hteamid]][gcolor], HOUSEINFO[i][entercp][0], HOUSEINFO[i][entercp][1], HOUSEINFO[i][entercp][2], 50.0, 0, 0);
	 
				GANGINFO[USERINFO[playerid][gid]][ghouse] = 1;
				GANGINFO[USERINFO[playerid][gid]][ghouseid] = i;
				  
				DestroyDynamicMapIcon(HOUSEINFO[i][icon_id]);  
				HOUSEINFO[i][icon_id] = CreateDynamicMapIcon(HOUSEINFO[i][entercp][0], HOUSEINFO[i][entercp][1], HOUSEINFO[i][entercp][2], 32, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
			}
		}
		else
		{
			new str[1024], dialog[1024];
			strcat(str, "                 Gang House - %d                \n\n");
			strcat(str, "* You can select options by entering option IDs \n");
			strcat(str, "* Use \"preview\" to ensure this is the house you \n");
			strcat(str, "  want                                          \n");
			strcat(str, "* Check out the price before purchase           \n");
			strcat(str, "* You will recieve only half of the price if you\n");
			strcat(str, "  sell this house after purchase                \n");
			strcat(str, "------------------------------------------------\n");
			strcat(str, "- Interior type: %s                             \n");
			strcat(str, "- Exterior type: %s                             \n");
			strcat(str, "- Price: $%d                                    \n");
			strcat(str, "------------------------------------------------\n");
			strcat(str, "  ID                        Option              \n");
			strcat(str, "  1                         Preview             \n"); 
			strcat(str, "  2                         Purchase            \n");
			strcat(str, "[ Note ] Purchasing action is irreversable      \n");
			format(dialog, sizeof(dialog), str, id, HOUSEINFO[id][hinttype], HOUSEINFO[id][hextype], HOUSEINFO[id][hprice]);
			Dialog_Show(playerid, DIALOG_SELL_HOUSE, DIALOG_STYLE_MSGBOX, "LGGW - Gang House Info & Options", dialog, "Enter", "Close");
			return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid selection");
		}
	}
	return 1;
}

Dialog:DIALOG_AFUNCS(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new str[1024];
		if(USERINFO[playerid][plevel] == 1)
		{
			if(af_page[playerid] == 1)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/veh\t/veh <id> [color 1] [color 2]\tSpawn a vehicle with the given model id\n", sizeof(str));  
				strcat(str,"/a1\t/a1 <text>\tAdmin chat for level 1 and above\n", sizeof(str));    
				strcat(str,"/repair\tNone\tRepair the vehicle you are in\n", sizeof(str)); 
				strcat(str,"/goto\t/goto <id>\tTeleports to a given player's position\n", sizeof(str)); 
				strcat(str,"/mute\t/mute <id>\tDisable chatting for a given player\n", sizeof(str)); 
				strcat(str,"/unmute\t/unmute <id>\tEnable chatting for a given player\n", sizeof(str)); 
				strcat(str,"/getip\t/getip <id> \tShows the current connected ip of a given player\n", sizeof(str));
				strcat(str,"/getips\t/getips <id>\tShows the all connected ips of a player", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Back", "Close");
				af_page[playerid] = 2;
			}
			else if(af_page[playerid] == 2)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"<...> --> Essential parameter\n", sizeof(str));
				strcat(str,"[...] --> Optional parameter\n\n", sizeof(str));
				strcat(str,"/acmds\tNone\tShows all the Admin commands which you can use\n", sizeof(str));
				strcat(str,"/afuncs\tNone\tShows all the functions related to admin commands\n", sizeof(str));
				strcat(str,"/onduty\tNone\tPuts you on Admin mode\n", sizeof(str)); 
				strcat(str,"/offduty\tNone\tPuts you on Player mode\n", sizeof(str));  
				strcat(str,"/a\t/a <text>\tSend message to players as an Admin\n", sizeof(str));
				strcat(str,"/spawn\t/spawn <id>\tSpawn a given player\n", sizeof(str));  
				strcat(str,"/warn\t/warn <id>\tWarns a given player\n", sizeof(str));
				strcat(str,"/sgg\tNone\tStart the Gun Game\n", sizeof(str)); 
				strcat(str,"/clearchat(cc)\tNone\tClear everyone's chat", sizeof(str)); 
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Close");
				af_page[playerid] = 1;
			}
		}
		else if(USERINFO[playerid][plevel] == 2)
		{
			if(af_page[playerid] == 1)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/veh\t/veh <id> [color 1] [color 2]\tSpawn a vehicle with the given model id\n", sizeof(str));  
				strcat(str,"/a1\t/a1 <text>\tAdmin chat for level 1 and above\n", sizeof(str));    
				strcat(str,"/repair\tNone\tRepair the vehicle you are in\n", sizeof(str)); 
				strcat(str,"/goto\t/goto <id>\tTeleports to a given player's position\n", sizeof(str)); 
				strcat(str,"/mute\t/mute <id>\tDisable chatting for a given player\n", sizeof(str)); 
				strcat(str,"/unmute\t/unmute <id>\tEnable chatting for a given player\n", sizeof(str)); 
				strcat(str,"/getip\t/getip <id> \tShows the current connected ip of a given player\n", sizeof(str));
				strcat(str,"/getips\t/getips <id>\tShows the all connected ips of a player", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Back");
				af_page[playerid] = 2;
			}
			else if(af_page[playerid] == 2)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/kick\t/kick <id>\tKicks a given player\n", sizeof(str));  
				strcat(str,"/akill\t/akill <name>\tKills a given player\n", sizeof(str)); 
				strcat(str,"/get\t/get <id>\tTeleports a given player to you\n", sizeof(str)); 
				strcat(str,"/sethealth\t/sethealth <id> <amount>\tSets the given player's health to a given amount\n", sizeof(str));
				strcat(str,"/setarmour\t/setarmour <id> <amount>\tSets the given player's armour to  given amount\n", sizeof(str));  
				strcat(str,"/givegun\t/givegun <id> <weaponid> <ammo>\tGive a specified gun to a given player with the\n", sizeof(str)); 
				strcat(str," \t \tspecified amount of ammo\n", sizeof(str));
				strcat(str,"/jail\t/jail <id> <minutes>\tPuts a given player in jail\n", sizeof(str)); 
				strcat(str,"/unjail\t/unjail <id>\tRemoves a given player from jail\n", sizeof(str));
				strcat(str,"/a2\t/a2 <text>\tAdmin chat for level 2 and above\n", sizeof(str));  
				strcat(str,"/agivecash\t/agivecash <id> <amount>\tGive cash for players\n", sizeof(str));
				strcat(str,"/fine\t/fine <id> <amount>\tGive fines for breaking rules", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Back", "Close");
				af_page[playerid] = 3;
			}
			else if(af_page[playerid] == 3)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/veh\t/veh <id> [color 1] [color 2]\tSpawn a vehicle with the given model id\n", sizeof(str));  
				strcat(str,"/a1\t/a1 <text>\tAdmin chat for level 1 and above\n", sizeof(str));    
				strcat(str,"/repair\tNone\tRepair the vehicle you are in\n", sizeof(str)); 
				strcat(str,"/goto\t/goto <id>\tTeleports to a given player's position\n", sizeof(str)); 
				strcat(str,"/mute\t/mute <id>\tDisable chatting for a given player\n", sizeof(str)); 
				strcat(str,"/unmute\t/unmute <id>\tEnable chatting for a given player\n", sizeof(str)); 
				strcat(str,"/getip\t/getip <id> \tShows the current connected ip of a given player\n", sizeof(str));
				strcat(str,"/getips\t/getips <id>\tShows the all connected ips of a player", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Back");
				af_page[playerid] = 2;
			}
		}
		else if(USERINFO[playerid][plevel] == 3)
		{
			if(af_page[playerid] == 1)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/veh\t/veh <id> [color 1] [color 2]\tSpawn a vehicle with the given model id\n", sizeof(str));  
				strcat(str,"/a1\t/a1 <text>\tAdmin chat for level 1 and above\n", sizeof(str));    
				strcat(str,"/repair\tNone\tRepair the vehicle you are in\n", sizeof(str)); 
				strcat(str,"/goto\t/goto <id>\tTeleports to a given player's position\n", sizeof(str)); 
				strcat(str,"/mute\t/mute <id>\tDisable chatting for a given player\n", sizeof(str)); 
				strcat(str,"/unmute\t/unmute <id>\tEnable chatting for a given player\n", sizeof(str)); 
				strcat(str,"/getip\t/getip <id> \tShows the current connected ip of a given player\n", sizeof(str));
				strcat(str,"/getips\t/getips <id>\tShows the all connected ips of a player", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Back");
				af_page[playerid] = 2;
			}
			else if(af_page[playerid] == 2)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/kick\t/kick <id>\tKicks a given player\n", sizeof(str));  
				strcat(str,"/akill\t/akill <name>\tKills a given player\n", sizeof(str)); 
				strcat(str,"/get\t/get <id>\tTeleports a given player to you\n", sizeof(str)); 
				strcat(str,"/sethealth\t/sethealth <id> <amount>\tSets the given player's health to a given amount\n", sizeof(str));
				strcat(str,"/setarmour\t/setarmour <id> <amount>\tSets the given player's armour to  given amount\n", sizeof(str));  
				strcat(str,"/givegun\t/givegun <id> <weaponid> <ammo>\tGive a specified gun to a given player with the\n", sizeof(str)); 
				strcat(str," \t \tspecified amount of ammo\n", sizeof(str));
				strcat(str,"/jail\t/jail <id> <minutes>\tPuts a given player in jail\n", sizeof(str)); 
				strcat(str,"/unjail\t/unjail <id>\tRemoves a given player from jail\n", sizeof(str));
				strcat(str,"/a2\t/a2 <text>\tAdmin chat for level 2 and above\n", sizeof(str));  
				strcat(str,"/agivecash\t/agivecash <id> <amount>\tGive cash for players\n", sizeof(str));
				strcat(str,"/fine\t/fine <id> <amount>\tGive fines for breaking rules", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Back");
				af_page[playerid] = 3;
			}
			else if(af_page[playerid] == 3)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/setkills\t/setkills <id> <kills>\tSets the kill amount of a given player\n", sizeof(str)); 
				strcat(str,"/setdeaths\t/setdeaths <id> <deaths>\tSets the death amount of a given player\n", sizeof(str)); 
				strcat(str,"/setpass\t/setpass <id> <password>\tResets the password of a player to a given one\n", sizeof(str));
				strcat(str,"/ban\t/ban <id>\tBans a given online player\n", sizeof(str)); 
				strcat(str,"/oban\t/oban <name>\tBans a given offline player\n", sizeof(str)); 
				strcat(str,"/unban\t/unban <name>\tUnbans a banned player\n", sizeof(str));
				strcat(str,"/readlogs\tNone\tRead server logs\n", sizeof(str));
				strcat(str,"/a3\t/a3 <text>\tAdmin chat for level 3 and above\n", sizeof(str));
				strcat(str,"/blockcmds\t/blockcmds <id>\tBlocks all the server commands for a given player\n", sizeof(str));
				strcat(str,"/unblockcmds\t/unblockcmds <id>\tUnblocks all the server commands for a given player\n", sizeof(str));
				strcat(str,"/fexitmg\t/fexitmg <id>\tForce a given player to exit Minigame\n", sizeof(str)); 
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Back", "Close");
				af_page[playerid] = 4;
			}
			else if(af_page[playerid] == 4)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/kick\t/kick <id>\tKicks a given player\n", sizeof(str));  
				strcat(str,"/akill\t/akill <name>\tKills a given player\n", sizeof(str)); 
				strcat(str,"/get\t/get <id>\tTeleports a given player to you\n", sizeof(str)); 
				strcat(str,"/sethealth\t/sethealth <id> <amount>\tSets the given player's health to a given amount\n", sizeof(str));
				strcat(str,"/setarmour\t/setarmour <id> <amount>\tSets the given player's armour to  given amount\n", sizeof(str));  
				strcat(str,"/givegun\t/givegun <id> <weaponid> <ammo>\tGive a specified gun to a given player with the\n", sizeof(str)); 
				strcat(str," \t \tspecified amount of ammo\n", sizeof(str));
				strcat(str,"/jail\t/jail <id> <minutes>\tPuts a given player in jail\n", sizeof(str)); 
				strcat(str,"/unjail\t/unjail <id>\tRemoves a given player from jail\n", sizeof(str));
				strcat(str,"/a2\t/a2 <text>\tAdmin chat for level 2 and above\n", sizeof(str));  
				strcat(str,"/agivecash\t/agivecash <id> <amount>\tGive cash for players\n", sizeof(str));
				strcat(str,"/fine\t/fine <id> <amount>\tGive fines for breaking rules", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Back");
				af_page[playerid] = 3;
			}
		}
		else if(USERINFO[playerid][plevel] == 4)
		{
			if(af_page[playerid] == 1)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/veh\t/veh <id> [color 1] [color 2]\tSpawn a vehicle with the given model id\n", sizeof(str));  
				strcat(str,"/a1\t/a1 <text>\tAdmin chat for level 1 and above\n", sizeof(str));    
				strcat(str,"/repair\tNone\tRepair the vehicle you are in\n", sizeof(str)); 
				strcat(str,"/goto\t/goto <id>\tTeleports to a given player's position\n", sizeof(str)); 
				strcat(str,"/mute\t/mute <id>\tDisable chatting for a given player\n", sizeof(str)); 
				strcat(str,"/unmute\t/unmute <id>\tEnable chatting for a given player\n", sizeof(str)); 
				strcat(str,"/getip\t/getip <id> \tShows the current connected ip of a given player\n", sizeof(str));
				strcat(str,"/getips\t/getips <id>\tShows the all connected ips of a player", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Back");
				af_page[playerid] = 2;
			}
			else if(af_page[playerid] == 2)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/kick\t/kick <id>\tKicks a given player\n", sizeof(str));  
				strcat(str,"/akill\t/akill <name>\tKills a given player\n", sizeof(str)); 
				strcat(str,"/get\t/get <id>\tTeleports a given player to you\n", sizeof(str)); 
				strcat(str,"/sethealth\t/sethealth <id> <amount>\tSets the given player's health to a given amount\n", sizeof(str));
				strcat(str,"/setarmour\t/setarmour <id> <amount>\tSets the given player's armour to  given amount\n", sizeof(str));  
				strcat(str,"/givegun\t/givegun <id> <weaponid> <ammo>\tGive a specified gun to a given player with the\n", sizeof(str)); 
				strcat(str," \t \tspecified amount of ammo\n", sizeof(str));
				strcat(str,"/jail\t/jail <id> <minutes>\tPuts a given player in jail\n", sizeof(str)); 
				strcat(str,"/unjail\t/unjail <id>\tRemoves a given player from jail\n", sizeof(str));
				strcat(str,"/a2\t/a2 <text>\tAdmin chat for level 2 and above\n", sizeof(str));  
				strcat(str,"/agivecash\t/agivecash <id> <amount>\tGive cash for players\n", sizeof(str));
				strcat(str,"/fine\t/fine <id> <amount>\tGive fines for breaking rules", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Back");
				af_page[playerid] = 3;
			}
			else if(af_page[playerid] == 3)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/setkills\t/setkills <id> <kills>\tSets the kill amount of a given player\n", sizeof(str)); 
				strcat(str,"/setdeaths\t/setdeaths <id> <deaths>\tSets the death amount of a given player\n", sizeof(str)); 
				strcat(str,"/setpass\t/setpass <id> <password>\tResets the password of a player to a given one\n", sizeof(str));
				strcat(str,"/ban\t/ban <id>\tBans a given online player\n", sizeof(str)); 
				strcat(str,"/oban\t/oban <name>\tBans a given offline player\n", sizeof(str)); 
				strcat(str,"/unban\t/unban <name>\tUnbans a banned player\n", sizeof(str));
				strcat(str,"/readlogs\tNone\tRead server logs\n", sizeof(str));
				strcat(str,"/a3\t/a3 <text>\tAdmin chat for level 3 and above\n", sizeof(str));
				strcat(str,"/blockcmds\t/blockcmds <id>\tBlocks all the server commands for a given player\n", sizeof(str));
				strcat(str,"/unblockcmds\t/unblockcmds <id>\tUnblocks all the server commands for a given player\n", sizeof(str));
				strcat(str,"/fexitmg\t/fexitmg <id>\tForce a given player to exit Minigame\n", sizeof(str)); 
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Back");
				af_page[playerid] = 4;
			}
			else if(af_page[playerid] == 4)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/setlevel\t/setlevel <id>\tSets the level of a given player\n", sizeof(str));  
				strcat(str,"/spawnall\tNone\tSpawn all the online players\n", sizeof(str)); 
				strcat(str,"/killall\tNone\tKill all the online players\n", sizeof(str)); 
				strcat(str,"/givepriveh\t/givepriveh <name>\tGive a private vehicle to a player\n", sizeof(str)); 
				strcat(str,"/a4\t/a4 <text>\tAdmin chat for level 4 and above", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Back", "Close");
				af_page[playerid] = 5;
			}
			else if(af_page[playerid] == 5)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/setkills\t/setkills <id> <kills>\tSets the kill amount of a given player\n", sizeof(str)); 
				strcat(str,"/setdeaths\t/setdeaths <id> <deaths>\tSets the death amount of a given player\n", sizeof(str)); 
				strcat(str,"/setpass\t/setpass <id> <password>\tResets the password of a player to a given one\n", sizeof(str));
				strcat(str,"/ban\t/ban <id>\tBans a given online player\n", sizeof(str)); 
				strcat(str,"/oban\t/oban <name>\tBans a given offline player\n", sizeof(str)); 
				strcat(str,"/unban\t/unban <name>\tUnbans a banned player\n", sizeof(str));
				strcat(str,"/readlogs\tNone\tRead server logs\n", sizeof(str));
				strcat(str,"/a3\t/a3 <text>\tAdmin chat for level 3 and above\n", sizeof(str));
				strcat(str,"/blockcmds\t/blockcmds <id>\tBlocks all the server commands for a given player\n", sizeof(str));
				strcat(str,"/unblockcmds\t/unblockcmds <id>\tUnblocks all the server commands for a given player\n", sizeof(str));
				strcat(str,"/fexitmg\t/fexitmg <id>\tForce a given player to exit Minigame\n", sizeof(str)); 
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Back");
				af_page[playerid] = 4;
			}
		}
		else if(USERINFO[playerid][plevel] == 5)
		{
			if(af_page[playerid] == 1)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/veh\t/veh <id> [color 1] [color 2]\tSpawn a vehicle with the given model id\n", sizeof(str));  
				strcat(str,"/a1\t/a1 <text>\tAdmin chat for level 1 and above\n", sizeof(str));    
				strcat(str,"/repair\tNone\tRepair the vehicle you are in\n", sizeof(str)); 
				strcat(str,"/goto\t/goto <id>\tTeleports to a given player's position\n", sizeof(str)); 
				strcat(str,"/mute\t/mute <id>\tDisable chatting for a given player\n", sizeof(str)); 
				strcat(str,"/unmute\t/unmute <id>\tEnable chatting for a given player\n", sizeof(str)); 
				strcat(str,"/getip\t/getip <id> \tShows the current connected ip of a given player\n", sizeof(str));
				strcat(str,"/getips\t/getips <id>\tShows the all connected ips of a player", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Back");
				af_page[playerid] = 2;
			}
			else if(af_page[playerid] == 2)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/kick\t/kick <id>\tKicks a given player\n", sizeof(str));  
				strcat(str,"/akill\t/akill <name>\tKills a given player\n", sizeof(str)); 
				strcat(str,"/get\t/get <id>\tTeleports a given player to you\n", sizeof(str)); 
				strcat(str,"/sethealth\t/sethealth <id> <amount>\tSets the given player's health to a given amount\n", sizeof(str));
				strcat(str,"/setarmour\t/setarmour <id> <amount>\tSets the given player's armour to  given amount\n", sizeof(str));  
				strcat(str,"/givegun\t/givegun <id> <weaponid> <ammo>\tGive a specified gun to a given player with the\n", sizeof(str)); 
				strcat(str," \t \tspecified amount of ammo\n", sizeof(str));
				strcat(str,"/jail\t/jail <id> <minutes>\tPuts a given player in jail\n", sizeof(str)); 
				strcat(str,"/unjail\t/unjail <id>\tRemoves a given player from jail\n", sizeof(str));
				strcat(str,"/a2\t/a2 <text>\tAdmin chat for level 2 and above\n", sizeof(str));  
				strcat(str,"/agivecash\t/agivecash <id> <amount>\tGive cash for players\n", sizeof(str));
				strcat(str,"/fine\t/fine <id> <amount>\tGive fines for breaking rules", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Back");
				af_page[playerid] = 3;
			}
			else if(af_page[playerid] == 3)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/setkills\t/setkills <id> <kills>\tSets the kill amount of a given player\n", sizeof(str)); 
				strcat(str,"/setdeaths\t/setdeaths <id> <deaths>\tSets the death amount of a given player\n", sizeof(str)); 
				strcat(str,"/setpass\t/setpass <id> <password>\tResets the password of a player to a given one\n", sizeof(str));
				strcat(str,"/ban\t/ban <id>\tBans a given online player\n", sizeof(str)); 
				strcat(str,"/oban\t/oban <name>\tBans a given offline player\n", sizeof(str)); 
				strcat(str,"/unban\t/unban <name>\tUnbans a banned player\n", sizeof(str));
				strcat(str,"/readlogs\tNone\tRead server logs\n", sizeof(str));
				strcat(str,"/a3\t/a3 <text>\tAdmin chat for level 3 and above\n", sizeof(str));
				strcat(str,"/blockcmds\t/blockcmds <id>\tBlocks all the server commands for a given player\n", sizeof(str));
				strcat(str,"/unblockcmds\t/unblockcmds <id>\tUnblocks all the server commands for a given player\n", sizeof(str));
				strcat(str,"/fexitmg\t/fexitmg <id>\tForce a given player to exit Minigame\n", sizeof(str)); 
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Back");
				af_page[playerid] = 4;
			}
			else if(af_page[playerid] == 4)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/setlevel\t/setlevel <id>\tSets the level of a given player\n", sizeof(str));  
				strcat(str,"/spawnall\tNone\tSpawn all the online players\n", sizeof(str)); 
				strcat(str,"/killall\tNone\tKill all the online players\n", sizeof(str)); 
				strcat(str,"/givepriveh\t/givepriveh <name>\tGive a private vehicle to a player\n", sizeof(str)); 
				strcat(str,"/a4\t/a4 <text>\tAdmin chat for level 4 and above", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Back");
				af_page[playerid] = 5;
			}
			else if(af_page[playerid] == 5)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/a5\t/a5 <text>\tAdmin chat for level 5 Admins", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Back", "Close");
				af_page[playerid] = 6;
			}
			else if(af_page[playerid] == 6)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/setlevel\t/setlevel <id>\tSets the level of a given player\n", sizeof(str));  
				strcat(str,"/spawnall\tNone\tSpawn all the online players\n", sizeof(str)); 
				strcat(str,"/killall\tNone\tKill all the online players\n", sizeof(str)); 
				strcat(str,"/givepriveh\t/givepriveh <name>\tGive a private vehicle to a player\n", sizeof(str)); 
				strcat(str,"/a4\t/a4 <text>\tAdmin chat for level 4 and above", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Back");
				af_page[playerid] = 5;
			} 
		}
	}
	else
	{
		new str[1024];
		if(USERINFO[playerid][plevel] == 1)
		{
			return Dialog_Close(playerid);
		}
		else if(USERINFO[playerid][plevel] == 2)
		{
			if(af_page[playerid] == 1)
			{
				return Dialog_Close(playerid);
			}
			else if(af_page[playerid] == 2)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"<...> --> Essential parameter\n", sizeof(str));
				strcat(str,"[...] --> Optional parameter\n\n", sizeof(str));
				strcat(str,"/acmds\tNone\tShows all the Admin commands which you can use\n", sizeof(str));
				strcat(str,"/afuncs\tNone\tShows all the functions related to admin commands\n", sizeof(str));
				strcat(str,"/onduty\tNone\tPuts you on Admin mode\n", sizeof(str)); 
				strcat(str,"/offduty\tNone\tPuts you on Player mode\n", sizeof(str));  
				strcat(str,"/a\t/a <text>\tSend message to players as an Admin\n", sizeof(str));
				strcat(str,"/spawn\t/spawn <id>\tSpawn a given player\n", sizeof(str));  
				strcat(str,"/warn\t/warn <id>\tWarns a given player\n", sizeof(str));
				strcat(str,"/sgg\tNone\tStart the Gun Game\n", sizeof(str)); 
				strcat(str,"/clearchat(cc)\tNone\tClear everyone's chat", sizeof(str));  
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Close");
				af_page[playerid] = 1;
			}
			else if(af_page[playerid] == 3)
			{
				return Dialog_Close(playerid);
			}
		}
		else if(USERINFO[playerid][plevel] == 3)
		{
			if(af_page[playerid] == 1) 
			{
				return Dialog_Close(playerid);
			}
			else if(af_page[playerid] == 2)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"<...> --> Essential parameter\n", sizeof(str));
				strcat(str,"[...] --> Optional parameter\n\n", sizeof(str));
				strcat(str,"/acmds\tNone\tShows all the Admin commands which you can use\n", sizeof(str));
				strcat(str,"/afuncs\tNone\tShows all the functions related to admin commands\n", sizeof(str));
				strcat(str,"/onduty\tNone\tPuts you on Admin mode\n", sizeof(str)); 
				strcat(str,"/offduty\tNone\tPuts you on Player mode\n", sizeof(str));  
				strcat(str,"/a\t/a <text>\tSend message to players as an Admin\n", sizeof(str));
				strcat(str,"/spawn\t/spawn <id>\tSpawn a given player\n", sizeof(str));  
				strcat(str,"/warn\t/warn <id>\tWarns a given player\n", sizeof(str));
				strcat(str,"/sgg\tNone\tStart the Gun Game\n", sizeof(str)); 
				strcat(str,"/clearchat(cc)\tNone\tClear everyone's chat", sizeof(str)); 
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Close");
				af_page[playerid] = 1;
			}
			else if(af_page[playerid] == 3)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/veh\t/veh <id> [color 1] [color 2]\tSpawn a vehicle with the given model id\n", sizeof(str));  
				strcat(str,"/a1\t/a1 <text>\tAdmin chat for level 1 and above\n", sizeof(str));    
				strcat(str,"/repair\tNone\tRepair the vehicle you are in\n", sizeof(str)); 
				strcat(str,"/goto\t/goto <id>\tTeleports to a given player's position\n", sizeof(str)); 
				strcat(str,"/mute\t/mute <id>\tDisable chatting for a given player\n", sizeof(str)); 
				strcat(str,"/unmute\t/unmute <id>\tEnable chatting for a given player\n", sizeof(str)); 
				strcat(str,"/getip\t/getip <id> \tShows the current connected ip of a given player\n", sizeof(str));
				strcat(str,"/getips\t/getips <id>\tShows the all connected ips of a player", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Back");
				af_page[playerid] = 2;
			}
			else if(af_page[playerid] == 4)
			{
				return Dialog_Close(playerid);
			}
		}
		else if(USERINFO[playerid][plevel] == 4)
		{
			if(af_page[playerid] == 1) 
			{
				return Dialog_Close(playerid);
			}
			else if(af_page[playerid] == 2)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"<...> --> Essential parameter\n", sizeof(str));
				strcat(str,"[...] --> Optional parameter\n\n", sizeof(str));
				strcat(str,"/acmds\tNone\tShows all the Admin commands which you can use\n", sizeof(str));
				strcat(str,"/afuncs\tNone\tShows all the functions related to admin commands\n", sizeof(str));
				strcat(str,"/onduty\tNone\tPuts you on Admin mode\n", sizeof(str)); 
				strcat(str,"/offduty\tNone\tPuts you on Player mode\n", sizeof(str));  
				strcat(str,"/a\t/a <text>\tSend message to players as an Admin\n", sizeof(str));
				strcat(str,"/spawn\t/spawn <id>\tSpawn a given player\n", sizeof(str));  
				strcat(str,"/warn\t/warn <id>\tWarns a given player\n", sizeof(str));
				strcat(str,"/sgg\tNone\tStart the Gun Game\n", sizeof(str)); 
				strcat(str,"/clearchat(cc)\tNone\tClear everyone's chat", sizeof(str)); 
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Close");
				af_page[playerid] = 1;
			}
			else if(af_page[playerid] == 3)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/veh\t/veh <id> [color 1] [color 2]\tSpawn a vehicle with the given model id\n", sizeof(str));  
				strcat(str,"/a1\t/a1 <text>\tAdmin chat for level 1 and above\n", sizeof(str));    
				strcat(str,"/repair\tNone\tRepair the vehicle you are in\n", sizeof(str)); 
				strcat(str,"/goto\t/goto <id>\tTeleports to a given player's position\n", sizeof(str)); 
				strcat(str,"/mute\t/mute <id>\tDisable chatting for a given player\n", sizeof(str)); 
				strcat(str,"/unmute\t/unmute <id>\tEnable chatting for a given player\n", sizeof(str)); 
				strcat(str,"/getip\t/getip <id> \tShows the current connected ip of a given player\n", sizeof(str));
				strcat(str,"/getips\t/getips <id>\tShows the all connected ips of a player", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Back");
				af_page[playerid] = 2;
			}
			else if(af_page[playerid] == 4)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/kick\t/kick <id>\tKicks a given player\n", sizeof(str));  
				strcat(str,"/akill\t/akill <name>\tKills a given player\n", sizeof(str)); 
				strcat(str,"/get\t/get <id>\tTeleports a given player to you\n", sizeof(str)); 
				strcat(str,"/sethealth\t/sethealth <id> <amount>\tSets the given player's health to a given amount\n", sizeof(str));
				strcat(str,"/setarmour\t/setarmour <id> <amount>\tSets the given player's armour to  given amount\n", sizeof(str));  
				strcat(str,"/givegun\t/givegun <id> <weaponid> <ammo>\tGive a specified gun to a given player with the\n", sizeof(str)); 
				strcat(str," \t \tspecified amount of ammo\n", sizeof(str));
				strcat(str,"/jail\t/jail <id> <minutes>\tPuts a given player in jail\n", sizeof(str)); 
				strcat(str,"/unjail\t/unjail <id>\tRemoves a given player from jail\n", sizeof(str));
				strcat(str,"/a2\t/a2 <text>\tAdmin chat for level 2 and above\n", sizeof(str));  
				strcat(str,"/agivecash\t/agivecash <id> <amount>\tGive cash for players\n", sizeof(str));
				strcat(str,"/fine\t/fine <id> <amount>\tGive fines for breaking rules", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Back");
				af_page[playerid] = 3;
			}
			else if(af_page[playerid] == 5)
			{
				return Dialog_Close(playerid);
			}
		}
		else if(USERINFO[playerid][plevel] == 5)
		{
			if(af_page[playerid] == 1) 
			{
				return Dialog_Close(playerid);
			}
			else if(af_page[playerid] == 2)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"<...> --> Essential parameter\n", sizeof(str));
				strcat(str,"[...] --> Optional parameter\n\n", sizeof(str));
				strcat(str,"/acmds\tNone\tShows all the Admin commands which you can use\n", sizeof(str));
				strcat(str,"/afuncs\tNone\tShows all the functions related to admin commands\n", sizeof(str));
				strcat(str,"/onduty\tNone\tPuts you on Admin mode\n", sizeof(str)); 
				strcat(str,"/offduty\tNone\tPuts you on Player mode\n", sizeof(str));  
				strcat(str,"/a\t/a <text>\tSend message to players as an Admin\n", sizeof(str));
				strcat(str,"/spawn\t/spawn <id>\tSpawn a given player\n", sizeof(str));  
				strcat(str,"/warn\t/warn <id>\tWarns a given player\n", sizeof(str));
				strcat(str,"/sgg\tNone\tStart the Gun Game\n", sizeof(str)); 
				strcat(str,"/clearchat(cc)\tNone\tClear everyone's chat", sizeof(str)); 
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Close");
				af_page[playerid] = 1;
			}
			else if(af_page[playerid] == 3)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/veh\t/veh <id> [color 1] [color 2]\tSpawn a vehicle with the given model id\n", sizeof(str));  
				strcat(str,"/a1\t/a1 <text>\tAdmin chat for level 1 and above\n", sizeof(str));    
				strcat(str,"/repair\tNone\tRepair the vehicle you are in\n", sizeof(str)); 
				strcat(str,"/goto\t/goto <id>\tTeleports to a given player's position\n", sizeof(str)); 
				strcat(str,"/mute\t/mute <id>\tDisable chatting for a given player\n", sizeof(str)); 
				strcat(str,"/unmute\t/unmute <id>\tEnable chatting for a given player\n", sizeof(str)); 
				strcat(str,"/getip\t/getip <id> \tShows the current connected ip of a given player\n", sizeof(str));
				strcat(str,"/getips\t/getips <id>\tShows the all connected ips of a player", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Back");
				af_page[playerid] = 2;
			}
			else if(af_page[playerid] == 4)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/kick\t/kick <id>\tKicks a given player\n", sizeof(str));  
				strcat(str,"/akill\t/akill <name>\tKills a given player\n", sizeof(str)); 
				strcat(str,"/get\t/get <id>\tTeleports a given player to you\n", sizeof(str)); 
				strcat(str,"/sethealth\t/sethealth <id> <amount>\tSets the given player's health to a given amount\n", sizeof(str));
				strcat(str,"/setarmour\t/setarmour <id> <amount>\tSets the given player's armour to  given amount\n", sizeof(str));  
				strcat(str,"/givegun\t/givegun <id> <weaponid> <ammo>\tGive a specified gun to a given player with the\n", sizeof(str)); 
				strcat(str," \t \tspecified amount of ammo\n", sizeof(str));
				strcat(str,"/jail\t/jail <id> <minutes>\tPuts a given player in jail\n", sizeof(str)); 
				strcat(str,"/unjail\t/unjail <id>\tRemoves a given player from jail\n", sizeof(str));
				strcat(str,"/a2\t/a2 <text>\tAdmin chat for level 2 and above\n", sizeof(str));  
				strcat(str,"/agivecash\t/agivecash <id> <amount>\tGive cash for players\n", sizeof(str));
				strcat(str,"/fine\t/fine <id> <amount>\tGive fines for breaking rules", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Back");
				af_page[playerid] = 3;
			}
			else if(af_page[playerid] == 5)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/setkills\t/setkills <id> <kills>\tSets the kill amount of a given player\n", sizeof(str)); 
				strcat(str,"/setdeaths\t/setdeaths <id> <deaths>\tSets the death amount of a given player\n", sizeof(str)); 
				strcat(str,"/setpass\t/setpass <id> <password>\tResets the password of a player to a given one\n", sizeof(str));
				strcat(str,"/ban\t/ban <id>\tBans a given online player\n", sizeof(str)); 
				strcat(str,"/oban\t/oban <name>\tBans a given offline player\n", sizeof(str)); 
				strcat(str,"/unban\t/unban <name>\tUnbans a banned player\n", sizeof(str));
				strcat(str,"/readlogs\tNone\tRead server logs\n", sizeof(str));
				strcat(str,"/a3\t/a3 <text>\tAdmin chat for level 3 and above\n", sizeof(str));
				strcat(str,"/blockcmds\t/blockcmds <id>\tBlocks all the server commands for a given player\n", sizeof(str));
				strcat(str,"/unblockcmds\t/unblockcmds <id>\tUnblocks all the server commands for a given player\n", sizeof(str));
				strcat(str,"/fexitmg\t/fexitmg <id>\tForce a given player to exit Minigame\n", sizeof(str)); 
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Back");
				af_page[playerid] = 4;
			}
			else if(af_page[playerid] == 6)
			{
				return Dialog_Close(playerid);
			}
		}
	}
	return 1;
}

Dialog:DIALOG_ANIM(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a vehicle");
		inanim[playerid] = 1;
		switch(listitem)
		{
			case 0: ApplyAnimation(playerid,"DANCING","dnce_M_c",4.1,1,1,1,1,1,1);
			case 1: ApplyAnimation(playerid,"DANCING","DAN_Down_A",4.1,1,1,1,1,1,1);
			case 2: ApplyAnimation(playerid,"BEACH","Bather",4.1,1,1,1,1,1,1);
			case 3: ApplyAnimation(playerid,"BEACH","Lay_Bac_Loop",4.1,1,1,1,1,1,1);
			case 4: ApplyAnimation(playerid,"CARRY","liftup",4.1,1,1,1,1,1,1);
			case 5: ApplyAnimation(playerid,"CARRY","liftup05",4.1,1,1,1,1,1,1);
			case 6: ApplyAnimation(playerid,"CARRY","putdwn105",4.1,1,1,1,1,1,1);
			case 7: ApplyAnimation(playerid,"CRACK","Bbalbat_Idle_02",4.1,1,1,1,1,1,1);
			case 8: ApplyAnimation(playerid,"CRACK","crckidle4",4.1,1,1,1,1,1,1);
			case 9: ApplyAnimation(playerid,"CRACK","crckdeth1",4.1,1,1,1,1,1,1);
			case 10: ApplyAnimation(playerid,"DEALER","DEALER_DEAL",4.1,1,1,1,1,1,1);
			case 11: ApplyAnimation(playerid,"DEALER","DEALER_IDLE_01",4.1,1,1,1,1,1,1);
			case 12: ApplyAnimation(playerid,"DILDO","DILDO_Hit_1",4.1,1,1,1,1,1,1);
			case 13: ApplyAnimation(playerid,"DILDO","DILDO_Hit_2",4.1,1,1,1,1,1,1);
			case 14: ApplyAnimation(playerid,"FAT","FatIdle",4.1,1,1,1,1,1,1);
			case 15: ApplyAnimation(playerid,"FAT","IDLE_tired",4.1,1,1,1,1,1,1);
			case 16: ApplyAnimation(playerid,"FAT","FatWalk_Rocket",4.1,1,1,1,1,1,1);
			case 17: ApplyAnimation(playerid,"FAT","FatWalkstart",4.1,1,1,1,1,1,1);
			case 18: ApplyAnimation(playerid,"FOOD","EAT_Burger",4.1,1,1,1,1,1,1);
			case 19: ApplyAnimation(playerid,"SMOKING","M_smk_out",4.1,1,1,1,1,1,1); 
			case 20: ApplyAnimation(playerid,"STRIP","STR_A2B",4.1,1,1,1,1,1,1);
			case 21: ApplyAnimation(playerid,"BASEBALL","Bat_1",4.1,1,1,1,1,1,1);
			case 22: ApplyAnimation(playerid,"BASEBALL","Bat_2",4.1,1,1,1,1,1,1);
			case 23: ApplyAnimation(playerid,"BASEBALL","Bat_3",4.1,1,1,1,1,1,1);
			case 24: ApplyAnimation(playerid,"BASEBALL","Bat_4",4.1,1,1,1,1,1,1);
			case 25: ApplyAnimation(playerid,"ped","SEAT_up",4.1,1,1,1,1,1,1);
			case 26: ApplyAnimation(playerid,"ped","bomber",4.1,1,1,1,1,1,1);
			case 27: ApplyAnimation(playerid,"ped","CAR_Lsit",4.1,1,1,1,1,1,1);
			case 28: ApplyAnimation(playerid,"ped","FALL_back",4.1,1,1,1,1,1,1);
			case 29: ApplyAnimation(playerid,"ped","GunMove_R",4.1,1,1,1,1,1,1);
			case 30: ApplyAnimation(playerid,"ped","phone_talk",4.1,1,1,1,1,1,1);
			case 31: ApplyAnimation(playerid,"ped","woman_runpanic",4.1,1,1,1,1,1,1);
			case 32: ApplyAnimation(playerid,"ped","Walk_Wuzi",4.1,1,1,1,1,1,1);
			case 33: ApplyAnimation(playerid,"RAPPING","Laugh_01",4.1,1,1,1,1,1,1);
			case 34: ApplyAnimation(playerid,"RAPPING","RAP_B_Loop",4.1,1,1,1,1,1,1);
			case 35: ApplyAnimation(playerid,"RAPPING","RAP_A_IN",4.1,1,1,1,1,1,1);
			case 36: ApplyAnimation(playerid,"RIOT","RIOT_CHANT",4.1,1,1,1,1,1,1);
			case 37: ApplyAnimation(playerid,"RIOT","RIOT_FUKU",4.1,1,1,1,1,1,1);
			case 38: ApplyAnimation(playerid,"RIOT","RIOT_shout",4.1,1,1,1,1,1,1);
			case 39: PC_EmulateCommand(playerid, "/piss");
			case 40: PC_EmulateCommand(playerid, "/wank");
			case 41: PC_EmulateCommand(playerid, "/bj 1");
			case 42: PC_EmulateCommand(playerid, "/bj 2");
			case 43: PC_EmulateCommand(playerid, "/bj 3");
			case 44: PC_EmulateCommand(playerid, "/bj 4");
		}
	}
	else return Dialog_Close(playerid);
	return 1;
}

Dialog:DIALOG_GANGS(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		SaveServerData();
		if(listitem > 6)
		{
			new laststr[1024], mem_id = -1, field[24], str[128];
			for(new i = 7; i < MAX_GANGS; i++)
			{
				if(IsValidGang(i))
				{
					mem_id++;
					if(mem_id == listitem)
					{
						mem_id = i;
						break;
					}
				}

			}
			
			strcat(laststr, "Member\tGang level\n", sizeof(laststr));
			mysql_format(Database, laststr, sizeof(laststr), "SELECT * FROM Gangs WHERE `Gang_ID` = %d LIMIT 1", mem_id + 1);
			new Cache:cache = mysql_query(Database, laststr);

			 
			for(new j = 0; j < MAX_GANG_MEMBERS; j++)
			{
				cache_set_active(cache); 

				format(field, sizeof(field), "Member_%d", j + 1);
				cache_get_value_name_int(0, field, mem_id);

				cache_unset_active();

				if(mem_id != -1)
				{
					mysql_format(Database, laststr, sizeof(laststr), "SELECT * FROM Users WHERE `User_ID` = %d LIMIT 1", mem_id);
					mysql_query(Database, laststr);

					cache_get_value_name_int(0, "Gang_level", mem_id);
					cache_get_value_name(0, "Name", field, sizeof(field));

			  		format(str, sizeof(str), "%s\t%s\n", field, GangLevelName(mem_id));
			  		strcat(laststr, str, sizeof(laststr));
			  	}
			}
			cache_delete(cache);
			format(str, sizeof(str), "LGGW - Gangs - %s - Members", ReplaceUwithS(GANGINFO[listitem][gname]));
			Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, str, laststr, "Close", "");
		}
		else
		{
			SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Only custom gangs have gang members");
			return PC_EmulateCommand(playerid, "/gangs");
		}
	}
	else return Dialog_Close(playerid);
	return 1;
}

Dialog:DIALOG_LOGS(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new comp[2048], File:rflh;
		switch(listitem)
		{
			case 0: rflh = fopen(LOG_CONNECTS, io_read);
			case 1: rflh = fopen(LOG_DISCONNECTS, io_read);
			case 2: rflh = fopen(LOG_ADMINLVLCHANGES, io_read);
			case 3: rflh = fopen(LOG_ADMINACTIONS, io_read);
			case 4: rflh = fopen(LOG_BANS, io_read);
			case 5: rflh = fopen(LOG_REPORTS, io_read);
		}
		
		if(rflh)
		{
			new lines, id, str[128];
			
			while(fread(rflh, str))
			{
				lines++;
			}
			
			id = lines - 200;
			lines = 0;
			
			fseek(rflh);
			
			while(fread(rflh, str))
			{
				if(++lines <= id) continue;
				new l[128];
				format(l, sizeof(l), "%s", str);
				strcat(comp, l, sizeof(comp));
			}
			fclose(rflh);
			Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_MSGBOX, "LGGW - Logs", comp, "Close", "");
		}
		else
		{
			SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}This Log is empty");
			return PC_EmulateCommand(playerid, "/readlogs");
		}
	}
	else return Dialog_Close(playerid);
	return 1;
}

Dialog:DIALOG_BUY_SHOP(playerid, response, listitem, inputtext[])
{
	new str[1024], Float:hp;
	GetPlayerHealth(playerid, hp);
	strcat(str, "ID\tMeal         \tPrice\n\n");
	strcat(str, "1 \tLarge        \t$750\n");
	strcat(str, "2 \tHot & spicy  \t$400\n");
	strcat(str, "3 \tJumbo chicken\t$150\n\n");
	strcat(str, "[ Note ] Large - Increase your health by 100%\n");
	strcat(str, "         Hot & spicy - Increase your health by 75%\n"); 
	strcat(str, "         Jumbo chicken - Increase your health by 50%\n");
	if(!response) Dialog_Close(playerid);
	else
	{
		Dialog_Show(playerid, DIALOG_BUY_SHOP, DIALOG_STYLE_INPUT, "LGGW - Restaurant", str, "purchase", "Close");
		if(isequal(inputtext, "1"))
		{
			if(GetPlayerMoney(playerid) < 150)
			{
				SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				return PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
			}
			else 
			{
				PlayerPlaySound(playerid,1054,0.0,0.0,0.0);
				GivePlayerCash(playerid, -750);
				SetPlayerHealth(playerid, 100);
			}
		}
		else if(isequal(inputtext, "2"))
		{
			if(GetPlayerMoney(playerid) < 150)
			{
				SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				return PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
			}
			else
			{
				PlayerPlaySound(playerid,1054,0.0,0.0,0.0);
				GivePlayerCash(playerid, -400);
				if((hp + 75) > 100) SetPlayerHealth(playerid, 100);
				else SetPlayerHealth(playerid, (hp + 75)); 
			}
		}   
		else if(isequal(inputtext, "3"))
		{
			if(GetPlayerMoney(playerid) < 150)
			{
				SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
				return PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
			}
			else
			{
				PlayerPlaySound(playerid,1054,0.0,0.0,0.0);
				GivePlayerCash(playerid, -150);
				if((hp + 50) > 100) SetPlayerHealth(playerid, 100);
				else SetPlayerHealth(playerid, (hp + 50)); 
			}
		} 
		else 
		{
			SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid selection");
			return PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
		}
	}
	return 1;
}

//Commands
CMD:spec(playerid, params[])
{
	new id;
	if(spec[playerid] || GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) return SendClientMessage(playerid, -1, "You are spectating at the moment");		
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "[ Usage ] /spec <id>");	
	if(!IsPlayerConnected(id))	 return SendClientMessage(playerid, -1, "[ Usage ] Invalid player ID");
	if(id == playerid) return SendClientMessage(playerid, -1, "You can't spectate yourself");
	if(GetPlayerState(id) == PLAYER_STATE_SPECTATING) return SendClientMessage(playerid, -1, "Player is spectating someone");
	
	GetPlayerDetails(playerid);
	spec[playerid] = 1;
	specid[playerid] = id;
	SetPlayerColor(playerid, COLOR_SPEC);
	TogglePlayerSpectating(playerid, 1);
	
	if(IsPlayerInAnyVehicle(id)) PlayerSpectateVehicle(playerid, GetPlayerVehicleID(id));
	else PlayerSpectatePlayer(playerid, id);
	
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));
	SetPlayerInterior(playerid, GetPlayerInterior(id));
	
	foreach(new i : Player)
	{
		if(spec[i] == 1 && specid[i] == playerid)
		{
			PC_EmulateCommand(i, "/specoff");
		}
	}
	return 1;
}

CMD:specoff(playerid, params[])
{
	if(!spec[playerid]) return SendClientMessage(playerid, -1, "You are not spectating at the moment");	
	TogglePlayerSpectating(playerid, 0);
	return 1;
}

CMD:zones(playerid, params[])
{
	new s_[1500], tmp[248];
	for(new i = 0; i < sizeof(ZONEINFO); i ++)
	{
		if(i == 0) format(tmp, sizeof(tmp), "Zone\tController\n%s\t%s\n", ReplaceUwithS(ZONEINFO[i][zname]), ReplaceUwithS(GANGINFO[ZONEINFO[i][zteamid]][gname]));
		else if (i != (sizeof(ZONEINFO) - 1)) format(tmp, sizeof(tmp), "%s\t%s\n", ReplaceUwithS(ZONEINFO[i][zname]), ReplaceUwithS(GANGINFO[ZONEINFO[i][zteamid]][gname]));
		else format(tmp, sizeof(tmp), "%s\t%s", ReplaceUwithS(ZONEINFO[i][zname]), ReplaceUwithS(GANGINFO[ZONEINFO[i][zteamid]][gname]));
		strcat(s_, tmp, sizeof(s_));
	}
	Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Zones", s_, "Close", "");
	return 1;
}

CMD:turfs(playerid, params[])
{
	SaveServerData();
	new completed[1024], str[200], name_[30], rows, val;
	strcat(completed, "Gang\tTurfs\n", sizeof(completed));
	cache_get_row_count(rows);
	mysql_query(Database, "SELECT `Name`,`Turfs` FROM `Gangs` WHERE `Name` != '-1', `Turfs` != '0' ORDER BY `Turfs` DESC");
	for(new a; a < rows; a++) 
	{ 
		cache_get_value_name(a, "Name", name_, sizeof(name_));
		cache_get_value_name_int(a, "Turfs", val);
		strreplace(name_, "_", " "); 
		format(str, sizeof(str), "%s\t%d\n", name_, val); 
		strcat(completed, str, sizeof(completed));
	}                                          
	Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Turfs", completed, "Close", "");
	return 1;
}

CMD:gangs(playerid, params[])
{
	new str[1024];
	for(new i = 0; i < MAX_GANGS; i++)
	{
		new gstr[128];
		if(IsValidGang(i))
		{
			format(gstr, sizeof(gstr), "%d\t%s\n", i, ReplaceUwithS(GANGINFO[i][gname]));
			strcat(str, gstr, sizeof(str));
		}
	}
	new completed[1024 + 50];
	format(completed, sizeof(completed), "Gang ID\tName\n%s", str);
	Dialog_Show(playerid, DIALOG_GANGS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Gangs", completed, "Select", "Close");
	SendClientMessage(playerid, -1, "{804040}* Click on any gang to view it's members");
	return 1;
}

CMD:gstats(playerid, params[])
{
	new id, str[1200];
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF69B4}/gstats <id>");
	if(!IsValidGang(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid gang ID");
	if(GANGINFO[id][gdeaths] == 0) format(str, sizeof(str), "%s [%d]\n\nScore earned: %d\nGang kills: %d\nGang deaths: %d\nGang KDR: 0.00\nTurfs controlled: %d", ReplaceUwithS(GANGINFO[id][gname]), id, GANGINFO[id][gscore], GANGINFO[id][gkills], GANGINFO[id][gdeaths], GANGINFO[id][gturfs]);
	else format(str, sizeof(str), "%s [%d]\n\nScore earned: %d\nGang kills: %d\nGang deaths: %d\nGang KDR: %.2f\nTurfs controlled: %d", ReplaceUwithS(GANGINFO[id][gname]), id, GANGINFO[id][gscore], GANGINFO[id][gkills], GANGINFO[id][gdeaths], floatdiv(GANGINFO[id][gkills], GANGINFO[id][gdeaths]), GANGINFO[id][gturfs]);
	Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_MSGBOX, "LGGW - Gang Statistics", str, "Close", "");
	return 1;
}

CMD:credits(playerid, params[])
{
	new str[1024];
    strcat(str, "  - The people who are behind this strong effort -   \n\n", sizeof(str));
    strcat(str, "                    ~ Coding by ~                    \n", sizeof(str));
    strcat(str, "                       GameOvr                       \n\n", sizeof(str)); 
    strcat(str, "                    ~ Website By ~                   \n", sizeof(str)); 
    strcat(str, "                   _.EvilExecutor._                  \n\n", sizeof(str));  
    strcat(str, "                    ~ Mapped By ~                    \n", sizeof(str)); 
    strcat(str, "                      Scorpion.                      \n\n", sizeof(str)); 
    strcat(str, "                  ~ Beta Testing By ~                \n", sizeof(str)); 
    strcat(str, "                       GameOvr                       \n", sizeof(str));  
    strcat(str, "                   _.EvilExecutor._                  \n", sizeof(str)); 
    strcat(str, "                      Scorpion.                      \n", sizeof(str));
    strcat(str, "                      Drayvox                        \n", sizeof(str));
    strcat(str, "                       Jithu                         \n", sizeof(str));
    strcat(str, "                     BloodHunter_                    \n\n", sizeof(str));
    strcat(str, "                ~ Other Contributors ~               \n", sizeof(str));
    strcat(str, "                     Husam_Haider                    \n", sizeof(str));
    strcat(str, "                        SoNu                         \n", sizeof(str));
    strcat(str, "                      realistik                      \n", sizeof(str));
    strcat(str, "                       hamz4                         \n\n", sizeof(str));
    strcat(str, "Special thanks for \"Cypress\" for providing the HOST", sizeof(str));
    Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_MSGBOX, "LGGW - Credits", str, "Close", "");          
	return 1;
}

CMD:cmds(playerid, params[])
{
	new str[2048];
	strcat(str, "Command\tFunction\n\n", sizeof(str));
	strcat(str, "/credits\tShows Creators & Contributors of the SERVER\n", sizeof(str));
	strcat(str, "/cmds\tShows the list of server commands\n", sizeof(str));
	strcat(str, "/help\tIf you are looking for help then this is the command\n", sizeof(str));
	strcat(str, "/keys\tShows the key usage of servers\n", sizeof(str));
	strcat(str, "/gungame\tJoins the Gun Game\n", sizeof(str));			
	strcat(str, "/givecash\tGive someone cash from your account\n", sizeof(str));	
	strcat(str, "/changepass\tChange the password to a desired one\n", sizeof(str));
	strcat(str, "/stats\tShow the statistics of a player\n", sizeof(str));
	strcat(str, "/speedo\tToggle vehicle speedo meter\n", sizeof(str));
	strcat(str, "/spec\tSpectate a player\n", sizeof(str));
	strcat(str, "/specoff\tStop spectating a player\n", sizeof(str));
	strcat(str, "/cmc\tClears your chat\n", sizeof(str));
	strcat(str, "/gstats\tShows the statistics of a gang\n", sizeof(str));
	strcat(str, "/gangs\tShows the list of gangs in the server\n", sizeof(str));
	strcat(str, "/zones\tShows the list of Zones in the server\n", sizeof(str));
	strcat(str, "/blobkpm\tBlock recieving personal messages\n", sizeof(str));
	strcat(str, "/pm\tSend a personal message to a player\n", sizeof(str));
	strcat(str, "/report\tSending a report to Administrators\n", sizeof(str));
	strcat(str, "/top\tShows the Top 10 rankings in different criterias\n", sizeof(str)); 
	strcat(str, "/gang\tShows the list of gang commands with functions\n", sizeof(str));
	strcat(str, "/medkit\tA small bag containing medical supplies that fully heal the player\n", sizeof(str));
	strcat(str, "/lms\tStart Last Man Standing or join it\n", sizeof(str));
	strcat(str, "/v\tSpawn your personal vehicle\n", sizeof(str));
	strcat(str, "/dm(1..5)\tShows the list of deathmatches\n", sizeof(str));
	strcat(str, "/exit\tExits from a joined Minigame\n", sizeof(str));
	strcat(str, "/duel\tStart a duel\n", sizeof(str));
	strcat(str, "/duelsettings\tChange duel settings\n", sizeof(str));
	strcat(str, "/cancel\tCancel a requested duel\n", sizeof(str));
	strcat(str, "/yes\tAccept an invited duel\n", sizeof(str));
	strcat(str, "/no\tReject an invited duel\n", sizeof(str));
	strcat(str, "/t\tSends a team message\n", sizeof(str));
	strcat(str, "/kill\tMake you suicide\n", sizeof(str));
	strcat(str, "/rules\tShows the list of server rules\n", sizeof(str));
	strcat(str, "/backup\tRequest for a gang backup\n", sizeof(str));
	strcat(str, "/anim\tShows a list of server available animations\n", sizeof(str));
	strcat(str, "/bj\tBlow job animations\n", sizeof(str));
	strcat(str, "/piss\tPiss animation\n", sizeof(str));
	strcat(str, "/wank\tWank animation", sizeof(str));
	Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Commands", str, "Close", "");
	return 1;
}

CMD:help(playerid, params[])
{
	new str[2048];
	strcat(str, "                                             Hey There,                                              \n\n", sizeof(str));
	strcat(str, "                      You might be new here and wondering about what to do.                            \n", sizeof(str));
	strcat(str, "          You may be dreaming high about being a Dominator in the server without knowing a shit!       \n", sizeof(str)); 
	strcat(str, "               Yeah dreaming high is good but you should know a few things before...                   \n", sizeof(str)); 
	strcat(str, "                                            No Worries!                                                \n", sizeof(str));
	strcat(str, "                   You can be your dream because we are here to help you with it.                      \n", sizeof(str));
	strcat(str, "              Okay enough introductions without wasting anymore time let's get started.                \n", sizeof(str)); 
	strcat(str, "            (To know all the available commands use /cmds while /rules to know the rules)              \n", sizeof(str));
	strcat(str, "                  As you all know in Gang Wars there are many things to cover.                         \n", sizeof(str)); 
	strcat(str, "                  So let's break it down to make you much more comfortable.                            \n\n", sizeof(str));
	strcat(str, "                                1. How to be the top killer(Includes how to DM and Duel)?              \n", sizeof(str));
	strcat(str, "                                2. How to be the richest?                                              \n", sizeof(str));
	strcat(str, "                                3. How can your gang rule Los Santos?                                  \n", sizeof(str));
	strcat(str, "                                4. How to deal with Minigames?                                         \n", sizeof(str));
	strcat(str, "                                5. How to be the knightrider of Los Santos?                            \n\n", sizeof(str));
	strcat(str, "   >> Once you finished reading these topics, We guarantee that you are ready to RULE Los Santos <<\n\n", sizeof(str));
	strcat(str, "[ Just type the number in the below box and hit enter in order to get help regarding the topics above ]", sizeof(str));
	Dialog_Show(playerid, DIALOG_HELP, DIALOG_STYLE_INPUT, "LGGW - Help", str, "Enter", "Close");
	return 1;
}

CMD:keys(playerid, params[])
{
	new str[1024];
	strcat(str, "Key\tFunction\n", sizeof(str)); 
	strcat(str, "LCTRL\tStop animation\n", sizeof(str)); 
	strcat(str, " \tNitro for personal vehicles\n", sizeof(str));
	strcat(str, "LMB\tStop animation\n", sizeof(str));
	strcat(str, " \tNitro for personal vehicles\n", sizeof(str));
	strcat(str, "Enter\tStop animation\n ", sizeof(str));
	strcat(str, " \tUse sprunk machine\n", sizeof(str));
	strcat(str, "F\tStop animation\n", sizeof(str));
	strcat(str, " \tUse sprunk machine\n", sizeof(str));
	strcat(str, "Y\tClose statistics", sizeof(str));
	Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Key Usage", str, "Close", "");
	return 1;
}

CMD:acmds(playerid, params[])
{
	new str[1024];
	if(USERINFO[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(USERINFO[playerid][plevel] >= 1)
	{
		strcat(str, "{1495CE}Trial Moderator\n\n", sizeof(str));
		strcat(str, "{ffffff}/onduty   /offduty   /a   /spawn   /sgg   /clearchat(cc)\n", sizeof(str));
		strcat(str, "{ffffff}/veh   /warn   /repair   /goto   /mute   /unmute\n", sizeof(str));
		strcat(str, "{ffffff}/getip   /getips   /a1   /acmds   /afuncs\n\n", sizeof(str));
	}
	if(USERINFO[playerid][plevel] >= 2)
	{
		strcat(str, "{1495CE}Moderator\n\n", sizeof(str));
		strcat(str, "{ffffff}/kick   /get   /sethealth   /setarmour   /agivecash\n", sizeof(str)); 
		strcat(str, "{ffffff}/givegun   /jail   /unjail   /fine   /a2   /akill\n", sizeof(str)); 
		strcat(str, "{ffffff}/freeze   /unfreeze\n\n", sizeof(str)); 
	}
	if(USERINFO[playerid][plevel] >= 3)
	{
		strcat(str, "{1495CE}Administrator\n\n", sizeof(str));
		strcat(str, "{ffffff}/ban   /oban   /unban   /setkills   /setdeaths   /setpass\n", sizeof(str));
		strcat(str, "{ffffff}/setname   /readlogs   /blockcmds   /unblockcmds   /fexitmg\n", sizeof(str));
		strcat(str, "{ffffff}/a3\n", sizeof(str)); 
	}
	if(USERINFO[playerid][plevel] >= 4)
	{
		strcat(str, "{1495CE}Management Board\n\n", sizeof(str));
		strcat(str, "{ffffff}/setlevel   /spawnall   /killall   /givepriveh   /a4\n\n", sizeof(str));
	}
	if(USERINFO[playerid][plevel] == 5)
	{
		strcat(str, "{1495CE}Developer\n\n", sizeof(str));
		strcat(str, "{ffffff}/a5\n\n", sizeof(str));
	}
	strcat(str, "*** Use /afuncs to see the relevent functions for commands\n", sizeof(str));
	strcat(str, "[ Note ] * Every inch of actions you take will be logged.\n", sizeof(str));
	strcat(str, "           So don't abuse Admin powers.\n", sizeof(str));
	strcat(str, "         * Never test Admin commands, Use them when necessary.", sizeof(str));
	Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_MSGBOX, "LGGW - Admin Commands", str, "Close", "");
	return 1;
}

CMD:afuncs(playerid, params[])
{
	new str[1024];
	if(USERINFO[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
	strcat(str,"<...> --> Essential parameter\n", sizeof(str));
	strcat(str,"[...] --> Optional parameter\n\n", sizeof(str));
	strcat(str,"/acmds\tNone\tShows all the Admin commands which you can use\n", sizeof(str));
	strcat(str,"/afuncs\tNone\tShows all the functions related to admin commands\n", sizeof(str));
	strcat(str,"/onduty\tNone\tPuts you on Admin mode\n", sizeof(str)); 
	strcat(str,"/offduty\tNone\tPuts you on Player mode\n", sizeof(str));  
	strcat(str,"/a\t/a <text>\tSend message to players as an Admin\n", sizeof(str));
	strcat(str,"/spawn\t/spawn <id>\tSpawn a given player\n", sizeof(str));  
	strcat(str,"/warn\t/warn <id>\twarns a given player\n", sizeof(str));
	strcat(str,"/sgg\tNone\tStart the Gun Game\n", sizeof(str)); 
	strcat(str,"/clearchat(cc)\tNone\tClear everyone's chat", sizeof(str)); 
	Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "LGGW - Admin Functions", str, "Next", "Close");
	af_page[playerid] = 1;
	return 1;
}

CMD:spawnall(playerid, params[])
{
	if(USERINFO[playerid][plevel] < 4) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Invalid command");
	foreach(new i : Player)
	{
		if(!IsPlayerInClassSelection(i))
		{
			if(IsPlayerSpawned(i)) SpawnPlayer(i);
		}
	}
	SendClientMessageToAll_(-1, "{006400}[ Info ] {00FF00} An Admin has respawned everyone!");
	WriteLog(LOG_ADMINACTIONS, "COMMAND: spawnall | Admin: %s | Affected: All", PlayerName(playerid));
	return 1;
}

CMD:killall(playerid, params[])
{
	if(USERINFO[playerid][plevel] < 4) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Invalid command");
	foreach(new i : Player)
	{
		if(!IsPlayerInClassSelection(i))
		{
			if(IsPlayerSpawned(i)) SetPlayerHealth(i, 0);
		}
	}
	SendClientMessageToAll_(-1, "{006400}[ Info ] {00FF00} An Admin has killed everyone!");
	WriteLog(LOG_ADMINACTIONS, "COMMAND: killall | Admin: %s | Affected: All", PlayerName(playerid));
	return 1;
}

CMD:blockcmds(playerid, params[]) 
{
	new id, str[128];
	if(USERINFO[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Invalid command");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF69B4} /blockcmds <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} There is no such player!");
	if(id == playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Entered player is You!");
	if(USERINFO[id][plevel] >= USERINFO[playerid][plevel]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Player you entered is at the same level or a higher level than you");
	if(nocmd[id] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Commands are restricted for the player already");
	SendClientMessage(id, -1, "{006400}[ Info ] {00FF00} An Admin has blocked all server commands for you!");
	format(str, sizeof(str), "{006400}[ Info ] {00FF00} You restricted all server commands for %s[%d]", PlayerName(id), id);
	SendClientMessage(playerid, -1, str);
	nocmd[playerid] = 1;
	WriteLog(LOG_ADMINACTIONS, "COMMAND: unblockcmds | Admin: %s | Affected: %s", PlayerName(playerid), PlayerName(id));
	return 1;
}

CMD:unblockcmds(playerid, params[])
{
	new id, str[128];
	if(USERINFO[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Invalid command");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF69B4} /unblockcmds <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} There is no such player!");
	if(id == playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Entered player is You!");
	if(USERINFO[playerid][jailed] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} You can't unblock commands for a jailed player");
	if(nocmd[id] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Commands are not restricted for the player");
	if(USERINFO[id][plevel] >= USERINFO[playerid][plevel]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Player you entered is at the same level or a higher level than you");
	SendClientMessage(id, -1, "{006400}[ Info ] {00FF00} An Admin has unblocked all server commands for you!");
	format(str, sizeof(str), "{006400}[ Info ] {00FF00} You unblocked all server commands for %s[%d]", PlayerName(id), id);
	SendClientMessage(playerid, -1, str);
	nocmd[playerid] = 1;
	WriteLog(LOG_ADMINACTIONS, "COMMAND: blockcmds | Admin: %s | Affected: %s", PlayerName(playerid), PlayerName(id));
	return 1;
}

CMD:warn(playerid, params[])
{
	new id, str[256], message[256];
	if(USERINFO[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Invalid command");
	if(sscanf(params, "us[256]", id, message)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF69B4} /warn <id> <message>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} There is no such player!");
	if(id == playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Entered player is You!");
	if(USERINFO[id][plevel] >= USERINFO[playerid][plevel]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Player you entered is at the same level or a higher level than you");
	format(str, sizeof(str), "~r~WARNED!!!~n~~g~[%d/%d]", warns[id], MAX_WARNS);
	GameTextForPlayer(id, str, 10, 5);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00} You were warned by an Admin for -> %s", message);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00} You warned %s[%d] (WARN: %s)", PlayerName(id), id, message);
	SendClientMessage(id, -1, "{006400}[ Info ] {00FF00} You will be kicked when the maximum warn limit reached");
	SendClientMessage(playerid, -1, str);
	warns[id]++;
	if(warns[id] == MAX_WARNS)
	{
		format(str, sizeof(str), "{FF8000}* '%s[%d]' kicked from the Server (Exeeding Warn limit)", PlayerName(id), id);
		Kick(id);
	}
	WriteLog(LOG_ADMINACTIONS, "COMMAND: warn | Admin: %s | Affected: %s", PlayerName(playerid), PlayerName(id));
	return 1;
}

CMD:repair(playerid, params[])
{
	if(USERINFO[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{e60000}{e60000}[ Error ] {FF6347} {FF6347}Invalid command");
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFFFFFFFF, "{e60000}[ Error ] {FF6347} You are not in a vehicle!");
    RepairVehicle(GetPlayerVehicleID(playerid));
    SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00} Your vehicle has been successfully repaired!");
    WriteLog(LOG_ADMINACTIONS, "COMMAND: repair | Admin: %s | Affected: Self", PlayerName(playerid));
	return 1;
}

CMD:fexitmg(playerid, params[])
{
	new id, str[128];
	if(USERINFO[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Invalid command");
	if(sscanf(params, "us[256]", id)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF69B4} /fexitmg <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} There is no such player!");
	if(id == playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Entered player is You!");
	if(inminigame[id] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Player is not in a Minigame");
	if(USERINFO[id][plevel] >= USERINFO[playerid][plevel]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Player you entered is at the same level or a higher level than you");
	if(indm[id] == 1 || ingg[id] == 1)
	{
		PC_EmulateCommand(id, "/exit");
		SendClientMessage(playerid, -1, "An admin has removed you from the Minigame");
	}
	if(inlms[id] == 1)
	{
		inlms[id] = 0;
		inminigame[id] = 0;
		format(str, sizeof(str), "{800080}[ LMS ] {8000FF}'%s[%d]' dropped out of LMS with %d kills (An Admin has removed the player from Minigame)", PlayerName(playerid), playerid, lmskills[playerid]);
		SendClientMessageToAll_(-1, str);
		ResetPlayerWeapons(id);
		SetPlayerDetails(id);
		new count, idx = -1;
		foreach(new i : Player)
		{
			if(inlms[i] == 1 && inminigame[i] == 1)
			{
				count ++;
				idx = i;
			}
		}

		if(count == 1)
		{
			format(str, sizeof(str), "{800080}[ LMS ] {8000FF}'%s[%d]' survived in the event as the Last Man Standing with %d number of kills and won %d$", PlayerName(idx), idx, lmskills[idx], MONEY_PER_LMS_KILL * lmskills[idx]);
			SendClientMessageToAll_(-1, str);
			lmsstarted = 0;
			inlms[idx] = 0;
			inminigame[idx] = 0;
			USERINFO[idx][lmswon] ++;
			ResetPlayerWeapons(idx);
			SetPlayerDetails(idx);
			foreach(new k : Player)
			{
				SetPlayerMarkerForPlayer(k, idx, COLOR[idx]);
				SetPlayerMarkerForPlayer(k, playerid, COLOR[id]);
			}
			if(lmskills[idx] == 0) GivePlayerCash(idx, MONEY_PER_LMS_KILL / 2);
			else GivePlayerCash(idx, MONEY_PER_LMS_KILL * lmskills[playerid]);
		}
	}
	WriteLog(LOG_ADMINACTIONS, "COMMAND: fexitmg | Admin: %s | Affected: %s", PlayerName(playerid), PlayerName(id));
	return 1;
}

CMD:a1(playerid, params[])
{
	new text[128], str[160];
	if(USERINFO[playerid][muted] == 1)
	{
		format(str, sizeof(str), "{e60000}[ Error ] {FF6347}You can't talk while you are muted (Remaining time: %d seconds)", USERINFO[playerid][mutetime]);
		SendClientMessage(playerid, -1, str);
	} 
	if(USERINFO[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Invalid command");
	if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF69B4} /a1 <text>");
	format(str, sizeof(str), "[ /a1 | Level: %d ] %s[%d]: %s", USERINFO[playerid][plevel], PlayerName(playerid), playerid, text);
	SendToAdmins(-1, str, 1);
	return 1;
}

CMD:a2(playerid, params[])
{
	new text[128], str[160];
	if(USERINFO[playerid][muted] == 1)
	{
		format(str, sizeof(str), "{e60000}[ Error ] {FF6347}You can't talk while you are muted (Remaining time: %d seconds)", USERINFO[playerid][mutetime]);
		SendClientMessage(playerid, -1, str);
	} 
	if(USERINFO[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Invalid command");
	if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF69B4} /a2 <text>");
	format(str, sizeof(str), "[ /a2 | Level: %d ] %s[%d]: %s", USERINFO[playerid][plevel], PlayerName(playerid), playerid, text);
	SendToAdmins(-1, str, 2);
	return 1;
}

CMD:a3(playerid, params[])
{
	new text[128], str[160];
	if(USERINFO[playerid][muted] == 1)
	{
		format(str, sizeof(str), "{e60000}[ Error ] {FF6347}You can't talk while you are muted (Remaining time: %d seconds)", USERINFO[playerid][mutetime]);
		SendClientMessage(playerid, -1, str);
	} 
	if(USERINFO[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Invalid command");
	if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF69B4} /a3 <text>");
	format(str, sizeof(str), "[ /a3 | Level: %d ] %s[%d]: %s", USERINFO[playerid][plevel], PlayerName(playerid), playerid, text);
	SendToAdmins(-1, str, 3);
	return 1;
}

CMD:a4(playerid, params[])
{
	new text[128], str[160];
	if(USERINFO[playerid][muted] == 1)
	{
		format(str, sizeof(str), "{e60000}[ Error ] {FF6347}You can't talk while you are muted (Remaining time: %d seconds)", USERINFO[playerid][mutetime]);
		SendClientMessage(playerid, -1, str);
	} 
	if(USERINFO[playerid][plevel] < 4) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Invalid command");
	if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF69B4} /a4 <text>");
	format(str, sizeof(str), "[ /a4 | Level: %d ] %s[%d]: %s", USERINFO[playerid][plevel], PlayerName(playerid), playerid, text);
	SendToAdmins(-1, str, 4);
	return 1;
}

CMD:a5(playerid, params[])
{
	new text[128], str[160];
	if(USERINFO[playerid][muted] == 1)
	{
		format(str, sizeof(str), "{e60000}[ Error ] {FF6347}You can't talk while you are muted (Remaining time: %d seconds)", USERINFO[playerid][mutetime]);
		SendClientMessage(playerid, -1, str);
	} 
	if(USERINFO[playerid][plevel] < 5) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Invalid command");
	if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF69B4} /a5 <text>");
	format(str, sizeof(str), "[ /a5 | Level: %d ]  %s[%d]: %s", USERINFO[playerid][plevel], PlayerName(playerid), playerid, text);
	SendToAdmins(-1, str, 5);
	return 1;
}

CMD:givepriveh(playerid, params[])
{
	new name[MAX_PLAYER_NAME], str[512], model;
	if(USERINFO[playerid][plevel] < 4) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Invalid command");
	if(sscanf(params, "s["#MAX_PLAYER_NAME"]i", name, model)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF69B4} /givepriveh <name> <model>");
	mysql_format(Database, str, sizeof(str), "SELECT * FROM Users WHERE `Name` = '%e' LIMIT 1", name);
	mysql_query(Database, str);
	if(!cache_num_rows()) return SendClientMessage(playerid, -1 , "{e60000}[ Error ] {FF6347} There is no such player");
	new v_owned;
	cache_get_value_name_int(0, "Vehicle_owned", v_owned);
	if(v_owned == 1) return SendClientMessage(playerid, -1 , "{e60000}[ Error ] {FF6347} This player already has a private vehicle");
	if(model != 567 && model != 567 && model != 534 && model != 402 && model != 558 && model != 562 && model != 560 && model != 506 && model != 415 && model != 541 && model != 471 && model != 462 && model != 463 && model != 468 && model != 461 && model != 581 && model != 521)
	{
		return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347} Invalid private vehicle model ID");
	}

	new id = -1;
	foreach(new i : Player)
	{
		if(isequal(name, PlayerName(i)))
		{
			id = i;
			break;
		}
	}

	if(id != -1)
	{
		USERINFO[id][vowned] = 1;
		USERINFO[id][vmodel] = model;
		USERINFO[id][vcolor_1] = 51;
		if(model != 541) USERINFO[id][vcolor_2] = 51;
		else USERINFO[id][vcolor_2] = 53;
		USERINFO[id][vnitro] = -1;
		USERINFO[id][vneon_1] = 0;
		USERINFO[id][vneon_2] = 0;
		USERINFO[id][vpjob] = 3;
		USERINFO[id][vwheel] = 1077;
		USERINFO[id][vhydra] = 0;
	}
	else 
	{
		mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Vehicle_owned` = 1, `Vehicle_model` = %d, `Vehicle_wheel` = 1077, `Vehicle_color_1` = 51, `Vehicle_color_2` = 53, \
			`Vehicle_neon_1` = 0, `Vehicle_neon_2` = 0, `Vehicle_paintjob` = 3, `Vehicle_nitro` = -1, `Vehicle_hydraulics` = 0 WHERE `Name` = %e LIMIT 1", model, name);
		mysql_query(Database, str);
	}

	if(id == -1) format(str, sizeof(str), "{006400}[ Info ] {00FF00} You have given \"%s\" a \"%s\" as a private vehicle", name, VehicleNames[model - 400]);
	else format(str, sizeof(str), "{006400}[ Info ] {00FF00} You have given \"%s[%d]\" a \"%s\" as a private vehicle", name, id, VehicleNames[model - 400]);
	SendClientMessage(playerid, -1, str);
	
	format(str, sizeof(str), "{006400}[ Info ] {00FF00} You were given a \"%s\" as a private vehicle by an Admin", VehicleNames[model - 400]);

	if(id != -1)
	{
		SendClientMessage(id, -1, str);
		SendClientMessage(id, -1, "{006400}[ Info ] {00FF00} Use /v to spawn it");
	}
	WriteLog(LOG_ADMINACTIONS, "COMMAND: givepriveh | Admin: %s | Affected: %s", PlayerName(playerid), name);
	return 1;
}

CMD:sgg(playerid, params[])
{
	if(USERINFO[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(gg_started == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}GunGame has already started");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a minigame");
	new count;
	foreach(new i : Player)
	{
     	count++;
	}
	if(count < MIN_PLAYERS_TO_START_GUNGAME) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Not Enough Players (Required: "#MIN_PLAYERS_TO_START_GUNGAME" players");
	gg_started = 1;
	SetTimer("GunGameEndTime", TIME_FOR_GUNGAME_END * 60 * 1000, false);
	GameTextForAll("~r~gungame started!~n~~g~use /gungame to join", 10000, 4);
	SendClientMessageToAll_(-1, "{008000}Gun Game has started use /gungame to join");
	SendClientMessageToAll_(-1, "{008000}Gun Game winner will be announced in "#TIME_FOR_GUNGAME_END" minutes");
	WriteLog(LOG_ADMINACTIONS, "COMMAND: sgg | Admin: %s | Affected: All", PlayerName(playerid));
	return 1;
}

CMD:gungame(playerid, params[])
{
	if(gg_started == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Gun Game haven't started yet (You can ask for an Admin to start)");
	if(USERINFO[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command while you are in Admin mode");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a minigame");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have participated for Last Man Standing");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are invited for a duel, use /no to refuse or /yes to accept it");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have invited someone for a duel, use /cancel");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a vehicle");
	GetPlayerDetails(playerid);
	gg_lvl[playerid] = 1;
	new str[128];
	format(str, sizeof(str), "{FF8040}%s has joined the GunGame (/gungame)", PlayerName(playerid));
	SendClientMessageToAll_(-1, str);
	SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}Use \"/exit\" to leave (Your gungame progress won't be saved if you left)");
	ingg[playerid] = 1;
	inminigame[playerid] = 1;
	SetPlayerTeam(playerid, NO_TEAM);
	SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 0);
	SetPlayerColor(playerid, COLOR_GG);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 9, 2000);
	SetPlayerVirtualWorld(playerid, 55);
	SetPlayerInterior(playerid, 0);
	new rand = random(sizeof(GGRandoms));
	SetPlayerPos(playerid, GGRandoms[rand][0], GGRandoms[rand][1], GGRandoms[rand][2]);
	SetPlayerFacingAngle(playerid, GGRandoms[rand][3]);
	return 1;
}

CMD:changepass(playerid, params[])
{
	new oldpass[128], newpass[128];
	if(sscanf(params, "s[128]s[128]", oldpass, newpass)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF69B4}/changepass <oldpassword> <newpassword>");
	new buf1[129], buf[129];
	WP_Hash(buf, sizeof(buf), oldpass);
	if(!isequal(buf, USERINFO[playerid][ppass])) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Incorrect password");
	if(strlen(newpass) < 5 ) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Your new password must include atleast 5 characters");
	if(strlen(newpass) > 20 ) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Your new password cannot go over 20 characters");
	WP_Hash(buf1, sizeof(buf1), newpass);
	format(USERINFO[playerid][ppass], 129, "%s", buf1);
	SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}Your password has been changed successfully");
	new str[128];
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}Your new password: %s", newpass);
	SendClientMessage(playerid, -1, str);
	WriteLog(LOG_PASS, "Name: %s | HashCode: %s", PlayerName(playerid), buf);
	return 1;
}

stock ConvertToMinAndHours(seconds, &hours, &mins)
{
	new rem = seconds % 3600;
	hours = (seconds - rem)/3600;
	new rem_ = rem % 60;
	mins = (rem - rem_)/60;
}

CMD:stats(playerid, params[])
{
	new id, str[512];
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF69B4}/stats <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	
	TextDrawShowForPlayer(playerid, statstd);
	
	PlayerTextDrawColor(playerid, statstd_1[playerid][0], GetPlayerColor(playerid));
	format(str, sizeof(str), "%s~w~'s_stats", PlayerName(id), id);
	PlayerTextDrawSetString(playerid, statstd_1[playerid][0], str);
	PlayerTextDrawShow(playerid, statstd_1[playerid][0]);

	PlayerTextDrawColor(playerid, statstd_1[playerid][1], GANGINFO[USERINFO[playerid][gid]][gcolor]);
	format(str, sizeof(str), "%s~n~%s", GANGINFO[USERINFO[playerid][gid]][gname], GANGINFO[USERINFO[playerid][gid]][gtag]);
	PlayerTextDrawSetString(playerid, statstd_1[playerid][1], str);
	PlayerTextDrawShow(playerid, statstd_1[playerid][1]);

	PlayerTextDrawSetPreviewModel(playerid, statstd_1[playerid][4], GetPlayerSkin(id));
	PlayerTextDrawShow(playerid, statstd_1[playerid][4]);

	PlayerTextDrawSetPreviewVehCol(playerid, statstd_1[playerid][5], USERINFO[playerid][vcolor_1], USERINFO[playerid][vcolor_2]);
	PlayerTextDrawSetPreviewModel(playerid, statstd_1[playerid][5], USERINFO[playerid][vmodel]);
	if(USERINFO[playerid][vowned] == 1) PlayerTextDrawShow(playerid, statstd_1[playerid][5]);

	new bool[10];
	if(USERINFO[playerid][VIP] == 1) bool = "Yes";
	else bool = "No";

	new Float:ratio;
	if(USERINFO[playerid][pdeaths] == 0) ratio = 0.00;
	else ratio = floatdiv(USERINFO[playerid][pkills], USERINFO[playerid][pdeaths]);

	new pTime[30], hours, mins;
	ConvertToMinAndHours(USERINFO[playerid][ptime], hours, mins);
	format(pTime, sizeof(pTime), "%d_hrs_%d_mins", hours, mins);
	
	format(str, sizeof(str), "~y~VIP_status:_~w~%s~n~~y~Kills:_~w~%d~n~~y~Deaths:_~w~%d~n~~y~Ratio:_~w~%.2f~n~~y~Play_time:_~w~%s~n~~y~Income:_~w~%d~n~~y~Highest_rampage:_~w~%d~n~~y~Head_shots:_~w~%d", bool, USERINFO[playerid][pkills], USERINFO[playerid][pdeaths], ratio, pTime, GetPlayerMoney(playerid), USERINFO[playerid][bramp], USERINFO[playerid][hshots]);
	PlayerTextDrawSetString(playerid, statstd_1[playerid][2], str);
	PlayerTextDrawShow(playerid, statstd_1[playerid][2]);

	new vbool[10];
	if(USERINFO[playerid][vowned] == 1) format(vbool, sizeof(vbool), "%s", VehicleNames[USERINFO[playerid][vmodel] - 400]);
	else vbool = "Not_owned";

	format(str, sizeof(str), "~y~Revenges:_~w~%d~n~~y~Brutal_kills:_~w~%d~n~~y~GunGames_won:_~w~%d~n~~y~LMS_won:_~w~%d~n~~y~Duels_won:_~w~%d~n~~y~Robberies:_~w~%d~n~~y~Vehicle:_~w~%s", USERINFO[playerid][revenges], USERINFO[playerid][bkills], USERINFO[playerid][ggw], USERINFO[playerid][lmswon], USERINFO[playerid][dwon], USERINFO[playerid][robbs], vbool);
	PlayerTextDrawSetString(playerid, statstd_1[playerid][3], str);
	PlayerTextDrawShow(playerid, statstd_1[playerid][3]);
	return 1;
} 

CMD:cmc(playerid, params[])
{
	for(new i = 0; i < 100; i++) SendClientMessage(playerid, -1, "");
	return 1;
}

CMD:blockpm(playerid, params[])
{
	if(USERINFO[playerid][blockpm] == 1)
	{
		SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You unblocked recieving personal messages from others");
		USERINFO[playerid][blockpm] = 0;
	}
	else
	{
		SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You blocked recieving personal messages from others");
		USERINFO[playerid][blockpm] = 1;
	}
	return 1;
}

CMD:pm(playerid , params[])
{
	new id, message[128], str[128];
	if(USERINFO[playerid][muted] == 1)
	{
		format(str, sizeof(str), "{e60000}[ Error ] {FF6347}You can't talk while you are muted (Remaining time: %d seconds)", USERINFO[playerid][mutetime]);
		SendClientMessage(playerid, -1, str);
	} 
	if(sscanf(params,"us[256]", id, message)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF69B4}/pm <id> <text>");
	if(id == playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't PM yourself");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(USERINFO[id][blockpm] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player has blocked recieving PMs from others");
	PlayerPlaySound(id, 1057, 0.0, 0.0, 0.0); 
	format(str, sizeof(str), "{008080}*** PM from %s[%d]: %s" ,PlayerName(playerid), playerid, message);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{008080}*** PM to %s[%d]: %s" ,PlayerName(id), id, message); 
	SendClientMessage(playerid, -1, str);
	format(str, sizeof(str), "{C1AB53}* PM from %s[%d] to %s[%d]: %s", PlayerName(playerid), playerid, PlayerName(id), id, message);
	new hlvl;
	if(USERINFO[id][plevel] > USERINFO[playerid][plevel]) hlvl = USERINFO[id][plevel];
	else hlvl = USERINFO[playerid][plevel];
	foreach(new j : Player)
	{
		if(USERINFO[j][plevel] >= hlvl && j != playerid && j != id && USERINFO[j][plevel] != 0)
		{
			SendClientMessage(j, -1, str);
		}
	} 
	WriteLog(LOG_PM, "Sender: %s | Reciever: %s | Message: %s", PlayerName(playerid), PlayerName(id), message);
	return 1;
}

CMD:setlevel(playerid, params[])
{
	new id, level, str[128];
	if(USERINFO[playerid][plevel] < 4 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "ui", id, level)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF69B4}/setlevel <id> <level>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(id == playerid && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command on you");
	if((USERINFO[id][plevel] >= USERINFO[playerid][plevel] || IsPlayerAdmin(id)) && id != playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player you entered is at the same level or a higher level than you");
	if(level > 5 || level < 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Use a level between 0 - 5");
	if((!IsPlayerAdmin(playerid) && USERINFO[playerid][plevel] != 5 && level == 5)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't give level 5 to anyone unless you are RCON admin or another level 5 Admin");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is not spawned yet");
	USERINFO[id][plevel] = level;
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}Admin %s has set your Admin level to %d", PlayerName(playerid), level);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}You have set %s's Admin level to %d", PlayerName(id), level);
	SendClientMessage(playerid, -1, str);
	adm_id[id] = GetFreeAdminID();
	WriteLog(LOG_ADMINLVLCHANGES, "Level Giver: %s | Level Reciever: %s | Level: %d", PlayerName(playerid), PlayerName(id), level);
	return 1;
}

CMD:setvip(playerid, params[])
{
	new id, str[128]; 
	if(USERINFO[playerid][plevel] < 4 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF69B4}/setvip <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(id == playerid && (!IsPlayerAdmin(playerid) || USERINFO[playerid][plevel] < 5)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command on you");
	if(USERINFO[playerid][VIP] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}The entered player is a VIP already");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is not spawned yet");
	USERINFO[playerid][VIP] = 1;
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}An admin has set you as a VIP", PlayerName(playerid));
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}You have set %s as a VIP", PlayerName(id));
	SendClientMessage(playerid, -1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND:setvip | Admin: %s | VIP Reciever: %s", PlayerName(playerid), PlayerName(id));
	return 1;
}

CMD:kick(playerid, params[])
{
	new id, str[128], reason[128];
	if(USERINFO[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "us[128]", id, reason)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/kick <id> <reason>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(id == playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You cannot use this command on you");
	if(USERINFO[id][plevel] >= USERINFO[playerid][plevel]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player you entered is at the same level or a higher level than you");
	format(str,sizeof(str), "{006400}[ Info ] {00FF00}You kicked \"%s[i]\" from the server", PlayerName(id), id);
	SendClientMessage(playerid, -1, str);
	format(str, sizeof(str), "{FF8000}* \"%s[%d]\" kicked from the server by an Admin (%s)", PlayerName(id), id, reason);
	SendClientMessageToAll_(-1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: Kick | Admin: %s | Affected: %s | Reason: %s", PlayerName(playerid), PlayerName(id), reason);
	Kick(id); 
	return 1;
}

CMD:clearchat(playerid, params[])
{
	if(USERINFO[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	for(new i = 0; i < 100; i++)
	{
		SendClientMessageToAll_(-1, "");
	}
	WriteLog(LOG_ADMINACTIONS, "COMMAND: Clearchat(CC) | Admin: %s | Affected: All ", PlayerName(playerid));    
	return 1;
}

CMD:cc(playerid, params[])
{
	return PC_EmulateCommand(playerid, "/clearchat");
}

CMD:report(playerid, params[])
{
	new id, reason[128], str[128], dcc_report[400];
	if(sscanf(params,"us[128]", id, reason)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/report <id> <reason>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(id == playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You cant report yourself");
	new ReportRandoms[][] = 
	{
		"`@everyone` WAKE UP!!!, A report is here!!! :confused:",
		"`@everyone` Oh no no no!! a report? again? shuhh!!! :sweat:",
		"`@everyone` GameOvr should develop the anti-cheat system :smile:",
		"`@everyone` Actually I was thinking that why these guys arn't intelligent enough to use cheats without getting cought! :sweat_smile:",
		"`@everyone` You guys have to take care about this guy!. He doesn't know that we are monitoring him! :smirk:",
		"`@everyone` Time to launch the mission `Protect LGGW`! :joy:. Nah! I'm serious! :angry:"
	};
	new Rand = random(sizeof(ReportRandoms));
	DCC_SendChannelMessage(dcc_channel_reports, ReportRandoms[Rand]);
	SendToAdmins(-1, "----------------- REPORT -----------------", 1);
	strcat(dcc_report, "```----------------- REPORT -----------------\n", sizeof(dcc_report));
	strcat(dcc_report, str, sizeof(dcc_report));
	strcat(dcc_report, "\n", sizeof(dcc_report));
	format(str, sizeof(str), "Reporter: %s[%d]", PlayerName(playerid), playerid);
	SendToAdmins(-1, str, 1);
	strcat(dcc_report, str, sizeof(dcc_report));
	strcat(dcc_report, "\n", sizeof(dcc_report));
	format(str, sizeof(str), "Rule breaker: %s[%d]", PlayerName(id), id);
	SendToAdmins(-1, str, 1);
	strcat(dcc_report, str, sizeof(dcc_report));
	strcat(dcc_report, "\n", sizeof(dcc_report));
	format(str, sizeof(str), "Reason: %s", reason);
	SendToAdmins(-1, str, 1);
	strcat(dcc_report, str, sizeof(dcc_report));
	strcat(dcc_report, "\n", sizeof(dcc_report));
	SendToAdmins(-1, "------------------------------------------", 1);
	strcat(dcc_report, "------------------------------------------```", sizeof(dcc_report));
	DCC_SendChannelMessage(dcc_channel_reports, dcc_report);
	GameTextForAdmins("~r~new report recieved from a player", 5000, 5);
	WriteLog(LOG_REPORTS, "Reporter: %s | RuleBreaker: %s | Reason: %s", PlayerName(playerid), PlayerName(id), reason);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}Your report against \"%s\" has been sent to online Admins in the SERVER and DISCORD!", PlayerName(id));
	SendClientMessage(playerid, -1, str);
	return 1;
}

CMD:veh(playerid, params[])
{
	new car, color1, color2; 
	new Float:X, Float:Y, Float:Z;
	new Float:fa;
	GetPlayerFacingAngle(playerid, fa);
	GetPlayerPos(playerid, X, Y, Z);
	if(USERINFO[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "iD(-1)D(-1)", car, color1, color2)) 
	{
		SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/veh <id> <colour 1> <colour 2>");
		return SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}The parts in <put a color here> are optional, You can leave them if you want");
	}
	if(car < 400 || car > 611) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid vehicle ID");
	if(color1 > 255 || color2 > 255) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid colour ID");
	if(adminveh[playerid] != INVALID_VEHICLE_ID)
	{ 
		DestroyVehicle(adminveh[playerid]); 
		adminveh[playerid] = INVALID_VEHICLE_ID;
	}
	adminveh[playerid] = CreateVehicle(car, X, Y, Z, fa, color1, color2, -1); 
	SetVehicleVirtualWorld(adminveh[playerid], GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(adminveh[playerid], GetPlayerInterior(playerid));
	PutPlayerInVehicle(playerid, adminveh[playerid], 0); 
	WriteLog(LOG_ADMINACTIONS, "COMMAND: Clearchat(CC) | Admin: %s | Affected: Self", PlayerName(playerid));    
	return 1;
}

CMD:ban(playerid, params[])
{
	new id, str[128], reason[128];
	if(USERINFO[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "us[128]", id, reason)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/ban <id> <reason>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(id == playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You cannot use this command on you");
	if(USERINFO[id][plevel] >= USERINFO[playerid][plevel]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player you entered is at the same level or a higher level than you");
	format(str,sizeof(str), "{006400}[ Info ] {00FF00}You Banned \"%s[i]\" from the server", PlayerName(id), id);
	SendClientMessage(playerid, -1, str);
	format(str, sizeof(str), "{FF8000}* \"%s[%d]\" Banned from the server by an Admin (%s)", PlayerName(id), id, reason);
	SendClientMessageToAll_(-1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: Ban | Admin: %s | BannedPlayer: %s | Reason: %s", PlayerName(playerid), PlayerName(id), reason);
	WriteLog(LOG_BANS, "Admin: %s | BannedPlayer: %s | BanType: Online Ban | Reason: %s", PlayerName(playerid), PlayerName(id), reason);
	BanPlayer(PlayerName(id));
	return 1;
}

CMD:oban(playerid, params[])
{
	new name[MAX_PLAYER_NAME], str[128], reason[128];
	if(USERINFO[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params,"s["#MAX_PLAYER_NAME"]s[128]", name, reason)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/oban <name> <reason>");
	mysql_format(Database, str, sizeof(str), "SELECT * FROM Users WHERE `Name` = '%e' LIMIT 1", name);
	new Cache:cache = mysql_query(Database, str);
	if(!cache_num_rows()) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player name (There's no such player registered)");
	if(isequal(name, PlayerName(playerid))) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You cannot use this command on you");
	if(IsPlayerBanned(name)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player you entered is already banned");
	SaveServerData();
	cache_set_active(cache);
	new lvl;
	cache_get_value_name_int(0, "Level", lvl);
	cache_unset_active();
	cache_delete(cache);
	if(lvl >= USERINFO[playerid][plevel]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player you entered is at the same level or a higher level than you");
	foreach(new i : Player) if(isequal(PlayerName(i), name)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player you entered is connected use /ban instead");
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}You banned \"s\" from the server", name);
	SendClientMessage(playerid, -1, str);
	format(str, sizeof(str), "{FF8000}* \"%s\" banned from the server by an admin (%s)", name, reason);
	SendClientMessageToAll_(-1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: Oban | Admin: %s | BannedPlayer: %s | Reason: %s", PlayerName(playerid), name, reason);
	WriteLog(LOG_BANS, "Admin: %s | BannedPlayer: %s | BanType: Offline Ban | Reason: %s", PlayerName(playerid), name, reason);
	BanPlayer(name, false);
	return 1;
}

CMD:unban(playerid, params[])
{   
	new name[MAX_PLAYER_NAME], str[256];
	if(USERINFO[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "s["#MAX_PLAYER_NAME"]", name)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/unban <name>");
	mysql_format(Database, str, sizeof(str), "SELECT * FROM Users WHERE `Name` = %e LIMIT 1", name);
	mysql_query(Database, str);
	if(!cache_num_rows()) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player name (There's no such player registered)");
	if(isequal(name, PlayerName(playerid))) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You cannot use this command on you");
	if(!IsPlayerBanned(name)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player you entered is not banned");
	UnbanPlayer(name);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}You unbanned \"%s\" from the server", name);
	SendClientMessage(playerid, -1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: unban | Admin: %s | Affected: %s", PlayerName(playerid), name);    
	return 1;
} 

/*CMD:rban(playerid, params[])
{
	return 1;      GiveError
}

CMD:orban(playerid, params[])
{
	return 1; 	   GiveError
}*/

CMD:freeze(playerid, params[])
{
	new id, str[128];
	if(USERINFO[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/freeze <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(id == playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You cannot use this command on you");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is not spawned yet");
	if(USERINFO[id][plevel] >= USERINFO[playerid][plevel]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player you entered is at the same level or a higher level than you");
	if(frozen[id] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is already frozen");
	TogglePlayerControllable(id, 0);
	GameTextForPlayer(id, "~r~frozen", 5000, 5);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}You froze \"%s\"", PlayerName(id));
	SendClientMessage(playerid, -1, str);
	SendClientMessage(id, -1, "{006400}[ Info ] {00FF00}You have been frozen by an admin");
	frozen[id] = 1;
	nocmd[id] = 1;
	WriteLog(LOG_ADMINACTIONS, "COMMAND: freeze | Admin: %s | Affected: %s", PlayerName(playerid), PlayerName(id));    
	return 1;
}

CMD:unfreeze(playerid, params[])
{
	new id, str[128];
	if(USERINFO[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/unfreeze <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(id == playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You cannot use this command on you");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is not spawned yet");
	if(USERINFO[id][plevel] >= USERINFO[playerid][plevel]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player you entered is at the same level or a higher level than you");
	if(frozen[id] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player isn't frozen");
	TogglePlayerControllable(id, 1);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}You unfroze \"%s\"", PlayerName(id));
	SendClientMessage(playerid, -1, str);
	SendClientMessage(id, -1, "{006400}[ Info ] {00FF00}You have been unfrozen by an Admin");
	frozen[id] = 0;
	nocmd[id] = 0;
	WriteLog(LOG_ADMINACTIONS, "COMMAND: unfreeze | Admin: %s | Affected: %s", PlayerName(playerid), PlayerName(id)); 
	return 1;
}

CMD:get(playerid, params[])
{
	new id, int, vw, str[128];
	new Float:X, Float:Y, Float:Z;  
	if(USERINFO[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params,"u", id)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/get <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(id == playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command on you");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is not spawned yet");
	if(USERINFO[playerid][plevel] <= USERINFO[id][plevel]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}The person you are using the command is at the same or higher level");
	GetPlayerPos(playerid, X, Y, Z);
	int = GetPlayerInterior(playerid);
	vw = GetPlayerVirtualWorld(playerid);
	SetPlayerVirtualWorld(id, vw);
	SetPlayerInterior(id, int);
	SetPlayerPos(id, X+1 , Y+1, Z+1);
	format(str, sizeof(str) , "{006400}[ Info ] {00FF00}You have teleported \"%s\" to your location", PlayerName(id));
	SendClientMessage(playerid, -1, str);
	SendClientMessage(id, -1, "{006400}[ Info ] {00FF00}You have been teleported by an admin");
	WriteLog(LOG_ADMINACTIONS, "COMMAND: get | Admin: %s | Affected: %s", PlayerName(playerid), PlayerName(id)); 
	return 1;
}

CMD:goto(playerid, params[])
{
	new id, int, vw, str[128];
	new Float:X, Float:Y, Float:Z;  
	if(USERINFO[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params,"u", id)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/goto <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(id == playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command on you");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is not spawned yet");
	GetPlayerPos(id, X, Y, Z);
	int = GetPlayerInterior(id);
	vw = GetPlayerVirtualWorld(id);
	SetPlayerVirtualWorld(playerid, vw);
	SetPlayerInterior(playerid, int);
	SetPlayerPos(playerid, X , Y, Z);
	format(str, sizeof(str) , "{006400}[ Info ] {00FF00}You have teleported to %s's location", PlayerName(id));
	SendClientMessage(playerid, -1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: goto | Admin: %s | Affected: %s", PlayerName(playerid), PlayerName(id)); 
	return 1;
}

CMD:setpass(playerid, params[])
{
	new name[MAX_PLAYER_NAME], pass[40], str[128], buf[129], playerconnected = 0;
	if(USERINFO[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "s["#MAX_PLAYER_NAME"]s[128]", name, pass)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/setpass <name> <password>");
	mysql_format(Database, str, sizeof(str), "SELECT * FROM Users WHERE `Name` = '%e' LIMIT 1", name);
	mysql_query(Database, str);
	if(!cache_num_rows()) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player name (There's no such player registered)");
	new lvl;
	cache_get_value_name_int(0, "Level", lvl);
	if(USERINFO[playerid][plevel] <= lvl && !isequal(PlayerName(playerid), name)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}The person you are using the command is at the same or higher level");
	if(strlen(pass) < 5) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Password must include atleast 5 characters");
	if(strlen(pass) > 20) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Password cannot go over 20 characters");
	foreach(new j : Player)
	{
		if(isequal(PlayerName(j), name))
		{
			WP_Hash(buf, sizeof(buf), pass);
			format(USERINFO[j][ppass], 129, "%s", buf);
			SendClientMessage(j, -1, "{006400}[ Info ] {00FF00}Your password has been changed by an Admin");
			format(str, sizeof(str), "{006400}[ Info ] {00FF00}Your new password: %s", pass);
			SendClientMessage(j, -1, str);
			playerconnected = 1;
			break;
		} 
	}
	mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Password` = %s WHERE `Name` = %e LIMIT 1", buf, name);
	mysql_query(Database, str);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}You have set %s's password to a new password succesfully", name);
	SendClientMessage(playerid, -1, str);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}New password of the user: %s", pass);
	SendClientMessage(playerid, -1, str);
	if(playerconnected == 1) SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}Player you entered is connected and the changed password has been sent to him");
	WriteLog(LOG_ADMINACTIONS, "COMMAND: setpass | Admin: %s | Affected: %s", PlayerName(playerid), name); 
	WriteLog(LOG_PASS, "Admin: %s | Affected: %s | Hash: %s", PlayerName(playerid), name, buf); 
	return 1;
}

CMD:setname(playerid, params[])
{
	new oname[MAX_PLAYER_NAME], nname[MAX_PLAYER_NAME], str[128], playerconnected = 0, id = -1;
	if(USERINFO[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "s["#MAX_PLAYER_NAME"]s["#MAX_PLAYER_NAME"]", oname, nname)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/setname <oldname> <newname>");
	mysql_format(Database, str, sizeof(str), "SELECT * FROM Users WHERE `Name` = '%e' LIMIT 1", oname);
	mysql_query(Database, str);
	if(!cache_num_rows()) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player name (There's no such player registered)");
	new lvl;
	cache_get_value_name_int(0, "Level", lvl);
	if(lvl >= USERINFO[playerid][plevel]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}The player you are going to set name is at the same or higher level");
	if(strlen(nname) < 4 || strlen(nname) > 19 ) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}New name of the player must in between 4 - 20 characters");
	if(!IsValidName(nname)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}New name of the player contains invalid characters");
	mysql_format(Database, str, sizeof(str), "SELECT * FROM Users WHERE `Name` = '%e' LIMIT 1", nname);
	mysql_query(Database, str);
	if(cache_num_rows()) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}There's another player with that name already");
	mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Name` = %e WHERE `Name` = %e", nname, oname);
	mysql_query(Database, str);

	foreach(new j : Player)
	{
		if(isequal(PlayerName(j), oname))
		{
			SetPlayerName(j, nname);
			SendClientMessage(j, -1, "{006400}[ Info ] {00FF00}Your name has been changed by an Admin");
			format(str, sizeof(str), "{006400}[ Info ] {00FF00}Your new name: %s", nname);
			SendClientMessage(j, -1, str);
			playerconnected = 1;
			id = j;
			break;
		} 
	}

	format(str, sizeof(str), "{006400}[ Info ] {00FF00}You have set %s's name to a new name succesfully", oname);
	SendClientMessage(playerid, -1, str);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}New name of the user: %s", nname);
	SendClientMessage(playerid, -1, str);

	if(playerconnected == 1)
	{
		SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}Player you entered is connected and the information about name changes has been sent to him");
		if(USERINFO[id][vowned] == 1)
		{
			if(INVALID_VEHICLE_ID != priveh[id])
			{
				Delete3DTextLabel(vehlabel[priveh[id]]);
				format(str, sizeof(str), "{FFFFFF}[Private vehicle]\n{%06x}%s", GetPlayerColor(id) >>> 8, PlayerName(id));
				vehlabel[priveh[id]] = Create3DTextLabel(str, -1, 0.0, 0.0, 0.0, 40.0, 0);
				Attach3DTextLabelToVehicle(vehlabel[priveh[id]], priveh[id], 0.0, 0.0, 1.25);
			}
		}
	}

	WriteLog(LOG_ADMINACTIONS, "COMMAND: setname | Admin: %s | Affected: %s |nnewname: %s", PlayerName(playerid), oname, nname); 
	return 1;
}

CMD:top(playerid, params[])
{
	Dialog_Show(playerid, DIALOG_TOP_SELECTION, DIALOG_STYLE_LIST, "LGGW - Top List", "Top Killers\nTop Weakest\nTop Richest\nTop ratio maintainers\nTop duels won\nTop rampages\nTop robbers\nTop revenges\nTop turf owners\nTop Gangs\nTop Brutal killers\nTop LMS winners\nTop GunGame winners\nTop Head shotters", "Select", "Cancel");  
	return 1;
}

CMD:setkills(playerid, params[])
{
	new id, amount, str[128];
	if(USERINFO[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "ui", id, amount)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/setkills <id> <amount>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is not spawned yet");
	if(USERINFO[playerid][plevel] <= USERINFO[id][plevel] && id != playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}The person you are using the command is at the same or higher level");
	USERINFO[id][pkills] = amount;
	SetPlayerScore(id, amount);
	SendClientMessage(id, -1, "{006400}[ Info ] {00FF00}Your kills has been changed by an Admin");
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}New amount of kills: %d", amount);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}You have changed %s's kills to %d", PlayerName(id), amount);
	SendClientMessage(playerid, -1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: setkills | Admin: %s | Affected: %s | Kills: %d", PlayerName(playerid), PlayerName(id), amount); 
	return 1;
}

CMD:setdeaths(playerid, params[])
{
	new id, amount, str[128];
	if(USERINFO[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "ui", id, amount)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/setdeaths <id> <amount>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is not spawned yet");
	if(USERINFO[playerid][plevel] <= USERINFO[id][plevel] && id != playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}The person you are using the command is at the same or higher level");
	USERINFO[id][pdeaths] = amount;
	SendClientMessage(id, -1, "{006400}[ Info ] {00FF00}Your deaths has been changed by an Admin");
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}New amount of deaths: %d", amount);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}You have changed %s's deaths to %d", PlayerName(id), amount);
	SendClientMessage(playerid, -1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: setdeaths | Admin: %s | Affected: %s | Deaths: %d", PlayerName(playerid), PlayerName(id), amount); 
	return 1;
}

CMD:sethealth(playerid, params[])
{
	new id, amount, str[128];
	if(USERINFO[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "ui", id, amount)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/sethealth <id> <amount>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(amount < 0 || amount > 100) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid health amount");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is not spawned yet");
	if(USERINFO[playerid][plevel] <= USERINFO[id][plevel] && id != playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}The person you are using the command is at the same or higher level");
	SetPlayerHealth(id, amount);
	SendClientMessage(id, -1, "{006400}[ Info ] {00FF00}Your health(HP) has been changed by an Admin");
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}New health(HP): %d", amount);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}You have changed %s's health to %d", PlayerName(id), amount);
	SendClientMessage(playerid, -1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: sethealth | Admin: %s | Affected: %s | Health: %d", PlayerName(playerid), PlayerName(id), amount); 
	return 1;
}

CMD:setarmour(playerid, params[])
{
	new id, amount, str[128];
	if(USERINFO[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "ui", id, amount)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/setarmour <id> <amount>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(amount < 0 || amount > 100) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid armour amount");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is not spawned yet");
	if(USERINFO[playerid][plevel] <= USERINFO[id][plevel] && id != playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}The person you are using the command is at the same or higher level");
	SetPlayerArmour(id, amount);
	SendClientMessage(id, -1, "{006400}[ Info ] {00FF00}Your armour has been changed by an Admin");
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}New armour: %d", amount);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}You have changed %s's armour to %d", PlayerName(id), amount);
	SendClientMessage(playerid, -1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: setarmour | Admin: %s | Affected: %s | Armour: %d", PlayerName(playerid), PlayerName(id), amount); 
	return 1;
}

CMD:givegun(playerid, params[])
{
	new gun, ammo, id, str[128];
	if(USERINFO[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params,"uii", id, gun, ammo)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/givegun <id> <weapon> <ammo>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(gun < 1 || gun > 47) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid weapon ID (use a ID in between 1 - 47)");
	if(ammo < 1 || ammo > 999999) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid ammo amount (use an amount of ammo in between 1 - 999999)");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is not spawned yet");
	GivePlayerWeapon(id, gun, ammo);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}An admin has given you a weapon with ID %d and %d rounds of ammo", GunName(gun), ammo);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}You have given \"%s\" a weapon with ID %d and with %d rounds of ammo", PlayerName(id), GunName(gun), ammo);
	SendClientMessage(playerid, -1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: givegun | Admin: %s | Affected: %s | Gun: %s | Ammo: %d", PlayerName(playerid), PlayerName(id), GunName(gun), ammo); 
	return 1;
}

CMD:agivecash(playerid, params[])
{
	new amount, id, str[128];
	if(USERINFO[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params,"ui", id, amount)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/agivecash <id> <amount>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(amount < 1 || amount > 999999) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid cash amount (use an amount of cash in between $1 - 999999)");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is not spawned yet");
	GivePlayerCash(id, amount);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}An admin has given you $%d", amount);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}You have given \"%s\" $%d", PlayerName(id), amount);
	SendClientMessage(playerid, -1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: agivecash | Admin: %s | Affected: %s | Cash: %d", PlayerName(playerid), PlayerName(id), amount); 
	return 1;
}

CMD:fine(playerid, params[])
{
	new amount, id, str[128];
	if(USERINFO[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params,"ui", id, amount)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/fine <id> <amount>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(amount < 1 || amount > 999999) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid fine cash amount (use an amount of cash in between $1 - 999999)");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is not spawned yet");
	if(USERINFO[playerid][plevel] <= USERINFO[id][plevel] && id != playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}The person you are using the command is at the same or higher level");
	GivePlayerCash(id, -amount);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}An admin has fined you $%d", amount);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}You have fined \"%s\" $%d", PlayerName(id), amount);
	SendClientMessage(playerid, -1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: fine | Admin: %s | Affected: %s | Cash: %s", PlayerName(playerid), PlayerName(id), amount); 
	return 1;
}

CMD:givecash(playerid, params[])
{
	new amount, id, str[128];
	if(sscanf(params,"ui", id, amount)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/givecash <id> <amount>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(amount < 1 || amount > 300000) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid cash amount (use an amount of cash in between $1 - 300000)");
	if(amount > GetPlayerMoney(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You dont have such amount of money to give him");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is not spawned yet");
	if(USERINFO[playerid][ptime] < (3 * 60 * 60)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You need to play atleast 3 hours to use /givecash");
	GivePlayerCash(id, amount);
	GivePlayerCash(playerid, -amount);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}\"%s\" has given you $%d", PlayerName(playerid), amount);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}You have given \"%s\" $%d", PlayerName(id), amount);
	SendClientMessage(playerid, -1, str);
	return 1;
}

CMD:gang(playerid, params[])
{
	if(USERINFO[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command while you are in Admin mode");
	new id, skin, tmp, tmp_1, str[256], gstr[128];
	
	if(sscanf(params, "s[128]D(-1)D(-1)", gstr, tmp, tmp_1)) return PC_EmulateCommand(playerid, "/gang help");

	if(isequal(gstr, "skin", true))
	{
		if(USERINFO[playerid][ingang] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are not in a gang");
		if(tmp == -1) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/gang skin <id>");
		if(GetPlayerMoney(playerid) < MIN_CASH_TO_CHANGE_SKIN) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a vehicle");
		if(GetPlayerSkin(playerid) == tmp) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have this skin");
		skin = tmp;
		switch(skin)
		{
			case 41, 55, 63, 85, 102 .. 110, 114 .. 117, 163 .. 165, 265 .. 267, 269 .. 271, 284 .. 286: return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid skin ID");
			case 23, 24, 29, 34, 100, 122, 133, 169, 185, 188, 216, 219, 225, 250, 261, 306, 211, 223:
			{
				if(USERINFO[playerid][VIP] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}This skin is only for VIPs");
				ClearAnimations(playerid);
				GivePlayerCash(playerid, -MIN_CASH_TO_CHANGE_SKIN);
				USERINFO[playerid][gskin] = skin;
				SetPlayerSkin(playerid, skin);
			}
			default:
			{
				if(skin > 299 || skin < 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid skin ID");
				ClearAnimations(playerid);
				GivePlayerCash(playerid, -MIN_CASH_TO_CHANGE_SKIN);
				USERINFO[playerid][gskin] = skin;
				SetPlayerSkin(playerid, skin);
			}
		}
		if(inminigame[playerid] == 1 && indm[playerid] == 1) SKIN[playerid] = USERINFO[playerid][gskin];
	}
	else if(isequal(gstr, "create", true))
	{
		new con_;
		for(new i = 0; i < MAX_GANGS; i ++)
		{
			if(IsValidGang(i)) con_ ++;
		}

		if(con_ == MAX_GANGS) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Gang slots are full, Ask for the owner to increase slots or Ask for an admin to remove inactive gangs");
		if(USERINFO[playerid][ingang] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a gang");

		if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a minigame");
		if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have participated for Last Man Standing");
		if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are invited for a duel, use /no to refuse or /yes to accept it");
		if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have invited someone for a duel, use /cancel");
		
		if(GetPlayerMoney(playerid) < MIN_CASH_TO_CREATE_A_GANG) 
		{
			format(str, sizeof(str), "{e60000}[ Error ] {FF6347}You don't have enough money to create a gang (Required: $%d)", MIN_CASH_TO_CREATE_A_GANG);
			return SendClientMessage(playerid, -1, str);
		}
		if(GetPlayerScore(playerid) < MIN_SCORE_TO_CREATE_GANG)
		{
			format(str, sizeof(str), "{e60000}[ Error ] {FF6347}You don't have enough score to create a gang (Required: %d)", MIN_SCORE_TO_CREATE_GANG);
			return SendClientMessage(playerid, -1, str);
		} 
		Dialog_Show(playerid, DIALOG_GANG_ENTER_NAME, DIALOG_STYLE_INPUT, "LGGW - Create a gang (Step - 1)", "Insert the name of the gang that you want to create\n\n[ Note ] Name length should in between 6 - 29", "Enter", "Close");
	}
	else if(isequal(gstr, "join", true))
	{
		if(USERINFO[playerid][ingang] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a gang");

		if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a minigame");
		if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have participated for Last Man Standing");
		if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are invited for a duel, use /no to refuse or /yes to accept it");
		if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have invited someone for a duel, use /cancel");

		if(tmp == -1) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/gang join <id>");
		id = tmp;
		if(!IsValidGang(id) || id < 7) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid gang ID");
		new con_, field[20];
		new mem_;
		mysql_format(Database, str, sizeof(str), "SELECT * FROM Gangs WHERE `Gang_ID` = '%d' LIMIT 1", id + 1);
		mysql_query(Database, str);
		for(new i = 0; i < MAX_GANG_MEMBERS; i++)
		{
			format(field, sizeof(field), "Member_%d", i + 1);
			cache_get_value_name_int(0, field, mem_);
			if(mem_ != -1) con_ ++;
		}

		if(con_ == MAX_GANG_MEMBERS) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}This gang is full, Ask Gang founder to kick inactive members");
		reqtimer[playerid] = SetTimerEx("ExpireGangRequest", 120000, false, "i", playerid);
		format(str, sizeof(str), "{006400}[ Info ] {00FF00}Gang request for Gang - '%s[%d]' has been sent (Ask someone of that gang to accept your request)", ReplaceUwithS(GANGINFO[id][gname]), id);
		SendClientMessage(playerid, -1, str);
		grequested[playerid] = 1;
		grequestedid[playerid] = id;
		format(str, sizeof(str), "{6800b3}[ Gang ] {9370DB}'%s[%d]' sent a gang request for your gang (Use /gang accept %d to accept him)", PlayerName(playerid), playerid, playerid);
		foreach( new i : Player)
		{
			if(USERINFO[i][ingang] == 1)
			{
				if(USERINFO[i][gid] == id)
				{
					SendClientMessage(i, -1, str);
				}
			}
		}
	}
	else if(isequal(gstr, "leave", true))
	{
		if(USERINFO[playerid][ingang] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are not in a gang");

		if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a minigame");
		if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have participated for Last Man Standing");
		if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are invited for a duel, use /no to refuse or /yes to accept it");
		if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have invited someone for a duel, use /cancel");

		if(USERINFO[playerid][glevel] < 4)
		{   
			mysql_format(Database, str, sizeof(str), "SELECT * FROM Gangs WHERE `Gang_ID` = '%d' LIMIT 1", USERINFO[playerid][gid] + 1);
			mysql_query(Database, str);

			new field[20], mem;
			for(new i = 0; i < MAX_GANG_MEMBERS; i++)
			{
				
				format(field, sizeof(field), "Member_%d", i + 1);
				cache_get_value_name_int(0, field, mem);
				if(mem == USERINFO[playerid][pid])
				{
					mysql_format(Database, str, sizeof(str), "UPDATE `Gangs` SET `%s` = `-1` WHERE `Gang_ID` = %d LIMIT 1", USERINFO[playerid][gid] + 1);
					mysql_query(Database, str);
					break;
				}
			}

			USERINFO[playerid][glevel] = 0;
			USERINFO[playerid][ingang] = 0;
			USERINFO[playerid][gskin] = 1;
			USERINFO[playerid][gid] = -1;
			SendClientMessage(playerid, -1, "{6800b3}[ Gang ] {9370DB}You have left the gang");
			format(str, sizeof(str), "{6800b3}[ Gang ] {9370DB}%s has left the gang", PlayerName(playerid));
			foreach(new j : Player)
			{
				if(GetPlayerTeam(playerid) == GetPlayerTeam(j) && j != playerid)
				{
					SendClientMessage(j, -1, str);
				}
			}
			ForceClassSelection(playerid);
			SetPlayerHealth(playerid, 0); 
		}
		else return Dialog_Show(playerid, DIALOG_GANG_WARNING, DIALOG_STYLE_MSGBOX, "LGGW - Gang leave warning", "You are the founder of this gang\nIf a gang founder leave a gang it will result in a gang destroy\nYou can overcome gang destroy by appointing someone as gang founder", "Destroy", "Cancel");
	}
	else if(isequal(gstr, "accept", true))
	{
		if(USERINFO[playerid][ingang] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are not in a gang");
		if(USERINFO[playerid][glevel] < 2) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are not authorized to use this command (Required: Warrior level or higher)");

		if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a minigame");
		if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have participated for Last Man Standing");
		if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are invited for a duel, use /no to refuse or /yes to accept it");
		if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have invited someone for a duel, use /cancel");
		
		if(tmp == -1) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/gang accept <id>");
		id = tmp;
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");

		if(inminigame[tmp] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is in a minigame");

		new idog = USERINFO[playerid][gid];
		if(grequested[id] == 0 || grequestedid[id] != idog) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player haven't sent any Gang join requests to your gang");
		SendClientMessage(id, -1, "{6800b3}[ Gang ] {9370DB}You have been accepted");
		USERINFO[id][glevel] = 1;
		USERINFO[id][ingang] = 1;
		USERINFO[id][gskin] = 1;
		USERINFO[id][gid] = idog;
	
		SetPlayerSkin(id, USERINFO[id][gskin]);
		SetPlayerColor(id, GANGINFO[idog][gcolor]);
		SetPlayerTeam(id, idog);
	
		KillTimer(reqtimer[id]);
	
		grequested[playerid] = 0;
		grequestedid[playerid] = -1;
	
		format(str, sizeof(str), "{6800b3}[ Gang ] {9370DB}%s[%d] has joined the gang", PlayerName(id), id);
		foreach( new i : Player)
		{
			if(USERINFO[i][ingang] == 1)
			{
				if(USERINFO[i][gid] == idog)
				{
					SendClientMessage(i, -1, str);
				}
			}
		}

		Delete3DTextLabel(glabel[id]);

		new tag[10];
		format(tag, sizeof(tag), "| %s |", GANGINFO[idog][gtag]);
		glabel[id] = Create3DTextLabel(tag, GANGINFO[idog][gcolor], 30.0, 40.0, 50.0, 50.0, 0);
		Attach3DTextLabelToPlayer(glabel[id], id, 0.0, 0.0, 0.3);

		if(USERINFO[id][vowned] == 1 && priveh[id] != INVALID_VEHICLE_ID)
		{
			Delete3DTextLabel(vehlabel[priveh[id]]); 
			new color = GANGINFO[idog][gcolor];
			format(str, sizeof(str), "[Private vehicle]\n{%06x}%s", color >>> 8, PlayerName(id));
			vehlabel[priveh[id]] = Create3DTextLabel(str, -1, 0.0, 0.0, 0.0, 50.0, 0);
			Attach3DTextLabelToVehicle(vehlabel[priveh[id]], priveh[id], 0.0, 0.0, 1.25);
		}
		new field[20], val;
		mysql_format(Database, str, sizeof(str), "SELECT * FROM Gangs WHERE `Gang_ID` = '%d' LIMIT 1", idog + 1);
		mysql_query(Database, str);

		for(new i = 0; i < MAX_GANG_MEMBERS; i++)
		{
			format(field, sizeof(field), "Member_%d", i + 1);
			cache_get_value_name_int(0, field, val);
			if(val == -1)
			{
				mysql_format(Database, str, sizeof(str), "UPDATE Gangs SET `%s` = %d WHERE `Gang_ID` = '%d' LIMIT 1", field, USERINFO[playerid][pid], idog + 1);
				mysql_query(Database, str);
				break;
			}
		}
	}
	else if(isequal(gstr, "destroy", true))
	{
		if(USERINFO[playerid][ingang] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are not in a gang");
		if(USERINFO[playerid][glevel] < 4) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are not authorized to use this command (Required: Boss level)");

		if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a minigame");
		if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have participated for Last Man Standing");
		if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are invited for a duel, use /no to refuse or /yes to accept it");
		if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have invited someone for a duel, use /cancel");

		new key = USERINFO[playerid][gid];
		
		for(new i = 0; i < sizeof(ZONEINFO); i++)
		{
			if(ZONEINFO[i][zteamid] == key)
			{
				new Rand = random(sizeof(TeamRandoms));
				ZONEINFO[i][zteamid] = TeamRandoms[Rand];
				GangZoneShowForAll(ZONEID[i], Zone_ColorAlpha(GANGINFO[ZONEINFO[i][zteamid]][gcolor]));

				GANGINFO[TeamRandoms[Rand]][gturfs]++;
			}
		}
	   
		if(GANGINFO[key][ghouse] == 1)
		{
			HOUSEINFO[GANGINFO[key][ghouseid]][howned] = 0;
			HOUSEINFO[GANGINFO[key][ghouseid]][hteamid] = -1;
			Delete3DTextLabel(hlabel[GANGINFO[key][ghouseid]]);
			hlabel[GANGINFO[key][ghouseid]] = Create3DTextLabel("{FF6347}[Head Qauters]\n* Unowned", -1, HOUSEINFO[GANGINFO[USERINFO[playerid][gid]][ghouseid]][entercp][0], HOUSEINFO[GANGINFO[USERINFO[playerid][gid]][ghouseid]][entercp][1], HOUSEINFO[GANGINFO[USERINFO[playerid][gid]][ghouseid]][entercp][2], 50.0, 0, 0);
			DestroyDynamicMapIcon(HOUSEINFO[GANGINFO[key][ghouseid]][icon_id]);  
			HOUSEINFO[GANGINFO[key][ghouseid]][icon_id] = CreateDynamicMapIcon(HOUSEINFO[GANGINFO[key][ghouseid]][entercp][0], HOUSEINFO[GANGINFO[key][ghouseid]][entercp][1], HOUSEINFO[GANGINFO[key][ghouseid]][entercp][2], 31, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
		}      

		foreach(new j : Player)
		{
			if(GetPlayerTeam(playerid) == GetPlayerTeam(j))
			{
				USERINFO[j][ingang] = 0;
				USERINFO[j][glevel] = 0;
				USERINFO[j][gskin] = 1;
				USERINFO[j][gid] = -1;
				
				Delete3DTextLabel(glabel[j]);
				ForceClassSelection(j);
				SetPlayerHealth(j, 0);
				SendClientMessage(j, -1, "{006400}[ Info ] {00FF00}Your gang was destroyed by the founder or have been removed by an Admin!");
			}
		}

		format(GANGINFO[key][gname], 30, "%d", -1);
		format(GANGINFO[key][gtag], 6, "%d", -1);

		GANGINFO[key][gcolor] = 0xFFFFFFFF;
		GANGINFO[key][ghouse] = 0;
		GANGINFO[key][ghouseid] = -1;
		GANGINFO[key][gkills] = 0;
		GANGINFO[key][gdeaths] = 0;
		GANGINFO[key][gscore] = 0;
		GANGINFO[key][gturfs] = 0; 

		SaveServerData();

		mysql_format(Database, str, sizeof(str), "SELECT * FROM Gangs WHERE `Gang_ID` = '%d' LIMIT 1", key + 1);
		new Cache:cache = mysql_query(Database, str);
		new mem_id, field[20];
		for(new i = 0; i < MAX_GANG_MEMBERS; i ++)
		{
			cache_set_active(cache);	
			format(field, sizeof(field), "Member_%d", i + 1);	
			cache_get_value_name_int(0, field, mem_id);
			cache_unset_active();

			mysql_format(Database, str, sizeof(str), "UPDATE `Gangs` SET `%s` = -1 WHERE `Gang_ID` = %d LIMIT 1", field, USERINFO[playerid][gid] + 1);
			mysql_query(Database, str);

			mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `In_gang` = 0, `Gang_ID` = -1 WHERE `User_ID` = %d", mem_id);
			mysql_query(Database, str);
		}
		cache_delete(cache);
	}
	else if(isequal(gstr, "house", true))
	{
		new incp, dstr[1024], dialog[1024];
		if(USERINFO[playerid][ingang] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are not in a gang");
		if(USERINFO[playerid][glevel] < 4) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are not authorized to use this command (Required: Boss level)");
		for(new i = 0; i < sizeof(HOUSEINFO); i++)
		{
			if(IsPlayerInDynamicCP(playerid, STREAMER_TAG_CP GENTERCP[i]))
			{
				incp = 1;
				if(GANGINFO[USERINFO[playerid][gid]][ghouse] == 1)
				{
					SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Your gang already has a gang HQ");
					return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Go away from this checkpoint and use '/gang house' to sell your current Gang House");
				}
				strcat(dstr, "                 Gang House - %d                \n\n");
				strcat(dstr, "* You can select options by entering option IDs \n");
				strcat(dstr, "* Use 'preview' to ensure this is the house you \n");
				strcat(dstr, "  want                                          \n");
				strcat(dstr, "* Check out the price before purchase           \n");
				strcat(dstr, "* You will recieve only half of the price if you\n");
				strcat(dstr, "  sell this house after purchase                \n");
				strcat(dstr, "------------------------------------------------\n");
				strcat(dstr, "- Interior type: %s                             \n");
				strcat(dstr, "- Exterior type: %s                             \n");
				strcat(dstr, "- Price: $%d                                    \n");
				strcat(dstr, "------------------------------------------------\n");
				strcat(dstr, "  ID                        Option              \n");
				strcat(dstr, "  1                         Preview             \n"); 
				strcat(dstr, "  2                         Purchase            \n");
				strcat(dstr, "[ Note ] Purchasing action is irreversable      \n");
				format(dialog, sizeof(dialog), dstr, i, HOUSEINFO[i][hinttype], HOUSEINFO[i][hextype], HOUSEINFO[i][hprice]);
				Dialog_Show(playerid, DIALOG_BUY_HOUSE, DIALOG_STYLE_INPUT, "LGGW - Gang House Info & Options", dialog, "Enter", "Close");
				break;
			}
			else incp = 0;
		}
		if(incp == 0)
		{
			if(GANGINFO[USERINFO[playerid][gid]][ghouse] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Go to a Gang House checkpoint and use '/gang house'");
			strcat(dstr, "                Gang House - %d             \n\n");
			strcat(dstr, "              Your Gang House Info          \n"); 
			strcat(dstr, "--------------------------------------------\n");
			strcat(dstr, "- Interior type: %s                         \n");
			strcat(dstr, "- Exterior type: %s                         \n");
			strcat(dstr, "- Price: $%d                                \n");
			strcat(dstr, "--------------------------------------------\n");
			strcat(dstr, "* You will recieve only half of the original\n"); 
			strcat(dstr, "  price if you sell This Gang House         \n");
			strcat(dstr, "* Refund: $%d                               \n\n");
			strcat(dstr, "[ Note ] This action is irreversable          ");
			format(dialog, sizeof(dialog), dstr, GANGINFO[USERINFO[playerid][gid]][ghouseid], HOUSEINFO[GANGINFO[USERINFO[playerid][gid]][ghouseid]][hinttype], HOUSEINFO[GANGINFO[USERINFO[playerid][gid]][ghouseid]][hextype], HOUSEINFO[GANGINFO[USERINFO[playerid][gid]][ghouseid]][hprice], (HOUSEINFO[GANGINFO[USERINFO[playerid][gid]][ghouseid]][hprice] / 2));
			Dialog_Show(playerid, DIALOG_SELL_HOUSE, DIALOG_STYLE_MSGBOX, "LGGW - Gang House Info & Options", dialog, "Sell", "Close");
		}
	}
	else if(isequal(gstr, "color", true))
	{
		if(USERINFO[playerid][ingang] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are not in a gang");
		if(USERINFO[playerid][glevel] < 3) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are not authorized to use this command (Required: Under-Boss level or higher)");
		Dialog_Show(playerid, DIALOG_GANG_COLOR, DIALOG_STYLE_INPUT, "LGGW - Gang Color", "For each color it will cost $50000\n\nID\tColor\n\n{696969}1\tDim Gray\n{2f4f4f}2\tDark Slate Gray\n{f0e68c}3\tKhaki\n{ff0000}4\tRed\n{FF6347}5\tSalmon\n{ff69b4}6\tHot Pink\n{8b4513}7\tSaddle Brown\n{cd853f}8\tPeru\n{b22222}9\tFirebrick\n{9370db}10\tMedium Purple\n{c1cdc1}11\tHoneydew\n{000033}12\tBlackish Blue\n{6495ed}13\tCornflower Blue\n{7cfc00}14\tLawn Green\n{556b2f}15\tDark Olive Green", "Enter", "Close");
	}
	else if(isequal(gstr, "setlevel", true))
	{
		if(tmp == -1 || tmp_1 == -1) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/gang setlevel <id> <level>");
		if(USERINFO[playerid][ingang] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are not in a gang");
		if(USERINFO[playerid][glevel] < 3) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are not authorized to use this command (Required: Under-Boss level or higher)");
		if(!IsPlayerConnected(tmp)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
		if(tmp == playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You cannot use this command on yourself");
		if(USERINFO[tmp][gid] != USERINFO[playerid][gid]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is not in your gang");
		if(USERINFO[playerid][glevel] == USERINFO[tmp][glevel] || USERINFO[playerid][glevel] < USERINFO[tmp][glevel]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}The player you are going to change gang level is in the same level or at a higher level than you");
		if(tmp_1 == -1 || tmp_1 > 3 || tmp_1 < 1) SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Use a level in between 1 - 3, If you want to set the gang Boss Use '/gang setboss'");
		if(USERINFO[tmp][glevel] == tmp_1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is already is already in this level");
		if(USERINFO[tmp][glevel] < tmp_1) format(str, sizeof(str), "{6800b3}[ Gang ] {9370DB}You have been promoted to %s level", GangLevelName(tmp_1));
		else format(str, sizeof(str), "{6800b3}[ Gang ] {9370DB}You have been demoted to %s level", GangLevelName(tmp_1));
		USERINFO[tmp][glevel] = tmp_1;
		SendClientMessage(tmp, -1, str);
		format(str, sizeof(str), "{6800b3}[ Gang ] {9370DB}You have given %s level to %s", GangLevelName(tmp_1), PlayerName(tmp));
		SendClientMessage(playerid, -1, str);
	}
	else if(isequal(gstr, "kick", true))
	{
		if(tmp == -1) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/gang kick <id>");
		if(USERINFO[playerid][ingang] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are not in a gang");
		if(USERINFO[playerid][glevel] < 3) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are not authorized to use this command (Required: Under-Boss level or higher)");
		if(!IsPlayerConnected(tmp)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
		if(tmp == playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You cannot use this command on yourself");
		if(USERINFO[tmp][gid] != USERINFO[playerid][gid]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is not in your gang");
		if(USERINFO[playerid][glevel] == USERINFO[tmp][glevel] || USERINFO[playerid][glevel] < USERINFO[tmp][glevel]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}The player you are going to kick is in the same level or at a higher level than you");
		if(inminigame[tmp]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is currently in a minigame");
		
		USERINFO[tmp][ingang] = 0;
		USERINFO[tmp][glevel] = 0;
		USERINFO[tmp][gskin] = 1;
		USERINFO[tmp][gid] = -1;

		if(USERINFO[tmp][vowned] == 1 && priveh[tmp] != INVALID_VEHICLE_ID)
		{
			DestroyPrivateVehicle(tmp);
		}

		ForceClassSelection(tmp);
		SetPlayerHealth(tmp, 0);

		SendClientMessage(tmp, -1, "{6800b3}[ Gang ] {9370DB}You have been kicked out of the gang");
		format(str, sizeof(str), "{6800b3}[ Gang ] {9370DB}You kicked %s from the gang", PlayerName(tmp));
		SendClientMessage(playerid, -1, str);
	}
	else if(isequal(gstr, "setboss", true))
	{
		if(tmp == -1) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/gang setboss <id>");
		if(USERINFO[playerid][ingang] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are not in a gang");
		if(USERINFO[playerid][glevel] < 4) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are not authorized to use this command (Required: Boss level)");
		if(!IsPlayerConnected(tmp)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
		if(tmp == playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You cannot use this command on yourself");
		if(USERINFO[playerid][gid] != USERINFO[tmp][gid]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is not in your gang");
		USERINFO[playerid][glevel] = 3;
		USERINFO[tmp][glevel] = 4;
		format(str, sizeof(str), "{6800b3}[ Gang ] {9370DB}You have given gang Boss level to %s", PlayerName(tmp));
		SendClientMessage(playerid, -1, str);
		SendClientMessage(playerid, -1, "{6800b3}[ Gang ] {9370DB}You have been demoted to level Under-Boss");
		SendClientMessage(tmp, -1, "{6800b3}[ Gang ] {9370DB}You have been promoted to gang Boss level (Founder level)");
		SendClientMessage(tmp, -1, "{6800b3}[ Gang ] {9370DB}Welcome new Boss!");
		SendClientMessage(tmp, -1, "{6800b3}[ Gang ] {9370DB}If you need any help with developing the gang, Use '/gang help'");
		GameTextForPlayer(tmp, "Congradulations!", 5, 5);
	}
	else if(isequal(gstr, "help", true))
	{
		new dialog[1500];
		strcat(dialog, "{008000}Not in a gang ?\n");
		strcat(dialog, "{00FF00}/gang join  /gangs\n\n") ;
		strcat(dialog, "{008000}Level 1 - Thug\n");
		strcat(dialog, "{00FF00}/gang leave\n\n");
		strcat(dialog, "{008000}Level 2 - Warrior\n");
		strcat(dialog, "{00FF00}/gang accept\n\n");
		strcat(dialog, "{008000}Level 3 - Under-Boss\n");
		strcat(dialog, "{00FF00}/gang color  /gang kick  /gang setlevel\n\n");
		strcat(dialog, "{008000}Level 4 - Boss\n");
		strcat(dialog, "{00FF00}/gang destroy  /gang house  /gang setboss\n\n");
		strcat(dialog, "{008000}Gang colors\n");
		strcat(dialog, "{00FF00}* To have a gang color you have to purchase a color from '/gang color'\n");
		strcat(dialog, "{00FF00}* Other gangs can steal your gang color if they have a higher score than your gang\n\n");
		strcat(dialog, "{008000}Gang score\n");
		strcat(dialog, "{00FF00}* Your gang can earn score by Capturing turfs & Killing players in other gangs\n");
		strcat(dialog, "{00FF00}* Your gang score also will decrease if you loose turfs and die by other gangs\n\n");
		strcat(dialog, "{008000}Other Information\n");
		strcat(dialog, "{00FF00}* Players in the gang will earn cash per every 12 minutes for turfs\n");
		strcat(dialog, "{00FF00}* Use '/t' for the team chat\n");
		strcat(dialog, "{00FF00}* A turf war can be started by standing with 3 players of the gang on an enemy turf\n");
		strcat(dialog, "{00FF00}* Gang score can be earned by turfing & killing players of enemy gangs\n");
		strcat(dialog, "{00FF00}* Gang score will be reduced by 10 if any owned turf lost\n");
		strcat(dialog, "{00FF00}* Minigame kills won't be counted for scores\n");
		strcat(dialog, "{00FF00}* You must go to a Gang house checkpoint before using '/gang house'\n");
		strcat(dialog, "{00FF00}* You can request for a gang backup by using '/backup' or pressing 'H'\n");
		strcat(dialog, "{00FF00}* Inactivity of gang will result in a Gang remove by Administrators");
		Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_MSGBOX, "LGGW - Gang commands & Info", dialog, "Close", "");
	}
	else return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command, Use '/gang help' if any help is needed");
	return 1;
}

CMD:readlogs(playerid, params[])
{
	if(USERINFO[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	Dialog_Show(playerid, DIALOG_LOGS, DIALOG_STYLE_LIST, "LGGW - Logs", "Player connection Log\nPlayer Disconnection Log\nAdmin Promotion Log\nAdmin Actions Log\nBans Log\nReports Log", "Close", "");
	return 1;
}

CMD:jail(playerid, params[])
{
	new id, mins, reason[128], str[128];
	if(USERINFO[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "uis[128]", id, mins, reason)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/jail <id> <minutes> <reason>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(playerid == id) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You cannot use this command on you");
	if(USERINFO[playerid][plevel] <= USERINFO[id][plevel]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}The person you are using the command is at the same or higher level");
	if(mins < 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Don't use a jail time less than 1 minute");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is not spawned yet");
	USERINFO[id][jailed] = 1;
	USERINFO[id][jailtime] = mins * 60;
	SetPlayerPos(id, 264.4176, 77.8930, 1001.0391);
	SetPlayerInterior(id, 6);
	SetPlayerHealth(id, 100);
	GameTextForPlayer(id, "~r~JAILED!", 5000, 5);
	format(str, sizeof(str), "{FF8000}* %s[%d] has been jailed by an Admin for %d minutes (%s)", PlayerName(id), id, mins, reason);
	SendClientMessageToAll_(-1, str);
	nocmd[id] = 1;
	WriteLog(LOG_ADMINACTIONS, "COMMAND: Jail | Admin: %s | Affected: %s | Reason: %s", PlayerName(playerid), PlayerName(id), reason);
	return 1;
} 

CMD:unjail(playerid, params[])
{
	new id;
	if(USERINFO[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/unjail <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(id == playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command on yourself");
	if(USERINFO[id][jailed] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is not under jail");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is not spawned yet");
	USERINFO[id][jailed] = 0;
	USERINFO[id][jailtime] = 0;
	SpawnPlayer(id);
	GameTextForPlayer(id, "~g~UNJAILED!", 5000, 5);
	nocmd[id] = 0;
	WriteLog(LOG_ADMINACTIONS, "COMMAND: Unail | Admin: %s | Affected: %s | Reason: %s", PlayerName(playerid), PlayerName(id));
	return 1;
}

CMD:mute(playerid, params[])
{
	new id, mins, reason[50], str[128];
	if(USERINFO[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "uis[128]", id, mins, reason)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/mute <id> <minutes> <reason>");
	if(playerid == id) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You cannot use this command on you");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(USERINFO[playerid][plevel] <= USERINFO[id][plevel]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}The person you are using the command is at the same or higher level");
	if(mins < 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Don't use a mute time less than 1 minute");
	USERINFO[id][muted] = 1;
	USERINFO[id][mutetime] = mins * 60;
	format(str, sizeof(str), "{FF8000}* %s[%d] has been muted by an Admin for %d minutes (%s)", PlayerName(id), id, mins, reason);
	SendClientMessageToAll_(-1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: Mute | Admin: %s | Affected: %s | Reason: %s", PlayerName(playerid), PlayerName(id), reason);
	return 1;
}

CMD:unmute(playerid, params[])
{
	new id;
	if(USERINFO[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/unmute <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(playerid == id) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You cannot use this command on you");
	if(USERINFO[id][muted] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is not muted");
	USERINFO[id][muted] = 0;
	USERINFO[id][mutetime] = 0;
	SendClientMessage(id, -1, "{006400}[ Info ] {00FF00}You have been unmuted by an Admin");
	WriteLog(LOG_ADMINACTIONS, "COMMAND: Unmute | Admin: %s | Affected: %s", PlayerName(playerid), PlayerName(id));
	return 1;
}

CMD:anim(playerid,params[])
{
	new str[800];
	strcat(str, "Dance 1\nDance 2\nBeach 1\nBeach 2\nCarry 1\nCarry 2\nCarry 3\nCrack 1\nCrack 2\nCrack 3\nDealer 1\nDealer 2\n", sizeof(str));
	strcat(str, "Dildo 1\nDildo 2\nFat 1\nFat 2\nFat 3\nFat 4\nFood\nSmoking\nStrip\nBasketball 1\nBasketball 2\nBasketball 3\n", sizeof(str));
	strcat(str, "Basketball 4\nped 1\nped 2\nped 3\nped 4\nped 5\nped 6\nped 7\nped 8\nRaping 1\nRaping 2\nRaping 3\nRiot 1\n", sizeof(str));
	strcat(str, "Riot 2\nRiot 3\nPiss(/piss)\nWank(/wank)\nBlow Job 1(/bj 1)\nBlow Job 2(/bj 2)\nBlow Job 3(/bj 3)\nBlow Job 4(/bj 4)", sizeof(str));
	Dialog_Show(playerid, DIALOG_ANIM, DIALOG_STYLE_LIST, "LGGW - Animation List", str, "Select", "Close");
	return 1;
}

CMD:piss(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a vehicle");
	inanim[playerid] = 1;
	ApplyAnimation(playerid, "PAULNMAC", "Piss_loop", 4.1, 1, 1, 1, 1, 0);
	foreach(new i : Player)
	{
		if(i != playerid)
		{
			if(IsPlayerFacingPlayer(playerid, i, 4.0))
			{
				new str[128];
				format(str, sizeof(str), "* %s[%d] pisses over %s[%d]", PlayerName(playerid), playerid, PlayerName(i), i);
				SendClientMessageToAll_(-1, str);
				break;
			}
		}
	}
	SetPlayerSpecialAction(playerid, 68);
	return 1;
}

CMD:wank(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a vehicle");
	inanim[playerid] = 1;
	ApplyAnimation(playerid, "PAULNMAC", "wank_loop", 4.1, 1, 1, 1, 1, 0); 
	foreach(new i : Player)
	{
		if(i != playerid)
		{
			if(IsPlayerFacingPlayer(playerid, i, 4.0))
			{
				new str[128];
				format(str, sizeof(str), "* %s[%d] wanks over %s[%d]", PlayerName(playerid), playerid, PlayerName(i), i);
				SendClientMessageToAll_(-1, str);
				break;
			}
		}
	}
	return 1;
}

CMD:bj(playerid, params[])
{
	new id;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/bj <1..4>");
	if(id < 1 || id > 4) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid Blow Job ID");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a vehicle");
	switch(id)
	{
		case 1: ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_LOOP_P",4.1,1,1,1,1,1,1);
		case 2: ApplyAnimation(playerid,"BLOWJOBZ","BJ_STAND_LOOP_W",4.1,1,1,1,1,1,1);
		case 3: ApplyAnimation(playerid,"BLOWJOBZ","BJ_STAND_LOOP_P",4.1,1,1,1,1,1,1);
		case 4: ApplyAnimation(playerid,"BLOWJOBZ","BJ_STAND_LOOP_P",4.1,1,1,1,1,1,1);
	}
	inanim[playerid] = 1;
	return 1; 
}


CMD:medkit(playerid, params[])
{
	if(USERINFO[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command while you are in Admin mode");
	new str[128];
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a minigame");
	if(GetPlayerMoney(playerid) < MIN_CASH_TO_USE_MEDKIT) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money");
	new Float:hp;
	GetPlayerHealth(playerid, hp);
	if(hp == 100) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You already have 100% HP");
	SetPlayerHealth(playerid, 100);
	GivePlayerCash(playerid, -MIN_CASH_TO_USE_MEDKIT);
	format(str, sizeof(str), "* %s healed using a medkit (/medkit)", PlayerName(playerid));
	SendClientMessageToAll_(-1, str);
	return 1;
}

CMD:lms (playerid, params[])
{  
	if(USERINFO[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command while you are in Admin mode");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, 1, "You have already participated for LMS"); 
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a minigame");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are invited for a duel, use /no to refuse or /yes to accept it");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have invited someone for a duel, use /cancel");
	switch(lmsstarted)
	{
		case 1:
		{
			if(lmsjustnow == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Last Man Standing event already started");
			inlms[playerid] = 1;
			SendClientMessage(playerid, 1, "{800080}[ LMS ] {8000FF}You have participated for LMS. Waiting for more players...");
			new str[128];
			format(str, sizeof(str), "{800080}[ LMS ] {8000FF}%s[%d] has participated for Last Man Standing event. Waiting for more players...", PlayerName(playerid), playerid);
			SendClientMessageToAll_(-1, str);
		}
		case 0:
		{
			if(lmsjustnow == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}A Last Man Standing event has started before few minutes, you can start another LMS after few more minutes");
			Dialog_Show(playerid, DIALOG_LMS_PLACE, DIALOG_STYLE_INPUT, "LGGW - Last Man Standing", "ID\tPlace\n\n1\tJefferson Motel\n2\tRC Battlefield\n3\tRussian Mafia Base\n4\tValle Ocultado", "Enter", "Close");
		}
	}
	return 1;
}

CMD:v(playerid, params[])
{
	if(USERINFO[playerid][vowned] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have a private vehicle");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a minigame");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a vehicle");
	if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in an interior");
	if(IsPlayerInRangeOfPoint(playerid, 20.0, 1685.1998,-1460.3500,13.5528)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't spawn the vehicle here! GO AWAY!");
	if(USERINFO[playerid][moving] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Please don't move");
	new Float:X, Float:Y, Float:Z;
	new Float:fa;
	new str[128];
	GetPlayerFacingAngle(playerid, fa); 
	GetPlayerPos(playerid, X, Y, Z); 
	if(priveh[playerid] == INVALID_VEHICLE_ID)
	{
		priveh[playerid] = CreateVehicle(USERINFO[playerid][vmodel], X, Y, Z, fa, USERINFO[playerid][vcolor_1], USERINFO[playerid][vcolor_2], -1);
		PutPlayerInVehicle(playerid, priveh[playerid], 0);
		vehowner[priveh[playerid]] = playerid;
		vehowned[priveh[playerid]] = 1;
		if(USERINFO[playerid][vneon_1] == 1) 
		{
			new Rand = random(sizeof(NeonRandoms));
			vehneon[priveh[playerid]][0] = CreateObject(NeonRandoms[Rand],0,0,0,0,0,0);
			vehneon[priveh[playerid]][1] = CreateObject(NeonRandoms[Rand],0,0,0,0,0,0);
			AttachObjectToVehicle(vehneon[priveh[playerid]][0], priveh[playerid], -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			AttachObjectToVehicle(vehneon[priveh[playerid]][1], priveh[playerid], 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		}
		if(USERINFO[playerid][vneon_2] == 1)
		{
			vehneon[priveh[playerid]][2] = CreateObject(18646,0,0,0,0,0,0);
			AttachObjectToVehicle(vehneon[priveh[playerid]][2], priveh[playerid], 0.0, -0.35, 0.90, 0.0, 0.0, 0.0);
		}
		if(USERINFO[playerid][vhydra] == 1) AddVehicleComponent(priveh[playerid], 1087);
		if(USERINFO[playerid][vnitro] == 1008) AddVehicleComponent(priveh[playerid], 1008);
		if(USERINFO[playerid][vnitro] == 1009) AddVehicleComponent(priveh[playerid], 1009);
		if(USERINFO[playerid][vnitro] == 1010) AddVehicleComponent(priveh[playerid], 1010);
		AddVehicleComponent(priveh[playerid], USERINFO[playerid][vwheel]);
		ChangeVehiclePaintjob(priveh[playerid], USERINFO[playerid][vpjob]);
		format(str, sizeof(str), "{FFFFFF}[Private vehicle]\n{%06x}%s", GetPlayerColor(playerid) >>> 8, PlayerName(playerid));
		vehlabel[priveh[playerid]] = Create3DTextLabel(str, -1, 0.0, 0.0, 0.0, 40.0, 0);
		Attach3DTextLabelToVehicle(vehlabel[priveh[playerid]], priveh[playerid], 0.0, 0.0, 1.25);
		SetVehicleVirtualWorld(priveh[playerid], GetPlayerVirtualWorld(playerid));
	}
	else  
	{
		SetVehiclePos(priveh[playerid], X, Y, Z);
		SetVehicleZAngle(priveh[playerid], fa); 
		PutPlayerInVehicle(playerid, priveh[playerid], 0);
		SetVehicleVirtualWorld(priveh[playerid], GetPlayerVirtualWorld(playerid));
		ChangeVehiclePaintjob(priveh[playerid], USERINFO[playerid][vpjob]);
		ChangeVehicleColor(priveh[playerid], USERINFO[playerid][vcolor_1], USERINFO[playerid][vcolor_2]);
		AddVehicleComponent(priveh[playerid], USERINFO[playerid][vwheel]);
		if(USERINFO[playerid][vhydra] == 1) AddVehicleComponent(priveh[playerid], 1087);
		if(USERINFO[playerid][vnitro] == 1008) AddVehicleComponent(priveh[playerid], 1008);
		if(USERINFO[playerid][vnitro] == 1009) AddVehicleComponent(priveh[playerid], 1009);
		if(USERINFO[playerid][vnitro] == 1010) AddVehicleComponent(priveh[playerid], 1010);
	}
	return 1;
} 

CMD:dm(playerid, params[])
{
	if(USERINFO[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command while you are in Admin mode");
	new dm1, dm2, dm3, dm4, dm5, dm6;
	foreach(new i : Player)
	{
		if(inminigame[i] && indm[i])
		{
			switch(dmid[i])
			{
				case 1: dm1 ++;
				case 2: dm2 ++;
				case 3: dm3 ++;
				case 4: dm4 ++;
				case 5: dm5 ++;
				case 6: dm6 ++;
			}
		}
	}
	new dmstr[300];
	format(dmstr, sizeof(dmstr), "ID\tPlayers\tWeapons\n1\t%d\tDeagle+Sgotgun\n2\t%d\tDeagle+Shotgun+AK47\n3\t%d\tSniper+Spass12\n4\t%d\tMinigun\n5\t%d\tSawnoff+Uzi\n6\t%d\tKnife+Deagle+Shotgun", dm1, dm2, dm3, dm4, dm5, dm6);
	Dialog_Show(playerid, DIALOG_DM, DIALOG_STYLE_TABLIST_HEADERS, "Deathmatches", dmstr, "Join", "Close");
	return 1;
}

CMD:dm1(playerid, params[])
{
	if(USERINFO[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command while you are in Admin mode");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a minigame");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have participated for Last Man Standing");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are invited for a duel, use /no to refuse or /yes to accept it");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have invited someone for a duel, use /cancel");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a vehicle");
	TextDrawShowForPlayer(playerid, DM__[0]);
	TextDrawShowForPlayer(playerid, DM__[1]);
	PlayerTextDrawShow(playerid, DM_1[playerid]);
	PlayerTextDrawSetString(playerid, DM_1[playerid], "~g~kills:_0______________ ~r~deaths:_0______________ ~y~killingspree:_0______________ ~p~ratio:_0.00______________");
	dmkills[playerid] = 0;
	dmdeaths[playerid] = 0;
	dmspree[playerid] = 0;
	GetPlayerDetails(playerid);
	new str[128];
	format(str,sizeof(str),"~y~%s_~w~has_~g~joined_~b~deagle_+_shotgun_~w~DM_(/dm1)",PlayerName(playerid));
	TextDrawSetString(LGGW[1], str);
	SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}Use /exit to leave DM");
	indm[playerid] = 1;
	inminigame[playerid] = 1;
	dmid[playerid] = 1;
	ResetPlayerWeapons(playerid);
	new Rand = random(sizeof(DM1Randoms));
	SetPlayerPos(playerid, DM1Randoms[Rand][0], DM1Randoms[Rand][1], DM1Randoms[Rand][2]);
	SetPlayerFacingAngle(playerid,DM1Randoms[Rand][3]);
	SetPlayerVirtualWorld(playerid, INT_VW);
	SetPlayerInterior(playerid, 0);
	SetPlayerTeam(playerid, NO_TEAM);
	SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 0);
	SetPlayerColor(playerid,COLOR_DM);
	GivePlayerWeapon(playerid, 24, 2000);
	GivePlayerWeapon(playerid, 25, 2000);
	PlayerPlaySound(playerid,1188,0.0,0.0,0.0);
	return 1;
}

CMD:dm2(playerid, params[])
{
	if(USERINFO[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command while you are in Admin mode");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a minigame");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have participated for Last Man Standing");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are invited for a duel, use /no to refuse or /yes to accept it");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have invited someone for a duel, use /cancel");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a vehicle");
	TextDrawShowForPlayer(playerid, DM__[0]);
	TextDrawShowForPlayer(playerid, DM__[1]);
	PlayerTextDrawShow(playerid, DM_1[playerid]);
	PlayerTextDrawSetString(playerid, DM_1[playerid], "~g~kills:_0______________ ~r~deaths:_0______________ ~y~killingspree:_0______________ ~p~ratio:_0.00______________");
	dmkills[playerid] = 0;
	dmdeaths[playerid] = 0;
	dmspree[playerid] = 0;
	GetPlayerDetails(playerid);
	new str[128];
	format(str,sizeof(str),"~y~%s_~w~has_~g~joined_~b~deagle_+_shotgun_+_ak47~w~_DM_(/dm2)",PlayerName(playerid));
	TextDrawSetString(LGGW[1], str);
	SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}Use /exit to leave DM");
	indm[playerid] = 1;
	inminigame[playerid] = 1;
	dmid[playerid] = 2;
	ResetPlayerWeapons(playerid);
	new Rand = random(sizeof(DM2Randoms));
	SetPlayerPos(playerid, DM2Randoms[Rand][0], DM2Randoms[Rand][1], DM2Randoms[Rand][2]);
	SetPlayerFacingAngle(playerid,DM2Randoms[Rand][3]);
	SetPlayerVirtualWorld(playerid, INT_VW);
	SetPlayerInterior(playerid,3);
	SetPlayerTeam(playerid, NO_TEAM);
	SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 0);
	SetPlayerColor(playerid,COLOR_DM);
	GivePlayerWeapon(playerid, 24, 2000);
	GivePlayerWeapon(playerid, 25, 2000);
	GivePlayerWeapon(playerid, 30, 2000);
	PlayerPlaySound(playerid,1188,0.0,0.0,0.0);
	return 1;
}

CMD:dm3(playerid, params[])
{
	if(USERINFO[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command while you are in Admin mode");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a minigame");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have participated for Last Man Standing");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are invited for a duel, use /no to refuse or /yes to accept it");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have invited someone for a duel, use /cancel");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a vehicle");
	TextDrawShowForPlayer(playerid, DM__[0]);
	TextDrawShowForPlayer(playerid, DM__[1]);
	PlayerTextDrawShow(playerid, DM_1[playerid]);
	PlayerTextDrawSetString(playerid, DM_1[playerid], "~g~kills:_0______________ ~r~deaths:_0______________ ~y~killingspree:_0______________ ~p~ratio:_0.00______________");
	dmkills[playerid] = 0;
	dmdeaths[playerid] = 0;
	dmspree[playerid] = 0;
	GetPlayerDetails(playerid);
	new str[128];
	format(str,sizeof(str),"~y~%s_~w~_has_~g~joined_~b~sniper_+_spass12_ ~w~DM_(/dm3)",PlayerName(playerid));
	TextDrawSetString(LGGW[1], str);
	SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}Use /exit to leave DM");
	indm[playerid] = 1;
	inminigame[playerid] = 1;
	dmid[playerid] = 3;
	ResetPlayerWeapons(playerid);
	new Rand = random(sizeof(DM3Randoms));
	SetPlayerPos(playerid, DM3Randoms[Rand][0], DM3Randoms[Rand][1], DM3Randoms[Rand][2]);
	SetPlayerFacingAngle(playerid,DM3Randoms[Rand][3]);
	SetPlayerVirtualWorld(playerid, INT_VW);
	SetPlayerInterior(playerid,18);
	SetPlayerTeam(playerid, NO_TEAM);
	SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 0);
	SetPlayerColor(playerid,COLOR_DM);
	GivePlayerWeapon(playerid, 34, 2000);
	GivePlayerWeapon(playerid, 27, 2000);
	PlayerPlaySound(playerid,1188,0.0,0.0,0.0);
	return 1;
}

CMD:dm4(playerid, params[])
{
	if(USERINFO[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command while you are in Admin mode");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a minigame");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have participated for Last Man Standing");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are invited for a duel, use /no to refuse or /yes to accept it");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have invited someone for a duel, use /cancel");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a vehicle");
	TextDrawShowForPlayer(playerid, DM__[0]);
	TextDrawShowForPlayer(playerid, DM__[1]);
	PlayerTextDrawShow(playerid, DM_1[playerid]);
	PlayerTextDrawSetString(playerid, DM_1[playerid], "~g~kills:_0______________ ~r~deaths:_0______________ ~y~killingspree:_0______________ ~p~ratio:_0.00______________");
	dmkills[playerid] = 0;
	dmdeaths[playerid] = 0;
	dmspree[playerid] = 0;
	GetPlayerDetails(playerid);
	new str[128];
	format(str,sizeof(str),"~y~%s_~w~has_~g~joined_~b~minigun~w~_DM_(/dm4)",PlayerName(playerid));
	TextDrawSetString(LGGW[1], str);
	SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}Use /exit to leave DM");
	indm[playerid] = 1;
	inminigame[playerid] = 1;
	dmid[playerid] = 4;
	ResetPlayerWeapons(playerid);
	new Rand = random(sizeof(DM4Randoms));
	SetPlayerPos(playerid, DM4Randoms[Rand][0], DM4Randoms[Rand][1], DM4Randoms[Rand][2]);
	SetPlayerFacingAngle(playerid,DM4Randoms[Rand][3]);
	SetPlayerVirtualWorld(playerid, INT_VW);
	SetPlayerInterior(playerid,10);
	SetPlayerTeam(playerid, NO_TEAM);
	SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 0);
	SetPlayerColor(playerid,COLOR_DM);
	GivePlayerWeapon(playerid, 38, 2000);
	PlayerPlaySound(playerid,1188,0.0,0.0,0.0);
	return 1;
}

CMD:dm5(playerid, params[])
{
	if(USERINFO[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command while you are in Admin mode");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a minigame");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have participated for Last Man Standing");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are invited for a duel, use /no to refuse or /yes to accept it");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have invited someone for a duel, use /cancel");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a vehicle");
	TextDrawShowForPlayer(playerid, DM__[0]);
	TextDrawShowForPlayer(playerid, DM__[1]);
	PlayerTextDrawShow(playerid, DM_1[playerid]);
	PlayerTextDrawSetString(playerid, DM_1[playerid], "~g~kills:_0______________ ~r~deaths:_0______________ ~y~killingspree:_0______________ ~p~ratio:_0.00______________");
	dmkills[playerid] = 0;
	dmdeaths[playerid] = 0;
	dmspree[playerid] = 0;
	GetPlayerDetails(playerid);
	new str[128];
	format(str,sizeof(str),"~y~%s_~w~has_~g~joined_~b~Sawnoff_+_Uzi~w~_DM_(/dm5)", PlayerName(playerid));
	TextDrawSetString(LGGW[1], str);
	SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}Use /exit to leave DM");
	indm[playerid] = 1;
	inminigame[playerid] = 1;
	dmid[playerid] = 5;
	ResetPlayerWeapons(playerid);
	new Rand = random(sizeof(DM5Randoms));
	SetPlayerPos(playerid, DM5Randoms[Rand][0], DM5Randoms[Rand][1], DM5Randoms[Rand][2]);
	SetPlayerFacingAngle(playerid,DM5Randoms[Rand][3]);
	SetPlayerVirtualWorld(playerid, INT_VW);
	SetPlayerInterior(playerid,1);
	SetPlayerTeam(playerid, NO_TEAM);
	SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 0);
	SetPlayerColor(playerid,COLOR_DM);
	GivePlayerWeapon(playerid, 26, 2000);
	GivePlayerWeapon(playerid, 28, 2000);
	PlayerPlaySound(playerid,1188,0.0,0.0,0.0);
	return 1;
}

CMD:dm6(playerid, params[])
{
	if(USERINFO[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command while you are in Admin mode");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a minigame");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have participated for Last Man Standing");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are invited for a duel, use /no to refuse or /yes to accept it");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have invited someone for a duel, use /cancel");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a vehicle");
	TextDrawShowForPlayer(playerid, DM__[0]);
	TextDrawShowForPlayer(playerid, DM__[1]);
	PlayerTextDrawShow(playerid, DM_1[playerid]);
	PlayerTextDrawSetString(playerid, DM_1[playerid], "~g~kills:_0______________ ~r~deaths:_0______________ ~y~killingspree:_0______________ ~p~ratio:_0.00______________");
	dmkills[playerid] = 0;
	dmdeaths[playerid] = 0;
	dmspree[playerid] = 0;
	GetPlayerDetails(playerid);
	new str[128];
	format(str,sizeof(str),"~y~%s_~w~has_~g~joined_~b~Knife_+_Deagle_+_Shotgun~w~_DM_(/dm6)", PlayerName(playerid));
	TextDrawSetString(LGGW[1], str);
	SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}Use /exit to leave DM");
	indm[playerid] = 1;
	inminigame[playerid] = 1;
	dmid[playerid] = 6;
	ResetPlayerWeapons(playerid);
	new Rand = random(sizeof(DM6Randoms));
	SetPlayerPos(playerid, DM6Randoms[Rand][0], DM6Randoms[Rand][1], DM6Randoms[Rand][2]);
	SetPlayerFacingAngle(playerid,DM6Randoms[Rand][3]);
	SetPlayerVirtualWorld(playerid, INT_VW);
	SetPlayerInterior(playerid, 0);
	SetPlayerTeam(playerid, NO_TEAM);
	SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 0);
	SetPlayerColor(playerid,COLOR_DM);
	GivePlayerWeapon(playerid, 24, 2000);
	GivePlayerWeapon(playerid, 25, 2000);
	GivePlayerWeapon(playerid, 4, 2000);
	PlayerPlaySound(playerid,1188,0.0,0.0,0.0);
	return 1;
}

CMD:exit(playerid, params[])
{
	if(USERINFO[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command while you are in Admin mode");
	if(inminigame[playerid] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are not in a minigame");
	if(induel[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command right now");
	if(ingg[playerid] == 0 && indm[playerid] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are not in a GunGame or a Death Match");
	inminigame[playerid] = 0;
	if(indm[playerid] == 1)
	{
		indm[playerid] = 0;
		ResetPlayerWeapons(playerid);
		SetPlayerDetails (playerid);
		TextDrawHideForPlayer(playerid, DM__[0]);
		TextDrawHideForPlayer(playerid, DM__[1]);
		PlayerTextDrawHide(playerid, DM_1[playerid]);

		new str[128];
		if(dmid[playerid] == 1)
		{
			format(str,sizeof(str),"~y~%s_~w~has_~r~left_~b~deagle_+_shotgun_~w~DM", PlayerName(playerid));
			TextDrawSetString(LGGW[1], str);
		}
		else if(dmid[playerid] == 2)
		{
			format(str,sizeof(str),"~y~%s_~w~has_~r~left_~b~deagle_+_shotgun_+_ak47_~w~DM", PlayerName(playerid));
			TextDrawSetString(LGGW[1], str);
		}
		else if(dmid[playerid] == 3)
		{
			format(str,sizeof(str),"~y~%s_~w~has_~r~left_~b~sniper_+_spass12_~w~DM", PlayerName(playerid));
			TextDrawSetString(LGGW[1], str);
		}
		else if(dmid[playerid] == 4)
		{
			format(str,sizeof(str),"~y~%s_~w~has_~r~left_~b~left minigun_~w~DM", PlayerName(playerid));
			TextDrawSetString(LGGW[1], str);
		}
		else if(dmid[playerid] == 5)
		{
			format(str,sizeof(str),"~y~%s_~w~has_~r~left_~b~sawnoff_+_uzi_~w~DM", PlayerName(playerid));
			TextDrawSetString(LGGW[1], str);
		}
		else if(dmid[playerid] == 6)
		{
			format(str,sizeof(str),"~y~%s_~w~has_~r~left_~b~Knife_+_Deagle_+_Shotgun_~w~DM", PlayerName(playerid));
			TextDrawSetString(LGGW[1], str);
		}
	}
	else if(ingg[playerid] == 1)
	{
		ResetPlayerWeapons(playerid);
		SetPlayerDetails(playerid); 
		ingg[playerid] = 0;
	}
	return 1;
}

CMD:duelsettings(playerid, params)
{
	if(USERINFO[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command while you are in Admin mode");
	if(induel[playerid] == 1 || duelinvited[playerid] == 1 || duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't edit duel settings right now");
	Dialog_Show(playerid, DIALOG_DUEL_PREVIEW, DIALOG_STYLE_LIST, "LGGW - Duel Settings", "Place\nWeapon - 1\nWeapon - 2\nWeapon - 3\nBet", "Select", "Close");
	return 1;
}

CMD:duel(playerid, params[])
{
	if(USERINFO[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command while you are in Admin mode");
	new id;
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have participated for Last Man Standing");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/duel <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if(id == playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You cannot duel yourself");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a minigame");
	if(inminigame[id] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is in a minigame");
	if(GetPlayerMoney(playerid) < USERINFO[playerid][dbet]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to duel, Try changing your duelsettings (/duelsettings)");
	if(GetPlayerMoney(id) < USERINFO[playerid][dbet]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player doesn't have enough money to duel with you");
	if(duelinvited[id] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player has been already invited for a duel");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have been invited by someone for duel, Use /no to cancel or /yes to accept before playing another duel");
	if(duelinviter[id] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player has already invited someone for a duel");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have invited someone for duel, Use /cancel to cancel it before playing another duel");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a vehicle");
	if(IsPlayerInAnyVehicle(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player is in a vehicle");
	duelinvited[id] = 1;
	duelinviter[playerid] = 1;
	enemy[playerid] = id;
	enemy[id] = playerid;
	duelbet[playerid] = USERINFO[playerid][dbet];
	duelbet[id] = USERINFO[playerid][dbet];
	dstimer[playerid] = SetTimerEx("DuelDeadLine", 30000, false, "ii", id, playerid);
	new str[256];
	format(str, sizeof(str), "{004000}[ Duel ] {00FF00}%s has invited you for a duel ( Place: %s | Weapon 1: %s | Weapon 2: %s | Weapon 3: %s | Bet: $%d )", PlayerName(playerid), GetDuelPlaceName(USERINFO[playerid][dplace]), GunName(USERINFO[playerid][dwep1]), GunName(USERINFO[playerid][dwep2]), GunName(USERINFO[playerid][dwep3]), USERINFO[playerid][dbet]);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{004000}[ Duel ] {00FF00}%s has invited you for a duel ( Place: %s | Weapon 1: %s | Weapon 2: %s | Weapon 3: %s | Bet: $%d )", PlayerName(playerid), GetDuelPlaceName(USERINFO[playerid][dplace]), GunName(USERINFO[playerid][dwep1]), GunName(USERINFO[playerid][dwep2]), GunName(USERINFO[playerid][dwep3]), USERINFO[playerid][dbet]);
	SendClientMessage(id, -1, "{004000}[ Duel ] {00FF00}Use /yes to accept or /no to decline");
	format(str, sizeof(str), "{004000}[ Duel ] {00FF00}You have invited %s for a duel ( Place: %s | Weapon 1: %s | Weapon 2: %s | Weapon 3: %s | Bet: $%d )", PlayerName(id), GetDuelPlaceName(USERINFO[playerid][dplace]), GunName(USERINFO[playerid][dwep1]), GunName(USERINFO[playerid][dwep2]), GunName(USERINFO[playerid][dwep3]), USERINFO[playerid][dbet]);
	SendClientMessage(playerid, -1, str);
	SendClientMessage(playerid, -1, "{004000}[ Duel ] {00FF00}Use /cancel to cancel the duel");
	return 1; 
}

CMD:cancel(playerid, params[])
{
	if(USERINFO[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command while you are in Admin mode");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a minigame");
	if(duelinviter[playerid] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You haven't invited anyone for a duel");
	new id = enemy[playerid];
	duelinviter[playerid] = 0;
	duelinvited[id] = 0;
	new str[128];
	format(str, sizeof(str), "{004000}[ Duel ] {00FF00}%s cancelled duel with you", PlayerName(playerid));
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{004000}[ Duel ] {00FF00}You cancelled duel with %s", PlayerName(id));
	SendClientMessage(playerid, -1, str);
	KillTimer(dstimer[playerid]);
	return 1;
}

CMD:yes(playerid, params[])
{
	if(USERINFO[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command while you are in Admin mode");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You have participated for Last Man Standing");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a minigame");
	if(duelinvited[playerid] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have any duel requests");
	new id = enemy[playerid], str[200];
	if(GetPlayerMoney(playerid) < USERINFO[id][dbet]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You don't have enough money to duel (you have spent your money after recieving the duel request)");
	if(GetPlayerMoney(id) < USERINFO[id][dbet]) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Duel sender doesn't have enough money to duel with you (he has spent some money after sending the duel request to you)");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a vehicle");
	if(IsPlayerInAnyVehicle(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Duel sender is in a vehicle");
	KillTimer(dstimer[id]);
	induel[id] = 1;
	induel[playerid] = 1;
	inminigame[id] = 1;
	inminigame[playerid] = 1;
	USERINFO[playerid][dplayed]++;
	USERINFO[id][dplayed]++;
	format(str, sizeof(str),"{004000}[ Duel ] {00FF00}Duel between %s and %s started ( Place: %s | Weapon 1: %s | Weapon 2: %s | Weapon 3: %s | Bet: $%d )",  PlayerName(id), PlayerName(playerid), GetDuelPlaceName(USERINFO[id][dplace]), GunName(USERINFO[id][dwep1]), GunName(USERINFO[id][dwep1]), GunName(USERINFO[id][dwep1]), USERINFO[id][dbet]);
	SendClientMessageToAll_(-1, str);
	GetPlayerDetails(playerid);
	ResetPlayerWeapons(playerid);
	SetPlayerColor(playerid, COLOR_DUEL);
	SetPlayerTeam(playerid, NO_TEAM);
	SetPlayerHealth(playerid, 100.0);
	SetPlayerArmour(playerid, 0);
	SetPlayerVirtualWorld(playerid, playerid + 1);
	GivePlayerWeapon(playerid, USERINFO[id][dwep1], 2000);
	GivePlayerWeapon(playerid, USERINFO[id][dwep2], 2000);
	GivePlayerWeapon(playerid, USERINFO[id][dwep3], 2000);
	PlayerPlaySound(playerid,1068,0.0,0.0,0.0);
   
	GetPlayerDetails(id);
	ResetPlayerWeapons(id);
	SetPlayerArmour(id, 0);
	SetPlayerHealth(id, 100.0);
	SetPlayerTeam(id, NO_TEAM);
	SetPlayerColor(id, COLOR_DUEL);
	SetPlayerVirtualWorld(id, playerid + 1);
	GivePlayerWeapon(id, USERINFO[id][dwep1], 2000);
	GivePlayerWeapon(id, USERINFO[id][dwep2], 2000);
	GivePlayerWeapon(id, USERINFO[id][dwep3], 2000);
	PlayerPlaySound(id,1068,0.0,0.0,0.0);

	if(USERINFO[id][dplace] == 0)
	{
		SetPlayerPos(playerid, 1381.1675,2183.3015,11.0234);
		SetPlayerFacingAngle(playerid, 313.4774);
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(id, 1326.5436,2126.2871,11.0156);
		SetPlayerFacingAngle(id, 132.1626);
		SetPlayerInterior(id, 0);
	}
	if(USERINFO[id][dplace] == 1)
	{
		SetPlayerPos(playerid, 1412.4567,-18.6115,1000.9243);
		SetPlayerFacingAngle(playerid, 266.9549);
		SetPlayerInterior(playerid, 1);
		SetPlayerPos(id, 1364.3143,-20.4402,1000.9219);
		SetPlayerFacingAngle(id, 90.7137);
		SetPlayerInterior(id, 1);
	}
	if(USERINFO[id][dplace] == 2)
	{
		SetPlayerPos(playerid, -1130.0868,1057.8641,1346.4141);
		SetPlayerFacingAngle(playerid, 270.7783);
		SetPlayerInterior(playerid, 10);
		SetPlayerPos(id, -976.6179,1061.0818,1345.6719);
		SetPlayerFacingAngle(id, 90.1922);
		SetPlayerInterior(id, 10);
	}
	if(USERINFO[id][dplace] == 3)
	{
		SetPlayerPos(playerid, -1451.7310,994.0298,1024.3093);
		SetPlayerFacingAngle(playerid, 91.2436);
		SetPlayerInterior(playerid, 15);
		SetPlayerPos(id, -1344.3348,999.5040,1024.2615);
		SetPlayerFacingAngle(id, 276.3602);
		SetPlayerInterior(id, 15);
	}
	return 1;
}

CMD:no(playerid, params[])
{
	if(USERINFO[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command while you are in Admin mode");
	new id = enemy[playerid];
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a minigame");
	if(duelinvited[playerid] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You haven't invited for a duel");
	duelinvited[playerid] = 0;
	duelinviter[id] = 0;
	new str[128];
	format(str, sizeof(str), "{004000}[ Duel ] {00FF00}You refused %s's duel request", PlayerName(id));
	SendClientMessage(playerid, -1, str);
	format(str, sizeof(str), "{004000}[ Duel ] {00FF00}%s refused your duel request", PlayerName(playerid));
	SendClientMessage(id, -1, str);
	KillTimer(dstimer[id]);
	return 1;
}

CMD:t(playerid, params[])
{
	new text[256], str[256 + 50];
	if(USERINFO[playerid][muted] == 1)
	{
		format(str, sizeof(str), "{e60000}[ Error ] {FF6347}You can't talk while you are muted (Remaining time: %d seconds)", USERINFO[playerid][mutetime]);
		SendClientMessage(playerid, -1, str);
	} 
	if(sscanf(params,"s[128]", text)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/t <text>");
	foreach(new j : Player)
	{
		if(USERINFO[j][gid] == USERINFO[playerid][gid])
		{
			format(str, sizeof(str), "{00FF00}TeamMsg '/t <text>' | %s[%d]: %s", PlayerName(playerid), playerid, text);
			SendClientMessage(j, -1, str);
		}
	}
	return 1;
}

CMD:kill(playerid, params[])
{
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in a minigame");
	if(killinginprogress[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Wait a while to use this command again");
	if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are in an interior");
	if(GetPlayerWeapon(playerid) == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You must have a weapon in your hand to kill yourself");
	SetTimerEx("KillMe", 8000, false, "i", playerid);
	SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}Wait a while to suicide");
	ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.1, 1, 0, 0, 0, 0);
	killinginprogress[playerid] = 1;
	return 1;
}

CMD:rules(playerid, params[])
{
	new dialog[1500];
	strcat(dialog, "The ten things you should do to maintain your respect in the server. Stay within them and enjoy the maximum...\n\n");
	strcat(dialog, "1. RESCPECT.RESPECT..RESPECT... It's quites simple. Respect everyone never mind who they are.\n");
	strcat(dialog, "2. Avoid childish behaviors such as spamming, flooding, insulting and advertising.\n");
	strcat(dialog, "3. DO NOT use other languages in the main chat.\n");
	strcat(dialog, "4. Avoid using any type hacks or modifications that will benifit you.\n");
	strcat(dialog, "5. DO NOT abuse server bugs. Report us if you find any.\n");
	strcat(dialog, "6. DO NOT Try to protect hackers or rule breakers. Always use /report if you spot them.\n");
	strcat(dialog, "8. Avoid spawn killing.\n");
	strcat(dialog, "9. Evading stuff is strictly prohibited.\n");
	strcat(dialog, "10. The staff's descision is the last descision. Always obey them.\n\n");
	strcat(dialog, "Our staff doesn't like punishing. But violation of one or more of the above rules is a punishable offense.");
	Dialog_Show(playerid, DIALOG_RULES, DIALOG_STYLE_MSGBOX,"LGGW - Rules", dialog, "Accept", "Decline");
	return 1;
}

CMD:backup(playerid, params[])
{
	if(USERINFO[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't use this command while you are in Admin mode");
	if(inminigame[playerid] == 1) SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't request for backup while you are in a minigame");
	new str[128];
	format(str, sizeof(str), "{6800b3}[ Gang ] {9370DB}%s is requesting for a gang backup (Location: %s)", PlayerName(playerid), GetPlayerZone(playerid));
	foreach(new j : Player)
	{
		if(GetPlayerTeam(playerid) == GetPlayerTeam(j) || USERINFO[playerid][gid] == USERINFO[j][gid]) SendClientMessage(j, -1, str);
	}
	return 1;
}

CMD:onduty(playerid, params[])
{
	if(USERINFO[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You can't switch to Admin mode in Minigames");
	if(USERINFO[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are already in Admin mode");
	if(!IsPlayerSpawned(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are not spawned yet");
	USERINFO[playerid][onduty] = 1;
	GetPlayerDetails(playerid);
	Delete3DTextLabel(glabel[playerid]);
	alabel[playerid] = Create3DTextLabel("{800080}[ Don't shoot ]\n{9370DB}Admin on duty !", -1, 0.0, 0.0, 0.0, 50, 0);
	Attach3DTextLabelToPlayer(alabel[playerid], playerid, 0.0, 0.0, 0.35);
	SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You are now on Admin mode");
	SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}Don't kill any player in the server with no reason");
	SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}Each an every inch of your actions will be logged");
	SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 0);
	SetPlayerSkin(playerid, 294);
	SetPlayerColor(playerid, COLOR_ADMIN);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 38, 999999); 
	SetPlayerTeam(playerid, TEAM_ADMIN);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: onduty | Admin: %s", PlayerName(playerid));
	return 1;
}

CMD:offduty(playerid, params[])
{
	if(USERINFO[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(USERINFO[playerid][onduty] == 0) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are already in Playing mode");
	if(!IsPlayerSpawned(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}You are not spawned yet");
	USERINFO[playerid][onduty] = 0;
	Delete3DTextLabel(alabel[playerid]);
	new lstr[50];
	format(lstr, sizeof(lstr), "| %s |", GANGINFO[USERINFO[playerid][gid]][gtag]);
	glabel[playerid] = Create3DTextLabel(lstr, GANGINFO[USERINFO[playerid][gid]][gcolor], 0.0, 0.0, 0.0, 50,0);
	Attach3DTextLabelToPlayer(glabel[playerid], playerid, 0.0, 0.0, 0.3);
	SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}You are now on Playing mode");
	ResetPlayerWeapons(playerid);
	for(new k = 0; k < sizeof(WEAPS[][]); k++)
	{
		GivePlayerWeapon(playerid, WEAPS[playerid][0][k], WEAPS[playerid][1][k]);
	}
	SetPlayerTeam(playerid, TEAM[playerid]);
	SetPlayerInterior(playerid, INT[playerid]);
	SetPlayerVirtualWorld(playerid, VW[playerid]);
	SetPlayerHealth(playerid, HP[playerid]);
	SetPlayerArmour(playerid, ARMOUR[playerid]);
	SetPlayerColor(playerid, COLOR[playerid]);
	SetPlayerSkin(playerid, SKIN[playerid]);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: offduty | Admin: %s", PlayerName(playerid));
	return 1;
}

CMD:spawn(playerid, params[])
{
	new id, str[128];
	if(USERINFO[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/spawn <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	format(str, sizeof(str), "You spawned %s[%d]", PlayerName(id), id);
	SendClientMessage(playerid, -1, str);
	SendClientMessage(id, -1, "You were spawned by an Admin");
	SpawnPlayer(id);
	return 1;
}

CMD:a(playerid, params[])
{
	new text[150], str[170];
	if(USERINFO[playerid][muted] == 1)
	{
		format(str, sizeof(str), "{e60000}[ Error ] {FF6347}You can't talk while you are muted (Remaining time: %d seconds)", USERINFO[playerid][mutetime]);
		SendClientMessage(playerid, -1, str);
	} 
	if(USERINFO[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "s[256]", text)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/a <text>");
	format(str, sizeof(str), "{000000}[ *** ] {C0C0C0}(%d)_Admin: {0080C0}%s", adm_id[playerid], text);
	SendClientMessageToAll_(-1, str);
	return 1;
}

CMD:getip(playerid, params[])
{
	new id, str[50];
	if(USERINFO[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/getip <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	format(str, sizeof(str), "%s's current IP --> %s", PlayerName(id), PlayerIP(id));
	SendClientMessage(playerid, -1, str);
	SendClientMessage(playerid, -1, "{006400}[ Info ] {00FF00}Use '/getips' to see all connected IPs of a player");
	WriteLog(LOG_ADMINACTIONS, "COMMAND: getip | Admin: %s | Affected: %s", PlayerName(playerid), PlayerName(id));
	return 1;
}

/*CMD:aka(playerd, params[])
{
	new name[MAX_PLAYER_NAME], names[50][MAX_PLAYER_NAME], pass[256];
	if(USERINFO[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "s["#MAX_PLAYER_NAME"]", name)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/akill <name >");
	new key = DB_RetrieveKey(user_table, "", 0, "Name", name);
	if(key == DB_INVALID_KEY) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player name (There's no such player registered)");
	new lvl = DB_GetIntEntry(user_table, key, "Level");
	if((lvl >= USERINFO[playerid][plevel] && !isequal(name, PlayerName(playerid))) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player you entered is at the same level or a higher level than you");
	for(new i = 0; i < DB_CountRows(user_table); i++)
	{
		if()
	}
	return 1;
}*/

CMD:akill(playerid, params[])
{
	new id, str[128];
	if(USERINFO[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/akill <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player ID");
	if((USERINFO[id][plevel] >= USERINFO[playerid][plevel] || IsPlayerAdmin(id)) && id != playerid) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player you entered is at the same level or a higher level than you");
	if(!IsPlayerSpawned(playerid)) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Player isn't spawned yet");
	format(str, sizeof(str), "{006400}[ Info ] {00FF00}You killed %s by Admin powers", PlayerName(id));
	SendClientMessage(playerid, -1, str);
	SendClientMessage(id, -1, "{006400}[ Info ] {00FF00}You have been killed by an Admin");
	SetPlayerHealth(id, 0);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: akill | Admin: %s | Affected: %s", PlayerName(playerid), PlayerName(id));
	return 1;
}

CMD:getips(playerid, params[])
{
	new name[MAX_PLAYER_NAME], str[1024];
	if(USERINFO[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid command");
	if(sscanf(params, "s["#MAX_PLAYER_NAME"]", name)) return SendClientMessage(playerid, -1, "{FF1493}[ Usage ] {FF0080}/getips <name>");
	if(strlen(name) > MAX_PLAYER_NAME || strlen(name) < 3) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player name (There's no such player registered)");
	mysql_format(Database, str, sizeof(str), "SELECT * FROM Users WHERE `Name` = '%e' LIMIT 1", name);
	mysql_query(Database, str);
	if(!cache_num_rows()) return SendClientMessage(playerid, -1, "{e60000}[ Error ] {FF6347}Invalid player name (There's no such player registered)");
	new key;
	cache_get_value_name_int(0, "User_ID", key);
	new field[10], ip[60];
	mysql_format(Database, str, sizeof(str), "SELECT * FROM IPs WHERE `User_ID` = '%d' LIMIT 1", key);
	mysql_query(Database, str);
	for(new i = 0; i < MAX_IP_SAVES; i++)
	{
		format(field, sizeof(field), "IP_%d", i + 1);
		cache_get_value_name(0, field, ip, sizeof(ip));
		if(i != 19) strcat(ip, "\n", sizeof(ip));
		strcat(str, ip, sizeof(str));
	}
	format(ip, sizeof(ip), "LGGW - %s's IP Log (All connected ips)", name);
	Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_LIST, ip, str, "Close", "");
	WriteLog(LOG_ADMINACTIONS, "COMMAND: getips | Admin: %s | Player %s", PlayerName(playerid), name);
	return 1;
}

/*  //Do not remove!!!  (complex Date and time algorithms)
datetime_to_unix(year, month, day, hour, minute, second)  
{
	new jday = 367 * year - 7 * (year + (month + 9) / 12) / 4 - 3 * ((year + (month - 9) / 7) / 100 + 1) / 4 + 275 * month / 9 + day + 1721029 - 2440588;
	return jday * 86400 + hour * 3600 + minute * 60 + second;
}

IsDateExpired(Timestamp)  
{
	new gy, gm, gd, gh, gmin, gs;
	TimestampToDate(Timestamp, gy, gm, gd, gh, gmin, gs, 0);
	new ny, nm, nd, nh, nmin, ns, expired;
	getdate(ny, nm, nd);
	gettime(nh, nmin, ns);
	if(gy < ny) expired = 1;
	else if(gy == ny) 
	{
		if(gm < nm) expired = 1;
		else if(gm == nm)
		{
			if(gd < nd) expired = 1;
			else if(gd == nd) 
			{
				if(gh < nh) expired = 1;
				else if(gh == nh) 
				{
					if(gm < nm) expired = 1;
					else if(gm == nm) 
					{
						if (gs < ns) expired = 1;
					}
				}
			}
		}
	}
	return expired;
} 

rdn(year, month, day)
{
    if (month < 3)
    {
        year--;
        month += 12;
    }
    return ((365*year) + (year/4) - (year/100) + (year/400) + (((153*month) - 457)/5) + (day - 306));
} */

forward OnCheatDetected(playerid, ip_address[], type, code);
public OnCheatDetected(playerid, ip_address[], type, code)
{
    if(type) BlockIpAddress(ip_address, 0);
    else
    {
        switch(code)
        {
            case 5, 6, 11, 22: return 1;
            case 14:
            {
                new a = GetPlayerMoney(playerid);
                ResetPlayerMoney(playerid);
                GivePlayerMoney(playerid, a);
                return 1;
            }
            case 32:
            {
                new Float:x, Float:y, Float:z;
                AntiCheatGetPos(playerid, x, y, z);
                SetPlayerPos(playerid, x, y, z);
                return 1;
            }
            case 40: SendClientMessage(playerid, -1, MAX_CONNECTS_MSG);
            case 41: SendClientMessage(playerid, -1, UNKNOWN_CLIENT_MSG);
            default:
            {
                new strtmp[sizeof KICK_MSG];
                format(strtmp, sizeof strtmp, KICK_MSG, code);
                SendClientMessage(playerid, -1, strtmp);
            }
        }
        SendClientMessage(playerid, -1, "cought for cheats");
        //AntiCheatKickWithDesync(playerid, code);
    }
    return 1;
}  