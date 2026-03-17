export ZSH="$HOME/.oh-my-zsh"

plugins=(
    git
    dnf
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/flowis/programs:$PATH"

# Aliases (lsd)
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

alias e='eza'
alias cpp='clipcopy'
alias c='claude'
alias o='xdg-open'

# Tools
fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc
source <(fzf --zsh)
source "/home/jakub/.openclaw/completions/openclaw.zsh"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval $(keychain --eval --quiet ~/.ssh/id_ed25519)
