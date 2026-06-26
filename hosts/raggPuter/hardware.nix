{ self, inputs, ... }: {

  flake.nixosModules.raggPuterHardware = { config, lib, pkgs, modulesPath, ... }:

    {
    imports =
        [ (modulesPath + "/installer/scan/not-detected.nix")
        ];

    boot.initrd.availableKernelModules = [ "vmd" "xhci_pci" "nvme" "usbhid" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
        { device = "/dev/disk/by-uuid/2e2f973c-bab2-42c9-bccb-89c33f3aa9fc";
        fsType = "ext4";
        };

    fileSystems."/boot" =
        { device = "/dev/disk/by-uuid/F37E-6B38";
        fsType = "vfat";
        options = [ "fmask=0077" "dmask=0077" ];
        };

    swapDevices =
        [ { device = "/dev/disk/by-uuid/6e09f50d-1cb7-4f6e-bb49-9ce649fed5de"; }
        ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };

}