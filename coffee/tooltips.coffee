#
# * jQuery Foundation Tooltips 2.0.2
# * http://foundation.zurb.com
# * Copyright 2012, ZURB
# * Free to use under the MIT license.
# * http://www.opensource.org/licenses/mit-license.php
#

#jslint unparam: true, browser: true, indent: 2 
(($, window, undefined_) ->
  "use strict"
  settings =
    bodyHeight: 0
    selector: ".has-tip"
    additionalInheritableClasses: []
    tooltipClass: ".tooltip"
    tipTemplate: (selector, content) ->
      "<span data-selector=\"" + selector + "\" class=\"" + settings.tooltipClass.substring(1) + "\">" + content + "<span class=\"nub\"></span></span>"

  methods =
    init: (options) ->
      settings = $.extend(settings, options)
      
      # alias the old targetClass option
      settings.selector = (if settings.targetClass then settings.targetClass else settings.selector)
      @each ->
        $body = $("body")
        if Modernizr.touch
          $body.on "click.tooltip touchstart.tooltip touchend.tooltip", settings.selector, (e) ->
            e.preventDefault()
            $(settings.tooltipClass).hide()
            methods.showOrCreateTip $(this)

          $body.on "click.tooltip touchstart.tooltip touchend.tooltip", settings.tooltipClass, (e) ->
            e.preventDefault()
            $(this).fadeOut 150

        else
          $body.on "mouseenter.tooltip mouseleave.tooltip", settings.selector, (e) ->
            $this = $(this)
            if e.type is "mouseenter"
              methods.showOrCreateTip $this
            else methods.hide $this  if e.type is "mouseleave"

        $(this).data "tooltips", true


    showOrCreateTip: ($target, content) ->
      $tip = methods.getTip($target)
      if $tip and $tip.length > 0
        methods.show $target
      else
        methods.create $target, content

    getTip: ($target) ->
      selector = methods.selector($target)
      tip = null
      tip = $("span[data-selector=" + selector + "]" + settings.tooltipClass)  if selector
      (if (tip.length > 0) then tip else false)

    selector: ($target) ->
      id = $target.attr("id")
      dataSelector = $target.data("selector")
      if id is `undefined` and dataSelector is `undefined`
        dataSelector = "tooltip" + Math.random().toString(36).substring(7)
        $target.attr "data-selector", dataSelector
      (if (id) then id else dataSelector)

    create: ($target, content) ->
      $tip = $(settings.tipTemplate(methods.selector($target), $("<div>").html((if content then content else $target.attr("title"))).html()))
      classes = methods.inheritable_classes($target)
      $tip.addClass(classes).appendTo "body"
      $tip.append "<span class=\"tap-to-close\">tap to close </span>"  if Modernizr.touch
      $target.removeAttr "title"
      methods.show $target

    reposition: (target, tip, classes) ->
      width = undefined_
      nub = undefined_
      nubHeight = undefined_
      nubWidth = undefined_
      column = undefined_
      objPos = undefined_
      tip.css("visibility", "hidden").show()
      width = target.data("width")
      nub = tip.children(".nub")
      nubHeight = nub.outerHeight()
      nubWidth = nub.outerWidth()
      objPos = (obj, top, right, bottom, left, width) ->
        obj.css(
          top: top
          bottom: bottom
          left: left
          right: right
          "max-width": (if (width) then width else "auto")
        ).end()

      objPos tip, (target.offset().top + target.outerHeight() + 10), "auto", "auto", target.offset().left, width
      objPos nub, -nubHeight, "auto", "auto", 10
      if $(window).width() < 767
        if target.data("mobile-width")
          tip.width(target.data("mobile-width")).css("left", 15).addClass "tip-override"
        else
          column = target.closest(".columns")
          
          # if not using Foundation
          column = $("body")  if column.length < 0
          if column.outerWidth()
            tip.width(column.outerWidth() - 25).css("left", 15).addClass "tip-override"
          else
            tmp_width = Math.ceil($(window).width() * 0.9)
            tip.width(tmp_width).css("left", 15).addClass "tip-override"
        objPos nub, -nubHeight, "auto", "auto", target.offset().left
      else
        if classes and classes.indexOf("tip-top") > -1
          objPos(tip, (target.offset().top - tip.outerHeight() - nubHeight), "auto", "auto", target.offset().left, width).removeClass "tip-override"
          objPos nub, "auto", "auto", -nubHeight, "auto"
        else if classes and classes.indexOf("tip-left") > -1
          objPos(tip, (target.offset().top + (target.outerHeight() / 2) - nubHeight), "auto", "auto", (target.offset().left - tip.outerWidth() - 10), width).removeClass "tip-override"
          objPos nub, (tip.outerHeight() / 2) - (nubHeight / 2), -nubHeight, "auto", "auto"
        else if classes and classes.indexOf("tip-right") > -1
          objPos(tip, (target.offset().top + (target.outerHeight() / 2) - nubHeight), "auto", "auto", (target.offset().left + target.outerWidth() + 10), width).removeClass "tip-override"
          objPos nub, (tip.outerHeight() / 2) - (nubHeight / 2), "auto", "auto", -nubHeight
        else if classes and classes.indexOf("tip-centered-top") > -1
          objPos(tip, (target.offset().top - tip.outerHeight() - nubHeight), "auto", "auto", (target.offset().left + ((target.outerWidth() - tip.outerWidth()) / 2)), width).removeClass "tip-override"
          objPos nub, "auto", ((tip.outerWidth() / 2) - (nubHeight / 2)), -nubHeight, "auto"
        else if classes and classes.indexOf("tip-centered-bottom") > -1
          objPos(tip, (target.offset().top + target.outerHeight() + 10), "auto", "auto", (target.offset().left + ((target.outerWidth() - tip.outerWidth()) / 2)), width).removeClass "tip-override"
          objPos nub, -nubHeight, ((tip.outerWidth() / 2) - (nubHeight / 2)), "auto", "auto"
      tip.css("visibility", "visible").hide()

    inheritable_classes: (target) ->
      inheritables = ["tip-top", "tip-left", "tip-bottom", "tip-right", "tip-centered-top", "tip-centered-bottom", "noradius"].concat(settings.additionalInheritableClasses)
      classes = target.attr("class")
      filtered = (if classes then $.map(classes.split(" "), (el, i) ->
        el  if $.inArray(el, inheritables) isnt -1
      ).join(" ") else "")
      $.trim filtered

    show: ($target) ->
      $tip = methods.getTip($target)
      methods.reposition $target, $tip, $target.attr("class")
      $tip.fadeIn 150

    hide: ($target) ->
      $tip = methods.getTip($target)
      $tip.fadeOut 150

    reload: ->
      $self = $(this)
      (if ($self.data("tooltips")) then $self.foundationTooltips("destroy").foundationTooltips("init") else $self.foundationTooltips("init"))

    destroy: ->
      @each ->
        $(window).off ".tooltip"
        $(settings.selector).off ".tooltip"
        $(settings.tooltipClass).each((i) ->
          $($(settings.selector).get(i)).attr "title", $(this).text()
        ).remove()


  $.fn.foundationTooltips = (method) ->
    if methods[method]
      methods[method].apply this, Array::slice.call(arguments_, 1)
    else if typeof method is "object" or not method
      methods.init.apply this, arguments_
    else
      $.error "Method " + method + " does not exist on jQuery.foundationTooltips"
) jQuery, this
