-- Manually disable oxfmt so prettier (or the next formatter in conform's
-- per-filetype list) wins. LazyVim's defaults put oxfmt ahead of prettier
-- for JS/TS, which causes formatting conflicts when both are installed via
-- Mason. Marking oxfmt's `condition` as always-false makes conform treat it
-- as unavailable everywhere and fall through to the next formatter, without
-- having to enumerate every affected filetype.
return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}
      opts.formatters.oxfmt = {
        condition = function()
          return false
        end,
      }
    end,
  },
}
