return {
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = "zathura" -- ou "evince", "okular"
      vim.g.vimtex_compiler_method = "tectonic"
    end,
  },
}
