{ pkgs, config, ... }:
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
      alias ncas = do {nc; ./scripts/apply_system.hs; cd -};
      alias ncau = do {nc; ./scripts/apply_user.hs; cd -};
      alias ncu = do {nc; ./scripts/update.hs; cd -};
      alias work = ssh jmoore@jmoore-arch.adtran.com;

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

      cat /run/secrets/atticd.root | lines | str trim | str replace -a "\"" "" | split column "=" | let-env $in.column1.0 = $in.column2.0
      attic login asmodeus http://asmodeus:8080 $env.ATTIC_ROOT_TOKEN out+err> /dev/null
      attic use jmoore out+err> /dev/null

      let-env STARSHIP_SHELL = "nu"
      let-env STARSHIP_SESSION_KEY = (random chars -l 16)
      let-env PROMPT_MULTILINE_INDICATOR = (^/home/jmoore/.nix-profile/bin/starship prompt --continuation)

      # Does not play well with default character module.
      # TODO: Also Use starship vi mode indicators?
      let-env PROMPT_INDICATOR = ""

      let-env PROMPT_COMMAND = { ||
          # jobs are not supported
          let width = (term size).columns
          ^${pkgs.starship}/bin/starship prompt $"--cmd-duration=($env.CMD_DURATION_MS)" $"--status=($env.LAST_EXIT_CODE)" $"--terminal-width=($width)"
      }

      # Whether we have config items
      let has_config_items = (not ($env | get -i config | is-empty))

      let-env config = if $has_config_items {
          $env.config | upsert render_right_prompt_on_last_line true
      } else {
          {render_right_prompt_on_last_line: true}
      }

      let-env PROMPT_COMMAND_RIGHT = { ||
          let width = (term size).columns
          ^${pkgs.starship}/bin/starship prompt --right $"--cmd-duration=($env.CMD_DURATION_MS)" $"--status=($env.LAST_EXIT_CODE)" $"--terminal-width=($width)"
      }
    '';
  };
}
