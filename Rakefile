require 'colorize'
require 'yaml'

namespace :gps do
  config = YAML::load(File.open("config.yml"))
  
  desc "Check if GPS logger is connected"
  task :conn? do
    # TODO: Add Support for GNU/Linux and Windows
    if File.exists?("/Volumes/GPS Tracker")
      puts "Connected".green
    else
      puts "Not Connected".red
      break
    end
  end
  
  desc "Check uniqueness of files on GPS logger"
  task :uniq? => :conn? do
    files_store  = Dir.glob("#{config["file_store"]}/*.log")
    Dir.glob("/Volumes/GPS Tracker/*.log").each do |file|
      puts file
    end
  end
  
  desc "Copy files from GPS logger to data store"
  task :copy_files => :conn? do
    puts "copying..."
  end
end

namespace :notes do
  desc "Enumerate all annotations"
  task :todo do
    # TODO: make a rake notes:todo feature like in rails
  end
  
  task :fixme do
    # TODO: see notes:todo
  end
end