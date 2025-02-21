#include <a_samp>  
#include <foreach>  
#include <c_textdraw> 
#include <Pawn.CMD>

//--->        __ _______      __  __  _                  
//--->      _/_//_/ ___/___  / /_/ /_(_)___  ____ ______ 
//--->    _/_//_/ \__ \/ _ \/ __/ __/ / __ \/ __ `/ ___/ 
//--->  _/_//_/  ___/ /  __/ /_/ /_/ / / / / /_/ (__  )  
//---> /_//_/   /____/\___/\__/\__/_/_/ /_/\__, /____/   
//--->                                    /____/               

new TD_L_Value[MAX_PLAYERS]; 
new SpeedoTimer[MAX_PLAYERS];
new PlayerText:SpeedoBase[MAX_PLAYERS];
new PlayerText:KMHTEXT[MAX_PLAYERS];
new PlayerText:KMH_Box[MAX_PLAYERS];
new PlayerText:KMH_Speed[MAX_PLAYERS];
new bool:SpeedoDisabled[MAX_PLAYERS]; //toggles if the speedometer should show or not.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
#define UNIT 0 // 1 = MPH  ||  0 = KMH
#define UPDATE_INTERVAL 100 //How often do you want to update the spedometer textdraw circle? In milliseconds  
#define COLOR_EMPTY 0x00000055 //when no speed, which color? (The base color)  
#define COLOR_FILLED 0x33FF3377 //when speed detected, which color whould it be?  
#define SPEED_MULTIPLIER 43 //needs to be increased a bit if you lower the value of "DIFF" below.  
#define POSX 560.0 //Center Position X 
#define POSY 330.0 //Center Position Y 
#define DIAMETER 40.0  //Diameter of the circle 
#define TD_LETTER ")"  //This is the letter the Circle is made of. ".", "," and ")" are the best ones in my opinion. 
#define GROUNDSPEED 0  // 0 Speed in all 3 dimensions are calculated. if set to 1 it only calculates your speed in X and Y axis.
#define DIFF  3.0 // 1.40 is lowest, as 360/1.41 ~ 256. do 360/DIFF in order to see how many TXD's you get. The higher number = less textdraws, read about "DIFF" here:   

public OnFilterScriptInit()  
{  
    print("Circle Textdraw speedo v1.1 by denNorske has been loaded");  
    return 1;  
}  

public OnPlayerConnect(playerid)
{
    LoadSpeedoTextDraws(playerid);
    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)  
{  
    if(newstate == PLAYER_STATE_ONFOOT  && TD_IsCircleCreated(playerid)) //The player was a driver, and now he's on foot.  
    {  
        TD_DestroyCircle(playerid);  
        KillTimer(SpeedoTimer[playerid]);
        HideSpeedometer(playerid);   
    }  
    if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) //Player became a driver in a car, and no textdraws has been created yet 
    {  
        if(!SpeedoDisabled[playerid])
        {
            ShowSpeedometer(playerid);
            if(!TD_IsCircleCreated(playerid))
            {
                TD_CreateCircle(playerid,TD_LETTER, COLOR_EMPTY, POSX, POSY, DIAMETER, DIFF); 
            }
            SpeedoTimer[playerid] = SetTimerEx("UpdateSpeed", UPDATE_INTERVAL, 1, "i", playerid);
        }
    }  
    return 1;  
}  


forward UpdateSpeed(playerid);  
public UpdateSpeed(playerid)  
{  
    if((GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) && TD_IsCircleCreated(playerid))
    {  
        new Float:VelX, Float:VelTotal, Float:VelY, Float:VelZ, value,Float:SpeedoValue, str[25];  
        GetVehicleVelocity(GetPlayerVehicleID(playerid), VelX, VelY, VelZ);  
        #if GROUNDSPEED == 0 
            VelTotal = floatsqroot(floatpower(VelX, 2) + floatpower(VelY, 2)  + floatpower(VelZ, 2)); // 
        #else
            VelTotal = floatsqroot(floatpower(VelX, 2) + floatpower(VelY, 2));
        #endif
        value = floatround(VelTotal*SPEED_MULTIPLIER); //the calc'ed velocity, added with 43 to make it work correctly. can be adjusted--
        SpeedoValue = VelTotal*SPEED_MULTIPLIER; //for the speedometer text

        
        if(!SpeedoDisabled[playerid])
        {
            #if UNIT == 0            
            format(str, sizeof(str), "%d", floatround(floatpower(SpeedoValue*1.6, 1.09)));
            PlayerTextDrawSetString(playerid, KMH_Speed[playerid], str);
            #else
            format(str, sizeof(str), "%d", floatround(floatpower(SpeedoValue, 1.09)));
            PlayerTextDrawSetString(playerid, KMH_Speed[playerid], str);
            #endif
        }


        if(TD_L_Value[playerid] == value) //no need to update anything. Very efficient if car is standing still, or the speed is constant 
            return 1;  

        else if(TD_L_Value[playerid] < value) //higher speed, aka only new green to add  
        {  
            if(value > floatround(360/DIFF, floatround_floor))  
                value = floatround(360/DIFF, floatround_floor); //to avoid crashes. the speed may go higher than amount of textdraws, that's why  
            for(new i = TD_L_Value[playerid]; i< value; i++) //TD_L_Value[playerid] is used here to avoid updating already colored part, and just extend the area..  
            {  
                TD_L_Value[playerid] = value;  
                TD_SetCircleSlotColor(playerid, i, COLOR_FILLED);  
            }  

        }  
        else if(TD_L_Value[playerid] > value)  
        {  
            for(new i = value; i<TD_L_Value[playerid]; i++)  
            {  
                TD_SetCircleSlotColor(playerid, i, COLOR_EMPTY);  
            }  
            TD_L_Value[playerid] = value;  
        }  
    }  
    return 1;  
}  
public OnFilterScriptExit()  
{  
    foreach(new i : Player)  
        TD_DestroyCircle(i);   
    print("Circles Unloaded");  
    return 1;  
}  
public OnPlayerDisconnect(playerid, reason)  
{  
    TD_DestroyCircle(playerid);  
    return 1;  
}  

//////////////////////////////////////////////////////
//              Player
//              Commands
//////////////////////////////////////////////////////

CMD:speedo(playerid, params[])
{
    new str[75];
    if(!SpeedoDisabled[playerid])
    {
        SpeedoDisabled[playerid] = true;
        if(TD_IsCircleCreated(playerid))
        {
            KillTimer(SpeedoTimer[playerid]);
            TD_DestroyCircle(playerid);
            HideSpeedometer(playerid);
        }
    }
    else if(SpeedoDisabled[playerid])
    {
        if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
        {
            if(!TD_IsCircleCreated(playerid))
            {
                TD_CreateCircle(playerid,TD_LETTER, COLOR_EMPTY, POSX, POSY, DIAMETER, DIFF); 
            }
            SpeedoTimer[playerid] = SetTimerEx("UpdateSpeed", UPDATE_INTERVAL, 1, "i", playerid);
            ShowSpeedometer(playerid);
        }
        
        SpeedoDisabled[playerid] = false;

    }
    format(str,sizeof(str), "{008000}>> Speedo << {00FF00}Speedometer is successfully %s", ((SpeedoDisabled[playerid]) ? ("Disabled") : ("Enabled")));
    SendClientMessage(playerid, 0x00FF28FF, str);
    return 1;
}

//////////////////////////////////////////////////////
//              Stocks and
//              Functions
//////////////////////////////////////////////////////
stock LoadSpeedoTextDraws(playerid)
{
    SpeedoBase[playerid] = CreatePlayerTextDraw(playerid, 522.000000, 345.126037 - 70, "LD_POOL:ball");
    PlayerTextDrawLetterSize(playerid, SpeedoBase[playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, SpeedoBase[playerid], 81.750000, 83.792579);
    PlayerTextDrawAlignment(playerid, SpeedoBase[playerid], 1);
    PlayerTextDrawColor(playerid, SpeedoBase[playerid], -1150938795);
    PlayerTextDrawSetShadow(playerid, SpeedoBase[playerid], 0);
    PlayerTextDrawSetOutline(playerid, SpeedoBase[playerid], 0);
    PlayerTextDrawFont(playerid, SpeedoBase[playerid], 4);

    KMHTEXT[playerid] = CreatePlayerTextDraw(playerid, 547.000000, 393.659210 - 70, "KM/H");
    PlayerTextDrawLetterSize(playerid, KMHTEXT[playerid], 0.341250, 2.014814);
    PlayerTextDrawAlignment(playerid, KMHTEXT[playerid], 1);
    PlayerTextDrawColor(playerid, KMHTEXT[playerid], -1);
    PlayerTextDrawSetShadow(playerid, KMHTEXT[playerid], 2);
    PlayerTextDrawSetOutline(playerid, KMHTEXT[playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, KMHTEXT[playerid], 51);
    PlayerTextDrawFont(playerid, KMHTEXT[playerid], 1);
    PlayerTextDrawSetProportional(playerid, KMHTEXT[playerid], 1);

    KMH_Box[playerid] = CreatePlayerTextDraw(playerid, 590.500000, 362.388916 - 70, "usebox");
    PlayerTextDrawLetterSize(playerid, KMH_Box[playerid], 0.000000, 2.033946);
    PlayerTextDrawTextSize(playerid, KMH_Box[playerid], 533.500000, 0.000000);
    PlayerTextDrawAlignment(playerid, KMH_Box[playerid], 1);
    PlayerTextDrawColor(playerid, KMH_Box[playerid], 0);
    PlayerTextDrawUseBox(playerid, KMH_Box[playerid], true);
    PlayerTextDrawBoxColor(playerid, KMH_Box[playerid], 102);
    PlayerTextDrawSetShadow(playerid, KMH_Box[playerid], 0);
    PlayerTextDrawSetOutline(playerid, KMH_Box[playerid], -4);
    PlayerTextDrawBackgroundColor(playerid, KMH_Box[playerid], -2139062017);
    PlayerTextDrawFont(playerid, KMH_Box[playerid], 0);

    KMH_Speed[playerid] = CreatePlayerTextDraw(playerid, 561.500000, 363.792663 - 70, "0");
    PlayerTextDrawLetterSize(playerid, KMH_Speed[playerid], 0.449999, 1.600000);
    PlayerTextDrawAlignment(playerid, KMH_Speed[playerid], 2);
    PlayerTextDrawColor(playerid, KMH_Speed[playerid], 872362973);
    PlayerTextDrawSetShadow(playerid, KMH_Speed[playerid], 0);
    PlayerTextDrawSetOutline(playerid, KMH_Speed[playerid], 1);
    PlayerTextDrawBackgroundColor(playerid, KMH_Speed[playerid], 51);
    PlayerTextDrawFont(playerid, KMH_Speed[playerid], 1);
    PlayerTextDrawSetProportional(playerid, KMH_Speed[playerid], 1);
    return;
}

stock ShowSpeedometer(playerid)
{
    PlayerTextDrawShow(playerid, SpeedoBase[playerid]);
    PlayerTextDrawShow(playerid, KMH_Speed[playerid]);
    PlayerTextDrawShow(playerid, KMH_Box[playerid]);
    PlayerTextDrawShow(playerid, KMHTEXT[playerid]);
    #if UNIT == 0 //KMH
        PlayerTextDrawSetString(playerid, KMHTEXT[playerid], "KM/H");
    #else
        PlayerTextDrawSetString(playerid, KMHTEXT[playerid], "MPH");
    #endif
    return;
}

stock HideSpeedometer(playerid)
{
    PlayerTextDrawHide(playerid, SpeedoBase[playerid]);
    PlayerTextDrawHide(playerid, KMH_Speed[playerid]);
    PlayerTextDrawHide(playerid, KMH_Box[playerid]);
    PlayerTextDrawHide(playerid, KMHTEXT[playerid]);
    return;
}