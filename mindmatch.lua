require('lib/helpers')

local headers = {}
headers['Content-Type'] = 'application/json'
headers['Accept'] = 'application/json'
headers['Authorization'] = string.format(
  'Bearer %s',
  (os.getenv('MINDMATCH_TOKEN') or 'secret')
)

local path = "/graphql"

local create_match_query = [===[
{
  "query":"mutation ($companies: [CompanyInput], $people: [PersonInput]) { createMatch( input: { companies: $companies, people: $people }) { id } }",
  "variables":{"companies": [%s], "people": [%s]}
}
]===]

local get_match_query = [===[
{
  "query":"query ($id: String!) { getMatch(id: $id) { status results { score } } }",
  "variables":{ "id": %q }
}
]===]

local position_paths = ls('./data/basic/positions')
local positions = read_files(position_paths)
local position_count = len(position_paths)

local resume_paths = ls('./data/basic/resumes')
local resumes = read_files(resume_paths)
local resume_count = len(resume_paths)

local x = "%x"
local uuid_pattern = table.concat({ x:rep(8), x:rep(4), x:rep(4), x:rep(4), x:rep(12) }, '%-')

local match_request_ids = {}

request = function()
  local template = nil
  local bindings = {}
  if len(match_request_ids) == 0 then
    template = create_match_query
    local resume = resumes[math.random(1, resume_count)]
    local position = positions[math.random(1, position_count)]
    bindings = {position, resume}
  else
    template = get_match_query
    bindings = {table.remove(match_request_ids,1)}
  end
  local body = render(template, bindings)
  return wrk.format("POST", path, headers, body)
end

response = function(status, headers, body)
  if status == 200 then
    local uuid = string.match(body, uuid_pattern)
    if uuid then
      table.insert(match_request_ids, uuid)
    end
  end
end
