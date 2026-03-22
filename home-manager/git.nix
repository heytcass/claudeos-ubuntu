{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Tom Cassady";
        email = "heytcass@gmail.com";
      };
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        last = "log -1 HEAD";
        unstage = "reset HEAD --";
        amend = "commit --amend";
        graph = "log --graph --oneline --decorate --all";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
      color.ui = true;
      diff.algorithm = "histogram";
      merge.conflictstyle = "diff3";
      rebase.autoStash = true;
      rerere.enabled = true;
      fetch.prune = true;
      commit.verbose = true;
      core.autocrlf = "input";
      credential.helper = "!gh auth git-credential";
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519.pub";
      commit.gpgSign = true;
      tag.gpgSign = true;
    };
    lfs.enable = true;
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  programs.delta = {
    enable = true;
    options = {
      features = "line-numbers decorations";
      line-numbers = true;
      side-by-side = false;
      navigate = true;
      hyperlinks = true;
    };
  };
}
