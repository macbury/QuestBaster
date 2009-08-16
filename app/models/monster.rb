class Monster < ActiveRecord::Base
  set_table_name 'creature_template'
  set_primary_key 'entry'
  
  def self.inheritance_column
    nil
  end
end
