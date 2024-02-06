# Palworld-Check-Memory
This PS script checks memory usage as well as collects logs, sends server messages, restarts and updates server based on selections

Make Selections starting from the top of script modifying the variables until you hit: NO NEED TO EDIT BELOW HERE

* This script requires AARCON: https://github.com/radj307/ARRCON

* Linux user can try: https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.4

1. $PorVRAM 
   a. Here you select P or V. This will indicate if you want the script to use Virtual or Physical Memory. V - Virtual ; P - Phisical
   b. If you run your server / start batch silent select virtual.
   c. Virtual Memory is the default and is the suggested.

2. $ServerIP
   a. This is your dedicated server IP.
   b. This script is meant to be used on the machine running the server so 127.0.0.1 will work and is preffered but public RCON will also work.

3. $RestartOption
   a. When memory hits 90% capacity the server will restart.
   b. This option is to select whether you want the machine/VM to reboot or just restart the game server. 0 - Game Server ; 1 - VM / Machine

4. $batch
   a. Select whether you use a batch file to start your server or palserver.exe

6. $palstart
   a. Enter the path of the batch file you start your server with or palserver.exe

7. $UpdateOpt     (ONLY WORKS IF REBOTTING GAMESERVER W/ $RestartOption)
   a. Select if you check for update to server via steamapps. 0 - Disable ; 1 - Enable
   b. Only if rebooting game server. If you want this option on a full reboot look at server start script in GitHub. (Coming Soon)

9. $steamapps     (ONLY WORKS IF REBOTTING GAMESERVER W/ $RestartOption)
   a. The path steamapps.exe is located
   b. Only if rebooting game server. If you want this option on a full reboot look at server start script in GitHub. (Coming Soon)

10. $backup
    a. Enable backups if a restart is needed due to breaking 90% Memory usage. 0 - Disabled ; 1 - Enabled
    b. Backup happens 1 min after 5 min warning message to server

11. $palsaves
    a. This is you server saves location.
    b. By default from the palserver.exe directory it is at PalServer\Pal\Saved\SaveGames\0\YOUR SERVER ID FOLDER NAME

12. $backuppath
    a. This will be the path the backups save to
    b. A folder will be created with date/time stamp save was created

13. $ServerPort
    a. Your server RCON port

14. $RCONPW
    a. Your server RCON password

15. $RCONpath
    a. This script requires ARRCON
    b. This is the path of your ARRCON
    c. If you need ARRCON: https://github.com/radj307/ARRCON

16. $CurPlayerLog
    a. Option to create a log of current players. 0 - Disabled ; 1 - Enabled
    b. Log will include the players, GUID and STEAMID plus current memory usage and time/date

17. $CurPlayerLogPath
    a. Location you want the log to save
    b. Suggeted location is PalServer\Pal\Saved\Logs
    c. Default name of log is activeplayers.log but you can change to what you would like in the path you put
    b. Make sure to create the log by creating a txt file in the path and name it to match and give it extension .log or ,txt but make sure to put that as you create it in the path for the variable.

18. $CurRAMLog
    a. Option to create a log of current memory usage. 0 - Disabled ; 1 - Enabled
    b. Log will include the current memory usage plus if critical or restarting and time/date
    
19. $CurRAMLogPath
    a. Location you want the log to save
    b. Suggeted location is PalServer\Pal\Saved\Logs
    c. Default name of log is RAMUse.log but you can change to what you would like in the path you put
    b. Make sure to create the log by creating a txt file in the path and name it to match and give it extension .log or ,txt but make sure to put that as you create it in the path for the variable.


*************************************************************************************************************************************************************
LINUX USERS CAN TRY FOR PS ON LINUX: https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.4

*************************************************************************************************************************************************************
Donations not expected but appreciated. I made all the scripts you see here for my server and modified so everyone can also use. Some are quick and others take time. I hope they help and are useful to you.

If you would like to donate the link is below:

https://www.paypal.com/donate/?business=5UD9FW3X2DVNL&no_recurring=1&item_name=Donation+not+expected+but+appreciated.+These+scripts+to+take+time+to+put+together+and+I+hope+they+do+help+you.+xKingLeonidasx&currency_code=USD
