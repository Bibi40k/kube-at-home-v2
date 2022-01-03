#!/usr/bin/env bash

printf "\n * Install pre-commit and the pre-commit hooks.
 * Sops-pre-commit will check to make sure you are not by accident committing your secrets un-encrypted.\n"

pre-commit install-hooks

printf "\n * Proceed to step 2\n\n"