var os = require('os')
var http = require('http')

function handleRequest(req, res) {
  res.write('Hi there! I\'m being served from ' + os.hostname() + ' feature branch')
  res.end()
}

http.createServer(handleRequest).listen(3000)
