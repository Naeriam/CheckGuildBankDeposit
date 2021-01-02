# Check Guild Bank Deposit (Addon for World of Warcraft) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This addon checks if all raid (or group) members have recently made a deposit of, at least, one unit of a certain object into guild's bank. For example, you could check if all your raid members have made a deposit of one flask to contribute to the guild couldron.
 
The use can be stored in a **macro**, because is really simple:
 
`/checkguildbank <Item name>, <Hour limit>`
 
For example, when executing:
 
> /checkguildbank Spectral Flask of Power, 3 
 
The addon will check if all raid (or group) members have made a deposit of (at least) one Spectral Flask of Power in the last 3 hours.
 
The hour limit argument is **optional**, if not provided, by default the value of 1 hour will be used.
 
## Limitations:
 
- Due to Blizzard limitations, each one of the guild tabs has a hard limit in the number of stored operations in the log. The log is limited to 25 movements. If your average raid is over 25 members, you should then make deposits in different tabs, this way all movements can be readed and processed by the addon.
 
- Also due to Blizzard limitations, the user will need to execute all commands while the Guild bank window is open for the addon to be able to query information from the server.

You can download this addon from: https://www.curseforge.com/wow/addons/check-guild-bank-deposit
