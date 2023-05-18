{ config, pkgs, ... }:
{
  systemd.timers."system-builder" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 01:00:00";
      Unit = "system-builder.service";
    };
  };

  systemd.services."system-builder" = {
    path = [ pkgs.git pkgs.nettools pkgs.nix ];
    script = ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash

      set -eu

      rm -rf /tmp/nix-config
      git clone https://github.com/jesseDMoore1994/nix-config.git /tmp/nix-config || true

      pushd /tmp/nix-config

      MACHINES="asmodeus baphomet"
      for MACHINE in $MACHINES
      do
        echo "Storing system config for $MACHINE"
        nix build .#nixosConfigurations.$MACHINE.config.system.build.toplevel
        echo "Storing home config for $MACHINE"
        nix build .#homeManagerConfigurations.jmoore@$MACHINE.activationPackage
      done
      popd
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
