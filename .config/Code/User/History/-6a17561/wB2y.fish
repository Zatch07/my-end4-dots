function fish_prompt -d "Write out the prompt"
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive
    # No greeting
    set fish_greeting

    # Use starship
    starship init fish | source

    # Global Environment Variables
    # Now using VS Code as the primary system editor
    set -gx EDITOR "code --wait --quiet"
    set -gx VISUAL "code --wait --quiet"

    # Aliases
    alias clear "printf '\033[2J\033[3J\033[1;1H'"
    alias celar "printf '\033[2J\033[3J\033[1;1H'"
    alias claer "printf '\033[2J\033[3J\033[1;1H'"
    alias ls 'eza --icons'
    alias pamcan pacman
    alias q 'qs -c ii'

end

# Function to make Yazi quit to the current working directory
function yazi
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# This makes the word 'code' silent without an alias
function code
    command code -r --quiet $argv 2>/dev/null
end