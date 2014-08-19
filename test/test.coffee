request = require 'supertest'


describe 'hand-static', ()->

  ficent = require 'ficent'
  statics = require '../src'
  http = require 'http'
  
#   it 'should default setting  ', (done)-> 

#     server = http.createServer ficent [
# #      ... something you need
#       statics()
#     ]
#     request server
#       .get '/c.txt'
#       .expect 200, 'c' 
#       .end done
 
  it 'should pass request', (done)-> 

    server = http.createServer ficent [
#      ... something you need
      statics()
      (req,res)->
        res.statusCode = 404
        res.end 'pass'
    ]
    request server
      .get '/a.txt'
      .expect 404 , 'pass'
      .end done
    
  it 'should pass request', (done)-> 

    server = http.createServer ficent [
#      ... something you need
      statics
        '/unmatched': 'test/public'
      (req,res)->
        res.statusCode = 404
        res.end 'pass'
    ]
    request server
      .get '/a.txt'
      .expect 404 , 'pass'
      .end done
    
  it 'should send txt ', (done)-> 

    server = http.createServer ficent [
#      ... something you need
      statics
        '/': 'test/public'
    ]
    request server
      .get '/a.txt'
      .expect 200, 'a' 
      .end done
 

  it 'should send sub dir, ', (done)-> 

    s = statics
        '/': 'test/public' 
    server = http.createServer ficent [
#      ... something you need
      s
    ]
    s.setPrefix '/2', 'test/public2'

    request server
      .get '/2/b.txt'
      .expect 200, 'b' 
      .end done
 
 

  it 'should accept options key start with "/" ', (done)-> 
 
    server = http.createServer ficent [
#      ... something you need
      statics
        '/': 'test/public' 
        '/2': 'test/public2' 
    ]

    request server
      .get '/2/b.txt'
      .expect 200, 'b' 
      .end done
 

  it 'should accept mapping object ', (done)-> 

    s = statics()
        # '/': 'test/public' 
    server = http.createServer ficent [
#      ... something you need
      s
    ]
    # s.setPrefix '/2', 'test/public2'
    s.setPrefix 
      "/2": 'test/public2'
      '/': 'test/public' 
    # request server
    #   .get '/2/b.txt'
    #   .expect 200, 'b'
    #   .end done
    request server
      .get '/a.txt'
      .expect 200, 'a' 
      .end done


  it 'should send index.html', (done)-> 

    server = http.createServer ficent [
#      ... something you need
      statics
        index: 'index.html'
        '/': 'test/public' 
      (req,res)->
        res.statusCode = 404
        res.end 'pass'
    ]
    request server
      .get '/'
      .expect 200, 'HELLOW INDEX.HTML'
      .end done


  it 'should send change index', (done)-> 

    server = http.createServer ficent [
#      ... something you need
      statics
        index: 'a.txt'
        '/': 'test/public' 
      (req,res)->
        res.statusCode = 404
        res.end 'pass'
    ]
    request server
      .get '/'
      .expect 200, 'a'
      .end done


  it 'read jsonFile', (done)-> 

    server = http.createServer ficent [
#      ... something you need
      statics
        jsonFile: './static-prefix.json'
      (req,res)->
        res.statusCode = 404
        res.end 'pass'
    ]
    doTest = ()->
      request server
        .get '/test/a.txt'
        .expect 200, 'a'
        .end done


    setTimeout doTest, 500

  it 'read jsonFile (not exist)', (done)-> 

    server = http.createServer ficent [
#      ... something you need
      statics
        jsonFile: './static-prefix-2.json'
      (req,res)->
        res.statusCode = 404
        res.end 'pass'
    ]
    doTest = ()->
      request server
        .get '/test/a.txt'
        .expect 404
        .end done


    setTimeout doTest, 500

  it 'read jsonFile (cracked)', (done)-> 

    server = http.createServer ficent [
#      ... something you need
      statics
        jsonFile: './static-prefix-cracked.json'
      (req,res)->
        res.statusCode = 404
        res.end 'pass'
    ]
    doTest = ()->
      request server
        .get '/test/a.txt'
        .expect 404
        .end done


    setTimeout doTest, 500