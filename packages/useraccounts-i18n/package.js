Package.describe({
  summary: "i18n, with standard translations for basic meteor packages.",
  version: '1.14.2_7',
  name: "steedos:accounts-t9n",
  git: "https://github.com/steedos/useraccounts-i18n.git",
  documentation: null
});


Package.onUse(function(api) { 
        api.use('coffeescript@1.11.1_4');
        api.use('tap:i18n@1.8.2', ['client', 'server']);

        tapi18nFiles = [
                'i18n/en.i18n.json', 
                'i18n/zh-CN.i18n.json'
        ]

        api.addFiles(tapi18nFiles);

        api.addFiles('core.coffee');
});