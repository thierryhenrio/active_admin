require 'spec_helper'
require 'generator_spec/test_case'
require 'generators/active_admin/comments/comments_generator'

describe ActiveAdmin::Generators::CommentsGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../../tmp", __FILE__)

  before :all do
    prepare_destination
    run_generator
  end

  def comments_migrations
    Dir["#{destination_root}/db/migrate/*.rb"]
  end

  it "should generate 2 migration files" do
    comments_migrations.count.should == 2
  end
end