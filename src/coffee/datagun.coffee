querystring = require('querystring')
http = require('http')
url = require('url')
vulns = []

class Instance
  constructor: (@id, @name, @regionId, @type, @vulnRefs) ->


class VulnRef
  constructor: (@vulnId, @vulnType, @vulnName, @intuit_vuln_definition_id, @xref, @synopsis, @cve, @severity, @scan_results_xref) ->
instanceId = "instance_id_1"
instance = (new Instance(instanceId, "instanceName", "region", "type", [new VulnRef("vulnId", "type", "name", "intuit_vuln_id", "xref", "synopsis", "cve", "1", "xref")]))
data = querystring.stringify(instance)

options = {
  host: "localhost",
  port: 8080,
  path: "/cmdb-1.0-SNAPSHOT/v1/vuln/account/" + instanceId, 
  method: 'POST',
  headers: {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Content-Length': Buffer.byteLength(data)
  }
}

req = http.request(options, (res) ->
  res.setEncoding "utf8"
  res.on "data", (chunk) ->
    console.log "body: " + chunk

)
req.write data
req.end()

