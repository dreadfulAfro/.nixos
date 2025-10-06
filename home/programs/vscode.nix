{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    #package = pkgs.vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      vscodevim.vim
      yzhang.markdown-all-in-one
      ms-vscode.cpptools-extension-pack
      ms-python.python
      ms-python.debugpy
    ];
  };
}
