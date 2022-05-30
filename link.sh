#!/usr/bin/env sh

THIS_DIR=$(dirname $(readlink -f "./nixpkgs"))

# sync sytem level config by hostname
function link_system()
{
	rm -rf /etc/nixos
	ln -s $THIS_DIR/nixos/$(hostname) /etc/nixos
	nixos-rebuild switch
}

function get_release()
{
	local retval=$(nixos-version | python -c "import sys;[sys.stdout.write('.'.join(line.split('.')[:2])) for line in sys.stdin]")
	echo "$retval"
}

function link_home_manager()
{
	if ! command -v home-manager &> /dev/null
	then
		echo "home-manager not found! attempting install!"
		nix-channel --add https://github.com/nix-community/home-manager/archive/release-$(get_release).tar.gz home-manager
		nix-channel --update
	fi

	runuser -l $SUDO_USER -c "rm -f ~/.config"
	runuser -l $SUDO_USER -c "ln -s $THIS_DIR ~/.config"
	runuser -l $SUDO_USER -c "home-manager build switch"
}

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

link_system
link_home_manager
