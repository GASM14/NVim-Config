-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Inside lua/config/keymaps.lua, replace the whole '<leader>ph' map with:
vim.keymap.set("n", "<leader>ph", function()
  local session = vim.fn.system("echo $XDG_SESSION_TYPE"):gsub("%s+", "")
  local cmd

  if session == "wayland" then
    cmd =
      [[bash -c 'HTML=$(wl-paste -t text/html 2>/dev/null); if [ -n "$HTML" ]; then echo "$HTML" | pandoc -f html -t markdown_strict --wrap=none; else wl-paste -t text/plain | pandoc -f plain -t markdown_strict --wrap=none; fi']]
  elseif session == "x11" then
    cmd =
      [[bash -c 'HTML=$(xclip -o -selection clipboard -t text/html 2>/dev/null); if [ -n "$HTML" ]; then echo "$HTML" | pandoc -f html -t markdown_strict --wrap=none; else xclip -o -selection clipboard -t text/plain | pandoc -f plain -t markdown_strict --wrap=none; fi']]
  else
    -- macOS or other (assumes pbpaste for plain text; HTML is not easily accessible via CLI)
    cmd = [[bash -c 'pbpaste | pandoc -f plain -t markdown_strict --wrap=none']]
  end

  vim.fn.execute("read !" .. cmd)
end, { desc = "Paste HTML/Plain as clean Markdown" })
