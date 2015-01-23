---
---

{% include_relative _js/main-nav.js %}
{% include bower_components/respondr/dist/jquery.respondr.min.js %}

$.respondr({
  apiKey: 'c2dfff46955d313d86bcd1a051f57af7',
  usePicturefill: true
})

$('.page-content').respondr();