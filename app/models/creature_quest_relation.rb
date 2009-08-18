class CreatureQuestRelation < ActiveRecord::Base
  set_table_name 'creature_questrelation'
  has_one :monster, :class_name => "Monster", :foreign_key => "entry", :primary_key => "id"
  
  after_save :set_flag_quest
  
  def set_flag_quest
    self.monster.npcflag = self.monster.npcflag | 2
    self.monster.npcflag = self.monster.npcflag | 1 unless self.monster.ScriptName.nil? || self.monster.ScriptName.blank?
    self.monster.save
  end
end