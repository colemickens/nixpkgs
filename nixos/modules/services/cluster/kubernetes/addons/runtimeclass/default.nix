{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.kubernetes.addons.runtimeclass;
in {
  options.services.kubernetes.addons.runtimeclass = {
    enable = mkEnableOption "kubernetes runtimeclass addon";
  };

  config = mkIf cfg.enable {
    services.kubernetes.addonManager.addons = {
      # https://raw.githubusercontent.com/kubernetes/kubernetes/v1.12.1/cluster/addons/runtimeclass/runtimeclass_crd.yaml
      runtimeclass-crd = readFile ./runtimeclass_crd.yaml;
    };
  };
}
