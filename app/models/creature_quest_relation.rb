class CreatureQuestRelation < ActiveRecord::Base
  set_table_name 'creature_questrelation'
  has_one :monster, :class_name => "Monster", :foreign_key => "entry", :primary_key => "id"
end