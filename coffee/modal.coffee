#
# * jQuery Reveal Plugin 1.1
# * www.ZURB.com
# * Copyright 2010, ZURB
# * Free to use under the MIT license.
# * http://www.opensource.org/licenses/mit-license.php
#

#globals jQuery 
(($) ->
  "use strict"
  
  #
  # Global variable.
  # Helps us determine if the current modal is being queued for display.
  #
  modalQueued = false
  
  #
  # Bind the live 'click' event to all anchor elemnets with the data-reveal-id attribute.
  #
  $(document).on "click", "a[data-reveal-id]", (event) ->
    
    #
    # Prevent default action of the event.
    #
    event.preventDefault()
    
    #
    # Get the clicked anchor data-reveal-id attribute value.
    #
    modalLocation = $(this).attr("data-reveal-id")
    
    #
    # Find the element with that modalLocation id and call the reveal plugin.
    #
    $("#" + modalLocation).reveal $(this).data()

  
  ###
  @module reveal
  @property {Object} [options] Reveal options
  ###
  $.fn.reveal = (options) ->
    
    #
    #       * Cache the document object.
    #       
    $doc = $(document)
    defaults =
      
      #
      #         * Default property values.
      #         
      
      ###
      Possible options: fade, fadeAndPop, none
      
      @property animation
      @type {String}
      @default fadeAndPop
      ###
      animation: "fadeAndPop"
      
      ###
      Speed at which the reveal should show. How fast animtions are.
      
      @property animationSpeed
      @type {Integer}
      @default 300
      ###
      animationSpeed: 300
      
      ###
      Should the modal close when the background is clicked?
      
      @property closeOnBackgroundClick
      @type {Boolean}
      @default true
      ###
      closeOnBackgroundClick: true
      
      ###
      Specify a class name for the 'close modal' element.
      This element will close an open modal.
      
      @example
      <a href='#close' class='close-reveal-modal'>Close Me</a>
      
      @property dismissModalClass
      @type {String}
      @default close-reveal-modal
      ###
      dismissModalClass: "close-reveal-modal"
      
      ###
      Specify a callback function that triggers 'before' the modal opens.
      
      @property open
      @type {Function}
      @default function(){}
      ###
      open: $.noop
      
      ###
      Specify a callback function that triggers 'after' the modal is opened.
      
      @property opened
      @type {Function}
      @default function(){}
      ###
      opened: $.noop
      
      ###
      Specify a callback function that triggers 'before' the modal prepares to close.
      
      @property close
      @type {Function}
      @default function(){}
      ###
      close: $.noop
      
      ###
      Specify a callback function that triggers 'after' the modal is closed.
      
      @property closed
      @type {Function}
      @default function(){}
      ###
      closed: $.noop

    
    #
    # Extend the default options.
    # This replaces the passed in option (options) values with default values.
    #
    options = $.extend({}, defaults, options)
    
    #
    # Apply the plugin functionality to each element in the jQuery collection.
    #
    @not(".reveal-modal.open").each ->
      
      #
      # Cache the modal element
      #
      
      #
      # Get the current css 'top' property value in decimal format.
      #
      
      #
      # Calculate the top offset.
      #
      
      #
      # Helps determine if the modal is locked.
      # This way we keep the modal from triggering while it's in the middle of animating.
      #
      
      #
      # Get the modal background element.
      #
      
      #
      # Show modal properties
      #
      
      #
      # Used, when we show the modal.
      #
      
      #
      # Set the 'top' property to the document scroll minus the calculated top offset.
      #
      
      #
      # Opacity gets set to 0.
      #
      
      #
      # Show the modal
      #
      
      #
      # Ensure it's displayed as a block element.
      #
      
      #
      # Used, when we hide the modal.
      #
      
      #
      # Set the default 'top' property value.
      #
      
      #
      # Has full opacity.
      #
      
      #
      # Hide the modal
      #
      
      #
      # Ensure the elment is hidden.
      #
      
      #
      # Initial closeButton variable.
      #
      
      #
      # Do we have a modal background element?
      #
      
      #
      # No we don't. So, let's create one.
      #
      
      #
      # Then insert it after the modal element.
      #
      
      #
      # Now, fade it out a bit.
      #
      
      #
      # Helper Methods
      #
      
      ###
      Unlock the modal for animation.
      
      @method unlockModal
      ###
      unlockModal = ->
        locked = false
      
      ###
      Lock the modal to prevent further animation.
      
      @method lockModal
      ###
      lockModal = ->
        locked = true
      
      ###
      Closes all open modals.
      
      @method closeOpenModal
      ###
      closeOpenModals = ->
        
        #
        # Get all reveal-modal elements with the .open class.
        #
        $openModals = $(".reveal-modal.open")
        
        #
        # Do we have modals to close?
        #
        if $openModals.length is 1
          
          #
          # Set the modals for animation queuing.
          #
          modalQueued = true
          
          #
          # Trigger the modal close event.
          #
          $openModals.trigger "reveal:close"
      
      ###
      Animates the modal opening.
      Handles the modal 'open' event.
      
      @method openAnimation
      ###
      openAnimation = ->
        
        #
        # First, determine if we're in the middle of animation.
        #
        unless locked
          
          #
          # We're not animating, let's lock the modal for animation.
          #
          lockModal()
          
          #
          # Close any opened modals.
          #
          closeOpenModals()
          
          #
          # Now, add the open class to this modal.
          #
          modal.addClass "open"
          
          #
          # Are we executing the 'fadeAndPop' animation?
          #
          if options.animation is "fadeAndPop"
            
            #
            # Yes, we're doing the 'fadeAndPop' animation.
            # Okay, set the modal css properties.
            #
            #
            # Set the 'top' property to the document scroll minus the calculated top offset.
            #
            cssOpts.open.top = $doc.scrollTop() - topOffset
            
            #
            # Flip the opacity to 0.
            #
            cssOpts.open.opacity = 0
            
            #
            # Set the css options.
            #
            modal.css cssOpts.open
            
            #
            # Fade in the background element, at half the speed of the modal element.
            # So, faster than the modal element.
            #
            modalBg.fadeIn options.animationSpeed / 2
            
            #
            # Let's delay the next animation queue.
            # We'll wait until the background element is faded in.
            #
            
            #
            # Animate the following css properties.
            #
            modal.delay(options.animationSpeed / 2).animate
              
              #
              # Set the 'top' property to the document scroll plus the calculated top measure.
              #
              top: $doc.scrollTop() + topMeasure + "px"
              
              #
              # Set it to full opacity.
              #
              opacity: 1
            
            #
            #             * Fade speed.
            #             
            
            #
            #             * End of animation callback.
            #             
            , options.animationSpeed, ->
              
              #
              # Trigger the modal reveal:opened event.
              # This should trigger the functions set in the options.opened property.
              #
              modal.trigger "reveal:opened"

          # end of animate.
          # end if 'fadeAndPop'
          
          #
          # Are executing the 'fade' animation?
          #
          if options.animation is "fade"
            
            #
            # Yes, were executing 'fade'.
            # Okay, let's set the modal properties.
            #
            cssOpts.open.top = $doc.scrollTop() + topMeasure
            
            #
            # Flip the opacity to 0.
            #
            cssOpts.open.opacity = 0
            
            #
            # Set the css options.
            #
            modal.css cssOpts.open
            
            #
            # Fade in the modal background at half the speed of the modal.
            # So, faster than modal.
            #
            modalBg.fadeIn options.animationSpeed / 2
            
            #
            # Delay the modal animation.
            # Wait till the modal background is done animating.
            #
            
            #
            # Now animate the modal.
            #
            modal.delay(options.animationSpeed / 2).animate
              
              #
              # Set to full opacity.
              #
              opacity: 1
            
            #
            #             * Animation speed.
            #             
            
            #
            #             * End of animation callback.
            #             
            , options.animationSpeed, ->
              
              #
              # Trigger the modal reveal:opened event.
              # This should trigger the functions set in the options.opened property.
              #
              modal.trigger "reveal:opened"

          # end if 'fade'
          
          #
          # Are we not animating?
          #
          if options.animation is "none"
            
            #
            # We're not animating.
            # Okay, let's set the modal css properties.
            #
            #
            # Set the top property.
            #
            cssOpts.open.top = $doc.scrollTop() + topMeasure
            
            #
            # Set the opacity property to full opacity, since we're not fading (animating).
            #
            cssOpts.open.opacity = 1
            
            #
            # Set the css property.
            #
            modal.css cssOpts.open
            
            #
            # Show the modal Background.
            #
            modalBg.css display: "block"
            
            #
            # Trigger the modal opened event.
            #
            modal.trigger "reveal:opened"
      # end if animating 'none'
      # end if !locked
      # end openAnimation
      openVideos = ->
        video = modal.find(".flex-video")
        iframe = video.find("iframe")
        if iframe.length > 0
          iframe.attr "src", iframe.data("src")
          video.fadeIn 100
      
      #
      # Bind the reveal 'open' event.
      # When the event is triggered, openAnimation is called
      # along with any function set in the options.open property.
      #
      
      ###
      Closes the modal element(s)
      Handles the modal 'close' event.
      
      @method closeAnimation
      ###
      closeAnimation = ->
        
        #
        # First, determine if we're in the middle of animation.
        #
        unless locked
          
          #
          # We're not animating, let's lock the modal for animation.
          #
          lockModal()
          
          #
          # Clear the modal of the open class.
          #
          modal.removeClass "open"
          
          #
          # Are we using the 'fadeAndPop' animation?
          #
          if options.animation is "fadeAndPop"
            
            #
            # Yes, okay, let's set the animation properties.
            #
            modal.animate
              
              #
              # Set the top property to the document scrollTop minus calculated topOffset.
              #
              top: $doc.scrollTop() - topOffset + "px"
              
              #
              # Fade the modal out, by using the opacity property.
              #
              opacity: 0
            
            #
            #             * Fade speed.
            #             
            
            #
            #             * End of animation callback.
            #             
            , options.animationSpeed / 2, ->
              
              #
              # Set the css hidden options.
              #
              modal.css cssOpts.close

            
            #
            # Is the modal animation queued?
            #
            unless modalQueued
              
              #
              # Oh, the modal(s) are mid animating.
              # Let's delay the animation queue.
              #
              
              #
              # Fade out the modal background.
              #
              
              #
              #               * Animation speed.
              #               
              
              #
              #              * End of animation callback.
              #              
              modalBg.delay(options.animationSpeed).fadeOut options.animationSpeed, ->
                
                #
                # Trigger the modal 'closed' event.
                # This should trigger any method set in the options.closed property.
                #
                modal.trigger "reveal:closed"

            else
              
              #
              # We're not mid queue.
              # Trigger the modal 'closed' event.
              # This should trigger any method set in the options.closed propety.
              #
              modal.trigger "reveal:closed"
          # end if !modalQueued
          # end if animation 'fadeAndPop'
          
          #
          # Are we using the 'fade' animation.
          #
          if options.animation is "fade"
            
            #
            # Yes, we're using the 'fade' animation.
            #
            modal.animate
              opacity: 0
            
            #
            #               * Animation speed.
            #               
            
            #
            #               * End of animation callback.
            #               
            , options.animationSpeed, ->
              
              #
              # Set the css close options.
              #
              modal.css cssOpts.close

            # end animate
            
            #
            # Are we mid animating the modal(s)?
            #
            unless modalQueued
              
              #
              # Oh, the modal(s) are mid animating.
              # Let's delay the animation queue.
              #
              
              #
              # Let's fade out the modal background element.
              #
              
              #
              #               * Animation speed.
              #               
              
              #
              #                 * End of animation callback.
              #                 
              modalBg.delay(options.animationSpeed).fadeOut options.animationSpeed, ->
                
                #
                # Trigger the modal 'closed' event.
                # This should trigger any method set in the options.closed propety.
                #
                modal.trigger "reveal:closed"

            # end fadeOut
            else
              
              #
              # We're not mid queue.
              # Trigger the modal 'closed' event.
              # This should trigger any method set in the options.closed propety.
              #
              modal.trigger "reveal:closed"
          # end if !modalQueued
          # end if animation 'fade'
          
          #
          # Are we not animating?
          #
          if options.animation is "none"
            
            #
            # We're not animating.
            # Set the modal close css options.
            #
            modal.css cssOpts.close
            
            #
            # Is the modal in the middle of an animation queue?
            #
            
            #
            # It's not mid queueu. Just hide it.
            #
            modalBg.css display: "none"  unless modalQueued
            
            #
            # Trigger the modal 'closed' event.
            # This should trigger any method set in the options.closed propety.
            #
            modal.trigger "reveal:closed"
          # end if not animating
          #
          # Reset the modalQueued variable.
          #
          modalQueued = false
      # end if !locked
      # end closeAnimation
      
      ###
      Destroys the modal and it's events.
      
      @method destroy
      ###
      destroy = ->
        
        #
        # Unbind all .reveal events from the modal.
        #
        modal.unbind ".reveal"
        
        #
        # Unbind all .reveal events from the modal background.
        #
        modalBg.unbind ".reveal"
        
        #
        # Unbind all .reveal events from the modal 'close' button.
        #
        $closeButton.unbind ".reveal"
        
        #
        # Unbind all .reveal events from the body.
        #
        $("body").unbind ".reveal"
      closeVideos = ->
        video = modal.find(".flex-video")
        iframe = video.find("iframe")
        if iframe.length > 0
          iframe.data "src", iframe.attr("src")
          iframe.attr "src", ""
          video.fadeOut 100
      modal = $(this)
      topMeasure = parseInt(modal.css("top"), 10)
      topOffset = modal.height() + topMeasure
      locked = false
      modalBg = $(".reveal-modal-bg")
      cssOpts =
        open:
          top: 0
          opacity: 0
          visibility: "visible"
          display: "block"

        close:
          top: topMeasure
          opacity: 1
          visibility: "hidden"
          display: "none"

      $closeButton = undefined
      if modalBg.length is 0
        modalBg = $("<div />",
          class: "reveal-modal-bg"
        ).insertAfter(modal)
        modalBg.fadeTo "fast", 0.8
      modal.bind "reveal:open.reveal", openAnimation
      modal.bind "reveal:open.reveal", openVideos
      
      #
      # Bind the modal 'close' event
      #
      modal.bind "reveal:close.reveal", closeAnimation
      modal.bind "reveal:closed.reveal", closeVideos
      
      #
      # Bind the modal 'opened' + 'closed' event
      # Calls the unlockModal method.
      #
      modal.bind "reveal:opened.reveal reveal:closed.reveal", unlockModal
      
      #
      # Bind the modal 'closed' event.
      # Calls the destroy method.
      #
      modal.bind "reveal:closed.reveal", destroy
      
      #
      # Bind the modal 'open' event
      # Handled by the options.open property function.
      #
      modal.bind "reveal:open.reveal", options.open
      
      #
      # Bind the modal 'opened' event.
      # Handled by the options.opened property function.
      #
      modal.bind "reveal:opened.reveal", options.opened
      
      #
      # Bind the modal 'close' event.
      # Handled by the options.close property function.
      #
      modal.bind "reveal:close.reveal", options.close
      
      #
      # Bind the modal 'closed' event.
      # Handled by the options.closed property function.
      #
      modal.bind "reveal:closed.reveal", options.closed
      
      #
      # We're running this for the first time.
      # Trigger the modal 'open' event.
      #
      modal.trigger "reveal:open"
      
      #
      # Get the closeButton variable element(s).
      #
      
      #
      # Bind the element 'click' event and handler.
      #
      $closeButton = $("." + options.dismissModalClass).bind("click.reveal", ->
        
        #
        # Trigger the modal 'close' event.
        #
        modal.trigger "reveal:close"
      )
      
      #
      # Should we close the modal background on click?
      #
      if options.closeOnBackgroundClick
        
        #
        # Yes, close the modal background on 'click'
        # Set the modal background css 'cursor' propety to pointer.
        # Adds a pointer symbol when you mouse over the modal background.
        #
        modalBg.css cursor: "pointer"
        
        #
        # Bind a 'click' event handler to the modal background.
        #
        modalBg.bind "click.reveal", ->
          
          #
          # Trigger the modal 'close' event.
          #
          modal.trigger "reveal:close"

      
      #
      # Bind keyup functions on the body element.
      # We'll want to close the modal when the 'escape' key is hit.
      #
      $("body").bind "keyup.reveal", (event) ->
        
        #
        # Did the escape key get triggered?
        #
        # 27 is the keycode for the Escape key
        #
        # Escape key was triggered.
        # Trigger the modal 'close' event.
        #
        modal.trigger "reveal:close"  if event.which is 27


# end $(body)
# end this.each
# end $.fn
) jQuery
