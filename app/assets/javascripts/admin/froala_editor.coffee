#= require froala_editor.min.js
#= require plugins/paragraph_style.min.js
#= require plugins/align.min.js
#= require plugins/code_view.min.js
#= require plugins/colors.min.js
#= require plugins/image.min.js
#= require plugins/image_manager.min.js
#= require plugins/table.min.js
#= require plugins/video.min.js
#= require plugins/font_family.min.js
#= require plugins/font_size.min.js
#= require plugins/file.min.js
#= require plugins/lists.min.js
#= require plugins/char_counter.min.js
#= require plugins/fullscreen.min.js
#= require plugins/link.min.js
#= require plugins/inline_style.min.js
#= require languages/fr.js

$ ->
  if $('.froala').length
    $.FroalaEditor.DEFAULTS.key = gon.froala_key
    froala_init()

froala_init = ->
  $('.froala').froalaEditor
    toolbarInline: false
    toolbarSticky: true
    codeMirror: true
    codeBeautifier: true
    theme: 'royal'
    plainPaste: true
    tabSpaces: true
    fontSizeSelection: true
    fontFamilySelection: false
    fontFamily:
      'Ubuntu': 'Ubuntu'
      'Arial,Helvetica,sans-serif': 'Arial'
    toolbarButtons: [
      'bold', 'italic', 'underline', '|',
      'paragraphStyle', 'fontFamily', 'fontSize', '|',
      'color', 'insertLink', 'insertImage', '|',
      'indent', 'outdent', 'align', 'insertOrderedList', 'insertUnorderedList', '|',
      'undo', 'redo' , '|',
      'html'
    ]
    linkList: []
    linkStyles: {}
    multiLine: true
    colorsStep: 6
    heightMin: 300
    language: 'fr'
    placeholderText: I18n.t('form.placeholder.froala', locale: gon.language)