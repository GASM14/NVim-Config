-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Colar o conteúdo HTML do clipboard convertido para Markdown
-- Colar o conteúdo HTML do clipboard convertido para Markdown
vim.keymap.set("n", "<leader>ph", function()
  local session = vim.fn.system("echo $XDG_SESSION_TYPE"):gsub("%s+", "")
  local cmd

  if session == "wayland" then
    cmd =
      [[bash -c 'HTML=$(wl-paste -t text/html 2>/dev/null); if [ -n "$HTML" ]; then echo "$HTML" | pandoc -f html -t markdown_strict --wrap=none; else wl-paste -t text/plain | pandoc -f plain -t markdown_strict --wrap=none; fi']]
  else
    cmd =
      [[bash -c 'HTML=$(xclip -o -selection clipboard -t text/html 2>/dev/null); if [ -n "$HTML" ]; then echo "$HTML" | pandoc -f html -t markdown_strict --wrap=none; else xclip -o -selection clipboard -t text/plain | pandoc -f plain -t markdown_strict --wrap=none; fi']]
  end

  vim.fn.execute("read !" .. cmd)
end, { desc = "Paste HTML/Plain as clean Markdown" })
