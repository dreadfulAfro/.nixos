{ config, pkgs, ... }:

{
    home = {
        username = "angelo";
        homeDirectory = "/home/angelo";
        stateVersion = "25.05";

        packages = with pkgs; [
            btop
            dconf2nix
            tor-browser
        ];
    };


    programs = {
        gnome-shell = {
          enable = true;
          extensions = [{ package = pkgs.gnomeExtensions.gsconnect; }];
        };
        fish.enable = true;
        git = {
            enable = true;
            userEmail = "lukasangelo18@gmail.com";
            userName = "Lukas-Angelo Meier";
        };
        vscode = {
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
        joplin-desktop = {
          enable = true;
          extraConfig = {
            "sync.interval" = 300;  # sync every 5m
            "sync.target" = 2;  # 2=filesystem
            "sync.2.path" = "/home/angelo/Joplin";
            "spellchecker.enabled" = true;
          };
        };
    };

    services = {
        # For Virtualization and rdp
        remmina.enable = true;
        syncthing = {
            enable = true;                 # turn on syncthing
            #user = "angelo";               # run as your user
            # home = "/home/angelo";         # config location
            settings = {
                options = {
                    urAccepted = -1;  # dont share usage data
                    #relaysEnabled = true;
                    #localAnnounceEnabled = true;
                };
                devices = {
                    "SM-A202F" = {
                        id = "4R66KYU-GUZDHAT-HHH67JE-LJEECSR-GHQA3LW-4PYI7Z4-NTJUQB4-WQJRJA2";
                        name = "SM-A202F";
                    };
                };
                folders = {
                    "/home/angelo/Joplin" = {
                        id = "cyzeu-xl7em";
                        devices = [ "SM-A202F" ];
                        path = "/home/angelo/Joplin";
                        type = "sendreceive";
                        enable = true;
                    };
                };
            };
        };
    };
}
