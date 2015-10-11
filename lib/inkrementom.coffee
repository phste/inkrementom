{CompositeDisposable} = require 'atom'

module.exports = Inkrementom =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'inkrementom:inc1': => @operate(1),
      'inkrementom:dec1': => @operate(-1),
      'inkrementom:inc10': => @operate(10),
      'inkrementom:dec10': => @operate(-10)

  deactivate: ->
    @subscriptions.dispose()

  operate: (step) ->
    editor = atom.workspace.getActiveTextEditor()
    position = editor.getLastCursor().getScreenPosition()

    # this is the only way to reliably select everything under the cursor
    editor.selectToNextSubwordBoundary()
    editor.selectWordsContainingCursors()
    wordUnderCursor = editor.getSelectedText()

    # check if word under cursor is a number containing a post-fix
    # eg px or %
    m = wordUnderCursor.match(/(\d+)(\w*)/)

    if m
      postfix = m[2] # usually px or %
      value = parseFloat wordUnderCursor
      selection = editor.getLastSelection()
      adjustedValue = value + step
      selection.insertText(adjustedValue.toString() + postfix)
      editor.setCursorScreenPosition(position)
