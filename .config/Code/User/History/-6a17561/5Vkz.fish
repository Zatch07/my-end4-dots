function fish_prompt -d "Write out the prompt"
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive
    set fish_greeting
    starship init fish | source

    # Global Env for Yazi/System
    set -gx EDITOR "code --wait"
    set -gx VISUAL "code --wait"

    # Quick Aliases
    alias c="code"
    alias ls='eza --icons'
    alias q='qs -c ii'
    
    # Silence the "Tech Chatter"
    function code
        command code --quiet $argv 2>/dev/null
    end
end

# Yazi CWD Function  
function yazi
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end