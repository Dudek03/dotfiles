return {
  "scottmckendry/cyberdream.nvim",
  priority = 1000,
  config = function()
    vim.g.cyberdream_transparent = false

    require("cyberdream").setup({
      transparent = vim.g.cyberdream_transparent,
    })

    vim.cmd("colorscheme cyberdream")

    -- Toggle transparency
    local bg_transparent = vim.g.cyberdream_transparent

    function ToggleTransparency()
      bg_transparent = not bg_transparent
      vim.g.cyberdream_transparent = bg_transparent
      require("cyberdream").setup({
        transparent = bg_transparent,
      })
      vim.cmd("colorscheme cyberdream")
    end

    vim.keymap.set("n", "<leader>bg", ToggleTransparency, { desc = "Toggle background transparency" })
  end,
}
