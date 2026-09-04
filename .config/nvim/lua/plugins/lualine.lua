local function arch_btw()
	return '  Arch'
end

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- Helper to get a highlight color safely
    local function get_hl(name, attr)
      local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
      if hl[attr] then
        return string.format('#%06x', hl[attr])
      end
      return nil
    end

    local colors = {
      -- Fallbacks in case a highlight group is missing
      bg     = get_hl('Normal', 'bg') or '#1e1e2e',
      fg     = get_hl('Normal', 'fg') or '#cdd6f4',
      violet = get_hl('Statement', 'fg') or get_hl('Keyword', 'fg') or '#cba6f7',
      blue   = get_hl('Function', 'fg') or get_hl('Directory', 'fg') or '#89b4fa',
      cyan   = get_hl('String', 'fg') or get_hl('Character', 'fg') or '#94e2d5',
      red    = get_hl('Error', 'fg') or get_hl('DiagnosticError', 'fg') or '#f38ba8',
      grey   = get_hl('Comment', 'fg') or '#6c7086',
      black  = get_hl('Normal', 'bg') or '#11111b',
    }

    local bubbles_theme = {
      normal = {
        a = { fg = colors.black, bg = colors.violet },
        b = { fg = colors.fg, bg = colors.grey },
        c = { fg = colors.fg, bg = colors.bg },
      },
      insert = {
        a = { fg = colors.black, bg = colors.blue },
      },
      visual = {
        a = { fg = colors.black, bg = colors.cyan },
      },
      replace = {
        a = { fg = colors.black, bg = colors.red },
      },
      inactive = {
        a = { fg = colors.fg, bg = colors.bg },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
      },
    }

    require('lualine').setup {
      options = {
        theme = bubbles_theme,
        component_separators = '',
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {
	  arch_btw,
          { 'mode', arch_btw, separator = { left = '' }, right_padding = 2 },
        },
        lualine_b = { 'filename', 'branch' },
        lualine_c = { '%=' },
        lualine_x = {},
        lualine_y = { 'filetype', 'progress' },
        lualine_z = {
          { 'location', separator = { right = '' }, left_padding = 2 },
        },
      },
      inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'location' },
      },
      tabline = {},
      extensions = {},
    }
  end,
}
