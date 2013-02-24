###
  Inspired in foundation v.3.2
  magellan: magellan.coffee
###
#
# * jQuery Foundation Magellan 0.1.0
# * http://foundation.zurb.com
# * Copyright 2012, ZURB
# * Free to use under the MIT license.
# * http://www.opensource.org/licenses/mit-license.php
#
#jslint unparam: true, browser: true, indent: 2 
(($, window) ->
  "use strict"

  $.fn.foundationMagellan = (options) ->
    $window = $(window)
    $document = $(document)
    $fixedMagellan = $("[data-magellan-expedition=fixed]")
    defaults =
      threshold: (if ($fixedMagellan.length) then $fixedMagellan.outerHeight(true) else 0)
      activeClass: "active"

    options = $.extend({}, defaults, options)
    
    # Indicate we have arrived at a destination
    $document.on "magellan.arrival", "[data-magellan-arrival]", (e) ->
      $destination = $(this)
      $expedition = $destination.closest("[data-magellan-expedition]")
      activeClass = $expedition.attr("data-magellan-active-class") or options.activeClass
      $destination.closest("[data-magellan-expedition]").find("[data-magellan-arrival]").not(this).removeClass activeClass
      $destination.addClass activeClass

    
    # Set starting point as the current destination
    $expedition = $("[data-magellan-expedition]")
    $expedition.find("[data-magellan-arrival]:first").addClass $expedition.attr("data-magellan-active-class") or options.activeClass
    
    # Update fixed position
    $fixedMagellan.on("magellan.update-position", ->
      $el = $(this)
      $el.data "magellan-fixed-position", ""
      $el.data "magellan-top-offset", ""
    ).trigger "magellan.update-position"
    $window.on "resize.magellan", ->
      $fixedMagellan.trigger "magellan.update-position"

    $window.on "scroll.magellan", ->
      windowScrollTop = $window.scrollTop()
      $fixedMagellan.each ->
        $expedition = $(this)
        $expedition.data "magellan-top-offset", $expedition.offset().top  if $expedition.data("magellan-top-offset") is ""
        fixed_position = (windowScrollTop + options.threshold) > $expedition.data("magellan-top-offset")
        unless $expedition.data("magellan-fixed-position") is fixed_position
          $expedition.data "magellan-fixed-position", fixed_position
          if fixed_position
            $expedition.css
              position: "fixed"
              top: 0

          else
            $expedition.css
              position: ""
              top: ""

    # Determine when a destination has been reached, ah0y!
    $lastDestination = $("[data-magellan-destination]:last")
    
    # Determine if a destination has been set
    if $lastDestination.length > 0
      $window.on "scroll.magellan", (e) ->
        windowScrollTop = $window.scrollTop()
        scrolltopPlusHeight = windowScrollTop + $window.outerHeight(true)
        lastDestinationTop = Math.ceil($lastDestination.offset().top)
        $("[data-magellan-destination]").each ->
          $destination = $(this)
          destination_name = $destination.attr("data-magellan-destination")
          topOffset = $destination.offset().top - windowScrollTop
          $("[data-magellan-arrival=" + destination_name + "]").trigger "magellan.arrival"  if topOffset <= options.threshold
          
          # In large screens we may hit the bottom of the page and dont reach the top of the last magellan-destination, so lets force it
          $("[data-magellan-arrival]:last").trigger "magellan.arrival"  if scrolltopPlusHeight >= $document.outerHeight(true) and lastDestinationTop > windowScrollTop and lastDestinationTop < scrolltopPlusHeight

) jQuery, this
