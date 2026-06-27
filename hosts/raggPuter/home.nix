{ self, inputs, ... }: {
  flake.nixosModules.raggPuterHome = { pkgs, config, ... }: {
    home-manager.users.ragg = {
        
        programs.kitty.enable = true;
        programs.alacritty.enable = true;
        

        stylix.targets.gtk.enable = true;
        
        
        home.stateVersion = "24.11"; 
    };
  };
}