eval "$(starship init zsh)"
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"

export PATH=$PATH:/usr/local/go/bin

HISTFILE=~/.history
HISTSIZE=10000
SAVEHIST=50000

setopt inc_append_history

alias v='nvim'
alias vi='nvim'
alias vim='nvim'

bindkey "\e[3~" delete-char         # Delete
bindkey "\e[1~" beginning-of-line   # Home (some terminals)
bindkey "\e[H" beginning-of-line    # Home (alternate)
bindkey "\e[4~" end-of-line         # End (some terminals)
bindkey "\e[F" end-of-line          # End (alternate)
bindkey "\eOH" beginning-of-line    # xterm-kitty Home
bindkey "\eOF" end-of-line          # xterm-kitty End


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
