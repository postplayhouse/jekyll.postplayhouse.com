(function() {
  var transitioningEls = [];
  var callbacks = [];
  function deregisterEl(el) {
    transitioningEls = transitioningEls.filter(function(someEl) {
      return someEl !== el;
    })
    if (transitioningEls.length === 0) {
      doCallbacks();
    }
  }
  function registerEl(el) {
    transitioningEls.push(el);
  }
  function registerCallback(cb) {
    callbacks.push(cb);
  }
  function doCallbacks() {
    callbacks.forEach(function(cb) {cb();})
    callbacks = [];
  }

  function getBasePath(path) {
    return path.split('/').slice(0, -1).join('/') + '/';
  }

  function replaceImageWith(el, url, cb) {
    preload(url, function () {
      $(el).fadeTo(500, 0.01, function () {
        el.src = url;
        el.onload = function () {
          $(el).fadeTo(500, 1);
          if (cb) cb();
        }
      });
    })    
  }

  function preload(url, cb) {
    var tempEl = new Image();
    tempEl.onload = cb;
    tempEl.src = url;
  }

  function shuffleArray(array) {
    for (var i = array.length - 1; i > 0; i--) {
        var j = Math.floor(Math.random() * (i + 1));
        var temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
  }

  function getNextImage(current, urls) {
    var wrappedList = urls.concat(urls[0]);
    var currentIndex = wrappedList.indexOf(current);
    return wrappedList[currentIndex + 1];
  }

  // function rotateImages(el, urls) {
  //   setTimeout(function() {
  //     var src = getNextImage(el.src, urls)
  //     replaceImageWith(el, src)
  //     rotateImages(el, urls);
  //   }, randomIntFromInterval(6000, 10000))
  // }

  function rotateAllImagesTogether(el, urls) {
    setTimeout(function() {
      registerEl(el);
      var cb = function () {rotateAllImagesTogether(el, urls);}
      registerCallback(cb);
      var afterTransition = function () { deregisterEl(el); }
      var src = getNextImage(el.src, urls)
      replaceImageWith(el, src, afterTransition)
    }, 8000)
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
    shuffleArray(list)
    var urls = prepareUrls(getBasePath(el.src), list);
    rotateAllImagesTogether(el, urls);
  };
})()
