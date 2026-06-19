-- atlas.nvim — browse and manage GitHub PRs (and optionally Jira/Bitbucket)
-- without leaving the editor.
--
-- Requirements:
--   * Neovim 0.10+
--   * GitHub CLI (`gh`) authenticated via `gh auth login`
--
-- Useful commands:
--   :AtlasPulls          -- open the PR view (use the configured provider)
--   :AtlasPulls mock     -- explore the UI with mock data (no creds needed)
--   :checkhealth atlas   -- verify the setup
return {
  {
    "emrearmagan/atlas.nvim",
    dependencies = {
      "sindrets/diffview.nvim", -- for `gd` / `:DiffviewOpen` PR diffs
    },
    cmd = { "AtlasPulls", "AtlasClearCache", "AtlasLogs" },
    config = function()
      require("atlas").setup({
        pulls = {
          diff = {
            -- Command must accept a range like origin/<dst>...origin/<src>
            open_cmd = "DiffviewOpen",
          },
          providers = {
            github = {
              cache_ttl = 300,

              ---@type AtlasGitHubViewConfig[]
              views = {
                {
                  name = "Product (open)",
                  key = "1",
                  search = "repo:raidium-med/product is:open sort:updated-desc",
                },
                {
                  name = "My PRs",
                  key = "2",
                  search = "author:@me sort:updated-desc",
                },
                {
                  name = "Review requested",
                  key = "3",
                  search = "review-requested:@me sort:updated-desc",
                },
              },
            },
          },
        },
      })
    end,
  },
}
