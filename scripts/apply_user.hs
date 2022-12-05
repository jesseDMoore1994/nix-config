#!/run/current-system/sw/bin/env nix-shell
#!nix-shell -i runghc -p "haskellPackages.ghcWithPackages (pkgs: [ pkgs.turtle ])"
import Turtle
import Data.Text as T
{-# LANGUAGE OverloadedStrings #-}


getUser :: [(T.Text, T.Text)] -> Maybe Text
getUser env = if (not . Prelude.null) matching then Just $ getFirstValue $ matching else Nothing 
  where
  getFirstValue = snd . Prelude.head
  matching = Prelude.filter (\x -> (fst x) == (T.pack "USER")) env


main = do
    environment <- env
    user <- case (getUser environment) of
      Just x -> return x
      Nothing -> die $ T.pack $ "user cannot be determined, USER variable not set."

    host <- hostname
    proc (T.pack "nix") [ T.pack "build"
                        , T.pack $ ".#homeManagerConfigurations."
                                 ++ (T.unpack user)
                                 ++ "@"
                                 ++ (T.unpack host)
                                 ++ ".activationPackage"
                        ] Turtle.empty
    proc (T.pack "./result/activate") [] Turtle.empty
    exit ExitSuccess
