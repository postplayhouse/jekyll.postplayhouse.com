(function($) {
  $(window).load(function() {
    cal_width = $("div.calendar").width();
    var calSizer = function() {
      if ($(document).width() < 575) {
        $("div.calendar td.day").attr("style", "");
      } else {
        monday_width = cal_width / 7 - 50;
        other_days_width = (cal_width - monday_width) / 6;
        $("div.calendar td.day.monday").width(monday_width + "px");
        $("div.calendar td.day").not(".monday").width(other_days_width + "px");
      }
    };
    calSizer();
    $(window).on("resize", calSizer);
  });
})(jQuery);
