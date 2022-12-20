{...}: {
  environment.persistence."/persist" = {
    hideMounts = true;
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
    directories = [
      "/etc/NetworkManager/system-connections"
    ];
  };

  networking.hostId = "40762f1f";

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=2G" "mode=755"];
  };

  fileSystems."/nix" = {
    device = "djungelskog/NixOS/nix";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "djungelskog/NixOS/persist";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1232bbd5-a84c-4ba5-83f1-0358658ef4c8";
    fsType = "ext4";
  };
}
