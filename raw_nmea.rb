# GPRMC
# 
# eg1. $GPRMC,081836,A,3751.65,S,14507.36,E,000.0,360.0,130998,011.3,E*62
# eg2. $GPRMC,225446,A,4916.45,N,12311.12,W,000.5,054.7,191194,020.3,E*68
#
#           225446       Time of fix 22:54:46 UTC
#           A            Navigation receiver warning A = Valid position, V = Warning
#           4916.45,N    Latitude 49 deg. 16.45 min. North
#           12311.12,W   Longitude 123 deg. 11.12 min. West
#           000.5        Speed over ground, Knots
#           054.7        Course Made Good, degrees true
#           191194       UTC Date of fix, 19 November 1994
#           020.3,E      Magnetic variation, 20.3 deg. East
#           *68          mandatory checksum
#######################################################################################
class RawNMEAData
  def initialize data_dir
    # these sentence types have time, latitude and longitude
    @types = ['GPRMC', 'GPGGA']

    @data_dir = File.expand_path data_dir

    @filenames = []

    Dir.open(@data_dir).each do |filename| 
      @filenames << "#{@data_dir}/#{filename}" if filename =~ /GPS[\d_]+\.log/
    end
  end

  def import_from_files
    if @sentences.nil?
      @sentences = []
      @sentence_types = []
       
      @filenames.each do |filename|
        File.open(filename).each do |sentence|
          t = sentence.split(",").first 

          if t =~ /^\$G/
            @sentences << sentence
            @sentence_types << t unless @sentence_types.member? t
          end
        end
      end
      return "#{@filenames.length} files, totalling #{@sentences.length} sentences have just been imported from #{@data_dir}"
    else
      return "#{@filenames.length} files have already been imported from #{@data_dir}"
    end
  end

  def sentence_types
    return @sentence_types
  end

  private
    def get_utc time_str
      hrs = time_str[0,2]
      mns = time_str[2,4]
      sec = time_str[4,6]
    end
end

r = RawNMEAData.new "~/Dropbox/Data/GPS/"
puts r.import_from_files
puts r.sentence_types.inspect
