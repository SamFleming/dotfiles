local ts = require('nvim-treesitter')

-- Install the parser on first use of a filetype, then highlight with it.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang then return end

    local start = function() pcall(vim.treesitter.start, ev.buf, lang) end
    if vim.list_contains(ts.get_installed(), lang) or not vim.list_contains(ts.get_available(), lang) then
      -- Fails when no parser exists for the filetype; regex syntax stays on then.
      return start()
    end
    ts.install(lang):await(vim.schedule_wrap(function()
      if vim.api.nvim_buf_is_valid(ev.buf) then start() end
    end))
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argv(0) == "" then
      require("telescope.builtin").find_files()
    end
  end,
})
