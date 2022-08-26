# treesitter-refact-react

>[Neovim](https://neovim.io/) plugin to deal with [treesitter](https://github.com/tree-sitter/tree-sitter) units.

The plugin provides refactoring tools for your React codebase. Extract JSX into a new component, wrapping with Hooks and more!

## Highlights

- Allows extracting JSX into new component
- Allows wrapping JSX with conditional

## Requirements

- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) including a parser for your language

- [nui.nvim](https://github.com/MunifTanjim/nui.nvim)

## Installation


For [packer](https://github.com/wbthomason/packer.nvim):
```
use 'tamanna190101/NVIM-PLUGIN'
```

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

For init.lua:
```
vim.api.nvim_set_keymap('n', 'vv', ':lua require"treesitter-refact-react".select()<CR>', {noremap=true})

vim.api.nvim_set_keymap('v', 'r', ':lua require"treesitter-refact-react".change()<CR>', {noremap=true})
```

## Licensing

Licensed under the Apache License. Check the [LICENSE](LICENSE) file for details.