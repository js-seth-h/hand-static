send = require 'send'
url = require 'url'
debug = require('debug')("hand:static")
path = require 'path'
fs = require 'fs'

statics = (option = {})-> 
  option.index = option.index || undefined # 'index.html'

  fn = (req, res, next)->  
    address = url.parse(req.url)
    pathname = address.pathname

    # debug "statics", pathname 
    for conf in fn.configure
      [prefix, root] = conf

      in_prefix = address.pathname[..prefix.length - 1]
      in_path = address.pathname[prefix.length..]  


      if in_prefix isnt prefix
        continue
      else              
        pathname = in_path
        debug "statics prefix ='#{in_prefix}' path='#{pathname}'" 
        break

    debug 'root = ',root
    return next() unless root
    # log 'send', pathname, root

    actualPath = path.join root, pathname

    debug 'actualPath' , actualPath 
    fs.exists actualPath, (exists)->
      return next() unless exists   
      fn.sendFile req, res, actualPath, next


  fn.configure = []
  fn.sendFile = (req, res, actualPath, next)->
    debug 'send path ', actualPath
    fs.stat actualPath, (err, stats)->
      # debug 'stats ', actualPath, err, stats
      return next(err)  if err        
      debug 'isFile = ', stats.isFile()
      if stats.isFile()
        debug 'static send', req.url, '<-', actualPath
        send(req, actualPath).pipe(res)
      else if option.index
        indexPath = path.join actualPath, option.index
        fs.exists indexPath, (exists)->
          return next() unless exists
          fn.sendFile req, res, indexPath, next
      else
        next()

  fn.setPrefix = (prefix, root)->

    if typeof prefix is 'object'
      debug 'accept prefix object', prefix
      for own k, v of prefix
        debug 'setPrefix',  k, v
        fn.setPrefix k, v
      return  
    fn.configure.push([prefix, root ])
    # debug 'configure = ', fn.configure
    fn.configure.sort (a, b)-> 
      # debug 'sort ', a,b 
      return 0 if a[0] is b[0]
      return -1 if a[0] > b[0]
      return 1
    debug 'prefix setting :', fn.configure


  # hasPrefix = false
  for own prefix, dir of option
    if prefix[0] is '/'
      fn.setPrefix prefix, dir
      # hasPrefix = true

  # if hasPrefix is false
  #   fn.setPrefix '/', 'public' 
  return fn

module.exports = exports = statics