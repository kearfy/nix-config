{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      lg = "lazygit";
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
    ];
    theme = "robbyrussell";
  };
}
