-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Inside lua/config/keymaps.lua, replace the whole '<leader>ph' map with:
vim.keymap.set("n", "<leader>ph", function()
  local session = vim.fn.system("echo $XDG_SESSION_TYPE"):gsub("%s+", "")
  local cmd

  if session == "wayland" then
    cmd =
      [[bash -c 'HTML=$(wl-paste -t text/html 2>/dev/null); if [ -n "$HTML" ]; then echo "$HTML" | sed -E "s/ (style|class|id)=\"[^\"]*\"//g; s/<span[^>]*>//g; s/<\/span>//g; s/<div[^>]*>/<div>/g; s/<p[^>]*>/<p>/g" | pandoc -f html -t gfm --wrap=none; else wl-paste -t text/plain | pandoc -f plain -t gfm --wrap=none; fi']]
  else
    cmd =
      [[bash -c 'HTML=$(xclip -o -selection clipboard -t text/html 2>/dev/null); if [ -n "$HTML" ]; then echo "$HTML" | sed -E "s/ (style|class|id)=\"[^\"]*\"//g; s/<span[^>]*>//g; s/<\/span>//g; s/<div[^>]*>/<div>/g; s/<p[^>]*>/<p>/g" | pandoc -f html -t gfm --wrap=none; else xclip -o -selection clipboard -t text/plain | pandoc -f plain -t gfm --wrap=none; fi']]
  end

  vim.fn.execute("read !" .. cmd)
end, { desc = "Paste HTML/Plain as clean GFM Markdown" })

-- Atalhos para transformar a linha atual em cabeçalho Markdown
vim.keymap.set("n", "<leader>h1", "I# <Esc>", { desc = "Make current line H1" })
vim.keymap.set("n", "<leader>h2", "I## <Esc>", { desc = "Make current line H2" })
vim.keymap.set("n", "<leader>h3", "I### <Esc>", { desc = "Make current line H3" })
vim.keymap.set("n", "<leader>h4", "I#### <Esc>", { desc = "Make current line H4" })
vim.keymap.set("n", "<leader>h5", "I##### <Esc>", { desc = "Make current line H5" })
