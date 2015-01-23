$('.site-nav').on('click', function(){
  if ($(this).find(':checked').length === 0 && $(this).find('label').css('display') !== 'none' ) {
    $(this).find('ul').css('display','none');
  } else {
    $(this).find('ul').css('display','block');
  }
});