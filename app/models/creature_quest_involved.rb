class CreatureQuestInvolved < ActiveRecord::Base
  set_table_name 'creature_involvedrelation'
  has_one :monster, :class_name => "Monster", :foreign_key => "entry", :primary_key => "id"
end