module Uploader
  class FilePart < File
    def initialize(path, filename)
      @filename = filename
      super(path, 'a')
    end

    def original_filename
      @filename
    end

    def concat(other_file)
      binmode
      write(other_file.read)
      other_file.close
    end
  end
end
