require 'spec_helper'
require 'generator_spec/test_case'
require 'generators/active_admin/install/install_generator'

describe ActiveAdmin::Generators::InstallGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../../../../tmp", __FILE__)

  def setup
    prepare_destination
    # OH the pain to build this context !
    # generator test has a black box approach
    # have to build a box that _has_ items generator wants
    copy_routes
    copy_script
    fake_models
    fake_assets
  end

  def copy_routes
    # route action requires a config/routes.rb with correct syntax
    mkdir_p "#{destination_root}/config/initializers"
    cp "#{Rails.root}/config/routes.rb", "#{destination_root}/config"
  end

  def copy_script
    # generate action requires : ./script/rails
    mkdir_p "#{destination_root}/script"
    cp "#{Rails.root}/script/rails", "#{destination_root}/script"
    %w(application boot).each { |f| cp "#{Rails.root}/config/#{f}.rb", "#{destination_root}/config" }
  end

  def fake_models
    mkdir_p "#{destination_root}/app/models"
    touch "#{destination_root}/app/models/admin_user.rb"
  end

  def fake_assets
    %w(javascripts stylesheets).each { |d|  mkdir_p "#{destination_root}/app/assets/#{d}" }
  end

  context "--no-comments, --no-assets" do
    before :all do
      setup
      run_generator %w(--no-comments --no-assets)
    end
    it "does not generate migration" do
      assert_no_migration "db/config/migrate"
    end
    it "generates initializer without comments" do
      assert_file "#{destination_root}/config/initializers/active_admin.rb" do |f|
        assert_match /config.allow_comments_in = \[\]/, f
      end
    end
    it "does not generate assets" do
      assert_no_file "app/assets/javascripts/active_admin.js"
      assert_no_file "app/assets/stylesheets/active_admin.css.scss"
    end
  end

  context "default" do
    before :all do
      setup
      run_generator
    end
    it "generates migration for comments" do
      assert_migration "db/migrate/create_admin_notes.rb"
      assert_migration "db/migrate/move_admin_notes_to_comments.rb"
    end
    it "generates assets" do
      assert_file "app/assets/javascripts/active_admin.js"
      assert_file "app/assets/stylesheets/active_admin.css.scss"
    end
  end
end