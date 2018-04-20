$('.site-nav [for="menu"]').on('click', function(){
  if ($(this.parentNode).find(':checked').length === 0 ) {
    $(this.parentNode).find('ul').addClass('unhide');
  } else {
    $(this.parentNode).find('ul').removeClass('unhide');
  }
});
