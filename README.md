# tmux-config

tmux config including tmux plugin manager (tpm) and catppuccin

![Screenshot](./imgs/screenshot.png)

## Dependencies

Mac OS

```bash
brew install tmux-mem-cpu-load
```

Linux build from source:

```bash
git clone https://github.com/thewtex/tmux-mem-cpu-load
cd tmux-mem-cpu-load
mkdir build && cd build
cmake ..
sudo make install
```

## Installation

1. clone this repo to .tmux

    ```bash
    git clone https://github.com/nwesem/tmux-config .tmux
    # or ssh
    git clone git@github.com:nwesem/tmux-config.git .tmux
    ```

1. install tmux plugin manager

    ```bash
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ```

1. link .tmux.conf to home

    ```bash
    ln -s ~/.tmux/.tmux.conf ~/.tmux.conf
    ```

1. if in tmux session source file

    ```bash
    tmux source ~/.tmux.conf
    ```

1. Now tap the rewritten key bindings `CTRL + a` + `I` to install all plugins

1. Done :grin:

## SSH agent forwarding

`.tmux.conf` points every pane at a stable socket path, `~/.ssh/ssh_auth_sock`,
instead of the ephemeral one a given SSH connection provides. Two things keep
that symlink aimed at the live connection's agent, so panes that were already
open when you detached keep working after you reattach:

- `bin/tmux-ssh-agent-relink`, run by a `client-attached` hook, on every attach
- `ssh/rc`, installed as `~/.ssh/rc` and run by sshd, on every incoming connection

Without the steps below, agent forwarding inside tmux stops working.

1. install the sshd hook

    ```bash
    install -m 600 ~/.tmux/ssh/rc ~/.ssh/rc
    ```

    Keep the `xauth` block in that file, X11 forwarding needs it once
    `~/.ssh/rc` exists.

1. source the shell snippet, so new shells prefer the stable path and you get a
   `fixssh` helper

    ```bash
    echo '[ -f "$HOME/.tmux/shell/ssh-agent.sh" ] && . "$HOME/.tmux/shell/ssh-agent.sh"' >> ~/.bashrc
    ```

1. reconnect over SSH so `~/.ssh/rc` creates the link, then check it

    ```bash
    ssh-add -l   # should list your forwarded keys
    ```

Panes opened before installing still hold the old path. Run `fixssh` in each.

### Known limitation

The `client-attached` hook fires on attach, not when you switch focus between
two clients connected at the same time (laptop and desktop both attached). In
that case agent requests keep going to whichever client attached last. See
[socklink](https://markshroyer.com/2025/09/socklink/) for a `client-active`
based approach that handles it.
