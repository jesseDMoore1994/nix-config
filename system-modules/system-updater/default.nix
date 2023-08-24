{ config, pkgs, ... }:
{
  systemd.timers."system-updater" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/15";
      Unit = "system-updater.service";
    };
  };

  systemd.timers."user-updater" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/15";
      Unit = "user-updater.service";
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

      date >> /var/log/update_system.hs 2>&1
      nohup ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake .# >> /var/log/update_system.hs 2>&1 &

      popd
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  systemd.services."user-updater" = {
    path = [ pkgs.bash pkgs.git pkgs.nettools pkgs.nix pkgs.nixos-rebuild pkgs.util-linux ];
    script = with pkgs; ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash

      set -eu

      rm -rf /tmp/nix-config-user
      ${util-linux}/bin/runuser jmoore "${bash}/bin/bash -c '${git}/bin/git clone https://github.com/jesseDMoore1994/nix-config.git /tmp/nix-config-user || true'"

      pushd /tmp/nix-config-user

      host=$(${nettools}/bin/hostname)
      echo $host
      date >> /var/log/update_user.hs 2>&1
      ${util-linux}/bin/runuser jmoore "${bash}/bin/bash -c '${nix}/bin/nix build .#homeManagerConfigurations.jmoore@$host.activationPackage'"  >> /var/log/update_user.hs 2>&1
      ${util-linux}/bin/runuser jmoore "./result/activate"  >> /var/log/update_user.hs 2>&1

      popd
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
