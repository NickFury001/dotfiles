return {
	cmd = { 'rust-analyzer' },
	filetypes = { 'rust' },
	root_markers = { 'Cargo.toml' },

	settings = {
		['rust-analyzer'] = {
			diagnostics = {
				enable = true,
				experimental = {
					enable = true,
				},
			},
			-- Run Clippy instead of cargo check
			check = {
				command = 'clippy',
			},
			cargo = {
				-- Prevents rust-analyzer from locking target/ and blocking your terminal builds
				targetDir = true,
			},
			inlayHints = {
				-- Keep only what helps without cluttering the screen
				typeHints = { enable = true },
				parameterHints = { enable = true },
				chainingHints = { enable = true },
			},
		},
	},
}
