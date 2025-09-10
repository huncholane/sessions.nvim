-- Unique session
local function getsessionfile()
	local cwd = vim.fn.getcwd()
	local hash = vim.fn.sha256(cwd)
	local sessiondir = vim.fn.stdpath("data") .. "/sessions"
	if vim.fn.isdirectory(sessiondir) == 0 then
		vim.fn.mkdir(sessiondir, "p")
	end
	return sessiondir .. "/" .. hash .. ".vim"
end

local sessionfile = getsessionfile()

-- Save session
local function save_session()
	vim.schedule(function()
		vim.cmd("mksession! " .. vim.fn.fnameescape(sessionfile))
	end)
end

-- Restore session
local function restore_session()
	if vim.fn.filereadable(sessionfile) == 1 then
		vim.cmd("source " .. vim.fn.fnameescape(sessionfile))
		vim.cmd("doautocmd BufReadPost")
	end
end

return {
	setup = function()
		vim.o.sessionoptions = "curdir,folds,tabpages,winsize,buffers"
		vim.o.undofile = true
		-- Autocmd: save on write
		vim.api.nvim_create_autocmd({ "BufWritePost", "VimLeavePre" }, {
			callback = save_session,
		})

		-- Optional: auto-restore on start
		vim.api.nvim_create_autocmd("VimEnter", {
			once = true,
			callback = restore_session,
		})
	end,
}
