{ pkgs, ... }: {
  users.users.nat = {
    uid = 1111;
    initialHashedPassword = "$6$lR2ORA5b3eQUIqWN$W0RFJ7/5jWfajKZl2CfSwp5/BmUIzuS5OnRvksaUWmN575fubdRMybKDAFKKDnh67k6z39qjNlMLiI/drslNv1";
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "networkmanager" "adbusers" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGeYYGkVH8pPo1f769OHYn6Vga6wnhftJA6w2IJADzgs nat@blahaj"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEBoE8OnT+YbaLQJFPvZIbmh+6FP252Jk93AyZiF86Y4 nat@djungelskog"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPSqGOe/GfjCXruEaDqvPNSY72rTKiQNnX3x/Ey1ajB+ hanoip"
    ];
  };

  systemd.tmpfiles.rules = [ "d /home/nat 0700 nat users - -" ];
}
