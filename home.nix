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
        render-markdown-nvim
        mini-pairs
        
        bufferline-nvim
        lualine-nvim
#       trouble-nvim

#       which-key-nvim
        nui-nvim
        noice-nvim

        oxocarbon-nvim
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

        nui = lib.mkOrder 500 "require('nui').setup()";
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
      in lib.mkMerge [ tabs rel_lines bufferline mini_pairs lsp lualine oxocarbon nvim_web_devicons nui noice];

#     extraPython3Packages = pyPkgs: with pyPkgs; [ pylatexenc ];

    };
  };
}
