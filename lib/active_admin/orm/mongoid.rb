require "orm_adapter/adapters/mongoid"

class Mongoid::Document::OrmAdapter
  def resource_table_name
    klass.collection.name
  end

  def search q
    klass.where q
  end
end