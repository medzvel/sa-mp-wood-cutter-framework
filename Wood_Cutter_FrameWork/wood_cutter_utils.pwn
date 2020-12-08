#define MAX_TREE 100


#define MAX_TREE_HEALTH 80.0


#define TREE_MODEL 700


#define TREE_CUTTED_OBJECT 834


#if defined OnPlayerStartWoodCutting
forward OnPlayerStartWoodCutting(playerid, tree_id);
#endif

#if defined OnPlayerEndWoodCutting
forward OnPlayerEndWoodCutting(playerid, tree_id, Float:cutted);
#endif

new 
		TREE_OBJECT_MAIN[MAX_TREE],
		TREE_OBJECT_DEAD[MAX_TREE],
		Float:TREE_HEALTH[MAX_TREE],
		Float:TREE_POS_X[MAX_TREE],
		Float:TREE_POS_Y[MAX_TREE],
		Float:TREE_POS_Z[MAX_TREE],
		TREE_IS_GETTING_CUTTED[MAX_TREE],
		bool:TREE_AVAILABLE_FOR_CUTTING[MAX_TREE],
		Text3D:TREE_LABEL[MAX_TREE]
;


new TREE_CREATED = 0;


new Text:Wood_CutterGlobalTD[3];

new bool:PLAYER_IS_CUTTING_TREE[MAX_PLAYERS], PLAYER_CUTTING_TARGET_TREE[MAX_PLAYERS] = -1, Float:PLAYER_CUTTING_VALUE[MAX_PLAYERS], PlayerBar:PLAYER_CUTTING_PROGRESS_BAR[MAX_PLAYERS], PLAYER_WOOD_CUTTING_TIMER[MAX_PLAYERS];

forward CreateTree(Float:t_pos_x, Float:t_pos_y, Float:t_pos_z, Float:health);
CreateTree(Float:t_pos_x, Float:t_pos_y, Float:t_pos_z, Float:health)
{
	new t_id = TREE_CREATED;
	
	TREE_HEALTH[t_id] = health;
	
	TREE_POS_X[t_id] = t_pos_x;
	TREE_POS_Y[t_id] = t_pos_y;
	TREE_POS_Z[t_id] = t_pos_z;

	TREE_IS_GETTING_CUTTED[t_id] = false;
	TREE_AVAILABLE_FOR_CUTTING[t_id] = true;

	TREE_OBJECT_MAIN[t_id] = CreateObject(TREE_MODEL, t_pos_x-0.5, t_pos_y, t_pos_z-2.0, 0.0, 0.0, 0.0, 7777.77);
	TREE_OBJECT_DEAD[t_id] = CreateObject(TREE_CUTTED_OBJECT, t_pos_x, t_pos_y, t_pos_z-2.4, 0.0, 0.0, 0.0, 7777.77);

	new temp_str[124];
	format(temp_str, sizeof(temp_str), "Tree(%d)\nHealth:%f", t_id, health);
	TREE_LABEL[t_id] = Create3DTextLabel(temp_str, -1, t_pos_x, t_pos_y, t_pos_z, 4.0, 0);
	
	return TREE_CREATED++;

}

forward KillTree(t_id, respawntime);
KillTree(t_id, respawntime)
{
	TREE_HEALTH[t_id] = 0.0;

	DestroyObject(TREE_OBJECT_MAIN[t_id]);

	TREE_AVAILABLE_FOR_CUTTING[t_id] = false;

	new temp_str[124];
	format(temp_str, sizeof(temp_str), "Tree(%d)\nHealth: {FF0000}DEAD", t_id);

	Update3DTextLabelText(TREE_LABEL[t_id], -1, temp_str);

	SetTimerEx("TreeRespawn", respawntime, false, "d", t_id);
}

forward TreeRespawn(t_id);
public TreeRespawn(t_id)
{
	TREE_HEALTH[t_id] = 100.0;

	TREE_OBJECT_MAIN[t_id] = CreateObject(TREE_MODEL, TREE_POS_X[t_id]-0.5, TREE_POS_Y[t_id], TREE_POS_Z[t_id]-2.0, 0.0, 0.0, 0.0, 7777.77);

	TREE_AVAILABLE_FOR_CUTTING[t_id] = true;

	new temp_str[124];
	format(temp_str, sizeof(temp_str), "Tree(%d)\nHealth:%f", t_id, TREE_HEALTH[t_id]);
	Update3DTextLabelText(TREE_LABEL[t_id], -1, temp_str);
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & 1024)
	{
		if(IsPlayerNearTree(playerid))
		{
			new temp_tree_id;
			GetPlayerNearByTree(playerid, temp_tree_id);
			StartPlayerWoodCutting(playerid, temp_tree_id);
			#if defined OnPlayerStartWoodCutting
			CallLocalFunction("OnPlayerStartWoodCutting", "dd", playerid, temp_tree_id);
			#endif
		}
	}
	if(newkeys & KEY_FIRE)
	{
		//SendClientMessage(playerid, -1, "DAACHIRE MAUSIS GILAKS");
		new bool:temp_is_cutting;
		IsPlayerCuttingTree(playerid, temp_is_cutting);
		if(temp_is_cutting && IsPlayerNearTree(playerid)) 
		{
			if(PLAYER_CUTTING_VALUE[playerid] >= GetPlayerProgressBarMaxValue(playerid,	 PLAYER_CUTTING_PROGRESS_BAR[playerid]))
			{
				new temp_tree_id;
				GetPlayerNearByTree(playerid, temp_tree_id);
				StopPlayerWoodCutting(playerid, temp_tree_id, frandom(15.0, 1.0));
			}
			PLAYER_CUTTING_VALUE[playerid] = PLAYER_CUTTING_VALUE[playerid] + frandom(5.0, 1.0);
			SetPlayerProgressBarValue(playerid, PLAYER_CUTTING_PROGRESS_BAR[playerid], PLAYER_CUTTING_VALUE[playerid]);
		//	new temp_str_debug[64];
		//	format(temp_str_debug, sizeof(temp_str_debug), "%f CUTTING VALUE ", PLAYER_CUTTING_VALUE[playerid]);
		//	SendClientMessage(playerid, -1, temp_str_debug);
		}
	}
	return 1;
}

#if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange WC_OnPlayerKeyStateChange
#if defined WC_OnPlayerKeyStateChange
    forward WC_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif

public OnPlayerConnect(playerid)
{
	PLAYER_CUTTING_PROGRESS_BAR[playerid] = CreatePlayerProgressBar(playerid, 276.000000, 335.000000, 141.000000, 24.700000, -1429936641, 40.0000, 0); 
	return 1;
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect WC_OnPlayerConnect
#if defined WC_OnPlayerConnect
    forward WC_OnPlayerConnect(playerid);
#endif

stock GetPlayerNearByTree(playerid, &t_id)
{
	new Float:temp_x, Float:temp_y, Float:temp_z;
	
	t_id = -1;

	GetPlayerPos(playerid, temp_x, temp_y, temp_z);

	for(new i; i<TREE_CREATED; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.0, TREE_POS_X[i], TREE_POS_Y[i], TREE_POS_Z[i]))
		{
			t_id = i;
		}
	}
}

stock IsPlayerNearTree(playerid)
{
	new temp_tree_id;
	GetPlayerNearByTree(playerid, temp_tree_id);
	if(temp_tree_id != -1)
	{
		return 1;
	}
	return 0;
}

stock GotoTree(playerid, t_id)
{
	SetPlayerPos(playerid, TREE_POS_X[t_id], TREE_POS_Y[t_id], TREE_POS_Z[t_id]);
}


stock StartPlayerWoodCutting(playerid, t_id)
{
	TextDrawShowForPlayer(playerid, Wood_CutterGlobalTD[0]);
	TextDrawShowForPlayer(playerid, Wood_CutterGlobalTD[1]);
	TextDrawShowForPlayer(playerid, Wood_CutterGlobalTD[2]);
	ShowPlayerProgressBar(playerid, PLAYER_CUTTING_PROGRESS_BAR[playerid]);
	SetPlayerProgressBarValue(playerid, PLAYER_CUTTING_PROGRESS_BAR[playerid], 0.0);
	SetPlayerProgressBarMaxValue(playerid, PLAYER_CUTTING_PROGRESS_BAR[playerid], 80);
	PLAYER_IS_CUTTING_TREE[playerid] = true;
	PLAYER_CUTTING_VALUE[playerid] = 0.0;
	PLAYER_CUTTING_TARGET_TREE[playerid] = t_id;
	PLAYER_WOOD_CUTTING_TIMER[playerid] = SetTimerEx("woodCuttingValueCheck", 350, true, "i", playerid);
	TogglePlayerControllable(playerid, false);
}
forward woodCuttingValueCheck(playerid);
public woodCuttingValueCheck(playerid)
{
	if(PLAYER_CUTTING_VALUE[playerid] > 0.0)
	{
		PLAYER_CUTTING_VALUE[playerid] = PLAYER_CUTTING_VALUE[playerid] - frandom(5.0, 2.5);
		SetPlayerProgressBarValue(playerid, PLAYER_CUTTING_PROGRESS_BAR[playerid], PLAYER_CUTTING_VALUE[playerid]);
	}
}


stock StopPlayerWoodCutting(playerid, t_id, Float:cutted)
{
	TextDrawHideForPlayer(playerid, Wood_CutterGlobalTD[0]);
	TextDrawHideForPlayer(playerid, Wood_CutterGlobalTD[1]);
	TextDrawHideForPlayer(playerid, Wood_CutterGlobalTD[2]);
	HidePlayerProgressBar(playerid, PLAYER_CUTTING_PROGRESS_BAR[playerid]);
	PLAYER_IS_CUTTING_TREE[playerid] = false;
	PLAYER_CUTTING_VALUE[playerid] = 0.0;
	PLAYER_CUTTING_TARGET_TREE[playerid] = -1;

	KillTimer(PLAYER_WOOD_CUTTING_TIMER[playerid]);


	new Float:temp_t_health;
	GetTreeHealth(t_id, temp_t_health);


	SetTreeHealth(t_id, temp_t_health - frandom(20.0, 1.0));

	TogglePlayerControllable(playerid, true);
	UpdateTree(t_id);

	#if defined OnPlayerEndWoodCutting
	CallLocalFunction("OnPlayerEndWoodCutting", "ddf", playerid, t_id, cutted);
	#endif

}


stock GetPlayerTargetTree(playerid, &t_id)
{
	if(PLAYER_CUTTING_TARGET_TREE[playerid] != -1)
	{
		t_id = PLAYER_CUTTING_TARGET_TREE[playerid];
	}
	else
	{
		t_id = -1;
	}
}

stock UpdateTreeLabel(t_id)
{
	new temp_str[124], Float:temp_t_health;
	GetTreeHealth(t_id, temp_t_health);
	format(temp_str, sizeof(temp_str), "Tree(%d)\nHealth:%f", t_id, temp_t_health);
	Update3DTextLabelText(TREE_LABEL[t_id], -1, temp_str);

	///TREE_LABEL[t_id] = Create3DTextLabel(temp_str, -1, t_pos_x, t_pos_y, t_pos_z, 4.0, 0);	
}


stock UpdateTree(t_id)
{
	new Float:temp_t_health;
	GetTreeHealth(t_id, temp_t_health);
	if(temp_t_health <= 0.0)
	{
		KillTree(t_id, 600000);
	}
	else
	{
		UpdateTreeLabel(t_id);
	}
}

stock SetTreeHealth(t_id, Float:t_health)
{
	if(TREE_POS_X[t_id] != 0.0) // tree exist
	{
		TREE_HEALTH[t_id] = t_health;
	}
	else printf("[SET TREE HEALTH] Tree(%d) Doesn't exist", t_id);
}


stock GetTreeHealth(t_id, &Float:t_health)
{
	if(TREE_POS_X[t_id] != 0.0)
	{
		t_health = TREE_HEALTH[t_id];
	}
	else printf("[GET TREE HEALTH] Tree(%d) Doesn't exist", t_id);

}


stock IsPlayerCuttingTree(playerid, &bool:is_cutting)
{
	if(PLAYER_IS_CUTTING_TREE[playerid] == true)
	{
		is_cutting = true;
	}
	else
	{
		is_cutting = false;
	}	
}

stock LoadTrees(filename[])
{
	new
		File:file,
		line[256],
		linenumber = 1,
		count,

		funcname[32],
		funcargs[128],

		Float:x,
		Float:y,
		Float:z;

	if(!fexist(filename))
	{
		printf("[WOOD CUTTER ERROR] file: \"%s\" NOT FOUND", filename);
		return 0;
	}

	file = fopen(filename, io_read);

	if(!file)
	{
		printf("[WOOD CUTTER ERROR] \"%s\" NOT LOADED", filename);
		return 0;
	}

	while(fread(file, line))
	{
		if(line[0] < 65)
		{
			linenumber++;
			continue;
		}

		if(sscanf(line, "p<(>s[32]p<)>s[128]{s[96]}", funcname, funcargs))
		{
			linenumber++;
			continue;
		}

		if(!strcmp(funcname, "TreePositions"))
		{
			if(sscanf(funcargs, "p<,>fff", x, y, z))
			{
				printf("[WOOD CUTTER ERROR] [LOADING] Malformed parameters on line %d", linenumber);
				linenumber++;
				continue;
			}
			count++;
			linenumber++;
			CreateTree(x, y, z, 100.0);
		}
	}

	printf("[WOOD CUTTER] Loaded %d tree position from '%s'.", count, filename);

	return 1;
}
CreateWoodCuttingGTD()
{
	Wood_CutterGlobalTD[0] = TextDrawCreate(420.828002, 368.816497, "box");
	TextDrawLetterSize(Wood_CutterGlobalTD[0], 0.000000, -6.621235);
	TextDrawTextSize(Wood_CutterGlobalTD[0], 267.290283, 0.000000);
	TextDrawAlignment(Wood_CutterGlobalTD[0], 1);
	TextDrawColor(Wood_CutterGlobalTD[0], -1);
	TextDrawUseBox(Wood_CutterGlobalTD[0], 1);
	TextDrawBoxColor(Wood_CutterGlobalTD[0], -5963521);
	TextDrawSetShadow(Wood_CutterGlobalTD[0], 0);
	TextDrawSetOutline(Wood_CutterGlobalTD[0], 0);
	TextDrawBackgroundColor(Wood_CutterGlobalTD[0], 255);
	TextDrawFont(Wood_CutterGlobalTD[0], 1);
	TextDrawSetProportional(Wood_CutterGlobalTD[0], 1);
	TextDrawSetShadow(Wood_CutterGlobalTD[0], 0);

	Wood_CutterGlobalTD[1] = TextDrawCreate(274.538726, 313.083343, "CUTTING");
	TextDrawLetterSize(Wood_CutterGlobalTD[1], 0.400000, 1.600000);
	TextDrawAlignment(Wood_CutterGlobalTD[1], 1);
	TextDrawColor(Wood_CutterGlobalTD[1], -1);
	TextDrawSetShadow(Wood_CutterGlobalTD[1], 0);
	TextDrawSetOutline(Wood_CutterGlobalTD[1], 1);
	TextDrawBackgroundColor(Wood_CutterGlobalTD[1], 255);
	TextDrawFont(Wood_CutterGlobalTD[1], 1);
	TextDrawSetProportional(Wood_CutterGlobalTD[1], 1);
	TextDrawSetShadow(Wood_CutterGlobalTD[1], 0);

	Wood_CutterGlobalTD[2] = TextDrawCreate(332.242248, 313.283355, "      TREE");
	TextDrawLetterSize(Wood_CutterGlobalTD[2], 0.337686, 1.576667);
	TextDrawAlignment(Wood_CutterGlobalTD[2], 1);
	TextDrawColor(Wood_CutterGlobalTD[2], 0x33AA33AA);
	TextDrawSetShadow(Wood_CutterGlobalTD[2], 0);
	TextDrawSetOutline(Wood_CutterGlobalTD[2], 1);
	TextDrawBackgroundColor(Wood_CutterGlobalTD[2], 255);
	TextDrawFont(Wood_CutterGlobalTD[2], 1);
	TextDrawSetProportional(Wood_CutterGlobalTD[2], 1);
	TextDrawSetShadow(Wood_CutterGlobalTD[2], 0);	

}
