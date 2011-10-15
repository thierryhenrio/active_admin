require 'spec_helper'
require 'active_admin/orm/mongoid'

module MongoidApp
  class Nerd
    include Mongoid::Document
    store_in :geeks
    field :name
  end
end

describe ActiveAdmin::Resource do
  context "mongoid" do
    let(:resource) { ActiveAdmin::Resource.new(nil, MongoidApp::Nerd)}
    it "resource_table_name is name of document store" do
      resource.resource_table_name.should == "geeks"
    end
  end
end
