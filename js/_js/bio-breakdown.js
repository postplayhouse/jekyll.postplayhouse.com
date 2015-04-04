var $bioGroups = $('.bio-group');
var labels = [];
var $switcher = $('<nav class="switcher"></nav>');

$.each( $bioGroups, function(){
  var $thisGroup = $(this);
  var label = $(this).find('.bio-group-label').html();
  var $switchLink = $('<a>'+label+'</a>');
  labels.push(label);
  $(this).hide();

  $switchLink.bind('click', function(){
    $switcher.find('a').removeClass('active');
    $switchLink.addClass('active');
    $bioGroups.hide();
    $thisGroup.show();
  });

  $switcher.append($switchLink);
});

$('.bios-page').prepend($switcher);
$switcher.find('a:first').click();
