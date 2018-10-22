{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.kubernetes.addons.kuberouter;
in {
  options.services.kubernetes.addons.kuberouter = {
    enable = mkEnableOption "kubernetes kuberouter addon";
  };

  config = mkIf cfg.enable {
    services.kubernetes.addonManager.addons = {
      # add to the bootstrapped rbac stuff


      kuberouter-configmap = pkgs.writeText kuberouter-configmap.yaml '''

      ''';

      kuberouter-daemonset = pkgs.writeText kuberouter-daemonset.yaml '''

      ''';
    };
  };
}
