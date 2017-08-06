#!/bin/bash

# Path
HOMEDIR=/home/DEVICES

# Help
function usage() {
    echo "Usage script with options: $0 [OPTIONS]"
    echo "  -h --help          Print HELP"
    echo "  -s --serial        Device serial number [mandatory option]"
    echo "  --get_status       To get status for device:"
    echo "                     ---> return exitcode 0 if device is available"
    echo "                     ---> return exitcode 1 if device is locked"
    echo "                     ---> return exitcode 2 if device is offline"
    echo "  --set_status       To set status for device:"
    echo "                     ---> use 0 if you want to change status to 'available'"
    echo "                     ---> use 1 if you want to change status to 'locked'"
    echo "                     ---> use 2 if you want to change status to 'offline'"
    echo "  For example:"
    echo "    ./devices_status_update.sh -s c43a0b --set_status 1"
    echo "                     To set status 'locked' for device 'c43a0b'"
    echo "  "
    exit 1
}

# Description get_status function
function get_status () {

STATUS=$(cat ${HOMEDIR}/devices_status_table | grep "${DEVICEID}" | awk -F '_' '{print $2}')
    if [[ $(cat ${HOMEDIR}/devices_status_table | grep "${DEVICEID}") != "" ]]; then   
        case ${STATUS} in 
            0)
                echo  "---> Device ${DEVICEID} is available"
                EXITCODE=0
            ;;
            1)
                echo  "---> Device ${DEVICEID} is locked"
                EXITCODE=1
            ;;
            2)
                echo  "---> Device ${DEVICEID} is offline"
                EXITCODE=2
            ;; 
        esac
    else
        STATUS=0
        EXITCODE=0
	    echo  "---> Device is added to devices_status_table with status 'available'"
        echo  "${DEVICEID}_${STATUS}" >> ${HOMEDIR}/devices_status_table
    fi
}

# Description set_status function
function set_status () {

    if [[ ${STATUS} == ${NEW_STATUS} ]]; then
        echo  "---> Device status for ${DEVICEID} is not updated"
    else
        sed -i "/${DEVICEID}_/d" "${HOMEDIR}/devices_status_table"
        case ${NEW_STATUS} in 
            0)
                EXITCODE=0
                echo  "---> Device status for ${DEVICEID} updated from ${STATUS} to ${NEW_STATUS} (available)"
                echo  "${DEVICEID}_${NEW_STATUS}" >> ${HOMEDIR}/devices_status_table
            ;;
            1)
                EXITCODE=1
                echo  "---> Device status for ${DEVICEID} updated from ${STATUS} to ${NEW_STATUS} (locked)"
                echo  "${DEVICEID}_${NEW_STATUS}" >> ${HOMEDIR}/devices_status_table
            ;;
            2)
                EXITCODE=2
                echo  "---> Device status for ${DEVICEID} updated from ${STATUS} to ${NEW_STATUS} (offline)"
                echo  "${DEVICEID}_${NEW_STATUS}" >> ${HOMEDIR}/devices_status_table
            ;; 
		    *)
 	            echo "ERROR! Invalid STATUS id:" 
                echo "                  ---> use 0 if you want to change status to 'available'"
                echo "                  ---> use 1 if you want to change status to 'locked'"
                echo "                  ---> use 2 if you want to change status to 'offline'"
		        exit 1
		    ;;
        esac
    fi
}

# Get options for start
while true; do
    case "$1" in
        -h|--help) usage;;
        -s|--serial) DEVICEID="$2"; shift 2;
	        if [ -z ${DEVICEID} ]; then 
                echo "ERROR! Please enter device id"
                exit 1
	        fi
        ;;
        --get_status) STEP=1; NEW_STATUS=" "; shift;;
        --set_status) STEP=2; NEW_STATUS="$2"; shift 2; 
	        if [ -z ${NEW_STATUS} ]; then 
	            echo "ERROR! Please enter STATUS id" 
		        exit 1
	        fi
	    ;;
        *) echo "Erorr! You have entered a wrong key"; exit 1
        ;;
    esac
    if ! [[ -z ${DEVICEID} ]] && ! [[ -z ${NEW_STATUS} ]]; then
        break
    fi
done

# Check for file 'devices_status_table'
if ! [[ -f ${HOMEDIR}/devices_status_table ]]; then
    touch ${HOMEDIR}/devices_status_table 
    chmod 777 ${HOMEDIR}/devices_status_table 
fi

# Execution of functions
[ "${STEP}" == "1" ] && get_status
[ "${STEP}" == "2" ] && get_status && set_status

echo "EXITCODE=${EXITCODE}" 