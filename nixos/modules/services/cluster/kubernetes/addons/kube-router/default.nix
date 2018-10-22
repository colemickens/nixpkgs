{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.kubernetes.addons.kuberouter;

  outputScript = pkgs.writeText generate '''
    subsituteAll .
  ''';
in {
  options.services.kubernetes.addons.kuberouter = {
    enable = mkEnableOption "kubernetes kuberouter addon";
  };

  config = mkIf cfg.enable {
    services.kubernetes.addonManager.addons = {
      # add to the bootstrapped rbac stuff
      kuberouter = (substituteAll {
        src = ./kuberouter.yaml; 
	apiserver = cfg.top.apiserver;
	clusterCidr = cfg.top.clusterCidr;
      };
    };
  };
}

