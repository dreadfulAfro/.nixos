{pkgs, ...}:
{
    programs.joplin-desktop = {
      enable = true;
      extraConfig = {
        "sync.interval" = 300; # sync every 5m
        "sync.target" = 2; # 2=filesystem
        "sync.2.path" = "/home/angelo/Joplin";
        "spellchecker.enabled" = true;
      };
    };
}