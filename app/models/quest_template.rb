class QuestTemplate < ActiveRecord::Base
  set_table_name 'quest_template'
  set_primary_key 'entry'
  
  validates_uniqueness_of :entry
  
  after_save :create_quest_relations
  
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
      item = ItemTemplate.first(:conditions => ['(name LIKE ? AND name NOT LIKE ?) OR entry = ?', val, '', val.to_i])
      write_attribute "ReqItemId#{index}", item.nil? ? 0 : item.id
    end
    
    method_name = ("reqCreature" + index.to_s).to_sym
    send :define_method, method_name do
      monster = send("requiredCreature#{index}".to_sym)
      return monster.name unless monster.nil?
    end
    
    send :define_method, "#{method_name.to_s}=" do |val|
      monster = Monster.first(:conditions => ['(name LIKE ? AND name NOT LIKE ?) OR entry = ?', val, '', val.to_i])
      write_attribute "ReqCreatureOrGOId#{index}", monster.id unless monster.nil?
    end
    
    method_name = ("reqObjectName" + index.to_s).to_sym
    send :define_method, method_name do
      val = read_attribute "ReqCreatureOrGOId#{index}".to_sym
      
      if val < 0
        obj = GameObject.find(val.abs)
        return obj.nil? ? "[NONE]" : obj.name
      else
        return "[NONE]"
      end
    end
    
    method_name = ("reqObjectID" + index.to_s).to_sym
    send :define_method, method_name do
      val = read_attribute "ReqCreatureOrGOId#{index}".to_sym
      
      if val < 0
        obj = GameObject.find(val.abs)
        return obj.nil? ? "" : obj.entry
      else
        return 0
      end
    end
    
    send :define_method, "#{method_name}=" do |val|
      obj = GameObject.first(:conditions => { :entry => val })
      write_attribute "ReqCreatureOrGOId#{index}", obj.entry.abs * -1 unless obj.nil?
    end
    
    method_name = ("rewardFactionName" + index.to_s).to_sym
    send :define_method, method_name do
      faction = read_attribute "RewRepFaction#{index}".to_sym
      return Factions[faction];
    end
    
    send :define_method, "#{method_name}=" do |faction_value|
      if faction_value.nil?
        write_attribute "RewRepFaction#{index}".to_sym, 0  
      else
        Factions.each do |faction_id, faction_name|
          if faction_name == faction_value || faction_id == faction_value.to_i
            write_attribute "RewRepFaction#{index}".to_sym, faction_id
            break
          end
        end
      end
    end
    
    method_name = ("rewardItemName" + index.to_s).to_sym
    send :define_method, method_name do
      item_id = read_attribute "RewItemId#{index}".to_sym
      item = ItemTemplate.first(:conditions => { :entry => item_id })
      return item.nil? ? '' : item.name
    end
    
    send :define_method, "#{method_name.to_s}=".to_sym do |val|
      item = ItemTemplate.first(:conditions => ['(name LIKE ? AND name NOT LIKE ?) OR entry = ?', val, '', val.to_i])
      
      write_attribute "RewItemId#{index}".to_sym, item.nil? ? 0 : item.entry
    end
    
    
    method_name = ("rewardChoiceItemName" + index.to_s).to_sym
    send :define_method, method_name do
      item_id = read_attribute "RewChoiceItemId#{index}".to_sym
      item = ItemTemplate.first(:conditions => { :entry => item_id })
      return item.nil? ? '' : item.name
    end
    
    send :define_method, "#{method_name.to_s}=".to_sym do |val|
      item = ItemTemplate.first(:conditions => ['(name LIKE ? AND name NOT LIKE ?) OR entry = ?', val, '', val.to_i])
      
      write_attribute "RewChoiceItemId#{index}".to_sym, item.nil? ? 0 : item.entry
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
      creatures[rc] = send("ReqCreatureOrGOCount#{index}".to_sym) unless rc.nil? || rc.entry == 0
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
    if zone_value.nil?
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
  
  def gold=(amount)
    self.RewOrReqMoney += amount.to_i * 10_000
  end
  
  def silver
    amount = self.RewOrReqMoney - gold * 10_000
    amount.div(100)
  end
  
  def silver=(amount)
    self.RewOrReqMoney += amount.to_i * 100
  end
  
  def copper
    return self.RewOrReqMoney - (gold * 10_000 + silver * 100)
  end
  
  def copper=(amount)
    self.RewOrReqMoney += amount.to_i
  end
  
  def quest_giver
    game_object = ObjectQuestRelation.first(:conditions => { :quest => self.entry })
    creature = CreatureQuestRelation.first(:conditions => { :quest => self.entry })
    
    return game_object || creature
  end
  
  attr_accessor :quest_giver_id, :quest_giver_type, :quest_involver_type, :quest_involver_id
  
  def quest_giver_id
    quest_giver.nil? ? 0 : quest_giver.id
  end
  
  def quest_giver_type
    return 0 if quest_giver.nil?
    
    return quest_giver.class == CreatureQuestRelation ? 0 : 1
  end
  
  def quest_involver
    game_object = ObjectQuestInvolved.first(:conditions => { :quest => self.entry })
    creature = CreatureQuestInvolved.first(:conditions => { :quest => self.entry })
    
    return game_object || creature
  end
  
  def quest_involver_id
    quest_involver.nil? ? 0 : quest_involver.id
  end
  
  def quest_involver_type
    return 0 if quest_involver.nil?
    
    return quest_involver.class == CreatureQuestInvolved ? 0 : 1
  end
  
  protected
  
  def create_quest_relations
    begin
      quest_giver.destroy
      quest_involver.destroy
    rescue Exception => e
      
    end
    
    giver = @quest_giver_type || quest_giver_type
    if giver.to_i == 0
      o = CreatureQuestRelation.new
    else
      o = ObjectQuestRelation.new
    end
    
    o.quest = self.id
    o.id = @quest_giver_id || quest_giver_id
    o.save
    
    taker = @quest_involver_type || quest_involver_type
    
    if taker.to_i == 0
      o = CreatureQuestInvolved.new
    else
      o = ObjectQuestInvolved.new
    end
    
    o.quest = self.id
    o.id = @quest_involver_id || quest_involver_id
    o.save
  end
end
