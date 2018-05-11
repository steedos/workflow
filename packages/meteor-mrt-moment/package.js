// package metadata file for Meteor.js
'use strict';

Package.describe({
  name: "steedos:moment",
  summary: 'disable mrt:moment package for conflict with nw.js',
  version: "2.14.1",
  documentation: null,
  git: ''
});

Package.onUse(function (api) {
  api.versionsFrom(['METEOR@0.9.0', 'METEOR@1.0', 'METEOR@1.2']);
  //api.export('moment');
  //api.addFiles('moment.js');
  //api.addFiles('export.js');
});