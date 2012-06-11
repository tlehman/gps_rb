A simple NMEA parser and database utility for an AMOD 3080 GPS Data Logger
==========================================================================

Features:

- takes .log files and extracts date, time, latitude, longitude, altitude, 
  and number of satellites, then inserts into a database


To-Do List:

- Make a rake task that
  - ~~Checks if the device is connected (looks for /Volumes/GPS\ Tracker)~~
	- Add support for GNU/Linux and Windows
  - ~~Gets list of all files on GPS Tracker~~
	- ~~Copies all files to Data Store~~
		- ~~Data store config require some configuration file~~
- ~~Change the interface of NMEAFile to behave more like file~~
	- example usage: 
	  NMEAFile.open(filename).each do |nmea|
			process_nmea_object(nmea)
	  end
- Store GPS Logger path in config.yml (related to other OS support)
- Abstract away dealing with the file system: remove repetitive code 
from rake tasks
- Add support for annotations (rake notes:annotation where "# ANNOTATION" is a comment)
- ~~Add rake gps:clear ~~