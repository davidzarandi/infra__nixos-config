users: {
  users.users = {
    root = {
      uid = 0;
      initialPassword = users.root.initialPassword;
    };
    user = {
      uid = 1000;
      initialPassword = users.user.initialPassword;
      isNormalUser = true;
      openssh.authorizedKeys.keys = users.user.authorizedKeys;
      extraGroups = [ "networkmanager" ] ++ users.user.extraGroups;
      shell = users.user.shell;
    };
  };
  programs."${(builtins.parseDrvName users.user.shell.name).name}".enable = true;
}