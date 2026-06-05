# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Lily Foster <lily@lily.flowers>
# Portions of this code are adapted from nixos-cosmic
# https://github.com/lilyinstarlight/nixos-cosmic

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.displayManager.cosmic-greeter;
  cfgAutoLogin = config.services.displayManager.autoLogin;

  # gammad applies gamma correction (night light) to the greeter display.
  # Following upstream guidance, it must run right before the greeter starts.
  # https://github.com/nedimzecic/gammad
  greeterStart =
    if cfg.gammad.enable then
      pkgs.writeShellScript "cosmic-greeter-start-gammad" ''
        ${lib.getExe cfg.gammad.package} ${cfg.gammad.card} ${toString cfg.gammad.temperature} || true
        exec ${lib.getExe' cfg.package "cosmic-greeter-start"} "$@"
      ''
    else
      lib.getExe' cfg.package "cosmic-greeter-start";
in

{
  meta.teams = [ lib.teams.cosmic ];

  options.services.displayManager.cosmic-greeter = {
    enable = lib.mkEnableOption "COSMIC greeter";
    package = lib.mkPackageOption pkgs "cosmic-greeter" { };

    gammad = {
      enable = lib.mkEnableOption "gamma correction (night light) for the COSMIC greeter using gammad";
      package = lib.mkPackageOption pkgs "gammad" { };

      card = lib.mkOption {
        type = lib.types.str;
        default = "card1";
        example = "card0";
        description = ''
          The DRM device to apply gamma correction to, as found in `/dev/dri/`.
        '';
      };

      temperature = lib.mkOption {
        type = lib.types.ints.positive;
        default = 3000;
        description = ''
          The color temperature (in Kelvin) to apply to the greeter display.
          Lower values are warmer.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.cosmic-comp
      pkgs.cosmic-icons
      cfg.package
    ];

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          user = "cosmic-greeter";
          command = ''${lib.getExe' pkgs.coreutils "env"} XCURSOR_THEME="''${XCURSOR_THEME:-Pop}" ${greeterStart}'';
        };
        initial_session = lib.mkIf (cfgAutoLogin.enable && (cfgAutoLogin.user != null)) {
          user = cfgAutoLogin.user;
          command = ''${lib.getExe' pkgs.coreutils "env"} XCURSOR_THEME="''${XCURSOR_THEME:-Pop}" systemd-cat -t cosmic-session ${lib.getExe' pkgs.cosmic-session "start-cosmic"}'';
        };
      };
    };

    # Daemon for querying background state and such
    systemd.services.cosmic-greeter-daemon = {
      wantedBy = [ "multi-user.target" ];
      before = [ "greetd.service" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "com.system76.CosmicGreeter";
        ExecStart = lib.getExe' cfg.package "cosmic-greeter-daemon";
        Restart = "on-failure";
      };
    };

    systemd.tmpfiles.settings.cosmic-greeter."/run/cosmic-greeter".d = {
      group = "cosmic-greeter";
      mode = "0755";
      user = "cosmic-greeter";
    };

    # The greeter user is hardcoded in `cosmic-greeter`
    users.groups.cosmic-greeter = { };
    users.users.cosmic-greeter = {
      description = "COSMIC login greeter user";
      isSystemUser = true;
      home = "/var/lib/cosmic-greeter";
      homeMode = "0750";
      createHome = true;
      group = "cosmic-greeter";
      extraGroups = [ "video" ];
    };
    # Required for authentication
    security.pam.services.cosmic-greeter = {
      allowNullPassword = true;
    };

    hardware.graphics.enable = true;
    services.accounts-daemon.enable = true;
    services.dbus.packages = [ cfg.package ];
    services.libinput.enable = true;
  };
}
