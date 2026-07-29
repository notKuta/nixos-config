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
/*
    bash = {
      enable = true; 
      enableCompletion = true;
      sessionVariables = {
        #EDITOR = "vim";
      };
      shellAliases = {
        ll = "ls -la";
      };
    };
*/    
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

    };


    neovim = {
      enable = true;
#     defaultEditor = true;
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
#        which-key-nvim
      ];
      initLua = let
      	tabs = lib.mkOrder 500 "vim.opt.shiftwidth = 2\nvim.opt.expandtab = true\nvim.opt.tabstop = 2";
        rel_lines = lib.mkOrder 500 "vim.opt.relativenumber = true";
#       lsp = lib.mkOrder 500 "vim.pack.add{{ src = 'https://github.com/neovim/nvim-lspconfig' },}";
        lsp_nix = lib.mkOrder 500 "vim.lsp.enable('nixd')";
        lsp_md = lib.mkOrder 500 "vim.lsp.enable('marksman')";
        mini_icons = lib.mkOrder 500 "require('mini.icons').setup()";
        mini_pairs = lib.mkOrder 500 "require ('mini.pairs').setup()";
        bufferline = lib.mkOrder 500 "vim.opt.termguicolors = true\nrequire('bufferline').setup{}";
        lualine = lib.mkOrder 500 "require('lualine').setup()";
#        linters = lib.mkOrder 500 "require('lint').linters_by_ft = { markdown = {'markdownlint-cli2'}, nix = {'nix'}, }";
        #auto_cmd = lib.mkOrder 250 "vim.cmd(au BufWritePost * lua require('lint').try_lint())";
/*	
	auto_cmd_lua = lib.mkOrder 250 "vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
		callback = function()
		require('lint').try_lint('cspell')
		end,
	})";*/
    	in lib.mkMerge [ tabs rel_lines lsp_nix lsp_md mini_icons mini_pairs bufferline lualine ];

      extraPython3Packages = pyPkgs: with pyPkgs; [ pylatexenc ];

    };

    helix = {
      enable = true;
      #defaultEditor = true;

    };
  };
}
