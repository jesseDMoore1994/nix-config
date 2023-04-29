{ config, pkgs, ... }:
{
  sops.defaultSopsFile = ../../secrets/example.yaml;
  # This will automatically import SSH keys as age keys
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  # This is using an age key that is expected to already be in the filesystem
  sops.age.keyFile = "/home/jmoore/.config/sops/age/keys.txt";
  # This will generate a new key if the key specified above does not exist
  #sops.age.generateKey = true;
  # This is the actual specification of the secrets.
  sops.secrets.pia-auth = { };
  sops.secrets.pia-auth.mode = "0440";
  sops.secrets.pia-auth.owner = config.users.users.jmoore.name;
  sops.secrets.pia-auth.group = "wheel";
  sops.secrets.pia-config = { };
  sops.secrets.pia-config.mode = "0440";
  sops.secrets.pia-config.owner = config.users.users.jmoore.name;
  sops.secrets.pia-config.group = "wheel";
  sops.secrets."cache-pub-key.pem" = { };
  sops.secrets."cache-pub-key.pem".mode = "0440";
  sops.secrets."cache-pub-key.pem".owner = config.users.users.root.name;
  sops.secrets."cache-pub-key.pem".group = "wheel";
  sops.secrets."cache-priv-key.pem" = { };
  sops.secrets."cache-priv-key.pem".mode = "0440";
  sops.secrets."cache-priv-key.pem".owner = config.users.users.root.name;
  sops.secrets."cache-priv-key.pem".group = "wheel";
}
