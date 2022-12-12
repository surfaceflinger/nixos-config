{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    virt-manager
  ];
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        runAsRoot = false;
        ovmf.enable = true;
      };
    };
  };
}
