send = require 'send'
url = require 'url'
debug = require('debug')("httpware-static")
path = require 'path'
fs = require 'fs'

statics = (option = {})-> 
  option.index = option.index || undefined # 'index.html'

  debug 'create with ', option
  fn = (req, res, next)->  
    address = url.parse(req.url)
    pathname = address.pathname

    # debug "statics", pathname 
    for conf in fn.configure
      [prefix, mappedDir] = conf

      in_prefix = address.pathname[..prefix.length - 1]
      in_path = address.pathname[prefix.length..]  
      if in_prefix is prefix
        pathname = in_path
        root = mappedDir
        debug "statics prefix ='#{in_prefix}' path='#{pathname}'" 
        break

    debug 'root = ',root
    return next() unless root
    # log 'send', pathname, root
 

    mappedPath = path.join root, pathname
    fn.getRealPath mappedPath, (err, realPath)->
      debug 'getRealPath', mappedPath, '->', realPath
      return next err if err
      if realPath is undefined
        err = new Error 'File not found'
        err.status = 404
        return next err
      send(req, realPath)
        .on 'error', next
        .pipe res

  fn.configure = []

  fn.getRealPath = (mappedPath, callback)->
    fs.exists mappedPath, (exists)->
      return callback(null, undefined) unless exists
      fs.stat mappedPath, (err, stats)->
        return callback err if err
        return callback(null, mappedPath) if stats.isFile()
        return callback null, undefined unless option.index
        indexPath = path.join mappedPath, option.index
        debug 'search index file', indexPath
        fs.exists indexPath, (exists)->
          return callback null, undefined unless exists
          fs.stat indexPath, (err, stats)->
            return callback err if err
            return callback(err, indexPath) if stats.isFile()
            return callback null, undefined
 

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