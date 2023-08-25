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

      rm -rf /tmp/nix-config-system
      git clone https://github.com/jesseDMoore1994/nix-config.git /tmp/nix-config-system || true

      pushd /tmp/nix-config-system

      date 
      nohup ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake .# &

      popd
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
