script_dir: { pkgs, config, ... }:
{
  programs.nushell = {
    enable = true;
    extraConfig = ''
      alias ga = git add
      alias gc = git commit
      alias gd = git diff
      alias gf = git fetch
      alias gpl = git pull
      alias gph = git push
      alias gs = git status
      alias gl = git log
      alias icat = kitty +kitten icat;
      alias nb = nix build;
      alias nbl = nix build -L;
      alias nc = cd $"($env.HOME)/projects/nix-config";
      alias ncas = do {nc; ${script_dir}/apply_system.hs; cd -};
      alias ncau = do {nc; ${script_dir}/apply_user.hs; cd -};
      alias ncu = do {nc; ${script_dir}/update.hs; cd -};
      alias work = ssh jmoore@jmoore-nixos.adtran.com;

      let-env config = {
        show_banner: false
        completions: {
          case_sensitive: false # set to true to enable case-sensitive completions
          quick: true  # set this to false to prevent auto-selecting completions when only one remains
          partial: true  # set this to false to prevent partial filling of the prompt
          algorithm: "fuzzy"  # prefix or fuzzy
          external: {
            enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up my be very slow
            max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
            completer: null # check 'carapace_completer' above as an example
          }
        }
        edit_mode: vi
        keybindings: [
          {
            name: completion_menu
            modifier: none
            keycode: tab
            mode: [emacs vi_normal vi_insert]
            event: {
              until: [
                { send: menu name: completion_menu }
                { send: menunext }
              ]
            }
          }
          {
            name: completion_previous
            modifier: shift
            keycode: backtab
            mode: [emacs, vi_normal, vi_insert] # Note: You can add the same keybinding to all modes by using a list
            event: { send: menuprevious }
          }
          {
            name: reload_config
            modifier: control
            keycode: char_r
            mode: [ emacs vi_insert vi_normal ]
            event: [
               { edit: clear }
               {
                  edit: insertString
                  value: $"source ($nu.env-path); source ($nu.config-path)"
               }
               { send: Enter }
            ]
          }
          {
            name: history_menu
            modifier: control
            keycode: char_h
            mode: [vi_insert vi_normal]
            event: {
              until: [
                { send: menu name: history_menu }
                { send: menupagenext }
              ]
            }
          }
        ]
      }
    '';
  };
}
