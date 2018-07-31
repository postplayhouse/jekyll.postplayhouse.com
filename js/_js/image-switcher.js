(function() {
  function getBasePath(path) {
    return path.split('/').slice(0, -1).join('/') + '/';
  }

  function replaceImageWith(el, url) {
    el.src = url;
  }

  function getNextImage(current, urls) {
    var wrappedList = urls.concat(urls[0]);
    var currentIndex = wrappedList.indexOf(current);
    return wrappedList[currentIndex + 1];
  }

  function rotateImages(el, urls) {
    setInterval(function() {
      var src = getNextImage(el.src, urls)
      replaceImageWith(el, src)
    }, 4000)
  }

  function prepareUrls(baseUrl, fileNames) {
    return fileNames.map(function (name) { return baseUrl + name; })
  }

  window.initSwitchImage = function (el) {
    var list = $(el).data('switch-image-list').replace(/\n\s+/g, '').split(',')
      .filter(function(v) { return v !== '' });
    var urls = prepareUrls(getBasePath(el.src), list);
    rotateImages(el, urls);
  };
})()
