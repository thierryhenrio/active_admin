require 'rubygems'
require 'spork'

Spork.prefork do
  $LOAD_PATH.unshift(File.dirname(__FILE__))
  $LOAD_PATH << File.expand_path('../support', __FILE__)

  ENV['BUNDLE_GEMFILE'] = File.expand_path('../../Gemfile', __FILE__)

  require 'detect_rails_version'
  ENV['RAILS'] = detect_rails_version

  require "bundler"
  Bundler.setup

  require 'shoulda/active_record'
  include Shoulda::ActiveRecord::Macros

  ENV['RAILS_ENV'] = 'test'
  ENV['RAILS_ROOT'] = File.expand_path("../rails/rails-#{ENV["RAILS"]}", __FILE__)

  # Create the test app if it doesn't exists
  unless File.exists?(ENV['RAILS_ROOT'])
    system 'rake setup'
  end

  # Ensure the Active Admin load path is happy
  require 'rails'

  # Don't add asset cache timestamps. Makes it easy to integration
  # test for the presence of an asset file
  ENV["RAILS_ASSET_ID"] = ''

  require 'rspec'
end

Spork.each_run do
end