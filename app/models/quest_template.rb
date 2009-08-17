class QuestTemplate < ActiveRecord::Base
  set_table_name 'quest_template'
  set_primary_key 'entry'
  
  validates_uniqueness_of :entry
  
  #harcore - bo ktoś spieprzył relacje w bazie....
  4.times do |i|
    index = i + 1
    has_one "rewardItem#{index}".to_sym, :class_name => "ItemTemplate", :foreign_key => "entry", :primary_key => "RewItemId#{index}"
    
    has_one "rewardChoiceItem#{index}".to_sym, :class_name => "ItemTemplate", :foreign_key => "entry", :primary_key => "RewChoiceItemId#{index}"
    
    #has_one "rewardReputation#{index}".to_sym, :class_name => "Faction", :foreign_key => "id", :primary_key => "RewRepFaction#{index}"
    
    has_one "requiredItem#{index}".to_sym, :class_name => "ItemTemplate", :foreign_key => "entry", :primary_key => "ReqItemId#{index}"
    
    has_one "requiredCreature#{index}".to_sym, :class_name => "Monster", :foreign_key => "entry", :primary_key => "ReqCreatureOrGOId#{index}", :conditions => "entry > 0 "
    has_one "requiredGameObject#{index}".to_sym, :class_name => "GameObject", :foreign_key => "entry", :primary_key => "ReqCreatureOrGOId#{index}", :conditions => "entry < 0 "
    
    method_name = ("reqItemName" + index.to_s).to_sym
    send :define_method, method_name do
       item = send("requiredItem#{index}".to_sym)
       return item.name unless item.nil?
    end
    
    send :define_method, "#{method_name.to_s}=" do |val|
       item = ItemTemplate.find_by_name_or_entry(val, val)
       write_attribute "ReqItemId#{index}", item.nil? ? 0 : item.id
    end
    
    method_name = ("reqCreature" + index.to_s).to_sym
    send :define_method, method_name do
       monster = send("requiredCreature#{index}".to_sym)
       return monster.name unless monster.nil?
    end
    
    send :define_method, "#{method_name.to_s}=" do |val|
       monster = Monster.find_by_name_or_entry(val, val)
       write_attribute "ReqCreatureOrGOId#{index}", monster.nil? ? 0 : item.id
    end
  end
  
  [:Details, :Objectives, :OfferRewardText, :RequestItemsText, :EndText].each do |name|
    method_name = (name.to_s + '_f').to_sym
    send :define_method, method_name do
     text = read_attribute(name) || ""
     text.gsub!(/\$B/i, "\n")
     return text
    end
    
    send :define_method, "#{method_name.to_s}=".to_sym do |value|
      write_attribute name, value.gsub("\n", "$B")
    end
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
  
  def required_min_faction_name
    Factions[self.RequiredMinRepFaction]
  end
  
  def required_min_faction_name=(faction_value)
    if faction_value.nil?
      write_attribute :RequiredMinRepFaction, 0  
    else
      Factions.each do |faction_id, faction_name|
        if faction_name == faction_value || faction_id == faction_value.to_i
          write_attribute :RequiredMinRepFaction, faction_id
          break
        end
      end
    end
  end
  
  def required_max_faction_name
    Factions[self.RequiredMaxRepFaction]
  end
  
  def required_max_faction_name=(faction_value)
    if faction_value.nil?
      write_attribute :RequiredMaxRepFaction, 0  
    else
      Factions.each do |faction_id, faction_name|
        if faction_name == faction_value || faction_id == faction_value.to_i
          write_attribute :RequiredMaxRepFaction, faction_id
          break
        end
      end
    end
  end
  
  def zone_or_sort_name
    if self.ZoneOrSort > 0
      Zones[self.ZoneOrSort]
    else
      Quest_Sort[self.ZoneOrSort.abs]
    end
  end
  
  def zone_or_sort_name=(zone_value)
    if faction_value.nil?
      write_attribute :ZoneOrSort, 0  
    else
      Zones.each do |area_id, area_name|
        if area_name == zone_value || area_id == zone_value.to_i
          write_attribute :ZoneOrSort, area_id
          break
        end
      end
      
      Quest_Sort.each do |sort_id, sort_name|
        if sort_name == zone_value || sort_id == zone_value.to_i
          write_attribute :ZoneOrSort, sort_id.abs * -1
          break
        end
      end
    end
  end
  
  def gold
    self.RewOrReqMoney.div(10_000)
  end
  
  def silver
    amount = self.RewOrReqMoney - gold * 10_000
    amount.div(100)
  end
  
  def copper
    return self.RewOrReqMoney - (gold * 10_000 + silver * 100)
  end
end
