if type -q tmux
    abbr --add ta 'tmux attach -t'
end

if type -q eza
    abbr --add ls eza
    abbr --add ll 'eza -lg --icons="auto" --git'
    abbr --add tree 'eza -T'
    abbr --add la 'eza -a'
end

if type -q bat
    abbr --add cat bat
end

# --- Git
abbr --add g git
abbr --add gaa 'git add -A'
abbr --add gcmsg 'git commit -m'
abbr --add gd 'git diff'
abbr --add gdc 'git diff --cached'
abbr --add gp 'git push'
abbr --add gs 'git status'
abbr --add gsc 'git status --show-stash'
abbr --add gf 'git fetch --all'
abbr --add gl 'git log --graph --abbrev-commit --decorate --format=format:\"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)\" --all'


abbr --add title 'wezterm cli set-tab-title'
abbr --add n nvim

