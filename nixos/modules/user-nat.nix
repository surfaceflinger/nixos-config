{pkgs, ...}: {
  users.users.nat = {
    uid = 1111;
    initialHashedPassword = "$6$lR2ORA5b3eQUIqWN$W0RFJ7/5jWfajKZl2CfSwp5/BmUIzuS5OnRvksaUWmN575fubdRMybKDAFKKDnh67k6z39qjNlMLiI/drslNv1";
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd" "networkmanager" "adbusers"];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBeWbH2L99MoMuT2a1nzmpI86VBht/io2TBraa2Pe98F nat@sparkle"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIANRmkBgx14Oa1CKUQfS76V0ixEJzKhHlM8XF7qqiapa nat@apricot"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEqJ6aKTV33D1iZcuEw86lQ6QxmcfqIEcpBs4Da7GjI2 hanoip"
    ];
  };

  systemd.tmpfiles.rules = ["d /home/nat 0700 nat users - -"];
}
