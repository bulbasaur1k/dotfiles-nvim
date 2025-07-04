local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.mini" },
    { import = "plugins.snacks" },
  },
  install = {
    colorscheme = { "tokyonight" },
  },
  defaults = {
    lazy = true,
    version = false,
  },
  checker = {
    enabled = true,
  },
  timeout = 300,
  ui = {
    backdrop = 100,
    border = require("util.ui").border,
  },
  pkg = {
    sources = {
      "lazy",
      "packspec",
    },
  },
})
