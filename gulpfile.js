var gulp = require('gulp');
var rs = require('run-sequence');
var loadPlugins = require('gulp-load-plugins');
var $ = loadPlugins({lazy: true});
var del = require('del');

// requires sharp, which has specific OSX install instructions: https://github.com/lovell/sharp
gulp.task('newer-image-sizes-to-temp', function() {
  return gulp.src('_original-images/**/*')
    .pipe($.newer('images'))
    .pipe($.responsive({
      'people/**/*': [{
        width: 300,
        rename: {
          suffix: '_300',
        }
      // }, {
      //   width: 100,
      //   rename: {
      //     suffix: '_100',
      //   }
      // }, {
      //   width: 600,
      //   rename: {
      //     suffix: '_600',
      //   }
      // }, {
      //   width: 900,
      //   rename: {
      //     suffix: '_900',
      //   }
      }],
    }, {
      // Global configuration for all images
      // The output quality for JPEG, WebP and TIFF output formats
      // Since we will be compressing later, keep it high
      quality: 100,
      errorOnEnlargement: false,
      errorOnUnusedConfig: false,
      errorOnUnusedImage: false
    }))
    .pipe(gulp.dest('.tmp/images'));
});

gulp.task('copy-newer-images-to-temp', function(){
  return gulp.src('_original-images/**/*')
    .pipe($.newer('images'))
    .pipe(gulp.dest('.tmp/images'))
});

gulp.task('optimize-temp-images', function(){
  return gulp.src('.tmp/images/**/*')
    .pipe($.imageoptim.optimize({jpegmini: true}))
    .pipe(gulp.dest('images'))
});

gulp.task('clean', function(){
  return del('.tmp');
});

gulp.task('default', function(){
  rs(
    'clean',
    [
      'copy-newer-images-to-temp',
      'newer-image-sizes-to-temp'
    ],
    'optimize-temp-images',
    'clean'
  );
});