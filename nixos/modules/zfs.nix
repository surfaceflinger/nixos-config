{...}: {
  boot = {
    supportedFilesystems = ["zfs"];
    kernelParams = ["init_on_alloc=0" "init_on_free=0" "zfs.zfs_abd_scatter_enabled=0" "zfs.zfs_compressed_arc_enabled=0"];
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  };
}
