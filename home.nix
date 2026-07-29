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
  
  programs = {

   git = {
      enable = true;
      settings = {
        user = {
          name = "kuta";
          email = "realfirestar731@gmail.com";
       };
        init.defaultBranch = "main";
      }; 
    };

    discord.enable = true;

    kitty = {
      enable = true;
      font = {
        name = "Fira Code";
        size = 11;
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
        nvim-lspconfig
        markdown-preview-nvim
#       nvim-lint
        render-markdown-nvim
#       mini-icons
        mini-pairs
        bufferline-nvim
        lualine-nvim
#       trouble-nvim

        which-key-nvim

        oxocarbon-nvim
        nvim-web-devicons
/*
        telescope-nvim
        plenary-nvim
        telescope-fzy-native-nvim
*/
      ];
      initLua = let
      	tabs = lib.mkOrder 500 "vim.opt.shiftwidth = 2\nvim.opt.expandtab = true\nvim.opt.tabstop = 2";
        rel_lines = lib.mkOrder 500 "vim.opt.relativenumber = true";
        lsp_nix = lib.mkOrder 500 "vim.lsp.enable('nixd')";
        lsp_md = lib.mkOrder 500 "vim.lsp.enable('marksman')";
        #mini_icons = lib.mkOrder 500 "require('mini.icons').setup()";
        mini_pairs = lib.mkOrder 500 "require ('mini.pairs').setup()";
        bufferline = lib.mkOrder 500 "vim.opt.termguicolors = true\nrequire('bufferline').setup{}";
        lualine = lib.mkOrder 500 "require('lualine').setup()";
        oxocarbon = lib.mkOrder 500 "vim.opt.background = 'dark'\nvim.cmd.colorscheme 'oxocarbon'";
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
        /*
        telescope = "require('telescope').setup{
          defaults = {
          -- Default configuration for telescope goes here:
          -- config_key = value,
            mappings = {
              i = {
            -- map actions.which_key to <C-h> (default: <C-/>)
            -- actions.which_key shows the mappings for your picker,
            -- e.g. git_{create, delete, ...}_branch for the git_branches picker
              ['<C-h>'] = 'which_key'
              }
            }
          },
          pickers = {
          -- Default configuration for builtin pickers goes here:
          -- picker_name = {
          --   picker_config_key = value,
          --   ...
          -- }
          -- Now the picker_config_key will be applied every time you call this
          -- builtin picker
          },
          extensions = {
          -- Your extension configuration goes here:
          -- extension_name = {
          --   extension_config_key = value,
          -- }
          -- please take a look at the readme of the extension you want to configure
          }
        }";

        fzy_native = "require('telescope').load_extension('fzy_native')";

        plenary = "local async = require 'plenary.async'";
        */

#      linters = lib.mkOrder 500 "require('lint').linters_by_ft = { markdown = {'markdownlint-cli2'}, nix = {'nix'}, }";
      in lib.mkMerge [ tabs rel_lines lsp_nix lsp_md bufferline mini_pairs lualine oxocarbon nvim_web_devicons ];

#     extraPython3Packages = pyPkgs: with pyPkgs; [ pylatexenc ];

    };

    helix = {
      enable = true;
      #defaultEditor = true;

    };
  };
}
