desc "Imports quest in import_quests directory"
task :import_quest => :environment do
  puts "Importing quests...."
  
  quest_path = "#{RAILS_ROOT}/import_quests"
  quest_dir = Dir.new(quest_path)
  
  quest_dir.each do |file_name|
    next unless file_name =~ /.quest$/i
    
    puts "Opening file #{file_name}"
    pure_quest = YAML.load_file("#{quest_path}/#{file_name}")
    
    puts "Importing: #{pure_quest["Title"]}"

    quest = QuestTemplate.find_or_initialize_by_entry(pure_quest['entry'])
    quest.attributes = pure_quest
    quest.save
    
    quest.changed do |key|
      puts "Updating #{key}... "
    end 
    
    File.delete("#{quest_path}/#{file_name}")
  end
end