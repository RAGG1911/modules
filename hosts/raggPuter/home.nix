{ self, inputs, ... }: {
  flake.nixosModules.raggPuterHome = { pkgs, config, ... }: {
    home-manager.users.ragg = {
        
        #programs
        programs.kitty.enable = true;
        programs.alacritty.enable = true; 
        programs.vesktop.enable = true;
        programs.prismlauncher.enable = true;
        programs.vscode.enable = true;
        programs.git.enable = true;

        stylix.targets.gtk.enable = true;
        
        
        home.stateVersion = "24.11"; 
    };
  };
}