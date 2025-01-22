# Rice's Hyprland Dotfiles
My dotfiles for wayland compositor hyprland. Tested on Fedora and Arch linux.

## Dependencies
This config requires some packages to be installed.

### Required
```
hyprland hyprlock hyprpaper wlogout kitty waybar wofi python-pywal
```

### Optional
```
visual-studio-code neovim imv dolphin zen-browser
```

#### Yazi
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update
```
```bash
cargo install --locked yazi-fm yazi-cli
```

## Extra information
Runs host specific configuration by having directories based on host name.
Might not work if pywal hasn't been run at least once.

## Previews
![Purple-Motor](https://i.imgur.com/YcwvXtJ.png)
![Japan-Crossing](https://i.imgur.com/geKzA8f.png)
