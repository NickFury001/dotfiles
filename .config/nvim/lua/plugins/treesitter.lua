return {
	'nvim-treesitter/nvim-treesitter',
	lazy = false,
	build = ':TSUpdate',
	config = function ()
		require('nvim-treesitter').install {
			'lua',
			'json',
			'qmljs',
			'java',
			'markdown',
			'markdown_inline'
		}
	end
}
