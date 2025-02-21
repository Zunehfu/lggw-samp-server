#include <a_samp>
#include <Pawn.CMD>
#include <streamer>
#include <sscanf2>

enum e_data
{
	pid,
	STREAMER_TAG_3D_TEXT_LABEL lid,
	Float:posx,
	Float:posy,
	Float:posz
}

new array[10000][e_data];

public OnFilterScriptInit()
{
	for(new i = 0; i < 10000; i++)
	{
		array[i][pid] = -1;
	}
	return 1;
}

CMD:s(playerid, params[])
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	new str[50], id = -1;
	for(new i = 0; i < 10000; i++){
		if(array[i][pid] == -1){
			id = i;
			break;
		}
	}
	if(id == -1) return SendClientMessage(playerid, -1, "maximum reached!");
	format(str, sizeof(str), "ID: %i", id);
	array[id][pid] = CreateDynamicPickup(19605, 1, x, y, z);
	array[id][lid] = CreateDynamic3DTextLabel(str, -1, x, y, z + 0.5, 50);
	array[id][posx] = x;
	array[id][posy] = y;
	array[id][posz] = z;
	return 1;
}

CMD:exp(playerid, params[])
{
	new str[128];
	if(fexist("array.txt")) fremove("array.txt");
	new File:f = fopen("array.txt", io_append);
	fwrite(f, "new positions[][] =\r\n{");
	for(new i = 0; i < 10000; i++)
	{
		if(array[i][pid] != -1)
		{
			format(str, sizeof(str), "\t{%f, %f, %f},\r\n", array[i][posx], array[i][posy], array[i][posz]);
			fwrite(f, str);
		}
	}
	fwrite(f, "};");
	fclose(f);
	return 1;
}

CMD:rem(playerid, params[])
{
	new id;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, "/rem <id>");
	if(id < 0 || id >= 10000) return SendClientMessage(playerid, -1, "INVALID PICKUP ID");
	if(!IsValidDynamicPickup(array[id][pid])) return SendClientMessage(playerid, -1, "INVALID PICKUP ID");
	DestroyDynamicPickup(array[id][pid]);
	DestroyDynamic3DTextLabel(array[id][lid]);
	array[id][pid] = -1;
	return 1;
}

CMD:go(playerid, params[])
{
	SetPlayerPos(playerid, 1939.0334 + 10,-1115.5330,27.4523);
	GivePlayerWeapon(playerid, 24, 9999);
	return 1;
}

top command


d/dx(ln(kills)) * kills

1/kills * kills

kills + d/dx(ln)

for(new i = 1; i != kills + 1; i++) score += (d/dx(ln(i)) 


 