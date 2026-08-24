return {
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	-- Ensure it triggers when you open your Hyprland config
	root_markers = { 'hyprland.lua', '.git' },
	settings = {
		Lua = {
			runtime = { version = 'LuaJIT' },
			workspace = {
				checkThirdParty = false,
				library = {
					-- This injects the Hyprland API stubs
					'/usr/share/hypr/stubs/',
					-- Optional: Injects Neovim's own Lua API for configuring the editor
					vim.env.VIMRUNTIME,
				},
			},
			diagnostics = {
				-- Stop the LSP from complaining that "hl" is an undefined global
				globals = { 'hl' }
			}
		}
	}
}
