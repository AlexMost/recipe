gulp = require 'gulp'
gutil = require 'gulp-util'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'

SRC_PATH = './src/**/*.coffee'

gulp.task 'default', ->
    gulp.src(SRC_PATH)
        .pipe(coffeelint())
        .pipe(coffeelint.reporter())
        .pipe(coffee({bare: true}).on('error', gutil.log))
        .pipe(gulp.dest('./lib'))

gulp.task 'watch', ->
    gulp.watch(SRC_PATH, ['default'])