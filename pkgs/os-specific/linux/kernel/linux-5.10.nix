{ stdenv, buildPackages, fetchurl, perl, buildLinux, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "5.10.0-rc7";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  #modDirVersion = if (modDirVersionArg == null) then concatStringsSep "." (take 3 (splitVersion "${version}.0")) else modDirVersionArg;
  modDirVersion = version;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-5.10-rc7.tar.gz";
    sha256 = "sha256-n5UZT8hO7wF4ny7WVmUY71l+nGVBtkD3J28qPvGiIfI=";
  };
} // (args.argsOverride or {}))
