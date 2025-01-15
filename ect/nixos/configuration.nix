# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Enable Flakes.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "ntfs" ];


  ##############################################
  # Locale:
  ##############################################

  # Set your time zone.
  time.timeZone = "America/Winnipeg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";



  ##############################################
  # File System:
  ##############################################

  # let automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,credentials=~/.config/smb-secrets";


  #fileSystems."/home/zeus/MAX/Data" = {
  #  device = "//192.168.10.216/DATA";
  #  fsType = "cifs";
  #  options = [ "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,credentials=/home/zeus/.config/smb-secrets" ];
  #};

  fileSystems."/home/zeus/MAX/Media" = {
    device = "//192.168.10.216/MEDIA";
    fsType = "auto";
    options = [ "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,credentials=/home/zeus/.config/smb-secrets,uid=1000,gid=0" ];
  };

    fileSystems."/home/zeus/MAX/Data" = {
    device = "//192.168.10.216/DATA";
    fsType = "auto";
    options = [ "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,credentials=/home/zeus/.config/smb-secrets,uid=1000,gid=0" ];
  };

  fileSystems."/home/zeus/Storage" = {
    device = "/dev/disk/by-uuid/7EC4B1FBC4B1B62D";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000"];

  };

  ##############################################
  # Networking and Firewall:
  ##############################################

  networking.hostName = "Oedipu_NixOS"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Samba discovery.
  networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  ##############################################
  # Graphics:
  ##############################################


  # Enable the X11 windowing system.
  # This can be disable if you're using ONLY Wayland sessions.
  services.xserver.enable = true;

  # Enable openGL acceleration.
  hardware.graphics = {
    enable = true;
  };

  # Enable discrete GPU driver(s).

  services.xserver.videoDrivers = ["nvidia"]; # Enable the NVIDIA driver.
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false; # Enable/Disable the open-source kernel module.
    nvidiaSettings = true;
  };
  #services.xserver.videoDrivers = ["amdgpu"]; # Enable the AMDGPU driver.
  #services.xserver.videoDrivers = ["intel"]; # Enable the Intel driver.


  # Hybrid Graphics. Make sure to use the correct Bus ID values for your system!
  #hardware.nvidia.prime = {
    #offload = {
      #enable = true;
      #enableOffloadCmd = true;
    #};

    #intelBusId = "PCI:0:2:0";
    #nvidiaBusId = "PCI:1:0:0";
    ##amdgpuBusId = "PCI:54:0:0"; For AMD GPU
  #};


  ##############################################
  # Audio, printing, HID:
  ##############################################

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable font pakages

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      nerdfonts
      font-awesome
      fira-code-nerdfont
      roboto
      #noto-fonts
      #noto-fonts-cjk
      #noto-fonts-emoji
      #liberation_ttf
      fira-code
      fira-code-symbols
      #mplus-outline-fonts.githubRelease
      #dina-font
      #proggyfonts
    ];
  };

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManagers).
  # services.xserver.libinput.enable = true;


  ##############################################
  # Desktop Environment:
  ##############################################

  # Enable SDDM Display Manager
  services.displayManager.sddm.enable = true;

  # Required for Wayland compositor:
  services.displayManager.sddm.wayland.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;

  programs.hyprland.enable = true;
  # Optional, hint electron apps to use wayland:
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable remote desktop.
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startplasma-x11";
  services.xrdp.openFirewall = true;




  ########################################
  # Home-Manager:
  ########################################

  home-manager.users.zeus = { pkgs, ... }: {
    home.packages = [ pkgs.atool pkgs.httpie ];
    programs.bash.enable = true;



    home.stateVersion = "24.11";
  };



  ########################################
  # Users:
  ########################################

  # Define the admin user account. Don't forget to set a password with ‘passwd’.
  users.users.zeus = {
    isNormalUser = true;
    description = "Father of the gods";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate # Kate text editor.
      remmina # Remote desktop client
      neofetch # Displays device information in the CLI.
      curl
      lshw
      pciutils
      freecad-wayland
      librewolf
    ];
  };

 # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = false;
  services.displayManager.autoLogin.user = "zeus";


  ########################################
  # System Packages:
  ########################################

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Packages installed to the system profile.
  environment.systemPackages = with pkgs;[
    git
    killall
    samba
    cifs-utils
    kdePackages.kdenetwork-filesharing
    inotify-tools
    brightnessctl
    home-manager
    popcorntime
    firefox # FireFox Browser.
    brave # Brave browser.
    #gimp # GIMP image editor.
    flatpak  # Flatpak.
    #heroic # Heroic Games Launcher.
    #lutris # Lutris game manager.
    #protonup
    #protonplus
    #protontricks
    #mangohud
    #gamemode
    #bottles
    #bottles-unwrapped
    zerotierone # P2P self managed SDLAN/VPN
    input-remapper # Enable Input-Remmapper for mapping keys on HIDs.
    spacedrive # NAS type file manager for local files.
    polonium # Tiling support similar to Hyprland, for KDE Plama.
    waydroid # Android virtual machine, supports running android apps in Linux.

    ## Hyprland pkgs ##
    #nwg-hello  # greeter DM to later replace SDDM
    xdg-desktop-portal-hyprland
    bun
    waybar
    rofi-wayland
    # pywald
    kitty
    dunst
    libsForQt5.qt5.qtwayland
    kdePackages.qtwayland
    hyprpaper
    hyprlock
    vim
    vimPlugins.vim-cpp-enhanced-highlight
    python3Full
    python312Packages.pip
    fastfetch
    wlogout
    gtk4
    wpaperd
    hyprpolkitagent
    wofi
    wofi-pass
    nwg-drawer
    nwg-displays
    nwg-panel
    nwg-bar
    htop
    networkmanager_dmenu
    networkmanagerapplet
    font-awesome
    fira-code-nerdfont
    roboto

  ];

  # Install Steam.
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  ##############################################
  # Optional services you might want to enable:
  ##############################################

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable browsing of SMB shares.
  services.gvfs.enable = true;

  # Input-mapper.
  services.input-remapper.enable = true;

  # Enable Flatpak.
  services.flatpak.enable = true;

  services.samba.enable = true;

  # Enable ZeroTier One.
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "60ee7c034aa9b2be"
    ];
  };

  # Enable Waydroid container service.
  virtualisation.waydroid.enable = true;


  ##############################################
  # System version:
  ##############################################

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}

