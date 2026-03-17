{ config, pkgs, ... }:
{
  programs.dconf.enable = true;
  users.users.gcis.extraGroups = [ "libvirtd", "kvm" ];
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    gnome.adwaita-icon-theme
  ];
  virtualization = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
}
