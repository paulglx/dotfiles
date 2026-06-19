-- Point pyright (and basedpyright, if it ends up active via the LazyVim
-- python extra) at the project's uv-managed `.venv/bin/python`.
--
-- The autocmd in `lua/config/autocmds.lua` already exports VIRTUAL_ENV / PATH
-- so ruff, mypy, pytest, the debugger, terminals, etc. all use the venv.
-- Pyright doesn't reliably pick that up on its own, hence this explicit wire.

local function venv_python_for(root_dir)
  if not root_dir or root_dir == "" then
    return nil
  end
  local venv = root_dir .. "/.venv"
  if vim.fn.isdirectory(venv) == 1 then
    return venv .. "/bin/python"
  end
  return nil
end

local function before_init(_, config)
  local py = venv_python_for(config.root_dir)
  if not py then
    return
  end
  config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
    python = { pythonPath = py },
  })
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          before_init = before_init,
        },
        -- LazyVim's python extra ships basedpyright; keep it wired the same
        -- way so this Just Works whichever one is the active server.
        basedpyright = {
          before_init = before_init,
        },
      },
    },
  },
}
