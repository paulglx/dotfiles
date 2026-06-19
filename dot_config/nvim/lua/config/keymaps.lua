-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Open Claude Code in a vertical split on the right
vim.keymap.set("n", "<leader>ac", function()
  vim.cmd("botright vsplit")
  vim.cmd("terminal claude")
  vim.cmd("startinsert")
end, { desc = "Open Claude Code (right split)" })

-- Open Lazygit in a new tab instead of a floating window
-- vim.keymap.set("n", "<leader>gg", function()
--   vim.cmd("tabnew")
--   vim.fn.termopen("lazygit", {
--     on_exit = function()
--       vim.schedule(function()
--         if vim.api.nvim_buf_is_valid(0) then
--           vim.cmd("tabclose")
--         end
--       end)
--     end,
--   })
--   vim.cmd("startinsert")
-- end, { desc = "Lazygit (tab)" })
