local helpers = require("helpers")

local M = {}

function M.mute_window()
  local pid = hl.get_active_window().pid
  local name = hl.get_active_window().title
  local muted = (function()
    local node = helpers.get_pw_node(pid)
    if node == nil then return nil end
    for _, thing in ipairs(node.info.params.Props) do
      if thing.mute ~= nil then
        return thing.mute
      end
    end
    return nil
  end)()
  if muted == nil then return end
  os.execute("wpctl set-mute -p " .. pid .. " toggle")
  local msg = (function()
    local res = "muted: " .. name .. " (" .. pid .. ")"
    if muted then --will make muted
      res = "un" .. res
    end
    return res
  end)()
  hl.notification.create({ text = msg, timeout = 2000 })
end

function M.popup_pid()
  local pid = hl.get_active_window().pid
  local name = hl.get_active_window().title
  hl.notification.create({ text = name .. ": " .. pid, timeout = 10000 })
end

return M
