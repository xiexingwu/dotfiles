Version controlled contents of the `.config/` directory.

# Quickstart

Clone over HTTPS (SSH isn't set up yet on a fresh machine) and place its contents in your `$HOME/.config`:
```sh
git clone https://github.com/xiexingwu/dotfiles.git $HOME/.config_tmp
cp -vrf $HOME/.config_tmp/ $HOME/.config/
rm -rf $HOME/.config_tmp
# pulls/pushes need the SSH setup below
git -C $HOME/.config remote set-url origin github:xiexingwu/dotfiles.git
```

Both steps overwrite existing files: the copy above replaces same-named files in `~/.config`,
and `push_home` replaces tracked dotfiles in `$HOME`. On a machine that isn't fresh, back up
first, and preview what `push_home` would change:
```sh
make check_home
```

To manage dotfiles directly in the `$HOME` directory:
```sh
make push_home
```

To pull changes from `$HOME` into the repo:
```sh
make check_home
make fetch_home
```

# SSH

Keys live in the password managers; only the `.pub` files are on disk.
`~/.ssh/config` points each host at an agent, and `IdentityFile <key>.pub` + `IdentitiesOnly yes`
picks the matching key from it. Clone with the host aliases, not `github.com`:

| Alias        | Agent       | Key                |
|--------------|-------------|--------------------|
| `github`     | Proton Pass | `id_personal.pub`  |
| `github-r2r` | 1Password   | `id_r2r.pub`       |

## 1Password
1. Sign in to the app, then Settings → Developer → enable "Use the SSH agent".
2. `1Password/ssh/agent.toml` limits the agent to the Employee and Private vaults.

## Proton Pass
1. `pass-cli login`
2. Start the agent (it also starts on every login, serving the Personal vault at `~/.ssh/proton-pass-agent.sock`):
   ```sh
   launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/me.proton.pass.ssh-agent.plist
   ```
   Logs go to `~/.ssh/proton-pass-agent.log`.

## Verify
```sh
ssh -T github
ssh -T github-r2r
```
