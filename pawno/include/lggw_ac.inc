#include <a_samp>

forward OnPlayerCheat(playerid, cheat_code);

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define                 CHEAT_CODE_AUTOC                        1
#define                 CHEAT_CODE_FLY                          2
#define                 CHEAT_CODE_VEHMOD                       3
#define                 CHEAT_CODE_PROAIM                       4
#define                 CHEAT_CODE_SILENTAIM                    5
#define                 CHEAT_CODE_CJ                           6
#define                 CHEAT_CODE_RAPIDFIRE                    7
#define                 CHEAT_CODE_TROLL 	                    8
#define                 CHEAT_CODE_AUTOBULLET 	                9
#define                 CHEAT_CODE_NPCSPOOF 	                10
#define                 CHEAT_CODE_CONNECTIONSPOOF 	            11
#define                 CHEAT_CODE_LAGTROLL	     	            12
#define 				CHEAT_CODE_TELEPORT 				    0

#define 				MIN_LAG_SHOT_DIFF						550 

#define 				MAX_RAPIDFIRE_INFRACTIONS				5 

#define 				MAX_PROAIM_INFRACTIONS				    5

#define 				MAX_SILENTAIM_INFRACTIONS				5

#define             	MAX_AUTOBULLET_INFRACTIONS          	3
#define             	AUTOBULLET_RESET_DELAY              	30

#define         		MAX_VEHICLE_ID_CHANGES          		5

static LastVehicleID[MAX_PLAYERS], VehicleIDChanges[MAX_PLAYERS], VehicleIDChangeTime[MAX_PLAYERS];
static AutoBulletInfractions[MAX_PLAYERS], LastInfractionTime[MAX_PLAYERS];
static AutoC[MAX_PLAYERS], AutoC_tick[MAX_PLAYERS];
static SilentAimCount[MAX_PLAYERS], ProAimCount[MAX_PLAYERS], TintaApasata[MAX_PLAYERS];
static infractions[MAX_PLAYERS], skillLevel[MAX_PLAYERS] = {999, ...}, lastShotTick[MAX_PLAYERS], lastCrouchTick[MAX_PLAYERS];
static cur_vehicle[MAX_PLAYERS] = {INVALID_VEHICLE_ID, ...};
static WeaponShotIntervals[17] = 
{
	// Pistols
	300, // 22 M9 WHEN DUAL: 185
	400, // 23 M9 SD
	800, // 24 Desert Eagle WHEN C-BUGGING: 100

	// Shotgun
	1060, // 25 Shotgun
	300, // 26 Sawnoff WHEN DUAL: 140
	320, // 27 Spas 12

	// Automatic
	120, // 28 Mac 10 WHEN DUAL: 35
	100, // 29 MP5
	120, // 30 AK-47
	120, // 31 M16
	120, // 32 Tec 9 WHEN DUAL: 35

	// Rifle
	1060, // 33 Rifle
	1060, // 34 Sniper

	// Heavy
	0, // 35 RPG
	0, // 36 Heatseeker
	0, // 37 Flamer
	20 // 38 Minigun
};
static bool:PlayerConnected[MAX_PLAYERS];
static PlayerNames[MAX_PLAYERS][MAX_PLAYER_NAME];

public OnPlayerConnect(playerid)
{
    
    if(IsPlayerNPC(playerid))
    {
        new ip[16];
        GetPlayerIp(playerid, ip, sizeof(ip));
        if (!!strcmp(ip, "127.0.0.1"))
        {
            new name[MAX_PLAYER_NAME];
            format(name, sizeof(name), "%i", gettime());
            SetPlayerName(playerid, name);
            CallLocalFunction("OnPlayerCheat", "dd", playerid, CHEAT_CODE_NPCSPOOF);
            return 1;
        }
    }
    else 
    {
    	if(PlayerConnected[playerid])
	    {
	        SetPlayerName(playerid, PlayerNames[playerid]);
	        CallLocalFunction("OnPlayerCheat", "dd", playerid, CHEAT_CODE_CONNECTIONSPOOF);
	        return 1;
	    }
	    else
	    {
	        GetPlayerName(playerid, PlayerNames[playerid], MAX_PLAYER_NAME);
	        PlayerConnected[playerid] = true;
	    }
    }

  	#if defined LAC_OnPlayerConnect
        LAC_OnPlayerConnect(playerid);
    #endif
    return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(GetPlayerWeapon(playerid) == WEAPON_DEAGLE)
	{
		if((((tickcount()) - AutoC_tick[playerid]) < MIN_LAG_SHOT_DIFF) && AutoC[playerid])
		{
			CallLocalFunction("OnPlayerCheat", "dd", playerid, CHEAT_CODE_AUTOC);
			return 0;
		}

        AutoC_tick[playerid] = (tickcount());
		AutoC[playerid] = 1;
	}

	if(weaponid != 38 && weaponid > 18 && weaponid < 34 && hittype == 1)
	{
		new Float:shot_vectors[6], Float:aim_dist;
		GetPlayerPos(hitid,shot_vectors[0],shot_vectors[1],shot_vectors[2]); 
		aim_dist = GetPlayerDistanceFromPoint(playerid,shot_vectors[0],shot_vectors[1],shot_vectors[2]);

		if(GetPlayerTargetPlayer(playerid) == INVALID_PLAYER_ID && aim_dist > 1 && aim_dist < 31 && TintaApasata[playerid] == 1)
		{
			SilentAimCount[playerid]++;
			if(SilentAimCount[playerid] >= MAX_SILENTAIM_INFRACTIONS)
			{
				SilentAimCount[playerid] = 0;
				CallLocalFunction("OnPlayerCheat", "dd", playerid, CHEAT_CODE_SILENTAIM);
				return 0;
			}
		}
		
		GetPlayerLastShotVectors(playerid, shot_vectors[0],shot_vectors[1],shot_vectors[2], shot_vectors[3],shot_vectors[4],shot_vectors[5]);
		if(!IsPlayerInRangeOfPoint(hitid, 3.0, shot_vectors[3],shot_vectors[4],shot_vectors[5])) 
		{
			ProAimCount[playerid]++;
			if(ProAimCount[playerid] >= MAX_PROAIM_INFRACTIONS)
			{
				ProAimCount[playerid] = 0;
				CallLocalFunction("OnPlayerCheat", "dd", playerid, CHEAT_CODE_PROAIM);
				return 0;
			}
		}
	}

	new interval = lastShotTick[playerid] - tickcount(),
		weaponshotinterval = WeaponShotIntervals[weaponid - 22] - 20
	;

	if(skillLevel[playerid] == 999) 
	{
		switch(weaponid) 
		{
			case 22: weaponshotinterval = 185;
			case 26: weaponshotinterval = 140;
			case 28: weaponshotinterval = 35;
			case 32: weaponshotinterval = 35;
		}
	}

	if(weaponid == 24) 
	{
		if(lastCrouchTick[playerid] - tickcount() < 600)  weaponshotinterval = 100;
	}

	if(interval < weaponshotinterval) 
	{

		infractions[playerid]++;

		if(infractions[playerid] == MAX_RAPIDFIRE_INFRACTIONS) 
		{
			infractions[playerid] = 0;
			CallLocalFunction("OnPlayerCheat", "dd", playerid, CHEAT_CODE_RAPIDFIRE);
		}
		return 0;
	}

	lastShotTick[playerid] = tickcount();


	if(!IsPlayerInAnyVehicle(playerid))
    {
        switch(weaponid)
        {
            case 27, 23, 25, 29, 30, 31, 33, 24, 38:
            {
                if(CheckSpeed(playerid))
                {
                    if(gettime() - LastInfractionTime[playerid] >= AUTOBULLET_RESET_DELAY) AutoBulletInfractions[playerid] = 1;
                    else AutoBulletInfractions[playerid]++;
                    LastInfractionTime[playerid] = gettime();

                    if(AutoBulletInfractions[playerid] == MAX_AUTOBULLET_INFRACTIONS)
                    {
                        AutoBulletInfractions[playerid] = 0;
                        CallLocalFunction("OnPlayerCheat", "dd", playerid, CHEAT_CODE_AUTOBULLET);
                        return 0;
                    }
                }
            }
        }
    }

	#if defined LAC_OnPlayerWeaponShot
        LAC_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
    #endif
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_CROUCH)
	{ 
		AutoC[playerid] = 0; 
		lastCrouchTick[playerid] = tickcount(); 
		new str[80];
		format(str, sizeof(str), "[ debug ] 'c' pressed -> playerid - %d last_crouch_tick - %d", playerid, lastCrouchTick[playerid]);
		SendClientMessageToAll(-1, str);
	}
	else if(newkeys & KEY_HANDBRAKE && !IsPlayerInAnyVehicle(playerid)) TintaApasata[playerid] = 1;
	else if(oldkeys & KEY_HANDBRAKE) TintaApasata[playerid] = 0;
	
	#if defined LAC_OnPlayerKeyStateChange
        LAC_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    #endif
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	cur_vehicle[playerid] = vehicleid;

	#if defined LAC_OnPlayerEnterVehicle
        LAC_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
    #endif
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if((newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) && (oldstate != PLAYER_STATE_DRIVER && oldstate != PLAYER_STATE_PASSENGER))
	{
		if(cur_vehicle[playerid] != GetPlayerVehicleID(playerid))
		{
			CallLocalFunction("OnPlayerCheat", "dd", playerid, CHEAT_CODE_TROLL);
		}
		else cur_vehicle[playerid] = INVALID_VEHICLE_ID;
	}

	#if defined LAC_OnPlayerStateChange
        LAC_OnPlayerStateChange(playerid, newstate, oldstate);
    #endif
	return 1;
}

static stock IsPlayerUsingSwimAnim(playerid) 
{
    switch(GetPlayerAnimationIndex(playerid))
    {
        case 1538, 1542, 1544, 1250, 1062, 1539, 958, 962: return true;
    }
    return false;
}

static stock IsPlayerInWater(playerid) //Credits to Synchro for his coords function.
{
    static 
        Float:fX, 
        Float:fY, 
        Float:fZ
    ;
    GetPlayerPos( playerid, fX, fY, fZ );

    if((fX >= 2044.6 && fX <= 2192.984 && fY >= 1206.358 && fY <= 1376.552) && fZ < 0xA) return true;
    else if((fX >= 2048.504 && fX <= 2185.174 && fY >= 1063.239 && fY <= 1202.49) && fZ < 0xA) return true;
    else if((fX >= 2204.698 && fX <= 2204.698 && fY >= 1426.837 && fY <= 1430.705) && fZ < 0xA) return true;
    else if((fX >= 2032.885 && fX <= 2114.887 && fY >= 1852.325 && fY <= 1991.575) && fZ < 0xC) return true;
    else if((fX >= 2517.086 && fX <= 2606.897 && fY >= 2316.493 && fY <= 2420.93) && fZ < 0x16) return true;
    else if((fX >= 2554.5996 && fX <= 2507.7683 && fY >= 1548.6178 && fY <= 1588.9154) && fZ < 0xF) return true;
    else if((fX >= -2043.628 && fX <= -1973.561 && fY >= -980.9415 && fY <= -724.0283) && fZ < 0x20) return true;
    else if((fX >= -2753.912 && fX <= -2665.071 && fY >= -522.3632 && fY <= -380.3444) && fZ < 0x05) return true;
    else if((fX >= 1219.864 && fX <= 1292.118 && fY >= -2435.881 && fY <= -2325.344) && fZ < 0xF) return true;
    else if((fX >= 1923.388 && fX <= 2010.854 && fY >= -1223.924 && fY <= -1168.656) && fZ < 0x16) return true;
    else if((fX >= 1269.301 && fX <= 1314.935 && fY >= -837.0452 && fY <= -781.7769) && fZ < 0x5A) return true;
    else if((fX >= 1087.3953 && fX <= 1102.3138 && fY >= -682.6734 && fY <= -663.0043) && fZ < 0x71) return true;
    else if((fX >= 1268.6118 && fX <= 1291.8774 && fY >= -784.2910 && fY <= -764.6104) && fZ < 0x43D) return true;
    else if(fZ < 0xF) return true;
    else return false;
}

static stock IsPlayerUsingParaAnim(playerid) 
{
	if(GetPlayerAnimationIndex(playerid))
	{
	    new animlib[32], animname[32];
	    GetAnimationName(GetPlayerAnimationIndex(playerid), animlib, sizeof(animlib), animname, sizeof(animname));
	    if(!strcmp(animlib, "PARACHUTE", true) && !strcmp(animname, "FALL_SkyDive_Accel", true)) return 1;
	    return 0;
	}
	return 0;
}

public OnVehicleMod(playerid,vehicleid,componentid)
{
    if(GetPlayerInterior(playerid) == 0)
    {
        CallLocalFunction("OnPlayerCheat", "dd", playerid, CHEAT_CODE_VEHMOD);
        return 0; 
    }

    #if defined LAC_OnVehicleMod
        LAC_OnVehicleMod(playerid);
    #endif
    return 1;
}

public OnPlayerUpdate(playerid)
{
    if(IsPlayerUsingParaAnim(playerid))
    {
    	if(GetPlayerWeapon(playerid) != 46) return CallLocalFunction("OnPlayerCheat", "dd", playerid, CHEAT_CODE_FLY);
    }
    if(IsPlayerUsingSwimAnim(playerid))
	{
		if(!IsPlayerInWater(playerid)) CallLocalFunction("OnPlayerCheat", "dd", playerid, CHEAT_CODE_FLY);
	}

	//if(!IsPlayerInWater(playerid)) return 
	new vid = GetPlayerVehicleID(playerid);
    if(vid > 0)
    {
        if(vid != LastVehicleID[playerid])
        {
            if(GetTickCount() - VehicleIDChangeTime[playerid] < 5000)
            {
                VehicleIDChanges[playerid]++;
                if(VehicleIDChanges[playerid] > MAX_VEHICLE_ID_CHANGES)
                {
                    CallLocalFunction("OnPlayerCheat", "dd", playerid, CHEAT_CODE_LAGTROLL);
                    return 0;
                }
            }
            else VehicleIDChanges[playerid] = 1;
        }
        LastVehicleID[playerid] = vid;
        VehicleIDChangeTime[playerid] = GetTickCount();
    }

    #if defined LAC_OnPlayerUpdate
        LAC_OnPlayerUpdate(playerid);
    #endif
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    AutoBulletInfractions[playerid] = 0;
    PlayerConnected[playerid] = false;

    #if defined LAC_OnPlayerDisconnect
        LAC_OnPlayerDisconnect(playerid, reason);
    #endif
    return 1;
}

static stock CheckSpeed(playerid)
{
    new Keys,ud,lr;
    GetPlayerKeys(playerid,Keys,ud,lr);

    if(ud == KEY_UP && lr != KEY_LEFT && lr != KEY_RIGHT)
    {
        new Float:Velocity[3];
        GetPlayerVelocity(playerid, Velocity[0], Velocity[1], Velocity[2]);
        Velocity[0] = floatsqroot( (Velocity[0]*Velocity[0])+(Velocity[1]*Velocity[1])+(Velocity[2]*Velocity[2]));
        if(Velocity[0] >= 0.11 && Velocity[0] <= 0.13) return 1;
    }
    return 0;
}

public OnPlayerCheat(playerid, cheat_code)
{
    if(IsPlayerConnected(playerid))
    {
        new str[128];
        switch(cheat_code)
        {
            case CHEAT_CODE_TELEPORT: format(str, sizeof(str), "{ff8000}* {ffffff}%s[%d] {ff8000}has been kicked by the system (Teleport hack).", userinfo[playerid][pname], playerid);
            case CHEAT_CODE_AUTOC: format(str, sizeof(str),  "{ff8000}* {ffffff}%s[%d] {ff8000}has been kicked by the system (Auto C-Bug).", userinfo[playerid][pname], playerid);
            case CHEAT_CODE_FLY: format(str, sizeof(str),  "{ff8000}* {ffffff}%s[%d] {ff8000}has been kicked by the system (Fly hack).", userinfo[playerid][pname], playerid);
            case CHEAT_CODE_VEHMOD: format(str, sizeof(str),  "{ff8000}* {ffffff}%s[%d] {ff8000}has been kicked by the system (Vehicle mod hack).", userinfo[playerid][pname], playerid);
            case CHEAT_CODE_PROAIM: format(str, sizeof(str),  "{ff8000}* {ffffff}%s[%d] {ff8000}has been kicked by the system (Pro aim).", userinfo[playerid][pname], playerid);
            case CHEAT_CODE_SILENTAIM: format(str, sizeof(str),  "{ff8000}* {ffffff}%s[%d] {ff8000}has been kicked by the system (Silent aim).", userinfo[playerid][pname], playerid);
            case CHEAT_CODE_CJ: format(str, sizeof(str),  "{ff8000}* {ffffff}%s[%d] {ff8000}has been kicked by the system (CJ hack).", userinfo[playerid][pname], playerid);
            case CHEAT_CODE_RAPIDFIRE: format(str, sizeof(str),  "{ff8000}* {ffffff}%s[%d] {ff8000}has been kicked by the system (Rapid fire).", userinfo[playerid][pname], playerid);
            case CHEAT_CODE_TROLL: format(str, sizeof(str),  "{ff8000}* {ffffff}%s[%d] {ff8000}has been kicked by the system (Troll hacks).", userinfo[playerid][pname], playerid);
            case CHEAT_CODE_AUTOBULLET: format(str, sizeof(str),  "{ff8000}* {ffffff}%s[%d] {ff8000}has been kicked by the system (Auto bullet).", userinfo[playerid][pname], playerid);
            case CHEAT_CODE_CONNECTIONSPOOF: format(str, sizeof(str),  "{ff8000}* {ffffff}%s[%d] {ff8000}has been kicked by the system (Connection spoof).", userinfo[playerid][pname], playerid);
            case CHEAT_CODE_LAGTROLL: format(str, sizeof(str),  "{ff8000}* {ffffff}%s[%d] {ff8000}has been kicked by the system (Lag troll).", userinfo[playerid][pname], playerid);
            case CHEAT_CODE_NPCSPOOF: format(str, sizeof(str),  "{ff8000}* {ffffff}%s[%d] {ff8000}has been kicked by the system (NPC spoof).", userinfo[playerid][pname], playerid);
        }
        SendClientMessageToAll_(-1, str);
        //BanPlayer
    }
    return 1;
}

#if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate LAC_OnPlayerUpdate
#if defined LAC_OnPlayerUpdate
    forward LAC_OnPlayerUpdate(playerid);
#endif

#if defined _ALS_OnVehicleMod
    #undef OnVehicleMod
#else
    #define _ALS_OnVehicleMod
#endif
#define OnVehicleMod LAC_OnVehicleMod
#if defined LAC_OnVehicleMod
    forward LAC_OnVehicleMod(playerid,vehicleid,componentid);
#endif

#if defined _ALS_OnPlayerWeaponShot
    #undef OnPlayerWeaponShot
#else
    #define _ALS_OnPlayerWeaponShot
#endif
#define OnPlayerWeaponShot LAC_OnPlayerWeaponShot
#if defined LAC_OnPlayerWeaponShot
    forward LAC_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
#endif

#if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange LAC_OnPlayerKeyStateChange
#if defined LAC_OnPlayerKeyStateChange
    forward LAC_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif

#if defined _ALS_OnPlayerEnterVehicle 
    #undef OnPlayerEnterVehicle
#else
    #define _ALS_OnPlayerEnterVehicle
#endif
#define OnPlayerEnterVehicle LAC_OnPlayerEnterVehicle
#if defined LAC_OnPlayerEnterVehicle
    forward LAC_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
#endif

#if defined _ALS_OnPlayerStateChange    
    #undef OnPlayerStateChange
#else
    #define _ALS_OnPlayerStateChange
#endif
#define OnPlayerStateChange LAC_OnPlayerStateChange
#if defined LAC_OnPlayerStateChange
    forward LAC_OnPlayerStateChange(playerid, newstate, oldstate);
#endif

#if defined _ALS_OnPlayerDisconnect    
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect LAC_OnPlayerDisconnect
#if defined LAC_OnPlayerDisconnect
    forward LAC_OnPlayerDisconnect(playerid, reason);
#endif

#if defined _ALS_OnPlayerConnect    
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect LAC_OnPlayerConnect
#if defined LAC_OnPlayerConnect
    forward LAC_OnPlayerConnect(playerid);
#endif
