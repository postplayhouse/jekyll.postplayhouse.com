(function() {
  function getBasePath(path) {
    return path.split('/').slice(0, -1).join('/') + '/';
  }

  function replaceImageWith(el, url) {
    $(el).fadeTo(500, 0.01, function () {
      el.src = url;
      el.onload = function () {
        $(el).fadeTo(500, 1);
      }
    });
  }

  function getNextImage(current, urls) {
    var wrappedList = urls.concat(urls[0]);
    var currentIndex = wrappedList.indexOf(current);
    return wrappedList[currentIndex + 1];
  }

  function rotateImages(el, urls) {
    setTimeout(function() {
      var src = getNextImage(el.src, urls)
      replaceImageWith(el, src)
      rotateImages(el, urls);
    }, randomIntFromInterval(4000, 6000))
  }

  function prepareUrls(baseUrl, fileNames) {
    return fileNames.map(function (name) { return baseUrl + name; })
  }

  function randomIntFromInterval(min, max) {
    return Math.floor(Math.random()*(max-min+1)+min);
  }

  window.initSwitchImage = function (el) {
    var list = $(el).data('switch-image-list').replace(/\n\s+/g, '').split(',')
      .filter(function(v) { return v !== '' });
    var urls = prepareUrls(getBasePath(el.src), list);
    rotateImages(el, urls);
  };
})()
