import registerLocale from './index';

import en from './langs/en.js';
import zh from './langs/zh.js';


var locales = [en,zh];

for (var i = 0; i < locales.length; i++) {
  registerLocale(locales[i]);
}

