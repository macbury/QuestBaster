class ItemTemplate < ActiveRecord::Base
  set_table_name 'item_template'
  set_primary_key 'entry'
  #belongs_to :reward1, :class_name => "QuestTemplate", :foreign_key => "entry"
  
  class << self
    def instance_method_already_implemented?(method_name)
      return true if method_name == 'class'
      super
    end
  end
end
