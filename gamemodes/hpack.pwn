#include <a_samp>
#include <streamer>
#include <Pawn.CMD>

#define 	ATTACKERS 			3
#define     DEFENDERS 			2
#define 	TEAM_ATTACKERS 		22
#define 	TEAM_DEFENDERS 		32
#define  	HPACK_MIN_Z 		88

new inhapck[MAX_PLAYERS];
new hpackstarted;
new hpackstarted2;
new hpackcount;
new dunerider;
new hpackcp;
new duneveh;

stock GetPlayerDetails(playerid)
{
	for(new i = 0; i < 14; i++) GetPlayerWeaponData(playerid, i, wep[playerid][i], ammo[playerid][i]);
	int[playerid] = GetPlayerInterior(playerid);
	vw[playerid] = GetPlayerVirtualWorld(playerid);
	col[playerid] = GetPlayerColor(playerid);
	team[playerid] = GetPlayerTeam(playerid);
	GetPlayerPos(playerid, px[playerid], py[playerid], pz[playerid]);
	GetPlayerFacingAngle(playerid, pang[playerid]);
	GetPlayerHealth(playerid, hp[playerid]);
	GetPlayerArmour(playerid, arm[playerid]);
	return 1;
}

stock SetPlayerDetails(playerid)
{
	for(new i = 0; i < 14; i++) GivePlayerWeapon(playerid, wep[playerid][i], ammo[playerid][i]);
	SetPlayerInterior(playerid, int[playerid]);
	SetPlayerVirtualWorld(playerid, vw[playerid]);
	SetPlayerColor(playerid, col[playerid]);
	SetPlayerTeam(playerid, team[playerid]);
	SetPlayerPos(playerid, px[playerid], py[playerid], pz[playerid]);
	SetPlayerFacingAngle(playerid, pang[playerid]);
	SetPlayerHealth(playerid, hp[playerid]);
	SetPlayerArmour(playerid, arm[playerid]);
	return 1;
}

public OnFilterScriptInit()
{
	hpackcp = CreateDynamicCP(0, 0, 0, 1);
	SetTimer("HuntingPackEx", 500, 1);	
	return 1; 
}

forward HuntingPackEx();
public HuntingPackEx()	
{
	if(hpackstarted2)
	{
		if(inhpack[playerid] && dunerider != playerid)
		{
			if(IsPlayerInAnyVehicle(playerid))
			{
				RepairVehicle(GetPlayerVehicleID(playerid));
			}
		}
	}

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	if(z < HPACK_MIN_Z)
	{
		//setplayerpos (attacker spawn pos)
	}
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	if(hpackstarted2)
	{
		if(vehicleid == duneveh)
		{
			hpackstarted2 = 0;
			hpackstarted = 0;
			DestroyVehicle(vehicleid);
			foreach(new i : Player)
			{
				if(inhpack[i])
				{
					if(i != dunerider) DestroyVehicle(GetPlayerVehicleID(i));

					if(GetPlayerTeam(i) == TEAM_DEFENDERS) GameTextForPlayer(playerid, "You LOST!!!", 5000, 3);
					else GameTextForPlayer(playerid, "Well Done!!!", 5000, 3);
					inhpack[i] = 0;
					SetPlayerDetails(i);
				}
			}
		}
	}
	return 1;
}

public OnPlayerEnterDynamicCP(playerid, STREAMER_TAG_CP checkpointid)
{
	if(checkpointid == hpackcp && hpackstarted2 && inhpack[playerid] && dunerider == playerid)
	{
		hpackstarted2 = 0;
		hpackstarted = 0;
		foreach(new i : Player)
		{
			if(inhpack[i])
			{
				DestroyVehicle(GetPlayerVehicleID(i));

				if(GetPlayerTeam(i) == TEAM_DEFENDERS) GameTextForPlayer(playerid, "Well Done!!!", 5000, 3);
				else GameTextForPlayer(playerid, "You LOST!!!", 5000, 3);
				inhpack[i] = 0;
				SetPlayerDetails(i);
			}
		}
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(hpackstarted2)
	{
		if(inhpack[playerid])
		{
			foreach(new i : Player)
			{
				if(inhpack[i])
				{
					DestroyVehicle(GetPlayerVehicleID(i));
					SetPlayerDetails(i);
					hpack[i] = 0;
					hpackstarted2 = 0;
					hpackstarted = 0; 
				}
			}
		}
	}
	return 1;
}

CMD:starthpack(playerid, params[])
{
	if(hpacksarted) return SendClientMessage(playerid, -1, "[ Error ] Hunting pack event has already started!");
	hpackstarted = 1;
	GameTextForAll("Hunting pack event has started!~n~Use /joinhpack for join", 10000, 3);
	SetTimer("StartHuntingPack", 60 * 1000, 0);
	return 1;
}

forward StartHuntingPack();
public StartHuntingPack()
{
	new count;
	foreach(new i : Player) if(inhpack[i]) count ++;
	if(count < 6)
	{
		foreach(new i : Player) inhpack[i] = 0;
		hpackstarted = 0;
		return GameTextForAll("Hunting pack event~n~cancelled!", 5000, 3);
	}

	hpackstarted2 = 1;
	new attackers;
	new defenders;
	new k;
	foreach(new i : Player)
	{
		if(inhpack[i])
		{
			GetPlayerDetails(i);
			TogglePlayerControllable(playerid, 0);
			k = random(2);
			if(k == 0 && attackers == 3) k = 1;
			if(k == 1 && defenders == 2) k = 0;	
			if(attackers == 3 && defenders == 2) k = 2;
			switch(k)
			{
				case 0:
				{
					SetPlayerTeam(playerid, TEAM_ATTACKERS);
					//setplayer pos
					attackers ++;
				}
				case 1:
				{
					SetPlayerTeam(playerid, TEAM_DEFENDERS);
					//setplayer pos
					defenders ++;
				}
				case 2:
				{
					SetPlayerTeam(playerid, TEAM_DEFENDERS);
					//setplayer pos
					dunerider = i;
					break;
				}
			}
		}
	}

	hcount = 10;
	SetTimer("HuntingPackUnfreeze", 10000, 1);
	return 1;
}

forward HuntingPackUnfreeze();
public HuntingPackUnfreeze()
{
	new str[10];
	format(str, sizeof(str), "%i", hcount);
	foreach(new i : Player)
	{
		if(inhpack[i])
		{
			if(hcount != 0) GameTextForPlayer(playerid, str, 1000, 3);
			else
			{
				GameTextForPlayer(playerid, "GO!!!", 1000, 3);
				TogglePlayerControllable(playerid, 1);
			}
		}
	}
	hcount --;
	return 1;
}

CMD:joinhpack(playerid, params[])
{
	if(!hpackstarted) return SendClientMessage(playerid, -1, "[ Error ] Hunting pack event isn't started!");
	if(hpackstarted2) return SendClientMessage(playerid, -1, "[ Error ] Hunting pack event has already started!");
	new count;
	foreach(new i : Player) if(inhpack[i]) count ++;
	if(count >= 6) return SendClientMessage(playerid, -1, "[ Error ] Only 6 participants can join this event!");
	inhpack[playerid] = 1;
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(hpackstarted2) 
	{
		if(inhpack[playerid])
		{
			ClearAnimations(playerid);
			GameTextForPlayer(playerid, "You cant exit the vehicle~n~in hunting pack", 3000, 3);
		}
	}
	return 1;
}