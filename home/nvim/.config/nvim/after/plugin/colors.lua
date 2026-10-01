require("catppuccin").setup({ background = { light = "latte", dark = "frappe" } })

function ColorMyPencils(color)
	vim.cmd.colorscheme(color or "catppuccin")

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()

-- Nvim re-queries the terminal on a light/dark switch and updates 'background'.
vim.api.nvim_create_autocmd("OptionSet", {
	pattern = "background",
	callback = function() ColorMyPencils() end,
})
