# nvim config

## Introduction

Built from kickstart.nvim.

### Install External Dependencies

External Requirements:

- [ripgrep](https://github.com/BurntSushi/ripgrep#installation)
- fzf
- A [Nerd Font](https://www.nerdfonts.com/): provides various icons (defaults to enabled via `vim.g.have_nerd_font = true` in `init.lua`)

## Per project config

I have projects at work that use different Python tools (`flake8`, `mypy`, `ruff`, `pyright`, etc.) for linting and static analysis, so I have created importable configs for them in `lua/python_configs`. To use these, create a `.nvim.lua` file in the root folder of the project and put `require("python_configs/<config name>")` in it.
