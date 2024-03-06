{ pkgs, config, lib }: let
  port = 9993;
  package = pkgs.zerotierone;
in {
  systemd.services.zerotierone = {
    description = "ZeroTierOne";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    wants = [ "network-online.target" ];
    path = [ package ];
    preStart = ''
      mkdir -p /var/lib/zerotier-one/networks.d
      chmod 700 /var/lib/zerotier-one
      chown -R root:root /var/lib/zerotier-one
      touch "/var/lib/zerotier-one/networks.d/$(cat /run/secrets/zerotier_network_id).conf"
    '';
    serviceConfig = {
      User = "root";
      ExecStart = "${package}/bin/zerotier-one -p${toString port}";
      Restart = "always";
      KillMode = "process";
      TimeoutStopSec = 5;
    };
  };
  networking.dhcpcd.denyInterfaces = [ "zt*" ];
  networking.firewall.allowedUDPPorts = [ port ];
  environment.systemPackages = [ package ];
  systemd.network.links."50-zerotier" = {
    matchConfig = {
      OriginalName = "zt*";
    };
    linkConfig = {
      AutoNegotiation = false;
      MACAddressPolicy = "none";
    };
  };
}
