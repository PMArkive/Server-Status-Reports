#pragma newdecls required
#pragma semicolon 1

#include <sourcemod>
#include <csgocolors_fix>

// Core convars
ConVar g_cv_ReportInterval, g_cv_EnableStatusReport;

// Status Update convars
ConVar g_cv_ShowPadding, g_cv_ShowTime, g_cv_ShowPlayer, g_cv_ShowMap, g_cv_ShowEdict, g_cv_ShowUptime;

public Plugin myinfo =
{
	name = "Server Status Report",
	author = "koen#4977",
	description = "Prints server status information to chat in intervals",
	version = "1.3",
	url = "https://steamcommunity.com/id/fungame1224/"
};

public void OnPluginStart()
{
	// Load plugin translations
	LoadTranslations("statusreport.phrases");
	
	// Print status command
	RegConsoleCmd("sm_statusreport", Command_Status, "Print server status in chat");
	
	// Core functionality convars
	g_cv_EnableStatusReport = CreateConVar("sm_status_enable", "1", "Toggle status report messages in chat (1 to enable, 0 to disable)", _, true, 0.0, true, 1.0);
	g_cv_ReportInterval = CreateConVar("sm_status_update", "60", "Interval between each server status message (in seconds)", _, true, 15.0, true, 300.0);
	
	// Display convars
	g_cv_ShowPadding = CreateConVar("sm_status_padding", "1", "Print header/footer in status messages?", _, true, 0.0, true, 1.0);
	g_cv_ShowTime = CreateConVar("sm_status_time", "1", "Print current server time in status messages?", _, true, 0.0, true, 1.0);
	g_cv_ShowPlayer = CreateConVar("sm_status_players", "1", "Print player count in status messages?", _, true, 0.0, true, 1.0);
	g_cv_ShowMap = CreateConVar("sm_status_map", "1", "Print map name in status messages?", _, true, 0.0, true, 1.0);
	g_cv_ShowEdict = CreateConVar("sm_status_edict", "0", "Print edict count in status messages?", _, true, 0.0, true, 1.0);
	g_cv_ShowUptime = CreateConVar("sm_status_uptime", "1", "Print server uptime in status messages?", _, true, 0.0, true, 1.0);
	
	// Autoexecute plugin config
	AutoExecConfig(true, "ServerStatusReport");
}

// Function: Obtains server uptime using engine time
stock char[] GetServerUptime()
{
	int enginetime = RoundToFloor(GetEngineTime());
	int days = enginetime / 60 / 60 / 24;
	int hours = (enginetime / 60 / 60) % 24;
	int minutes = (enginetime / 60) % 60;
	
	char uptime[64];
	FormatEx(uptime, sizeof(uptime), "%d Days %d Hours %d Minutes", days, hours, minutes);
	return uptime;
}

// Function: Obtains current entity count on the server
stock int GetEdictCount()
{
	int EdictCount = 0;
	for (int entity = 0; entity <= 2048; entity++)
	{
		if (IsValidEdict(entity))
			EdictCount++;
	}
	return EdictCount;
}

// Function: Obtains current server time
stock char[] GetCurrentTime()
{
	char ctime[64];
	FormatTime(ctime, 64, NULL_STRING);
	return ctime;
}

// Function: Obtains current map name
stock char[] GetMapName()
{
	char map[PLATFORM_MAX_PATH];
	GetCurrentMap(map, sizeof(map));
	GetMapDisplayName(map, map, sizeof(map));
	return map;
}

// Create timer when plugin config is executed
public void OnConfigsExecuted()
{
	CreateTimer(GetConVarFloat(g_cv_ReportInterval), StatusReport, _, TIMER_REPEAT);
}

// Timer Event
public Action StatusReport(Handle timer)
{
	// If server status messages are disabled, return plugin_continue
	if (!(g_cv_EnableStatusReport.BoolValue) || !(g_cv_ShowPadding.BoolValue && g_cv_ShowTime.BoolValue && g_cv_ShowPlayer.BoolValue && g_cv_ShowMap.BoolValue && g_cv_ShowEdict.BoolValue && g_cv_ShowUptime.BoolValue))
		return Plugin_Continue;
	else
	{
		// Print server status in chat
		if (g_cv_ShowPadding.BoolValue)
			CPrintToChatAll("%t", "Report Header");
		if (g_cv_ShowTime.BoolValue)
			CPrintToChatAll("%t", "Server Time", GetCurrentTime());
		if (g_cv_ShowUptime.BoolValue)
			CPrintToChatAll("%t", "Server Uptime", GetServerUptime());
		if (g_cv_ShowPlayer.BoolValue)
			CPrintToChatAll("%t", "Player Amount", GetClientCount(true), MaxClients);
		if (g_cv_ShowMap.BoolValue)
			CPrintToChatAll("%t", "Current Map", GetMapName());
		if (g_cv_ShowEdict.BoolValue)
			CPrintToChatAll("%t", "Edict Count", GetEdictCount());
		if (g_cv_ShowPadding.BoolValue)
			CPrintToChatAll("%t", "Report Footer");
			
		return Plugin_Continue;
	}
}

// Print server information command
public Action Command_Status(int client, int args)
{
	CPrintToChat(client, "%t", "Report Header");
	CPrintToChat(client, "%t", "Server Time", GetCurrentTime());
	CPrintToChat(client, "%t", "Server Uptime", GetServerUptime());
	CPrintToChat(client, "%t", "Player Amount", GetClientCount(true), MaxClients);
	CPrintToChat(client, "%t", "Current Map", GetMapName());
	CPrintToChat(client, "%t", "Edict Count", GetEdictCount());
	CPrintToChat(client, "%t", "Report Footer");
	
	return Plugin_Handled;
}