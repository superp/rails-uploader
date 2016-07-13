require 'rack/request'
require 'fileutils'
require 'digest/sha1'
require 'uri'

module Uploader
  class UploadRequest < Rack::Request
    SPLITTER = '/'.freeze

    attr_reader :file

    def initialize(env, file_or_part)
      super(env)

      @file = file_or_part
      append_chunked_content
    end

    def completed?
      !chunked? || chunked_completed?
    end

    def chunked?
      content_length.to_i > 0 && @env['HTTP_CONTENT_RANGE']
    end

    def chunked_completed?
      file.size == total_file_length
    end

    def total_file_length
      return content_length.to_i unless chunked?
      @env['HTTP_CONTENT_RANGE'].split(SPLITTER).last.to_i
    end

    def filename
      @filename ||= extract_filename(@env['HTTP_CONTENT_DISPOSITION'])
    end

    def cleanup
      file.close
      FileUtils.rm(file.path, force: true)
    end

    protected

    def append_chunked_content
      return unless chunked?

      tempfile.concat(@file)
      @file = tempfile
    end

    def tempfile
      @tempfile ||= FilePart.new(tempfile_path, filename)
    end

    def tempfile_path
      File.join(Dir.tmpdir, tempfile_key + tempfile_extname)
    end

    def tempfile_key
      Digest::SHA1.hexdigest([filename, ip, user_agent, csrf_token].join(SPLITTER))
    end

    def tempfile_extname
      @tempfile_extname ||= File.extname(filename)
    end

    def csrf_token
      @env['HTTP_X_CSRF_TOKEN']
    end

    def extract_filename(value)
      value = value.match(/filename\s?=\s?\"?([^;"]+)\"?/i)[1]
      URI.decode(value.force_encoding('binary'))
    end
  end
end
