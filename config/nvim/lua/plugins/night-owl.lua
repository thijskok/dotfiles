return {
  -- Add Night Owl theme
  {
    "oxfist/night-owl.nvim",
    lazy = false, -- Load during startup
    priority = 1000, -- Load before other plugins
  },

  -- Configure LazyVim to use Night Owl
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "night-owl",
    },
  },
}
