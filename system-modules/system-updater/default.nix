{ config, pkgs, ... }:
{
  systemd.timers."system-updater" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/15";
      Unit = "system-updater.service";
    };
  };

  systemd.services."system-updater" = {
    path = [ pkgs.git pkgs.nix pkgs.nixos-rebuild pkgs.util-linux ];
    script = ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash

      set -eu

      rm -rf /tmp/nix-config
      git clone https://github.com/jesseDMoore1994/nix-config.git /tmp/nix-config || true

      pushd /tmp/nix-config

      date >> /var/log/update_system.hs 2>&1
      ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake .# >> /var/log/update_system.hs 2>&1
      date >> /var/log/update_user.hs 2>&1
      ${pkgs.util-linux} runas jmoore bash -c "${pkgs.nix}/bin/nix build .#homeManagerConfigurations.jmoore@$(hostname).activationPackage"  >> /var/log/update_user.hs 2>&1
      ${pkgs.util-linux} runas jmoore ./result/activate  >> /var/log/update_user.hs 2>&1

      popd
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
