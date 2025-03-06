{ config, ... }:
let
  endpoint-public-key = "O/PnMwnoWHozT5oLcKJhYRw+h3+lCSRS/hr8DiHDoAM=";
  endpoint-ip = "10.0.0.0/24";

  remote-interface-name = "remote";
  remote-endpoint = "vpn.atarbinian.com:51820";

  home-interface-name = "home";
  home-endpoint = "192.168.1.62:51820";

  framework-ip = "10.0.0.14/32";
  framework-dns = "9.9.9.9";
in
{
  age.secrets.wg-private-framework.file = ../../secrets/wg-private-framework.age;

  # networking.firewall = {
  #   allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  # };
  #
  # # Enable WireGuard
  # networking.wireguard.interfaces = {
  #   # "wg0" is the network interface name. You can name the interface arbitrarily.
  #   wg0 = {
  #     # Determines the IP address and subnet of the client's end of the tunnel interface.
  #     ips = [ framework-ip ];
  #     listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)
  #
  #     # Path to the private key file.
  #     #
  #     # Note: The private key can also be included inline via the privateKey option,
  #     # but this makes the private key world-readable; thus, using privateKeyFile is
  #     # recommended.
  #     privateKeyFile = config.age.secrets.wg-private-framework.path;
  #
  #     peers = [
  #       # For a client configuration, one peer entry for the server will suffice.
  #       {
  #         publicKey = endpoint-public-key;
  #         allowedIPs = [ endpoint-ip ];
  #         # Set this to the server IP and port.
  #         endpoint = remote-endpoint; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
  #
  #         # Send keepalives every 25 seconds. Important to keep NAT tables alive.
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };

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

  # # environment.etc."NetworkManager/system-connections/${home-interface-name}.nmconnection" = {
  # #   mode = "0600";
  # #   text = ''
  # #     [connection]
  # #     id=${home-interface-name}
  # #     uuid=7c4dd788-4012-435e-a9b7-dcf76df5b904
  # #     type=wireguard
  # #     interface-name=${home-interface-name}
  # #     autoconnect=false 
  # #
  # #     [wireguard]
  # #     private-key=${builtins.readFile config.age.secrets.wg-private-framework.path}
  # #
  # #     [wireguard-peer.${endpoint-public-key}]
  # #     endpoint=${home-endpoint}
  # #     allowed-ips=${endpoint-ip};
  # #
  # #     [ipv4]
  # #     address1=${framework-ip}
  # #     dns=${framework-dns};
  # #     ignore-auto-dns=true
  # #     method=manual
  # #
  # #     [ipv6]
  # #     addr-gen-mode=default
  # #     method=disabled
  # #   '';
  # # };
}
