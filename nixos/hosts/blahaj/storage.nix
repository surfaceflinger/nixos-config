_: {
  environment.persistence."/persist" = {
    hideMounts = true;
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
    directories = [
      "/etc/NetworkManager/system-connections"
      "/var/cache/minidlna"
    ];
  };

  networking.hostId = "b84cacfe";

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=2G" "mode=755" ];
  };

  fileSystems."/nix" = {
    device = "blahaj/NixOS/nix";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "blahaj/NixOS/persist";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4B56-046D";
    fsType = "vfat";
  };

  # Add some dataset from secondary HDD as neededForBoot so the entire pool gets activated in Stage 1.
  fileSystems."/vol/ikea/Other" = {
    device = "ikea/Other";
    fsType = "zfs";
    neededForBoot = true;
  };

  systemd.tmpfiles.rules = [
    "d /vol/Games 0700 nat users - -"
  ];
}
