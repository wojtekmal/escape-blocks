/*import https from "https"
import fs from "fs"
import path from 'path';
import { fileURLToPath } from 'url';
import express from "express"

const app = express()
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

app.use(express.static('public'))
app.use(express.urlencoded({extended: true, limit: '3mb'}))

app.post("/registration", (req, res) => {
    console.log(req.body)
    res.redirect("/")
})

const options = {
    key: fs.readFileSync('localhost+2-key.pem'),
    cert: fs.readFileSync('localhost+2.pem')
}

const PORT = process.env.PORT || 8000
https.createServer(options, app).listen(PORT, console.log(`server runs on port ${PORT}`))*/
const express = require('express')
const https = require('https')
const fs = require('fs')
const path = require('path')

let app = express()

let key = fs.readFileSync(__dirname+'/localhost+2-key.pem','utf-8')
let cert = fs.readFileSync(__dirname+'/localhost+2.pem','utf-8')

const port = 8000
const parameters = {
  key: key,
  cert: cert
}

/*app.get('/',(req,res)=>{
  res.send('HTTPS in ExpressJS')
})*/

app.use(function(req, res, next) {
  res.header("Cross-Origin-Embedder-Policy", "require-corp");
  res.header("Cross-Origin-Opener-Policy", "same-origin");
  next();
});

app.use( express.static( __dirname + '/static_stuff'));
app.get('/', function(req, res) {
  res.sendFile(path.join(__dirname, '/eb.html'));
});

let server = https.createServer(parameters,app)

server.listen(port,()=>{
  console.log(`Server is listening at port ${port}`)
})
