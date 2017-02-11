Package.describe({
  name: 'steedos:webui-popover',
  summary: 'jQuery WebUI Popover plugin for MeteorJS.',
  version: '1.2.18',
  git: 'https://github.com/sandywalker/webui-popover'
});

Package.onUse(function(api) {

  api.use('flemay:less-autoprefixer@1.2.0');
  api.use('jquery@1.9.1', 'client');

  api.addFiles([
    'src/jquery.webui-popover.js',
    'src/jquery.webui-popover.less'
  ], 'client');

  api.addFiles([
    'src/img/loading.gif'
  ], 'client', {isAsset: true});

});
