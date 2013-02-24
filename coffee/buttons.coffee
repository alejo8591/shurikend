###
  Inspired in foundation v.3.2
  buttons: buttons.coffee
###
(($, window, undefined_) ->
  "use strict"
  $.fn.foundationButtons = (options) ->
    $doc = $(document)
    config = $.extend(
      dropdownAsToggle: false
      activeClass: "active"
    , options)
    
    # close all dropdowns except for the dropdown passed
    closeDropdowns = (dropdown) ->
      
      # alert(dropdown.html());
      $(".button.dropdown").find("ul").not(dropdown).removeClass "show-dropdown"

    
    # reset all toggle states except for the button passed
    resetToggles = (button) ->
      
      # alert(button.html());
      buttons = $(".button.dropdown").not(button)
      buttons.add($("> span." + config.activeClass, buttons)).removeClass config.activeClass

    
    # Prevent event propagation on disabled buttons
    $doc.on "click.fndtn", ".button.disabled", (e) ->
      e.preventDefault()

    $(".button.dropdown > ul", this).addClass "no-hover"
    
    # reset other active states
    $doc.on "click.fndtn", ".button.dropdown:not(.split), .button.dropdown.split span", (e) ->
      $el = $(this)
      button = $el.closest(".button.dropdown")
      dropdown = $("> ul", button)
      
      # If the click is registered on an actual link or on button element then do not preventDefault which stops the browser from following the link
      e.preventDefault()  if $.inArray(e.target.nodeName, ["A", "BUTTON"])
      
      # close other dropdowns
      setTimeout (->
        closeDropdowns (if config.dropdownAsToggle then "" else dropdown)
        dropdown.toggleClass "show-dropdown"
        if config.dropdownAsToggle
          resetToggles button
          $el.toggleClass config.activeClass
      ), 0

    
    # close all dropdowns and deactivate all buttons
    $doc.on "click.fndtn", "body, html", (e) ->
      return  if `undefined` is e.originalEvent
      
      # check original target instead of stopping event propagation to play nice with other events
      unless $(e.originalEvent.target).is(".button.dropdown:not(.split), .button.dropdown.split span")
        closeDropdowns()
        resetToggles()  if config.dropdownAsToggle

    
    # Positioning the Flyout List
    normalButtonHeight = $(".button.dropdown:not(.large):not(.small):not(.tiny):visible", this).outerHeight() - 1
    largeButtonHeight = $(".button.large.dropdown:visible", this).outerHeight() - 1
    smallButtonHeight = $(".button.small.dropdown:visible", this).outerHeight() - 1
    tinyButtonHeight = $(".button.tiny.dropdown:visible", this).outerHeight() - 1
    $(".button.dropdown:not(.large):not(.small):not(.tiny) > ul", this).css "top", normalButtonHeight
    $(".button.dropdown.large > ul", this).css "top", largeButtonHeight
    $(".button.dropdown.small > ul", this).css "top", smallButtonHeight
    $(".button.dropdown.tiny > ul", this).css "top", tinyButtonHeight
    $(".button.dropdown.up:not(.large):not(.small):not(.tiny) > ul", this).css("top", "auto").css "bottom", normalButtonHeight - 2
    $(".button.dropdown.up.large > ul", this).css("top", "auto").css "bottom", largeButtonHeight - 2
    $(".button.dropdown.up.small > ul", this).css("top", "auto").css "bottom", smallButtonHeight - 2
    $(".button.dropdown.up.tiny > ul", this).css("top", "auto").css "bottom", tinyButtonHeight - 2
) jQuery, this
