# nvim-ReFact

>A [Neovim](https://neovim.io/) plugin Inspired by VSCode extension [Glean](https://github.com/wix/vscode-glean)

The plugin provides refactoring tools for your React codebase. Extract JSX into a new component, wrapping with Hooks and more!

## Highlights

- Allows extracting JSX into new component
- Allows wrapping JSX with conditional

## Requirements

- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) including a parser for your language

- [nui.nvim](https://github.com/MunifTanjim/nui.nvim)

## Installation

<details>
	<summary><a href="https://github.com/wbthomason/packer.nvim">Packer.nvim</a></summary>

```lua
use 'tamanna190101/nvim-ReFact'
```
</details>
<details>
	<summary><a href="https://github.com/junegunn/vim-plug">vim-plug</a></summary>

```vim
Plug 'tamanna190101/nvim-ReFact'
```
</details>
&nbsp;

## Extracting JSX into a new Component

treesitter-refact-react allows easy extraction of JSX into new React components (in the same or other file). Just select the JSX to extract, and it will handle all the rest:

- Generate Functional Component, such that the extracted JSX will continue to function.
- It will identify all inputs to the newly created component.
- Replace extracted JSX with newly created component, while providing it with all the props.

Examples:
- `vv` to select the inner unit
- `r` to change the JSX into new React components

gif...

### Useful mappings
<details>
	<summary><a href="https://github.com/wbthomason/packer.nvim">init.lua</a></summary>

```lua
vim.api.nvim_set_keymap('n', 'vv', ':lua require"nvim-ReFact".select()<CR>', {noremap=true})

vim.api.nvim_set_keymap('v', 'r', ':lua require"nvim-ReFact".change()<CR>', {noremap=true})
```
</details>
<details>
	<summary><a href="https://github.com/wbthomason/packer.nvim">init.vim</a></summary>

```vim
xnoremap vv :lua require"nvim-ReFact".select()<CR>

xnoremap r :lua require"nvim-ReFact".change()<CR>
```
</details>
&nbsp;

## How to run this project into your machine
make sure you have fulfilled the [requirements](https://github.com/tamanna190101/nvim-ReFact#requirements) and necessary [key mappings](https://github.com/tamanna190101/nvim-ReFact#useful-mappings)
```sh
# clone this repo
$ git clone https://github.com/tamanna190101/nvim-ReFact.git

$ cd nvim-ReFact

# set runtime path and open lua init.lua file and example.js file for test lua implementation
$ nvim --cmd "set rtp+=./" lua/nvim-ReFact/init.lua -O example.js
```
To setup Neovim Treesitter Playground follow this [link](https://github.com/nvim-treesitter/playground).
## Licensing

Licensed under the Apache License. Check the [LICENSE](LICENSE) file for details.
