/*                              
| 2020.05.19 | 

        +===========  ========
        |             |
        |             |              |     |
        |     +====+  |=======       | *   |            
        |     ||   |  |         =====| |  ===   ------ |===
        |          |  |         |    | |   |    |    | |   
        +==========+  |=======  |====| |   |___ |____| |    v1.0            
            
                        All in one sophisticated Map Editor! 

_______ Credits _______
GameOvr - Scripter
h02 - Fly mode base code
[uL]Pottus - texture viewer base code
______________________

- GEditor.inc 
- GEditor.pwn
*/

#include <a_samp> 

#if !defined IsValidVehicle
    native IsValidVehicle(vehicleid);
#endif

#if defined MAX_PLAYERS
    #undef MAX_PLAYERS
#endif

#define MAX_PLAYERS 100

#include <sscanf2>
#include <GEditor>

#define STREAMER_OBJECT_SD      400
#define STREAMER_OBJECT_DD      400

#include <streamer>

#define STREAMER_OBJECT_SD      400
#define STREAMER_OBJECT_DD      400

#include <3dmenu>
#include <Pawn.CMD>

#define  DINI_MAX_FIELDS   	1000 // MAX_VEH + MAX_ACT + (16 * MAX_OBJ) + 6

#include <Dini2>
#include <foreach>
#include <strlib>
#include <PreviewModelDialog>


/* GEditor Defines*/
#define 	   MAP_SAVE_PATH				            "/GEditor/Saves/%s.ini"
#define 	   MAP_EXPORT_PATH					        "/GEditor/Exports/%s.txt"
#define 	   MAP_EDITOR_CONF_PATH				        "/GEditor/GEditor_Data.ini"

#define 	   MAX_OBJ		    						500   //Maximum number of objects that can be created in a map
#define 	   MAX_ACT		    						10   //Maximum number of actors that can be created in a map
#define        MAX_VEH                                  10   //Maximum number of Vehicles that can be created in a map
#define        MAX_LOADABLE_MAPS_IN_SERVER				10   //Maximum number of maps that can be loaded in the server  - > (MAX_PLAYERS * MAX_LOADABLE_MAPS_AT_ONCE)
#define  	   MAX_LOADABLE_MAPS_AT_ONCE	 			5 	  //Maximum number of maps that can be loaded by a player
#define 	   LABEL_DRAW_DISTANCE						50    //Draw distance of labels
#define   	   MAX_MAPS_THAT_CAN_BE_CREATED_BY_A_USER	10    //Maximum number of maps that can be created by a user
#define        MAX_CREATABLE_MAPS_IN_SERVER             50
#define        MAX_INDEX                                16
#define        MAX_MATTEXT_SIZE                         24
#define        RESPAWN_DELAY                            120

#define 	   COL_BLUE 						        "{0E5FAF}"
#define 	   COL_RED            				        "{FF0000}"
#define        COL_GREY        					        "{979797}"
#define 	   COL_YELLOW						        "{D2AC00}"
#define        COL_GREEN                                "{00FF00}"
#define        COL_WHITE                                "{FFFFFF}"

#define        DIALOG_CMDS                               291
#define        DIALOG_CLOSE_DIALOG                       292               
#define        DIALOG_EDIT_MAP                           293            
#define        DIALOG_MAPS                               294                
#define        DIALOG_CLOSE                              295      
#define        DIALOG_MODEL_SEARCH                       296                
#define        DIALOG_OBJECT_SEARCH                      297       
#define        DIALOG_MAP_PASS                           298 
#define        DIALOG_MAP_DELETE                         299 
#define        DIALOG_MAP_INFO                           300        
#define        DIALOG_MANAGE_MAP                         301 
#define        DIALOG_MAP_NAME                           302 
#define        DIALOG_CMDS2                              303
#define        DIALOG_CMDS3                              304

//Fly Editor defines
#define         MOVE_SPEED                100.0
#define         ACCEL_RATE                0.03

#define         CAMERA_MODE_NONE          0
#define         CAMERA_MODE_FLY           1

#define         MOVE_FORWARD              1 
#define         MOVE_BACK                 2 
#define         MOVE_LEFT                 3 
#define         MOVE_RIGHT                4 
#define         MOVE_FORWARD_LEFT         5 
#define         MOVE_FORWARD_RIGHT        6 
#define         MOVE_BACK_LEFT            7 
#define         MOVE_BACK_RIGHT           8 

//Texture viewver
#define         PREVIEW_STATE_NONE              0
#define         PREVIEW_STATE_ALLTEXTURES       1

#define         DEFAULT_TEXTURE                 1000

alias:cm("createmap");
alias:lm("loadmap");  
alias:vlm("visualloadmap"); 
alias:vulm("visualunloadmap"); 
alias:md("mapdelete");
alias:mr("maprename");
alias:mpass("mappassword");
alias:oc("objectcreate");
alias:oe("objectedit");
alias:od("objedtdelete");
alias:op("objectposition");
alias:oclone("objectclone");

/* ========================================================================
                  DO NOT CHANGE ANYTHING FROM HERE 
   If you need something to be changed contact the scripter
                  DISCORD ID     =>     GameOvr#9363  
   ======================================================================== */

#define PRESSED(%0) \
    (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define RELEASED(%0) \
    (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#define HOLDING(%0) \
    ((newkeys & (%0)) == (%0))

/* GEditor Variables & Constants */
enum Menu_Info
{
    TPreviewState,
    CurrTextureIndex,
    Menus3D,
    PlayerText:Menu3D_Model_Info,
}
new MENU3D_DATA[MAX_PLAYERS][Menu_Info];

enum EditorInfo
{
	T_Maps,
	M_Loaded
}
new EDITOR_INFO[EditorInfo];

enum CopyBuf 
{
    mapid,
    objid
}
new COPY_BUF[MAX_PLAYERS][CopyBuf];

enum ObjectInfo
{
	STREAMER_TAG_OBJECT O_ID,
	STREAMER_TAG_3D_TEXT_LABEL O_LID,
	O_MODEL_ID,
	Float:O_PosX,
	Float:O_PosY,
	Float:O_PosZ,
	Float:O_RotX,
	Float:O_RotY,
	Float:O_RotZ,
    move,
    Float:ospeed,
    Float:movex,
    Float:movey,
    Float:movez
}
new OBJ_INFO[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][ObjectInfo];

new 
    Mat_ID[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_INDEX],
    Mat_USED[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_INDEX],
    Mat_TUSED[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_INDEX],
    Mat_TCOL[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_INDEX],
    Mat_TBACKCOL[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_INDEX],
    Mat_TSIZE[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_INDEX],
    Mat_TFONT[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_INDEX],
    Mat_TMSIZE[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_INDEX],
    Mat_TALIGN[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_INDEX],
    Mat_TBOLD[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_INDEX],
    Mat_TEXT0[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_MATTEXT_SIZE],
    Mat_TEXT1[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_MATTEXT_SIZE],
    Mat_TEXT2[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_MATTEXT_SIZE],
    Mat_TEXT3[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_MATTEXT_SIZE],
    Mat_TEXT4[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_MATTEXT_SIZE],
    Mat_TEXT5[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_MATTEXT_SIZE],
    Mat_TEXT6[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_MATTEXT_SIZE],
    Mat_TEXT7[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_MATTEXT_SIZE],
    Mat_TEXT8[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_MATTEXT_SIZE],
    Mat_TEXT9[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_MATTEXT_SIZE],
    Mat_TEXT10[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_MATTEXT_SIZE],
    Mat_TEXT11[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_MATTEXT_SIZE],
    Mat_TEXT12[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_MATTEXT_SIZE],
    Mat_TEXT13[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_MATTEXT_SIZE],
    Mat_TEXT14[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_MATTEXT_SIZE],
    Mat_TEXT15[MAX_LOADABLE_MAPS_IN_SERVER][MAX_OBJ][MAX_MATTEXT_SIZE]
;

enum VehicleInfo
{
    V_ID,
    STREAMER_TAG_3D_TEXT_LABEL V_LID,
    V_MODEL_ID,
    Float:V_PosX,
    Float:V_PosY,
    Float:V_PosZ,
    Float:V_Ang,
    V_Color1,
    V_Color2
}
new VEH_INFO[MAX_LOADABLE_MAPS_IN_SERVER][MAX_VEH][VehicleInfo];

enum PlayerInfo
{
	mLoaded,
	cur_svr_mid,
	cur_player_mid,
	cur_obj,
	editing,  
	labeled,
	cur_act,
    fly,
    cameramode,
    flyobject,
    mode,
    lrold,
    udold,
    lastmove,
    Float:accelmul,
    Float:pos[3],
    Float:angl
}

new PLAYER_INFO[MAX_PLAYERS][PlayerInfo];
new PLAYER_mName[MAX_PLAYERS][MAX_LOADABLE_MAPS_AT_ONCE][20];

enum MapInfo
{
	M_Name[20],
	total_obj,
	total_actors,
    total_vehicles,
    forview
}
new MAP_INFO[MAX_LOADABLE_MAPS_IN_SERVER][MapInfo];

enum ActorInfo
{
    A_ID,
	A_SKIN,
    A_LID,
	Float:A_PosX,
	Float:A_PosY,
	Float:A_PosZ,
	Float:A_Ang,
    animused,
    animid
}	
new ACT_INFO[MAX_LOADABLE_MAPS_IN_SERVER][MAX_ACT][ActorInfo];

new Fonts[][] = //If you are adding new fonts, add them from bottom!
{
    "Arial",
    "Aharoni",
    "Aldhabi",
    "Bahnschrift",
    "Calibri",
    "Calisto MT",
    "Cambria",
    "Cambria Math",
    "Candara",
    "Century Gothic",
    "Comic Sans MS",
    "Consolas",
    "Constantia",
    "Copperplate Gothic Bold",
    "Corbel",
    "Courier New",
    "David",
    "Dotum",
    "Euphemia",
    "Georgia",
    "Gill Sans Nova",
    "Impact",
    "Lucida Console",
    "News Gothic MT",
    "Palatino Linotype",
    "Rockwell Nova",
    "Times New Roman",
    "Tahoma",
    "Trebuchet MS",
    "Verdana"
};

new mDialog[MAX_PLAYERS][MAX_MAPS_THAT_CAN_BE_CREATED_BY_A_USER][20];
new cur_map[MAX_PLAYERS][20];

new fsearch[MAX_PLAYERS];
new nowf[MAX_PLAYERS];
new fob[MAX_PLAYERS];
new PlayerText:fonttd[MAX_PLAYERS];

/* GEditor Functions*/
InitText3DDraw(playerid)
{
    MENU3D_DATA[playerid][Menu3D_Model_Info] = CreatePlayerTextDraw(playerid,630.000000, 400.000000, "Model: TXD: Texture:");
    PlayerTextDrawAlignment(playerid,MENU3D_DATA[playerid][Menu3D_Model_Info], 3);
    PlayerTextDrawBackgroundColor(playerid,MENU3D_DATA[playerid][Menu3D_Model_Info], 255);
    PlayerTextDrawFont(playerid,MENU3D_DATA[playerid][Menu3D_Model_Info], 2);
    PlayerTextDrawLetterSize(playerid,MENU3D_DATA[playerid][Menu3D_Model_Info], 0.300000, 1.000000);
    PlayerTextDrawColor(playerid,MENU3D_DATA[playerid][Menu3D_Model_Info], 16711935);
    PlayerTextDrawSetOutline(playerid,MENU3D_DATA[playerid][Menu3D_Model_Info], 1);
    PlayerTextDrawSetProportional(playerid,MENU3D_DATA[playerid][Menu3D_Model_Info], 1);
    PlayerTextDrawSetSelectable(playerid,MENU3D_DATA[playerid][Menu3D_Model_Info], 0);
    return 1;
}

frename(oldname[], newname[])
{
	if(!fexist(oldname)) return print("[ frename ] Something is wrong! An unavailable file called for file rename");
	new str[128], line[256];
	new File:oFile = fopen(oldname, io_read);
	new File:nFile = fopen(newname, io_append);
	while(fread(oFile, line))
	{
		format(str, sizeof(str), "%s", line);
		fwrite(nFile, str);
	}
	fclose(oFile);
	fclose(nFile);
	fremove(oldname);
	return 1;
}

GetVehicleSlotID2(vehicleid, &mid, &vid)
{
    mid = -1;
    for(new i = 0; i < MAX_LOADABLE_MAPS_IN_SERVER; i++)
    {
        for(new j = 0; j < MAX_VEH; j++)
        {
            if(VEH_INFO[i][j][V_ID] == vehicleid)
            {
                vid = j;
                mid = i;
                break;
            }
        }
        if(mid != -1) break;
    }
}

GetVehicleRelativePos(vehicleid, &Float:x, &Float:y, &Float:z, Float:xoff=0.0, Float:yoff=0.0, Float:zoff=0.0)
{
    new Float:rot;
    GetVehicleZAngle(vehicleid, rot);
    rot = 360 - rot;    
    GetVehiclePos(vehicleid, x, y, z);
    x = floatsin(rot,degrees) * yoff + floatcos(rot,degrees) * xoff + x;
    y = floatcos(rot,degrees) * yoff - floatsin(rot,degrees) * xoff + y;
    z = zoff + z;
}

GetLastVehicleSlot(mapid_)
{
    for(new i = 0; i < MAX_VEH; i++)
    {
        if(!IsValidVehicle(VEH_INFO[mapid_][i][V_ID])) return i;
    }
    return -1;
}

GetVehicleSlotID(mapid_, vehicleid)
{
    for(new i = 0; i < MAX_VEH; i++)
    {
        if(VEH_INFO[mapid_][i][V_ID] == vehicleid && IsValidVehicle(VEH_INFO[mapid_][i][V_ID])) return i;
    }
    return -1;
}

PlayerName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

IsIDEValid(input)
{
	switch(input)
	{
		case 615..661: return true;
		case 664: return true;
		case 669..698: return true;
		case 700..792: return true;
		case 800..906: return true;
		case 910..964: return true;
		case 966..998: return true;
		case 1000..1193: return true;
		case 1207..1325: return true;
		case 1327..1572: return true;
		case 1574..1698: return true;
		case 1700..2882: return true;
		case 2885..3135: return true;
		case 3167..3175: return true;
		case 3178: return true;
		case 3187: return true;
		case 3193: return true;
		case 3214: return true;
		case 3221: return true;
		case 3241..3244: return true;
		case 3246: return true;
		case 3249..3250: return true;
		case 3252..3253: return true;
		case 3255..3265: return true;
		case 3267..3347: return true;
		case 3350..3415: return true;
		case 3417..3428: return true;
		case 3430..3609: return true;
		case 3612..3783: return true;
		case 3785..3869: return true;
		case 3872..3882: return true;
		case 3884..3888: return true;
		case 3890..3973: return true;
		case 3975..4541: return true;
		case 4550..4762: return true;
		case 4806..5084: return true;
		case 5086..5089: return true;
		case 5105..5375: return true;
		case 5390..5682: return true;
		case 5703..6010: return true;
		case 6035..6253: return true;
		case 6255..6257: return true;
		case 6280..6347: return true;
		case 6349..6525: return true;
		case 6863..7392: return true;
		case 7415..7973: return true;
		case 7978..9193: return true;
		case 9205..9267: return true;
		case 9269..9478: return true;
		case 9482..10310: return true;
		case 10315..10744: return true;
		case 10750..11417: return true;
		case 11420..11753: return true;
		case 12800..13563: return true;
		case 13590..13667: return true;
		case 13672..13890: return true;
		case 14383..14528: return true;
		case 14530..14554: return true;
		case 14556: return true;
		case 14558..14643: return true;
		case 14650..14657: return true;
		case 14660..14695: return true;
		case 14699..14728: return true;
		case 14735..14765: return true;
		case 14770..14856: return true;
		case 14858..14883: return true;
		case 14885..14898: return true;
		case 14900..14903: return true;
		case 15025..15064: return true;
		case 16000..16790: return true;
		case 17000..17474: return true;
		case 17500..17974: return true;
		case 17976: return true;
		case 17978: return true;
		case 18000..18036: return true;
		case 18038..18102: return true;
		case 18104..18105: return true;
		case 18109: return true;
		case 18112: return true;
		case 18200..18859: return true;
		case 18862..19198: return true;
		case 19200..19274: return true;
		case 19277..19595: return true;
		case 19597..19999: return true;
	}
	return false;
}

CancelDynamicEdit(playerid)
{
    CallLocalFunction("OnPlayerEditDynamicObject", "iiiffffff", playerid, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID], EDIT_RESPONSE_CANCEL, 0, 0, 0, 0, 0, 0);
    CancelEdit(playerid);
    return 1;
}

GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance) // credits -> Y-Less 
{
    new Float:a;

    GetPlayerPos(playerid, x, y, a);
    GetPlayerFacingAngle(playerid, a);

    if (GetPlayerVehicleID(playerid)) {
        GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    }

    x += (distance * floatsin(-a, degrees));
    y += (distance * floatcos(-a, degrees));
}

GetMoveDirectionFromKeys(ud, lr)
{
    new direction = 0;
    
    if(lr < 0)
    {
        if(ud < 0)      direction = MOVE_FORWARD_LEFT;  
        else if(ud > 0) direction = MOVE_BACK_LEFT;     
        else            direction = MOVE_LEFT;   
    }
    else if(lr > 0)     
    {
        if(ud < 0)      direction = MOVE_FORWARD_RIGHT;  
        else if(ud > 0) direction = MOVE_BACK_RIGHT;     
        else            direction = MOVE_RIGHT;          
    }
    else if(ud < 0)     direction = MOVE_FORWARD;   
    else if(ud > 0)     direction = MOVE_BACK;      
    
    return direction;
}

MoveCamera(playerid)
{
    new Float:FV[3], Float:CP[3];
    GetPlayerCameraPos(playerid, CP[0], CP[1], CP[2]);     
    GetPlayerCameraFrontVector(playerid, FV[0], FV[1], FV[2]);  

    if(PLAYER_INFO[playerid][accelmul] <= 1) PLAYER_INFO[playerid][accelmul] += ACCEL_RATE;

    new Float:speed = MOVE_SPEED * PLAYER_INFO[playerid][accelmul];

    new Float:X, Float:Y, Float:Z;
    GetNextCameraPosition(PLAYER_INFO[playerid][mode], CP, FV, X, Y, Z);
    MovePlayerObject(playerid, PLAYER_INFO[playerid][flyobject], X, Y, Z, speed);

    PLAYER_INFO[playerid][lastmove] = GetTickCount();
    return 1;
}


GetNextCameraPosition(move_mode, Float:CP[3], Float:FV[3], &Float:X, &Float:Y, &Float:Z)
{
    #define OFFSET_X (FV[0]*6000.0)
    #define OFFSET_Y (FV[1]*6000.0)
    #define OFFSET_Z (FV[2]*6000.0)
    switch(move_mode)
    {
        case MOVE_FORWARD:
        {
            X = CP[0]+OFFSET_X;
            Y = CP[1]+OFFSET_Y;
            Z = CP[2]+OFFSET_Z;
        }
        case MOVE_BACK:
        {
            X = CP[0]-OFFSET_X;
            Y = CP[1]-OFFSET_Y;
            Z = CP[2]-OFFSET_Z;
        }
        case MOVE_LEFT:
        {
            X = CP[0]-OFFSET_Y;
            Y = CP[1]+OFFSET_X;
            Z = CP[2];
        }
        case MOVE_RIGHT:
        {
            X = CP[0]+OFFSET_Y;
            Y = CP[1]-OFFSET_X;
            Z = CP[2];
        }
        case MOVE_BACK_LEFT:
        {
            X = CP[0]+(-OFFSET_X - OFFSET_Y);
            Y = CP[1]+(-OFFSET_Y + OFFSET_X);
            Z = CP[2]-OFFSET_Z;
        }
        case MOVE_BACK_RIGHT:
        {
            X = CP[0]+(-OFFSET_X + OFFSET_Y);
            Y = CP[1]+(-OFFSET_Y - OFFSET_X);
            Z = CP[2]-OFFSET_Z;
        }
        case MOVE_FORWARD_LEFT:
        {
            X = CP[0]+(OFFSET_X  - OFFSET_Y);
            Y = CP[1]+(OFFSET_Y  + OFFSET_X);
            Z = CP[2]+OFFSET_Z;
        }
        case MOVE_FORWARD_RIGHT:
        {
            X = CP[0]+(OFFSET_X  + OFFSET_Y);
            Y = CP[1]+(OFFSET_Y  - OFFSET_X);
            Z = CP[2]+OFFSET_Z;
        }
    }
}

CancelFlyMode(playerid)
{
    TogglePlayerSpectating(playerid, false);

    DestroyPlayerObject(playerid, PLAYER_INFO[playerid][flyobject]);
    PLAYER_INFO[playerid][cameramode] = CAMERA_MODE_NONE;
    SetTimerEx("SetPos", 100, 0, "i", playerid);
    CancelDynamicEdit(playerid);
    return 1;
}

FlyMode(playerid)
{
    PLAYER_INFO[playerid][fly] = 1;

    new Float:X, Float:Y, Float:Z;
    GetPlayerPos(playerid, X, Y, Z);
    PLAYER_INFO[playerid][flyobject] = CreatePlayerObject(playerid, 19300, X, Y, Z, 0.0, 0.0, 0.0);

    TogglePlayerSpectating(playerid, true);

    AttachCameraToPlayerObject(playerid, PLAYER_INFO[playerid][flyobject]);

    PLAYER_INFO[playerid][cameramode] = CAMERA_MODE_FLY;
    GetPlayerPos(playerid, PLAYER_INFO[playerid][pos][0], PLAYER_INFO[playerid][pos][1], PLAYER_INFO[playerid][pos][2]);
    GetPlayerFacingAngle(playerid, PLAYER_INFO[playerid][angl]);
    return 1;
}

Float:GetDistance(Float:x1,Float:y1,Float:z1, Float:x2,Float:y2,Float:z2)
{
    return floatsqroot(floatpower(floatabs(floatsub(x2, x1)), 2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}

UpdateTextureInfo(playerid, boxid)
{
    if(MENU3D_DATA[playerid][TPreviewState] == PREVIEW_STATE_ALLTEXTURES)
    {
        new line[128];
        format(line, sizeof(line), "~n~~n~Material_ID:_%i~n~~r~Index:_%i/%i", boxid+MENU3D_DATA[playerid][CurrTextureIndex], MENU3D_DATA[playerid][CurrTextureIndex]+boxid, MAX_TEXTURES - 1);

        PlayerTextDrawSetString(playerid, MENU3D_DATA[playerid][Menu3D_Model_Info], line);
    }
    return 1;
}

SetMatTextInIndex(mapid_, objid_, index, text[])
{
    switch(index)
    {
        case 0: format(Mat_TEXT0[mapid_][objid_], MAX_MATTEXT_SIZE, "%s", text);  
        case 1: format(Mat_TEXT1[mapid_][objid_], MAX_MATTEXT_SIZE, "%s", text);  
        case 2: format(Mat_TEXT2[mapid_][objid_], MAX_MATTEXT_SIZE, "%s", text);  
        case 3: format(Mat_TEXT3[mapid_][objid_], MAX_MATTEXT_SIZE, "%s", text);  
        case 4: format(Mat_TEXT4[mapid_][objid_], MAX_MATTEXT_SIZE, "%s", text);  
        case 5: format(Mat_TEXT5[mapid_][objid_], MAX_MATTEXT_SIZE, "%s", text);  
        case 6: format(Mat_TEXT6[mapid_][objid_], MAX_MATTEXT_SIZE, "%s", text);  
        case 7: format(Mat_TEXT7[mapid_][objid_], MAX_MATTEXT_SIZE, "%s", text);  
        case 8: format(Mat_TEXT8[mapid_][objid_], MAX_MATTEXT_SIZE, "%s", text);  
        case 9: format(Mat_TEXT9[mapid_][objid_], MAX_MATTEXT_SIZE, "%s", text);  
        case 10: format(Mat_TEXT10[mapid_][objid_], MAX_MATTEXT_SIZE, "%s", text);  
        case 11: format(Mat_TEXT11[mapid_][objid_], MAX_MATTEXT_SIZE, "%s", text);  
        case 12: format(Mat_TEXT12[mapid_][objid_], MAX_MATTEXT_SIZE, "%s", text);  
        case 13: format(Mat_TEXT13[mapid_][objid_], MAX_MATTEXT_SIZE, "%s", text);  
        case 14: format(Mat_TEXT14[mapid_][objid_], MAX_MATTEXT_SIZE, "%s", text);  
        case 15: format(Mat_TEXT15[mapid_][objid_], MAX_MATTEXT_SIZE, "%s", text);  
    }
    return 1;
}

GetMatTextInIndex(mapid_, objid_, index)
{
    switch(index)
    {
        case 0: return Mat_TEXT0[mapid_][objid_];  
        case 1: return Mat_TEXT1[mapid_][objid_];  
        case 2: return Mat_TEXT2[mapid_][objid_];  
        case 3: return Mat_TEXT3[mapid_][objid_];  
        case 4: return Mat_TEXT4[mapid_][objid_];  
        case 5: return Mat_TEXT5[mapid_][objid_];  
        case 6: return Mat_TEXT6[mapid_][objid_];  
        case 7: return Mat_TEXT7[mapid_][objid_];  
        case 8: return Mat_TEXT8[mapid_][objid_];  
        case 9: return Mat_TEXT9[mapid_][objid_];  
        case 10: return Mat_TEXT10[mapid_][objid_];  
        case 11: return Mat_TEXT11[mapid_][objid_];  
        case 12: return Mat_TEXT12[mapid_][objid_];  
        case 13: return Mat_TEXT13[mapid_][objid_];  
        case 14: return Mat_TEXT14[mapid_][objid_];  
        case 15: return Mat_TEXT15[mapid_][objid_];  
    }
    return Mat_TEXT0[mapid_][objid_];
}

IsMatTextUsedInIndex(mapid_, objid_, indx)
{
    printf("mattext used %i", Mat_TUSED[mapid_][objid_][indx]);
    printf("str %s", GetMatTextInIndex(mapid_, objid_, indx));
    if(!Mat_TUSED[mapid_][objid_][indx]) return 0;
    if(isequal("``````````", GetMatTextInIndex(mapid_, objid_, indx))) return 0;
    if(isequal("-1", GetMatTextInIndex(mapid_, objid_, indx))) return 0;
    return 1;
}

SaveMapData()
{
    new id__;
    new str[128], str_[128], info[256];
	foreach(new i : Player)
	{
		if(PLAYER_INFO[i][mLoaded] > 0)
		{
			for(new k = 0; k < MAX_LOADABLE_MAPS_AT_ONCE; k ++)
			{
				if(!isequal(PLAYER_mName[i][k], "-1"))
				{
					id__ = GetServerMapID(PLAYER_mName[i][k]);
					format(str, sizeof(str), MAP_SAVE_PATH, PLAYER_mName[i][k]);
					dini_IntSet(str, "Total_Objects", MAP_INFO[i][total_obj]);
					dini_IntSet(str, "Total_Actors", MAP_INFO[i][total_actors]);
                    dini_IntSet(str, "Total_Vehicles", MAP_INFO[i][total_vehicles]);
					for(new j = 0; j < MAX_OBJ; j++)
					{			
						format(str_, sizeof(str_), "%i_Object_Info", j);
						if(IsValidDynamicObject(OBJ_INFO[id__][j][O_ID]))
						{
							format(info, sizeof(info), "%i %f %f %f %f %f %f %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %f %f %f %f", 
                            OBJ_INFO[id__][j][O_MODEL_ID], 
                            OBJ_INFO[id__][j][O_PosX], 
                            OBJ_INFO[id__][j][O_PosY], 
                            OBJ_INFO[id__][j][O_PosZ], 
                            OBJ_INFO[id__][j][O_RotX], 
                            OBJ_INFO[id__][j][O_RotY], 
                            OBJ_INFO[id__][j][O_RotZ],
                            Mat_USED[id__][j][0], Mat_ID[id__][j][0],
                            Mat_USED[id__][j][1], Mat_ID[id__][j][1],
                            Mat_USED[id__][j][2], Mat_ID[id__][j][2],
                            Mat_USED[id__][j][3], Mat_ID[id__][j][3],
                            Mat_USED[id__][j][4], Mat_ID[id__][j][4],
                            Mat_USED[id__][j][5], Mat_ID[id__][j][5],
                            Mat_USED[id__][j][6], Mat_ID[id__][j][6],
                            Mat_USED[id__][j][7], Mat_ID[id__][j][7],
                            Mat_USED[id__][j][8], Mat_ID[id__][j][8],
                            Mat_USED[id__][j][9], Mat_ID[id__][j][9],
                            Mat_USED[id__][j][10], Mat_ID[id__][j][10],
                            Mat_USED[id__][j][11], Mat_ID[id__][j][11],
                            Mat_USED[id__][j][12], Mat_ID[id__][j][12],
                            Mat_USED[id__][j][13], Mat_ID[id__][j][13],
                            Mat_USED[id__][j][14], Mat_ID[id__][j][14],
                            Mat_USED[id__][j][15], Mat_ID[id__][j][15],
                            OBJ_INFO[id__][j][move], 
                            OBJ_INFO[id__][j][movex],
                            OBJ_INFO[id__][j][movey],
                            OBJ_INFO[id__][j][movez],
                            OBJ_INFO[id__][j][ospeed]
                            );
							dini_Set(str, str_, info);

                            for(new l = 0; l < MAX_INDEX; l++)
                            {
                                format(str_, sizeof(str_), "%i_%i_MaterialText_Info", j, l);
                                if(Mat_TUSED[id__][j][l]){
                                    format(info, sizeof(info), "%s %i %i %i %i %i %i %i", GetMatTextInIndex(id__, j, l), Mat_TMSIZE[id__][j][l], Mat_TFONT[id__][j][l], Mat_TSIZE[id__][j][l], Mat_TBOLD[id__][j][l], Mat_TCOL[id__][j][l], Mat_TBACKCOL[id__][j][l], Mat_TALIGN[id__][j][l]);
                                    dini_Set(str, str_, info);
                                }
                                else{
                                    if(dini_Isset(str, str_))
                                    {
                                        dini_Unset(str, str_);
                                    }
                                }
                            }
						}
						else 
						{
							if(dini_Isset(str, str_))
							{
								dini_Unset(str, str_);
                                for(new l = 0; l < MAX_INDEX; l++)
                                {
                                    format(str_, sizeof(str_), "%i_%i_MaterialText_Info", j, l);
                                    if(dini_Isset(str, str_))
                                    {
                                        dini_Unset(str, str_);
                                    }
                                }
							}
						}
					}
					for(new j = 0; j < MAX_ACT; j++)
					{			
						format(str_, sizeof(str_), "%i_Actor_Info", j);
						if(IsValidDynamicActor(ACT_INFO[id__][j][A_ID]))
						{
							format(info, sizeof(info), "%i %f %f %f %f %i %i", ACT_INFO[id__][j][A_SKIN], ACT_INFO[id__][j][A_PosX], ACT_INFO[id__][j][A_PosY], ACT_INFO[id__][j][A_PosZ], ACT_INFO[id__][j][A_Ang], ACT_INFO[id__][j][animused], ACT_INFO[id__][j][animid]);
							dini_Set(str, str_, info);
						}
						else 
						{
							if(dini_Isset(str, str_))
							{
								dini_Unset(str, str_);
							}
						}
					}
                    for(new j = 0; j < MAX_VEH; j++)
                    {           
                        format(str_, sizeof(str_), "%i_Vehicle_Info", j);
                        if(IsValidVehicle(VEH_INFO[id__][j][V_ID]))
                        {
                            format(info, sizeof(info), "%i %f %f %f %f %i %i", VEH_INFO[id__][j][V_MODEL_ID], VEH_INFO[id__][j][V_PosX], VEH_INFO[id__][j][V_PosY], VEH_INFO[id__][j][V_PosZ], VEH_INFO[id__][j][V_Ang], VEH_INFO[id__][j][V_Color1], VEH_INFO[id__][j][V_Color2]);
                            dini_Set(str, str_, info);
                        }
                        else 
                        {
                            if(dini_Isset(str, str_))
                            {
                                dini_Unset(str, str_);
                            }
                        }
                    }
				}
			}
		} 
	}
	dini_IntSet(MAP_EDITOR_CONF_PATH, "Total_Maps", EDITOR_INFO[T_Maps]);
	return 1;
}

GetServerMapID(mname[])
{
	for(new i = 0; i < MAX_LOADABLE_MAPS_IN_SERVER; i ++)
	{
		if(isequal(MAP_INFO[i][M_Name], mname)) return i;
	}
	print("|GEditor| ID for the given map name not found! (Function : GetServerMapID(mname[]))");
	return 1;
}

GetPlayerMapID(playerid, mname[])
{
	for(new j = 0; j < MAX_LOADABLE_MAPS_AT_ONCE; j ++)
	{
		if(isequal(PLAYER_mName[playerid][j], mname)) return j;
	}
	print("|GEditor| ID for the given map name not found! (Function : GetPlayerMapID(playerid, mname[]))");
	return 1;
}

IsValidMapName(const mname[]) 
{ 
	for(new i, j = strlen(mname); i != j; i++) 
	{ 
		switch (mname[i]) 
		{ 
			case  '0' .. '9', 'a' .. 'z': continue; 
			case ' ': continue;
			default: return 0; 
		} 
	} 
	return 1; 
}  

/* GEditor Publics */
public OnFilterScriptInit()
{
	if(dini_Exists(MAP_EDITOR_CONF_PATH))
	{
		EDITOR_INFO[T_Maps] = dini_Int(MAP_EDITOR_CONF_PATH, "Total_Maps");
	}
	else
	{
		dini_Create(MAP_EDITOR_CONF_PATH);
		dini_IntSet(MAP_EDITOR_CONF_PATH, "Total_Maps", 0);
	    EDITOR_INFO[T_Maps] = 0;
	}
	for(new i = 0; i < MAX_LOADABLE_MAPS_IN_SERVER; i++)
	{
		format(MAP_INFO[i][M_Name], 20, "%s", "-1");
		MAP_INFO[i][total_obj] = 0;
		MAP_INFO[i][total_actors] = 0;
		for(new j = 0; j < MAX_OBJ; j ++)
		{
			OBJ_INFO[i][j][O_ID] = -1;
			OBJ_INFO[i][j][O_MODEL_ID] = -1;
			OBJ_INFO[i][j][O_PosX] = -1;
			OBJ_INFO[i][j][O_PosY] = -1;
			OBJ_INFO[i][j][O_PosZ] = -1;
			OBJ_INFO[i][j][O_RotX] = -1;
			OBJ_INFO[i][j][O_RotY] = -1;
			OBJ_INFO[i][j][O_RotZ] = -1;
            for(new k = 0; k < MAX_INDEX; k++)
            {
                Mat_USED[i][j][k] = 0;
                Mat_TUSED[i][j][k] = 0;
                Mat_TBOLD[i][j][k] = 1;
                Mat_TSIZE[i][j][k] = 24;
                Mat_TCOL[i][j][k] = 0xFFFFFFFF;
                Mat_TBACKCOL[i][j][k] = 0;
                SetMatTextInIndex(i, j, k, "-1");
            }
		}

		for(new j = 0; j < MAX_ACT; j ++)
		{
			ACT_INFO[i][j][A_ID] = -1;
			ACT_INFO[i][j][A_SKIN] = -1;
			ACT_INFO[i][j][A_PosX] = -1;
			ACT_INFO[i][j][A_PosY] = -1;
			ACT_INFO[i][j][A_PosZ] = -1;
			ACT_INFO[i][j][A_Ang] = -1;
		}

        for(new j = 0; j < MAX_VEH; j ++)
        {
            VEH_INFO[i][j][V_ID] = -1;
            VEH_INFO[i][j][V_MODEL_ID] = -1;
            VEH_INFO[i][j][V_PosX] = -1;
            VEH_INFO[i][j][V_PosY] = -1;
            VEH_INFO[i][j][V_PosZ] = -1;
            VEH_INFO[i][j][V_Ang] = -1;
        }
	}

	for(new i = 0 ; i < MAX_PLAYERS; i++)
	{
		for(new k = 0; k < MAX_LOADABLE_MAPS_AT_ONCE; k++)
		{
			format(PLAYER_mName[i][k], 20, "%s", "-1");
			PLAYER_INFO[i][cur_svr_mid] = -1;
			PLAYER_INFO[i][cur_player_mid] = -1;
			PLAYER_INFO[i][mLoaded] = 0;
			PLAYER_INFO[i][cur_obj] = -1;
			PLAYER_INFO[i][cur_act] = -1;
			PLAYER_INFO[i][editing] = 0;
			PLAYER_INFO[i][labeled] = 0;
		}

        if(IsPlayerConnected(i)) InitText3DDraw(i);
	}

	SetTimer("SaveMappings",  1000 * 60, 1);
    print("\n\n\n|=======================================\n");
    print("| 'GEditor' by GameOvr Loaded!\n");
    print("|---------------------------------------------\n");
    printf("|'%i' objects succesfully synced!\n", sizeof(MODEL_NAMES));
    printf("|'%i' textures succesfully synced!\n", MAX_TEXTURES);
    printf("|'%i' animations succesfully synced!\n", sizeof(AnimationData));
    print("|---------------------------------------------\n");
    print("|=============================================\n\n\n");
	return 1;
}

forward SaveMappings();
public SaveMappings()
{
	SaveMapData();

	print("|GEditor| Maps have been automatically saved for safety");
	return 1;
}

public OnFilterScriptExit()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(PLAYER_INFO[i][cameramode] == CAMERA_MODE_FLY) CancelFlyMode(i);
        if(IsPlayerConnected(i))
        {
            if(MENU3D_DATA[i][TPreviewState] == PREVIEW_STATE_ALLTEXTURES)
            {
                CancelSelect3DMenu(i);
                Destroy3DMenu(MENU3D_DATA[i][Menus3D]);
                MENU3D_DATA[i][TPreviewState] = PREVIEW_STATE_NONE;
                PlayerTextDrawHide(i, MENU3D_DATA[i][Menu3D_Model_Info]);
            }

            PlayerTextDrawDestroy(i, fonttd[i]);

            if(fsearch[i]) DestroyPlayerObject(i, fob[i]);
        }
    }

	SaveMapData();

    for(new i = 0; i < MAX_LOADABLE_MAPS_IN_SERVER; i++)
    {
        for(new j = 0; j < MAX_VEH; j++)
        {
            if(IsValidVehicle(VEH_INFO[i][j][V_ID]))
            {
                DestroyVehicle(VEH_INFO[i][j][V_ID]);
            }
        }
    }

	print("\n--------------------------------------");
    print("GEditor by GameOvr Unoaded!");
    print("--------------------------------------\n");
	return 1;
}

public OnPlayerSpawn(playerid)
{
    if(PLAYER_INFO[playerid][fly] == 1) 
    {
        SetPlayerPos(playerid, PLAYER_INFO[playerid][pos][0], PLAYER_INFO[playerid][pos][1], PLAYER_INFO[playerid][pos][2]);
        SetPlayerFacingAngle(playerid, PLAYER_INFO[playerid][angl]);
        PLAYER_INFO[playerid][fly] = 0;
    }
    SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor| "#COL_GREY"Use "#COL_YELLOW"/gcmds "#COL_GREY"to view "#COL_GREEN"GEditor "#COL_GREY"commands");
    return 1;
}

public OnVehicleSpawn(vehicleid)
{
    new mid, id;
    GetVehicleSlotID2(vehicleid, mid, id);
    if(mid != -1)
    {
        SetVehiclePos(vehicleid,
            VEH_INFO[mid][id][V_PosX], 
            VEH_INFO[mid][id][V_PosY],
            VEH_INFO[mid][id][V_PosZ]);
        SetVehicleZAngle(vehicleid, VEH_INFO[mid][id][V_Ang]);
    }
    return 1;
}

public OnPlayerUpdate(playerid)
{
    if(PLAYER_INFO[playerid][cameramode] == CAMERA_MODE_FLY)
    {
        new keys,ud,lr;
        GetPlayerKeys(playerid,keys,ud,lr);

        if(PLAYER_INFO[playerid][mode] && (GetTickCount() - PLAYER_INFO[playerid][lastmove] > 100))
        {
            MoveCamera(playerid);
        }

        if(PLAYER_INFO[playerid][udold] != ud || PLAYER_INFO[playerid][lrold] != lr)
        {
            if((PLAYER_INFO[playerid][udold] != 0 || PLAYER_INFO[playerid][lrold] != 0) && ud == 0 && lr == 0)
            {   
                StopPlayerObject(playerid, PLAYER_INFO[playerid][flyobject]);
                PLAYER_INFO[playerid][mode]      = 0;
                PLAYER_INFO[playerid][accelmul]  = 0.0;
            }
            else
            {   
                PLAYER_INFO[playerid][mode] = GetMoveDirectionFromKeys(ud, lr);
                MoveCamera(playerid);
            }
        }
        PLAYER_INFO[playerid][udold] = ud; 
        PLAYER_INFO[playerid][lrold] = lr; 
        return 0;
    }
    return 1;
}

public OnPlayerConnect(playerid)
{
    PLAYER_INFO[playerid][cameramode]   = CAMERA_MODE_NONE;
    PLAYER_INFO[playerid][lrold]        = 0;
    PLAYER_INFO[playerid][udold]        = 0;
    PLAYER_INFO[playerid][mode]         = 0;
    PLAYER_INFO[playerid][lastmove]     = 0;
    PLAYER_INFO[playerid][accelmul]     = 0.0;
    PLAYER_INFO[playerid][fly]          = 0;
    fsearch[playerid] = 0;
    InitText3DDraw(playerid);

    fonttd[playerid] = CreatePlayerTextDraw(playerid, 549.000000, 328.000000, "Font_ID:_1");
    PlayerTextDrawFont(playerid, fonttd[playerid], 2);
    PlayerTextDrawLetterSize(playerid, fonttd[playerid], 0.383332, 1.600000);
    PlayerTextDrawTextSize(playerid, fonttd[playerid], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, fonttd[playerid], 1);
    PlayerTextDrawSetShadow(playerid, fonttd[playerid], 0);
    PlayerTextDrawAlignment(playerid, fonttd[playerid], 3);
    PlayerTextDrawColor(playerid, fonttd[playerid], 16711935);
    PlayerTextDrawBackgroundColor(playerid, fonttd[playerid], 255);
    PlayerTextDrawBoxColor(playerid, fonttd[playerid], 50);
    PlayerTextDrawUseBox(playerid, fonttd[playerid], 0);
    PlayerTextDrawSetProportional(playerid, fonttd[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, fonttd[playerid], 0);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(PLAYER_INFO[playerid][mLoaded] > 0)
	{
		if(PLAYER_INFO[playerid][labeled] == 1 && PLAYER_INFO[playerid][cur_svr_mid] != -1)
		{
			for(new i = 0; i <	MAX_OBJ; i++)
			{
				if(IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID]))
				{
					if(IsValidDynamic3DTextLabel(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID]))
					{
						DestroyDynamic3DTextLabel(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID]);
					}
				}
			}
			for(new i = 0; i < MAX_ACT; i++)
			{
				if(IsValidDynamicActor(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_ID]))
				{
					if(IsValidDynamic3DTextLabel(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_LID]))
					{
						DestroyDynamic3DTextLabel(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_LID]);
					}
				}
			}
		}

		for(new k = 0; k < MAX_LOADABLE_MAPS_AT_ONCE; k++)
		{
			if(!isequal(PLAYER_mName[playerid][k],"-1"))
			{
				new str[128], str_[128], info[256];
				format(str, sizeof(str), MAP_SAVE_PATH, PLAYER_mName[playerid][k]);
				new id_ = GetServerMapID(PLAYER_mName[playerid][k]);
				format(PLAYER_mName[playerid][k], 20, "%s", "-1");
				dini_IntSet(str, "Total_Objects", MAP_INFO[id_][total_obj]);
				dini_IntSet(str, "Total_Actors", MAP_INFO[id_][total_actors]);
                dini_IntSet(str, "Total_Vehicles", MAP_INFO[id_][total_vehicles]);
				for(new j = 0; j < MAX_OBJ; j++)
				{
					format(str_, sizeof(str_), "%i_Object_Info", j);
					if(IsValidDynamicObject(OBJ_INFO[id_][j][O_ID]))
					{
						format(info, sizeof(info), "%i %f %f %f %f %f %f %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %f %f %f %f", 
                        OBJ_INFO[id_][j][O_MODEL_ID], OBJ_INFO[id_][j][O_PosX], OBJ_INFO[id_][j][O_PosY], OBJ_INFO[id_][j][O_PosZ], OBJ_INFO[id_][j][O_RotX], OBJ_INFO[id_][j][O_RotY], OBJ_INFO[id_][j][O_RotZ],
                        Mat_USED[id_][j][0], Mat_ID[id_][j][0],
                        Mat_USED[id_][j][1], Mat_ID[id_][j][1],
                        Mat_USED[id_][j][2], Mat_ID[id_][j][2],
                        Mat_USED[id_][j][3], Mat_ID[id_][j][3],
                        Mat_USED[id_][j][4], Mat_ID[id_][j][4],
                        Mat_USED[id_][j][5], Mat_ID[id_][j][5],
                        Mat_USED[id_][j][6], Mat_ID[id_][j][6],
                        Mat_USED[id_][j][7], Mat_ID[id_][j][7],
                        Mat_USED[id_][j][8], Mat_ID[id_][j][8],
                        Mat_USED[id_][j][9], Mat_ID[id_][j][9],
                        Mat_USED[id_][j][10], Mat_ID[id_][j][10],
                        Mat_USED[id_][j][11], Mat_ID[id_][j][11],
                        Mat_USED[id_][j][12], Mat_ID[id_][j][12],
                        Mat_USED[id_][j][13], Mat_ID[id_][j][13],
                        Mat_USED[id_][j][14], Mat_ID[id_][j][14],
                        Mat_USED[id_][j][15], Mat_ID[id_][j][15],
                        OBJ_INFO[id_][j][move], 
                        OBJ_INFO[id_][j][movex],
                        OBJ_INFO[id_][j][movey],
                        OBJ_INFO[id_][j][movez],
                        OBJ_INFO[id_][j][ospeed]
                        );
                        dini_Set(str, str_, info);
                       
                        for(new l = 0; l < MAX_INDEX; l++)
                        {
                            format(str_, sizeof(str_), "%i_%i_MaterialText_Info", j, l);
                            if(Mat_TUSED[id_][j][l]){
                                format(info, sizeof(info), "%s %i %i %i %i %i %i %i", GetMatTextInIndex(id_, j, l), Mat_TMSIZE[id_][j][l], Mat_TFONT[id_][j][l], Mat_TSIZE[id_][j][l], Mat_TBOLD[id_][j][l], Mat_TCOL[id_][j][l], Mat_TBACKCOL[id_][j][l], Mat_TALIGN[id_][j][k]);
                                dini_Set(str, str_, info);
                            }
                            else{
                                if(dini_Isset(str, str_))
                                {
                                    dini_Unset(str, str_);
                                }
                            }
                        }

						DestroyDynamicObject(OBJ_INFO[id_][j][O_ID]);

						OBJ_INFO[id_][j][O_ID] = -1;
						OBJ_INFO[id_][j][O_MODEL_ID] = -1;
						OBJ_INFO[id_][j][O_PosX] = -1;
						OBJ_INFO[id_][j][O_PosY] = -1;
						OBJ_INFO[id_][j][O_PosZ] = -1;
						OBJ_INFO[id_][j][O_RotX] = -1;
						OBJ_INFO[id_][j][O_RotY] = -1;
						OBJ_INFO[id_][j][O_RotZ] = -1;
                        for(new l = 0; l < MAX_INDEX; l++)
                        {
                            Mat_USED[id_][j][l] = 0;
                            Mat_TUSED[id_][j][l] = 0;
                            Mat_TBOLD[id_][j][l] = 1;
                            Mat_TSIZE[id_][j][l] = 24;
                            Mat_TCOL[id_][j][l] = 0xFFFFFFFF;
                            Mat_TBACKCOL[id_][j][l] = 0;
                            SetMatTextInIndex(id_, j, l, "-1");
                        }
					}
					else
					{
						if(dini_Isset(str, str_))
						{
							dini_Unset(str, str_);
                            for(new l = 0; l < MAX_INDEX; l++)
                            {
                                format(str_, sizeof(str_), "%i_%i_MaterialText_Info", j, l);
                                if(dini_Isset(str, str_))
                                {
                                    dini_Unset(str, str_);
                                }
                            }
						}
					}
				} 
				for(new j = 0; j < MAX_ACT; j++)
				{
					format(str_, sizeof(str_), "%i_Actor_Info", j);
					if(IsValidDynamicActor(ACT_INFO[id_][j][A_ID]))
					{
						format(info, sizeof(info), "%i %f %f %f %f %i %i", ACT_INFO[id_][j][A_SKIN], ACT_INFO[id_][j][A_PosX], ACT_INFO[id_][j][A_PosY], ACT_INFO[id_][j][A_PosZ], ACT_INFO[id_][j][A_Ang], ACT_INFO[id_][j][animused], ACT_INFO[id_][j][animid]);
						dini_Set(str, str_, info);

						DestroyDynamicActor(ACT_INFO[id_][j][A_ID]);

						ACT_INFO[id_][j][A_ID] = -1;
						ACT_INFO[id_][j][A_SKIN] = -1;
						ACT_INFO[id_][j][A_PosX] = -1;
						ACT_INFO[id_][j][A_PosY] = -1;
						ACT_INFO[id_][j][A_PosZ] = -1;
						ACT_INFO[id_][j][A_Ang] = -1;
					}
					else
					{
						if(dini_Isset(str, str_))
						{
							dini_Unset(str, str_);
						}
					}
				} 
                for(new j = 0; j < MAX_VEH; j++)
                {
                    format(str_, sizeof(str_), "%i_Vehicle_Info", j);
                    if(IsValidVehicle(VEH_INFO[id_][j][V_ID]))
                    {
                        format(info, sizeof(info), "%i %f %f %f %f %i %i", VEH_INFO[id_][j][V_MODEL_ID], VEH_INFO[id_][j][V_PosX], VEH_INFO[id_][j][V_PosY], VEH_INFO[id_][j][V_PosZ], VEH_INFO[id_][j][V_Ang], VEH_INFO[id_][j][V_Color1], VEH_INFO[id_][j][V_Color2]);
                        dini_Set(str, str_, info);

                        DestroyVehicle(VEH_INFO[id_][j][V_ID]);

                        VEH_INFO[id_][j][V_ID] = -1;
                        VEH_INFO[id_][j][V_MODEL_ID] = -1;
                        VEH_INFO[id_][j][V_PosX] = -1;
                        VEH_INFO[id_][j][V_PosY] = -1;
                        VEH_INFO[id_][j][V_PosZ] = -1;
                        VEH_INFO[id_][j][V_Ang] = -1;
                    }
                    else
                    {
                        if(dini_Isset(str, str_))
                        {
                            dini_Unset(str, str_);
                        }
                    }
                } 
				format(MAP_INFO[id_][M_Name], 20, "%s", "-1");
				MAP_INFO[id_][total_obj] = 0;
				MAP_INFO[id_][total_actors] = 0;
                MAP_INFO[id_][total_vehicles] = 0;
			}
		}
	}

    MENU3D_DATA[playerid][TPreviewState] = PREVIEW_STATE_NONE;
    CancelSelect3DMenu(playerid);
    
    if(MENU3D_DATA[playerid][Menus3D] != INVALID_3DMENU)
    {
        Destroy3DMenu(MENU3D_DATA[playerid][Menus3D]);
        MENU3D_DATA[playerid][Menus3D] = INVALID_3DMENU;
    }

    if(fsearch[playerid]) DestroyPlayerObject(playerid, fob[playerid]);

    PlayerTextDrawDestroy(playerid, fonttd[playerid]);

	PLAYER_INFO[playerid][mLoaded] = 0;
	PLAYER_INFO[playerid][cur_svr_mid] = -1;
	PLAYER_INFO[playerid][cur_player_mid] = -1;
	PLAYER_INFO[playerid][cur_obj] = -1;
	PLAYER_INFO[playerid][cur_act] = -1;
	PLAYER_INFO[playerid][editing] = 0;
	PLAYER_INFO[playerid][labeled] = 0;
	return 1;
}

forward OnPlayerKeyStateChangeMenu(playerid, newkeys, oldkeys);
public OnPlayerKeyStateChangeMenu(playerid, newkeys, oldkeys)
{
    if(MENU3D_DATA[playerid][TPreviewState] == PREVIEW_STATE_ALLTEXTURES)
    {
        if(newkeys & KEY_ANALOG_RIGHT)
        {
            MENU3D_DATA[playerid][CurrTextureIndex] += 16;
            if(MENU3D_DATA[playerid][CurrTextureIndex] >= MAX_TEXTURES - 1) MENU3D_DATA[playerid][CurrTextureIndex] = 1;
            if(MAX_TEXTURES - 1 - MENU3D_DATA[playerid][CurrTextureIndex] - 16 < 0) MENU3D_DATA[playerid][CurrTextureIndex] = MAX_TEXTURES - 16 - 1;
            for(new i = 0; i < 16; i++)
            {
               if(i+MENU3D_DATA[playerid][CurrTextureIndex] >= MAX_TEXTURES - 1) continue;
               SetBoxMaterial(MENU3D_DATA[playerid][Menus3D],i,0,ObjectTextures[i+MENU3D_DATA[playerid][CurrTextureIndex]][TModel],ObjectTextures[i+MENU3D_DATA[playerid][CurrTextureIndex]][TXDName],ObjectTextures[i+MENU3D_DATA[playerid][CurrTextureIndex]][TextureName], 0, 0xFF999999);
            }

            UpdateTextureInfo(playerid, SelectedBox[playerid]);
        }

        if(newkeys & KEY_ANALOG_LEFT)
        {
            MENU3D_DATA[playerid][CurrTextureIndex] -= 16;
            if(MENU3D_DATA[playerid][CurrTextureIndex] < 1) MENU3D_DATA[playerid][CurrTextureIndex] = MAX_TEXTURES - 1 - 16;
            if(MENU3D_DATA[playerid][CurrTextureIndex] >= MAX_TEXTURES - 1) MENU3D_DATA[playerid][CurrTextureIndex] = 1;
            for(new i = 0; i < 16; i++)
            {
                if(i+MENU3D_DATA[playerid][CurrTextureIndex] >= MAX_TEXTURES - 1) continue;
                SetBoxMaterial(MENU3D_DATA[playerid][Menus3D],i,0,ObjectTextures[i+MENU3D_DATA[playerid][CurrTextureIndex]][TModel],ObjectTextures[i+MENU3D_DATA[playerid][CurrTextureIndex]][TXDName],ObjectTextures[i+MENU3D_DATA[playerid][CurrTextureIndex]][TextureName], 0, 0xFF999999);
            }

            UpdateTextureInfo(playerid, SelectedBox[playerid]);
        }
    }
    return 0;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys & KEY_YES)
    {
        if(fsearch[playerid])
        {
            nowf[playerid] ++;
            if(nowf[playerid] == sizeof(Fonts)) nowf[playerid] = 0;
            SetPlayerObjectMaterialText(playerid, fob[playerid], Fonts[nowf[playerid]], 1, 90, Fonts[nowf[playerid]], 40, 1, 0xFFFFFFFF, 0xFF000000, 1);
            new str[30];
            format(str, sizeof(str), "Font_ID:_%i", nowf[playerid] + 1);
            PlayerTextDrawSetString(playerid, fonttd[playerid], str);
        }
    }       
    else if(newkeys & KEY_NO)
    {
        if(fsearch[playerid])
        {
            nowf[playerid] --;
            if(nowf[playerid] == -1) nowf[playerid] = sizeof(Fonts) -1;
            SetPlayerObjectMaterialText(playerid, fob[playerid], Fonts[nowf[playerid]], 1, 90, Fonts[nowf[playerid]], 40, 1, 0xFFFFFFFF, 0xFF000000, 1);
            new str[30];
            format(str, sizeof(str), "Font_ID:_%i", nowf[playerid] + 1);
            PlayerTextDrawSetString(playerid, fonttd[playerid], str);
        }
    }
    return 1;
}

public OnPlayerChange3DMenuBox(playerid,MenuID,boxid)
{
    UpdateTextureInfo(playerid, boxid);
    return 1;
}

public OnPlayerEditDynamicObject(playerid, STREAMER_TAG_OBJECT objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if(IsValidDynamicObject(objectid))
    {
        if(response == EDIT_RESPONSE_FINAL)
        {
            SetDynamicObjectPos(objectid, x, y, z);               
            SetDynamicObjectRot(objectid, rx, ry, rz);

            OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosX] = x;
            OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosY] = y;
            OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosZ] = z;
            OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotX] = rx;
            OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotY] = ry;
            OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotZ] = rz;

            PLAYER_INFO[playerid][editing] = 0;

            new str[128]; 
            format(str, sizeof(str), ""#COL_BLUE"|GEditor| "#COL_YELLOW"New locaion for object id %i in map '%s' has been saved", PLAYER_INFO[playerid][cur_obj], PLAYER_mName[playerid][PLAYER_INFO[playerid][cur_player_mid]]);
            SendClientMessage(playerid, -1, str);
        }
        else if(response == EDIT_RESPONSE_CANCEL)
        {
            SetDynamicObjectPos(objectid, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosX], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosY], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosZ]);
            SetDynamicObjectRot(objectid, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotX], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotY], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotZ]);

            PLAYER_INFO[playerid][editing] = 0;

            new str[128];
            format(str, sizeof(str), ""#COL_BLUE"|GEditor| "#COL_YELLOW"New locaion for object %i in map '%s' hasn't been saved!", PLAYER_INFO[playerid][cur_obj], PLAYER_mName[playerid][PLAYER_INFO[playerid][cur_player_mid]]);
            SendClientMessage(playerid, -1, str);
        }
    }
    return 1;
}

/* GEditor Commands */ 
CMD:gcmds(playerid, params[])
{       
    new str[2500]; 
    strcat(str, ""#COL_GREEN"Map Commands:\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/cm <name> <password>\t\t\t- Creates a new map by the given name and password\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/md <name> <password>\t\t\t- Deletes a map by name and password\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/lm <name> <password>\t\t\t- Loads a saved map by name and password\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/em\t\t\t\t\t\t- Select a map for editing from loaded maps\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/ulm <name> <password>\t\t\t- Unloads a loaded map by name and password\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/vlm <name> <password>\t\t\t- Loads a map for view by name and password (no editing ability)\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/vulm <name> <password>\t\t\t- Unloads a map loaded for view by name and password\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/mr <new name>\t\t\t\t- Renames the current editing map\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/mpass <old pass> <new pass>\t\t- Replace the password of current editing map with a new one\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/fly\t\t\t\t\t\t- Activate/Deactivate Fly mode\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/label\t\t\t\t\t\t- Add labels for objects, actors and vehicles\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/fontsearch\t\t\t\t\t- browse through all fonts available\n\n", sizeof(str));
    strcat(str, ""#COL_GREEN"Object Commands:\n", sizeof(str));     
    strcat(str, ""#COL_WHITE"/osearch\t\t\t\t\t- Search object by name or some parts from inputed name\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/oc <model ID>\t\t\t\t\t- Creates object by model ID\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/odc\t\t\t\t\t\t- Delete current editing object\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/od <object ID>\t\t\t\t\t- Destroy or delete object from map object ID\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/op\t\t\t\t\t\t- Editing mode with mouse and GUI\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/oe <object ID>\t\t\t\t\t- Select an object for editing\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/oclone\t\t\t\t\t- Clone current object and select it for editing\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/ocopy <object ID>\t\t\t\t- Copy all specifications from current editing object (texture, color, text..)\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/opaste\t\t\t\t\t- Paste specifications from copy buffer to current editing object\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/omodel <new model ID>\t\t\t- Swap the model of current editing object with a new  one\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/omove <object ID> <x> <y> <z> <time>\t- Move obect to a given positon\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/ostopmove <object ID>\t\t\t- Stops a moving object\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/(ox | oy | oz) <value>\t\t\t\t- Change the position of the position of the current editing object in relevent axis by the given value\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/(rx | ry | rz) <value>\t\t\t\t- Change the rotation of the position of the current editing object in relevent axis by the given value\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/(aox | aoy | aoz <value>\t\t\t- Change the position of the position of all objects in relevent axis by the given value\n", sizeof(str));
    strcat(str, ""#COL_WHITE"/(arx | ary | arz <value>\t\t\t- Change the rotation of the position of all objects in relevent axis by the given value", sizeof(str));
    ShowPlayerDialog(playerid, DIALOG_CMDS, DIALOG_STYLE_MSGBOX, "GEditor - Commands - Page(1/3)", str, "Next", "Close");
    return 1;
}

CMD:fly(playerid, params[])
{
    if(PLAYER_INFO[playerid][fly] == 1) CancelFlyMode(playerid);
    else FlyMode(playerid);
    return 1;         
}

CMD:cm(playerid, params[])
{
	new mname[20], mpass[20]; 
	new count, path[50], str[128];
	for(new i = 0; i < MAX_CREATABLE_MAPS_IN_SERVER; i++)
	{
        format(str, sizeof(str), "%i_Map", i);
        if(dini_Isset(MAP_EDITOR_CONF_PATH, str))
		{
            format(path, sizeof(path), MAP_SAVE_PATH, dini_Get(MAP_EDITOR_CONF_PATH, str));
            if(isequal(PlayerName(playerid), dini_Get(path, "Creator")))
            {
                count ++;
            }
        }
	}
	if(count >= MAX_MAPS_THAT_CAN_BE_CREATED_BY_A_USER) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You have reached the maximum number of maps that can be created by a player ( limit: "#MAX_MAPS_THAT_CAN_BE_CREATED_BY_A_USER" )");
	if(sscanf(params, "s[20]s[20]", mname, mpass)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /cm <name> <password>");
	if(strlen(mname) < 4 || strlen(mname) > 20) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Map name should have 4 - 20 characters");
	if(strlen(mpass) < 4 || strlen(mpass) > 20) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Map password should have 4 - 20 characters");
	if(!IsValidMapName(mname)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Map name should only contain lower case letters or numbers");
	format(str, sizeof(str), MAP_SAVE_PATH, mname);
	if(dini_Exists(str)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" A map with this name already exists");
	SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_YELLOW" Your map has been successfully created");

	new hour, minute, second, year, month, day;
	gettime(hour, minute, second);
	getdate(year, month, day);
	new date[60];
	format(date, sizeof(date), "[ %i.%i.%i | %i.%i.%i ]", year, month, date, hour, minute, second);  // [ Year.Month.Date | Hour.Minute.Second ]

	dini_Create(str);
	dini_Set(str, "Creator", PlayerName(playerid));
	dini_Set(str, "Password", mpass);
	dini_Set(str, "Date_Created", date);
	dini_IntSet(str, "Total_Objects", 0);
	dini_IntSet(str, "Total_Actors", 0);
    dini_IntSet(str, "Total_Vehicles", 0);

	EDITOR_INFO[T_Maps]++; 
	for(new i = 0; i < MAX_CREATABLE_MAPS_IN_SERVER; i++)
    {
        format(str, sizeof(str), "%i_Map", i);
        if(!dini_Isset(MAP_EDITOR_CONF_PATH, str))
        {  
            dini_Set(MAP_EDITOR_CONF_PATH, str, mname); 
            break;
        }
    }
	return 1;
}

CMD:vlm(playerid, params[])
{
    new mname[20], mpass[20];
    if(PLAYER_INFO[playerid][mLoaded] == MAX_LOADABLE_MAPS_AT_ONCE) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You have reached the limit of the maximum  no of maps which can be open at once (Limit: "#MAX_LOADABLE_MAPS_AT_ONCE")");
    if(EDITOR_INFO[M_Loaded] == MAX_LOADABLE_MAPS_IN_SERVER) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Server has reached the limit of the maximum  no of maps which can be loaded at once (Limit: "#MAX_LOADABLE_MAPS_IN_SERVER")");
    if(sscanf(params, "s[20]s[20]", mname, mpass)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /lm <name> <password>");
    if(!IsValidMapName(mname)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Map name should only contain lower case letters or numbers");
    for(new i = 0; i < MAX_LOADABLE_MAPS_AT_ONCE; i ++)
    {
        if(isequal(PLAYER_mName[playerid][i], mname)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You have already loaded this map");
    }
    for(new i = 0; i < MAX_LOADABLE_MAPS_IN_SERVER; i++)
    {
        if(isequal(MAP_INFO[i][M_Name], mname)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Someone has loded this map for editing. You can't load the map until he/she finished editing.");
    }
    new str[128];
    format(str, sizeof(str), MAP_SAVE_PATH, mname);
    if(!dini_Exists(str)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" A map with this name does not exist");
    if(!isequal(mpass, dini_Get(str, "Password"))) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Wrong password!");
    SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_GREY" Your map has been successfully loaded");
    for(new i = 0; i < MAX_LOADABLE_MAPS_AT_ONCE; i ++)
    {
        if(isequal(PLAYER_mName[playerid][i], "-1"))
        {
            format(PLAYER_mName[playerid][i], 20, "%s", mname);
            break;
        }
    }

    for(new i = 0; i < MAX_LOADABLE_MAPS_IN_SERVER; i ++)
    {
        if(isequal(MAP_INFO[i][M_Name], "-1"))
        {
            format(MAP_INFO[i][M_Name], 20, "%s", mname);
            break;
        }
    }
    
    new id_ = GetServerMapID(mname);
    MAP_INFO[id_][forview] = 1;
    for(new i = 0; i < MAX_OBJ; i ++)
    {
        OBJ_INFO[id_][i][O_ID] = -1;
        OBJ_INFO[id_][i][O_MODEL_ID] = -1;
        OBJ_INFO[id_][i][O_PosX] = -1;
        OBJ_INFO[id_][i][O_PosY] = -1;
        OBJ_INFO[id_][i][O_PosZ] = -1;
        OBJ_INFO[id_][i][O_RotX] = -1;
        OBJ_INFO[id_][i][O_RotY] = -1;
        OBJ_INFO[id_][i][O_RotZ] = -1;
        OBJ_INFO[id_][i][move] = 0;
        for(new k = 0; k < MAX_INDEX; k++)
        {
            Mat_USED[id_][i][k] = 0;
            Mat_TUSED[id_][i][k] = 0;
            Mat_TBOLD[id_][i][k] = 1;
            Mat_TSIZE[id_][i][k] = 24;
            Mat_TCOL[id_][i][k] = 0xFFFFFFFF;
            Mat_TBACKCOL[id_][i][k] = 0;
            Mat_TMSIZE[id_][i][k] = OBJECT_MATERIAL_SIZE_256x128;
            Mat_TALIGN[id_][i][k] = 0;
            Mat_TFONT[id_][i][k] = 0;
            SetMatTextInIndex(id_, i, k, "-1");
        }
    }


    MAP_INFO[id_][total_obj] = dini_Int(str, "Total_Objects");
    
    new t[MAX_MATTEXT_SIZE];
    if(MAP_INFO[id_][total_obj] > 0)
    {
        new str_[50], info[256];
        for(new i = 0; i < MAX_OBJ; i ++)
        { 
            format(str_, sizeof(str_), "%i_Object_Info", i);
            if(dini_Isset(str, str_))
            {
                format(info, sizeof(info), "%s", dini_Get(str, str_));
                sscanf(info, "iffffffiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiffff", 
                OBJ_INFO[id_][i][O_MODEL_ID], OBJ_INFO[id_][i][O_PosX], OBJ_INFO[id_][i][O_PosY], OBJ_INFO[id_][i][O_PosZ], OBJ_INFO[id_][i][O_RotX], OBJ_INFO[id_][i][O_RotY], OBJ_INFO[id_][i][O_RotZ],
                Mat_USED[id_][i][0], Mat_ID[id_][i][0],
                Mat_USED[id_][i][1], Mat_ID[id_][i][1],
                Mat_USED[id_][i][2], Mat_ID[id_][i][2],
                Mat_USED[id_][i][3], Mat_ID[id_][i][3],
                Mat_USED[id_][i][4], Mat_ID[id_][i][4],
                Mat_USED[id_][i][5], Mat_ID[id_][i][5],
                Mat_USED[id_][i][6], Mat_ID[id_][i][6],
                Mat_USED[id_][i][7], Mat_ID[id_][i][7],
                Mat_USED[id_][i][8], Mat_ID[id_][i][8],
                Mat_USED[id_][i][9], Mat_ID[id_][i][9],
                Mat_USED[id_][i][10], Mat_ID[id_][i][10],
                Mat_USED[id_][i][11], Mat_ID[id_][i][11],
                Mat_USED[id_][i][12], Mat_ID[id_][i][12],
                Mat_USED[id_][i][13], Mat_ID[id_][i][13],
                Mat_USED[id_][i][14], Mat_ID[id_][i][14],
                Mat_USED[id_][i][15], Mat_ID[id_][i][15],
                OBJ_INFO[id_][i][move], 
                OBJ_INFO[id_][i][movex],
                OBJ_INFO[id_][i][movey],
                OBJ_INFO[id_][i][movez],
                OBJ_INFO[id_][i][ospeed]
                );
                OBJ_INFO[id_][i][O_ID] = CreateDynamicObject(OBJ_INFO[id_][i][O_MODEL_ID], OBJ_INFO[id_][i][O_PosX], OBJ_INFO[id_][i][O_PosY], OBJ_INFO[id_][i][O_PosZ], OBJ_INFO[id_][i][O_RotX], OBJ_INFO[id_][i][O_RotY], OBJ_INFO[id_][i][O_RotZ]);
                MoveDynamicObject(OBJ_INFO[id_][i][O_ID], OBJ_INFO[id_][i][movex], OBJ_INFO[id_][i][movey], OBJ_INFO[id_][i][movez], OBJ_INFO[id_][i][ospeed], OBJ_INFO[id_][i][O_RotX], OBJ_INFO[id_][i][O_RotY], OBJ_INFO[id_][i][O_RotZ]);
                for(new k = 0; k < MAX_INDEX; k++)
                {
                    if(Mat_USED[id_][i][k]) SetDynamicObjectMaterial(OBJ_INFO[id_][i][O_ID], k, ObjectTextures[Mat_ID[id_][i][k]][TModel], ObjectTextures[Mat_ID[id_][i][k]][TXDName], ObjectTextures[Mat_ID[id_][i][k]][TextureName]);
                    format(str_, sizeof(str_), "%i_%i_MaterialText_Info", i, k);
                    if(dini_Isset(str, str_))
                    {
                        Mat_TUSED[id_][i][k] = 1;
                        sscanf(dini_Get(str, str_), "s["#MAX_MATTEXT_SIZE"]iiiiiii", t, Mat_TMSIZE[id_][i][k], Mat_TFONT[id_][i][k], Mat_TSIZE[id_][i][k], Mat_TBOLD[id_][i][k], Mat_TCOL[id_][i][k], Mat_TBACKCOL[id_][i][k], Mat_TALIGN[id_][i][k]);
                        SetMatTextInIndex(id_, i, k, t);
                        strreplace(t, "`", " ");
                        SetDynamicObjectMaterialText(OBJ_INFO[id_][i][O_ID], k, t, Mat_TMSIZE[id_][i][k], Fonts[Mat_TFONT[id_][i][k]], Mat_TSIZE[id_][i][k], Mat_TBOLD[id_][i][k], Mat_TCOL[id_][i][k], Mat_TBACKCOL[id_][i][k], Mat_TALIGN[id_][i][k]);
                    }
                }
            }
        }
    }

    for(new i = 0; i < MAX_ACT; i ++)
    {
        ACT_INFO[id_][i][A_ID] = -1;
        ACT_INFO[id_][i][A_SKIN] = -1;
        ACT_INFO[id_][i][A_PosX] = -1;
        ACT_INFO[id_][i][A_PosY] = -1;
        ACT_INFO[id_][i][A_PosZ] = -1;
        ACT_INFO[id_][i][A_Ang] = -1;
        ACT_INFO[id_][i][animused] = 0;
        ACT_INFO[id_][i][animid] = -1;
    }

    MAP_INFO[id_][total_actors] = dini_Int(str, "Total_Actors");

    if(MAP_INFO[id_][total_actors] > 0)
    {
        new str_[50], info[128];
        for(new i = 0; i < MAX_ACT; i ++)
        {
            format(str_, sizeof(str_), "%i_Actor_Info", i);
            if(dini_Isset(str, str_)) 
            {
                format(info, sizeof(info), "%s", dini_Get(str, str_));
                sscanf(info, "iffffii", ACT_INFO[id_][i][A_SKIN], ACT_INFO[id_][i][A_PosX], ACT_INFO[id_][i][A_PosY], ACT_INFO[id_][i][A_PosZ], ACT_INFO[id_][i][A_Ang], ACT_INFO[id_][i][animused], ACT_INFO[id_][i][animid]);
                ACT_INFO[id_][i][A_ID] = CreateDynamicActor(ACT_INFO[id_][i][A_SKIN], ACT_INFO[id_][i][A_PosX], ACT_INFO[id_][i][A_PosY], ACT_INFO[id_][i][A_PosZ], ACT_INFO[id_][i][A_Ang]);
                if(ACT_INFO[id_][i][animused]) ApplyDynamicActorAnimation(ACT_INFO[id_][i][A_ID], AnimationData[ACT_INFO[id_][i][animid]][animlib], AnimationData[ACT_INFO[id_][i][animid]][animname], 4.0,1,0,0,0,-1);
            }
        }
    }

    for(new i = 0; i < MAX_VEH; i ++)
    {
        VEH_INFO[id_][i][V_ID] = -1;
        VEH_INFO[id_][i][V_MODEL_ID] = -1;
        VEH_INFO[id_][i][V_PosX] = -1;
        VEH_INFO[id_][i][V_PosY] = -1;
        VEH_INFO[id_][i][V_PosZ] = -1;
        VEH_INFO[id_][i][V_Ang] = -1;
    }

    MAP_INFO[id_][total_vehicles] = dini_Int(str, "Total_Vehicles");

    if(MAP_INFO[id_][total_vehicles] > 0)
    {
        new str_[50], info[128];
        for(new i = 0; i < MAX_VEH; i ++)
        {
            format(str_, sizeof(str_), "%i_Vehicle_Info", i);
            if(dini_Isset(str, str_)) 
            {
                format(info, sizeof(info), "%s", dini_Get(str, str_));
                sscanf(info, "iffffii", VEH_INFO[id_][i][V_MODEL_ID], VEH_INFO[id_][i][V_PosX], VEH_INFO[id_][i][V_PosY], VEH_INFO[id_][i][V_PosZ], VEH_INFO[id_][i][V_Ang], VEH_INFO[id_][i][V_Color1], VEH_INFO[id_][i][V_Color2]);
                VEH_INFO[id_][i][V_ID] = CreateVehicle(VEH_INFO[id_][i][V_MODEL_ID], VEH_INFO[id_][i][V_PosX], VEH_INFO[id_][i][V_PosY], VEH_INFO[id_][i][V_PosZ], VEH_INFO[id_][i][V_Ang], VEH_INFO[id_][i][V_Color1], VEH_INFO[id_][i][V_Color2], RESPAWN_DELAY);
            }
        }
    }

    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" %i objects, %i actors and %i vehicles loaded! ( Map name: %s | Map ID: %i )",  MAP_INFO[id_][total_obj], MAP_INFO[id_][total_actors], MAP_INFO[id_][total_vehicles], mname, GetPlayerMapID(playerid, mname));
    SendClientMessage(playerid, -1, str);
    PLAYER_INFO[playerid][mLoaded]++;
    EDITOR_INFO[M_Loaded]++;
    return 1;
}

CMD:vulm(playerid, params[])
{
    new mname[20], mpass[20];
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps");
    if(sscanf(params, "s[20]s[20]", mname, mpass)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /ulm <name> <password>");
    if(strlen(mname) < 4 || strlen(mname) > 20) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Map name should have 4 - 20 characters");
    if(!IsValidMapName(mname)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Map name should only contain lower case letters or numbers");
    new str[128];
    format(str, sizeof(str), MAP_SAVE_PATH, mname);
    if(!dini_Exists(str)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" A map with this name does not exist");
    new ret;
    for(new i = 0; i < MAX_LOADABLE_MAPS_IN_SERVER; i++)
    {
        if(isequal(MAP_INFO[i][M_Name], mname)) ret = 1;
    }
    if(ret == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" This map isn't loaded");
    if(!isequal(mpass, dini_Get(str, "Password"))) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Wrong password!");
    new id_ = GetServerMapID(mname);    
    SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_GREY" Your map has been successfully unloaded");
    new id__ = GetPlayerMapID(playerid, mname);
    
    new str_[128];
    MAP_INFO[id_][forview] = 0;
    if(PLAYER_INFO[playerid][cur_svr_mid] == id_ && PLAYER_INFO[playerid][labeled] == 1)
    {
        for(new i = 0; i < MAX_OBJ; i++)
        {
            if(IsValidDynamicObject(OBJ_INFO[id_][i][O_ID]))
            {
                if(IsValidDynamic3DTextLabel(OBJ_INFO[id_][i][O_LID]))
                {
                    DestroyDynamic3DTextLabel(OBJ_INFO[id_][i][O_LID]);
                }
            }
        }

        for(new i = 0; i < MAX_ACT; i++)
        {
            if(IsValidDynamicActor(ACT_INFO[id_][i][A_ID]))
            {
                if(IsValidDynamic3DTextLabel(ACT_INFO[id_][i][A_LID]))
                {
                    DestroyDynamic3DTextLabel(ACT_INFO[id_][i][A_LID]);
                }
            }
        }

        for(new i = 0; i < MAX_VEH; i++)
        {
            if(IsValidVehicle(VEH_INFO[id_][i][V_ID]))
            {
                if(IsValidDynamic3DTextLabel(VEH_INFO[id_][i][V_LID]))
                {
                    DestroyDynamic3DTextLabel(VEH_INFO[id_][i][V_LID]);
                }
            }
        }
    }

    new info[256];
    format(PLAYER_mName[playerid][id__], 20, "%s", "-1");
    dini_IntSet(str, "Total_Objects", MAP_INFO[id_][total_obj]);
    dini_IntSet(str, "Total_Actors", MAP_INFO[id_][total_actors]);
    dini_IntSet(str, "Total_Vehicles", MAP_INFO[id_][total_vehicles]);
    for(new j = 0; j < MAX_OBJ; j++)
    {
        format(str_, sizeof(str_), "%i_Object_Info", j);
        if(IsValidDynamicObject(OBJ_INFO[id_][j][O_ID]))
        {
            format(info, sizeof(info), "%i %f %f %f %f %f %f %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %f %f %f %f", OBJ_INFO[id_][j][O_MODEL_ID], OBJ_INFO[id_][j][O_PosX], OBJ_INFO[id_][j][O_PosY], OBJ_INFO[id_][j][O_PosZ], OBJ_INFO[id_][j][O_RotX], OBJ_INFO[id_][j][O_RotY], OBJ_INFO[id_][j][O_RotZ],
            Mat_USED[id_][j][0], Mat_ID[id_][j][0],
            Mat_USED[id_][j][1], Mat_ID[id_][j][1],
            Mat_USED[id_][j][2], Mat_ID[id_][j][2],
            Mat_USED[id_][j][3], Mat_ID[id_][j][3],
            Mat_USED[id_][j][4], Mat_ID[id_][j][4],
            Mat_USED[id_][j][5], Mat_ID[id_][j][5],
            Mat_USED[id_][j][6], Mat_ID[id_][j][6],
            Mat_USED[id_][j][7], Mat_ID[id_][j][7],
            Mat_USED[id_][j][8], Mat_ID[id_][j][8],
            Mat_USED[id_][j][9], Mat_ID[id_][j][9],
            Mat_USED[id_][j][10], Mat_ID[id_][j][10],
            Mat_USED[id_][j][11], Mat_ID[id_][j][11],
            Mat_USED[id_][j][12], Mat_ID[id_][j][12],
            Mat_USED[id_][j][13], Mat_ID[id_][j][13],
            Mat_USED[id_][j][14], Mat_ID[id_][j][14],
            Mat_USED[id_][j][15], Mat_ID[id_][j][15],
            OBJ_INFO[id_][j][move], 
            OBJ_INFO[id_][j][movex],
            OBJ_INFO[id_][j][movey],
            OBJ_INFO[id_][j][movez],
            OBJ_INFO[id_][j][ospeed]
            );
            dini_Set(str, str_, info);
            for(new k = 0; k < MAX_INDEX; k++)
            {
                format(str_, sizeof(str_), "%i_%i_MaterialText_Info", j, k);
                if(Mat_TUSED[id_][j][k]){
                    format(info, sizeof(info), "%s %i %i %i %i %i %i %i", GetMatTextInIndex(id_, j, k), Mat_TMSIZE[id_][j][k], Mat_TFONT[id_][j][k], Mat_TSIZE[id_][j][k], Mat_TBOLD[id_][j][k], Mat_TCOL[id_][j][k], Mat_TBACKCOL[id_][j][k], Mat_TALIGN[id_][j][k]);
                    dini_Set(str, str_, info);
                }
                else{
                    if(dini_Isset(str, str_))
                    {
                        dini_Unset(str, str_);
                    }
                }
            }

            DestroyDynamicObject(OBJ_INFO[id_][j][O_ID]);
        }
        else
        {
            if(dini_Isset(str, str_))
            {
                dini_Unset(str, str_);
                for(new k = 0; k < MAX_INDEX; k++)
                {
                    format(str_, sizeof(str_), "%i_%i_MaterialText_Info", j, k);
                    if(dini_Isset(str, str_))
                    {
                        dini_Unset(str, str_);
                    }
                }
            }
        }
    } 

    for(new j = 0; j < MAX_ACT; j++)
    {
        format(str_, sizeof(str_), "%i_Actor_Info", j);
        if(IsValidDynamicActor(ACT_INFO[id_][j][A_ID]))
        {
            format(info, sizeof(info), "%i %f %f %f %f %i %i", ACT_INFO[id_][j][A_SKIN], ACT_INFO[id_][j][A_PosX], ACT_INFO[id_][j][A_PosY], ACT_INFO[id_][j][A_PosZ], ACT_INFO[id_][j][A_Ang], ACT_INFO[id_][j][animused], ACT_INFO[id_][j][animid]);
            dini_Set(str, str_, info);

            DestroyDynamicActor(ACT_INFO[id_][j][A_ID]);
        }
        else
        {
            if(dini_Isset(str, str_))
            {
                dini_Unset(str, str_);
            }
        }
    } 

    for(new j = 0; j < MAX_VEH; j++)
    {
        format(str_, sizeof(str_), "%i_Vehicle_Info", j);
        if(IsValidVehicle(VEH_INFO[id_][j][V_ID]))
        {
            format(info, sizeof(info), "%i %f %f %f %f %i %i", VEH_INFO[id_][j][V_MODEL_ID], VEH_INFO[id_][j][V_PosX], VEH_INFO[id_][j][V_PosY], VEH_INFO[id_][j][V_PosZ], VEH_INFO[id_][j][V_Ang], VEH_INFO[id_][j][V_Color1], VEH_INFO[id_][j][V_Color2]);
            dini_Set(str, str_, info);

            DestroyVehicle(VEH_INFO[id_][j][V_ID]);
        }
        else
        {
            if(dini_Isset(str, str_))
            {
                dini_Unset(str, str_);
            }
        }
    } 

    format(str, sizeof(str), ""#COL_BLUE"|GEditor| "#COL_YELLOW"%i objects, %i actors and %i vehicles unloaded! ( Map name: %s | Map ID: %i )", MAP_INFO[id_][total_obj], MAP_INFO[id_][total_actors], MAP_INFO[id_][total_vehicles], mname, id__);
    SendClientMessage(playerid, -1, str);

    format(MAP_INFO[id_][M_Name], 20, "%s", "-1");
    MAP_INFO[id_][total_obj] = 0;
    MAP_INFO[id_][total_actors] = 0;
    MAP_INFO[id_][total_vehicles] = 0;
    PLAYER_INFO[playerid][mLoaded]--;
    EDITOR_INFO[M_Loaded]--;

    if(PLAYER_INFO[playerid][mLoaded] > 0)
    {
        new lid = -1;
        for(new i = 0; i < MAX_LOADABLE_MAPS_AT_ONCE; i++)
        {
            if(!isequal(PLAYER_mName[playerid][i], "-1"))
            {
                lid = i;
            }
        }
        PLAYER_INFO[playerid][cur_player_mid] = lid;
        if(lid != -1) PLAYER_INFO[playerid][cur_svr_mid] = GetServerMapID(PLAYER_mName[playerid][lid]);
        else PLAYER_INFO[playerid][cur_svr_mid] = -1; 
        PLAYER_INFO[playerid][editing] = 0;
        PLAYER_INFO[playerid][cur_obj] = -1;    
        PLAYER_INFO[playerid][cur_act] = -1;    
        PLAYER_INFO[playerid][cur_act] = -1;

        if(PLAYER_INFO[playerid][labeled] == 1)
        {
            for(new i = 0; i < MAX_OBJ; i ++)
            {
                if(IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID]))
                {
                    format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"Model ID: "#COL_RED"%i", i, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_MODEL_ID]);
                    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID] = CreateDynamic3DTextLabel(str, -1, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosX], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosY], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosZ], LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
                }
            }

            for(new i = 0; i < MAX_ACT; i ++)
            {
                if(IsValidDynamicActor(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_ID]))
                {
                    format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"Skin ID: "#COL_RED"%i", i, ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_SKIN]);
                    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_LID] = CreateDynamic3DTextLabel(str, -1, ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_PosX], ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_PosY], ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_PosZ], LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
                }
            }   

            for(new i = 0; i < MAX_VEH; i ++)
            {
                if(IsValidVehicle(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_ID]))
                {
                    format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"Model ID: "#COL_RED"%i", i, VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_MODEL_ID]);
                    VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_LID] = CreateDynamic3DTextLabel(str, -1, VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_PosX], VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_PosY], VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_PosZ], LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_ID], 0, -1, -1, playerid);
                }
            }                 
        }   
    }
    else
    {
        PLAYER_INFO[playerid][cur_player_mid] = -1;
        PLAYER_INFO[playerid][cur_svr_mid] = -1;
        PLAYER_INFO[playerid][editing] = 0;
        PLAYER_INFO[playerid][cur_obj] = -1;
        PLAYER_INFO[playerid][cur_act] = -1;
        PLAYER_INFO[playerid][labeled] = 0;
    }
    
    for(new i = 0; i < MAX_OBJ; i ++)
    {
        OBJ_INFO[id_][i][O_ID] = -1;
        OBJ_INFO[id_][i][O_MODEL_ID] = -1;
        OBJ_INFO[id_][i][O_PosX] = -1;
        OBJ_INFO[id_][i][O_PosY] = -1;
        OBJ_INFO[id_][i][O_PosZ] = -1;
        OBJ_INFO[id_][i][O_RotX] = -1;
        OBJ_INFO[id_][i][O_RotY] = -1;
        OBJ_INFO[id_][i][O_RotZ] = -1;
        OBJ_INFO[id_][i][move] = 0;
    }    

    for(new i = 0; i < MAX_ACT; i ++)
    {
        ACT_INFO[id_][i][A_ID] = -1;
        ACT_INFO[id_][i][A_SKIN] = -1;
        ACT_INFO[id_][i][A_PosX] = -1;
        ACT_INFO[id_][i][A_PosY] = -1;
        ACT_INFO[id_][i][A_PosZ] = -1;
        ACT_INFO[id_][i][A_Ang] = -1;
    }

    for(new i = 0; i < MAX_VEH; i ++)
    {
        VEH_INFO[id_][i][V_ID] = -1;
        VEH_INFO[id_][i][V_MODEL_ID] = -1;
        VEH_INFO[id_][i][V_PosX] = -1;
        VEH_INFO[id_][i][V_PosY] = -1;
        VEH_INFO[id_][i][V_PosZ] = -1;
        VEH_INFO[id_][i][V_Ang] = -1;
    }
    return 1;
}

CMD:lm(playerid, params[])
{
	new mname[20], mpass[20];
	if(PLAYER_INFO[playerid][mLoaded] == MAX_LOADABLE_MAPS_AT_ONCE) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You have reached the limit of the maximum  no of maps which can be open at once (Limit: "#MAX_LOADABLE_MAPS_AT_ONCE")");
	if(EDITOR_INFO[M_Loaded] == MAX_LOADABLE_MAPS_IN_SERVER) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Server has reached the limit of the maximum  no of maps which can be loaded at once (Limit: "#MAX_LOADABLE_MAPS_IN_SERVER")");
	if(sscanf(params, "s[20]s[20]", mname, mpass)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /lm <name> <password>");
    if(!IsValidMapName(mname)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Map name should only contain lower case letters or numbers");
	for(new i = 0; i < MAX_LOADABLE_MAPS_AT_ONCE; i ++)
	{
		if(isequal(PLAYER_mName[playerid][i], mname)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You have already loaded this map");
	}
	for(new i = 0; i < MAX_LOADABLE_MAPS_IN_SERVER; i++)
	{
		if(isequal(MAP_INFO[i][M_Name], mname)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Someone has loded this map for editing. You can't load the map until he/she finished editing.");
	}
	new str[128];
	format(str, sizeof(str), MAP_SAVE_PATH, mname);
	if(!dini_Exists(str)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" A map with this name does not exist");
	if(!isequal(mpass, dini_Get(str, "Password"))) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Wrong password!");
	SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_GREY" Your map has been successfully loaded");
	for(new i = 0; i < MAX_LOADABLE_MAPS_AT_ONCE; i ++)
	{
		if(isequal(PLAYER_mName[playerid][i], "-1"))
		{
			format(PLAYER_mName[playerid][i], 20, "%s", mname);
			break;
		}
	}

	for(new i = 0; i < MAX_LOADABLE_MAPS_IN_SERVER; i ++)
	{
		if(isequal(MAP_INFO[i][M_Name], "-1"))
		{
			format(MAP_INFO[i][M_Name], 20, "%s", mname);
			break;
		}
	}
	
	new id_ = GetServerMapID(mname);
    MAP_INFO[id_][forview] = 0;
	for(new i = 0; i < MAX_OBJ; i ++)
	{
		OBJ_INFO[id_][i][O_ID] = -1;
		OBJ_INFO[id_][i][O_MODEL_ID] = -1;
		OBJ_INFO[id_][i][O_PosX] = -1;
		OBJ_INFO[id_][i][O_PosY] = -1;
		OBJ_INFO[id_][i][O_PosZ] = -1;
		OBJ_INFO[id_][i][O_RotX] = -1;
		OBJ_INFO[id_][i][O_RotY] = -1;
		OBJ_INFO[id_][i][O_RotZ] = -1;
        OBJ_INFO[id_][i][move] = 0;
        for(new k = 0; k < MAX_INDEX; k++)
        {
            Mat_USED[id_][i][k] = 0;
            Mat_TUSED[id_][i][k] = 0;
            Mat_TBOLD[id_][i][k] = 1; 
            Mat_TSIZE[id_][i][k] = 24;
            Mat_TCOL[id_][i][k] = 0xFFFFFFFF;
            Mat_TBACKCOL[id_][i][k] = 0;
            Mat_TALIGN[id_][i][k] = 0;
            Mat_TMSIZE[id_][i][k] = OBJECT_MATERIAL_SIZE_256x128;
            SetMatTextInIndex(id_, i, k, "-1");
        }
	}


	MAP_INFO[id_][total_obj] = dini_Int(str, "Total_Objects");
	
    new t[MAX_MATTEXT_SIZE];
	if(MAP_INFO[id_][total_obj] > 0)
	{
		new str_[50], info[256];
		for(new i = 0; i < MAX_OBJ; i ++)
		{ 
			format(str_, sizeof(str_), "%i_Object_Info", i);
			if(dini_Isset(str, str_))
			{
				format(info, sizeof(info), "%s", dini_Get(str, str_));
				sscanf(info, "iffffffiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiffff", 
                OBJ_INFO[id_][i][O_MODEL_ID], OBJ_INFO[id_][i][O_PosX], OBJ_INFO[id_][i][O_PosY], OBJ_INFO[id_][i][O_PosZ], OBJ_INFO[id_][i][O_RotX], OBJ_INFO[id_][i][O_RotY], OBJ_INFO[id_][i][O_RotZ],
                Mat_USED[id_][i][0], Mat_ID[id_][i][0],
                Mat_USED[id_][i][1], Mat_ID[id_][i][1],
                Mat_USED[id_][i][2], Mat_ID[id_][i][2],
                Mat_USED[id_][i][3], Mat_ID[id_][i][3],
                Mat_USED[id_][i][4], Mat_ID[id_][i][4],
                Mat_USED[id_][i][5], Mat_ID[id_][i][5],
                Mat_USED[id_][i][6], Mat_ID[id_][i][6],
                Mat_USED[id_][i][7], Mat_ID[id_][i][7],
                Mat_USED[id_][i][8], Mat_ID[id_][i][8],
                Mat_USED[id_][i][9], Mat_ID[id_][i][9],
                Mat_USED[id_][i][10], Mat_ID[id_][i][10],
                Mat_USED[id_][i][11], Mat_ID[id_][i][11],
                Mat_USED[id_][i][12], Mat_ID[id_][i][12],
                Mat_USED[id_][i][13], Mat_ID[id_][i][13],
                Mat_USED[id_][i][14], Mat_ID[id_][i][14],
                Mat_USED[id_][i][15], Mat_ID[id_][i][15],
                OBJ_INFO[id_][i][move], 
                OBJ_INFO[id_][i][movex],
                OBJ_INFO[id_][i][movey],
                OBJ_INFO[id_][i][movez],
                OBJ_INFO[id_][i][ospeed]
                );
				OBJ_INFO[id_][i][O_ID] = CreateDynamicObject(OBJ_INFO[id_][i][O_MODEL_ID], OBJ_INFO[id_][i][O_PosX], OBJ_INFO[id_][i][O_PosY], OBJ_INFO[id_][i][O_PosZ], OBJ_INFO[id_][i][O_RotX], OBJ_INFO[id_][i][O_RotY], OBJ_INFO[id_][i][O_RotZ]);
			    if(OBJ_INFO[id_][i][move]) MoveDynamicObject(OBJ_INFO[id_][i][O_ID], OBJ_INFO[id_][i][movex], OBJ_INFO[id_][i][movey], OBJ_INFO[id_][i][movez], OBJ_INFO[id_][i][ospeed], OBJ_INFO[id_][i][O_RotX], OBJ_INFO[id_][i][O_RotY], OBJ_INFO[id_][i][O_RotZ]);
                for(new k = 0; k < MAX_INDEX; k++)
                {
                    if(Mat_USED[id_][i][k]) SetDynamicObjectMaterial(OBJ_INFO[id_][i][O_ID], k, ObjectTextures[Mat_ID[id_][i][k]][TModel], ObjectTextures[Mat_ID[id_][i][k]][TXDName], ObjectTextures[Mat_ID[id_][i][k]][TextureName]);
                    format(str_, sizeof(str_), "%i_%i_MaterialText_Info", i, k);
                    if(dini_Isset(str, str_))
                    {
                        Mat_TUSED[id_][i][k] = 1;
                        sscanf(dini_Get(str, str_), "s["#MAX_MATTEXT_SIZE"]iiiiiii", t, Mat_TMSIZE[id_][i][k], Mat_TFONT[id_][i][k], Mat_TSIZE[id_][i][k], Mat_TBOLD[id_][i][k], Mat_TCOL[id_][i][k], Mat_TBACKCOL[id_][i][k], Mat_TALIGN[id_][i][k]);
                        SetMatTextInIndex(id_, i, k, t);
                        strreplace(t, "`", " ");
                        SetDynamicObjectMaterialText(OBJ_INFO[id_][i][O_ID], k, t, Mat_TMSIZE[id_][i][k], Fonts[Mat_TFONT[id_][i][k]], Mat_TSIZE[id_][i][k], Mat_TBOLD[id_][i][k], Mat_TCOL[id_][i][k], Mat_TBACKCOL[id_][i][k], Mat_TALIGN[id_][i][k]);
                    }
                }
            }
		}
	}

	for(new i = 0; i < MAX_ACT; i ++)
	{
		ACT_INFO[id_][i][A_ID] = -1;
		ACT_INFO[id_][i][A_SKIN] = -1;
		ACT_INFO[id_][i][A_PosX] = -1;
		ACT_INFO[id_][i][A_PosY] = -1;
		ACT_INFO[id_][i][A_PosZ] = -1;
		ACT_INFO[id_][i][A_Ang] = -1;
        ACT_INFO[id_][i][animused] = 0;
        ACT_INFO[id_][i][animid] = -1;
	}

	MAP_INFO[id_][total_actors] = dini_Int(str, "Total_Actors");

	if(MAP_INFO[id_][total_actors] > 0)
	{
		new str_[50], info[128];
		for(new i = 0; i < MAX_ACT; i ++)
		{
			format(str_, sizeof(str_), "%i_Actor_Info", i);
			if(dini_Isset(str, str_)) 
			{
				format(info, sizeof(info), "%s", dini_Get(str, str_));
				sscanf(info, "iffffii", ACT_INFO[id_][i][A_SKIN], ACT_INFO[id_][i][A_PosX], ACT_INFO[id_][i][A_PosY], ACT_INFO[id_][i][A_PosZ], ACT_INFO[id_][i][A_Ang], ACT_INFO[id_][i][animused], ACT_INFO[id_][i][animid]);
				ACT_INFO[id_][i][A_ID] = CreateDynamicActor(ACT_INFO[id_][i][A_SKIN], ACT_INFO[id_][i][A_PosX], ACT_INFO[id_][i][A_PosY], ACT_INFO[id_][i][A_PosZ], ACT_INFO[id_][i][A_Ang]);
			    if(ACT_INFO[id_][i][animused]) ApplyDynamicActorAnimation(ACT_INFO[id_][i][A_ID], AnimationData[ACT_INFO[id_][i][animid]][animlib], AnimationData[ACT_INFO[id_][i][animid]][animname], 4.0,1,0,0,0,-1);
            }
		}
	}

    for(new i = 0; i < MAX_VEH; i ++)
    {
        VEH_INFO[id_][i][V_ID] = -1;
        VEH_INFO[id_][i][V_MODEL_ID] = -1;
        VEH_INFO[id_][i][V_PosX] = -1;
        VEH_INFO[id_][i][V_PosY] = -1;
        VEH_INFO[id_][i][V_PosZ] = -1;
        VEH_INFO[id_][i][V_Ang] = -1;
    }

    MAP_INFO[id_][total_vehicles] = dini_Int(str, "Total_Vehicles");

    if(MAP_INFO[id_][total_vehicles] > 0)
    {
        new str_[50], info[128];
        for(new i = 0; i < MAX_VEH; i ++)
        {
            format(str_, sizeof(str_), "%i_Vehicle_Info", i);
            if(dini_Isset(str, str_)) 
            {
                format(info, sizeof(info), "%s", dini_Get(str, str_));
                sscanf(info, "iffffii", VEH_INFO[id_][i][V_MODEL_ID], VEH_INFO[id_][i][V_PosX], VEH_INFO[id_][i][V_PosY], VEH_INFO[id_][i][V_PosZ], VEH_INFO[id_][i][V_Ang], VEH_INFO[id_][i][V_Color1], VEH_INFO[id_][i][V_Color2]);
                VEH_INFO[id_][i][V_ID] = CreateVehicle(VEH_INFO[id_][i][V_MODEL_ID], VEH_INFO[id_][i][V_PosX], VEH_INFO[id_][i][V_PosY], VEH_INFO[id_][i][V_PosZ], VEH_INFO[id_][i][V_Ang], VEH_INFO[id_][i][V_Color1], VEH_INFO[id_][i][V_Color2], RESPAWN_DELAY);
            }
        }
    }

	format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" %i objects, %i actors and %i vehicles loaded! ( Map name: %s | Map ID: %i )",  MAP_INFO[id_][total_obj], MAP_INFO[id_][total_actors], MAP_INFO[id_][total_vehicles], mname, GetPlayerMapID(playerid, mname));
	SendClientMessage(playerid, -1, str);
	PLAYER_INFO[playerid][mLoaded]++;
	EDITOR_INFO[M_Loaded]++;
	return 1;
}

CMD:ulm(playerid, params[])
{
	new mname[20], mpass[20];
	if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps");
	if(sscanf(params, "s[20]s[20]", mname, mpass)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /ulm <name> <password>");
	if(strlen(mname) < 4 || strlen(mname) > 20) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Map name should have 4 - 20 characters");
	if(!IsValidMapName(mname)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Map name should only contain lower case letters or numbers");
	new str[128];
	format(str, sizeof(str), MAP_SAVE_PATH, mname);
	if(!dini_Exists(str)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" A map with this name does not exist");
	new ret;
	for(new i = 0; i < MAX_LOADABLE_MAPS_IN_SERVER; i++)
	{
		if(isequal(MAP_INFO[i][M_Name], mname)) ret = 1;
	}
	if(ret == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" This map isn't loaded");
	if(!isequal(mpass, dini_Get(str, "Password"))) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Wrong password!");
    new id_ = GetServerMapID(mname);
    if(MAP_INFO[id_][forview]) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" This map is loaded only for view! use /ulmv instead");
	
    SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_GREY" Your map has been successfully unloaded");
    new id__ = GetPlayerMapID(playerid, mname);
	
	new str_[128];
	

	if(PLAYER_INFO[playerid][cur_svr_mid] == id_ && PLAYER_INFO[playerid][labeled] == 1)
	{
		for(new i = 0; i < MAX_OBJ; i++)
		{
			if(IsValidDynamicObject(OBJ_INFO[id_][i][O_ID]))
			{
				if(IsValidDynamic3DTextLabel(OBJ_INFO[id_][i][O_LID]))
				{
					DestroyDynamic3DTextLabel(OBJ_INFO[id_][i][O_LID]);
				}
			}
		}

		for(new i = 0; i < MAX_ACT; i++)
		{
			if(IsValidDynamicActor(ACT_INFO[id_][i][A_ID]))
			{
				if(IsValidDynamic3DTextLabel(ACT_INFO[id_][i][A_LID]))
				{
					DestroyDynamic3DTextLabel(ACT_INFO[id_][i][A_LID]);
				}
			}
		}

        for(new i = 0; i < MAX_VEH; i++)
        {
            if(IsValidVehicle(VEH_INFO[id_][i][V_ID]))
            {
                if(IsValidDynamic3DTextLabel(VEH_INFO[id_][i][V_LID]))
                {
                    DestroyDynamic3DTextLabel(VEH_INFO[id_][i][V_LID]);
                }
            }
        }
	}

	new info[256];
	format(PLAYER_mName[playerid][id__], 20, "%s", "-1");
	dini_IntSet(str, "Total_Objects", MAP_INFO[id_][total_obj]);
	dini_IntSet(str, "Total_Actors", MAP_INFO[id_][total_actors]);
    dini_IntSet(str, "Total_Vehicles", MAP_INFO[id_][total_vehicles]);
	for(new j = 0; j < MAX_OBJ; j++)
	{
		format(str_, sizeof(str_), "%i_Object_Info", j);
		if(IsValidDynamicObject(OBJ_INFO[id_][j][O_ID]))
		{
			format(info, sizeof(info), "%i %f %f %f %f %f %f %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %f %f %f %f", OBJ_INFO[id_][j][O_MODEL_ID], OBJ_INFO[id_][j][O_PosX], OBJ_INFO[id_][j][O_PosY], OBJ_INFO[id_][j][O_PosZ], OBJ_INFO[id_][j][O_RotX], OBJ_INFO[id_][j][O_RotY], OBJ_INFO[id_][j][O_RotZ],
			Mat_USED[id_][j][0], Mat_ID[id_][j][0],
            Mat_USED[id_][j][1], Mat_ID[id_][j][1],
            Mat_USED[id_][j][2], Mat_ID[id_][j][2],
            Mat_USED[id_][j][3], Mat_ID[id_][j][3],
            Mat_USED[id_][j][4], Mat_ID[id_][j][4],
            Mat_USED[id_][j][5], Mat_ID[id_][j][5],
            Mat_USED[id_][j][6], Mat_ID[id_][j][6],
            Mat_USED[id_][j][7], Mat_ID[id_][j][7],
            Mat_USED[id_][j][8], Mat_ID[id_][j][8],
            Mat_USED[id_][j][9], Mat_ID[id_][j][9],
            Mat_USED[id_][j][10], Mat_ID[id_][j][10],
            Mat_USED[id_][j][11], Mat_ID[id_][j][11],
            Mat_USED[id_][j][12], Mat_ID[id_][j][12],
            Mat_USED[id_][j][13], Mat_ID[id_][j][13],
            Mat_USED[id_][j][14], Mat_ID[id_][j][14],
            Mat_USED[id_][j][15], Mat_ID[id_][j][15],
            OBJ_INFO[id_][j][move], 
            OBJ_INFO[id_][j][movex],
            OBJ_INFO[id_][j][movey],
            OBJ_INFO[id_][j][movez],
            OBJ_INFO[id_][j][ospeed]
            );
            dini_Set(str, str_, info);
            for(new k = 0; k < MAX_INDEX; k++)
            {
                format(str_, sizeof(str_), "%i_%i_MaterialText_Info", j, k);
                if(Mat_TUSED[id_][j][k]){
                    format(info, sizeof(info), "%s %i %i %i %i %i %i %i", GetMatTextInIndex(id_, j, k), Mat_TMSIZE[id_][j][k], Mat_TFONT[id_][j][k], Mat_TSIZE[id_][j][k], Mat_TBOLD[id_][j][k], Mat_TCOL[id_][j][k], Mat_TBACKCOL[id_][j][k], Mat_TALIGN[id_][j][k]);
                    dini_Set(str, str_, info);
                }
                else{
                    if(dini_Isset(str, str_))
                    {
                        dini_Unset(str, str_);
                    }
                }
            }

			DestroyDynamicObject(OBJ_INFO[id_][j][O_ID]);
		}
		else
		{
			if(dini_Isset(str, str_))
			{
				dini_Unset(str, str_);
                for(new k = 0; k < MAX_INDEX; k++)
                {
                    format(str_, sizeof(str_), "%i_%i_MaterialText_Info", j, k);
                    if(dini_Isset(str, str_))
                    {
                        dini_Unset(str, str_);
                    }
                }
			}
		}
	} 

	for(new j = 0; j < MAX_ACT; j++)
	{
		format(str_, sizeof(str_), "%i_Actor_Info", j);
		if(IsValidDynamicActor(ACT_INFO[id_][j][A_ID]))
		{
			format(info, sizeof(info), "%i %f %f %f %f %i %i", ACT_INFO[id_][j][A_SKIN], ACT_INFO[id_][j][A_PosX], ACT_INFO[id_][j][A_PosY], ACT_INFO[id_][j][A_PosZ], ACT_INFO[id_][j][A_Ang], ACT_INFO[id_][j][animused], ACT_INFO[id_][j][animid]);
			dini_Set(str, str_, info);

			DestroyDynamicActor(ACT_INFO[id_][j][A_ID]);
		}
		else
		{
			if(dini_Isset(str, str_))
			{
				dini_Unset(str, str_);
			}
		}
	} 

    for(new j = 0; j < MAX_VEH; j++)
    {
        format(str_, sizeof(str_), "%i_Vehicle_Info", j);
        if(IsValidVehicle(VEH_INFO[id_][j][V_ID]))
        {
            format(info, sizeof(info), "%i %f %f %f %f %i %i", VEH_INFO[id_][j][V_MODEL_ID], VEH_INFO[id_][j][V_PosX], VEH_INFO[id_][j][V_PosY], VEH_INFO[id_][j][V_PosZ], VEH_INFO[id_][j][V_Ang], VEH_INFO[id_][j][V_Color1], VEH_INFO[id_][j][V_Color2]);
            dini_Set(str, str_, info);

            DestroyVehicle(VEH_INFO[id_][j][V_ID]);
        }
        else
        {
            if(dini_Isset(str, str_))
            {
                dini_Unset(str, str_);
            }
        }
    } 

	format(str, sizeof(str), ""#COL_BLUE"|GEditor| "#COL_YELLOW"%i objects, %i actors and %i vehicles unloaded! ( Map name: %s | Map ID: %i )", MAP_INFO[id_][total_obj], MAP_INFO[id_][total_actors], MAP_INFO[id_][total_vehicles], mname, id__);
	SendClientMessage(playerid, -1, str);

	format(MAP_INFO[id_][M_Name], 20, "%s", "-1");
	MAP_INFO[id_][total_obj] = 0;
	MAP_INFO[id_][total_actors] = 0;
    MAP_INFO[id_][total_vehicles] = 0;
	PLAYER_INFO[playerid][mLoaded]--;
	EDITOR_INFO[M_Loaded]--;

	if(PLAYER_INFO[playerid][mLoaded] > 0)
	{
		new lid = -1;
		for(new i = 0; i < MAX_LOADABLE_MAPS_AT_ONCE; i++)
		{
			if(!isequal(PLAYER_mName[playerid][i], "-1"))
			{
				lid = i;
			}
		}
		PLAYER_INFO[playerid][cur_player_mid] = lid;
		if(lid != -1) PLAYER_INFO[playerid][cur_svr_mid] = GetServerMapID(PLAYER_mName[playerid][lid]);
        else PLAYER_INFO[playerid][cur_svr_mid] = -1; 
		PLAYER_INFO[playerid][editing] = 0;
		PLAYER_INFO[playerid][cur_obj] = -1;	
		PLAYER_INFO[playerid][cur_act] = -1;	
        PLAYER_INFO[playerid][cur_act] = -1;

		if(PLAYER_INFO[playerid][labeled] == 1)
		{
			for(new i = 0; i < MAX_OBJ; i ++)
			{
				if(IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID]))
				{
					format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"Model ID: "#COL_RED"%i", i, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_MODEL_ID]);
					OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID] = CreateDynamic3DTextLabel(str, -1, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosX], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosY], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosZ], LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
                }
			}

			for(new i = 0; i < MAX_ACT; i ++)
			{
				if(IsValidDynamicActor(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_ID]))
				{
					format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"Skin ID: "#COL_RED"%i", i, ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_SKIN]);
					ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_LID] = CreateDynamic3DTextLabel(str, -1, ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_PosX], ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_PosY], ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_PosZ], LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
				}
			}	

            for(new i = 0; i < MAX_VEH; i ++)
            {
                if(IsValidVehicle(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_ID]))
                {
                    format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"Model ID: "#COL_RED"%i", i, VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_MODEL_ID]);
                    VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_LID] = CreateDynamic3DTextLabel(str, -1, VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_PosX], VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_PosY], VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_PosZ], LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_ID], 0, -1, -1, playerid);
                }
            }                 
		}	
	}
	else
	{
		PLAYER_INFO[playerid][cur_player_mid] = -1;
		PLAYER_INFO[playerid][cur_svr_mid] = -1;
		PLAYER_INFO[playerid][editing] = 0;
		PLAYER_INFO[playerid][cur_obj] = -1;
		PLAYER_INFO[playerid][cur_act] = -1;
		PLAYER_INFO[playerid][labeled] = 0;
	}
    
   	for(new i = 0; i < MAX_OBJ; i ++)
   	{
  		OBJ_INFO[id_][i][O_ID] = -1;
		OBJ_INFO[id_][i][O_MODEL_ID] = -1;
		OBJ_INFO[id_][i][O_PosX] = -1;
		OBJ_INFO[id_][i][O_PosY] = -1;
		OBJ_INFO[id_][i][O_PosZ] = -1;
		OBJ_INFO[id_][i][O_RotX] = -1;
		OBJ_INFO[id_][i][O_RotY] = -1;
		OBJ_INFO[id_][i][O_RotZ] = -1;
   	}    

   	for(new i = 0; i < MAX_ACT; i ++)
	{
		ACT_INFO[id_][i][A_ID] = -1;
		ACT_INFO[id_][i][A_SKIN] = -1;
		ACT_INFO[id_][i][A_PosX] = -1;
		ACT_INFO[id_][i][A_PosY] = -1;
		ACT_INFO[id_][i][A_PosZ] = -1;
		ACT_INFO[id_][i][A_Ang] = -1;
	}

    for(new i = 0; i < MAX_VEH; i ++)
    {
        VEH_INFO[id_][i][V_ID] = -1;
        VEH_INFO[id_][i][V_MODEL_ID] = -1;
        VEH_INFO[id_][i][V_PosX] = -1;
        VEH_INFO[id_][i][V_PosY] = -1;
        VEH_INFO[id_][i][V_PosZ] = -1;
        VEH_INFO[id_][i][V_Ang] = -1;
    }
	return 1;
}

CMD:em(playerid, params[])
{		
	if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
	new str[1024];
	format(str, sizeof(str), "Map ID\tMap Name\t      \n");
	for(new i = 0; i < MAX_LOADABLE_MAPS_AT_ONCE; i ++)
	{
		if(!isequal(PLAYER_mName[playerid][i], "-1"))
		{
			new str_[128];
			if(PLAYER_INFO[playerid][cur_player_mid] == i) format(str_, sizeof(str_), "%i\t%s\t"#COL_GREEN"Active\n", i, PLAYER_mName[playerid][i]);
			else format(str_, sizeof(str_), "%i\t%s\t"#COL_GREEN"      \n", i, PLAYER_mName[playerid][i]);
			strcat(str, str_, sizeof(str));
		}
	}
	ShowPlayerDialog(playerid, DIALOG_EDIT_MAP, DIALOG_STYLE_TABLIST_HEADERS, "GEditor - Choose a Map for editing", str, "Edit", "Close");
	return 1;
}

CMD:export(playerid, params[])
{
    new mname[20], mpass[20];
    if(sscanf(params, "s[20]s[20]", mname, mpass)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /export <map name> <map password>");
    new str[128];
    format(str, sizeof(str), MAP_SAVE_PATH, mname);
    if(!dini_Exists(str)) return SendClientMessage(playerid, -1,  ""#COL_BLUE"|GEditor|"#COL_RED" A map with this name does not exist");
    if(!isequal(mpass, dini_Get(str, "Password"))) return SendClientMessage(playerid, -1,  ""#COL_BLUE"|GEditor|"#COL_RED" Wrong password!");
    
    new str_[128];
    format(str_, sizeof(str_), MAP_EXPORT_PATH, mname);
    if(fexist(str_)) fremove(str_);

    new matid[MAX_INDEX];
    new matused[MAX_INDEX];

    new mattext[MAX_MATTEXT_SIZE],
        mattbold,
        mattsize,
        mattcol,
        mattbackcol,
        matsize,
        matalign,
        matfont
    ;

    new Float:x, Float:y, Float:z;
    new move_, Float:speed_;
    
    new File:file = fopen(str_, io_append);
    new savestr[256], idx[50];
    new model, Float:ox, Float:oy, Float:oz, Float:rx, Float:ry, Float:rz;
    format(savestr, sizeof(savestr), "/*\nExported using MapForce MapEditor\n---------------------------------\nCreator: %s\nCreated On: %s\nObjects: %i\nVehicles: %i\nActors: %i\n*/\r\n\r\n//Objects\r\nnew objid;\r\n"
    , dini_Get(str, "Creator"), dini_Get(str, "Date_Created"), dini_Int(str, "Total_Objects"), dini_Int(str, "Total_Vehicles"), dini_Int(str, "Total_Actors"));
    for(new i = 0; i < MAX_OBJ; i++)
    {
        format(idx, sizeof(idx), "%i_Object_Info", i);
        if(dini_Isset(str, idx))
        {
            sscanf(dini_Get(str, idx), "iffffffiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiffff", model, ox, oy, oz, rx, ry, rz, 
            matused[0], matid[0],
            matused[1], matid[1],
            matused[2], matid[2],
            matused[3], matid[3],
            matused[4], matid[4],
            matused[5], matid[5],
            matused[6], matid[6],
            matused[7], matid[7],
            matused[8], matid[8],
            matused[9], matid[9],
            matused[10],matid[10],
            matused[11],matid[11],
            matused[12],matid[12],
            matused[13],matid[13],
            matused[14],matid[14],
            matused[15],matid[15],
            move_,
            x,
            y, 
            z,
            speed_); 
            format(savestr, sizeof(savestr), "objid = CreateDynamicObject(%i, %f, %f, %f, %f, %f, %f);\r\n", model, ox, oy, oz, rx, ry, rz);
            fwrite(file, savestr);
            for(new k = 0; k < MAX_INDEX; k++)
            {
                if(matused[k])
                {
                    format(savestr, sizeof(savestr), "SetDynamicObjectMaterial(objid, %i, %i, %s, %s);\r\n", k, ObjectTextures[matid[k]][TModel], ObjectTextures[matid[k]][TXDName], ObjectTextures[matid[k]][TextureName]);
                    fwrite(file, savestr);
                }
                format(idx, sizeof(idx), "%i_%i_MaterialText_Info", i, k);
                if(dini_Isset(str, idx))
                {
                    sscanf(dini_Get(str, idx), "s["#MAX_MATTEXT_SIZE"]iiiiiii", mattext, matsize, matfont, mattsize, mattbold, mattcol, mattbackcol, matalign);
                    strreplace(mattext, "`", " ");
                    format(savestr, sizeof(savestr), "SetDynamicObjectMaterialText(objid, %i, \"%s\", %i, \"%s\", %i, %i, 0x%x, 0x%x, %i);\r\n", k, mattext, matsize, Fonts[matfont], mattsize, mattbold, mattcol, mattbackcol, matalign);
                    fwrite(file, savestr);
                }
            } 
            if(move_)
            {
                format(savestr, sizeof(savestr), "MoveDynamicObject(objid, %f, %f, %f, %f, %f, %f, %f);\r\n", x, y, z, speed_, rx, ry, rz);
                fwrite(file, savestr);
            }
        }

    }

    fwrite(file, "\r\n//Actors\r\n");
    fwrite(file, "new actorid;\r\n");
    for(new i = 0; i < MAX_ACT; i++)
    {
        format(idx, sizeof(idx), "%i_Actor_Info", i);
        if(dini_Isset(str, idx))
        {
            sscanf(dini_Get(str, idx), "iffffii", model, ox, oy, oz, rx, matsize, mattcol);
            format(savestr, sizeof(savestr), "actorid = CreateDynamicActor(%i, %f, %f, %f, %f);\r\n", model, ox, oy, oz, rx);
            fwrite(file, savestr);
            if(matsize)
            {
                format(savestr, sizeof(savestr), "ApplyDynamicActorAnimation(actorid, \"%s\", \"%s\", 4.0, 1, 0, 0, 0, -1);\r\n", AnimationData[mattcol][animlib], AnimationData[mattcol][animname]);
                fwrite(file, savestr);
            }
        }   
    }
   
    fwrite(file, "\r\n//Vehicles\r\n");
    for(new i = 0; i < MAX_VEH; i ++)
    {
        format(idx, sizeof(idx), "%i_Vehicle_Info", i);
        if(dini_Isset(str, idx))
        { 
            sscanf(dini_Get(str, idx), "iffffii", model, ox, oy, oz, rx, ry, rz);
            format(savestr, sizeof(savestr), "AddStaticVehicleEx(%i, %f, %f, %f, %f, %i, %i, "#RESPAWN_DELAY");\r\n", model, ox, oy, oz, rx, ry, rz);
            fwrite(file, savestr);
        }
    }

    fclose(file);

    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_GREY" Map '%s' exported to '/scriptfiles%s'", mname, str_);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:mpass(playerid, params[])
{
	new opass[20], npass[20], str[128];
	if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
	if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
	if(sscanf(params, "s[20]s[20]", opass, npass)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /mpass <old password> <new password>");
	if(strlen(npass) > 20 || strlen(npass) < 4) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Map password should contain 4 - 20 characters");
	format(str, sizeof(str), MAP_SAVE_PATH, PLAYER_mName[playerid][PLAYER_INFO[playerid][cur_player_mid]]);
	new ropass[20];
	format(ropass, sizeof(ropass), "%s", dini_Get(str, "Password"));
	if(!isequal(opass, ropass)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Wrong password!");
	if(strlen(npass) > 20 || strlen(npass) < 4) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Map password shoul contain 4 - 20 characters");
	dini_Set(str, "Password", npass);
	format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_GREY" You changed the password of map '%s' ( new password: %s )", PLAYER_mName[playerid][PLAYER_INFO[playerid][cur_player_mid]], npass);
	SendClientMessage(playerid, -1, str);
	return 1; 
}

CMD:mr(playerid, params[])
{
	new nname[20];
	if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
	if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
	if(sscanf(params, "s[20]", nname)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /mrename <new name>");
	if(strlen(nname) > 20 || strlen(nname) < 4) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Map name should contain 4 - 20 characters");
	if(!IsValidMapName(nname)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Map name can contain only lowercase letters with numbers");

	new str[50];
	format(str, sizeof(str), MAP_SAVE_PATH, PLAYER_mName[playerid]);
	
	new str_[50];
	format(str_, sizeof(str_), MAP_SAVE_PATH, nname);
	frename(str, str_);

	format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_GREY" You changed the name of map '%s' ( new name: %s )", PLAYER_mName[playerid][PLAYER_INFO[playerid][cur_player_mid]], nname);
	SendClientMessage(playerid, -1, str);

    for(new i = 0; i < MAX_CREATABLE_MAPS_IN_SERVER; i++)
    {
	   format(str, sizeof(str), "%i_Map", nname);
       if(isequal(nname, dini_Get(MAP_EDITOR_CONF_PATH, str)))
       {
            dini_Set(MAP_EDITOR_CONF_PATH, str, nname);
            break;
       }
    }

	format(MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][M_Name], 20, "%s", nname);
	format(PLAYER_mName[playerid][PLAYER_INFO[playerid][cur_player_mid]], 20, "%s", nname);
	return 1;
}

CMD:md(playerid, params[])
{
    new name[20], pass[20];
    if(sscanf(params, "s[20]s[20]", name, pass)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /md <map name> <map pass>");
    if(isequal(name, "-1")) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" A map with this name does not exist!");

    for(new i = 0; i < MAX_LOADABLE_MAPS_IN_SERVER; i++)
    {
        if(isequal(name, MAP_INFO[i][M_Name])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Someone has loaded this map, You can't delete it until he/she unloads the map!");
    }

    new str[128], path[128], removed;
    for(new i = 0; i < MAX_CREATABLE_MAPS_IN_SERVER; i++)
    {
        format(str, sizeof(str), "%i_Map", i + 1);
        if(dini_Isset(MAP_EDITOR_CONF_PATH, str))
        {
            if(isequal(dini_Get(MAP_EDITOR_CONF_PATH, str), name))
            {
                format(path, sizeof(path), MAP_SAVE_PATH, dini_Get(MAP_EDITOR_CONF_PATH, str));
                if(!isequal(dini_Get(path, "Password"), pass)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Wrong password!");
                dini_Remove(path);
                dini_Unset(MAP_EDITOR_CONF_PATH, str);
                removed = 1;
            }
        }
    }

    if(!removed) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" A map with this name does not exist!");
    SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_GREY" Map deleted successfully!");
    return 1;
}

CMD:maps(playerid, params[])
{
    new name[MAX_PLAYER_NAME], val = -1;
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You don't have permissons to use this command");
    for(new i = 0; i < MAX_MAPS_THAT_CAN_BE_CREATED_BY_A_USER; i++)
    {
        format(mDialog[playerid][i], 20, "%s", "-1");
    }
    if(sscanf(params, "s[24]", name)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /mpas <name>");
    new str[128];
    new line[128], path[50], dialog[1024], count = -1;
    for(new i = 0; i < MAX_CREATABLE_MAPS_IN_SERVER; i++)
    {
        format(str, sizeof(str), "%i_Map", i);
        if(dini_Isset(MAP_EDITOR_CONF_PATH, str))
        {
            format(path, sizeof(path), MAP_SAVE_PATH, dini_Get(MAP_EDITOR_CONF_PATH, str));
            if(dini_Exists(path))
            {
                if(isequal(name, dini_Get(path, "Creator")))
                {
                    val = 1;
                    count ++;
                    format(line, sizeof(line), "%s\n", dini_Get(MAP_EDITOR_CONF_PATH, str));
                    format(mDialog[playerid][count], 20, "%s", dini_Get(MAP_EDITOR_CONF_PATH, str));
                    strcat(dialog, line, sizeof(dialog));
                }
            }
        }
    }
    if(val == -1)
    {
        format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_RED" Player '%s' haven't created any maps", name);
        return SendClientMessage(playerid, -1, str);
    }
    SaveMapData();
    format(str, sizeof(str), "GEditor - Maps created by '%s'", name);
    ShowPlayerDialog(playerid, DIALOG_MAPS, DIALOG_STYLE_LIST, str, dialog, "Select", "Close");
    return 1;
}

CMD:label(playerid, params[])
{
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing"); 
    if(PLAYER_INFO[playerid][labeled] == 0)
    {
        new str[128];
        PLAYER_INFO[playerid][labeled] = 1;
        for(new i = 0; i < MAX_OBJ; i ++)
        {
            if(IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID]))
            {
                if(i != PLAYER_INFO[playerid][cur_obj])
                {
                    format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"Model ID: "#COL_RED"%i", i, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_MODEL_ID]);
                    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID] = CreateDynamic3DTextLabel(str, -1, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosX], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosY], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosZ], LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
                }
            }
        }
        for(new i = 0; i < MAX_ACT; i ++)
        {
            if(IsValidDynamicActor(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_ID]))
            {
                if(i != PLAYER_INFO[playerid][cur_act])
                {
                    format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"skin ID: "#COL_RED"%i", i, ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_SKIN]);
                    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_LID] = CreateDynamic3DTextLabel(str, -1, ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_PosX], ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_PosY], ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_PosZ], LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
                }
            }
        }
        for(new i = 0; i < MAX_VEH; i ++)
        {
            if(IsValidVehicle(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_ID]))
            {
                format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"Model ID: "#COL_RED"%i", i, VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_MODEL_ID]);
                VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_LID] = CreateDynamic3DTextLabel(str, -1, VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_PosX], VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_PosY], VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_PosZ], LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_ID], 0, -1, -1, playerid);
            }
        } 
        SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_GREY" Labels for current map has been added successfully!");
    }
    else
    {
        PLAYER_INFO[playerid][labeled] = 0;
        for(new i = 0; i < MAX_OBJ; i++)
        {
            if(IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID]))
            {
                if(i != PLAYER_INFO[playerid][cur_obj])
                {
                    DestroyDynamic3DTextLabel(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID]);
                }
            }
        }

        for(new i = 0; i < MAX_ACT; i++)
        {
            if(IsValidDynamicActor(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_ID]))
            {
                if(i != PLAYER_INFO[playerid][cur_act])
                {
                    DestroyDynamic3DTextLabel(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_LID]);
                } 
            } 
        }
        for(new i = 0; i < MAX_VEH; i ++)
        {
            if(IsValidVehicle(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_ID]))
            {
                DestroyDynamic3DTextLabel(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_LID]);
            }
        } 
        SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_GREY" Labels for current map has been removed successfully!");
    }

    return 1;
}

CMD:fontlist(playerid, params[])
{
    new str[128], str1[1024];
    strcat(str1, "{FFFFFF}ID\t\tName\n", sizeof(str1));
    for(new i = 0; i < sizeof(Fonts); i++)
    {
        format(str, sizeof(str), "%i\t\t{FFFFFF}%s\n", i + 1, Fonts[i]);
        strcat(str1, str, sizeof(str1));
    }
    ShowPlayerDialog(playerid, DIALOG_CLOSE, DIALOG_STYLE_MSGBOX, "GEditor - Fonts", str1, "Close", "");
    return 1;
}

//Object commands!
CMD:osearch(playerid, params[])
{
    ShowPlayerDialog(playerid, DIALOG_MODEL_SEARCH, DIALOG_STYLE_INPUT, "GEditor - Search Object Models", "Input the whole name or part of the name\nof any object", "Search", "Close");
    return 1;
}

CMD:odc(playerid, params[])
{
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(PLAYER_INFO[playerid][cur_obj] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing");
    if(!IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing");
    
    DestroyDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID]);

    new str[128];
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You deleted the object ID %i ( model ID: %i )", PLAYER_INFO[playerid][cur_obj], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_MODEL_ID]);
    SendClientMessage(playerid, -1, str);

    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID] = -1; 
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_MODEL_ID] = -1;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosX] = -1;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosY] = -1;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosZ] = -1;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotX] = -1;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotY] = -1;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotZ] = -1;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][move] = 0;
    for(new k = 0; k < MAX_INDEX; k++)
    {
        Mat_USED[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k] = 0;
        Mat_TUSED[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k] = 0;
        Mat_TBOLD[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k] = 1; 
        Mat_TSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k] = 24;
        Mat_TCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k] = 0xFFFFFFFF;
        Mat_TBACKCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k] = 0;
        Mat_TALIGN[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k] = 0;
        Mat_TMSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k] = OBJECT_MATERIAL_SIZE_256x128;
        SetMatTextInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], k, "-1");
    }

    PLAYER_INFO[playerid][cur_obj] = -1;
    MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][total_obj]--;

    PLAYER_INFO[playerid][editing] = 0;
    return 1;
}

CMD:od(playerid, params[])
{
    new id;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /od <object ID>");
    if(id < 0 || id > MAX_OBJ) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid Object ID");
    if(!IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid object ID");
    if(id == PLAYER_INFO[playerid][cur_obj]) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You are currently editing this object ( use /od )");

    DestroyDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_ID]);

    new str[128];
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You deleted the object ID %i ( model ID: %i )", id, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_MODEL_ID]);
    SendClientMessage(playerid, -1, str);

    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_ID] = -1; 
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_MODEL_ID] = -1;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_PosX] = -1;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_PosY] = -1;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_PosZ] = -1;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_RotX] = -1;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_RotY] = -1;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_RotZ] = -1;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][move] = 0;
    for(new k = 0; k < MAX_INDEX; k++)
    {
        Mat_USED[PLAYER_INFO[playerid][cur_svr_mid]][id][k] = 0;
        Mat_TUSED[PLAYER_INFO[playerid][cur_svr_mid]][id][k] = 0;
        Mat_TBOLD[PLAYER_INFO[playerid][cur_svr_mid]][id][k] = 1; 
        Mat_TSIZE[PLAYER_INFO[playerid][cur_svr_mid]][id][k] = 24;
        Mat_TCOL[PLAYER_INFO[playerid][cur_svr_mid]][id][k] = 0xFFFFFFFF;
        Mat_TBACKCOL[PLAYER_INFO[playerid][cur_svr_mid]][id][k] = 0;
        Mat_TALIGN[PLAYER_INFO[playerid][cur_svr_mid]][id][k] = 0;
        Mat_TMSIZE[PLAYER_INFO[playerid][cur_svr_mid]][id][k] = OBJECT_MATERIAL_SIZE_256x128;
        SetMatTextInIndex(PLAYER_INFO[playerid][cur_svr_mid], id, k, "-1");
    }

    MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][total_obj]--;

    if(PLAYER_INFO[playerid][labeled] == 1)
    {
        if(IsValidDynamic3DTextLabel(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_LID])) DestroyDynamic3DTextLabel(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_LID]);
    }
    return 1;
}

CMD:ox(playerid, params[])
{
    new Float:X;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(PLAYER_INFO[playerid][cur_obj] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing");
    if(!IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing");
    if(sscanf(params, "f", X)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /ox <X cordinate>");

    SetDynamicObjectPos(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosX] + X, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosY], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosZ]);
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosX] += X;

    new str[128];
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You have changed the X cordinate of Object ID %i by %f", PLAYER_INFO[playerid][cur_obj], X);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:oy(playerid, params[])
{
    new Float:Y;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(PLAYER_INFO[playerid][cur_obj] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing");
    if(!IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing");
    if(sscanf(params, "f", Y)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /oy <Y cordinate>");

    SetDynamicObjectPos(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosX], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosY] + Y, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosZ]);
    
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosY] += Y;
    
    new str[128];
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You have changed the Y cordinate of Object ID %i by %f", PLAYER_INFO[playerid][cur_obj], Y);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:oz(playerid, params[])
{
    new Float:Z;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(PLAYER_INFO[playerid][cur_obj] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing");
    if(!IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing");
    if(sscanf(params, "f", Z)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /oz <Z cordinate>");

    SetDynamicObjectPos(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosX], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosY], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosZ] + Z);
    
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosZ] += Z;

    new str[128];
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You have changed the Z cordinate of Object ID %i by %f", PLAYER_INFO[playerid][cur_obj], Z);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:rx(playerid, params[])
{
    new Float:rx;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(PLAYER_INFO[playerid][cur_obj] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing");
    if(!IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing");
    if(sscanf(params, "f", rx)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /rx <X rotation>");

    SetDynamicObjectRot(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotX] + rx, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotY], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotZ]);
    
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotX] += rx;

    new str[128];
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You have changed the X rotation of Object ID %i by %f", PLAYER_INFO[playerid][cur_obj], rx);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:ry(playerid, params[])
{
    new Float:ry;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(PLAYER_INFO[playerid][cur_obj] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing");
    if(!IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing");
    if(sscanf(params, "f", ry)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /ry <Y rotation>");

    SetDynamicObjectRot(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotX], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotY] + ry, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotZ]);
    
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotY] += ry;

    new str[128];
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You have changed the Y rotation of Object ID %i by %f", PLAYER_INFO[playerid][cur_obj], ry);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:rz(playerid, params[])
{
    new Float:rz;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(PLAYER_INFO[playerid][cur_obj] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing");
    if(!IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing");
    if(sscanf(params, "f", rz)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /rz <Z rotation>");

    SetDynamicObjectRot(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotX], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotY], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotZ] + rz);
    
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotZ] += rz;

    new str[128];
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You have changed the Z rotation of Object ID %i by %f", PLAYER_INFO[playerid][cur_obj], rz);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:aox(playerid, params[])
{
    new Float:X;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(sscanf(params, "f", X)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /aox <X cordinate>");

    new str[128];
    for(new i = 0; i < MAX_OBJ; i++)
    {
        if(IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID])) 
        {
            SetDynamicObjectPos(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosX] + X, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosY], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosZ]);
            OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosX] += X;
            if(PLAYER_INFO[playerid][labeled])
            {
                if(IsValidDynamic3DTextLabel(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID]))
                {
                    DestroyDynamic3DTextLabel(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID]);
                    format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"Model ID: "#COL_RED"%i", i, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_MODEL_ID]);
                    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID] = CreateDynamic3DTextLabel(str, -1, 
                        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosX], 
                        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosY], 
                        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosZ],
                        LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
                }
            }
        }
    }

    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You have changed the X cordinate of all objects by %f", X);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:aoy(playerid, params[])
{
    new Float:Y;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(sscanf(params, "f", Y)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /aoy <Y cordinate>");

    new str[128];
    for(new i = 0; i < MAX_OBJ; i++)
    {
        if(IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID])) 
        {
            SetDynamicObjectPos(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosX], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosY] + Y, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosZ]);
            OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosY] += Y;
            if(PLAYER_INFO[playerid][labeled])
            {
                if(IsValidDynamic3DTextLabel(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID]))
                {
                    DestroyDynamic3DTextLabel(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID]);
                    format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"Model ID: "#COL_RED"%i", i, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_MODEL_ID]);
                    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID] = CreateDynamic3DTextLabel(str, -1, 
                        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosX], 
                        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosY], 
                        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosZ],
                        LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
                }
            }
        }
    }       

    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You have changed the Y cordinate of all objects by %f", Y);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:aoz(playerid, params[])
{
    new Float:Z;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(sscanf(params, "f", Z)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /aoz <Z cordinate>");

    new str[128];
    for(new i = 0; i < MAX_OBJ; i++)
    {
        if(IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID])) 
        {
            SetDynamicObjectPos(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosX], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosY], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosZ] + Z);
            OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosZ] += Z;
            if(PLAYER_INFO[playerid][labeled])
            {
                if(IsValidDynamic3DTextLabel(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID]))
                {
                    DestroyDynamic3DTextLabel(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID]);
                    format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"Model ID: "#COL_RED"%i", i, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_MODEL_ID]);
                    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID] = CreateDynamic3DTextLabel(str, -1, 
                        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosX], 
                        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosY], 
                        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosZ],
                        LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
                }
            }
        }
    }
    
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You have changed the Z cordinate of all objects by %f", Z);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:arx(playerid, params[])
{
    new Float:rx;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(sscanf(params, "f", rx)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /arx <X rotation>");

    new str[128];
    for(new i = 0; i < MAX_OBJ; i++)
    {
        if(IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID])) 
        {
            SetDynamicObjectRot(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID],OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_RotX] +  rx, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_RotY], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_RotZ]);
            OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_RotX] += rx;
            if(PLAYER_INFO[playerid][labeled])
            {
                if(IsValidDynamic3DTextLabel(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID]))
                {
                    DestroyDynamic3DTextLabel(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID]);
                    format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"Model ID: "#COL_RED"%i", i, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_MODEL_ID]);
                    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID] = CreateDynamic3DTextLabel(str, -1, 
                        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosX], 
                        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosY], 
                        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosZ],
                        LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
                }
            }
        }
    }

    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You have set the X rotation of all objects by %f", rx);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:ary(playerid, params[])
{
    new Float:ry;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(sscanf(params, "f", ry)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /ary <Y rotation>");

    new str[128];
    for(new i = 0; i < MAX_OBJ; i++)
    {
        if(IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID])) 
        {
            SetDynamicObjectRot(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_RotX], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_RotY] + ry, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_RotZ]);
            OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_RotY] += ry;
            if(PLAYER_INFO[playerid][labeled])
            {
                if(IsValidDynamic3DTextLabel(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID]))
                {
                    DestroyDynamic3DTextLabel(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID]);
                    format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"Model ID: "#COL_RED"%i", i, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_MODEL_ID]);
                    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID] = CreateDynamic3DTextLabel(str, -1, 
                        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosX], 
                        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosY], 
                        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosZ],
                        LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
                }
            }
        }

    }

    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You have set the Y rotation of all objects by %f", ry);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:arz(playerid, params[])
{
    new Float:rz;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(sscanf(params, "f", rz)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /arz <Z rotation>");

    new str[128];
    for(new i = 0; i < MAX_OBJ; i++)
    {
        if(IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID])) 
        {
            SetDynamicObjectRot(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_RotX], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_RotY], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_RotZ] + rz);
            OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_RotZ] += rz;
            if(PLAYER_INFO[playerid][labeled])
            {
                if(IsValidDynamic3DTextLabel(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID]))
                {
                    DestroyDynamic3DTextLabel(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID]);
                    format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"Model ID: "#COL_RED"%i", i, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_MODEL_ID]);
                    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID] = CreateDynamic3DTextLabel(str, -1, 
                        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosX], 
                        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosY], 
                        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_PosZ],
                        LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
                }
            }
        }
    }

    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You have set the Z rotation of all objects by %f", rz);
    SendClientMessage(playerid, -1, str);
    return 1;
}                                             

CMD:oc(playerid, params[])
{
    new model;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(MAP_INFO[PLAYER_INFO[playerid][cur_player_mid]][total_obj] == MAX_OBJ) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You have reached the maximum amout of objects that can be created in one map (Limit: "#MAX_OBJ")");
    if(sscanf(params, "i", model)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /oc <model ID>");
    if(!IsIDEValid(model)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid model ID");
    new Float:x, Float:y, Float:z, Float:xp, Float:yp;
    GetXYInFrontOfPlayer(playerid, x, y, 8.0);
    GetPlayerPos(playerid, xp, yp, z);
    new oid = -1;
    for(new i = 0; i < MAX_OBJ; i++)
    {
        if(!IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID]))
        {
            OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID] = CreateDynamicObject(model, x, y, z, 0, 0, 0);
            oid = i;
            break;
        }
    }

    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_MODEL_ID] = model;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_PosX] = x;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_PosY] = y;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_PosZ] = z;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_RotX] = 0;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_RotY] = 0;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_RotZ] = 0;

    MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][total_obj] ++;

    new str[128];
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Object successfully created! ( Map ID: %s(%i) | Object ID: %i | Model ID: %i )", MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][M_Name], PLAYER_INFO[playerid][cur_player_mid], oid, model);
    SendClientMessage(playerid, -1, str);

    if(PLAYER_INFO[playerid][labeled] == 1)
    {
        format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"Model ID: "#COL_RED"%i", oid, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_MODEL_ID]);
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_LID] = CreateDynamic3DTextLabel(str, -1, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_PosX], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_PosY], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_PosZ], LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
    }

    format(str, sizeof(str), "/oe %i", oid);
    PC_EmulateCommand(playerid, str);
    return 1;
}

CMD:ocopy(playerid, params[])
{
    new id;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /ocopy <object ID>");    
    if(id < 0 || id >= MAX_OBJ) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid object ID");   
    if(!IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid object ID");   
    COPY_BUF[playerid][mapid] = PLAYER_INFO[playerid][cur_svr_mid];
    COPY_BUF[playerid][objid] = id;
    return 1;
}

CMD:opaste(playerid, params[])
{
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(!IsValidDynamicObject(OBJ_INFO[COPY_BUF[playerid][mapid]][COPY_BUF[playerid][objid]][O_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Data object copied has been destroyed! Unable to sync!!!");   
    if(PLAYER_INFO[playerid][cur_obj] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing");
    new str[128];
    for(new k = 0; k < MAX_INDEX; k++)
    {
        if(Mat_USED[COPY_BUF[playerid][mapid]][COPY_BUF[playerid][objid]][k])
        {
            SetDynamicObjectMaterial(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID], k, 
                ObjectTextures[Mat_ID[COPY_BUF[playerid][mapid]][COPY_BUF[playerid][objid]][k]][TModel],
                ObjectTextures[Mat_ID[COPY_BUF[playerid][mapid]][COPY_BUF[playerid][objid]][k]][TXDName],
                ObjectTextures[Mat_ID[COPY_BUF[playerid][mapid]][COPY_BUF[playerid][objid]][k]][TextureName]);

            Mat_USED[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k] = 1;
            Mat_ID[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k] = Mat_ID[COPY_BUF[playerid][mapid]][COPY_BUF[playerid][objid]][k];
        }
 
        if(Mat_TUSED[COPY_BUF[playerid][mapid]][COPY_BUF[playerid][objid]][k])
        {
            format(str, sizeof(str), "%s", GetMatTextInIndex(COPY_BUF[playerid][mapid], COPY_BUF[playerid][objid], k));
            SetMatTextInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], k, str);
            strreplace(str, "`", " ");
            SetDynamicObjectMaterialText(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID], k, str, 
                Mat_TMSIZE[COPY_BUF[playerid][mapid]][COPY_BUF[playerid][objid]][k], 
                Fonts[Mat_TFONT[COPY_BUF[playerid][mapid]][COPY_BUF[playerid][objid]][k]], 
                Mat_TSIZE[COPY_BUF[playerid][mapid]][COPY_BUF[playerid][objid]][k],  
                Mat_TBOLD[COPY_BUF[playerid][mapid]][COPY_BUF[playerid][objid]][k],  
                Mat_TCOL[COPY_BUF[playerid][mapid]][COPY_BUF[playerid][objid]][k], 
                Mat_TBACKCOL[COPY_BUF[playerid][mapid]][COPY_BUF[playerid][objid]][k],  
                Mat_TALIGN[COPY_BUF[playerid][mapid]][COPY_BUF[playerid][objid]][k]);

            Mat_TMSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k] = Mat_TMSIZE[COPY_BUF[playerid][mapid]][COPY_BUF[playerid][objid]][k]; 
            Mat_TFONT[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k] = Mat_TFONT[COPY_BUF[playerid][mapid]][COPY_BUF[playerid][objid]][k];
            Mat_TSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k] = Mat_TSIZE[COPY_BUF[playerid][mapid]][COPY_BUF[playerid][objid]][k];  
            Mat_TBOLD[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k] = Mat_TBOLD[COPY_BUF[playerid][mapid]][COPY_BUF[playerid][objid]][k];  
            Mat_TCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k] = Mat_TCOL[COPY_BUF[playerid][mapid]][COPY_BUF[playerid][objid]][k]; 
            Mat_TBACKCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k]  = Mat_TBACKCOL[COPY_BUF[playerid][mapid]][COPY_BUF[playerid][objid]][k];  
            Mat_TALIGN[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k] = Mat_TALIGN[COPY_BUF[playerid][mapid]][COPY_BUF[playerid][objid]][k];
        }
    }
    return 1;
}

CMD:omove(playerid, params[])
{
    new Float:ox, Float:oy, Float:oz, sec, id;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(sscanf(params, "ifffi", id, ox, oy, oz, sec)){
        SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /omove <object ID> <x> <y> <z> <seconds>");
        return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Time should be given in 'seconds'");
    }
    if(id < 0 || id >= MAX_OBJ) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid object ID");
    if(!IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid object ID");
    if(ox == 0 && oy == 0 && oz == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Object cannot move with '0' distance");
    if(sec == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Object cannot move in '0' seconds");

    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][move] = 1;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][movex] = OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_PosX] + ox; 
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][movey] = OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_PosY] + oy; 
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][movez] = OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_PosZ] + oz;  
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][ospeed] = (GetDistance(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosX], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosY], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosZ],
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][movex], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][movey], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][movez]) / sec);

    SetDynamicObjectPos(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_ID], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_PosX], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_PosY], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_PosZ]);
    
    MoveDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_ID], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_PosX], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_PosY], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_PosZ],  
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][ospeed], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][movex], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][movey],  
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][movez]); 
    return 1;
}

CMD:ostopmove(playerid, params[])
{
    new id;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /ostopmove <object ID>");
    if(!OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][move])  return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" This object is not moving!, use /omove");
    if(id < 0 || id >= MAX_OBJ) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid object ID");
    if(!IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid object ID");

    StopDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_ID]);
    SetDynamicObjectPos(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_ID], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_PosX],
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_PosY],
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_PosZ]
    );

    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][move] = 0;
    return 1;
}

CMD:oclone(playerid, params[])
{
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(PLAYER_INFO[playerid][cur_obj] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing");
    if(MAP_INFO[PLAYER_INFO[playerid][cur_player_mid]][total_obj] == MAX_OBJ) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You have reached the maximum amout of objects that can be created in one map (Limit: "#MAX_OBJ")");
    new Float:x, Float:y, Float:z, Float:xp, Float:yp;
    GetXYInFrontOfPlayer(playerid, x, y, 8.0);
    GetPlayerPos(playerid, xp, yp, z);
    new oid = -1;
    for(new i = 0; i < MAX_OBJECTS; i++)
    {
        if(!IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID]))
        {
            oid = i;
            OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID] = CreateDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_MODEL_ID], 0, 0, 0, 0, 0, 0);
            break;  
        }
    }

    SetDynamicObjectPos(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_ID], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosX], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosY], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosZ]);
    SetDynamicObjectRot(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_ID], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotX], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotY], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotZ]
    );
    
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_MODEL_ID] = OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_MODEL_ID];
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_PosX] =  OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosX];
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_PosY] =  OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosY];
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_PosZ] =  OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosZ];
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_RotX] =  OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotX];
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_RotY] =  OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotY];
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_RotZ] =  OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotZ];

    new str[128];
    for(new k = 0; k < MAX_INDEX; k++)
    {
        if(Mat_USED[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k])
        {
            SetDynamicObjectMaterial(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_ID], k, 
                ObjectTextures[Mat_ID[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k]][TModel],
                ObjectTextures[Mat_ID[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k]][TXDName],
                ObjectTextures[Mat_ID[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k]][TextureName]);

            Mat_USED[PLAYER_INFO[playerid][cur_svr_mid]][oid][k] = 1;
            Mat_ID[PLAYER_INFO[playerid][cur_svr_mid]][oid][k] = Mat_ID[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k];
        }

        if(Mat_TUSED[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k])
        {
            format(str, sizeof(str), "%s", GetMatTextInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], k));
            SetMatTextInIndex(PLAYER_INFO[playerid][cur_svr_mid], oid, k, str);
            strreplace(str, "`", " ");
            SetDynamicObjectMaterialText(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_ID], k, str, 
                Mat_TMSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k], 
                Fonts[Mat_TFONT[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k]], 
                Mat_TSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k],  
                Mat_TBOLD[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k],  
                Mat_TCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k], 
                Mat_TBACKCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k],  
                Mat_TALIGN[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k]);

            Mat_TMSIZE[PLAYER_INFO[playerid][cur_svr_mid]][oid][k] = Mat_TMSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k]; 
            Mat_TFONT[PLAYER_INFO[playerid][cur_svr_mid]][oid][k] = Mat_TFONT[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k];
            Mat_TSIZE[PLAYER_INFO[playerid][cur_svr_mid]][oid][k] = Mat_TSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k];  
            Mat_TBOLD[PLAYER_INFO[playerid][cur_svr_mid]][oid][k] = Mat_TBOLD[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k];  
            Mat_TCOL[PLAYER_INFO[playerid][cur_svr_mid]][oid][k] = Mat_TCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k]; 
            Mat_TBACKCOL[PLAYER_INFO[playerid][cur_svr_mid]][oid][k]  = Mat_TBACKCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k];  
            Mat_TALIGN[PLAYER_INFO[playerid][cur_svr_mid]][oid][k] = Mat_TALIGN[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k];
        }
    }
        
    MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][total_obj] ++;

    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Object successfully cloned! ( Map ID: %s(%i) | Object ID: %i | Model ID: %i )", MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][M_Name], PLAYER_INFO[playerid][cur_player_mid], oid, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_MODEL_ID]);
    SendClientMessage(playerid, -1, str);

    if(PLAYER_INFO[playerid][labeled] == 1)
    {
        format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"Model ID: "#COL_RED"%i", oid, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_MODEL_ID]);
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_LID] = CreateDynamic3DTextLabel(str, -1, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_PosX], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_PosY], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][oid][O_PosZ], LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
    }

    format(str, sizeof(str), "/oe %i", oid);
    PC_EmulateCommand(playerid, str);
    return 1;
}

CMD:omodel(playerid, params[])
{
    new model;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(PLAYER_INFO[playerid][cur_obj] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing");
    if(sscanf(params, "i", model)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /omodel <new model ID>");
    if(!IsIDEValid(model)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid model ID");
    if(model == OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_MODEL_ID]) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" This the same model ID that object holds now!"); 

    DestroyDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID]);
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_MODEL_ID] = model;
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID] = CreateDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_MODEL_ID], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosX], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosY], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosZ], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotX], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotY], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotZ]
    );

    new str[128];
    for(new k = 0; k < MAX_INDEX; k++)
    {
        if(Mat_USED[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k])
        {
            SetDynamicObjectMaterial(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID], k, 
                ObjectTextures[Mat_ID[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k]][TModel],
                ObjectTextures[Mat_ID[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k]][TXDName],
                ObjectTextures[Mat_ID[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k]][TextureName]);
        }

        if(Mat_TUSED[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k])
        {
            format(str, sizeof(str), "%s", GetMatTextInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], k));
            strreplace(str, "`", " ");
            SetDynamicObjectMaterialText(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID], k, str, 
                Mat_TMSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k], 
                Fonts[Mat_TFONT[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k]], 
                Mat_TSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k],  
                Mat_TBOLD[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k],  
                Mat_TCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k], 
                Mat_TBACKCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k],  
                Mat_TALIGN[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][k]);
        }
    }
    return 1;
}

CMD:oe(playerid, params[])
{
    new id, str[128];
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing"); 
    if(PLAYER_INFO[playerid][editing] == 1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You are editing an object, finish it before editing another");
    if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /oe <object ID>");
    if(id > MAX_OBJ  || id < 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid object ID");
    if(!IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid object ID");
    if(PLAYER_INFO[playerid][cur_obj] == id) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You have already selected this object for editing");
    
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You are now editing object ID %i ", id);
    SendClientMessage(playerid, -1, str);
    
    if(PLAYER_INFO[playerid][labeled] == 1)
    {
        DestroyDynamic3DTextLabel(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][O_LID]);
        if(PLAYER_INFO[playerid][cur_obj] != -1)
        {
            if(IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID]))
            {
                format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"Model ID: "#COL_RED"%i", PLAYER_INFO[playerid][cur_obj], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_MODEL_ID]);
                OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_LID] = CreateDynamic3DTextLabel(str, -1, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosX], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosY], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosZ], LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
            }
        }
    }
    PLAYER_INFO[playerid][cur_obj] = id;
    return 1;
}

CMD:op(playerid, params[])
{
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing"); 
    if(PLAYER_INFO[playerid][cur_obj] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing"); 
    if(PLAYER_INFO[playerid][editing] == 1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You are already editing an object, finish it to edit another"); 
    EditDynamicObject(playerid, OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID]);
    PLAYER_INFO[playerid][editing] = 1;
    SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_GREY" You can move the camera while editing by pressing and holding the spacebar (or W in vehicle) and moving your mouse.");
    SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_GREY" You have to click on the save icon to save your updates & press ESC to cancel");
    return 1;
}

//Object material commands!
CMD:fontsearch(playerid, params[])
{
    if(!fsearch[playerid])
    {
        fsearch[playerid] = 1;
        nowf[playerid] = 0;
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        GetXYInFrontOfPlayer(playerid, x, y, 2);
        fob[playerid] = CreatePlayerObject(playerid, 2267, x, y, z + 1, 0.000000, 0.000000, 0.000000, 10);
        SetPlayerObjectMaterial(playerid, fob[playerid], 0, 0, "INVALID", "INVALID", 0);
        SetPlayerObjectMaterialText(playerid, fob[playerid], "Arial", 1, 90, "Arial", 40, 1, 0xFFFFFFFF, 0xFF000000, 1);
        PlayerTextDrawSetString(playerid, fonttd[playerid], "Font_ID:_1");
        PlayerTextDrawShow(playerid, fonttd[playerid]);
    }
    else 
    {
        fsearch[playerid] = 0;
        DestroyPlayerObject(playerid, fob[playerid]);
        PlayerTextDrawHide(playerid, fonttd[playerid]);
    }
    return 1;
}
CMD:mattexture(playerid, params[])
{
    new index, mid;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing"); 
    if(PLAYER_INFO[playerid][cur_obj] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing"); 
    if(sscanf(params, "ii", index, mid)){
        SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /mattexture <index> <material ID>");
        return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_GREY" Use /tbrowse to view material IDs");
    }
    if(index < 0 || index >= MAX_INDEX) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid index (Index should be in between 0 - 15)");
    if(mid > MAX_TEXTURES || mid < 0){
        SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid material ID");
        return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_GREY" Use /tbrowse to view material IDs");
    }
    SetDynamicObjectMaterial(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID], index, ObjectTextures[mid][TModel], ObjectTextures[mid][TXDName], ObjectTextures[mid][TextureName]);
    Mat_USED[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index] = 1;
    Mat_ID[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index] = mid;
    Mat_TUSED[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index] = 0;

    new str[128];
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Material of index %i in object ID %i has been changed to Material ID %i", index, PLAYER_INFO[playerid][cur_obj], mid);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:mattextureall(playerid, params[])
{
    new index, mid;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing"); 
    if(MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][total_obj] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You don't have any object in this map!"); 
    if(sscanf(params, "ii", index, mid)){
        SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /mattextureall <index> <material ID>");
        return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_GREY" Use /tbrowse to view material IDs");
    }
    if(index < 0 || index >= MAX_INDEX) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid index (Index should be in between 0 - 15)");
    if(mid > MAX_TEXTURES || mid < 0){
        SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid material ID");
        return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_GREY" Use /tbrowse to view material IDs");
    }
    for(new i = 0; i < MAX_OBJ; i++)
    {
        if(IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID]))
        {
            SetDynamicObjectMaterial(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID], index, ObjectTextures[mid][TModel], ObjectTextures[mid][TXDName], ObjectTextures[mid][TextureName]);
            Mat_USED[PLAYER_INFO[playerid][cur_svr_mid]][i][index] = 1;
            Mat_ID[PLAYER_INFO[playerid][cur_svr_mid]][i][index] = mid;
            Mat_TUSED[PLAYER_INFO[playerid][cur_svr_mid]][i][index] = 0;
        }
    }

    new str[128];
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Material of index %i in all objects has been changed to Material ID %i", index, mid);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:matreset(playerid, params[])
{
    new index;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing"); 
    if(MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][total_obj] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You don't have any object in this map!"); 
    if(sscanf(params, "i", index)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /matreset <index>");
    if(index < 0 || index >= MAX_INDEX) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid index (Index should be in between 0 - 15)");
    if(PLAYER_INFO[playerid][cur_obj] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing"); 
    if(!Mat_USED[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index]) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't used any material in that object!");
    new tmp = CreateDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_MODEL_ID], 
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosX], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosY], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_PosZ],
        OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotX], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotY], OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_RotZ]);
    for(new i = 0; i < MAX_INDEX; i++)
    {
        if(i != index)
        {
            if(Mat_USED[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][i]) 
            {
                SetDynamicObjectMaterial(tmp, i, 
                ObjectTextures[Mat_ID[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][i]][TModel], 
                ObjectTextures[Mat_ID[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][i]][TXDName], 
                ObjectTextures[Mat_ID[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][i]][TextureName]);
            }
            if(Mat_TUSED[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][i]) 
            {
                SetDynamicObjectMaterialText(tmp, i, 
                GetMatTextInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], i), 
                Mat_TMSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
                Fonts[Mat_TFONT[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index]],
                Mat_TSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][i], 
                Mat_TBOLD[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][i], 
                Mat_TCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][i], 
                Mat_TBACKCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][i],
                Mat_TALIGN[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][i]);
            }
        }
    }

    Mat_TUSED[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index] = 0;
    Mat_USED[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index] = 0;

    DestroyDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID]);
    OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID] = tmp;

    new str[128];
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Material of index %i in object ID %i has been reset", index, PLAYER_INFO[playerid][cur_obj]);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:matcolor(playerid, params[])
{
    new index, hex;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing"); 
    if(MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][total_obj] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You don't have any object in this map!"); 
    if(sscanf(params, "ih", index, hex)){
        SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /matcolor <index> <color>");
        return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_GREY" Type the hex of the color, (Ex - Hex of white is 0xFFFFFFFF |  0xAARRGGBB)");
    }
    if(index < 0 || index >= MAX_INDEX) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid index (Index should be in between 0 - 15)");
    Mat_TBACKCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index] = hex;
    new str[MAX_MATTEXT_SIZE];
    format(str, sizeof(str), "%s", GetMatTextInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], index));
    strreplace(str, "`", " ");
    if(IsMatTextUsedInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], index))
    {
        SetDynamicObjectMaterialText(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID], index, str,
        Mat_TMSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index],
        Fonts[Mat_TFONT[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index]], 
        Mat_TSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TBOLD[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TBACKCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index],
        Mat_TALIGN[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index]);
    }
    else 
    {
        Mat_TUSED[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index] = 1;
        SetMatTextInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], index, "          ");
        SetDynamicObjectMaterialText(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID], index, GetMatTextInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], index),
        Mat_TMSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index],
        Fonts[Mat_TFONT[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index]], 
        Mat_TSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TBOLD[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TBACKCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index],
        Mat_TALIGN[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index]);
        SetMatTextInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], index, "``````````");
    }

    new str1[128];
    format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Material color of index %i in object ID %i has been changed to %x", index, PLAYER_INFO[playerid][cur_obj], hex);
    SendClientMessage(playerid, -1, str1);
    return 1;
}

CMD:mattext(playerid, params[])
{
    new index, str[MAX_MATTEXT_SIZE];
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing"); 
    if(PLAYER_INFO[playerid][cur_obj] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing"); 
    if(sscanf(params, "is["#MAX_MATTEXT_SIZE"]", index, str)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /mattext <index> <text>");
    if(strlen(str) > MAX_MATTEXT_SIZE || strlen(str) < 1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid character length");
    Mat_TUSED[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index] = 1;
    Mat_USED[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index] = 0;
    SetDynamicObjectMaterialText(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID], index, str, 
        Mat_TMSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Fonts[Mat_TFONT[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index]], 
        Mat_TSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TBOLD[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TBACKCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index],
        Mat_TALIGN[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index]);
    strreplace(str, " ", "`");
    SetMatTextInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], index, str);

    new str1[128];
    format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Material text of index %i in object ID %i has been changed to \"%s\"", index, PLAYER_INFO[playerid][cur_obj], str);
    SendClientMessage(playerid, -1, str1);
    return 1;
}

CMD:matalign(playerid, params[])
{
    new index, align;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing"); 
    if(PLAYER_INFO[playerid][cur_obj] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing"); 
    if(sscanf(params, "ii", index, align)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /matalign <index> <align>");
    if(align < 1 || align > 3) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid align id (Left : 1 | Center : 2 | Right : 3)");
    if(index < 0 || index >= MAX_INDEX) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid index");
    if(!IsMatTextUsedInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], index)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't marked any text to bold!");
    new str1[128];
    switch(align)
    {
        case 1:{
            Mat_TALIGN[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index] = 0;
            format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Material alignment of index %i in object ID %i has been set to LEFT", index, PLAYER_INFO[playerid][cur_obj]);
    
        }
        case 2:{
            Mat_TALIGN[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index] = 1;
            format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Material alignment of index %i in object ID %i has been set to CENTER", index, PLAYER_INFO[playerid][cur_obj]);
    
        }
        case 3:{
            Mat_TALIGN[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index] = 2;
            format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Material alignment of index %i in object ID %i has been set to RIGHT", index, PLAYER_INFO[playerid][cur_obj]);
    
        }
    }
    new str[MAX_MATTEXT_SIZE];
    format(str, sizeof(str), "%s", GetMatTextInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], index));
    strreplace(str, "`", " ");
    SetDynamicObjectMaterialText(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID], index, str,
        Mat_TMSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index],
        Fonts[Mat_TFONT[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index]], 
        Mat_TSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TBOLD[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TBACKCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index],
        Mat_TALIGN[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index]); 
    
    SendClientMessage(playerid, -1, str1);
    return 1;
}

CMD:matsize(playerid, params[])
{
    new index, size;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing"); 
    if(PLAYER_INFO[playerid][cur_obj] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing"); 
    if(sscanf(params, "ii", index, size)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /matsize <index> <size>");
    if(size < 1 || size > 14) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid Material size (Material size should lie in between 1 - 14)");
    if(index < 0 || index >= MAX_INDEX) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid index");
    if(!IsMatTextUsedInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], index)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't marked any text to bold!");
    Mat_TMSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index] = 10 * size;
    new str[MAX_MATTEXT_SIZE];
    format(str, sizeof(str), "%s", GetMatTextInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], index));
    strreplace(str, "`", " ");
    SetDynamicObjectMaterialText(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID], index, str,
        Mat_TMSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Fonts[Mat_TFONT[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index]], 
        Mat_TSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TBOLD[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TBACKCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index],
        Mat_TALIGN[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index]);

    new str1[128];
    format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Material dimension of index %i in object ID %i has been changed to %i", index, PLAYER_INFO[playerid][cur_obj], size);
    SendClientMessage(playerid, -1, str1);
    return 1;
}

CMD:matbold(playerid, params[])
{
    new index;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing"); 
    if(PLAYER_INFO[playerid][cur_obj] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing"); 
    if(sscanf(params, "i", index)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /matbold <index>");
    if(index < 0 || index >= MAX_INDEX) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid index");
    if(!IsMatTextUsedInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], index)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't marked any text to bold!");
    new str1[128];
    if(Mat_TBOLD[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index]){
        Mat_TBOLD[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index] = 0;
        format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Material boldness of index %i in object ID %i has been toggled OFF", index, PLAYER_INFO[playerid][cur_obj]);
    }
    else{
        Mat_TBOLD[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index] = 1;
        format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Material boldness of index %i in object ID %i has been toggled ON", index, PLAYER_INFO[playerid][cur_obj]);
    }
    new str[MAX_MATTEXT_SIZE];
    format(str, sizeof(str), "%s", GetMatTextInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], index));
    strreplace(str, "`", " ");
    SetDynamicObjectMaterialText(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID], index, str,
        Mat_TMSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index],
        Fonts[Mat_TFONT[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index]], 
        Mat_TSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TBOLD[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TBACKCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index],
        Mat_TALIGN[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index]);

    SendClientMessage(playerid, -1, str1);
    return 1;
}

CMD:matfont(playerid, params[])
{
    new index, id;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing"); 
    if(PLAYER_INFO[playerid][cur_obj] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing"); 
    if(sscanf(params, "ii", index, id)){
        SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /matfont <index> <color>");
        return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_GREY" Type the hex of the color, (Ex - Hex of white is 0xFFFFFFFF |  0xAARRGGBB)");
    }
    if(index < 0 || index >= MAX_INDEX) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid index");
    if(!IsMatTextUsedInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], index)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't marked any text to change color!");
    if(id < 1 || id > sizeof(Fonts)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid font face ID, Use /fontlist");
    Mat_TFONT[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index] = id - 1;
    new str[MAX_MATTEXT_SIZE];
    format(str, sizeof(str), "%s", GetMatTextInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], index));
    strreplace(str, "`", " ");
    SetDynamicObjectMaterialText(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID], index, str,
        Mat_TMSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Fonts[Mat_TFONT[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index]],  
        Mat_TSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TBOLD[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TBACKCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index],
        Mat_TALIGN[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index]);

    new str1[128];
    format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Material font of index %i in object ID %i has been changed to \"%s\" -> ID: %i", index, PLAYER_INFO[playerid][cur_obj], Fonts[id -1], id);
    SendClientMessage(playerid, -1, str1);
    return 1;
}

CMD:matfontcolor(playerid, params[])
{
    new index, hex;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing"); 
    if(PLAYER_INFO[playerid][cur_obj] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing"); 
    if(sscanf(params, "ih", index, hex)){
        SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /matfontcolor <index> <color>");
        return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_GREY" Type the hex of the color, (Ex - Hex of white is 0xFFFFFFFF |  0xAARRGGBB)");
    }
    if(index < 0 || index >= MAX_INDEX) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid index");
    if(!IsMatTextUsedInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], index)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't marked any text to change color!");
    Mat_TCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index] = hex;
    new str[MAX_MATTEXT_SIZE];
    format(str, sizeof(str), "%s", GetMatTextInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], index));
    strreplace(str, "`", " ");
    SetDynamicObjectMaterialText(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID], index, str,
        Mat_TMSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Fonts[Mat_TFONT[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index]], 
        Mat_TSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TBOLD[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TBACKCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index],
        Mat_TALIGN[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index]);
    new str1[128];
    format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Material font color of index %i in object ID %i has been changed to %x", index, PLAYER_INFO[playerid][cur_obj], hex);
    SendClientMessage(playerid, -1, str1);
    return 1;
}

CMD:matfontsize(playerid, params[])
{
    new index, size;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing"); 
    if(PLAYER_INFO[playerid][cur_obj] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing"); 
    if(sscanf(params, "ii", index, size)) SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /matfontsize <index> <size>");
    if(index < 0 || index >= MAX_INDEX) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid index");
    if(size < 1 || size > 255) return SendClientMessage(PLAYER_INFO[playerid][cur_obj], -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid font size (font size should lie in between 1 - 255)");
    if(!IsMatTextUsedInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], index)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't marked any text to change font size!");
    Mat_TSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index] = size;
    new str[MAX_MATTEXT_SIZE];
    format(str, sizeof(str), "%s", GetMatTextInIndex(PLAYER_INFO[playerid][cur_svr_mid], PLAYER_INFO[playerid][cur_obj], index));
    strreplace(str, "`", " ");
    SetDynamicObjectMaterialText(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][O_ID], index, str,
        Mat_TMSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Fonts[Mat_TFONT[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index]], 
        Mat_TSIZE[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TBOLD[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index], 
        Mat_TBACKCOL[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index],
        Mat_TALIGN[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_obj]][index]);
    new str1[128];
    format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Material font size of index %i in object ID %i has been changed to %i", index, PLAYER_INFO[playerid][cur_obj], size);
    SendClientMessage(playerid, -1, str1);
    return 1;
}

CMD:tbrowse(playerid, params[])
{
    if(MENU3D_DATA[playerid][TPreviewState] == PREVIEW_STATE_ALLTEXTURES && strval(params) == 0)
    {
        CancelSelect3DMenu(playerid);
        Destroy3DMenu(MENU3D_DATA[playerid][Menus3D]);
        MENU3D_DATA[playerid][TPreviewState] = PREVIEW_STATE_NONE;
        PlayerTextDrawHide(playerid, MENU3D_DATA[playerid][Menu3D_Model_Info]);

        SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor| "#COL_GREY"Texture selection closed!");
    }
    else
    {

        new Float:x, Float: y, Float:z, Float:fa;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, fa);

        x = (x + 1.75 * floatsin(-fa + -90,degrees));
        y = (y + 1.75 * floatcos(-fa + -90,degrees));

        x = (x + 2.0 * floatsin(-fa,degrees));
        y = (y + 2.0 * floatcos(-fa,degrees));
        
        new index = strval(params);

        if(index < 1 || index > MAX_TEXTURES - 1) MENU3D_DATA[playerid][CurrTextureIndex] = 1;
        else MENU3D_DATA[playerid][CurrTextureIndex] = index;
        
        if(MAX_TEXTURES - 1 - MENU3D_DATA[playerid][CurrTextureIndex] - 16 < 0) MENU3D_DATA[playerid][CurrTextureIndex] = MAX_TEXTURES - 16 - 1;

        if(MENU3D_DATA[playerid][TPreviewState] == PREVIEW_STATE_NONE)
        {
            MENU3D_DATA[playerid][Menus3D] = Create3DMenu(playerid, x, y, z, fa, 16);
            Select3DMenu(playerid, MENU3D_DATA[playerid][Menus3D]);
            MENU3D_DATA[playerid][TPreviewState] = PREVIEW_STATE_ALLTEXTURES;
            PlayerTextDrawShow(playerid, MENU3D_DATA[playerid][Menu3D_Model_Info]);

            for(new i = 0; i < 16; i++)
            {
                SetBoxMaterial(MENU3D_DATA[playerid][Menus3D],i,0,ObjectTextures[i+MENU3D_DATA[playerid][CurrTextureIndex]][TModel],ObjectTextures[i+MENU3D_DATA[playerid][CurrTextureIndex]][TXDName],ObjectTextures[i+MENU3D_DATA[playerid][CurrTextureIndex]][TextureName], 0, 0xFF999999);
            }

            UpdateTextureInfo(playerid, SelectedBox[playerid]);

            SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor| "#COL_GREY"Texture selection opened!");
            SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor| "#COL_GREY"Use numpad '6' and '4' to change the slot while 'Y' and 'N' to change within the slot");
        }

        else if(MENU3D_DATA[playerid][TPreviewState] == PREVIEW_STATE_ALLTEXTURES)
        {
            for(new i = 0; i < 16; i++)
            {
                SetBoxMaterial(MENU3D_DATA[playerid][Menus3D],i,0,ObjectTextures[i+MENU3D_DATA[playerid][CurrTextureIndex]][TModel],ObjectTextures[i+MENU3D_DATA[playerid][CurrTextureIndex]][TXDName],ObjectTextures[i+MENU3D_DATA[playerid][CurrTextureIndex]][TextureName], 0, 0xFF999999);
            }

            UpdateTextureInfo(playerid, SelectedBox[playerid]);

            SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor| "#COL_GREY"Texture selection slot changed!");
        }
    }
    return 1;
}

CMD:tsearch(playerid, params[])
{
    new name[30];
    if(sscanf(params, "s[30]", name)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /tsearch <name>");
    if(strlen(name) < 1 || strlen(name) > 30) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid character length");
    new model[10];
    new k = -1, p = -1, r = -1;
    new str[1024];
    new str1[1050];
    new substr[128];
    for(new i = 0; i < MAX_TEXTURES; i++)
    {
        valstr(model, ObjectTextures[i][TModel]);
        k = strfind(ObjectTextures[i][TXDName], name, true);
        p = strfind(ObjectTextures[i][TextureName], name, true);
        r = strfind(model, name, true);
        if(k != -1 || p != -1 || r != -1 )
        {
            format(substr, sizeof(substr), "%i\t%i\t%s\t%s\n", i, ObjectTextures[i][TModel], ObjectTextures[i][TXDName], ObjectTextures[i][TextureName]);
            strcat(str, substr, sizeof(str));
        }   
    }
    format(substr, sizeof(substr), "Search results for '%s'", name);
    if(isempty(str)) return ShowPlayerDialog(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_MSGBOX, substr, "Nothing found for this search!", "Close", "");
    format(str1, sizeof(str1), "Texture ID\tModel ID\tTXD Name\tTexture Name\n%s", str); 
    ShowPlayerDialog(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_MSGBOX, substr, str1, "Close", "");
    return 1;
}

//Vehicle commands!
CMD:vspawn(playerid, params[])
{
    new name[30]; 
    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "You cant use this command while you are in a vehicle!");
    if(sscanf(params, "s[30]", name)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor| "#COL_RED" /vspawn <name>");
    new model = -1;
    for(new i = 0; i < sizeof(VehicleNames); i++)
    {
        if(strfind(VehicleNames[i], name, true))
        {
            model = 400 + i;
            break;
        }
    }

    if(model == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor| "#COL_RED" No such vehicle found!");

    new Float:x, Float:y, Float:z, Float:ang;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, ang);
    new vid = CreateVehicle(model, x, y, z, ang, -1, -1, -1);
    SetVehicleVirtualWorld(vid, GetPlayerVirtualWorld(playerid));
    LinkVehicleToInterior(vid, GetPlayerInterior(playerid));
    PutPlayerInVehicle(playerid, vid, 0);

    new str1[128];
    format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You spawned a \"%s\"", VehicleNames[model - 400]);
    SendClientMessage(playerid, -1, str1);
    return 1;
}

CMD:vadd(playerid, params[])
{
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You should be in a vehicle to use this command");
    if(MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][total_vehicles] == MAX_VEH) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You have reached the maximum amount of vehicles that can be added to a map (limit: "#MAX_VEH")");
    if(GetVehicleSlotID(PLAYER_INFO[playerid][cur_svr_mid], GetPlayerVehicleID(playerid)) == -1)
    {
        new id = GetLastVehicleSlot(PLAYER_INFO[playerid][cur_svr_mid]);
        VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID] = GetPlayerVehicleID(playerid);
        VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_MODEL_ID] = GetVehicleModel(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID]);
        VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_Color1] = 0;
        VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_Color2] = 1;
        GetVehiclePos(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID], 
            VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_PosX],
            VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_PosY],
            VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_PosZ]
        );
        ChangeVehicleColor(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID], 0, 1);
        GetVehicleZAngle(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID], 
            VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_Ang]);
        new str[128]; 
        if(PLAYER_INFO[playerid][labeled]) 
        {
            format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"model ID: "#COL_RED"%i", id, VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_MODEL_ID]);
            VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_LID] = CreateDynamic3DTextLabel(str, -1, 0, 0, 0, LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID], 0, -1, -1, playerid);
        }
        new str1[128];
        format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" This vehicle has been added successfully ( Vehicle ID: %i | Map ID: %i )", id, PLAYER_INFO[playerid][cur_player_mid]);
        SendClientMessage(playerid, -1, str1);
    }
    else
    {
        new id = GetVehicleSlotID(PLAYER_INFO[playerid][cur_svr_mid], GetPlayerVehicleID(playerid));
        GetVehiclePos(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID], 
            VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_PosX],
            VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_PosY],
            VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_PosZ]
        );
        GetVehicleZAngle(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID], 
            VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_Ang]);
        new str1[128];
        format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Position for vehicle ID %i has been updated!", id);
        SendClientMessage(playerid, -1, str1);
    }
    MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][total_vehicles] ++;
    return 1;
}

CMD:vcolor1(playerid, params[])
{
    new id, color;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(sscanf(params, "ii", id, color)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /vcolor1 <vehicle ID> <color ID>");
    if(id < 0 || id >= MAX_VEH) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid vehicle ID");
    if(!IsValidVehicle(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid vehicle ID");
    VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_Color1] = color;
    ChangeVehicleColor(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID], color, VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_Color2]);
    new str1[128];
    format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" The 1st color of vehicle ID %i has been changed to %i", id, color);
    SendClientMessage(playerid, -1, str1);
    return 1;
}

CMD:vcolor2(playerid, params[])
{
    new id, color;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(sscanf(params, "ii", id, color)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /vcolor2 <vehicle ID> <color ID>");
    if(id < 0 || id >= MAX_VEH) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid vehicle ID");
    if(!IsValidVehicle(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid vehicle ID");
    VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_Color2] = color;
    ChangeVehicleColor(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID], VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_Color1], color);
    new str1[128];
    format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" The 2nd color of vehicle ID %i has been changed to %i", id, color);
    SendClientMessage(playerid, -1, str1);
    return 1;
}

CMD:vdm(playerid, params[])
{
    new id;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /vdm <vehicle ID>");
    if(id < 0 || id >= MAX_VEH) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid vehicle ID");
    if(!IsValidVehicle(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid vehicle ID");
    if(PLAYER_INFO[playerid][labeled]) DestroyDynamic3DTextLabel(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_LID]);
    DestroyVehicle(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID]);

    VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID] = -1;
    VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_MODEL_ID] = -1;
    VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_PosX] = -1;
    VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_PosY] = -1;
    VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_PosZ] = -1;
    VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_Ang] = -1;

    MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][total_vehicles]--;

    new str1[128];
    format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Vehicle has been deleted successfully ( Vehicle ID: %i | Map ID: %i )", id, PLAYER_INFO[playerid][cur_player_mid]);
    SendClientMessage(playerid, -1, str1);
    return 1;
}

CMD:vclone(playerid, params[])
{
    new id;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][total_vehicles] == MAX_VEH) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You have reached the maximum amount of vehicles that can be added to a map (limit: "#MAX_VEH")");
    if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /vclone <vehicle ID>");
    if(id < 0 || id >= MAX_VEH) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid vehicle ID");
    if(!IsValidVehicle(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid vehicle ID");
    new nid = GetLastVehicleSlot(PLAYER_INFO[playerid][cur_svr_mid]);
    GetVehicleRelativePos(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID],
        VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][nid][V_PosX],
        VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][nid][V_PosY],
        VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][nid][V_PosZ],
        2.5);
    VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][nid][V_ID] = CreateVehicle(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_MODEL_ID], 
        VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][nid][V_PosX], 
        VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][nid][V_PosY], 
        VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][nid][V_PosZ], 
        VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_Ang], 
        VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_Color1], 
        VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_Color2], RESPAWN_DELAY);

    VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][nid][V_MODEL_ID] =  VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_MODEL_ID];
    VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][nid][V_Color1] =  VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_Color1]; 
    VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][nid][V_Color2] =  VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_Color2];
    VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][nid][V_Ang] =  VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_Ang];

    new str[128]; 
    if(PLAYER_INFO[playerid][labeled]) 
    {
        format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"model ID: "#COL_RED"%i", nid, VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][nid][V_MODEL_ID]);
        VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][nid][V_LID] = CreateDynamic3DTextLabel(str, -1, 0, 0, 0, LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][nid][V_ID], 0, -1, -1, playerid);
    }

    MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][total_vehicles] ++;

    new str1[128];
    format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Vehicle ID %i has been cloned successfully!", id);
    SendClientMessage(playerid, -1, str1);
    return 1;
}

CMD:vmodel(playerid, params[])
{
    new id, model;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][total_vehicles] == MAX_VEH) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You have reached the maximum amount of vehicles that can be added to a map (limit: "#MAX_VEH")");
    if(sscanf(params, "ii", id, model)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /vmodel <vehicle ID> <new model ID>");
    if(id < 0 || id >= MAX_VEH) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid vehicle ID");
    if(model < 400 || model > 611) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid model ID");
    if(!IsValidVehicle(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid vehicle ID");
    DestroyVehicle(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID]);
    VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID] = CreateVehicle(model, 
        VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_PosX], 
        VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_PosY], 
        VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_PosZ], 
        VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_Ang], 
        VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_Color1], 
        VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_Color2], RESPAWN_DELAY);

    VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_MODEL_ID] = model;

    new str[128]; 
    if(PLAYER_INFO[playerid][labeled]) 
    {
        DestroyDynamic3DTextLabel(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_LID]);
        format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"model ID: "#COL_RED"%i", id, VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_MODEL_ID]);
        VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_LID] = CreateDynamic3DTextLabel(str, -1, 0, 0, 0, LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID], 0, -1, -1, playerid);
    }

    new str1[128];
    format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Model of vehicle ID %i has been changed to %i successfully!", id, model);
    SendClientMessage(playerid, -1, str1);
    return 1;
}

CMD:vbring(playerid, params[])
{
    new id;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /vbring <vehicle ID>");
    if(id < 0 || id >= MAX_VEH) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid vehicle ID");
    if(!IsValidVehicle(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid vehicle ID");
    new Float:x, Float:y, Float:z, Float:ang;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, ang);
    SetVehiclePos(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID], x, y, z);
    SetVehicleZAngle(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID], ang);
    PutPlayerInVehicle(playerid, VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID], 0);
    SetVehicleVirtualWorld(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][V_ID], GetPlayerVirtualWorld(playerid));

    new str1[128];
    format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You bought vehicle ID %i to your location successfully!", id);
    SendClientMessage(playerid, -1, str1);
    return 1;
}

//Actor commands!
CMD:vsearch(playerid, params[])
{
    new substr[30];
    static str[212  * sizeof(substr)]; 

    for(new i = 400; i < 612; i++) 
    {
        format(substr, sizeof(substr), "%i\t%s:%i\n", i, VehicleNames[i - 400], i);
        strcat(str, substr);
    } 

    ShowPlayerDialog(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_PREVIEW_MODEL, "GEditor - Vehicle browser", str, "Close", ""); 
    return 1;
}

CMD:anim(playerid, params[])
{
    new id, str[128];
    if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /anim <ID>");
    if(id < 1 || id > sizeof(AnimationData)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid anim ID");
    ApplyAnimation(playerid, AnimationData[id - 1][animlib], AnimationData[id - 1][animname], 4.0,1,0,0,0,-1);
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_GREY" ID: \"%i\" | Anim library - \"%s\" | Anim name - \"%s\"", id, AnimationData[id - 1][animlib], AnimationData[id - 1][animname]);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:stopanim(playerid, params[])
{
    ClearAnimations(playerid);
    return 1;
}

CMD:aanim(playerid, params[])
{
    new id, str[128];
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /anim <ID>");
    if(id < 1 || id > sizeof(AnimationData)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid anim ID");
    ApplyDynamicActorAnimation(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_ID], AnimationData[id - 1][animlib], AnimationData[id - 1][animname], 4.0,1,0,0,0,-1);
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_GREY" ID: \"%i\" | Anim library - \"%s\" | Anim name - \"%s\"", id, AnimationData[id - 1][animlib], AnimationData[id - 1][animname]);
    SendClientMessage(playerid, -1, str);
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][animused] = 1;
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][animid] = id - 1;
    new str1[128];
    format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Animation ID %i has been applied for the actor ID %i !", id, PLAYER_INFO[playerid][cur_act]);
    SendClientMessage(playerid, -1, str1);
    return 1;
}

CMD:aremoveanim(playerid, params[])
{
    new id;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /anim <ID>");
    if(id < 1 || id > sizeof(AnimationData)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid anim ID");
    ClearDynamicActorAnimations(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][animid]);
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][animused] = 0;
    new str1[128];
    format(str1, sizeof(str1), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Animation has been removed from actor ID %i !", PLAYER_INFO[playerid][cur_act]);
    SendClientMessage(playerid, -1, str1);
    return 1;
}

CMD:ac(playerid, params[])
{
    new skin;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(MAP_INFO[PLAYER_INFO[playerid][cur_player_mid]][total_actors] == MAX_ACT) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You have reached the maximum amout of actors that can be created in one map (Limit: "#MAX_ACT")");
    if(sscanf(params, "i", skin)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /ac <skin ID>");
    if(skin > 311 || skin < 0)  return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid skin ID");
    new Float:x, Float:y, Float:z, Float:xp, Float:yp;
    GetXYInFrontOfPlayer(playerid, x, y, 4.0);
    GetPlayerPos(playerid, xp, yp, z);
    new aid;
    for(new i = 0; i < MAX_ACT; i++)
    {
        if(!IsValidDynamicActor(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_ID]))
        {
            ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_ID] = CreateDynamicActor(skin, x, y, z, 0.0);
            aid = i;
            break;
        }
    }

    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][aid][A_SKIN] = skin;
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][aid][A_PosX] = x;
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][aid][A_PosY] = y;
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][aid][A_PosZ] = z;
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][aid][A_Ang] = 0;

    MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][total_actors] ++;

    new str[128];
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Actor successfully created! ( Map ID: %s(%i) | Actor ID: %i | skin ID: %i )", MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][M_Name], PLAYER_INFO[playerid][cur_player_mid], aid, skin);
    SendClientMessage(playerid, -1, str);

    if(PLAYER_INFO[playerid][labeled] == 1)
    {
        format(str, sizeof(str), ""#COL_YELLOW"ID: %i {ffffff}| "#COL_YELLOW"skin ID: %i", aid, ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][aid][A_SKIN]);
        ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][aid][A_LID] = CreateDynamic3DTextLabel(str, -1, ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][aid][A_PosX], ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][aid][A_PosY], ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][aid][A_PosZ], LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
    }

    format(str, sizeof(str), "/ae %i", aid);
    PC_EmulateCommand(playerid, str);
    return 1;
}

CMD:askinc(playerid, params[])
{
    new skin;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(PLAYER_INFO[playerid][cur_act] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any actor for editing");
    if(!IsValidDynamicActor(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any actor for editing");
    if(sscanf(params, "i", skin)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /askinc <skin ID>");
    if(skin < 0 || skin > 312) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid skin ID");
    if(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_SKIN] == skin) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" This is the same skin that actor holds now!");
    
    ClearDynamicActorAnimations(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_ID]);

    DestroyDynamicActor(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_ID]);

    new Float:x = ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_PosX]; 
    new Float:y = ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_PosY]; 
    new Float:z = ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_PosZ];
    new Float:ang = ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_Ang];  

    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_ID] =  CreateDynamicActor(skin, x, y, z, ang);

    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_SKIN] = skin;

    if(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][animused])
    {
        ApplyDynamicActorAnimation(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_ID], 
            AnimationData[ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][animid]][animlib], 
            AnimationData[ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][animid]][animname], 
            4.0,1,0,0,0,-1);
    }

    new str[128];
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You changed skin of the Actor ID %i ( new skin ID: %i )", PLAYER_INFO[playerid][cur_act], skin);
    SendClientMessage(playerid, -1, str); 
    return 1;
}

CMD:ae(playerid, params[])
{
    new id;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing"); 
    if(PLAYER_INFO[playerid][editing] == 1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You are editing an object, finish it before editing another actor");
    if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /ae <actor ID>");
    if(!IsValidDynamicActor(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid actor ID");
    if(PLAYER_INFO[playerid][cur_act] == id) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You have already selected this actor for editing");
    
    new str[128];
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You are now editing actor ID %i ", id);
    SendClientMessage(playerid, -1, str);

    if(PLAYER_INFO[playerid][labeled] == 1)
    {
        DestroyDynamic3DTextLabel(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_LID]);

        if(PLAYER_INFO[playerid][cur_act] != -1)
        {
            if(IsValidDynamicActor(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_ID]))
            {
                format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"Skin ID: "#COL_RED"%i", PLAYER_INFO[playerid][cur_act], ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_SKIN]);
                ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_LID] = CreateDynamic3DTextLabel(str, -1, ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_PosX], ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_PosY], ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_PosZ], LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
            }
        }
    }

    PLAYER_INFO[playerid][cur_act] = id;
    return 1;   
} 

CMD:abring(playerid, params[])
{
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing"); 
    if(PLAYER_INFO[playerid][cur_act] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any actor for editing"); 
    if(!IsValidDynamicActor(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any actor for editing"); 
    
    SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_YELLOW" You have brought current editing actor to your location");

    new Float:x, Float:y, Float:z, Float:ang;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, ang);

    SetDynamicActorPos(ACT_INFO[PLAYER_INFO[playerid][cur_player_mid]][PLAYER_INFO[playerid][cur_act]][A_ID], x, y, z);
    SetDynamicActorFacingAngle(ACT_INFO[PLAYER_INFO[playerid][cur_player_mid]][PLAYER_INFO[playerid][cur_act]][A_ID], ang);

    SetPlayerPos(playerid, x + 0.5, y + 0.5, z);

    ACT_INFO[PLAYER_INFO[playerid][cur_player_mid]][PLAYER_INFO[playerid][cur_act]][A_PosX] = x;
    ACT_INFO[PLAYER_INFO[playerid][cur_player_mid]][PLAYER_INFO[playerid][cur_act]][A_PosY] = y;
    ACT_INFO[PLAYER_INFO[playerid][cur_player_mid]][PLAYER_INFO[playerid][cur_act]][A_PosZ] = z;
    ACT_INFO[PLAYER_INFO[playerid][cur_player_mid]][PLAYER_INFO[playerid][cur_act]][A_Ang] = ang;
    return 1;
}

CMD:agoto(playerid, params[])
{
    new id;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing"); 
    if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /agoto <actor ID>");
    if(!IsValidDynamicActor(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid actor ID");

    new str[128];
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You have been teleported to actor ID %i location", id);
    SendClientMessage(playerid, -1, str);

    new Float:x, Float:y, Float:z, Float:ang;
    GetDynamicActorPos(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_ID], x, y, z);
    GetDynamicActorFacingAngle(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_ID], ang);

    SetPlayerPos(playerid, x + 0.5, y + 0.5, z);
    SetPlayerFacingAngle(playerid, ang);
    return 1;
}

CMD:aclone(playerid, params[])
{
    new id;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any map for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(MAP_INFO[PLAYER_INFO[playerid][cur_player_mid]][total_actors] == MAX_ACT) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You have reached the maximum amout of actors that can be created in one map (Limit: "#MAX_ACT")");
    if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /aclone <actor ID>");
    if(!IsValidDynamicActor(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_ID]))  return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid actor ID");
    new aid;
    for(new i = 0; i < MAX_ACT; i++)
    {
        if(!IsValidDynamicActor(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_ID]))
        {
            ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_ID] = CreateDynamicActor(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_SKIN], ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_PosX], ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_PosY], ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_PosZ], ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_Ang]);
            aid = i;
            break;
        }
    }

    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][aid][A_SKIN] = ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_SKIN];
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][aid][A_PosX] = ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_PosX];
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][aid][A_PosY] = ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_PosY];
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][aid][A_PosZ] = ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_PosZ];
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][aid][A_Ang] = ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_Ang];

    MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][total_actors] ++;

    new str[128];
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" Actor successfully cloned! ( Map ID: %s(%i) | Actor ID: %i | skin ID: %i )", MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][M_Name], PLAYER_INFO[playerid][cur_player_mid], aid, ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_SKIN]);
    SendClientMessage(playerid, -1, str);

    if(PLAYER_INFO[playerid][labeled] == 1)
    {
        format(str, sizeof(str), ""#COL_YELLOW"ID: "#COL_RED"%i {ffffff}| "#COL_YELLOW"skin ID: "#COL_RED"%i", aid, ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][aid][A_SKIN]);
        ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][aid][A_LID] = CreateDynamic3DTextLabel(str, -1, ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][aid][A_PosX], ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][aid][A_PosY], ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][aid][A_PosZ], LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
    }

    format(str, sizeof(str), "/ae %i", aid);
    PC_EmulateCommand(playerid, str);
    return 1;
}

CMD:adc(playerid, params[])
{
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(PLAYER_INFO[playerid][cur_act] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing");
    if(!IsValidDynamicActor(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any object for editing");
    
    DestroyDynamicActor(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_ID]);

    new str[128];
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You deleted the actor ID %i ( skin ID: %i )", PLAYER_INFO[playerid][cur_act], ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_SKIN]);
    SendClientMessage(playerid, -1, str);

    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_ID] = -1; 
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_SKIN] = -1;
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_PosX] = -1;
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_PosY] = -1;
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_PosZ] = -1;
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][A_Ang] = -1;
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][animused] = 0;
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][PLAYER_INFO[playerid][cur_act]][animid] = -1;

    PLAYER_INFO[playerid][cur_act] = -1;
    MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][total_actors]--;
    return 1;
}

CMD:ad(playerid, params[])
{
    new id;
    if(PLAYER_INFO[playerid][mLoaded] == 0) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't loaded any maps for editing");
    if(PLAYER_INFO[playerid][cur_player_mid] == -1) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You haven't selected any map for editing");
    if(sscanf(params, "i", id)) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" /ad <actor ID>");
    if(id < 0 || id > MAX_ACT) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid Actor ID");
    if(!IsValidDynamicActor(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_ID])) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Invalid actor ID");
    if(id == PLAYER_INFO[playerid][cur_act]) return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You are currently editing this actor ( use /adc )");

    DestroyDynamicActor(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_ID]);

    new str[128];
    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_YELLOW" You deleted the actor ID %i ( actor ID: %i )", id, ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_SKIN]);
    SendClientMessage(playerid, -1, str);

    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_ID] = -1; 
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_SKIN] = -1;
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_PosX] = -1;
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_PosY] = -1;
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_PosZ] = -1;
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_Ang] = -1;
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][animused] = 0;
    ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][animid] = -1;

    MAP_INFO[PLAYER_INFO[playerid][cur_svr_mid]][total_actors]--;

    if(PLAYER_INFO[playerid][labeled] == 1)
    {
        if(IsValidDynamic3DTextLabel(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_LID])) DestroyDynamic3DTextLabel(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][id][A_LID]);
    }
    return 1;
}

CMD:asearch(playerid, params[])
{
    new substr[16];
    static str[312 * sizeof(substr)]; 

    for(new i = 0; i < 312; i++) 
    {
        format(substr, sizeof(substr), "%i\tID: %i\n", i, i);
        strcat(str, substr);
    } 

    ShowPlayerDialog(playerid, DIALOG_CLOSE_DIALOG, DIALOG_STYLE_PREVIEW_MODEL, "GEditor - Skin browser", str, "Close", ""); 
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) 
{
    switch(dialogid) 
    {
        case DIALOG_OBJECT_SEARCH:
        {
            if(response)
            {
                ShowPlayerDialog(playerid, DIALOG_MODEL_SEARCH, DIALOG_STYLE_INPUT, "GEditor - Search object models", "Input the whole name or part of the name\nof any object", "Search", "Close");
            }
            else return 1;
        }
        case DIALOG_CMDS:
        {
            if(response)
            {
                new str[2048];
                strcat(str, ""#COL_GREEN"Object textures, Colors, Text Commands:\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/tbrowse [slot]\t\t\t\t\t- Browse through all the textures\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/tsearch <name>\t\t\t\t\t- Search all textures with name or part of name\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/mattext <index> <text>\t\t\t\t- Set text on current editing object\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/matfont <index> <font ID>\t\t\t\t- Set material text font style\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/matreset <index>\t\t\t\t\t- Reset the material of a particular index\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/matfontsize <index> <size>\t\t\t\t- Edit font size of current editing object\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/matbold <index>\t\t\t\t\t- Toggle material text boldness\n", sizeof(str));   
                strcat(str, ""#COL_WHITE"/matfontcolor <index> <color>\t\t\t- Change text color on current editing object\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/matcolor <index> <color>\t\t\t\t- Toggle back color of material\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/mattexture <index> <texture ID>\t\t\t- Texture current editing object with a new material\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/mattextureall <index> <texture ID>\t\t\t- set all objects in map in textureid\n\n", sizeof(str)); 
                strcat(str, ""#COL_GREEN"Actor Commands:\n", sizeof(str));  
                strcat(str, ""#COL_WHITE"/asearch\t\t\t\t\t\t- Browse through all skin IDs\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/ac <skinID>\t\t\t\t\t\t- Create actor\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/askinc <new skin ID>\t\t\t\t\t- Swap the skin of current editing actor\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/abring\t\t\t\t\t\t\t- Bring current editing actor to your location and your facing angle\n", sizeof(str));     
                strcat(str, ""#COL_WHITE"/aclone\t\t\t\t\t\t\t- Clone current editing actor\n", sizeof(str));                       
                strcat(str, ""#COL_WHITE"/agoto <ID in map>\t\t\t\t\t- Go to a given actor ID in map\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/aanim <anim ID>\t\t\t\t\t- Remove actor animation\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/aremoveanim <actor ID>\t\t\t\t- Set actor animation\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/anim <anim ID>\t\t\t\t\t- Animation preview", sizeof(str));
                ShowPlayerDialog(playerid, DIALOG_CMDS2, DIALOG_STYLE_MSGBOX, "GEditor - Commands - Page(2/3)", str, "Next", "Back");
            }
            else return 1;
            return 1;
        }
        case DIALOG_CMDS2:
        {
            if(response)
            {
                new str[1024];
                strcat(str, ""#COL_GREEN"Vehicle Commands:\n", sizeof(str));    
                strcat(str, ""#COL_WHITE"/vsearch\t\t\t\t\t\t- Browse through all Vehicles\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/vadd\t\t\t\t\t\t\t- Add vehicle to the map\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/vmodel <vehicle ID> <new model>\t\t\t- Swap the vehicle model to a new one\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/vadd\t\t\t\t\t\t\t- Save the current position for vehicle\n", sizeof(str));     
                strcat(str, ""#COL_WHITE"/vbring <vehicle ID>\t\t\t\t\t- Go to vehicle ID in map\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/vcolor1 <vehicle ID> <color>\t\t\t\t- Set the 1st color of vehicle\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/vcolor2 <vehicle ID> <color>\t\t\t\t- Set the 2st color of vehicle", sizeof(str));
                ShowPlayerDialog(playerid, DIALOG_CMDS3, DIALOG_STYLE_MSGBOX, "GEditor - Commands - Page(3/3)", str, "Back", "Close");
            }
            else return PC_EmulateCommand(playerid, "/gcmds");
            return 1;
        }
        case DIALOG_CMDS3:
        {
            if(response)
            {
                new str[2048];
                strcat(str, ""#COL_GREEN"Object textures, Colors, Text Commands:\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/tbrowse [slot]                        - Browse through all the textures\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/tsearch <name>                        - Search all textures with name or part of name\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/mattext <index> <text>                - Set text on current editing object\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/matfont <index> <font ID>             - Set material text font style\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/matreset <index>                      - Reset the material of a particular index\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/matfontsize <index> <size>            - Edit font size of current editing object\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/matbold <index>                       - Toggle material text boldness\n", sizeof(str));   
                strcat(str, ""#COL_WHITE"/matfontcolor <index> <color>          - Change text color on current editing object\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/matcolor <index> <color>              - Toggle back color of material\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/mattexture <index> <texture ID>       - Texture current editing object with a new material\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/mattextureall <index> <texture ID>    - set all objects in map in textureid\n\n", sizeof(str)); 
                strcat(str, ""#COL_GREEN"Actor Commands:\n", sizeof(str));  
                strcat(str, ""#COL_WHITE"/asearch                               - Browse through all skin IDs\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/ac <skinID>                           - Create actor\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/askinc <new skin ID>                  - Swap the skin of current editing actor\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/abring                                - Bring current editing actor to your location and your facing angle\n", sizeof(str));     
                strcat(str, ""#COL_WHITE"/aclone                                - Clone current editing actor\n", sizeof(str));                       
                strcat(str, ""#COL_WHITE"/agoto <ID in map>                     - Go to a given actor ID in map\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/aanim <anim ID>                       - Remove actor animation\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/aremoveanim <actor ID>                - Set actor animation\n", sizeof(str));
                strcat(str, ""#COL_WHITE"/anim <anim ID>                        - Animation preview", sizeof(str));
                ShowPlayerDialog(playerid, DIALOG_CMDS2, DIALOG_STYLE_MSGBOX, "GEditor - Commands - Page(2/3)", str, "Next", "Back");
            }
            else return 1;
        }
        case DIALOG_MAPS:
        {
            if(response)
            {
                if(isequal(mDialog[playerid][listitem], "-1")) return 1;
                new str[128];
                format(str, sizeof(str), "GEditor - Management Tools for Map '%s'", mDialog[playerid][listitem]);
                format(cur_map[playerid], 20, "%s", mDialog[playerid][listitem]);
                ShowPlayerDialog(playerid, DIALOG_MANAGE_MAP, DIALOG_STYLE_LIST, str, "Map Information\nEdit Name\nEdit Password\nDelete Map", "Select", "Close");
            }
            else return 1;
            return 1;
        }
        case DIALOG_MANAGE_MAP:
        {
            if(response)
            {
                new str_[50];
                format(str_, sizeof(str_), MAP_SAVE_PATH, cur_map[playerid]);
                switch(listitem)
                {
                    case 0:
                    {
                        new str[256];
                        format(str, 256, "| - |Map Name : %s\n| - |Map creator : %s\n| - |Date Created : %s\n| - |Map Password : %s\n| - |Total Objects : %i\n| - |Total Actors : %i", cur_map[playerid], dini_Get(str_, "Creator"), dini_Get(str_, "Date_Created"), dini_Get(str_, "Password"), dini_Int(str_, "Total_Objects"), dini_Int(str_, "Total_Actors"));
                        ShowPlayerDialog(playerid, DIALOG_MAP_INFO, DIALOG_STYLE_MSGBOX, "GEditor - Map Information", str, "Back", "Close");
                    }
                    case 1:
                    {
                        new str[256];
                        format(str, sizeof(str), "Enter a desired name as the new name\nfor map '%s'\nIf someone has loaded the map inform\nation about name change will be sent\nto him [ Creator - %s ]", cur_map[playerid], dini_Get(str_, "Creator"));
                        ShowPlayerDialog(playerid, DIALOG_MAP_NAME, DIALOG_STYLE_INPUT, "GEditor - Map Name", str, "Enter", "Back");
                    }
                    case 2:
                    {
                        new str[256];
                        format(str, sizeof(str), "Enter a desired password as the new password\nfor map '%s'\nIf someone has loaded the map information\nabout password change will be sent to him\n[ Creator - %s ]", cur_map[playerid], dini_Get(str_, "Password"));
                        ShowPlayerDialog(playerid, DIALOG_MAP_PASS, DIALOG_STYLE_INPUT, "GEditor - Map Password", str, "Enter", "Back");
                    }
                    case 3:
                    {
                        new str[256];
                        format(str, sizeof(str), "Are you sure that you want to\ndelete Map '%s' created by '%s'", cur_map[playerid], dini_Get(str_, "Creator"));
                        ShowPlayerDialog(playerid, DIALOG_MAP_DELETE, DIALOG_STYLE_MSGBOX, "GEditor - Map Password", str, "Delete", "Back");
                    }
                }
            }
            else return 1;
            return 1;
        }
        case DIALOG_MAP_INFO:
        {
            if(response)
            {
                new str[128];
                format(str, sizeof(str), "GEditor - Management Tools for Map '%s'", cur_map[playerid]);
                ShowPlayerDialog(playerid, DIALOG_MANAGE_MAP, DIALOG_STYLE_LIST, str, "Map Information\nEdit Name\nEdit Password\nDelete Map", "Select", "Close");
            }
            else return 1;
            return 1;
        }
        case DIALOG_MAP_NAME:
        {
            if(response)
            {
                new str_[50];
                format(str_, sizeof(str_), MAP_SAVE_PATH, cur_map[playerid]);

                if(strlen(inputtext) > 20 || strlen(inputtext) < 4 || !IsValidMapName(inputtext))  
                {
                    new str[256];
                    format(str, sizeof(str), "Enter a desired name as the new name\nfor map '%s'\nIf someone has loaded the map inform\nation about name change will be sent\nto him [ Creator - %s ]", cur_map[playerid], dini_Get(str_, "Creator"));
                    ShowPlayerDialog(playerid, DIALOG_MAP_NAME, DIALOG_STYLE_INPUT, "GEditor - Map Name", str, "Enter", "Back");
                    return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Map name should contain only 4 - 20 characters with lowercase letters or numbers");
                }
                
                new path[50];
                format(path, sizeof(path), MAP_SAVE_PATH, inputtext);

                if(dini_Exists(path))
                {
                    new str[256];
                    format(str, sizeof(str), "Enter a desired name as the new name\nfor map '%s'\nIf someone has loaded the map inform\nation about name change will be sent\nto him [ Creator - %s ]", cur_map[playerid], dini_Get(str_, "Creator"));
                    ShowPlayerDialog(playerid, DIALOG_MAP_NAME, DIALOG_STYLE_INPUT, "GEditor - Map Name", str, "Enter", "Back");
                    return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" A map with this name already exsists");
                }

                new id = -1;
                foreach(new i : Player)
                {
                    for(new j = 0; j < MAX_LOADABLE_MAPS_AT_ONCE; j++)
                    {
                        if(isequal(PLAYER_mName[i][j], cur_map[playerid]))
                        {
                            format(PLAYER_mName[i][j], 20, "%s", inputtext);
                            id = i;
                            break;
                        }
                    }
                    if(id != -1) break;
                }

                new str[128];
                if(id != -1)
                {
                    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_GREY" Admin '%s[%i]' has changed the name of your map '%s' to '%s'", PlayerName(playerid), playerid, cur_map[playerid], inputtext);
                    SendClientMessage(id, -1, str);
                    for(new i = 0; i < MAX_LOADABLE_MAPS_IN_SERVER; i++)
                    {
                        if(isequal(MAP_INFO[i][M_Name], cur_map[playerid]))
                        {
                            format(MAP_INFO[i][M_Name], 20, "%s", inputtext);
                            break;
                        }
                    }
                }
                
                format(str, sizeof(str), MAP_SAVE_PATH, inputtext);
                frename(str_, str);

                for(new i = 0; i < MAX_CREATABLE_MAPS_IN_SERVER; i++)
                {
                    format(str_, sizeof(str_), "%i_Map", i);
                    if(dini_Isset(MAP_EDITOR_CONF_PATH, str_) && isequal(cur_map[playerid], dini_Get(MAP_EDITOR_CONF_PATH, str_)))
                    {
                        dini_Set(MAP_EDITOR_CONF_PATH, str_, inputtext);
                        break;
                    }
                }

                format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_GREY" You changed the name of map '%s' to '%s'", cur_map[playerid], inputtext);
                SendClientMessage(playerid, -1, str);

                format(cur_map[playerid], 20, "%s", inputtext);

                format(str, sizeof(str), "GEditor - Management Tools for Map '%s'", cur_map[playerid]);
                ShowPlayerDialog(playerid, DIALOG_MANAGE_MAP, DIALOG_STYLE_LIST, str, "Map Information\nEdit Name\nEdit Password\nDelete Map", "Select", "Close");
            }
            else
            {
                new str[128];
                format(str, sizeof(str), "GEditor - Management Tools for Map '%s'", cur_map[playerid]);
                ShowPlayerDialog(playerid, DIALOG_MANAGE_MAP, DIALOG_STYLE_LIST, str, "Map Information\nEdit Name\nEdit Password\nDelete Map", "Select", "Close");
            }
            return 1;
        }
        case DIALOG_MAP_PASS:
        {
            if(response)
            {
                new str_[50];
                format(str_, sizeof(str_), MAP_SAVE_PATH, cur_map[playerid]);
                
                if(strlen(inputtext) < 4 || strlen(inputtext) > 20)
                {
                    new str[256];
                    format(str, sizeof(str), "Enter a desired password as the new password\nfor map '%s'\nIf someone has loaded the map information\nabout password change will be sent to him\n[ Creator - %s ]", cur_map[playerid], dini_Get(str_, "Password"));
                    ShowPlayerDialog(playerid, DIALOG_MAP_PASS, DIALOG_STYLE_INPUT, "GEditor - Map Password", str, "Enter", "Back");
                    return SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" Map password should contain only 4 - 20 characters with lowercase letters or numbers"); 
                }

                new id = -1;
                foreach(new i : Player)
                {
                    for(new j = 0; j < MAX_LOADABLE_MAPS_AT_ONCE; j++)
                    {
                        if(isequal(PLAYER_mName[i][j], cur_map[playerid]))
                        {
                            id = i;
                            break;
                        }
                    }
                    if(id != -1) break;
                }

                dini_Set(str_, "Password", inputtext);
                new str[128];
                if(id != -1)
                {
                    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_GREY" Admin '%s[%i]' has changed the password of your map '%s' to '%s'", PlayerName(playerid), playerid, cur_map[playerid], inputtext);
                    SendClientMessage(id, -1, str);
                }

                format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_GREY" You changed the password of map '%s' to '%s'", cur_map[playerid], inputtext);
                SendClientMessage(playerid, -1, str);

                format(str, sizeof(str), "GEditor - Management Tools for Map '%s'", cur_map[playerid]);
                ShowPlayerDialog(playerid, DIALOG_MANAGE_MAP, DIALOG_STYLE_LIST, str, "Map Information\nEdit Name\nEdit Password\nDelete Map", "Select", "Close");
            }
            else
            {
                new str[128];
                format(str, sizeof(str), "GEditor - Management Tools for Map '%s'", cur_map[playerid]);
                ShowPlayerDialog(playerid, DIALOG_MANAGE_MAP, DIALOG_STYLE_LIST, str, "Map Information\nEdit Name\nEdit Password\nDelete Map", "Select", "Close");
            }
            return 1;
        }
        case DIALOG_MAP_DELETE:
        {
            new str_[50];
            format(str_, sizeof(str_), MAP_SAVE_PATH, cur_map[playerid]);
            if(response)
            {
                new str[128];
                format(str, sizeof(str), MAP_SAVE_PATH, cur_map[playerid]);

                new id = -1;
                foreach(new i : Player)
                {
                    for(new j = 0; j < MAX_LOADABLE_MAPS_AT_ONCE; j++)
                    {
                        if(isequal(PLAYER_mName[i][j], cur_map[playerid]))
                        {
                            id = i;
                            break;
                        }
                    }
                    if(id != -1) break;
                }
                
                if(id != -1)
                {
                    format(str, sizeof(str), "/ulm %s %s", cur_map[playerid], dini_Get(str_, "Password"));
                    PC_EmulateCommand(id, str);
                    format(str, sizeof(str), ""#COL_BLUE"|GEditor|"#COL_GREY" Admin '%s[%i]' has force unloaded and deleted one of your loaded maps ( deleted map name: %s )", PlayerName(playerid), playerid, cur_map[playerid]);
                    SendClientMessage(id, -1, str);
                }

                SetTimerEx("MapDeleteEx", 1000, 0, "i", playerid);
            }
            else
            {
                new str[256];
                format(str, sizeof(str), "Are you sure that you want to\ndelete Map '%s' created by '%s'", cur_map[playerid], dini_Get(str_, "Creator"));
                ShowPlayerDialog(playerid, DIALOG_MAP_DELETE, DIALOG_STYLE_MSGBOX, "GEditor - Map Password", str, "Delete", "Back");
            }
            return 1;
        }
        case DIALOG_EDIT_MAP:
        {   
            if(response)
            {
                new count = -1, mid;
                for(new i = 0; i < MAX_LOADABLE_MAPS_AT_ONCE; i++)
                {
                    if(!isequal(PLAYER_mName[playerid][i], "-1"))
                    {
                        count ++;
                        if(count == listitem)
                        {
                            mid = i;
                            break;
                        }
                    }
                }

                new id = GetServerMapID(PLAYER_mName[playerid][mid]);

                if(MAP_INFO[id][forview])
                {
                    SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" This map is loaded only for view, You can't select it for editing!");
                    return PC_EmulateCommand(playerid, "/em");
                }

                if(PLAYER_INFO[playerid][cur_player_mid] == mid)
                {
                    SendClientMessage(playerid, -1, ""#COL_BLUE"|GEditor|"#COL_RED" You have already selected this map for editing!");
                    return PC_EmulateCommand(playerid, "/em");
                }
                
                if(PLAYER_INFO[playerid][labeled] == 1)
                {
                    if(PLAYER_INFO[playerid][cur_svr_mid] != -1)
                    {
                        for(new i = 0; i < MAX_OBJ; i++)
                        {
                            if(IsValidDynamicObject(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_ID]))
                            {
                                if(IsValidDynamic3DTextLabel(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID]))
                                {
                                    DestroyDynamic3DTextLabel(OBJ_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][O_LID]);
                                }
                            }
                        }   

                        for(new i = 0; i < MAX_ACT; i++)
                        {
                            if(IsValidDynamicActor(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_ID]))
                            {
                                if(IsValidDynamic3DTextLabel(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_LID]))
                                {
                                    DestroyDynamic3DTextLabel(ACT_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][A_LID]);
                                }
                            }
                        }   

                        for(new i = 0; i < MAX_VEH; i++)
                        {
                            if(IsValidVehicle(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_ID]))
                            {
                                if(IsValidDynamic3DTextLabel(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_LID]))
                                {
                                    DestroyDynamic3DTextLabel(VEH_INFO[PLAYER_INFO[playerid][cur_svr_mid]][i][V_LID]);
                                }
                            }
                        }   
                    }

                    for(new i = 0; i < MAX_OBJ; i ++)
                    {
                        if(IsValidDynamicObject(OBJ_INFO[id][i][O_ID]))
                        {
                            new str[128];
                            format(str, sizeof(str), ""#COL_YELLOW"ID: %i {ffffff}| "#COL_YELLOW"Model ID: %i", i, OBJ_INFO[id][i][O_MODEL_ID]);
                            OBJ_INFO[id][i][O_LID] = CreateDynamic3DTextLabel(str, -1, OBJ_INFO[id][i][O_PosX], OBJ_INFO[id][i][O_PosY], OBJ_INFO[id][i][O_PosZ], LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
                        }
                    }

                    for(new i = 0; i < MAX_ACT; i ++)
                    {
                        if(IsValidDynamicActor(ACT_INFO[id][i][A_ID]))
                        {
                            new str[128];
                            format(str, sizeof(str), ""#COL_YELLOW"ID: %i {ffffff}| "#COL_YELLOW"Skin ID: %i", i, ACT_INFO[id][i][A_ID]);
                            ACT_INFO[id][i][A_LID] = CreateDynamic3DTextLabel(str, -1, ACT_INFO[id][i][A_PosX], ACT_INFO[id][i][A_PosY], ACT_INFO[id][i][A_PosZ], LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
                        }
                    }

                    for(new i = 0; i < MAX_VEH; i ++)
                    {
                        if(IsValidVehicle(VEH_INFO[id][i][V_ID]))
                        {
                            new str[128];
                            format(str, sizeof(str), ""#COL_YELLOW"ID: %i {ffffff}| "#COL_YELLOW"Model ID: %i", i, VEH_INFO[id][i][V_ID]);
                            VEH_INFO[id][i][V_LID] = CreateDynamic3DTextLabel(str, -1, VEH_INFO[id][i][V_PosX], VEH_INFO[id][i][V_PosY], VEH_INFO[id][i][V_PosZ], LABEL_DRAW_DISTANCE, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
                        }
                    }
                }

                PLAYER_INFO[playerid][cur_player_mid] = mid;
                PLAYER_INFO[playerid][cur_svr_mid] = id;
                PLAYER_INFO[playerid][cur_obj] = -1;
                PLAYER_INFO[playerid][cur_act] = -1;

                PC_EmulateCommand(playerid, "/em");
            }   
            else return 1;
            return 1;
        }
        case DIALOG_MODEL_SEARCH:
        {
            if(response)
            {
                if(strlen(inputtext) > 0)
                {
                    new i, iMatches, szBuffer[20], szID[6], szDialog[128 + (25) + (20 * 25)];

                    for(i = 0; i < sizeof(MODEL_NAMES); i++)
                    {
                        strunpack(szBuffer, MODEL_NAMES[i][M_Name_], 20);
                        if(strfind(szBuffer, inputtext, true) != -1)
                        {
                            valstr(szID, MODEL_NAMES[i][M_ID]);

                            strcat(szDialog, szID);
                            strcat(szDialog, "\t");
                            strcat(szDialog, "ID: ");
                            strcat(szDialog, szID);
                            strcat(szDialog, "\n");

                            ++iMatches;
                        }
                    } 

                    if(iMatches == 0)
                    {
                        format(szDialog, sizeof(szDialog), "No matches were found for '%s'.\nInput the whole name or part of the name\nof any object", inputtext);
                        return ShowPlayerDialog(playerid, DIALOG_MODEL_SEARCH, DIALOG_STYLE_INPUT, "GEditor - Search object models", szDialog, "Search", "Close");
                    }
                    
                    new str[128];
                    format(str, sizeof(str), "GEditor - Search results for '%s'", inputtext);
                    ShowPlayerDialog(playerid, 567, DIALOG_STYLE_PREVIEW_MODEL, str, szDialog, "Search", "Close"); 
                }
                else ShowPlayerDialog(playerid, DIALOG_MODEL_SEARCH, DIALOG_STYLE_INPUT, "GEditor - Search Object Models", "No matches were found", "Search", "Close");
            }
            else return 1;
            return 1;
        }
    }
    return 1;
}
