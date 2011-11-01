module ActiveAdmin
  module Generators
    class CommentsGenerator < ::Rails::Generators::Base
      desc "Generates migrations for admin comments (active record)"
      include Rails::Generators::Migration

      def self.source_root
        @_active_admin_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def self.next_migration_number(_dirname)
        Time.now.strftime("%Y%m%d%H%M%S")
      end

      def create_migrations
        Dir["#{self.class.source_root}/migrations/*.rb"].sort.each do |filepath|
          name = File.basename(filepath)
          migration_template "migrations/#{name}", "db/migrate/#{name.gsub(/^\d+_/,'')}"
          sleep 1 # so that next migration has a different number, as it depends on time ...
        end
      end
    end
  end
end

