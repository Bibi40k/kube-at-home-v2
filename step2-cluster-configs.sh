#!/usr/bin/env bash

printf "\n * Creating a Age Private / Public Key\n"
age-keygen -o age.agekey

printf " * Setting up the directory for the Age key and move the Age file to it\n"
mkdir -p ~/.config/sops/age
mv age.agekey ~/.config/sops/age/keys.txt

AGE_PUBLIC_KEY=$(cat ~/.config/sops/age/keys.txt | grep 'public key' | awk '{print $4}')

printf " * Exporting the SOPS_AGE_KEY_FILE variable in your bashrc, zshrc or config.fish and source it\n"
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
source ~/.bashrc

printf " * Filling out the Age public key in the .config.env under BOOTSTRAP_AGE_PUBLIC_KEY\n"
if [[ ! -f .config.env ]]; then
    cp .config.sample.env .config.env
fi
sed -i "s/BOOTSTRAP_AGE_PUBLIC_KEY.*/BOOTSTRAP_AGE_PUBLIC_KEY=\"${AGE_PUBLIC_KEY}\"/g" ".config.env"

if ./configure.sh --verify | grep 'ERROR'; then
    printf "\n !!! There are required variables missing in .config.env !!!\n\n"
    exit 0
fi

./configure.sh
printf "\n * All configurations files were generated.\n"

# shellcheck disable=SC1091
source "${PROJECT_DIR}./scripts/go_to_next_step.inc"
go_to_next_step "3"