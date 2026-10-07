local home = assert(os.getenv("HOME"))
local config_home = os.getenv("XDG_CONFIG_HOME") or (home .. "/.config")
local hypr_config = config_home .. "/hypr"

local function load_module(path, optional)
    local chunk, err = loadfile(path)
    if chunk then
        return chunk()
    end
    if optional and err:match("^cannot open") then
        return {}
    end
    error(err)
end

local host_name = os.getenv("HYPRLAND_HOST") or os.getenv("HOSTNAME") or "unknown"
local host_file = io.open(home .. "/.cache/hostname/hypr.conf", "r")
if host_file and not os.getenv("HYPRLAND_HOST") then
    local host_setting = host_file:read("*a")
    host_file:close()
    host_name = host_setting:match("%$hostname%s*=%s*([%w_-]+)") or host_name
end
host_name = host_name:match("^[%w_-]+$") and host_name or "unknown"

local shared = load_module(hypr_config .. "/hyprland/shared.lua")
local host = load_module(hypr_config .. "/hyprland/hosts/" .. host_name .. ".lua", true)
local colors = load_module(home .. "/.cache/wal/hypr-colors.lua", true)

hl.config(shared.options)
if host.options then
    hl.config(host.options)
end
hl.config({
    general = {
        col = {
            active_border = {
                colors = {
                    colors.color5 or "rgb(8A63D2)",
                    colors.color6 or "rgb(63C5D2)",
                },
                angle = 45,
            },
            inactive_border = colors.color0 or "rgb(282828)",
        },
    },
})

hl.curve("myBezier", {
    type = "bezier",
    points = { { 0.05, 0.9 }, { 0.1, 1.05 } },
})
for _, animation in ipairs({
    { leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" },
    { leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" },
    { leaf = "border", enabled = true, speed = 10, bezier = "default" },
    { leaf = "borderangle", enabled = true, speed = 8, bezier = "default" },
    { leaf = "fade", enabled = true, speed = 7, bezier = "default" },
    { leaf = "workspaces", enabled = true, speed = 6, bezier = "default" },
}) do
    hl.animation(animation)
end

for _, variable in ipairs(shared.environment) do
    hl.env(variable[1], variable[2])
end

for _, monitor in ipairs(shared.monitors or {}) do
    hl.monitor(monitor)
end
for _, monitor in ipairs(host.monitors or {}) do
    hl.monitor(monitor)
end

for _, device in ipairs(shared.devices or {}) do
    hl.device(device)
end
for _, device in ipairs(host.devices or {}) do
    hl.device(device)
end

for _, rule in ipairs(shared.window_rules or {}) do
    hl.window_rule(rule)
end
for _, rule in ipairs(host.window_rules or {}) do
    hl.window_rule(rule)
end
for _, rule in ipairs(shared.layer_rules or {}) do
    hl.layer_rule(rule)
end
for _, rule in ipairs(shared.workspace_rules or {}) do
    hl.workspace_rule(rule)
end
for _, rule in ipairs(host.workspace_rules or {}) do
    hl.workspace_rule(rule)
end

local applications = {}
for name, command in pairs(shared.applications) do
    applications[name] = command
end
for name, command in pairs(host.applications or {}) do
    applications[name] = command
end

hl.on("hyprland.start", function()
    for _, command in ipairs(shared.autostart_once or {}) do
        hl.exec_cmd(command)
    end
    for _, command in ipairs(host.autostart_once or {}) do
        hl.exec_cmd(command)
    end
end)

for _, command in ipairs(shared.autostart or {}) do
    hl.exec_cmd(command)
end

local main_mod = "SUPER"
local bind = function(key, dispatcher, flags)
    hl.bind(main_mod .. " + " .. key, dispatcher, flags)
end

bind("SHIFT + RETURN", hl.dsp.exec_cmd(applications.terminal))
bind("SHIFT + C", hl.dsp.window.close())
bind("SHIFT + Q", hl.dsp.exec_cmd("wlogout"))
bind("E", hl.dsp.exec_cmd(applications.file_manager))
bind("SHIFT + E", hl.dsp.exec_cmd(applications.graphical_file_manager))
bind("P", hl.dsp.exec_cmd(applications.menu))
bind("SHIFT + P", hl.dsp.exec_cmd(applications.password_manager))
bind("O", hl.dsp.exec_cmd(applications.project_menu))
bind("W", hl.dsp.exec_cmd(applications.browser))
bind("SHIFT + B", hl.dsp.exec_cmd("killall -SIGUSR2 waybar"))
bind("SHIFT + S", hl.dsp.exec_cmd(applications.screenshot))
bind("SHIFT + L", hl.dsp.exec_cmd(applications.lock))
bind("D", hl.dsp.exec_cmd(applications.chat))
bind("SHIFT + D", hl.dsp.exec_cmd(applications.database_client))
bind("M", hl.dsp.exec_cmd(applications.music_player))
bind("SHIFT + M", hl.dsp.exec_cmd("~/.local/scripts/selectmountdisk"))
bind("SHIFT + R", hl.dsp.exec_cmd("~/.local/scripts/reload-config"))
bind("V", hl.dsp.exec_cmd(applications.volume))
bind("CTRL + V", hl.dsp.exec_cmd("~/.local/scripts/xpaste"))
bind("T", hl.dsp.window.float({ action = "toggle" }))

bind("H", hl.dsp.layout("mfact -0.05"))
bind("J", hl.dsp.layout("cyclenext"))
bind("K", hl.dsp.layout("cycleprev"))
bind("L", hl.dsp.layout("mfact +0.05"))

for workspace = 1, 10 do
    local key = tostring(workspace % 10)
    bind(key, hl.dsp.focus({ workspace = workspace }))
    bind("SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
end

for index, monitor in ipairs(host.monitor_shortcuts or {}) do
    bind("ALT + " .. index, hl.dsp.workspace.move({ monitor = monitor }))
end

bind("F", hl.dsp.window.fullscreen({ action = "toggle" }))
bind("mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind("mouse_up", hl.dsp.focus({ workspace = "e-1" }))
bind("mouse:272", hl.dsp.window.drag(), { mouse = true })
bind("mouse:273", hl.dsp.window.resize(), { mouse = true })
bind("RETURN", hl.dsp.layout("swapwithmaster"))

local locked_repeat = { locked = true, repeating = true }
for key, command in pairs({
    XF86AudioRaiseVolume = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+",
    XF86AudioLowerVolume = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-",
    XF86AudioMute = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
    XF86AudioMicMute = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle",
    XF86MonBrightnessUp = "brightnessctl s 10%+",
    XF86MonBrightnessDown = "brightnessctl s 10%-",
}) do
    hl.bind(key, hl.dsp.exec_cmd(command), locked_repeat)
end

for key, command in pairs({
    XF86AudioNext = "playerctl next",
    XF86AudioPause = "playerctl play-pause",
    XF86AudioPlay = "playerctl play-pause",
    XF86AudioPrev = "playerctl previous",
}) do
    hl.bind(key, hl.dsp.exec_cmd(command), { locked = true })
end