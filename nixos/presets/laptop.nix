{config, ...}: {
  imports = [
    ./desktop.nix
  ];

  powerManagement.cpuFreqGovernor = "schedutil";

  # Personal preference on how logind should handle lid switch.
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "lock";
  };
}
