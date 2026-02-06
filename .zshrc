# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [[ -z "$TMUX" && -z "$TMUXP_SESSION" ]]; then
  fastfetch
fi

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ========================================
# Zsh configuration for Oh My Zsh + Powerlevel10k
# Compatible with Zsh 5.9+
# ========================================

# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set Powerlevel10k as the theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins to load
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  sudo
  extract
  history
  fzf
)

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Powerlevel10k instant prompt (optional but recommended)
if [[ -r ~/.p10k.zsh ]]; then
  source ~/.p10k.zsh
fi


# Aliases
alias ll='ls -lah'
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'

# History settings
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history

# Enable completion
autoload -Uz compinit
compinit

# Optional: Recommended environment variables
export EDITOR=nvim
export VISUAL=nvim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Load zsh-autosuggestions (if not loaded by Oh My Zsh)
if [[ -f $ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source $ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Load zsh-syntax-highlighting (if not loaded by Oh My Zsh)
if [[ -f $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

export FZF_DEFAULT_OPTS="
  --height=40%
  --layout=reverse
  --border
  --preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {}'
  --preview-window=right:60%
"

export FZF_ALT_C_OPTS="
  --preview 'tree -C {} | head -200'
"

export BAT_THEME="kanagawa"

# Prompt for updates (optional)
export UPDATE_ZSH_DAYS=7
export DISABLE_AUTO_TITLE='true'

