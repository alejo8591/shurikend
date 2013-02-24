###
  Inspired in foundation v.3.2
  mediaQueryToggle: mediaQueryToggle.coffee
###
(($, window) ->
  "use strict"
  $.fn.foundationMediaQueryViewer = (options) ->
    settings = $.extend(options, # Press 'M'
      toggleKey: 77
    )
    $doc = $(document)
    $doc.on "keyup.mediaQueryViewer", ":input", (e) ->
      e.stopPropagation()  if e.which is settings.toggleKey

    $doc.on "keyup.mediaQueryViewer", (e) ->
      $mqViewer = $("#fqv")
      if e.which is settings.toggleKey
        if $mqViewer.length > 0
          $mqViewer.remove()
        else
          $("body").prepend "<div id=\"fqv\" style=\"position:fixed;top:4px;left:4px;z-index:999;color:#fff;\"><p style=\"font-size:12px;background:rgba(0,0,0,0.75);padding:5px;margin-bottom:1px;line-height:1.2;\"><span class=\"left\">Media:</span> <span style=\"font-weight:bold;\" class=\"show-for-xlarge\">Extra Large</span><span style=\"font-weight:bold;\" class=\"show-for-large\">Large</span><span style=\"font-weight:bold;\" class=\"show-for-medium\">Medium</span><span style=\"font-weight:bold;\" class=\"show-for-small\">Small</span><span style=\"font-weight:bold;\" class=\"show-for-landscape\">Landscape</span><span style=\"font-weight:bold;\" class=\"show-for-portrait\">Portrait</span><span style=\"font-weight:bold;\" class=\"show-for-touch\">Touch</span></p></div>"

) jQuery, this
