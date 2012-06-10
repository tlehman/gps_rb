require 'colorize'

namespace :gps do
  desc "Check if GPS logger is connected"
  task :connected? do
    # TODO: Add Support for GNU/Linux and Windows
    if File.exists?("/Volumes/GPS Tracker")
      puts "Connected".green
    else
      puts "Not Connected".red
      break
    end
  end
  
  desc "Copy files from GPS logger to data store"
  task :copy_files => :connected? do
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