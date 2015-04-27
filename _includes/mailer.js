$('body').append($('#mailer'));

$('a[name="mailer"]').on('click', function (e){
  e.preventDefault();
  $('body').addClass('mailer-open');
});

$('#mailer').on('click', function (e){
  if (e.target === this || e.target.className === 'close') {
    $('body').removeClass('mailer-open');
  }
});
