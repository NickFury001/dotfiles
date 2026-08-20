if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
end

# Start Hyprland on TTY1
if status is-login
    if test -z "$WAYLAND_DISPLAY"; and test (tty) = /dev/tty1
        start-hyprland
    end
end
