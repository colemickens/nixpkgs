{ pkgs, config, lib }:

let
  configTxt = ''
  '';

  systemdBootBuilder =
    import ../systemd-boot/systemd-boot.nix {
      pkgs = pkgs.buildPackages;
      inherit config lib;
    };
in
pkgs.substituteAll {
  src = ./rpi4uefi-builder.sh;
  isExecutable = true;
  inherit (pkgs) bash;
  path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep];
  rpi4uefi = pkgs.rpi4-uefi;
  inherit configTxt;
}
