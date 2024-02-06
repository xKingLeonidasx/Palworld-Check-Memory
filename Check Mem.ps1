<#----------------------------------------------ADD YOUR SERVER DETAILS IN THIS SECTION-----------------------------------------------#>
<# Server Hardware Info #>

$PorVRAM = 'V'     # P - To track physical memory capacity or ;
                   # V - To track Virtual memory capacity

<#------------------------------------------------------------------------------------------------------------------------------------#>
<# Server Info #>


$ServerIP = '127.0.0.1'     # Enter your server IP here.


<#------------------------------------------------------------------------------------------------------------------------------------#>
<# Restart Options #>


$RestartOption = 0     # 0 - Only restart the game server not the VM/machine. 
                       # 1 - Restart the machine/VM (Full Restart) (ONLY IF YOU HAVE SCRIPT TO START AT STARTUP)

$batch = 0     # 0 - You do not use a batch script to start Palworld server
               # 1 - You use a batch script to start Palworld server

$palstart = 'C:\Users\Leo\Desktop\test pal\steamcmd\steamapps\common\PalServer'     # Path of your startup batch file to start Palworld server


<#------------------------------------------------------------------------------------------------------------------------------------#>
<# Path of steamcmd and option to update server on restart #>

<# ONLY IF RESTARTING GAME SERVER NOT MACHINE OR VM ABOVE #>


$UpdateOpt = 0     # 0 - Server update check disabled. 1 to have steamapps check for server update on restart
                   # 1 - Check for server update at restart.

$steamapps = 'C:\Users\Leo\Desktop\test pal\steamcmd'     # Path of steamapps.exe


<#------------------------------------------------------------------------------------------------------------------------------------#>
<# Backup Options #>


$backup = 1     # 0 - No backup if restart due to memory overload.
                # 1 - Enable backup if restart due to memory overload.

$palsaves = 'C:\Pal\steamcmd\steamapps\common\PalServer\Pal\Saved\SaveGames\0\77A4s8yD531FD08BFD8ABC892NN4D14U'     # Path of save files (world / players)

$backuppath = 'C:\palbackup'     # Path to store backups


<#------------------------------------------------------------------------------------------------------------------------------------#>
<# RCON Info #>  


$ServerPort = 12345     # Your server RCON Port

$RCONPW = 'YOURPASSWORD'     # Your server RCON PW

$RCONpath = 'C:\pal\ARRCON-3.3.7-Windows\arrcon.exe'     # ARRCON path


<#------------------------------------------------------------------------------------------------------------------------------------#>
<# Current Player File Paths & Log Enable/Disable #>


$CurPlayerLog = 1     # 0 - Current player log disabled.
                      # 1 - Enable Current Player log.

$CurPlayerLogPath = 'C:\pal\steamcmd\steamapps\common\PalServer\Pal\Saved\Logs\activeplayerslog.log'     # Path activeplayerslog.log is located


<#------------------------------------------------------------------------------------------------------------------------------------#>
<# RAM USE File Paths & Log Enable/Disable #>


$CurRAMLog = 1     # 0 - Memory use log disabled.
                   # 1 - memory use log enabled.

$CurRAMLogPath = 'C:\pal\steamcmd\steamapps\common\PalServer\Pal\Saved\Logs\RAMUselog.log'     # Path RAMUselog.log is located


<#------------------------------------------------------------------------------------------------------------------------------------#>
<#------------------------------------------------------------------------------------------------------------------------------------#>
<#-----------------------------------------------------NO NEED TO EDIT BELOW HERE-----------------------------------------------------#>
<#------------------------------------------------------------------------------------------------------------------------------------#>
<#------------------------------------------------------------------------------------------------------------------------------------#>


if ($PorVRAM -eq 'V') {
$totRAM = (Get-WmiObject win32_operatingsystem | Select @{L='VRAMtot';E={($_.totalvirtualmemorysize)*1KB/1GB}}).VRAMtot
} elseif ($PorVRAM -eq 'P'){
$totRAM = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb
}

$VRAM = (Get-WmiObject win32_operatingsystem | Select @{L='commit';E={($_.totalvirtualmemorysize - $_.freevirtualmemory)*1KB/1GB}}).commit;
$TimeStamp = (Get-Date).toString("MM/dd/yyyy HH:mm:ss:fff tt")

$Logramgreen = "$TimeStamp - $VRAM"
$Logramcrit = "$TimeStamp - $VRAM - Server memory Critical"
$Logramred = "$TimeStamp - $VRAM - Server Rebooted Due to Memory Commit Limits"

$RedRAM = ($totRAM * .90)
$CritRAM = ($totRAM * .75)

$CMD = $RCONpath + " -H " + $ServerIP + " -P " + $ServerPort + " -p " + $RCONPW
$CMDshow = $RCONpath + " -H " + $ServerIP + " -P " + $ServerPort + " -p " + $RCONPW + " showplayers "

$players = Invoke-Expression $CMDshow | Select -Skip 2 | Select -Skiplast 1
$Logplayers = " ","-------------------------------------------------------------------------------",$TimeStamp," ","MEMORY COMMITED - $VRAM"," ",$players
Add-Content -Path $CurPlayerLogPath -Value $Logplayers

if ($VRAM -gt $RedRAM){
$5min = $CMD + ' "Broadcast THE_SERVER_IS_REBOOTING_IN_5_MINUTES_DUE_TO" "Broadcast MEMORY_COMMIT_PROTECTION" "Broadcast OVER_90%_COMMITED"'
Invoke-Expression $5min
Start-Sleep -s 60
if ($backup -eq 1) {
$Date = Get-Date -Format "yyyy-MM-dd_HHmm tt"
Copy-Item $palsaves $backuppath\$Date -Recurse -Force
Start-Sleep -s 20
} else {
Start-Sleep -s 20
}
$1min = $CMD + ' "Broadcast THE_SERVER_IS_REBOOTING_IN_1_MINUTE_DUE_TO" "Broadcast MEMORY_COMMIT_PROTECTION" "Broadcast OVER_90%_COMMITED"'
Invoke-Expression $1min
Start-Sleep -s 60
Add-Content -Path $CurRAMLogPath -Value $Logramred
Start-Sleep -s 2
Add-Content -Path $CurPlayerLog -Value "-------------------------------------------------------------------------------"," ","Server Rebooted Due to Memory Commit Limits"
Start-Sleep -s 5

if ($RestartOption -gt 0) {
$restartserver = $CMD + ' "SAVE" "SHUTDOWN 15"'
Invoke-Expression $restartserver
SLEEP 30
shutdown -r
} else {
$CMD + ' "SAVE" "SHUTDOWN 15"'
SLEEP 30
cd $steamapps
.\steamcmd.exe +login anonymous +app_update 2394010 validate +quit
cd $palstart
.\startup.bat
}

} elseif ($VRAM -lt $CritRAM){
Start-Sleep -s 1
Add-Content -Path $CurRAMLogPath -Value $Logramgreen
Start-Sleep -s 5
Exit

} else {
$Critmsg = $CMD + ' "Broadcast THE_SERVER_MEMORY_STATUS_IS" "Broadcast CRITICAL_STATUS_75%_COMMITED" "Broadcast DO_NOT_PLAN_ANYTHING_THAT_TAKES_TIME" "Broadcast RESTART_IMMINENT"'
Start-Sleep -s 1
Invoke-Expression $Critmsg
Start-Sleep -s 1
Add-Content -Path $CurRAMLogPath -Value $Logramcrit
Start-Sleep -s 5
Exit
}