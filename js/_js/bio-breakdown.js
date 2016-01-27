var $bioGroups = $('.bio-group');
var labels = [];
var $switcher = $('<nav class="switcher"></nav>');
var location = window.location;
console.log(location.hash.split('#')[1]);

$.each( $bioGroups, function(){
  var $thisGroup = $(this);
  var label = $(this).find('.bio-group-label').html();
  var $switchLink = $('<a class="group-name-' + label.toLowerCase() + '">'+label+'</a>');
  labels.push(label);
  $(this).hide();

  $switchLink.bind('click', function(){
    $switcher.find('a').removeClass('active');
    $switchLink.addClass('active');
    $bioGroups.hide();
    $thisGroup.show();
    window.location.replace('#' + label.toLowerCase());
  });

  $switcher.append($switchLink);
});

$('.bios-page').prepend($switcher);

if (location.hash != ""){
  var groupName = location.hash.split('#')[1].toLowerCase();
  var $groupButton = $switcher.find('a.group-name-' + groupName);
  if ($groupButton.length > 0){
    $groupButton.click();
  } else {
    $switcher.find('a:first').click();
  }
} else {
  $switcher.find('a:first').click();
}
