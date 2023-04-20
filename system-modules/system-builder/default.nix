{ config, pkgs, ... }:
{
  # systemd.timers."hello-world" = {
  #   wantedBy = [ "timers.target" ];
  #     timerConfig = {
  #       OnBootSec = "5m";
  #       OnUnitActiveSec = "5m";
  #       Unit = "hello-world.service";
  #     };
  # };
  
  systemd.services."system-builder" = {
    path = [ pkgs.attic pkgs.git pkgs.nettools pkgs.nix ];
    script = ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash

      set -eu

      rm -rf /tmp/nix-config
      git clone https://github.com/jesseDMoore1994/nix-config.git /tmp/nix-config || true

      pushd /tmp/nix-config
      export $(cat /run/secrets/atticd.root | xargs)
      attic login $(hostname) http://$(hostname):8080 $ATTIC_ROOT_TOKEN
      attic cache create jmoore || true

      MACHINES="asmodeus baphomet"
      for MACHINE in $MACHINES
      do
        echo "Storing system config for $MACHINE"
        until nix-store -qR $(nix build .#nixosConfigurations.$MACHINE.config.system.build.toplevel --print-out-paths) | xargs attic push jmoore
        do
          sleep 1
        done
        echo "Storing home config for $MACHINE"
        until nix-store -qR $(nix build .#homeManagerConfigurations.jmoore@$MACHINE.activationPackage --print-out-paths) | xargs attic push jmoore
        do
          sleep 1
        done
      done
      popd
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
