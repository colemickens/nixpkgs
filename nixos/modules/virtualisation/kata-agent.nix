# Systemd services for kata-agent.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualisation.kata-agent;

in

{
  ###### interface

  options.virtualisation.kata-agent = {
    enable =
      mkOption {
        type = types.bool;
        default = false;
        description =
          ''
            This option enables kata-agent,
          '';
      };
  };

  ###### implementation

  config = mkIf cfg.enable {
      systemd.targets."kata-containers" = {
        description = "Kata Containers Agent Target";
	# Requires=basic.target
	# Requires=kata-agent.service
	# Conflicts=rescue.service rescue.target
	# After=basic.target rescue.service rescue.target
	# AllowIsolate=yes
      };
      systemd.services."kata-agent" = {
        description = "TODO";
        serviceConfig = {
          ExecStart = "${pkgs.kata-agent}/bin/kata-agent";
          Restart = "always";
	};
        wantedBy = [ "multi-user.target" ]; 
      };
      environment.systemPackages = [ pkgs.kata-agent ];
    };
}

