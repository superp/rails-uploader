# frozen_string_literal: true

require 'rails/generators/migration'

module Uploader
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('templates', __dir__)

      desc 'add the migrations'
      def self.next_migration_number(_path)
        if @prev_migration_nr
          @prev_migration_nr += 1
        else
          @prev_migration_nr = Time.now.utc.strftime('%Y%m%d%H%M%S').to_i
        end

        @prev_migration_nr.to_s
      end

      def copy_migrations
        migration_template '20130905144515_create_assets.rb', 'db/migrate/create_assets.rb'
      end
    end
  end
end
