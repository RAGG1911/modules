{ self, inputs, ... }: {
  flake.nixosConfigurations.raggPuter = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.raggPuterConfiguration
    ];
  };
}