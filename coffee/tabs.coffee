(($, window, document, undefined_) ->
  "use strict"
  settings =
    callback: $.noop
    deep_linking: true
    init: false

  methods =
    init: (options) ->
      settings = $.extend({}, settings, options)
      @each ->
        methods.events()  unless settings.init
        methods.from_hash()  if settings.deep_linking


    events: ->
      $(document).on "click.fndtn", ".tabs a", (e) ->
        methods.set_tab $(this).parent("dd, li"), e

      settings.init = true

    set_tab: ($tab, e) ->
      $activeTab = $tab.closest("dl, ul").find(".active")
      target = $tab.children("a").attr("href")
      hasHash = /^#/.test(target)
      $content = $(target + "Tab")
      if hasHash and $content.length > 0
        
        # Show tab content
        e.preventDefault()  if e and not settings.deep_linking
        $content.closest(".tabs-content").children("li").removeClass("active").hide()
        $content.css("display", "block").addClass "active"
      
      # Make active tab
      $activeTab.removeClass "active"
      $tab.addClass "active"
      settings.callback()

    from_hash: ->
      hash = window.location.hash
      $tab = $("a[href=\"" + hash + "\"]")
      $tab.trigger "click.fndtn"

  $.fn.foundationTabs = (method) ->
    if methods[method]
      methods[method].apply this, Array::slice.call(arguments_, 1)
    else if typeof method is "object" or not method
      methods.init.apply this, arguments_
    else
      $.error "Method " + method + " does not exist on jQuery.foundationTabs"
) jQuery, this, @document
