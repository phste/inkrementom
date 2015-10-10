{CompositeDisposable} = require 'atom'

module.exports = Inkrementom =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'inkrementom:inc': => @increment(),
      'inkrementom:dec': => @decrement()

  deactivate: ->
    @subscriptions.dispose()

  operate: (num) ->

    editor = atom.workspace.getActiveTextEditor()
    position = editor.getLastCursor().getScreenPosition()

    editor.moveToBeginningOfWord()
    editor.selectToNextWordBoundary()

    #editor.selectWordsContainingCursors()
    cursorWord = editor.getSelectedText()

    console.log cursorWord

    m = cursorWord.match(/(\d+)(\w*)/)

    if m
      number = parseFloat cursorWord

      selection = editor.getLastSelection()
      console.log selection

      blup = number + num
      selection.insertText(blup.toString() + m[2])
      editor.setCursorScreenPosition(position)





  increment: ->
    @operate(1)

  decrement: ->
    @operate(-1)
