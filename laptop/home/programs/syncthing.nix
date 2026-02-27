{pkgs, ...}:
{
    services.syncthing = {
      enable = true; # turn on syncthing
      #user = "angelo";               # run as your user
      # home = "/home/angelo";         # config location
      settings = {
        options = {
          urAccepted = -1; # dont share usage data
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
            devices = ["SM-A202F"];
            path = "/home/angelo/Joplin";
            type = "sendreceive";
            enable = true;
          };
        };
      };
    };
}