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
    cursorWord = editor.getWordUnderCursor()
    cursor = editor.getLastCursor().getScreenPosition()
    editor.selectWordsContainingCursors()
    test = "9px"
    s = cursorWord.split(/(\d+)([%px]{0,2})/)
    console.log(s)
    console.log(cursorWord)
    incremented = ""
    for element in s
      do (element) ->
        if element != '' && !isNaN(element)
          fvalue = parseFloat(element)
          fvalue += num
          incremented += fvalue.toString();
        else
          incremented += element
    selection = editor.getLastSelection()
    selection.insertText(incremented)
    editor.setCursorScreenPosition(cursor)

  increment: ->
    @operate(1)

  decrement: ->
    @operate(-1)
