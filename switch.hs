#!/run/current-system/sw/bin/env nix-shell
#!nix-shell -i runghc -p "haskellPackages.ghcWithPackages (pkgs: [ pkgs.turtle pkgs.split ])"
-- #!/usr/bin/env sh
-- 
-- THIS_DIR=$(dirname $(readlink -f "./nixpkgs"))
-- 
-- # sync sytem level config by hostname
-- function link_system()
-- {
-- 	rm -rf /etc/nixos
-- 	ln -s $THIS_DIR/nixos/$(hostname) /etc/nixos
-- 	nixos-rebuild switch
-- }
-- 
-- function get_release()
-- {
-- 	local retval=$(nixos-version | python -c "import sys;[sys.stdout.write('.'.join(line.split('.')[:2])) for line in sys.stdin]")
-- 	echo "$retval"
-- }
-- 
-- function link_home_manager()
-- {
-- 	if ! command -v home-manager &> /dev/null
-- 	then
-- 		echo "home-manager not found! attempting install!"
-- 		nix-channel --add https://github.com/nix-community/home-manager/archive/release-$(get_release).tar.gz home-manager
-- 		nix-channel --update
-- 	fi
-- 
-- 	runuser -l $SUDO_USER -c "rm -f ~/.config"
-- 	runuser -l $SUDO_USER -c "ln -s $THIS_DIR ~/.config"
-- 	runuser -l $SUDO_USER -c "home-manager build switch"
-- }
-- 
-- if ! [ $(id -u) = 0 ]; then
--    echo "The script need to be run as root." >&2
--    exit 1
-- fi
-- 
-- link_system
-- link_home_manager

import Turtle
import Data.Text as T
import Data.List.Split (splitOn)
import Control.Monad
import Control.Foldl as Fold
{-# LANGUAGE OverloadedStrings #-}

getParent :: Turtle.FilePath -> Turtle.FilePath
getParent f = parent f

nixPkgsFolder :: IO Turtle.FilePath
nixPkgsFolder = do
    realpath $ decodeString "nixos"

nixConfigFolder :: IO Turtle.FilePath
nixConfigFolder = do
    nixpkgs <- nixPkgsFolder
    return $ getParent nixpkgs

rootCheck :: IO Bool
rootCheck = do
     e <- env 
     let u = Prelude.lookup (T.pack "USER") e
     case u of
       Just a -> return $ a == (T.pack "root")
       _ -> return $ False

getUser :: IO (Maybe T.Text)
getUser = do
     e <- env 
     return $ Prelude.lookup (T.pack "USER") e

linkSystem :: Turtle.FilePath -> IO ExitCode
linkSystem nixcfg = do
    host <- hostname
    let path = T.concat [T.pack "nixos/", host, T.pack "/configuration.nix"]
    proc (T.pack "sudo") [ T.pack "nixos-rebuild"
                         , T.pack "switch"
                         , T.pack "-I"
                         , T.pack $ "nixos-config=" ++ encodeString (nixcfg </> fromText path)
                         ] Turtle.empty

getRelease :: IO (Maybe Line)
getRelease = do
    let sh = inproc (T.pack "nixos-version") [] Turtle.empty
    Turtle.fold sh Fold.head

parseMajorMinor :: Line -> String
parseMajorMinor l = majorMinorToString
    where
    majorMinorToString = T.unpack joinMajorMinor
    joinMajorMinor = intercalate (T.pack ".") majorMinorToText
    majorMinorToText = Prelude.map T.pack getMajorMinor
    getMajorMinor = Prelude.take 2 splitLineOnDot
    splitLineOnDot = Data.List.Split.splitOn "." lineAsStr
    lineAsStr = T.unpack $ lineToText l

getReleaseUrl :: String -> String
getReleaseUrl mm = "https://github.com/nix-community/home-manager/archive/release-" ++ mm ++ ".tar.gz"

homeManagerCheck :: IO Bool
homeManagerCheck = do
    hm <- Turtle.which $ decodeString "home-manager"
    case hm of
        Just a -> return True
        Nothing -> return False

installHomeManager :: IO ()
installHomeManager = do
    putStrLn $ "Home manager could not be found, adding it now."
    rel <- getRelease
    let mm = fmap parseMajorMinor rel

    code <- case mm of
        Just url -> proc (T.pack "nixos-channel") [T.pack "--add", T.pack (getReleaseUrl url), T.pack "home-manager"] Turtle.empty
        _ -> die $ T.pack "Could not find a suitable release version to install home manager from!"

    case code of
        ExitSuccess -> putStrLn "successfully added home-manager!"
        _ -> die $ T.pack "Could not add home manager channel!"

    code <- proc (T.pack "nixos-channel") [T.pack "--update"] Turtle.empty
    case code of
        ExitSuccess -> putStrLn "successfully updated channels!"
        _ -> die $ T.pack "Could not update channels!"

buildHomePath :: Maybe Text -> IO Text
buildHomePath user = case user of
    Just u  -> return (T.concat [T.pack "users/", u, T.pack "/home.nix"])
    Nothing -> die $ T.pack "failed to find home manager config!"

homeManagerSwitch :: Turtle.FilePath -> IO ()
homeManagerSwitch nixcfg = do
    putStrLn $ "Getting your username to bootstrap your home manager."
    user <- getUser
    let u = user

    path <- buildHomePath u
    code <- case u of
        Just user -> proc (T.pack "home-manager") [ T.pack "switch"
                                                  , T.pack "-f"
                                                  , T.pack $ encodeString (nixcfg </> fromText path)
                                                  ] Turtle.empty
        _ -> die $ T.pack "Could not find USER in env!"

    case code of
        ExitSuccess -> putStrLn "successfully switched home manager!"
        _ -> die $ T.pack "failed to load home manager config!"
    

main :: IO ()
main = do
    putStrLn $ "Checking for adequate permissions."
    isRoot <- rootCheck
    when (isRoot) $ die $ T.pack "This program must not be run as root, exiting."
      

    putStrLn $ "Finding my configuration."
    cfgfolder <- nixConfigFolder
    let nixcfg = cfgfolder

    putStrLn $ "Installing system configuration for this host."
    code <-linkSystem nixcfg
    case code of
        ExitSuccess -> putStrLn "Global system installation successful!"
        _ -> die $ T.pack "Could not install global system config!"

    putStrLn $ "Checking if home manager is installed."
    hasHomeManager <- homeManagerCheck
    when (not hasHomeManager) $ installHomeManager
    putStrLn $ "Home manager is installed!"

    homeManagerSwitch nixcfg
    putStrLn $ "Done!"
    exit ExitSuccess
