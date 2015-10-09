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
    cursorWord = ""
    atom.workspace.observeTextEditors(() ->
        editor.selectWordsContainingCursors()
        cursorWord = editor.getSelectedText()
    )

    test = "100%"
    s = cursorWord.split(/(\d+)(\w+)/)
    console.log(s)
    console.log(cursorWord)
    incremented = ""
    isNumber = false;
    for element in s
      do (element) ->
        if element != '' && !isNaN(element)
          fvalue = parseFloat(element)
          fvalue += num
          incremented += fvalue.toString();
          isNumber = true
        else
          incremented += element
    if isNumber
      selection = editor.getLastSelection()
      selection.insertText(incremented)
      editor.setCursorScreenPosition(position)

  increment: ->
    @operate(1)

  decrement: ->
    @operate(-1)
