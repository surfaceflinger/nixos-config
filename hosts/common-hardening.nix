{ modulesPath, ... }: {
  imports = [
    (modulesPath + "/profiles/hardened.nix")
  ];

  security = {
    allowSimultaneousMultithreading = true;
    lockKernelModules = false;
    unprivilegedUsernsClone = true;
    pam.loginLimits = [
      {
        domain = "*";
        item = "core";
        type = "hard";
        value = "0";
      }
    ];
  };
  systemd.coredump.enable = false;

  boot.kernel.sysctl = {
    "dev.tty.ldisc_autoload" = "0";
    "fs.protected_fifos" = "2";
    "fs.protected_regular" = "2";
    "fs.suid_dumpable" = "0";
    "kernel.printk" = "3 3 3 3";
    "kernel.sysrq" = "4";
    "kernel.yama.ptrace_scope" = "2";
    "net.ipv4.tcp_dsack" = "0";
    "net.ipv4.tcp_rfc1337" = "1";
    "net.ipv4.tcp_sack" = "0";
    "net.ipv4.tcp_timestamps" = "0";
    "net.ipv6.conf.all.accept_ra" = "0";
    "net.ipv6.default.accept_ra" = "0";
    "syskernel.core_pattern" = "|/bin/false";
    "vm.swappiness" = "1";
  };

  boot.kernelParams = [
    "slab_nomerge"
    "vsyscall=none"
    "debugfs=off"
    "oops=panic"
    "module.sig_enforce=0"
    "lockdown=confidentiality"
    "efi=disable_early_pci_dma"
    "amd_iommu=on"
    "intel_iommu=on"
    "quiet"
    "loglevel=0"
  ];

  boot.blacklistedKernelModules = [
    "dccp"
    "sctp"
    "rds"
    "tipc"
    "n-hdlc"
    "x25"
    "decnet"
    "econet"
    "af_802154"
    "ipx"
    "appletalk"
    "psnap"
    "p8023"
    "p8022"
    "can"
    "atm"
    "jffs2"
    "hfsplus"
    "squashfs"
    "udf"
    "cifs"
    "nfs"
    "nfsv3"
    "nfsv4"
    "gfs2"
    "vivid"
    "thunderbolt"
    "firewire-core"
  ];

  environment.memoryAllocator.provider = "libc";
}
