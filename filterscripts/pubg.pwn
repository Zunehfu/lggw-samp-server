#include <a_samp>
#include <Pawn.CMD>

#define 		COLOR_ERROR							0xFFFFFFFF
#define         COLOR_PUBG 							0xFFFFFFFF
#define  		MIN_PLAYERS_TO_START_PUBG			2

new x[MAX_PLAYERS],
	y[MAX_PLAYERS],
	z[MAX_PLAYERS],
	vw[MAX_PLAYERS],
	int[MAX_PLAYERS],
	weaps[MAX_PLAYERS][2][13], 
	Float:fa[MAX_PLAYERS],
	Float:hp[MAX_PLAYERS],
	Float:ar[MAX_PLAYERS]
;

GetPlayerDetails(playerid) 
{
	GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
	GetPlayerFacingAngle(playerid, fa[playerid]);
	int[playerid] = GetPlayerInterior(playerid);
	vw[playerid] = GetPlayerVirtualWorld(playerid);
	skin[playerid] = GetPlayerSkin(playerid);
	col[playerid] = GetPlayerColor(playerid);
	team[playerid] = GetPlayerTeam(playerid);
	GetPlayerHealth(playerid, hp[playerid]);
	GetPlayerHealth(playerid, ar[playerid]);
	new weapid, weapammo;
	for(new l, j = 0; l < 13; l++)
	{
		GetPlayerWeaponData(playerid, l, weapid, weapammo);
		if(weapid != 0)
		{
			weaps[playerid][0][j] = weapid;
			weaps[playerid][1][j] = weapammo;
			j++;
		}
	}
	return 1;
}

SetPlayerDetails(playerid)
{
	SetPlayerTeam(playerid, team[playerid]);
	SetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);
	SetPlayerInterior(playerid, int[playerid]);
	SetPlayerVirtualWorld(playerid, vw[playerid]);
	SetPlayerFacingAngle(playerid, fa[playerid]);
	SetPlayerHealth(playerid, hp[playerid]);
	SetPlayerArmour(playerid, ar[playerid]);
	SetPlayerColor(playerid, col[playerid]);
	SetPlayerSkin(playerid, skin[playerid]);
	for(new k = 0; k < sizeof(weaps[][]); k++)
	{
		GivePlayerWeapon(playerid, weaps[playerid][0][k], weaps[playerid][1][k]);
	}
	return 1;
}

new g_started;
new g_sync[MAX_PLAYERS];
new g_in[MAX_PLAYERS];
new g_kills[MAX_PLAYERS];
new g_hideme[MAX_PLAYERS];
new g_time[MAX_PLAYERS];

public OnPlayerConnect(playerid)
{
	g_sync[playerid] = 0;
	g_in[playerid] = 0;
	return 1;
}

CMD:spubg(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_ERROR, "You should be an Admin to use this command!");
	if(g_started) return SendClientMessage(playerid, COLOR_ERROR, "Event has already started!");
	g_started = 1;
	SendClientMessageToAll(-1, "PUBG event will be start within 2 mins! type /pubj for sync!!!");
	GameTextForAll("~r~PUBJ ~w~EVENT COUNTDOWN STARTED!~y~!!\n~r~/pubj ~w~to join", 6000, 4);
	g_timer = SetTimer("StartPubG", 1000 * 60 * 2, 1);
	return 1;
}

forward StartPubG();
public StartPubG()
{
	if(g_time != 0)
	{
		new str[50];
		format(str, sizeof(str), "Remaining Time: %i", g_time);
		foreach(new i : Player)
		{
			if(!g_in[i] && g_sync[i])
			{
				GameTextForPlayer(i, "remaining time:_%i", 1000, 3);
			}	
		}
		g_time--;
		return 1;
	}

	new count;
	foreach(new i : Player)
	{
		if(!g_in[i] && g_sync[i])
		{
			count ++;
		}	
	}

	if(count < MIN_PLAYERS_TO_START_PUBG)
	{
		
		g_started = 0;
		SendClientMessageToAll(COLOR_ERROR, "PubG event has cancelled due to lack of players!");
		GameTextForAll("~y~PUBG ~w~Event ~r~cancelled~w~!!!", 1000, 3);
		foreach(new : Player)
		{
			if(!g_in[i] && g_sync[i])
			{
				g_sync[i] = 0;
				g_in[i] = 0;
				SetPlayerDetails(i);
			}	
		}
		return KillTimer(g_timer);
	}
	else 
	{
		SendClientMessageToAll(COLOR_SUCCESS, "PubG evet has started!!!");
		foreach(new : Player)
		{
			GameTextForPlayer(i, "~y~Shoot that anything moves~r~!!~n~~w~:3", 1000, 3);
			if(!g_in[i] && g_sync[i])
			{
				g_in[i] = 1;
				SetPlayerVirtualWorld(i, PUBG_VW);
				//SettingPosition! interior
			}	
		}
		KillTimer(g_timer);
	}
	return 1;
}

CMD:pubg(playerid, params[])
{
	if(!g_started) return SendClientMessage(playerid, COLOR_ERROR, "Event has already started!");
	if(g_sync[playerid]) return SendClientMessage(playerid, COLOR_ERROR, "You have already sync for PUBG event wait a litte...");
	g_sync[playerid] = 1;
	g_in[playerid] = 0;
	g_kills[playerid] = 0;
	GetPlayerDetails(playerid);
	SetPlayerVirtualWorld(playerid, PUBG_VW);
	SetPlayerColor(playerid, COLOR_PUBG);
	SetPlayerTeam(playerid, TEAM_PUBG);
	SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 100);
	//set position of waiting area
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(killerid != INVALID_PLAYER_ID)
	{
		g_kills[killerid] ++;
	}	
	return 1;
}

new g_colval[MAX_PLAYERS];
public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(g_in[playerid])
	{
		g_colval[playerid] = 16;
		foreach(new i : Player) SetPlayerMarkerForPlayer(playerid, i, COLOR_PUBG);
		if(IsValidTimer(g_hideme[playerid])) KillTimer(g_hideme[playerid]);
		g_hideme[playerid] = shoSetTimerEx("HideMe", 200, 1, "i", playerid);
	}
	return 1;
}


Alpha_Col(color, Alpha)
{
	new alpha_col;
	alpha_col = (color - (color & 0x000000FF) + Alpha);
	return alpha_col;
}

forward HideMe(playerid);
public HideMe(playerid)
{	
	g_colval[playerid] --;
	switch(g_colval[playerid])
	{
		case 0: alpha = 00;
		case 1: alpha = 11;
		case 2: alpha = 22;
		case 3: alpha = 33;
		case 4: alpha = 44;
		case 5: alpha = 55;
		case 6: alpha = 66;
		case 7: alpha = 77;
		case 8: alpha = 88;
		case 9: alpha = 99;
		case 10: alpha = AA;
		case 11: alpha = BB;
		case 12: alpha = CC;
		case 13: alpha = DD;
		case 14: alpha = EE;
	}
	foreach(new i : Player) SetPlayerMarkerForPlayer(playerid, i, Alpha_Col(COLOR_PUBG, alpha));
	if(g_colval[playerid] == 0) KillTimer(g_hideme[playerid]);
	return 1;
}
