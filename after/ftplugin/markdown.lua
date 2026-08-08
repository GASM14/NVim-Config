-- Exportar Markdown para PDF (pandoc + xelatex)
vim.keymap.set("n", "<leader>mp", function()
  local md = vim.fn.expand("%:p")
  local pdf = vim.fn.expand("%:p:r") .. ".pdf"
  vim.cmd("!pandoc " .. vim.fn.shellescape(md) ..
    " -o " .. vim.fn.shellescape(pdf) ..
    " --pdf-engine=xelatex -V geometry:margin=1in -V fontsize=11pt")
  vim.notify("PDF gerado: " .. pdf, vim.log.levels.INFO)
end, { buffer = true, desc = "Export Markdown to PDF" })

-- Atalho extra: abrir o PDF gerado
vim.keymap.set("n", "<leader>mv", function()
  local pdf = vim.fn.expand("%:p:r") .. ".pdf"
  vim.cmd("!xdg-open " .. vim.fn.shellescape(pdf) .. " &")
end, { buffer = true, desc = "Open generated PDF" })
