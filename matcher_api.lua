local headers = {}
headers['Content-Type'] = 'application/json'

local function read_file(file)
  local f = assert(io.open(file, "rb"))
  local content = f:read("*all")
  f:close()
  return content
end

local function render(template, env)
  return string.format(template, unpack(env))
end

local positions = {'./data/enriched/positions/elixir.json'}
local resumes = {'./data/enriched/resumes/elixir.json'}

local template = '{"resume": %s, "position": %s}'

request = function()
  local path = "/match"

  local resume = read_file(resumes[1])
  local position = read_file(positions[1])
  local bindings = {resume, position}
  local body = render(template, bindings)
  return wrk.format("POST", path, headers, body)
end
