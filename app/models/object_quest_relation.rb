class ObjectQuestRelation < ActiveRecord::Base
  set_table_name 'gameobject_questrelation'
  has_one :game_object, :class_name => "GameObject", :foreign_key => "entry", :primary_key => "id"
end