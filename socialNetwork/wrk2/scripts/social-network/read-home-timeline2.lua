local latencies = {}

local socket = require("socket")
local time = socket.gettime()*1000
math.randomseed(time)
math.random(); math.random(); math.random()

-- load env vars
local max_user_index = tonumber(os.getenv("max_user_index")) or 962

request = function()
  local user_id = tostring(math.random(0, max_user_index - 1))
  local start = tostring(math.random(0, 100))
  local stop = tostring(start + 10)

  local args = "user_id=" .. user_id .. "&start=" .. start .. "&stop=" .. stop
  local method = "GET"
  local headers = {}
  headers["Content-Type"] = "application/x-www-form-urlencoded"
  local path = "http://localhost:8080/wrk2-api/home-timeline/read?" .. args
  return wrk.format(method, path, headers, nil)

end

-- Fonction appelée à la fin du test
done = function(summary, latency, requests)
  -- Ouvrir un fichier CSV pour enregistrer les métriques
  local file = io.open("latencies.csv", "w")

  -- Écrire l'en-tête
  file:write("latency\n")

  -- Écrire chaque métrique dans le fichier CSV
  local total = summary.requests  -- number of recorded latency samples
  for i = 1, total do
    local usec = latency[i]     -- i-th latency in microseconds
    file:write(string.format("%d\n", usec))
  end
end

function response(status, headers, body, time)
    table.insert(latencies, time)
end

