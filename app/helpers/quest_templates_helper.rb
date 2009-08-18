module QuestTemplatesHelper
  
  def details(quest)
    text = quest
    
    text.gsub!(/\$B/i, '<br />')
    text.gsub!(/\$N/i, '<b>Nick gracza</b>')
    text.gsub!(/\$R/i, '<b>Rasa gracza</b>')
    text.gsub!(/\$C/i, '<b>Klasa gracza</b>')
    text.gsub!(/\$G/i, '<b>Płeć gracza</b>')
    
    text
  end
  
  def plus_minus(amount)
    
    if amount > 0
      return "+#{amount}"
    else
      return "-#{amount}"
    end
    
  end
  
  def wowhead_quest_creature_or_object_link(obj)
    if obj.nil?
      return "[NONE]"
    else
      if obj.class == ObjectQuestRelation
        return link_to obj.game_object.name, "http://www.wowhead.com/?object=#{obj.id}"
      else
        return link_to obj.monster.name, "http://www.wowhead.com/?npc=#{obj.id}"
      end
    end
  end
  
end
