{ pkgs, lib, ... }:

{
  programs.vscode = {
    enable = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        mkhl.direnv
        yzhang.markdown-all-in-one
        davidanson.vscode-markdownlint
        redhat.vscode-yaml
        # Claude extension: install manually from marketplace
      ];

      userSettings = {
        "editor.fontLigatures" = true;
        "editor.formatOnSave" = true;
        "editor.minimap.enabled" = false;
        "editor.renderWhitespace" = "selection";
        "editor.rulers" = [
          80
          120
        ];
        "files.autoSave" = "onFocusChange";
        "files.trimTrailingWhitespace" = true;
        "files.insertFinalNewline" = true;
        "workbench.startupEditor" = "none";
        "terminal.integrated.defaultProfile.linux" = "fish";
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.serverSettings" = {
          "nil" = {
            "formatting" = {
              "command" = [ "nixfmt" ];
            };
          };
        };
        "direnv.restart.automatic" = true;
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "telemetry.telemetryLevel" = "off";
        "[markdown]" = {
          "editor.wordWrap" = "on";
          "editor.quickSuggestions" = false;
        };
        "[yaml]" = {
          "editor.insertSpaces" = true;
          "editor.tabSize" = 2;
          "editor.autoIndent" = "advanced";
        };
        "yaml.schemas" = {
          "https://json.schemastore.org/github-workflow.json" = ".github/workflows/*.yaml";
        };
      };

      keybindings = [
        {
          key = "ctrl+shift+t";
          command = "workbench.action.terminal.new";
        }
      ];
    };
  };

  # Clean stale backup files before HM link phase
  home.activation.cleanVscodeBackups = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    for f in "$HOME/.config/Code/User/settings.json.backup" \
             "$HOME/.config/Code/User/keybindings.json.backup"; do
      [ -e "$f" ] && $DRY_RUN_CMD rm "$f"
    done
  '';

  # Make VSCode config files writable
  home.activation.mutableVscodeFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for f in "$HOME/.config/Code/User/settings.json" \
             "$HOME/.config/Code/User/keybindings.json"; do
      if [ -L "$f" ]; then
        target=$(readlink "$f")
        $DRY_RUN_CMD rm "$f"
        $DRY_RUN_CMD cp "$target" "$f"
        $DRY_RUN_CMD chmod u+w "$f"
      fi
    done
  '';
}
