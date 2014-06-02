# httpware-static


> static with prefix, multiple directory binding
> responsed html is customizable.
> written by coffeescript

## Features

* static with [send][send] 
* compatible with connect
* multiplexing by prfix , example...
 * http://localhost/a.tx -> public/a.txt
 * http://localhost/module_a/b.txt -> module_a/public/b.txt

[send]: https://www.npmjs.org/package/send


## Important - Multiplexing Order


**long prefix matching first, short later.**

In `httpware-static`, sort multiplexing rule by prefix. 




## Example 

```coffee 

    server = http.createServer flyway [
#      ... something you need
      statics
        '/': 'test/public'
    ]
#or 

 
    server = http.createServer flyway [
#      ... something you need
      statics
        '/': 'test/public' 
        '/2': 'test/public2' 
    ]

 ```
 prefix '/'  goto  dir `test/public`
 prefix '/2'  goto  dir `test/public2`



 ```coffee 
 
    s = statics
        '/': 'test/public' 
    server = http.createServer flyway [
#      ... something you need
      s
    ]
    s.setPrefix '/2', 'test/public2'

 ```
you can setPrefix later.
  
 ```coffee 
 
    s = statics
        '/': 'test/public' 
    server = http.createServer flyway [
#      ... something you need
      s
    ]
    s.setPrefix
      "/2": 'test/public2'
      '/': 'test/public' 

 ```
you can setPrefix accept object

```coffee 
 
    s = statics
        '/': 'test/public' 
        index : 'default.html'  # default of index  is `index.html`
    server = http.createServer flyway [
#      ... something you need
      s
    ]
    s.setPrefix
      "/2": 'test/public2'
      '/': 'test/public' 

 ```
you can setPrefix accept object
## License

(The MIT License)

Copyright (c) 2014 junsik &lt;js@seth.h@google.com&gt;

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 