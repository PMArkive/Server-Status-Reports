#pragma newdecls required
#pragma semicolon 1

#include <sourcemod>
#include <csgocolors_fix>

// Core convars
ConVar g_cReportInterval, g_cEnableStatusReport;

// Status Update convars
ConVar g_cShowPadding, g_cShowTime, g_cShowPlayer, g_cShowMap, g_cShowEdict;

public Plugin myinfo =
{
	name = "Server Status Report",
	author = "koen#4977",
	description = "Prints server status (Time, Players, Map, Edicts) to chat in intervals",
	version = "1.0",
	url = "https://steamcommunity.com/id/fungame1224/"
};

public void OnPluginStart()
{
	// Load plugin translations
	LoadTranslations("statusreport.phrases");
	
	// Core functionality convars
	g_cEnableStatusReport = CreateConVar("sm_status_enable", "1", "Toggle status report messages in chat (1 to enable, 0 to disable)", _, true, 0.0, true, 1.0);
	g_cReportInterval = CreateConVar("sm_status_update", "60", "Interval between each server status message (in seconds)", _, true, 15.0, true, 300.0);
	
	// Display convars
	g_cShowPadding = CreateConVar("sm_status_padding", "1", "Print header/footer in status messages?", _, true, 0.0, true, 1.0);
	g_cShowTime = CreateConVar("sm_status_time", "1", "Print current server time in status messages?", _, true, 0.0, true, 1.0);
	g_cShowPlayer = CreateConVar("sm_status_players", "1", "Print player count in status messages?", _, true, 0.0, true, 1.0);
	g_cShowMap = CreateConVar("sm_status_map", "1", "Print map name in status messages?", _, true, 0.0, true, 1.0);
	g_cShowEdict = CreateConVar("sm_status_edict", "0", "Print edict count in status messages?", _, true, 0.0, true, 1.0);
	
	// Autoexecute plugin config
	AutoExecConfig(true, "ServerStatusReport");
}

// IsValidClient function
stock bool IsValidClient(int client)
{
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client))
		return false;
	return true;
}

// Create timer when plugin config is executed
public void OnConfigsExecuted()
{
	CreateTimer(GetConVarFloat(g_cReportInterval), StatusReport, _, TIMER_REPEAT);
}

// Timer Event
public Action StatusReport(Handle timer)
{
	// If server status messages are disabled, return plugin_continue
	if (!(g_cEnableStatusReport.BoolValue) || !(g_cShowPadding.BoolValue && g_cShowTime.BoolValue && g_cShowPlayer.BoolValue && g_cShowMap.BoolValue && g_cShowEdict.BoolValue))
		return Plugin_Continue;
	else
	{
		// Get current server time (taken from basetrigger.sp)
		char ctime[64];
		FormatTime(ctime, 64, NULL_STRING);
		
		// Get current map name
		char map[PLATFORM_MAX_PATH];
		GetCurrentMap(map, sizeof(map));
		GetMapDisplayName(map, map, sizeof(map));
		
		// Print server status in chat
		if (g_cShowPadding.BoolValue)
			CPrintToChatAll("%t", "Report Header");
		if (g_cShowTime.BoolValue)
			CPrintToChatAll("%t", "Server Time", ctime);
		if (g_cShowPlayer.BoolValue)
			CPrintToChatAll("%t", "Player Amount", GetClientCount(true), MaxClients);
		if (g_cShowMap.BoolValue)
			CPrintToChatAll("%t", "Current Map", map);
		if (g_cShowEdict.BoolValue)
			CPrintToChatAll("%t", "Edict Count", GetEntityCount());
		if (g_cShowPadding.BoolValue)
			CPrintToChatAll("%t", "Report Footer");
		
		// Return plugin_continue
		return Plugin_Continue;
	}
}