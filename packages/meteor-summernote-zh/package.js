// package metadata file for Meteor.js
'use strict';

var packageName = 'summernote:summernote';  // http://atmospherejs.com/summernote:standalone
var where = 'client';  // where to install: 'client' or 'server'. For both, pass nothing.

//var packageJson = JSON.parse(Npm.require("fs").readFileSync('package.json'));

Package.describe({
  name: packageName,
  summary: 'summernote (official): jQuery+Bootstrap WYSIWYG editor with embedded images support',
  version: "0.8.2",
  git: 'https://github.com/summernote/summernote.git'
});

Package.onUse(function (api) {
  api.versionsFrom(['METEOR@0.9.0', 'METEOR@1.0']);
  
  // api.use([
  //   'jquery',
  //   'twbs:bootstrap@3.3.7'
  // ], where);

  // no exports - summernote adds itself to jQuery
  api.addFiles([
    'dist/summernote.js',
    'dist/summernote.css'
  ], where);

  api.addFiles([
    'dist/lang/summernote-zh-CN.js',
    'dist/lang/summernote-zh-TW.js'
  ], where);
  
  api.addAssets([
    'dist/font/summernote.eot',
    'dist/font/summernote.ttf',
    'dist/font/summernote.woff'
  ], where);
});

Package.onTest(function (api) {
  // load dependencies for test only, before loading the package
  api.use(['twbs:bootstrap@3.3.1'], where);

  // load our package
  api.use(packageName, where);

  // load the test runner
  api.use('tinytest', where);

  api.addFiles('meteor/test.js', where);
});
