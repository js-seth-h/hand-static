request = require 'supertest'


describe 'hand-static', ()->

  ho = require 'handover'
  statics = require '../hand-static'
  http = require 'http'
  
    
  it 'should send txt ', (done)-> 

    server = http.createServer ho.make [
#      ... something you need
      statics
        root: 'test/public'
    ]
    request server
      .get '/a.txt'
      .expect 200, 'a' 
      .end done
 

  it 'should send sub dir', (done)-> 

    s = statics
        root: 'test/public' 
    server = http.createServer ho.make [
#      ... something you need
      s
    ]
    s.setPrefix '/2', 'test/public2'

    request server
      .get '/2/b.txt'
      .expect 200, 'b' 
      .end done
 