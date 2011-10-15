require "orm_adapter/adapters/active_record"

class ActiveRecord::Base::OrmAdapter
  def resource_table_name
    klass.quoted_table_name
  end

  def search(controller, q)
    # extracted from active_admin/resource_controller/collection.rb
    # even uglier than original !!
    # controller.@search is expected later in active_admin/resource/sidebars.rb
    # XXX
    search = klass.search(q)
    controller.instance_variable_set(:@search, search)
    search.relation
  end
end
