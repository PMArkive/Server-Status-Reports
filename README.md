# Server Status Reporting
Prints server status and information in chat.

*Compiled in SM 1.11.6881*

# Credits and Thanks:
- Possession.JP (PŠΣ™) for the original plugin idea
- [Vauff](https://steamcommunity.com/id/Vauff), [Snowy](https://steamcommunity.com/id/SnowyWasHere), and [Luffaren](https://steamcommunity.com/id/LuffarenPer) for explaining and giving me information on how to count edicts properly instead of `GetEntityCount()`

# Image:
![Sample status report](https://i.ibb.co/xYkKD9r/image.png)

# List of Information Reported (currently)
- Server time
- Player Count
- Current map name
- Edict Count

# Change Log
## 1.0
- Initial commit
## 1.1
- Added additional convars for setting what information is reported
- Set edict count to be not reported by default
## 1.2
- Fix incorrect edict information being reported by replacing `GetEntityCount()` with another function that utilizes `IsValidEdict()`
