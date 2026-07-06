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
  local window = hl.get_active_window() or {}
  local pid = window.pid
  local name = window.title
  local pw_id = helpers.get_pw_node_id(pid)
  hl.notification.create({
    text = name .. ": (pid " .. pid .. ") (pw_id " .. (pw_id or "[null]") .. ")",
    timeout = 10000
  })
end

function M.window_vol(op)
  return function()
    local window = hl.get_active_window() or {}
    local pid = window.pid
    local name = window.title
    local id = helpers.get_pw_node_id(pid)
    local amnt = 3

    os.execute("wpctl set-volume -p " .. pid .. " " .. amnt .. "%" .. op)

    if id ~= nil then
      helpers.notify("node not found")
      return
    end
    local handle = io.popen("wpctl get-volume " .. id)
    if handle == nil then return nil end
    local raw = handle:read("*a")
    handle:close()

    local volume = raw:reverse():match("^(.-) "):reverse():gsub("%s+", "")
    helpers.notify(name .. ": " .. volume .. "%")
  end
end

return M
