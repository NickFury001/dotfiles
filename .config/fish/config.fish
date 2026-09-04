if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -x BROWSER qutebrowser
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set -gx TERMINAL kitty
    set -Ux LIBVA_DRIVER_NAME iHD
    # Force Aquamarine (Hyprland's backend) to only see Intel
    set -Ux AQ_DRM_DEVICES /dev/dri/card2

    # Catch older wlroots dependencies and Xwayland just in case
    set -Ux WLR_DRM_DEVICES /dev/dri/card2
    fastfetch
end

# Start Hyprland on TTY1
if status is-login
    if test -z "$WAYLAND_DISPLAY"; and test (tty) = /dev/tty1
        start-hyprland
    end
end

set PATH $PATH $HOME/.local/bin
