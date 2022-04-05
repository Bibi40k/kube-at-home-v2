#!/usr/bin/env bash

APP_NAME="age-keygen"
APP_LOCATION="/usr/local/bin/${APP_NAME}"
if [ ! -f "$APP_LOCATION" ]; then
    read -p "${APP_NAME} does not exist [$APP_LOCATION], do you want me to install it ? [Y/n] " response
    if [[ ! $response =~ ^([nN][oO]|[nN])$ ]]; then
        brew install age
        age-keygen --version
    else
        echo "You chose not to install ${APP_NAME}. We exit."
        exit 1
    fi
fi

printf "\n * Creating a Age Private / Public Key\n"
age-keygen -o age.agekey

printf " * Setting up the directory for the Age key and move the Age file to it\n"
mkdir -p ~/.config/sops/age
mv age.agekey ~/.config/sops/age/keys.txt

AGE_PUBLIC_KEY=$(cat ~/.config/sops/age/keys.txt | grep 'public key' | awk '{print $4}')

printf " * Exporting the SOPS_AGE_KEY_FILE variable in your bashrc, zshrc or config.fish and source it\n"
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt

# source ~/.bashrc # linux
source ~/.bash_profile # MacOs

printf " * Filling out the Age public key in the .config.env under BOOTSTRAP_AGE_PUBLIC_KEY\n"
if [[ ! -f .config.env ]]; then
    cp .config.sample.env .config.env
fi
# sed -i "s/BOOTSTRAP_AGE_PUBLIC_KEY.*/BOOTSTRAP_AGE_PUBLIC_KEY=\"${AGE_PUBLIC_KEY}\"/g" ".config.env" # linux
sed -i '' "s/BOOTSTRAP_AGE_PUBLIC_KEY.*/BOOTSTRAP_AGE_PUBLIC_KEY=\"${AGE_PUBLIC_KEY}\"/g" ".config.env" # MacOs

APP_NAME="ipcalc"
APP_LOCATION="/usr/local/bin/${APP_NAME}"
if [ ! -f "$APP_LOCATION" ]; then
    read -p "${APP_NAME} does not exist [$APP_LOCATION], do you want me to install it ? [Y/n] " response
    if [[ ! $response =~ ^([nN][oO]|[nN])$ ]]; then
        brew install ipcalc
        ipcalc --version
    else
        echo "You chose not to install ${APP_NAME}. We exit."
        exit 1
    fi
fi

APP_NAME="jq"
APP_LOCATION="/usr/local/bin/${APP_NAME}"
if [ ! -f "$APP_LOCATION" ]; then
    read -p "${APP_NAME} does not exist [$APP_LOCATION], do you want me to install it ? [Y/n] " response
    if [[ ! $response =~ ^([nN][oO]|[nN])$ ]]; then
        brew install jq
        jq --version
    else
        echo "You chose not to install ${APP_NAME}. We exit."
        exit 1
    fi
fi

APP_NAME="task"
APP_LOCATION="/usr/local/bin/${APP_NAME}"
if [ ! -f "$APP_LOCATION" ]; then
    read -p "${APP_NAME} does not exist [$APP_LOCATION], do you want me to install it ? [Y/n] " response
    if [[ ! $response =~ ^([nN][oO]|[nN])$ ]]; then
        brew install go-task/tap/go-task
        task --version
    else
        echo "You chose not to install ${APP_NAME}. We exit."
        exit 1
    fi
fi

APP_NAME="terraform"
APP_LOCATION="/usr/local/bin/${APP_NAME}"
if [ ! -f "$APP_LOCATION" ]; then
    read -p "${APP_NAME} does not exist [$APP_LOCATION], do you want me to install it ? [Y/n] " response
    if [[ ! $response =~ ^([nN][oO]|[nN])$ ]]; then
        brew install terraform
        terraform --version
    else
        echo "You chose not to install ${APP_NAME}. We exit."
        exit 1
    fi
fi

if ./custom_configure.sh --verify | grep 'ERROR'; then
    printf "\n !!! There are required variables missing in .config.env !!!\n\n"
    exit 0
fi

./custom_configure.sh
printf "\n * All configurations files were generated.\n"

# shellcheck disable=SC1091
source "${PROJECT_DIR}./scripts/go_to_next_step.inc"
go_to_next_step "3"