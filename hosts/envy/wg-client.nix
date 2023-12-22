{ config, ... }:
let 
  interface-name = "wg0";

  endpoint-pk = "O/PnMwnoWHozT5oLcKJhYRw+h3+lCSRS/hr8DiHDoAM=";
  endpoint = "vpn.atarbinian.com:51820";
  endpoint-ip = "10.0.0.1/32";

  envy-ip = "10.0.0.9/32";
  envy-dns = "9.9.9.9";
in {
  age.secrets.wg-private-envy.file = ../../secrets/wg-private-envy.age;
  environment.etc."NetworkManager/system-connections/wg0.nmconnection" = {
    # files must by owned by root with perms 0600 or networkmanager will ignore them
    # https://unix.stackexchange.com/a/619415
    mode = "0600";
    text = ''
      [connection]
      id=${interface-name}
      uuid=a3e84326-d2a0-472e-b794-0ae36eeb7d08
      type=wireguard
      interface-name=${interface-name}

      [wireguard]
      private-key=${builtins.readFile config.age.secrets.wg-private-envy.path}

      [wireguard-peer.${endpoint-pk}]
      endpoint=${endpoint}
      allowed-ips=${endpoint-ip};

      [ipv4]
      address1=${envy-ip}
      dns=${envy-dns};
      ignore-auto-dns=true
      method=manual

      [ipv6]
      addr-gen-mode=default
      method=disabled
      '';
  };
}