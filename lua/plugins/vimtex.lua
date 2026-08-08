return {
  "lervag/vimtex",
  lazy = false,
  init = function()
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
      options = {
        "-pdf",
        "-interaction=nonstopmode",
        "-synctex=1",
        "-outdir=.build",
      },
    }

    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_quickfix_mode = 2
    vim.g.vimtex_quickfix_open_on_warning = 0

    -- Hook: copia o PDF + SyncTeX da .build para a raiz após compilação COM SUCESSO
    vim.api.nvim_create_autocmd("User", {
      pattern = "VimtexEventCompileSuccess",
      callback = function()
        local base_name = vim.fn.expand("%:t:r")
        local pdf_name = base_name .. ".pdf"
        local synctex_name = base_name .. ".synctex.gz"

        local build_pdf = ".build/" .. pdf_name
        local build_synctex = ".build/" .. synctex_name

        if vim.fn.filereadable(build_pdf) == 1 then
          vim.fn.system({ "cp", "-f", build_pdf, pdf_name })
          if vim.fn.filereadable(build_synctex) == 1 then
            vim.fn.system({ "cp", "-f", build_synctex, synctex_name })
          end
          vim.notify("PDF copiado para a raiz!", vim.log.levels.INFO)
        end
      end,
    })
  end,
  config = function()
    -- Abre o PDF da raiz no Zathura com SyncTeX
    vim.api.nvim_create_user_command("VimtexView", function()
      local pdf = vim.fn.expand("%:t:r") .. ".pdf"
      if vim.fn.filereadable(pdf) == 1 then
        local line = vim.fn.line(".")
        local file = vim.fn.expand("%:p")
        vim.fn.jobstart({ "zathura", "--synctex-forward", line .. ":0:" .. file, pdf }, { detach = true })
      else
        vim.notify("PDF não encontrado na raiz. Compila primeiro com \\ll", vim.log.levels.WARN)
      end
    end, { force = true })
  end,
}
