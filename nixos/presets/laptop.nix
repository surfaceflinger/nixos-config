{...}: {
  imports = [
    ./desktop.nix
  ];

  powerManagement.cpuFreqGovernor = "schedutil";
  services.thermald.enable = true;

  # Personal preference on how logind should handle lid switch.
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "lock";
  };
}
