-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Inside lua/config/keymaps.lua, replace the whole '<leader>ph' map with:
-- Colar HTML do clipboard convertido para Markdown (script externo)
vim.keymap.set("n", "<leader>ph", ":read !html2md<CR>", { desc = "Paste HTML as Markdown (via html2md script)" })
vim.keymap.set("n", "<leader>pt", ":read !html2md_turndown<CR>", { desc = "Paste HTML as Markdown (turndown)" })
vim.keymap.set("n", "<leader>O", ":put =''<CR>", { desc = "Insert blank line below, stay in Normal" })

-- Atalhos para cabeçalhos Markdown
vim.keymap.set("n", "<leader>h1", "I# <Esc>", { desc = "Make current line H1" })
vim.keymap.set("n", "<leader>h2", "I## <Esc>", { desc = "Make current line H2" })
vim.keymap.set("n", "<leader>h3", "I### <Esc>", { desc = "Make current line H3" })
vim.keymap.set("n", "<leader>h4", "I#### <Esc>", { desc = "Make current line H4" })
vim.keymap.set("n", "<leader>h5", "I##### <Esc>", { desc = "Make current line H5" })

-- Exportar em PDF
vim.keymap.set("n", "<leader>ep", function()
  local file = vim.fn.expand("%")
  local pdf = vim.fn.expand("%:r") .. ".pdf"
  local dir = vim.fn.expand("%:p:h")
  local layout_file = dir .. "/layout.tex"
  local lua_filter = dir .. "/figure.lua"
  local extra_args = ""

  -- layout.tex
  if vim.fn.filereadable(layout_file) == 1 then
    extra_args = extra_args .. " --include-in-header=" .. vim.fn.shellescape(layout_file)
  end
  -- figura.lua
  if vim.fn.filereadable(lua_filter) == 1 then
    extra_args = extra_args .. " --lua-filter=" .. vim.fn.shellescape(lua_filter)
  end

  -- Mudar para a pasta do ficheiro (para imagens com caminhos relativos)
  vim.cmd("lcd " .. vim.fn.fnameescape(dir))

  -- Executar o Pandoc com XeLaTeX + os extras
  local cmd = "!pandoc " .. vim.fn.shellescape(file) .. " -o " .. vim.fn.shellescape(pdf) .. " --pdf-engine=xelatex" .. extra_args
  vim.cmd(cmd)

  vim.notify("PDF gerado: " .. pdf, vim.log.levels.INFO)
  vim.fn.jobstart({"xdg-open", pdf}, {detach = true})
end, { desc = "Exportar MD para PDF (imagens fixas)" })
