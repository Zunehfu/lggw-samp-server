/*
	
			+======                                  
			|                                        ||     |        |
			|                         |              ||     |        |  
			+======	 +====  +=====+   |====  =====   ||  ===|===  ===|===
			   	  |	 |	    |     |   |      |   |   ||     |        |
				  |	 |	    |     |   |      |___|   ||     |        |
			======+  |____  |_____|_  |      |____   ||     |__      |__  	v1.0

Scripter - GameOvr
				                
*/			

#include <a_samp>
#include <sscanf2>
#include <YSI\y_iterate>
#include <Pawn.CMD>
#include <timerfix>
#include <FCNPC>
#include <ColAndreas>
#include <a_pathfinder>

#define 			BOT_NAME				"Scarlett"
#define 			BOT_COLOR				0xFFFFFFF
#define             BOT_ATTACK_RANGE        50.0
#define             MIN_DIST 		        10.0
#define             BOT_SKIN  			    141
#define 			MAX_NODE_SIZE 			20


#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))


new g_id;
new p_id; 
new g_vehid;
new Text3D:g_label;

stock GetDistance( Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2 ){    return floatround( floatsqroot( ( ( x1 - x2 ) * ( x1 - x2 ) ) + ( ( y1 - y2 ) * ( y1 - y2 ) ) + ( ( z1 - z2 ) * ( z1 - z2 ) ) )  );}

stock GetClosestPlayerToBot()
{
	new id = INVALID_PLAYER_ID;
	new Float:nx, Float:ny, Float:nz, Float:x, Float:y, Float:z;
	FCNPC_GetPosition(g_id, nx, ny, nz);
	new Float:dist = -1;
	foreach(new i : Player)
	{
        GetPlayerPos(i, x, y, z);
		if(IsPlayerInRangeOfPoint(i, BOT_ATTACK_RANGE, nx, ny, nz) && GetPlayerVirtualWorld(i) == 0 && (dist > GetDistance(x, y, z, nx, ny, nz) || dist == -1))
		{
		    dist = GetDistance(x, y, z, nx, ny, nz);
			id = i;
		}
	}
	return id;
}

stock GetBotPlayerID()
{
	new name[MAX_PLAYER_NAME];
	for(new i = 0; i < MAX_PLAYERS; i ++)
	{
		if(IsPlayerConnected(i))
		{
		    GetPlayerName(i, name,sizeof(name));
		    if(!strcmp(name, BOT_NAME))
			{
				return i;
			}
		}
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	if(!IsPlayerNPC(playerid)) FCNPC_ShowInTabListForPlayer(g_id, playerid);
	return 1;
}

stock GetXYLeftOfPlayer(playerid, &Float:X, &Float:Y, Float:distance)
{
    new Float:Angle;
    GetPlayerFacingAngle(playerid, Angle); Angle += 90.0;
    X += floatmul(floatsin(-Angle, degrees), distance);
    Y += floatmul(floatcos(-Angle, degrees), distance);
}

stock GetXYRightOfPlayer(playerid, &Float:X, &Float:Y, Float:distance)
{
    new Float:Angle;
    GetPlayerFacingAngle(playerid, Angle); Angle -= 90.0;
    X += floatmul(floatsin(-Angle, degrees), distance);
    Y += floatmul(floatcos(-Angle, degrees), distance);
}

new driver;
new timer;

public OnFilterScriptInit()
{
	CA_Init();

	g_id = FCNPC_Create(BOT_NAME);
	FCNPC_SetInvulnerable(g_id, false);

	driver = FCNPC_Create("check");

	p_id = GetBotPlayerID();
	new str[40];
	format(str, sizeof(str), ""#BOT_NAME"(%i)",  p_id);
	g_label = Create3DTextLabel(str , -1, 30.0, 40.0, 50.0, 60.0, -1, 0);
	Attach3DTextLabelToPlayer(g_label, p_id, 0.0, 0.0, 0.4);

	FCNPC_Spawn(g_id, BOT_SKIN, 1939.0334,-1115.5330,27.4523);
	FCNPC_Spawn(driver, 29, 1939.0334,-1115.5330,27.4523);

	AddStaticVehicle(451, 0, 0, 0, 0, 0, 0);
	g_vehid = CreateVehicle(451, 0, 0, 0, 0, 0, 0, -1, 1);
	FCNPC_PutInVehicle(driver, g_vehid, 0);
	FCNPC_PutInVehicle(g_id, g_vehid, 1);

	FCNPC_StartPlayingPlayback(driver, "yas");	
	timer = SetTimer("SetupBot", 1000, 1);
	return 1;
}

public OnFilterScriptExit()
{
	DestroyVehicle(g_vehid);
	FCNPC_Destroy(g_id);
	FCNPC_Destroy(driver);
	KillTimer(timer);
	return 1;
}

stock GetXYInFrontOfPlayer(playerid, &Float:x2, &Float:y2, Float:distance)
{
	new Float:a;
	GetPlayerPos(playerid, x2, y2, a);
	GetPlayerFacingAngle(playerid, a);
	x2 += (distance * floatsin(-a, degrees));
	y2 += (distance * floatcos(-a, degrees));
}

stock GetXYInFrontOfBot(&Float:x2, &Float:y2, Float:distance)
{
	new Float:a;
	FCNPC_GetPosition(g_id, x2, y2, a);
	a = FCNPC_GetAngle(g_id);
	x2 += (distance * floatsin(-a, degrees));
	y2 += (distance * floatcos(-a, degrees));
}


stock GetXYInBackOfBot(&Float:q, &Float:w, Float:distance)//Credits go to MP2
{
    new Float:a;
    FCNPC_GetPosition(g_id, q, w, a);
	a = FCNPC_GetAngle(g_id);
    q += (distance * -floatsin(-a, degrees));
    w += (distance * -floatcos(-a, degrees));
}  

new c_;
new rand;
new removed;
new move;

forward SetupBot();
public SetupBot()
{
	RepairVehicle(g_vehid);
	SendClientMessageToAll(-1, "setupbot");
	if(FCNPC_IsSpawned(g_id))
	{ 
		new Float:nx, Float:ny, Float:nz, Float:x, Float:y, Float:z;
		FCNPC_GetPosition(g_id, nx, ny, nz);

		new id = GetClosestPlayerToBot();

		if(id != INVALID_PLAYER_ID && !FCNPC_IsMoving(g_id) && !FCNPC_IsAimingAtPlayer(g_id, id) && !FCNPC_IsShooting(g_id) && c_ == 0)
		{
			if(FCNPC_GetVehicleID(g_id) != INVALID_VEHICLE_ID && !removed)
			{
				SendClientMessageToAll(-1, "removed from vehicle");
				FCNPC_PausePlayingPlayback(driver);
				removed = 1; 
				return FCNPC_ExitVehicle(g_id);
			} 

			new str[128];
			format(str, sizeof(str), "After Call  c_ - %i", c_);
			SendClientMessageToAll(-1, str);
			GetPlayerPos(id, x, y, z);
			
			if(GetDistance(nx, ny, nz, x, y, z) < MIN_DIST)
			{
				rand = Random(3);
				switch(rand)
				{
				    case 0:
				    {
						GetXYRightOfPlayer(id, x, y, 15);
				        MoveBot(nx, ny, nz, x, y, z);
					}
					case 1:
					{
					
                        GetXYLeftOfPlayer(id, x, y, 15);
                        MoveBot(nx, ny, nz, x, y, z);
					}
					case 2:  
					{
						GetXYInFrontOfPlayer(id, x, y, 15);
						MoveBot(nx, ny, nz, x, y, z);
					}
				}
			}
			else
			{
				rand = Random(8);
				switch(rand)
				{
				    case 0:
				    {
						GetXYRightOfPlayer(id, x, y, 15);
						MoveBot(nx, ny, nz, x, y, z);
					}
					case 1:
					{
					
                        GetXYLeftOfPlayer(id, x, y, 15);
                        MoveBot(nx, ny, nz, x, y, z);
					}
					case 2:
					{
					    FCNPC_SetWeapon(g_id, 24);
						FCNPC_SetAmmo(g_id, 9999);
						FCNPC_SetWeaponShootTime(g_id, 24, 250);
						FCNPC_ApplyAnimation(g_id,"ped","WALK_civi",4.1,0,0,0,0);
				    	FCNPC_AimAtPlayer(g_id, id, true, 0);
						SetTimer("PressC", 200, 0);
					}
					case 3:
					{
					    FCNPC_SetWeapon(g_id, 24);
						FCNPC_SetAmmo(g_id, 9999);
						FCNPC_SetWeaponShootTime(g_id, 24, 250);
						FCNPC_ApplyAnimation(g_id,"ped","WALK_civi",4.1,0,0,0,0);
				    	FCNPC_AimAtPlayer(g_id, id, true, 0);
						SetTimer("PressC", 200, 0);
					}
					case 4:
					{
					    FCNPC_SetWeapon(g_id, 24);
						FCNPC_SetAmmo(g_id, 9999);
						FCNPC_SetWeaponShootTime(g_id, 24, 250);
						FCNPC_ApplyAnimation(g_id,"ped","WALK_civi",4.1,0,0,0,0);
				    	FCNPC_AimAtPlayer(g_id, id, true, 0);
						SetTimer("PressC", 200, 0);
					}
					case 5:
					{
					    FCNPC_SetWeapon(g_id, 24);
						FCNPC_SetAmmo(g_id, 9999);
						FCNPC_SetWeaponShootTime(g_id, 24, 250);
						FCNPC_ApplyAnimation(g_id,"ped","WALK_civi",4.1,0,0,0,0);
				    	FCNPC_AimAtPlayer(g_id, id, true, 0);
						SetTimer("PressC", 200, 0);
					}
					case 6:
					{
					    FCNPC_SetWeapon(g_id, 24);
						FCNPC_SetAmmo(g_id, 9999);
						FCNPC_SetWeaponShootTime(g_id, 24, 250);
						FCNPC_ApplyAnimation(g_id,"ped","WALK_civi",4.1,0,0,0,0);
				    	FCNPC_AimAtPlayer(g_id, id, true, 0);
						SetTimer("PressC", 200, 0);
					}
					case 7:
					{
					    FCNPC_SetWeapon(g_id, 24);
						FCNPC_SetAmmo(g_id, 9999);
						FCNPC_SetWeaponShootTime(g_id, 24, 250);
						FCNPC_ApplyAnimation(g_id,"ped","WALK_civi",4.1,0,0,0,0);
				    	FCNPC_AimAtPlayer(g_id, id, true, 0);
						SetTimer("PressC", 200, 0);
					}
				}  
			}
		}
		else if(id == INVALID_PLAYER_ID)
		{
			if(FCNPC_GetVehicleID(g_id) == INVALID_VEHICLE_ID && !move)
			{
			 	FCNPC_EnterVehicle(g_id, g_vehid, 1, FCNPC_MOVE_TYPE_WALK);
			 	SendClientMessageToAll(-1, "INVALID_PLAYER and not moving called!");
			 	move = 1;
			}
		}
	}
	return 1; 
}

public FCNPC_OnVehicleEntryComplete(npcid, vehicleid, seatid)
{
	if(npcid == g_id)
	{	
		removed = 0;
		move = 0;
		FCNPC_ResumePlayingPlayback(driver);
	}
	return 1;
}


new rand1;
forward PressC();
public PressC()
{
	FCNPC_ApplyAnimation(g_id,"ped","WALK_civi",4.1,0,0,0,0);
	FCNPC_ApplyAnimation(g_id,"ped","Crouch_Roll_L",4.1,0,0,0,0);
	rand1 = random(4);
	switch(rand1)
	{
		case 0:
		{
			if(c_ >= 2)
			{
				c_ = 0;
				return FCNPC_StopAim(g_id);
			}
		}
		case 1:
		{
			if(c_ >= 3)
			{
				c_ = 0;
				return FCNPC_StopAim(g_id);
			}
		}
		case 2:
		{
			if(c_ >= 4)
			{
				c_ = 0;
				return FCNPC_StopAim(g_id);
			}
		}
		case 3:
		{
			if(c_ >= 5)
			{
				c_ = 0;
				return FCNPC_StopAim(g_id);
			}
		}
	}
	SetTimer("PressC", 250, 0);
	c_ ++;
	return 1;
}

public FCNPC_OnDeath(npcid, killerid, reason)
{
	FCNPC_Respawn(g_id);
	return 1;
}

public FCNPC_OnSpawn(npcid)
{ 
	FCNPC_SetPosition(g_id, 1939.0334,-1115.5330,27.4523);
    FCNPC_SetWeapon(g_id, 24);
    FCNPC_SetAmmo(g_id, 9999);
    return 1;
}

CMD:go(playerid, params[])
{
	SetPlayerPos(playerid, 1939.0334 + 10,-1115.5330,27.4523);
	GivePlayerWeapon(playerid, 24, 9999);
	return 1;
}

new yo[MAX_PLAYERS];
new adminveh[MAX_PLAYERS] = {INVALID_VEHICLE_ID, ...};

CMD:veh(playerid, params[])
{
	new car, color1, color2; 
	new Float:X, Float:Y, Float:Z;
	new Float:fa;
	GetPlayerFacingAngle(playerid, fa);
	GetPlayerPos(playerid, X, Y, Z);
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
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_YES))  
	{
		GivePlayerWeapon(playerid, 34, 9999);
		yo[playerid] = 0;
	}
	if(PRESSED(KEY_NO)) yo[playerid] = 1;
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{ 
	if(playerid != g_id && yo[playerid] == 1){
		SetPlayerHealth(playerid, 100);
	}
	return 1;
}

public FCNPC_OnFinishPlayback(npcid)
{
	if(driver == npcid)
	{
		FCNPC_StartPlayingPlayback(driver, "yas");
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(vehicleid == g_vehid) 
	{
		PlayerPlaySound(playerid,1190,0.0,0.0,0.0);
		ClearAnimations(playerid);
		GameTextForPlayer(playerid, "~r~This is ~g~"#BOT_NAME"~r~'s~n~vehicle", 2000, 3);
	}
	return 1;
}

stock MoveBot(Float:sx, Float:sy, Float:sz, Float:ex, Float:ey, Float:ez)
{
	new nodes[MAX_NODE_SIZE], str[128];
	CY_FindPath(sx, sy, sz, ex, ey, ez, nodes);
	new path = FCNPC_CreateMovePath();
	for(new i = 0; i < MAX_NODE_SIZE; i++)
	{
		CY_GetNodePosition(nodes[i], sx, sy, sz); 
		format(str, sizeof(str), "x: %f | y: %f | z: %f", sx, sy, sz);
		SendClientMessageToAll(-1, str);
		FCNPC_AddPointToMovePath(path, sx, sy, sz);
	}
	FCNPC_GoByMovePath(g_id, path, 0, FCNPC_MOVE_TYPE_SPRINT, FCNPC_MOVE_SPEED_SPRINT);
	FCNPC_DestroyMovePath(path);
	return 
}