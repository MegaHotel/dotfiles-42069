if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -gx PATH "$HOME/.cargo/bin" $PATH;
set -gx STARSHIP_CONFIG  "$HOME/.config/starship/starship.toml"
set -Ux PYENV_ROOT $HOME/.pyenv
set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths


alias ll='exa --long -a --icons'
alias la='exa -a --icons'
alias l='exa --tree --level=2 --long -a --icons'
alias stopall='docker stop $(docker ps -aq)'
alias fzf="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
alias vim='lvim-gui'
alias aliases='vim ~/.config/fish/config.fish'
alias store='sudo pamac-manager'
alias nvidia-manager='sudo nvidia-settings'
alias i3-conf='vim ~/.config/i3/config'
alias sudo='sudo '
alias aq='asciiquarium'
alias pre-lol="sudo sh -c 'sysctl -w abi.vsyscall32=0'"
alias post-lol="sudo sh -c 'sysctl -w abi.vsyscall32=1'"
alias nordvpn-start="sudo systemctl start nordvpnd && nordvpn login && nordvpn connect us"
alias speedtest="speedtest --bytes"
alias new_btop="alacritty --class btop,btop -e btop </dev/null &>/dev/null & disown"

starship init fish | source
neofetch --ascii ~/.config/neofetch/ascii.txt
pyenv init - | source
status --is-interactive; and pyenv virtualenv-init - | source

