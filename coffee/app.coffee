###
  Inspired in foundation v.3.2
  app: app.coffee
###
(($, window) ->
  "use strict"
  $doc = $(document)
  Modernizr = window.Modernizr
  $(document).ready ->
    (if $.fn.Alerts then $doc.Alerts() else null)
    (if $.fn.Buttons then $doc.Buttons() else null)
    (if $.fn.Accordion then $doc.Accordion() else null)
    (if $.fn.Navigation then $doc.Navigation() else null)
    (if $.fn.TopBar then $doc.TopBar() else null)
    (if $.fn.CustomForms then $doc.CustomForms() else null)
    (if $.fn.MediaQueryViewer then $doc.MediaQueryViewer() else null)
    (if $.fn.Tabs then $doc.Tabs({callback: $.shurikend.customForms.appendCustomMarkup}) else null)
    (if $.fn.Tooltips then $doc.Tooltips() else null)
    (if $.fn.Magellan then $doc.Magellan() else null)

    (if $.fn.placeholder then $("input, textarea").placeholder() else null)

  
  # UNCOMMENT THE LINE YOU WANT BELOW IF YOU WANT IE8 SUPPORT AND ARE USING .block-grids
  # $('.block-grid.two-up>li:nth-child(2n+1)').css({clear: 'both'});
  # $('.block-grid.three-up>li:nth-child(3n+1)').css({clear: 'both'});
  # $('.block-grid.four-up>li:nth-child(4n+1)').css({clear: 'both'});
  # $('.block-grid.five-up>li:nth-child(5n+1)').css({clear: 'both'});
  
  # Hide address bar on mobile devices (except if #hash present, so we don't mess up deep linking).
  if Modernizr.touch and not window.location.hash
    $(window).load ->
      setTimeout (->
        # At load, if user hasn't scrolled more than 20px or so...
        window.scrollTo 0, 1  if $(window).scrollTop() < 20
      ), 0

) jQuery, this
