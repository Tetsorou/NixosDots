{
  inputs,
  pkgs,
  username,
  terminal,
  ...
}: let
in {
  imports = [
    
    ../../themes/Catppuccin # Catppuccin GTK and QT themes
    ./programs/waybar
    ./programs/wlogout
    ./programs/rofi
    ./programs/dunst
    ./programs/swaylock
    ./programs/swaync
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  home-manager.users.${username} = {...}: {
    imports = [
      inputs.hyprland.homeManagerModules.default
    ];

    home.packages = with pkgs; [
       blueman
      cliphist
      grimblast
      libnotify
      light
      networkmanagerapplet
      pamixer
      pavucontrol
      playerctl
      slurp
      swappy
      swww
      swaynotificationcenter
      waybar
      wlsunset
      wtype
      wl-clipboard
    ];
    #useGlobalPkgs = true;
     #useUserPackages = true;
    xdg.configFile."hypr/scripts" = {
      source = ./scripts;
      recursive = true;
    };
    xdg.configFile."hypr/icons" = {
      source = ./icons;
      recursive = true;
    };

    #test later systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      plugins = [
        # inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
        # inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
        inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
      ];
      systemd = {
        enable = true;
        variables = ["--all"];
      };
      settings = {
        "$scriptsDir" = "XDG_BIN_HOME";
        "$hyprScriptsDir" = "$XDG_CONFIG_HOME/hypr/scripts";
        "$mainMod" = "SUPER";
        # "$launcher" = "pkill rofi || rofi -show drun -modi drun,filebrowser,run,window -theme $XDG_CONFIG_HOME/rofi/launchers/type-2/style-2.rasi";
        "$launcher" = "pkill rofi || rofi -show drun -modi drun,filebrowser,run,window -theme $XDG_CONFIG_HOME/rofi/launchers/type-4/style-3.rasi";
        "$term" = "${pkgs.${terminal}}/bin/${terminal}";
        "$editor" = "code --disable-gpu";
        "$file" = "$term -e lf";
        "$browser" = "firefox";

        env = [
          # "XCURSOR_SIZE,16"

          # WLR
          "WLR_NO_HARDWARE_CURSORS,1"
          "WLR_RENDERER_ALLOW_SOFTWARE,1"

          # XDG Specifications
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"

          # Use wayland by default
          "GDK_BACKEND=wayland,x11,*"
          "QT_QPA_PLATFORM,wayland;xcb"
          "NIXOS_OZONE_WL,1"
          "MOZ_ENABLE_WAYLAND,1"
          "SDL_VIDEODRIVER,wayland"
          "OZONE_PLATFORM,wayland"
          "CLUTTER_BACKEND,wayland"

          # Qt settings
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "QT_QPA_PLATFORMTHEME,qt6ct"
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        ];
        exec-once = [
          "pamixer --set-volume 40"
        #  "[workspace 1 silent] firefox"
          #"[workspace 2 silent] alacritty"
          #"[workspace 5 silent] spotify"
          #"[workspace special silent] firefox --new-instance -P private"
          #"[workspace special silent] alacritty"
          #"[workspace 8 silent] alacritty -e cava"
          #"[workspace 9 silent] alacritty -e cava"

          "$hyprScriptsDir/wallpaper.sh"
          "waybar &"
          "swaync &"
          # "dunst"
          # "blueman-applet"
          "nm-applet --indicator"
          "wl-clipboard-history -t"
          "wl-paste --type text --watch cliphist store" # clipboard store text data
          "wl-paste --type image --watch cliphist store" # clipboard store image data
          "rm '$XDG_CACHE_HOME/cliphist/db'" # Clear clipboard
          "$hyprScriptsDir/batterynotify.sh" # battery notification
          "polkit-agent-helper-1"
          #"systemctl start --user polkit-kde-authentication-agent-1"
        ];
        input = {
          kb_layout = "us";
         # kb_variant = "qwerty";
          repeat_delay = 212;
          repeat_rate = 30;

          follow_mouse = 1;

          touchpad = {natural_scroll = false;};

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
          force_no_accel = true;
        };
        general = {
          gaps_in = 4;
          gaps_out = 9;
          border_size = 2;
          "col.active_border" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
          "col.inactive_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
          resize_on_border = true;
          layout = "master"; # dwindle or master
          # allow_tearing = true; # Allow tearing for games (use immediate window rules for specific games or all titles)
        };
        decoration = {
          rounding = 10;
          drop_shadow = false;
          dim_special = 0.3;
          blur = {
            enabled = true;
            special = true;
            size = 6;
            passes = 3;
            new_optimizations = true;
            ignore_opacity = true;
            xray = false;
          };
        };
        group = {
          "col.border_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
          "col.border_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
          "col.border_locked_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
          "col.border_locked_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
        };
        animations = {
          enabled = true;
          bezier = [
            "linear, 0, 0, 1, 1"
            "md3_standard, 0.2, 0, 0, 1"
            "md3_decel, 0.05, 0.7, 0.1, 1"
            "md3_accel, 0.3, 0, 0.8, 0.15"
            "overshot, 0.05, 0.9, 0.1, 1.1"
            "crazyshot, 0.1, 1.5, 0.76, 0.92"
            "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
            "fluent_decel, 0.1, 1, 0, 1"
            "easeInOutCirc, 0.85, 0, 0.15, 1"
            "easeOutCirc, 0, 0.55, 0.45, 1"
            "easeOutExpo, 0.16, 1, 0.3, 1"
          ];
          animation = [
            "windows, 1, 3, md3_decel, popin 60%"
            "border, 1, 10, default"
            "fade, 1, 2.5, md3_decel"
            # "workspaces, 1, 3.5, md3_decel, slide"
            "workspaces, 1, 3.5, easeOutExpo, slide"
            # "workspaces, 1, 7, fluent_decel, slidefade 15%"
            # "specialWorkspace, 1, 3, md3_decel, slidefadevert 15%"
            "specialWorkspace, 1, 3, md3_decel, slidevert"
          ];
        };
        misc = {
          disable_hyprland_logo = true;
          mouse_move_focuses_monitor = true;
          vfr = true; # always keep on
          vrr = true; # enable variable refresh rate (effective depending on hardware)
          no_direct_scanout = false; # Set to false for improved Fullscreen performance.
        };
        gestures = {
          workspace_swipe = true;
          workspace_swipe_fingers = 3;
        };
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };
        master = {
          new_is_master = true;
          new_on_top = true;
          mfact = 0.5;
        };
        windowrulev2 = [
          #"noanim, class:^(Rofi)$
          "opacity 0.80 0.80,class:^(alacritty)$"
          "tile,title:(.*)(Godot)(.*)$"
           "workspace 1, class:^(firefox)$"
          "workspace 1, class:^(brave)$"
          #"workspace 2, class:^(Alacritty)$" 
          "workspace 2, class:^(kitty)$"
          "workspace 3, class:^(VSCodium)$"
          "workspace 3, class:^(codium-url-handler)$"
          "workspace 3, class:^(Code)$"
          "workspace 3, class:^(code-url-handler)$"
          "workspace 4, class:^(krita)$"
          "workspace 4, title:(.*)(Godot)(.*)$"
          "workspace 4, title:(GNU Image Manipulation Program)(.*)$"
          "workspace 5, class:^(Spotify)$"
          "workspace 5, title:(.*)(Spotify)(.*)$"
          "workspace 7, class:^(steam)$"
          # "workspace 10, class:^(factorio)$"

          # Allow screen tearing for reduced input latency on some games.
          #"immediate, class:^(cs2)$"
          #"immediate, class:^(steam_app_0)$"
          #"immediate, class:^(steam_app_1)$"
          #"immediate, class:^(steam_app_2)$"
          #"immediate, class:^(.*)(.exe)$"

          "opacity 1.00 1.00,class:^(firefox)$"
          "opacity 0.90 0.90,class:^(brave)$"
          "opacity 0.80 0.80,class:^(Steam)$"
          "opacity 0.80 0.80,class:^(steam)$"
          "opacity 0.80 0.80,class:^(steamwebhelper)$"
          "opacity 0.80 0.80,class:^(Spotify)$"
          "opacity 0.80 0.80,title:(.*)(Spotify)(.*)$"
          # "opacity 0.80 0.80,class:^(VSCodium)$"
          # "opacity 0.80 0.80,class:^(codium-url-handler)$"
          "opacity 0.80 0.80,class:^(Code)$"
          "opacity 0.80 0.80,class:^(code-url-handler)$"
          "opacity 0.80 0.80,class:^(kitty)$"
          "opacity 0.80 0.80,class:^(org.kde.dolphin)$"
          "opacity 0.80 0.80,class:^(org.kde.ark)$"
          "opacity 0.80 0.80,class:^(nwg-look)$"
          "opacity 0.80 0.80,class:^(qt5ct)$"

          "opacity 0.90 0.90,class:^(com.github.rafostar.Clapper)$" #Clapper-Gtk
          "opacity 0.80 0.80,class:^(com.github.tchx84.Flatseal)$" #Flatseal-Gtk
          "opacity 0.80 0.80,class:^(hu.kramo.Cartridges)$" #Cartridges-Gtk
          "opacity 0.80 0.80,class:^(com.obsproject.Studio)$" #Obs-Qt
          "opacity 0.80 0.80,class:^(gnome-boxes)$" #Boxes-Gtk
          "opacity 0.80 0.80,class:^(discord)$" #Discord-Electron
          "opacity 0.80 0.80,class:^(WebCord)$" #WebCord-Electron
          "opacity 0.80 0.80,class:^(app.drey.Warp)$" #Warp-Gtk
          "opacity 0.80 0.80,class:^(net.davidotek.pupgui2)$" #ProtonUp-Qt
          "opacity 0.80 0.80,class:^(yad)$" #Protontricks-Gtk
          "opacity 0.80 0.80,class:^(Signal)$" #Signal-Gtk
          "opacity 0.80 0.80,class:^(io.gitlab.theevilskeleton.Upscaler)$" #Upscaler-Gtk

          "opacity 0.80 0.70,class:^(pavucontrol)$"
          "opacity 0.80 0.70,class:^(blueman-manager)$"
          "opacity 0.80 0.70,class:^(nm-applet)$"
          "opacity 0.80 0.70,class:^(nm-connection-editor)$"
          "opacity 0.80 0.70,class:^(org.kde.polkit-kde-authentication-agent-1)$"
          "opacity 0.80 0.70,class:^(jetbrains-clion)$"
          "opacity 0.80 0.70,class:^(jetbrains-pycharm)$"
          "opacity 0.80 0.70,class:^(jetbrains-writerside)$"
          "opacity 0.80 0.70,class:^(jetbrains-idea)$"
          "opacity 0.50 0.30,class:^(jetbrains-toolbox)$"
          "opacity 0.80 0.70,class:^(exercism)$ "
          "float,class:^(qt5ct)$"
          "float,class:^(nwg-look)$"
          "float,class:^(org.kde.ark)$"
          "float,class:^(Signal)$" #Signal-Gtk
          "float,class:^(com.github.rafostar.Clapper)$" #Clapper-Gtk
          "float,class:^(app.drey.Warp)$" #Warp-Gtk
          "float,class:^(net.davidotek.pupgui2)$" #ProtonUp-Qt
          "float,class:^(yad)$" #Protontricks-Gtk
          "float,class:^(eog)$" #Imageviewer-Gtk
          "float,class:^(io.gitlab.theevilskeleton.Upscaler)$" #Upscaler-Gtk
          "float,class:^(pavucontrol)$"
          "float,class:^(blueman-manager)$"
          "float,class:^(nm-applet)$"
          "float,class:^(nm-connection-editor)$"
          "float,class:^(org.kde.polkit-kde-authentication-agent-1)$"
        ];
        binde = [
          # Resize windows
          "$mainMod SHIFT, right, resizeactive, 30 0"
          "$mainMod SHIFT, left, resizeactive, -30 0"
          "$mainMod SHIFT, up, resizeactive, 0 -30"
          "$mainMod SHIFT, down, resizeactive, 0 30"

          # Resize windows with hjkl keys
          "$mainMod SHIFT, l, resizeactive, 30 0"
          "$mainMod SHIFT, h, resizeactive, -30 0"
          "$mainMod SHIFT, k, resizeactive, 0 -30"
          "$mainMod SHIFT, j, resizeactive, 0 30"
        ];
        bind =
          [
            # Night Mode (lower value means warmer temp)
            "$mainMod, F9, exec, wlsunset -t 3000 -T 3900"
            "$mainMod, F10, exec, pkill wlsunset"

            # Overview plugin
            # "$mainMod, tab, overview:toggle"

            # Window/Session actions
            "$mainMod, Q, exec, $hyprScriptsDir/dontkillsteam.sh" # killactive, kill the window on focus
            "ALT, F4, exec, $hyprScriptsDir/dontkillsteam.sh" # killactive, kill the window on focus
            "$mainMod, delete, exit" # kill hyperland session
            "$mainMod, W, togglefloating" # toggle the window on focus to float
            "$mainMod SHIFT, G, togglegroup" # toggle the window on focus to float
            "ALT, return, fullscreen" # toggle the window on focus to fullscreen
            #"$mainMod ALT, L, exec, swaylock" # lock screen
            "$mainMod, backspace, exec, wlogout -b 4" # logout menu
            "$CONTROL, ESCAPE, exec, killall waybar || waybar" # toggle waybar

            "$mainMod, Return, exec, $term"
            "$mainMod, T, exec, $term"
            "$mainMod, E, exec, $file"
            "$mainMod, C, exec, $editor"
            "$mainMod, F, exec, $browser"
            "$CONTROL ALT, DELETE, exec, $term -e '${pkgs.btop}/bin/btop2'"

            "$mainMod, A, exec, pkill -x rofi || $launcher" # launch desktop applications
            "$mainMod, Z, exec, pkill -x rofi || $hyprScriptsDir/emoji.sh" # launch emoji picker
            "$mainMod, tab, exec, pkill -x rofi || $hyprScriptsDir/rofilaunch.sh w" # switch between desktop applications
            # "$mainMod, R, exec, pkill -x rofi || $hyprScriptsDir/rofilaunch.sh f" # browse system files
            "$mainMod SHIFT, W, exec, $hyprScriptsDir/WallpaperSelect.sh" # Select wallpaper to apply
           #"$mainMod ALT, K, exec, $hyprScriptsDir/keyboardswitch.sh" # change keyboard layout
            "$mainMod SHIFT, N, exec, swaync-client -t -sw" # swayNC panel
            "$mainMod, G, exec, $hyprScriptsDir/gamelauncher.sh" # game launcher
            "$mainMod ALT, G, exec, $hyprScriptsDir/gamemode.sh" # disable hypr effects for gamemode
            #"$mainMod, V, exec, $hyprScriptsDir/ClipManager.sh" # Clipboard Manager
            "$mainMod SHIFT, M, exec, $hyprScriptsDir/rofimusic.sh" # online music

            # Waybar
            "$mainMod, B, exec, killall -SIGUSR1 waybar" # Toggle hide/show waybar
            "$mainMod CTRL, B, exec, $hyprScriptsDir/WaybarStyles.sh" # Waybar Styles Menu
            "$mainMod ALT, B, exec, $hyprScriptsDir/WaybarLayout.sh" # Waybar Layout Menu

            # Screenshot/Screencapture
            "$mainMod, P, exec, $hyprScriptsDir/screenshot.sh s" # drag to snip an area / click on a window to print it
            "$mainMod CTRL, P, exec, $hyprScriptsDir/screenshot.sh sf" # frozen screen, drag to snip an area / click on a window to print it
            ",print, exec, $hyprScriptsDir/screenshot.sh m" # print focused monitor
            "$mainMod ALT, P, exec, $hyprScriptsDir/screenshot.sh p" # print all monitor outputs

            # Functional keybinds
          #  ",xf86Sleep, exec, systemctl suspend"
            ",XF86AudioMicMute,exec,pamixer --default-source -t"
            ",XF86MonBrightnessDown,exec,brightnessctl set 20- --min-value 10"
            ",XF86MonBrightnessUp,exec,brightnessctl set +20"
            ",XF86AudioMute,exec,pamixer -t"
            ",XF86AudioLowerVolume,exec,pamixer -d 5"
            ",XF86AudioRaiseVolume,exec,pamixer -i 5"
            ",XF86AudioPlay,exec,playerctl play-pause"
            ",XF86AudioPause,exec,playerctl play-pause"
            ",xf86AudioNext,exec,playerctl next"
            ",xf86AudioPrev,exec,playerctl previous"
            # ",xf86AudioNext,exec,$hyprScriptsDir/MediaCtrl.sh --nxt"
            # ",xf86AudioPrev,exec,$hyprScriptsDir/MediaCtrl.sh --prv"

            # to switch between windows in a floating workspace
            # "SUPER,Tab,cyclenext,
            # "SUPER,Tab,bringactivetotop,

            # Switch workspaces with mainMod  [0-9]
            
            #"$mainMod, 1, workspace, 1"
            #"$mainMod, 2, workspace, 2"
            #"$mainMod, 3, workspace, 3"
            #"$mainMod, 4, workspace, 4"
            #"$mainMod, 5, workspace, 5"
            #"$mainMod, 6, workspace, 6"
            #"$mainMod, 7, workspace, 7"
            #"$mainMod, 8, workspace, 8"
            #"$mainMod, 9, workspace, 9"
            #"$mainMod, 0, workspace, 10"
            

            # Switch workspaces relative to the active workspace with mainMod + CTRL + [←→]
            "$mainMod CTRL, right, split-workspace, r+1"
            "$mainMod CTRL, left, split-workspace, r-1"

            # move to the first empty workspace instantly with mainMod + CTRL + [↓]
            "$mainMod CTRL, down, split-workspace, empty"

            # Move focus with mainMod + arrow keys
            "$mainMod, left, movefocus, l"
            "$mainMod, right, movefocus, r"
            "$mainMod, up, movefocus, u"
            "$mainMod, down, movefocus, d"
            "ALT, Tab, movefocus, d"

            # Move focus with mainMod + HJKL keys
            "$mainMod, h, movefocus, l"
            "$mainMod, l, movefocus, r"
            "$mainMod, k, movefocus, u"
            "$mainMod, j, movefocus, d"

            # Go to workspace 5 (Spotify) with mouse side button
            "$mainMod, mouse:275, split-workspace, 5"

            # Scroll through existing workspaces with mainMod + scroll
            "$mainMod, mouse_down, split-workspace, e+1"
            "$mainMod, mouse_up, split-workspace, e-1"

            # Move active window to a relative workspace with mainMod + CTRL + ALT + [←→]
            #"$mainMod CTRL ALT, right, movetoworkspace, r+1"
            #"$mainMod CTRL ALT, left, movetoworkspace, r-1"

            # Move active window around current workspace with mainMod + SHIFT + CTRL [←→↑↓]
            "$mainMod SHIFT $CONTROL, left, movewindow, l"
            "$mainMod SHIFT $CONTROL, right, movewindow, r"
            "$mainMod SHIFT $CONTROL, up, movewindow, u"
            "$mainMod SHIFT $CONTROL, down, movewindow, d"

            # Move active window around current workspace with mainMod + SHIFT + CTRL [HLJK]
            "$mainMod SHIFT $CONTROL, H, movewindow, l"
            "$mainMod SHIFT $CONTROL, L, movewindow, r"
            "$mainMod SHIFT $CONTROL, K, movewindow, u"
            "$mainMod SHIFT $CONTROL, J, movewindow, d"

            # Special workspaces (scratchpad)
            "$mainMod ALT, S, movetoworkspacesilent, special"
            "$mainMod, S, togglespecialworkspace,"
          ]
          ++ (builtins.concatLists (builtins.genList (x: [
              "$mainMod, ${toString (x + 1)}, split-workspace, ${toString (x +1)}"
              "$mainMod SHIFT, ${toString (x + 1)}, split-movetoworkspace, ${toString (x + 1)}"
              "$mainMod ALT, ${toString (x  + 1)}, split-movetoworkspacesilent, ${toString (x + 1)}"
            ])
            9))
          ++ (builtins.concatLists (builtins.genList (x: [
              #"$mainMod CTRL, ${toString (x + 10)}, split-workspace, ${toString (x + 10)}"
              #"$mainMod CTRL SHIFT, ${toString (x + 10)}, split-movetoworkspace, ${toString (x + 10)}"
              #"$mainMod CTRL ALT, ${toString (x  + 10)}, split-movetoworkspacesilent, ${toString (x + 10)}"
            ])
            9));
        bindm = [
          # Move/Resize windows with mainMod  LMB/RMB and dragging
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
      };
      extraConfig = ''
        # plugin {
        #   overview {
        #     showEmptyWorkspace = true
        #     panelHeight = 200
        #     overrideGaps = true
        #     gapsIn = 6
        #     gapsOut = 13
        #   }
        # }
        plugin {
          split-monitor-workspaces {
            count = 9
            keep_focused = 0
            enable_notifications = 0
           }
        }
        binds {
          workspace_back_and_forth = 1
          #allow_workspace_cycles=1
          #pass_mouse_when_bound=0
        }

        # Monitor
      #  monitor=,1920x1080@144,auto,1
	     # monitor=eDP-1,1920x1080@144, 1920x0, 1
        monitor=desc: JVC LT-MK24220,1920x1080@144,0x0,1
        monitor=eDP-1,1920x1080@144, 1920x0, 1
        #monitor=,1920x1080@144,auto,1
       # monitor = HDMI-A-1, preferred, 0x0, 1
        #monitor = DP-1, 2560x1600@59.9, 2560x0, 1

       workspace=1,monitor:eDP-1,default:true
        workspace=2,monitor:eDP-1,default:true
        workspace=3,monitor:eDP-1
        workspace=4,monitor:eDP-1
        workspace=5,monitor:eDP-1
	      workspace=6,monitor:eDP-1
        workspace=7,monitor:eDP-1
        workspace=8,monitor:eDP-1
        workspace=9,monitor:eDP-1


        workspace=10,monitor:HDMI-A-1
         workspace=11,monitor:HDMI-A-1,default:true
        workspace=12,monitor:HDMI-A-1,default:true
        workspace=13,monitor:HDMI-A-1
        workspace=14,monitor:HDMI-A-1
        workspace=15,monitor:HDMI-A-1
	      workspace=16,monitor:HDMI-A-1
        workspace=17,monitor:HDMI-A-1
        workspace=18,monitor:HDMI-A-1
        #workspace=19,monitor:HDMI-A-1
        
      '';
    };
  };
}
