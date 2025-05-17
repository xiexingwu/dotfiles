Version controlled contents of the `.config/` directory.

# Quickstart

Clone the repo and place its contents in your `$HOME/.config`:
```sh
git clone github:xiexingwu/dotfiles.git $HOME/.config_tmp
cp -vrf $HOME/.config_tmp/ $HOME/.config/
rm -rf $HOME/.config_tmp
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
