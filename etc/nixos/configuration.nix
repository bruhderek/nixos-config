# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./apple-silicon-support
      inputs.apple-silicon-support.nixosModules.apple-silicon-support
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "derek-macbook"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # X11, gnome, wayland
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
  
  boot.extraModprobeConfig = ''
    options hid_apple iso_layout=0
 '';

  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  hardware.asahi = {
    peripheralFirmwareDirectory = ./firmware;
    withRust = true;
    addEdgeKernelConfig = true;
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
    setupAsahiSound = true;
  };
  hardware.opengl.enable = true;
  
  nixpkgs.overlays = [
    inputs.apple-silicon-support.overlays.apple-silicon-overlay
  ];

  # Define a user account
  users.users.derek = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
    packages = with pkgs; [
      firefox
      tree
      neovim
      git
      nerdfonts
      kitty
      wget
      curl
      unzip
      python3
      nodejs_21
      luarocks
      fd
      ripgrep
      cargo
      fzf
      clang
      gh
      bibata-cursors
      gnome3.gnome-tweaks
    ];
  };
  
  nix.extraOptions =  ''
    experimental-features = flakes
  ''

  system.stateVersion = "24.05"; # Do not change
}

