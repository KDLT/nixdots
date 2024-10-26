{lib, ...}:
# checking here if i really need the arguments line
{
  imports = [
    ./firefox
    ./obsidian
  ];

  # options = {
  #   kdlt = {
  #     graphical.applications = {
  #       firefox.enable = lib.mkEnableOption "Firefox";
  #       obsidian.enable = lib.mkEnableOption "Obsidian";
  #     };
  #   };
  # };

  # config = {};
}
