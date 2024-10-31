{ pkgs, nix-vscode-extensions, ... }:
{
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
      mkhl.direnv

      # Language support
      surrealdb.surrealql
      ms-vscode.makefile-tools
      rust-lang.rust-analyzer
      dustypomerleau.rust-syntax
      astro-build.astro-vscode
      biomejs.biome
      unifiedjs.vscode-mdx
      ms-vscode.vscode-typescript-next
      mrmlnc.vscode-scss
      bradlc.vscode-tailwindcss
      oven.bun-vscode
    ];

    userSettings = {
      extensions.autoCheckUpdates = false;
      update.mode = "none";

      git = {
        confirmSync = false;
        autoFetch = true;
      };

      editor = {
        cursorSmoothCaretAnimation = "on";
        smoothScrolling = true;
      };

      terminal.integrated.smoothScrolling = true;
    };
  };
}
