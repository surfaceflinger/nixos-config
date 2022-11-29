{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    virt-manager
    spice-gtk
  ];
  virtualisation.libvirtd.enable = true;
}
