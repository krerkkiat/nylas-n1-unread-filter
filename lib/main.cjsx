{ComponentRegistry,
 Threads,
 Actions,
 WorkspaceStore} = require 'nylas-exports'

UnreadMailViewFilter = require './unread-mail-view-filter'

module.exports =
  # Activate is called when the package is loaded. If your package previously
  # saved state using `serialize` it is provided.
  #
  activate: (@state) ->
    # Arbitary non-default value
    @originalMarkAsReadDelay = -2
    @unlistenFocusMailView = Actions.focusMailView.listen(@_focusMailView)
    @unlistenOpenPreferences = Actions.openPreferences.listen(@_openPreferences)

    WorkspaceStore.addSidebarItem new WorkspaceStore.SidebarItem({
      name: "Unread",
      section: "Custom Filters",
      mailViewFilter: new UnreadMailViewFilter(),
      sheet: Threads
    })

  _focusMailView: (data) ->
    if data.name == 'Unread'
      # Some how when the activate() is called the default value is undefined.
      @originalMarkAsReadDelay = NylasEnv.config.get('core.reading.markAsReadDelay')
      NylasEnv.config.set('core.reading.markAsReadDelay', -1)
    else
      # Make sure that we have default value before we change it.
      if @originalMarkAsReadDelay != -2
        NylasEnv.config.set('core.reading.markAsReadDelay', @originalMarkAsReadDelay)

  _openPreferences: ->
    @originalMarkAsReadDelay = NylasEnv.config.get('core.reading.markAsReadDelay')

  # Serialize is called when your package is about to be unmounted.
  # You can return a state object that will be passed back to your package
  # when it is re-activated.
  #
  serialize: ->

  # This **optional** method is called when the window is shutting down,
  # or when your package is being updated or disabled. If your package is
  # watching any files, holding external resources, providing commands or
  # subscribing to events, release them here.
  #
  deactivate: ->
    @unlistenFocusMailView()
    @unlistenOpenPreferences()
