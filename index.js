var os = require('os')
var http = require('http')

function handleRequest(req, res) {
  res.write('Hi there! I\'m being served from ' + os.hostname())
  res.end()
}

process.on('SIGINT', function() {
    process.exit();
})


console.log('starting server on 3000');

http.createServer(handleRequest).listen(3000, '0.0.0.0');
