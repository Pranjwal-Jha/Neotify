local M = {}

local function shell(cmd)
  local handle = io.popen(cmd)
  local result = handle:read "*a"
  handle:close()
  return result
end

function M.play_pause()
  vim.notify("Toggling Play/Pause", vim.log.levels.INFO, { title = "Neotify" })
  shell "playerctl --player=spotifyd play-pause"
end

function M.next_track()
  vim.notify("Skipping to Next Track", vim.log.levels.INFO, { title = "Neotify" })
  shell "playerctl --player=spotifyd next"
end

function M.previous_track()
  vim.notify("Going to Previous Track", vim.log.levels.INFO, { title = "Neotify" })
  shell "playerctl --player=spotifyd previous"
end

function M.setup()
  vim.api.nvim_set_keymap(
    "n",
    "<leader>mp",
    "<cmd>lua require('neotify').play_pause()<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<leader>mn",
    "<cmd>lua require('neotify').next_track()<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<leader>mb",
    "<cmd>lua require('neotify').previous_track()<CR>",
    { noremap = true, silent = true }
  )
end

return M
