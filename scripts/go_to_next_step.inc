go_to_next_step() {
    local nextstep="${1}"
    local filename="step$nextstep*"
    # shellcheck disable=SC2015
    printf "\n * Proceed to step $nextstep (%s)? [Y/n] " $filename
    read response
    response="$a" | tr '[:upper:]' '[:lower:]'  # tolower
    response=${response:-yes}                   # default yes
    if [[ "$response" =~ ^(yes|y)$ ]]; then
        ./$filename
    else 
        printf " Exit!\n"
        exit 0
    fi
}