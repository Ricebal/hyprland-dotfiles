return {
    applications = {
        chat = "flatpak run --socket=wayland --branch=stable --arch=x86_64 --command=com.slack.Slack --file-forwarding com.slack.Slack --enable-features=UseOzonePlatform --ozone-platform=wayland",
        browser = "flatpak run app.zen_browser.zen",
        database_client = "flatpak run --nosocket=wayland --socket=x11 --env=GDK_BACKEND=x11 io.dbeaver.DBeaverCommunity",
        project_menu = "~/.local/scripts/open-project",
        graphical_file_manager = "nautilus",
        password_manager = "~/.local/bin/wofi-pass -s",
        music_player = "flatpak run dev.aunetx.deezer",
    },
    monitors = {
        { output = "eDP-1", mode = "1920x1200", position = "0x0", scale = 1 },
        { output = "DP-3", mode = "3440x1440@99.98", position = "-1520x-1440", scale = 1 },
        { output = "DP-1", mode = "3440x1440@99.98", position = "-1520x-1440", scale = 1 },
        { output = "HDMI-A-1", mode = "1920x1080@199.98", position = "1920x0", scale = 1 },
    },
    devices = {
        { name = "foostan-corne-v4-mouse", sensitivity = -0.5 },
    },
    workspace_rules = {
        { workspace = "1", monitor = "eDP-1" },
    },
    monitor_shortcuts = { "eDP-1", "HDMI-A-1", "DP-3" },
    autostart_once = {},
}