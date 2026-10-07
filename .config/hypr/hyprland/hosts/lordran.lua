return {
    applications = {
        graphical_file_manager = "dolphin",
        database_client = "steam",
        browser = "zen-browser",
        project_menu = "lutris-runner",
        chat = "vesktop --enable-features=VaapiVideoDecodeLinuxGL --use-gl=angle --use-angle=gl",
        music_player = '"/opt/Deezer Discord RPC/deezer-discord-rpc"',
        password_manager = "wofi-pass -s",
    },
    monitors = {
        { output = "DP-4", mode = "1920x1080@240", position = "0x0", scale = 1 },
        { output = "DP-6", mode = "1920x1080@240", position = "-1920x0", scale = 1 },
    },
    devices = {
        { name = "hid-keyboard-hid-keyboard" },
    },
    options = {
        input = {
            sensitivity = -0.5,
        },
    },
    workspace_rules = {
        { workspace = "1", monitor = "DP-6" },
    },
    monitor_shortcuts = { "DP-6", "DP-4", "DP-4" },
    autostart_once = {
        "/usr/lib/polkit-kde-authentication-agent-1",
        "~/.local/scripts/obs-audio-setup",
    },
}