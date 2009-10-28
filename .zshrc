# Aaron Toponce's ZSH prompt
# License: in the public domain
# Update: Oct 14, 2009
function precmd {
    # Get version control information for several version control backends
#    autoload -Uz vcs_info; vcs_info
#    zstyle ':vcs_info:*' formats ' %s:%b'
#    PR_VCS="${vcs_info_msg_0_}"
    PR_VCS=""

    # The following 9 lines of code comes directly from Phil!'s ZSH prompt
    # http://aperiodic.net/phil/prompt/
    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} - 1 ))

    local PROMPTSIZE=${#${(%):--- %D{%R.%S %a %b %d %Y}\! }}
    local PWDSIZE=${#${(%):-%~}}

    if [[ "$PROMPTSIZE + $PWDSIZE" -gt $TERMWIDTH ]]; then
        (( PR_PWDLEN = $TERMWIDTH - $PROMPTSIZE ))
    fi

    # now let's change the color of the path if it's not writable
    if [[ -w $PWD ]]; then
        PR_PWDCOLOR="${PR_BOLD_DEFAULT}"
    else
        PR_PWDCOLOR="${PR_BOLD_YELLOW}"
    fi  

    # set a simple variable to show when in screen
    if [[ -n "${WINDOW}" ]]; then
        PR_SCREEN=" screen:${WINDOW}"
    else
        PR_SCREEN=""
    fi

    # check if jobs are executing
    if [[ ${#jobstates} -gt 0 ]]; then
        PR_JOBS=" jobs:%j"
    else
        PR_JOBS=""
    fi

    # I want to know my battery percentage when running on battery power
    if which acpi &> /dev/null; then
        local BATTSTATE="$(acpi -b)"
        local BATTPRCNT="$(echo ${BATTSTATE[(w)4]}|sed -r 's/(^[0-9]+).*/\1/')"
        if [[ -z "${BATTPRCNT}" ]]; then
            PR_BATTERY=""
        elif [[ "${BATTPRCNT}" -lt 15 ]]; then
            PR_BATTERY="${PR_BOLD_RED} batt:${BATTPRCNT}%%"
        elif [[ "${BATTPRCNT}" -lt 50 ]]; then
            PR_BATTERY="${PR_BOLD_YELLOW} batt:${BATTPRCNT}%%"
        elif [[ "${BATTPRCNT}" -lt 96 ]]; then
            PR_BATTERY=" batt:${BATTPRCNT}%%"
        else
            PR_BATTERY=""
        fi
    fi
}

# If I am using vi keys, I want to know what mode I'm currently using.
# zle-keymap-select is executed every time KEYMAP changes.
# From http://zshwiki.org/home/examples/zlewidgets
zle-keymap-select() {
    VIMODE="${${KEYMAP/vicmd/ vim:command}/(main|viins)}"
    RPROMPT2="${PR_BOLD_BLUE}${VIMODE}"
    zle reset-prompt
}

zle -N zle-keymap-select

setprompt () {
    # Need this, so the prompt will work
    setopt prompt_subst

    # let's load colors into our environment, then set them
    autoload colors

    if [[ "$terminfo[colors]" -gt 8 ]]; then
        colors
    fi

    # The variables are wrapped in %{%}. This should be the case for every
    # variable that does not contain space.
    for COLOR in RED GREEN YELLOW BLUE BLACK; do
        eval PR_$COLOR='%{$fg_no_bold[${(L)COLOR}]%}'
        eval PR_BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
    done
    eval PR_BOLD_DEFAULT='%{$fg_bold[default]%}'

    # Finally, let's set the prompt
    PROMPT='${PR_BOLD_RED}<${PR_RED}<${PR_BOLD_BLACK}<${PR_BOLD_DEFAULT} \
%D{%R.%S %a %b %d %Y}${PR_RED}|${PR_PWDCOLOR}%${PR_PWDLEN}<...<%~%<<\

${PR_BOLD_RED}<${PR_RED}<${PR_BOLD_BLACK}<\
${PR_BOLD_DEFAULT} %n@%m${PR_RED}|${PR_BOLD_DEFAULT}%h${PR_BOLD_RED}\
%(?.. exit:%?)${PR_BOLD_BLUE}${PR_SCREEN}${PR_JOBS}${PR_VCS}${PR_BATTERY}\
${PR_BOLD_BLUE}${VIMODE}\

${PR_BOLD_BLACK}>${PR_GREEN}>${PR_BOLD_GREEN}>\
%{${reset_color}%} '

    # Of course we need a matching continuation prompt
    PROMPT2='${PR_BOLD_BLACK}>${PR_GREEN}>${PR_BOLD_GREEN}>\
${PR_BOLD_DEFAULT} %_ ${PR_BOLD_BLACK}>${PR_GREEN}>\
${PR_BOLD_GREEN}>%{${reset_color}%} '
}

setprompt
