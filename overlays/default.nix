{
  # This one brings our custom packages from the 'packages' directory
  additions = final: _prev: import ../packages {pkgs = final;};

  modifications = final: prev: {
    # Enable OpenASAR for Discord.
    discord = prev.discord.override {withOpenASAR = true;};
    # Enable global dark mode in Google Chrome (Chromium still can't set prefers-color-scheme properly from GTK theme)
    google-chrome = prev.google-chrome.override {commandLineArgs = "--enable-features=WebUIDarkMode --force-dark-mode";};
    # Install mpv with scripts
    mpv = prev.wrapMpv prev.mpv-unwrapped {scripts = [prev.mpvScripts.youtube-quality prev.mpvScripts.mpris];};
  };
}
