require "orm_adapter/adapters/mongoid"

class Mongoid::Document::OrmAdapter
  def resource_table_name
    klass.collection.name
  end

  def search controller, q, chain
    formatted_search_criteria = q.dup

    # Format _contains to Mongoid syntax (ActiveAdmin filter :as => :string )
    q.keys.select {|v| v =~ /(\w+)\_contains$/} .each do |old_field_name|
      # Format search term key and value, delete old key
      mongoid_search_key = $1
      mongoid_search_value = /#{q[old_field_name]}/i
      formatted_search_criteria[mongoid_search_key] = mongoid_search_value
      formatted_search_criteria.delete(old_field_name)
    end

    # Format lt|gt|eq to Mongoid syntax (ActiveAdmin filter as: => numeric, :as => :select )
    q.keys.select {|v| v =~ /(\w+)\_(lt|gt|eq)$/} .each do |old_field_name|
      mongoid_search_operator = $2
      mongoid_search_key = $1

      # Add _id to key if search is for an associated model but id isn't passed in the form
      mongoid_search_key += '_id' if chain.to_adapter.column_names.select {|v| v =~ /\w+\_id$/} .include?(mongoid_search_key + '_id')
      mongoid_search_value = q[old_field_name]
      formatted_search_criteria.delete(old_field_name)

      # If _eq, set normal seach syntax, else use operator
      if mongoid_search_operator == 'eq'
        formatted_search_criteria[mongoid_search_key] = mongoid_search_value
      else
        formatted_search_criteria[mongoid_search_key] = {"$#{mongoid_search_operator}" => q[old_field_name]}
      end
    end

    # Return chain with formatted search
    chain.where formatted_search_criteria
  end
end