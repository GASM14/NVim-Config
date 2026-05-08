-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Inside lua/config/keymaps.lua, replace the whole '<leader>ph' map with:
-- Colar HTML do clipboard convertido para Markdown (script externo)
vim.keymap.set("n", "<leader>ph", ":read !html2md<CR>", { desc = "Paste HTML as Markdown (via html2md script)" })
vim.keymap.set("n", "<leader>pt", ":read !html2md_turndown<CR>", { desc = "Paste HTML as Markdown (turndown)" })

-- Atalhos para cabeçalhos Markdown
vim.keymap.set("n", "<leader>h1", "I# <Esc>", { desc = "Make current line H1" })
vim.keymap.set("n", "<leader>h2", "I## <Esc>", { desc = "Make current line H2" })
vim.keymap.set("n", "<leader>h3", "I### <Esc>", { desc = "Make current line H3" })
vim.keymap.set("n", "<leader>h4", "I#### <Esc>", { desc = "Make current line H4" })
vim.keymap.set("n", "<leader>h5", "I##### <Esc>", { desc = "Make current line H5" })
