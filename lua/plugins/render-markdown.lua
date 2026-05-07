echo 'return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      completions = {
        blink = {
          enabled = true,
        },
      },
    },
    ft = { "markdown" },
  },
}' > ~/.config/nvim/lua/plugins/render-markdown.lua
