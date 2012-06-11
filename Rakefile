require 'colorize'
require 'yaml'

namespace :gps do
  config = YAML::load(File.open("config.yml"))
  
  desc "Check if GPS logger is connected"
  task :conn? do
    # TODO: Add Support for GNU/Linux and Windows
    if File.exists?("/Volumes/GPS Tracker")
      puts "GPS Logger Connected".green
    else
      puts "GPS Logger Not Connected".red
      break
    end
  end
  
  desc "Check uniqueness of files on GPS logger"
  task :uniq? => :conn? do
    puts "Checking uniqueness of files on GPS logger"
    files_store = Dir.glob("#{config["file_store"]}/*.log").map {|file| file.split("/").last }
    Dir.glob("/Volumes/GPS Tracker/GPSFILES/*.log").each do |file_dev|
      if !files_store.member? file_dev.split("/").last
        puts "\t#{file_dev} (unique)".green
      else
        puts "\t#{file_dev} (already in data store)".red
      end
    end
  end
  
  desc "Copy files from GPS logger to data store"
  task :store => :conn? do
    files_store = Dir.glob("#{config["file_store"]}/*.log").map { |file| file.split("/").last }
    Dir.glob("/Volumes/GPS Tracker/GPSFILES/*.log").each do |file_dev|
      if !files_store.member? file_dev.split("/").last
        puts "Copying #{file_dev} to #{config['file_store']}"
        FileUtils.cp(file_dev, config["file_store"])
      end
    end
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