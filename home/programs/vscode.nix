{}:
{
    programs.vscode = {
          enable = true;
          #package = pkgs.vscodium;
          profiles.default.extensions = with pkgs.vscode-extensions; [
            vscodevim.vim
            yzhang.markdown-all-in-one
            ms-vscode.cpptools-extension-pack
            ms-python.python
            #kevinrose.vsc-python-indent
            ms-python.debugpy
            bbenoist.nix
          ];
        };
}