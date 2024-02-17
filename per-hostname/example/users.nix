{ pkgs }: {
  root = {
    initialPassword = "change_me";
  };
  user = {
    initialPassword = "change_me";
    authorizedKeys = [ ];
    extraGroups = [ ];

    shell = pkgs.zsh;
    programs = {};
    packages = with pkgs; [];
  };
}