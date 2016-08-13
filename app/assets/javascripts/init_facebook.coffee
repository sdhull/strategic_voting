bindFacebookEvents = ->
  $(document)
    .on('turbolinks:request-start', saveFacebookRoot)
    .on('turbolinks:render', restoreFacebookRoot)
    .on('turbolinks:load', ->
      console.log "parsing XFBML"
      FB?.XFBML.parse()
    )
  window.fbEventsBound = true

saveFacebookRoot = ->
  console.log "saving fb root"
  if $('#fb-root').length
    @fbRoot = $('#fb-root').detach()

restoreFacebookRoot = ->
  console.log "restoring fb root"
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
