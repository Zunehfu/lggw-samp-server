/*

                                      ██╗     ██████╗  ██████╗   ██╗       ██╗
                                      ██║     ██╔════╝ ██╔════╝  ██║  ██╗  ██║
                                      ██║     ██║  ██╗ ██║  ██╗  ╚██╗████╗██╔╝
                                      ██║     ██║  ╚██╗██║  ╚██╗  ████╔═████║
                                      ███████╗╚██████╔╝╚██████╔╝  ╚██╔╝ ╚██╔╝
                                      ╚══════╝ ╚═════╝  ╚═════╝    ╚═╝   ╚═╝  Build 3 


LGGW - Lazer Gaming Gang WarZ
Version - v 1.03
Forum - https://www.lg-gw.ga

>> Script By GameOvr <<

Contribution :-
    Scorpion : Mapping
    EvilExecutor : LGGW Forum
    Cypress : Host
    GameOvr : Scripting + Minor mappings
    
@All Rights Reserved
*/

#include <a_samp>

#define     FIXES_ServerVarMsg      0
#define 	FIXES_Single 			1 

#undef      MAX_PLAYERS
#define     MAX_PLAYERS 	   50

#undef      MAX_VEHICLES
#define     MAX_VEHICLES      500

#include <fixes>
//#include <lggw_ac>
#include <weaponconfig>
#include <progress3D>
#include <DialogCenter>
#include <a_mysql>
#include <timerfix>
#include <progress2>
#include <playerstates>
#include <streamer>
#include <Pawn.CMD>
#include <YSI\y_va>
#include <playerzone>
#include <sscanf2>
#include <foreach> 
#include <easyDialog>
#include <strlib> 
#include <PreviewModelDialog>
#include <TimeStampToDate>
#include <bcrypt>

#define DISABLE_3D_TRYG_ACTOR        //Use before 3DTryg.inc for disable Actors Module                                                    *
#define DISABLE_3D_TRYG_FOXFOREACH   //Use before 3DTryg.inc for disable FoxForeach Module                                                *
#define DISABLE_3D_TRYG_YSIFOREACH   //Use before 3DTryg.inc for disable Foreach Module                                                   *
#define DISABLE_3D_TRYG_VEHICLECOL   //Use before 3DTryg.inc for disable VehicleCollision Module                                          *
#define DISABLE_3D_TRYG_COLANDREAS   //Use before 3DTryg.inc for disable ColAndreas Module                                                *
#define DISABLE_3D_TRYG_YSF          //Use before 3DTryg.inc for disable YSF Module                                                       *
#define DISABLE_3D_TRYG_STREAMER     //Use before 3DTryg.inc for disable Streamer Module                                                  *
#define DISABLE_3D_TRYG_FCNPC        //Use before 3DTryg.inc for disable FCNPC Module                                                     *
#define DISABLE_3D_TRYG_VEHSTREAMER  //Use before 3DTryg.inc for disable VehicleStreamer Module                                           *
#define ENABLE_3D_TRYG_YSI_SUPPORT   //Use before 3DTryg.inc for enable YSI Support (use only when 3DTryg say error for this)             *

#include <3DTryg>

#if !defined IsValidVehicle
    native IsValidVehicle(vehicleid);
#endif

#if !defined gpci
    native gpci(playerid, serial[], len);
#endif


#define                 DISCORD_SUPPORT                         false
#define                 SERVER_HOST_PROTECTION                  false

#if DISCORD_SUPPORT == true
#include <discord-connector>
#endif

#if SERVER_HOST_PROTECTION == true
#define    				HOSTED_IP               				"127.0.0.1" // MOST_IMPORTANT     
#endif

#define 				MYSQL_HOST 								"localhost"
#define 				MYSQL_USER 								"root"
#define                 MYSQL_PASS	                            ""
#define                 MYSQL_DATABASE 							"lggw"

//NzE1MjYxNzcwMDQ1OTgwNzgy.Xs81vA.FITlLRs8YJzfGyNke7ydp9VKATw - Discord BOT TOKEN

/* 
   HOSTED_IP is the IP that the SERVER is hosted
   If somebody steals the AMX and going to host
   in the another SERVER that doesn't match with this  
   IP, server is gonna close automatically...
*/

#define                 SERVER_GMT                              5
#define                 SERVER_MIN_GMT                          30
#define                 BCRYPT_COST                             7

// #define 				MAX_PLAYERS								50    > Goto the 30th line to edit MAX_PLAYERS (if needed) <
#define         		MAX_GANGS                       		30
#define 				MAX_WARNS								4
#define         		MAX_GANG_MEMBERS                       	20
#define 				MAX_IP_SAVES							20

#define    			    ROCN_PASS               				"LGGW2003123"  //Tip: Name of the SERVER + B'year of the owners + 123
#define 				SCRIPT_VERSION							1.03
#define 				GAMEMODE_TEXT							"v"#SCRIPT_VERSION": GangWars/TDM/DM"
		
#define     			LOG_ADMINLVLCHANGES      				"/LGGW_Logs/Admin_Level_Changes.lggwlog"
#define     			LOG_ADMINACTIONS         				"/LGGW_Logs/Admin_Actions.lggwlog"
#define     			LOG_DISCONNECTS          			 	"/LGGW_Logs/Player_Disconnects.lggwlog"
#define     			LOG_CONNECTS             				"/LGGW_Logs/Player_Connects.lggwlog"
#define     			LOG_REPORTS              				"/LGGW_Logs/Player_Reports.lggwlog"
#define     			LOG_PASS                 				"/LGGW_Logs/Player_Pass_Changes.lggwlog" 
#define     			LOG_BANS                 				"/LGGW_Logs/Player_Bans.lggwlog"
#define     			LOG_PM                   				"/LGGW_Logs/Player_PM.lggwlog"
#define     			LOG_COMMANDS                   			"/LGGW_Logs/Player_Chat.lggwlog"
#define     			LOG_CHAT                  				"/LGGW_Logs/Player_Commands.lggwlog"

#define 				TEAM_GROVE    							0
#define 				TEAM_AZTECA   							1
#define 				TEAM_JUSTICE  							2
#define 				TEAM_BALLAS   							3
#define 				TEAM_VAGOS    							4
#define 				TEAM_MAFIA    							5
#define 				TEAM_VIP    							6
#define     			TEAM_ADMIN              				34 //Always use a number greater than MAX_GANGS
#define                 TEAM_STUNT                              35 //Always use a number greater than MAX_GANGS
		
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
#define                 COLOR_STUNT                             0xFF0000FF
#define 				COLOR_SPEC								0xFFFFFFFF
		
#define     		    MIN_PLAYERS_TO_START_TURF    			2
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

#define 				HEALTH_FOR_EDRINK						30
#define 				HEALTH_FOR_BANDAGE						20
		
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

#define 				DCC_REPORT_CHANNEL_ID					"705411336389263430"
#define 				DCC_COMMANDS_CHANNEL_ID                 "705110630285180979"
#define 				DCC_CON_DISCON_CHANNEL_ID				"715512961426259968"
#define 				DCC_CHAT_CHANNEL_ID                     "715514258426822736"
#define 				DCC_RCON_CHANNEL_ID                     "716612704277757962"

#define 				DIALOG_USER_TOY_BUY						897
#define 				DIALOG_USER_TOY_REPLACE					987

#define 				MINX 									0.25
#define 				MINY 									0.25
#define 				MINZ 									0.25
#define 				MAXX 									3.00
#define 				MAXY 									3.00
#define 				MAXZ 									3.00

#define                 THREAD_SORT_KILLS                       0                                                                                        
#define                 THREAD_SORT_DEATHS                      1                                                                                   
#define                 THREAD_SORT_CASH                        2                                                                                   
#define                 THREAD_SORT_RATIO                       3                                                                               
#define                 THREAD_SORT_DUELSWON                    4                                                                                       
#define                 THREAD_SORT_HRAMP                       5                                                                                       
#define                 THREAD_SORT_ROBBS                       6                                                                                        
#define                 THREAD_SORT_REVENGES                    7                                                                                             
#define                 THREAD_SORT_GTURFS                      8                                                                                   
#define                 THREAD_SORT_GSCORE                      9                                                                                   
#define                 THREAD_SORT_BKILLS                      10                                                                                   
#define                 THREAD_SORT_LMSWON                      11                                                                               
#define                 THREAD_SORT_GGWON                       12                                                                                   
#define                 THREAD_SORT_HSHOTS                      13  

#define                 KEY_DEFAULT                             2313


new last_key[MAX_PLAYERS];
new spec[MAX_PLAYERS];
new specid[MAX_PLAYERS];
new hshotid = -1;
new hshotgot = -1;
new gvehowned[MAX_VEHICLES];
new gvehid[MAX_VEHICLES] = {-1, ...};
new gang_veh[MAX_GANGS] = {INVALID_VEHICLE_ID, ...};
new Bar3D:gang_vlabel[MAX_GANGS];
new Float:gang_vhealth[MAX_GANGS];
new allow_10min_timer;
new class_in[MAX_PLAYERS];
new class_real[MAX_PLAYERS];
new men_row[MAX_PLAYERS];
new color_tab[MAX_PLAYERS];
new tmppass[MAX_PLAYERS][30];
new intuneshop[MAX_PLAYERS];
new cur_kills[MAX_PLAYERS];
new PlayerText:killtext[MAX_PLAYERS];
new kill_counter[MAX_PLAYERS];

new time_edrink[MAX_PLAYERS];
new time_band[MAX_PLAYERS];
/*  Do not change anything from here */

//Defines
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))

//Enumerators
enum GangData 
{
	gname[30],
	gtag[6],
	gcolor,
	ghouse,
	ghouseid,
	gkills,
	gdeaths,
	gturfs,
	gscore,
	gveh,
	gvmodel
}
enum UserData
{
    pname[MAX_PLAYER_NAME],
    pip[20],
	
	ppass[BCRYPT_HASH_LENGTH],
	plevel,
	VIP, 
    VIP_exp, 
    Float:pscore,
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

	onduty,

    jailed,
    jailtime,
    jailed_admin,
    jailed_reason,
    muted,
    mutetime,
    muted_admin,
    muted_reason,

	Cache:Player_Cache
}
enum pToyInfo
{
	tused,
	tid,
	bone,
	Float:posx,
	Float:posy,
	Float:posz,
	Float:rotx,
	Float:roty,
	Float:rotz,
	Float:scalex,
	Float:scaley,
	Float:scalez
}
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
enum ShopData 
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
new cur_slotid[MAX_PLAYERS];

enum ToyData
{
	tmodel, 
	tname[24],
	tprice
}

new
	MySQL: Database, Corrupt_Check[MAX_PLAYERS];

new last_shot[MAX_PLAYERS];
new last_kill[MAX_PLAYERS];

//Forwards
forward DuelDeadLine(id, playerid);
forward CloseMoneyTD(playerid);
forward ExpireGangRequest(playerid);
forward HideZoneTD(playerid);
forward OnPlayerConnectEx(playerid);
forward HideVehTD(playerid);
forward LMSStartedJustNow();
forward UncuffForLMS();
forward StartLastManStanding();
forward SecTimer_5();
forward GunGameEndTime();
forward ExtraGunGameTime();
forward RobTimer();
forward SecTimer_1();
forward TurfTimer();
forward HideCashTD();
forward TurfMoney();
forward MinTimer_5();
forward RandomConnectTD();

//Variables
/* Structural indexed variables (If you are adding new Zones or Shops or Gang Houses, Add them from bottom!!!*/

new Toys[][ToyData] = 
{
	{18632, "FishingRod", 500},
	{18633, "GTASAWrench1", 500},
	{18634, "GTASACrowbar1", 500},
	{18635, "GTASAHammer1", 500},
	{18636, "PoliceCap1", 500},
	{18637, "PoliceShield1", 500},
	{18638, "HardHat1", 500},
	{18639, "BlackHat1", 500},
	{18640, "Hair1", 500},
	{18975, "Hair2", 500},
	{19136, "Hair4", 500},
	{19274, "Hair5", 500},
	{18641, "Flashlight1", 500},
	{18642, "Taser1", 500},
	{18643, "LaserPointer1", 500},
	{19080, "LaserPointer2", 500},
	{19081, "LaserPointer3", 500},
	{19082, "LaserPointer4", 500},
	{19083, "LaserPointer5", 500},
	{19084, "LaserPointer6", 500},
	{18644, "Screwdriver1", 500},
	{18645, "MotorcycleHelmet1", 500},
	{18865, "MobilePhone1", 500},
	{18866, "MobilePhone2", 500},
	{18867, "MobilePhone3", 500},
	{18868, "MobilePhone4", 500},
	{18869, "MobilePhone5", 500},
	{18870, "MobilePhone6", 500},
	{18871, "MobilePhone7", 500},
	{18872, "MobilePhone8", 500},
	{18873, "MobilePhone9", 500},
	{18874, "MobilePhone10", 500},
	{18875, "Pager1", 500},
	{18890, "Rake1", 500},
	{18891, "Bandana1", 500},
	{18892, "Bandana2", 500},
	{18893, "Bandana3", 500},
	{18894, "Bandana4", 500},
	{18895, "Bandana5", 500},
	{18896, "Bandana6", 500},
	{18897, "Bandana7", 500},
	{18898, "Bandana8", 500},
	{18899, "Bandana9", 500},
	{18900, "Bandana10", 500},
	{18901, "Bandana11", 500},
	{18902, "Bandana12", 500},
	{18903, "Bandana13", 500},
	{18904, "Bandana14", 500},
	{18905, "Bandana15", 500},
	{18906, "Bandana16", 500},
	{18907, "Bandana17", 500},
	{18908, "Bandana18", 500},
	{18909, "Bandana19", 500},
	{18910, "Bandana20", 500},
	{18911, "Mask1", 500},
	{18912, "Mask2", 500},
	{18913, "Mask3", 500},
	{18914, "Mask4", 500},
	{18915, "Mask5", 500},
	{18916, "Mask6", 500},
	{18917, "Mask7", 500},
	{18918, "Mask8", 500},
	{18919, "Mask9", 500},
	{18920, "Mask10", 500},
	{18921, "Beret1", 500},
	{18922, "Beret2", 500},
	{18923, "Beret3", 500},
	{18924, "Beret4", 500},
	{18925, "Beret5", 500},
	{18926, "Hat1", 500},
	{18927, "Hat2", 500},
	{18928, "Hat3", 500},
	{18929, "Hat4", 500},
	{18930, "Hat5", 500},
	{18931, "Hat6", 500},
	{18932, "Hat7", 500},
	{18933, "Hat8", 500},
	{18934, "Hat9", 500},
	{18935, "Hat10", 500},
	{18936, "Helmet1", 500},
	{18937, "Helmet2", 500},
	{18938, "Helmet3", 500},
	{18939, "CapBack1", 500},
	{18940, "CapBack2", 500},
	{18941, "CapBack3", 500},
	{18942, "CapBack4", 500},
	{18943, "CapBack5", 500},
	{18944, "HatBoater1", 500},
	{18945, "HatBoater2", 500},
	{18946, "HatBoater3", 500},
	{18947, "HatBowler1", 500},
	{18948, "HatBowler2", 500},
	{18949, "HatBowler3", 500},
	{18950, "HatBowler4", 500},
	{18951, "HatBowler5", 500},
	{18952, "BoxingHelmet1", 500},
	{18953, "CapKnit1", 500},
	{18954, "CapKnit2", 500},
	{18955, "CapOverEye1", 500},
	{18956, "CapOverEye2", 500},
	{18957, "CapOverEye3", 500},
	{18958, "CapOverEye4", 500},
	{18959, "CapOverEye5", 500},
	{18960, "CapRimUp1", 500},
	{18961, "CapTrucker1", 500},
	{18962, "CowboyHat2", 500},
	{18963, "CJElvisHead", 500},
	{18964, "SkullyCap1", 500},
	{18965, "SkullyCap2", 500},
	{18966, "SkullyCap3", 500},
	{18967, "HatMan1", 500},
	{18968, "HatMan2", 500},
	{18969, "HatMan3", 500},
	{18970, "HatTiger1", 500},
	{18971, "HatCool1", 500},
	{18972, "HatCool2", 500},
	{18973, "HatCool3", 500},
	{18974, "MaskZorro1", 500},
	{18976, "MotorcycleHelmet2", 500},
	{18977, "MotorcycleHelmet3", 500},
	{18978, "MotorcycleHelmet4", 500},
	{18979, "MotorcycleHelmet5", 500},
	{19006, "GlassesType1", 500},
	{19007, "GlassesType2", 500},
	{19008, "GlassesType3", 500},
	{19009, "GlassesType4", 500},
	{19010, "GlassesType5", 500},
	{19011, "GlassesType6", 500},
	{19012, "GlassesType7", 500},
	{19013, "GlassesType8", 500},
	{19014, "GlassesType9", 500},
	{19015, "GlassesType10", 500},
	{19016, "GlassesType11", 500},
	{19017, "GlassesType12", 500},
	{19018, "GlassesType13", 500},
	{19019, "GlassesType14", 500},
	{19020, "GlassesType15", 500},
	{19021, "GlassesType16", 500},
	{19022, "GlassesType17", 500},
	{19023, "GlassesType18", 500},
	{19024, "GlassesType19", 500},
	{19025, "GlassesType20", 500},
	{19026, "GlassesType21", 500},
	{19027, "GlassesType22", 500},
	{19028, "GlassesType23", 500},
	{19029, "GlassesType24", 500},
	{19030, "GlassesType25", 500},
	{19031, "GlassesType26", 500},
	{19032, "GlassesType27", 500},
	{19033, "GlassesType28", 500},
	{19034, "GlassesType29", 500},
	{19035, "GlassesType30", 500},
	{19036, "HockeyMask1", 500},
	{19037, "HockeyMask2", 500},
	{19038, "HockeyMask3", 500},
	{19039, "WatchType1", 500},
	{19040, "WatchType2", 500},
	{19041, "WatchType3", 500},
	{19042, "WatchType4", 500},
	{19043, "WatchType5", 500},
	{19044, "WatchType6", 500},
	{19045, "WatchType7", 500},
	{19046, "WatchType8", 500},
	{19047, "WatchType9", 500},
	{19048, "WatchType10", 500},
	{19049, "WatchType11", 500},
	{19050, "WatchType12", 500},
	{19051, "WatchType13", 500},
	{19052, "WatchType14", 500},
	{19053, "WatchType15", 500},
	{19085, "EyePatch1", 500},
	{19086, "ChainsawDildo1", 500},
	{19090, "PomPomBlue", 500},
	{19091, "PomPomRed", 500},
	{19092, "PomPomGreen", 500},
	{19093, "HardHat2", 500},
	{19094, "BurgerShotHat1", 500},
	{19095, "CowboyHat1", 500},
	{19096, "CowboyHat3", 500},
	{19097, "CowboyHat4", 500},
	{19098, "CowboyHat5", 500},
	{19099, "PoliceCap2", 500},
	{19100, "PoliceCap3", 500},
	{19101, "ArmyHelmet1", 500},
	{19102, "ArmyHelmet2", 500},
	{19103, "ArmyHelmet3", 500},
	{19104, "ArmyHelmet4", 500},
	{19105, "ArmyHelmet5", 500},
	{19106, "ArmyHelmet6", 500},
	{19107, "ArmyHelmet7", 500},
	{19108, "ArmyHelmet8", 500},
	{19109, "ArmyHelmet9", 500},
	{19110, "ArmyHelmet10", 500},
	{19111, "ArmyHelmet11", 500},
	{19112, "ArmyHelmet12", 500},
	{19113, "SillyHelmet1", 500},
	{19114, "SillyHelmet2", 500},
	{19115, "SillyHelmet3", 500},
	{19116, "PlainHelmet1", 500},
	{19117, "PlainHelmet2", 500},
	{19118, "PlainHelmet3", 500},
	{19119, "PlainHelmet4", 500},
	{19120, "PlainHelmet5", 500},
	{19137, "CluckinBellHat1", 500},
	{19138, "PoliceGlasses1", 500},
	{19139, "PoliceGlasses2", 500},
	{19140, "PoliceGlasses3", 500},
	{19141, "SWATHelmet1", 500},
	{19142, "SWATArmour1", 500},
	{19160, "HardHat3", 500},
	{19161, "PoliceHat1", 500},
	{19162, "PoliceHat2", 500},
	{19163, "GimpMask1", 500},
	{19317, "bassguitar01", 500},
	{19318, "flyingv01", 500},
	{19319, "warlock01", 500},
	{19330, "fire_hat01", 500},
	{19331, "fire_hat02", 500},
	{19346, "hotdog01", 500},
	{19347, "badge01", 500},
	{19348, "cane01", 500},
	{19349, "monocle01", 500},
	{19350, "moustache01", 500},
	{19351, "moustache02", 500},
	{19352, "tophat01", 500},
	{19487, "tophat02", 500},
	{19488, "HatBowler6", 500},
	{19513, "whitephone", 500},
	{19515, "GreySwatArm", 500},
	{3044, "Cigar", 500},
	{1210, "Briefcase", 500}
};
new shopinfo[][ShopData] = 
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
	"~w~Seriously~y~?~w~_Are_you_new_here~y~?~w~_get_started_with_~r~/help!",
	"~w~Go_and_register_on_our_~y~forums_~r~right_now!.",
	"~w~Join_Us_at_~y~Discord~w~_too.",
	"~w~Shoot_enemies,_kill_them_and_earn_~y~money~w~_to_buy_~r~cool_stuff.",
	"~w~Found_a_~r~cheater/rule_breaker~y~?~w~,_use_~y~/report.",
	"~w~Use_~y~/rules~w~_to_view_server_rules.",
	"~w~Need_money~y~?~w~_You_can_start_turfing_with_~r~"#MIN_PLAYERS_TO_START_TURF"~w~_players_of_your_gang.",
	"~w~Unlock_more_~y~exciting_~w~and_~y~premium~w~_features_by_becoming_a_~y~]_~r~VIP_~y~].",
	"~w~Need_help?_try_~y~/cmds~w~_or_Ask_an_online_admin.",
	"~w~Use_~y~/pm_~w~to_~r~privatly~w~_message_a_player.", 
	"~w~Feeling_~r~tired_~w~reading_~r~PMS~y~?~w~,_Use_~y~/blockpm_~w~to_~r~disable_~w~PMs!.",
	"~w~You_can_also_check_~r~your_stats~w~_by_~y~/stats.",
	"~w~Bored_of_playing_~r~TDM~y~?~w~,_try_out_our_~r~exclusive_deathmatches_~y~(/dm).",
	"~w~~y~Thank_you~w~_for_playing_and_stay_~r~in_touch~w~_with_us.",
	"~w~Want_to_buy_~r~powerful_weapons~w~_and_kill_others_without_effort~y~?_~r~Ammunation~w~_is_the_place_for_you."
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
new Float:DM7Randoms[][] =
{
	{636.7563,1695.8118,498.0546,39.2083},
	{615.9961,1696.1672,498.0546,322.0232},
	{615.6380,1746.5756,498.0546,226.6646},
	{626.4606,1731.3420,501.5505,177.8885},
	{626.2786,1713.0710,501.5494,0.6680},
	{636.6380,1746.6476,498.0546,143.9438},
	{626.2887,1709.4434,498.0580,358.3470},
	{626.4953,1723.3812,498.0549,2.6293},
	{626.4751,1720.7968,498.0549,179.5598},
	{626.6397,1732.0201,498.0599,176.5308}
};
new Float:DM8Randoms[][] =
{
	{760.9568,11.8584,1001.1639,171.5163},
	{773.7585,13.9491,1000.6959,146.0549},
	{771.9315,-3.2259,1000.7288,38.8940},
	{756.7094,-3.5663,1000.6952,325.1555}
};
new Float:DM9Randoms[][] =
{
	{231.0768,1933.5436,33.8984,166.0780},
	{266.0390,1893.2893,33.8984,141.9992},
	{281.0493,1837.0741,17.6481,55.9345},
	{211.1294,1811.1814,21.8672,0.8918},
	{152.0541,1803.5645,17.6406,353.4761},
	{167.3129,1852.3776,33.8984,347.1629},
	{112.8907,1928.1630,18.7838,252.7675},
	{159.1372,1929.5592,20.3672,267.4944},
	{213.6750,1864.2860,13.1406,0.7408}
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
new 
	class_gselected[MAX_PLAYERS],
	class_selected[MAX_PLAYERS],
	class_tick[MAX_PLAYERS],
	inminigame[MAX_PLAYERS],
	ingg[MAX_PLAYERS],
	instunt[MAX_PLAYERS],
	hospicked[MAX_PLAYERS],
	justconnected[MAX_PLAYERS],
	warns[MAX_PLAYERS],
	picked[MAX_PLAYERS],
	nocmd[MAX_PLAYERS],
	frozen[MAX_PLAYERS],
	duelinvited[MAX_PLAYERS],
	duelinviter[MAX_PLAYERS],
	inanim[MAX_PLAYERS],
	induel[MAX_PLAYERS],
	killinginprogress[MAX_PLAYERS],
	indm[MAX_PLAYERS],
	vehowned[MAX_VEHICLES],
	logged[MAX_PLAYERS],
	inlms[MAX_PLAYERS],
	grequested[MAX_PLAYERS],
	revenge[MAX_PLAYERS],
    shoprob_timestamp[MAX_ACTORS],
	last_weather,
	gg_started,
	lmsstarted,
	lmsjustnow,
	tdlvl,
	egg_timer,
	lmsplace,
	WEAPS[MAX_PLAYERS][2][13],
	editvneon[MAX_PLAYERS][3],
	vehneon[MAX_VEHICLES][3],
	userinfo[MAX_PLAYERS][UserData],
	toyinfo[MAX_PLAYERS][10][pToyInfo],
	ganginfo[MAX_GANGS][GangData],
	ZONEID[sizeof(zoneinfo)],
	DZONEID[sizeof(zoneinfo)],
	GENTERCP[sizeof(houseinfo)], 
	GEXITCP[sizeof(houseinfo)],
	SENTERCP[sizeof(shopinfo)],
	SEXITCP[sizeof(shopinfo)],
	SBUYCP[sizeof(shopinfo)],
	hospick[2],
	GANG_HOUSE[14],
	PVEH[2],
	gangpick[6],
	pDrunkLevelLast[MAX_PLAYERS],
	pFPS[MAX_PLAYERS],
	af_page[MAX_PLAYERS],
	class_saved[MAX_PLAYERS],
	gg_lvl[MAX_PLAYERS],
	adm_id[MAX_PLAYERS],
	spamcount[MAX_PLAYERS],
	adminveh[MAX_PLAYERS],
	rconattempts[MAX_PLAYERS],
	dstimer[MAX_PLAYERS],
	duelbet[MAX_PLAYERS],
	enemy[MAX_PLAYERS],
	dmid[MAX_PLAYERS],
	dmkills[MAX_PLAYERS],
	dmdeaths[MAX_PLAYERS],
	dmspree[MAX_PLAYERS],
	INT[MAX_PLAYERS],
	VW[MAX_PLAYERS],
	TEAM[MAX_PLAYERS],
	COLOR[MAX_PLAYERS],
	SKIN[MAX_PLAYERS],
	SAWNBOUGHT[MAX_PLAYERS], 
	ARMOURBOUGHT[MAX_PLAYERS],
	lmskills[MAX_PLAYERS],
	grequestedid[MAX_PLAYERS],
	reqtimer[MAX_PLAYERS],
	rampage[MAX_PLAYERS],
	revengeid[MAX_PLAYERS],
	robber[MAX_ACTORS] = {-1, ...},
	vehowner[MAX_VEHICLES] = {INVALID_PLAYER_ID, ...},
	priveh[MAX_PLAYERS] = {INVALID_VEHICLE_ID, ...}
;

/* Float */
new Float:DX[MAX_PLAYERS], 
    Float:DY[MAX_PLAYERS], 
    Float:DZ[MAX_PLAYERS],
    Float:HP[MAX_PLAYERS],
    Float:ARMOUR[MAX_PLAYERS],
    Float:FA[MAX_PLAYERS],
    Float:robgtv[MAX_PLAYERS],
    Float:robtime[MAX_ACTORS]
;

/* String */
new tempgname[MAX_PLAYERS][30],
    tempgtag[MAX_PLAYERS][6],
    lastmsg[MAX_PLAYERS][128]
;

/* Graphical */
new PlayerBar:rbar[MAX_PLAYERS],
    PlayerBar:lbar[MAX_PLAYERS],
    PlayerBar:glbar[MAX_PLAYERS]
;

new Text3D:glabel[MAX_PLAYERS] = {Text3D:INVALID_3DTEXT_ID, ...},
    Text3D:hlabel[sizeof(houseinfo)],
    Text3D:alabel[MAX_PLAYERS]
;

new Text:zonetd,
    Text:gangtd,
    Text:statstd,
    Text:LGGW[4],
    Text:takeovertd[4],
    Text:DM__[2],
    Text:wastedtd[5],
    Text:connecttd[12]
;

new PlayerText:fplabel_1[MAX_PLAYERS],
    PlayerText:wastedtd_1[MAX_PLAYERS],
    PlayerText:pleveltd[MAX_PLAYERS],
    PlayerText:vehtd_1[MAX_PLAYERS],
    PlayerText:turfcashtd[MAX_PLAYERS],
    PlayerText:moneytd_1[MAX_PLAYERS],
    PlayerText:DM_1[MAX_PLAYERS],
    PlayerText:zonetd_1[MAX_PLAYERS][2],
    PlayerText:takeovertd_1[MAX_PLAYERS][2],
    PlayerText:statstd_1[MAX_PLAYERS][6],
    PlayerText:gangtd_1[MAX_PLAYERS][5]
;

new Menu:tune_main,
    Menu:tune_pjob,
    Menu:tune_colors,
    Menu:tune_colors2,
    Menu:tune_nitro,
    Menu:tune_hydra,
    Menu:tune_wheels,
    Menu:tune_neons
;

//Main

#if DISCORD_SUPPORT true
new DCC_Channel:dcc_channel_reports,
    DCC_Channel:dcc_channel_commands,
    DCC_Channel:dcc_channel_chat,
    DCC_Channel:dcc_channel_con_discon,
    DCC_Channel:dcc_channel_rcon
;
#endif

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
	print("| {ffa500}LGGW {ffffff}- Lazer Gaming Gang WarZ                                	|");
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

    #if DISCORD_SUPPORT == true
	dcc_channel_reports = DCC_FindChannelById(DCC_REPORT_CHANNEL_ID);
	dcc_channel_commands = DCC_FindChannelById(DCC_COMMANDS_CHANNEL_ID);
	dcc_channel_con_discon = DCC_FindChannelById(DCC_CON_DISCON_CHANNEL_ID);
	dcc_channel_chat = DCC_FindChannelById(DCC_CHAT_CHANNEL_ID);
	dcc_channel_rcon = DCC_FindChannelById(DCC_RCON_CHANNEL_ID);
    #endif
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
	cache_get_value_name_int(0, "User_ID", userinfo[playerid][pid]);
	cache_get_value_name_int(0, "Level", userinfo[playerid][plevel]); 
	cache_get_value_name_int(0, "VIP", userinfo[playerid][VIP]); 
    cache_get_value_name_int(0, "VIP_expiretime", userinfo[playerid][VIP_exp]); 
	cache_get_value_name_int(0, "Cash", userinfo[playerid][pcash]); 
	cache_get_value_name_int(0, "Kills", userinfo[playerid][pkills]); 
    cache_get_value_name_int(0, "Score", userinfo[playerid][pkills]); 
	cache_get_value_name_int(0, "Deaths", userinfo[playerid][pdeaths]); 
	cache_get_value_name_int(0, "Block_PM", userinfo[playerid][blockpm]); 
	cache_get_value_name_int(0, "Revenges", userinfo[playerid][revenges]); 
	cache_get_value_name_int(0, "Brutal_kills", userinfo[playerid][bkills]); 
	cache_get_value_name_int(0, "Highest_rampage", userinfo[playerid][bramp]); 
	cache_get_value_name_int(0, "Robberies", userinfo[playerid][robbs]); 
	cache_get_value_name_int(0, "Head_shots", userinfo[playerid][hshots]); 
	cache_get_value_name_int(0, "Play_time", userinfo[playerid][ptime]); 

	cache_get_value_name_int(0, "Duels_played", userinfo[playerid][dplayed]); 
	cache_get_value_name_int(0, "Duels_won", userinfo[playerid][dwon]); 
	cache_get_value_name_int(0, "Duel_place_ID", userinfo[playerid][dplace]); 
	cache_get_value_name_int(0, "Duel_weapon_1", userinfo[playerid][dwep1]); 
	cache_get_value_name_int(0, "Duel_weapon_2", userinfo[playerid][dwep2]); 
	cache_get_value_name_int(0, "Duel_weapon_3", userinfo[playerid][dwep3]); 
	cache_get_value_name_int(0, "Duel_bet", userinfo[playerid][dbet]); 
	cache_get_value_name_int(0, "LMS_played", userinfo[playerid][lmsplayed]); 
	cache_get_value_name_int(0, "LMS_won", userinfo[playerid][lmswon]); 
	cache_get_value_name_int(0, "GunGames_played", userinfo[playerid][ggp]);  
	cache_get_value_name_int(0, "GunGames_won", userinfo[playerid][ggw]);  

	cache_get_value_name_int(0, "In_gang", userinfo[playerid][ingang]); 
	cache_get_value_name_int(0, "Gang_ID", userinfo[playerid][gid]); 
	cache_get_value_name_int(0, "Gang_level", userinfo[playerid][glevel]); 
	cache_get_value_name_int(0, "Gang_skin", userinfo[playerid][gskin]); 
	return 1;
}

forward LoadUserVehicleData(playerid);
public LoadUserVehicleData(playerid)
{
    cache_get_value_name_int(0, "Vehicle_owned", userinfo[playerid][vowned]); 
    cache_get_value_name_int(0, "Vehicle_model", userinfo[playerid][vmodel]); 
    cache_get_value_name_int(0, "Vehicle_wheel", userinfo[playerid][vwheel]); 
    cache_get_value_name_int(0, "Vehicle_color_1", userinfo[playerid][vcolor_1]); 
    cache_get_value_name_int(0, "Vehicle_color_2", userinfo[playerid][vcolor_2]); 
    cache_get_value_name_int(0, "Vehicle_neon_1", userinfo[playerid][vneon_1]); 
    cache_get_value_name_int(0, "Vehicle_neon_2", userinfo[playerid][vneon_2]); 
    cache_get_value_name_int(0, "Vehicle_paintjob", userinfo[playerid][vpjob]); 
    cache_get_value_name_int(0, "Vehicle_nitro", userinfo[playerid][vnitro]); 
    cache_get_value_name_int(0, "Vehicle_hydraulics", userinfo[playerid][vhydra]); 
    return 1;
}

forward LoadUserToyData(playerid);
public LoadUserToyData(playerid)
{
	for(new i = 0; i < 10; i++)
	{
		cache_get_value_name_int(i, "Used", toyinfo[playerid][i][tused]);
		cache_get_value_name_int(i, "Toy_ID", toyinfo[playerid][i][tid]);
		cache_get_value_name_int(i, "Bone", toyinfo[playerid][i][bone]);
		cache_get_value_name_float(i, "Pos_X", toyinfo[playerid][i][posx]);
		cache_get_value_name_float(i, "Pos_Y", toyinfo[playerid][i][posy]); 
		cache_get_value_name_float(i, "Pos_Z", toyinfo[playerid][i][posz]);
		cache_get_value_name_float(i, "Rot_X", toyinfo[playerid][i][rotx]);
		cache_get_value_name_float(i, "Rot_Y", toyinfo[playerid][i][roty]);
		cache_get_value_name_float(i, "Rot_Z", toyinfo[playerid][i][rotz]);
		cache_get_value_name_float(i, "Scale_X", toyinfo[playerid][i][scalex]);
		cache_get_value_name_float(i, "Scale_Y", toyinfo[playerid][i][scaley]);
		cache_get_value_name_float(i, "Scale_Z", toyinfo[playerid][i][scalez]);
	}
	return 1;
}

LoadGangData(g_id)
{
	new str[65];
	mysql_format(Database, str, sizeof(str), "SELECT * FROM `Gangs` WHERE `Gang_ID` = '%d' LIMIT 1", g_id + 1);
	new Cache:c_ = mysql_query(Database, str);

	cache_get_value_name(0, "Name", ganginfo[g_id][gname], 30);
	cache_get_value_name(0, "Tag", ganginfo[g_id][gtag], 6);
	cache_get_value_name_int(0, "Color", ganginfo[g_id][gcolor]);
	cache_get_value_name_int(0, "HQ", ganginfo[g_id][ghouse]);
	cache_get_value_name_int(0, "HQ_ID", ganginfo[g_id][ghouseid]); 
	cache_get_value_name_int(0, "Kills", ganginfo[g_id][gkills]); 
	cache_get_value_name_int(0, "Deaths", ganginfo[g_id][gdeaths]); 
	cache_get_value_name_int(0, "Score", ganginfo[g_id][gscore]); 
	cache_get_value_name_int(0, "Turfs", ganginfo[g_id][gturfs]);
	cache_get_value_name_int(0, "Vehicle_owned", ganginfo[g_id][gveh]);
	cache_get_value_name_int(0, "Vehicle_model", ganginfo[g_id][gvmodel]);

    cache_delete(c_);
	return 1;
}

LoadHouseData(h_id)
{
	new str[65];
	mysql_format(Database, str, sizeof(str), "SELECT * FROM `Houses` WHERE `House_ID` = '%d' LIMIT 1", h_id + 1);
	new Cache:r = mysql_query(Database, str);

	cache_get_value_name_int(0, "House_owned", houseinfo[h_id][howned]);
	cache_get_value_name_int(0, "House_owned_team_ID", houseinfo[h_id][hteamid]);

    cache_delete(r);
	return 1;
}

LoadZoneData(z_id)
{
	new str[65]; 
	mysql_format(Database, str, sizeof(str), "SELECT * FROM `Zones` WHERE `Zone_ID` = '%d' LIMIT 1", z_id + 1);
	new Cache:r = mysql_query(Database, str);

	cache_get_value_name_int(0, "Zone_owned_team_ID", zoneinfo[z_id][zteamid]);
    printf("Zone_owned_team_ID = %d", zoneinfo[z_id][zteamid]);

    cache_delete(r);
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

IsPlayerMoving(playerid)
{
	new Float:VelocityX, Float:VelocityY, Float:VelocityZ;
	GetPlayerVelocity(playerid, VelocityX, VelocityY, VelocityZ);
	if(VelocityX == 0 && VelocityY == 0 && VelocityZ == 0) return 0;
	return 1;
}

SyncPlayerCash(playerid)
{
	if(GetPlayerMoney(playerid) != userinfo[playerid][pcash])
	{
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, GetPlayerCash(playerid));
	}       
	return 1;
}

GetPlayerCash(playerid) 
{
	return userinfo[playerid][pcash];
}

SetPlayerCash(playerid, amount)
{
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, amount);
	userinfo[playerid][pcash] = amount;
	return 1;
}

GivePlayerCash(playerid, amount, show = 1)
{
	new mstr[128];
	if(amount >= 0)
	{
		GivePlayerMoney(playerid, amount);
		format(mstr, sizeof(mstr), "~g~+$%d", amount);
		userinfo[playerid][pcash] += amount;
	}
	else
	{
		new idx = (0 - amount);
		if(0 > (GetPlayerCash(playerid) + amount)){
			ResetPlayerMoney(playerid);
			userinfo[playerid][pcash] = 0;
		}
		else{
			GivePlayerMoney(playerid, amount); 
			userinfo[playerid][pcash] -= idx;
		}
		format(mstr, sizeof(mstr), "~r~-$%d", idx);
	}
	
	if(show)
	{
		PlayerTextDrawShow(playerid, moneytd_1[playerid]);
		PlayerTextDrawSetString(playerid, moneytd_1[playerid], mstr); 
		SetTimerEx("CloseMoneyTD", 5000, false, "i", playerid);
	}

	mysql_format(Database, mstr, sizeof(mstr), "UPDATE `Users` SET `Cash` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][pcash], userinfo[playerid][pid]);
	mysql_tquery(Database, mstr);
	return 1;
}

AntiDeAMX()
{
	new a[][] = 
	{
		"Unarmed (Fist).",
		"Brass K"
	};
	#pragma unused a
}

stock stringContainsIP(const szStr[], bool:fixedSeparation = false, bool:ignoreNegatives = false, bool:ranges = true) // bool:ipMustHavePort = true
{
	new 
		i = 0, ch, lastCh, len = strlen(szStr), trueIPInts = 0, bool:isNumNegative = false, bool:numIsValid = true, // Invalid numbers are 1-1
		numberFound = -1, numLen = 0, numStr[5], numSize = sizeof(numStr),
		lastSpacingPos = -1, numSpacingDiff, numLastSpacingDiff, numSpacingDiffCount // -225\0 (4 len)
	;
	while(i <= len)
	{
		lastCh = ch;
		ch = szStr[i];
		if(ch >= '0' && ch <= '9' || (ranges == true && ch == '*')) 
		{
			if(numIsValid && numLen < numSize) 
			{
				if(lastCh == '-') 
				{
					if(numLen == 0 && ignoreNegatives == false) 
					{
						isNumNegative = true;
					}
					else if(numLen > 0) 
					{
						numIsValid = false;
					}
				}
				numberFound = strval(numStr);
				if(numLen == (3 + _:isNumNegative) && !(numberFound >= -255 && numberFound <= 255)) 
				{ 
				// IP Num is valid up to 4 characters.. -255
					for(numLen = 3; numLen > 0; numLen--) 
					{
						numStr[numLen] = EOS;
					}
				}
				else if(lastCh == '-' && ignoreNegatives) 
				{
					i++;
					continue;
				} else {
					if(numLen == 0 && numIsValid == true && isNumNegative == true && lastCh == '-') 
					{
						numStr[numLen++] = lastCh;
					}
					numStr[numLen++] = ch;
				}
			}
		} else {
			if(numLen && numIsValid) 
			{
				numberFound = strval(numStr);
				if(numberFound >= -255 && numberFound <= 255) 
				{
					if(fixedSeparation) 
					{
						if(lastSpacingPos != -1) 
						{
							numLastSpacingDiff = numSpacingDiff;
							numSpacingDiff = i - lastSpacingPos - numLen;
							if(trueIPInts == 1 || numSpacingDiff == numLastSpacingDiff) 
							{
								++numSpacingDiffCount;
							}
						}
						lastSpacingPos = i;
					}
					if(++trueIPInts >= 4) 
					{
						break;
					}
				}
				for(numLen = 3; numLen > 0; numLen--) 
				{
					numStr[numLen] = EOS;
				}
				isNumNegative = false;
			} else {
				numIsValid = true;
			}
		}
		i++;
	}
	if(fixedSeparation == true && numSpacingDiffCount < 3) 
	{
		return 0;
	}
	return (trueIPInts >= 4);
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

Tune_SetupVehicle(playerid)
{
    SetVehicleRealData(playerid);
    new vehicleid = GetPlayerVehicleID(playerid);
    new Menu:cur_menu = GetPlayerMenu(playerid);
    if(cur_menu == tune_wheels)
    {   
        switch(men_row[playerid])
        {
            case 0: AddVehicleComponent(vehicleid, 1073);
            case 1: AddVehicleComponent(vehicleid, 1074);
            case 2: AddVehicleComponent(vehicleid, 1075);
            case 3: AddVehicleComponent(vehicleid, 1076);
            case 4: AddVehicleComponent(vehicleid, 1077);
            case 5: AddVehicleComponent(vehicleid, 1078);
            case 6: AddVehicleComponent(vehicleid, 1079);
            case 7: AddVehicleComponent(vehicleid, 1083);
            case 8: AddVehicleComponent(vehicleid, 1085);
        }
    }
    else if(cur_menu == tune_colors)
    {
        switch(color_tab[playerid])
        {
            case 0:
            {
                switch(men_row[playerid])
                {
                    case 0: ChangeVehicleColor(vehicleid, 0, userinfo[playerid][vcolor_2]);
                    case 1: ChangeVehicleColor(vehicleid, 1, userinfo[playerid][vcolor_2]);
                    case 2: ChangeVehicleColor(vehicleid, 128, userinfo[playerid][vcolor_2]);
                    case 3: ChangeVehicleColor(vehicleid, 135, userinfo[playerid][vcolor_2]);
                    case 4: ChangeVehicleColor(vehicleid, 152, userinfo[playerid][vcolor_2]);
                    case 5: ChangeVehicleColor(vehicleid, 6, userinfo[playerid][vcolor_2]);
                    case 6: ChangeVehicleColor(vehicleid, 252, userinfo[playerid][vcolor_2]);
                    case 7: ChangeVehicleColor(vehicleid, 146, userinfo[playerid][vcolor_2]);
                    case 8: ChangeVehicleColor(vehicleid, 219, userinfo[playerid][vcolor_2]);
                }
            }
            case 1:
            {
                switch(men_row[playerid])
                {
                    case 0: ChangeVehicleColor(vehicleid, userinfo[playerid][vcolor_1], 0);
                    case 1: ChangeVehicleColor(vehicleid, userinfo[playerid][vcolor_1], 1);
                    case 2: ChangeVehicleColor(vehicleid, userinfo[playerid][vcolor_1], 128);
                    case 3: ChangeVehicleColor(vehicleid, userinfo[playerid][vcolor_1], 135);
                    case 4: ChangeVehicleColor(vehicleid, userinfo[playerid][vcolor_1], 152);
                    case 5: ChangeVehicleColor(vehicleid, userinfo[playerid][vcolor_1], 6);
                    case 6: ChangeVehicleColor(vehicleid, userinfo[playerid][vcolor_1], 252);
                    case 7: ChangeVehicleColor(vehicleid, userinfo[playerid][vcolor_1], 146);
                    case 8: ChangeVehicleColor(vehicleid, userinfo[playerid][vcolor_1], 219);
                }
            }
        }
    }
    else if(cur_menu == tune_neons)
    {
        switch(men_row[playerid])
        {
            case 0:
            {
                editvneon[playerid][0] = CreateObject(18651,0,0,0,0,0,0);  
                editvneon[playerid][1] = CreateObject(18651,0,0,0,0,0,0);  
                AttachObjectToVehicle(editvneon[playerid][0], vehicleid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                AttachObjectToVehicle(editvneon[playerid][1], vehicleid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
            }
            case 1:
            {
                editvneon[playerid][2] = CreateObject(18646,0,0,0,0,0,0);
                AttachObjectToVehicle(editvneon[playerid][2], vehicleid, 0.0, -0.35, 0.90, 0.0, 0.0, 0.0);
            }
            case 2:
            {
                if(IsValidObject(editvneon[playerid][0])) DestroyObject(editvneon[playerid][0]);
                if(IsValidObject(editvneon[playerid][1])) DestroyObject(editvneon[playerid][1]);
                if(IsValidObject(editvneon[playerid][2])) DestroyObject(editvneon[playerid][2]);
                if(IsValidObject(vehneon[vehicleid][0])) DestroyObject(vehneon[vehicleid][0]);
                if(IsValidObject(vehneon[vehicleid][1])) DestroyObject(vehneon[vehicleid][1]);
                if(IsValidObject(vehneon[vehicleid][2])) DestroyObject(vehneon[vehicleid][2]);
            }
        }
    }
    else if(cur_menu == tune_nitro)
    {
        switch(men_row[playerid])
        {
            case 0: AddVehicleComponent(vehicleid, 1008);   
            case 1: AddVehicleComponent(vehicleid, 1009);   
            case 2: AddVehicleComponent(vehicleid, 1010);   
            case 3:
            {
                RemoveVehicleComponent(vehicleid, 1008);    
                RemoveVehicleComponent(vehicleid, 1009);    
                RemoveVehicleComponent(vehicleid, 1010);    
            }
        }
    }
    else if(cur_menu == tune_hydra)  
    {
        switch(men_row[playerid])
        {
            case 0: AddVehicleComponent(vehicleid, 1087);   
            case 1: RemoveVehicleComponent(vehicleid, 1087);    
        }
    }
    else if(cur_menu == tune_pjob)
    {
        switch(men_row[playerid])
        {
            case 0: ChangeVehiclePaintjob(vehicleid, 0);
            case 1: ChangeVehiclePaintjob(vehicleid, 1);
            case 2: ChangeVehiclePaintjob(vehicleid, 2);
            case 3: ChangeVehiclePaintjob(vehicleid, 3);
        }
    }
    return 1;
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

	LGGW[0] = TextDrawCreate(318.000000, 431.000000, "_");
    TextDrawFont(LGGW[0], 1);
    TextDrawLetterSize(LGGW[0], 0.641665, 1.999994);
    TextDrawTextSize(LGGW[0], 298.500000, 658.500000);
    TextDrawSetOutline(LGGW[0], 1);
    TextDrawSetShadow(LGGW[0], 0);
    TextDrawAlignment(LGGW[0], 2);
    TextDrawColor(LGGW[0], -1);
    TextDrawBackgroundColor(LGGW[0], 255);
    TextDrawBoxColor(LGGW[0], 113);
    TextDrawUseBox(LGGW[0], 1);
    TextDrawSetProportional(LGGW[0], 1);
    TextDrawSetSelectable(LGGW[0], 0);

    LGGW[1] = TextDrawCreate(319.000000, 431.000000, "get_started_with_~y~/help");
    TextDrawFont(LGGW[1], 2);
    TextDrawLetterSize(LGGW[1], 0.237498, 1.499999);
    TextDrawTextSize(LGGW[1], 640.000000, 480.000000);
    TextDrawSetOutline(LGGW[1], 0);
    TextDrawSetShadow(LGGW[1], 0);
    TextDrawAlignment(LGGW[1], 2);
    TextDrawColor(LGGW[1], -1);
    TextDrawBackgroundColor(LGGW[1], 255);
    TextDrawBoxColor(LGGW[1], 50);
    TextDrawUseBox(LGGW[1], 0);
    TextDrawSetProportional(LGGW[1], 1);
    TextDrawSetSelectable(LGGW[1], 0);

    LGGW[2] = TextDrawCreate(507.000000, 387.000000, "Lazer_Gaming~n~_____~w~Gang_Warz");
    TextDrawFont(LGGW[2], 3);
    TextDrawLetterSize(LGGW[2], 0.508333, 2.049999);
    TextDrawTextSize(LGGW[2], 754.000000, 556.000000);
    TextDrawSetOutline(LGGW[2], 0);
    TextDrawSetShadow(LGGW[2], 0);
    TextDrawAlignment(LGGW[2], 1);
    TextDrawColor(LGGW[2], 16711935);
    TextDrawBackgroundColor(LGGW[2], -1811885057);
    TextDrawBoxColor(LGGW[2], 50);
    TextDrawUseBox(LGGW[2], 0);
    TextDrawSetProportional(LGGW[2], 1);
    TextDrawSetSelectable(LGGW[2], 0);

	LGGW[3] = TextDrawCreate(21.000000, 309.000000 + 6, "]_~y~lazergam~y~i~r~n~y~~y~g.net_~w~]");
	TextDrawFont(LGGW[3], 0);
	TextDrawLetterSize(LGGW[3], 0.504166, 2.199999);
	TextDrawTextSize(LGGW[3], 761.000000, 109.500000);
	TextDrawSetOutline(LGGW[3], 1);
	TextDrawSetShadow(LGGW[3], 0);
	TextDrawAlignment(LGGW[3], 1);
	TextDrawColor(LGGW[3], -1);
	TextDrawBackgroundColor(LGGW[3], 255);
	TextDrawBoxColor(LGGW[3], 50);
	TextDrawUseBox(LGGW[3], 0);
	TextDrawSetProportional(LGGW[3], 1);
	TextDrawSetSelectable(LGGW[3], 0);

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
	TextDrawAlignment(takeovertd[1], 2);\
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

Tune_CreateMenus()
{
    tune_main = CreateMenu("Upgrades", 1, 83.000000, 138.000000, 150);
    AddMenuItem(tune_main, 0, "Colors");
    AddMenuItem(tune_main, 0, "Paint Jobs");
    AddMenuItem(tune_main, 0, "Neons");
    AddMenuItem(tune_main, 0, "Nitrous");
    AddMenuItem(tune_main, 0, "Hydraulics");
    AddMenuItem(tune_main, 0, "Wheels");

    tune_colors2 = CreateMenu("Upgrades", 1, 83.000000, 138.000000, 150);
    AddMenuItem(tune_colors2, 0, "Color 1");
    AddMenuItem(tune_colors2, 0, "Color 2");

    tune_colors = CreateMenu("Upgrades", 2, 83.000000, 138.000000, 150, 150);
    AddMenuItem(tune_colors, 0, "Black");
    AddMenuItem(tune_colors, 0, "White");
    AddMenuItem(tune_colors, 0, "Green");
    AddMenuItem(tune_colors, 0, "Cyan");
    AddMenuItem(tune_colors, 0, "Blue");
    AddMenuItem(tune_colors, 0, "Yellow");
    AddMenuItem(tune_colors, 0, "Grey");
    AddMenuItem(tune_colors, 0, "Pink");
    AddMenuItem(tune_colors, 0, "Orange");

    AddMenuItem(tune_colors, 1, "$150");
    AddMenuItem(tune_colors, 1, "$150");
    AddMenuItem(tune_colors, 1, "$150");
    AddMenuItem(tune_colors, 1, "$150");
    AddMenuItem(tune_colors, 1, "$150");
    AddMenuItem(tune_colors, 1, "$150");
    AddMenuItem(tune_colors, 1, "$150");
    AddMenuItem(tune_colors, 1, "$150");
    AddMenuItem(tune_colors, 1, "$150");

    tune_pjob = CreateMenu("Upgrades", 2, 83.000000, 138.000000, 150, 150);
    AddMenuItem(tune_pjob, 0, "Paint job 1");
    AddMenuItem(tune_pjob, 0, "Paint job 2");
    AddMenuItem(tune_pjob, 0, "Paint job 3");

    AddMenuItem(tune_pjob, 1, "$750");
    AddMenuItem(tune_pjob, 1, "$750");
    AddMenuItem(tune_pjob, 1, "$750");

    tune_hydra = CreateMenu("Upgrades", 2, 83.000000, 138.000000, 150, 150);
    AddMenuItem(tune_hydra, 0, "Hydraulics");
    AddMenuItem(tune_hydra, 0, "Remove Hydraulics");

    AddMenuItem(tune_hydra, 1, "$1000");
    AddMenuItem(tune_hydra, 1, "Free");

    tune_nitro = CreateMenu("Upgrades", 2, 83.000000, 138.000000, 150, 150);
    AddMenuItem(tune_nitro, 0, "Nitrous x2");
    AddMenuItem(tune_nitro, 0, "Nitrous x5");
    AddMenuItem(tune_nitro, 0, "Nitrous x10");
    AddMenuItem(tune_nitro, 0, "Remove nitrous");

    AddMenuItem(tune_nitro, 1, "$200");
    AddMenuItem(tune_nitro, 1, "$500");
    AddMenuItem(tune_nitro, 1, "$1000");
    AddMenuItem(tune_nitro, 1, "Free");

    tune_neons = CreateMenu("Upgrades", 2, 83.000000, 138.000000, 150, 150);
    AddMenuItem(tune_neons, 0, "Tube neon");
    AddMenuItem(tune_neons, 0, "Cup neon");
    AddMenuItem(tune_neons, 0, "Remove neons");

    AddMenuItem(tune_neons, 1, "$3000");
    AddMenuItem(tune_neons, 1, "$2000");
    AddMenuItem(tune_neons, 1, "Free");

    tune_wheels = CreateMenu("Upgrades", 2, 83.000000, 138.000000, 150, 150);
    AddMenuItem(tune_wheels, 0, "Shadow");
    AddMenuItem(tune_wheels, 0, "Mega");
    AddMenuItem(tune_wheels, 0, "Rinshine");
    AddMenuItem(tune_wheels, 0, "Wires");
    AddMenuItem(tune_wheels, 0, "Classic");
    AddMenuItem(tune_wheels, 0, "Twist");
    AddMenuItem(tune_wheels, 0, "Cutter");
    AddMenuItem(tune_wheels, 0, "Dollar");
    AddMenuItem(tune_wheels, 0, "Atomic");

    AddMenuItem(tune_wheels, 1, "$350");
    AddMenuItem(tune_wheels, 1, "$350");
    AddMenuItem(tune_wheels, 1, "$350");
    AddMenuItem(tune_wheels, 1, "$350");
    AddMenuItem(tune_wheels, 1, "$350");
    AddMenuItem(tune_wheels, 1, "$350");
    AddMenuItem(tune_wheels, 1, "$350");
    AddMenuItem(tune_wheels, 1, "$350");
    AddMenuItem(tune_wheels, 1, "$350");
}

CreatePlayerTextDraws(playerid)
{
	killtext[playerid] = CreatePlayerTextDraw(playerid, 318.000000, 112.000000, "First_Blood");
	PlayerTextDrawFont(playerid, killtext[playerid], 2);
	PlayerTextDrawLetterSize(playerid, killtext[playerid], 0.437500, 2.199999);
	PlayerTextDrawTextSize(playerid, killtext[playerid], 400.000000, 128.500000);
	PlayerTextDrawSetOutline(playerid, killtext[playerid], 1);
	PlayerTextDrawSetShadow(playerid, killtext[playerid], 0);
	PlayerTextDrawAlignment(playerid, killtext[playerid], 2);
	PlayerTextDrawColor(playerid, killtext[playerid], 255);
	PlayerTextDrawBackgroundColor(playerid, killtext[playerid], 255);
	PlayerTextDrawBoxColor(playerid, killtext[playerid], -1);
	PlayerTextDrawUseBox(playerid, killtext[playerid], 1);
	PlayerTextDrawSetProportional(playerid, killtext[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, killtext[playerid], 0);

    pleveltd[playerid] = CreatePlayerTextDraw(playerid, 536.000000, 115.000000, "lggw_hero~n~~n~~n~conqueror");
    PlayerTextDrawFont(playerid, pleveltd[playerid], 2);
    PlayerTextDrawLetterSize(playerid, pleveltd[playerid], 0.204163, 0.949998);
    PlayerTextDrawTextSize(playerid, pleveltd[playerid], 856.500000, 412.500000);
    PlayerTextDrawSetOutline(playerid, pleveltd[playerid], 0);
    PlayerTextDrawSetShadow(playerid, pleveltd[playerid], 0);
    PlayerTextDrawAlignment(playerid, pleveltd[playerid], 1);
    PlayerTextDrawColor(playerid, pleveltd[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, pleveltd[playerid], 255);
    PlayerTextDrawBoxColor(playerid, pleveltd[playerid], 50);
    PlayerTextDrawUseBox(playerid, pleveltd[playerid], 0);
    PlayerTextDrawSetProportional(playerid, pleveltd[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, pleveltd[playerid], 0);

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

	fplabel_1[playerid] = CreatePlayerTextDraw(playerid, 4.000000, 393.000000, "PL:_0.0~n~Ping:_180~n~FPS:_120");
	PlayerTextDrawFont(playerid, fplabel_1[playerid], 1);
	PlayerTextDrawLetterSize(playerid, fplabel_1[playerid], 0.225000, 0.950000);
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
	PlayerTextDrawTextSize(playerid, takeovertd_1[playerid][1], 640, 480);
	PlayerTextDrawSetOutline(playerid, takeovertd_1[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, takeovertd_1[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, takeovertd_1[playerid][1], 2);
	PlayerTextDrawColor(playerid, takeovertd_1[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, takeovertd_1[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, takeovertd_1[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, takeovertd_1[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, takeovertd_1[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, takeovertd_1[playerid][1], 0);

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

Menu:Tune_GetPreviousMenu(playerid)
{
    if(GetPlayerMenu(playerid) == tune_colors) 
    {
        if(PVehIs2ColorVehicle(GetVehicleModel(GetPlayerVehicleID(playerid)))) return tune_colors2;
        else return tune_main;
    }
    else return tune_main;
}

CMD:check(playerid, params[])
{
    Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT, 500);
    return 1;
}

CreateVehicles()
{
	AddStaticVehicleEx(487,2050.3052,-1694.4078,17.6442,267.9156,26,3, 60 * 3); //gang Vehicles by BloodHunter_
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
	AddStaticVehicleEx(487,1150.6158,-2020.3108,69.1972,269.6392,74,35, 60 * 3); 
	AddStaticVehicleEx(487,1150.5963,-2052.8835,69.1915,271.4837,26,14, 60 * 3); 
	AddStaticVehicleEx(555,1261.4601,-2010.0002,59.0622,0.5308,68,1, 60 * 3); 
	AddStaticVehicleEx(555,1252.1614,-803.7568,83.8245,167.6100,58,1, 60 * 3); 
	AddStaticVehicleEx(560,1245.0131,-803.4440,83.8456,168.0584,17,1, 60 * 3); 
	AddStaticVehicleEx(461,1299.0231,-804.2794,83.7300,303.6593,79,1, 60 * 3);
	AddStaticVehicleEx(461,1298.7006,-809.2598,83.7247,302.2619,88,1, 60 * 3); 
	AddStaticVehicleEx(487,1284.2021,-827.8125,83.3906,179.3584,26,57, 60 * 3); 
	AddStaticVehicleEx(487,1304.2423,-1380.1681,13.9091,180.2378,54,29, 60 * 3); 
	AddStaticVehicleEx(439,1325.3503,-1375.9314,13.7338,179.3055,37,78, 60 * 3); 
	AddStaticVehicleEx(402,1318.2467,-1380.4982,13.6553,179.6103,13,13, 60 * 3); 
	AddStaticVehicleEx(429,1313.8585,-1380.6046,13.4061,179.2462,1,2, 60 * 3); 
	AddStaticVehicleEx(461,1314.2023,-1369.4952,13.1570,181.3939,53,1, 60 * 3); 
	AddStaticVehicleEx(461,1317.4529,-1369.3142,13.1681,186.8571,61,1, 60 * 3); 
	AddStaticVehicleEx(439,1295.1191,-1377.3073,13.6817,179.5653,65,79, 60 * 3); 
	AddStaticVehicleEx(510,1304.4141,-1369.7004,13.1734,174.2131,46,46, 60 * 3); 
	AddStaticVehicleEx(429,1101.9417,-1225.7065,15.5034,177.2475,10,10, 60 * 3); 
	AddStaticVehicleEx(424,1092.7089,-1225.1332,15.6003,176.5051,2,2, 60 * 3); 
	AddStaticVehicleEx(536,809.8713,-1388.6364,13.3547,179.8051,26,96, 60 * 3); 
	AddStaticVehicleEx(402,822.6026,-1388.3512,13.4508,179.5506,39,39, 60 * 3); 
	AddStaticVehicleEx(471,819.3466,-1386.6023,13.0845,178.2803,103,111, 60 * 3); 
	AddStaticVehicleEx(461,813.8742,-1387.6547,13.1945,182.5773,88,1, 60 * 3); 
	AddStaticVehicleEx(461,812.4167,-1387.6215,13.1922,171.4878,88,1, 60 * 3); 
	AddStaticVehicleEx(467,1101.4470,-1218.4135,17.5446,358.3337,68,8, 60 * 3); 
	AddStaticVehicleEx(400,1085.2526,-1242.6229,15.9195,269.9104,62,1, 60 * 3); 
	AddStaticVehicleEx(461,726.4941,-1273.9799,13.2339,273.7609,43,1, 60 * 3); 
	AddStaticVehicleEx(560,730.5157,-1265.8954,13.2579,359.7838,37,0, 60 * 3);  
	AddStaticVehicleEx(461,2433.1768,-1221.0995,24.8323,147.9305,43,1, 60 * 3);  
	AddStaticVehicleEx(461,2427.8972,-1220.8259,25.0251,139.4601,61,1, 60 * 3);  
	AddStaticVehicleEx(487,2400.2256,-1234.5665,28.5173,184.0050,3,29, 60 * 3);  
	AddStaticVehicleEx(402,2422.9453,-1241.2670,24.0064,180.0479,98,98, 60 * 3);  
	AddStaticVehicleEx(560,2438.7988,-1222.2675,24.7728,180.1222,52,39, 60 * 3);  
	AddStaticVehicleEx(555,2417.5044,-1224.3641,24.6707,353.7825,68,1, 60 * 3);  
	AddStaticVehicleEx(510,2424.2808,-1220.9044,25.0570,168.4189,39,39, 60 * 3); 
	AddStaticVehicleEx(541,1108.2057,-1180.8838,18.4934,270.3571,2,1, 60 * 3); 
	AddStaticVehicleEx(487,1130.2794,-1222.3463,25.5520,358.0731,12,39, 60 * 3); 
	AddStaticVehicleEx(487,1129.7041,-1245.1582,25.5020,359.3068,74,35, 60 * 3); 
	AddStaticVehicleEx(517,2299.5071,-1767.3784,13.4396,359.6973,36,36, 60 * 3); 
	AddStaticVehicleEx(426,1806.4152,-1583.0343,13.2538,310.9771,7,7, 60 * 3); 
	AddStaticVehicleEx(554,1806.1375,-1684.3353,13.6072,270.4196,65,32, 60 * 3); 
	AddStaticVehicleEx(429,1739.9811,-1613.4016,13.2266,359.7740,1,3, 60 * 3); 
	AddStaticVehicleEx(495,1705.2269,-1685.8593,13.8947,91.0344,118,117, 60 * 3); 
	AddStaticVehicleEx(415,1144.4125,-1763.4756,13.4107,0.4871,62,1, 60 * 3); 
	AddStaticVehicleEx(547,1209.5724,-1486.5035,13.2828,90.7557,123,1, 60 * 3); 
	AddStaticVehicleEx(547,1216.3541,-1557.1946,13.2825,179.8785,123,1, 60 * 3); 
	AddStaticVehicleEx(560,1207.7418,-1555.3094,13.2526,180.3390,9,39, 60 * 3); 
	AddStaticVehicleEx(495,613.5044,-1348.5411,14.0268,279.6028,114,108, 60 * 3); 
	AddStaticVehicleEx(489,2419.1597,-1104.7865,40.8763,358.3017,84,110, 60 * 3); 
	AddStaticVehicleEx(439,2425.2356,-1099.8359,41.4993,10.6573,8,17, 60 * 3); 
	AddStaticVehicleEx(429,1728.6591,-1330.4855,13.2655,64.8039,10,10, 60 * 3); 
	AddStaticVehicleEx(429,1501.4850,-1317.9822,13.8033,1.3703,10,10, 60 * 3); 
	AddStaticVehicleEx(426,1524.1987,-1176.8271,23.7998,359.0453,37,37, 60 * 3); 
	AddStaticVehicleEx(567,1434.4799,-1049.9753,23.7002,0.0067,99,81, 60 * 3); 
	AddStaticVehicleEx(567,1298.5533,-1059.6028,29.1408,0.9314,99,81, 60 * 3); 
	AddStaticVehicleEx(560,1212.2505,-1128.7396,23.7710,182.7382,37,0, 60 * 3); 
	AddStaticVehicleEx(560,1096.7997,-1083.0996,26.3226,88.7909,37,0, 60 * 3); 
	AddStaticVehicleEx(542,1248.4432,-972.7236,39.9460,268.2815,119,113, 60 * 3); 
	AddStaticVehicleEx(448,1191.1658,-917.7927,42.8075,193.3018,3,6, 60 * 3); 
	AddStaticVehicleEx(448,1189.9120,-918.6534,42.8226,197.3931,3,6, 60 * 3); 
	AddStaticVehicleEx(400,1425.7166,-1145.9573,23.9732,177.9815,36,1, 60 * 3); 
	AddStaticVehicleEx(402,1276.9452,-1302.3647,13.1560,359.1013,22,22, 60 * 3); 
	AddStaticVehicleEx(416,1178.0341,-1338.2245,14.0271,272.5762,1,3, 60 * 3); 
	AddStaticVehicleEx(467,785.2601,-1800.5122,12.7634,356.6745,58,8, 60 * 3); 
	AddStaticVehicleEx(475,1210.8298,-1486.1558,13.3504,90.9611,37,0, 60 * 3); 
	AddStaticVehicleEx(449,2284.8750,-1133.2894,27.2674,180.0000,1,74, 60 * 3); 
	AddStaticVehicleEx(449,1688.0338,-1953.6306,13.9973,270.0359,1,74, 60 * 3); 
	AddStaticVehicleEx(535,2498.5098,-2022.1201,13.3099,0.2961,28,1, 60 * 3); 
	AddStaticVehicleEx(535,2158.5457,-1794.9449,13.1239,271.7294,31,1, 60 * 3); 
	AddStaticVehicleEx(474,2249.9731,-1908.8552,13.3097,0.1644,84,1, 60 * 3); 
	AddStaticVehicleEx(474,2273.1030,-1907.6173,13.3082,359.1305,84,1, 60 * 3); 
	AddStaticVehicleEx(470,1949.3920,-1873.0367,13.5553,0.4738,43,0, 60 * 3); 
	AddStaticVehicleEx(560,1672.5359,-1750.1141,13.2508,359.5661,9,39, 60 * 3); 
	AddStaticVehicleEx(579,1368.0479,-1885.3054,13.4577,0.6806,42,42, 60 * 3); 
	AddStaticVehicleEx(491,1311.1588,-1485.7760,13.3031,269.5330,30,72, 60 * 3); 
	AddStaticVehicleEx(489,1360.6267,-1488.9408,13.6887,68.4406,76,102, 60 * 3);

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
	AddStaticVehicleEx(480,1377.3156,-1096.4209,24.8927,93.1781,5,1, 60 * 3); // BlazeRay_ Comet [Second Donation]



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
	AddStaticVehicleEx(474,2445.3430000,-1325.7814000,23.6705000,0.8372000,22,16,60 * 3); //Hermes
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
	AddStaticVehicleEx(579,1461.6138000,-1406.1893000,13.4818000,179.4314000,54,42,60 * 3); //Huntley
	AddStaticVehicleEx(522,1531.5944000,-1451.9625000,12.9548000,4.1184000,60,0,60 * 3); //NRG-500
	AddStaticVehicleEx(487,1476.7988000,-1292.9109000,13.7690000,87.8844000,29,42,60 * 3); //Maverick
	AddStaticVehicleEx(416,2002.9579000,-1415.3356000,17.1411000,177.9899000,1,3,60 * 3); //Ambulance
	AddStaticVehicleEx(522,1973.2185000,-1439.8990000,13.0730000,94.9563000,3,0,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1972.9475000,-1437.5325000,13.0775000,90.5696000,3,0,60 * 3); //NRG-500
	AddStaticVehicleEx(522,1973.6080000,-1442.1852000,13.0674000,93.0322000,6,25,60 * 3); //NRG-500
	AddStaticVehicleEx(481,1884.6495000,-1369.5531000,13.0838000,82.0393000,12,9,60 * 3); //BMX
	AddStaticVehicleEx(481,1890.1118000,-1362.8639000,13.0205000,173.7132000,26,1,60 * 3); //BMX
	AddStaticVehicleEx(481,1885.5587000,-1355.7878000,13.0010000,276.7696000,14,1,60 * 3); //BMX
	AddStaticVehicleEx(579,1715.6182000,-1576.7150000,13.4833000,176.5975000,62,62,60 * 3); //Huntley
	AddStaticVehicleEx(400,1742.9714000,-1747.5903000,13.6323000,359.0181000,123,1,60 * 3); //Landstalker
	AddStaticVehicleEx(482,1345.9530000,-1753.6694000,13.4808000,358.5551000,0,0,60 * 3); //Burrito
	AddStaticVehicleEx(448,2117.6392000,-1784.6228000,12.9866000,358.3927000,3,6,60 * 3); //Pizzaboy
	AddStaticVehicleEx(448,2118.6680000,-1784.7036000,12.9992000,357.2917000,3,6,60 * 3); //Pizzaboy
	AddStaticVehicleEx(448,2111.6201000,-1784.6499000,12.9832000,355.7061000,3,6,60 * 3); //Pizzaboy
	AddStaticVehicleEx(448,2110.4790000,-1784.4723000,12.9866000,352.8771000,3,6,60 * 3); //Pizzaboy
	AddStaticVehicleEx(402,2476.0110000,-2117.6929000,13.3797000,358.5579000,22,22,60 * 3); //Buffalo
	AddStaticVehicleEx(402,2469.4058000,-2117.9854000,13.3792000,2.5414000,30,30,60 * 3); //Buffalo
	AddStaticVehicleEx(461,2451.8093000,-2120.3416000,13.1205000,46.0395000,88,1,60 * 3); //PCJ-600
	AddStaticVehicleEx(461,2448.0063000,-2120.2498000,13.1291000,36.7806000,79,1,60 * 3); //PCJ-600
	AddStaticVehicleEx(461,2445.5457000,-2120.1182000,13.1293000,34.5774000,61,1,60 * 3); //PCJ-600
	AddStaticVehicleEx(521,2457.2290000,-2081.6399000,13.1075000,179.8145000,92,3,60 * 3); //FCR-900
	AddStaticVehicleEx(521,2455.3450000,-2081.3892000,13.1157000,176.1868000,87,118,60 * 3); //FCR-900
	AddStaticVehicleEx(588,2397.1694000,-1889.3961000,13.2935000,270.6021000,1,1,60 * 3); //Hotdog
	AddStaticVehicleEx(493,2596.5444000,-2476.9480000,-0.0123000,268.0885000,36,13,60 * 3); //Jetmax
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
	AddStaticVehicleEx(463,489.0911000,-1767.1393000,5.0837000,173.2824000,53,53,60 * 3); //Freeway
	AddStaticVehicleEx(482,515.3393000,-1767.0791000,5.6216000,178.3167000,41,41,60 * 3); //Burrito
	AddStaticVehicleEx(487,504.3589000,-1796.0552000,6.0465000,173.2168000,41,0,60 * 3); //Maverick
	AddStaticVehicleEx(490,745.7175000,-1293.3507000,13.6930000,270.0052000,0,0,60 * 3); //FBI Rancher
	AddStaticVehicleEx(560,745.2401000,-1272.7728000,13.2623000,269.0181000,0,0,60 * 3); //Sultan
	AddStaticVehicleEx(541,745.4940000,-1268.8285000,13.1803000,269.9022000,3,0,60 * 3); //Bullet
	AddStaticVehicleEx(560,745.5299000,-1247.3076000,13.2097000,268.0338000,0,0,60 * 3); //Sultan
	AddStaticVehicleEx(490,747.1693000,-1241.3002000,13.6849000,268.7546000,0,0,60 * 3); //FBI Rancher
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
	AddStaticVehicleEx(463,1952.2970000,-1767.9891000,13.0932000,311.2477000,53,53,60 * 3); //Freeway
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

	//dm9 blocks
    CreateObject(744, 98.805076, 1920.383544, 17.335149, 0.000000, 0.000000, 0.000000);
    CreateObject(2395, 226.300018, 1873.819580, 12.754375, 0.000000, 0.000000, 270.000000);
    CreateObject(2395, 226.459991, 1871.469726, 12.624362, 0.000000, 0.000000, 90.000000);
    CreateObject(2395, 264.932830, 1880.018310, 15.660654, 270.000000, 0.000000, 0.000000);
    CreateObject(2395, 264.932830, 1882.759277, 15.660654, 270.000000, 0.000000, 0.000000);
    CreateObject(2395, 264.932830, 1885.491821, 15.660654, 270.000000, 0.000000, 0.000000);
    CreateObject(2395, 268.662750, 1885.491821, 15.660654, 270.000000, 0.000000, 0.000000);
    CreateObject(2395, 268.662750, 1882.760864, 15.660654, 270.000000, 0.000000, 0.000000);
    CreateObject(2395, 268.662750, 1880.020385, 15.660654, 270.000000, 0.000000, 0.000000);
    CreateObject(2395, 272.382690, 1880.020385, 15.660654, 270.000000, 0.000000, 0.000000);
    CreateObject(2395, 272.382690, 1882.760742, 15.660654, 270.000000, 0.000000, 0.000000);
    CreateObject(2395, 272.382690, 1885.490600, 15.660654, 270.000000, 0.000000, 0.000000);
    
    //Gun Game
    CreateObject(19313, 1559.335327, 1917.478393, 13.210295, 0.000000, 0.000000, -83.300010);
    CreateObject(19313, 1557.695678, 1931.431762, 13.210295, 0.000000, 0.000000, -83.300010);
    CreateObject(5821, 1565.801391, 1931.984008, 9.590299, 0.000000, 0.000000, -84.899971);
    CreateObject(3593, 1664.893920, 1973.995117, 11.510308, 0.000000, 0.000000, -57.699989);
    CreateObject(3475, 1670.025146, 1999.335449, 14.160312, 0.000000, 0.000000, -88.299987);
    CreateObject(3475, 1664.027099, 1999.158203, 14.160312, 0.000000, 0.000000, -88.299987);
    CreateObject(19608, 1568.263793, 1891.517089, 9.920308, 0.000000, 0.000000, 178.800109);
    CreateObject(19339, 1568.392700, 1892.631835, 10.360308, 0.000000, 0.000000, 0.000000);
    CreateObject(3475, 1579.815307, 1961.267822, 13.330307, 0.000000, 0.000000, 0.000000);
    CreateObject(3475, 1579.815307, 1967.077636, 13.330307, 0.000000, 0.000000, 0.000000);
    CreateObject(3475, 1579.815307, 1972.937744, 13.330307, 0.000000, 0.000000, 0.000000);
    CreateObject(3475, 1565.023925, 1888.570556, 13.380311, 0.000000, 0.000000, -90.100028);
    CreateObject(3475, 1570.844970, 1888.560913, 13.380311, 0.000000, 0.000000, -90.100028);
    CreateObject(3406, 1563.729858, 1925.043823, 11.360321, 0.000000, 0.000000, -81.499984);
    CreateObject(3515, 1630.770385, 1944.976440, 9.265646, 0.000000, 0.000000, 0.000000);
    CreateObject(3475, 1627.979614, 1888.375976, 13.190312, 0.000000, 0.000000, -89.999946);
    CreateObject(19313, 1557.695678, 1931.431762, 13.210294, 0.000000, 0.000000, -83.300010);
    CreateObject(19313, 1559.335327, 1917.478393, 13.210294, 0.000000, 0.000000, -83.300010);
    CreateObject(5821, 1565.801391, 1931.984008, 9.590298, 0.000000, 0.000000, -84.899971);
    CreateObject(13591, 1666.453979, 1972.512451, 10.700311, 0.000000, 0.000000, -39.999996);
    CreateObject(18251, 1671.521362, 1933.388916, 18.820297, 0.000000, 0.000000, -179.800064);
    CreateObject(3515, 1609.779296, 1945.646728, 9.265646, 0.000000, 0.000000, 0.000000);
    CreateObject(19870, 1674.318115, 1923.104614, 12.924360, 0.000000, 0.000000, -92.599945);
    CreateObject(3475, 1622.109619, 1888.375976, 13.190312, 0.000000, 0.000000, -89.999946);

    //Easter eggs
    CreateObject(3524, 818.590881, -1092.026733, 24.101152, 0.000000, 0.000000, 0.000000); 
    CreateObject(3524, 812.470703, -1092.026733, 24.101152, 0.000000, 0.000000, 0.000000);
    CreateObject(19056, 815.564025, -1093.239379, 25.370080, 0.000000, 0.000000, 0.000000);
    CreateObject(19056, 393.374176, -2055.077148, 13.425203, 0.000000, 0.000000, 0.000000);
    CreateObject(18655, 396.289916, -2055.139648, 12.046230, 0.000000, 0.000000, 0.000000);
    CreateObject(19056, 1117.794311, -2037.017333, 78.420944, 0.000000, 0.000000, 0.000000);
    CreateObject(18655, 1118.433227, -2034.062988, 76.816551, 0.000000, 0.000000, 81.000000);
    CreateObject(19056, 1415.894042, -807.208984, 84.596931, 0.000000, 0.000000, 0.000000);
    CreateObject(18655, 1418.925415, -806.281127, 83.828819, 0.000000, 0.000000, 0.000000);
    CreateObject(18655, 1412.563842, -806.281127, 83.828819, 0.000000, 0.000000, 172.299987);
    CreateObject(19056, 2940.310302, -2051.727050, 3.198043, 0.000000, 0.000000, 0.000000);
    CreateObject(18655, 2940.539550, -2054.636962, 2.008044, 0.000000, 0.000000, -79.899978);

    //dm7 map
    new tmpobjid;
    tmpobjid =  CreateObject(18981, 638.6561, 1719.2890, 484.5446, 0.0000, 0.0000, 0.0000); //Concrete1mx25mx25m
    SetObjectMaterial(tmpobjid, 0, 13295, "ce_terminal", "des_adobewall2", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18981, 625.6966, 1706.8703, 496.5546, 0.0000, 90.0000, 0.0000); //Concrete1mx25mx25m
    SetObjectMaterial(tmpobjid, 0, 11425, "des_clifftown", "des_adobewall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19604, 639.0688, 1720.6423, 492.2246, 0.0000, 0.0000, 90.0000); //WaterPlane2
    tmpobjid =  CreateObject(18981, 613.7261, 1719.2890, 497.8649, 0.0000, 0.0000, 0.0000); //Concrete1mx25mx25m
    SetObjectMaterial(tmpobjid, 0, 6867, "vgnpwrmainbld", "sw_wallbrick_02", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 622.6519, 1741.3360, 497.5083, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18981, 625.6966, 1735.7403, 496.5546, 0.0000, 90.0000, 0.0000); //Concrete1mx25mx25m
    SetObjectMaterial(tmpobjid, 0, 11425, "des_clifftown", "des_adobewall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19604, 619.0693, 1720.6423, 492.2246, 0.0000, 0.0000, 90.0000); //WaterPlane2
    tmpobjid =  CreateObject(19604, 629.0695, 1720.6423, 492.2246, 0.0000, 0.0000, 90.0000); //WaterPlane2
    tmpobjid =  CreateObject(18981, 625.6966, 1718.8691, 483.7146, 0.0000, 0.0000, 90.0000); //Concrete1mx25mx25m
    SetObjectMaterial(tmpobjid, 0, 13295, "ce_terminal", "des_adobewall2", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18981, 613.7361, 1719.2890, 484.5446, 0.0000, 0.0000, 0.0000); //Concrete1mx25mx25m
    SetObjectMaterial(tmpobjid, 0, 13295, "ce_terminal", "des_adobewall2", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18981, 613.7261, 1744.2885, 497.8649, 0.0000, 0.0000, 0.0000); //Concrete1mx25mx25m
    SetObjectMaterial(tmpobjid, 0, 6867, "vgnpwrmainbld", "sw_wallbrick_02", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18981, 613.7261, 1694.2987, 497.8649, 0.0000, 0.0000, 0.0000); //Concrete1mx25mx25m
    SetObjectMaterial(tmpobjid, 0, 6867, "vgnpwrmainbld", "sw_wallbrick_02", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18981, 625.7164, 1693.8892, 497.8645, 0.0000, 0.0000, 90.0000); //Concrete1mx25mx25m
    SetObjectMaterial(tmpobjid, 0, 6867, "vgnpwrmainbld", "sw_wallbrick_02", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18981, 625.7164, 1748.6494, 497.8640, 0.0000, 0.0000, 90.0000); //Concrete1mx25mx25m
    SetObjectMaterial(tmpobjid, 0, 6867, "vgnpwrmainbld", "sw_wallbrick_02", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18981, 638.6760, 1735.9086, 497.8645, 0.0000, 0.0000, 0.0000); //Concrete1mx25mx25m
    SetObjectMaterial(tmpobjid, 0, 6867, "vgnpwrmainbld", "sw_wallbrick_02", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18981, 638.6761, 1710.9288, 497.8649, 0.0000, 0.0000, 0.0000); //Concrete1mx25mx25m
    SetObjectMaterial(tmpobjid, 0, 6867, "vgnpwrmainbld", "sw_wallbrick_02", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18981, 638.6761, 1685.9289, 497.8640, 0.0000, 0.0000, 0.0000); //Concrete1mx25mx25m
    SetObjectMaterial(tmpobjid, 0, 6867, "vgnpwrmainbld", "sw_wallbrick_02", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19790, 614.6934, 1707.9929, 494.7000, 0.0000, 0.0000, 0.0000); //Cube5mx5m
    SetObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "cheerybox03", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19790, 637.9835, 1708.0731, 494.7000, 0.0000, 0.0000, 0.0000); //Cube5mx5m
    SetObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "cheerybox03", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19790, 614.6934, 1734.9831, 494.7000, 0.0000, 0.0000, 0.0000); //Cube5mx5m
    SetObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "cheerybox03", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19790, 637.9835, 1734.9831, 494.7000, 0.0000, 0.0000, 0.0000); //Cube5mx5m
    SetObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "cheerybox03", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 630.2025, 1740.4063, 497.5083, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 632.2025, 1738.3575, 498.5082, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 625.2826, 1740.4067, 499.8481, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 630.1925, 1740.3863, 499.4881, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 630.2025, 1741.3360, 497.5083, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 622.6524, 1740.4063, 497.5083, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 622.6524, 1740.4063, 499.4983, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18766, 630.6221, 1736.4210, 500.0315, 90.0000, 90.0000, 0.0000); //Concrete10mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 3355, "cxref_savhus", "des_brick1", 0xFF991E1E);
    tmpobjid =  CreateObject(18766, 627.5520, 1736.4210, 500.0304, 90.0000, 90.0000, 0.0000); //Concrete10mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 3355, "cxref_savhus", "des_brick1", 0xFF991E1E);
    tmpobjid =  CreateObject(18766, 621.4520, 1736.4210, 500.0304, 90.0000, 90.0000, 0.0000); //Concrete10mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 3355, "cxref_savhus", "des_brick1", 0xFF991E1E);
    tmpobjid =  CreateObject(18766, 623.1419, 1735.9306, 500.0314, 90.0000, 90.0000, 0.0000); //Concrete10mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 3355, "cxref_savhus", "des_brick1", 0xFF991E1E);
    tmpobjid =  CreateObject(1437, 624.5335, 1741.7770, 495.5811, 0.0000, 0.0000, 180.0000); //DYN_LADDER_2
    tmpobjid =  CreateObject(18762, 630.1825, 1740.3764, 498.5082, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 622.6524, 1740.4063, 498.5082, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 632.1925, 1733.3780, 499.8481, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 632.2025, 1728.9671, 498.5082, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 632.2025, 1726.6367, 499.8481, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 628.1928, 1724.6367, 497.5083, 0.0000, 0.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18981, 625.6966, 1723.7095, 483.7146, 0.0000, 0.0000, 90.0000); //Concrete1mx25mx25m
    SetObjectMaterial(tmpobjid, 0, 13295, "ce_terminal", "des_adobewall2", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 630.1926, 1731.8662, 501.2081, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 620.6526, 1733.3773, 499.8481, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 620.6728, 1728.9671, 499.4682, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 623.5031, 1724.6463, 499.8481, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 632.2028, 1737.4365, 497.5083, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 632.2025, 1738.3565, 499.4980, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 632.2030, 1728.9676, 499.5082, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 632.2028, 1727.5975, 497.5083, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18766, 630.6223, 1728.9199, 500.0310, 90.0000, 90.0000, 0.0000); //Concrete10mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 3355, "cxref_savhus", "des_brick1", 0xFF991E1E);
    tmpobjid =  CreateObject(18766, 621.4520, 1728.9113, 500.0325, 90.0000, 90.0000, 0.0000); //Concrete10mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 3355, "cxref_savhus", "des_brick1", 0xFF991E1E);
    tmpobjid =  CreateObject(18766, 625.9226, 1728.9113, 500.0320, 90.0000, 90.0000, 0.0000); //Concrete10mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 3355, "cxref_savhus", "des_brick1", 0xFF991E1E);
    tmpobjid =  CreateObject(18762, 625.2826, 1724.6469, 499.8481, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 624.6326, 1724.6367, 497.5083, 0.0000, 0.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 630.2026, 1724.6367, 497.5083, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 632.2028, 1732.4670, 497.5083, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 620.6525, 1737.4365, 497.5083, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 620.6524, 1738.3571, 498.5082, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 620.6524, 1738.3571, 499.4981, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 620.6525, 1727.5178, 497.5083, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 620.6925, 1726.6367, 499.8481, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 620.6525, 1732.4670, 497.5083, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 620.6728, 1728.9671, 498.5082, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 629.2827, 1724.6463, 499.8481, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 622.6425, 1724.6367, 497.5083, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(1347, 631.4304, 1731.6833, 500.9993, 0.0000, 0.0000, 0.0000); //CJ_WASTEBIN
    tmpobjid =  CreateObject(18762, 622.1225, 1731.8757, 501.2081, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 628.2028, 1728.8769, 501.2090, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 624.1326, 1728.8759, 501.2098, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 625.0923, 1728.8763, 503.2699, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 622.1127, 1728.8763, 502.0698, 0.0000, 0.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 630.2030, 1728.8764, 502.0698, 0.0000, 0.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 627.2022, 1728.8774, 503.2697, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 630.2030, 1731.8657, 504.0697, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 630.2030, 1731.8659, 503.0798, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 630.2030, 1731.8660, 502.2098, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 622.1225, 1731.8757, 502.1981, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 622.1225, 1731.8757, 503.1781, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 622.1225, 1731.8757, 504.1281, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 629.2231, 1733.8666, 502.0698, 0.0000, 0.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 628.2333, 1733.8666, 502.0698, 0.0000, 0.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 623.1032, 1733.8666, 502.0698, 0.0000, 0.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 624.0833, 1733.8666, 502.0698, 0.0000, 0.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 626.1423, 1733.8764, 504.0697, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18766, 626.1221, 1731.8807, 504.1414, 90.0000, 90.0000, 90.0000); //Concrete10mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 3355, "cxref_savhus", "des_brick1", 0xFF991E1E);
    tmpobjid =  CreateObject(18766, 626.1226, 1730.8208, 504.1424, 90.0000, 90.0000, 90.0000); //Concrete10mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 3355, "cxref_savhus", "des_brick1", 0xFF991E1E);
    tmpobjid =  CreateObject(1428, 623.1900, 1734.7751, 502.9566, 0.0000, 0.0000, 180.0000); //DYN_LADDER
    tmpobjid =  CreateObject(18762, 625.0633, 1733.8666, 502.0698, 0.0000, 0.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19464, 623.6583, 1736.9361, 496.9349, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19464, 629.2084, 1736.9361, 496.9349, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19464, 625.6384, 1736.9361, 496.9339, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19464, 625.6384, 1731.0163, 496.9349, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19464, 623.6583, 1731.0067, 496.9354, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19464, 629.2883, 1731.0067, 496.9354, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19464, 629.2084, 1727.1162, 496.9339, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19464, 623.6285, 1727.1162, 496.9349, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19464, 626.5686, 1727.1077, 496.9335, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19430, 626.4361, 1720.0957, 496.9679, 0.0000, 90.0000, 90.0000); //wall070
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19430, 626.4353, 1722.3875, 496.9690, 0.0000, 90.0000, 90.0000); //wall070
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19789, 624.7652, 1729.0773, 504.5921, 0.0000, 0.0000, 151.4999); //Cube1mx1m
    SetObjectMaterial(tmpobjid, 0, 1736, "cj_ammo", "CJ_SLATEDWOOD2", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19789, 625.9905, 1729.1839, 504.5928, 0.0000, 0.0000, 133.7999); //Cube1mx1m
    SetObjectMaterial(tmpobjid, 0, 1736, "cj_ammo", "CJ_SLATEDWOOD2", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19789, 625.3105, 1729.1040, 505.5429, 0.0000, 0.0000, -167.5000); //Cube1mx1m
    SetObjectMaterial(tmpobjid, 0, 1736, "cj_ammo", "CJ_SLATEDWOOD2", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19789, 623.1386, 1734.8714, 500.5129, 0.0000, 0.0000, 0.0000); //Cube1mx1m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19789, 624.0786, 1734.8714, 500.5129, 0.0000, 0.0000, 0.0000); //Cube1mx1m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18981, 625.6966, 1718.8691, 491.6947, 0.0000, 90.0000, 90.0000); //Concrete1mx25mx25m
    SetObjectMaterial(tmpobjid, 0, 13295, "ce_terminal", "des_adobewall2", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 624.1334, 1728.8764, 500.8898, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 628.0739, 1728.8771, 500.8898, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 622.1235, 1731.7966, 500.8898, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 630.1935, 1731.7966, 500.8898, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 630.2033, 1733.8666, 502.0698, 0.0000, 0.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 629.2827, 1717.9256, 499.8481, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 628.1928, 1717.9262, 497.5083, 0.0000, 0.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 625.2826, 1717.9256, 499.8481, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 622.6425, 1717.9256, 497.5083, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 630.2026, 1717.9256, 497.5083, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 623.5026, 1717.9256, 499.8481, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 624.6426, 1717.9262, 497.5083, 0.0000, 0.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 620.6525, 1715.8984, 497.5075, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 620.6525, 1715.9284, 499.8481, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 632.2021, 1715.9284, 499.8481, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 632.2028, 1715.9176, 497.5075, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 632.2028, 1704.6274, 497.5075, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 632.2028, 1709.6076, 497.5075, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 632.2022, 1712.4571, 497.5069, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 632.2022, 1712.4571, 498.5069, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 632.2022, 1712.4571, 499.4969, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 632.2021, 1710.9393, 499.8481, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 632.2021, 1705.9699, 499.8481, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 632.2021, 1704.6303, 499.8476, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 632.2022, 1703.7066, 498.5069, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 632.2022, 1703.7155, 499.4769, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 630.2025, 1701.7055, 498.5082, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 630.2025, 1701.7055, 497.5082, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 630.2025, 1701.7055, 499.4982, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 630.2020, 1701.7060, 499.8370, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 622.6524, 1701.7054, 497.5183, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 622.6524, 1701.7054, 498.5082, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 622.6524, 1701.7054, 499.5083, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 622.6618, 1701.7060, 499.8370, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 625.2826, 1701.7049, 499.8370, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 620.6523, 1712.4571, 497.5069, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 620.6523, 1712.4571, 498.4970, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 620.6523, 1712.4571, 499.4970, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 620.6527, 1712.4576, 499.8370, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 620.6529, 1709.6076, 497.5075, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 620.6526, 1704.6274, 497.5075, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 620.6524, 1703.7066, 498.5069, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 620.6524, 1703.7066, 499.5069, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 620.6524, 1703.7066, 499.8370, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 620.6524, 1708.5166, 499.8370, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(19464, 629.2084, 1715.4467, 496.9339, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19464, 629.2084, 1709.5169, 496.9339, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19464, 629.2084, 1705.1567, 496.9345, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19464, 623.5384, 1705.1567, 496.9345, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19464, 623.5384, 1715.4573, 496.9345, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19464, 623.5384, 1710.7172, 496.9338, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19464, 624.7885, 1705.1470, 496.9330, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19464, 624.7885, 1711.0866, 496.9330, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19464, 624.7885, 1715.4665, 496.9335, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 622.6519, 1700.7363, 497.5083, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 630.2020, 1700.7363, 497.5083, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 630.2030, 1715.1157, 502.0698, 0.0000, 0.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18766, 630.6223, 1713.6694, 500.0310, 90.0000, 90.0000, 0.0000); //Concrete10mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 3355, "cxref_savhus", "des_brick1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18766, 630.6223, 1706.1898, 500.0317, 90.0000, 90.0000, 0.0000); //Concrete10mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 3355, "cxref_savhus", "des_brick1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18766, 625.6226, 1705.4699, 500.0317, 90.0000, 90.0000, 0.0000); //Concrete10mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 3355, "cxref_savhus", "des_brick1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18766, 625.6224, 1713.6694, 500.0304, 90.0000, 90.0000, 0.0000); //Concrete10mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 3355, "cxref_savhus", "des_brick1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18766, 621.6820, 1705.4699, 500.0310, 90.0000, 90.0000, 0.0000); //Concrete10mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 3355, "cxref_savhus", "des_brick1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18766, 621.6925, 1713.6694, 500.0320, 90.0000, 90.0000, 0.0000); //Concrete10mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 3355, "cxref_savhus", "des_brick1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 622.1127, 1715.1157, 502.0698, 0.0000, 0.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 624.1334, 1715.1157, 500.8898, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 628.0739, 1715.1157, 500.8898, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 624.1326, 1715.1157, 501.2098, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 628.2028, 1715.1157, 501.2090, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 627.2022, 1715.1157, 503.2697, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 625.0923, 1715.1157, 503.2699, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 622.1235, 1712.1359, 500.8898, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 622.1235, 1712.1359, 501.8598, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 622.1235, 1712.1359, 502.8497, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 622.1235, 1712.1359, 503.8197, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 630.2036, 1712.1359, 503.8197, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 630.2036, 1712.1359, 502.8197, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 630.2036, 1712.1359, 501.8297, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 630.2036, 1712.1359, 500.8597, 0.0000, 90.0000, 90.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(1347, 620.6205, 1712.5432, 500.9993, 0.0000, 0.0000, 0.0000); //CJ_WASTEBIN
    tmpobjid =  CreateObject(18762, 630.2033, 1709.1473, 502.0698, 0.0000, 0.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 629.2235, 1709.1473, 502.0698, 0.0000, 0.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 628.2235, 1709.1473, 502.0698, 0.0000, 0.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 622.1234, 1709.1473, 502.0698, 0.0000, 0.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 623.1233, 1709.1473, 502.0698, 0.0000, 0.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 624.1134, 1709.1473, 502.0698, 0.0000, 0.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(18762, 626.1423, 1709.1463, 504.0697, 0.0000, 90.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(19464, 628.1282, 1731.3970, 500.4255, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19464, 625.1487, 1731.3974, 500.4244, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19464, 625.1487, 1711.6470, 500.4244, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19464, 627.3182, 1711.6464, 500.4238, 0.0000, 90.0000, 0.0000); //wall104
    SetObjectMaterial(tmpobjid, 0, 14530, "estate2", "man_parquet", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18766, 626.1232, 1711.1116, 504.1429, 90.0000, 90.0000, 90.0000); //Concrete10mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 3355, "cxref_savhus", "des_brick1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18766, 626.1226, 1713.2714, 504.1424, 90.0000, 90.0000, 90.0000); //Concrete10mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 3355, "cxref_savhus", "des_brick1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(1437, 628.6336, 1700.1871, 495.5811, 0.0000, 0.0000, 0.0000); //DYN_LADDER_2
    tmpobjid =  CreateObject(18766, 631.6427, 1705.4997, 500.0321, 90.0000, 90.0000, 0.0000); //Concrete10mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 3355, "cxref_savhus", "des_brick1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19789, 629.1984, 1708.3314, 500.5129, 0.0000, 0.0000, 0.0000); //Cube1mx1m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(19789, 628.2285, 1708.3314, 500.5129, 0.0000, 0.0000, 0.0000); //Cube1mx1m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFF335F3F);
    tmpobjid =  CreateObject(1428, 629.3101, 1708.4044, 503.0358, 8.2999, 0.0000, 0.0000); //DYN_LADDER
    tmpobjid =  CreateObject(19789, 626.5082, 1714.2307, 505.5429, 0.0000, 0.0000, -167.5000); //Cube1mx1m
    SetObjectMaterial(tmpobjid, 0, 1736, "cj_ammo", "CJ_SLATEDWOOD2", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19789, 627.0746, 1714.3560, 504.5929, 0.0000, 0.0000, 167.3000); //Cube1mx1m
    SetObjectMaterial(tmpobjid, 0, 1736, "cj_ammo", "CJ_SLATEDWOOD2", 0xFFFFFFFF);
    tmpobjid =  CreateObject(19789, 625.9557, 1714.2142, 504.5929, 0.0000, 0.0000, 117.4000); //Cube1mx1m
    SetObjectMaterial(tmpobjid, 0, 1736, "cj_ammo", "CJ_SLATEDWOOD2", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18766, 631.6629, 1713.6689, 500.0304, 90.0000, 90.0000, 0.0000); //Concrete10mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 3355, "cxref_savhus", "des_brick1", 0xFFFFFFFF);
    tmpobjid =  CreateObject(18762, 622.1231, 1733.8671, 502.0698, 0.0000, 0.0000, 0.0000); //Concrete1mx1mx5m
    SetObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "ws_palebrickwall1", 0xFFFFFFFF);

    //lazer
    tmpobjid = CreateObject(2932, 1373.822387, -810.377502, 76.458999, 90.000000, 180.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1373.822387, -810.377502, 83.608802, 90.000000, 180.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1378.973999, -810.377990, 74.469062, 180.000000, 270.000000, 270.000000);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1386.257202, -810.390502, 76.759445, 109.899993, 89.599998, 90.099998);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1388.690185, -810.387451, 83.472991, 109.899993, 89.599998, 90.099998);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1394.060546, -810.402221, 83.492317, 69.899993, 89.599998, 90.100006);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1396.503051, -810.398559, 76.815277, 69.899993, 89.599998, 90.100006);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1391.420043, -810.367919, 78.969047, 180.000000, 270.000000, 270.000000);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1404.133911, -810.377990, 74.469062, 180.000000, 270.000000, 270.000000);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1411.273315, -810.377990, 74.469062, 180.000000, 270.000000, 270.000000);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1404.156982, -810.357910, 77.374412, 134.899993, 89.599998, 90.099998);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1409.203002, -810.348693, 82.439155, 134.899993, 89.599998, 90.099998);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1409.282714, -810.358154, 85.408943, 180.000000, 270.000000, 270.000000);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1402.129516, -810.358154, 85.408943, 180.000000, 270.000000, 270.000000);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1418.154663, -810.377502, 76.458999, 90.000000, 180.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1418.154663, -810.377502, 83.558876, 90.000000, 180.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1423.292358, -810.377990, 74.469062, 180.000000, 270.000000, 270.000000);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1423.292358, -810.377990, 80.158866, 180.000000, 270.000000, 270.000000);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1423.292358, -810.377990, 85.578857, 180.000000, 270.000000, 270.000000);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1430.015258, -810.377502, 76.439186, 90.000000, 180.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1430.015258, -810.377502, 83.549026, 90.000000, 180.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1435.142822, -810.377990, 85.578857, 180.000000, 270.000000, 270.000000);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1437.147705, -810.367492, 83.549026, 90.000000, 180.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1435.142822, -810.388000, 80.499053, 180.000000, 270.000000, 270.000000);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1432.300415, -810.357971, 78.925209, 39.899993, 89.599998, 90.100006);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");
    tmpobjid = CreateObject(2932, 1436.214111, -810.422851, 75.653228, 39.899993, 89.599998, 90.100006);
    SetObjectMaterial(tmpobjid, 0, 16640, "a51", "sl_metalwalk");
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "sl_metalwalk");

    //gaming
    tmpobjid = CreateObject(2932, 1394.166748, -825.435913, 64.683387, -90.000000, 0.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1394.175659, -825.435913, 71.833221, -90.000000, 0.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1399.286499, -825.435913, 73.823226, 180.000000, 90.000000, 450.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1399.286499, -825.435913, 62.643280, 180.000000, 90.000000, 450.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1401.326416, -825.445922, 64.683387, -90.000000, 0.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(3062, 1398.893310, -824.001892, 68.245384, 0.000000, 90.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(3062, 1398.893310, -826.862060, 68.245384, 0.000000, 90.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(3062, 1400.613891, -825.501953, 68.245384, 90.000000, 180.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(3062, 1399.054443, -825.501953, 68.245384, 90.000000, 180.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(3062, 1399.054443, -825.501953, 66.725387, 90.000000, 180.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(3062, 1400.615600, -825.501953, 66.725387, 90.000000, 180.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(3062, 1397.524414, -825.391845, 68.245384, 180.000000, 270.000000, 90.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1406.164306, -825.445922, 64.504882, -70.000000, 90.000000, 90.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1408.616455, -825.445922, 71.242378, -70.000000, 90.000000, 90.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1413.782836, -825.465942, 71.259742, -110.000000, 90.000000, 90.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1416.228027, -825.465942, 64.541038, -110.000000, 90.000000, 90.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1411.096801, -825.435913, 66.823249, 180.000000, 90.000000, 450.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1422.196533, -825.435913, 71.833221, -90.000000, 0.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1422.196533, -825.435913, 64.683410, -90.000000, 0.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1424.633666, -825.325805, 71.634407, -125.000000, 90.000000, 90.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1431.129760, -825.325805, 71.628738, -55.000000, 90.000000, 90.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1461.433349, -825.435913, 64.683334, -90.000000, 0.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1433.557617, -825.435913, 71.833221, -90.000000, 0.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1433.557617, -825.435913, 64.683334, -90.000000, 0.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1440.509887, -825.435913, 64.683334, -90.000000, 0.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1440.509887, -825.425903, 68.253219, -90.000000, 0.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1446.841674, -825.435913, 64.683334, -90.000000, 0.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1446.841674, -825.435913, 71.833251, -90.000000, 0.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1449.273315, -825.405883, 71.644363, -55.000000, 270.000000, 270.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1453.375244, -825.405883, 65.787567, -55.000000, 270.000000, 270.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1455.802368, -825.435913, 72.683258, -90.000000, 0.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1455.802368, -825.435913, 65.543273, -90.000000, 0.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1461.433349, -825.435913, 71.833297, -90.000000, 0.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1455.802368, -825.435913, 72.683258, -90.000000, 0.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1466.556884, -825.435913, 62.643280, 180.000000, 90.000000, 450.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1468.585083, -825.445922, 64.683334, -90.000000, 0.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(3062, 1465.926757, -826.852233, 68.253921, 0.000000, 90.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(3062, 1465.926757, -823.992553, 68.253921, 0.000000, 90.000000, 0.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(3062, 1466.096923, -825.492553, 66.733879, 90.000000, 90.000000, 90.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(3062, 1467.656127, -825.492553, 66.733879, 90.000000, 90.000000, 90.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(3062, 1467.656127, -825.492553, 68.243904, 90.000000, 90.000000, 90.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(3062, 1466.096191, -825.492553, 68.243904, 90.000000, 90.000000, 90.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(3062, 1464.586303, -825.492553, 66.693901, 180.000000, 90.000000, 90.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
    tmpobjid = CreateObject(2932, 1466.556884, -825.435913, 73.843215, 180.000000, 90.000000, 450.000000);
    SetObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe");
    SetObjectMaterial(tmpobjid, 1, 9514, "711_sfw", "mono1_sfe");
	return 1;
}

GetLastGangID()
{
	for(new i = 0; i < MAX_GANGS; i++)
	{
		if(isequal(ganginfo[i][gname], "-1")) return i;
	}
	print("[ LGGW ] There's a problem in `GetLastGangID`");
	return -1;
}

IsValidGang(g_id)
{
	if(isequal(ganginfo[g_id][gname], "-1")) return 0;
	return 1;
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
	ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), userinfo[playerid][vpjob]);
	AddVehicleComponent(GetPlayerVehicleID(playerid), userinfo[playerid][vwheel]);
	if(userinfo[playerid][vhydra] == 1) AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);
	if(userinfo[playerid][vnitro] != -1) AddVehicleComponent(GetPlayerVehicleID(playerid), userinfo[playerid][vnitro]);
	ChangeVehicleColor(GetPlayerVehicleID(playerid), userinfo[playerid][vcolor_1], userinfo[playerid][vcolor_2]);
	if(userinfo[playerid][vneon_1] == 1)
	{
		vehneon[priveh[playerid]][0] = CreateObject(18651,0,0,0,0,0,0); 
		vehneon[priveh[playerid]][1] = CreateObject(18651,0,0,0,0,0,0);
		AttachObjectToVehicle(vehneon[priveh[playerid]][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		AttachObjectToVehicle(vehneon[priveh[playerid]][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	}
	if(userinfo[playerid][vneon_2] == 1)
	{ 
		vehneon[priveh[playerid]][2] = CreateObject(18646,0,0,0,0,0,0);
		AttachObjectToVehicle(vehneon[priveh[playerid]][2], GetPlayerVehicleID(playerid), 0.0, -0.35, 0.90, 0.0, 0.0, 0.0);
	} 
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
	vehowner[priveh[playerid]] = INVALID_PLAYER_ID;
	vehowned[priveh[playerid]] = 0;
	DestroyVehicle(priveh[playerid]);
	priveh[playerid] = INVALID_VEHICLE_ID;
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
		if(userinfo[j][plevel] >= level)
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
		if(userinfo[j][plevel] > 0)
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

stock HexToInt(string[])
{
	if (string[0] == 0)
	{
		return 0;
	}
	new j, cur = 1, res;
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
    last_key[playerid] = KEY_DEFAULT;
    intuneshop[playerid] = 0;
    cur_kills[playerid] = 0;
    class_in[playerid] = -1;
    class_real[playerid] = -1;
	userinfo[playerid][onduty] = 0;
	justconnected[playerid] = 1;
	killinginprogress[playerid] = 0;
	inlms[playerid] = 0;
	instunt[playerid] = 0;
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
	class_gselected[playerid] = 0;
	class_saved[playerid] = -1;
	logged[playerid] = 0;
	pDrunkLevelLast[playerid] = 0;
	pFPS[playerid] = 0;
	rampage[playerid] = 0;
	adm_id[playerid] = -1;
	time_edrink[playerid] = -1;
	time_band[playerid] = -1;
	spec[playerid] = 0;
	specid[playerid] = -1;
	format(lastmsg[playerid], 128, "%s", "");
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
    new val, str[128];
    mysql_format(Database, str, sizeof(str), "SELECT * FROM `Users` WHERE `Name` = '%e' LIMIT 1", name);
    new Cache:r = mysql_query(Database, str);
    cache_get_value_name_int(0, "User_ID", val);
    cache_delete(r);

	mysql_format(Database, str, sizeof(str), "SELECT * FROM `User_Status` WHERE `User_ID` = '%d' LIMIT 1", val);
	r = mysql_query(Database, str);
    cache_get_value_name_int(0, "Banned", val);
    cache_delete(r);
	return val;
}

new turfs[7];

new ClassAnimations[][] = //only 'DANCING' library anims
{
	{"dance_loop"},
	{"DAN_Down_A"},
	{"DAN_Left_A"},
	{"DAN_Loop_A"},
	{"DAN_Right_A"},
	{"DAN_Up_A"},
	{"dnce_M_a"},
	{"dnce_M_b"},
	{"dnce_M_c"},
	{"dnce_M_d"},
	{"dnce_M_e"}
};

//Publics
public OnGameModeInit()
{
	AntiDeAMX();

    #if SERVER_HOST_PROTECTION == true
	new ip[16];
	GetServerVarAsString("bind", ip, sizeof (ip));
	if (!ip[0] || strcmp(ip, HOSTED_IP)) SendRconCommand("exit");
    #endif

	new MySQLOpt: option_id = mysql_init_options(); 
	mysql_set_option(option_id, AUTO_RECONNECT, true); 

	Database = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DATABASE, option_id); 

	if(Database == MYSQL_INVALID_HANDLE || mysql_errno(Database) != 0) 
	{
		print("[ SERVER ] MySQL - > I couldn't connect to the MySQL server, closing..."); 
		SendRconCommand("exit"); 
		return 1; 
	}

	print("[ SERVER ] I connected to MySQL server successfully!");

	for(new i = 0; i < sizeof(zoneinfo); i++) zoneinfo[i][ZoneAttacker] = -1;

	SetWeather(0);
	SetWorldTime(6);

	SetGameModeText(GAMEMODE_TEXT);

	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	UsePlayerPedAnims();

	CreateTextDraws();
	CreateVehicles();
	CreateMappings();
    Tune_CreateMenus();

    new count;
    for(new i = 0; i < MAX_VEHICLES; i++) if(IsValidVehicle(i)) count ++;
    printf("%i", count);

	AddPlayerClass(0,0,0,0,0,0,0,0,0,0,0);
	AddPlayerClass(0,0,0,0,0,0,0,0,0,0,0);
	AddPlayerClass(0,0,0,0,0,0,0,0,0,0,0); 
	AddPlayerClass(0,0,0,0,0,0,0,0,0,0,0);
	AddPlayerClass(0,0,0,0,0,0,0,0,0,0,0); 
	AddPlayerClass(0,0,0,0,0,0,0,0,0,0,0); 
	AddPlayerClass(0,0,0,0,0,0,0,0,0,0,0); 

	AddPlayerClass(0,2495.9734,-1705.2390,1014.7422,0,0,0,0,0,0,0);
	AddPlayerClass(0,2495.9734,-1705.2390,1014.7422,0,0,0,0,0,0,0);
	AddPlayerClass(0,2495.9734,-1705.2390,1014.7422,0,0,0,0,0,0,0);
	AddPlayerClass(0,2495.9734,-1705.2390,1014.7422,0,0,0,0,0,0,0);
	AddPlayerClass(0,2495.9734,-1705.2390,1014.7422,0,0,0,0,0,0,0);
	AddPlayerClass(0,2495.9734,-1705.2390,1014.7422,0,0,0,0,0,0,0);
	AddPlayerClass(0,2495.9734,-1705.2390,1014.7422,0,0,0,0,0,0,0);

	AddPlayerClass(0,2324.3496,-1135.6730,1051.3047,0,0,0,0,0,0,0);
	AddPlayerClass(0,2324.3496,-1135.6730,1051.3047,0,0,0,0,0,0,0);
	AddPlayerClass(0,2324.3496,-1135.6730,1051.3047,0,0,0,0,0,0,0);
	AddPlayerClass(0,2324.3496,-1135.6730,1051.3047,0,0,0,0,0,0,0);

	AddPlayerClass(0,322.2002,310.1391,999.1484,0,0,0,0,0,0,0);
	AddPlayerClass(0,322.2002,310.1391,999.1484,0,0,0,0,0,0,0);
	AddPlayerClass(0,322.2002,310.1391,999.1484,0,0,0,0,0,0,0);
	AddPlayerClass(0,322.2002,310.1391,999.1484,0,0,0,0,0,0,0);
	AddPlayerClass(0,322.2002,310.1391,999.1484,0,0,0,0,0,0,0);
	AddPlayerClass(0,322.2002,310.1391,999.1484,0,0,0,0,0,0,0);

	AddPlayerClass(0,323.7699,1125.5558,1083.8828,0,0,0,0,0,0,0);
	AddPlayerClass(0,323.7699,1125.5558,1083.8828,0,0,0,0,0,0,0);
	AddPlayerClass(0,323.7699,1125.5558,1083.8828,0,0,0,0,0,0,0);
	AddPlayerClass(0,323.7699,1125.5558,1083.8828,0,0,0,0,0,0,0);

	AddPlayerClass(0,344.9517,-1179.2848,1027.9766,0,0,0,0,0,0,0);
	AddPlayerClass(0,344.9517,-1179.2848,1027.9766,0,0,0,0,0,0,0);
	AddPlayerClass(0,344.9517,-1179.2848,1027.9766,0,0,0,0,0,0,0);
	AddPlayerClass(0,344.9517,-1179.2848,1027.9766,0,0,0,0,0,0,0);

	AddPlayerClass(0,2449.2959,-1703.5011,1013.5078,0,0,0,0,0,0,0);
	AddPlayerClass(0,2449.2959,-1703.5011,1013.5078,0,0,0,0,0,0,0);
	AddPlayerClass(0,2449.2959,-1703.5011,1013.5078,0,0,0,0,0,0,0);
	AddPlayerClass(0,2449.2959,-1703.5011,1013.5078,0,0,0,0,0,0,0);
	AddPlayerClass(0,2449.2959,-1703.5011,1013.5078,0,0,0,0,0,0,0);

	AddPlayerClass(0,232.7027,1202.4850,1084.4160,0,0,0,0,0,0,0); 
	AddPlayerClass(0,232.7027,1202.4850,1084.4160,0,0,0,0,0,0,0);
	AddPlayerClass(0,232.7027,1202.4850,1084.4160,0,0,0,0,0,0,0);
	AddPlayerClass(0,232.7027,1202.4850,1084.4160,0,0,0,0,0,0,0);
	AddPlayerClass(0,232.7027,1202.4850,1084.4160,0,0,0,0,0,0,0); 
	AddPlayerClass(0,232.7027,1202.4850,1084.4160,0,0,0,0,0,0,0);
	AddPlayerClass(0,232.7027,1202.4850,1084.4160,0,0,0,0,0,0,0);
	AddPlayerClass(0,232.7027,1202.4850,1084.4160,0,0,0,0,0,0,0);
	AddPlayerClass(0,232.7027,1202.4850,1084.4160,0,0,0,0,0,0,0);
	AddPlayerClass(0,232.7027,1202.4850,1084.4160,0,0,0,0,0,0,0);
	AddPlayerClass(0,232.7027,1202.4850,1084.4160,0,0,0,0,0,0,0);
	AddPlayerClass(0,232.7027,1202.4850,1084.4160,0,0,0,0,0,0,0);
	AddPlayerClass(0,232.7027,1202.4850,1084.4160,0,0,0,0,0,0,0);
	AddPlayerClass(0,232.7027,1202.4850,1084.4160,0,0,0,0,0,0,0);
	AddPlayerClass(0,232.7027,1202.4850,1084.4160,0,0,0,0,0,0,0);
	AddPlayerClass(0,232.7027,1202.4850,1084.4160,0,0,0,0,0,0,0);
	AddPlayerClass(0,232.7027,1202.4850,1084.4160,0,0,0,0,0,0,0);
	AddPlayerClass(0,232.7027,1202.4850,1084.4160,0,0,0,0,0,0,0);
    AddPlayerClass(0,232.7027,1202.4850,1084.4160,0,0,0,0,0,0,0);

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
	PVEH[0] = CreateDynamicCP(2128.5830,-1140.2947,25.2329, 2);//pveh shop 
	PVEH[1] = CreateDynamicCP(1518.2750,-1465.3423,9.5000, 2);//pveh mod shop

	for(new i = 0; i < sizeof(shopinfo); i++)
	{
		Create3DTextLabel(shopinfo[i][label], 0xD9BC17FF, shopinfo[i][entercp][0], shopinfo[i][entercp][1], shopinfo[i][entercp][2], 50.0, 0, 0);
		SENTERCP[i] = CreateDynamicCP(shopinfo[i][entercp][0], shopinfo[i][entercp][1], shopinfo[i][entercp][2], 1);
		SEXITCP[i] = CreateDynamicCP(shopinfo[i][exitcp][0], shopinfo[i][exitcp][1], shopinfo[i][exitcp][2], 1, (i + 1));
		SBUYCP[i] = CreateDynamicCP(shopinfo[i][buycp][0], shopinfo[i][buycp][1], shopinfo[i][buycp][2], 1, (i + 1));
		CreateActor(shopinfo[i][askin], shopinfo[i][actorpos][0], shopinfo[i][actorpos][1], shopinfo[i][actorpos][2], shopinfo[i][actorpos][3]);
		SetActorVirtualWorld(i, (i + 1));
	}

	for(new a = 0, j = GetActorPoolSize(); a <= j; a++)
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

	//=================================== Data verification

	new str[128];
	new Cache:r = mysql_query(Database, "SELECT * FROM `Gangs`");
	new rows;
    cache_get_row_count(rows);
    cache_delete(r);
    printf("---%i", rows);
	if(rows < MAX_GANGS)
	{
		print("came here 1");
		for(new i = 0; i < MAX_GANGS; i ++)
		{
			print("came here 2");
			if(i > (rows - 1))
			{
				print("came here 3");
				if(i < 7)
				{
					print("came here 4");
					mysql_format(Database, str, sizeof(str), "INSERT INTO `Gangs` (`Name`, `Tag`, `Color`) VALUES('%e', '%e', '%d')", GetTeamName(i), GetTeamTag(i), GetTeamColor(i));
					mysql_query(Database, str, false);
				}
				else{
					mysql_query(Database, "INSERT INTO `Gangs` (`Name`, `Tag`, `Color`) VALUES('-1', '-1', '-1')", false);
					print("came here 5");
				}
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
			if(i > (rows - 1))
			{
				Rand = random(sizeof(TeamRandoms)); 
                turfs[TeamRandoms[Rand]] ++;
				mysql_format(Database, str, sizeof(str), "INSERT INTO `Zones` (`Zone_owned_team_ID`) VALUES('%d')", TeamRandoms[Rand]);
				mysql_query(Database, str, false);
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
                mysql_query(Database, "INSERT INTO `Houses` (`House_owned`) VALUES('0')", false);
            }
		}
	}

	//================================================= Loading from database

	for(new i = 0; i < MAX_GANGS; i ++) LoadGangData(i);
	for(new i = 0; i < sizeof(houseinfo); i++) LoadHouseData(i);
	for(new i = 0; i < sizeof(zoneinfo); i ++) LoadZoneData(i);

	for(new c = 0; c < sizeof(houseinfo); c++)
	{
		GENTERCP[c] = CreateDynamicCP(houseinfo[c][entercp][0], houseinfo[c][entercp][1], houseinfo[c][entercp][2], 1);
		GEXITCP[c] = CreateDynamicCP(houseinfo[c][exitcp][0], houseinfo[c][exitcp][1], houseinfo[c][exitcp][2], 1);
		if(houseinfo[c][howned] == 0)
		{
			hlabel[c] = Create3DTextLabel("{FF6347}[Head Qauters]\n* Unowned", -1, houseinfo[c][entercp][0], houseinfo[c][entercp][1], houseinfo[c][entercp][2], 50.0, 0, 0);
		}
		else
		{
			format(str, sizeof(str), "[Head Qauters]\n%s", ReplaceUwithS(ganginfo[houseinfo[c][hteamid]][gname]));
			hlabel[c] = Create3DTextLabel(str, ganginfo[houseinfo[c][hteamid]][gcolor], houseinfo[c][entercp][0], houseinfo[c][entercp][1], houseinfo[c][entercp][2], 50.0, 0, 0);
		}
	}

	for(new j = 0; j < sizeof(zoneinfo); j++)
	{
		ZONEID[j] = GangZoneCreate(zoneinfo[j][zminx], zoneinfo[j][zminy], zoneinfo[j][zmaxx], zoneinfo[j][zmaxy]);
		DZONEID[j] = CreateDynamicRectangle(zoneinfo[j][zminx], zoneinfo[j][zminy], zoneinfo[j][zmaxx], zoneinfo[j][zmaxy]);
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

	for(new i = 0; i < sizeof(shopinfo); i++)
	{
		CreateDynamicMapIcon(shopinfo[i][entercp][0], shopinfo[i][entercp][1], shopinfo[i][entercp][2], shopinfo[i][mapico], 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);  
	}

	for(new i = 0; i < sizeof(houseinfo); i++)
	{
		if(houseinfo[i][howned] == 1) houseinfo[i][icon_id] = CreateDynamicMapIcon(houseinfo[i][entercp][0], houseinfo[i][entercp][1], houseinfo[i][entercp][2], 32, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
		else houseinfo[i][icon_id] = CreateDynamicMapIcon(houseinfo[i][entercp][0], houseinfo[i][entercp][1], houseinfo[i][entercp][2], 31, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
	}
    
	SetTimer("RobTimer", 500, true);
	SetTimer("TurfTimer", 1000, true);
	SetTimer("SecTimer_1", 1000, true);
	SetTimer("TurfMoney", TIME_FOR_TURF_PAYDAY * 60 * 1000, true);
	SetTimer("SecTimer_5", 5000, true);
	SetTimer("MinTimer_5", 1000 * 60 * 5, true); 

	return 1;
}

public OnGameModeExit() 
{
	mysql_close(Database); 

	foreach(new j : Player)
	{
		PlayerTextDrawDestroy(j, fplabel_1[j]);
		PlayerTextDrawDestroy(j, wastedtd_1[j]);
		PlayerTextDrawDestroy(j, vehtd_1[j]);
		PlayerTextDrawDestroy(j, turfcashtd[j]);
		PlayerTextDrawDestroy(j, moneytd_1[j]);
		PlayerTextDrawDestroy(j, DM_1[j]); 

		for(new i = 0; i < 5; i++) PlayerTextDrawDestroy(j, gangtd_1[j][i]);
		for(new i = 0; i < 2; i++) PlayerTextDrawDestroy(j, zonetd_1[j][i]);
		for(new i = 0; i < 2; i++) PlayerTextDrawDestroy(j, takeovertd_1[j][i]);
		for(new i = 0; i < 6; i++) PlayerTextDrawDestroy(j, statstd_1[j][i]);

		DestroyPlayerProgressBar(j, rbar[j]);
	}

	TextDrawDestroy(statstd);
	TextDrawDestroy(gangtd);
	TextDrawDestroy(zonetd); 

	for(new i = 0; i < 12; i++) TextDrawDestroy(connecttd[i]);
	for(new i = 0; i < 4; i++) TextDrawDestroy(LGGW[i]);
	for(new i = 0; i < 4; i++) TextDrawDestroy(takeovertd[i]);
	for(new i = 0; i < 2; i++) TextDrawDestroy(DM__[i]);
	for(new i = 0; i < 5; i++) TextDrawDestroy(wastedtd[i]);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    printf("id - %i | came here2", playerid);

    SetPlayerWorldBounds(playerid,20000.0000,-20000.0000,20000.0000,-20000.0000); 

    new upval;
    if(classid == 0 && class_real[playerid] == 55)
    {
        upval = 1;
        class_real[playerid] = 0;
    }
    else if(classid == 55 && class_real[playerid] == 0)
    {
        upval = 0;
        class_real[playerid] = 55;
    }
    else if(classid > class_real[playerid])
    {
        upval = 1;
        class_real[playerid] ++;
    }
    else if(classid < class_real[playerid])
    {
        upval = 0;
        class_real[playerid] --;
    }

	if(logged[playerid] == 0) return 0;
	if(tickcount() - class_tick[playerid] < 500) return 0;
	class_tick[playerid] = tickcount();

    if(upval)
    {
        class_in[playerid]++;
        if(class_gselected[playerid])
        {
            switch(class_saved[playerid])
            {
                case TEAM_GROVE: if(class_in[playerid] == 14) class_in[playerid] = 7;
                case TEAM_AZTECA: if(class_in[playerid] == 18) class_in[playerid] = 14;    
                case TEAM_JUSTICE: if(class_in[playerid] == 24) class_in[playerid] = 18;    
                case TEAM_BALLAS: if(class_in[playerid] == 28) class_in[playerid] = 24;    
                case TEAM_VAGOS: if(class_in[playerid] == 32) class_in[playerid] = 28;    
                case TEAM_MAFIA: if(class_in[playerid] == 37) class_in[playerid] = 32;    
                case TEAM_VIP: if(class_in[playerid] == 56) class_in[playerid] = 37;    
            }
        }
        else if(class_in[playerid] == 7) class_in[playerid] = 0;
    }
    else 
    {
        class_in[playerid] --;
        if(class_gselected[playerid])
        {
            switch(class_saved[playerid])
            {
                case TEAM_GROVE: if(class_in[playerid] == 6) class_in[playerid] = 13;
                case TEAM_AZTECA: if(class_in[playerid] == 13) class_in[playerid] = 17;    
                case TEAM_JUSTICE: if(class_in[playerid] == 17) class_in[playerid] = 23;    
                case TEAM_BALLAS: if(class_in[playerid] == 23) class_in[playerid] = 27;    
                case TEAM_VAGOS: if(class_in[playerid] == 27) class_in[playerid] = 31;    
                case TEAM_MAFIA: if(class_in[playerid] == 31) class_in[playerid] = 36;    
                case TEAM_VIP: if(class_in[playerid] == 36) class_in[playerid] = 55;    
            }
        }
        else if(class_in[playerid] == -1) class_in[playerid] = 6;
    }

	SetPlayerColor(playerid, 0xafafaf88);
	SetPlayerVirtualWorld(playerid, playerid + 1);
	SetPlayerInterior(playerid, 0);
	
	PlayerTextDrawHide(playerid, wastedtd_1[playerid]);
	TextDrawHideForPlayer(playerid, wastedtd[0]);
	TextDrawHideForPlayer(playerid, wastedtd[1]);
	TextDrawHideForPlayer(playerid, wastedtd[2]);
	TextDrawHideForPlayer(playerid, wastedtd[3]);
	TextDrawHideForPlayer(playerid, wastedtd[4]);
	
	if(inminigame[playerid] == 1) return SpawnPlayer(playerid);
	if(userinfo[playerid][ingang] == 1) return SpawnPlayer(playerid);
	if(class_selected[playerid]) class_in[playerid] = 3;
	PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
	class_selected[playerid] = 0;

	new rand = random(sizeof(ClassAnimations));
	if(class_in[playerid] >= 0 && class_in[playerid] <= 6)
    {
        userinfo[playerid][gid] = -1;
        userinfo[playerid][gskin] = -1;

        TextDrawShowForPlayer(playerid, gangtd);
        for(new i = 0; i < 5; i ++) PlayerTextDrawShow(playerid, gangtd_1[playerid][i]);
        
        new str[50];
        format(str, sizeof(str), "~y~Score:_~w~%d", ganginfo[class_in[playerid]][gscore]);
        PlayerTextDrawSetString(playerid, gangtd_1[playerid][1], str);
        
        new count;
        foreach(new i : Player)
        {
            if(userinfo[i][gid] == class_in[playerid])
            {
                count++;
            }
        }
        
        format(str, sizeof(str), "~y~Members_Online:_~w~%d", count);
        PlayerTextDrawSetString(playerid, gangtd_1[playerid][2], str);
        format(str, sizeof(str), "~y~Controlled_Turfs:_~w~%d", ganginfo[class_in[playerid]][gturfs]);
        PlayerTextDrawSetString(playerid, gangtd_1[playerid][3], str);
        
        switch(class_in[playerid])
        {
            case TEAM_GROVE: SetPlayerPos(playerid, 2509.4551,-1695.8652,13.5238);
            case TEAM_AZTECA: SetPlayerPos(playerid, 1755.6006,-1943.0302,13.5718);
            case TEAM_JUSTICE: SetPlayerPos(playerid, 1552.0704,-1637.4517,13.5559);
            case TEAM_BALLAS: SetPlayerPos(playerid, 1940.5020,-1104.8237,26.4531);
            case TEAM_VAGOS: SetPlayerPos(playerid, 2275.3394,-1097.8798,37.9766);
            case TEAM_MAFIA: SetPlayerPos(playerid, 2176.4033,-2229.8257,13.4371);
            case TEAM_VIP: SetPlayerPos(playerid, 1016.6958,-1115.9430,23.8978);
        } 
        class_saved[playerid] = class_in[playerid];
    }

    switch(class_in[playerid])
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
            ClearAnimations(playerid);

            if(class_in[playerid] == 7){ 
            	userinfo[playerid][gskin] = 0; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 8){ 
            	userinfo[playerid][gskin] = 105; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            } 
            if(class_in[playerid] == 9){ 
            	userinfo[playerid][gskin] = 106; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 10){ 
            	userinfo[playerid][gskin] = 107; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 11){ 
            	userinfo[playerid][gskin] = 270; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 12){ 
            	userinfo[playerid][gskin] = 269; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 13){ 
            	userinfo[playerid][gskin] = 271; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }   
            
            SetPlayerPos(playerid, 2495.3616,-1687.8169,13.5163);
            SetPlayerFacingAngle(playerid, 0);
            ApplyAnimation(playerid,"DANCING", ClassAnimations[rand],4.0,1,0,0,0,-1);
        }
        case 14..17: //Azteca
        {
            ClearAnimations(playerid);

            if(class_in[playerid] == 14){ 
            	userinfo[playerid][gskin] = 114; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 15){ 
            	userinfo[playerid][gskin] = 115; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 16){ 
            	userinfo[playerid][gskin] = 116; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 17){ 
            	userinfo[playerid][gskin] = 41; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            
            SetPlayerPos(playerid, 1755.1818,-1911.9816,13.5680);
            SetPlayerFacingAngle(playerid, 270);
            ApplyAnimation(playerid,"DANCING", ClassAnimations[rand],4.0,1,0,0,0,-1);
        }
        case 18..23: //Justice
        {
            ClearAnimations(playerid);

            if(class_in[playerid] == 18){ 
            	userinfo[playerid][gskin] = 265; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 19){ 
            	userinfo[playerid][gskin] = 266; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 20){ 
            	userinfo[playerid][gskin] = 267; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 21){ 
            	userinfo[playerid][gskin] = 284; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 22){ 
            	userinfo[playerid][gskin] = 286; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 23){ 
            	userinfo[playerid][gskin] = 285; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            
            SetPlayerPos(playerid, 1552.3999,-1675.7057,16.1953);
            SetPlayerFacingAngle(playerid, 90);
            ApplyAnimation(playerid,"DANCING", ClassAnimations[rand],4.0,1,0,0,0,-1);
        }
        case 24..27: //Ballas
        {
            ClearAnimations(playerid);

            if(class_in[playerid] == 24){ 
            	userinfo[playerid][gskin] = 102; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 25){ 
            	userinfo[playerid][gskin] = 103; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 26){ 
            	userinfo[playerid][gskin] = 104; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 27){ 
            	userinfo[playerid][gskin] = 85; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            
            SetPlayerPos(playerid, 1939.3193,-1116.9648,26.5312);
            SetPlayerFacingAngle(playerid, 180);
            ApplyAnimation(playerid,"DANCING", ClassAnimations[rand],4.0,1,0,0,0,-1);
        }
        case 28..31: //Vagos
        {
            ClearAnimations(playerid);

            if(class_in[playerid] == 28){ 
            	userinfo[playerid][gskin] = 108; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 29){ 
            	userinfo[playerid][gskin] = 109; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 30){ 
            	userinfo[playerid][gskin] = 110; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 31){ 
            	userinfo[playerid][gskin] = 63; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            
            SetPlayerPos(playerid, 2287.5903,-1107.4723,37.9766);
            SetPlayerFacingAngle(playerid, 180);
            ApplyAnimation(playerid,"DANCING", ClassAnimations[rand],4.0,1,0,0,0,-1);
        }
        case 32..36: //Russian
        {
            ClearAnimations(playerid);

            if(class_in[playerid] == 32){ 
            	userinfo[playerid][gskin] = 55; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 33){ 
            	userinfo[playerid][gskin] = 117; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 34){ 
            	userinfo[playerid][gskin] = 163; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 35){ 
            	userinfo[playerid][gskin] = 164; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 36){ 
            	userinfo[playerid][gskin] = 165; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            
            SetPlayerPos(playerid, 2180.0186,-2256.8735,14.7734);
            SetPlayerFacingAngle(playerid, 240);
            ApplyAnimation(playerid,"DANCING", ClassAnimations[rand],4.0,1,0,0,0,-1);
        }
        case 37..54: //VIP
        {
            ClearAnimations(playerid);

            if(class_in[playerid] == 37){ 
            	userinfo[playerid][gskin] = 23; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 38){ 
            	userinfo[playerid][gskin] = 24; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 39){ 
            	userinfo[playerid][gskin] = 29; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 40){ 
            	userinfo[playerid][gskin] = 34; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }
            if(class_in[playerid] == 41){ 
            	userinfo[playerid][gskin] = 100; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }  
            if(class_in[playerid] == 42){ 
            	userinfo[playerid][gskin] = 122; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }  
            if(class_in[playerid] == 43){ 
            	userinfo[playerid][gskin] = 133; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }  
            if(class_in[playerid] == 44){ 
            	userinfo[playerid][gskin] = 169; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }  
            if(class_in[playerid] == 45){ 
            	userinfo[playerid][gskin] = 185; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }  
            if(class_in[playerid] == 46){ 
            	userinfo[playerid][gskin] = 188; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }  
            if(class_in[playerid] == 47){ 
            	userinfo[playerid][gskin] = 216; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }  
            if(class_in[playerid] == 48){ 
            	userinfo[playerid][gskin] = 219; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }  
            if(class_in[playerid] == 49){ 
            	userinfo[playerid][gskin] = 225; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }  
            if(class_in[playerid] == 50){ 
            	userinfo[playerid][gskin] = 250; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }  
            if(class_in[playerid] == 51){ 
            	userinfo[playerid][gskin] = 261; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }  
            if(class_in[playerid] == 52){ 
            	userinfo[playerid][gskin] = 306; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }  
            if(class_in[playerid] == 53){ 
            	userinfo[playerid][gskin] = 211; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }  
            if(class_in[playerid] == 54){ 
            	userinfo[playerid][gskin] = 223; 
            	SetPlayerSkin(playerid,  userinfo[playerid][gskin]); 
            }  
            
            SetPlayerPos(playerid, 1022.4600,-1123.6239,23.8702);
            SetPlayerFacingAngle(playerid, 180);
            ApplyAnimation(playerid,"DANCING", ClassAnimations[rand],4.0,1,0,0,0,-1);
        }   
    }
	return 1;
}

public OnPlayerRequestSpawn(playerid) 
{
	if(logged[playerid] == 0) return 0;
	if(class_gselected[playerid] == 0)
	{
		if(class_saved[playerid] == TEAM_VIP && userinfo[playerid][VIP] == 0)
		{
			GameTextForPlayer(playerid, "~r~ONLY FOR VIPs", 1000, 3);
			return 0;
		}

		class_gselected[playerid] = 1;
		TextDrawHideForPlayer(playerid, gangtd);
		for(new i = 0; i < 5; i++) PlayerTextDrawHide(playerid, gangtd_1[playerid][i]);
		new rand = random(sizeof(ClassAnimations));
    
		switch(class_saved[playerid])
		{
			case TEAM_GROVE:
			{	
				userinfo[playerid][gid] = TEAM_GROVE;
				userinfo[playerid][gskin] = 0;

				SetPlayerTeam(playerid, TEAM_GROVE);
				SetPlayerPos(playerid, 2495.3616,-1687.8169,13.5163);
				SetPlayerFacingAngle(playerid, 0);
                SetPlayerSkin(playerid, 0);
				
                InterpolateCameraPos(playerid, 2471.233398, -1662.675537, 29.131023, 2494.8152,-1675.8546,13.3359, 2000);
				InterpolateCameraLookAt(playerid, 2474.705810, -1665.924194, 27.585163,2495.3616,-1687.8169,13.516, 2000);
				
                ClearAnimations(playerid);
				ApplyAnimation(playerid,"DANCING", ClassAnimations[rand],4.0,1,0,0,0,-1);
                
                class_in[playerid] = 7;
				return 0;
			}
			case TEAM_AZTECA:
			{
				userinfo[playerid][gid] = TEAM_AZTECA;
				userinfo[playerid][gskin] = 114;
				
                SetPlayerTeam(playerid, TEAM_AZTECA);
				SetPlayerPos(playerid, 1755.1818,-1911.9816,13.5680);
				SetPlayerFacingAngle(playerid, 270);
                SetPlayerSkin(playerid, 114);
				
                InterpolateCameraPos(playerid, 1783.382568, -1904.509765, 31.318225, 1763.0292,-1912.2617,13.5701, 2000);
				InterpolateCameraLookAt(playerid, 1779.026489, -1905.638427, 29.138710,1755.1818,-1911.9816,13.5680, 2000);
				
                ClearAnimations(playerid);
				ApplyAnimation(playerid,"DANCING", ClassAnimations[rand],4.0,1,0,0,0,-1);
                
                class_in[playerid] = 14;
				return 0;
			}
			case TEAM_JUSTICE:
			{
				userinfo[playerid][gid] = TEAM_JUSTICE;
				userinfo[playerid][gskin] = 265;
				
                SetPlayerTeam(playerid, TEAM_JUSTICE);				
				SetPlayerPos(playerid, 1552.3999,-1675.7057,16.1953);
				SetPlayerFacingAngle(playerid, 90);
                SetPlayerSkin(playerid, 265);
				
                InterpolateCameraPos(playerid, 1497.753295, -1675.863769, 49.390430, 1546.2343,-1675.8071,13.5619, 2000);
				InterpolateCameraLookAt(playerid, 1502.374145, -1675.999267, 47.485393,1552.3999,-1675.7057,16.1953, 2000);
				
                ClearAnimations(playerid);
				ApplyAnimation(playerid,"DANCING", ClassAnimations[rand],4.0,1,0,0,0,-1);
                
                class_in[playerid] = 18;
				return 0;
			}
			case TEAM_BALLAS:
			{
				userinfo[playerid][gid] = TEAM_BALLAS;
				userinfo[playerid][gskin] = 102;
				
                SetPlayerTeam(playerid, TEAM_BALLAS);
				SetPlayerPos(playerid, 1939.3193,-1116.9648,26.5312);
				SetPlayerFacingAngle(playerid, 180);
                SetPlayerSkin(playerid, 102);
				
                InterpolateCameraPos(playerid, 1931.146118, -1140.666992, 42.193244, 1939.4532,-1121.6401,26.5256, 2000);
				InterpolateCameraLookAt(playerid, 1932.703369, -1136.448730, 40.006698,1939.3193,-1116.9648,26.5312, 2000);
				
                ClearAnimations(playerid);
				ApplyAnimation(playerid,"DANCING", ClassAnimations[rand],4.0,1,0,0,0,-1);
                
                class_in[playerid] = 24;
				return 0;
			}
			case TEAM_VAGOS:
			{
				userinfo[playerid][gid] = TEAM_VAGOS;
				userinfo[playerid][gskin] = 108;
				
                SetPlayerTeam(playerid, TEAM_VAGOS);
				SetPlayerPos(playerid, 2287.5903,-1107.4723,37.9766);
				SetPlayerFacingAngle(playerid, 180); 
                SetPlayerSkin(playerid, 108);
				
                InterpolateCameraPos(playerid, 2301.262451, -1132.500854, 59.928718, 2284.7876,-1117.1827,37.9766, 2000);
				InterpolateCameraLookAt(playerid, 2299.283447, -1128.518432, 57.643180,2287.5903,-1107.4723,37.9766, 2000);
				
                ClearAnimations(playerid);
				ApplyAnimation(playerid,"DANCING", ClassAnimations[rand],4.0,1,0,0,0,-1);
                
                class_in[playerid] = 28;
				return 0;
			}
			case TEAM_MAFIA:
			{
				userinfo[playerid][gid] = TEAM_MAFIA;
				userinfo[playerid][gskin] = 55;
				
                SetPlayerTeam(playerid, TEAM_MAFIA);
				SetPlayerPos(playerid,2180.0186,-2256.8735,14.7734);
				SetPlayerFacingAngle(playerid, 240);
                SetPlayerSkin(playerid, 55);
				
                InterpolateCameraPos(playerid, 2207.555664, -2266.463378, 29.055604, 2187.0168,-2262.7578,13.4510, 2000);
				InterpolateCameraLookAt(playerid, 2203.309326, -2265.023193, 26.843336,2180.0186,-2256.8735,14.7734, 2000);
				
                ClearAnimations(playerid);
				ApplyAnimation(playerid,"DANCING", ClassAnimations[rand],4.0,1,0,0,0,-1);
                
                class_in[playerid] = 32;
				return 0;
			}
			case TEAM_VIP:
			{
				userinfo[playerid][gid] = TEAM_VIP;
				userinfo[playerid][gskin] = 23;

				SetPlayerTeam(playerid, TEAM_VIP);
				SetPlayerPos(playerid, 1022.4600,-1123.6239,23.8702);
				SetPlayerFacingAngle(playerid, 180);
                SetPlayerSkin(playerid, 23);

				InterpolateCameraPos(playerid, 1052.617797, -1160.796630, 55.495792, 1022.266906, -1138.560791, 26.024034, 2000);
				InterpolateCameraLookAt(playerid, 1050.388916, -1157.074707, 53.010036,1022.405822, -1133.603515, 25.386693, 2000);
				
                ClearAnimations(playerid);
				ApplyAnimation(playerid,"DANCING", ClassAnimations[rand],4.0,1,0,0,0,-1);
                
                class_in[playerid] = 37;
				return 0;
			}
		}
	}
	else
	{
		ClearAnimations(playerid);

		class_gselected[playerid] = 0;
		class_selected[playerid] = 1;
        class_in[playerid] = -1;
        class_real[playerid] = -1;

        if(userinfo[playerid][onduty] == 0)
        {
            if(Text3D:INVALID_3DTEXT_ID != glabel[playerid]) Delete3DTextLabel(glabel[playerid]);
            new lstr[10]; 
            format(lstr, sizeof(lstr), "| %s |", ganginfo[userinfo[playerid][gid]][gtag]);
            glabel[playerid] = Create3DTextLabel(lstr, ganginfo[userinfo[playerid][gid]][gcolor], 0.0, 0.0, 0.0, 50.0, 0); 
            Attach3DTextLabelToPlayer(glabel[playerid], playerid, 0.0, 0.0, 0.3);
        }
	}
	return 1;
}

public OnPlayerConnect(playerid)
{ 
    printf("id - %i | came here", playerid);

	new str[180];
	PlayAudioStreamForPlayer(playerid, "https://www.mboxdrive.com/coffin.mp3");

    GetPlayerName(playerid, userinfo[playerid][pname], MAX_PLAYER_NAME);
    GetPlayerIp(playerid, userinfo[playerid][pip], 20);

    Corrupt_Check[playerid]++; 
    mysql_format(Database, str, sizeof(str), "SELECT * FROM `Users` WHERE `Name` = '%e' LIMIT 1", userinfo[playerid][pname]);
    mysql_tquery(Database, str, "OnPlayerDataCheck", "ii", playerid, Corrupt_Check[playerid]);

    SetTimerEx("OnPlayerConnectEx", 5000, false, "i", playerid);

    ResetPlayerVars(playerid);

    SetSpawnInfo(playerid, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	SetPlayerInterior(playerid, 0);
	SetPlayerPos(playerid, -231.7803,2379.3232,110.2815);
    SetPlayerVirtualWorld(playerid, playerid + 1);
    SetPlayerColor(playerid, 0xafafaf88);

    PreloadPlayerAnimations(playerid);

	TogglePlayerClock(playerid, false);

	CreatePlayerTextDraws(playerid);
	TextDrawShowForPlayer(playerid, connecttd[2]);
	TextDrawShowForPlayer(playerid, connecttd[3]);

    rbar[playerid] = CreatePlayerProgressBar(playerid, 501.000000, 350.000000, 109.500000, 3.200000, -1642851073, TIME_FOR_ROB_END, 0);
    lbar[playerid] = CreatePlayerProgressBar(playerid, 537.000000, 126.000000, 73.000000, 4.699999, 2147418367, 100.0000, 0);
    glbar[playerid] = CreatePlayerProgressBar(playerid, 537.000000, 151.000000, 73.000000, 4.699999, -65281, 100.0000, 0);

    //tune shop + vehicle shop
    //RemoveBuildingForPlayer(playerid, 4178, 1686.880, -1459.959, 16.296, 0.250);
    // RemoveBuildingForPlayer(playerid, 4179, 1686.880, -1459.959, 16.296, 0.250);

    //lggw land mark
    RemoveBuildingForPlayer(playerid, 13759, 1413.4141, -804.7422, 83.4375, 0.25);
    RemoveBuildingForPlayer(playerid, 13722, 1413.4141, -804.7422, 83.4375, 0.25);
    RemoveBuildingForPlayer(playerid, 13831, 1413.4141, -804.7422, 83.4375, 0.25);

	for(new i = 0; i < 100; i++) SendClientMessage(playerid, -1, "");

    format(str, sizeof(str), "{bebebe}* {ffffff}%s {bebebe}has connected to the server. Say {ffffff}Hello{bebebe}.", userinfo[playerid][pname]);
    SendClientMessageToAll_(-1, str);
    SendClientMessage(playerid, -1, "{801500}Warning -> {ff0000}If You Are Here To Advertise, Good Bye!");
    SendDeathMessage(INVALID_PLAYER_ID, playerid, 200);

    WriteLog(LOG_CONNECTS, "Name: %s | IP: %s", userinfo[playerid][pname], userinfo[playerid][pip]);

    #if DISCORD_SUPPORT == true
    new h, m, s;
    new y, mn, d;
    getdate(y, mn, d);
    gettime(h, m, s);
    format(str, sizeof(str), ":green_circle: `[ %d:%d:%d | %d:%d:%d ]` (`%s`) **%s[%d]** has joined the server", y, mn, d, h, m, s, userinfo[playerid][pip], userinfo[playerid][pname], playerid);
    DCC_SendChannelMessage(dcc_channel_con_discon, str);
	#endif
    return 1; 
}

new registered[MAX_PLAYERS];

forward  OnPlayerDataCheck(playerid, corrupt_check);
public OnPlayerDataCheck(playerid, corrupt_check)
{
	if(corrupt_check != Corrupt_Check[playerid])
    {
        new str[128];
        format(str, sizeof(str), "* \"%s[%i]\" has been kicked by the system due to MySQL system overload!", userinfo[playerid][pname], playerid);
        return DelayKick(playerid);
    }

	if(cache_num_rows())
	{
		cache_get_value(0, "Password", userinfo[playerid][ppass], 129);
		registered[playerid] = 1;
		userinfo[playerid][Player_Cache] = cache_save();
	}
	else registered[playerid] = 0;
	return 1;
}

new camtimer[MAX_PLAYERS];
new con_cam[MAX_PLAYERS];

forward ChangeCamera(playerid);
public ChangeCamera(playerid)
{
    if(logged[playerid]) 
    	{if(IsValidTimer(camtimer[playerid])) return KillTimer(camtimer[playerid]); camtimer[playerid] = INVALID_PLAYER_ID;}
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
			SetPlayerPos(playerid, 626.485168, 1694.970336, 497.924499);
			ApplyAnimation(playerid, "ped", "run_left", 4.1, 0, 0, 0, 0, 0, 3000);
			InterpolateCameraPos(playerid, 626.485168, 1694.970336, 497.924499, 626.525878, 1743.293579, 498.410339, 10000);
			InterpolateCameraLookAt(playerid, 626.385314, 1699.949951, 497.484954, 626.589660, 1748.292480, 498.489776, 10000);
			camtimer[playerid] = SetTimerEx("ChangeCamera", 10000, 0, "i", playerid);
		}
		case 3: 
		{	
			InterpolateCameraPos(playerid, 236.813812, 1931.322631, 17.508970, 230.078002, 1931.335693, 20.205249, 2000);
			InterpolateCameraLookAt(playerid, 232.230606, 1931.329467, 19.507511, 230.252639, 1936.092773, 21.735008, 2000);
			camtimer[playerid] = SetTimerEx("ChangeCamera", 2000, 0, "i", playerid);
		}
		case 4: 
		{	
			InterpolateCameraPos(playerid, 230.078033, 1931.335693, 20.205234, 230.463150, 1937.971923, 22.981601, 2000);
			InterpolateCameraLookAt(playerid, 230.421936, 1936.054687, 21.821506, 235.217697, 1937.944091, 24.528703, 2000);
			camtimer[playerid] = SetTimerEx("ChangeCamera", 2000, 0, "i", playerid);
		}
		case 5: 
		{	
			InterpolateCameraPos(playerid, 230.463119, 1937.971557, 22.981430, 237.287139, 1937.773681, 25.438411, 2000);
			InterpolateCameraLookAt(playerid, 235.230651, 1937.874145, 24.485130, 237.064178, 1932.788452, 25.124816, 2000);
			camtimer[playerid] = SetTimerEx("ChangeCamera", 2000, 0, "i", playerid);
		}
		case 6: 
		{				
			InterpolateCameraPos(playerid, 237.286636, 1937.773681, 25.438228, 236.902511, 1931.710693, 25.308553, 2000);
			InterpolateCameraLookAt(playerid, 236.899902, 1932.794067, 25.206541, 232.077606, 1931.682739, 26.619857, 2000);
			camtimer[playerid] = SetTimerEx("ChangeCamera", 2000, 0, "i", playerid);
		}
		case 7: 
		{	
			InterpolateCameraPos(playerid, 236.902526, 1931.710937, 25.308559, 230.507141, 1931.422119, 27.788366, 2000);
			InterpolateCameraLookAt(playerid, 232.079940, 1931.709350, 26.628658, 230.651992, 1936.347412, 28.637100, 2000);
			camtimer[playerid] = SetTimerEx("ChangeCamera", 2000, 0, "i", playerid);
		}
		case 8: 
		{	
			
			InterpolateCameraPos(playerid, 230.507278, 1931.422119, 27.788311, 230.006713, 1937.782470, 29.437480, 2000);
			InterpolateCameraLookAt(playerid, 230.623199, 1936.348144, 28.637044, 234.748947, 1937.685546, 31.019208, 2000);
			camtimer[playerid] = SetTimerEx("ChangeCamera", 2000, 0, "i", playerid);
		}
		case 9: 
		{	
			
			InterpolateCameraPos(playerid, 230.361175, 1937.731445, 29.540662, 237.359497, 1937.920898, 32.289524, 2000);
			InterpolateCameraLookAt(playerid, 235.054489, 1937.755249, 31.264678, 237.291488, 1932.958740, 32.899703, 2000);
			camtimer[playerid] = SetTimerEx("ChangeCamera", 2000, 0, "i", playerid);
		}
		case 10: 
		{	
			InterpolateCameraPos(playerid, 237.359497, 1937.920898, 32.289524, 234.373657, 1932.868041, 38.593242, 2000);
			InterpolateCameraLookAt(playerid, 237.291488, 1932.958740, 32.899703, 231.836517, 1928.875122, 36.974807, 2000);
			camtimer[playerid] = SetTimerEx("ChangeCamera", 2000, 0, "i", playerid);
		}
		case 11:
		{
			SetPlayerInterior(playerid, 10);
			SetPlayerPos(playerid, -974.2203,1089.6129,1344.9800);
			InterpolateCameraPos(playerid, -967.523437, 1060.484741, 1348.892578, -1130.473632, 1072.298950, 1369.214233, 10000);
			InterpolateCameraLookAt(playerid, -972.479736, 1060.608520, 1348.244628, -1125.967407, 1071.078613, 1367.424194, 10000);
			camtimer[playerid] = SetTimerEx("ChangeCamera", 10000, 0, "i", playerid);
		}
		case 12:
		{
			SetPlayerInterior(playerid, 18);
			SetPlayerPos(playerid, 1251.2056,-25.2684,1001.0347);
			InterpolateCameraPos(playerid, 1267.452514, 5.661926, 1008.270385, 1285.548339, 5.310754, 1002.339294, 10000);
			InterpolateCameraLookAt(playerid, 1272.014648, 5.540562, 1006.227844, 1285.231811, 0.342287, 1001.876525, 12000);
			camtimer[playerid] = SetTimerEx("ChangeCamera", 12000, 0, "i", playerid);
		}
		case 13:
		{
			SetPlayerInterior(playerid, 3);
			SetPlayerPos(playerid, 244.9740,142.1823,1003.0234);
			InterpolateCameraPos(playerid, 238.796234, 194.843811, 1008.599975, 238.569137, 184.553054, 1003.095092, 10000);
			InterpolateCameraLookAt(playerid, 238.687301, 190.380950, 1006.348083, 238.520050, 179.554733, 1003.214965, 11000);
			camtimer[playerid] = SetTimerEx("ChangeCamera", 11000, 0, "i", playerid);
		}
		case 14:
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

    #if DISCORD_SUPPORT == true
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
    #endif
	return 1;
}


public OnPlayerConnectEx(playerid)
{
    con_cam[playerid] = 0;
    ChangeCamera(playerid);

    
    switch(registered[playerid])
    {
        case 1:
        {
            new str[256];
            format(str, sizeof(str), "{FFFFFF}Welcome back to {33ff00}Lazer Gaming Gang WarZ\n\n{ffffff}Account{ff0000}\"%s\" {ffffff}is registered. Please enter your password below to login", userinfo[playerid][pname]);
            Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,"{ffa500}LGGW {ffffff}- Login",str,"Login","Quit");
        }
        case 0:
        {
            new str[1800];
            strcat(str, "{ffffff}Hey {b22222}ganster,\n", sizeof(str));
            strcat(str, "{ffffff}Welcome To {4169e1}Lazer Gaming {ffffff}| {4169e1}Gang WarZ{ffffff}!\n", sizeof(str));
            strcat(str, "\\c{4169e1}Lazer Gaming {ffffff}is a community where new buddies like you are {b22222}highly accepted {ffffff}and {b22222}warmly welcomed{ffffff}.\n", sizeof(str));
            strcat(str, "\\cWith our modernized concepts and frequetly updated game mode we hope you will enjoy the\n", sizeof(str));
            strcat(str, "\\cNext GeN Gang WarZ Experience.\n\n", sizeof(str));
            strcat(str, "\\cUnlike other gang wars servers in {4169e1}LG {ffffff}| GW {ffffff}you have nothing to worry about {b22222}cheaters and hackers{ffffff}.\n" , sizeof(str));
            strcat(str, "\\c{4169e1}LG {ffffff}| {4169e1}GW{ffffff}'s powerful anti-cheat system and active staff will look after them. So you have no\n" , sizeof(str));
            strcat(str, "\\cinterruptions for your enjoyment!\n\n", sizeof(str));
            strcat(str, "\\cWell, before you register keep in mind if you wish to use {b22222}hacks, break rules {ffffff}this is not the\n" , sizeof(str));
            strcat(str, "\\cplace for you.\n", sizeof(str));
            strcat(str, "\\cAlso don't forget to read the rules, stay in touch with our {ffff00}website {ffffff}at {b22222}\"lazergaming.net\" {ffffff}and\n", sizeof(str));
            strcat(str, "\\cintroduce yourself in our {ffff00}forum at {b22222}\"forum.lazergaming.net\" {ffffff}to recieve the 75K in-game money\n" , sizeof(str));
            strcat(str, "\\creserved just for you!\n", sizeof(str));
            strcat(str, "\\cTo learn more about {4169e1}LG {ffffff}| {4169e1}GW {ffffff}Gameplay and Features please use {b22222}'/help'\n", sizeof(str));
            strcat(str, "\\c{daa520}Play clean! Stay Safe! Fight For Your Destiny!\n\n", sizeof(str));
            strcat(str, "\\c{ffffff}Thanks.\n", sizeof(str));
            strcat(str, "\\c-{66cdaa}Lazer Gaming\n", sizeof(str));
            Dialog_Show(playerid, DIALOG_REGISTER_PRE, DIALOG_STYLE_MSGBOX,"{ffa500}LGGW {ffffff}- Registration", str, "Okay", ""); 
        }
    }

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
	return 1;
}

Dialog:DIALOG_REGISTER_PRE(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new str[256];
        format(str, sizeof(str), "{ffffff}Welcome to {33ff00}Lazer Gaming Gang WarZ\n\n{ffffff}Your account{ff0000}\"%s\" {ffffff}is not registered. Please enter a desired password below to register", userinfo[playerid][pname]);
        Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT,"{ffa500}LGGW {ffffff}- Registration",str,"Register","Quit"); 
    }
    return 1;
}

public OnRconLoginAttempt(ip[], password[], success) 
{
	new id = -1;
	
	foreach(new i : Player)
	{
		if(isequal(ip, userinfo[i][pip]))
		{
			id = i;
			break;
		}
	}

    #if DISCORD_SUPPORT == true
	new str[256];
    #endif
	if(success)																			
	{
        #if DISCORD_SUPPORT == true
		format(str, sizeof(str), "[ STEP 1 ] **`%s[%d]` has accessed RCON partialy! :face_with_monocle:**", userinfo[id][pname], id);
		DCC_SendChannelMessage(dcc_channel_rcon, str);
		#endif

        Dialog_Show(id, DIALOG_RCON, DIALOG_STYLE_PASSWORD, "{ffa500}LGGW {ffffff}- Rcon protection", "You have logged in RCON partially,\nNow input the 2nd RCON security password to access the SERVER features", "Access", "Quit");
		return rconattempts[id] = 0;
	}
    #if DISCORD_SUPPORT == true
	format(str, sizeof(str), "[ STEP 1 ] `%s[%d]` is trying to access RCON... @Developers use /aka to check who is this! May be he is an enemy :angry: (password: `%s`).", userinfo[id][pname], id, password);
	DCC_SendChannelMessage(dcc_channel_rcon, str);
    #endif
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(logged[playerid])
	{
		new str[60];
		format(str, sizeof(str), "~r~PL:_~y~%.2f~n~~r~FPS:_~y~%d~n~~r~Ping:_~y~%d", NetStats_PacketLossPercent(playerid), pFPS[playerid] - 1, GetPlayerPing(playerid));
		PlayerTextDrawSetString(playerid, fplabel_1[playerid], str);
		
		new drunk_new;
		drunk_new = GetPlayerDrunkLevel(playerid);
		
		if (drunk_new < 100) 
		{ 
			SetPlayerDrunkLevel(playerid, 2000);
		} 
		else 
		{
			if(pDrunkLevelLast[playerid] != drunk_new) 
			{
				new wfps = pDrunkLevelLast[playerid] - drunk_new;
				
				if ((wfps > 0) && (wfps < 200))
					pFPS[playerid] = wfps;
				
				pDrunkLevelLast[playerid] = drunk_new;
			}
		}

        if(GetPlayerMenu(playerid) != Menu:INVALID_MENU && GetPlayerMenu(playerid) != tune_colors2)
        {
            new ud, lr, keys;
            GetPlayerKeys(playerid, keys, ud, lr);
            if(ud == KEY_UP)
            {
                if(last_key[playerid] != KEY_UP)
                {
                    last_key[playerid] = KEY_UP;
                    Tune_SetupMenuRowValue(playerid, 1);

                    Tune_SetupVehicle(playerid); 
                    SendClientMessageToAll_(-1, "key_up");
                    
                    if(GetPlayerMenu(playerid) == tune_main) Tune_SetupMenuCamera(playerid);
                    PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
                }
            }
            else if(ud == KEY_DOWN)
            {
                if(last_key[playerid] != KEY_DOWN)
                {
                    last_key[playerid] = KEY_DOWN;
                    Tune_SetupMenuRowValue(playerid, 0);

                    Tune_SetupVehicle(playerid); 
                    SendClientMessageToAll_(-1, "key_down");

                    if(GetPlayerMenu(playerid) == tune_main) Tune_SetupMenuCamera(playerid);
                    PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
                }
            }
            else last_key[playerid] = KEY_DEFAULT;
        }

        if(time_edrink[playerid] != -1)
        {
        	if(tickcount() - time_edrink[playerid] >= 1500)
        	{
        		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        		time_edrink[playerid] = -1;
        		new Float:health;
        		GetPlayerHealth(playerid, health);
        		SetPlayerHealth(playerid, health + HEALTH_FOR_EDRINK); 
        	}
        }

        if(time_band[playerid] != -1)
        {
        	if(tickcount() - time_band[playerid] >= 2000)
        	{
        		time_band[playerid] = -1;
        		new Float:health;
        		GetPlayerHealth(playerid, health);
        		SetPlayerHealth(playerid, health + HEALTH_FOR_BANDAGE); 
        	}
        }
    }

	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	new str[128];
    
    if(IsValidTimer(camtimer[playerid])) 
    {
    	KillTimer(camtimer[playerid]);
    	camtimer[playerid] = INVALID_PLAYER_ID;
    }
    if(IsValidTimer(reqtimer[playerid])) 
    {
        KillTimer(reqtimer[playerid]);
        reqtimer[playerid] = INVALID_PLAYER_ID;
        ExpireGangRequest(playerid);
    }
    if(IsValidTimer(kill_counter[playerid]) )
	{
		KillTimer(kill_counter[playerid]);
		PlayerTextDrawHide(playerid, killtext[playerid]);
		kill_counter[playerid] = INVALID_PLAYER_ID;
	}


    if(glabel[playerid] != Text3D:INVALID_3DTEXT_ID)
    {
        Delete3DTextLabel(glabel[playerid]);
        glabel[playerid] = Text3D:INVALID_3DTEXT_ID;
    }

    if(alabel[playerid] != Text3D:INVALID_3DTEXT_ID)
    {
        Delete3DTextLabel(alabel[playerid]);
        alabel[playerid] = Text3D:INVALID_3DTEXT_ID;
    }

	PlayerTextDrawDestroy(playerid, fplabel_1[playerid]);
	PlayerTextDrawDestroy(playerid, wastedtd_1[playerid]);
	PlayerTextDrawDestroy(playerid, vehtd_1[playerid]);
	PlayerTextDrawDestroy(playerid, turfcashtd[playerid]);
	PlayerTextDrawDestroy(playerid, moneytd_1[playerid]);
	PlayerTextDrawDestroy(playerid, DM_1[playerid]);
	PlayerTextDrawDestroy(playerid, killtext[playerid]);

	PlayerTextDrawDestroy(playerid, gangtd_1[playerid][0]);
    PlayerTextDrawDestroy(playerid, gangtd_1[playerid][1]);
    PlayerTextDrawDestroy(playerid, gangtd_1[playerid][2]);
    PlayerTextDrawDestroy(playerid, gangtd_1[playerid][3]);
    PlayerTextDrawDestroy(playerid, gangtd_1[playerid][4]);
	PlayerTextDrawDestroy(playerid, zonetd_1[playerid][0]);
    PlayerTextDrawDestroy(playerid, zonetd_1[playerid][1]);
	PlayerTextDrawDestroy(playerid, takeovertd_1[playerid][0]);
    PlayerTextDrawDestroy(playerid, takeovertd_1[playerid][1]);
	PlayerTextDrawDestroy(playerid, statstd_1[playerid][0]);
    PlayerTextDrawDestroy(playerid, statstd_1[playerid][1]);
    PlayerTextDrawDestroy(playerid, statstd_1[playerid][2]);
    PlayerTextDrawDestroy(playerid, statstd_1[playerid][3]);
    PlayerTextDrawDestroy(playerid, statstd_1[playerid][4]);
    PlayerTextDrawDestroy(playerid, statstd_1[playerid][5]);

	DestroyPlayerProgressBar(playerid, rbar[playerid]);

	SendDeathMessage(INVALID_PLAYER_ID, playerid, 201);

	new szDisconnectReason[3][] =
	{
		"Timeout/Crash",
		"Quit",
		"Kick/Ban"
	};
	
	format(str, sizeof(str), "{bebebe}* %s has left the server (%s).", userinfo[playerid][pname], szDisconnectReason[reason]);
	SendClientMessageToAll_(-1, str); 

    #if DISCORD_SUPPORT == true
    new h, m, s;
    new y, mn, d;
    getdate(y, mn, d);
    gettime(h, m, s);
    format(str, sizeof(str), ":red_circle: `[ %d:%d:%d | %d:%d:%d ]` **%s[%d]** has left the server (`%s`).", y, mn, d, h, m, s, userinfo[playerid][pname], playerid, szDisconnectReason[reason]);
    DCC_SendChannelMessage(dcc_channel_con_discon, str);
    #endif

	if(logged[playerid] == 1)
	{
		mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Play_time` = %d, `Last_online` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][ptime], gettime(), userinfo[playerid][pid]);
		mysql_tquery(Database, str);

		for(new i = 0; i < 10; i++)
		{
			if(toyinfo[playerid][i][tused])
			{
				RemovePlayerAttachedObject(playerid, i);
			}
		}

		if(INVALID_VEHICLE_ID != priveh[playerid])   
		{
			DestroyPrivateVehicle(playerid);
		}
		if(INVALID_VEHICLE_ID != adminveh[playerid])
		{
			DestroyVehicle(adminveh[playerid]); 
			adminveh[playerid] = INVALID_VEHICLE_ID;
		}

		WriteLog(LOG_DISCONNECTS, "Name: %s | Reason: %s", userinfo[playerid][pname], szDisconnectReason[reason]);

		new id = enemy[playerid];

		if(inminigame[playerid] == 1) 
		{
			inminigame[playerid] = 0;
			if(indm[playerid] == 1)
			{
				indm[playerid] = 0;
			}
			else if(instunt[playerid] == 1) 
			{
				instunt[playerid] = 0;
			}
			else if(induel[playerid] == 1)
			{
				GivePlayerCash(id, duelbet[playerid]);
				GivePlayerCash(playerid, -duelbet[playerid]);
				
                new Float:hp;
				GetPlayerHealth(id, hp);
				format(str, sizeof(str), "{ff0000}\"%s\" {eee8aa}won the duel against {ff0000}\"%s\" {eee8aa}with {ffff00}%.2f HP {eee8aa}({ffffff}Oponnent disconnected{eee8aa}).", userinfo[id][pname], userinfo[playerid][pname], hp);
				SendClientMessageToAll_(-1, str);
				
                userinfo[id][dwon]++;
				induel[id] = 0;
				inminigame[id] = 0;
				duelinvited[id] = 0;
				duelinviter[id] = 0;
				
                ResetPlayerWeapons(id);
				SetPlayerDetails(id);

				mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Duels_won` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[id][dwon], userinfo[id][pid]);
				mysql_tquery(Database, str);
			}
			else if(inlms[playerid] == 1)
			{
				inlms[playerid] = 0;
				format(str, sizeof(str), "{8000ff}\"%s[%d]\" dropped out of LMS with {ffffff}%d {8000ff}kills {ffffff}(Player disconnected).", userinfo[playerid][pname], playerid, lmskills[playerid]);
				SendClientMessageToAll_(-1, str);
				
                new count;
				foreach(new i : Player) if(inlms[i] == 1) count ++;
				
                if(count == 1)
				{
					foreach(new i : Player)
					{
						if(inlms[i] == 1)
						{
							format(str, sizeof(str), "{8000ff}\"%s[%d]\" survived in the Last Man Standing with {ffffff}%d {8000ff}kills and won {ffffff}%d$ {8000ff}! {ffffff}Congratz!!!", userinfo[i][pname], i, lmskills[i], MONEY_PER_LMS_KILL * lmskills[i]);
							SendClientMessageToAll_(-1, str);
							
                            lmsstarted = 0;
							inlms[i] = 0;
							inminigame[i] = 0;
							userinfo[i][lmswon] ++;
							
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
			format(str, sizeof(str), "{eee8aa}Duel request by {ff0000}%s {eee8aa}has been expired {eee8aa}({ffffff}Oponnent disconnected{eee8aa}).", userinfo[playerid][pname]);
			SendClientMessage(id, -1, str);
		}
		if(duelinvited[playerid] == 1)
		{
			KillTimer(dstimer[id]);
			duelinviter[id] = 0;
			format(str, sizeof(str), "{eee8aa}Duel request for {ff0000}%s {eee8aa}has been expired {eee8aa}({ffffff}Oponnent disconnected{eee8aa}).", userinfo[playerid][pname]);
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
	if(IsPlayerNPC(playerid)) return 1;
	
    new str[128];
	PlayerTextDrawShow(playerid, fplabel_1[playerid]);
	SetCameraBehindPlayer(playerid);

    if(userinfo[playerid][VIP] == 1)
    {
        if(userinfo[playerid][VIP_exp] != -1)
        {
            if(gettime() <= userinfo[playerid][VIP_exp])
            {
                SendClientMessage(playerid, -1, "{eee8aa}Your {ffffff}VIP access period has been {ff0000}expired{eee8aa!");
                SendClientMessage(playerid, -1, "{eee8aa}You can purchase the 'never expire' version if you are interested!");
                SendClientMessage(playerid, -1, "{eee8aa}Thank you for {ffffff}donating {eee8aa}us!!!");
                
                userinfo[playerid][VIP] = 0;
                mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `VIP` = 0 WHERE `User_ID` = %d", userinfo[playerid][pid]);
            }
        }
    }

	if(justconnected[playerid] == 1)
	{	
		PC_EmulateCommand(playerid, "/rules");
		SendClientMessage(playerid, -1, "{eee8aa}Use {ff0000}'/cmds' {eee8aa}to see server commands{ffffff}!");
		SendClientMessage(playerid, -1, "{eee8aa}Use {ff0000}'/keys' {eee8aa}to see server available keys{ffffff}!");
		SendClientMessage(playerid, -1, "{eee8aa}Use {ff0000}'/help' {eee8aa}get help in detail{ffffff}!");
		SendClientMessage(playerid, -1, "{eee8aa}Use {ff0000}'/credits' {eee8aa}to see server creators{ffffff}!");
		if(userinfo[playerid][ingang] == 1)
		{
			format(str, sizeof(str), "{6800b3}~Gang~ {ffffff}%s {9370DB}~Level~ {ffffff}%s ", ReplaceUwithS(ganginfo[userinfo[playerid][gid]][gname]), GangLevelName(userinfo[playerid][glevel]));
			SendClientMessage(playerid, -1, str);
		}
		justconnected[playerid] = 0;
		StopAudioStreamForPlayer(playerid);
	}
	 
	if(frozen[playerid] == 1) TogglePlayerControllable(playerid, 0);

	if(userinfo[playerid][jailed] == 1)
	{
		SetPlayerPos(playerid, 264.4176, 77.8930, 1001.0391);
		SetPlayerInterior(playerid, 6);
		StopAudioStreamForPlayer(playerid);
		return SetPlayerHealth(playerid, 100);
	}  

	for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
	{
		if(toyinfo[playerid][i][tused])
		{
			SetPlayerAttachedObject(playerid, i, Toys[toyinfo[playerid][i][tid]][tmodel], 
			toyinfo[playerid][i][bone], 
			toyinfo[playerid][i][posx], 
			toyinfo[playerid][i][posy], 
			toyinfo[playerid][i][posz], 
			toyinfo[playerid][i][rotx], 
			toyinfo[playerid][i][roty],
			toyinfo[playerid][i][rotz],
			toyinfo[playerid][i][scalex], 
			toyinfo[playerid][i][scaley],
			toyinfo[playerid][i][scalez]);
		}
	}

	for(new i = 0; i < sizeof(zoneinfo); i++) 
	{
		GangZoneShowForPlayer(playerid, ZONEID[i], Zone_ColorAlpha(ganginfo[zoneinfo[i][zteamid]][gcolor]));
		if(zoneinfo[i][ZoneAttacker] != -1) GangZoneFlashForPlayer(playerid, ZONEID[i], Zone_ColorAlpha(ganginfo[zoneinfo[i][ZoneAttacker]][gcolor])); 
	}

	PlayerTextDrawHide(playerid, wastedtd_1[playerid]);
	TextDrawHideForPlayer(playerid, wastedtd[0]);
	TextDrawHideForPlayer(playerid, wastedtd[1]);
	TextDrawHideForPlayer(playerid, wastedtd[2]);
	TextDrawHideForPlayer(playerid, wastedtd[3]);
	TextDrawHideForPlayer(playerid, wastedtd[4]);

	if(spec[playerid])
	{
		spec[playerid] = 0;
		ResetPlayerWeapons(playerid);
		return SetPlayerDetails(playerid);
	}

	SAWNBOUGHT[playerid] = 0;
	ARMOURBOUGHT[playerid] = 0;

	ResetPlayerWeapons(playerid);

	if(inminigame[playerid] == 1)
	{
		SetPlayerSkin(playerid, userinfo[playerid][gskin]);
		if(indm[playerid] == 1)
		{
			TextDrawShowForPlayer(playerid, DM__[0]);
            TextDrawShowForPlayer(playerid, DM__[1]);
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
			else if(dmid[playerid] == 7)
			{
				SetPlayerInterior(playerid,0);
				new Rand = random(sizeof(DM7Randoms));
				SetPlayerPos(playerid, DM7Randoms[Rand][0], DM7Randoms[Rand][1], DM7Randoms[Rand][2]);
				SetPlayerFacingAngle(playerid, DM7Randoms[Rand][3]);
				GivePlayerWeapon(playerid, 24, 2000);
				GivePlayerWeapon(playerid, 25, 2000);
				GivePlayerWeapon(playerid, 4, 2000);
			}
			else if(dmid[playerid] == 8)
			{
				SetPlayerInterior(playerid,0);
				new Rand = random(sizeof(DM8Randoms));
				SetPlayerPos(playerid, DM8Randoms[Rand][0], DM8Randoms[Rand][1], DM8Randoms[Rand][2]);
				SetPlayerFacingAngle(playerid, DM8Randoms[Rand][3]);
				GivePlayerWeapon(playerid, 24, 2000);
				GivePlayerWeapon(playerid, 25, 2000);
				GivePlayerWeapon(playerid, 4, 2000);
			}
			else if(dmid[playerid] == 9)
			{
				SetPlayerInterior(playerid,0);
				new Rand = random(sizeof(DM9Randoms));
				SetPlayerPos(playerid, DM9Randoms[Rand][0], DM9Randoms[Rand][1], DM9Randoms[Rand][2]);
				SetPlayerFacingAngle(playerid, DM9Randoms[Rand][3]);
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
		SetPlayerSkin(playerid, userinfo[playerid][gskin]);
		SetPlayerArmour(playerid, 0);
		SetPlayerHealth(playerid, 100);
		GivePlayerWeapon(playerid, 30, 150);
		GivePlayerWeapon(playerid, 24, 100);
		GivePlayerWeapon(playerid, 25, 150);
		if(userinfo[playerid][ingang] == 0)
		{    
			SetPlayerVirtualWorld(playerid, userinfo[playerid][gid] + 1);    
			switch(userinfo[playerid][gid])
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
			SetPlayerSkin(playerid, userinfo[playerid][gskin]);
			SetPlayerTeam(playerid, userinfo[playerid][gid]);
			SetPlayerColor(playerid, ganginfo[userinfo[playerid][gid]][gcolor]);
			SetPlayerInterior(playerid, 0);
			if(ganginfo[userinfo[playerid][gid]][ghouse] == 0)
			{
				new Rand = random(sizeof(LSRandoms));
				SetPlayerPos(playerid, LSRandoms[Rand][0], LSRandoms[Rand][1], LSRandoms[Rand][2]);
				SetPlayerFacingAngle(playerid, LSRandoms[Rand][3]);
				SetPlayerVirtualWorld(playerid, 0);
			}
			else
			{
				SetPlayerVirtualWorld(playerid, INT_VW);    
				SetPlayerInterior(playerid, houseinfo[ganginfo[userinfo[playerid][gid]][ghouseid]][hintid]);
				SetPlayerPos(playerid, houseinfo[ganginfo[userinfo[playerid][gid]][ghouseid]][spawn][0], houseinfo[ganginfo[userinfo[playerid][gid]][ghouseid]][spawn][1], houseinfo[ganginfo[userinfo[playerid][gid]][ghouseid]][spawn][2]);
				SetPlayerFacingAngle(playerid, houseinfo[ganginfo[userinfo[playerid][gid]][ghouseid]][spawn][3]);
			}
			
		}
	}

	if(userinfo[playerid][onduty] == 1)
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
		if(spec[i] == 1 && specid[i] == playerid && i != playerid)
		{
			TogglePlayerSpectating(i, 1);
			
			if(!IsPlayerInAnyVehicle(playerid)) PlayerSpectatePlayer(i, playerid);
			else PlayerSpectateVehicle(i, GetPlayerVehicleID(playerid));
		}
	}
	return 1;
}

forward HideKillCount(playerid);
public HideKillCount(playerid)
{
	PlayerTextDrawHide(playerid, killtext[playerid]);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(IsPlayerNPC(playerid) || IsPlayerNPC(killerid)) return 1;
	
	if(hshotid != -1 && hshotgot == playerid)
	{
		killerid = hshotid;
		reason = 34;
		hshotid = -1;
	}

	SendDeathMessage(killerid, playerid, reason);

	TextDrawHideForPlayer(playerid, zonetd);
	TextDrawHideForPlayer(playerid, statstd);

	TextDrawHideForPlayer(playerid, takeovertd[0]);
    TextDrawHideForPlayer(playerid, takeovertd[1]);
    TextDrawHideForPlayer(playerid, takeovertd[2]);
    TextDrawHideForPlayer(playerid, takeovertd[3]);
	TextDrawHideForPlayer(playerid, DM__[0]);
    TextDrawHideForPlayer(playerid, DM__[1]);
	
	PlayerTextDrawHide(playerid,fplabel_1[playerid]);
	PlayerTextDrawHide(playerid,vehtd_1[playerid]);
	PlayerTextDrawHide(playerid,turfcashtd[playerid]);
	PlayerTextDrawHide(playerid,moneytd_1[playerid]);
	PlayerTextDrawHide(playerid,DM_1[playerid]);
	
	PlayerTextDrawHide(playerid,zonetd_1[playerid][0]);
    PlayerTextDrawHide(playerid,zonetd_1[playerid][1]);
	PlayerTextDrawHide(playerid,takeovertd_1[playerid][0]);
    PlayerTextDrawHide(playerid,takeovertd_1[playerid][1]);
	PlayerTextDrawHide(playerid,statstd_1[playerid][0]);
    PlayerTextDrawHide(playerid,statstd_1[playerid][1]);
    PlayerTextDrawHide(playerid,statstd_1[playerid][2]);
    PlayerTextDrawHide(playerid,statstd_1[playerid][3]);
    PlayerTextDrawHide(playerid,statstd_1[playerid][4]);
    PlayerTextDrawHide(playerid,statstd_1[playerid][5]);

	HidePlayerProgressBar(playerid, rbar[playerid]);

	TextDrawShowForPlayer(playerid, wastedtd[0]);
	TextDrawShowForPlayer(playerid, wastedtd[1]);
	TextDrawShowForPlayer(playerid, wastedtd[2]);
	TextDrawShowForPlayer(playerid, wastedtd[3]);
	TextDrawShowForPlayer(playerid, wastedtd[4]);

	last_shot[playerid] = 0;

	if(IsValidTimer(kill_counter[playerid]) )
	{
		KillTimer(kill_counter[playerid]);
		PlayerTextDrawHide(playerid, killtext[playerid]);
		kill_counter[playerid] = INVALID_PLAYER_ID;
	}

	if(killerid != INVALID_PLAYER_ID)
	{
		new dstr[128];
		format(dstr, sizeof(dstr), "%s_~w~killed you", userinfo[killerid][pname]);
		PlayerTextDrawColor(playerid, wastedtd_1[playerid], GetPlayerColor(playerid)); 
		PlayerTextDrawSetString(playerid, wastedtd_1[playerid], dstr);
		PlayerTextDrawShow(playerid, wastedtd_1[playerid]);

        //cur_kills[killerid] ++;
        //cur_kills[playerid] = 0;
//
        //switch(cur_kills[killerid]) 
        //{
        //    case 1: PlayerTextDrawSetString(killerid, killtext[killerid], "First Blood");
        //    case 2: PlayerTextDrawSetString(killerid, killtext[killerid], "Double kill");
        //    case 3: PlayerTextDrawSetString(killerid, killtext[killerid], "Triple Kill");
        //    case 4: PlayerTextDrawSetString(killerid, killtext[killerid], "Quad kill");
        //    case 5: PlayerTextDrawSetString(killerid, killtext[killerid], "Penta Kill");
        //    case 6: PlayerTextDrawSetString(killerid, killtext[killerid], "Ultra Kill");
        //    case 7: PlayerTextDrawSetString(killerid, killtext[killerid], "Rampage");
        //    case 8: PlayerTextDrawSetString(killerid, killtext[killerid], "Killing Spree");
        //    case 9: PlayerTextDrawSetString(killerid, killtext[killerid], "Dominating");
        //    case 10: PlayerTextDrawSetString(killerid, killtext[killerid], "Mega Kill");
        //    case 11: PlayerTextDrawSetString(killerid, killtext[killerid], "Unstoppable");
        //    case 12: PlayerTextDrawSetString(killerid, killtext[killerid], "Wicked Sick");
        //    case 13: PlayerTextDrawSetString(killerid, killtext[killerid], "Monster Kill");
        //    case 14: PlayerTextDrawSetString(killerid, killtext[killerid], "Godlike");
        //    case 15: PlayerTextDrawSetString(killerid, killtext[killerid], "Holy Shit");
        //    case 16: PlayerTextDrawSetString(killerid, killtext[killerid], "Ownage");
        //}
//
        //PlayerTextDrawShow(killerid, killtext[killerid]);
//
        //if(IsValidTimer(kill_counter[killerid])) KillTimer(kill_counter[killerid]);
        //kill_counter[killerid] = SetTimerEx("HideKillCount", 4000, 0, "i", killerid);

		userinfo[playerid][pdeaths] ++;
		userinfo[killerid][pkills] ++;

		mysql_format(Database, dstr, sizeof(dstr), "UPDATE `Users` SET `Kills` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[killerid][pkills], userinfo[killerid][pid]);
		mysql_tquery(Database, dstr);

		mysql_format(Database, dstr, sizeof(dstr), "UPDATE `Users` SET `Deaths` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][pdeaths], userinfo[playerid][pid]);
		mysql_tquery(Database, dstr);

		if(userinfo[killerid][pdeaths] != 0)
		{
			mysql_format(Database, dstr, sizeof(dstr), "UPDATE `Users` SET `Ratio` = %f WHERE `User_ID` = %d LIMIT 1", floatdiv(userinfo[killerid][pkills], userinfo[killerid][pdeaths]), userinfo[killerid][pid]);
			mysql_tquery(Database, dstr);
		}

		mysql_format(Database, dstr, sizeof(dstr), "UPDATE `Users` SET `Ratio` = %f WHERE `User_ID` = %d LIMIT 1", floatdiv(userinfo[playerid][pkills], userinfo[playerid][pdeaths]), userinfo[playerid][pid]);
		mysql_tquery(Database, dstr);

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
				format(str, sizeof(str), "{ff0000}\"%s\" {eee8aa}won the duel against {ff0000}\"%s\" {eee8aa}with {ffff00}%.2f HP", userinfo[id][pname], userinfo[playerid][pname], hp);
				SendClientMessageToAll_(-1, str);
				userinfo[id][dwon]++;
				induel[id] = 0;
				duelinvited[id] = 0;
				duelinvited[playerid] = 0;
				duelinviter[id] = 0;
				duelinviter[playerid] = 0;
				ResetPlayerWeapons(id);
				SetPlayerDetails(id);
				PlayerPlaySound(playerid,1069,0.0,0.0,0.0);
				PlayerPlaySound(id,1069,0.0,0.0,0.0);

				mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Duels_won` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[killerid][dwon], userinfo[killerid][pid]);
				mysql_tquery(Database, str);
			}
			else if(inlms[playerid] == 1)
			{
				new str[180];
				lmskills[killerid] ++;
				format(str, sizeof(str), "{8000ff}\"%s[%d]\" dropped out of LMS with {ffffff}%d {8000ff}kills {ffffff}(killed by %s[%d]).", userinfo[playerid][pname], playerid, lmskills[playerid], userinfo[killerid][pname], killerid);
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
					format(str, sizeof(str), "{8000ff}\"%s[%d]\" survived in the Last Man Standing with {ffffff}%d {8000ff}kills and won {ffffff}%d$ {8000ff}! {ffffff}Congratz!!!", userinfo[killerid][pname], killerid, lmskills[killerid], lmskills[killerid] * MONEY_PER_LMS_KILL); 
					SendClientMessageToAll_(-1, str);
					ResetPlayerWeapons(killerid);
					SetPlayerDetails(killerid);
					foreach(new k : Player)
					{
						SetPlayerMarkerForPlayer(k, killerid, COLOR[killerid]);
					}
					GivePlayerCash(killerid, lmskills[killerid] * MONEY_PER_LMS_KILL);
					userinfo[killerid][lmswon] ++;
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
				if(gg_lvl[killerid] == 20) format(str, sizeof(str), "{408080}OMG! OMG!! OMG!!! {ffffff}\"%s\" {408080}reached the maximum level {ffffff}(%d) {408080}by killing {ffffff}\"%s\" {408080}and got {ffffff}%s", userinfo[killerid][pname], gg_lvl[killerid], userinfo[playerid][pname], RetGGWep(killerid));
				else if(gg_lvl[killerid] > 20) format(str, sizeof(str), "{ffffff}\"%s\" {408080}killed {ffffff}\"%s\" {408080}and he is at the maximum level {ffffff}(20) {408080}with {ffffff}%s", userinfo[killerid][pname], userinfo[playerid][pname], RetGGWep(killerid));
				else format(str, sizeof(str), "{ffffff}\"%s\" {408080}killed {ffffff}\"%s\" {408080}in gungame and got {ffffff}\"%s\" {408080}(level: {ffffff}%d{408080}).", userinfo[killerid][pname], userinfo[playerid][pname], RetGGWep(killerid), gg_lvl[killerid]);
				SendClientMessageToAll_(-1, str);
			}
		}
		else
		{
			new str[128];
			rampage[killerid] ++;
			
			if(GetPlayerWeapon(killerid) == 0)
			{
				format(str, sizeof(str), "* {ffffff}\"%s\" {b03060}has brutally murdered {ffffff}\"%s\" {b03060}with bare hands", userinfo[killerid][pname], userinfo[playerid][pname]);
				SendClientMessageToAll_(-1, str);
				userinfo[killerid][bkills] ++;
				
				mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Brutal_kills` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[killerid][bkills], userinfo[killerid][pid]);
				mysql_tquery(Database, str);
			}
			if(rampage[playerid] >= 5)
			{
				format(str, sizeof(str), "* {ffffff}\"%s\" {b03060}has finished {ffffff}%s{b03060}'s rampage on {ff0000}%d {b03060}kills (reward : {ffffff}$%d{b03060}).", userinfo[killerid][pname], userinfo[playerid][pname], rampage[playerid], MONEY_PER_KILL_IN_RAMPAGE * rampage[playerid]);
				SendClientMessageToAll_(-1, str);
				format(str, sizeof(str), "~r~You ruined someone's~n~party~n~~n~~g~$%d", MONEY_PER_KILL_IN_RAMPAGE * rampage[playerid]);
				GameTextForPlayer(killerid, str, 5000, 5);
				GivePlayerCash(killerid, MONEY_PER_KILL_IN_RAMPAGE * rampage[playerid]);
				revenge[playerid] = 1;
				revengeid[playerid] = killerid;
			}
			if(rampage[killerid] % 5 == 0)
			{
				format(str, sizeof(str), "* {ffffff}\"%s\" {b03060}is on rampage with {ffffff}%d {b03060}consicutive killings! (reward : {ffffff}$%d{b03060}).", userinfo[killerid][pname], rampage[killerid], MONEY_PER_KILL_IN_RAMPAGE * rampage[killerid]);
				SendClientMessageToAll_(-1, str);
			}
			if(revenge[killerid] == 1 && revengeid[killerid] == playerid)
			{
				format(str, sizeof(str), "* {ffffff}\"%s\" {b03060}got his revenge on {ffffff}\"%s\"", userinfo[killerid][pname], userinfo[playerid][pname]);
				SendClientMessageToAll_(-1, str);
				GameTextForPlayer(killerid, "~r~revenge", 5000 ,5);
				userinfo[killerid][revenges] ++;
				revenge[killerid] = 0; 

				mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Revenges` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[killerid][revenges], userinfo[killerid][pid]);
				mysql_tquery(Database, str);
			}

			if(userinfo[killerid][bramp] < rampage[killerid])
			{
				userinfo[killerid][bramp] = rampage[killerid];
				
				mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Highest_rampage` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[killerid][bramp], userinfo[killerid][pid]);
				mysql_tquery(Database, str);
			}

			rampage[playerid] = 0;
			
			GivePlayerCash(killerid, 300);
			GivePlayerCash(playerid, -100);
			ganginfo[userinfo[playerid][gid]][gdeaths]++;
			if(ganginfo[userinfo[playerid][gid]][gscore] > 20) ganginfo[userinfo[playerid][gid]][gscore] -= (GANG_SCORE_PER_KILL - 3);
			ganginfo[userinfo[killerid][gid]][gkills]++;
			ganginfo[userinfo[killerid][gid]][gscore] += GANG_SCORE_PER_KILL;

			mysql_format(Database, str, sizeof(str), "UPDATE `Gangs` SET `Kills` = %d, `Score` = %d WHERE `Gang_ID` = %d LIMIT 1", ganginfo[userinfo[killerid][gid]][gkills], ganginfo[userinfo[killerid][gid]][gscore], userinfo[killerid][gid] + 1);
			mysql_tquery(Database, str);

			mysql_format(Database, str, sizeof(str), "UPDATE `Gangs` SET `Deaths` = %d, `Score` = %d WHERE `Gang_ID` = %d LIMIT 1", ganginfo[userinfo[playerid][gid]][gdeaths], ganginfo[userinfo[playerid][gid]][gscore], userinfo[playerid][gid] + 1);
			mysql_tquery(Database, str);
		}
        
        new str[128];
        mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Score` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][pscore], userinfo[playerid][pid]);
        mysql_tquery(Database, str);
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
			format(str, sizeof(str), "{ff0000}\"%s\" {eee8aa}won the duel against {ff0000}\"%s\" {eee8aa}with {ffff00}%.2f HP {eee8aa}({ffffff}Oponnent suicide{eee8aa}).", userinfo[id][pname], userinfo[playerid][pname], hp);
			SendClientMessageToAll_(-1, str);
			userinfo[id][dwon]++;
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
			format(str, sizeof(str), "{8000ff}\"%s[%d]\" dropped out of LMS with {ffffff}%d {8000ff}kills {ffffff} (suicide).", userinfo[playerid][pname], playerid, lmskills[playerid]);
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
				format(str, sizeof(str), "{8000ff}\"%s[%d]\" survived in the Last Man Standing with {ffffff}%d {8000ff}kills and won {ffffff}%d$ {8000ff}! {ffffff}Congratz!!!", userinfo[id][pname], id, lmskills[id], lmskills[id] * MONEY_PER_LMS_KILL); 
				SendClientMessageToAll_(-1, str);
				ResetPlayerWeapons(id);
				SetPlayerDetails(id);
				foreach(new k : Player)
				{
					SetPlayerMarkerForPlayer(k, id, COLOR[id]);
				}
				GivePlayerCash(id, lmskills[id] * MONEY_PER_LMS_KILL);
				userinfo[id][lmswon] ++;
				inlms[id] = 0;
				inminigame[id] = 0;
				lmsstarted = 0;

				mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `LMS_won` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[id][lmswon], userinfo[id][pid]);
				mysql_tquery(Database, str);
			}
		}
	}

	foreach(new i : Player)
	{
		if(specid[i] == playerid && spec[i] == 1 && i != playerid)
		{
			GameTextForPlayer(i, "~b~waiting for player to ~n~~r~respawn...", 3000, 6);

			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);

		    new Float:cx, Float:cy, Float:cz;
			GetPlayerCameraPos(playerid, cx, cy, cz);

			cz += !GetPlayerInterior(playerid) ? 5.0 : 0.5;

			SetPlayerCameraPos(i, cx, cy, cz);
			SetPlayerCameraLookAt(i, x, y, z);
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	new param[12];
	format(param, sizeof(param), "/stats %d", clickedplayerid);
	return PC_EmulateCommand(playerid, param);
}

public OnPlayerEnterDynamicCP(playerid, STREAMER_TAG_CP checkpointid)
{
	if(IsPlayerInAnyVehicle(playerid) && checkpointid != PVEH[1]) return SendClientMessage(playerid, -1, "{ff0000}You are in a vehicle.");
	new str[1024];
	if(checkpointid == GANG_HOUSE[0])
	{
		if(GetPlayerTeam(playerid) ==  TEAM_GROVE)
		{
			SetPlayerVirtualWorld(playerid, userinfo[playerid][gid] + 1);
			SetPlayerInterior(playerid,3);
			SetPlayerPos(playerid,2496.049804,-1695.238159,1014.742187);
		}
	}
	else if(checkpointid == GANG_HOUSE[1])
	{
		if(GetPlayerTeam(playerid) ==  TEAM_BALLAS)
		{
			SetPlayerVirtualWorld(playerid, userinfo[playerid][gid] + 1);
			SetPlayerInterior(playerid,5);
			SetPlayerPos(playerid,318.564971,1118.209960,1083.882812);
		}
	}
	else if(checkpointid == GANG_HOUSE[2])
	{
		if(GetPlayerTeam(playerid) ==  TEAM_JUSTICE)
		{
			SetPlayerVirtualWorld(playerid, userinfo[playerid][gid] + 1);
			SetPlayerInterior(playerid,5);
			SetPlayerPos(playerid,321.8513,304.1907,999.1484);
		}
	}
	else if(checkpointid == GANG_HOUSE[3])
	{
		if(GetPlayerTeam(playerid) ==  TEAM_AZTECA)
		{
			SetPlayerVirtualWorld(playerid, userinfo[playerid][gid] + 1);
			SetPlayerInterior(playerid,12);
			SetPlayerPos(playerid,2324.419921,-1145.568359,1050.710083);
		}
	}
	else if(checkpointid == GANG_HOUSE[4])
	{
		if(GetPlayerTeam(playerid) ==  TEAM_MAFIA)
		{
			SetPlayerVirtualWorld(playerid, userinfo[playerid][gid] + 1);
			SetPlayerInterior(playerid,2);
			SetPlayerPos(playerid,2467.7971,-1698.0714,1013.5078);
		}

	}
	else if(checkpointid == GANG_HOUSE[5])
	{
		if(GetPlayerTeam(playerid) ==  TEAM_VAGOS)
		{
			SetPlayerVirtualWorld(playerid, userinfo[playerid][gid] + 1);
			SetPlayerInterior(playerid,5);
			SetPlayerPos(playerid,2350.339843,-1181.649902,1027.976562);
		}
	}
	else if(checkpointid == GANG_HOUSE[6])
	{
		if(GetPlayerTeam(playerid) ==  TEAM_VIP)
		{
			SetPlayerVirtualWorld(playerid, userinfo[playerid][gid] + 1);
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
		strcat(str, "{e9967a}ID\tType\n\n");
		strcat(str, "{ff0000}1 \t{ffffff}Cars\n");
		strcat(str, "{ff0000}2 \t{ffffff}Motor bikes\n");
		strcat(str, "{ff0000}3 \t{ffffff}Sell vehicle");
		Dialog_Show(playerid, DIALOG_VEH_PREVIEW, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Vehicle Shop", str, "Enter", "Close");
	}
	else if(checkpointid == PVEH[1])
	{
		if(userinfo[playerid][vowned] == 0) return SendClientMessage(playerid, -1, "{ff0000}You don't have a Personal Vehicle to access Tune Shop!");
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You should come with your Personal Vehicle!");
		if(vehowned[GetPlayerVehicleID(playerid)] == 0) return SendClientMessage(playerid, -1, "{ff0000}This is not your Personal Vehicle!");
		if(vehowner[GetPlayerVehicleID(playerid)] != playerid) return SendClientMessage(playerid, -1, "{ff0000}This is not your personal vehicle!");
		
        SetPlayerVirtualWorld(playerid, playerid + 1);
        TogglePlayerControllable(playerid, 0);
        SetPlayerInterior(playerid, 1);
        
        SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), playerid + 1);
        SetVehiclePos(priveh[playerid], 613.5759,-1.2345,1000.6935);
        SetVehicleZAngle(priveh[playerid], 270.4779);
        LinkVehicleToInterior(priveh[playerid], 1);

        intuneshop[playerid] = 1;
        men_row[playerid] = 0;
        ShowMenuForPlayer(tune_main, playerid);
        Tune_SetupMenuCamera(playerid);
        
        SendClientMessage(playerid, -1, "{eee8aa}Press {ffff00}\"W | Arrow UP\" {eee8aa}to go up in a menu and {ffff00}\"S | Arrow DOWN\" {eee8aa}to go down in a menu.");
        SendClientMessage(playerid, -1, "{eee8aa}Press {ffff00}\"SPACE\" {eee8aa}to purchase anything that you have selected.");
        SendClientMessage(playerid, -1, "{eee8aa}Press {ffff00}\"N\" {eee8aa}to switch to previous menu.");
        SendClientMessage(playerid, -1, "{eee8aa}Once you are done with modifying your vehicle you can use \"ENTER\" for leaving tune shop.");
	}

	for(new i = 0; i < sizeof(houseinfo); i++)
	{
		if(checkpointid == GENTERCP[i])
		{  
			if(userinfo[playerid][ingang]  == 1 && houseinfo[i][howned] == 1 && userinfo[playerid][gid] == houseinfo[i][hteamid])
			{
				SetPlayerVirtualWorld(playerid, userinfo[playerid][gid] + 1);
				SetPlayerPos(playerid, houseinfo[i][enterpos][0], houseinfo[i][enterpos][1], houseinfo[i][enterpos][2]);
				SetPlayerInterior(playerid, houseinfo[i][hintid]);
				SetPlayerFacingAngle(playerid, houseinfo[i][enterpos][3]);
				break;
			}
		}
	}

	for(new i = 0; i < sizeof(houseinfo); i++)
	{
		if(checkpointid == GEXITCP[i])
		{
			SetPlayerPos(playerid, houseinfo[i][exitpos][0], houseinfo[i][exitpos][1], houseinfo[i][exitpos][2]);
			SetPlayerInterior(playerid, 0);
			SetPlayerFacingAngle(playerid, houseinfo[i][exitpos][3]);
			SetPlayerVirtualWorld(playerid, 0);
			break;
		}
	}

	for(new i = 0; i < sizeof(shopinfo); i++)
	{
		if(checkpointid == SENTERCP[sizeof(shopinfo) -1] || checkpointid == SENTERCP[sizeof(shopinfo) -2] || checkpointid == SENTERCP[sizeof(shopinfo) -3] || checkpointid == SENTERCP[sizeof(shopinfo) -4])
		{
			return SendClientMessage(playerid, -1, "{ffffff}[ NOTICE ] {ff0000}24/7 shop is under construction! It will be open soon!!!");
		}
		if(checkpointid == SENTERCP[i])
		{ 
			SetPlayerInterior(playerid, shopinfo[i][sintid]);  
			SetPlayerVirtualWorld(playerid, (i + 1));
			SetPlayerPos(playerid, shopinfo[i][enterpos][0], shopinfo[i][enterpos][1], shopinfo[i][enterpos][2]);
			SetPlayerFacingAngle(playerid, shopinfo[i][enterpos][3]);   
			break;
		}
	}

	for(new i = 0; i < sizeof(shopinfo); i++)
	{
		if(checkpointid == SEXITCP[i])
		{
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, shopinfo[i][exitpos][0], shopinfo[i][exitpos][1], shopinfo[i][exitpos][2]);
			SetPlayerFacingAngle(playerid, shopinfo[i][exitpos][3]);
			break;
		}
	}

	for(new i = 0; i < sizeof(shopinfo); i++)
	{
		if(checkpointid == SBUYCP[i])
		{
			if( i == 0 || i == 1)
			{
				strcat(str, "{e9967a}ID\tWeapon       \tPrice\n\n");
				strcat(str, "{ff0000}1 \t{ffffff}Armour       \t$2000\n");
				strcat(str, "{ff0000}2 \t{ffffff}9mm          \t$100\n");
				strcat(str, "{ff0000}3 \t{ffffff}Silenced 9mm \t$120\n");
				strcat(str, "{ff0000}4 \t{ffffff}Desert Eagle \t$300\n");
				strcat(str, "{ff0000}5 \t{ffffff}Shotgun      \t$450\n");
				strcat(str, "{ff0000}6 \t{ffffff}Sawn-Off     \t$750\n");
				strcat(str, "{ff0000}7 \t{ffffff}Spass12      \t$800\n");
				strcat(str, "{ff0000}8 \t{ffffff}Uzi          \t$150\n");
				strcat(str, "{ff0000}9 \t{ffffff}AK47         \t$250\n");
				strcat(str, "{ff0000}10\t{ffffff}M4           \t$200\n");
				strcat(str, "{ff0000}11\t{ffffff}Tec-9        \t$150\n");
				strcat(str, "{ff0000}12\t{ffffff}Sniper Rifle \t$1200\n");
				strcat(str, "{ff0000}13\t{ffffff}Country Rifle\t$1300\n\n");
				strcat(str, "{ff0000}[ Note ] {ffffff}You cannot buy Sawn-Off and Armour\n");
				strcat(str, "         at one time");
				Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Ammu Nation", str, "Purchase", "Close");
			}
			else
			{
				strcat(str, "{e9967a}ID\tMeal         \tPrice\n\n");
				strcat(str, "{ff0000}1 \t{ffffff}Large        \t$750\n");
				strcat(str, "{ff0000}2 \t{ffffff}Hot & spicy  \t$400\n");
				strcat(str, "{ff0000}3 \t{ffffff}Jumbo chicken\t$150\n\n");
				strcat(str, "{ff0000}[ Note ] {ffffff}Large - Increase your health by 100%\n");
				strcat(str, "         Hot & spicy - Increase your health by 70%\n");
				strcat(str, "         Jumbo chicken - Increase your health by 50%\n");
				Dialog_Show(playerid, DIALOG_BUY_SHOP, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Restaurant", str, "purchase", "Close");
			}
		}
	}
	return 1;
}

#if DISCORD_SUPPORT == true
new HeyRandoms[][] = 
{
	"Hello, sunshine! How are you? Oh, your rays are already making my day brighter!",
	"Hey, howdy, hi! How is it going?",
	"What?Äôs kicking, little chicken?",
	"Howdy-doody! Tell me what?Äôs new!",
	"Hey there, freshman! Wassup?",
	"My name is Scarlett, and I am a bad, bad girl. I like you!",
	"Hi, mister! What is going on?",
	"I come in peace! Chow chow.",
	"Hello-hello! Who?Äôs there? It?Äôs me Scarlett talking.",
	"Hello! There is my pumpkin! I miiiissed you <3",
	"What?Äôs up with you, old soul? Wanna chat?",
	"Hello belle! You are glowing!",
	"Hey love!",
	"Hi, cutie pie, sugar bun!",
	"This is where my bae is at!",
	"Hi, butterfly! Holaaa!",
	"What?Äôs up, handsome? You are making the temperatures soar this season!"
};

new ByeRandoms[][] = 
{
	"See you later, alligator!",
	"Stay out of trouble.",
	"Okay...bye, fry guy!",
	"If I don?Äôt see you around, I'll see you square.",
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
			format(str, sizeof(str), "<@%s> It looks like you haven't typed it correctly :confused: (``[ USAGE ] /command``).", id);
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
				format(str, sizeof(str), "<@%s> You didn't type it correctly :woman_facepalming: (``[ USAGE ] /kick <id> <reason>``).", id);
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
																													
			if(userinfo[id][plevel] >= userinfo[playerid][plevel])
			{
				format(str, sizeof(str), "<@%s> Sorry mister!, player you are going to kick out is at the same level or a higher level than you :rolling_eyes:", id); 
				return DCC_SendChannelMessage(channel, str);
			}  
				
			format(str,sizeof(str), "<@%s>, Kicked that rat bastard as you orderd mister (Name: ``%s[%d]``| Reason: ``%s``)\nBut tbh I had a crush on him :sob:", id, PlayerName(id_), id_, reason);                
			DCC_SendChannelMessage(channel, str);

			format(str, sizeof(str), "* \"%s[%d]\" {FF8000}kicked from the server by a [DISCORD] Admin (%s).", PlayerName(id_), id_, reason);                               
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
					format(hmm, sizeof(hmm), "%d\t%s\n", i, userinfo[i][pname]);
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
				format(str, sizeof(str), "<@%s>, Thank you so much for trying to teach me :kissing_heart:, but your format is wrong (`[ USAGE ] /teach <message> <response>`).", id);
				DCC_SendChannelMessage(channel, str);
				DCC_SendChannelMessage(channel, "Don't forget to use `_` instead of `space`, if you didn't do that I'll get wrong things in my mind! :|");
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
			
			strreplace(id__, "_", "");
			DB_CreateRow(scarlett_table, "Message", id__);
			new val = DB_RetrieveKey(scarlett_table, "", 0, "Message", id__);
			strreplace(reason, "_", "");
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
					else if(k[4] != -1 || k[5] != -1 || k[6] != -1) format(str, sizeof(str), "<@%s>, Yeh! he is a nub! (Just like you xD).", id);
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
}
#endif

public OnPlayerDamage(&playerid, &Float:amount, &issuerid, &weapon, &bodypart)
{
	if(issuerid != INVALID_PLAYER_ID && playerid != INVALID_PLAYER_ID)
	{
        if(isequal(userinfo[playerid][pname], "GameOvr")) return 0;
		if(userinfo[playerid][onduty] == 1 || userinfo[playerid][jailed] == 1 || userinfo[issuerid][onduty] == 1 || (inminigame[playerid] && instunt[playerid])) return 0;
    }
	return 1;
}

public OnPlayerDamageDone(playerid, Float:amount, issuerid, weapon, bodypart)
{
	if(issuerid != INVALID_PLAYER_ID && playerid != INVALID_PLAYER_ID) 
	{
		if(GetPlayerTeam(playerid) != GetPlayerTeam(issuerid) || (GetPlayerTeam(playerid) == NO_TEAM))
        {
            PlayerPlaySound(issuerid,7802,0.0,0.0,0.0);
            last_shot[playerid] = gettime();
            //SendClientMessage(playerid, -1, "[debug] shot accepted");
        }

		if(bodypart == 9 && weapon == 34)
		{
			if(inminigame[playerid] == 0)
			{
				userinfo[issuerid][hshots] ++; 
				GameTextForPlayer(issuerid, "~r~Boom! ~g~Head shot", 3000, 5);
				SetPlayerHealth(playerid, 0);
				hshotid = issuerid;
				hshotgot = playerid;

				new str[70];
				mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Head_shots` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[issuerid][hshots], userinfo[issuerid][pid]);
				mysql_tquery(Database, str);
			}
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

		PlayerTextDrawHide(playerid, takeovertd_1[playerid][0]);
		PlayerTextDrawHide(playerid, takeovertd_1[playerid][1]);

		foreach(new i : Player)
		{
			if(specid[i] == playerid && spec[i])
			{
				PlayerSpectateVehicle(i, GetPlayerVehicleID(playerid));
			}
		}
	}
	else if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
	{
		PlayerTextDrawHide(playerid, vehtd_1[playerid]);
		foreach(new i : Player)
		{
			if(specid[i] == playerid && spec[i])
			{
				PlayerSpectatePlayer(i, playerid);
			}
		}
	}
	return 1;
}

Tune_SetupMenuRowValue(playerid, updown)
{
    new Menu:cur_menu = GetPlayerMenu(playerid);

    if(updown) 
    {
        men_row[playerid] --;
        if(cur_menu == tune_main && men_row[playerid] < 0) men_row[playerid] = 5;
        else if(cur_menu == tune_colors && men_row[playerid] < 0) return men_row[playerid] = 8;
        else if(cur_menu == tune_pjob && men_row[playerid] < 0) return men_row[playerid] = 3;
        else if(cur_menu == tune_hydra && men_row[playerid] < 0) return men_row[playerid] = 1;
        else if(cur_menu == tune_nitro && men_row[playerid] < 0) return men_row[playerid] = 3;
        else if(cur_menu == tune_neons && men_row[playerid] < 0) return men_row[playerid] = 2;
        else if(cur_menu == tune_wheels && men_row[playerid] < 0) return men_row[playerid] = 8;
    }
    else
    {
        men_row[playerid] ++;
        if(cur_menu == tune_main && men_row[playerid] > 5) return men_row[playerid] = 0;
        else if(cur_menu == tune_colors && men_row[playerid] > 8) return men_row[playerid] = 0;
        else if(cur_menu == tune_pjob && men_row[playerid] > 3) return men_row[playerid] = 0;
        else if(cur_menu == tune_hydra && men_row[playerid] > 1) return men_row[playerid] = 0;
        else if(cur_menu == tune_nitro && men_row[playerid] > 3) return men_row[playerid] = 0;
        else if(cur_menu == tune_neons && men_row[playerid] > 2) return men_row[playerid] = 0;
        else if(cur_menu == tune_wheels && men_row[playerid] > 8) return men_row[playerid] = 0;
    }
    return 1;
}

Tune_SetupMenuCamera(playerid)
{
    switch(men_row[playerid])
    {
        case 0: 
        {
            SetPlayerCameraPos(playerid, 610.505004, 3.504504, 1002.963500);
            SetPlayerCameraLookAt(playerid, 613.036804, -0.354658, 1001.040771);
        }
        case 1:
        {
            SetPlayerCameraPos(playerid, 610.505004, 3.504504, 1002.963500);
            SetPlayerCameraLookAt(playerid, 613.036804, -0.354658, 1001.040771);
        }
        case 2:
        {
            SetPlayerCameraPos(playerid, 616.914123, -5.129198, 1002.657958);
            SetPlayerCameraLookAt(playerid, 614.188598, -1.502126, 1000.556518);
        }
        case 3:
        {
            SetPlayerCameraPos(playerid, 609.386840, -1.224623, 1000.314880);
            SetPlayerCameraLookAt(playerid, 614.386779, -1.215295, 1000.290710);
        }
        case 4:
        {
            SetPlayerCameraPos(playerid, 608.743774, -1.269964, 1001.736816);
            SetPlayerCameraLookAt(playerid, 613.521484, -1.290513, 1000.262634);
        }
        case 5:
        {
            SetPlayerCameraPos(playerid, 615.927490, -3.281631, 1000.067321);
            SetPlayerCameraLookAt(playerid, 612.494934, 0.353870, 1000.094604);
        }
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
	else if(PRESSED(KEY_SECONDARY_ATTACK)) // 'enter, F'
	{
		if(inanim[playerid] == 1)
		{
			inanim[playerid] = 0;
			ClearAnimations(playerid);
		}

        if(intuneshop[playerid])
        { 
            intuneshop[playerid] = 0;
            HideMenuForPlayer(tune_main, playerid);
            HideMenuForPlayer(tune_pjob, playerid);
            HideMenuForPlayer(tune_colors, playerid);
            HideMenuForPlayer(tune_colors2, playerid);
            HideMenuForPlayer(tune_nitro, playerid);
            HideMenuForPlayer(tune_hydra, playerid);
            HideMenuForPlayer(tune_wheels, playerid);
            HideMenuForPlayer(tune_neons, playerid);

            SetPlayerVirtualWorld(playerid, 0);   
            SetPlayerInterior(playerid, 0);
            SetCameraBehindPlayer(playerid); 
            TogglePlayerControllable(playerid, 1);
            SetVehicleRealData(playerid);

            SetVehicleVirtualWorld(priveh[playerid], 0);
            SetVehiclePos(priveh[playerid], 1534.9286,-1471.9719,9.2723);
            SetVehicleZAngle(priveh[playerid], 0.7286);
            LinkVehicleToInterior(priveh[playerid], 0);
        }
	}
	else if(PRESSED(KEY_YES)) // 'Y'
	{
		for(new i = 0; i < 6; i++) PlayerTextDrawHide(playerid, statstd_1[playerid][i]);
		TextDrawHideForPlayer(playerid, statstd);
	}
    else if(PRESSED(KEY_NO))
    {
        if(GetPlayerMenu(playerid) != Menu:INVALID_MENU)
        { 
            men_row[playerid] = 0;
            ShowMenuForPlayer(Tune_GetPreviousMenu(playerid), playerid);
            if(GetPlayerMenu(playerid) == tune_main) Tune_SetupMenuCamera(playerid);
            SetVehicleRealData(playerid);
        }
    }
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(vehowned[vehicleid] == 1 && vehowner[vehicleid] != playerid && !ispassenger)
	{
		new str[128];
		format(str, sizeof(str), "~r~This is ~g~%s~r~'s~n~vehicle", userinfo[vehowner[vehicleid]][pname]);
		GameTextForPlayer(playerid, str, 3000, 3);
		PlayerPlaySound(playerid,1190,0.0,0.0,0.0);
		ClearAnimations(playerid);
	}
	/*else if(lockedv_id[0] == vehicleid || lockedv_id[1] == vehicleid || lockedv_id[2] == vehicleid || lockedv_id[3] == vehicleid || lockedv_id[4] == vehicleid || lockedv_id[5] == vehicleid || lockedv_id[6] == vehicleid)
	{
		GameTextForPlayer(playerid, "~r~You can't enter showroom ~n~vehicles", 3000, 3);
		PlayerPlaySound(playerid,1190,0.0,0.0,0.0);
		ClearAnimations(playerid);
	} */
	else if(gvehowned[vehicleid] == 1 && gvehid[vehicleid] != userinfo[playerid][gid])
	{
		new str[128];
		format(str, sizeof(str), "~r~This is the ~g~gang vehicle ~r~of ~n~~b~%s", ReplaceUwithS(ganginfo[userinfo[playerid][gid]][gname]));
		GameTextForPlayer(playerid, str, 3000, 3);
		PlayerPlaySound(playerid,1190,0.0,0.0,0.0);
		ClearAnimations(playerid);
	}
	else if(gvehowned[vehicleid] == 1 && gvehid[vehicleid] == userinfo[playerid][gid] && userinfo[playerid][glevel] < 2)
	{
		GameTextForPlayer(playerid, "~r~You should be at least a ~w~Warrior ~r~to drive ~g~~n~gang vehicle", 3000, 3);
		PlayerPlaySound(playerid,1190,0.0,0.0,0.0);
		ClearAnimations(playerid);
	}
	return 1;
}

/*public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z)
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
}*/

new last_cmd[MAX_PLAYERS];

public OnPlayerCommandReceived(playerid, cmd[], params[], flags) 
{
	if(!IsPlayerSpawned(playerid) || IsPlayerInClassSelection(playerid) || (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && !isequal(cmd, "sepc", true) && !isequal(cmd, "specoff", true))) return 0;
	else if(nocmd[playerid] == 1) 
	{
		SendClientMessage(playerid, -1, "{ff0000}You are not allowed to type any command at the moment!");
		return 0;
	}
	else if(time_edrink[playerid] != -1) 
	{
		SendClientMessage(playerid, -1, "{ff0000}Please wait you are using an energy drink!");
		return 0;
	}
	else if(time_band[playerid] != -1) 
	{
		SendClientMessage(playerid, -1, "{ff0000}Please wait you are using bandages!");
		return 0;
	}
    else if((gettime() - last_shot[playerid]) < 20 && !isequal(cmd, "t", true) && !isequal(cmd, "pm", true) && !isequal(cmd, "a1", true) && !isequal(cmd, "a2", true) && !isequal(cmd, "a3", true) && !isequal(cmd, "a4", true) && !isequal(cmd, "a5", true)) 
    {
        new ks[70];
        format(ks, sizeof(ks), "{ff0000}There are enemies around you! Please wait %i seconds.", last_shot[playerid] + 20 -gettime());
        SendClientMessage(playerid, -1, ks);
        return 0;
    }
    else if(gettime() - last_cmd[playerid] < 2  && !isequal(cmd, "t", true) && !isequal(cmd, "pm", true) && !isequal(cmd, "a1", true) && !isequal(cmd, "a2", true) && !isequal(cmd, "a3", true) && !isequal(cmd, "a4", true) && !isequal(cmd, "a5", true))
    {
    	SendClientMessage(playerid, -1, "{ff0000}Please wait before typing another command.");
    	return 0;
    }
    last_cmd[playerid] = gettime();
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{ 
	printf("( command ) /%s executed by \"%s\"", cmd, userinfo[playerid][pname]);
	WriteLog(LOG_COMMANDS, "Name: %s | Command: %s", userinfo[playerid][pname], cmd);

    //new str[128];
    //format(str, sizeof(str), "[ debug ] command - %s |  playerid - %i", cmd, playerid);
    //SendToAdmins(-1, str, 5);

    #if DISCORD_SUPPORT == true
    new str[128];
    #endif 

	if(result == -1)
	{ 
		SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
		SendClientMessage(playerid, -1, "{ff4500}Use {ffffff}'/cmds' {ff4500}to see available cmds.");
		
        #if DISCORD_SUPPORT == true
        format(str, sizeof(str), "**`@everyone` %s[%d] typed a non-existing command, maybe this is a cheat command! (``command: /%s``)**", userinfo[playerid][pname], playerid, cmd);
		DCC_SendChannelMessage(dcc_channel_commands, str);
		#endif
       
        return 0; 
	}     

    #if DISCORD_SUPPORT == true
	format(str, sizeof(str), "``%s[%d] executed /%s``", userinfo[playerid][pname], playerid, cmd);
	DCC_SendChannelMessage(dcc_channel_commands, str);
	#endif
    return 1; 
} 

public OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA areaid)
{
	new str[128], id = -1;
	for(new i = 0; i < sizeof(zoneinfo); i++)
	{
		if(areaid == DZONEID[i])
		{
			id = i; 
			break;
		}
	}
	
	if(id != -1)
	{
		if(GetPlayerInterior(playerid) == 0 && IsPlayerSpawned(playerid) && !IsPlayerInClassSelection(playerid) && GetPlayerVirtualWorld(playerid) == 0 && GetPlayerState(playerid) != PLAYER_STATE_WASTED)
		{
			TextDrawShowForPlayer(playerid, zonetd);
			PlayerTextDrawShow(playerid, zonetd_1[playerid][0]);
			PlayerTextDrawShow(playerid, zonetd_1[playerid][1]);
		
			format(str, sizeof(str),"~y~%s", zoneinfo[id][zname]);
			PlayerTextDrawSetString(playerid, zonetd_1[playerid][0], str);
		
			format(str, sizeof(str),"~w~turf_-_~r~%s", ganginfo[zoneinfo[id][zteamid]][gname]);
			PlayerTextDrawSetString(playerid, zonetd_1[playerid][1], str);
		
			SetTimerEx("HideZoneTD", 10000, false, "i", playerid);
		}
	}
	return 1;  
}

public OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA areaid)
{
	TextDrawHideForPlayer(playerid, zonetd);

	PlayerTextDrawHide(playerid, zonetd_1[playerid][0]);
	PlayerTextDrawHide(playerid, zonetd_1[playerid][1]);

	TextDrawHideForPlayer(playerid, takeovertd[0]);
	TextDrawHideForPlayer(playerid, takeovertd[1]);
	TextDrawHideForPlayer(playerid, takeovertd[2]);
	TextDrawHideForPlayer(playerid, takeovertd[3]);

	PlayerTextDrawHide(playerid, takeovertd_1[playerid][0]);
	PlayerTextDrawHide(playerid, takeovertd_1[playerid][1]);
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
			else return SendClientMessage(playerid, -1, "{ff0000}You can't pick armour again until you die!");
		}
	}

	for(new i = 0; i < 2; i++)
	{
		if(pickupid == hospick[i])
		{
			new str[512];
			strcat(str, "               {ffffff}Welcome to {ffff00}Los Santos              \n");
			strcat(str, "                     {ffffff}Hospital                     \n\n");
			strcat(str, "{32cd32}* {ffffff}Here you can refill your health for $1000\n");
			strcat(str, "{32cd32}* {ffffff}If you want to refill use \"Purchase\"\n");
			strcat(str, "{32cd32}* {ffffff}Use \"Close\" to dismiss\n\n");
			strcat(str, "{ff0000}[ Note ] {ffffff}You can refill your health only one time\n");
			strcat(str, "         for one spawn");
			Dialog_Show(playerid, DIALOG_REFILL_HP, DIALOG_STYLE_MSGBOX, "{ffa500}LGGW {ffffff}- Medical center", str, "Purchase", "Close");
		}
	}
	return 1;
}

new last_text[MAX_PLAYERS];
public OnPlayerText(playerid, text[])
{	
    if(!justconnected[playerid])
    {
    	if(userinfo[playerid][muted])
    	{
    		new str[128];
    		format(str, sizeof(str), "{ff0000}You can't talk while you are muted (Remaining time: {ffffff}%d {ff0000}seconds).", userinfo[playerid][mutetime]);
    		SendClientMessage(playerid, -1, str);
    	} 
    	else 
    	{ 
    		new str[150];
    		if(tickcount() - last_text[playerid] < 400) 
    		{
    			SendClientMessage(playerid, -1, "{ff0000}Oh! Cool down! You are typing way too faster!!!");
    			return 0;
    		}  

    		last_text[playerid] = tickcount();

            printf("( chat ) %s[%d]: %s", userinfo[playerid][pname], playerid, text);
            
    		if(stringContainsIP(text))
    		{
    			userinfo[playerid][muted] = 1;
    			userinfo[playerid][mutetime] = TIME_FOR_ADVERTISE_MUTE * 60;
    			userinfo[playerid][muted_admin] = -1;
    			format(userinfo[playerid][muted_reason], 80, "%s", "Advertising");

    			mysql_format(Database, str, sizeof(str), "UPDATE `User_Status` SET `Muted` = 1, `Muted_admin` = -1, `Muted_reason` = 'Advertising' WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][pid]);
   				mysql_tquery(Database, str);
    			
                format(str, sizeof(str), "{ff8000}* {ffffff}%s[%d] {ff8000}has been muted by the server for {ff0000}%d {ff8000}minutes (Advertising).", userinfo[playerid][pname], playerid, TIME_FOR_ADVERTISE_MUTE);
    			SendClientMessageToAll_(-1, str);

                printf("( rule breaking ) %s[%d] has been muted by the server (Advertising)", userinfo[playerid][pname], playerid);
                return 0;
    		}

            if(strfind(text, "/q") != -1) 
            { 
            	SendClientMessage(playerid, -1, "{ff0000}What??? don't tell our gang homies to leave LGGW <3");
            	return 0; 
            }

            if(text[0] == '!')
            {
                strdel(text, 0, 1);
                format(str, sizeof(str), "/t %s", text);
                PC_EmulateCommand(playerid, str);
                return 0;
            }
            
            if(userinfo[playerid][VIP]) format(str, sizeof(str), "{%06x}%s{e7e6a9} [%d]: {cc9999}%s", GetPlayerColor(playerid) >>> 8, userinfo[playerid][pname], playerid, text);
    		else format(str, sizeof(str), "{%06x}%s{e7e6a9} [%d]: {ffffff}%s", GetPlayerColor(playerid) >>> 8, userinfo[playerid][pname], playerid, text);
            
            foreach(new i : Player)
    		{
    			if(!justconnected[i])
    			{        
    				SendClientMessage(i, -1, str);
    			}
    		}

    		SetPlayerChatBubble(playerid, text, 0xB8860BAA, 20, 7000);
            
    		if(isequal(lastmsg[playerid], text, true))  
    		{
    			spamcount[playerid]++;

    			if(spamcount[playerid] == MIN_SPAM_COUNT)
    			{
    				userinfo[playerid][muted] = 1;
	    			userinfo[playerid][mutetime] = TIME_FOR_SPAM_MUTE * 60;
	    			userinfo[playerid][muted_admin] = -1;
	    			format(userinfo[playerid][muted_reason], 80, "%s", "Spam");

	    			mysql_format(Database, str, sizeof(str), "UPDATE `User_Status` SET `Muted` = 1, `Muted_admin` = -1, `Muted_reason` = 'Spam' WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][pid]);
	   				mysql_tquery(Database, str);
    				
                    format(str, sizeof(str), "{ff8000}* {ffffff}\"%s[%d]\" {ff8000}has been muted by the server for {ff0000}%d {ff8000}minutes (Spamming).", userinfo[playerid][pname], playerid, TIME_FOR_SPAM_MUTE);
    				SendClientMessageToAll_(-1, str);
    				
                    printf("( rule breaking ) %s[%d] has been muted by the server (Spam)", userinfo[playerid][pname], playerid);
    			}
    		}
    		else spamcount[playerid] = 1;

            #if DISCORD_SUPPORT == true
    		new h, m, s;
    		new y, mn, d;
    		
            getdate(y, mn, d);
    		gettime(h, m, s);
    		
            format(str, sizeof(str), "``[ %d:%d:%d | %d:%d:%d ] %s[%d]: %s``", y, mn, d, h, m, s, userinfo[playerid][pname], playerid, text);
    		DCC_SendChannelMessage(dcc_channel_chat, str);
            #endif

    		format(lastmsg[playerid], 128, "%s", text);
    	}
    }
	return 0;
}

DelayKick(playerid)
{
    SetTimerEx("Delay_Kick", 500, false, "i", playerid);
	return 1;
}

forward Delay_Kick(playerid);
public Delay_Kick(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    Kick(playerid);
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
	format(str, sizeof(str), "{eee8aa}Your duel request for {ff4500}\"%s[%i]\" {eee8aa}has been expired!", userinfo[id][pname]);
	SendClientMessage(playerid, -1, str);
	format(str, sizeof(str), "{eee8aa}Duel request by {ff4500}\"%s[%i]\" {eee8aa}has been expired!", userinfo[playerid][pname]);
	SendClientMessage(id, -1, str);
	return 1;
}

public StartLastManStanding()
{
	new count, str[128];
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
		SendClientMessageToAll_(-1, "{8000ff}Last Man Standing cancelled due to {ffffff}lack of participants.");
	}
	else    
	{
		lmsjustnow = 1;
		SendClientMessageToAll_(-1, "{8000ff}Last Man Standing started just now!!! Use {ffffff}'/spec' {8000ff}to watch it if u were too late to join.");
		new Rand = random(sizeof(LMSWeapons));
		foreach( new i : Player)
		{
			if(inlms[i] == 1)
			{
				userinfo[i][lmsplayed] ++;
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

				mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `LMS_played` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[i][lmsplayed], userinfo[i][pid]);
				mysql_tquery(Database, str);
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
			format(str, sizeof(str), "You have recieved ~y~$%d ~w~by your ~p~gang ~r~\"%s\" ~w~for controlling ~y~%d ~p~turfs ~w~over ~g~Los_Santos", MONEY_PER_TURF * ganginfo[userinfo[j][gid]][gturfs], ganginfo[userinfo[j][gid]][gname], ganginfo[userinfo[j][gid]][gturfs]);
			PlayerTextDrawShow(j, turfcashtd[j]);
			PlayerTextDrawSetString(j, turfcashtd[j], str);
			GivePlayerCash(j, MONEY_PER_TURF * ganginfo[userinfo[j][gid]][gturfs]);
		}
	}
	SetTimer("HideCashTD", 10000, false);
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

public TurfTimer()
{
	new tstr[128];
	for(new i = 0; i < sizeof(zoneinfo); i++) 
	{
		if(zoneinfo[i][ZoneAttacker] != -1) 
		{
			if(GetPlayersInZone(i, zoneinfo[i][ZoneAttacker]) >= MIN_PLAYERS_TO_START_TURF) // team has enough members in the zone
			{
				zoneinfo[i][ZoneAttackTime] ++;
				if(zoneinfo[i][ZoneAttackTime] == TIME_FOR_TURF) // zone has been under attack for enough time and attackers take over the zone
				{
					foreach(new j : Player)
					{
						if(GetPlayerTeam(j) == zoneinfo[i][ZoneAttacker] && IsPlayerInZone(j, i))
						{
							PlayerTextDrawHide(j, takeovertd_1[j][0]);
							PlayerTextDrawHide(j, takeovertd_1[j][1]);
							
							TextDrawHideForPlayer(j, takeovertd[0]);
							TextDrawHideForPlayer(j, takeovertd[1]);
							TextDrawHideForPlayer(j, takeovertd[2]);
							TextDrawHideForPlayer(j, takeovertd[3]);
						}
					}

					GangZoneStopFlashForAll(ZONEID[i]);
					GangZoneShowForAll(ZONEID[i], Zone_ColorAlpha(ganginfo[zoneinfo[i][ZoneAttacker]][gcolor])); // update the zone color for new team

					format(tstr, sizeof(tstr), "{%06x}%s {ffc0cb}won the turf war against {%06x}%s {ffc0cb}in {ff0000}%s{ffc0cb}.", ganginfo[zoneinfo[i][ZoneAttacker]][gcolor] >>> 8, ReplaceUwithS(ganginfo[zoneinfo[i][ZoneAttacker]][gname]), ganginfo[zoneinfo[i][zteamid]][gcolor] >>> 8, ReplaceUwithS(ganginfo[zoneinfo[i][zteamid]][gname]), ReplaceUwithS(zoneinfo[i][zname]));
					SendClientMessageToAll_(-1, tstr);

					ganginfo[zoneinfo[i][ZoneAttacker]][gscore] += GANG_SCORE_PER_TURF;
					ganginfo[zoneinfo[i][ZoneAttacker]][gturfs] ++;
					ganginfo[zoneinfo[i][zteamid]][gturfs] --;
					if(ganginfo[zoneinfo[i][zteamid]][gscore] > 20 ) ganginfo[zoneinfo[i][zteamid]][gscore] -= (GANG_SCORE_PER_TURF - 10);

					zoneinfo[i][zteamid] = zoneinfo[i][ZoneAttacker];

					mysql_format(Database, tstr, sizeof(tstr), "UPDATE `Gangs` SET `Turfs` = %d, `Score` = %d WHERE `Gang_ID` = %d LIMIT 1", ganginfo[zoneinfo[i][ZoneAttacker]][gturfs], ganginfo[zoneinfo[i][ZoneAttacker]][gscore], zoneinfo[i][ZoneAttacker] + 1);
					mysql_tquery(Database, tstr);

					mysql_format(Database, tstr, sizeof(tstr), "UPDATE `Zones` SET `Zone_owned_team_ID` = %d WHERE `Zone_ID` = %d LIMIT 1", zoneinfo[i][ZoneAttacker], i + 1);
					mysql_tquery(Database, tstr);

					zoneinfo[i][ZoneAttacker] = -1;   
				} 
			}
			else // attackers failed to take over the zone
			{
				GangZoneStopFlashForAll(ZONEID[i]);
				foreach(new j : Player)
				{
					if(GetPlayerTeam(j) == zoneinfo[i][ZoneAttacker] && IsPlayerInZone(j, i))
					{
						PlayerTextDrawHide(j, takeovertd_1[j][0]);
						PlayerTextDrawHide(j, takeovertd_1[j][1]);
						
						TextDrawHideForPlayer(j, takeovertd[0]);
						TextDrawHideForPlayer(j, takeovertd[1]);
						TextDrawHideForPlayer(j, takeovertd[2]);
						TextDrawHideForPlayer(j, takeovertd[3]);
					}
				}
				zoneinfo[i][ZoneAttacker] = -1;
			}
		}
		else // check if somebody is attacking
		{
			for(new t = 0; t < MAX_GANGS; t++) // loop all teams
			{
				if(t != zoneinfo[i][zteamid] && GetPlayersInZone(i, t) >= MIN_PLAYERS_TO_START_TURF)
				{
					zoneinfo[i][ZoneAttacker] = t;
					zoneinfo[i][ZoneAttackTime] = 0;
					GangZoneFlashForAll(ZONEID[i], Zone_ColorAlpha(ganginfo[zoneinfo[i][ZoneAttacker]][gcolor]));
					foreach(new k : Player)
					{
						if(GetPlayerTeam(k) == t && IsPlayerInZone(k, i)) 
						{
	       					format(tstr, sizeof(tstr), "~r~%s~n~~w~against~n~~b~%s", ganginfo[zoneinfo[i][ZoneAttacker]][gname], ganginfo[zoneinfo[i][zteamid]][gname]);
							PlayerTextDrawSetString(k, takeovertd_1[k][1], tstr);
	
							format(tstr, sizeof(tstr), "~y~%s", zoneinfo[i][zname]);
							PlayerTextDrawSetString(k, takeovertd_1[k][0], tstr);

							PlayerTextDrawShow(k, takeovertd_1[k][0]);
							PlayerTextDrawShow(k, takeovertd_1[k][1]);
	
							TextDrawShowForPlayer(k, takeovertd[0]);
							TextDrawShowForPlayer(k, takeovertd[1]);
							TextDrawShowForPlayer(k, takeovertd[2]);
							TextDrawShowForPlayer(k, takeovertd[3]);
						}
					}
				}
			}
		}
	}
	return 1;
}

public SecTimer_1()
{
	new tstr[128];
	foreach(new j : Player)
	{
		if(logged[j] == 1)
		{
			userinfo[j][ptime]++;

			SyncPlayerCash(j);

			if(userinfo[j][jailed] == 1 && !IsPlayerInClassSelection(j) && IsPlayerSpawned(j))
			{
				userinfo[j][jailtime] --;
				format(tstr, sizeof(tstr), "~g~Remaining Time: ~w~%d", userinfo[j][jailtime]);
				GameTextForPlayer(j, tstr, 1000, 5);
				ResetPlayerWeapons(j);
				if(userinfo[j][jailtime] == 0)
				{
					GameTextForPlayer(j, "~g~UNJAILED!", 5000, 5);
					userinfo[j][jailed] = 0;
					userinfo[j][jailtime] = 0;
					SpawnPlayer(j);

					mysql_format(Database, tstr, sizeof(tstr), "UPDATE `User_status` SET `Jailed` = 0 WHERE `User_ID` = %d LIMIT 1", userinfo[j][pid]);
					mysql_tquery(Database, tstr);
				}
			}
			if(userinfo[j][muted] == 1)
			{
				userinfo[j][mutetime] --;
				if(userinfo[j][mutetime] == 0)
				{
					userinfo[j][muted] = 0;
					SendClientMessage(j, -1, "{eee8aa}You have been {ff0000}unmuted{ffffff}! {eee8aa}Remember to mind your words!!!");
					
                    mysql_format(Database, tstr, sizeof(tstr), "UPDATE `User_status` SET `Muted` = 0 WHERE `User_ID` = %d LIMIT 1", userinfo[j][pid]);
					mysql_tquery(Database, tstr);
				}
			}

            if(spec[j])
            {
                if(GetPlayerVirtualWorld(j) != GetPlayerVirtualWorld(specid[j])) SetPlayerVirtualWorld(j, GetPlayerVirtualWorld(specid[j]));
                if(GetPlayerInterior(j) != GetPlayerInterior(specid[j])) SetPlayerInterior(j, GetPlayerInterior(specid[j]));
            }
		}

        if(GetPlayerPing(j) > 700)
        {
            format(tstr, sizeof(tstr), "{ffffff}%s[%i] {eee8aa}has been kicked by the system {ffffff}(High ping){eee8aa}.", userinfo[j][pname]);
            SendClientMessageToAll_(-1, tstr);
            Kick(j);
        }
        if(NetStats_PacketLossPercent(j) > 20)
        {
            format(tstr, sizeof(tstr), "{ffffff}%s[%i] {eee8aa}has been kicked by the system {ffffff}(High packet loss){eee8aa}.", userinfo[j][pname]);
            SendClientMessageToAll_(-1, tstr);
            Kick(j);
        }
	}

	switch(tdlvl)
	{
		case 0: TextDrawSetString(LGGW[3], "~w~]_~r~l~y~azergaming.net~w~_]");  
		case 1: TextDrawSetString(LGGW[3], "~w~]_~y~l~r~a~y~zergaming.net~w~_]");  
		case 2: TextDrawSetString(LGGW[3], "~w~]_~y~la~r~z~y~ergaming.net~w~_]");
		case 3: TextDrawSetString(LGGW[3], "~w~]_~y~laz~r~e~y~rgaming.net~w~_]");
		case 4: TextDrawSetString(LGGW[3], "~w~]_~y~laze~r~r~y~gaming.net~w~_]");
		case 5: TextDrawSetString(LGGW[3], "~w~]_~y~lazer~r~g~y~aming.net~w~_]");
		case 6: TextDrawSetString(LGGW[3], "~w~]_~y~lazerg~r~a~y~ming.net~w~_]");
		case 7: TextDrawSetString(LGGW[3], "~w~]_~y~lazerga~r~m~y~ing.net~w~_]");
		case 8: TextDrawSetString(LGGW[3], "~w~]_~y~lazergam~r~i~y~ng.net~w~_]");
		case 9: TextDrawSetString(LGGW[3], "~w~]_~y~lazergami~r~n~y~g.net~w~_]");
		case 10: TextDrawSetString(LGGW[3], "~w~]_~y~lazergamin~r~g~y~.net~w~_]");
		case 11: TextDrawSetString(LGGW[3], "~w~]_~y~lazergaming~r~.~y~net~w~_]");
		case 12: TextDrawSetString(LGGW[3], "~w~]_~y~lazergaming.~r~n~y~et~w~_]");
		case 13: TextDrawSetString(LGGW[3], "~w~]_~y~lazergaming.n~r~e~y~t~w~_]");
		case 14:
		{
			TextDrawSetString(LGGW[3], "~w~]_~y~lazergaming.ne~r~t~y~~w~_]");
			return tdlvl = 0;
		}
	}

	tdlvl ++;
	return 1;
}


public RobTimer()
{
	for(new i = 2, a = GetActorPoolSize(); i <= a; i++)
	{

		if(IsValidActor(i)) 
		{ 
			if(gettime() - shoprob_timestamp[i] >= TIME_FOR_ROB_REST * 60)
			{
				if(robber[i] != -1) // shop is under rob
				{
					if(GetPlayerTargetActor(robber[i]) == i && GetPlayerWeapon(robber[i]) != 0) 
					{
						robtime[i] += 0.5;
						SetPlayerProgressBarValue(robber[i], rbar[robber[i]], robtime[i]);
						switch(robgtv[robber[i]])
                        {
                            case 0: GameTextForPlayer(robber[i], "~r~Robbing", 1000, 1);
                            case 1: GameTextForPlayer(robber[i], "~r~Robbing.", 1000, 1); 
                            case 2: GameTextForPlayer(robber[i], "~r~Robbing..", 1000, 1);
                            case 3: GameTextForPlayer(robber[i], "~r~Robbing...", 1000, 1);
                            case 4: 
                            {
                                robgtv[robber[i]] = 0;
                                GameTextForPlayer(robber[i], "~r~Robbing", 1000, 1);
                            }
                        }

						robgtv[robber[i]] += 0.5;

						if(robtime[i] == TIME_FOR_ROB_END) // successfully robbed
						{
							new str[128];
							GameTextForPlayer(robber[i], " ", 100, 1);
							ClearActorAnimations(i); 
							HidePlayerProgressBar(robber[i], rbar[robber[i]]);
							userinfo[robber[i]][robbs] ++; 
                            new amount = 1000 + random(4001);
							GivePlayerCash(robber[i], amount);
							format(str, sizeof(str), "* {%06x}%s{ffffff}[%d] {ff8000}has robbed a {ffffff}%s {ff8000}shop in {ffffff}%s {ff8000}and got {ff0000}$%d", GetPlayerColor(robber[i]) >>> 8, userinfo[robber[i]][pname], robber[i], shopinfo[i][label], GetPlayerZone(robber[i]), amount);
							SendClientMessageToAll_(-1, str);
							robber[i] = -1;
                            shoprob_timestamp[i] = gettime();

							mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Robberies` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[robber[i]][robbs], userinfo[robber[i]][pid]);
							mysql_tquery(Database, str);
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
					if(GetPlayerTargetActor(j) == i) return SendClientMessage(j, -1, "{ff0000}The shop has been robbed before few minutes, No cash left with the cashier!");
				}
			}
		}
	}
	return 1;
}

public MinTimer_5() // 5 min timer
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

    allow_10min_timer ++;
	if(allow_10min_timer == 2) //10 min timer 
	{
        allow_10min_timer = 0;
        
		TextDrawDestroy(connecttd[2]);
	
		new str[30];
		new t = random(14);
		format(str, sizeof(str), "loadsc%d:loadsc%d", t + 1, t + 1);

		connecttd[2] = TextDrawCreate(0.000000, 0.000000, str);
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

        mysql_tquery(Database, "SELECT * FROM `User_Status` WHERE `Banned` = 1 AND `Unban_timestamp` != -1", "PrevBanCheck");
	}
	return 1;
}

forward PrevBanCheck();
public PrevBanCheck()
{
    new time, id, str[85];
    for(new i = 0; i < cache_num_rows(); i++)
    {
        cache_get_value_name_int(i, "Unban_timestamp", time);
        cache_get_value_name_int(i, "User_ID", id);
        if(time >= gettime())
        {
            mysql_format(Database, str, sizeof(str), "UPDATE `User_Status` SET `Banned` = 0 WHERE `User_ID` = %d LIMIT 1", id);  
            mysql_tquery(Database, str);
            mysql_format(Database, str, sizeof(str), "SELECT * FROM `User_IPs` WHERE `User_ID` = %d AND `IP` != '-1' LIMIT "#MAX_IP_SAVES"", id);  
            mysql_tquery(Database, str, "BanCheck", "d", id);
        }
    }
    return 1;
}

forward BanCheck();
public BanCheck()
{
    new ip[16];
    for(new i = 0; i < cache_num_rows(); i++)
    {
        cache_get_value_name(i, "IP", ip, sizeof(ip));
        RangeUnban(ip);
    }
    return 1;
}


public SecTimer_5()
{
	new rand = random(sizeof(ServerMessages));
	TextDrawSetString(LGGW[1], ServerMessages[rand]);
	//SendClientMessageToAll_(-1, "{8000ff}========================================================");
	//SendClientMessageToAll_(-1, "       {FF69B4}Join our forums at >>> {FFFFFF}https://lg-gw.ga ");
	//SendClientMessageToAll_(-1, "{8000ff}========================================================");

	foreach(new i : Player)
	{
		if(userinfo[i][vowned] == 1 && userinfo[i][vneon_1] == 1 && IsPlayerInAnyVehicle(i) && vehowner[GetPlayerVehicleID(i)] == i && vehowned[GetPlayerVehicleID(i)] == 1)
		{
			if(IsValidObject(vehneon[GetPlayerVehicleID(i)][0]) && IsValidObject(vehneon[GetPlayerVehicleID(i)][1]))
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
	}
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
		return SendClientMessageToAll_(-1, "{ff0000}Gun Game has ended without a winner!");
	}

	foreach(new i : Player)
	{
		if(ingg[i] == 1 && hl == gg_lvl[i] && hid != i)
		{
			return egg_timer = SetTimer("ExtraGunGameTime", 1000, true);
		}
	}

	new str[128];
	if(hl <= 20) format(str, sizeof(str), "{ffffff}\"%s\" {408080}won the GunGame with the level {ffffff}%d (Reward: {ffffff}$%d{408080}).", userinfo[hid][pname], hl, MONEY_PER_GUNGAME_LEVEL * hl);
	else format(str, sizeof(str), "{ffffff}\"%s\" {408080}won the GunGame with the level {ffffff}20{408080}(maximum level) (Reward: {ffffff}$%d{408080}).", userinfo[hid][pname], hl, MONEY_PER_GUNGAME_LEVEL * 20);
	SendClientMessageToAll_(-1, str);
	if(hl <= 20) GivePlayerCash(hid, MONEY_PER_GUNGAME_LEVEL * hl);
	else GivePlayerCash(hid, MONEY_PER_GUNGAME_LEVEL * 20);
	userinfo[hid][ggw] ++;
	
	mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `GunGames_won` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[hid][ggw], userinfo[hid][pid]);
	mysql_tquery(Database, str);

	foreach(new i : Player)
	{
		if(ingg[i] == 1 && inminigame[i])
		{
			ResetPlayerWeapons(i);
			SetPlayerDetails(i);
			ingg[i] = 0;
			inminigame[i] = 0;
			gg_started = 0;
			userinfo[i][ggp]++;
			mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `GunGames_played` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[i][ggp], userinfo[i][pid]);
			mysql_tquery(Database, str);
		}
	}
	return 1;
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
    if(IsPlayerInAnyVehicle(playerid))
    {
        if(gvehowned[GetPlayerVehicleID(playerid)]) ManageGangVehicleHealth(GetPlayerVehicleID(playerid));
    }
    
    if(inminigame[playerid] && instunt[playerid])
    {
        if(IsPlayerInAnyVehicle(playerid)) RepairVehicle(GetPlayerVehicleID(playerid));
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
		if(hl <= 20) format(str, sizeof(str), "{ffffff}\"%s\" {408080}won the GunGame with the level {ffffff}%d {408080}(Reward: {ffffff}$%d{408080}).", userinfo[hid][pname], hl, MONEY_PER_GUNGAME_LEVEL * hl);
		else format(str, sizeof(str), "{ffffff}\"%s\" {408080}won the GunGame with the level {ffffff}20{408080}(maximum level) (Reward: {ffffff}$%d{408080}).", userinfo[hid][pname], hl, MONEY_PER_GUNGAME_LEVEL * 20);
		SendClientMessageToAll_(-1, str);
		if(hl <= 20) GivePlayerCash(hid, MONEY_PER_GUNGAME_LEVEL * hl);
		else GivePlayerCash(hid, MONEY_PER_GUNGAME_LEVEL * 20);
		userinfo[hid][ggw] ++;

		mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `GunGames_won` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[hid][ggw], userinfo[hid][pid]);
		mysql_tquery(Database, str);

		foreach(new i : Player)
		{
			if(ingg[i] == 1 && inminigame[i])
			{
				ResetPlayerWeapons(i);
				SetPlayerDetails(i);
				ingg[i] = 0;
				gg_started = 0;
				userinfo[i][ggp]++;

				mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `GunGames_played` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[i][ggp], userinfo[i][pid]);
				mysql_tquery(Database, str);
			}
		}
		KillTimer(egg_timer);
	}
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
			SendClientMessage(playerid, -1, "{ff0000}Invalid input ID.");
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
				strcat(str, "* The next time you want to duel simply hit /duel <id> you have nothing to messup with\n", sizeof(str)); 
				strcat(str, "  weapons or arenas since its automatically saved.\n\n", sizeof(str)); 
				strcat(str, "* In case you want to change the the weapons or arenas you can use /duelsettings again.", sizeof(str));
				Dialog_Show(playerid, DIALOG_HELP_2, DIALOG_STYLE_MSGBOX, "{ffa500}LGGW {ffffff}- Help - How to be the top killer?", str, "Back", "Close");
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
				Dialog_Show(playerid, DIALOG_HELP_2, DIALOG_STYLE_MSGBOX, "{ffa500}LGGW {ffffff}- Help - How to be the richest?", str, "Back", "Close");
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
				Dialog_Show(playerid, DIALOG_HELP_2, DIALOG_STYLE_MSGBOX, "{ffa500}LGGW {ffffff}- Help - How can your gang rule Los Santos?", str, "Back", "Close");
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
				strcat(str, "* The first person kills a player from the last weapon level wins the event.\n\n", sizeof(str));
				strcat(str, "* Only admins can start the gun game while you can join it by using /gungame command.\n\n", sizeof(str));
				Dialog_Show(playerid, DIALOG_HELP_2, DIALOG_STYLE_MSGBOX, "{ffa500}LGGW {ffffff}- Help - How to deal with Minigames?", str, "Back", "Close");
			}
			case 5:
			{
				strcat(str, "* Personal vehicle is another cool system we have gathered to our server.\n\n", sizeof(str));
				strcat(str, "* The vehicle shop in Commerce(which is denoted by car sign on the map) provides you\n", sizeof(str)); 
				strcat(str, "  a variety of cars and bikes.\n\n", sizeof(str));
				strcat(str, "* What you have to do is buy the car or bike you want.\n\n", sizeof(str));
				strcat(str, "* Then use '/v to spawn it.\n", sizeof(str));
				strcat(str, "  The tune shop is next to the vehicle shop so you can modify(tune)\n", sizeof(str)); 
				strcat(str, "  your vehicle as you wish and be the knight rider of Los Santos ;).\n\n", sizeof(str)); 
				strcat(str, "* Nitrous will make you faster while wheels will increase your grip and controls.\n", sizeof(str)); 
				strcat(str, "  Neons and paints will make your vehicle cooler and cooler and Hydraulics is also there.", sizeof(str));
				Dialog_Show(playerid, DIALOG_HELP_2, DIALOG_STYLE_MSGBOX, "{ffa500}LGGW {ffffff}- Help - How to be the knightrider of Los Santos?", str, "Back", "Close");
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
		if(hospicked[playerid] == 1) 
		{
			SendClientMessage(playerid, -1, "{ff0000}You can't refill health again until you die!");
			return PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
		}
		if(GetPlayerCash(playerid) < MIN_CASH_TO_USE_HOSPITAL) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!");
		new str[128];
		format(str, sizeof(str), "{ff0000}\"%s[%i]\" {eee8aa}refilled health at LGGW medical center.", userinfo[playerid][pname], playerid);
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
			case 6: return PC_EmulateCommand(playerid, "/dm7");
			case 7: return PC_EmulateCommand(playerid, "/dm8");
			case 8: return PC_EmulateCommand(playerid, "/dm9");
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
		strcat(str, "{e9967a}ID\tWeapon       \tPrice\n\n");
		strcat(str, "{ff0000}1 \t{ffffff}Armour       \t$2000\n");
		strcat(str, "{ff0000}2 \t{ffffff}9mm          \t$100\n");
		strcat(str, "{ff0000}3 \t{ffffff}Silenced 9mm \t$120\n");
		strcat(str, "{ff0000}4 \t{ffffff}Desert Eagle \t$300\n");
		strcat(str, "{ff0000}5 \t{ffffff}Shotgun      \t$450\n");
		strcat(str, "{ff0000}6 \t{ffffff}Sawn-Off     \t$750\n");
		strcat(str, "{ff0000}7 \t{ffffff}Spass12      \t$800\n");
		strcat(str, "{ff0000}8 \t{ffffff}Uzi          \t$150\n");
		strcat(str, "{ff0000}9 \t{ffffff}AK47         \t$250\n");
		strcat(str, "{ff0000}10\t{ffffff}M4           \t$200\n");
		strcat(str, "{ff0000}11\t{ffffff}Tec-9        \t$150\n");
		strcat(str, "{ff0000}12\t{ffffff}Sniper Rifle \t$1200\n");
		strcat(str, "{ff0000}13\t{ffffff}Country Rifle\t$1300\n\n");
		strcat(str, "{ff0000}[ Note ] {ffffff}You cannot buy Sawn-Off and Armour\n");
		strcat(str, "         at one time");
		Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Ammu Nation", str, "Purchase", "Close");
		if(isequal(inputtext, "1"))
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Ammu Nation", str, "Purchase", "Close");
			if(SAWNBOUGHT[playerid] == 0)
			{
				if(GetPlayerCash(playerid) >= 2000) //armour
				{
					PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
					SetPlayerArmour(playerid, 100.0);
					GivePlayerCash(playerid, -2000);
					ARMOURBOUGHT[playerid] = 1;
				}
				else
				{
					PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
					SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy an {696969}armour{ff0000}!");
				}
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{ff0000}You cannot buy an {696969}armour {ff0000}while you have a {696969}Sawn-Off{ff0000}!");
			}
		}
		else if(isequal(inputtext, "2"))//9mm
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerCash(playerid) >= 100)
			{
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 22, 100);
				GivePlayerCash(playerid, -100);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy a {696969}9mm{ff0000}!");
			}
		}
		else if(isequal(inputtext, "3"))//silenced 9mm
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerCash(playerid) >= 120)
			{
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 23, 100);
				GivePlayerCash(playerid, -120);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy a {696969}Silenced 9mm{ff0000}!");
			}
		}
		else if(isequal(inputtext, "4"))//deagle
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerCash(playerid) >= 300)
			{
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 24, 80);
				GivePlayerCash(playerid, -300);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy a {696969}Desert Eagle{ff0000}!");
			}
		}
		else if(isequal(inputtext, "5"))//shotgun
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerCash(playerid) >= 450)
			{
				
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 25, 70);
				GivePlayerCash(playerid, -400);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy a {696969}Shotgun{ff0000}!");
			}
		}
		else if(isequal(inputtext, "6"))//sawn
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Ammu Nation", str, "Purchase", "Close");
			if(ARMOURBOUGHT[playerid] == 0)
			{
				if(GetPlayerCash(playerid) >= 750)
				{
					PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
					GivePlayerWeapon(playerid, 26, 60);
					GivePlayerCash(playerid, -750);
					SAWNBOUGHT[playerid] = 1;
				}
				else
				{
					PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
					SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy a {696969}Sawn-Off{ff0000}!");
				}
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{ff0000}You cannot buy a {696969}Sawn-Off {ff0000}while you have an {696969}Armour!");
			}
		}
		else if(isequal(inputtext, "7"))//spass
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerCash(playerid) >= 800)
			{
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 27, 60);
				GivePlayerCash(playerid, -800);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy a {696969}Spass12{ff0000}!");
			}
		}
		else if(isequal(inputtext, "8"))//uzi 150 28
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerCash(playerid) >= 150)
			{
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 28, 120);
				GivePlayerCash(playerid, -150);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy an {696969}Uzi/Micro SMG{ff0000}!");
			}
		}
		else if(isequal(inputtext, "9"))//ak47 250 30
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerCash(playerid) >= 250)
			{
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 30, 150);
				GivePlayerCash(playerid, -250);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy an {696969}ak-47{ff0000}!");
			}
		}
		else if(isequal(inputtext, "10"))//m4 200 31
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerCash(playerid) >= 200)
			{
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 31, 150);
				GivePlayerCash(playerid, -200);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy a {696969}M4{ff0000}!");
			}
		}
		else if(isequal(inputtext, "11"))//tec9 150 32
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerCash(playerid) >= 150)
			{
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 32, 120);
				GivePlayerCash(playerid, -150);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy a {696969}Tec-9{ff0000}!");
			}
		}
		else if(isequal(inputtext, "12"))//sr 1200 34
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerCash(playerid) >= 1200)
			{
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 34, 20);
				GivePlayerCash(playerid, -1200);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy a {696969}Sniper Rifle{ff0000}!");
			}
		}
		else if(isequal(inputtext, "13"))//cr 1300 33
		{
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Ammu Nation", str, "Purchase", "Close");
			if(GetPlayerCash(playerid) >= 1300)
			{
				PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
				GivePlayerWeapon(playerid, 33, 30);
				GivePlayerCash(playerid, -1300);
			}
			else
			{
				PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy a {696969}Country Rifle{ff0000}!");
			}
		}
		else
		{
			PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
			Dialog_Show(playerid, DIALOG_AMMU, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Ammu Nation", str, "Purchase", "Close");
			SendClientMessage(playerid, -1, "{ff0000}Invalid selection.");
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
			case 0: Dialog_Show(playerid, DIALOG_DUEL_PLACE, DIALOG_STYLE_LIST, "{ffa500}LGGW {ffffff}- Duel Settings - Duel place", "LV Stadium\nWarehouse\nRC Battlefield\nBloodbowl", "Select", "");
			case 1: Dialog_Show(playerid, DIALOG_DUEL_WEAPONS_1, DIALOG_STYLE_LIST, "{ffa500}LGGW {ffffff}- Duel Settings - Weapon 1", "Brass Knuckles\nKnife\nBaseball Bat\nChain Saw\nPurple Dildo\nGrenade\n9mm\nSilenced 9mm\nDesert Eagle\nShotgun\nSawn-Off Shotgun\nCombat Shotgun\nUzi\nAk-47\nSniper Rifle\nMinigun", "Select", "");
			case 2: Dialog_Show(playerid, DIALOG_DUEL_WEAPONS_2, DIALOG_STYLE_LIST, "{ffa500}LGGW {ffffff}- Duel Settings - Weapon 2", "None\nBrass Knuckles\nKnife\nBaseball Bat\nChain Saw\nPurple Dildo\nGrenade\n9mm\nSilenced 9mm\nDesert Eagle\nShotgun\nSawn-Off Shotgun\nCombat Shotgun\nUzi\nAk-47\nSniper Rifle\nMinigun", "Select", "");
			case 3: Dialog_Show(playerid, DIALOG_DUEL_WEAPONS_3, DIALOG_STYLE_LIST, "{ffa500}LGGW {ffffff}- Duel Settings - Weapon 3", "None\nBrass Knuckles\nKnife\nBaseball Bat\nChain Saw\nPurple Dildo\nGrenade\n9mm\nSilenced 9mm\nDesert Eagle\nShotgun\nSawn-Off Shotgun\nCombat Shotgun\nUzi\nAk-47\nSniper Rifle\nMinigun", "Select", "");
			case 4: Dialog_Show(playerid, DIALOG_DUEL_BET, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Duel Settings - Duel bet", "{ffffff}Insert a value to bet with the player\nwho you are dueling\n\nInsert a valaue between {adff2f}$5 - $5000", "Enter", "");
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
		Dialog_Show(playerid, DIALOG_DUEL_PREVIEW, DIALOG_STYLE_LIST, "{ffa500}LGGW {ffffff}- Duel Settings", "Place\nWeapon - 1\nWeapon - 2\nWeapon - 3\nBet", "Select", "Close");
		switch(listitem)
		{
			case 0: userinfo[playerid][dplace] = 0;
			case 1: userinfo[playerid][dplace] = 1;
			case 2: userinfo[playerid][dplace] = 2;
			case 3: userinfo[playerid][dplace] = 3;
		}
		format(str, sizeof(str), "{7cfc00}Duel settings updated! (Place: {ffffff}%s{7cfc00}).", GetDuelPlaceName(userinfo[playerid][dplace]));
		SendClientMessage(playerid, -1, str);

		mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Duel_place_ID` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][dplace], userinfo[playerid][pid]);
		mysql_tquery(Database, str);
	}
}

Dialog:DIALOG_DUEL_WEAPONS_1(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new str[128];
		Dialog_Show(playerid, DIALOG_DUEL_PREVIEW, DIALOG_STYLE_LIST, "{ffa500}LGGW {ffffff}- Duel Settings", "Place\nWeapon - 1\nWeapon - 2\nWeapon - 3\nBet", "Select", "Close");
		switch(listitem)
		{
			case 0: userinfo[playerid][dwep1] = 1;
			case 1: userinfo[playerid][dwep1] = 4;
			case 2: userinfo[playerid][dwep1] = 5;
			case 3: userinfo[playerid][dwep1] = 9;
			case 4: userinfo[playerid][dwep1] = 10;
			case 5: userinfo[playerid][dwep1] = 16;
			case 6: userinfo[playerid][dwep1] = 22;
			case 7: userinfo[playerid][dwep1] = 23;
			case 8: userinfo[playerid][dwep1] = 24;
			case 9: userinfo[playerid][dwep1] = 25;
			case 10: userinfo[playerid][dwep1] = 26;
			case 11: userinfo[playerid][dwep1] = 27;
			case 12: userinfo[playerid][dwep1] = 28;
			case 13: userinfo[playerid][dwep1] = 30;
			case 14: userinfo[playerid][dwep1] = 34;
			case 15: userinfo[playerid][dwep1] = 38;
		}
		format(str, sizeof(str), "{7cfc00}Duel settings updated! (Weapon 1: {ffffff}%s{7cfc00}).", GunName(userinfo[playerid][dwep1]));
		SendClientMessage(playerid, -1, str);

		mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Duel_weapon_1` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][dwep1], userinfo[playerid][pid]);
		mysql_tquery(Database, str);
	}
}

Dialog:DIALOG_DUEL_WEAPONS_2(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new str[128];
		Dialog_Show(playerid, DIALOG_DUEL_PREVIEW, DIALOG_STYLE_LIST, "{ffa500}LGGW {ffffff}- Duel Settings", "Place\nWeapon - 1\nWeapon - 2\nWeapon - 3\nBet", "Select", "Close");
		switch(listitem)
		{
			case 0: userinfo[playerid][dwep2] = 0;
			case 1: userinfo[playerid][dwep2] = 1;
			case 2: userinfo[playerid][dwep2] = 4;
			case 3: userinfo[playerid][dwep2] = 5;
			case 4: userinfo[playerid][dwep2] = 9;
			case 5: userinfo[playerid][dwep2] = 10;
			case 6: userinfo[playerid][dwep2] = 16;
			case 7: userinfo[playerid][dwep2] = 22;
			case 8: userinfo[playerid][dwep2] = 23;
			case 9: userinfo[playerid][dwep2] = 24;
			case 10: userinfo[playerid][dwep2] = 25;
			case 11: userinfo[playerid][dwep2] = 26;
			case 12: userinfo[playerid][dwep2] = 27;
			case 13: userinfo[playerid][dwep2] = 28;
			case 14: userinfo[playerid][dwep2] = 30;
			case 15: userinfo[playerid][dwep2] = 34;
			case 16: userinfo[playerid][dwep2] = 38;
		}
		format(str, sizeof(str), "{7cfc00}Duel settings updated! (Weapon 2: {ffffff}%s{7cfc00}).", GunName(userinfo[playerid][dwep2]));
		SendClientMessage(playerid, -1, str);

		mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Duel_weapon_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][dwep2], userinfo[playerid][pid]);
		mysql_tquery(Database, str);
	}
}

Dialog:DIALOG_DUEL_WEAPONS_3(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new str[128];
		Dialog_Show(playerid, DIALOG_DUEL_PREVIEW, DIALOG_STYLE_LIST, "{ffa500}LGGW {ffffff}- Duel Settings", "Place\nWeapon - 1\nWeapon - 2\nWeapon - 3\nBet", "Select", "Close");
		switch(listitem)
		{
			case 0: userinfo[playerid][dwep3] = 0;
			case 1: userinfo[playerid][dwep3] = 1;
			case 2: userinfo[playerid][dwep3] = 4;
			case 3: userinfo[playerid][dwep3] = 5;
			case 4: userinfo[playerid][dwep3] = 9;
			case 5: userinfo[playerid][dwep3] = 10;
			case 6: userinfo[playerid][dwep3] = 16;
			case 7: userinfo[playerid][dwep3] = 22;
			case 8: userinfo[playerid][dwep3] = 23;
			case 9: userinfo[playerid][dwep3] = 24;
			case 10: userinfo[playerid][dwep3] = 25;
			case 11: userinfo[playerid][dwep3] = 26;
			case 12: userinfo[playerid][dwep3] = 27;
			case 13: userinfo[playerid][dwep3] = 28;
			case 14: userinfo[playerid][dwep3] = 30;
			case 15: userinfo[playerid][dwep3] = 34;
			case 16: userinfo[playerid][dwep3] = 38;
		}

		format(str, sizeof(str), "{7cfc00}Duel settings updated! (Weapon 3: {ffffff}%s{7cfc00}).", GunName(userinfo[playerid][dwep3]));
		SendClientMessage(playerid, -1, str);

		mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Duel_weapon_3` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][dwep3], userinfo[playerid][pid]);
		mysql_tquery(Database, str);
	}
}

Dialog:DIALOG_DUEL_BET(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new str[128];
		if(strval(inputtext) > 5000 || strval(inputtext) < 5)
		{
			SendClientMessage(playerid, -1, "{ff0000}Your bet value must be in between $5 - $5000.");
			Dialog_Show(playerid, DIALOG_DUEL_BET, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Duel Settings", "{ffffff}Insert a value to bet with the player\nwho you are dueling\n\nInsert a value between {adff2f}$5 - $5000", "Enter", "");
		}
		else
		{
			userinfo[playerid][dbet] = strval(inputtext);
			Dialog_Show(playerid, DIALOG_DUEL_PREVIEW, DIALOG_STYLE_LIST, "{ffa500}LGGW {ffffff}- Duel Settings", "Place\nWeapon - 1\nWeapon - 2\nWeapon - 3\nBet", "Select", "Close");
			format(str, sizeof(str), "{7cfc00}Duel settings updated! (Duel bet: {ffffff}$%d{7cfc00}).", userinfo[playerid][dbet]);
			SendClientMessage(playerid, -1, str);

			mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Duel_bet` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][dbet], userinfo[playerid][pid]);
			mysql_tquery(Database, str);
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
			strcat(str, "{e9967a}ID\tType\n\n");
			strcat(str, "{ff0000}1 \t{ffffff}Cars\n");
			strcat(str, "{ff0000}2 \t{ffffff}Motor bikes\n");
			strcat(str, "{ff0000}3 \t{ffffff}Sell vehicle");
			SendClientMessage(playerid, -1, "{ff0000}Invalid selection.");
			Dialog_Show(playerid, DIALOG_VEH_PREVIEW, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Vehicle Shop", str, "Enter", "Close");
		}
		else if(isequal("1", inputtext))
		{
			strcat(str, "{e9967a}ID\tCar      \tPrice\n\n");
			strcat(str, "{ff0000}1 \t{ffffff}Sabre    \t$100000\n");
			strcat(str, "{ff0000}2 \t{ffffff}Savanna  \t$120000\n");
			strcat(str, "{ff0000}3 \t{ffffff}Remington\t$150000\n");
			strcat(str, "{ff0000}4 \t{ffffff}Buffalo  \t$170000\n");
			strcat(str, "{ff0000}5 \t{ffffff}Uranus   \t$180000\n");
			strcat(str, "{ff0000}6 \t{ffffff}Elegy    \t$210000\n");
			strcat(str, "{ff0000}7 \t{ffffff}Sultan   \t$240000\n");
			strcat(str, "{ff0000}8 \t{ffffff}Super GT \t$270000\n");
			strcat(str, "{ff0000}9 \t{ffffff}Cheetah  \t$290000\n");
			strcat(str, "{ff0000}10\t{ffffff}Bullet   \t$310000");
			Dialog_Show(playerid, DIALOG_VEH_CAR, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Vehicle Shop", str, "Purchase", "Close");
		}
		else if(isequal("2", inputtext))
		{
			strcat(str, "{e9967a}ID\tBike   \tPrice\n\n");
			strcat(str, "{ff0000}1 \t{ffffff}Quad   \t$30000\n");
			strcat(str, "{ff0000}2 \t{ffffff}Faggio \t$40000\n");
			strcat(str, "{ff0000}3 \t{ffffff}Freeway\t$60000\n");
			strcat(str, "{ff0000}4 \t{ffffff}Sanchez\t$70000\n");
			strcat(str, "{ff0000}5 \t{ffffff}PCJ-600\t$90000\n");
			strcat(str, "{ff0000}6 \t{ffffff}BF-400 \t$90000\n");
			strcat(str, "{ff0000}7 \t{ffffff}FCR-900\t$100000");
			Dialog_Show(playerid, DIALOG_VEH_BIKE, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Vehicle Shop ", str, "Purchase", "Close");
		}
		else if(isequal("3", inputtext))
		{
			Dialog_Show(playerid, DIALOG_VEH_SELL, DIALOG_STYLE_MSGBOX, "{ffa500}LGGW {ffffff}- Vehicle Shop ", "Are you sure that you want\nto sell your vehicle\n\n[ Important ]This action is irreversable\n\n[ Note ]You will recieve only half\nof the price of your\nvehicle", "Sell", "Close");
		}
		else
		{
			SendClientMessage(playerid, -1, "{ff0000}Invalid selection.");
			Dialog_Show(playerid, DIALOG_VEH_PREVIEW, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Vehicle Shop", "ID\tType\n\n1\tCars\n2\tMotor bikes\n3\tSell vehicle", "Enter", "Close");
		}
	}
	return 1;
}

Dialog:DIALOG_VEH_CAR(playerid, response, listitem, inputtext[])
{
	if(!response) Dialog_Close(playerid);
	if(response)
	{
		new str[520];
		strcat(str, "{e9967a}ID\tCar      \tPrice\n\n");
		strcat(str, "{ff0000}1 \t{ffffff}Sabre    \t$100000\n");
		strcat(str, "{ff0000}2 \t{ffffff}Savanna  \t$120000\n");
		strcat(str, "{ff0000}3 \t{ffffff}Remington\t$150000\n");
		strcat(str, "{ff0000}4 \t{ffffff}Buffalo  \t$170000\n");
		strcat(str, "{ff0000}5 \t{ffffff}Uranus   \t$180000\n");
		strcat(str, "{ff0000}6 \t{ffffff}Elegy    \t$210000\n");
		strcat(str, "{ff0000}7 \t{ffffff}Sultan   \t$240000\n");
		strcat(str, "{ff0000}8 \t{ffffff}Super GT \t$270000\n");
		strcat(str, "{ff0000}9 \t{ffffff}Cheetah  \t$290000\n");
		strcat(str, "{ff0000}10\t{ffffff}Bullet   \t$310000");
		if(isempty(inputtext))
		{
			SendClientMessage(playerid, -1, "{ff0000}Invalid selection.");
			return Dialog_Show(playerid, DIALOG_VEH_CAR, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Vehicle Shop", str, "Purchase", "Close");
		}
		else if(isequal("1", inputtext))
		{
			if(userinfo[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{ff0000}You already own a personal vehicle.");
			if(GetPlayerCash(playerid) < 100000) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to purchase this vehicle.");
			SendClientMessage(playerid, -1, "{eee8aa}You have purchased a {ff0000}\"Sabre\"{eee8aa}, Use '/v to spawn it.");
			SendClientMessage(playerid, -1, "{eee8aa}You can {ff0000}upgrade {eee8aa}your vehicle by {ffffff}Tune shop.");
			GivePlayerCash(playerid, -100000);
			userinfo[playerid][vowned] = 1;
			userinfo[playerid][vmodel] = 475;
			userinfo[playerid][vcolor_1] = 51;
			userinfo[playerid][vcolor_2] = 51;
			userinfo[playerid][vnitro] = -1;
			userinfo[playerid][vneon_1] = 0;
			userinfo[playerid][vneon_2] = 0;
			userinfo[playerid][vpjob] = 3;
			userinfo[playerid][vwheel] = 1077;
			userinfo[playerid][vhydra] = 0;

			mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_owned` = %d, `Vehicle_model` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vowned], userinfo[playerid][vmodel], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
			mysql_tquery(Database, str);
		}
		else if(isequal("2", inputtext))
		{
			if(userinfo[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{ff0000}You already own a personal vehicle.");
			if(GetPlayerCash(playerid) < 120000) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to purchase this vehicle.");
			SendClientMessage(playerid, -1, "{eee8aa}You have purchased a {ff0000}\"Savana\"{eee8aa}, Use '/v to spawn it.");
			SendClientMessage(playerid, -1, "{eee8aa}You can {ff0000}upgrade {eee8aa}your vehicle by {ffffff}Tune shop.");
			GivePlayerCash(playerid, -120000);
			userinfo[playerid][vowned] = 1;
			userinfo[playerid][vmodel] = 567;
			userinfo[playerid][vcolor_1] = 51;
			userinfo[playerid][vcolor_2] = 51;
			userinfo[playerid][vnitro] = -1;
			userinfo[playerid][vneon_1] = 0;
			userinfo[playerid][vneon_2] = 0;
			userinfo[playerid][vpjob] = 3;
			userinfo[playerid][vwheel] = 1077;
			userinfo[playerid][vhydra] = 0;

			mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_owned` = %d, `Vehicle_model` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vowned], userinfo[playerid][vmodel], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
			mysql_tquery(Database, str);
		}
		else if(isequal("3", inputtext))
		{
			if(userinfo[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{ff0000}You already own a personal vehicle.");
			if(GetPlayerCash(playerid) < 150000) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to purchase this vehicle.");
			SendClientMessage(playerid, -1, "{eee8aa}You have purchased a {ff0000}\"Remington\"{eee8aa}, Use '/v to spawn it.");
			SendClientMessage(playerid, -1, "{eee8aa}You can {ff0000}upgrade {eee8aa}your vehicle by {ffffff}Tune shop.");
			GivePlayerCash(playerid, -150000);
			userinfo[playerid][vowned] = 1;
			userinfo[playerid][vmodel] = 534;
			userinfo[playerid][vcolor_1] = 51;
			userinfo[playerid][vcolor_2] = 51;
			userinfo[playerid][vnitro] = -1;
			userinfo[playerid][vneon_1] = 0;
			userinfo[playerid][vneon_2] = 0;
			userinfo[playerid][vpjob] = 3;
			userinfo[playerid][vwheel] = 1077;
			userinfo[playerid][vhydra] = 0;

			mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_owned` = %d, `Vehicle_model` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vowned], userinfo[playerid][vmodel], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
			mysql_tquery(Database, str);
		}
		else if(isequal("4", inputtext))
		{
			if(userinfo[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{ff0000}You already own a personal vehicle.");
			if(GetPlayerCash(playerid) < 170000) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to purchase this vehicle.");
			SendClientMessage(playerid, -1, "{eee8aa}You have purchased a {ff0000}\"Buffalo\"{eee8aa}, Use '/v to spawn it.");
			SendClientMessage(playerid, -1, "{eee8aa}You can {ff0000}upgrade {eee8aa}your vehicle by {ffffff}Tune shop.");
			GivePlayerCash(playerid, -170000);
			userinfo[playerid][vowned] = 1;
			userinfo[playerid][vmodel] = 402;
			userinfo[playerid][vcolor_1] = 51;
			userinfo[playerid][vcolor_2] = 51;
			userinfo[playerid][vnitro] = -1;
			userinfo[playerid][vneon_1] = 0;
			userinfo[playerid][vneon_2] = 0;
			userinfo[playerid][vpjob] = 3;
			userinfo[playerid][vwheel] = 1077;
			userinfo[playerid][vhydra] = 0;

			mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_owned` = %d, `Vehicle_model` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vowned], userinfo[playerid][vmodel], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
			mysql_tquery(Database, str);
		}
		else if(isequal("5", inputtext))
		{
			if(userinfo[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{ff0000}You already own a personal vehicle.");
			if(GetPlayerCash(playerid) < 180000) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to purchase this vehicle.");
			SendClientMessage(playerid, -1, "{eee8aa}You have purchased a {ff0000}\"Uranus\"{eee8aa}, Use '/v to spawn it.");
			SendClientMessage(playerid, -1, "{eee8aa}You can {ff0000}upgrade {eee8aa}your vehicle by {ffffff}Tune shop.");
			GivePlayerCash(playerid, -180000);
			userinfo[playerid][vowned] = 1;
			userinfo[playerid][vmodel] = 558;
			userinfo[playerid][vcolor_1] = 51;
			userinfo[playerid][vcolor_2] = 51;
			userinfo[playerid][vnitro] = -1;
			userinfo[playerid][vneon_1] = 0;
			userinfo[playerid][vneon_2] = 0;
			userinfo[playerid][vpjob] = 3;
			userinfo[playerid][vwheel] = 1077;
			userinfo[playerid][vhydra] = 0;

			mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_owned` = %d, `Vehicle_model` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vowned], userinfo[playerid][vmodel], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
			mysql_tquery(Database, str);
		}
		else if(isequal("6", inputtext))
		{
			if(userinfo[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{ff0000}You already own a personal vehicle.");
			if(GetPlayerCash(playerid) < 210000) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to purchase this vehicle.");
			SendClientMessage(playerid, -1, "{eee8aa}You have purchased a {ff0000}\"Elegy\"{eee8aa}, Use '/v to spawn it.");
			SendClientMessage(playerid, -1, "{eee8aa}You can {ff0000}upgrade {eee8aa}your vehicle by {ffffff}Tune shop.");
			GivePlayerCash(playerid, -210000);
			userinfo[playerid][vowned] = 1;
			userinfo[playerid][vmodel] = 562;
			userinfo[playerid][vcolor_1] = 51;
			userinfo[playerid][vcolor_2] = 51;
			userinfo[playerid][vnitro] = -1;
			userinfo[playerid][vneon_1] = 0;
			userinfo[playerid][vneon_2] = 0;
			userinfo[playerid][vpjob] = 3;
			userinfo[playerid][vwheel] = 1077;
			userinfo[playerid][vhydra] = 0;

			mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_owned` = %d, `Vehicle_model` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vowned], userinfo[playerid][vmodel], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
			mysql_tquery(Database, str);
		}
		else if(isequal("7", inputtext))
		{
			if(userinfo[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{ff0000}You already own a personal vehicle.");
			if(GetPlayerCash(playerid) < 240000) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to purchase this vehicle.");
			SendClientMessage(playerid, -1, "{eee8aa}You have purchased a {ff0000}\"Sultan\"{eee8aa}, Use '/v to spawn it.");
			SendClientMessage(playerid, -1, "{eee8aa}You can {ff0000}upgrade {eee8aa}your vehicle by {ffffff}Tune shop.");
			GivePlayerCash(playerid, -240000);
			userinfo[playerid][vowned] = 1;
			userinfo[playerid][vmodel] = 560;
			userinfo[playerid][vcolor_1] = 51;
			userinfo[playerid][vcolor_2] = 51;
			userinfo[playerid][vnitro] = -1;
			userinfo[playerid][vneon_1] = 0;
			userinfo[playerid][vneon_2] = 0;
			userinfo[playerid][vpjob] = 3;
			userinfo[playerid][vwheel] = 1077;
			userinfo[playerid][vhydra] = 0;

			mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_owned` = %d, `Vehicle_model` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vowned], userinfo[playerid][vmodel], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
			mysql_tquery(Database, str);
		}
		else if(isequal("8", inputtext))
		{
			if(userinfo[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{ff0000}You already own a personal vehicle.");
			if(GetPlayerCash(playerid) < 270000) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to purchase this vehicle.");
			SendClientMessage(playerid, -1, "{eee8aa}You have purchased a {ff0000}\"Super GT\"{eee8aa}, Use '/v to spawn it.");
			SendClientMessage(playerid, -1, "{eee8aa}You can {ff0000}upgrade {eee8aa}your vehicle by {ffffff}Tune shop.");
			GivePlayerCash(playerid, -270000);
			userinfo[playerid][vowned] = 1;
			userinfo[playerid][vmodel] = 506;
			userinfo[playerid][vcolor_1] = 51;
			userinfo[playerid][vcolor_2] = 51;
			userinfo[playerid][vnitro] = -1;
			userinfo[playerid][vneon_1] = 0;
			userinfo[playerid][vneon_2] = 0;
			userinfo[playerid][vpjob] = 3;
			userinfo[playerid][vwheel] = 1077;
			userinfo[playerid][vhydra] = 0;

			mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_owned` = %d, `Vehicle_model` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vowned], userinfo[playerid][vmodel], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
			mysql_tquery(Database, str);
		}
		else if(isequal("9", inputtext))
		{
			if(userinfo[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{ff0000}You already own a personal vehicle.");
			if(GetPlayerCash(playerid) < 290000) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to purchase this vehicle.");
			SendClientMessage(playerid, -1, "{eee8aa}You have purchased a {ff0000}\"Cheetah\"{eee8aa}, Use '/v to spawn it.");
			SendClientMessage(playerid, -1, "{eee8aa}You can {ff0000}upgrade {eee8aa}your vehicle by {ffffff}Tune shop.");
			GivePlayerCash(playerid, -290000);
			userinfo[playerid][vowned] = 1;
			userinfo[playerid][vmodel] = 415;
			userinfo[playerid][vcolor_1] = 51;
			userinfo[playerid][vcolor_2] = 51;
			userinfo[playerid][vnitro] = -1; 
			userinfo[playerid][vneon_1] = 0;
			userinfo[playerid][vneon_2] = 0;
			userinfo[playerid][vpjob] = 3;
			userinfo[playerid][vwheel] = 1077;
			userinfo[playerid][vhydra] = 0;

			mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_owned` = %d, `Vehicle_model` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vowned], userinfo[playerid][vmodel], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
			mysql_tquery(Database, str);
		}
		else if(isequal("10", inputtext))
		{
			if(userinfo[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{ff0000}You already own a personal vehicle.");
			if(GetPlayerCash(playerid) < 310000) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to purchase this vehicle.");
			SendClientMessage(playerid, -1, "{eee8aa}You have purchased a {ff0000}\"Bullet\"{eee8aa}, Use '/v to spawn it.");
			SendClientMessage(playerid, -1, "{eee8aa}You can {ff0000}upgrade {eee8aa}your vehicle by {ffffff}Tune shop.");
			GivePlayerCash(playerid, -310000);
			userinfo[playerid][vowned] = 1;
			userinfo[playerid][vmodel] = 541;
			userinfo[playerid][vcolor_1] = 51;
			userinfo[playerid][vcolor_2] = 53;
			userinfo[playerid][vnitro] = -1;
			userinfo[playerid][vneon_1] = 0;
			userinfo[playerid][vneon_2] = 0;
			userinfo[playerid][vpjob] = 3;
			userinfo[playerid][vwheel] = 1077;
			userinfo[playerid][vhydra] = 0;

			mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_owned` = %d, `Vehicle_model` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vowned], userinfo[playerid][vmodel], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
			mysql_tquery(Database, str);
		}
		else
		{
			SendClientMessage(playerid, -1, "{ff0000}Invalid selection.");
			Dialog_Show(playerid, DIALOG_VEH_CAR, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Vehicle Shop", str, "Purchase", "Close");
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
		strcat(str, "{e9967a}ID\tBike   \tPrice\n\n");
		strcat(str, "{ff0000}1 \t{ffffff}Quad   \t$30000\n");
		strcat(str, "{ff0000}2 \t{ffffff}Faggio \t$40000\n");
		strcat(str, "{ff0000}3 \t{ffffff}Freeway\t$60000\n");
		strcat(str, "{ff0000}4 \t{ffffff}Sanchez\t$70000\n");
		strcat(str, "{ff0000}5 \t{ffffff}PCJ-600\t$90000\n");
		strcat(str, "{ff0000}6 \t{ffffff}BF-400 \t$90000\n");
		strcat(str, "{ff0000}7 \t{ffffff}FCR-900\t$100000");
		if(isempty(inputtext))
		{
			SendClientMessage(playerid, -1, "{ff0000}Invalid selection.");
			Dialog_Show(playerid, DIALOG_VEH_BIKE, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Vehicle Shop ", str, "Purchase", "Close");
		}
		else if(isequal("1", inputtext))
		{
			if(userinfo[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{ff0000}You already own a personal vehicle.");
			if(GetPlayerCash(playerid) < 30000) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to purchase this vehicle.");
			SendClientMessage(playerid, -1, "{eee8aa}You have purchased a {ff0000}\"Quad\"{eee8aa}, Use '/v to spawn it.");
			SendClientMessage(playerid, -1, "{eee8aa}You can {ff0000}upgrade {eee8aa}your vehicle by {ffffff}Tune shop.");
			GivePlayerCash(playerid, -30000);
			userinfo[playerid][vowned] = 1;
			userinfo[playerid][vmodel] = 471;
			userinfo[playerid][vcolor_1] = 51;
			userinfo[playerid][vcolor_2] = 53;
			userinfo[playerid][vnitro] = -1;
			userinfo[playerid][vneon_1] = 0;
			userinfo[playerid][vneon_2] = 0;
			userinfo[playerid][vpjob] = 3;
			userinfo[playerid][vwheel] = 1077;
			userinfo[playerid][vhydra] = 0;

			mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_owned` = %d, `Vehicle_model` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vowned], userinfo[playerid][vmodel], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
			mysql_tquery(Database, str);
		}
		else if(isequal("2", inputtext))
		{
			if(userinfo[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{ff0000}You already own a personal vehicle.");
			if(GetPlayerCash(playerid) < 40000) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to purchase this vehicle.");
			SendClientMessage(playerid, -1, "{eee8aa}You have purchased a {ff0000}\"Faggio\"{eee8aa}, Use '/v to spawn it.");
			SendClientMessage(playerid, -1, "{eee8aa}You can {ff0000}upgrade {eee8aa}your vehicle by {ffffff}Tune shop.");
			GivePlayerCash(playerid, -40000);
			userinfo[playerid][vowned] = 1;
			userinfo[playerid][vmodel] = 462;
			userinfo[playerid][vcolor_1] = 51;
			userinfo[playerid][vcolor_2] = 53;
			userinfo[playerid][vnitro] = -1;
			userinfo[playerid][vneon_1] = 0;
			userinfo[playerid][vneon_2] = 0;
			userinfo[playerid][vpjob] = 3;
			userinfo[playerid][vwheel] = 1077;
			userinfo[playerid][vhydra] = 0;

			mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_owned` = %d, `Vehicle_model` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vowned], userinfo[playerid][vmodel], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
			mysql_tquery(Database, str);
		}
		else if(isequal("3", inputtext))
		{
			if(userinfo[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{ff0000}You already own a personal vehicle.");
			if(GetPlayerCash(playerid) < 60000) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to purchase this vehicle.");
			SendClientMessage(playerid, -1, "{eee8aa}You have purchased a {ff0000}\"Freeway\"{eee8aa}, Use '/v to spawn it.");
			SendClientMessage(playerid, -1, "{eee8aa}You can {ff0000}upgrade {eee8aa}your vehicle by {ffffff}Tune shop.");
			GivePlayerCash(playerid, -60000);
			userinfo[playerid][vowned] = 1;
			userinfo[playerid][vmodel] = 463;
			userinfo[playerid][vcolor_1] = 51;
			userinfo[playerid][vcolor_2] = 53;
			userinfo[playerid][vnitro] = -1;
			userinfo[playerid][vneon_1] = 0;
			userinfo[playerid][vneon_2] = 0;
			userinfo[playerid][vpjob] = 3;
			userinfo[playerid][vwheel] = 1077;
			userinfo[playerid][vhydra] = 0;

			mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_owned` = %d, `Vehicle_model` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vowned], userinfo[playerid][vmodel], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
			mysql_tquery(Database, str);
		}
		else if(isequal("4", inputtext))
		{
			if(userinfo[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{ff0000}You already own a personal vehicle.");
			if(GetPlayerCash(playerid) < 70000) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to purchase this vehicle.");
			SendClientMessage(playerid, -1, "{eee8aa}You have purchased a {ff0000}\"Sanchez\"{eee8aa}, Use '/v to spawn it.");
			SendClientMessage(playerid, -1, "{eee8aa}You can {ff0000}upgrade {eee8aa}your vehicle by {ffffff}Tune shop.");
			GivePlayerCash(playerid, -70000);
			userinfo[playerid][vowned] = 1;
			userinfo[playerid][vmodel] = 468;
			userinfo[playerid][vcolor_1] = 51;
			userinfo[playerid][vcolor_2] = 51;
			userinfo[playerid][vnitro] = -1;
			userinfo[playerid][vneon_1] = 0;
			userinfo[playerid][vneon_2] = 0;
			userinfo[playerid][vpjob] = 3;
			userinfo[playerid][vwheel] = 1077;
			userinfo[playerid][vhydra] = 0;

			mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_owned` = %d, `Vehicle_model` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vowned], userinfo[playerid][vmodel], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
			mysql_tquery(Database, str);
		}
		else if(isequal("5", inputtext))
		{
			if(userinfo[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{ff0000}You already own a personal vehicle.");
			if(GetPlayerCash(playerid) < 90000) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to purchase this vehicle.");
			SendClientMessage(playerid, -1, "{eee8aa}You have purchased a {ff0000}\"PCJ-600\"{eee8aa}, Use '/v to spawn it.");
			SendClientMessage(playerid, -1, "{eee8aa}You can {ff0000}upgrade {eee8aa}your vehicle by {ffffff}Tune shop.");
			GivePlayerCash(playerid, -90000);
			userinfo[playerid][vowned] = 1;
			userinfo[playerid][vmodel] = 461;
			userinfo[playerid][vcolor_1] = 51;
			userinfo[playerid][vcolor_2] = 51;
			userinfo[playerid][vnitro] = -1;
			userinfo[playerid][vneon_1] = 0;
			userinfo[playerid][vneon_2] = 0;
			userinfo[playerid][vpjob] = 3;
			userinfo[playerid][vwheel] = 1077;
			userinfo[playerid][vhydra] = 0;

			mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_owned` = %d, `Vehicle_model` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vowned], userinfo[playerid][vmodel], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
			mysql_tquery(Database, str);
		}
		else if(isequal("6", inputtext))
		{
			if(userinfo[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{ff0000}You already own a personal vehicle.");
			if(GetPlayerCash(playerid) < 90000) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to purchase this vehicle.");
			SendClientMessage(playerid, -1, "{eee8aa}You have purchased a {ff0000}\"BF-400\"{eee8aa}, Use '/v to spawn it.");
			SendClientMessage(playerid, -1, "{eee8aa}You can {ff0000}upgrade {eee8aa}your vehicle by {ffffff}Tune shop.");
			GivePlayerCash(playerid, -90000);
			userinfo[playerid][vowned] = 1;
			userinfo[playerid][vmodel] = 581;
			userinfo[playerid][vcolor_1] = 51;
			userinfo[playerid][vcolor_2] = 51;
			userinfo[playerid][vnitro] = -1;
			userinfo[playerid][vneon_1] = 0;
			userinfo[playerid][vneon_2] = 0;
			userinfo[playerid][vpjob] = 3;
			userinfo[playerid][vwheel] = 1077;
			userinfo[playerid][vhydra] = 0;

			mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_owned` = %d, `Vehicle_model` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vowned], userinfo[playerid][vmodel], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
			mysql_tquery(Database, str);
		}
		else if(isequal("7", inputtext))
		{
			if(userinfo[playerid][vowned] == 1) return SendClientMessage(playerid, -1, "{ff0000}You already own a personal vehicle.");
			if(GetPlayerCash(playerid) < 100000) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to purchase this vehicle.");
			SendClientMessage(playerid, -1, "{eee8aa}You have purchased a {ff0000}\"FCR-900\"{eee8aa}, Use '/v to spawn it.");
			SendClientMessage(playerid, -1, "{eee8aa}You can {ff0000}upgrade {eee8aa}your vehicle by {ffffff}Tune shop.");
			GivePlayerCash(playerid, -100000);
			userinfo[playerid][vowned] = 1;
			userinfo[playerid][vmodel] = 521;
			userinfo[playerid][vcolor_1] = 51;
			userinfo[playerid][vcolor_2] = 51;
			userinfo[playerid][vnitro] = -1;
			userinfo[playerid][vneon_1] = 0;
			userinfo[playerid][vneon_2] = 0;
			userinfo[playerid][vpjob] = 3;
			userinfo[playerid][vwheel] = 1077;
			userinfo[playerid][vhydra] = 0;

			mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_owned` = %d, `Vehicle_model` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vowned], userinfo[playerid][vmodel], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
			mysql_tquery(Database, str);
		}
		else
		{
			SendClientMessage(playerid, -1, "{ff0000}Invalid selection.");
			Dialog_Show(playerid, DIALOG_VEH_BIKE, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Vehicle Shop ", str, "Purchase", "Close");
		}
	}
	return 1;
}

Dialog:DIALOG_VEH_SELL(playerid, response, listitem, inputtext[])
{ 
	if(!response) Dialog_Close(playerid);
	if(response)
	{
		if(userinfo[playerid][vowned] == 0) return SendClientMessage(playerid, -1, "{ff0000}You don't have any vehicle to sell.");
		if(priveh[playerid] == INVALID_VEHICLE_ID) return SendClientMessage(playerid, -1, "{ff0000}You must spawn your vehicle first.");
		userinfo[playerid][vowned] = 0;    
		DestroyPrivateVehicle(playerid); 
		switch(userinfo[playerid][vmodel])
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
		new str[128];
		mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_owned` = 0 WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][pid]);
		mysql_tquery(Database, str);
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
			format(str, sizeof(str), "{ffffff}Welcome to {33ff00}Lazer Gaming Gang WarZ\n\n{ffffff}Your account{ff0000}\"%s\" {ffffff}is not registered. Please enter a desired password below to register", userinfo[playerid][pname]);
            Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT,"{ffa500}LGGW {ffffff}- Registreation",str,"Register","Quit");
			SendClientMessage(playerid, -1, "{ff0000}Your password must include 5 - 20 characters");
		}
		else 
        {
            format(tmppass[playerid], BCRYPT_HASH_LENGTH, "%s", inputtext);
            Dialog_Show(playerid, DIALOG_PASS_CONF, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Registration", "{ffffff}Please confirm your {ff0000}password {ffffff}in order to continue!", "Confirm", "Change");
        }
	}  
	else return Kick(playerid);
	return 1;
}

Dialog:DIALOG_PASS_CONF(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(!isequal(tmppass[playerid], inputtext))
        {
            Dialog_Show(playerid, DIALOG_PASS_CONF, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Registration", "{ffffff}Please confirm your {ff0000}password {ffffff}in order to continue!", "Confirm", "Change");
            return SendClientMessage(playerid, -1, "{ff0000}Your passwords seems to be unmatching!");
        }

        bcrypt_hash(inputtext, BCRYPT_COST, "OnPasswordHashed", "d", playerid);
    }
    else
    {
        new str[256];
        format(str, sizeof(str), "{ffffff}Welcome to {33ff00}Lazer Gaming Gang WarZ\n\n{ffffff}Your account{ff0000} \"%s\" {ffffff}is not registered. Please enter a desired password below to register", userinfo[playerid][pname]);
        Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT,"{ffa500}LGGW {ffffff}- Registration",str,"Register","Quit");
    }      
    return 1;
}

forward OnPasswordHashed(playerid);
public OnPasswordHashed(playerid)
{
    bcrypt_get_hash(userinfo[playerid][ppass]);

    new str[256];

    GameTextForPlayer(playerid, "~g~$10000", 5000, 1);
    format(str, sizeof(str), "{7cfc00}You have been registered successfully! ( Password: {ffffff}%s {7cfc00}).", tmppass[playerid]);
    SendClientMessage(playerid, -1, str);

    new _gpci[40];
    gpci(playerid, _gpci, sizeof(_gpci));

    mysql_format(Database, str, sizeof(str), "INSERT INTO `Users` (`Name`, `Password`, `GPCI`) VALUES ('%e', '%s', '%s')", userinfo[playerid][pname], userinfo[playerid][ppass], _gpci);
    mysql_tquery(Database, str, "OnPlayerRegister", "d", playerid);
    return 1;
}

forward OnPlayerRegister(playerid);
public OnPlayerRegister(playerid)
{
	new str[256];
	userinfo[playerid][pid] = cache_insert_id();

    for(new i = 0; i < MAX_IP_SAVES; i++)
    {
        mysql_format(Database, str, sizeof(str), "INSERT INTO `User_IPs` (`User_ID`, `Index_`, `IP`) VALUES ('%d', '%d', '-1')", userinfo[playerid][pid], i);
        mysql_tquery(Database, str);
    }

	for(new i = 0; i < 10; i++)
    {
        mysql_format(Database, str, sizeof(str), "INSERT INTO `User_Toys` (`User_ID`, `Index_`) VALUES ('%d', '%d')", userinfo[playerid][pid], i);
        mysql_tquery(Database, str);
    }

    mysql_tquery(Database, "INSERT INTO `User_Status` (`Banned`) VALUES ('0')");
    mysql_tquery(Database, "INSERT INTO `User_Vehicles` (`Vehicle_owned`) VALUES ('0')");
	
    mysql_format(Database, str, sizeof(str), "SELECT * FROM Users WHERE `User_ID` = '%d' LIMIT 1", userinfo[playerid][pid]);
	userinfo[playerid][Player_Cache] = mysql_query(Database, str); 
	
    format(str, sizeof(str), "{FFFFFF}Welcome back to {33ff00}Lazer Gaming Gang WarZ\n\n{ffffff}Account{ff0000}\"%s\" {ffffff}is registered. Please enter your password below to login", userinfo[playerid][pname]);
	Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,"{ffa500}LGGW {ffffff}- Login",str,"Login","Quit");
	return 1;
}

stock GetMonthName(Month)
{
    new MonthStr[15];
    switch(Month)
    {
        case 1:  MonthStr = "January";
        case 2:  MonthStr = "February";
        case 3:  MonthStr = "March";
        case 4:  MonthStr = "April";
        case 5:  MonthStr = "May";
        case 6:  MonthStr = "June";
        case 7:  MonthStr = "July";
        case 8:  MonthStr = "August";
        case 9:  MonthStr = "September";
        case 10: MonthStr = "October";
        case 11: MonthStr = "November";
        case 12: MonthStr = "December";
    }
    return MonthStr;
}

stock Get12HrsTime(h, m)
{
    new str[15];
    if(h > 12) format(str, sizeof(str), "%i:%ipm", h - 12, m);
    else format(str, sizeof(str), "%i:%iam", h, m);
    return str;
}

Dialog:DIALOG_LOGIN(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        bcrypt_check(inputtext, userinfo[playerid][ppass], "OnPasswordChecked", "d", playerid);
	}
	else return Kick(playerid);
	return 1;
}

forward OnPasswordChecked(playerid);
public OnPasswordChecked(playerid)
{
    if(bcrypt_is_equal())
    {
        new str1[128];

        cache_set_active(userinfo[playerid][Player_Cache]);
        LoadUserData(playerid);
        cache_delete(userinfo[playerid][Player_Cache]);
        userinfo[playerid][Player_Cache] = MYSQL_INVALID_CACHE;

        mysql_format(Database, str1, sizeof(str1), "SELECT * FROM `User_Toys` WHERE `User_ID` = '%d' LIMIT 10", userinfo[playerid][pid]);
        mysql_tquery(Database, str1, "LoadUserToyData", "d", playerid);
        mysql_format(Database, str1, sizeof(str1), "SELECT * FROM `User_Vehicles` WHERE `User_ID` = '%d' LIMIT 1", userinfo[playerid][pid]);
        mysql_tquery(Database, str1, "LoadUserVehicleData", "d", playerid);

        SendClientMessage(playerid, -1, "{7cfc00}Logged in successfully!");

        TextDrawHideForPlayer(playerid, connecttd[0]);
        TextDrawHideForPlayer(playerid, connecttd[1]);
        TextDrawHideForPlayer(playerid, connecttd[4]);
        TextDrawHideForPlayer(playerid, connecttd[5]);
        TextDrawHideForPlayer(playerid, connecttd[6]);
        TextDrawHideForPlayer(playerid, connecttd[7]);
        TextDrawHideForPlayer(playerid, connecttd[8]);
        TextDrawHideForPlayer(playerid, connecttd[9]);
        TextDrawHideForPlayer(playerid, connecttd[10]);
        TextDrawHideForPlayer(playerid, connecttd[11]);

        TextDrawShowForPlayer(playerid, LGGW[0]);
        TextDrawShowForPlayer(playerid, LGGW[1]);
        TextDrawShowForPlayer(playerid, LGGW[2]);
        TextDrawShowForPlayer(playerid, LGGW[3]);

        if(userinfo[playerid][plevel] > 0) adm_id[playerid] = GetFreeAdminID();
        if(userinfo[playerid][jailed] == 1) nocmd[playerid] = 1;

        SetPlayerCash(playerid, userinfo[playerid][pcash]);
        SetPlayerScore(playerid, userinfo[playerid][pkills]);

        KillTimer(camtimer[playerid]);
        camtimer[playerid] = INVALID_PLAYER_ID;

        logged[playerid] = 1;

        mysql_format(Database, str1, sizeof(str1), "SELECT * FROM `User_IPs` WHERE `IP` = '%e' AND `User_ID` = '%d' LIMIT 1", userinfo[playerid][pip], userinfo[playerid][pid]);
        mysql_tquery(Database, str1, "IP_Ex", "d", playerid);

        if(userinfo[playerid][ingang] == 1) return SpawnPlayer(playerid);
        class_real[playerid] = -1;
        OnPlayerRequestClass(playerid, 0);
    }
    else
    {
        new str[256];
        format(str, sizeof(str), "{FFFFFF}Welcome back to {33ff00}Lazer Gaming Gang WarZ\n\n{ffffff}Account{ff0000}\"%s\" {ffffff}is registered. Please enter your password below to login", userinfo[playerid][pname]);
        Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,"{ffa500}LGGW {ffffff}- Login", str,"Login","Quit");
        SendClientMessage(playerid, -1, "{ff0000}Incorrect password.");
    }
    return 1;
}

forward IP_Ex(playerid);
public IP_Ex(playerid)
{
    if(!cache_num_rows())
    {
        new str[128];
        mysql_format(Database, str, sizeof(str), "UPDATE `User_IPs` SET `IP` = '%e' WHERE `IP` = '-1' AND `User_ID` = '%d' LIMIT 1", userinfo[playerid][pip], userinfo[playerid][pid]);
        mysql_pquery(Database, str);
    }
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
		format(str, sizeof(str), "* \"%s[%d]\" {FF8000}kicked from the Server (Rejecting rules).", userinfo[playerid][pname], playerid);
        SendClientMessageToAll_(-1, str);
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
			SendClientMessage(playerid, -1, "* {7cfc00}You have accessed the SERVER succesfully!");
			GameTextForPlayer(playerid,"~g~Welcome administrator",5000,5);
			format(str, sizeof(str), "[ STEP 2 ] `%s[%d]` accessed 2nd RCON successfully :open_mouth: and got the power to control the server!", userinfo[playerid][pname], playerid);
			//DCC_SendChannelMessage(dcc_channel_rcon, str);
		}
		else if(rconattempts[playerid] >= 3) 
		{ 
			format(str, sizeof(str), "* \"%s[%d]\" {FF8000}banned from the Server (Trying to access RCON).", userinfo[playerid][pname], playerid);
			SendClientMessageToAll_(-1, str);
			BanPlayer(userinfo[playerid][pname]);
			format(str, sizeof(str), "[ STEP 2 ] `%s[%d]` got banned because of trying to access RCON! :joy:", userinfo[playerid][pname], playerid);
			//DCC_SendChannelMessage(dcc_channel_rcon, str);
		}
		else 
		{
			rconattempts[playerid]++;
			SendClientMessage(playerid, -1, "{ff0000}Incorrect RCON password (If you are not a community owner don't try to access RCON, It will result you in a permanat ban).");
			format(str, sizeof(str), "{eee8aa}Remaining RCON login attempts: %d", 4 - rconattempts[playerid]);
			SendClientMessage(playerid, -1, str);
			Dialog_Show(playerid, DIALOG_RCON, DIALOG_STYLE_PASSWORD, "{ffa500}LGGW {ffffff}- Rcon protection", "You have logged in RCON partially, \nNow input the 2nd RCON security password to access the SERVER features", "Access", "Quit");
			format(str, sizeof(str), "[ STEP 2 ] (attempts: %d/3) `%s[%d]` is trying to access 2nd RCON... @developers use /aka to check who is this! May be he is an enemy :angry: (password: `%s`).", rconattempts[playerid], userinfo[playerid][pname], playerid, inputtext);
			//DCC_SendChannelMessage(dcc_channel_rcon, str);
		}
	}
	else 
	{
		format(str, sizeof(str), "* \"%s[%d]\" {FF8000}kicked from the Server (Trying to access RCON).", userinfo[playerid][pname], playerid);
		SendClientMessageToAll_(-1, str);
		Kick(playerid);
		format(str, sizeof(str), "[ STEP 2 ] `%s[%d]` got kicked because of trying to access RCON! :joy:", userinfo[playerid][pname], playerid);
		//DCC_SendChannelMessage(dcc_channel_rcon, str);
	}
	return 1;
}

forward OnSortingFinished(playerid, thread);
public OnSortingFinished(playerid, thread)
{
    new completed[1024], str[128], name[MAX_PLAYER_NAME], rows, val;
    cache_get_row_count(rows);
    switch(thread)
    {
        case THREAD_SORT_KILLS:
        {   
            strcat(completed, "Rank\tName\tKills\n", sizeof(completed));
            for (new a; a < rows; a++) 
            { 
                cache_get_value_name(a, "Name", name, sizeof(name)); 
                cache_get_value_name_int(a, "Kills", val); 
                if(a == 0) format(str, sizeof(str), "{b22222}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 1) format(str, sizeof(str), "{d2691e}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 2) format(str, sizeof(str), "{eee8aa}%i\t%s\t%i{ffffff}\n", a + 1, name, val);
                strcat(completed, str);
            }                       
            Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Top Killers", completed, "Close", "");
        }
        case THREAD_SORT_DEATHS:
        {
            strcat(completed, "Rank\tName\tDeaths\n", sizeof(completed));
            for (new a; a < rows; a++) 
            { 
                cache_get_value_name(a, "Name", name, sizeof(name)); 
                cache_get_value_name_int(a, "Deaths", val); 
                if(a == 0) format(str, sizeof(str), "{b22222}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 1) format(str, sizeof(str), "{d2691e}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 2) format(str, sizeof(str), "{eee8aa}%i\t%s\t%i{ffffff}\n", a + 1, name, val);
                strcat(completed, str);
            }                       
            Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Top Weakest", completed, "Close", "");
        }
        case THREAD_SORT_CASH:
        {
            strcat(completed, "Rank\tName\tCash\n", sizeof(completed));
            for (new a; a < rows; a++) 
            { 
                cache_get_value_name(a, "Name", name, sizeof(name)); 
                cache_get_value_name_int(a, "Cash", val); 
                if(a == 0) format(str, sizeof(str), "{b22222}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 1) format(str, sizeof(str), "{d2691e}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 2) format(str, sizeof(str), "{eee8aa}%i\t%s\t%i{ffffff}\n", a + 1, name, val);
                strcat(completed, str);
            }                       
            Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Top Richest", completed, "Close", "");
        }
        case THREAD_SORT_RATIO:
        {
            new Float:val2;
            strcat(completed, "Rank\tName\tRatio\n", sizeof(completed));
            for (new a; a < rows; a++) 
            { 
                cache_get_value_name(a, "Name", name, sizeof(name)); 
                cache_get_value_name_float(a, "Ratio", val2); 
                if(a == 0) format(str, sizeof(str), "{b22222}%i\t%s\t%.2f\n", a + 1, name, val2);
                else if(a == 1) format(str, sizeof(str), "{d2691e}%i\t%s\t%.2f\n", a + 1, name, val2);
                else if(a == 2) format(str, sizeof(str), "{eee8aa}%i\t%s\t%.2f{ffffff}\n", a + 1, name, val2);
                strcat(completed, str);
            }   
            Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Top Players", completed, "Close", "");
        }
        case THREAD_SORT_DUELSWON:
        {
            strcat(completed, "Rank\tName\tDuels won\n", sizeof(completed));
            for (new a; a < rows; a++) 
            { 
                cache_get_value_name(a, "Name", name, sizeof(name)); 
                cache_get_value_name_int(a, "Duels_won", val); 
                if(a == 0) format(str, sizeof(str), "{b22222}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 1) format(str, sizeof(str), "{d2691e}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 2) format(str, sizeof(str), "{eee8aa}%i\t%s\t%i{ffffff}\n", a + 1, name, val);
                strcat(completed, str);
            }   
            Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Top Duels won", completed, "Close", "");
        }
        case THREAD_SORT_HRAMP:
        {
            strcat(completed, "Rank\tName\tRampages\n", sizeof(completed));
            for (new a; a < rows; a++) 
            { 
                cache_get_value_name(a, "Name", name, sizeof(name)); 
                cache_get_value_name_int(a, "Rampages", val); 
                if(a == 0) format(str, sizeof(str), "{b22222}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 1) format(str, sizeof(str), "{d2691e}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 2) format(str, sizeof(str), "{eee8aa}%i\t%s\t%i{ffffff}\n", a + 1, name, val);
                strcat(completed, str);
            }   
            Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Top Rampages", completed, "Close", "");
        }
        case THREAD_SORT_ROBBS:
        {
            strcat(completed, "Rank\tName\tRobbs\n", sizeof(completed));
            for (new a; a < rows; a++) 
            { 
                cache_get_value_name(a, "Name", name, sizeof(name)); 
                cache_get_value_name_int(a, "Robbers", val); 
                if(a == 0) format(str, sizeof(str), "{b22222}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 1) format(str, sizeof(str), "{d2691e}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 2) format(str, sizeof(str), "{eee8aa}%i\t%s\t%i{ffffff}\n", a + 1, name, val);
                strcat(completed, str);
            }   
            Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Top Robbers", completed, "Close", "");
        }
        case THREAD_SORT_REVENGES:
        {
            strcat(completed, "Rank\tName\tRevenges\n", sizeof(completed));
            for (new a; a < rows; a++) 
            { 
                cache_get_value_name(a, "Name", name, sizeof(name)); 
                cache_get_value_name_int(a, "Revenges", val); 
                if(a == 0) format(str, sizeof(str), "{b22222}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 1) format(str, sizeof(str), "{d2691e}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 2) format(str, sizeof(str), "{eee8aa}%i\t%s\t%i{ffffff}\n", a + 1, name, val);
                strcat(completed, str);
            }   
            Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Top Revenges", completed, "Close", "");
        }
        case THREAD_SORT_GTURFS:
        {
            strcat(completed, "Rank\tName\tTurfs\n", sizeof(completed));
            for (new a; a < rows; a++) 
            { 
                cache_get_value_name(a, "Name", name, sizeof(name)); 
                strreplace(name, "_", "");
                cache_get_value_name_int(a, "Turfs", val); 
                if(a == 0) format(str, sizeof(str), "{b22222}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 1) format(str, sizeof(str), "{d2691e}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 2) format(str, sizeof(str), "{eee8aa}%i\t%s\t%i{ffffff}\n", a + 1, name, val); 
                strcat(completed, str);
            }   
            Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Top Turf owners", completed, "Close", "");
        }
        case THREAD_SORT_GSCORE:
        {
            strcat(completed, "Rank\tName\tScore\n", sizeof(completed));
            for (new a; a < rows; a++) 
            { 
                cache_get_value_name(a, "Name", name, sizeof(name)); 
                strreplace(name, "_", "");
                cache_get_value_name_int(a, "Score", val); 
                if(a == 0) format(str, sizeof(str), "{b22222}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 1) format(str, sizeof(str), "{d2691e}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 2) format(str, sizeof(str), "{eee8aa}%i\t%s\t%i{ffffff}\n", a + 1, name, val);
                strcat(completed, str);
            }   
            Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Top Gangs", completed, "Close", "");
        }
        case THREAD_SORT_BKILLS:
        {
            strcat(completed, "Rank\tName\tBrutal Kills\n", sizeof(completed));
            for (new a; a < rows; a++) 
            { 
                cache_get_value_name(a, "Name", name, sizeof(name)); 
                cache_get_value_name_int(a, "Brutal_kills", val); 
                if(a == 0) format(str, sizeof(str), "{b22222}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 1) format(str, sizeof(str), "{d2691e}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 2) format(str, sizeof(str), "{eee8aa}%i\t%s\t%i{ffffff}\n", a + 1, name, val);
                strcat(completed, str);
            }   
            Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Top Brutal killers", completed, "Close", "");
        }
        case THREAD_SORT_LMSWON:
        {
            strcat(completed, "Rank\tName\tLMS won\n", sizeof(completed));
            for (new a; a < rows; a++) 
            { 
                cache_get_value_name(a, "Name", name, sizeof(name)); 
                cache_get_value_name_int(a, "LMS_won", val); 
                if(a == 0) format(str, sizeof(str), "{b22222}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 1) format(str, sizeof(str), "{d2691e}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 2) format(str, sizeof(str), "{eee8aa}%i\t%s\t%i{ffffff}\n", a + 1, name, val);
                strcat(completed, str);
            }   
            Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Top LMS winners", completed, "Close", "");
        }
        case THREAD_SORT_GGWON:
        {
            strcat(completed, "Rank\tName\tGunGames won\n", sizeof(completed));
            for (new a; a < rows; a++) 
            { 
                cache_get_value_name(a, "Name", name, sizeof(name)); 
                cache_get_value_name_int(a, "GunGames_won", val); 
                if(a == 0) format(str, sizeof(str), "{b22222}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 1) format(str, sizeof(str), "{d2691e}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 2) format(str, sizeof(str), "{eee8aa}%i\t%s\t%i{ffffff}\n", a + 1, name, val);
                strcat(completed, str);
            }   
            Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Top GunGame winners", completed, "Close", "");
        }
        case THREAD_SORT_HSHOTS:
        {
            strcat(completed, "Rank\tName\tHead shots\n", sizeof(completed));
            for (new a; a < rows; a++) 
            { 
                cache_get_value_name(a, "Name", name, sizeof(name)); 
                cache_get_value_name_int(a, "Head_shots", val); 
                if(a == 0) format(str, sizeof(str), "{b22222}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 1) format(str, sizeof(str), "{d2691e}%i\t%s\t%i\n", a + 1, name, val);
                else if(a == 2) format(str, sizeof(str), "{eee8aa}%i\t%s\t%i{ffffff}\n", a + 1, name, val);
                strcat(completed, str);
            }   
            Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Top Head shotters", completed, "Close", "");
        }
    }
    return 1;
}

Dialog:DIALOG_TOP_SELECTION(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{ 
			case 1: mysql_tquery(Database, "SELECT `Name`,`Kills` FROM `Users` ORDER BY `Kills` DESC LIMIT 10", "OnSortingFinished", "ii", playerid, THREAD_SORT_KILLS);
			case 2: mysql_tquery(Database, "SELECT `Name`,`Deaths` FROM `Users` ORDER BY `Deaths` DESC LIMIT 10", "OnSortingFinished", "ii", playerid, THREAD_SORT_DEATHS);
			case 3: mysql_tquery(Database, "SELECT `Name`,`Cash` FROM `Users` ORDER BY `Cash` DESC LIMIT 10", "OnSortingFinished", "ii", playerid, THREAD_SORT_CASH);
			case 0: mysql_tquery(Database, "SELECT `Name`,`Ratio` FROM `Users` ORDER BY `Ratio` DESC LIMIT 10", "OnSortingFinished", "ii", playerid, THREAD_SORT_RATIO);
			case 4: mysql_tquery(Database, "SELECT `Name`,`Duels_won` FROM `Users` ORDER BY `Duels_won` DESC LIMIT 10", "OnSortingFinished", "ii", playerid, THREAD_SORT_DUELSWON);
			case 5:	mysql_tquery(Database, "SELECT `Name`,`Highest_rampage` FROM `Users` ORDER BY `Highest_rampage` DESC LIMIT 10", "OnSortingFinished", "ii", playerid, THREAD_SORT_HRAMP);			
            case 6:	mysql_tquery(Database, "SELECT `Name`,`Robberies` FROM `Users` ORDER BY `Robberies` DESC LIMIT 10", "OnSortingFinished", "ii", playerid, THREAD_SORT_ROBBS);		
            case 7:	mysql_tquery(Database, "SELECT `Name`,`Revenges` FROM `Users` ORDER BY `Revenges` DESC LIMIT 10", "OnSortingFinished", "ii", playerid, THREAD_SORT_REVENGES);			
            case 8: mysql_tquery(Database, "SELECT `Name`,`Turfs` FROM `Gangs` WHERE `Name` != '-1' ORDER BY `Turfs` DESC LIMIT 10", "OnSortingFinished", "ii", playerid, THREAD_SORT_GTURFS);
			case 9: mysql_tquery(Database, "SELECT `Name`,`Score` FROM `Gangs` WHERE `Name` != '-1' ORDER BY `Score` DESC LIMIT 10", "OnSortingFinished", "ii", playerid, THREAD_SORT_GSCORE);
			case 10: mysql_tquery(Database, "SELECT `Name`,`Brutal_kills` FROM `Users` ORDER BY `Brutal_kills` DESC LIMIT 10", "OnSortingFinished", "ii", playerid, THREAD_SORT_BKILLS);
			case 11: mysql_tquery(Database, "SELECT `Name`,`LMS_Won` FROM `Users` ORDER BY `LMS_Won` DESC LIMIT 10", "OnSortingFinished", "ii", playerid, THREAD_SORT_LMSWON);
			case 12: mysql_tquery(Database, "SELECT `Name`,`GunGames_won` FROM `Users` ORDER BY `GunGames_won` DESC LIMIT 10", "OnSortingFinished", "ii", playerid, THREAD_SORT_GGWON);
			case 13: mysql_tquery(Database, "SELECT `Name`,`Head_shots` FROM `Users` ORDER BY `Head_shots` DESC LIMIT 10", "OnSortingFinished", "ii", playerid, THREAD_SORT_HSHOTS);
		}
	}
	return 1;
}

Dialog:DIALOG_LMS_PLACE(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(lmsstarted == 1) return SendClientMessage(playerid, -1, "{ff0000}Last Man Standing event has already started.");
		switch(strval(inputtext))
        {
            case 1:
    		{
    			inlms[playerid] = 1;
    			lmsstarted = 1;
    			lmsplace = 1;
    			SetTimer("StartLastManStanding", 60000, false);
    			SendClientMessageToAll_(-1, "{8000ff}Player counting for Last Man Standing started. Use {ffffff}'/lms'{8000ff} to join.");
    			SendClientMessageToAll_(-1, "{8000ff}Last Man Standing will start in a minute. Stay tuned!!!");
    			GameTextForAll("Last Man Standing counting started!!!~n~/LMS", 15000, 4);
    		}
    		case 2:
    		{
    			inlms[playerid] = 1;
    			lmsstarted = 1;
    			lmsplace = 2;
    			SetTimer("StartLastManStanding", 60000, false);
    			SendClientMessageToAll_(-1, "{8000ff}Player counting for Last Man Standing started. Use {ffffff}'/lms'{8000ff} to join.");
    			SendClientMessageToAll_(-1, "{8000ff}Last Man Standing will start in a minute. Stay tuned!!!");
    			GameTextForAll("Last Man Standing counting started!!!~n~/LMS", 15000, 4);
    		}
    		case 3:
    		{
    			inlms[playerid] = 1;
    			lmsstarted = 1;
    			lmsplace = 3;
    			SetTimer("StartLastManStanding", 60000, false);
    			SendClientMessageToAll_(-1, "{8000ff}Player counting for Last Man Standing started. Use {ffffff}'/lms'{8000ff} to join.");
    			SendClientMessageToAll_(-1, "{8000ff}Last Man Standing will start in a minute. Stay tuned!!!");
    			GameTextForAll("Last Man Standing counting started!!!~n~/LMS", 15000, 4);
    		}
    		case 4:
    		{
    			inlms[playerid] = 1;
    			lmsstarted = 1;
    			lmsplace = 4;
    			SetTimer("StartLastManStanding", 60000, false);
    			SendClientMessageToAll_(-1, "{8000ff}Player counting for Last Man Standing started. Use {ffffff}'/lms'{8000ff} to join.");
    			SendClientMessageToAll_(-1, "{8000ff}Last Man Standing will start in a minute. Stay tuned!!!");
    			GameTextForAll("Last Man Standing counting started!!!~n~/LMS", 15000, 4);
    		}
    		default:
    		{
    			Dialog_Show(playerid, DIALOG_LMS_PLACE, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Last Man Standing", "{e9967a}ID\tPlace\n\n{ff0000}1\t{ffffff}Jefforson Motel\n{ff0000}2\t{ffffff}RC Battlefield\n{ff00000}3\t{ffffff}Russian Mafia Base\n{ff0000}4\t{ffffff}Valle Ocultado", "Enter", "Close");
    			SendClientMessage(playerid, -1, "{ff0000}Invalid selection.");
    		}
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
			Dialog_Show(playerid, DIALOG_GANG_ENTER_NAME, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Create a gang (Step - 1)", "{ffffff}Insert the {ffff00}name of the {7fff00}gang {ffffff}that you want to create\n\n{ff0000}[ Note ] {ffffff}Name length should in between 6 - 29", "Enter", "Close");
			SendClientMessage(playerid, -1, "{ff0000}Name length of the gang should in between 6 - 29.");
		}
		else 
		{
			if(!IsValidGangNameOrTag(inputtext)) 
			{
				Dialog_Show(playerid, DIALOG_GANG_ENTER_NAME, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Create a gang (Step - 1)", "{ffffff}Insert the {ffff00}name of the {7fff00}gang {ffffff}that you want to create\n\n{ff0000}[ Note ] {ffffff}Name length should in between 6 - 29", "Enter", "Close");
				return SendClientMessage(playerid, -1, "{ff0000}This gang name contains invalid characters.");
			}
			format(tempgname[playerid], 30, "%s", inputtext);
			strreplace(tempgname[playerid], " ", "_");
			for(new i = 0; i < MAX_GANGS; i++)
			{
				if(IsValidGang(i))
				{
					if(isequal(tempgname[playerid], ganginfo[i][gname], true))
					{
						Dialog_Show(playerid, DIALOG_GANG_ENTER_NAME, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Create a gang (Step - 1)", "{ffffff}Insert the {ffff00}name of the {7fff00}gang {ffffff}that you want to create\n\n{ff0000}[ Note ] {ffffff}Name length should in between 6 - 29", "Enter", "Close");
						return SendClientMessage(playerid, -1, "{ff0000}A gang with this name already exists.");
					}
				}
			}
			Dialog_Show(playerid, DIALOG_GANG_ENTER_TAG, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Create a gang (Step - 2)", "{ffffff}Insert a name to display as the {ffff00}tag of the {7fff00}gang\n{ff0000}[ Example ] {ffffff}Tag {ffff00}\"HlF\" {ffffff}for a gang named {ffff00}\"Hopeless Fighters\"\n\n{ff0000}[ Note ] {ffffff}Tag length should in between 2 - 4", "Enter", "Close");
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
			SendClientMessage(playerid, -1, "{ff0000}Name length of the tag should in between 3 - 4.");
			Dialog_Show(playerid, DIALOG_GANG_ENTER_TAG, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Create a gang (Step - 2)", "{ffa500}LGGW {ffffff}- Create a gang (Step - 2).", "{ffffff}Insert a name to display as the {ffff00}tag of the {7fff00}gang\n{ff0000}[ Example ] {ffffff}Tag {ffff00}\"HlF\" {ffffff}for a gang named {ffff00}\"Hopeless Fighters\"\n\n{ff0000}[ Note ] {ffffff}Tag length should in between 2 - 4", "Enter", "Close");
		}
		else
		{
			if(!IsValidGangNameOrTag(inputtext)) 
			{
				Dialog_Show(playerid, DIALOG_GANG_ENTER_TAG, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Create a gang (Step - 2)", "{ffffff}Insert a name to display as the {ffff00}tag of the {7fff00}gang\n{ff0000}[ Example ] {ffffff}Tag {ffff00}\"HlF\" {ffffff}for a gang named {ffff00}\"Hopeless Fighters\"\n\n{ff0000}[ Note ] {ffffff}Tag length should in between 2 - 4", "Enter", "Close");
				return SendClientMessage(playerid, -1, "{ff0000}This gang tag contains invalid characters.");
			}

			format(tempgtag[playerid], 30, "%s", inputtext);
			strreplace(tempgtag[playerid], " ", "_");
			
			for(new i = 0; i < MAX_GANGS; i++)
			{
				if(IsValidGang(i))
				{
					if(isequal(tempgtag[playerid], ganginfo[i][gtag], true))
					{
						Dialog_Show(playerid, DIALOG_GANG_ENTER_TAG, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Create a gang (Step - 2)", "{ffa500}LGGW {ffffff}- Create a gang (Step - 2)", "{ffffff}Insert a name to display as the {ffff00}tag of the {7fff00}gang\n{ff0000}[ Example ] {ffffff}Tag {ffff00}\"HlF\" {ffffff}for a gang named {ffff00}\"Hopeless Fighters\"\n\n{ff0000}[ Note ] {ffffff}Tag length should in between 2 - 4", "Enter", "Close");
						return SendClientMessage(playerid, -1, "{ff0000}A gang with this tag already exists.");
					}
				}
			}

			new str[256];
			format(str, sizeof(str), "{fffffF}~ {ffff00}Gang Confirmation {ffffff}~\n\n{ff0000}Your gang Info...\n{7fff00}Gang name: {ffffff}%s\n{7f0000}Gang tag: {ffffff}%s\n\n{ff0000}[ Note ] {ffffff}This action is {ff0000}irreversable\n{ffffff}This will cost {ff0000}$%d {ffffff}and look again what you have entered", ReplaceUwithS(tempgname[playerid]), ReplaceUwithS(tempgtag[playerid]), MIN_CASH_TO_CREATE_A_GANG);
			Dialog_Show(playerid, DIALOG_GANG_CONFIRMATION, DIALOG_STYLE_MSGBOX, "{ffa500}LGGW {ffffff}- Create a gang (Step - 3)", str, "Create", "Close");
		}
	}
	else Dialog_Close(playerid);
	return 1;
}


Dialog:DIALOG_GANG_CONFIRMATION(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(GetPlayerInterior(playerid) > 0) return SendClientMessage(playerid, -1, "{ff0000}You are in an interior.");
		if(userinfo[playerid][ingang] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a gang.");

		if(GetPlayerCash(playerid) < MIN_CASH_TO_CREATE_A_GANG) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to create a gang");
		GivePlayerCash(playerid, -MIN_CASH_TO_CREATE_A_GANG);
		new str[300];
		
		new key = GetLastGangID();
        mysql_format(Database, str, sizeof(str), "UPDATE `Gangs` SET `Name` = '%e', `Tag` = '%e' WHERE `Gang_ID`  = %d LIMIT 1", tempgname[playerid], tempgtag[playerid], key + 1);
		mysql_query(Database, str, false);
		
		LoadGangData(key);

		userinfo[playerid][ingang] = 1;
		userinfo[playerid][gid] = key;
		userinfo[playerid][glevel] = 4;
		userinfo[playerid][gskin] = 1;

		SetPlayerTeam(playerid, key);
		SetPlayerColor(playerid, ganginfo[key][gcolor]);
		SetPlayerSkin(playerid, userinfo[playerid][gskin]);

		
		Delete3DTextLabel(glabel[playerid]); 
		format(str, sizeof(str), "| %s |", ganginfo[key][gtag]);
		glabel[playerid] = Create3DTextLabel(str, ganginfo[key][gcolor], 0.0, 0.0, 0.0, 50.0, 0);
		Attach3DTextLabelToPlayer(glabel[playerid], playerid, 0.0, 0.0, 0.3);

		mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `In_gang` = 1, `Gang_ID` = %d, `Gang_level` = 4, `Gang_skin` = 1 WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][gid], userinfo[playerid][pid]);
		mysql_tquery(Database, str);
	}
	else Dialog_Close(playerid);
	return 1;
}

Dialog:DIALOG_GANG_WARNING(playerid, response, listitem, inputtext[])
{
	if(response) PC_EmulateCommand(playerid, "/gang destroy");
	else Dialog_Close(playerid);
	return 1;
}

Dialog:DIALOG_GANG_COLOR(playerid, response, listitem, inputtext[])
{
	new str[128];
	if(response)
	{
		new tempgcolor;
		switch(strval(inputtext))
		{
			case 1: tempgcolor = 0x696969ff;
			case 2: tempgcolor = 0x2f4f4fff;
			case 3: tempgcolor = 0xf0e68cff;
			case 4: tempgcolor = 0xff0000ff;
			case 5: tempgcolor = 0xFF6347ff;
			case 6: tempgcolor = 0xff69b4ff;
			case 7: tempgcolor = 0x8b4513ff;
			case 8: tempgcolor = 0xf5deb3ff;
			case 9: tempgcolor = 0xb22222ff;
			case 10: tempgcolor = 0x9370dbff;
			case 11: tempgcolor = 0xc1cdc1ff;
			case 12: tempgcolor = 0x000033ff;
			case 13: tempgcolor = 0x6495edff;
			case 14: tempgcolor = 0x7cfc00ff;
			case 15: tempgcolor = 0x556b2fff;
			default:
		    {
				SendClientMessage(playerid, -1, "{ff0000}Invalid selection.");
                PC_EmulateCommand(playerid, "/gang color");
			}
		}
        
		if(tempgcolor == ganginfo[userinfo[playerid][gid]][gcolor]) return SendClientMessage(playerid, -1, "{ff0000}Your gang already own this colour.");
		if(GetPlayerCash(playerid) < MIN_CASH_TO_CHANGE_GANG_COLOR) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy this color (amount - $"#MIN_CASH_TO_CHANGE_GANG_COLOR").");
		
        new c, bossgang = -1;
        for(new g = 0; g < MAX_GANGS; g++)
		{
			if(IsValidGang(g))
			{
				if(ganginfo[g][gcolor] == tempgcolor && g != userinfo[playerid][gid] && ganginfo[userinfo[playerid][gid]][gscore] <= ganginfo[g][gscore]) 
				{   
					format(str, sizeof(str), "{ff0000}This gang colour is owned by \"%s[%d]\" which has a higher gang score than your gang.", ReplaceUwithS(ganginfo[g][gname]), g);
					return SendClientMessage(playerid, -1, str);
				}
				else if(ganginfo[g][gcolor] == tempgcolor && g != userinfo[playerid][gid] && ganginfo[userinfo[playerid][gid]][gscore] > ganginfo[g][gscore]) 
				{ 
					bossgang = g;
                    break;
				}
			}
		}

        if(bossgang != -1)
        {
            ganginfo[bossgang][gcolor] = 0xFFFFFFFF;
            foreach(new k : Player)
            {
                if(userinfo[k][gid] == bossgang && !IsPlayerInClassSelection(k))
                {
                    Delete3DTextLabel(glabel[k]); 
                    format(str, sizeof(str), "| %s |", ganginfo[bossgang][gtag]);
                    glabel[k] = Create3DTextLabel(str, ganginfo[bossgang][gcolor], 0.0, 0.0, 0.0, 50.0, 0);
                    Attach3DTextLabelToPlayer(glabel[k], k, 0.0, 0.0, 0.3);

                    if(inminigame[k] == 0) SetPlayerColor(k, ganginfo[bossgang][gcolor]);
                    else COLOR[k] =  ganginfo[bossgang][gcolor];
                }
            }
            for(new i = 0; i < sizeof(zoneinfo); i++)
            {
                if(zoneinfo[i][zteamid] == bossgang) GangZoneShowForAll(ZONEID[i], Zone_ColorAlpha(ganginfo[zoneinfo[i][zteamid]][gcolor]));
            }
            if(ganginfo[bossgang][ghouse] == 1)
            {        
                c = ganginfo[bossgang][ghouseid];
                Delete3DTextLabel(hlabel[c]);
                format(str, sizeof(str), "[Head Qauters]\n%s", ReplaceUwithS(ganginfo[houseinfo[c][hteamid]][gname]));
                hlabel[c] = Create3DTextLabel(str, ganginfo[bossgang][gcolor], houseinfo[c][entercp][0], houseinfo[c][entercp][1], houseinfo[c][entercp][2], 50.0, 0, 0);
            }

            mysql_format(Database, str, sizeof(str), "UPDATE `Gangs` SET `Color` = %d WHERE `Gang_ID` = %d LIMIT 1", ganginfo[bossgang][gcolor], bossgang + 1);
            mysql_tquery(Database, str);
        }

		ganginfo[userinfo[playerid][gid]][gcolor] = tempgcolor;
		GivePlayerCash(playerid, -MIN_CASH_TO_CHANGE_GANG_COLOR);
		foreach(new j : Player)
		{
			if(userinfo[j][gid] == userinfo[playerid][gid] && !IsPlayerInClassSelection(j))
			{
				Delete3DTextLabel(glabel[j]); 
				format(str, sizeof(str), "| %s |", ganginfo[userinfo[playerid][gid]][gtag]);
				glabel[j] = Create3DTextLabel(str, ganginfo[userinfo[playerid][gid]][gcolor], 30.0, 40.0, 50.0, 50.0, 0);
				Attach3DTextLabelToPlayer(glabel[j], j, 0.0, 0.0, 0.3);
				
				if(inminigame[j] == 0) SetPlayerColor(j, ganginfo[userinfo[playerid][gid]][gcolor]);
				else COLOR[j] =  ganginfo[userinfo[playerid][gid]][gcolor];
			}
		}
		
		for(new i = 0; i < sizeof(zoneinfo); i++)
		{
			if(zoneinfo[i][zteamid] == userinfo[playerid][gid])
			{
				GangZoneShowForAll(ZONEID[i], Zone_ColorAlpha(ganginfo[zoneinfo[i][zteamid]][gcolor]));
			
            }
		}

		if(ganginfo[userinfo[playerid][gid]][ghouse] == 1)
		{
			c = ganginfo[userinfo[playerid][gid]][ghouseid];
			Delete3DTextLabel(hlabel[c]);
			format(str, sizeof(str), "[Head Qauters]\n%s", ReplaceUwithS(ganginfo[houseinfo[c][hteamid]][gname]));
			hlabel[c] = Create3DTextLabel(str, ganginfo[houseinfo[c][hteamid]][gcolor], houseinfo[c][entercp][0], houseinfo[c][entercp][1], houseinfo[c][entercp][2], 50.0, 0, 0);
		}

		mysql_format(Database, str, sizeof(str), "UPDATE `Gangs` SET `Color` = %d WHERE `Gang_ID` = %d LIMIT 1", ganginfo[userinfo[playerid][gid]][gcolor], userinfo[playerid][gid] + 1);
		mysql_tquery(Database, str);
        
	}
	else Dialog_Close(playerid);
	return 1;
}

Dialog:DIALOG_SELL_HOUSE(playerid, response, listitem, inputtext[])
{
	if(!response) return Dialog_Close(playerid);
	if(response)
	{
		Delete3DTextLabel(hlabel[ganginfo[userinfo[playerid][gid]][ghouseid]]);
		hlabel[ganginfo[userinfo[playerid][gid]][ghouseid]] = Create3DTextLabel("{FF6347}[Head Qauters]\n* Unowned", -1, houseinfo[ganginfo[userinfo[playerid][gid]][ghouseid]][entercp][0], houseinfo[ganginfo[userinfo[playerid][gid]][ghouseid]][entercp][1], houseinfo[ganginfo[userinfo[playerid][gid]][ghouseid]][entercp][2], 50.0, 0, 0);
		
		DestroyDynamicMapIcon(houseinfo[ganginfo[userinfo[playerid][gid]][ghouseid]][icon_id]);  
		houseinfo[ganginfo[userinfo[playerid][gid]][ghouseid]][icon_id] = CreateDynamicMapIcon(houseinfo[ganginfo[userinfo[playerid][gid]][ghouseid]][entercp][0], houseinfo[ganginfo[userinfo[playerid][gid]][ghouseid]][entercp][1], houseinfo[ganginfo[userinfo[playerid][gid]][ghouseid]][entercp][2], 31, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
		
		SendClientMessage(playerid, -1, "{9370db}You sold the Gang House.");
		
		ganginfo[userinfo[playerid][gid]][ghouse] = 0;
		houseinfo[ganginfo[userinfo[playerid][gid]][ghouseid]][howned] = 0; 

		new str[129];
		mysql_format(Database, str, sizeof(str), "UPDATE `Gangs` SET `HQ` = 0, `HQ_ID` = -1 WHERE `Gang_ID` = %d LIMIT 1", userinfo[playerid][gid] + 1);
		mysql_tquery(Database, str);

		mysql_format(Database, str, sizeof(str), "UPDATE `Houses` SET `House_owned` = 0, `House_owned_team_ID` = -1 WHERE `House_ID` = %d LIMIT 1", ganginfo[userinfo[playerid][gid]][ghouseid] + 1);
		mysql_tquery(Database, str);
	}
	return 1;
}

Dialog:DIALOG_BUY_HOUSE(playerid, response, listitem, inputtext[])
{
	if(!response) return Dialog_Close(playerid);
	if(response)
	{
		new id = -1;
		for(new i = 0; i < sizeof(houseinfo); i++) if(IsPlayerInDynamicCP(playerid, STREAMER_TAG_CP GENTERCP[i])) id = i;
		if(isequal(inputtext, "1"))
		{
			SetPlayerPos(playerid, houseinfo[id][enterpos][0], houseinfo[id][enterpos][1], houseinfo[id][enterpos][2]);
			SetPlayerFacingAngle(playerid, houseinfo[id][enterpos][3]);
			SetPlayerInterior(playerid, houseinfo[id][hintid]);
			SetPlayerVirtualWorld(playerid, playerid + 1);
		}
		else if(isequal(inputtext, "2"))
		{
			new i = id;
			if(houseinfo[i][howned] == 1 &&  ganginfo[houseinfo[i][hteamid]][gscore] >= ganginfo[userinfo[playerid][gid]][gscore]) return SendClientMessage(playerid, -1, "{ff0000}This house is owned by a gang that has a higher score than your gang (use \"/top\" and select \"Top Gangs\" to view gang ranks).");
			else if(GetPlayerCash(playerid) < houseinfo[i][hprice]) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!");
			else
			{
				if(houseinfo[i][howned] == 1) ganginfo[houseinfo[i][hteamid]][ghouse] = 0;
	 
				GivePlayerCash(playerid, -houseinfo[i][hprice]);
				SendClientMessage(playerid, -1, "{9370db}You bought a new Gang House.");
				houseinfo[i][howned] = 1;
				houseinfo[i][hteamid] = userinfo[playerid][gid];

				new str[128];
				format(str, sizeof(str), "[Head Qauters]\n%s", ReplaceUwithS(ganginfo[houseinfo[i][hteamid]][gname]));
	 
				Delete3DTextLabel(hlabel[i]);
				hlabel[i] = Create3DTextLabel(str, ganginfo[houseinfo[i][hteamid]][gcolor], houseinfo[i][entercp][0], houseinfo[i][entercp][1], houseinfo[i][entercp][2], 50.0, 0, 0);
	 
				ganginfo[userinfo[playerid][gid]][ghouse] = 1;
				ganginfo[userinfo[playerid][gid]][ghouseid] = i;
				  
				DestroyDynamicMapIcon(houseinfo[i][icon_id]);  
				houseinfo[i][icon_id] = CreateDynamicMapIcon(houseinfo[i][entercp][0], houseinfo[i][entercp][1], houseinfo[i][entercp][2], 32, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
				 
				mysql_format(Database, str, sizeof(str), "UPDATE `Gangs` SET `HQ` = 1, `HQ_ID` = %d WHERE `Gang_ID` = %d LIMIT 1", i, userinfo[playerid][gid] + 1);
				mysql_tquery(Database, str);

				mysql_format(Database, str, sizeof(str), "UPDATE `Houses` SET `House_owned` = 1, `House_owned_team_ID` = %d WHERE `House_ID` = %d LIMIT 1", userinfo[playerid][gid], i + 1);
				mysql_tquery(Database, str);
			}
		}
		else
		{
			new str[1024], dialog[1024];
			strcat(str, "{ffff00}                 Gang House - %d                \n\n");
            strcat(str, "{ffffff}* {7fff00}You can select options by entering option IDs \n");
            strcat(str, "{ffffff}* {7fff00}Use 'preview' to ensure this is the house you \n");
            strcat(str, "  want                                          \n");
            strcat(str, "{ffffff}* {7fff00}Check out the price before purchase           \n");
            strcat(str, "{ffffff}* {7fff00}You will recieve only half of the price if you\n");
            strcat(str, "  sell this house after purchase                \n");
            strcat(str, "{ffff00}------------------------------------------------\n");
            strcat(str, "{ffffff}- Interior type: {ffff00}%s                             \n");
            strcat(str, "{ffffff}- Exterior type: {ffff00}%s                             \n");
            strcat(str, "{ffffff}- Price: {ffff00}$%d                                    \n");
            strcat(str, "{ffff00}------------------------------------------------\n");
            strcat(str, "  {e9967a}ID                        Option              \n");
            strcat(str, "  {ff0000}1                         {ffffff}Preview             \n"); 
            strcat(str, "  {ff0000}2                         {ffffff}Purchase            \n");
            strcat(str, "{ff0000}[ Note ] {ffffff}Purchasing action is irreversable      \n");
			format(dialog, sizeof(dialog), str, id, houseinfo[id][hinttype], houseinfo[id][hextype], houseinfo[id][hprice]);
			Dialog_Show(playerid, DIALOG_SELL_HOUSE, DIALOG_STYLE_MSGBOX, "{ffa500}LGGW {ffffff}- Gang House Info & Options", dialog, "Enter", "Close");
			return SendClientMessage(playerid, -1, "{ff0000}Invalid selection.");
		}
	}
	return 1;
}


Dialog:DIALOG_AFUNCS(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new str[1024];
		if(userinfo[playerid][plevel] == 1)
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Back", "Close");
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Close");
				af_page[playerid] = 1;
			}
		}
		else if(userinfo[playerid][plevel] == 2)
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Back");
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Back", "Close");
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Back");
				af_page[playerid] = 2;
			}
		}
		else if(userinfo[playerid][plevel] == 3)
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Back");
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Back");
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Back", "Close");
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Back");
				af_page[playerid] = 3;
			}
		}
		else if(userinfo[playerid][plevel] == 4)
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Back");
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Back");
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Back");
				af_page[playerid] = 4;
			}
			else if(af_page[playerid] == 4)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/setlevel\t/setlevel <id>\tSets the level of a given player\n", sizeof(str));  
				strcat(str,"/spawnall\tNone\tSpawn all the online players\n", sizeof(str)); 
				strcat(str,"/killall\tNone\tKill all the online players\n", sizeof(str)); 
				strcat(str,"/givepriveh\t/givepriveh <name>\tGive a personal vehicle to a player\n", sizeof(str)); 
				strcat(str,"/a4\t/a4 <text>\tAdmin chat for level 4 and above", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Back", "Close");
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Back");
				af_page[playerid] = 4;
			}
		}
		else if(userinfo[playerid][plevel] == 5)
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Back");
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Back");
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Back");
				af_page[playerid] = 4;
			}
			else if(af_page[playerid] == 4)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/setlevel\t/setlevel <id>\tSets the level of a given player\n", sizeof(str));  
				strcat(str,"/spawnall\tNone\tSpawn all the online players\n", sizeof(str)); 
				strcat(str,"/killall\tNone\tKill all the online players\n", sizeof(str)); 
				strcat(str,"/givepriveh\t/givepriveh <name>\tGive a personal vehicle to a player\n", sizeof(str)); 
				strcat(str,"/a4\t/a4 <text>\tAdmin chat for level 4 and above", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Back");
				af_page[playerid] = 5;
			}
			else if(af_page[playerid] == 5)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/a5\t/a5 <text>\tAdmin chat for level 5 Admins", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Back", "Close");
				af_page[playerid] = 6;
			}
			else if(af_page[playerid] == 6)
			{
				strcat(str,"Command\tParameters\tFunction\n", sizeof(str));
				strcat(str,"/setlevel\t/setlevel <id>\tSets the level of a given player\n", sizeof(str));  
				strcat(str,"/spawnall\tNone\tSpawn all the online players\n", sizeof(str)); 
				strcat(str,"/killall\tNone\tKill all the online players\n", sizeof(str)); 
				strcat(str,"/givepriveh\t/givepriveh <name>\tGive a personal vehicle to a player\n", sizeof(str)); 
				strcat(str,"/a4\t/a4 <text>\tAdmin chat for level 4 and above", sizeof(str));
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Back");
				af_page[playerid] = 5;
			} 
		}
	}
	else
	{
		new str[1024];
		if(userinfo[playerid][plevel] == 1)
		{
			return Dialog_Close(playerid);
		}
		else if(userinfo[playerid][plevel] == 2)
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Close");
				af_page[playerid] = 1;
			}
			else if(af_page[playerid] == 3)
			{
				return Dialog_Close(playerid);
			}
		}
		else if(userinfo[playerid][plevel] == 3)
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Close");
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Back");
				af_page[playerid] = 2;
			}
			else if(af_page[playerid] == 4)
			{
				return Dialog_Close(playerid);
			}
		}
		else if(userinfo[playerid][plevel] == 4)
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Close");
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Back");
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Back");
				af_page[playerid] = 3;
			}
			else if(af_page[playerid] == 5)
			{
				return Dialog_Close(playerid);
			}
		}
		else if(userinfo[playerid][plevel] == 5)
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Close");
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Back");
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Back");
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
				Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Back");
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
		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You are in a vehicle.");
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
		if(listitem > 6)
		{
			new laststr[1024], val = 6, name[24], str[128];
			for(new i = 7; i < MAX_GANGS; i++)
			{
				if(IsValidGang(i))
				{
                    val ++;
					if(val == listitem)
					{
						val = i;
						break;
					}
				}

			}
			
			strcat(laststr, "{ffffff}Member\t\tGang level\n", sizeof(laststr));
			mysql_format(Database, str, sizeof(str), "SELECT `Name`, `Gang_level` FROM `Users` WHERE `Gang_ID` = %d AND `In_gang` = 1 ORDER BY `Gang_level` DESC LIMIT "#MAX_GANG_MEMBERS"", val);
			new Cache:r = mysql_query(Database, str);

            printf("Gang_ID - %i", val);

            new rows;
            cache_get_row_count(rows);
            for(new j = 0; j < rows; j++)
            {
                cache_get_value_name(j, "Name", name, sizeof(name));
                cache_get_value_name_int(j, "Gang_level", val);
                switch(val)
                {
                    case 1: format(str, sizeof(str), "{ffffff}%s\t\t%s\n", name, GangLevelName(val));
                    case 2: format(str, sizeof(str), "{e9967a}%s\t\t%s\n", name, GangLevelName(val));
                    case 3: format(str, sizeof(str), "{ffa500}%s\t\t%s\n", name, GangLevelName(val));
                    case 4: format(str, sizeof(str), "{ff0000}%s\t\t%s\n", name, GangLevelName(val));
                }
                strcat(laststr, str, sizeof(laststr));
            }
			
            cache_delete(r);

			format(str, sizeof(str), "{ffa500}LGGW {ffffff}- Gangs - %s - Members", ReplaceUwithS(ganginfo[val][gname]));
			Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_MSGBOX, str, laststr, "Close", "");
		}
		else
		{
			SendClientMessage(playerid, -1, "{ff0000}Only custom gangs have gang members.");
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
			Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_MSGBOX, "{ffa500}LGGW {ffffff}- Logs", comp, "Close", "");
		}
		else
		{
			SendClientMessage(playerid, -1, "{ff0000}This Log is empty!");
			return PC_EmulateCommand(playerid, "/readlogs");
		}
	}
	else return Dialog_Close(playerid);
	return 1;
}

Dialog:DIALOG_BUY_SHOP(playerid, response, listitem, inputtext[])
{
	new str[512], Float:hp;
	GetPlayerHealth(playerid, hp);
	strcat(str, "{e9967a}ID\tMeal         \tPrice\n\n");
	strcat(str, "{ff0000}1 \t{ffffff}Large        \t$750\n");
	strcat(str, "{ff0000}2 \t{ffffff}Hot & spicy  \t$400\n");
	strcat(str, "{ff0000}3 \t{ffffff}Jumbo chicken\t$150\n\n");
	strcat(str, "{ff0000}[ Note ] {ffffff}Large - {ffff00}Increase your health by 100%\n");
	strcat(str, "         {ffffff}Hot & spicy - {ffff00}Increase your health by 75%\n"); 
	strcat(str, "         {ffffff}Jumbo chicken - {ffff00}Increase your health by 50%\n");
	if(!response) Dialog_Close(playerid);
	else
	{
		Dialog_Show(playerid, DIALOG_BUY_SHOP, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Restaurant", str, "purchase", "Close");
		if(isequal(inputtext, "1"))
		{
			if(GetPlayerCash(playerid) < 150)
			{
				SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!");
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
			if(GetPlayerCash(playerid) < 150)
			{
				SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!");
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
			if(GetPlayerCash(playerid) < 150)
			{
				SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!");
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
			SendClientMessage(playerid, -1, "{ff0000}Invalid selection.");
			return PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
		}
	}
	return 1;
}

//Commands
CMD:spec(playerid, params[])
{
	new id;
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
	if(spec[playerid] || GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) return SendClientMessage(playerid, -1, "{ff0000}You are spectating at the moment");		
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "/spec <id>");	
	if(!IsPlayerConnected(id))	 return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(id == playerid) return SendClientMessage(playerid, -1, "{ff0000}You can't spectate yourself.");
	if(GetPlayerState(id) == PLAYER_STATE_SPECTATING) return SendClientMessage(playerid, -1, "{ff0000}Player is spectating someone at the moment.");
	
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
	if(!spec[playerid]) return SendClientMessage(playerid, -1, "{ff0000}You are not spectating at the moment.");	
	TogglePlayerSpectating(playerid, 0);
	return 1;
}

CMD:zones(playerid, params[])
{
	new s_[1500], tmp[248];
	for(new i = 0; i < sizeof(zoneinfo); i ++)
	{
		if(i == 0) format(tmp, sizeof(tmp), "Zone\tController\n%s\t%s\n", ReplaceUwithS(zoneinfo[i][zname]), ReplaceUwithS(ganginfo[zoneinfo[i][zteamid]][gname]));
		else if (i != (sizeof(zoneinfo) - 1)) format(tmp, sizeof(tmp), "%s\t%s\n", ReplaceUwithS(zoneinfo[i][zname]), ReplaceUwithS(ganginfo[zoneinfo[i][zteamid]][gname]));
		else format(tmp, sizeof(tmp), "%s\t%s", ReplaceUwithS(zoneinfo[i][zname]), ReplaceUwithS(ganginfo[zoneinfo[i][zteamid]][gname]));
		strcat(s_, tmp, sizeof(s_));
	}
	Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Zones", s_, "Close", "");
	return 1;
}

CMD:turfs(playerid, params[])
{
	new completed[1024], str[200], name_[30], rows, val;
	strcat(completed, "Gang\tTurfs\n", sizeof(completed));
	cache_get_row_count(rows);
	new Cache:r = mysql_query(Database, "SELECT `Name`,`Turfs` FROM `Gangs` WHERE `Name` != '-1' AND `Turfs` != '0' ORDER BY `Turfs` DESC");
	for(new a; a < rows; a++) 
	{ 
		cache_get_value_name(a, "Name", name_, sizeof(name_));
		cache_get_value_name_int(a, "Turfs", val);
		strreplace(name_, "_", ""); 
		format(str, sizeof(str), "%s\t%d\n", name_, val); 
		strcat(completed, str, sizeof(completed));
	}     
    cache_delete(r);                                      
	Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Turfs", completed, "Close", "");
	return 1;
}

CMD:gangs(playerid, params[])
{
	new str[1024], gstr[128];
	for(new i = 0; i < MAX_GANGS; i++)
	{
		if(IsValidGang(i))
		{
			format(gstr, sizeof(gstr), "%d\t%s\n", i, ReplaceUwithS(ganginfo[i][gname]));
			strcat(str, gstr, sizeof(str));
		}
	}
	new completed[1024 + 50];
	format(completed, sizeof(completed), "Gang ID\tName\n%s", str);
	Dialog_Show(playerid, DIALOG_GANGS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Gangs", completed, "Select", "Close");
	SendClientMessage(playerid, -1, "{1e90ff}Click on any gang to view it's members.");
	return 1;
}

CMD:gstats(playerid, params[])
{
	new id, str[1200];
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{FF69B4}/gstats <id>");
	if(!IsValidGang(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid gang ID.");
	if(ganginfo[id][gdeaths] == 0) format(str, sizeof(str), "{%06x}%s {ffffff}[%d]\n\n{ffffff}Score earned: {ff0000}%d\nffffffGang kills: {ff0000}%d\n{ffffff}Gang deaths: {ff0000}%d\n{ffffff}Gang KDR: {ff0000}0.00\n{ffffff}Turfs controlled: {ff0000}%d", ganginfo[id][gcolor] >> 8, ReplaceUwithS(ganginfo[id][gname]), id, ganginfo[id][gscore], ganginfo[id][gkills], ganginfo[id][gdeaths], ganginfo[id][gturfs]);
	else format(str, sizeof(str), "%s [%d]\n\nScore earned: %d\nGang kills: %d\nGang deaths: %d\nGang KDR: %.2f\nTurfs controlled: %d", ReplaceUwithS(ganginfo[id][gname]), id, ganginfo[id][gscore], ganginfo[id][gkills], ganginfo[id][gdeaths], floatdiv(ganginfo[id][gkills], ganginfo[id][gdeaths]), ganginfo[id][gturfs]);
	Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_MSGBOX, "{ffa500}LGGW {ffffff}- Gang Statistics", str, "Close", "");
	return 1;
}

CMD:credits(playerid, params[])
{
	new str[1024];
	strcat(str, "{ffffff}- The people who are behind this {ff0000}strong effort {ffffff}-\n\n", sizeof(str));
	strcat(str, "{ffff00}Host provider:\n", sizeof(str)); 
    strcat(str, "{ffffff}Cypress\n\n", sizeof(str)); 
    strcat(str, "{ffff00}Coding:\n", sizeof(str));
	strcat(str, "{ffffff}GameOvr\n\n", sizeof(str)); 
	strcat(str, "{ffff00}Website/Forum/UCP:\n", sizeof(str)); 
	strcat(str, "{ffffff}_.EvilExecutor._\n\n", sizeof(str));  
	strcat(str, "{ffff00}Mapping:\n", sizeof(str)); 
	strcat(str, "{ffffff}Scorpion.\n\n", sizeof(str)); 
	strcat(str, "{ffff00}Beta Testing:\n", sizeof(str)); 
	strcat(str, "{ffffff}GameOvr\n", sizeof(str));  
	strcat(str, "_.EvilExecutor._\n", sizeof(str)); 
	strcat(str, "Scorpion.\n", sizeof(str));
	strcat(str, "Drayvox\n", sizeof(str));
	strcat(str, "Jithu\n", sizeof(str));
	strcat(str, "BloodHunter_\n\n", sizeof(str));
	strcat(str, "{ffff00}Other Contributors:\n", sizeof(str));
	strcat(str, "{ffffff}Husam_Haider\n", sizeof(str));
	strcat(str, "SoNu\n", sizeof(str));
	strcat(str, "realistik\n", sizeof(str));
	strcat(str, "hamz4\n\n", sizeof(str));
	strcat(str, "{ffa500}Special thanks to,\n", sizeof(str));
    strcat(str, "*{ff0000}\"Cypress\" {ffffff}for providing the HOST!\n", sizeof(str));
    strcat(str, "*{ff0000}\"Husam_Haider\" {ffffff}for providing a server for test runs!\n", sizeof(str));
    strcat(str, "*{ff0000}\"_.EvilExecutor._\" {ffffff}for the beautiful website, forum and UCP!\n", sizeof(str));
    strcat(str, "|-|{ffff00}Yes! there were many failiures{ffffff}! {ffff00}Yet we are up{ffffff}!!!\n\n", sizeof(str));
    strcat(str, "|-|{ff0000}Thanks for everyone who helped!", sizeof(str));
	Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_MSGBOX, "{ffa500}LGGW {ffffff}- Credits", str, "Close", "");          
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
	Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Commands", str, "Close", "");
	return 1;
}

CMD:help(playerid, params[])
{
	new str[2048];
	strcat(str, "Hey There,\n\n", sizeof(str));
	strcat(str, "\\cYou might be new here and wondering about what to do.\n", sizeof(str));
	strcat(str, "\\cYou may be dreaming high about being a Dominator in the server without knowing a shit!\n", sizeof(str)); 
	strcat(str, "\\cYeah dreaming high is good but you should know a few things before...\n", sizeof(str)); 
	strcat(str, "\\cNo Worries!\n", sizeof(str));
	strcat(str, "\\cYou can be your dream because we are here to help you with it.\n", sizeof(str));
	strcat(str, "\\cOkay enough introductions without wasting anymore time let's get started.\n", sizeof(str)); 
	strcat(str, "\\c(To know all the available commands use /cmds while /rules to know the rules)\n", sizeof(str));
	strcat(str, "\\cAs you all know in Gang Wars there are many things to cover.\n", sizeof(str)); 
	strcat(str, "\\cSo let's break it down to make you much more comfortable.\n\n", sizeof(str));
	strcat(str, "\t\t\t\t1. How to be the top killer(Includes how to DM and Duel)?\n", sizeof(str));
	strcat(str, "\t\t\t\t2. How to be the richest?\n", sizeof(str));
	strcat(str, "\t\t\t\t3. How can your gang rule Los Santos?\n", sizeof(str));
	strcat(str, "\t\t\t\t4. How to deal with Minigames?\n", sizeof(str));
	strcat(str, "\t\t\t\t5. How to be the knightrider of Los Santos?\n\n", sizeof(str));
	strcat(str, "\\c>> Once you finished reading these topics, We guarantee that you are ready to RULE Los Santos <<\n\n", sizeof(str));
	strcat(str, "\\c[ Just type the number in the below box and hit enter in order to get help regarding the topics above ]", sizeof(str));
	Dialog_Show(playerid, DIALOG_HELP, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Help", str, "Enter", "Close");
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
	Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Key Usage", str, "Close", "");
	return 1;
}

CMD:acmds(playerid, params[])
{
	new str[1024];
	if(userinfo[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(userinfo[playerid][plevel] >= 1)
	{
		strcat(str, "{1495CE}Trial Moderator\n\n", sizeof(str));
		strcat(str, "{ffffff}/onduty   /offduty   /a   /spawn   /sgg   /clearchat(cc)\n", sizeof(str));
		strcat(str, "{ffffff}/veh   /warn   /repair   /goto   /mute   /unmute\n", sizeof(str));
		strcat(str, "{ffffff}/getip   /getips   /a1   /acmds   /afuncs\n\n", sizeof(str));
	}
	if(userinfo[playerid][plevel] >= 2)
	{
		strcat(str, "{1495CE}Moderator\n\n", sizeof(str));
		strcat(str, "{ffffff}/kick   /get   /sethealth   /setarmour   /agivecash\n", sizeof(str)); 
		strcat(str, "{ffffff}/givegun   /jail   /unjail   /fine   /a2   /akill\n", sizeof(str)); 
		strcat(str, "{ffffff}/freeze   /unfreeze\n\n", sizeof(str)); 
	}
	if(userinfo[playerid][plevel] >= 3)
	{
		strcat(str, "{1495CE}Administrator\n\n", sizeof(str));
		strcat(str, "{ffffff}/ban   /oban   /unban   /setkills   /setdeaths   /setpass\n", sizeof(str));
		strcat(str, "{ffffff}/setname   /readlogs   /blockcmds   /unblockcmds   /fexitmg\n", sizeof(str));
		strcat(str, "{ffffff}/a3\n", sizeof(str)); 
	}
	if(userinfo[playerid][plevel] >= 4)
	{
		strcat(str, "{1495CE}Management Board\n\n", sizeof(str));
		strcat(str, "{ffffff}/setlevel   /spawnall   /killall   /givepriveh   /a4\n\n", sizeof(str));
	}
	if(userinfo[playerid][plevel] == 5)
	{
		strcat(str, "{1495CE}Developer\n\n", sizeof(str));
		strcat(str, "{ffffff}/a5\n\n", sizeof(str));
	}
	strcat(str, "*** Use /afuncs to see the relevent functions for commands\n", sizeof(str));
	strcat(str, "[ Note ] * Every inch of actions you take will be logged.\n", sizeof(str));
	strcat(str, "           So don't abuse Admin powers.\n", sizeof(str));
	strcat(str, "         * Never test Admin commands, Use them when necessary.", sizeof(str));
	Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_MSGBOX, "{ffa500}LGGW {ffffff}- Admin Commands", str, "Close", "");
	return 1;
}

CMD:afuncs(playerid, params[])
{
	new str[1024];
	if(userinfo[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
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
	Dialog_Show(playerid, DIALOG_AFUNCS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Admin Functions", str, "Next", "Close");
	af_page[playerid] = 1;
	return 1;
}

CMD:spawnall(playerid, params[])
{
	if(userinfo[playerid][plevel] < 4) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	foreach(new i : Player)
	{
		if(!IsPlayerInClassSelection(i))
		{
			if(IsPlayerSpawned(i)) SpawnPlayer(i);
		}
	}
	SendClientMessageToAll_(-1, "{eee8aa}An Admin has respawned everyone!");
	WriteLog(LOG_ADMINACTIONS, "COMMAND: spawnall | Admin: %s | Affected: All", userinfo[playerid][pname]);
	return 1;
}

CMD:killall(playerid, params[])
{
	if(userinfo[playerid][plevel] < 4) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	foreach(new i : Player)
	{
		if(!IsPlayerInClassSelection(i))
		{
			if(IsPlayerSpawned(i)) SetPlayerHealth(i, 0);
		}
	}
	SendClientMessageToAll_(-1, "{eee8aa}An Admin has killed everyone!");
	WriteLog(LOG_ADMINACTIONS, "COMMAND: killall | Admin: %s | Affected: All", userinfo[playerid][pname]);
	return 1;
}

CMD:blockcmds(playerid, params[]) 
{
	new id, str[128];
	if(userinfo[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{FF69B4}/blockcmds <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(id == playerid) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command on you.");
	if(userinfo[id][plevel] >= userinfo[playerid][plevel]) return SendClientMessage(playerid, -1, "{ff0000}Player you entered is at the same level or a higher level than you.");
	if(nocmd[id] == 1) return SendClientMessage(playerid, -1, "{ff0000}Commands are restricted for the player already.");
	SendClientMessage(id, -1, "{eee8aa}An Admin has blocked all the server commands for you.");
	format(str, sizeof(str), "{eee8aa}You restricted all server commands for {ffffff}\"%s[%d]\"{eee8aa}.", userinfo[id][pname], id);
	SendClientMessage(playerid, -1, str);
	nocmd[playerid] = 1;
	WriteLog(LOG_ADMINACTIONS, "COMMAND: unblockcmds | Admin: %s | Affected: %s", userinfo[playerid][pname], userinfo[id][pname]);
	return 1;
}

CMD:unblockcmds(playerid, params[])
{
	new id, str[128];
	if(userinfo[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{FF69B4}/unblockcmds <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(id == playerid) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command on you.");
	if(userinfo[playerid][jailed] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't unblock commands for a jailed player.");
	if(nocmd[id] == 1) return SendClientMessage(playerid, -1, "{ff0000}Commands are not restricted for the player.");
	if(userinfo[id][plevel] >= userinfo[playerid][plevel]) return SendClientMessage(playerid, -1, "{ff0000}Player you entered is at the same level or a higher level than you.");
	SendClientMessage(id, -1, "{eee8aa}An Admin has unblocked all server commands for you.");
	format(str, sizeof(str), "{eee8aa}You unblocked all the server commands for %s[%d].", userinfo[id][pname], id);
	SendClientMessage(playerid, -1, str);
	nocmd[playerid] = 1;
	WriteLog(LOG_ADMINACTIONS, "COMMAND: blockcmds | Admin: %s | Affected: %s", userinfo[playerid][pname], userinfo[id][pname]);
	return 1;
}

CMD:warn(playerid, params[])
{
	new id, str[256], message[256];
	if(userinfo[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "us[256]", id, message)) return SendClientMessage(playerid, -1, "{FF69B4}/warn <id> <message>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(id == playerid) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command on you.");
	if(userinfo[id][plevel] >= userinfo[playerid][plevel]) return SendClientMessage(playerid, -1, "{ff0000}Player you entered is at the same level or a higher level than you.");
	format(str, sizeof(str), "~r~WARNING!!!~n~~g~[%d/%d]", warns[id], MAX_WARNS);
	GameTextForPlayer(id, str, 10, 5);
	format(str, sizeof(str), "{eee8aa}You were warned by an Admin -> {ffffff}\"%s\".", message);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{eee8aa}You warned %s[%d] (warn: {ffffff}%s{eee8aa}).", userinfo[id][pname], id, message);
	SendClientMessage(id, -1, "{eee8aa}You will be kicked when the maximum warn limit reached.");
	SendClientMessage(playerid, -1, str);
	warns[id]++;
	if(warns[id] == MAX_WARNS)
	{
		format(str, sizeof(str), "* \"%s[%d]\" {FF8000}kicked from the Server (Exeeding Warn limit).", userinfo[id][pname], id);
		Kick(id);
	}
	WriteLog(LOG_ADMINACTIONS, "COMMAND: warn | Admin: %s | Affected: %s", userinfo[playerid][pname], userinfo[id][pname]);
	return 1;
}

CMD:repair(playerid, params[])
{
	if(userinfo[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{e60000}{ff0000}{FF6347}Invalid command.");
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFFFFFFFF, "{ff0000}You are not in a vehicle.");
	RepairVehicle(GetPlayerVehicleID(playerid));
	SendClientMessage(playerid, -1, "{eee8aa}Your vehicle has been successfully repaired.");
	WriteLog(LOG_ADMINACTIONS, "COMMAND: repair | Admin: %s | Affected: Self", userinfo[playerid][pname]);
	return 1;
}

CMD:fexitmg(playerid, params[])
{
	new id, str[128];
	if(userinfo[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "us[256]", id)) return SendClientMessage(playerid, -1, "{FF69B4}/fexitmg <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(id == playerid) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command on you.");
	if(inminigame[id] == 0) return SendClientMessage(playerid, -1, "{ff0000}Player is not in a Minigame.");
	if(userinfo[id][plevel] >= userinfo[playerid][plevel]) return SendClientMessage(playerid, -1, "{ff0000}Player you entered is at the same level or a higher level than you.");
	if(indm[id] == 1 || ingg[id] == 1)
	{
		PC_EmulateCommand(id, "/exit");
		SendClientMessage(playerid, -1, "{eee8aa}An admin has removed you from the Minigame.");
	}
	if(inlms[id] == 1)
	{
		inlms[id] = 0;
		inminigame[id] = 0;
		format(str, sizeof(str), "{8000ff}\"%s[%d]\" dropped out of LMS with {ffffff}%d {8000ff}kills {ffffff}(An Admin has removed the player from Minigame).", userinfo[playerid][pname], playerid, lmskills[playerid]);
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
			format(str, sizeof(str), "{8000ff}\"%s[%d]\" survived in the Last Man Standing with {ffffff}%d {8000ff}kills and won {ffffff}%d$ {8000ff}! {ffffff}Congratz!!!", userinfo[idx][pname], idx, lmskills[idx], MONEY_PER_LMS_KILL * lmskills[idx]);
			SendClientMessageToAll_(-1, str);
			lmsstarted = 0;
			inlms[idx] = 0;
			inminigame[idx] = 0;
			userinfo[idx][lmswon] ++;
			ResetPlayerWeapons(idx);
			SetPlayerDetails(idx);
			foreach(new k : Player)
			{
				SetPlayerMarkerForPlayer(k, idx, COLOR[idx]);
				SetPlayerMarkerForPlayer(k, playerid, COLOR[id]);
			}
			if(lmskills[idx] == 0) GivePlayerCash(idx, MONEY_PER_LMS_KILL / 2);
			else GivePlayerCash(idx, MONEY_PER_LMS_KILL * lmskills[playerid]);

			mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `LMS_won` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[idx][lmswon], userinfo[idx][pid]);
			mysql_tquery(Database, str);
		}
	}
	WriteLog(LOG_ADMINACTIONS, "COMMAND: fexitmg | Admin: %s | Affected: %s", userinfo[playerid][pname], userinfo[id][pname]);
	return 1;
}

CMD:a1(playerid, params[])
{
	new text[128], str[160];
	if(userinfo[playerid][muted] == 1)
	{
		format(str, sizeof(str), "{ff0000}You can't talk while you are muted (Remaining time: %d seconds).", userinfo[playerid][mutetime]);
		SendClientMessage(playerid, -1, str);
	} 
	if(userinfo[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, -1, "{FF69B4}/a1 <text>");
	format(str, sizeof(str), "[ /a1 | Level: %d ] %s[%d]: %s", userinfo[playerid][plevel], userinfo[playerid][pname], playerid, text);
	SendToAdmins(-1, str, 1);
	return 1;
}

CMD:a2(playerid, params[])
{
	new text[128], str[160];
	if(userinfo[playerid][muted] == 1)
	{
		format(str, sizeof(str), "{ff0000}You can't talk while you are muted (Remaining time: %d seconds).", userinfo[playerid][mutetime]);
		SendClientMessage(playerid, -1, str);
	} 
	if(userinfo[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, -1, "{FF69B4}/a2 <text>");
	format(str, sizeof(str), "[ /a2 | Level: %d ] %s[%d]: %s", userinfo[playerid][plevel], userinfo[playerid][pname], playerid, text);
	SendToAdmins(-1, str, 2);
	return 1;
}

CMD:a3(playerid, params[])
{
	new text[128], str[160];
	if(userinfo[playerid][muted] == 1)
	{
		format(str, sizeof(str), "{ff0000}You can't talk while you are muted (Remaining time: %d seconds).", userinfo[playerid][mutetime]);
		SendClientMessage(playerid, -1, str);
	} 
	if(userinfo[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, -1, "{FF69B4}/a3 <text>");
	format(str, sizeof(str), "[ /a3 | Level: %d ] %s[%d]: %s", userinfo[playerid][plevel], userinfo[playerid][pname], playerid, text);
	SendToAdmins(-1, str, 3);
	return 1;
}

CMD:a4(playerid, params[])
{
	new text[128], str[160];
	if(userinfo[playerid][muted] == 1)
	{
		format(str, sizeof(str), "{ff0000}You can't talk while you are muted (Remaining time: %d seconds).", userinfo[playerid][mutetime]);
		SendClientMessage(playerid, -1, str);
	} 
	if(userinfo[playerid][plevel] < 4) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, -1, "{FF69B4}/a4 <text>");
	format(str, sizeof(str), "[ /a4 | Level: %d ] %s[%d]: %s", userinfo[playerid][plevel], userinfo[playerid][pname], playerid, text);
	SendToAdmins(-1, str, 4);
	return 1;
}

CMD:a5(playerid, params[])
{
	new text[128], str[160];
	if(userinfo[playerid][muted] == 1)
	{
		format(str, sizeof(str), "{ff0000}You can't talk while you are muted (Remaining time: %d seconds).", userinfo[playerid][mutetime]);
		SendClientMessage(playerid, -1, str);
	} 
	if(userinfo[playerid][plevel] < 5) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, -1, "{FF69B4}/a5 <text>");
	format(str, sizeof(str), "[ /a5 | Level: %d ]  %s[%d]: %s", userinfo[playerid][plevel], userinfo[playerid][pname], playerid, text);
	SendToAdmins(-1, str, 5);
	return 1;
}

CMD:givepriveh(playerid, params[])
{
	new name[MAX_PLAYER_NAME], str[512], model, uid;
	if(userinfo[playerid][plevel] < 4) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "s["#MAX_PLAYER_NAME"]i", name, model)) return SendClientMessage(playerid, -1, "{FF69B4}/givepriveh <name> <model>");
	mysql_format(Database, str, sizeof(str), "SELECT * FROM Users WHERE `Name` = '%e' LIMIT 1", name);
	new Cache:r = mysql_query(Database, str);
	if(!cache_num_rows()){ 
		
        cache_delete(r); 
        return SendClientMessage(playerid, -1 , "{ff0000}Invalid player name (There's no such player registered)."); 
    }
    new v_owned;
    cache_get_value_name_int(0, "User_ID", uid);
    cache_delete(r);
    mysql_format(Database, str, sizeof(str), "SELECT * FROM User_Vehicles WHERE `User_ID` = '%d' LIMIT 1", uid);
    r = mysql_query(Database, str);
    cache_get_value_name_int(0, "Vehicle_owned", v_owned);
    cache_delete(r);
    if(v_owned == 1) return SendClientMessage(playerid, -1 , "{ff0000}This player already has a personal vehicle.");
	if(model != 567 && model != 567 && model != 534 && model != 402 && model != 558 && model != 562 && model != 560 && model != 506 && model != 415 && model != 541 && model != 471 && model != 462 && model != 463 && model != 468 && model != 461 && model != 581 && model != 521)
	{
		return SendClientMessage(playerid, -1, "{ff0000}Invalid personal vehicle model ID.");
	}

	new id = -1;
	foreach(new i : Player)
	{
		if(isequal(name, userinfo[i][pname]))
		{
			id = i;
			break;
		}
	}

	if(id != -1)
	{
		userinfo[id][vowned] = 1;
		userinfo[id][vmodel] = model;
		userinfo[id][vcolor_1] = 51;
		if(model != 541) userinfo[id][vcolor_2] = 51;
		else userinfo[id][vcolor_2] = 53;
		userinfo[id][vnitro] = -1;
		userinfo[id][vneon_1] = 0;
		userinfo[id][vneon_2] = 0;
		userinfo[id][vpjob] = 3;
		userinfo[id][vwheel] = 1077;
		userinfo[id][vhydra] = 0;
	}

	mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_owned` = 1, `Vehicle_model` = %d, `Vehicle_wheel` = 1077, `Vehicle_color_1` = 51, `Vehicle_color_2` = 53, \
		`Vehicle_neon_1` = 0, `Vehicle_neon_2` = 0, `Vehicle_paintjob` = 3, `Vehicle_nitro` = -1, `Vehicle_hydraulics` = 0 WHERE `User_ID` = %d LIMIT 1", model, uid);
	mysql_tquery(Database, str);

	if(id == -1) format(str, sizeof(str), "{eee8aa}You have given {ffffff}\"%s\" {eee8aa}a {ffffff}\"%s\" {eee8aa}as a personal vehicle.", name, VehicleNames[model - 400]);
	else format(str, sizeof(str), "{eee8aa}You have given {ffffff}\"%s[%d]\" {eee8aa}a {ffffff}\"%s\" {eee8aa}as a personal.", name, id, VehicleNames[model - 400]);
	SendClientMessage(playerid, -1, str);
	
	format(str, sizeof(str), "{eee8aa}You were given a {ffffff}\"%s\" {eee8aa}as a personal vehicle by an Admin.", VehicleNames[model - 400]);

	if(id != -1)
	{
		SendClientMessage(id, -1, str);
		SendClientMessage(id, -1, "{eee8aa}Use '/v to spawn it.");
	}
	WriteLog(LOG_ADMINACTIONS, "COMMAND: givepriveh | Admin: %s | Affected: %s", userinfo[playerid][pname], name);
	return 1;
}

CMD:sgg(playerid, params[])
{
	if(userinfo[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(gg_started == 1) return SendClientMessage(playerid, -1, "{ff0000}GunGame has already started.");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
	new count;
	foreach(new i : Player)
	{
		count++;
	}
	if(count < MIN_PLAYERS_TO_START_GUNGAME) return SendClientMessage(playerid, -1, "{ff0000}Cannot start due to lack of players (Required: "#MIN_PLAYERS_TO_START_GUNGAME" players");
	gg_started = 1;
	SetTimer("GunGameEndTime", TIME_FOR_GUNGAME_END * 60 * 1000, false);
	GameTextForAll("~r~gungame started!~n~~g~use /gungame to join", 10000, 4);
	SendClientMessageToAll_(-1, "{008000}Gun Game has started use {ff0000}'/gungame' {008000}to join.");
	SendClientMessageToAll_(-1, "{008000}Gun Game winner will be announced in {ffffff}"#TIME_FOR_GUNGAME_END" {008000}minutes.");
	WriteLog(LOG_ADMINACTIONS, "COMMAND: sgg | Admin: %s | Affected: All", userinfo[playerid][pname]);
	return 1;
}

CMD:gungame(playerid, params[])
{
	if(gg_started == 0) return SendClientMessage(playerid, -1, "{ff0000}Gun Game haven't started yet (You can ask for an Admin to start).");
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have participated for Last Man Standing.");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are invited for a duel, use \"/no\" to refuse or \"/yes\" to accept it.");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have invited someone for a duel, use \"/cancel\".");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You are in a vehicle.");
	GetPlayerDetails(playerid);    
	gg_lvl[playerid] = 1;
	new str[128];
	format(str, sizeof(str), "{FF8040}\"%s[%i]\" has joined the GunGame {ffffff}(/gungame).", userinfo[playerid][pname],playerid);
	SendClientMessageToAll_(-1, str);
	SendClientMessage(playerid, -1, "{eee8aa}Use \"/exit\" to leave (Your gungame progress won't be saved if you left).");
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
	if(sscanf(params, "s[128]s[128]", oldpass, newpass)) return SendClientMessage(playerid, -1, "{FF69B4}/changepass <old password> <new password>");
    format(tmppass[playerid], 30, "%s", newpass);
    bcrypt_check(oldpass, userinfo[playerid][ppass], "ChangePassCheck", "d", playerid);
	return 1;
}

forward ChangePassCheck(playerid);
public ChangePassCheck(playerid)
{
  if(!bcrypt_is_equal()) return SendClientMessage(playerid, -1, "{ff0000}Incorrect password.");
  if(strlen(tmppass[playerid]) < 5 ) return SendClientMessage(playerid, -1, "{ff0000}Your new password must include atleast 5 characters");
  if(strlen(tmppass[playerid]) > 20 ) return SendClientMessage(playerid, -1, "{ff0000}Your new password cannot go over 20 characters.");
  bcrypt_hash(tmppass[playerid], BCRYPT_COST, "ChangePassHash", "d", playerid);
  
  SendClientMessage(playerid, -1, "{eee8aa}Your password has been changed successfully.");
  
  new str[128];
  format(str, sizeof(str), "{eee8aa}Your new password: {ffffff}%s", tmppass[playerid]);
  SendClientMessage(playerid, -1, str);
  return 1;
}

forward ChangePassHash(playerid);
public ChangePassHash(playerid)
{
  bcrypt_get_hash(userinfo[playerid][ppass]);
  WriteLog(LOG_PASS, "Name: %s | HashCode: %s", userinfo[playerid][pname], userinfo[playerid][ppass]);
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
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{FF69B4}/stats <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	
	TextDrawShowForPlayer(playerid, statstd);
	
	PlayerTextDrawColor(playerid, statstd_1[playerid][0], GetPlayerColor(id));
	format(str, sizeof(str), "%s~w~'s_stats", userinfo[id][pname], id);
	PlayerTextDrawSetString(playerid, statstd_1[playerid][0], str);
	PlayerTextDrawShow(playerid, statstd_1[playerid][0]);

	PlayerTextDrawColor(playerid, statstd_1[playerid][1], ganginfo[userinfo[id][gid]][gcolor]);
	format(str, sizeof(str), "%s~n~%s", ganginfo[userinfo[id][gid]][gname], ganginfo[userinfo[id][gid]][gtag]);
	PlayerTextDrawSetString(playerid, statstd_1[playerid][1], str);
	PlayerTextDrawShow(playerid, statstd_1[playerid][1]);

	PlayerTextDrawSetPreviewModel(playerid, statstd_1[playerid][4], GetPlayerSkin(id));
	PlayerTextDrawShow(playerid, statstd_1[playerid][4]);

	PlayerTextDrawSetPreviewVehCol(playerid, statstd_1[playerid][5], userinfo[id][vcolor_1], userinfo[id][vcolor_2]);
	PlayerTextDrawSetPreviewModel(playerid, statstd_1[playerid][5], userinfo[id][vmodel]);
	if(userinfo[id][vowned] == 1) PlayerTextDrawShow(playerid, statstd_1[playerid][5]);

	new bool[10];
	if(userinfo[id][VIP] == 1) bool = "Yes";
	else bool = "No";

	new Float:ratio;
	if(userinfo[id][pdeaths] == 0) ratio = 0.00;
	else ratio = floatdiv(userinfo[id][pkills], userinfo[id][pdeaths]);

	new pTime[30], hours, mins;
	ConvertToMinAndHours(userinfo[id][ptime], hours, mins); 
	format(pTime, sizeof(pTime), "%d_hrs_%d_mins", hours, mins);
	
	format(str, sizeof(str), "~y~VIP_status:_~w~%s~n~~y~Kills:_~w~%d~n~~y~Deaths:_~w~%d~n~~y~Ratio:_~w~%.2f~n~~y~Play_time:_~w~%s~n~~y~Income:_~w~%d~n~~y~Highest_rampage:_~w~%d~n~~y~Head_shots:_~w~%d", bool, userinfo[id][pkills], userinfo[id][pdeaths], ratio, pTime, GetPlayerCash(id), userinfo[id][bramp], userinfo[id][hshots]);
	PlayerTextDrawSetString(playerid, statstd_1[playerid][2], str);
	PlayerTextDrawShow(playerid, statstd_1[playerid][2]);
	new vbool[10];
	if(userinfo[id][vowned] == 1) format(vbool, sizeof(vbool), "%s", VehicleNames[userinfo[id][vmodel] - 400]);
	else vbool = "Not_owned";

	format(str, sizeof(str), "~y~Revenges:_~w~%d~n~~y~Brutal_kills:_~w~%d~n~~y~GunGames_won:_~w~%d~n~~y~LMS_won:_~w~%d~n~~y~Duels_won:_~w~%d~n~~y~Robberies:_~w~%d~n~~y~Vehicle:_~w~%s", userinfo[id][revenges], userinfo[id][bkills], userinfo[id][ggw], userinfo[id][lmswon], userinfo[id][dwon], userinfo[id][robbs], vbool);
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
	new str[128];
	if(userinfo[playerid][blockpm] == 1)
	{
		SendClientMessage(playerid, -1, "{eee8aa}You unblocked recieving personal messages from others.");
		userinfo[playerid][blockpm] = 0;
		mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Block_PM` = 0 WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][pid]);
		mysql_tquery(Database, str);
	}
	else
	{
		SendClientMessage(playerid, -1, "{eee8aa}You blocked recieving personal messages from others.");
		userinfo[playerid][blockpm] = 1;
		mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Block_PM` = 1 WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][pid]);
		mysql_tquery(Database, str);
	}
	return 1;
}

CMD:pm(playerid , params[])
{
	new id, message[128], str[128];
	if(userinfo[playerid][muted] == 1)
	{
		format(str, sizeof(str), "{ff0000}You can't talk while you are muted (Remaining time: %d seconds).", userinfo[playerid][mutetime]);
		SendClientMessage(playerid, -1, str);
	} 
	if(sscanf(params,"us[256]", id, message)) return SendClientMessage(playerid, -1, "{FF69B4}/pm <id> <text>");
	if(id == playerid) return SendClientMessage(playerid, -1, "{ff0000}You can't PM yourself.");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(userinfo[id][blockpm] == 1) return SendClientMessage(playerid, -1, "{ff0000}Player has blocked recieving PMs from others.");
	if(strfind(message, "/q") != -1) return SendClientMessage(playerid, -1, "{ff0000}Hey!!! don't tell our gang homies to leave LGGW!");
    if(stringContainsIP(message))
    {
        userinfo[playerid][muted] = 1;
        userinfo[playerid][mutetime] = TIME_FOR_ADVERTISE_MUTE * 60;
        
        format(str, sizeof(str), "{ff8000}* {ffffff}%s[%d] {ff8000}has been muted by the server for {ff0000}%d {ff8000}minutes (Advertising).", userinfo[playerid][pname], playerid, TIME_FOR_ADVERTISE_MUTE);
        return SendClientMessageToAll_(-1, str);
    }
	PlayerPlaySound(id, 1057, 0.0, 0.0, 0.0); 
	format(str, sizeof(str), "{008080}*** PM from %s[%d]: %s" ,userinfo[playerid][pname], playerid, message);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{008080}*** PM to %s[%d]: %s" ,userinfo[id][pname], id, message); 
	SendClientMessage(playerid, -1, str);
	format(str, sizeof(str), "{C1AB53}* PM from %s[%d] to %s[%d]: %s", userinfo[playerid][pname], playerid, userinfo[id][pname], id, message);
	new hlvl;
	if(userinfo[id][plevel] > userinfo[playerid][plevel]) hlvl = userinfo[id][plevel];
	else hlvl = userinfo[playerid][plevel];
	foreach(new j : Player)
	{
		if(userinfo[j][plevel] >= hlvl && j != playerid && j != id && userinfo[j][plevel] != 0)
		{
			SendClientMessage(j, -1, str);
		}
	} 
	WriteLog(LOG_PM, "Sender: %s | Reciever: %s | Message: %s", userinfo[playerid][pname], userinfo[id][pname], message);
	return 1;
}

CMD:setlevel(playerid, params[])
{
	new id, level, str[128];
	if(userinfo[playerid][plevel] < 4 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "ui", id, level)) return SendClientMessage(playerid, -1, "{FF69B4}/setlevel <id> <level>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(id == playerid && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command on you.");
	if((userinfo[id][plevel] >= userinfo[playerid][plevel] || IsPlayerAdmin(id)) && id != playerid) return SendClientMessage(playerid, -1, "{ff0000}Player you entered is at the same level or a higher level than you.");
	if(level > 5 || level < 0) return SendClientMessage(playerid, -1, "{ff0000}Use a level between 0 - 5.");
	if((!IsPlayerAdmin(playerid) && userinfo[playerid][plevel] != 5 && level == 5)) return SendClientMessage(playerid, -1, "{ff0000}You can't give level 5 to anyone unless you are a RCON admin or another level 5 Admin.");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{ff0000}Player is not spawned yet.");
	
	userinfo[id][plevel] = level;
	format(str, sizeof(str), "{eee8aa}Admin {ffffff}\"%s[%i]\" {eee8aa}has set your Admin level to {ffffff}%d{eee8aa}.", userinfo[playerid][pname], playerid, level);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{eee8aa}You have set {ffffff}%s{eee8aa}'s Admin level to {ffffff}%d{eee8aa}.", userinfo[id][pname], level);
	SendClientMessage(playerid, -1, str);
	adm_id[id] = GetFreeAdminID();
	
	WriteLog(LOG_ADMINLVLCHANGES, "Level Giver: %s | Level Reciever: %s | Level: %d", userinfo[playerid][pname], userinfo[id][pname], level);
	mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Level` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[id][plevel], userinfo[id][pid]);
	mysql_tquery(Database, str);
	return 1;
}

CMD:setvip(playerid, params[])
{
	new id, level, str[128]; 
	if(userinfo[playerid][plevel] < 4 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "ud", id, level)) return SendClientMessage(playerid, -1, "{FF69B4}/setvip <id> <level>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(id == playerid && userinfo[playerid][plevel] < 5) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command on you.");
	if(userinfo[id][VIP] == 1) return SendClientMessage(playerid, -1, "{ff0000}The entered player is a VIP already.");
    if(level < 1 || level > 3) return SendClientMessage(playerid, -1, "{ff0000}Invalid VIP level (Use a level between 1 - 4)");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{ff0000}Player is not spawned yet.");
	
    userinfo[playerid][VIP] = 1;
    switch(level)
    {
        case 1: userinfo[playerid][VIP_exp] = gettime() + 24 * 60 * 60 * 30;
        case 2: userinfo[playerid][VIP_exp] = gettime() + 24 * 60 * 60 * 30 * 3;
        case 3: userinfo[playerid][VIP_exp] = -1;
    } 
	
    format(str, sizeof(str), "{eee8aa}An admin has set you as a {ffffff}*** {ff0000}VIP {ffffff}***{eee8aa}.", userinfo[playerid][pname]);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{eee8aa}You have set {ffffff}\"%s[%i]\" {eee8aa}as a {ffffff}*** {ff0000}VIP {ffffff}***{eee8aa}.", userinfo[id][pname]);
	SendClientMessage(playerid, -1, str);

    switch(level)
    {
        case 1: SendClientMessage(id, -1, "{eee8aa}This is VIP level {ffffff}1{eee8aa}. This VIP access will expire in {ffffff}1 month{eee8aa}.");
        case 2: SendClientMessage(id, -1, "{eee8aa}This is VIP level {ffffff}2{eee8aa}. This VIP access will expire in {ffffff}3 month{eee8aa}.");
        case 3: SendClientMessage(id, -1, "{eee8aa}This is VIP level {ffffff}3{eee8aa}. This VIP access will {ffffff}never {eee8aa}expire.");
    } 
	
    WriteLog(LOG_ADMINACTIONS, "COMMAND:setvip | Admin: %s | VIP Reciever: %s", userinfo[playerid][pname], userinfo[id][pname]);
	
    mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Level` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[id][VIP], userinfo[id][pid]);
	mysql_tquery(Database, str);
	return 1;
}

CMD:kick(playerid, params[])
{
	new id, str[128], reason[128];
	if(userinfo[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "us[128]", id, reason)) return SendClientMessage(playerid, -1, "{ff1493}/kick <id> <reason>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(id == playerid) return SendClientMessage(playerid, -1, "{ff0000}You cannot use this command on you.");
	if(userinfo[id][plevel] >= userinfo[playerid][plevel]) return SendClientMessage(playerid, -1, "{ff0000}Player you entered is at the same level or a higher level than you.");
	format(str,sizeof(str), "{eee8aa}You kicked \"%s[i]\" from the server.", userinfo[id][pname], id);
	SendClientMessage(playerid, -1, str);
	format(str, sizeof(str), "* {ffffff}\"%s[%d]\" {FF8000}kicked from the server by an Admin (%s).", userinfo[id][pname], id, reason);
	SendClientMessageToAll_(-1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: Kick | Admin: %s | Affected: %s | Reason: %s", userinfo[playerid][pname], userinfo[id][pname], reason);
	Kick(id); 
	return 1;
}

CMD:clearchat(playerid, params[])
{
	if(userinfo[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	for(new i = 0; i < 100; i++)
	{
		SendClientMessageToAll_(-1, "");
	}
	return 1;
}

CMD:cc(playerid, params[])
{
	return PC_EmulateCommand(playerid, "/clearchat");
}

new last_report[MAX_PLAYERS];

CMD:report(playerid, params[])
{
	new id, reason[128], str[128];
	if(sscanf(params,"us[128]", id, reason)) return SendClientMessage(playerid, -1, "{ff1493}/report <id> <reason>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(id == playerid) return SendClientMessage(playerid, -1, "{ff0000}You cant report yourself.");
	if(gettime() - last_report[playerid] < 30) 
	{ 
		format(str, sizeof(str), "{ff0000}Please wait %i seconds to report again.", -gettime() + 30 + last_report[playerid]);
		return SendClientMessage(playerid, -1, str);
	}
	new dcc_report[400];
	//new ReportRandoms[][] = 
	//{
	//	"`@everyone` WAKE UP!!!, A report is here!!! :confused:",
	//	"`@everyone` Oh no no no!! a report? again? shuhh!!! :sweat:",
	//	"`@everyone` GameOvr should develop the anti-cheat system tf :smile:",
	//	"`@everyone` Actually I was thinking that why these guys arn't intelligent enough to use cheats without getting cought! :sweat_smile:",
	//	"`@everyone` You guys have to take care about this guy!. He doesn't know that we are monitoring him! :smirk:",
	//	"`@everyone` Time to launch the mission `Protect LGGW`! :joy:. Nah! I'm serious! :angry:"
	//};
	//new Rand = random(sizeof(ReportRandoms));
	//DCC_SendChannelMessage(dcc_channel_reports, ReportRandoms[Rand]);
	SendToAdmins(-1, "----------------- REPORT -----------------", 1);
	strcat(dcc_report, "```----------------- REPORT -----------------\n", sizeof(dcc_report));
	strcat(dcc_report, str, sizeof(dcc_report));
	strcat(dcc_report, "\n", sizeof(dcc_report));
	format(str, sizeof(str), "Reporter: %s[%d]", userinfo[playerid][pname], playerid);
	SendToAdmins(-1, str, 1);
	strcat(dcc_report, str, sizeof(dcc_report));
	strcat(dcc_report, "\n", sizeof(dcc_report));
	format(str, sizeof(str), "Rule breaker: %s[%d]", userinfo[id][pname], id);
	SendToAdmins(-1, str, 1);
	strcat(dcc_report, str, sizeof(dcc_report));
	strcat(dcc_report, "\n", sizeof(dcc_report));
	format(str, sizeof(str), "Reason: %s", reason);
	SendToAdmins(-1, str, 1);
	strcat(dcc_report, str, sizeof(dcc_report));
	strcat(dcc_report, "\n", sizeof(dcc_report));
	SendToAdmins(-1, "------------------------------------------", 1);
	strcat(dcc_report, "------------------------------------------```", sizeof(dcc_report));
	//DCC_SendChannelMessage(dcc_channel_reports, dcc_report);
	GameTextForAdmins("~r~new report recieved from a player", 5000, 5);
	WriteLog(LOG_REPORTS, "Reporter: %s | RuleBreaker: %s | Reason: %s", userinfo[playerid][pname], userinfo[id][pname], reason);
	format(str, sizeof(str), "{eee8aa}Your report against \"%s\" has been sent to online Admins in the SERVER and DISCORD!", userinfo[id][pname]);
	SendClientMessage(playerid, -1, str);
	last_report[playerid] = gettime();
	return 1;
}

CMD:veh(playerid, params[])
{
	new car, color1, color2; 
	
    if(userinfo[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "iD(-1)D(-1).", car, color1, color2)) 
	{
		SendClientMessage(playerid, -1, "{ff1493}/veh <id> [colour 1] [colour 2]");
		return SendClientMessage(playerid, -1, "{eee8aa}The parameters in [ ... ] are optional, You can leave them if you want.");
	}
	if(car < 400 || car > 611) return SendClientMessage(playerid, -1, "{ff0000}Invalid vehicle ID.");
	if(color1 > 255 || color2 > 255) return SendClientMessage(playerid, -1, "{ff0000}Invalid colour ID.");
	if(adminveh[playerid] != INVALID_VEHICLE_ID)
	{ 
		DestroyVehicle(adminveh[playerid]); 
		adminveh[playerid] = INVALID_VEHICLE_ID;
	}

    new Float:X, Float:Y, Float:Z;
    new Float:fa;

    GetPlayerFacingAngle(playerid, fa);
    GetPlayerPos(playerid, X, Y, Z);

	adminveh[playerid] = CreateVehicle(car, X, Y, Z, fa, color1, color2, -1); 
	SetVehicleVirtualWorld(adminveh[playerid], GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(adminveh[playerid], GetPlayerInterior(playerid));
	PutPlayerInVehicle(playerid, adminveh[playerid], 0); 
	return 1;
}

CMD:ban(playerid, params[])
{
	new id, str[240], reason[128];
	if(userinfo[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "us[128]", id, reason)) return SendClientMessage(playerid, -1, "{ff1493}/ban <id> <reason>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(id == playerid) return SendClientMessage(playerid, -1, "{ff0000}You cannot use this command on you.");
	if(userinfo[id][plevel] >= userinfo[playerid][plevel]) return SendClientMessage(playerid, -1, "{ff0000}Player you entered is at the same level or a higher level than you.");
	
    format(str,sizeof(str), "{eee8aa}You Banned \"%s[%d]\" from the server.", userinfo[id][pname], id);
	SendClientMessage(playerid, -1, str);
	format(str, sizeof(str), "* \"%s[%d]\" {FF8000}Banned from the server by an Admin (%s).", userinfo[id][pname], id, reason);
	SendClientMessageToAll_(-1, str);
	
    WriteLog(LOG_ADMINACTIONS, "COMMAND: Ban | Admin: %s | BannedPlayer: %s | Reason: %s", userinfo[playerid][pname], userinfo[id][pname], reason);
	WriteLog(LOG_BANS, "Admin: %s | BannedPlayer: %s | BanType: Online Ban | Reason: %s", userinfo[playerid][pname], userinfo[id][pname], reason);
	
    mysql_format(Database, str, sizeof(str), "UPDATE `User_Status` SET \
        `Banned` = 1, \
        `Banned_times` = Banned_times + 1, \
        `Banned_admin` = %d, \
        `Banned_timestamp` = %d, \
        `Banned_reason` = '%e', \
        `Unban_timestamp` = -1 WHERE `User_ID` = %d", userinfo[playerid][pid], gettime(), reason, userinfo[id][pid]);
    mysql_tquery(Database, str);


    BanPlayer_UID(userinfo[id][pid]);

    DelayKick(id);
	return 1;
}

RangeBan(ip[])
{
    new total[16], str[24];
    
    new cnt;
    for(new i = 0; i < strlen(ip); i++)
    {
        if(ip[i] == '.') cnt++;

        if(cnt == 2)
        {
            i++;
            strdel(ip, i, strlen(ip));
            format(total, sizeof(total), "%s*.*", ip);
        }
    }
    
    format(str, sizeof(str),"banip %s", total);
    SendRconCommand(str);

    SendRconCommand("reloadbans");
    return 1;
}

RangeUnban(ip[])
{
    new total[16], str[24];
    
    new cnt;
    for(new i = 0; i < strlen(ip); i++)
    {
        if(ip[i] == '.') cnt++;

        if(cnt == 2)
        {
            i++;
            strdel(ip, i, strlen(ip));
            format(total, sizeof(total), "%s*.*", ip);
        }
    }
    
    format(str, sizeof(str),"unbanip %s", total);
    SendRconCommand(str);

    SendRconCommand("reloadbans");
    return 1;
}

BanPlayer_UID(key)
{
    new str[128];
    
    mysql_format(Database, str, sizeof(str), "SELECT * FROM `User_IPs` WHERE `User_ID` = '%d' AND `IP` != '-1' LIMIT "#MAX_IP_SAVES"", key);
    new Cache:r = mysql_query(Database, str);

    new rows, ip[16];
    
    cache_get_row_count(rows);
    for(new i = 0; i < rows; i++)
    {
        cache_get_value_name(i, "IP", ip, sizeof(ip));
        RangeBan(ip);
    }
    cache_delete(r);
    return 1;
}

BanPlayer(name[])
{
    new str[128], key;
    
    mysql_format(Database, str, sizeof(str), "SELECT * FROM `Users` WHERE `Name` = '%e' LIMIT 1", name);
    new Cache:r = mysql_query(Database, str);
    cache_get_value_name_int(0, "User_ID", key);
    cache_delete(r);

    mysql_format(Database, str, sizeof(str), "SELECT * FROM `User_IPs` WHERE `User_ID` = '%d' AND `IP` != '-1' LIMIT "#MAX_IP_SAVES"", key);
    r = mysql_query(Database, str);

    new rows, ip[16];
    
    cache_get_row_count(rows);
    for(new i = 0; i < rows; i++)
    {
        cache_get_value_name(i, "IP", ip, sizeof(ip));
        RangeBan(ip);
    }
    cache_delete(r);
    return 1;
}

UnbanPlayer(name[])
{
    new str[128], key;

    mysql_format(Database, str, sizeof(str), "SELECT * FROM `Users` WHERE `Name` = '%e' LIMIT 1", name);
    new Cache:r = mysql_query(Database, str);
    cache_get_value_name_int(0, "User_ID", key);
    cache_delete(r);

    mysql_format(Database, str, sizeof(str), "SELECT * FROM `User_IPs` WHERE `User_ID` = '%d' AND IP != '-1' LIMIT "#MAX_IP_SAVES"", key);
    r = mysql_query(Database, str);

    new rows, ip[16];

    cache_get_row_count(rows);
    for(new i = 0; i < rows; i++)
    {
        cache_get_value_name(i, "IP", ip, sizeof(ip));
        RangeBan(ip);
    }
    cache_delete(r);
    return 1;
}

CMD:oban(playerid, params[])
{
	new name[MAX_PLAYER_NAME], str[240], reason[128];
	
    if(userinfo[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params,"s["#MAX_PLAYER_NAME"]s[128]", name, reason)) return SendClientMessage(playerid, -1, "{ff1493}/oban <name> <reason>");
	
    mysql_format(Database, str, sizeof(str), "SELECT * FROM Users WHERE `Name` = '%e' LIMIT 1", name);
	new Cache:cache = mysql_query(Database, str);
	
    if(!cache_num_rows()){ 
    	
        cache_delete(cache); 
        return SendClientMessage(playerid, -1, "{ff0000}Invalid player name (There's no such player registered)."); 
    }
	if(isequal(name, userinfo[playerid][pname])){ 
		
        cache_delete(cache); 
        return SendClientMessage(playerid, -1, "{ff0000}You cannot use this command on you."); 
    }
	if(IsPlayerBanned(name)){ 
		
        cache_delete(cache); 
        return SendClientMessage(playerid, -1, "{ff0000}Player you entered is already banned"); 
    }
	
    cache_set_active(cache);
	new lvl, id;
	cache_get_value_name_int(0, "Level", lvl);
    cache_get_value_name_int(0, "User_ID", id);
	cache_unset_active();
	cache_delete(cache);

	if(lvl >= userinfo[playerid][plevel]) return SendClientMessage(playerid, -1, "{ff0000}Player you entered is at the same level or a higher level than you.");
	foreach(new i : Player) if(isequal(userinfo[i][pname], name)) return SendClientMessage(playerid, -1, "{ff0000}Player you entered is connected use /ban instead");
	
    format(str, sizeof(str), "{eee8aa}You banned \"s\" from the server", name);
	SendClientMessage(playerid, -1, str);
	format(str, sizeof(str), "* {FFFFFF}\"%s\" {FF8000}banned from the server by an admin (%s).", name, reason);
	SendClientMessageToAll_(-1, str);
	
    WriteLog(LOG_ADMINACTIONS, "COMMAND: Oban | Admin: %s | BannedPlayer: %s | Reason: %s", userinfo[playerid][pname], name, reason);
	WriteLog(LOG_BANS, "Admin: %s | BannedPlayer: %s | BanType: Offline Ban | Reason: %s", userinfo[playerid][pname], name, reason);
	
    mysql_format(Database, str, sizeof(str), "UPDATE `User_Status` SET \
        `Banned` = 1, \
        `Banned_times` = Banned_times + 1, \
        `Banned_admin` = %d, \
        `Banned_timestamp` = %d, \
        `Banned_reason` = '%e', \
        `Unban_timestamp` = -1 WHERE `User_ID` = %d", userinfo[playerid][pid], gettime(), reason, id);
    mysql_tquery(Database, str);

    BanPlayer(userinfo[id][pname]);

    DelayKick(id);
	return 1;
}

CMD:unban(playerid, params[])
{   
	new name[MAX_PLAYER_NAME], str[256];
	if(userinfo[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "s["#MAX_PLAYER_NAME"]", name)) return SendClientMessage(playerid, -1, "{ff1493}/unban <name>");
	
    mysql_format(Database, str, sizeof(str), "SELECT * FROM Users WHERE `Name` = %e LIMIT 1", name);
	new Cache:r = mysql_query(Database, str);

    if(!cache_num_rows()) 
    {
        cache_delete(r); 
        return SendClientMessage(playerid, -1, "{ff0000}Invalid player name (There's no such player registered)."); 
    }
	
    new id;
    cache_get_value_name_int(0, "User_ID", id);
    cache_delete(r);

    if(isequal(name, userinfo[playerid][pname])) return SendClientMessage(playerid, -1, "{ff0000}You cannot use this command on you.");
	if(!IsPlayerBanned(name)) return SendClientMessage(playerid, -1, "{ff0000}Player you entered is not banned");

    format(str, sizeof(str), "{eee8aa}You unbanned {ffffff}\"%s\" {eee8aa}from the server", name);
	SendClientMessage(playerid, -1, str);
	
    WriteLog(LOG_ADMINACTIONS, "COMMAND: unban | Admin: %s | Affected: %s", userinfo[playerid][pname], name);    

    mysql_format(Database, str, sizeof(str), "UPDATE `User_Status` SET \
        `Banned` = 0 WHERE `User_ID` = %d LIMIT 1", id);
    mysql_tquery(Database, str);

    UnbanPlayer(name);
	return 1;
} 

CMD:tban(playerid, params[])
{
    new id, str[240], minutes, reason[128];
    
    if(userinfo[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
    if(sscanf(params, "uis[128]", id, minutes, reason)) return SendClientMessage(playerid, -1, "{ff1493}/rban <id> <minutes> <reason>");
    if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
    if(id == playerid) return SendClientMessage(playerid, -1, "{ff0000}You cannot use this command on you.");
    if(userinfo[id][plevel] >= userinfo[playerid][plevel]) return SendClientMessage(playerid, -1, "{ff0000}Player you entered is at the same level or a higher level than you.");
    if(minutes < 2) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
    
    new timestamp = (gettime() + (60 * minutes));
    mysql_format(Database, str, sizeof(str), "UPDATE `User_Status` SET \
        `Banned` = 1, \
        `Banned_times` = Banned_times + 1, \
        `Banned_admin` = %d, \
        `Banned_timestamp` = %d, \
        `Banned_reason` = '%s', \
        `Unban_timestamp` = %d WHERE `User_ID` = %d", userinfo[playerid][pid], gettime(), reason, timestamp, userinfo[id][pid]);
    mysql_tquery(Database, str);
    
    BanPlayer_UID(userinfo[id][pid]);
    return 1;      
}

CMD:freeze(playerid, params[])
{
	new id, str[128];
	if(userinfo[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{ff1493}/freeze <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(id == playerid) return SendClientMessage(playerid, -1, "{ff0000}You cannot use this command on you.");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{ff0000}Player is not spawned yet.");
	if(userinfo[id][plevel] >= userinfo[playerid][plevel]) return SendClientMessage(playerid, -1, "{ff0000}Player you entered is at the same level or a higher level than you.");
	if(frozen[id] == 1) return SendClientMessage(playerid, -1, "{ff0000}Player is already frozen.");
	
    TogglePlayerControllable(id, 0);
	GameTextForPlayer(id, "~r~frozen", 5000, 5);
	
    format(str, sizeof(str), "{eee8aa}You froze \"%s\"", userinfo[id][pname]);
	SendClientMessage(playerid, -1, str);
	SendClientMessage(id, -1, "{eee8aa}You have been frozen by an admin.");
	
    frozen[id] = 1;
	nocmd[id] = 1;
	
    WriteLog(LOG_ADMINACTIONS, "COMMAND: freeze | Admin: %s | Affected: %s", userinfo[playerid][pname], userinfo[id][pname]);    
	return 1;
}

CMD:unfreeze(playerid, params[])
{
	new id, str[128];
	if(userinfo[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{ff1493}/unfreeze <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(id == playerid) return SendClientMessage(playerid, -1, "{ff0000}You cannot use this command on you.");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{ff0000}Player is not spawned yet.");
	if(userinfo[id][plevel] >= userinfo[playerid][plevel]) return SendClientMessage(playerid, -1, "{ff0000}Player you entered is at the same level or a higher level than you.");
	if(frozen[id] == 0) return SendClientMessage(playerid, -1, "{ff0000}Player isn't frozen.");
	
    TogglePlayerControllable(id, 1);
	
    format(str, sizeof(str), "{eee8aa}You unfroze {ffffff]\"%s\"{eee8aa}.", userinfo[id][pname]);
	SendClientMessage(playerid, -1, str);
    SendClientMessage(id, -1, "{eee8aa}You have been unfrozen by an Admin.");
	
    frozen[id] = 0;
	nocmd[id] = 0;
	
    WriteLog(LOG_ADMINACTIONS, "COMMAND: unfreeze | Admin: %s | Affected: %s", userinfo[playerid][pname], userinfo[id][pname]); 
	return 1;
}

CMD:get(playerid, params[])
{
	new id, int, vw, str[128];
	new Float:X, Float:Y, Float:Z;  
	if(userinfo[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params,"u", id)) return SendClientMessage(playerid, -1, "{ff1493}/get <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(id == playerid) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command on you.");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{ff0000}Player is not spawned yet.");
	if(userinfo[playerid][plevel] <= userinfo[id][plevel]) return SendClientMessage(playerid, -1, "{ff0000}The person you are using the command is at the same or at a higher level.");
	GetPlayerPos(playerid, X, Y, Z);
	int = GetPlayerInterior(playerid);
	vw = GetPlayerVirtualWorld(playerid);
	SetPlayerVirtualWorld(id, vw);
	SetPlayerInterior(id, int);
	SetPlayerPos(id, X+1 , Y+1, Z+1);
	format(str, sizeof(str) , "{eee8aa}You have teleported {ffffff}\"%s\" {eee8aa}to your location.", userinfo[id][pname]);
	SendClientMessage(playerid, -1, str);
	SendClientMessage(id, -1, "{eee8aa}You have been teleported by an admin.");
	WriteLog(LOG_ADMINACTIONS, "COMMAND: get | Admin: %s | Affected: %s", userinfo[playerid][pname], userinfo[id][pname]); 
	return 1;
}

CMD:goto(playerid, params[])
{
	new id, int, vw, str[128];
	new Float:X, Float:Y, Float:Z;  
	if(userinfo[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params,"u", id)) return SendClientMessage(playerid, -1, "{ff1493}/goto <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(id == playerid) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command on you.");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{ff0000}Player is not spawned yet.");
	GetPlayerPos(id, X, Y, Z);
	int = GetPlayerInterior(id);
	vw = GetPlayerVirtualWorld(id);
	SetPlayerVirtualWorld(playerid, vw);
	SetPlayerInterior(playerid, int);
	SetPlayerPos(playerid, X+1.5, Y, Z);
	format(str, sizeof(str) , "{eee8aa}You have teleported to {ffffff}%s{eee8aa}'s location.", userinfo[id][pname]);
	SendClientMessage(playerid, -1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: goto | Admin: %s | Affected: %s", userinfo[playerid][pname], userinfo[id][pname]); 
	return 1;
}

CMD:tele(playerid, params[])
{
    new id1, id2, int, vw, str[128];
    new Float:X, Float:Y, Float:Z;  
    
    if(userinfo[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
    if(sscanf(params,"uu", id1, id2))
    {
        SendClientMessage(playerid, -1, "{ff1493}/tele <id 1> <id 2>");
        return SendClientMessage(playerid, -1, "{eee8aa}Note that this command teleports {ffffff}ID 1 {eee8aa}to {ffffff}ID 2.");
    }
    if(!IsPlayerConnected(id1)) return SendClientMessage(playerid, -1, "{ff0000}ID 1 is an invalid player ID.");
    if(!IsPlayerConnected(id2)) return SendClientMessage(playerid, -1, "{ff0000}ID 2 is an invalid player ID.");
    if(id1 == playerid || id2 == playerid) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command on you, Use \"/goto\" or \"/get\" instead.");
    if(userinfo[id1][plevel] >= userinfo[playerid][plevel]) return SendClientMessage(playerid, -1, "{ff0000}ID 1 is a person with higher or equal admin level concered with you.");
    if(IsPlayerInClassSelection(id1) || !IsPlayerSpawned(id1) || IsPlayerInClassSelection(id2) || !IsPlayerSpawned(id2)) return SendClientMessage(playerid, -1, "{ff0000}One od the players is not spawned yet.");
    if(!IsPlayerConnected(id2)) return SendClientMessage(playerid, -1, "{ff0000}ID 2 is an invalid player ID.");
    
    GetPlayerPos(id2, X, Y, Z);
    int = GetPlayerInterior(id2);
    vw = GetPlayerVirtualWorld(id2);
    
    SetPlayerVirtualWorld(id1, vw);
    SetPlayerInterior(id1, int);
    SetPlayerPos(id1, X+1.5 , Y, Z);
    
    format(str, sizeof(str) , "{eee8aa}You have been teleported by an admin to {ffffff{eee8aa}}%s's location.", userinfo[id2][pname]);
    SendClientMessage(id1, -1, str);

    format(str, sizeof(str) , "{eee8aa}You have teleported {ffffff}\"%s[%d]\"{eee8aa} to {ffffff}%s[%d]{eee8aa}'s location.", userinfo[id1][pname], userinfo[id2][pname]);
    SendClientMessage(playerid, -1, str);
    
    WriteLog(LOG_ADMINACTIONS, "COMMAND: tele | Admin: %s | Affected: ID 1: %s & ID 2: %s", userinfo[playerid][pname], userinfo[id1][pname], userinfo[id2][pname]); 
    return 1;
}

CMD:sm(playerid, params[])
{
    new id, msg[128], time;
    
    if(userinfo[playerid][plevel] == 0) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
    if(sscanf(params, "us[50]d", id, msg, time)){
        SendClientMessage(playerid, -1, "{dd1493}/sm <id> <msg> <seconds>");
        return SendClientMessage(playerid, -1, "You can use color tags like ~r~ ~w~ ~p~ also ~n~ for a new line!");
    }
    if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
    if(id == playerid) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command on you.");
    if(userinfo[id][plevel] >= userinfo[playerid][plevel]) return SendClientMessage(playerid, -1, "{ff0000}The player you are using the command is at the same or higher level than you.");
    if(strlen(msg) > 30 || strlen(msg) < 5) return SendClientMessage(playerid, -1, "{ff0000}Message character length should lie inbetween 5 - 30");
    if(time < 5 || time > 60) return SendClientMessage(playerid, -1, "{ff0000}Seconds should lie inbetween 5 and 60.");
    
    GameTextForPlayer(id, msg, time, 3);
    return 1;
}

CMD:setcolor(playerid, params[])
{
    new id, hex;
    
    if(userinfo[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
    if(sscanf(params, "uh", id, hex)) return SendClientMessage(playerid, -1, "{dd1493}/setcolor <id> <color>");
    if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
    if(userinfo[id][plevel] >= userinfo[playerid][plevel]) return SendClientMessage(playerid, -1, "{ff0000}The player you are using the command is at the same or higher level than you.");
   
    SetPlayerColor(playerid, hex);
    
    new str[128];
    format(str, sizeof(str), "{eee8aa}You have set {ffffff}%s{eee8aa}'s color to {ffffff}%x", userinfo[id][pname]);
    SendClientMessage(playerid, -1, str);
    SendClientMessage(playerid, -1, "{eee8aa}Player's color will reset once he respawn.");
    return 1;
}

CMD:muted(playerid, params[])
{
    if(userinfo[playerid][plevel] == 0) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
    
    new str[1024], str1[128], name[MAX_PLAYER_NAME], c;
    
    strcat(str, "ID\tName\tAdmin\tReason\tTime left", sizeof(str));
    foreach(new i : Player)
    {
        if(userinfo[i][muted])
        {
            c++;
            if(userinfo[i][muted_admin] != -1)
            {
	            mysql_format(Database, str1, sizeof(str1), "SELECT `Name` FROM `Users` WHERE `User_ID` = '%d' LIMIT 1", userinfo[i][muted_admin]);
	            new Cache:r = mysql_query(Database, str1);
	            cache_get_value_name(0, "Name", name, sizeof(name)); 
	            cache_delete(r);
	        }
            
            if(userinfo[playerid][muted_admin] != -1) format(str1, sizeof(str1), "%d\t%s\t%s\t%s\t%d seconds\n", i, userinfo[i][pname], name, userinfo[i][muted_reason], userinfo[i][mutetime]);
            else format(str1, sizeof(str1), "%d\t%s\tServer\t%s\t%d seconds\n", i, userinfo[i][pname], userinfo[i][muted_reason], userinfo[i][mutetime]);
            strcat(str, str1, sizeof(str));
        }
    }

    if(c != 0) Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Muted players", str, "Close", "");
    else Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Muted players", "There are no muted players online.", "Close", "");
    return 1;
}

CMD:jailed(playerid, params[])
{
    if(userinfo[playerid][plevel] == 0) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
    
    new str[1024], str1[128], name[MAX_PLAYER_NAME], c;
    
    strcat(str, "ID\tName\tAdmin\tReason\tTime left", sizeof(str));
    foreach(new i : Player)
    {
        if(userinfo[i][jailed])
        {
            c++;
            if(userinfo[playerid][jailed_admin] != -1)
            {
	            mysql_format(Database, str1, sizeof(str1), "SELECT `Name` FROM `Users` WHERE `User_ID` = '%d' LIMIT 1", userinfo[i][jailed_admin]);
	            new Cache:r = mysql_query(Database, str1);
	            cache_get_value_name(0, "Name", name, sizeof(name)); 
	            cache_delete(r);
	        }

            if(userinfo[playerid][jailed_admin] != -1) format(str1, sizeof(str1), "%d\t%s\t%s\t%s\t%d seconds\n", i, userinfo[i][pname], name, userinfo[i][jailed_reason], userinfo[i][jailtime]);
            else format(str1, sizeof(str1), "%d\t%s\tServer\t%s\t%d seconds\n", i, userinfo[i][pname], userinfo[i][jailed_reason], userinfo[i][jailtime]);
            strcat(str, str1, sizeof(str));
        }
    }

    if(c != 0) Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Muted players", str, "Close", "");
    else Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Muted players", "There are no muted players online.", "Close", "");
    return 1;
}

CMD:eject(playerid, params[])
{
    new id;
    
    if(userinfo[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
    if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{dd1493}/eject <id>");
    if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
    if(userinfo[id][plevel] >= userinfo[playerid][plevel]) return SendClientMessage(playerid, -1, "{ff0000}The player you are using the command is at the same or higher level than you.");
    if(!IsPlayerInAnyVehicle(id)) return SendClientMessage(playerid, -1, "{ff0000}Player is not in a vehicle.");

    new str[128];
    format(str, sizeof(str), "{eee8aa}You have ejected \"%s[%i]\" from a vehicle ( Name : %s ).", userinfo[id][pname],id, VehicleNames[GetVehicleModel(GetPlayerVehicleID(playerid))]);
    SendClientMessage(playerid, -1, str);
    ClearAnimations(id);
    return 1;
}

CMD:setskin(playerid, params[])
{
    new id, skinid;
    if(userinfo[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
    if(sscanf(params, "ud", id, skinid)) return SendClientMessage(playerid, -1, "{dd1493}/setskin <id> <skin id>");
    if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
    if(userinfo[id][plevel] >= userinfo[playerid][plevel]) return SendClientMessage(playerid, -1, "{ff0000}The player you are using the command is at the same or higher level than you.");
    if(skinid < 0 || skinid > 312) return SendClientMessage(playerid, -1, "{ff0000}Invalid skin ID.");

    ClearAnimations(playerid);
    SetPlayerSkin(playerid, skinid);
    
    new str[128];
    format(str, sizeof(str), "{eee8aa}You have set {ffffff}%s{eee8aa}'s skin to {ffffff}%d", userinfo[id][pname], skinid);
    SendClientMessage(playerid, -1, str);
    SendClientMessage(playerid, -1, "{eee8aa}Player's skin will reset once he respawn.");
    return 1;
}

CMD:vehrespawn(playerid, params[])
{
    if(userinfo[playerid][plevel] == 0) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");

    for(new i = 0; i < MAX_VEHICLES; i++)
    {
        if(IsValidVehicle(i)) SetVehicleToRespawn(i);
    }

    SendClientMessageToAll_(-1, "* {ffff00}An admin has respawned all vehicles.");
    return 1;
}

CMD:restart(playerid, params[])
{
    if(userinfo[playerid][plevel] < 4) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
    SetTimer("RestartServer", 10 * 1000, 0);
    SendClientMessageToAll_(-1, "{ff0000}Server will restart within {ffffff}10 {ff0000}seconds...");
    return 1;
}

CMD:jetpack(playerid, params[])
{
    if(userinfo[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
    return 1;
}

CMD:offjetpack(playerid, params[])
{
    if(userinfo[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    return 1;
}

/*CMD:aka(playerid, params[])
{
    new name[MAX_PLAYER_NAME];
    if(userinfo[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
    if(sscanf(params, "s["#MAX_PLAYER_NAME"]", name)) return SendClientMessage(playerid, -1, "{dd1493}/aka <name>");
   
    new str[128];
    new pass[BCRYPT_HASH_LENGTH], id;
    new aka[40][MAX_PLAYER_NAME];

    mysql_format(Database, str, sizeof(str), "SELECT `Password`, `User_ID` FROM `Users` WHERE `Name` = '%e'", name);
    mysql_query(Database, str);
    cache_get_value_name_int(0, "User_ID", id);
    cache_get_value_name(0, "Password", pass, sizeof(pass));    
    
    for(new i = 0; i < 40; i++)
    {   

    }
    return 1;
}*/

CMD:setpass(playerid, params[])
{
	new name[MAX_PLAYER_NAME], pass[40], str[128];
	
    if(userinfo[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "s["#MAX_PLAYER_NAME"]s[128]", name, pass)) return SendClientMessage(playerid, -1, "{ff1493}/setpass <name> <password>");
	
    mysql_format(Database, str, sizeof(str), "SELECT * FROM Users WHERE `Name` = '%e' LIMIT 1", name);
	new Cache:r = mysql_query(Database, str);
	if(!cache_num_rows()){ 
		
        cache_delete(r); 
        return SendClientMessage(playerid, -1, "{ff0000}Invalid player name (There's no such player registered)."); 
    }
	new lvl;
	cache_get_value_name_int(0, "Level", lvl);
    cache_delete(r);
    
    if(userinfo[playerid][plevel] <= lvl && !isequal(userinfo[playerid][pname], name)) return SendClientMessage(playerid, -1, "{ff0000}The person you are using the command is at the same or at a higher level.");
    if(strlen(pass) < 5) return SendClientMessage(playerid, -1, "{ff0000}Password must include atleast 5 characters.");
	if(strlen(pass) > 20) return SendClientMessage(playerid, -1, "{ff0000}Password cannot go over 20 characters.");
	
    bcrypt_hash(pass, BCRYPT_COST, "AdminSetPassword", "dss", playerid, name, pass);
    return 1;
}

forward AdminSetPassword(playerid, name[], pass[]);
public AdminSetPassword(playerid, name[], pass[])
{
    new buf[BCRYPT_HASH_LENGTH], str[128], playerconnected;
    bcrypt_get_hash(buf);

    foreach(new j : Player)
    {
        if(isequal(userinfo[j][pname], name))
        {
            format(userinfo[j][ppass], BCRYPT_HASH_LENGTH, "%s", buf);
            SendClientMessage(j, -1, "{eee8aa}Your password has been changed by an Admin.");
            format(str, sizeof(str), "{eee8aa}Your new password: {ffffff}%s", pass);
            SendClientMessage(j, -1, str);
            playerconnected = 1;
            break;
        } 
    }

    mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Password` = '%s' WHERE `Name` = '%e' LIMIT 1", buf, name);
    mysql_tquery(Database, str);
    
    format(str, sizeof(str), "{eee8aa}You have set %s's password to a new password succesfully.", name);
    SendClientMessage(playerid, -1, str);
    format(str, sizeof(str), "{eee8aa}New password of the user: %s", pass);
    SendClientMessage(playerid, -1, str);
    
    if(playerconnected == 1) SendClientMessage(playerid, -1, "{eee8aa}Player you entered is connected and the changed password has been sent to him.");
    
    WriteLog(LOG_ADMINACTIONS, "COMMAND: setpass | Admin: %s | Affected: %s", userinfo[playerid][pname], name); 
    WriteLog(LOG_PASS, "Admin: %s | Affected: %s | Hash: %s", userinfo[playerid][pname], name, buf); 
    return 1;
}

CMD:setname(playerid, params[])
{
	new oname[MAX_PLAYER_NAME], nname[MAX_PLAYER_NAME], str[128], playerconnected = 0, id = -1;
	if(userinfo[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "s["#MAX_PLAYER_NAME"]s["#MAX_PLAYER_NAME"]", oname, nname)) return SendClientMessage(playerid, -1, "{ff1493}/setname <oldname> <newname>");
	mysql_format(Database, str, sizeof(str), "SELECT * FROM Users WHERE `Name` = '%e' LIMIT 1", oname);
	new Cache:r = mysql_query(Database, str);
	if(!cache_num_rows()){ 
		
        cache_delete(r); 
        return SendClientMessage(playerid, -1, "{ff0000}Invalid player name (There's no such player registered)."); 
    }
	new lvl;
	cache_get_value_name_int(0, "Level", lvl);
	cache_delete(r); 
    if(lvl >= userinfo[playerid][plevel]) return SendClientMessage(playerid, -1, "{ff0000}The player you are going to set name is at the same or at a higher level.");
	if(strlen(nname) < 4 || strlen(nname) > 19 ) return SendClientMessage(playerid, -1, "{ff0000}New name of the player must in between 4 - 20 characters.");
	if(!IsValidName(nname)) return SendClientMessage(playerid, -1, "{ff0000}New name of the player contains invalid characters.");
	mysql_format(Database, str, sizeof(str), "SELECT * FROM Users WHERE `Name` = '%e' LIMIT 1", nname);
	r = mysql_query(Database, str);
	if(cache_num_rows()){ 
		
        cache_delete(r); 
        return SendClientMessage(playerid, -1, "{ff0000}There's another player with that name already."); 
    }
	cache_delete(r); 

    mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Name` = '%e' WHERE `Name` = '%e' LIMIT 1", nname, oname);
	mysql_tquery(Database, str);

	foreach(new j : Player)
	{
		if(isequal(userinfo[j][pname], oname))
		{
			playerconnected = 1;
			id = j;
			break;
		} 
	}

	format(str, sizeof(str), "{eee8aa}You have set {ffffff}%s{eee8aa}'s name to a new name succesfully.", oname);
	SendClientMessage(playerid, -1, str);
	format(str, sizeof(str), "{eee8aa}New name of the user: %s", nname);
	SendClientMessage(playerid, -1, str);

	if(playerconnected == 1)
	{
		SendClientMessage(playerid, -1, "{eee8aa}Player you entered is connected and the information about name changes has been sent to him.");
		
        SetPlayerName(id, nname);
        
        SendClientMessage(id, -1, "{eee8aa}Your name has been changed by an Admin.");
        format(str, sizeof(str), "{eee8aa}Your new name: {ffffff}%s", nname);
        SendClientMessage(id, -1, str);

        format(userinfo[playerid][pname], MAX_PLAYER_NAME, "%s", nname);
	}

	WriteLog(LOG_ADMINACTIONS, "COMMAND: setname | Admin: %s | Affected: %s |nnewname: %s", userinfo[playerid][pname], oname, nname); 
	return 1;
}

CMD:top(playerid, params[])
{
	Dialog_Show(playerid, DIALOG_TOP_SELECTION, DIALOG_STYLE_LIST, "{ffa500}LGGW {ffffff}- Top List", "Top Players\nTop Killers\nTop Weakest\nTop Richest\nTop duels won\nTop rampages\nTop robbers\nTop revenges\nTop turf owners\nTop Gangs\nTop Brutal killers\nTop LMS winners\nTop GunGame winners\nTop Head shotters", "Select", "Cancel");  
	return 1;
}

CMD:setkills(playerid, params[])
{
	new id, amount, str[128];
	if(userinfo[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "ui", id, amount)) return SendClientMessage(playerid, -1, "{ff1493}/setkills <id> <amount>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{ff0000}Player is not spawned yet.");
	if(userinfo[playerid][plevel] <= userinfo[id][plevel] && id != playerid) return SendClientMessage(playerid, -1, "{ff0000}The person you are using the command is at the same or at a higher level.");
	userinfo[id][pkills] = amount;
	SetPlayerScore(id, amount);
	SendClientMessage(id, -1, "{eee8aa}Your kills has been changed by an Admin");
	format(str, sizeof(str), "{eee8aa}New amount of kills: %d", amount);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{eee8aa}You have changed %s's kills to %d", userinfo[id][pname], amount);
	SendClientMessage(playerid, -1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: setkills | Admin: %s | Affected: %s | Kills: %d", userinfo[playerid][pname], userinfo[id][pname], amount); 
	mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Kills` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[id][pkills], userinfo[id][pid]);
	mysql_tquery(Database, str);
	return 1;
}

CMD:setdeaths(playerid, params[])
{
	new id, amount, str[128];
	if(userinfo[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "ui", id, amount)) return SendClientMessage(playerid, -1, "{ff1493}/setdeaths <id> <amount>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{ff0000}Player is not spawned yet.");
	if(userinfo[playerid][plevel] <= userinfo[id][plevel] && id != playerid) return SendClientMessage(playerid, -1, "{ff0000}The person you are using the command is at the same or at a higher level.");
	userinfo[id][pdeaths] = amount;
	SendClientMessage(id, -1, "{eee8aa}Your deaths has been changed by an Admin");
	format(str, sizeof(str), "{eee8aa}New amount of deaths: %d", amount);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{eee8aa}You have changed %s's deaths to %d", userinfo[id][pname], amount);
	SendClientMessage(playerid, -1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: setdeaths | Admin: %s | Affected: %s | Deaths: %d", userinfo[playerid][pname], userinfo[id][pname], amount); 
	mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Deaths` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[id][pdeaths], userinfo[id][pid]);
	mysql_tquery(Database, str);
	return 1;
}

CMD:sethealth(playerid, params[])
{
	new id, amount, str[128];
	if(userinfo[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "ui", id, amount)) return SendClientMessage(playerid, -1, "{ff1493}/sethealth <id> <amount>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(amount < 0 || amount > 100) return SendClientMessage(playerid, -1, "{ff0000}Invalid health amount");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{ff0000}Player is not spawned yet.");
	if(userinfo[playerid][plevel] <= userinfo[id][plevel] && id != playerid) return SendClientMessage(playerid, -1, "{ff0000}The person you are using the command is at the same or at a higher level.");
	SetPlayerHealth(id, amount);
	SendClientMessage(id, -1, "{eee8aa}Your health(HP) has been changed by an Admin");
	format(str, sizeof(str), "{eee8aa}New health(HP): %d", amount);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{eee8aa}You have changed %s's health to %d", userinfo[id][pname], amount);
	SendClientMessage(playerid, -1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: sethealth | Admin: %s | Affected: %s | Health: %d", userinfo[playerid][pname], userinfo[id][pname], amount); 
	return 1;
}

CMD:setarmour(playerid, params[])
{
	new id, amount, str[128];
	if(userinfo[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "ui", id, amount)) return SendClientMessage(playerid, -1, "{ff1493}/setarmour <id> <amount>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(amount < 0 || amount > 100) return SendClientMessage(playerid, -1, "{ff0000}Invalid armour amount");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{ff0000}Player is not spawned yet.");
	if(userinfo[playerid][plevel] <= userinfo[id][plevel] && id != playerid) return SendClientMessage(playerid, -1, "{ff0000}The person you are using the command is at the same or at a higher level.");
	SetPlayerArmour(id, amount);
	SendClientMessage(id, -1, "{eee8aa}Your armour has been changed by an Admin");
	format(str, sizeof(str), "{eee8aa}New armour: %d", amount);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{eee8aa}You have changed %s's armour to %d", userinfo[id][pname], amount);
	SendClientMessage(playerid, -1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: setarmour | Admin: %s | Affected: %s | Armour: %d", userinfo[playerid][pname], userinfo[id][pname], amount); 
	return 1;
}

CMD:givegun(playerid, params[])
{
	new gun, ammo, id, str[128];
	if(userinfo[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params,"uii", id, gun, ammo)) return SendClientMessage(playerid, -1, "{ff1493}/givegun <id> <weapon> <ammo>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(gun < 1 || gun > 47) return SendClientMessage(playerid, -1, "{ff0000}Invalid weapon ID (use a ID in between 1 - 47).");
	if(ammo < 1 || ammo > 999999) return SendClientMessage(playerid, -1, "{ff0000}Invalid ammo amount (use an amount of ammo in between 1 - 999999).");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{ff0000}Player is not spawned yet.");
	GivePlayerWeapon(id, gun, ammo);
	format(str, sizeof(str), "{eee8aa}An admin has given you a weapon with ID %d and %d rounds of ammo", GunName(gun), ammo);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{eee8aa}You have given \"%s\" a weapon with ID %d and with %d rounds of ammo", userinfo[id][pname], GunName(gun), ammo);
	SendClientMessage(playerid, -1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: givegun | Admin: %s | Affected: %s | Gun: %s | Ammo: %d", userinfo[playerid][pname], userinfo[id][pname], GunName(gun), ammo); 
	return 1;
}

CMD:agivecash(playerid, params[])
{
	new amount, id, str[128];
	if(userinfo[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params,"ui", id, amount)) return SendClientMessage(playerid, -1, "{ff1493}/agivecash <id> <amount>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(amount < 1 || amount > 999999) return SendClientMessage(playerid, -1, "{ff0000}Invalid cash amount (use an amount of cash in between $1 - 999999).");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{ff0000}Player is not spawned yet.");
	GivePlayerCash(id, amount);
	format(str, sizeof(str), "{eee8aa}An admin has given you $%d", amount);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{eee8aa}You have given \"%s\" $%d", userinfo[id][pname], amount);
	SendClientMessage(playerid, -1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: agivecash | Admin: %s | Affected: %s | Cash: %d", userinfo[playerid][pname], userinfo[id][pname], amount); 
	return 1;
}

CMD:fine(playerid, params[])
{
	new amount, id, str[128];
	if(userinfo[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params,"ui", id, amount)) return SendClientMessage(playerid, -1, "{ff1493}/fine <id> <amount>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(amount < 1 || amount > 999999) return SendClientMessage(playerid, -1, "{ff0000}Invalid fine cash amount (use an amount of cash in between $1 - 999999).");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{ff0000}Player is not spawned yet.");
	if(userinfo[playerid][plevel] <= userinfo[id][plevel] && id != playerid) return SendClientMessage(playerid, -1, "{ff0000}The person you are using the command is at the same or at a higher level.");
	GivePlayerCash(id, -amount);
	format(str, sizeof(str), "{eee8aa}An admin has fined you $%d", amount);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{eee8aa}You have fined \"%s\" $%d", userinfo[id][pname], amount);
	SendClientMessage(playerid, -1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: fine | Admin: %s | Affected: %s | Cash: %s", userinfo[playerid][pname], userinfo[id][pname], amount); 
	return 1;
}

CMD:givecash(playerid, params[])
{
	new amount, id, str[128];
	if(sscanf(params,"ui", id, amount)) return SendClientMessage(playerid, -1, "{ff1493}/givecash <id> <amount>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(amount < 1 || amount > 300000) return SendClientMessage(playerid, -1, "{ff0000}Invalid cash amount (use an amount of cash in between $1 - 300000).");
	if(amount > GetPlayerCash(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You dont have such amount of money to give him");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{ff0000}Player is not spawned yet.");
	if(userinfo[playerid][ptime] < (3 * 60 * 60)) return SendClientMessage(playerid, -1, "{ff0000}You need to play atleast 3 hours to use /givecash");
	GivePlayerCash(id, amount);
	GivePlayerCash(playerid, -amount);
	format(str, sizeof(str), "{eee8aa}\"%s\" has given you $%d", userinfo[playerid][pname], amount);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{eee8aa}You have given \"%s\" $%d", userinfo[id][pname], amount);
	SendClientMessage(playerid, -1, str);
	return 1;
}

stock GetTotalGangMembers(g_id)
{   
    new str[80];
    mysql_format(Database, str, sizeof(str), "SELECT `User_ID` FROM `Users` WHERE `Gang_ID` = %d AND `In_gang` = 1", g_id);
    new Cache:r = mysql_query(Database, str);
    new rows; 
    cache_get_row_count(rows);
    cache_delete(r); 
    return rows;
}
/*
stock isNumeric(const string[])
{
  new length=strlen(string);
  if (length==0) return false;
  for (new i = 0; i < length; i++)
    {
      if (
            (string[i] > '9' || string[i] < '0' && string[i]!='-' && string[i]!='+') 
             || (string[i]=='-' && i!=0)                                             
             || (string[i]=='+' && i!=0)                                             
         ) return false;
    }
  if (length==1 && (string[0]=='-' || string[0]=='+')) return false;
  return true;
}*/

CMD:gang(playerid, params[])
{
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	new tmp, tmp_1, str[700], gstr[128], name[MAX_PLAYER_NAME];

    if(isequal(params, "create", true))
	{
		new con_;
		for(new i = 0; i < MAX_GANGS; i ++)
		{
			if(IsValidGang(i)) con_ ++;
		}

		if(con_ == MAX_GANGS) return SendClientMessage(playerid, -1, "{ff0000}Gang slots are full! Report about this to admins!");
		if(userinfo[playerid][ingang] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a gang");
		if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
		if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have participated for Last Man Standing.");
		if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are invited for a duel, use /no to refuse or /yes to accept it.");
		if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have invited someone for a duel, use /cancel.");
		
		if(GetPlayerCash(playerid) < MIN_CASH_TO_CREATE_A_GANG) 
		{
			format(str, sizeof(str), "{ff0000}You don't have enough money to create a gang (Required: $%d).", MIN_CASH_TO_CREATE_A_GANG);
			return SendClientMessage(playerid, -1, str);
		}
		if(GetPlayerScore(playerid) < MIN_SCORE_TO_CREATE_GANG)
		{
			format(str, sizeof(str), "{ff0000}You don't have enough score to create a gang (Required: %d).", MIN_SCORE_TO_CREATE_GANG);
			return SendClientMessage(playerid, -1, str);
		} 
        Dialog_Show(playerid, DIALOG_GANG_ENTER_NAME, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Create a gang (Step - 1).", "{ffffff}Insert the {ffff00}name of the {7fff00}gang {ffffff}that you want to create\n\n{ff0000}[ Note ] {ffffff}Name length should in between 6 - 29", "Enter", "Close");
	}
    else if(!sscanf(params, "'skin'D(-1)", tmp))
	{
		if(userinfo[playerid][ingang] == 0) return SendClientMessage(playerid, -1, "{ff0000}You are not in a gang.");
		if(tmp == -1) return SendClientMessage(playerid, -1, "{ff1493}/gang skin <id>");
		if(GetPlayerCash(playerid) < MIN_CASH_TO_CHANGE_SKIN) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!");
		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You are in a vehicle.");
		if(GetPlayerSkin(playerid) == tmp) return SendClientMessage(playerid, -1, "{ff0000}You already have this skin");
		switch(tmp)
		{
			case 41, 55, 63, 85, 102 .. 110, 114 .. 117, 163 .. 165, 265 .. 267, 269 .. 271, 284 .. 286: return SendClientMessage(playerid, -1, "{ff0000}Invalid skin ID.");
			case 23, 24, 29, 34, 100, 122, 133, 169, 185, 188, 216, 219, 225, 250, 261, 306, 211, 223:
			{
				if(userinfo[playerid][VIP] == 0) return SendClientMessage(playerid, -1, "{ff0000}This skin is only for VIPs");
				ClearAnimations(playerid);
				GivePlayerCash(playerid, -MIN_CASH_TO_CHANGE_SKIN);
				userinfo[playerid][gskin] = tmp;
				SetPlayerSkin(playerid, tmp);
				
				mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Gang_skin` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][gskin], userinfo[playerid][pid]);
				mysql_tquery(Database, str);
			}
			default:
			{
				if(tmp > 299 || tmp < 0) return SendClientMessage(playerid, -1, "{ff0000}Invalid skin ID.");
				ClearAnimations(playerid);
				GivePlayerCash(playerid, -MIN_CASH_TO_CHANGE_SKIN);
				userinfo[playerid][gskin] = tmp;
				SetPlayerSkin(playerid, tmp);
				
				mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Gang_skin` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][gskin], userinfo[playerid][pid]);
				mysql_tquery(Database, str);
			}
		}
		if(inminigame[playerid] == 1 && indm[playerid] == 1) SKIN[playerid] = userinfo[playerid][gskin];
	}
	else if(!sscanf(params, "'join'D(-1)", tmp))
	{
		if(userinfo[playerid][ingang] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a gang");

		if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
		if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have participated for Last Man Standing.");
		if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are invited for a duel, use /no to refuse or /yes to accept it.");
		if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have invited someone for a duel, use /cancel.");

		if(tmp == -1) return SendClientMessage(playerid, -1, "{ff1493}/gang join <id>");
		if(!IsValidGang(tmp) || tmp < 7) return SendClientMessage(playerid, -1, "{ff0000}Invalid gang ID.");
		if(GetTotalGangMembers(tmp) == MAX_GANG_MEMBERS) return SendClientMessage(playerid, -1, "{ff0000}This gang is full.  Ask gang boss to kick inactive members!");
		if(grequested[playerid]) return SendClientMessage(playerid, -1, "{ff0000}Wait before sending another gang request!");
        reqtimer[playerid] = SetTimerEx("ExpireGangRequest", 120000, false, "i", playerid);
		format(str, sizeof(str), "{eee8aa}Gang request for Gang - '%s[%d]' has been sent (Ask someone of that gang to accept your request).", ReplaceUwithS(ganginfo[tmp][gname]), tmp);
		SendClientMessage(playerid, -1, str);
		grequested[playerid] = 1;
		grequestedid[playerid] = tmp;
		format(str, sizeof(str), "{ffffff}%s[%d] {9370DB}sent a gang request for your gang (Type \"/gang accept %d\" to accept him).", userinfo[playerid][pname], playerid, playerid);
		foreach( new i : Player)
		{
			if(userinfo[i][ingang] == 1)
			{
				if(userinfo[i][gid] == tmp)
				{
					SendClientMessage(i, -1, str);
				}
			}
		}
	}
	else if(isequal(params, "leave", true))
	{
		if(userinfo[playerid][ingang] == 0) return SendClientMessage(playerid, -1, "{ff0000}You are not in a gang.");

		if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
		if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have participated for Last Man Standing.");
		if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are invited for a duel, use /no to refuse or /yes to accept it.");
		if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have invited someone for a duel, use /cancel.");

		if(userinfo[playerid][glevel] < 4)
		{   
			userinfo[playerid][glevel] = 0;
			userinfo[playerid][ingang] = 0;
			userinfo[playerid][gskin] = 1;
			userinfo[playerid][gid] = -1;
			SendClientMessage(playerid, -1, "{9370DB}You have left the gang");
			format(str, sizeof(str), "{9370DB}%s has left the gang", userinfo[playerid][pname]);
			foreach(new j : Player)
			{
				if(GetPlayerTeam(playerid) == GetPlayerTeam(j) && j != playerid)
				{
					SendClientMessage(j, -1, str);
				}
			}
			ForceClassSelection(playerid);
			SetPlayerHealth(playerid, 0); 

            mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `In_gang` = 0 WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][pid]);
            mysql_tquery(Database, str);
		}
		else return Dialog_Show(playerid, DIALOG_GANG_WARNING, DIALOG_STYLE_MSGBOX, "{ffa500}LGGW {ffffff}- Gang leave warning", "{ffffff}You are the {ff0000}boss {ffffff}of this {7fff00}gang\n{ffffff}If a {ff0000}gang boss {ffffff}leave a gang it will result in a {ffff00}gang destroy\n{ffffff}You can overcome {ff0000}gang destroy {ffffff}by appointing someone as {ffff00}gang boss", "Destroy", "Cancel");
	}
	else if(!sscanf(params, "'accept'D(-1)", tmp))
	{
		if(userinfo[playerid][ingang] == 0) return SendClientMessage(playerid, -1, "{ff0000}You are not in a gang.");
		if(userinfo[playerid][glevel] < 2) return SendClientMessage(playerid, -1, "{ff0000}You are not authorized to use this command (Required: Warrior level or higher).");

		if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
		if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have participated for Last Man Standing.");
		if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are invited for a duel, use /no to refuse or /yes to accept it.");
		if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have invited someone for a duel, use /cancel.");
		
		if(tmp == -1) return SendClientMessage(playerid, -1, "{ff1493}/gang accept <id>");
		if(!IsPlayerConnected(tmp)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");

		if(inminigame[tmp] == 1) return SendClientMessage(playerid, -1, "{ff0000}Player is in a minigame.");

		new idog = userinfo[playerid][gid];
		if(grequested[tmp] == 0 || grequestedid[tmp] != idog) return SendClientMessage(playerid, -1, "{ff0000}Player haven't sent any Gang join requests to your gang");
		SendClientMessage(tmp, -1, "{9370DB}You have been accepted");
		userinfo[tmp][glevel] = 1;
		userinfo[tmp][ingang] = 1;
		userinfo[tmp][gskin] = 1;
		userinfo[tmp][gid] = idog;

		mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `In_gang` = 1, `Gang_ID` = %d, `Gang_level` = 1, `Gang_skin` = 1 WHERE `User_ID` = %d LIMIT 1", userinfo[tmp][gid], userinfo[tmp][pid]);
		mysql_tquery(Database, str);
	
		SetPlayerSkin(tmp, userinfo[tmp][gskin]);
		SetPlayerColor(tmp, ganginfo[idog][gcolor]);
		SetPlayerTeam(tmp, idog);
	
		KillTimer(reqtimer[tmp]);
		reqtimer[tmp] = INVALID_PLAYER_ID;
	
		grequested[playerid] = 0;
		grequestedid[playerid] = -1;
	
		format(str, sizeof(str), "{9370DB}%s[%d] has joined the gang", userinfo[tmp][pname], tmp);
		foreach( new i : Player)
		{
			if(userinfo[i][ingang] == 1)
			{
				if(userinfo[i][gid] == idog)
				{
					SendClientMessage(i, -1, str);
				}
			}
		}

		Delete3DTextLabel(glabel[tmp]);

		new tag[10];
		format(tag, sizeof(tag), "| %s |", ganginfo[idog][gtag]);
		glabel[tmp] = Create3DTextLabel(tag, ganginfo[idog][gcolor], 30.0, 40.0, 50.0, 50.0, 0);
		Attach3DTextLabelToPlayer(glabel[tmp], tmp, 0.0, 0.0, 0.3);

        mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `In_gang` = 1, `Gang_ID` = %d, `Gang_skin` = 1, `Gang_level` = 1 WHERE `User_ID` = %d LIMIT 1", idog, userinfo[tmp][pid] + 1);
        mysql_tquery(Database, str);
	}
	else if(isequal(params, "destroy", true))
	{
		if(userinfo[playerid][ingang] == 0) return SendClientMessage(playerid, -1, "{ff0000}You are not in a gang.");
		if(userinfo[playerid][glevel] < 4) return SendClientMessage(playerid, -1, "{ff0000}You are not authorized to use this command (Required: Boss level).");

		if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
		if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have participated for Last Man Standing.");
		if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are invited for a duel, use /no to refuse or /yes to accept it.");
		if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have invited someone for a duel, use /cancel.");

		new key = userinfo[playerid][gid];

		if(IsValidVehicle(gang_veh[key]))
		{
			gang_veh[key] = INVALID_VEHICLE_ID;
			gvehowned[gang_veh[key]] = 0;
			gvehid[gang_veh[key]] = -1;
            DestroyProgressBar3D(gang_vlabel[userinfo[playerid][gid]]);
			DestroyVehicle(gang_veh[key]);
		}

		for(new i = 0; i < sizeof(zoneinfo); i++)
		{
			if(zoneinfo[i][zteamid] == key)
			{
				new Rand = random(sizeof(TeamRandoms));
				zoneinfo[i][zteamid] = TeamRandoms[Rand];
				GangZoneShowForAll(ZONEID[i], Zone_ColorAlpha(ganginfo[zoneinfo[i][zteamid]][gcolor]));

				ganginfo[TeamRandoms[Rand]][gturfs]++;
			}
		}
	   
		if(ganginfo[key][ghouse] == 1)
		{
			houseinfo[ganginfo[key][ghouseid]][howned] = 0;
			houseinfo[ganginfo[key][ghouseid]][hteamid] = -1;
			Delete3DTextLabel(hlabel[ganginfo[key][ghouseid]]);
			hlabel[ganginfo[key][ghouseid]] = Create3DTextLabel("{FF6347}[Head Qauters]\n* Unowned", -1, houseinfo[ganginfo[userinfo[playerid][gid]][ghouseid]][entercp][0], houseinfo[ganginfo[userinfo[playerid][gid]][ghouseid]][entercp][1], houseinfo[ganginfo[userinfo[playerid][gid]][ghouseid]][entercp][2], 50.0, 0, 0);
			DestroyDynamicMapIcon(houseinfo[ganginfo[key][ghouseid]][icon_id]);  
			houseinfo[ganginfo[key][ghouseid]][icon_id] = CreateDynamicMapIcon(houseinfo[ganginfo[key][ghouseid]][entercp][0], houseinfo[ganginfo[key][ghouseid]][entercp][1], houseinfo[ganginfo[key][ghouseid]][entercp][2], 31, 0, -1, -1, -1, 300.0, MAPICON_GLOBAL);
		}      

        mysql_format(Database, str, sizeof(str), "UPDATE `Gangs` SET `Name` = '-1' WHERE `Gang_ID` = %d LIMIT 1", userinfo[playerid][gid] + 1);
        mysql_tquery(Database, str);

        mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `In_gang` = 0 WHERE (`Gang_ID` = %d AND `In_gang` = 1) LIMIT "#MAX_GANG_MEMBERS"", userinfo[playerid][gid]);
        mysql_tquery(Database, str);

		foreach(new j : Player)
		{
			if(userinfo[playerid][gid] == userinfo[j][gid])
			{
				userinfo[j][ingang] = 0;
				userinfo[j][glevel] = 0;
				userinfo[j][gskin] = 1;
				userinfo[j][gid] = -1;
				
				Delete3DTextLabel(glabel[j]);
				ForceClassSelection(j);
				SetPlayerHealth(j, 0);
				SendClientMessage(j, -1, "{eee8aa}Your gang has been destroyed!!!");
			}

		}

		format(ganginfo[key][gname], 30, "%d", -1);
		format(ganginfo[key][gtag], 6, "%d", -1);

		ganginfo[key][gcolor] = 0xFFFFFFFF;
		ganginfo[key][ghouse] = 0;
		ganginfo[key][ghouseid] = -1;
		ganginfo[key][gkills] = 0;
		ganginfo[key][gdeaths] = 0;
		ganginfo[key][gscore] = 0;
		ganginfo[key][gturfs] = 0; 
		ganginfo[key][gveh] = 0; 
		ganginfo[key][gvmodel] = 0; 
	}
	else if(isequal(params, "house", true))
	{
		new incp, dstr[1024], dialog[1024];
		if(userinfo[playerid][ingang] == 0) return SendClientMessage(playerid, -1, "{ff0000}You are not in a gang.");
		if(userinfo[playerid][glevel] < 4) return SendClientMessage(playerid, -1, "{ff0000}You are not authorized to use this command (Required: Boss level).");
		if(ganginfo[userinfo[playerid][gid]][ghouse])
		{
			strcat(dstr, "{ffff00}                Gang House - %d             \n\n");
			strcat(dstr, "{7fff00}              Your Gang House Info          \n"); 
			strcat(dstr, "{ffff00}--------------------------------------------\n");
			strcat(dstr, "{ffffff}- Interior type: {ffff00}%s                         \n");
			strcat(dstr, "{ffffff}- Exterior type: {ffff00}%s                         \n");
			strcat(dstr, "{ffffff}- Price: {ffff00}$%d                                \n");
			strcat(dstr, "{ffff00}--------------------------------------------\n");
			strcat(dstr, "{ffffff}* {7fff00}You will recieve only half of the original\n"); 
			strcat(dstr, "  price if you sell This Gang House         \n");
			strcat(dstr, "{ffffff}* {7fff00}Refund: $%d                               \n\n");
			strcat(dstr, "{ff0000}[ Note ] {ff0000}This action is irreversable         ");
			format(dialog, sizeof(dialog), dstr, ganginfo[userinfo[playerid][gid]][ghouseid], houseinfo[ganginfo[userinfo[playerid][gid]][ghouseid]][hinttype], houseinfo[ganginfo[userinfo[playerid][gid]][ghouseid]][hextype], houseinfo[ganginfo[userinfo[playerid][gid]][ghouseid]][hprice], (houseinfo[ganginfo[userinfo[playerid][gid]][ghouseid]][hprice] / 2));
			return Dialog_Show(playerid, DIALOG_SELL_HOUSE, DIALOG_STYLE_MSGBOX, "{ffa500}LGGW {ffffff}- Gang House Info & Options", dialog, "Sell", "Close");
		}

		for(new i = 0; i < sizeof(houseinfo); i++)
		{
			if(IsPlayerInDynamicCP(playerid, STREAMER_TAG_CP GENTERCP[i]))
			{
				incp = 1;
				strcat(dstr, "{ffff00}                 Gang House - %d                \n\n");
				strcat(dstr, "{ffffff}* {7fff00}You can select options by entering option IDs \n");
				strcat(dstr, "{ffffff}* {7fff00}Use 'preview' to ensure this is the house you \n");
				strcat(dstr, "  want                                          \n");
				strcat(dstr, "{ffffff}* {7fff00}Check out the price before purchase           \n");
				strcat(dstr, "{ffffff}* {7fff00}You will recieve only half of the price if you\n");
				strcat(dstr, "  sell this house after purchase                \n");
				strcat(dstr, "{ffff00}------------------------------------------------\n");
				strcat(dstr, "{ffffff}- Interior type: {ffff00}%s                             \n");
				strcat(dstr, "{ffffff}- Exterior type: {ffff00}%s                             \n");
				strcat(dstr, "{ffffff}- Price: {ffff00}$%d                                    \n");
				strcat(dstr, "{ffff00}------------------------------------------------\n");
				strcat(dstr, "  {e9967a}ID                        Option              \n");
				strcat(dstr, "  {ff0000}1                         {ffffff}Preview             \n"); 
				strcat(dstr, "  {ff0000}2                         {ffffff}Purchase            \n");
				strcat(dstr, "{ff0000}[ Note ] {ffffff}Purchasing action is irreversable      \n");
				format(dialog, sizeof(dialog), dstr, i, houseinfo[i][hinttype], houseinfo[i][hextype], houseinfo[i][hprice]);
				Dialog_Show(playerid, DIALOG_BUY_HOUSE, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Gang House Info & Options", dialog, "Enter", "Close");
				break;
			}
			else incp = 0;
		}

		if(incp == 0) SendClientMessage(playerid, -1, "{ff0000}Go to a Gang House checkpoint and use '/gang house'");
	}
	else if(isequal(params, "color", true))
	{
		if(userinfo[playerid][ingang] == 0) return SendClientMessage(playerid, -1, "{ff0000}You are not in a gang.");
		if(userinfo[playerid][glevel] < 3) return SendClientMessage(playerid, -1, "{ff0000}You are not authorized to use this command (Required: Under-Boss level or higher).");
        strcat(str, "For each color it will cost {ffff00}$"#MIN_CASH_TO_CHANGE_GANG_COLOR"\n\n{ffffff}ID\tColor\n\n{696969}1\tDim Gray\n{2f4f4f}2\tDark Slate Gray\n{f0e68c}3\tKhaki\n", sizeof(str));
        strcat(str, "{ff0000}4\tRed\n{FF6347}5\tSalmon\n{ff69b4}6\tHot Pink\n{8b4513}7\tSaddle Brown\n{eee8aa}8\tPeru\n{b22222}9\tFirebrick\n{9370db}10\tMedium Purple\n{c1cdc1}11\tHoneydew\n", sizeof(str));
        strcat(str, "{000033}12\tBlackish Blue\n{6495ed}13\tCornflower Blue\n{7cfc00}14\tLawn Green\n{556b2f}15\tDark Olive Green", sizeof(str));
		Dialog_Show(playerid, DIALOG_GANG_COLOR, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Gang Color", str, "Enter", "Close");
	}
	else if(!sscanf(params, "'setlevel'D(-1)D(-1)", tmp, tmp_1))
	{
		if(tmp == -1 || tmp_1 == -1) return SendClientMessage(playerid, -1, "{ff1493}/gang setlevel <id> <level>");
		if(userinfo[playerid][ingang] == 0) return SendClientMessage(playerid, -1, "{ff0000}You are not in a gang.");
		if(userinfo[playerid][glevel] < 3) return SendClientMessage(playerid, -1, "{ff0000}You are not authorized to use this command (Required: Under-Boss level or higher).");
		if(!IsPlayerConnected(tmp)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
		if(tmp == playerid) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command on you.");
		if(userinfo[tmp][gid] != userinfo[playerid][gid]) return SendClientMessage(playerid, -1, "{ff0000}Player is not in your gang");
		if(userinfo[playerid][glevel] == userinfo[tmp][glevel] || userinfo[playerid][glevel] < userinfo[tmp][glevel]) return SendClientMessage(playerid, -1, "{ff0000}The player you are going to change gang level is in the same level or at a higher level than you.");
		if(tmp_1 > 3 || tmp_1 < 1) SendClientMessage(playerid, -1, "{ff0000}Use a level in between 1 - 3, If you want to set the gang Boss Use '/gang setboss'");
		if(userinfo[tmp][glevel] == tmp_1) return SendClientMessage(playerid, -1, "{ff0000}Player is already is already in this level");
		if(userinfo[tmp][glevel] < tmp_1){
			GameTextForPlayer(tmp, "~g~PROMOTED!", 3000, 3);
			format(str, sizeof(str), "{9370DB}You have been promoted to \"%s\" level.", GangLevelName(tmp_1));
		}
		else{
			GameTextForPlayer(tmp, "~r~DEMOTED!", 3000, 3);
			format(str, sizeof(str), "{9370DB}You have been demoted to \"%s\" level.", GangLevelName(tmp_1));
		}
		userinfo[tmp][glevel] = tmp_1;
		SendClientMessage(tmp, -1, str);
		format(str, sizeof(str), "{9370DB}You have given \"%s\" level to \"%s[%i]\"", GangLevelName(tmp_1), userinfo[tmp][pname]);
		SendClientMessage(playerid, -1, str);

		mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Gang_level` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[tmp][glevel], userinfo[tmp][pid]);
		mysql_tquery(Database, str);
	}
	else if(!sscanf(params, "'kick'D(-1)", tmp))
	{
		if(tmp == -1) return SendClientMessage(playerid, -1, "{ff1493}/gang kick <id>");
		if(userinfo[playerid][ingang] == 0) return SendClientMessage(playerid, -1, "{ff0000}You are not in a gang.");
		if(userinfo[playerid][glevel] < 3) return SendClientMessage(playerid, -1, "{ff0000}You are not authorized to use this command (Required: Under-Boss level or higher).");
		if(!IsPlayerConnected(tmp)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
		if(tmp == playerid) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command on you.");
		if(userinfo[tmp][gid] != userinfo[playerid][gid]) return SendClientMessage(playerid, -1, "{ff0000}Player is not in your gang");
		if(userinfo[playerid][glevel] == userinfo[tmp][glevel] || userinfo[playerid][glevel] < userinfo[tmp][glevel]) return SendClientMessage(playerid, -1, "{ff0000}The player you are going to kick is in the same level or at a higher level than you.");
		if(inminigame[tmp]) return SendClientMessage(playerid, -1, "{ff0000}Player is currently in a minigame.");
		
		userinfo[tmp][ingang] = 0;
		userinfo[tmp][glevel] = 0;
		userinfo[tmp][gskin] = 1;
		userinfo[tmp][gid] = -1;

		if(userinfo[tmp][vowned] == 1 && priveh[tmp] != INVALID_VEHICLE_ID)
		{
			DestroyPrivateVehicle(tmp);
		}

		ForceClassSelection(tmp);
		SetPlayerHealth(tmp, 0);

		SendClientMessage(tmp, -1, "{9370DB}You have been kicked out of the gang");
		format(str, sizeof(str), "{9370DB}You kicked %s from the gang", userinfo[tmp][pname]);
		SendClientMessage(playerid, -1, str);
	}
	else if(!sscanf(params, "'setboss'D(-1)", tmp))
	{
		if(tmp == -1) return SendClientMessage(playerid, -1, "{ff1493}/gang setboss <id>");
		if(userinfo[playerid][ingang] == 0) return SendClientMessage(playerid, -1, "{ff0000}You are not in a gang.");
		if(userinfo[playerid][glevel] < 4) return SendClientMessage(playerid, -1, "{ff0000}You are not authorized to use this command (Required: Boss level).");
		if(!IsPlayerConnected(tmp)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
		if(tmp == playerid) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command on you.");
		if(userinfo[playerid][gid] != userinfo[tmp][gid]) return SendClientMessage(playerid, -1, "{ff0000}Player is not in your gang");
		
		userinfo[playerid][glevel] = 3;
		userinfo[tmp][glevel] = 4;
		format(str, sizeof(str), "{9370DB}You have given gang Boss level to %s", userinfo[tmp][pname]);
		SendClientMessage(playerid, -1, str);
		SendClientMessage(playerid, -1, "{9370DB}You have been demoted to level Under-Boss");
		SendClientMessage(tmp, -1, "{9370DB}You have been promoted to gang Boss level (Founder level).");
		SendClientMessage(tmp, -1, "{9370DB}Welcome new Boss!");
		SendClientMessage(tmp, -1, "{9370DB}If you need any help with developing the gang, Use '/gang help'");
		GameTextForPlayer(tmp, "Congradulations!", 5, 5);

		mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Gang_level` = 4 WHERE `User_ID` = %d LIMIT 1", userinfo[tmp][pid]);
		mysql_tquery(Database, str);
	}
	else if(isequal(params, "members", true))
	{
		if(userinfo[playerid][ingang] == 0) return SendClientMessage(playerid, -1, "{ff0000}You are not in a gang.");
		mysql_format(Database, str, sizeof(str), "SELECT `Gang_level`, `Name`, `Last_Online` FROM `Users` WHERE `Gang_ID` = %d AND `In_gang` = 1 ORDER BY `Gang_level` DESC LIMIT "#MAX_GANG_MEMBERS"", userinfo[playerid][gid]);
		new Cache:r = mysql_query(Database, str);

		format(str, sizeof(str), "%s", "Name\t\tLevel\tLast Online\n");

		new online, na[MAX_PLAYER_NAME], lvl, ts;
		for(new k, p = cache_num_rows(); k < p; k++)
		{
			cache_get_value_name(k, "Name", na, sizeof(na));
			cache_get_value_name_int(k, "Last_Online", ts);
			cache_get_value_name_int(k, "Gang_level", lvl);

			online = 0;

			foreach(new i : Player)
			{
				if(isequal(userinfo[i][pname], na)){
					online = 1;
					break;
				}
			}

			if(!online)
			{
				if(floatdiv(gettime()-ts, 60*60) < 24) format(gstr, sizeof(gstr), "{ffffff}%s\t\t%i\t{f0e68c}%.0f hrs before\n", na, lvl, floatdiv(gettime()-ts, 60*60));
				else format(gstr, sizeof(gstr), "{ffffff}%s\t\t%i\t{ff0000}%.1f hrs before\n", na, lvl, floatdiv(gettime()-ts, 60*60));
			}
			else format(gstr, sizeof(gstr), "{ffffff}%s\t\t%i\t{7cfc00}Online\n", na, lvl);

			strcat(str, gstr, sizeof(str));
		}

		cache_delete(r);

		format(gstr, sizeof(gstr), "{ffa500}LGGW {ffffff}- %s - Gang members", ReplaceUwithS(ganginfo[userinfo[playerid][gid]][gname])); 
		Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_MSGBOX, gstr, str, "Close", "");
	}	
	else if(!sscanf(params, "'remove'S('-1')["#MAX_PLYER_NAME"]", name))
	{
		if(userinfo[playerid][ingang] == 0) return SendClientMessage(playerid, -1, "{ff0000}You are not in a gang.");
		if(userinfo[playerid][glevel] < 3) return SendClientMessage(playerid, -1, "{ff0000}You are not authorized to use this command (Required: Under-Boss level or higher).");
		if(isequal(name, userinfo[playerid][pname], true)) return SendClientMessage(playerid, -1 , "{ff0000}You can't use this command on you! Use '/gang leave'.");

		foreach(new i : Player)
		{
			if(isequal(userinfo[i][pname], name, true) && userinfo[i][ingang] && userinfo[i][gid] == userinfo[playerid][gid]){
				return SendClientMessage(playerid, -1 , "{ff0000}This player is online. Use '/gang kick'.");
			}
		}
		
		mysql_format(Database, gstr, sizeof(gstr), "SELECT `User_ID`, `Gang_level` FROM `Users` WHERE `Name` = '%e' AND `In_gang` = 1 AND `Gang_ID` = %d LIMIT 1", name, userinfo[playerid][gid]);
		new Cache:r = mysql_query(Database, gstr);

		if(!cache_num_rows())
		{	
			SendClientMessage(playerid, -1, "{ff0000}There's no such player in your gang.");
			return cache_delete(r);
		}
 
		new u_lvl;
		cache_get_value_name_int(0, "Gang_level", u_lvl);
		if(userinfo[playerid][glevel] <= u_lvl){
			if(u_lvl == 4) SendClientMessage(playerid, -1, "{ff0000}The player you are trying to remove is the Boss.");
			else SendClientMessage(playerid, -1, "{ff0000}The player you are trying to remove is an Under-Boss.");
			return cache_delete(r);
		}

		new u_id;
		cache_get_value_name_int(0, "User_ID", u_id);
		cache_delete(r);

		mysql_format(Database, gstr, sizeof(gstr), "UPDATE `Users` SET `In_gang` = 0 WHERE `User_ID` = %d LIMIT 1", u_id);
		mysql_tquery(Database, gstr);

		format(gstr, sizeof(gstr), "{ffffff}%s {eee8aa}has been removed from the gang.", name);
		SendClientMessage(playerid, -1 , gstr);
	}
	else if(isequal(params, "v", true))
	{
		if(!userinfo[playerid][ingang] || userinfo[playerid][glevel] < 4) return SendClientMessage(playerid, -1, "{ff0000}You shold be a gang owner buy/sell a gang vehicle");
		Dialog_Show(playerid, DIALOG_GANG_VEH, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Gang Vehicles", "{e9967a}ID\t\tOption\n{ffffff}1\t\t{7fff00}Buy vehicle\n{ffffff}2\t\t{ff0000}Sell vehicle", "Enter", "Close");
	}   
	else if(isequal(params, "help", true))
	{
		new dialog[1500];
		strcat(dialog, "{008000}Not in a gang ?\n");
		strcat(dialog, "{7f8000}/gang join  /gangs\n\n") ;
		strcat(dialog, "{008000}Level 1 - Thug\n");
		strcat(dialog, "{7f8000}/gang leave\n\n");
		strcat(dialog, "{008000}Level 2 - Warrior\n");
		strcat(dialog, "{7f8000}/gang accept\n\n");
		strcat(dialog, "{008000}Level 3 - Under-Boss\n");
		strcat(dialog, "{7f8000}/gang color  /gang kick  /gang setlevel /gv\n\n");
		strcat(dialog, "{008000}Level 4 - Boss\n");
		strcat(dialog, "{7f8000}/gang destroy  /gang house  /gang setboss /gang v\n\n");
		strcat(dialog, "{008000}Gang colors\n");
		strcat(dialog, "{7f8000}* To have a gang color you have to purchase a color from '/gang color'\n");
		strcat(dialog, "{7f8000}* Other gangs can steal your gang color if they have a higher score than your gang\n\n");
		strcat(dialog, "{008000}Gang score\n");
		strcat(dialog, "{7f8000}* Your gang can earn score by Capturing turfs & Killing players in other gangs\n");
		strcat(dialog, "{7f8000}* Your gang score also will decrease if you loose turfs and die by other gangs\n\n");
		strcat(dialog, "{008000}Other Information\n");
		strcat(dialog, "{7f8000}* Players in the gang will earn cash per every 12 minutes for turfs\n");
		strcat(dialog, "{7f8000}* Use '/t' for the team chat\n");
		strcat(dialog, "{7f8000}* A turf war can be started by standing with 3 players of the gang on an enemy turf\n");
		strcat(dialog, "{7f8000}* Gang score can be earned by turfing & killing players of enemy gangs\n");
		strcat(dialog, "{7f8000}* Gang score will be reduced by 10 if any owned turf lost\n");
		strcat(dialog, "{7f8000}* Minigame kills won't be counted for scores\n");
		strcat(dialog, "{7f8000}* You must go to a Gang house checkpoint before using '/gang house'\n");
		strcat(dialog, "{7f8000}* You can request for a gang backup by using '/backup'\n");
		strcat(dialog, "{7f8000}* Inactivity of gang will result in a Gang remove by Administrators");
		Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_MSGBOX, "{ffa500}LGGW {ffffff}- Gang commands & Info", dialog, "Close", "");
	}
	else return SendClientMessage(playerid, -1, "{ff0000}Invalid gang command, Use '/gang help' for more details.");
	return 1;
}

CMD:gv(playerid, params[])
{
	if(userinfo[playerid][ingang] == 0) return SendClientMessage(playerid, -1, "{ff0000}You are not in a gang.");
	if(userinfo[playerid][glevel] < 3) return SendClientMessage(playerid, -1, "{ff0000}You are not authorized to use this command (Required: Under-Boss level or higher).");
	if(ganginfo[userinfo[playerid][gid]][gveh] == 0) return SendClientMessage(playerid, -1, "{ff0000}Your gang doesn't own a gang vehicle (Request owner to buy one).");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");

	if(gang_veh[userinfo[playerid][gid]] == INVALID_VEHICLE_ID)
	{
		new Float:x, Float:y, Float:z, Float:ang;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, ang);
		gang_veh[userinfo[playerid][gid]] = CreateVehicle(ganginfo[userinfo[playerid][gid]][gvmodel], x, y, z, ang, 1, 0, -1);
		PutPlayerInVehicle(playerid, gang_veh[userinfo[playerid][gid]], 0);
		gvehowned[gang_veh[userinfo[playerid][gid]]] = 1;
		gvehid[gang_veh[userinfo[playerid][gid]]] = userinfo[playerid][gid];
		gang_vhealth[userinfo[playerid][gid]] = 1000;
		SetVehicleHealth(gang_veh[userinfo[playerid][gid]], 3000);
        gang_vlabel[userinfo[playerid][gid]] = CreateProgressBar3D(0xff0000ff, false, 0, 0, 0, 3000, 0, 50, INVALID_PLAYER_ID, gang_veh[userinfo[playerid][gid]]);
        SetProgressBar3DValue(gang_vlabel[userinfo[playerid][gid]], 3000);
	}
	else 
	{
		if(userinfo[playerid][glevel] != 4)
		{
			foreach(new i : Player)
			{
				if(IsPlayerInVehicle(i, gang_veh[userinfo[playerid][gid]]) && GetPlayerVehicleSeat(playerid) == 0 && i != playerid) return SendClientMessage(playerid, -1, "{ff0000}A gang member is driving the gang vehicle");
			}
		}

		new Float:x, Float:y, Float:z, Float:ang;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, ang);
		SetVehiclePos(gang_veh[userinfo[playerid][gid]], x, y, z);
		SetVehicleZAngle(gang_veh[userinfo[playerid][gid]], ang);
		PutPlayerInVehicle(playerid, gang_veh[userinfo[playerid][gid]], 0);
	}
	return 1;
}

CMD:readlogs(playerid, params[])
{
	if(userinfo[playerid][plevel] < 3) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	Dialog_Show(playerid, DIALOG_LOGS, DIALOG_STYLE_LIST, "{ffa500}LGGW {ffffff}- Logs", "Player connection Log\nPlayer Disconnection Log\nAdmin Promotion Log\nAdmin Actions Log\nBans Log\nReports Log", "Close", "");
	return 1;
}

CMD:jail(playerid, params[])
{
	new id, mins, reason[128];
	if(userinfo[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "uis[128]", id, mins, reason)) return SendClientMessage(playerid, -1, "{ff1493}/jail <id> <minutes> <reason>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(playerid == id) return SendClientMessage(playerid, -1, "{ff0000}You cannot use this command on you.");
	if(userinfo[playerid][plevel] <= userinfo[id][plevel]) return SendClientMessage(playerid, -1, "{ff0000}The person you are using the command is at the same or at a higher level.");
	if(mins < 1) return SendClientMessage(playerid, -1, "{ff0000}Don't use a jail time less than 1 minute");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{ff0000}Player is not spawned yet.");
	
    new str[190];
    
    userinfo[id][jailed] = 1;
	userinfo[id][jailtime] = mins * 60;
    userinfo[id][jailed_admin] = userinfo[playerid][pid];
    format(userinfo[id][jailed_reason], 80, "%s", reason);
	
    SetPlayerPos(id, 264.4176, 77.8930, 1001.0391);
	SetPlayerInterior(id, 6);
	SetPlayerHealth(id, 100);
    GameTextForPlayer(id, "~r~JAILED!", 5000, 5);
	
    format(str, sizeof(str), "{FF8000}* %s[%d] has been jailed by an Admin for %d minutes (%s).", userinfo[id][pname], id, mins, reason);
	SendClientMessageToAll_(-1, str);

    nocmd[id] = 1;
	WriteLog(LOG_ADMINACTIONS, "COMMAND: Jail | Admin: %s | Affected: %s | Reason: %s", userinfo[playerid][pname], userinfo[id][pname], reason);

	mysql_format(Database, str, sizeof(str), "UPDATE `User_Status` SET `Jailed` = 1, `Jailed_admin` = %d, `Jailed_times` = Jailed_times + 1, `Jailed_reason` = '%e' WHERE `User_ID` = %d LIMIT 1", userinfo[id][pid], reason, userinfo[playerid][pid]);
	mysql_tquery(Database, str);
	return 1;
} 

CMD:unjail(playerid, params[])
{
	new id;
	if(userinfo[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{ff1493}/unjail <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(id == playerid) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command on yourself.");
	if(userinfo[id][jailed] == 0) return SendClientMessage(playerid, -1, "{ff0000}Player is not under jail");
	if(IsPlayerInClassSelection(id) || !IsPlayerSpawned(id)) return SendClientMessage(playerid, -1, "{ff0000}Player is not spawned yet.");
	
    userinfo[id][jailed] = 0;
	userinfo[id][jailtime] = 0;
	
    SpawnPlayer(id);
	GameTextForPlayer(id, "~g~UNJAILED!", 5000, 5);
	nocmd[id] = 0;
    
    SendClientMessage(id, -1, "{eee8aa}You have been unjailed by an admin.");
    
    new str[90];
    format(str, sizeof(str), "{eee8aa}You released {ffffff}%s {eee8aa}from jail.", userinfo[id][pname]);
    SendClientMessage(playerid, -1, str);

	mysql_format(Database, str, sizeof(str), "UPDATE `User_Status` SET `Jailed` = 0 WHERE `User_ID` = %d LIMIT 1", userinfo[id][pid]);
	mysql_tquery(Database, str);

	WriteLog(LOG_ADMINACTIONS, "COMMAND: Unail | Admin: %s | Affected: %s | Reason: %s", userinfo[playerid][pname], userinfo[id][pname]);
	return 1;
}

CMD:mute(playerid, params[])
{
	new id, mins, reason[50];
	if(userinfo[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "uis[128]", id, mins, reason)) return SendClientMessage(playerid, -1, "{ff1493}/mute <id> <minutes> <reason>");
	if(playerid == id) return SendClientMessage(playerid, -1, "{ff0000}You cannot use this command on you.");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(userinfo[playerid][plevel] <= userinfo[id][plevel]) return SendClientMessage(playerid, -1, "{ff0000}The person you are using the command is at the same or at a higher level.");
	if(mins < 1) return SendClientMessage(playerid, -1, "{ff0000}Don't use a mute time less than 1 minute");
	
    userinfo[id][muted] = 1;
	userinfo[id][mutetime] = mins * 60;
    userinfo[id][muted_admin] = userinfo[playerid][pid];
    format(userinfo[id][muted_reason], 80, "%s", reason);
	
    new str[190];
    format(str, sizeof(str), "{FF8000}* %s[%d] has been muted by an Admin for %d minutes (%s).", userinfo[id][pname], id, mins, reason);
	SendClientMessageToAll_(-1, str);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: Mute | Admin: %s | Affected: %s | Reason: %s", userinfo[playerid][pname], userinfo[id][pname], reason);
   
	mysql_format(Database, str, sizeof(str), "UPDATE `User_Status` SET `Muted` = 1, `Muted_admin` = %d, `Muted_times` = Muted_times + 1, `Muted_reason` = '%e' WHERE `User_ID` = %d LIMIT 1", userinfo[id][pid], reason, userinfo[playerid][pid]);
    mysql_tquery(Database, str);
	return 1;
}

CMD:unmute(playerid, params[])
{
	new id;
	if(userinfo[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{ff1493}/unmute <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(playerid == id) return SendClientMessage(playerid, -1, "{ff0000}You cannot use this command on you.");
	if(userinfo[id][muted] == 0) return SendClientMessage(playerid, -1, "{ff0000}Player is not muted");
	
    userinfo[id][muted] = 0;
	userinfo[id][mutetime] = 0;
    
    new str[128];
    format(str, sizeof(str), "{eee8aa}You unmuted {ffffff}%s{eee8aa}.", userinfo[id][pname]);
    SendClientMessage(playerid, -1, str);

    SendClientMessage(id, -1, "{eee8aa}You have been unmuted by an admin.");
    SendClientMessage(id, -1, "{eee8aa}Mind your words!!!");
	
    mysql_format(Database, str, sizeof(str), "UPDATE `User_Status` SET `Muted` = 0 WHERE `User_ID` = %d LIMIT 1", userinfo[id][pid]);
    mysql_tquery(Database, str);

    WriteLog(LOG_ADMINACTIONS, "COMMAND: Unmute | Admin: %s | Affected: %s", userinfo[playerid][pname], userinfo[id][pname]);
	return 1;
}

CMD:anim(playerid,params[])
{
	new str[800];
	strcat(str, "Dance 1\nDance 2\nBeach 1\nBeach 2\nCarry 1\nCarry 2\nCarry 3\nCrack 1\nCrack 2\nCrack 3\nDealer 1\nDealer 2\n", sizeof(str));
	strcat(str, "Dildo 1\nDildo 2\nFat 1\nFat 2\nFat 3\nFat 4\nFood\nSmoking\nStrip\nBasketball 1\nBasketball 2\nBasketball 3\n", sizeof(str));
	strcat(str, "Basketball 4\nped 1\nped 2\nped 3\nped 4\nped 5\nped 6\nped 7\nped 8\nRaping 1\nRaping 2\nRaping 3\nRiot 1\n", sizeof(str));
	strcat(str, "Riot 2\nRiot 3\nPiss(/piss)\nWank(/wank)\nBlow Job 1(/bj 1)\nBlow Job 2(/bj 2)\nBlow Job 3(/bj 3)\nBlow Job 4(/bj 4).", sizeof(str));
	Dialog_Show(playerid, DIALOG_ANIM, DIALOG_STYLE_LIST, "{ffa500}LGGW {ffffff}- Animation List", str, "Select", "Close");
	return 1;
}

CMD:piss(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You are in a vehicle.");
	
    inanim[playerid] = 1;
	
    ApplyAnimation(playerid, "PAULNMAC", "Piss_loop", 4.1, 1, 1, 1, 1, 0);
	SetPlayerSpecialAction(playerid, 68);

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new id = INVALID_PLAYER_ID;
	
    foreach(new i : Player)
    {
        if(IsPlayerInRangeOfPoint(i, 1, x, y, z) && i != playerid)
        {
            id = i;
            break;
        }
    }

	if(id != INVALID_PLAYER_ID)
	{
		new str[128];
		format(str, sizeof(str), "* %s[%d] pisses over %s[%d]", userinfo[playerid][pname], playerid, userinfo[id][pname], id);
		SendClientMessageToAll_(-1, str);
	}
	return 1;
}

CMD:wank(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You are in a vehicle.");
	
    inanim[playerid] = 1;
	
    ApplyAnimation(playerid, "PAULNMAC", "wank_loop", 4.1, 1, 1, 1, 1, 0); 
	
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new id = INVALID_PLAYER_ID;
    
    foreach(new i : Player)
    {
        if(IsPlayerInRangeOfPoint(i, 1, x, y, z) && i != playerid)
        {
            id = i;
            break;
        }
    }

    if(id != INVALID_PLAYER_ID)
    {
        new str[128];
        format(str, sizeof(str), "* %s[%d] wanks over %s[%d]", userinfo[playerid][pname], playerid, userinfo[id][pname], id);
        SendClientMessageToAll_(-1, str);
    }
	return 1;
}

CMD:bj(playerid, params[])
{
	new id;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, "{ff1493}/bj <1..4>");
	if(id < 1 || id > 4) return SendClientMessage(playerid, -1, "{ff0000}Invalid Blow Job ID.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You are in a vehicle.");
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
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	new str[128];
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
	if(GetPlayerCash(playerid) < MIN_CASH_TO_USE_MEDKIT) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!");
	new Float:hp;
	GetPlayerHealth(playerid, hp);
	if(hp == 100) return SendClientMessage(playerid, -1, "{ff0000}You already have 100% HP");
	SetPlayerHealth(playerid, 100);
	GivePlayerCash(playerid, -MIN_CASH_TO_USE_MEDKIT);
	format(str, sizeof(str), "* %s healed using a medkit (/medkit).", userinfo[playerid][pname]);
	SendClientMessageToAll_(-1, str);
	return 1;
}

CMD:lms(playerid, params[])
{  
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, 1, "You have already participated for LMS"); 
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are invited for a duel, use /no to refuse or /yes to accept it.");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have invited someone for a duel, use /cancel.");
	switch(lmsstarted)
	{
		case 1:
		{
			if(lmsjustnow == 1) return SendClientMessage(playerid, -1, "{ff0000}Last Man Standing event already started");
			inlms[playerid] = 1;
			SendClientMessage(playerid, 1, "{8000ff}You have participated for LMS. Waiting for more players...");
			new str[128];
			format(str, sizeof(str), "{8000ff}%s[%d] has participated for Last Man Standing event. Waiting for more players...", userinfo[playerid][pname], playerid);
			SendClientMessageToAll_(-1, str);
		}
		case 0:
		{
			if(lmsjustnow == 1) return SendClientMessage(playerid, -1, "{ff0000}A Last Man Standing event has started before few minutes, you can start another LMS after few more minutes");
            Dialog_Show(playerid, DIALOG_LMS_PLACE, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Last Man Standing", "{e9967a}ID\tPlace\n\n{ff0000}1\t{ffffff}Jefforson Motel\n{ff0000}2\t{ffffff}RC Battlefield\n{ff00000}3\t{ffffff}Russian Mafia Base\n{ff0000}4\t{ffffff}Valle Ocultado", "Enter", "Close");
		}
	}
	return 1;
}

CMD:v(playerid, params[])
{
	if(userinfo[playerid][vowned] == 0) return SendClientMessage(playerid, -1, "{ff0000}You don't have a personal vehicle");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You are in a vehicle.");
	if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid, -1, "{ff0000}You are in an interior");
	if(IsPlayerInRangeOfPoint(playerid, 20.0, 1685.1998,-1460.3500,13.5528)) return SendClientMessage(playerid, -1, "{ff0000}You can't spawn the vehicle here! GO AWAY!");
	if(IsPlayerMoving(playerid)) return SendClientMessage(playerid, -1, "{ff0000}Please don't move");
	new Float:X, Float:Y, Float:Z;
	new Float:fa;
	GetPlayerFacingAngle(playerid, fa); 
	GetPlayerPos(playerid, X, Y, Z); 
	if(priveh[playerid] == INVALID_VEHICLE_ID)
	{
		priveh[playerid] = CreateVehicle(userinfo[playerid][vmodel], X, Y, Z, fa, userinfo[playerid][vcolor_1], userinfo[playerid][vcolor_2], -1);
		PutPlayerInVehicle(playerid, priveh[playerid], 0);
		vehowner[priveh[playerid]] = playerid;
		vehowned[priveh[playerid]] = 1;
		if(userinfo[playerid][vneon_1] == 1) 
		{
			new Rand = random(sizeof(NeonRandoms));
			vehneon[priveh[playerid]][0] = CreateObject(NeonRandoms[Rand],0,0,0,0,0,0);
			vehneon[priveh[playerid]][1] = CreateObject(NeonRandoms[Rand],0,0,0,0,0,0);
			AttachObjectToVehicle(vehneon[priveh[playerid]][0], priveh[playerid], -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			AttachObjectToVehicle(vehneon[priveh[playerid]][1], priveh[playerid], 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		}
		if(userinfo[playerid][vneon_2] == 1)
		{
			vehneon[priveh[playerid]][2] = CreateObject(18646,0,0,0,0,0,0);
			AttachObjectToVehicle(vehneon[priveh[playerid]][2], priveh[playerid], 0.0, -0.35, 0.90, 0.0, 0.0, 0.0);
		}
		if(userinfo[playerid][vhydra] == 1) AddVehicleComponent(priveh[playerid], 1087);
		if(userinfo[playerid][vnitro] == 1008) AddVehicleComponent(priveh[playerid], 1008);
		if(userinfo[playerid][vnitro] == 1009) AddVehicleComponent(priveh[playerid], 1009);
		if(userinfo[playerid][vnitro] == 1010) AddVehicleComponent(priveh[playerid], 1010);
		AddVehicleComponent(priveh[playerid], userinfo[playerid][vwheel]);
		ChangeVehiclePaintjob(priveh[playerid], userinfo[playerid][vpjob]);
		SetVehicleVirtualWorld(priveh[playerid], GetPlayerVirtualWorld(playerid));
	}
	else  
	{
		SetVehiclePos(priveh[playerid], X, Y, Z);
		SetVehicleZAngle(priveh[playerid], fa); 
		PutPlayerInVehicle(playerid, priveh[playerid], 0);
		SetVehicleVirtualWorld(priveh[playerid], GetPlayerVirtualWorld(playerid));
		ChangeVehiclePaintjob(priveh[playerid], userinfo[playerid][vpjob]);
		ChangeVehicleColor(priveh[playerid], userinfo[playerid][vcolor_1], userinfo[playerid][vcolor_2]);
		AddVehicleComponent(priveh[playerid], userinfo[playerid][vwheel]);
		if(userinfo[playerid][vhydra] == 1) AddVehicleComponent(priveh[playerid], 1087);
		if(userinfo[playerid][vnitro] == 1008) AddVehicleComponent(priveh[playerid], 1008);
		if(userinfo[playerid][vnitro] == 1009) AddVehicleComponent(priveh[playerid], 1009);
		if(userinfo[playerid][vnitro] == 1010) AddVehicleComponent(priveh[playerid], 1010);
	}
	return 1;
} 

CMD:dm(playerid, params[])
{
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	new dm1, dm2, dm3, dm4, dm5, dm6, dm7, dm8, dm9;
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
				case 7: dm7 ++;
				case 8: dm8 ++;
				case 9: dm9 ++;
			}
		}
	}
	new dmstr[300];
	format(dmstr, sizeof(dmstr), "ID\tPlayers\tWeapons\n1\t%d\tDeagle+Sgotgun\n2\t%d\tDeagle+Shotgun+AK47\n3\t%d\tSniper+Spass12\n4\t%d\tMinigun\n5\t%d\tSawnoff+Uzi\n6\t%d\tKnife+Deagle+Shotgun\n7\t%d\tKnife+Deagle+Shotgun\n8\t%d\tKnife+Deagle+Shotgun\n9\t%d\tKnife+Deagle+Shotgun", dm1, dm2, dm3, dm4, dm5, dm6, dm7, dm8, dm9);
	Dialog_Show(playerid, DIALOG_DM, DIALOG_STYLE_TABLIST_HEADERS, "Deathmatches", dmstr, "Join", "Close");
	return 1;
}

CMD:stunt(playerid, params[])
{
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have participated for Last Man Standing..");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are invited for a duel, use /no to refuse or /yes to accept it..");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have invited someone for a duel, use /cancel..");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You are in a vehicle.");
	GetPlayerDetails(playerid);
	new str[128];
	SendClientMessage(playerid, -1, "{eee8aa}Use /exit to leave stunt arena");
    format(str, sizeof(str), "%s has joined a deathmatch!", userinfo[playerid][pname]);
    SendClientMessageToAll_(1, str);
	//stunt pos------ set
	instunt[playerid] = 1;
	inminigame[playerid] = 1;
	ResetPlayerWeapons(playerid);
	SetPlayerTeam(playerid, TEAM_STUNT);
	SetPlayerVirtualWorld(playerid, INT_VW);
	SetPlayerInterior(playerid, 0);
	SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 100);
	SetPlayerColor(playerid,COLOR_STUNT);
	PlayerPlaySound(playerid,1188,0.0,0.0,0.0);
	return 1;
}

CMD:dm1(playerid, params[])
{
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have participated for Last Man Standing.");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are invited for a duel, use /no to refuse or /yes to accept it.");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have invited someone for a duel, use /cancel.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You are in a vehicle.");
	
    TextDrawShowForPlayer(playerid, DM__[0]);
	TextDrawShowForPlayer(playerid, DM__[1]);
	PlayerTextDrawShow(playerid, DM_1[playerid]);
	PlayerTextDrawSetString(playerid, DM_1[playerid], "~g~kills:_0______________ ~r~deaths:_0______________ ~y~killingspree:_0______________ ~p~ratio:_0.00______________");
	
    dmkills[playerid] = 0;
	dmdeaths[playerid] = 0;
	dmspree[playerid] = 0;
	
    GetPlayerDetails(playerid);
	
    new str[128];
	SendClientMessage(playerid, -1, "{eee8aa}Use /exit to leave DM");
    format(str, sizeof(str), "%s has joined a deathmatch!", userinfo[playerid][pname]);
    SendClientMessageToAll_( -1, str);
	
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
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have participated for Last Man Standing.");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are invited for a duel, use /no to refuse or /yes to accept it.");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have invited someone for a duel, use /cancel.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You are in a vehicle.");
    TextDrawShowForPlayer(playerid, DM__[0]);
	TextDrawShowForPlayer(playerid, DM__[1]);
	PlayerTextDrawShow(playerid, DM_1[playerid]);
	PlayerTextDrawSetString(playerid, DM_1[playerid], "~g~kills:_0______________ ~r~deaths:_0______________ ~y~killingspree:_0______________ ~p~ratio:_0.00______________");
	
    dmkills[playerid] = 0;
	dmdeaths[playerid] = 0;
	dmspree[playerid] = 0;
	
    GetPlayerDetails(playerid);
	
    new str[128];
	SendClientMessage(playerid, -1, "{eee8aa}Use /exit to leave DM");
    format(str, sizeof(str), "%s has joined a deathmatch!", userinfo[playerid][pname]);
    SendClientMessageToAll_( -1, str);
	
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
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have participated for Last Man Standing.");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are invited for a duel, use /no to refuse or /yes to accept it.");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have invited someone for a duel, use /cancel.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You are in a vehicle.");
	
    TextDrawShowForPlayer(playerid, DM__[0]);
	TextDrawShowForPlayer(playerid, DM__[1]);
	PlayerTextDrawShow(playerid, DM_1[playerid]);
	PlayerTextDrawSetString(playerid, DM_1[playerid], "~g~kills:_0______________ ~r~deaths:_0______________ ~y~killingspree:_0______________ ~p~ratio:_0.00______________");
	
    dmkills[playerid] = 0;
	dmdeaths[playerid] = 0;
	dmspree[playerid] = 0;
	
    GetPlayerDetails(playerid);
	new str[128];
	SendClientMessage(playerid, -1, "{eee8aa}Use /exit to leave DM");
    format(str, sizeof(str), "%s has joined a deathmatch!", userinfo[playerid][pname]);
    SendClientMessageToAll_( -1, str);
	
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
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have participated for Last Man Standing.");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are invited for a duel, use /no to refuse or /yes to accept it.");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have invited someone for a duel, use /cancel.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You are in a vehicle.");
	
    TextDrawShowForPlayer(playerid, DM__[0]);
	TextDrawShowForPlayer(playerid, DM__[1]);
	PlayerTextDrawShow(playerid, DM_1[playerid]);
	PlayerTextDrawSetString(playerid, DM_1[playerid], "~g~kills:_0______________ ~r~deaths:_0______________ ~y~killingspree:_0______________ ~p~ratio:_0.00______________");
	
    dmkills[playerid] = 0;
	dmdeaths[playerid] = 0;
	dmspree[playerid] = 0;
	
    GetPlayerDetails(playerid);
	
    new str[128];
	SendClientMessage(playerid, -1, "{eee8aa}Use /exit to leave DM");
    format(str, sizeof(str), "%s has joined a deathmatch!", userinfo[playerid][pname]);
    SendClientMessageToAll_( -1, str);
	
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
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have participated for Last Man Standing.");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are invited for a duel, use /no to refuse or /yes to accept it.");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have invited someone for a duel, use /cancel.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You are in a vehicle.");
	
    TextDrawShowForPlayer(playerid, DM__[0]);
	TextDrawShowForPlayer(playerid, DM__[1]);
	PlayerTextDrawShow(playerid, DM_1[playerid]);
	PlayerTextDrawSetString(playerid, DM_1[playerid], "~g~kills:_0______________ ~r~deaths:_0______________ ~y~killingspree:_0______________ ~p~ratio:_0.00______________");
	
    dmkills[playerid] = 0;
	dmdeaths[playerid] = 0;
	dmspree[playerid] = 0;
	
    GetPlayerDetails(playerid);
	
    new str[128];
	
    SendClientMessage(playerid, -1, "{eee8aa}Use /exit to leave DM");
    format(str, sizeof(str), "%s has joined a deathmatch!", userinfo[playerid][pname]);
    SendClientMessageToAll_( -1, str);
	
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
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have participated for Last Man Standing.");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are invited for a duel, use /no to refuse or /yes to accept it.");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have invited someone for a duel, use /cancel.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You are in a vehicle.");
	
    TextDrawShowForPlayer(playerid, DM__[0]);
	TextDrawShowForPlayer(playerid, DM__[1]);
	PlayerTextDrawShow(playerid, DM_1[playerid]);
	PlayerTextDrawSetString(playerid, DM_1[playerid], "~g~kills:_0______________ ~r~deaths:_0______________ ~y~killingspree:_0______________ ~p~ratio:_0.00______________");
	
    dmkills[playerid] = 0;
	dmdeaths[playerid] = 0;
	dmspree[playerid] = 0;
	
    GetPlayerDetails(playerid);
	
    new str[128];
	SendClientMessage(playerid, -1, "{eee8aa}Use /exit to leave DM");
    format(str, sizeof(str), "%s has joined a deathmatch!", userinfo[playerid][pname]);
    SendClientMessageToAll_( -1, str);
	
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

CMD:dm7(playerid, params[])
{
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have participated for Last Man Standing.");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are invited for a duel, use /no to refuse or /yes to accept it.");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have invited someone for a duel, use /cancel.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You are in a vehicle.");
	
    TextDrawShowForPlayer(playerid, DM__[0]);
	TextDrawShowForPlayer(playerid, DM__[1]);
	PlayerTextDrawShow(playerid, DM_1[playerid]);
	PlayerTextDrawSetString(playerid, DM_1[playerid], "~g~kills:_0______________ ~r~deaths:_0______________ ~y~killingspree:_0______________ ~p~ratio:_0.00______________");
	
    dmkills[playerid] = 0;
	dmdeaths[playerid] = 0;
	dmspree[playerid] = 0;
	
    GetPlayerDetails(playerid);
	new str[128];
	SendClientMessage(playerid, -1, "{eee8aa}Use /exit to leave DM");
    format(str, sizeof(str), "%s has joined a deathmatch!", userinfo[playerid][pname]);
    SendClientMessageToAll_( -1, str);
	
    indm[playerid] = 1;
	inminigame[playerid] = 1;
	dmid[playerid] = 7;
	
    ResetPlayerWeapons(playerid);
	
    new Rand = random(sizeof(DM7Randoms));
	SetPlayerPos(playerid, DM7Randoms[Rand][0], DM7Randoms[Rand][1], DM7Randoms[Rand][2]);
	SetPlayerFacingAngle(playerid,DM7Randoms[Rand][3]);
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

CMD:dm8(playerid, params[])
{
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have participated for Last Man Standing.");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are invited for a duel, use /no to refuse or /yes to accept it.");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have invited someone for a duel, use /cancel.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You are in a vehicle.");
	
    TextDrawShowForPlayer(playerid, DM__[0]);
	TextDrawShowForPlayer(playerid, DM__[1]);
	PlayerTextDrawShow(playerid, DM_1[playerid]);
	PlayerTextDrawSetString(playerid, DM_1[playerid], "~g~kills:_0______________ ~r~deaths:_0______________ ~y~killingspree:_0______________ ~p~ratio:_0.00______________");
	
    dmkills[playerid] = 0;
	dmdeaths[playerid] = 0;
	dmspree[playerid] = 0;
	
    GetPlayerDetails(playerid);
	
    new str[128];
	SendClientMessage(playerid, -1, "{eee8aa}Use /exit to leave DM");
    format(str, sizeof(str), "%s has joined a deathmatch!", userinfo[playerid][pname]);
    SendClientMessageToAll_( -1, str);
	
    indm[playerid] = 1;
	inminigame[playerid] = 1;
	dmid[playerid] = 8;
	
    ResetPlayerWeapons(playerid);
	
    new Rand = random(sizeof(DM8Randoms));
	SetPlayerPos(playerid, DM8Randoms[Rand][0], DM8Randoms[Rand][1], DM8Randoms[Rand][2]);
	SetPlayerFacingAngle(playerid,DM8Randoms[Rand][3]);
	SetPlayerVirtualWorld(playerid, INT_VW);
	SetPlayerInterior(playerid, 5);
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

CMD:dm9(playerid, params[])
{
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have participated for Last Man Standing.");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are invited for a duel, use /no to refuse or /yes to accept it.");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have invited someone for a duel, use /cancel.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You are in a vehicle.");
	
    TextDrawShowForPlayer(playerid, DM__[0]);
	TextDrawShowForPlayer(playerid, DM__[1]);
	PlayerTextDrawShow(playerid, DM_1[playerid]);
	PlayerTextDrawSetString(playerid, DM_1[playerid], "~g~kills:_0______________ ~r~deaths:_0______________ ~y~killingspree:_0______________ ~p~ratio:_0.00______________");
	
    dmkills[playerid] = 0;
	dmdeaths[playerid] = 0;
	dmspree[playerid] = 0;
	
    GetPlayerDetails(playerid);
	new str[128];
	SendClientMessage(playerid, -1, "{eee8aa}Use /exit to leave DM");
    format(str, sizeof(str), "%s has joined a deathmatch!", userinfo[playerid][pname]);
    SendClientMessageToAll_( -1, str);
	
    indm[playerid] = 1;
	inminigame[playerid] = 1;
	dmid[playerid] = 9;
	
    ResetPlayerWeapons(playerid);
	
    new Rand = random(sizeof(DM9Randoms));
	SetPlayerPos(playerid, DM9Randoms[Rand][0], DM9Randoms[Rand][1], DM9Randoms[Rand][2]);
	SetPlayerFacingAngle(playerid,DM9Randoms[Rand][3]);
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
	SetPlayerWorldBounds(playerid, 286.1616, 97.0327, 1940.0804, 1798.7915);
	return 1;
}

CMD:exit(playerid, params[])
{
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	if(inminigame[playerid] == 0) return SendClientMessage(playerid, -1, "{ff0000}You are not in a minigame.");
	if(induel[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command right now");
	if(ingg[playerid] == 0 && indm[playerid] == 0) return SendClientMessage(playerid, -1, "{ff0000}You are not in a GunGame or a Death Match");

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
        switch(dmid[playerid])
        {
            case 1:format(str,sizeof(str),"* {ffff00}\"%s[%i]\" has left {ffffff}[deagle + shotgun] {ffff00}DM", userinfo[playerid][pname], playerid);
            case 2:format(str,sizeof(str),"* {ffff00}\"%s[%i]\" has left {ffffff}[deagle + shotgun + ak47] {ffff00}DM", userinfo[playerid][pname], playerid);
            case 3:format(str,sizeof(str),"* {ffff00}\"%s[%i]\" has left {ffffff}[sniper + spass12] {ffff00}DM", userinfo[playerid][pname], playerid);
            case 4:format(str,sizeof(str),"* {ffff00}\"%s[%i]\" has left {ffffff}[minigun] {ffff00}DM", userinfo[playerid][pname], playerid);
            case 5:format(str,sizeof(str),"* {ffff00}\"%s[%i]\" has left {ffffff}[sawnoff + uzi] {ffff00}DM", userinfo[playerid][pname], playerid);
            case 6:format(str,sizeof(str),"* {ffff00}\"%s[%i]\" has left {ffffff}[knife + deagle + shotgun] {ffff00}DM", userinfo[playerid][pname], playerid);
            case 7:format(str,sizeof(str),"* {ffff00}\"%s[%i]\" has left {ffffff}[Knife + Deagle + Shotgun] {ffff00}DM", userinfo[playerid][pname], playerid);
            case 8:format(str,sizeof(str),"* {ffff00}\"%s[%i]\" has left {ffffff}[Knife + Deagle + Shotgun] {ffff00}DM", userinfo[playerid][pname], playerid);
            case 9:
            {
                format(str,sizeof(str),"* {ffff00}\"%s[%i]\" has left {ffffff}[Knife + Deagle + Shotgun] {ffff00}DM", userinfo[playerid][pname]);
                SetPlayerWorldBounds(playerid,20000.0000,-20000.0000,20000.0000,-20000.0000); 
            }
        }
		SendClientMessageToAll_(-1, str);
	}
	else if(ingg[playerid] == 1)
	{
		ResetPlayerWeapons(playerid);
		SetPlayerDetails(playerid); 
		
        ingg[playerid] = 0;
	}
	else if(instunt[playerid] == 1)
	{
		ResetPlayerWeapons(playerid);
		SetPlayerDetails(playerid); 
		
        instunt[playerid] = 0;
	}
	return 1;
}

CMD:duelsettings(playerid, params)
{
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	if(induel[playerid] == 1 || duelinvited[playerid] == 1 || duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't edit duel settings right now");
    
    Dialog_Show(playerid, DIALOG_DUEL_PREVIEW, DIALOG_STYLE_LIST, "{ffa500}LGGW {ffffff}- Duel Settings", "Place\nWeapon - 1\nWeapon - 2\nWeapon - 3\nBet", "Select", "Close");
	return 1;
}

CMD:duel(playerid, params[])
{
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	new id;
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have participated for Last Man Standing.");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{ff1493}/duel <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if(id == playerid) return SendClientMessage(playerid, -1, "{ff0000}You cannot duel yourself.");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
	if(inminigame[id] == 1) return SendClientMessage(playerid, -1, "{ff0000}Player is in a minigame.");
	if(GetPlayerCash(playerid) < userinfo[playerid][dbet]) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to duel, Try changing your duelsettings (/duelsettings).");
	if(GetPlayerCash(id) < userinfo[playerid][dbet]) return SendClientMessage(playerid, -1, "{ff0000}Player doesn't have enough money to duel with you.");
	if(duelinvited[id] == 1) return SendClientMessage(playerid, -1, "{ff0000}Player has been already invited for a duel.");
	if(duelinvited[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have been invited by someone for duel, Use /no to cancel or /yes to accept before playing another duel.");
	if(duelinviter[id] == 1) return SendClientMessage(playerid, -1, "{ff0000}Player has already invited someone for a duel.");
	if(duelinviter[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have invited someone for duel, Use /cancel to cancel it before playing another duel.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You are in a vehicle.");
	if(IsPlayerInAnyVehicle(id)) return SendClientMessage(playerid, -1, "{ff0000}Player is in a vehicle.");
	
    duelinvited[id] = 1;
	duelinviter[playerid] = 1;
	enemy[playerid] = id;
	enemy[id] = playerid;
	duelbet[playerid] = userinfo[playerid][dbet];
	duelbet[id] = userinfo[playerid][dbet];
	dstimer[playerid] = SetTimerEx("DuelDeadLine", 30000, false, "ii", id, playerid);
	
    new str[128];
    
	format(str, sizeof(str), "{ffffff}%s {eee8aa}has invited you for a duel.", userinfo[playerid][pname]);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{eee8aa}(place: %s | Weapon 1: %s | Weapon 2: %s | Weapon 3: %s | Bet: $%d ).", GetDuelPlaceName(userinfo[playerid][dplace]), GunName(userinfo[playerid][dwep1]), GunName(userinfo[playerid][dwep2]), GunName(userinfo[playerid][dwep3]), userinfo[playerid][dbet]);
	SendClientMessage(id, -1, str);
	SendClientMessage(id, -1, "{eee8aa}Use /yes to accept or /no to decline");
	
	format(str, sizeof(str), "{eee8aa}You have invited {ffffff}%s {eee8aa}for a duel.", userinfo[id][pname]);
	SendClientMessage(playerid, -1, str);
	format(str, sizeof(str), "{eee8aa}(place: %s | Weapon 1: %s | Weapon 2: %s | Weapon 3: %s | Bet: $%d ).", GetDuelPlaceName(userinfo[playerid][dplace]), GunName(userinfo[playerid][dwep1]), GunName(userinfo[playerid][dwep2]), GunName(userinfo[playerid][dwep3]), userinfo[playerid][dbet]);
	SendClientMessage(id, -1, str);
	SendClientMessage(playerid, -1, "{eee8aa}Use /cancel to cancel the duel");
	return 1; 
}

CMD:cancel(playerid, params[])
{
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
	if(duelinviter[playerid] == 0) return SendClientMessage(playerid, -1, "{ff0000}You haven't invited anyone for a duel");
	
    new id = enemy[playerid];
	duelinviter[playerid] = 0;
	duelinvited[id] = 0;
	
    new str[128];
	format(str, sizeof(str), "{eee8aa}%s cancelled duel with you", userinfo[playerid][pname]);
	SendClientMessage(id, -1, str);
	format(str, sizeof(str), "{eee8aa}You cancelled duel with %s", userinfo[id][pname]);
	SendClientMessage(playerid, -1, str);
	
    KillTimer(dstimer[playerid]);
	return 1;
}

CMD:yes(playerid, params[])
{
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	if(inlms[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You have participated for Last Man Standing.");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
	if(duelinvited[playerid] == 0) return SendClientMessage(playerid, -1, "{ff0000}You don't have any duel requests");
	new id = enemy[playerid], str[200];
	if(GetPlayerCash(playerid) < userinfo[id][dbet]) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to duel (you have spent your money after recieving the duel request).");
	if(GetPlayerCash(id) < userinfo[id][dbet]) return SendClientMessage(playerid, -1, "{ff0000}Duel sender doesn't have enough money to duel with you (he has spent some money after sending the duel request to you).");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You are in a vehicle.");
	if(IsPlayerInAnyVehicle(id)) return SendClientMessage(playerid, -1, "{ff0000}Duel sender is in a vehicle");
	
    KillTimer(dstimer[id]);
	induel[id] = 1;
	induel[playerid] = 1;
	inminigame[id] = 1;
	inminigame[playerid] = 1;
	userinfo[playerid][dplayed]++;
	userinfo[id][dplayed]++;

	mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Duels_played` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][dplayed], userinfo[playerid][pid]);
	mysql_tquery(Database, str);

	mysql_format(Database, str, sizeof(str), "UPDATE `Users` SET `Duels_played` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[id][dplayed], userinfo[id][pid]);
	mysql_tquery(Database, str);

	format(str, sizeof(str),"{eee8aa}Duel between %s and %s started (place: %s | Weapon 1: %s | Weapon 2: %s | Weapon 3: %s | Bet: $%d ).",  userinfo[id][pname], userinfo[playerid][pname], GetDuelPlaceName(userinfo[id][dplace]), GunName(userinfo[id][dwep1]), GunName(userinfo[id][dwep1]), GunName(userinfo[id][dwep1]), userinfo[id][dbet]);
	SendClientMessageToAll_(-1, str);
	GetPlayerDetails(playerid);
	ResetPlayerWeapons(playerid);
	SetPlayerColor(playerid, COLOR_DUEL);
	SetPlayerTeam(playerid, NO_TEAM);
	SetPlayerHealth(playerid, 100.0);
	SetPlayerArmour(playerid, 0);
	SetPlayerVirtualWorld(playerid, playerid + 1);
	GivePlayerWeapon(playerid, userinfo[id][dwep1], 2000);
	GivePlayerWeapon(playerid, userinfo[id][dwep2], 2000);
	GivePlayerWeapon(playerid, userinfo[id][dwep3], 2000);
	PlayerPlaySound(playerid,1068,0.0,0.0,0.0);
   
	GetPlayerDetails(id);
	ResetPlayerWeapons(id);
	SetPlayerArmour(id, 0);
	SetPlayerHealth(id, 100.0);
	SetPlayerTeam(id, NO_TEAM);
	SetPlayerColor(id, COLOR_DUEL);
	SetPlayerVirtualWorld(id, playerid + 1);
	GivePlayerWeapon(id, userinfo[id][dwep1], 2000);
	GivePlayerWeapon(id, userinfo[id][dwep2], 2000);
	GivePlayerWeapon(id, userinfo[id][dwep3], 2000);
	PlayerPlaySound(id,1068,0.0,0.0,0.0);

	if(userinfo[id][dplace] == 0)
	{
		SetPlayerPos(playerid, 1381.1675,2183.3015,11.0234);
		SetPlayerFacingAngle(playerid, 313.4774);
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(id, 1326.5436,2126.2871,11.0156);
		SetPlayerFacingAngle(id, 132.1626);
		SetPlayerInterior(id, 0);
	}
	if(userinfo[id][dplace] == 1)
	{
		SetPlayerPos(playerid, 1412.4567,-18.6115,1000.9243);
		SetPlayerFacingAngle(playerid, 266.9549);
		SetPlayerInterior(playerid, 1);
		SetPlayerPos(id, 1364.3143,-20.4402,1000.9219);
		SetPlayerFacingAngle(id, 90.7137);
		SetPlayerInterior(id, 1);
	}
	if(userinfo[id][dplace] == 2)
	{
		SetPlayerPos(playerid, -1130.0868,1057.8641,1346.4141);
		SetPlayerFacingAngle(playerid, 270.7783);
		SetPlayerInterior(playerid, 10);
		SetPlayerPos(id, -976.6179,1061.0818,1345.6719);
		SetPlayerFacingAngle(id, 90.1922);
		SetPlayerInterior(id, 10);
	}
	if(userinfo[id][dplace] == 3)
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
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	new id = enemy[playerid];
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
	if(duelinvited[playerid] == 0) return SendClientMessage(playerid, -1, "{ff0000}You haven't invited for a duel.");
	duelinvited[playerid] = 0;
	duelinviter[id] = 0;
	new str[128];
	format(str, sizeof(str), "{eee8aa}You refused %s's duel request", userinfo[id][pname]);
	SendClientMessage(playerid, -1, str);
	format(str, sizeof(str), "{eee8aa}%s refused your duel request", userinfo[playerid][pname]);
	SendClientMessage(id, -1, str);
	KillTimer(dstimer[id]);
	return 1;
}

CMD:t(playerid, params[])
{
	new text[256], str[256 + 50];
	if(userinfo[playerid][muted] == 1)
	{
		format(str, sizeof(str), "{ff0000}You can't talk while you are muted (Remaining time: %d seconds).", userinfo[playerid][mutetime]);
		SendClientMessage(playerid, -1, str);
	} 
	if(sscanf(params,"s[128]", text)) return SendClientMessage(playerid, -1, "{ff1493}/t <text>");
    if(strfind(text, "/q") != -1) return SendClientMessage(playerid, -1, "{ff0000}Hey!!! don't tell our gang homies to leave LGGW!");
    if(stringContainsIP(text))
    {
        userinfo[playerid][muted] = 1;
        userinfo[playerid][mutetime] = TIME_FOR_ADVERTISE_MUTE * 60;
        
        format(str, sizeof(str), "{ff8000}* {ffffff}%s[%d] {ff8000}has been muted by the server for {ff0000}%d {ff8000}minutes (Advertising).", userinfo[playerid][pname], playerid, TIME_FOR_ADVERTISE_MUTE);
        return SendClientMessageToAll_(-1, str);
    }

	foreach(new j : Player)
	{
		if(userinfo[j][gid] == userinfo[playerid][gid])
		{
			format(str, sizeof(str), "{00ff00}TeamMsg '/t' '!text' | %s[%d]: %s", userinfo[playerid][pname], playerid, text);
			SendClientMessage(j, -1, str);
		}
	}
	return 1;
}

CMD:kill(playerid, params[])
{
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are in a minigame.");
	if(killinginprogress[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}Wait a while to use this command again");
	if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid, -1, "{ff0000}You are in an interior");
	if(GetPlayerWeapon(playerid) == 0) return SendClientMessage(playerid, -1, "{ff0000}You must have a weapon in your hand to kill yourself.");
	if(gettime() - last_kill[playerid] < 30)
    {
        new ks[70];
        format(ks, sizeof(ks), "{ff0000}Please wait %i seconds before using this command again.", last_kill[playerid] + 30 - gettime());
        return SendClientMessage(playerid, -1, ks);
    }
    last_kill[playerid] = gettime();
    SetPlayerHealth(playerid, 0);
	return 1;
}

CMD:rules(playerid, params[])
{
	new dialog[1500];
	strcat(dialog, "{ffff00}The ten things you should do to maintain your respect in the server. Stay within them and enjoy the maximum...\n\n");
	strcat(dialog, "{7fff00}1. {ffffff}RESCPECT.RESPECT..RESPECT... It's quites simple. Respect everyone never mind who they are.\n");
	strcat(dialog, "{7fff00}2. {ffffff}Avoid childish behaviors such as spamming, flooding, insulting and advertising.\n");
	strcat(dialog, "{7fff00}3. {ffffff}DO NOT use other languages in the main chat.\n");
	strcat(dialog, "{7fff00}4. {ffffff}Avoid using any type hacks or modifications that will benifit you.\n");
	strcat(dialog, "{7fff00}5. {ffffff}DO NOT abuse server bugs. Report us if you find any.\n");
	strcat(dialog, "{7fff00}6. {ffffff}DO NOT Try to protect hackers or rule breakers. Always use /report if you spot them.\n");
	strcat(dialog, "{7fff00}8. {ffffff}Avoid spawn killing.\n");
	strcat(dialog, "{7fff00}9. {ffffff}Evading stuff is strictly prohibited.\n");
	strcat(dialog, "{7fff00}10. {ffffff}The staff's descision is the last descision. Always obey them.\n\n");
	strcat(dialog, "{ff0000}Our staff doesn't like punishing. But violation of one or more of the above rules is a punishable offense.");
	Dialog_Show(playerid, DIALOG_RULES, DIALOG_STYLE_MSGBOX,"{ffa500}LGGW {ffffff}- Rules", dialog, "Accept", "Decline");
	return 1;
}

CMD:backup(playerid, params[])
{
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't use this command while you are in Admin mode.");
	if(inminigame[playerid] == 1) SendClientMessage(playerid, -1, "{ff0000}You can't request for backup while you are in a minigame.");
	new str[128];
	format(str, sizeof(str), "{9370DB}%s is requesting for a gang backup (Location: %s).", userinfo[playerid][pname], GetPlayerZone(playerid));
	foreach(new j : Player)
	{
		if(GetPlayerTeam(playerid) == GetPlayerTeam(j) || userinfo[playerid][gid] == userinfo[j][gid]) SendClientMessage(j, -1, str);
	}
	return 1;
}

CMD:onduty(playerid, params[])
{
	if(userinfo[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(inminigame[playerid] == 1) return SendClientMessage(playerid, -1, "{ff0000}You can't switch to Admin mode in Minigames");
	if(userinfo[playerid][onduty] == 1) return SendClientMessage(playerid, -1, "{ff0000}You are already in Admin mode.");
	if(!IsPlayerSpawned(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You are not spawned yet.");
	
    userinfo[playerid][onduty] = 1;
	GetPlayerDetails(playerid);
	Delete3DTextLabel(glabel[playerid]);
    glabel[playerid] = Text3D:INVALID_3DTEXT_ID;

	alabel[playerid] = Create3DTextLabel("{800080}[ Don't shoot ]\n{9370DB}Admin on duty !", -1, 0.0, 0.0, 0.0, 50, 0);
	Attach3DTextLabelToPlayer(alabel[playerid], playerid, 0.0, 0.0, 0.35);
	
    SendClientMessage(playerid, -1, "{eee8aa}You are now on Admin mode");
	SendClientMessage(playerid, -1, "{eee8aa}Don't kill any player in the server with no reason");
	SendClientMessage(playerid, -1, "{eee8aa}Each an every inch of your actions will be logged");
	
    SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 0);
	SetPlayerSkin(playerid, 294);
	SetPlayerColor(playerid, COLOR_ADMIN);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 38, 999999); 
	SetPlayerTeam(playerid, TEAM_ADMIN);
	
    WriteLog(LOG_ADMINACTIONS, "COMMAND: onduty | Admin: %s", userinfo[playerid][pname]);
	return 1;
}

CMD:offduty(playerid, params[])
{
	if(userinfo[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(userinfo[playerid][onduty] == 0) return SendClientMessage(playerid, -1, "{ff0000}You are already in Playing mode.");
	if(!IsPlayerSpawned(playerid)) return SendClientMessage(playerid, -1, "{ff0000}You are not spawned yet.");
	
    userinfo[playerid][onduty] = 0;
	Delete3DTextLabel(alabel[playerid]);
    alabel[playerid] = Text3D:INVALID_3DTEXT_ID;
	
    new lstr[50];
	format(lstr, sizeof(lstr), "| %s |", ganginfo[userinfo[playerid][gid]][gtag]);
	glabel[playerid] = Create3DTextLabel(lstr, ganginfo[userinfo[playerid][gid]][gcolor], 0.0, 0.0, 0.0, 50,0);
	Attach3DTextLabelToPlayer(glabel[playerid], playerid, 0.0, 0.0, 0.3);
	SendClientMessage(playerid, -1, "{eee8aa}You are now on Playing mode");
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
	WriteLog(LOG_ADMINACTIONS, "COMMAND: offduty | Admin: %s", userinfo[playerid][pname]);
	return 1;
}

CMD:spawn(playerid, params[])
{
	new id, str[128];
	if(userinfo[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{ff1493}/spawn <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	
    format(str, sizeof(str), "You spawned %s[%d]", userinfo[id][pname], id);
	SendClientMessage(playerid, -1, str);
	SendClientMessage(id, -1, "You were spawned by an Admin");
	
    SpawnPlayer(id);
	return 1;
}

CMD:a(playerid, params[])
{
	new text[150], str[170];
	if(userinfo[playerid][muted] == 1)
	{
		format(str, sizeof(str), "{ff0000}You can't talk while you are muted (Remaining time: %d seconds).", userinfo[playerid][mutetime]);
		SendClientMessage(playerid, -1, str);
	} 
	if(userinfo[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "s[256]", text)) return SendClientMessage(playerid, -1, "{ff1493}/a <text>");
	format(str, sizeof(str), "{000000}[ *** ] {C0C0C0}(%d)_Admin: {0080C0}%s", adm_id[playerid], text);
	SendClientMessageToAll_(-1, str);
	return 1;
}

CMD:getip(playerid, params[])
{
	new id, str[50];
	if(userinfo[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{ff1493}/getip <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	format(str, sizeof(str), "%s's current IP --> %s", userinfo[id][pname], userinfo[id][pip]);
	SendClientMessage(playerid, -1, str);
	SendClientMessage(playerid, -1, "{eee8aa}Use '/getips' to see all connected IPs of a player");
	WriteLog(LOG_ADMINACTIONS, "COMMAND: getip | Admin: %s | Affected: %s", userinfo[playerid][pname], userinfo[id][pname]);
	return 1;
}

CMD:akill(playerid, params[])
{
	new id, str[128];
	if(userinfo[playerid][plevel] < 2) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{ff1493}/akill <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{ff0000}Invalid player ID.");
	if((userinfo[id][plevel] >= userinfo[playerid][plevel] || IsPlayerAdmin(id)) && id != playerid) return SendClientMessage(playerid, -1, "{ff0000}Player you entered is at the same level or a higher level than you.");
	if(!IsPlayerSpawned(playerid)) return SendClientMessage(playerid, -1, "{ff0000}Player isn't spawned yet");
	format(str, sizeof(str), "{eee8aa}You killed %s by Admin powers", userinfo[id][pname]);
	SendClientMessage(playerid, -1, str);
	SendClientMessage(id, -1, "{eee8aa}You have been killed by an Admin");
	SetPlayerHealth(id, 0);
	WriteLog(LOG_ADMINACTIONS, "COMMAND: akill | Admin: %s | Affected: %s", userinfo[playerid][pname], userinfo[id][pname]);
	return 1;
}

CMD:getips(playerid, params[])
{
	new name[MAX_PLAYER_NAME], str[1024];
	if(userinfo[playerid][plevel] < 1) return SendClientMessage(playerid, -1, "{ff0000}Invalid command.");
	if(sscanf(params, "s["#MAX_PLAYER_NAME"]", name)) return SendClientMessage(playerid, -1, "{ff1493}/getips <name>");
	if(strlen(name) > MAX_PLAYER_NAME || strlen(name) < 3) return SendClientMessage(playerid, -1, "{ff0000}Invalid player name (There's no such player registered).");
	
    new str1[128];
    mysql_format(Database, str1, sizeof(str1), "SELECT * FROM Users WHERE `Name` = '%e' LIMIT 1", name);
	new Cache:r = mysql_query(Database, str1);
	
    if(!cache_num_rows()) 
    { 

        cache_delete(r); 
        return SendClientMessage(playerid, -1, "{ff0000}Invalid player name (There's no such player registered)."); 
    }
	
    new key;
	cache_get_value_name_int(0, "User_ID", key);
	
    cache_delete(r); 

    mysql_format(Database, str1, sizeof(str1), "SELECT * FROM `User_IPs` WHERE `User_ID` = '%d' AND `IP` != '-1' LIMIT "#MAX_IP_SAVES"", key);
    r = mysql_query(Database, str1);

	for(new i = 0; i < cache_num_rows(); i++)
	{
		cache_get_value_name(i, "IP", str1, sizeof(str1));
		strcat(str, str1, sizeof(str));
	}

    cache_delete(r); 
	format(str1, sizeof(str1), "{ffa500}LGGW {ffffff}- %s's IP Log (All connected ips).", name);
	Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_LIST, str1, str, "Close", "");
	WriteLog(LOG_ADMINACTIONS, "COMMAND: getips | Admin: %s | Player %s", userinfo[playerid][pname], name);
	return 1;
}


CMD:toyshop(playerid, params[])
{	
	new str[512], substr[128];
	strcat(str, "Slot ID\tStatus\n", sizeof(str));
	for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
	{
		if(toyinfo[playerid][i][tused]) format(substr, sizeof(substr), "{ffffff}%d\t{7fff00}Used\n", i + 1);
		else format(substr, sizeof(substr), "{ffffff}%d\t{ff0000}Not used\n", i + 1);
		strcat(str, substr, sizeof(str));
	}
	Dialog_Show(playerid, DIALOG_USER_TOYS, DIALOG_STYLE_TABLIST_HEADERS, "{ffa500}LGGW {ffffff}- Toy shop", str, "Edit slot", "Close");
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_USER_TOY_BUY)
	{
		if(response)
		{
			if(response)
			{	
				new str[128];
				if(GetPlayerCash(playerid) < Toys[listitem][tprice])
				{
					SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy this toy!");
					new st[512];
					for(new i = 0; i < sizeof(Toys); i++)
					{ 
						format(str, sizeof(str), "%i\t~g~$%i_~w~-_%s\n", Toys[i][tmodel], Toys[i][tprice], Toys[i][tname]);
						strcat(st, str, sizeof(st));
					}
					format(str, sizeof(str), "{ffa500}LGGW {ffffff}- Toy shop - Slot %d - Add toy", cur_slotid[playerid] + 1);
					return ShowPlayerDialog(playerid, DIALOG_USER_TOY_BUY, DIALOG_STYLE_PREVIEW_MODEL, str, st, "Select", "Close");
				}
				
				toyinfo[playerid][cur_slotid[playerid]][tused] = 1;
				toyinfo[playerid][cur_slotid[playerid]][tid] = listitem;
				toyinfo[playerid][cur_slotid[playerid]][bone] = 1;

				SetPlayerAttachedObject(playerid, cur_slotid[playerid], Toys[listitem][tmodel], 1);
				SendClientMessage(playerid, -1, "Use \"/toyedit\" to edit toy position!");
				SendClientMessage(playerid, -1, "Editing toy position is not enough, You should use \"/toybone\" to set the toy to move with the specific bone!");
				GivePlayerCash(playerid, -Toys[listitem][tprice]);

                mysql_format(Database, str, sizeof(str), "`UPDATE `User_Toys` SET `Used` = 1, `Toy_ID` = %d WHERE `User_ID` = %d AND `Index_` = %d LIMIT 1", listitem, userinfo[playerid][pid], cur_slotid[playerid]);
                mysql_tquery(Database, str);
			} 
			else return 1;
		}
	}
	else if(dialogid == DIALOG_USER_TOY_REPLACE)
	{
		if(response)
		{
			new str[128];
			new id = listitem;
			if(id  == toyinfo[playerid][cur_slotid[playerid]][tid])
			{
				SendClientMessage(playerid, -1, "{ff0000}You already have this toy in the slot!");
				new st[512];
				for(new i = 0; i < sizeof(Toys); i++)
				{ 
					format(str, sizeof(str), "%i\t~g~$%i_~w~-_%s\n", Toys[i][tmodel], Toys[i][tprice], Toys[i][tname]);
					strcat(st, str, sizeof(st));
				}
				format(str, sizeof(str), "{ffa500}LGGW {ffffff}- Toy shop - Slot %d - Add toy", cur_slotid[playerid] + 1);
				return ShowPlayerDialog(playerid, DIALOG_USER_TOY_BUY, DIALOG_STYLE_PREVIEW_MODEL, str, st, "Select", "Close");
			}
			if(GetPlayerCash(playerid) < (Toys[id][tprice] / 2))
			{
				SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy this toy!");
				new st[512];
				for(new i = 0; i < sizeof(Toys); i++)
				{ 
					format(str, sizeof(str), "%i\t~g~$%i_~w~-_%s\n", Toys[i][tmodel], Toys[i][tprice], Toys[i][tname]);
					strcat(st, str, sizeof(st));
				}
				format(str, sizeof(str), "{ffa500}LGGW {ffffff}- Toy shop - Slot %d - Add toy", cur_slotid[playerid] + 1);
				return ShowPlayerDialog(playerid, DIALOG_USER_TOY_BUY, DIALOG_STYLE_PREVIEW_MODEL, str, st, "Select", "Close");
			}
			GivePlayerCash(playerid, -(Toys[id][tprice] / 2));

			toyinfo[playerid][cur_slotid[playerid]][tid] = id;

			SetPlayerAttachedObject(playerid, cur_slotid[playerid], Toys[id][tmodel], toyinfo[playerid][cur_slotid[playerid]][bone], 
				toyinfo[playerid][cur_slotid[playerid]][posx], toyinfo[playerid][cur_slotid[playerid]][posy], 
				toyinfo[playerid][cur_slotid[playerid]][posz], toyinfo[playerid][cur_slotid[playerid]][rotx], 
				toyinfo[playerid][cur_slotid[playerid]][roty],toyinfo[playerid][cur_slotid[playerid]][rotz],
				toyinfo[playerid][cur_slotid[playerid]][scalex], toyinfo[playerid][cur_slotid[playerid]][scaley],
				toyinfo[playerid][cur_slotid[playerid]][scalez]);
			SendClientMessage(playerid, -1, "Use \"/toyedit\" to edit toy position!");
			GivePlayerCash(playerid, -Toys[id][tprice]);

            mysql_format(Database, str, sizeof(str), "`UPDATE `User_Toys` SET `Toy_ID` = %d WHERE `User_ID` = %d AND `Index_` = %d LIMIT 1", id, userinfo[playerid][pid], cur_slotid[playerid]);
            mysql_tquery(Database, str);
		} 
	}
	return 1;
}

Dialog:DIALOG_USER_TOYS(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		cur_slotid[playerid] = listitem;
		new str[128];
		format(str, sizeof(str), "{ffa500}LGGW {ffffff}- Toy shop - Slot %d", listitem + 1);
		if(toyinfo[playerid][listitem][tused]) Dialog_Show(playerid, DIALOG_USER_TOYS_MANAGE, DIALOG_STYLE_LIST, str, "{ffff00}Replace toy\n{ff0000}Remove toy", "Select", "Close");
		else Dialog_Show(playerid, DIALOG_USER_TOYS_MANAGE, DIALOG_STYLE_LIST, str, "{ffff00}Add toy", "Select", "Close");
	}
	else Dialog_Close(playerid);
	return 1;
}

Dialog:DIALOG_USER_TOYS_MANAGE(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new str[128];
		if(!toyinfo[playerid][cur_slotid[playerid]][tused])
		{
			new st[512];
			for(new i = 0; i < sizeof(Toys); i++)
			{
				format(str, sizeof(str), "%d\t~g~$%d_~w~-_%s\n", Toys[i][tmodel], Toys[i][tprice], Toys[i][tname]);
				strcat(st, str, sizeof(st));
			}
			format(str, sizeof(str), "{ffa500}LGGW {ffffff}- Toy shop - Slot %d - Add toy", cur_slotid[playerid] + 1);
			ShowPlayerDialog(playerid, DIALOG_USER_TOY_BUY, DIALOG_STYLE_PREVIEW_MODEL, str, st, "Select", "Close");
			SendClientMessage(playerid, -1, "Select the toy you want to add");
		}
		else
		{
			switch(listitem)
			{
				case 0:
				{
					new st[512];
					for(new i = 0; i < sizeof(Toys); i++)
					{
						format(str, sizeof(str), "%i\t~g~$%i_~w~-_%s\n", Toys[i][tmodel], Toys[i][tprice], Toys[i][tname]);
						strcat(st, str, sizeof(st));
					}
					format(str, sizeof(str), "{ffa500}LGGW {ffffff}- Toy shop - Slot %d - Replace toy", cur_slotid[playerid] + 1);
					ShowPlayerDialog(playerid, DIALOG_USER_TOY_REPLACE, DIALOG_STYLE_PREVIEW_MODEL, str, st, "Select", "Close");
					SendClientMessage(playerid, -1, "Select the toy you want to replace with");
				}
				case 1:
				{
					format(str, sizeof(str), "{ffa500}LGGW {ffffff}- Toy shop - Slot %d - Remove toy", cur_slotid[playerid] + 1);
					Dialog_Show(playerid, DIALOG_USER_TOY_REMOVE, DIALOG_STYLE_MSGBOX, str, "{ffffff}Are you sure that you want to {7fff00}sell {ffffff}the\ntoy in this {ffff00}slot ID?\n\n{ffffff}This will refund you {ff0000}half of the initial price {ffffff}of the toy", "Remove", "Close");
				}
			}
		}
	}
	else Dialog_Close(playerid);
	return 1;
}

Dialog:DIALOG_USER_TOY_REMOVE(playerid, response, listitem, inputtext[])
{
	if(response)
	{	
		RemovePlayerAttachedObject(playerid, cur_slotid[playerid]);

		SendClientMessage(playerid, -1, "Toy removed!");
		GivePlayerCash(playerid, (Toys[toyinfo[playerid][cur_slotid[playerid]][tid]][tprice] / 2));

		toyinfo[playerid][cur_slotid[playerid]][tused] = 0;
		toyinfo[playerid][cur_slotid[playerid]][tid] = -1;
		toyinfo[playerid][cur_slotid[playerid]][bone] = 1;

        new str[80];
        mysql_format(Database, str, sizeof(str), "`UPDATE `User_Toys` SET `Used` = 0 WHERE `User_ID` = %d AND `Index_` = %d LIMIT 1", userinfo[playerid][pid], cur_slotid[playerid]);
        mysql_tquery(Database, str);
	}
	else Dialog_Close(playerid);
	return 1;
}

CMD:toyedit(playerid, params[])
{
	new slot;
	if(sscanf(params, "i", slot)) return SendClientMessage(playerid, -1, "/toyedit <slot ID>");
	if(slot < 1 || slot > MAX_PLAYER_ATTACHED_OBJECTS) return SendClientMessage(playerid, -1, "Invalid slot ID.");
	if(!toyinfo[playerid][slot - 1][tused]) return SendClientMessage(playerid, -1, "You don't have any toy in that slot!");
	EditAttachedObject(playerid, slot - 1);
	return 1;
}

CMD:toybone(playerid, params[])
{
	new slot, tbone;
	if(sscanf(params, "ii", slot, tbone))
	{
		SendClientMessage(playerid, -1, "/toybone <slot ID> <bone ID>"); 
		return SendClientMessage(playerid, -1, "Use /bonelist to check specific bone IDs");
	}
	if(slot < 1 || slot > MAX_PLAYER_ATTACHED_OBJECTS) return SendClientMessage(playerid, -1, "Invalid slot ID.");
	if(!toyinfo[playerid][slot - 1][tused]) return SendClientMessage(playerid, -1, "You don't have any toy in that slot!");
	if(tbone > 18 || tbone < 1) return SendClientMessage(playerid, -1, "Invalid bone ID use /bonelist to check specific bone IDs");
	
	toyinfo[playerid][slot - 1][bone] = tbone;
	
	SetPlayerAttachedObject(playerid, slot - 1, Toys[toyinfo[playerid][slot - 1][tid]][tmodel], 
	toyinfo[playerid][slot - 1][bone], 
	toyinfo[playerid][slot - 1][posx], 
	toyinfo[playerid][slot - 1][posy], 
	toyinfo[playerid][slot - 1][posz], 
	toyinfo[playerid][slot - 1][rotx], 
	toyinfo[playerid][slot - 1][roty],
	toyinfo[playerid][slot - 1][rotz],
	toyinfo[playerid][slot - 1][scalex], 
	toyinfo[playerid][slot - 1][scaley],
	toyinfo[playerid][slot - 1][scalez]);

    new str[80];
	mysql_format(Database, str, sizeof(str), "`UPDATE `User_Toys` SET `Bone` = %d WHERE `User_ID` = %d AND `Index_` = %d LIMIT 1", toyinfo[playerid][slot - 1][bone], userinfo[playerid][pid], slot - 1);
	mysql_tquery(Database, str);
	return 1;
}

CMD:bonelist(playerid, params[])
{
	Dialog_Show(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_MSGBOX, "{ffa500}LGGW {ffffff}- Bone list", "ID\t\tBone\n\n1\t\tSpine\n2\t\tHead\n3\t\tLeft upper arm\n4\t\tRight upper arm\n5\t\tLeft hand\n6\t\tRight hand\n7\t\tLeft thigh\n8\t\tRight thigh\n9\t\tLeft foot\n10\t\tRight foot\n11\t\tRight calf\n12\t\tLeft calf\n13\t\tLeft forearm\n14\t\tRight forearm\n15\t\tLeft clavicle (shoulder)\n16\t\tRight clavicle (shoulder)\n17\t\tNeck\n18\t\tJaw", "Close", "");
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	if(gvehowned[vehicleid])
	{
		SetVehicleHealth(vehicleid, 3000);
		ManageGangVehicleHealth(vehicleid);
	}
	return 1;
}

ManageGangVehicleHealth(vehicleid)
{
	new Float:health; 
	GetVehicleHealth(vehicleid, health);
	if(gang_vhealth[gvehid[vehicleid]] != health)
	{
		gang_vhealth[gvehid[vehicleid]] = health;
        SetProgressBar3DValue(gang_vlabel[gvehid[vehicleid]], health);
	}
	return 1;
}

Dialog:DIALOG_GANG_VEH(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(strval(inputtext))
		{
			case 1:
			{
				if(ganginfo[userinfo[playerid][gid]][gveh]) 
				{
					SendClientMessage(playerid, -1, "{ff0000}Your gang already owns a gang vehicle!");
					return  Dialog_Show(playerid, DIALOG_GANG_VEH, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Gang Vehicles", "{e9967a}ID\t\tOption\n{ffffff}1\t\t{7fff00}Buy vehicle\n{ffffff}2\t\t{ff0000}Sell vehicle", "Enter", "Close");
                }
				Dialog_Show(playerid, DIALOG_GANG_VEH_BUY, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Gang vehicles - Buy", "ID\t\tVehicle\t\tPrice\n1\t\tMonster\t\t$500\n2\t\tpatriot\t\t$500\n3\t\tFBI Rancher\t\t$500\n4\t\tSandking\t\t$500\n5\t\tMonster A\t\t$500\n6\t\tMonster B\t\t$500\n7\t\tBuritto\t\t$500", "Purchase", "Close");
			}
			case 2:
			{
				if(!ganginfo[userinfo[playerid][gid]][gveh]) 
				{
					SendClientMessage(playerid, -1, "{ff0000}You don't own a gang vehicle to sell!");
					return Dialog_Show(playerid, DIALOG_GANG_VEH, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Gang Vehicles", "{e9967a}ID\t\tOption\n{ffffff}1\t\t{7fff00}Buy vehicle\n{ffffff}2\t\t{ff0000}Sell vehicle", "Enter", "Close"); 
                }
				Dialog_Show(playerid, DIALOG_GANG_VEH_SELL, DIALOG_STYLE_MSGBOX, "{ffa500}LGGW {ffffff}- Gang vehicles - Sell", "Are you sure that you want to sell this gang vehicle?\nThis will refund you half of the initial amount!", "Sell", "Close");  
			}
		}
	}
	else Dialog_Close(playerid);
	return 1;
}

Dialog:DIALOG_GANG_VEH_SELL(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(ganginfo[userinfo[playerid][gid]][gvmodel])
		{
			case 444: GivePlayerCash(playerid, 250);
			case 470: GivePlayerCash(playerid, 250);
			case 490: GivePlayerCash(playerid, 250);
			case 495: GivePlayerCash(playerid, 250);
			case 556: GivePlayerCash(playerid, 250);
			case 557: GivePlayerCash(playerid, 250);
			case 582: GivePlayerCash(playerid, 250);
		}

		ganginfo[userinfo[playerid][gid]][gveh] = 0;
		ganginfo[userinfo[playerid][gid]][gvmodel] = -1;

		new str[128];
		mysql_format(Database, str, sizeof(str), "UPDATE `Gangs` SET `Vehicle_owned` = 0, `Vehicle_model` = -1 WHERE `Gang_ID` = %d LIMIT 1", userinfo[playerid][gid] + 1);
		mysql_tquery(Database, str);

		if(IsValidVehicle(gang_veh[userinfo[playerid][gid]]))
		{
			gang_veh[userinfo[playerid][gid]] = INVALID_VEHICLE_ID;
			gvehowned[gang_veh[userinfo[playerid][gid]]] = 0;
			gvehid[gang_veh[userinfo[playerid][gid]]] = -1;
			DestroyVehicle(gang_veh[userinfo[playerid][gid]]);
		}
		SendClientMessage(playerid, -1, "Gang vehicle has been sold!!!");
	}
	else Dialog_Close(playerid);
	return 1;
}

Dialog:DIALOG_GANG_VEH_BUY(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new str[128];
		ganginfo[userinfo[playerid][gid]][gveh] = 1;
		switch(strval(inputtext))
		{
			case 1:
			{
				if(GetPlayerCash(playerid) < 500) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy this vehicle!");
				SendClientMessage(playerid, -1, "You bought a nameeeee as your gang vehicle! Use /gang veh to spawn it!");
				ganginfo[userinfo[playerid][gid]][gvmodel] = 444;
				GivePlayerCash(playerid, -500);
				mysql_format(Database, str, sizeof(str), "UPDATE `Gangs` SET `Vehicle_owned` = 1, `Vehicle_model` = %d WHERE `Gang_ID` = %d LIMIT 1", ganginfo[userinfo[playerid][gid]][gvmodel], userinfo[playerid][gid] + 1);
				mysql_tquery(Database, str);

			}
			case 2:
			{
				if(GetPlayerCash(playerid) < 500) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy this vehicle!");
				SendClientMessage(playerid, -1, "You bought a nameeeee as your gang vehicle! Use /gang veh to spawn it!");
				ganginfo[userinfo[playerid][gid]][gvmodel] = 470;
				GivePlayerCash(playerid, -500);
				mysql_format(Database, str, sizeof(str), "UPDATE `Gangs` SET `Vehicle_owned` = 1, `Vehicle_model` = %d WHERE `Gang_ID` = %d LIMIT 1", ganginfo[userinfo[playerid][gid]][gvmodel], userinfo[playerid][gid] + 1);
				mysql_tquery(Database, str);
			}
			case 3:
			{
				if(GetPlayerCash(playerid) < 500) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy this vehicle!");
				SendClientMessage(playerid, -1, "You bought a nameeeee as your gang vehicle! Use /gang veh to spawn it!");
				ganginfo[userinfo[playerid][gid]][gvmodel] = 490;
				GivePlayerCash(playerid, -500);
				mysql_format(Database, str, sizeof(str), "UPDATE `Gangs` SET `Vehicle_owned` = 1, `Vehicle_model` = %d WHERE `Gang_ID` = %d LIMIT 1", ganginfo[userinfo[playerid][gid]][gvmodel], userinfo[playerid][gid] + 1);
				mysql_tquery(Database, str);
			}
			case 4:
			{
				if(GetPlayerCash(playerid) < 500) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy this vehicle!");
				SendClientMessage(playerid, -1, "You bought a nameeeee as your gang vehicle! Use /gang veh to spawn it!");
				ganginfo[userinfo[playerid][gid]][gvmodel] = 495;
				GivePlayerCash(playerid, -500);
				mysql_format(Database, str, sizeof(str), "UPDATE `Gangs` SET `Vehicle_owned` = 1, `Vehicle_model` = %d WHERE `Gang_ID` = %d LIMIT 1", ganginfo[userinfo[playerid][gid]][gvmodel], userinfo[playerid][gid] + 1);
				mysql_tquery(Database, str);
			}
			case 5:
			{
				if(GetPlayerCash(playerid) < 500) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy this vehicle!");
				SendClientMessage(playerid, -1, "You bought a nameeeee as your gang vehicle! Use /gang veh to spawn it!");
				ganginfo[userinfo[playerid][gid]][gvmodel] = 556;
				GivePlayerCash(playerid, -500);
				mysql_format(Database, str, sizeof(str), "UPDATE `Gangs` SET `Vehicle_owned` = 1, `Vehicle_model` = %d WHERE `Gang_ID` = %d LIMIT 1", ganginfo[userinfo[playerid][gid]][gvmodel], userinfo[playerid][gid] + 1);
				mysql_tquery(Database, str);
			}
			case 6:
			{
				if(GetPlayerCash(playerid) < 500) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy this vehicle!");
				SendClientMessage(playerid, -1, "You bought a nameeeee as your gang vehicle! Use /gang veh to spawn it!");
				ganginfo[userinfo[playerid][gid]][gvmodel] = 557;
				GivePlayerCash(playerid, -500);
				mysql_format(Database, str, sizeof(str), "UPDATE `Gangs` SET `Vehicle_owned` = 1, `Vehicle_model` = %d WHERE `Gang_ID` = %d LIMIT 1", ganginfo[userinfo[playerid][gid]][gvmodel], userinfo[playerid][gid] + 1);
				mysql_tquery(Database, str);
			}
			case 7:
			{
				if(GetPlayerCash(playerid) < 500) return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money to buy this vehicle!");
				SendClientMessage(playerid, -1, "You bought a nameeeee as your gang vehicle! Use /gang veh to spawn it!");
				ganginfo[userinfo[playerid][gid]][gvmodel] = 482;
				GivePlayerCash(playerid, -500);
				mysql_format(Database, str, sizeof(str), "UPDATE `Gangs` SET `Vehicle_owned` = 1, `Vehicle_model` = %d WHERE `Gang_ID` = %d LIMIT 1", ganginfo[userinfo[playerid][gid]][gvmodel], userinfo[playerid][gid] + 1);
				mysql_tquery(Database, str);
			}
			default:
			{
				Dialog_Show(playerid, DIALOG_GANG_VEH, DIALOG_STYLE_INPUT, "{ffa500}LGGW {ffffff}- Gang vehicles", "ID\t\tVehicle\t\tPrice\n1\t\tMonster\t\t$500\n2\t\tpatriot\t\t$500\n3\t\tFBI Rancher\t\t$500\n4\t\tSandking\t\t$500\n5\t\tMonster A\t\t$500\n6\t\tMonster B\t\t$500\n7\t\tBuritto\t\t$500", "Purchase", "Close");
				return SendClientMessage(playerid, -1, "Invalid selection.");
			}
		}
	}
	else Dialog_Close(playerid);
	return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	if(response)
	{
		fScaleX = (fScaleX < MINX) ? (MINX) : ((fScaleX > MAXX) ? (MAXX) : (fScaleX));
		fScaleY = (fScaleY < MINY) ? (MINY) : ((fScaleY > MAXY) ? (MAXY) : (fScaleY));
		fScaleZ = (fScaleZ < MINZ) ? (MINZ) : ((fScaleZ > MAXZ) ? (MAXZ) : (fScaleZ));
	 
		toyinfo[playerid][index][bone] = boneid;
		toyinfo[playerid][index][posx] = fOffsetX;
		toyinfo[playerid][index][posy] = fOffsetY;
		toyinfo[playerid][index][posz] = fOffsetZ;
		toyinfo[playerid][index][rotx] = fRotX;
		toyinfo[playerid][index][roty] = fRotY;
		toyinfo[playerid][index][rotz] = fRotZ;
		toyinfo[playerid][index][scalex] = fScaleX;
		toyinfo[playerid][index][scaley] = fScaleY;
		toyinfo[playerid][index][scalez] = fScaleZ;

		new str[300];

		format(str, sizeof(str), "New position for toy in slot %i has been saved!", index + 1);
		SendClientMessage(playerid, -1, str);

		mysql_format(Database, str, sizeof(str), "`UPDATE `User_Toys` SET `Pos_X` = %f, `Pos_Y` = %f, `Pos_Z` = %f, `Rot_X` = %f, `Rot_Y` = %f, `Rot_Z` = %f, `Scale_X` = %f,  `Scale_Y` = %f, `Scale_Z` = %f WHERE `User_ID` = %d AND `Index_` = %d LIMIT 1",
						toyinfo[playerid][index][posx], toyinfo[playerid][index][posy], toyinfo[playerid][index][posz], 
						toyinfo[playerid][index][rotx], toyinfo[playerid][index][roty], toyinfo[playerid][index][rotz],
						toyinfo[playerid][index][scalex], toyinfo[playerid][index][scaley], toyinfo[playerid][index][scalez], 
                        userinfo[playerid][pid], index);
		mysql_tquery(Database, str);
	} 
	else
	{
		SendClientMessage(playerid, -1, "Attached object edit canceled!");
		SetPlayerAttachedObject(playerid, index, modelid, toyinfo[playerid][index][bone], 
			toyinfo[playerid][index][posx], toyinfo[playerid][index][posy],
			toyinfo[playerid][index][posz], toyinfo[playerid][index][rotx], 
			toyinfo[playerid][index][roty], toyinfo[playerid][index][rotz], 
			toyinfo[playerid][index][scalex], toyinfo[playerid][index][scaley], 
			toyinfo[playerid][index][scalez]);
	}
	return 1;
}

public OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle)
{
    new str[128];

    SendClientMessageToAll_(-1, "Something appears wrong!!! SERVER will restart in 20 seconds!!!");
	SendClientMessageToAll_(-1, "Please take a screenshot of this message and inform to {ffff00}GameOvr#9363.");
	format(str, sizeof(str), "{ff0000}code - {ffffff}#%i", gettime());
    SendClientMessageToAll_(-1, str);
    SendClientMessageToAll_(-1, "Restarting...");
    //SetTimer("RestartServer", 20 * 1000, 0);
	return 1;
}

forward RestartServer();
public RestartServer()
{
    SendRconCommand("gmx");
    return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
    new str[200];
    new Menu:cur_menu = GetPlayerMenu(playerid);
    if(cur_menu == tune_main)
    {
        men_row[playerid] = 0;
        switch(row)
        {
            case 0:
            {
                if(PVehIs2ColorVehicle(GetVehicleModel(GetPlayerVehicleID(playerid)))) ShowMenuForPlayer(tune_colors2, playerid);
                else
                {
                    ShowMenuForPlayer(tune_colors, playerid);
                    Tune_SetupVehicle(playerid);
                    color_tab[playerid] = 0;
                }
            }
            case 1:
            {
                if(PVehIsPaintjobAvailable(GetVehicleModel(GetPlayerVehicleID(playerid)))) 
                {
                    ShowMenuForPlayer(tune_pjob, playerid);
                    Tune_SetupVehicle(playerid);
                }
                else 
                {
                    SendClientMessage(playerid, -1, "{ff0000}Paint jobs are not available for this vehicle!");
                    ShowMenuForPlayer(tune_main, playerid);
                    Tune_SetupMenuCamera(playerid);
                    return PlayerPlaySound(playerid, 1055, 0, 0, 0);
                }
            }
            case 2: 
            {
                ShowMenuForPlayer(tune_neons, playerid);
                Tune_SetupVehicle(playerid);
            }
            case 3:
            {
                if(PVehIsBike(GetVehicleModel(GetPlayerVehicleID(playerid))))
                {
                    SendClientMessage(playerid, -1, "{ff0000}Nitrous is not available for your vehicle!");    
                    ShowMenuForPlayer(tune_main, playerid);
                    Tune_SetupMenuCamera(playerid);
                }
                else 
                {
                    ShowMenuForPlayer(tune_nitro, playerid);
                    Tune_SetupVehicle(playerid);
                }
            }
            case 4:
            {
                if(PVehIsBike(GetVehicleModel(GetPlayerVehicleID(playerid))))
                {
                    SendClientMessage(playerid, -1, "{ff0000}Hydraulics is not available for your vehicle!");    
                    ShowMenuForPlayer(tune_main, playerid);
                    Tune_SetupMenuCamera(playerid);
                    return PlayerPlaySound(playerid, 1055, 0, 0, 0);
                }
                else
                {
                    ShowMenuForPlayer(tune_hydra, playerid);
                    Tune_SetupVehicle(playerid);
                }
            }
            case 5: 
            {
                ShowMenuForPlayer(tune_wheels, playerid);
                Tune_SetupVehicle(playerid);
                Tune_SetupMenuCamera(playerid);
            }
        }
    }
    else if(cur_menu == tune_colors2)
    {
        switch(row)
        {
            case 0: color_tab[playerid] = 0;
            case 1: color_tab[playerid] = 1;
        }
        ShowMenuForPlayer(tune_colors, playerid);
        men_row[playerid] = 0;
        Tune_SetupVehicle(playerid);
    }
    else if(cur_menu == tune_wheels)
    {   
        switch(row)
        {
            case 0: 
            {
                if(GetPlayerCash(playerid) < 350) 
                { 
                	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                }
                userinfo[playerid][vwheel] = 1073;
                GivePlayerCash(playerid, -350);

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_wheel` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vwheel], userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
            case 1:
            {
                if(GetPlayerCash(playerid) < 350) 
                { 
                	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                }
                userinfo[playerid][vwheel] = 1074;
                GivePlayerCash(playerid, -350);

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_wheel` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vwheel], userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
            case 2:
            {
                if(GetPlayerCash(playerid) < 350) 
                { 
                	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                }
                userinfo[playerid][vwheel] = 1075;
                GivePlayerCash(playerid, -350);

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_wheel` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vwheel], userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
            case 3:
            {
                if(GetPlayerCash(playerid) < 350) 
                { 
                	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                }
                userinfo[playerid][vwheel] = 1076;
                GivePlayerCash(playerid, -350);

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_wheel` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vwheel], userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
            case 4:
            {
                if(GetPlayerCash(playerid) < 350) 
                { 
                	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                }
                userinfo[playerid][vwheel] = 1077;
                GivePlayerCash(playerid, -350);

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_wheel` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vwheel], userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
            case 5:
            {
                if(GetPlayerCash(playerid) < 350) 
                { 
                	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                }
                userinfo[playerid][vwheel] = 1078;
                GivePlayerCash(playerid, -350);

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_wheel` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vwheel], userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
            case 6:
            {   
                if(GetPlayerCash(playerid) < 350) 
                { 
                	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                }
                userinfo[playerid][vwheel] = 1079;
                GivePlayerCash(playerid, -350);

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_wheel` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vwheel], userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
            case 7:
            {
                if(GetPlayerCash(playerid) < 350) 
                { 
                	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                }
                userinfo[playerid][vwheel] = 1083;
                GivePlayerCash(playerid, -350);

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_wheel` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vwheel], userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
            case 8:
            {
                if(GetPlayerCash(playerid) < 350) 
                { 
                	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                }
                userinfo[playerid][vwheel] = 1085;
                GivePlayerCash(playerid, -350);

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_wheel` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vwheel], userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
        }
        ShowMenuForPlayer(tune_wheels, playerid);
        men_row[playerid] = 0;
    }
    else if(cur_menu == tune_colors)
    {
        switch(color_tab[playerid])
        {
            case 0:
            {
                switch(row)
                {
                    case 0:
                    {
                        if(GetPlayerCash(playerid) < 150) 
                        { 
                        	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                        	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                        }
                        GivePlayerCash(playerid, -150);
                        userinfo[playerid][vcolor_1] = 0;
                        userinfo[playerid][vcolor_2] = 0;
                       
                        mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_color_1` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vcolor_1], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
                        mysql_tquery(Database, str);
                    }
                    case 1:
                    {
                        if(GetPlayerCash(playerid) < 150) 
                        { 
                        	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                        	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                        }
                        GivePlayerCash(playerid, -150);
                        userinfo[playerid][vcolor_1] = 1;
                        userinfo[playerid][vcolor_2] = 1;

                        mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_color_1` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vcolor_1], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
                        mysql_tquery(Database, str);
                    }
                    case 2:
                    {
                        if(GetPlayerCash(playerid) < 150) 
                        { 
                        	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                        	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                        }
                        GivePlayerCash(playerid, -150);
                        userinfo[playerid][vcolor_1] = 128;
                        userinfo[playerid][vcolor_2] = 128;

                        mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_color_1` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vcolor_1], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
                        mysql_tquery(Database, str);
                    }
                    case 3:
                    {
                        if(GetPlayerCash(playerid) < 150) 
                        { 
                        	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                        	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                        }
                        GivePlayerCash(playerid, -150);
                        userinfo[playerid][vcolor_1] = 135;
                        userinfo[playerid][vcolor_2] = 135;

                        mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_color_1` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vcolor_1], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
                        mysql_tquery(Database, str);
                    }
                    case 4:
                    {
                        if(GetPlayerCash(playerid) < 150) 
                        { 
                        	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                        	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                        }
                        GivePlayerCash(playerid, -150);
                        userinfo[playerid][vcolor_1] = 152;
                        userinfo[playerid][vcolor_2] = 152;

                        mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_color_1` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vcolor_1], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
                        mysql_tquery(Database, str);
                    }
                    case 5:
                    {
                        if(GetPlayerCash(playerid) < 150) 
                        { 
                        	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                        	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                        }
                        GivePlayerCash(playerid, -150);
                        userinfo[playerid][vcolor_1] = 6;
                        userinfo[playerid][vcolor_2] = 6;

                        mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_color_1` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vcolor_1], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
                        mysql_tquery(Database, str);
                    }
                    case 6:
                    {
                        if(GetPlayerCash(playerid) < 150) 
                        { 
                        	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                        	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                        }
                        GivePlayerCash(playerid, -150);
                        userinfo[playerid][vcolor_1] = 252;
                        userinfo[playerid][vcolor_2] = 252;

                        mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_color_1` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vcolor_1], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
                        mysql_tquery(Database, str);
                    }
                    case 7:
                    {
                        if(GetPlayerCash(playerid) < 150) 
                        { 
                        	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                        	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                        }
                        GivePlayerCash(playerid, -150);
                        userinfo[playerid][vcolor_1] = 146;
                        userinfo[playerid][vcolor_2] = 146;

                        mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_color_1` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vcolor_1], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
                        mysql_tquery(Database, str);
                    }
                    case 8:
                    {
                        if(GetPlayerCash(playerid) < 150) 
                        { 
                        	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                        	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                        }
                        GivePlayerCash(playerid, -150);
                        userinfo[playerid][vcolor_1] = 219;
                        userinfo[playerid][vcolor_2] = 219;

                        mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_color_1` = %d, `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vcolor_1], userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
                        mysql_tquery(Database, str);
                    }
                }
            }
            case 1:
            {
                switch(row)
                {
                    case 0:
                    {
                        if(GetPlayerCash(playerid) < 150) 
                        { 
                        	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                        	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                        }
                        GivePlayerCash(playerid, -150);
                        userinfo[playerid][vcolor_2] = 0;

                        mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
                        mysql_tquery(Database, str);
                    }
                    case 1:
                    {
                        if(GetPlayerCash(playerid) < 150) 
                        { 
                        	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                        	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                        }
                        GivePlayerCash(playerid, -150);
                        userinfo[playerid][vcolor_2] = 1;

                        mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
                        mysql_tquery(Database, str);
                    }
                    case 2:
                    {
                        if(GetPlayerCash(playerid) < 150) 
                        { 
                        	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                        	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                        }
                        GivePlayerCash(playerid, -150);
                        userinfo[playerid][vcolor_2] = 128;

                        mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
                        mysql_tquery(Database, str);
                    }
                    case 3:
                    {
                        if(GetPlayerCash(playerid) < 150) 
                        { 
                        	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                        	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                        }
                        GivePlayerCash(playerid, -150);
                        userinfo[playerid][vcolor_2] = 135;

                        mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
                        mysql_tquery(Database, str);
                    }
                    case 4:
                    {
                        if(GetPlayerCash(playerid) < 150) 
                        { 
                        	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                        	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                        }
                        GivePlayerCash(playerid, -150);              
                        userinfo[playerid][vcolor_2] = 152;

                        mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
                        mysql_tquery(Database, str);
                    }
                    case 5:
                    {
                        if(GetPlayerCash(playerid) < 150) 
                        { 
                        	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                        	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                        }
                        GivePlayerCash(playerid, -150);
                        userinfo[playerid][vcolor_2] = 6;

                        mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
                        mysql_tquery(Database, str);
                    }
                    case 6:
                    {
                        if(GetPlayerCash(playerid) < 150) 
                        { 
                        	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                        	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                        }
                        GivePlayerCash(playerid, -150);
                        userinfo[playerid][vcolor_2] = 252;

                        mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
                        mysql_tquery(Database, str);
                    }
                    case 7:
                    {
                        if(GetPlayerCash(playerid) < 150) 
                        { 
                        	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                        	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                        }
                        GivePlayerCash(playerid, -150);
                        userinfo[playerid][vcolor_2] = 146;

                        mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
                        mysql_tquery(Database, str);
                    }
                    case 8:
                    {
                        if(GetPlayerCash(playerid) < 150) 
                        { 
                        	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                        	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                        }
                        GivePlayerCash(playerid, -150);
                        userinfo[playerid][vcolor_2] = 219;

                        mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_color_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vcolor_2], userinfo[playerid][pid]);
                        mysql_tquery(Database, str);
                    }
                }
            }
        }
        ShowMenuForPlayer(tune_colors, playerid);
        men_row[playerid] = 0;
    }
    else if(cur_menu == tune_neons)
    {
        switch(row)
        {
            case 0: //neon
            {
                if(GetPlayerCash(playerid) < 3000) 
                { 
                	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                }
                DestroyObject(editvneon[playerid][0]);
                DestroyObject(editvneon[playerid][1]);
                vehneon[GetPlayerVehicleID(playerid)][0] = CreateObject(18651,0,0,0,0,0,0); 
                vehneon[GetPlayerVehicleID(playerid)][1] = CreateObject(18651,0,0,0,0,0,0);
                AttachObjectToVehicle(vehneon[GetPlayerVehicleID(playerid)][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                AttachObjectToVehicle(vehneon[GetPlayerVehicleID(playerid)][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                userinfo[playerid][vneon_1] = 1;
                GivePlayerCash(playerid, -3000); 

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_neon_1` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vneon_1], userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
            case 1: //neon
            {
                if(GetPlayerCash(playerid) < 2000) 
                { 
                	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                }
                DestroyObject(editvneon[playerid][2]);
                vehneon[GetPlayerVehicleID(playerid)][2] = CreateObject(18646,0,0,0,0,0,0); 
                AttachObjectToVehicle(vehneon[GetPlayerVehicleID(playerid)][2], GetPlayerVehicleID(playerid), 0.0, -0.35, 0.90, 0.0, 0.0, 0.0);
                userinfo[playerid][vneon_2] = 1;
                GivePlayerCash(playerid, -2000);

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_neon_2` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vneon_2], userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
            case 2: // remove neon
            {
                userinfo[playerid][vneon_1] = 0;
                userinfo[playerid][vneon_2] = 0;

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_neon_1` = 0, `Vehicle_neon_2` = 0 WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
        }
        ShowMenuForPlayer(tune_neons, playerid);
        men_row[playerid] = 0;
    }
    else if(cur_menu == tune_nitro)
    {
        switch(row)
        {
            case 0:
            {
                if(GetPlayerCash(playerid) < 200) 
                { 
                	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                }
                userinfo[playerid][vnitro] = 1008;
                GivePlayerCash(playerid, -200);

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_nitro` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vnitro], userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
            case 1:
            {
                if(GetPlayerCash(playerid) < 500) 
                { 
                	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                }
                userinfo[playerid][vnitro] = 1009;
                GivePlayerCash(playerid, -500);

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_nitro` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vnitro], userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
            case 2: 
            {
                if(GetPlayerCash(playerid) < 1000) 
                { 
                	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                }
                userinfo[playerid][vnitro] = 1010;
                GivePlayerCash(playerid, -1000);

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_nitro` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vnitro], userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
            case 3:
            {
                userinfo[playerid][vnitro] = -1;

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_nitro` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vnitro], userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
        }
        ShowMenuForPlayer(tune_nitro, playerid);
        men_row[playerid] = 0;
    }
    else if(cur_menu == tune_hydra)
    {
        switch(row)
        {
            case 0: 
            {
                if(GetPlayerCash(playerid) < 1000) 
                { 
                	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                }
                userinfo[playerid][vhydra] = 1;
                GivePlayerCash(playerid, -1000);

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_hydraulics` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vhydra], userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
            case 1:
            {
                userinfo[playerid][vhydra] = 0;

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_hydraulics` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vhydra], userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
        }
        ShowMenuForPlayer(tune_hydra, playerid);
        men_row[playerid] = 0;
    }
    else if(cur_menu == tune_pjob)
    {
        switch(row)
        {
            case 0:
            {
                if(GetPlayerCash(playerid) < 750)  
                { 
                	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                }
                GivePlayerCash(playerid, -750);
                userinfo[playerid][vpjob] = 0;

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_paintjob` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vpjob], userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
            case 1:
            {
                if(GetPlayerCash(playerid) < 750) 
                { 
                	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                }
                GivePlayerCash(playerid, -750);
                userinfo[playerid][vpjob] = 1;

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_paintjob` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vpjob], userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
            case 2:
            {
                if(GetPlayerCash(playerid) < 750) 
                { 
                	PlayerPlaySound(playerid, 1055, 0, 0, 0);
                	return SendClientMessage(playerid, -1, "{ff0000}You don't have enough money!"); 
                }
                GivePlayerCash(playerid, -750);
                userinfo[playerid][vpjob] = 2;

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_paintjob` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vpjob], userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
            case 3:
            {
                userinfo[playerid][vpjob] = 3;

                mysql_format(Database, str, sizeof(str), "UPDATE `User_Vehicles` SET `Vehicle_paintjob` = %d WHERE `User_ID` = %d LIMIT 1", userinfo[playerid][vpjob], userinfo[playerid][pid]);
                mysql_tquery(Database, str);
            }
        }
        ShowMenuForPlayer(tune_pjob, playerid);
        men_row[playerid] = 0;
    }   
    PlayerPlaySound(playerid, 1054, 0, 0, 0);
    return 1;
}

CMD:use(playerid, params[])
{
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);
	ApplyAnimation(playerid, "VENDING","VEND_Drink_P", 4.1, 0, 1, 1, 1, 1500);
	time_edrink[playerid] = tickcount();
	return 1;
}

CMD:bd(playerid, params[])
{
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 1, 1, 1, 0, 2000);
	time_band[playerid] = tickcount();
	return 1;
}

CMD:lel(playerid, params[])
{
	SetPlayerPos(playerid,2128.5830,-1140.2947 + 2,25.2329);
	return 1;
}

CMD:lell(playerid, params[])
{
	SetPlayerPos(playerid, 1518.2750,-1465.3423 + 2,9.5000);//pveh mod shop
	return 1;
}

/*Float:PlayerScore(kills, deaths, hramp, duelwins, rev)
{
    new Float:kv;
    
    for(new i = 0; i < kills; i++) kv += floatdiv(1, i+1);
    for(new i = 0; i < hramp; i++) kv += floatdiv(1, i+1);
    for(new i = 0; i < duelwins; i++) kv += floatdiv(1, i+1);
    for(new i = 0; i < rev; i++) kv += floatdiv(1, i+1);
    for(new i = 0; i < deaths; i++) kv -= floatdiv(1, i+1);

    kv = kv/5;
    if(deaths != 0) kv += floatdiv(kills, deaths);
    
    new Float:result = 0.0;
    for (new i = 0; i < 10; i++) 
    { 
        result += (2.0 / (2.0 * i + 1.0)) * floatpower(((kv - 1.0) / (kv + 1.0)), 2.0 * i + 1.0);
    }
    if(result > 0) return result;
    return 0.00;
}

SetupGangLevelBar(gangid)
{
    new level[20],str[128]; 
    foreach(new i : Player)
    {
        if(userinfo[i][gid] == gangid)
        {
            if(userinfo[i][pscore] >= 100) level = "Gangstar";
            else if(userinfo[i][pscore] >= 90) level = "LGGW_Hero";
            else if(userinfo[i][pscore] >= 80) level = "Dominator";
            else if(userinfo[i][pscore] >= 70) level = "Extreme_Killa";
            else if(userinfo[i][pscore] >= 60) level = "Assisian";
            else if(userinfo[i][pscore] >= 50) level = "Killa";
            else if(userinfo[i][pscore] >= 40) level = "Backup_Force";
            else if(userinfo[i][pscore] >= 30) level = "Thug";
            else if(userinfo[i][pscore] >= 20) level = "Criminal";
            else if(userinfo[i][pscore] >= 10) level = "Rookie";
            else if(userinfo[i][pscore] >= 0) level = "Newbie";

            if(ganginfo[userinfo[i][gid]][gscore] >= 350)
            {
                format(str, sizeof(str), "%s~n~~n~~n~Conquer", level);
                PlayerTextDrawSetString(i, pleveltd[i], str);
                SetPlayerProgressBarValue(i, glbar[i], ganginfo[userinfo[i][gid]][gscore]);
            }
            else if(ganginfo[userinfo[i][gid]][gscore] >= 300)
            {
                format(str, sizeof(str), "%s~n~~n~~n~Silver", level);
                PlayerTextDrawSetString(i, pleveltd[i], str);
                SetPlayerProgressBarValue(i, glbar[i], ganginfo[userinfo[i][gid]][gscore]);
            }
            else if(ganginfo[userinfo[i][gid]][gscore] >= 250)
            {
                format(str, sizeof(str), "%s~n~~n~~n~Gold", level);
                PlayerTextDrawSetString(i, pleveltd[i], str);
                SetPlayerProgressBarValue(i, glbar[i], ganginfo[userinfo[i][gid]][gscore]);
            }
            else if(ganginfo[userinfo[i][gid]][gscore] >= 200)
            {
                format(str, sizeof(str), "%s~n~~n~~n~Ace", level);
                PlayerTextDrawSetString(i, pleveltd[i], str);
                SetPlayerProgressBarValue(i, glbar[i], ganginfo[userinfo[i][gid]][gscore]);
            }
            else if(ganginfo[userinfo[i][gid]][gscore] >= 150)
            {
                format(str, sizeof(str), "%s~n~~n~~n~Crown", level);
                PlayerTextDrawSetString(i, pleveltd[i], str);
                SetPlayerProgressBarValue(i, glbar[i], ganginfo[userinfo[i][gid]][gscore]);
            }
            else if(ganginfo[userinfo[i][gid]][gscore] >= 100)
            {
                format(str, sizeof(str), "%s~n~~n~~n~Diamond", level);
                PlayerTextDrawSetString(i, pleveltd[i], str);
                SetPlayerProgressBarValue(i, glbar[i], ganginfo[userinfo[i][gid]][gscore]);
            }
            else if(ganginfo[userinfo[i][gid]][gscore] >= 50)
            {
                format(str, sizeof(str), "%s~n~~n~~n~Platinum", level);
                PlayerTextDrawSetString(i, pleveltd[i], str);
                SetPlayerProgressBarValue(i, glbar[i], ganginfo[userinfo[i][gid]][gscore]);
            }
            else if(ganginfo[userinfo[i][gid]][gscore] >= 0)
            {
                format(str, sizeof(str), "%s~n~~n~~n~Bronze", level);
                PlayerTextDrawSetString(i, pleveltd[i], str);
                SetPlayerProgressBarValue(i, glbar[i], ganginfo[userinfo[i][gid]][gscore]);
            }
            ShowPlayerProgressBar(i, glbar[i]);
            PlayerTextDrawShow(i, pleveltd[i]);
        }
    }
    return 1;
}

SetupPlayerLevelBar(playerid)
{   
    new glevel_[20];
    if(ganginfo[userinfo[playerid][gid]] = "Crown";
    if(ganginfo[userinfo[playerid][gid]][gscore] >= 50) glevel_ = "Ace";
    if(ganginfo[userinfo[playerid][gid]][gscore] >= 0) glevel_ = "Conquer";

    new str[128];
    if(userinfo[playerid][pscore] >= 100)
    {
        format(str, sizeof(str), "Gangster~n~~n~~n~%s", g[gscore] >= 350) glevel_ = "Bronze";
    if(ganginfo[userinfo[playerid][gid]][gscore] >= 300) glevel_ = "Silver";
    if(ganginfo[userinfo[playerid][gid]][gscore] >= 250) glevel_ = "Gold ";
    if(ganginfo[userinfo[playerid][gid]][gscore] >= 200) glevel_ = "Platinum";
    if(ganginfo[userinfo[playerid][gid]][gscore] >= 150) glevel_ = "Diamond";
    if(ganginfo[userinfo[playerid][gid]][gscore] >= 100) glevel_level_);
        PlayerTextDrawSetString(playerid, pleveltd[playerid], str);
        SetPlayerProgressBarValue(playerid, lbar[playerid], userinfo[playerid][pscore]);
    }
    else if(userinfo[playerid][pscore] >= 90)
    {
        format(str, sizeof(str), "LGGW_Hero~n~~n~~n~%s", glevel_);
        PlayerTextDrawSetString(playerid, pleveltd[playerid], str);
        SetPlayerProgressBarValue(playerid, lbar[playerid], userinfo[playerid][pscore]);
    }
    else if(userinfo[playerid][pscore] >= 80)
    {
        format(str, sizeof(str), "Dominator~n~~n~~n~%s", glevel_);
        PlayerTextDrawSetString(playerid, pleveltd[playerid], str);
        SetPlayerProgressBarValue(playerid, lbar[playerid], userinfo[playerid][pscore]);
    }
    else if(userinfo[playerid][pscore] >= 70)
    {
        format(str, sizeof(str), "Extreme_Killa~n~~n~~n~%s", glevel_);
        PlayerTextDrawSetString(playerid, pleveltd[playerid], str);
        SetPlayerProgressBarValue(playerid, lbar[playerid], userinfo[playerid][pscore]);
    }
    else if(userinfo[playerid][pscore] >= 60)
    {
        format(str, sizeof(str), "Assisian~n~~n~~n~%s", glevel_);
        PlayerTextDrawSetString(playerid, pleveltd[playerid], str);
        SetPlayerProgressBarValue(playerid, lbar[playerid], userinfo[playerid][pscore]);
    }
    else if(userinfo[playerid][pscore] >= 50)
    {

        format(str, sizeof(str), "Killa~n~~n~~n~%s", glevel_);
        PlayerTextDrawSetString(playerid, pleveltd[playerid], str);
        SetPlayerProgressBarValue(playerid, lbar[playerid], userinfo[playerid][pscore]);
    }
    else if(userinfo[playerid][pscore] >= 40)
    {
        format(str, sizeof(str), "Backup_Force~n~~n~~n~%s", glevel_);
        PlayerTextDrawSetString(playerid, pleveltd[playerid], str);
        SetPlayerProgressBarValue(playerid, lbar[playerid], userinfo[playerid][pscore]);
    }
    else if(userinfo[playerid][pscore] >= 30)
    {
        format(str, sizeof(str), "Thug~n~~n~~n~%s", glevel_);
        PlayerTextDrawSetString(playerid, pleveltd[playerid], str);
        SetPlayerProgressBarValue(playerid, lbar[playerid], userinfo[playerid][pscore]);
    }
    else if(userinfo[playerid][pscore] >= 20)
    {
        format(str, sizeof(str), "Criminal~n~~n~~n~%s", glevel_);
        PlayerTextDrawSetString(playerid, pleveltd[playerid], str);
        SetPlayerProgressBarValue(playerid, lbar[playerid], userinfo[playerid][pscore]);
    }
    else if(userinfo[playerid][pscore] >= 10)
    {
        format(str, sizeof(str), "Rookie~n~~n~~n~%s", glevel_); 
        PlayerTextDrawSetString(playerid, pleveltd[playerid], str);
        SetPlayerProgressBarValue(playerid, lbar[playerid], userinfo[playerid][pscore]);
    }
    else if(userinfo[playerid][pscore] >= 0)
    {
        format(str, sizeof(str), "Newbie~n~~n~~n~%s", glevel_);
        PlayerTextDrawSetString(playerid, pleveltd[playerid], str);
        SetPlayerProgressBarValue(playerid, lbar[playerid], userinfo[playerid][pscore]);
    }

    ShowPlayerProgressBar(playerid, lbar[playerid]);
    PlayerTextDrawShow(playerid, pleveltd[playerid]);
    return 1;
}*/