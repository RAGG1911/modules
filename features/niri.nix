{ self, inputs, ... }: {
    flake.nixosModules.niri = { pkgs, lib, ... }: {
        programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.raggNiri;
        };
    };

    perSystem = { pkgs, lib, self', ... }: {
        packages.raggNiri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = {
            spawn-at-startup = [
                (lib.getExe self'.packages.raggNoctalia)
                (lib.getExe pkgs.xwayland-satellite)
            ];

            xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

            extraConfig = ''
                input {
                    touchpad {
                        tap
                        natural-scroll
                        dwt
                    }
                    focus-follows-mouse "max-scroll-amount"="0%" {
                    }
                }

                window-rule {
                    geometry-corner-radius 4
                    clip-to-geometry true
                }
            '';

            layout = {
                gaps = 8;
                focus-ring = {
                    width = 6;
                    active-color = "#ab1784";
                    inactive-color = "#313244";
                };
                preset-column-widths = [
                    { proportion = 0.5; }
                    { proportion = 0.666667; }
                ];
                
            };

            


            binds = {
                # --- Apps ---
                "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
                "Mod+Z".spawn-sh = "flatpak run app.zen_browser.zen";
                "Mod+V".spawn-sh = "code";
                "Mod+E".spawn-sh = "dolphin";
                "Mod+S".spawn-sh = "${lib.getExe self'.packages.raggNoctalia} ipc call launcher toggle";
                "Mod+A".spawn-sh = "${lib.getExe self'.packages.raggNoctalia} ipc call controlCenter toggle";
                "Mod+Shift+Q".spawn-sh = "${lib.getExe self'.packages.raggNoctalia} ipc call sessionMenu toggle";

                # --- Window management ---
                "Mod+F".maximize-column = _: {};
                "Mod+Q".close-window = _: {};
                "Mod+O".toggle-overview = _: {};

                # --- Focus movement ---
                "Mod+Left".focus-column-left = _: {};
                "Mod+Right".focus-column-right = _: {};
                "Mod+Up".focus-window-up = _: {};
                "Mod+Down".focus-window-down = _: {};
                "Mod+H".focus-column-left = _: {};
                "Mod+L".focus-column-right = _: {};
                "Mod+K".focus-window-up = _: {};
                "Mod+J".focus-window-down = _: {};

                # --- Move windows ---
                "Mod+Shift+Left".move-column-left = _: {};
                "Mod+Shift+Right".move-column-right = _: {};
                "Mod+Shift+Up".move-window-up = _: {};
                "Mod+Shift+Down".move-window-down = _: {};
                "Mod+Shift+H".move-column-left = _: {};
                "Mod+Shift+L".move-column-right = _: {};
                "Mod+Shift+K".move-window-up = _: {};
                "Mod+Shift+J".move-window-down = _: {};

                # --- Workspaces ---
                "Mod+1".focus-workspace = 1;
                "Mod+2".focus-workspace = 2;
                "Mod+3".focus-workspace = 3;
                "Mod+4".focus-workspace = 4;
                "Mod+5".focus-workspace = 5;
                "Mod+Shift+1".move-column-to-workspace = 1;
                "Mod+Shift+2".move-column-to-workspace = 2;
                "Mod+Shift+3".move-column-to-workspace = 3;
                "Mod+Shift+4".move-column-to-workspace = 4;
                "Mod+Shift+5".move-column-to-workspace = 5;
                "Mod+Tab".focus-workspace-down = _: {};
                "Mod+Shift+Tab".focus-workspace-up = _: {};

                # --- Workspace mouse scroll ---
                "Mod+WheelScrollDown" = _: {
                    props.cooldown-ms = 150;
                    content.focus-workspace-down = _: {};
                };
                "Mod+WheelScrollUp" = _: {
                    props.cooldown-ms = 150;
                    content.focus-workspace-up = _: {};
                };

                # --- Volume ---
                "XF86AudioRaiseVolume" = _: {
                    props.allow-when-locked = true;
                    content.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+";
                };
                "XF86AudioLowerVolume" = _: {
                    props.allow-when-locked = true;
                    content.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
                };
                "XF86AudioMute" = _: {
                    props.allow-when-locked = true;
                    content.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
                };

                # --- Brightness ---
                "XF86MonBrightnessUp".spawn = [ (lib.getExe pkgs.brightnessctl) "set" "5%+" ];
                "XF86MonBrightnessDown".spawn = [ (lib.getExe pkgs.brightnessctl) "set" "5%-" ];

                # --- Screenshots ---
                "Print".screenshot = _: {};
                "Ctrl+Print".screenshot-screen = _: {};
                "Alt+Print".screenshot-window = _: {};

                # --- Niri essentials ---
                "Mod+Shift+E".quit = _: {};
                "Mod+Escape".toggle-keyboard-shortcuts-inhibit = _: {};
            };
        };

        
        };
    };
}