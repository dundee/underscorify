# Based on https://github.com/LoicLBD/underscore

{CompositeDisposable} = require 'atom'

module.exports = Underscore =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'underscorify:run': => @run()

  deactivate: ->
    @subscriptions.dispose()

  run: ->
    editor = atom.workspace.getActiveTextEditor()

    for selection in editor.getSelections()
      range = selection.getBufferRange()
      selectedText = editor.getTextInBufferRange(range)
  
      # replace camelCase with underscores
      selectedText = selectedText.replace(/([A-Z])/g, ($1) -> "_" + $1.toLowerCase())

      # replace words with underscores
      selectedWords = selectedText.toLowerCase().split(" ")
      convertedText = ""
      for word in selectedWords
        do ->
          convertedText += word + "_"

      convertedText = convertedText.substring(0, convertedText.length - 1)
      editor.setTextInBufferRange(range, convertedText)
