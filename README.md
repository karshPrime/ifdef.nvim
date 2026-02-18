
# ifdef.nvim

A plugin that makes navigating **C/C++ files full of nested `#ifdef` blocks** dramatically easier.  

It scans through opened source file, builds a structural map of all preprocessor conditionals, and
gives tools to inspect, visualise, and annotate them.


## Features

* **Show active parent `#ifdef` blocks** for the current line (`:Ifdef current`)
* **Auto‑refresh on file open/save**, with a manual refresh command
* **Tree view** of file structure with indentation based on preprocessor nesting
* **Append comment labels** to matching `#endif` lines
* **Enable/disable** the plugin at any time
* **Lightweight**: uses simple file scanning and keeps an in‑memory structure


## Under the Hood

Whenever a file is opened or saved, the plugin:
1. Scans the entire buffer for: `#ifdef` `#ifndef` `#else` `#endif`
2. Builds a structured array representing the full conditional tree.
3. Keeps it cached until the next refresh.

Refresh can also be triggered manually with: `:Ifdef refresh`


## Commands

* `:Ifdef current` Prints all enclosing preprocessor conditions for the current cursor position. `!`
  marks inversions (`#ifndef` and `#else` branches of `#ifdef`).
* `:Ifdef refresh` Re-scan and rebuild the condition tree.
* `:Ifdef comment-end` Appends labels such as `// IFDEF_FOO` to `#endif` lines.
* `:Ifdef tree` Opens a new buffer showing a hierarchical layout of functions/procedures, indented
  by their surrounding `#ifdef` structure.
* `:Ifdef enable` / `:Ifdef disable` Toggle the plugin on or off.


## Installation

Add plugin with `karshPrime/ifdef.nvim`. With **lazy.nvim** this can be done as:

```lua
local plugins = {
    ...

    { 'karshPrime/ifdef.nvim', event = 'VeryLazy', },

    ...
}

require("lazy").setup(plugins, {})
require('ifdef').setup()
```


## Keybindings

To bind a command, use something like:

```lua
vim.keymap.set('n', '<leader>h', ':Ifdef current<CR>')
```

Replace `<leader>h` with whatever makes sense.


## Hacks & Notes

If using **noice.nvim**, brief messages may disappear too quickly.
This can be increase with:

```lua
require("noice").setup({
    views = {
        mini = { timeout = 10000 },
    },
    ...
})
```

