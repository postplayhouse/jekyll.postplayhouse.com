// Based on:
// http://codepen.io/ipelekhan/pen/Gebnf

var updateHeaders;

updateHeaders = function() {
  return $('.bio-group').each(function() {
    var el, floatingHeader, offset, scrollTop;
    el = $(this);
    offset = el.offset();
    scrollTop = $(window).scrollTop();
    floatingHeader = $('.floating-header', this);
    if ((scrollTop > offset.top) && (scrollTop < offset.top + el.height() - floatingHeader.height())) {
      floatingHeader.css('visibility', 'visible');
      floatingHeader.css('position', 'fixed');
      return floatingHeader.css('top', '0px');
    } else if (scrollTop < offset.top) {
      return floatingHeader.css('visibility', 'hidden');
    } else {
      floatingHeader.css('position', 'absolute');
      return floatingHeader.css('top', el.height() - floatingHeader.outerHeight() + 'px');
    }
  });
};

$(function() {
  $('.bio-group').each(function(i) {
    var clonedHeader, thisHeader;
    thisHeader = $('.bio-group-label', this);
    clonedHeader = thisHeader.clone();
    thisHeader.before(clonedHeader);
    clonedHeader.addClass('floating-header');
    clonedHeader.css('position', 'fixed');
    //clonedHeader.css('width', thisHeader.width());
    clonedHeader.css('width', '100%');
    clonedHeader.css('top', '0px');
    return clonedHeader.css('visibility', 'hidden');
  });
  updateHeaders();
  return $(window).scroll(updateHeaders);
});