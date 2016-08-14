bindFacebookEvents = ->
  $(document)
    .on('turbolinks:request-start', saveFacebookRoot)
    .on('turbolinks:render', restoreFacebookRoot)
    .on('turbolinks:load', ->
      FB?.XFBML.parse()
    )
  window.fbEventsBound = true

saveFacebookRoot = ->
  if $('#fb-root').length
    @fbRoot = $('#fb-root').detach()

restoreFacebookRoot = ->
  if @fbRoot?
    if $('#fb-root').length
      $('#fb-root').replaceWith @fbRoot
    else
      $('body').append @fbRoot

loadFacebookSDK = ->
  window.fbAsyncInit = initializeFacebookSDK
  $.getScript("//connect.facebook.net/en_US/sdk.js")

initializeFacebookSDK = ->
  FB.init
    appId  : '173652306389327'
    version: 'v2.7'
    status : true
    cookie : true
    xfbml  : true

loadFacebookSDK()
bindFacebookEvents() unless window.fbEventsBound
