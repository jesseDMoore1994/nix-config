#!/run/current-system/sw/bin/env nix-shell
#!nix-shell -i runghc -p "haskellPackages.ghcWithPackages (pkgs: [ pkgs.turtle ])"
{-# LANGUAGE OverloadedStrings #-}
import Turtle
import Data.Text as T

main = do
    proc (T.pack "nix") [ T.pack "flake"
                        , T.pack "update"
                        ] Turtle.empty
    exit ExitSuccess
