-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- ---------------------------------------------------------------------------
-- Auto-activate the project's uv venv for Python buffers.
--
-- Walks up from the current file to find a project root (pyproject.toml,
-- uv.lock, .venv, or .git), and if a `.venv` directory exists there, exports
-- VIRTUAL_ENV / prepends the venv bin to PATH / sets python3_host_prog.
--
-- That covers every subprocess nvim spawns: ruff, mypy, pytest, debuggers,
-- `:!python`, terminal toggles, etc. The LSP-specific wiring lives in
-- `lua/plugins/python-venv.lua`.
-- ---------------------------------------------------------------------------

local venv_cache = {} ---@type table<string, boolean>

local function activate_uv_venv(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  if fname == "" then
    return
  end

  local root = vim.fs.root(bufnr, { "pyproject.toml", "uv.lock", ".venv", ".git" })
  if not root then
    return
  end

  local venv = root .. "/.venv"
  if vim.fn.isdirectory(venv) == 0 then
    return
  end

  if venv_cache[venv] then
    return
  end
  venv_cache[venv] = true

  vim.env.VIRTUAL_ENV = venv
  -- Avoid stacking duplicate entries on PATH if the same venv is re-activated.
  local bin = venv .. "/bin"
  if not (vim.env.PATH or ""):match(vim.pesc(bin) .. ":") then
    vim.env.PATH = bin .. ":" .. vim.env.PATH
  end
  vim.g.python3_host_prog = venv .. "/bin/python"
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "FileType" }, {
  group = vim.api.nvim_create_augroup("uv_venv_activate", { clear = true }),
  pattern = { "*.py", "python", "pyproject.toml", "*.pyi" },
  callback = function(args)
    activate_uv_venv(args.buf)
  end,
})

-- LazyVim loads this file on VeryLazy, which fires *after* BufReadPost for the
-- file passed on the command line. Catch up any Python buffers that are
-- already loaded so the venv activates on the very first file too.
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if vim.api.nvim_buf_is_loaded(buf) then
    local ft = vim.bo[buf].filetype
    local name = vim.api.nvim_buf_get_name(buf)
    if ft == "python" or name:match("%.py$") or name:match("%.pyi$") or name:match("pyproject%.toml$") then
      activate_uv_venv(buf)
    end
  end
end

-- Manual escape hatch: `:UvVenvActivate` re-runs activation for the current
-- buffer. Useful for debugging or for filetypes outside the autocmd pattern.
vim.api.nvim_create_user_command("UvVenvActivate", function()
  venv_cache = {} -- clear cache so we re-detect
  activate_uv_venv(vim.api.nvim_get_current_buf())
  print("VIRTUAL_ENV = " .. tostring(vim.env.VIRTUAL_ENV))
end, { desc = "Activate the project's uv venv for the current buffer" })
