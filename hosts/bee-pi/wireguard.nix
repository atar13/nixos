{ config, pkgs, ... }:
{
  age.secrets.wg-private-pi.file = ../../secrets/wg-private-pi.age;

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  # enable NAT   
  networking.nat.enable = true;
  networking.nat.externalInterface = "eth0";
  networking.nat.internalInterfaces = [ "wg0" ];

  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [ 
          "10.0.0.1/24" 
          # "fdc9:281f:04d7:9ee9::1/64" 
      ];


      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 51820;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE
      '';
        # ${pkgs.iptables}/bin/ip6tables -A FORWARD -i wg0 -j ACCEPT
        # ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o ens5  -j MASQUERADE
        # ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o eth0 -j MASQUERADE

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE
        ${pkgs.iptables}/bin/ip6tables -D FORWARD -i wg0 -j ACCEPT
      '';
        #${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o ens5  -j MASQUERADE
        #${pkgs.iptables}/bin/ip6tables -D FORWARD -i wg0 -j ACCEPT
        # ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o eth0 -j MASQUERADE

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = config.age.secrets.wg-private-pi.path;

      peers = [
        # envy 
        {
          publicKey = "PLpszb004p9fo8dn2fzfwbRzR1vKLxinfgN5tkl9cQg=";
          allowedIPs = [ "10.0.0.2/32" ];
        }
        # iphone 14 pro
        {
          publicKey = "yohDl+bTiiKmfYXf/8WW74EOTEOFhaLAdlrFI25E8ms=";
          allowedIPs = [ 
          "10.0.0.3/32" 
          # "fdc9:281f:04d7:9ee9::3/128"
          ];
        }
        # iphone 14
        {
          publicKey = "bnsiLWPmjgwPLbH1yyA4/Wb5BiH968MIq6aYQU5xRH0=";
          allowedIPs = [ "10.0.0.4/32" ];
        }
        # dell inspiron (1)
        {
          publicKey = "Ujbb5UALrlKJ2Y1MG9Eqn/+Pn3NkacAV64bnXNV4X2Q=";
          allowedIPs = [ "10.0.0.5/32" ];
        }
        # fire stick (1)
        {
          publicKey = "1jAUxsebC2r86XVWWD8iCozJiCIM44AqYSDtY9Ch+28=";
          allowedIPs = [ "10.0.0.6/32" ];
        }
        # iphone 12 (blue)
        {
          publicKey = "0rJg2CKNGlPpTLtLjXsIx/FqjXL23YSj4T5AUgQdu3Y=";
          allowedIPs = [ "10.0.0.7/32" ];
        }
        # ipad pro
        {
          publicKey = "xpbEK4iS0FaRDqWCyw+TQK3nnyjbn8tUa+9sBTGfSRI=";
          allowedIPs = [ "10.0.0.8/32" ];
        }
        # envy nixos
        {
          publicKey = "xOQKn3SX7L4Lr8YhJUFY0nBnhrro1bN0NlU/bQJ4E2U=";
          allowedIPs = [ "10.0.0.9/32" ];
        }
        # grogs-desktop 
        {
          publicKey = "k5Z9yWWZyGs8HN1Jxb6W+xiIgxausPQPqVv/pW3aBGg=";
          allowedIPs = [ "10.0.0.10/32" ];
        }
        # lenovo-legion
        {
          publicKey = "BfI+FDYTl0nP4gnDFPI8cjw/rjfNjx0MQJ3yFEWi5zg=";
          allowedIPs = [ "10.0.0.12/32" ];
        }
        {
          publicKey = "RebwZEDqXXTBpHbiENOpn3t1Jhu3J0uuGHueTrniy0E=";
          allowedIPs = [ "10.0.0.13/32" ];
        }
        # framework-16
        {
          publicKey = "dEGmN6MOQhW+rYsgReV4FUcSWkSVKK+g3Gwo0HtCeQ0=";
          allowedIPs = [ 
            "10.0.0.14/32" 
            # "fdc9:281f:04d7:9ee9::14/128"
          ];
        }
        # ipad-9
        {
          publicKey = "n/peh2tTymooI87a/zgqG6AcnKLIm+or9gGVOfuqPUU=";
          allowedIPs = [ "10.0.0.15/32" ];
        }
        # black iphone12
        {
          publicKey = "Xol3jTKsprejykbbvMNlSvgoJ1fUgHv4tJZ13lTRzEw=";
          allowedIPs = [ "10.0.0.16/32" ];
        }
        {
          publicKey = "kbcShJPdb5XeIfus79/b76xYmzlgB0tglSYujzJ3wRU=";
          allowedIPs = [ "10.0.0.17/32" ];
        }
        {
          publicKey = "fBRQ84QfE8zJMX/RPjS4ekzy4ZtKEdX0RohcWql46Eg=";
          allowedIPs = [ "10.0.0.18/32" ];
        }
        {
          publicKey = "bAB23zaxI2l5sj5rSugkkP5UEigPBePkuJtLSZeIjHA=";
          allowedIPs = [ "10.0.0.19/32" ];
        }
        {
          publicKey = "8JYb5GRfSDdtAIxLoCV/zxl8C350w29VPEGv6z868CE=";
          allowedIPs = [ "10.0.0.20/32" ];
        }
        {
          publicKey = "jR9MlRxi4K5LE96E7iy5cB0m/0ubOc9+jDDL2zWOgig=";
          allowedIPs = [ "10.0.0.21/32" ];
        }
        {
          publicKey = "8LZFmGVEtyvgppmLopwHGjIsCGgldtDGguyKDDP9WSU=";
          allowedIPs = [ "10.0.0.22/32" ];
        }
        {
          publicKey = "TX3AymryQTnwhhd/zAi/+VaSYGwPRRUD5toiJ5f9R0U=";
          allowedIPs = [ "10.0.0.23/32" ];
        }
        {
          publicKey = "AaRD1MwfoxUanpfde4nVYFxO4HYcwutgfrcJ+MXyP2A=";
          allowedIPs = [ "10.0.0.24/32" ];
        }
        # dell nixos
        {
          publicKey = "v3heG7MHCa6XN+cjGl45GIDnK7O85Q0OsGnJ9qPDfQ8=";
          allowedIPs = [ "10.0.0.25/32" ];
        }
        # kris dell2
        {
          publicKey = "4CdCQ6uerCVASEpPteBC6TLTMHGdAXkI97U18kzRew4=";
          allowedIPs = [ "10.0.0.26/32" ];
        }
        # tv-firestick
        {
          publicKey = "7VZdOlHyRsIKMEdO59EJXB+xnHBjmORy/GUR/w4zaHw=";
          allowedIPs = [ "10.0.0.27/32" ];
        }
        # pc
        {
          publicKey = "AuIoMirev4+KP0O6U3ur6u/iF2fXNwb+Kf0iJZXGkno=";
          allowedIPs = [ "10.0.0.28/32" ];
        }
        # bob-fire
        {
          publicKey = "P4uQXvxWZvijEffWXoXmTET+GR9XSjgfPfguqNKH53k=";
          allowedIPs = [ "10.0.0.29/32" ];
        }
        {
          publicKey = "P3K8gTKpipbmWhcv0bl86HlsEZR1ijgOh9YUvh1kcHE=";
          allowedIPs = [ "10.0.0.32/32" ];
        }
        {
          publicKey = "Bj4grJ7ujyWCBMyQxpK+ZutH7icRFS53Bhf5OQi7+kY=";
          allowedIPs = [ "10.0.0.33/32" ];
        }
        
      ];
    };
  };

}
