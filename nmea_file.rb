class NMEAFile
  def initialize(filename)
    @filename = filename
  end

  def to_hash
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
end
