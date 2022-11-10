module Timesheets
  class Import
    def self.call(file)
      
      $timesheets_imported_count = 0

      sheet = RubyXL::Parser.parse(file)[0]

      sheet[1..1].map do |row| # Вторая строка - заголовки
        heads = row.cells[0..38].map { |c| c&.value.to_s }
        @days = heads.select{ _1 =~ /^\d+$/ } # На выходе получим массив дней.
        @days_index_from = 8 # Индекс начала дней
        @days_index_since = @days_index_from + @days.length() - 1 # Индекс конца дней
        $days_count = @days.length()
        #@yavok = heads.index {|i| i == "Явок" }
        @yavok = @days_index_from + @days.length()
      end

      sheet[2..-1].each do |row| # Все строки с третьей
        cells = row.cells[0..38].map { |c| c&.value.to_s }
        colours = row.cells[6..7].map { |c| c&.fill_color }
        fill_colors = row.cells[0..38].map { |c| c&.fill_color }

        timesheet = Timesheet.new(colour: colours[0],
                      unit: cells[0],
                      subdivision_code: cells[1],
                      personnel_number: cells[2],
                      employment_official_date: cells[3].slice(0,10),
                      employment_fact_date: cells[4].slice(0,10),
                      full_name: cells[6],
                      position: cells[7])
                      #worked_hours_per_day: cells[@yavok.to_i + 2],
                      #worked_hours_per_night: cells[@yavok.to_i + 3])

        add_worked_hours(timesheet, cells[@days_index_from..@days_index_since], fill_colors[@days_index_from..@days_index_since])

        Timesheets::Recalculate.new(timesheet).call

        
        
        $timesheets_imported_count = $timesheets_imported_count + 1
        timesheet.save!
      end
    end

    def self.add_worked_hours(timesheet, cells, fill_colors)

      cells.each.with_index do |cell, index|
        attributes = {day_of_month: index + 1}
        if cell.blank? then
          attributes[:note] = ''
        else
          cell.gsub!(',', '.')
          
          if cell.to_f > 0
            attributes[:hours] = cell.to_f
            attributes[:fill] = fill_colors[index]
          else
            attributes[:note] = cell
          end
        end

        timesheet.worked_hours.build(attributes)
      end
    end

    
  end
end