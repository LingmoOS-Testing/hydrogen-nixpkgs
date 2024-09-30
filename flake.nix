{ description = "A Nixpkgs Collection for LingmoOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    lingmo-nixpkgs.url = "github:LingmoOS/hydrogen-nixpkgs";

    };
  };

  outputs = { self, nixpkgs, ... }: {
    default = nixpkgs.system.buildLinux {
      system = "x86_64-linux";
      # 其他系统配置
      environment.systemPackages = with nixpkgs; [
        # 这里引用你之前定义的包
        liblingmo
        lingmo-core
        lingmo-calculator
        lingmo-cursor-theme
        lingmo-dock
        lingmo-filemanager
        lingmo-gtk-themes
        lingmo-kwin-plugins
        lingmo-launcher
        lingmo-qt-plugins
        lingmo-screenlocker
        lingmo-screenshots
        lingmo-sddm-theme
        lingmo-settings
        lingmo-statusbar
        lingmo-systemicons
        lingmo-terminal
        lingmo-texteditor
        lingmo-videoplayer
        lingmo-wallpapers
      ];
    };
  };
}
