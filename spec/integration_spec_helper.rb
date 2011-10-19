require ENV['RAILS_ROOT'] + '/config/environment'
require 'rspec/rails'

ActiveAdmin.application.load_paths = [ENV['RAILS_ROOT'] + "/app/admin"]

# Setup Some Admin stuff for us to play with
require 'integration_helper'
include ActiveAdminIntegrationSpecHelper
load_defaults!
reload_routes!

# Disabling authentication in specs so that we don't have to worry about
# it allover the place
ActiveAdmin.application.authentication_method = false
ActiveAdmin.application.current_user_method = false

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures = false
end

# All RSpec configuration needs to happen before any examples
# or else it whines.
require 'integration_example_group'
RSpec.configure do |c|
  c.include RSpec::Rails::IntegrationExampleGroup, :example_group => { :file_path => /\bspec\/integration\// }
end
require 'have_tag_matcher'