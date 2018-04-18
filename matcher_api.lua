require('lib/helpers')

local headers = {}
headers['Content-Type'] = 'application/json'

local position_paths = ls('./data/enriched/positions')
local positions = read_files(position_paths)
local position_count = len(position_paths)
local resume_paths = ls('./data/enriched/resumes')
local resumes = read_files(resume_paths)
local resume_count = len(resume_paths)

local path = "/match"
local template = '{"resume": %s, "position": %s}'

request = function()
  local resume = resumes[math.random(1, resume_count)]
  local position = positions[math.random(1, position_count)]
  local bindings = {resume, position}
  local body = render(template, bindings)
  return wrk.format("POST", path, headers, body)
end
