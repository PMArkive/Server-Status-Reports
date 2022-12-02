# Server Status Reports

Prints server status and information in chat.

## Commands

`sm_statusreport` / `sm_status` - Prints server status in chat

## Plugin convars

Cvar | Description
--- | ---
`sm_status_enable` | Enable status report messages in chat? (0 - Disable | 1 - Enable)
`sm_status_update` | Interval between each status report in chat

## List of Information Reported

- Server time
- Player Count
- Current map name
- Edict Count
- Server Uptime

## Credits and Thanks

- [PŠΣ™ Shufen](https://steamcommunity.com/id/shufen/) for sending me the original plugin sourcecode used on PŠΣ™ originally, which some functions were taken from.
- [Vauff](https://steamcommunity.com/id/Vauff), [Snowy](https://steamcommunity.com/id/SnowyWasHere), and [Luffaren](https://steamcommunity.com/id/LuffarenPer) for explaining edicts and giving me information on obtaining the right amount instead of `GetEntityCount()`.
- [tilgep](https://steamcommunity.com/id/tilgep/) general help with writing plugins
