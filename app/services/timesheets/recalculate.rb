module Timesheets
  class Recalculate
    attr_reader :timesheet
    def initialize(timesheet)
      @timesheet = timesheet
    end

    def call(save: true)
      add_yavok(timesheet)
      add_chasov(timesheet)
      add_nevihod(timesheet)
      add_zayavlenie(timesheet)
      add_spravka(timesheet)
      add_bolnichniy(timesheet)
      add_otpusk(timesheet)
      add_razreshenie(timesheet)
      add_otrabotka(timesheet)
      add_otpusk_po_razresheniu(timesheet)
      add_worked_hours_per_day(timesheet)
      add_worked_hours_per_night(timesheet)
      add_itogo(timesheet)
      timesheet.save! if save
    end

    def add_yavok(timesheet)
      shifts = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.hours.to_f > 0 then
          shifts = shifts + 1
        end
      end
      timesheet.worked_shifts_total = shifts
    end

    def add_chasov(timesheet)
      chasov = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.hours.to_f > 0 then
          chasov = chasov + worked_hours.hours
        end
        if chasov.to_i == chasov then
          chasov = chasov.to_i
        else
          chasov = chasov.round(1)
        end
      end
      timesheet.worked_hours_total = chasov
    end

    def add_nevihod(timesheet)
      progul = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.note == 'н'
          progul = progul + 1
        elsif worked_hours.note == 'Н'
          progul = progul + 1
        elsif worked_hours.note == 'H'
          progul = progul + 1
        end
      end
      timesheet.absences_total = progul
    end

    def add_zayavlenie(timesheet)
      progul = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.note == "з/я"
          progul = progul + 1
        elsif worked_hours.note == "з\\я"
          progul = progul + 1
        elsif worked_hours.note == "З/Я"
          progul = progul + 1
        elsif worked_hours.note == "З\\Я"
          progul = progul + 1
        end
      end
      timesheet.absences_by_request = progul
    end

    def add_spravka(timesheet)
      progul = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.note == 'сп'
          progul = progul + 1
        elsif worked_hours.note == 'СП'
          progul = progul + 1
        end
      end
      timesheet.absences_by_certificate = progul
    end

    def add_bolnichniy(timesheet)
      progul = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.note == 'б'
          progul = progul + 1
        elsif worked_hours.note == 'Б'
          progul = progul + 1
        end
      end
      timesheet.absences_by_sick_leave = progul
    end

    def add_otpusk(timesheet)
      progul = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.note == 'от'
          progul = progul + 1
        elsif worked_hours.note == 'ОТ'
          progul = progul + 1
        end
      end
      timesheet.vacation_days_total = progul
    end

    def add_razreshenie(timesheet)
      progul = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.note == 'а'
          progul = progul + 1
        elsif worked_hours.note == 'a'
          progul = progul + 1
        elsif worked_hours.note == 'А'
          progul = progul + 1
        elsif worked_hours.note == 'A'
          progul = progul + 1
        end
      end
      timesheet.absences_by_permission = progul
    end

    def add_otrabotka(timesheet)
      progul = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.note == 'и'
          progul = progul + 1
        elsif worked_hours.note == 'И'
          progul = progul + 1
        end
      end
      timesheet.absences_with_working_out = progul
    end

    def add_otpusk_po_razresheniu(timesheet)
      progul = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.note == 'оа'
          progul = progul + 1
        elsif worked_hours.note == 'oa'
          progul = progul + 1
        elsif worked_hours.note == 'ОА'
          progul = progul + 1
        elsif worked_hours.note == 'OA'
          progul = progul + 1
        end
      end
      timesheet.absences_by_permission_vacation = progul
    end

    def add_worked_hours_per_day(timesheet)
      chasov = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.fill == 'ffffff'
          if worked_hours.hours.to_f > 0 then
            chasov = chasov + worked_hours.hours
          end
        end
        if chasov.to_i == chasov then
          chasov = chasov.to_i
        else
          chasov = chasov.round(1)
        end
      end
      timesheet.worked_hours_per_day = chasov
    end

    def add_worked_hours_per_night(timesheet)
      chasov = 0
      timesheet.worked_hours.each do |worked_hours|
        if worked_hours.fill != 'ffffff'
          if worked_hours.hours.to_f > 0 then
            chasov = chasov + worked_hours.hours
          end
        end
        if chasov.to_i == chasov then
          chasov = chasov.to_i
        else
          chasov = chasov.round(1)
        end
      end
      timesheet.worked_hours_per_night = chasov
    end

    def add_itogo(timesheet)
      raznica = 0
      if timesheet.worked_hours_total.to_f > 0 and timesheet.worked_hours_per_day.to_f > 0 and timesheet.worked_hours_per_night.to_f > 0 then
        raznica = timesheet.worked_hours_total - (timesheet.worked_hours_per_day + timesheet.worked_hours_per_night)
      end
      if raznica.to_i == raznica then
        raznica = raznica.to_i
      else
        raznica = raznica.round(1)
      end
      timesheet.check_formula = raznica
    end
  end
end
