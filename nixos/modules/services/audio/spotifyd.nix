{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.spotifyd;
  spotifydConf = pkgs.writeText "spotifyd.conf" cfg.config;
in {
  options = {
    services.spotifyd = {
      enable = mkEnableOption "spotifyd, a Spotify playing daemon";

      config = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Configuration for Spotifyd. For syntax and directives, see
          https://github.com/Spotifyd/spotifyd#Configuration.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.spotifyd = {
      serviceConfig = {
        ExecStart =
          "${pkgs.spotifyd}/bin/spotifyd --no-daemon --config-path ${spotifydConf}";
      };
    };
    systemd.packages = [ pkgs.spotifyd ];
  };

  meta.maintainers = [ maintainers.anderslundstedt ];
}
