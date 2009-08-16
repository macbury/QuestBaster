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

Zones = {}

regexp = Regexp.new(/^([0-9]{1,4})/i)

File.new(RAILS_ROOT+'/config/factions.txt', "r").each do |line|
  area = line.strip
  
  if area =~ regexp
    area_id = $1
    area.gsub!($1, '')
    area = area.strip
    
    Zones[area_id.to_i] = area
  end
end