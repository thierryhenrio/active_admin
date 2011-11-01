require 'spec_helper'
require 'active_admin/orm/mongoid'

module MongoidApp
  class Nerd
    include Mongoid::Document
    store_in :geeks
    field :name
    field :nerd_house_id, :type => Integer
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

describe Mongoid::Document::OrmAdapter do
  let(:controller) do
    rc = ActiveAdmin::ResourceController.new
    rc.stub!(:params) do
      params
    end
    rc
  end
  describe "#search" do

    context 'for basic searches' do
      it 'formats basic searches correctly for Mongoid' do
        params = {'user_name' => 'jack'}
        chain = MongoidApp::Nerd.to_adapter.search controller, params, MongoidApp::Nerd
        chain.should == MongoidApp::Nerd.where('user_name' => 'jack')
      end
    end

    context 'for _contains searches' do
      it 'formats search to use regex' do
        params = {'user_name_contains' => 'jack'}
        chain = MongoidApp::Nerd.to_adapter.search controller, params, MongoidApp::Nerd
        chain.should == MongoidApp::Nerd.where('user_name' => /jack/i)
      end
    end

    context 'for _lt|_gt|_eq searches' do
      it 'formats _gt searches correctly' do
        params = {'user_name_gt' => '12'}
        chain = MongoidApp::Nerd.to_adapter.search controller, params, MongoidApp::Nerd
        chain.should == MongoidApp::Nerd.where('user_name' => {'$gt' => '12'})
      end
      it 'formats _lt searches correctly' do
        params = {'user_name_lt' => '12'}
        chain = MongoidApp::Nerd.to_adapter.search controller, params, MongoidApp::Nerd
        chain.should == MongoidApp::Nerd.where('user_name' => {'$lt' => '12'})
      end
      it 'formats _eq searches correctly' do
        params = {'user_name_eq' => '12'}
        chain = MongoidApp::Nerd.to_adapter.search controller, params, MongoidApp::Nerd
        chain.should == MongoidApp::Nerd.where('user_name' => '12')
      end
    end

    context 'for associated model searhes' do
      it "formats _eq searches correctly" do
        params = {'nerd_house_eq' => '1'}
        chain = MongoidApp::Nerd.to_adapter.search controller, params, MongoidApp::Nerd
        chain.should == MongoidApp::Nerd.where('nerd_house_id' => '1')
      end
    end
  end
end
