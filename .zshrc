zmodload zsh/complist
autoload -U compinit && compinit
autoload -U colors && colors

# cmp opts
zstyle ':completion:*' menu select # tab opens cmp menu
zstyle ':completion:*' special-dirs true # force . and .. to show in cmp menu
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33 # colorize cmp menu
# zstyle ':completion:*' file-list true # more detailed list
zstyle ':completion:*' squeeze-slashes false # explicit disable to allow /*/ expansion

# main opts
setopt append_history inc_append_history share_history # better history
# on exit, history appends rather than overwrites; history is appended as soon as cmds executed; history shared across sessions
setopt auto_menu menu_complete # autocmp first menu match
setopt autocd # type a dir to cd
setopt auto_param_slash # when a dir is completed, add a / instead of a trailing space
setopt no_case_glob no_case_match # make cmp case insensitive
setopt globdots # include dotfiles
setopt extended_glob # match ~ # ^
setopt interactive_comments # allow comments in shell
unsetopt prompt_sp # don't autoclean blanklines
stty stop undef # disable accidental ctrl s

# history opts
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$XDG_CACHE_HOME/zsh_history" # move histfile to cache
HISTCONTROL=ignoreboth # consecutive duplicates & commands starting with space are not saved

export EDITOR=hx

### SET FZF DEFAULTS
export FZF_DEFAULT_COMMAND="fdfind --type f --hidden --follow"

# accept autosuggestion
bindkey '^y' autosuggest-accept

alias ff="fastfetch"
alias ..="cd .."
alias ls="eza --color=always --group-directories-first -al"
alias la="eza --color=always --group-directories-first -a"
alias ll="eza --color=always --group-directories-first -l"
alias lt="eza --color=always --group-directories-first -aT"
alias zconf="hx $HOME/.zshrc"
alias svr="ssh codedbyshoe@72.60.66.126"

# add syntax highlighting and autosuggestions
source "$HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

eval "$(starship init zsh)"
eval "$(/home/andrew/.local/bin/mise activate zsh)"

export PATH="$PATH:$HOME/.local/bin:$HOME/.fly/bin:$HOME/.config/herd-lite/bin:$PATH"

# Turso
export PATH="$PATH:/home/andrew/.turso"
