#!/bin/bash
#
# Displays the battery status.

set -o errexit
set -o nounset
set -o pipefail

main() {
    printBattery
}

printBattery() {
    local output=" "
    local capacity
    capacity="$(getCapacity)"
    if isError "${capacity}"; then
        output+="$(getErrorColor)"
    elif isWarning "${capacity}"; then
        output+="$(getWarningColor)"
    fi
    case "$(getStatus)" in
        "Discharging")
            output+="🔋"
            ;;
        "Charging")
            output+="🔌"
            ;;
        "Full")
            output+="✅"
            ;;
        *)
            output+="❓"
            ;;
    esac
    output+="${capacity}%"
    output+="$(getNormalColor)"
    echo -e "${output}"
}

getCapacity() {
    echo "$(< /sys/class/power_supply/BAT0/capacity)"
}

isWarning() {
    local capacity="${1}"
    local warningValue=15
    [[ "${capacity}" -le "${warningValue}" ]]
}

isError() {
    local capacity="${1}"
    local errorValue=5
    [[ "${capacity}" -le "${errorValue}" ]]
}

getWarningColor() {
    echo "\x03"
}

getErrorColor() {
    echo "\x04"
}

getStatus() {
    echo "$(< /sys/class/power_supply/BAT0/status)"
}

getNormalColor() {
    echo "\x01"
}

main
