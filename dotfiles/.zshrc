ZINIT_HOME=$HOME/.config/zinit/

if [ ! -d $ZINIT_HOME ]; then
  mkdir -p $ZINIT_HOME
  git clone https://github.com/zdharma-continuum/zinit.git $ZINIT_HOME
fi

alias clear='clear -x'
alias claer='clear -x'
alias cls='clear -x'

#source zinit in .zshrc
source $ZINIT_HOME/zinit.zsh

#add in zinit plugins

# add zsh-syntax-highlighting
zinit light zsh-users/zsh-syntax-highlighting

# add zsh-autosuggestions
zinit light zsh-users/zsh-autosuggestions

# add zsh-completions
zinit light zsh-users/zsh-completions

#add in snippets

#autoload completion
autoload -U compinit && compinit

#history
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTDUP=erase
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

#Completion style
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'
zstyle ':completion:*' menu no

#aliases
#alias ls='ls -l1 --color'
eval "$(starship init zsh)"
export PATH="$PATH;$HOME/.local/bin/"
alias ls='exa --long'
