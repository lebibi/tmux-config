# Sourced from ~/.bashrc. -S follows the symlink, so a dangling link is skipped.
if [ -S "$HOME/.ssh/ssh_auth_sock" ]; then
    export SSH_AUTH_SOCK="$HOME/.ssh/ssh_auth_sock"
fi

# Resync a pane that predates this setup.
fixssh() { eval "$(tmux show-environment -g -s SSH_AUTH_SOCK)"; }
