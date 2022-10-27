module Timesheets
  class Import
    def self.call(file)
      
      $timesheets_imported_count = 0

      sheet = RubyXL::Parser.parse(file)[0]

      sheet[1..1].map do |row| # Вторая строка - заголовки
        heads = row.cells[0..52].map { |c| c&.value.to_s }
        @days = heads.select{ _1 =~ /^\d+$/ } # На выходе получим массив дней.
        @days_index_from = 8 # Индекс начала дней
        @days_index_since = @days_index_from + @days.length() - 1 # Индекс конца дней
        $days_count = @days.length()
        #@yavok = heads.index {|i| i == "Явок" }
        @yavok = @days_index_from + @days.length()
      end

      sheet[2..-1].each do |row| # Все строки с третьей
        cells = row.cells[0..52].map { |c| c&.value.to_s }
        colours = row.cells[6..7].map { |c| c&.fill_color }

        timesheet = Timesheet.new(colour: colours[0],
                      unit: cells[0],
                      subdivision_code: cells[1],
                      personnel_number: cells[2],
                      employment_official_date: cells[3].slice(0,10),
                      employment_fact_date: cells[4].slice(0,10),
                      full_name: cells[6],
                      position: cells[7],
                      worked_hours_per_day: cells[@yavok.to_i + 2],
                      worked_hours_per_night: cells[@yavok.to_i + 3])

        add_worked_hours(timesheet, cells[@days_index_from..@days_index_since])
        add_yavok(timesheet)
        add_chasov(timesheet)
        add_itogo(timesheet)
        add_nevihod(timesheet)
        add_zayavlenie(timesheet)
        add_spravka(timesheet)
        add_bolnichniy(timesheet)
        add_otpusk(timesheet)
        add_razreshenie(timesheet)
        add_otrabotka(timesheet)
        add_otpusk_po_razresheniu(timesheet)

        $timesheets_imported_count = $timesheets_imported_count + 1
        timesheet.save!
      end
    end

    def self.add_worked_hours(timesheet, cells)
      cells.each.with_index do |cell, index|
        next if cell.blank?
        cell.gsub!(',', '.')

        attributes = {day_of_month: index + 1}

        if cell.to_f > 0
          attributes[:hours] = cell.to_f
        else
          attributes[:note] = cell
        end

        timesheet.worked_hours.build(attributes)
      end
    end

    def self.add_yavok(timesheet)
      shifts = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.hours.to_f > 0 then
          shifts = shifts + 1
        end
      end
      timesheet.worked_shifts_total = shifts
      timesheet.save!
    end

    def self.add_chasov(timesheet)
      chasov = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.hours.to_f > 0 then
          chasov = chasov + worked_hours.hours
        end
        if chasov.to_i == chasov then
          timesheet.worked_hours_total = chasov.to_i
        end
      end
      timesheet.worked_hours_total = chasov
      timesheet.save!
    end

    def self.add_itogo(timesheet)
      raznica = 0
      if timesheet.worked_hours_total.to_f > 0 and timesheet.worked_hours_per_day.to_f > 0 and timesheet.worked_hours_per_night.to_f > 0 then
        raznica = timesheet.worked_hours_total - (timesheet.worked_hours_per_day + timesheet.worked_hours_per_night)
      end
      if raznica.to_i == raznica then
        timesheet.check_formula = raznica.to_i
      else
        timesheet.check_formula = raznica
      end
        timesheet.save!
    end

    def self.add_nevihod(timesheet)
      progul = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.note == 'н' then
          progul = progul + 1
        end
      end
      timesheet.absences_total = progul
      timesheet.save!
    end

    def self.add_zayavlenie(timesheet)
      progul = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.note == 'з'+'/'+'я' then
          progul = progul + 1
        end
      end
      timesheet.absences_by_request = progul
      timesheet.save!
    end

    def self.add_spravka(timesheet)
      progul = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.note == 'сп' then
          progul = progul + 1
        end
      end
      timesheet.absences_by_certificate = progul
      timesheet.save!
    end

    def self.add_bolnichniy(timesheet)
      progul = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.note == 'б' then
          progul = progul + 1
        end
      end
      timesheet.absences_by_sick_leave = progul
      timesheet.save!
    end

    def self.add_otpusk(timesheet)
      progul = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.note == 'от' then
          progul = progul + 1
        end
      end
      timesheet.vacation_days_total = progul
      timesheet.save!
    end

    def self.add_razreshenie(timesheet)
      progul = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.note == 'а' then
          progul = progul + 1
        end
      end
      timesheet.absences_by_permission = progul
      timesheet.save!
    end

    def self.add_otrabotka(timesheet)
      progul = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.note == 'и' then
          progul = progul + 1
        end
      end
      timesheet.absences_with_working_out = progul
      timesheet.save!
    end

    def self.add_otpusk_po_razresheniu(timesheet)
      progul = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.note == 'оа' then
          progul = progul + 1
        end
      end
      timesheet.absences_by_permission_vacation = progul
      timesheet.save!
    end

  end
end