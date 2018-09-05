{ config, lib, pkgs, ... }:

with lib;

let
  top = config.services.kubernetes;
  cfg = top.flannel;
in
{
  ###### interface
  options.services.kubernetes.flannel = {
    enable = mkEnableOption "enable flannel networking";
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.flannel = {

      enable = mkDefault true;
      network = mkDefault top.clusterCidr;
    };

    services.kubernetes.kubelet = {
      networkPlugin = mkDefault "cni";
      cni.config = mkDefault [{
        name = "mynet";
        type = "flannel";
        delegate = {
          isDefaultGateway = true;
        };
      }];
    };

    networking = {
      firewall.allowedUDPPorts = [
        8285  # flannel udp
        8472  # flannel vxlan
      ];
      dhcpcd.denyInterfaces = [ "docker*" "flannel*" ];
    };

    services.kubernetes.pki.certs = {
      flannelEtcdClient = top.lib.mkCert {
        name = "flannel-etcd-client";
        CN = "flannel-etcd-client";
        action = "systemctl restart flannel.service";
      };
    };
  };
}
