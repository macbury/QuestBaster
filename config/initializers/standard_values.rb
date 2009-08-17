Races = {
  0 => 'All Races',
  1791 => 'All Races',
  690 => 'Horde Quest',
  1101 => 'Alliance Quest',
  
  1 => 'Human',
  2	=> 'Orc',
  4	=> 'Dwarf',
  8	=> 'Night Elf',
  16 => 'Undead',
  32 => 'Tauren',
  64 => 'Gnome',
  128	=> 'Troll',
  512	=> 'Blood Elf(Pedały)',
  1024 => 'Draenei'
}

QuestType = {
  0 => 'Normal',
  1	=> 'Group',
  21 => 'Life',
  41 => 'PvP',
  62 => 'Raid',
  81 => 'Dungeon',
  82 => 'World Event',
  83 => 'Legendary',
  84 => 'Escort',
  85 => 'Heroic',
  88 => 'Raid (10)',
  89 => 'Raid (25)'
}

Factions = {}

regexp = Regexp.new(/^([0-9]{1,4})/i)

File.new(RAILS_ROOT+'/config/factions.txt', "r").each do |line|
  faction = line.strip
  
  if faction =~ regexp
    faction_id = $1
    faction.gsub!($1, '')
    faction = faction.strip
    
    Factions[faction_id.to_i] = faction
  end
end

Factions_Reputation = {
  1 => 'Neutral',
  3000 => 'Friendly',
  9000 => 'Honored',
  21000 => 'Revered',
  42000 => 'Exalted'
}

Zones = {}

File.new(RAILS_ROOT+'/config/factions.txt', "r").each do |line|
  area = line.strip
  
  if area =~ regexp
    area_id = $1
    area.gsub!($1, '')
    area = area.strip
    
    Zones[area_id.to_i] = area
  end
end

Quest_Sort = {}

File.new(RAILS_ROOT+'/config/quest_sort.txt', "r").each do |line|
  name = line.strip
  
  if name =~ regexp
    name_id = $1
    name.gsub!($1, '')
    name = name.strip
    
    Quest_Sort[name_id.to_i] = name
  end
end

Quest_Flags = {
  0	=> 'QUEST_FLAGS_NONE',
  1	=> 'QUEST_FLAGS_STAY_ALIVE',
  2	=> 'QUEST_FLAGS_EVENT',
  4	=> 'QUEST_FLAGS_EXPLORATION',
  8	=> 'QUEST_FLAGS_SHARABLE',
  9 => 'QUEST_FLAGS_NONE2',
  16 => 'Unknown',
  32 => 'QUEST_FLAGS_EPIC',
  64 => 'QUEST_FLAGS_RAID	',
  128	=> 'QUEST_FLAGS_TBC',
  256	=> 'QUEST_FLAGS_UNK2',
  512	=> 'QUEST_FLAGS_HIDDEN_REWARDS',
  1024 => 'QUEST_FLAGS_AUTO_REWARDED',
  2048 => 'QUEST_FLAGS_TBC_RACES',
  4096 => 'QUEST_FLAGS_DAILY',
  8192 => 'QUEST_FLAGS_UNK5'
}

Quest_Special_Flags = {
  0 => 'No extra requirements',
  1 => 'Makes the quest repeatable.',
  2 => 'Makes the quest only completable by some external event',
  3 => 'Both repeatable and completable only through an external event'
}