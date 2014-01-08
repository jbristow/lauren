http = require 'http'
url = require 'url'
fakeedda = require './fakeedda'

http.createServer((req, res) ->
  parsedUrl = url.parse req.url

  res.writeHead 200,
    "Content-Type": "text/json"
    "Access-Control-Allow-Origin": "*"

  if fakeedda.matchesUserUrl 'fps-perf', parsedUrl.pathname
    console.log "getting users"
    users = require './users.json'
    res.end JSON.stringify(users)
  else if fakeedda.matchesInstanceUrl 'fps-perf', ['us-west-1', 'us-west-2'], parsedUrl.pathname
    console.log "getting instances"
    instances = require './instances.json'
    res.end JSON.stringify(instances)
  else
    console.log "no!" + parsedUrl.pathname
    res.end JSON.stringify([])
).listen 8888


