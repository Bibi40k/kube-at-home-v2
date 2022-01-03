#!/usr/bin/env bash

printf "\n * Install pre-commit and the pre-commit hooks.
 * Sops-pre-commit will check to make sure you are not by accident committing your secrets un-encrypted.\n"

pre-commit install-hooks

# shellcheck disable=SC1091
source "${PROJECT_DIR}./scripts/go_to_next_step.inc"
go_to_next_step "2"