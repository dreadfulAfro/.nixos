{ pkgs, ... }:
let
  common = with pkgs.vscode-extensions; [
    jnoortheen.nix-ide
    arrterian.nix-env-selector
    mkhl.direnv
    vscodevim.vim
  ];
in
{
  programs.vscode = {
    enable = true;
    #mutableExtensionsDir = true;

    profiles = {
      latex = {
        extensions =
          common
          ++ (with pkgs.vscode-extensions; [
            james-yu.latex-workshop
          ]);
      };
      cpp = {
        extensions =
          common
          ++ (with pkgs.vscode-extensions; [
            ms-vscode.cpptools
            #llvm-vs-code-extensions.vscode-clangd
          ]);
      };

      java = {
        extensions =
          common
          ++ (with pkgs.vscode-extensions; [
            vscjava.vscode-java-pack
            redhat.java
            vscjava.vscode-java-debug
            vscjava.vscode-java-test
            vscjava.vscode-maven
            vscjava.vscode-gradle
            vscjava.vscode-java-dependency
          ]);
      };

      rust = {
        extensions =
          common
          ++ (with pkgs.vscode-extensions; [
            rust-lang.rust-analyzer
          ]);
      };

      python = {
        extensions =
          common
          ++ (with pkgs.vscode-extensions; [
            ms-python.python
            ms-python.debugpy
          ]);
      };

      default = {
        extensions =
          common
          ++ (with pkgs.vscode-extensions; [
          ]);
        userSettings = {
          "window.autoDetectColorScheme" = true;
          "workbench.colorTheme" = "Default Dark Modern";
          "workbench.preferedLightColorTheme" = "Default Light Modern";
          "workbench.preferedDarkColorTheme" = "Default Dark Modern";
          "editor.formatOnSave" = true;
          "editor.tabSize" = 4;
          "editor.insertSpaces" = true;
        };
      };

    };
  };
}
