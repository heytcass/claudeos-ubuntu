{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    shellAliases = {
      cat = "bat --style=auto";
      man = "batman";
      gs = "git status";
      gd = "git diff";
      gl = "git log --oneline --graph --decorate";
      gp = "git pull";
      ".." = "cd ..";
      "..." = "cd ../..";
      zc = "z ~/Projects/claudeos";
    };

    shellAbbrs = {
      gco = "git checkout";
      gci = "git commit";
      gca = "git commit --amend";
      gaa = "git add --all";
      gcm = "git checkout main";
      nfmt = "nix fmt";
      ndev = "nix develop";
      nbuild = "nix build";
      nrun = "nix run";
      nshell = "nix shell";
      nrepl = "nix repl";
      nupdate = "nix flake update";
      sctl = "systemctl";
      jctl = "journalctl";
    };

    functions = {
      starship_transient_prompt_func = "starship module character";

      mkcd = "mkdir -p $argv[1]; and cd $argv[1]";
      extract = "ouch decompress $argv";
      gcam = "git commit -am $argv";
      findbig = "du -sh * | sort -h | tail -20";

      # Claude-powered shell commands
      fix = ''
                set -l cmd $history[1]
                if test -z "$cmd"
                  echo "No previous command in history."
                  return 1
                end
                set_color --dim
                echo "Asking Claude about: $cmd"
                set_color normal
                set -l suggestion (claude -p "This Fish shell command on Ubuntu failed: $cmd
        Give me ONLY the corrected command. No explanation, no markdown, no code fences. Just the single command." --model haiku 2>/dev/null)
                if test -z "$suggestion"
                  echo "No suggestion available."
                  return 1
                end
                echo ""
                set_color green
                echo "  $suggestion"
                set_color normal
                echo ""
                read -P "Run? [y/N] " -l confirm
                if string match -qi y $confirm
                  eval $suggestion
                end
      '';

      explain = ''
                if not isatty stdin
                  set -l input (cat)
                  claude -p "Explain this command output concisely. Be brief and focus on what matters:
        $input" --model haiku 2>/dev/null
                else if test (count $argv) -gt 0
                  claude -p "Explain this concisely: $argv" --model haiku 2>/dev/null
                else
                  set -l cmd $history[1]
                  if test -z "$cmd"
                    echo "No previous command in history."
                    return 1
                  end
                  claude -p "Explain what this shell command does concisely: $cmd" --model haiku 2>/dev/null
                end
      '';

      ask = ''
        if test (count $argv) -eq 0
          echo "Usage: ask <question>"
          return 1
        end
        claude -p "$argv" --model haiku 2>/dev/null
      '';
    };

    plugins = [
      {
        name = "fzf.fish";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "v10.3";
          sha256 = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
        };
      }
      {
        name = "puffer-fish";
        src = pkgs.fetchFromGitHub {
          owner = "nickeb96";
          repo = "puffer-fish";
          rev = "12d062eae0d49f5f6d75a23cb6d1f4e410d24242";
          sha256 = "sha256-2niYj0NLfmVIQguuGTA7RrPIcorJEPkxhH6Dhcy+6Bk=";
        };
      }
    ];

    interactiveShellInit = ''
      set fish_greeting

      # Add ~/.local/bin to PATH for Claude Code CLI and other native installers
      fish_add_path ~/.local/bin

      # Export GitHub token for MCP server + Claude Code plugins
      if command -q gh
        set -gx GITHUB_PERSONAL_ACCESS_TOKEN (gh auth token 2>/dev/null)
      end

      # System fetch on first shell
      if not set -q MACCHINA_SHOWN
        set -gx MACCHINA_SHOWN 1
        if command -q macchina
          macchina
        end
      end
    '';
  };
}
