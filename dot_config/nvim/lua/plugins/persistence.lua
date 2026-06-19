return {
  "folke/persistence.nvim",
  opts = {},
  init = function()
    vim.api.nvim_create_autocmd("StdinReadPre", {
      group = vim.api.nvim_create_augroup("persistence_stdin", { clear = true }),
      callback = function()
        vim.g.started_with_stdin = true
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      group = vim.api.nvim_create_augroup("persistence_autoload", { clear = true }),
      once = true,
      nested = true,
      callback = function()
        -- Only try to auto-load when nvim was launched with no file args
        -- and nothing was piped in via stdin.
        if vim.fn.argc() ~= 0 or vim.g.started_with_stdin then
          return
        end

        -- Try to load the session for the current directory.
        pcall(require("persistence").load)

        -- If no session was actually restored, fall through to the
        -- LazyVim dashboard so we still get the welcome screen.
        if vim.v.this_session == "" then
          local ok, dashboard = pcall(require, "snacks.dashboard")
          if ok then
            dashboard.open()
          else
            -- Fallback for older LazyVim setups that use alpha-nvim.
            pcall(vim.cmd, "Alpha")
          end
        end
      end,
    })
  end,
}
