vim.cmd("syntax on")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Use terminal colors
vim.o.termguicolors = false

-- Colorscheme (Dracula)
-- vim.opt.termguicolors = true
-- vim.cmd.colorscheme('dracula')

-- Map Ctrl+Z to Undo
vim.keymap.set('n', '<C-z>', 'u', { noremap = true })
vim.keymap.set('i', '<C-z>', 'u', { noremap = true })
vim.keymap.set('v', '<C-z>', 'u', { noremap = true })

-- Enable pseudo-line movement
vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<Down>', 'g<Down>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Up>', 'g<Up>', { noremap = true, silent = true })

--- I dont disable arrow keys since on a keyboard like crkbd with a different layout like Colemak-DH its actually way easier to use them instead of HJKL
-- Disable arrow keys in normal mode
-- vim.api.nvim_set_keymap('n', '<Up>', '<Nop>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<Down>', '<Nop>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<Left>', '<Nop>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<Right>', '<Nop>', { noremap = true, silent = true })

-- Disable arrow keys in insert mode
-- vim.api.nvim_set_keymap('i', '<Up>', '<Nop>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', '<Down>', '<Nop>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', '<Left>', '<Nop>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', '<Right>', '<Nop>', { noremap = true, silent = true })

-- Disable arrow keys in visual mode
-- vim.api.nvim_set_keymap('v', '<Up>', '<Nop>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('v', '<Down>', '<Nop>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('v', '<Left>', '<Nop>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('v', '<Right>', '<Nop>', { noremap = true, silent = true })

-- Visual Block rebound to Alt+V (since Ctrl+V is paste in my kitty cfg)
vim.keymap.set('n', '<M-v>', '<C-v>', { noremap = true })

-- Clipboard
if vim.fn.has("clipboard") == 1 then
  vim.g.clipboard = {
    name = "wl-clipboard",
    copy = { ["+"] = "wl-copy", ["*"] = "wl-copy" },
    paste = { ["+"] = "wl-paste", ["*"] = "wl-paste" },
    cache_enabled = 1,
  }
end

vim.opt.clipboard = "unnamedplus"

