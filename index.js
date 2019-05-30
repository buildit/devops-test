var os = require('os')
var http = require('http')

function handleRequest(req, res) {
  res.write('Hi there! I\'m being served from ' + os.hostname() + ' using pm2. Tested and deployed using Codeship')
  res.end()
}

http.createServer(handleRequest).listen(3000)
