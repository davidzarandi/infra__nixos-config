final: super: {
  webstorm = super.jetbrains.webstorm.overrideAttrs (_: rec {
    version = "2023.3.2";
    src = builtins.fetchTarball {
      url = "https://download.jetbrains.com/webstorm/WebStorm-2023.3.2.tar.gz";
      sha256 = "1y32zzx4p2svw98402a68zpdvqq2gdciaz9xgv7pkk71iwn6v5yf";
    };
  });
}