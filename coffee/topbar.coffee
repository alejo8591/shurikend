###
  Inspired in foundation v.3.2
  topbar: topbar.coffee
###
#
# * jQuery Foundation Top Bar 2.0.4
# * http://foundation.zurb.com
# * Copyright 2012, ZURB
# * Free to use under the MIT license.
# * http://www.opensource.org/licenses/mit-license.php
#

#jslint unparam: true, browser: true, indent: 2 
(($, window) ->
  "use strict"
  settings =
    index: 0
    initialized: false

  methods =
    init: (options) ->
      @each ->
        settings = $.extend(settings, options)
        settings.$w = $(window)
        settings.$topbar = $("nav.top-bar")
        settings.$section = settings.$topbar.find("section")
        settings.$titlebar = settings.$topbar.children("ul:first")

        breakpoint = $("<div class='top-bar-js-breakpoint'/>").appendTo("body")
        settings.breakPoint = breakpoint.width()
        breakpoint.remove()
        unless settings.initialized
          methods.assemble()
          settings.initialized = true
        methods.largestUL()  unless settings.height
        $("body").css "padding-top", settings.$topbar.outerHeight()  if settings.$topbar.parent().hasClass("fixed")
        $(".top-bar .toggle-topbar").off("click.fndtn").on "click.fndtn", (e) ->
          e.preventDefault()
          if methods.breakpoint()
            settings.$topbar.toggleClass "expanded"
            settings.$topbar.css "min-height", ""
          unless settings.$topbar.hasClass("expanded")
            settings.$section.css left: "0%"
            settings.$section.find(">.name").css left: "100%"
            settings.$section.find("li.moved").removeClass "moved"
            settings.index = 0

        
        # Show the Dropdown Levels on Click
        $(".top-bar .has-dropdown>a").off("click.fndtn").on "click.fndtn", (e) ->
          e.preventDefault()  if Modernizr.touch or methods.breakpoint()
          if methods.breakpoint()
            $this = $(this)
            $selectedLi = $this.closest("li")
            settings.index += 1
            $selectedLi.addClass "moved"
            settings.$section.css left: -(100 * settings.index) + "%"
            settings.$section.find(">.name").css left: 100 * settings.index + "%"
            $this.siblings("ul").height settings.height + settings.$titlebar.outerHeight(true)
            settings.$topbar.css "min-height", settings.height + settings.$titlebar.outerHeight(true) * 2

        $(window).on "resize.fndtn.topbar", ->
          settings.$topbar.css "min-height", ""  unless methods.breakpoint()

        
        # Go up a level on Click
        $(".top-bar .has-dropdown .back").off("click.fndtn").on "click.fndtn", (e) ->
          e.preventDefault()
          $this = $(this)
          $movedLi = $this.closest("li.moved")
          $previousLevelUl = $movedLi.parent()
          settings.index -= 1
          settings.$section.css left: -(100 * settings.index) + "%"
          settings.$section.find(">.name").css left: 100 * settings.index + "%"
          settings.$topbar.css "min-height", 0  if settings.index is 0
          setTimeout (->
            $movedLi.removeClass "moved"
          ), 300



    breakpoint: ->
      settings.$w.width() < settings.breakPoint

    assemble: ->
      
      # Pull element out of the DOM for manipulation
      settings.$section.detach()
      settings.$section.find(".has-dropdown>a").each ->
        $link = $(this)
        $dropdown = $link.siblings(".dropdown")
        $titleLi = $("<li class=\"title back js-generated\"><h5><a href=\"#\"></a></h5></li>")
        
        # Copy link to subnav
        $titleLi.find("h5>a").html $link.html()
        $dropdown.prepend $titleLi

      
      # Put element back in the DOM
      settings.$section.appendTo settings.$topbar

    largestUL: ->
      uls = settings.$topbar.find("section ul ul")
      largest = uls.first()
      total = 0
      uls.each ->
        largest = $(this)  if $(this).children("li").length > largest.children("li").length

      largest.children("li").each ->
        total += $(this).outerHeight(true)

      settings.height = total

  $.fn.foundationTopBar = (method) ->
    if methods[method]
      methods[method].apply this, Array::slice.call(arguments, 1)
    else if typeof method is "object" or not method
      methods.init.apply this, arguments
    else
      $.error "Method " + method + " does not exist on jQuery.foundationTopBar"

  
  # Monitor scroll position for sticky
  if $(".sticky").length > 0
    distance = (if $(".sticky").length then $(".sticky").offset().top else 0)
    $window = $(window)
    $window.scroll ->
      if $window.scrollTop() >= distance
        $(".sticky").addClass "fixed"
      else $(".sticky").removeClass "fixed"  if $window.scrollTop() < distance

) jQuery, this
