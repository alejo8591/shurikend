(($, document, undefined_) ->
  raw = (s) ->
    s
  decoded = (s) ->
    decodeURIComponent s.replace(pluses, " ")
  pluses = /\+/g
  config = $.cookie = (key, value, options) ->
    
    # write
    if value isnt `undefined`
      options = $.extend({}, config.defaults, options)
      options.expires = -1  if value is null
      if typeof options.expires is "number"
        days = options.expires
        t = options.expires = new Date()
        t.setDate t.getDate() + days
      value = (if config.json then JSON.stringify(value) else String(value))
      # use expires attribute, max-age is not supported by IE
      return (document.cookie = [encodeURIComponent(key), "=", (if config.raw then value else encodeURIComponent(value)), (if options.expires then "; expires=" + options.expires.toUTCString() else ""), (if options.path then "; path=" + options.path else ""), (if options.domain then "; domain=" + options.domain else ""), (if options.secure then "; secure" else "")].join(""))
    
    # read
    decode = (if config.raw then raw else decoded)
    cookies = document.cookie.split("; ")
    i = 0
    l = cookies.length

    while i < l
      parts = cookies[i].split("=")
      if decode(parts.shift()) is key
        cookie = decode(parts.join("="))
        return (if config.json then JSON.parse(cookie) else cookie)
      i++
    null

  config.defaults = {}
  $.removeCookie = (key, options) ->
    if $.cookie(key) isnt null
      $.cookie key, null, options
      return true
    false
) jQuery, document