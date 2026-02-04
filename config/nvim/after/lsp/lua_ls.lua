-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

return {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path ~= vim.fn.stdpath 'config'
        and (vim.uv.fs_stat(vim.fs.joinpath(path, '.luarc.json'))
        or vim.uv.fs_stat(vim.fs.joinpath(path, '.luarc.jsonc')))
      then
        return
      end
    end
    local cfg = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT',
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          '${3rd}/luv/library',
        },
      },
    })
    client.config.settings.Lua = cfg
  end,
  settings = { Lua = {} },
}
