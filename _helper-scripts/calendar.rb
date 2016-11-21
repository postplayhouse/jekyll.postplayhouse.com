# Sloppy script to (mostly) generate a calendar
# run it from the terminal in this directory (_helper_scritps)
# so that it creates calendar.html in the correct dir.
# Then make a couple minor adjustments to the generated file
# if needed. For example, a month starting on a Monday, will
# omit that day (or any day or more without a show.) See
# https://github.com/happycollision/jekyll.postplayhouse.com/commit/edffb8b4792f9959932cc315182fc24b7f4b3296
# for more details.

# This script will also generate a file called schedule.txt in
# its directory as well. That will contain a per-show list of
# calendar dates.

require 'date'
require 'pp'
require 'fileutils'

year = 2017
morning_time_arr = ["10:00am", "10am"]
matinee_time_arr = ["2:00pm", "2pm"]
evening_time_arr = ["8:00pm", "8pm"]

show1 = {
  code: "show-1",
  name: "Shrek The Musical",
  short_name: "Shrek",
  morning_dates: {
    june: [],
    july: [29],
    august: [5]
    },
  matinee_dates: {
    june: [4, 25],
    july: [12, 14, 16, 19, 26],
    august: [9, 11, 13]
    },
  evening_dates: {
    june: [2, 3, 6, 13, 21],
    july: [5, 22],
    august: []
  }
}
show2 = {
  code: "show-2",
  name: "Mamma Mia!",
  short_name: "Mamma Mia!",
  morning_dates: {
    june: [],
    july: [],
    august: []
    },
  matinee_dates: {
    june: [11],
    july: [8, 15, 29],
    august: [6]
    },
  evening_dates: {
    june: [9, 10, 14, 20, 23, 28],
    july: [4, 13, 18, 20, 26],
    august: [3, 8, 12]
  }
}
show3 = {
  code: "show-3",
  name: "Crazy For You",
  short_name: "Crazy",
  morning_dates: {
    june: [],
    july: [],
    august: []
    },
  matinee_dates: {
    june: [18],
    july: [21, 23],
    august: [5, 12]
    },
  evening_dates: {
    june: [16, 17, 22, 24, 27],
    july: [8, 12, 15, 27, 29],
    august: [2, 9]
  }
}
show4 = {
  code: "show-4",
  name: "Chicago",
  short_name: "Chicago",
  morning_dates: {
    june: [],
    july: [],
    august: []
    },
  matinee_dates: {
    june: [],
    july: [22],
    august: [2]
    },
  evening_dates: {
    june: [30],
    july: [1, 2, 11, 19, 25, 28, 30],
    august: [5, 11]
  }
}
show5 = {
  code: "show-5",
  name: "Young Frankenstein",
  short_name: "Frankenstein",
  morning_dates: {
    june: [],
    july: [],
    august: []
    },
  matinee_dates: {
    june: [],
    july: [9, 27],
    august: []
    },
  evening_dates: {
    june: [],
    july: [7, 14, 21],
    august: [1, 4, 10]
  }
}
bmr = {
  code: "",
  name: "Bald Mountain Rounders",
  short_name: "Bald Mountain Rounders",
  evening_dates: {may: []}
}

define_method :pad_inner_days do |month_name, month_hash|
  first = month_hash.first[0]
  last = month_hash.to_a.last[0]
  between_count = last - first - 1

  if between_count > 0
    between_count.times do |i|
      month_hash[first + i + 1] = {} if month_hash[first + i + 1] == nil
    end
  end

  return month_hash.sort.to_h
end

def create_calendar_hash(show_array)
  calendar = {}
  show_array.each do |production|
    production.each do |property, value|
      unless [:name, :short_name, :code].include? property
        # Property is now a dates category
        value.each do |month_name, dates|
          dates.each do |date|
            calendar[month_name] = {} if calendar[month_name] == nil
            calendar[month_name][date] = {} if calendar[month_name][date] == nil
            if property == :morning_dates
              calendar[month_name][date][:morning] = production
            elsif property == :matinee_dates
              calendar[month_name][date][:afternoon] = production
            elsif property == :evening_dates
              calendar[month_name][date][:evening] = production
            end
          end
        end
      end
    end
  end
  calendar.each do |month,dates|
    calendar[month] = calendar[month].sort.to_h
    calendar[month] = pad_inner_days month.to_s, calendar[month]
  end

  #since may, june, july, august *happen* to be reverse alphabetical
  return calendar.sort.reverse.to_h 
end

define_method :showing do |production, day_part|
  return "" if production == nil
  times = case day_part
    when "morning"
      morning_time_arr
    when "matinee"
      matinee_time_arr
    when "evening"
      evening_time_arr
  end
  html = "
      <div class=\"showing #{day_part} #{production[:code]}\">"
  html += "
        <div class=\"show-title\">
          <span class=\"full\">#{production[:name]}</span>
          <span class=\"short\">#{production[:short_name]}</span>
        </div>
        <div class=\"show-time\">
          <span class=\"full\">#{times[0]}</span>
          <span class=\"short\">#{times[1]}</span>
        </div>
      </div><!-- showing -->"
  return html
end

define_method :create_html_calendar do
  show_array = [bmr,show1,show2,show3,show4,show5]
  puts PP.pp create_calendar_hash(show_array)
  calendar = create_calendar_hash(show_array)
  calendar_html = "<div class=\"calendar\">"
  calendar.each do |month, dates|
    month_num = {may: 5, june: 6, july: 7, august: 8}[month]
    pad_days = Date.new(year, month_num, dates.first[0]).wday

    calendar_html += "
<h3 class=\"month-name\">#{month.to_s.capitalize}</h3><table class=\"month\" cellpadding=\"0\" cellspacing=\"0\"><tbody>"
    
    if pad_days > 0
      calendar_html += "<tr class=\"week\">"
      pad_days.times do |i|
        calendar_html += "
  <td class=\"day padding\" valign=\"top\">"
        calendar_html += "
    <span class=\"day-name\">
      <span class=\"full\">#{Date::DAYNAMES[i]}</span>
      <span class=\"short\">#{Date::ABBR_DAYNAMES[i]}</span>
    </span>
  </td>"
      end
    end

    dates.each do |date, events|
      cal_date = Date.new(year, month_num, date)
      
      calendar_html += "
<tr class=\"week\">" if cal_date.sunday?

      if events.empty?
        calendar_html += "
  <td class=\"day dark\" valign=\"top\">"
      else
        calendar_html += "
  <td class=\"day\" valign=\"top\">"
      end
    
      calendar_html += "
    <span class=\"day-name\">
      <span class=\"full\">#{Date::DAYNAMES[cal_date.wday]}</span>
      <span class=\"short\">#{Date::ABBR_DAYNAMES[cal_date.wday]}</span>
    </span>"
      calendar_html += "
    <span class=\"month-name\">#{month.to_s.capitalize}</span>
    <span class=\"mday\">#{cal_date.mday}</span>"
      if events.empty?
        calendar_html += "
    <div class=\"day-content show-count-0\"> &nbsp; </div><!--day_content-->"
      else
        calendar_html += "
    <div class=\"day-content show-count-#{events.count}\">"
        if events.count == 1 && events[:evening] != nil
          calendar_html += "
      <div class=\"spacer\"></div>"
        end
        calendar_html += showing events[:morning], "morning"
        calendar_html += showing events[:afternoon], "matinee"
        calendar_html += showing events[:evening], "evening"
        calendar_html += "
    </div><!--day_content-->"
      end
      calendar_html += "
  </td>"
      calendar_html += "
</tr><!-- week -->" if cal_date.saturday?
    end
    calendar_html += "
</tbody></table>\n\n"
  end
  calendar_html += "
</div>"
  return calendar_html
end

open '../_includes/calendar.html', 'w' do |f|
  f.puts "<div class=\"calendar-filters\">\n"

  [show1,show2,show3,show4,show5].each do |s|
    f.puts "\
  <div class=\"filter selected #{s[:code]}\">
    #{s[:name]}
  </div>"

  end
  f.puts "</div>\n\n"

  f.puts create_html_calendar()
end

open 'schedule.txt', 'w' do |f|
  f.puts "Post Playhouse #{year}\n\n\n"

  f.puts "By Production:"
  f.puts "==============\n\n"
  f.puts "Showtimes are 8pm unless otherwise noted:"
  f.puts "  * = #{matinee_time_arr[1]}  ‡ = #{morning_time_arr[1]}"
  f.puts "\n"

  [show1,show2,show3,show4,show5].each do |s|
    calendar = create_calendar_hash([s])
    f.puts "#{s[:name]}\n"

    calendar.each do |month, dates|
      date_str_arr = []
      dates.each do |date, perf_types|
        next if perf_types.empty?
        date_str_arr << case perf_types.first[0]
          when :evening
            "#{date}"
          when :morning
            "#{date}‡"
          when :afternoon
            "#{date}*"
          else
            f.puts "error: #{perf_types}"
        end
      end
      f.puts "#{month.to_s.capitalize} #{date_str_arr.join(", ")}"
      
    end
    f.puts "\n\n"
  end
  
  f.puts "By Dates:"
  f.puts "=========\n\n"
  
  calendar = create_calendar_hash([show1,show2,show3,show4,show5])
  calendar.each do |month, dates|
    dates.each do |date, perf_types|
      next if perf_types.empty?
      f.puts "#{month.to_s.capitalize} #{date}"
      perf_types.each do |day_part, show_obj|
        f.puts case day_part
          when :morning
            "  #{morning_time_arr[1]}  #{show_obj[:name]}"
          when :afternoon
            "  #{matinee_time_arr[1]}   #{show_obj[:name]}"
          when :evening
            "  #{evening_time_arr[1]}   #{show_obj[:name]}"
          else
            "error: #{day_part.to_s}: #{show_obj}"
        end
      end
      f.puts ""
    end
  end
end

# <tr class="week">
#   <td class="day dark\padding\{nothing}" valign="top">
#     <span class="day-name">
#       <span class="full">Tuesday</span>
#       <span class="short">Tue</span>
#     </span>
#     <span class="month-name">May</span>
#     <span class="mday">12</span>
#     <div class="day-content show-count-0"> &nbsp; </div><!--day_content-->
#     OR------------------------------------
#     <div class="day-content show-count-2">
#       <div class="showing matinee show-1">
#         <div class="show-title">
#           <span class="full">The Best Little Whorehouse in Texas</span>
#           <span class="short">Texas</span>
#         </div>
#         <div class="show-time">
#           <span class="full">2:00pm</span>
#           <span class="short">2pm</span>
#         </div>
#       </div><!--showing-->
#       <div class="showing evening show-3">
#         <div class="show-title">
#           <span class="full">Cinderella</span>
#           <span class="short">Cinderella</span>
#         </div>
#         <div class="show-time">
#           <span class="full">8:00pm</span>
#           <span class="short">8p</span>
#         </div>
#       </div><!--showing-->
#     </div><!--day_content-->
#   </td><!--day-->
# </tr>
