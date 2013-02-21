(($, window, undefided) ->
  "use strict"
  $.fn.foundationAlerts = (options) ->
     settings = $.extend({
      callback : $.noop
     }, options) 

     $(document).on("click", ".alert-box a.close", 
      (e)->
        e.preventDefault()
        $(this).closest(".alert-box").fadeOut(()->
          $(this).remove()))
) jQuery, this