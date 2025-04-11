return {
  dir = vim.fn.stdpath "config" .. "/lua/", -- Path to local plugin directory

  name = "neotify", -- optional, but useful for display in Lazy UI

  version = false, -- not a git repo

  lazy = false,

  config = function()
    local success, neotify_module = pcall(require, "neotify")
    if success then
      neotify_module.setup()
    else
      print "--- ERROR: Failed to require 'neotify' in lazy config ---"
    end
  end,
}
