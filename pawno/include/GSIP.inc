/*
	GetServerIP
	by wups		*/
#include <a_samp>
#include <a_http>

new _P_SERVERIP[20];
stock GetServerIP() return _P_SERVERIP;
#if defined FILTERSCRIPT
	public OnFilterScriptInit()
	{
		HTTP(0,HTTP_GET,"whatismyip.org/","","OnServerGetIP");
		return (funcidx("GSIP_OnFilterScriptInit") != -1)?CallLocalFunction("GSIP_OnFilterScriptInit",""):1;	
	}
	#if defined _ALS_OnFilterScriptInit
		#undef OnFilterScriptInit
	#else
		#define _ALS_OnFilterScriptInit
	#endif
	#define OnFilterScriptInit GSIP_OnFilterScriptInit
	forward GSIP_OnFilterScriptInit();
#else
	public OnGameModeInit()
	{
		HTTP(0,HTTP_GET,"whatismyip.org/","","OnServerGetIP");
		return (funcidx("GSIP_OnGameModeInit") != -1)?CallLocalFunction("GSIP_OnGameModeInit",""):1;
	}
	#if defined _ALS_OnGameModeInit
		#undef OnGameModeInit
	#else
		#define _ALS_OnGameModeInit
	#endif
	#define OnGameModeInit GSIP_OnGameModeInit
	forward GSIP_OnGameModeInit();
#endif
forward OnServerGetIP(index, response_code, data[]);
public OnServerGetIP(index, response_code, data[])
{	
	if(response_code == 200)
	{
		strmid(_P_SERVERIP,data,0,20,20);
		printf("GSIP: Server IP is %s",_P_SERVERIP);
	}
	return 1;
}