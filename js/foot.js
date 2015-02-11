---
---

{% include_relative _js/main-nav.js %}
{% include bower_components/respondr/dist/jquery.respondr.min.js %}
{% include bower_components/fitvids/jquery.fitvids.js %}

$(document).ready(function(){
  $.respondr({
    apiKey: 'c2dfff46955d313d86bcd1a051f57af7',
    usePicturefill: true
  })
  $('.page-content').respondr();

  $('.video').fitVids();
  
  {% include_relative _js/sticky-titles.js %}
  
  if ($('.calendar').length > 0) {
    {% include_relative _js/calendar.js %}
  }
});

//Google Analytics
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-58996807-1', 'auto');
ga('send', 'pageview');

