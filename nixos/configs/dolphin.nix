{ pkgs, ... }: {

  environment.systemPackages = with pkgs.kdePackages; [
    dolphin
    dolphin-plugins
    kio-extras
    qtsvg
    plasma-integration 
    breeze-icons
    ffmpegthumbs
    kdegraphics-thumbnailers
    qtstyleplugin-kvantum
  ];
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "kde";
    QT_STYLE_OVERRIDE = "kvantum";
  };
}
