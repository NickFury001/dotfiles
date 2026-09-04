return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "moon", -- storm, night, moon, day
    })
    vim.cmd.colorscheme("tokyonight")
  end,
}
