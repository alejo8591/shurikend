#
# * jQuery Foundation Joyride Plugin 2.0.3
# * http://foundation.zurb.com
# * Copyright 2012, ZURB
# * Free to use under the MIT license.
# * http://www.opensource.org/licenses/mit-license.php
#

#jslint unparam: true, browser: true, indent: 2 
(($, window, undefined_) ->
  "use strict"
  defaults =
    version: "2.0.3"
    tipLocation: "bottom" # 'top' or 'bottom' in relation to parent
    nubPosition: "auto" # override on a per tooltip bases
    scrollSpeed: 300 # Page scrolling speed in milliseconds
    timer: 0 # 0 = no timer , all other numbers = timer in milliseconds
    startTimerOnClick: true # true or false - true requires clicking the first button start the timer
    startOffset: 0 # the index of the tooltip you want to start on (index of the li)
    nextButton: true # true or false to control whether a next button is used
    tipAnimation: "fade" # 'pop' or 'fade' in each tip
    pauseAfter: [] # array of indexes where to pause the tour after
    tipAnimationFadeSpeed: 300 # when tipAnimation = 'fade' this is speed in milliseconds for the transition
    cookieMonster: false # true or false to control whether cookies are used
    cookieName: "joyride" # Name the cookie you'll use
    cookieDomain: false # Will this cookie be attached to a domain, ie. '.notableapp.com'
    tipContainer: "body" # Where will the tip be attached
    postRideCallback: $.noop # A method to call once the tour closes (canceled or complete)
    postStepCallback: $.noop # A method to call after each step
    template: # HTML segments for tip layout
      link: "<a href=\"#close\" class=\"joyride-close-tip\">X</a>"
      timer: "<div class=\"joyride-timer-indicator-wrap\"><span class=\"joyride-timer-indicator\"></span></div>"
      tip: "<div class=\"joyride-tip-guide\"><span class=\"joyride-nub\"></span></div>"
      wrapper: "<div class=\"joyride-content-wrapper\"></div>"
      button: "<a href=\"#\" class=\"small button joyride-next-tip\"></a>"

  Modernizr = Modernizr or false
  settings = {}
  methods =
    init: (opts) ->
      @each ->
        if $.isEmptyObject(settings)
          settings = $.extend(true, defaults, opts)
          
          # non configurable settings
          settings.document = window.document
          settings.$document = $(settings.document)
          settings.$window = $(window)
          settings.$content_el = $(this)
          settings.body_offset = $(settings.tipContainer).position()
          settings.$tip_content = $("> li", settings.$content_el)
          settings.paused = false
          settings.attempts = 0
          settings.tipLocationPatterns =
            top: ["bottom"]
            bottom: [] # bottom should not need to be repositioned
            left: ["right", "top", "bottom"]
            right: ["left", "top", "bottom"]

          
          # are we using jQuery 1.7+
          methods.jquery_check()
          
          # can we create cookies?
          settings.cookieMonster = false  unless $.isFunction($.cookie)
          
          # generate the tips and insert into dom.
          if not settings.cookieMonster or not $.cookie(settings.cookieName)
            settings.$tip_content.each (index) ->
              methods.create
                $li: $(this)
                index: index


            
            # show first tip
            if not settings.startTimerOnClick and settings.timer > 0
              methods.show "init"
              methods.startTimer()
            else
              methods.show "init"
          settings.$document.on "click.joyride", ".joyride-next-tip, .joyride-modal-bg", (e) ->
            e.preventDefault()
            if settings.$li.next().length < 1
              methods.end()
            else if settings.timer > 0
              clearTimeout settings.automate
              methods.hide()
              methods.show()
              methods.startTimer()
            else
              methods.hide()
              methods.show()

          settings.$document.on "click.joyride", ".joyride-close-tip", (e) ->
            e.preventDefault()
            methods.end()

          settings.$window.bind "resize.joyride", (e) ->
            if methods.is_phone()
              methods.pos_phone()
            else
              methods.pos_default()

        else
          methods.restart()


    
    # call this method when you want to resume the tour
    resume: ->
      methods.set_li()
      methods.show()

    tip_template: (opts) ->
      $blank = undefined
      content = undefined
      opts.tip_class = opts.tip_class or ""
      $blank = $(settings.template.tip).addClass(opts.tip_class)
      content = $.trim($(opts.li).html()) + methods.button_text(opts.button_text) + settings.template.link + methods.timer_instance(opts.index)
      $blank.append $(settings.template.wrapper)
      $blank.first().attr "data-index", opts.index
      $(".joyride-content-wrapper", $blank).append content
      $blank[0]

    timer_instance: (index) ->
      txt = undefined
      if (index is 0 and settings.startTimerOnClick and settings.timer > 0) or settings.timer is 0
        txt = ""
      else
        txt = methods.outerHTML($(settings.template.timer)[0])
      txt

    button_text: (txt) ->
      if settings.nextButton
        txt = $.trim(txt) or "Next"
        txt = methods.outerHTML($(settings.template.button).append(txt)[0])
      else
        txt = ""
      txt

    create: (opts) ->
      
      # backwards compatibility with data-text attribute
      buttonText = opts.$li.attr("data-button") or opts.$li.attr("data-text")
      tipClass = opts.$li.attr("class")
      $tip_content = $(methods.tip_template(
        tip_class: tipClass
        index: opts.index
        button_text: buttonText
        li: opts.$li
      ))
      $(settings.tipContainer).append $tip_content

    show: (init) ->
      opts = {}
      ii = undefined
      opts_arr = []
      opts_len = 0
      p = undefined
      $timer = null
      
      # are we paused?
      if settings.$li is `undefined` or ($.inArray(settings.$li.index(), settings.pauseAfter) is -1)
        
        # don't go to the next li if the tour was paused
        if settings.paused
          settings.paused = false
        else
          methods.set_li init
        settings.attempts = 0
        if settings.$li.length and settings.$target.length > 0
          opts_arr = (settings.$li.data("options") or ":").split(";")
          opts_len = opts_arr.length
          
          # parse options
          ii = opts_len - 1
          while ii >= 0
            p = opts_arr[ii].split(":")
            opts[$.trim(p[0])] = $.trim(p[1])  if p.length is 2
            ii--
          settings.tipSettings = $.extend({}, settings, opts)
          settings.tipSettings.tipLocationPattern = settings.tipLocationPatterns[settings.tipSettings.tipLocation]
          
          # scroll if not modal
          methods.scroll_to()  unless /body/i.test(settings.$target.selector)
          if methods.is_phone()
            methods.pos_phone true
          else
            methods.pos_default true
          $timer = $(".joyride-timer-indicator", settings.$next_tip)
          if /pop/i.test(settings.tipAnimation)
            $timer.outerWidth 0
            if settings.timer > 0
              settings.$next_tip.show()
              $timer.animate
                width: $(".joyride-timer-indicator-wrap", settings.$next_tip).outerWidth()
              , settings.timer
            else
              settings.$next_tip.show()
          else if /fade/i.test(settings.tipAnimation)
            $timer.outerWidth 0
            if settings.timer > 0
              settings.$next_tip.fadeIn settings.tipAnimationFadeSpeed
              settings.$next_tip.show()
              $timer.animate
                width: $(".joyride-timer-indicator-wrap", settings.$next_tip).outerWidth()
              , settings.timer
            else
              settings.$next_tip.fadeIn settings.tipAnimationFadeSpeed
          settings.$current_tip = settings.$next_tip
        
        # skip non-existent targets
        else if settings.$li and settings.$target.length < 1
          methods.show()
        else
          methods.end()
      else
        settings.paused = true

    
    # detect phones with media queries if supported.
    is_phone: ->
      return Modernizr.mq("only screen and (max-width: 767px)")  if Modernizr
      (if (settings.$window.width() < 767) then true else false)

    hide: ->
      settings.postStepCallback settings.$li.index(), settings.$current_tip
      $(".joyride-modal-bg").hide()
      settings.$current_tip.hide()

    set_li: (init) ->
      if init
        settings.$li = settings.$tip_content.eq(settings.startOffset)
        methods.set_next_tip()
        settings.$current_tip = settings.$next_tip
      else
        settings.$li = settings.$li.next()
        methods.set_next_tip()
      methods.set_target()

    set_next_tip: ->
      settings.$next_tip = $(".joyride-tip-guide[data-index=" + settings.$li.index() + "]")

    set_target: ->
      cl = settings.$li.attr("data-class")
      id = settings.$li.attr("data-id")
      $sel = ->
        if id
          $ settings.document.getElementById(id)
        else if cl
          $("." + cl).first()
        else
          $ "body"

      settings.$target = $sel()

    scroll_to: ->
      window_half = undefined
      tipOffset = undefined
      window_half = settings.$window.height() / 2
      tipOffset = Math.ceil(settings.$target.offset().top - window_half + settings.$next_tip.outerHeight())
      $("html, body").stop().animate
        scrollTop: tipOffset
      , settings.scrollSpeed

    paused: ->
      return true  if $.inArray((settings.$li.index() + 1), settings.pauseAfter) is -1
      false

    destroy: ->
      settings.$document.off ".joyride"
      $(window).off ".joyride"
      $(".joyride-close-tip, .joyride-next-tip, .joyride-modal-bg").off ".joyride"
      $(".joyride-tip-guide, .joyride-modal-bg").remove()
      clearTimeout settings.automate
      settings = {}

    restart: ->
      methods.hide()
      settings.$li = `undefined`
      methods.show "init"

    pos_default: (init) ->
      half_fold = Math.ceil(settings.$window.height() / 2)
      tip_position = settings.$next_tip.offset()
      $nub = $(".joyride-nub", settings.$next_tip)
      nub_height = Math.ceil($nub.outerHeight() / 2)
      toggle = init or false
      
      # tip must not be "display: none" to calculate position
      if toggle
        settings.$next_tip.css "visibility", "hidden"
        settings.$next_tip.show()
      unless /body/i.test(settings.$target.selector)
        if methods.bottom()
          settings.$next_tip.css
            top: (settings.$target.offset().top + nub_height + settings.$target.outerHeight())
            left: settings.$target.offset().left

          methods.nub_position $nub, settings.tipSettings.nubPosition, "top"
        else if methods.top()
          settings.$next_tip.css
            top: (settings.$target.offset().top - settings.$next_tip.outerHeight() - nub_height)
            left: settings.$target.offset().left

          methods.nub_position $nub, settings.tipSettings.nubPosition, "bottom"
        else if methods.right()
          settings.$next_tip.css
            top: settings.$target.offset().top
            left: (settings.$target.outerWidth() + settings.$target.offset().left)

          methods.nub_position $nub, settings.tipSettings.nubPosition, "left"
        else if methods.left()
          settings.$next_tip.css
            top: settings.$target.offset().top
            left: (settings.$target.offset().left - settings.$next_tip.outerWidth() - nub_height)

          methods.nub_position $nub, settings.tipSettings.nubPosition, "right"
        if not methods.visible(methods.corners(settings.$next_tip)) and settings.attempts < settings.tipSettings.tipLocationPattern.length
          $nub.removeClass("bottom").removeClass("top").removeClass("right").removeClass "left"
          settings.tipSettings.tipLocation = settings.tipSettings.tipLocationPattern[settings.attempts]
          settings.attempts++
          methods.pos_default true
      else methods.pos_modal $nub  if settings.$li.length
      if toggle
        settings.$next_tip.hide()
        settings.$next_tip.css "visibility", "visible"

    pos_phone: (init) ->
      tip_height = settings.$next_tip.outerHeight()
      tip_offset = settings.$next_tip.offset()
      target_height = settings.$target.outerHeight()
      $nub = $(".joyride-nub", settings.$next_tip)
      nub_height = Math.ceil($nub.outerHeight() / 2)
      toggle = init or false
      $nub.removeClass("bottom").removeClass("top").removeClass("right").removeClass "left"
      if toggle
        settings.$next_tip.css "visibility", "hidden"
        settings.$next_tip.show()
      unless /body/i.test(settings.$target.selector)
        if methods.top()
          settings.$next_tip.offset top: settings.$target.offset().top - tip_height - nub_height
          $nub.addClass "bottom"
        else
          settings.$next_tip.offset top: settings.$target.offset().top + target_height + nub_height
          $nub.addClass "top"
      else methods.pos_modal $nub  if settings.$li.length
      if toggle
        settings.$next_tip.hide()
        settings.$next_tip.css "visibility", "visible"

    pos_modal: ($nub) ->
      methods.center()
      $nub.hide()
      $("body").append("<div class=\"joyride-modal-bg\">").show()  if $(".joyride-modal-bg").length < 1
      if /pop/i.test(settings.tipAnimation)
        $(".joyride-modal-bg").show()
      else
        $(".joyride-modal-bg").fadeIn settings.tipAnimationFadeSpeed

    center: ->
      $w = settings.$window
      settings.$next_tip.css
        top: ((($w.height() - settings.$next_tip.outerHeight()) / 2) + $w.scrollTop())
        left: ((($w.width() - settings.$next_tip.outerWidth()) / 2) + $w.scrollLeft())

      true

    bottom: ->
      /bottom/i.test settings.tipSettings.tipLocation

    top: ->
      /top/i.test settings.tipSettings.tipLocation

    right: ->
      /right/i.test settings.tipSettings.tipLocation

    left: ->
      /left/i.test settings.tipSettings.tipLocation

    corners: (el) ->
      w = settings.$window
      right = w.width() + w.scrollLeft()
      bottom = w.width() + w.scrollTop()
      [el.offset().top <= w.scrollTop(), right <= el.offset().left + el.outerWidth(), bottom <= el.offset().top + el.outerHeight(), w.scrollLeft() >= el.offset().left]

    visible: (hidden_corners) ->
      i = hidden_corners.length
      return false  if hidden_corners[i]  while i--
      true

    nub_position: (nub, pos, def) ->
      if pos is "auto"
        nub.addClass def
      else
        nub.addClass pos

    startTimer: ->
      if settings.$li.length
        settings.automate = setTimeout(->
          methods.hide()
          methods.show()
          methods.startTimer()
        , settings.timer)
      else
        clearTimeout settings.automate

    end: ->
      if settings.cookieMonster
        $.cookie settings.cookieName, "ridden",
          expires: 365
          domain: settings.cookieDomain

      clearTimeout settings.automate  if settings.timer > 0
      $(".joyride-modal-bg").hide()
      settings.$current_tip.hide()
      settings.postStepCallback settings.$li.index(), settings.$current_tip
      settings.postRideCallback settings.$li.index(), settings.$current_tip

    jquery_check: ->
      
      # define on() and off() for older jQuery
      unless $.isFunction($.fn.on)
        $.fn.on = (types, sel, fn) ->
          @delegate sel, types, fn

        $.fn.off = (types, sel, fn) ->
          @undelegate sel, types, fn

        return false
      true

    outerHTML: (el) ->
      
      # support FireFox < 11
      el.outerHTML or new XMLSerializer().serializeToString(el)

    version: ->
      settings.version

  $.fn.joyride = (method) ->
    if methods[method]
      methods[method].apply this, Array::slice.call(arguments_, 1)
    else if typeof method is "object" or not method
      methods.init.apply this, arguments_
    else
      $.error "Method " + method + " does not exist on jQuery.joyride"
) jQuery, this
