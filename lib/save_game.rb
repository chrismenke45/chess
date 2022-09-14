require "json"

module SaveGame
  def self.save_it(game_object)
    Dir.mkdir("output") unless Dir.exist?("output")
    current_files = Dir.entries("./output")
    current_files.delete(".")
    current_files.delete("..")
    unless current_files.empty?
      show_files(current_files)
      puts "Only save your game under one of these names if you wish to replace it"
    end
    puts "What name would you like to save your game under? (Only lowercase letters are allowed in save names, and names must be 8 characters or shorter)"
    new_file = nil
    loop do
      new_file = gets.chomp
      break if new_file.match?(/\A[a-z]{1,8}\z/)
      puts "Please enter a valid save name. It must be less than 8 characters and must only consist of lowercase letters"
    end
    filename = "output/#{new_file}.json"
    File.open(filename, "w") { |file| file.write(game_object.to_json) }
  end

  def self.check_for_save
    File.exist?("output/game.json")
  end

  def self.load_it
    current_files = Dir.entries("./output")
    current_files.delete(".")
    current_files.delete("..")
    unless current_files.empty?
      show_files(current_files)
      file_to_load = nil
      loop do
        puts "Which save would you like to load?"
        file_to_load = gets.chomp
        break if current_files.include?(file_to_load + ".json")
        puts "That is not a proper filename"
      end
      game_string = JSON.load_file("output/#{file_to_load}.json")
      puts "The #{file_to_load} save will be loaded and deleted, please save again if you'd like to keep the file"
      File.delete("output/game.json") if File.exist?("output/game.json")
      game_string
    else
      puts "There are currently no saved games, please start a new game"
      false
    end
  end

  def self.show_files(files)
    puts "Current save files include:"
    files.each { |filename| puts filename.slice(0..-6) }
  end
end
