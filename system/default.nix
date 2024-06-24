{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    ./audio
    ./locale
    ./nvidia
  ];

  # Bootloader.
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable the rt kernel
  boot.kernelPackages = pkgs.linuxPackages_zen; 

  networking.hostName = "anon";

  # Enable networking
  networking.networkmanager.enable = true; 

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  programs.hyprland = {
    enable = true;

    xwayland = {
      enable = true;
    };
  };

  xdg.portal = {
    enable = true;

    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  }; 

  # Configure console keymap
  console.keyMap = "dk-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable flatpak.
  services.flatpak.enable = true;

  # Enable GVFS for mounting remote filesystems.
  services.gvfs.enable = true;

  # Enable thumbnails for file managers.
  services.tumbler.enable = true;  

  powerManagement.cpuFreqGovernor = "performance";

  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"   ; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio" ; type = "-"   ; value = "99"       ; }
    { domain = "@audio"; item = "nofile" ; type = "soft"; value = "99999"    ; }
    { domain = "@audio"; item = "nofile" ; type = "hard"; value = "99999"    ; }
  ];

  users.users.anon = {
    isNormalUser = true;
    description = "anon";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    packages = with pkgs; [
      firefox
      neofetch
      gnome.nautilus
      ark
    ];
  };

  # Enable light
  programs.light.enable = true;

  # Enable steam
  programs.steam = {
    enable = true;
  };

  # Enable fish
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish; 

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    home-manager
  ];

  # Add fonts
  fonts.packages = with pkgs; [
    noto-fonts
    nerdfonts
    material-symbols
  ];

  # Enable experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable nix garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
