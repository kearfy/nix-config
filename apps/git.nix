{pkgs, ...}: {
    programs.git = {
        enable = true;
        userName = "Micha de Vries";
        userEmail = "micha@devrie.sh";
        extraConfig = {
            pull.rebase = true;
            init.defaultBranch = "main";

            user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICbopZzjJo93/8gCABVMZLwjO0OeqyusYiB+tbPIS5Gx";
            gpg.format = "ssh";
            gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
            commit.gpgsign = true;
        };
    };
}