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
      ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake .# >> /var/log/update_system.hs 2>&1

      popd
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  systemd.services."user-updater" = {
    path = [ pkgs.git pkgs.nix pkgs.nixos-rebuild pkgs.util-linux ];
    script = ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash

      set -eu

      rm -rf /tmp/nix-config-user
      git clone https://github.com/jesseDMoore1994/nix-config.git /tmp/nix-config-user || true

      pushd /tmp/nix-config-user

      date >> /var/log/update_user.hs 2>&1
      ${pkgs.util-linux}/bin/runuser jmoore bash -c "${pkgs.nix}/bin/nix build .#homeManagerConfigurations.jmoore@$(hostname).activationPackage"  >> /var/log/update_user.hs 2>&1
      ${pkgs.util-linux}/bin/runuser jmoore ./result/activate  >> /var/log/update_user.hs 2>&1

      popd
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
