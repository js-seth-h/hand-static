

send = require 'send'
url = require 'url'
debug = require('debug')("hand:static")


statics = (option = {})->
  # option.root = option.root || './public'


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
        # debug "statics prefix ='#{in_prefix}' path='#{pathname}'" 
        break

    # log 'send', pathname, root
    debug 'static send', req.url, '->', root, pathname
    send(req, pathname)
      .root(root) 
      .pipe(res)

  fn.configure = []
  fn.setPrefix = (prefix, root)->
    fn.configure.push([prefix, root ])
    # debug 'configure = ', fn.configure
    fn.configure.sort (a, b)-> 
      # debug 'sort ', a,b 
      return 0 if a[0] is b[0]
      return -1 if a[0] > b[0]
      return 1
    debug 'prefix setting :', fn.configure


  for own prefix, dir of option
    if prefix[0] is '/'
      fn.setPrefix prefix, dir

  # fn.setPrefix '/', option.root
  return fn

module.exports = exports = statics