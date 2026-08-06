{ config, pkgs, inputs, lib, ... }:

{
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "26.11";

  xdg.configFile = {
    "MangoHud/MangoHud.conf".source = config.lib.file.mkOutOfStoreSymlink "/home/kuta/nixos-config/configs/MangoHud.conf";
    "MangoHud/Stardew Valley.conf".source = config.lib.file.mkOutOfStoreSymlink "/home/kuta/nixos-config/configs/Stardew Valley.conf";
  };

  # Sets user environmental variables thru Systemd i.e. 
  # on other distros this would be thru ~/.config/environment.d
  # ONLY WORKS on KDE and GNOME (https://wiki.archlinux.org/title/Environment_variables#Per_Wayland_session)
  systemd.user.sessionVariables = { __GL_SHADER_DISK_CACHE_SIZE = 12000000000; MANGOHUD = 1; };

  services = {
    pipewire = {
      enable = true;
      configPackages = [
        (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/99-input-denoising.conf" ''
        context.modules = [
        {
            name = libpipewire-module-filter-chain
            args = {
              node.description =  "Microphone (noise suppressed)"
              media.name =  "Microphone (noise suppressed)"
              filter.graph = {
                nodes = [
                    {
                       type = ladspa
                       name = rnnoise
                       plugin = librnnoise_ladspa
                       label = noise_suppressor_mono
                       control = {
                         "VAD Threshold (%)" = 85.0
                         "VAD Grace Period (ms)" = 200
                         "Retroactive VAD Grace (ms)" = 0
                      }
                    }
                  ]
                }
                capture.props = {
                  node.name =  "capture.rnnoise_source"
                  node.passive = true
                  audio.rate = 48000
                }
                playback.props = {
                  node.name =  "rnnoise_source"
                  media.class = Audio/Source
                  audio.rate = 48000
                }
            }
          }
          ]
      '')
      ];  
    };
  };

  programs = {
    plasma = {
      enable = true;

      # overrideConfig = true;

      workspace = {
      # Sets theme to Breeze Dark
        lookAndFeel = "org.kde.breezedark.desktop";
        theme = "breeze-dark";
        wallpaper = "/home/kuta/nixos-config/wallpapers/metaphor-three-gang.jpg";
        wallpaperFillMode = "preserveAspectCrop";
      };

      panels = [
      {
        alignment = "center";
        extraSettings = null; # Extra shenangians with fillers and whatnot
        floating = true;
        height = 46;
        hiding = "autohide";
        lengthMode = "fill";
        location = "bottom";
        opacity = "adaptive";
      }
      
      ];

      input.mice = [
      {
        name = "Compx Teevo Terra Pro";  
        enable = true;
        acceleration = 0.36;
        accelerationProfile = "none";
        leftHanded = false;
        middleButtonEmulation = false;
        naturalScroll = false;
        productId = "f520";
        scrollSpeed = 2;
        vendorId = "3554";
      }
      ];
      # Controls how applications are restored on login
      session.sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
      krunner.shortcuts.launch = "Alt+Space";
      krunner.position = "center";

      fonts = {
        general = {
          family = "Noto Sans";
          pointSize = 10;
        };
        fixedWidth = {
          family = "Hack";
          pointSize = 10;
        };
        small = {
          family = "Noto Sans";
          pointSize = 8;
        };
        toolbar = {
          family = "Noto Sans";
          pointSize = 10;
        };
        menu = {
          family = "Noto Sans";
          pointSize = 10;
        };
        windowTitle = {
          family = "Noto Sans";
          pointSize = 10;
        };

        general.styleStrategy.antialiasing = "prefer";
      };

      
      # Sets the lockscreen wallpaper 
      # TO-DO: Copy metaphor wallpaper into nixos-config directory
      kscreenlocker.appearance.wallpaper = "/home/kuta/nixos-config/wallpapers/metaphor-three-gang.jpg";
      kscreenlocker.appearance.showMediaControls = true;

      shortcuts = {
        kwin = {
          "Switch to Next Desktop" = "Meta+Tab";
        };
      };

      kwin = {
        effects = {
          desktopSwitching.navigationWrapping = true;
          hideCursor.hideOnInactivity = 60;
          desktopSwitching.animation = "slide";
          minimization.animation = "squash";
          windowOpenClose.animation = "scale";
          dimAdminMode.enable = true;
          hideCursor.enable = true;
          shakeCursor.enable = true;
        };

        virtualDesktops.number = 2;
      };

      powerdevil = {
        AC = {
          autoSuspend.action = "sleep";
          autoSuspend.idleTimeout = 1800;
          dimDisplay.enable = true;
          dimDisplay.idleTimeout = 600; 

          displayBrightness = 25;
          # keyboardBrightness = 50;
          powerButtonAction = "shutDown";
          powerProfile = "balanced";
          turnOffDisplay.idleTimeout = 900;
          turnOffDisplay.idleTimeoutWhenLocked = 60;

          whenLaptopLidClosed = "sleep";
          # whenSleepingEnter = Type: null or one of “hybridSleep”, “standby”, “standbyThenHibernate"
        };

        battery = {
        # Hibernates after 30 minutes of inactivity on battery
          autoSuspend.action = "hibernate";
          autoSuspend.idleTimeout = 1800;

        # Dims the display after 10 minutes of inactivity on battery
          dimDisplay.enable = true;
          dimDisplay.idleTimeout = 600;

          dimKeyboard.enable = true;
          keyboardBrightness = 20;
          displayBrightness = 30;

          powerButtonAction = "shutDown";
          powerProfile = "powerSaving";

          turnOffDisplay.idleTimeout = 900;
          turnOffDisplay.idleTimeoutWhenLocked = 60;

          whenLaptopLidClosed = "hibernate";
          # Change to what you want
          whenSleepingEnter = null; # Type: null or one of “hybridSleep”, “standby”, “standbyThenHibernate”
        };

        batteryLevels.criticalLevel = 5;
        batteryLevels.lowLevel = 20;
        general.pausePlayersOnSuspend = true;

        lowBattery = {
          powerProfile = "powerSaving";
          autoSuspend.action = "shutDown";
          autoSuspend.idleTimeout = 600;

          dimDisplay.enable = true;
          dimDisplay.idleTimeout = 180;

          dimKeyboard.enable = true;
          displayBrightness = 10;
          keyboardBrightness = 0;

          powerButtonAction = "shutDown";
          turnOffDisplay.idleTimeout = 300;
          turnOffDisplay.idleTimeoutWhenLocked = 60;
          whenLaptopLidClosed = "shutDown";
          whenSleepingEnter = "standbyThenHibernate";
        };
      };
    };
# DRM-controlled media not playing when launching
# PWA thru the DE desktop entry, but does work when
# launched thru Firefox extension
/*
    firefox = {
      enable = true;
      nativeMessagingHosts = [ pkgs.firefoxpwa ];
    };

    firefoxpwa = {
      enable = true;
      profiles = {
        "01KYX600KEY64N6KDTG1T4MP1P" = {
          name = "Apple Music Profile";
          sites."01KYX600KE75YA53F0GN0M5FHG" = {
            desktopEntry.categories = [ "Music" ];
            desktopEntry.enable = true;
            desktopEntry.icon = pkgs.fetchurl {
              url = "https://upload.wikimedia.org/wikipedia/commons/5/5f/Apple_Music_icon.svg";
              sha256 = "e17c3c7ad50b7a0b2b7dbade1493518338c76766c0513abd84f615d1c5048153";
            };
            name = "Apple Music";
            url = "https://music.apple.com/us/new";
            manifestUrl = "https://music.apple.com/manifest.json";
          };
        };
      };
    };
*/
   git = {
      enable = true;
      settings = {
        user = {
          name = "kuta";
          email = "graystripe63@posteo.net";
       };
        init.defaultBranch = "main";
      }; 
    };

    mangohud = {
      enable = true;
      # Options are symlinked with mkOutStore...
      # See above and edit the file under configs/ if wanted
    };

    thunderbird = {
      enable = true;
      profiles."default_new" = {
        settings = {};
        search.default = "ddg";
        search.privateDefault = "ddg";
        search.force = true;
        isDefault = true;
      };
      # Much more options available
    };

    kitty = {
      enable = true;
      font = {
        name = "Fira Code";
        size = 11;
        package = pkgs.fira-code;
      };
      settings = {
        foreground = "#dde1e6";
        background = "#161616";
        selection_foreground = "#f2f4f8";
        selection_background = "#525252";

        cursor = "#f2f4f8";
        cursor_text_color = "#393939";

        url_color = "#ee5396";
        url_style = "single";

        active_border_color = "#ee5396";
        inactive_border_color = "#ff7eb6";

        bell_border_color = "#ee5396";

        wayland_titlebar_color = "system";
        macos_titlebar_color = "system";

        active_tab_foreground = "#161616";
        active_tab_background = "#ee5396";
        inactive_tab_foreground = "#dde1e6";
        inactive_tab_background = "#393939";
        tab_bar_background = "#161616";

        color0 = "#262626";
        color8 = "#393939";

        color1 = "#ff7eb6";
        color9 = "#ff7eb6";

        color2 = "#42be65";
        color10 = "#42be65";

        color3 = "#82cfff";
        color11 = "#82cfff";

        color4 = "#33b1ff";
        color12 = "#33b1ff";

        color5 = "#ee5396";
        color13 = "#ee5396";

        color6 = "#3ddbd9";
        color14 = "#3ddbd9";

        color7 = "#dde1e6";

        color15 = "#ffffff";

      };
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      plugins = with pkgs.vimPlugins; 
      [
        # Helps with easy lsp configs for enabled &
        # download langs
        nvim-lspconfig
        # Enables markdown preview in-browser
        markdown-preview-nvim
        # Enables markdown in-terminal previews
        render-markdown-nvim

        # Immediately creates corresponding 
        # character for parenthesis, quotes, etc.
        mini-pairs
        # Creates the "tabs" look at the top of
        # nvim window
        bufferline-nvim
        # Creates the bottom statusline
        lualine-nvim

        # Makes diagnostics 'prettier'
        # trouble-nvim

        # Pop-up to illustrate keybinds
        # available 
        # This is the plugin which should
        # Be focused on and customized next
        which-key-nvim
        # UI Component Library
        nui-nvim
        # 'Prettier' cmdline 
        noice-nvim

        # Theme
        oxocarbon-nvim
        # Icons
        nvim-web-devicons
     ];
      initLua = let
      	tabs = lib.mkOrder 500 "vim.opt.shiftwidth = 2\nvim.opt.expandtab = true\nvim.opt.tabstop = 2";
        rel_lines = lib.mkOrder 500 "vim.opt.relativenumber = true";

        lsp = lib.mkOrder 500 "vim.lsp.enable('nixd')\nvim.lsp.enable('marksman')";
        mini_pairs = lib.mkOrder 500 "require ('mini.pairs').setup()";

        bufferline = lib.mkOrder 500 "vim.opt.termguicolors = true\nrequire('bufferline').setup{}";
        lualine = lib.mkOrder 500 "require('lualine').setup()";
        oxocarbon = lib.mkOrder 500 "vim.opt.background = 'dark'\nvim.cmd.colorscheme 'oxocarbon'";

        noice = lib.mkOrder 500 "require('noice').setup({
          lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
              ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
              ['vim.lsp.util.stylize_markdown'] = true,
              ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
            },
          },
          -- you can enable a preset for easier configuration
          presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = true, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false, -- add a border to hover docs and signature help
          },
        })";

        nvim_web_devicons = "require'nvim-web-devicons'.setup {
          -- your personal icons can go here (to override)
          -- you can specify color or cterm_color instead of specifying both of them
          -- DevIcon will be appended to `name`
          override = {
            zsh = {
              icon = '',
              color = '#428850',
              cterm_color = '65',
              name = 'Zsh'
            }
          };
          -- globally enable different highlight colors per icon (default to true)
          -- if set to false all icons will have the default icon's color
          color_icons = true;
          -- globally enable default icons (default to false)
          -- will get overriden by `get_icons` option
          default = true;
          -- globally enable strict selection of icons - icon will be looked up in
          -- different tables, first by filename, and if not found by extension; this
          -- prevents cases when file doesn't have any extension but still gets some icon
          -- because its name happened to match some extension (default to false)
          strict = true;
          -- set the light or dark variant manually, instead of relying on `background`
          -- (default to nil)
          variant = 'light|dark';
          -- override blend value for all highlight groups :h highlight-blend.
          -- setting this value to `0` will make all icons opaque. in practice this means
          -- that icons width will not be affected by pumblend option (see issue #608)
          -- (default to nil)
          blend = 0;
          -- same as `override` but specifically for overrides by filename
          -- takes effect when `strict` is true
          override_by_filename = {
            ['.gitignore'] = {
              icon = '',
              color = '#f1502f',
              name = 'Gitignore'
              }
          };
          -- same as `override` but specifically for overrides by extension
          -- takes effect when `strict` is true
          override_by_extension = {
            ['log'] = {
              icon = '',
              color = '#81e043',
              name = 'Log'
            }
          };
          -- same as `override` but specifically for operating system
          -- takes effect when `strict` is true
          override_by_operating_system = {
            ['apple'] = {
              icon = '',
              color = '#A2AAAD',
              cterm_color = '248',
              name = 'Apple',
            },
          };
        }";
      in lib.mkMerge [ tabs rel_lines bufferline mini_pairs lsp lualine oxocarbon nvim_web_devicons noice];

#     extraPython3Packages = pyPkgs: with pyPkgs; [ pylatexenc ];

    };
  };
}
