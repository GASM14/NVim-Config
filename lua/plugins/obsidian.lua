return {
  {
    "epwalsh/obsidian.nvim",
    lazy = true,
    event = { "BufReadPre *.md" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      workspaces = {
        {
          name = "joplin",
          path = "~/Documents/Joplin Notes/Notes MD",
        },
      },
    },
  },
}
