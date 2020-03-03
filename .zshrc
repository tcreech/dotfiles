set -o vi
autoload -Uz compinit && compinit
autoload -Uz colors && colors
setopt share_history hist_ignore_dups
setopt complete_in_word
setopt auto_pushd no_auto_cd no_auto_name_dirs
setopt prompt_subst
setopt no_bg_nice
export HISTFILE=~/.zhistory
export HISTSIZE=1000000
export SAVEHIST=1000000

# For GNU coreutils ls
export LS_COLORS'di=1;34:ln=1;36:so=32:pi=33:ex=1;32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
# For BSDish ls
export CLICOLOR=1
export LSCOLORS="ExGxcxdxCxegedabagacad"
alias ll='ls -l '

[[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
	source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

function pr_pwdcolor() {
	if [[ -w $PWD ]]; then
		print green
	else
		print red
	fi
}

function pr_hostcolor() {
	if (( ${+SSH_CONNECTION} )); then
		print green
	else
		print default
	fi
}

PROMPT="[%B%(!.%F{red}%n.%F{blue}%n)%F{white}@%U%F{\$(pr_hostcolor)}%m%f%u:%F{\$(pr_pwdcolor)}%~%f%b]%# "


