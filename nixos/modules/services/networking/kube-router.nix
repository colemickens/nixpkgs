{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.kube-router;
in
{
  options.services.kube-router = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "This option enables containerd, a daemon that manages linux containers.";
    };

    clusterCidr = mkOption {
      type = types.string;
      description = "The cluster cidr.";
    };

    kubeconfig = mkOption {
      type = types.string;
      description = "Kubeconfig to access the apiserver.";
    };
  };

  config = mkIf cfg.enable {
    systemd.packages = [ pkgs.kube-router ];
    systemd.services.kube-router = {
      after = [ "network-online.target" "network.target" ];
      wants = [ "network-online.target" "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = [ "" "${pkgs.kube-router}/bin/kube-router" "--kubeconfig=${kubeconfig}" "--cluster-cidr=${clusterCidr}" ];
      };
      path = incpkgs;
    };
  };
}
