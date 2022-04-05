#!/usr/bin/env bash

# command -v pre-commit

printf "\n * Install pre-commit and the pre-commit hooks.
 * Sops-pre-commit will check to make sure you are not by accident committing your secrets un-encrypted.\n"

APP_NAME="pre-commit"
APP_LOCATION="/usr/local/bin/${APP_NAME}"
if [ ! -f "$APP_LOCATION" ]; then
    read -p "${APP_NAME} does not exist [$APP_LOCATION], do you want me to install it ? [Y/n] " response
    if [[ ! $response =~ ^([nN][oO]|[nN])$ ]]; then
        pip install pre-commit
        pre-commit --version
    else
        echo "You chose not to install ${APP_NAME}. We exit."
        exit 1
    fi
fi

pre-commit install-hooks

# shellcheck disable=SC1091
source "${PROJECT_DIR}./scripts/go_to_next_step.inc"
go_to_next_step "2"