#!/bin/bash
###############################################################################
# This script is used to apply preconfigured themes to a shell using starship.
# Themes must be configured ahead of time and can be stored in a file with the
# name of it's theme. Themes are configured as key value pairs in the format
# `key = value`
# No quotes should be used. The following configuration keys are accepted.
# Background Colours
#   background1: the background colour of the command duration
#   background2: the background colour of the path
#   background3: the background colour of the git module
#   background4: the background colour of the clock
#   background5: the background colour of the battery indicator
#
# Foreground Colours
#   foreground1: the colour used by text and symbols
#

# Basic logger
function log {
    local msg=$1
    printf "${msg}\n"
}

# Print usage information, available flags, etc
function usage {
    log "This script is used to apply preconfigured themes to a shell using starship\n"
    log "Usage:"
    log "   change-theme [theme-name] [-i | --install] [-h | --help] [-l | --list]\n"
    log " Run with the -l/--list flag to list available themes"
    log " When running with the -i/--install flag, the script and it's themes will be installed to ${HOME}/.local/bin and ${HOME}/.config/shell-theme-templates"
    log " Themes are configured in the repository's shell-theme-templates directory"
}

# Uninstalls the theme changer and it's themes
function uninstall {
    if [ -f "${SCRIPT_INSTALLATION_PATH}" ]; then
        log "Removing old script version"
        rm -f "${SCRIPT_INSTALLATION_PATH}"
    fi

    if [ -d "$THEME_HOME" ]; then
        log "Removing old theme templates"
        rm -r "${THEME_HOME}"
    fi
}

# Installs or reinstals the theme changer and it's themes
function install {
    local execution_directory=$(dirname "${SCRIPT_EXECUTION_PATH}")
    if [ $(realpath "${SCRIPT_EXECUTION_PATH}") = $(realpath "${SCRIPT_INSTALLATION_PATH}") ]; then
        log "Script already installed"
        exit 0
    fi

    uninstall

    log "Installing shell theme changer"
    log "Installing script"
    cp  "${SCRIPT_EXECUTION_PATH}" "${SCRIPT_INSTALLATION_PATH}"

    log "Installing theme templates"
    cp -r "${execution_directory}/shell-theme-templates" "${THEME_HOME}"
    log "Installation complete!"

    exit 0
}

function list-themes {
    log "Available themes:"
    ls "${THEME_HOME}" -I starship.toml.template
    exit 0
}

SCRIPT_EXECUTION_PATH=$(realpath ${BASH_SOURCE})
SCRIPT_EXECUTION_DIRECTORY=$(dirname "${SCRIPT_EXECUTION_PATH}")
SCRIPT_INSTALLATION_PATH="${HOME}/.local/bin/change-theme"
THEME_HOME="${HOME}/.config/shell-theme-templates"
STARSHIP_TEMPLATE="starship.toml.template"

theme_name="";
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -a|--apply) theme_name="$2"; shift ;;
        -l|--list) list-themes ;;
        -i|--install) install ;;
        -u|--uninstall) uninstall ;;
        -h|--help) usage ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [ ! -f ${THEME_HOME}/${theme_name} ] || [ ${theme_name} = ${STARSHIP_TEMPLATE} ]; then
    log "Theme $theme_name does not exist!"
    exit 0
fi

# Read template
template=$(cat "${THEME_HOME}/${STARSHIP_TEMPLATE}")

# set default colours to prevent errors
background1="#111111"
background2="#333333"
background3="#555555"
background4="#777777"
background5="#999999"
foreground1="#ffffff"
divider=
rightterminator=
leftterminator=

while read -r line
do
    key=$(echo $line | cut -d '=' -f 1)
    value=$(echo $line | cut -d '=' -f 2)
    log "Setting ${key} to ${value}"
    template=$(sed "s/${key}/${value}/g" <<< $template)
done < "${THEME_HOME}/${theme_name}"

template=$(sed "s/background1/${background1}/g" <<< $template)
template=$(sed "s/background2/${background2}/g" <<< $template)
template=$(sed "s/background3/${background3}/g" <<< $template)
template=$(sed "s/background4/${background4}/g" <<< $template)
template=$(sed "s/background5/${background5}/g" <<< $template)
template=$(sed "s/foreground1/${foreground1}/g" <<< $template)
template=$(sed "s/divider/${divider}/g" <<< $template)
template=$(sed "s/rightterminator/${rightterminator}/g" <<< $template)
template=$(sed "s/leftterminator/${leftterminator}/g" <<< $template)

echo "${template}" > "${HOME}/.config/starship.toml"
