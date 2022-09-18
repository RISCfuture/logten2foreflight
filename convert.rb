require 'csv'
require 'bundler'
Bundler.require
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/string/exclude'

$/ = "\r\n"

################################################################################

LTP_LOGBOOK_PATH = Pathname.new(Dir.home).join('Library/Containers/com.coradine.LogTenProX/Data/Documents/LogTenProData/LogTenCoreDataStore.sql')

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
    210 => 'airplane',
    581 => 'glider'
}.freeze
AIRCRAFT_CLASSES = {
    321 => 'airplane_single_engine_land',
    146 => 'airplane_single_engine_sea',
    680 => 'airplane_multi_engine_land',
    97  => 'airplane_multi_engine_sea'
}.freeze
ENGINE_TYPES = {
    244 => 'Piston',
    676 => 'Turbofan',
    507 => 'Non-Powered'
}.freeze

def load_ltp_logbook_aircraft(ltp_logbook)
  db       = SQLite3::Database.new(ltp_logbook.to_s)
  aircraft = Array.new

  db.execute("SELECT ZAIRCRAFT_AIRCRAFTID, ZAIRCRAFT_AIRCRAFTTYPE,
      ZAIRCRAFT_YEAR, ZAIRCRAFT_UNDERCARRIAGEAMPHIB,
      ZAIRCRAFT_UNDERCARRIAGEFLOATS, ZAIRCRAFT_UNDERCARRIAGERETRACTABLE,
      ZAIRCRAFT_UNDERCARRIAGESKIDS, ZAIRCRAFT_UNDERCARRIAGESKIS,
      ZAIRCRAFT_TAILWHEEL, ZAIRCRAFT_RADIALENGINE, ZAIRCRAFT_COMPLEX,
      ZAIRCRAFT_HIGHPERFORMANCE, ZAIRCRAFT_PRESSURIZED,
      ZAIRCRAFT_TECHNICALLYADVANCED
      FROM ZAIRCRAFT") do |(tail_number, type_id, year, amphib, floats, retract, skids, skis, tailwheel, radial, complex, hp, pressurized, taa)|
    type_data = db.execute("SELECT ZAIRCRAFTTYPE_TYPE, ZAIRCRAFTTYPE_MAKE,
        ZAIRCRAFTTYPE_MODEL, ZAIRCRAFTTYPE_CATEGORY, ZAIRCRAFTTYPE_AIRCRAFTCLASS,
        ZAIRCRAFTTYPE_ENGINETYPE, ZAIRCRAFTTYPE_CUSTOMATTRIBUTE1,
        ZAIRCRAFTTYPE_CUSTOMATTRIBUTE2, ZAIRCRAFTTYPE_CUSTOMATTRIBUTE3
        FROM ZAIRCRAFTTYPE WHERE Z_PK = #{type_id}")[0]
    type_code, make, model, category_id, class_id, engine_type_id, sim_type, sim_aircraft, sim_aircraft_cat = type_data

    year = (Time.utc(2001, 1, 1) + year.to_i).year if year

    if category_id == 100 # simulator
      equipment_type  = sim_type.downcase
      category, klass = simulator_category_class(sim_aircraft_cat)
      type_code       = sim_aircraft
    else
      equipment_type = 'aircraft'
      category       = category_id ? AIRCRAFT_CATEGORIES.fetch(category_id) : nil
      klass          = aircraft_class(category, class_id)
      type_code      = aircraft_type(type_code)
    end

    aircraft << {
        tail_number:,
        type_code:,
        year:,
        make:,
        model:,
        equipment_type:,
        category:,
        class:            klass,
        gear_type:        gear_type(category_id == 100, amphib == 1, floats == 1, retract == 1, skids == 1, skis == 1, tailwheel == 1),
        engine_type:      engine_type(engine_type_id, radial == 1, make),
        complex:          complex == 1,
        high_performance: hp == 1,
        pressurized:      pressurized == 1,
        taa:              taa == 1
    }
  end

  return aircraft
end

def gear_type(simulator, amphib, floats, retract, skids, skis, tailwheel)
  return nil if simulator
  return 'AM' if amphib
  return 'FL' if floats
  return 'Skids' if skids
  return 'Skis' if skis
  return 'FC' if !retract && tailwheel
  return 'FT' if !retract && !tailwheel
  return 'RC' if retract && tailwheel
  return 'RT' if retract && !tailwheel

  raise "Unknown gear type"
end

def engine_type(code, radial, atype)
  return nil unless code

  type = ENGINE_TYPES.fetch(code)
  return 'Radial' if type == 'Piston' && radial
  return 'Diesel' if atype == 'DA42'

  return type
end

def aircraft_class(category, class_id)
  return 'glider' if category == 'glider'

  return class_id ? AIRCRAFT_CLASSES.fetch(class_id) : nil
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
  return 'SR22' if type.start_with?('SR22-')
  return 'SR22' if type.start_with?('SR22N-')
  return 'S22T' if type.start_with?('SR22T-')
  return 'SF50' if type.start_with?('SF50-')
  return 'C82T' if type.start_with?('C-T182')
  return 'G44' if type.start_with?('G-44')
  return 'S233' if type.start_with?('2-33')

  return type
end

def simulator_category_class(cat)
  return %w[airplane airplane_single_engine_land] if cat == 'ASEL'
  return %w[airplane airplane_multi_engine_land] if cat == 'AMEL'
  return %w[airplane airplane_single_engine_sea] if cat == 'ASEL'
  return %w[airplane airplane_multi_engine_sea] if cat == 'AMES'
  return %w[glider glider] if cat == 'GL'

  return nil
end

################################################################################

def load_ltp_logbook_flights(ltp_logbook)
  db      = SQLite3::Database.new(ltp_logbook.to_s)
  flights = Array.new

  db.execute("SELECT Z_PK, ZFLIGHT_FLIGHTDATE, ZFLIGHT_AIRCRAFT, ZFLIGHT_FROMPLACE,
      ZFLIGHT_TOPLACE, ZFLIGHT_ROUTE, ZFLIGHT_ACTUALDEPARTURETIME,
      ZFLIGHT_TAKEOFFTIME, ZFLIGHT_LANDINGTIME, ZFLIGHT_ACTUALARRIVALTIME, ZFLIGHT_ONDUTYTIME, ZFLIGHT_OFFDUTYTIME,
      ZFLIGHT_TOTALTIME, ZFLIGHT_PIC, ZFLIGHT_SIC, ZFLIGHT_NIGHT, ZFLIGHT_SOLO,
      ZFLIGHT_CROSSCOUNTRY, ZFLIGHT_DISTANCE, ZFLIGHT_DAYTAKEOFFS,
      ZFLIGHT_DAYLANDINGS, ZFLIGHT_NIGHTTAKEOFFS, ZFLIGHT_NIGHTLANDINGS,
      ZFLIGHT_FULLSTOPS, ZFLIGHT_CUSTOMLANDING1, ZFLIGHT_ACTUALINSTRUMENT,
      ZFLIGHT_SIMULATEDINSTRUMENT, ZFLIGHT_HOBBSSTART, ZFLIGHT_HOBBSSTOP,
      ZFLIGHT_TACHSTART, ZFLIGHT_TACHSTOP, ZFLIGHT_HOLDS, ZFLIGHT_DUALGIVEN,
      ZFLIGHT_DUALRECEIVED, ZFLIGHT_SIMULATOR, ZFLIGHT_GROUND, ZFLIGHT_REMARKS,
      ZFLIGHT_REVIEW, ZFLIGHT_INSTRUMENTPROFICIENCYCHECK
      FROM ZFLIGHT") do |(flight_id, date, aircraft_id, from_id, to_id, route, time_out, off, on, time_in, on_duty, off_duty, total_time, pic, sic, night, solo, xc, distance, day_to, day_ldg, night_to, night_ldg, full_stops, night_full_stops, actual, sim_inst, hobbs_out, hobbs_in, tach_out, tach_in, holds, dual_given, dual_received, sim, ground, remarks, bfr, ipc)|
    next unless aircraft_id

    aircraft_data = db.execute("SELECT ZAIRCRAFT_AIRCRAFTID FROM ZAIRCRAFT WHERE Z_PK = #{aircraft_id}")[0]

    from_data     = db.execute("SELECT ZPLACE_ICAOID, ZPLACE_IDENTIFIER FROM ZPLACE WHERE Z_PK = #{from_id}")[0] if from_id
    to_data       = db.execute("SELECT ZPLACE_ICAOID, ZPLACE_IDENTIFIER FROM ZPLACE WHERE Z_PK = #{to_id}")[0] if to_id

    approach_ids      = db.execute("SELECT #{(1..10).map { |i| "ZFLIGHTAPPROACHES_APPROACH#{i}" }.join(', ')}
        FROM ZFLIGHTAPPROACHES WHERE ZFLIGHTAPPROACHES_FLIGHT = #{flight_id}").flatten.compact
    approach_data     = db.execute("SELECT #{(1..10).map { |i| "ZAPPROACH_FLIGHTAPPROACHES#{i}" }.join(', ')},
        ZAPPROACH_TYPE, ZAPPROACH_COMMENT, ZAPPROACH_PLACE FROM ZAPPROACH
        WHERE Z_PK IN (#{approach_ids.join(', ')})")
    approach_airports = db.execute("SELECT Z_PK, ZPLACE_ICAOID, ZPLACE_IDENTIFIER FROM ZPLACE WHERE Z_PK IN (#{approach_data.filter_map { |a| a[12] }.join(', ')})")

    crew_data      = db.execute("SELECT ZFLIGHTCREW_PIC, ZFLIGHTCREW_SIC, ZFLIGHTCREW_INSTRUCTOR, ZFLIGHTCREW_STUDENT FROM ZFLIGHTCREW WHERE ZFLIGHTCREW_FLIGHT = #{flight_id}")[0]
    passenger_data = db.execute("SELECT #{(1..20).map { |i| "ZFLIGHTPASSENGERS_PAX#{i}" }.join(', ')} FROM ZFLIGHTPASSENGERS WHERE ZFLIGHTPASSENGERS_FLIGHT = #{flight_id}")[0].compact
    people_data    = db.execute("SELECT Z_PK, ZPERSON_NAME, ZPERSON_EMAIL, ZPERSON_ISME FROM ZPERSON").index_by { |p| p[0] }
    my_id          = people_data.values.detect { |i| i[3] == 1 }[0]

    approaches = Array.new
    approach_data.each do |data|
      type = approach_type(data[10]) or next
      num                 = (1..10).detect { |i| data[i - 1] }
      approaches[num - 1] = {
          type:,
          runway:  data[11],
          airport: approach_airports.detect { |a| a[0] == data[12] }&.slice(1..2)&.compact&.first
      }
    end

    instructor = crew_data[2] ? people_data[crew_data[2]][1] : nil

    people = Array.new
    if remarks&.downcase&.include?('safety pilot') && crew_data[0] == my_id && crew_data[1]
      safety = people_data[crew_data[1]]
      people << {name: safety[1], role: 'Safety Pilot', email: safety[2]}
    elsif crew_data[0] && crew_data[0] != my_id && crew_data[0] != crew_data[2]
      picp = people_data[crew_data[0]]
      people << {name: picp[1], role: 'PIC', email: picp[2]}
    end
    if crew_data[1] && crew_data[1] != my_id && remarks.downcase.exclude?('safety pilot')
      sicp = people_data[crew_data[1]]
      people << {name: sicp[1], role: 'SIC', email: sicp[2]}
    end
    if crew_data[3] && crew_data[3] != my_id
      student = people_data[crew_data[3]]
      people << {name: student[1], role: 'Student', email: student[2]}
    end
    if remarks&.downcase&.include?('checkride') && passenger_data.size == 1
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
        off:                  off ? Time.utc(2001, 1, 1) + off : nil,
        on:                   on ? Time.utc(2001, 1, 1) + on : nil,
        in:                   time_in ? Time.utc(2001, 1, 1) + time_in : nil,
        off_duty:             off_duty ? Time.utc(2001, 1, 1) + time_in : nil,
        on_duty:              on_duty ? Time.utc(2001, 1, 1) + time_in : nil,
        total_time:           total_time / 60.0,
        pic:                  (pic || 0) / 60.0,
        sic:                  (sic || 0) / 60.0,
        solo:                 (solo || 0) / 60.0,
        night:                (night || 0) / 60.0,
        cross_country:        (xc || 0) / 60.0,
        distance:,
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
        approaches:,
        dual_given:           (dual_given || 0) / 60.0,
        dual_received:        (dual_received || 0) / 60.0,
        simulated:            (sim || 0) / 60.0,
        ground:               (ground || 0) / 60.0,
        instructor_name:      instructor,
        people:,
        flight_review:        (bfr == 1 && remarks.downcase.exclude?('checkride')),
        checkride:            (bfr == 1 && remarks.downcase.include?('checkride')),
        ipc:                  ipc == 1,
        remarks:
    }
  end

  return flights
end

def approach_type(type)
  return 'RNAV (GPS)' if %w[GPS GPS/GNSS].include?(type)
  return 'ILS' if type == 'ILS/DME'
  return 'LOC' if type == 'LOC/DME'
  return 'RNAV (GPS)' if type == 'RNAV'
  return 'RNAV (GPS)' if %w[LNAV LNAV/VNAV LNAV+V LP LP+V LPV].include?(type)
  return 'VOR' if type == 'VOR/DME'
  return nil if type == 'VISUAL'

  return type
end

################################################################################

def print_header
  puts "ForeFlight Logbook Import,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
end

AIRCRAFT_NIL_FILLER = [nil] * 45

def print_aircraft(aircraft)
  puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
  puts "Aircraft Table,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"

  puts(CSV.generate do |csv|
    csv << (%w[Text Text Text YYYY Text Text Text Text Text Text Boolean Boolean Boolean] + AIRCRAFT_NIL_FILLER)
    csv << (%w[AircraftID EquipmentType TypeCode Year Make Model Category Class GearType EngineType Complex HighPerformance Pressurized] + AIRCRAFT_NIL_FILLER)

    aircraft.sort_by { |a| a[:tail_number] }.each do |plane|
      csv << [
          plane[:tail_number],
          plane[:equipment_type],
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
          *AIRCRAFT_NIL_FILLER
      ]
    end
  end)
end

FLIGHT_NIL_FILLER = [nil] * 6

def print_flights(flights)
  puts ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
  puts "Flights Table,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#;type;runway;airport;comments,,,,,,,,,,,,name;role;email,,,,,,,,,,,,,,,"

  puts(CSV.generate do |csv|
    csv << ["Date", "Text", "Text", "Text", "Text", "hhmm", "hhmm", "hhmm", "hhmm", "hhmm", "hhmm", "Decimal", "Decimal", "Decimal", "Decimal", "Decimal", "Decimal", "Decimal", "Number", "Number", "Number", "Number", "Number", "Decimal", "Decimal", "Decimal", "Decimal", "Decimal", "Decimal", "Number", "Packed Detail", "Packed Detail", "Packed Detail", "Packed Detail", "Packed Detail", "Packed Detail", "Decimal", "Decimal", "Decimal", "Decimal", "Text", "Text", "Packed Detail", "Packed Detail", "Packed Detail", "Packed Detail", "Packed Detail", "Packed Detail", "Boolean", "Boolean", "Boolean", "Text", "Decimal", "Decimal", "Number", "Date", "Boolean", "Text"]
    csv << %w(Date AircraftID From To Route TimeOut TimeOff TimeOn TimeIn OnDuty OffDuty TotalTime PIC SIC Night Solo CrossCountry Distance DayTakeoffs DayLandingsFullStop NightTakeoffs NightLandingsFullStop AllLandings ActualInstrument SimulatedInstrument HobbsStart HobbsEnd TachStart TachEnd Holds Approach1 Approach2 Approach3 Approach4 Approach5 Approach6 DualGiven DualReceived SimulatedFlight GroundTraining InstructorName InstructorComments Person1 Person2 Person3 Person4 Person5 Person6 FlightReview Checkride IPC [Text]CustomFieldName [Numeric]CustomFieldName [Hours]CustomFieldName [Counter]CustomFieldName [Date]CustomFieldName [Toggle]CustomFieldName PilotComments)

    flights.sort_by { |f| f[:date] }.each do |flight|
      csv << [
          flight[:date].strftime('%Y-%m-%d'),
          flight[:aircraft_id],
          flight[:from],
          flight[:to],
          flight[:route],
          flight[:out] ? flight[:out].strftime('%H%M') : nil,
          flight[:off] ? flight[:off].strftime('%H%M') : nil,
          flight[:on] ? flight[:on].strftime('%H%M') : nil,
          flight[:in] ? flight[:in].strftime('%H%M') : nil,
          flight[:off_duty] ? flight[:off_duty].strftime('%H%M') : nil,
          flight[:on_duty] ? flight[:on_duty].strftime('%H%M') : nil,
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
          *FLIGHT_NIL_FILLER, # custom fields
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
