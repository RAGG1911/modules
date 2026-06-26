{ self, inputs, ... }: {

  flake.nixosModules.raggPuterConfiguration = { config, pkgs, inputs, lib, ... }:


    #Android Setup
    let
    androidSdk = (pkgs.androidenv.composeAndroidPackages {
        platformVersions = [ "34" ];
        buildToolsVersions = [ "34.0.0" ];
        includeEmulator = false;
        includeSources = false;
        includeSystemImages = false;
        includeNDK = false;
        useGoogleAPIs = false;
        cmdLineToolsVersion = "13.0";
    }).androidsdk;
    in



    {
    imports =
        [ # Include the results of the hardware scan.
        self.nixosModules.raggPuterHardware
        self.nixosModules.niri
        ];

    #flakes
    nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
    };

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixos"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;


        #bluetooth
        hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
        General = {
            Experimental = true;      # enables battery status + extra features
            FastConnectable = true;   # faster reconnects (slight power cost)
        };
        Policy = {
            AutoEnable = true;
        };
        };
    };

    boot.extraModprobeConfig = ''
        options iwlwifi bt_coex_active=0
        options iwlwifi power_save=0
        options iwlwifi uapsd_disable=1
        options iwlmvm power_scheme=1
    '';
    
    #polkit
        security.polkit.enable = true;

    # Set your time zone.
    time.timeZone = "America/Panama";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "es_PA.UTF-8";
        LC_IDENTIFICATION = "es_PA.UTF-8";
        LC_MEASUREMENT = "es_PA.UTF-8";
        LC_MONETARY = "es_PA.UTF-8";
        LC_NAME = "es_PA.UTF-8";
        LC_NUMERIC = "es_PA.UTF-8";
        LC_PAPER = "es_PA.UTF-8";
        LC_TELEPHONE = "es_PA.UTF-8";
        LC_TIME = "es_PA.UTF-8";
    };

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    #services.displayManager.gdm.enable = true;
    #services.desktopManager.gnome.enable = true;

    #kde
    services = {
        desktopManager.plasma6.enable = true;
        displayManager.sddm.enable = true;
        displayManager.sddm.wayland.enable = true;
    };

    environment.plasma6.excludePackages = with pkgs; [
        kdePackages.elisa # Music player
        kdePackages.kdepim-runtime # Akonadi agents
        kdePackages.kmahjongg
        kdePackages.kmines
        kdePackages.konversation # IRC client
        kdePackages.kpat # Solitaire
        kdePackages.ksudoku
        kdePackages.ktorrent
    ];

    programs.kdeconnect.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "latam";
        variant = "";
    };

    # Configure console keymap
    console.keyMap = "la-latin1";

    # Enable CUPS to print documents.
    services.printing.enable = true;
        services.flatpak.enable = true;
        xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        ];
        config.common.default = "gtk";
    };

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        #jack.enable = true;

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput = {
        enable = true;
        touchpad = {
        naturalScrolling = true;
        tapping = true;
        middleEmulation = true;
        };
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users."ragg" = {
        isNormalUser = true;
        description = "Raul";
        extraGroups = [ "networkmanager" "wheel" "plugdev" "video" "audio" "input"];
        shell = pkgs.bash;
        packages = with pkgs; [
        #  thunderbird
        ];
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
        
    #android licenses
    nixpkgs.config.android_sdk.accept_license = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        #coding
        vscode
        nodejs
        flutter
        android-studio
        android-tools
        php
        php.packages.composer
        postgresql
        phpunit
        jdk
        #entertainment
        reaper
        mcaselector
        #rice
        xwayland-satellite
        kitty
        networkmanagerapplet
        #kde
        kdePackages.discover
        kdePackages.kcalc # Calculator
        kdePackages.kcharselect # Character map
        kdePackages.kclock # Clock app
        kdePackages.kcolorchooser # Color picker
        kdePackages.kolourpaint # Simple paint program
        kdePackages.ksystemlog # System log viewer
        kdePackages.sddm-kcm # SDDM configuration module
        kdiff3 # File/directory comparison tool
        kdePackages.partitionmanager
        wayland-utils # Wayland diagnostic tools
        wl-clipboard # Wayland copy/paste support
    ];

    #shut ibus up
        i18n.inputMethod.enable = lib.mkForce false;

        #fonts
        fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [
        corefonts
        maple-mono.truetype
        maple-mono.NF-unhinted
        maple-mono.NF-CN-unhinted
        nerd-fonts.noto
        font-awesome
        inter
        noto-fonts
        noto-fonts-color-emoji
        ];
        fontconfig.defaultFonts = {
        monospace = [ "Maple Mono NF" ];
        sansSerif = [ "Inter" ];
        emoji     = [ "Noto Color Emoji" ];
        };
        };
    
        #mount games disk
        fileSystems."/mnt/games" = {
        device = "/dev/disk/by-uuid/6313c0d8-a433-40c1-8fb2-1b91e4fd924f";
        fsType = "ext4";
        options = [
                "rw"
        "uid=1000"
        "gid=100"
        "nofail"
            ];
        };

    #steam
        programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
            dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
            localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
        };

    #environment variables
        environment.variables = {
            JAVA_HOME = "${pkgs.jdk}/lib/openjdk";
            ANDROID_HOME = "/home/ragg/Android/Sdk"; 
            ANDROID_SDK_ROOT = "/home/ragg/Android/Sdk";
        };
        
        programs.nix-ld = {
            enable = true;
            libraries = with pkgs; [
                stdenv.cc.cc.lib
                zlib
                glib
                libz
                libGL
                libGLU
                libX11
                libxext
                libxrender
                freetype
                expat	
            ];
        };	  
        
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ];
    # networking.firewall.allowedUDPPorts = [ ];
    # Or disable the firewall altogether.
    networking.firewall.enable = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "26.05"; # Did you read the comment?

    };


}