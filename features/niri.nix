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
            ];


            binds = {
            "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
            "Mod+S".spawn-sh = "${lib.getExe self'.packages.raggNoctalia} ipc call launcher toggle";
            };
        };
        };
    };
}