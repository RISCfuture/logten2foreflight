require 'csv'
require 'bundler'
Bundler.require

$/ = "\r\n"

################################################################################

LTP_LOGBOOK_PATH = Pathname.new('/Users/tim/Library/Containers/com.coradine.LogTenProX/Data/Documents/LogTenProData/LogTenCoreDataStore.sql')

def find_ltp_logbook
  if ARGV.empty?
    if LTP_LOGBOOK_PATH.exist?
      return LTP_LOGBOOK_PATH
    else
      warn <<~EOF.chomp
        No LogTen Pro X logbook file detected. Re-run this command and specify the
        location of your LogTenCoreDataStore.sql file as an argument.
      EOF
      exit(1)
    end
  else
    path = Pathname.new(ARGV.first)
    if path.exist?
      return path
    else
      warn "File not found: #{path}"
      exit(2)
    end
  end
end

################################################################################

AIRCRAFT_CATEGORIES = {
    682 => 'Airplane',
    773 => 'Simulator'
}.freeze
AIRCRAFT_CLASSES    = {
    447 => 'ASEL',
    590 => 'ASES',
    0   => 'FTD',
    711 => 'AMEL'
}.freeze
ENGINE_TYPES        = {
    134 => 'Piston'
}.freeze

def load_ltp_logbook_aircraft(ltp_logbook)
  db       = SQLite3::Database.new(ltp_logbook.to_s)
  aircraft = Array.new

  db.execute("SELECT ZAIRCRAFT_AIRCRAFTID, ZAIRCRAFT_AIRCRAFTTYPE,
      ZAIRCRAFT_YEAR, ZAIRCRAFT_UNDERCARRIAGEAMPHIB,
      ZAIRCRAFT_UNDERCARRIAGEFLOATS, ZAIRCRAFT_UNDERCARRIAGERETRACTABLE,
      ZAIRCRAFT_UNDERCARRIAGESKIDS, ZAIRCRAFT_TAILWHEEL, ZAIRCRAFT_RADIALENGINE,
      ZAIRCRAFT_COMPLEX, ZAIRCRAFT_HIGHPERFORMANCE, ZAIRCRAFT_PRESSURIZED
      FROM ZAIRCRAFT") do |(tail_number, type_id, year, amphib, floats, retract, skids, tailwheel, radial, complex, hp, pressurized)|
    type_data = db.execute("SELECT ZAIRCRAFTTYPE_TYPE, ZAIRCRAFTTYPE_MAKE,
        ZAIRCRAFTTYPE_MODEL, ZAIRCRAFTTYPE_CATEGORY, ZAIRCRAFTTYPE_AIRCRAFTCLASS,
        ZAIRCRAFTTYPE_ENGINETYPE
        FROM ZAIRCRAFTTYPE WHERE Z_PK = #{type_id}")[0]
    year      = (Time.utc(2001, 1, 1) + year.to_i).year

    aircraft << {
        tail_number:      tail_number,
        type_code:        aircraft_type(type_data[0]),
        year:             year,
        make:             type_data[1],
        model:            type_data[2],
        category:         AIRCRAFT_CATEGORIES[type_data[3].to_i],
        class:            AIRCRAFT_CLASSES[type_data[4].to_i],
        gear_type:        gear_type(type_data[3].to_i, amphib == 1, floats == 1, retract == 1, skids == 1, tailwheel == 1),
        engine_type:      engine_type(type_data[5], radial == 1, type_data[0]),
        complex:          complex == 1,
        high_performance: hp == 1,
        pressurized:      pressurized == 1
    }
  end

  return aircraft
end

def build_ff_logbook
end

def gear_type(category, amphib, floats, retract, skids, tailwheel)
  return nil if AIRCRAFT_CATEGORIES[category] == 'Simulator'
  return 'AM' if amphib
  return 'Floats' if floats
  return 'Skids' if skids
  return 'FC' if !retract && tailwheel
  return 'FT' if !retract && !tailwheel
  return 'RC' if retract && tailwheel
  return 'RT' if retract && !tailwheel

  raise "Unknown gear type"
end

def engine_type(code, radial, atype)
  type = ENGINE_TYPES[code]
  return 'Radial' if type == 'Piston' && radial
  return 'Diesel' if atype == 'DA42'

  return type
end

def aircraft_type(type)
  return nil if type == 'FRASCA 142'
  return 'C152' if type.start_with?('C-152')
  return 'C172' if type.start_with?('C-172')
  return 'C182' if type.start_with?('C-182')
  return 'CH7A' if type == '7ECA'
  return 'CH7B' if type == '7GCBC'
  return 'BL8' if type == '8KCAB'
  return 'PA22' if type.start_with?('PA-22')
  return 'P28A' if type.start_with?('PA-28-')
  return 'P28R' if type.start_with?('PA-28R')
  return 'PA34' if type.start_with?('PA-34')
  return 'SR22' if type.start_with?('SR22-T')
  return 'C82T' if type.start_with?('C-T182')

  return type
end

################################################################################

def load_ltp_logbook_flights(ltp_logbook)
  db      = SQLite3::Database.new(ltp_logbook.to_s)
  flights = Array.new

  db.execute("SELECT Z_PK, ZFLIGHT_FLIGHTDATE, ZFLIGHT_AIRCRAFT, ZFLIGHT_FROMPLACE,
      ZFLIGHT_TOPLACE, ZFLIGHT_ROUTE, ZFLIGHT_ACTUALDEPARTURETIME,
      ZFLIGHT_ACTUALARRIVALTIME, ZFLIGHT_ONDUTYTIME, ZFLIGHT_OFFDUTYTIME,
      ZFLIGHT_TOTALTIME, ZFLIGHT_PIC, ZFLIGHT_SIC, ZFLIGHT_NIGHT, ZFLIGHT_SOLO,
      ZFLIGHT_CROSSCOUNTRY, ZFLIGHT_DISTANCE, ZFLIGHT_DAYTAKEOFFS,
      ZFLIGHT_DAYLANDINGS, ZFLIGHT_NIGHTTAKEOFFS, ZFLIGHT_NIGHTLANDINGS,
      ZFLIGHT_FULLSTOPS, ZFLIGHT_CUSTOMLANDING1, ZFLIGHT_ACTUALINSTRUMENT,
      ZFLIGHT_SIMULATEDINSTRUMENT, ZFLIGHT_HOBBSSTART, ZFLIGHT_HOBBSSTOP,
      ZFLIGHT_TACHSTART, ZFLIGHT_TACHSTOP, ZFLIGHT_HOLDS, ZFLIGHT_DUALGIVEN,
      ZFLIGHT_DUALRECEIVED, ZFLIGHT_SIMULATOR, ZFLIGHT_GROUND, ZFLIGHT_REMARKS,
      ZFLIGHT_REVIEW, ZFLIGHT_INSTRUMENTPROFICIENCYCHECK
      FROM ZFLIGHT") do |(flight_id, date, aircraft_id, from_id, to_id, route, time_out, time_in, on, off, total_time, pic, sic, night, solo, xc, distance, day_to, day_ldg, night_to, night_ldg, full_stops, night_full_stops, actual, sim_inst, hobbs_out, hobbs_in, tach_out, tach_in, holds, dual_given, dual_received, sim, ground, remarks, bfr, ipc)|

    next unless aircraft_id

    aircraft_data = db.execute("SELECT ZAIRCRAFT_AIRCRAFTID FROM ZAIRCRAFT WHERE Z_PK = #{aircraft_id}")[0]

    from_data     = db.execute("SELECT ZPLACE_ICAOID, ZPLACE_IDENTIFIER FROM ZPLACE WHERE Z_PK = #{from_id}")[0] if from_id
    to_data       = db.execute("SELECT ZPLACE_ICAOID, ZPLACE_IDENTIFIER FROM ZPLACE WHERE Z_PK = #{to_id}")[0] if to_id

    approach_ids      = db.execute("SELECT #{(1..10).map { |i| 'ZFLIGHTAPPROACHES_APPROACH' + i.to_s }.join(', ')}
        FROM ZFLIGHTAPPROACHES WHERE ZFLIGHTAPPROACHES_FLIGHT = #{flight_id}").flatten.compact
    approach_data     = db.execute("SELECT #{(1..10).map { |i| 'ZAPPROACH_FLIGHTAPPROACHES' + i.to_s }.join(', ')},
        ZAPPROACH_TYPE, ZAPPROACH_COMMENT, ZAPPROACH_PLACE FROM ZAPPROACH
        WHERE Z_PK IN (#{approach_ids.join(', ')})")
    approach_airports = db.execute("SELECT Z_PK, ZPLACE_ICAOID, ZPLACE_IDENTIFIER FROM ZPLACE WHERE Z_PK IN (#{approach_data.map { |a| a[12] }.compact.join(', ')})")

    crew_data      = db.execute("SELECT ZFLIGHTCREW_PIC, ZFLIGHTCREW_SIC, ZFLIGHTCREW_INSTRUCTOR, ZFLIGHTCREW_STUDENT FROM ZFLIGHTCREW WHERE ZFLIGHTCREW_FLIGHT = #{flight_id}")[0]
    passenger_data = db.execute("SELECT #{(1..20).map { |i| 'ZFLIGHTPASSENGERS_PAX' + i.to_s }.join(', ')} FROM ZFLIGHTPASSENGERS WHERE ZFLIGHTPASSENGERS_FLIGHT = #{flight_id}")[0].compact
    people_data    = db.execute("SELECT Z_PK, ZPERSON_NAME, ZPERSON_EMAIL, ZPERSON_ISME FROM ZPERSON").each_with_object({}) { |p, hsh| hsh[p[0]] = p; }
    my_id          = people_data.values.detect { |i| i[3] == 1 }[0]

    approaches = Array.new
    approach_data.each do |data|
      num                 = (1..10).detect { |i| data[i - 1] }
      approaches[num - 1] = {
          type:    approach_type(data[10]),
          runway:  data[11],
          airport: approach_airports.detect { |a| a[0] == data[12] }&.slice(1..2)&.compact&.first
      }
    end

    instructor = crew_data[2] ? people_data[crew_data[2]][1] : nil

    people = Array.new
    if remarks.downcase.include?('safety pilot') && crew_data[0] == my_id && crew_data[1]
      safety = people_data[crew_data[1]]
      people << {name: safety[1], role: 'Safety Pilot', email: safety[2]}
    elsif crew_data[0] && crew_data[0] != my_id && crew_data[0] != crew_data[2]
      picp = people_data[crew_data[0]]
      people << {name: picp[1], role: 'PIC', email: picp[2]}
    end
    if crew_data[1] && crew_data[1] != my_id
      sicp = people_data[crew_data[1]]
      people << {name: sicp[1], role: 'SIC', email: sicp[2]}
    end
    if crew_data[3] && crew_data[3] != my_id
      student = people_data[crew_data[3]]
      people << {name: student[1], role: 'Student', email: student[2]}
    end
    if remarks.downcase.include?('checkride') && passenger_data.size == 1
      examiner = people_data[passenger_data.first]
      people << {name: examiner[1], role: 'Examiner', email: examiner[2]}
    else
      passenger_data.each do |pax_id|
        pax = people_data[pax_id]
        people << {name: pax[1], role: 'Passenger', email: pax[2]}
      end
    end

    flights << {
        date:                 (Time.utc(2001, 1, 1) + date).to_date,
        aircraft_id:          aircraft_data[0],
        from:                 from_data ? from_data[0] || from_data[1] : nil,
        to:                   to_data ? to_data[0] || to_data[1] : nil,
        route:                route&.gsub('-', ' '),
        out:                  time_out ? Time.utc(2001, 1, 1) + time_out : nil,
        in:                   time_in ? Time.utc(2001, 1, 1) + time_in : nil,
        on:                   on ? Time.utc(2001, 1, 1) + on : nil,
        off:                  off ? Time.utc(2001, 1, 1) + off : nil,
        total_time:           total_time / 60.0,
        pic:                  (pic || 0) / 60.0,
        sic:                  (sic || 0) / 60.0,
        solo:                 (solo || 0) / 60.0,
        night:                (night || 0) / 60.0,
        cross_country:        (xc || 0) / 60.0,
        distance:             distance,
        day_takeoffs:         day_to || 0,
        night_takeoffs:       night_to || 0,
        day_landings:         day_ldg || 0,
        night_landings:       night_ldg || 0,
        day_full_stops:       (full_stops || 0) - (night_full_stops || 0),
        night_full_stops:     night_full_stops || 0,
        all_landings:         (day_ldg || 0) + (night_ldg || 0),
        actual_instrument:    (actual || 0) / 60.0,
        simulated_instrument: (sim_inst || 0) / 60.0,
        hobbs_start:          hobbs_out ? hobbs_out / 60.0 : nil,
        hobbs_end:            hobbs_in ? hobbs_in / 60.0 : nil,
        tach_start:           tach_out ? tach_out / 60.0 : nil,
        tach_end:             tach_in ? tach_in / 60.0 : nil,
        holds:                holds || 0,
        approaches:           approaches,
        dual_given:           (dual_given || 0) / 60.0,
        dual_received:        (dual_received || 0) / 60.0,
        simulated:            (sim || 0) / 60.0,
        ground:               (ground || 0) / 60.0,
        instructor_name:      instructor,
        people:               people,
        flight_review:        (bfr == 1 && !remarks.downcase.include?('checkride')),
        checkride:            (bfr == 1 && remarks.downcase.include?('checkride')),
        ipc:                  ipc == 1,
        remarks:              remarks
    }
  end

  return flights
end

def approach_type(type)
  return 'RNAV (GPS)' if %w[GPS GPS/GNSS].include?(type)
  return 'LOC' if type == 'LOC/DME'
  return 'RNAV (GPS)' if type == 'RNAV'

  return type
end

################################################################################

def print_header
  puts "ForeFlight Logbook Import,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
end

def print_aircraft(aircraft)
  puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
  puts "Aircraft Table,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"

  puts(CSV.generate do |csv|
    csv << (%w[Text Text YYYY Text Text Text Text Text Text Boolean Boolean Boolean] + [nil] * 44)
    csv << (%w[AircraftID TypeCode Year Make Model Category Class GearType EngineType Complex HighPerformance Pressurized] + [nil] * 44)

    aircraft.sort_by { |a| a[:tail_number] }.each do |plane|
      csv << [
          plane[:tail_number],
          plane[:type_code],
          plane[:year].to_s,
          plane[:make],
          plane[:model],
          plane[:category],
          plane[:class],
          plane[:gear_type],
          plane[:engine_type],
          plane[:complex] ? 'x' : nil,
          plane[:high_performance] ? 'x' : nil,
          plane[:pressurized] ? 'x' : nil,
          *([nil] * 44)
      ]
    end
  end)
end

def print_flights(flights)
  puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
  puts "Flights Table,,,,,,,,,,,,,,,,,,,,,,,,,,,,#;type;runway;airport;comments,,,,,,,,,,,,name;role;email,,,,,,,,,,,,,,,"

  puts(CSV.generate do |csv|
    csv << %w[Date Text Text Text Text hhmm hhmm hhmm hhmm Decimal Decimal Decimal Decimal Decimal Decimal Decimal Number Number Number Number Number Decimal Decimal Decimal Decimal Decimal Decimal Number PackedDetail PackedDetail PackedDetail PackedDetail PackedDetail PackedDetail Decimal Decimal Decimal Decimal Text Text PackedDetail PackedDetail PackedDetail PackedDetail PackedDetail PackedDetail Boolean Boolean Boolean Text Decimal Decimal Number Date Boolean Text]
    csv << %w(Date AircraftID From To Route TimeOut TimeIn OnDuty OffDuty TotalTime PIC SIC Night Solo CrossCountry Distance DayTakeoffs DayLandingsFullStop NightTakeoffs NightLandingsFullStop AllLandings ActualInstrument SimulatedInstrument HobbsStart HobbsEnd TachStart TachEnd Holds Approach1 Approach2 Approach3 Approach4 Approach5 Approach6 DualGiven DualReceived SimulatedFlight GroundTraining InstructorName InstructorComments Person1 Person2 Person3 Person4 Person5 Person6 FlightReview Checkride IPC [Text]CustomFieldName [Numeric]CustomFieldName [Hours]CustomFieldName [Counter]CustomFieldName [Date]CustomFieldName [Toggle]CustomFieldName PilotComments)

    flights.sort_by { |f| f[:date] }.each do |flight|
      csv << [
          flight[:date].strftime('%Y-%m-%d'),
          flight[:aircraft_id],
          flight[:from],
          flight[:to],
          flight[:route],
          flight[:out] ? flight[:out].strftime('%H%M') : nil,
          flight[:in] ? flight[:in].strftime('%H%M') : nil,
          flight[:off] ? flight[:off].strftime('%H%M') : nil,
          flight[:on] ? flight[:on].strftime('%H%M') : nil,
          flight[:total_time].round(1),
          flight[:pic].round(1),
          flight[:sic].round(1),
          flight[:night].round(1),
          flight[:solo].round(1),
          flight[:cross_country].round(1),
          flight[:distance]&.round(1) || nil,
          flight[:day_takeoffs],
          flight[:day_landings],
          flight[:night_takeoffs],
          flight[:night_landings],
          flight[:all_landings],
          flight[:actual_instrument].round(1),
          flight[:simulated_instrument].round(1),
          flight[:hobbs_start]&.round(2) || nil,
          flight[:hobbs_end]&.round(2) || nil,
          flight[:tach_start]&.round(2) || nil,
          flight[:tach_end]&.round(2) || nil,
          flight[:holds],
          *(0...6).map { |i| (a = flight[:approaches][i]) ? [i + 1, a[:type], a[:runway], a[:airport], ''].join(';') : nil },
          flight[:dual_given].round(1),
          flight[:dual_received].round(1),
          flight[:simulated].round(1),
          flight[:ground].round(1),
          flight[:instructor_name] || nil,
          nil, # instructor comment
          *(0...6).map { |i| (p = flight[:people][i]) ? [p[:name], p[:role], p[:email]].join(';') : nil },
          flight[:flight_review] ? 'x' : nil,
          flight[:checkride] ? 'x' : nil,
          flight[:ipc] ? 'x' : nil,
          *([nil] * 6), # custom fields
          flight[:remarks]
      ]
    end
  end)
end

################################################################################

def run
  ltp_logbook = find_ltp_logbook

  aircraft = load_ltp_logbook_aircraft(ltp_logbook)
  print_header
  print_aircraft(aircraft)

  flights = load_ltp_logbook_flights(ltp_logbook)
  print_flights(flights)
end

run
