class QuestTemplate < ActiveRecord::Base
  set_table_name 'quest_template'
  set_primary_key 'entry'
  
  #harcore - bo ktoś spieprzył relacje w bazie....
  
  4.times do |i|
    index = i + 1
    has_one "rewardItem#{index}".to_sym, :class_name => "ItemTemplate", :foreign_key => "entry", :primary_key => "RewItemId#{index}"
    
    has_one "rewardChoiceItem#{index}".to_sym, :class_name => "ItemTemplate", :foreign_key => "entry", :primary_key => "RewChoiceItemId#{index}"
    
    #has_one "rewardReputation#{index}".to_sym, :class_name => "Faction", :foreign_key => "id", :primary_key => "RewRepFaction#{index}"
    
    has_one "requiredItem#{index}".to_sym, :class_name => "ItemTemplate", :foreign_key => "entry", :primary_key => "ReqItemId#{index}"
    
    has_one "requiredCreature#{index}".to_sym, :class_name => "Monster", :foreign_key => "entry", :primary_key => "ReqCreatureOrGOId#{index}", :conditions => "entry > 0 "
    has_one "requiredGameObject#{index}".to_sym, :class_name => "GameObject", :foreign_key => "entry", :primary_key => "ReqCreatureOrGOId#{index}", :conditions => "entry < 0 "
  end
  
  def requiredCreatures
    creatures = {}
    
    4.times do |i|
      index = i + 1
      
      rc = send("requiredCreature#{index}".to_sym)
      creatures[rc] = send("ReqCreatureOrGOCount#{index}".to_sym) unless rc.nil?
    end
    
    return creatures
  end
  
  def requiredItems
    items = {}
    
    4.times do |i|
      index = i + 1
      
      ri = send("requiredItem#{index}".to_sym)
      items[ri] = send("ReqItemCount#{index}".to_sym) unless ri.nil?
    end
    
    items
  end
  
  def rewardReputations
    rewards = {}
    
    4.times do |i|
      index = i + 1
      
      rr = send("RewRepFaction#{index}".to_sym)
      rewards[rr] = send("RewRepValue#{index}".to_sym) if !rr.nil? && rr != 0
    end
    
    rewards
  end
  
  def rewardItems
    rewards = {}
    
    4.times do |i|
      index = i + 1
      
      ri = send("rewardItem#{index}".to_sym)
      rewards[ri] = send("RewItemCount#{index}".to_sym) unless ri.nil?
      
      ci = send("rewardChoiceItem#{index}".to_sym)
      rewards[ci] = send("RewChoiceItemCount#{index}".to_sym) unless ci.nil?
    end

    
    rewards
  end
  
  def title
    self.Title
  end
  
  def minLevel
    self.MinLevel
  end
  
  def questLevel
    self.QuestLevel
  end
  
  def race_name
    Races[self.RequiredRaces]
  end
  
  def type_name
    QuestType[self.Type]
  end
  
end
