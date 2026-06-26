local json = require("libs.json")
local M = {}

function M.get_pw_node(pid)
  local handle = io.popen("pw-dump -R")
  if handle == nil then return nil end
  local raw = handle:read("*a")
  handle:close()

  local pid_pattern = '"application.process.id": ' .. pid .. ","

  local res = "["
  while raw:match(pid_pattern) ~= nil do
    local id_start, id_end = raw:find(pid_pattern)
    local _, start = raw:sub(0, id_start):reverse():find(('{"id": '):reverse())
    res = res .. assert(raw:sub(id_start - start+1, id_start-2))
    local obj_end = raw:sub(id_start - start+1, -1):find(',{"id": %d+,')
    res = res .. assert(raw:sub(id_end, id_start - start + obj_end))
    raw = raw:sub(id_start - start + obj_end-3, -1)
  end
  res = res:sub(0, -2) .. "]"
  if res:match("PipeWire:Interface:Node") == nil then return nil end

  for _, node in ipairs(json.decode(res)) do
    if node.type == "PipeWire:Interface:Node" then return node end
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

return M
