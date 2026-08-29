if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -x BROWSER qutebrowser
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set -gx TERMINAL kitty
    fastfetch
end

# Start Hyprland on TTY1
if status is-login
    if test -z "$WAYLAND_DISPLAY"; and test (tty) = /dev/tty1
        start-hyprland
    end
end

set PATH $PATH $HOME/.local/bin
