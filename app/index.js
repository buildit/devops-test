// var os = require('os')
var http = require('http')

// function handleRequest(req, res) {
//   res.write('Hi there! I\'m being served from ' + os.hostname())
//   res.end()
// }

// http.createServer(handleRequest).listen(3000)
'use strict';
const express = require('express');
var os = require('os')
// Constants
const PORT = 3000;

// App
const app = express();
app.get('/', (req, res) => {
  console.log('Recieved a request');
  res.send('Hi there! I\'m being served from ' + os.hostname());
});

app.listen(PORT, () => {
  console.log(`Listening --> http://localhost:${PORT}`)
})
console.log(`Running on http://${os.hostname()}:${PORT}`);