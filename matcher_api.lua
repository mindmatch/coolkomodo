local headers = {}
headers['Content-Type'] = 'application/json'

function read_file(file)
  local f = assert(io.open(file, "rb"))
  local content = f:read("*all")
  f:close()
  return content
end

function read_files(file_paths)
  local files = {}
  for _,file_path in ipairs(file_paths) do
    table.insert(files, read_file(file_path))
  end
  return files
end

function ls(dir)
  local file_paths = {}
  local p = io.popen('find "'..dir..'" -type f')
  for file_path in p:lines() do
    table.insert(file_paths, file_path)
  end
  return file_paths
end

function len(list)
  local count = 0
  for _ in pairs(list) do
    count = count + 1
  end
  return count
end

function render(template, env)
  return string.format(template, unpack(env))
end

local position_paths = ls('./data/enriched/positions')
local positions = read_files(position_paths)
local position_count = len(position_paths)
local resume_paths = ls('./data/enriched/resumes')
local resumes = read_files(resume_paths)
local resume_count = len(resume_paths)

local template = '{"resume": %s, "position": %s}'

request = function()
  local path = "/match"

  local resume = resumes[math.random(1, resume_count)]
  local position = positions[math.random(1, position_count)]
  local bindings = {resume, position}
  local body = render(template, bindings)
  return wrk.format("POST", path, headers, body)
end
