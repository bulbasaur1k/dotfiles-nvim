-- config/options.lua
local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

opt.autowrite = true -- Enable auto write
opt.breakindent = true
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cmdheight = 0
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.fileencoding = "utf-8"
opt.fileencodings = "ucs-bom,utf-8,default,latin1" -- Попытаться прочитать в этих кодировках, в данном порядке

-- *** УДАЛИТЕ ИЛИ ЗАКОММЕНТИРУЙТЕ ЭТИ ДВЕ СТРОКИ ***
-- vim.opt.backup = false      -- не создавать файлы filename~
-- vim.opt.writebackup = false -- не создавать временные копии при записи

opt.foldenable = true
opt.foldexpr = "v:lua.require('util.ui').foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldmethod = "expr"
opt.foldtext = ""
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 3 -- global statusline
opt.mouse = "" -- Enable mouse mode
opt.number = true -- Print line number
opt.numberwidth = 1
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.showtabline = 0
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.smoothscroll = true
-- opt.spelllang = "en"
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.swapfile = false -- Вы, вероятно, хотите оставить swapfile = false, так как он может засорять директории, и undo-файлы (undofile = true) обычно достаточны для восстановления.
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 300
opt.undofile = true -- Включено постоянное undo (сохраняется в undodir)
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap
opt.whichwrap = "<,>,[,],h,l"
opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = " ",
	eob = " ",
}
