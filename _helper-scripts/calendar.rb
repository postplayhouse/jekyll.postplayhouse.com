# Sloppy script to (mostly) generate a calendar
# run it from the terminal in its own directory (so the accomapnying file is created next to it)
# copy paste into the actual calendar page and make a couple minor adjustments

require 'date'
require 'pp'
require 'fileutils'

year = 2016
show1 = {
  code: "show-1",
  name: "Disney's Beauty and the Beast",
  short_name: "Beauty/Beast",
  morning_dates: {
    june: [],
    july: [30],
    august: [6]
    },
  matinee_dates: {
    june: [5, 26],
    july: [24, 27],
    august: [3, 10, 14]
    },
  evening_dates: {
    june: [3,4,7,14,22],
    july: [6,15,21],
    august: [12]
  }
}
show2 = {
  code: "show-2",
  name: "The Addams Family",
  short_name: "Addams",
  morning_dates: {
    june: [],
    july: [],
    august: []
    },
  matinee_dates: {
    june: [12],
    july: [15,17,30],
    august: [6,13]
    },
  evening_dates: {
    june: [10,11,15,21,24,29],
    july: [5,22,28],
    august: []
  }
}
show3 = {
  code: "show-3",
  name: "Legally Blonde",
  short_name: "Blonde",
  morning_dates: {
    june: [],
    july: [],
    august: []
    },
  matinee_dates: {
    june: [19],
    july: [23,31],
    august: [12]
    },
  evening_dates: {
    june: [17,18,23,25,28],
    july: [9,13,16,20],
    august: [2,5]
  }
}
show4 = {
  code: "show-4",
  name: "Cabaret",
  short_name: "Cabaret",
  morning_dates: {
    june: [],
    july: [],
    august: []
    },
  matinee_dates: {
    june: [],
    july: [3,9,13,16,20,22],
    august: [7]
    },
  evening_dates: {
    june: [],
    july: [1,2,26,30],
    august: [4,10,13]
  }
}
show5 = {
  code: "show-5",
  name: "Monty Python's Spamalot",
  short_name: "Spamalot",
  morning_dates: {
    june: [],
    july: [],
    august: []
    },
  matinee_dates: {
    june: [],
    july: [10],
    august: []
    },
  evening_dates: {
    june: [],
    july: [8,12,14,19,23,27,29],
    august: [3,6,9,11]
  }
}
bmr = {
  code: "",
  name: "Bald Mountain Rounders",
  short_name: "Bald Mountain Rounders",
  evening_dates: {may: [28]}
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

define_method :create_calendar_hash do
  calendar = {}
  [bmr,show1,show2,show3,show4,show5].each do |production|
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
      ["10:00am", "10am"]
    when "matinee"
      ["2:00pm", "2pm"]
    when "evening"
      ["8:00pm", "8pm"]
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
  puts PP.pp create_calendar_hash()
  calendar = create_calendar_hash()
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
    </span></td>"
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

open 'calendar_html.html', 'w' do |f|
  f.puts "<html><head><link rel=\"stylesheet\" href=\"../_site/css/main.css?v=1\"></head><body>"
  f.puts create_html_calendar()
  f.puts "</body></html>"
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
