{ pkgs }: {
  services = {
    xserver.enable = true;
    xserver.displayManager.sddm.enable = true;
    xserver.displayManager.defaultSession = "none+openbox";
    xserver.windowManager.openbox.enable = true;
  };
  packages = with pkgs; [
    neovim
  ];
}
