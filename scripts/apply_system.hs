#!/run/current-system/sw/bin/env nix-shell
#!nix-shell -i runghc -p "haskellPackages.ghcWithPackages (pkgs: [ pkgs.turtle ])"
{-# LANGUAGE OverloadedStrings #-}
import Turtle
import Data.Text as T

main = do
    proc (T.pack "sudo") [ T.pack "nixos-rebuild"
                         , T.pack "switch"
                         , T.pack "--flake"
                         , T.pack ".#"
                         ] Turtle.empty
    exit ExitSuccess
