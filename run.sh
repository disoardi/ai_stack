#!/usr/bin/env bash
#
# SCRIPT: Controller script
# AUTHOR: Davide Isoardi
#
# TODO: 
#       UPDATE
# 28/04/2024    First writing

export SCRIPT_PATH="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";

# Load libraries
source ./bashLibraries/*.sh

source "${SCRIPT_PATH}/bashLibraries/logging.sh"
source "${SCRIPT_PATH}/bashLibraries/bash_libraries.sh"
source "${SCRIPT_PATH}/bashLibraries/dockerLibs.sh"

#############################################
#                                           #
#               Variables                   #
#                                           #
#############################################

# 6 is debug mode
export verbosity=6

listOfExecution="deploy,list"

#

#############################################
#                                           #
#               Functions                   #
#                                           #
#############################################

function fnUsage(){
    echo "Usage: $0 -e <execution> -f <docker-compose.yml> -p <file.properties>"
    echo "Example: $0 -e list -f ./docker-compose.yml -p .env"
    echo
    echo "-e has the following options:"
    echo -e "\tdeploy \t\t\tRun all service in docker-compose file"
    echo -e "\tlist   \t\t\tShow all services and all mapped properties"
}

# Eseguita quando exit in modo da lasciare la shell pulita
function fnCleanUp(){
    edebug "unset variabili!"
    #unset impalaHost
}

#############################################
#                                           #
#                  Main                     #
#                                           #
#############################################

# Parameters check
###########################################
if [ $# -lt 3 ]; then
    ecrit "Error: incorrect number of parameters"
    fnUsage
    exit 1
fi

while getopts "e:f:p:" opt; do
    case $opt in
        e)
            execution=$OPTARG
            ;;
        f)
            DFPath=$OPTARG
            ;;
        p)
            PropertiesFile=$OPTARG
            ;;
        \?)
            ecrit "Invalid option: -$OPTARG"
            fnUsage
            exit 1
            ;;
    esac
done

if [ -z "$execution" ]; then
    edebug "execution: ${execution}"
    ecrit "-e empty. I need to kno what do you want to do."
    fnUsage
    exit 1
elif ! fnExistsInList "${listOfExecution}" "," "${execution}"; then
    ecrit "Wrong argument for -e."
    ecrit "You entered --> ${execution,,}"
    fnUsage
    exit 1
fi

if [ -z "$DFPath" ]; then
    edebug "Docker Compose file: ${DFPath}"
    ecrit "Docker Compose file argument is empty."
    fnUsage
    exit 1
elif [ ! -f "$DFPath" ]; then
    edebug "Docker Compose files: ${DFPath}"
    ecrit "Docker Compose file not found."
    fnUsage
    exit 1
fi

if [ -z "$PropertiesFile" ]; then
    edebug "Env file: ${PropertiesFile}"
    ecrit "Properties File argument is empty."
    fnUsage
    exit 1
elif [ ! -f "$PropertiesFile" ]; then
    edebug "Env file: ${PropertiesFile}"
    ecrit "Env file not found."
    fnUsage
    exit 1
fi

if [[ "${execution,,}" == "deploy" ]]; then
    einfo "Run docker compose!"
    einfo "You found the logs here: ${RUN_LOG}"
    
    exit 0
fi

if [[ "${execution,,}" == "list" ]]; then
    einfo "List all docker-compose.yml services:"
    einfo "You found the logs here: ${RUN_LOG}"
    
    exit 0
fi
