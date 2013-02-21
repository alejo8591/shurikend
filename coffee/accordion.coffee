(($, window, undefined_) ->
  "use strict"
  $.fn.foundationAccordion = (options) ->
    
    # DRY up the logic used to determine if the event logic should execute.
    hasHover = (accordion) ->
      accordion.hasClass("hover") and not Modernizr.touch

    $(document).on "mouseenter", ".accordion li", ->
      p = $(this).parent()
      if hasHover(p)
        flyout = $(this).children(".content").first()
        $(".content", p).not(flyout).hide().parent("li").removeClass "active"
        flyout.show 0, ->
          flyout.parent("li").addClass "active"


    $(document).on "click.fndtn", ".accordion li .title", ->
      li = $(this).closest("li")
      p = li.parent()
      unless hasHover(p)
        flyout = li.children(".content").first()
        if li.hasClass("active")
          p.find("li").removeClass("active").end().find(".content").hide()
        else
          $(".content", p).not(flyout).hide().parent("li").removeClass "active"
          flyout.show 0, ->
            flyout.parent("li").addClass "active"


) jQuery, this
