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

    neovim = {
      enable = true;
      defaultEditor = true;
      initLua = let
      	w0ke = lib.mkOrder 500 "vim.opt.shiftwidth = 4\nvim.opt.expandtab = true\nvim.opt.tabstop = 4";
	in lib.mkMerge [ w0ke ];
    };
  };
}
