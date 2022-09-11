#!/run/current-system/sw/bin/env nix-shell
#!nix-shell -i runghc -p "haskellPackages.ghcWithPackages (pkgs: [ pkgs.turtle ])"
import Turtle
import Data.Text as T
{-# LANGUAGE OverloadedStrings #-}

main = do
    proc (T.pack "nix") [ T.pack "build"
                        , T.pack ".#homeManagerConfigurations.jmoore.activationPackage"
                        ] Turtle.empty
    proc (T.pack "./result/activate") [] Turtle.empty
    exit ExitSuccess
