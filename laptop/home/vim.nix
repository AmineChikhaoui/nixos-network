{ pkgs, lib, ... }:
let

  clangFormat = builtins.fetchurl {
    url =
      "https://raw.githubusercontent.com/llvm-mirror/clang/master/tools/clang-format/clang-format.py";
    sha256 = "0xmnshbn8p10yjz4821lmayrbs4044i9mcqi5y6pnqzh6nfkk130";
  };

  cscopeMaps = builtins.fetchurl {
    url =
      "https://raw.githubusercontent.com/chazy/cscope_maps/master/plugin/cscope_maps.vim";
    sha256 = "0i955zg1c2gw5lj6921b4yllhr9nbxg7nl3yar54h7m4m1z6q9rz";
  };

  customPlugins = {
    vim-ripgrep = pkgs.vimUtils.buildVimPlugin {
      name = "vim-ripgrep";
      src = pkgs.fetchFromGitHub {
        owner = "jremmen";
        repo = "vim-ripgrep";
        rev = "ec87af6b69387abb3c4449ce8c4040d2d00d745e";
        sha256 = "1by56rflr0bmnjvcvaa9r228zyrmxwfkzkclxvdfscm7l7n7jnmh";
      };
      patches = [
        (pkgs.fetchurl {
          url = "https://patch-diff.githubusercontent.com/raw/jremmen/vim-ripgrep/pull/64.patch";
          sha256 = "sha256-YAmY2DVcUbWPeLI0O3dxevFD1+0VFezsax1SgSBhZMA=";
        })
      ];
    };
    vim-logicblox = pkgs.vimUtils.buildVimPlugin {
      name = "vim-logicblox";
      src = builtins.fetchGit {
        url = /home/amine/src/vim-logicblox;
        ref = "master";
        rev = "003586ca6773e54ced8d477307c409d30ad18be8";
      };
    };
    vim-autopep8 = pkgs.vimUtils.buildVimPlugin {
      name = "vim-autopep8";
      src = pkgs.fetchFromGitHub {
        owner = "tell-k";
        repo = "vim-autopep8";
        rev = "4191261db378fcad4213fc59a7f3be0c2735d543";
        sha256 = "154vnx034mccbda07zfqqmh99vbbkkqgizasl1gkbxsd8j4jx5vv";
      };
    };
    vim-jq = pkgs.vimUtils.buildVimPlugin {
      name = "vim-jq";
      src = pkgs.fetchFromGitHub {
        owner = "bfrg";
        repo = "vim-jq";
        rev = "0076ef5424894e17f0ab17f4d025a3b519008134";
        sha256 = "7d9e409f34e383736d6d3024e4427f8b632fe6175a8c9d2e0b01e75fefebf244";
      };
    };
    vim-deus = pkgs.vimUtils.buildVimPlugin {
      name = "vim-deus";
      src = pkgs.fetchFromGitHub {
        owner = "ajmwagar";
        repo = "vim-deus";
        rev = "2f88c926629ab094e8d7ec4942518075e7f47f96";
        sha256 = "sha256:1vmvs0rn4a1d9zi62pp9lfd682dagy31zdzsi36fyrr04510q8bb";
      };
    };
    badwolf = pkgs.vimUtils.buildVimPlugin {
      name = "badwolf";
      src = pkgs.fetchFromGitHub {
        owner = "sjl";
        repo = "badwolf";
        rev = "73e3198860d1e874874844688b83b6d7b35d644f";
        sha256 = "sha256:09h8p193c4mjmfqh08hmffpgdgqm5nx04mnmbcxm3w2cw05gv3jg";
      };
    };
    sitruuna = pkgs.vimUtils.buildVimPlugin {
      name = "sitruuna";
      src = pkgs.fetchFromGitHub {
        owner = "eemed";
        repo = "sitruuna.vim";
        rev = "e0e0a829bdeefbe7ba012f26cebdad2fb4481cb0";
        sha256 = "sha256-S7BcKcfyP8BSzbRhh2Jo4T3yl7lEFfxPnHl7zqpSlHo=";
      };
    };
    onedark = pkgs.vimUtils.buildVimPlugin {
      name = "onedark";
      src = pkgs.fetchFromGitHub {
        owner = "joshdick";
        repo = "onedark.vim";
        rev = "4bd965e29811e29e1c1b0819f3a63671d3e6ef28";
        sha256 = "e22db041e6ef328f69692adb0cf4155711ec465aad5fce6320e44d17418d1f99";
      };
    };
    vim-nickel = pkgs.vimUtils.buildVimPlugin rec {
      name = "vim-nickel";
      src = pkgs.fetchFromGitHub {
        owner = "nickel-lang";
        repo = name;
        rev = "90d68675d46e029517a41b0610d8a79dd5a73918";
        sha256 = "sha256-rwpPNZiCnjQK+26NDlkE7R+L33EpZuMlNhGrRNsDK7I=";
      };
    };
  };

  myVim = pkgs.vim_configurable.customize {
    name = "vim";
    wrapGui = true;
    vimrcConfig = {
      customRC = ''
        syntax on
        set encoding=UTF-8
        set autoread
        set backspace=2
        set colorcolumn=80,100
        set hidden
        set background=dark
        set laststatus=2
        set list
        set t_Co=256
        set textwidth=80
        set listchars=tab:›\ ,eol:¬,trail:⋅
        set number
        set ruler
        set showmatch
        set visualbell
        set nu
        set list

        " Search settings
        set hlsearch
        set ignorecase
        set incsearch
        set smartcase

        autocmd BufEnter * :syntax sync fromstart

        highlight ExtraWhitespace ctermbg=red guibg=red
        match ExtraWhitespace /\s\+$/

        map <F7> :tabp<enter>
        map <F8> :tabn<enter>
        set expandtab
        set softtabstop=2
        set shiftwidth=2
        filetype plugin indent on
        colorscheme badwolf
        " colorscheme onedark

        source ${cscopeMaps}

        map <C-K> :pyf ${clangFormat}<cr>

        map <C-F> :FZF<enter>

        if &diff
          colorscheme molokai
        endif

        let g:syntastic_python_checkers = ['mypy', 'flake8']

        " comment the next line to disable automatic format on save
        let g:dhall_format=1

        " Always draw sign column. Prevent buffer moving when adding/deleting sign.
        set signcolumn=yes

        " Required for operations modifying multiple buffers like rename.
        set hidden

        "ensure zig is a recognized filetype
        autocmd BufNewFile,BufRead *.zig set filetype=zig

        let g:LanguageClient_serverCommands = {
         \ 'zig': ['/run/current-system/sw/bin/zls'],
         \ 'python': ['/run/current-system/sw/bin/pylsp'],
         \ 'dhall': ['dhall-lsp-server'],
         \ 'terraform': ['terraform-ls'],
         \ 'go': ['gopls'],
         \ 'jsonnet': ['/home/amine/go/bin/jsonnet-language-server']
         \ }

        nnoremap <F5> :call LanguageClient_contextMenu()<CR>
        nnoremap <silent> gh :call LanguageClient_textDocument_hover()<CR>
        nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
        nnoremap <silent> gr :call LanguageClient_textDocument_references()<CR>
        nnoremap <silent> gs :call LanguageClient_textDocument_documentSymbol()<CR>
        nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
        nnoremap <silent> gff :call LanguageClient_textDocument_formatting()<CR>

        function! FaroEdit()
          let l:fname = expand("/home/amine/oxford/gtn/**/". expand("<cWORD>") . ".deckspec")
          if filereadable(l:fname)
            execute 'edit' l:fname
          else
            echo "couldn't find " . expand("<cWORD>") . " in the deckspecs"
          endif
        endfunction

        function! CFTemplateEdit()
          let l:fname = expand("/home/amine/oxford/gtn/**/". expand("<cWORD>") . ".template")
          if filereadable(l:fname)
            execute 'edit' l:fname
          else
            echo "couldn't find " . expand("<cWORD>") . " in the templates"
          endif
        endfunction

        nnoremap f :call FaroEdit()<CR>
        nnoremap t :call CFTemplateEdit()<CR>

        " add Infor tooling file types which are pretty much yaml
        ${lib.concatMapStringsSep "\n"
          (
          ext: "autocmd BufNewFile,BufRead *.${ext} set syntax=yaml"
          ) [
          "farobuild" "deckspec" # "sls"
          "ced" "sam" "template"
          ]
        }
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ LanguageClient-neovim ];
      };
      vam.knownPlugins = pkgs.vimPlugins // customPlugins;
      vam.pluginDictionaries = [{
        names = [
          "vim-nix"
          "fugitive" # Git
          "nerdtree"
          "vim-grammarous" # grammar check
          "fzfWrapper" # fzf
          "airline" # fancy status bar
          "vim-lawrencium" # mercurial ?
          "vim-autoformat"
          "vim-docbk"
          "vim-docbk-snippets"
          "syntastic"
          "vim-codefmt"
          "vim-ripgrep"
          "vim-logicblox"
          #"vim-snippets"
          "vim-autopep8"
          "molokai" # color scheme
          "vim-deus" # color scheme
          #"vim"
          "badwolf" # color scheme
          "vim-cpp-enhanced-highlight" # C++ better syntax highlighter
          "vim-gitgutter" # show changes live
          "dhall-vim" # Dhall syntax
          #"coc-metals" # Scala LSP
          "coc-nvim" # LSP
          "onedark" # color syntax
          "vim-devicons" # fonts
          "vim-racer"
          "vim-go"
          "vim-ledger"
          "sitruuna"
          "zig-vim"
          "vim-toml"
          "vim-terraform"
          "vim-terraform-completion"
          "vim-nickel"
          "vim-jsonnet"
          "salt-vim"
          #"YouCompleteMe"
        ];
      }];
    };
  };
in
  {
    home.packages = [
      myVim pkgs.terraform-ls pkgs.gopls pkgs.delve
      pkgs.dhall-lsp-server ]; }
