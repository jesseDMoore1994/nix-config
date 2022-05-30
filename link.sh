#!/usr/bin/env sh

function get_release()
{
	local retval=$(nixos-version | python -c "import sys;[sys.stdout.write('.'.join(line.split('.')[:2])) for line in sys.stdin]")
	echo "$retval"
}

if ! command -v home-manager &> /dev/null
then
	echo "home-manager not found! attempting install!"
	nix-channel --add https://github.com/nix-community/home-manager/archive/release-$(get_release).tar.gz home-manager
	nix-channel --update
fi


rm -f ~/.config
ln -s $(dirname $(readlink -f "nixpkgs")) ~/.config
home-manager build switch
