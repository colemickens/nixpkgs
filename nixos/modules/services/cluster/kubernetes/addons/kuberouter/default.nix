{ config, pkgs, lib, ... }:

with lib;

let
  top = config.services.kubernetes;
  cfg = top.addons.kuberouter;
in {
  options.services.kubernetes.addons.kuberouter = {
    enable = mkEnableOption "kubernetes kuberouter addon";
  };

  config = mkIf cfg.enable {
    services.kuberouter = {
      enable = true;
      apiserverAddress = top.apiserverAddress;
      clusterCidr = top.clusterCidr;
    };
  };
}

