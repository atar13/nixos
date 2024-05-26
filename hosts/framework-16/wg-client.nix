{ config, ... }:
let
  endpoint-public-key = "O/PnMwnoWHozT5oLcKJhYRw+h3+lCSRS/hr8DiHDoAM=";
  endpoint-ip = "10.0.0.1/32";

  remote-interface-name = "remote";
  remote-endpoint = "vpn.atarbinian.com:51820";

  home-interface-name = "home";
  home-endpoint = "192.168.1.62:51820";

  framework-ip = "10.0.0.14/32";
  framework-dns = "9.9.9.9";
in
{
  age.secrets.wg-private-framework.file = ../../secrets/wg-private-framework.age;

  # Setting up nmconnection files so NetworkManager can use them for connecting to Wireguard VPN.
  # nmconnection files are created with nmcli: "nmcli connection import type wireguard file wg0.conf"
  #
  # Files must by owned by root with perms 0600 or networkmanager will ignore them
  # https://unix.stackexchange.com/a/619415

  environment.etc."NetworkManager/system-connections/${remote-interface-name}.nmconnection" = {
    mode = "0600";
    text = ''
      [connection]
      id=${remote-interface-name}
      uuid=a3e84326-d2a0-472e-b794-0ae36eeb7d08
      type=wireguard
      interface-name=${remote-interface-name}
      autoconnect=false 

      [wireguard]
      private-key=${builtins.readFile config.age.secrets.wg-private-framework.path}

      [wireguard-peer.${endpoint-public-key}]
      endpoint=${remote-endpoint}
      allowed-ips=${endpoint-ip};

      [ipv4]
      address1=${framework-ip}
      dns=${framework-dns};
      ignore-auto-dns=true
      method=manual

      [ipv6]
      addr-gen-mode=default
      method=disabled
    '';
  };

  environment.etc."NetworkManager/system-connections/${home-interface-name}.nmconnection" = {
    mode = "0600";
    text = ''
      [connection]
      id=${home-interface-name}
      uuid=7c4dd788-4012-435e-a9b7-dcf76df5b904
      type=wireguard
      interface-name=${home-interface-name}
      autoconnect=false 

      [wireguard]
      private-key=${builtins.readFile config.age.secrets.wg-private-framework.path}

      [wireguard-peer.${endpoint-public-key}]
      endpoint=${home-endpoint}
      allowed-ips=${endpoint-ip};

      [ipv4]
      address1=${framework-ip}
      dns=${framework-dns};
      ignore-auto-dns=true
      method=manual

      [ipv6]
      addr-gen-mode=default
      method=disabled
    '';
  };
}
