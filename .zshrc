# Aaron Toponce's ZSH prompt
# License: in the public domain
# Update: Oct 14, 2009
function precmd {
    # Get version control information for several version control backends
    #autoload -Uz vcs_info; vcs_info
    #zstyle ':vcs_info:*' formats ' %s:%b'
    #PR_VCS="${vcs_info_msg_0_}"
    PR_VCS=""

    # Initially set VIMODE.
    VIMODE="${${KEYMAP/vicmd/ vim:command}/(main|viins)}"

    # now let's change the color of the path if it's not writable
    if [[ -w $PWD ]]; then
        PR_PWDCOLOR="${PR_BOLD_GREEN}"
    else
        PR_PWDCOLOR="${PR_BOLD_RED}"
    fi  

    # now let's change the color of the hostname if this is a remote shell
    if [ "no$SSH_CONNECTION" = "no" ]; then
        PR_HOSTCOLOR="${PR_BOLD_DEFAULT}"
    else
        PR_HOSTCOLOR="${PR_BOLD_GREEN}"
    fi  
    #
    # now let's change the color of the user name if we are root
    if [ "$USER" = "root" ]; then
        PR_USERCOLOR="${PR_BOLD_RED}"
    else
        PR_USERCOLOR="${PR_BOLD_BLUE}"
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
    # This doesn't seem to work for now...
    RPROMPT2="${PR_BOLD_BLUE}\${VIMODE}${PR_DEFAULT}"
    zle reset-prompt
}

zle -N zle-keymap-select

setcrapimightnotneed() {
    # This is a mess of crap from the old zshrc I was using. Not even
    # sure if I need all of it.

    setopt INC_APPEND_HISTORY SHARE_HISTORY
    setopt APPEND_HISTORY
    unsetopt BG_NICE                # do NOT nice bg commands
    setopt CORRECT                  # command CORRECTION
    setopt EXTENDED_HISTORY         # puts timestamps in the history
    #setopt MENUCOMPLETE            # <-- lame.
    setopt ALL_EXPORT
    setopt   notify globdots correct pushdtohome cdablevars autolist
    setopt   correctall autocd recexact longlistjobs
    setopt   autoresume histignoredups pushdsilent 
    setopt   autopushd pushdminus extendedglob rcquotes mailwarning    
    unsetopt bgnice autoparamslash

    # Autoload zsh modules when they are referenced
    zmodload -a zsh/stat stat
    zmodload -a zsh/zpty zpty
    zmodload -a zsh/zprof zprof
    zmodload -a zsh/mapfile mapfile
    PATH="$HOME/bin:$HOME/myStuff/bin:$HOME/opt/bin:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:$PATH"
    TZ="America/New_York"
    HISTFILE=$HOME/.zhistory
    HISTSIZE=1000
    SAVEHIST=1000
    HOSTNAME="`hostname`"
    PAGER='less'
    EDITOR='vim'
    LC_ALL='en_US.UTF-8'
    LANG='en_US.UTF-8'
    MPD_HOST=password@hostname
    unsetopt ALL_EXPORT

    # Aliases
    alias man='LC_ALL=C LANG=C man'
    alias ll='ls -l'
    alias mv='nocorrect mv '
    alias cp='nocorrect cp '
    alias rm='nocorrect rm '
    alias mkdir='nocorrect mkdir '
    alias locate='nocorrect locate '
    alias gcalcli='gcalcli --width $(( $(( $COLUMNS - 8 )) / 7 )) '

    # Set up alias for ls for some color:
    if [ `ls --color 2> /dev/null 1> /dev/null && echo true || echo false` = "true" ]; then
       # We are using GNU ls.
       alias ls='ls --color=auto '
    else
       # Assuming we are using BSD ls.
       export LSCOLORS="ExGxcxdxCxegedabagacad"
       alias ls='ls -G '
    fi

    alias vim='vim -X '
    alias xtest='xlogo& ; sleep 1;killall xlogo'

    autoload -U compinit
    compinit
    bindkey "^?" backward-delete-char
    bindkey '^[OH' beginning-of-line
    bindkey '^[OF' end-of-line
    bindkey '^[[5~' up-line-or-history
    bindkey '^[[6~' down-line-or-history
    bindkey "^r" history-incremental-search-backward
    bindkey ' ' magic-space    # also do history expansion on space
    bindkey '^I' complete-word # complete on tab, leave expansion to _expand
    zstyle ':completion::complete:*' use-cache on
    zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST
    
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
    zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
    zstyle ':completion:*' menu select=1 _complete _ignored _approximate
    zstyle -e ':completion:*:approximate:*' max-errors \
        'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
    zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
    
    # Completion Styles
    
    # list of completers to use
    zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
    
    # allow one error for every three characters typed in approximate completer
    zstyle -e ':completion:*:approximate:*' max-errors \
        'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
        
    # insert all expansions for expand completer
    zstyle ':completion:*:expand:*' tag-order all-expansions
    
    # formatting and messages
    zstyle ':completion:*' verbose yes
    zstyle ':completion:*:descriptions' format '%B%d%b'
    zstyle ':completion:*:messages' format '%d'
    zstyle ':completion:*:warnings' format 'No matches for: %d'
    zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
    zstyle ':completion:*' group-name ''
    
    # match uppercase from lowercase
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
    
    # offer indexes before parameters in subscripts
    zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
    
    # command for process lists, the local web server details and host completion
    # on processes completion complete all user processes
    # zstyle ':completion:*:processes' command 'ps -au$USER'
    
    ## add colors to processes for kill completion
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
    
    #zstyle ':completion:*:processes' command 'ps ax -o pid,s,nice,stime,args | sed "/ps/d"'
    zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -A -o pid,user,cmd'
    zstyle ':completion:*:processes-names' command 'ps axho command' 
    #zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
    #
    #NEW completion:
    # 1. All /etc/hosts hostnames are in autocomplete
    # 2. If you have a comment in /etc/hosts like #%foobar.domain,
    #    then foobar.domain will show up in autocomplete!
    zstyle ':completion:*' hosts $(awk '/^[^#]/ {print $3 }' /etc/hosts | grep -v ip6- && grep "^#%" /etc/hosts | awk -F% '{print $2}') 
    # Filename suffixes to ignore during completion (except after rm command)
    zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
        '*?.old' '*?.pro'
    # the same for old style completion
    #fignore=(.o .c~ .old .pro)
    
    # ignore completion functions (until the _ignored completer)
    zstyle ':completion:*:functions' ignored-patterns '_*'
    zstyle ':completion:*:*:*:users' ignored-patterns \
            adm apache bin daemon games gdm halt ident junkbust lp mail mailnull \
            named news nfsnobody nobody nscd ntp operator pcap postgres radvd \
            rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs avahi-autoipd\
            avahi backup messagebus beagleindex debian-tor dhcp dnsmasq fetchmail\
            firebird gnats haldaemon hplip irc klog list man cupsys postfix\
            proxy syslog www-data mldonkey sys snort
    # SSH Completion
    zstyle ':completion:*:scp:*' tag-order \
       files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
    zstyle ':completion:*:scp:*' group-order \
       files all-files users hosts-domain hosts-host hosts-ipaddr
    zstyle ':completion:*:ssh:*' tag-order \
       users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
    zstyle ':completion:*:ssh:*' group-order \
       hosts-domain hosts-host users hosts-ipaddr
    zstyle '*' single-ignored show
    
    # Add some keybindings for ctrl-arrowkey movement with PuTTY
    bindkey '\x1b\x4f\x43' forward-word # Ctrl + Right - advance 1 word
    bindkey '\x1b\x4f\x44' backward-word # Ctrl + Left - go back 1 word
    bindkey '\xff' backward-kill-word # Alt+Bksp - kill last word 
    bindkey '\e[1~' beginning-of-line # Home - Move Beginning of Line
    bindkey '\e[4~' end-of-line # End - Move Beginning of Line
    bindkey '\e[3~' delete-char # Delete - Delete a char
    
    # Get vi keybindings for line input
    bindkey -v 
    
    # Add the fancy anonymous script editor so that I can press 'v' in command
    #  mode and get vim to edit the input.
    autoload -U edit-command-line
    zle -N edit-command-line
    bindkey -M vicmd v edit-command-line
    
    alias ct='/opt/rational/clearcase/bin/cleartool '
    # Directory in which to store shortcut dirs
    #  (just a mess of symlinks.)
    DIRDIR=$HOME/.dirs

    rmplayer(){
            typeset COUNT=$1
            shift
            randomfile $COUNT | xargs -0 mplayer $*
    }

    # Function to add shortcut dirs
    tmkdir(){
            mkdir -p $DIRDIR
            ln -s -f `pwd` $DIRDIR/$1
    }
    
    tcd(){
            if [[ $1 = "" ]]; then
                builtin cd;
            else
                if [[ -d $1 ]]; then
                    builtin cd $1;
                else 
                    # echo "step back: being magical..."
                    builtin cd `readlink $DIRDIR/$1`
                fi
            fi
    }
    
    tls(){
            mkdir -p $DIRDIR
            ls $* $DIRDIR
    }
    
    trm(){
            rm $DIRDIR/$1
    }
    
    gfind(){
            for e in $*; do find . | grep $e;done | xargs
    }
    
    alias gf='gfind '

    ttree(){ 
            tree --charset=utf8 -C $* | less -XFr
    }
    
    # Function to find/open files quickly for editing in vim
    vimfind(){
            vim -p `gfind $*`
    }
    
    # On USR2, source a file. Used for global-export.
    TRAPUSR2(){
       [ -f ~/.global_export_tmp ] && . ~/.global_export_tmp
    }
    
    # Export to /all/ instances of zsh that I can send USR2 to.
    globalexport(){
       echo > ~/.global_export_tmp
       # This is done before anything goes into the file so that
       #   there is no chance of it being readable by other users.
       chmod 600 ~/.global_export_tmp
       echo "export $*" >> ~/.global_export_tmp
       killall -USR2 zsh
    }

}

setprompt () {
    # Need this, so the prompt will work
    setopt prompt_subst

    # let's load colors into our environment, then set them
    autoload colors

    if [[ "$terminfo[colors]" -ge 8 ]]; then
        colors
    fi

    # The variables are wrapped in %{%}. This should be the case for every
    # variable that does not contain space.
    for COLOR in RED GREEN YELLOW BLUE BLACK; do
        eval PR_$COLOR='%{$fg_no_bold[${(L)COLOR}]%}'
        eval PR_BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
    done
    eval PR_BOLD_DEFAULT='%{$fg_bold[default]%}'
    eval PR_DEFAULT='%{$fg_no_bold[default]%}'

    # Finally, let's set the prompt

    # Determine here how much space we'll allow the working directory to consume.
    (( PR_PWDLEN = $COLUMNS / 6 ))

    PROMPT='${PR_DEFAULT}[\
${PR_BOLD_DEFAULT}${PR_USERCOLOR}%n${PR_BOLD_DEFAULT}@${PR_HOSTCOLOR}%U%m%u${PR_DEFAULT}:${PR_PWDCOLOR}%${PR_PWDLEN}<...<%~%<<\
${PR_DEFAULT}]%(!.#.$)\
%{${reset_color}%} '
    RPROMPT="$PR_DEFAULT(${PR_BOLD_RED}%(?.. exit:%?)${PR_BOLD_BLUE}\${PR_SCREEN}\${PR_JOBS}\${PR_VCS}\${PR_BATTERY}\
${PR_BOLD_BLUE}\${VIMODE} $PR_BOLD_YELLOW%D{%m/%d %H:%M}$PR_DEFAULT )"

    # Of course we need a matching continuation prompt
    PROMPT2='${PR_BOLD_DEFAULT} ...%_:%{${reset_color}%} '
}

setcrapimightnotneed
setprompt
