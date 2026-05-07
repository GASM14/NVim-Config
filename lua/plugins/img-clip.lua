return {
  {
    "HakonHarnes/img-clip.nvim",
    event = "BufReadPost",
    config = function()
      require("img-clip").setup()
    end,
  },
}
