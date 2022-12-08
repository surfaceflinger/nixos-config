{ ... }: {
  nixpkgs.overlays = [
    (self: super: {
      # Packages
      anime4k = super.callPackage ../packages/anime4k { };
      apple-emoji-linux = super.callPackage ../packages/apple-emoji-linux { };
      burpsuite = super.callPackage ../packages/burpsuite { };
      feather-wallet = super.qt6.callPackage ../packages/feather-wallet { };
      # Overrides
      discord = super.discord.override { withOpenASAR = true; };
      google-chrome = super.google-chrome.override { commandLineArgs = "--enable-features=WebUIDarkMode --force-dark-mode"; };
      mpv = super.wrapMpv self.mpv-unwrapped { scripts = [ self.mpvScripts.youtube-quality self.mpvScripts.mpris ]; };
    })
  ];
}
