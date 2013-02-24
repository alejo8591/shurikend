###
  Inspired in jquery-placeholder
  jquery-placeholder: jquery-placeholder.coffee
###

#! http://mths.be/placeholder v2.0.7 by @mathias 
((window, document, $) ->
  
  # Issue #56: Setting the placeholder causes problems if the element continues to have focus.
  
  # We can't use `triggerHandler` here because of dummy text/password inputs :(
  
  # `set` can not return `undefined`; see http://jsapi.info/jquery/1.7.1/val#L2363
  
  # Look for forms
  
  # Clear the placeholder values so they don't get submitted
  
  # Clear placeholder values upon page reload
  args = (elem) ->
    
    # Return an object of element attributes
    newAttrs = {}
    rinlinejQuery = /^jQuery\d+$/
    $.each elem.attributes, (i, attr) ->
      newAttrs[attr.name] = attr.value  if attr.specified and not rinlinejQuery.test(attr.name)

    newAttrs
  clearPlaceholder = (event, value) ->
    input = this
    $input = $(input)
    if input.value is $input.attr("placeholder") and $input.hasClass("placeholder")
      if $input.data("placeholder-password")
        $input = $input.hide().next().show().attr("id", $input.removeAttr("id").data("placeholder-id"))
        
        # If `clearPlaceholder` was called from `$.valHooks.input.set`
        return $input[0].value = value  if event is true
        $input.focus()
      else
        input.value = ""
        $input.removeClass "placeholder"
        input is document.activeElement and input.select()
  setPlaceholder = ->
    $replacement = undefined
    input = this
    $input = $(input)
    $origInput = $input
    id = @id
    if input.value is ""
      if input.type is "password"
        unless $input.data("placeholder-textinput")
          try
            $replacement = $input.clone().attr(type: "text")
          catch e
            $replacement = $("<input>").attr($.extend(args(this),
              type: "text"
            ))
          $replacement.removeAttr("name").data(
            "placeholder-password": true
            "placeholder-id": id
          ).bind "focus.placeholder", clearPlaceholder
          $input.data(
            "placeholder-textinput": $replacement
            "placeholder-id": id
          ).before $replacement
        $input = $input.removeAttr("id").hide().prev().attr("id", id).show()
      
      # Note: `$input[0] != input` now!
      $input.addClass "placeholder"
      $input[0].value = $input.attr("placeholder")
    else
      $input.removeClass "placeholder"
  isInputSupported = "placeholder" of document.createElement("input")
  isTextareaSupported = "placeholder" of document.createElement("textarea")
  prototype = $.fn
  valHooks = $.valHooks
  hooks = undefined
  placeholder = undefined
  if isInputSupported and isTextareaSupported
    placeholder = prototype.placeholder = ->
      this

    placeholder.input = placeholder.textarea = true
  else
    placeholder = prototype.placeholder = ->
      $this = this
      $this.filter(((if isInputSupported then "textarea" else ":input")) + "[placeholder]").not(".placeholder").bind(
        "focus.placeholder": clearPlaceholder
        "blur.placeholder": setPlaceholder
      ).data("placeholder-enabled", true).trigger "blur.placeholder"
      $this

    placeholder.input = isInputSupported
    placeholder.textarea = isTextareaSupported
    hooks =
      get: (element) ->
        $element = $(element)
        (if $element.data("placeholder-enabled") and $element.hasClass("placeholder") then "" else element.value)

      set: (element, value) ->
        $element = $(element)
        return element.value = value  unless $element.data("placeholder-enabled")
        if value is ""
          element.value = value
          setPlaceholder.call element  unless element is document.activeElement
        else if $element.hasClass("placeholder")
          clearPlaceholder.call(element, true, value) or (element.value = value)
        else
          element.value = value
        $element

    isInputSupported or (valHooks.input = hooks)
    isTextareaSupported or (valHooks.textarea = hooks)
    $ ->
      $(document).delegate "form", "submit.placeholder", ->
        $inputs = $(".placeholder", this).each(clearPlaceholder)
        setTimeout (->
          $inputs.each setPlaceholder
        ), 10


    $(window).bind "beforeunload.placeholder", ->
      $(".placeholder").each ->
        @value = ""


) this, document, jQuery
