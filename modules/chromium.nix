{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    google-chrome
  ];

  programs.chromium = {
    enable = true;
    extraOpts = {
      "DefaultJavaScriptJitSetting" = 2;
      "HistoryClustersVisible" = false;
      "SavingBrowserHistoryDisabled" = true;
    };
    extensions = [
      # Manifest version in parenthesis
      "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite (3)
      "fihnjjcciajhdojfnbdddfaoknhalnja" # I don't care about cookies (3)
      "gebbhagfogifgggkldgodflihgfeippi" # Return YouTube dislike (3)
      "lckanjgmijmafbedllaakclkaicjfmnk" # ClearURLs (2)
      "mafpmfcccpbjnhfhjnllmmalhifmlcie" # TOR Snowflake (2)
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock for YouTube (2)
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden (3)
      "omkfmpieigblcllmkgbflkikinpkodlk" # enhanced-h264ify (2)
    ];
  };
}
