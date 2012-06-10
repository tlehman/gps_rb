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
  def initialize(sentence)
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

    @quality                     = @quality.to_f
    @number_of_satellites_in_use = @number_of_satellites_in_use.to_i
    @hdop                        = @hdop.to_i
    @altitude                    = @altitude.to_f
    @geoidal_separation          = @geoidal_separation.to_f

  end

  def to_sql
    return "INSERT INTO points (t, lat, ns, lng, ew, fixquality, numsatellites, hdop, alt, alt_unit, geoid_height, geoid_unit) VALUES(#{@utc}, #{@latitude}, '#{@northsouth}', #{@longitude}, '#{@eastwest}', #{@quality}, #{@number_of_satellites_in_use}, #{@hdop}, #{@altitude}, '#{@above_sea_unit}', #{@geoidal_separation}, '#{@geoidal_separation_unit}');"
  end
    
  def to_hash
    return {utc: @utc,
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