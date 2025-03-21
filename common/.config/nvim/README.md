# nvim config

## Introduction

Built from kickstart.nvim.

### Install External Dependencies

External Requirements:

- [ripgrep](https://github.com/BurntSushi/ripgrep#installation)
- fzf
- A [Nerd Font](https://www.nerdfonts.com/): optional, provides various icons
  - if you have it set `vim.g.have_nerd_font` in `init.lua` to true

## Per project config

I have projects at work that use `flake8` to lint and `pyright`
for static analysis so I have created an importable config for that
in `lua/python_configs`. To use this, create a `.nvim.lua` file in
the root folder of the project and put `require("python_configs/<config name>")`
in it.
