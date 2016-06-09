$ = jQuery

$.fn.uploaderWidget = (options = {}) ->
  @each ->
    $this = $(this)
    data = $this.data('uploaderWidget')
    if (!data)
      $this.data('uploaderWidget', new UploaderWidget(this, options))
    if (typeof options is 'string')
      data[options]()

class UploaderWidget
  constructor: (@dom_id, options = {}) ->
    defaults =
      dataType: 'json'
      autoUpload: true
      paramName: 'asset[data]'
      formData: (form) -> return []
      namespace: 'uploader'
      uploadTemplateId: 'template-upload-'
      downloadTemplateId: 'template-download-'

    @options = $.extend defaults, options

    this._setup()

  _setup: ->
    @element = $(@dom_id)
    @container = @element.find('.uploader-files')
    @template = @element.data('tpml')
    @input = @element.find('input[type="file"]:eq(0)')

    @options['dropZone'] = @element
    @options['filesContainer'] = @container
    @options['uploadTemplateId'] += @template
    @options['downloadTemplateId'] += @template

    this._initFileupload()

  _initFileupload: ->
    @input.fileupload(@options)

    @uploader = (@input.data('blueimp-fileupload') || @input.data('fileupload'))

    this._load() if @element.data('exists')

  _load: ->
    $.ajax(
      url: @input.data('url')
      dataType: 'json'
      method: 'GET'
      success: (data) =>
        if data['files']?
          this.render(data['files'])
    )

  render: (files) ->
    @uploader._renderDownload(files).appendTo(@container)
