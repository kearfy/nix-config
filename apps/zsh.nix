{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      lg = "lazygit";
      sr = "surreal sql --conn memory --user root --pass root --ns test --db test --pretty";
    };
  };

  programs.zsh.oh-my-zsh = {
    enable = true;
    plugins = [
      "git"
      "1password"
      "man"
      "autojump"
      "deno"
      "node"
      "npm"
      "rust"
      "ssh"
      "thefuck"
      "vscode"
      "direnv"
    ];
    theme = "robbyrussell";
  };
}
