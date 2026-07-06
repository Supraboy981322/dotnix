local json = require("libs.json")
local M = {}

--yes, I know that's kind-of redundant,
--  but it's much less verbose to use
function M.notify(msg, timeout)
  hl.notification.create({ text = msg, timeout = timeout or 2000 })
end

function M.get_pw_node(pid)
  --would be nice if I could do this reliably almost
  --  exclusively in Lua, without it being obscenely slow
  local handle = io.popen("pw-dump -R | jq '[.[] | select(.type == \"PipeWire:Interface:Node\") | select(.info.props.\"application.process.id\" == " .. pid .. ") | select(.info.state == \"running\")] | .[0]'")
  if handle == nil then return nil end
  local raw = handle:read("*a")
  handle:close()

  local ok, foo = pcall(json.decode, raw)
  if ok and foo ~= nil then
    return foo
  elseif not ok then
    M.notify("failed to decode json:\n\t" .. foo)
  else
    M.notify("no window node matching current ID is '.info.state == \"running\"'")
  end

  return nil
end

function M.json_encode(table)
  return json.encode(table)
end
function M.get_nth_line(str, n)
    local line_number = 1
    for line in str:gmatch("([^\r\n]*)\r?\n?") do
        if line_number == n then
            return line
        end
        line_number = line_number + 1
    end
    return nil
end

function M.collect_stdout(cmd)
  local handle = io.popen(cmd)
  if handle == nil then return nil end
  local res = handle:read("*a")
  handle:close()
  return res
end

function M.get_pw_node_id(pid)
  local node = M.get_pw_node(pid)
  if node == nil then return nil end
  return node.id
end

return M
