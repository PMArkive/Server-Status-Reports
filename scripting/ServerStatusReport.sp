#pragma newdecls required
#pragma semicolon 1

#include <sourcemod>
#include <csgocolors_fix>

// Core convars
ConVar g_cvInterval, g_cvEnable;

// Timer variables
Handle g_hTimer;
bool g_bTimer;

public Plugin myinfo =
{
	name = "Server Status Reports",
	author = "koen",
	description = "Prints server status information to chat in intervals",
	version = "1.4",
	url = "https://github.com/notkoen"
};

public void OnPluginStart()
{
	// Load plugin translations
	LoadTranslations("statusreport.phrases");
	
	// Print status command
	RegConsoleCmd("sm_status", Command_Status, "Print server status in chat");
	RegConsoleCmd("sm_statusreport", Command_Status, "Print server status in chat");
	
	// Core functionality convars
	g_cvEnable = CreateConVar("sm_status_enable", "1", "Toggle status report messages in chat (1=enable, 0=disable)", _, true, 0.0, true, 1.0);
	g_bTimer = g_cvEnable.BoolValue;
	HookConVarChange(g_cvEnable, OnTimerToggle);
	
	g_cvInterval = CreateConVar("sm_status_update", "60", "Interval between each server status message (in seconds)", _, true, 15.0, true, 300.0);
	HookConVarChange(g_cvInterval, OnTimerToggle);
	
	// Autoexecute plugin config
	AutoExecConfig(true);
}

public void OnTimerToggle(ConVar cvar, const char[] oldValue, const char[] newValue)
{
	// Store new cvar value for if plugin is enabled
	g_bTimer = g_cvEnable.BoolValue;
	
	// Delete timer and check if it is enabled. Changing intervals will also apply here
	delete g_hTimer;
	if (g_bTimer)
		g_hTimer = CreateTimer(g_cvInterval.FloatValue, StatusReport, _, TIMER_REPEAT);
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
		if (IsValidEdict(entity)) EdictCount++;
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
	return map;
}

// Create timer when plugin config is executed
public void OnConfigsExecuted()
{
	g_hTimer = CreateTimer(g_cvInterval.FloatValue, StatusReport, _, TIMER_REPEAT);
}

// Timer Event
public Action StatusReport(Handle timer)
{
	CPrintToChatAll("%t", "Report Header");
	CPrintToChatAll("%t", "Server Time", GetCurrentTime());
	CPrintToChatAll("%t", "Server Uptime", GetServerUptime());
	CPrintToChatAll("%t", "Player Amount", GetClientCount(true), MaxClients);
	CPrintToChatAll("%t", "Current Map", GetMapName());
	CPrintToChatAll("%t", "Edict Count", GetEdictCount());
	return Plugin_Continue;
}

// Print server information command
public Action Command_Status(int client, int args)
{
	if (client == 0) return Plugin_Handled;
	CPrintToChat(client, "%t", "Report Header");
	CPrintToChat(client, "%t", "Server Time", GetCurrentTime());
	CPrintToChat(client, "%t", "Server Uptime", GetServerUptime());
	CPrintToChat(client, "%t", "Player Amount", GetClientCount(true), MaxClients);
	CPrintToChat(client, "%t", "Current Map", GetMapName());
	CPrintToChat(client, "%t", "Edict Count", GetEdictCount());
	return Plugin_Handled;
}
