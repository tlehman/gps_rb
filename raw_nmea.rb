# raw_nmea.rb is some code I hacked together because I couldn't get the NMEA gem to 
# work, the following information is taken from an html file included in said gem.
require 'pry'

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

  def get_sql_inserts
    return @insert_statements
  end

  def import_from_files
    if @sentences.nil?
      @sentences = []
      @sentence_types = []
      @gpgga_pts = []
      @insert_statements = []
       
      @filenames.each do |filename|
        File.open(filename).each do |sentence|
          t = sentence.split(",").first 

          if t =~ /^\$G/
            @sentences << sentence
            @sentence_types << t unless @sentence_types.member? t
            if t == "$GPGGA"
              sentence = sentence.gsub(/^\$GPGGA,/, '')                     # chop off $GPGGA
              thedate = filename.scan(/GPS_\d{8}/).first.gsub(/GPS_/,'')    # extract date from filename
                                                                            #
              ye1,ye2,mon,day = thedate.scan(/\d{2}/)                       #
              thedate = "#{ye1+ye2}-#{mon}-#{day}"                          #  prettify date

              thetime = sentence.scan(/^[\d+\.]+,/).first                   # extract time from sentence
              hour,min,sec = thetime.gsub(/\.\d+,$/,'').scan(/\d{2}/)       # decompose time
              sentence = sentence.gsub(/^[\d+\.]+,/,'')                     # delete unformatted time

              g = GPGGA.new "'#{thedate} #{hour}:#{min}:#{sec} UTC', #{sentence}"
              @gpgga_pts << g.to_hash
              @insert_statements << g.to_sql
            end
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

  def gpgga_pts
    return @gpgga_pts[4]
  end
end

#######################################################################################
# Global Positioning System Fix Data
#
# eg1. $GPGGA,170834,4124.8963,N,08151.6838,W,1,05,1.5,280.2,M,-34.0,M,,,*75
#
# Name                                    Example Data   Description
# Sentence  Identifier                    $GPGGA         Global Positioning System Fix Data
# Time                                    170834         17:08:34 UTC
# Latitude                                4124.8963, N   41d 24.8963' N or 41d 24' 54" N
# Longitude                               08151.6838, W  81d 51.6838' W or 81d 51' 41" W
# Fix Quality:
# - 0 = Invalid
# - 1 = GPS fix
# - 2 = DGPS fix                          1               Data is from a GPS fix
# Number of Satellites                    05              5 Satellites are in view
# Horizontal Dilution of Precision (HDOP) 1.5             Relative accuracy of 
#                                                         horizontal position
# Altitude                                280.2, M        280.2 meters above mean sea level
# Height of geoid above WGS84 ellipsoid  -34.0, M         -34.0 meters
# Time since last DGPS update             blank           No last update
# DGPS reference station id               blank           No station id
# Checksum                                *75             Used by program to check 
#                                                         for transmission errors
#
#######################################################################################
class GPGGA
  def initialize sentence
    @utc,
    @latitude,
    @northsouth,
    @longitude,
    @eastwest, 
    @quality,
    @number_of_satellites_in_use,
    @hdop, 
    @altitude,
    @above_sea_unit,
    @geoidal_separation,
    @geoidal_separation_unit,
    @data_age,
    @diff_ref_stationID = sentence.split(",")

    @latitude = @latitude.to_f
    @longitude = @longitude.to_f
    @quality = @quality.to_f
    @number_of_satellites_in_use = @number_of_satellites_in_use.to_i
    @hdop = @hdop.to_i
    @altitude = @altitude.to_f
    @geoidal_separation = @geoidal_separation.to_f
  end

  def to_sql
    return "INSERT INTO points (t, lat, ns, lng, ew, fixquality, numsatellites, hdop, alt, alt_unit, geoid_height, geoid_unit) VALUES(#{@utc}, #{@latitude}, '#{@northsouth}', #{@longitude}, '#{@eastwest}', #{@quality}, #{@number_of_satellites_in_use}, #{@hdop}, #{@altitude}, '#{@above_sea_unit}', #{@geoidal_separation}, '#{@geoidal_separation_unit}');"
  end
    
  def to_hash
    return {utc:      @utc,
            latitude: @latitude, 
            northsouth: @northsouth, 
            longitude: @longitude, 
            eastwest: @eastwest, 
            quality: @quality, 
            number_of_satellites_in_use: @number_of_satellites_in_use, 
            hdop: @hdop, 
            altitude: @altitude, 
            above_sea_unit: @above_sea_unit, 
            geoidal_separation: @geoidal_separation, 
            geoidal_separation_unit: @geoidal_separation_unit, 
            data_age: @data_age, 
            diff_ref_stationID: @diff_ref_stationID }
    
  end
end

#######################################################################################
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
class GPRMC
  def parse sentence
    # TODO: implement
    sentence
  end
end

r = RawNMEAData.new "~/Dropbox/Data/GPS/"
r.import_from_files
puts r.get_sql_inserts
