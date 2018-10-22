{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.kube-router;
in
{
  options.services.kube-router = {
    enable =
      mkOption {
        type = types.bool;
        default = false;
        description =
          ''
            This option enables containerd, a daemon that manages
            linux containers.
          '';
      };
  };

  config = mkIf cfg.enable {
      systemd.packages = [ pkgs.kube-router ];
      environment.systemPackages = incpkgs;

      systemd.services.containerd = {
        after = [ "network-online.target" "network.target" ];
        wants = [ "network-online.target" "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = [ "" "${pkgs.containerd}/bin/containerd --config=${configFile}" ];
        };
        path = incpkgs;
      };

      # TODO: assert that cri-o is not running as well
      environment.etc."crictl.yaml".text = ''
        runtime-endpoint: unix:///run/containerd/containerd.sock
        image-endpoint: unix:///run/containerd/containerd.sock
        timeout: 10
        debug: true
      '';

      systemd.sockets.containerd = {
        description = "Containerd Socket for the API";
        wantedBy = [ "sockets.target" ];
        socketConfig = {
          ListenStream = "/run/containerd/containerd.sock";
          SocketMode = "0660";
          SocketUser = "root";
          SocketGroup = "root";
        };
      };

    };
}
