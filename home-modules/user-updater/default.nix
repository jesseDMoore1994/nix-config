{ config, pkgs, lib, ... }:
{
  systemd.user.timers.user-updater = {
    Timer = {
      OnCalendar = "*:0/15";
      Persistent = true;
      RandomizedDelaySec = "10m";
    };
    Install.WantedBy = [ "timers.target" ];
  };

  systemd.user.services.user-updater = {
    Service = {
      ExecStart = pkgs.writeShellScript "user-updater.sh" ''
         set -euo pipefail
         PATH=${lib.makeBinPath (with pkgs; [bash coreutils git nettools nix nixos-rebuild util-linux])}

         whoami
         rm -rf /tmp/nix-config-user
         git clone https://github.com/jesseDMoore1994/nix-config.git /tmp/nix-config-user || true

         pushd /tmp/nix-config-user

         host=$(hostname)
         echo $host
         date
         nix build .#homeManagerConfigurations.jmoore@$host.activationPackage
         bash ./result/activate

         popd
      '';
      Type = "oneshot";
    };

  };
}
