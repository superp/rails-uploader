require 'rack/request'
require 'stringio'

module Sunrise
  module FileUpload
    class Request < ::Rack::Request
    
      def raw_post
        unless @env.include? 'RAW_POST_DATA'
          @env['RAW_POST_DATA'] = body.read(@env['CONTENT_LENGTH'].to_i)
          body.rewind if body.respond_to?(:rewind)
        end
        @env['RAW_POST_DATA']
      end
      
      def body
        if raw_post = @env['RAW_POST_DATA']
          raw_post.force_encoding(Encoding::BINARY) if raw_post.respond_to?(:force_encoding)
          StringIO.new(raw_post)
        else
          @env['rack.input']
        end
      end
    end
  end
end
