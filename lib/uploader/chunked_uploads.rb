module Uploader
  module ChunkedUploads
    extend ActiveSupport::Concern

    protected

    def with_chunked_upload(file_or_part)
      uploader = UploadRequest.new(request.env, file_or_part)
      return unless uploader.completed?

      yield uploader.file
      uploader.cleanup
    end
  end
end
