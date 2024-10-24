{pkgs, ...}: {
    programs.zsh = {
        enable = true;
        shellAliases = {
            ll = "ls -l";
            lg = "lazygit";
        };
    };
}