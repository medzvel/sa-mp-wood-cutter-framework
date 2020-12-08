// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>

#include <sscanf2>
#include <ZCMD>
#include <foreach>
#include <progress2>


stock Float:frandom(Float:max, Float:min = 0.0, dp = 4)
{
    new
        Float:mul = floatpower(10.0, dp),
        imin = floatround(min * mul),
        imax = floatround(max * mul);
    return float(random(imax - imin) + imin) / mul;
}

#include <Wood_Cutter_FrameWork\wood_cutter_utils.pwn>


main()
{
	print("\n----------------------------------");
	print(" Wood Test Cutter by your name here");
	print("----------------------------------\n");
}



public OnGameModeInit()
{
	LoadTrees("trees/trees.tr");
	CreateWoodCuttingGTD();
	SetGameModeText("Blank Script");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}

CMD:testtree(playerid, params[])
{
	new Float:temp_float_x, Float:temp_float_y, Float:temp_float_z;
	GetPlayerPos(playerid, temp_float_x, temp_float_y, temp_float_z);
	
	
	CreateTree(temp_float_x, temp_float_y, temp_float_z, 100.0);

	return 1;
}

CMD:testtree2(playerid, params[])
{
	KillTree(1, 10000);
	return 1;
}

CMD:gototree1(playerid, params[])
{
	GotoTree(playerid, 4);
	return 1;
}

CMD:getmytreeid(playerid, params[])
{
	new temp_t_id;
    GetPlayerNearByTree(playerid, temp_t_id);
    
    new temp_str_1[64];
    format(temp_str_1, sizeof(temp_str_1), "You are near Tree(%d)", temp_t_id);
    SendClientMessage(playerid, -1, temp_str_1);
    return 1;
}

CMD:settreehealth(playerid, params[])
{
	new temp_t_id;
	GetPlayerNearByTree(playerid, temp_t_id);
	
	SetTreeHealth(temp_t_id, 10.0);
	
	return 1;
}

public OnPlayerStartWoodCutting(playerid, tree_id)
{
	new temp_str[64];
	format(temp_str, sizeof(temp_str), "Shen Cdilob Mochra Tree(%d)", tree_id);
	SendClientMessage(playerid, -1, temp_str);
	return 1;
}

public OnPlayerEndWoodCutting(playerid, tree_id, Float:cutted)
{
	new temp_str[64];
	format(temp_str, sizeof(temp_str), "Shen mocheri %f WOOD FROM TREE(%d)", cutted, tree_id);
	SendClientMessage(playerid, -1, temp_str);
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	SetPlayerPos(playerid, fX, fY, fZ);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
