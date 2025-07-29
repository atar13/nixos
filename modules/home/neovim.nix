# { dotfiles, pkgs, ... }:
# let

# lazy-nix-helper = pkgs.vimUtils.buildVimPlugin {
#     name = "lazy-nix-helper";
#     src = pkgs.fetchFromGitHub {
#       owner = "b-src";
#       repo = "lazy-nix-helper.nvim";
#       rev = "main";
#       hash = "sha256-TBDZGj0NXkWvJZJ5ngEqbhovf6RPm9N+Rmphz92CS3Q=";
#     };
#   };

# treesitterWithGrammars = (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
#     p.bash
#     p.comment
#     p.css
#     p.dockerfile
#     p.fish
#     p.gitattributes
#     p.gitignore
#     p.go
#     p.gomod
#     p.gowork
#     p.hcl
#     p.javascript
#     p.jq
#     p.json5
#     p.json
#     p.lua
#     p.make
#     p.markdown
#     p.nix
#     p.python
#     p.rust
#     p.toml
#     p.typescript
#     p.vue
#     p.yaml
#   ]));
# in
# {
#   xdg.configFile = {
#     nvim = {
#       # needs to be recursive instead of symlink to get packer to work
#       # https://github.com/nix-community/home-manager/issues/2282#issuecomment-903299819
#       recursive = true;
#       source = "${dotfiles}/nvim/.config/nvim";
#       # source = "/home/${username}/dotfiles/nvim/.config/nvim";
#     };
#   };

#   home.packages = with pkgs; [
#     ripgrep
#     fd
#     lua-language-server
#     rust-analyzer-unwrapped
#     black
#   ];

#   programs.neovim = {
#     enable = true;
#     vimAlias = true;

#     plugins = [
#       treesitterWithGrammars
#       lazy-nix-helper
#       pkgs.vimPlugins.lazy-nvim
#     ];
#   };
# }

{ dotfiles, pkgs, config, lib, ... }:

let
  lazy-nix-helper-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "lazy-nix-helper.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "b-src";
      repo = "lazy-nix-helper.nvim";
      rev = "main";
      hash = "sha256-4DyuBMp83vM344YabL2SklQCg6xD7xGF5CvQP2q+W7A=";
    };
  };

  telescope-repo-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "telescope-repo.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "cljoly";
      repo = "telescope-repo.nvim";
      rev = "a5395a4bf0fd742cc46b4e8c50e657062f548ba9";
      hash = "sha256-cIovB45hfG4lDK0VBIgK94dk2EvGXZtfAJETkQ+lrcw=";
    };
  };

  # noctis-nvim = pkgs.vimUtils.buildVimPlugin {
  #   name = "noctis.nvim";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "kartikp10";
  #     repo = "noctis.nvim";
  #     rev = "0b9336e39c686a7e58de06e4dd38c2bd862a7b33";
  #     hash = "sha256-TtH5Kw9qgkMisuJNI2LeTHTNfQZnJXPQfs9WJGQwgys=";
  #   };
  # };

  icon-picker-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "icon-picker.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "ziontee113";
      repo = "icon-picker.nvim";
      rev = "3ee9a0ea9feeef08ae35e40c8be6a2fa2c20f2d3";
      hash = "sha256-VZKsVeSmPR3AA8267Mtd5sSTZl2CAqnbgqceCptgp4w=";
    };
  };

  duck-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "tamton-aquib/duck.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "tamton-aquib";
      repo = "duck.nvim";
      rev = "d8a6b08af440e5a0e2b3b357e2f78bb1883272cd";
      hash = "sha256-97QSkZHpHLq1XyLNhPz88i9VuWy6ux7ZFNJx/g44K2A=";
    };
  };

  toggle-lsp-diagnostics-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "WhoIsSethDaniel";
      repo = "toggle-lsp-diagnostics.nvim";
      rev = "4fbfb51e3902d17613be0bc03035ce26b9a8d05d";
      hash = "sha256-QuqdWBWduETFBFj2n09Pwst39hzFNAtpLUVx3XhENfI=";
    };
  };

  # nvim-cmp-unstable = pkgs.vimUtils.buildVimPlugin {
  #   name = "hrsh7th/nvim-cmp";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "hrsh7th";
  #     repo = "nvim-cmp";
  #     rev = "97dc716fc914c46577a4f254035ebef1aa72558a";
  #     hash = "sha256-VFtf1mI1ucClWzsWn+rf+TlC3ZgkYPiHrPTQZci9zrQ=";
  #   };
  # };

  treesitterWithGrammars = (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.bash
    p.comment
    p.css
    p.dockerfile
    p.fish
    p.gitattributes
    p.gitignore
    p.go
    p.gomod
    p.gowork
    p.hcl
    p.javascript
    p.jq
    p.json5
    p.json
    p.lua
    p.make
    p.markdown
    p.nix
    p.python
    p.rust
    p.toml
    p.typescript
    p.vue
    p.yaml
  ]));

  sanitizePluginName = input:
    let
      name = lib.strings.getName input;
      intermediate = lib.strings.removePrefix "vimplugin-" name;
      result = lib.strings.removePrefix "lua5.1-" intermediate;
    in
    result;

  pluginList = plugins: lib.strings.concatMapStrings (plugin: "  [\"${sanitizePluginName plugin.name}\"] = \"${plugin.outPath}\",\n") plugins;

in
{
  xdg.configFile = {
    "nvim/lua" = {
      recursive = true;
      source = "${dotfiles}/nvim/.config/nvim/lua";
      # source = "/home/atarbinian/dotfiles/nvim/.config/nvim/lua/";
    };
    "nvim/after" = {
      recursive = true;
      source = "${dotfiles}/nvim/.config/nvim/after";
      # source = "/home/atarbinian/dotfiles/nvim/.config/nvim/after";
    };
  };

  home.packages = with pkgs; [
    html-tidy
    vscode-langservers-extracted
    # ripgrep
    # fd
    lua-language-server
    # rust-analyzer
    # black
    # clangd
    nil
    glslls
    pyright
    djlint
    autotools-language-server
    tree-sitter
    nodejs
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
    ];
    plugins = with pkgs.vimPlugins; [
      lazy-nix-helper-nvim
      lazy-nvim

      telescope-nvim
      telescope-ui-select-nvim
      telescope-fzf-native-nvim
      telescope-repo-nvim
      vim-prosession
      vim-obsession
      plenary-nvim
      vim-rooter

      nvim-lspconfig
      # nvim-cmp-unstable
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip
      cmp-nvim-lua
      luasnip
      friendly-snippets
      nvim-lint
      conform-nvim

      oxocarbon-nvim
      nightfox-nvim
      noctis-nvim
      lush-nvim

      barbar-nvim
      nvim-web-devicons

      comment-nvim
      vim-fugitive
      gitsigns-nvim
      undotree
      icon-picker-nvim
      nvim-tree-lua
      lualine-nvim
      nvim-navic
      knap
      vim-suda
      duck-nvim
      toggle-lsp-diagnostics-nvim
      vim-tmux-navigator
      toggleterm-nvim
      todo-comments-nvim
      # nvim-treesitter
      # nvim-treesitter.withAllGrammars
      treesitterWithGrammars
      # (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      rustaceanvim
    ];
    extraLuaConfig = ''
      require("config")

      local plugins = {
      ${pluginList config.programs.neovim.plugins}
      }
      local lazy_nix_helper_path = "${lazy-nix-helper-nvim}"
      if not vim.loop.fs_stat(lazy_nix_helper_path) then
        lazy_nix_helper_path = vim.fn.stdpath("data") .. "/lazy_nix_helper/lazy_nix_helper.nvim"
        if not vim.loop.fs_stat(lazy_nix_helper_path) then
          vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/b-src/lazy_nix_helper.nvim.git",
            lazy_nix_helper_path,
          })
        end
      end

      -- add the Lazy Nix Helper plugin to the vim runtime
      vim.opt.rtp:prepend(lazy_nix_helper_path)

      -- call the Lazy Nix Helper setup function
      local non_nix_lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      local lazy_nix_helper_opts = { lazypath = non_nix_lazypath, input_plugin_table = plugins }
      require("lazy-nix-helper").setup(lazy_nix_helper_opts)

      -- get the lazypath from Lazy Nix Helper
      local lazypath = require("lazy-nix-helper").lazypath()
      if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
          "git",
          "clone",
          "--filter=blob:none",
          "https://github.com/folke/lazy.nvim.git",
          "--branch=stable", -- latest stable release
          lazypath,
        })
      end
      vim.opt.rtp:prepend(lazypath)

      require("lazy").setup({
        {
          priority = 1,
          import = "plugins",
        },
      })
    '';
  };
}
