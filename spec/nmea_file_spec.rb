require_relative '../nmea_file'

describe NMEAFile do
  it "should return an iterator of hashes containing GPS Data" do
    NMEAFile.open(File.expand_path("../fixtures/GPS_20120331_022828.log"))
    
  end
end
