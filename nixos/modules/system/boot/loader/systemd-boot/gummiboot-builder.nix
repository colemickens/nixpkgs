{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.boot.loader.systemd-boot;
  efi = config.boot.loader.efi;
in
  pkgs.substituteAll {
    src = ./systemd-boot-builder.py;

    isExecutable = true;

    inherit (pkgs) python3;

    systemd = config.systemd.package;

    nix = config.nix.package.out;

    timeout = if config.boot.loader.timeout != null then config.boot.loader.timeout else "";

    editor = if cfg.editor then "True" else "False";

    configurationLimit = if cfg.configurationLimit == null then 0 else cfg.configurationLimit;

    inherit (cfg) consoleMode;

    inherit (efi) efiSysMountPoint canTouchEfiVariables;

    memtest86 = if cfg.memtest86.enable then pkgs.memtest86-efi else "";
  }
