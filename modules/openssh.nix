{ ... }: {
  services.openssh = {
    enable = true;
    openFirewall = true;
    kexAlgorithms = [ "sntrup761x25519-sha512@openssh.com" ];
    ciphers = [ "chacha20-poly1305@openssh.com" ];
    macs = [ "-*" ];
    kbdInteractiveAuthentication = false;
    passwordAuthentication = false;
    permitRootLogin = "no";
    extraConfig = ''
      AllowAgentForwarding no
      AllowGroups users
      LoginGraceTime 15s
      MaxAuthTries 2
      MaxStartups 4096
      PerSourceMaxStartups 1
      PrintMotd no
      PubkeyAcceptedKeyTypes ssh-ed25519
    '';
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
}
