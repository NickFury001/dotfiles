-- Get the absolute path to your lua/config/lsp directory
local lsp_dir_path = vim.fn.stdpath("config") .. "/lua/lsp"

-- Check if the directory exists before attempting to read it
if vim.fn.isdirectory(lsp_dir_path) == 1 then
  -- Loop through every file in the directory
  for _, file in ipairs(vim.fn.readdir(lsp_dir_path)) do
    -- Match only .lua files
    if file:match("%.lua$") then
      -- Extract the server name from the filename (e.g., "qml.lua" becomes "qml")
      local server_name = file:gsub("%.lua$", "")
      
      -- Safely require the config file module
      local ok, config = pcall(require, "lsp." .. server_name)
      
      if ok and type(config) == "table" then
        -- Register the configuration and enable the language server natively
        vim.lsp.config(server_name, config)
        vim.lsp.enable(server_name)
      end
    end
  end
end

-- Automatically show autocompletes
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method('textDocument/completion') then
      -- Enable auto-trigger completion
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})

-- Recommended options for visual layout
vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
