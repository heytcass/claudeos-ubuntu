{ lib, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_status"
        "$nix_shell"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      character = {
        success_symbol = "[❯](peach)";
        error_symbol = "[❯](red)";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "white";
        format = "[$path]($style) ";
      };

      git_branch = {
        symbol = " ";
        style = "peach";
        format = "[$symbol$branch]($style) ";
      };

      git_status = {
        style = "red";
        format = "([$all_status$ahead_behind]($style) )";
        conflicted = "= ";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "?\${count}";
        stashed = "*\${count}";
        modified = "!\${count}";
        staged = "[+\${count}](green)";
        renamed = "»\${count}";
        deleted = "✘\${count}";
      };

      nix_shell = {
        symbol = " ";
        format = "[$symbol$state]($style) ";
        style = "cyan";
        impure_msg = "impure";
        pure_msg = "pure";
      };

      cmd_duration = {
        min_time = 2000;
        format = "took [$duration]($style) ";
        style = "bright-black";
      };

      username = {
        show_always = false;
        format = "[$user]($style) ";
        style_user = "yellow";
        style_root = "bold red";
      };

      hostname = {
        ssh_only = true;
        format = "[@$hostname]($style) ";
        style = "yellow";
      };

      nodejs.disabled = true;
      python.disabled = true;
      rust.disabled = true;
      golang.disabled = true;
      java.disabled = true;
      ruby.disabled = true;
      php.disabled = true;
    };
  };
}
