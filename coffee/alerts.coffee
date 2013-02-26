###
  Inspired in foundation v.3.2
  alerts: alerts.coffee
###
(($, window) ->
  "use strict"
  $.fn.Alerts = (options) ->
     settings = $.extend({
      callback : $.noop
     }, options) 

     $(document).on("click", ".alert-box a.close", 
      (e)->
        e.preventDefault()
        $(this).closest(".alert-box").fadeOut(()->
          $(this).remove()))
) jQuery, this