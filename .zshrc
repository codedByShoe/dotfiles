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

# fzf setup
source <(fzf --zsh) # allow for fzf history widget

# binds
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^k" kill-line
bindkey "^j" backward-word
bindkey "^k" forward-word
bindkey "^H" backward-kill-word
# ctrl J & K for going up and down in prev commands
bindkey "^J" history-search-forward
bindkey "^K" history-search-backward
bindkey '^R' fzf-history-widget
# accept autosuggestion
bindkey '^y' autosuggest-accept

#aliases
alias vi="nvim"
alias ff="fastfetch"
alias nvconf="cd ~/.config/nvim && nvim"
alias aweconf="cd ~/.config/awesome && nvim"
alias zconf="nvim ~/.zshrc"
alias update="sudo pacman -Syyu && kill -45 $(pidof dwmblocks)"
alias fk="sudo !!" 
alias l="ls -lh --color=auto --group-directories-first" 
alias ls="ls -h --color=auto --group-directories-first" 
alias la="ls -lah --color=auto --group-directories-first" 
alias grep="grep --color=auto" \

# --- OneDark Prompt ---
setopt prompt_subst

# Colors (OneDark)
ONEDARK_BG="#282c34"
ONEDARK_DIM="#3e4451"
ONEDARK_FG="#abb2bf"
OD_BLUE="#61afef"
OD_GREEN="#98c379"
OD_YELLOW="#e5c07b"
OD_RED="#e06c75"
OD_MAGENTA="#c678dd"
OD_CYAN="#56b6c2"

# Git helpers (fast & simple)
_git_branch() {
  command git rev-parse --abbrev-ref HEAD 2>/dev/null
}
_git_dirty() {
  command git status --porcelain 2>/dev/null | grep -q . && echo "*"
}

# Powerline-style segment: segment <bg> <fg> <text>
segment() {
  local bg="$1" fg="$2" text="$3"
  print -Pn "%F{$bg}%K{$bg}%F{$fg} ${text} %k%F{$bg}%f"
}

# Build prompt before each command
precmd() {
  local tstamp="%D{%I:%M%P}"            # 12h time
  local user="%n"                       # username
  local dir_short="%~"                  # cwd
  local branch="$(_git_branch)"
  local dirty="$(_git_dirty)"
  local git_seg=""
  [[ -n $branch ]] && git_seg="$(segment $OD_GREEN $ONEDARK_BG " ${branch}${dirty}")"

  PROMPT=$'\n'"$(segment $OD_CYAN $ONEDARK_BG "󰣇  ${user}") "
  PROMPT+="$(segment $OD_BLUE $ONEDARK_BG "  ${tstamp}") "
  PROMPT+=$(segment $ONEDARK_DIM $ONEDARK_FG "  ${dir_short}")" "
  [[ -n $git_seg ]] && PROMPT+="$git_seg "
  PROMPT+=$'\n'"%F{$OD_GREEN}❯%f "
}

# Right prompt: last exit (only if non-zero) + optional venv
precmd_exit_rprompt() {
  local last=$?
  local venv=""
  [[ -n $VIRTUAL_ENV ]] && venv="${VIRTUAL_ENV:t}"
  RPROMPT=""
  [[ -n $venv ]] && RPROMPT+="%F{$OD_YELLOW}[${venv}]%f"
  if (( last != 0 )); then
    [[ -n $RPROMPT ]] && RPROMPT+=" "
    RPROMPT+="%F{$OD_RED}✖ ${last}%f"
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd precmd_exit_rprompt
# --- End OneDark Prompt ---


# add syntax highlighting and autosuggestions
source "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"


export PATH="$PATH:$HOME/go/bin:/opt/chromite/:/opt/nvim/:$HOME/.config/composer/vendor/bin:$HOME/.bun/bin:$HOME/bin:/usr/local/bin:${HOME}/.npm-global/bin:${HOME}/.local/bin:$PATH"
eval "$(~/.local/bin/mise activate)"
source "$HOME/.env/init.sh"



