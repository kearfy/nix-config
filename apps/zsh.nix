{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      lg = "lazygit";
      sr = "surreal sql --conn memory --user root --pass root --ns test --db test --pretty";
    };
    initExtraFirst = ''
      # Disable compfix to avoid the insecure directories warning
      ZSH_DISABLE_COMPFIX=true
    '';
    initExtra = ''
      CC=/opt/homebrew/Cellar/llvm/19.1.6/bin/clang
      AR=/opt/homebrew/Cellar/llvm/19.1.6/bin/llvm-ar
      PATH=/opt/homebrew/opt/llvm/bin:/Users/micha/.cargo/bin:$PATH
    '';
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
