{ pkgs, lib, inputs, config, ...}: let
  cfg = config.display;
in {
  options.display = {
    enable = lib.mkEnableOption "Display";
    package = lib.mkOption {
      default = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
  };

  config = {
    programs.hyprland = {
      enable = true;
      # package = cfg.package;
    };

    # xdg already installed
    #xdg.portal = {
    #  enable = true;
    #  wlr.enable = lib.mkForce false;
    #  extraPortals = [pkgs.xdg-desktop-portal-gtk];
    #  xdgOpenUsePortal = true;
    #};

    # locker on sleep
    systemd.services.locker = {
      before = ["sleep.target"];
      wantedBy = ["sleep.target"];
      script = "${pkgs.systemd}/bin/loginctl lock-sessions";
    };

    home-manager.users.derek = {
      home.stateVersion = "24.05";
      wayland.windowManager.hyprland = {
        enable = true;
        # package = cfg.package;
      };
    };
  };
}
