{WorkspaceStore,
 Thread,
 ChangeUnreadTask,
 MailViewFilter} = require 'nylas-exports'

class UnreadMailViewFilter extends MailViewFilter

  constructor: ->
    @name = "Unread"
    @iconName = "toolbar-markasunread.png"
    @

  matchers: ->
    [Thread.attributes.unread.equal(true)]

  categoryId: ->
    null

  canApplyToThreads: ->
    true

  canArchiveThreads: ->
    false

  canTrashThreads: ->
    false

  applyToThreads: (threadsOrIds) ->
    task = new ChangeUnreadTask({threads:threadsOrIds, unread: true})
    Actions.queueTask(task)

module.exports = UnreadMailViewFilter