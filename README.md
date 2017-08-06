# script-devices-status-update

Created script for displaying and changing of status of connected adb devices to PC using Bash

Task:
Write a script that can:
- show status of connected mobile devices by serial number id
- update status of connected mobile devices by serial number id
- show help 
- device can have one from three mode: available, locked or offline

General stack of technologies: 
- Bash

Preconditions:
-	OS Linux

Instructions:

`usage: devices_status_update.sh [-h] [-s DEVICEID] [--get_status] [--set_status]`

`optional arguments:`

`  -h, --help                                                   show this help message and exit`

`  -s DEVICEID, --serial DEVICEID                               Device serial number [mandatory option]`

`  --get_status                                   To get status for device:`
`                                                 ---> return exitcode 0 if device is available`
`                                                 ---> return exitcode 1 if device is locked`
`                                                 ---> return exitcode 2 if device is offline`

`  --set_status                                   To set status for device:`
`                                                 ---> use 0 if you want to change status to 'available'`
`                                                 ---> use 1 if you want to change status to 'locked'`
`                                                 ---> use 2 if you want to change status to 'offline'`

`For example:`
`                              ./devices_status_update.sh -s c43a0b --set_status 1`
`                              To set status 'locked' for device 'c43a0b'`
