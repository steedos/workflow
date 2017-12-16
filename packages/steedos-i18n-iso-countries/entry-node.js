import library from './index';

import en from './langs/en.json';
import zh from './langs/zh.json';


var locales = [en,zh];

for (var i = 0; i < locales.length; i++) {
  library.registerLocale(locales[i]);
}

module.exports = library;
