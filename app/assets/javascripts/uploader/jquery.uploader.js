(function() {
  var $, UploaderWidget;

  $ = jQuery;

  $.fn.uploaderWidget = function(options) {
    if (options == null) {
      options = {};
    }
    return this.each(function() {
      var $this, data;
      $this = $(this);
      data = $this.data('uploaderWidget');
      if (!data) {
        $this.data('uploaderWidget', new UploaderWidget(this, options));
      }
      if (typeof options === 'string') {
        return data[options]();
      }
    });
  };

  UploaderWidget = (function() {
    function UploaderWidget(dom_id, options) {
      var defaults;
      this.dom_id = dom_id;
      if (options == null) {
        options = {};
      }
      defaults = {
        dataType: 'json',
        autoUpload: true,
        paramName: 'asset[data]',
        formData: function(form) {
          return [];
        },
        namespace: 'uploader',
        uploadTemplateId: 'template-upload-',
        downloadTemplateId: 'template-download-'
      };
      this.options = $.extend(defaults, options);
      this._setup();
    }

    UploaderWidget.prototype._setup = function() {
      this.element = $(this.dom_id);
      this.container = this.element.find('.uploader-files');
      this.template = this.element.data('tpml');
      this.input = this.element.find('input[type="file"]:eq(0)');
      this.options['dropZone'] = this.element;
      this.options['filesContainer'] = this.container;
      this.options['uploadTemplateId'] += this.template;
      this.options['downloadTemplateId'] += this.template;
      this.options.singular = !this.input.prop('multiple');
      return this._initFileupload();
    };

    UploaderWidget.prototype._initFileupload = function() {
      this.input.fileupload(this.options);
      this.uploader = this.input.data('blueimp-fileupload') || this.input.data('fileupload');
      if (this.element.data('exists')) {
        return this._load();
      }
    };

    UploaderWidget.prototype._load = function() {
      return $.ajax({
        url: this.input.data('url'),
        dataType: 'json',
        method: 'GET',
        success: (function(_this) {
          return function(data) {
            if (data['files'] != null) {
              return _this.render(data['files']);
            }
          };
        })(this)
      });
    };

    UploaderWidget.prototype.render = function(files) {
      return this.uploader._renderDownload(files).appendTo(this.container);
    };

    return UploaderWidget;
  })();
}).call(this);
