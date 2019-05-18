setupaliases() {
    # Aliases
    alias ll='ls -l'
    alias mv='nocorrect mv '
    alias cp='nocorrect cp '
    alias rm='nocorrect rm '
    alias mkdir='nocorrect mkdir '
    alias locate='nocorrect locate '
    alias hgrep='history 1 | grep '
    alias grep='grep '

    # For GNU coreutils ls
    export LS_COLORS'di=1;34:ln=1;36:so=32:pi=33:ex=1;32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
    # For BSDish ls
    export LSCOLORS="ExGxcxdxCxegedabagacad"

    # Set up alias for ls for some color:
    if ls --color 2> /dev/null 1> /dev/null; then
       # We are using GNU ls. (Or newer FreeBSD ls.)
       alias ls='ls --color '
    else
       # Guess we are using BSD ls with '-G' support.
       if ls -G 2> /dev/null > /dev/null; then
          alias ls='ls -G '
       fi
    fi

    alias xtest='xlogo& ; sleep 1;killall xlogo'
}

setupfunctions() {
    # Function to silently launch and disown a process.
    silentdisown(){
       $* |& cat > /dev/null &|
    }

    # Function to attach to "work" tmux session. Intended to be somewhat
    # portable. If there is a "startwork" command and the "work" session
    # doesn't exist yet, run it. If there is no "startwork" command, just
    # create an empty session named "work". Then, in any event, create new
    # temporary session grouped to the "work" session and attach to it. When
    # the called detaches or is disconnected the temporary session will be
    # destroyed by the tmux server, with the "work" session surviving.
    work(){
       if ! tmux has-session -t work 2> /dev/null; then
          if which startwork 1> /dev/null 2> /dev/null; then
             startwork
          else
             tmux new -s work -d
          fi
       fi
       tmux new -t work \; set destroy-unattached
    }

    # Function to relocate all tmux clients in a session
    tmuxprivacy(){
        for i in $(tmux list-clients -F'#S' | awk -v SELF=$(tmux display-message -p '#S') '$1 != SELF'); do
           tmux select-window -t $i:0
        done
    }

    ttree(){
            tree --charset=utf8 -C $* | less -XFr
    }
}

setupenvironment() {
    setopt inc_append_history share_history
    setopt append_history
    setopt correct
    # put timestamps in the history
    setopt extended_history
    setopt all_export
    setopt   notify globdots correct pushdtohome cdablevars autolist
    setopt   autocd recexact longlistjobs
    setopt   autoresume histignoredups pushdsilent
    setopt   autopushd pushdminus extendedglob rcquotes mailwarning
    unsetopt bgnice autoparamslash

    # Autoload zsh modules when they are referenced
    zmodload -a zsh/stat stat
    zmodload -a zsh/zpty zpty
    zmodload -a zsh/zprof zprof
    zmodload -a zsh/mapfile mapfile

    # Add some PATHs I keep in HOME often
    PATH="$HOME/bin:$HOME/opt/bin:$PATH"
    # For pkgsrc installations
    PATH="$PATH:/opt/local/bin:/opt/local/sbin"

    # my public bin in AFS
    #PATH=$PATH:/afs/tcreech.com/usr/tcreech/pub/bin

    TZ="America/New_York"
    HISTFILE=$HOME/.zhistory
    HISTSIZE=1000
    SAVEHIST=10000000000
    PAGER='less'
    EDITOR='vim'
    MPD_HOST=pass@host

    unsetopt all_export

    autoload -U compinit
    compinit
    bindkey '^I' complete-word # complete on tab, leave expansion to _expand
    zstyle ':completion::complete:*' use-cache on

    # I don't think this has ever actually worked.
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

    # Get vi keybindings for line input
    bindkey -v

    # Add the fancy anonymous script editor so that I can press 'v' in command
    #  mode and get vim to edit the input.
    autoload -U edit-command-line
    zle -N edit-command-line
    bindkey -M vicmd '^X^E' edit-command-line

    # If available, use url-quote-magic. Assumes the much older 'is-at-least'
    # is around.
    autoload -U is-at-least
    if is-at-least 4.3.9; then
      autoload -U url-quote-magic && zle -N self-insert url-quote-magic
    fi

    #Re-enable emacs-style incremental searching:
    bindkey -M viins  history-incremental-search-backward
    bindkey -M vicmd  history-incremental-search-backward
}

function precmd {

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

    # now let's change the color of the user name if we are root
    if [ "$USER" = "root" ]; then
        PR_USERCOLOR="${PR_BOLD_RED}"
    else
        PR_USERCOLOR="${PR_BOLD_BLUE}"
    fi

    # check if jobs are executing
    if [[ ${#jobstates} -gt 0 ]]; then
        PR_JOBS=" jobs:%j"
    else
        PR_JOBS=""
    fi
}

# If I am using vi keys, I want to know what mode I'm currently using.
# zle-keymap-select is executed every time KEYMAP changes.
# From http://zshwiki.org/home/examples/zlewidgets
zle-keymap-select() {
    VIMODE="${${KEYMAP/vicmd/ vim:command}/(main|viins)}"
    RPROMPT2="${PR_BOLD_BLUE}\${VIMODE}${PR_DEFAULT}"
    zle reset-prompt
}

zle -N zle-keymap-select

setprompt () {
    # Need this, so the prompt will work
    setopt prompt_subst

    # let's load colors into our environment, then set them
    autoload colors

    if [[ "$terminfo[colors]" -ge 8 ]] || [[ "$termcap[colors]" -ge 8 ]]; then
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
    RPROMPT="$PR_DEFAULT(${PR_BOLD_RED}%(?.. exit:%?)${PR_BOLD_BLUE}\${PR_JOBS}\${PR_VCS}\${PR_BATTERY}\
${PR_BOLD_BLUE}\${VIMODE} $PR_BOLD_YELLOW%D{%m/%d %H:%M}$PR_DEFAULT )"

    # Of course we need a matching continuation prompt
    PROMPT2='${PR_BOLD_DEFAULT} ...%_:%{${reset_color}%} '
}

setupenvironment
setupaliases
setupfunctions
setprompt
