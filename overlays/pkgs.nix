[(self: super: {
  jetbrains.webstorm = super.jetbrains.webstorm.overrideAttrs (_: rec {
    version = "2023.3.2";
    src = builtins.fetchTarball {
      url = "https://download.jetbrains.com/webstorm/WebStorm-2023.3.2.tar.gz";
      sha256 = "1y32zzx4p2svw98402a68zpdvqq2gdciaz9xgv7pkk71iwn6v5yf";
    };
  });
  jetbrains.datagrip = super.jetbrains.datagrip.overrideAttrs (_: rec {
    version = "2023.3.2";
    src = builtins.fetchTarball {
      url = "https://download.jetbrains.com/datagrip/datagrip-2023.2.3.tar.gz";
      sha256 = "0i2i4yphcaf60wmzkc3wkh6ppg79wniv1c7sn0f3x8r67zy3g0pa";
   };
 });
})]