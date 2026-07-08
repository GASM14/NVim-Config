return {
  "HakonHarnes/img-clip.nvim",
  cmd = "PasteImage",          -- <-- ESSENCIAL!
  opts = {
    default_path = "./_resources",
    relative_to = "file",
    prompt_for_name = true,
    paste_command = "wl-paste",
  },
  keys = {
    { "<leader>i", "<cmd>PasteImage<cr>", desc = "Paste image" },
  },
}
