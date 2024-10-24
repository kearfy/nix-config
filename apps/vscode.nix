{pkgs, nix-vscode-extensions, ...}: {
    programs.vscode = {
        enable = true;
        package = pkgs.vscode;

        mutableExtensionsDir = false;
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;

        extensions = with nix-vscode-extensions.extensions.aarch64-darwin.vscode-marketplace; [
            # Nix
            bbenoist.nix
            jnoortheen.nix-ide

            # Language support
            surrealdb.surrealql
            ms-vscode.makefile-tools
            rust-lang.rust-analyzer
            dustypomerleau.rust-syntax
        ];

        userSettings = {
            
        };
    };
}