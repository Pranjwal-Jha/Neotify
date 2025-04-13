local M = {}

local current_string_status = ""
local loop_status_string = "No Loop"

local function shell(cmd)
  local handle = io.popen(cmd .. " 2>/dev/null")
  if not handle then
    vim.notify("Error running the command : " .. cmd, vim.log.levels.ERROR, { title = "Neotify" })
    return nil
  end

  local result = handle:read "*a"
  handle:close()

  -- Trim Whitespace
  result = result:match "^%s*(.-)%s*$"
  if result == "" then return nil end
  return result
end

function M.get_current_song_info()
  local cmd = "playerctl --player=spotify metadata --format '{{title}} - {{artist}}'"
  local info = shell(cmd)
  return info
end

function M.update_display_info()
  local song_info = M.get_current_song_info()
  if song_info then
    current_string_status = "🎵 " .. song_info
    vim.notify(current_string_status, vim.log.levels.INFO, { title = "Now Playing" })
  else
    current_string_status = ""
    vim.notify("No Song Playing Currently", vim.log.levels.INFO, { title = "Now Playing" })
  end
end

function M.get_status_string()
  print("--- Neotify: get_status_string() called, returning: '" .. current_string_status .. "' ---")
  return current_string_status
end

function M.play_pause()
  vim.notify("Toggling Play/Pause", vim.log.levels.INFO, { title = "Neotify" })
  shell "playerctl --player=spotify play-pause"
  M.update_display_info()
end

function M.next_track()
  vim.notify("Skipping to Next Track", vim.log.levels.INFO, { title = "Neotify" })
  shell "playerctl --player=spotify next"
  vim.defer_fn(function() M.update_display_info() end, 1500)
end

function M.previous_track()
  vim.notify("Going to Previous Track", vim.log.levels.INFO, { title = "Neotify" })
  shell "playerctl --player=spotify previous"
  vim.defer_fn(function() M.update_display_info() end, 1500)
end

function M.track_loop_playlist()
  vim.notify("Looping the current song", vim.log.levels.INFO, { title = "Neotify" })
  shell "playerctl --player=spotify loop Track"
  loop_status_string = "Looping Current Song"
  --M.update_display_info()
end

function M.cancel_loop_playlist()
  vim.notify("Looping Stopped", vim.log.levels.INFO, { title = "Neotify" })
  shell "playerctl --player=spotify loop none"
  loop_status_string = "No Loop"
  --M.update_display_info()
end

function M.like_current_song()
  vim.notify("Added to Liked Songs !", vim.log.levels.INFO, { title = "Neotify" })
  shell "spotify_player like"
  M.update_display_info()
end

function M.unlike_current_song()
  vim.notify("Unliked the current song", vim.log.levels.INFO, { title = "Neotify" })
  shell "spotify_player like -u"
  M.update_display_info()
end

function M.manual_update_notify()
  vim.notify(loop_status_string, vim.log.levels.INFO, { title = "Looping Status" })
  M.update_display_info()
end

function M.setup()
  vim.api.nvim_set_keymap(
    "n",
    "<leader>mp",
    "<cmd>lua require('neotify').play_pause()<CR>",
    { noremap = true, silent = true, desc = "Neotify : Play/Pause" }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<leader>mk",
    "<cmd>lua require('neotify').next_track()<CR>",
    { noremap = true, silent = true, desc = "Neotify : Next" }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<leader>mj",
    "<cmd>lua require('neotify').previous_track()<CR>",
    { noremap = true, silent = true, desc = "Neotify : Previous" }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<leader>mt",
    "<cmd>lua require('neotify').track_loop_playlist()<CR>",
    { noremap = true, silent = true, desc = "Neotify : Looping Track" }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<leader>mc",
    "<cmd>lua require('neotify').cancel_loop_playlist()<CR>",
    { noremap = true, silent = true, desc = "Neotify : Looping Ended" }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<leader>mi",
    "<cmd>lua require('neotify').manual_update_notify()<CR>",
    { noremap = true, silent = true, desc = "Neotify : Update Song Info" }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<leader>ml",
    "<cmd>lua require('neotify').like_current_song()<CR>",
    { noremap = true, silent = true, desc = "Neotify : Liking the current song" }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<leader>mu",
    "<cmd>lua require('neotify').unlike_current_song()<CR>",
    { noremap = true, silent = true, desc = "Neotify : Unliking the current song" }
  )
  --M.update_display_info()
  --vim.notify("Neotify setup complete, Initial song info fetched.", vim.log.levels.INFO, { title = "Neotify" })
end

return M
