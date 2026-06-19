-- lsp-lens.nvim — shows reference counts above functions/methods, like JB's IDEA.
-- https://github.com/VidocqH/lsp-lens.nvim
return {
  "VidocqH/lsp-lens.nvim",
  event = "LspAttach",
  opts = {
    enable = true, -- show lens immediately when LSP attaches
    sections = {
      definition = false,
      references = true, -- only references are enabled
      implements = false,
      git_authors = false,
    },
  },
}
