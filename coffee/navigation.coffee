(($, window, undefined_) ->
  "use strict"
  $.fn.foundationNavigation = (options) ->
    lockNavBar = false
    
    # Windows Phone, sadly, does not register touch events :(
    if Modernizr.touch or navigator.userAgent.match(/Windows Phone/i)
      $(document).on "click.fndtn touchstart.fndtn", ".nav-bar a.flyout-toggle", (e) ->
        e.preventDefault()
        flyout = $(this).siblings(".flyout").first()
        if lockNavBar is false
          $(".nav-bar .flyout").not(flyout).slideUp 500
          flyout.slideToggle 500, ->
            lockNavBar = false

        lockNavBar = true

      $(".nav-bar>li.has-flyout", this).addClass "is-touch"
    else
      $(".nav-bar>li.has-flyout", this).on "mouseenter mouseleave", (e) ->
        if e.type is "mouseenter"
          $(".nav-bar").find(".flyout").hide()
          $(this).children(".flyout").show()
        if e.type is "mouseleave"
          flyout = $(this).children(".flyout")
          inputs = flyout.find("input")
          hasFocus = (inputs) ->
            focus = undefined
            if inputs.length > 0
              inputs.each ->
                focus = true  if $(this).is(":focus")

              return focus
            false

          $(this).children(".flyout").hide()  unless hasFocus(inputs)

) jQuery, this
