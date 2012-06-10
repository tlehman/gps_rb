require './gpgga'

class NMEAFile
  def self.open(filename)
    File.open(filename).grep(/^\$GPGGA/).map do |sentence|
      GPGGA.new(sentence.gsub(/^\$GPGGA,/, '').strip)
    end
  end
end