###
  Inspired in foundation v.3.2
  clearing: clearing.coffee
###
#
# * jQuery Foundation Clearing 1.2.1
# * http://foundation.zurb.com
# * Copyright 2012, ZURB
# * Free to use under the MIT license.
# * http://www.opensource.org/licenses/mit-license.php
#

#jslint unparam: true, browser: true, indent: 2 
(($, window, document, undefined_) ->
  caption=()->
  fix_height=()->
  center=()->
  shift=()->
  "use strict"
  defaults =
    templates:
      viewing: "<a href=\"#\" class=\"clearing-close\">&times;</a>" + "<div class=\"visible-img\" style=\"display: none\"><img src=\"#\">" + "<p class=\"clearing-caption\"></p><a href=\"#\" class=\"clearing-main-left\"></a>" + "<a href=\"#\" class=\"clearing-main-right\"></a></div>"

    
    # comma delimited list of selectors that, on click, will close clearing, 
    # add 'div.clearing-blackout, div.visible-img' to close on background click
    close_selectors: "a.clearing-close"
    
    # event initializers and locks
    initialized: false
    locked: false

  cl =
    init: (options, extendMethods) ->
      @find("ul[data-clearing]").each ->
        doc = $(document)
        $el = $(this)
        options = options or {}
        extendMethods = extendMethods or {}
        settings = $el.data("fndtn.clearing.settings")
        
        unless settings
          options.$parent = $el.parent()
          $el.data "fndtn.clearing.settings", $.extend({}, defaults, options)
          cl.assemble $el.find("li")
          unless defaults.initialized
            cl.events $el
            if Modernizr.touch 
              cl.swipe_events()


    events: (el) ->
      settings = el.data("fndtn.clearing.settings")
      
      # set current and target to the clicked li if not otherwise defined.
      $(document).on("click.fndtn.clearing", "ul[data-clearing] li", (e, current, target) ->
        current = current or $(this)
        target = target or current
        settings = current.parent().data("fndtn.clearing.settings")
        e.preventDefault()
        current.parent().foundationClearing()  unless settings
        cl.open $(e.target), current, target
        cl.update_paddles target
      ).on("click.fndtn.clearing", ".clearing-main-right", (e) ->
        cl.nav e, "next"
      ).on("click.fndtn.clearing", ".clearing-main-left", (e) ->
        cl.nav e, "prev"
      ).on("click.fndtn.clearing", settings.close_selectors, @close).on "keydown.fndtn.clearing", @keydown
      $(window).on "resize.fndtn.clearing", @resize
      defaults.initialized = true

    swipe_events: ->
      $(document).bind("swipeleft", "ul[data-clearing]", (e) ->
        cl.nav e, "next"
      ).bind("swiperight", "ul[data-clearing]", (e) ->
        cl.nav e, "prev"
      ).bind "movestart", "ul[data-clearing]", (e) ->
        e.preventDefault()  if (e.distX > e.distY and e.distX < -e.distY) or (e.distX < e.distY and e.distX > -e.distY)


    assemble: ($li) ->
      $el = $li.parent()
      settings = $el.data("fndtn.clearing.settings")
      grid = $el.detach()
      data =
        grid: "<div class=\"carousel\">" + @outerHTML(grid[0]) + "</div>"
        viewing: settings.templates.viewing

      wrapper = "<div class=\"clearing-assembled\"><div>" + data.viewing + data.grid + "</div></div>"
      settings.$parent.append wrapper

    open: ($image, current, target) ->
      root = target.closest(".clearing-assembled")
      container = root.find("div:first")
      visible_image = container.find(".visible-img")
      image = visible_image.find("img").not($image)
      unless cl.locked()
        
        # set the image to the selected thumbnail
        image.attr "src", @load($image)
        
        # toggle the gallery if not visible
        
        # shift the thumbnails if necessary
        image.loaded ->
          root.addClass "clearing-blackout"
          container.addClass "clearing-container"
          caption visible_image.find(".clearing-caption"), $image
          visible_image.show()
          fix_height target
          center image
          shift current, target, ->
            target.siblings().removeClass "visible"
            target.addClass "visible"

        .bind(this)

    close: (e) ->
      e.preventDefault()
      root = ((target) ->
        if /blackout/.test(target.selector)
          target
        else
          target.closest ".clearing-blackout"
      ($(this)))
      container = undefined_
      visible_image = undefined_
      if this is e.target and root
        container = root.find("div:first")
        visible_image = container.find(".visible-img")

        defaults.prev_index = 0
        root.find("ul[data-clearing]").attr "style", ""
        root.removeClass "clearing-blackout"
        container.removeClass "clearing-container"
        visible_image.hide()
      false

    keydown: (e) ->
      clearing = $(".clearing-blackout").find("ul[data-clearing]")
      cl.go clearing, "next"  if e.which is 39
      cl.go clearing, "prev"  if e.which is 37
      $("a.clearing-close").trigger "click"  if e.which is 27

    nav: (e, direction) ->
      clearing = $(".clearing-blackout").find("ul[data-clearing]")
      e.preventDefault()
      @go clearing, direction

    resize: ->
      image = $(".clearing-blackout .visible-img").find("img")
      cl.center image  if image.length > 0

    fix_height: (target) ->
      lis = target.siblings()
      lis.each(->
        li = $(this)
        image = li.find("img")
        li.addClass "fix-height"  if li.height() > image.outerHeight()
      ).closest("ul").width lis.length * 100 + "%"

    update_paddles: (target) ->
      visible_image = target.closest(".carousel").siblings(".visible-img")
      if target.next().length > 0
        visible_image.find(".clearing-main-right").removeClass "disabled"
      else
        visible_image.find(".clearing-main-right").addClass "disabled"
      if target.prev().length > 0
        visible_image.find(".clearing-main-left").removeClass "disabled"
      else
        visible_image.find(".clearing-main-left").addClass "disabled"

    load: ($image) ->
      href = $image.parent().attr("href")
      @preload $image
      return href  if href
      $image.attr "src"

    preload: ($image) ->
      @img $image.closest("li").next()
      @img $image.closest("li").prev()

    img: (img) ->
      if img.length > 0
        new_img = new Image()
        new_a = img.find("a")
        if new_a.length > 0
          new_img.src = new_a.attr("href")
        else
          new_img.src = img.find("img").attr("src")

    caption: (container, $image) ->
      caption = $image.data("caption")
      if caption
        container.text(caption).show()
      else
        container.text("").hide()

    go: ($ul, direction) ->
      current = $ul.find(".visible")
      target = current[direction]()
      target.find("img").trigger "click", [current, target]  if target.length > 0

    shift: (current, target, callback) ->
      clearing = target.parent()
      old_index = defaults.prev_index
      direction = @direction(clearing, current, target)
      left = parseInt(clearing.css("left"), 10)
      width = target.outerWidth()
      skip_shift = undefined_
      
      # we use jQuery animate instead of CSS transitions because we
      # need a callback to unlock the next animation
      if target.index() isnt old_index and not /skip/.test(direction)
        if /left/.test(direction)
          @lock()
          clearing.animate
            left: left + width
          , 300, @unlock
        else if /right/.test(direction)
          @lock()
          clearing.animate
            left: left - width
          , 300, @unlock
      else if /skip/.test(direction)
        
        # the target image is not adjacent to the current image, so
        # do we scroll right or not
        skip_shift = target.index() - defaults.up_count
        @lock()
        if skip_shift > 0
          clearing.animate
            left: -(skip_shift * width)
          , 300, @unlock
        else
          clearing.animate
            left: 0
          , 300, @unlock
      callback()

    lock: ->
      defaults.locked = true

    unlock: ->
      defaults.locked = false

    locked: ->
      defaults.locked

    direction: ($el, current, target) ->
      lis = $el.find("li")
      li_width = lis.outerWidth() + (lis.outerWidth() / 4)
      up_count = Math.floor($(".clearing-container").outerWidth() / li_width) - 1
      target_index = lis.index(target)
      response = undefined_
      defaults.up_count = up_count
      if @adjacent(defaults.prev_index, target_index)
        if (target_index > up_count) and target_index > defaults.prev_index
          response = "right"
        else if (target_index > up_count - 1) and target_index <= defaults.prev_index
          response = "left"
        else
          response = false
      else
        response = "skip"
      defaults.prev_index = target_index
      response

    adjacent: (current_index, target_index) ->
      i = target_index + 1

      while i >= target_index - 1
        return true  if i is current_index
        i--
      false

    center: (target) ->
      target.css
        marginLeft: -(target.outerWidth() / 2)
        marginTop: -(target.outerHeight() / 2)


    outerHTML: (el) ->
      
      # support FireFox < 11
      el.outerHTML or new XMLSerializer().serializeToString(el)

  $.fn.foundationClearing = (method) ->
    if cl[method]
      cl[method].apply this, Array::slice.call(arguments, 1)
    else if typeof method is "object" or not method
      cl.init.apply this, arguments
    else
      $.error "Method " + method + " does not exist on jQuery.foundationClearing"

  
  # jquery.imageready.js
  # @weblinc, @jsantell, (c) 2012
  (($) ->
    $.fn.loaded = (callback, userSettings) ->
      loaded = ->
        unloadedImages -= 1
        not unloadedImages and callback()
      bindLoad = ->
        @one "load", loaded
        if $.browser.msie
          src = @attr("src")
          param = (if src.match(/\?/) then "&" else "?")
          param += options.cachePrefix + "=" + (new Date()).getTime()
          @attr "src", src + param
      options = $.extend({}, $.fn.loaded.defaults, userSettings)
      $images = @find("img").add(@filter("img"))
      unloadedImages = $images.length
      $images.each ->
        $this = $(this)
        unless $this.attr("src")
          loaded()
          return
        (if @complete or @readyState is 4 then loaded() else bindLoad.call($this))


    $.fn.loaded.defaults = cachePrefix: "random"
  ) jQuery
) jQuery, this, @document
