{ config, ... }: {
  boot = {
    supportedFilesystems = [ "zfs" ];
    kernelParams = [ "init_on_alloc=0" "init_on_free=0" ];
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  };
}
