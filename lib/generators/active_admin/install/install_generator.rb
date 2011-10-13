module ActiveAdmin
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Installs Active Admin"

      hook_for :users, :default => "devise", :desc => "Admin user generator to run. Skip with --skip-users"

      class_option :comments, default: true, type: :boolean,
        desc: "Generate migrations for admin comments (active record), skip with --(no|skip)-comments"
      class_option :assets, default: true, type: :boolean,
        desc: "Generate assets, skip with --(no|skip)-assets"

      def self.source_root
        @_active_admin_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def copy_initializer
        template 'active_admin.rb.erb', 'config/initializers/active_admin.rb'
      end

      def setup_directory
        empty_directory "app/admin"
        template 'dashboards.rb', 'app/admin/dashboards.rb'
      end

      def setup_routes
        route "ActiveAdmin.routes(self)"
      end

      def create_assets
        generate "active_admin:assets" if options.assets?
      end

      def comments
        generate "active_admin:comments" if options.comments?
      end
    end
  end
end
