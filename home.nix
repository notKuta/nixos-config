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
        mini-icons
        mini-pairs
        bufferline-nvim
        lualine-nvim
        trouble-nvim
#       which-key-nvim
        oxocarbon-nvim
      ];
      initLua = let
      	tabs = lib.mkOrder 500 "vim.opt.shiftwidth = 2\nvim.opt.expandtab = true\nvim.opt.tabstop = 2";
        rel_lines = lib.mkOrder 500 "vim.opt.relativenumber = true";
        lsp_nix = lib.mkOrder 500 "vim.lsp.enable('nixd')";
        lsp_md = lib.mkOrder 500 "vim.lsp.enable('marksman')";
        mini_icons = lib.mkOrder 500 "require('mini.icons').setup()";
        mini_pairs = lib.mkOrder 500 "require ('mini.pairs').setup()";
        bufferline = lib.mkOrder 500 "vim.opt.termguicolors = true\nrequire('bufferline').setup{}";
        lualine = lib.mkOrder 500 "require('lualine').setup()";
        oxocarbon = lib.mkOrder 500 "vim.opt.background = 'dark'\nvim.cmd.colorscheme 'oxocarbon'";
#       linters = lib.mkOrder 500 "require('lint').linters_by_ft = { markdown = {'markdownlint-cli2'}, nix = {'nix'}, }";
      in lib.mkMerge [ tabs rel_lines lsp_nix lsp_md mini_icons mini_pairs bufferline lualine oxocarbon ];

      extraPython3Packages = pyPkgs: with pyPkgs; [ pylatexenc ];

    };

    helix = {
      enable = true;
      #defaultEditor = true;

    };
  };
}
