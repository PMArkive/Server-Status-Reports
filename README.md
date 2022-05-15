# Server Status Reporting
Prints server status and information in chat.

*Compiled in SM 1.11.6881*

# Image:
![Sample status report](https://i.ibb.co/pxY4LmL/image.png)

# Commands
`sm_statusreport` - Prints server status in chat

# Plugin CVars
**Plugin Functionality ConVars**
`sm_status_enable` - Enable status report messages in chat? (0 - Disable | 1 - Enable)
`sm_status_update` - Interval between each status report in chat

**Status Report ConVars**
`sm_status_edict` - Print server edict count in status reports?
`sm_status_map` - Print current map name in status reports?
`sm_status_padding` - Enable header/footer in status reports?
`sm_status_players` - Print player count in status reports?
`sm_status_time` - Print current server time in status reports?
`sm_status_uptime` - Print server uptime in status reports?

# List of Information Reported
- Server time
- Player Count
- Current map name
- Edict Count
- Server Uptime

# Credits and Thanks:
- Possession.JP (PŠΣ™) for the original plugin idea
- [PŠΣ™ Shufen](https://steamcommunity.com/id/shufen/) for sending me the original plugin sourcecode used on PŠΣ™ originally, which some functions were taken from.
- [Vauff](https://steamcommunity.com/id/Vauff), [Snowy](https://steamcommunity.com/id/SnowyWasHere), and [Luffaren](https://steamcommunity.com/id/LuffarenPer) for explaining edicts and giving me information on obtaining the right amount instead of `GetEntityCount()`.
- [tilgep](https://steamcommunity.com/id/tilgep/) general help with writing plugins

# Change Log
## 1.0
- Initial commit
## 1.1
- Added additional convars for setting what information is reported
- Set edict count to be not reported by default
## 1.2
- Fix incorrect edict information being reported by replacing `GetEntityCount()` with another function that utilizes `IsValidEdict()`
## 1.3
- Added server uptime report (Thanks shufen!)
- Added `!statusreport` command to print server information on demand
- Code refactoring: Moved some functions outside of the timer callback so that the function is only used if the specified report it enabled
