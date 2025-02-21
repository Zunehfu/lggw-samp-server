#include <a_samp>
#include <Pawn.CMD>
#include <3DTryg>

new done;
new obj;

new last_shift;

public OnFilterScriptInit()
{
    obj = CreateObject(362, 2502.01489, -1677.79150, 12.91030,   -84.00000, 360.00000, -324.00000);
	return 1;
}

public OnFilterScriptExit()
{
	DestroyObject(obj);
	return 1;
}

CMD:lolz(playerid, params[])
{
	done = 1;
	ApplyAnimation(playerid, "ped", "IDLE_stance", 4.1, 1, 0, 0, 1, 0, 1);
	return 1;
}

CMD:oc(playerid, params[])
{
	new 
		Float:x1, Float:y1, Float:z1
	;
	obj = CreateObject(362, x1, y1, 12.91030,   -84.00000, 360.00000, -324.00000);
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(done)
	{
		new 
			Float:x1, Float:y1, Float:z1,
		    Float:rx, Float:ry, Float:rz
		;

		GetObjectRot(obj, rx, ry, rz);
		GetObjectPos(obj, x1, y1, z1);

		GetPlayerCameraRotation(playerid, rx, rz); 

		switch(last_shift)
		{
			case 0:
			{
				last_shift = 1;
				MoveObject(obj, x1, y1, z1 + 0.001, 0.008, rx, ry, rz);
			}
			case 1:
			{
				last_shift = 0;
				MoveObject(obj, x1, y1, z1 - 0.001, 0.008, rx, ry, rz);
			}
		}
	}
	return 1;
}


