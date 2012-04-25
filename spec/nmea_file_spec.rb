require_relative '../nmea_file'

describe NMEAFile do
  it "should return an array of hashes containing GPS Data" do
    nf = NMEAFile.new(File.expand_path("../fixtures/GPS_20120331_022828.log"))
    nf.to_hash.should.have_key? 'latitude'
  end
end
